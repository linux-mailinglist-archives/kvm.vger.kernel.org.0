Return-Path: <kvm+bounces-5364-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D4318820765
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 17:32:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4BA8B1F21935
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 16:32:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB929F9FC;
	Sat, 30 Dec 2023 16:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="VDsiBu6h"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2077.outbound.protection.outlook.com [40.107.244.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6909215AC7;
	Sat, 30 Dec 2023 16:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sx4jhGs93BXyNNoyPukTZV1XwASMGppU9q0pC6dwkH95l3g/FuRi8L/g8UnIJ3IZkhXB79F/jlD9KywB0rOIkp7SxIG6njpoQ+CFswGLUfADhCcw9qRELjMpFPvsJ1sf1TfNGFydHItkpxg9ahxQ043bVVz24oGzdQXFDeUmHUaGFzDr+Va+Pi28fpBDbcTLvlx9f8wiEwXlPMZ7qaM2KUyHdOf/QWdg2H63J/bLlQri8RiLPJkFm2CuLgFyAlXOZ5HyTj0pLwlujrJaHgk6Hy1+9eOr7T+50x7QYBdpKkFNhtFJq5J6ABCT8zzS9VL4kANAC3lVEPH4cwb4rXAkvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=so/M/yuLaYQT82hFvKbUaVO2X0RY5jcv/5tOG5PsNH4=;
 b=LRICl5rkaqdmIEqUkXn8LkoKlQEoVvAWZDu3ChLHG7+l92+O2D0Xo31hopDmtt47WsucwchXCnLKho2u/7a1qDno1jIIZO/Z+X8Q30YD+Nc+W8F/WvDyj4dBcMWtMPWktpvnywT0krqE7s4apquPc1l5RVlj0XKJ1gqvPXLvgfCQDwNNCMy8N3K9F1N1kWFacRonp5yn0mqmlior8Hqk7wvFx1//8tViE/hC2y9BWtQpqvUz28e2VP91CbrO/x/budrkWcjGBTeV+eNCRj5/tv8JbdzR2tpRz/vziLUgibtEQcUs0KVJ3/+Baxdi2gLssBsbim87U0moXsQRhNxetA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=so/M/yuLaYQT82hFvKbUaVO2X0RY5jcv/5tOG5PsNH4=;
 b=VDsiBu6hGSCvq0r7Tm1gJKQqoA7teYKiibtLR/P+368IeWXYh9SYweQY9ArAFbmOGQ+cr8q2owI8C+DM9uzcu4u6iWxf1AtgJMG7QNmmtTf7FmIDJYIQxRISIcOna6M7r9xA5WPqUkbqE2vF2AYYW8dnWUYmI/6iqKfLYD+OZMo=
Received: from DM6PR06CA0089.namprd06.prod.outlook.com (2603:10b6:5:336::22)
 by SA0PR12MB4382.namprd12.prod.outlook.com (2603:10b6:806:9a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.22; Sat, 30 Dec
 2023 16:28:43 +0000
Received: from DS1PEPF00017098.namprd05.prod.outlook.com
 (2603:10b6:5:336:cafe::49) by DM6PR06CA0089.outlook.office365.com
 (2603:10b6:5:336::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.20 via Frontend
 Transport; Sat, 30 Dec 2023 16:28:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF00017098.mail.protection.outlook.com (10.167.18.102) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Sat, 30 Dec 2023 16:28:43 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Sat, 30 Dec
 2023 10:28:42 -0600
From: Michael Roth <michael.roth@amd.com>
To: <x86@kernel.org>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
	<thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<jmattson@google.com>, <luto@kernel.org>, <dave.hansen@linux.intel.com>,
	<slp@redhat.com>, <pgonda@google.com>, <peterz@infradead.org>,
	<srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
	<tobin@ibm.com>, <bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>
Subject: [PATCH v1 00/26] Add AMD Secure Nested Paging (SEV-SNP) Initialization Support
Date: Sat, 30 Dec 2023 10:19:28 -0600
Message-ID: <20231230161954.569267-1-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
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
X-MS-TrafficTypeDiagnostic: DS1PEPF00017098:EE_|SA0PR12MB4382:EE_
X-MS-Office365-Filtering-Correlation-Id: 3984a4b6-09c7-4849-b570-08dc0954637d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	KbUM8hT4UmD/CSMImQjHw9jsmcQUw7ittfp+05lyteIFufrP3Z53nL14VGz5YeNJu6DIbhZgYuYyxA0sf3gMbFwvpRg0UpcJl9IZ5Egj99UEK5XZoGawG7/YeFMWFoLMVEckhBYM3+XMuF1quT6151DKzAslnIgPaB2KGLAjaB6R219h7hMcrLcF8m9W8SG48usrfCI9cmrfha9s7mTdxo9Pu1ksHn5Us91EaJvrBCdXjglmMF4875KJYxZsABbehdjKclqnlP/ytVigrjvpMYgcAiDgDXwrvTrrz9VQMvW8hGKFQNQ5PedEuMNwSK1H9kzO5gw93rBEAAByYbbdPQ8Z9jatQs+EIuKizLtpf6d0R4ZCo8S+h7XZJX3yJ+jnQjJ+vmzUhesLnnOzGvfgmnNvYAcGTWEY2kLxLypfNyEnlScyG9tfbYLgorhYnhVHx4TZr2ln83TLanPRcYzF1SIu5g0NPp9nG2Px5mtpl9xR8y/xImXFgl+hT4WCoT5NB3wBfK/vx2k3X101zj/pKJ4AOQr+O5yMGrEXJWtOi1nRNpgpYaFE/wGEJsR/iUIMZqOHcQnuL+h5z3P+5Es4kU7uGQVrUDcP3V7j5LTF6xHxNg3nbaZS5ocCpYbu2iqN7l0AhXCDrO7VtZd3njDunD0mW02uJ/wtUBHx/9g9iCRtoMfT84Trd+W9/qPi61R9P92qB5uCovRCVMQKNHgDpRGUXxxdDnh6qw0PzOhuFgYNVA8FE1gZd9Hvn83hcGV/OqffoTv/XyOHSkHVOcKwvkxoIdT0x/Zq3jM2qPRF40eQ8Bp+cMaCjfUWQkWt3Wyp4N7Q0t/T0CEYcYMwAWqLTg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(376002)(346002)(136003)(396003)(230273577357003)(230922051799003)(230173577357003)(1800799012)(451199024)(64100799003)(82310400011)(186009)(40470700004)(46966006)(36840700001)(40480700001)(66899024)(40460700003)(426003)(336012)(16526019)(2616005)(26005)(83380400001)(1076003)(86362001)(36756003)(81166007)(82740400003)(356005)(47076005)(4326008)(44832011)(5660300002)(7416002)(7406005)(6666004)(36860700001)(54906003)(8936002)(8676002)(70586007)(316002)(70206006)(6916009)(2906002)(966005)(41300700001)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2023 16:28:43.0072
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3984a4b6-09c7-4849-b570-08dc0954637d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017098.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4382

This patchset is also available at:

  https://github.com/amdese/linux/commits/snp-host-init-v1

and is based on top of linux-next tag next-20231222

These patches were originally included in v10 of the SNP KVM/hypervisor
patches[1], but have been split off from the general KVM support for easier
review and eventual merging into the x86 tree. They are based on linux-next
to help stay in sync with both tip and kvm-next.

There is 1 KVM-specific patch here since it is needed to avoid regressions
when running legacy SEV guests while the RMP table is enabled.

== OVERVIEW ==

AMD EPYC systems utilizing Zen 3 and newer microarchitectures add support
for a new feature called SEV-SNP, which adds Secure Nested Paging support
on top of the SEV/SEV-ES support already present on existing EPYC systems.

One of the main features of SNP is the addition of an RMP (Reverse Map)
table to enforce additional security protections for private guest memory.
This series primarily focuses on the various host initialization
requirements for enabling SNP on the system, while the actual KVM support
for running SNP guests is added as a separate series based on top of these
patches.

The basic requirements to initialize SNP support on a host when the feature
has been enabled in the BIOS are:

  - Discovering and initializing the RMP table
  - Initializing various MSRs to enable the capability across CPUs
  - Various tasks to maintain legacy functionality on the system, such as:
    - Setting up hooks for handling RMP-related changes for IOMMU pages
    - Initializing SNP in the firmware via the CCP driver, and implement
      additional requirements needed for continued operation of legacy
      SEV/SEV-ES guests

Additionally some basic SEV ioctl interfaces are added to configure various
aspects of SNP-enabled firmwares via the CCP driver.

More details are available in the SEV-SNP Firmware ABI[2].

== KNOWN ISSUES ==

  - When SNP is enabled, it has been observed that TMR allocation may fail when
    reloading CCP driver after kexec. This is being investigated.

Feedback/review is very much appreciated!

-Mike

[1] https://lore.kernel.org/kvm/20231016132819.1002933-1-michael.roth@amd.com/ 
[2] https://www.amd.com/en/developer/sev.html 


Changes since being split off from v10 hypervisor patches:

 * Move all host initialization patches to beginning of overall series and
   post as a separate patchset. Include only KVM patches that are necessary
   for maintaining legacy SVM/SEV functionality with SNP enabled.
   (Paolo, Boris)
 * Don't enable X86_FEATURE_SEV_SNP until all patches are in place to maintain
   legacy SVM/SEV/SEV-ES functionality when RMP table and SNP firmware support
   are enabled. (Paolo)
 * Re-write how firmware-owned buffers are handled when dealing with legacy
   SEV commands. Allocate on-demand rather than relying on pre-allocated pool,
   use a descriptor format for handling nested/pointer params instead of
   relying on macros. (Boris)
 * Don't introduce sev-host.h, re-use sev.h (Boris)
 * Various renames, cleanups, refactorings throughout the tree (Boris)
 * Rework leaked pages handling (Vlastimil)
 * Fix kernel-doc errors introduced by series (Boris)
 * Fix warnings when onlining/offlining CPUs (Jeremi, Ashish)
 * Ensure X86_FEATURE_SEV_SNP is cleared early enough that AutoIBRS will still
   be enabled if RMP table support is not available/configured. (Tom)
 * Only read the RMP base/end MSR values once via BSP (Boris)
 * Handle IOMMU SNP setup automatically based on state machine rather than via
   external caller (Boris)

----------------------------------------------------------------
Ashish Kalra (5):
      iommu/amd: Don't rely on external callers to enable IOMMU SNP support
      x86/mtrr: Don't print errors if MtrrFixDramModEn is set when SNP enabled
      x86/sev: Introduce snp leaked pages list
      iommu/amd: Clean up RMP entries for IOMMU pages during SNP shutdown
      crypto: ccp: Add panic notifier for SEV/SNP firmware shutdown on kdump

Brijesh Singh (16):
      x86/cpufeatures: Add SEV-SNP CPU feature
      x86/sev: Add the host SEV-SNP initialization support
      x86/sev: Add RMP entry lookup helpers
      x86/fault: Add helper for dumping RMP entries
      x86/traps: Define RMP violation #PF error code
      x86/sev: Add helper functions for RMPUPDATE and PSMASH instruction
      x86/sev: Invalidate pages from the direct map when adding them to the RMP table
      crypto: ccp: Define the SEV-SNP commands
      crypto: ccp: Add support to initialize the AMD-SP for SEV-SNP
      crypto: ccp: Provide API to issue SEV and SNP commands
      crypto: ccp: Handle the legacy TMR allocation when SNP is enabled
      crypto: ccp: Handle legacy SEV commands when SNP is enabled
      crypto: ccp: Add debug support for decrypting pages
      KVM: SEV: Make AVIC backing, VMSA and VMCB memory allocation SNP safe
      crypto: ccp: Add the SNP_PLATFORM_STATUS command
      crypto: ccp: Add the SNP_SET_CONFIG command

Kim Phillips (1):
      x86/speculation: Do not enable Automatic IBRS if SEV SNP is enabled

Michael Roth (2):
      x86/fault: Dump RMP table information when RMP page faults occur
      x86/cpufeatures: Enable/unmask SEV-SNP CPU feature

Tom Lendacky (2):
      crypto: ccp: Handle non-volatile INIT_EX data when SNP is enabled
      crypto: ccp: Add the SNP_COMMIT command

 Documentation/virt/coco/sev-guest.rst    |   51 ++
 arch/x86/Kbuild                          |    2 +
 arch/x86/include/asm/cpufeatures.h       |    1 +
 arch/x86/include/asm/disabled-features.h |    8 +-
 arch/x86/include/asm/iommu.h             |    1 +
 arch/x86/include/asm/kvm-x86-ops.h       |    1 +
 arch/x86/include/asm/kvm_host.h          |    1 +
 arch/x86/include/asm/msr-index.h         |   11 +-
 arch/x86/include/asm/sev.h               |   36 +
 arch/x86/include/asm/trap_pf.h           |   20 +-
 arch/x86/kernel/cpu/amd.c                |   20 +-
 arch/x86/kernel/cpu/common.c             |    7 +-
 arch/x86/kernel/cpu/mtrr/generic.c       |    3 +
 arch/x86/kernel/crash.c                  |    7 +
 arch/x86/kvm/lapic.c                     |    5 +-
 arch/x86/kvm/svm/nested.c                |    2 +-
 arch/x86/kvm/svm/sev.c                   |   37 +-
 arch/x86/kvm/svm/svm.c                   |   17 +-
 arch/x86/kvm/svm/svm.h                   |    1 +
 arch/x86/mm/fault.c                      |    5 +
 arch/x86/virt/svm/Makefile               |    3 +
 arch/x86/virt/svm/sev.c                  |  513 +++++++++++++
 drivers/crypto/ccp/sev-dev.c             | 1216 +++++++++++++++++++++++++++---
 drivers/crypto/ccp/sev-dev.h             |    5 +
 drivers/iommu/amd/amd_iommu.h            |    1 -
 drivers/iommu/amd/init.c                 |  120 ++-
 include/linux/amd-iommu.h                |    6 +-
 include/linux/psp-sev.h                  |  337 ++++++++-
 include/uapi/linux/psp-sev.h             |   59 ++
 tools/arch/x86/include/asm/cpufeatures.h |    1 +
 30 files changed, 2359 insertions(+), 138 deletions(-)
 create mode 100644 arch/x86/virt/svm/Makefile
 create mode 100644 arch/x86/virt/svm/sev.c




