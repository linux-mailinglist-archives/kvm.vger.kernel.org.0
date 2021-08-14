Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F7583EC1BF
	for <lists+kvm@lfdr.de>; Sat, 14 Aug 2021 11:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237547AbhHNJsP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Aug 2021 05:48:15 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:50226 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232648AbhHNJsP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 14 Aug 2021 05:48:15 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=laijs@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0UiyB2fi_1628934463;
Received: from C02XQCBJJG5H.local(mailfrom:laijs@linux.alibaba.com fp:SMTPD_---0UiyB2fi_1628934463)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 14 Aug 2021 17:47:43 +0800
Subject: Re: [PATCH 1/2] KVM: X86: Check pte present first in
 __shadow_walk_next()
To:     Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
References: <20210812043630.2686-1-jiangshanlai@gmail.com>
 <YRVGY1ZK8wl9ybBH@google.com>
From:   Lai Jiangshan <laijs@linux.alibaba.com>
Message-ID: <4df6cdb1-c559-fee0-7efa-a2afa059c945@linux.alibaba.com>
Date:   Sat, 14 Aug 2021 17:47:43 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YRVGY1ZK8wl9ybBH@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2021/8/13 00:03, Sean Christopherson wrote:

> 
> And for clarity and safety, I think it would be worth adding the patch below as
> a prep patch to document and enforce that walking the non-leaf SPTEs when faulting
> in a page should never terminate early.

I'v sent V2 patch which was updated as you suggested.
The patch you provided below doesn't need to be updated. It and my V2 patch
do not depend on each other, so I didn't resent your patch with mine together.

For your patch

Acked-by: Lai Jiangshan <jiangshanlai@gmail.com>

And it can be queued earlier.

> 
> 
>  From 1c202a7e82b1931e4eb37b23aa9d7108340a6cd2 Mon Sep 17 00:00:00 2001
> From: Sean Christopherson <seanjc@google.com>
> Date: Thu, 12 Aug 2021 08:38:35 -0700
> Subject: [PATCH] KVM: x86/mmu: Verify shadow walk doesn't terminate early in
>   page faults
> 
> WARN and bail if the shadow walk for faulting in a SPTE terminates early,
> i.e. doesn't reach the expected level because the walk encountered a
> terminal SPTE.  The shadow walks for page faults are subtle in that they
> install non-leaf SPTEs (zapping leaf SPTEs if necessary!) in the loop
> body, and consume the newly created non-leaf SPTE in the loop control,
> e.g. __shadow_walk_next().  In other words, the walks guarantee that the
> walk will stop if and only if the target level is reached by installing
> non-leaf SPTEs to guarantee the walk remains valid.
> 
> Opportunistically use fault->goal-level instead of it.level in
> FNAME(fetch) to further clarify that KVM always installs the leaf SPTE at
> the target level.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/mmu/mmu.c         | 3 +++
>   arch/x86/kvm/mmu/paging_tmpl.h | 7 +++++--
>   2 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index a272ccbddfa1..2a243ae1d64c 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2992,6 +2992,9 @@ static int __direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>   			account_huge_nx_page(vcpu->kvm, sp);
>   	}
> 
> +	if (WARN_ON_ONCE(it.level != fault->goal_level))
> +		return -EFAULT;
> +
>   	ret = mmu_set_spte(vcpu, it.sptep, ACC_ALL,
>   			   fault->write, fault->goal_level, base_gfn, fault->pfn,
>   			   fault->prefault, fault->map_writable);
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index f70afecbf3a2..3a8a7b2f9979 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -749,9 +749,12 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
>   		}
>   	}
> 
> +	if (WARN_ON_ONCE(it.level != fault->goal_level))
> +		return -EFAULT;
> +
>   	ret = mmu_set_spte(vcpu, it.sptep, gw->pte_access, fault->write,
> -			   it.level, base_gfn, fault->pfn, fault->prefault,
> -			   fault->map_writable);
> +			   fault->goal_level, base_gfn, fault->pfn,
> +			   fault->prefault, fault->map_writable);
>   	if (ret == RET_PF_SPURIOUS)
>   		return ret;
> 
> --
> 2.33.0.rc1.237.g0d66db33f3-goog
> 
