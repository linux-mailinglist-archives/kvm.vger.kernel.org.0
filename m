Return-Path: <kvm+bounces-27227-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BE1B597DA98
	for <lists+kvm@lfdr.de>; Sat, 21 Sep 2024 00:36:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E14A91C21051
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2024 22:36:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A11018E020;
	Fri, 20 Sep 2024 22:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HkB5I6AS"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2085.outbound.protection.outlook.com [40.107.95.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2EB618DF72;
	Fri, 20 Sep 2024 22:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726871721; cv=fail; b=pjYgiwkiWg8QDMKSzFcmg5yxycgeZV8lZI4wzcIBB9inWSigxu4y3YASDi2Ce0CgVqMLT2keLzPLExqjoI+7yGn2aS0Dg7zBmVfTCFS6W4hy6eWz0qb9wxKic+aiHLmHWA+JFmRopBD2rQPq80qRIsWoNJmQU1conYDWuHuwQxo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726871721; c=relaxed/simple;
	bh=D94POwOjTBGD9UujCYyZPQeSMSPqynqou5n6fAMNN+E=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aHP9mcFFIz/TOGAxn/imirr/piGB0IbPSb9JLUEjdOP879DTSTgyl4NFYcK8dgh3kYiLW3VY9izLYOH0uRLD1n1Dtlh3+ZfQS83wp9PvYqy+oSSu4orjSU1ox0KwHmOMbbBuvvtE3mE5Wimdt6v+GEmgJOcHV4TmdMv0MI0OYj0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=HkB5I6AS; arc=fail smtp.client-ip=40.107.95.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Wr6wpZdOdozkPtIAeagNp/tXrYNDbSJbGFaAI5qqJOGX3WnDCN+Mj0qLsMEC5pPoF3aJ9wRGl42Fxl4N8h0MCLmDwgy35uoFyIoQIEI39bX9rBwckBX2U5QJALESn370h6Wfew1krA4B3wzAxFOW2PhrepHMMu3gZ4meOniwSurzFemHJbskju0iVOsapYzOBqMn5QLR4SZkeup0juURIZ9byKNQCYOO8uCW9gnHYjAG+yjm7mPSsmlPRBAd5zhNtWw4HZngXf1k1JokH4BkcEKCassZIDBhSQnNCDHP+QIimhMNfqq3Mxbxf9MA5fR9AtIBiJkHRy30Ug9vLQMmag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gwpgZ9jEaMvBiYHOtREiWi21V5vUFrGcZIkH/uTpn50=;
 b=oNIo7dSPtlwkVJ6wi3wJhF/fIBam2Wdkw4CYiWw/m35TpFYmqS9d+fRe2Y38P9L2S+112ZtgZYsS9zi7A69qswtx8MpFBCZEL+HawQNT5Owaj4ayAWZhLr8CmHB9hjc/UtnpE7Ad4697IZBXgb2khnNtmNOS4xJS0yCJYy5hIGziSWx/lQvy/uc+14+nOk1MKXImkxp3hUKwxht4SrFgQOL0pJTv870pTFv30emDGW/3W38OFfG4TP7N239EZOVnvONjdEsEYdf4NlsSNAeNJzMx3J3iRddgQiTwkOHsspzHFrlVcLIkUijSlLoRuUrJ281bKKGSr38hMXi8VnZKug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gwpgZ9jEaMvBiYHOtREiWi21V5vUFrGcZIkH/uTpn50=;
 b=HkB5I6AShcp2pkwZ8YP0QQ/tD3W6yPs0fj+qH0MFTxCbizAv47remtVwBk3zX8ehLGSQGB21HJUGsA9SU8kw3UiV7fiHJ/vHYnirvMJ2St4IsJv1Gy0dJGhctEL3kyxb/34eINz5yOyoDdTSVmn82XJmAqEwmqNG66fJoCQy6eWyfDmppwjv3j0qME5NSNvEEZ87IApUZdb3e6LTg36bP6FlnJtAn17LRUoW+vor0OFm0kyiBMp3hMXOdzIZw1VjcNAzDMLUEVg261sewcngOE2UBEqtqI1uIcGQypBWtHmzeWQ1luBhdVEj8BhMQYKVyU3aI+O6Ba7owjh3e6kEJQ==
