Return-Path: <kvm+bounces-64139-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DB5DC7A20A
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 15:22:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id ADAB14F1971
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 14:13:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CB2134DB55;
	Fri, 21 Nov 2025 14:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bSwS/nH7"
X-Original-To: kvm@vger.kernel.org
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012003.outbound.protection.outlook.com [52.101.53.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F405C34D4D5;
	Fri, 21 Nov 2025 14:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.3
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763734340; cv=fail; b=Ot3hHh6+TY1uyrUKZ69xLVoojC3eM8YIIMoP8BnoiezdD0VQLC2RekWqKo8cMyOv9MjydHTiFn1rJJvpj7LuzCUj8g/7TS4ZOSO7m4I9kIzqO3dtZmq8OG00FAqh+DfNtdhL/8VNfqUC8Wo+zQuXPCefXpTNiv0BBhnQjotgkh0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763734340; c=relaxed/simple;
	bh=+jTpMIgt/o/VLQmn064apmAho30fcKrJm6mlQ0TQlR4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EqcBk5/d1wU8JWpiDu/FsgHnawHjPBsxQzl35ijJ4j3bachvuCqEkZaIohoNE5KY2tMxbxQxG360v+VNw9GGGQsLinD4QGjXDV5HGhU2ZQZXUUFPbInTrOD83h+tZE7hrXk4P+czWWv2LZxx0JcR/BDFwXA2l/mLKs0IKuNGhFI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=bSwS/nH7; arc=fail smtp.client-ip=52.101.53.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U5u1u/STX2jVFWPZQstsGAofKuhn1IXUEDQtQW4rkPOKhKgtN1068s47P+9WXQEQ4iinNdc/IiVoyHShHx62xvO5VHCgC6mafdjubIrwnCU2rNMJ7GBjIu3vdxXw0rkkfLeAzKUvLY7gal93JWw4O6173cgIFaQZjaBtinE4Ivy2mSaelwqZjb+sUUjI3VA2YTbYp1cY0+s+GfrL9/hopY/Ftw73+eF+KVmd1gLGDbC3EV03v8T3yds+LTN6/WQ9tbDnx3DlLab9ZzZja/1CY5gVovyHgwZ/Wjl5s2VlY8+Rq8AD/8E7Lx2o5WVyZPIn83sSw8HCRrCfri8HlQVFHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5OHVbDSbhctNNhP/AyRR5gYIO+DTSZ24gnHD8HWm7xw=;
 b=Z/uCMXyOin4LdP8QWvLzrkLsXF1I1yomyWj7aKwLIuwgOeV0D6602+uPayls0UFRFJWa9tB9+RQs1kvWZoPnjxENKznGHVJw21jFmJCQwUnagpzlmsUnhA/uhIoPrl5J8jJq3rlCMo3NaWHxOLBWq8oA5F3wJZxjshI/b8U/bsIzrm69bLZpImsbvM161DNWPrQEgdHzcYQtRKZGsolHT8vaVM53CfCbBGAbJ3UfkpNQqIDiHFJ6b9YjP1lMfxyj+KF0BsdEaVEBrmRb3HqDG7+9uqt+f4nzyOO4G/UWyH0CB4+u2FEv5hpYqN0kw2+VdNKpvLiVHZllaBOAtbX5bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5OHVbDSbhctNNhP/AyRR5gYIO+DTSZ24gnHD8HWm7xw=;
 b=bSwS/nH7CJH0+XEGPqEmIjjP/hepoX4/WYDtKag+GC1y61KCyPDGaEfRLpdkbhQqFYrTgNxlxf4MR9N01sfdl94ze4b7Tm3CezHFqmjR0HaqzPPFEYYsX/V37+cb94Y24YtgJFGxT23P8HnxADwtFg/jYqlVw8fjZCDe4NIJKbM/jGO3V5Xx40OyFrRjzWGlaeH+XS1GLmFJ2NH3ZN74htYWycEQpiOPIi6fePC0RaBJe4jLqvdwCgJ6Mdjrs8xatyVkLLbi0uZbonFeT+jzZDUZiMjVBoP2xL65VNWvprGHsPQU25IAHU/V196xEGJnvPcYoEyfX/OtjJyaDph2LQ==
Received: from SJ0PR03CA0243.namprd03.prod.outlook.com (2603:10b6:a03:3a0::8)
 by MN2PR12MB4408.namprd12.prod.outlook.com (2603:10b6:208:26c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.11; Fri, 21 Nov
 2025 14:12:11 +0000
Received: from SJ5PEPF000001CB.namprd05.prod.outlook.com
 (2603:10b6:a03:3a0:cafe::de) by SJ0PR03CA0243.outlook.office365.com
 (2603:10b6:a03:3a0::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.14 via Frontend Transport; Fri,
 21 Nov 2025 14:12:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ5PEPF000001CB.mail.protection.outlook.com (10.167.242.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.9 via Frontend Transport; Fri, 21 Nov 2025 14:12:10 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 21 Nov
 2025 06:11:46 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 21 Nov
 2025 06:11:46 -0800
Received: from
 gb-nvl-073-compute01.l16.internal032k18.bmc032b17.internal032f11.internal032huang.bmc032l04.bmc
 (10.127.8.11) by mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20 via Frontend Transport; Fri, 21 Nov 2025 06:11:45 -0800
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
Subject: [PATCH v3 7/7] vfio/nvgrace-gpu: wait for the GPU mem to be ready
Date: Fri, 21 Nov 2025 14:11:41 +0000
Message-ID: <20251121141141.3175-8-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CB:EE_|MN2PR12MB4408:EE_
X-MS-Office365-Filtering-Correlation-Id: fe1aed87-26b4-4dc2-6048-08de2907f67f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UClqwqaCAFkrrObFheJr63ifJm43hC6Kq1tfKiA3t104rmOiwPaL3++EV4xM?=
 =?us-ascii?Q?Z4lDwAHvjn4fMziT48VAyfjczYSNXnZIqbkkx23+4fGZ9oZPCqxdLeoOMClJ?=
 =?us-ascii?Q?tgDHDvCWDeJHJSlltVeXXvf5eMi2Cn8LuPNadPzm/yqs2ZNBjCtBHk/9Gw7t?=
 =?us-ascii?Q?QzHtQjD7/j1VK91IWciNRUNTpUifV3bT0eC0jtA/aXp08LQEu122MDBSgM5Y?=
 =?us-ascii?Q?aBJSlU2Olq90hIhj42KaUwz3DTyn6He9zPj0Pp5IY0skYpgPGKP0f3lcbjTG?=
 =?us-ascii?Q?2utml5CUL6U0Q9UyD6Od3uAmXw4tOZOtPBytsCCLJ26InYBxs1tvFT4GFu9u?=
 =?us-ascii?Q?JmqccT4DEoJhlxF9/fqffwwPoLlA6ka9laaEJzg+0O0tVlq6xVmx7nFzVB7t?=
 =?us-ascii?Q?zZa/caPxBuxgaxjgedXn4l6PKoiaUrjEIs0GktwmcfvRPkEAG7KIMxu+y6Z6?=
 =?us-ascii?Q?Die17DJDsXJsJrl4THkoZycxYcRRFYydZxDgRMIgSEcpfvWpgUl+v8ReQluo?=
 =?us-ascii?Q?Pd+rklCdBB6ILOmftLag/JT/aoFOCwnD4VpkwrobP0BNu/89fvKIUalHdC8t?=
 =?us-ascii?Q?kvuxd+0XWe59JQz1sSomuXl3VgUc729Q7rbZxrZ/TlMOWSQ3jYMt3gI8qAVs?=
 =?us-ascii?Q?TlqyWXlTQiTnsmoyO612N0GwCd6/6hzzjXmPjxjhjt8JfSbeDff8uiFPsgDf?=
 =?us-ascii?Q?xuZoci5A1xWkycxtNfQSemVXedtl9zWfQx7hnxjRM8qRs1trEFgxNLEZhE2K?=
 =?us-ascii?Q?+oDhqE6JYG42bgpNaUa2HgjDq7sjXK6IZl1+j2ewAgV6orKtRlxQLto3EmCw?=
 =?us-ascii?Q?wwpvDzR8R5VGRxsTjFRJLZzr14IQ8q2kAWbO5HbTN/+eEQoMyYDr5lruJEY8?=
 =?us-ascii?Q?u2AE33YLoHaNuhHqmkOpdaqCQFpbkX5r3km6Q7AFUyYnMgWKvp+ieZWn6eeD?=
 =?us-ascii?Q?kLIUG/4DQX3bapebJTI9gH8LjoNxgNV3mHjFv2TuulLQCgohTxhntn5GtGUU?=
 =?us-ascii?Q?lGtnemICzxfGqybWnpBl8F2oWCzryYN7bq5AOaHUGxuDwL9A2HKnXellbish?=
 =?us-ascii?Q?kmcqPhrGCmF88/skzpffw+zochZuMr/kVeyE4FZpGbU8sJeYgNYRqqwpZVs/?=
 =?us-ascii?Q?VWZLUkAjpfl2IwAOV7SvBfuxk4Ei8ByorSyr/nZO+NhI5cB1YtGaZVDDp2+5?=
 =?us-ascii?Q?XPdR9FMX2RATKmF8vqNG1sZ3VQWDtZX2Em+FVvTTd9zB2Wokb5HjZqiaBe+I?=
 =?us-ascii?Q?Rz6h+XSI71nfATxgTd/2mIIqAL1Eig7t0L4SCjj5aDf4eia0DN0f7EZDRWCU?=
 =?us-ascii?Q?031mNl9dS4c2cYuH5iTugXO59bHV4/DgEH37nA0gwTqS5k/TTaOFn1K/m2Ok?=
 =?us-ascii?Q?DvIl7/yxRbbl2oQI9sKgDMUexgkDlv7vHKQg8nbq14S30p4A2cv6HB5C1ZFo?=
 =?us-ascii?Q?lSwK5SWl9j6U4pEAKfWSNbbTgeEF/+oAV9SKRzq1D6HWeEENIto6WAVTkbV7?=
 =?us-ascii?Q?aNXtu61RFDeLyaDk94hXfPiDxqt2H9zI66pQ45Esv29Gy3GhTo3DCam6KqQf?=
 =?us-ascii?Q?zp8J9vDmZ0KUc7AKEr8=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2025 14:12:10.9226
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fe1aed87-26b4-4dc2-6048-08de2907f67f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CB.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4408

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
request which amortizes the GPU readiness time. The first fault
is checked using a flag. The flag is unset on every GPU reset
request.

Intercept the following calls to the GPU reset, unset gpu_mem_mapped.
Then use it to determine whether to wait before mapping.
1. VFIO_DEVICE_RESET ioctl call
2. FLR through config space.

cc: Alex Williamson <alex@shazbot.org>
cc: Jason Gunthorpe <jgg@ziepe.ca>
cc: Vikram Sethi <vsethi@nvidia.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/main.c | 64 ++++++++++++++++++++++++++++-
 1 file changed, 63 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index 7618c3f515cc..23e3278aba25 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -58,6 +58,8 @@ struct nvgrace_gpu_pci_core_device {
 	/* Lock to control device memory kernel mapping */
 	struct mutex remap_lock;
 	bool has_mig_hw_bug;
+	/* Any GPU memory mapped to the VMA */
+	bool gpu_mem_mapped;
 };
 
 static void nvgrace_gpu_init_fake_bar_emu_regs(struct vfio_device *core_vdev)
@@ -102,9 +104,15 @@ static int nvgrace_gpu_open_device(struct vfio_device *core_vdev)
 		mutex_init(&nvdev->remap_lock);
 	}
 
+	nvdev->gpu_mem_mapped = false;
+
 	vfio_pci_core_finish_enable(vdev);
 
-	return 0;
+	/*
+	 * The GPU readiness is determined through BAR0 register reads.
+	 * Make sure the BAR0 is mapped before any such check occur.
+	 */
+	return vfio_pci_core_barmap(vdev, 0);
 }
 
 static void nvgrace_gpu_close_device(struct vfio_device *core_vdev)
@@ -158,6 +166,21 @@ static vm_fault_t nvgrace_gpu_vfio_pci_huge_fault(struct vm_fault *vmf,
 	struct mem_region *memregion;
 	unsigned long pgoff, pfn, addr;
 
+	/*
+	 * If the GPU memory is accessed by the CPU while the GPU is
+	 * not ready after reset, it can cause harmless corrected RAS
+	 * events to be logged. Make sure the GPU is ready before
+	 * establishing the mappings.
+	 */
+	if (!nvdev->gpu_mem_mapped) {
+		struct vfio_pci_core_device *vdev = &nvdev->core_device;
+
+		if (nvgrace_gpu_wait_device_ready(vdev->barmap[0]))
+			return VM_FAULT_SIGBUS;
+
+		nvdev->gpu_mem_mapped = true;
+	}
+
 	memregion = nvgrace_gpu_memregion(index, nvdev);
 	if (!memregion)
 		return ret;
@@ -354,7 +377,17 @@ static long nvgrace_gpu_ioctl(struct vfio_device *core_vdev,
 	case VFIO_DEVICE_IOEVENTFD:
 		return -ENOTTY;
 	case VFIO_DEVICE_RESET:
+		struct nvgrace_gpu_pci_core_device *nvdev =
+			container_of(core_vdev, struct nvgrace_gpu_pci_core_device,
+				     core_device.vdev);
 		nvgrace_gpu_init_fake_bar_emu_regs(core_vdev);
+
+		/*
+		 * GPU memory is exposed as device BAR2 (region 4,5).
+		 * This would be zapped during GPU reset. Unset
+		 * nvdev->gpu_mem_mapped to reflect just that.
+		 */
+		nvdev->gpu_mem_mapped = false;
 		fallthrough;
 	default:
 		return vfio_pci_core_ioctl(core_vdev, cmd, arg);
@@ -439,11 +472,14 @@ nvgrace_gpu_write_config_emu(struct vfio_device *core_vdev,
 	struct nvgrace_gpu_pci_core_device *nvdev =
 		container_of(core_vdev, struct nvgrace_gpu_pci_core_device,
 			     core_device.vdev);
+	struct vfio_pci_core_device *vdev =
+		container_of(core_vdev, struct vfio_pci_core_device, vdev);
 	u64 pos = *ppos & VFIO_PCI_OFFSET_MASK;
 	struct mem_region *memregion = NULL;
 	size_t register_offset;
 	loff_t copy_offset;
 	size_t copy_count;
+	int cap_start = vfio_find_cap_start(vdev, pos);
 
 	if (vfio_pci_core_range_intersect_range(pos, count, PCI_BASE_ADDRESS_2,
 						sizeof(u64), &copy_offset,
@@ -462,6 +498,23 @@ nvgrace_gpu_write_config_emu(struct vfio_device *core_vdev,
 		return copy_count;
 	}
 
+	if (vfio_pci_core_range_intersect_range(pos, count, cap_start + PCI_EXP_DEVCTL,
+						sizeof(u16), &copy_offset,
+						&copy_count, &register_offset)) {
+		__le16 val16;
+
+		if (copy_from_user((void *)&val16, buf, copy_count))
+			return -EFAULT;
+
+		/*
+		 * GPU memory is exposed as device BAR2 (region 4,5).
+		 * This would be zapped during GPU reset. Unset
+		 * nvdev->gpu_mem_mapped to reflect just that.
+		 */
+		if (val16 & cpu_to_le16(PCI_EXP_DEVCTL_BCR_FLR))
+			nvdev->gpu_mem_mapped = false;
+	}
+
 	return vfio_pci_core_write(core_vdev, buf, count, ppos);
 }
 
@@ -478,9 +531,18 @@ static int
 nvgrace_gpu_map_device_mem(int index,
 			   struct nvgrace_gpu_pci_core_device *nvdev)
 {
+	struct vfio_pci_core_device *vdev = &nvdev->core_device;
 	struct mem_region *memregion;
 	int ret = 0;
 
+	if (!nvdev->gpu_mem_mapped) {
+		ret = nvgrace_gpu_wait_device_ready(vdev->barmap[0]);
+		if (ret)
+			return ret;
+
+		nvdev->gpu_mem_mapped = true;
+	}
+
 	memregion = nvgrace_gpu_memregion(index, nvdev);
 	if (!memregion)
 		return -EINVAL;
-- 
2.34.1


