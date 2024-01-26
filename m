Return-Path: <kvm+bounces-7053-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A21AD83D384
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 05:41:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5858B28C5CC
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 04:41:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3ECB0C8DE;
	Fri, 26 Jan 2024 04:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="YWRBjBvV"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2049.outbound.protection.outlook.com [40.107.237.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78C278F5F;
	Fri, 26 Jan 2024 04:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706244072; cv=fail; b=RSaAgQoScyRbY7XRZNgD7CxUTOMFVUCWEpYmpprypJAtxA4gc1iuFQdLfFhgKdqdOMU+YgcghPBoFWQsMnHh0g9hqDtQQk0Hfyb9o3S8RTleqfvjPrtn9rOSqaZ0wjL1j5Fy5+raa3QLH3oSyYyRoHpAVjbFA8wsrzqIIzRHcYA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706244072; c=relaxed/simple;
	bh=1qPuOqeY5psstNJMacUoIGV+qfXuWG819xYEuyRAnvI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=CuiUlRTnefBBd0ZjLKv5n23FfQ+M4w8SLW8hdu/muA3Ne+TiNc7WA6+e/nQILZvRgIFEZUmjZDDW7YUv8I860YbxGNT+nTCJfAMF7a4sMWNcmjxljdH5gEXj4xaM6Fuh2+fCp5IQUm5iH9L25yn+4GGxqcx1bwMwKT90jWUCnQ8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=YWRBjBvV; arc=fail smtp.client-ip=40.107.237.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=alnhw+j95RulWSGhUVnJKBgA5zG86wxaweLMCKFb7CuuA7MyZ/5Dh6RSH1Naopf6cAOlCJw0gLmf3ouxwIs5BSwkLRzPQ4T93m5MJTwYhzLg8yiuNqdFPp3/oHMl7bcW4z88KmfI3lHj2SQHxMU7PZPyuLdcLPO0ySQCMAOLhh0BmfnKaiFXkSLNzBiwh4Qj+3hMNs4H1iLZrWMVkmbRE7F8jxq35XaN42pcgVMWWF3QaKWeBV6vOix54rDqCc/mkUt9AhnOaMl0QBykCkP9i3QbmE1e0GRXMZsrwMh4VBA2aW3j98w3UqWpXBaY51SSVvkGyScS5POBn2eXCiwcnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=owBUFj1qyHr+ghfXNxBQt0eG1QA/8bJOhfuHUcCBYrE=;
 b=JNQZQSGS1HUqmlKiToQ7jfTiEVsdVBk6trfB8hGp2cPTWkefKT2d1LgGW+fmjHJC7QFFQ22m88icb/BARmaMKpF4kOncdnNLhJ83dz8w7nvwuUjL3MPaii4Qsr94sBQj/+ua9Yq6V7PjwPILOsB3MlMffGVr8ocLktsm6iajFQEjT5rx5ZUbIROWCx2oj4LYqfEBgL18AZ0pNo5fPEmw1IBGkSOG4ZsMe6pPlm/PKuGN896pNt9j+1H+igBVhtvt4e9r2+EC4L4JyL7syHrhUG0d59x+UjEUnE4eP9sUHLZ5Eot3IU0ZNsCkxia92FIcCaG1+DDkd0anlWGhl9ywqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=owBUFj1qyHr+ghfXNxBQt0eG1QA/8bJOhfuHUcCBYrE=;
 b=YWRBjBvVjnhKf7NVU2hDn4OXmyxlZBPyfCZHQWlVi8HGOLAGsVgV8idc/Ca2Xo71RY7GTExf15G22IwLIualeQPPslc7ReMxOTnyc/s550pzkhyS9ev6BO7ZRIzov8MUsvIp/AmlTInaS1LXqEkRLlQnyvlyR65F9TAsHDj+xkE=
Received: from BY5PR16CA0009.namprd16.prod.outlook.com (2603:10b6:a03:1a0::22)
 by DM4PR12MB6470.namprd12.prod.outlook.com (2603:10b6:8:b8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.22; Fri, 26 Jan
 2024 04:41:07 +0000
Received: from MWH0EPF000971E3.namprd02.prod.outlook.com
 (2603:10b6:a03:1a0:cafe::3b) by BY5PR16CA0009.outlook.office365.com
 (2603:10b6:a03:1a0::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.26 via Frontend
 Transport; Fri, 26 Jan 2024 04:41:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000971E3.mail.protection.outlook.com (10.167.243.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7228.16 via Frontend Transport; Fri, 26 Jan 2024 04:41:05 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Thu, 25 Jan
 2024 22:41:04 -0600
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>
Subject: [PATCH v2 00/25] Add AMD Secure Nested Paging (SEV-SNP) Initialization Support
Date: Thu, 25 Jan 2024 22:11:00 -0600
Message-ID: <20240126041126.1927228-1-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E3:EE_|DM4PR12MB6470:EE_
X-MS-Office365-Filtering-Correlation-Id: dcc413a0-a03d-4678-fb02-08dc1e290207
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	U6K1Frs+CO8KEbTZbtZ1lZzXstkXUmxGHr7rl4+Pwaen/HOtE2E6fdA0TZQZHJQihp1+pGvxjzgGwLYJfSDgCjDbGhHc2hVIcF1CgWJZ4TqIdNHh2IFUvaJSuaEVuIxJmqLpdodt8m4kCHsyAxKAj21QS8xURw+Th0xuH4Ylh1VfHFP6PYxyqjLCOiRgvhtnEZLh9hXH2Nancnf2Vx/YSmnmjXFZICONtDB3ch8TsKyqyuO2yJgEPjbUZCq5nk9ka03+An2HtAjcXA3Io3bQM2IYBiEeqYWsMv7c5XFtkTW4trznhYcEYeSA8uxlQQIaGFxspUfvm5rLsGssaxydck6tAxpoDLBl00xpnlVt8T7O/zzB4zIYSNGofTB/gkKGYiwBKVGAv8Q87G1Dan8UCzhAP+cw5F9A2xzxxZoHjEd9L4OuWl4qF1KzYNqh17pwnczJoPbx13vymDtQZl6uuZs7W0l1+fbxySMH7rJrmzQ9CpdfZVE7U2A2WCNfcGrqwXoNmL7KFHgv9bKik0aznv/G46+pbI5S7rhvtB2eEdwP92UKMFhE2Oga/2VHzV0CQEOQN+U9s/syosV4u78OT+QTfX6Vv6Irl2NnDEwTYPnh4UZomWppy35KcAFUHOVgVVYMnEhhQSsmmIwLJGBDz0YN9ZG2WbfJhLuBTaJAHG2zG2pcHJV8D8yvw2c9uXZGiVhNwkw2R2jKojvS0c/0T4zDCyoLJODF2FU8aHwAHJfzrNqz8Koq70PrVcT13pEa8CtSY4iy/pT4xgCKT8k1H02NahAz8tbY6b8ThfsA8ladds8z0MnC8y9irVm7noM1
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(39860400002)(136003)(376002)(346002)(230922051799003)(230273577357003)(230173577357003)(451199024)(186009)(1800799012)(64100799003)(82310400011)(46966006)(40470700004)(36840700001)(47076005)(82740400003)(36756003)(41300700001)(5660300002)(44832011)(40460700003)(70586007)(6916009)(316002)(966005)(1076003)(7406005)(356005)(6666004)(40480700001)(70206006)(54906003)(7416002)(83380400001)(2906002)(30864003)(336012)(4326008)(8936002)(2616005)(478600001)(8676002)(426003)(36860700001)(66899024)(26005)(86362001)(16526019)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 04:41:05.4775
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dcc413a0-a03d-4678-fb02-08dc1e290207
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E3.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6470

This patchset is also available at:

  https://github.com/amdese/linux/commits/snp-host-init-v2

and is based on top of linux-next tag next-20240125

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

Feedback/review is very much appreciated!

-Mike

[1] https://lore.kernel.org/kvm/20231016132819.1002933-1-michael.roth@amd.com/ 
[2] https://www.amd.com/en/developer/sev.html 

Changes since v1:

 * rebased on linux-next tag next-202401125
 * patch 26: crypto: ccp: Add the SNP_SET_CONFIG command
   - documentation updates (Boris)
 * patch 25: crypto: ccp: Add the SNP_COMMIT command
   - s/len/length/ in SNP_COMMIT kernel-doc (Boris)
   - s/length/len/ in struct for consistency with other cmds/structs
 * patch 24: crypto: ccp: Add the SNP_PLATFORM_STATUS command
   - add comments regarding the need for page reclaim of status page (Boris)
 * patch 21: crypto: ccp: Add panic notifier for SEV/SNP firmware shutdown on kdump
   - enable crash_kexec_post_notifiers by default for SNP (Ashish)
   - squash in refactorings from Boris, but keep wbinvd_on_all_cpus() so that
     non-SNP/non-panic case is still handled as it was prior to SNP.
 * patch 20: crypto: ccp: Add debug support for decrypting pages
   - not utilized in current code, dropped it for now (Sean)
 * patch 18: crypto: ccp: Handle legacy SEV commands when SNP is enabled
   - drop uneeded index variables used when rolling back descriptor mappings
     when failure occurs (Boris)
   - error message fixups (Boris)
   - fix indentation to align each argument description line to same column
     as recommended by kernel-doc documentation
   - attempt to unmap/reclaim all descriptors even if a previous unmap/reclaim
     failed
   - s/restored to/restored to hypervisor-owned/ in commit message
   - fix reclaim clobbering return value when a command failure occurs
   - reclaim cmd buffers and descriptors separately so that active cmd buffers
     can be marked !inuse even when reclaim for a descriptor fails
 * patch 17: crypto: ccp: Handle non-volatile INIT_EX data when SNP is enabled
   - drop usage of vmap() to access INIT_EX non-volatile data buffer, no longer
     needed now that rmpupdate() splits directmap rather than removes mappings
 * patch 15: x86/sev: Introduce snp leaked pages list
   - add Suggested-by: Vlastimil Babka <vbabka@suse.cz>
   - avoid the need to allocate memory when leaking unreclaimable pages
     (Vlastimil, Ashish)
   - use pr_warn() instead of pr_debug() when leaking (Sean)
 * patch 14: crypto: ccp: Provide API to issue SEV and SNP commands
   - s/SEV/SEV device/ in kernel-doc for sev_do_cmd() (Boris) 
 * patch 13: crypto: ccp: Add support to initialize the AMD-SP for SEV-SNP
   - account for non-page-aligned HV-Fixed ranges when calling SNP_INIT (Ashish)
   - various comment/commit fixups (Boris)
 * patch 12: crypto: ccp: Define the SEV-SNP commands
   - fix alignment of SEV_CMD_SNP_DOWNLOAD_FIRMWARE_EX enum
   - add "Incoming Migration Image" in all places that mention of IMI for
     purposes of documentation (Boris)
   - fix indentation to align each argument description line to same column
     in accordance with Documentation/doc-guide/kernel-doc.rst
   - rename sev_data_snp_addr.paddr_gctx to more appropriate
     sev_data_snp_addr.address, fix up affected patches
   - len/length in kernel-doc descriptions
 * patch 11: x86/sev: Invalidate pages from the direct map when adding them to the RMP table
   - replace old patch/handling with an implementation based on set_memory_4k()
     that splits directmap as-needed rather than adding/removing mappings in
     response to shared/private conversions.
   - lookup/confirm the mappings in advance of splitting, and avoid unecessary
     splits for 2M private ranges to reduce unecessary contention / TLB flushing
     (Dave, Boris, Tom, Mike, Vlastimil)
 * patch 10: x86/sev: Add helper functions for RMPUPDATE and PSMASH instruction
   - add additional comments clarifying RMPUPDATE retry logic (Boris)
 * patch 07: x86/fault: Add helper for dumping RMP entries
   - fix dump logic for 2MB+ pages (Tom)
   - dump full 2MB range if particular 4K RMP entry is not populated (Boris)
   - drop EXPORT_SYMBOL_GPL() until actually needed by a module (Boris)
 * patch 04: x86/sev: Add the host SEV-SNP initialization support
   - macro alignment fixups (Boris)
   - commit message cleanups (Boris)
   - work in Zen5 patch (Boris)
   - squash __snp_init_rmptable in helper back in (Boris)
 * patch 03: iommu/amd: Don't rely on external callers to enable IOMMU SNP support
   - add Joerg's acked-by
   - error message cleanups (Boris)

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

Brijesh Singh (14):
      x86/cpufeatures: Add SEV-SNP CPU feature
      x86/sev: Add the host SEV-SNP initialization support
      x86/sev: Add RMP entry lookup helpers
      x86/fault: Add helper for dumping RMP entries
      x86/traps: Define RMP violation #PF error code
      x86/sev: Add helper functions for RMPUPDATE and PSMASH instruction
      crypto: ccp: Define the SEV-SNP commands
      crypto: ccp: Add support to initialize the AMD-SP for SEV-SNP
      crypto: ccp: Provide API to issue SEV and SNP commands
      crypto: ccp: Handle the legacy TMR allocation when SNP is enabled
      crypto: ccp: Handle legacy SEV commands when SNP is enabled
      KVM: SEV: Make AVIC backing, VMSA and VMCB memory allocation SNP safe
      crypto: ccp: Add the SNP_PLATFORM_STATUS command
      crypto: ccp: Add the SNP_SET_CONFIG command

Kim Phillips (1):
      x86/speculation: Do not enable Automatic IBRS if SEV SNP is enabled

Michael Roth (3):
      x86/fault: Dump RMP table information when RMP page faults occur
      x86/sev: Adjust directmap to avoid inadvertant RMP faults
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
 arch/x86/include/asm/sev.h               |   38 +
 arch/x86/include/asm/trap_pf.h           |   20 +-
 arch/x86/kernel/cpu/amd.c                |   21 +-
 arch/x86/kernel/cpu/common.c             |    7 +-
 arch/x86/kernel/cpu/mtrr/generic.c       |    3 +
 arch/x86/kernel/crash.c                  |    3 +
 arch/x86/kernel/sev.c                    |   10 +
 arch/x86/kvm/lapic.c                     |    5 +-
 arch/x86/kvm/svm/nested.c                |    2 +-
 arch/x86/kvm/svm/sev.c                   |   37 +-
 arch/x86/kvm/svm/svm.c                   |   17 +-
 arch/x86/kvm/svm/svm.h                   |    1 +
 arch/x86/mm/fault.c                      |    5 +
 arch/x86/virt/svm/Makefile               |    3 +
 arch/x86/virt/svm/sev.c                  |  547 +++++++++++++++
 drivers/crypto/ccp/sev-dev.c             | 1122 ++++++++++++++++++++++++++++--
 drivers/crypto/ccp/sev-dev.h             |    5 +
 drivers/iommu/amd/amd_iommu.h            |    1 -
 drivers/iommu/amd/init.c                 |  120 +++-
 include/linux/amd-iommu.h                |    6 +-
 include/linux/psp-sev.h                  |  319 ++++++++-
 include/uapi/linux/psp-sev.h             |   59 ++
 tools/arch/x86/include/asm/cpufeatures.h |    1 +
 31 files changed, 2303 insertions(+), 125 deletions(-)
 create mode 100644 arch/x86/virt/svm/Makefile
 create mode 100644 arch/x86/virt/svm/sev.c




