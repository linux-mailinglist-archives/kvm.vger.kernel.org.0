Return-Path: <kvm+bounces-8850-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EBBB98573E0
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 04:02:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ABB4928178D
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 03:02:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14006FC01;
	Fri, 16 Feb 2024 03:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Uj45MPcC"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2042.outbound.protection.outlook.com [40.107.94.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160CBDF6B;
	Fri, 16 Feb 2024 03:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708052514; cv=fail; b=eCUDdU+P00aQWYUX/JCqOvSMQAKtFBFmNEjkmbFHQZGGJlygZ1tJSJtZkqpnGymjJj81msL+f1moevNVgwr/ksguT4ApdxGDFWEb5TaMlCPBMtGQWit4+LjVZq3vYCbWXouoHXxpKRlU3/mbEfxn6u8zr0c2+ospoTkDJ0QMvHE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708052514; c=relaxed/simple;
	bh=RDuhbyCRwa3SdzyVvNhh3YxBHMiKc7u8d2h0ClleMUg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Neuk0+mY1gUIWcqJ6Dk5GfQUXKRMTc/EromBAIoPlPM4VWzuskRhgseVSlDden7p8czstTUuc2ZirbsZJ7DrA2exdB6cYp1aqaOFqOPq8MRTR7ez34XV4X8o09xwotu0QnhcSoo/qOd9G5AaWqS4Tu8fmKDOoxGysIrowEv2xJw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Uj45MPcC; arc=fail smtp.client-ip=40.107.94.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GgbWAeJM+V3LHqi2yXKJAdsvWB2RmKaooC/BTNGytn+R6Xww860vDuNqIe/GRBIwg19aeg7ir2XpQSN8lvSKA8hMvNbHRK+0wZF+4zBSOVYd9Hyv6ghb9/QGU3pl/PLsyJxNmnRpYFHJzj6dqcM9Syf0Z74DYZTa5kvuSZGUBAWkVEt5ZDVqVqHJOx1Y7egoEdtVQGZpcL+7+63z4nl9KSLSAb4hyvP//S1ZzHcH2cxd5Mrtmp2J9gQCGtzkK5gFVpCh/RTH9od9OHBT3iEVmqTmv7XPmDoT3T7XTLZPOagICB18xmH2AwIfuGvcL8LL5MTvAH6tAwD8ff8dIR4VlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YO5QdaOYt2qsNi9DPVB8p/KIRIi4hdwNIKrx6y7gp9A=;
 b=az5MGu2SO4gAJUvVUtp7XmX58aHlHdXcIpD5CsUmsvJyaH0noE2fVo4rINxTWOigbKDemXduudm7Ph4xE0Wmf3ETZbJWmSTWQEvX1b3HFiJZHG5jQFw3axkv6/R+QDZkxkDKiTmWks+CtCTbAy3fA7NAJ3P9LMQDVQJ6OtFK4/ILTnR/kaIyqIpnKVcCNd1AUGE3YHktWTVocqRP30XhXMJ7m44KhgeU5IgwjrNJN1LfpxVij7TPePQCdNpILXUVDzjuCc8kzLbbU3XlPEsEOCtR0ykMMBe5iTZDUdSnVH485kExexAfdERMWN0OnEo18vlauGKK/he2THkaq5ydgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YO5QdaOYt2qsNi9DPVB8p/KIRIi4hdwNIKrx6y7gp9A=;
 b=Uj45MPcCrQN1pzI52Cyi+L190VaOqhj1Ro0IJGE+51sx67KB5ErwTuCXq4ctLoqgxJRnljfvbhC6cnArFSBkxznq/PBmsp05zdtEekX6G7YGBhW+NvZZFmkdD1+fDh7/Xi2jTUzO35tiAQHqjN2sKcg6YGQwmsNHqOHmOktPkaeiKu+FRqABOOS+AYy58caH4IMCSI3tQsXMyI5J1lAwtFtyaVSLZ5j9GNty+Qofdxrhx89dHYo+IYQ+KIN9JJoOCdgKC7L/o9lBZ9uxNJXJY+kIl4xpobbqJXGiI/CVL/QB7zipTOtA7sbc0YG8hxMrTzXZyZz+0JrAnmn+Fd232A==
