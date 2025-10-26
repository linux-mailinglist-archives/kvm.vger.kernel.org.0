Return-Path: <kvm+bounces-61096-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 37518C0A9CF
	for <lists+kvm@lfdr.de>; Sun, 26 Oct 2025 15:25:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 697D41883545
	for <lists+kvm@lfdr.de>; Sun, 26 Oct 2025 14:22:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0FED2EB5B3;
	Sun, 26 Oct 2025 14:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nkkxJpL7"
X-Original-To: kvm@vger.kernel.org
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010008.outbound.protection.outlook.com [52.101.61.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6382926ED43;
	Sun, 26 Oct 2025 14:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761488388; cv=fail; b=QLT9WPqm9S3Zu5jDruqMTQ+ukqj6/dDFM6+LLpruMTgIOJsr/JR39m2MixEcNoffkszB6gImMv/PGK74x1OQBjF9ciVut4sd1kXajMIe7636ngPzhY8EA0okdedMedZo5xv74+3H4CC6Tfa1rEiHsblOgs01iqfgZMw1p+xNORk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761488388; c=relaxed/simple;
	bh=wuCKEicDcIsv1O+0qRo5ntlItvTTh/31+SqaSS6tYyI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g/Yms6j4Cm1M6adanZpOlGOhGswKmcMgw4+eXTVZ5sd9RkQ7PcC6EarvyfxxjLB7HQdYNN9K0Hb2Cx6Pqm3l8xCVmTtTAmKo1mW/Nq+zrzCfu92NCeWobeADmXrpYvE1CWc/pVJtaA3oypoKgyGe7ysTjl7sCRR5Alx5ueb6H2I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nkkxJpL7; arc=fail smtp.client-ip=52.101.61.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K0ApDqH3VehTAZQrPi/uId3UyvJMOkECGe2mKywrqybx9IBY3McBQ530E9/fPcWFwOLNmqnF6rLYAZmpXIKNmrkSzWVmxIRwaJm6OsUTMDUHBUrWsrpurhe37vuCuIYBW2MmtVVucMmkTem+WnpMUoKFiEhR9PaHsKZQmG/1Cz/Ci7zsSxs/OGm/HfNcuyW8b4ljMrQzn/r44z64x1fpgbJRp8HdzusOCLzVcYIx7utq9gtXt1mHrBB8YEk6sJLnXv1OI4BD4714vuYFj3TQgJvB00qoqExZDz2tV5/N/3+xMP8Agt32xYnHzs/FpxnwC9aEHqhxddxSpK87u4z3qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l+PoeFQBtdd6tvq+PxWLLVPThcvfQiPhoI1YysoCFeo=;
 b=k/ShXzQVNI0sC2uFQItKmxvoXFA9AVHR4f946VaekD6TIqtWlsTw8RnZF2E2au0gSJRZVF8ofTypvxxjzyBkVgYDkm8eUBCaeWh82R3fZU3xWQAGVW1JCD5bFQUep3Zm9iAfZMqVutjAouVyhjR39Oipf8KjhYtIRqMFjRIQPZHaiBMoGA36KSipnXIs6l0FSJty1jv1X4RLrx4C7v8R9x2Nvk/uXt7XRKgCmUjShIDIUQlvaayGwqmVw09ic5yv407l+k+CWJKBpYoA60wQpEL62hIZ6pJ9EKWgUvvItBlgBiX3puc2iyqlj7KcVTFOC5u4tmyh8qfm89nXZ2fNoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l+PoeFQBtdd6tvq+PxWLLVPThcvfQiPhoI1YysoCFeo=;
 b=nkkxJpL7T2SiA0i/aq8w+Xoc5KBAcI3yYXAOglkZkuMrDvoDquzzI1xBEycVu+kgWm5OHbUJq8snxQ8vuUTnTjmMPxxIrSomccrLan/8bizNdKeH1+vD23ZnE28IGi9Hl51G1hQNgMD44LAyiIcrfnyKyvh/UniEou/ieGY/rPDTRfpEzitHbn/jHLHOjIavaH54n6alkmt+8/JdOVDPjc0y+aNlQo8nUmE77ueLlt9510xQVv/wbje0U6gWiPuAlQro7nKrkSFB2N+kSvzdZkaufyCsp5oaqkkauFoDowutI5LeyUJA3r9jwkLmGjUEReegpsX5Hh/9wMqeWivqBA==
Received: from MW4PR03CA0347.namprd03.prod.outlook.com (2603:10b6:303:dc::22)
 by LV9PR12MB9760.namprd12.prod.outlook.com (2603:10b6:408:2f0::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.16; Sun, 26 Oct
 2025 14:19:42 +0000
Received: from SJ1PEPF00002326.namprd03.prod.outlook.com
 (2603:10b6:303:dc:cafe::18) by MW4PR03CA0347.outlook.office365.com
 (2603:10b6:303:dc::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9253.13 via Frontend Transport; Sun,
 26 Oct 2025 14:19:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ1PEPF00002326.mail.protection.outlook.com (10.167.242.89) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9275.10 via Frontend Transport; Sun, 26 Oct 2025 14:19:41 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Sun, 26 Oct
 2025 07:19:28 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Sun, 26 Oct
 2025 07:19:27 -0700
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Sun, 26 Oct 2025 07:19:26 -0700
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
Subject: [PATCH v4 3/3] vfio/nvgrace-gpu: register device memory for poison handling
Date: Sun, 26 Oct 2025 14:19:19 +0000
Message-ID: <20251026141919.2261-4-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251026141919.2261-1-ankita@nvidia.com>
References: <20251026141919.2261-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002326:EE_|LV9PR12MB9760:EE_
X-MS-Office365-Filtering-Correlation-Id: 104b4566-318d-453c-9d90-08de149ab444
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|7416014|376014|921020|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gNOMF11kKR7xob1kJklxMjBEzWwktIa0Oy5L6/0hnMuAvDGrL8OgVUhSogfx?=
 =?us-ascii?Q?yZHQYs/SQ7K5F0KHgMncJMLPs2ITNlerZDNNc5MBjXuGai/ekQGZGSOrV4FQ?=
 =?us-ascii?Q?FU7P0fnhEmO5EEdu7SJ0TQUL++6JkorLgivvOsLzj9pVokmdfv6VbewAdELF?=
 =?us-ascii?Q?yclsOzOQw6zzKm92ramoLKXhA+Cc8G0dFx0CLiz7enO+6kVSvQ1LS5pRy0/n?=
 =?us-ascii?Q?+aSM9uR0Vl32nCgmqnOQHIf/slH5wxvkkxV5Ff+WGGTMN+LUjgqNnJpT64WP?=
 =?us-ascii?Q?coexywk5dyGohC+8crf0olNILNXc6pHE0L/YzJhq8pUJWwX7Ht5QsrBSOAnm?=
 =?us-ascii?Q?ktzA88zpqtO45yCnNasuod3ObldBIQQwb6DFHW+OktDrqTHehao3CT3PnQlL?=
 =?us-ascii?Q?SPY6fJe49K66ASgp9PhL9i8O+I33FtyP7ImoTvc+PpJO6Fu8kRFQtdx3Elfx?=
 =?us-ascii?Q?EypOkCMA0TnvtkfsakFwnDV/j2MBhtSeNGdSDF6oYC2wLKuAEUIb8OixFRq1?=
 =?us-ascii?Q?k3X9prrgOPyuqeW5/yinr1xrm7o8IoLPeCVYJod+pfj6fWor3qKGHdzFSz8y?=
 =?us-ascii?Q?IfDqa7U6DHw5z+1MOYg1Lhw0VTYOauOGVrhPZYtzebmZ8xQXiNa/kOXOj7wD?=
 =?us-ascii?Q?KBEoH9YHyBiU/xOR1yvzeoaVp0iYCK4qOgkKHRigYL9vUnf9WbylIO7t+LH/?=
 =?us-ascii?Q?ukSSKXnGu2IGihfE/+joiv+SRERT6W/fjkIKehZrjpIK82m4orCjnOxNnMyX?=
 =?us-ascii?Q?PVmutyP+o2wnLzU9Dm99MQmY+EMkyLxJGl7SQdE4Zs1CpSGGvV2fssXQLPRa?=
 =?us-ascii?Q?r2ndwC884PVLc9whrOU2KJHb5Q669+LxTaUpGi9nHaX79fBL1vAlZwxOwE8H?=
 =?us-ascii?Q?yq+N30qDXz/sEaBTpV03jXwYxi9Qm4pcNr7eqPi4/Nfx8btH3SfdvMrTb+ss?=
 =?us-ascii?Q?B9XQH1RH1PG88jwwH8IcReRQ7FVJPofp6HjujBQl5eP1yO+jnZ4xRkdmET7U?=
 =?us-ascii?Q?E+5gYSTiX8Cnwl7qHUiunFrSuuAV2zH+7SwE5PB58p9EWPHJe7mMoBonllGV?=
 =?us-ascii?Q?LPRHM5eTRSfbw47j4hb4Twl5FErqPlpGcdSjHNfnO1Ts38NfLKUiUP4QTG+o?=
 =?us-ascii?Q?GVpQVPpzFPGi7g8anhYz+uFjUwNcTvZHcmb6KunHEDgD3uU40dgc6jahuAun?=
 =?us-ascii?Q?oCAOjUDGfeeRXk8/PqVcRFzNavjCo9fAzQJ3y6Au/2KUvkyD7PcGy2cjxHIj?=
 =?us-ascii?Q?AVZEWlsqMtnzPHl4UGnyC481Tyo2twySbktSiozVdel9kDTNsTsfhWCxJ1/8?=
 =?us-ascii?Q?YyAO0w10FHtI/jKOosPtzTS98I0k4fPOgPHXVj9JncslSgf7iweaT/P9BzyK?=
 =?us-ascii?Q?NPnsSXPMltoM54sA40iGcyNuPZMhANmncrZnsixWKvjB/yHBxnd1qlUN1+HR?=
 =?us-ascii?Q?R+7g44NsSOLKDuXqeRO9i3te8An58R5F7yC0gq7914H1Mx5zPska/6LkkE7n?=
 =?us-ascii?Q?Xn0f3jrF1kUyucTRDczADginue5D2yvCse7CWexLEfAYwfFmBJ8jkJ3QBMT/?=
 =?us-ascii?Q?MoxCdfS/PiefMKmpPuzAwr4Fcknod4w6m8EbAMvV?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(7416014)(376014)(921020)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2025 14:19:41.4433
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 104b4566-318d-453c-9d90-08de149ab444
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002326.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV9PR12MB9760

From: Ankit Agrawal <ankita@nvidia.com>

The nvgrace-gpu-vfio-pci module [1] maps the device memory to the user VA
(Qemu) using remap_pfn_range() without adding the memory to the kernel.
The device memory pages are not backed by struct page. The previous
patch implements the mechanism to handle ECC/poison on memory page without
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


