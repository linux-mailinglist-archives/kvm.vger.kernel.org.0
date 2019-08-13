Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F8D48AEEE
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 07:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726005AbfHMFsP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 01:48:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:21760 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725836AbfHMFsP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 01:48:15 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Aug 2019 22:48:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,380,1559545200"; 
   d="scan'208";a="376191369"
Received: from unknown (HELO localhost) ([10.239.159.128])
  by fmsmga006.fm.intel.com with ESMTP; 12 Aug 2019 22:48:13 -0700
Date:   Tue, 13 Aug 2019 13:49:57 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com, mst@redhat.com,
        rkrcmar@redhat.com, jmattson@google.com
Subject: Re: [PATCH v6 4/8] KVM: VMX: Pass through CET related MSRs to Guest
Message-ID: <20190813054956.GC2432@local-michael-cet-test>
References: <20190725031246.8296-1-weijiang.yang@intel.com>
 <20190725031246.8296-5-weijiang.yang@intel.com>
 <20190812235341.GG4996@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190812235341.GG4996@linux.intel.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 12, 2019 at 04:53:41PM -0700, Sean Christopherson wrote:
> On Thu, Jul 25, 2019 at 11:12:42AM +0800, Yang Weijiang wrote:
> > CET MSRs pass through Guest directly to enhance performance.
> > CET runtime control settings are stored in MSR_IA32_{U,S}_CET,
> > Shadow Stack Pointer(SSP) are stored in MSR_IA32_PL{0,1,2,3}_SSP,
> > SSP table base address is stored in MSR_IA32_INT_SSP_TAB,
> > these MSRs are defined in kernel and re-used here.
> > 
> > MSR_IA32_U_CET and MSR_IA32_PL3_SSP are used for user mode protection,
> > the contents could differ from process to process, therefore,
> > kernel needs to save/restore them during context switch, it makes
> > sense to pass through them so that the guest kernel can
> > use xsaves/xrstors to operate them efficiently. Other MSRs are used
> > for non-user mode protection. See CET spec for detailed info.
> > 
> > The difference between CET VMCS state fields and xsave components is that,
> > the former used for CET state storage during VMEnter/VMExit,
> > whereas the latter used for state retention between Guest task/process
> > switch.
> > 
> > Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
> > Signed-off-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
> > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> > ---
> >  arch/x86/kvm/vmx/vmx.c | 14 ++++++++++++++
> >  1 file changed, 14 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index ce1d6fe21780..ce5d1e45b7a5 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -6952,6 +6952,7 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
> >  static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
> >  {
> >  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> > +	unsigned long *msr_bitmap;
> >  
> >  	if (cpu_has_secondary_exec_ctrls()) {
> >  		vmx_compute_secondary_exec_control(vmx);
> > @@ -6973,6 +6974,19 @@ static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
> >  	if (boot_cpu_has(X86_FEATURE_INTEL_PT) &&
> >  			guest_cpuid_has(vcpu, X86_FEATURE_INTEL_PT))
> >  		update_intel_pt_cfg(vcpu);
> > +
> > +	msr_bitmap = vmx->vmcs01.msr_bitmap;
> > +
> > +	if (guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) ||
> > +	    guest_cpuid_has(vcpu, X86_FEATURE_IBT)) {
> 
> These should be exposed to the guest if and only if they're supported in
> the host and guest, i.e. kvm_supported_xss() needs to be checked.  And,
> again assuming USER and KERNEL can be virtualized independently, the logic
> needs to account for exposting USER but KERNEL and vice versa.
>
this patch serial is supposed to enable both USER and KERNEL mode CET as
long as platform and host kernel support so. I'll add condition check
before pass through correspond MSR to guest OS.

> > +		vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_U_CET, MSR_TYPE_RW);
> > +		vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_S_CET, MSR_TYPE_RW);
> > +		vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_INT_SSP_TAB, MSR_TYPE_RW);
> > +		vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_PL0_SSP, MSR_TYPE_RW);
> > +		vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_PL1_SSP, MSR_TYPE_RW);
> > +		vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_PL2_SSP, MSR_TYPE_RW);
> > +		vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_PL3_SSP, MSR_TYPE_RW);
> 
> The SSP MSRs should only be passed through if the guest has SHSTK, e.g.
> KVM should intercept RDMSR and WRMSR to inject #GP in those cases.
> 
> > +	}
> >  }
> >  
> >  static void vmx_set_supported_cpuid(u32 func, struct kvm_cpuid_entry2 *entry)
> > -- 
> > 2.17.2
> > 
