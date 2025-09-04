Return-Path: <kvm+bounces-56734-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 91146B430E7
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 06:11:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 370314E26F3
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 04:11:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4319E26A0DB;
	Thu,  4 Sep 2025 04:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="aSDBu0gQ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2044.outbound.protection.outlook.com [40.107.223.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9210125A65B;
	Thu,  4 Sep 2025 04:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756958929; cv=fail; b=BlZkNQy2GZoDqL5p1Azmj7z8Cxr2VMFl5OBgNRwNn8SJ9zQ4PTG4x6YqI0PzZMssBmwEyYhtf85CLU7HipB7zjwvgSW3Q/UmmqQtRjkIUdiEOz0mLXx+Hiv+ub/07ojVBh+tuW2Vqo39fDCmu9+PsIozRjy5AXN3d2ZdaK+2UCI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756958929; c=relaxed/simple;
	bh=zOAXaHa/xO5N9QYTZEPrDXfQ9I6bNF/usDo6ghY65qo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j0moJYLVu4AAWkaT25riCcpdLTGifS65U4Eyjk3miYkhMCB/L6PjCqaA6oVBuu+th0Lk+pkY0Ueu/1NBhWEGmTJWBjOy8PFgIPH48jInNm/zRficOQb/Zj/TKoHI4WA9hjeVZXs+wQiV+XQzFj860zeE19HXg1iJEJgfdRfO/zY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=aSDBu0gQ; arc=fail smtp.client-ip=40.107.223.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z9FGyi8yvpcTr5sskl7d9APsLyBvQzW0uy82FZ0ZD9liK6MtxtUE/tH+jb9c495l/7agN4R6CVnJM3thCR9d7o/NBYgJi8Kg9ZEY32uk0QHlN1zMczw+8pS86mNMnGXF89rz/ki8GTdh4kF5Cqaujdhp2xMg8emB5Nq1n6QmqxiF0WDrV++XtQEYAcOx/DkL/j3fbW4g1CjdGcJcDATAkxyE0KJVd6y2gD/PAtquaR8t4lklLqyA7Pk2HnLKJGnL6V62yUL1OiRGrvXewfH8lU+pXgjn4sEDqd4PAP7/uWlq+sXmlUbfcBKf9ArX8EM420hocZK5biHS6d+ft+rkew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5LxRM8U49l+wWLu1IBuPy19Urz8r7McS06JfqfyR/lU=;
 b=TfPe/kiCkgOZyd+QWHrPj+RhTY3wI0sTbymaBCqxPxNNyqRWrvNBxTrOC/xSi/0bOjzQsWln9RMBx+AIqEVusI1MMNH/ZU5NCoQCCDuIsvWyGsTlMt4A8VX2ypuOHfEHZx39YdNOQ08wY3qvrks4SW979b4/U+Lw0X1WWitE/UbDK0Ai9x15qa2XBGM5HfTFEGnLtUkCO6+l2BxQV5sRe3UlCa7xQ1xT18mPetFyyYdCSRG4wOYj2jn1CDHvkDPElJzSq+eo2emJM4PVEWMzaXbr824VHoHx3p0K0mWbpZUFQaVI8W5vDDqZOI0grdv2hu/BRLOBsnnxqGKiybwecA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5LxRM8U49l+wWLu1IBuPy19Urz8r7McS06JfqfyR/lU=;
 b=aSDBu0gQ7mEdy2DQMNb7ogRWn0/YEuOuiV0V3Y7HrXpBg4mzSv5WHH5efhkcG8KZaJr/oGQq1zwNvT8yYdRbETOR6gSVoUY2ue+E6R44lhJ8HKl8CplBnnnGpcaHc3nsVZPs04jTwx4fVNdmmfKgSTiaa9t3lWX3QzasnwGnirlmD0RedDsvwiixYyxt4/VIpbpvQBxqIagQHuHKrigrFrUAvoGFPqo+TghGMXc6AGu0HqgU+tmi4dqcwTbEpfeg4iAk18BDELt6JmmYlu7HTQOkbbiFsSGO+bHaY1rLatz/eimWHr7YEbf+PpptKiib0gNvUTwU8QsQ8bkWYSYmNw==
