Return-Path: <kvm+bounces-54936-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A4CDB2B587
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 02:47:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ED3E5624BA9
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 00:47:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6434518DF89;
	Tue, 19 Aug 2025 00:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jrngg2QV"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E7DD531;
	Tue, 19 Aug 2025 00:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755564417; cv=none; b=KqsHjLZByJj+VKkt+jSehnimHgL8xvMT0F6t4fmSXspFcnH9UWcWzflPYQ4ONh9E7FzETUJWTTRbhiJKi9HzxmEFMBqsK2+kWtfaDpjKYJMlK3rIpM1SBsUSFNbezQfWkYmYvzzKUOTQGDlL2J3Wzx9nS1Xz9uGtKK0vAm7+CpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755564417; c=relaxed/simple;
	bh=DsWrRR/JVk9NGxDPruscs5vh74AouGxQra9oUbC6csk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Ri+2FCML1QOXK8rH1SWvHsKfXmYmkKaBPmYb0iWGMAFiwZ2DY0bm1ARoDT0+mFcpk2Xc8KVhBeYOFTN3XFEZUrz8Lw1RdUWmT+N5NYYioHhyXTktLRmaXWxlis1+I6kETCnWJKyrxIvw7hrFA+8A7HLmvG4QxrJyxF/rNQokfR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jrngg2QV; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49635C4CEEB;
	Tue, 19 Aug 2025 00:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755564417;
	bh=DsWrRR/JVk9NGxDPruscs5vh74AouGxQra9oUbC6csk=;
	h=From:To:Cc:Subject:Date:From;
	b=jrngg2QVHRvbWwsNWWKdi2b4rtirPpuFcxNJHZtkGhRWaGMuCRMGttAin2yqP98FL
	 hIM8dVJa2Mn/sHI1p3ADOnVK+smt6TMQrJNUodhQXrnI2j1NnXRcB724Mi78/dWQWj
	 Z5vlJPpbXAgBDfn/xKx5PnKFqdJKPRLPxE8M3zIgaQmB1+1aoLqcvNDYHapDpoQKZS
	 IVdloivkEZkyZtClFh88C0QwCS3F4rG0klz/AB3CnIob55qqdYI9d970hqWfHdT6ot
	 kDCYGT+RRQY7WYPG8wQz1qfKdE6jEG9/gI4TZn6h3FOpnmP7JkYPQJpRHavzgXtyOT
	 3aOnScz/HTgLw==
From: guoren@kernel.org
To: guoren@kernel.org,
	paul.walmsley@sifive.com,
	anup@brainfault.org,
	atish.patra@linux.dev,
	fangyu.yu@linux.alibaba.com
Cc: linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Subject: [PATCH] RISC-V: KVM: Prevent HGATP_MODE_BARE passed
Date: Mon, 18 Aug 2025 20:46:43 -0400
Message-Id: <20250819004643.1884149-1-guoren@kernel.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Guo Ren (Alibaba DAMO Academy)" <guoren@kernel.org>

urrent kvm_riscv_gstage_mode_detect() assumes H-extension must
have HGATP_MODE_SV39X4/SV32X4 at least, but the spec allows
H-extension with HGATP_MODE_BARE alone. The KVM depends on
!HGATP_MODE_BARE at least, so enhance the gstage-mode-detect
to block HGATP_MODE_BARE.

Move gstage-mode-check closer to gstage-mode-detect to prevent
unnecessary init.

Signed-off-by: Guo Ren (Alibaba DAMO Academy) <guoren@kernel.org>
---
 arch/riscv/kvm/gstage.c | 27 ++++++++++++++++++++++++---
 arch/riscv/kvm/main.c   | 35 +++++++++++++++++------------------
 2 files changed, 41 insertions(+), 21 deletions(-)

