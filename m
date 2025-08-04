Return-Path: <kvm+bounces-53899-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D7E09B19FDD
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 12:43:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 911F33B2901
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 10:43:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C06124CEEA;
	Mon,  4 Aug 2025 10:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="OQAgZ7zB"
X-Original-To: kvm@vger.kernel.org
Received: from fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com [52.28.197.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5985B248F6F
	for <kvm@vger.kernel.org>; Mon,  4 Aug 2025 10:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.28.197.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754304185; cv=none; b=UZ156QfDhObVLZemCRkJbQkcNo9BlH7tFI8f/j65O/m+YgNXpsZg5YChGVz8fIDuigjVq4xfuNWCkm9KiSRcymuPAt0o9tzgbOiXLpUc4mw6tsOuA0foSoknXqS579bsMWFfgD3PLqkfCRyQ/5+osiURyFoEIrUOZg8tqXHGmLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754304185; c=relaxed/simple;
	bh=BnLnAvEwvYp4PK7mzhh0NnQL4p4T7IS66WIr3EDJzh4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fysoj8Afv8dVZ5WzKXjgi/H8pMLWODpbAZfe1JDLBE6AFbIZ8YW44t2MUFkUuGVR/S/Z+myK53Giagfec2fD03zSH1gqhUUxmecAYmd/6PdE/G3+/n3OW05of5DgrOV/xNVfCr5ZpEKDzoxYZO1Nq+G/uHAq5DlG/T72L0WMfDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=OQAgZ7zB; arc=none smtp.client-ip=52.28.197.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1754304183; x=1785840183;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=d8jQxMMkVLI7pHdsjGlVFTNihflHdlKkMQeNNCSgyJg=;
  b=OQAgZ7zBP+S93Z/ElwwsMoMMeN/Ic6v8PaQIMRzeh+Ccu0eQGFtGwucb
   2/G1NDU5l46nuafdOy+KMs5vgrMmbmLH22kLGqpCqkKoFP6S9GUmlD9rM
   4c40uC5jS1OkkQkWs0LjE9fyS/ZKt8zaK+mMnOLxfRtYhRIabvAp3zXj0
   Yc5HRvJlLgNSNOG58zuznJ9b9rrusJhjE+JbjuIuILlmN82VQbUXb3cty
   Eiir9qZ1x29gU2qR2Wpg6BUnb/5EUmH8iNKGasaZYlOK10mNyb1PlPcb6
   OKghT7ceKmF/rFfH29r8cVifEqx3VERPkJb/IadvgpBZ+dBUXWmBlT/QC
   w==;
X-CSE-ConnectionGUID: g2mcfmN0TOy/XH7L8/NnqQ==
X-CSE-MsgGUID: CK24HuzISqyuA4pEV5q8CA==
X-IronPort-AV: E=Sophos;i="6.17,258,1747699200"; 
   d="scan'208";a="423403"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-west-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2025 10:42:53 +0000
Received: from EX19MTAEUB002.ant.amazon.com [10.0.43.254:14543]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.9.131:2525] with esmtp (Farcaster)
 id 75b28210-16d2-48cd-8d3c-ca145c83854e; Mon, 4 Aug 2025 10:42:52 +0000 (UTC)
X-Farcaster-Flow-ID: 75b28210-16d2-48cd-8d3c-ca145c83854e
Received: from EX19D039EUC004.ant.amazon.com (10.252.61.190) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Mon, 4 Aug 2025 10:42:48 +0000
Received: from dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com
 (10.253.107.175) by EX19D039EUC004.ant.amazon.com (10.252.61.190) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14; Mon, 4 Aug 2025
 10:42:45 +0000
From: Mahmoud Adam <mngyadam@amazon.de>
To: <kvm@vger.kernel.org>
CC: <alex.williamson@redhat.com>, <jgg@ziepe.ca>, <benh@kernel.crashing.org>,
	David Woodhouse <dwmw@amazon.co.uk>, <pravkmr@amazon.de>,
	<nagy@khwaternagy.com>
Subject: [RFC PATCH 5/9] vfio-pci-core: add vfio_pci_mmap & helpers
Date: Mon, 4 Aug 2025 12:39:58 +0200
Message-ID: <20250804104012.87915-6-mngyadam@amazon.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250804104012.87915-1-mngyadam@amazon.de>
References: <20250804104012.87915-1-mngyadam@amazon.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D040UWB001.ant.amazon.com (10.13.138.82) To
 EX19D039EUC004.ant.amazon.com (10.252.61.190)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

