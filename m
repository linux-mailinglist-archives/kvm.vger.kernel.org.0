Return-Path: <kvm+bounces-66467-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F77ECD5595
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 10:38:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 33A913029D17
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 09:37:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECA27311C32;
	Mon, 22 Dec 2025 09:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="MwDvHCMj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A829F30F949
	for <kvm@vger.kernel.org>; Mon, 22 Dec 2025 09:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766396252; cv=none; b=QzkndO4Ir0KKmOYe77ktJ0OKpXQEP2Uj5BHqRG8qeuuOya5J6+/06I3sg23tveIX4QfOOxr0bfuIlCEsp6aSe2rdtpkRERCLW25/VqqBNzV29gK+1wPCdCYVWP7Ci4c8JCv85ah7TdztFGgWIlu3ROlZ/fKOYm/9hEIyYRs/0r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766396252; c=relaxed/simple;
	bh=c1+ZAMdzh02vWjeiTFaMbNLB9tl3xJthxXA9iBlQ6NI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=G/eE/QleNDipB3hXeX1UZPyzF7SkUTuF30+I85IFYLmXwNDey4Pqj68h55pQKCgtTmGiyENb7VeSqbb4J5Ny29eNp4IxtCwN/+CUsYwaP+4rO0yMFI/Cy4OkvPxa1Kyawgpm6EBygSlcKM7pjoWoYwKnQ6myECHzDFyGErGrtdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=MwDvHCMj; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2a09757004cso47599195ad.3
        for <kvm@vger.kernel.org>; Mon, 22 Dec 2025 01:37:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1766396249; x=1767001049; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=e+eYOQ9Z1GWGVQPVaVWjHQDJybI+c8ckkcfPVYmzYak=;
        b=MwDvHCMjChZkRJuerRcUwVfqsZsw3DJ14clm33uY7JcfrzvkuLCCaJDB6W3dZzwSbs
         kecr9jj4oMu+Su9La/wghpnWU3X0zmuA1i4stXG8iwFkBbLrSnUU5i6ITSOSg4vBGQth
         KkljutFBB/DYGTB7tMOHJ4SNfnJwpHkJ4NnipDlKrPCAMaZRqBipXsUwp1fq5Hd/t75T
         YiZDHEr4b4Unp0T38VtzJbftfi7XXZ+/HXAtSO6lvOskc7cDu1dBhdawS3X6hPp9IU4H
         sA9qAgtoN/T6mVRmXTnJ/QrLrO16bqWcHyuy5bH91KM6D9AdkmuHI8+rzJO+kvBCQrE3
         atSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766396249; x=1767001049;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e+eYOQ9Z1GWGVQPVaVWjHQDJybI+c8ckkcfPVYmzYak=;
        b=OGgi0dI8ojVsyBmFscMPxv/DYkBt1JiEij8lgaWKHw3EkU0KzTWFwFX9IrCQkVDDvx
         xuKQg6kmDZLdYIEBg2RdQb0qsw6eso5EMja0RrWvoEDq8iKTtnBeiMCyHM8OUHRFfCw6
         JFuvzT3ezdjKcWLkLp2709+Ktpj6Twh8pVBBIj9sWaOISQEj8J0Z2LVtTfQNUbjamgzs
         xuBQHea+v6AZcQ8VTtBYCP+o2sFOkp0FbSnnX3rglxuLNMYCpQAu02L1HbUGBQrU/dMI
         Inyj6TgoL7vY3gInBXNO1Zn1mmWLEU4XPt3Uk9zDPYhl6eY4wJMcySWscWlrcffzo/3b
         F5QQ==
X-Gm-Message-State: AOJu0Yx5/7FxPeNOnfynLyOmAdfb306EVdEtxVDO/I1plEJZfmpOIGQa
	fTVu1sBJ1iAZECVZo9q9NRDdCcIoZFrj0HHnkv1WX0VGg/8g8piYzPicE56zQq5V+tk=
