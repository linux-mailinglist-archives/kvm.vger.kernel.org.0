Return-Path: <kvm+bounces-64138-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id C278EC7A1D7
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 15:20:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 399124F08D6
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 14:13:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CE7A34D926;
	Fri, 21 Nov 2025 14:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QzDsSZln"
X-Original-To: kvm@vger.kernel.org
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013020.outbound.protection.outlook.com [40.107.201.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F19346A1D;
	Fri, 21 Nov 2025 14:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763734337; cv=fail; b=N3ytuBhOY/ZxPrGJ/YlKPp8Gfj2SpAXfplQNhujleayCswbze5W3KBxVHlorhXWxg9Wo9VE5tETJr5jVR70ldaKk2/MKoI8InzaQTF2E/vzMlxSS0m9+ZC1tlZO0s6KT0xmDFJciiUu+rhbkFdgfSMqpODTDKOlIUcp9EUFydNo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763734337; c=relaxed/simple;
	bh=NaAJlxM3M06vyDgnmJymJnSmeWIlipt8GYfR3DpAnNU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hp3syWqw0TnA4wWDndGVW+J0gNhuRBMfpa79wj9Ha8N2dDkyvEvV5pKlfwsb99j6RZdZR0vv/Flc3IO4I29kYPjQql3xsgFzc1uAB3ziJlRKxbx5cdd/rSebPvFRQBP0q9d9z0agSdpNHXGOQ2xsBbMlx6OcSWoMNBAimdjodvA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QzDsSZln; arc=fail smtp.client-ip=40.107.201.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jEFr2DdlzLd1ZHUpeDIMpR1+uwZYvrTpJHTB/b1RpxOwn4KegkcLgYE5sjXoE8PhNkNja+LoTTKON1+vG/HvKv4iJVjm2U0qtoATx5Z5AmMnfCx+97l6Mex6U+JwjnSfskcMMSElr/APcX0RspniZCqS5o8fHrelLorC0yp8jUlHKjmWjV7DkeYPXn1SDPB4AKOl1rd1vogWWO9KCt/jQm/NjD0KARrxgGt0Lj9ZeOwsLlqKKGiVIe5cte9kNkVmfDP6Hts+eomhMGWwuvviet3k1Rwyphky1glLKQOI8O8GnKz+g9y6TFLhIVuEbW6jw/QXprjnMnij3Dief4LWIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oHfgp8s0wBeYJuyEtHx3U2tjJr9f5+2J/TFzMrHqNqk=;
 b=Kk+2KtRXLk5QUHjctT/qm/6wPgTfDiR0LMuvY2sixnmB1DETlxrjIBO4BpNg+ZUaOZpPhZVGckCL66SFyhvMIDa4DBTzivCvxAXXjqohTavSUrZxNQkvWpd4kAtNPyy3EfYxdkbbqyc+30Kb8weic2xTId4AUZ9h4zkvAMjZsh9zq7f0Cf/U9wbc3o0c79sZDev9c6wJYmCAMToxXMay7fhCZ3I5Lzt3WBVYo51XmKusdwEoMLldHN47pM0Iv1n5Ng1nMu40hoy7H1fqVC+klAAeAdQwfPBPcycV2p3qrP2tz0k/m/OiBhaWr6Y55tRuD+80aTR/uQVAf0ced/hD+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oHfgp8s0wBeYJuyEtHx3U2tjJr9f5+2J/TFzMrHqNqk=;
 b=QzDsSZlnLV0A/YWgtJNgIVM75JScYMMVDMEvWDWcL+UfIRslgs49O8f2LCCVs+1dumg6uAyqMoIpVLBQoneew5d6/9xKILdAqrZk/GP50Tk0x5QyUU6Ps9ljljPtc1K8JSFJ4j/TFgQKlhf8tgHry6XhHZ035VQ98Z6RKLaL2ENC8hzgRexMGucWuD50M3aU48hydBHqcYK4LvW5c0bAkr/UyrpYrc5mz3uihh4kKeTjE6zH2z2Qk5RDlJUc9u6mRdyahartCqslLZuNg3FulbEjP/yn3AlMMH99Nyl4PDj/Mwru4gP/2FCry5yZaxogwo0VrORbglftWNUQ29GPWQ==
Received: from MW4PR04CA0241.namprd04.prod.outlook.com (2603:10b6:303:88::6)
 by MN0PR12MB5980.namprd12.prod.outlook.com (2603:10b6:208:37f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.11; Fri, 21 Nov
 2025 14:12:11 +0000
Received: from SJ5PEPF000001CD.namprd05.prod.outlook.com
 (2603:10b6:303:88:cafe::b) by MW4PR04CA0241.outlook.office365.com
 (2603:10b6:303:88::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.11 via Frontend Transport; Fri,
 21 Nov 2025 14:12:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ5PEPF000001CD.mail.protection.outlook.com (10.167.242.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.9 via Frontend Transport; Fri, 21 Nov 2025 14:12:10 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 21 Nov
 2025 06:11:46 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 21 Nov
 2025 06:11:44 -0800
Received: from
 gb-nvl-073-compute01.l16.internal032k18.bmc032b17.internal032f11.internal032huang.bmc032l04.bmc
 (10.127.8.11) by mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20 via Frontend Transport; Fri, 21 Nov 2025 06:11:44 -0800
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
Subject: [PATCH v3 5/7] vfio: move barmap to a separate function and export
Date: Fri, 21 Nov 2025 14:11:39 +0000
Message-ID: <20251121141141.3175-6-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CD:EE_|MN0PR12MB5980:EE_
X-MS-Office365-Filtering-Correlation-Id: b432aad7-4ce3-48f7-bd6f-08de2907f61a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?F1QNwf/mApbTDnxAdoLlcg3FeB8W5PhxC8C91exfTnGhZEcEjFJ82hIOt1BZ?=
 =?us-ascii?Q?TAbAJdG6YbedHNlF8mrK6RnYzvG8MEp/0dli2mULYD/sFH+07RVjNu5GAD9L?=
 =?us-ascii?Q?cY/MNXHlUzkqjtrVv2XC4OxPhlCIYvCdVVL2rtRJJx1HIug8qEAXRpCH5Nnw?=
 =?us-ascii?Q?i3SQKT90KqVDVeKJ+e4zvhTSZTYCJz+5tiVBVcXjarAwdiGwhGxjKwUzaTSU?=
 =?us-ascii?Q?sjNJyyMwM27Cnuu6TgXAfc72dQw5QlJ7QtxSCu+Ucl637As4dNlRkYB/J78X?=
 =?us-ascii?Q?+pRrsBk3Dgq4SzYQKIF1w+bBKZYwzWbFoJcv4z2Ty6kUipjANuJu3C0QVK0v?=
 =?us-ascii?Q?nEb7jMjzc1STSEqF496wPBu/5bNUZvLMV4TP0wP/P0IAYcsRGZa9g4TIymTH?=
 =?us-ascii?Q?NJEea0NhiLx+h3Hv9E2z2nlCjqogXlnWTNY+1gvP62v2lTeL6sI6+xYk8shZ?=
 =?us-ascii?Q?NkYzsUq7g8nc55rpXcAIPpmMSHZu+VxBtg29u+34lnxJ30UNNFkVSxGVjQO4?=
 =?us-ascii?Q?CADQxvYPux5DEVS5qqLL3v2xcxFR2Y121W5DKdnbHHk2xzBfAu6u60LmObRi?=
 =?us-ascii?Q?SVEYMDD9EXPfOj4ZrPni/ErskyeDIMzM+DbWzBl6dE1lehm2J6wf1qKAMj3W?=
 =?us-ascii?Q?9f0nRTgvirE6thFGwPbGmr7pAgaMzLRwDENFwwUrZWY2TenYfDSvwM2q/zi4?=
 =?us-ascii?Q?ES2gHKBEtqTisVhMiFaj5T2B0XzrbtM2+X+Vk1YFT2tUOWSCZi8qDO6cjI4w?=
 =?us-ascii?Q?T+YeWSm5SASuaH0H7SS6+wzDkUmrqK7Z1JgXgfKWVpuqp3krz4ZYypHjOsjC?=
 =?us-ascii?Q?ZcDaZybja7udSGHH0Ldyw+LjwBhyNlBDXKZqoeYAdO5D9Bs5KIuXYex2btov?=
 =?us-ascii?Q?3WuF/OLpo8hpAl577XHQEblH/s2Uy/UmyeivhZzc+boBbMpnyREbdZeHjgaZ?=
 =?us-ascii?Q?bnKifGvz/rytwSSpIVVzwlMDT6pyaGzH01Bh6282yOniPVf/QYVk8NmiALy1?=
 =?us-ascii?Q?Y0PGbsl4ixQ3nivXEKfuaG2tymwZN/v5nBehfLKaL6ARVgRdh3cYz938CsoF?=
 =?us-ascii?Q?LpXdfXOX24aKBnRjmYfyoaJJ5baqxAZMNnAGYlJ+vuPpl6MxYhLUwZSNmW7Z?=
 =?us-ascii?Q?GSHZQehj+8MPpGrDipM+21tLN/qLZ+CoC9krRxz2lV2ipeZ/314qT+1CJnjD?=
 =?us-ascii?Q?McCHLLYkPBsB4qWaJNNDLEAyxHFwT0bb+6pqA/jJxKNe8dUuIXeSSZKgH2HQ?=
 =?us-ascii?Q?Suw4zCT2ex7GAkOieDvkQN9CMyM5nWbw/tSgDJg56+8y9+r/7CvAgvTfTEbe?=
 =?us-ascii?Q?8VSyKa1evPkhbI6b2LDOpyVltg+JlOzMIHPv8oFYkRpRc849cvpdL+cly4Bf?=
 =?us-ascii?Q?R21Yqmyfl2j9gV+3lwwL/QcSuVSWmGZHl8y0r4GXZRjfdYmqYtVmzDj63Kq+?=
 =?us-ascii?Q?dSlr3jAl4wCJjN3Y+gRNXoEI+LITRAXXXluoqeL2kOKvorULFOZSA2Qef9Fx?=
 =?us-ascii?Q?OfBUzQnamZByNi4y/UNQ3KdMR/5RUwzloZFKaJ0nXv/C/6rOFOjlXNmA6nUE?=
 =?us-ascii?Q?Rhu70Oq/6CwzGDgSveA=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2025 14:12:10.2311
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b432aad7-4ce3-48f7-bd6f-08de2907f61a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CD.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5980

From: Ankit Agrawal <ankita@nvidia.com>

Move the code to map the BAR to a separate function.

This would be reused by the nvgrace-gpu module.

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 38 ++++++++++++++++++++++----------
 include/linux/vfio_pci_core.h    |  1 +
 2 files changed, 27 insertions(+), 12 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 29dcf78905a6..d1ff1c0aa727 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1717,6 +1717,29 @@ static const struct vm_operations_struct vfio_pci_mmap_ops = {
 #endif
 };
 
+int vfio_pci_core_barmap(struct vfio_pci_core_device *vdev, unsigned int index)
+{
+	struct pci_dev *pdev = vdev->pdev;
+	int ret;
+
+	if (vdev->barmap[index])
+		return 0;
+
+	ret = pci_request_selected_regions(pdev,
+					   1 << index, "vfio-pci");
+	if (ret)
+		return ret;
+
+	vdev->barmap[index] = pci_iomap(pdev, index, 0);
+	if (!vdev->barmap[index]) {
+		pci_release_selected_regions(pdev, 1 << index);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vfio_pci_core_barmap);
+
 int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma)
 {
 	struct vfio_pci_core_device *vdev =
@@ -1761,18 +1784,9 @@ int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma
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
+	ret = vfio_pci_core_barmap(vdev, index);
+	if (ret)
+		return ret;
 
 	vma->vm_private_data = vdev;
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index a097a66485b4..75f04d613e0c 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -121,6 +121,7 @@ ssize_t vfio_pci_core_write(struct vfio_device *core_vdev, const char __user *bu
 		size_t count, loff_t *ppos);
 vm_fault_t vfio_pci_map_pfn(struct vm_fault *vmf, unsigned long pfn,
 			    unsigned int order);
+int vfio_pci_core_barmap(struct vfio_pci_core_device *vdev, unsigned int index);
 int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma);
 void vfio_pci_core_request(struct vfio_device *core_vdev, unsigned int count);
 int vfio_pci_core_match(struct vfio_device *core_vdev, char *buf);
-- 
2.34.1


