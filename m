Return-Path: <kvm+bounces-42300-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 29788A779A9
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 13:36:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 09CC57A405D
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 11:35:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83ED21FAC54;
	Tue,  1 Apr 2025 11:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="IMHu1QQr"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2048.outbound.protection.outlook.com [40.107.243.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E04271F03C1;
	Tue,  1 Apr 2025 11:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743507400; cv=fail; b=BpteMqFndykx15qwTLRH9xMq38TS9YOKKzgO+7lMjuZSv2+UnWOlpyxBkCVOS7/jFKPWz+e3S5+GfDZR16b0dT/8zUSk/xu+aijObUSoRPm1q9Tb29tJOPihJXyxXhBbp3VJVL0c1+s+Py7NAWzANJLy/kgciVUg7AghR0sfy/Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743507400; c=relaxed/simple;
	bh=ZBEs4DrvZcj2rJcRZquG2NbQMRUuZJKlO5wOKmjmyog=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=k9PK+diXCJOxPlyo6RA0KzlpSmEHdOkX4gGQo0kmrC4sU6fZ3sSSWBwdX3nWKY4x901bbXyNamdOCD57pdALilMCSZmoWfH98k4OudG/Lu//tm7ICMn5GpTxBEybx4vC83kP1+Z25K2TB7UysTK93YVEL3wWr6soCTYBvBFOqQU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=IMHu1QQr; arc=fail smtp.client-ip=40.107.243.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TA0sIX84HrEU7sSrGJocV5ng18oaJgQi+LIqZcY4yLjURCEU5OO7dYE6EyacnR6winyddaXLdGJ9jtIByB/tatot9F8X3bVOu9OXOFPiU0wHBkR1jpSodx8M9FOp5g3kGaIfcVH9O8pxa/+Th+houjX9hNvcdzWrVfmeOe8gJaYFfDkJv0Ti5r6sAZqs8Y4aGj2rdvVUB480yF6nnUpvbdeAPNJnG23RJI2yf6E4uuPg9icDi1YUc35NR9YD76sqhIXj0RTnRFeO90NaZmq10j3+EGVVdgtU/J0U3pHDwVegfEnQDRwEJDBieNlPhH2FuibpTzV5KLIR05zayWvLiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Btu+kqAjPDoC2yJLNfHu8JcRso5UMZ3+YVn8I8dIi+Q=;
 b=qh+OgC/pPkGp5bq2WnSj09PgRrBfA1Yuc+EbtLmdgVVdaByfJ5vqelzO3IUG/fBCDsNLxSSHSLI4cIAXC1+V1FstKrznhkhCLZvqn0rjknvIEY8G/bKLaxGEYfj0CR1aYp80qMUNmUxhqfwp6oNNw1oSno/vUOEhtBGulBu8JsEW/pevgdLf9d1ZBtcFoG/QkgyphDdTn13rVgEOdrr4KTftVNdaRKJ5u+++UWJlsKvZ7UgcELTgQezDIcDm0rJVXdvUqkR/wIar3lZZIEWuzCrffAjt1vG7ZIyYRFrWLJV4XNUczDujWEO2o4s9Ricug+x+g9UfNjmllhUcGR5F+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Btu+kqAjPDoC2yJLNfHu8JcRso5UMZ3+YVn8I8dIi+Q=;
 b=IMHu1QQrQhIDxJo9kkObFx72D/gQbN1RpYyNnkXiPMmdGjUA4MzGzeMAw9s3ktPKMG1FAkWkijUlbL51SlqxZOaH+szVF2BKJgewYezN+A5t75+Izic1vDv5t5gA8wLxbiVj+9T4wStr2jhGZtYb7dL6drP7hwSAanCSNfZ7858=
Received: from MW4PR03CA0022.namprd03.prod.outlook.com (2603:10b6:303:8f::27)
 by CH3PR12MB8403.namprd12.prod.outlook.com (2603:10b6:610:133::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.47; Tue, 1 Apr
 2025 11:36:30 +0000
Received: from MWH0EPF000989E6.namprd02.prod.outlook.com
 (2603:10b6:303:8f:cafe::f4) by MW4PR03CA0022.outlook.office365.com
 (2603:10b6:303:8f::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8534.52 via Frontend Transport; Tue,
 1 Apr 2025 11:36:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000989E6.mail.protection.outlook.com (10.167.241.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8606.22 via Frontend Transport; Tue, 1 Apr 2025 11:36:29 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 1 Apr
 2025 06:36:23 -0500
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
Subject: [PATCH v3 00/17] AMD: Add Secure AVIC Guest Support
Date: Tue, 1 Apr 2025 17:05:59 +0530
Message-ID: <20250401113616.204203-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000989E6:EE_|CH3PR12MB8403:EE_
X-MS-Office365-Filtering-Correlation-Id: 578ca4c5-6593-40c6-688f-08dd7111722b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014|7416014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+AwRFxvJhRWoXpZ877FS5Xk5EPvJM47+k35TeTJtRRtr06FvVBuZvpmni0Mk?=
 =?us-ascii?Q?rYnOUmpOtL43jxRvEATMsiRsjM8YjJeTaMqKnGo/QjQDNxoYRbNBWBwSdKg7?=
 =?us-ascii?Q?+GH2SVtI+reRr6N9ObWN75dWBcfIVCQ1orEoi8BwzVS1sO+JtotyoX1UYaDu?=
 =?us-ascii?Q?6bpMAMVuTARx6+xZJb0MFdekTWXt8Sp1AjoKKlS4a8hDgU4kvwMk1iqC2WoB?=
 =?us-ascii?Q?tKf1a78xFuVrDJBvQmJLL3OPTr19dvsSLg6VeEWRs6F+AZ+d9QMbO75Yx/LP?=
 =?us-ascii?Q?QTkTB1xkpkmGLgTLLb2mFVF4rOou9IiQY+RDVfUljRqea7wK6UEncP9IurvB?=
 =?us-ascii?Q?r3oEDyRzMLCKOCqYULKXqtzfJWYV4httZSoP/0YQiwJM1g1dMzQSUB9sOh9W?=
 =?us-ascii?Q?Nb4gnhBCc0FwUKNjMgetZ58iD6SRi2WsVHvd/oqzq+b+mYMIcT7FBGrJSDmp?=
 =?us-ascii?Q?JwQICD3pS8rYj1iCCy7kCqHSrojjKyAuIipDtMJtsqdwH8yBdSQ7v2IBqIcE?=
 =?us-ascii?Q?zLmJjA9TVuJCmNHSq6ijtKbkTDrMLIbbGjeLuBnEkOAMVB1LgBN18rXkSl0i?=
 =?us-ascii?Q?muzOo92xmc42ffB+myzqedadxMwRfqSrd2zvvDnjxzKGZfL4+Xb0rh6vVOYq?=
 =?us-ascii?Q?LBAo75VI7gZj8OxLGiXoNt+bcylasdHsSmTxjf+jrCCueKqlSRrS67vS3HuV?=
 =?us-ascii?Q?1WB/jjJZlOHaKYrBUCvAG8eukOPX9s+nQ+GNBsoZWpad7R5yMqlnhtTZsMUK?=
 =?us-ascii?Q?FVgNaKWvjw7mM4HpA0oZQsaRRnxf/PViwF8ZoJCf9OcLufzZZAeQGt2m5+YU?=
 =?us-ascii?Q?2JazLhKXIq5Qxqa5Hn5NN5A8+CVZOwkzOETJS1bLLk6/t73z8MrDaaW3kbcc?=
 =?us-ascii?Q?bNT613uZapc2OVd1jCRJ7CqsReY5lbPFFBcR29ilIu/CZ4UDdai2/F4PmldH?=
 =?us-ascii?Q?jCZ3w+eXHHOhAl8YO92Nx7psbDWys5RYyhLIpm6avoGhGZjYa0+knaWVyzXb?=
 =?us-ascii?Q?vs+vbCRZZdpkOCQVkdbnaEhMmWO6Ii5n1aonn/ngZ9UrLfgJpkxNEBNOyxvA?=
 =?us-ascii?Q?lMXn60vSsz2fRV9CD4RsiSlggjia/V+8gNKv2rSZNT7mqXWObXquciUlsqTj?=
 =?us-ascii?Q?IDPrV6/oP3Etnzwliz2dBooM7+NFhJpyTWqlb3rH8PLJ2MhiiDMmdPR55WVN?=
 =?us-ascii?Q?yAeFxTN/zPP/dY/OAiZ3RInHZzGZxfBoCzr9X7vl3NHQShj5cR5huwNbwLU+?=
 =?us-ascii?Q?RWftbQOgsjiHssYaK5t9G5lZW11fY8ajVy6vjILjXtAU/kQLalYHxQribauI?=
 =?us-ascii?Q?V9y1bL1FxWDK5ZgDYQ2xztm3XAVRAgtCJzJnDFi2eDFVl0DxR7dMvGmVeOVb?=
 =?us-ascii?Q?7FlaR1dsd00br0ssD8WIVoPtdgls6oQqdlvArYeiHmhV4331GVPunsoDBuOI?=
 =?us-ascii?Q?GY+ltevNUrcriKCiDMTSXnuZkECAHIHnqKGeaK82gp017mNIkASUbmt81Pic?=
 =?us-ascii?Q?RAp7ykPZAIS2ebM=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014)(7416014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2025 11:36:29.8902
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 578ca4c5-6593-40c6-688f-08dd7111722b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000989E6.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8403

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

This series is based on top of commit 535bd326c565 "Merge branch into
tip/master: 'x86/tdx'" of tip/tip master branch.

Host Secure AVIC support patch series is at [1].

Qemu support patch is at [2].

QEMU commandline for testing Secure AVIC enabled guest:

qemu-system-x86_64 <...> -object sev-snp-guest,id=sev0,policy=0xb0000,cbitpos=51,reduced-phys-bits=1,allowed-sev-features=true,secure-avic=true

Following tests are done:

1) Boot to Prompt using initramfs and ubuntu fs.
2) Verified timer and IPI as part of the guest bootup.
3) Verified long run SCF TORTURE IPI test.

[1] https://github.com/AMDESE/linux-kvm/tree/savic-host-latest
[2] https://github.com/AMDESE/qemu/tree/secure-avic

Change since v2

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

Kishon Vijay Abraham I (2):
  x86/sev: Initialize VGIF for secondary VCPUs for Secure AVIC
  x86/sev: Enable NMI support for Secure AVIC

Neeraj Upadhyay (15):
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
 arch/x86/coco/sev/core.c            | 131 +++++++-
 arch/x86/include/asm/apic-emul.h    |  28 ++
 arch/x86/include/asm/apic.h         |  12 +
 arch/x86/include/asm/apicdef.h      |   2 +
 arch/x86/include/asm/msr-index.h    |   9 +-
 arch/x86/include/asm/sev.h          |   8 +
 arch/x86/include/uapi/asm/svm.h     |   3 +
 arch/x86/kernel/apic/Makefile       |   1 +
 arch/x86/kernel/apic/apic.c         |   7 +
 arch/x86/kernel/apic/init.c         |   3 +
 arch/x86/kernel/apic/vector.c       |  53 +++-
 arch/x86/kernel/apic/x2apic_savic.c | 467 ++++++++++++++++++++++++++++
 arch/x86/kvm/lapic.c                |  23 +-
 include/linux/cc_platform.h         |   8 +
 17 files changed, 742 insertions(+), 39 deletions(-)
 create mode 100644 arch/x86/include/asm/apic-emul.h
 create mode 100644 arch/x86/kernel/apic/x2apic_savic.c

base-commit: 535bd326c5657fe570f41b1f76941e449d9e2062
-- 
2.34.1


