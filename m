Return-Path: <kvm+bounces-60655-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BDBF0BF5C4E
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 12:24:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 091C04836C7
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 10:24:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81DEB32D443;
	Tue, 21 Oct 2025 10:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="OE9yzX6H"
X-Original-To: kvm@vger.kernel.org
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011009.outbound.protection.outlook.com [52.101.57.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37E21F1538;
	Tue, 21 Oct 2025 10:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761042232; cv=fail; b=cZIULg43tCS+xq3w6LkIahF5RFovWL8CWyc1+kVifqfsOQ0AJUonb7vpyyLYQStJihEMTXZpVNL2nYWDW8C8IloCDxmxMuUkjXu68HiYRTiNm73X/kooLQCHI70Z530s3oI6jnlPWvGkhmomcTxrxJgyr2Nxkw/sqafNYP3BZ5A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761042232; c=relaxed/simple;
	bh=LzgaMOcTIWM3oUW0zpIOPL8nXPUP7jXgYlesc4Mi4L0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pjuOm3R/ssSUPX9HM1A7zj6MjbizmuUAFdNghQ3agG0tbK5oQ9L5S9x2SYNSPuxJprltdRlsBA4VNgm5rOhK83VQdcTQpuDRqKJk7USlVApQH/NJ5k/1Hf5zKfxZaJuAVSuPPvVZ7dakH1PxojeI9eF+39h4jNhej1TmOA7HdUA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=OE9yzX6H; arc=fail smtp.client-ip=52.101.57.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tjUp9nhFTQjyOOsjhj3N9hNT+gmLTTLkcTMfwdpYiivMqy/eFf0qiiahdASaw7O+D04SCEJac+NZnyTzJ8mfm/FruGxmWKQYElldJTxz2lAqk2vO5jVxsvuxU5R9Z6BFxHm6kqGvvfuqvfPWCXxVFmJeSZtzswyFmuEqm+00/viSyUCJEBx/pBaWGuODsRcfrtwXBkEBIpsKnr0/CrEcNWFT2s3I8Bz7pID7OSpK35nd96+U+tb5nTGSLXSESd/cin2vBOwM7wNt1uFoXdBU0+G8sxHvZirSNePXV9KvoEFaNLL9yDZkpPwVhldSxBFWcFR4isvuenlzR7Ug5gSm2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9oKtb1iXwKRocnqdIx51ArX2eBBUyzUz7T8BWIx8k4Y=;
 b=Q6+S6407hRCKLGvcY8AhPujc3MvGJLqX9Ax+QovIxgqiShjxWqX+nu9m9Mjfbq3n/5HEklzqFGDa1ZeR0nUuE0o2IP5A0dmJnA3W2GoFX5nkH1X5AGhdz7bT4PJ+aG4KUddcPS20g3HNE6RfW1Xy+ZdGGe/GJjCRQTWQ61eC5VMB6Be66plkDlE4+LIPP/j4Jtjfd/IAR+enwpfA9WtGRRjNC95dkcJP6Y6hy0depEHhbbs3fZ1+GqJyEHd0iXGQ4/en5D9AOg03r/MQx7ccO5iQhNHp3bUCWx30LP2SPw1a7bBKdtOCW5ZnS7OiIzR5P7dSofk1yJbtsncA3MRXHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9oKtb1iXwKRocnqdIx51ArX2eBBUyzUz7T8BWIx8k4Y=;
 b=OE9yzX6H45im90HomscAW9p0qFG5UYpFStdPJtdZLyI6u009Yqc9fx9LqbqVLt6Qn/DJzep46q/IU+m/IRCeUO/mcdrQZExdD+5+UUE+S9O1aJN4xLhNRghOztVSOm3GeFKrYo6ANB3IPiXcm0TuW5HY2VlXsP8BEbQO3VyPBsckmaB7zhglpMG+dlzaX5oUoChqUMvtM9w3wLSzinvGhMFbFX6qroyQINjvOHhcnMI6aK1EN56dXMTtyQvzRPSYik1u+zlP09MX2IMFD7/rBcy2oATph4wxI/V04HfACVaTZvZyHSKJxbMHY+TLFPqmMVqJnt2cayUY0L4M3Qw6DQ==
Received: from SA9PR13CA0017.namprd13.prod.outlook.com (2603:10b6:806:21::22)
 by DM4PR12MB6112.namprd12.prod.outlook.com (2603:10b6:8:aa::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9253.12; Tue, 21 Oct 2025 10:23:45 +0000
Received: from SA2PEPF00003F62.namprd04.prod.outlook.com
 (2603:10b6:806:21:cafe::f7) by SA9PR13CA0017.outlook.office365.com
 (2603:10b6:806:21::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9253.10 via Frontend Transport; Tue,
 21 Oct 2025 10:23:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SA2PEPF00003F62.mail.protection.outlook.com (10.167.248.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9253.7 via Frontend Transport; Tue, 21 Oct 2025 10:23:45 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 21 Oct
 2025 03:23:34 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Tue, 21 Oct 2025 03:23:33 -0700
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 21 Oct 2025 03:23:33 -0700
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <aniketa@nvidia.com>, <vsethi@nvidia.com>,
	<jgg@nvidia.com>, <mochs@nvidia.com>, <skolothumtho@nvidia.com>,
	<linmiaohe@huawei.com>, <nao.horiguchi@gmail.com>,
	<akpm@linux-foundation.org>, <david@redhat.com>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<tony.luck@intel.com>, <bp@alien8.de>, <rafael@kernel.org>,
	<guohanjun@huawei.com>, <mchehab@kernel.org>, <lenb@kernel.org>,
	<kevin.tian@intel.com>, <alex@shazbot.org>
CC: <cjia@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
	<zhiw@nvidia.com>, <dnigam@nvidia.com>, <kjaju@nvidia.com>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-edac@vger.kernel.org>, <Jonathan.Cameron@huawei.com>,
	<ira.weiny@intel.com>, <Smita.KoralahalliChannabasappa@amd.com>,
	<u.kleine-koenig@baylibre.com>, <peterz@infradead.org>,
	<linux-acpi@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: [PATCH v3 3/3] vfio/nvgrace-gpu: register device memory for poison handling
Date: Tue, 21 Oct 2025 10:23:27 +0000
Message-ID: <20251021102327.199099-4-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251021102327.199099-1-ankita@nvidia.com>
References: <20251021102327.199099-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F62:EE_|DM4PR12MB6112:EE_
X-MS-Office365-Filtering-Correlation-Id: 0cfb499c-64ff-4ed0-73e0-08de108beac8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|1800799024|36860700013|13003099007|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?j/dneHJWhhoGuK4Mckfd6RboyCWwshlGXcZY0aLGhS9KcX49qNSrgsdJYlBP?=
 =?us-ascii?Q?RGbh3e6mxJcF95/pCkGi98aRJ4UHdBk8KgFLcnplmH8f82zeQ+GXSPyiBqCc?=
 =?us-ascii?Q?2jA3UasyWJgfgMKS4iCqouIrB0ksCIZ/BJWud6YXWjBVDl1xFgZ2cPyCEs4r?=
 =?us-ascii?Q?Ai8kTHNsN/xNeOXasVG2wtfewTi8ZG2jOTcOtVeTxuaSRCoc1x9ciFWzn3ux?=
 =?us-ascii?Q?Q5tUIw7oLVQMbnSEB6X3jPzW5pS+a/PCmvElzJ4PI1GnQ87ubVjP7rf4RqZt?=
 =?us-ascii?Q?6sPPw2T57zq+9VAtZzKWYgrekIMVOs6coVJr4wKaNVyzweCoiqjMExtAxXcK?=
 =?us-ascii?Q?6OcL52GUvj4U6ToahOmDRy/iID7B+MNniWIM5c6xl3HNVcalabfXzY2WDd+A?=
 =?us-ascii?Q?clqJgTc4KbuADax/rnZC3MzISHfY79ucaJQh9+d6Q8zRGIIr0bjXxAsFXzV+?=
 =?us-ascii?Q?XE13m8zIhj9fpRm/sV4StI5SHhxA9iNf4+wRCFAuLd7T9ynvX0rd5Rlx4VFr?=
 =?us-ascii?Q?ghy5xWpCKHgfR4XWOAZXIm4XEbogmbqHpv7f6zXMmxKjnuHsLBHDI6mL2svO?=
 =?us-ascii?Q?o5h05jDVNfrZ27EK9qQrQxwRge2ZN1MgTQO7sDaWbBT0gRVXEenWULnlrbUO?=
 =?us-ascii?Q?klU2ZCMbIJiLE8sTr8miro78KuPRBDJDiKi1FyxAf0UfDNzEKvfVfeW4Lpyi?=
 =?us-ascii?Q?pKoJhFUNskR0Y5DI70ODBsH1xrN1ltdoS0lvXlgMP6e0m9DATHmA1ue9HYHH?=
 =?us-ascii?Q?Wabgu/Ea9EBnfMna1BbKnB0WYJ+3Ui79iNqgIfm9vZxX2yyMin548Sb6p7nx?=
 =?us-ascii?Q?WEEE1vHfqY6tzCffDPlggBQ8CGDELWFwnp1/b90uhvzqvmOpqr+xUU5cwR89?=
 =?us-ascii?Q?uQqBDZ5IPD1AqX+NIE0W6tTV3CaZm3CVXd7M2qsw0wH4sP/xgon4nDSx+zep?=
 =?us-ascii?Q?ekoNkIbW2ArOvuM3aHLGI+f3rPRncooPfdHtuwKVvB+ncy9XO3RNkUfhua5Y?=
 =?us-ascii?Q?awLVARu/lmKpvXTefKSevOvVCC17rW1CfJCEv+dQGTTouKVXuONVBpcP8TjN?=
 =?us-ascii?Q?w015zlo2xhcv7Xdk0bJYVSOhtvVPUtQpZPBwCXLCr2fUKJXMvvoKVGxNq4ju?=
 =?us-ascii?Q?IoB2R1PdXqd9TgCPzeBdSSwV2a2qTJK8/R7SWULMiixFdHb3yxwSC4bw2zfd?=
 =?us-ascii?Q?50XXsDIziiz1f49seCCL9p5kdsmPkN/snoQVCAQu9SZHhl9+hwUbSt8qqDfr?=
 =?us-ascii?Q?azAZXPEUu3BsocUb+7/+tNhZJVI8hPBKS/ab9ewbs2CzStGu/uSaarhYXINA?=
 =?us-ascii?Q?sN62vb/6sEcuz39ac55VG4eDYFcI0GE1Hg7haDaDIgQfYkuuex+LUe8eyQmo?=
 =?us-ascii?Q?H2i5ahNki3Fpk8Cjn9crpXK1DvyuKsCAQdo8Cx0wmoKJg/CtnGI8rLWvgB52?=
 =?us-ascii?Q?Ne7v3HwU9Zyf1kkRsQ+PvMlvG4zFHRV4WUcm7uWnIpUFe2faGO15gBxlcPGE?=
 =?us-ascii?Q?LhnI5Q/yyDuLW4lyR6cp5wDVAQaaTYpCFCRcM8G4FC5h43GTLUDATbjiuPMG?=
 =?us-ascii?Q?BU90w0Hf2KCEEdiT5kik4ogMTX6f7zak4egi7Fye?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(1800799024)(36860700013)(13003099007)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2025 10:23:45.8158
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cfb499c-64ff-4ed0-73e0-08de108beac8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F62.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6112

From: Ankit Agrawal <ankita@nvidia.com>

The nvgrace-gpu-vfio-pci module [1] maps the device memory to the user VA
(Qemu) using remap_pfn_range() without adding the memory to the kernel.
The device memory pages are not backed by struct page. Patches 1-2
implements the mechanism to handle ECC/poison on memory page without
struct page. This new mechanism is being used here.

The module registers its memory region and the address_space with the
kernel MM for ECC handling using the register_pfn_address_space()
registration API exposed by the kernel.

Link: https://lore.kernel.org/all/20240220115055.23546-1-ankita@nvidia.com/ [1]

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/main.c | 45 ++++++++++++++++++++++++++++-
 1 file changed, 44 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index d95761dcdd58..80b3ed63c682 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -8,6 +8,10 @@
 #include <linux/delay.h>
 #include <linux/jiffies.h>
 
+#ifdef CONFIG_MEMORY_FAILURE
+#include <linux/memory-failure.h>
+#endif
+
 /*
  * The device memory usable to the workloads running in the VM is cached
  * and showcased as a 64b device BAR (comprising of BAR4 and BAR5 region)
@@ -47,6 +51,9 @@ struct mem_region {
 		void *memaddr;
 		void __iomem *ioaddr;
 	};                      /* Base virtual address of the region */
+#ifdef CONFIG_MEMORY_FAILURE
+	struct pfn_address_space pfn_address_space;
+#endif
 };
 
 struct nvgrace_gpu_pci_core_device {
@@ -60,6 +67,28 @@ struct nvgrace_gpu_pci_core_device {
 	bool has_mig_hw_bug;
 };
 
+#ifdef CONFIG_MEMORY_FAILURE
+
+static int
+nvgrace_gpu_vfio_pci_register_pfn_range(struct mem_region *region,
+					struct vm_area_struct *vma)
+{
+	unsigned long nr_pages;
+	int ret = 0;
+
+	nr_pages = region->memlength >> PAGE_SHIFT;
+
+	region->pfn_address_space.node.start = vma->vm_pgoff;
+	region->pfn_address_space.node.last = vma->vm_pgoff + nr_pages - 1;
+	region->pfn_address_space.mapping = vma->vm_file->f_mapping;
+
+	ret = register_pfn_address_space(&region->pfn_address_space);
+
+	return ret;
+}
+
+#endif
+
 static void nvgrace_gpu_init_fake_bar_emu_regs(struct vfio_device *core_vdev)
 {
 	struct nvgrace_gpu_pci_core_device *nvdev =
@@ -127,6 +156,13 @@ static void nvgrace_gpu_close_device(struct vfio_device *core_vdev)
 
 	mutex_destroy(&nvdev->remap_lock);
 
+#ifdef CONFIG_MEMORY_FAILURE
+	if (nvdev->resmem.memlength)
+		unregister_pfn_address_space(&nvdev->resmem.pfn_address_space);
+
+	unregister_pfn_address_space(&nvdev->usemem.pfn_address_space);
+#endif
+
 	vfio_pci_core_close_device(core_vdev);
 }
 
@@ -202,7 +238,14 @@ static int nvgrace_gpu_mmap(struct vfio_device *core_vdev,
 
 	vma->vm_pgoff = start_pfn;
 
-	return 0;
+#ifdef CONFIG_MEMORY_FAILURE
+	if (nvdev->resmem.memlength && index == VFIO_PCI_BAR2_REGION_INDEX)
+		ret = nvgrace_gpu_vfio_pci_register_pfn_range(&nvdev->resmem, vma);
+	else if (index == VFIO_PCI_BAR4_REGION_INDEX)
+		ret = nvgrace_gpu_vfio_pci_register_pfn_range(&nvdev->usemem, vma);
+#endif
+
+	return ret;
 }
 
 static long
-- 
2.34.1


