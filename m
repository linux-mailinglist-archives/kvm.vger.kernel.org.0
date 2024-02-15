Return-Path: <kvm+bounces-8746-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BC175856199
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 12:32:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 478EB1F20F66
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 11:32:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1251D12AAD6;
	Thu, 15 Feb 2024 11:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Kgp3mP4q"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2058.outbound.protection.outlook.com [40.107.244.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31BF76341F;
	Thu, 15 Feb 2024 11:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707996725; cv=fail; b=Y/rZvun3pQKv2o/u4GW/94lkxScaRXf5fbI8lV0jZn6msRkEb2r1u791ojRRGFFBkXn2war/lB0hPlfDMI6qzIQGyKGFAvJ6PawiyWHHZEQg3PEBITudcMm1xBQHh4gTcPIL93iXu5k/7iBvggkre1QeIlR2ilqEFgJL3o/sX40=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707996725; c=relaxed/simple;
	bh=2kC5QKSJnXJxFnv8+H0y0d4pkovGBiETls+Yl6p9YtY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=k59RlMNUM8Q772uLZY3BK7Js6Dxit/SGi21dEp4gLVSPkRW3TjR+CyCFk8dy1b+m/CxXW/7QSESmP2I1xFLj7T2IkYjgU0cYT40MzdaJw4Hbehqlc2Evg1ocQS+dHNIWJUIA7I+euBLKysiEK9Bw57/ipIu945t4/UuB2wQ/GUU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Kgp3mP4q; arc=fail smtp.client-ip=40.107.244.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JtoHzlFeYgZkBPOCgQ2WG/jFDwcfuoLmq/+2mZGeBcZzeEtVuRb4CXyvNMjg+RfY/tI2DWzNgVENbCMlyB33g3vMUq47eJC9hvjC5MvOtrBQG+hdmR8F+xdTsouspEiAb4FjBI8RXoWjSFTBI23sN+5MJOsDTANqSPaUIaYU/727WfTeUpaydKKxH0fW66vjW12lxa1M4ruIKVP4wh+sCfhuh4GrTbsMwffU8d1wfhdLs0LqBJC/abRFjzWJLRO3KU0tlTWaddOJeqMdT2C3tJ9HnAhpBwN+LSZ6WvZojFBPCUM8qwJaG7iLI2IxQpysyu6NBzD37OMqaCdgVyXhmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Izq67tQUxqtA4rBw5NLTlCAcObQj3gR5u4AmP2evTmM=;
 b=kIsAX6TqbMcyNly5MjWj2LCNRYwgsuu2SJxzSulWakcwH4eJeuJ9cCyJLFKNcp5hWJk1CjnN65Ibs2zzEUsVXgVcSzixAWxO5ptT9SLBvim3zltq6aZcEmFfdb/Aic3w4Q8RwJCuEqL1DW9CzqUkSe4ChhK7GcWBAwdD/edIhtyb8QanvjF/ETsjC5+igs8n9dlOmlcw/ga/rH/uohXoXat2QOgy7T8qIAv5XtniZ3cUT8I6DKDyG3VihX2Qre2B5oOcVEdryW6+tqrtI/RS9RIuQTZlK7m0m601sA+QCLuD9QIEHrtcEUhWhCkM9RYjlwW0bkSxpAYhu3Eutuhv2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Izq67tQUxqtA4rBw5NLTlCAcObQj3gR5u4AmP2evTmM=;
 b=Kgp3mP4qLeoQtRxkmtB/rOTsGWcUXVjXS99SbAAB8UIrTQKClWwFm9Solgb+yXIEhTefCN8SIquVgoBTPNA5+5ZCrpVrg/NmLkEZ8mTsFDzJhid/xsv84AMDMe400hBrN+eUoQ2Du3YzippXVvb5iR2CnOAMqvxh0HawiRh05Kw=
