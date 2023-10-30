Return-Path: <kvm+bounces-39-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A3BC7DB37F
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 07:37:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6B798B20DE2
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 06:37:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5ACC04437;
	Mon, 30 Oct 2023 06:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="VAwKdfhk"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4340C3C10
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 06:37:22 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2073.outbound.protection.outlook.com [40.107.244.73])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C12FCAC;
	Sun, 29 Oct 2023 23:37:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HyNc1I5+yZz4Cix3xtNTJ10z2drE90KYL7WLXB5rqm4mVVOSS3+vatzICuNcnoVZT5JgU898rzZ0JPBkC89ANQpZ+U5yvnt3FPoA3nzP1dLak1ctACMfsO1lbn6bXO/2GZUlkaXAOAVGBEVK+Zo0h2SBL5/vIPwQklW6KRgQlZTUBjDd0TyInDe/jNc09UDI2ZwE/7qcKa5p7El5HlKkHA2F8Cl8g8Zhc4VdwOVCmMY6vrGS9j0UziYV3Uvv6gKTt9N+7VtNuYe9OHOZc1BdXrq53H8MuSO3vKaZqBdaueyxdtAx8egl2V6Jos1NidlEbV5nPDIXSPOBao9hn+gF+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xKs22jQMdgIKQKNRt1bbJNYc0z3J16Pg9/lvofLT4Vc=;
 b=SU15nXj6Rv2JI71FRZWMSANhvwBjkgJvT7JA1d7nWSVGkvsnLJ6TrDzR6TYdAz2XZFgJDmmgULMP5uLABDqvNT0P3d6UheGpAbJe5SrVWf+Zs1KQ8jB+Ei0zmZyw20hGcalEuOgXdGZlUJVVDNPXg5P0A/lvQ6JrmKI/0ZXRqnfGbRe64zqS8w+2WXTr/J3N8xP8s6Ms6nFng4o2a3ogp8lRZfo8YE/hen9jT7XfQa0O0H+vKUZzKTqMNvXUbiQhfq/LCYqT9bULmfz5C58DjrYWjCi6iBs87EP6hbuxMlmVNVaGul9vrsmNp3LcCkiQf2d1Zt9SQql64fzjIWFJJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xKs22jQMdgIKQKNRt1bbJNYc0z3J16Pg9/lvofLT4Vc=;
 b=VAwKdfhk/0qhi9C3EzGwA3cGabS/LPbVOpT/xtaraXeYas5mLEStqnShUVy5vCT9p2CPImFc9eCJC1ysnnuBJhlGZPfKgEKUJqc/FhHw6s08cKSFkOabLN1LLzAqCKW2RviScp8wBPvKskfTNPEhO+xp3HIQZ7beUydirrMcQYo=
