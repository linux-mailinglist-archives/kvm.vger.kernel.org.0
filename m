Return-Path: <kvm+bounces-26798-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 563C5977E8A
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 13:37:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D3BF41F24507
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 11:37:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FFA31D88A4;
	Fri, 13 Sep 2024 11:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="C3KUrZMD"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2064.outbound.protection.outlook.com [40.107.101.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3BE41BD4E4;
	Fri, 13 Sep 2024 11:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726227443; cv=fail; b=uHz3F2Gcv1Gj5Bal4XwY1sKd4lsNepbgTLEMYWMP5aMmapGH0VthPeZxJ07yrvMW9MQNCYgsQm8I3fSXzfVV2igSoXGJOweS1/Tdvs6UBnAeUa+TwDzMq3W7gQM/zF0Ka7h+ftYzax1rw99DN+sm0hlRBi07+bx3QS55ErvwmxY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726227443; c=relaxed/simple;
	bh=bVURonVtm7IV0NVnZeNdz1p1tD1dPsSHYTb0wv/Uzz4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=fa9rW+YYgObdGffAL35zJiMitfy1WGyiPca02QnrpwF4YLch57ckWPAlBBGwUyc/uKUGQzZgZele+/A71ct3M5PqllZO3KWJhelW0sjICQRCweaELszHMUGSkcJo22CX5QkiLIb0yL3f4sNcNdTMkou3h2aFAmQf4lsNwmIs0FU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=C3KUrZMD; arc=fail smtp.client-ip=40.107.101.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Nt+ge3iUsJe6auWt4kkF415qDtT4Ao82ScgxCPyLp4/jOUWZgnGL954Y8L6+Klzwa/8JOj2K5hrViW1Xg1daZ31z79bhYIqluon/JZiRX6uV+1eAqzKwrNwr9t7fQw3uSX+0PC4AtoETTdNOdDGTe8QORSm/JaWq4zF975j6aQ2b6r6n1w9Ber2H1OWddQT0ZG6gn4uxm7PLb2N0eX7AbCl51l2B4RiNJslc+7OXSBIOXx/YAk82q7yjIKr0gya/ZA1u89W8gnV7ObbiKsQas9mrD1TUnERS0JNsEQO8GSMuD0Ggin2HcUHXTncCuecpgZNgDbmU6Cf62iQUJP8KFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J26oDHzt6tzKi4hVB5HtfZf4vQwziwSnIBeo2awrIJ8=;
 b=RpWyDxFDO7SeIUV3y0FQqkzklI3RULsj67iqkqlA1TcuhjCgPeNRlRbkmv4opnfVLMKrMLoBY8CrTUUJpXKXqpN5TfyxbnfUNCspJbhVl7u9gdJrkHISYVwR6o9HF/Mj18Z7nCD8vLGHAkOECrigByMfC25Sd8w/VbZU2Z0p4jOcJSwV3t6d4jmyC7KewnRmTCWASm/GGw/UazVXfrn8OeesD5p//tEkhAC1dkNt5/LhDDxwZ2lfdMrzuohwwiUyW30Sj/NeOy3DtcW/ugG4fvAtZ4OvriH2NQoJp2QX9zkUNwZu4Z4X6NU/3eI1nqz7gEX8+jFccP+ocf6GqOlWOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J26oDHzt6tzKi4hVB5HtfZf4vQwziwSnIBeo2awrIJ8=;
 b=C3KUrZMDoWMWGk1ZIWEmBpR3Q+SwFm2I7KHRkScAG52kqTLIE4tyKNqAf548pJpxQFMS8W29fwAVfY8kstSFtj3tHaYWGRIHsno91GcVb1FOTJDc4+97BLYZ2WR1JQCVpoLIWkUWwTYu8tOyW2InU6Bld2FkRNGfe7EiJq/kB20=
Received: from LV3P220CA0013.NAMP220.PROD.OUTLOOK.COM (2603:10b6:408:234::34)
 by SN7PR12MB7252.namprd12.prod.outlook.com (2603:10b6:806:2ac::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.25; Fri, 13 Sep
 2024 11:37:18 +0000
Received: from DS3PEPF000099E1.namprd04.prod.outlook.com
 (2603:10b6:408:234:cafe::24) by LV3P220CA0013.outlook.office365.com
 (2603:10b6:408:234::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.24 via Frontend
 Transport; Fri, 13 Sep 2024 11:37:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099E1.mail.protection.outlook.com (10.167.17.196) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7918.13 via Frontend Transport; Fri, 13 Sep 2024 11:37:18 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 13 Sep
 2024 06:37:13 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <dave.hansen@linux.intel.com>,
	<Thomas.Lendacky@amd.com>, <nikunj@amd.com>, <Santosh.Shukla@amd.com>,
	<Vasant.Hegde@amd.com>, <Suravee.Suthikulpanit@amd.com>, <bp@alien8.de>,
	<David.Kaplan@amd.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<peterz@infradead.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<kvm@vger.kernel.org>
Subject: [RFC 00/14] AMD: Add Secure AVIC Guest Support
Date: Fri, 13 Sep 2024 17:06:51 +0530
Message-ID: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099E1:EE_|SN7PR12MB7252:EE_
X-MS-Office365-Filtering-Correlation-Id: e9057a7d-be9a-429d-ad31-08dcd3e86c67
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UpNbUR5NabZfpWJU/Uf3NyXzpynwUQtW7jY3bx3Fw+GvE+UF8bowGiOh+uhF?=
 =?us-ascii?Q?0m+M1EaivmgILnBC3xHiP1aHhk0+1oWFeom5ETezLPSHBIgerpNWW/5kPrdl?=
 =?us-ascii?Q?tmip7E/x1B9H75Qf7oSnaL7M+8Zg4F8oBvhj/b8fxadRWcdYZx/MixWdr9Zt?=
 =?us-ascii?Q?wA2151Y6jBU+ztUXQG0jEIOyaiexX8Y2iIvHqzQnIOuuiLPAvTyaW7yXKkGE?=
 =?us-ascii?Q?CiR45UIHTbWqB6GfAqhUe4UhyYVjlAKcS8OUBlaC+MQnvfOetggoIADMhvwY?=
 =?us-ascii?Q?L6WbUhB90kBol9UVq3vj7si8TJFfXIwGIdlysHBIoppAwvpR98kDf53sWPAz?=
 =?us-ascii?Q?KuXv7t1OxdHyAdruGRheqa6LBt6r29PJ796RrTs3+lCcn2XJYmjSJnUWr+7e?=
 =?us-ascii?Q?/poHl1pWNNeHHozkK6yCCmzF8QdqDZgfSxdIQXVqz/xsiAjFsJ7Ihf+2fpGt?=
 =?us-ascii?Q?KKVqYNH/+eI7NAK7Pr2pFStTK4Nlt92ypVWCUA43nDRSAxIq4UTcD//g4kY0?=
 =?us-ascii?Q?fmjgiNnIAIyHnIoN9NbUWqNEKvOIn/yBuzfzRVVHkWJ88olrQxlTv9sKh1Vw?=
 =?us-ascii?Q?oUUpV5BxguBRwkhHvn3VtVlhDNBGKqcjpxJa1kcdPc1A7bcb+UdJ8vEpIjWi?=
 =?us-ascii?Q?1/h/bVmDnLiL+rJXSHdqm9OOakw9Kd9SaqHlhvAn/qdiAXte6BLZ6Jb7I8ac?=
 =?us-ascii?Q?qhp8kBu1/mo7Bk03LWzUSQaVqZJ2ULGwa+4vD4BQvaiCxqBE0nrugi7+gj2t?=
 =?us-ascii?Q?EhUC1Qvml52Cy8SkKw7R5W0EbSFnU0/qZpwERqafgpbCC99H1c7QcEPXZqo3?=
 =?us-ascii?Q?LvFZS3rarJVJCbqmUfTMItu+xpX+ccpL3SVy6He3ESkY6SOqdsbsGLaD5IF9?=
 =?us-ascii?Q?noFUGXECmY7t+95OsYzUv/zWnyUp9iRY1o8RUz7URH0irTXmk/pTZHT6wo1+?=
 =?us-ascii?Q?mRY9EHjOiYK5kLEcv3tg/uSpQqN6PORbOAPjKJaaVnAftWCdG1WrfpAzpZ/R?=
 =?us-ascii?Q?J5JqqXRzOeF9ATFK12q0guRnUOVkF4hqEESLMZv33Hbke+/f4bH6CDijaXyj?=
 =?us-ascii?Q?yI+7rcjr0zR24u9l1Ak0Jmv77KdfaH4TRfKo8wYYAWmzw6AqRBELH2olb7RU?=
 =?us-ascii?Q?DU/cXs8CiyN/qUI/uBi9ul49L3UcGrUfdHYSV4oI37edDt8iweBB7OebgeiK?=
 =?us-ascii?Q?pnwhQHr/Ig2ECkgMWMKZc0J7rjvRVe49rES2exRvNqRBfVevv0h3kDj2KTCE?=
 =?us-ascii?Q?RBA0+4FIgbM2FF4s5aTIeM1gR0/NV0EjXlIiPUqColFPiltejM7TGEpNNO4S?=
 =?us-ascii?Q?rMHtA3J0omoduAl8Wc0LEzx4vo61klundHENUx692bQeyZOQ9Eux5hpnTxxn?=
 =?us-ascii?Q?maJNmW/HJXqsvn6UKmfB8FPf7s+M+4BRybo1c4bI+Nh/YmsKABiYLG6gdvRY?=
 =?us-ascii?Q?mu2xrmhl6mE+O2csadcBw202FtUqKorD?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 11:37:18.3281
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e9057a7d-be9a-429d-ad31-08dcd3e86c67
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099E1.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7252

Introduction
------------

Secure AVIC is a new hardware feature in the AMD64 architecture to
allow SEV-SNP guests to prevent hypervisor from generating unexpected
interrupts to a vCPU or otherwise violate architectural assumptions
around APIC behavior.

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

ALLOWED_IRR vector indicates the interrupt vectors which the guest
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


LAPIC Timer Support
-------------------
LAPIC timer is emulated by hypervisor. So, APIC_LVTT, APIC_TMICT and
APIC_TDCR, APIC_TMCCT APIC registers are not read/written to the guest
APIC backing page and are communicated to the hypervisor using SVM_EXIT_MSR
VMGEXIT. 

IPI Support
-----------
Only SELF_IPI is accelerated by Secure AVIC hardware. Other IPIs require
writing (from the Secure AVIC driver) to the IRR vector of the target CPU
backing page and then issuing VMGEXIT for the hypervisor to notify the
target vCPU.

Driver Implementation Open Points
---------------------------------

The Secure AVIC driver only supports physical destination mode. If
logical destination mode need to be supported, then a separate x2apic
driver would be required for supporting logical destination mode.

Setting of ALLOWED_IRR vectors is done from vector.c for IOAPIC and MSI
interrupts. ALLOWED_IRR vector is not cleared when an interrupt vector
migrates to different CPU. Using a cleaner approach to manage and
configure allowed vectors needs more work.


Testing
-------

This series is based on top of commit 196145c606d0 "Merge
tag 'clk-fixes-for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/clk/linux."

Host Secure AVIC support patch series is at [1].

Following tests are done:

1) Boot to Prompt using initramfs and ubuntu fs.
2) Verified timer and IPI as part of the guest bootup.
3) Verified long run SCF TORTURE IPI test.
4) Verified FIO test with NVME passthrough.

