Return-Path: <kvm+bounces-43538-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D455AA9177C
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 11:17:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BE3F419069F3
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 09:17:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37E86207DE3;
	Thu, 17 Apr 2025 09:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="a4mzCssb"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2059.outbound.protection.outlook.com [40.107.92.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8A9226CF1;
	Thu, 17 Apr 2025 09:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744881454; cv=fail; b=a++9cacpFDLvBeAchr8jES4rC+xQzf2H8O/xsTvSqxkdPEULS5DaBPabx0RPzd1EWtmdcX/Xbopkq76fjZkKX/9LtcXR4Z6+6VDQpr70VKlTvf/bXoeOQDTREJxipggn/2JdtARHVpqpiPykpjk1wNI206WtxLL4Uze4lBVPHEs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744881454; c=relaxed/simple;
	bh=3wRBP/g26xn91jI18m6dUqoqAKt5nz0VcUNUt5RHjck=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Nwqoup88j2vm5xCb68iOvmyimXeqOOSbXEeBh5U49LN2RFtRqNLvEWxwO3/TEIY+WVMTm+xMhoPH70WKmEe5WMbw6HswkBEzXK3pEPW2Kktz8JkPc6wzjDhxw8Tl7jxoup0BQAL7dELlp2xVUtNl635oKldFV9anDo12xuNHNJM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=a4mzCssb; arc=fail smtp.client-ip=40.107.92.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dB5uo2RIUhHmqA6YmcT0eP4oedFuZ2GZci9ia26hbinkigJnTb+2wCiV6cMHLct4bH+OT4UPDRQ458dZfViS+qIE3RBMuB0lNwJ7BHTUgvysD4ny0Nn83YKIUWT5rhcjx1As2heauXWjOmhDow/cq0rir6GhoZUg/43c5IsEVoBysFaFrwxg95T/5Dd6F3r5mrF/Zqfi64nZQegkolswUzKByfhTI+7fUmBhUAISsnON3vcAM0eOqYvR5a43J5sVyyZCZPNiFP+StMXJsPwMDKmoEGEg1aJN0qzFvV/mVsMO/We6Hm6Iet/4xt69/CelWygYE+aryGo0Ohep+NuABA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LQ+jSwHVndQo0ElpcFv5pUJK6TUyOvKNtinsaRA3KKI=;
 b=UmOSglVDhbT+z+fOOH1Lc1eDXx8C6hlauZDJDQYKwvu0kt6VZcCKZ3O+K4xO4WY5kkPWhS4CRo7lk6OMK06v3xaxkpBP6H+El3fy09RNWpcHiJ2JhZdPnLNfYwdblJPfeqilpKxQ/cZ+903N7fsfy0xJBUBkCVi31AZlmR5mis8EYNeeR165euu1PmeHpVh2y7Za7zZ+RB2675ZZyK/J1IWTa5Dab2MP3SyfQqVTUw6WMMAVkZrP8lbpMLJOlgGfTigUjlvofw5pUgc3LKIeQe57q0t6yG6zOzsDbNbHFLnOPDc2xZQtefQ/IZmaRYxy+rzKuu4KOFTBMaKDZVCAyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LQ+jSwHVndQo0ElpcFv5pUJK6TUyOvKNtinsaRA3KKI=;
 b=a4mzCssbzCVfWppenqLmc/dIxUoDQh82szYBefIsWxYyJ35dMRUm9H0P5Toj3Qq7/OFJCL2Ig4wTe+hfTz7xtt/ELJskgiZUnXSK4e8Uwg6l9aDWW6GAFCQOjD637KtA6FulGqQSqyZnPKuodmN8F+10itG0+oUa7V7JI8rTq1w=
Received: from BY5PR20CA0030.namprd20.prod.outlook.com (2603:10b6:a03:1f4::43)
 by SJ5PPFC41ACEE7B.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::9a0) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.32; Thu, 17 Apr
 2025 09:17:27 +0000
