Return-Path: <kvm+bounces-64721-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E7479C8B93E
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 20:30:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 70E4D3AABF9
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 19:30:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C7E6326D6E;
	Wed, 26 Nov 2025 19:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DVrtm//R"
X-Original-To: kvm@vger.kernel.org
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012037.outbound.protection.outlook.com [52.101.43.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 445F5340264;
	Wed, 26 Nov 2025 19:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764185357; cv=fail; b=o93spKoTMjXFC3TgaaB75dX53QRz6XODNpK6L2xNwbHk+VOpvaBifG95ojokz2AySzWmZU873q/qohPcteTxcJnJXD1tlkZM0G9P6ymQb+iBstANGrTbfPtECfTF9LDsbbMEbnWR0VYaXyThHLd9cgCwFkZID06au/TQW6TUasA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764185357; c=relaxed/simple;
	bh=m+fso94tf/YoqKA12CIw4OLJI/vFakQ1N3zU2leWwqI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eZMdRf6pwj6uZGGJPSAbiTDuHM1ZSOJrFuFZtjiJC+t/kCnytX2bfkF/pXNJHW/d6OEvBW5MaBebyqTIdg9KOIUab4cO3VtQRpb2Wp7M/1wChj6ociliHI70eGfHMVdOVa1P82IKRxNVh/eHELMxiE8VMNXT7pV8PTNbhtwVRPI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DVrtm//R; arc=fail smtp.client-ip=52.101.43.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H/wMWB57/211JfLqgy3fpo/dOPBDz0/SeGsLJ3/eEHa1Oe4BML6oEq56sb3YELE05KvyqqQ00bOEWJXvNQBskNh2M8ILquXyNl3QEFCien0qGtjtbLqgOF2GhgfwQXqjGk6zi/UPVvMF4HO993xdfAViF9t3WNH6LWElwdns5Iol8xXd6fbmqXVEDre6IH5cAOzke34JtJVx4XC1AAslXsUG0iMMShdQXNqgdEIyjb9vgbzDhbvbNVLVkrPFXo6BL+Qp0WvOHPa9jZOZDGInUcEkzandb/9v+3JXE3rKp80Xd1f9f+gxHLIdkPwUyuwzD/eqKEDxsqt0ENeQ4ikGVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x9ril1aQ1WJ9eXnm+DfYSfDBfKpJ5vz+St01CclQFDQ=;
 b=MTZooYI9Og4XTnAGKnhRScYzrgii5XJ3QSt/q+FiLs485M1C/S/SMhTOQEHmeqsBFSb6QOnkaeAO0EYmp/V407HG//EQYv4OvhkNvvU/mKFiwaOwYCgleL4z3dvRR7qzVIoY5F3r2sCoIihO3OQrO++tYareWiNZFl1BDOiyRUHzU51c4BdQYPyoy2Vmltw5wXy1hyv+iZUFhU3k8w3k4AX85qu93KuPVNPiODQ+D7XcmyipTyN6wTM6JpatOo9ILzUKng03PpKUBwjnbXkSxHPfFKbptcFSqlIryFqGfDMWmJtsatXCpbwA2ajxlkrQsTrbStAlIDdC2IKgTajsIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x9ril1aQ1WJ9eXnm+DfYSfDBfKpJ5vz+St01CclQFDQ=;
 b=DVrtm//ROFI1uPT1sy2Dl5Hoj36SodXNvRgtdNMeto8PUCQIxQC56ZOwpRMSaaNY+tpKj/1K8MOinwC9bd/MS4Fay7AgwkCcGSsPnLsas/LVMPlNvRQlwdiQCiQ0Vh/Soy4H6mEdlx9OC+jbtJAfvL4+3fp7XMoAeM+XNEOys3a+T/sNflLF+Otft0sFuzxVTqidPUER+5saMN8nxnScDaDJvMbzOseb3As04tn0CNo6wCxo4Fh43KyVJaVcctW83CoIqyCryGbqPQDRll0L2UJ4dkxADcwHPnqVgiGVeI3xx7pRi732Z1tqz5PoI98zLLh3AJNjQrxXxtwanA+oYQ==
Received: from BN9P222CA0029.NAMP222.PROD.OUTLOOK.COM (2603:10b6:408:10c::34)
 by CH3PR12MB7620.namprd12.prod.outlook.com (2603:10b6:610:150::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.11; Wed, 26 Nov
 2025 19:29:07 +0000
Received: from BN1PEPF0000468C.namprd05.prod.outlook.com
 (2603:10b6:408:10c:cafe::ec) by BN9P222CA0029.outlook.office365.com
 (2603:10b6:408:10c::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9366.13 via Frontend Transport; Wed,
 26 Nov 2025 19:29:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN1PEPF0000468C.mail.protection.outlook.com (10.167.243.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.7 via Frontend Transport; Wed, 26 Nov 2025 19:29:07 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 26 Nov
 2025 11:28:49 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Wed, 26 Nov 2025 11:28:49 -0800
Received: from
 gb-nvl-073-compute01.l16.internal032k18.bmc032b17.internal032f11.internal032huang.bmc032l04.bmc
 (10.127.8.11) by mail.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20 via Frontend Transport; Wed, 26 Nov 2025 11:28:49 -0800
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
Subject: [PATCH v8 6/6] vfio/nvgrace-gpu: wait for the GPU mem to be ready
Date: Wed, 26 Nov 2025 19:28:46 +0000
Message-ID: <20251126192846.43253-7-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF0000468C:EE_|CH3PR12MB7620:EE_
X-MS-Office365-Filtering-Correlation-Id: 4724d532-d292-4e4f-a81a-08de2d221158
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vknSx4V6wohL+JihAA3LFUmP3yDJROSAMHoKIdBSvOnejlE1Twwwo44m1dMU?=
 =?us-ascii?Q?pysl6letDQSAVUA59GuX6HTMjasz0iIb8mD17q2Pqv219m8ihvWzf5CgzlLK?=
 =?us-ascii?Q?ZwZL6hkr5Qk2CLUJdB9cdBW4D+qpI92dxm+S4ZRIn84mkjgATz+AUSGseIf6?=
 =?us-ascii?Q?kyXIY/wMgDR/XVLdY8BwM3jdWGJ4rsq7Sy9MyhZ/Oz0tkKMDfkD/BLMlULGP?=
 =?us-ascii?Q?fGnulBwL5AzaSXgW1a/yDN3D7RHK2eLDCkagd75hCiSoVTW6r7UbuoBHtgSw?=
 =?us-ascii?Q?dx28G5XYP3ygXspPlq0l9JF5pHqxN5vmtfF9AVIA4FrNQC+i+R1st8JTdjBt?=
 =?us-ascii?Q?b3Q49eIZ/GLB9VmSuRzCbpwh6exYKHSilc5dIKe5YzbbgAknU9ZU319Jk2sv?=
 =?us-ascii?Q?lcphnixDRc3Rgg1KGL2GuKJ8FeclokVKHgDcS8AEFUboYh04LD/Xq66JAn8H?=
 =?us-ascii?Q?WgDHb/X14SulY2AAMVPToWj7qV2EcCsJuwpkfmdhC+X007dc+IsiHNrSTXJu?=
 =?us-ascii?Q?wPh5/jdnOax+IWK3sNBx0a5CDRUBUE6+SjkTkmFuiTfyWdpE7ndJ+p3Bz7v1?=
 =?us-ascii?Q?mbZ82rUl8rHXjtHrd7de6WMeH+HzcF6o5d3F5MtMSiT4J/Cma+WL4x7Nx/TW?=
 =?us-ascii?Q?NBvzIxVad2KiM5i+9DB32mGwF2lctNs+3aqwOjdFkADbEAeB6kGDJnrwNd4K?=
 =?us-ascii?Q?zbEFNy0KMhOD3v6XT0RV7APq8ztuNc6mDzgsh24aeKuISvuLmZ55a2L7nAHb?=
 =?us-ascii?Q?SZkiBkLpkjEVeGwKyTXPLay0Obk8mjRX18fy25mzZE5ziZFYjQnqGNSRnYSp?=
 =?us-ascii?Q?3apU9TZtxdNkOfFlc3zgCO9Lw8LKGGP2fHSURk1ya5PghE24p02EcxA5o+qA?=
 =?us-ascii?Q?4qUySNtJpv5f18nzQzXCDdaFvFHRzXhyZz74AiNoxwPXmMBjq6NULQlEgaYn?=
 =?us-ascii?Q?4fo6asFYusv6e8szrds+PTsMN5JVJ3S/2VAgmPzleER30+h2GWz3W/qkbcnd?=
 =?us-ascii?Q?Z3k2GDQJgkD7Itdie//jP0jNQYRn65ezuC11cgPzXzK23+2He23BhtUKQsfe?=
 =?us-ascii?Q?7tAQW8fvomNj+6ExryuLqKEV3Jf8oRbmIREx8W+n8E68R8kbKCWvHqq9Gupy?=
 =?us-ascii?Q?rWaOzvQ11iWhDmJFkrGKR7EFJe+MAR0sTG+JMGwmobezHljZVV5L0BVKjckk?=
 =?us-ascii?Q?qTza9smOMiIt1b2fLypOBJAf3/ISwCUylngCddyC+d6G3/mApFC+q3kioQ3J?=
 =?us-ascii?Q?ZqEYwFM7b2I0FmOxhliqx4+OQ+ldkCA1gPbSzsqY04jS4D9c7o5KSGZ5Lnhw?=
 =?us-ascii?Q?aEjE20ysRh25Jfs/i2bA5lYE5SgwOHIgXYagzlHFtpJCXpvq3iif3UITgGqc?=
 =?us-ascii?Q?D+sBgknrpowgwDAt4+4xA0BWYGEAKKMQp8VDLUYYf1BoDD5snu/F99yMsyEl?=
 =?us-ascii?Q?VJJUFFXOQzRxTVYEwtXThWVTFgPGk9w1sg14HbzsxA1Vby6xAi3E4AtxjVKq?=
 =?us-ascii?Q?2MVU3V6IWnlCsgNkQCyLfx+8zDdmkg44NjTnU23nhVVuVHvhSU8JSfFOaeQI?=
 =?us-ascii?Q?06WUMe8tL3uPXVUda5A=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2025 19:29:07.4659
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4724d532-d292-4e4f-a81a-08de2d221158
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF0000468C.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7620

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

Cc: Shameer Kolothum <skolothumtho@nvidia.com>
Cc: Alex Williamson <alex@shazbot.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Vikram Sethi <vsethi@nvidia.com>
Reviewed-by: Shameer Kolothum <skolothumtho@nvidia.com>
Suggested-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/main.c | 74 +++++++++++++++++++++++++----
 1 file changed, 66 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index bf0a3b65c72e..a37cd1ce4496 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -104,6 +104,19 @@ static int nvgrace_gpu_open_device(struct vfio_device *core_vdev)
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
@@ -146,6 +159,31 @@ static int nvgrace_gpu_wait_device_ready(void __iomem *io)
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
@@ -175,8 +213,12 @@ static vm_fault_t nvgrace_gpu_vfio_pci_huge_fault(struct vm_fault *vmf,
 	pfn = PHYS_PFN(memregion->memphys) + addr_to_pgoff(vma, addr);
 
 	if (is_aligned_for_order(vma, addr, pfn, order)) {
-		scoped_guard(rwsem_read, &vdev->memory_lock)
+		scoped_guard(rwsem_read, &vdev->memory_lock) {
+			if (nvgrace_gpu_check_device_ready(nvdev))
+				return VM_FAULT_SIGBUS;
+
 			ret = vfio_pci_vmf_insert_pfn(vdev, vmf, pfn, order);
+		}
 	}
 
 	dev_dbg_ratelimited(&vdev->pdev->dev,
@@ -589,9 +631,15 @@ nvgrace_gpu_read_mem(struct nvgrace_gpu_pci_core_device *nvdev,
 	else
 		mem_count = min(count, memregion->memlength - (size_t)offset);
 
-	ret = nvgrace_gpu_map_and_read(nvdev, buf, mem_count, ppos);
-	if (ret)
-		return ret;
+	scoped_guard(rwsem_read, &nvdev->core_device.memory_lock) {
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
@@ -709,9 +757,15 @@ nvgrace_gpu_write_mem(struct nvgrace_gpu_pci_core_device *nvdev,
 	 */
 	mem_count = min(count, memregion->memlength - (size_t)offset);
 
-	ret = nvgrace_gpu_map_and_write(nvdev, buf, mem_count, ppos);
-	if (ret)
-		return ret;
+	scoped_guard(rwsem_read, &nvdev->core_device.memory_lock) {
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
@@ -1051,7 +1105,11 @@ MODULE_DEVICE_TABLE(pci, nvgrace_gpu_vfio_pci_table);
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
-- 
2.34.1


