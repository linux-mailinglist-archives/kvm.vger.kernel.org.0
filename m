Return-Path: <kvm+bounces-55319-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C703EB2FCE7
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 16:38:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9EEB11747B8
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 14:30:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B1CD2D73B2;
	Thu, 21 Aug 2025 14:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G73bsXs7"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BFA81DE8B2;
	Thu, 21 Aug 2025 14:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755786377; cv=none; b=ZRN1LWQ28yk5Wbvdfy2GBSvEUN7r+L1oNQFmyRQUsNRdFqYEnYTjf/ZEbakE8NjZ193vDEHUmWdy9WmKjPnmU4MkkpB5ZwFT+k/VBsIkjcOZqbp+G4FfgMFAWkAJNUR4NjOVzeL/ETcFsJAY4u0Di3kMfK7D6Oj3D5oLcTvtWhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755786377; c=relaxed/simple;
	bh=DMRWjGxN262TTh3G5XEfX36BOwhJZxZpsyMaejs1xjc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QbxZz6MtWK56s2lS98i2wYuO/n9FMywNOoE534QJ6J3F9Mon9dc/UnxyY0kSfcU3LaoSHdT4gdzuLjd/Z2uAEBwbP2TWnZFw4hVfL1Z87JkO62KOsXqASIrd1CDGAgRqgEIwpaDE12U2k1KmjhmnIiG4O2e5MaNK/xN0SbQW5ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G73bsXs7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 731B3C4CEEB;
	Thu, 21 Aug 2025 14:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755786377;
	bh=DMRWjGxN262TTh3G5XEfX36BOwhJZxZpsyMaejs1xjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G73bsXs7hd6bavivDbDbKhs7p+62Ff4SrQ/jPxYewju79uoySLhmxkH+pdQZ/Ceyj
	 r2Vk9curcO7fNu6BpgeLvrz9J2V0L4vODztLkCsOeG11FQiXJYhINEwTtdVclPPVhW
	 DbDQ018IYJzoc/GXZedNDbBUuear7VwvMLQ1IjvxpeKGwl7i1OI2XQfIy/JzvpRDBv
	 iBZqv9ZzouDtAZQgMGbcU7qmi0XB+WXR+2Q3YaRg5tM0O+TNex5Rk+IwikjU6SUfc4
	 1MVVA4qw8cWs7laRu0ivQWY4PANZ8ftoIM9gmxam3in9qV9WGmgGE5vWfh2N0uD+8i
	 1vQxucfj4vQZQ==
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
Subject: [PATCH V4 RESEND 3/3] RISC-V: KVM: Prevent HGATP_MODE_BARE passed
Date: Thu, 21 Aug 2025 10:25:42 -0400
Message-Id: <20250821142542.2472079-4-guoren@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20250821142542.2472079-1-guoren@kernel.org>
References: <20250821142542.2472079-1-guoren@kernel.org>
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


