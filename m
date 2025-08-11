Return-Path: <kvm+bounces-54388-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AADD2B20466
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 11:51:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7B11E7B3208
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 09:45:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4B5B33F6;
	Mon, 11 Aug 2025 09:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="OS7UcPeC"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2071.outbound.protection.outlook.com [40.107.101.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDD6D1DED7B;
	Mon, 11 Aug 2025 09:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754905506; cv=fail; b=eCfPE+fpi1Th2IVjf7g5e/TBRADw7VCksCcDI9ZBqXri6EElqapA3SeKbZLFyuVyDFF1mdFoAhNlguc2PPO/Vestdz0ap62KRskoJZzBD5NEptID1rIO57N3dE+qxL3sKofcKtEbCn0pqz4Wcwtun8ZRxCJkuvfGMI1axv9/Cdg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754905506; c=relaxed/simple;
	bh=VmldB7jrowUvujr+9eK/d6NurCkh32GOTwXBL9Qe45s=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=EitvDEu0657oh8VezNo/e/nVP18P/XeGwEMt5objqJiiG0zNAemD1b7b2D6Kyt17UULKVZk7hJf9e0sMF67zsbhryuNMR3/MgkDY4G6+9ex+NPTGlS9svhzzByY2NLgPsFERVWHu69Slgg28RBmLb+EPVFrwy6fA3mTLLmRauPQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=OS7UcPeC; arc=fail smtp.client-ip=40.107.101.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JgzblO+cQv2CABv4ymG1t8N+da64X/vurDulgo1GMLUVpH6flzAaCuMCcPYU+orrL4G2LjtlVYsnIrOpt5AAAoZcPsvt3H68VeUEBzvdidCrvFy34M13c1GDPjXZpFgInoJMpmdDPI/3iheoQ2iU1rMBlTEYdGgfuX1vmBZwbEQGxoXKZIMpZCp9O0380Mufo+M/6YgjK2Qq01LaOc1s+p5YT2I5/basAmH6eUa9xrh2WekGS1+hkk3bCbdrfcQ9cwm44EYEpdeVQLA5LxFQ5SWqb7azaZBjztprcDyOG7CRNaGhv0d0cGrOQR8VRQXdNQBwVL8AB3hCazBKDUbN1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gO/qAwalrCRXCOlTYc2w8mLIDPL5AD1bQ5jReDGZ1Ig=;
 b=NSflSDnV9FpY/1l4MIu2sgmT/74hWAWC9tfr1QjtaV1Nyx1hxblc/4iBUUKMWTCEhSbsS2nrEBUGHGbKXUwZex/4J4NyW7kTPZ59TpKKnKhKrvubeqbqRZsdbD32ipbSTxS26Z1XZgbCH1XW/8HJcM332JEGIMxC0XnZmeM0YQjsln8if3m5FKwxlzQ4eHuk8x8QWo9KHE4YNGJE9Wh+rfhngSg4YCJX8a+rxMrR6O4gYIO1tfYe3G1nsQPxg0FHq67gFZhnxAZwo503M0P3aGWnu4era5AAbj7cQaH8I4SwQmiLW8qaQVYv3mf5W4QC50ZssAw6BLkQ77Cu9xHs5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gO/qAwalrCRXCOlTYc2w8mLIDPL5AD1bQ5jReDGZ1Ig=;
 b=OS7UcPeCE3BBcMeG7VtVLx25sH39Dn9R6eJ9IBH7846gmTH1Cd72uRMtBnbhYLZP+M7mopdUNIBgtg+9eod79iF+8uoQX+COF/qkMhSlJcHjRyZ9cyI4B2NrMWfCt2GB4X78tmQb48CXfhxQnimSGGpEzX6LoH6niUbXP28laTQ=
Received: from BLAPR03CA0155.namprd03.prod.outlook.com (2603:10b6:208:32f::13)
 by BY5PR12MB4178.namprd12.prod.outlook.com (2603:10b6:a03:20e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.21; Mon, 11 Aug
 2025 09:44:59 +0000
Received: from BL6PEPF0001AB54.namprd02.prod.outlook.com
 (2603:10b6:208:32f:cafe::c9) by BLAPR03CA0155.outlook.office365.com
 (2603:10b6:208:32f::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9009.21 via Frontend Transport; Mon,
 11 Aug 2025 09:44:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB54.mail.protection.outlook.com (10.167.241.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9031.11 via Frontend Transport; Mon, 11 Aug 2025 09:44:59 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 11 Aug
 2025 04:44:52 -0500
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
Subject: [PATCH v9 00/18] AMD: Add Secure AVIC Guest Support
Date: Mon, 11 Aug 2025 15:14:26 +0530
Message-ID: <20250811094444.203161-1-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB54:EE_|BY5PR12MB4178:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c31290c-c3e4-46bc-cb24-08ddd8bbbcd3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|7416014|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?N1ngS1EXkmWlZKHIlh5LSNqH0i8xh2Vibu3MVkdi/Xg41+3nxU5D4ZhBuT2j?=
 =?us-ascii?Q?Sz8D2EKt8I1FFuEGaf0Yvj7Q9wSmiLf1kyAyOzqjFxmay61K/60Cmi5HiLka?=
 =?us-ascii?Q?L35Zz5gH0c6qv2TjDIbjL8EjmDqSauS4jWEUCdmIINYDBfAnYJn9rJhQjPAn?=
 =?us-ascii?Q?dZDD7I0HqfVWVXpBUhuDpNPZWk5PFH9Hbe7fq/eB/x9UCromc9CXJ/9pr5l4?=
 =?us-ascii?Q?M4vDFoEzW6uBbSEOGHvUaTlUNhJ8MNew7iR2yZn5CSfDTOpkT/HXWo788icD?=
 =?us-ascii?Q?cN1Ca96IZk3vGv6cnuQisXU/xVJBy8v5wPPlymX3wv+xIf9EUIyh0/ldwrVO?=
 =?us-ascii?Q?lC3muybSBiwxWU7uIoiMp3c0aqgLNtaYXC3qKSlhcJUFySA7TYeGMsVSrnLD?=
 =?us-ascii?Q?kHF7yjF/8qFNoZ3T7QfSufQVZRdoE2XB3Qr5kNV16vxY+zD8ZCs3s5G2KRGj?=
 =?us-ascii?Q?FYur7+jy46OjMvzho4rItcTuaDGX++AHoNW2wRGGPwczVwSTBA2bK6fMTrft?=
 =?us-ascii?Q?7FHUzC4YtrDg/AewHHd1JIDWlWxNtpoLXWcEuh2o/lLz5kjEh1cuYpQetid+?=
 =?us-ascii?Q?qlFHezmyhlKAXnrmRyfxRluk3xgE8hFOXxIJ4eBh0pIGcPkiL8YVaFkGX3e5?=
 =?us-ascii?Q?pCaa+6fDZGhDDjOJyEUWCuWczXurv58llYtj4SLTC9yWCAOpZJ8+FpuLOVNb?=
 =?us-ascii?Q?W+P+WHemFk3+noSre1muMv1zl7EgQty6XVMBJv3lhKf3eOM29aifcjBSTGej?=
 =?us-ascii?Q?P/V68kgMHzPAteTqDK9bKoCChGdSZpzIaIWPqBu8hWbWx4mbk4qt/upG/8WG?=
 =?us-ascii?Q?ZC4CWrV4KNP42th3L7EKGL439YZH4NIy4qflWHFZx8y48VNCjqH+JHUTK57Y?=
 =?us-ascii?Q?//EvE9BVp/s7h9Q4FVRm2boX8vWOmCnR6CNdAPfgs50Wm77MQvNvmmJjQAKs?=
 =?us-ascii?Q?zjv5frxOab8YyM8+tLTg3OgzjtGwFOUusLlA6zgjRRB3G1maasmc3WHfdFXp?=
 =?us-ascii?Q?9qFXew4OvPRtV3hReU0kqGGa9DtFDemAWDcMytYa3fuVjb/Vx5Fz5aVOb5WA?=
 =?us-ascii?Q?38brPPNjqyvINSpVRIr+MyBo3vrrzwoV2KhwQdx4tgmy2/JQqhqiZsL+p79Z?=
 =?us-ascii?Q?iwOSnH13y336WHiie52sihHRZG/1wryyL7oMqtnNcPoD2COVs4mH8ReX0eHD?=
 =?us-ascii?Q?ffaMdEsmVov3tTnMMa2qo+MwuzOmPVxYelcCQfc7DngB/B4+4VWVHyLocEG2?=
 =?us-ascii?Q?UI/qbx2eOBE0BDCDTs8fCmtY3CzyWFdWMLR0NRtjk5ctWKGjRNpWT2D2iP7Y?=
 =?us-ascii?Q?HbxGt6Ky5Le/lWZkGpbAzHTD+wQ5ys2vxKYaqppuTQizmx1rUxxPEbcT+Vup?=
 =?us-ascii?Q?YYruX3mUIQDK2TbR61HQGjOITZlwnbnV/imBe4RY9x3ywP1prf0BKYR0K0Xl?=
 =?us-ascii?Q?HbM5R21v/EFwc7+5LUJK4tl6wVeBmzDTWIPPGzFXTb7AgN+jvwP006Yz3+UF?=
 =?us-ascii?Q?O86jbv3rKwXq/gkSOVbtWn4kq6z3sRn+D9cJAavcY0ztLuXMaA14xZX+Cg?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(7416014)(376014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2025 09:44:59.4533
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c31290c-c3e4-46bc-cb24-08ddd8bbbcd3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB54.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4178

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

This series is based on top of v6.17-rc1.

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

Changes since v8

v8: https://lore.kernel.org/lkml/20250709033242.267892-1-Neeraj.Upadhyay@amd.com/

   - Removed KVM lapic refactoring patches which have been included in
     v6.17-rc1.
   - Added Tianyu's Reviewed-by's.
   - Dropped below 2 patches based on review feedback:

     x86/apic: Unionize apic regs for 32bit/64bit access w/o type casting
     x86/apic: Simplify bitwise operations on APIC bitmap

   - Misc cleanups suggested by Boris and Sean.

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

Neeraj Upadhyay (16):
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
 arch/x86/coco/core.c                |   3 +
 arch/x86/coco/sev/core.c            | 103 +++++++
 arch/x86/coco/sev/vc-handle.c       |  20 +-
 arch/x86/include/asm/apic.h         |  11 +
 arch/x86/include/asm/apicdef.h      |   2 +
 arch/x86/include/asm/msr-index.h    |   9 +-
 arch/x86/include/asm/sev-internal.h |   2 +
 arch/x86/include/asm/sev.h          |   8 +
 arch/x86/include/uapi/asm/svm.h     |   4 +
 arch/x86/kernel/apic/Makefile       |   1 +
 arch/x86/kernel/apic/apic.c         |   8 +
 arch/x86/kernel/apic/vector.c       |  29 +-
 arch/x86/kernel/apic/x2apic_savic.c | 422 ++++++++++++++++++++++++++++
 include/linux/cc_platform.h         |   8 +
 16 files changed, 635 insertions(+), 18 deletions(-)
 create mode 100644 arch/x86/kernel/apic/x2apic_savic.c


base-commit: 8f5ae30d69d7543eee0d70083daf4de8fe15d585
-- 
2.34.1


