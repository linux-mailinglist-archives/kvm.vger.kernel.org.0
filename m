Return-Path: <kvm+bounces-31548-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 371D29C4C03
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 02:47:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AF3F61F224CF
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 01:47:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19A85204F6B;
	Tue, 12 Nov 2024 01:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VdDtksdk"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 367CB157A59;
	Tue, 12 Nov 2024 01:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731376007; cv=none; b=fRZD1j57Vc51muolv7Hw4Jt8xNSpJd5hxug6UQ9XeuofUNo9AdgtGBKG6f0Chhcwka8McZtbNJNff2zGBKX7DqWwPt5VmF+AMm+aZ4xwAovcfQ96MP5fSMb3KQqPjn/vqsc61872bIg9HWMvE7p8JqDYbhHAsc5HcFHwHRWcxTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731376007; c=relaxed/simple;
	bh=t4DRispja/rBIeZTUS8EcXZ3J1ffNNE/f2oEAh9MOBU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=efvf7Qd4BfZUvq2pTjukveHFGyLczVpopra3S5tbzr6KTv3kY86rQTCbDaW0l0SY6HsZoZpKVQkU5tnDSXe/fMNxbLr7Pr3QbZ0dtBXXXZHK0K74JjTyF1qv1/4WDEPQjiuA9yp5NVIwzMx3kUvVwPabe73AlpoyZOSTJ3C+fH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VdDtksdk; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2075C4CECF;
	Tue, 12 Nov 2024 01:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731376006;
	bh=t4DRispja/rBIeZTUS8EcXZ3J1ffNNE/f2oEAh9MOBU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VdDtksdkWsJewWFnWeWj1DgQh0hTYxkIOHwakEVcfa1Ey2YiItPT+ygm3HtXsaHG/
	 WEvobcWb0jJ4V9MVgp+u/otQt9aOYZahk8UZe2AvnUxwE/rM8b/MnSUYforQkBBD2X
	 d2jHPs5RRDB6j0wzWuKa5nTRlxPPiyDO5Ub3Y/QxIZ4RbZiaaPoy3FLV6DICWvKm6w
	 GW2o8gzgeoqxLMgKOEbwvu9AUCzN/K0JIHOHZODnpOleV6q0V97eWszH9NQfb+2zs/
	 NxnsC5UUuiV9Jkv+n0yFITPrWXMGhvj5g1Uys2Rvr8hGFNHa0xsWpT6ZiMT2pdBQ1X
	 +XSGKxJdgJX1Q==
Date: Mon, 11 Nov 2024 17:46:44 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Andrew Cooper <andrew.cooper3@citrix.com>
Cc: Amit Shah <amit@kernel.org>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, x86@kernel.org, linux-doc@vger.kernel.org,
	amit.shah@amd.com, thomas.lendacky@amd.com, bp@alien8.de,
	tglx@linutronix.de, peterz@infradead.org,
	pawan.kumar.gupta@linux.intel.com, corbet@lwn.net, mingo@redhat.com,
	dave.hansen@linux.intel.com, hpa@zytor.com, seanjc@google.com,
	pbonzini@redhat.com, daniel.sneddon@linux.intel.com,
	kai.huang@intel.com, sandipan.das@amd.com,
	boris.ostrovsky@oracle.com, Babu.Moger@amd.com,
	david.kaplan@amd.com, dwmw@amazon.co.uk
Subject: Re: [RFC PATCH v2 1/3] x86: cpu/bugs: update SpectreRSB comments for
 AMD
Message-ID: <20241112014644.3p2a6te3sbh5x55c@jpoimboe>
References: <20241111163913.36139-1-amit@kernel.org>
 <20241111163913.36139-2-amit@kernel.org>
 <20241111193304.fjysuttl6lypb6ng@jpoimboe>
 <564a19e6-963d-4cd5-9144-2323bdb4f4e8@citrix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <564a19e6-963d-4cd5-9144-2323bdb4f4e8@citrix.com>

