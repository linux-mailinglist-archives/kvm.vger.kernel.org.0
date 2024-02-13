Return-Path: <kvm+bounces-8614-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 73779852CE2
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 10:49:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C6606B260D6
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 09:49:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64E0B55C3E;
	Tue, 13 Feb 2024 09:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fnhsyHji"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BD175577B
	for <kvm@vger.kernel.org>; Tue, 13 Feb 2024 09:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707817314; cv=none; b=GZzuyHTnXIgzMfNJUy+vP4Of8Wknsro30C47j2vEE2QNSWHlnOFX213RG03/GshYYgcBAni2+OExdLbsefBpS4kumMqCryxbQdqhYEDHTgZ4MiV8mzz36jzJtPHxUKFYikk3mFuAT0CUGtwtaCoY0PnWesZvOwjr8+PX5fRxVDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707817314; c=relaxed/simple;
	bh=LfIizmE1ae4sFNPaSEw/Hx7kqnSpkrUJGFdC2oe/wBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lEscDdPK9OCGC+Ajt2QyZayWGlnHUahBxMjup6to8sf/5kubzFgW6Pi0TVgeK4AI2J4JCqRHhN160PDxO8+v3R/tKoX0hAqnCMOwqBD4aAbT+nzwI5a6HkiU0akpB2fspeQSlrZpyPNttXY2EYmIUbargkIUg698BYf/0jmteVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fnhsyHji; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1707817311;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cnCi4BYIqMn8+Kc3y6O2Ph5n/B+/QtuSdPhWS/W9G2A=;
	b=fnhsyHjiUGadzULajmuLUrF0hDvKZSO4srOYrhf2IeX3GRiXL//klQxXw/rurnNZhNr9nP
	jj7nNFXEKEB2AIDKUw/llicgcNS7k/2TxnKtp4W2cdIf4xryaW7szE89B6sa3URnxcXgKm
	9R4Wb9I7kXQOYhAUbbVdKvesvny1ADg=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-kernel@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 20/23] KVM: selftests: Add helper for enabling LPIs on a redistributor
Date: Tue, 13 Feb 2024 09:41:41 +0000
Message-ID: <20240213094141.3962026-1-oliver.upton@linux.dev>
In-Reply-To: <20240213093250.3960069-1-oliver.upton@linux.dev>
References: <20240213093250.3960069-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The selftests GIC library presently does not support LPIs. Add a
userspace helper for configuring a redistributor for LPIs, installing
an LPI configuration table and LPI pending table.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 .../selftests/kvm/include/aarch64/vgic.h      |  4 +
 .../testing/selftests/kvm/lib/aarch64/vgic.c  | 78 +++++++++++++++++++
 2 files changed, 82 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/aarch64/vgic.h b/tools/testing/selftests/kvm/include/aarch64/vgic.h
index d45b2902439d..ae6a54453c62 100644
--- a/tools/testing/selftests/kvm/include/aarch64/vgic.h
+++ b/tools/testing/selftests/kvm/include/aarch64/vgic.h
@@ -32,6 +32,10 @@ void kvm_irq_write_isactiver(int gic_fd, uint32_t intid, struct kvm_vcpu *vcpu);
 
 #define KVM_IRQCHIP_NUM_PINS	(1020 - 32)
 
+void vgic_rdist_enable_lpis(int gic_fd, struct kvm_vcpu *vcpu,
+			    vm_paddr_t cfg_table, size_t cfg_table_size,
+			    vm_paddr_t pend_table);
+
 struct vgic_its {
 	int	its_fd;
 	void 	*cmdq_hva;
diff --git a/tools/testing/selftests/kvm/lib/aarch64/vgic.c b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
index fc7b4fbe6453..2e1e0aa8cabc 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/vgic.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
@@ -3,8 +3,10 @@
  * ARM Generic Interrupt Controller (GIC) v3 host support
  */
 
+#include <linux/kernel.h>
 #include <linux/kvm.h>
 #include <linux/sizes.h>
+#include <asm/cputype.h>
 #include <asm/kvm_para.h>
 #include <asm/kvm.h>
 
@@ -168,6 +170,82 @@ void kvm_irq_write_isactiver(int gic_fd, uint32_t intid, struct kvm_vcpu *vcpu)
 	vgic_poke_irq(gic_fd, intid, vcpu, GICD_ISACTIVER);
 }
 
