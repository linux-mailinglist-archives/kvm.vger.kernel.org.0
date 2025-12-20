Return-Path: <kvm+bounces-66434-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F010ACD2BC0
	for <lists+kvm@lfdr.de>; Sat, 20 Dec 2025 10:09:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B93723013556
	for <lists+kvm@lfdr.de>; Sat, 20 Dec 2025 09:08:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6945F2FB630;
	Sat, 20 Dec 2025 09:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="eC9KWOhd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69A12FBE00
	for <kvm@vger.kernel.org>; Sat, 20 Dec 2025 09:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766221736; cv=none; b=E5UU4edko68JbKXfbgAHGURSWiHnAurvq0KxCt2FYCjz37X7gW1aEh5uKQq7eQzlpwVlti+p+kmOsvKezO4rxOO+qsRQHtme+Tz/1YwaCskBLoFDB96NlTrizFStZwCsEnZWCr84NopwojO8eswdQVdF0c4tneU33/T0PzgsJEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766221736; c=relaxed/simple;
	bh=5sxeVmM1HSneHjU/I1Fk7AXM2eqK42xU7iyfuc1gJG0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SjseHvgMaXIhfDm+kzKH0AynvJQi8FCh4YYuA8DiNyxZwhojSW317i6aTcl6K+IOU1Xdx3MrwjSy3i523onBzu92NFnwNyJxMwyRWbabT4GO+7dP8RT0oDpGp2U5pqJ9EJdySW1pSUjb0+MRmN6hwUirxkAuMIKgSwqZRrVyxfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=eC9KWOhd; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7f1243792f2so1776497b3a.1
        for <kvm@vger.kernel.org>; Sat, 20 Dec 2025 01:08:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1766221734; x=1766826534; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9FCav/YO9x/c2l0kK2rjBlOI4AUzqgUWfXFrOx8/XtI=;
        b=eC9KWOhdLyWOS0Ys1nNa9Kyp8TyTk0kyFyVBqUCoWPIvm0FfTziECYZRwl/HHGNGjV
         0KjGUfAnD5kTrO9nitcpOsKXfcvW0qY+v0yKjofwCsYcBsH+omBhcseX3rds4QSHLoo1
         pjEmelA/ZPX2gwS2J6mR8Xn2RnaWgebwigAXanAcJDSTwm47Shqp8CroGmdGXXAYHdoC
         mSPbuR+KJYggmuenmX7BNGfdn4bXAaz/hyJD0HaiXwSgoM7cIGVfsfozZR0XfVIyHsyw
         MmkWKfGZ4OFjYAzGslo9zgb8Jc2SIKixiXZX/44hghYzSqgbr9+v176q3rfNsdSRfkmF
         7DpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766221734; x=1766826534;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9FCav/YO9x/c2l0kK2rjBlOI4AUzqgUWfXFrOx8/XtI=;
        b=GGcmzOi5UhGuwQK329ttNR3OwrPnUbnnZFWwvmZzaFcHhl6Vzx0f6bmO7p7qH4OTW6
         YxTTH2O4htLv6cm3qwF8VUqb+pHMy8zkvFLfuXHzpt+qdwxST/Tf982mtB0UQWdBnKua
         JrdhNt5UR8Gezrij6x9DeK/Go+uiZKHnLfrw3aFxtohmOdJLz/aQK3qsvHt72HnaUGUf
         WTovEk8zk98ORIVgav38nsrFDQV8X1Pzt2X9rd+dl2821WXtaNY+vn/ifoaZRLiey7ST
         yk+fMbdpRPTaOj8RNvnawiBc7F3CnHIPoKRELVU2D8dldnRDDFuwoP4hQZsqF9J1wJzo
         gs1w==
X-Gm-Message-State: AOJu0YwOr3pukl1RPJWU0qPqU7sUpobfJvDLah33azp0LBJrfa3OyoUr
	/FttLb4/Czw3MQFPUFn+XhMixkffBjdvzBVe5ylEGNYe8cHTPMDRrlT+jd1p2zz46Ng=
X-Gm-Gg: AY/fxX4CUS+z3ZuUQLJvMG36yzJJSXxY9pk4bRgHGfdY/ocIidT9AzplpIWDrWyDrpG
	m6Qm0EV3IIuGK9sPTe+TrydkYC1RcbseOFEuCG5E462kWFp9eWwb2l3tkEkPTtWH7hbu8WT90q6
	GzUtv8PL1Lb/XIpuOTB+jjYzB15DaMshKik4HDAgtYWda7hCJ+fwMDZQnLsOt3YBE+3B6XJwg3J
	PFFkTMevEpmw8sbj2eP/DCde8OZ26t+IV0PWBddY0cV4Sr9wMxxhxS2TAQOzfp83jvtsZY/dhm2
	rfXxixEqG0FX+bh5MvoxpJnCkB3t0juttd/dmDhBNuQqgmGaMZiZhoSBC0HSNlie2fbjwv2hNIX
	SRdVG7OjrOfpah8HpKfptjlLAOqc9idV6fVlZIbSOfGW1sc1oX9FH/eYQbE1HQ+6aSkYu2n3qHl
	1mhbyvMmEsLao5YdhYNt8uaUg/lWqCbOF4tb/7uqp2KXQl83yrHaP+
