Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3ABBC16B4AF
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 23:57:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728308AbgBXW5o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 17:57:44 -0500
Received: from mga06.intel.com ([134.134.136.31]:25885 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728018AbgBXW5o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 17:57:44 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Feb 2020 14:57:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,481,1574150400"; 
   d="scan'208";a="284491423"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by FMSMGA003.fm.intel.com with ESMTP; 24 Feb 2020 14:57:43 -0800
Date:   Mon, 24 Feb 2020 14:57:43 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 38/61] KVM: x86: Introduce kvm_cpu_caps to replace
 runtime CPUID masking
Message-ID: <20200224225743.GP29865@linux.intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
 <20200201185218.24473-39-sean.j.christopherson@intel.com>
 <87h7zgndxl.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h7zgndxl.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 24, 2020 at 05:32:54PM +0100, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> 
> > Calculate the CPUID masks for KVM_GET_SUPPORTED_CPUID at load time using
> > what is effectively a KVM-adjusted copy of boot_cpu_data, or more
> > precisely, the x86_capability array in boot_cpu_data.
> >
> > In terms of KVM support, the vast majority of CPUID feature bits are
> > constant, and *all* feature support is known at KVM load time.  Rather
> > than apply boot_cpu_data, which is effectively read-only after init,
> > at runtime, copy it into a KVM-specific array and use *that* to mask
> > CPUID registers.
> >
> > In additional to consolidating the masking, kvm_cpu_caps can be adjusted
> > by SVM/VMX at load time and thus eliminate all feature bit manipulation
> > in ->set_supported_cpuid().
> >
> > No functional change intended.
> >
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >  arch/x86/kvm/cpuid.c | 229 +++++++++++++++++++++++--------------------
> >  arch/x86/kvm/cpuid.h |  19 ++++
> >  arch/x86/kvm/x86.c   |   2 +
> >  3 files changed, 142 insertions(+), 108 deletions(-)
> >
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index 20a7af320291..c2a4c9df49a9 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -24,6 +24,13 @@
> >  #include "trace.h"
> >  #include "pmu.h"
> >  
> > +/*
> > + * Unlike "struct cpuinfo_x86.x86_capability", kvm_cpu_caps doesn't need to be
> > + * aligned to sizeof(unsigned long) because it's not accessed via bitops.
> > + */
> > +u32 kvm_cpu_caps[NCAPINTS] __read_mostly;
> > +EXPORT_SYMBOL_GPL(kvm_cpu_caps);
> > +
> >  static u32 xstate_required_size(u64 xstate_bv, bool compacted)
> >  {
> >  	int feature_bit = 0;
> > @@ -259,7 +266,119 @@ static __always_inline void cpuid_entry_mask(struct kvm_cpuid_entry2 *entry,
> >  {
> >  	u32 *reg = cpuid_entry_get_reg(entry, leaf * 32);
> >  
> > -	*reg &= boot_cpu_data.x86_capability[leaf];
> > +	BUILD_BUG_ON(leaf > ARRAY_SIZE(kvm_cpu_caps));
> 
> Should this be '>=' ?

Yep, nice catch.

> > +	*reg &= kvm_cpu_caps[leaf];
> > +}
> > +
> > +static __always_inline void kvm_cpu_cap_mask(enum cpuid_leafs leaf, u32 mask)
> > +{
> > +	reverse_cpuid_check(leaf);
> > +	kvm_cpu_caps[leaf] &= mask;
> > +}
> > +
> > +void kvm_set_cpu_caps(void)
> > +{
> > +	unsigned f_nx = is_efer_nx() ? F(NX) : 0;
> > +#ifdef CONFIG_X86_64
> > +	unsigned f_gbpages = F(GBPAGES);
> > +	unsigned f_lm = F(LM);
> > +#else
> > +	unsigned f_gbpages = 0;
> > +	unsigned f_lm = 0;
> > +#endif
> 
> Three too many bare 'unsinged's :-)

Roger that, I'll fix this up.

> > +
> > +	BUILD_BUG_ON(sizeof(kvm_cpu_caps) >
> > +		     sizeof(boot_cpu_data.x86_capability));
> > +
> > +	memcpy(&kvm_cpu_caps, &boot_cpu_data.x86_capability,
> > +	       sizeof(kvm_cpu_caps));
> > +
> > +	kvm_cpu_cap_mask(CPUID_1_EDX,
> > +		F(FPU) | F(VME) | F(DE) | F(PSE) |
> > +		F(TSC) | F(MSR) | F(PAE) | F(MCE) |
> > +		F(CX8) | F(APIC) | 0 /* Reserved */ | F(SEP) |
> > +		F(MTRR) | F(PGE) | F(MCA) | F(CMOV) |
> > +		F(PAT) | F(PSE36) | 0 /* PSN */ | F(CLFLUSH) |
> > +		0 /* Reserved, DS, ACPI */ | F(MMX) |
> > +		F(FXSR) | F(XMM) | F(XMM2) | F(SELFSNOOP) |
> > +		0 /* HTT, TM, Reserved, PBE */
> > +	);
> > +
> > +	kvm_cpu_cap_mask(CPUID_8000_0001_EDX,
> > +		F(FPU) | F(VME) | F(DE) | F(PSE) |
> > +		F(TSC) | F(MSR) | F(PAE) | F(MCE) |
> > +		F(CX8) | F(APIC) | 0 /* Reserved */ | F(SYSCALL) |
> > +		F(MTRR) | F(PGE) | F(MCA) | F(CMOV) |
> > +		F(PAT) | F(PSE36) | 0 /* Reserved */ |
> > +		f_nx | 0 /* Reserved */ | F(MMXEXT) | F(MMX) |
> > +		F(FXSR) | F(FXSR_OPT) | f_gbpages | F(RDTSCP) |
> > +		0 /* Reserved */ | f_lm | F(3DNOWEXT) | F(3DNOW)
> > +	);
> > +
> > +	kvm_cpu_cap_mask(CPUID_1_ECX,
> > +		/* NOTE: MONITOR (and MWAIT) are emulated as NOP,
> > +		 * but *not* advertised to guests via CPUID ! */
> > +		F(XMM3) | F(PCLMULQDQ) | 0 /* DTES64, MONITOR */ |
> > +		0 /* DS-CPL, VMX, SMX, EST */ |
> > +		0 /* TM2 */ | F(SSSE3) | 0 /* CNXT-ID */ | 0 /* Reserved */ |
> > +		F(FMA) | F(CX16) | 0 /* xTPR Update, PDCM */ |
> > +		F(PCID) | 0 /* Reserved, DCA */ | F(XMM4_1) |
> > +		F(XMM4_2) | F(X2APIC) | F(MOVBE) | F(POPCNT) |
> > +		0 /* Reserved*/ | F(AES) | F(XSAVE) | 0 /* OSXSAVE */ | F(AVX) |
> > +		F(F16C) | F(RDRAND)
> > +	);
> 
> I would suggest we order things by CPUID_NUM here, i.e.
> 
> CPUID_1_ECX
> CPUID_1_EDX
> CPUID_7_1_EAX
> CPUID_7_0_EBX
> CPUID_7_ECX
> CPUID_7_EDX
> CPUID_D_1_EAX
> ...

Hmm, generally speaking I agree, but I didn't want to change the ordering
in this patch when moving the code.  Throw a patch on top?  Leave as is?
Something else?
