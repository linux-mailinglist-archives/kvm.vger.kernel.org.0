Return-Path: <kvm+bounces-54365-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 96137B1FF0A
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 08:12:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 73B2F189BA03
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 06:12:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93BFE2D8767;
	Mon, 11 Aug 2025 06:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="jrItEsXE"
X-Original-To: kvm@vger.kernel.org
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC5A2D63E5;
	Mon, 11 Aug 2025 06:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754892684; cv=none; b=BVoy7K+cbgSB6AmPlz6uZVoak2QwKT8H+9cSpfgM16CuDsdaykpa86EGGNVxiSry4Lnek2e5DuPKXlj5hdOebag0fp4xuzl83PJEHjsrhupqDed0CQkwfCHTQnKynoDxqpMIBdT1uUggHI6paoYr3JfqcJz0/dTvGE56fmFU4Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754892684; c=relaxed/simple;
	bh=x/6H8FCpaM1P1l+m7yJ/++snzFBZ4yex37yrKVs51rU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CmsPrVTkyCTbby3qs9TwFcL8TAEBxSw+Hz4HFAqKLgLrhMVMp6xs4VlHt3BxryuJVDveZPzoCuFCUWCLD4M4f1SaPWzyDA9ZxkZJLxcNLoeTOSPtnpgyIyjRaKdznOcZXfUHrLYI3jSQ1OqkMDXPAcf/jKLroi+fJRP99kbm7tI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=jrItEsXE; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1754892679; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=XDEJbKTMYToe/P3nkdkZb7Pdk39snYZKhujzTlABfAU=;
	b=jrItEsXEeshys8x7mIsACjcmCpUNC0rrwtNOXCei2hBNjtRZhCtStzqqjGN0Emb1DepMQUs3izVuAbZS126aIDL7FT62MRQkPkjSTKW4/KMl8LEuQo6ghPjvYoCMtIqnjLq8lj9BlttkR/QypoRqxAiot01CmE4pB3MDFDalh2k=
