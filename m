Return-Path: <kvm+bounces-66432-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A802CD2B2C
	for <lists+kvm@lfdr.de>; Sat, 20 Dec 2025 09:56:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id C7EDF300217D
	for <lists+kvm@lfdr.de>; Sat, 20 Dec 2025 08:56:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 605C92F9C39;
	Sat, 20 Dec 2025 08:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="el/c8c7i"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 635534A35
	for <kvm@vger.kernel.org>; Sat, 20 Dec 2025 08:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766220967; cv=none; b=pqneF4NNt4gaOzoh1bYf6n3C2geYUg2Hvwz6gOt+yHhPTllpd43RN7vOWOCinA33b7Jozee3rzWw4oVuRXiiyNUHtL4IoaUnP4ED7fOQY5+y2Cbvckk4r07uBZHWbEhl7sT6r4cHEhwqut0ckJEUP6L0vhuZZtFJ3HbllxgDMVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766220967; c=relaxed/simple;
	bh=i2h9SH23wmQJ3NJ51Aqm8ccq2WKMVX1YE4DufG4Ua5M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Pkr3LwWOm7xN+F6RqFNpgpeHEk8qIVqzDfxBt3sLP8bj1A44aooIn163wAoNAy69uwSigmDdpohM58pjRkEtMZQRmBsl+d723gFqUOTveZ0pdrk918dmBSqR+GslQqLMJ8mBjKa2HfR9CZFzoGCDnVMS6buS0FMJJ50qMCkxvlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=el/c8c7i; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-34c7d0c5ddaso1425867a91.0
        for <kvm@vger.kernel.org>; Sat, 20 Dec 2025 00:56:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1766220964; x=1766825764; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HXENzr5z2plkFWLtxmfbha96E8Xbo/nXRtWKuaAr4kw=;
        b=el/c8c7i6UykLHTAj5GmqBIv2CPDgpwHuMs/mbtJ8bfs4Ys5rjxQTXo/JpZ+5pDf7l
         D7GLO42XxBp6FfFwo/QqxovstaQld4mRLBjRhzTjbmYVvLi0p9tvLBZLIyNdPRVU8ygV
         Rmqf+lKqXjNvC68kdEVJFC1meQgrXjnFiBeL7qIj2OjN8zYbVGBDv2QRIYLmhww35RJi
         77FdE0UPK34hEG8yvmBD8NRsmwfmE9mE1q0Slfq7Pi4XV4TEWRoz/0mH1QUwROPyWNe1
         0+SGIjfLmSTisvHjautBLaYYdvE8CDMjUuRKC0G+z7QA0HY5fpOsFJ0/bhdJ8HYAPjrB
         ttdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766220964; x=1766825764;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HXENzr5z2plkFWLtxmfbha96E8Xbo/nXRtWKuaAr4kw=;
        b=mbSBeeDWiGhYYGzVxEIXTt7Y5G1mGc9nGilxNuonSlIm2DMcGKnZR2FExynmCI+Q7a
         kZqkQoSIj8WL4JNgFdQfUz23GywgNAEYBHxyDL4nfIB/VD95C14hJMnevYRXQQv56ji2
         DslU4CftVhcxT9srHQq0WD40wnQ9NSEPREJl7i0d8PLes+bPwOhfch/cNcwn4zLNup+0
         u1gDrIYSKyKERJLQig644+PurlXmRZedxX06++aQDD+F7fudEm5I0C0hdtPOU05EGzcD
         zqzNYjnOaxeNYbke2yn4np/QW5DLERpPyjcPFn8Qf83HXvM3ajbf9kOd5LQBb8Lv/7YL
         Vkxg==
X-Gm-Message-State: AOJu0YxNRcy5J5HZzbCMqzL88gldvf7//n1edotuXgEchd3QENrltQLB
	q2y1jH+YixB7abItmFeYOhThLgbYqLFAH2oCwRby8ZBKCijQjRFX0KpX6DKsf6EobJ4=
X-Gm-Gg: AY/fxX6WDI5tv7fDSu2E1QEzOwQgTtIqALjLgN60V/VP6oMjxXZugOzkm5KcRT2ZJL8
	Zzt4eLNXVL/Rg9SPFCJ2l1pD019zl8MdBQhn1ND8Fw8sXDm5YdZl3KMLcy/Sd+4LwB3y/UOjNK5
	ntqY219HZQoTfO227nHExji2VhkXcUpt1L2uzR1XNSyFjIOCosGWB9MIEHphvg9g+MF/iT9MrFB
	KbTKBI2SCMu7a/+MyCF6uhYMHp7T1N5rTa5XMZjOQHjtPVFB0zL1c1RHEYys2DcbUClXrNj5rxS
	Z4Uo3Ag7S3ni7jVt238L9icmfyLELLHPHX/A8G3qfe64bL/KbJ16j+cwksOJJkFlUI3OpjX2slI
	I/3i1rZHk6OWfhKBTTdiABQ7Ry4QoTiEbtP++ljI9PfPSZMU1lDLvti2TQ6Az5VIoLzGM6yGWGl
	Dfl+uYwys342E3QOJQio15ssG6+dlsLKGBNI3nXYfHReLxgzV5hQG+
X-Google-Smtp-Source: AGHT+IF05noiQi3hAuPe2AeRVjxn4xsojmQL6ESiyGT6IBKYv3sJCcgsagLTeD2lo/eEy1e2Bo8hYA==
X-Received: by 2002:a17:90a:fc4c:b0:343:e692:f8d7 with SMTP id 98e67ed59e1d1-34e90dcfcb4mr4666180a91.11.1766220963620;
        Sat, 20 Dec 2025 00:56:03 -0800 (PST)
Received: from J9GPGXL7NT.bytedance.net ([139.177.225.247])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34e70dbcb6esm7506626a91.9.2025.12.20.00.55.58
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 20 Dec 2025 00:56:03 -0800 (PST)
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
Subject: [PATCH] irqchip/riscv-imsic: Adjust vs irq files num according to MMIO resources
Date: Sat, 20 Dec 2025 16:55:50 +0800
Message-ID: <20251220085550.42647-1-luxu.kernel@bytedance.com>
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
index dad3181856600..7b1f6adcf22d6 100644
--- a/arch/riscv/kvm/aia.c
+++ b/arch/riscv/kvm/aia.c
@@ -630,7 +630,7 @@ int kvm_riscv_aia_init(void)
 	 */
 	if (gc)
 		kvm_riscv_aia_nr_hgei = min((ulong)kvm_riscv_aia_nr_hgei,
-					    BIT(gc->guest_index_bits) - 1);
+					    BIT(gc->nr_guest_files) - 1);
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