X-Gm-Gg: AY/fxX4RNoRloUptdzO2k1CueAdXxVxYrzqjG9fwYaQwfRnrwWQxCQ/R7sbw+H/pRkM
	SR8zGB7N63ffWQqvoDtiJWCH5x6mV+o1eRqd8zhRCvD4OCUETKuaPvmaRxogmzTXUvhOjM+pw95
	nOBkTZO4Aj7uNCLu+2QLeWAxwVUwEV1q3h2fj+ghPmDym1bYPaUUXtJjo+ysHOnum1U/zhcaHsB
	xjzRY3cPCrcfEIJNrSXSGB/EI74cND1Uh7SZxZhDeTpRuRhY5kHVqCAT4L+LjytCwsn6y0TM/Uj
	Kdq/zHEGFMs9klfJLujzrURA6EIWbOtFxWZ3oKkveYJ7Nyt5EOwiDfXO+8S9Q6GJLpXm2B9w86m
	jGge3ayPBu/XGggXbtFMcJQVyuRe6QMNBp2ulGed82XYB7M4mauAG8jirhltP0sCRnrYzJYgk71
	gTGkIjU/USd7W6BTOn/DYJrj4A6bCRboiCgIcPwcvm6/R+ufsG5lFi
X-Google-Smtp-Source: AGHT+IHbAevZrh677mrcs/s1RBp0r3uPnm7MKiIYh2aKgk+Y2T5BWPJU1+fmAHdSaxWnaMOTu2Gp8g==
X-Received: by 2002:a17:902:f607:b0:2a1:4c31:335 with SMTP id d9443c01a7336-2a2f2717b88mr102674405ad.26.1766396248789;
        Mon, 22 Dec 2025 01:37:28 -0800 (PST)
Received: from J9GPGXL7NT.bytedance.net ([139.177.225.255])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3d5d20dsm92611765ad.67.2025.12.22.01.37.23
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 22 Dec 2025 01:37:28 -0800 (PST)
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
Subject: [PATCH v4] irqchip/riscv-imsic: Adjust the number of available guest irq files
Date: Mon, 22 Dec 2025 17:37:18 +0800
Message-ID: <20251222093718.26223-1-luxu.kernel@bytedance.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, KVM assumes the minimum of implemented HGEIE bits and
"BIT(gc->guest_index_bits) - 1" as the number of guest files available
across all CPUs. This will not work when CPUs have different number
of guest files because KVM may incorrectly allocate a guest file on a CPU
with fewer guest files.

To address above, during initialization, we calculate the number of
available guest interrupt files according to MMIO resources and constrain
the number of guest interrupt files that can be allocated by KVM.

Signed-off-by: Xu Lu <luxu.kernel@bytedance.com>
---
 arch/riscv/kvm/aia.c                    |  2 +-
 drivers/irqchip/irq-riscv-imsic-state.c | 12 +++++++++++-
 include/linux/irqchip/riscv-imsic.h     |  3 +++
 3 files changed, 15 insertions(+), 2 deletions(-)

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
index dc95ad856d80a..cccca38983577 100644
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
@@ -928,6 +929,15 @@ int __init imsic_setup_state(struct fwnode_handle *fwnode, void *opaque)
 		local->msi_pa = mmios[index].start + reloff;
 		local->msi_va = mmios_va[index] + reloff;
 
+		/*
+		 * KVM uses global->nr_guest_files to determine the available guest
+		 * interrupt files on each CPU. Take the minimum number of guest
+		 * interrupt files across all CPUs to avoid KVM incorrectly allocatling
+		 * an unexisted or unmapped guest interrupt file on some CPUs.
+		 */
+		nr_guest_files = (resource_size(&mmios[index]) - reloff) / IMSIC_MMIO_PAGE_SZ - 1;
+		global->nr_guest_files = min(global->nr_guest_files, nr_guest_files);
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


