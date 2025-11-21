Return-Path: <kvm+bounces-64133-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FAA8C7A071
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 15:12:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sea.lore.kernel.org (Postfix) with ESMTPS id B9F212DC2A
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 14:12:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70E6C334C1C;
	Fri, 21 Nov 2025 14:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="OuCXrxaM"
X-Original-To: kvm@vger.kernel.org
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012012.outbound.protection.outlook.com [40.107.200.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD8672F8BCB;
	Fri, 21 Nov 2025 14:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763734332; cv=fail; b=pcFRDclL2jQn/5Fef4q0nMnbkUY3WdBl0MU91bMkQ5zpcSMrn0kURCKSpoFG+4+YDgxI2OYqVWn/GhWFfbU7VVTPA11P2fWaNNvuk2By2+4ZYRIMN7m4p/1ZEBBVKLTl248EHJn5AxAVbEemSaM6PVYYqzOBEGFPD91VBxDZtAU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763734332; c=relaxed/simple;
	bh=s4HOoPpw+F+uz/UUWetkyfr/GLjgmA2Hy6U7sCP17qM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h4jj8nsLN+wt5svtVYOGxTlSMZuS1R+RGArPhsQnXoI3gfBzdaRufY5/jrn9HI3KmYjn311wFRPrLn2x6PxohgxzO8FxVoJSRVKGy5pehn1D/Wv+TQHVv2374w/03o3+FIKpg3iWJvBznDn7csSBFdRZXOjlmfXh6DQO/nTJah4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=OuCXrxaM; arc=fail smtp.client-ip=40.107.200.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DcgasWrpTdNJN2C00dyEigh5W6zs5z4olvR9fHMytfoLu52Z/j87r5mO6DIVZCvv36dfwFJrMKXAPlP/gA+sCWGj1HT6RxJeBDoCr99MWSyPHIAzbWPG8rD30nVdg//tWsfw9XG2+k5IGuUg79i7gLxD/JyshEepWRpEcMhytQzki6b8az7wTKnePHmVvmGtN0caxbLoVHmJ8TsH94JlzhsItHvSjot0p6sXPXSMOuIe4VbFRG47hOx5DRe79xJDBVd4mThqEnCXbi+zEupnRxfZm64UromZg5sIeI/XeTQmOQY6OIPsA2mZPNxTDHpjCuTNUijz5ap/bWHDn+YyDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r+jXZfFaj/mBZfU6QapQukJMNEemAubukfYwvP8TYRI=;
 b=kumw95BCSx5SS5Ja6Jp/K+HnHkKh2h4ARVl/tniSZo9EpxgHCfOP/nLykeWj381Qt9CWte5ZrWX/DhLOKr1LeZV8abQmpv9SAevITVRkd5O/YgLwGYrDj8YdNG/nGTaEkt2XSNA2aHvL317L6F6x0AjuN3JrMfd21Qlf4iDQIFe4KYn6UwLqEOGUuLjHv7uOqQg8q01YM8iUJDckvk0vak9UL7NQL7qPrCrojZefVoOkMAzrugthq4tgv64neZp9Xjzq+OfbVvMjMcvoD3h0oLFFVCEfz6jEoS3WKYb0pyMGfllGvwDOTjkVi6dYqvmeDC3hW4H+f2IxxcFKASCOHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r+jXZfFaj/mBZfU6QapQukJMNEemAubukfYwvP8TYRI=;
 b=OuCXrxaM+gRhsbdTbtL8urbt6hZejCQzjHsBnyS58woxHNB9UcFD4b+t+lRofNJSKPnV5L5ZxF68BBRJBDVPCCaZZRP+na4HfRwbdJSWWs8GEc7oZ0rZIlDtOgnakfCoNLS/1v+YG+A6ptTlQpIHTAopOUhIQ2PNUruvk3erdNODOFHvVswgVp92T/zusoSqIHDTFBceU2QJno5mhSRUqabMdcoC7P5wjzBndpC4yU27k8gSlpg7fVp/fR7n4PdNPH8Knvvfit6VsRabgVR8jCOysQYn56gJivACqGvbIfocnJ8YBHqwQVCOJ6hQTeExTtWl5wUJco8EniQrvcEUDw==
Received: from CH2PR14CA0033.namprd14.prod.outlook.com (2603:10b6:610:56::13)
 by BY5PR12MB4068.namprd12.prod.outlook.com (2603:10b6:a03:203::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.14; Fri, 21 Nov
 2025 14:12:05 +0000
Received: from CH1PEPF0000AD74.namprd04.prod.outlook.com
 (2603:10b6:610:56:cafe::3e) by CH2PR14CA0033.outlook.office365.com
 (2603:10b6:610:56::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.14 via Frontend Transport; Fri,
 21 Nov 2025 14:12:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH1PEPF0000AD74.mail.protection.outlook.com (10.167.244.52) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.9 via Frontend Transport; Fri, 21 Nov 2025 14:12:04 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 21 Nov
 2025 06:11:43 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 21 Nov
 2025 06:11:43 -0800
Received: from
 gb-nvl-073-compute01.l16.internal032k18.bmc032b17.internal032f11.internal032huang.bmc032l04.bmc
 (10.127.8.11) by mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20 via Frontend Transport; Fri, 21 Nov 2025 06:11:43 -0800
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
Subject: [PATCH v3 2/7] vfio: export function to map the VMA
Date: Fri, 21 Nov 2025 14:11:36 +0000
Message-ID: <20251121141141.3175-3-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251121141141.3175-1-ankita@nvidia.com>
References: <20251121141141.3175-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD74:EE_|BY5PR12MB4068:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d793952-b35f-4e0f-f520-08de2907f2fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zqxXi9G4zT1SA/MIXiJOHuYtlEc2vznUE6AjAMn7PPOfTvNK76+beXrqGenu?=
 =?us-ascii?Q?te3C94OpTbLUELBOwNfHNs+siLXLGH3xDmX+ylV+J3eiOIUNMZes02P1KTw/?=
 =?us-ascii?Q?JmwoSeIqTikMHzn2vn2oGjkbjVZQJAg8UtqtLCqGar94Od7vBaCzr7FU21cB?=
 =?us-ascii?Q?CXq72LzC2RX/tS+CAxGjLcy454ckYHk5ka+IPpSgi3WgmXSX2YLyHy+CBbYA?=
 =?us-ascii?Q?+nlDLFRI+HnJTPZejX8OU5jrIs3IndjfvBch9WdaHlDVymQDaRhfU+/ftPZP?=
 =?us-ascii?Q?a7E/Hax3h7r001iwmq32digeGW2pzwJOwruaDteW3LNqcPVu5VifiidRZUh2?=
 =?us-ascii?Q?PtB1LJ+7C8yX2epu9Rw8jub1nMMW0090xz08VVkhHPbH2F9j2QGxzS5QjEYe?=
 =?us-ascii?Q?y1Yh7evrpaFhP1wd/F3TYvhGlW02BIU/O4JbNYn40btiV2bkHLedqmeLnK75?=
 =?us-ascii?Q?WiCNeG33xCLB1G74yYGTzpMY9VA/gIz83My/iUbiwTuzkyl7gbpkSfmpPA6H?=
 =?us-ascii?Q?gqn1sFM9GnMBSHDCPTh1e3X8k86wKamCHlYT5Ms7sjbaKjoy2177ilaDtbSK?=
 =?us-ascii?Q?W5UFdc7jw24uWd5CasejXxyTR4bBRJbIKqAGC95a9AXRDQJGH69aCOgzT0Yy?=
 =?us-ascii?Q?5TDS4LYtBEW21zshVWgImpzbvlBBXyKfwdSZMFGq9iySzk89K6ITideP4xvC?=
 =?us-ascii?Q?cscRkpnNwZyJwtbW6VzQ2C4KdXKTQgqlRLWPO++07kkJdyxM6V9yGb69M98z?=
 =?us-ascii?Q?Nk5f2manwJssibq80L9NHej0JQHws7OaQ7t9JN8I16tLntnejZORsz6LJmMB?=
 =?us-ascii?Q?zSRQR50vvDMnRvWO+dUHp8Ny2lUqyvAospuDYEeex/BWkkUM/doScYsEHRvt?=
 =?us-ascii?Q?DSnlsNsMslObLfoVGUuu58DoNZlkjFaqu3Szu22TUKcO3wFAY7wKJrrTAIc3?=
 =?us-ascii?Q?oJnFMZfKf+zHGn4/SF2ffXqyS5Ztt2MIc6neIOGbtzquJ4ybBKNd4hx6PvEb?=
 =?us-ascii?Q?/75PhBxOnTiqGmR4bR84oTnZ7x0NSKMhYdNAmSMBIDPcl/CZFc/lCKmX/Wgx?=
 =?us-ascii?Q?IGOFS2vJlEFSpaz4sTaVwMnpUIZo1uZiTwOEphIjIt7vhGmComZchkkOYF3h?=
 =?us-ascii?Q?tu1nrNRqHNNyydu53lw6lCI9nP+dkNaeV+u/74tJ1tCubkGKiWizu8yn+sCJ?=
 =?us-ascii?Q?EZHrqZIGdQOi5hbTE3efWRMKlm0bg7FGQRWCxmRv1WL8P8PRD34lzE4KX1bW?=
 =?us-ascii?Q?TuMe2I3tgHygenx5is898DK24dN5GOGZCo21VZBqdkn6eSf7bQKD15cwJ5WP?=
 =?us-ascii?Q?5KlFvKLB9RgW33vi0BZf3vNVBI2hgwdI6FX/4Hk8KGSe/mcANR3iZD+dAgQQ?=
 =?us-ascii?Q?IU1zcMEvKabW8+vKV1BJmesgDR3jWIzhiVIa74Pd+X6W5AS76rmbuLtIjA9+?=
 =?us-ascii?Q?ZW+0blnVX8VVQSP6yPhHHObfzkl4l6neztdoQv6dLWaqmbyA0j1T+mq6Kfqc?=
 =?us-ascii?Q?D+avYg7gAzHq5MYjm4QxjrPB/rIFw/ilLD82aqwpuNDw+pfmEgA8k5qcCB1L?=
 =?us-ascii?Q?76NEMSrjPOWmd6gqIDM=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2025 14:12:04.9939
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d793952-b35f-4e0f-f520-08de2907f2fb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD74.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4068

From: Ankit Agrawal <ankita@nvidia.com>

Take out the implementation to map the VMA to the PTE/PMD/PUD
as a separate function.

Export the function to be used by nvgrace-gpu module.

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 46 ++++++++++++++++++++------------
 include/linux/vfio_pci_core.h    |  2 ++
 2 files changed, 31 insertions(+), 17 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 7dcf5439dedc..29dcf78905a6 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1640,6 +1640,34 @@ static unsigned long vma_to_pfn(struct vm_area_struct *vma)
 	return (pci_resource_start(vdev->pdev, index) >> PAGE_SHIFT) + pgoff;
 }
 
+vm_fault_t vfio_pci_map_pfn(struct vm_fault *vmf,
+			    unsigned long pfn,
+			    unsigned int order)
+{
+	vm_fault_t ret;
+
+	switch (order) {
+	case 0:
+		ret = vmf_insert_pfn(vmf->vma, vmf->address, pfn);
+		break;
+#ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
+	case PMD_ORDER:
+		ret = vmf_insert_pfn_pmd(vmf, pfn, false);
+		break;
+#endif
+#ifdef CONFIG_ARCH_SUPPORTS_PUD_PFNMAP
+	case PUD_ORDER:
+		ret = vmf_insert_pfn_pud(vmf, pfn, false);
+		break;
+#endif
+	default:
+		ret = VM_FAULT_FALLBACK;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(vfio_pci_map_pfn);
+
 static vm_fault_t vfio_pci_mmap_huge_fault(struct vm_fault *vmf,
 					   unsigned int order)
 {
@@ -1662,23 +1690,7 @@ static vm_fault_t vfio_pci_mmap_huge_fault(struct vm_fault *vmf,
 	if (vdev->pm_runtime_engaged || !__vfio_pci_memory_enabled(vdev))
 		goto out_unlock;
 
-	switch (order) {
-	case 0:
-		ret = vmf_insert_pfn(vma, vmf->address, pfn);
-		break;
-#ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
-	case PMD_ORDER:
-		ret = vmf_insert_pfn_pmd(vmf, pfn, false);
-		break;
-#endif
-#ifdef CONFIG_ARCH_SUPPORTS_PUD_PFNMAP
-	case PUD_ORDER:
-		ret = vmf_insert_pfn_pud(vmf, pfn, false);
-		break;
-#endif
-	default:
-		ret = VM_FAULT_FALLBACK;
-	}
+	ret = vfio_pci_map_pfn(vmf, pfn, order);
 
 out_unlock:
 	up_read(&vdev->memory_lock);
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index f541044e42a2..058acded858b 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -119,6 +119,8 @@ ssize_t vfio_pci_core_read(struct vfio_device *core_vdev, char __user *buf,
 		size_t count, loff_t *ppos);
 ssize_t vfio_pci_core_write(struct vfio_device *core_vdev, const char __user *buf,
 		size_t count, loff_t *ppos);
+vm_fault_t vfio_pci_map_pfn(struct vm_fault *vmf, unsigned long pfn,
+			    unsigned int order);
 int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma);
 void vfio_pci_core_request(struct vfio_device *core_vdev, unsigned int count);
 int vfio_pci_core_match(struct vfio_device *core_vdev, char *buf);
-- 
2.34.1