Received: from localhost.localdomain(mailfrom:fangyu.yu@linux.alibaba.com fp:SMTPD_---0WlP-vAn_1754892676 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 11 Aug 2025 14:11:17 +0800
From: fangyu.yu@linux.alibaba.com
To: anup@brainfault.org,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	atishp@atishpatra.org,
	tjeznach@rivosinc.com,
	joro@8bytes.org,
	will@kernel.org,
	robin.murphy@arm.com,
	sunilvl@ventanamicro.com,
	rafael.j.wysocki@intel.com,
	tglx@linutronix.de,
	ajones@ventanamicro.com
Cc: guoren@linux.alibaba.com,
	guoren@kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	iommu@lists.linux.dev,
	Fangyu Yu <fangyu.yu@linux.alibaba.com>
Subject: [RFC PATCH 5/6] iommu/riscv: Add MRIF mode support
Date: Mon, 11 Aug 2025 14:11:03 +0800
Message-Id: <20250811061104.10326-6-fangyu.yu@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20250811061104.10326-1-fangyu.yu@linux.alibaba.com>
References: <20250811061104.10326-1-fangyu.yu@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fangyu Yu <fangyu.yu@linux.alibaba.com>

If the guest interrupt files are exhausted and the MRIF is supported
we configure the MSI PTE with MRIF mode,  and set  the  NPPN and NID
using notice MSI from host irq.

Otherwise, we redirect the guest interrupt back to the original host
irq and inject the interrupt into the guest machine through irqfd.

Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
---
 drivers/iommu/riscv/iommu-bits.h |  6 ++++++
 drivers/iommu/riscv/iommu-ir.c   | 35 +++++++++++++++++++++++++++++---
 2 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/riscv/iommu-bits.h b/drivers/iommu/riscv/iommu-bits.h
index d3d98dbed709..3af6436d5c5c 100644
--- a/drivers/iommu/riscv/iommu-bits.h
+++ b/drivers/iommu/riscv/iommu-bits.h
@@ -39,6 +39,12 @@
 /* RISC-V IOMMU PPN <> PHYS address conversions, PHYS <=> PPN[53:10] */
 #define riscv_iommu_phys_to_ppn(pa)	(((pa) >> 2) & (((1ULL << 44) - 1) << 10))
 #define riscv_iommu_ppn_to_phys(pn)	(((pn) << 2) & (((1ULL << 44) - 1) << 12))
+/* RISC-V IOMMU MRIF Address <> PHYS address conversions, PHYS <=> MRIF[53:7] */
+#define riscv_iommu_phys_to_mrif(pa)	(((pa) >> 2) & (((1ULL << 47) - 1) << 7))
+/* RISC-V IOMMU nppn <> PHYS address conversions, PHYS <=> nppn[53:10] */
+#define riscv_iommu_phys_to_nppn(pa)	(((pa) >> 2) & (((1ULL << 44) - 1) << 10))
+#define riscv_iommu_data_to_nid(data)   \
+		((((data) & 0x3FFULL)) | (((((data) >> 10) & 1ULL)) << 60))
 
 /* 5.3 IOMMU Capabilities (64bits) */
 #define RISCV_IOMMU_REG_CAPABILITIES		0x0000
diff --git a/drivers/iommu/riscv/iommu-ir.c b/drivers/iommu/riscv/iommu-ir.c
index 73f552ed5b65..f3ebf62de53e 100644
--- a/drivers/iommu/riscv/iommu-ir.c
+++ b/drivers/iommu/riscv/iommu-ir.c
@@ -150,9 +150,12 @@ static int riscv_iommu_irq_set_vcpu_affinity(struct irq_data *data, void *info)
 {
 	struct riscv_iommu_vcpu_info *vcpu_info = info;
 	struct riscv_iommu_domain *domain = data->domain->host_data;
+	struct device *dev = msi_desc_to_dev(irq_data_get_msi_desc(data));
+	struct riscv_iommu_device *iommu = dev_to_iommu(dev);
 	struct riscv_iommu_msipte *pte;
 	int ret = -EINVAL;
-	u64 pteval;
+	u64 pteval, mrifval = 0;
+	bool mrif_support = (iommu->caps & RISCV_IOMMU_CAPABILITIES_MSI_MRIF);
 
 	if (WARN_ON(domain->domain.type != IOMMU_DOMAIN_UNMANAGED))
 		return ret;
@@ -186,12 +189,38 @@ static int riscv_iommu_irq_set_vcpu_affinity(struct irq_data *data, void *info)
 	if (!pte)
 		goto out_unlock;
 
-	pteval = FIELD_PREP(RISCV_IOMMU_MSIPTE_M, 3) |
-		 riscv_iommu_phys_to_ppn(vcpu_info->hpa) |
+	if (!vcpu_info->mrif) {
+		pteval = FIELD_PREP(RISCV_IOMMU_MSIPTE_M, 3) |
+			 riscv_iommu_phys_to_ppn(vcpu_info->hpa) |
+			 FIELD_PREP(RISCV_IOMMU_MSIPTE_V, 1);
+		goto update_pte;
+	}
+
+	pteval = FIELD_PREP(RISCV_IOMMU_MSIPTE_M, 1) |
+		 riscv_iommu_phys_to_mrif(vcpu_info->hpa) |
 		 FIELD_PREP(RISCV_IOMMU_MSIPTE_V, 1);
+	if (mrif_support) {
+		mrifval = riscv_iommu_data_to_nid(vcpu_info->host_msg->data) |
+				riscv_iommu_phys_to_nppn(
+				(u64)vcpu_info->host_msg->address_hi << 32 |
+				vcpu_info->host_msg->address_lo);
+	} else {
+		/* If the guest interrupt file is exhausted and MRIF is not supported, we
+		 * redirect the guest interrupt back to the original host interrupt and
+		 * inject the interrupt into the guest machine through irqfd.
+		 */
+		struct irq_data *irqdata = irq_get_irq_data(vcpu_info->host_irq);
+
+		irq_data_get_irq_chip(irqdata)->irq_write_msi_msg(irqdata,
+						vcpu_info->host_msg);
+		ret = -ENODEV;
+		goto out_unlock;
+	}
 
+update_pte:
 	if (pte->pte != pteval) {
 		pte->pte = pteval;
+		pte->mrif_info = mrifval;
 		riscv_iommu_ir_msitbl_inval(domain, pte);
 	}
 
-- 
2.49.0


