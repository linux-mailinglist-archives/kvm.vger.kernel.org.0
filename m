Return-Path: <kvm+bounces-2597-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FF837FBAAA
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 14:00:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 47FDB282313
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 13:00:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6036256442;
	Tue, 28 Nov 2023 13:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2gyp+yVM"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2042.outbound.protection.outlook.com [40.107.244.42])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF0D3D60;
	Tue, 28 Nov 2023 05:00:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fZ0S37xWlYhBFAo24vsJUnxvmVfDxF78c0nUs5sdbVUOvddWvIKCQbhIiP5z1sPzyo9HABUX1U2qPspgAwitQF5Pmdu/x9ctMYiHX97IJJ7mZ7TkB9tMzzYJNSvMBoPrZ55WO+nCIfEQBt0Ix34LtNGNEdeeyxf1G1hhdr7XPzNBfakzykOnWrdGhRhYzHFLAtFRG2SGhAs+2wVkhxn7D9sBPLNGEr7gdIbRO5FyqhtUXTdNVmBZa/YxyeJBoqY2RyB3uxhTc1vVpPZyAMoPkfH5GctXTrPxmhPO8qmzzAWHeq0zyofzgOLgFYNP8Of2IK3v/XjCI3FIHxlKlyUpDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y/Sb3Cd+daEyZ4iYQl5u0qO7UzXLWixS1gcRcG118/k=;
 b=NvD3ZQ+9Ved9TNzXgBY941Yd7uC+9+p1EkMEElb3rSDe5H6z0W8cYeQ+YfLW5CV6U/cVDwSDDCEnE9takM5VC7vOVy9NwfE8LTrD7IrdFVSkxfkZG6FQ2L0pJo4Dh8Eww2NdVuhyPMo+tF7PBQHxuScLZUoSSXsL4JbwjsloMo+2YqAw0PGAAg1o4THP+TGylcECGKU5Fy0z2zqd/UHmPKVKUMPaLf1FtuvVgoXl64fiPgb6wcrreY39ehUm02zeqnddG5IJsWNZ9rY+voq06KCZu4GSzxCPqYdmTKAzqMkxxPMWCALaSaWtGQLEeSJespC9Vx5fRviY0fk+HwUdIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y/Sb3Cd+daEyZ4iYQl5u0qO7UzXLWixS1gcRcG118/k=;
 b=2gyp+yVMMFNFookgMVmlhaYT6OAdLQIkblRFYf53RYEXS4q3eh3WOwE76pyqcYEXQ0TAcwWC8LGRwHKdRNdwq0+4Unv96ssHf4noQxQtEVOJhhC0H7SQ+RnjrCZiAM5vRjqKIrCA35dmKskZ5Cr1PYsyJjXFogGyOgREf8E7Y2w=
