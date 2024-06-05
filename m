Return-Path: <kvm+bounces-18871-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 161B68FC7ED
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 11:35:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B32EA284DF4
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 09:35:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7CF1190053;
	Wed,  5 Jun 2024 09:31:08 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 170BE190052;
	Wed,  5 Jun 2024 09:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717579868; cv=none; b=Tx4dlYuUq4sQTQSgJtJW4OaY6N7EmepTM6duQuAqz/oSQG9kgmgk6vvno25Qe96aVWuWKT6T/+RXP4Uh9XxcDVXq0IpG6Z8rQPOvytiKOGGwiJ4YAZ6mSa952NbafTay3h1rmvXCAKxoqguAYF7j5PsRzcQylgkgosG4mWdnXDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717579868; c=relaxed/simple;
	bh=9kWGTEKXneZnvfZ4TpSJHiRlPWbr7/apufT1KheiKbE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LUZ/LcpKiiQaiqVLxIXWMwoJEQhDRNHLRmBSvIbo05l8jWKmOfuwnPcPY039MaAL7zkmpeHH11bESgj08hdtNpdoNlI61M9sADoB++WvplK37f+vWGaFZDngPEqaEFRrJ1mLxuHOgiJkd/cPkc27PbY2q2bflBfnFnBSHoQzp/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 29106FEC;
	Wed,  5 Jun 2024 02:31:30 -0700 (PDT)
Received: from e122027.arm.com (unknown [10.57.39.129])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8AF8E3F792;
	Wed,  5 Jun 2024 02:31:02 -0700 (PDT)
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: [PATCH v3 12/14] arm64: realm: Support nonsecure ITS emulation shared
Date: Wed,  5 Jun 2024 10:30:04 +0100
Message-Id: <20240605093006.145492-13-steven.price@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240605093006.145492-1-steven.price@arm.com>
References: <20240605093006.145492-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Within a realm guest the ITS is emulated by the host. This means the
allocations must have been made available to the host by a call to
set_memory_decrypted(). Introduce an allocation function which performs
this extra call.

Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
Changes since v2:
 * Drop 'shared' from the new its_xxx function names as they are used
   for non-realm guests too.
 * Don't handle the NUMA_NO_NODE case specially - alloc_pages_node()
   should do the right thing.
 * Drop a pointless (void *) cast.
---
 drivers/irqchip/irq-gic-v3-its.c | 90 ++++++++++++++++++++++++--------
 1 file changed, 67 insertions(+), 23 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 40ebf1726393..ca72f830f4cc 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -18,6 +18,7 @@
 #include <linux/irqdomain.h>
 #include <linux/list.h>
 #include <linux/log2.h>
+#include <linux/mem_encrypt.h>
 #include <linux/memblock.h>
 #include <linux/mm.h>
 #include <linux/msi.h>
@@ -27,6 +28,7 @@
 #include <linux/of_pci.h>
 #include <linux/of_platform.h>
 #include <linux/percpu.h>
+#include <linux/set_memory.h>
 #include <linux/slab.h>
 #include <linux/syscore_ops.h>
 
