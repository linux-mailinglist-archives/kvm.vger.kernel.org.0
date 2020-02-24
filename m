Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B39CE16AA5D
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 16:45:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727893AbgBXPpK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 10:45:10 -0500
Received: from mga02.intel.com ([134.134.136.20]:29575 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727859AbgBXPpK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 10:45:10 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Feb 2020 07:45:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,480,1574150400"; 
   d="scan'208";a="284385389"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by FMSMGA003.fm.intel.com with ESMTP; 24 Feb 2020 07:45:08 -0800
Date:   Mon, 24 Feb 2020 07:45:08 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 30/61] KVM: x86: Handle MPX CPUID adjustment in VMX code
Message-ID: <20200224154508.GA29865@linux.intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
 <20200201185218.24473-31-sean.j.christopherson@intel.com>
 <874kvgow3z.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874kvgow3z.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 24, 2020 at 04:14:56PM +0100, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> 
> > Move the MPX CPUID adjustments into VMX to eliminate an instance of the
> > undesirable "unsigned f_* = *_supported ? F(*) : 0" pattern in the
> > common CPUID handling code.
> >
> > Note, VMX must manually check for kernel support via
> > boot_cpu_has(X86_FEATURE_MPX).
> >
> > No functional change intended.
> >
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >  arch/x86/kvm/cpuid.c   |  3 +--
> >  arch/x86/kvm/vmx/vmx.c | 14 ++++++++++++--
> >  2 files changed, 13 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index cb5870a323cc..09e24d1d731c 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -340,7 +340,6 @@ static int __do_cpuid_func_emulated(struct kvm_cpuid_array *array, u32 func)
> >  static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry)
> >  {
> >  	unsigned f_invpcid = kvm_x86_ops->invpcid_supported() ? F(INVPCID) : 0;
> > -	unsigned f_mpx = kvm_mpx_supported() ? F(MPX) : 0;
> >  	unsigned f_umip = kvm_x86_ops->umip_emulated() ? F(UMIP) : 0;
> >  	unsigned f_intel_pt = kvm_x86_ops->pt_supported() ? F(INTEL_PT) : 0;
> >  	unsigned f_la57;
> > @@ -349,7 +348,7 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry)
> >  	/* cpuid 7.0.ebx */
> >  	const u32 kvm_cpuid_7_0_ebx_x86_features =
> >  		F(FSGSBASE) | F(BMI1) | F(HLE) | F(AVX2) | F(SMEP) |
> > -		F(BMI2) | F(ERMS) | f_invpcid | F(RTM) | f_mpx | F(RDSEED) |
> > +		F(BMI2) | F(ERMS) | f_invpcid | F(RTM) | 0 /*MPX*/ | F(RDSEED) |
> >  		F(ADX) | F(SMAP) | F(AVX512IFMA) | F(AVX512F) | F(AVX512PF) |
> >  		F(AVX512ER) | F(AVX512CD) | F(CLFLUSHOPT) | F(CLWB) | F(AVX512DQ) |
> >  		F(SHA_NI) | F(AVX512BW) | F(AVX512VL) | f_intel_pt;
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 3ff830e2258e..143193fc178e 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -7106,8 +7106,18 @@ static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
> >  
> >  static void vmx_set_supported_cpuid(struct kvm_cpuid_entry2 *entry)
> >  {
> > -	if (entry->function == 1 && nested)
> > -		entry->ecx |= feature_bit(VMX);
> > +	switch (entry->function) {
> > +	case 0x1:
> > +		if (nested)
> > +			cpuid_entry_set(entry, X86_FEATURE_VMX);
> > +		break;
> > +	case 0x7:
> > +		if (boot_cpu_has(X86_FEATURE_MPX) && kvm_mpx_supported())
> > +			cpuid_entry_set(entry, X86_FEATURE_MPX);
> > +		break;
> > +	default:
> > +		break;
> > +	}
> >  }
> >  
> >  static void vmx_request_immediate_exit(struct kvm_vcpu *vcpu)
> 
> The word 'must' in the description seems to work like a trigger for
> reviewers, their brains automatically turn into 'and what if not?' mode
> :-)

This is the second time that sentence has caused confusion, I definitely
need to tweak the changelog.  It's supposed to say something like:

  Note, to maintain existing behavior, VMX must manually check for kernel
  support for MPX by querying boot_cpu_has(X86_FEATURE_MPX).  Previously,
  do_cpuid_7_mask() masked MPX based on boot_cpu_data by invoking
  cpuid_mask() on the associated cpufeatures word, but cpuid_mask() runs
  prior to executing vmx_set_supported_cpuid().
 
> So do I understand correctly that kvm_mpx_supported() (which checks for
> XFEATURE_MASK_BNDREGS/XFEATURE_MASK_BNDCSR) may actually return true
> while 'boot_cpu_has(X86_FEATURE_MPX)' is false?

Yes.  The VMCS capabilities and host capabilities are tracked separately.

> Is this done on purpose, i.e. why don't we filter these out from vmcs_config
> early, similar to SVM?

Most (all?) SVM features that are conditionally available are enumerated
via CPUID, and thus are naturally reflected in boot_cpu_data.

VMX enumerates its features via MSRs, which, except for a few synthetic
flags in word 8 that are maintained for ABI compatibility, aren't reflected
in boot_cpu_data.  It would be possible to update the global vmcs_config,
but separating vmcs_config from boot_cpu_data has a few advantages:

  - Allows KVM full control over using features, e.g. EPT can be toggled
    simply by reloading kvm_intel, whereas controlling it via boot_cpu_data
    would require a host reboot.

  - Instructions like RDSEED, RDRAND and ENCLS are exectuable in VMX
    non-root by default, e.g. KVM needs to know that RDRAND-exiting is
    supported in hardware even if it's "disabled" in the host so that KVM
    can set the exiting control to intercept RDRAND and inject #UD.

> 
> The patch itself looks good, so
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> -- 
> Vitaly
> 
