Return-Path: <kvm+bounces-6285-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C99AF82E21E
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 22:16:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 98A9AB21FE1
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 21:16:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 884341B58D;
	Mon, 15 Jan 2024 21:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="A2jefPK/"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2053.outbound.protection.outlook.com [40.107.212.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3A31B263;
	Mon, 15 Jan 2024 21:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BEEBjtee4K/dYiuwwTTezWC8/966KW64q832EjZu6cFEtRvu3WejPqCLAvyKHVY4rtvH/1wE/hE+nZyK/LtHIm7/B74aPnu6ewMpttPAr+ea+APxMFdx4R3uor086kMQf4b2WdMvTtpMAeGwyvwRxkYjCDrcipCi88KaIx17iPhssRE3ok2y2pelFWOHY5GLewSlcFehtECnpJ4r7d0zzjkpR18X/VRmWO8FQnn1vChz6QwuuGFqbK0gpYvVfeJbVRqw55D9ymKH3Eq5IyfypiRukpLFIv2w5a63GFWboycAAMZCu1/g50Ak8J6LBZDAvYxa2yvlKM/Dm1M++vT+jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wac5hCDsVbS7ZZzYvLtGy1Y4dWo56ufKe4+yf821eMI=;
 b=kDhHlwneo3A7HGWeDkSWATxzAo4r++7+mCAoKTnlZcUS4yLMCNy9MVrTTOxoTnRdpFCJSUl+Q720AkmQj0oh3kno51uiNwgY5w4TFY4AN4PtyItAo0ot47igawmzRsHLVI0HoV5X8Mt+AmhWPKgJUu+7bHcXtsfUQFF1h6RlyuQDrpwzI4gOZGykPR04VUirhRTTpdHNJH9J8LYz1h/h4cMzpRPwYS7PUNBs59PQFCGFjEL4+QPHRS9J7EUJ6hNnZCBso5bgYcl9ZlXr8wlOJ/hX6p6ynA0TRChkoTuBu5ITUJ6h+ByEdsSnt7HenYAcY4vsuU7jqtOtR9gAhGbV3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wac5hCDsVbS7ZZzYvLtGy1Y4dWo56ufKe4+yf821eMI=;
 b=A2jefPK/9gAjYAQLrA6EPkxrHi+g09aTWt3rlCwMuZolKsrv57THiZWJ8kWPwnvdbm5SHaU4U03UcDFk4fYbKzb7hoxJfzDTz+7lBjgmMjY74CUv4SJI6YBepvlW3FiRUtS+kSLy5pkwN6/5tTvJtMI+Ca7+6cL/In8c7+/2vGCEWimETatAeCRNb8cK1Kvmnw9sQlC22EjrIkSjhM+Np2fhDwVvxanf59mItqUpZDH9L5ze8xkeBgCPqUJWWsvX2Sru8qh0tEeU4Hge7RzX5vY/iZopZ/zZKJyGSqgUCCK2Ws1n1s4SVAe+ODGZQGQGpseQ001dCoa4nuLTC+kTdw==
Received: from DS7PR06CA0026.namprd06.prod.outlook.com (2603:10b6:8:54::16) by
 CY5PR12MB6430.namprd12.prod.outlook.com (2603:10b6:930:3a::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7181.21; Mon, 15 Jan 2024 21:15:34 +0000
Received: from SN1PEPF0002BA51.namprd03.prod.outlook.com
 (2603:10b6:8:54:cafe::9) by DS7PR06CA0026.outlook.office365.com
 (2603:10b6:8:54::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7181.26 via Frontend
 Transport; Mon, 15 Jan 2024 21:15:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SN1PEPF0002BA51.mail.protection.outlook.com (10.167.242.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7202.16 via Frontend Transport; Mon, 15 Jan 2024 21:15:34 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 15 Jan
 2024 13:15:17 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 15 Jan
 2024 13:15:17 -0800
Received: from localhost.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41 via Frontend
 Transport; Mon, 15 Jan 2024 13:15:16 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>,
	<yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
	<kevin.tian@intel.com>, <eric.auger@redhat.com>, <brett.creeley@amd.com>,
	<horms@kernel.org>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<anuaggarwal@nvidia.com>, <mochs@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v16 0/3] vfio/nvgrace-gpu: Add vfio pci variant module for grace hopper
Date: Mon, 15 Jan 2024 21:15:13 +0000
Message-ID: <20240115211516.635852-1-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA51:EE_|CY5PR12MB6430:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e4254d6-7ff1-48b9-d25a-08dc160f1cc3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	1V/jHoEysdhJHqTpJA0rjFmGf0QcDCGXIiknaJaYtUr1EYYi8vQ+7VPv90uNI80hpXwmzN4Ht2Ue07Hl8zc4naG1DvNlZWTmiAhQJLB2XvsXK+2pfHpEJPWNB5S44lI+jEGfoJkR3OopiB3yDUI8vkjDlEEGWU/qI59vtuIKT6dLH/FqsMjiBpjWbJ0QDwHDvXZ/q6ovVWqzkt5BYlxQud+NouJsbIWSZmtdxDF91ddxQh58fyOWaj1MlvX0USFLytRTSurgMFsZcq4c38u/X52gcFxgYtbkWlc0CDtGj/Ecf2asxxkgizdqfj5WVxMHNsQSYOY/5OKp1Z9CIa0oSl/YSMxwW+3EdM6ov7TDwxlhdTK4Jp7mRowVEHwXChohMe/+qdKjIpBtv2Amr11p8hDW8TSRw0MJksmSK1Zoc3Yv5+lQS6SwnKQPhNUCo+4JfqZDwwvbC44TaKc91uuqjV/s+fllCvfNbDHnLaMiKaQpkoVfEdW2slPXI7SFECKjd6VWp2ViRWraeeLZz4OVuxEY6T30p5DN0kBs96pNAalfdhxPlqlPN4MUfmDNezquYSm1oLhIWE/MMtWSo9V1G/OoRqMS6Zjqs5MM7Yfy2pn6UPqQHskqg5I5RJZ+2tOA+MbIJ2jsgJDTUyXnhibd1pENuT7k0ieBmRAAAO5bdRkexFZ4RrRFQChiBwY/FGFvzJZ1L4HRy/I9rqTcw/PhbvfR+wSb0vO/1+3XvYSJeiIuHHl2CvwMaTf5j9TIRBKcGeyWwBMzmEg1v1SuuJUpMMg+i8auXEodFQM7w2mckAqa0luwTgH2NjH/DIWTsX0E
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(376002)(396003)(136003)(346002)(230922051799003)(1800799012)(186009)(64100799003)(82310400011)(451199024)(46966006)(36840700001)(40470700004)(356005)(54906003)(316002)(4326008)(8936002)(8676002)(86362001)(5660300002)(70586007)(110136005)(70206006)(2906002)(41300700001)(2616005)(1076003)(36756003)(2876002)(47076005)(82740400003)(6666004)(478600001)(36860700001)(7636003)(966005)(336012)(26005)(83380400001)(7696005)(426003)(40460700003)(84970400001)(40480700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2024 21:15:34.1433
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e4254d6-7ff1-48b9-d25a-08dc160f1cc3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA51.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6430

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

Applied over v6.7-rc8.

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
Signed-off-by: Aniket Agashe <aniketa@nvidia.com>
Tested-by: Ankit Agrawal <ankita@nvidia.com>
---
Link for variant driver v15:
https://lore.kernel.org/all/20231217191031.19476-1-ankita@nvidia.com/

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
  vfio/pci: implement range_intesect_range to determine range overlap
  vfio/nvgrace-gpu: Add vfio pci variant module for grace hopper

 MAINTAINERS                                   |   6 +
 drivers/vfio/pci/Kconfig                      |   2 +
 drivers/vfio/pci/Makefile                     |   2 +
 drivers/vfio/pci/nvgrace-gpu/Kconfig          |  10 +
 drivers/vfio/pci/nvgrace-gpu/Makefile         |   3 +
 drivers/vfio/pci/nvgrace-gpu/main.c           | 760 ++++++++++++++++++
 .../pci/nvgrace-gpu/nvgrace_gpu_vfio_pci.h    |  50 ++
 drivers/vfio/pci/vfio_pci_config.c            |  28 +
 drivers/vfio/pci/vfio_pci_rdwr.c              |  16 +-
 include/linux/vfio_pci_core.h                 |   9 +
 10 files changed, 879 insertions(+), 7 deletions(-)
 create mode 100644 drivers/vfio/pci/nvgrace-gpu/Kconfig
 create mode 100644 drivers/vfio/pci/nvgrace-gpu/Makefile
 create mode 100644 drivers/vfio/pci/nvgrace-gpu/main.c
 create mode 100644 drivers/vfio/pci/nvgrace-gpu/nvgrace_gpu_vfio_pci.h

-- 
2.34.1


