Return-Path: <kvm+bounces-64527-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EFB3C8636F
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 18:32:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E1E314E3D3C
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 17:31:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B41F832D0C3;
	Tue, 25 Nov 2025 17:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="U7wZ7zQ+"
X-Original-To: kvm@vger.kernel.org
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010005.outbound.protection.outlook.com [52.101.56.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7DC432BF46;
	Tue, 25 Nov 2025 17:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764091849; cv=fail; b=OAOMMiGl3mfi0aZkJExmp1bX4vlZSriUUCiWKeS9/6SXka2qZDh+iPoRnHwcWa7XWwzLrXA6xInq9ZcW1Q2/N6ABGR2m7kFTxgBByRrhN1z/JdONLbY7Ov5ipeoqQCbU6fWC1AWDKE5eZohogmHYy58yWDFS7AVmj7pmJ16TB9I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764091849; c=relaxed/simple;
	bh=lzop/8NdtNVihbwvk2aWSrUemcx8o7x3/zOJ8/zm7K4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JlFwW5jMgoN9eD1PzwsE2m9kQCBdQdZP5UMT1srgeV6bP5iSekUWj9e13/Kkcvmm5/zGzqWrqlH9FZ9Zv6gSs68Bhlnsx53RYGnSx9dd7nPLuFCnmQRKNjsweiT1F2L6j6k4HJllkP7O797/MsfYTDqBPJ5f+ddyZeIFmZDx25U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=U7wZ7zQ+; arc=fail smtp.client-ip=52.101.56.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GDUZcziAVc4DBnamKehTvqR+tLSjqcGziPnjAQGF2iJDn2mss+MBYcNAcmSLp/SyQ0zPAr50aI5KXREyhtBCQl+MW0W4nVcVT2dqfnQX87cccuK/u5563JV+R4VEgQw+xplnJMQmyYCabPxoVDVTPxY8nTLKJpgygkEE5GFXRBxih0kO8c1RYNtydJdPXP0JiZ9nF9n3DXQUITpSXx6kEu0Xale5NkpLAj+I//7sfFSMxOCPzK7Ng+sqR+iukDqMdw9VTEYUMRgb07m9dYijj0/cKZ8uKVpfv2olIFHOsvkPBh5PAvDglK5krB/muyum2BgP0XCm7WGlKdwC26kH3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xUqYHNkpa+tv5F9uljmltB/60mrDVrzUCEVu4LGHWbU=;
 b=KdAHHIsa3V9wWrLNcIaJUCPx5JyVKhdHGMfmWqglMwFhUveX+5paN5J96M2yruSZ1RlgyqAUaFRCnlsMFhkduOJNcXNdTKX5o5ZC84Z5uUxLjLlRJkqwVXXPUkgY56cM7/n9HFpkWIPH6c8fm9kKjVJV66sHqIaqM+nESdHHXTPJ9i9mZcZTPXnyPJhtsACH5upyv1gy0C+gqp/71Mf+03fFx16yDjPS154Nsq0pGIqeQ0odhjdNSzpaDoZxM0jmmr8AXYMUPyjInrEug+RhRxVZknaOGPucUvoSEb8KuBeq+RVi/+IMc0fHUFqMz7faDSmEvEvNfxkUpcCkt6c/rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xUqYHNkpa+tv5F9uljmltB/60mrDVrzUCEVu4LGHWbU=;
 b=U7wZ7zQ+S46GLAhPdfGnylexwX0IhStxb0dfeaF1v6cPnp974XMm5X6DSSV7jl/PgeA5E+Zqtl58BY6ACJQhBnmb/HGomLeCDJCVQnkgG6ocUY2y6VbWN26wjxJChS8AmHpydT8QtQnpIflVs2RmViVX2TVefD1qF8js6TKayzoCylVoS3aQfBncfOADZ7O5Gz7q/dGB4/J4TjfAwpFAlgLd8SMKWPiNrimRxYFHZVqVkEhJN2ZfQeesEIXlUIx4yC7sWt4/Det9Q8sOWEt6AVaKBovQC1HSF1CbqsfXdB/Z9B6raGOdpQ4djklmDxR+XdAXaSdLKkgn7dd/WgRM0g==
Received: from BN1PR12CA0004.namprd12.prod.outlook.com (2603:10b6:408:e1::9)
 by MW4PR12MB7311.namprd12.prod.outlook.com (2603:10b6:303:227::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.11; Tue, 25 Nov
 2025 17:30:43 +0000
Received: from BN3PEPF0000B073.namprd04.prod.outlook.com
 (2603:10b6:408:e1:cafe::9e) by BN1PR12CA0004.outlook.office365.com
 (2603:10b6:408:e1::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9366.11 via Frontend Transport; Tue,
 25 Nov 2025 17:30:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN3PEPF0000B073.mail.protection.outlook.com (10.167.243.118) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.7 via Frontend Transport; Tue, 25 Nov 2025 17:30:43 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 25 Nov
 2025 09:30:16 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Tue, 25 Nov 2025 09:30:15 -0800
Received: from
 gb-nvl-073-compute01.l16.internal032k18.bmc032b17.internal032f11.internal032huang.bmc032l04.bmc
 (10.127.8.11) by mail.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20 via Frontend Transport; Tue, 25 Nov 2025 09:30:15 -0800
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
Subject: [PATCH v6 6/6] vfio/nvgrace-gpu: wait for the GPU mem to be ready
Date: Tue, 25 Nov 2025 17:30:13 +0000
Message-ID: <20251125173013.39511-7-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251125173013.39511-1-ankita@nvidia.com>
References: <20251125173013.39511-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B073:EE_|MW4PR12MB7311:EE_
X-MS-Office365-Filtering-Correlation-Id: a72c2a4f-8920-4baf-4de5-08de2c485cab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OIY5QudvmkXEHn4Eui35pZaqepDxTA4RKYCZXbnE3xrzlpe6BwqLWCF7kJv/?=
 =?us-ascii?Q?EQrG5JKo7XB+KQnQvt4wBm5dQ7isa6vdjl0ZqLYP6pEyO2qB+yZ6IgaMyDa7?=
 =?us-ascii?Q?q59AeE/a74iW/eCsOZSGz0sOVtzH73fUh35RXy3nIVFGw+E+a7n2EC4FlcoP?=
 =?us-ascii?Q?aVFiJbBAOiFPhck/vffu499122j9xAZqh2oCNhWq7cJgzbcc7qUkiLzT2lMm?=
 =?us-ascii?Q?1HsTWtUNlqX8ckmQoMjTs2e6GekQOnrjbCskjYThSxY6m21vpv4VB5wfyzE2?=
 =?us-ascii?Q?mLaiXPJlQglTnidDojLzmBDpqXYF2bBpXZ9X+MDmX33HFTzThBUagj62pSll?=
 =?us-ascii?Q?DxLowEUD6X3197ckgCNEZeqGKN/vR34woE6AP7WuAMUSv61iYOrKuaaFnci2?=
 =?us-ascii?Q?o3+Uorl1ZWwt3rEs27rQREWCF9ghcRwTDnFlL1YNLWtRqHetXwIhOF1J783B?=
 =?us-ascii?Q?aBMNcHOaJ2lqXVw++jwWLtbf1InnHbXtISInORbUMM2guqQ8aXfPw9pZ4zQG?=
 =?us-ascii?Q?76UmEhQcZnaafB0ROB12wc7z9iXWMu8sYT0o/Bj8x+sGkTz6jUdujXZTNB+n?=
 =?us-ascii?Q?Wb31OeIZp0oXQ/AaVP8bCz9tZt+Zu3GfwwH3Hk1MugNcTCo/zl+nVZTGtbHP?=
 =?us-ascii?Q?Ig/3Uo5u0ksZGOC2hPNaD3A3/bE0q+HVLJmCqqDwnLPcONI4UMPwZbNyzOm1?=
 =?us-ascii?Q?F+C9UDWmiRHC6WU20LL+kWf1jbpJaz3nwKB6aW6dpSbklLbG3j5yQbdBWPKY?=
 =?us-ascii?Q?sj0lzzW7vcfQ0oh8gn6KjyXMBO7eI9ske6wVkVgkPsydun8Ulg782p4/D9hL?=
 =?us-ascii?Q?Po3pDlG4zFD+jMRyHilrbsNRxkif6ZO+jofPDL7lkrEjo+Vt0E86a7YDRb5y?=
 =?us-ascii?Q?PWwsag7PoDnCDvycsPVE0m6s98A2LsIx5MB9P+IsWUC2MmFhFybK4nCZYY0v?=
 =?us-ascii?Q?BENH7BICBRc100Xuf5NtInAf54RWekw8bbU+98cbv7a+PWrYwpHazqSsluFA?=
 =?us-ascii?Q?Fftiktg7HSIPG95/4254ifXO7zRCXZ1PqpkE0Y1YYi5avewWWjRoWfEQ8Jdy?=
 =?us-ascii?Q?CUaRmZkGldt1Kop1m4mEChXnP5mL/WPNVktqICUSr1mwtjZUKjLJfetrgfTB?=
 =?us-ascii?Q?+PQkkkZ+EdsoGNEK6BbBbo2fRc8VaF1hzajxBXofl6IZMHrUr31UZvO4Hgov?=
 =?us-ascii?Q?fQQ/D3dfmFq+wbNo6ah4sLg5/wlyz3F9hFMDxuUDGCqQlq/cT7UQFE44kT/6?=
 =?us-ascii?Q?quFhHx8P4XiU7PsZLTHXkGuzWoBDCuXBjm1W7SioETYPhrQ4p0X3jmUFAFxc?=
 =?us-ascii?Q?8Cx4IdWC8fSumBXKVUxvRgHvNWTkCs9oggxz3TVgQye8dugYO25s+8uxrrO6?=
 =?us-ascii?Q?KtOPHrL3vwYHfxwg5Jfsv+KqlfP6/7hJAPnVhsa3eVULurV6xBV0DqpzndxR?=
 =?us-ascii?Q?/MJshRJ9XV9vZTXdCViPjIXw+c+/SsIGUPybOaQjmimN0QhLQH7fqRDIb574?=
 =?us-ascii?Q?l7GPzwe+FwrEmdA08CGRUC+byag8GGXomRGih6Ll7HO2XDYboyqi5b1ect24?=
 =?us-ascii?Q?1ydEPKla4uLXREfnOpQ=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2025 17:30:43.6043
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a72c2a4f-8920-4baf-4de5-08de2c485cab
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B073.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7311

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

cc: Shameer Kolothum <skolothumtho@nvidia.com>
cc: Alex Williamson <alex@shazbot.org>
cc: Jason Gunthorpe <jgg@ziepe.ca>
cc: Vikram Sethi <vsethi@nvidia.com>
Suggested-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/main.c | 66 ++++++++++++++++++++++++++---
 1 file changed, 59 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index 7d5544280ed2..f9cea19093fa 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -104,6 +104,17 @@ static int nvgrace_gpu_open_device(struct vfio_device *core_vdev)
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
+	if (ret)
+		return ret;
+
 	vfio_pci_core_finish_enable(vdev);
 
 	return 0;
@@ -146,6 +157,31 @@ static int nvgrace_gpu_wait_device_ready(void __iomem *io)
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
@@ -179,8 +215,12 @@ static vm_fault_t nvgrace_gpu_vfio_pci_huge_fault(struct vm_fault *vmf,
 		      pfn & ((1 << order) - 1)))
 		return VM_FAULT_FALLBACK;
 
-	scoped_guard(rwsem_read, &vdev->memory_lock)
+	scoped_guard(rwsem_read, &vdev->memory_lock) {
+		if (nvgrace_gpu_check_device_ready(nvdev))
+			return ret;
+
 		ret = vfio_pci_vmf_insert_pfn(vdev, vmf, pfn, order);
+	}
 
 	dev_dbg_ratelimited(&vdev->pdev->dev,
 			    "%s order = %d pfn 0x%lx: 0x%x\n",
@@ -592,9 +632,15 @@ nvgrace_gpu_read_mem(struct nvgrace_gpu_pci_core_device *nvdev,
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
@@ -712,9 +758,15 @@ nvgrace_gpu_write_mem(struct nvgrace_gpu_pci_core_device *nvdev,
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
-- 
2.34.1


