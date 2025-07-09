Return-Path: <kvm+bounces-51834-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 676D1AFDE21
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 05:33:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6AE923A8D5C
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 03:32:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECA8F1FBCAA;
	Wed,  9 Jul 2025 03:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="bKAu2w+J"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2076.outbound.protection.outlook.com [40.107.212.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1695FC1D;
	Wed,  9 Jul 2025 03:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752031982; cv=fail; b=e/LSbFdyDQED/fFQb4cggq51yHN9TFiQrdnLk4FN/OZa6rLEWWmIg5Rc6/ZPyAvB9BVu3nuSiIfHMJgElfRbJLlB4K1i53HMEBSJ/HI3H60kLnDQ4kx10Pv6M8cKxaNdnoJNL/+KTxxJcbm3J3Na0PjvVwGAHBD6wcbjDWqqBU0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752031982; c=relaxed/simple;
	bh=d8zfzMQFdnsWo8jn1CIu4kEKovliEPZJL9pY03ZhbLk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=g/2d7F2XDmw9VbjNfDl8S51/C0hkCHFrfwciC1YNvTdDlE7zchEPlLY6Oz672arWcmEKKij7qrGovwD3qXF3lkg7pYUapqoIYUxg+PUqkXpMv2GIuifsMOaKQxcC0PqVO/9rnuSwQdJiKyG49Qx7ih25Ci0k507zM5K5ItU+ru8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=bKAu2w+J; arc=fail smtp.client-ip=40.107.212.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ldon6TE/vTGos/v4ZwsrP9C7Z374jamu39QnC8UUGjYJJEmz5gKjzX7KunS+juBni41uJYyz5uF383pgYBslBRvyuE5KZ4FuHi7msi9d/7e6mpN7vnN4NRmMEHsoXxzMa3m5cWAW3qUnJ8EaUK1wLDx5FiKdDUezi3JXo6ZcjWHUNFEGdXDKKWK8Ojd8xvIh0fELTuVU83Pie40MzjV3qoc6YuZmp6PtVNz6kUHSxHH0UdE+xmFmgFe2a92fNNSPipnuY9tQriytjEI8MqaYoqN7SBfVESQvDTz67wuwg9b9mQrN+yK1RJdUgMBOfhhxZRcz/GJ1dfqg9NKpp/WAsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b/NN55XWQNU9zBIdiI1MXa9QL6+WVeTFnmnVTrJiAC8=;
 b=u+KjWch+cGx+DSin7yF7jTEt2mtVdmfLEErb/9RSHdy2opY31eLwlVNtmH/i37pGjnLIu2QW1gRiwbAQlRZWLKTm+EVuq20m4WcNpaIpVGfFbZq3XVXp6MsTAM5g1P0y3N6fadkwmuN0CrixaCai/AgeL2WvRR0m2pMTAGXreoZUuv2QAUiE4sMYV0RYFlE5YAcJpwcFl9VEhRy3tTS2AH7h3lC292Q3ZvSgQo7ZOQQb/DLU4WyIghPBbxYgUj93c9riu8bSCInYtsqUu1wAyw/hvV55Ce4oFEdHHjFmlsAGISga1DqBP37rg7tRNNAPDgBsO+qau2Jzi5DpkXfgDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b/NN55XWQNU9zBIdiI1MXa9QL6+WVeTFnmnVTrJiAC8=;
 b=bKAu2w+Jn8PmIz5C1QcdsVbGWj8qRCBwa9fjiq1Yuk3TtyMGE0YIA61evJ5rMq2JCd1Q/kigVI+L6faryMFYbOCHFcaUC+sQpJSQ6Ntyrh3a3qabXJqkCqnBg6lyOONjF1klvTgOGktp3vQPg8QEhocn4n1JN8yMYTvg10PWvDE=
Received: from DS2PEPF00004563.namprd21.prod.outlook.com
 (2603:10b6:f:fc00::519) by MW4PR12MB6754.namprd12.prod.outlook.com
 (2603:10b6:303:1eb::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.25; Wed, 9 Jul
 2025 03:32:56 +0000
Received: from CY4PEPF0000EE3D.namprd03.prod.outlook.com
 (2603:10b6:92f::1004:0:11) by DS2PEPF00004563.outlook.office365.com
 (2603:10b6:f:fc00::519) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8943.6 via Frontend Transport; Wed, 9
 Jul 2025 03:32:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE3D.mail.protection.outlook.com (10.167.242.15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8901.15 via Frontend Transport; Wed, 9 Jul 2025 03:32:56 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 8 Jul
 2025 22:32:49 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <kai.huang@intel.com>
Subject: [RFC PATCH v8 00/35] AMD: Add Secure AVIC Guest Support
Date: Wed, 9 Jul 2025 09:02:07 +0530
Message-ID: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE3D:EE_|MW4PR12MB6754:EE_
X-MS-Office365-Filtering-Correlation-Id: de6617a0-b14c-44f1-e5af-08ddbe994ba2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Lehm6LANeKyVKHOxUF8m0vCB/CSctgkgggXyULnIrdEHU01Hz8lARXo955aF?=
 =?us-ascii?Q?dAX5e4qJqsYk2BrXXgYyHKg9G0Pw9U4BYiCQcwedrJFdDr2pnNS0/q6OECzu?=
 =?us-ascii?Q?VfdpRdBPUQIADOj2teO01ewqdwu1akrPWC79jmqJ3nOpHEaczL2BVBhzusvQ?=
 =?us-ascii?Q?lyvbbouEGnb8nK10NMJlFCkV3MZ3ddoRb5CmAh6/Mm33JoGdiXptf0Fvv28z?=
 =?us-ascii?Q?xatg3gTdkSqOvxiQv0Jxo6rFHzI2HVaCF18iuUwNbzW+B6vkBz99+G2PJ2Pr?=
 =?us-ascii?Q?CwkMbT1Mh0WwhrPlgTGM5Ov/m8s8pupsd1P/lh5y/i963SHxph3V4VA6lcaF?=
 =?us-ascii?Q?R4wrmdD9m+P97Vfcd9hsnz4NimzfxLHCzTLfd5i0UO2n6MZYeL6i6MIhiiDi?=
 =?us-ascii?Q?POowRGMY6N5LDCZ8Lg/YF/oVHHz2D1f3p/zw1F4P6zRrQgkHQIYPepD53G/Z?=
 =?us-ascii?Q?ndrspvp4fZehYE8C5Rrjln8dXCU+5I8q+GyggW7ijPMkR20urJewgmSyoGKn?=
 =?us-ascii?Q?KrTipJgtfc9PAFoKWIh7BwX58JlNATd1EfWn9lDmJlEXsxHl1rKHDpN5EvEl?=
 =?us-ascii?Q?X+bQEenbTlMqC4aN9DJ+B2QmYCQZXafiliJmbsxulnbvZoBN9iVU/6bJHpv1?=
 =?us-ascii?Q?gAZdcVGrwaI+T+kYyiPbC5b/6zT0csZf2ti5gt6xNrLlUnBqig1eBG/hsrdu?=
 =?us-ascii?Q?qoa4kFCP0A/wubOv9LOfhHBqhEt9X0f4Gfhkxrw26JWCZkbAN9zqBaNG4pQL?=
 =?us-ascii?Q?cLtNxZdiYIUq5DLNjFe9/sze5eladNTMQx1tdKoCMhZvMsnCarPcIS25R5ix?=
 =?us-ascii?Q?KeTzfzr1tKkoR7NPXD52uB4KFUuqC65Q/wRyjn/tlm95hnezp0dKNzPFOPiO?=
 =?us-ascii?Q?kSaw/KqVqBPyttZ3xS4p01s6iDRaUgaoD0D8BmycaE8NbUHISZW8NRd3GOc6?=
 =?us-ascii?Q?yE6pX4UiKwDcdXlMFGRKFKy/7iHedKcSHrgIwPnuXT0ZB3699zi8Pzdhw2FD?=
 =?us-ascii?Q?x2uUD51fsEWMFOjcXF0ZED5s38YEMt4teiUCi4A8BbhgEqFpLc46sif/MhIj?=
 =?us-ascii?Q?WoQjqtHewjQZUeeUArQcYEG7yBFheep51OCujU/NU1vZSXok+UjmpJ3K2Ula?=
 =?us-ascii?Q?flfYdaHYKIhxm1U0x7MTKYcwz+GCsM0tVHmEWNGrAWAAteqwZPmqSc42H70A?=
 =?us-ascii?Q?Hrsk68dsRcbXJxX6jRdWWoS0qxAHGXU6TdNhZOG5dT6kwXEVWd1bDFRxAJbg?=
 =?us-ascii?Q?2GboYQnw4Sxe9aWF+EbhDCIp/jy8ZK6HDwBgPOsKl2VEavehmQhlTsS9alhf?=
 =?us-ascii?Q?emqJ3ZDcgSK0+i3uKTGs9xCS1WrakogKNzyszML0SdKbHtcPHW87OJrHs5nx?=
 =?us-ascii?Q?c4o6b31EgWNH1mpym5j820KO0wQ9PUNGPQDTOWb+6tHi7y+xEznmjzX8Y/JZ?=
 =?us-ascii?Q?504xhfjq7a7zi3RzT/PZJeekhYVTsYxP1dX8I4B7EhswFz3uJu3Tnz/5g20i?=
 =?us-ascii?Q?kn72JWZGqiX9UK3MwdXQXkpwDiZYdAy5WNAeGt10bM2LtuUfLxAF3xAWew?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 03:32:56.3835
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: de6617a0-b14c-44f1-e5af-08ddbe994ba2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE3D.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6754

Introduction
------------

Secure AVIC is a new hardware feature in the AMD64 architecture to
allow SEV-SNP guests to prevent the hypervisor from generating
unexpected interrupts to a vCPU or otherwise violate architectural
assumptions around APIC behavior.

One of the significant differences from AVIC or emulated x2APIC is that
Secure AVIC uses a guest-owned and managed APIC backing page. It also
introduces additional fields in both the VMCB and the Secure AVIC backing
page to aid the guest in limiting which interrupt vectors can be injected
into the guest.

Guest APIC Backing Page
-----------------------
Each vCPU has a guest-allocated APIC backing page of size 4K, which
maintains APIC state for that vCPU. The x2APIC MSRs are mapped at
their corresposing x2APIC MMIO offset within the guest APIC backing
page. All x2APIC accesses by guest or Secure AVIC hardware operate
on this backing page. The backing page should be pinned and NPT entry
for it should be always mapped while the corresponding vCPU is running.


MSR Accesses
------------
Secure AVIC only supports x2APIC MSR accesses. xAPIC MMIO offset based
accesses are not supported.

Some of the MSR accesses such as ICR writes (with shorthand equal to
self), SELF_IPI, EOI, TPR writes are accelerated by Secure AVIC
hardware. Other MSR accesses generate a #VC exception. The #VC
exception handler reads/writes to the guest APIC backing page.
As guest APIC backing page is accessible to the guest, the Secure
AVIC driver code optimizes APIC register access by directly
reading/writing to the guest APIC backing page (instead of taking
the #VC exception route).

In addition to the architected MSRs, following new fields are added to
the guest APIC backing page which can be modified directly by the
guest:

a. ALLOWED_IRR

ALLOWED_IRR reg offset indicates the interrupt vectors which the guest
allows the hypervisor to send. The combination of host-controlled
REQUESTED_IRR vectors (part of VMCB) and ALLOWED_IRR is used by
hardware to update the IRR vectors of the Guest APIC backing page.

#Offset        #bits        Description
204h           31:0         Guest allowed vectors 0-31
214h           31:0         Guest allowed vectors 32-63
...
274h           31:0         Guest allowed vectors 224-255

ALLOWED_IRR is meant to be used specifically for vectors that the
hypervisor is allowed to inject, such as device interrupts.  Interrupt
vectors used exclusively by the guest itself (like IPI vectors) should
not be allowed to be injected into the guest for security reasons.

b. NMI Request
 
#Offset        #bits        Description
278h           0            Set by Guest to request Virtual NMI

Guest need to set NMI Request register to allow the Hypervisor to
inject vNMI to it.

LAPIC Timer Support
-------------------
LAPIC timer is emulated by the hypervisor. So, APIC_LVTT, APIC_TMICT and
APIC_TDCR, APIC_TMCCT APIC registers are not read/written to the guest
APIC backing page and are communicated to the hypervisor using SVM_EXIT_MSR
VMGEXIT. 

IPI Support
-----------
Only SELF_IPI is accelerated by Secure AVIC hardware. Other IPIs require
writing (from the Secure AVIC driver) to the IRR vector of the target CPU
backing page and then issuing VMGEXIT for the hypervisor to notify the
target vCPU.

KEXEC Support
-------------
Secure AVIC enabled guest can kexec to another kernel which has Secure
AVIC enabled, as the Hypervisor has Secure AVIC feature bit set in the
sev_status.

Open Points
-----------

The Secure AVIC driver only supports physical destination mode. If
logical destination mode need to be supported, then a separate x2apic
driver would be required for supporting logical destination mode.


Testing
-------

This series is based on top of commit 262fcdc7c5e8 Revert "sched/numa: add statistics of numa balance task" of tip/tip master branch.

Host Secure AVIC support patch series is at [1].

Qemu support patch is at [2].

QEMU commandline for testing Secure AVIC enabled guest:

qemu-system-x86_64 <...> -object sev-snp-guest,id=sev0,policy=0xb0000,cbitpos=51,
reduced-phys-bits=1,allowed-sev-features=true,secure-avic=true

Following tests are done:

1) Boot to Prompt using initramfs and ubuntu fs.
2) Verified timer and IPI as part of the guest bootup.
3) Verified long run SCF TORTURE IPI test.

[1] https://github.com/AMDESE/linux-kvm/tree/savic-host-latest
[2] https://github.com/AMDESE/qemu/tree/secure-avic

Changes since v7

v7: https://lore.kernel.org/lkml/20250610175424.209796-1-Neeraj.Upadhyay@amd.com/

   - Commit log updates.
   - Applied Reviewed-by and Acked-by.
   - Combined few patches.

Changes since v6

v6: https://lore.kernel.org/lkml/20250514071803.209166-1-Neeraj.Upadhyay@amd.com/

  - Restructured the patches to split out function/macro rename into
    separate patches.
  - Update commit logs with more details on impact to kvm.ko text size.
  - Updated the new macros in patch "x86/apic: KVM: Deduplicate APIC vector =>
    register+bit math" to type cast macro parameter to unsigned int.
    This ensures better code generation for cases where signed int is
    passed to these macros. With this update, below patches have been
    removed in this version:

    x86/apic: Change apic_*_vector() vector param to unsigned
    x86/apic: Change get/set reg operations reg param to unsigned

  - Added Tianyu's Reviewed-by's.

Changes since v5

v5: https://lore.kernel.org/lkml/20250429061004.205839-1-Neeraj.Upadhyay@amd.com/

  - Add back RFC tag due to new changes to share code between KVM's
    lapic emulation and Secure AVIC.
  - Minor optimizations to the apic bitwise ops and set/get reg
    operations.
  - Other misc fixes, cleanups and refactoring due to code sharing with
    KVM lapic implementation.

Change since v4

v4: https://lore.kernel.org/lkml/20250417091708.215826-1-Neeraj.Upadhyay@amd.com/

  - Add separate patch for update_vector() apic callback addition.
  - Add a cleanup patch for moving apic_update_irq_cfg() calls to
    apic_update_vector().
  - Cleaned up change logs.
  - Rebased to latest tip/tip master. Resolved merge conflicts due to
    sev code movement to sev-startup.c in mainline.
  - Other misc cleanups.

Change since v3

v3: https://lore.kernel.org/lkml/20250401113616.204203-1-Neeraj.Upadhyay@amd.com/

  - Move KVM updates to a separate patch.
  - Cleanups to use guard().
  - Refactored IPI callbacks addition.
  - Misc cleanups.

Change since v2

v2: https://lore.kernel.org/lkml/20250226090525.231882-1-Neeraj.Upadhyay@amd.com/

  - Removed RFC tag.
  - Change config rule to not select AMD_SECURE_AVIC config if
    AMD_MEM_ENCRYPT config is enabled.
  - Fix broken backing page GFP_KERNEL allocation in setup_local_APIC().
    Use alloc_percpu() for APIC backing pages allocation during Secure
    AVIC driver probe.
  - Remove code to check for duplicate APIC_ID returned by the
    Hypervisor. Topology evaluation code already does that during boot.
  - Fix missing update_vector() callback invocation during vector
    cleanup paths. Invoke update_vector() during setup and tearing down
    of a vector.
  - Reuse find_highest_vector() from kvm/lapic.c.
  - Change savic_register_gpa/savic_unregister_gpa() interface to be
    invoked only for the local CPU.
  - Misc cleanups.

Change since v1

v1: https://lore.kernel.org/lkml/20240913113705.419146-1-Neeraj.Upadhyay@amd.com/

  - Added Kexec support.
  - Instead of doing a 2M aligned allocation for backing pages,
    allocate individual PAGE_SIZE pages for vCPUs.
  - Instead of reading Extended Topology Enumeration CPUID, APIC_ID
    value is read from Hv and updated in APIC backing page. Hv returned
    ID is checked for any duplicates.
  - Propagate all LVT* register reads and writes to Hv.
  - Check that Secure AVIC control MSR is not intercepted by Hv.
  - Fix EOI handling for level-triggered interrupts.
  - Misc cleanups and commit log updates.

Kishon Vijay Abraham I (2):
  x86/sev: Initialize VGIF for secondary VCPUs for Secure AVIC
  x86/sev: Enable NMI support for Secure AVIC

Neeraj Upadhyay (32):
  KVM: x86: Open code setting/clearing of bits in the ISR
  KVM: x86: Remove redundant parentheses around 'bitmap'
  KVM: x86: Rename VEC_POS/REG_POS macro usages
  KVM: x86: Change lapic regs base address to void pointer
  KVM: x86: Rename find_highest_vector()
  KVM: x86: Rename lapic get/set_reg() helpers
  KVM: x86: Rename lapic get/set_reg64() helpers
  KVM: x86: Rename lapic set/clear vector helpers
  x86/apic: KVM: Move apic_find_highest_vector() to a common header
  x86/apic: KVM: Move lapic get/set helpers to common code
  x86/apic: KVM: Move lapic set/clear_vector() helpers to common code
  x86/apic: KVM: Move apic_test)vector() to common code
  x86/apic: Rename 'reg_off' to 'reg'
  x86/apic: Unionize apic regs for 32bit/64bit access w/o type casting
  x86/apic: Simplify bitwise operations on apic bitmap
  x86/apic: Move apic_update_irq_cfg() calls to apic_update_vector()
  x86/apic: Add new driver for Secure AVIC
  x86/apic: Initialize Secure AVIC APIC backing page
  x86/apic: Populate .read()/.write() callbacks of Secure AVIC driver
  x86/apic: Initialize APIC ID for Secure AVIC
  x86/apic: Add update_vector() callback for apic drivers
  x86/apic: Add update_vector() callback for Secure AVIC
  x86/apic: Add support to send IPI for Secure AVIC
  x86/apic: Support LAPIC timer for Secure AVIC
  x86/apic: Add support to send NMI IPI for Secure AVIC
  x86/apic: Allow NMI to be injected from hypervisor for Secure AVIC
  x86/apic: Read and write LVT* APIC registers from HV for SAVIC guests
  x86/apic: Handle EOI writes for Secure AVIC guests
  x86/apic: Add kexec support for Secure AVIC
  x86/apic: Enable Secure AVIC in Control MSR
  x86/sev: Prevent SECURE_AVIC_CONTROL MSR interception for Secure AVIC
    guests
  x86/sev: Indicate SEV-SNP guest supports Secure AVIC

