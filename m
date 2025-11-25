Return-Path: <kvm+bounces-64526-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 3535DC8636C
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 18:31:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 7AEEC352B89
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 17:31:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F18432C322;
	Tue, 25 Nov 2025 17:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ANSDcUdG"
X-Original-To: kvm@vger.kernel.org
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013065.outbound.protection.outlook.com [40.107.201.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFBF032ABFD;
	Tue, 25 Nov 2025 17:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764091847; cv=fail; b=eIJFqg2uk5dqhFcm1WCgPoJvZUZsAqpTQwbqXP1H7o1VeTaOPddnygNIGGTwb0pQF44dgbsgLZ2cbzfJkVpaHWlo0sPf3em50Jsl8PWy+kSBTG+P3H6rbxguzBkQnXB721IE8MM+Oy+FA9hB6XJy5cfxpR43MJV8+WZ8yai4++8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764091847; c=relaxed/simple;
	bh=hol7RFA//xlM/LqPJInCcpPOJb/arDFcAov1DG7a+l4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C6aU6052nwC8WfDXNQ/VRnMeq/OF0Kcv5dwFHa/Qi2WWhQWn+51DsKq0CgTl8h3PMpNwQnFmBjMTOIIKVhlcaFaltOw/oNcWRnohEYfPZDu7M/bRbAdB1xutEgiWhQ/nhVa5NKapNnaPAYHZWwDwR7qwn+0VWyo8V1Zj5eWGzpc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ANSDcUdG; arc=fail smtp.client-ip=40.107.201.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IAYql5uwWKnKpZ2CTS1iMV1GLvBKx5YqMCPPGrA7lGwpudHno4/IDz9wJHETAAxFEQYNqlS1C9IMjOp7sGPPaBUWNX4ndnM4a5KyP11mwuXVj4Kldon+Y+/uXphtlUnfMiSwr6gddVnDyZu6Xu8LQG83qG6vffwm0WlZSjE1xWNZC5uj4xPvejANTb6B4ToC1IGiMxmLoML1VoRt38ZehNzYHM4InPB5brdwDpHE30H/Ax/7FA1SVWntInVONygCMUDqrHRPDxCI2ig2dIHZBB0I0D4cC00jOn1GN+4jHTKAEcroGSIFXvysxh7+//A6jt/Unx4Y5Qt/zTEcLFocng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8n63Q8YjM2vrpsOdd5BqmpivduQ4bMuDcvJ++7KOZCw=;
 b=ZqrtPlN14mVtO7cA2LeLS5Mh3ShsuAWBwwKndvjGmN22nkkRNda5dKk1AMSb1ZG+/Hm101hG+S4cSpmWR0qHVETUjAJJca4PtyTh5YIOOf9UoX6MnAgKO6Edi9HW3vu+TmssbCo7KHLVmp/+/N6MBuPxdhQMfmOddXm6DeuRtERxSFMsQhDp4GiTS5qygPwcfTNcgi7dwTDprUb1qkiPk9P1FGsktnNcoCUo2JR/Zg0KKsaGj7n9V3o76/KIMzpce3s3BZ7GfwwdqATowDPE8hxFTyUPAwT86SyGC4bA43QD2qmurScxSUSD5iTnLgxfS0ByA/n1oQs3Ep9EFazFdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8n63Q8YjM2vrpsOdd5BqmpivduQ4bMuDcvJ++7KOZCw=;
 b=ANSDcUdGbWrBlzvvTkwGtCMkpha3Y/dJeTR/Op+Q0HbbYQfPAplV6TPOb7liu48j/9mxlidpQJ0TY4dHZd+RdsLjanjjeM4ZlM8FuJTgoZeFN4WKBI8vWXGPZMH1cf/at48qn87IEwyrtXkeGyuSPbRnDJ79njEaj0qUxvHH0qoEHsxLMw/vum8ZDgPVJrsO+ru+jI3zgoNK7dDkfU4CoLsQKyFzOlY8A83S3Uvo6AHZ2XTQWvOUIf1rglDHFJpQFy2acH17pzi5DwPsjI4VQXPWSuaDQy0Xh7VV9WKhCtqOCzAcID4AyqqIRR5onx7y8Ae3sdikvOFEttrdQ+l79w==
Received: from BN1PR12CA0023.namprd12.prod.outlook.com (2603:10b6:408:e1::28)
 by DS7PR12MB6024.namprd12.prod.outlook.com (2603:10b6:8:84::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Tue, 25 Nov
 2025 17:30:41 +0000
Received: from BN3PEPF0000B073.namprd04.prod.outlook.com
 (2603:10b6:408:e1:cafe::cc) by BN1PR12CA0023.outlook.office365.com
 (2603:10b6:408:e1::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.17 via Frontend Transport; Tue,
 25 Nov 2025 17:30:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN3PEPF0000B073.mail.protection.outlook.com (10.167.243.118) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.7 via Frontend Transport; Tue, 25 Nov 2025 17:30:41 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 25 Nov
 2025 09:30:14 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Tue, 25 Nov 2025 09:30:14 -0800
Received: from
 gb-nvl-073-compute01.l16.internal032k18.bmc032b17.internal032f11.internal032huang.bmc032l04.bmc
 (10.127.8.11) by mail.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20 via Frontend Transport; Tue, 25 Nov 2025 09:30:14 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@ziepe.ca>, <yishaih@nvidia.com>,
	<skolothumtho@nvidia.com>, <kevin.tian@intel.com>, <alex@shazbot.org>,
	<aniketa@nvidia.com>, <vsethi@nvidia.com>, <mochs@nvidia.com>
CC: <Yunxiang.Li@amd.com>, <yi.l.liu@intel.com>,
	<zhangdongdong@eswincomputing.com>, <avihaih@nvidia.com>,
	<bhelgaas@google.com>, <peterx@redhat.com>, <pstanner@redhat.com>,
	<apopple@nvidia.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<cjia@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
	<zhiw@nvidia.com>, <danw@nvidia.com>, <dnigam@nvidia.com>, <kjaju@nvidia.com>
Subject: [PATCH v6 3/6] vfio: use vfio_pci_core_setup_barmap to map bar in mmap
Date: Tue, 25 Nov 2025 17:30:10 +0000
Message-ID: <20251125173013.39511-4-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251125173013.39511-1-ankita@nvidia.com>
References: <20251125173013.39511-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B073:EE_|DS7PR12MB6024:EE_
X-MS-Office365-Filtering-Correlation-Id: 218fa2c4-d5f6-464b-f9b9-08de2c485b4e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1uDrKurS0eLPAYXhKrZ7lesfBseik0IwPRQ+AXVqI5efDho+OvzayiYfBAUD?=
 =?us-ascii?Q?9Y1II1OfdsT9kEuyPAvxfASlHE7fL4PYv0vZpFO8ZhX5n8op22qyTG58mqfu?=
 =?us-ascii?Q?Fm42UXQphCnHlcOL9Q4ouvTkCq0qDLl2HsGgxkUZbEgKCqgHdIv4tR3HVARI?=
 =?us-ascii?Q?JkuBQlzvGq6GHM/aNHzEGmH2jGQyLBkKRffFL9MoIC8ykX/gPQJRS5ezMW6X?=
 =?us-ascii?Q?KKWJMAAAyBfBuD7ZsCXVHgeUbTzFalWSt5fWE/U84mvgEpZN8O3MtR+rAje2?=
 =?us-ascii?Q?OBwGzMUZr2d9OVGDgSuDP/ABVkICZY0RSisXy+3ofkeAqmvODNf3Sj+gpNBC?=
 =?us-ascii?Q?jfXA+wOP+n6DYv0Cc3wxBjELN7uWZ1jKM9WPbNIh7RwHEThkXKPnNtpQ3wyj?=
 =?us-ascii?Q?NCWABjwN3F83Veh3FOuarMHBw/8shhs0/FvfndQUtV3E2tUw86g5gRXuyo8S?=
 =?us-ascii?Q?Iss003L4k829iIuBlNtpzeykkVUGsYHM5nB/BS5ArwARlPSVN9sFxUnjmH1A?=
 =?us-ascii?Q?EKtmmLd6aZztTSgzM5WgpaQcQjsOt/wpCUalXV7lNUqhn3OHfGLfyyLgiVcJ?=
 =?us-ascii?Q?oRHvKEGJnBabU637vFPCYp5SKWVmCkGM/jTGqiEwUFc09wYETFBHqi6+duOv?=
 =?us-ascii?Q?sYdrqd5v7Hu+lmQUfALjpyJntmrQ2B6gWWBkgL9/3xv7DjEAb2Jvia1OJ6k/?=
 =?us-ascii?Q?d9dDK+417ez1Q3Mu5JmBbHZ2CNZrVR8Bak6fhNBMQ5m6Ms8+IhnWUQ98m5RX?=
 =?us-ascii?Q?8tmqeX6DWJmUmXfo5/YflDcGg9qA1JFZikyl8EjZbhWLg8MhiE8qIOoTy/Ov?=
 =?us-ascii?Q?hFHcQ9hJ4mb8FhBxwf1O7E+aW3DFYQXw3z+Aw2DXshh1mGt0+EbcR6Z8HvPr?=
 =?us-ascii?Q?esfmi0Px+cjrJPC7IFssh/S4r7loE+vdE2RBkip5eSt6qb5Sr/ZNK0VoyCDE?=
 =?us-ascii?Q?XSC/tx2vJBTh4D69Ot/PBrwSMkAf9LUp6NeJcQyPRDpl7zotbZ08/1po4ot4?=
 =?us-ascii?Q?ouPKKKw2tCYOVK4Z6He0/fdyzT/hkeL0YyNkheMsu2kfIRcNQucsc6YB4bkg?=
 =?us-ascii?Q?otI9oEmXYi6MGyyUqQ5yKSt+JOyspFy8wKb6Vwgj8QiHwY8SdAzKeSgsPQTw?=
 =?us-ascii?Q?ZKnQ1YjTHjfasT6NL1DBSj7ui1FN9Twe2m7tGe45bXUDq0umMBEfGMIToHDU?=
 =?us-ascii?Q?6FY+ILDE+48+U2IpirbCiSY2NMi0aGeq+g/k9uZnOJkql7cTZLMV7wrIPegn?=
 =?us-ascii?Q?EkjW84R+Ti6O2wJQ+qmCAgcVDOk/Yk4eHeDhYfxMijHcflFh/E3wFLHAhQWj?=
 =?us-ascii?Q?K0qhMYcwB21593TauOc8ECaWyZbVjC4LmF4Aw1D2e6XNzFL6TBBUz1oQvWbj?=
 =?us-ascii?Q?e9OkwzD0wssLQT/LeddKeZszC9h2o8x0NZQo5Yqf3Z7ujL4zadKDpu48Hcw7?=
 =?us-ascii?Q?9btjtaAxWrL8IDqtDEj2LW4w6P+uwz3zrUerAzDdO9Dhq/Fs86Eo2msYfkZF?=
 =?us-ascii?Q?ugoCgC1eluEkkk6sSdEE+N1x1BycpyxZwd76YY1gbstHZXwcKaiqVc1TwVb/?=
 =?us-ascii?Q?fRQ6JqiAI0RD22xPKzU=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2025 17:30:41.2143
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 218fa2c4-d5f6-464b-f9b9-08de2c485b4e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B073.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6024

From: Ankit Agrawal <ankita@nvidia.com>

Remove code duplication in vfio_pci_core_mmap by calling
vfio_pci_core_setup_barmap to perform the bar mapping.

cc: Donald Dutile <ddutile@redhat.com>
Reviewed-by: Shameer Kolothum <skolothumtho@nvidia.com>
Suggested-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index c445a53ee12e..3cc799eb75ea 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1761,18 +1761,9 @@ int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma
 	 * Even though we don't make use of the barmap for the mmap,
 	 * we need to request the region and the barmap tracks that.
 	 */
-	if (!vdev->barmap[index]) {
-		ret = pci_request_selected_regions(pdev,
-						   1 << index, "vfio-pci");
-		if (ret)
-			return ret;
-
-		vdev->barmap[index] = pci_iomap(pdev, index, 0);
-		if (!vdev->barmap[index]) {
-			pci_release_selected_regions(pdev, 1 << index);
-			return -ENOMEM;
-		}
-	}
+	ret = vfio_pci_core_setup_barmap(vdev, index);
+	if (ret)
+		return ret;
 
 	vma->vm_private_data = vdev;
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
-- 
2.34.1


