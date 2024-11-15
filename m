Return-Path: <kvm+bounces-31910-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EB7A9CD6B6
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 06:49:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B4CA5B24E07
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 05:49:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B249185B6B;
	Fri, 15 Nov 2024 05:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MSK1b2XH"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 421C916F851;
	Fri, 15 Nov 2024 05:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731649719; cv=none; b=lzzBUOUmEH7zCqD7gePAhaElwTSGThVS4hr5DWBxBdolgXiQ5cSYGmpcHqtGLP40IoVJ6uII4iwtHfmwYlAszPQ90iT/HXA2WZ0CfWd4ez5W8r8SiNxSZSWSNp1i17F4Rw045rXU7kGVcgt61yGfrCoNoYRNeajFjXR/yAQAK6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731649719; c=relaxed/simple;
	bh=bBL3zb3Let5QttcUOTfx807iAfRBBBRv6dEt/KJuaOY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TWnP+5snGk+NTqpG3btJP6wdP52Q1TN2plXpxa+E6eZcpH6apjrModEoQ5eOiT55wLd48lcjqTCcIXKwG0ajr1PXMz2gaw4sLEaJ7ECDdUyBLSROrt7L1azyPdNipn6wwY6TQi/wx56slCQ+GYOV4rCIL861AKw2kEkQJCiSYic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MSK1b2XH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E105EC4CECF;
	Fri, 15 Nov 2024 05:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731649718;
	bh=bBL3zb3Let5QttcUOTfx807iAfRBBBRv6dEt/KJuaOY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MSK1b2XH8JTDBKlaxUpi2kbzlJrRv6r9TTtG0SYGwaVwDx4gZHN/m6hHuuRUB1s0i
	 lS7ha6Zx7kNsZc6WRqMOQfztIi+yXnUQn6ZtMSL+Up76svu8fbDUqJpWzn/IxtR0u8
	 7s6qS0PIzydk3RBNs8Xikm0odm8esOan6W8g9IOb3oE5/cN4lV+e17E9te0hemuVRf
	 W6qklY+hTmjC3R+r7W8DoIVm1/Xk0UuBP3kA92o33NFHhQr3ZXto5E+g8umCOH/fDY
	 JZSKS72wWlYIV8HsbZ49yIpUgci4fqWLOCE/ZieLRmjlLbE09Esd9JE0iBxa81CqbD
	 sL3At0ekPAlxg==
Date: Thu, 14 Nov 2024 21:48:36 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: Andrew Cooper <andrew.cooper3@citrix.com>, Amit Shah <amit@kernel.org>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
	linux-doc@vger.kernel.org, amit.shah@amd.com,
	thomas.lendacky@amd.com, bp@alien8.de, tglx@linutronix.de,
	peterz@infradead.org, corbet@lwn.net, mingo@redhat.com,
	dave.hansen@linux.intel.com, hpa@zytor.com, seanjc@google.com,
	pbonzini@redhat.com, daniel.sneddon@linux.intel.com,
	kai.huang@intel.com, sandipan.das@amd.com,
	boris.ostrovsky@oracle.com, Babu.Moger@amd.com,
	david.kaplan@amd.com, dwmw@amazon.co.uk
Subject: Re: [RFC PATCH v2 1/3] x86: cpu/bugs: update SpectreRSB comments for
 AMD
Message-ID: <20241115054836.oubgh4jbyvjum4tk@jpoimboe>
References: <20241111163913.36139-1-amit@kernel.org>
 <20241111163913.36139-2-amit@kernel.org>
 <20241111193304.fjysuttl6lypb6ng@jpoimboe>
 <564a19e6-963d-4cd5-9144-2323bdb4f4e8@citrix.com>
 <20241112014644.3p2a6te3sbh5x55c@jpoimboe>
 <20241112214241.fzqq6sqszqd454ei@desk>
 <20241113202105.py5imjdy7pctccqi@jpoimboe>
 <20241114015505.6kghgq33i4m6jrm4@desk>
 <20241114023141.n4n3zl7622gzsf75@jpoimboe>
 <20241114075403.7wxou7g5udaljprv@desk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241114075403.7wxou7g5udaljprv@desk>

On Thu, Nov 14, 2024 at 12:01:16AM -0800, Pawan Gupta wrote:
> > For PBRSB, I guess we don't need to worry about that since there would
> > be at least one kernel CALL before context switch.
> 
> Right. So the case where we need RSB filling at context switch is
> retpoline+CDT mitigation.

According to the docs, classic IBRS also needs RSB filling at context
switch to protect against corrupt RSB entries (as opposed to RSB
underflow).


Something like so...


diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 47a01d4028f6..7b9c0a21e478 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1579,27 +1579,44 @@ static void __init spec_ctrl_disable_kernel_rrsba(void)
 	rrsba_disabled = true;
 }
 
