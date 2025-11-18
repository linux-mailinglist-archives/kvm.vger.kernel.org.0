Return-Path: <kvm+bounces-63530-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 62674C68C75
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 11:20:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 4EC804F1367
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 10:17:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DA5133F8AA;
	Tue, 18 Nov 2025 10:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="lmX7y8ol"
X-Original-To: kvm@vger.kernel.org
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012043.outbound.protection.outlook.com [52.101.48.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 710A733E372
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 10:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763460961; cv=fail; b=Qftr6GnBXPfbTiWmmII7P55pLPST3dK1faSlizuiRmtwLRKQoTy8vllSXDk7v8TLAoPTtrQpBNd7WgJj4Llqs0+XacfQl4n1D3ShtVEV9JmBoxdgAIkUkNKPsclI0K8BpDdGOz1JxyTRbvMHCS13D58ZUD2MMA6nClTpms/7qiI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763460961; c=relaxed/simple;
	bh=vQIaz49Y4VsLOI10UuMZNTSTHbcZtp0NlrxoRHlaEMI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=T2JEfvA/oO/AKOMmXvoc2m8tPaQbyhsPx6RETAg1hrkuf1UtYcV2ScLuu1112PGpnW3F0uyZCOnJiGnK+VGr6hrRGoGx7NF7lg3nbpohvRai6bzEAiVQMQm3a91CIww6FOXQBU0MaIe8Ac1v80rhXJtnwSHO9Ee9sC7nO+drkQ8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=lmX7y8ol; arc=fail smtp.client-ip=52.101.48.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IVhTTk6RAQdR7fB+K9o7iNKjhAFzsd6ZcU9Pqn6NV7FKC+FXGO9shXwGMUmBBkLwOgOX8hh93ARV1KwTpdPNK48zw8bg6at5yZp8kULsBVSe3XEJ4QVYQzDS9/ajsFQ1C19D52lWXQRcNZ1B5/dNV0zcrCExo236Tuqc1zqBkqVAdXp7yXVwUnA6BFHv3jxWA7f5tv1AYQchVloIG1VQ64RSSf7kOXypdzgSkdqoBapBv0aLqR8hFyYpN8MgyGOlVqOegJMhjMXbDKafcRAaPwNs+UObd3JdaL6pZN958FV2/pO96BTZmUZrWAROuVSVLdtKotBiEVc61Q45Ly7V7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VD+XLOIYqHMFDAuYsUNBc6y8QNRjnNI/gCc7eF7sO6I=;
 b=tdMwv6Ppk7b69PakQhV5NxyWSh92burz1RjfyY44A329IY6OMXx882WBRJg+xksZ0S3tCqNkeOd809zCR0LKZdLMTJn5RocYemoLXlUVCcHBYHxxJQQpcERxCf8Ew7LqHPLVEs2A7Udr1/C1E4lMc1UDuZqoyL7J6uA+9dPXzVO/GaR4eEiPo/BMNnn/VkhYuGFgcKQeDdUZM8l1LHYVjo0K8yBwWasaY2c3iQtWQ9yKNJQD2yyBnDq/j6K/f3Q8JuWr4ZUNQyafOpXj0vGxke9HhOxs2O2B1dqBs/JQ2Bwjk4q2MhCZSdgTMDcY1WeuCmA8ypoHo5Fw3YDJ3cxH3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VD+XLOIYqHMFDAuYsUNBc6y8QNRjnNI/gCc7eF7sO6I=;
 b=lmX7y8olYtG/tHbY9ahio/ONMqq2NGfmmNt/KIfaNBh/Sshq92YcSQKTKPENVw+zzCyrRyGREm5tOgcvibp1qSTFSXWcZNkmr6wdUbhmnQ/QIOurqXUP/eL9DDhu+1frHSeFc7wrhYBzvBj3MA1Zjps5QNfE8p8a6omR3pIf7+E=
Received: from MW4PR04CA0357.namprd04.prod.outlook.com (2603:10b6:303:8a::32)
 by SA1PR12MB8093.namprd12.prod.outlook.com (2603:10b6:806:335::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Tue, 18 Nov
 2025 10:15:53 +0000
Received: from SJ1PEPF00002312.namprd03.prod.outlook.com
 (2603:10b6:303:8a:cafe::6f) by MW4PR04CA0357.outlook.office365.com
 (2603:10b6:303:8a::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.10 via Frontend Transport; Tue,
 18 Nov 2025 10:15:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00002312.mail.protection.outlook.com (10.167.242.166) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.9 via Frontend Transport; Tue, 18 Nov 2025 10:15:52 +0000
Received: from BLR-L1-SARUNKOD.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 18 Nov
 2025 02:15:46 -0800
From: Sairaj Kodilkar <sarunkod@amd.com>
To: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
	<alejandro.j.jimenez@oracle.com>, <vasant.hegde@amd.com>,
	<suravee.suthikulpanit@amd.com>
CC: <mst@redhat.com>, <imammedo@redhat.com>, <anisinha@redhat.com>,
	<marcel.apfelbaum@gmail.com>, <pbonzini@redhat.com>,
	<richard.henderson@linaro.org>, <eduardo@habkost.net>, <yi.l.liu@intel.com>,
	<eric.auger@redhat.com>, <zhenzhong.duan@intel.com>, <cohuck@redhat.com>,
	<seanjc@google.com>, <iommu@lists.linux.dev>, <kevin.tian@intel.com>,
	<joro@8bytes.org>, Sairaj Kodilkar <sarunkod@amd.com>
Subject: [RFC PATCH RESEND 0/5] amd_iommu: support up to 2048 MSI vectors per IRT
Date: Tue, 18 Nov 2025 15:45:27 +0530
Message-ID: <20251118101532.4315-1-sarunkod@amd.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002312:EE_|SA1PR12MB8093:EE_
X-MS-Office365-Filtering-Correlation-Id: e40957e9-0e10-4d09-f672-08de268b7441
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014|7416014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NXhYUjV3dzlqb2lWRXpETi9ma1crOTc3dGROWm03c0tQNEhrSVZkZkptUjdD?=
 =?utf-8?B?Y1l4QjRjMDArd1lqbmQxcEhUU3lZeWE2K1Rna1VWQm51aVArVm1RYmRVYUlO?=
 =?utf-8?B?cHBkRTc0UFNVMER3S0s0WWpTbzI1Z2xGR2ZDSDN4ZmtuODZYQXRqZXcrL2Vq?=
 =?utf-8?B?eFJzdmpRd1crVUUzUzcrZ2d2NGRVc3RLNFhYRDVTNnQ4cXg1cmJIZVJXMzNj?=
 =?utf-8?B?dml2b2hMcVorMGFVcXpDK3gyVm5lOWlYNzNRazRhSlJtR2dQaC9EUlNsZXVD?=
 =?utf-8?B?cUZkVGNCTmh3YjdaMXFBaEU3Q1phQjBtMllKYTBJeXhEcEFhVTVyWE5Rd0pw?=
 =?utf-8?B?MnVZbUZrMzYxRG8wUHdncHlLL1EzR1M1cDhaOWdvWlBGVFh3SVpEWjU0YzJy?=
 =?utf-8?B?T2JORlNVQWlJWWdnNFFXK3E4ckFwbi9WWm9yblkyZjJaS3owMzJjaXFTc1JQ?=
 =?utf-8?B?UUdMZTNQNmZXSno3eUxjTElsZGQ1T2hDN1VTZkdIKzh3d0t6SkJUeVFxeENM?=
 =?utf-8?B?UStBeGJ0YkRoemMxNURqaEF1TFJ1VWZkcDhUSXl3NVhNZ094RlNxM0tKOTl3?=
 =?utf-8?B?Q0hVSXVhZkcvYmJyYWZvbUZiOWJyTDgyTEFKRSswMWh6RDVGYUNxVllaYVgr?=
 =?utf-8?B?ZUhQMGsrU0l4akhPY2RRVU9CMUFjbWREK3JHN2ducmhNS2t0eXJCZE9Pd1pR?=
 =?utf-8?B?OW9pZnRYa3BuUkZTRGVjTm9saUl2b2dZaXVvZkw0dkZuM1drYXpob0VneFRE?=
 =?utf-8?B?d1RCbmlzdGtROXRxcUtBZjNFR1FpRERxejFqbUlKUnpVY2laaFN4cDBhSU15?=
 =?utf-8?B?QUdFYUdVY2QvVXpZRGtnajRuZ3JLSW9iMEl0K3NZLzlwcGZ4Ukl2eGRkY1RB?=
 =?utf-8?B?TzNrcTBKakR4Q1ZTSDByZXNiUXlTZThhbWY5NXN4M2E4Um9GUjh0bWFpb0NL?=
 =?utf-8?B?WUlZWTFUbmVrT290NTh1b1Y4SmEvMitwUnN5SXZzbjd2cVJLVCtuUjJlZEJF?=
 =?utf-8?B?M25iUE5YL2JGVWJRUkZIVVF2VkdzSVl4NjFUeFcxb1JaWllRdGxEOWpVR2Ru?=
 =?utf-8?B?c3d0OCtVbEJPeVF3S1JrTDd3Q0NaN2poNFZpWGpCREMyenZOR3RORGxLOFdP?=
 =?utf-8?B?NCtWSDRodmlQSkVHaDFPU0UxUlM5bUtpbnBUdzE4WE1JV3RBSGVpZHZrOHRj?=
 =?utf-8?B?WWJOcHpoSkhBVVRXMm91Yk1iOWNmdnVxTHh2TnZvclhSNU9LdDNuRUpsYVlR?=
 =?utf-8?B?d2xkNUFTbStnMlFVc0docFEzNVJwbm5NL09qS0JzOVpXa0JVNm5nZGVvdHhH?=
 =?utf-8?B?aURQdWRZcEgxVmlkdWxGZVp1SUpRSXI3bmd1ck9SV0U4Ni9MVkthTlI1L3lt?=
 =?utf-8?B?L1RIZHZxcEtDZ1dmQk9MSW81RVBObERHY0t0RkJpbGw1STNIZDk4RVNiSlNV?=
 =?utf-8?B?YTNidVVEVmY5NHptb2ZCMGtsaGp5YWNTMCttR21raVRBc0RKSUQ1UmlEZzAx?=
 =?utf-8?B?TnRqcFRPSkpkWFNvWnNlbUlXb25PdG91NXhidGRTYTJrckNqTzZjM242a28y?=
 =?utf-8?B?TFFsZ2NRbUZrejNscndYc2hnUC9wSVAwSzV3Zy9NUDlIUXNYSGVPVU5oTTBz?=
 =?utf-8?B?SlhaeVBpRlhKcXYxbk4rSThPOU9TQmZMS0RtWC9GaU84R3IwMndtK1k2bXhX?=
 =?utf-8?B?Vmx6NlkvTGZXZ2JmY2w3SHVtMXFwVnp3c1hZcFFUY3dTMkN3S2FJdk4zYnNv?=
 =?utf-8?B?b1lDamY5dEhLUDFpbHRIZFhrMEZuY0t4VW5DdEJUeFJPODZ2dERacDVCUHln?=
 =?utf-8?B?azM5bEdNb1cxYlVld0cvaVdIYzVlMmhZMytKdTROTmlNMXJQUmZxTjFCMnRI?=
 =?utf-8?B?eUxVcXd5NjQ1UlBWOC9GR3AzdXdub095RjhqYm5aZFhzVFVWb3kyblZBbmlz?=
 =?utf-8?B?UHlqd3lWTDcwS2wrSytuRXN4RGhqZnJLcWhjS3RkNVVyUkV5WEg1TUpIUWlm?=
 =?utf-8?B?Qnd4NFVDQ1hxZUlzQXY3TlAvOHZHTGdZL0lqb09IWk5qVkE0ajdpU3VNelVi?=
 =?utf-8?B?YW9TWkd6YXpzejFaZ3U4SCsraWpwZnAxV25kVGlYbzZpbzQvSVRlc3l0dTl5?=
 =?utf-8?Q?gsS4=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014)(7416014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2025 10:15:52.4619
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e40957e9-0e10-4d09-f672-08de268b7441
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002312.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8093

Resending this series with KVM and IOMMU maintainers in CC.

AMD IOMMU can route upto 2048 MSI vectors through a single
Interrupt Remapping Table (IRT) entry. This series brings the same
capability to the emulated AMD IOMMU in QEMU.

Highlights
----------
* Sets bits [9:8] in Extended-Feature-Register-2 to advertise 2K MSI
  support to the guest.
* Uses bits [10:0] of the MSI data to select the IRTE when the guest
  programs MSIs in logical-destination mode.
* Introduces a new IOMMU device property:
        -device amd-iommu,...,numint2k=on

  The feature is **opt-in**; guests keep the 512-MSI behaviour unless
  `numint2k=on` is supplied.

Passthrough devices
-------------------
When a PCI function is passed through via iommufd the code checks the
host’s vendor capabilities.  If the host IOMMU has not enabled
2K-MSI support (bits [44:43] set in the control register) the guest
feature is disabled even if `numint2k=on` was requested.

The detection logic relies on the iommufd interface; with the legacy
VFIO container the guest always falls back to 512 MSIs.

Example
-------
qemu-system-x86_64 \
-enable-kvm -m 10G -smp cpus=8 \
-kernel /boot/vmlinuz \
-initrd /boot/initrd.img \
-append "console=ttyS0 earlyprintk=serial root=<DEVICE>" 
-device amd-iommu,dma-remap=on,numint2k=on \
-object iommufd,id=iommufd0 \
-device vfio-pci,host=<DEVID>,iommufd=iommufd0 \
-global kvm-pit.lost_tick_policy=discard \
-cpu host \
-machine q35,kernel_irqchip=split \
-nographic \
-smbios type=0,version=2.8 \
-blockdev node-name=drive0,driver=qcow2,file.driver=file,file.filename=<IMAGE> \
-device virtio-blk-pci,drive=drive0

Limitations
-----------
This approach works well for features queried after IOMMUFD
initialization but cannot handle features needed during early QEMU
setup, before IOMMUFD is available.

A key example is EFR2[HTRangeIgnore]. When this bit is set, the physical
IOMMU treats HyperTransport (HT) address ranges as regular memory
accesses rather than reserved regions. This has important implications
for memory layout:

* Without HTRangeIgnore: QEMU must relocate RAM above 4G to above 1T on
  AMD platforms to avoid HT conflicts
* With HTRangeIgnore: QEMU can safely place RAM immediately above 4G,
  improving memory utilization

Since RAM layout must be determined before IOMMUFD initialization, QEMU
cannot use hwinfo to query EFR2[HTRangeIgnore] feature bit.

Another limitation with using the control register is that, if BIOS enables
particular feature (e.g. ControlRegister[GCR3TRPMode) without kernel support
QEMU incorrectly assumes that host kernel supports that feature potentially
causing guest failure. 

Alternative considered
----------------------
We also explored alternate approach which uses KVM capability
"KVM_CAP_AMD_NUM_INT_2K_SUP", which user can query to know if host
kernel supports 2K MSIs. Similarly, this enables qemu to detect the
presence of EFR2[HTRangeIgnore] during RAM initialization.

Although current implementation allows 2K MSI support only with
iommufd, it keeps the logic inside the vfio/iommufd and avoids
modifying KVM ABI. I am happy to discuss advantages and drawbacks of
both approaches.

------------------------------------------------------------------------

The patches are based on top of bc831f37398b (qemu master). Additionally
it requires linux kernel with patches[1] which expose control register
via IOMMU_GET_HW_INFO ioctl.

[1] https://lore.kernel.org/linux-iommu/20251029095846.4486-1-sarunkod@amd.com/

------------------------------------------------------------------------

Sairaj Kodilkar (3):
  vfio/iommufd: Add amd specific hardware info struct to vendor
    capability
  amd_iommu: Add support for extended feature register 2
  amd_iommu: Add support for upto 2048 interrupts per IRT

Suravee Suthikulpanit (2):
  [DO NOT MERGE] linux-headers: Introduce struct iommu_hw_info_amd
  amd-iommu: Add support for set/unset IOMMU for VFIO PCI devices

 hw/i386/acpi-build.c               |   4 +-
 hw/i386/amd_iommu-stub.c           |   5 +
 hw/i386/amd_iommu.c                | 163 +++++++++++++++++++++++++++--
 hw/i386/amd_iommu.h                |  24 +++++
 include/system/host_iommu_device.h |   1 +
 linux-headers/linux/iommufd.h      |  20 ++++
 6 files changed, 207 insertions(+), 10 deletions(-)

-- 
2.34.1


