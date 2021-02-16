Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAEA831C565
	for <lists+kvm@lfdr.de>; Tue, 16 Feb 2021 03:19:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbhBPCTM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Feb 2021 21:19:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:34152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229917AbhBPCQk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Feb 2021 21:16:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1FAC664DEC;
        Tue, 16 Feb 2021 02:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613441759;
        bh=rwPyvSkRaZjNg1e1cChrEfHaJu6ECECq3HBijxdrKA0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KI+hPRNwlmomBsXCCmRkpNwBX5UzgmyFDTuBRn5qOVS0Cww/YXcvl1YVQWzbhGGOy
         rXeXKFdMfaf4R6/3CwyrKcZeDQzqQ2/yxuWruEa9Rbu4MKo5hZIOO6OuF0Q/KJibpi
         nq2S8pmqQNVgBk2yMFVBhvfxYdHhGfw1zWrc3a4ukEq9+x++LTbHnGzbZer93lB0Ji
         KBlmjzXpmWKMbTQ0Xtn2p/lo21gcwsHSpaCAapWjxhHksfaUo4BtO+EA3LBYuPqYXW
         d+urrRIuiUZ1XJ2eUIOk1vsTma3HmFsLS7VRaIhbg8ru5vVoEZO7p+k/6cvKz08x9s
         6mlyQDhQZlecg==
Date:   Tue, 16 Feb 2021 04:15:46 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, luto@kernel.org, dave.hansen@intel.com,
        rick.p.edgecombe@intel.com, haitao.huang@intel.com,
        pbonzini@redhat.com, bp@alien8.de, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, jethro@fortanix.com,
        b.thiel@posteo.de
Subject: Re: [RFC PATCH v5 06/26] x86/cpu/intel: Allow SGX virtualization
 without Launch Control support
Message-ID: <YCsq0uFdzwLrFCMW@kernel.org>
References: <cover.1613221549.git.kai.huang@intel.com>
 <82c304d6f4e8ebfa9b35d1be74360a5004179c5f.1613221549.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82c304d6f4e8ebfa9b35d1be74360a5004179c5f.1613221549.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Feb 14, 2021 at 02:29:05AM +1300, Kai Huang wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> The kernel will currently disable all SGX support if the hardware does
