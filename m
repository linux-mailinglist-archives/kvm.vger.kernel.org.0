Return-Path: <kvm+bounces-26992-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AE11B97A05C
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 13:36:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3373B1F20631
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 11:36:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3158715531B;
	Mon, 16 Sep 2024 11:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="LMPKFVZu"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0905D153824;
	Mon, 16 Sep 2024 11:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.171.184.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726486551; cv=none; b=phvv5DWLoNBclXCcvpj2cFrQez77BCrupEA+szhfvm2HlotqRv81mRJuQr6klH3Obv9N5Cy4zwoa+aJmum6t51Z4hPLpeMsMCdYMcNPu8iKcOJF97ouEV9aeAmYTw2/WReuROaEKh5fT4CvqtFEoEP866Oies736cyXl042uKNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726486551; c=relaxed/simple;
	bh=kZap1Ca0wYXL5ZXFV+JmmCCnLEfEqJOXPIU9iFe1SF0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HED/YzXHBbU8sL30rKRz7gaoqM3hqSk7LrLIGklhxBsNZ9Clw0isUkjHP6AP6qGHuEFPZ7RjIjfouKdXK43Tpgj83fcVT78fxYF0A8iUgRRDI3h4nyQRtO0ri5oTUcBiVlgLVSltRYLnI4UH5dsrKhn3r3T4WV9JWN8HMiwKh+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=LMPKFVZu; arc=none smtp.client-ip=207.171.184.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1726486551; x=1758022551;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YhYC82vuYhxRbKNM3lupC9Sz/V22SIFTp2GLNchSdFM=;
  b=LMPKFVZuLEXbvmJBhHxXvdUIXTSUU4GSqmckX98KlY9h324MztgMQWPc
   biX7ZnyGnUQmQVo6SMMhEqdH2xZDwc/Coq84gyzlmaTm5B6m3O1oqg0y3
   ehPcsr4lkmf0Xu3k/wDmmDqK0ZR4b48imGNaZLQWiWqdNWpKwDj9cVziA
   M=;
X-IronPort-AV: E=Sophos;i="6.10,233,1719878400"; 
   d="scan'208";a="454427141"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.214])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2024 11:35:48 +0000
Received: from EX19MTAEUA001.ant.amazon.com [10.0.17.79:29382]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.20.15:2525] with esmtp (Farcaster)
 id b4c4bc91-312e-476c-b408-dce0c369f62a; Mon, 16 Sep 2024 11:35:47 +0000 (UTC)
