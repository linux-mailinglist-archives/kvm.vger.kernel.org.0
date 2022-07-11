Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC2AA56D523
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 09:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbiGKHFQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 03:05:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbiGKHFO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 03:05:14 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 818AD1836A;
        Mon, 11 Jul 2022 00:05:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657523113; x=1689059113;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=M3DEFxgy5d/neRqAV7gBWI9NQ0OGc01lrpGq6dCFm0M=;
  b=TzJqySTy85pYgWZE1XBfnKJRg37x9ItwaNj5HZXuSFWI/fc9BRbqnvha
   UOw0SlAG+8sRqsg8/Xz5X4m8ZSVdYhxp8wOSmaXk61gvJ93I7WGReki+L
   CFVct/SEjDXa5umuWFWE4etg31K+76Fcv41UlA2vIJF10s86adl/+uxN6
   Tt9qYkaqKx8RJkNYveohKe8kRtowY9KrRg4eyFYxRw8jeFOJ5W7Tlj5K9
   /QYO2GRoGwfv2rvAMjR+2nN1JX7Xca0QgWoVL2tYrcFRuyk1y2lIUredJ
   6DtPjtVyuIUbyzuzs83RYe/4CZ8eMAsoXb/nLKmJWhNC1NZoVVK9rH8RA
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10404"; a="282143199"
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="282143199"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 00:05:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="598936860"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by fmsmga007.fm.intel.com with ESMTP; 11 Jul 2022 00:05:11 -0700
Date:   Mon, 11 Jul 2022 15:05:10 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v7 036/102] KVM: x86/mmu: Allow non-zero value for
 non-present SPTE
Message-ID: <20220711070510.dm4am2miy5lcwlzq@yy-desk-7060>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
 <f74b05eca8815744ce1ad672c66033101be7369c.1656366338.git.isaku.yamahata@intel.com>
 <20220708051847.prn254ukwvgkdl3c@yy-desk-7060>
 <YshNjy5RsxYuFxOo@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YshNjy5RsxYuFxOo@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 08, 2022 at 03:30:23PM +0000, Sean Christopherson wrote:
