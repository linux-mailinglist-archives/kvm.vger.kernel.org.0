Return-Path: <kvm+bounces-66440-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D8EE2CD339B
	for <lists+kvm@lfdr.de>; Sat, 20 Dec 2025 17:37:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BBFAB301618B
	for <lists+kvm@lfdr.de>; Sat, 20 Dec 2025 16:37:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4CEC30CDB0;
	Sat, 20 Dec 2025 16:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="YXV0C9Ft"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149ED267B92
	for <kvm@vger.kernel.org>; Sat, 20 Dec 2025 16:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766248646; cv=none; b=apabm5PSmLJQBV0Gx6wkoQe4G7vZ+S0YFMCIms1K09ShH6rYZUcVE5DqfhEQLlQC+Gy5Hb798H3RpH0VUJbdPnNGJecymEJjCyzkRXMce2HNmhoo4d1VD7bhZmWuQTfh73sZ7gCKbeVyB+l1OCs8W7sO9YlrAxrjPi6LUmsXcWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766248646; c=relaxed/simple;
	bh=5sxeVmM1HSneHjU/I1Fk7AXM2eqK42xU7iyfuc1gJG0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sFRKp/Cr512Jcp/X1+CLA+1r5FzUdFlJSLFTz/T02Ki96g89GxoNzJSxAfHotBBNWLIOrdAUGSaJTmhKxgTIldCbcOCgWqb/Bn2A5O0IdQTbn8C7aFn7IRNwjSkoMQVWuLRdv6HVoZDYmi8/LZIWe92Qeowkh108Q6NcTS5Ymc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=YXV0C9Ft; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-34c30f0f12eso2004753a91.1
        for <kvm@vger.kernel.org>; Sat, 20 Dec 2025 08:37:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1766248644; x=1766853444; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9FCav/YO9x/c2l0kK2rjBlOI4AUzqgUWfXFrOx8/XtI=;
        b=YXV0C9FtkWqPbfRYVgTfnBA84f3sDjLW57w2v9ix5Wn4P7I5XhDC0xSkTg3WFSj1yR
         Rq2tkGDO7KI45xo/HAOMPbtzZDWrrcGQ7zqZDzTxheumSCqzkG398cr50hmi9lBJZqiE
         ZiLSBPA7VjtXN7MBaGgmeApknzhyucywsN6AhgC4F5KWolhhfTkMGdEBiEYlaXW1fvQy
         jxbOwbQXf8Dj3gIMsUGRHkPQvDtEQBeTKPHE1O7IzQaztUZwHuX366mpW/q41kG1xAPA
         baQRDLt24Ztc89hzQ6CdQj9IfxEeZnAisAjlcOhbwJGEC40HqLljHfV8uNnxtP3HlqVr
         tPSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766248644; x=1766853444;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9FCav/YO9x/c2l0kK2rjBlOI4AUzqgUWfXFrOx8/XtI=;
        b=UFlq5SGrv1+K82njPN/6JoAoqc0JPpLW8V7ASxwTxjBr07BemnlwQPpJ6Ne/yJMT+a
         rcSqNeWhmk2PTrEO6WDGL+t/5OuhKJ4hBAF3g8SvIYC6u0/oJ3agKL3XF9Crv4CKznSZ
         TdTBFFSL+ou9BEF/s9gilVb03o9Gnd+SFU1Tbjx8uH6MLeCsdt3Egp5BPT3FRHT5SqXM
         oMI/c9F1ZmZ0jfz2oN/DYbV5UnIc1Y5ZOsOmUZhVGBy3m8EB72fV6QF1ob2Q1qi6hDNK
         IeZ85TD+AtiJLj3uAe1fLK2HayGfsd8td226DAzDiOpw2zMqRcStgVgHt+yufYAdamwp
         HOMg==
X-Gm-Message-State: AOJu0YwHMBc06cbVRqt/WVUtVpGy5NH/r8s29TPp+nBymeMwvTgeARhp
	CD5N5Jz/SZFFrUqceWCJ9eVa8jWhHVCOUiVoQ1H1hAUnw7jrt3O2mnYEDzW8JF53tSw=
X-Gm-Gg: AY/fxX5AfbDSAEy9gODSHQ/pehomtAGbwxhXkgoOvxhI9DC9W/p7himGRYLFQZ602r0
	DOa2MR/VB097FoT4Lx1igKmHgMMmTnOgHVoEKUHu2Ci5ZxB+1ovajxZwzxaBvqnzg/Q/e5FJWrg
	qoKeanQl0rR5S7sT234dWFB69/Ky+tck8W3ZY/rEuM35jjKDRd1NNC6nyLB05I6cGUhL6L/boAh
	edHQQDukWqrNzK6b1kun1BM1x1ruAUavs+lwibE+fhKr6BgN2fkomU3EgFC3yC7HsViWovAUKWf
	OwOTMT5R+zJP3bT6GGXXhpm5w81YIjYwUU/tL9Ok3whWvdIOZGUml8OLs00cC77YaA3Tq+pgJEv
	ksPqJDaNboffyboofHEd2loT2hbHdd18CrFuZ1F+GdSyZeNvx/6MGy6MNU4aGY1so1pdfRNmAl7
	zVHGPkHQh8k7getbquqO4u2vRXV2GpihEtERpKLZ7glyHJ/JusVxRG
X-Google-Smtp-Source: AGHT+IEJ3D8d9FhHHj3AGrLqpCRsqvYXaepmMKWkAaQAZJhz7+7JujmZvyMN56HD4piBnaPs2x/1og==
X-Received: by 2002:a17:90b:51c8:b0:340:bb64:c5e with SMTP id 98e67ed59e1d1-34e9212a206mr5848851a91.14.1766248644122;
        Sat, 20 Dec 2025 08:37:24 -0800 (PST)
Received: from J9GPGXL7NT.bytedance.net ([139.177.225.252])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34e70dbc9d6sm8368055a91.10.2025.12.20.08.37.19
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 20 Dec 2025 08:37:23 -0800 (PST)
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
Subject: [PATCH v3] irqchip/riscv-imsic: Adjust the number of available guest irq files
Date: Sun, 21 Dec 2025 00:37:13 +0800
Message-ID: <20251220163713.34040-1-luxu.kernel@bytedance.com>
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


