Return-Path: <kvm+bounces-24918-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AB71195CDFF
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 15:33:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 367731F2531C
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 13:33:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98719186E5F;
	Fri, 23 Aug 2024 13:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="XuPTEi5q"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2049.outbound.protection.outlook.com [40.107.102.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42B2714AD3E;
	Fri, 23 Aug 2024 13:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724420000; cv=fail; b=W9P2BmLcUE1eyDk1qbj8sy+9cAQNDBNG4qlOXyfax7C1wSVKG3xuvHyrDPeHn3cYV1HbOIyQdHQ6PBeCkPETA4lGtK2KJUXmRDRJdA9/nkKR/thz7+4YBmecb+l+0gb11/9i4jcKY6Ju9bLKSeSuoWs+QopuhF/0syVWjybkeI0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724420000; c=relaxed/simple;
	bh=jq/F1dvaXhFGNmq3QUaAtpjEPpiapSS4taXNwm46yd4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UKiaSFq2lGlVwTdcJfPKYRxeyoVj9I0lZxdQx/f9LFy+G9E+Jj1JpKfSQsef+D95kIwJUWOmyOxpONZvBccNMxAeOvEwMeeYSZYnEuUkkgTNASYNQn2WJUOhmTNI9L8HGed4Gsh5cUSIKlxGQBmoxHnZkxrJsOwLeNWqcK/SgQo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=XuPTEi5q; arc=fail smtp.client-ip=40.107.102.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GjCQb0bS9ao1d8bPfzplMDlLjudgjZYIsW8AkXEtAsbab06SZMoqI99IIXhm6WJev/mdzaIL/4BjMDFeuGZXO7BPAAsPuT9zG754yYrbPWNj7drKOzPLVm9f7XzN1X96Zo/zu3hMXaKaAUO/WCePD5zRp4VmCoEGMiJozVXsbDhs1L8zjV0d2iYv234esTpaZGzr1PZPuSgEgiT8n8KsxQpScaPJUHm3s6XAUoHkCyj4SpFJnejv07vz+aIvjNTC93+dTobU2j8s6o2WXtLzqUTG0VL2Zmg+1OWVdhtAPMr2p/XDgbg0Ivv8dwOR1776pRZkF0EcxbS5AeP9pUMR1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nqYGQKfnd6GIIE7MYeKAY1B0olkO+SJadZrC8lavNKE=;
 b=QaYINRIHk1mxgMMMUzEYn+OsLoSDFGc8SKwQS0Wuz8oBx61HtIoyyb5elxfnCxjGBwBZvlB7Rmzio3U+f/mH+utlv1aPIsNMW3bqMTYQA4S0Ne0oe+PxtoIp7TO+Xo59zKd0NiyI52TWEgaVd2t3OKfWPS1S9v47UB7ZbrzWjfWVOP8B1nTtJMN2nFc8aPf6QlkklskC3zRpdlANmqlSZxtjrp+M1YvPWkxvSaGAaRKJhvK+bNK0ld0wvqCIZZTbCNZf4fOFri+OI6sm5REVjgkwID8ouC/lDGj0FNBaXVMakggpjNwknMoOYHXLS2b1+Gw+cMWrBAZSvWOvYRcTPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nqYGQKfnd6GIIE7MYeKAY1B0olkO+SJadZrC8lavNKE=;
 b=XuPTEi5qMvxtCXtkpXhZ8HlqcWyzOk4LusBJN6QrnaPSKMURCTBublHi9UcoZfwP4ml7xW5p07pcjkAuAKQsyd0ur3qmjYkju58jUr3hzZsnqgN7scGBnqbVq8jyMoPQCgUDxfyXgXXzIzqGCBblYGA/DcC1Cbw3sNiLFjCkp5Q=
Received: from DS7PR03CA0001.namprd03.prod.outlook.com (2603:10b6:5:3b8::6) by
 SA1PR12MB8143.namprd12.prod.outlook.com (2603:10b6:806:333::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.19; Fri, 23 Aug
 2024 13:33:14 +0000
Received: from CY4PEPF0000EE36.namprd05.prod.outlook.com
 (2603:10b6:5:3b8:cafe::8a) by DS7PR03CA0001.outlook.office365.com
 (2603:10b6:5:3b8::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21 via Frontend
 Transport; Fri, 23 Aug 2024 13:33:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE36.mail.protection.outlook.com (10.167.242.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7897.11 via Frontend Transport; Fri, 23 Aug 2024 13:33:13 +0000
Received: from aiemdee.2.ozlabs.ru (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 23 Aug
 2024 08:33:08 -0500
From: Alexey Kardashevskiy <aik@amd.com>
To: <kvm@vger.kernel.org>
CC: <iommu@lists.linux.dev>, <linux-coco@lists.linux.dev>,
	<linux-pci@vger.kernel.org>, Suravee Suthikulpanit
	<suravee.suthikulpanit@amd.com>, Alex Williamson
	<alex.williamson@redhat.com>, Dan Williams <dan.j.williams@intel.com>,
	<pratikrajesh.sampat@amd.com>, <michael.day@amd.com>, <david.kaplan@amd.com>,
	<dhaval.giani@amd.com>, Santosh Shukla <santosh.shukla@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, "Alexander
 Graf" <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>, Vasant Hegde
	<vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>, Alexey Kardashevskiy
	<aik@amd.com>
Subject: [RFC PATCH 20/21] pci: Allow encrypted MMIO mapping via sysfs
Date: Fri, 23 Aug 2024 23:21:34 +1000
Message-ID: <20240823132137.336874-21-aik@amd.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240823132137.336874-1-aik@amd.com>
References: <20240823132137.336874-1-aik@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE36:EE_|SA1PR12MB8143:EE_
X-MS-Office365-Filtering-Correlation-Id: 9fc864c2-037e-4a74-8435-08dcc378233b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lQqbuhGEsxWzbewOLKCk9ttJE1pCKEZLsXmg9ggQflb5u0Y8raApnwIvZjyQ?=
 =?us-ascii?Q?N+NxGaCqDz0TtwvyBd4+nDwFkhb482L26vO/T29OUswBQHXJWoSx55vypSRy?=
 =?us-ascii?Q?FJMKsz5C839u9EAbx+IPuqFOYQga8GJYsF2toGo4leB76G28Tm3cjvwfJ4FG?=
 =?us-ascii?Q?HxuqXSe7vr9eCPevBV5uCCf/8U93toHdK1uGVslAloYdBSZwn7ns6WmnhtfC?=
 =?us-ascii?Q?4PBSACZtcYkKQOuVNTfPxzvt3B52+7zCzbWWTTTjR/7xYElmzR5ziW3CSoew?=
 =?us-ascii?Q?D2fxoGtGd6ny3PjLFMnc797ZSx4NI21FVsCR+I/YD1V8h9I6IlEu6LRXq+Dr?=
 =?us-ascii?Q?4nUV1CZnfg/A80ppEppAPKJEI9cVYM3EY/LUHiAx59KuyW1a3hAJyzQgF4j5?=
 =?us-ascii?Q?wW89fRNRC7IJSyqIwJj539yNAfRQxiolwQEefA3AkUzuuH+ApMjPuKV9zo0e?=
 =?us-ascii?Q?Fctx0OD77KiLjanWZVyVNwpYJWsQJKFOrXXGJ8WJy+vvWpabiMdhBUM8xMu4?=
 =?us-ascii?Q?lazejJaE/aNY3SL4zMXlu07Nx3E/2vGS0kMN2d80DCorOs4G5640QPbtWFKw?=
 =?us-ascii?Q?5qhbNdiQevKoIa3ipgPSJBXHhyv4XNRMmxfuTnlKIqCNcSeZJzygA4IsKPiO?=
 =?us-ascii?Q?8an62D7PHffqUxGki102gmQr3o/WaBpr2r/a2sFU+H4b65SuNX7X9KqfnlUd?=
 =?us-ascii?Q?iPyupQuZ/bdbmSqu4B/pcwR8L9BYp5vUR+BPC0JPeN/2UbCi+VtX1jGPcVTQ?=
 =?us-ascii?Q?wNNGCVRmI8Mc9QrFo+dSSHcX8aB3QdcvUGfooTI/qQcRaZh93WnU8MUFmHiE?=
 =?us-ascii?Q?VRIqq1SLrXRK4ik01rEcX+3LEVRTbSTrU6WkmjWbphNAY/fFDW+4rTpka8GU?=
 =?us-ascii?Q?e555qVpFFBclp54zGslXPSroSVKkWj4OOyvNJbLobID+KAvcwyDEPyPBZHJ4?=
 =?us-ascii?Q?n0GQrW+1K2769DGjBSSF8VKyxSd95b6d8wXryEOOlD7HgpQ9iLOwCnkAMx2J?=
 =?us-ascii?Q?uhJVlM+ksyALqPjEAyZ9TlLx9uDdlFOa+lajXaGt3YiuGBeiYnPg8VroqyhF?=
 =?us-ascii?Q?8ZNILYKB09YgpEiMPKSlZUC7i9q/BH9QRFFJqUcvvxqNCssbh8MvoReW3skU?=
 =?us-ascii?Q?4wr3m9tUmrKRAeHXKvpwZjrqhIEPhxa5DsALFZZOlkLWVTt6XXh7lJtu4A9B?=
 =?us-ascii?Q?4b/Y+q+qDRiqZRzql0x8jr4K7pDWk4KyC8RF+jxYL3wPnPo1PM+BY91Wc9ix?=
 =?us-ascii?Q?GFdv3k7gzRVbfk+/Fnk79orfPIHwhvLxk9Np30AoiMOLB7Nkk9PDkc4dsJrL?=
 =?us-ascii?Q?uVoNZivZ/dRV8XLiGkpoqEeefv0VRsLpMxHrngjNxwhMK9Nw5Cy7Q2Rjy32k?=
 =?us-ascii?Q?VWTRP/9orJAzfa545iZjO8vJUumFmRrEJEgUHcg4xWEyzQCPKaoAwDNGTNUv?=
 =?us-ascii?Q?t1Rp11cDpMVRmcLTmFq0W2ijcm2olZJT?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2024 13:33:13.3581
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fc864c2-037e-4a74-8435-08dcc378233b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE36.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8143

Add another resource#d_enc to allow mapping MMIO as
an encrypted/private region.

Unlike resourceN_wc, the node is added always as ability to
map MMIO as private depends on negotiation with the TSM which
happens quite late.

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
 include/linux/pci.h     |  2 +-
 drivers/pci/mmap.c      | 11 +++++++-
 drivers/pci/pci-sysfs.c | 27 +++++++++++++++-----
 drivers/pci/proc.c      |  2 +-
 4 files changed, 32 insertions(+), 10 deletions(-)

diff --git a/include/linux/pci.h b/include/linux/pci.h
index 053b7c506818..3c44542f66df 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -2085,7 +2085,7 @@ pci_alloc_irq_vectors(struct pci_dev *dev, unsigned int min_vecs,
  */
 int pci_mmap_resource_range(struct pci_dev *dev, int bar,
 			    struct vm_area_struct *vma,
-			    enum pci_mmap_state mmap_state, int write_combine);
+			    enum pci_mmap_state mmap_state, int write_combine, int enc);
 
 #ifndef arch_can_pci_mmap_wc
 #define arch_can_pci_mmap_wc()		0
diff --git a/drivers/pci/mmap.c b/drivers/pci/mmap.c
index 8da3347a95c4..4fd522aeb767 100644
--- a/drivers/pci/mmap.c
+++ b/drivers/pci/mmap.c
@@ -23,7 +23,7 @@ static const struct vm_operations_struct pci_phys_vm_ops = {
 
 int pci_mmap_resource_range(struct pci_dev *pdev, int bar,
 			    struct vm_area_struct *vma,
-			    enum pci_mmap_state mmap_state, int write_combine)
+			    enum pci_mmap_state mmap_state, int write_combine, int enc)
 {
 	unsigned long size;
 	int ret;
@@ -46,6 +46,15 @@ int pci_mmap_resource_range(struct pci_dev *pdev, int bar,
 
 	vma->vm_ops = &pci_phys_vm_ops;
 
+	/*
+	 * Calling remap_pfn_range() directly as io_remap_pfn_range()
+	 * enforces shared mapping.
+	 */
+	if (enc)
+		return remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
+				       vma->vm_end - vma->vm_start,
+				       vma->vm_page_prot);
+
 	return io_remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
 				  vma->vm_end - vma->vm_start,
 				  vma->vm_page_prot);
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index bf019371ef9a..1b0eca1751c2 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -1032,7 +1032,7 @@ void pci_remove_legacy_files(struct pci_bus *b)
  * Use the regular PCI mapping routines to map a PCI resource into userspace.
  */
 static int pci_mmap_resource(struct kobject *kobj, struct bin_attribute *attr,
-			     struct vm_area_struct *vma, int write_combine)
+			     struct vm_area_struct *vma, int write_combine, int enc)
 {
 	struct pci_dev *pdev = to_pci_dev(kobj_to_dev(kobj));
 	int bar = (unsigned long)attr->private;
@@ -1052,21 +1052,28 @@ static int pci_mmap_resource(struct kobject *kobj, struct bin_attribute *attr,
 
 	mmap_type = res->flags & IORESOURCE_MEM ? pci_mmap_mem : pci_mmap_io;
 
-	return pci_mmap_resource_range(pdev, bar, vma, mmap_type, write_combine);
+	return pci_mmap_resource_range(pdev, bar, vma, mmap_type, write_combine, enc);
 }
 
 static int pci_mmap_resource_uc(struct file *filp, struct kobject *kobj,
 				struct bin_attribute *attr,
 				struct vm_area_struct *vma)
 {
-	return pci_mmap_resource(kobj, attr, vma, 0);
+	return pci_mmap_resource(kobj, attr, vma, 0, 0);
 }
 
 static int pci_mmap_resource_wc(struct file *filp, struct kobject *kobj,
 				struct bin_attribute *attr,
 				struct vm_area_struct *vma)
 {
-	return pci_mmap_resource(kobj, attr, vma, 1);
+	return pci_mmap_resource(kobj, attr, vma, 1, 0);
+}
+
+static int pci_mmap_resource_enc(struct file *filp, struct kobject *kobj,
+				 struct bin_attribute *attr,
+				 struct vm_area_struct *vma)
+{
+	return pci_mmap_resource(kobj, attr, vma, 0, 1);
 }
 
 static ssize_t pci_resource_io(struct file *filp, struct kobject *kobj,
@@ -1160,7 +1167,7 @@ static void pci_remove_resource_files(struct pci_dev *pdev)
 	}
 }
 
-static int pci_create_attr(struct pci_dev *pdev, int num, int write_combine)
+static int pci_create_attr(struct pci_dev *pdev, int num, int write_combine, int enc)
 {
 	/* allocate attribute structure, piggyback attribute name */
 	int name_len = write_combine ? 13 : 10;
@@ -1178,6 +1185,9 @@ static int pci_create_attr(struct pci_dev *pdev, int num, int write_combine)
 	if (write_combine) {
 		sprintf(res_attr_name, "resource%d_wc", num);
 		res_attr->mmap = pci_mmap_resource_wc;
+	} else if (enc) {
+		sprintf(res_attr_name, "resource%d_enc", num);
+		res_attr->mmap = pci_mmap_resource_enc;
 	} else {
 		sprintf(res_attr_name, "resource%d", num);
 		if (pci_resource_flags(pdev, num) & IORESOURCE_IO) {
@@ -1234,11 +1244,14 @@ static int pci_create_resource_files(struct pci_dev *pdev)
 		if (!pci_resource_len(pdev, i))
 			continue;
 
-		retval = pci_create_attr(pdev, i, 0);
+		retval = pci_create_attr(pdev, i, 0, 0);
 		/* for prefetchable resources, create a WC mappable file */
 		if (!retval && arch_can_pci_mmap_wc() &&
 		    pdev->resource[i].flags & IORESOURCE_PREFETCH)
-			retval = pci_create_attr(pdev, i, 1);
+			retval = pci_create_attr(pdev, i, 1, 0);
+		/* Add node for private MMIO mapping */
+		if (!retval)
+			retval = pci_create_attr(pdev, i, 0, 1);
 		if (retval) {
 			pci_remove_resource_files(pdev);
 			return retval;
diff --git a/drivers/pci/proc.c b/drivers/pci/proc.c
index f967709082d6..62992c8234f1 100644
--- a/drivers/pci/proc.c
+++ b/drivers/pci/proc.c
@@ -284,7 +284,7 @@ static int proc_bus_pci_mmap(struct file *file, struct vm_area_struct *vma)
 	/* Adjust vm_pgoff to be the offset within the resource */
 	vma->vm_pgoff -= start >> PAGE_SHIFT;
 	ret = pci_mmap_resource_range(dev, i, vma,
-				  fpriv->mmap_state, write_combine);
+				  fpriv->mmap_state, write_combine, 0);
 	if (ret < 0)
 		return ret;
 
-- 
2.45.2