Received: from BL1PR13CA0024.namprd13.prod.outlook.com (2603:10b6:208:256::29)
 by SA3PR12MB9178.namprd12.prod.outlook.com (2603:10b6:806:396::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.19; Mon, 30 Oct
 2023 06:37:17 +0000
Received: from BL6PEPF0001AB71.namprd02.prod.outlook.com
 (2603:10b6:208:256:cafe::e1) by BL1PR13CA0024.outlook.office365.com
 (2603:10b6:208:256::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.15 via Frontend
 Transport; Mon, 30 Oct 2023 06:37:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB71.mail.protection.outlook.com (10.167.242.164) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6933.22 via Frontend Transport; Mon, 30 Oct 2023 06:37:16 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.32; Mon, 30 Oct
 2023 01:37:12 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <bp@alien8.de>, <mingo@redhat.com>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>, <dionnaglaze@google.com>, <pgonda@google.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>
Subject: [PATCH v5 00/14] Add Secure TSC support for SNP guests
Date: Mon, 30 Oct 2023 12:06:38 +0530
Message-ID: <20231030063652.68675-1-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB71:EE_|SA3PR12MB9178:EE_
X-MS-Office365-Filtering-Correlation-Id: 46ee22ca-bccb-493f-3237-08dbd912a8d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	xmIx8w1mYeOQ1r4qzxxLCzvLOjsVVrJzIwgpdVNQE+3JVpSSKltgqG2qORCpHpJJimdINqDNkhYGoZSDxGG54adzTtmH8qgKzeRb57UfaO7mTvyUKSolWcohwd22lXvH7oTypYPWUgFElDIRPhi/0k5jkEuT9by4I7atVK7V8rgVrC/S3H1d2qlppExdiI0ut553zXgjp1JwPqbWvlNv2JZXfDnQ6jpN40Z4okr0nsmTXlkA+MnKw6O4IWRvTSRR062OO7ejWKPJGZipI/ym4UHkfnKi+bI/WZov7qrLOB8dv4bo1VOh1CzBouIPX7ufQvOE68VyIjo3QSE189lPGgo4OH70Ef55qzcLlXhjrcUKOA/V9t2LL2jIFglZvSDn2iJr/VVhn6/SQtbeglQbqCzljWIZ3XvX8wwtY8DmUBz49uiSp6zmg9eix3Tn6pNCVtfwXs5LnlOHbqGhbL0NI9u6+0IDesy2rbw6bsHOeQBUHdgSfqmIqEhdZEg2kgi3BjAiEl+dzxBP/kCd5e8U7FBUhQtIO7j8i2rQXvnv6QvV6awfaB1oN5YvsbWTtsmi1z8eJt1AR19AXK7UcR4enMsj2sHaEgBEkqSU2tdnI+KPzxlQAT+vlYS7nhsEisNZbGqd6LpvmD222YPioyEmCBl7yIAczDwe8Vv8pV4/NEHuQUiHNsaa9JM7wNYuJiqCMyb3DqxVnv5Z8EoSEYtwaRwx5QG/UvXaiaEWOPnl1VesZOWtpm3i3IvXywRnYGqrP+i3hi8STts//J7/ziuLDEcdp30s6OEWg3ws/AgHBQE=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(346002)(39860400002)(376002)(136003)(230922051799003)(82310400011)(1800799009)(186009)(64100799003)(451199024)(46966006)(36840700001)(40470700004)(83380400001)(7416002)(4326008)(2906002)(8936002)(8676002)(966005)(81166007)(356005)(82740400003)(41300700001)(5660300002)(316002)(110136005)(26005)(426003)(336012)(478600001)(7696005)(1076003)(6666004)(2616005)(16526019)(36756003)(54906003)(40460700003)(47076005)(70586007)(70206006)(36860700001)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2023 06:37:16.7902
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 46ee22ca-bccb-493f-3237-08dbd912a8d7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB71.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9178

Secure TSC allows guests to securely use RDTSC/RDTSCP instructions as the
parameters being used cannot be changed by hypervisor once the guest is
launched. More details in the AMD64 APM Vol 2, Section "Secure TSC".

During the boot-up of the secondary cpus, SecureTSC enabled guests need to
query TSC info from AMD Security Processor. This communication channel is
encrypted between the AMD Security Processor and the guest, the hypervisor
is just the conduit to deliver the guest messages to the AMD Security
Processor. Each message is protected with an AEAD (AES-256 GCM). See "SEV
Secure Nested Paging Firmware ABI Specification" document (currently at
https://www.amd.com/system/files/TechDocs/56860.pdf) section "TSC Info"

Use a minimal GCM library to encrypt/decrypt SNP Guest messages to
communicate with the AMD Security Processor which is available at early
boot.

SEV-guest driver has the implementation for guest and AMD Security
Processor communication. As the TSC_INFO needs to be initialized during
early boot before smp cpus are started, move most of the sev-guest driver
code to kernel/sev.c and provide well defined APIs to the sev-guest driver
to use the interface to avoid code-duplication.

Patches:
01-07: Preparation and movement of sev-guest driver code
08-14: SecureTSC enablement patches.

Testing SecureTSC
-----------------

SecureTSC hypervisor patches based on top of SEV-SNP UPM series:
https://github.com/nikunjad/linux/tree/snp-host-latest-securetsc_v5

QEMU changes:
https://github.com/nikunjad/qemu/tree/snp_securetsc_v5

QEMU commandline SEV-SNP-UPM with SecureTSC:

  qemu-system-x86_64 -cpu EPYC-Milan-v2,+secure-tsc -smp 4 \
    -object memory-backend-memfd-private,id=ram1,size=1G,share=true \
    -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,secure-tsc=on \
    -machine q35,confidential-guest-support=sev0,memory-backend=ram1,kvm-type=snp \
    ...

Changelog:
----------
v5:
* Rebased on v6.6 kernel
* Dropped link tag in first patch
* Dropped get_ctx_authsize() as it was redundant

v4:
* Drop handle_guest_request() and handle_guest_request_ext()
* Drop NULL check for key
* Corrected commit subject
* Added Reviewed-by from Tom

https://lore.kernel.org/lkml/20230814055222.1056404-1-nikunj@amd.com/

v3:
* Updated commit messages
* Made snp_setup_psp_messaging() generic that is accessed by both the
  kernel and the driver
* Moved most of the context information to sev.c, sev-guest driver
  does not need to know the secrets page layout anymore
* Add CC_ATTR_GUEST_SECURE_TSC early in the series therefore it can be
  used in later patches.
* Removed data_gpa and data_npages from struct snp_req_data, as certs_data
  and its size is passed to handle_guest_request_ext()
* Make vmpck_id as unsigned int
* Dropped unnecessary usage of memzero_explicit()
* Cache secrets_pa instead of remapping the cc_blob always
* Rebase on top of v6.4 kernel
https://lore.kernel.org/lkml/20230722111909.15166-1-nikunj@amd.com/

v2:
* Rebased on top of v6.3-rc3 that has Boris's sev-guest cleanup series
  https://lore.kernel.org/r/20230307192449.24732-1-bp@alien8.de/

v1: https://lore.kernel.org/r/20230130120327.977460-1-nikunj@amd.com/

Nikunj A Dadhania (14):
  virt: sev-guest: Use AES GCM crypto library
  virt: sev-guest: Move mutex to SNP guest device structure
  virt: sev-guest: Replace dev_dbg with pr_debug
  virt: sev-guest: Add SNP guest request structure
  virt: sev-guest: Add vmpck_id to snp_guest_dev struct
  x86/sev: Cache the secrets page address
  x86/sev: Move and reorganize sev guest request api
  x86/mm: Add generic guest initialization hook
  x86/sev: Add Secure TSC support for SNP guests
  x86/sev: Change TSC MSR behavior for Secure TSC enabled guests
  x86/sev: Prevent RDTSC/RDTSCP interception for Secure TSC enabled
    guests
  x86/kvmclock: Skip kvmclock when Secure TSC is available
  x86/tsc: Mark Secure TSC as reliable clocksource
  x86/sev: Enable Secure TSC for SNP guests

 arch/x86/Kconfig                        |   1 +
 arch/x86/boot/compressed/sev.c          |   3 +-
 arch/x86/coco/core.c                    |   3 +
 arch/x86/include/asm/sev-guest.h        | 175 +++++++
 arch/x86/include/asm/sev.h              |  20 +-
 arch/x86/include/asm/svm.h              |   6 +-
 arch/x86/include/asm/x86_init.h         |   2 +
 arch/x86/kernel/kvmclock.c              |   2 +-
 arch/x86/kernel/sev-shared.c            |   7 +
 arch/x86/kernel/sev.c                   | 631 +++++++++++++++++++++--
 arch/x86/kernel/tsc.c                   |   2 +-
 arch/x86/kernel/x86_init.c              |   2 +
 arch/x86/mm/mem_encrypt.c               |  13 +-
 arch/x86/mm/mem_encrypt_amd.c           |   6 +
 drivers/virt/coco/sev-guest/Kconfig     |   3 -
 drivers/virt/coco/sev-guest/sev-guest.c | 646 +++---------------------
 drivers/virt/coco/sev-guest/sev-guest.h |  63 ---
 include/linux/cc_platform.h             |   8 +
 18 files changed, 877 insertions(+), 716 deletions(-)
 create mode 100644 arch/x86/include/asm/sev-guest.h
 delete mode 100644 drivers/virt/coco/sev-guest/sev-guest.h


base-commit: ffc253263a1375a65fa6c9f62a893e9767fbebfa
-- 
2.34.1


