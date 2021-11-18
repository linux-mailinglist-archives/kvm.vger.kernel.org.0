Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5374456154
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 18:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234064AbhKRRWR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 12:22:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:47422 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234053AbhKRRWQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Nov 2021 12:22:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637255955;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KxAXZ/t9scV/wZoc1s0LazT7bOUXTrnD9v2ZC7dqEPQ=;
        b=O57iA8xtQxDMdDXfFuyIAhGZ8Wf3Fdn8E6Y6rEm7nMxVePo2vPhOak1vQEwpO6LbbiFukQ
        fE79iQu1dkm8ZAYtEbs15QMTAf9N82m+VgtJCMy712dvCjlamrZyQMn3u4C7pMm1NjEovL
        MPZIkx8lD7RkJ/n1G6nIBnBa6Rnp+eA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-153-CSIzPzJwNbir83palKBQWQ-1; Thu, 18 Nov 2021 12:19:13 -0500
X-MC-Unique: CSIzPzJwNbir83palKBQWQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 829CB8005A2;
        Thu, 18 Nov 2021 17:19:09 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 702C167855;
        Thu, 18 Nov 2021 17:19:06 +0000 (UTC)
Message-ID: <db8a2431-8a05-bd50-dd79-74c814c71edd@redhat.com>
Date:   Thu, 18 Nov 2021 18:19:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [RFC 11/19] KVM: x86/mmu: Factor shadow_zero_check out of
 make_spte
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        David Hildenbrand <david@redhat.com>
References: <20211110223010.1392399-1-bgardon@google.com>
 <20211110223010.1392399-12-bgardon@google.com> <YZW02M0+YzAzBF/w@google.com>
 <YZXIqAHftH4d+B9Y@google.com> <YZaBSf+bPc69WR1R@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YZaBSf+bPc69WR1R@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/18/21 17:37, Sean Christopherson wrote:
>> It's a bit ugly in that we'd pass both @kvm and @vcpu, so that needs some more
>> thought, but at minimum it means there's no need to recalc the reserved bits.
>
> Ok, I think my final vote is to have the reserved bits passed in, but with the
> non-nested TDP reserved bits being computed at MMU init.

Yes, and that's also where I was getting with the idea of moving part of 
the "direct" MMU (man, naming these things is so hard) to struct kvm: 
split the per-vCPU state from the constant one and initialize the latter 
just once.  Though perhaps I was putting the cart slightly before the horse.

On the topic of naming, we have a lot of things to name:

- the two MMU codebases: you Googlers are trying to grandfather "legacy" 
and "TDP" into upstream, but that's not a great name because the former 
is used also when shadowing EPT/NPT.  I'm thinking of standardizing on 
"shadow" and "TDP" (it's not perfect because of the 32-bit and tdp_mmu=0 
cases, but it's a start).  Maybe even split parts of mmu.c out into 
shadow_mmu.c.

- the two walkers (I'm quite convinced of splitting that part out of 
struct kvm_mmu and getting rid of walk_mmu/nested_mmu): that's easy, it 
can be walk01 and walk12 with "walk" pointing to one of them

- the two MMUs: with nested_mmu gone, root_mmu and guest_mmu are much 
less confusing and we can keep those names.

Paolo

