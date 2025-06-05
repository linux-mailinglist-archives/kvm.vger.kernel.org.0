Return-Path: <kvm+bounces-48484-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C4D27ACE9FD
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 08:18:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 69D3116562B
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 06:18:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B52C21930A;
	Thu,  5 Jun 2025 06:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="Enkcg+PG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EE02218AC1
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 06:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749104155; cv=none; b=bjQI9T/vJU7eCf0yUZk45PiRNg4PbdnbCWfGJq0jYYc0DquVk6QaImE/f8Xs1L9okPjljabPEgE9RE8RJV7bXUFCvEXD9PFfysmhvlNjApaTvOvguS/gX1H1WMaDRAkrV+fZ5Iew3GFeoMYK5X27rwYCK3TNc7IYyHpCeMdGB1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749104155; c=relaxed/simple;
	bh=1T+5U596f3dA/YPSNAOltWgISKWaPc9hTEJTVhp8Dw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MFtUgRzvhdeAEIZxBs/pRiWK9YzfbiLKAaiMbwSlpruvhiLT7ohK6C2mo6niM+ofNOLi+8m/KonFFUEo/f0sTl6c9en2cjUiZVoNcqHgHuVQhWs7cF8mTmFxqyzQ5LvhVl3aWDD95Ko4KvjHBh3wIEgF8uZi+klarUVMlSU97ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=Enkcg+PG; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-22c33677183so5407455ad.2
        for <kvm@vger.kernel.org>; Wed, 04 Jun 2025 23:15:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1749104152; x=1749708952; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BRraX5zqPEIu27knbCgVox/vzZ57ews0d3/eBDkqJxA=;
        b=Enkcg+PGk28/nUukkXHw3lllW+NDJQk8L+IjvYef937fBPKYSDAFONSvktnoAXAc74
         fu+QQ1evuaD/Oh3ham6pOdL5BFkP3oKwNfpX8nzkdwXvqCZlrONcvnoaGvfoZ1fDj+4P
         ub7YR2sVbMmVgRA3rB++Law7o0FB1VXjs8RB70IzMopRSkprrMhd/2M/6UVDSJS4+Dm/
         cDnEeF8J7o4XIh40Qp/sb/ruUsueApe1VlJZEmCtyJe2C3mqR3T9waBepx4ZEgKCMUmQ
         E9lgkjT28LWAaAD72lM7YCZ2Tg3FfcG+VdLgR1XmZmePvC9cHAaHiYbOtVuuSmSCC/6Q
         eLtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749104152; x=1749708952;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BRraX5zqPEIu27knbCgVox/vzZ57ews0d3/eBDkqJxA=;
        b=Xi991wNnbJOC6EZIf/rHMiWuL1JyldavJLyfoQLJnWVeWyB5BpIwkR2TGyLNO8bPsg
         NOD10caDQ44JalAo2MUMSaguCczVHD3AZ48mQFnDykuJaAbQ1hi5VhXkX4j+FKCJ6Fe4
         xQE7LgiN33sfl5Sx1xpT+glJb3z7PKyzol1Bp3Vg4YCJN8IORMz7gSnLD00z2bSzZ5YZ
         jqFdS7GtAMSQbir3BY5ObzXfYBRMQbBJ8XPR/if4cMsW/RCfhnwVNu4Tbfb5z6sFClQ3
         8oFZYrkJ8FQtqye1nweSKIU9wyETqESSceQ56AoAjK4FfDosCb0gi20r3DGb31ioG5mF
         mXXw==
X-Forwarded-Encrypted: i=1; AJvYcCVIYq/XaQmuyUIghVsDKpR4ratpB8Xo4u6T+qN/aia517WwsvbLBmj7kFO3s2QBBzGUbA0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwljIBC4FvDK/i/ninXXDHVJxZo7L0yPtPz2EIWsuNkjRbWUbqM
	4381l3A3n53quHZWpJ+4LRpRchPY4OC2NFKymns90+oadHESaGcUH1t4b3Vi9aYQ3BQ=
X-Gm-Gg: ASbGncuYe8cTHV85/ihCsXWWYDDCbvxr9nN3HQhR71QZN/Dr8WPb3nMze1S+QzKUKvj
	LqeH+dDdPu8hEUDdRAhja/N0m3qYR37OUIXzwZ9eBZGP05B3GrUbBnXtD6s7NeDj2ubxyNesdFV
	zL77d2plP8cGfaE1vq/z5GfmuYExxgjuWFc5FH0Xt0HsF0KmEXA4aZW0VmilKzDJcF6MQi77e16
	VkxjkA8pTnof6GhT4i/axom0g9OSWRkrsYJNW4k323Z5utt1McKMxvVQyjhQqW4NTLttx3sMuak
	vIwFgl80bXPYLFeotU6vbdKo63j3QV28X1DWKp7iGvF5unpHHkIE3PC4oCSmc/PsmE+HKd7QfGv
	jv8m2nUAJTH/x91gi
X-Google-Smtp-Source: AGHT+IGYGTyTa8SFhLhi99Le1sXP7Ki5TCTst4Mq5ezq+Odq6ROVX+MSCkircODyWSq338B3BPTPkw==
X-Received: by 2002:a17:90b:1ccb:b0:311:df4b:4b93 with SMTP id 98e67ed59e1d1-3130cca7a23mr8376360a91.7.1749104151877;
        Wed, 04 Jun 2025 23:15:51 -0700 (PDT)
Received: from localhost.localdomain ([14.141.91.70])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3132c0bedc7sm716026a91.49.2025.06.04.23.15.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jun 2025 23:15:51 -0700 (PDT)
From: Anup Patel <apatel@ventanamicro.com>
To: Atish Patra <atish.patra@linux.dev>
Cc: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 12/13] RISC-V: KVM: Factor-out g-stage page table management
Date: Thu,  5 Jun 2025 11:44:57 +0530
Message-ID: <20250605061458.196003-13-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250605061458.196003-1-apatel@ventanamicro.com>
References: <20250605061458.196003-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The upcoming nested virtualization can share g-stage page table
management with the current host g-stage implementation hence
factor-out g-stage page table management into separate sources
and also use "kvm_riscv_mmu_" prefix for host g-stage functions.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/include/asm/kvm_gstage.h |  72 ++++
 arch/riscv/include/asm/kvm_mmu.h    |  32 +-
 arch/riscv/kvm/Makefile             |   1 +
 arch/riscv/kvm/aia_imsic.c          |  11 +-
 arch/riscv/kvm/gstage.c             | 335 +++++++++++++++++++
 arch/riscv/kvm/main.c               |   2 +-
 arch/riscv/kvm/mmu.c                | 490 ++++++----------------------
 arch/riscv/kvm/vcpu.c               |   4 +-
 arch/riscv/kvm/vcpu_exit.c          |   5 +-
 arch/riscv/kvm/vm.c                 |   6 +-
 10 files changed, 528 insertions(+), 430 deletions(-)
 create mode 100644 arch/riscv/include/asm/kvm_gstage.h
 create mode 100644 arch/riscv/kvm/gstage.c

