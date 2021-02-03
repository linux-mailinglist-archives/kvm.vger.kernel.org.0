Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E00930DBF8
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 14:56:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232065AbhBCN4B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 08:56:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55418 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231721AbhBCNzl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Feb 2021 08:55:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612360454;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=px52d5AvHJ49VuQLZY1SD+L1Jaeps3GqOjk9GodXnr4=;
        b=U8ubk0qUHE97GAupBMa+QIV48QUoU+wxxmwFNfKHYqtVdzop7Ato4AGZCS3+WC/kuNJvYL
        D3U9qMf8J14gFEMGABy2iLpx5wWayZvyCp97D4vfS3j6d2cApwXQYZod1tzHYj0jrAZH6L
        LpbNBuNdAk7lyMY1pcLmL8lPozsqd3A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-231-s_XPbuV3NQCubAgtjZxbDg-1; Wed, 03 Feb 2021 08:52:50 -0500
X-MC-Unique: s_XPbuV3NQCubAgtjZxbDg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9DF0180196F;
        Wed,  3 Feb 2021 13:52:47 +0000 (UTC)
Received: from [10.36.112.222] (ovpn-112-222.ams2.redhat.com [10.36.112.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 922C519C59;
        Wed,  3 Feb 2021 13:52:43 +0000 (UTC)
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
 <5efd931f-9d69-2936-89e8-278fe106616d@redhat.com>
 <307603f3-52a8-7464-ba98-06cbe4ddd408@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Subject: Re: [PATCH 2/2] KVM: Scalable memslots implementation
Message-ID: <b9aacf06-de2b-b831-6210-25191dd1b0ac@redhat.com>
Date:   Wed, 3 Feb 2021 14:52:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <307603f3-52a8-7464-ba98-06cbe4ddd408@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03.02.21 14:46, Paolo Bonzini wrote:
> On 03/02/21 14:44, David Hildenbrand wrote:
>> BTW: what are your thoughts regarding converting the rmap array on
>> x86-64 into some dynamic datastructre (xarray etc)? Has that already
>> been discussed?
> 
> Hasn't been discussed---as always, showing the code would be the best
> way to start a discussion. :)

If only a workday would have more hours :)

> 
> However, note that the TDP MMU does not need an rmap at all.  Since that
> one is getting ready to become the default, the benefits of working on
> the rmap would be quite small and only affect nested virtualization.

Right, but we currently always have to allocate it.

8 bytes per 4k page, 8 bytes per 2M page, 8 bytes per 1G page.

The 4k part alone is 0.2% of the memblock size.

For a 1 TB memslot we might "waste" > 2 GB on rmap arrays.

(that's why I am asking :) )

-- 
Thanks,

David / dhildenb

