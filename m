Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21E3035087
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2019 21:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbfFDT7D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jun 2019 15:59:03 -0400
Received: from mga11.intel.com ([192.55.52.93]:34707 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726238AbfFDT7D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jun 2019 15:59:03 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Jun 2019 12:59:02 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga007.jf.intel.com with ESMTP; 04 Jun 2019 12:59:02 -0700
Date:   Tue, 4 Jun 2019 12:59:02 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, mst@redhat.com, rkrcmar@redhat.com,
        jmattson@google.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, yu-cheng.yu@intel.com
Subject: Re: [PATCH v5 4/8] KVM: VMX: Pass through CET related MSRs to Guest
Message-ID: <20190604195902.GB7476@linux.intel.com>
References: <20190522070101.7636-1-weijiang.yang@intel.com>
 <20190522070101.7636-5-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190522070101.7636-5-weijiang.yang@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 22, 2019 at 03:00:57PM +0800, Yang Weijiang wrote:
> CET MSRs pass through Guest directly to enhance performance.
> CET runtime control settings are stored in MSR_IA32_{U,S}_CET,
> Shadow Stack Pointer(SSP) are presented in MSR_IA32_PL{0,1,2,3}_SSP,
> SSP table base address is stored in MSR_IA32_INT_SSP_TAB,
> these MSRs are defined in kernel and re-used here.
> 
> MSR_IA32_U_CET and MSR_IA32_PL3_SSP are used for user mode protection,
> the contents could differ from process to process, therefore,
> kernel needs to save/restore them during context switch, so it makes
> sense to pass through them so that the guest kernel can
> use xsaves/xrstors to operate them efficiently. Ohter MSRs are used
> for non-user mode protection. See CET spec for detailed info.
> 
> The difference between CET VMCS state fields and xsave components is,
> the former used for CET state storage during VMEnter/VMExit,
> whereas the latter used for state retention between Guest task/process
> switch.
> 
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 574428375ff9..9321da538f65 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6942,6 +6942,7 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
>  static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> +	unsigned long *msr_bitmap;
>  
>  	if (cpu_has_secondary_exec_ctrls()) {
>  		vmx_compute_secondary_exec_control(vmx);
> @@ -6963,6 +6964,19 @@ static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
>  	if (boot_cpu_has(X86_FEATURE_INTEL_PT) &&
>  			guest_cpuid_has(vcpu, X86_FEATURE_INTEL_PT))
>  		update_intel_pt_cfg(vcpu);
> +
> +	msr_bitmap = vmx->vmcs01.msr_bitmap;
> +
> +	if (guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) ||
> +	    guest_cpuid_has(vcpu, X86_FEATURE_IBT)) {
> +		vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_U_CET, MSR_TYPE_RW);
> +		vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_S_CET, MSR_TYPE_RW);
> +		vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_INT_SSP_TAB, MSR_TYPE_RW);
> +		vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_PL0_SSP, MSR_TYPE_RW);
> +		vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_PL1_SSP, MSR_TYPE_RW);
> +		vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_PL2_SSP, MSR_TYPE_RW);
> +		vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_PL3_SSP, MSR_TYPE_RW);
> +	}
>  }
>  
>  static void vmx_set_supported_cpuid(u32 func, struct kvm_cpuid_entry2 *entry)
> @@ -7163,6 +7177,7 @@ static void __pi_post_block(struct kvm_vcpu *vcpu)
>  		spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
>  		vcpu->pre_pcpu = -1;
>  	}
> +

Spurious whitespace change.

>  }
>  
>  /*
> -- 
> 2.17.2
> 