X-Google-Smtp-Source: AGHT+IF2jkxbF7mAn+s4RGO9FXrxMFZTWrnAnqrw89U2+BW6yKGvETNKZF8EMf2cRZHfSphIJaGSBg==
X-Received: by 2002:a05:6a00:330a:b0:7e8:43f5:bd46 with SMTP id d2e1a72fcca58-7ff67257bb3mr4181960b3a.50.1766221733916;
        Sat, 20 Dec 2025 01:08:53 -0800 (PST)
Received: from J9GPGXL7NT.bytedance.net ([139.177.225.247])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7e48cd07sm4623647b3a.46.2025.12.20.01.08.49
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 20 Dec 2025 01:08:53 -0800 (PST)
From: Xu Lu <luxu.kernel@bytedance.com>
To: anup@brainfault.org,
	atish.patra@linux.dev,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	tglx@linutronix.de
Cc: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Xu Lu <luxu.kernel@bytedance.com>
Subject: [PATCH v2] irqchip/riscv-imsic: Adjust vs irq files num according to MMIO resources
Date: Sat, 20 Dec 2025 17:08:44 +0800
Message-ID: <20251220090844.46441-1-luxu.kernel@bytedance.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

During initialization, kernel maps the MMIO resources of IMSIC, which is
parsed from ACPI or DTS and may not strictly contains all guest
interrupt files. Page fault happens when KVM wrongly allocates an
unmapped guest interrupt file and writes it.

Thus, during initialization, we calculate the number of available guest
interrupt files according to MMIO resources and constrain the number of
guest interrupt files that can be allocated by KVM.

Signed-off-by: Xu Lu <luxu.kernel@bytedance.com>
---
 arch/riscv/kvm/aia.c                    | 2 +-
 drivers/irqchip/irq-riscv-imsic-state.c | 7 ++++++-
 include/linux/irqchip/riscv-imsic.h     | 3 +++
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kvm/aia.c b/arch/riscv/kvm/aia.c
index dad3181856600..cac3c2b51d724 100644
--- a/arch/riscv/kvm/aia.c
+++ b/arch/riscv/kvm/aia.c
@@ -630,7 +630,7 @@ int kvm_riscv_aia_init(void)
 	 */
 	if (gc)
 		kvm_riscv_aia_nr_hgei = min((ulong)kvm_riscv_aia_nr_hgei,
-					    BIT(gc->guest_index_bits) - 1);
+					    gc->nr_guest_files);
 	else
 		kvm_riscv_aia_nr_hgei = 0;
 
diff --git a/drivers/irqchip/irq-riscv-imsic-state.c b/drivers/irqchip/irq-riscv-imsic-state.c
index dc95ad856d80a..1e982ce024a47 100644
--- a/drivers/irqchip/irq-riscv-imsic-state.c
+++ b/drivers/irqchip/irq-riscv-imsic-state.c
@@ -794,7 +794,7 @@ static int __init imsic_parse_fwnode(struct fwnode_handle *fwnode,
 
 int __init imsic_setup_state(struct fwnode_handle *fwnode, void *opaque)
 {
-	u32 i, j, index, nr_parent_irqs, nr_mmios, nr_handlers = 0;
+	u32 i, j, index, nr_parent_irqs, nr_mmios, nr_guest_files, nr_handlers = 0;
 	struct imsic_global_config *global;
 	struct imsic_local_config *local;
 	void __iomem **mmios_va = NULL;
@@ -888,6 +888,7 @@ int __init imsic_setup_state(struct fwnode_handle *fwnode, void *opaque)
 	}
 
 	/* Configure handlers for target CPUs */
+	global->nr_guest_files = BIT(global->guest_index_bits) - 1;
 	for (i = 0; i < nr_parent_irqs; i++) {
 		rc = imsic_get_parent_hartid(fwnode, i, &hartid);
 		if (rc) {
@@ -928,6 +929,10 @@ int __init imsic_setup_state(struct fwnode_handle *fwnode, void *opaque)
 		local->msi_pa = mmios[index].start + reloff;
 		local->msi_va = mmios_va[index] + reloff;
 
+		nr_guest_files = (resource_size(&mmios[index]) - reloff) / IMSIC_MMIO_PAGE_SZ - 1;
+		global->nr_guest_files = global->nr_guest_files > nr_guest_files ? nr_guest_files :
+					 global->nr_guest_files;
+
 		nr_handlers++;
 	}
 
diff --git a/include/linux/irqchip/riscv-imsic.h b/include/linux/irqchip/riscv-imsic.h
index 7494952c55187..43aed52385008 100644
--- a/include/linux/irqchip/riscv-imsic.h
+++ b/include/linux/irqchip/riscv-imsic.h
@@ -69,6 +69,9 @@ struct imsic_global_config {
 	/* Number of guest interrupt identities */
 	u32					nr_guest_ids;
 
+	/* Number of guest interrupt files per core */
+	u32					nr_guest_files;
+
 	/* Per-CPU IMSIC addresses */
 	struct imsic_local_config __percpu	*local;
 };
-- 
2.20.1


