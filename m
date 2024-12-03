Return-Path: <kvm+bounces-32898-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 61D439E1687
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 10:01:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 222452843A2
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 09:01:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F0A015573A;
	Tue,  3 Dec 2024 09:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="MC895qAw"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2085.outbound.protection.outlook.com [40.107.220.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1331AF4EA;
	Tue,  3 Dec 2024 09:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733216477; cv=fail; b=rJH/2n/CAOoR6oe8H7D+OeDQDjY5gEKi4uPkq+eucYCtEmw4ZhLlMMvw5pGvEGvMhIn3n5Dzpg+TWX53P+UkqIxjqfd9ZK3FaVBG8nntVtsNJboCPWH+/aYWH79M6TEtDfTbvHTr5xT6PFarfFf25oe1efHR4nVQYqm9YXfqugg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733216477; c=relaxed/simple;
	bh=mO9e20w1aF5/9jGIpS++09+w2zKbEA1qqI2kIx6ZCvY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=u0jUILUPed3QbuA9xwZMgVSUTxn6dxmZd7HCgkrVP+qXZdITn1oGNJJ4rrw05FdkUfdyqlSlsCqb7oE/kOocTSwE3R3sJ+bipq2OAmFdkVc2gO/Tc8n2g/aFjuJFxJElRgF2td0mB7bp0HvqJtjyjYHLe5biGUxyBVbov2W491Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=MC895qAw; arc=fail smtp.client-ip=40.107.220.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BMXwbjOYZqiB4MfJ1AcnxX0wIzJ5VHv68eMAjnbtSY+F3ESJn7O7/8kJPDeo0RJXBQxlssmKzBgWk3lcNDnfo6iotqB7ybLNr8y10qSCmcuC8JZXMgGSPWk/DPnEuGKKeqcZxCTKNujGZsWqk7ghjymjenhciUyh6CnMrnrUMVsyt3U10GXlsEFdkH0J9D51ChjNp4aeBQ0B5/P6nPCtU4uXZRFa673q9VppZbArDVZNYpd1Fnw790V4GFiAobuk5dWucMOztWIHwUENAUvgXrpHDZc03oLeRrsro+Zv2NGXVvQGUy3OnMf7/Ps5pILYvyYcfCHg9lJpE2evRssxpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b51zGWXXGIHzvMY54x2llNVZYOXPyWPbCy0L8GDpuEs=;
 b=g7lIXsx/upRv3kujK05NQ2Sa3DOTwpWkFOmtIA7Nr3/0Sj0WfhHhfh9LdL8tSC00sIN7xjQjx/6FBPLIApgJGmcCfeOthT/pL+bp4+jedfRBwqTrS08l2pPhUZX1SoKWlsfVYUrESMHLNo71N5aOQ+LzKvPsKLh+PyJuhgUE9z8gkx4IebH9uO0u2hPkj9oU/Ix7NEfSfTlfZtazkzggniS7WEHvl02dW/Al0126mi3UFYUyMLR0DSWTY8Ui46BlPpMiwxXn5C8gYjUDp0lhydzFUYV7qyMTapHJGi9Gd200ioJeMK/Qoq9ycqyhNiWmocscHewG6Pi4O7oPjt+fww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b51zGWXXGIHzvMY54x2llNVZYOXPyWPbCy0L8GDpuEs=;
 b=MC895qAwx/J0PfP26mMuHY34hSUTVhixZgAh6Mx7EIUFhcka6bHSw8Tsh6R2i3oNzByvDXA98HsaJ64K7qyd/hF+8y64MeCJWG7pYZ9/E4DG5Ugd1zHROtdWV6ZfgDag+hidejtWsJZlPsMZHAbfnwQGmFdP+GJkCdShi1oqiV0=
Received: from CH2PR16CA0005.namprd16.prod.outlook.com (2603:10b6:610:50::15)
 by PH8PR12MB7109.namprd12.prod.outlook.com (2603:10b6:510:22f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.18; Tue, 3 Dec
 2024 09:01:11 +0000
Received: from CH1PEPF0000A34C.namprd04.prod.outlook.com
 (2603:10b6:610:50:cafe::8b) by CH2PR16CA0005.outlook.office365.com
 (2603:10b6:610:50::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8207.18 via Frontend Transport; Tue,
 3 Dec 2024 09:01:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000A34C.mail.protection.outlook.com (10.167.244.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8230.7 via Frontend Transport; Tue, 3 Dec 2024 09:01:10 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 3 Dec
 2024 03:01:04 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v15 00/13] Add Secure TSC support for SNP guests
Date: Tue, 3 Dec 2024 14:30:32 +0530
Message-ID: <20241203090045.942078-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000A34C:EE_|PH8PR12MB7109:EE_
X-MS-Office365-Filtering-Correlation-Id: dfabe611-aa03-43b3-8b72-08dd1379085a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7vT5krzoIw9aocB0dWg8gTTtnM3hSdWoX47wBOu2mYWqeeTy2KOTz0MZeHom?=
 =?us-ascii?Q?o5D4w4b1wsg9YqTfcHz4QCzOKZ+x/0U4zOLZ1l9cYrTni2xa3rNTk5Tw/HjD?=
 =?us-ascii?Q?7VtTc+SAmziNhu98x1a0RJPqdkniLT4q4KTVME8wCOlH2J09xZHhH7F1qZCk?=
 =?us-ascii?Q?haDwoUgd6HvUtdBhoEeqM0anK/nM3R5QFS0mdEADic4mq7cbdHOi7Gj9ziIU?=
 =?us-ascii?Q?/q1w3i14TmNze3h+I0LxCJeNSsB4HmSLDzlGNe0bmg8xxl55f8/YJTILz/7a?=
 =?us-ascii?Q?FkcSbUfcPJ/f+/byINqzQ8LTGqk2gklJN2yPIcE61lKfv+v6ef2tywhRzRPO?=
 =?us-ascii?Q?oAXLgRm1g9KPL181rOOMRtboIRfmw3B20NmlD32U48EKH1+7FR44u80LQIVI?=
 =?us-ascii?Q?HaqFWtMfLaxW2kfoGqMCrmquv3xOiNGrEMxMQMIJwzmBAgVaY4bH12cQaU7C?=
 =?us-ascii?Q?283AY4JKS9jctG+MqnnEs5AAtpW4sk/5XePfTM+YcUprbT9LztHdlGrsXrz5?=
 =?us-ascii?Q?lQfHTq0zZMkDDuXychJ8+SfNL9lhTsqHGZ64YdO+L6CN0RW12yYUNfzI3WHx?=
 =?us-ascii?Q?zSMjEoLZtCgyjWKEOXgRA36wdROefIGZ9in6DTwgEU3OjVnpmN83zxi9kkNj?=
 =?us-ascii?Q?pQWB0dza7DgwemMWLXKgTP6iSCKBW8vIONuqqRgDwUqGsJbp+NoRH48HVrC8?=
 =?us-ascii?Q?myf39Jjxd9tfCx8iI5wAcqhIOP3eKFlm19wCNbUzneHBqHYUWtHh7xjCdSEu?=
 =?us-ascii?Q?FYzlvvkbDKV3UGANBl8pc/Elc5pQ41GxDj06w1JJTSkjn/8jhNMqDKavblC/?=
 =?us-ascii?Q?ib2aqY7kwX8AZPYf5SfBdcw9sdc7tozWGfBGugOFXk95KOm6E9vyXPv+f+/z?=
 =?us-ascii?Q?S7igug88WA20E0g96g+DzJpSCktYn8wnf7rzNI4k8Y0gfeBnz2rrF/j0Ll99?=
 =?us-ascii?Q?pOvLHpILrxBh5m6TZQjNJ4+LiPghgEDZhCvyZMv2ND0FTfx9uxIGELnTzLGZ?=
 =?us-ascii?Q?HT2XK7z3tWrvvARPLqTxykKaE6D1WZe9fVyTcmNkoOMMsk/5562v+Sn1elIZ?=
 =?us-ascii?Q?7du7Z0LfCyj+AP2bYkC9roYQItnypWZ4Mzk+5J1lWbWxtK28oU4kPZ0ayRBV?=
 =?us-ascii?Q?4vboxiU33lPMFTtMwwh6IrbXcyE9OCyUuaaK9TJfyP4CYBAa3Dm0wzC6Q0EY?=
 =?us-ascii?Q?PPeV+g1wT4ehCoWnqcZleq0LFEkEv5TXrM99amDL2PQsHe+zW/FSu1jGazAx?=
 =?us-ascii?Q?H6QkqQLUmI65JlrG2bTsNnYKSlQUa10o/JlZmkqluq+uUHVgDQa/xNAwIZO6?=
 =?us-ascii?Q?XICr1fXmcoX5QeDv3Nj8FdyqtSS7WaTjNKwJ7jR/e0usyGEgwEHS9fzHWwGj?=
 =?us-ascii?Q?ix1etVyLX8yYkA+fPvne2LHbZH80uQDmHRAfhQ8idOPxC69f2g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2024 09:01:10.7663
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dfabe611-aa03-43b3-8b72-08dd1379085a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000A34C.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7109

This patchset is also available at:

  https://github.com/AMDESE/linux-kvm/tree/sectsc-guest-latest

and is based on tip/master

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
v15:
* Rebased on latest tip/master
* Update commits/comments (Boris)
* Add snp_msg_free() to free allocated buffers (Boris)
* Dynamically allocate buffers for sending TSC_INFO (Boris)
* Fix the build issue at patch#1 (Boris)
* Carve out tsc handling in __vc_handle_msr_tsc() (Boris)

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
 arch/x86/include/asm/sev.h              |  62 ++-
 arch/x86/include/asm/svm.h              |   6 +-
 include/linux/cc_platform.h             |   8 +
 arch/x86/boot/compressed/sev.c          |   3 +-
 arch/x86/coco/core.c                    |   3 +
 arch/x86/coco/sev/core.c                | 646 +++++++++++++++++++++++-
 arch/x86/coco/sev/shared.c              |  17 +-
 arch/x86/kernel/cpu/amd.c               |   3 +-
 arch/x86/kernel/kvmclock.c              |   9 +
 arch/x86/kernel/tsc.c                   |  41 ++
 arch/x86/mm/mem_encrypt.c               |   2 +
 arch/x86/mm/mem_encrypt_amd.c           |   4 +
 drivers/virt/coco/sev-guest/sev-guest.c | 485 +-----------------
 arch/x86/Kconfig                        |   1 +
 drivers/virt/coco/sev-guest/Kconfig     |   1 -
 17 files changed, 803 insertions(+), 491 deletions(-)


base-commit: 14fd319494cbd6ae74499a56758415c5dc67691c
-- 
2.34.1


