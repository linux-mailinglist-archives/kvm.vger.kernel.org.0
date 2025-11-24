Return-Path: <kvm+bounces-64380-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 1350AC805AD
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 13:07:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 2EE314E9F8F
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 12:02:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADFD6302769;
	Mon, 24 Nov 2025 11:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="uKhPr2il"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012002.outbound.protection.outlook.com [40.93.195.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1943D30171D;
	Mon, 24 Nov 2025 11:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.2
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763985586; cv=fail; b=eiVwII0wa9owx3bvamn4atMiecwqwYNOKQgEhTUqF6u05lrrMC7B/jreOgiCPzWGLx5lBAhCufJpITwTT7yb4O0PDYh+VCRJSOB/bI6SYjRuWj7t4Q84T8qaSiVjKV5K1HiOEgpoi0WFbK2CCfifaKl3CjGeJATZwqZYy2vdZ3s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763985586; c=relaxed/simple;
	bh=CbaS8YbEYdLu1oTkaefa/YnRYe2+FkdQJFVWHOr4vjc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mcJdkx82g3SUWTjIXiKlxnF9ZDLhnA3XBsYqalmGeunweOXRG0aDUI+jsu9FiTPcA6vnWLTd9mDDOyqN3xd+ufHq7fPZM9xPGvP5LHUViD8710qjz73BYb9nCU+JGd6JEITfcIb7KuqI8gIrJptU1nvCY1w3ZV+qTsbFXI85flY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=uKhPr2il; arc=fail smtp.client-ip=40.93.195.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fyme7ME9SXzYGmSJaF/0/g9+pvoEpx8SFSP/YJmz05Mf1T6sDKupfM1Bu2xFSefiLkgEmHpKuut8RLULzxxdzmNHffkvda+nXjkLlG1flFxwYaxYBpfAw4/+9msQEbOa2beFRtzDDyeW3qC90PAayXTZgRVV6pEbxxadbrGWFVMv8qMwFZt9dXfcw93iBVwIgpCCfeoIMvuh+V9sseoW1hu0xihf+rAbTKqYGePsZzCwC123BseelgcwPVyH+hqtzit/AqufjGM47sjb0Ven1mC3QQoiQwZwbYo3ZSHg1kx2ZavH8JXmbYbfqi6/7au8dESKxKq33gbJcQ9kB0ARUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vo3foNOqJmiqSOyxox6xkIYxbYFUoqq5rNydFqXASIQ=;
 b=UHYj/JuEY0LBdAa7z1bGBw8/AF0oQYLMNZrYGjnFXjiiEZmvFIFnOhWEwWu5haSJw15B6J33RJdB3Qph36aKB4BF8W1N9uKT0mPB0X2L0qC8SINW6yP9yBd12KZujY1B8zUwbUkWdkqr82baCXK3WVWhDBKLhpJnmzlPepxpwzovxMNxQ78tnviGGkmbxirOgy8ZbuLFZTuj8keXw9JNDOnb6DlWB7HQYZ/SV1oeTMTSTZeRYfyJ3aeTl3n3l10Y/orBE2SQ4zsyRnvjLgfGYVVL1q0E49YjrYasPncNnzky+C+hY/VTYBwu5i4IsHT3pDJYZCM6JpMGDXmlMkTH9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vo3foNOqJmiqSOyxox6xkIYxbYFUoqq5rNydFqXASIQ=;
 b=uKhPr2ilWnMEHdqIyyBXgjWJ4OYs4GV2VGfvUU7AKpnc5BpCxi9Ngx2dKUKnXiebNQNAWmuqcd0FSb5yY55O/9Lb+fUs8oLYJkkLqkjZmSIpH1LFPkMZuQBMQ7K8VIMvhhJvNSTY/83Z7uklOVpBWXNvi+Bh1CamDMUjqV+vUDGwN0BOiiA0IFSLh2iPvJxq60vi8IvDzirSPSLvMW0P/eCRJU621JJ++PORZEduYyYD1aegxUvFqy5qEhRWvy3Y6BP88mRLH434fpR3HBqdwXBxOkmx6fjAeVbYJo1prODRcXRbo+aqPJnczdXcB6AkCh1aAj5qg6gKerEoeOczxg==
Received: from SJ0PR13CA0140.namprd13.prod.outlook.com (2603:10b6:a03:2c6::25)
 by SA3PR12MB9092.namprd12.prod.outlook.com (2603:10b6:806:37f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Mon, 24 Nov
 2025 11:59:40 +0000
Received: from SJ5PEPF000001CF.namprd05.prod.outlook.com
 (2603:10b6:a03:2c6:cafe::7e) by SJ0PR13CA0140.outlook.office365.com
 (2603:10b6:a03:2c6::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9366.11 via Frontend Transport; Mon,
 24 Nov 2025 11:59:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SJ5PEPF000001CF.mail.protection.outlook.com (10.167.242.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.7 via Frontend Transport; Mon, 24 Nov 2025 11:59:40 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 24 Nov
 2025 03:59:30 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Mon, 24 Nov 2025 03:59:30 -0800
Received: from
 gb-nvl-073-compute01.l16.internal032k18.bmc032b17.internal032f11.internal032huang.bmc032l04.bmc
 (10.127.8.11) by mail.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20 via Frontend Transport; Mon, 24 Nov 2025 03:59:30 -0800
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
Subject: [PATCH v5 4/7] vfio: use vfio_pci_core_setup_barmap to map bar in mmap
Date: Mon, 24 Nov 2025 11:59:23 +0000
Message-ID: <20251124115926.119027-5-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251124115926.119027-1-ankita@nvidia.com>
References: <20251124115926.119027-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CF:EE_|SA3PR12MB9092:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d1ef8f6-b88a-4778-d156-08de2b50f2b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?a1NBLopaF6is15vN8mv8qenYKqTbCUY3CVCPBU24W4iQ+UqeRB3OSZ38ZwLT?=
 =?us-ascii?Q?bZGQ41vnkb06Kg01+8SMHnXisF6eFWEPdiCD9kXHkitFy4SRdVriZhYl8dAl?=
 =?us-ascii?Q?xhXyqny2gDe3lfYy+rdodFVz5zrQ4R1N0F9svJ29gY1uhAhbx/F2gYZzXsDc?=
 =?us-ascii?Q?a9+yUs4tUpVhcmUEQdS00olgtw3p50/CrA8vmWt51PdYd4DnIWV9jtbVB98q?=
 =?us-ascii?Q?i6R6yvgQ0oqTGlWjrH24EsRTwDZHtMh/oTII8gADcLxKHeUyxEwVITBawM0k?=
 =?us-ascii?Q?eu21iIunDapjERUqG8qqwlm/pCUfskDaKYQxJyTzvozKQ0dEpK3yilgqSV7L?=
 =?us-ascii?Q?lrfsbmYNr5aMmp7lwAfPv9pOoshvL94zfbJ7jVZDWpgiEsCrXjUChJHfb8L8?=
 =?us-ascii?Q?mECCG69I6GvqloIiIuCOIJuGqNkkmCL8RfzHCy11qnut3/l6rcickEzpe7iT?=
 =?us-ascii?Q?BrKUqRMaEUX+GJQslgonUoUUJmPAwNN5KBGTnL9ZLk2ZVD3VVoR228fR61rn?=
 =?us-ascii?Q?W1BROrDPyP3+Sm/SpN9IjKutuIAhzLF+jPsKwp30vR2dtIMTMOfmP/52IVQQ?=
 =?us-ascii?Q?AIaMXKLm5wWqDTzuFCheUGfDEyTAaobLjJB0PHo48NJz1LC817VTFPWEY50X?=
 =?us-ascii?Q?2R81PaGcVXXMAMqsDzqJjb1xyhjCwetZ1qLPk/vMGb2laQQF1KRIDIc6KOHr?=
 =?us-ascii?Q?BvbqlVsXqKCpeXqr1YZBEF6VnbDbA28BA9Pu0+a5h67juruWHBtWtMnfifxe?=
 =?us-ascii?Q?7jQ/wY/jmjU5DgG56xwRV3pqJG0oCraq0IewehfXGZL+p9o2nftfefae6oE6?=
 =?us-ascii?Q?zTI/lJXVPdpUsYUKcBH4g0gvNSBdbDbrcInGFfERBOUyxcEItKLnDKSTO15A?=
 =?us-ascii?Q?APep6KtdlSJGH+wnaHUpaSJXE+2PEyQ7f3q3Gk+47mKLzV68p6HSyH0DRjDv?=
 =?us-ascii?Q?5oodsBa+CRcmcBlvLnw48Cw5QRp8m3sKbHtuWTjjsCsoj8dPYqDLbEI+v9HC?=
 =?us-ascii?Q?cxBJx5/Tb8M0232eQvEQjQUZKO8K2hdb8MzhL2Aamd3seDT5i+B3JHKEBIjz?=
 =?us-ascii?Q?bDUIU+PHUh0rCFEWLNmtbULUEMIX1q5yU9MW5c93P1+WLBOw3UxPk7USf7hg?=
 =?us-ascii?Q?n5BgR9/YTqLNX2BkOUhEO4UqNqqSLgzCHFCCqnr4BThp3ve6t7cBV+y7NCv4?=
 =?us-ascii?Q?obqXax3J1F3N0jhNKn0iUknlyhmB7+nzWYR3nsPFyUFii0LHhpkBGSJrD3/P?=
 =?us-ascii?Q?kEw/Pq0mmuO8utBfgbynAtDOYJVVrZf8Dxp1BHN9CUBX8JHmA/V/vcc6e5jL?=
 =?us-ascii?Q?AUHrOzZQzl2YR89GpzBivBuU8s86MbNT4XzXrSVLfn9xLp3Q5TOUV5bxrB6+?=
 =?us-ascii?Q?z6FwaSkUK8lZjMqYounb/0lhYp30mWg6kvNb7ApB6PI1XwARVKrDByimrQES?=
 =?us-ascii?Q?D5uF4/24QN3CNP6kGPv+Wfao0P2QqpeVvk3SVlV8vdmy4pVynxEQ3jV5Cmhv?=
 =?us-ascii?Q?Z2Jyo1i941w53djOJOWbom5sn09aQioNgFwTx3VhFfxThiabTgxH+RAnBuHN?=
 =?us-ascii?Q?tXILeI0q7bWYXaf+RXc=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2025 11:59:40.2153
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d1ef8f6-b88a-4778-d156-08de2b50f2b6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9092

From: Ankit Agrawal <ankita@nvidia.com>

Remove code duplication in vfio_pci_core_mmap by calling
vfio_pci_core_setup_barmap to perform the bar mapping.

cc: Donald Dutile <ddutile@redhat.com>
Suggested-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index ede410e0ae1c..3d21f6a8c279 100644
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


