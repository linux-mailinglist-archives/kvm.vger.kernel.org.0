Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E579916264C
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 13:42:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbgBRMm2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 07:42:28 -0500
Received: from mga02.intel.com ([134.134.136.20]:13865 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726512AbgBRMm2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 07:42:28 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Feb 2020 04:42:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,456,1574150400"; 
   d="scan'208";a="228722002"
Received: from local-michael-cet-test.sh.intel.com (HELO localhost) ([10.239.159.128])
  by orsmga008.jf.intel.com with ESMTP; 18 Feb 2020 04:42:24 -0800
Date:   Tue, 18 Feb 2020 20:46:20 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        jmattson@google.com, aaronlewis@google.com
Subject: Re: [RFC PATCH 1/2] KVM: CPUID: Enable supervisor XSAVE states in
 CPUID enumeration and XSS
Message-ID: <20200218124620.GB20460@local-michael-cet-test.sh.intel.com>
References: <20200211065706.3462-1-weijiang.yang@intel.com>
 <a75a0e16-198d-9c96-3a63-d09a93909c0f@intel.com>
 <20200217130355.GA10854@local-michael-cet-test.sh.intel.com>
 <2125c47d-06c5-d559-c95c-a55a71790f31@intel.com>
 <44baa7f5-c643-27d5-b2d7-fd03e78ad2a5@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <44baa7f5-c643-27d5-b2d7-fd03e78ad2a5@intel.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 18, 2020 at 01:44:17PM +0800, Xiaoyao Li wrote:
> On 2/17/2020 9:20 PM, Xiaoyao Li wrote:
> > On 2/17/2020 9:03 PM, Yang Weijiang wrote:
> > > On Mon, Feb 17, 2020 at 12:26:51PM +0800, Xiaoyao Li wrote:
> > > > On 2/11/2020 2:57 PM, Yang Weijiang wrote:
> > > > > CPUID.(EAX=DH, ECX={i}H i>=0) enumerates XSAVE related
> > > > > leaves/sub-leaves,
> > > > > +extern int host_xss;
> > > > > +u64 kvm_supported_xss(void)
> > > > > +{
> > > > > +    return KVM_SUPPORTED_XSS & host_xss;
> > > > > +}
> > > > > +
> > > > 
> > > > How about using a global variable, supported_xss, instead of
> > > > calculating the
> > > > mask on every call. Just like what Sean posted on
> > > > https://lore.kernel.org/kvm/20200201185218.24473-21-sean.j.christopherson@intel.com/
> > > > 
> > > > 
> > > Thanks Xiaoyao for the comments!
> > > Good suggestion, I'll change it in next version.
> > > 
> > > > >    #define F(x) bit(X86_FEATURE_##x)
> > > > >    int kvm_update_cpuid(struct kvm_vcpu *vcpu)
> > > > > @@ -112,10 +118,17 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
> > > > >            vcpu->arch.guest_xstate_size = best->ebx =
> > > > >                xstate_required_size(vcpu->arch.xcr0, false);
> > > > >        }
> > > > > -
> > > > >        best = kvm_find_cpuid_entry(vcpu, 0xD, 1);
> > > > > -    if (best && (best->eax & (F(XSAVES) | F(XSAVEC))))
> > > > > -        best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
> > > > > +    if (best && (best->eax & (F(XSAVES) | F(XSAVEC)))) {
> > > > > +        u64 xstate = vcpu->arch.xcr0 | vcpu->arch.ia32_xss;
> > > > > +
> > > > > +        best->ebx = xstate_required_size(xstate, true);
> > > > > +        vcpu->arch.guest_supported_xss =
> > > > > +            (best->ecx | ((u64)best->edx << 32)) &
> > > > > +            kvm_supported_xss();
> > > > > +    } else {
> > > > > +        vcpu->arch.guest_supported_xss = 0;
> > > > > +    }
> 
> also here should be something like below:
> 
> if (best) {
> 	if (best->eax & (F(XSAVES) | F(XSAVEC)))) {
> 		u64 xstate = vcpu->arch.xcr0 | vcpu->arch.ia32_xss;
> 		best->ebx = xstate_required_size(xstate, true);
> 	}
> 
> 	if (best->eax & F(XSAVES) {
> 		vcpu->arch.guest_supported_xss =
> 			(best->ecx | ((u64)best->edx << 32)) &
> 			kvm_supported_xss();
> 	} else {
> 		best->ecx = 0;
> 		best->edx = 0;
> 		vcpu->arch.guest_supported_xss = 0;
> 	}
> }
Right, to keep it consistent with CPUID enumeration, thanks for review!

