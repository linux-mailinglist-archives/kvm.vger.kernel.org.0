Return-Path: <kvm+bounces-31546-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C27C69C4AEC
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 01:33:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 84C4328283F
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 00:33:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 602B41F708F;
	Tue, 12 Nov 2024 00:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I1zsDvua"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79ADF1F26EB;
	Tue, 12 Nov 2024 00:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731371418; cv=none; b=kv1IZNqhsiNJNk+uxP1UEOTIhjbw/VAsxvTlaVa4Dm2EK/XQ9ZeuAP8ywe1Z4x79CVvS2xLlGdNnPVr/wvwT/nKODSaymeJYS+t6bW4g/Gxq36ZLUwtqHt5eUeMiWgtW8UyACoRd+ipyR8l3OvCfx3KjY8E9KZ2FMajPKGH1w70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731371418; c=relaxed/simple;
	bh=V83T9rsRDVwJq3z6X/c7c2hPEWoKo7exrEVZtV2JS9A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kg8NP0nXQAOMthgfqhZf8XZv7t7+9kTewQTqUNNyl2VoxwwT2z7bMkPfq+H60R0YSA3tg/plfr8Nq/jHfRdkxcjpn/OOy+JJ0K4iKKLYQbucuqifCAD6X2UvJsT3PsHt31CXdhQcXC0/4LT7lSXqnmD/cfAkXa9pl3oGQeHHxns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I1zsDvua; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11249C4CECF;
	Tue, 12 Nov 2024 00:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731371418;
	bh=V83T9rsRDVwJq3z6X/c7c2hPEWoKo7exrEVZtV2JS9A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=I1zsDvuaZksUyu6y9UYrQFBxj+6jCdWhhth1eDt54E14FFcLgLOIeq15b99kdx8PX
	 9WZb6FmbNrIAaOQTkTn73bI9nspntd/CfoAFqzEYohO+wFMhJVrDMHnXy3AEMZyKsh
	 NTFHpfLrO/GoH/RoZRi0D8n18IS46b8hzmQvuxH4Gzrs9c+fEFM4RS+B+lYaIxVsnV
	 UzJ0E1D0/GOMZaCLC55h88FhLml8fZfObleEJF5lUlV2xjO3NYxX0rgKZZ0DT/sM+Z
	 PxCuFdnsW+lqUwSaa2P2sxUt9DsL2MziCm2Z6PKWt+uEFhBHRD5+xoXKG8E1vDobI2
	 GBMuXNDnmDmDg==
Date: Mon, 11 Nov 2024 16:30:15 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: "Kaplan, David" <David.Kaplan@amd.com>
Cc: Amit Shah <amit@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"Shah, Amit" <Amit.Shah@amd.com>,
	"Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
	"bp@alien8.de" <bp@alien8.de>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"peterz@infradead.org" <peterz@infradead.org>,
	"pawan.kumar.gupta@linux.intel.com" <pawan.kumar.gupta@linux.intel.com>,
	"corbet@lwn.net" <corbet@lwn.net>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"hpa@zytor.com" <hpa@zytor.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"daniel.sneddon@linux.intel.com" <daniel.sneddon@linux.intel.com>,
	"kai.huang@intel.com" <kai.huang@intel.com>,
	"Das1, Sandipan" <Sandipan.Das@amd.com>,
	"boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
	"Moger, Babu" <Babu.Moger@amd.com>,
	"dwmw@amazon.co.uk" <dwmw@amazon.co.uk>,
	"andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>
Subject: Re: [RFC PATCH v2 1/3] x86: cpu/bugs: update SpectreRSB comments for
 AMD
Message-ID: <20241112003015.qxuufx6jrfeoqfak@jpoimboe>
References: <20241111163913.36139-1-amit@kernel.org>
 <20241111163913.36139-2-amit@kernel.org>
 <20241111193304.fjysuttl6lypb6ng@jpoimboe>
 <LV3PR12MB9265A6B2030DAE155E7B560B94582@LV3PR12MB9265.namprd12.prod.outlook.com>
 <20241111203906.a2y55qoi767hcmht@jpoimboe>
 <20241111204038.63ny4i74irngw2si@jpoimboe>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241111204038.63ny4i74irngw2si@jpoimboe>

On Mon, Nov 11, 2024 at 12:40:41PM -0800, Josh Poimboeuf wrote:
> On Mon, Nov 11, 2024 at 12:39:09PM -0800, Josh Poimboeuf wrote:
> > This is why it's important to spell out all the different cases in the
> > comments.  I was attempting to document the justifications for the
> > existing behavior.
> > 
> > You make some good points, though backing up a bit, I realize my comment
> > was flawed for another reason: the return thunks only protect the
> > kernel, but RSB filling on context switch is meant to protect user
> > space.
> > 
> > So, never mind...
> 
> That said, I still think the comments need an update.  I'll try to come
> up with something later.

Here are some clarifications to the comments.  Amit, feel free to
include this in your next revision.

----8<----

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
 arch/x86/kernel/cpu/bugs.c | 59 ++++++++++++--------------------------
 1 file changed, 19 insertions(+), 40 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 47a01d4028f6..fbdfa151b7a9 100644
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
@@ -1818,43 +1798,42 @@ static void __init spectre_v2_select_mitigation(void)
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
+	 *    entry.  Speculative Type Confusion ("AMD retbleed") can also
+	 *    create poisoned RSB entries.
 	 *
-	 *    The "user -> kernel" attack scenario is mitigated by SMEP and
-	 *    eIBRS.
+	 *    The "user -> kernel" attack is mitigated by SMEP and eIBRS.
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
+	 *    The "guest -> host" attack is mitigated by eIBRS (not IBRS!) or
+	 *    RSB clearing on vmexit.  Note that eIBRS implementations with
+	 *    X86_BUG_EIBRS_PBRSB still need "lite" RSB clearing which retires
+	 *    a single CALL before the first RET.
 	 */
+
 	setup_force_cpu_cap(X86_FEATURE_RSB_CTXSW);
 	pr_info("Spectre v2 / SpectreRSB mitigation: Filling RSB on context switch\n");
 
-- 
2.47.0


