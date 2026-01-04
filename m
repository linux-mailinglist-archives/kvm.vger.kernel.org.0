Return-Path: <kvm+bounces-66987-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 12A26CF1006
	for <lists+kvm@lfdr.de>; Sun, 04 Jan 2026 14:36:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9379C3012BF8
	for <lists+kvm@lfdr.de>; Sun,  4 Jan 2026 13:35:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E17D330E0D1;
	Sun,  4 Jan 2026 13:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="E5QNcAf3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C85A30DEBB
	for <kvm@vger.kernel.org>; Sun,  4 Jan 2026 13:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767533719; cv=none; b=iMz2GwqGfe9tJNZ3fCwzzuhbJmOsnjBGfugFhNBTnNf/+RUSmCbMW5CoG1v+gQP8c0Y3tIQMfm4TbNFOsOoxvoZ6Hw1O/9qnxhIzh/C60IF0NrldyfWDphtTfzhqnAxQVNCiyKlGWa7KQMbTsfzB2Tp5odOByzs3gGos9//gHyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767533719; c=relaxed/simple;
	bh=ZH2BECDUVrP3GcnZNu73snHbaTQWeCapzle897uviO0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ukUqhlIxX/g7FzpkGEb8ZgzzdeG9xI1FEtzv8p/g5w3MtZMN00zB/b6S4ZiEo5YUjP8oema0XVvPWStxQ48FIWAWzM33QZZQi17IRmVVN23es77kFA39iFW6TmiSyjNaZqZQDbwxSgeMlODVrW/rRgv+s/zgzPLtpvA8o9978fU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=E5QNcAf3; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2a0fe77d141so151756265ad.1
        for <kvm@vger.kernel.org>; Sun, 04 Jan 2026 05:35:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1767533716; x=1768138516; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JvZUDpxx2/TZemLMHA7g/NjnGnb9ciURwwd/us/xC4Y=;
        b=E5QNcAf3SV7Czm01HeosnrdAvYcXIrkcEYSotBBNQXpy0m5MEMZRBfu9MNoig3864H
         HbmL5vZ/F4xhvkCV3rPntaBP7tyWAhfujqxkUrRHO/nynqKElU1UlvrkTQKhWRsdbywv
         IO9iGvxuxSweteOrORku4U6zRcBl+u3Ff3k+2GGLzZE7OdmI4TUKw8XmyY2vAc3ToLyY
         clLK85exPE2f/OSNNX1R88CVxlwUX5A0oIj9bQsXx3SJK3J20xeTmiej4ObikobQr/M+
         lOKB+ez2M5C35AbPhfeLTziWmso/thZq6oO65HenkR3ZKipgrTN9M3vruH6eVCNYRcqm
         0RMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767533716; x=1768138516;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JvZUDpxx2/TZemLMHA7g/NjnGnb9ciURwwd/us/xC4Y=;
        b=JMqkCxgLxRB6ChuhXA+LK6OJKkcagTDQrQN6O66HZJbQ5AViqaZyFrrlvWju/LSX+e
         aMtG9iucthOfcWcoKFZyswiVOSNuAK81nK5IqTFC8U0zoOcQk/y1iRHNUoeoYhnTYiXZ
         8AJH33q6xrwY9AgRk7u2pnXsxHsv+wmc8xuZUsX6m5ROVCZgLFbVkC3sAshoTguBA/So
         t6IGlok9vWPDiycd1CZQsvAm13VDJPGEYali4wK66WfDeaLwTOjQEwoxlsFmgzkYU8Bt
         hIHtbbugtwl4U+ZBGzp5F4byUJ+wBdnz9IRCIdhfdtuxJJYBpXJvhIkotbdAZYo8Aw4I
         0vKQ==
X-Gm-Message-State: AOJu0Yw5NyWROiQYrasxyt79LP12VwWJ+KKXZMOxLIqU/H/REDWba1P1
	0AlR5InGfbtPhLDZbf12pjbXlpQKocA5G94P4LE34NgEdXWFyjMSaUhxIzr5eP4I1VE=
X-Gm-Gg: AY/fxX6HrXbrtWNUwETzGhNZLqn5NH9SpPPeWt4vDKy+/sg1qYErvb3XlcdSwmxryMd
	FveQKD0galf9yWIVwWbsCPm2r/sML0Q5lSUXIYp+A0InKIgZXtSJylwC/uU/yoNpBUm/y3y1BgR
	gl3ExZMTqjXiHAxlYJwdYI+DhNed2pUrbo+8xsHhi1GTOP6986DFOOG850ipXVku4ZjuiWxy3nd
	c8lVYwkjxZifAPrMEJkujMEkQ1PVD8kJZDf6ANnZzsOP94Dau8lGvmNrjx1sFxIOKlm+b/pubBR
	WC8GIZDoEQiRRQ0HWeyASk7r5PHHIStBg9eALRjHeyWlgTPu0W9moqLQBdbvopyysl/ZT47V88v
	wMXJFgOo9pTe7jJdkfmGD1PJaPQwjt1l9Vn2c07t+O0DS1DUshXKmBdfQZiQEGz1iN/d+sMGklo
	3MF7sxMlLo+KmFbCjkJrWLjHd7VynWki0PRNqseW1IaizfLbhWqNpSoUvXy5OB+07OJf+PEyWSh
	g==
X-Google-Smtp-Source: AGHT+IF6pqf+xAoe4xEDhrknYrrwm/vNFvihqgaZg1GfeAvx7Byc3K7yYVMaT/2jX/ci+jocfmEzpg==
X-Received: by 2002:a17:903:b8b:b0:2a1:1074:4199 with SMTP id d9443c01a7336-2a2f2830f89mr406839395ad.32.1767533707326;
        Sun, 04 Jan 2026 05:35:07 -0800 (PST)
Received: from J9GPGXL7NT.bytedance.net ([61.213.176.57])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3c949fb63sm30428785ad.53.2026.01.04.05.35.03
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 04 Jan 2026 05:35:06 -0800 (PST)
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
Subject: [PATCH v5] irqchip/riscv-imsic: Adjust the number of available guest irq files
Date: Sun,  4 Jan 2026 21:34:57 +0800
Message-ID: <20260104133457.57742-1-luxu.kernel@bytedance.com>
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
of guest files because KVM may incorrectly allocate a guest file on a
CPU with fewer guest files.

To address above, during initialization, calculate the number of
available guest interrupt files according to MMIO resources and
constrain the number of guest interrupt files that can be allocated
by KVM.

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
index dc95ad856d80a..e8f20efb028be 100644
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
+		 * interrupt files across all CPUs to avoid KVM incorrectly allocating
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