> 
> > > > >        /*
> > > > >         * The existing code assumes virtual address is
> > > > > 48-bit or 57-bit in the
> > > > > @@ -426,6 +439,56 @@ static inline void
> > > > > do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry, int index)
> > > > >        }
> > > > >    }
> > > > > +static inline bool do_cpuid_0xd_mask(struct
> > > > > kvm_cpuid_entry2 *entry, int index)
> > > > > +{
> > > > > +    unsigned int f_xsaves = kvm_x86_ops->xsaves_supported()
> > > > > ? F(XSAVES) : 0;
> > > > > +    /* cpuid 0xD.1.eax */
> > > > > +    const u32 kvm_cpuid_D_1_eax_x86_features =
> > > > > +        F(XSAVEOPT) | F(XSAVEC) | F(XGETBV1) | f_xsaves;
> > > > > +    u64 u_supported = kvm_supported_xcr0();
> > > > > +    u64 s_supported = kvm_supported_xss();
> > > > > +    u64 supported;
> > > > > +
> > > > > +    switch (index) {
> > > > > +    case 0:
> > > > > +        if (!u_supported) {
> > > > > +            entry->eax = 0;
> > > > > +            entry->ebx = 0;
> > > > > +            entry->ecx = 0;
> > > > > +            entry->edx = 0;
> > > > > +            return false;
> > > > > +        }
> > > > > +        entry->eax &= u_supported;
> > > > > +        entry->ebx = xstate_required_size(u_supported, false);
> > > > > +        entry->ecx = entry->ebx;
> > > > > +        entry->edx &= u_supported >> 32;
> > > > > +        break;
> > > > > +    case 1:
> > > > > +        supported = u_supported | s_supported;
> > > > > +        entry->eax &= kvm_cpuid_D_1_eax_x86_features;
> > > > > +        cpuid_mask(&entry->eax, CPUID_D_1_EAX);
> > > > > +        entry->ebx = 0;
> > > > > +        entry->edx &= s_supported >> 32;
> > > > > +        entry->ecx &= s_supported;
> > > > 
> > > > We'd better initialize msr_ia32_xss bitmap (entry->ecx &
> > > > entry-edx) as zeros
> > > > here.
> > > Hmm, explicit setting the MSR to 0 is good in this case, but there's
> > > implied
> > > flow to ensure guest MSR_IA32_XSS will be 0 if entry->ecx and
> > > entry->edx are 0s.
> > > In above kvm_update_cpuid(), vcpu->arch.guest_supported_xss is set to 0
> > > when they're 0s. this masks guest cannot set non-zero value to this
> > > MSR. And in kvm_vcpu_reset(), vcpu->arch.ia32_xss is initialized to 0,
> > > in kvm_load_guest_xsave_state() MSR_IA32_XSS is set to ia32_xss,
> > > therefore the MSR is kept to 0.
> > 
> > Sorry, I think what I said "msr_ia32_xss bitmap" misled you.
> > 
> > "msr_ia32_xss bitmap" is not MSR_IA32_XSS,
> > but the (entry->ecx | entry->edx >> 32) of cpuid.D_1
> > 
> > I meant we'd better set entry->ecx and entry->edx to 0 here.
> > 
> > > > 
> > > > > +        if (entry->eax & (F(XSAVES) | F(XSAVEC)))
> > > > > +            entry->ebx = xstate_required_size(supported, true);
> > > > 
> > > > And setup msr_ia32_xss bitmap based on the s_supported within
> > > > this condition
> > > > when F(XSAVES) is supported.
> > > 
> > 
> > And set entry->ecx & entry->edx only when F(XSAVES) is supported.
> > 
> > > IIUC, both XSAVEC and XSAVES use compacted format of the extended
> > > region, so if XSAVEC is supported while XSAVES is not, guest still can
> > > get correct size, so in existing code the two bits are ORed.
> > 
> > Yeah, but entry->ecx and entry->edx should be non-zero only when
> > F(XSAVES) is set.
> > 
> > > > 
> > > > > +        break;
> > > > > +    default:
> > > > > +        supported = (entry->ecx & 0x1) ? s_supported : u_supported;
> > > > > +        if (!(supported & (BIT_ULL(index)))) {
> > > > > +            entry->eax = 0;
> > > > > +            entry->ebx = 0;
> > > > > +            entry->ecx = 0;
> > > > > +            entry->edx = 0;
> > > > > +            return false;
> > > > > +        }
> > > > > +        if (entry->ecx & 0x1)
> > > > > +            entry->ebx = 0;
> > > > > +        break;
> > > > > +    }
> > > > > +    return true;
> > > > > +}
> > > > > +
> > > > >    static inline int __do_cpuid_func(struct kvm_cpuid_entry2
> > > > > *entry, u32 function,
> > > > >                      int *nent, int maxnent)
> > > > >    {
> > > > > @@ -440,7 +503,6 @@ static inline int __do_cpuid_func(struct
> > > > > kvm_cpuid_entry2 *entry, u32 function,
> > > > >        unsigned f_lm = 0;
> > > > >    #endif
> > > > >        unsigned f_rdtscp = kvm_x86_ops->rdtscp_supported() ?
> > > > > F(RDTSCP) : 0;
> > > > > -    unsigned f_xsaves = kvm_x86_ops->xsaves_supported() ?
> > > > > F(XSAVES) : 0;
> > > > >        unsigned f_intel_pt = kvm_x86_ops->pt_supported() ?
> > > > > F(INTEL_PT) : 0;
> > > > >        /* cpuid 1.edx */
> > > > > @@ -495,10 +557,6 @@ static inline int
> > > > > __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32
> > > > > function,
> > > > >            F(ACE2) | F(ACE2_EN) | F(PHE) | F(PHE_EN) |
> > > > >            F(PMM) | F(PMM_EN);
> > > > > -    /* cpuid 0xD.1.eax */
> > > > > -    const u32 kvm_cpuid_D_1_eax_x86_features =
> > > > > -        F(XSAVEOPT) | F(XSAVEC) | F(XGETBV1) | f_xsaves;
> > > > > -
> > > > >        /* all calls to cpuid_count() should be made on the same cpu */
> > > > >        get_cpu();
> > > > > @@ -639,38 +697,21 @@ static inline int
> > > > > __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32
> > > > > function,
> > > > >            break;
> > > > >        }
> > > > >        case 0xd: {
> > > > > -        int idx, i;
> > > > > -        u64 supported = kvm_supported_xcr0();
> > > > > +        int i, idx;
> > > > > -        entry->eax &= supported;
> > > > > -        entry->ebx = xstate_required_size(supported, false);
> > > > > -        entry->ecx = entry->ebx;
> > > > > -        entry->edx &= supported >> 32;
> > > > > -        if (!supported)
> > > > > +        if (!do_cpuid_0xd_mask(&entry[0], 0))
> > > > >                break;
> > > > > -
> > > > > -        for (idx = 1, i = 1; idx < 64; ++idx) {
> > > > > -            u64 mask = ((u64)1 << idx);
> > > > > +        for (i = 1, idx = 1; idx < 64; ++idx) {
> > > > >                if (*nent >= maxnent)
> > > > >                    goto out;
> > > > > -
> > > > >                do_host_cpuid(&entry[i], function, idx);
> > > > > -            if (idx == 1) {
> > > > > -                entry[i].eax &= kvm_cpuid_D_1_eax_x86_features;
> > > > > -                cpuid_mask(&entry[i].eax, CPUID_D_1_EAX);
> > > > > -                entry[i].ebx = 0;
> > > > > -                if (entry[i].eax & (F(XSAVES)|F(XSAVEC)))
> > > > > -                    entry[i].ebx =
> > > > > -                        xstate_required_size(supported,
> > > > > -                                     true);
> > > > > -            } else {
> > > > > -                if (entry[i].eax == 0 || !(supported & mask))
> > > > > -                    continue;
> > > > > -                if (WARN_ON_ONCE(entry[i].ecx & 1))
> > > > > -                    continue;
> > > > > -            }
> > > > > -            entry[i].ecx = 0;
> > > > > -            entry[i].edx = 0;
> > > > > +
> > > > > +            if (entry[i].eax == 0 && entry[i].ebx == 0 &&
> > > > > +                entry[i].ecx == 0 && entry[i].edx == 0)
> > > > > +                continue;
> > > > > +
> > > > > +            if (!do_cpuid_0xd_mask(&entry[i], idx))
> > > > > +                continue;
> > > > >                ++*nent;
> > > > >                ++i;
> > > > >            }
> > >   >
> > > 
> > 
