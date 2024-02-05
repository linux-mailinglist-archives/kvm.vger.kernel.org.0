Return-Path: <kvm+bounces-8054-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 916DF84AA2B
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 00:03:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 488F0293BBC
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 23:03:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43E0B4BAB6;
	Mon,  5 Feb 2024 23:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="LvW8wjFd"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2059.outbound.protection.outlook.com [40.107.243.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F1FE3CF58;
	Mon,  5 Feb 2024 23:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707174110; cv=fail; b=kLZatqX218UmDJl0/H1/IEYvuYXAp6RLBqbAsL10nAivPQTqsQSU8hnewmRxy+c3i0cv0V+eYbyXFU07xYcMZ8OseAyTXb7jvU/4clY8ddUF2GYv2JOB3pqqQ1bUpHEYzSlQhmbdT/Ww/s0TRjyCjONpPCymIE4lSdU1P3EWAfA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707174110; c=relaxed/simple;
	bh=XlzphpN0+B2XskUUUR8NVhyITjWmNKw+KOi2uLzDFsg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=d+fUOExhTt1e4bk+EwZoySv0EBs6xknHUBTVEdG04x2LxbgSiiO9HOFpZZ737Cww2aORGbNATrX9RbXnem8wUHoxEGudkZMsX5plkw6OHbJS20vjJUKWVnehqE17+MRDOUNUR+IouvmMBUCnMO7FJbRgn70Ldy63ogVzSTNrN9Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=LvW8wjFd; arc=fail smtp.client-ip=40.107.243.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LO8CJA4p9DCeSjlXCy99Cw6PXLS/R8EVb6pH8bvztUQjg25YqE46moPimih6zuDPdKgcTdOSZc3xQZeXYmXLh1SYPwClITqlqqHvGSpDCIc8kpaYuRjSyujIuBMq8f0ztx/0ANhOFlLhW7+BaSrC3+AsitjiTS9FHzAPX+IovuQui6Zqhtopz4u6itGpVlDBVJ5A/CHZuLmgYBQALRXtT+rNMuCkx4XjP8XmS5ZJJJjSLM4m3W/pf5PBJaQ00kNlv6pJ6q3Lp0gR34n1P4MwwVzYIXl11ch3pr39lg2XNSeVYeh01GOsajNR9fDLwZe8eQ9b+zcwyLmfCpwD7OmycQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cslpe/vNkle6P8VNFzzxPckcfnqJRJuRU+Gn7cbMrik=;
 b=ag+1lRs0rC3asxzb2R869VinhEXYlp886QcsvpP/HqnKLsdbat6FQ7hIfeN3/O/RQwwRRoajeL+nsi4PsVXMrG46J/s7MMbsv4+rUI41AG07P0+d25VUpvvGz25CaLGJsrHlz5VP/p3w8rfduqXZ74xqfwU/RNoeIpUiu/uRoFf1LZ61Wv3P2IJ5DRDGpFFivYkqlFAGmdUW9RORWFeq8pEF9Uyt0mPWrAY3TU/55buH64lv6xRaein/Orq3uknXx3nj1xtkXoXu2h/tB456q67BdYIfsgj8TABaxSQ/h5z4UmX7bBpiMG7rM9DsdHVstIa99bcvZFqeQBj4mwQVFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cslpe/vNkle6P8VNFzzxPckcfnqJRJuRU+Gn7cbMrik=;
 b=LvW8wjFd2f8LQvm8TkUBfyMwrRpayW9zkXAt8vE9GpPsuD6cp4xzcXHHQ4IE6qOla+9NVPPb74MX/kcsOojpTDYD009vBtw+Stsqt8LIesZ9I21qcbco8RoW2EYRxCOwCiwJchicSos3u+qbE2rs+ClXN++iuTJ67Lit6ENtaGYozdCADApbS7hJqyfotIZNLHyNerXpa5yHv/4fDm+MznsTLQfPyhX4V8x47xXMNePkxZ5HFsVzkWZ0cu8reTOn763kVWqC0U8y3u9Zptr1X0ZOUIGO5WN23DJjw0mqYwL3Lleo7mVDDy6UC+B1x2Iwz1GEUfMGft0XgnZuxgEucg==
Received: from DS7PR05CA0073.namprd05.prod.outlook.com (2603:10b6:8:57::27) by
 DM4PR12MB6039.namprd12.prod.outlook.com (2603:10b6:8:aa::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7270.13; Mon, 5 Feb 2024 23:01:45 +0000
Received: from DS3PEPF000099D3.namprd04.prod.outlook.com
 (2603:10b6:8:57:cafe::4c) by DS7PR05CA0073.outlook.office365.com
 (2603:10b6:8:57::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.24 via Frontend
 Transport; Mon, 5 Feb 2024 23:01:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DS3PEPF000099D3.mail.protection.outlook.com (10.167.17.4) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7249.19 via Frontend Transport; Mon, 5 Feb 2024 23:01:45 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 5 Feb 2024
 15:01:33 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.12; Mon, 5 Feb 2024 15:01:32 -0800
Received: from sgarnayak-dt.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12 via Frontend
 Transport; Mon, 5 Feb 2024 15:01:25 -0800
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
Subject: [PATCH v17 0/3] vfio/nvgrace-gpu: Add vfio pci variant module for grace hopper
Date: Tue, 6 Feb 2024 04:31:20 +0530
Message-ID: <20240205230123.18981-1-ankita@nvidia.com>
X-Mailer: git-send-email 2.17.1
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D3:EE_|DM4PR12MB6039:EE_
X-MS-Office365-Filtering-Correlation-Id: 86ab51b5-7b72-48f8-c592-08dc269e6cf2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	3T6mp1a+CZgel0CK7k39nwIDH+vwaiBgJpheNET6toltpM9xTCLAy6Dk1+wv+wPasWJmMYKwWDtFVQFHZSTq6EQuXT5cp7ZQOgsXlIF4ipnKytxw+b+TIfDVfMKUSJq9LZWXCE9Cyh9e+kG0gK9jcgQDpJJ3uX4ynbthBPtMMfOGTAmIkNgE38gbqjS5Sr/Vv38umgf92ANDRO1iFWbsIFs/SXXjVNUnGBNsUYk0O5UoGk2CUOTPhH/BAI8Utfvbdfw/i1JbSgpxOeCS6jC85+96pC84ty6JBjb/rAKvkLMJVp/UIg9oLQi0j+VSdWK5pqHwIKqfbwQkUfx5loyFnTn/zSqRa2MXit/gPLVihSkPteSi9oxC7j8X3dXzuo7dlHlh2JdS6Ay+lWzfOCBVx7J9fWRr11JUflBoK2Zyn8shnKP/Goz5LEA9jiKbpBBRCdeNitJL7j06TNXbtkEK3F+eY30Dju2JmDyZBBbGyNynJ6Cudr2st1eVxbxfajNoPPFQNd5PkYaAeToO/JZDbaDAs4xj/ZJj2oOUom44GKmoCpS7fuPeUTDjI96pn3j7cbahx0EdHboxgaLrl+OP1atHDGe+QNhOimoc0E5WchZ/B9inXiHm0P5j1v9e6k76USB3jsOU4ZB98P780nJfG3ipfhY6f2jPZy6NMKJzF7uyGeRGZkbux/E90+CqWuyk+i1S0IW/IXLl+SMgs8QEakzu5EQ3fiPt9NHZjOd1lr4zxdn30MVGTZoOasp2UH8Lw4021RugimKIvE6M41QzFNkJPI3pvO9geyweU2fG4QiaD34qxC2McfEqupNo7gk3+RESRZJnyenTCaYPpc31Ig==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(376002)(396003)(346002)(39860400002)(230922051799003)(82310400011)(451199024)(1800799012)(186009)(64100799003)(36840700001)(40470700004)(46966006)(6636002)(54906003)(316002)(70586007)(336012)(70206006)(110136005)(36860700001)(478600001)(966005)(7416002)(5660300002)(86362001)(7696005)(2876002)(426003)(36756003)(26005)(921011)(83380400001)(2616005)(1076003)(2906002)(30864003)(7636003)(356005)(8676002)(47076005)(8936002)(4326008)(6666004)(41300700001)(84970400001)(40480700001)(82740400003)(40460700003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2024 23:01:45.2899
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 86ab51b5-7b72-48f8-c592-08dc269e6cf2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D3.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6039

From: Ankit Agrawal <ankita@nvidia.com>

NVIDIA's upcoming Grace Hopper Superchip provides a PCI-like device
for the on-chip GPU that is the logical OS representation of the
internal proprietary chip-to-chip cache coherent interconnect.

The device is peculiar compared to a real PCI device in that whilst
there is a real 64b PCI BAR1 (comprising region 2 & region 3) on the
device, it is not used to access device memory once the faster
chip-to-chip interconnect is initialized (occurs at the time of host
system boot). The device memory is accessed instead using the
chip-to-chip interconnect that is exposed as a contiguous physically
addressable region on the host. Since the device memory is cache
coherent with the CPU, it can be mmaped into the user VMA with a
cacheable mapping and used like a regular RAM. The device memory is
not added to the host kernel, but mapped directly as this reduces
memory wastage due to struct pages.

There is also a requirement of a reserved 1G uncached region (termed as
resmem) to support the Multi-Instance GPU (MIG) feature [1]. This is
to work around a HW defect. Based on [2], the requisite properties
(uncached, unaligned access) can be achieved through a VM mapping (S1)
of NORMAL_NC and host (S2) mapping with MemAttr[2:0]=0b101. To provide
a different non-cached property to the reserved 1G region, it needs to
be carved out from the device memory and mapped as a separate region
in Qemu VMA with pgprot_writecombine(). pgprot_writecombine() sets
the Qemu VMA page properties (pgprot) as NORMAL_NC.

Provide a VFIO PCI variant driver that adapts the unique device memory
representation into a more standard PCI representation facing userspace.

The variant driver exposes these two regions - the non-cached reserved
(resmem) and the cached rest of the device memory (termed as usemem) as
separate VFIO 64b BAR regions. This is divergent from the baremetal
approach, where the device memory is exposed as a device memory region.
The decision for a different approach was taken in view of the fact that
it would necessiate additional code in Qemu to discover and insert those
regions in the VM IPA, along with the additional VM ACPI DSDT changes to
communiate the device memory region IPA to the VM workloads. Moreover,
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

If the device memory properties are not present in the host ACPI table,
the driver registers the vfio-pci-core function pointers.

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

Applied over v6.8-rc2.

Signed-off-by: Aniket Agashe <aniketa@nvidia.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
Link for variant driver v16:
https://lore.kernel.org/all/20240115211516.635852-1-ankita@nvidia.com/

v16 -> v17
- Moved, renamed and exported the range_intersect_range() per
  suggestion from Rahul Rameshbabu.
- Updated license from GPLv2 to GPL.
- Fixed S-O-B mistakes.
- Removed nvgrace_gpu_vfio_pci.h based on Alex Williamson's suggestion.
- Refactor [read]write_config_emu based on Alex's suggestion
- Added fallback to vfio-pci-core function pointers in case of absence
  of memory properties in the host ACPI table as per Alex's suggestion.
- Used anonymous union to represent the mapped device memory.
- Fixed code nits and rephrased comments.
- Rebased to v6.8-rc2.

v15 -> v16
- Added the missing header file causing build failure in v15.
- Moved the range_intersect_range function() to a seperate patch.
- Exported the do_io_rw as GPL and moved to the vfio-pci-core file.
- Added helper function to mask with BAR size and add flag while
  returning a read on the fake BARs PCI config register.
- Removed the PCI command disable.
- Removed nvgrace_gpu_vfio_pci_fake_bar_mem_region().
- Fixed miscellaneous nits.

v14 -> v15
- Added case to handle VFIO_DEVICE_IOEVENTFD to return -EIO as it
  is not required on the device.
- Updated the BAR config space handling code to closely resemble
  by Yishai Hadas (using range_intersect_range) in
  https://lore.kernel.org/all/20231207102820.74820-10-yishaih@nvidia.com
- Changed the bar pci config register from union to u64.
- Adapted the code to disable BAR when it is disabled through
  PCI_COMMAND.
- Exported and reused the do_io_rw to do mmio accesses.
- Added a new header file to keep the newly declared structures.
- Miscellaneous code fixes suggested by Alex Williamson in v14.

v13 -> v14
- Merged the changes for second BAR implementation for MIG support
  on the device driver.
  https://lore.kernel.org/all/20231115080751.4558-1-ankita@nvidia.com/
- Added the missing implementation of sub-word access to fake BARs'
  PCI config access. Implemented access algorithm suggested by
  Alex Williamson in the comments (Thanks!)
- Added support to BAR accesses on the reserved memory with
  Qemu device param x-no-mmap=on.
- Handled endian-ness in the PCI config space access.
- Git commit message change

v12 -> v13
- Added emulation for the PCI config space BAR offset register for
the fake BAR.
- commit message updated with more details on the BAR offset emulation.

v11 -> v12
- More details in commit message on device memory size

v10 -> v11
- Removed sysfs attribute to expose the CPU coherent memory feature
- Addressed review comments

v9 -> v10
- Add new sysfs attribute to expose the CPU coherent memory feature.

v8 -> v9
- Minor code adjustment suggested in v8.

v7 -> v8
- Various field names updated.
- Added a new function to handle VFIO_DEVICE_GET_REGION_INFO ioctl.
- Locking protection for memremap to bar region and other changes
  recommended in v7.
- Added code to fail if the devmem size advertized is 0 in system DSDT.

v6 -> v7
- Handled out-of-bound and overflow conditions at various places to validate
  input offset and length.
- Added code to return EINVAL for offset beyond region size.

v5 -> v6
- Added the code to handle BAR2 read/write using memremap to the device
  memory.

v4 -> v5
- Changed the module name from nvgpu-vfio-pci to nvgrace-gpu-vfio-pci.

v3 -> v4
- Mapping the available device memory using sparse mmap. The region outside
  the device memory is handled by read/write ops.
- Removed the fault handler added in v3.

v2 -> v3
- Added fault handler to map the region outside the physical GPU memory
  up to the next power-of-2 to a dummy PFN.
- Changed to select instead of "depends on" VFIO_PCI_CORE for all the
  vfio-pci variant driver.
- Code cleanup based on feedback comments.
- Code implemented and tested against v6.4-rc4.

v1 -> v2
- Updated the wording of reference to BAR offset and replaced with
  index.
- The GPU memory is exposed at the fixed BAR2_REGION_INDEX.
- Code cleanup based on feedback comments.

Ankit Agrawal (3):
  vfio/pci: rename and export do_io_rw()
  vfio/pci: rename and export range_intesect_range
  vfio/nvgrace-gpu: Add vfio pci variant module for grace hopper

 MAINTAINERS                           |   6 +
 drivers/vfio/pci/Kconfig              |   2 +
 drivers/vfio/pci/Makefile             |   2 +
 drivers/vfio/pci/nvgrace-gpu/Kconfig  |  10 +
 drivers/vfio/pci/nvgrace-gpu/Makefile |   3 +
 drivers/vfio/pci/nvgrace-gpu/main.c   | 856 ++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_config.c    |  45 ++
 drivers/vfio/pci/vfio_pci_rdwr.c      |  16 +-
 drivers/vfio/pci/virtio/main.c        |  72 +--
 include/linux/vfio_pci_core.h         |  10 +-
 10 files changed, 968 insertions(+), 54 deletions(-)
 create mode 100644 drivers/vfio/pci/nvgrace-gpu/Kconfig
 create mode 100644 drivers/vfio/pci/nvgrace-gpu/Makefile
 create mode 100644 drivers/vfio/pci/nvgrace-gpu/main.c

-- 
2.34.1


