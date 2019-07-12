Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEAE5672C8
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 17:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbfGLPwD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jul 2019 11:52:03 -0400
Received: from mga07.intel.com ([134.134.136.100]:50651 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726907AbfGLPwD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jul 2019 11:52:03 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Jul 2019 08:52:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,483,1557212400"; 
   d="scan'208";a="177539011"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.165])
  by orsmga002.jf.intel.com with ESMTP; 12 Jul 2019 08:52:02 -0700
Date:   Fri, 12 Jul 2019 08:52:02 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Tao Xu <tao3.xu@intel.com>
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, corbet@lwn.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, xiaoyao.li@linux.intel.com,
        jingqi.liu@intel.com
Subject: Re: [PATCH v7 2/3] KVM: vmx: Emulate MSR IA32_UMWAIT_CONTROL
Message-ID: <20190712155202.GC29659@linux.intel.com>
References: <20190712082907.29137-1-tao3.xu@intel.com>
 <20190712082907.29137-3-tao3.xu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190712082907.29137-3-tao3.xu@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 12, 2019 at 04:29:06PM +0800, Tao Xu wrote:
> diff --git a/arch/x86/kernel/cpu/umwait.c b/arch/x86/kernel/cpu/umwait.c
> index 6a204e7336c1..631152a67c6e 100644
> --- a/arch/x86/kernel/cpu/umwait.c
> +++ b/arch/x86/kernel/cpu/umwait.c
> @@ -15,7 +15,8 @@
>   * Cache IA32_UMWAIT_CONTROL MSR. This is a systemwide control. By default,
>   * umwait max time is 100000 in TSC-quanta and C0.2 is enabled
>   */
> -static u32 umwait_control_cached = UMWAIT_CTRL_VAL(100000, UMWAIT_C02_ENABLE);
> +u32 umwait_control_cached = UMWAIT_CTRL_VAL(100000, UMWAIT_C02_ENABLE);
> +EXPORT_SYMBOL_GPL(umwait_control_cached);

It'd probably be better to add an accessor to expose umwait_control_cached
given that umwait.c is using {READ,WRITE}_ONCE() and there shouldn't be a
need to write it outside of umwait.c.

>  /*
>   * Serialize access to umwait_control_cached and IA32_UMWAIT_CONTROL MSR in
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index f411c9ae5589..0787f140d155 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1676,6 +1676,12 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  #endif
>  	case MSR_EFER:
>  		return kvm_get_msr_common(vcpu, msr_info);
> +	case MSR_IA32_UMWAIT_CONTROL:
> +		if (!msr_info->host_initiated && !vmx_has_waitpkg(vmx))
> +			return 1;
> +
> +		msr_info->data = vmx->msr_ia32_umwait_control;
> +		break;
>  	case MSR_IA32_SPEC_CTRL:
>  		if (!msr_info->host_initiated &&
>  		    !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL))
> @@ -1838,6 +1844,16 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  			return 1;
>  		vmcs_write64(GUEST_BNDCFGS, data);
>  		break;
> +	case MSR_IA32_UMWAIT_CONTROL:
> +		if (!msr_info->host_initiated && !vmx_has_waitpkg(vmx))
> +			return 1;
> +
> +		/* The reserved bit IA32_UMWAIT_CONTROL[1] should be zero */
> +		if (data & BIT_ULL(1))
> +			return 1;
> +
> +		vmx->msr_ia32_umwait_control = data;

The SDM only defines bits 31:0, and the kernel uses a u32 to cache its
value.  I assume bits 63:32 are reserved?  I'm guessing we also need an
SDM update...

> +		break;
>  	case MSR_IA32_SPEC_CTRL:
>  		if (!msr_info->host_initiated &&
>  		    !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL))
> @@ -4139,6 +4155,8 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>  	vmx->rmode.vm86_active = 0;
>  	vmx->spec_ctrl = 0;
>  
> +	vmx->msr_ia32_umwait_control = 0;
> +
>  	vcpu->arch.microcode_version = 0x100000000ULL;
>  	vmx->vcpu.arch.regs[VCPU_REGS_RDX] = get_rdx_init_val();
>  	kvm_set_cr8(vcpu, 0);
> @@ -6352,6 +6370,19 @@ static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
>  					msrs[i].host, false);
>  }
>  
