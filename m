Return-Path: <kvm+bounces-27231-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B2BC97DA9D
	for <lists+kvm@lfdr.de>; Sat, 21 Sep 2024 00:36:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EF0701F220E2
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2024 22:36:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5396C18CC12;
	Fri, 20 Sep 2024 22:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Bo80OZxb"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2056.outbound.protection.outlook.com [40.107.94.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D312218CC02;
	Fri, 20 Sep 2024 22:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726871729; cv=fail; b=sBaTZcyyHHz6+fsXHHM1wfZwd9RjaGp8h4wl2MTauSnGwCdhdZ0eW/IDfV8jo/oswwLDX0EBdJ+DIX+oAXYgJM1vpxOzp1j3tMn4ncv2aGfFiDutSdyZpECrvAjGSgEBxBUttjXzRRjzK3xFY19/gr0qB8cxYihXBxuaxo9+1qk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726871729; c=relaxed/simple;
	bh=HzZQT4JTb9Vjz2bFDT6w1c2OsIzone4ffRvzbROFczw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mY4Ml5BQFILQ1WtpOJ5mzpVb0hV3BncaSYZJ7FkAwpf9HHLvEb1PxLJV8/7VV2Nar7/Rynjr/xjRM7r0AJac/Sui1z/9lqP+qRFoRVZYmKh1F3Ep+KoiuLyTd0o6ufMPGJuLBAWtskhhKjZ/4L9peh3dXZae3TQ8W6jP/GCceyM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Bo80OZxb; arc=fail smtp.client-ip=40.107.94.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RwGoWL0opU291yM/9yipfYm375mVhQMjLXz1jmLRs7c7aF0LUK4L6UEbQOur0qUGxmZqK5zLvA3pTHhZKKQNewjyXvOgp4fL8y9X1YIpdgE1OCuh4mTVMATF8BT9R6GQo8KtMb2FhWSxUktaWc/k74txvrN1BPM5Y3shCfZl5HZRHuA2Md7GQpN4NynWVPka7JRD8M+1a/RL3QeXx20JHP/hKqLfibBO2UZZ7vZ+sbGTRNdQDaRmz9JFTpXNw5Bh6ylWGXrOHR699cI00LfRDMUXoInN9thuX2LcYo97UUD6BlDxLB70WEDV6kWV6hM7q4M8kyK07w5DTy+xNUGXmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j31hJvif7Wk95e95Osg2cHJ/eYP8VQ4zfkemBrkNQWw=;
 b=WybAVIzdj9tS3l5FqkYR6u/HdvEiGqXtLaiQZ7n2z7onVFKB+rnyf+dCGDNzw1fblGZbNRB0S0XtGO+/0BKpTdlHEpAT2z7Rw0UExa+6ZGAR9yScIhu26hiy7QLA+1f/QPhOgK5wkHErfBZ2xAxcW8/zqGVDU4FBfQ6J+1KIIXc2kDygECIyVT5D5ElifeHqffuANtYmF7inw1CoOIsQo4GYA8PkoB+AjP0nhMdpz5dvjs7p3coMHn9vYC6PGWLALAFarICDlUdKGm0DZJzrznhmFCRney8QFb3zlW5irmYWr4e3INTGCK460rzuGt44Y6xSW+k5hIdgua4nDoudRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j31hJvif7Wk95e95Osg2cHJ/eYP8VQ4zfkemBrkNQWw=;
 b=Bo80OZxbBrHaeYEsKfqroVWJz9nc3i5MBJ/CGD9qcV6qjHWs0Bld8RZvQioWDfGPs/uzLQJjvlUpsOLhNqvJ9dyZLucbeezdBvYk3mmHsB7seAndOhh3nns8IpKN/2jB8q654rpH7+L1HoHsGrFYAFl4eaWhcLabflD1dZRyNJ+fZGI20JgTpL/VPMFYWLMfD/umRssUC8PXC38K1tJD5LCEzGNwuvmeGoXKEeg1Ax0/fp5CNMFqO3gkPhiAwlePbE35D9yJuaKTn3zjWEHNzvRfHlGDZq6dAAIBWza6HQfZAhQUFMU1w6RjFSDW4O6yGzMQR/9WesZbNXjpY8/X5Q==
