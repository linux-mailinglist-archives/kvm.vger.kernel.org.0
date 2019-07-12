Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3C7A67212
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 17:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbfGLPNB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jul 2019 11:13:01 -0400
Received: from mga04.intel.com ([192.55.52.120]:26427 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726318AbfGLPNB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jul 2019 11:13:01 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Jul 2019 08:13:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,483,1557212400"; 
   d="scan'208";a="171580427"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.165])
  by orsmga006.jf.intel.com with ESMTP; 12 Jul 2019 08:13:00 -0700
Date:   Fri, 12 Jul 2019 08:13:00 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Tao Xu <tao3.xu@intel.com>
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, corbet@lwn.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, xiaoyao.li@linux.intel.com,
        jingqi.liu@intel.com
Subject: Re: [PATCH v7 1/3] KVM: x86: add support for user wait instructions
Message-ID: <20190712151300.GB29659@linux.intel.com>
References: <20190712082907.29137-1-tao3.xu@intel.com>
 <20190712082907.29137-2-tao3.xu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190712082907.29137-2-tao3.xu@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 12, 2019 at 04:29:05PM +0800, Tao Xu wrote:
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 46af3a5e9209..a4d5da34b306 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2048,6 +2048,7 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
>  				  SECONDARY_EXEC_ENABLE_INVPCID |
>  				  SECONDARY_EXEC_RDTSCP |
>  				  SECONDARY_EXEC_XSAVES |
> +				  SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE |
>  				  SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY |
>  				  SECONDARY_EXEC_APIC_REGISTER_VIRT |
>  				  SECONDARY_EXEC_ENABLE_VMFUNC);
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index d98eac371c0a..f411c9ae5589 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2247,6 +2247,7 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>  			SECONDARY_EXEC_RDRAND_EXITING |
>  			SECONDARY_EXEC_ENABLE_PML |
>  			SECONDARY_EXEC_TSC_SCALING |
> +			SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE |
>  			SECONDARY_EXEC_PT_USE_GPA |
>  			SECONDARY_EXEC_PT_CONCEAL_VMX |
>  			SECONDARY_EXEC_ENABLE_VMFUNC |
> @@ -3984,6 +3985,25 @@ static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
>  		}
>  	}
>  
> +	if (vmcs_config.cpu_based_2nd_exec_ctrl &
> +		SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE) {

This should be aligned with the beginning of the conditional.
Alternatively, add a vmx_waitpkg_supported() helper, which is fairly
ubiquitous even when there is only a single call site.

> +		/* Exposing WAITPKG only when WAITPKG is exposed */
No need for this comment.  It's also oddly worded, e.g. the second
"exposed" should probably be "enabled"?

> +		bool waitpkg_enabled =
> +			guest_cpuid_has(vcpu, X86_FEATURE_WAITPKG);
> +
> +		if (!waitpkg_enabled)
> +			exec_control &= ~SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE;
> +
> +		if (nested) {
> +			if (waitpkg_enabled)
> +				vmx->nested.msrs.secondary_ctls_high |=
> +					SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE;
> +			else
> +				vmx->nested.msrs.secondary_ctls_high &=
> +					~SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE;
> +		}
> +	}
> +
>  	vmx->secondary_exec_control = exec_control;
>  }
>  
> -- 
> 2.20.1
> 