diff --git a/arch/riscv/include/asm/kvm_gstage.h b/arch/riscv/include/asm/kvm_gstage.h
new file mode 100644
index 000000000000..595e2183173e
--- /dev/null
+++ b/arch/riscv/include/asm/kvm_gstage.h
@@ -0,0 +1,72 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2019 Western Digital Corporation or its affiliates.
+ * Copyright (c) 2025 Ventana Micro Systems Inc.
+ */
+
+#ifndef __RISCV_KVM_GSTAGE_H_
+#define __RISCV_KVM_GSTAGE_H_
+
+#include <linux/kvm_types.h>
+
+struct kvm_gstage {
+	struct kvm *kvm;
+	unsigned long flags;
+#define KVM_GSTAGE_FLAGS_LOCAL		BIT(0)
+	unsigned long vmid;
+	pgd_t *pgd;
+};
+
+struct kvm_gstage_mapping {
+	gpa_t addr;
+	pte_t pte;
+	u32 level;
+};
+
+#ifdef CONFIG_64BIT
+#define kvm_riscv_gstage_index_bits	9
+#else
+#define kvm_riscv_gstage_index_bits	10
+#endif
+
+extern unsigned long kvm_riscv_gstage_mode;
+extern unsigned long kvm_riscv_gstage_pgd_levels;
+
+#define kvm_riscv_gstage_pgd_xbits	2
+#define kvm_riscv_gstage_pgd_size	(1UL << (HGATP_PAGE_SHIFT + kvm_riscv_gstage_pgd_xbits))
+#define kvm_riscv_gstage_gpa_bits	(HGATP_PAGE_SHIFT + \
+					 (kvm_riscv_gstage_pgd_levels * \
+					  kvm_riscv_gstage_index_bits) + \
+					 kvm_riscv_gstage_pgd_xbits)
+#define kvm_riscv_gstage_gpa_size	((gpa_t)(1ULL << kvm_riscv_gstage_gpa_bits))
+
+bool kvm_riscv_gstage_get_leaf(struct kvm_gstage *gstage, gpa_t addr,
+			       pte_t **ptepp, u32 *ptep_level);
+
+int kvm_riscv_gstage_set_pte(struct kvm_gstage *gstage,
+			     struct kvm_mmu_memory_cache *pcache,
+			     const struct kvm_gstage_mapping *map);
+
+int kvm_riscv_gstage_map_page(struct kvm_gstage *gstage,
+			      struct kvm_mmu_memory_cache *pcache,
+			      gpa_t gpa, phys_addr_t hpa, unsigned long page_size,
+			      bool page_rdonly, bool page_exec,
+			      struct kvm_gstage_mapping *out_map);
+
+enum kvm_riscv_gstage_op {
+	GSTAGE_OP_NOP = 0,	/* Nothing */
+	GSTAGE_OP_CLEAR,	/* Clear/Unmap */
+	GSTAGE_OP_WP,		/* Write-protect */
+};
+
+void kvm_riscv_gstage_op_pte(struct kvm_gstage *gstage, gpa_t addr,
+			     pte_t *ptep, u32 ptep_level, enum kvm_riscv_gstage_op op);
+
+void kvm_riscv_gstage_unmap_range(struct kvm_gstage *gstage,
+				  gpa_t start, gpa_t size, bool may_block);
+
+void kvm_riscv_gstage_wp_range(struct kvm_gstage *gstage, gpa_t start, gpa_t end);
+
+void kvm_riscv_gstage_mode_detect(void);
+
+#endif
diff --git a/arch/riscv/include/asm/kvm_mmu.h b/arch/riscv/include/asm/kvm_mmu.h
index 91c11e692dc7..5439e76f0a96 100644
--- a/arch/riscv/include/asm/kvm_mmu.h
+++ b/arch/riscv/include/asm/kvm_mmu.h
@@ -6,28 +6,16 @@
 #ifndef __RISCV_KVM_MMU_H_
 #define __RISCV_KVM_MMU_H_
 
-#include <linux/kvm_types.h>
+#include <asm/kvm_gstage.h>
 
-struct kvm_gstage_mapping {
-	gpa_t addr;
-	pte_t pte;
-	u32 level;
-};
-
-int kvm_riscv_gstage_ioremap(struct kvm *kvm, gpa_t gpa,
-			     phys_addr_t hpa, unsigned long size,
-			     bool writable, bool in_atomic);
-void kvm_riscv_gstage_iounmap(struct kvm *kvm, gpa_t gpa,
-			      unsigned long size);
-int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
-			 struct kvm_memory_slot *memslot,
-			 gpa_t gpa, unsigned long hva, bool is_write,
-			 struct kvm_gstage_mapping *out_map);
-int kvm_riscv_gstage_alloc_pgd(struct kvm *kvm);
-void kvm_riscv_gstage_free_pgd(struct kvm *kvm);
-void kvm_riscv_gstage_update_hgatp(struct kvm_vcpu *vcpu);
-void kvm_riscv_gstage_mode_detect(void);
-unsigned long kvm_riscv_gstage_mode(void);
-int kvm_riscv_gstage_gpa_bits(void);
+int kvm_riscv_mmu_ioremap(struct kvm *kvm, gpa_t gpa, phys_addr_t hpa,
+			  unsigned long size, bool writable, bool in_atomic);
+void kvm_riscv_mmu_iounmap(struct kvm *kvm, gpa_t gpa, unsigned long size);
+int kvm_riscv_mmu_map(struct kvm_vcpu *vcpu, struct kvm_memory_slot *memslot,
+		      gpa_t gpa, unsigned long hva, bool is_write,
+		      struct kvm_gstage_mapping *out_map);
+int kvm_riscv_mmu_alloc_pgd(struct kvm *kvm);
+void kvm_riscv_mmu_free_pgd(struct kvm *kvm);
+void kvm_riscv_mmu_update_hgatp(struct kvm_vcpu *vcpu);
 
 #endif
diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
index 4e0bba91d284..4b199dc3e58b 100644
--- a/arch/riscv/kvm/Makefile
+++ b/arch/riscv/kvm/Makefile
@@ -14,6 +14,7 @@ kvm-y += aia.o
 kvm-y += aia_aplic.o
 kvm-y += aia_device.o
 kvm-y += aia_imsic.o
+kvm-y += gstage.o
 kvm-y += main.o
 kvm-y += mmu.o
 kvm-y += nacl.o
diff --git a/arch/riscv/kvm/aia_imsic.c b/arch/riscv/kvm/aia_imsic.c
index 40b469c0a01f..ea1a36836d9c 100644
--- a/arch/riscv/kvm/aia_imsic.c
+++ b/arch/riscv/kvm/aia_imsic.c
@@ -704,9 +704,8 @@ void kvm_riscv_vcpu_aia_imsic_release(struct kvm_vcpu *vcpu)
 	 */
 
 	/* Purge the G-stage mapping */
-	kvm_riscv_gstage_iounmap(vcpu->kvm,
-				 vcpu->arch.aia_context.imsic_addr,
-				 IMSIC_MMIO_PAGE_SZ);
+	kvm_riscv_mmu_iounmap(vcpu->kvm, vcpu->arch.aia_context.imsic_addr,
+			      IMSIC_MMIO_PAGE_SZ);
 
 	/* TODO: Purge the IOMMU mapping ??? */
 
@@ -786,9 +785,9 @@ int kvm_riscv_vcpu_aia_imsic_update(struct kvm_vcpu *vcpu)
 	imsic_vsfile_local_clear(new_vsfile_hgei, imsic->nr_hw_eix);
 
 	/* Update G-stage mapping for the new IMSIC VS-file */
-	ret = kvm_riscv_gstage_ioremap(kvm, vcpu->arch.aia_context.imsic_addr,
-				       new_vsfile_pa, IMSIC_MMIO_PAGE_SZ,
-				       true, true);
+	ret = kvm_riscv_mmu_ioremap(kvm, vcpu->arch.aia_context.imsic_addr,
+				    new_vsfile_pa, IMSIC_MMIO_PAGE_SZ,
+				    true, true);
 	if (ret)
 		goto fail_free_vsfile_hgei;
 
