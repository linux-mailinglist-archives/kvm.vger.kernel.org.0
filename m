Return-Path: <kvm+bounces-23340-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A5B0A948D42
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 12:53:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D72181C23575
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 10:53:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1203C1C0DE3;
	Tue,  6 Aug 2024 10:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W0MOSvny"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36285161310;
	Tue,  6 Aug 2024 10:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722941580; cv=none; b=ENlcGqloV+fYh924jfydYFOs+lGXFxDxD3zbc4YNm3eGsKuR1txR21nheA7FAzQjHw8xcMILNVq1cZnMoPRepoF+iieUeo0EcMbqnId38Q9IR7dRu9raqlMQShD3dZ2riC3sqEkKcZW4tKtHxo97QVTOVo1U1CTpgYxTjZnsJ7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722941580; c=relaxed/simple;
	bh=EkKMxxSMZRePpCMe2tSDiAV8730Q2+erHGgzoyi5cnU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GDlgPxpQ+QdbhYMkezCYpa4/er4WzqV7yJqqfTRwZPR9Qt37lzrX1Ouxgd60/1uKsPl0Vs0MKHMlFA8cj02h/uhFdAhJYbPT/fEU/WKfPJSV47puI9O+uJA/WJe0VRLT8InOyBvoX4ND0TcOnhC5+jkOJBs0d/UKZPRp9HUmKqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W0MOSvny; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E20FAC32786;
	Tue,  6 Aug 2024 10:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722941579;
	bh=EkKMxxSMZRePpCMe2tSDiAV8730Q2+erHGgzoyi5cnU=;
	h=From:To:Cc:Subject:Date:From;
	b=W0MOSvnyLaflLR4yTGHlkzqkxOfeo1jiYOdIyCx42gEcQd1Td+TmiI/GR5mBu1o/Z
	 MP2/oitYFqDmEYk33ZrhLSOhwSLhLTg0JmkB7e+vkaFCtKTwTHg1mArHowILqFe1NS
	 LuyQnNu8pmLo7kcyMCScOhRaZQeKD+IUGXtvx8WjUla95rwasHEa+eKUeoXUV6j14e
	 QQ5Fqg0nrXmBnhPwH1WejfJ9XVn7uR7rVxByXd25YVJp0SXujSJ7LQyfqwhqMhMAyo
	 PynFNnD8BIQRa7M+KZvbXlvBV7AFz1RAyJIRZx6fteGqS1fwn1nztM1m2O2D/6U3xq
	 EQwkoLTMqfUVw==
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
Subject: [PATCH] KVM: SVM: let alternatives handle the cases when RSB filling is required
Date: Tue,  6 Aug 2024 12:52:45 +0200
Message-ID: <20240806105245.13993-1-amit@kernel.org>
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


