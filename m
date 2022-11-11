Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 299C4625A9D
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 13:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233591AbiKKMky (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 07:40:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231615AbiKKMkx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 07:40:53 -0500
Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 564BC7B20B;
        Fri, 11 Nov 2022 04:40:51 -0800 (PST)
Received: from quatroqueijos.cascardo.eti.br (unknown [179.93.206.76])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id ADABE422B0;
        Fri, 11 Nov 2022 12:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1668170446;
        bh=iyrlr5D+wgNUuQ68yQgFYSLFe0CfoqbiWi42P9R6HUk=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To;
        b=GnRWtnB7RsNrUkI+caqCoCbmlOsixJt5WK3/a3WUaRmeFrJTiXZdmZVHQzSkqRT7e
         d3PPUS8H9TUp2VccWako36WpSIUrA1tNUsxzP6V8joNkLZJBPMItxT2hUouCTRzD1E
         /3iILHqDghp6QmSE/TvrvtGe8gpzjJ52bYyE/fKqCy4McU5TYWceIvCpiWijbnKBDt
         Uxp4C06szzHirrmsfdIUwMN6eyANVJ5bi68LgEUspQCa9qCRGi6S9o3X4yxBB8iPRI
         wBbnBUjFX4Gt8lI7qksJpG/+8QomsCv+fzX5xUf3ml/NdiiSN1q2vNUyCkBVdu9spD
         LEV2PouNV3nbw==
Date:   Fri, 11 Nov 2022 09:40:34 -0300
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Kim Phillips <kim.phillips@amd.com>,
        Peter Zijlstra <peterz@infradead.org>, x86@kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Juergen Gross <jgross@suse.com>,
        Tony Luck <tony.luck@intel.com>,
        Babu Moger <Babu.Moger@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] x86/speculation: Support Automatic IBRS
Message-ID: <Y25CwmylusloNKsr@quatroqueijos.cascardo.eti.br>
References: <20221104213651.141057-1-kim.phillips@amd.com>
 <20221104213651.141057-3-kim.phillips@amd.com>
 <Y2WJjdY3wwQl9/q9@zn.tnic>
 <Y2ZEinL+wlIX+1Sn@hirez.programming.kicks-ass.net>
 <d413c064-ee9b-5853-9cf1-544adde22c8a@amd.com>
 <Y247gY9NKYi34er6@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y247gY9NKYi34er6@zn.tnic>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 11, 2022 at 01:09:37PM +0100, Borislav Petkov wrote:
