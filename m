Return-Path: <kvm+bounces-54940-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 64417B2B6A0
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 04:03:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 18DA81B607F9
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 02:02:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B07524C068;
	Tue, 19 Aug 2025 02:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="pPpTDvqk"
X-Original-To: kvm@vger.kernel.org
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47758189F20;
	Tue, 19 Aug 2025 02:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755568910; cv=none; b=PpNkCj6OamJxRmp9GKXn5LJKslrxCL7qPNEkroIiu1t1VAkhCF0J/KqvGsf6TTxc8nRpxiDlyJZcFMKe1X9LKbphbeWsc3eMR6oKZWkspMRKjz2DlAPfwxvZAAc8iR49f1eOoYLhFZ0NeDQXASGJiu2iSfJ/itkCVrUdcS/J/6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755568910; c=relaxed/simple;
	bh=kpJ529nLFpZYhOhFdxXRXKi3IP6YxshWJN+qitKNDeU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=meKpZiOZl9b7TN4U4HH8osBauSnT09jjm3khwAsO9UcDLl0gwpGauExzcPIpf94cImIUcT8p02t99jLdY0bVqlMI7QGepb80VzFouNALsLomoN5E7KSUMoWIyGTGkQVDtq4G21ny2sruy+JdcHKduXERuyVVU8SQQSot8o8c5PU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=pPpTDvqk; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1755568897; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=5IULTEMO8UY5UYSTMLLyWq2kUCXNHZOA+68prgWQp1U=;
	b=pPpTDvqkTnU5HDZis5Li5Cy7KR2rxfflSShi6+yO85bQbNmKjksR7H40Oi1CwPTdjpnvXAsKuUtWEzWDwXgmbSFRX3dxBobJcGuZ5Yoe5wluv9SMCQeUzTN2b8k3QyaW0Lz/wZY/F0XZ2dtTL8//Hq6FV1K2sff95oWet5EtfL8=
