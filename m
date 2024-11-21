Return-Path: <kvm+bounces-32314-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1651B9D53B7
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 21:08:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CA9E7282D1A
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 20:08:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B731A1DA60B;
	Thu, 21 Nov 2024 20:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V4QX4SwK"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D26981D86F6;
	Thu, 21 Nov 2024 20:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732219649; cv=none; b=PyCkj4fGQmFOF6ODf5bWZdxvjIzidhwWHsXKmB0Fv7sKIU/l2vfrcHgUwjpJM2ODzPraJCd7PtF/ade+yjPZwTIsONc1LzzwN5eMTSGtJDRnmeZf2c6rp3zQYy2P89DTsXYUSpbD73BfZmV7kmsxnUKfuXx4xhY/Jb4v1XrgTgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732219649; c=relaxed/simple;
	bh=BFByCKMJF67PQOKKXz3vC/jkTbja3Wd/qN/VuLH6EG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OfT8Ww4nKKSA9dWrdFO42hTBSBNogrti0OuLjHRAUnReV56dRQ5GisLTPg7u3OQnNOyHaEh6zvmvbDY5GQDowF/NcPXeqYomaXwiI2N6BJDhKTEgo/kSL9WqJKurq8/ZYpbaB56Q+Yt97WgT1NuHqo8A1Ln4CdxK8U7D+riss1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V4QX4SwK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3F77C4CED6;
	Thu, 21 Nov 2024 20:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732219649;
	bh=BFByCKMJF67PQOKKXz3vC/jkTbja3Wd/qN/VuLH6EG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V4QX4SwKvybMQ+ddk/ToKWL7PxpLDYf+4w++RV5qNiZDYO8mlvBfjYiFDmm7gxb6t
	 x+KQiy6oFvDy9NTinkIuo2sZFx7Fp8z5AL+Z6CrSJuDAcN4ZIknBx8NRGzih8277KY
	 3UhVtCbp0YnhbC7U9NaDFLAGkgnlixzsLSjMy+jB5v32/f5aNdFxODlPgm+CyelLVU
	 bqjz4VrP9zgmHiYFnoxkpV5P+cf4ma5qlnzBKyGienKtuV20KqvRBpMKCOO2K7b5hH
	 FVqIR8o9Aqt8/mdW9Z0gP2SNCEkkRu7z2g2juW3eKBWnPjjB2UkpBXez9qww+HXS6N
	 1JZLV3ax5PSPw==
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
Subject: [PATCH v2 2/2] x86/bugs: Don't fill RSB on context switch with eIBRS
Date: Thu, 21 Nov 2024 12:07:19 -0800
Message-ID: <d6b0c08000aa96221239ace37dd53e3f1919926c.1732219175.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <cover.1732219175.git.jpoimboe@kernel.org>
References: <cover.1732219175.git.jpoimboe@kernel.org>
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

While at it, update and coalesce the comments describing the various RSB
mitigations.

Suggested-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Reviewed-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Reviewed-by: Amit Shah <amit.shah@amd.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 arch/x86/kernel/cpu/bugs.c | 103 +++++++++++++++----------------------
 arch/x86/mm/tlb.c          |   2 +-
 2 files changed, 42 insertions(+), 63 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 68bed17f0980..d5102b72f74d 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1579,31 +1579,48 @@ static void __init spec_ctrl_disable_kernel_rrsba(void)
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
-		return;
+		break;
 
 	case SPECTRE_V2_EIBRS:
 	case SPECTRE_V2_EIBRS_LFENCE:
@@ -1612,18 +1629,21 @@ static void __init spectre_v2_determine_rsb_fill_type_at_vmexit(enum spectre_v2_
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
@@ -1817,48 +1837,7 @@ static void __init spectre_v2_select_mitigation(void)
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
index 86593d1b787d..dc388f5ae7ef 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -388,7 +388,7 @@ static void cond_mitigation(struct task_struct *next)
 	prev_mm = this_cpu_read(cpu_tlbstate.last_user_mm_spec);
 
 	/*
-	 * Avoid user/user BTB poisoning by flushing the branch predictor
+	 * Avoid user->user BTB/RSB poisoning by flushing the branch predictor
 	 * when switching between processes. This stops one process from
 	 * doing Spectre-v2 attacks on another.
 	 *
-- 
2.47.0


