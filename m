Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6DEF6507DF
	for <lists+kvm@lfdr.de>; Mon, 19 Dec 2022 07:47:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231292AbiLSGrL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Dec 2022 01:47:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231708AbiLSGqw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Dec 2022 01:46:52 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C594A60D4
        for <kvm@vger.kernel.org>; Sun, 18 Dec 2022 22:44:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671432298; x=1702968298;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ypn4smB4U60K6pf/L8VX8q7KH8u2ncOwRNyHq3y9TNY=;
  b=QS0UGMZR9t14qSHOkMOAvuMeI/otL9s2F1j9Lec3bqLSAEwLsapn8kZn
   9yS6ODYOEMkt6lDjXADon9YKc0W0cUYdyHLC0M1/djyvRf51FhDxoY9gJ
   AsMA61/aflpDCgTDkmz891ey9f6uSL5KyuwR4SQb48rKNF/wFQvWPf1I8
   A5G9ZwNDOmtRoPFGnXdFRhhhjpkSWWY/B4UpQJIfeIASHX3DYmEO3Ykfm
   M7/aCHMB/b+S1KHmwBI1ib2cxJss0t8CPTHbrB6XpTvtNw1DlY0nVbK3E
   8do3rjOCPryUYCLrY12mUt0Y7olcY/cmSmS8QPM/xNhf5KqShEkGaVd28
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="316918229"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="316918229"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2022 22:44:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="719001871"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="719001871"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by fmsmga004.fm.intel.com with ESMTP; 18 Dec 2022 22:44:56 -0800
Date:   Mon, 19 Dec 2022 14:44:56 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
Cc:     pbonzini@redhat.com, seanjc@google.com,
        kirill.shutemov@linux.intel.com, kvm@vger.kernel.org,
        Jingqi Liu <jingqi.liu@intel.com>
Subject: Re: [PATCH v3 3/9] KVM: x86: MMU: Rename get_cr3() --> get_pgd() and
 clear high bits for pgd
Message-ID: <20221219064456.gcefglh4mov7xbz6@yy-desk-7060>
References: <20221209044557.1496580-1-robert.hu@linux.intel.com>
 <20221209044557.1496580-4-robert.hu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221209044557.1496580-4-robert.hu@linux.intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 09, 2022 at 12:45:51PM +0800, Robert Hoo wrote:
> The get_cr3() is the implementation of kvm_mmu::get_guest_pgd(), well, CR3
> cannot be naturally equivalent to pgd, SDM says CR3 high bits are reserved,
> must be zero.
> And now, with LAM feature's introduction, bit 61 ~ 62 are used.
> So, rename get_cr3() --> get_pgd() to better indicate function purpose and
> in it, filtered out CR3 high bits.
>
> Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
> Reviewed-by: Jingqi Liu <jingqi.liu@intel.com>
> ---
>  arch/x86/include/asm/processor-flags.h |  1 +
>  arch/x86/kvm/mmu/mmu.c                 | 12 ++++++++----
>  2 files changed, 9 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/include/asm/processor-flags.h b/arch/x86/include/asm/processor-flags.h
> index d8cccadc83a6..bb0f8dd16956 100644
> --- a/arch/x86/include/asm/processor-flags.h
> +++ b/arch/x86/include/asm/processor-flags.h
> @@ -38,6 +38,7 @@
>  #ifdef CONFIG_X86_64
>  /* Mask off the address space ID and SME encryption bits. */
>  #define CR3_ADDR_MASK	__sme_clr(PHYSICAL_PAGE_MASK)
> +#define CR3_HIGH_RSVD_MASK	GENMASK_ULL(63, 52)
>  #define CR3_PCID_MASK	0xFFFull
>  #define CR3_NOFLUSH	BIT_ULL(63)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index b6f96d47e596..d433c8923b18 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4488,9 +4488,13 @@ void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd)
>  }
>  EXPORT_SYMBOL_GPL(kvm_mmu_new_pgd);
>
> -static unsigned long get_cr3(struct kvm_vcpu *vcpu)
> +static unsigned long get_pgd(struct kvm_vcpu *vcpu)
>  {
> +#ifdef CONFIG_X86_64
> +	return kvm_read_cr3(vcpu) & ~CR3_HIGH_RSVD_MASK;

CR3_HIGH_RSVD_MASK is used to extract the guest pgd, may
need to use guest's MAXPHYADDR but not hard code to 52.
Or easily, just mask out the LAM bits.

> +#else
>  	return kvm_read_cr3(vcpu);
> +#endif
>  }
>
>  static bool sync_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, gfn_t gfn,
> @@ -5043,7 +5047,7 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,
>  	context->page_fault = kvm_tdp_page_fault;
>  	context->sync_page = nonpaging_sync_page;
>  	context->invlpg = NULL;
> -	context->get_guest_pgd = get_cr3;
> +	context->get_guest_pgd = get_pgd;
>  	context->get_pdptr = kvm_pdptr_read;
>  	context->inject_page_fault = kvm_inject_page_fault;
>
> @@ -5193,7 +5197,7 @@ static void init_kvm_softmmu(struct kvm_vcpu *vcpu,
>
>  	kvm_init_shadow_mmu(vcpu, cpu_role);
>
> -	context->get_guest_pgd     = get_cr3;
> +	context->get_guest_pgd     = get_pgd;
>  	context->get_pdptr         = kvm_pdptr_read;
>  	context->inject_page_fault = kvm_inject_page_fault;
>  }
> @@ -5207,7 +5211,7 @@ static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu,
>  		return;
>
>  	g_context->cpu_role.as_u64   = new_mode.as_u64;
> -	g_context->get_guest_pgd     = get_cr3;
> +	g_context->get_guest_pgd     = get_pgd;
>  	g_context->get_pdptr         = kvm_pdptr_read;
>  	g_context->inject_page_fault = kvm_inject_page_fault;
>
> --
> 2.31.1
>
