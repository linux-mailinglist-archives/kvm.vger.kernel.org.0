Return-Path: <kvm+bounces-56053-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C10FFB3980C
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 11:21:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E613F1B2772F
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 09:21:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66A492E3360;
	Thu, 28 Aug 2025 09:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="xgL++W+N"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2050.outbound.protection.outlook.com [40.107.92.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91DD620B22;
	Thu, 28 Aug 2025 09:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756372865; cv=fail; b=UB6K+Ak7cmYIquno+MTOqN1cA5DCGVP1TyUsPTkxGCsJll8J4q+/3EQow3f/GKRloc960Ji2+vXt9FSIAX2sE2njKbjNg2FTflST8V0/Pu6UFDByL6j9QhuKVcMybdMKM7GjjOtB6K3ynlvvNENHCJJO9FJRhFNy8pkuMp1qits=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756372865; c=relaxed/simple;
	bh=1lWBSQA4xh7TT1a0QQQOA9A5+aKrnWFcP2t/w9zyAow=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=e1XhjcwU/ETdEUxaWQMigSB3JvO4M1cbJMJVVDasv7BMbuwxw5V8QL8A7z2G5saPQSFK0OUWci06kpWdQBuMrAoOdyDnxeTb93srcOptcSxAFPSDHj6oJZkhSknkDrppaLq/NQBErJFrfFuFVL/cy7OkLsmT7K1yl0gdCk1gOEo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=xgL++W+N; arc=fail smtp.client-ip=40.107.92.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a8OzfHFXVvKCsfXVGXqVCQxB8Cns8mMRlsV7/LBfV387Yzffe6+3VW8+AVeCVrAjrKQ9PGnbS0RJ38UTACH21JwZ4VFgEXog0Y0Mz/rbILTJ0ABG7uB9a/UeBYLcJV8m1LUVknXGau9dIoQ+4xjYdpyj1VOzeYb89beed20hEruKPgYiFKnoHYSQb6rXGyTx4qTSZKWQkybJn/tEi4DOV1a0KVqwnEwxdERfjQId7d5Di0MRb+bfFfrD1fCJzEDf9dLfhqnXX14Bj/DqEd40BPrR9FgD5zl+lYNhanRZBOHAiR06md5bYu9YPwIrDjn8PIYnd7eWXHgyqv2fr0RKCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ehRW1movQYcFqm47SyIMdmVEK2NJUCEFxZFuMmAXQqg=;
 b=YldtQBTBSxk4jX3pUbU3Fw4a1MG5USCnF4yNYGbjdrN4YfyBlApPqJGwPLKbjAHEpCgJxq6+avVFiF796El4w2OrP6/eCbi1StWdlmcNZPI1YTiUK6RkoSoOCgBtX7x95dlb+EvFAQcsKKHJeofKuFpUaKnt8bi5hVDggXrCJQoxoZDtkCPovuQT2SGbp01tjnAjR3A9cFTcp3VPdq4pU6N5WSc5nWVKx3qs8tJOblHnItoG55VllA+Gr9ZYj6dfJ/gkrGMQUXienONSgAnZFMGFHsdtFZv/jzf6tf1pNqb1kgOak7qNFVnTV0DD7qrC3NbP/kM/dgzEJC1sKsfcJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ehRW1movQYcFqm47SyIMdmVEK2NJUCEFxZFuMmAXQqg=;
 b=xgL++W+NSHh63YTJZd6j7owXgdVxI9gsfWUPmnPARHvJkzCjPE8ycfqwOAjxBeOclhS6nfWJc7csj/kEbN9HKioa/HBwoVZR49FO3XVrVcEKBvTkrEUVn9Jniq/F+cTihWqUqVygjpaFUFQ3qtFEnU1rKovb7PHEQuayiMoawQM=
Received: from MN0PR05CA0015.namprd05.prod.outlook.com (2603:10b6:208:52c::28)
 by CH3PR12MB9124.namprd12.prod.outlook.com (2603:10b6:610:1a7::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Thu, 28 Aug
 2025 09:20:54 +0000
Received: from BL6PEPF00020E64.namprd04.prod.outlook.com
 (2603:10b6:208:52c:cafe::70) by MN0PR05CA0015.outlook.office365.com
 (2603:10b6:208:52c::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.6 via Frontend Transport; Thu,
 28 Aug 2025 09:20:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BL6PEPF00020E64.mail.protection.outlook.com (10.167.249.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9073.11 via Frontend Transport; Thu, 28 Aug 2025 09:20:54 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 28 Aug
 2025 02:01:26 -0500
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 satlexmb09.amd.com (10.181.42.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1748.10; Thu, 28 Aug 2025 00:01:50 -0700
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
Subject: [PATCH v10 00/18] AMD: Add Secure AVIC Guest Support
Date: Thu, 28 Aug 2025 12:30:54 +0530
Message-ID: <20250828070112.208339-1-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To satlexmb09.amd.com
 (10.181.42.218)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E64:EE_|CH3PR12MB9124:EE_
X-MS-Office365-Filtering-Correlation-Id: 1de921f9-902f-45da-1cc5-08dde61430a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|1800799024|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+JXVGkbFjDhvjYS/cpju9NUxmTJqUUUmMQvBMPK3NBqGqwD/7flu3Dy9I/Ik?=
 =?us-ascii?Q?lNj09J8DdSIWXMVIfbhRiJlxi7Dh72gOxMUcoc0y2D0qfgL98KLBFnzaYGEs?=
 =?us-ascii?Q?HEBDpBZhEY5UqfmFz1xDGlIp7OqzX/F0AQeLQ799hZMYO8tIEaL3dvauI6UO?=
 =?us-ascii?Q?MMzHQGZQpn7Z6cG8d0bsMLcKBy7pLbqaO/ohNXM0EHw6e0ewVlH2h8Mv1ZPX?=
 =?us-ascii?Q?4rYIBJ/lApQ2UXfPhtqYjMxziV2yF1RE9Hhcllcuqpyip1rBT+izQGg8boDx?=
 =?us-ascii?Q?uZUi4bvXFRWlCQoGhKTlpQGzdcNMpgCu2X8QLtv5EoyO7LnYZ+jAdRA/+04C?=
 =?us-ascii?Q?K+towNnIbmvRsjf0ijqig1pY6Fuzv5jnbAuLijju/1c0f5o4R/91ucUa6WAP?=
 =?us-ascii?Q?UAmLHiw6lsyQWBGQbA50jjLKReTTzEfjO46XWjmIuQpM5ZHgHwPzgMOKaNJS?=
 =?us-ascii?Q?n6wxIgC4nkLWkYbdomp+J6+f1yoktumI7kgApwVGtyUXsGFuXed5CQXuQynB?=
 =?us-ascii?Q?DLNoFTMuNqevAoqIdk1F2oOgdMXFobn0ZBf11CIh3XEOJEePusXliVz7hwIM?=
 =?us-ascii?Q?Pc2dbfi6vrpLtda5VFDuA45qQWRJF8DfaQuvyPPF70jkaBI/yI04IOVzoa/7?=
 =?us-ascii?Q?wMnvVvDEbrsyXdIv1cr9XMgtphY6aLoN2ZHAUfxcB8vtZe8fRg37qXj90JBf?=
 =?us-ascii?Q?GgMyQqNMAYz/SWquzkHVAK+5VDYlQYhT11kJ8Z7q1LIlFcHtCOu3hbvL7DrR?=
 =?us-ascii?Q?rV0oUpE6HHgz30fHO1Rcx8LGtivnoP9qK9c7C64exH+CUbPnu4BOIbZT92XJ?=
 =?us-ascii?Q?YMtYATD6Ec6FXrlHEzSI9TD9W0vGMW4wV/BZOdky8w+T3y9DC/yo9DbBGdAp?=
 =?us-ascii?Q?pWlY0qan9K1ts3Z2F7U2dY285nL65BQHnKTUR6Qz4vlR50wyHhGQNUgi1JD0?=
 =?us-ascii?Q?1aFjZg2+mSRsgY0UIYmbg7F8gcTp1QB6/uRKRxYzIwL0EMN84+bWe0I/EgbO?=
 =?us-ascii?Q?T972sdEfORHC355MpEQpHIfhyD6LU8HSGr+uAfb9HnH/jOWjRFdrCFY+9GJV?=
 =?us-ascii?Q?oCGaAngf+f+zO0IU5kChL+18JIDAc1cxVTBGxcFTin1sHetgNS3RtyYTi/+Q?=
 =?us-ascii?Q?M20IdbMNgZMi5CkCU15QY+YsbY8H+g65v+wBVzmT2dscvV79CJvrvbuXdhhX?=
 =?us-ascii?Q?euLh3F/Ecu1rwpR2xzUN1dbeCyzikJp8k2AujWsbaKEx1eLgRNeH+1BVWIxE?=
 =?us-ascii?Q?5x73bEiSBucZ5kuV7Jyn3uR+Kq4Gf2FvaB8ERnH3SIBsUc89FACaIqci2WaJ?=
 =?us-ascii?Q?VScHIvn6TgJrPxpY1SQHXYOk7YVMFguhysPzGhW+EQ9YqXnv7lhOwJ2itnTW?=
 =?us-ascii?Q?3RtprFgw49Bwk6SH9/6CA2u84iQbZGtAdaKV/sZpch0LKTcYGJRxsMDLTRSw?=
 =?us-ascii?Q?n4nV0tujnUlGowu4DZWJpXOl85np+TSTnOHerdw+QP/tp/xsUsBFH9gvLl9n?=
 =?us-ascii?Q?hXVnvwx+FHK89RSiq3NLj0jLq7Ymds9dgp85BLC/MI9pbp5QJnrkzuCxpQ?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(1800799024)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 09:20:54.5970
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1de921f9-902f-45da-1cc5-08dde61430a6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E64.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9124

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

This series is based on top of commit 4628e5bbca91 "Merge branch into
tip/master: 'x86/tdx'" of the tip/tip master branch.

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

Changes since v9

v9: https://lore.kernel.org/lkml/20250811094444.203161-1-Neeraj.Upadhyay@amd.com/

   - Commit log updates.
   - Update comments to be more descriptive.
   - Various coding style updates.

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
  x86/sev: Initialize VGIF for secondary vCPUs for Secure AVIC
  x86/sev: Enable NMI support for Secure AVIC

Neeraj Upadhyay (16):
  x86/apic: Add new driver for Secure AVIC
  x86/apic: Initialize Secure AVIC APIC backing page
  x86/apic: Populate .read()/.write() callbacks of Secure AVIC driver
  x86/apic: Initialize APIC ID for Secure AVIC
  x86/apic: Add update_vector() callback for APIC drivers
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
 arch/x86/kernel/apic/vector.c       |  28 +-
 arch/x86/kernel/apic/x2apic_savic.c | 427 ++++++++++++++++++++++++++++
 include/linux/cc_platform.h         |   8 +
 16 files changed, 639 insertions(+), 18 deletions(-)
 create mode 100644 arch/x86/kernel/apic/x2apic_savic.c


base-commit: 4628e5bbca916edaf4ed55915ab399f9ba25519f
-- 
2.34.1