diff --git a/arch/riscv/kvm/gstage.c b/arch/riscv/kvm/gstage.c
new file mode 100644
index 000000000000..c7d61f14f6be
--- /dev/null
+++ b/arch/riscv/kvm/gstage.c
@@ -0,0 +1,335 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019 Western Digital Corporation or its affiliates.
+ * Copyright (c) 2025 Ventana Micro Systems Inc.
+ */
+
+#include <linux/bitops.h>
+#include <linux/errno.h>
+#include <linux/kvm_host.h>
+#include <linux/module.h>
+#include <linux/pgtable.h>
+#include <asm/kvm_gstage.h>
+
+#ifdef CONFIG_64BIT
+unsigned long kvm_riscv_gstage_mode __ro_after_init = HGATP_MODE_SV39X4;
+unsigned long kvm_riscv_gstage_pgd_levels __ro_after_init = 3;
+#else
+unsigned long kvm_riscv_gstage_mode __ro_after_init = HGATP_MODE_SV32X4;
+unsigned long kvm_riscv_gstage_pgd_levels __ro_after_init = 2;
+#endif
+
+#define gstage_pte_leaf(__ptep)	\
+	(pte_val(*(__ptep)) & (_PAGE_READ | _PAGE_WRITE | _PAGE_EXEC))
+
+static inline unsigned long gstage_pte_index(gpa_t addr, u32 level)
+{
+	unsigned long mask;
+	unsigned long shift = HGATP_PAGE_SHIFT + (kvm_riscv_gstage_index_bits * level);
+
+	if (level == (kvm_riscv_gstage_pgd_levels - 1))
+		mask = (PTRS_PER_PTE * (1UL << kvm_riscv_gstage_pgd_xbits)) - 1;
+	else
+		mask = PTRS_PER_PTE - 1;
+
+	return (addr >> shift) & mask;
+}
+
+static inline unsigned long gstage_pte_page_vaddr(pte_t pte)
+{
+	return (unsigned long)pfn_to_virt(__page_val_to_pfn(pte_val(pte)));
+}
+
+static int gstage_page_size_to_level(unsigned long page_size, u32 *out_level)
+{
+	u32 i;
+	unsigned long psz = 1UL << 12;
+
+	for (i = 0; i < kvm_riscv_gstage_pgd_levels; i++) {
+		if (page_size == (psz << (i * kvm_riscv_gstage_index_bits))) {
+			*out_level = i;
+			return 0;
+		}
+	}
+
+	return -EINVAL;
+}
+
+static int gstage_level_to_page_order(u32 level, unsigned long *out_pgorder)
+{
+	if (kvm_riscv_gstage_pgd_levels < level)
+		return -EINVAL;
+
+	*out_pgorder = 12 + (level * kvm_riscv_gstage_index_bits);
+	return 0;
+}
+
+static int gstage_level_to_page_size(u32 level, unsigned long *out_pgsize)
+{
+	int rc;
+	unsigned long page_order = PAGE_SHIFT;
+
+	rc = gstage_level_to_page_order(level, &page_order);
+	if (rc)
+		return rc;
+
+	*out_pgsize = BIT(page_order);
+	return 0;
+}
+
+bool kvm_riscv_gstage_get_leaf(struct kvm_gstage *gstage, gpa_t addr,
+			       pte_t **ptepp, u32 *ptep_level)
+{
+	pte_t *ptep;
+	u32 current_level = kvm_riscv_gstage_pgd_levels - 1;
+
+	*ptep_level = current_level;
+	ptep = (pte_t *)gstage->pgd;
+	ptep = &ptep[gstage_pte_index(addr, current_level)];
+	while (ptep && pte_val(ptep_get(ptep))) {
+		if (gstage_pte_leaf(ptep)) {
+			*ptep_level = current_level;
+			*ptepp = ptep;
+			return true;
+		}
+
+		if (current_level) {
+			current_level--;
+			*ptep_level = current_level;
+			ptep = (pte_t *)gstage_pte_page_vaddr(ptep_get(ptep));
+			ptep = &ptep[gstage_pte_index(addr, current_level)];
+		} else {
+			ptep = NULL;
+		}
+	}
+
+	return false;
+}
+
+static void gstage_tlb_flush(struct kvm_gstage *gstage, u32 level, gpa_t addr)
+{
+	unsigned long order = PAGE_SHIFT;
+
+	if (gstage_level_to_page_order(level, &order))
+		return;
+	addr &= ~(BIT(order) - 1);
+
+	if (gstage->flags & KVM_GSTAGE_FLAGS_LOCAL)
+		kvm_riscv_local_hfence_gvma_vmid_gpa(gstage->vmid, addr, BIT(order), order);
+	else
+		kvm_riscv_hfence_gvma_vmid_gpa(gstage->kvm, -1UL, 0, addr, BIT(order), order);
+}
+
+int kvm_riscv_gstage_set_pte(struct kvm_gstage *gstage,
+			     struct kvm_mmu_memory_cache *pcache,
+			     const struct kvm_gstage_mapping *map)
+{
+	u32 current_level = kvm_riscv_gstage_pgd_levels - 1;
+	pte_t *next_ptep = (pte_t *)gstage->pgd;
+	pte_t *ptep = &next_ptep[gstage_pte_index(map->addr, current_level)];
+
+	if (current_level < map->level)
+		return -EINVAL;
+
+	while (current_level != map->level) {
+		if (gstage_pte_leaf(ptep))
+			return -EEXIST;
+
+		if (!pte_val(ptep_get(ptep))) {
+			if (!pcache)
+				return -ENOMEM;
+			next_ptep = kvm_mmu_memory_cache_alloc(pcache);
+			if (!next_ptep)
+				return -ENOMEM;
+			set_pte(ptep, pfn_pte(PFN_DOWN(__pa(next_ptep)),
+					      __pgprot(_PAGE_TABLE)));
+		} else {
+			if (gstage_pte_leaf(ptep))
+				return -EEXIST;
+			next_ptep = (pte_t *)gstage_pte_page_vaddr(ptep_get(ptep));
+		}
+
+		current_level--;
+		ptep = &next_ptep[gstage_pte_index(map->addr, current_level)];
+	}
+
+	if (pte_val(*ptep) != pte_val(map->pte)) {
+		set_pte(ptep, map->pte);
+		if (gstage_pte_leaf(ptep))
+			gstage_tlb_flush(gstage, current_level, map->addr);
+	}
+
+	return 0;
+}
+
+int kvm_riscv_gstage_map_page(struct kvm_gstage *gstage,
+			      struct kvm_mmu_memory_cache *pcache,
+			      gpa_t gpa, phys_addr_t hpa, unsigned long page_size,
+			      bool page_rdonly, bool page_exec,
+			      struct kvm_gstage_mapping *out_map)
+{
+	pgprot_t prot;
+	int ret;
+
+	out_map->addr = gpa;
+	out_map->level = 0;
+
+	ret = gstage_page_size_to_level(page_size, &out_map->level);
+	if (ret)
+		return ret;
+
+	/*
+	 * A RISC-V implementation can choose to either:
+	 * 1) Update 'A' and 'D' PTE bits in hardware
+	 * 2) Generate page fault when 'A' and/or 'D' bits are not set
+	 *    PTE so that software can update these bits.
+	 *
+	 * We support both options mentioned above. To achieve this, we
+	 * always set 'A' and 'D' PTE bits at time of creating G-stage
+	 * mapping. To support KVM dirty page logging with both options
+	 * mentioned above, we will write-protect G-stage PTEs to track
+	 * dirty pages.
+	 */
+
+	if (page_exec) {
+		if (page_rdonly)
+			prot = PAGE_READ_EXEC;
+		else
+			prot = PAGE_WRITE_EXEC;
+	} else {
+		if (page_rdonly)
+			prot = PAGE_READ;
+		else
+			prot = PAGE_WRITE;
+	}
+	out_map->pte = pfn_pte(PFN_DOWN(hpa), prot);
+	out_map->pte = pte_mkdirty(out_map->pte);
+
+	return kvm_riscv_gstage_set_pte(gstage, pcache, out_map);
+}
+
+void kvm_riscv_gstage_op_pte(struct kvm_gstage *gstage, gpa_t addr,
+			     pte_t *ptep, u32 ptep_level, enum kvm_riscv_gstage_op op)
+{
+	int i, ret;
+	pte_t *next_ptep;
+	u32 next_ptep_level;
+	unsigned long next_page_size, page_size;
+
+	ret = gstage_level_to_page_size(ptep_level, &page_size);
+	if (ret)
+		return;
+
+	WARN_ON(addr & (page_size - 1));
+
+	if (!pte_val(ptep_get(ptep)))
+		return;
+
+	if (ptep_level && !gstage_pte_leaf(ptep)) {
+		next_ptep = (pte_t *)gstage_pte_page_vaddr(ptep_get(ptep));
+		next_ptep_level = ptep_level - 1;
+		ret = gstage_level_to_page_size(next_ptep_level, &next_page_size);
+		if (ret)
+			return;
+
+		if (op == GSTAGE_OP_CLEAR)
+			set_pte(ptep, __pte(0));
+		for (i = 0; i < PTRS_PER_PTE; i++)
+			kvm_riscv_gstage_op_pte(gstage, addr + i * next_page_size,
+						&next_ptep[i], next_ptep_level, op);
+		if (op == GSTAGE_OP_CLEAR)
+			put_page(virt_to_page(next_ptep));
+	} else {
+		if (op == GSTAGE_OP_CLEAR)
+			set_pte(ptep, __pte(0));
+		else if (op == GSTAGE_OP_WP)
+			set_pte(ptep, __pte(pte_val(ptep_get(ptep)) & ~_PAGE_WRITE));
+		gstage_tlb_flush(gstage, ptep_level, addr);
+	}
+}
+
+void kvm_riscv_gstage_unmap_range(struct kvm_gstage *gstage,
+				  gpa_t start, gpa_t size, bool may_block)
+{
+	int ret;
+	pte_t *ptep;
+	u32 ptep_level;
+	bool found_leaf;
+	unsigned long page_size;
+	gpa_t addr = start, end = start + size;
+
+	while (addr < end) {
+		found_leaf = kvm_riscv_gstage_get_leaf(gstage, addr, &ptep, &ptep_level);
+		ret = gstage_level_to_page_size(ptep_level, &page_size);
+		if (ret)
+			break;
+
+		if (!found_leaf)
+			goto next;
+
+		if (!(addr & (page_size - 1)) && ((end - addr) >= page_size))
+			kvm_riscv_gstage_op_pte(gstage, addr, ptep,
+						ptep_level, GSTAGE_OP_CLEAR);
+
+next:
+		addr += page_size;
+
+		/*
+		 * If the range is too large, release the kvm->mmu_lock
+		 * to prevent starvation and lockup detector warnings.
+		 */
+		if (!(gstage->flags & KVM_GSTAGE_FLAGS_LOCAL) && may_block && addr < end)
+			cond_resched_lock(&gstage->kvm->mmu_lock);
+	}
+}
+
+void kvm_riscv_gstage_wp_range(struct kvm_gstage *gstage, gpa_t start, gpa_t end)
+{
+	int ret;
+	pte_t *ptep;
+	u32 ptep_level;
+	bool found_leaf;
+	gpa_t addr = start;
+	unsigned long page_size;
+
+	while (addr < end) {
+		found_leaf = kvm_riscv_gstage_get_leaf(gstage, addr, &ptep, &ptep_level);
+		ret = gstage_level_to_page_size(ptep_level, &page_size);
+		if (ret)
+			break;
+
+		if (!found_leaf)
+			goto next;
+
+		if (!(addr & (page_size - 1)) && ((end - addr) >= page_size))
+			kvm_riscv_gstage_op_pte(gstage, addr, ptep,
+						ptep_level, GSTAGE_OP_WP);
+
+next:
+		addr += page_size;
+	}
+}
+
+void __init kvm_riscv_gstage_mode_detect(void)
+{
+#ifdef CONFIG_64BIT
+	/* Try Sv57x4 G-stage mode */
+	csr_write(CSR_HGATP, HGATP_MODE_SV57X4 << HGATP_MODE_SHIFT);
+	if ((csr_read(CSR_HGATP) >> HGATP_MODE_SHIFT) == HGATP_MODE_SV57X4) {
+		kvm_riscv_gstage_mode = HGATP_MODE_SV57X4;
+		kvm_riscv_gstage_pgd_levels = 5;
+		goto skip_sv48x4_test;
+	}
+
+	/* Try Sv48x4 G-stage mode */
+	csr_write(CSR_HGATP, HGATP_MODE_SV48X4 << HGATP_MODE_SHIFT);
+	if ((csr_read(CSR_HGATP) >> HGATP_MODE_SHIFT) == HGATP_MODE_SV48X4) {
+		kvm_riscv_gstage_mode = HGATP_MODE_SV48X4;
+		kvm_riscv_gstage_pgd_levels = 4;
+	}
+skip_sv48x4_test:
+
+	csr_write(CSR_HGATP, 0);
+	kvm_riscv_local_hfence_gvma_all();
+#endif
+}
diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
index b861a5dd7bd9..67c876de74ef 100644
--- a/arch/riscv/kvm/main.c
+++ b/arch/riscv/kvm/main.c
@@ -135,7 +135,7 @@ static int __init riscv_kvm_init(void)
 			 (rc) ? slist : "no features");
 	}
 
