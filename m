Return-Path: <kvm+bounces-15571-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E6EE98AD58F
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 22:04:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 87A9A1F22297
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 20:04:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54113156F2A;
	Mon, 22 Apr 2024 20:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HSg8fXnc"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB063156C51
	for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 20:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713816166; cv=none; b=t1dHOGD3a1szNnSri4bDctFWWmJYeLxB3SfwPMijPgth6aNevZoGx3OMSAIqgfCwO8/rMdQE0ftNcaeJjPeM6LRiw/6P0kY6NlDYQQxOKQVOXx9MfdGFXzBJfDGqNf2pmjlj68ei/xB1ieyAP1pjrxGq7a/o+3nHfyeUmjYeuuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713816166; c=relaxed/simple;
	bh=wJZ7DW4qRQZS/6pM79B33QEZG+sA+diqf7yBczhVEC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FiQrrN8Qd/lli9xrJ8j2gArsrDZ8MyiUwXF+FEi1GkjnviUDCNrNDFWLPWD8dhx6vvKR0fHnsFeei5uXtNSYbfSnL9fUPJDunpyAC9DeN9Xq+Y15bhKPQ90xra9sFx4VS6uAihsAboiE//fNluSh/9rEU9ePolygGTkZ1Prjtfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HSg8fXnc; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713816163;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Nhnp3uWaD4aJFeFGI/XmtL06tlTKY/BOmAF29V3Wh+w=;
	b=HSg8fXncJc6u7cZfMBcCUAu/upwkMuQ4ffikTAu3fBZuHzZ3bhU5DUzI0M9eJyZ6gFCepw
	/WWaUvub0EXcDr3psDKiOoFt4ZC6HHW4ijelsp/CB0K0T+N/DPheVNYgEAzYd9MQpXmLPf
	Mo7ODygdm6GWwc3BxS1Bv0dMtJvz820=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	kvm@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 17/19] KVM: selftests: Add helper for enabling LPIs on a redistributor
Date: Mon, 22 Apr 2024 20:01:56 +0000
Message-ID: <20240422200158.2606761-18-oliver.upton@linux.dev>
In-Reply-To: <20240422200158.2606761-1-oliver.upton@linux.dev>
References: <20240422200158.2606761-1-oliver.upton@linux.dev>
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
 .../selftests/kvm/include/aarch64/gic.h       |  3 +++
 .../selftests/kvm/lib/aarch64/gic_v3.c        | 24 +++++++++++++++++++
 .../testing/selftests/kvm/lib/aarch64/vgic.c  |  2 ++
 3 files changed, 29 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/aarch64/gic.h b/tools/testing/selftests/kvm/include/aarch64/gic.h
index 6d03188435e4..baeb3c859389 100644
--- a/tools/testing/selftests/kvm/include/aarch64/gic.h
+++ b/tools/testing/selftests/kvm/include/aarch64/gic.h
@@ -58,4 +58,7 @@ void gic_irq_clear_pending(unsigned int intid);
 bool gic_irq_get_pending(unsigned int intid);
 void gic_irq_set_config(unsigned int intid, bool is_edge);
 
+void gic_rdist_enable_lpis(vm_paddr_t cfg_table, size_t cfg_table_size,
+			   vm_paddr_t pend_table);
+
 #endif /* SELFTEST_KVM_GIC_H */
diff --git a/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c b/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
index 515335179045..66d05506f78b 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
@@ -401,3 +401,27 @@ const struct gic_common_ops gicv3_ops = {
 	.gic_irq_get_pending = gicv3_irq_get_pending,
 	.gic_irq_set_config = gicv3_irq_set_config,
 };
+
+void gic_rdist_enable_lpis(vm_paddr_t cfg_table, size_t cfg_table_size,
+			   vm_paddr_t pend_table)
+{
+	volatile void *rdist_base = gicr_base_cpu(guest_get_vcpuid());
+
+	u32 ctlr;
+	u64 val;
+
+	val = (cfg_table |
+	       GICR_PROPBASER_InnerShareable |
+	       GICR_PROPBASER_RaWaWb |
+	       ((ilog2(cfg_table_size) - 1) & GICR_PROPBASER_IDBITS_MASK));
+	writeq_relaxed(val, rdist_base + GICR_PROPBASER);
+
+	val = (pend_table |
+	       GICR_PENDBASER_InnerShareable |
+	       GICR_PENDBASER_RaWaWb);
+	writeq_relaxed(val, rdist_base + GICR_PENDBASER);
+
+	ctlr = readl_relaxed(rdist_base + GICR_CTLR);
+	ctlr |= GICR_CTLR_ENABLE_LPIS;
+	writel_relaxed(ctlr, rdist_base + GICR_CTLR);
+}
diff --git a/tools/testing/selftests/kvm/lib/aarch64/vgic.c b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
index 5e8f0d5382c2..4427f43f73ea 100644
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
 
-- 
2.44.0.769.g3c40516874-goog


