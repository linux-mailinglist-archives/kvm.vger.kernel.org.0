Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEBC96C0AF2
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 07:57:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbjCTG5q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 02:57:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbjCTG5n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 02:57:43 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1367816AFB
        for <kvm@vger.kernel.org>; Sun, 19 Mar 2023 23:57:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679295462; x=1710831462;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=XIvWGE8rh65d4Gv5Kq+ZbBSONCS905gBbdbc4X/9p4Y=;
  b=JaUK6mXO2IMF1yFVzzIqTm27ocUglbeEA71lRxD+K5mj8RIH0HlUd511
   2dzKo1UGhVw8HU9Hjz2ZTxJYYMy246r2Ir+UnQw83pTF15F77DVHANdcv
   mG0mR/pYuPM3AkcfuSddfBCMewknkYfAqB0QRPc6XBzkpjWNN4i8QaAGz
   sMZbYsD2C7QiIaBR7AGSwoC2aMbERGLZE1vyF+QntilZqeDnBF6Pj0jsZ
   mtLH+AfZe3a72yVtGQWHU8hX8oszFjR8klObTKGLu9zOryQFQ9muks2sd
   VnEr4gpXl3+h3D7aZ6apflnhgCha6vVnYbWKVYZmmaPRSWPalBw1nUav8
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10654"; a="366305446"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="366305446"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2023 23:57:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10654"; a="1010356441"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="1010356441"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.0.239]) ([10.238.0.239])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2023 23:57:40 -0700
Message-ID: <b7a54a70-7937-203e-6f65-3c0b8cb831ea@linux.intel.com>
Date:   Mon, 20 Mar 2023 14:57:38 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v5 3/5] KVM: x86: Virtualize CR3.LAM_{U48,U57}
To:     Sean Christopherson <seanjc@google.com>,
        Robert Hoo <robert.hu@linux.intel.com>
Cc:     pbonzini@redhat.com, chao.gao@intel.com, kvm@vger.kernel.org
References: <20230227084547.404871-1-robert.hu@linux.intel.com>
 <20230227084547.404871-4-robert.hu@linux.intel.com>
 <ZAuPPv8PUDX2RBQa@google.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ZAuPPv8PUDX2RBQa@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/11/2023 4:12 AM, Sean Christopherson wrote:
> On Mon, Feb 27, 2023, Robert Hoo wrote:
>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>> index 835426254e76..3efec7f8d8c6 100644
>> --- a/arch/x86/kvm/mmu/mmu.c
>> +++ b/arch/x86/kvm/mmu/mmu.c
>> @@ -3699,7 +3699,14 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
>>   	int quadrant, i, r;
>>   	hpa_t root;
>>   
>> -	root_pgd = mmu->get_guest_pgd(vcpu);
>> +	/*
>> +	 * Omit guest_cpuid_has(X86_FEATURE_LAM) check but can unconditionally
>> +	 * strip CR3 LAM bits because they resides in high reserved bits,
>> +	 * with LAM or not, those high bits should be striped anyway when
>> +	 * interpreted to pgd.
>> +	 */
> This misses the most important part: why it's safe to ignore LAM bits when reusing
> a root.
>
>> +	root_pgd = mmu->get_guest_pgd(vcpu) &
>> +		   ~(X86_CR3_LAM_U48 | X86_CR3_LAM_U57);
> Unconditionally clearing LAM bits is unsafe.  At some point the EPTP may define
> bits in the same area that must NOT be omitted from the root cache, e.g. the PWL
> bits in the EPTP _need_ to be incorporated into is_root_usable().

Sean, sorry that I missed the mail when I cooked & sent out the v6 patch 
of the series.

You are right that the mmu->get_guest_pgd() could be EPTP, and I do 
agree it is not
reasonable to unconditionally ignore LAM bits when the value is EPTP, 
although PWL bits
are not in the high reserved bits.


>
> For simplicity, I'm very, very tempted to say we should just leave the LAM bits
> in root.pgd, i.e. force a new root for a CR3+LAM combination.
Thanks for the suggestion.

Force a new root for a CR3+LAM combination, one concern is that if LAM bits are part of
root.pgd, then toggle of CR3 LAM bit(s) will trigger the kvm mmu reload. That means for a
process that is created without LAM bits set, after it calling prctl to enable LAM, kvm will
have to do mmu load twice. Do you think it would be a problem?


> First and foremost,
> that only matters for shadow paging.  Second, unless a guest kernel allows per-thread
> LAM settings, KVM the extra checks will be benign.  And AIUI, the proposed kernel
> implementation is to apply LAM on a per-MM basis.

Yes, the proposed linux kernel implementaion is to apply LAM on a per-MM basis, and currently
no interface provided to disable LAM after enabling it.However, for kvm, guests are not limited to linux, and not sure how LAM 
feature is enabled in other guest OSes.