-	switch (kvm_riscv_gstage_mode()) {
+	switch (kvm_riscv_gstage_mode) {
 	case HGATP_MODE_SV32X4:
 		str = "Sv32x4";
 		break;
diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index 934c97c21130..9f7dcd8cd741 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -6,9 +6,7 @@
  *     Anup Patel <anup.patel@wdc.com>
  */
 
-#include <linux/bitops.h>
 #include <linux/errno.h>
-#include <linux/err.h>
 #include <linux/hugetlb.h>
 #include <linux/module.h>
 #include <linux/uaccess.h>
@@ -17,340 +15,28 @@
 #include <linux/sched/signal.h>
 #include <asm/kvm_mmu.h>
 #include <asm/kvm_nacl.h>
-#include <asm/page.h>
-#include <asm/pgtable.h>
-
-#ifdef CONFIG_64BIT
-static unsigned long gstage_mode __ro_after_init = (HGATP_MODE_SV39X4 << HGATP_MODE_SHIFT);
-static unsigned long gstage_pgd_levels __ro_after_init = 3;
-#define gstage_index_bits	9
-#else
-static unsigned long gstage_mode __ro_after_init = (HGATP_MODE_SV32X4 << HGATP_MODE_SHIFT);
-static unsigned long gstage_pgd_levels __ro_after_init = 2;
-#define gstage_index_bits	10
-#endif
-
-#define gstage_pgd_xbits	2
-#define gstage_pgd_size	(1UL << (HGATP_PAGE_SHIFT + gstage_pgd_xbits))
-#define gstage_gpa_bits	(HGATP_PAGE_SHIFT + \
-			 (gstage_pgd_levels * gstage_index_bits) + \
-			 gstage_pgd_xbits)
-#define gstage_gpa_size	((gpa_t)(1ULL << gstage_gpa_bits))
-
-#define gstage_pte_leaf(__ptep)	\
-	(pte_val(*(__ptep)) & (_PAGE_READ | _PAGE_WRITE | _PAGE_EXEC))
-
-static inline unsigned long gstage_pte_index(gpa_t addr, u32 level)
-{
-	unsigned long mask;
-	unsigned long shift = HGATP_PAGE_SHIFT + (gstage_index_bits * level);
-
-	if (level == (gstage_pgd_levels - 1))
-		mask = (PTRS_PER_PTE * (1UL << gstage_pgd_xbits)) - 1;
-	else
-		mask = PTRS_PER_PTE - 1;
-
-	return (addr >> shift) & mask;
-}
 
-static inline unsigned long gstage_pte_page_vaddr(pte_t pte)
-{
-	return (unsigned long)pfn_to_virt(__page_val_to_pfn(pte_val(pte)));
-}
-
-static int gstage_page_size_to_level(unsigned long page_size, u32 *out_level)
-{
-	u32 i;
-	unsigned long psz = 1UL << 12;
-
-	for (i = 0; i < gstage_pgd_levels; i++) {
-		if (page_size == (psz << (i * gstage_index_bits))) {
-			*out_level = i;
-			return 0;
-		}
-	}
-
-	return -EINVAL;
-}
-
-static int gstage_level_to_page_order(u32 level, unsigned long *out_pgorder)
-{
-	if (gstage_pgd_levels < level)
-		return -EINVAL;
-
-	*out_pgorder = 12 + (level * gstage_index_bits);
-	return 0;
-}
-
-static int gstage_level_to_page_size(u32 level, unsigned long *out_pgsize)
-{
-	int rc;
-	unsigned long page_order = PAGE_SHIFT;
-
-	rc = gstage_level_to_page_order(level, &page_order);
-	if (rc)
-		return rc;
-
-	*out_pgsize = BIT(page_order);
-	return 0;
-}
-
-static bool gstage_get_leaf_entry(struct kvm *kvm, gpa_t addr,
-				  pte_t **ptepp, u32 *ptep_level)
-{
-	pte_t *ptep;
-	u32 current_level = gstage_pgd_levels - 1;
-
-	*ptep_level = current_level;
-	ptep = (pte_t *)kvm->arch.pgd;
-	ptep = &ptep[gstage_pte_index(addr, current_level)];
-	while (ptep && pte_val(ptep_get(ptep))) {
-		if (gstage_pte_leaf(ptep)) {
-			*ptep_level = current_level;
-			*ptepp = ptep;
-			return true;
-		}
-
-		if (current_level) {
-			current_level--;
-			*ptep_level = current_level;
-			ptep = (pte_t *)gstage_pte_page_vaddr(ptep_get(ptep));
-			ptep = &ptep[gstage_pte_index(addr, current_level)];
-		} else {
-			ptep = NULL;
-		}
-	}
-
-	return false;
-}
-
-static void gstage_remote_tlb_flush(struct kvm *kvm, u32 level, gpa_t addr)
-{
-	unsigned long order = PAGE_SHIFT;
-
-	if (gstage_level_to_page_order(level, &order))
-		return;
-	addr &= ~(BIT(order) - 1);
-
-	kvm_riscv_hfence_gvma_vmid_gpa(kvm, -1UL, 0, addr, BIT(order), order);
-}
-
-static int gstage_set_pte(struct kvm *kvm,
-			  struct kvm_mmu_memory_cache *pcache,
-			  const struct kvm_gstage_mapping *map)
-{
-	u32 current_level = gstage_pgd_levels - 1;
-	pte_t *next_ptep = (pte_t *)kvm->arch.pgd;
-	pte_t *ptep = &next_ptep[gstage_pte_index(map->addr, current_level)];
-
-	if (current_level < map->level)
-		return -EINVAL;
-
-	while (current_level != map->level) {
-		if (gstage_pte_leaf(ptep))
-			return -EEXIST;
-
-		if (!pte_val(ptep_get(ptep))) {
-			if (!pcache)
-				return -ENOMEM;
-			next_ptep = kvm_mmu_memory_cache_alloc(pcache);
-			if (!next_ptep)
-				return -ENOMEM;
-			set_pte(ptep, pfn_pte(PFN_DOWN(__pa(next_ptep)),
-					      __pgprot(_PAGE_TABLE)));
-		} else {
-			if (gstage_pte_leaf(ptep))
-				return -EEXIST;
-			next_ptep = (pte_t *)gstage_pte_page_vaddr(ptep_get(ptep));
-		}
-
-		current_level--;
-		ptep = &next_ptep[gstage_pte_index(map->addr, current_level)];
-	}
-
-	if (pte_val(*ptep) != pte_val(map->pte)) {
-		set_pte(ptep, map->pte);
-		if (gstage_pte_leaf(ptep))
-			gstage_remote_tlb_flush(kvm, current_level, map->addr);
-	}
-
-	return 0;
-}
-
-static int gstage_map_page(struct kvm *kvm,
-			   struct kvm_mmu_memory_cache *pcache,
-			   gpa_t gpa, phys_addr_t hpa,
-			   unsigned long page_size,
-			   bool page_rdonly, bool page_exec,
-			   struct kvm_gstage_mapping *out_map)
-{
-	pgprot_t prot;
-	int ret;
-
-	out_map->addr = gpa;
-	out_map->level = 0;
-
-	ret = gstage_page_size_to_level(page_size, &out_map->level);
-	if (ret)
-		return ret;
-
-	/*
-	 * A RISC-V implementation can choose to either:
-	 * 1) Update 'A' and 'D' PTE bits in hardware
-	 * 2) Generate page fault when 'A' and/or 'D' bits are not set
-	 *    PTE so that software can update these bits.
-	 *
-	 * We support both options mentioned above. To achieve this, we
-	 * always set 'A' and 'D' PTE bits at time of creating G-stage
-	 * mapping. To support KVM dirty page logging with both options
-	 * mentioned above, we will write-protect G-stage PTEs to track
-	 * dirty pages.
-	 */
-
-	if (page_exec) {
-		if (page_rdonly)
-			prot = PAGE_READ_EXEC;
-		else
-			prot = PAGE_WRITE_EXEC;
-	} else {
-		if (page_rdonly)
-			prot = PAGE_READ;
-		else
-			prot = PAGE_WRITE;
-	}
-	out_map->pte = pfn_pte(PFN_DOWN(hpa), prot);
-	out_map->pte = pte_mkdirty(out_map->pte);
-
-	return gstage_set_pte(kvm, pcache, out_map);
-}
-
-enum gstage_op {
-	GSTAGE_OP_NOP = 0,	/* Nothing */
-	GSTAGE_OP_CLEAR,	/* Clear/Unmap */
-	GSTAGE_OP_WP,		/* Write-protect */
-};
-
-static void gstage_op_pte(struct kvm *kvm, gpa_t addr,
-			  pte_t *ptep, u32 ptep_level, enum gstage_op op)
-{
-	int i, ret;
-	pte_t *next_ptep;
-	u32 next_ptep_level;
-	unsigned long next_page_size, page_size;
-
-	ret = gstage_level_to_page_size(ptep_level, &page_size);
-	if (ret)
-		return;
-
-	BUG_ON(addr & (page_size - 1));
-
-	if (!pte_val(ptep_get(ptep)))
-		return;
-
-	if (ptep_level && !gstage_pte_leaf(ptep)) {
-		next_ptep = (pte_t *)gstage_pte_page_vaddr(ptep_get(ptep));
-		next_ptep_level = ptep_level - 1;
-		ret = gstage_level_to_page_size(next_ptep_level,
-						&next_page_size);
-		if (ret)
-			return;
-
-		if (op == GSTAGE_OP_CLEAR)
-			set_pte(ptep, __pte(0));
-		for (i = 0; i < PTRS_PER_PTE; i++)
-			gstage_op_pte(kvm, addr + i * next_page_size,
-					&next_ptep[i], next_ptep_level, op);
-		if (op == GSTAGE_OP_CLEAR)
-			put_page(virt_to_page(next_ptep));
-	} else {
-		if (op == GSTAGE_OP_CLEAR)
-			set_pte(ptep, __pte(0));
-		else if (op == GSTAGE_OP_WP)
-			set_pte(ptep, __pte(pte_val(ptep_get(ptep)) & ~_PAGE_WRITE));
-		gstage_remote_tlb_flush(kvm, ptep_level, addr);
-	}
-}
-
-static void gstage_unmap_range(struct kvm *kvm, gpa_t start,
-			       gpa_t size, bool may_block)
-{
-	int ret;
-	pte_t *ptep;
-	u32 ptep_level;
-	bool found_leaf;
-	unsigned long page_size;
-	gpa_t addr = start, end = start + size;
-
-	while (addr < end) {
-		found_leaf = gstage_get_leaf_entry(kvm, addr,
-						   &ptep, &ptep_level);
-		ret = gstage_level_to_page_size(ptep_level, &page_size);
-		if (ret)
-			break;
-
-		if (!found_leaf)
-			goto next;
-
-		if (!(addr & (page_size - 1)) && ((end - addr) >= page_size))
-			gstage_op_pte(kvm, addr, ptep,
-				      ptep_level, GSTAGE_OP_CLEAR);
-
-next:
-		addr += page_size;
-
-		/*
-		 * If the range is too large, release the kvm->mmu_lock
-		 * to prevent starvation and lockup detector warnings.
-		 */
-		if (may_block && addr < end)
-			cond_resched_lock(&kvm->mmu_lock);
-	}
-}
-
-static void gstage_wp_range(struct kvm *kvm, gpa_t start, gpa_t end)
-{
-	int ret;
-	pte_t *ptep;
-	u32 ptep_level;
-	bool found_leaf;
-	gpa_t addr = start;
-	unsigned long page_size;
-
-	while (addr < end) {
-		found_leaf = gstage_get_leaf_entry(kvm, addr,
-						   &ptep, &ptep_level);
-		ret = gstage_level_to_page_size(ptep_level, &page_size);
-		if (ret)
-			break;
-
-		if (!found_leaf)
-			goto next;
-
-		if (!(addr & (page_size - 1)) && ((end - addr) >= page_size))
-			gstage_op_pte(kvm, addr, ptep,
-				      ptep_level, GSTAGE_OP_WP);
-
-next:
-		addr += page_size;
-	}
-}
-
-static void gstage_wp_memory_region(struct kvm *kvm, int slot)
+static void mmu_wp_memory_region(struct kvm *kvm, int slot)
 {
 	struct kvm_memslots *slots = kvm_memslots(kvm);
 	struct kvm_memory_slot *memslot = id_to_memslot(slots, slot);
 	phys_addr_t start = memslot->base_gfn << PAGE_SHIFT;
 	phys_addr_t end = (memslot->base_gfn + memslot->npages) << PAGE_SHIFT;
+	struct kvm_gstage gstage;
+
+	gstage.kvm = kvm;
+	gstage.flags = 0;
+	gstage.vmid = READ_ONCE(kvm->arch.vmid.vmid);
+	gstage.pgd = kvm->arch.pgd;
 
 	spin_lock(&kvm->mmu_lock);
-	gstage_wp_range(kvm, start, end);
+	kvm_riscv_gstage_wp_range(&gstage, start, end);
 	spin_unlock(&kvm->mmu_lock);
 	kvm_flush_remote_tlbs_memslot(kvm, memslot);
 }
 
-int kvm_riscv_gstage_ioremap(struct kvm *kvm, gpa_t gpa,
-			     phys_addr_t hpa, unsigned long size,
-			     bool writable, bool in_atomic)
+int kvm_riscv_mmu_ioremap(struct kvm *kvm, gpa_t gpa, phys_addr_t hpa,
+			  unsigned long size, bool writable, bool in_atomic)
 {
 	int ret = 0;
 	unsigned long pfn;
@@ -360,6 +46,12 @@ int kvm_riscv_gstage_ioremap(struct kvm *kvm, gpa_t gpa,
 		.gfp_zero = __GFP_ZERO,
 	};
 	struct kvm_gstage_mapping map;
+	struct kvm_gstage gstage;
+
+	gstage.kvm = kvm;
+	gstage.flags = 0;
+	gstage.vmid = READ_ONCE(kvm->arch.vmid.vmid);
+	gstage.pgd = kvm->arch.pgd;
 
 	end = (gpa + size + PAGE_SIZE - 1) & PAGE_MASK;
 	pfn = __phys_to_pfn(hpa);
@@ -372,12 +64,12 @@ int kvm_riscv_gstage_ioremap(struct kvm *kvm, gpa_t gpa,
 		if (!writable)
 			map.pte = pte_wrprotect(map.pte);
 
-		ret = kvm_mmu_topup_memory_cache(&pcache, gstage_pgd_levels);
+		ret = kvm_mmu_topup_memory_cache(&pcache, kvm_riscv_gstage_pgd_levels);
 		if (ret)
 			goto out;
 
 		spin_lock(&kvm->mmu_lock);
-		ret = gstage_set_pte(kvm, &pcache, &map);
+		ret = kvm_riscv_gstage_set_pte(&gstage, &pcache, &map);
 		spin_unlock(&kvm->mmu_lock);
 		if (ret)
 			goto out;
@@ -390,10 +82,17 @@ int kvm_riscv_gstage_ioremap(struct kvm *kvm, gpa_t gpa,
 	return ret;
 }
 
-void kvm_riscv_gstage_iounmap(struct kvm *kvm, gpa_t gpa, unsigned long size)
+void kvm_riscv_mmu_iounmap(struct kvm *kvm, gpa_t gpa, unsigned long size)
 {
+	struct kvm_gstage gstage;
+
+	gstage.kvm = kvm;
+	gstage.flags = 0;
+	gstage.vmid = READ_ONCE(kvm->arch.vmid.vmid);
+	gstage.pgd = kvm->arch.pgd;
+
 	spin_lock(&kvm->mmu_lock);
-	gstage_unmap_range(kvm, gpa, size, false);
+	kvm_riscv_gstage_unmap_range(&gstage, gpa, size, false);
 	spin_unlock(&kvm->mmu_lock);
 }
 
@@ -405,8 +104,14 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 	phys_addr_t base_gfn = slot->base_gfn + gfn_offset;
 	phys_addr_t start = (base_gfn +  __ffs(mask)) << PAGE_SHIFT;
 	phys_addr_t end = (base_gfn + __fls(mask) + 1) << PAGE_SHIFT;
+	struct kvm_gstage gstage;
+
+	gstage.kvm = kvm;
+	gstage.flags = 0;
+	gstage.vmid = READ_ONCE(kvm->arch.vmid.vmid);
+	gstage.pgd = kvm->arch.pgd;
 
-	gstage_wp_range(kvm, start, end);
+	kvm_riscv_gstage_wp_range(&gstage, start, end);
 }
 
 void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
@@ -423,7 +128,7 @@ void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen)
 
 void kvm_arch_flush_shadow_all(struct kvm *kvm)
 {
-	kvm_riscv_gstage_free_pgd(kvm);
+	kvm_riscv_mmu_free_pgd(kvm);
 }
 
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
@@ -431,9 +136,15 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 {
 	gpa_t gpa = slot->base_gfn << PAGE_SHIFT;
 	phys_addr_t size = slot->npages << PAGE_SHIFT;
+	struct kvm_gstage gstage;
+
+	gstage.kvm = kvm;
+	gstage.flags = 0;
+	gstage.vmid = READ_ONCE(kvm->arch.vmid.vmid);
+	gstage.pgd = kvm->arch.pgd;
 
 	spin_lock(&kvm->mmu_lock);
-	gstage_unmap_range(kvm, gpa, size, false);
+	kvm_riscv_gstage_unmap_range(&gstage, gpa, size, false);
 	spin_unlock(&kvm->mmu_lock);
 }
 
@@ -448,7 +159,7 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 	 * the memory slot is write protected.
 	 */
 	if (change != KVM_MR_DELETE && new->flags & KVM_MEM_LOG_DIRTY_PAGES)
-		gstage_wp_memory_region(kvm, new->id);
+		mmu_wp_memory_region(kvm, new->id);
 }
 
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
@@ -470,7 +181,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	 * space addressable by the KVM guest GPA space.
 	 */
 	if ((new->base_gfn + new->npages) >=
-	    (gstage_gpa_size >> PAGE_SHIFT))
+	    (kvm_riscv_gstage_gpa_size >> PAGE_SHIFT))
 		return -EFAULT;
 
 	hva = new->userspace_addr;
