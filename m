Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E575232F132
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 18:30:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbhCERaZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Mar 2021 12:30:25 -0500
Received: from mail.skyhub.de ([5.9.137.197]:50164 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229465AbhCERaG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Mar 2021 12:30:06 -0500
Received: from zn.tnic (p200300ec2f0b95001b26a1a345abd660.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:9500:1b26:a1a3:45ab:d660])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 46BFC1EC0528;
        Fri,  5 Mar 2021 18:30:04 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1614965404;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=L2DznrHs2974hAtcbJbvPMJYMDAjtrQkOfNloB/J18Q=;
        b=OwVefF93ifvJ8TJ6cAegoM4gB4nOErwB5WceW+2rX+dAgQUQoafLsfVikx7oeag4PwkqXE
        7CNJI1j8b+qoF9/J4BaQmbdwUNvIL75wE6lfpJWn8rHt0Q8BTH7cY2Ib+FEybueqyX+poB
        1X3SmYcjaOUtSK150JIasD4Fm+VA5YE=
Date:   Fri, 5 Mar 2021 18:29:57 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Kai Huang <kai.huang@intel.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, seanjc@google.com, jarkko@kernel.org,
        luto@kernel.org, dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, jethro@fortanix.com,
        b.thiel@posteo.de
Subject: Re: [PATCH 06/25] x86/cpu/intel: Allow SGX virtualization without
 Launch Control support
Message-ID: <20210305172957.GE2685@zn.tnic>
References: <cover.1614590788.git.kai.huang@intel.com>
 <12541888ae9ac7f517582aa64d9153feede7aed4.1614590788.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <12541888ae9ac7f517582aa64d9153feede7aed4.1614590788.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 01, 2021 at 10:45:02PM +1300, Kai Huang wrote:
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
> Acked-by: Dave Hansen <dave.hansen@intel.com>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
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

The preferred ordering of variable declarations at the beginning of a
function is reverse fir tree order::

	struct long_struct_name *descriptive_name;
	unsigned long foo, bar;
	unsigned int tmp;
	int ret;


>  	if (rdmsrl_safe(MSR_IA32_FEAT_CTL, &msr)) {
> @@ -114,13 +115,21 @@ void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
>  		return;
>  	}
>  
> +	enable_vmx = cpu_has(c, X86_FEATURE_VMX) &&
> +		     IS_ENABLED(CONFIG_KVM_INTEL);
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

That enable_sgx_any use looks weird. You can get rid of it:

	if (cpu_has(c, X86_FEATURE_SGX) && IS_ENABLED(CONFIG_X86_SGX)) {
		enable_sgx_driver = cpu_has(c, X86_FEATURE_SGX_LC);
		enable_sgx_kvm    = enable_vmx && IS_ENABLED(CONFIG_X86_SGX_KVM);
	}

and yap, let longer lines stick out.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
