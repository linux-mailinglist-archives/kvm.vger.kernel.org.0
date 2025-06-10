Return-Path: <kvm+bounces-48816-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C5151AD4144
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 19:55:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 895823A7536
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 17:55:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B769C2472A5;
	Tue, 10 Jun 2025 17:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="A5fRAA47"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2059.outbound.protection.outlook.com [40.107.220.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B448244684;
	Tue, 10 Jun 2025 17:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749578087; cv=fail; b=LlX4Hp4kWHL5rhLC6ycQYFgoyuY5dtKAKRfwddFyoBeB4/BOz28csIv8I+z1Ysk0y9gkM87aX8ox69Z108SEGSjS4IKGHo+ZhDnQ3JYF7ZsyL8Z3UtG+XS5wFqnGZiq1vxSndEaUejYwhyGEmXUhuRHgYZVWTmVZxcTb2r2LlQM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749578087; c=relaxed/simple;
	bh=aVXF3qDAmuOqFMv8gVIdkAifQrQpTzb7Q+uVmeGcufA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=WaTlTGkMQGSE4Wii22M8l+20ZlJffGSkICoH9RsrXBOAvNpAj8/DICnEPZSelyLQsbLt2xjroUR6ctta4scCJ342KAM0FkLs3NmJ9R/uZC/ZiRjYFXtwjJxNOVrsPfZlMb/17nSBwwtKtYhUr7wY4IZhPs1XWZbx0rNhhgdwbsA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=A5fRAA47; arc=fail smtp.client-ip=40.107.220.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gm66t+PvDNnuU04ccKOyI45b28rz1nH+vYmx5ZZGKTzGTIGXpGlyEGFnodA5yWCPF/4c0sZCzWmA30xhEe2luTfgZBshsCTKR4vnpdZq5gtFR+5ZUo1R1d1o6RQ7yrHfwqeozX743eNPNCA/33mH6CdrOdV8tM3EXBLWXiVehqSa+dmQZkJ+s4ynDnTDCAROSyELOk2d7Zd5UZeXYND7F6mIw/c4Qy/vb5pF8o5wYkn/KIgq8KQqm+qPldtcaHBBWxHw1buTtzuNc+gQz9NXmTrkf3L/dl78C6hjaQitcLLwygTY7AZOMuZ0FngjA6gXcKrWyn5ZmNnQosHtNnA7pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D06GUl9qX1cD3Ugs6lxZ7ugx1t727RPpv8n3Fd+PAo0=;
 b=AXWhEzHAaebX8oUJ0rhME/yusa9ydX9e9FYgY6Dk0mLrwoNkcH6usbsFVcOxg0m+aebySXPB3nBipfcyoh+mE+HumdoZHniaqBhQEWcnDDvS/+tmnRGXuF2yQykCjyTmD3FukZaDPlhdX+j6NYFQws0Aor7Y16zxIIvGNhis7fM1LVZjOFrmgfIbExVByc6XJwDet8qzZaHrMXWZnlOWXPdX9sV9QDvgEPpTwQFtBrlex619STMwgeHkePpkcBgWvXp4UZTR3vxtEnDMT+XQtpGZdv5VPQqMXiWZeu+hpp1b2G+5XTDj+6gVFIsODU6yqzW5H9sd3aiQRLlmoPU9UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D06GUl9qX1cD3Ugs6lxZ7ugx1t727RPpv8n3Fd+PAo0=;
 b=A5fRAA47iHNewJ3SzdG0pmbnGAhJmDhWmZp5HHtKm7+Cw/6wihg0tLcxG/ZxVvoMHwmqx2xqiSBHEkOfWqNp4eIOaLpbRG5j6LGFw8ocFkwo6xJ9XATkH/J7VwZ2PeiJZiz/ikH6DtgfR1QcNy6cVM/y83kmQijPhlcPV5ejRlE=
Received: from BN7PR02CA0010.namprd02.prod.outlook.com (2603:10b6:408:20::23)
 by SJ0PR12MB6880.namprd12.prod.outlook.com (2603:10b6:a03:485::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.41; Tue, 10 Jun
 2025 17:54:40 +0000
Received: from BN1PEPF0000468A.namprd05.prod.outlook.com
 (2603:10b6:408:20:cafe::71) by BN7PR02CA0010.outlook.office365.com
 (2603:10b6:408:20::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8746.30 via Frontend Transport; Tue,
 10 Jun 2025 17:54:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF0000468A.mail.protection.outlook.com (10.167.243.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8835.15 via Frontend Transport; Tue, 10 Jun 2025 17:54:39 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 10 Jun
 2025 12:54:32 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <francescolavra.fl@gmail.com>, <tiala@microsoft.com>
Subject: [RFC PATCH v7 00/37] AMD: Add Secure AVIC Guest Support
Date: Tue, 10 Jun 2025 23:23:47 +0530
Message-ID: <20250610175424.209796-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF0000468A:EE_|SJ0PR12MB6880:EE_
X-MS-Office365-Filtering-Correlation-Id: ed82e3e4-bda5-4049-b229-08dda847df06
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|36860700013|30052699003|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cwxZCAvDyG2vWezjXTGw7H1k6rEYZ+LBQv/0hpl4CDYjRlu3LLL5KcN7CnSa?=
 =?us-ascii?Q?dnH3BlravUmirteUTl/0y2RVTfP3t/nAVkk7PDoeW9MCR6dtxOd8UQEyoGF6?=
 =?us-ascii?Q?NU+3z+XQa81hoic/duup1jWavh+PzCDkT4JdYjdtg1+vQeTBe+eYH1yLkhAr?=
 =?us-ascii?Q?PeDntib5VoHPG+fVEtt+IHLq/TFlr2IEWYQWSODqwz/m8xGe6/QW6q6XbJy7?=
 =?us-ascii?Q?uANDZLrTrIC/9E5KA7zx/MuNy8TZ2ygkSygBbSHX2ADM7cZY4v3o/VFa8nGD?=
 =?us-ascii?Q?rjT59tKnrJZYWvWYyPzN/V6rJ+mY/KCCaLB58xAsbraavgFQPfKREesfqHvl?=
 =?us-ascii?Q?owcdN7blXTmLJ9ATMvUkfxjsH3GKw+Vd76ioT6iLpvphM7mi3AB8vBp/4ZP2?=
 =?us-ascii?Q?vu2PVluouXS59ZYUtrPGzf7I7W9wIRQ/EcytuARAjPWsGBvL2c8vrKyv7MFY?=
 =?us-ascii?Q?sAQsbI4Ft0QI+Zc5+adq0Skes1xiyirl9IyIsjVZ4C8EdzUA51zQnO0YCqEO?=
 =?us-ascii?Q?mPrBkKRa3f3tYII+1l/24x5nLngU/sLlKXf0t218xiCK5cewmaPxJvmWue0s?=
 =?us-ascii?Q?v6RSXTtFOEv9AZTCfYhFp6uFNPW4KBOimySYkKXJVes5wI1S69Yu6/4+boZL?=
 =?us-ascii?Q?Mq49J6MbJQvQuYtxZIGK3CE3U0GNZYOZq9h3HOevX6Lq5lh4ZnE7ZKOOg06n?=
 =?us-ascii?Q?Lo2FcUUK+rtcD68XnemZXR+Gx043oe2L46yrW8g1jNGetjsp47s7W6lO7xpN?=
 =?us-ascii?Q?HGAUDgDatU5SRQtmDschYkJ5AeupIWw7CtqJqXIzjzVT+1QOU2/EQ7U4sps9?=
 =?us-ascii?Q?txYWSOpg0Zybj1VMYbu3uoSnX93fMRivmD1xySjp4ABIzEY/k6UjVjPCA52e?=
 =?us-ascii?Q?J0OvwgoAUIE4puV/xKEUCvqXzkyXcW7OM4Qj1AQEO5sxHUYUu74Zx5PuzZNA?=
 =?us-ascii?Q?PeJk+/MYyarDkPrODo4QjrjGNe5uUHOfp1JzisTbcD1Fs5E9KnbnpgxbcAhq?=
 =?us-ascii?Q?ueuaU0WGEpNfAtWq6p0JcxqE/MMAwzAFFJ74aWz4kz6szKVbHyGtMuYDeaUW?=
 =?us-ascii?Q?b3PaklNgTv+I/HO1VpEzpyy+8nCDlwDJXzzT1q0CAqr/4zwy5RhFCjpQj7Bh?=
 =?us-ascii?Q?V2TKXXPGvPRuaMqzdlwu4l/+BPiDoTIl0ekqopmu5AzzLMoVPtWMUu+HYMRx?=
 =?us-ascii?Q?7kqDCkjbAJvaM9qOIGzTzrdcY+5GyVuMr68nPu54cIdu13nnghcvyHZ3I6Ik?=
 =?us-ascii?Q?eHpr2H7DTYR0swcsl2o/RwXF2K+CCUO6pDVSJDhYajWcwvIdaG+3786fpLKg?=
 =?us-ascii?Q?0jgv2uhSIVnJJlAktlZf/VPV4q4X86hJ2YKEvEPJw79G1Grc6kJKT+DjnKHS?=
 =?us-ascii?Q?EA1DT1ofTGK5e1nCzpJAJfVF5LMsL2Jlzrea5fb2fnpS6JAHgJyiHaIttKOi?=
 =?us-ascii?Q?T8t/7UdqegZbbbYJ1tvNopQ1qUTjwfls+tA53dxLCrg2OuikHAXdf0PQtw21?=
 =?us-ascii?Q?QqjVCmtinJOaOs5V+k9GdfkdTvVFflUXLy+qKkuvoZvq0z658XkusfpE3Q?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(36860700013)(30052699003)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2025 17:54:39.3912
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ed82e3e4-bda5-4049-b229-08dda847df06
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF0000468A.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6880

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

This series is based on top of commit 337964c8abfb "Merge branch into tip/master: 'x86/urgent'" of tip/tip master branch.

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

Neeraj Upadhyay (34):
  KVM: lapic: Remove __apic_test_and_{set|clear}_vector()
  KVM: lapic: Remove redundant parentheses around 'bitmap'
  KVM: lapic: Rename VEC_POS/REG_POS macro usages
  KVM: lapic: Change lapic regs base address to void pointer
  KVM: lapic: Rename find_highest_vector()
  KVM: lapic: Rename lapic get/set_reg() helpers
  KVM: lapic: Rename lapic get/set_reg64() helpers
  KVM: lapic: Rename lapic set/clear vector helpers
  KVM: lapic: Mark apic_find_highest_vector() inline
  x86/apic: KVM: Move apic_find_highest_vector() to a common header
  x86/apic: KVM: Move lapic get/set_reg() helpers to common code
  KVM: x86: Move lapic get/set_reg64() helpers to common code
  KVM: x86: Move lapic set/clear_vector() helpers to common code
  KVM: x86: apic_test_vector() to common code
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


base-commit: 337964c8abfbef645cbbe25245e25c11d9d1fc4c
-- 
2.34.1