On Tue, Nov 12, 2024 at 12:29:28AM +0000, Andrew Cooper wrote:
> This is my take.  On AMD CPUs, there are two unrelated issues to take
> into account:
> 
> 1) SRSO
> 
> Affects anything which doesn't enumerate SRSO_NO, which is all parts to
> date including Zen5.
> 
> SRSO ends up overflowing the RAS with arbitrary BTB targets, such that a
> subsequent genuine RET follows a prediction which never came from a real
> CALL instruction.
> 
> Mitigations for SRSO are either safe-ret, or IBPB-on-entry.  Parts
> without IBPB_RET using IBPB-on-entry need to manually flush the RAS.
> 
> Importantly, SMEP does not protection you against SRSO across the
> user->kernel boundary, because the bad RAS entries are arbitrary.  New
> in Zen5 is the SRSO_U/S_NO bit which says this case can't occur any
> more.  So on Zen5, you can in principle get away without a RAS flush on
> entry.

Updated to mention SRSO:

	/*
	 * In general there are two types of RSB attacks:
	 *
	 * 1) RSB underflow ("Intel Retbleed")
	 *
	 *    Some Intel parts have "bottomless RSB".  When the RSB is empty,
	 *    speculated return targets may come from the branch predictor,
	 *    which could have a user-poisoned BTB or BHB entry.
	 *
	 *    When IBRS or eIBRS is enabled, the "user -> kernel" attack is
	 *    mitigated by the IBRS branch prediction isolation properties, so
	 *    the RSB buffer filling wouldn't be necessary to protect against
	 *    this type of attack.
	 *
	 *    The "user -> user" attack is mitigated by RSB filling on context
	 *    switch.
	 *
	 *    The "guest -> host" attack is mitigated by IBRS or eIBRS.
	 *
	 * 2) Poisoned RSB entry
	 *
	 *    If the 'next' in-kernel return stack is shorter than 'prev',
	 *    'next' could be tricked into speculating with a user-poisoned RSB
	 *    entry.  Poisoned RSB entries can also be created by Branch Type
	 *    Confusion ("AMD retbleed") or SRSO.
	 *
	 *    The "user -> kernel" attack is mitigated by SMEP and eIBRS.  AMD
	 *    without SRSO_NO also needs the SRSO mitigation.
	 *
	 *    The "user -> user" attack, also known as SpectreBHB, requires RSB
	 *    clearing.
	 *
	 *    The "guest -> host" attack is mitigated by either eIBRS (not
	 *    IBRS!) or RSB clearing on vmexit.  Note that eIBRS
	 *    implementations with X86_BUG_EIBRS_PBRSB still need "lite" RSB
	 *    clearing which retires a single CALL before the first RET.
	 */


---8<---

From: Josh Poimboeuf <jpoimboe@kernel.org>
Subject: [PATCH] x86/bugs: Update insanely long comment about RSB attacks

The long comment above the setting of X86_FEATURE_RSB_CTXSW is a bit
confusing.  It starts out being about context switching specifically,
but then goes on to describe "user -> kernel" mitigations, which aren't
necessarily limited to context switches.

Clarify that it's about *all* RSB attacks and their mitigations.