@@ -163,6 +165,7 @@ struct its_device {
 	struct its_node		*its;
 	struct event_lpi_map	event_map;
 	void			*itt;
+	u32			itt_order;
 	u32			nr_ites;
 	u32			device_id;
 	bool			shared;
@@ -198,6 +201,30 @@ static DEFINE_IDA(its_vpeid_ida);
 #define gic_data_rdist_rd_base()	(gic_data_rdist()->rd_base)
 #define gic_data_rdist_vlpi_base()	(gic_data_rdist_rd_base() + SZ_128K)
 
+static struct page *its_alloc_pages_node(int node, gfp_t gfp,
+					 unsigned int order)
+{
+	struct page *page;
+
+	page = alloc_pages_node(node, gfp, order);
+
+	if (page)
+		set_memory_decrypted((unsigned long)page_address(page),
+				     1 << order);
+	return page;
+}
+
+static struct page *its_alloc_pages(gfp_t gfp, unsigned int order)
+{
+	return its_alloc_pages_node(NUMA_NO_NODE, gfp, order);
+}
+
+static void its_free_pages(void *addr, unsigned int order)
+{
+	set_memory_encrypted((unsigned long)addr, 1 << order);
+	free_pages((unsigned long)addr, order);
+}
+
 /*
  * Skip ITSs that have no vLPIs mapped, unless we're on GICv4.1, as we
  * always have vSGIs mapped.
@@ -2212,7 +2239,8 @@ static struct page *its_allocate_prop_table(gfp_t gfp_flags)
 {
 	struct page *prop_page;
 
-	prop_page = alloc_pages(gfp_flags, get_order(LPI_PROPBASE_SZ));
+	prop_page = its_alloc_pages(gfp_flags,
+				    get_order(LPI_PROPBASE_SZ));
 	if (!prop_page)
 		return NULL;
 
@@ -2223,8 +2251,8 @@ static struct page *its_allocate_prop_table(gfp_t gfp_flags)
 
 static void its_free_prop_table(struct page *prop_page)
 {
-	free_pages((unsigned long)page_address(prop_page),
-		   get_order(LPI_PROPBASE_SZ));
+	its_free_pages(page_address(prop_page),
+		       get_order(LPI_PROPBASE_SZ));
 }
 
 static bool gic_check_reserved_range(phys_addr_t addr, unsigned long size)
@@ -2346,7 +2374,8 @@ static int its_setup_baser(struct its_node *its, struct its_baser *baser,
 		order = get_order(GITS_BASER_PAGES_MAX * psz);
 	}
 
-	page = alloc_pages_node(its->numa_node, GFP_KERNEL | __GFP_ZERO, order);
+	page = its_alloc_pages_node(its->numa_node,
+				    GFP_KERNEL | __GFP_ZERO, order);
 	if (!page)
 		return -ENOMEM;
 
@@ -2359,7 +2388,7 @@ static int its_setup_baser(struct its_node *its, struct its_baser *baser,
 		/* 52bit PA is supported only when PageSize=64K */
 		if (psz != SZ_64K) {
 			pr_err("ITS: no 52bit PA support when psz=%d\n", psz);
-			free_pages((unsigned long)base, order);
+			its_free_pages(base, order);
 			return -ENXIO;
 		}
 
@@ -2415,7 +2444,7 @@ static int its_setup_baser(struct its_node *its, struct its_baser *baser,
 		pr_err("ITS@%pa: %s doesn't stick: %llx %llx\n",
 		       &its->phys_base, its_base_type_string[type],
 		       val, tmp);
-		free_pages((unsigned long)base, order);
+		its_free_pages(base, order);
 		return -ENXIO;
 	}
 
@@ -2554,8 +2583,8 @@ static void its_free_tables(struct its_node *its)
 
 	for (i = 0; i < GITS_BASER_NR_REGS; i++) {
 		if (its->tables[i].base) {
-			free_pages((unsigned long)its->tables[i].base,
-				   its->tables[i].order);
+			its_free_pages(its->tables[i].base,
+				       its->tables[i].order);
 			its->tables[i].base = NULL;
 		}
 	}
@@ -2821,7 +2850,8 @@ static bool allocate_vpe_l2_table(int cpu, u32 id)
 
 	/* Allocate memory for 2nd level table */
 	if (!table[idx]) {
-		page = alloc_pages(GFP_KERNEL | __GFP_ZERO, get_order(psz));
+		page = its_alloc_pages(GFP_KERNEL | __GFP_ZERO,
+				       get_order(psz));
 		if (!page)
 			return false;
 
@@ -2940,7 +2970,8 @@ static int allocate_vpe_l1_table(void)
 
 	pr_debug("np = %d, npg = %lld, psz = %d, epp = %d, esz = %d\n",
 		 np, npg, psz, epp, esz);
-	page = alloc_pages(GFP_ATOMIC | __GFP_ZERO, get_order(np * PAGE_SIZE));
+	page = its_alloc_pages(GFP_ATOMIC | __GFP_ZERO,
+			       get_order(np * PAGE_SIZE));
 	if (!page)
 		return -ENOMEM;
 
@@ -2986,8 +3017,8 @@ static struct page *its_allocate_pending_table(gfp_t gfp_flags)
 {
 	struct page *pend_page;
 
-	pend_page = alloc_pages(gfp_flags | __GFP_ZERO,
-				get_order(LPI_PENDBASE_SZ));
+	pend_page = its_alloc_pages(gfp_flags | __GFP_ZERO,
+				    get_order(LPI_PENDBASE_SZ));
 	if (!pend_page)
 		return NULL;
 
@@ -2999,7 +3030,7 @@ static struct page *its_allocate_pending_table(gfp_t gfp_flags)
 
 static void its_free_pending_table(struct page *pt)
 {
-	free_pages((unsigned long)page_address(pt), get_order(LPI_PENDBASE_SZ));
+	its_free_pages(page_address(pt), get_order(LPI_PENDBASE_SZ));
 }
 
 /*
@@ -3334,8 +3365,9 @@ static bool its_alloc_table_entry(struct its_node *its,
 
 	/* Allocate memory for 2nd level table */
 	if (!table[idx]) {
-		page = alloc_pages_node(its->numa_node, GFP_KERNEL | __GFP_ZERO,
-					get_order(baser->psz));
+		page = its_alloc_pages_node(its->numa_node,
+					    GFP_KERNEL | __GFP_ZERO,
+					    get_order(baser->psz));
 		if (!page)
 			return false;
 
@@ -3418,7 +3450,9 @@ static struct its_device *its_create_device(struct its_node *its, u32 dev_id,
 	unsigned long *lpi_map = NULL;
 	unsigned long flags;
 	u16 *col_map = NULL;
+	struct page *page;
 	void *itt;
+	int itt_order;
 	int lpi_base;
 	int nr_lpis;
 	int nr_ites;
@@ -3430,7 +3464,6 @@ static struct its_device *its_create_device(struct its_node *its, u32 dev_id,
 	if (WARN_ON(!is_power_of_2(nvecs)))
 		nvecs = roundup_pow_of_two(nvecs);
 
-	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
 	/*
 	 * Even if the device wants a single LPI, the ITT must be
 	 * sized as a power of two (and you need at least one bit...).
@@ -3438,7 +3471,16 @@ static struct its_device *its_create_device(struct its_node *its, u32 dev_id,
 	nr_ites = max(2, nvecs);
 	sz = nr_ites * (FIELD_GET(GITS_TYPER_ITT_ENTRY_SIZE, its->typer) + 1);
 	sz = max(sz, ITS_ITT_ALIGN) + ITS_ITT_ALIGN - 1;
-	itt = kzalloc_node(sz, GFP_KERNEL, its->numa_node);
+	itt_order = get_order(sz);
+	page = its_alloc_pages_node(its->numa_node,
+				    GFP_KERNEL | __GFP_ZERO,
+				    itt_order);
+	if (!page)
+		return NULL;
+	itt = page_address(page);
+
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+
 	if (alloc_lpis) {
 		lpi_map = its_lpi_alloc(nvecs, &lpi_base, &nr_lpis);
 		if (lpi_map)
@@ -3450,9 +3492,9 @@ static struct its_device *its_create_device(struct its_node *its, u32 dev_id,
 		lpi_base = 0;
 	}
 
-	if (!dev || !itt ||  !col_map || (!lpi_map && alloc_lpis)) {
+	if (!dev || !col_map || (!lpi_map && alloc_lpis)) {
 		kfree(dev);
-		kfree(itt);
+		its_free_pages(itt, itt_order);
 		bitmap_free(lpi_map);
 		kfree(col_map);
 		return NULL;
@@ -3462,6 +3504,7 @@ static struct its_device *its_create_device(struct its_node *its, u32 dev_id,
 
 	dev->its = its;
 	dev->itt = itt;
+	dev->itt_order = itt_order;
 	dev->nr_ites = nr_ites;
 	dev->event_map.lpi_map = lpi_map;
 	dev->event_map.col_map = col_map;
@@ -3489,7 +3532,7 @@ static void its_free_device(struct its_device *its_dev)
 	list_del(&its_dev->entry);
 	raw_spin_unlock_irqrestore(&its_dev->its->lock, flags);
 	kfree(its_dev->event_map.col_map);
-	kfree(its_dev->itt);
+	its_free_pages(its_dev->itt, its_dev->itt_order);
 	kfree(its_dev);
 }
 
@@ -5131,8 +5174,9 @@ static int __init its_probe_one(struct its_node *its)
 		}
 	}
 
-	page = alloc_pages_node(its->numa_node, GFP_KERNEL | __GFP_ZERO,
-				get_order(ITS_CMD_QUEUE_SZ));
+	page = its_alloc_pages_node(its->numa_node,
+				    GFP_KERNEL | __GFP_ZERO,
+				    get_order(ITS_CMD_QUEUE_SZ));
 	if (!page) {
 		err = -ENOMEM;
 		goto out_unmap_sgir;
@@ -5196,7 +5240,7 @@ static int __init its_probe_one(struct its_node *its)
 out_free_tables:
 	its_free_tables(its);
 out_free_cmd:
-	free_pages((unsigned long)its->cmd_base, get_order(ITS_CMD_QUEUE_SZ));
+	its_free_pages(its->cmd_base, get_order(ITS_CMD_QUEUE_SZ));
 out_unmap_sgir:
 	if (its->sgir_base)
 		iounmap(its->sgir_base);
-- 
2.34.1


