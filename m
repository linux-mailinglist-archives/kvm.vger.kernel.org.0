Return-Path: <kvm+bounces-4983-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B318881AFCB
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 08:48:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 373711F22CE8
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 07:48:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19DCE156C9;
	Thu, 21 Dec 2023 07:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nGINdai+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9465714AB5
	for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 07:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1703144904; x=1734680904;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=0oH81wKHbBl3kj3yYa7SWTEoLMHEB4dcWBsuLOCWcWE=;
  b=nGINdai+bAmSpUbl8xY9rbkH544Ilgev22ex3E4c2KeqVQKYoKCkAdfe
   BqB+a7jY9WdmyN3o6mNjt38DwSEV2blpVjPX64PSzfA789GFNrpQjSfJx
   dTtpw8XPL2d2umPAxjrbPu7JqdyhSMoky7bUbkIBp45PdK+PNOM4C9Owe
   DhTG/mPlu3Cd9OwuGLLkmhya6eVrSSmZ9QGMYk+xZuxSevlTFuZ3RBasn
   UtvkTjPzFy1+PSUglVH9HvEdbbgHSj30JkKMK+m0IwzuifGP3AbhvOcfq
   g4a7fKv4WNbVOOxGLWn844WJW5Szr07hZH5mt5V0cFoeiKx59iuNCthhC
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10930"; a="386362318"
X-IronPort-AV: E=Sophos;i="6.04,293,1695711600"; 
   d="scan'208";a="386362318"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2023 23:48:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10930"; a="752856561"
X-IronPort-AV: E=Sophos;i="6.04,293,1695711600"; 
   d="scan'208";a="752856561"
Received: from linux.bj.intel.com ([10.238.157.71])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2023 23:48:21 -0800
Date: Thu, 21 Dec 2023 15:45:15 +0800
From: Tao Su <tao1.su@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, eddie.dong@intel.com,
	chao.gao@intel.com, xiaoyao.li@intel.com, yuan.yao@linux.intel.com,
	yi1.lai@intel.com, xudong.hao@intel.com, chao.p.peng@intel.com
Subject: Re: [PATCH 1/2] x86: KVM: Limit guest physical bits when 5-level EPT
 is unsupported
Message-ID: <ZYPtC01FMknBSVxV@linux.bj.intel.com>
References: <20231218140543.870234-1-tao1.su@linux.intel.com>
 <20231218140543.870234-2-tao1.su@linux.intel.com>
 <ZYMWFhVQ7dCjYegQ@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZYMWFhVQ7dCjYegQ@google.com>

On Wed, Dec 20, 2023 at 08:28:06AM -0800, Sean Christopherson wrote:
> As evidenced by my initial response, the shortlog is a bit misleading.  In non-KVM
> code it would be perfectly ok to say "limit", but in KVM's split world where
> *userspace* is mostly responsible for the guest configuration, "limit guest ..."
> is often going to be read as "limit the capabilities of the guest".
> 
> This is also a good example of why shortlogs and changelogs should NOT be play-by-play
> descriptions of the code change.  The literal code change applies a limit to
> guest physical bits, but that doesn't capture the net effect of applying said limit.
> 
> Something like
> 
>   KVM: x86: Don't advertise 52-bit MAXPHYADDR if 5-level TDP is unsupported
> 
> better captures that the patch affects what KVM advertises to userspace.  Yeah,
> it's technically inaccurate to say "52-bit", but I think 52-bit MAXPHYADDR is
> ubiquitous enough that it's worth being technically wrong in order to clearly
> communicate the net effect.  Alternatively, it could be something like:
> 
>   KVM: x86: Don't advertise incompatible MAXPHYADDR if 5-level TDP is unsupported

Yeah, these two shortlogs are more accurate and intuitive.