@@ -526,9 +237,8 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				goto out;
 			}
 
-			ret = kvm_riscv_gstage_ioremap(kvm, gpa, pa,
-						       vm_end - vm_start,
-						       writable, false);
+			ret = kvm_riscv_mmu_ioremap(kvm, gpa, pa, vm_end - vm_start,
+						    writable, false);
 			if (ret)
 				break;
 		}
@@ -539,7 +249,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 		goto out;
 
 	if (ret)
-		kvm_riscv_gstage_iounmap(kvm, base_gpa, size);
+		kvm_riscv_mmu_iounmap(kvm, base_gpa, size);
 
 out:
 	mmap_read_unlock(current->mm);
@@ -548,12 +258,18 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 
 bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 {
+	struct kvm_gstage gstage;
+
 	if (!kvm->arch.pgd)
 		return false;
 
-	gstage_unmap_range(kvm, range->start << PAGE_SHIFT,
-			   (range->end - range->start) << PAGE_SHIFT,
-			   range->may_block);
+	gstage.kvm = kvm;
+	gstage.flags = 0;
+	gstage.vmid = READ_ONCE(kvm->arch.vmid.vmid);
+	gstage.pgd = kvm->arch.pgd;
+	kvm_riscv_gstage_unmap_range(&gstage, range->start << PAGE_SHIFT,
+				     (range->end - range->start) << PAGE_SHIFT,
+				     range->may_block);
 	return false;
 }
 
