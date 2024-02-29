Return-Path: <kvm+bounces-10507-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C534386CC2A
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 15:54:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7BB3D289178
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 14:54:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0C9F137775;
	Thu, 29 Feb 2024 14:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A3Xx+DQd"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CDDE13775B;
	Thu, 29 Feb 2024 14:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709218467; cv=none; b=bd8609GM3j4sqVdsd89rg3YXjtooE8bd3coASkMdWHh3e+qwtEFsHtT98QdG51aVdtbqOtudr2drmNhY/hLbsGLfdoflFmLgZJE0MBPgSP9L+EojHkAEh/yJUEaNzOOPoCB9kjdlZ4mETr7Lfw67HznT/b7d85qQBd54bO98h6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709218467; c=relaxed/simple;
	bh=r6oB4kaLBR7dvKtM/qhXIjLnaZum9WS4h7QaCR+0Xsg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=hk+vGOsnhxcfi0bPOE8m3DpyQNDbp6xtfOO1CQhEWXP5zd9BKTKuTxmFTRlLyAAc4/sMamMVYpB3H0JMinOHEVK9q1jQ37Yzu9ZGfmCsrHt0MtF6wIqf9tJNEGmB3BIV+D7eiYqp27tV3zEejqdvkBaH3r2OMITgO4U4k9FVYV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A3Xx+DQd; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD49FC433F1;
	Thu, 29 Feb 2024 14:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709218466;
	bh=r6oB4kaLBR7dvKtM/qhXIjLnaZum9WS4h7QaCR+0Xsg=;
	h=From:To:Cc:Subject:Date:From;
	b=A3Xx+DQdVDNSTWUcQ1acFEsa4BYLaImGQigxZ+3fDiW7fuVb9EPirYkTEzf0TlsKp
	 735BCZc1Oen1GcHfZ5/CkqhY5/zMg5aaDlPUClc/jGeL/9vJLMi3xIhm86skRfGlIq
	 FGsGYZShg1SHy6e3BkLUFco9bY5SPpPP+fk5eZECMEfdxfNgODyNEPFBSMB1ux47ld
	 /8lwLvy86boQBPYR3juGCR9jB3NTF5nz9EXfwny+0o1t9MMtGK8SVyMa6XH1piQmRq
	 CTyboUpSEsKaXgarL0+fyqJAns9e7mp566eNyDUiRJKHVAWxDBI9Kq3gTpp+wsRBLA
	 nkhrlML2uZiPA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rfhnk-0082lm-Bg;
	Thu, 29 Feb 2024 14:54:24 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	James Clark <james.clark@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>
Subject: [PATCH] KVM: arm64: Fix TRFCR_EL1/PMSCR_EL1 access in hVHE mode
Date: Thu, 29 Feb 2024 14:54:17 +0000
Message-Id: <20240229145417.3606279-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, james.clark@arm.com, anshuman.khandual@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

When running in hVHE mode, EL1 accesses are performed with the EL12
accessor, as we run with HCR_EL2.E2H=1.

Unfortunately, both PMSCR_EL1 and TRFCR_EL1 are used with the
EL1 accessor, meaning that we actually affect the EL2 state. Duh.

Switch to using the {read,write}_sysreg_el1() helpers that will do
the right thing in all circumstances.

Note that the 'Fixes:' tag doesn't represent the point where the bug
was introduced (there is no such point), but the first practical point
where the hVHE feature is usable.

Cc: James Clark <james.clark@arm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Fixes: 38cba55008e5 ("KVM: arm64: Force HCR_E2H in guest context when ARM64_KVM_HVHE is set")
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/debug-sr.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
index 8103f8c695b4..6d57b5c86a91 100644
--- a/arch/arm64/kvm/hyp/nvhe/debug-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
@@ -31,8 +31,8 @@ static void __debug_save_spe(u64 *pmscr_el1)
 		return;
 
 	/* Yes; save the control register and disable data generation */
-	*pmscr_el1 = read_sysreg_s(SYS_PMSCR_EL1);
-	write_sysreg_s(0, SYS_PMSCR_EL1);
+	*pmscr_el1 = read_sysreg_el1(SYS_PMSCR);
+	write_sysreg_el1(0, SYS_PMSCR);
 	isb();
 
 	/* Now drain all buffered data to memory */
@@ -48,7 +48,7 @@ static void __debug_restore_spe(u64 pmscr_el1)
 	isb();
 
 	/* Re-enable data generation */
-	write_sysreg_s(pmscr_el1, SYS_PMSCR_EL1);
+	write_sysreg_el1(pmscr_el1, SYS_PMSCR);
 }
 
 static void __debug_save_trace(u64 *trfcr_el1)
@@ -63,8 +63,8 @@ static void __debug_save_trace(u64 *trfcr_el1)
 	 * Since access to TRFCR_EL1 is trapped, the guest can't
 	 * modify the filtering set by the host.
 	 */
-	*trfcr_el1 = read_sysreg_s(SYS_TRFCR_EL1);
-	write_sysreg_s(0, SYS_TRFCR_EL1);
+	*trfcr_el1 = read_sysreg_el1(SYS_TRFCR);
+	write_sysreg_el1(0, SYS_TRFCR);
 	isb();
 	/* Drain the trace buffer to memory */
 	tsb_csync();
@@ -76,7 +76,7 @@ static void __debug_restore_trace(u64 trfcr_el1)
 		return;
 
 	/* Restore trace filter controls */
-	write_sysreg_s(trfcr_el1, SYS_TRFCR_EL1);
+	write_sysreg_el1(trfcr_el1, SYS_TRFCR);
 }
 
 void __debug_save_host_buffers_nvhe(struct kvm_vcpu *vcpu)
-- 
2.39.2