-static void __init spectre_v2_determine_rsb_fill_type_at_vmexit(enum spectre_v2_mitigation mode)
+static void __init spectre_v2_mitigate_rsb(enum spectre_v2_mitigation mode)
 {
 	/*
-	 * Similar to context switches, there are two types of RSB attacks
-	 * after VM exit:
+	 * In general there are two types of RSB attacks:
 	 *
-	 * 1) RSB underflow
+	 * 1) RSB underflow ("Intel Retbleed")
+	 *
+	 *    Some Intel parts have "bottomless RSB".  When the RSB is empty,
+	 *    speculated return targets may come from the branch predictor,
+	 *    which could have a user-poisoned BTB or BHB entry.
+	 *
+	 *    user->user attacks are mitigated by IBPB on context switch.
+	 *
+	 *    user->kernel attacks via context switch are mitigated by IBRS,
+	 *    eIBRS, or RSB filling.
+	 *
+	 *    user->kernel attacks via kernel entry are mitigated by IBRS,
+	 *    eIBRS, or call depth tracking.
+	 *
+	 *    On VMEXIT, guest->host attacks are mitigated by IBRS, eIBRS, or
+	 *    RSB filling.
 	 *
 	 * 2) Poisoned RSB entry
 	 *
-	 * When retpoline is enabled, both are mitigated by filling/clearing
-	 * the RSB.
+	 *    On a context switch, the previous task can poison RSB entries
+	 *    used by the next task, controlling its speculative return
+	 *    targets.  Poisoned RSB entries can also be created by "AMD
+	 *    Retbleed" or SRSO.
 	 *
-	 * When IBRS is enabled, while #1 would be mitigated by the IBRS branch
-	 * prediction isolation protections, RSB still needs to be cleared
-	 * because of #2.  Note that SMEP provides no protection here, unlike
-	 * user-space-poisoned RSB entries.
+	 *    user->user attacks are mitigated by IBPB on context switch.
 	 *
-	 * eIBRS should protect against RSB poisoning, but if the EIBRS_PBRSB
-	 * bug is present then a LITE version of RSB protection is required,
-	 * just a single call needs to retire before a RET is executed.
+	 *    user->kernel attacks via context switch are prevented by
+	 *    SMEP+eIBRS+SRSO mitigations, or RSB clearing.
+	 *
+	 *    guest->host attacks are mitigated by eIBRS or RSB clearing on
+	 *    VMEXIT.  eIBRS implementations with X86_BUG_EIBRS_PBRSB still
+	 *    need "lite" RSB filling which retires a CALL before the first
+	 *    RET.
 	 */
 	switch (mode) {
 	case SPECTRE_V2_NONE:
@@ -1608,8 +1625,8 @@ static void __init spectre_v2_determine_rsb_fill_type_at_vmexit(enum spectre_v2_
 	case SPECTRE_V2_EIBRS_LFENCE:
 	case SPECTRE_V2_EIBRS:
 		if (boot_cpu_has_bug(X86_BUG_EIBRS_PBRSB)) {
-			setup_force_cpu_cap(X86_FEATURE_RSB_VMEXIT_LITE);
 			pr_info("Spectre v2 / PBRSB-eIBRS: Retire a single CALL on VMEXIT\n");
+			setup_force_cpu_cap(X86_FEATURE_RSB_VMEXIT_LITE);
 		}
 		return;
 
@@ -1617,12 +1634,13 @@ static void __init spectre_v2_determine_rsb_fill_type_at_vmexit(enum spectre_v2_
 	case SPECTRE_V2_RETPOLINE:
 	case SPECTRE_V2_LFENCE:
 	case SPECTRE_V2_IBRS:
+		pr_info("Spectre v2 / SpectreRSB : Filling RSB on context switch and VMEXIT\n");
+		setup_force_cpu_cap(X86_FEATURE_RSB_CTXSW);
 		setup_force_cpu_cap(X86_FEATURE_RSB_VMEXIT);
-		pr_info("Spectre v2 / SpectreRSB : Filling RSB on VMEXIT\n");
 		return;
 	}
 
-	pr_warn_once("Unknown Spectre v2 mode, disabling RSB mitigation at VM exit");
+	pr_warn_once("Unknown Spectre v2 mode, disabling RSB mitigation\n");
 	dump_stack();
 }
 
@@ -1817,48 +1835,7 @@ static void __init spectre_v2_select_mitigation(void)
 	spectre_v2_enabled = mode;
 	pr_info("%s\n", spectre_v2_strings[mode]);
 
-	/*
-	 * If Spectre v2 protection has been enabled, fill the RSB during a
-	 * context switch.  In general there are two types of RSB attacks
-	 * across context switches, for which the CALLs/RETs may be unbalanced.
-	 *
-	 * 1) RSB underflow
-	 *
-	 *    Some Intel parts have "bottomless RSB".  When the RSB is empty,
-	 *    speculated return targets may come from the branch predictor,
-	 *    which could have a user-poisoned BTB or BHB entry.
-	 *
-	 *    AMD has it even worse: *all* returns are speculated from the BTB,
-	 *    regardless of the state of the RSB.
-	 *
-	 *    When IBRS or eIBRS is enabled, the "user -> kernel" attack
-	 *    scenario is mitigated by the IBRS branch prediction isolation
-	 *    properties, so the RSB buffer filling wouldn't be necessary to
-	 *    protect against this type of attack.
-	 *
-	 *    The "user -> user" attack scenario is mitigated by RSB filling.
-	 *
-	 * 2) Poisoned RSB entry
-	 *
-	 *    If the 'next' in-kernel return stack is shorter than 'prev',
-	 *    'next' could be tricked into speculating with a user-poisoned RSB
-	 *    entry.
-	 *
-	 *    The "user -> kernel" attack scenario is mitigated by SMEP and
-	 *    eIBRS.
-	 *
-	 *    The "user -> user" scenario, also known as SpectreBHB, requires
-	 *    RSB clearing.
-	 *
-	 * So to mitigate all cases, unconditionally fill RSB on context
-	 * switches.
-	 *
-	 * FIXME: Is this pointless for retbleed-affected AMD?
-	 */
-	setup_force_cpu_cap(X86_FEATURE_RSB_CTXSW);
-	pr_info("Spectre v2 / SpectreRSB mitigation: Filling RSB on context switch\n");
-
-	spectre_v2_determine_rsb_fill_type_at_vmexit(mode);
+	spectre_v2_mitigate_rsb(mode);
 
 	/*
 	 * Retpoline protects the kernel, but doesn't protect firmware.  IBRS

