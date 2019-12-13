Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D90811EACE
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2019 20:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728864AbfLMS7g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Dec 2019 13:59:36 -0500
Received: from foss.arm.com ([217.140.110.172]:42230 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728591AbfLMS7g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Dec 2019 13:59:36 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C33DE106F;
        Fri, 13 Dec 2019 10:59:35 -0800 (PST)
Received: from [10.1.197.1] (ewhatever.cambridge.arm.com [10.1.197.1])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AD07C3F718;
        Fri, 13 Dec 2019 10:59:33 -0800 (PST)
Subject: Re: [PATCH 1/7] KVM: Pass mmu_notifier_range down to
 kvm_unmap_hva_range()
To:     Marc Zyngier <maz@kernel.org>
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org
References: <20191213182503.14460-1-maz@kernel.org>
 <20191213182503.14460-2-maz@kernel.org>
From:   Suzuki Kuruppassery Poulose <suzuki.poulose@arm.com>
Message-ID: <c347df67-6cc3-9d5c-0dd9-72ebb8fa9712@arm.com>
Date:   Fri, 13 Dec 2019 18:59:32 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191213182503.14460-2-maz@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,


On 13/12/2019 18:24, Marc Zyngier wrote:
> kvm_unmap_hva_range() is currently passed both start and end
> fields from the mmu_notifier_range structure. As this struct
> now contains important information about the reason of the
> unmap (the event field), replace the start/end parameters
> with the range struct, and update all architectures.
> 
> No functionnal change.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>


> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 00268290dcbd..7c3665ad1035 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -158,7 +158,7 @@ static unsigned long long kvm_createvm_count;
>   static unsigned long long kvm_active_vms;
>   
>   __weak int kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
> -		unsigned long start, unsigned long end, bool blockable)
> +		const struct mmu_notifier_range *range, bool blockable)
>   {
>   	return 0;
>   }
> @@ -415,7 +415,7 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
>   	 * count is also read inside the mmu_lock critical section.
>   	 */
>   	kvm->mmu_notifier_count++;
> -	need_tlb_flush = kvm_unmap_hva_range(kvm, range->start, range->end);
> +	need_tlb_flush = kvm_unmap_hva_range(kvm, range);
>   	need_tlb_flush |= kvm->tlbs_dirty;
>   	/* we've to flush the tlb before the pages can be freed */
>   	if (need_tlb_flush)
> @@ -423,8 +423,7 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
>   
>   	spin_unlock(&kvm->mmu_lock);
>   
> -	ret = kvm_arch_mmu_notifier_invalidate_range(kvm, range->start,
> -					range->end,
> +	ret = kvm_arch_mmu_notifier_invalidate_range(kvm, range,
>   					mmu_notifier_range_blockable(range));

minor nit:

Since we now have the range passed on to the arch hooks, we could get
rid of the "blockable" too, as it is something you can deduce from the
range.

Otherwise looks good to me.

Suzuki