Received: from BYAPR03CA0016.namprd03.prod.outlook.com (2603:10b6:a02:a8::29)
 by MN2PR12MB4317.namprd12.prod.outlook.com (2603:10b6:208:1d0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.17; Thu, 4 Sep
 2025 04:08:43 +0000
Received: from SJ5PEPF000001D5.namprd05.prod.outlook.com
 (2603:10b6:a02:a8:cafe::21) by BYAPR03CA0016.outlook.office365.com
 (2603:10b6:a02:a8::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.16 via Frontend Transport; Thu,
 4 Sep 2025 04:08:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SJ5PEPF000001D5.mail.protection.outlook.com (10.167.242.57) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.14 via Frontend Transport; Thu, 4 Sep 2025 04:08:43 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 3 Sep
 2025 21:08:34 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 3 Sep 2025 21:08:34 -0700
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 3 Sep 2025 21:08:34 -0700
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>,
	<yishaih@nvidia.com>, <skolothumtho@nvidia.com>, <kevin.tian@intel.com>,
	<yi.l.liu@intel.com>, <zhiw@nvidia.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<anuaggarwal@nvidia.com>, <mochs@nvidia.com>, <kjaju@nvidia.com>,
	<dnigam@nvidia.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [RFC 14/14] vfio/nvgrace-gpu: Add link from pci to EGM
Date: Thu, 4 Sep 2025 04:08:28 +0000
Message-ID: <20250904040828.319452-15-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250904040828.319452-1-ankita@nvidia.com>
References: <20250904040828.319452-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D5:EE_|MN2PR12MB4317:EE_
X-MS-Office365-Filtering-Correlation-Id: cae901b3-d08c-4ea1-f7e5-08ddeb68bd00
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nXwEnFs+canT1IebrASUB7SsjBDSVkXTPR2Mrw4i/zZTn8VcL9LLOfo2TKJq?=
 =?us-ascii?Q?nWvd11zPr/9u0JNahIsWeMcipOR889rvJN3F5JkuEwVL37yiz9lZdudH3Paq?=
 =?us-ascii?Q?uXo7prTzxZb39w9uy/hUH3BylChcOTxLFaHnb58sii9ctvyweSZMzUHpACEe?=
 =?us-ascii?Q?J6Li0bxOyr9rnrmdmxVR9Xqp1LKl9fTRa9zpnGewp0YM9vxBZ8z/jtapuioL?=
 =?us-ascii?Q?qrPUIEM2snt4JAmnNg6Kn4wQBw6109FEOq09WaDikn6blgMCt/Lsf0YsPr7m?=
 =?us-ascii?Q?j5/J2YiJkpGXHXy3fF3JGRGbGbi1DwDjaaXhT53FUx2e822ozFsrcHiM7+zt?=
 =?us-ascii?Q?saHTP7OSCt2sXB3rB4d06kMlFDCOQ2pMMrQyDZKSg8VbwM/qqRcKe3vwAyjN?=
 =?us-ascii?Q?v646xnmCExxmeaCgns0JSlrsNYt0gwhaHnCPHKxwH1Ya0PoydP6cyoowTrio?=
 =?us-ascii?Q?eausFMrxHyJbIVMNOmh+/OHEvAKtquUbOMSlf8IeoVs9YAP/OPon25v2oRMz?=
 =?us-ascii?Q?94bQO9gPHlGbKLmMxaZ6ruS4537q5EL1KEUfIEu5wGqqZOTsQIB2xqourrLl?=
 =?us-ascii?Q?AHCbYL5335SVScwBt2jcgnizIk6VQgBErrE5LGKCYlAnVFSvPffF5NP3e1/D?=
 =?us-ascii?Q?374nBS6zXHbvpExj1OWVTzQgZ+sxPC3ZR/ux0z7CY1bS3nWEXq912K0nzC/X?=
 =?us-ascii?Q?8ci0N0VeW4p6CQtJXcfv1zuoWYGjRNK8PJg0WrTi9am+Lbv6LrSDMtb96ruv?=
 =?us-ascii?Q?e9UIjg0MVEGpQQvEZm1u26Wu4FfouNNX8abrpthc6OwHkg/Ss2I+YrXhqJl1?=
 =?us-ascii?Q?+VeqWkt/NvYTarUM5SpLDyLgPIHObQcr+5bs1mE853wLpO9Yrk3Wzr6xPw75?=
 =?us-ascii?Q?Ubf9kDT2fYnFtQlw31mmbC3tkCWGjNU8LWWVC0HKjJMG4xBSPzhAS/Rbxhrm?=
 =?us-ascii?Q?daD9Yq0QUzV6sFEoUp+UJlb/eKHcOAM4DCxGX8R0kjy4T3r0Gl7tb/WqlE57?=
 =?us-ascii?Q?sdc21p5hbzJv1BK/MgKumugb8/7jwk1fXYDBmfehb+X0A2H9Yf9dGQOxikXc?=
 =?us-ascii?Q?w86EJjRyNTt9vmyyydZ82eSC7N1/iHi26e7+egjhX2TCy/CAmnqrGeVf2k8u?=
 =?us-ascii?Q?rYuRNbDf/5rPRIbhj+qkM4l36OIvJ+c5m7S+I8XEyF909sdhKy041WQm2TXa?=
 =?us-ascii?Q?yijPcNeEWZdOK7V+M3M7d9ljELbSG4RayNSkPZYoNKHpkbYG9kSUdA9NaKdp?=
 =?us-ascii?Q?aMne6Zp0H1iZ8N40nHOgpLmHPGYwv22ou1ld11SKVeRyPsysanbfKt5vnF6u?=
 =?us-ascii?Q?17ZBE6SNVOB722aWE1Bbf1OGS49tH2jKb1hr0SR0r0Ly/AMFMpggXJmFnM7p?=
 =?us-ascii?Q?IFMGMLtIUWjyqa4uvUyGXp6X8eqIi04j8AxYphk9eqCAWNMDmt9UyPo7Gau0?=
 =?us-ascii?Q?RnyPCQ6iVEuvHIbKQ7Z5O9R301ydMVRM68v69LQMncDeyjd1uo0Dikmh3aVH?=
 =?us-ascii?Q?BFVn2373afAE4+W5aA8qkI7eoOQboIcusNEo?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 04:08:43.6267
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cae901b3-d08c-4ea1-f7e5-08ddeb68bd00
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D5.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4317

From: Ankit Agrawal <ankita@nvidia.com>

To replicate the host EGM topology in the VM in terms of
the GPU affinity, the userspace need to be aware of which
GPUs belong to the same socket as the EGM region.

Expose the list of GPUs associated with an EGM region
through sysfs. The list can be queried from the auxiliary
device path.

On a 2-socket, 4 GPU Grace Blackwell setup, it shows up as the following:
/sys/devices/pci0008:00/0008:00:00.0/0008:01:00.0/nvgrace_gpu_vfio_pci.egm.4
/sys/devices/pci0009:00/0009:00:00.0/0009:01:00.0/nvgrace_gpu_vfio_pci.egm.4
pointing to egm4.

/sys/devices/pci0018:00/0018:00:00.0/0018:01:00.0/nvgrace_gpu_vfio_pci.egm.5
/sys/devices/pci0019:00/0019:00:00.0/0019:01:00.0/nvgrace_gpu_vfio_pci.egm.5
pointing to egm5.

Moreover
/sys/devices/pci0008:00/0008:00:00.0/0008:01:00.0/nvgrace_gpu_vfio_pci.egm.4
/sys/devices/pci0009:00/0009:00:00.0/0009:01:00.0/nvgrace_gpu_vfio_pci.egm.4
lists links to both the 0008:01:00.0 & 0009:01:00.0 GPU devices.

and
/sys/devices/pci0018:00/0018:00:00.0/0018:01:00.0/nvgrace_gpu_vfio_pci.egm.5
/sys/devices/pci0019:00/0019:00:00.0/0019:01:00.0/nvgrace_gpu_vfio_pci.egm.5
lists links to both the 0018:01:00.0 & 0019:01:00.0.

Suggested-by: Matthew R. Ochs <mochs@nvidia.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/egm_dev.c | 42 +++++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/nvgrace-gpu/egm_dev.c b/drivers/vfio/pci/nvgrace-gpu/egm_dev.c
index b8e143542bce..20e9213aa0ac 100644
--- a/drivers/vfio/pci/nvgrace-gpu/egm_dev.c
+++ b/drivers/vfio/pci/nvgrace-gpu/egm_dev.c
@@ -56,6 +56,36 @@ int nvgrace_gpu_fetch_egm_property(struct pci_dev *pdev, u64 *pegmphys,
 	return ret;
 }
 
+static int create_egm_symlinks(struct nvgrace_egm_dev *egm_dev,
+			       struct pci_dev *pdev)
+{
+	int ret_l1, ret_l2;
+
+	ret_l1 = sysfs_create_link_nowarn(&pdev->dev.kobj,
+					  &egm_dev->aux_dev.dev.kobj,
+					  dev_name(&egm_dev->aux_dev.dev));
+
+	/*
+	 * Allow if Link already exists - created since GPU is the auxiliary
+	 * device's parent; flag the error otherwise.
+	 */
+	if (ret_l1 && ret_l1 != -EEXIST)
+		return ret_l1;
+
+	ret_l2 = sysfs_create_link(&egm_dev->aux_dev.dev.kobj,
+				   &pdev->dev.kobj,
+				   dev_name(&pdev->dev));
+
+	/*
+	 * Remove the aux dev link only if wasn't already present.
+	 */
+	if (ret_l2 && !ret_l1)
+		sysfs_remove_link(&pdev->dev.kobj,
+				  dev_name(&egm_dev->aux_dev.dev));
+
+	return ret_l2;
+}
+
 int add_gpu(struct nvgrace_egm_dev *egm_dev, struct pci_dev *pdev)
 {
 	struct gpu_node *node;
@@ -68,7 +98,16 @@ int add_gpu(struct nvgrace_egm_dev *egm_dev, struct pci_dev *pdev)
 
 	list_add_tail(&node->list, &egm_dev->gpus);
 
-	return 0;
+	return create_egm_symlinks(egm_dev, pdev);
+}
+
+static void remove_egm_symlinks(struct nvgrace_egm_dev *egm_dev,
+				struct pci_dev *pdev)
+{
+	sysfs_remove_link(&pdev->dev.kobj,
+			  dev_name(&egm_dev->aux_dev.dev));
+	sysfs_remove_link(&egm_dev->aux_dev.dev.kobj,
+			  dev_name(&pdev->dev));
 }
 
 void remove_gpu(struct nvgrace_egm_dev *egm_dev, struct pci_dev *pdev)
@@ -77,6 +116,7 @@ void remove_gpu(struct nvgrace_egm_dev *egm_dev, struct pci_dev *pdev)
 
 	list_for_each_entry_safe(node, tmp, &egm_dev->gpus, list) {
 		if (node->pdev == pdev) {
+			remove_egm_symlinks(egm_dev, pdev);
 			list_del(&node->list);
 			kvfree(node);
 		}
-- 
2.34.1