> 
> On Mon, Dec 18, 2023, Tao Su wrote:
> > When host doesn't support 5-level EPT, bits 51:48 of the guest physical
> > address must all be zero, otherwise an EPT violation always occurs and
> > current handler can't resolve this if the gpa is in RAM region. Hence,
> > instruction will keep being executed repeatedly, which causes infinite
> > EPT violation.
> > 
> > Six KVM selftests are timeout due to this issue:
> >     kvm:access_tracking_perf_test
> >     kvm:demand_paging_test
> >     kvm:dirty_log_test
> >     kvm:dirty_log_perf_test
> >     kvm:kvm_page_table_test
> >     kvm:memslot_modification_stress_test
> > 
> > The above selftests add a RAM region close to max_gfn, if host has 52
> > physical bits but doesn't support 5-level EPT, these will trigger infinite
> > EPT violation when access the RAM region.
> > 
> > Since current Intel CPUID doesn't report max guest physical bits like AMD,
> > introduce kvm_mmu_tdp_maxphyaddr() to limit guest physical bits when tdp is
> > enabled and report the max guest physical bits which is smaller than host.
> > 
> > When guest physical bits is smaller than host, some GPA are illegal from
> > guest's perspective, but are still legal from hardware's perspective,
> > which should be trapped to inject #PF. Current KVM already has a parameter
> > allow_smaller_maxphyaddr to support the case when guest.MAXPHYADDR <
> > host.MAXPHYADDR, which is disabled by default when EPT is enabled, user
> > can enable it when loading kvm-intel module. When allow_smaller_maxphyaddr
> > is enabled and guest accesses an illegal address from guest's perspective,
> > KVM will utilize EPT violation and emulate the instruction to inject #PF
> > and determine #PF error code.
> 
> There is far too much unnecessary cruft in this changelog.  The entire last
> paragraph is extraneous information.  Talking in detail about KVM's (flawed)
> emulation of smaller guest.MAXPHYADDR isn't at all relevant as to whether or not
> it's correct for KVM to advertise an impossible configuration.
> 
> And this is exactly why I dislike the "explain the symptom, then the solution"
> style for KVM.  The symptoms described above don't actually explain why *KVM* is
> at fault.
> 
>   KVM: x86: Don't advertise 52-bit MAXPHYADDR if 5-level TDP is unsupported
> 
>   Cap the effective guest.MAXPHYADDR that KVM advertises to userspace at
>   48 bits if 5-level TDP isn't supported, as bits 51:49 are consumed by the
>   CPU during a page table walk if and only if 5-level TDP is enabled.  I.e.
>   it's impossible for KVM to actually map GPAs with bits 51:49 set, which
>   results in vCPUs getting stuck on endless EPT violations.
> 
>   From Intel's SDM:
> 
>     4-level EPT accesses at most 4 EPT paging-structure entries (an EPT page-
>     walk length of 4) to translate a guest-physical address and uses only
>     bits 47:0 of each guest-physical address. In contrast, 5-level EPT may
>     access up to 5 EPT paging-structure entries (an EPT page-walk length of 5)
>     and uses guest-physical address bits 56:0. [Physical addresses and
>     guest-physical addresses are architecturally limited to 52 bits (e.g.,
>     by paging), so in practice bits 56:52 are zero.]
> 
>   While it's decidedly odd for a CPU to support a 52-bit MAXPHYADDR but
>   not 5-level EPT, the combination is architecturally legal and such CPUs
>   do exist (and can easily be "created" with nested virtualization).
> 
>   Note, because EPT capabilities are reported via MSRs, it's impossible
>   for userspace to avoid the funky setup, i.e. advertising a sane MAXPHYADDR
>   is 100% KVM's responsibility.

Yes, I learn a lot, I will use the above shortlogs and changelogs as my
next version.

> 
> > Reported-by: Yi Lai <yi1.lai@intel.com>
> > Signed-off-by: Tao Su <tao1.su@linux.intel.com>
> > Tested-by: Yi Lai <yi1.lai@intel.com>
> > Tested-by: Xudong Hao <xudong.hao@intel.com>
> > ---
> >  arch/x86/kvm/cpuid.c   | 5 +++--
> >  arch/x86/kvm/mmu.h     | 1 +
> >  arch/x86/kvm/mmu/mmu.c | 7 +++++++
> >  3 files changed, 11 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index dda6fc4cfae8..91933ca739ad 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -1212,12 +1212,13 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
> >  		 *
> >  		 * If TDP is enabled but an explicit guest MAXPHYADDR is not
> >  		 * provided, use the raw bare metal MAXPHYADDR as reductions to
> > -		 * the HPAs do not affect GPAs.
> > +		 * the HPAs do not affect GPAs, but ensure guest MAXPHYADDR
> > +		 * doesn't exceed the bits that TDP can translate.
> >  		 */
> >  		if (!tdp_enabled)
> >  			g_phys_as = boot_cpu_data.x86_phys_bits;
> >  		else if (!g_phys_as)
> > -			g_phys_as = phys_as;
> > +			g_phys_as = min(phys_as, kvm_mmu_tdp_maxphyaddr());
> 
> I think KVM should be paranoid and cap the advertised MAXPHYADDR even if the CPU
> advertises guest.MAXPHYADDR.  Advertising a bad guest.MAXPHYADDR is arguably a
> blatant CPU bug, but being paranoid is cheap in this case.

Yes, agree.