Received: from localhost.localdomain(mailfrom:fangyu.yu@linux.alibaba.com fp:SMTPD_---0Wm4x1Pe_1755568895 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 19 Aug 2025 10:01:37 +0800
From: fangyu.yu@linux.alibaba.com
To: guoren@kernel.org
Cc: anup@brainfault.org,
	atish.patra@linux.dev,
	fangyu.yu@linux.alibaba.com,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	paul.walmsley@sifive.com
Subject: [PATCH] RISC-V: KVM: Prevent HGATP_MODE_BARE passed
Date: Tue, 19 Aug 2025 10:01:33 +0800
Message-Id: <20250819020133.93545-1-fangyu.yu@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20250819004643.1884149-1-guoren@kernel.org>
References: <20250819004643.1884149-1-guoren@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

>From: "Guo Ren (Alibaba DAMO Academy)" <guoren@kernel.org>
>
>urrent kvm_riscv_gstage_mode_detect() assumes H-extension must
>have HGATP_MODE_SV39X4/SV32X4 at least, but the spec allows
>H-extension with HGATP_MODE_BARE alone. The KVM depends on
>!HGATP_MODE_BARE at least, so enhance the gstage-mode-detect
>to block HGATP_MODE_BARE.
>
>Move gstage-mode-check closer to gstage-mode-detect to prevent
>unnecessary init.

This patch helps to detect hardware function missing in advance,
prevent software from entering incorrect logic.

Reviewed-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>

>Signed-off-by: Guo Ren (Alibaba DAMO Academy) <guoren@kernel.org>
>---
> arch/riscv/kvm/gstage.c | 27 ++++++++++++++++++++++++---
> arch/riscv/kvm/main.c   | 35 +++++++++++++++++------------------
> 2 files changed, 41 insertions(+), 21 deletions(-)
>
>diff --git a/arch/riscv/kvm/gstage.c b/arch/riscv/kvm/gstage.c
>index 24c270d6d0e2..b67d60d722c2 100644
>--- a/arch/riscv/kvm/gstage.c
>+++ b/arch/riscv/kvm/gstage.c
>@@ -321,7 +321,7 @@ void __init kvm_riscv_gstage_mode_detect(void)
> 	if ((csr_read(CSR_HGATP) >> HGATP_MODE_SHIFT) == HGATP_MODE_SV57X4) {
> 		kvm_riscv_gstage_mode = HGATP_MODE_SV57X4;
> 		kvm_riscv_gstage_pgd_levels = 5;
>-		goto skip_sv48x4_test;
>+		goto done;
> 	}
>
> 	/* Try Sv48x4 G-stage mode */
>@@ -329,10 +329,31 @@ void __init kvm_riscv_gstage_mode_detect(void)
> 	if ((csr_read(CSR_HGATP) >> HGATP_MODE_SHIFT) == HGATP_MODE_SV48X4) {
> 		kvm_riscv_gstage_mode = HGATP_MODE_SV48X4;
> 		kvm_riscv_gstage_pgd_levels = 4;
>+		goto done;
> 	}
>-skip_sv48x4_test:
>
>+	/* Try Sv39x4 G-stage mode */
>+	csr_write(CSR_HGATP, HGATP_MODE_SV39X4 << HGATP_MODE_SHIFT);
>+	if ((csr_read(CSR_HGATP) >> HGATP_MODE_SHIFT) == HGATP_MODE_SV39X4) {
>+		kvm_riscv_gstage_mode = HGATP_MODE_SV39X4;
>+		kvm_riscv_gstage_pgd_levels = 3;
>+		goto done;
>+	}
>+#else /* CONFIG_32BIT */
>+	/* Try Sv32x4 G-stage mode */
>+	csr_write(CSR_HGATP, HGATP_MODE_SV32X4 << HGATP_MODE_SHIFT);
>+	if ((csr_read(CSR_HGATP) >> HGATP_MODE_SHIFT) == HGATP_MODE_SV32X4) {
>+		kvm_riscv_gstage_mode = HGATP_MODE_SV32X4;
>+		kvm_riscv_gstage_pgd_levels = 2;
>+		goto done;
>+	}
>+#endif
>+
>+	/* KVM depends on !HGATP_MODE_OFF */
>+	kvm_riscv_gstage_mode = HGATP_MODE_OFF;
>+	kvm_riscv_gstage_pgd_levels = 0;
>+
>+done:
> 	csr_write(CSR_HGATP, 0);
> 	kvm_riscv_local_hfence_gvma_all();
>-#endif
> }
>diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
>index 67c876de74ef..8ee7aaa74ddc 100644
>--- a/arch/riscv/kvm/main.c
>+++ b/arch/riscv/kvm/main.c
>@@ -93,6 +93,23 @@ static int __init riscv_kvm_init(void)
> 		return rc;
>
> 	kvm_riscv_gstage_mode_detect();
>+	switch (kvm_riscv_gstage_mode) {
>+	case HGATP_MODE_SV32X4:
>+		str = "Sv32x4";
>+		break;
>+	case HGATP_MODE_SV39X4:
>+		str = "Sv39x4";
>+		break;
>+	case HGATP_MODE_SV48X4:
>+		str = "Sv48x4";
>+		break;
>+	case HGATP_MODE_SV57X4:
>+		str = "Sv57x4";
>+		break;
>+	default:
>+		return -ENODEV;
>+	}
>+	kvm_info("using %s G-stage page table format\n", str);
>
> 	kvm_riscv_gstage_vmid_detect();
>
>@@ -135,24 +152,6 @@ static int __init riscv_kvm_init(void)
> 			 (rc) ? slist : "no features");
> 	}
>
>-	switch (kvm_riscv_gstage_mode) {
>-	case HGATP_MODE_SV32X4:
>-		str = "Sv32x4";
>-		break;
>-	case HGATP_MODE_SV39X4:
>-		str = "Sv39x4";
>-		break;
>-	case HGATP_MODE_SV48X4:
>-		str = "Sv48x4";
>-		break;
>-	case HGATP_MODE_SV57X4:
>-		str = "Sv57x4";
>-		break;
>-	default:
>-		return -ENODEV;
>-	}
>-	kvm_info("using %s G-stage page table format\n", str);
>-
> 	kvm_info("VMID %ld bits available\n", kvm_riscv_gstage_vmid_bits());
>
> 	if (kvm_riscv_aia_available())
>--
>2.40.1