support the new vmmap solution to vfio-pci-core, this adds the
vfio_pci_mmap struct. the core already keeps the offset and size of
the region, extend it with bar_index.
Add alloc helper funciton for vfio_pci, which allocates and insert
vmmap to the mt, for the transitioning period the mtree_insert_range
is used with the same offset calculation as the legacy solution, so
that we don't break VFIO_PCI_OFFSET_TO_INDEX usages, eventually after
all the vfio_pci_devices are migrated to the new ops, these macros
will be replaced with mtree_load or similar, then maple tree
allocation could be used instead of direct insertions.

Signed-off-by: Mahmoud Adam <mngyadam@amazon.de>
---
 drivers/vfio/pci/vfio_pci_core.c | 44 ++++++++++++++++++++++++++++++++
 include/linux/vfio_pci_core.h    | 10 ++++++++
 2 files changed, 54 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 467466a0b619f..7a431a03bd850 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -882,6 +882,50 @@ static int msix_mmappable_cap(struct vfio_pci_core_device *vdev,
 	return vfio_info_add_capability(caps, &header, sizeof(header));
 }
 
+static void vfio_pci_mmap_free(struct vfio_mmap *core_vmmap)
+{
+	struct vfio_pci_mmap *vmmap = container_of(core_vmmap,
+						   struct vfio_pci_mmap,
+						   core);
+	kfree(vmmap);
+}
+
+static struct vfio_mmap_ops vfio_pci_mmap_ops = {
+	.free = vfio_pci_mmap_free,
+};
+
+int vfio_pci_mmap_alloc(struct vfio_pci_core_device *vdev,
+			struct maple_tree *mmap_mt, u32 region_flags,
+			size_t bar_size, unsigned int bar_index,
+			unsigned long *offset)
+{
+	struct vfio_pci_mmap *vmmap;
+	int ret;
+	unsigned long alloc_size;
+	vmmap = kzalloc(sizeof(*vmmap), GFP_KERNEL);
+	if (!vmmap)
+		return -ENOMEM;
+
+	alloc_size = PAGE_ALIGN(bar_size);
+	/* keep the offset aligned to the current usage for now, so we
+	 * don't break VFIO_PCI_OFFSET_TO_INDEX */
+	*offset = VFIO_PCI_INDEX_TO_OFFSET(bar_index);
+	vmmap->bar_index = bar_index;
+	vfio_mmap_init(&vdev->vdev, &vmmap->core, region_flags,
+		       *offset, alloc_size, &vfio_pci_mmap_ops);
+	ret = mtree_insert_range(mmap_mt, *offset,
+				 *offset + alloc_size - 1,
+				 &vmmap->core, GFP_KERNEL);
+	if (ret) {
+		vfio_mmap_free(&vmmap->core);
+		/* for now if it exists reuse it */
+		if (ret != -EEXIST)
+			return ret;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(vfio_pci_mmap_alloc);
+
 int vfio_pci_core_register_dev_region(struct vfio_pci_core_device *vdev,
 				      unsigned int type, unsigned int subtype,
 				      const struct vfio_pci_regops *ops,
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index fbb472dd99b36..532d2914a9c2e 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -49,6 +49,11 @@ struct vfio_pci_region {
 	u32				flags;
 };
 
+struct vfio_pci_mmap {
+	struct vfio_mmap	core;
+	unsigned int		bar_index;
+};
+
 struct vfio_pci_core_device {
 	struct vfio_device	vdev;
 	struct pci_dev		*pdev;
@@ -137,6 +142,11 @@ bool vfio_pci_core_range_intersect_range(loff_t buf_start, size_t buf_cnt,
 					 loff_t *buf_offset,
 					 size_t *intersect_count,
 					 size_t *register_offset);
+int vfio_pci_mmap_alloc(struct vfio_pci_core_device *vdev,
+			struct maple_tree *mmap_mt, u32 region_flags,
+			size_t bar_size, unsigned int bar_index,
+			unsigned long *offset);
+
 #define VFIO_IOWRITE_DECLARATION(size) \
 int vfio_pci_core_iowrite##size(struct vfio_pci_core_device *vdev,	\
 			bool test_mem, u##size val, void __iomem *io);
-- 
2.47.3




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


