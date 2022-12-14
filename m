Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32EE964D03A
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 20:47:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238983AbiLNTru (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 14:47:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239081AbiLNTrh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 14:47:37 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2067.outbound.protection.outlook.com [40.107.220.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A32F2B26F;
        Wed, 14 Dec 2022 11:47:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GeM8ayiru+JHEFVKtp1d+TZqWc5sEwPK94/CGW07Q4+NDZpCWizTuPGZEFCfD+4H7UyjLXRoO/2TFlkFT/H4BLdT/HcJlM47dYdnCgNadOJtkx8KRKZ+l3E3QZ8+m+DblypawO3RCgM+zD6SpNUYTWDBRJGR4/tLnkfmAosCR5SflomXjow8iEIPkD/gUfVw7D83RW1HTHhAFK3tC5WaIwCZB1tZGM8KhO14KuqGFr37IuLjn2RaYis6y5IUddfs/KrzDQaczdzY/z2K+PO4dGfcx3JftkscorCoB5bCQ71cCjS71dviqOR8JRhy8m6T9SZrQJ9s2wPe7IWjDLn1Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P2/4xPHlqYHWFtXjPw0CW9AI+wXLk6e7BKxgNBjxis4=;
 b=KH6ktVYQrNpEvNrK5ZajNUm/tVCQPJ86Vss9zY2h1ATLRZtCg9hq0aT9dIIEFUy8COilqrVbr/upADScwWqwfwMx7fXT7moAXqg0S68+ZBadlwTmuXuQK2BbbUJt6QE4RNbgJ4NezbbUGY/M9FBngtYzy2YQkfqLFHgSHvfN8bYrn4xCY9ojQ+0icj2FlDvmefXV2pQvekgomMTJQSKs1y+pV8iR1dggsjfnu84C9cT+7/WVzrweAo64b0L2QktccpHU3JYIViwuA+0HOAGxBk2mXLSO8Np2N523B8QeUsHTMNqG6YXAXtJuvVJCrrYbOs7fN+Jz2ZXQ7j1cPz4Teg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P2/4xPHlqYHWFtXjPw0CW9AI+wXLk6e7BKxgNBjxis4=;
 b=qrwDZhrUnfSa8QXvsKhOgI4AV5XHaUg8bP9Y8oksA/m57pF3TJVSG8ReLQfQM41pwyLamtTQb11n64DYQ43dS+88+R/yGGNlF88Gwb7XewbGhroyR5fwTFrhFxZqdXE4rwZzv1GEta6hZUqxpYQeA098DqFfUC0JQO16STejT1M=
Received: from BL1PR13CA0102.namprd13.prod.outlook.com (2603:10b6:208:2b9::17)
 by PH0PR12MB7790.namprd12.prod.outlook.com (2603:10b6:510:289::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11; Wed, 14 Dec
 2022 19:47:26 +0000
Received: from BL02EPF0000EE3D.namprd05.prod.outlook.com
 (2603:10b6:208:2b9:cafe::83) by BL1PR13CA0102.outlook.office365.com
 (2603:10b6:208:2b9::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11 via Frontend
 Transport; Wed, 14 Dec 2022 19:47:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0000EE3D.mail.protection.outlook.com (10.167.241.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5880.8 via Frontend Transport; Wed, 14 Dec 2022 19:47:26 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 14 Dec
 2022 13:47:25 -0600
From:   Michael Roth <michael.roth@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <harald@profian.com>
Subject: [PATCH RFC v7 00/64] Add AMD Secure Nested Paging (SEV-SNP) Hypervisor Support
Date:   Wed, 14 Dec 2022 13:39:52 -0600
Message-ID: <20221214194056.161492-1-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0000EE3D:EE_|PH0PR12MB7790:EE_
X-MS-Office365-Filtering-Correlation-Id: ffab015f-2d0c-4093-4bea-08dade0c06e0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n6Ae9rP8Mj/QSNTbdhUwrQPHMOzgH6imPGzQWJV7gJpBLmqy/UO+jdXDE6WocLL68w5ktl11tZ8NcNW8a6sNjhA5Slkd59/xV/09z89evzuSIZmQc4L58fLuqTwERnqe5fUGE4xbfOhAqWHVnar53KMZO286QFY959eAAMvH0elDV5NFa1QPQtUzJDMLIve3jhu2SgzAO9K6t0IefEqSOmuM2SPASecfyWcu3mBEChIEaTBv+2sxSPlXe+DRWVJHJSNgV2p8MXe6WFETJK2C9cc904k1fbKv7qD8y5h71kKq+qz0lt7rOLdtT05vWDZu4aWTqq/Od5kLh4L1UwmBxM9cRhIAenE2JhnlRXgM+peYchbPhvqD/exYz62tke0Mq57lxhaXbNhx8djIre30WhYG3vW1yNEMwvu/QerJyumWyqO+XQULEctBPgVXzuQ3ycWi7GMZ3wFs3bUSiLPz9rIKNtFN/xxSZRj0PqhAII5pgbfqVN72EeYRfJOeVdWlT3mDLuPfeGHq6ocTMqNL3C/jY186ZuEVUQ70DMfvogcqCBDrfzJzYp4MADV3ctLUFEYqHouZBcxqozdsI3F7DD2UmsPlKcxx3tS7V23/41NuWWVixWX41x5bovSnOE8RYS/wjaFxHhJZyH5WM7OLFO2n4USK8etXJk4uugQbAe0HZDtwuLceoBVPYQn7ELos9dpgAfIBdNOk7s691f2Fvk8f9iGRUh/G0u6P1622PNycYcK7ovajcRRfvBPq7/ti/BSiCAATqGBWt/9ywXKDbHWSyXkhDFtZod6Vpkw+iuqqIZgWzzRKTqGtslITS+IL
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(136003)(39860400002)(376002)(451199015)(46966006)(40470700004)(36840700001)(82740400003)(356005)(81166007)(40480700001)(40460700003)(82310400005)(36756003)(6666004)(86362001)(316002)(966005)(478600001)(2616005)(70206006)(186003)(26005)(54906003)(6916009)(2906002)(36860700001)(336012)(70586007)(47076005)(426003)(1076003)(4326008)(8676002)(16526019)(7406005)(30864003)(7416002)(44832011)(83380400001)(41300700001)(8936002)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 19:47:26.1834
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ffab015f-2d0c-4093-4bea-08dade0c06e0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF0000EE3D.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7790
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patchset is based on top of the following patchset:

  "[PATCH v10 0/9] KVM: mm: fd-based approach for supporting KVM"
  https://lore.kernel.org/lkml/20221202061347.1070246-1-chao.p.peng@linux.intel.com/T/#me1dd3a4c295758b4e4ac8ff600f2db055bc5f987

and is also available at:

  https://github.com/amdese/linux/commits/upmv10-host-snp-v7-rfc

== OVERVIEW ==

This version is being posted as an RFC due to fairly extensive changes
relating to transitioning the SEV-SNP implementation to using
restricted/private memslots (aka Unmapped Private Memory) to manage
private guest pages instead of the legacy SEV memory registration ioctls.

Alongside that work we've also been investigating leveraging UPM to to
implement lazy-pinning support for SEV guests, rather than the legacy
SEV memory registration ioctls which rely on pinning everything in
advance.

For both of these SEV and SEV-SNP use-cases we've needed to add a
number of hooks in the restricted, so we thought it would be useful
for this version at least to include both UPM-based SEV and SNP
implementations so can see if these hooks might be needed for other
archs/platforms and start consolidating around whether/how they should
be defined for general usage. There are still some TODOs in this area,
but we hope this implementation is complete enough to at least outline
the required additions needed for using UPM for these use-cases.

Outside of UPM-related items, we've also included fairly extensive
changes based on review feedback from v6 and would appreciate any
feedback on those aspects as well.

== LAYOUT ==

PATCH 01-06: pre-patches that add the UPM hooks and KVM capability needed
             to switch between UPM and legacy SEV memory registration.
PATCH 07-12: implement SEV lazy-pinning using UPM to manage private memory
PATCH 13-32: general SNP detection/enablement for host and CCP driver
PATCH 33-58: base KVM-specific support for running SNP guests
PATCH 59-64: misc./documentation/IOMMU changes

== TESTING ==

Tested with the following QEMU tree, which is based on Chao Peng's UPM v10 QEMU
tree:
  https://github.com/mdroth/qemu/commits/upmv10-snpv3

SEV-SNP with UPM:

  qemu-system-x86_64 -cpu EPYC-Milan-v2 \
    -object memory-backend-memfd-private,id=ram1,size=1G,share=true \
    -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,upm-mode=on \
    -machine q35,confidential-guest-support=sev0,memory-backend=ram1 \
    ...

SEV with UPM (requires patched OVMF[1]):

  qemu-system-x86_64 -cpu EPYC-Milan-v2 \
    -object memory-backend-memfd-private,id=ram1,size=1G,share=true \
    -object sev-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,upm-mode=on \
    -machine q35,confidential-guest-support=sev0,memory-backend=ram1 \
    ...

[1] https://github.com/mdroth/edk2/commits/upmv8-seves-v1

== BACKGROUND ==

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

Changes since v6:

 * Added support for restrictedmem/UPM, and removed SEV-specific
   implementation of private memory management. As a result of this rework
   the following patches were no longer needed so were dropped:
   - KVM: SVM: Mark the private vma unmergable for SEV-SNP guests
   - KVM: SVM: Disallow registering memory range from HugeTLB for SNP guest
   - KVM: x86/mmu: Introduce kvm_mmu_map_tdp_page() for use by TDX and SNP
   - KVM: x86: Introduce kvm_mmu_get_tdp_walk() for SEV-SNP use
 * Moved RMP table entry structure definition (struct rmpentry)
   to sev.c, to not expose this non-architectural definition to rest
   of the kernel and making the structure private to SNP code.
   Also made RMP table entry accessors to be inline functions and
   removed all accessors which are not called more than once. 
   Added a new function rmptable_entry() to index into the RMP table
   and return RMP table entry.
 * Moved RMPUPDATE, PSMASH helper function declerations to x86 arch
   specific include namespace from linux namespace. Added comments 
   for these helper functions.
 * Introduce set_memory_p() to provide a way to change atributes of a
   memory range to be marked as present and added to the kernel 
   directmap, and invalidating/restoring pages from directmap are
   now done using set_memory_np() and set_memory_p().
 * Added detailed comments around user RMP #PF fault handling and
   simplified computation of the faulting pfn for large-pages.
 * Added support to return pfn from dump_pagetable() to do SEV-specific
   fault handling, this is added a pre-patch. This support is now
   used to dump RMP entry in case of RMP #PF in show_fault_oops().
 * Added a new generic SNP command params structure sev_data_snp_addr,
   which is used for all SNP firmware API commands requiring a 
   single physical address parameter.
 * Added support for new SNP_INIT_EX command with support for HV-Fixed
   page range list. 
 * Added support for new SNP_SHUTDOWN_EX command which allows 
   disabling enforcement of SNP in the IOMMU. Also DF_FLUSH is done
   at SNP shutdown if it indicates DF_FLUSH is required.
 * Make sev_do_cmd() a generic API interface for the hypervisor
   to issue commands to manage an SEV and SNP guest. Also removed
   the API wrappers used by the hypervisor to manage an SEV-SNP guest.
   All these APIs now invoke sev_do_cmd() directly.
 * Introduce snp leaked pages list. If pages are unsafe to be released
   back to the page-allocator as they can't be reclaimed or 
   transitioned back to hypervisor/shared state are now added
   to this internal leaked pages list to prevent fatal page faults
   when accessing these pages. The function snp_leak_pages() is 
   renamed to snp_mark_pages_offline() and is an external function
   available to both CCP driver and the SNP hypervisor code. Removed
   call to memory_failure() when leaking/marking pages offline.
 * Remove snp_set_rmp_state() multiplexor code and add new separate
   helpers such as rmp_mark_pages_firmware() & rmp_mark_pages_shared().
   The callers now issue snp_reclaim_pages() directly when needed as
   done by __snp_free_firmware_pages() and unmap_firmware_writeable().
   All callers of snp_set_rmp_state() modified to call helpers
   rmp_mark_pages_firmware() or rmp_mark_pages_shared() as required.
 * Change snp_reclaim_pages() to take physical address as an argument
   and clear C-bit from this physical address argument internally.
 * Output parameter sev_user_data_ext_snp_config in sev_ioctl_snp_get_config()
   is memset to zero to avoid kernel memory leaking.
 * Prevent race between sev_ioctl_snp_set_config() and 
   snp_guest_ext_guest_request() for sev->snp_certs_data by acquiring
   sev->snp_certs_lock mutex.
 * Zeroed out struct sev_user_data_snp_config in
   sev_ioctl_snp_set_config() to prevent leaking uninitialized
   kernel memory.
 * Optimized snp_safe_alloc_page() by avoiding multiple calls to
   pfn_to_page() and checking for a hugepage using pfn instead of
   expanding to full physical address.
 * Invoke host_rmp_make_shared() with leak parameter set to true
   if VMSA page cannot be transitioned back to shared state.
 * Fix snp_launch_finish() to always sent the ID_AUTH struct to
   the firmware. Use params.auth_key_en indicator to set 
   if the ID_AUTH struct contains an author key or not.
 * Cleanup snp_context_create() and allocate certs_data in this
   function using kzalloc() to prevent giving the guest 
   uninitialized kernel memory.
 * Remove the check for guest supplied buffer greater than the data
   provided by the hypervisor in snp_handle_ext_guest_request().
 * Add check in sev_snp_ap_create() if a malicious guest can
   RMPADJUST a large page into VMSA which will hit the SNP erratum
   where the CPU will incorrectly signal an RMP violation #PF if a
   hugepage collides with the RMP entry of VMSA page, reject the
   AP CREATE request if VMSA address from guest is 2M aligned.
 * Make VMSAVE target area memory allocation SNP safe, implemented
   workaround for an SNP erratum where the CPU will incorrectly signal
   an RMP violation #PF if a hugepage (2mb or 1gb) collides with the
   RMP entry of the VMSAVE target page.
 * Fix handle_split_page_fault() to work with memfd backed pages.
 * Add KVM commands for per-VM instance certificates.
 * Add IOMMU_SNP_SHUTDOWN support, this adds support for Host kexec
   support with SNP.

----------------------------------------------------------------
Ashish Kalra (6):
      x86/mm/pat: Introduce set_memory_p
      x86/fault: Return pfn from dump_pagetable() for SEV-specific fault handling.
      crypto: ccp: Introduce snp leaked pages list
      KVM: SVM: Sync the GHCB scratch buffer using already mapped ghcb
      KVM: SVM: Make VMSAVE target area memory allocation SNP safe
      iommu/amd: Add IOMMU_SNP_SHUTDOWN support

Brijesh Singh (36):
      x86/cpufeatures: Add SEV-SNP CPU feature
      x86/sev: Add the host SEV-SNP initialization support
      x86/sev: Add RMP entry lookup helpers
      x86/sev: Add helper functions for RMPUPDATE and PSMASH instruction
      x86/sev: Invalidate pages from the direct map when adding them to the RMP table
      x86/traps: Define RMP violation #PF error code
      x86/fault: Add support to handle the RMP fault for user address
      x86/fault: Add support to dump RMP entry on fault
      crypto:ccp: Define the SEV-SNP commands
      crypto: ccp: Add support to initialize the AMD-SP for SEV-SNP
      crypto:ccp: Provide API to issue SEV and SNP commands
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
      KVM: SVM: Add KVM_SEV_SNP_LAUNCH_UPDATE command
      KVM: SVM: Add KVM_SEV_SNP_LAUNCH_FINISH command
      KVM: X86: Keep the NPT and RMP page level in sync
      KVM: x86: Define RMP page fault error bits for #NPF
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
      ccp: Add support to decrypt the page

Dionna Glaze (2):
      x86/sev: Add KVM commands for instance certs
      x86/sev: Document KVM_SEV_SNP_{G,S}ET_CERTS

Hugh Dickins (1):
      x86/fault: fix handle_split_page_fault() to work with memfd backed pages

Michael Roth (9):
      KVM: x86: Add KVM_CAP_UNMAPPED_PRIVATE_MEMORY
      KVM: x86: Add 'fault_is_private' x86 op
      KVM: x86: Add 'update_mem_attr' x86 op
      KVM: x86: Add platform hooks for private memory invalidations
      KVM: SEV: Implement .fault_is_private callback
      KVM: SVM: Add KVM_EXIT_VMGEXIT
      KVM: SVM: Add SNP-specific handling for memory attribute updates
      KVM: x86/mmu: Generate KVM_EXIT_MEMORY_FAULT for implicit conversions for SNP
      KVM: SEV: Handle restricted memory invalidations for SNP

Nikunj A Dadhania (5):
      KVM: Fix memslot boundary condition for large page
      KVM: SVM: Advertise private memory support to KVM
      KVM: SEV: Handle KVM_HC_MAP_GPA_RANGE hypercall
      KVM: Move kvm_for_each_memslot_in_hva_range() to be used in SVM
      KVM: SEV: Support private pages in LAUNCH_UPDATE_DATA

Tom Lendacky (3):
      KVM: SVM: Add support to handle AP reset MSR protocol
      KVM: SVM: Use a VMSA physical address variable for populating VMCB
      KVM: SVM: Support SEV-SNP AP Creation NAE event

Vishal Annapurve (2):
      KVM: Add HVA range operator
      KVM: SEV: Populate private memory fd during LAUNCH_UPDATE_DATA

 Documentation/virt/coco/sev-guest.rst              |   54 +
 .../virt/kvm/x86/amd-memory-encryption.rst         |  146 ++
 arch/x86/include/asm/cpufeatures.h                 |    1 +
 arch/x86/include/asm/disabled-features.h           |    8 +-
 arch/x86/include/asm/kvm-x86-ops.h                 |    6 +
 arch/x86/include/asm/kvm_host.h                    |   23 +
 arch/x86/include/asm/msr-index.h                   |   11 +-
 arch/x86/include/asm/set_memory.h                  |    3 +-
 arch/x86/include/asm/sev-common.h                  |   28 +
 arch/x86/include/asm/sev.h                         |   28 +
 arch/x86/include/asm/svm.h                         |    6 +
 arch/x86/include/asm/trap_pf.h                     |   18 +-
 arch/x86/kernel/cpu/amd.c                          |    5 +-
 arch/x86/kernel/sev.c                              |  437 ++++
 arch/x86/kvm/lapic.c                               |    5 +-
 arch/x86/kvm/mmu.h                                 |    2 -
 arch/x86/kvm/mmu/mmu.c                             |   34 +-
 arch/x86/kvm/mmu/mmu_internal.h                    |   40 +-
 arch/x86/kvm/svm/sev.c                             | 2217 +++++++++++++++++---
 arch/x86/kvm/svm/svm.c                             |   84 +-
 arch/x86/kvm/svm/svm.h                             |   75 +-
 arch/x86/kvm/trace.h                               |   34 +
 arch/x86/kvm/x86.c                                 |   36 +
 arch/x86/mm/fault.c                                |  118 +-
 arch/x86/mm/pat/set_memory.c                       |   12 +-
 drivers/crypto/ccp/sev-dev.c                       | 1055 +++++++++-
 drivers/crypto/ccp/sev-dev.h                       |   18 +
 drivers/iommu/amd/init.c                           |   53 +
 include/linux/amd-iommu.h                          |    1 +
 include/linux/kvm_host.h                           |   15 +
 include/linux/mm.h                                 |    3 +-
 include/linux/mm_types.h                           |    3 +
 include/linux/psp-sev.h                            |  352 +++-
 include/uapi/linux/kvm.h                           |   75 +
 include/uapi/linux/psp-sev.h                       |   60 +
 mm/memory.c                                        |   15 +
 mm/restrictedmem.c                                 |   16 +
 tools/arch/x86/include/asm/cpufeatures.h           |    1 +
 virt/kvm/kvm_main.c                                |   87 +-
 39 files changed, 4838 insertions(+), 347 deletions(-)


