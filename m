Return-Path: <kvm+bounces-8057-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 847D584AA34
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 00:04:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2E6FE28DC15
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 23:04:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D2A04F8AE;
	Mon,  5 Feb 2024 23:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="a/0rF06t"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2085.outbound.protection.outlook.com [40.107.220.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 465614F5F3;
	Mon,  5 Feb 2024 23:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707174125; cv=fail; b=S2rDTXp08oAC5wR1Vvng7TYhDdFhAchx7UaPwebAEBL7+PGsCTciK7ALg0Y/Qs9Sc0jMRjHZMd0lMwnQ0IOt/WVvcTtDGY0LLBa86DHhhY+/Jv685aD9k3YUf68Bywypek/pxI/+SWWZFPTR/3uaGMKNSW6ZfS8w3eKVrklksCU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707174125; c=relaxed/simple;
	bh=UtV5gmP5YG2JjtQ+kpSICrvemZ4AsT67HNBBhBq17nQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WsO6vYktDcS7KdaYeZBqFPOgYZea+8tHlmfxk8zZJXbaHxYM8RxJQ01jVXfhgkVGRFaoILqC2Fc1zfgjjESm+/CiKOBvRpU0sbJa+7/L2qH7q+4c56yaDJUpNNr9y8Tp+89xxutxFjMOs9cOXOmUvylgyJslIg1WcLLJ4rCvP9c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=a/0rF06t; arc=fail smtp.client-ip=40.107.220.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eVvh56r1SR6JqZdzmQY8RLzc3sz8Q5sqMBvq8gQ/jKB8jRXPnf8gGtBX9qCFRoN1I8TaxdwtrZFjs1OsIdDyDf1qLW9wcYw+FwexEzh6PBaUDCUga1+WklpjUI/yZ4gEXi1iJGmnkSbG/7KbenRNrTd414louxBjVBJge9NQagH1e31nU8QcN7phAHWcSYc4w/39m+6YYUvmrPqFZWlgnZx5gKtzkhh0KoySF8ohr6hPMfwWkBXcRcOe9GtOy+5esLlssuejyeJZlnW1JqIvVsuD+DXVDfUZui1ahcUeDJobW2PEA+QHVRVLeZFF37g1BDs+qUk3hPumufZrnv7ZXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mv18rZDed9uM1weMyJEFCaWE9S2uINwXhRg1gm9vAZE=;
 b=Vdr0aaukhgkORKmNgI6EtrCCl5FBe4THoFWWTb+01R2kWzX9oXhVTVtEdTriz/BkcejTyBza+3XH9S2Cn7MdkTSYc+aItx+tLOvPvOE0KW/s/If7s4zNh3SeS3YUndIa5wkYVNH3i6WmXvZY20VpObL14Ecad6LwU/rhQ0zq/SCkpsNqqAtBvyUBuJ6KnQUWiNGVZZyssKEdLqqktREpKpzdweYwCUQHX3saYxbxgujpZy/BgS2cq2LSfzj6Ad6C+9HBU0/uiMpl9NSMCSBJtpEv/aVKTmi0B8k26MrM270aDzQaaKJa3PBtN3xVIx9hdsliqC9JJqhUfqpU6oVkPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mv18rZDed9uM1weMyJEFCaWE9S2uINwXhRg1gm9vAZE=;
 b=a/0rF06tTRtu29s6TUQJLx6/66XzIIiEsIiGSXb3EJsHWydCUuYy2oVJy7ZVpDz2WVzmpcymDFKWz1wvllLKsncGmUX2QsUg7hOOUutRSGmssxacuHEJFkaz24ufvxuTw7FEmFPeXVx0hAIFbzc17zn2Tp1azVibXqqaV2zDga5VV3PNIC0xC5GQ7Ra0xEFY7ZV0Fo0cB8aCm0nvl5mR01nhQiM8TN2ccjDnTTM47SGHd9PTgvei+ECDsp0bLMDwnkMNZblZZ5bZd/P9z4Qnw0KY6zXPeCzgMGPaiMBiGvf5W0nf1ueu+X4TogtjwGmcEO7SkHK0+lJGme28HTCOFg==
Received: from BL1PR13CA0144.namprd13.prod.outlook.com (2603:10b6:208:2bb::29)
 by SN7PR12MB6814.namprd12.prod.outlook.com (2603:10b6:806:266::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.14; Mon, 5 Feb
 2024 23:01:59 +0000
Received: from BL02EPF0001A102.namprd05.prod.outlook.com
 (2603:10b6:208:2bb:cafe::37) by BL1PR13CA0144.outlook.office365.com
 (2603:10b6:208:2bb::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.15 via Frontend
 Transport; Mon, 5 Feb 2024 23:01:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL02EPF0001A102.mail.protection.outlook.com (10.167.241.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7202.16 via Frontend Transport; Mon, 5 Feb 2024 23:01:58 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 5 Feb 2024
 15:01:57 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.12; Mon, 5 Feb 2024 15:01:56 -0800
Received: from sgarnayak-dt.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12 via Frontend
 Transport; Mon, 5 Feb 2024 15:01:49 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>,
	<yishaih@nvidia.com>, <mst@redhat.com>,
	<shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
	<clg@redhat.com>, <oleksandr@natalenko.name>,
	<satyanarayana.k.v.p@intel.com>, <eric.auger@redhat.com>,
	<brett.creeley@amd.com>, <horms@kernel.org>, <rrameshbabu@nvidia.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<anuaggarwal@nvidia.com>, <mochs@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <virtualization@lists.linux-foundation.org>
Subject: [PATCH v17 3/3] vfio/nvgrace-gpu: Add vfio pci variant module for grace hopper
Date: Tue, 6 Feb 2024 04:31:23 +0530
Message-ID: <20240205230123.18981-4-ankita@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20240205230123.18981-1-ankita@nvidia.com>
References: <20240205230123.18981-1-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A102:EE_|SN7PR12MB6814:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b9b7a0e-265e-41d9-f650-08dc269e74da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	FCiVq7bRhH42vwEkPjR1vJEC7AYxPLGqJznJCshUr6Q+i6r0fPqkqqnPdiLR44Bzcy9Q9QntpSEUl4xnEqk8nm/zK21FaM1A0jNHtbe3W5EoZngw9d1G+QeuYWyNVSq2DvXNks7bQ+y4RFONUznpMg2QoHw5RJFr7hXP8/vzeAKX9rseEId6EX0IoyJJd8ZzSt3UHS6d4gXDR6zs2T27hworcreWFObzaeDnfgqCZs8f6JyvLf9Za2qkqq4OLAzkzvUhIK7Ju5JnVNz9B7gbCiiMGK37Gn9AQwSfl0tGbtvBSDhk2yI33K/SzDwRkBK2336BAeqzMsR1rCj8k1uPAAGY3Sn07lc+Yl7Gc/Z20YnvrL0N9lH3Hs5xfbs7EiVA8iUHW/nuew7klb3grH3eJw6Epj2o+ejIG83Wfs0qAD/ivnkg+maP3lTTcO+HxlEROTQqbsPBIiSpo8nFDFzvB1xmV/YzBk+csYL5ax51ZekwKn2SZ9sjm61HvUCdzMmCy5ONDs9lkJooAt4fW03i7xZl2BZkOYQiYYP5/9xww0DyjTYxhasN5plaUmiEXJuBCq1kK2mmkQMvJWgvkfOTwbF5i+BaoGxdhfMABkeSB2FHcykaz679j3aFnROiPJNmk3lQme7t6LDm47lgt04Iddy9WmADqEaQjJ6uZTel6G98igggvzrobQaeLrlYuoNuwQv6re9CmkN9OmzYIM7Toav+FvWUo82GpbXklC8p466/oO1mVYLc1+WQgKxLTONf/YXZEso89K1pZ4QNM+/R3ZwBejKsDa/qVfsSkyHtcypuG+Kh6q7suVJVyA4fuipcUmvkW1dgsbawjNEV3ZvBxA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(376002)(39860400002)(346002)(136003)(396003)(230922051799003)(1800799012)(82310400011)(186009)(451199024)(64100799003)(46966006)(36840700001)(40470700004)(7696005)(6666004)(7416002)(26005)(336012)(47076005)(426003)(5660300002)(30864003)(1076003)(921011)(2616005)(6636002)(2876002)(8936002)(316002)(36756003)(4326008)(2906002)(70586007)(110136005)(8676002)(54906003)(70206006)(41300700001)(966005)(86362001)(478600001)(7636003)(40480700001)(40460700003)(36860700001)(356005)(83380400001)(84970400001)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2024 23:01:58.5087
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b9b7a0e-265e-41d9-f650-08dc269e74da
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A102.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6814

From: Ankit Agrawal <ankita@nvidia.com>

NVIDIA's upcoming Grace Hopper Superchip provides a PCI-like device
for the on-chip GPU that is the logical OS representation of the
internal proprietary chip-to-chip cache coherent interconnect.

The device is peculiar compared to a real PCI device in that whilst
there is a real 64b PCI BAR1 (comprising region 2 & region 3) on the
device, it is not used to access device memory once the faster
chip-to-chip interconnect is initialized (occurs at the time of host
system boot). The device memory is accessed instead using the chip-to-chip
interconnect that is exposed as a contiguous physically addressable
region on the host. This device memory aperture can be obtained from host
ACPI table using device_property_read_u64(), according to the FW
specification. Since the device memory is cache coherent with the CPU,
it can be mmap into the user VMA with a cacheable mapping using
remap_pfn_range() and used like a regular RAM. The device memory
is not added to the host kernel, but mapped directly as this reduces
memory wastage due to struct pages.

There is also a requirement of a reserved 1G uncached region (termed as
resmem) to support the Multi-Instance GPU (MIG) feature [1]. This is
to work around a HW defect. Based on [2], the requisite properties
(uncached, unaligned access) can be achieved through a VM mapping (S1)
of NORMAL_NC and host (S2) mapping with MemAttr[2:0]=0b101. To provide
a different non-cached property to the reserved 1G region, it needs to
be carved out from the device memory and mapped as a separate region
in Qemu VMA with pgprot_writecombine(). pgprot_writecombine() sets the
Qemu VMA page properties (pgprot) as NORMAL_NC.

Provide a VFIO PCI variant driver that adapts the unique device memory
representation into a more standard PCI representation facing userspace.

The variant driver exposes these two regions - the non-cached reserved
(resmem) and the cached rest of the device memory (termed as usemem) as
separate VFIO 64b BAR regions. This is divergent from the baremetal
approach, where the device memory is exposed as a device memory region.
The decision for a different approach was taken in view of the fact that
it would necessiate additional code in Qemu to discover and insert those
regions in the VM IPA, along with the additional VM ACPI DSDT changes to
communicate the device memory region IPA to the VM workloads. Moreover,
this behavior would have to be added to a variety of emulators (beyond
top of tree Qemu) out there desiring grace hopper support.

Since the device implements 64-bit BAR0, the VFIO PCI variant driver
maps the uncached carved out region to the next available PCI BAR (i.e.
comprising of region 2 and 3). The cached device memory aperture is
assigned BAR region 4 and 5. Qemu will then naturally generate a PCI
device in the VM with the uncached aperture reported as BAR2 region,
the cacheable as BAR4. The variant driver provides emulation for these
fake BARs' PCI config space offset registers.

The hardware ensures that the system does not crash when the memory
is accessed with the memory enable turned off. It synthesis ~0 reads
and dropped writes on such access. So there is no need to support the
disablement/enablement of BAR through PCI_COMMAND config space register.

The memory layout on the host looks like the following:
               devmem (memlength)
|--------------------------------------------------|
|-------------cached------------------------|--NC--|
|                                           |
usemem.phys/memphys                         resmem.phys

PCI BARs need to be aligned to the power-of-2, but the actual memory on the
device may not. A read or write access to the physical address from the
last device PFN up to the next power-of-2 aligned physical address
results in reading ~0 and dropped writes. Note that the GPU device
driver [6] is capable of knowing the exact device memory size through
separate means. The device memory size is primarily kept in the system
ACPI tables for use by the VFIO PCI variant module.

Note that the usemem memory is added by the VM Nvidia device driver [5]
to the VM kernel as memblocks. Hence make the usable memory size memblock
aligned.

Currently there is no provision in KVM for a S2 mapping with
MemAttr[2:0]=0b101, but there is an ongoing effort to provide the same [3].
As previously mentioned, resmem is mapped pgprot_writecombine(), that
sets the Qemu VMA page properties (pgprot) as NORMAL_NC. Using the
proposed changes in [4] and [3], KVM marks the region with
MemAttr[2:0]=0b101 in S2.

If the bare metal properties are not present, the driver registers the
vfio-pci-core function pointers.

This goes along with a qemu series [6] to provides the necessary
implementation of the Grace Hopper Superchip firmware specification so
that the guest operating system can see the correct ACPI modeling for
the coherent GPU device. Verified with the CUDA workload in the VM.

[1] https://www.nvidia.com/en-in/technologies/multi-instance-gpu/
[2] section D8.5.5 of https://developer.arm.com/documentation/ddi0487/latest/
[3] https://lore.kernel.org/all/20231205033015.10044-1-ankita@nvidia.com/
[4] https://lore.kernel.org/all/20230907181459.18145-2-ankita@nvidia.com/
[5] https://github.com/NVIDIA/open-gpu-kernel-modules
[6] https://lore.kernel.org/all/20231203060245.31593-1-ankita@nvidia.com/

Signed-off-by: Aniket Agashe <aniketa@nvidia.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 MAINTAINERS                           |   6 +
 drivers/vfio/pci/Kconfig              |   2 +
 drivers/vfio/pci/Makefile             |   2 +
 drivers/vfio/pci/nvgrace-gpu/Kconfig  |  10 +
 drivers/vfio/pci/nvgrace-gpu/Makefile |   3 +
 drivers/vfio/pci/nvgrace-gpu/main.c   | 856 ++++++++++++++++++++++++++
 6 files changed, 879 insertions(+)
 create mode 100644 drivers/vfio/pci/nvgrace-gpu/Kconfig
 create mode 100644 drivers/vfio/pci/nvgrace-gpu/Makefile
 create mode 100644 drivers/vfio/pci/nvgrace-gpu/main.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 8999497011a2..529ec8966f58 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -23103,6 +23103,12 @@ L:	kvm@vger.kernel.org
 S:	Maintained
 F:	drivers/vfio/platform/
 
+VFIO NVIDIA GRACE GPU DRIVER
+M:	Ankit Agrawal <ankita@nvidia.com>
+L:	kvm@vger.kernel.org
+S:	Supported
+F:	drivers/vfio/pci/nvgrace-gpu/
+
 VGA_SWITCHEROO
 R:	Lukas Wunner <lukas@wunner.de>
 S:	Maintained
diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index 18c397df566d..15821a2d77d2 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -67,4 +67,6 @@ source "drivers/vfio/pci/pds/Kconfig"
 
 source "drivers/vfio/pci/virtio/Kconfig"
 
+source "drivers/vfio/pci/nvgrace-gpu/Kconfig"
+
 endmenu
diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
index 046139a4eca5..ce7a61f1d912 100644
--- a/drivers/vfio/pci/Makefile
+++ b/drivers/vfio/pci/Makefile
@@ -15,3 +15,5 @@ obj-$(CONFIG_HISI_ACC_VFIO_PCI) += hisilicon/
 obj-$(CONFIG_PDS_VFIO_PCI) += pds/
 
 obj-$(CONFIG_VIRTIO_VFIO_PCI) += virtio/
+
+obj-$(CONFIG_NVGRACE_GPU_VFIO_PCI) += nvgrace-gpu/
diff --git a/drivers/vfio/pci/nvgrace-gpu/Kconfig b/drivers/vfio/pci/nvgrace-gpu/Kconfig
new file mode 100644
index 000000000000..936e88d8d41d
--- /dev/null
+++ b/drivers/vfio/pci/nvgrace-gpu/Kconfig
@@ -0,0 +1,10 @@
+# SPDX-License-Identifier: GPL-2.0-only
+config NVGRACE_GPU_VFIO_PCI
+	tristate "VFIO support for the GPU in the NVIDIA Grace Hopper Superchip"
+	depends on ARM64 || (COMPILE_TEST && 64BIT)
+	select VFIO_PCI_CORE
+	help
+	  VFIO support for the GPU in the NVIDIA Grace Hopper Superchip is
+	  required to assign the GPU device using KVM/qemu/etc.
+
+	  If you don't know what to do here, say N.
diff --git a/drivers/vfio/pci/nvgrace-gpu/Makefile b/drivers/vfio/pci/nvgrace-gpu/Makefile
new file mode 100644
index 000000000000..3ca8c187897a
--- /dev/null
+++ b/drivers/vfio/pci/nvgrace-gpu/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0-only
+obj-$(CONFIG_NVGRACE_GPU_VFIO_PCI) += nvgrace-gpu-vfio-pci.o
+nvgrace-gpu-vfio-pci-y := main.o
diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
new file mode 100644
index 000000000000..6279af2bc6b8
--- /dev/null
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -0,0 +1,856 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES. All rights reserved
+ */
+
+#include <linux/vfio_pci_core.h>
+
+/*
+ * The device memory usable to the workloads running in the VM is cached
+ * and showcased as a 64b device BAR (comprising of BAR4 and BAR5 region)
+ * to the VM and is represented as usemem.
+ * Moreover, the VM GPU device driver needs a non-cacheable region to
+ * support the MIG feature. This region is also exposed as a 64b BAR
+ * (comprising of BAR2 and BAR3 region) and represented as resmem.
+ */
+#define RESMEM_REGION_INDEX VFIO_PCI_BAR2_REGION_INDEX
+#define USEMEM_REGION_INDEX VFIO_PCI_BAR4_REGION_INDEX
+
+/* Memory size expected as non cached and reserved by the VM driver */
+#define RESMEM_SIZE 0x40000000
+#define MEMBLK_SIZE 0x20000000
+
+/*
+ * The state of the two device memory region - resmem and usemem - is
+ * saved as struct mem_region.
+ */
+struct mem_region {
+	phys_addr_t memphys;    /* Base physical address of the region */
+	size_t memlength;       /* Region size */
+	size_t bar_size;        /* Reported region BAR size */
+	__le64 bar_val;         /* Emulated BAR offset registers */
+	union {
+		void *memaddr;
+		void __iomem *ioaddr;
+	};                      /* Base virtual address of the region */
+};
+
+struct nvgrace_gpu_vfio_pci_core_device {
+	struct vfio_pci_core_device core_device;
+	/* Cached and usable memory for the VM. */
+	struct mem_region usemem;
+	/* Non cached memory carved out from the end of device memory */
+	struct mem_region resmem;
+	/* Lock to control device memory kernel mapping */
+	struct mutex remap_lock;
+};
+
+static void nvgrace_gpu_init_fake_bar_emu_regs(struct vfio_device *core_vdev)
+{
+	struct nvgrace_gpu_vfio_pci_core_device *nvdev =
+		container_of(core_vdev, struct nvgrace_gpu_vfio_pci_core_device,
+			     core_device.vdev);
+
+	nvdev->resmem.bar_val = 0;
+	nvdev->usemem.bar_val = 0;
+}
+
+/* Choose the structure corresponding to the fake BAR with a given index. */
+static struct mem_region *
+nvgrace_gpu_memregion(int index,
+		      struct nvgrace_gpu_vfio_pci_core_device *nvdev)
+{
+	if (index == USEMEM_REGION_INDEX)
+		return &nvdev->usemem;
+
+	if (index == RESMEM_REGION_INDEX)
+		return &nvdev->resmem;
+
+	return NULL;
+}
+
+static int nvgrace_gpu_open_device(struct vfio_device *core_vdev)
+{
+	struct vfio_pci_core_device *vdev =
+		container_of(core_vdev, struct vfio_pci_core_device, vdev);
+	struct nvgrace_gpu_vfio_pci_core_device *nvdev =
+		container_of(core_vdev, struct nvgrace_gpu_vfio_pci_core_device,
+			     core_device.vdev);
+	int ret;
+
+	ret = vfio_pci_core_enable(vdev);
+	if (ret)
+		return ret;
+
+	vfio_pci_core_finish_enable(vdev);
+
+	if (nvdev->usemem.memlength) {
+		nvgrace_gpu_init_fake_bar_emu_regs(core_vdev);
+		mutex_init(&nvdev->remap_lock);
+	}
+
+	return 0;
+}
+
+static void nvgrace_gpu_close_device(struct vfio_device *core_vdev)
+{
+	struct nvgrace_gpu_vfio_pci_core_device *nvdev =
+		container_of(core_vdev, struct nvgrace_gpu_vfio_pci_core_device,
+			     core_device.vdev);
+
+	/* Unmap the mapping to the device memory cached region */
+	if (nvdev->usemem.memaddr) {
+		memunmap(nvdev->usemem.memaddr);
+		nvdev->usemem.memaddr = NULL;
+	}
+
+	/* Unmap the mapping to the device memory non-cached region */
+	if (nvdev->resmem.ioaddr) {
+		iounmap(nvdev->resmem.ioaddr);
+		nvdev->resmem.ioaddr = NULL;
+	}
+
+	mutex_destroy(&nvdev->remap_lock);
+
+	vfio_pci_core_close_device(core_vdev);
+}
+
+static int nvgrace_gpu_mmap(struct vfio_device *core_vdev,
+			    struct vm_area_struct *vma)
+{
+	struct nvgrace_gpu_vfio_pci_core_device *nvdev =
+		container_of(core_vdev, struct nvgrace_gpu_vfio_pci_core_device,
+			     core_device.vdev);
+
+	unsigned long start_pfn;
+	unsigned int index;
+	u64 req_len, pgoff, end;
+	int ret = 0;
+	struct mem_region *memregion;
+
+	index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
+
+	memregion = nvgrace_gpu_memregion(index, nvdev);
+	if (!memregion)
+		return vfio_pci_core_mmap(core_vdev, vma);
+
+	/*
+	 * Request to mmap the BAR. Map to the CPU accessible memory on the
+	 * GPU using the memory information gathered from the system ACPI
+	 * tables.
+	 */
+	pgoff = vma->vm_pgoff &
+		((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
+
+	if (check_sub_overflow(vma->vm_end, vma->vm_start, &req_len) ||
+	    check_add_overflow(PHYS_PFN(memregion->memphys), pgoff, &start_pfn) ||
+	    check_add_overflow(PFN_PHYS(pgoff), req_len, &end))
+		return -EOVERFLOW;
+
+	/*
+	 * Check that the mapping request does not go beyond available device
+	 * memory size
+	 */
+	if (end > memregion->memlength)
+		return -EINVAL;
+
+	/*
+	 * The carved out region of the device memory needs the NORMAL_NC
+	 * property. Communicate as such to the hypervisor.
+	 */
+	if (index == RESMEM_REGION_INDEX)
+		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
+
+	/*
+	 * Perform a PFN map to the memory and back the device BAR by the
+	 * GPU memory.
+	 *
+	 * The available GPU memory size may not be power-of-2 aligned. The
+	 * remainder is only backed by vfio_device_ops read/write handlers.
+	 *
+	 * During device reset, the GPU is safely disconnected to the CPU
+	 * and access to the BAR will be immediately returned preventing
+	 * machine check.
+	 */
+	ret = remap_pfn_range(vma, vma->vm_start, start_pfn,
+			      req_len, vma->vm_page_prot);
+	if (ret)
+		return ret;
+
+	vma->vm_pgoff = start_pfn;
+
+	return 0;
+}
+
+static long
+nvgrace_gpu_ioctl_get_region_info(struct vfio_device *core_vdev,
+				  unsigned long arg)
+{
+	unsigned long minsz = offsetofend(struct vfio_region_info, offset);
+	struct nvgrace_gpu_vfio_pci_core_device *nvdev =
+		container_of(core_vdev, struct nvgrace_gpu_vfio_pci_core_device,
+			     core_device.vdev);
+	struct vfio_region_info_cap_sparse_mmap *sparse;
+	struct vfio_info_cap caps = { .buf = NULL, .size = 0 };
+	struct vfio_region_info info;
+	struct mem_region *memregion;
+	u32 size;
+	int ret;
+
+	if (copy_from_user(&info, (void __user *)arg, minsz))
+		return -EFAULT;
+
+	if (info.argsz < minsz)
+		return -EINVAL;
+
+	memregion = nvgrace_gpu_memregion(info.index, nvdev);
+	if (!memregion)
+		return vfio_pci_core_ioctl(core_vdev,
+					   VFIO_DEVICE_GET_REGION_INFO, arg);
+
+	/*
+	 * Request to determine the BAR region information. Send the
+	 * GPU memory information.
+	 */
+	size = struct_size(sparse, areas, 1);
+
+	/*
+	 * Setup for sparse mapping for the device memory. Only the
+	 * available device memory on the hardware is shown as a
+	 * mappable region.
+	 */
+	sparse = kzalloc(size, GFP_KERNEL);
+	if (!sparse)
+		return -ENOMEM;
+
+	sparse->nr_areas = 1;
+	sparse->areas[0].offset = 0;
+	sparse->areas[0].size = memregion->memlength;
+	sparse->header.id = VFIO_REGION_INFO_CAP_SPARSE_MMAP;
+	sparse->header.version = 1;
+
+	ret = vfio_info_add_capability(&caps, &sparse->header, size);
+	kfree(sparse);
+	if (ret)
+		return ret;
+
+	info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
+	/*
+	 * The region memory size may not be power-of-2 aligned.
+	 * Given that the memory  as a BAR and may not be
+	 * aligned, roundup to the next power-of-2.
+	 */
+	info.size = memregion->bar_size;
+	info.flags = VFIO_REGION_INFO_FLAG_READ |
+		     VFIO_REGION_INFO_FLAG_WRITE |
+		     VFIO_REGION_INFO_FLAG_MMAP;
+
+	if (caps.size) {
+		info.flags |= VFIO_REGION_INFO_FLAG_CAPS;
+		if (info.argsz < sizeof(info) + caps.size) {
+			info.argsz = sizeof(info) + caps.size;
+			info.cap_offset = 0;
+		} else {
+			vfio_info_cap_shift(&caps, sizeof(info));
+			if (copy_to_user((void __user *)arg +
+					 sizeof(info), caps.buf,
+					 caps.size)) {
+				kfree(caps.buf);
+				return -EFAULT;
+			}
+			info.cap_offset = sizeof(info);
+		}
+		kfree(caps.buf);
+	}
+	return copy_to_user((void __user *)arg, &info, minsz) ?
+			    -EFAULT : 0;
+}
+
+static long nvgrace_gpu_ioctl(struct vfio_device *core_vdev,
+			      unsigned int cmd, unsigned long arg)
+{
+	switch (cmd) {
+	case VFIO_DEVICE_GET_REGION_INFO:
+		return nvgrace_gpu_ioctl_get_region_info(core_vdev, arg);
+	case VFIO_DEVICE_IOEVENTFD:
+		return -ENOTTY;
+	case VFIO_DEVICE_RESET:
+		nvgrace_gpu_init_fake_bar_emu_regs(core_vdev);
+		fallthrough;
+	default:
+		return vfio_pci_core_ioctl(core_vdev, cmd, arg);
+	}
+}
+
+static __le64
+nvgrace_gpu_get_read_value(size_t bar_size, u64 flags, __le64 val64)
+{
+	u64 tmp_val;
+
+	tmp_val = le64_to_cpu(val64);
+	tmp_val &= ~(bar_size - 1);
+	tmp_val |= flags;
+
+	return cpu_to_le64(tmp_val);
+}
+
+/*
+ * Both the usable (usemem) and the reserved (resmem) device memory region
+ * are exposed as a 64b fake BARs in the VM. These fake BARs must respond
+ * to the accesses on their respective PCI config space offsets.
+ *
+ * resmem BAR owns PCI_BASE_ADDRESS_2 & PCI_BASE_ADDRESS_3.
+ * usemem BAR owns PCI_BASE_ADDRESS_4 & PCI_BASE_ADDRESS_5.
+ */
+static ssize_t
+nvgrace_gpu_read_config_emu(struct vfio_device *core_vdev,
+			    char __user *buf, size_t count, loff_t *ppos)
+{
+	struct nvgrace_gpu_vfio_pci_core_device *nvdev =
+		container_of(core_vdev, struct nvgrace_gpu_vfio_pci_core_device,
+			     core_device.vdev);
+	struct mem_region *memregion = NULL;
+	u64 pos = *ppos & VFIO_PCI_OFFSET_MASK;
+	__le64 val64;
+	size_t register_offset;
+	loff_t copy_offset;
+	size_t copy_count;
+	int ret;
+
+	ret = vfio_pci_core_read(core_vdev, buf, count, ppos);
+	if (ret < 0)
+		return ret;
+
+	if (vfio_pci_core_range_intersect_range(pos, count, PCI_BASE_ADDRESS_2,
+						sizeof(val64),
+						&copy_offset, &copy_count,
+						&register_offset))
+		memregion = nvgrace_gpu_memregion(RESMEM_REGION_INDEX, nvdev);
+	else if (vfio_pci_core_range_intersect_range(pos, count,
+						     PCI_BASE_ADDRESS_4,
+						     sizeof(val64),
+						     &copy_offset, &copy_count,
+						     &register_offset))
+		memregion = nvgrace_gpu_memregion(USEMEM_REGION_INDEX, nvdev);
+
+	if (memregion) {
+		val64 = nvgrace_gpu_get_read_value(memregion->bar_size,
+						   PCI_BASE_ADDRESS_MEM_TYPE_64 |
+						   PCI_BASE_ADDRESS_MEM_PREFETCH,
+						   memregion->bar_val);
+		if (copy_to_user(buf + copy_offset,
+				 (void *)&val64 + register_offset, copy_count))
+			return -EFAULT;
+	}
+
+	return count;
+}
+
+static ssize_t
+nvgrace_gpu_write_config_emu(struct vfio_device *core_vdev,
+			     const char __user *buf, size_t count, loff_t *ppos)
+{
+	struct nvgrace_gpu_vfio_pci_core_device *nvdev =
+		container_of(core_vdev, struct nvgrace_gpu_vfio_pci_core_device,
+			     core_device.vdev);
+	u64 pos = *ppos & VFIO_PCI_OFFSET_MASK;
+	size_t register_offset;
+	loff_t copy_offset;
+	size_t copy_count;
+	struct mem_region *memregion = NULL;
+
+	if (vfio_pci_core_range_intersect_range(pos, count, PCI_BASE_ADDRESS_2,
+						sizeof(u64), &copy_offset,
+						&copy_count, &register_offset))
+		memregion = nvgrace_gpu_memregion(RESMEM_REGION_INDEX, nvdev);
+	else if (vfio_pci_core_range_intersect_range(pos, count, PCI_BASE_ADDRESS_4,
+						     sizeof(u64), &copy_offset,
+						     &copy_count, &register_offset))
+		memregion = nvgrace_gpu_memregion(USEMEM_REGION_INDEX, nvdev);
+
+	if (memregion) {
+		if (copy_from_user((void *)&memregion->bar_val + register_offset,
+				   buf + copy_offset, copy_count))
+			return -EFAULT;
+		*ppos += copy_count;
+		return copy_count;
+	}
+
+	return vfio_pci_core_write(core_vdev, buf, count, ppos);
+}
+
+/*
+ * Ad hoc map the device memory in the module kernel VA space. Primarily needed
+ * as vfio does not require the userspace driver to only perform accesses through
+ * mmaps of the vfio-pci BAR regions and such accesses should be supported using
+ * vfio_device_ops read/write implementations.
+ *
+ * The usemem region is cacheable memory and hence is memremaped.
+ * The resmem region is non-cached and is mapped using ioremap_wc (NORMAL_NC).
+ */
+static int
+nvgrace_gpu_map_device_mem(int index,
+			   struct nvgrace_gpu_vfio_pci_core_device *nvdev)
+{
+	struct mem_region *memregion;
+	int ret = 0;
+
+	memregion = nvgrace_gpu_memregion(index, nvdev);
+	if (!memregion)
+		return -EINVAL;
+
+	mutex_lock(&nvdev->remap_lock);
+	if (index == USEMEM_REGION_INDEX && !memregion->memaddr) {
+		memregion->memaddr = memremap(memregion->memphys,
+					      memregion->memlength,
+					      MEMREMAP_WB);
+		if (!memregion->memaddr)
+			ret = -ENOMEM;
+	} else if (index == RESMEM_REGION_INDEX && !memregion->ioaddr) {
+		memregion->ioaddr = ioremap_wc(memregion->memphys,
+					       memregion->memlength);
+		if (!memregion->ioaddr)
+			ret = -ENOMEM;
+	}
+	mutex_unlock(&nvdev->remap_lock);
+
+	return ret;
+}
+
+/*
+ * Read the data from the device memory (mapped either through ioremap
+ * or memremap) into the user buffer.
+ */
+static int
+nvgrace_gpu_map_and_read(struct nvgrace_gpu_vfio_pci_core_device *nvdev,
+			 char __user *buf, size_t mem_count, loff_t *ppos)
+{
+	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
+	u64 offset = *ppos & VFIO_PCI_OFFSET_MASK;
+	int ret;
+
+	/*
+	 * Handle read on the BAR regions. Map to the target device memory
+	 * physical address and copy to the request read buffer.
+	 */
+	ret = nvgrace_gpu_map_device_mem(index, nvdev);
+	if (ret)
+		return ret;
+
+	if (index == USEMEM_REGION_INDEX) {
+		if (copy_to_user(buf,
+				 (u8 *)nvdev->usemem.memaddr + offset,
+				 mem_count))
+			ret = -EFAULT;
+	} else {
+		/*
+		 * The hardware ensures that the system does not crash when
+		 * the device memory is accessed with the memory enable
+		 * turned off. It synthesizes ~0 on such read. So there is
+		 * no need to check or support the disablement/enablement of
+		 * BAR through PCI_COMMAND config space register. Pass
+		 * test_mem flag as false.
+		 */
+		ret = vfio_pci_core_do_io_rw(&nvdev->core_device, false,
+					     nvdev->resmem.ioaddr,
+					     buf, offset, mem_count,
+					     0, 0, false);
+	}
+
+	return ret;
+}
+
+/*
+ * Read count bytes from the device memory at an offset. The actual device
+ * memory size (available) may not be a power-of-2. So the driver fakes
+ * the size to a power-of-2 (reported) when exposing to a user space driver.
+ *
+ * Reads extending beyond the reported size are truncated; reads starting
+ * beyond the reported size generate -EINVAL; reads extending beyond the
+ * actual device size is filled with ~0.
+ */
+static ssize_t
+nvgrace_gpu_read_mem(struct nvgrace_gpu_vfio_pci_core_device *nvdev,
+		     char __user *buf, size_t count, loff_t *ppos)
+{
+	u64 offset = *ppos & VFIO_PCI_OFFSET_MASK;
+	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
+	struct mem_region *memregion;
+	size_t mem_count, i;
+	u8 val = 0xFF;
+	int ret;
+
+	memregion = nvgrace_gpu_memregion(index, nvdev);
+	if (!memregion)
+		return -EINVAL;
+
+	if (offset >= memregion->bar_size)
+		return -EINVAL;
+
+	/* Clip short the read request beyond reported BAR size */
+	count = min(count, memregion->bar_size - (size_t)offset);
+
+	/*
+	 * Determine how many bytes to be actually read from the device memory.
+	 * Read request beyond the actual device memory size is filled with ~0,
+	 * while those beyond the actual reported size is skipped.
+	 */
+	if (offset >= memregion->memlength)
+		mem_count = 0;
+	else
+		mem_count = min(count, memregion->memlength - (size_t)offset);
+
+	ret = nvgrace_gpu_map_and_read(nvdev, buf, mem_count, ppos);
+	if (ret)
+		return ret;
+
+	/*
+	 * Only the device memory present on the hardware is mapped, which may
+	 * not be power-of-2 aligned. A read to an offset beyond the device memory
+	 * size is filled with ~0.
+	 */
+	for (i = mem_count; i < count; i++)
+		put_user(val, (unsigned char __user *)(buf + i));
+
+	*ppos += count;
+	return count;
+}
+
+static ssize_t
+nvgrace_gpu_read(struct vfio_device *core_vdev,
+		 char __user *buf, size_t count, loff_t *ppos)
+{
+	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
+	struct nvgrace_gpu_vfio_pci_core_device *nvdev =
+		container_of(core_vdev, struct nvgrace_gpu_vfio_pci_core_device,
+			     core_device.vdev);
+
+	if (nvgrace_gpu_memregion(index, nvdev))
+		return nvgrace_gpu_read_mem(nvdev, buf, count, ppos);
+
+	if (index == VFIO_PCI_CONFIG_REGION_INDEX)
+		return nvgrace_gpu_read_config_emu(core_vdev, buf, count, ppos);
+
+	return vfio_pci_core_read(core_vdev, buf, count, ppos);
+}
+
+/*
+ * Write the data to the device memory (mapped either through ioremap
+ * or memremap) from the user buffer.
+ */
+static int
+nvgrace_gpu_map_and_write(struct nvgrace_gpu_vfio_pci_core_device *nvdev,
+			  const char __user *buf, size_t mem_count,
+			  loff_t *ppos)
+{
+	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
+	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
+	int ret;
+
+	ret = nvgrace_gpu_map_device_mem(index, nvdev);
+	if (ret)
+		return ret;
+
+	if (index == USEMEM_REGION_INDEX) {
+		if (copy_from_user((u8 *)nvdev->usemem.memaddr + pos,
+				   buf, mem_count))
+			return -EFAULT;
+	} else {
+		/*
+		 * The hardware ensures that the system does not crash when
+		 * the device memory is accessed with the memory enable
+		 * turned off. It drops such writes. So there is no need to
+		 * check or support the disablement/enablement of BAR
+		 * through PCI_COMMAND config space register. Pass test_mem
+		 * flag as false.
+		 */
+		ret = vfio_pci_core_do_io_rw(&nvdev->core_device, false,
+					     nvdev->resmem.ioaddr,
+					     (char __user *)buf, pos, mem_count,
+					     0, 0, true);
+	}
+
+	return ret;
+}
+
+/*
+ * Write count bytes to the device memory at a given offset. The actual device
+ * memory size (available) may not be a power-of-2. So the driver fakes the
+ * size to a power-of-2 (reported) when exposing to a user space driver.
+ *
+ * Writes extending beyond the reported size are truncated; writes starting
+ * beyond the reported size generate -EINVAL.
+ */
+static ssize_t
+nvgrace_gpu_write_mem(struct nvgrace_gpu_vfio_pci_core_device *nvdev,
+		      size_t count, loff_t *ppos, const char __user *buf)
+{
+	u64 offset = *ppos & VFIO_PCI_OFFSET_MASK;
+	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
+	struct mem_region *memregion;
+	size_t mem_count;
+	int ret = 0;
+
+	memregion = nvgrace_gpu_memregion(index, nvdev);
+	if (!memregion)
+		return -EINVAL;
+
+	if (offset >= memregion->bar_size)
+		return -EINVAL;
+
+	/* Clip short the write request beyond reported BAR size */
+	count = min(count, memregion->bar_size - (size_t)offset);
+
+	/*
+	 * Determine how many bytes to be actually written to the device memory.
+	 * Do not write to the offset beyond available size.
+	 */
+	if (offset >= memregion->memlength)
+		goto exitfn;
+
+	/*
+	 * Only the device memory present on the hardware is mapped, which may
+	 * not be power-of-2 aligned. Drop access outside the available device
+	 * memory on the hardware.
+	 */
+	mem_count = min(count, memregion->memlength - (size_t)offset);
+
+	ret = nvgrace_gpu_map_and_write(nvdev, buf, mem_count, ppos);
+	if (ret)
+		return ret;
+
+exitfn:
+	*ppos += count;
+	return count;
+}
+
+static ssize_t
+nvgrace_gpu_write(struct vfio_device *core_vdev,
+		  const char __user *buf, size_t count, loff_t *ppos)
+{
+	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
+	struct nvgrace_gpu_vfio_pci_core_device *nvdev =
+		container_of(core_vdev, struct nvgrace_gpu_vfio_pci_core_device,
+			     core_device.vdev);
+
+	if (nvgrace_gpu_memregion(index, nvdev))
+		return nvgrace_gpu_write_mem(nvdev, count, ppos, buf);
+
+	if (index == VFIO_PCI_CONFIG_REGION_INDEX)
+		return nvgrace_gpu_write_config_emu(core_vdev, buf, count, ppos);
+
+	return vfio_pci_core_write(core_vdev, buf, count, ppos);
+}
+
+static const struct vfio_device_ops nvgrace_gpu_vfio_pci_ops = {
+	.name		= "nvgrace-gpu-vfio-pci",
+	.init		= vfio_pci_core_init_dev,
+	.release	= vfio_pci_core_release_dev,
+	.open_device	= nvgrace_gpu_open_device,
+	.close_device	= nvgrace_gpu_close_device,
+	.ioctl		= nvgrace_gpu_ioctl,
+	.read		= nvgrace_gpu_read,
+	.write		= nvgrace_gpu_write,
+	.mmap		= nvgrace_gpu_mmap,
+	.request	= vfio_pci_core_request,
+	.match		= vfio_pci_core_match,
+	.bind_iommufd	= vfio_iommufd_physical_bind,
+	.unbind_iommufd	= vfio_iommufd_physical_unbind,
+	.attach_ioas	= vfio_iommufd_physical_attach_ioas,
+	.detach_ioas	= vfio_iommufd_physical_detach_ioas,
+};
+
+static const struct vfio_device_ops nvgrace_gpu_vfio_pci_core_ops = {
+	.name		= "nvgrace-gpu-vfio-pci-core",
+	.init		= vfio_pci_core_init_dev,
+	.release	= vfio_pci_core_release_dev,
+	.open_device	= nvgrace_gpu_open_device,
+	.close_device	= vfio_pci_core_close_device,
+	.ioctl		= vfio_pci_core_ioctl,
+	.device_feature	= vfio_pci_core_ioctl_feature,
+	.read		= vfio_pci_core_read,
+	.write		= vfio_pci_core_write,
+	.mmap		= vfio_pci_core_mmap,
+	.request	= vfio_pci_core_request,
+	.match		= vfio_pci_core_match,
+	.bind_iommufd	= vfio_iommufd_physical_bind,
+	.unbind_iommufd	= vfio_iommufd_physical_unbind,
+	.attach_ioas	= vfio_iommufd_physical_attach_ioas,
+	.detach_ioas	= vfio_iommufd_physical_detach_ioas,
+};
+
+static struct
+nvgrace_gpu_vfio_pci_core_device *nvgrace_gpu_drvdata(struct pci_dev *pdev)
+{
+	struct vfio_pci_core_device *core_device = dev_get_drvdata(&pdev->dev);
+
+	return container_of(core_device, struct nvgrace_gpu_vfio_pci_core_device,
+			    core_device);
+}
+
+static int
+nvgrace_gpu_fetch_memory_property(struct pci_dev *pdev,
+				  u64 *pmemphys, u64 *pmemlength)
+{
+	int ret;
+
+	/*
+	 * The memory information is present in the system ACPI tables as DSD
+	 * properties nvidia,gpu-mem-base-pa and nvidia,gpu-mem-size.
+	 */
+	ret = device_property_read_u64(&pdev->dev, "nvidia,gpu-mem-base-pa",
+				       pmemphys);
+	if (ret)
+		return ret;
+
+	if (*pmemphys > type_max(phys_addr_t))
+		return -EOVERFLOW;
+
+	ret = device_property_read_u64(&pdev->dev, "nvidia,gpu-mem-size",
+				       pmemlength);
+	if (ret)
+		return ret;
+
+	if (*pmemlength > type_max(size_t))
+		return -EOVERFLOW;
+
+	/*
+	 * If the C2C link is not up due to an error, the coherent device
+	 * memory size is returned as 0. Fail in such case.
+	 */
+	if (*pmemlength == 0)
+		return -ENOMEM;
+
+	return ret;
+}
+
+static int
+nvgrace_gpu_init_nvdev_struct(struct pci_dev *pdev,
+			      struct nvgrace_gpu_vfio_pci_core_device *nvdev,
+			      u64 memphys, u64 memlength)
+{
+	int ret = 0;
+
+	/*
+	 * The VM GPU device driver needs a non-cacheable region to support
+	 * the MIG feature. Since the device memory is mapped as NORMAL cached,
+	 * carve out a region from the end with a different NORMAL_NC
+	 * property (called as reserved memory and represented as resmem). This
+	 * region then is exposed as a 64b BAR (region 2 and 3) to the VM, while
+	 * exposing the rest (termed as usable memory and represented using usemem)
+	 * as cacheable 64b BAR (region 4 and 5).
+	 *
+	 *               devmem (memlength)
+	 * |-------------------------------------------------|
+	 * |                                           |
+	 * usemem.phys/memphys                         resmem.phys
+	 */
+	nvdev->usemem.memphys = memphys;
+
+	/*
+	 * The device memory exposed to the VM is added to the kernel by the
+	 * VM driver module in chunks of memory block size. Only the usable
+	 * memory (usemem) is added to the kernel for usage by the VM
+	 * workloads. Make the usable memory size memblock aligned.
+	 */
+	if (check_sub_overflow(memlength, RESMEM_SIZE,
+			       &nvdev->usemem.memlength)) {
+		ret = -EOVERFLOW;
+		goto done;
+	}
+	nvdev->usemem.memlength = round_down(nvdev->usemem.memlength,
+					     MEMBLK_SIZE);
+	if ((check_add_overflow(nvdev->usemem.memphys,
+				nvdev->usemem.memlength,
+				&nvdev->resmem.memphys)) ||
+	    (check_sub_overflow(memlength, nvdev->usemem.memlength,
+				&nvdev->resmem.memlength))) {
+		ret = -EOVERFLOW;
+		goto done;
+	}
+
+	/*
+	 * The memory regions are exposed as BARs. Calculate and save
+	 * the BAR size for them.
+	 */
+	nvdev->usemem.bar_size = roundup_pow_of_two(nvdev->usemem.memlength);
+	nvdev->resmem.bar_size = roundup_pow_of_two(nvdev->resmem.memlength);
+done:
+	return ret;
+}
+
+static int nvgrace_gpu_probe(struct pci_dev *pdev,
+			     const struct pci_device_id *id)
+{
+	const struct vfio_device_ops *ops = &nvgrace_gpu_vfio_pci_core_ops;
+	struct nvgrace_gpu_vfio_pci_core_device *nvdev;
+	u64 memphys, memlength;
+	int ret;
+
+	ret = nvgrace_gpu_fetch_memory_property(pdev, &memphys, &memlength);
+	if (!ret)
+		ops = &nvgrace_gpu_vfio_pci_ops;
+
+	nvdev = vfio_alloc_device(nvgrace_gpu_vfio_pci_core_device, core_device.vdev,
+				  &pdev->dev, ops);
+	if (IS_ERR(nvdev))
+		return PTR_ERR(nvdev);
+
+	dev_set_drvdata(&pdev->dev, &nvdev->core_device);
+
+	if (ops == &nvgrace_gpu_vfio_pci_ops) {
+		/*
+		 * Device memory properties are identified in the host ACPI
+		 * table. Set the nvgrace_gpu_vfio_pci_core_device structure.
+		 */
+		ret = nvgrace_gpu_init_nvdev_struct(pdev, nvdev,
+						    memphys, memlength);
+		if (ret)
+			goto out_put_vdev;
+	}
+
+	ret = vfio_pci_core_register_device(&nvdev->core_device);
+	if (ret)
+		goto out_put_vdev;
+
+	return ret;
+
+out_put_vdev:
+	vfio_put_device(&nvdev->core_device.vdev);
+	return ret;
+}
+
+static void nvgrace_gpu_remove(struct pci_dev *pdev)
+{
+	struct nvgrace_gpu_vfio_pci_core_device *nvdev = nvgrace_gpu_drvdata(pdev);
+	struct vfio_pci_core_device *vdev = &nvdev->core_device;
+
+	vfio_pci_core_unregister_device(vdev);
+	vfio_put_device(&vdev->vdev);
+}
+
+static const struct pci_device_id nvgrace_gpu_vfio_pci_table[] = {
+	/* GH200 120GB */
+	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_NVIDIA, 0x2342) },
+	/* GH200 480GB */
+	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_NVIDIA, 0x2345) },
+	{}
+};
+
+MODULE_DEVICE_TABLE(pci, nvgrace_gpu_vfio_pci_table);
+
+static struct pci_driver nvgrace_gpu_vfio_pci_driver = {
+	.name = KBUILD_MODNAME,
+	.id_table = nvgrace_gpu_vfio_pci_table,
+	.probe = nvgrace_gpu_probe,
+	.remove = nvgrace_gpu_remove,
+	.err_handler = &vfio_pci_core_err_handlers,
+	.driver_managed_dma = true,
+};
+
+module_pci_driver(nvgrace_gpu_vfio_pci_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Ankit Agrawal <ankita@nvidia.com>");
+MODULE_AUTHOR("Aniket Agashe <aniketa@nvidia.com>");
+MODULE_DESCRIPTION("VFIO NVGRACE GPU PF - User Level driver for NVIDIA devices with CPU coherently accessible device memory");
-- 
2.34.1