> 
> >  		entry->eax = g_phys_as | (virt_as << 8);
> >  		entry->ecx &= ~(GENMASK(31, 16) | GENMASK(11, 8));
> > diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> > index bb8c86eefac0..1c7d649fcf6b 100644
> > --- a/arch/x86/kvm/mmu.h
> > +++ b/arch/x86/kvm/mmu.h
> > @@ -115,6 +115,7 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
> >  				u64 fault_address, char *insn, int insn_len);
> >  void __kvm_mmu_refresh_passthrough_bits(struct kvm_vcpu *vcpu,
> >  					struct kvm_mmu *mmu);
> > +unsigned int kvm_mmu_tdp_maxphyaddr(void);
> >  
> >  int kvm_mmu_load(struct kvm_vcpu *vcpu);
> >  void kvm_mmu_unload(struct kvm_vcpu *vcpu);
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index c57e181bba21..72634d6b61b2 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -5177,6 +5177,13 @@ void __kvm_mmu_refresh_passthrough_bits(struct kvm_vcpu *vcpu,
> >  	reset_guest_paging_metadata(vcpu, mmu);
> >  }
> >  
> > +/* guest-physical-address bits limited by TDP */
> > +unsigned int kvm_mmu_tdp_maxphyaddr(void)
> > +{
> > +	return max_tdp_level == 5 ? 57 : 48;
> 
> Using "57" is kinda sorta wrong, e.g. the SDM says:
> 
>   Bits 56:52 of each guest-physical address are necessarily zero because
>   guest-physical addresses are architecturally limited to 52 bits.
> 
> Rather than split hairs over something that doesn't matter, I think it makes sense
> for the CPUID code to consume max_tdp_level directly (I forgot that max_tdp_level
> is still accurate when tdp_root_level is non-zero).
> 
> That also avoids confusion with kvm_mmu_max_gfn(), which deliberately uses the
> *host* MAXPHYADDR.
> 
> Making max_tdp_level visible isn't ideal, but tdp_enabled is already visible and
> used by the CPUID code, so it's not the end of the world.

Yes, agree.

> 
> > +}
> > +EXPORT_SYMBOL_GPL(kvm_mmu_tdp_maxphyaddr);
> 
> This shouldn't be exported, I don't see any reason for vendor code to need access
> to this helper.  It's essentially a moot point though if we avoid the helper in
> the first place.

Yes, previously I want to invoke this helper in the patch2, now it is no
longer needed.

> 
> All in all, this?

The code is perfect, I will add it to my next version, thanks!

> 
> ---
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/cpuid.c            | 16 ++++++++++++----
>  arch/x86/kvm/mmu/mmu.c          |  2 +-
>  3 files changed, 14 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 7bc1daf68741..29b575b86912 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1932,6 +1932,7 @@ void kvm_fire_mask_notifiers(struct kvm *kvm, unsigned irqchip, unsigned pin,
>  			     bool mask);
>  
>  extern bool tdp_enabled;
> +extern int max_tdp_level;
>  
>  u64 vcpu_tsc_khz(struct kvm_vcpu *vcpu);
>  
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 294e5bd5f8a0..637a1f388a51 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -1233,12 +1233,20 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  		 *
>  		 * If TDP is enabled but an explicit guest MAXPHYADDR is not
>  		 * provided, use the raw bare metal MAXPHYADDR as reductions to
> -		 * the HPAs do not affect GPAs.
> +		 * the HPAs do not affect GPAs.  Finally, if TDP is enabled and
> +		 * doesn't support 5-level TDP, cap guest MAXPHYADDR at 48 bits
> +		 * as bits 51:49 are used by the CPU if and only if 5-level TDP

Nit, it should be bits 51:48?

Thanks,
Tao

> +		 * is enabled, i.e. KVM can't map such GPAs with 4-level TDP.
>  		 */
> -		if (!tdp_enabled)
> +		if (!tdp_enabled) {
>  			g_phys_as = boot_cpu_data.x86_phys_bits;
> -		else if (!g_phys_as)
> -			g_phys_as = phys_as;
> +		} else {
> +			if (!g_phys_as)
> +				g_phys_as = phys_as;
> +
> +			if (max_tdp_level < 5)
> +				g_phys_as = min(g_phys_as, 48);
> +		}
>  
>  		entry->eax = g_phys_as | (virt_as << 8);
>  		entry->ecx &= ~(GENMASK(31, 16) | GENMASK(11, 8));
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 3c844e428684..5036c7eb7dac 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -114,7 +114,7 @@ module_param_named(tdp_mmu, tdp_mmu_enabled, bool, 0444);
>  
>  static int max_huge_page_level __read_mostly;
>  static int tdp_root_level __read_mostly;
> -static int max_tdp_level __read_mostly;
> +int max_tdp_level __read_mostly;
>  
>  #define PTE_PREFETCH_NUM		8
>  
> 
> base-commit: f2a3fb7234e52f72ff4a38364dbf639cf4c7d6c6
> -- 
> 

