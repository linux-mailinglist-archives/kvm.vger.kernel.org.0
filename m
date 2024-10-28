Return-Path: <kvm+bounces-29801-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 40D0C9B245E
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 06:37:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 64D0B1C20754
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 05:37:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7124A18FDDC;
	Mon, 28 Oct 2024 05:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0Yy84BON"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2070.outbound.protection.outlook.com [40.107.94.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B3818FDC2;
	Mon, 28 Oct 2024 05:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730093716; cv=fail; b=ndZkfL2pNL1vzUgXw1ylDzELtdH16hSw3usKb5e5DbjJl3vyn+5impPqth/1pBKUEAs5LVQzalmfLo19MfeKuJJ99yxk/0zpol+mHglKHTvtBWshifrVHKC8HxvQF9E+GnpYKvYiG8kazie7XZqyMtPTP4G6TVy2nIn+j1dQhkA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730093716; c=relaxed/simple;
	bh=3AD5OP57gikDbJufbzK/ECIIvLJM+21Q4LX4JVbbom4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Z3G1YbEoj71sBfaSsXGNs5B5nvWn3cY5wH/284+rZurLoy7ayKda5Vi7NzuSKES+nj8vaWOR0qw8AydjBpgLqIbKfrLu+yrplyy3UKNdQIrVvyVohhmURX93DCzewnbs4nKZA2HpaEpqv8viX9i0/qC4wm6NoFvqdmPywFtq6g8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0Yy84BON; arc=fail smtp.client-ip=40.107.94.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZhD8vr3sv8A8aTWCpNm1W6/jtiQP3F6NeQwYhF5HzZ3GNR6v1cuMdpPrB5FEiskm30E6bqOUXu7rRPv6oHejYwbBVStdCx2paGz7qRRCw09KwgdfVi3ER3mhTCJawLc09HhrSVPFhgYxgIgyH9Lnkit1EZZr2XAQYtnHC5+1CJdJNQJcusvCPo9SPgfK9LTHU2N1dT1Jvl8ot6obzfms+XywTLkeYoina+/vOuP1dqazbWhRSy0hY33kIXwM95ESYChvVysmdkw1ritdBrfJN9plJuoKbu7rAwZcQ+qXZXkgLia5yysbOXsK/3e4IUsRDN8MCl5/MI3Ww4ZTnGcCAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QD5+bK50oQBKpmvGXbPPwnLhvcZXVSxsa079aw40xlI=;
 b=HhHsP2zlpjxLV3DHa7JyQ8SI68iTh+S7nn6zK6aI53xvuFkKDANunfce5jGJ9aymkHVGJ9A31oKt8FXTV5CBGmPqW3BgmJSpCOQRwClKuSxGHLV5LdLtNXsq4Jj+CEePNlaOIilwmGSuCKWTIgE0i23sHH9IQnlHu8PIRMOpWV2U6kmuiMHwm8G4bvT0sSjTG1HVOdj5MNl3TqYbo9qd9lYDtOnno2aDkglnEhNdSy5D4embXEj0suLKYJ/8AnzJkB5UeoGJeDku//B4D4lh72AJVUkwVpqtxdCO2ybmXnPT+IUfsUwGAnjKZrOuxcvhrO2CQujesq5kibm1p/i0Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QD5+bK50oQBKpmvGXbPPwnLhvcZXVSxsa079aw40xlI=;
 b=0Yy84BON4XaXLRuIlNuHliThulkrM97GRmReBq5hCFD0S+rnphLwGWUS2ukH7lerVHWwIjBNM88gK90MnwuPXjpy7wIiyeutEJMbKlWlOV1LOsocuXU3sPO3ngh+kWV3TWJ4XJxRtcuCS54+rnTxs1ohbKuUXH0xdpGu5fpYFHg=
