Return-Path: <kvm+bounces-23533-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8747A94A7CD
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 14:36:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 413162851C0
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 12:36:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEE191E674F;
	Wed,  7 Aug 2024 12:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LlP1KoaO"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 123871E2101;
	Wed,  7 Aug 2024 12:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723034159; cv=none; b=jKj+FpjTG/MBvMMG5pGvRRYqQnoWrGRKlmtMQ9S+U9ldPKFEruQeyDB88NWB5pZzBnqXs2K2V/VjvGK7+fZHHqPlqhxEB3tpThtbf179on1Co4ei5DrnMic8leUnf20808n3pdrkaiEwr1tAuwbGgzXfJMzaPAGvJ0x8c+SJLbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723034159; c=relaxed/simple;
	bh=WN0fJI4solTC3GkSCUWyRjtzYFNVoGLFPZqwbfMcIq4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PS8c1vRodN+SiR01RLxge6Vk04fMwWZBLdyNxsX3dnyiFFJ4ABxcnNPLhTXGXGRCrMrV4HXBXSu/jSq1YnBgmycKOKsIFJ9vh/ykPYasRB007Nfd9Uirr+FRRc3IQzkFMdACD/RfcuJShuJ3kUT5yzWzabdEmYtHTwCAqyPIHEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LlP1KoaO; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD1B6C4AF0B;
	Wed,  7 Aug 2024 12:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723034158;
	bh=WN0fJI4solTC3GkSCUWyRjtzYFNVoGLFPZqwbfMcIq4=;
	h=From:To:Cc:Subject:Date:From;
	b=LlP1KoaOSK3IbWtES4IBLMWzgF/B1pnZ5zmm/rn/3Vrke8YeiQEH89GtHzv1DUlhH
	 fFNPfcsjiWLc8n7/HFpyBB8XRZUIpsVlGLwz9Ybw2x2ThYlcGulz7H/oN+ZapQO0xb
	 T5kdmmRLQv/bO9tn7sZ+9DQYHh1Hf3I9szpdusSpYmK+ZSbVIvhFy2MCkWMbvWeAoe
	 f8lpZkY0aD8pbKXF61K8jo22BGaDci3FNazZNO2+r9LBOlT8RhmruuDNgOYSB2cjsY
	 ueL/Q3mqtEwXlH4UwdG/CkQx6+e/dOjhfXDQIzptsDndAZplZcZlyZm2cVfnF/CHUF
	 eBoRPhMzBeKxw==
From: Amit Shah <amit@kernel.org>
To: seanjc@google.com,
	pbonzini@redhat.com,
	x86@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: amit.shah@amd.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	kim.phillips@amd.com,
	david.kaplan@amd.com
Subject: [PATCH v4] KVM: SVM: let alternatives handle the cases when RSB filling is required
Date: Wed,  7 Aug 2024 14:35:31 +0200
Message-ID: <20240807123531.69677-1-amit@kernel.org>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Amit Shah <amit.shah@amd.com>

Remove superfluous RSB filling after a VMEXIT when the CPU already has
flushed the RSB after a VMEXIT when AutoIBRS is enabled.

The initial implementation for adding RETPOLINES added an ALTERNATIVES
implementation for filling the RSB after a VMEXIT in

commit 117cc7a908c836 ("x86/retpoline: Fill return stack buffer on vmexit")

Later, X86_FEATURE_RSB_VMEXIT was added in

commit 2b129932201673 ("x86/speculation: Add RSB VM Exit protections")

The AutoIBRS (on AMD CPUs) feature implementation added in

commit e7862eda309ecf ("x86/cpu: Support AMD Automatic IBRS")

used the already-implemented logic for EIBRS in
spectre_v2_determine_rsb_fill_type_on_vmexit() -- but did not update the
code at VMEXIT to act on the mode selected in that function -- resulting
in VMEXITs continuing to clear the RSB when RETPOLINES are enabled,
despite the presence of AutoIBRS.

Signed-off-by: Amit Shah <amit.shah@amd.com>

---
v4: resend of v3 with subject-prefix fixed

v3:
 - Add a comment mentioning SVM does not need RSB_VMEXIT_LITE unlike
   VMX.
v2:
 - tweak commit message re: Boris's comments.

 arch/x86/kvm/svm/vmenter.S | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
index a0c8eb37d3e1..69d9825ebdd9 100644
--- a/arch/x86/kvm/svm/vmenter.S
+++ b/arch/x86/kvm/svm/vmenter.S
@@ -209,10 +209,14 @@ SYM_FUNC_START(__svm_vcpu_run)
 7:	vmload %_ASM_AX
 8:
 
-#ifdef CONFIG_MITIGATION_RETPOLINE
-	/* IMPORTANT: Stuff the RSB immediately after VM-Exit, before RET! */
-	FILL_RETURN_BUFFER %_ASM_AX, RSB_CLEAR_LOOPS, X86_FEATURE_RETPOLINE
-#endif
+	/*
+	 * IMPORTANT: Stuff the RSB immediately after VM-Exit, before RET!
+	 *
+	 * Unlike VMX, AMD does not have the hardware bug that necessitates
+	 * RSB_VMEXIT_LITE
+	 */
+
+	FILL_RETURN_BUFFER %_ASM_AX, RSB_CLEAR_LOOPS, X86_FEATURE_RSB_VMEXIT
 
 	/* Clobbers RAX, RCX, RDX.  */
 	RESTORE_HOST_SPEC_CTRL
@@ -348,10 +352,14 @@ SYM_FUNC_START(__svm_sev_es_vcpu_run)
 
 2:	cli
 
-#ifdef CONFIG_MITIGATION_RETPOLINE
-	/* IMPORTANT: Stuff the RSB immediately after VM-Exit, before RET! */
-	FILL_RETURN_BUFFER %rax, RSB_CLEAR_LOOPS, X86_FEATURE_RETPOLINE
-#endif
+	/*
+	 * IMPORTANT: Stuff the RSB immediately after VM-Exit, before RET!
+	 *
+	 * Unlike VMX, AMD does not have the hardware bug that necessitates
+	 * RSB_VMEXIT_LITE
+	 */
+
+	FILL_RETURN_BUFFER %rax, RSB_CLEAR_LOOPS, X86_FEATURE_RSB_VMEXIT
 
 	/* Clobbers RAX, RCX, RDX, consumes RDI (@svm) and RSI (@spec_ctrl_intercepted). */
 	RESTORE_HOST_SPEC_CTRL
-- 
2.45.2