Received: from DM6PR02CA0157.namprd02.prod.outlook.com (2603:10b6:5:332::24)
 by PH8PR12MB7230.namprd12.prod.outlook.com (2603:10b6:510:226::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.23; Fri, 20 Sep
 2024 22:35:15 +0000
Received: from CY4PEPF0000E9D2.namprd03.prod.outlook.com
 (2603:10b6:5:332:cafe::87) by DM6PR02CA0157.outlook.office365.com
 (2603:10b6:5:332::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.29 via Frontend
 Transport; Fri, 20 Sep 2024 22:35:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000E9D2.mail.protection.outlook.com (10.167.241.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Fri, 20 Sep 2024 22:35:14 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 20 Sep
 2024 15:35:03 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 20 Sep
 2024 15:35:02 -0700
Received: from inno-linux.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Fri, 20 Sep 2024 15:35:01 -0700
From: Zhi Wang <zhiw@nvidia.com>
To: <kvm@vger.kernel.org>, <linux-cxl@vger.kernel.org>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>,
	<alison.schofield@intel.com>, <dan.j.williams@intel.com>,
	<dave.jiang@intel.com>, <dave@stgolabs.net>, <jonathan.cameron@huawei.com>,
	<ira.weiny@intel.com>, <vishal.l.verma@intel.com>, <alucerop@amd.com>,
	<acurrid@nvidia.com>, <cjia@nvidia.com>, <smitra@nvidia.com>,
	<ankita@nvidia.com>, <aniketa@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <zhiw@nvidia.com>, <zhiwang@kernel.org>
Subject: [RFC 09/13] vfio/pci: introduce CXL device awareness
Date: Fri, 20 Sep 2024 15:34:42 -0700
Message-ID: <20240920223446.1908673-10-zhiw@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240920223446.1908673-1-zhiw@nvidia.com>
References: <20240920223446.1908673-1-zhiw@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D2:EE_|PH8PR12MB7230:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f319e89-6e3f-4cd8-1080-08dcd9c47f1d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jPI6YGLcRnzcp9C8LMhCwT0e0F+ZUw86Z+sweCLwuzZsN5zrA2moqVyF6B9n?=
 =?us-ascii?Q?DM9gy/sNe3yjUaB9ro1mSMfCb0BJvhEDbKLqwhmmkROEStFB4IA5JVJEkNyU?=
 =?us-ascii?Q?4zANatHjajnUaHag7xGQuJnG6V8dTbk6dHgms3l/s+N3vl0og1qw4Yj9D5qz?=
 =?us-ascii?Q?qh9oZYar/Vi3xsOcXPHHEBagRq7wtOlwtnw+7YLA3UTmsR5L07l+PEKAtGCD?=
 =?us-ascii?Q?hsaaSixXycGZVUpn9RGOi0uWJNUPZQY5o9sfHWpO83RWC9uXPj2yyowBPWBI?=
 =?us-ascii?Q?kMc8aFZ4J0t8SJUqR48ov+Lntwo50xBbRg3JlU/nPjf1cAPEJIdISGU+Ek2z?=
 =?us-ascii?Q?7tBKzrfAj40WHkemkdId3q9jIpPXUBHVbFsh+oPI2JpjNOgYcZk/iHlwsn6R?=
 =?us-ascii?Q?YaK18c6yy0l/NJwEZT74Zi899rrB9GgzY+yDLzDmvjPv7dYUm7UMFa1Oa0EV?=
 =?us-ascii?Q?mWGQV11bpcBe5ENOb1JsFj0Gkijga0OAl8PyPyxrsYyaP7Nt8fk/FqTchfL/?=
 =?us-ascii?Q?ngsS8dBYkOuohBjJrFCvFnJNBxt94bh2K5aPyZdMSKiGje8//QIad6XufwYE?=
 =?us-ascii?Q?vfURDzMJaaZ5EYzycRkFdL31NM3evq3sYnYYEWIWxY9SU5Vwe2Akyh1G7kn/?=
 =?us-ascii?Q?GMX0HQQfaYxXqW5XVETCMkRHTeH4hySol7uuAFrK87GjFmH7QSKYFp1yt39J?=
 =?us-ascii?Q?G1dIG1HGNTbMI4U4KbAAE++LhDPz9840Iyb0n8/GwvGodIJ96qa+inAqrT5w?=
 =?us-ascii?Q?qchiha+/KhTexjBbMCUIy3d9SdbrUZm61jwAQJmjkhOcFSpcibQ54dY8CuZH?=
 =?us-ascii?Q?eWdN708ggxbMfosG+tRVfzETJiopvagnYIpk2+Jb8HXcrhdx5ZXXheL53Zsx?=
 =?us-ascii?Q?C1i01+S6AarYTYbgh/v+pDV2N7u24x8QDh7kI9cokmKM4a8TGiCBK1Qznog1?=
 =?us-ascii?Q?6BrzOTYXlckJsHq/wdjeNss7NII6ZQk45QoaCxbbfh2Yvcb3gU5/38t6AGXP?=
 =?us-ascii?Q?66McmugylXsO9hj0ZUPOmbjpooIsv010mvjK1Uos4sN8CnoBF6axFWelOmJK?=
 =?us-ascii?Q?216HIVHKJxFJp/WvOjNjXwTrBZSUkUGHAcoCwvQom+F0CjHTsMQgYk/Wu0Q+?=
 =?us-ascii?Q?v6FkP7UR86VOReBnpT14pSVpq1vlRbgCbCwHDZz+uYePYi361QiHhA/lA7XY?=
 =?us-ascii?Q?rJXbdPwj6gaB8mv0rR2bi4akZe/fc/dtjsRMNAZXOCPq5eupNd4l3kh12N96?=
 =?us-ascii?Q?zCyHTodgW5TBpao44pEvd44w6WMRBLu/hF2pyM3mX+lwZ7u6XHlG7rKK12BC?=
 =?us-ascii?Q?pWqKLhZXKGr3dFras5vUOWmu2V3PJqgJc5ZojhRO4HuQLgXhwhvNUggRtmDc?=
 =?us-ascii?Q?Nh5v3V1BVFOY2lxVkb1iqnztV1Su7ppzoHXjI+lKVY1tQyFMsJ+9T1qpj16Q?=
 =?us-ascii?Q?lmcJfTgEzWehw0Y3yhOLpuapya2R1oua?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2024 22:35:14.7790
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f319e89-6e3f-4cd8-1080-08dcd9c47f1d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9D2.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7230

CXL device programming interfaces are built upon PCI interfaces. Thus
the vfio-pci-core can be leveraged to handle a CXL device.

However, CXL device also has difference with PCI devicce:

- No INTX support, only MSI/MSIX is supported.
- Resest is one via CXL reset. FLR only resets CXL.io.

Introduce the CXL device awareness to the vfio-pci-core. Expose a new
VFIO device flags to the userspace to identify the VFIO device is a CXL
device. Disable INTX support in the vfio-pci-core. Disable FLR reset for
the CXL device as the kernel CXL core hasn't support CXL reset yet.
Disable mmap support on the CXL MMIO BAR in vfio-pci-core.

Signed-off-by: Zhi Wang <zhiw@nvidia.com>
---
 drivers/vfio/pci/vfio_cxl_core.c |  8 ++++++
 drivers/vfio/pci/vfio_pci_core.c | 42 +++++++++++++++++++++-----------
 include/linux/vfio_pci_core.h    |  2 ++
 include/uapi/linux/vfio.h        |  1 +
 4 files changed, 39 insertions(+), 14 deletions(-)

diff --git a/drivers/vfio/pci/vfio_cxl_core.c b/drivers/vfio/pci/vfio_cxl_core.c
index bbb968cb1b70..d8b51f8792a2 100644
--- a/drivers/vfio/pci/vfio_cxl_core.c
+++ b/drivers/vfio/pci/vfio_cxl_core.c
@@ -391,6 +391,8 @@ int vfio_cxl_core_enable(struct vfio_pci_core_device *core_dev)
 	if (ret)
 		return ret;
 
+	vfio_pci_core_enable_cxl(core_dev);
+
 	ret = vfio_pci_core_enable(core_dev);
 	if (ret)
 		goto err_pci_core_enable;
@@ -618,6 +620,12 @@ ssize_t vfio_cxl_core_write(struct vfio_device *core_vdev, const char __user *bu
 }
 EXPORT_SYMBOL_GPL(vfio_cxl_core_write);
 
+void vfio_pci_core_enable_cxl(struct vfio_pci_core_device *core_dev)
+{
+	core_dev->has_cxl = true;
+}
+EXPORT_SYMBOL(vfio_pci_core_enable_cxl);
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 9373942f1acb..e0f23b538858 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -126,6 +126,9 @@ static void vfio_pci_probe_mmaps(struct vfio_pci_core_device *vdev)
 		if (!(res->flags & IORESOURCE_MEM))
 			goto no_mmap;
 
+		if (vdev->has_cxl && bar == vdev->cxl.comp_reg_bar)
+			goto no_mmap;
+
 		/*
 		 * The PCI core shouldn't set up a resource with a
 		 * type but zero size. But there may be bugs that
@@ -487,10 +490,15 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
 	if (ret)
 		goto out_power;
 
-	/* If reset fails because of the device lock, fail this path entirely */
-	ret = pci_try_reset_function(pdev);
-	if (ret == -EAGAIN)
-		goto out_disable_device;
+	if (!vdev->has_cxl) {
+		/* If reset fails because of the device lock, fail this path entirely */
+		ret = pci_try_reset_function(pdev);
+		if (ret == -EAGAIN)
+			goto out_disable_device;
+	} else {
+		/* CXL Reset is missing in CXL core. FLR only resets CXL.io path. */
+		ret = -ENODEV;
+	}
 
 	vdev->reset_works = !ret;
 	pci_save_state(pdev);
@@ -498,14 +506,17 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
 	if (!vdev->pci_saved_state)
 		pci_dbg(pdev, "%s: Couldn't store saved state\n", __func__);
 
-	if (likely(!nointxmask)) {
-		if (vfio_pci_nointx(pdev)) {
-			pci_info(pdev, "Masking broken INTx support\n");
-			vdev->nointx = true;
-			pci_intx(pdev, 0);
-		} else
-			vdev->pci_2_3 = pci_intx_mask_supported(pdev);
-	}
+	if (!vdev->has_cxl) {
+		if (likely(!nointxmask)) {
+			if (vfio_pci_nointx(pdev)) {
+				pci_info(pdev, "Masking broken INTx support\n");
+				vdev->nointx = true;
+				pci_intx(pdev, 0);
+			} else
+				vdev->pci_2_3 = pci_intx_mask_supported(pdev);
+		}
+	} else
+		vdev->nointx = true; /* CXL device doesn't have INTX. */
 
 	pci_read_config_word(pdev, PCI_COMMAND, &cmd);
 	if (vdev->pci_2_3 && (cmd & PCI_COMMAND_INTX_DISABLE)) {
@@ -541,7 +552,6 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
 	if (!vfio_vga_disabled() && vfio_pci_is_vga(pdev))
 		vdev->has_vga = true;
 
-
 	return 0;
 
 out_free_zdev:
@@ -657,7 +667,8 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
 	 * Disable INTx and MSI, presumably to avoid spurious interrupts
 	 * during reset.  Stolen from pci_reset_function()
 	 */
-	pci_write_config_word(pdev, PCI_COMMAND, PCI_COMMAND_INTX_DISABLE);
+	if (!vdev->nointx)
+		pci_write_config_word(pdev, PCI_COMMAND, PCI_COMMAND_INTX_DISABLE);
 
 	/*
 	 * Try to get the locks ourselves to prevent a deadlock. The
@@ -973,6 +984,9 @@ static int vfio_pci_ioctl_get_info(struct vfio_pci_core_device *vdev,
 	if (vdev->reset_works)
 		info.flags |= VFIO_DEVICE_FLAGS_RESET;
 
+	if (vdev->has_cxl)
+		info.flags |= VFIO_DEVICE_FLAGS_CXL;
+
 	info.num_regions = VFIO_PCI_NUM_REGIONS + vdev->num_regions;
 	info.num_irqs = VFIO_PCI_NUM_IRQS;
 
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 9d295ca9382a..e5646aad3eb3 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -113,6 +113,7 @@ struct vfio_pci_core_device {
 	bool			needs_pm_restore:1;
 	bool			pm_intx_masked:1;
 	bool			pm_runtime_engaged:1;
+	bool			has_cxl:1;
 	struct pci_saved_state	*pci_saved_state;
 	struct pci_saved_state	*pm_save;
 	int			ioeventfds_nr;
@@ -208,5 +209,6 @@ ssize_t vfio_cxl_core_read(struct vfio_device *core_vdev, char __user *buf,
 			   size_t count, loff_t *ppos);
 ssize_t vfio_cxl_core_write(struct vfio_device *core_vdev, const char __user *buf,
 			    size_t count, loff_t *ppos);
+void vfio_pci_core_enable_cxl(struct vfio_pci_core_device *core_dev);
 
 #endif /* VFIO_PCI_CORE_H */
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 71f766c29060..0895183feaac 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -214,6 +214,7 @@ struct vfio_device_info {
 #define VFIO_DEVICE_FLAGS_FSL_MC (1 << 6)	/* vfio-fsl-mc device */
 #define VFIO_DEVICE_FLAGS_CAPS	(1 << 7)	/* Info supports caps */
 #define VFIO_DEVICE_FLAGS_CDX	(1 << 8)	/* vfio-cdx device */
+#define VFIO_DEVICE_FLAGS_CXL	(1 << 9)	/* Device supports CXL support */
 	__u32	num_regions;	/* Max region index + 1 */
 	__u32	num_irqs;	/* Max IRQ index + 1 */
 	__u32   cap_offset;	/* Offset within info struct of first cap */
-- 
2.34.1


