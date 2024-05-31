Return-Path: <kvm+bounces-18468-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A7F9C8D595D
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 06:31:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CB29A1C2365B
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 04:31:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF4F357CA2;
	Fri, 31 May 2024 04:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="29s/UK8T"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2077.outbound.protection.outlook.com [40.107.94.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C0618E2A;
	Fri, 31 May 2024 04:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717129885; cv=fail; b=mH4MNrOGuQS26Ak1fs/4f/GbDuuZzb01lbaUqziHwqLRpd+MEt+7WR+qhPFuqnNc1NZfaaS4lmrQf2hN6SqYB1hV8FRfH6R7SXvFaWgNddOpzB32elFPj6v4/3Fx/RoDyJmb/rmpv1PMcPPiyfOSFhCvprmOOsANztypB9446qg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717129885; c=relaxed/simple;
	bh=4x5vNEH8jhdEftksp/jESHSd+iuGiYUrfOJkGBZBvu4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=AfWd6F8tee0hAQCrH6SbanmlyTnB2SIiu+s7DuYYRFLFpbHORTvMn7NVv5dJo62jE8okwBUHLzw94Fwm+NZw55t2ASu52F7TRIJ0tn7FbVzZaZnq2UI+rt54Byet2s8cI26lI1+7P+9EmvFhkASFIHQgkoTxohHAP8WEycTdepM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=29s/UK8T; arc=fail smtp.client-ip=40.107.94.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zzg4hofrKBbE28dapg29ng5Hm7OBQL9I4J3W/VJfcKoohARVQUZGrPdywOchFRnUOLcRBQf3zbD1aS2u8kxHTnlbhfNXtlLi00JUm20P6eHCcCh/VVx4GAUn7gvOp1jrc50u6auSBOoTE/Kcd+0tYCUZxn+3fH0pGny6w5/jrsCInA5+nBWTfXoSstYTXdEINEp3BPSt7ZeU8EbYSWMijuXCqrSUG4vwi3I8n36Nggb/FwpCqGnkprjQGe8522p0LJ0SR3yKpTuZx9N5YqBseO9IKb0P9vjJMXJiW8R/HecCjSxO5nYK1pcjJkRiH4OhQntF1VqdVn6nGAqMz2DgSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N9+BRiNpETaxzRB03oT/p/A2Du28yD3i01tNiKnxRzU=;
 b=kquZGzirHpm9NTmizcW+n+PLgU0HdDB4YLWVaQNCvM56W8nY0pSXUND29mLKP9Rk35zF6r1F9uha4LwfcRuk3QLaKOW7+w8riRMEix4B3hhZGqJHiwfzCXeBaXHMI/aFA57vaEbFe2pYuFO1ht3FNI+SI85JL1keWtgV+mFsKBqaZPOVJq/lwKkS5prFUuWszOTxMSk5kHb5Nw0oY6CAR3j1HezcsVRfmE/DZCiVsPsYoN3wTh/TEr32A4llUVTuck8szdYJZJ18YIMOGx4ER5zWGSuCi7uJjWjgvqgszYZOsyWXvwYH6GaRmJA+jTnPYulxw3sFUO2lR9jV3yz8wQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N9+BRiNpETaxzRB03oT/p/A2Du28yD3i01tNiKnxRzU=;
 b=29s/UK8TkIUdCSkEkwv1cxjcZ/l31KOYxzbIQL+dfvRdmug9A1Y+EMMEaILCHXewPhsyH94SZSm0ZvW4GCLHuYmvdGacyOQxIVZefSx62soNzyPMszstf/D26CJX/FYauEIWYVHKO9cEDWVfTzd+kj6+2uZSjfT0mmajnnW7OIU=
Received: from BY3PR05CA0005.namprd05.prod.outlook.com (2603:10b6:a03:254::10)
 by CH3PR12MB8401.namprd12.prod.outlook.com (2603:10b6:610:130::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.24; Fri, 31 May
 2024 04:31:21 +0000
Received: from SJ1PEPF00002325.namprd03.prod.outlook.com
 (2603:10b6:a03:254:cafe::56) by BY3PR05CA0005.outlook.office365.com
 (2603:10b6:a03:254::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7656.8 via Frontend
 Transport; Fri, 31 May 2024 04:31:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00002325.mail.protection.outlook.com (10.167.242.88) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Fri, 31 May 2024 04:31:20 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 23:31:16 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v9 00/24] Add Secure TSC support for SNP guests
Date: Fri, 31 May 2024 10:00:14 +0530
Message-ID: <20240531043038.3370793-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002325:EE_|CH3PR12MB8401:EE_
X-MS-Office365-Filtering-Correlation-Id: 176e8f02-3d78-4b96-a976-08dc812a859b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|82310400017|1800799015|36860700004|376005|7416005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+1lXIFhm57TVsk7I87xfCF048u6Iw61CVNf5NM96UU/4C6SdXGP/kolGLVTw?=
 =?us-ascii?Q?QVXyLZPIVLgkJxHW85iHGIpJYX44O2QfCZXK+r7EXjG7SmECGDrBIU39FSUr?=
 =?us-ascii?Q?3OfA7lO3QnQnoOD5/rEHYv5TiCzDiz6vPBoD+bGMOgl18vOpmHvMC9AeHZKa?=
 =?us-ascii?Q?TIMMODEBPdOLGOaM5ZluWqLAVCQCfyvyjZHSntxqjRsTGcVPy+4GohGmPHDV?=
 =?us-ascii?Q?1Af16P1Ogh95qzgqcFkIf4/aUfp1gyEJDLF3QZGxKlV5mpVMBEjRw7NOpBSb?=
 =?us-ascii?Q?/M1PtxV0d6izbS8JHrSA9JnNes2q7b4gUCl87JiIhR7Bzj/jF5tkYqVDK9NX?=
 =?us-ascii?Q?VF8x4K6y1Rty5QAKNfyv/1EsLJbNziUsh6R9l+AQ8L2Q7NE1i49tlzZjt9ZZ?=
 =?us-ascii?Q?JX4XS29idlqLQ7xFm6P3pesLtNxUt87xwsH4mwPQQmYE4swQCndBMlvyk291?=
 =?us-ascii?Q?jlTJHjdAor0TKodjD73R0ftknBqTHL3Q1u7hMpBi2mcxCeV8MPQmsyfWUtUl?=
 =?us-ascii?Q?8Eju2tTDBr+dV6gyPtu6vohBbZJQSMVGlEJ0vtwJ4v6Kmrk9CrQeL2CGiQvQ?=
 =?us-ascii?Q?ZiJIXvTpXKPl3O5/IFYqZOeNW4PZkB1gmt4uQ3gIwU9Ny9QWnjsfr+Gddgsy?=
 =?us-ascii?Q?mp3j62Wf32VUQbnTUOIQo02DCJSqdt4jCqNKIi1myCiYXjmAGN/TPEniBwK+?=
 =?us-ascii?Q?/fs3qJbyf01eseKWg8OKgxhqtkkC7vs8psWg3+N3FEzOk5SB9UnCNZGJB02D?=
 =?us-ascii?Q?yHQA0AIE0VGYR+biC4s54buDCCOcwsLhUnzH+pK2sDnO/cqyCFfHcd7iXLpR?=
 =?us-ascii?Q?M7P3Nsi7t+ybNiCpzzzKDm23LMUjX6YQzD27+6LlfucC5ldO1JcRKgERR5Cc?=
 =?us-ascii?Q?opZanXQn7JtsUb9A0Uke3rUNRE/ul/QbCOLzZ++qgrOKBx9+odAWu06Ens77?=
 =?us-ascii?Q?zP5/LHD36JpcSL98Uk6UAoeo8hS9KnRYFjtsJ9iwSfvx9t4g50MRaPZgXMwY?=
 =?us-ascii?Q?9d7mfLF0V/cVaqbZz6s77dcU4YBu78hu7euLVcoj5ra18bXwV7HkQuAee29r?=
 =?us-ascii?Q?3/NXPLgDN+E6N+WsUdePDOQDssXZ1XigzBUBSX1z6EeZE7CBTGLs3gSIvUX5?=
 =?us-ascii?Q?Z+SorWb1KcVCjsEg+Ey9O8xaZkviv9CkFQplalY8Wsrp/KPrMX9wrG2VOgfi?=
 =?us-ascii?Q?nO9sMrnSSJC4RBIqDRdbq8rf3RU55EuvQwyo1Hqpgj8CRPDL4+/24ixTFfj4?=
 =?us-ascii?Q?nSOTO+EbvaKff7G0EClnPyRXIVBO3ZQdyU07JjWBLkkh6gcgFNQ7oXuiWvKd?=
 =?us-ascii?Q?2irKhHgizxScd1NM91hVN5w1?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400017)(1800799015)(36860700004)(376005)(7416005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2024 04:31:20.7917
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 176e8f02-3d78-4b96-a976-08dc812a859b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002325.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8401

This patchset is also available at:

  https://github.com/AMDESE/linux-kvm/tree/sectsc-guest-latest

and is based on commit: 1613e604df0c ("Linux 6.10-rc1")

Overview
--------

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
01-09: Preparatory patches for code movement and general cleanup/fixups
10-13: Patches moving SNP guest messaging code from SEV guest driver to
       SEV common code
14-16: Error handling and caching secrets page
17-24: SecureTSC enablement patches.

Testing SecureTSC
-----------------

SecureTSC hypervisor patches based on top of SEV-SNP Guest MEMFD series:
https://github.com/AMDESE/linux-kvm/tree/sectsc-host-latest

QEMU changes:
https://github.com/nikunjad/qemu/tree/snp-securetsc-latest

QEMU commandline SEV-SNP with SecureTSC:

  qemu-system-x86_64 -cpu EPYC-Milan-v2,+invtsc -smp 4 \
    -object memory-backend-memfd,id=ram1,size=1G,share=true,prealloc=false,reserve=false \
    -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,secure-tsc=on \
    -machine q35,confidential-guest-support=sev0,memory-backend=ram1 \
    ...

Changelog:
----------
v9:
* Added Acked-by/Reviewed-by
* Removed Reviewed-by/Tested-by from patches that had significant changes
* Added patch to make payload a variable length array in snp_guest_msg
* Fix all your user-visible strings (vmpck => VMPCK) and readabilty.
* Separated patch for message sequence handling
* Handle failures from snp_init() in sme_enable()
* Preparatory patches:
  * Carved out simplify VMPCK and OS message sequence changes
  * Carved out SNP guest messaging init/exit for proper initialization and
    cleanup.
  * Move SNP command mutex down and make it private to sev.c
* Pure code movement patch and subsequent code changes patches
* Drop patches adding guest initiation hook enc_init() and call
  snp_secure_tsc_prepare() from mem_encrypt.c
* Use CC_ATTR_GUEST_SECURE_TSC and drop synthetic SecureTSC feature bit

v8: https://lore.kernel.org/lkml/20240215113128.275608-1-nikunj@amd.com/
* Rebased on top of tip/x86/sev
* Use minimum size of IV or msg_seqno in memcpy
* Use arch/x86/include/asm/sev.h instead of sev-guest.h
* Use DEFINE_MUTEX for snp_guest_cmd_mutex
* Added Reviewed-by from Tom.
* Dropped Tested-by from patch 3/16

v7: https://lore.kernel.org/kvm/20231220151358.2147066-1-nikunj@amd.com/
v6: https://lore.kernel.org/lkml/20231128125959.1810039-1-nikunj@amd.com/
v5: https://lore.kernel.org/lkml/20231030063652.68675-1-nikunj@amd.com/
v4: https://lore.kernel.org/lkml/20230814055222.1056404-1-nikunj@amd.com/
v3: https://lore.kernel.org/lkml/20230722111909.15166-1-nikunj@amd.com/
v2: https://lore.kernel.org/r/20230307192449.24732-1-bp@alien8.de/
v1: https://lore.kernel.org/r/20230130120327.977460-1-nikunj@amd.com 


Nikunj A Dadhania (24):
  virt: sev-guest: Use AES GCM crypto library
  virt: sev-guest: Replace dev_dbg with pr_debug
  virt: sev-guest: Make payload a variable length array
  virt: sev-guest: Add SNP guest request structure
  virt: sev-guest: Fix user-visible strings
  virt: sev-guest: Simplify VMPCK and sequence number assignments
  virt: sev-guest: Store VMPCK index to SNP guest device structure
  virt: sev-guest: Take mutex in snp_send_guest_request()
  virt: sev-guest: Carve out SNP guest messaging init/exit
  x86/sev: Move core SEV guest driver routines to common code
  x86/sev: Replace dev_[err,alert] with pr_[err,alert]
  x86/sev: Make snp_issue_guest_request() static
  x86/sev: Make sev-guest driver functional again
  x86/sev: Handle failures from snp_init()
  x86/sev: Cache the secrets page address
  x86/sev: Drop sev_guest_platform_data structure
  x86/cc: Add CC_ATTR_GUEST_SECURE_TSC
  x86/sev: Add Secure TSC support for SNP guests
  x86/sev: Change TSC MSR behavior for Secure TSC enabled guests
  x86/sev: Prevent RDTSC/RDTSCP interception for Secure TSC enabled
    guests
  x86/kvmclock: Skip kvmclock when Secure TSC is available
  x86/sev: Mark Secure TSC as reliable
  x86/cpu/amd: Do not print FW_BUG for Secure TSC
  x86/sev: Enable Secure TSC for SNP guests

 arch/x86/include/asm/sev-common.h       |   1 +
 arch/x86/include/asm/sev.h              | 197 ++++++-
 arch/x86/include/asm/svm.h              |   6 +-
 drivers/virt/coco/sev-guest/sev-guest.h |  63 ---
 include/linux/cc_platform.h             |   8 +
 arch/x86/boot/compressed/sev.c          |   3 +-
 arch/x86/coco/core.c                    |   3 +
 arch/x86/kernel/cpu/amd.c               |   3 +-
 arch/x86/kernel/kvmclock.c              |   2 +-
 arch/x86/kernel/sev-shared.c            |  10 +
 arch/x86/kernel/sev.c                   | 581 +++++++++++++++++--
 arch/x86/mm/mem_encrypt.c               |   4 +
 arch/x86/mm/mem_encrypt_amd.c           |   4 +
 arch/x86/mm/mem_encrypt_identity.c      |   7 +
 drivers/virt/coco/sev-guest/sev-guest.c | 711 +++---------------------
 arch/x86/Kconfig                        |   1 +
 drivers/virt/coco/sev-guest/Kconfig     |   3 -
 17 files changed, 843 insertions(+), 764 deletions(-)
 delete mode 100644 drivers/virt/coco/sev-guest/sev-guest.h


base-commit: 1613e604df0cd359cf2a7fbd9be7a0bcfacfabd0
-- 
2.34.1


