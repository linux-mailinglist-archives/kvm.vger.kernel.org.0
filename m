Return-Path: <kvm+bounces-64600-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 21571C88252
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 06:27:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id C62B635260B
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 05:27:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 840DA3164BD;
	Wed, 26 Nov 2025 05:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="EOi1dG0N"
X-Original-To: kvm@vger.kernel.org
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010071.outbound.protection.outlook.com [52.101.61.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B7031577D;
	Wed, 26 Nov 2025 05:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764134804; cv=fail; b=D9KyiaiNkwx6XQfdfT6QceAVbsYCrkaJqnEf1E4sAzaRebmQeIvh8lUXZMM/A99SHa9Yk2muwSuI1bqi4yOspjj/gNu4MZjcb0CirwapbTDpGA2WBX082hjgrv0nQ5nZoHrnJgaZfAt7WV6notYqFHjWakNNraCTBDfDLUNHOeE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764134804; c=relaxed/simple;
	bh=+S/6BKJtvOh2ey0qN2/c3UHq2j1w/9tR5VKpZTvN2sk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JlfMotDGd9RUtv9PFhIH1wQ+UxtvQGRD/xtgCQx+RxL7BSoWtGt6lamh9iCGCXf2AEOqKxG31tvw8fInwMsWFO6EH61PMHv+NiXkgNs9MKZOKCFonc3ZNnRQtAPSRdzj8BBHpEvDJj1I7P3MlGN3/PMQSwuIp91Y9iQZRNPgYZQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=EOi1dG0N; arc=fail smtp.client-ip=52.101.61.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KtPIvvBBmEcfz5JRpEReo2DOoM5iKm81n/p5uIudn64DRoh0XDpVwucIXDa5m1AExljdil7KrOvsz3aR3U1CjThxdyEj8hK5jDKM7w7FhUgPJ7gz4JhaKS6G8k+PtODmWvWH6+eId2ubbnp9yqGUFs7yUjQxYIbK8LSRcmUhMTem5GWE33N2E2NWOL74EpiYQbfSfRn5+FOAseBzg9sLONSAMTGACC7WUAnpitH4A4Bruj+Ipm+dqi5bGYVSi8QtU8ln5p6DmkYhFmUGnNNz8TITXOFvGogo+uPtjVQ27mnkoChoEVAEpLEsYlFWyrg1v3LkDmLDAAFMJG0XiWtlVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6Uk2ZRurX8rCK1Lq2FyQX5A5dKvcIf3XnMSYryKsndk=;
 b=gWjz+OBU+8g9D9vqV7ak+Uws/gTbQwxcgW5syVQkE42YYufiGUXv8Dn4nVdNF2dDDjNG9r/x+itT/OaMCTKSkSxqgFDFpMjQF4LEwWRee+6n1FyTR07B9YTDmOZbVNt0Xu/cV0hoGU/yz4PYgmHhGD1qfEMZCNrjCl0FwvgNPe/4ebQLtX0VHKo6ow3Q4QO0r9hjRKREAsNpenii1/czPXoW4LDOAGeESV+fMEoYBbNwr0a8Mzw9fd2l4ldioN3FqOZJebZi6uxOQXE0ko2JOJJaXcDUBIeQwHEc8AE9fhm9wexPiGYQIzJ63s2NLNDHyHKxQY+EUR68jIptBUQIew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Uk2ZRurX8rCK1Lq2FyQX5A5dKvcIf3XnMSYryKsndk=;
 b=EOi1dG0NiACSB4xQqGdq5g7HGalzpSF1uoSgEQg8Pm1EzFe72oc2oP/+Cm511a0y27MbDCGj3Tlb2AB6gBWpstli6Ogbt64OhDRxFs7eTjKt8Nk0SEJfEeqo3qS6m0LKNDwy8hs5DVOh1hPpZgyiqcC0oXROwKc+rPk90i9ST/+5+QSgIsOZJ0EVcIHsKCu/Nvn4NMjgwx5+9fxbe/eabaT2NzcWdSEbuukQUFqffakMVifaGl/mYJcnmHpIv2WXRgKawjcLxha6+iALgB9opj1/d8Jt6sV9X+gHVcKxv0yY6/cPmWV20Q+XTVgxy6M0+e75bSc6wR/Y+Jt7NWBqPA==
Received: from BY5PR16CA0023.namprd16.prod.outlook.com (2603:10b6:a03:1a0::36)
 by SA1PR12MB999109.namprd12.prod.outlook.com (2603:10b6:806:4a1::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.12; Wed, 26 Nov
 2025 05:26:38 +0000
Received: from BY1PEPF0001AE1B.namprd04.prod.outlook.com
 (2603:10b6:a03:1a0:cafe::ba) by BY5PR16CA0023.outlook.office365.com
 (2603:10b6:a03:1a0::36) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9366.12 via Frontend Transport; Wed,
 26 Nov 2025 05:26:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BY1PEPF0001AE1B.mail.protection.outlook.com (10.167.242.103) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.7 via Frontend Transport; Wed, 26 Nov 2025 05:26:38 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 25 Nov
 2025 21:26:28 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Tue, 25 Nov 2025 21:26:28 -0800
Received: from
 gb-nvl-073-compute01.l16.internal032k18.bmc032b17.internal032f11.internal032huang.bmc032l04.bmc
 (10.127.8.11) by mail.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20 via Frontend Transport; Tue, 25 Nov 2025 21:26:28 -0800
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
Subject: [PATCH v7 3/6] vfio: use vfio_pci_core_setup_barmap to map bar in mmap
Date: Wed, 26 Nov 2025 05:26:24 +0000
Message-ID: <20251126052627.43335-4-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251126052627.43335-1-ankita@nvidia.com>
References: <20251126052627.43335-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BY1PEPF0001AE1B:EE_|SA1PR12MB999109:EE_
X-MS-Office365-Filtering-Correlation-Id: 7fc9b7c0-58a0-4fc7-88b6-08de2cac5fc7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zq4SytZmz431sRFMys+gtOAFle8rWhxMk76E/8saZmhid79DHuPPmoVgxGbG?=
 =?us-ascii?Q?0B5sewW+u4iAjuzaaWdw9z8t1Yk4CQWeU3TK3/CJWU65rqTiE/hqAAkdX7yR?=
 =?us-ascii?Q?B69BiNbwiy7CTZO2IuMFmw3nX3heButGF1k3/gukqmfs3etjTM82G91CqjUJ?=
 =?us-ascii?Q?Pp+I68aSgOtv0l8i3bW/x3GuQqLAd2MukuFWYTBYFubvB2sRk9acvlFkO9Ui?=
 =?us-ascii?Q?luzKkob3Fs0rYluARm4w1lCDpR58gg0FY1O4bwwloQT6MQIRPoCG6U5qiIIv?=
 =?us-ascii?Q?dZMav+foc6S51kubFfhFlwx2AkNN4HjO1r6PmBz2qZkGOzQZ6yfctLHkCCZp?=
 =?us-ascii?Q?AHX6w6wR0muI6yKslGPS9qCcQvFqmD0g2lGVTS5kW8Ch34gtGEyX3VrS3/Ew?=
 =?us-ascii?Q?6uNT6sQPxM8B/8AzPCl3cUVROJmfJTxke37iATBnifdvN4qg/O2nYVfGUIYv?=
 =?us-ascii?Q?5feu5gbI6Ab2eqPbFLD+/C55AiUtqWJS6lbX3rjDYHOZlK27MQse1yPgaBkK?=
 =?us-ascii?Q?b2cn1dUB+jFBSsGz09ROA7L83x0E3iH3t16ApsH5QIfat7pqCeNKYUBRzcj/?=
 =?us-ascii?Q?Ip1rPXtub2/fWkqoB1kXTqLlnoBLCFZufr83arLhZVu+w8Fti7yH4Jm3oxcI?=
 =?us-ascii?Q?uGXvQQOsD4MIrnHK1SS9k7frGQE1vCTkymouhE4E6ulmTSWjePV0nFWp1i2S?=
 =?us-ascii?Q?IR+vL6W6DPVrE7t2ag2Zvyjv4Vkc3lD/x3V/xx5iZW00OgEmo8yqP2Gd9hEu?=
 =?us-ascii?Q?AoM4grc2WOfvmkw2SadfJpJC9IdJVFbSZ+z+0tBx66WwC70N6gIKGU0ZY4iu?=
 =?us-ascii?Q?gbDUWEhmvpAxJuPXO8jL/noqtE8KMF2T9RBKV6Ysh3Ypmuc5qHLes8LMqRsD?=
 =?us-ascii?Q?RK3mJlEZekssuq3QxbNvOMrti/u0FhwjNjHcRDPQ/HPhk3I6a6rpSOSDDf7N?=
 =?us-ascii?Q?YULIfOiXghiR3fGblZHFPvaxoo7w3oHvx/tLuufYBdIRhyblSoRgfZWlt+uM?=
 =?us-ascii?Q?AzKjhpS2XxP1qvzK20wlduP2r47DqPbNDu8Mxz53mD+u8gm/zINOPU/Tg3H0?=
 =?us-ascii?Q?3MgLAt9lYUTqwWRxJZgRCDv9Arsdr0YKUOFrJnlmXmbcz6X+bLNNTDBk2CM+?=
 =?us-ascii?Q?jOCVDi/b23CE5QGJxgMbTrt2ZDZJ/ILsqrboPm35KPNnR8bv+FXSyxPrhoS4?=
 =?us-ascii?Q?XN1sVgDP+hTftOJiKaAOAwHmVnFH8id5+/94lZ9UB85VP2IEqAT+tHWm87y+?=
 =?us-ascii?Q?rQAjqmlA6MHnlmtXc4vDuB/1gipTFivmzDGp+RRvgJRSmB4sAKztRZMbJlR6?=
 =?us-ascii?Q?++rnuF83FBLamrF/lTwaB5ieLROQFcT/dUHimW6l4jt4pZFRapBbyXqrVLqD?=
 =?us-ascii?Q?a0DGm3zjf+/TR7pZBcqse3cF1xlnwGaB0uVU971gLh2sMNuzY7147/venG3F?=
 =?us-ascii?Q?CpZGfjdoevw58nr7c5uPlpk07NJ6ZVCHLmdzAiH/tN3Mil3sRt1NGDGpUJp+?=
 =?us-ascii?Q?qmFt4r6cI4kXcdxYmfFgZdHGTO8zP3xt060wwoNQpKN75d43aSKV5tgqYpkJ?=
 =?us-ascii?Q?TWse9SXE+MaNDualuJo=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2025 05:26:38.5928
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fc9b7c0-58a0-4fc7-88b6-08de2cac5fc7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BY1PEPF0001AE1B.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB999109

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
index 52e3a10d776b..020bf3aa22e9 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1753,18 +1753,9 @@ int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma
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


