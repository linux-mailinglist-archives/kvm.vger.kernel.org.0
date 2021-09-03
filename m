Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98F793FF873
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 02:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346291AbhICAw7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 20:52:59 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:46358 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345668AbhICAw6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Sep 2021 20:52:58 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=laijs@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0Un2SUqC_1630630316;
Received: from C02XQCBJJG5H.local(mailfrom:laijs@linux.alibaba.com fp:SMTPD_---0Un2SUqC_1630630316)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 03 Sep 2021 08:51:57 +0800
Subject: Re: [PATCH 2/7] KVM: X86: Synchronize the shadow pagetable before
 link it
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
        Marcelo Tosatti <mtosatti@redhat.com>,
        Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org
References: <20210824075524.3354-1-jiangshanlai@gmail.com>
 <20210824075524.3354-3-jiangshanlai@gmail.com> <YTFhCt87vzo4xDrc@google.com>
From:   Lai Jiangshan <laijs@linux.alibaba.com>
Message-ID: <e7e9201f-76cc-08de-29a7-6d75abccf968@linux.alibaba.com>
Date:   Fri, 3 Sep 2021 08:51:56 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YTFhCt87vzo4xDrc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2021/9/3 07:40, Sean Christopherson wrote:
> On Tue, Aug 24, 2021, Lai Jiangshan wrote:
>> From: Lai Jiangshan <laijs@linux.alibaba.com>
>>
>> If gpte is changed from non-present to present, the guest doesn't need
>> to flush tlb per SDM.  So the host must synchronze sp before
>> link it.  Otherwise the guest might use a wrong mapping.
>>
>> For example: the guest first changes a level-1 pagetable, and then
>> links its parent to a new place where the original gpte is non-present.
>> Finally the guest can access the remapped area without flushing
>> the tlb.  The guest's behavior should be allowed per SDM, but the host
>> kvm mmu makes it wrong.
> 
> Ah, are you saying, given:
> 
> VA_x = PML4_A -> PDP_B -> PD_C -> PT_D
> 
> the guest can modify PT_D, then link it with
> 
> VA_y = PML4_A -> PDP_B -> PD_E -> PT_D
> 
> and access it via VA_y without flushing, and so KVM must sync PT_D.  Is that
> correct?

Yes. and another vcpu accesses it via VA_y without flushing.