> not support launch control.  Make it more permissive to allow SGX
> virtualization on systems without Launch Control support.  This will
> allow KVM to expose SGX to guests that have less-strict requirements on
> the availability of flexible launch control.
> 
> Improve error message to distinguish between three cases.  There are two
> cases where SGX support is completely disabled:
> 1) SGX has been disabled completely by the BIOS
> 2) SGX LC is locked by the BIOS.  Bare-metal support is disabled because
>    of LC unavailability.  SGX virtualization is unavailable (because of
>    Kconfig).
> One where it is partially available:
> 3) SGX LC is locked by the BIOS.  Bare-metal support is disabled because
>    of LC unavailability.  SGX virtualization is supported.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Co-developed-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
> v4->v5:
> 
>  - No code change.
> 
> v3->v4:
> 
>  - Removed cpu_has(X86_FEATURE_SGX1) check in enable_sgx_any, since it logically
>    is not related to KVM SGX series, per Sean.
>  - Changed declaration of variables to be in reverse-christmas tree style, per
>    Jarkko.
> 
> v2->v3:
> 
>  - Added to use 'enable_sgx_any', per Dave.
>  - Changed to call clear_cpu_cap() directly, rather than using clear_sgx_caps()
>    and clear_sgx_lc().
>  - Changed to use CONFIG_X86_SGX_KVM, instead of CONFIG_X86_SGX_VIRTUALIZATION.
> 
> v1->v2:
> 
>  - Refined commit message per Dave's comments.
>  - Added check to only enable SGX virtualization when VMX is supported, per
>    Dave's comment.
>  - Refined error msg print to explicitly call out SGX virtualization will be
>    supported when LC is locked by BIOS, per Dave's comment.
> 
> ---
>  arch/x86/kernel/cpu/feat_ctl.c | 57 ++++++++++++++++++++++++++--------
>  1 file changed, 44 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/feat_ctl.c b/arch/x86/kernel/cpu/feat_ctl.c
> index 27533a6e04fa..96c370284913 100644
> --- a/arch/x86/kernel/cpu/feat_ctl.c
> +++ b/arch/x86/kernel/cpu/feat_ctl.c
> @@ -105,7 +105,8 @@ early_param("nosgx", nosgx);
>  void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
>  {
>  	bool tboot = tboot_enabled();
> -	bool enable_sgx;
> +	bool enable_sgx_any, enable_sgx_kvm, enable_sgx_driver;
> +	bool enable_vmx;
>  	u64 msr;
>  
>  	if (rdmsrl_safe(MSR_IA32_FEAT_CTL, &msr)) {
> @@ -114,13 +115,21 @@ void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
>  		return;
>  	}
>  
> +	enable_vmx = cpu_has(c, X86_FEATURE_VMX) &&
> +		     IS_ENABLED(CONFIG_KVM_INTEL);

It's less than 100 characters:

        enable_vmx = cpu_has(c, X86_FEATURE_VMX) && IS_ENABLED(CONFIG_KVM_INTEL);

This is better:

        enable_vmx = IS_ENABLED(CONFIG_KVM_INTEL) && cpu_has(c, X86_FEATURE_VMX);

You only want to evaluate cpu_has() if COHNFIG_KVM_INTEL is enabled.

> +
>  	/*
> -	 * Enable SGX if and only if the kernel supports SGX and Launch Control
> -	 * is supported, i.e. disable SGX if the LE hash MSRs can't be written.
> +	 * Separate out SGX driver enabling from KVM.  This allows KVM
> +	 * guests to use SGX even if the kernel SGX driver refuses to
> +	 * use it.  This happens if flexible Faunch Control is not
> +	 * available.
>  	 */
> -	enable_sgx = cpu_has(c, X86_FEATURE_SGX) &&
> -		     cpu_has(c, X86_FEATURE_SGX_LC) &&
> -		     IS_ENABLED(CONFIG_X86_SGX);
> +	enable_sgx_any = cpu_has(c, X86_FEATURE_SGX) &&
> +			 IS_ENABLED(CONFIG_X86_SGX);
> +	enable_sgx_driver = enable_sgx_any &&
> +			    cpu_has(c, X86_FEATURE_SGX_LC);
> +	enable_sgx_kvm = enable_sgx_any && enable_vmx &&
> +			  IS_ENABLED(CONFIG_X86_SGX_KVM);
>  
>  	if (msr & FEAT_CTL_LOCKED)
>  		goto update_caps;
> @@ -136,15 +145,18 @@ void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
>  	 * i.e. KVM is enabled, to avoid unnecessarily adding an attack vector
>  	 * for the kernel, e.g. using VMX to hide malicious code.
>  	 */
> -	if (cpu_has(c, X86_FEATURE_VMX) && IS_ENABLED(CONFIG_KVM_INTEL)) {
> +	if (enable_vmx) {
>  		msr |= FEAT_CTL_VMX_ENABLED_OUTSIDE_SMX;
>  
>  		if (tboot)
>  			msr |= FEAT_CTL_VMX_ENABLED_INSIDE_SMX;
>  	}
>  
> -	if (enable_sgx)
> -		msr |= FEAT_CTL_SGX_ENABLED | FEAT_CTL_SGX_LC_ENABLED;
> +	if (enable_sgx_kvm || enable_sgx_driver) {
> +		msr |= FEAT_CTL_SGX_ENABLED;
> +		if (enable_sgx_driver)
> +			msr |= FEAT_CTL_SGX_LC_ENABLED;
> +	}
>  
>  	wrmsrl(MSR_IA32_FEAT_CTL, msr);
>  
> @@ -167,10 +179,29 @@ void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
>  	}
>  
>  update_sgx:
> -	if (!(msr & FEAT_CTL_SGX_ENABLED) ||
> -	    !(msr & FEAT_CTL_SGX_LC_ENABLED) || !enable_sgx) {
> -		if (enable_sgx)
> -			pr_err_once("SGX disabled by BIOS\n");
> +	if (!(msr & FEAT_CTL_SGX_ENABLED)) {
> +		if (enable_sgx_kvm || enable_sgx_driver)
> +			pr_err_once("SGX disabled by BIOS.\n");
>  		clear_cpu_cap(c, X86_FEATURE_SGX);

Empty line before return statement.

> +		return;
> +	}
> +
> +	/*
> +	 * VMX feature bit may be cleared due to being disabled in BIOS,
> +	 * in which case SGX virtualization cannot be supported either.
> +	 */
> +	if (!cpu_has(c, X86_FEATURE_VMX) && enable_sgx_kvm) {
> +		pr_err_once("SGX virtualization disabled due to lack of VMX.\n");
> +		enable_sgx_kvm = 0;
> +	}
> +
> +	if (!(msr & FEAT_CTL_SGX_LC_ENABLED) && enable_sgx_driver) {
> +		if (!enable_sgx_kvm) {
> +			pr_err_once("SGX Launch Control is locked. Disable SGX.\n");
> +			clear_cpu_cap(c, X86_FEATURE_SGX);
> +		} else {
> +			pr_err_once("SGX Launch Control is locked. Support SGX virtualization only.\n");
> +			clear_cpu_cap(c, X86_FEATURE_SGX_LC);
> +		}
>  	}
>  }
> -- 
> 2.29.2
> 
> 

/Jarkko