Received: from BN7PR06CA0053.namprd06.prod.outlook.com (2603:10b6:408:34::30)
 by CH3PR12MB7546.namprd12.prod.outlook.com (2603:10b6:610:149::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.28; Fri, 16 Feb
 2024 03:01:46 +0000
Received: from BN3PEPF0000B06C.namprd21.prod.outlook.com
 (2603:10b6:408:34:cafe::47) by BN7PR06CA0053.outlook.office365.com
 (2603:10b6:408:34::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.26 via Frontend
 Transport; Fri, 16 Feb 2024 03:01:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN3PEPF0000B06C.mail.protection.outlook.com (10.167.243.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7316.0 via Frontend Transport; Fri, 16 Feb 2024 03:01:46 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 15 Feb
 2024 19:01:38 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.12; Thu, 15 Feb 2024 19:01:37 -0800
Received: from sgarnayak-dt.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12 via Frontend
 Transport; Thu, 15 Feb 2024 19:01:30 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>,
	<yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
	<kevin.tian@intel.com>, <mst@redhat.com>, <eric.auger@redhat.com>,
	<jgg@ziepe.ca>, <oleksandr@natalenko.name>, <clg@redhat.com>,
	<satyanarayana.k.v.p@intel.com>, <brett.creeley@amd.com>, <horms@kernel.org>,
	<shannon.nelson@amd.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<anuaggarwal@nvidia.com>, <mochs@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <virtualization@lists.linux-foundation.org>
Subject: [PATCH v18 0/3] vfio/nvgrace-gpu: Add vfio pci variant module for grace hopper
Date: Fri, 16 Feb 2024 08:31:25 +0530
Message-ID: <20240216030128.29154-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B06C:EE_|CH3PR12MB7546:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f3283ec-2a42-4cbb-4796-08dc2e9b9cdb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	/8o0naWWPNlYF1Wkjj7vjhwmvA11sBtHprAwjt1UcoSh/yrQFxEmS61jc5TT/6f+szxz/5qbpPKNudL32Kp3Ndop0/b2iPWjbR/BVGYWJjHItWLfTEEGlSa6I224IzGFWkfpNcqXS396MKqoG82UTM2rAo1Br04Bn8L/xmUmrrkZQ2KmL26ZdLnDp3nEa74KNdhli6W1/InWOVgHYhZaisJwvnukFN1wIgi0Mhyst+WUFECBr8rknW0TMxs80fIMnuXsq6tkuOTejz/QeLKPBM2M0zEF3rS0BAcv0LWbqDeufT2fU2o1cJA6xypOJgZnRbe2xzi8srmBX9doMxO2PChfr2UgHgy3kSZtR+HvM6ViBaAIULM5U9ZYAVF8koMzA2W12yHiZT2VhTllj6HUEHfFfhM1V9KN68A1AQe6npZLuJ6g257RJT3kHh0LqmEfY4k24oA6zEc2ZyxtQt+ja5M6xBAUHN/Wv3Kq50mKmWioCQO9fu/wefFomr3RFwsQMFNl4OxWATnH+2U6mU1DWsbr1tsG7l2rAMQXGaVta5YjkyDLhpC/ktZ/SafJPKbFCSehndYuewcODZlSQA6u/7RouUUGgnkP5clQS3c/o3aG5Iq87wY6M5e98IY7lOWFSSrZ50GmsIECqERahHPse4n4zLMhSczZ0eFC9izjM/ce30QdpMDSvIu5UyczCJGHNwGQtRl5ba+huHsNilcwcQ==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(346002)(39860400002)(136003)(376002)(230922051799003)(36860700004)(186009)(82310400011)(451199024)(1800799012)(64100799003)(40470700004)(46966006)(2616005)(41300700001)(966005)(7696005)(478600001)(2876002)(70206006)(6666004)(7416002)(5660300002)(30864003)(4326008)(8676002)(8936002)(70586007)(2906002)(86362001)(316002)(26005)(1076003)(336012)(83380400001)(921011)(110136005)(36756003)(82740400003)(54906003)(426003)(7636003)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2024 03:01:46.4161
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f3283ec-2a42-4cbb-4796-08dc2e9b9cdb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B06C.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7546

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

Applied over v6.8-rc4.

Signed-off-by: Aniket Agashe <aniketa@nvidia.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
Link for variant driver v17:
https://lore.kernel.org/all/20240205230123.18981-1-ankita@nvidia.com/

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
 drivers/vfio/pci/nvgrace-gpu/main.c   | 888 ++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_config.c    |  42 ++
 drivers/vfio/pci/vfio_pci_rdwr.c      |  16 +-
 drivers/vfio/pci/virtio/main.c        |  72 +--
 include/linux/vfio_pci_core.h         |  10 +-
 10 files changed, 1002 insertions(+), 59 deletions(-)
 create mode 100644 drivers/vfio/pci/nvgrace-gpu/Kconfig
 create mode 100644 drivers/vfio/pci/nvgrace-gpu/Makefile
 create mode 100644 drivers/vfio/pci/nvgrace-gpu/main.c

-- 
2.34.1


