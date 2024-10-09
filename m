Return-Path: <kvm+bounces-28201-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A7035996558
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 11:29:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BEF721C22363
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 09:29:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4BCF18B482;
	Wed,  9 Oct 2024 09:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="jCRSKpOt"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2067.outbound.protection.outlook.com [40.107.212.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E559817;
	Wed,  9 Oct 2024 09:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728466157; cv=fail; b=NqulGyNyq0ZwCEGSn5dsqPNP5r3Uzm3kWAXAqyohXqg5W4GPUCmEjhqWGJT89NraOPGncKVYeGGgAvIqI0ctvijwbAF15JSFubdk1Mv1FitF/OxUDzWxS8Nq6lpnak3zw9FOXDJoqt6qliqvTdXUqP5zSXHygyFv/DW8hwgE2Mc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728466157; c=relaxed/simple;
	bh=K9wAB3/a4JCYNl1PFLvApWe8Poe/oFSmpEjlrDTR3x8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=gaMWhejH4GPThYaMDSEHOYhT0NiJqkgJ+bVJZGuyCbFC5SfcZpjKw7PF7AeG6mec9AFwj/bgny+jlZNn5RTBHMgZ/Z2Nqp4a2CizSDEVDKgWVB/XJm3LZxRLTsaHDcoW1WrI9OzkDEYkF3oYza+7nlGXPME8afd8I63MbZZEvgk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=jCRSKpOt; arc=fail smtp.client-ip=40.107.212.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eU6Kk8cf2y5fivsWckvKH56dVCnO5tMOHWUIQMgR/HuBcvvI/sg0AeVih1rDs1bO6UNhnwCRhN1u6OWkaohSDofCmTtkFRgid5xFzg/7E/34eCZ4ruQRsDyNJSaBnCLy29m4ABHFuqjDGMsTvKJmN6hK1R4xwNEUUCFYnvkJnXdFBLIzsb0n0YQX7AGPDbf6mPOcG92cXBaoR9g8cgHVoIstxNoSxBtShNuCBK+K+mwnOC9uSOAquITQtYm/iAnGEcVs2+VqszhfWogBqyoGVFevhfL2orj75742MZwXmzklMPudXNg9fRKWHLh9PW+orp4UlNJVrxtJ4POkviCFgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JtzwqcROgaFK2oO+UdVSrOkkMNkVMgEd5BqPcT+NERo=;
 b=rCAwQGutlaDqb092KaH1OxokpL8De3zfNN2SLWj4/D6nPG2zzxYcS48KogzOkVl1LKLuoxqdIj+BGJnWKDZCPadC2cGV8DegmdhNzKgzTjyBM5EojpsuWK2QU/yk5PEwjAwvNbkXsAOSuZ//gsUTz3IpRl2Kh+WT/MccIBvkpF1dt8hH1rqh5Ze2vTPKitO8NI3GHKZ/HWnvzUc+Z8YpI0GlYiVOHr5aSVqyUQkljaV6L5UPpO94Xp889uNzupAFdbt3hoRnY/xlu525Q0dtc8OtrXRzdHcKLrnvU5A2asPZdK9pItVUG/36x/jndBaHZafFgAo7EB8ALUKeNrmGKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JtzwqcROgaFK2oO+UdVSrOkkMNkVMgEd5BqPcT+NERo=;
 b=jCRSKpOtIVbKmmr3i8jiVipXJ6leZ9Oy7dV4RRWh/Qj44jLVoaanIK6M3y/UIjHJFdJ4I/5neIIoBsT3Q5rDMsbAF3KV8aGXto/4ooPRmjvJ4tlbJBHoYtuIE+lr9Vyv7hSlpIid/bLRCk4deJwoKS5rw+cGSeiC3+4dxdQhnyI=
Received: from BN9PR03CA0102.namprd03.prod.outlook.com (2603:10b6:408:fd::17)
 by SA1PR12MB8600.namprd12.prod.outlook.com (2603:10b6:806:257::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.16; Wed, 9 Oct
 2024 09:29:11 +0000
Received: from BL02EPF00021F6E.namprd02.prod.outlook.com
 (2603:10b6:408:fd:cafe::91) by BN9PR03CA0102.outlook.office365.com
 (2603:10b6:408:fd::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.17 via Frontend
 Transport; Wed, 9 Oct 2024 09:29:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF00021F6E.mail.protection.outlook.com (10.167.249.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8048.13 via Frontend Transport; Wed, 9 Oct 2024 09:29:10 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 9 Oct
 2024 04:29:06 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v12 00/19] Add Secure TSC support for SNP guests
Date: Wed, 9 Oct 2024 14:58:31 +0530
Message-ID: <20241009092850.197575-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF00021F6E:EE_|SA1PR12MB8600:EE_
X-MS-Office365-Filtering-Correlation-Id: b3ae81c2-9694-4df2-0360-08dce844d513
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|36860700013|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zMDzEjDsey6zhDyEZVBcC58Kp+52pLHH2rCzimAcUVu0twMe811JpslgCE9v?=
 =?us-ascii?Q?gXMGLJ7h15IQ1RxbZJRp+p5XsaADXUUOMgwnp6dSjlKFVV0PfZKtIhBWiszT?=
 =?us-ascii?Q?/i/quq8+g7GeOyfe8REWrrJw2jjRnjqDa1DYLQDIRJTTZO2dy8spjsmfVyqQ?=
 =?us-ascii?Q?x9rH/BIU9clILGDx5k1MqlvfRYeKpOHFeoqH3R3k/bKx3uLAp8Jur00KqZN2?=
 =?us-ascii?Q?YUhxk0padmY4mTmM9/l+PQbSPH+lkJlA86Ce2CX12wN5mpHsp1cWW4w86LlT?=
 =?us-ascii?Q?+qyWnK+XH5RRGdWyIEGmHoEU+1xsWVS41yqQv9dZj8njI7KNYx9cpV1ggWlT?=
 =?us-ascii?Q?tHWqBebKWdOMRUKIQ+Hhql4fvwWiiObNWv761FAY7vkTOovKIckCQj3pC4U0?=
 =?us-ascii?Q?1BkaCIg5Soqb4D9XPzNX/snNUkUjSfBYyhb62KQtpOrWp6G72L8FM4lE3fry?=
 =?us-ascii?Q?4JRL4e1aPOAYH4iusU0gwbZkBpUI3kIpz7YLRTqUmPYQi1TZ7RI67wB2HWz+?=
 =?us-ascii?Q?l+q3nIotZYiUJQIVjNieEuK373ogrmbuafADPoSj/Xlik+kiSWolnLGrP9DD?=
 =?us-ascii?Q?966mgxKOA8rfJFT4Mx15p8O54m1R0LxSU6qIa53RTeLJdDlHtYojaLme1o8W?=
 =?us-ascii?Q?hM4o6zR+ZQSstPuNGOLH/bjENGyzhfHfV3xYaQiZjfah+px7w9SacxSR0ipU?=
 =?us-ascii?Q?NAOClTA9MpisM4s9r+QjCydnPJKe21Xezrv4zgzrp+07q2WGSqtvdXUxNSvs?=
 =?us-ascii?Q?2JBPXj8ydvNn4xrzTGjyzWcOqqwgCRXX0icL0vbxMtOOAI5kxL61lTWBSyJ5?=
 =?us-ascii?Q?lnHJOVazEhr5l0ghkS1OZnGZzNaegG53Yna0XnOAMorVp84VdItnrALqizEG?=
 =?us-ascii?Q?4qx5dXbRMf5ae/walYWnB2sPgPUGDJHf6Ism4Pyub5N400/MCOMMG3pZ0qeD?=
 =?us-ascii?Q?4LZdKl65GEiImgPXzTt0jWctEazd5mmtX/mwftyizDiMHcA9ZBOKgawUXBXj?=
 =?us-ascii?Q?7SzYIO+88ZQ9uK4ePsKhPtRNMT9SkYg0qn6NYt1XiMmcsvE1u4bmiyQvNRrK?=
 =?us-ascii?Q?DMDu9UcUh6zZErGNU9WT5g6HIBfYtTSd9gYwUBINaUMVhQh4/VpYCw3FanNU?=
 =?us-ascii?Q?I4N+wjZ5bnigOD+nNAuh10I2xO3nr8g4M8Pis8pU4/fPO1m822IMKpzqEbqw?=
 =?us-ascii?Q?P5xLkTjzPoevSo1G9knOYgk5KVxW9GRIKc9hUwRcnvGfqJaZq4nemOxAUStP?=
 =?us-ascii?Q?PFVYSUpQ1bMkrG+MAsLtxpaftBKubnQpReKkCxkPyQxM+b30x/4VozKE4vKh?=
 =?us-ascii?Q?MPIpHiDRBzVRvlyhyy4wcg75WDl4nCmKClOYODe4J3SUjSivMJa/svslyxH/?=
 =?us-ascii?Q?UpxoV7AHU2X/yrdMyr7Udf4L06P0?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(36860700013)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2024 09:29:10.8887
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b3ae81c2-9694-4df2-0360-08dce844d513
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F6E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8600

This patchset is also available at:

  https://github.com/AMDESE/linux-kvm/tree/sectsc-guest-latest

and is based on v6.12-rc2

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
   01: Use AES GCM library
02-03: SNP init error handling and cache secrets page address
04-06: Preparatory patches for code movement
07-08: Patches moving SNP guest messaging code from SEV guest driver to
       SEV common code
09-14: SecureTSC enablement patches
15-16: Generic TSC/kvmclock improvements
17-19: SecureTSC enablement patches.

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
v12:
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

v11: https://lore.kernel.org/lkml/20240731150811.156771-1-nikunj@amd.com/
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


Nikunj A Dadhania (19):
  virt: sev-guest: Use AES GCM crypto library
  x86/sev: Handle failures from snp_init()
  x86/sev: Cache the secrets page address
  virt: sev-guest: Consolidate SNP guest messaging parameters to a
    struct
  virt: sev-guest: Reduce the scope of SNP command mutex
  virt: sev-guest: Carve out SNP message context structure
  x86/sev: Carve out and export SNP guest messaging init routines
  x86/sev: Relocate SNP guest messaging routines to common code
  x86/cc: Add CC_ATTR_GUEST_SNP_SECURE_TSC
  x86/sev: Add Secure TSC support for SNP guests
  x86/sev: Change TSC MSR behavior for Secure TSC enabled guests
  x86/sev: Prevent RDTSC/RDTSCP interception for Secure TSC enabled
    guests
  x86/sev: Mark Secure TSC as reliable clocksource
  tsc: Use the GUEST_TSC_FREQ MSR for discovering TSC frequency
  tsc: Upgrade TSC clocksource rating
  x86/kvmclock: Use clock source callback to update kvm sched clock
  x86/kvmclock: Abort SecureTSC enabled guest when kvmclock is selected
  x86/cpu/amd: Do not print FW_BUG for Secure TSC
  x86/sev: Allow Secure TSC feature for SNP guests

 arch/x86/include/asm/msr-index.h        |   1 +
 arch/x86/include/asm/sev-common.h       |   1 +
 arch/x86/include/asm/sev.h              | 165 +++++-
 arch/x86/include/asm/svm.h              |   6 +-
 include/linux/cc_platform.h             |   8 +
 arch/x86/boot/compressed/sev.c          |   3 +-
 arch/x86/coco/core.c                    |   3 +
 arch/x86/coco/sev/core.c                | 612 +++++++++++++++++++--
 arch/x86/coco/sev/shared.c              |  10 +
 arch/x86/kernel/cpu/amd.c               |   3 +-
 arch/x86/kernel/kvmclock.c              |  42 +-
 arch/x86/kernel/tsc.c                   |  22 +
 arch/x86/mm/mem_encrypt.c               |   4 +
 arch/x86/mm/mem_encrypt_amd.c           |   4 +
 arch/x86/mm/mem_encrypt_identity.c      |  11 +-
 drivers/virt/coco/sev-guest/sev-guest.c | 671 +++---------------------
 arch/x86/Kconfig                        |   1 +
 drivers/virt/coco/sev-guest/Kconfig     |   3 -
 18 files changed, 891 insertions(+), 679 deletions(-)


base-commit: 8cf0b93919e13d1e8d4466eb4080a4c4d9d66d7b
-- 
2.34.1