Received: from BN9P222CA0024.NAMP222.PROD.OUTLOOK.COM (2603:10b6:408:10c::29)
 by DM6PR12MB4121.namprd12.prod.outlook.com (2603:10b6:5:220::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.25; Mon, 28 Oct
 2024 05:35:10 +0000
Received: from BL6PEPF0001AB55.namprd02.prod.outlook.com
 (2603:10b6:408:10c:cafe::42) by BN9P222CA0024.outlook.office365.com
 (2603:10b6:408:10c::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.25 via Frontend
 Transport; Mon, 28 Oct 2024 05:35:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB55.mail.protection.outlook.com (10.167.241.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8114.16 via Frontend Transport; Mon, 28 Oct 2024 05:35:10 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 28 Oct
 2024 00:35:05 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v14 00/13] Add Secure TSC support for SNP guests
Date: Mon, 28 Oct 2024 11:04:18 +0530
Message-ID: <20241028053431.3439593-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB55:EE_|DM6PR12MB4121:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a997795-6a97-4329-822f-08dcf7124a22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?q/dmYFlEiyONMHuPi0h1k/Q2VMhUEETM06kM+WVn4L7UGRlmRApMssO/KCEk?=
 =?us-ascii?Q?KHDiaCAYyLTbdp9y6w3KKcAYA6vwGg5It14EyugdscfcXQxzW96R6Jy5hddO?=
 =?us-ascii?Q?bc6vS1hqmlZyd85pSO0ovlEoosptx3/OGz1MswwdArXj8LCl5KTsSSD1l0U0?=
 =?us-ascii?Q?AsZuqejwDhyJEgwZ085Ds9asP6Fzx8ezcB7gGf9HJ+F67Q//QU0OLk+Ow7TN?=
 =?us-ascii?Q?xfOlEyUaRhizFJTiTuKl+UmnZlRHyp8MEkKUEfez0GULyb78/C18mXpnXr82?=
 =?us-ascii?Q?09Qoq77lW2QtTt34IGq2v6uXzeXbDUkX6olKWb1mV1ZwNWi014hXhQWK4gtb?=
 =?us-ascii?Q?UmvAP/O2wT77y+b0GRwBwA3ypqbhLPrkejwFjJTsfqF/xf/ZVr/cOKR+hts3?=
 =?us-ascii?Q?PmXdpaCSRvRC4XDbOzH7DrQHzqVlYvFN5OKuWmrgZ4MkwWgrLvKgmivrHC0J?=
 =?us-ascii?Q?sz1LLPYiLCQNuhG7MgVR6jx3fgtrIljysoetQiNLs2OxbJRvVwC1McePKDcn?=
 =?us-ascii?Q?6cYdqaATzYs3F5Q9+ui9Ejg6PepBumjhIQ+DtpbMbh4hfrLzYYcWOVW6Dp9Y?=
 =?us-ascii?Q?DQN5JH0bJ4k65VHv1GHCGHmmXqaRmUBz8uHa2UJkQ0Q7zh7k9g/WyZDTHGA6?=
 =?us-ascii?Q?fp4DEF34AhfpKGuFDCfDVKbs3QOIs3h3raGGKXr6VvPqqtuen03OSpa5tW80?=
 =?us-ascii?Q?cTqoFN5b5RN6guCOFzSoh0X862F8NzDmOaRQwpxhHModZ9IoJ751ua7BMpbR?=
 =?us-ascii?Q?NWaQfon6eWyeX2V8YEHNb5ZkjjzCpqUjI81XtM0CU/4PmdPy37jX0ILDl2MD?=
 =?us-ascii?Q?dv7xLfSfaMP7ndX5koBW7bI5Hpx+HuWoUHElXq3BAHqvI7+UKwp7nmWWS6ED?=
 =?us-ascii?Q?Hj3I46BEfeLWP96elPx1fNtSYlcl6ENeWexHSwzGdY4o6XVPn4gsHuQtbEdk?=
 =?us-ascii?Q?PSbD0QGUgEBX2r3QiFnaASi8KTMxIy43B/iNQ38T9p4Psec5SdA2EpcJzU44?=
 =?us-ascii?Q?haA07t0nSkBK3vBYWrCZtITg4NeLickl33IiEFe6TRmIsSsHdnLYUTr+LbM3?=
 =?us-ascii?Q?Y7jc8gFq77i8m4bPVdlV+K4WiRi0pvKT1jDIMo1HL28e5j5MUjPvk5PspM72?=
 =?us-ascii?Q?gr6w3/iztV6/par7anzcLoPzEerTA7L1fUjQDBr6GjkJJhqboO3C/BMzeB6p?=
 =?us-ascii?Q?+7/pod1la+V/4ia/pp0+3fuPg/AZJUjueEE58n47442B+XbzVE3sGknJ6hgU?=
 =?us-ascii?Q?LgVJg32/VZIJ/uoVnuu3G8pixFht6s+82IRf4nQfCxxcoHzU8o5UMulPByT+?=
 =?us-ascii?Q?A5pPc9bQ4YrCVPi5DCnRMycCfbQU26xOnRGv/6KTM2JqNhqNYsYDP1KZKrn3?=
 =?us-ascii?Q?VvvUxQQ=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2024 05:35:10.4390
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a997795-6a97-4329-822f-08dcf7124a22
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB55.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4121

This patchset is also available at:

  https://github.com/AMDESE/linux-kvm/tree/sectsc-guest-latest

and is based on tip/x86/sev

Overview
--------

Secure TSC allows guests to securely use RDTSC/RDTSCP instructions as the
parameters being used cannot be changed by hypervisor once the guest is
launched. More details in the AMD64 APM Vol 2, Section "Secure TSC".

In order to enable secure TSC, SEV-SNP guests need to send a TSC_INFO guest
message before the APs are booted. Details from the TSC_INFO response will
then be used to program the VMSA before the APs are brought up. See "SEV
Secure Nested Paging Firmware ABI Specification" document (currently at
https://www.amd.com/system/files/TechDocs/56860.pdf) section "TSC Info"

SEV-guest driver has the implementation for guest and AMD Security
Processor communication. As the TSC_INFO needs to be initialized during
early boot before APs are started, move the guest messaging code from
sev-guest driver to sev/core.c and provide well defined APIs to the
sev-guest driver.

Patches:
01-02: Patches moving SNP guest messaging code from SEV guest driver to
       SEV common code
03-09: SecureTSC enablement patches
10-11: Generic TSC/kvmclock improvements
12-13: SecureTSC enablement patches.

Testing SecureTSC
-----------------

SecureTSC hypervisor patches based on top of SEV-SNP Guest MEMFD series:
https://github.com/AMDESE/linux-kvm/tree/sectsc-host-latest

QEMU changes:
https://github.com/nikunjad/qemu/tree/snp-securetsc-latest

QEMU commandline SEV-SNP with SecureTSC:

  qemu-system-x86_64 -cpu EPYC-Milan-v2 -smp 4 \
    -object memory-backend-memfd,id=ram1,size=1G,share=true,prealloc=false,reserve=false \
    -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,secure-tsc=on \
    -machine q35,confidential-guest-support=sev0,memory-backend=ram1 \
    ...

Changelog:
----------
v14:
* Make zero_key as static const(Christophe JAILLET)
* As req structure does not have sensitive data remove memzero_explicit().
  (Christophe JAILLET)
* Document the assumption that MSR_IA32_TSC is intercepted for Secure TSC (Xiaoyao Li)
* Update commit message for RDTSC/RTDSCP (Xiaoyao Li)
* Check against sev_status directly similar to DEBUG_SWAP, in case the handler
  gets called from early code. (Tom)
* Make enable_native_sched_clock() static for non-paravirt case (kernel test robot)
* Add a WARN_ON when kvmclock is selected in the guest so there is a splat in
  the guest as well. (Tom)
* Update commit message. (Tom)


v13: https://lore.kernel.org/lkml/20241021055156.2342564-1-nikunj@amd.com/
* Rebased on top of tip/x86/sev
* Squashed CC_ATTR_GUEST_SNP_SNP_SECURE_TSC change to patch where it used. (Tom)
* Fixed sparse warnings (kernel test robot)
* Added patch to prevent GUEST_TSC_FREQ MSR interception(Tom)
* Fix sched_clock override in common code (Sean)
* Added GHCB_TERM_SECURE_TSC_KVMCLOCK reason code and use sev_es_terminate() to
  inform the hypervisor that KVMCLOCK was being instead of Secure TSC.

v12: https://lore.kernel.org/lkml/20241009092850.197575-1-nikunj@amd.com/


Nikunj A Dadhania (13):
  x86/sev: Carve out and export SNP guest messaging init routines
  x86/sev: Relocate SNP guest messaging routines to common code
  x86/sev: Add Secure TSC support for SNP guests
  x86/sev: Change TSC MSR behavior for Secure TSC enabled guests
  x86/sev: Prevent RDTSC/RDTSCP interception for Secure TSC enabled
    guests
  x86/sev: Prevent GUEST_TSC_FREQ MSR interception for Secure TSC
    enabled guests
  x86/sev: Mark Secure TSC as reliable clocksource
  x86/cpu/amd: Do not print FW_BUG for Secure TSC
  tsc: Use the GUEST_TSC_FREQ MSR for discovering TSC frequency
  tsc: Upgrade TSC clocksource rating
  tsc: Switch to native sched clock
  x86/kvmclock: Abort SecureTSC enabled guest when kvmclock is selected
  x86/sev: Allow Secure TSC feature for SNP guests

 arch/x86/include/asm/msr-index.h        |   1 +
 arch/x86/include/asm/sev-common.h       |   2 +
 arch/x86/include/asm/sev.h              | 134 +++++-
 arch/x86/include/asm/svm.h              |   6 +-
 include/linux/cc_platform.h             |   8 +
 arch/x86/boot/compressed/sev.c          |   3 +-
 arch/x86/coco/core.c                    |   3 +
 arch/x86/coco/sev/core.c                | 566 +++++++++++++++++++++++-
 arch/x86/coco/sev/shared.c              |  13 +-
 arch/x86/kernel/cpu/amd.c               |   3 +-
 arch/x86/kernel/kvmclock.c              |   9 +
 arch/x86/kernel/tsc.c                   |  41 ++
 arch/x86/mm/mem_encrypt.c               |   4 +
 arch/x86/mm/mem_encrypt_amd.c           |   4 +
 drivers/virt/coco/sev-guest/sev-guest.c | 485 +-------------------
 arch/x86/Kconfig                        |   1 +
 drivers/virt/coco/sev-guest/Kconfig     |   1 -
 17 files changed, 793 insertions(+), 491 deletions(-)


base-commit: 0a895c0d9b73d934de95aa0dd4e631c394bdd25d
-- 
2.34.1