Received: from DS0PR17CA0005.namprd17.prod.outlook.com (2603:10b6:8:191::6) by
 DS7PR12MB5719.namprd12.prod.outlook.com (2603:10b6:8:72::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7982.17; Fri, 20 Sep 2024 22:35:23 +0000
Received: from CY4PEPF0000E9CE.namprd03.prod.outlook.com
 (2603:10b6:8:191:cafe::59) by DS0PR17CA0005.outlook.office365.com
 (2603:10b6:8:191::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.14 via Frontend
 Transport; Fri, 20 Sep 2024 22:35:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000E9CE.mail.protection.outlook.com (10.167.241.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Fri, 20 Sep 2024 22:35:20 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 20 Sep
 2024 15:35:05 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 20 Sep
 2024 15:35:05 -0700
Received: from inno-linux.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Fri, 20 Sep 2024 15:35:04 -0700
From: Zhi Wang <zhiw@nvidia.com>
To: <kvm@vger.kernel.org>, <linux-cxl@vger.kernel.org>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>,
	<alison.schofield@intel.com>, <dan.j.williams@intel.com>,
	<dave.jiang@intel.com>, <dave@stgolabs.net>, <jonathan.cameron@huawei.com>,
	<ira.weiny@intel.com>, <vishal.l.verma@intel.com>, <alucerop@amd.com>,
	<acurrid@nvidia.com>, <cjia@nvidia.com>, <smitra@nvidia.com>,
	<ankita@nvidia.com>, <aniketa@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <zhiw@nvidia.com>, <zhiwang@kernel.org>
Subject: [RFC 11/13] vfio/cxl: introduce VFIO CXL device cap
Date: Fri, 20 Sep 2024 15:34:44 -0700
Message-ID: <20240920223446.1908673-12-zhiw@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9CE:EE_|DS7PR12MB5719:EE_
X-MS-Office365-Filtering-Correlation-Id: 9058ca05-4d2c-453e-6d7f-08dcd9c482cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uhVArqJlAfYE07kVGJdqRSTnnRHv6892S37uoxmRQJtIr7thzlNlXPTL9Yii?=
 =?us-ascii?Q?7s8u7UGMTZPQ05bjWHYAF9TYp9myb0BH+A/gCWTS2CxzBPRo0pphxghzroLe?=
 =?us-ascii?Q?XDK767ZWiL0BQZAdYZhg8bvrVryDguICbUlB5S/EPDnQBlDvjgq7ogsQpN8P?=
 =?us-ascii?Q?Ydg182vbbOQI0PLKBkD4tJO+LzU3ih5s2EZKvmNCGyMz/YDzYY8srwJKiQOy?=
 =?us-ascii?Q?NhKtxisNPQETmp0sM9RU5e+z0LfhXVUQFaCEF2KI1IXNeqDoGoKbQYag2Nh6?=
 =?us-ascii?Q?pCXetSOdM1RPiZsfjoPM2vXgWGCMj/7lW4mgaCTkIFyLl3/bnze79OAfOz6n?=
 =?us-ascii?Q?2sqOpOYxGs57u8z+V3TV2YAkH93GT3Qz4aVgMrGtutX7OZ2zogPhe39EnQXB?=
 =?us-ascii?Q?B+fehzFdtvxstHsvYs9Diult3cNQMjGfQ1zZlyfOG+YOFSJQowlBGI/OeCOx?=
 =?us-ascii?Q?zE1Z6kuxPXdP2mq7HymhQqDkD9M+q74OSLs9LqYC8q5nyA0OrO1H0TQwhMe6?=
 =?us-ascii?Q?OHZp3tXG8Uu44/oEebDDjyCpDi5Diu7Kp4/K6qkEm/u5QnD7bJA1mkQV9b1V?=
 =?us-ascii?Q?KQobTYm+veVgFcE66s16TGCKTAjMei967Fj6KrFUTsPKpJOKYZzQ1Z638MMO?=
 =?us-ascii?Q?JGtbdgUMJxOvIR6p433mNo721fN7qH16saO0Ycxo2lCHpwJWPbhHEJW9/MHc?=
 =?us-ascii?Q?onFJEcUMjTapJPlXXI1Qnc6EQCvIc8M9pM6a/3ARSSlnr0oFG6LwFzP9DVMA?=
 =?us-ascii?Q?PkCto5hv1RxCsKfO8mCwDtzD/NaDI6X2zXeBfEf71TJ6uydDt4AChA2CIVds?=
 =?us-ascii?Q?g1o2dFtJJyIy4pleywNgz/Gc/ihyKHCt2JLrdg9GTzadWnMdb9Zcj4YebgcA?=
 =?us-ascii?Q?MkEo3zEgq1gyXucBE7pTthwfcRq3BduFEXdQl69OPT/Lw1xtCF52aJ3A9Xm+?=
 =?us-ascii?Q?i0+p74wO45+QBJp1K1zu8j7Sj4Gn/Hd3btP7ItWI7ha4s7IA2tXYfFvLtnFv?=
 =?us-ascii?Q?wpgpWjtUldqMzElM2B1iEhbDLGHhL77d/0cwGqxh7E4bgueGdzsXK4rBjogz?=
 =?us-ascii?Q?jWRsSSJSPY/KbAzQeHoOs9IbZRD4JBdLzj0c/G1G70uAb0EOUfxCwwnUPuzT?=
 =?us-ascii?Q?1uDMzmatxZPZWNIU24Uc1QlQxPRZOPm3wKm+B9vDmGOs9VQHzR2uSVOWVrnW?=
 =?us-ascii?Q?7ruLDm/8ewJeB3Ufjjz3z65k3BGTmtr3DiolZP5ERZrvOOOL/Q0Vs/9hvM2d?=
 =?us-ascii?Q?93aON87Qf/D4L9Z+Qx9oH6SBP3hIlgEaoPn+i2HdwuC2B4ORNRC822B1Pu+u?=
 =?us-ascii?Q?BonmjhtWxj+IJEFeAeRzYpF/9ddPDoRqKNkMXVY1BBl1cqJTSii6DLzjpY1c?=
 =?us-ascii?Q?it19WXfDN6urN4mdyB/CaHUTTByPA9Eds/giNtJuQWZTedyVQsuulYVrXQqz?=
 =?us-ascii?Q?KOuybtwlMAuS79NPWDvK7hn1EA0jSDtW?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2024 22:35:20.7830
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9058ca05-4d2c-453e-6d7f-08dcd9c482cb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9CE.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5719

The userspace needs CXL device information, e.g. HDM decoder registers
offset to know when the VM updates the HDM decoder and re-build the
mapping between GPA in the virtual HDM decoder base registers and the
HPA of the CXL region created by the vfio-cxl-core when initialize the
CXL device.

To acheive this, a new VFIO CXL device cap is required to convey those
information to the usersapce.

Introduce a new VFIO CXL device cap to expose necessary information to
the userspace. Initialize the cap with the information filled when the
CXL device is being initialized. vfio-pci-core fills the CXL cap into
the caps returned to userapce when CXL is enabled.

Signed-off-by: Zhi Wang <zhiw@nvidia.com>
---
 drivers/vfio/pci/vfio_cxl_core.c | 15 +++++++++++++++
 drivers/vfio/pci/vfio_pci_core.c | 19 ++++++++++++++++++-
 include/linux/vfio_pci_core.h    |  1 +
 include/uapi/linux/vfio.h        | 10 ++++++++++
 4 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_cxl_core.c b/drivers/vfio/pci/vfio_cxl_core.c
index d8b51f8792a2..cebc444b54b7 100644
--- a/drivers/vfio/pci/vfio_cxl_core.c
+++ b/drivers/vfio/pci/vfio_cxl_core.c
@@ -367,6 +367,19 @@ static int setup_virt_comp_regs(struct vfio_pci_core_device *core_dev)
 	return 0;
 }
 
+static void init_vfio_cxl_cap(struct vfio_pci_core_device *core_dev)
+{
+	struct vfio_cxl *cxl = &core_dev->cxl;
+
+	cxl->cap.header.id = VFIO_DEVICE_INFO_CAP_CXL;
+	cxl->cap.header.version = 1;
+	cxl->cap.hdm_count = cxl->hdm_count;
+	cxl->cap.hdm_reg_offset = cxl->hdm_reg_offset;
+	cxl->cap.hdm_reg_size = cxl->hdm_reg_size;
+	cxl->cap.hdm_reg_bar_index = cxl->comp_reg_bar;
+	cxl->cap.dpa_size = cxl->dpa_size;
+}
+
 int vfio_cxl_core_enable(struct vfio_pci_core_device *core_dev)
 {
 	struct vfio_cxl *cxl = &core_dev->cxl;
@@ -401,6 +414,8 @@ int vfio_cxl_core_enable(struct vfio_pci_core_device *core_dev)
 	if (ret)
 		goto err_enable_cxl_device;
 
+	init_vfio_cxl_cap(core_dev);
+
 	flags = VFIO_REGION_INFO_FLAG_READ |
 		VFIO_REGION_INFO_FLAG_WRITE |
 		VFIO_REGION_INFO_FLAG_MMAP;
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index e0f23b538858..47e65e28a42b 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -963,6 +963,15 @@ static int vfio_pci_info_atomic_cap(struct vfio_pci_core_device *vdev,
 	return vfio_info_add_capability(caps, &cap.header, sizeof(cap));
 }
 
+static int vfio_pci_info_cxl_cap(struct vfio_pci_core_device *vdev,
+				 struct vfio_info_cap *caps)
+{
+	struct vfio_cxl *cxl = &vdev->cxl;
+
+	return vfio_info_add_capability(caps, &cxl->cap.header,
+					sizeof(cxl->cap));
+}
+
 static int vfio_pci_ioctl_get_info(struct vfio_pci_core_device *vdev,
 				   struct vfio_device_info __user *arg)
 {
@@ -984,9 +993,17 @@ static int vfio_pci_ioctl_get_info(struct vfio_pci_core_device *vdev,
 	if (vdev->reset_works)
 		info.flags |= VFIO_DEVICE_FLAGS_RESET;
 
-	if (vdev->has_cxl)
+	if (vdev->has_cxl) {
 		info.flags |= VFIO_DEVICE_FLAGS_CXL;
 
+		ret = vfio_pci_info_cxl_cap(vdev, &caps);
+		if (ret) {
+			pci_warn(vdev->pdev,
+				 "Failed to setup CXL capabilities\n");
+			return ret;
+		}
+	}
+
 	info.num_regions = VFIO_PCI_NUM_REGIONS + vdev->num_regions;
 	info.num_irqs = VFIO_PCI_NUM_IRQS;
 
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index e5646aad3eb3..d79f7a91d977 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -80,6 +80,7 @@ struct vfio_cxl {
 	struct resource ram_res;
 
 	struct vfio_cxl_region region;
+	struct vfio_device_info_cap_cxl cap;
 };
 
 struct vfio_pci_core_device {
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 0895183feaac..9a5972961280 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -257,6 +257,16 @@ struct vfio_device_info_cap_pci_atomic_comp {
 	__u32 reserved;
 };
 
+#define VFIO_DEVICE_INFO_CAP_CXL		6
+struct vfio_device_info_cap_cxl {
+	struct vfio_info_cap_header header;
+	__u8 hdm_count;
+	__u8 hdm_reg_bar_index;
+	__u64 hdm_reg_size;
+	__u64 hdm_reg_offset;
+	__u64 dpa_size;
+};
+
 /**
  * VFIO_DEVICE_GET_REGION_INFO - _IOWR(VFIO_TYPE, VFIO_BASE + 8,
  *				       struct vfio_region_info)
-- 
2.34.1