Sean Christopherson (1):
  x86/apic: KVM: Deduplicate APIC vector => register+bit math

 arch/x86/Kconfig                    |  13 +
 arch/x86/boot/compressed/sev.c      |  10 +-
 arch/x86/coco/core.c                |   3 +
 arch/x86/coco/sev/core.c            | 103 +++++++
 arch/x86/coco/sev/vc-handle.c       |  20 +-
 arch/x86/include/asm/apic.h         | 103 ++++++-
 arch/x86/include/asm/apicdef.h      |   2 +
 arch/x86/include/asm/msr-index.h    |   9 +-
 arch/x86/include/asm/sev-internal.h |   2 +
 arch/x86/include/asm/sev.h          |   8 +
 arch/x86/include/uapi/asm/svm.h     |   4 +
 arch/x86/kernel/apic/Makefile       |   1 +
 arch/x86/kernel/apic/apic.c         |   8 +
 arch/x86/kernel/apic/vector.c       |  33 ++-
 arch/x86/kernel/apic/x2apic_savic.c | 437 ++++++++++++++++++++++++++++
 arch/x86/kvm/lapic.c                |  95 ++----
 arch/x86/kvm/lapic.h                |  24 +-
 include/linux/cc_platform.h         |   8 +
 18 files changed, 770 insertions(+), 113 deletions(-)
 create mode 100644 arch/x86/kernel/apic/x2apic_savic.c


base-commit: 262fcdc7c5e8ee4b0978259ffdcd82a628f82f6d
-- 
2.34.1


