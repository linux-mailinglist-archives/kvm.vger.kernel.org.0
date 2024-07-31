Return-Path: <kvm+bounces-22772-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 031239432B8
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 17:08:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 29DFA1C21DBE
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 15:08:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0085814A90;
	Wed, 31 Jul 2024 15:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="IvHEeFcq"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2063.outbound.protection.outlook.com [40.107.101.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D24514AA9;
	Wed, 31 Jul 2024 15:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722438516; cv=fail; b=EO1rbGzN9x/rMjAs3voAWA2n9bGcr3rr8mHscZ/cc2I2qVXQYNII5NzVlJY8pYeDZNnpYZkZmIFrOPFSnLKEN/yJWZZa94iQgw+MXvceUkcTTOzVwqMwZQOymjn4u/dnYIdmoOFsaqNirO/xq22qV07NsMqEr82plWBEgZiBIOA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722438516; c=relaxed/simple;
	bh=k3OVrzdNn2YACmzLCAEiCzBGGLNRTrb4t1kzWti4uL0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ikHqJDTNKftUzjhVmFFiNTjrSrhiFCWrjlq1Kj8ri1M1P2l3/pKjEwq+VnTAGIFqU3FkLDiZ3IDgFTgO/xrz1pJWNxVAbAbhHK4B7WTr5I66LVF9eTPSsQfkGB0KEy85DYHpj+dEq8o1juRLz3+LvaKfatWURcvGDHY1gyjxwa4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=IvHEeFcq; arc=fail smtp.client-ip=40.107.101.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gp9Ah6rTGrGvz4qHU9uFNORIX1VLrthRGvcHsrumkIqY9EZjxplrT2FsHXhgVEpwUvTU5Qh1KyzMqGBpg4/Sd5eA/YvGemavvXS54bua9gotat+Q9bovY3f8mYEpOmfP0drDrJX7rr3MdqRaHvpIUARDvMrmTPEL0qKi931C0QjJRtIedjsoSrzrdND1TQZRagZ7xkvU85kPZMIJ0BaB/N+7Lhn1FodMD3Eaijkz12xMDh8PcrGc7G4Au+HQIQC8aF8R5TZNeueuaV4kYPS2TisEynAX9HObeWt7amq6AURoygnV+04cl/jnp7SBa07YY3zvuIpOIMTEwc33svyxDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z2U4RTgJGKOSkKa2WJoEOGmCb7lzpV5pfqIotxHFEuI=;
 b=OKs1ZHXUgHUeLQRm7HUAXYNzWqFZrrv7U77QlRaYHaAuZyH/OPWC3IWWX17ZZ+cBlBWCh8gTEwl0R+qQoP295I+WDrJ73T7jEeK6YhYQJBO7MG5QdZa7rN3tUV9MWnp4owhyqpvkmEVZq7vAS7x3eG/nvBooMDak5HYb+YJTnMYwCHJKDnulqYmjzcPMFJW+LAQ20GQKH0nj1mAoEDtFhjZjHr9utJeoQ0Lpdu/hwoOWHkGPlwJe2wb2O4vNxijIjAE2kZgX6HTucwIGPl2tg+8ix67ie7e+dQmIw5xu4hFkB2CL/zt50jAfRijd6yOCFuzmxYTuWSUr8RScUyIHcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z2U4RTgJGKOSkKa2WJoEOGmCb7lzpV5pfqIotxHFEuI=;
 b=IvHEeFcqjA6pwWafzDtNzOOOuidrGH3XSCE5Jhl/W2VBMSxDyJwSgGWxqkGGiEN8+7Q2ilFv1MpwoTH+l8Qc3bI+DkjueNGesJ2DvXsARyIHbda1/ENBonEQzlFjjGPI9jNtHLwrApnNJDbowFIclTE+5leCP0XHLJ7kQ/mcnoU=
Received: from DM6PR13CA0028.namprd13.prod.outlook.com (2603:10b6:5:bc::41) by
 CY5PR12MB6034.namprd12.prod.outlook.com (2603:10b6:930:2e::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7807.28; Wed, 31 Jul 2024 15:08:29 +0000
Received: from DS3PEPF0000C37D.namprd04.prod.outlook.com
 (2603:10b6:5:bc:cafe::59) by DM6PR13CA0028.outlook.office365.com
 (2603:10b6:5:bc::41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.23 via Frontend
 Transport; Wed, 31 Jul 2024 15:08:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF0000C37D.mail.protection.outlook.com (10.167.23.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7828.19 via Frontend Transport; Wed, 31 Jul 2024 15:08:29 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 31 Jul
 2024 10:08:25 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v11 00/20] Add Secure TSC support for SNP guests
Date: Wed, 31 Jul 2024 20:37:51 +0530
Message-ID: <20240731150811.156771-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37D:EE_|CY5PR12MB6034:EE_
X-MS-Office365-Filtering-Correlation-Id: e9a35a9c-9c02-46f8-d29e-08dcb172a2ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0Ah3Z+019HdJY1XM3QEcWPB89XcV1AmXI+ACd4tOQlp1wqcgCBircABTmpSf?=
 =?us-ascii?Q?MzYjK41fKI9N7L0gS1ehPnF2TJlgP7ThSlEiu+lZfValOiyqhteiN33CNF/J?=
 =?us-ascii?Q?c4ykFmRHVd2TQ7hUoo+IrOn6LZOULZQtz1qLZcocvczlSAivk4cMGXaRKBWE?=
 =?us-ascii?Q?t3SvR3Fxf2fcRC7ZH6bGO4yHyDwmJLmIts9Uy3FZgjcp0YjekxBiiI0ESUjh?=
 =?us-ascii?Q?UAV9ucT4mGCbxIHeWsDE/KFME6SQ62XgS6xHr4WL7OIKeGgrNIeNkDzkanZ4?=
 =?us-ascii?Q?jn/7SSNYPw7nyg/nwuWg6WZc0/OwTf9vkUaUoSzRxjiL8j+RzHBZTuEPTTmh?=
 =?us-ascii?Q?1JELbAjLrZc2iBYGv4Nxy11U/ujM5Wvq7KUeebFXX+ccSZ7JN1QU2Wup0UnJ?=
 =?us-ascii?Q?bqGGVIXZsZt6c7qojrxPFGxwmQ8k7pKhhcyTvYiHilD2Js+5769ti7su1Ugp?=
 =?us-ascii?Q?zEKC+mLQQtFHzxdmAvSWCFA+r8RKS4j3Aq3OK74GFOhVnkhXuGmCB5zCO599?=
 =?us-ascii?Q?rgfWNvfnd0PLtak9+XCT83ULmWKkxzB6JvOluf9jXlena9TbW0vgnubm8gda?=
 =?us-ascii?Q?4tJrjQwXi+h068XQJVP0QGY1Vgw3sESDLMZg7qWrB19/NV9nlMliqwiztmvA?=
 =?us-ascii?Q?VhJheC4HasVy2K/quwR3hIXzv8CnnKQWd5V2dBjG/5HeGKiAnboNraM54983?=
 =?us-ascii?Q?ruPWpHdSkBFy9c0EPpUlwSTDGF0YfQ1EXcJO5kOTJwS9f0bi67gfmuXkaYzT?=
 =?us-ascii?Q?6TuBpEDYHTZBdaB2zxtB7hqyUxnFnLRaExG0+5qHUvTf9iHpkgEYJx1i8ECM?=
 =?us-ascii?Q?B/QCbdfrUbI6jziLA9+cQ7mnWkwOHBAVBOxfGtzyWRXCHAEGV8rvRNxWurEu?=
 =?us-ascii?Q?eTVHvMRakz6R6WhkgYgcWr+rdGu7Z/n8ow+w3WmFaDAWlY1F765xJEK/vX6F?=
 =?us-ascii?Q?w8X5qF2Ube5lDJv7EoULL4JmJqd6inEoi1+pbbmud4pmdtP4RyVpJJZunX40?=
 =?us-ascii?Q?R45ja5iNot/0T6GSm6xShT9oM2Ibfg6IxA0xoZ9rVyTtPCneNE95axCbzvXB?=
 =?us-ascii?Q?TD2lUFCYMSresKM9aXskE1Ds2j33SngqxcVe2duizIXaL0dAxMbdYjwB/Mak?=
 =?us-ascii?Q?WAzHRNrQUbm480+NuKJWki5t8UiEsGhyDNv+Ilh/ZoH+xgEMfBTGR2VTiyy3?=
 =?us-ascii?Q?cisXeQzTrZ+FkvLEKxpnj993S5CGmqH9Z6Pt248yjIuu0LgVdbuPUHEfohlE?=
 =?us-ascii?Q?2vbJMToHnY4LOUU0kOQcD6AA8MHdJ8mJdpNVJE9SvrTgNCD7PmiwLZa1pj/O?=
 =?us-ascii?Q?jIR4nSPTL1hARirNWMa5G4dDGRKUpDecvgYX/GFW61xSw6SLmLegY+sbieBq?=
 =?us-ascii?Q?s11qgzcVtAP0/GOnkaSo5CB5mMOrVU7PR20wE3TzwPDZSIvgTQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2024 15:08:29.2428
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e9a35a9c-9c02-46f8-d29e-08dcb172a2ae
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37D.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6034

This patchset is also available at:

  https://github.com/AMDESE/linux-kvm/tree/sectsc-guest-latest

and is based on v6.11-rc1

Overview
--------

Secure TSC allows guests to securely use RDTSC/RDTSCP instructions as the
parameters being used cannot be changed by hypervisor once the guest is
launched. More details in the AMD64 APM Vol 2, Section "Secure TSC".

In order to enable secure TSC, SEV-SNP guests need to send TSC_INFO guest
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
01-04: sev-guest driver cleanup and enhancements
   05: Use AES GCM library
06-07: SNP init error handling and cache secrets page address
08-10: Preparatory patches for code movement
11-12: Patches moving SNP guest messaging code from SEV guest driver to
       SEV common code
13-20: SecureTSC enablement patches.

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
v11:
* Rebased on top of v6.11-rc1
* Added Acked-by/Reviewed-by
* Moved SEV Guest driver cleanups in the beginning of the series
* Commit message updates
* Enforced PAGE_SIZE constraints for snp_guest_msg
* After offline discussion with Boris, redesigned and exported
  SEV guest messaging APIs to sev-guest driver
* Dropped VMPCK rework patches
* Make sure movement of SEV core routines does not break the SEV Guest
  driver midway of the series.

v10: https://lore.kernel.org/lkml/20240621123903.2411843-1-nikunj@amd.com/
* Rebased on top of tip/x86/sev
* Added Reviewed-by from Tom
* Commit message updates
* Change the condition for better readability in get_vmpck()
* Make vmpck_id as u32 again and use VMPCK_MAX_NUM as the default value



Nikunj A Dadhania (20):
  virt: sev-guest: Replace dev_dbg with pr_debug
  virt: sev-guest: Rename local guest message variables
  virt: sev-guest: Fix user-visible strings
  virt: sev-guest: Ensure the SNP guest messages do not exceed a page
  virt: sev-guest: Use AES GCM crypto library
  x86/sev: Handle failures from snp_init()
  x86/sev: Cache the secrets page address
  virt: sev-guest: Consolidate SNP guest messaging parameters to a
    struct
  virt: sev-guest: Reduce the scope of SNP command mutex
  virt: sev-guest: Carve out SNP message context structure
  x86/sev: Carve out and export SNP guest messaging init routines
  x86/sev: Relocate SNP guest messaging routines to common code
  x86/cc: Add CC_ATTR_GUEST_SECURE_TSC
  x86/sev: Add Secure TSC support for SNP guests
  x86/sev: Change TSC MSR behavior for Secure TSC enabled guests
  x86/sev: Prevent RDTSC/RDTSCP interception for Secure TSC enabled
    guests
  x86/sev: Allow Secure TSC feature for SNP guests
  x86/sev: Mark Secure TSC as reliable clocksource
  x86/kvmclock: Skip kvmclock when Secure TSC is available
  x86/cpu/amd: Do not print FW_BUG for Secure TSC

 arch/x86/include/asm/sev-common.h       |   1 +
 arch/x86/include/asm/sev.h              | 166 +++++-
 arch/x86/include/asm/svm.h              |   6 +-
 include/linux/cc_platform.h             |   8 +
 arch/x86/boot/compressed/sev.c          |   3 +-
 arch/x86/coco/core.c                    |   3 +
 arch/x86/coco/sev/core.c                | 590 ++++++++++++++++++--
 arch/x86/coco/sev/shared.c              |  10 +
 arch/x86/kernel/cpu/amd.c               |   3 +-
 arch/x86/kernel/kvmclock.c              |   2 +-
 arch/x86/mm/mem_encrypt.c               |   4 +
 arch/x86/mm/mem_encrypt_amd.c           |   4 +
 arch/x86/mm/mem_encrypt_identity.c      |   7 +
 drivers/virt/coco/sev-guest/sev-guest.c | 695 +++---------------------
 arch/x86/Kconfig                        |   1 +
 drivers/virt/coco/sev-guest/Kconfig     |   3 -
 16 files changed, 820 insertions(+), 686 deletions(-)


base-commit: 8400291e289ee6b2bf9779ff1c83a291501f017b
-- 
2.34.1