> On Mon, Nov 07, 2022 at 04:39:02PM -0600, Kim Phillips wrote:
> > I've started a version that has AUTOIBRS reuse SPECTRE_V2_EIBRS
> > spectre_v2_mitigation enum, but, so far, it's change to bugs.c
> > looks bigger: 58 lines changed vs. 34 (see below).
> 
> It can be smaller. You simply do:
> 
> 	if (cpu_has(c, X86_FEATURE_AUTOIBRS))
> 		setup_force_cpu_cap(X86_FEATURE_IBRS_ENHANCED);
> 
> and the rest should just work - see below.
> 
> And yes, as Peter says, when the user requests something, the user
> should get it. No matter whether it makes sense or not.
> 
> Thx.
> 
> ---
> diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
> index 66d7addf1784..2b77eaee9bd2 100644
> --- a/arch/x86/kernel/cpu/bugs.c
> +++ b/arch/x86/kernel/cpu/bugs.c
> @@ -1005,6 +1005,7 @@ static inline const char *spectre_v2_module_string(void) { return ""; }
>  #endif
>  
>  #define SPECTRE_V2_LFENCE_MSG "WARNING: LFENCE mitigation is not recommended for this CPU, data leaks possible!\n"
> +#define SPECTRE_V2_EIBRS_AMD_MSG "WARNING: AutoIBRS does not need additional RETPOLINE/LFENCE mitigations, not doing them\n"
>  #define SPECTRE_V2_EIBRS_EBPF_MSG "WARNING: Unprivileged eBPF is enabled with eIBRS on, data leaks possible via Spectre v2 BHB attacks!\n"
>  #define SPECTRE_V2_EIBRS_LFENCE_EBPF_SMT_MSG "WARNING: Unprivileged eBPF is enabled with eIBRS+LFENCE mitigation and SMT, data leaks possible via Spectre v2 BHB attacks!\n"
>  #define SPECTRE_V2_IBRS_PERF_MSG "WARNING: IBRS mitigation selected on Enhanced IBRS CPU, this may cause unnecessary performance loss\n"
> @@ -1124,6 +1125,7 @@ spectre_v2_parse_user_cmdline(void)
>  	return SPECTRE_V2_USER_CMD_AUTO;
>  }
>  
> +/* Checks for IBRS versions */
>  static inline bool spectre_v2_in_ibrs_mode(enum spectre_v2_mitigation mode)
>  {
>  	return mode == SPECTRE_V2_IBRS ||
> @@ -1229,7 +1231,7 @@ static const char * const spectre_v2_strings[] = {
>  	[SPECTRE_V2_NONE]			= "Vulnerable",
>  	[SPECTRE_V2_RETPOLINE]			= "Mitigation: Retpolines",
>  	[SPECTRE_V2_LFENCE]			= "Mitigation: LFENCE",
> -	[SPECTRE_V2_EIBRS]			= "Mitigation: Enhanced IBRS",
> +	[SPECTRE_V2_EIBRS]			= "Mitigation: Enhanced / Automatic IBRS",
>  	[SPECTRE_V2_EIBRS_LFENCE]		= "Mitigation: Enhanced IBRS + LFENCE",
>  	[SPECTRE_V2_EIBRS_RETPOLINE]		= "Mitigation: Enhanced IBRS + Retpolines",
>  	[SPECTRE_V2_IBRS]			= "Mitigation: IBRS",
> @@ -1247,6 +1249,7 @@ static const struct {
>  	{ "retpoline,lfence",	SPECTRE_V2_CMD_RETPOLINE_LFENCE,  false },
>  	{ "retpoline,generic",	SPECTRE_V2_CMD_RETPOLINE_GENERIC, false },
>  	{ "eibrs",		SPECTRE_V2_CMD_EIBRS,		  false },
> +	{ "autoibrs",		SPECTRE_V2_CMD_EIBRS,		  false },
>  	{ "eibrs,lfence",	SPECTRE_V2_CMD_EIBRS_LFENCE,	  false },
>  	{ "eibrs,retpoline",	SPECTRE_V2_CMD_EIBRS_RETPOLINE,	  false },
>  	{ "auto",		SPECTRE_V2_CMD_AUTO,		  false },
> @@ -1300,7 +1303,7 @@ static enum spectre_v2_mitigation_cmd __init spectre_v2_parse_cmdline(void)
>  	     cmd == SPECTRE_V2_CMD_EIBRS_LFENCE ||
>  	     cmd == SPECTRE_V2_CMD_EIBRS_RETPOLINE) &&
>  	    !boot_cpu_has(X86_FEATURE_IBRS_ENHANCED)) {
> -		pr_err("%s selected but CPU doesn't have eIBRS. Switching to AUTO select\n",
> +		pr_err("%s selected but CPU doesn't have Enhanced or Automatic IBRS. Switching to AUTO select\n",
>  		       mitigation_options[i].option);
>  		return SPECTRE_V2_CMD_AUTO;
>  	}
> @@ -1474,11 +1477,19 @@ static void __init spectre_v2_select_mitigation(void)
>  		break;
>  
>  	case SPECTRE_V2_CMD_EIBRS_LFENCE:
> -		mode = SPECTRE_V2_EIBRS_LFENCE;
> +		if (boot_cpu_has(X86_FEATURE_AUTOIBRS)) {
> +			pr_err(SPECTRE_V2_EIBRS_AMD_MSG);
> +			mode = SPECTRE_V2_EIBRS;
> +		} else
> +			mode = SPECTRE_V2_EIBRS_LFENCE;
>  		break;
>  
>  	case SPECTRE_V2_CMD_EIBRS_RETPOLINE:
> -		mode = SPECTRE_V2_EIBRS_RETPOLINE;
> +		if (boot_cpu_has(X86_FEATURE_AUTOIBRS)) {
> +			pr_err(SPECTRE_V2_EIBRS_AMD_MSG);
> +			mode = SPECTRE_V2_EIBRS;
> +		} else
> +			mode = SPECTRE_V2_EIBRS_RETPOLINE;
>  		break;
>  	}
>  

I am confused here. Isn't the agreement that the user should get what they
asked for? That is, instead of warning and changing the mode to
SPECTRE_V2_EIBRS, the kernel should still use lfence or retpoline as requested?

The point of those options was to protect against Branch History Injection
attacks and Intra-Mode Branch Target Injection attacks. The first one might not
affect the CPUs that support AUTOIBRS, though we haven't heard that.

The second one (IMBTI) is very likely still possible with AUTOIBRS and
retpolines should still protect against those attacks. So users who want to be
paranoid should still be able to opt for "eibrs,retpoline" and have retpolines
enabled.

Cascardo.

> @@ -1486,8 +1497,12 @@ static void __init spectre_v2_select_mitigation(void)
>  		pr_err(SPECTRE_V2_EIBRS_EBPF_MSG);
>  
>  	if (spectre_v2_in_ibrs_mode(mode)) {
> -		x86_spec_ctrl_base |= SPEC_CTRL_IBRS;
> -		write_spec_ctrl_current(x86_spec_ctrl_base, true);
> +		if (boot_cpu_has(X86_FEATURE_AUTOIBRS)) {
> +			msr_set_bit(MSR_EFER, _EFER_AUTOIBRS);
> +		} else {
> +			x86_spec_ctrl_base |= SPEC_CTRL_IBRS;
> +			write_spec_ctrl_current(x86_spec_ctrl_base, true);
> +		}
>  	}
>  
>  	switch (mode) {
> @@ -1571,8 +1586,8 @@ static void __init spectre_v2_select_mitigation(void)
>  	/*
>  	 * Retpoline protects the kernel, but doesn't protect firmware.  IBRS
>  	 * and Enhanced IBRS protect firmware too, so enable IBRS around
> -	 * firmware calls only when IBRS / Enhanced IBRS aren't otherwise
> -	 * enabled.
> +	 * firmware calls only when IBRS / Enhanced / Automatic IBRS aren't
> +	 * otherwise enabled.
>  	 *
>  	 * Use "mode" to check Enhanced IBRS instead of boot_cpu_has(), because
>  	 * the user might select retpoline on the kernel command line and if
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index 73cc546e024d..45e3670bdaaf 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -1341,6 +1344,10 @@ static void __init cpu_set_bug_bits(struct cpuinfo_x86 *c)
>  	if (ia32_cap & ARCH_CAP_IBRS_ALL)
>  		setup_force_cpu_cap(X86_FEATURE_IBRS_ENHANCED);
>  
> +	/* AMDs AutoIBRS is equivalent to Intel's eIBRS - use the Intel flag. */
> +	if (cpu_has(c, X86_FEATURE_AUTOIBRS))
> +		setup_force_cpu_cap(X86_FEATURE_IBRS_ENHANCED);
> +
>  	if (!cpu_matches(cpu_vuln_whitelist, NO_MDS) &&
>  	    !(ia32_cap & ARCH_CAP_MDS_NO)) {
>  		setup_force_cpu_bug(X86_BUG_MDS);
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette
