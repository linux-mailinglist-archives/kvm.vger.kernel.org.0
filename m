Return-Path: <kvm+bounces-58325-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E6AEB8D0EC
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 22:40:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5543D7B23A4
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 20:38:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFB8C2DC79C;
	Sat, 20 Sep 2025 20:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="DXua6msX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD3692D9EFF
	for <kvm@vger.kernel.org>; Sat, 20 Sep 2025 20:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758400742; cv=none; b=IHYgBZJDEeUUY9HjZMDyiQ6rgSuHBN00qisHkobDt4ublBIRb0vOYqIkMir5tnw10UXmdG0mW9NsUqn/xx0pKdZqhZzoxYJ9Yw5/IR2JAvlvlNWtGya7QKG+8pIPtaa7eoVMu2Cf9efG6QScePlyAoGjDxfGrF1Vj/vmRDv89oM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758400742; c=relaxed/simple;
	bh=RjwhJA8A/oUnsQw6R1F22fcUWOTwb7V2Ws3LoFKq0Ow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FWLjlIhLZWxKVlpdt4NZ5L52FnrGr5wjSNOvGgS6IUpp5jIqaDQamUJClOFkxosTugxKKi39QgUL46AQqJmXE2Uk3fPR3fNaAAHFhVL4xm9rtWDU1nR7bK+APpRdq2RB0KytEjCrD5dW30ZNG+zEGXazG2ook1R7UXcZoP5gJZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=DXua6msX; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-4247d991161so13735405ab.3
        for <kvm@vger.kernel.org>; Sat, 20 Sep 2025 13:39:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1758400740; x=1759005540; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vxzb9rRxjqRKf5XO1kwZTSmIsN5S40FhHTnMmuG0nDs=;
        b=DXua6msXowCGpY1bF7qGX+gT68wKPHR4tyBMOiEL61LNCbw+l9UrpgGByrTbzjiyOu
         XH+cjdZpgG2UDoGGY+FixxtLKLLLVhJeNJVE76i/OxZ8/ZrW47SmoDowRzRcNDBF2Bs9
         nfvtZ8gD9XK08huO2uC2WFjtrKLMrXSTk00qlPvtv4zehq1a0rH/UNOgfwm7SJMJS9Mw
         Jqi2DxrIZUh7yHpYTyv1sNEEKtP1l/jjq/DfW/ZHyGitmQ2CJb2rCFadraVGq8mbHnFR
         MrSpltdx8/ZBrogSYSuj79tcF2hJeO58KzPkRmNKkp/meW+kqMx/rRP4oZHdoEg5/KfL
         Kqjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758400740; x=1759005540;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Vxzb9rRxjqRKf5XO1kwZTSmIsN5S40FhHTnMmuG0nDs=;
        b=llrY20MQAXhtu39hodFKpIP6GkQcoHG96i2ypA7fpaBOuA7a88lEzt4r0RUHf/mXsp
         4JRphh42aulAHP4cYZqkfKSMQMR94ipsGgL7i2Nd42CPU+RWs3/fizzbh35wo59CJZv9
         SJPTwLBcVwiAyAUfMrxWt/5zbrasjASJVyoycpI5c+cC0A+kxAAwL+WxaukNv3XY6D95
         1JNWviQtnTUYNpUR3lR96zycG0Z462ECqFFPIPx+we8KxlLBwhocEUIZn03NVRUj3RWp
         id3vEtLtEqczdfBjWjeswApvGyfuNNUy5TH2CLLM01lVKCV4N+MAQ/9B4R3pgWn7RdCo
         /BhA==
X-Forwarded-Encrypted: i=1; AJvYcCWyTLHShilH7I8PkIg7HuLNudIBvxF+jHy2Ckfg0xC3eAxz/TUF8spQsdhUeLMRc2Tlgtg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwRD/Q1MSE08GRL5JVehcMX6L7osUs2KmuXjtjeH2zLlzzP630l
	HFD4j4NbL7ccgbarGyVIQLnktuNNuSCMOe/CJVDwRPqjLr3ZZvP8FLpiLyxkmnZ8+Ys=
X-Gm-Gg: ASbGncurDOXiVvRYNRIQK7YswZi1j9Clkf/1Mj07ODULW0xvWolbIWDjjgnSGUWWGII
	rXWdYUu+Mmtqzx1SKo3lGlAt75t3tYRxU0h19I7ut0h+J/8eqH0vSehD6KrVzSs7qhigehOuzxN
	n+BQ4DTFab+PSMuDzKU27K8GKmZPORMYnDixz0i4U7vkMaCW6v7IaHQJ4AM0LCzNBoSAz6f5LXH
	NZMitnLYHiPADkL9Xr4K0BtQlvqRH7Jl2jlM2P1Fcwg9MHKN92NbnNtADMc2uaAzXu4ASup1YSW
	SnCl2XM56378M7VIHpNxQgB7BhYROSRYzc3iil8PLzWwYLOUaPaREOq7VBIiK3kyNPoR0k5LlMk
	Y6oLdfjnMYOKP2Ufto6ICwC8O
X-Google-Smtp-Source: AGHT+IGN7JA6HMHp4R5UIXrjGTEkZ7bM+GXI227vKH+W+fzVXTLep0v3OqRrD7H9gufAai1BV1o2GQ==
X-Received: by 2002:a5e:d50b:0:b0:893:2ff0:162c with SMTP id ca18e2360f4ac-8ade197b5efmr1011838239f.9.1758400739613;
        Sat, 20 Sep 2025 13:38:59 -0700 (PDT)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8a46ad38052sm296133939f.5.2025.09.20.13.38.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Sep 2025 13:38:59 -0700 (PDT)
From: Andrew Jones <ajones@ventanamicro.com>
To: iommu@lists.linux.dev,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: jgg@nvidia.com,
	zong.li@sifive.com,
	tjeznach@rivosinc.com,
	joro@8bytes.org,
	will@kernel.org,
	robin.murphy@arm.com,
	anup@brainfault.org,
	atish.patra@linux.dev,
	tglx@linutronix.de,
	alex.williamson@redhat.com,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	alex@ghiti.fr
Subject: [RFC PATCH v2 05/18] iommu/riscv: Prepare to use MSI table
Date: Sat, 20 Sep 2025 15:38:55 -0500
Message-ID: <20250920203851.2205115-25-ajones@ventanamicro.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250920203851.2205115-20-ajones@ventanamicro.com>
References: <20250920203851.2205115-20-ajones@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Capture the IMSIC layout from its config and reserve all the addresses.
Then use the IMSIC layout info to calculate the maximum number of PTEs
the MSI table needs to support and allocate the MSI table when attaching
a paging domain for the first time. Finally, at the same time, map the
IMSIC addresses in the stage1 DMA table when the stage1 DMA table is not
BARE. This ensures it doesn't fault as it will translate the addresses
before the MSI table does.

Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
---
 drivers/iommu/riscv/iommu-ir.c | 186 +++++++++++++++++++++++++++++++++
 drivers/iommu/riscv/iommu.c    |   6 ++
 drivers/iommu/riscv/iommu.h    |   4 +
 3 files changed, 196 insertions(+)

diff --git a/drivers/iommu/riscv/iommu-ir.c b/drivers/iommu/riscv/iommu-ir.c
index 08cf159b587d..bed104c5333c 100644
--- a/drivers/iommu/riscv/iommu-ir.c
+++ b/drivers/iommu/riscv/iommu-ir.c
@@ -4,11 +4,108 @@
  *
  * Copyright © 2025 Ventana Micro Systems Inc.
  */
+#include <linux/irqchip/riscv-imsic.h>
 #include <linux/irqdomain.h>
 #include <linux/msi.h>
+#include <linux/sizes.h>
 
+#include "../iommu-pages.h"
 #include "iommu.h"
 
+static size_t riscv_iommu_ir_group_size(struct riscv_iommu_domain *domain)
+{
+	phys_addr_t mask = domain->msi_addr_mask;
+
+	if (domain->group_index_bits) {
+		phys_addr_t group_mask = BIT(domain->group_index_bits) - 1;
+		phys_addr_t group_shift = domain->group_index_shift - 12;
+
+		mask &= ~(group_mask << group_shift);
+	}
+
+	return (mask + 1) << 12;
+}
+
+static int riscv_iommu_ir_map_unmap_imsics(struct riscv_iommu_domain *domain, bool map,
+					   gfp_t gfp, size_t *unmapped)
+{
+	phys_addr_t base = domain->msi_addr_pattern << 12, addr;
+	size_t stride = domain->imsic_stride, map_size = SZ_4K, size;
+	size_t i, j;
+
+	size = riscv_iommu_ir_group_size(domain);
+
+	if (stride == SZ_4K)
+		stride = map_size = size;
+
+	for (i = 0; i < BIT(domain->group_index_bits); i++) {
+		for (j = 0; j < size; j += stride) {
+			addr = (base + j) | (i << domain->group_index_shift);
+			if (map) {
+				int ret = iommu_map(&domain->domain, addr, addr, map_size,
+						    IOMMU_WRITE | IOMMU_NOEXEC | IOMMU_MMIO, gfp);
+				if (ret)
+					return ret;
+			} else {
+				*unmapped += iommu_unmap(&domain->domain, addr, map_size);
+			}
+		}
+	}
+
+	return 0;
+}
+
+static size_t riscv_iommu_ir_unmap_imsics(struct riscv_iommu_domain *domain)
+{
+	size_t unmapped = 0;
+
+	riscv_iommu_ir_map_unmap_imsics(domain, false, 0, &unmapped);
+
+	return unmapped;
+}
+
+static int riscv_iommu_ir_map_imsics(struct riscv_iommu_domain *domain, gfp_t gfp)
+{
+	int ret;
+
+	ret = riscv_iommu_ir_map_unmap_imsics(domain, true, gfp, NULL);
+	if (ret)
+		riscv_iommu_ir_unmap_imsics(domain);
+
+	return ret;
+}
+
+static size_t riscv_iommu_ir_compute_msipte_idx(struct riscv_iommu_domain *domain,
+						phys_addr_t msi_pa)
+{
+	phys_addr_t mask = domain->msi_addr_mask;
+	phys_addr_t addr = msi_pa >> 12;
+	size_t idx;
+
+	if (domain->group_index_bits) {
+		phys_addr_t group_mask = BIT(domain->group_index_bits) - 1;
+		phys_addr_t group_shift = domain->group_index_shift - 12;
+		phys_addr_t group = (addr >> group_shift) & group_mask;
+
+		mask &= ~(group_mask << group_shift);
+		idx = addr & mask;
+		idx |= group << fls64(mask);
+	} else {
+		idx = addr & mask;
+	}
+
+	return idx;
+}
+
+static size_t riscv_iommu_ir_nr_msiptes(struct riscv_iommu_domain *domain)
+{
+	phys_addr_t base = domain->msi_addr_pattern << 12;
+	phys_addr_t max_addr = base | (domain->msi_addr_mask << 12);
+	size_t max_idx = riscv_iommu_ir_compute_msipte_idx(domain, max_addr);
+
+	return max_idx + 1;
+}
+
 static struct irq_chip riscv_iommu_ir_irq_chip = {
 	.name			= "IOMMU-IR",
 	.irq_ack		= irq_chip_ack_parent,
@@ -90,25 +187,114 @@ struct irq_domain *riscv_iommu_ir_irq_domain_create(struct riscv_iommu_device *i
 	return irqdomain;
 }
 
+static void riscv_iommu_ir_free_msi_table(struct riscv_iommu_domain *domain)
+{
+	iommu_free_pages(domain->msi_root);
+}
+
 void riscv_iommu_ir_irq_domain_remove(struct riscv_iommu_info *info)
 {
+	struct riscv_iommu_domain *domain = info->domain;
 	struct fwnode_handle *fn;
 
 	if (!info->irqdomain)
 		return;
 
+	riscv_iommu_ir_free_msi_table(domain);
+
 	fn = info->irqdomain->fwnode;
 	irq_domain_remove(info->irqdomain);
 	info->irqdomain = NULL;
 	irq_domain_free_fwnode(fn);
 }
 
+static int riscv_ir_set_imsic_global_config(struct riscv_iommu_device *iommu,
+					    struct riscv_iommu_domain *domain)
+{
+	const struct imsic_global_config *imsic_global;
+	u64 mask = 0;
+
+	imsic_global = imsic_get_global_config();
+
+	mask |= (BIT(imsic_global->group_index_bits) - 1) << (imsic_global->group_index_shift - 12);
+	mask |= BIT(imsic_global->hart_index_bits + imsic_global->guest_index_bits) - 1;
+	domain->msi_addr_mask = mask;
+	domain->msi_addr_pattern = imsic_global->base_addr >> 12;
+	domain->group_index_bits = imsic_global->group_index_bits;
+	domain->group_index_shift = imsic_global->group_index_shift;
+	domain->imsic_stride = BIT(imsic_global->guest_index_bits + 12);
+
+	if (iommu->caps & RISCV_IOMMU_CAPABILITIES_MSI_FLAT) {
+		size_t nr_ptes = riscv_iommu_ir_nr_msiptes(domain);
+
+		domain->msi_root = iommu_alloc_pages_node_sz(domain->numa_node, GFP_KERNEL_ACCOUNT,
+							     nr_ptes * sizeof(*domain->msi_root));
+		if (!domain->msi_root)
+			return -ENOMEM;
+	}
+
+	return 0;
+}
+
 int riscv_iommu_ir_attach_paging_domain(struct riscv_iommu_domain *domain,
 					struct device *dev)
 {
+	struct riscv_iommu_device *iommu = dev_to_iommu(dev);
+	struct riscv_iommu_info *info = dev_iommu_priv_get(dev);
+	int ret;
+
+	if (!info->irqdomain)
+		return 0;
+
+	/*
+	 * Do the domain's one-time setup of the msi configuration the
+	 * first time the domain is attached and the msis are enabled.
+	 */
+	if (domain->msi_addr_mask == 0) {
+		ret = riscv_ir_set_imsic_global_config(iommu, domain);
+		if (ret)
+			return ret;
+
+		/*
+		 * The RISC-V IOMMU MSI table is checked after the stage1 DMA
+		 * page tables. If we don't create identity mappings in the
+		 * stage1 table then we'll fault and won't even get a chance
+		 * to check the MSI table.
+		 */
+		if (domain->pgd_mode) {
+			ret = riscv_iommu_ir_map_imsics(domain, GFP_KERNEL_ACCOUNT);
+			if (ret) {
+				riscv_iommu_ir_free_msi_table(domain);
+				return ret;
+			}
+		}
+	}
+
 	return 0;
 }
 
 void riscv_iommu_ir_free_paging_domain(struct riscv_iommu_domain *domain)
 {
+	riscv_iommu_ir_free_msi_table(domain);
+}
+
+void riscv_iommu_ir_get_resv_regions(struct device *dev, struct list_head *head)
+{
+	const struct imsic_global_config *imsic_global;
+	struct iommu_resv_region *reg;
+	phys_addr_t addr;
+	size_t size, i;
+
+	imsic_global = imsic_get_global_config();
+	if (!imsic_global || !imsic_global->nr_ids)
+		return;
+
+	size = BIT(imsic_global->hart_index_bits + imsic_global->guest_index_bits + 12);
+
+	for (i = 0; i < BIT(imsic_global->group_index_bits); i++) {
+		addr = imsic_global->base_addr | (i << imsic_global->group_index_shift);
+		reg = iommu_alloc_resv_region(addr, size, 0, IOMMU_RESV_MSI, GFP_KERNEL);
+		if (reg)
+			list_add_tail(&reg->list, head);
+	}
 }
diff --git a/drivers/iommu/riscv/iommu.c b/drivers/iommu/riscv/iommu.c
index db2acd9dc64b..0ba6504d4f33 100644
--- a/drivers/iommu/riscv/iommu.c
+++ b/drivers/iommu/riscv/iommu.c
@@ -1423,6 +1423,11 @@ static struct iommu_domain *riscv_iommu_alloc_paging_domain(struct device *dev)
 	return &domain->domain;
 }
 
+static void riscv_iommu_get_resv_regions(struct device *dev, struct list_head *head)
+{
+	riscv_iommu_ir_get_resv_regions(dev, head);
+}
+
 static int riscv_iommu_attach_blocking_domain(struct iommu_domain *iommu_domain,
 					      struct device *dev)
 {
@@ -1561,6 +1566,7 @@ static const struct iommu_ops riscv_iommu_ops = {
 	.blocked_domain = &riscv_iommu_blocking_domain,
 	.release_domain = &riscv_iommu_blocking_domain,
 	.domain_alloc_paging = riscv_iommu_alloc_paging_domain,
+	.get_resv_regions = riscv_iommu_get_resv_regions,
 	.device_group = riscv_iommu_device_group,
 	.probe_device = riscv_iommu_probe_device,
 	.release_device	= riscv_iommu_release_device,
diff --git a/drivers/iommu/riscv/iommu.h b/drivers/iommu/riscv/iommu.h
index 640d825f11b9..dc2020b81bbc 100644
--- a/drivers/iommu/riscv/iommu.h
+++ b/drivers/iommu/riscv/iommu.h
@@ -30,6 +30,9 @@ struct riscv_iommu_domain {
 	struct riscv_iommu_msipte *msi_root;
 	u64 msi_addr_mask;
 	u64 msi_addr_pattern;
+	u32 group_index_bits;
+	u32 group_index_shift;
+	size_t imsic_stride;
 };
 
 /* Private IOMMU data for managed devices, dev_iommu_priv_* */
@@ -97,6 +100,7 @@ void riscv_iommu_ir_irq_domain_remove(struct riscv_iommu_info *info);
 int riscv_iommu_ir_attach_paging_domain(struct riscv_iommu_domain *domain,
 					struct device *dev);
 void riscv_iommu_ir_free_paging_domain(struct riscv_iommu_domain *domain);
+void riscv_iommu_ir_get_resv_regions(struct device *dev, struct list_head *head);
 
 #define riscv_iommu_readl(iommu, addr) \
 	readl_relaxed((iommu)->reg + (addr))
-- 
2.49.0