For consistency, add the "guest -> host" mitigations as well.  Then the
comment above spectre_v2_determine_rsb_fill_type_at_vmexit() can be
removed and the overall line count is reduced.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 arch/x86/kernel/cpu/bugs.c | 60 +++++++++++++-------------------------
 1 file changed, 20 insertions(+), 40 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 47a01d4028f6..3dd1e504d706 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1581,26 +1581,6 @@ static void __init spec_ctrl_disable_kernel_rrsba(void)
 
 static void __init spectre_v2_determine_rsb_fill_type_at_vmexit(enum spectre_v2_mitigation mode)
 {
-	/*
-	 * Similar to context switches, there are two types of RSB attacks
-	 * after VM exit:
-	 *
-	 * 1) RSB underflow
-	 *
-	 * 2) Poisoned RSB entry
-	 *
-	 * When retpoline is enabled, both are mitigated by filling/clearing
-	 * the RSB.
-	 *
-	 * When IBRS is enabled, while #1 would be mitigated by the IBRS branch
-	 * prediction isolation protections, RSB still needs to be cleared
-	 * because of #2.  Note that SMEP provides no protection here, unlike
-	 * user-space-poisoned RSB entries.
-	 *
-	 * eIBRS should protect against RSB poisoning, but if the EIBRS_PBRSB
-	 * bug is present then a LITE version of RSB protection is required,
-	 * just a single call needs to retire before a RET is executed.
-	 */
 	switch (mode) {
 	case SPECTRE_V2_NONE:
 		return;
@@ -1818,43 +1798,43 @@ static void __init spectre_v2_select_mitigation(void)
 	pr_info("%s\n", spectre_v2_strings[mode]);
 
 	/*
-	 * If Spectre v2 protection has been enabled, fill the RSB during a
-	 * context switch.  In general there are two types of RSB attacks
-	 * across context switches, for which the CALLs/RETs may be unbalanced.
+	 * In general there are two types of RSB attacks:
 	 *
-	 * 1) RSB underflow
+	 * 1) RSB underflow ("Intel Retbleed")
 	 *
 	 *    Some Intel parts have "bottomless RSB".  When the RSB is empty,
 	 *    speculated return targets may come from the branch predictor,
 	 *    which could have a user-poisoned BTB or BHB entry.
 	 *
-	 *    AMD has it even worse: *all* returns are speculated from the BTB,
-	 *    regardless of the state of the RSB.
+	 *    When IBRS or eIBRS is enabled, the "user -> kernel" attack is
+	 *    mitigated by the IBRS branch prediction isolation properties, so
+	 *    the RSB buffer filling wouldn't be necessary to protect against
+	 *    this type of attack.
 	 *
-	 *    When IBRS or eIBRS is enabled, the "user -> kernel" attack
-	 *    scenario is mitigated by the IBRS branch prediction isolation
-	 *    properties, so the RSB buffer filling wouldn't be necessary to
-	 *    protect against this type of attack.
+	 *    The "user -> user" attack is mitigated by RSB filling on context
+	 *    switch.
 	 *
-	 *    The "user -> user" attack scenario is mitigated by RSB filling.
+	 *    The "guest -> host" attack is mitigated by IBRS or eIBRS.
 	 *
 	 * 2) Poisoned RSB entry
 	 *
 	 *    If the 'next' in-kernel return stack is shorter than 'prev',
 	 *    'next' could be tricked into speculating with a user-poisoned RSB
-	 *    entry.
+	 *    entry.  Poisoned RSB entries can also be created by Branch Type
+	 *    Confusion ("AMD retbleed") or SRSO.
 	 *
-	 *    The "user -> kernel" attack scenario is mitigated by SMEP and
-	 *    eIBRS.
+	 *    The "user -> kernel" attack is mitigated by SMEP and eIBRS.  AMD
+	 *    without SRSO_NO also needs the SRSO mitigation.
 	 *
-	 *    The "user -> user" scenario, also known as SpectreBHB, requires
-	 *    RSB clearing.
+	 *    The "user -> user" attack, also known as SpectreBHB, requires RSB
+	 *    clearing.
 	 *
-	 * So to mitigate all cases, unconditionally fill RSB on context
-	 * switches.
-	 *
-	 * FIXME: Is this pointless for retbleed-affected AMD?
+	 *    The "guest -> host" attack is mitigated by either eIBRS (not
+	 *    IBRS!) or RSB clearing on vmexit.  Note that eIBRS
+	 *    implementations with X86_BUG_EIBRS_PBRSB still need "lite" RSB
+	 *    clearing which retires a single CALL before the first RET.
 	 */
+
 	setup_force_cpu_cap(X86_FEATURE_RSB_CTXSW);
 	pr_info("Spectre v2 / SpectreRSB mitigation: Filling RSB on context switch\n");
 
-- 
2.47.0