@@ -562,14 +278,19 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	pte_t *ptep;
 	u32 ptep_level = 0;
 	u64 size = (range->end - range->start) << PAGE_SHIFT;
+	struct kvm_gstage gstage;
 
 	if (!kvm->arch.pgd)
 		return false;
 
 	WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PUD_SIZE);
 
-	if (!gstage_get_leaf_entry(kvm, range->start << PAGE_SHIFT,
-				   &ptep, &ptep_level))
+	gstage.kvm = kvm;
+	gstage.flags = 0;
+	gstage.vmid = READ_ONCE(kvm->arch.vmid.vmid);
+	gstage.pgd = kvm->arch.pgd;
+	if (!kvm_riscv_gstage_get_leaf(&gstage, range->start << PAGE_SHIFT,
+				       &ptep, &ptep_level))
 		return false;
 
 	return ptep_test_and_clear_young(NULL, 0, ptep);
@@ -580,23 +301,27 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	pte_t *ptep;
 	u32 ptep_level = 0;
 	u64 size = (range->end - range->start) << PAGE_SHIFT;
+	struct kvm_gstage gstage;
 
 	if (!kvm->arch.pgd)
 		return false;
 
 	WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PUD_SIZE);
 
-	if (!gstage_get_leaf_entry(kvm, range->start << PAGE_SHIFT,
-				   &ptep, &ptep_level))
+	gstage.kvm = kvm;
+	gstage.flags = 0;
+	gstage.vmid = READ_ONCE(kvm->arch.vmid.vmid);
+	gstage.pgd = kvm->arch.pgd;
+	if (!kvm_riscv_gstage_get_leaf(&gstage, range->start << PAGE_SHIFT,
+				       &ptep, &ptep_level))
 		return false;
 
 	return pte_young(ptep_get(ptep));
 }
 
