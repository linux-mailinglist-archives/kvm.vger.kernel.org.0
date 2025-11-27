Return-Path: <kvm+bounces-64902-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id D81D8C8F99E
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 18:09:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 5E9CA3508F2
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 17:09:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3DB22EC571;
	Thu, 27 Nov 2025 17:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="llZmtjuo"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011028.outbound.protection.outlook.com [40.93.194.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A3A02E8E06;
	Thu, 27 Nov 2025 17:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764263222; cv=fail; b=GrnbY5CA7tFC82b5Xa9uL54M6WVCKSjXybObiOGkd30o+S7k57AjbyCwtCSepDgd4M5DIHKP1/uRyxZFTnzNUdm5VbM+ThuT/DqcJE+nGgX4jqewtt8oENGXs2moMyp930r7HI2Fjzfk7mr7UkjRvrr4hqmmN9+8UfAt5XpA41I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764263222; c=relaxed/simple;
	bh=82PwHCR6stma/BKEE+A/xfHcGazOVPyL5bIVihXcL64=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VS9BvTZ05k/EQCbfSCBhQOWgF0zqUws/l0SZkUzPgOh8Xmxz/gKDv969wX4K2ykYuzZ8Q+zt9PVA40IJYH1VpclThD+axz2qC/s1suqAMrYa1sG2BRBb6ee/p2anOa9FpuemILgsvnc+IVOWtIsFJ9BZb9SNsz5vW2wx+9OeDjo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=llZmtjuo; arc=fail smtp.client-ip=40.93.194.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fnRCQEd4zcnArHoD6S1gkFUAdB+nAaC3JIcbKYWHgGmndH/BT0TybRRm5gN938MH60u7bWwRGeNEae289xWEVV23/CJqgwiYdDQ8SECNr3zU0p49XaOuACOOVEKnI58BR13TIgCH5gUtgVBuNz36faquFbHreSm6u63bNHjm4FyZ4SPWlMENXfIAts+JWwUq/SXbqaCudmcbiFF53SBbqEJTY+klDr0KKP8RcfjS2zk1RDHI2DBKiK+c9Amh6woLWlBEuChiNvah9b6DvKmDTjCJKtRx/F5f3mc+Q83IglArv5YACO6hBwQ6/agtTUvM5OKWpFfIrxsU2c7LcTYnvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=saMCv8YeSsLXEbenLKKfKdy6XKnlzOMSJDm/XSgAouI=;
 b=Yiwv0v7A2uYBPNAY53PAKUl2DtVlQ5jXKgBcnetpFm5W6FmBPU3BPAlkApi6t7LwTIMRmpNIDQt4rD7BWcMo2CBM83vFjbcHHwUkMKQyR0MYHHVM9beCivDxyAlrEsqiatJNS0giXCP/0goYRGZbC5BWqIeWC1KZWDjkWXC110BobRO66GMfoO6ASLt6VAcWvVHbmVk3Uw+KCx3/CPUYA4H+3fyYkfZfDaQ2fJF5kB9KJS0OsW9hkK0MnhotjlGh9e+3ADKRvV0aI0bIpB66weHFuKPuXpt0Z//oH0xp6K97yttpSgB1+79fH+TOZgdX+gJql2Qi2Kcq7JNVaup72g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=saMCv8YeSsLXEbenLKKfKdy6XKnlzOMSJDm/XSgAouI=;
 b=llZmtjuo9dz1LBR963taSc8ZNkggD4KqYwAAsNGt6xjPvTpbs9WeQANe2Gc0tGX6HGjzmZRWLfNkoK9lRBCWQuCPOewAxNAAfcqE5QfN0fs7G0mREcS/H3FdCD442b3//5ipE9cDUD6WI8TYTcGAOpscerSXUyC63zG4RbE1sxgVJPtPmNDhs2pCl7wrTmrXmxGajx/y6SQrx3pFeVuqbGqrDl3ogycf9Y7tf4mp6CtvsQssi/9zrGKIh97YOPxKPx0UVkI0ZI6CrBBQT6XsBvszZNDpAd20wQqTtlZZACTRxp+3424KQN6xH+jrf3FDweQQOQ5ZSqtlQguxkx3Hjw==
Received: from SA1P222CA0083.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:35e::21)
 by SJ0PR12MB5673.namprd12.prod.outlook.com (2603:10b6:a03:42b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.12; Thu, 27 Nov
 2025 17:06:54 +0000
Received: from SA2PEPF00003F62.namprd04.prod.outlook.com
 (2603:10b6:806:35e:cafe::9a) by SA1P222CA0083.outlook.office365.com
 (2603:10b6:806:35e::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9366.15 via Frontend Transport; Thu,
 27 Nov 2025 17:06:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SA2PEPF00003F62.mail.protection.outlook.com (10.167.248.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.7 via Frontend Transport; Thu, 27 Nov 2025 17:06:53 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 27 Nov
 2025 09:06:39 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 27 Nov
 2025 09:06:38 -0800
Received: from
 gb-nvl-073-compute01.l16.internal032k18.bmc032b17.internal032f11.internal032huang.bmc032l04.bmc
 (10.127.8.11) by mail.nvidia.com (10.129.68.7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20 via Frontend Transport; Thu, 27 Nov 2025 09:06:38 -0800
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
Subject: [PATCH v9 6/6] vfio/nvgrace-gpu: wait for the GPU mem to be ready
Date: Thu, 27 Nov 2025 17:06:32 +0000
Message-ID: <20251127170632.3477-7-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F62:EE_|SJ0PR12MB5673:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e3daf69-50cc-4641-8c44-08de2dd75d51
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+3EK/OmT/4YUFW/ZFrgUHB6IjYoiIAQ0ZV2N9+GN3GA4oLG2xPZuL+oFL/ic?=
 =?us-ascii?Q?Ck1hRT71wgvsIPkQZauLoWZfElCA0jNFpvPpGhs8kk4eMhwKAmljc8a4Zoc7?=
 =?us-ascii?Q?/ZmTBWp9DRMOponRsHV9LWJlVxXub3HLPiUzhQsTm+Q125/bEWKm4GvBPfDK?=
 =?us-ascii?Q?JBpyHQ+tRyzlPjFxMkcMBfoJsxqVGJBn+Av32XB4BGp6JW3q+/r0Zg3XxLNY?=
 =?us-ascii?Q?VtEa8u2Go2I1F2raUbkNzUhRXeeYVwyzIovaUoSODvOtpjvO3w/LLtaqRwE2?=
 =?us-ascii?Q?QpO5D5cKN4ubr0RAL8mwKLCt4/ykMRgkLf/ezB9wzbCmXprwSvoINzOXeYUq?=
 =?us-ascii?Q?BOImw7Sg3c73S/rZr2iNQZEm/aHyEPs7zZ30/SCDj28R7gRNdwJiOWySkSqV?=
 =?us-ascii?Q?wI3+sRgAbE2wirmiAOuW8uH/a6++GqJYEj9UbWH9hPfXy7qCZO2h2BWHOb4C?=
 =?us-ascii?Q?joCmStwqIgm4h0R7nkXlyohiZ3bEfaG5aIqPeivLeWdgBZgfWfSVX78S9fiB?=
 =?us-ascii?Q?pKCmGtkAcvwPEk+80JKnSXiw4EnJ7vDWwkRy0WceZS/w+z+AffQRtTSRVmo9?=
 =?us-ascii?Q?zzMS2QEkwKxP3rBK+x1SaubS2hqYEX2jvomXUn18jA6QEgvzPSMywFq0PIKg?=
 =?us-ascii?Q?qiF4ywlD58OsfQ3bQc7Fz6How2PxdwSRgnEdFLwABhnW3eMgyhz3hQL2zGq3?=
 =?us-ascii?Q?I7tJzs2me68tJciOr4Yxrvan7vHMFIAeyL5bUYT56ZO3GzHXkEgEi1YnJG3V?=
 =?us-ascii?Q?eO0o3FJto000MAw1n9JkdHvcI0sdwXU7PKa4xtteORSSv94r7ko5csoaqpNm?=
 =?us-ascii?Q?Ajr0bXoSgdXknT4+Iy92YqaTHCGeSwbSa+0aguIuMmHqZkfeev7hy82TkEyL?=
 =?us-ascii?Q?/G+0LwvppFda7RYUiM34RF/V0foJoTQZi6CxoMYNjnamRXXdHKPQmqoB/x20?=
 =?us-ascii?Q?zUTGfVWVFePcI/x9OfI1RffRy+Lzhc3Sa+2JatN097Q5yVlk4dRBoT9rhJiF?=
 =?us-ascii?Q?fCDS0phf5ywd5zcOrV3NFW4J0I5+b2I5PB1XcwTkuhNNWtksZqewdrWNet6j?=
 =?us-ascii?Q?JT19fqdja9uU6IkMRlYjWWRyIS7LTjNhfiDAs1ehrTbpZ2pYbr2PyXpr5dzA?=
 =?us-ascii?Q?GbHGfiMRgr8QmoXq+yr/HbzXEflj649qSGhIIZGvhAOTmBTeZy/nVP8puzGj?=
 =?us-ascii?Q?+U8Z5rhblEgdbHzyvAMnjQMInktrMiqB8OXUCxEbahZVSmFsQuzGDduQNtL9?=
 =?us-ascii?Q?oo8FJDQj4irQoautm42bB2+bRJIWgBxhFVeWMnWHE5mJbSZTWRSygWki80UI?=
 =?us-ascii?Q?TTpgvw3FBCVRUrOYWZs+cU7whSU4RL2aj1OxgUkDE5JKJnByoXQUwMphiGti?=
 =?us-ascii?Q?e9NrsJkBdhas/UTi96mm4DkOfDslAFqGM3Li6DitYKPc/MhumGiIExOjHnRe?=
 =?us-ascii?Q?jWlAoByC+bgqzFZxCPYky+Ptim4fd49F4jjXtbMm7M9bVru/PHIL9eYXbiNV?=
 =?us-ascii?Q?JHhgVRDEnXs6WCcQILedM+Sj2iLk4dJnP/T9G9WubnP6kGre2T/7fP43vz9G?=
 =?us-ascii?Q?GC4Ls5eXvoytf89BESM=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2025 17:06:53.8505
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e3daf69-50cc-4641-8c44-08de2dd75d51
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F62.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5673

From: Ankit Agrawal <ankita@nvidia.com>

Speculative prefetches from CPU to GPU memory until the GPU is
ready after reset can cause harmless corrected RAS events to
be logged on Grace systems. It is thus preferred that the
mapping not be re-established until the GPU is ready post reset.

The GPU readiness can be checked through BAR0 registers similar
to the checking at the time of device probe.

It can take several seconds for the GPU to be ready. So it is
desirable that the time overlaps as much of the VM startup as
possible to reduce impact on the VM bootup time. The GPU
readiness state is thus checked on the first fault/huge_fault
request or read/write access which amortizes the GPU readiness
time.

The first fault and read/write checks the GPU state when the
reset_done flag - which denotes whether the GPU has just been
reset. The memory_lock is taken across map/access to avoid
races with GPU reset.

Also check if the memory is enabled, before waiting for GPU
to be ready. Otherwise the readiness check would block for 30s.

Lastly added PM handling wrapping on read/write access.

Cc: Shameer Kolothum <skolothumtho@nvidia.com>
Cc: Alex Williamson <alex@shazbot.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Vikram Sethi <vsethi@nvidia.com>
Reviewed-by: Shameer Kolothum <skolothumtho@nvidia.com>
Suggested-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/main.c | 103 ++++++++++++++++++++++++----
 drivers/vfio/pci/vfio_pci_config.c  |   1 +
 drivers/vfio/pci/vfio_pci_priv.h    |   1 -
 include/linux/vfio_pci_core.h       |   1 +
 4 files changed, 93 insertions(+), 13 deletions(-)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index bf0a3b65c72e..bf54d1c6bd73 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -7,6 +7,7 @@
 #include <linux/vfio_pci_core.h>
 #include <linux/delay.h>
 #include <linux/jiffies.h>
+#include <linux/pm_runtime.h>
 
 /*
  * The device memory usable to the workloads running in the VM is cached
@@ -104,6 +105,19 @@ static int nvgrace_gpu_open_device(struct vfio_device *core_vdev)
 		mutex_init(&nvdev->remap_lock);
 	}
 
+	/*
+	 * GPU readiness is checked by reading the BAR0 registers.
+	 *
+	 * ioremap BAR0 to ensure that the BAR0 mapping is present before
+	 * register reads on first fault before establishing any GPU
+	 * memory mapping.
+	 */
+	ret = vfio_pci_core_setup_barmap(vdev, 0);
+	if (ret) {
+		vfio_pci_core_disable(vdev);
+		return ret;
+	}
+
 	vfio_pci_core_finish_enable(vdev);
 
 	return 0;
@@ -146,6 +160,34 @@ static int nvgrace_gpu_wait_device_ready(void __iomem *io)
 	return -ETIME;
 }
 
+/*
+ * If the GPU memory is accessed by the CPU while the GPU is not ready
+ * after reset, it can cause harmless corrected RAS events to be logged.
+ * Make sure the GPU is ready before establishing the mappings.
+ */
+static int
+nvgrace_gpu_check_device_ready(struct nvgrace_gpu_pci_core_device *nvdev)
+{
+	struct vfio_pci_core_device *vdev = &nvdev->core_device;
+	int ret;
+
+	lockdep_assert_held_read(&vdev->memory_lock);
+
+	if (!nvdev->reset_done)
+		return 0;
+
+	if (!__vfio_pci_memory_enabled(vdev))
+		return -EIO;
+
+	ret = nvgrace_gpu_wait_device_ready(vdev->barmap[0]);
+	if (ret)
+		return ret;
+
+	nvdev->reset_done = false;
+
+	return 0;
+}
+
 static unsigned long addr_to_pgoff(struct vm_area_struct *vma,
 				   unsigned long addr)
 {
@@ -175,8 +217,13 @@ static vm_fault_t nvgrace_gpu_vfio_pci_huge_fault(struct vm_fault *vmf,
 	pfn = PHYS_PFN(memregion->memphys) + addr_to_pgoff(vma, addr);
 
 	if (is_aligned_for_order(vma, addr, pfn, order)) {
-		scoped_guard(rwsem_read, &vdev->memory_lock)
+		scoped_guard(rwsem_read, &vdev->memory_lock) {
+			if (vdev->pm_runtime_engaged ||
+			    nvgrace_gpu_check_device_ready(nvdev))
+				return VM_FAULT_SIGBUS;
+
 			ret = vfio_pci_vmf_insert_pfn(vdev, vmf, pfn, order);
+		}
 	}
 
 	dev_dbg_ratelimited(&vdev->pdev->dev,
@@ -563,6 +610,7 @@ static ssize_t
 nvgrace_gpu_read_mem(struct nvgrace_gpu_pci_core_device *nvdev,
 		     char __user *buf, size_t count, loff_t *ppos)
 {
+	struct vfio_pci_core_device *vdev = &nvdev->core_device;
 	u64 offset = *ppos & VFIO_PCI_OFFSET_MASK;
 	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
 	struct mem_region *memregion;
@@ -589,9 +637,15 @@ nvgrace_gpu_read_mem(struct nvgrace_gpu_pci_core_device *nvdev,
 	else
 		mem_count = min(count, memregion->memlength - (size_t)offset);
 
-	ret = nvgrace_gpu_map_and_read(nvdev, buf, mem_count, ppos);
-	if (ret)
-		return ret;
+	scoped_guard(rwsem_read, &vdev->memory_lock) {
+		ret = nvgrace_gpu_check_device_ready(nvdev);
+		if (ret)
+			return ret;
+
+		ret = nvgrace_gpu_map_and_read(nvdev, buf, mem_count, ppos);
+		if (ret)
+			return ret;
+	}
 
 	/*
 	 * Only the device memory present on the hardware is mapped, which may
@@ -616,9 +670,16 @@ nvgrace_gpu_read(struct vfio_device *core_vdev,
 	struct nvgrace_gpu_pci_core_device *nvdev =
 		container_of(core_vdev, struct nvgrace_gpu_pci_core_device,
 			     core_device.vdev);
+	struct vfio_pci_core_device *vdev = &nvdev->core_device;
+	int ret;
 
-	if (nvgrace_gpu_memregion(index, nvdev))
-		return nvgrace_gpu_read_mem(nvdev, buf, count, ppos);
+	if (nvgrace_gpu_memregion(index, nvdev)) {
+		if (pm_runtime_resume_and_get(&vdev->pdev->dev))
+			return -EIO;
+		ret = nvgrace_gpu_read_mem(nvdev, buf, count, ppos);
+		pm_runtime_put(&vdev->pdev->dev);
+		return ret;
+	}
 
 	if (index == VFIO_PCI_CONFIG_REGION_INDEX)
 		return nvgrace_gpu_read_config_emu(core_vdev, buf, count, ppos);
@@ -680,6 +741,7 @@ static ssize_t
 nvgrace_gpu_write_mem(struct nvgrace_gpu_pci_core_device *nvdev,
 		      size_t count, loff_t *ppos, const char __user *buf)
 {
+	struct vfio_pci_core_device *vdev = &nvdev->core_device;
 	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
 	u64 offset = *ppos & VFIO_PCI_OFFSET_MASK;
 	struct mem_region *memregion;
@@ -709,9 +771,15 @@ nvgrace_gpu_write_mem(struct nvgrace_gpu_pci_core_device *nvdev,
 	 */
 	mem_count = min(count, memregion->memlength - (size_t)offset);
 
-	ret = nvgrace_gpu_map_and_write(nvdev, buf, mem_count, ppos);
-	if (ret)
-		return ret;
+	scoped_guard(rwsem_read, &vdev->memory_lock) {
+		ret = nvgrace_gpu_check_device_ready(nvdev);
+		if (ret)
+			return ret;
+
+		ret = nvgrace_gpu_map_and_write(nvdev, buf, mem_count, ppos);
+		if (ret)
+			return ret;
+	}
 
 exitfn:
 	*ppos += count;
@@ -725,10 +793,17 @@ nvgrace_gpu_write(struct vfio_device *core_vdev,
 	struct nvgrace_gpu_pci_core_device *nvdev =
 		container_of(core_vdev, struct nvgrace_gpu_pci_core_device,
 			     core_device.vdev);
+	struct vfio_pci_core_device *vdev = &nvdev->core_device;
 	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
+	int ret;
 
-	if (nvgrace_gpu_memregion(index, nvdev))
-		return nvgrace_gpu_write_mem(nvdev, count, ppos, buf);
+	if (nvgrace_gpu_memregion(index, nvdev)) {
+		if (pm_runtime_resume_and_get(&vdev->pdev->dev))
+			return -EIO;
+		ret = nvgrace_gpu_write_mem(nvdev, count, ppos, buf);
+		pm_runtime_put(&vdev->pdev->dev);
+		return ret;
+	}
 
 	if (index == VFIO_PCI_CONFIG_REGION_INDEX)
 		return nvgrace_gpu_write_config_emu(core_vdev, buf, count, ppos);
@@ -1051,7 +1126,11 @@ MODULE_DEVICE_TABLE(pci, nvgrace_gpu_vfio_pci_table);
  * faults and read/writes accesses to prevent potential RAS events logging.
  *
  * First fault or access after a reset needs to poll device readiness,
- * flag that a reset has occurred.
+ * flag that a reset has occurred. The readiness test is done by holding
+ * the memory_lock read lock and we expect all vfio-pci initiated resets to
+ * hold the memory_lock write lock to avoid races. However, .reset_done
+ * extends beyond the scope of vfio-pci initiated resets therefore we
+ * cannot assert this behavior and use lockdep_assert_held_write.
  */
 static void nvgrace_gpu_vfio_pci_reset_done(struct pci_dev *pdev)
 {
diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 333fd149c21a..d0cc5f04a8f2 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -416,6 +416,7 @@ bool __vfio_pci_memory_enabled(struct vfio_pci_core_device *vdev)
 	return pdev->current_state < PCI_D3hot &&
 	       (pdev->no_command_memory || (cmd & PCI_COMMAND_MEMORY));
 }
+EXPORT_SYMBOL_GPL(__vfio_pci_memory_enabled);
 
 /*
  * Restore the *real* BARs after we detect a FLR or backdoor reset.
diff --git a/drivers/vfio/pci/vfio_pci_priv.h b/drivers/vfio/pci/vfio_pci_priv.h
index a9972eacb293..7b1776bae802 100644
--- a/drivers/vfio/pci/vfio_pci_priv.h
+++ b/drivers/vfio/pci/vfio_pci_priv.h
@@ -60,7 +60,6 @@ void vfio_config_free(struct vfio_pci_core_device *vdev);
 int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev,
 			     pci_power_t state);
 
-bool __vfio_pci_memory_enabled(struct vfio_pci_core_device *vdev);
 void vfio_pci_zap_and_down_write_memory_lock(struct vfio_pci_core_device *vdev);
 u16 vfio_pci_memory_lock_and_enable(struct vfio_pci_core_device *vdev);
 void vfio_pci_memory_unlock_and_restore(struct vfio_pci_core_device *vdev,
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 3117a390c4eb..6db13f66b5e4 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -137,6 +137,7 @@ ssize_t vfio_pci_core_do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
 			       void __iomem *io, char __user *buf,
 			       loff_t off, size_t count, size_t x_start,
 			       size_t x_end, bool iswrite);
+bool __vfio_pci_memory_enabled(struct vfio_pci_core_device *vdev);
 bool vfio_pci_core_range_intersect_range(loff_t buf_start, size_t buf_cnt,
 					 loff_t reg_start, size_t reg_cnt,
 					 loff_t *buf_offset,
-- 
2.34.1


