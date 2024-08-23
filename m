Return-Path: <kvm+bounces-24896-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A47B995CDB2
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 15:22:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 285AB1F23B70
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 13:22:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45FEE186614;
	Fri, 23 Aug 2024 13:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="g4uWS22I"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2051.outbound.protection.outlook.com [40.107.244.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 709FC185945;
	Fri, 23 Aug 2024 13:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724419351; cv=fail; b=gHoBQZ0gVU9JJgRmekbOru7BolMpBBRRVuDVLQld3t0axhcFfEmomCj6lp73wk9jhJCi8IxpnSOyhmZgYIjgC7K8pT93//TdLJ5M9wiQ3Qwap0IcvCkR5G0wbwSsXP89xO+QhJ5BWb2TRLbuZiaiRkIJt7pfSJaNByZIpbhNeX0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724419351; c=relaxed/simple;
	bh=HzR/W54r+UEKEx0r/Q3Ovw/s7/B4bymeu4G9O5RVKo4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=mQgzztwrcv5diUFGcvxQO+kWVG4+6Jc12GYEGlmJ24SYVZAcmVJ6wkpiQO7wrT8StY86GgGngURMWCjvxye6wOzYW14ZattJ1nrrhq93PPtKka9hI4Ku2zsTQ8svZ00AnaOF7butvwExNjuwGl2i7d8Yf4LzuszyHf9WYuM81nw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=g4uWS22I; arc=fail smtp.client-ip=40.107.244.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FX+Hru8ozoLH52/IoXOaY5fHaApJ5dnuRj7pim3M9apRDr1Tjnh6W9T897r9gKPZqufxiY8F8uoACSQQ/WB8o3up3e3X39txcbQtRzhMFOhsyS0d5rKomnih228haRCgBbzO5eH8+f/ZjZR/v9LQH9ke7lH73oSrp0uWSOxEndsqR58lnLro14wnLsIQoXLEW5vYRBEv+kZb4tcTKU+gZ2Z7ah8kOJ4JSyqeKYrg4SBJpJWo9zQg+qGAz12YWDp42nR4E82pDv+QPnvzzdodlHaITf3t394JXkjSBroLYuzWsHTywOT0wSmhnCYoB2mfYuQSIV79xCrt11CuZn3jGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7cqd6k/wXRGPWsOXzGc+MnQBwq1gP2wSLw6YIq9QOFA=;
 b=HDnLW3kRga9sAkQ0ghBDtCnhEOmrPjJF+/7Y0VIocKxqehOOJmVczNTu6krjZRULCGu8UT7byrFaT4Zbp6Elg6cYoK3r/7RyC5idRQvdpgkz0ipNZT2u9z9vfAbOTzBBpK7XPJ/G1dX6pqm3fCmXm4P8Vt1VRtYbiaJztIHeXaTG210JXjoY28BIRuwlcQbC63ZLkDznEcx+cF6knif0aFmDWf5x8p+FoxOYAjm6igA6dkpMj8lm4z5CX6kBp0R8ECZpRVRXh/TyZsVxP1i/T0Y+EsRbWFx1D6ifCOGv+tJ72WSxiuXBQ+j1oQNU3e8DK2FemChVHlCuyVpcE1mQlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7cqd6k/wXRGPWsOXzGc+MnQBwq1gP2wSLw6YIq9QOFA=;
 b=g4uWS22I/g3RIrJdYk1BMBlDrXGvzydBN/m2WjQGQ5NU4gFCOqIyK71WDQGFb8CHmMX0X4eDZEydoMZKQjZL5HOTHGihowNLeOPa20d7/Rbc5/gbk4bRRCag/A9H/PwbijMa47NrkoSl9Phpy0kX38YNxsPieCzcpF9jGfnGqsQ=
Received: from CH0PR03CA0098.namprd03.prod.outlook.com (2603:10b6:610:cd::13)
 by IA0PR12MB8984.namprd12.prod.outlook.com (2603:10b6:208:492::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.19; Fri, 23 Aug
 2024 13:22:24 +0000
Received: from CH1PEPF0000AD77.namprd04.prod.outlook.com
 (2603:10b6:610:cd:cafe::54) by CH0PR03CA0098.outlook.office365.com
 (2603:10b6:610:cd::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.19 via Frontend
 Transport; Fri, 23 Aug 2024 13:22:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000AD77.mail.protection.outlook.com (10.167.244.55) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7897.11 via Frontend Transport; Fri, 23 Aug 2024 13:22:23 +0000
Received: from aiemdee.2.ozlabs.ru (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 23 Aug
 2024 08:22:16 -0500
From: Alexey Kardashevskiy <aik@amd.com>
To: <kvm@vger.kernel.org>
CC: <iommu@lists.linux.dev>, <linux-coco@lists.linux.dev>,
	<linux-pci@vger.kernel.org>, Suravee Suthikulpanit
	<suravee.suthikulpanit@amd.com>, Alex Williamson
	<alex.williamson@redhat.com>, Dan Williams <dan.j.williams@intel.com>,
	<pratikrajesh.sampat@amd.com>, <michael.day@amd.com>, <david.kaplan@amd.com>,
	<dhaval.giani@amd.com>, Santosh Shukla <santosh.shukla@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, "Alexander
 Graf" <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>, Vasant Hegde
	<vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>, Alexey Kardashevskiy
	<aik@amd.com>
Subject: [RFC PATCH 00/21] Secure VFIO, TDISP, SEV TIO
Date: Fri, 23 Aug 2024 23:21:14 +1000
Message-ID: <20240823132137.336874-1-aik@amd.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD77:EE_|IA0PR12MB8984:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b2b022b-805f-42bc-9780-08dcc376a017
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WR2adH6BKAwAfOZWmE6Ujn7KG08CouzAD+i3N9/uuJiA9eAxlf6WqMZgr2Gi?=
 =?us-ascii?Q?HgKFJnmzgW1BSuHYjqeuEdBHlumiIrx4y0RFhfhga1x+zGdRxwmGFBf7HDe/?=
 =?us-ascii?Q?piVz4QqDGZQjisXtECYLuCydhDatUWudtz01j3UIQM+DLSgCE6rsNYN9N3Jv?=
 =?us-ascii?Q?nAvb863LvkXMpjkSLe4Xs4g/G6z1ZIwIDBFXczr/N1IEk3O/s8kODcJs7mtV?=
 =?us-ascii?Q?CL2f3CB/pNwMR/9QvjC7mAXEjUEVpMFqC0fjsqvtgL2xAzH+zHt5gU1FRfMN?=
 =?us-ascii?Q?+bm5JR0MHRimtFACOVv+ZAm0IVbyxWY5tvk74rhbvOkUoJnLmZ/r7Bl0DYkS?=
 =?us-ascii?Q?r7mDTATPVs9Fxxr1nmPGCHzAPkvmYiMaSz45pnWQTGpGPQWyYmwO6zwhZIVR?=
 =?us-ascii?Q?oB+Cthd4iSy/GHHXVnySlyzuvKYYgKYvSmF04tAjubkcYl4FsHK5e16JxE6K?=
 =?us-ascii?Q?HGYVD5vHR4FKtTl5pgiAuAHn/NCxBWPRwIMYjPH1sFsFzzBlgHUn75xXJ01f?=
 =?us-ascii?Q?JBMDCQ+pc7ofaqdhocZXRauoPUJ8RcOGmUSYdTZdpMPbIr6k2qOkJ6Y8VHaw?=
 =?us-ascii?Q?W0Wl4KSyMz3fMDDAtZIvCZJXHw9SFIEjiHzwUSkjKcOso5msUsGdtCGKXia7?=
 =?us-ascii?Q?SkHKq+FrIRdZ4tN9seZHgtNVABjyvrYSJx+HgBFcXAJBAdtgPLirHlvxgyDN?=
 =?us-ascii?Q?kxlZvWtFHpduE1iqJxWzt+WU25FFdKbjpC/KAlt401AjIJd7RXlhnTzwfyRZ?=
 =?us-ascii?Q?O5QVM1jLVkv9FX1DGg2kQDksnr1UpJDDYs6dptsYEDFOHvb/a/h0dE1mNIyA?=
 =?us-ascii?Q?4QjZQESWUpBnpqTfWGIMZTMBe9Me4BVKJQE3pFolqwOPZ7J8XAzJ/19HhE01?=
 =?us-ascii?Q?6gYgJqvpCgB3XHPDK8ehB189vJt/eE70lwLpwhoWZpCIseTLc7/QbaQdHDex?=
 =?us-ascii?Q?/XtgK598i3tp4Fnvyr4wnbopnqf6zhblUqmrzHG/XwP5/g+L7dXv+eCL/8eY?=
 =?us-ascii?Q?25p+RGme4HAkdqtuNFUVaKqgHQQKVW0Z+TMmuTrk7g3V6H/PiZnSlrFGpqUG?=
 =?us-ascii?Q?O9gt/NDDJpIBYcB7Rh6REwmydhIoXGu4ouaYieD+LWN7iq2QlgBCd2h15kEC?=
 =?us-ascii?Q?icVPkYrOIYN6ZWyuwYXyW79zOj7GHWf/725wDOAc24D+Ra9FKTq/6LyVGWNT?=
 =?us-ascii?Q?/GJJCeqUjkQE5uyqnZ3XBvGgY02nwl1oOlfeG9RbqsHbKJW8tzX1anrAiTlX?=
 =?us-ascii?Q?5IBsQ6IQ9Q1mPz5aYt4KgpAWjrJa8/bDsgGLGlQUMJMWiEoc8Ly7T5XHBNhy?=
 =?us-ascii?Q?CstF8d8jGvBPO782ug7Jh3TlJOlnhCKqHRAuGhyvY+AlCrI1I3Gtnpx57APh?=
 =?us-ascii?Q?jlwWh8l0Q0RNLTGjBuwJoIuO9gEvxwgPEw6dVw8mWOVLtJgRag=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2024 13:22:23.8444
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b2b022b-805f-42bc-9780-08dcc376a017
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD77.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8984

Hi everyone,

Here are some patches to enable SEV-TIO (aka TDISP, aka secure VFIO)
on AMD Turin.

The basic idea is to allow DMA to/from encrypted memory of SNP VMs and
secure MMIO in SNP VMs (i.e. with Cbit set) as well.

These include both guest and host support. QEMU also requires
some patches, links below.

The patches are organized as:
01..06 - preparing the host OS;
07 - new TSM module;
08 - add PSP SEV TIO ABI (IDE should start working at this point);
09..14 - add KVM support (TDI binding, MMIO faulting, etc);
15..19 - guest changes (the rest of SEV TIO ABI, DMA, secure MMIO).
20, 21 - some helpers for guest OS to use encrypted MMIO

This is based on a merge of
ee3248f9f8d6 Lukas Wunner spdm: Allow control of next requester nonce
through sysfs
85ef1ac03941 (AMDESE/snp-host-latest) 4 days ago Michael Roth [TEMP] KVM: guest_memfd: Update gmem_prep are hook to handle partially-allocated folios


Please comment. Thanks.

Thanks,


SEV TIO tree prototype
======================

Goal
----

Support secure PCI devices pass through to confidential VMs.
The support is defined by PCIe 6, SPDM, TDISP (not AMD) and SEV TIO
specification (by AMD).

SEV TIO spec:
https://www.amd.com/content/dam/amd/en/documents/epyc-technical-docs/specifications/58271_0_70.pdf
Whitepaper:
https://www.amd.com/content/dam/amd/en/documents/epyc-business-docs/white-papers/sev-tio-whitepaper.pdf
GHCB spec update is coming.

The changeset adds:
- a generic TSM.ko module;
makes necessary changes to:
- ccp (interface to AMD secure platform processor, "PSP", works on the
host),
- sev-guest (interace to PSP for confidential SNP guest),
- kvm_amd,
- memfd,
- vfio kvm device,
- kvm-x86.

Acronyms
--------

TEE - Trusted Execution Environments, a concept of managing trust
between the host
and devices
TSM - TEE Security Manager (TSM), an entity which ensures
security on the host
PSP - AMD platform secure processor (also "ASP", "AMD-SP"), acts
as TSM on AMD.
SEV TIO - the TIO protocol implemented by the PSP and used by
the host
GHCB - guest/host communication block - a protocol for
guest-to-host communication
via a shared page

CMA, IDE, TDISP,
TVM, DSM, SPDM, DOE

Code
----

Written with AMD SEV SNP in mind, TSM is the PSP and
therefore no much of IDE/TDISP
is left for the host or guest OS.

Add a common module to expose various data objects in
the same way in host and
guest OS.

Provide a know on the host to enable IDE encryption.

Add another version of Guest Request for secure
guest<->PSP communication.

Enable secure DMA by:
- configuring vTOM in a secure DTE via the PSP to cover
the entire guest RAM;
- mapping all private memory pages in IOMMU just like
as they were shared
(requires hacking iommufd);
- skipping various enforcements of non-SME or
SWIOTLB in the guest;

No mixed share+private DMA supported within the
same IOMMU.

Enable secure MMIO by:
- configuring RMP entries via the PSP;
- adding necessary helpers for mapping MMIO with
the Cbit set;
- hacking the KVM #PF handler to allow private
MMIO failts.

Based on the latest upstream KVM (at the
moment it is kvm-coco-queue).


Workflow
--------

1. Boot host OS.
2. "Connect" the physical device.
3. Bind a VF to VFIO-PCI.
4. Run QEMU _without_ the device yet.
5. Hotplug the VF to the VM.
6. (if not already) Load the device driver.
7. Right after the BusMaster is enabled,
tsm.ko performs secure DMA and MMIO setup.
8. Run tests, for example:
sudo ./pcimem/pcimem
/sys/bus/pci/devices/0000\:01\:00.0/resource4_enc
0 w*4 0xabcd


Assumptions
-----------

This requires hotpligging into the VM vs
passing the device via the command line as
VFIO maps all guest memory as the device init
step which is too soon as
SNP LAUNCH UPDATE happens later and will fail
if VFIO maps private memory before that.

This requires the BME hack as MMIO and
BusMaster enable bits cannot be 0 after MMIO
validation is done and there are moments in
the guest OS booting process when this
appens.

SVSM could help addressing these (not
implemented at the moment).

QEMU advertises TEE-IO capability to the VM.
An additional x-tio flag is added to
vfio-pci.


TODOs
-----

Deal with PCI reset. Hot unplug+plug? Power
states too.

Do better generalization, the current code
heavily uses SEV TIO defined
structures in supposedly generic code.

Fix the documentation comments of SEV TIO structures.


Git trees
---------

https://github.com/AMDESE/linux-kvm/tree/tio
https://github.com/AMDESE/qemu/tree/tio




Alexey Kardashevskiy (21):
  tsm-report: Rename module to reflect what it does
  pci/doe: Define protocol types and make those public
  pci: Define TEE-IO bit in PCIe device capabilities
  PCI/IDE: Define Integrity and Data Encryption (IDE) extended
    capability
  crypto/ccp: Make some SEV helpers public
  crypto: ccp: Enable SEV-TIO feature in the PSP when supported
  pci/tdisp: Introduce tsm module
  crypto/ccp: Implement SEV TIO firmware interface
  kvm: Export kvm_vm_set_mem_attributes
  vfio: Export helper to get vfio_device from fd
  KVM: SEV: Add TIO VMGEXIT and bind TDI
  KVM: IOMMUFD: MEMFD: Map private pages
  KVM: X86: Handle private MMIO as shared
  RFC: iommu/iommufd/amd: Add IOMMU_HWPT_TRUSTED flag, tweak DTE's
    DomainID, IOTLB
  coco/sev-guest: Allow multiple source files in the driver
  coco/sev-guest: Make SEV-to-PSP request helpers public
  coco/sev-guest: Implement the guest side of things
  RFC: pci: Add BUS_NOTIFY_PCI_BUS_MASTER event
  sev-guest: Stop changing encrypted page state for TDISP devices
  pci: Allow encrypted MMIO mapping via sysfs
  pci: Define pci_iomap_range_encrypted

 drivers/crypto/ccp/Makefile                              |    2 +
 drivers/pci/Makefile                                     |    1 +
 drivers/virt/coco/Makefile                               |    3 +-
 drivers/virt/coco/sev-guest/Makefile                     |    1 +
 arch/x86/include/asm/kvm-x86-ops.h                       |    2 +
 arch/x86/include/asm/kvm_host.h                          |    2 +
 arch/x86/include/asm/sev.h                               |   23 +
 arch/x86/include/uapi/asm/svm.h                          |    2 +
 arch/x86/kvm/svm/svm.h                                   |    2 +
 drivers/crypto/ccp/sev-dev-tio.h                         |  105 ++
 drivers/crypto/ccp/sev-dev.h                             |    4 +
 drivers/iommu/amd/amd_iommu_types.h                      |    2 +
 drivers/iommu/iommufd/io_pagetable.h                     |    3 +
 drivers/iommu/iommufd/iommufd_private.h                  |    4 +
 drivers/virt/coco/sev-guest/sev-guest.h                  |   56 +
 include/asm-generic/pci_iomap.h                          |    4 +
 include/linux/device.h                                   |    5 +
 include/linux/device/bus.h                               |    3 +
 include/linux/dma-direct.h                               |    4 +
 include/linux/iommufd.h                                  |    6 +
 include/linux/kvm_host.h                                 |   70 +
 include/linux/pci-doe.h                                  |    4 +
 include/linux/pci-ide.h                                  |   18 +
 include/linux/pci.h                                      |    2 +-
 include/linux/psp-sev.h                                  |  116 +-
 include/linux/swiotlb.h                                  |    4 +
 include/linux/tsm-report.h                               |  113 ++
 include/linux/tsm.h                                      |  337 +++--
 include/linux/vfio.h                                     |    1 +
 include/uapi/linux/iommufd.h                             |    1 +
 include/uapi/linux/kvm.h                                 |   29 +
 include/uapi/linux/pci_regs.h                            |   77 +-
 include/uapi/linux/psp-sev.h                             |    4 +-
 arch/x86/coco/sev/core.c                                 |   11 +
 arch/x86/kvm/mmu/mmu.c                                   |    6 +-
 arch/x86/kvm/svm/sev.c                                   |  217 +++
 arch/x86/kvm/svm/svm.c                                   |    3 +
 arch/x86/kvm/x86.c                                       |   12 +
 arch/x86/mm/mem_encrypt.c                                |    5 +
 arch/x86/virt/svm/sev.c                                  |   23 +-
 drivers/crypto/ccp/sev-dev-tio.c                         | 1565 ++++++++++++++++++++
 drivers/crypto/ccp/sev-dev-tsm.c                         |  397 +++++
 drivers/crypto/ccp/sev-dev.c                             |   87 +-
 drivers/iommu/amd/iommu.c                                |   20 +-
 drivers/iommu/iommufd/hw_pagetable.c                     |    4 +
 drivers/iommu/iommufd/io_pagetable.c                     |    2 +
 drivers/iommu/iommufd/main.c                             |   21 +
 drivers/iommu/iommufd/pages.c                            |   94 +-
 drivers/pci/doe.c                                        |    2 -
 drivers/pci/ide.c                                        |  186 +++
 drivers/pci/iomap.c                                      |   24 +
 drivers/pci/mmap.c                                       |   11 +-
 drivers/pci/pci-sysfs.c                                  |   27 +-
 drivers/pci/pci.c                                        |    3 +
 drivers/pci/proc.c                                       |    2 +-
 drivers/vfio/vfio_main.c                                 |   13 +
 drivers/virt/coco/sev-guest/{sev-guest.c => sev_guest.c} |   68 +-
 drivers/virt/coco/sev-guest/sev_guest_tio.c              |  513 +++++++
 drivers/virt/coco/tdx-guest/tdx-guest.c                  |    8 +-
 drivers/virt/coco/tsm-report.c                           |  512 +++++++
 drivers/virt/coco/tsm.c                                  | 1542 ++++++++++++++-----
 virt/kvm/guest_memfd.c                                   |   40 +
 virt/kvm/kvm_main.c                                      |    4 +-
 virt/kvm/vfio.c                                          |  197 ++-
 Documentation/virt/coco/tsm.rst                          |   62 +
 MAINTAINERS                                              |    4 +-
 arch/x86/kvm/Kconfig                                     |    1 +
 drivers/pci/Kconfig                                      |    4 +
 drivers/virt/coco/Kconfig                                |   11 +
 69 files changed, 6163 insertions(+), 548 deletions(-)
 create mode 100644 drivers/crypto/ccp/sev-dev-tio.h
 create mode 100644 drivers/virt/coco/sev-guest/sev-guest.h
 create mode 100644 include/linux/pci-ide.h
 create mode 100644 include/linux/tsm-report.h
 create mode 100644 drivers/crypto/ccp/sev-dev-tio.c
 create mode 100644 drivers/crypto/ccp/sev-dev-tsm.c
 create mode 100644 drivers/pci/ide.c
 rename drivers/virt/coco/sev-guest/{sev-guest.c => sev_guest.c} (96%)
 create mode 100644 drivers/virt/coco/sev-guest/sev_guest_tio.c
 create mode 100644 drivers/virt/coco/tsm-report.c
 create mode 100644 Documentation/virt/coco/tsm.rst

-- 
2.45.2


