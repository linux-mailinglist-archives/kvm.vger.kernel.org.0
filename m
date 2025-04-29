Return-Path: <kvm+bounces-44688-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C778EAA0298
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 08:10:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 284EA1B63786
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 06:11:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 908742741C6;
	Tue, 29 Apr 2025 06:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="uUHS3cDd"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2048.outbound.protection.outlook.com [40.107.93.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8592622F3B0;
	Tue, 29 Apr 2025 06:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745907028; cv=fail; b=KNvdzsQFA9FXhpq6nqI13IwWg8yhF8Jw6O7cvTpJJwIYOCeGVFBGscy7xIzQptcPxTUCY7+SH+IOjJPJ747PO3lOZuO5crPrtTEKXDRULqCjlXVLM5wGwuG6C7yhTR5rZZvT2yQntf11Lpb0Xz4fBgXgSvxotM3uUXFH9I+wooA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745907028; c=relaxed/simple;
	bh=TYeQ5Sp+f2MZ0J4Tux6YQwz2jkEBJKCaie3r5l7IwPU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=FP9k+wBvJ0K8Ryfb0QPR2nzoM+gadxqh28OkdH5HFgFcdX828c49G1B3jEl2euTayY5q/xSdzl2QWkRsk3seAoBneh18mNjy2kXXyLQ+H+2ZXl/hUreWU1G5LAaXiq2QZpiQvbhQaE0cT420HtqLukZEyVIJ6mAfwIeFuLowd1U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=uUHS3cDd; arc=fail smtp.client-ip=40.107.93.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eVDYvpNtvG2F9G26cuMFwH0cFvQDK979xufYBH1LLHXfL22m9zTnal6YoKE4nisgzfrEBFR6FZwGJXDo8n5hffXVIluX3tLTEzJR8OP/vMkBizrXXoA/pNas9cOfh9STQFiHrt5t1kqAJAy3cxfOf07/75QcczgnSPvkQdKhVH5GYa/0XKBPcQTSjp9tuSCdBa4RjcJYkwzeBM+2sZiiAIB+k394205nKjOiQPx6D9vBxtMHsCfdTIJnYHSa1WIaEtJuqe2gaMCv55iuaafMRf91Ov1uNMTG/EHxiqCU7xpjzXJ/7OWDvILWYQ/ceY73oo80gxB09r8zdrXl0Wx+Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KNAL2MLDKvVvtPiHSm+OlDiLtOnry33JY7NCw023h54=;
 b=dB0CwV03lI6lxPWCDBWxV+Qh7dbrhPJy6nqanFjdBCKYBBCdjSY28T+fDNesRxTSw7yI+x/3ezO+I84QqkIrA66oQPiiZXdURMeSh0Z/hmIqntmpM2uOJVVmjXM/CVKSJgaM7wJAfRocAIX6+bV2PMmq4gAKHlcLerJUOu55kWxiFqGVVSN7n4V/tnufmkOpTDPeEZsYmkfHHanG4VhWVpDEcs03tKnzty0m8NU7uL2kSOPbo4T8yEzoeOnSdyQfHA+SF7MOPBVfJUJc6cZgEIFrSwns+rDzOZffC/KzRYo9RaTJg5glSWGVLE8y19MghDYCbPL4+K5hvlzQ2IRdkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KNAL2MLDKvVvtPiHSm+OlDiLtOnry33JY7NCw023h54=;
 b=uUHS3cDdJTTj+kng0d4bax1g69xpHEhpZXw0f9BsabUWNwHCxZ9h3ejIleuRHxR8/ilqsz+fqE4eoXDZl0xnJhIRQxu8bLdwdnep+F5uPAoWs58kpcVJ1dKwU8R0cUZfmKNg3eFu35SQjAk2d1lhLh+oE1oTbiHkulpoSyf7x1c=
Received: from BY1P220CA0018.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:5c3::8)
 by DS4PR12MB9633.namprd12.prod.outlook.com (2603:10b6:8:27f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.31; Tue, 29 Apr
 2025 06:10:21 +0000
Received: from CO1PEPF000066E8.namprd05.prod.outlook.com
 (2603:10b6:a03:5c3:cafe::e5) by BY1P220CA0018.outlook.office365.com
 (2603:10b6:a03:5c3::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.41 via Frontend Transport; Tue,
 29 Apr 2025 06:10:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000066E8.mail.protection.outlook.com (10.167.249.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8678.33 via Frontend Transport; Tue, 29 Apr 2025 06:10:20 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 29 Apr 2025 01:10:13 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <francescolavra.fl@gmail.com>
Subject: [PATCH v5 00/20] AMD: Add Secure AVIC Guest Support
Date: Tue, 29 Apr 2025 11:39:44 +0530
Message-ID: <20250429061004.205839-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000066E8:EE_|DS4PR12MB9633:EE_
X-MS-Office365-Filtering-Correlation-Id: b7c3e5bc-08a8-4a5d-b00d-08dd86e485aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|36860700013|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cSONjFXn5JE3J9hJ78LhbQs+silnNQtfOYCaVGoMCnvAA+NeyQydwVr0rKKm?=
 =?us-ascii?Q?P2MQ/6NTyT++1QGuk+GkoGOVNFXlHfAOt2jyFEpYxAyXq6m/3elpkPl+8AKV?=
 =?us-ascii?Q?xa5PAnKXLJ+LVUIT7CvzHD8MSysPbDWmw91laMBa7KPBHAKby7NTVhZ/T8QV?=
 =?us-ascii?Q?tpXlIs510cnwFWrhYFDN97X6gQICZulOI3BgN5cMaLl86gosvF+LdZBTc7l+?=
 =?us-ascii?Q?QTauyoK/MfgWkErnQUr7wiAIHYcStZbxrwAaWo66ujd0NgGmg4eruFs1nkBT?=
 =?us-ascii?Q?fUan1AzroKA1QJ+l4mDhfJ4+A9ESfHVzPkWy2o7JREfUh5H19ATVpxy6G1Ak?=
 =?us-ascii?Q?rX3HuevN/T3c3kWDhC2Om9YEP8xJPLhhPH89OiDdqTMe4vq8DsowCg+dZaiU?=
 =?us-ascii?Q?CDgcgznr9nF5UE6XGlqe3FQtgPcsZyAkkXEYGD6gXTTE5UNHdszaRMXqJ8Kg?=
 =?us-ascii?Q?cn4CUiy5fGQ1usz86zqqOInZX8B+R9YcUQxemPBtTUtXfAe4LszWE7rbLS7y?=
 =?us-ascii?Q?UCEp82zbSzz0zlZQbDrMGm44wVgYekhiNz7VbtVPPo6vKN4KVCoyrR7WndUr?=
 =?us-ascii?Q?1Tj5MNAmKTshhP/9HZQFrohKmT9maWRdnyuHlDiVgq+sZYI3fESjQbPxXw7v?=
 =?us-ascii?Q?UrUp/IFLEGSmEaKSF0heIAZWUpEPWs7m2iw2nQ1CFAbah1KHnHlsbLULo6ds?=
 =?us-ascii?Q?TS9QKQqqp/X31OQbrnxe8bknUDMb45/VbDSpiyxnIQ86LWsqbNBkl7yre7ic?=
 =?us-ascii?Q?uEo0nQAx8Iq2DjjO5I77xQVNCw4dW7IhefI9e8B4ApP9SHgWC+3zh3ZmkI2q?=
 =?us-ascii?Q?mfWJpELxN5irQYmQgPR43KOrfLhYBCLaP/4e+jNRsgQAQE3RMwkxzZ4LlYKY?=
 =?us-ascii?Q?w/El9b8wuFxjotzteF1c0ouv+zPBwvrO95jk+1NQ+3gqYIR4Wh+IDu+AmrLY?=
 =?us-ascii?Q?7rdHoEU6yLS1riWwi8cBBrPeSdh+fb0q6awxsX659iIAfCQXFvTM6h2KGVvP?=
 =?us-ascii?Q?+cNNWxo07utrhNXB9wIzQi0IHdgwxqKSm42ZhWkI2O0KFREUuMk+SFySeR+U?=
 =?us-ascii?Q?V3TaLghip6EBpsqKjCx2LOuZge+ud9Njzk3nHsm6q7gFn1ad9b97yipg5Ipc?=
 =?us-ascii?Q?0I96toXKUPyHwERIAmkKumyBxd184PPfzlF/UxrUvKwzJiYFQTGQKSzMvwiV?=
 =?us-ascii?Q?927+YrN9TVHaEYW/B7hmwR/QJWCOY/8VxuZhwK/cVyv73o+0pdQj3iBGcS5E?=
 =?us-ascii?Q?AUy4w4Xpct9AYefy2KbOWerQ4a3urIYh5KT9mCpX+7D8BVdccMC7kFainOQN?=
 =?us-ascii?Q?ad8sT8p9wqvKKwPosTrH08QWdratCQhFcBSXnkb5+6fc0Rrj5BKGYG0Hkkz+?=
 =?us-ascii?Q?7angy4CnO80hnkPqCR0UuF/ArD7wcion/ZP6FmXMMHUz5RmfwclK8gIyVMg4?=
 =?us-ascii?Q?SOs9sdSvZPZLeLQwg7YV/EFis7IHwwmVRPuM5yUCUPfu2MIWR4tLx+G5GKOs?=
 =?us-ascii?Q?aix+GM8+yY0K69HGBb2eUicE6Gi5V3lw37nlOpRvGM2JB3JIHq5oJubXZw?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(36860700013)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2025 06:10:20.8055
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b7c3e5bc-08a8-4a5d-b00d-08dd86e485aa
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000066E8.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9633

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

This series is based on top of commit b12498a42ec7 "Merge branch into
tip/master: 'x86/sev'" of tip/tip master branch.

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

Neeraj Upadhyay (18):
  KVM: x86: Move find_highest_vector() to a common header
  x86: apic: Move apic_update_irq_cfg() calls to apic_update_vector()
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

 arch/x86/Kconfig                    |  13 +
 arch/x86/boot/compressed/sev.c      |  10 +-
 arch/x86/boot/startup/sev-startup.c |  20 +-
 arch/x86/coco/core.c                |   3 +
 arch/x86/coco/sev/core.c            | 102 ++++++
 arch/x86/include/asm/apic.h         |  34 ++
 arch/x86/include/asm/apicdef.h      |   2 +
 arch/x86/include/asm/msr-index.h    |   9 +-
 arch/x86/include/asm/sev-internal.h |   2 +
 arch/x86/include/asm/sev.h          |   8 +
 arch/x86/include/uapi/asm/svm.h     |   4 +
 arch/x86/kernel/apic/Makefile       |   1 +
 arch/x86/kernel/apic/apic.c         |   8 +
 arch/x86/kernel/apic/vector.c       |  33 +-
 arch/x86/kernel/apic/x2apic_savic.c | 461 ++++++++++++++++++++++++++++
 arch/x86/kvm/lapic.c                |  23 +-
 include/linux/cc_platform.h         |   8 +
 17 files changed, 701 insertions(+), 40 deletions(-)
 create mode 100644 arch/x86/kernel/apic/x2apic_savic.c


base-commit: b12498a42ec760527662930c4fa5ae2253db7d8b
-- 
2.34.1


