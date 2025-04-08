Return-Path: <kvm+bounces-42964-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F390A817D7
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 23:48:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DA3BF1B8804E
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 21:48:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 008B8255E30;
	Tue,  8 Apr 2025 21:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DycNW4I2"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24B53255222;
	Tue,  8 Apr 2025 21:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744148883; cv=none; b=FwCZb6YHkH1iFnE69cRj3TvDb3y7+2k7+Illl7jWFADvWM8Yec2Dl80xVCIc2YS+JL59NNv9xMOYLRU3X7eN+ZiuEZptp067CIcMDwePeh9uerJwhJMIOyL0Gr41XQ+w7rW50yKnJeLqXzAZuLfTSj/noebfNg9ZKvxXpggKNUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744148883; c=relaxed/simple;
	bh=c/oFWdmB8Lm8up00opCo8sX9e64iLhaPQi3f/44+TMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kkSmrNPdNqX3CwwBPFSn9MqT9IXDTtL7QtS38/HZ9ppoB3QjMviA+jUq9YNo2PTzgb1XklOgvAx2cXd6b4NZzwoV8ZPLSSAby8frXEhEBobH0vQASHlgEdprBGJbeS3mFzcD0atOv1QyVadA5lQFsPBU2PhDw6Q+mJWGrrDeaEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DycNW4I2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4B66C4CEE9;
	Tue,  8 Apr 2025 21:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744148882;
	bh=c/oFWdmB8Lm8up00opCo8sX9e64iLhaPQi3f/44+TMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DycNW4I27oUvHux/3AtaeQZ656n2bxpehgi+ND2/cT96e00TG1j8+Do39+ikTo2lY
	 9lW9OPV4stRSWzof6xuIn2XyNtjyvtH94yFGEuvOczwjpVhgd/hYSnRj8qiiNlAaJj
	 tltgqxeaupweaZn90211gqDwFmMJM4ScLY8IL0xZxC056lHfqEfoow9FvJ1X+dZ/XM
	 KuCLc3FtESuj5ptPvHlXKWZ7nofoQHeo+MX5L+5xMAwphUU+yexCe0GKUHm0j2pckP
	 9QqgalpIsYlvGHq4+cwbBvhC3QvI9AsRrZMd5khj3k8QZgcgcZU0q5dXMWv+ewykrd
	 f4+TVQyUsBRjA==
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
Subject: [PATCH v4 1/6] x86/bugs: Rename entry_ibpb() to write_ibpb()
Date: Tue,  8 Apr 2025 14:47:30 -0700
Message-ID: <1e54ace131e79b760de3fe828264e26d0896e3ac.1744148254.git.jpoimboe@kernel.org>
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

There's nothing entry-specific about entry_ibpb().  In preparation for
calling it from elsewhere, rename it to write_ibpb().

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 arch/x86/entry/entry.S               | 7 ++++---
 arch/x86/include/asm/nospec-branch.h | 6 +++---
 arch/x86/kernel/cpu/bugs.c           | 6 +++---
 3 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/x86/entry/entry.S b/arch/x86/entry/entry.S
index d3caa31240ed..cabe65ac8379 100644
--- a/arch/x86/entry/entry.S
+++ b/arch/x86/entry/entry.S
@@ -17,7 +17,8 @@
 
 .pushsection .noinstr.text, "ax"
 
-SYM_FUNC_START(entry_ibpb)
+/* Clobbers AX, CX, DX */
+SYM_FUNC_START(write_ibpb)
 	ANNOTATE_NOENDBR
 	movl	$MSR_IA32_PRED_CMD, %ecx
 	movl	$PRED_CMD_IBPB, %eax
@@ -27,9 +28,9 @@ SYM_FUNC_START(entry_ibpb)
 	/* Make sure IBPB clears return stack preductions too. */
 	FILL_RETURN_BUFFER %rax, RSB_CLEAR_LOOPS, X86_BUG_IBPB_NO_RET
 	RET
-SYM_FUNC_END(entry_ibpb)
+SYM_FUNC_END(write_ibpb)
 /* For KVM */
-EXPORT_SYMBOL_GPL(entry_ibpb);
+EXPORT_SYMBOL_GPL(write_ibpb);
 
 .popsection
 
diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index 8a5cc8e70439..591d1dbca60a 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -269,7 +269,7 @@
  * typically has NO_MELTDOWN).
  *
  * While retbleed_untrain_ret() doesn't clobber anything but requires stack,
- * entry_ibpb() will clobber AX, CX, DX.
+ * write_ibpb() will clobber AX, CX, DX.
  *
  * As such, this must be placed after every *SWITCH_TO_KERNEL_CR3 at a point
  * where we have a stack but before any RET instruction.
@@ -279,7 +279,7 @@
 	VALIDATE_UNRET_END
 	CALL_UNTRAIN_RET
 	ALTERNATIVE_2 "",						\
-		      "call entry_ibpb", \ibpb_feature,			\
+		      "call write_ibpb", \ibpb_feature,			\
 		     __stringify(\call_depth_insns), X86_FEATURE_CALL_DEPTH
 #endif
 .endm
@@ -368,7 +368,7 @@ extern void srso_return_thunk(void);
 extern void srso_alias_return_thunk(void);
 
 extern void entry_untrain_ret(void);
-extern void entry_ibpb(void);
+extern void write_ibpb(void);
 
 #ifdef CONFIG_X86_64
 extern void clear_bhb_loop(void);
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 4386aa6c69e1..608bbe6cf730 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1142,7 +1142,7 @@ static void __init retbleed_select_mitigation(void)
 		setup_clear_cpu_cap(X86_FEATURE_RETHUNK);
 
 		/*
-		 * There is no need for RSB filling: entry_ibpb() ensures
+		 * There is no need for RSB filling: write_ibpb() ensures
 		 * all predictions, including the RSB, are invalidated,
 		 * regardless of IBPB implementation.
 		 */
@@ -2676,7 +2676,7 @@ static void __init srso_select_mitigation(void)
 				setup_clear_cpu_cap(X86_FEATURE_RETHUNK);
 
 				/*
-				 * There is no need for RSB filling: entry_ibpb() ensures
+				 * There is no need for RSB filling: write_ibpb() ensures
 				 * all predictions, including the RSB, are invalidated,
 				 * regardless of IBPB implementation.
 				 */
@@ -2701,7 +2701,7 @@ static void __init srso_select_mitigation(void)
 				srso_mitigation = SRSO_MITIGATION_IBPB_ON_VMEXIT;
 
 				/*
-				 * There is no need for RSB filling: entry_ibpb() ensures
+				 * There is no need for RSB filling: write_ibpb() ensures
 				 * all predictions, including the RSB, are invalidated,
 				 * regardless of IBPB implementation.
 				 */
-- 
2.49.0


