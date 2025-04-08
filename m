Return-Path: <kvm+bounces-42968-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 03D88A817E1
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 23:50:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E596F4C2360
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 21:49:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10AF92571BA;
	Tue,  8 Apr 2025 21:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CwcUcpp7"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E35C256C88;
	Tue,  8 Apr 2025 21:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744148887; cv=none; b=jp4SXr4f9qsHTbHDf2dGc33y6ml2PqIU/qFccW40ciuxZDhmWsPOTyeTa++P1M9HhBzmu9AJd4s6eiD5rntA8QFW+Ku6f5LOdAb7I1rHZr0/2yxucozbOH8zafHorK9PWC2QN4+/dUXYI0KgE3vW20LatNd0lT2i0M/PCHdPFXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744148887; c=relaxed/simple;
	bh=aRXQ79PUSLC1j2Y1PLoyu2IjBcD6ZD7dUjj7Zjjxv5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J0EylyZDVXIUhduyOYHYphgJhSV3lVlS662NU8ydt1a1doaGIbRAn76hdhJCZCmYGGQKPsrL+LwgJgT3IvX+uKviW5ZJlStk84lnQSBlVF6TFPmRWxfCRuFiDIxKxNhqwEvPzy0qdrhSNH9605JlJDtsDa7PZaB0a69HJxX+zls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CwcUcpp7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D88C5C4CEEC;
	Tue,  8 Apr 2025 21:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744148886;
	bh=aRXQ79PUSLC1j2Y1PLoyu2IjBcD6ZD7dUjj7Zjjxv5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CwcUcpp7DKnw7eFZt42u2QHjBIcfzIiUt90jSCkTomD2EpaWoLPuBgyh1XbzKrrLl
	 DAG0Jx5VmtSgLKDBUS3WNR/NxeE//qV/4GYE2CibOSQm9JiHH5f3NPnrmUa9O8JyA3
	 1MDWJk4Kt8ZvTJoqr0tu1b5WGQ2qezFlxfGs+u0oMIM+6E0rt9Wz5VpLoYW+eGXCuN
	 +sZj2v+015/e9nQWbUmcDsFrBgrCqC8xEHRk3ZdVwtMA3W1tdaQ9gzOaISBUOwd3NK
	 tKpcUvrGoKu6bFjkP4AIDgY5ibwbSmQl3F/e9JlcaUGvskndIPw1F6UUb2jbwEqlt9
	 W5Si9hYAUEzpA==
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
	andrew.cooper3@citrix.comm,
	nik.borisov@suse.com
Subject: [PATCH v4 5/6] x86/bugs: Don't fill RSB on context switch with eIBRS
Date: Tue,  8 Apr 2025 14:47:34 -0700
Message-ID: <98cdefe42180358efebf78e3b80752850c7a3e1b.1744148254.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1744148254.git.jpoimboe@kernel.org>
References: <cover.1744148254.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

User->user Spectre v2 attacks (including RSB) across context switches
are already mitigated by IBPB in cond_mitigation(), if enabled globally
or if either the prev or the next task has opted in to protection.  RSB
filling without IBPB serves no purpose for protecting user space, as
indirect branches are still vulnerable.

User->kernel RSB attacks are mitigated by eIBRS.  In which case the RSB
filling on context switch isn't needed, so remove it.

Suggested-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Reviewed-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Reviewed-by: Amit Shah <amit.shah@amd.com>
Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 arch/x86/kernel/cpu/bugs.c | 24 ++++++++++++------------
 arch/x86/mm/tlb.c          |  6 +++---
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index a10b37bb747e..e2a672f925e3 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1591,7 +1591,7 @@ static void __init spec_ctrl_disable_kernel_rrsba(void)
 	rrsba_disabled = true;
 }
 
-static void __init spectre_v2_determine_rsb_fill_type_at_vmexit(enum spectre_v2_mitigation mode)
+static void __init spectre_v2_select_rsb_mitigation(enum spectre_v2_mitigation mode)
 {
 	/*
 	 * Similar to context switches, there are two types of RSB attacks
@@ -1615,7 +1615,7 @@ static void __init spectre_v2_determine_rsb_fill_type_at_vmexit(enum spectre_v2_
 	 */
 	switch (mode) {
 	case SPECTRE_V2_NONE:
-		return;
+		break;
 
 	case SPECTRE_V2_EIBRS:
 	case SPECTRE_V2_EIBRS_LFENCE:
@@ -1624,18 +1624,21 @@ static void __init spectre_v2_determine_rsb_fill_type_at_vmexit(enum spectre_v2_
 			pr_info("Spectre v2 / PBRSB-eIBRS: Retire a single CALL on VMEXIT\n");
 			setup_force_cpu_cap(X86_FEATURE_RSB_VMEXIT_LITE);
 		}
-		return;
+		break;
 
 	case SPECTRE_V2_RETPOLINE:
 	case SPECTRE_V2_LFENCE:
 	case SPECTRE_V2_IBRS:
-		pr_info("Spectre v2 / SpectreRSB : Filling RSB on VMEXIT\n");
+		pr_info("Spectre v2 / SpectreRSB: Filling RSB on context switch and VMEXIT\n");
+		setup_force_cpu_cap(X86_FEATURE_RSB_CTXSW);
 		setup_force_cpu_cap(X86_FEATURE_RSB_VMEXIT);
-		return;
-	}
+		break;
 
-	pr_warn_once("Unknown Spectre v2 mode, disabling RSB mitigation at VM exit");
-	dump_stack();
+	default:
+		pr_warn_once("Unknown Spectre v2 mode, disabling RSB mitigation\n");
+		dump_stack();
+		break;
+	}
 }
 
 /*
@@ -1867,10 +1870,7 @@ static void __init spectre_v2_select_mitigation(void)
 	 *
 	 * FIXME: Is this pointless for retbleed-affected AMD?
 	 */
-	setup_force_cpu_cap(X86_FEATURE_RSB_CTXSW);
-	pr_info("Spectre v2 / SpectreRSB mitigation: Filling RSB on context switch\n");
-
-	spectre_v2_determine_rsb_fill_type_at_vmexit(mode);
+	spectre_v2_select_rsb_mitigation(mode);
 
 	/*
 	 * Retpoline protects the kernel, but doesn't protect firmware.  IBRS
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index d00ae21d0ee2..482b796f5243 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -672,9 +672,9 @@ static void cond_mitigation(struct task_struct *next)
 	prev_mm = this_cpu_read(cpu_tlbstate.last_user_mm_spec);
 
 	/*
-	 * Avoid user/user BTB poisoning by flushing the branch predictor
-	 * when switching between processes. This stops one process from
-	 * doing Spectre-v2 attacks on another.
+	 * Avoid user->user BTB/RSB poisoning by flushing them when switching
+	 * between processes. This stops one process from doing Spectre-v2
+	 * attacks on another.
 	 *
 	 * Both, the conditional and the always IBPB mode use the mm
 	 * pointer to avoid the IBPB when switching between tasks of the
-- 
2.49.0


