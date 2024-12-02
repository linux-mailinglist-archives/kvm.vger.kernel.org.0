Return-Path: <kvm+bounces-32819-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D60E59E024B
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 13:35:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2A481B32307
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 12:12:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A592F203706;
	Mon,  2 Dec 2024 12:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JarQvoen"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B67F6202F95;
	Mon,  2 Dec 2024 12:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733141063; cv=none; b=M0l7eF56b/gzIz4t+acz3FdfTm/b5n1ItGqsUpSm/9S/b2BiYIOHlc7rIAvdqvYJd141r8iv4PKHtnTDgovoEsNfQdrl5ayxDDKYT+zqC/4lXNn9Feovk+22PLrjmvLtdQ1ff7oSA1danOL4puaE19d4at+eby/pbvL8SPcTKik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733141063; c=relaxed/simple;
	bh=+81R2yhEI3xCcGHia9rOeaSyJc2c3Vsh3iF1V5uCdXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kRaNVPAunLYNWJtNcbAGn0Kxm42fTAmGd55ujA9NNXki+TTviSi3KOQEHNz1O/UH8Td5TFEnZhqANd60yOLOdCp5E4mJ0YL9J47ZkCQO+Yw0oCLWy6Sna91Ep7gJM3wr/jT4gRBpb/K5qPJHXYDTgQl3zS0isH1g6vdYTaZ+jZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JarQvoen; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86061C4CED2;
	Mon,  2 Dec 2024 12:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733141063;
	bh=+81R2yhEI3xCcGHia9rOeaSyJc2c3Vsh3iF1V5uCdXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JarQvoen9Ub9hp5ehA5M+u2t8upPDtHrdR+Fj8HYtKuiUJizrG0pg4tqcV/D2yaCV
	 StgtnjWJGdV7Zwsu2hQGFgZhQQLlkUfliIi8wa9IPAbOYquOqQK7Ajn6yQBhmMV4Mc
	 K+dOespHYS5qtPZdYynjvR2u4cj9eLjj0bV1xgM/pvzO8nff8ZvwUI9niI17QI6bXw
	 ccssd689TW9BfufbIMCkprXolbbYPbL1NSdyv6rU1pSN46Sdz9qky4p4xeZOnnDmqY
	 PS+bULIroogjiuXrgGHYprzaymivuhInveUPBqSnzunNLhTQFZNl1NjPnF+RbelJFk
	 m/NzZYUIh5fbw==
From: Borislav Petkov <bp@kernel.org>
To: Sean Christopherson <seanjc@google.com>,
	X86 ML <x86@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	KVM <kvm@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH v2 1/4] x86/bugs: Add SRSO_USER_KERNEL_NO support
Date: Mon,  2 Dec 2024 13:04:13 +0100
Message-ID: <20241202120416.6054-2-bp@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241202120416.6054-1-bp@kernel.org>
References: <20241202120416.6054-1-bp@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Borislav Petkov (AMD)" <bp@alien8.de>

If the machine has:

  CPUID Fn8000_0021_EAX[30] (SRSO_USER_KERNEL_NO) -- If this bit is 1,
  it indicates the CPU is not subject to the SRSO vulnerability across
  user/kernel boundaries.

have it fall back to IBPB on VMEXIT only, in the case it is going to run
VMs:

  Speculative Return Stack Overflow: CPU user/kernel transitions protected, falling back to IBPB-on-VMEXIT
  Speculative Return Stack Overflow: Mitigation: IBPB on VMEXIT only

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/kernel/cpu/bugs.c         | 6 ++++++
 arch/x86/kernel/cpu/common.c       | 1 +
 3 files changed, 8 insertions(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 17b6590748c0..2787227a8b42 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -464,6 +464,7 @@
 #define X86_FEATURE_SBPB		(20*32+27) /* Selective Branch Prediction Barrier */
 #define X86_FEATURE_IBPB_BRTYPE		(20*32+28) /* MSR_PRED_CMD[IBPB] flushes all branch type predictions */
 #define X86_FEATURE_SRSO_NO		(20*32+29) /* CPU is not affected by SRSO */
+#define X86_FEATURE_SRSO_USER_KERNEL_NO	(20*32+30) /* CPU is not affected by SRSO across user/kernel boundaries */
 
 /*
  * Extended auxiliary flags: Linux defined - for features scattered in various
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 47a01d4028f6..8854d9bce2a5 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -2615,6 +2615,11 @@ static void __init srso_select_mitigation(void)
 		break;
 
 	case SRSO_CMD_SAFE_RET:
+		if (boot_cpu_has(X86_FEATURE_SRSO_USER_KERNEL_NO)) {
+			pr_notice("CPU user/kernel transitions protected, falling back to IBPB-on-VMEXIT\n");
+			goto ibpb_on_vmexit;
+		}
+
 		if (IS_ENABLED(CONFIG_MITIGATION_SRSO)) {
 			/*
 			 * Enable the return thunk for generated code
@@ -2658,6 +2663,7 @@ static void __init srso_select_mitigation(void)
 		}
 		break;
 
+ibpb_on_vmexit:
 	case SRSO_CMD_IBPB_ON_VMEXIT:
 		if (IS_ENABLED(CONFIG_MITIGATION_SRSO)) {
 			if (!boot_cpu_has(X86_FEATURE_ENTRY_IBPB) && has_microcode) {
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index a5c28975c608..954f9c727f11 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1270,6 +1270,7 @@ static const struct x86_cpu_id cpu_vuln_blacklist[] __initconst = {
 	VULNBL_AMD(0x17, RETBLEED | SMT_RSB | SRSO),
 	VULNBL_HYGON(0x18, RETBLEED | SMT_RSB | SRSO),
 	VULNBL_AMD(0x19, SRSO),
+	VULNBL_AMD(0x1a, SRSO),
 	{}
 };
 
-- 
2.43.0