X-Farcaster-Flow-ID: b4c4bc91-312e-476c-b408-dce0c369f62a
Received: from EX19D014EUC004.ant.amazon.com (10.252.51.182) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.223) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Mon, 16 Sep 2024 11:35:46 +0000
Received: from u5d18b891348c5b.ant.amazon.com (10.146.13.221) by
 EX19D014EUC004.ant.amazon.com (10.252.51.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Mon, 16 Sep 2024 11:35:36 +0000
From: James Gowans <jgowans@amazon.com>
To: <linux-kernel@vger.kernel.org>
CC: Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>, "Joerg
 Roedel" <joro@8bytes.org>, =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?=
	<kw@linux.com>, Will Deacon <will@kernel.org>, Robin Murphy
	<robin.murphy@arm.com>, Mike Rapoport <rppt@kernel.org>, "Madhavan T.
 Venkataraman" <madvenka@linux.microsoft.com>, <iommu@lists.linux.dev>, "Sean
 Christopherson" <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<kvm@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>, Lu Baolu
	<baolu.lu@linux.intel.com>, Alexander Graf <graf@amazon.de>,
	<anthony.yznaga@oracle.com>, <steven.sistare@oracle.com>,
	<nh-open-source@amazon.com>, "Saenz Julienne, Nicolas" <nsaenz@amazon.es>
Subject: [RFC PATCH 12/13] iommufd, guestmemfs: Ensure persistent file used for persistent DMA
Date: Mon, 16 Sep 2024 13:31:01 +0200
Message-ID: <20240916113102.710522-13-jgowans@amazon.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240916113102.710522-1-jgowans@amazon.com>
References: <20240916113102.710522-1-jgowans@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWA004.ant.amazon.com (10.13.139.19) To
 EX19D014EUC004.ant.amazon.com (10.252.51.182)

When IOASes and hardware page tables are made persistent then DMA will
continue accessing memory which is mapped for DMA during and after
kexec. This is only legal if we are sure that the memory being accessed
by that DMA is also persistent. It would not be legal to map normal
buddy-list managed anonymous memory for persistent DMA.

Currently there is one provider of persistent memory: guestmemfs:
https://lore.kernel.org/all/20240805093245.889357-1-jgowans@amazon.com/

This commit ensures that only guestmemfs memory can be mapped into
persistent iommufds. This is almost certainly the wrong way and place to
do it, but something similar to this is needed. Perhaps in page.c?
As more persistent memory providers become available they can be added
to the list to check for.
---
 drivers/iommu/iommufd/ioas.c | 22 ++++++++++++++++++++++
 fs/guestmemfs/file.c         |  5 +++++
 include/linux/guestmemfs.h   |  7 +++++++
 3 files changed, 34 insertions(+)

diff --git a/drivers/iommu/iommufd/ioas.c b/drivers/iommu/iommufd/ioas.c
index 742248276548..ce76b41d2d72 100644
--- a/drivers/iommu/iommufd/ioas.c
+++ b/drivers/iommu/iommufd/ioas.c
@@ -2,9 +2,11 @@
 /*
  * Copyright (c) 2021-2022, NVIDIA CORPORATION & AFFILIATES
  */
+#include <linux/guestmemfs.h>
 #include <linux/interval_tree.h>
 #include <linux/iommufd.h>
 #include <linux/iommu.h>
+#include <linux/mm_types.h>
 #include <uapi/linux/iommufd.h>
 
 #include "io_pagetable.h"
@@ -217,6 +219,26 @@ int iommufd_ioas_map(struct iommufd_ucmd *ucmd)
 	if (IS_ERR(ioas))
 		return PTR_ERR(ioas);
 
+	pr_info("iommufd_ioas_map persistent id %lu\n",
+			ucmd->ictx->persistent_id);
+	if (ucmd->ictx->persistent_id) {
+#ifdef CONFIG_GUESTMEMFS_FS
+		struct vm_area_struct *vma;
+		struct mm_struct *mm = current->mm;
+
+		mmap_read_lock(mm);
+		vma = find_vma_intersection(current->mm,
+				 cmd->user_va, cmd->user_va + cmd->length);
+		if (!vma || !is_guestmemfs_file(vma->vm_file)) {
+			mmap_read_unlock(mm);
+			return -EFAULT;
+		}
+		mmap_read_unlock(mm);
+#else
+		return -EFAULT;
+#endif /* CONFIG_GUESTMEMFS_FS */
+	}
+
 	if (!(cmd->flags & IOMMU_IOAS_MAP_FIXED_IOVA))
 		flags = IOPT_ALLOC_IOVA;
 	rc = iopt_map_user_pages(ucmd->ictx, &ioas->iopt, &iova,
diff --git a/fs/guestmemfs/file.c b/fs/guestmemfs/file.c
index 8707a9d3ad90..ecacaf200a31 100644
--- a/fs/guestmemfs/file.c
+++ b/fs/guestmemfs/file.c
@@ -104,3 +104,8 @@ const struct file_operations guestmemfs_file_fops = {
 	.owner = THIS_MODULE,
 	.mmap = mmap,
 };
+
+bool is_guestmemfs_file(struct file const *file)
+{
+	return file && file->f_op == &guestmemfs_file_fops;
+}
diff --git a/include/linux/guestmemfs.h b/include/linux/guestmemfs.h
index 60e769c8e533..c5cd7b6a5630 100644
--- a/include/linux/guestmemfs.h
+++ b/include/linux/guestmemfs.h
@@ -3,14 +3,21 @@
 #ifndef _LINUX_GUESTMEMFS_H
 #define _LINUX_GUESTMEMFS_H
 
+#include <linux/fs.h>
+
 /*
  * Carves out chunks of memory from memblocks for guestmemfs.
  * Must be called in early boot before memblocks are freed.
  */
 # ifdef CONFIG_GUESTMEMFS_FS
 void guestmemfs_reserve_mem(void);
+bool is_guestmemfs_file(struct file const *filp);
 #else
 void guestmemfs_reserve_mem(void) { }
+inline bool is_guestmemfs_file(struct file const *filp)
+{
+	return 0;
+}
 #endif
 
 #endif
-- 
2.34.1