diff --git a/arch/riscv/kvm/gstage.c b/arch/riscv/kvm/gstage.c
index 24c270d6d0e2..b67d60d722c2 100644
--- a/arch/riscv/kvm/gstage.c
+++ b/arch/riscv/kvm/gstage.c
@@ -321,7 +321,7 @@ void __init kvm_riscv_gstage_mode_detect(void)
 	if ((csr_read(CSR_HGATP) >> HGATP_MODE_SHIFT) == HGATP_MODE_SV57X4) {
 		kvm_riscv_gstage_mode = HGATP_MODE_SV57X4;
 		kvm_riscv_gstage_pgd_levels = 5;
-		goto skip_sv48x4_test;
+		goto done;
 	}
 
 	/* Try Sv48x4 G-stage mode */
@@ -329,10 +329,31 @@ void __init kvm_riscv_gstage_mode_detect(void)
 	if ((csr_read(CSR_HGATP) >> HGATP_MODE_SHIFT) == HGATP_MODE_SV48X4) {
 		kvm_riscv_gstage_mode = HGATP_MODE_SV48X4;
 		kvm_riscv_gstage_pgd_levels = 4;
+		goto done;
 	}
-skip_sv48x4_test:
 
+	/* Try Sv39x4 G-stage mode */
+	csr_write(CSR_HGATP, HGATP_MODE_SV39X4 << HGATP_MODE_SHIFT);
+	if ((csr_read(CSR_HGATP) >> HGATP_MODE_SHIFT) == HGATP_MODE_SV39X4) {
+		kvm_riscv_gstage_mode = HGATP_MODE_SV39X4;
+		kvm_riscv_gstage_pgd_levels = 3;
+		goto done;
+	}
+#else /* CONFIG_32BIT */
+	/* Try Sv32x4 G-stage mode */
+	csr_write(CSR_HGATP, HGATP_MODE_SV32X4 << HGATP_MODE_SHIFT);
+	if ((csr_read(CSR_HGATP) >> HGATP_MODE_SHIFT) == HGATP_MODE_SV32X4) {
+		kvm_riscv_gstage_mode = HGATP_MODE_SV32X4;
+		kvm_riscv_gstage_pgd_levels = 2;
+		goto done;
+	}
+#endif
+
+	/* KVM depends on !HGATP_MODE_OFF */
+	kvm_riscv_gstage_mode = HGATP_MODE_OFF;
+	kvm_riscv_gstage_pgd_levels = 0;
+
+done:
 	csr_write(CSR_HGATP, 0);
 	kvm_riscv_local_hfence_gvma_all();
-#endif
 }
diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
index 67c876de74ef..8ee7aaa74ddc 100644
--- a/arch/riscv/kvm/main.c
+++ b/arch/riscv/kvm/main.c
@@ -93,6 +93,23 @@ static int __init riscv_kvm_init(void)
 		return rc;
 
 	kvm_riscv_gstage_mode_detect();
+	switch (kvm_riscv_gstage_mode) {
+	case HGATP_MODE_SV32X4:
+		str = "Sv32x4";
+		break;
+	case HGATP_MODE_SV39X4:
+		str = "Sv39x4";
+		break;
+	case HGATP_MODE_SV48X4:
+		str = "Sv48x4";
+		break;
+	case HGATP_MODE_SV57X4:
+		str = "Sv57x4";
+		break;
+	default:
+		return -ENODEV;
+	}
+	kvm_info("using %s G-stage page table format\n", str);
 
 	kvm_riscv_gstage_vmid_detect();
 
@@ -135,24 +152,6 @@ static int __init riscv_kvm_init(void)
 			 (rc) ? slist : "no features");
 	}
 
-	switch (kvm_riscv_gstage_mode) {
-	case HGATP_MODE_SV32X4:
-		str = "Sv32x4";
-		break;
-	case HGATP_MODE_SV39X4:
-		str = "Sv39x4";
-		break;
-	case HGATP_MODE_SV48X4:
-		str = "Sv48x4";
-		break;
-	case HGATP_MODE_SV57X4:
-		str = "Sv57x4";
-		break;
-	default:
-		return -ENODEV;
-	}
-	kvm_info("using %s G-stage page table format\n", str);
-
 	kvm_info("VMID %ld bits available\n", kvm_riscv_gstage_vmid_bits());
 
 	if (kvm_riscv_aia_available())
-- 
2.40.1


