Return-Path: <kvm+bounces-42496-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A209A794FA
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 20:20:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A3B881892EB5
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 18:20:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64D9F1DD9AC;
	Wed,  2 Apr 2025 18:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OA98Rl3X"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A821CD1E4;
	Wed,  2 Apr 2025 18:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743617997; cv=none; b=Ol8Gl6Z5FFkO83VbEkEV9PJjCDNzMjTw2q3BJoae9sg2kxr36lgzv7fOfHULtRpVIOhiD5ng6vTKSwa0dcXiEUMWmYzjG+NDOoQf7nWC+6jHHxQ0mKyudm4GhWXQUF+KT0t7swU0L6hCbIJ+yIj2/pXG2I+zXhsHkOtDYiRUwhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743617997; c=relaxed/simple;
	bh=awLUV5Moo7lLn6htb5EV0VB4byiNMh96cfT7JySAgfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oPuAkK5Lk8KChLh+ODwu/f/qqhIlmhz9LYJBQczkJza/GuR7gxjwoF/T+EHkqN2Exet9L8lvrjPaYYv37m2VEc4UdH7cZBEJcPgBPQTvBzuaLhgDY+E3iyj2vFFFLgiQ1m+cJU7PbjxeLj91N0Y96EVn2hMymsQAbGSX5DaRuQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OA98Rl3X; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36657C4CEE8;
	Wed,  2 Apr 2025 18:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743617997;
	bh=awLUV5Moo7lLn6htb5EV0VB4byiNMh96cfT7JySAgfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OA98Rl3XtnGvPurXVCP4tZb/jYAIFYlGfLBbZeGQ3bdES2LRVFCMLQ6yhrnHcFCvP
	 lHXGpIPgt92+1vDqIxitbxLD2qTIwPJdZJJ5dTrw1/dPs8zacY2avlYoX6REFam3Ko
	 AUw39cNOZEKhGx6bs6X9em/E1ufTuLTfJBOaEfCZDHfOu4gkGUH3JCZmQ0pj1aSr+2
	 2EyENBVGAXLY+bP8xgzrgtCi2/vBytTRy0rj0pvUa5WylH0YppSGexbGivvtfRsUAM
	 cVrr3ULofo/3zdw9XqSObZBL7wPQEoFsnl1nJcnyqFPQLJLoudUHhK/z7uHpH+62E4
	 cPADstBCh15gQ==
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
Subject: [PATCH v3 1/6] x86/bugs: Rename entry_ibpb()
Date: Wed,  2 Apr 2025 11:19:18 -0700
Message-ID: <a3ce1558b68a64f52ea56000f2bbdfd6e7799258.1743617897.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1743617897.git.jpoimboe@kernel.org>
References: <cover.1743617897.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There's nothing entry-specific about entry_ibpb().  In preparation for
calling it from elsewhere, rename it to __write_ibpb().

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 arch/x86/entry/entry.S               | 7 ++++---
 arch/x86/include/asm/nospec-branch.h | 6 +++---
 arch/x86/kernel/cpu/bugs.c           | 6 +++---
 3 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/x86/entry/entry.S b/arch/x86/entry/entry.S
index d3caa31240ed..3a53319988b9 100644
--- a/arch/x86/entry/entry.S
+++ b/arch/x86/entry/entry.S
@@ -17,7 +17,8 @@
 
 .pushsection .noinstr.text, "ax"
 
-SYM_FUNC_START(entry_ibpb)
+// Clobbers AX, CX, DX
+SYM_FUNC_START(__write_ibpb)
 	ANNOTATE_NOENDBR
 	movl	$MSR_IA32_PRED_CMD, %ecx
 	movl	$PRED_CMD_IBPB, %eax
@@ -27,9 +28,9 @@ SYM_FUNC_START(entry_ibpb)
 	/* Make sure IBPB clears return stack preductions too. */
 	FILL_RETURN_BUFFER %rax, RSB_CLEAR_LOOPS, X86_BUG_IBPB_NO_RET
 	RET
-SYM_FUNC_END(entry_ibpb)
+SYM_FUNC_END(__write_ibpb)
 /* For KVM */
-EXPORT_SYMBOL_GPL(entry_ibpb);
+EXPORT_SYMBOL_GPL(__write_ibpb);
 
 .popsection
 
diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index 8a5cc8e70439..bbac79cad04c 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -269,7 +269,7 @@
  * typically has NO_MELTDOWN).
  *
  * While retbleed_untrain_ret() doesn't clobber anything but requires stack,
- * entry_ibpb() will clobber AX, CX, DX.
+ * __write_ibpb() will clobber AX, CX, DX.
  *
  * As such, this must be placed after every *SWITCH_TO_KERNEL_CR3 at a point
  * where we have a stack but before any RET instruction.
@@ -279,7 +279,7 @@
 	VALIDATE_UNRET_END
 	CALL_UNTRAIN_RET
 	ALTERNATIVE_2 "",						\
-		      "call entry_ibpb", \ibpb_feature,			\
+		      "call __write_ibpb", \ibpb_feature,			\
 		     __stringify(\call_depth_insns), X86_FEATURE_CALL_DEPTH
 #endif
 .endm
@@ -368,7 +368,7 @@ extern void srso_return_thunk(void);
 extern void srso_alias_return_thunk(void);
 
 extern void entry_untrain_ret(void);
-extern void entry_ibpb(void);
+extern void __write_ibpb(void);
 
 #ifdef CONFIG_X86_64
 extern void clear_bhb_loop(void);
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 4386aa6c69e1..310cb3f7139c 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1142,7 +1142,7 @@ static void __init retbleed_select_mitigation(void)
 		setup_clear_cpu_cap(X86_FEATURE_RETHUNK);
 
 		/*
-		 * There is no need for RSB filling: entry_ibpb() ensures
+		 * There is no need for RSB filling: __write_ibpb() ensures
 		 * all predictions, including the RSB, are invalidated,
 		 * regardless of IBPB implementation.
 		 */
@@ -2676,7 +2676,7 @@ static void __init srso_select_mitigation(void)
 				setup_clear_cpu_cap(X86_FEATURE_RETHUNK);
 
 				/*
-				 * There is no need for RSB filling: entry_ibpb() ensures
+				 * There is no need for RSB filling: __write_ibpb() ensures
 				 * all predictions, including the RSB, are invalidated,
 				 * regardless of IBPB implementation.
 				 */
@@ -2701,7 +2701,7 @@ static void __init srso_select_mitigation(void)
 				srso_mitigation = SRSO_MITIGATION_IBPB_ON_VMEXIT;
 
 				/*
-				 * There is no need for RSB filling: entry_ibpb() ensures
+				 * There is no need for RSB filling: __write_ibpb() ensures
 				 * all predictions, including the RSB, are invalidated,
 				 * regardless of IBPB implementation.
 				 */
-- 
2.48.1