-int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
-			 struct kvm_memory_slot *memslot,
-			 gpa_t gpa, unsigned long hva, bool is_write,
-			 struct kvm_gstage_mapping *out_map)
+int kvm_riscv_mmu_map(struct kvm_vcpu *vcpu, struct kvm_memory_slot *memslot,
+		      gpa_t gpa, unsigned long hva, bool is_write,
+		      struct kvm_gstage_mapping *out_map)
 {
 	int ret;
 	kvm_pfn_t hfn;
@@ -609,13 +334,19 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
 	bool logging = (memslot->dirty_bitmap &&
 			!(memslot->flags & KVM_MEM_READONLY)) ? true : false;
 	unsigned long vma_pagesize, mmu_seq;
+	struct kvm_gstage gstage;
 	struct page *page;
 
+	gstage.kvm = kvm;
+	gstage.flags = 0;
+	gstage.vmid = READ_ONCE(kvm->arch.vmid.vmid);
+	gstage.pgd = kvm->arch.pgd;
+
 	/* Setup initial state of output mapping */
 	memset(out_map, 0, sizeof(*out_map));
 
 	/* We need minimum second+third level pages */
-	ret = kvm_mmu_topup_memory_cache(pcache, gstage_pgd_levels);
+	ret = kvm_mmu_topup_memory_cache(pcache, kvm_riscv_gstage_pgd_levels);
 	if (ret) {
 		kvm_err("Failed to topup G-stage cache\n");
 		return ret;
@@ -682,11 +413,11 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
 
 	if (writable) {
 		mark_page_dirty(kvm, gfn);
-		ret = gstage_map_page(kvm, pcache, gpa, hfn << PAGE_SHIFT,
-				      vma_pagesize, false, true, out_map);
+		ret = kvm_riscv_gstage_map_page(&gstage, pcache, gpa, hfn << PAGE_SHIFT,
+						vma_pagesize, false, true, out_map);
 	} else {
-		ret = gstage_map_page(kvm, pcache, gpa, hfn << PAGE_SHIFT,
-				      vma_pagesize, true, true, out_map);
+		ret = kvm_riscv_gstage_map_page(&gstage, pcache, gpa, hfn << PAGE_SHIFT,
+						vma_pagesize, true, true, out_map);
 	}
 
 	if (ret)
@@ -698,7 +429,7 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
 	return ret;
 }
 
-int kvm_riscv_gstage_alloc_pgd(struct kvm *kvm)
+int kvm_riscv_mmu_alloc_pgd(struct kvm *kvm)
 {
 	struct page *pgd_page;
 
@@ -708,7 +439,7 @@ int kvm_riscv_gstage_alloc_pgd(struct kvm *kvm)
 	}
 
 	pgd_page = alloc_pages(GFP_KERNEL | __GFP_ZERO,
-				get_order(gstage_pgd_size));
+				get_order(kvm_riscv_gstage_pgd_size));
 	if (!pgd_page)
 		return -ENOMEM;
 	kvm->arch.pgd = page_to_virt(pgd_page);
