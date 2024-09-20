Return-Path: <kvm+bounces-27224-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD50297DA95
	for <lists+kvm@lfdr.de>; Sat, 21 Sep 2024 00:36:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8D9A4282832
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2024 22:36:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DDCC18DF60;
	Fri, 20 Sep 2024 22:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="M9XmGkpN"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2078.outbound.protection.outlook.com [40.107.237.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9445918CBFC;
	Fri, 20 Sep 2024 22:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726871716; cv=fail; b=kvAGBqjUcY5Yrx+KHQTog0+IultW9y+lZlLsx9D/4EIm1ycf92G8Sa8dVFUp/KdHax+3A4k69DFW9vy3L+7lo7mR2CPupePaP5IIc6AyAkquieCjdrbdoxLgqpv5WgaA8oK327yxwyMM7RcuC5/FAzQeM9t9eTpEIQtbufNpY84=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726871716; c=relaxed/simple;
	bh=ZiXGEJG6xkMdgDE9njcmLcTrBcbZd8lwOfq/aTyi5xg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O7EmAYLx60LUzaj8yl11ALaEGSk3fCkW0zrpWohmhJmuix3Ql7G3YpKYlI+HPnfiK23UyteVNG5Z0DVkKj4yUl1QHrFgLaxFoFLEMZaOhtWlPFtddUkiKy+1/I2/9A9rX8f8hd5hvw6k9ZAv1PWlRyhbrYGaAJa5U66k1S0PRmM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=M9XmGkpN; arc=fail smtp.client-ip=40.107.237.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fjV9ghtRgVPArNTpjtkP08kQCYlkawhz4MW1P6UKZICI06YcnF1jOC6ZQWqTjVrtddQ7SzrX4jag7PadGamWhYP45lUjgVAFtcOyUFg3W9SsOeBpyNlw6UqqYl+2VuxVjIR9jE3R+GAtppGXhkroGTBvPk+txv7h/ASZmb4PJ0/bHIjJc1rL9qQ4vb0mOi+A+b4ZGJmtjJZVNh9BSjSa2zEzE22E0UYTpaoWvm4rBiWUhOSN0Lk62jjwThaJusO9P+lLqTwpxkWV8Hdr05/Ukvz+sePyRBFZlm3dO7xZ4Wt7erzlyOSR0Acydm2E9X5a7rbyOYukeG8aZF5OW48w1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fdlEmKOktwQDHJltnm7YMmchTX+TSdcBoUqkAglqwl0=;
 b=cQ+cZCFSvW4IOaouUtWa5KH7jtv1l7O37y4/RniuFH1EyC0x0CM+P8uvt5WbsxlMhibb3cojRjOwaQsJKN3RQ/DKKcGsAD84HxzRDWsBQPll0NBmCYjkUaNvqXf7HvAkezghS+hsFEkYGqGC9CjimFAXA6JZN0h/2QWdz1MjQx187oUtYagm250dhVkiYiMMTFSheHILhaQN5CIv5lTjtHF2fRWdjr53nbYcnbOuzpUQ/z5pqOxHS7iKTTMyX48upHAlozHvKKRCOsgYDcU/nOwSCeaOPDM/DLT6cKCO+vuUUNKJNKFYE3iIfH/9iEcygMevVVnX/vjK7QHALFwqHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fdlEmKOktwQDHJltnm7YMmchTX+TSdcBoUqkAglqwl0=;
 b=M9XmGkpNTCYrI/ejZA+W5Aq731GPdYUcw6WJhmri+gynwMSODRCDGzaSkdm9mLSENhTQEspo00bNlBIt6nOfDdcaHxeNmyR/OoNXWE0w5f1AAWLyIsIMB/9PryXJpb9yp/z0E3AfNwMNiAW9rR5OGVCRZZ/L3sRjBTf/2vZbXrSpxmuN/kKIcKFqe+0hHZAbtZsqJBfe9UXvHFaL2B3OR0/cLeL27I4GBQL8x8emzAdMJm/BiVAaG4k6Af3StB+kM4/U9YCVIYtm/BkJ5p7PoudL56fNo+xhDlAy0k1TXQuggd6xdiV+9+DMQejCrUCz7ydyKJkS126hdfw+sK0c3A==
Received: from MN2PR18CA0014.namprd18.prod.outlook.com (2603:10b6:208:23c::19)
 by DS0PR12MB8415.namprd12.prod.outlook.com (2603:10b6:8:fc::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.21; Fri, 20 Sep
 2024 22:35:11 +0000
Received: from BL02EPF0002992B.namprd02.prod.outlook.com
 (2603:10b6:208:23c:cafe::dd) by MN2PR18CA0014.outlook.office365.com
 (2603:10b6:208:23c::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.22 via Frontend
 Transport; Fri, 20 Sep 2024 22:35:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL02EPF0002992B.mail.protection.outlook.com (10.167.249.56) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Fri, 20 Sep 2024 22:35:10 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 20 Sep
 2024 15:34:58 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 20 Sep
 2024 15:34:57 -0700
Received: from inno-linux.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Fri, 20 Sep 2024 15:34:56 -0700
From: Zhi Wang <zhiw@nvidia.com>
To: <kvm@vger.kernel.org>, <linux-cxl@vger.kernel.org>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>,
	<alison.schofield@intel.com>, <dan.j.williams@intel.com>,
	<dave.jiang@intel.com>, <dave@stgolabs.net>, <jonathan.cameron@huawei.com>,
	<ira.weiny@intel.com>, <vishal.l.verma@intel.com>, <alucerop@amd.com>,
	<acurrid@nvidia.com>, <cjia@nvidia.com>, <smitra@nvidia.com>,
	<ankita@nvidia.com>, <aniketa@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <zhiw@nvidia.com>, <zhiwang@kernel.org>
Subject: [RFC 05/13] vfio/cxl: expose CXL region to the usersapce via a new VFIO device region
Date: Fri, 20 Sep 2024 15:34:38 -0700
Message-ID: <20240920223446.1908673-6-zhiw@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0002992B:EE_|DS0PR12MB8415:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d31c9b6-f999-4728-714c-08dcd9c47cc3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|7416014|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YSuGMpmq1UcZS2H2Zh1/49BIghqnoPNVnArhU8qg9P2Kod0ZsSB73/kPPgVt?=
 =?us-ascii?Q?DsD9UZcg9/CGcmYE3B043n9eveYEMtzJjHcjrSiOE9dV/i7avQ7sXBtgzUal?=
 =?us-ascii?Q?8x3lf9AXP9NEEyy9ZaUcZwpKusl5T/bDxhS3dkwoqGSqnPAcpUbymj+reZbl?=
 =?us-ascii?Q?/T2uAyPd0+ZFfhMpEC1c5QyI5eGyIE5kaubwFSkK9pjLOXIAM1O9jtbJyTZR?=
 =?us-ascii?Q?rabp6nr3j0Zi1R9+KUdInzwu/9amsvQIw+R9c6FBOQKvfDAGflGUzQjUSniX?=
 =?us-ascii?Q?xprUrsmgDPYvSRaasuqvZSy2p7sQZy/aqbFwJ15gjlUI/xZRyR8P12WKvFaE?=
 =?us-ascii?Q?R/K5plZ3VPYHQGfFjnpBNfw5yvaOnLTtl8GgUAc3khaggACWpLglKGNl/nND?=
 =?us-ascii?Q?WsGwEy9a18npZ049RpYOw6XIw7HNN7K7z+0oMYOEtvxLESpofKkdte0UeIg0?=
 =?us-ascii?Q?Bu4OTBbq8dVAuqt1hXLnMrG8s7Pmg03fMeCqDqLc3L0r6wykunfy1dOitz3p?=
 =?us-ascii?Q?9vj36O33NnqeIwI5yVEUTdrW2HQD6tZ90+EeDBv3F/QIanR4ya+LpiE+Gr6R?=
 =?us-ascii?Q?W+5wvPj2lG03Aen8LlFCrxInlGA+gAKP3BzTSXZngJgjuOjg/pqN1BuL7emT?=
 =?us-ascii?Q?9+/+A4uH4WY4KCrFKPRjAUGNSFEf/qTpZIfs8BoGf5EmSir6d14SyVf5O/Gd?=
 =?us-ascii?Q?GsivIV07l9Xr9/tuUcSmSSJiXqv0EJ3wVm2uY0ENBLwKutCp5cS+7WLnqlOU?=
 =?us-ascii?Q?ICYCQE+zLu57vU/7ERa6fLbrpkN1NzZctCV4BAB77JOa+r2hNG53/zX3dk/J?=
 =?us-ascii?Q?5nLE64PYhrVfJRmFr9uIZIK/T71C28gu6U8SIr1MNoVZRb+wy28It2UhjuH9?=
 =?us-ascii?Q?EGM6IyCHvNTi2LBnvhCbSFo5BYl4HEGBHp1bH+mL19lmx5WH+yLbrFIQqV1Q?=
 =?us-ascii?Q?w4hgRXi7eRrds7A/lGjnmFUtOapmPZMFcWldYmsItnHDqLaLiO9UvHD6DH44?=
 =?us-ascii?Q?8cC3iWxA7U8ITpcCC5r8ePY+lMkwvJexYA1+6TlZZ97nfRxfS0HLKBGw340E?=
 =?us-ascii?Q?YRZ2R7UesZ+jRqbQSwk0os5Mu2BpGjUwofmjlFnCOQetSWCu1NBvdO3zOkC3?=
 =?us-ascii?Q?wol2TDFCIoV29H5NHOMw1CEAebF7kDJKDB+vEHTAsihMSgxq7nIN+FwnfPea?=
 =?us-ascii?Q?MKDma4DD89JNDaXOVaITbRPBvEp+fi9HhXG9xoued9furysvxYW8PoTI8tDK?=
 =?us-ascii?Q?QJPovu4UrSYodvriW40k4J6ozeemKiHGmS8q0NJDkHpJuI7T6ktDOktBtG+e?=
 =?us-ascii?Q?0fqNLwu6pBDKDIaCLyhYPopZ7YM4k+7LM2RbRcsdjg9qj+FRn7ntyQs3r6/1?=
 =?us-ascii?Q?tXj24qlStsPsiCNu8TMdCzqcpyVHwx2Zgd1TiFNwZVbInXrps9t5J7UyvqRm?=
 =?us-ascii?Q?hE8PQw1q/KF3GbolGhIiom8dHwb9hnvE?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(7416014)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2024 22:35:10.7737
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d31c9b6-f999-4728-714c-08dcd9c47cc3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8415

To directly access the device memory, a CXL region is required. Creating
a CXL region requires to configure HDM decoders on the path to map the
access of HPA level by level and evetually hit the DPA in the CXL
topology.

For the usersapce, e.g. QEMU, to access the CXL region, the region is
required to be exposed via VFIO interfaces.

Introduce a new VFIO device region and region ops to expose the created
CXL region when initailize the device in the vfio-cxl-core. Introduce a
new sub region type for the userspace to identify a CXL region.

Signed-off-by: Zhi Wang <zhiw@nvidia.com>
---
 drivers/vfio/pci/vfio_cxl_core.c   | 140 ++++++++++++++++++++++++++++-
 drivers/vfio/pci/vfio_pci_config.c |   1 +
 include/linux/vfio_pci_core.h      |   1 +
 include/uapi/linux/vfio.h          |   3 +
 4 files changed, 144 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_cxl_core.c b/drivers/vfio/pci/vfio_cxl_core.c
index 6a7859333f67..ffc15fd94b22 100644
--- a/drivers/vfio/pci/vfio_cxl_core.c
+++ b/drivers/vfio/pci/vfio_cxl_core.c
@@ -102,6 +102,13 @@ static int create_cxl_region(struct vfio_pci_core_device *core_dev)
 	cxl_accel_get_region_params(cxl->region.region, &start, &end);
 
 	cxl->region.addr = start;
+	cxl->region.vaddr = ioremap(start, end - start);
+	if (!cxl->region.addr) {
+		pci_err(pdev, "Fail to map CXL region\n");
+		cxl_region_detach(cxl->cxled);
+		cxl_dpa_free(cxl->cxled);
+		goto out;
+	}
 out:
 	cxl_release_endpoint(cxl->cxlmd, cxl->endpoint);
 	return ret;
@@ -152,17 +159,135 @@ static void disable_cxl(struct vfio_pci_core_device *core_dev)
 {
 	struct vfio_cxl *cxl = &core_dev->cxl;
 
-	if (cxl->region.region)
+	if (cxl->region.region) {
+		iounmap(cxl->region.vaddr);
 		cxl_region_detach(cxl->cxled);
+	}
 
 	if (cxl->cxled)
 		cxl_dpa_free(cxl->cxled);
 }
 
+static unsigned long vma_to_pfn(struct vm_area_struct *vma)
+{
+	struct vfio_pci_core_device *vdev = vma->vm_private_data;
+	struct vfio_cxl *cxl = &vdev->cxl;
+	u64 pgoff;
+
+	pgoff = vma->vm_pgoff &
+		((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
+
+	return (cxl->region.addr >> PAGE_SHIFT) + pgoff;
+}
+
+static vm_fault_t vfio_cxl_mmap_fault(struct vm_fault *vmf)
+{
+	struct vm_area_struct *vma = vmf->vma;
+	struct vfio_pci_core_device *vdev = vma->vm_private_data;
+	unsigned long pfn, pgoff = vmf->pgoff - vma->vm_pgoff;
+	unsigned long addr = vma->vm_start;
+	vm_fault_t ret = VM_FAULT_SIGBUS;
+
+	pfn = vma_to_pfn(vma);
+
+	down_read(&vdev->memory_lock);
+
+	if (vdev->pm_runtime_engaged || !__vfio_pci_memory_enabled(vdev))
+		goto out_unlock;
+
+	ret = vmf_insert_pfn(vma, vmf->address, pfn + pgoff);
+	if (ret & VM_FAULT_ERROR)
+		goto out_unlock;
+
+	for (; addr < vma->vm_end; addr += PAGE_SIZE, pfn++) {
+		if (addr == vmf->address)
+			continue;
+
+		if (vmf_insert_pfn(vma, addr, pfn) & VM_FAULT_ERROR)
+			break;
+	}
+
+out_unlock:
+	up_read(&vdev->memory_lock);
+
+	return ret;
+}
+
+static const struct vm_operations_struct vfio_cxl_mmap_ops = {
+	.fault = vfio_cxl_mmap_fault,
+};
+
+static int vfio_cxl_region_mmap(struct vfio_pci_core_device *core_dev,
+				struct vfio_pci_region *region,
+				struct vm_area_struct *vma)
+{
+	struct vfio_cxl *cxl = &core_dev->cxl;
+	u64 phys_len, req_len, pgoff, req_start;
+
+	if (!(region->flags & VFIO_REGION_INFO_FLAG_MMAP))
+		return -EINVAL;
+
+	if (!(region->flags & VFIO_REGION_INFO_FLAG_READ) &&
+	    (vma->vm_flags & VM_READ))
+		return -EPERM;
+
+	if (!(region->flags & VFIO_REGION_INFO_FLAG_WRITE) &&
+	    (vma->vm_flags & VM_WRITE))
+		return -EPERM;
+
+	phys_len = cxl->region.size;
+	req_len = vma->vm_end - vma->vm_start;
+	pgoff = vma->vm_pgoff &
+		((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
+	req_start = pgoff << PAGE_SHIFT;
+
+	if (req_start + req_len > phys_len)
+		return -EINVAL;
+
+	vma->vm_private_data = core_dev;
+	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+	vma->vm_page_prot = pgprot_decrypted(vma->vm_page_prot);
+
+	vm_flags_set(vma, VM_ALLOW_ANY_UNCACHED | VM_IO | VM_PFNMAP |
+			VM_DONTEXPAND | VM_DONTDUMP);
+	vma->vm_ops = &vfio_cxl_mmap_ops;
+
+	return 0;
+}
+
+static ssize_t vfio_cxl_region_rw(struct vfio_pci_core_device *core_dev,
+				  char __user *buf, size_t count, loff_t *ppos,
+				  bool iswrite)
+{
+	unsigned int i = VFIO_PCI_OFFSET_TO_INDEX(*ppos) - VFIO_PCI_NUM_REGIONS;
+	struct vfio_cxl_region *cxl_region = core_dev->region[i].data;
+	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
+
+	if (!count)
+		return 0;
+
+	return vfio_pci_core_do_io_rw(core_dev, false,
+				      cxl_region->vaddr,
+				      (char __user *)buf, pos, count,
+				      0, 0, iswrite);
+}
+
+static void vfio_cxl_region_release(struct vfio_pci_core_device *vdev,
+				    struct vfio_pci_region *region)
+{
+}
+
+static const struct vfio_pci_regops vfio_cxl_regops = {
+	.rw		= vfio_cxl_region_rw,
+	.mmap		= vfio_cxl_region_mmap,
+	.release	= vfio_cxl_region_release,
+};
+
 int vfio_cxl_core_enable(struct vfio_pci_core_device *core_dev)
 {
 	struct vfio_cxl *cxl = &core_dev->cxl;
 	struct pci_dev *pdev = core_dev->pdev;
+	u32 flags;
 	u16 dvsec;
 	int ret;
 
@@ -182,8 +307,21 @@ int vfio_cxl_core_enable(struct vfio_pci_core_device *core_dev)
 	if (ret)
 		goto err_enable_cxl_device;
 
+	flags = VFIO_REGION_INFO_FLAG_READ |
+		VFIO_REGION_INFO_FLAG_WRITE |
+		VFIO_REGION_INFO_FLAG_MMAP;
+
+	ret = vfio_pci_core_register_dev_region(core_dev,
+		PCI_VENDOR_ID_CXL | VFIO_REGION_TYPE_PCI_VENDOR_TYPE,
+		VFIO_REGION_SUBTYPE_CXL, &vfio_cxl_regops,
+		cxl->region.size, flags, &cxl->region);
+	if (ret)
+		goto err_register_cxl_region;
+
 	return 0;
 
+err_register_cxl_region:
+	disable_cxl(core_dev);
 err_enable_cxl_device:
 	vfio_pci_core_disable(core_dev);
 	return ret;
diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 97422aafaa7b..98f3ac2d305c 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -412,6 +412,7 @@ bool __vfio_pci_memory_enabled(struct vfio_pci_core_device *vdev)
 	return pdev->current_state < PCI_D3hot &&
 	       (pdev->no_command_memory || (cmd & PCI_COMMAND_MEMORY));
 }
+EXPORT_SYMBOL(__vfio_pci_memory_enabled);
 
 /*
  * Restore the *real* BARs after we detect a FLR or backdoor reset.
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 7762d4a3e825..6523d9d1bffe 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -54,6 +54,7 @@ struct vfio_pci_region {
 struct vfio_cxl_region {
 	u64 size;
 	u64 addr;
+	void *vaddr;
 	struct cxl_region *region;
 };
 
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 2b68e6cdf190..71f766c29060 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -372,6 +372,9 @@ struct vfio_region_info_cap_type {
 /* sub-types for VFIO_REGION_TYPE_GFX */
 #define VFIO_REGION_SUBTYPE_GFX_EDID            (1)
 
+/* sub-types for VFIO CXL region */
+#define VFIO_REGION_SUBTYPE_CXL                 (1)
+
 /**
  * struct vfio_region_gfx_edid - EDID region layout.
  *
-- 
2.34.1