Received: from MN2PR02CA0013.namprd02.prod.outlook.com (2603:10b6:208:fc::26)
 by CH0PR12MB5124.namprd12.prod.outlook.com (2603:10b6:610:bf::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.12; Thu, 15 Feb
 2024 11:31:58 +0000
Received: from BL02EPF0001A0FB.namprd03.prod.outlook.com
 (2603:10b6:208:fc:cafe::53) by MN2PR02CA0013.outlook.office365.com
 (2603:10b6:208:fc::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.39 via Frontend
 Transport; Thu, 15 Feb 2024 11:31:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0001A0FB.mail.protection.outlook.com (10.167.242.102) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7292.25 via Frontend Transport; Thu, 15 Feb 2024 11:31:58 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 15 Feb
 2024 05:31:54 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v8 00/16] Add Secure TSC support for SNP guests
Date: Thu, 15 Feb 2024 17:01:12 +0530
Message-ID: <20240215113128.275608-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0FB:EE_|CH0PR12MB5124:EE_
X-MS-Office365-Filtering-Correlation-Id: 3517c517-43fc-4709-f53e-08dc2e19b859
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	vymT88TFLj8Ey4ZFHDlJQYdJVuC1gN+P10JtuLoPHRuDnKqimsANe+lx1BtpI7JAXkWJgYAcTFYFExBNL7+OXfmZmUBCIZ6H991CMVlRGNCC+ec4rZctKnw98Q5lrxJzrvzZ2zFRWtiJAsOXW1nhp2VFoqXxFSRCpzBXQ1rwr9Rm+iXnnGVMLHnHAMTmoeReDBJo7yI7y2xvtA7QpcUR5eH7kYAWOtPv56KIBHdxwQbNJaEZUOjoAzQFfD97w6ylPtV6lVtdbnm827YQqlmEHPkOJhziy1bP1PmYmLTLg6GNiGmAjVZBon3kPa4cV4c1BAT4oF6tUupHvvsbc9P4iaXCxPodaSlGS1QhMubFHKQ0e9vPjNNRz7rgLoblw8m3vZ9P7LoM2ni9vV3t9J86eo47FnPkV//6IIOXc1eOWF/GKEL/BGqWv7UnCpSJEC/Ig24HqupFu1qMoIPt/MWD8V1zarPAfBFqG3HYm5KJBiRVOTqyClDlNoS1X5/KYl5klyTZNm6lI8vl0A224fPy8FaAVmeSLbaDv0HfRDMyzEyvM5H7G53bdDSMuST8+ekEYHjjsKKFhWQ8ClDmXpgseDmq8vE0/KTJENSh3LY93D7cGzrcdVF2v7KQs4PY4c0elyoBjUqKhSvqkj9yFMdQmUm55T6FgR1EBOdQAvQ9FZ+qJd8bEa/yGbAVzZ09la9w
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(136003)(39860400002)(346002)(376002)(230922051799003)(186009)(451199024)(82310400011)(1800799012)(36860700004)(64100799003)(46966006)(40470700004)(2906002)(5660300002)(7416002)(8676002)(4326008)(8936002)(336012)(426003)(83380400001)(2616005)(1076003)(26005)(16526019)(82740400003)(36756003)(356005)(81166007)(54906003)(316002)(70586007)(110136005)(70206006)(7696005)(478600001)(966005)(6666004)(41300700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2024 11:31:58.1262
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3517c517-43fc-4709-f53e-08dc2e19b859
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A0FB.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5124

This patchset is also available at:

  https://github.com/AMDESE/linux-kvm/tree/sectsc-guest-latest

and is based on tip/x86/sev base commit ee8ff8768735
("crypto: ccp - Have it depend on AMD_IOMMU")

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
01-08: Preparation and movement of sev-guest driver code
09-16: SecureTSC enablement patches.

Testing SecureTSC
-----------------

SecureTSC hypervisor patches based on top of SEV-SNP Guest MEMFD series:
https://github.com/AMDESE/linux-kvm/tree/sectsc-host-latest

QEMU changes:
https://github.com/nikunjad/qemu/tree/snp-securetsc-latest

QEMU commandline SEV-SNP with SecureTSC:

  qemu-system-x86_64 -cpu EPYC-Milan-v2,+securetsc,+invtsc -smp 4 \
    -object memory-backend-memfd,id=ram1,size=1G,share=true,prealloc=false,reserve=false \
    -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,secure-tsc=on \
    -machine q35,confidential-guest-support=sev0,memory-backend=ram1 \
    ...

Changelog:
----------
v8:
* Rebased on top of tip/x86/sev
* Use minimum size of IV or msg_seqno in memcpy
* Use arch/x86/include/asm/sev.h instead of sev-guest.h
* Use DEFINE_MUTEX for snp_guest_cmd_mutex
* Added Reviewed-by from Tom.
* Dropped Tested-by from patch 3/16
 
https://lore.kernel.org/kvm/20231220151358.2147066-1-nikunj@amd.com/

v7:
* Drop mutex from the snp_dev and add snp_guest_cmd_{lock,unlock} API
* Added comments for secrets page failure
* Added define for maximum supported VMPCK
* Updated comments why sev_status is used directly instead of
  cpu_feature_enabled()

https://lore.kernel.org/kvm/20231220151358.2147066-1-nikunj@amd.com/

v6: https://lore.kernel.org/lkml/20231128125959.1810039-1-nikunj@amd.com/
v5: https://lore.kernel.org/lkml/20231030063652.68675-1-nikunj@amd.com/
v4: https://lore.kernel.org/lkml/20230814055222.1056404-1-nikunj@amd.com/
v3: https://lore.kernel.org/lkml/20230722111909.15166-1-nikunj@amd.com/
v2: https://lore.kernel.org/r/20230307192449.24732-1-bp@alien8.de/
v1: https://lore.kernel.org/r/20230130120327.977460-1-nikunj@amd.com

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
 arch/x86/include/asm/sev.h              | 206 ++++++-
 arch/x86/include/asm/svm.h              |   6 +-
 arch/x86/include/asm/x86_init.h         |   2 +
 arch/x86/kernel/cpu/amd.c               |   3 +-
 arch/x86/kernel/kvmclock.c              |   2 +-
 arch/x86/kernel/sev-shared.c            |  10 +
 arch/x86/kernel/sev.c                   | 648 +++++++++++++++++++--
 arch/x86/kernel/x86_init.c              |   2 +
 arch/x86/mm/mem_encrypt.c               |  12 +-
 arch/x86/mm/mem_encrypt_amd.c           |  12 +
 drivers/virt/coco/sev-guest/Kconfig     |   3 -
 drivers/virt/coco/sev-guest/sev-guest.c | 725 ++++--------------------
 drivers/virt/coco/sev-guest/sev-guest.h |  63 --
 17 files changed, 937 insertions(+), 763 deletions(-)
 delete mode 100644 drivers/virt/coco/sev-guest/sev-guest.h


base-commit: ee8ff8768735edc3e013837c4416f819543ddc17
-- 
2.34.1