> Please trim replies.
>
> On Fri, Jul 08, 2022, Yuan Yao wrote:
> > On Mon, Jun 27, 2022 at 02:53:28PM -0700, isaku.yamahata@intel.com wrote:
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index 51306b80f47c..f239b6cb5d53 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -668,6 +668,44 @@ static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
> > >  	}
> > >  }
> > >
> > > +static inline void kvm_init_shadow_page(void *page)
> > > +{
> > > +#ifdef CONFIG_X86_64
> > > +	int ign;
> > > +
> > > +	WARN_ON_ONCE(shadow_nonpresent_value != SHADOW_NONPRESENT_VALUE);
> > > +	asm volatile (
> > > +		"rep stosq\n\t"
>
> I have a slight preference for:
>
> 	asm volatile ("rep stosq\n\t"
> 		      <align here>
> 	);
>
> so that searching for "asm" or "asm volatile" shows the "rep stosq" in the
> result without needed to capture the next line.
>
> > > +		: "=c"(ign), "=D"(page)
> > > +		: "a"(SHADOW_NONPRESENT_VALUE), "c"(4096/8), "D"(page)
> > > +		: "memory"
> > > +	);
> > > +#else
> > > +	BUG();
> > > +#endif
>
> Rather than put the #ifdef here, split mmu_topup_shadow_page_cache() on 64-bit
> versus 32-bit.  Then this BUG() goes away and we don't get slapped on the wrist
> by Linus :-)
>
> > > +}
> > > +
> > > +static int mmu_topup_shadow_page_cache(struct kvm_vcpu *vcpu)
> > > +{
> > > +	struct kvm_mmu_memory_cache *mc = &vcpu->arch.mmu_shadow_page_cache;
> > > +	int start, end, i, r;
> > > +	bool is_tdp_mmu = is_tdp_mmu_enabled(vcpu->kvm);
> > > +
> > > +	if (is_tdp_mmu && shadow_nonpresent_value)
> > > +		start = kvm_mmu_memory_cache_nr_free_objects(mc);
> > > +
> > > +	r = kvm_mmu_topup_memory_cache(mc, PT64_ROOT_MAX_LEVEL);
> > > +	if (r)
> > > +		return r;
>
> Bailing immediately is wrong.  If kvm_mmu_topup_memory_cache() fails after allocating
> at least one page, then KVM needs to initialize those pages, otherwise it will leave
> uninitialized pages in the cache.  If userspace frees up memory in response to the
> -ENOMEM and resumes the vCPU, KVM will consume uninitialized data.
>
> > > +
> > > +	if (is_tdp_mmu && shadow_nonpresent_value) {
>
> So I'm pretty sure I effectively suggested keeping shadow_nonpresent_value, but
> seeing it in code, I really don't like it.  It's an unnecessary check on every
> SPT allocation, and it's misleading because it suggests shadow_nonpresent_value
> might be zero when the TDP MMU is enabled.
>
> My vote is to drop shadow_nonpresent_value and then rename kvm_init_shadow_page()
> to make it clear that it's specific to the TDP MMU.
>
> So this?  Completely untested.
>
> #ifdef CONFIG_X86_64
> static void kvm_init_tdp_mmu_shadow_page(void *page)
> {
> 	int ign;
>
> 	asm volatile ("rep stosq\n\t"
> 		      : "=c"(ign), "=D"(page)
> 		      : "a"(SHADOW_NONPRESENT_VALUE), "c"(4096/8), "D"(page)
> 		      : "memory"
> 	);
> }
>
> static int mmu_topup_shadow_page_cache(struct kvm_vcpu *vcpu)
> {
> 	struct kvm_mmu_memory_cache *mc = &vcpu->arch.mmu_shadow_page_cache;
> 	bool is_tdp_mmu = is_tdp_mmu_enabled(vcpu->kvm);
> 	int start, end, i, r;
>
> 	if (is_tdp_mmu)
> 		start = kvm_mmu_memory_cache_nr_free_objects(mc);
>
> 	r = kvm_mmu_topup_memory_cache(mc, PT64_ROOT_MAX_LEVEL);
>
> 	/*
> 	 * Note, topup may have allocated objects even if it failed to allocate
> 	 * the minimum number of objects required to make forward progress _at
> 	 * this time_.  Initialize newly allocated objects even on failure, as
> 	 * userspace can free memory and rerun the vCPU in response to -ENOMEM.
> 	 */
> 	if (is_tdp_mmu) {
> 		end = kvm_mmu_memory_cache_nr_free_objects(mc);
> 		for (i = start; i < end; i++)
> 			kvm_init_tdp_mmu_shadow_page(mc->objects[i]);
> 	}
> 	return r;
> }
> #else
> static int mmu_topup_shadow_page_cache(struct kvm_vcpu *vcpu)
> {
> 	return kvm_mmu_topup_memory_cache(vcpu->arch.mmu_shadow_page_cache,
> 					  PT64_ROOT_MAX_LEVEL);
> }
> #endif /* CONFIG_X86_64 */
>
> > > +		end = kvm_mmu_memory_cache_nr_free_objects(mc);
> > > +		for (i = start; i < end; i++)
> > > +			kvm_init_shadow_page(mc->objects[i]);
> > > +	}
> > > +	return 0;
> > > +}
> > > +
>
> ...
>
> > > @@ -5654,7 +5698,8 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
> > >  	vcpu->arch.mmu_page_header_cache.kmem_cache = mmu_page_header_cache;
> > >  	vcpu->arch.mmu_page_header_cache.gfp_zero = __GFP_ZERO;
> > >
> > > -	vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
> > > +	if (!(is_tdp_mmu_enabled(vcpu->kvm) && shadow_nonpresent_value))
> > > +		vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
> >
> > I'm not sure why skip this for TDX, arch.mmu_shadow_page_cache is
> > still used for allocating sp->spt which used to track the S-EPT in kvm
> > for tdx guest.  Anything I missed for this ?
>
> Shared EPTEs need to be initialized with SUPPRESS_VE=1, otherwise not-present
> EPT violations would be reflected into the guest by hardware as #VE exceptions.
> This is handled by initializing page allocations via kvm_init_shadow_page() during
> cache topup if shadow_nonpresent_value is non-zero.  In that case, telling the
> page allocation to zero-initialize the page would be wasted effort.
>
> The initialization is harmless for S-EPT entries because KVM's copy of the S-EPT
> isn't consumed by hardware, and because under the hood S-EPT entries should never
> #VE (I forget if this is enforced by hardware or if the TDX module sets SUPPRESS_VE).

Ah I see, you're right, thanks for the explanation! I think with
changes you suggested above the __GFP_ZERO can be removed from
mmu_shadow_page_cache for VMs which is_tdp_mmu_enabled() is true:

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8de26cbde295..0b412f3eb0c5 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6483,8 +6483,8 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.mmu_page_header_cache.kmem_cache = mmu_page_header_cache;
 	vcpu->arch.mmu_page_header_cache.gfp_zero = __GFP_ZERO;

-	if (!(tdp_enabled && shadow_nonpresent_value))
-		vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
+	if (!(is_tdp_mmu_enabled(vcpu->kvm))
+	    vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;

 	vcpu->arch.mmu = &vcpu->arch.root_mmu;
 	vcpu->arch.walk_mmu = &vcpu->arch.root_mmu;