Received: from DM6PR07CA0131.namprd07.prod.outlook.com (2603:10b6:5:330::19)
 by DS7PR12MB5766.namprd12.prod.outlook.com (2603:10b6:8:75::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.28; Tue, 28 Nov
 2023 13:00:30 +0000
Received: from CY4PEPF0000EE37.namprd05.prod.outlook.com
 (2603:10b6:5:330:cafe::d4) by DM6PR07CA0131.outlook.office365.com
 (2603:10b6:5:330::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.29 via Frontend
 Transport; Tue, 28 Nov 2023 13:00:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE37.mail.protection.outlook.com (10.167.242.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7046.17 via Frontend Transport; Tue, 28 Nov 2023 13:00:30 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Tue, 28 Nov
 2023 07:00:22 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <bp@alien8.de>, <mingo@redhat.com>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>, <dionnaglaze@google.com>, <pgonda@google.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>
Subject: [PATCH v6 00/16] Add Secure TSC support for SNP guests 
Date: Tue, 28 Nov 2023 18:29:43 +0530
Message-ID: <20231128125959.1810039-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE37:EE_|DS7PR12MB5766:EE_
X-MS-Office365-Filtering-Correlation-Id: 3be59b70-71c3-485b-8582-08dbf0120006
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	a6jK1RAUeVg68Gjo/gUgCXr5axPMp0zQIyMz/XdWE6xBAzcSivqvKnigDrPtPzvRQgbRka9jkBraK2Qt9y+iVID8ryoFqLKGk4Z8GfNwgF0+A78lntWNz7Y9I1cmT0od9BbD1IGGuLUANWYY6k0w1X8e4GMtvFhUtO8Z6NfmMkIaH1eJfVQAJL+y0fvsi8QtbuUIdXUUrhCBlDwJBYv3YR8O4ihblqp6/0wL9APq0XV06yluEUhcTZu5YM0MCDRFnEWCRO1CiArtgbELC9rG7eiqzLb836fcGaobzrEzJxPUfsdS+V7JbnRN82OY4qwVZUUEvnimIc6sQMRC+Op/EuF470+Ocuj3YokFpEfHgSb1c1aTVZgqgkLe1X1K4MGbaeeKpx4S3klPcBDkALtKtjrVWpfQtzCXGUd/TYnVJJ7Ddtqghf78+6DwL6xYFs026zU/MQU7bESC43n81NdH4QIuSy18wfXtZODc9qp8CMw/4EALgr4/wZMyr+vbBp5TdfwammlrrfT6D7wZ/0/snoIAv93y9WWo3A/n3tHwrxi29OdwQf/MtADiIAeMOue/NpWvMAdzMkvoxgjIAx8fuIX68PUgvVf7Hd7g9q+JCD5oJeY0ij4YukUgXkyPZdjyMQ5HPzBKFjGYqY7MrGpZjJ9MMlb8/PeHpWvxfoFyDi6GpBQOm6TJvVo1rdRyDaLY278aFh8rVDD1mu1TokiCkehmNO/+EJtO73oSh987261Cz+r+24VexsyVWM5pWxzq5YS/6VzsyWaTDyuQXowgmFA7dxZvbn5tHfTSoHIvG8U=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(396003)(39860400002)(346002)(376002)(230922051799003)(82310400011)(64100799003)(451199024)(186009)(1800799012)(36840700001)(40470700004)(46966006)(40480700001)(36860700001)(41300700001)(6666004)(40460700003)(5660300002)(2906002)(7416002)(83380400001)(356005)(8936002)(4326008)(54906003)(8676002)(966005)(110136005)(70586007)(1076003)(2616005)(316002)(16526019)(7696005)(26005)(336012)(82740400003)(70206006)(36756003)(426003)(81166007)(4743002)(47076005)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2023 13:00:30.2468
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3be59b70-71c3-485b-8582-08dbf0120006
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE37.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5766

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
  virt: sev-guest: Move mutex to SNP guest device structure
  virt: sev-guest: Replace dev_dbg with pr_debug
  virt: sev-guest: Add SNP guest request structure
  virt: sev-guest: Add vmpck_id to snp_guest_dev struct
  x86/sev: Cache the secrets page address
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
 arch/x86/include/asm/sev-guest.h        | 191 +++++++
 arch/x86/include/asm/sev.h              |  20 +-
 arch/x86/include/asm/svm.h              |   6 +-
 arch/x86/include/asm/x86_init.h         |   2 +
 arch/x86/kernel/cpu/amd.c               |   3 +-
 arch/x86/kernel/kvmclock.c              |   2 +-
 arch/x86/kernel/sev-shared.c            |  10 +
 arch/x86/kernel/sev.c                   | 622 ++++++++++++++++++++--
 arch/x86/kernel/x86_init.c              |   2 +
 arch/x86/mm/mem_encrypt.c               |  12 +-
 arch/x86/mm/mem_encrypt_amd.c           |  11 +
 drivers/virt/coco/sev-guest/Kconfig     |   3 -
 drivers/virt/coco/sev-guest/sev-guest.c | 661 +++---------------------
 drivers/virt/coco/sev-guest/sev-guest.h |  63 ---
 18 files changed, 888 insertions(+), 726 deletions(-)
 create mode 100644 arch/x86/include/asm/sev-guest.h
 delete mode 100644 drivers/virt/coco/sev-guest/sev-guest.h


base-commit: 98b1cc82c4affc16f5598d4fa14b1858671b2263
-- 
2.34.1


