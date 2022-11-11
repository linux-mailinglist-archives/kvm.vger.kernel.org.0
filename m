Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7D4625A46
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 13:09:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233483AbiKKMJs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 07:09:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbiKKMJr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 07:09:47 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41AB863F4;
        Fri, 11 Nov 2022 04:09:44 -0800 (PST)
Received: from zn.tnic (p200300ea9733e727329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e727:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 4FEC21EC042F;
        Fri, 11 Nov 2022 13:09:42 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1668168582;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=85fw3BZSc2Eju860xkeDyqGes4l/dOqnSw//0ViIseU=;
        b=qCUvLYePXPFnGUN/2ZZqvkJTuEe7/8r41qfaRWWyMdrKEbYkTFbFDGSoGF7yiwUsLfHyke
        p8pCpZyaThq2AJvIOfXaG1BpJHMRAv6Ax6/NbEddJ400GatF6QOpNf2GTxPNzUHrz8m7Fm
        7LvzAm3lqJSetHKgerWPtJRoaLMxhFw=
Date:   Fri, 11 Nov 2022 13:09:37 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Kim Phillips <kim.phillips@amd.com>
Cc:     Peter Zijlstra <peterz@infradead.org>, x86@kernel.org,
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
Message-ID: <Y247gY9NKYi34er6@zn.tnic>
References: <20221104213651.141057-1-kim.phillips@amd.com>
 <20221104213651.141057-3-kim.phillips@amd.com>
 <Y2WJjdY3wwQl9/q9@zn.tnic>
 <Y2ZEinL+wlIX+1Sn@hirez.programming.kicks-ass.net>
 <d413c064-ee9b-5853-9cf1-544adde22c8a@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <d413c064-ee9b-5853-9cf1-544adde22c8a@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 07, 2022 at 04:39:02PM -0600, Kim Phillips wrote:
> I've started a version that has AUTOIBRS reuse SPECTRE_V2_EIBRS
> spectre_v2_mitigation enum, but, so far, it's change to bugs.c
> looks bigger: 58 lines changed vs. 34 (see below).

It can be smaller. You simply do:

	if (cpu_has(c, X86_FEATURE_AUTOIBRS))
		setup_force_cpu_cap(X86_FEATURE_IBRS_ENHANCED);

and the rest should just work - see below.

And yes, as Peter says, when the user requests something, the user
should get it. No matter whether it makes sense or not.

Thx.

---
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 66d7addf1784..2b77eaee9bd2 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1005,6 +1005,7 @@ static inline const char *spectre_v2_module_string(void) { return ""; }
 #endif
 
 #define SPECTRE_V2_LFENCE_MSG "WARNING: LFENCE mitigation is not recommended for this CPU, data leaks possible!\n"
+#define SPECTRE_V2_EIBRS_AMD_MSG "WARNING: AutoIBRS does not need additional RETPOLINE/LFENCE mitigations, not doing them\n"
 #define SPECTRE_V2_EIBRS_EBPF_MSG "WARNING: Unprivileged eBPF is enabled with eIBRS on, data leaks possible via Spectre v2 BHB attacks!\n"
 #define SPECTRE_V2_EIBRS_LFENCE_EBPF_SMT_MSG "WARNING: Unprivileged eBPF is enabled with eIBRS+LFENCE mitigation and SMT, data leaks possible via Spectre v2 BHB attacks!\n"
 #define SPECTRE_V2_IBRS_PERF_MSG "WARNING: IBRS mitigation selected on Enhanced IBRS CPU, this may cause unnecessary performance loss\n"
@@ -1124,6 +1125,7 @@ spectre_v2_parse_user_cmdline(void)
 	return SPECTRE_V2_USER_CMD_AUTO;
 }
 