[1] https://github.com/AMDESE/linux-kvm/tree/savic-host

Kishon Vijay Abraham I (11):
  x86/apic: Add new driver for Secure AVIC
  x86/apic: Initialize Secure AVIC APIC backing page
  x86/apic: Initialize APIC backing page for Secure AVIC
  x86/apic: Add update_vector callback for Secure AVIC
  x86/apic: Add support to send IPI for Secure AVIC
  x86/apic: Support LAPIC timer for Secure AVIC
  x86/sev: Initialize VGIF for secondary VCPUs for Secure AVIC
  x86/apic: Add support to send NMI IPI for Secure AVIC
  x86/apic: Allow NMI to be injected from hypervisor for Secure AVIC
  x86/sev: Enable NMI support for Secure AVIC
  x86/sev: Indicate SEV-SNP guest supports Secure AVIC

Neeraj Upadhyay (3):
  x86/apic: Populate .read()/.write() callbacks of Secure AVIC driver
  x86/apic: Initialize APIC ID for Secure AVIC
  x86/apic: Enable Secure AVIC in Control MSR

 arch/x86/Kconfig                    |  12 +
 arch/x86/boot/compressed/sev.c      |   3 +-
 arch/x86/coco/core.c                |   3 +
 arch/x86/coco/sev/core.c            |  91 +++++-
 arch/x86/include/asm/apic.h         |   3 +
 arch/x86/include/asm/apicdef.h      |   2 +
 arch/x86/include/asm/msr-index.h    |   9 +-
 arch/x86/include/asm/sev.h          |   6 +
 arch/x86/include/uapi/asm/svm.h     |   1 +
 arch/x86/kernel/apic/Makefile       |   1 +
 arch/x86/kernel/apic/apic.c         |   4 +
 arch/x86/kernel/apic/vector.c       |   8 +
 arch/x86/kernel/apic/x2apic_savic.c | 480 ++++++++++++++++++++++++++++
 include/linux/cc_platform.h         |   8 +
 14 files changed, 621 insertions(+), 10 deletions(-)
 create mode 100644 arch/x86/kernel/apic/x2apic_savic.c

-- 
2.34.1