@@ -717,13 +448,18 @@ int kvm_riscv_gstage_alloc_pgd(struct kvm *kvm)
 	return 0;
 }
 
-void kvm_riscv_gstage_free_pgd(struct kvm *kvm)
+void kvm_riscv_mmu_free_pgd(struct kvm *kvm)
 {
+	struct kvm_gstage gstage;
 	void *pgd = NULL;
 
 	spin_lock(&kvm->mmu_lock);
 	if (kvm->arch.pgd) {
-		gstage_unmap_range(kvm, 0UL, gstage_gpa_size, false);
+		gstage.kvm = kvm;
+		gstage.flags = 0;
+		gstage.vmid = READ_ONCE(kvm->arch.vmid.vmid);
+		gstage.pgd = kvm->arch.pgd;
+		kvm_riscv_gstage_unmap_range(&gstage, 0UL, kvm_riscv_gstage_gpa_size, false);
 		pgd = READ_ONCE(kvm->arch.pgd);
 		kvm->arch.pgd = NULL;
 		kvm->arch.pgd_phys = 0;
@@ -731,12 +467,12 @@ void kvm_riscv_gstage_free_pgd(struct kvm *kvm)
 	spin_unlock(&kvm->mmu_lock);
 
 	if (pgd)
-		free_pages((unsigned long)pgd, get_order(gstage_pgd_size));
+		free_pages((unsigned long)pgd, get_order(kvm_riscv_gstage_pgd_size));
 }
 
-void kvm_riscv_gstage_update_hgatp(struct kvm_vcpu *vcpu)
+void kvm_riscv_mmu_update_hgatp(struct kvm_vcpu *vcpu)
 {
-	unsigned long hgatp = gstage_mode;
+	unsigned long hgatp = kvm_riscv_gstage_mode << HGATP_MODE_SHIFT;
 	struct kvm_arch *k = &vcpu->kvm->arch;
 
 	hgatp |= (READ_ONCE(k->vmid.vmid) << HGATP_VMID_SHIFT) & HGATP_VMID;
@@ -747,37 +483,3 @@ void kvm_riscv_gstage_update_hgatp(struct kvm_vcpu *vcpu)
 	if (!kvm_riscv_gstage_vmid_bits())
 		kvm_riscv_local_hfence_gvma_all();
 }
-
-void __init kvm_riscv_gstage_mode_detect(void)
-{
-#ifdef CONFIG_64BIT
-	/* Try Sv57x4 G-stage mode */
-	csr_write(CSR_HGATP, HGATP_MODE_SV57X4 << HGATP_MODE_SHIFT);
-	if ((csr_read(CSR_HGATP) >> HGATP_MODE_SHIFT) == HGATP_MODE_SV57X4) {
-		gstage_mode = (HGATP_MODE_SV57X4 << HGATP_MODE_SHIFT);
-		gstage_pgd_levels = 5;
-		goto skip_sv48x4_test;
-	}
-
-	/* Try Sv48x4 G-stage mode */
-	csr_write(CSR_HGATP, HGATP_MODE_SV48X4 << HGATP_MODE_SHIFT);
-	if ((csr_read(CSR_HGATP) >> HGATP_MODE_SHIFT) == HGATP_MODE_SV48X4) {
-		gstage_mode = (HGATP_MODE_SV48X4 << HGATP_MODE_SHIFT);
-		gstage_pgd_levels = 4;
-	}
-skip_sv48x4_test:
-
-	csr_write(CSR_HGATP, 0);
-	kvm_riscv_local_hfence_gvma_all();
-#endif
-}
-
-unsigned long __init kvm_riscv_gstage_mode(void)
-{
-	return gstage_mode >> HGATP_MODE_SHIFT;
-}
-
-int kvm_riscv_gstage_gpa_bits(void)
-{
-	return gstage_gpa_bits;
-}
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index bfe4d1369b24..834405b03862 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -631,7 +631,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		}
 	}
 
-	kvm_riscv_gstage_update_hgatp(vcpu);
+	kvm_riscv_mmu_update_hgatp(vcpu);
 
 	kvm_riscv_vcpu_timer_restore(vcpu);
 
@@ -716,7 +716,7 @@ static void kvm_riscv_check_vcpu_requests(struct kvm_vcpu *vcpu)
 			kvm_riscv_reset_vcpu(vcpu, true);
 
 		if (kvm_check_request(KVM_REQ_UPDATE_HGATP, vcpu))
-			kvm_riscv_gstage_update_hgatp(vcpu);
+			kvm_riscv_mmu_update_hgatp(vcpu);
 
 		if (kvm_check_request(KVM_REQ_FENCE_I, vcpu))
 			kvm_riscv_fence_i_process(vcpu);
diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
index 4fadf2bcd070..02da4695e0c8 100644
--- a/arch/riscv/kvm/vcpu_exit.c
+++ b/arch/riscv/kvm/vcpu_exit.c
@@ -42,8 +42,9 @@ static int gstage_page_fault(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		};
 	}
 
-	ret = kvm_riscv_gstage_map(vcpu, memslot, fault_addr, hva,
-		(trap->scause == EXC_STORE_GUEST_PAGE_FAULT) ? true : false, &host_map);
+	ret = kvm_riscv_mmu_map(vcpu, memslot, fault_addr, hva,
+				(trap->scause == EXC_STORE_GUEST_PAGE_FAULT) ? true : false,
+				&host_map);
 	if (ret < 0)
 		return ret;
 
diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
index 8601cf29e5f8..66d91ae6e9b2 100644
--- a/arch/riscv/kvm/vm.c
+++ b/arch/riscv/kvm/vm.c
@@ -32,13 +32,13 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 {
 	int r;
 
-	r = kvm_riscv_gstage_alloc_pgd(kvm);
+	r = kvm_riscv_mmu_alloc_pgd(kvm);
 	if (r)
 		return r;
 
 	r = kvm_riscv_gstage_vmid_init(kvm);
 	if (r) {
-		kvm_riscv_gstage_free_pgd(kvm);
+		kvm_riscv_mmu_free_pgd(kvm);
 		return r;
 	}
 
@@ -200,7 +200,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = KVM_USER_MEM_SLOTS;
 		break;
 	case KVM_CAP_VM_GPA_BITS:
-		r = kvm_riscv_gstage_gpa_bits();
+		r = kvm_riscv_gstage_gpa_bits;
 		break;
 	default:
 		r = 0;
-- 
2.43.0