>
> And I would much prefer to solve the GFN calculation generically.  E.g. it really
> should be something like this
>
> 	root_pgd = mmu->get_guest_pgd(vcpu);
> 	root_gfn = mmu->gpte_to_gfn(root_pgd);
>
> but having to set gpte_to_gfn() in the MMU is quite unfortunate, and gpte_to_gfn()
> is technically insufficient for PAE since it relies on previous checks to prevent
> consuming a 64-bit CR3.
>
> I was going to suggest extracting the maximal base addr mask and use that, e.g.
>
> 	#define __PT_BASE_ADDR_MASK (((1ULL << 52) - 1) & ~(u64)(PAGE_SIZE-1))
>
> Maybe this?
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index c8ebe542c565..8b2d2a6081b3 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3732,7 +3732,12 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
>          hpa_t root;
>   
>          root_pgd = mmu->get_guest_pgd(vcpu);
> -       root_gfn = root_pgd >> PAGE_SHIFT;
> +
> +       /*
> +        * The guest PGD has already been checked for validity, unconditionally
> +        * strip non-address bits when computing the GFN.
> +        */
> +       root_gfn = (root_pgd & __PT_BASE_ADDR_MASK) >> PAGE_SHIFT;
>   
>          if (mmu_check_root(vcpu, root_gfn))
>                  return 1;
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index cc58631e2336..c0479cbc2ca3 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -21,6 +21,7 @@ extern bool dbg;
>   #endif
>   
>   /* Page table builder macros common to shadow (host) PTEs and guest PTEs. */
> +#define __PT_BASE_ADDR_MASK (((1ULL << 52) - 1) & ~(u64)(PAGE_SIZE-1))
>   #define __PT_LEVEL_SHIFT(level, bits_per_level)        \
>          (PAGE_SHIFT + ((level) - 1) * (bits_per_level))
>   #define __PT_INDEX(address, level, bits_per_level) \
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index 57f0b75c80f9..0583bfce3b52 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -62,7 +62,7 @@
>   #endif
>   
>   /* Common logic, but per-type values.  These also need to be undefined. */
> -#define PT_BASE_ADDR_MASK      ((pt_element_t)(((1ULL << 52) - 1) & ~(u64)(PAGE_SIZE-1)))
> +#define PT_BASE_ADDR_MASK      ((pt_element_t)__PT_BASE_ADDR_MASK)
>   #define PT_LVL_ADDR_MASK(lvl)  __PT_LVL_ADDR_MASK(PT_BASE_ADDR_MASK, lvl, PT_LEVEL_BITS)
>   #define PT_LVL_OFFSET_MASK(lvl)        __PT_LVL_OFFSET_MASK(PT_BASE_ADDR_MASK, lvl, PT_LEVEL_BITS)
>   #define PT_INDEX(addr, lvl)    __PT_INDEX(addr, lvl, PT_LEVEL_BITS)
> diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> index 1279db2eab44..777f7d443e3b 100644
> --- a/arch/x86/kvm/mmu/spte.h
> +++ b/arch/x86/kvm/mmu/spte.h
> @@ -36,7 +36,7 @@ static_assert(SPTE_TDP_AD_ENABLED == 0);
>   #ifdef CONFIG_DYNAMIC_PHYSICAL_MASK
>   #define SPTE_BASE_ADDR_MASK (physical_mask & ~(u64)(PAGE_SIZE-1))
>   #else
> -#define SPTE_BASE_ADDR_MASK (((1ULL << 52) - 1) & ~(u64)(PAGE_SIZE-1))
> +#define SPTE_BASE_ADDR_MASK __PT_BASE_ADDR_MASK
>   #endif
>   
>   #define SPTE_PERM_MASK (PT_PRESENT_MASK | PT_WRITABLE_MASK | shadow_user_mask \
>
>>   	root_gfn = root_pgd >> PAGE_SHIFT;
>>   
>>   	if (mmu_check_root(vcpu, root_gfn))
>> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
>> index 0f6455072055..57f39c7492ed 100644
>> --- a/arch/x86/kvm/mmu/paging_tmpl.h
>> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
>> @@ -324,7 +324,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
>>   	trace_kvm_mmu_pagetable_walk(addr, access);
>>   retry_walk:
>>   	walker->level = mmu->cpu_role.base.level;
>> -	pte           = mmu->get_guest_pgd(vcpu);
>> +	pte           = mmu->get_guest_pgd(vcpu) & ~(X86_CR3_LAM_U48 | X86_CR3_LAM_U57);
> This should be unnecessary, gpte_to_gfn() is supposed to strip non-address bits.
>
>>   	have_ad       = PT_HAVE_ACCESSED_DIRTY(mmu);
>>   
>>   #ifdef CONFIG_X86_64
>>   	bool pcid_enabled = !!kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE);
>>   
>> @@ -1254,14 +1265,26 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
>>   	 * stuff CR3, e.g. for RSM emulation, and there is no guarantee that
>>   	 * the current vCPU mode is accurate.
>>   	 */
>> -	if (kvm_vcpu_is_illegal_gpa(vcpu, cr3))
>> +	if (!kvm_vcpu_is_valid_cr3(vcpu, cr3))
>>   		return 1;
>>   
>>   	if (is_pae_paging(vcpu) && !load_pdptrs(vcpu, cr3))
>>   		return 1;
>>   
>> -	if (cr3 != kvm_read_cr3(vcpu))
>> -		kvm_mmu_new_pgd(vcpu, cr3);
>> +	old_cr3 = kvm_read_cr3(vcpu);
>> +	if (cr3 != old_cr3) {
>> +		if ((cr3 ^ old_cr3) & ~(X86_CR3_LAM_U48 | X86_CR3_LAM_U57)) {
>> +			kvm_mmu_new_pgd(vcpu, cr3 & ~(X86_CR3_LAM_U48 |
>> +					X86_CR3_LAM_U57));
> As above, no change is needed here if LAM is tracked in the PGD.