+#define VGIC_AFFINITY_0_SHIFT 0
+#define VGIC_AFFINITY_1_SHIFT 8
+#define VGIC_AFFINITY_2_SHIFT 16
+#define VGIC_AFFINITY_3_SHIFT 24
+
+#define MPIDR_TO_VGIC_LEVEL(mpidr, level) \
+	((((mpidr) >> MPIDR_LEVEL_SHIFT(level)) & MPIDR_LEVEL_MASK) << \
+	 VGIC_AFFINITY_## level ##_SHIFT)
+
+#define MPIDR_TO_VGIC(mpidr) \
+	((MPIDR_TO_VGIC_LEVEL(mpidr, 0) | \
+	 MPIDR_TO_VGIC_LEVEL(mpidr, 1) | \
+	 MPIDR_TO_VGIC_LEVEL(mpidr, 2) | \
+	 MPIDR_TO_VGIC_LEVEL(mpidr, 3)) << 32)
+
+static u32 vgic_rdist_read_reg(int gic_fd, struct kvm_vcpu *vcpu,
+			       unsigned long offset)
+{
+	u64 mpidr, attr;
+	u32 val;
+
+	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_MPIDR_EL1), &mpidr);
+
+	attr = MPIDR_TO_VGIC(mpidr) | offset;
+	kvm_device_attr_get(gic_fd, KVM_DEV_ARM_VGIC_GRP_REDIST_REGS,
+			    attr, &val);
+
+	return val;
+}
+
+static void vgic_rdist_write_reg(int gic_fd, struct kvm_vcpu *vcpu,
+				 unsigned long offset, u32 val)
+{
+	u64 mpidr, attr;
+
+	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_MPIDR_EL1), &mpidr);
+
+	attr = MPIDR_TO_VGIC(mpidr) | offset;
+	kvm_device_attr_set(gic_fd, KVM_DEV_ARM_VGIC_GRP_REDIST_REGS,
+			    attr, &val);
+}
+
+static void vgic_rdist_write_baser(int gic_fd, struct kvm_vcpu *vcpu,
+				   unsigned long offset, u64 val)
+{
+	u32 attr = val;
+
+	vgic_rdist_write_reg(gic_fd, vcpu, offset, attr);
+
+	attr = val >> 32;
+	vgic_rdist_write_reg(gic_fd, vcpu, offset + 4, attr);
+}
+
+void vgic_rdist_enable_lpis(int gic_fd, struct kvm_vcpu *vcpu,
+			    vm_paddr_t cfg_table, size_t cfg_table_size,
+			    vm_paddr_t pend_table)
+{
+	u32 ctlr;
+	u64 val;
+
+	val = (cfg_table |
+	       GICR_PROPBASER_InnerShareable |
+	       GICR_PROPBASER_RaWaWb |
+	       ((ilog2(cfg_table_size) - 1) & GICR_PROPBASER_IDBITS_MASK));
+	vgic_rdist_write_baser(gic_fd, vcpu, GICR_PROPBASER, val);
+
+	val = (pend_table |
+	       GICR_PENDBASER_InnerShareable |
+	       GICR_PENDBASER_RaWaWb);
+	vgic_rdist_write_baser(gic_fd, vcpu, GICR_PENDBASER, val);
+
+	ctlr = vgic_rdist_read_reg(gic_fd, vcpu, GICR_CTLR);
+	ctlr |= GICR_CTLR_ENABLE_LPIS;
+	vgic_rdist_write_reg(gic_fd, vcpu, GICR_CTLR, ctlr);
+}
+
 static u64 vgic_its_read_reg(int its_fd, unsigned long offset)
 {
 	u64 attr;
-- 
2.43.0.687.g38aa6559b0-goog


