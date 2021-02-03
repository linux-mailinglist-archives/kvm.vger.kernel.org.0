Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8608B30DB9C
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 14:46:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231781AbhBCNqE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 08:46:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24376 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232076AbhBCNp7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Feb 2021 08:45:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612359873;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Cs3iOsJ+hW89JAhUT2y2LCELNvPWgVKRoTFjIBJXhX8=;
        b=ETLUnUfBRv+4vXFulo5VmH9ds0iGcr0UZKYeF7B/VM1ZdSlaYzKpBzcQFb883OHfm4MlHV
        7hU9WCO5TtZSq3FNtwWjnzBy7NxsNymi+L/Px0mXj/WM/fgD2asj597tVHgRP0+6aLM+x3
        uTVXvIeMVl9F63Ntu3nhCOE0s6QSJ8Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-213-NLGdFd9jMBqdF1Mp1n08mQ-1; Wed, 03 Feb 2021 08:44:31 -0500
X-MC-Unique: NLGdFd9jMBqdF1Mp1n08mQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C9FF9107ACE3;
        Wed,  3 Feb 2021 13:44:25 +0000 (UTC)
Received: from [10.36.112.222] (ovpn-112-222.ams2.redhat.com [10.36.112.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 380F45D9E3;
        Wed,  3 Feb 2021 13:44:21 +0000 (UTC)
Subject: Re: [PATCH 2/2] KVM: Scalable memslots implementation
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <ceb96527b6f7bb662eec813f05b897a551ebd0b2.1612140117.git.maciej.szmigiero@oracle.com>
 <4d748e0fd50bac68ece6952129aed319502b6853.1612140117.git.maciej.szmigiero@oracle.com>
 <YBisBkSYPoaOM42F@google.com>
 <9e6ca093-35c3-7cca-443b-9f635df4891d@maciej.szmigiero.name>
 <4bdcb44c-c35d-45b2-c0c1-e857e0fd383e@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <5efd931f-9d69-2936-89e8-278fe106616d@redhat.com>
Date:   Wed, 3 Feb 2021 14:44:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <4bdcb44c-c35d-45b2-c0c1-e857e0fd383e@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>> The new implementation also uses standard kernel {rb,interval}-tree
>> and hash table implementation as its basic data structures, so it
>> automatically benefits from any generic improvements to these.
>>
>> All for the low price of just 174 net lines of code added.
> 
> I think the best thing to do here is to provide a patch series that
> splits the individual changes so that they can be reviewed and their
> separate merits evaluated.
> 
> Another thing that I dislike about KVM_SET_USER_MEMORY_REGION is that
> IMO userspace should provide all memslots at once, for an atomic switch
> of the whole memory array.  (Or at least I would like to see the code;
> it might be a bit tricky because you'll need code to compute the
> difference between the old and new arrays and invoke
> kvm_arch_prepare/commit_memory_region).  I'm not sure how that would
> interact with the active/inactive pair that you introduce here.
> 

+1

One issue I am aware of is resizing/splitting slots, especially due to 
arrays like rmap + dirty bitmaps.

BTW: what are your thoughts regarding converting the rmap array on 
x86-64 into some dynamic datastructre (xarray etc)? Has that already 
been discussed?

> Paolo
> 


-- 
Thanks,

David / dhildenb

