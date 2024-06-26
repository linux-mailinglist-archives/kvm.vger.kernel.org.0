Return-Path: <kvm+bounces-20531-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F13B69179D8
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 09:38:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7CE9FB231E4
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 07:37:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87FA315F32D;
	Wed, 26 Jun 2024 07:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LTSGT5eJ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD8721FBB;
	Wed, 26 Jun 2024 07:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719387455; cv=none; b=q2FrthtLFHTUixRtxswg9sC8GZlkfRt+oYbT2YQ0cIuwjWpQjsWZ2ohKkul02icY29on53y8tRlP4p4Y/UD9X3l9ppz4VzeawAJxVLaaWLRKJUL9nM9egDXxgfa9WTFDcTAsW60xM09YimL0CHHWnlDSs8KqE3wkyCXt68EOAA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719387455; c=relaxed/simple;
	bh=ndOzFlNF7mgXZbFomdTEHkww/+uY25Qtzri+zDpcuNU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DnOeX7IQQkhygJz9q3N2BuTq6udat8f3pF2W+BgKCqo+gmwNHKSVbRyiGjd4sCr1Dxv/k6ishLCIvQF5G3XwK9mrmCXFrC9vQXALQbjHEo2CG13gkhEzbGukrTSnzGsti/NtEGAacikMPRbkLVttjkHFPY/MCvP+1xuciInqNYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LTSGT5eJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 903C5C32789;
	Wed, 26 Jun 2024 07:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719387455;
	bh=ndOzFlNF7mgXZbFomdTEHkww/+uY25Qtzri+zDpcuNU=;
	h=From:To:Cc:Subject:Date:From;
	b=LTSGT5eJpaTgQVTluRtjprVjIcx53X7vmbk1X7v+8wg93zEvg+wfgByOPa2yjy4Aq
	 isnyIW4pGbQ9hZTyoRjVCtHzkfC8d2jQHzUJrYUGhIVwNZ2b4hyAv5jd+aEMgmGEj3
	 xmFuYL2l5mF42JYtCjwMrGcOzrJ1bEz2A2c4R0ecUYjQAE/OeTT7T6t11zHwTVsSj7
	 Xe6fgdpTYunXVod1KtwtENq3wJx89AzVH2UkCJf9mzBLjoDEaMtjgzcsVmovTkeKLu
	 FSPtXdzza1bzyhaSWyYh7q7y8weh/yGVRBQ1Qaepj0MqV9NpFE9ZCDNdHel4+Nqyth
	 BGFfrj+djDicg==
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
Subject: [PATCH v2] KVM: SVM: let alternatives handle the cases when RSB filling is required
Date: Wed, 26 Jun 2024 09:37:19 +0200
Message-ID: <20240626073719.5246-1-amit@kernel.org>
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
v2:
 - tweak commit message re: Boris's comments.
---
 arch/x86/kvm/svm/vmenter.S | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
index a0c8eb37d3e1..2ed80aea3bb1 100644
--- a/arch/x86/kvm/svm/vmenter.S
+++ b/arch/x86/kvm/svm/vmenter.S
@@ -209,10 +209,8 @@ SYM_FUNC_START(__svm_vcpu_run)
 7:	vmload %_ASM_AX
 8:
 
-#ifdef CONFIG_MITIGATION_RETPOLINE
 	/* IMPORTANT: Stuff the RSB immediately after VM-Exit, before RET! */
-	FILL_RETURN_BUFFER %_ASM_AX, RSB_CLEAR_LOOPS, X86_FEATURE_RETPOLINE
-#endif
+	FILL_RETURN_BUFFER %_ASM_AX, RSB_CLEAR_LOOPS, X86_FEATURE_RSB_VMEXIT
 
 	/* Clobbers RAX, RCX, RDX.  */
 	RESTORE_HOST_SPEC_CTRL
@@ -348,10 +346,8 @@ SYM_FUNC_START(__svm_sev_es_vcpu_run)
 
 2:	cli
 
-#ifdef CONFIG_MITIGATION_RETPOLINE
 	/* IMPORTANT: Stuff the RSB immediately after VM-Exit, before RET! */
-	FILL_RETURN_BUFFER %rax, RSB_CLEAR_LOOPS, X86_FEATURE_RETPOLINE
-#endif
+	FILL_RETURN_BUFFER %rax, RSB_CLEAR_LOOPS, X86_FEATURE_RSB_VMEXIT
 
 	/* Clobbers RAX, RCX, RDX, consumes RDI (@svm) and RSI (@spec_ctrl_intercepted). */
 	RESTORE_HOST_SPEC_CTRL
-- 
2.45.2


