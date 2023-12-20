Return-Path: <kvm+bounces-4935-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D21A781A1FA
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 16:15:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5EDD41F244D0
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 15:15:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4911140BE7;
	Wed, 20 Dec 2023 15:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="GWJ2p3Pa"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2079.outbound.protection.outlook.com [40.107.94.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF39A405C9;
	Wed, 20 Dec 2023 15:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W2y7gdpYuwEzNMtLYxTTvYVp/6x7UBqGmsqJqPM+XFW0JJb+L4M+SmMBum7AyJJmTtTuDCwBMi6NJxjDpZ1G1FeMNEUIkJKNKHyHHVvoEiIfhOQJuc5idUq+JCOSPYo8Lod+TGCc0Rw6o6rm9qFaVOFoB10bBV5bmL0OOpys6kv1AilG0iHHiZjsTgMCczeDBrkWvVZS5hkCAsyo54x1/6yWzwaOVqm9wzpd2zP+IDyPK1qwQ8t2PFJOVfj/fVnnjplRhb2rWFw9w8QTnnlApu+IgZgpmerTcvfDaPT8OQnF9ZONcpmPJFrWUsiiuZaLo2lM7sEBwe8Op3sNdn/xcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ipmVbbYIa/B3hhMSouG/GD5hkj4LWswg2E6YiNyO1ig=;
 b=YUrBZSgXK1o2QbTer5Tn3B2UtWcbbQfc59EHR3hBRRMEaACckkw75SpMowADj+a4QH0e4fJcUMRSAQrp3ZEti4Xv5otjKjKhRxPQUHaDnCSPx17k4W/BXsa1SqpVPx/UlmZUQ1XI70HoTrsiOL4RUwBk40GE+zsnWZiq9vxuM+ZzdbhYYZcIwPfTHJqwOw/ot5oNSUJQmcymaLZaaPO53PSh4C7bwt5MGmzI3QCsd4HbHf1j3xYWFGZJLZjZqXw+ilXRogUThSz5rNs+WLZONPRCOcgfyW309M2u4oEHenOh6vlYnshUwmB/994Uzi6vsZWZITXSaP7D9x5aJ8cQAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ipmVbbYIa/B3hhMSouG/GD5hkj4LWswg2E6YiNyO1ig=;
 b=GWJ2p3PaYY4hBV37w9U/O8sj/ochuBNJPaP6Z2xdjH1eyAaw6nlyi5QNl6fR/bcvPm3eG5bsTSmX0/+EhzxjYT6ibfgcDDiaGUZJbsWSkv6aB+a6wKtvjulAOBadlFAN/gDth5s++t0hgPTngG7tbMZ2ZzcmX92XshD3iqtkPK0=
Received: from CH0PR03CA0217.namprd03.prod.outlook.com (2603:10b6:610:e7::12)
 by PH0PR12MB8049.namprd12.prod.outlook.com (2603:10b6:510:28f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.18; Wed, 20 Dec
 2023 15:14:50 +0000
Received: from DS2PEPF0000343A.namprd02.prod.outlook.com
 (2603:10b6:610:e7:cafe::2d) by CH0PR03CA0217.outlook.office365.com
 (2603:10b6:610:e7::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.18 via Frontend
 Transport; Wed, 20 Dec 2023 15:14:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF0000343A.mail.protection.outlook.com (10.167.18.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7113.14 via Frontend Transport; Wed, 20 Dec 2023 15:14:49 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Wed, 20 Dec
 2023 09:14:42 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <bp@alien8.de>, <mingo@redhat.com>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>, <dionnaglaze@google.com>, <pgonda@google.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>
Subject: [PATCH v7 00/16] Add Secure TSC support for SNP guests
Date: Wed, 20 Dec 2023 20:43:42 +0530
Message-ID: <20231220151358.2147066-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343A:EE_|PH0PR12MB8049:EE_
X-MS-Office365-Filtering-Correlation-Id: 8614e03c-bb3a-4a1e-e28e-08dc016e690b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	PkOtm9ohZ/UEByuyylgQhuKVt1xJ98mF112uaaxWTIE85yPk4n/+CDsxf456/6j+jcZHmOP8fyVYSSHfwZUYFnYqXemYCuCKD3Wk3ipLyUDMpyWjhBGxlM6wJPkH+ziUiWG6ycB2xvq5RW2q+1PHuv4bsn4QHHkIjhN/CzpPLiXPkkPL9fypbjajRUw0gxWovWszNCeRWxWn+DIzVjqYGiBIh/q6Ih57kn5X/rbgbG6UIvKDgQkWeivZlmMzKkHozaWDw4n25diuESjrM8ncRfZLfe7rHAUkRU4JPtis2of1GnQgr/t6fvOzLIE9SN5AkOorGeUH6o7759IjKWzytmR797uvOdNd/CRE03vFUnpYwGzR8+URHe6El1XT7IvLiXP213/KIx99q6xTakJRfZae5T4GZEZKHC4leVzabbbQ9mqm4FP5sqKsP9Nzttrde3gyJX1BUjS2S3E+kpvCFw2pCBvHNpgg5UhMVdrXcH+ARmCtAZkCpxhor9VguKkSFDPr/X2bRZFV0knyfefyp+bBcgA1bjC4PBs1f94SIGKbRWrlVU6opFUwkBbOZL3PeGjpjnr4xmnNDGYZolV6ShE0MotUtto2Kdnkc5F6KloHBmZP0IZOWei1CXcctIl8eqg5mGfWdvgOkxyxV3ZQYwxboHQpB0pyOr4BUhD3s5/yYrrUIymfSt5Tq0DmPw9hdtNdCtCSHNsnKPhypL4dOQSVTXZmFMEukC6oJgXoIjj4yx+w7NoWpihCSMnjn12yZUtAk80zzCWl3OBE0xjdTUH3/q8Zqy70UdlWBYp3rfk=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(39860400002)(376002)(346002)(396003)(230922051799003)(64100799003)(186009)(1800799012)(451199024)(82310400011)(46966006)(40470700004)(36840700001)(36860700001)(356005)(40480700001)(47076005)(40460700003)(1076003)(16526019)(426003)(336012)(83380400001)(2616005)(26005)(36756003)(82740400003)(81166007)(7696005)(478600001)(316002)(54906003)(110136005)(966005)(70206006)(70586007)(7416002)(4326008)(8676002)(8936002)(2906002)(5660300002)(41300700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2023 15:14:49.9247
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8614e03c-bb3a-4a1e-e28e-08dc016e690b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8049

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
01-08: Preparation and movement of sev-guest driver code
09-16: SecureTSC enablement patches.

Testing SecureTSC
-----------------

SecureTSC hypervisor patches based on top of SEV-SNP Guest MEMFD series:
https://github.com/nikunjad/linux/tree/snp-host-latest-securetsc_v5

QEMU changes:
https://github.com/nikunjad/qemu/tree/snp_securetsc_v5

QEMU commandline SEV-SNP-UPM with SecureTSC:

  qemu-system-x86_64 -cpu EPYC-Milan-v2,+secure-tsc,+invtsc -smp 4 \
    -object memory-backend-memfd-private,id=ram1,size=1G,share=true \
    -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,secure-tsc=on \
    -machine q35,confidential-guest-support=sev0,memory-backend=ram1,kvm-type=snp \
    ...

Changelog:
----------
v7:
* Drop mutex from the snp_dev and add snp_guest_cmd_{lock,unlock} API
* Added comments for secrets page failure
* Added define for maximum supported VMPCK
* Updated comments why sev_status is used directly instead of
  cpu_feature_enabled()

v6:
* Add synthetic SecureTSC x86 feature bit
* Drop {__enc,dec}_payload() as they are pretty small and has one caller.
* Instead of a pointer use data_npages as variable
* Beautify struct snp_guest_req
* Make vmpck_id as unsigned int in snp_assign_vmpck()
* Move most of the functions to end of sev.c file
* Update commit/comments/error messages
* Mark free_shared_pages and alloc_shared_pages as inline
* Free snp_dev->certs_data when guest driver is removed
* Add lockdep assert in snp_inc_msg_seqno()
* Drop redundant enc_init NULL check
* Move SNP_TSC_INFO_REQ_SZ define out of structure
* Rename guest_tsc_{scale,offset} to snp_tsc_{scale,offset}
* Add new linux termination error code GHCB_TERM_SECURE_TSC
* Initialize and use cmd_mutex in snp_get_tsc_info()
* Set TSC as reliable in sme_early_init()
* Do not print firmware bug for Secure TSC enabled guests

https://lore.kernel.org/lkml/20231128125959.1810039-1-nikunj@amd.com/

v5:
* Rebased on v6.6 kernel
* Dropped link tag in first patch
* Dropped get_ctx_authsize() as it was redundant

https://lore.kernel.org/lkml/20231030063652.68675-1-nikunj@amd.com/

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

Nikunj A Dadhania (16):
  virt: sev-guest: Use AES GCM crypto library
  virt: sev-guest: Replace dev_dbg with pr_debug
  virt: sev-guest: Add SNP guest request structure
  virt: sev-guest: Add vmpck_id to snp_guest_dev struct
  x86/sev: Cache the secrets page address
  virt: sev-guest: Move SNP Guest command mutex
  x86/sev: Move and reorganize sev guest request api
  x86/mm: Add generic guest initialization hook
  x86/cpufeatures: Add synthetic Secure TSC bit
  x86/sev: Add Secure TSC support for SNP guests
  x86/sev: Change TSC MSR behavior for Secure TSC enabled guests
  x86/sev: Prevent RDTSC/RDTSCP interception for Secure TSC enabled
    guests
  x86/kvmclock: Skip kvmclock when Secure TSC is available
  x86/sev: Mark Secure TSC as reliable
  x86/cpu/amd: Do not print FW_BUG for Secure TSC
  x86/sev: Enable Secure TSC for SNP guests

 arch/x86/Kconfig                        |   1 +
 arch/x86/boot/compressed/sev.c          |   3 +-
 arch/x86/include/asm/cpufeatures.h      |   1 +
 arch/x86/include/asm/sev-common.h       |   1 +
 arch/x86/include/asm/sev-guest.h        | 190 +++++++
 arch/x86/include/asm/sev.h              |  21 +-
 arch/x86/include/asm/svm.h              |   6 +-
 arch/x86/include/asm/x86_init.h         |   2 +
 arch/x86/kernel/cpu/amd.c               |   3 +-
 arch/x86/kernel/kvmclock.c              |   2 +-
 arch/x86/kernel/sev-shared.c            |  10 +
 arch/x86/kernel/sev.c                   | 649 +++++++++++++++++++++--
 arch/x86/kernel/x86_init.c              |   2 +
 arch/x86/mm/mem_encrypt.c               |  12 +-
 arch/x86/mm/mem_encrypt_amd.c           |  12 +
 drivers/virt/coco/sev-guest/Kconfig     |   3 -
 drivers/virt/coco/sev-guest/sev-guest.c | 668 +++---------------------
 drivers/virt/coco/sev-guest/sev-guest.h |  63 ---
 18 files changed, 917 insertions(+), 732 deletions(-)
 create mode 100644 arch/x86/include/asm/sev-guest.h
 delete mode 100644 drivers/virt/coco/sev-guest/sev-guest.h


base-commit: ceb6a6f023fd3e8b07761ed900352ef574010bcb
-- 
2.34.1


