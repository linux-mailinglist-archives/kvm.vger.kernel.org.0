Return-Path: <kvm+bounces-65569-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id BD8E3CB0A7D
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 18:02:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 99EBB30194F3
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 17:02:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25FB732ABC5;
	Tue,  9 Dec 2025 16:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lgtHKsYV"
X-Original-To: kvm@vger.kernel.org
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010004.outbound.protection.outlook.com [52.101.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A723532E6BA;
	Tue,  9 Dec 2025 16:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.4
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765299169; cv=fail; b=HLkVaKAz35RE5niOMVKUkwNoyv0hgHko5RyGldX9VhpALGUVhqaQS0TXGwSGcnMSQz8Fc7QFvPPe9HotjN36K6USU5Tpj6K0eyzY1yndkGcWxKmJutPZuWT4+zNErc07B55Xse8oeEkv8D29ejBAjZ4o/eBm5Dypw1NydbggOH8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765299169; c=relaxed/simple;
	bh=GZJDxchfh8V+pp1t4IlfH5gr/mdGN3pa2yrvPSNny8I=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vDhwqS9K51c3XpAVzFhZhAaNIrOAwVrk9n51a2qv1O7RJx3TlkG9vNAKIMpYQCuW5+Fx7pEG2oY8xjcvdfTvhmaCo3l2CT3vO/KyE9z91etVeXuXGrEpayjEo8YJf5JSzafzvtszPi+LdfvJ+0fweiNsJcovGMBU7sDcN6zHLkI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lgtHKsYV; arc=fail smtp.client-ip=52.101.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QJmtTqKU2OgnYjdIJxPrbFmlLeJyCzvFoCJKttY3ThifshegXd/D9IUZJoyspOllbNeOVrok/fXa3AHoWRMum6g1dLJuMRTZC6I51dsSDwRGKGeEcJHdo6U9PRygAyKec9pvAd2ZHCAwsBPaurbnbnvCG8ZsJ8qEpZsJ44wuGLeEyK3PIP8C61fqskN0QB0HRvpSVhbv1e7oumA4tGc2017XFNjmGH2lJ/VLSYAd7tLGwM9P6M3YRkXXIojkQF0AQS8DXsD2dKRD4UftnnAUZE1VfTQuTc5ekDPYrlZS175jYgi518pSkkOACs7OH5Rj6jsdNFh6559Nw7M6P1RaQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hxiZUvRANKziqWZ+A3QECR4oaAv5m6hQCCpRwpF3WIo=;
 b=mpdjQOzQ107Ic8K4H0WmHnBH8ZMxsPSJBCJs1pcl0L0rG/mAP4IpOegAYZm34BCOTuGAsgz2is2B6KjiSoJb0f1fZ9rBxyFFNmpq3nycUf7Ov8S7aQHdebbFeG/YwnZBs1+8J9vjBtDa/cLQXxwD2rpQSv3VDMQ5xPZfpvodTEeInJuaROOVHWk8+xZFhKSfvO5m+rZmURFRN2qet4QRR5QKJ/L48O8y3WH9lWCLHxC03QSO905UVEs8hEd1/k1e9pkA3gphHS9WhSzZNSYx1EVWrbOJ3n5hHtBbpCbfS9afxvOv9G6WPE1yNzwrnMu5uOLphA7/xnbd+yJwWyJOdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hxiZUvRANKziqWZ+A3QECR4oaAv5m6hQCCpRwpF3WIo=;
 b=lgtHKsYVp7MLz+8MIU+PT1yQjvWom4EIuRMXKZNJqYIJqz+io6Bm6oMSna8IE7YcI59+Z+73WK3sWdbWamD5P0zVT7b0o1L9Cfjmv9hK6pYGTQvlCH1XBZ52g00Tfqzmbla1Kw3ciZEopy8enRgPxYFCeCTa43Z7eD+wDLGy8rDXxol/1d8VIZ3LOLzkT4b3wNUAprq1uCT6jQE67aBdrrSInm4KQFd6Jef1c6XCTL2RePLMWn3hEc8WXAvvNrqjToH7UPvZe1vwlQlALU9A1eS05yrJrJbWljIECKXdIqe8zNLlHXY306kPBBIfu2slvaYwm+8cNkWUttQ1S5truQ==
Received: from SJ0PR03CA0371.namprd03.prod.outlook.com (2603:10b6:a03:3a1::16)
 by IA1PR12MB6164.namprd12.prod.outlook.com (2603:10b6:208:3e8::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.9; Tue, 9 Dec
 2025 16:52:36 +0000
Received: from SJ1PEPF00002315.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1:cafe::cc) by SJ0PR03CA0371.outlook.office365.com
 (2603:10b6:a03:3a1::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9388.14 via Frontend Transport; Tue,
 9 Dec 2025 16:52:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ1PEPF00002315.mail.protection.outlook.com (10.167.242.169) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.8 via Frontend Transport; Tue, 9 Dec 2025 16:52:36 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 9 Dec
 2025 08:52:13 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 9 Dec
 2025 08:52:12 -0800
Received: from nvidia-4028GR-scsim.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 9 Dec 2025 08:52:05 -0800
From: <mhonap@nvidia.com>
To: <aniketa@nvidia.com>, <ankita@nvidia.com>, <alwilliamson@nvidia.com>,
	<vsethi@nvidia.com>, <jgg@nvidia.com>, <mochs@nvidia.com>,
	<skolothumtho@nvidia.com>, <alejandro.lucero-palau@amd.com>,
	<dave@stgolabs.net>, <jonathan.cameron@huawei.com>, <dave.jiang@intel.com>,
	<alison.schofield@intel.com>, <vishal.l.verma@intel.com>,
	<ira.weiny@intel.com>, <dan.j.williams@intel.com>, <jgg@ziepe.ca>,
	<yishaih@nvidia.com>, <kevin.tian@intel.com>
CC: <cjia@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
	<zhiw@nvidia.com>, <kjaju@nvidia.com>, <linux-kernel@vger.kernel.org>,
	<linux-cxl@vger.kernel.org>, <kvm@vger.kernel.org>, <mhonap@nvidia.com>
Subject: [RFC v2 11/15] vfio/cxl: introduce the emulation of HDM registers
Date: Tue, 9 Dec 2025 22:20:15 +0530
Message-ID: <20251209165019.2643142-12-mhonap@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251209165019.2643142-1-mhonap@nvidia.com>
References: <20251209165019.2643142-1-mhonap@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002315:EE_|IA1PR12MB6164:EE_
X-MS-Office365-Filtering-Correlation-Id: d0af40f3-15bf-4d15-4c0c-08de37435b44
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|36860700013|376014|1800799024|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/Yr8RehwA9DG38P4GHxKKgHSsaOKlJ3fF6NiQmSl/RvRE771xjvkWhhddPQb?=
 =?us-ascii?Q?5vH0JyafDLHxpqZIdEeH7tydxD1Am0CM/jcGBXCUWMNJ0j9t3hRNiEeX76/6?=
 =?us-ascii?Q?mBsPDzgimJFgVZ5YgO2aEy7E0B/nRwt6CmLJjfq9V8dEb4Pp+R3DRkFQ/g26?=
 =?us-ascii?Q?awIrMBmTW9hzNwPvDRr5OJlLfSt+InTKVBmEDS2k9YUrt2AaA1qG9/4anhHn?=
 =?us-ascii?Q?3N6aVtpi2FqcQJSrkzJ6r0G/ysHgUjmuaAYeK4GXBbMLhydqudCF0KfmZleb?=
 =?us-ascii?Q?spX9xvn05Tn2G4lTKGaj7ByhPBWO78xZYwX3rBIzcO7k/wM1lTXaQNMNLzU5?=
 =?us-ascii?Q?ywiScncxgIW+pVL4azxY64Sa7Tx5NpLmWf50PNuCsgAbiKKqU3RzOJ6IW4bA?=
 =?us-ascii?Q?T8ztr2YwsX5HAqWRm8fWsKNAcyN4wi4FhTqL9MNBX7MtSXxv6HIvrqWCCueh?=
 =?us-ascii?Q?SVfUoN22BccU3RyPZuZsHvcM+zKLBERxWLfN4wacrox3jnmb2Fesp7TlJOQf?=
 =?us-ascii?Q?ZB4VE5At8paEPpL9RPZ0qevlGSiDAToM1NkMiMEetde/Z/wF0ywIZSEYI2Cs?=
 =?us-ascii?Q?/Hc6xoDxPCEjBffDnFTyjE/5NZb1ffASXuCVbw6BoUknKrKHjAnlhwxFHmE7?=
 =?us-ascii?Q?MVb+WjJAZC37AMMMN4kJgOLc53sS5h3hkVFpb60WtwUBXi6o74Ignr3T8aOB?=
 =?us-ascii?Q?1M+A0lQgtBoQ0TPSPdl8OvzRfoflt2t6v+/hzHs3RwrDqQ7Gnsszxa5VfPuW?=
 =?us-ascii?Q?QBzAnQW62+AI7NbimKTt3q9iHrFUVSGTOCeEdbL3AE5IQimMA7/32HiXZ4AJ?=
 =?us-ascii?Q?KAkwAXA/QM0gJSVqQcjYRA5VFka1lYiaz0BGaVMn6TBw6C+2mK47e5KPeUPj?=
 =?us-ascii?Q?5LhXkQUZG9HogyPdAy3VkTSNkenJ/1KY00Fse0pSQcGV6pfCAafcGr8E75P9?=
 =?us-ascii?Q?4RD0v6+OgE058whG2O56AMW1BG1AMFgS3gyFYY/3v3f1DnKt8b1tkCTmMM3x?=
 =?us-ascii?Q?dKSqRxQb2hy1M1f8znk5fTT7j1xRqX4YcLYx0H6Rl2VbDtI7gZOLeyCt//2I?=
 =?us-ascii?Q?4R/8ko/5sdBWuUSUbS/SpcWY7ygu3ni3QiTJi7ng68cBPeO8z3ipD/KL044o?=
 =?us-ascii?Q?/SjCalQOI/W0PLxyHe8UCells0xaW6sCvFiWpJ8Hs7fOkfRdhJOItKCJQgsL?=
 =?us-ascii?Q?MLvYlE4q0/xHrVPg6Q8zLlsLa1Nzd7eOZ+vqiWfJHT/i9PyABGn49UDHFuo0?=
 =?us-ascii?Q?RP0FFc8uMifsYk/iW+XzbygAtXO9ZvYixtMcSdBYzLBukWQJ1YT9DP9ky9Py?=
 =?us-ascii?Q?/uPafMsAJFfKd4L4S716qcnu2XRdpcimCoN3hhPabjJSfY4Lr36Ch25+4u4q?=
 =?us-ascii?Q?0/LpqZnmwcldo1VNpCqif0jV+QXs2PXeLg7Qit9hZUSZSvqF8AjnUO4BYJU0?=
 =?us-ascii?Q?vehvXr9Sq2ezOSdPvTIpKzu2aKnlHirg3a+uQguSlQzXylV1g2TrG7IsDGT7?=
 =?us-ascii?Q?UKjgtR5zjXGELz8DWyymD/pLPz/pwpMeiQqmGNLi28uKwI28wToLyu/IUtQl?=
 =?us-ascii?Q?az76A7VERVTW8jsVHBdtsvXoPXvbFl3qn4n0WxXI?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(36860700013)(376014)(1800799024)(82310400026)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2025 16:52:36.5455
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d0af40f3-15bf-4d15-4c0c-08de37435b44
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002315.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6164

From: Manish Honap <mhonap@nvidia.com>

CXL devices have HDM registers in its CXL MMIO bar. Many HDM registers
requires a PA and they are owned by the host in virtualization.

Thus, the HDM registers needs to be emulated accordingly so that the
guest kernel CXL core can configure the virtual HDM decoders.

Intorduce the emulation of HDM registers that emulates the HDM decoders.

Co-developed-by: Zhi Wang <zhiw@nvidia.com>
Signed-off-by: Zhi Wang <zhiw@nvidia.com>
Signed-off-by: Manish Honap <mhonap@nvidia.com>
---
 drivers/vfio/pci/vfio_cxl_core.c     |   7 +-
 drivers/vfio/pci/vfio_cxl_core_emu.c | 242 +++++++++++++++++++++++++++
 include/linux/vfio_pci_core.h        |   2 +
 3 files changed, 248 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/pci/vfio_cxl_core.c b/drivers/vfio/pci/vfio_cxl_core.c
index cb75e9f668a7..c0bdf55997da 100644
--- a/drivers/vfio/pci/vfio_cxl_core.c
+++ b/drivers/vfio/pci/vfio_cxl_core.c
@@ -247,8 +247,6 @@ int vfio_cxl_core_enable(struct vfio_cxl_core_device *cxl,
 	if (!dvsec)
 		return -ENODEV;
 
-	cxl->dvsec = dvsec;
-
 	cxl_core = devm_cxl_dev_state_create(&pdev->dev, CXL_DEVTYPE_DEVMEM,
 					     pdev->dev.id, dvsec, struct vfio_cxl,
 					     cxlds, false);
@@ -257,9 +255,12 @@ int vfio_cxl_core_enable(struct vfio_cxl_core_device *cxl,
 		return -ENOMEM;
 	}
 
+	cxl->dvsec = dvsec;
+	cxl->cxl_core = cxl_core;
+
 	ret = find_comp_regs(cxl);
 	if (ret)
-		return -ENODEV;
+		return ret;
 
 	ret = setup_virt_regs(cxl);
 	if (ret)
diff --git a/drivers/vfio/pci/vfio_cxl_core_emu.c b/drivers/vfio/pci/vfio_cxl_core_emu.c
index a0674bacecd7..6711ff8975ef 100644
--- a/drivers/vfio/pci/vfio_cxl_core_emu.c
+++ b/drivers/vfio/pci/vfio_cxl_core_emu.c
@@ -5,6 +5,239 @@
 
 #include "vfio_cxl_core_priv.h"
 
+typedef ssize_t reg_handler_t(struct vfio_cxl_core_device *cxl, void *buf,
+			      u64 offset, u64 size);
+
+static struct vfio_emulated_regblock *
+new_reg_block(struct vfio_cxl_core_device *cxl, u64 offset, u64 size,
+	      reg_handler_t *read, reg_handler_t *write)
+{
+	struct vfio_emulated_regblock *block;
+
+	block = kzalloc(sizeof(*block), GFP_KERNEL);
+	if (!block)
+		return ERR_PTR(-ENOMEM);
+
+	block->range.start = offset;
+	block->range.end = offset + size - 1;
+	block->read = read;
+	block->write = write;
+
+	INIT_LIST_HEAD(&block->list);
+
+	return block;
+}
+
+static int new_mmio_block(struct vfio_cxl_core_device *cxl, u64 offset, u64 size,
+			  reg_handler_t *read, reg_handler_t *write)
+{
+	struct vfio_emulated_regblock *block;
+
+	block = new_reg_block(cxl, offset, size, read, write);
+	if (IS_ERR(block))
+		return PTR_ERR(block);
+
+	list_add_tail(&block->list, &cxl->mmio_regblocks_head);
+	return 0;
+}
+
+static u64 hdm_reg_base(struct vfio_cxl_core_device *cxl)
+{
+	return cxl->comp_reg_offset + cxl->hdm_reg_offset;
+}
+
+static u64 to_hdm_reg_offset(struct vfio_cxl_core_device *cxl, u64 offset)
+{
+	return offset - hdm_reg_base(cxl);
+}
+
+static void *hdm_reg_virt(struct vfio_cxl_core_device *cxl, u64 hdm_reg_offset)
+{
+	return cxl->comp_reg_virt + cxl->hdm_reg_offset + hdm_reg_offset;
+}
+
+static ssize_t virt_hdm_reg_read(struct vfio_cxl_core_device *cxl, void *buf,
+				 u64 offset, u64 size)
+{
+	offset = to_hdm_reg_offset(cxl, offset);
+	memcpy(buf, hdm_reg_virt(cxl, offset), size);
+
+	return size;
+}
+
+static ssize_t virt_hdm_reg_write(struct vfio_cxl_core_device *cxl, void *buf,
+				  u64 offset, u64 size)
+{
+	offset = to_hdm_reg_offset(cxl, offset);
+	memcpy(hdm_reg_virt(cxl, offset), buf, size);
+
+	return size;
+}
+
+static ssize_t virt_hdm_rev_reg_write(struct vfio_cxl_core_device *cxl,
+				      void *buf, u64 offset, u64 size)
+{
+	/* Discard writes on reserved registers. */
+	return size;
+}
+
+static ssize_t hdm_decoder_n_lo_write(struct vfio_cxl_core_device *cxl,
+				      void *buf, u64 offset, u64 size)
+{
+	u32 new_val = le32_to_cpu(*(u32 *)buf);
+
+	if (WARN_ON_ONCE(size != 4))
+		return -EINVAL;
+
+	/* Bit [27:0] are reserved. */
+	new_val &= ~GENMASK(27, 0);
+
+	new_val = cpu_to_le32(new_val);
+	offset = to_hdm_reg_offset(cxl, offset);
+	memcpy(hdm_reg_virt(cxl, offset), &new_val, size);
+	return size;
+}
+
+static ssize_t hdm_decoder_global_ctrl_write(struct vfio_cxl_core_device *cxl,
+					     void *buf, u64 offset, u64 size)
+{
+	u32 hdm_decoder_global_cap;
+	u32 new_val = le32_to_cpu(*(u32 *)buf);
+
+	if (WARN_ON_ONCE(size != 4))
+		return -EINVAL;
+
+	/* Bit [31:2] are reserved. */
+	new_val &= ~GENMASK(31, 2);
+
+	/* Poison On Decode Error Enable bit is 0 and RO if not support. */
+	hdm_decoder_global_cap = le32_to_cpu(*(u32 *)hdm_reg_virt(cxl, 0));
+	if (!(hdm_decoder_global_cap & BIT(10)))
+		new_val &= ~BIT(0);
+
+	new_val = cpu_to_le32(new_val);
+	offset = to_hdm_reg_offset(cxl, offset);
+	memcpy(hdm_reg_virt(cxl, offset), &new_val, size);
+	return size;
+}
+
+static ssize_t hdm_decoder_n_ctrl_write(struct vfio_cxl_core_device *cxl,
+					void *buf, u64 offset, u64 size)
+{
+	u32 hdm_decoder_global_cap;
+	u32 ro_mask, rev_mask;
+	u32 new_val = le32_to_cpu(*(u32 *)buf);
+	u32 cur_val;
+
+	if (WARN_ON_ONCE(size != 4))
+		return -EINVAL;
+
+	offset = to_hdm_reg_offset(cxl, offset);
+	cur_val = le32_to_cpu(*(u32 *)hdm_reg_virt(cxl, offset));
+
+	/* Lock on commit */
+	if (cur_val & BIT(8))
+		return size;
+
+	hdm_decoder_global_cap = le32_to_cpu(*(u32 *)hdm_reg_virt(cxl, 0));
+
+	/* RO and reserved bits in the spec */
+	ro_mask = BIT(10) | BIT(11);
+	rev_mask = BIT(15) | GENMASK(31, 28);
+
+	/* bits are not valid for devices */
+	ro_mask |= BIT(12);
+	rev_mask |= GENMASK(19, 16) | GENMASK(23, 20);
+
+	/* bits are reserved when UIO is not supported */
+	if (!(hdm_decoder_global_cap & BIT(13)))
+		rev_mask |= BIT(14) | GENMASK(27, 24);
+
+	/* clear reserved bits */
+	new_val &= ~rev_mask;
+
+	/* keep the RO bits */
+	cur_val &= ro_mask;
+	new_val &= ~ro_mask;
+	new_val |= cur_val;
+
+	/* emulate HDM decoder commit/de-commit */
+	if (new_val & BIT(9))
+		new_val |= BIT(10);
+	else
+		new_val &= ~BIT(10);
+
+	new_val = cpu_to_le32(new_val);
+	memcpy(hdm_reg_virt(cxl, offset), &new_val, size);
+	return size;
+}
+
+static int setup_mmio_emulation(struct vfio_cxl_core_device *cxl)
+{
+	u64 offset, base;
+	int ret;
+
+	base = hdm_reg_base(cxl);
+
+#define ALLOC_BLOCK(offset, size, read, write) do {			\
+		ret = new_mmio_block(cxl, offset, size, read, write);	\
+		if (ret)						\
+			return ret;					\
+	} while (0)
+
+	ALLOC_BLOCK(base + 0x4, 4,
+		    virt_hdm_reg_read,
+		    hdm_decoder_global_ctrl_write);
+
+	offset = base + 0x10;
+	while (offset < base + cxl->hdm_reg_size) {
+		/* HDM N BASE LOW */
+		ALLOC_BLOCK(offset, 4,
+			    virt_hdm_reg_read,
+			    hdm_decoder_n_lo_write);
+
+		/* HDM N BASE HIGH */
+		ALLOC_BLOCK(offset + 0x4, 4,
+			    virt_hdm_reg_read,
+			    virt_hdm_reg_write);
+
+		/* HDM N SIZE LOW */
+		ALLOC_BLOCK(offset + 0x8, 4,
+			    virt_hdm_reg_read,
+			    hdm_decoder_n_lo_write);
+
+		/* HDM N SIZE HIGH */
+		ALLOC_BLOCK(offset + 0xc, 4,
+			    virt_hdm_reg_read,
+			    virt_hdm_reg_write);
+
+		/* HDM N CONTROL */
+		ALLOC_BLOCK(offset + 0x10, 4,
+			    virt_hdm_reg_read,
+			    hdm_decoder_n_ctrl_write);
+
+		/* HDM N TARGET LIST LOW */
+		ALLOC_BLOCK(offset + 0x14, 0x4,
+			    virt_hdm_reg_read,
+			    virt_hdm_rev_reg_write);
+
+		/* HDM N TARGET LIST HIGH */
+		ALLOC_BLOCK(offset + 0x18, 0x4,
+			    virt_hdm_reg_read,
+			    virt_hdm_rev_reg_write);
+
+		/* HDM N REV */
+		ALLOC_BLOCK(offset + 0x1c, 0x4,
+			    virt_hdm_reg_read,
+			    virt_hdm_rev_reg_write);
+
+		offset += 0x20;
+	}
+
+#undef ALLOC_BLOCK
+	return 0;
+}
+
 void vfio_cxl_core_clean_register_emulation(struct vfio_cxl_core_device *cxl)
 {
 	struct list_head *pos, *n;
@@ -17,10 +250,19 @@ void vfio_cxl_core_clean_register_emulation(struct vfio_cxl_core_device *cxl)
 
 int vfio_cxl_core_setup_register_emulation(struct vfio_cxl_core_device *cxl)
 {
+	int ret;
+
 	INIT_LIST_HEAD(&cxl->config_regblocks_head);
 	INIT_LIST_HEAD(&cxl->mmio_regblocks_head);
 
+	ret = setup_mmio_emulation(cxl);
+	if (ret)
+		goto err;
+
 	return 0;
+err:
+	vfio_cxl_core_clean_register_emulation(cxl);
+	return ret;
 }
 
 static struct vfio_emulated_regblock *
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 12ded67c7db7..31fd28626846 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -251,5 +251,7 @@ ssize_t vfio_cxl_core_write(struct vfio_device *core_vdev, const char __user *bu
 			    size_t count, loff_t *ppos);
 long vfio_cxl_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 			 unsigned long arg);
+int vfio_cxl_core_setup_register_emulation(struct vfio_cxl_core_device *cxl);
+void vfio_cxl_core_clean_register_emulation(struct vfio_cxl_core_device *cxl);
 
 #endif /* VFIO_PCI_CORE_H */
-- 
2.25.1


