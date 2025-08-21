Return-Path: <kvm+bounces-55230-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FB97B2EBD4
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 05:18:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B27DE1C87F32
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 03:18:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A69E2E36EA;
	Thu, 21 Aug 2025 03:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jjIATB4z"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C08F18C933;
	Thu, 21 Aug 2025 03:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755746274; cv=none; b=JC3Gc10uLvdqxHL5flIvTfDlQAflUxiY2wXPwpC7xHdfmfBg8DQS+RmJEQYivkiU21cfM0VAqqYW8adWWSXD1ZIppQsB3s62L0G0+ltUmnVP1qo4Xe9CiGZ1x9JgX4uEQQ890YN7ziZWHdVExG+z1RjoI//UNtpx5iLN9e3QXFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755746274; c=relaxed/simple;
	bh=DMRWjGxN262TTh3G5XEfX36BOwhJZxZpsyMaejs1xjc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mXrmADRaZe0vWsnYTkPtL8wr5T4JqCkUDYpO0a3tpA8MgUi9OwcJ5Nt+YfUpztKQYHAovwmv9mtW5ZHS4mVcgvZELT8jOefanHvHAkcnNwDbpUdYDUPiRDkjwhuGM/EAk4ajJbc09ceFkbxxIQmSwqu1lNPjvGeo2jBqyS2+FEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jjIATB4z; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E05C2C113CF;
	Thu, 21 Aug 2025 03:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755746274;
	bh=DMRWjGxN262TTh3G5XEfX36BOwhJZxZpsyMaejs1xjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jjIATB4zD7fodr7HIVXX5acF/oLmA+F+rCzD6d36kDPuMtRAx3DH/T3oGRXgda4ON
	 4ADF4lBAPeSYUsiu7/1iv10poNdPIM2sc9SDTdpRV/lBsbTycsWJ9RBqZWks8e3mHk
	 39gcyPtpbiEd3fyMKBz46Fd4xy/osqSbGn3D8DiPF8myJ0ve3UkJ4fb75aXEkSgHAd
	 IcsH0hU/RxeAsdIa4ZLNw6CsoKy/EdOxykwvGSJq9hLzjtztpQFn2mjS/cC9TVBVVO
	 scyjqOL4BrYmZRGZtmfB8H/4HhPm2pkUCwEJuq/B+H/axgGd/ImyrYtMiPzE4bDfzX
	 jYxrOalEVsyIQ==
From: guoren@kernel.org
To: guoren@kernel.org,
	troy.mitchell@linux.dev
Cc: alex@ghiti.fr,
	anup@brainfault.org,
	aou@eecs.berkeley.edu,
	atish.patra@linux.dev,
	fangyu.yu@linux.alibaba.com,
	guoren@linux.alibaba.com,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	palmer@dabbelt.com,
	paul.walmsley@sifive.com,
	Nutty Liu <nutty.liu@hotmail.com>
Subject: [PATCH V4 3/3] RISC-V: KVM: Prevent HGATP_MODE_BARE passed
Date: Wed, 20 Aug 2025 23:17:18 -0400
Message-Id: <20250821031719.2366017-4-guoren@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20250821031719.2366017-1-guoren@kernel.org>
References: <CAJF2gTQFWJzHhRoQ-oASO9nn1kC0dv+NuK-DD=JgfeHE90RWqw@mail.gmail.com>
 <20250821031719.2366017-1-guoren@kernel.org>
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

Reviewed-by: Troy Mitchell <troy.mitchell@linux.dev>
Reviewed-by: Nutty Liu <nutty.liu@hotmail.com>
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