Received: from SJ5PEPF000001D6.namprd05.prod.outlook.com
 (2603:10b6:a03:1f4:cafe::21) by BY5PR20CA0030.outlook.office365.com
 (2603:10b6:a03:1f4::43) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8632.36 via Frontend Transport; Thu,
 17 Apr 2025 09:17:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001D6.mail.protection.outlook.com (10.167.242.58) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8655.12 via Frontend Transport; Thu, 17 Apr 2025 09:17:26 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 17 Apr 2025 04:17:17 -0500
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
Subject: [PATCH v4 00/18] AMD: Add Secure AVIC Guest Support
Date: Thu, 17 Apr 2025 14:46:50 +0530
Message-ID: <20250417091708.215826-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D6:EE_|SJ5PPFC41ACEE7B:EE_
X-MS-Office365-Filtering-Correlation-Id: 0961a4f1-9558-486a-ce11-08dd7d90abff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|7416014|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?b9tjZ49j71oDKhzKAnXlGgSr7jnd9YamxTJDJYptDVUPvdMbJqMLDA/fZZGM?=
 =?us-ascii?Q?Dd5NixWp7eQuHwZ5JPBsmMSnlwTiacRbiFCFiki7iDUOZzo7t/T2k4h4Ygub?=
 =?us-ascii?Q?tBb7eojxxi4aQdEmBJUHQ3fMM9eWI/vcsr6dodKnRWIYkD5wfbW3E/Qs+UWd?=
 =?us-ascii?Q?QtAyVS5xlno7HNmRoid0Nl0/dv+CWAcSlh5iRM8zhNub5pmZmUDOHVTUsld5?=
 =?us-ascii?Q?vzU2I++DIkiygEsWe9uJd0WlUUe0SBO2AzQxmu14BQhb89sjilOOs4rLMvqT?=
 =?us-ascii?Q?U17JDELZHjW6gGn4RJh1I+Y+Z8R4i7Uko9R8pPJOK9zVSn3n2aZ5kaRbbLGx?=
 =?us-ascii?Q?o4Jvl4mf4pkNbKpuQaogs6X0gGGA5dLMZU5nhmjclS2HNZjbLU9V1nxrwvtW?=
 =?us-ascii?Q?NGO2gYYPJR0g5q7N3Vx9oarKsd6gG6BIq+l59N6HoW1eKdJB/h//KPW80cxp?=
 =?us-ascii?Q?Ygc68WQiaGi7vjMRPRm9RaL2tDWtw41DifdwZh+a5iT7foUH3Ymx3w/6b/wP?=
 =?us-ascii?Q?Gkwzps4BTmojYhQtkkEaKv4o8ZI+JTwRbGazuk30MizpkieNCmvpU/Yj2Fgp?=
 =?us-ascii?Q?nwJH7kVEx/XPuhoHLmnjn9R4bAouoY1p+655y1rNUVVDVALEMMw112NDRs7C?=
 =?us-ascii?Q?T5BtUelvLpSwEB37U7UDq7LQstE3nLWl/XG9VxudngeSmGac1WUDEIHMTHG2?=
 =?us-ascii?Q?+KYKQiouE/gLSq/Bb0gK5XVYQFQnYjhQJShBf268ZDQIHS6smIPJCNM9YJG6?=
 =?us-ascii?Q?9ljf7daRGzK4yx2N7i4lwnmGkUWS2awChnt9/pZUfmNpJ+DyYhL8djdCZGW8?=
 =?us-ascii?Q?vO5z0iw5mVXqLC3n0e0MgLFp+R9z6sYH1vep5B7fCSLWraUl+L2Eyw/rnfIu?=
 =?us-ascii?Q?e5Pl1rOdtnABVqSLvAx2rfbt1LO635rxCi7KOuBOxFaX9WdcaA8yQyGM3G13?=
 =?us-ascii?Q?LSrl94Tl51anJ+5lMvsBG3ajpIsAL9HxVpZK37m88AvkLpGi7xrsXvEZ7Lxp?=
 =?us-ascii?Q?0yVjGCCsnEflTe1U5ZMlxCpY4lQLMYTe3QOmnlfn5folHKt1Pkc5/Ww4/XKs?=
 =?us-ascii?Q?ILqmUS1f2uZ/jBFYwSeFTApVsSP+tTdy8vtidz8zBqsOCXTpTuOg1hTZvtL7?=
 =?us-ascii?Q?07XDxGpQq1bBm5AJaGdgKhP5aWCULmRD6UsepzjEMefXMrJw6rzLX8Dmipi0?=
 =?us-ascii?Q?UBIjT6InzaINGYaMUXaiCndXp4q2B2GD1xESLkqTguy3hgqPDeoPmJEiMWsy?=
 =?us-ascii?Q?Xhao5hjM5/MysSjoHX5JKhsHZB1LRfGzm1LrGeVhwDVJoyyGHFcXoGUYn5Sx?=
 =?us-ascii?Q?3FqoWEB/qQcWbLt2GdZt2rDGZc56k6pfH+WCKYR/WYYVT/P7aPG+12W091J+?=
 =?us-ascii?Q?68kkgZP+IPVa0vJNtXIDy85yQgswERejF63GM39j0fKIfnZqNXebfSy/NKr3?=
 =?us-ascii?Q?/Sa/bqLzFHMFvWlbBifxvfzxqRUowJqEyo7XdaHi4Fb3ov/04QRyOD8LE4bk?=
 =?us-ascii?Q?29swie+1TIchkPBRPlp6/cnytrfZKfyEJDmJBIs0yEKiLOgLGBS4nGTaRw?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(7416014)(376014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2025 09:17:26.9503
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0961a4f1-9558-486a-ce11-08dd7d90abff
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D6.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFC41ACEE7B

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

This series is based on top of commit b4d2bada09b1 "Merge branch into
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

Neeraj Upadhyay (16):
  KVM: x86: Move find_highest_vector() to a common header
  x86/apic: Add new driver for Secure AVIC
  x86/apic: Initialize Secure AVIC APIC backing page
  x86/apic: Populate .read()/.write() callbacks of Secure AVIC driver
  x86/apic: Initialize APIC ID for Secure AVIC
  x86/apic: Add update_vector callback for Secure AVIC
  x86/apic: Add support to send IPI for Secure AVIC
  x86/apic: Support LAPIC timer for Secure AVIC
  x86/apic: Add support to send NMI IPI for Secure AVIC
  x86/apic: Allow NMI to be injected from hypervisor for Secure AVIC
  x86/apic: Read and write LVT* APIC registers from HV for SAVIC guests
  x86/apic: Handle EOI writes for SAVIC guests
  x86/apic: Add kexec support for Secure AVIC
  x86/apic: Enable Secure AVIC in Control MSR
  x86/sev: Prevent SECURE_AVIC_CONTROL MSR interception for Secure AVIC
    guests
  x86/sev: Indicate SEV-SNP guest supports Secure AVIC

 arch/x86/Kconfig                    |  13 +
 arch/x86/boot/compressed/sev.c      |  10 +-
 arch/x86/coco/core.c                |   3 +
 arch/x86/coco/sev/core.c            | 122 +++++++-
 arch/x86/include/asm/apic.h         |  34 ++
 arch/x86/include/asm/apicdef.h      |   2 +
 arch/x86/include/asm/msr-index.h    |   9 +-
 arch/x86/include/asm/sev.h          |   8 +
 arch/x86/include/uapi/asm/svm.h     |   4 +
 arch/x86/kernel/apic/Makefile       |   1 +
 arch/x86/kernel/apic/apic.c         |   7 +
 arch/x86/kernel/apic/vector.c       |  53 +++-
 arch/x86/kernel/apic/x2apic_savic.c | 461 ++++++++++++++++++++++++++++
 arch/x86/kvm/lapic.c                |  23 +-
 include/linux/cc_platform.h         |   8 +
 15 files changed, 719 insertions(+), 39 deletions(-)
 create mode 100644 arch/x86/kernel/apic/x2apic_savic.c

base-commit: b4d2bada09b17fcd68a0f00811ca7f900ec988e6
-- 
2.34.1


