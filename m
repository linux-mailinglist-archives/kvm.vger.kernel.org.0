Return-Path: <kvm+bounces-32128-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 212899D341E
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 08:28:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D56AB28303F
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 07:28:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A7C4200CB;
	Wed, 20 Nov 2024 07:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZWPg9Uwx"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7059316C451;
	Wed, 20 Nov 2024 07:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732087676; cv=none; b=SpbARhKgwqpnacbpiffKSQPZwPOMDk/6UXkvw1d3nmGkBfSUsSdA77oJx3s7pvFpZETL+7XWftv5aVhzyu16Bh+Jqz8AFwHOXz3/HHV9BbpZN5jWKD5vwBaHsrGQ8LY6ARXQU3b2Xc3U3yNZA6VtaqY7ao0k9ntGnNb28p4ClGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732087676; c=relaxed/simple;
	bh=0DNpYI2KNn2bdBKkEmwtFouRkf9TP+Jp/KIuK5IDG88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=afNg3eJxvNfZGOejpumIK9d6FUjGe281wfFbqCvEJpea9XMLZ8VH7d/YcWhRcOXBWZXyi8YgaRIMTPggJ6qY23BfXTQmbAcbmGv5fbuYMvrCpRqk3OL06D9UwbrfrENr80o0FMvkhj3ULdaNJX/RIXvLplfMfUmqhIzOJM8WLxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZWPg9Uwx; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21207C4CEDA;
	Wed, 20 Nov 2024 07:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732087676;
	bh=0DNpYI2KNn2bdBKkEmwtFouRkf9TP+Jp/KIuK5IDG88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZWPg9UwxVWf0dM6Q1gOoZjWunGo7Ymj0e9hHiq2YBMwsvLjEDp9m2bZ30e6Jsd0oZ
	 bPV7GoS4Uw7ch1LIdHPFfwWHLY0dlfcaoG3OrmLeJ+U0iywCAqM7f7g1qUfuVi5oKt
	 gHVR7dS8Bd9r5b1h8foBbmQtcx2eYVmsvn/Lz1E/YCYsDSvf1gNrDN+Wq9cb0ZZQZG
	 xDsgQpAJkfgcHcKEwSkVjzggAC3uWDNpBfKY/jyCJHLzpqZVFp4zYsbMkBN1edaDK1
	 rfm0MqndR9AiCY0rNiPFgLNIQKH+H14TsVRC6oWR9CSqOoEfPAYPhr8z95IkbCKK+3
	 omCJWC33PX7/A==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	amit@kernel.org,
	kvm@vger.kernel.org,
	amit.shah@amd.com,
	thomas.lendacky@amd.com,
	bp@alien8.de,
	tglx@linutronix.de,
	peterz@infradead.org,
	pawan.kumar.gupta@linux.intel.com,
	corbet@lwn.net,
	mingo@redhat.com,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	seanjc@google.com,
	pbonzini@redhat.com,
	daniel.sneddon@linux.intel.com,
	kai.huang@intel.com,
	sandipan.das@amd.com,
	boris.ostrovsky@oracle.com,
	Babu.Moger@amd.com,
	david.kaplan@amd.com,
	dwmw@amazon.co.uk,
	andrew.cooper3@citrix.com
Subject: [PATCH 2/2] x86/bugs: Don't fill RSB on context switch with eIBRS
Date: Tue, 19 Nov 2024 23:27:51 -0800
Message-ID: <9792424a4fe23ccc1f7ebbef121bfdd31e696d5d.1732087270.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <cover.1732087270.git.jpoimboe@kernel.org>
References: <cover.1732087270.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

User->user Spectre v2 attacks (including RSB) across context switches
are already mitigated by IBPB in cond_mitigation(), if enabled globally
or if at least one of the tasks has opted in to protection.  RSB filling
without IBPB serves no purpose for protecting user space, as indirect
branches are still vulnerable.

User->kernel RSB attacks are mitigated by eIBRS.  In which case the RSB
filling on context switch isn't needed.  Fix that.

While at it, update and coalesce the comments describing the various RSB
mitigations.

Suggested-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 arch/x86/kernel/cpu/bugs.c | 91 ++++++++++++++------------------------
 arch/x86/mm/tlb.c          |  2 +-
 2 files changed, 35 insertions(+), 58 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 68bed17f0980..e261f41749b0 100644
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
@@ -1617,12 +1634,13 @@ static void __init spectre_v2_determine_rsb_fill_type_at_vmexit(enum spectre_v2_
 	case SPECTRE_V2_RETPOLINE:
 	case SPECTRE_V2_LFENCE:
 	case SPECTRE_V2_IBRS:
-		pr_info("Spectre v2 / SpectreRSB : Filling RSB on VMEXIT\n");
+		pr_info("Spectre v2 / SpectreRSB : Filling RSB on context switch and VMEXIT\n");
+		setup_force_cpu_cap(X86_FEATURE_RSB_CTXSW);
 		setup_force_cpu_cap(X86_FEATURE_RSB_VMEXIT);
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
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 86593d1b787d..c693b877d4df 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -388,7 +388,7 @@ static void cond_mitigation(struct task_struct *next)
 	prev_mm = this_cpu_read(cpu_tlbstate.last_user_mm_spec);
 
 	/*
-	 * Avoid user/user BTB poisoning by flushing the branch predictor
+	 * Avoid user/user BTB/RSB poisoning by flushing the branch predictor
 	 * when switching between processes. This stops one process from
 	 * doing Spectre-v2 attacks on another.
 	 *
-- 
2.47.0


