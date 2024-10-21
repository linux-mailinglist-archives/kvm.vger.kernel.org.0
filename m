Return-Path: <kvm+bounces-29224-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CC329A59F1
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 07:54:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D28F3B215D6
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 05:54:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5BBC1CF292;
	Mon, 21 Oct 2024 05:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="NhjG23jd"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2040.outbound.protection.outlook.com [40.107.237.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB51433A0;
	Mon, 21 Oct 2024 05:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729490079; cv=fail; b=d5joSZQL+nPFYw0NtEdETEfewiRhuDAHT7gjHU8P3Cxr6ojtCgnrH+Akzp3nDRgCUNAxUb5D8Si/ZPzTCSf37N6kdi9jP7pp7ECoBQRcvuLq8tkSpnL/r5PrImxENz87QW7S4udDzXUt9XpoP5DxaQ4j7twbv9u2iSUpcEHKrPM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729490079; c=relaxed/simple;
	bh=tUHF5PR3d23RMuYB/hpDRhCZXPgwBNzBAGWSAAbWjVE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=kZ7BrnYsz+QRQk9CxbZBxdwaXnBy49EDuc8vCh+2yhU/+XNP5Q90b8s0tICmbRRTQMnJZH829GbMZREKygipx7d+AE6XLNchJEry619Q9JUTOTOHIV4Zgnus4haqZkBYF22wYyfmF3vENNpPAhiP3MK+sTfU9tu/qTMeBl6CMfs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=NhjG23jd; arc=fail smtp.client-ip=40.107.237.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PvoE5A1R1ksgm2JvI5kX5RxfBYqFr+AH7Bwp9JitYLMm9PLMjXuPMsLdVC757bjq/+Fk4IKgWdDiuuUhWVmfeR3APw/QzU3nhF0VHrv5k3RhxDesGMCZyy6d94Au5Aa4gIu/spYZsdVftTRBi0uQYJ98omyxe/ESZw/Ld1xuSW70EDHrMAOBQ1kbgPJpV8tZf8gMTWyf5nymjmgz5/Gg4FrFHoB9opTLjodHplweJ/Q5j2ibf7dkfLELxvrnghn1z0m0TLAVkqNK5XIGKik7abzGlY+WiHqNTOxy1D0xngc9KOGDB/ako32W5ajzWa+rAivIrU9I639NWanufm/3Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o/xBZqlz4ASkVKIAT9e2TdMjlVBJWat00llwuINCzek=;
 b=PV7Ia3TQAbKy5UOURPDtvfTBdITdCT1vQ1rc84UNIJZIWy4Cb1O+F8XWFnyCyDMeAqCxSvM9nRAK9gu7/+FlUYXHV3Ok/MXkW8dYM4Mci2TuHBapNwvEwgLEGsf3GWA0hGfrrika1/SFNIfYB00dU3/2t8MTKODM4DUZ2x6/y5IiCpZGB+Ry2CAtBADgHorLjs7r37T05RdfNRdJsjk5YjX7ZNIzyAILBPKcrCfpuOFw1FWkHzRrgaFHOgVQgwZYZLaRXJtPGhLE0XI4y9fEoX59tzkL/gCYSNAdWz/C7TVsmlqrfUPyjY6jKSiaGGWtCn+QXqLc3hjr7Ynb/OvdhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o/xBZqlz4ASkVKIAT9e2TdMjlVBJWat00llwuINCzek=;
 b=NhjG23jdgHXsi0nU+qrz2qvpsVt97WppLHTaIAB6jpH4R/DshaDdKNXvVUmgpFzJu0tqy57tOZvhegPqLs5cgs3QJc7wP08yAHnGgoGfdrD44M/sf6C+r/GFkH8ZDg2vOgvEnIjj5BX/KX/wYGhieFJP17u6v+nGMNcukW5FFk8=
Received: from BN7PR06CA0050.namprd06.prod.outlook.com (2603:10b6:408:34::27)
 by MN0PR12MB6342.namprd12.prod.outlook.com (2603:10b6:208:3c1::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.27; Mon, 21 Oct
 2024 05:54:33 +0000
Received: from BN1PEPF00006003.namprd05.prod.outlook.com
 (2603:10b6:408:34:cafe::1f) by BN7PR06CA0050.outlook.office365.com
 (2603:10b6:408:34::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.28 via Frontend
 Transport; Mon, 21 Oct 2024 05:54:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF00006003.mail.protection.outlook.com (10.167.243.235) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8093.14 via Frontend Transport; Mon, 21 Oct 2024 05:54:33 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 21 Oct
 2024 00:52:50 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v13 00/13] Add Secure TSC support for SNP guests
Date: Mon, 21 Oct 2024 11:21:43 +0530
Message-ID: <20241021055156.2342564-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00006003:EE_|MN0PR12MB6342:EE_
X-MS-Office365-Filtering-Correlation-Id: 9349e831-0d87-400c-628c-08dcf194d635
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lF5vgNDangoo8VPOhwromg2wfGtegenxMXqyWSjpZ8h6OxUhy+JQue6jeplJ?=
 =?us-ascii?Q?W333P8curn0NLHhfQYDmB7Hj14TnlrvLnk2/qypE0+bPxwmXO5Nzj2rvDnpN?=
 =?us-ascii?Q?H0LG8mV1BQRQpg2HDzR+257g3mjKqBlVbtcwcLa2KDa9PgYJCWxeKHbEv/B4?=
 =?us-ascii?Q?l2X4Ve/c9XsaU51l4p6M/NC6/1UsQUPLngv7Ae7b0DOiIeb1ppfnGZmsEjLN?=
 =?us-ascii?Q?6Vp2B7ee6e8kRqutiRPzi2kJKVa0/it4r4mplNTYmOQ5pwBZl/SPLS3q3DWl?=
 =?us-ascii?Q?QQUNoP5ruInAp31ZBhrGdvzEyyOfe3pusu+iGdxm7NOg6JjavB+m7W+HLer2?=
 =?us-ascii?Q?OWlTbjMhTzk2q9xY+birLaVnBukgPOZzihzNyHnxYAz7ugVg5hjv9ogXhvHd?=
 =?us-ascii?Q?pNOOaJHoJZQ7ptFtnuvwvRFDP8AIm370nBU8lHVWSw8cukSkXb5e+icgcdtq?=
 =?us-ascii?Q?g872bgCgj7Z6HL8V6iUFtW97hQoXX8XHyIrLFXGHnVO6YGSlzLxeTl3Rw5My?=
 =?us-ascii?Q?UUOF2WNvjwz/qkh7B7y0fzZ8mywAKxfs2aK/sDaOwwM/dy+ODRj4yNcKWWSZ?=
 =?us-ascii?Q?Rd8lWEbGTpSx4PkkO5/RmQ+8a/cRw0VLwg4KW6Y4FaxHoZGjTpapVBFagwnr?=
 =?us-ascii?Q?+x1XmleX5yJw/eQMtcHN3bAMMHxuu9FssZcmyMf6Wq6oaf6FzzZ2X7hj1mey?=
 =?us-ascii?Q?dyW/nxi5V0TTs4jHA9B2E2+ox53IR8HQhvOgzH1h0n37bmIm8HBrIQYM2bWK?=
 =?us-ascii?Q?Fez0ft5QBcPIFppcfzkOy9NwfGFPtlJilwsisHkA9RDWe909CNqrQw/PNqyz?=
 =?us-ascii?Q?/v+oucvq9IZNX8G1LIgkENF8uINaI+1FU9HGrwEf3YMbGNiPZ60k1+GN2HYT?=
 =?us-ascii?Q?U00qn0GQa/TRnaaaUTlEMZG7ZbaX+ws/kcV2YEJu7eqOxfk9S3W1v7Wdj1KP?=
 =?us-ascii?Q?UreauwQGQ4urZOZQYTFTAn9pfosl6sB/yugdrjBRQL8YxLtkVijkIEZbmOW/?=
 =?us-ascii?Q?tN8mo77VQ/NlTB0GAVtZJdp1c5D6DLfLtF/YbXz2wSseQQ3sTegmY5cT8PZt?=
 =?us-ascii?Q?vliU+3TCze9ovMoL5k8jdV0atB9STap45Zb8LEhB4YyF/42W5iSXiKq0Wjs4?=
 =?us-ascii?Q?YEqE5B5VdmWyjZjU0yWXSiT9EJzAHtwQr0qK/iXkmwPYlmtFLqCijHZWZKld?=
 =?us-ascii?Q?C35eredGMRNKbb4f5TL3/YwNPSe9Zf6R+qYGibrLPYluLqM9y8vRTpwsBX94?=
 =?us-ascii?Q?h7h1WPq10faG04qIlufPvr40tJZC8b61TM9MmitSkx+9gRRdxcKNCzhGEdjV?=
 =?us-ascii?Q?vCsHn0hRA32jSNG4gL/edUnrD5X+xl9KcI+ehpJPL0BgeXLt9QIhZnLpmTAr?=
 =?us-ascii?Q?xFuQyUgqIsXlaU4SNkD1nlHyJnZCi4+aw9TnjR7AZf9gc3lMbzva/QKJX2uP?=
 =?us-ascii?Q?71DzbsBGNiE=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2024 05:54:33.0263
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9349e831-0d87-400c-628c-08dcf194d635
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00006003.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6342

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
v13:
* Rebased on top of tip/x86/sev
* Squashed CC_ATTR_GUEST_SNP_SNP_SECURE_TSC change to patch where it used. (Tom)
* Fixed sparse warnings (kernel test robot)
* Added patch to prevent GUEST_TSC_FREQ MSR interception(Tom)
* Fix sched_clock override in common code (Sean)
* Added GHCB_TERM_SECURE_TSC_KVMCLOCK reason code and use sev_es_terminate() to
  inform the hypervisor that KVMCLOCK was being instead of Secure TSC.

v12: https://lore.kernel.org/lkml/20241009092850.197575-1-nikunj@amd.com/
* Rebased on top of v6.12-rc2
* Collected Reviewed-by (Tom)
* Improve error handling in sme_enable() (Boris)
* Drop handle_guest_request() copying routine (Boris)
* Move VMPCK empty check inside the lock (Tom)
* Drop export symbol for snp_issue_guest_request() (Tom)
* Rename CC_ATTR_GUEST_SECURE_TSC as CC_ATTR_GUEST_SNP_SECURE_TSC (Tom)
* Upgrade the tsc early and regular clock rating when TSC is invariant,
  non-stop and stable (tglx)
* Initialize kvm sched clock only when the kvmclock source is selected (Sean)
* Abort SecureTSC enabled guests when kvmclock is selected (Sean)
* Added patch to use TSC frequency using GUEST_TSC_FREQ MSR (Sean)

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
 arch/x86/coco/sev/core.c                | 567 +++++++++++++++++++++++-
 arch/x86/coco/sev/shared.c              |  13 +-
 arch/x86/kernel/cpu/amd.c               |   3 +-
 arch/x86/kernel/kvmclock.c              |   9 +
 arch/x86/kernel/tsc.c                   |  41 ++
 arch/x86/mm/mem_encrypt.c               |   4 +
 arch/x86/mm/mem_encrypt_amd.c           |   4 +
 drivers/virt/coco/sev-guest/sev-guest.c | 485 +-------------------
 arch/x86/Kconfig                        |   1 +
 drivers/virt/coco/sev-guest/Kconfig     |   1 -
 17 files changed, 794 insertions(+), 491 deletions(-)


base-commit: 0a895c0d9b73d934de95aa0dd4e631c394bdd25d
-- 
2.34.1


