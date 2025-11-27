Return-Path: <kvm+bounces-64897-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 34BB8C8F971
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 18:07:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id E4E0834C5AE
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 17:07:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 409942E11D1;
	Thu, 27 Nov 2025 17:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Dtz/cQp6"
X-Original-To: kvm@vger.kernel.org
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011059.outbound.protection.outlook.com [52.101.52.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DCC62DECDF;
	Thu, 27 Nov 2025 17:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764263216; cv=fail; b=dWHyOytQ9vNXYbV9ofkxDzBqMxaJHSt7UUjwndtfDbOIk6n9s4tjO2fEzbVAxecGTci0JYS1JCwdzUfkP4guyKsJiu7MVY2WxCse1jLYh0YCkB5kjeDeeRG340EMw1ao7LzqYb7LMDhZrT4NhUlbQROYT+GYriRgyaRYIhCvI0w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764263216; c=relaxed/simple;
	bh=bdM4gZHhCQldYWCTNEj5cWfHGKIXSwMOpuKffYMH6Wg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i2PkcR73XOix9gzEW6VeonA3WMOV9oA1npkn1oEHZgbp+vMfHrVssgBpxdJpHHGIfV8KQ/5n7uOlR4ywCAUSA11f7RNlrTDZWrG+i14hQLzLiS42f8WE3vdSFDmGlPyefsMRo7Yp4XDB5/1EMel7oqUu8DPb5+xgXSCNY8jzHu8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Dtz/cQp6; arc=fail smtp.client-ip=52.101.52.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J5hsjckp+uvO1+EmQ/ic63yxp0z6JmrR1/5Izi/RQBVOp3I+hgUbddvWozM0DKrqlBGUktTzT3havPNhGgJnQWvHsNwae9v0vA8Ww/qan9K3oEw2jEV9/VTgBhF5NrjqGuH28j2SxqAqwl3UngBi130f5sTwyhIL8XLykFY78pROVCPSLwU3fPfcH5J5PDh+Emd9pYt9lMaOYhmNVhiTxXvSfQYnhkTQoJTb/ApOZxJWKs7bvExTYuXiwYF4+tGZMd9OXZR56qAjBFNFphAM9uuVanfHKl9pXuwQLL12OymV4MvXCtdTN2BCYiAqAvIAQDKKNtlZG+r6mLXtauCHDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=82ZVQ3scoEnYFpRbXvZguSvHf+1QkmHI4zb+asYHfA4=;
 b=OaFTw5+lpczZ0aHclLwByFQPQrGjLOhzGGvXM1Cu0Hd8lyp3FCCqhP98asnp1r79s3W6HcUnizBLR9Mx1BonCd3GrraGlAo5Tv+UGV7SCn0+/FwdDAg8TSXYNoVPvElKRkPpTNU1qfJPat/WSmz2N1o3V42EP3b2TRehmWLBgyq3F5MjX/bs6FHfBg2yS/Man5jla0T9HLxcbwOGe3bRGwnyCUMMq0mO8Op1Y89I9Mt6ACezBt3CeISM/mq87SntQmEMwsoLPLCIrRyR4KEaoGTuZD+31q8R5QlaIUpDUm/GWnEBUChotJcMhpJ7QNTj5xQ6OmUytmW6wD6VPwqWcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=82ZVQ3scoEnYFpRbXvZguSvHf+1QkmHI4zb+asYHfA4=;
 b=Dtz/cQp61N5KSr7A47j95gWC4K5DB33bhybgd906RjaHOlIvE+zSfL8UzynbTcjeydB5PRoJDh43Vyu/2ehAdQkNn7kv5ojoQwT8Lr90W95QtamK2oRZPv4cwjUep3M1qHol7xvLhmP+w9SM3n9rFVB6QxotnSX5C2tw9yiCxEfzX6TSYpnvcemDB0xjBFHXKVFrfW07Ks2pMtxtaSHqx1HEOZ+/Nnq3LyeefGdOVBWjynQfOHeZIY/fCEO8rIUnThLcuebhZVNSAyGGN/B0n8L8sBxrwfinHT3SZbG3Dosa1r046jSN5k2gK68Ux6E1pr3uT+Fo3fg/3x6bIxmgcw==
Received: from SA0PR11CA0082.namprd11.prod.outlook.com (2603:10b6:806:d2::27)
 by IA1PR12MB6412.namprd12.prod.outlook.com (2603:10b6:208:3af::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.15; Thu, 27 Nov
 2025 17:06:51 +0000
Received: from SA2PEPF00003F68.namprd04.prod.outlook.com
 (2603:10b6:806:d2:cafe::16) by SA0PR11CA0082.outlook.office365.com
 (2603:10b6:806:d2::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9366.12 via Frontend Transport; Thu,
 27 Nov 2025 17:06:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SA2PEPF00003F68.mail.protection.outlook.com (10.167.248.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.7 via Frontend Transport; Thu, 27 Nov 2025 17:06:50 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 27 Nov
 2025 09:06:36 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 27 Nov
 2025 09:06:35 -0800
Received: from
 gb-nvl-073-compute01.l16.internal032k18.bmc032b17.internal032f11.internal032huang.bmc032l04.bmc
 (10.127.8.11) by mail.nvidia.com (10.129.68.7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20 via Frontend Transport; Thu, 27 Nov 2025 09:06:35 -0800
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
Subject: [PATCH v9 3/6] vfio: use vfio_pci_core_setup_barmap to map bar in mmap
Date: Thu, 27 Nov 2025 17:06:29 +0000
Message-ID: <20251127170632.3477-4-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251127170632.3477-1-ankita@nvidia.com>
References: <20251127170632.3477-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F68:EE_|IA1PR12MB6412:EE_
X-MS-Office365-Filtering-Correlation-Id: ec321a6f-8b35-4d34-d37e-08de2dd75b9a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700013|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zK2gXzOxVEqlyd5r9WSUU2YsW3G1z3Jd8C9tgfbRn6zgjuvp82fBQGBIxU9S?=
 =?us-ascii?Q?iUXEDdS2IEsFcbUNdji84FdXm3Rkpw2W3CfJzlxWUdUeqeieY5421GM1WFTQ?=
 =?us-ascii?Q?dA2z0e7aMY6I27vscf3mX1RBwE5E/d4FOP4wmcibvxLJybbd1lsKmCRBOl51?=
 =?us-ascii?Q?VLwpp7aU1iYatRSkjFAxJhzrCRtt9+CVHqJrGioODwUrLdaMBfLLerRlQpv5?=
 =?us-ascii?Q?g10VgvipzJMipFq5DK56Ff/XUuzAc8cFxuPLSMOy4KgBbuBP1jhvARx9+Sh9?=
 =?us-ascii?Q?3/97zEr+1DRZzmQXt/dsuqYTORP9PEMye+4LVp3ot4TIcogclk7Ac4ujJ2Wm?=
 =?us-ascii?Q?4QfERIwGJb7PCVRNGY9cd2xdHhnO4ZBsDJFJOvzmFMmVqp3BgtjCBzDPKCTM?=
 =?us-ascii?Q?tnUHGFcK8MwZvN2EsJjCGsImoSVQMMiNaFl6qzBaXX909uViitENdwxx4VXa?=
 =?us-ascii?Q?TEevluDuDR3tOAZ0mBqlZw3L2YSInHH9Vjs/LkQIigrNjQ/KyE6iP6uG69Gg?=
 =?us-ascii?Q?kwrHfUImfW4V6r2qn6ucPGb/5ImCJrFlJJ66v2/afGYafVVvrbXb5BzMiUJI?=
 =?us-ascii?Q?uY6xhHKYc34OdiydtsTRXOlTvHvqnZwoBAJ+C9uRNuuPJENykoMR8G3aV18H?=
 =?us-ascii?Q?lRQ3hJlyI9zk1mqTZSrRsmfFNO5uN1XmeCLVDaKWeOiah0hqAM/J+Z0ld7R2?=
 =?us-ascii?Q?5NsbNjaLIq8rNzDu9osT9dqFG88fOeMK/elo0rcVCv5Kxl05Ka8wbNVi6rCu?=
 =?us-ascii?Q?GtXLB5/KShtQrxDGq+jbycsWy4Oz5T8SXlP2w4FozoadMVMGz4ZuujNraoJC?=
 =?us-ascii?Q?Sb48E+nNPrmKDYUWlXlJHBbUacBmmZHtSmrBg9kFsZhMmd+j68TiSkA0sDIr?=
 =?us-ascii?Q?svJKFSe9jdAxQ9YMuZU1xya6kQp6ji2g5JwDZOnzJ9+1w/nmdS6S4RJWB8jc?=
 =?us-ascii?Q?1O4k9ed6lNe9PCPbGkgiqS1ZnrcGl9p4+CYATZTaRZvg9dbRLIMfBclQ8yvW?=
 =?us-ascii?Q?kYCavy1bYIjDHMAAxdjoMKKH3CzdzNq0dfapQWcQ6ocoE4m1CoF0ZqcRWiV2?=
 =?us-ascii?Q?TN9hgt/RyQjd1ZHdVFFKnOT41WBwr1QhpLuexQnQdrZQSxKbbYiand13gdZK?=
 =?us-ascii?Q?Yu4HA5Kc3lVMnZRZiJopG7m5aRRAKkSuShWdTVlHBrEGrMXP0iu6A0uY5cvy?=
 =?us-ascii?Q?buBP/STPLi6RjIBreI2vLkWY+XUrRXiBBbAC9cgT6js5Nu7gGocXDkH8JwKz?=
 =?us-ascii?Q?QintZDwrzdUDBUfyYG0k+CrmSRzUTLM4b/p+NamLMTZdLKHd/FJ3BW+4ZyWY?=
 =?us-ascii?Q?S7eZV/Zmajwegm9NZ/+xK7LuVvG33Y/H+jYiEJMKyH3PtNMFNElMAF7pOKbc?=
 =?us-ascii?Q?j63KRuvzpDChZFGhUJw/HgBzyGzjo5IsGRODY0/u4IZgKFtYodybBlNUhPCA?=
 =?us-ascii?Q?0P/WyoGEfZ+OUofDgsL0zm72qKYhUJZ1SCMgyNeN7sRHhx9cgUF7A7bJmxkh?=
 =?us-ascii?Q?iwSdsFNwCCdK6E/IYdnzb/gftyWJLSLJJoD5y/O331vIK+KnfEGHbBFjjBby?=
 =?us-ascii?Q?NaLx63Xho4syWv+cm60=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700013)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2025 17:06:50.9915
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ec321a6f-8b35-4d34-d37e-08de2dd75b9a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F68.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6412

From: Ankit Agrawal <ankita@nvidia.com>

Remove code duplication in vfio_pci_core_mmap by calling
vfio_pci_core_setup_barmap to perform the bar mapping.

No functional change is intended.

Cc: Donald Dutile <ddutile@redhat.com>
Reviewed-by: Shameer Kolothum <skolothumtho@nvidia.com>
Reviewed-by: Zhi Wang <zhiw@nvidia.com>
Suggested-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index a1b8ddea1011..54c213350171 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1749,18 +1749,9 @@ int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma
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


