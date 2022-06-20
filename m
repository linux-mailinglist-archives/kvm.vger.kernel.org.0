Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE12552770
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 01:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346745AbiFTW7K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 18:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346381AbiFTW65 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 18:58:57 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2049.outbound.protection.outlook.com [40.107.95.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DD5425E91;
        Mon, 20 Jun 2022 15:56:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BZjOURGjcNxY6x1b8cuoGQ4mbcGGMSzc3wuB7sm4oJEfnsBVNg12FnE15NBELd1ctw7vgjseeUWQuTj0MUMh8b7DtqSSu/6gHJ0x3pl3TDuETDBIwO5kMIkQdoFErP4S/OjL4Gd8KfjhsgX5JCpOLpIollXlJxlsNfzxOnVmvm0f7bXXAj823SXoETKKsnEqciu/xHXQxJ6TLCDIJ6zRssmhYbLnG8vScQYbgi6l5D2h5RAeXxpic9Y5Zlq89EBhpbDrAS6WlSDkXTVdu1HdTRgd544vfRUEutqaJQWYfU83XKm88+UKILG1MKAwFHj6f2uFJ23RU3TZUNeaXk6/WQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GoqyPYAFEPrUGFwl0WHdlFmF70C6y6inBBjVyVgC8O0=;
 b=OpF7xnr0OT7A7V4ecrwjKG5ve8i3Gwtn13ejHZurSne/sXUqp/8Q3E6Iq6qK8MDdT3pXOhX+V6CHVmE9+yAd0rknv/pFyBu+HPds1w4OEa9+EgjE+LLMS+bOhfsLqHDqSGn2U1IbF/bVXd/x0qwyL3Tpv7VLONCvwxDaAjzt6c3ftL69l+gOf2toc+q2CrPzVhStwdM7QHY6ygKJSiNDRyY5kXz2+Zo+CXOG79Rd+pj155qcTEUmbOlbLuCNzL25fSxvTKM6CUaiehCuMp/EIr6L7Dgv18oOrZ9Ob1T/LaesoOGlhc8aBbrLQqLaMJyQceiF8zB3jvS8Cfv9P4ZsNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GoqyPYAFEPrUGFwl0WHdlFmF70C6y6inBBjVyVgC8O0=;
 b=gAHiP+FeJ1Pj5oY23qewdAlU0zxXCB3A1PEnCbjtSC1KxztWZ4phmmjFn7gW7LTjiI5W3UvNXR0ua2IYnEdlqkwjCLx5kRylFiH4rSAjHKp4+W1Jw0v3XUFCc5otf71zCxaCITzicTSatczzViSxvjqMfyQVs+j7uvnrT+c+pAc=
Received: from BN9PR03CA0473.namprd03.prod.outlook.com (2603:10b6:408:139::28)
 by BY5PR12MB4099.namprd12.prod.outlook.com (2603:10b6:a03:20f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14; Mon, 20 Jun
 2022 22:56:33 +0000
Received: from BN8NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:139:cafe::8) by BN9PR03CA0473.outlook.office365.com
 (2603:10b6:408:139::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.18 via Frontend
 Transport; Mon, 20 Jun 2022 22:56:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT013.mail.protection.outlook.com (10.13.176.182) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5353.14 via Frontend Transport; Mon, 20 Jun 2022 22:56:33 +0000
Received: from ashkalraubuntuserver.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 20 Jun 2022 17:56:31 -0500
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
        <linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>
CC:     <tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
        <thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <michael.roth@amd.com>, <vbabka@suse.cz>, <kirill@shutemov.name>,
        <ak@linux.intel.com>, <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>
Subject: [PATCH Part2 v6 00/49] Add AMD Secure Nested Paging (SEV-SNP)
Date:   Mon, 20 Jun 2022 22:56:13 +0000
Message-ID: <cover.1655761627.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 202b9676-1bb9-40b4-dc35-08da53101f36
X-MS-TrafficTypeDiagnostic: BY5PR12MB4099:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB4099D73E5DDA995F1CD49CD28EB09@BY5PR12MB4099.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WRpARwGZGEfnBooT4GMuBkKwCGmXKI00CHu7gTYqhTGUfnGT9F7ldIW5pyzQXML3C7SuviVurz876gU9OVU8rmJeS9G96y4A0Goa1Cgxu6jzhcZ2PnJKk9awznQG54CGl+nLHUhES4VvNi06dtT+jCUiGfa9norvWjpoP+PJnm2ibDjZ2r3IBbxxgmGFTSoSW7C2Z2SxL/Z4oZdi0oeD0VF99coYOBMZEpIdGt1ly2PvntuO8GAeNQVBujqZBGHk8x55gOemuY+0ymlb6xrn0Cyib5iOpuoNb8SNI8ANT8YbAqclV7PaNcqhq4jkXnrHiDJ6zozE+R926PlH/5mFO04sXG/6SO5byrzoQy84YfKW7m9B42FPg1cPL4DyAWSoLNSQ1edd3pIcXw6B7srUXR/fQTY3ofHN1GQiDh5OtFnfAvsYC9dvPPT0ge+TUmdpvST56JcWeB7vZT8/V7VCAOPGXqHb6q4MZmQgVLDiRZKsFygI0SVkfGW6MbVNcs39D0Bq8lMz2PdXTRhe/UMEKmfVBOjR2BLqXkwKsNDsqwH4EeIaAFwSACVaH1B6fEmkLKrCRif7ZeWEqzbkjhgrMD9YH8ZxcvwJYfu3yyDoXMgeRcuQXC2xb45x/gdWWPKn4vGB4/OKruTutht7enWoDx1KG+158VahJ+se/WZgN0mHpGdaluP5r7O+0bBrKZ6RizTxmOrzsYYCu7DEInr+zp2BCD844mhMmTmapRvTtzSYgiygzYazoDT1kJBhSyC5xPUG+chhpJstCpRv4KaaraBlChktyTBmMFVPpvD9ZD1qlnYVNOAAXc7odwHD6inGWRAcIS0x0C1hEofYQA+1EbatGkQZoCUv/+IF00i4ubaF3qjpB0i3R0Ql6OGGH5X+
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(136003)(396003)(39860400002)(46966006)(40470700004)(36840700001)(8936002)(70586007)(8676002)(478600001)(5660300002)(54906003)(110136005)(6666004)(4326008)(36860700001)(316002)(966005)(7406005)(70206006)(40480700001)(7416002)(82310400005)(36756003)(30864003)(86362001)(2906002)(356005)(82740400003)(7696005)(186003)(336012)(16526019)(81166007)(83380400001)(26005)(2616005)(426003)(41300700001)(47076005)(40460700003)(36900700001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 22:56:33.3836
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 202b9676-1bb9-40b4-dc35-08da53101f36
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4099
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

This part of the Secure Encrypted Paging (SEV-SNP) series focuses on the
changes required in a host OS for SEV-SNP support. The series builds upon
SEV-SNP Guest Support now part of mainline.

This series provides the basic building blocks to support booting the SEV-SNP
VMs, it does not cover all the security enhancement introduced by the SEV-SNP
such as interrupt protection.

The CCP driver is enhanced to provide new APIs that use the SEV-SNP
specific commands defined in the SEV-SNP firmware specification. The KVM
driver uses those APIs to create and managed the SEV-SNP guests.

The GHCB specification version 2 introduces new set of NAE's that is
used by the SEV-SNP guest to communicate with the hypervisor. The series
provides support to handle the following new NAE events:
- Register GHCB GPA
- Page State Change Request
- Hypevisor feature
- Guest message request

The RMP check is enforced as soon as SEV-SNP is enabled. Not every memory
access requires an RMP check. In particular, the read accesses from the
hypervisor do not require RMP checks because the data confidentiality is
already protected via memory encryption. When hardware encounters an RMP
checks failure, it raises a page-fault exception. If RMP check failure
is due to the page-size mismatch, then split the large page to resolve
the fault.

The series does not provide support for the interrupt security and migration
and those feature will be added after the base support.

Please note that some areas, such as how private guest pages are 
managed/pinned/protected, are likely to change once Unmapped Private Memory
support is further along in development/design and can be incorporated
into this series. We are posting these patches without UPM support for now
to hopefully get some review on other aspects of the series in the meantime.

Here is a link to latest UPM v6 patches: 
https://lore.kernel.org/linux-mm/20220519153713.819591-1-chao.p.peng@linux.intel.com/

A branch containing these patches is available here:
https://github.com/AMDESE/linux/tree/sev-snp-5.18-rc3-v3

Changes since v5:
 * Rebase to 5.18.0-rc3, these patches are just for review so they
   are based on 5.18.0-rc3 linux-next release as this included the
   SNP guest patches which weren't in mainline then.
 * Using kvm_write_guest() to sync the GHCB scratch buffer can fail
   due to host mapping being 2M, but RMP being 4K. The page fault
   handling in do_user_addr_fault() fails to split the 2M page to handle
   RMP fault due it being called in a non-preemptible context. Instead, 
   use the already kernel mapped ghcb to sync the scratch buffer when
   the scratch buffer is contained within the GHCB.
 * warn and retry failed rmpupdates.
 * Fix for stale per-cpu pointer due to cond_resched due during 
   ghcb mapping.
 * Multiple fixes for SEV-SNP AP Creation.
 * Remove SRCU to synchronize the PSC and gfn mapping replacing it
   with a spinlock. 
 * Remove generic post_{map,unmap}_gfn ops, need to revisit these
   later with respect to UPM support.
 * Fix kvm_mmu_get_tdp_walk() to handle "suspicious RCU usage" 
   warning.
 * Fix sev_snp_init() to do WBINVD/DF_FLUSH command after SNP_INIT
   command has been issued.
 * Fix sev_free_vcpu() to flush the VMSA page after it is transitioned
   back to hypervisor state and restored in the kernel direct map.

Changes since v4:
 * Move the RMP entry definition to x86 specific header file.
 * Move the dump RMP entry function to SEV specific file.
 * Use BIT_ULL while defining the #PF bit fields.
 * Add helper function to check the IOMMU support for SEV-SNP feature.
 * Add helper functions for the page state transition.
 * Map and unmap the pages from the direct map after page is added or
   removed in RMP table.
 * Enforce the minimum SEV-SNP firmware version.
 * Extend the LAUNCH_UPDATE to accept the base_gfn and remove the
   logic to calculate the gfn from the hva.
 * Add a check in LAUNCH_UPDATE to ensure that all the pages are
   shared before calling the PSP.
 * Mark the memory failure when failing to remove the page from the
   RMP table or clearing the immutable bit.
 * Exclude the encrypted hva range from the KSM.
 * Remove the gfn tracking during the kvm_gfn_map() and use SRCU to
   syncronize the PSC and gfn mapping.
 * Allow PSC on the registered hva range only.
 * Add support for the Preferred GPA VMGEXIT.
 * Simplify the PSC handling routines.
 * Use the static_call() for the newly added kvm_x86_ops.
 * Remove the long-lived GHCB map.
 * Move the snp enable module parameter to the end of the file.
 * Remove the kvm_x86_op for the RMP fault handling. Call the
   fault handler directly from the #NPF interception.

Changes since v3:
 * Add support for extended guest message request.
 * Add ioctl to query the SNP Platform status.
 * Add ioctl to get and set the SNP config.
 * Add check to verify that memory reserved for the RMP covers the full system RAM.
 * Start the SNP specific commands from 256 instead of 255.
 * Multiple cleanup and fixes based on the review feedback.

Changes since v2:
 * Add AP creation support.
 * Drop the patch to handle the RMP fault for the kernel address.
 * Add functions to track the write access from the hypervisor.
 * Do not enable the SNP feature when IOMMU is disabled or is in passthrough mode.
 * Dump the RMP entry on RMP violation for the debug.
 * Shorten the GHCB macro names.
 * Start the SNP_INIT command id from 255 to give some gap for the legacy SEV.
 * Sync the header with the latest 0.9 SNP spec.

Changes since v1:
 * Add AP reset MSR protocol VMGEXIT NAE.
 * Add Hypervisor features VMGEXIT NAE.
 * Move the RMP table initialization and RMPUPDATE/PSMASH helper in
   arch/x86/kernel/sev.c.
 * Add support to map/unmap SEV legacy command buffer to firmware state when
   SNP is active.
 * Enhance PSP driver to provide helper to allocate/free memory used for the
   firmware context page.
 * Add support to handle RMP fault for the kernel address.
 * Add support to handle GUEST_REQUEST NAE event for attestation.
 * Rename RMP table lookup helper.
 * Drop typedef from rmpentry struct definition.
 * Drop SNP static key and use cpu_feature_enabled() to check whether SEV-SNP
   is active.
 * Multiple cleanup/fixes to address Boris review feedback.


Ashish Kalra (1):
  KVM: SVM: Sync the GHCB scratch buffer using already mapped ghcb

Brijesh Singh (42):
  x86/cpufeatures: Add SEV-SNP CPU feature
  iommu/amd: Introduce function to check SEV-SNP support
  x86/sev: Add the host SEV-SNP initialization support
  x86/sev: set SYSCFG.MFMD
  x86/sev: Add RMP entry lookup helpers
  x86/sev: Add helper functions for RMPUPDATE and PSMASH instruction
  x86/sev: Invalid pages from direct map when adding it to RMP table
  x86/traps: Define RMP violation #PF error code
  x86/fault: Add support to handle the RMP fault for user address
  x86/fault: Add support to dump RMP entry on fault
  crypto:ccp: Define the SEV-SNP commands
  crypto: ccp: Add support to initialize the AMD-SP for SEV-SNP
  crypto:ccp: Provide APIs to issue SEV-SNP commands
  crypto: ccp: Handle the legacy TMR allocation when SNP is enabled
  crypto: ccp: Handle the legacy SEV command when SNP is enabled
  crypto: ccp: Add the SNP_PLATFORM_STATUS command
  crypto: ccp: Add the SNP_{SET,GET}_EXT_CONFIG command
  crypto: ccp: Provide APIs to query extended attestation report
  KVM: SVM: Provide the Hypervisor Feature support VMGEXIT
  KVM: SVM: Make AVIC backing, VMSA and VMCB memory allocation SNP safe
  KVM: SVM: Add initial SEV-SNP support
  KVM: SVM: Add KVM_SNP_INIT command
  KVM: SVM: Add KVM_SEV_SNP_LAUNCH_START command
  KVM: SVM: Disallow registering memory range from HugeTLB for SNP guest
  KVM: SVM: Add KVM_SEV_SNP_LAUNCH_UPDATE command
  KVM: SVM: Mark the private vma unmerable for SEV-SNP guests
  KVM: SVM: Add KVM_SEV_SNP_LAUNCH_FINISH command
  KVM: X86: Keep the NPT and RMP page level in sync
  KVM: x86: Introduce kvm_mmu_get_tdp_walk() for SEV-SNP use
  KVM: x86: Define RMP page fault error bits for #NPF
  KVM: x86: Update page-fault trace to log full 64-bit error code
  KVM: SVM: Do not use long-lived GHCB map while setting scratch area
  KVM: SVM: Remove the long-lived GHCB host map
  KVM: SVM: Add support to handle GHCB GPA register VMGEXIT
  KVM: SVM: Add support to handle MSR based Page State Change VMGEXIT
  KVM: SVM: Add support to handle Page State Change VMGEXIT
  KVM: SVM: Introduce ops for the post gfn map and unmap
  KVM: x86: Export the kvm_zap_gfn_range() for the SNP use
  KVM: SVM: Add support to handle the RMP nested page fault
  KVM: SVM: Provide support for SNP_GUEST_REQUEST NAE event
  KVM: SVM: Add module parameter to enable the SEV-SNP
  ccp: add support to decrypt the page

Michael Roth (2):
  *fix for stale per-cpu pointer due to cond_resched  during ghcb
    mapping
  *debug: warn and retry failed rmpupdates

Sean Christopherson (1):
  KVM: x86/mmu: Introduce kvm_mmu_map_tdp_page() for use by TDX and SNP

Tom Lendacky (3):
  KVM: SVM: Add support to handle AP reset MSR protocol
  KVM: SVM: Use a VMSA physical address variable for populating VMCB
  KVM: SVM: Support SEV-SNP AP Creation NAE event

 Documentation/virt/coco/sevguest.rst          |   54 +
 .../virt/kvm/x86/amd-memory-encryption.rst    |  102 +
 arch/x86/include/asm/cpufeatures.h            |    1 +
 arch/x86/include/asm/disabled-features.h      |    8 +-
 arch/x86/include/asm/kvm-x86-ops.h            |    2 +
 arch/x86/include/asm/kvm_host.h               |   15 +
 arch/x86/include/asm/msr-index.h              |    9 +
 arch/x86/include/asm/sev-common.h             |   28 +
 arch/x86/include/asm/sev.h                    |   45 +
 arch/x86/include/asm/svm.h                    |    6 +
 arch/x86/include/asm/trap_pf.h                |   18 +-
 arch/x86/kernel/cpu/amd.c                     |    3 +-
 arch/x86/kernel/sev.c                         |  400 ++++
 arch/x86/kvm/lapic.c                          |    5 +-
 arch/x86/kvm/mmu.h                            |    7 +-
 arch/x86/kvm/mmu/mmu.c                        |   90 +
 arch/x86/kvm/svm/sev.c                        | 1703 ++++++++++++++++-
 arch/x86/kvm/svm/svm.c                        |   62 +-
 arch/x86/kvm/svm/svm.h                        |   75 +-
 arch/x86/kvm/trace.h                          |   40 +-
 arch/x86/kvm/x86.c                            |   10 +-
 arch/x86/mm/fault.c                           |   84 +-
 drivers/crypto/ccp/sev-dev.c                  |  908 ++++++++-
 drivers/crypto/ccp/sev-dev.h                  |   17 +
 drivers/iommu/amd/init.c                      |   30 +
 include/linux/iommu.h                         |    9 +
 include/linux/mm.h                            |    3 +-
 include/linux/mm_types.h                      |    3 +
 include/linux/psp-sev.h                       |  346 ++++
 include/linux/sev.h                           |   32 +
 include/uapi/linux/kvm.h                      |   56 +
 include/uapi/linux/psp-sev.h                  |   60 +
 mm/memory.c                                   |   13 +
 tools/arch/x86/include/asm/cpufeatures.h      |    1 +
 34 files changed, 4090 insertions(+), 155 deletions(-)
 create mode 100644 include/linux/sev.h

-- 
2.25.1

