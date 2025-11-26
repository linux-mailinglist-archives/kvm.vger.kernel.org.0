Return-Path: <kvm+bounces-64716-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id D033AC8B927
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 20:29:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id B2C5D352AB4
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 19:29:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22BF3340264;
	Wed, 26 Nov 2025 19:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="iZXJsN20"
X-Original-To: kvm@vger.kernel.org
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011041.outbound.protection.outlook.com [52.101.62.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 841F923BD06;
	Wed, 26 Nov 2025 19:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764185341; cv=fail; b=gzpj1ejsrMe5TssMlq5nLDGul5tMN1hvWx/b7ClLCFmFShsCILCSRuwG9dwRPzRBx8jb9b3d3zqz1+1bxKLzZKBKvtGh4lnpO3HI07TMLu41+1l9ktSH5PXpaoYa3mAt0M8pq8HmxvAi5vSc1IhPGo9+14Q3LzGFxKUcHFTQwZ4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764185341; c=relaxed/simple;
	bh=bdM4gZHhCQldYWCTNEj5cWfHGKIXSwMOpuKffYMH6Wg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R5J0Zi/XP3CPier6ii0m6Ywgs1LhcUyTZ7P6TXgd0luRzQwJ7pGjp+sFLPHI9WHQxdKAaRJ4KPh3YWEDEr2FC+bKtrHOmPlE7Az94qxOwGXOYbtjjihTzaGh9YNBPuy3CyldqGhGo1kJDRhYMieDRDhJN8Y8zp6nG1eDmatQUSs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=iZXJsN20; arc=fail smtp.client-ip=52.101.62.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ozg8BGlmaL4jk/bHR//qF4TDRCHQ4WezSOtTJa/GYeqC5a4lCBuDmGZMRNJkHU/J4o+ieWv1mh8Omyc6BEtLy/TzqXPh3dTJy+cQgueEl1YgG9GmDMg/Bf8gncpuYUa1INTgX++DswW0ScP4OO5/ip5M0pZ9n7JwEK/Yp+OaYHbmgH7p6eW8XjrswEpyUnDfrW24APMitbbj1MkYRKG9HAxtPXwSU5DJkG++LUWP9Jo0sjU3Z0wJUJJq5URrCoDsS+bbT0dhC38L3KsWH/QZ2r07KQgkLz/iVmTukn/mimy8grYYxmuzbZVfPoHrZWNWg3w+epxKQlo7Gcm2t3W5TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=82ZVQ3scoEnYFpRbXvZguSvHf+1QkmHI4zb+asYHfA4=;
 b=x2cfC5d/JVlh0vUGtxfia8a2q3nKKNVPlOTDZidwGn1SXHFbylR/O0S3f27J7EGtFQnk6ghlZ55p+8tPKApCSz7wptNJsG6Md54ER+kmOmGsNVXkZ3+mR6vvDaC93JKxcbsEMTTxyiNJjl2ncBKMKuzaiCkMZMxtFOWLv11gyjUx/GB161O5mwyvubMIUBnIyVBpfoaIPrEMadhxVlOPSIDs16gTyyk218q55NokXQLEiHZplajjXkHby/dud2aV2gF6xL4b5m4Yd+hJYXRcS+n1HSChkm2gKTDM9v489vGFVidUio07OQYLZ8eyxxfvxjuTgsv+c5u/cG7beAQbGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=82ZVQ3scoEnYFpRbXvZguSvHf+1QkmHI4zb+asYHfA4=;
 b=iZXJsN20GXY/0c8oG6/fnZaVzNjByGuvrKmlyKCMM5zt2CN/Md+xYn8RBqSRV4hMH9eD7zxyjQzDoC/+HlYqnnLjgwmM2pDE4Csuv8DCpYHhMdPkWN/7v+Xgqoo1rJhNgm17+RuCtmODAYCEzXsByWCwZmAA2LCFAGRI6SXUSUFLG4E6T39fhoMnFun/k0/fNawXOtV2bnVaJ6/doSPK6aG6Uip28Iu5R3iD295SBQIIAy+86tv4OZveglKVflh3dx1of4SKgRjVyFREjzpwmF3WYhOPdPcNtoggUXNgZmFeO1NQfM9hjumK7L1Gs/GfXGLeMZOM92S1CmzzHV3vwQ==
Received: from SJ0PR03CA0170.namprd03.prod.outlook.com (2603:10b6:a03:338::25)
 by IA1PR12MB8312.namprd12.prod.outlook.com (2603:10b6:208:3fc::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.12; Wed, 26 Nov
 2025 19:28:56 +0000
Received: from SJ1PEPF000023D6.namprd21.prod.outlook.com
 (2603:10b6:a03:338:cafe::33) by SJ0PR03CA0170.outlook.office365.com
 (2603:10b6:a03:338::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9366.12 via Frontend Transport; Wed,
 26 Nov 2025 19:28:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SJ1PEPF000023D6.mail.protection.outlook.com (10.167.244.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.0 via Frontend Transport; Wed, 26 Nov 2025 19:28:56 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 26 Nov
 2025 11:28:48 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Wed, 26 Nov 2025 11:28:47 -0800
Received: from
 gb-nvl-073-compute01.l16.internal032k18.bmc032b17.internal032f11.internal032huang.bmc032l04.bmc
 (10.127.8.11) by mail.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20 via Frontend Transport; Wed, 26 Nov 2025 11:28:47 -0800
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
Subject: [PATCH v8 3/6] vfio: use vfio_pci_core_setup_barmap to map bar in mmap
Date: Wed, 26 Nov 2025 19:28:43 +0000
Message-ID: <20251126192846.43253-4-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251126192846.43253-1-ankita@nvidia.com>
References: <20251126192846.43253-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023D6:EE_|IA1PR12MB8312:EE_
X-MS-Office365-Filtering-Correlation-Id: efc445e0-a58c-4370-9167-08de2d220ae3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|7416014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IOWbVkQ32pZQmsAoaDQqk42ri/+Z+kcnEOm4b+T9Gj610l31ZJ/itdlameVs?=
 =?us-ascii?Q?/vGEnfnwlScbeSXJtU4bh7lA01xfeRbOX8NIeMde8vEm7pfmKrFJZWDKve2z?=
 =?us-ascii?Q?vyIxGIbaN2GHxFrr6ZMMP2F8renA9MRTzO3EFh8NN5W1j/UanEbqOoDHnPU0?=
 =?us-ascii?Q?MqhNtuuwEOHX3lDPMcbRXVeXzrTDhkDYyFlk2W/ZI4fWkpubzKhHuTPvBcRr?=
 =?us-ascii?Q?gFURqAIw4YeaVtmfrcNjFXwsHK/hwbj9rc4jjIGIh8XsDiqucku7M+v6tU/O?=
 =?us-ascii?Q?i5uGodk0Zyq5qV51qb9GhmU8AhGyMya4kBhJ0rS3KuEPjd2+eL8dNYoDCo5q?=
 =?us-ascii?Q?o0/CwO9UKo/8qeTu5t3FuYi72XDOZmqSz5Iju0mZbwHbZ6xT5PQ3mGpBtr6z?=
 =?us-ascii?Q?cm7KHxPnaCYkmIfyJTXblmB6u+E0wS+Zzu4S4f2gPIN2psH4Tgu14YwtxU1x?=
 =?us-ascii?Q?ldUYMa97pfHPpgGL/yEVqsvbbHYlFqGHf2fATikHmqmxdnUFnbKrPmK6tcd2?=
 =?us-ascii?Q?XB897NZsmgdD4Q8BqVXAGZZ3XdvmSNbkCM0/G5+/t/KnGh1ykxP11vLy0rlF?=
 =?us-ascii?Q?uliWgbf/1LqjNFiNvSYT5u/bDfJg2u/ZqDe3fpx7xR7FrMyC0LTLpxfa08z8?=
 =?us-ascii?Q?1yDqfNRRwf2LRJMAzGNpoa4PyhN3jWO2HPPJQXHWjVVjrmvDY+fmSFmLyFQ0?=
 =?us-ascii?Q?YWQjQfFxh4C5mJ7J1KJNPGe3czQ0Lq0ZOV3Rv94A49dL8Xogv7abv+3y9P6F?=
 =?us-ascii?Q?YDsClhncX74LMZlA2fl7tjl8Tf++19nQOylE+Heb2HrMKoDduaKFtwqijJl7?=
 =?us-ascii?Q?LxR6m2xfVn2QqGM6rRBg10fc+4vPA+V+NjeHKDbTcZK2nv/KoW5YdlBlvfIL?=
 =?us-ascii?Q?yoiTKRn+Kz2/UgPVDS4X3O6RkI73P+qprXh7FrOYHNOA2kyKU/LkpgAkKT29?=
 =?us-ascii?Q?P7INwL4qCTQhspm5H1b0LyMgdbl1FMKwzaz6wImQgYr0Qm0bz2pkwfMkhXdO?=
 =?us-ascii?Q?pmaeucmgczGRLk/hx39a7fbXIu8Gn7nwfRUf5EbTHyMjqhyIFXeRqV1sEy2o?=
 =?us-ascii?Q?6jwkfEC3MXumTDxIIoKikHAc/8+LK1fHIuB8UrCBoUo1C94HjiZLBHEAV5Hb?=
 =?us-ascii?Q?pqjj0x+34Wwpq4vHR2qytkGic8/lOxeZCxtT6rESUfB7yw2oUy3aiwYBJfc1?=
 =?us-ascii?Q?J2WmkW+9+m5Xbj8IetblLzKjlgr0OFIlxgOzydflflbAXACaorC5kmMf8eB8?=
 =?us-ascii?Q?o1J7w6yCVrJUuahraKeMcOgxqpS54qAf/Bv3M/jxmc/YkiF3lvPhG4cDxVHc?=
 =?us-ascii?Q?c+2N8CD+FAipwbVu0JydiP8zG+82k5edYvxmKjx8S9Z1RmhBBjXjHAvA2imu?=
 =?us-ascii?Q?sT6bO/E0mG21JnalFCscr1W36Koak5ZD0UKiI5a0mXWu84MHoPTXTFrlYMzr?=
 =?us-ascii?Q?aYdYL67LukBWUWkKsW/YkndIP+Nv5vMLgxLzj0PARq5q9w/R9WKXSQFVm7eC?=
 =?us-ascii?Q?UvDTxxb2nz3ZnRR6pPjvywIBmiyuSjrXACIRDVnJS3hhECFfZ4psJn+JJW36?=
 =?us-ascii?Q?QnqLAsJEcO/8McPiP9Q=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(7416014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2025 19:28:56.7846
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: efc445e0-a58c-4370-9167-08de2d220ae3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023D6.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8312

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