+/* Checks for IBRS versions */
 static inline bool spectre_v2_in_ibrs_mode(enum spectre_v2_mitigation mode)
 {
 	return mode == SPECTRE_V2_IBRS ||
@@ -1229,7 +1231,7 @@ static const char * const spectre_v2_strings[] = {
 	[SPECTRE_V2_NONE]			= "Vulnerable",
 	[SPECTRE_V2_RETPOLINE]			= "Mitigation: Retpolines",
 	[SPECTRE_V2_LFENCE]			= "Mitigation: LFENCE",
-	[SPECTRE_V2_EIBRS]			= "Mitigation: Enhanced IBRS",
+	[SPECTRE_V2_EIBRS]			= "Mitigation: Enhanced / Automatic IBRS",
 	[SPECTRE_V2_EIBRS_LFENCE]		= "Mitigation: Enhanced IBRS + LFENCE",
 	[SPECTRE_V2_EIBRS_RETPOLINE]		= "Mitigation: Enhanced IBRS + Retpolines",
 	[SPECTRE_V2_IBRS]			= "Mitigation: IBRS",
@@ -1247,6 +1249,7 @@ static const struct {
 	{ "retpoline,lfence",	SPECTRE_V2_CMD_RETPOLINE_LFENCE,  false },
 	{ "retpoline,generic",	SPECTRE_V2_CMD_RETPOLINE_GENERIC, false },
 	{ "eibrs",		SPECTRE_V2_CMD_EIBRS,		  false },
+	{ "autoibrs",		SPECTRE_V2_CMD_EIBRS,		  false },
 	{ "eibrs,lfence",	SPECTRE_V2_CMD_EIBRS_LFENCE,	  false },
 	{ "eibrs,retpoline",	SPECTRE_V2_CMD_EIBRS_RETPOLINE,	  false },
 	{ "auto",		SPECTRE_V2_CMD_AUTO,		  false },
@@ -1300,7 +1303,7 @@ static enum spectre_v2_mitigation_cmd __init spectre_v2_parse_cmdline(void)
 	     cmd == SPECTRE_V2_CMD_EIBRS_LFENCE ||
 	     cmd == SPECTRE_V2_CMD_EIBRS_RETPOLINE) &&
 	    !boot_cpu_has(X86_FEATURE_IBRS_ENHANCED)) {
-		pr_err("%s selected but CPU doesn't have eIBRS. Switching to AUTO select\n",
+		pr_err("%s selected but CPU doesn't have Enhanced or Automatic IBRS. Switching to AUTO select\n",
 		       mitigation_options[i].option);
 		return SPECTRE_V2_CMD_AUTO;
 	}
@@ -1474,11 +1477,19 @@ static void __init spectre_v2_select_mitigation(void)
 		break;
 
 	case SPECTRE_V2_CMD_EIBRS_LFENCE:
-		mode = SPECTRE_V2_EIBRS_LFENCE;
+		if (boot_cpu_has(X86_FEATURE_AUTOIBRS)) {
+			pr_err(SPECTRE_V2_EIBRS_AMD_MSG);
+			mode = SPECTRE_V2_EIBRS;
+		} else
+			mode = SPECTRE_V2_EIBRS_LFENCE;
 		break;
 
 	case SPECTRE_V2_CMD_EIBRS_RETPOLINE:
-		mode = SPECTRE_V2_EIBRS_RETPOLINE;
+		if (boot_cpu_has(X86_FEATURE_AUTOIBRS)) {
+			pr_err(SPECTRE_V2_EIBRS_AMD_MSG);
+			mode = SPECTRE_V2_EIBRS;
+		} else
+			mode = SPECTRE_V2_EIBRS_RETPOLINE;
 		break;
 	}
 
@@ -1486,8 +1497,12 @@ static void __init spectre_v2_select_mitigation(void)
 		pr_err(SPECTRE_V2_EIBRS_EBPF_MSG);
 
 	if (spectre_v2_in_ibrs_mode(mode)) {
-		x86_spec_ctrl_base |= SPEC_CTRL_IBRS;
-		write_spec_ctrl_current(x86_spec_ctrl_base, true);
+		if (boot_cpu_has(X86_FEATURE_AUTOIBRS)) {
+			msr_set_bit(MSR_EFER, _EFER_AUTOIBRS);
+		} else {
+			x86_spec_ctrl_base |= SPEC_CTRL_IBRS;
+			write_spec_ctrl_current(x86_spec_ctrl_base, true);
+		}
 	}
 
 	switch (mode) {
@@ -1571,8 +1586,8 @@ static void __init spectre_v2_select_mitigation(void)
 	/*
 	 * Retpoline protects the kernel, but doesn't protect firmware.  IBRS
 	 * and Enhanced IBRS protect firmware too, so enable IBRS around
-	 * firmware calls only when IBRS / Enhanced IBRS aren't otherwise
-	 * enabled.
+	 * firmware calls only when IBRS / Enhanced / Automatic IBRS aren't
+	 * otherwise enabled.
 	 *
 	 * Use "mode" to check Enhanced IBRS instead of boot_cpu_has(), because
 	 * the user might select retpoline on the kernel command line and if
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 73cc546e024d..45e3670bdaaf 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1341,6 +1344,10 @@ static void __init cpu_set_bug_bits(struct cpuinfo_x86 *c)
 	if (ia32_cap & ARCH_CAP_IBRS_ALL)
 		setup_force_cpu_cap(X86_FEATURE_IBRS_ENHANCED);
 
+	/* AMDs AutoIBRS is equivalent to Intel's eIBRS - use the Intel flag. */
+	if (cpu_has(c, X86_FEATURE_AUTOIBRS))
+		setup_force_cpu_cap(X86_FEATURE_IBRS_ENHANCED);
+
 	if (!cpu_matches(cpu_vuln_whitelist, NO_MDS) &&
 	    !(ia32_cap & ARCH_CAP_MDS_NO)) {
 		setup_force_cpu_bug(X86_BUG_MDS);

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