> 
>> Fixes: 4731d4c7a077 ("KVM: MMU: out of sync shadow core")
>> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
>> ---
> 
> ...
> 
>> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
>> index 50ade6450ace..48c7fe1b2d50 100644
>> --- a/arch/x86/kvm/mmu/paging_tmpl.h
>> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
>> @@ -664,7 +664,7 @@ static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, struct guest_walker *gw,
>>    * emulate this operation, return 1 to indicate this case.
>>    */
>>   static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
>> -			 struct guest_walker *gw)
>> +			 struct guest_walker *gw, unsigned long mmu_seq)
>>   {
>>   	struct kvm_mmu_page *sp = NULL;
>>   	struct kvm_shadow_walk_iterator it;
>> @@ -678,6 +678,8 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
>>   	top_level = vcpu->arch.mmu->root_level;
>>   	if (top_level == PT32E_ROOT_LEVEL)
>>   		top_level = PT32_ROOT_LEVEL;
>> +
>> +again:
>>   	/*
>>   	 * Verify that the top-level gpte is still there.  Since the page
>>   	 * is a root page, it is either write protected (and cannot be
>> @@ -713,8 +715,28 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
>>   		if (FNAME(gpte_changed)(vcpu, gw, it.level - 1))
>>   			goto out_gpte_changed;
>>   
>> -		if (sp)
>> +		if (sp) {
>> +			/*
>> +			 * We must synchronize the pagetable before link it
>> +			 * because the guest doens't need to flush tlb when
>> +			 * gpte is changed from non-present to present.
>> +			 * Otherwise, the guest may use the wrong mapping.
>> +			 *
>> +			 * For PG_LEVEL_4K, kvm_mmu_get_page() has already
>> +			 * synchronized it transiently via kvm_sync_page().
>> +			 *
>> +			 * For higher level pagetable, we synchronize it
>> +			 * via slower mmu_sync_children().  If it once
>> +			 * released the mmu_lock, we need to restart from
>> +			 * the root since we don't have reference to @sp.
>> +			 */
>> +			if (sp->unsync_children && !mmu_sync_children(vcpu, sp, false)) {
> 
> I don't like dropping mmu_lock in the page fault path.  I agree that it's not
> all that different than grabbing various things in kvm_mmu_do_page_fault() long
> before acquiring mmu_lock, but I'm not 100% convinced we don't have a latent
> bug hiding somehwere in there :-), and (b) there's a possibility, however small,
> that something in FNAME(fetch) that we're missing.  Case in point, this technically
> needs to do make_mmu_pages_available().
> 
> And I believe kvm_mmu_get_page() already tries to handle this case by requesting
> KVM_REQ_MMU_SYNC if it uses a sp with unsync_children, it just doesn't handle SMP
> interaction, e.g. can link a sp that's immediately available to other vCPUs before
> the sync.
> 
> Rather than force the sync here, what about kicking all vCPUs and retrying the
> page fault?  The only gross part is that kvm_mmu_get_page() can now fail :-(
> 
> ---
>   arch/x86/include/asm/kvm_host.h | 3 ++-
>   arch/x86/kvm/mmu/mmu.c          | 9 +++++++--
>   arch/x86/kvm/mmu/paging_tmpl.h  | 4 ++++
>   3 files changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 09b256db394a..332b9fb3454c 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -57,7 +57,8 @@
>   #define KVM_REQ_MIGRATE_TIMER		KVM_ARCH_REQ(0)
>   #define KVM_REQ_REPORT_TPR_ACCESS	KVM_ARCH_REQ(1)
>   #define KVM_REQ_TRIPLE_FAULT		KVM_ARCH_REQ(2)
> -#define KVM_REQ_MMU_SYNC		KVM_ARCH_REQ(3)
> +#define KVM_REQ_MMU_SYNC \
> +	KVM_ARCH_REQ_FLAGS(3, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>   #define KVM_REQ_CLOCK_UPDATE		KVM_ARCH_REQ(4)
>   #define KVM_REQ_LOAD_MMU_PGD		KVM_ARCH_REQ(5)
>   #define KVM_REQ_EVENT			KVM_ARCH_REQ(6)
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 4853c033e6ce..03293cd3c7ae 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2143,8 +2143,10 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
>   			kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
>   		}
> 
> -		if (sp->unsync_children)
> -			kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
> +		if (sp->unsync_children) {
> +			kvm_make_all_cpus_request(KVM_REQ_MMU_SYNC, vcpu);
> +			return NULL;
> +		}
> 
>   		__clear_sp_write_flooding_count(sp);
> 
> @@ -2999,6 +3001,7 @@ static int __direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> 
>   		sp = kvm_mmu_get_page(vcpu, base_gfn, it.addr,
>   				      it.level - 1, true, ACC_ALL);
> +		BUG_ON(!sp);
> 
>   		link_shadow_page(vcpu, it.sptep, sp);
>   		if (fault->is_tdp && fault->huge_page_disallowed &&
> @@ -3383,6 +3386,8 @@ static hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, gva_t gva,
>   	struct kvm_mmu_page *sp;
> 
>   	sp = kvm_mmu_get_page(vcpu, gfn, gva, level, direct, ACC_ALL);
> +	BUG_ON(!sp);
> +
>   	++sp->root_count;
> 
>   	return __pa(sp->spt);
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index 50ade6450ace..f573d45e2c6f 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -704,6 +704,8 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
>   			access = gw->pt_access[it.level - 2];
>   			sp = kvm_mmu_get_page(vcpu, table_gfn, fault->addr,
>   					      it.level-1, false, access);
> +			if (!sp)
> +				return RET_PF_RETRY;
>   		}
> 
>   		/*
> @@ -742,6 +744,8 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
>   		if (!is_shadow_present_pte(*it.sptep)) {
>   			sp = kvm_mmu_get_page(vcpu, base_gfn, fault->addr,
>   					      it.level - 1, true, direct_access);
> +			BUG_ON(!sp);
> +
>   			link_shadow_page(vcpu, it.sptep, sp);
>   			if (fault->huge_page_disallowed &&
>   			    fault->req_level >= it.level)
> --
> 
