Return-Path: <kvm+bounces-9175-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0185F85BAEF
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 12:51:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2628B1C22418
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 11:51:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E10A67C45;
	Tue, 20 Feb 2024 11:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="n2Dl6U3c"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2068.outbound.protection.outlook.com [40.107.95.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FEA3679ED;
	Tue, 20 Feb 2024 11:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708429881; cv=fail; b=Kr4P5tUnXM4MbA28mB+0tMpS7kxG4d4iziwJbxV6kV/vJQOY5iPS6KN1rmOExbDHdXJ7ttLfTQ/gABQzqr51ZwFWaEbOxSt6j9kECLo4Ebr1Ktj/H1pqua2dWh6hOdJtZo0nSjn4Sx6J0cm5J2TCaV/jbpRuBZgtDvFVGuxgaw4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708429881; c=relaxed/simple;
	bh=SzWHFPbzpFRhfibZscw0WMfKpE505Ed1fVOD5TNNAx4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=uan3A7ZKIIorau7hqws/YZxBzAHI6xdF5ZkHQhHSoG+Xdy7DG7CtlJ8/YsbW4U7OFBnZapBZvbH4761D7+P1x/y54wHX0ugrqCpyPaYd3AUnyBvSEMNA/Otvkeww95AmMDJ++JHrvgb6YrLG0ed6m+tigBw3qyJTbL6tlVJNkb4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=n2Dl6U3c; arc=fail smtp.client-ip=40.107.95.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MJU/conr3lIULyrIlpCC3uuuWYZeCUgpM6XaBOQuXDFeLR3In8nd4FSeIJQZF+4YeuSk2BATy1W5zvRL4ayMS4G+cFfKNBdu57fYyHh3oO2MzOLXMbtaeoua51CwIEYHaeDMUlZ+rJ24V/3VMmAZGPWGscmtlMc4os+qGEOlxqsshX0QFc6zc/za64h4PmO6gh1W88YV6PgCLOueMD7Aj7uue6D6YAFw7IuUdQNHvpS+CjZ9pAX6fFs3hcY07Q1g40xgqd+sFmpjklJJhQ8p3m4GplTauQYBwBfsJb6TMhOQbumYFIvmLPvceRTUlH3+Mh3v8DCz8T0s+BRpc3gBGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3QTtnlUupKKE0gB+UQDUqO4F2QY8kDBQLhqN5T4NwJk=;
 b=Qkw0MdejEkJLlw1kwRMUtF94xSO7pFYq4TcY/WPSgStOsyUPIU3PjsiAOczJUNa5Uq/Z+kcVUeyu3HA2VZFayoJucSkfcDC/2eWEMgqQnGd16t9H9ug+OrNLyCVaXiAmmGYcoA8iLDiJRG++Mb/14w13h87Y8FshpIQ36YmR9jVKj0CFXX0yrsELUl2EcwZ1r0XSUrJrfVQcLBcR3lKXWz/TzsZd98osUTsYcIWhInaIMLZqvzYCDRUEx8Ieeck6d2/FNcgeEn5SqWdZ1Be+YSAhngxrYmc6oltr66B5GYQoG+hBE+FWZECSHWL1l2XNbirlIi+AdbXA4kjY0lezfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3QTtnlUupKKE0gB+UQDUqO4F2QY8kDBQLhqN5T4NwJk=;
 b=n2Dl6U3c5sgsYSQRUe90OQuWL+OAEQFS+ZA642sZ9P2esa3iiKy6saxvZbzvX2qOECCxgSOer5Rm7Oj1ALPoi5bb6TeoW2zquoySNQVwA+sROhKFS/OJPTcSSJJXa3ORDL+iD4y+lZVsKbH65tvY04pnPWyJJTUA+tQroL+cdaZvsYWMGY4LnqaUk1Pq59hCPZupa0L6zhItObEgLTph6Wd+zIX1nzm33AeC8gLUkR6rnphw7HjZE8jhmg7rJtTp4uNSohJbO9xyWz8n9XEYhAguSUKfM7nbw2voy7gx460UaUezJ7RAuJwhQvYyH1FDjnhmIHJOcm1wT0/3R3HuBQ==
Received: from BYAPR08CA0068.namprd08.prod.outlook.com (2603:10b6:a03:117::45)
 by MN2PR12MB4536.namprd12.prod.outlook.com (2603:10b6:208:263::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.25; Tue, 20 Feb
 2024 11:51:16 +0000
Received: from CO1PEPF000044EE.namprd05.prod.outlook.com
 (2603:10b6:a03:117:cafe::f7) by BYAPR08CA0068.outlook.office365.com
 (2603:10b6:a03:117::45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.40 via Frontend
 Transport; Tue, 20 Feb 2024 11:51:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CO1PEPF000044EE.mail.protection.outlook.com (10.167.241.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7292.25 via Frontend Transport; Tue, 20 Feb 2024 11:51:15 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 20 Feb
 2024 03:51:05 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.12; Tue, 20 Feb 2024 03:51:04 -0800
Received: from sgarnayak-dt.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12 via Frontend
 Transport; Tue, 20 Feb 2024 03:50:57 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>,
	<yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
	<kevin.tian@intel.com>, <mst@redhat.com>, <eric.auger@redhat.com>,
	<jgg@ziepe.ca>, <oleksandr@natalenko.name>, <clg@redhat.com>,
	<satyanarayana.k.v.p@intel.com>, <brett.creeley@amd.com>, <horms@kernel.org>,
	<shannon.nelson@amd.com>, <rrameshbabu@nvidia.com>, <zhiw@nvidia.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<anuaggarwal@nvidia.com>, <mochs@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <virtualization@lists.linux-foundation.org>
Subject: [PATCH v19 0/3] vfio/nvgrace-gpu: Add vfio pci variant module for grace hopper
Date: Tue, 20 Feb 2024 17:20:52 +0530
Message-ID: <20240220115055.23546-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044EE:EE_|MN2PR12MB4536:EE_
X-MS-Office365-Filtering-Correlation-Id: b211332e-cad0-4798-6fd1-08dc320a3e75
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	l35bvTBw9uRji+NRyLiqvkbjLwJ3hD4a4pCQMiFAmRt87LiOYrIjhwblKMcNBODXMgyCsLGtOW/+SSebVd+eY+RNRYNIEq0aud9kdashoOR4OoKu8mYWVBHmV/7LVcA/wWfIGrDOfQCyjoFUK4JninDsByxPFiTQz7AEtNmMpz3O8la6+oJUjtTrl6YzGOZIiorZds3iY4u6SsDYGqdAw0Gqrc+m4b3i8scIPF9Ff4hwHxO3ixVJZQgeO4xzSALVTlzWd9PzBAn7NAV7hHsGnkGQ6mZQDCzu/hJnnoM345m2ZxFrnycJ4eRklB9uTGu4GQbFdoDlJ4W2zdK8HxSaLeTuYs5ttJCsg236/l/jL6XpYQOLaI8ASqqpkVMd9SBL33paRkx47+ZYb4Yc9R84wgWITy2LVLbi5ODcXx4Aps/mj0aEUJqedcsyJ/en1P4w+SE6BqczCXUWOQYvwCVO7IBFWTddy/WosJnFdL4jJJ/qZFYbxhlrkiUDLghix0qNmROISrzykULI1S+Fvt1vi3iBMHu863AjqXYjlM402TV/BEZA3NxWPJBpPYHICjj/1HQNUohUtgNjCmiWrpitE6womrKFhM7tKKZbQXtFcahGn0az8SdMMmyKfDWN2AKQfeit12GWGtd9nN0uCXgVNxbaZGKsr82mqSXcLfsKoVZA+bXaFCspijhiAw2UqRCufQRCS8Qr4zft1lAfbPUBSg==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230031)(36860700004)(46966006)(40470700004)(921011);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2024 11:51:15.7775
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b211332e-cad0-4798-6fd1-08dc320a3e75
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044EE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4536

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

There is also a requirement of a minimum reserved 1G uncached region
(termed as resmem) to support the Multi-Instance GPU (MIG) feature [1].
This is to work around a HW defect. Based on [2], the requisite properties
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
usemem.memphys                              resmem.memphys

PCI BARs need to be aligned to the power-of-2, but the actual memory on the
device may not. A read or write access to the physical address from the
last device PFN up to the next power-of-2 aligned physical address
results in reading ~0 and dropped writes. Note that the GPU device
driver [6] is capable of knowing the exact device memory size through
separate means. The device memory size is primarily kept in the system
ACPI tables for use by the VFIO PCI variant module.

Note that the usemem memory is added by the VM Nvidia device driver [5]
to the VM kernel as memblocks. Hence make the usable memory size memblock
(MEMBLK_SIZE) aligned. This is a hardwired ABI value between the GPU FW and
VFIO driver. The VM device driver make use of the same value for its
calculation to determine USEMEM size.

Currently there is no provision in KVM for a S2 mapping with
MemAttr[2:0]=0b101, but there is an ongoing effort to provide the same [3].
As previously mentioned, resmem is mapped pgprot_writecombine(), that
sets the Qemu VMA page properties (pgprot) as NORMAL_NC. Using the
proposed changes in [3] and [4], KVM marks the region with
MemAttr[2:0]=0b101 in S2.

If the device memory properties are not present, the driver registers the
vfio-pci-core function pointers. Since there are no ACPI memory properties
generated for the VM, the variant driver inside the VM will only use
the vfio-pci-core ops and hence try to map the BARs as non cached. This
is not a problem as the CPUs have FWB enabled which blocks the VM
mapping's ability to override the cacheability set by the host mapping.

This goes along with a qemu series [6] to provides the necessary
implementation of the Grace Hopper Superchip firmware specification so
that the guest operating system can see the correct ACPI modeling for
the coherent GPU device. Verified with the CUDA workload in the VM.

[1] https://www.nvidia.com/en-in/technologies/multi-instance-gpu/
[2] section D8.5.5 of https://developer.arm.com/documentation/ddi0487/latest/
[3] https://lore.kernel.org/all/20240211174705.31992-1-ankita@nvidia.com/
[4] https://lore.kernel.org/all/20230907181459.18145-2-ankita@nvidia.com/
[5] https://github.com/NVIDIA/open-gpu-kernel-modules
[6] https://lore.kernel.org/all/20231203060245.31593-1-ankita@nvidia.com/

Applied over v6.8-rc5.

Signed-off-by: Aniket Agashe <aniketa@nvidia.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
Link for variant driver v18:
https://lore.kernel.org/all/20240216030128.29154-1-ankita@nvidia.com/

v18 -> v19
- Removed unnecessary memregion null check in nvgrace_gpu_read[write]_mem
  based on Yishai's comment.
- Added error check for put_user.
- Added device_feature function pointer as pointed out by Yishia.
- Removed nvgrace_gpu_drvdata and inlined the code.
- Moved the nvdev->usemem.memlength check earlier in
  nvgrace_gpu_init_nvdev_struct.
- Sorted header list in alphabetical order Per Zhi's comment.
- Rebased to v6.8-rc5.

v17 -> v18
- Reorg nvgrace_gpu_open_device code based on Zhi Wang's suggestion
- Added code to return early in nvgrace_gpu_map_and_read[write] when
  mem_count is 0.
- Put the module information in MAINTAINERS in alphabetical order
  based on Alex's suggestion.
- Consolidated check for the union value in nvgrace_gpu_map_device_mem.
- Put comments around usage of MEMBLK_SIZE from Kevin's suggestion.
- Fixed *ppos to revert to the starting position on failure in
  nvgrace_gpu_read_config_emu.
- Fixed nits suggested by Alex and Kevin.
- Updated commit message to add information on MEMBLK_SIZE and
  nested VM.
- Rebased to v6.8-rc4.

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
  vfio/pci: rename and export range_intersect_range
  vfio/nvgrace-gpu: Add vfio pci variant module for grace hopper

 MAINTAINERS                           |  16 +-
 drivers/vfio/pci/Kconfig              |   2 +
 drivers/vfio/pci/Makefile             |   2 +
 drivers/vfio/pci/nvgrace-gpu/Kconfig  |  10 +
 drivers/vfio/pci/nvgrace-gpu/Makefile |   3 +
 drivers/vfio/pci/nvgrace-gpu/main.c   | 879 ++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_config.c    |  42 ++
 drivers/vfio/pci/vfio_pci_rdwr.c      |  16 +-
 drivers/vfio/pci/virtio/main.c        |  72 +--
 include/linux/vfio_pci_core.h         |  10 +-
 10 files changed, 993 insertions(+), 59 deletions(-)
 create mode 100644 drivers/vfio/pci/nvgrace-gpu/Kconfig
 create mode 100644 drivers/vfio/pci/nvgrace-gpu/Makefile
 create mode 100644 drivers/vfio/pci/nvgrace-gpu/main.c

-- 
2.34.1


