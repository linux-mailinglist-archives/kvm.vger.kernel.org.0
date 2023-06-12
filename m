Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4395372B665
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 06:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233499AbjFLE2c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 00:28:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234062AbjFLE16 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 00:27:58 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2047.outbound.protection.outlook.com [40.107.94.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B893D10C0;
        Sun, 11 Jun 2023 21:27:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S/4jdbl1Tc4/Z77E8zaDhYIXU/W+seD0HfP58MlQpQx6j9FJanMcyvuWn+g/7NxaM04dk0EyJIqmwxqXLGhUARslFX6Ozz3B6jiG5tCVLpOmGg3dOEzAX4dee2ibIqWh0ZFD2G6L1193qkJODlf/sBaPoIhHvCOLpNd6lC3GOvtUr7QV7pV8jAffEvZpm6yRXxDRYgEtc5SzXl86nZJl2f/mPJw7ovAfqHEe7YTWV20R7A8JL/ruqmKOK5IeaZXaoJ72V7zOCObNx/gnwLshpBAs4YPwewzrwpv02CNCUiadfw1twLHqUmrR0NPrZyQfQnITODXAtJSMBNtr7eBuqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6Turi9MP/TCNTilEuBce43cMNJGCNvxMUAbI2SLYVoE=;
 b=RGa/RKmWrs44V83OO+UrluBt7rwfU0lj/HxysVAjKA8QI723lk3pTikSej95F3t92Ik2rwbP4OPpl7NsMbs4wwOfViqmV47xigqG+STf2UrMBfDzxv6CbwHpOQZxJT3DPBJAITpk0iVQQeSzEY4AkGJiZIqxdiZQ/CSn5PJARK4o4qZlVAuSyw2ri9UAqJUyFRE1g6E378nN7Z12y3bjkiczUk69JoRuq7TLiSv2pUMWwzPuaLj1j9jwULbyf0h24xwMNPcgHDaMomiTuf8hC71olijdxpoo61/ycuaibhbfJ0xqBjcD6I3bZSnZrmXWuv/inefInGnybu5EsXPTDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Turi9MP/TCNTilEuBce43cMNJGCNvxMUAbI2SLYVoE=;
 b=yA2QZ35T8Ht5HTgBNG3+KvZZSRIS04oHSSyfziE1yLP3y1FXzQpFyDXp/rdZQnt7f9DLkHlkrqPf2wc7QMkzDc3/wHTAyThXXswtgdbyfQ6pdWVlwZt8TeVyg31IbN/aWCsW9PPprqmyt49CAhCy/NGxLBHOWSKIyZiE/IPSliU=
Received: from CY5PR19CA0110.namprd19.prod.outlook.com (2603:10b6:930:64::11)
 by DS0PR12MB7607.namprd12.prod.outlook.com (2603:10b6:8:13f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.38; Mon, 12 Jun
 2023 04:27:48 +0000
Received: from CY4PEPF0000E9D1.namprd03.prod.outlook.com
 (2603:10b6:930:64:cafe::e5) by CY5PR19CA0110.outlook.office365.com
 (2603:10b6:930:64::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.34 via Frontend
 Transport; Mon, 12 Jun 2023 04:27:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000E9D1.mail.protection.outlook.com (10.167.241.144) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6500.22 via Frontend Transport; Mon, 12 Jun 2023 04:27:48 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Sun, 11 Jun
 2023 23:27:47 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>, <jmattson@google.com>,
        <luto@kernel.org>, <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>
Subject: [PATCH RFC v9 00/51] Add AMD Secure Nested Paging (SEV-SNP) Hypervisor Support
Date:   Sun, 11 Jun 2023 23:25:08 -0500
Message-ID: <20230612042559.375660-1-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D1:EE_|DS0PR12MB7607:EE_
X-MS-Office365-Filtering-Correlation-Id: c4f6a63b-3c2f-4add-2dfe-08db6afd60c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1fyGuXqUKNZN1Bg2r72B1GKPkNcHHAlJJaX4015oV7iKe82E0Kqf22Vct0ILZSqkVbcsy/rfAUiNtWMfllEgk1cms9c/6muCm6dVcoFgjv+1+LYeP91NaTFAg9pTvD488PA9tDXkcSkAwPuf3GCrBStJhFHUBZOCCVbsthYGQ4idJKhmSqa+XZOaQDKtzmwU8HmtChDpeEz7n6ubCQuDZiiQ6H42X9ZeiFUrysKR6QuA+CZPJvFACKpJXHpKT+HaPIAV2HB4lCx4d0BWTmvrZhvvVdt0B1mezPu8qr/tGpKAtGlBmdEKpywyYox6778COREvlcrVV7ifcZGnElbFByun3M2en82D1quK+6TWAa0XQf/mjDxoQQHqajVyljgoiZhE2GdpT1cDuqZUJkuKERCfB3+VeA31ZYT/W3ZdxC4iwX5ig4SHrZod6D4CooQ7gTLExHv+GY6TB3cqzO/Uk/EHpV2fmPoAcsIoHiLGWkryPwu3b1xyYClmcDAdh3o9fc2B7LgC/a5sgZDJtcPkc0NWCSa4o2BHzt4TVMeW8zbTbiOq7dAtN0vDGzcP7bW5V6WJHycP0iS8DVfh3h12FPtiYKMXJh98ilf+e01QbIYR3cq6PSnPyk18vhdGdmk/3PHSbSPzu3l+v1iE1FuR/vNd3MOnhQyaCzwvvNIglIZST0ONR5C5AM5yCClOYw4/mHVusWTQNntsjtNghE8rGiw9NO5oE6OBYs8z0kvHSlPIgBASmb+3AFARpscEWfuaABdgBYzdH8ZO2QFFOgbciNxxGq3DTRDlS5mgYfneQos=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(136003)(39860400002)(396003)(451199021)(46966006)(40470700004)(36840700001)(26005)(1076003)(16526019)(336012)(2616005)(426003)(966005)(36860700001)(47076005)(83380400001)(186003)(82310400005)(6666004)(70206006)(356005)(30864003)(70586007)(2906002)(82740400003)(478600001)(81166007)(40460700003)(44832011)(7406005)(54906003)(7416002)(5660300002)(8936002)(36756003)(8676002)(41300700001)(316002)(86362001)(40480700001)(6916009)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 04:27:48.4193
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c4f6a63b-3c2f-4add-2dfe-08db6afd60c1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000E9D1.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7607
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patchset is also available at:

  https://github.com/amdese/linux/commits/snp-host-v9-rfc

and is based on top of the following tree:

  https://github.com/mdroth/linux/commits/kvm_gmem_solo_fixes

which in turn is based on Sean Christopherson's UPM base support tree,
with a couple fixes/workarounds needed for SEV/SNP support. [1]

== OVERVIEW ==

This patchset implements SEV-SNP hypervisor support for linux.

This version is being posted as an RFC due to fairly extensive changes
relating to transitioning the SEV-SNP implementation to using
guest_memfd (gmem, aka Unmapped Private Memory) to manage private guest
pages instead of the legacy SEV memory registration ioctls.

For this purpose we've added a number of hooks on top of gmem to plumb
in necessary RMP table updates corresponding when mapping private
memory into a guest's nested page table, and then restoring it to
shared/hypervisor-owned state we free'ing gmem-allocated memory back to
the host. Our hope is that some of these hooks can be re-used for other
platforms as well, but have tried to make them as minimal as possible if
they prove to be SNP-specific. For quicker review of this aspect, they
are at the beginning of the series, directly on top of the gmem patchset.

Outside of UPM-related items, we've also included fairly extensive changes
based on review feedback from v8 and would appreciate any feedback on
those aspects as well.


== LAYOUT ==

PATCH 01-05: Pre-patches that add generic gmem and KVM MMU hooks to handle
             plumbing gmem memory into CoCo guests, and make arch/x86/coco
             re-usability for common SEV host code instead of only guest
             code..
PATCH 06-22: Host SNP initialization code and CCP driver prep for handling
             SNP cmds
PATCH 13-22: general SNP detection/enablement for host and CCP driver
PATCH 23-46: core KVM support for running SEV-SNP guests
PATCH 47-51: misc handling for IOMMU support, guest request handling, and
             debug infrastructure


== TESTING (note updated QEMU command-lines) ==

For testing this via QEMU, use the following tree:

  https://github.com/amdese/qemu/commits/snp-wip-gmem

SEV-SNP with gmem/UPM enabled:

  # set discard=none to disable discarding memory post-conversion, faster
  # boot times, but increased memory usage
  qemu-system-x86_64 -cpu EPYC-Milan-v2 \
    -object memory-backend-memfd-private,id=ram1,size=1G,share=true \
    -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,discard=both \
    -machine q35,confidential-guest-support=sev0,memory-backend=ram1,kvm-type=protected \
    ...

KVM selftests for UPM:

  cd $kernel_src_dir
  make -C tools/testing/selftests TARGETS="kvm" EXTRA_CFLAGS="-DDEBUG -I<path to kernel headers>"
  sudo tools/testing/selftests/kvm/x86_64/private_mem_conversions_test


== BACKGROUND (SEV-SNP) ==

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

When pages are marked as guest-owned in the RMP table, they are assigned
to a specific guest/ASID, as well as a specific GFN with in the guest. Any
attempts to map it in the RMP table to a different guest/ASID, or a
different GFN within a guest/ASID, will result in an RMP nested page fault.

Prior to accessing a guest-owned page, the guest must validate it with a
special PVALIDATE instruction which will set a special bit in the RMP table
for the guest. This is the only way to set the validated bit outisde of the
initial pre-encrypted guest payload/image; any attempts outside the guest to
modify the RMP entry from that point forward will result in the validated
bit being cleared, at which point the guest will trigger an exception if it
attempts to access that page so it can be made aware of possible tampering.

One exception to this is the initial guest payload, which is pre-validated
by the firmware prior to launching. The guest can use Guest Message requests 
to fetch an attestation report which will include the measurement of the
initial image so that the guest can verify it was booted with the expected
image/environment.

After boot, guests can use Page State Change requests to switch pages
between shared/hypervisor-owned and private/guest-owned to share data for
things like DMA, virtio buffers, and other GHCB requests.

In this implementation SEV-SNP, private guest memory is managed by a new 
kernel framework called guest_memfd (gmem). With gmem, a new
KVM_SET_MEMORY_ATTRIBUTES KVM ioctl has been added to tell the KVM
MMU whether a particular GFN should be backed by shared (normal) memory or
private (gmem-allocated) memory. To tie into this, Page State Change
requests are forward to userspace via KVM_EXIT_VMGEXIT exits, which will
then issue the corresponding KVM_SET_MEMORY_ATTRIBUTES call to set the
private/shared state in the KVM MMU.

The gmem / KVM MMU hooks added in this series will then update the RMP table
entries for the backing PFNs to set them to guest-owned/private when mapping
private pages into the guest via KVM MMU, or use the normal KVM MMU handling
in the case of shared pages where the corresponding RMP table entries are
left in the default shared/hypervisor-owned state.

== TODO / KNOWN ISSUES ==

 * Add a per-arch CONFIG option for enabling platform-specific handling
   when invalidating gmem pages and free'ing the back to host, as opposed
   to the current approach which defaults to issuing invalidations to a
   weak-referenced stub implementation for non-x86 builds. Hoping for more
   feedback on general implementation first.
 * This should incorporate all review feedback from v8, but if anything
   slipped through the cracks please let me know.

[1] https://lore.kernel.org/lkml/20230512002124.3sap3kzxpegwj3n2@amd.com/

Changes since v8:

 * Rework gmem/UPM hooks based on Sean's latest gmem/UPM tree
 * Move SEV lazy-pinning support out to a separate series which uses this
   series as a prereq instead of the other way around.
 * Re-organize extended guest request patches into 3 patches encompassing
   SEV FD ioctls for host-wide certs, KVM ioctls for per-instance certs,
   and the guest request handling that consumes them. Also move them to
   the top of the series to better separate them for the core SNP patches
   (Alexey, Zhi, Ashish, Dov, Dionna, others)
 * Various other changes/fixups for extended guests request handling (Dov,
   Alexey, Dionna)
 * Use helper to calculate max RMP entry size and improve readability (Dave)
 * Use architecture-independent GPA value for initial VMSA pages
 * Ensure SEV_CMD_SNP_GUEST_REQUEST failures are indicated to guest (Alex)
 * Allocate per-instance certs on-demand (Alex)
 * comment fixup for RMP fault handling (Zhi)
 * commit msg rewording for MSR-based PSCs (Zhi)
 * update SNP command/struct definitions based on 1.54 ABI (Saban)
 * use sev_deactivate_lock around SEV_CMD_SNP_DECOMMISSION (Saban)
 * Various comment/commit fixups (Zhi, Alex, Kim, Vlastimil, Dave, 
 * kexec fixes for newer SNP firmwares (Ashish)
 * Various other fixups and re-ordering of patches.

Changes since v7:

 * Rebase to Sean's updated UPM base support tree
 * Drop KVM_CAP_UNMAPPED_MEMORY and .private_mem_enabled x86 op in favor
   of kvm_arch_has_private_mem() and vm_type KVM_VM_CREATE arg
 * Drop GHCB map/unmap refactoring and post map/unmap hooks as they are no
   longer needed with UPM
 * Move .fault_is_private implementation to SNP patch range, no longer
   needed for SEV.
 * Don't call attribute update / invalidation hooks under kvm->mmu_lock
   (Tom, Jarkko)
 * Revert switch to using set_memory_p()/set_memory_np() in rmpupdate() due
   to it causing performance regression
 * Commit fixups for 'fault_is_private'/'update_mem_attr' hooks, have
   'fault_is_private' return bool (Boris)
 * Split kvm_vm_set_region_attr() into separate patch. (Jarkko)
 * Copy corrected CPUID page to userspace when firmware rejects it (Tom,
   Jarkko)
 * Fix sev_dump_rmpentry() error-handling (Alper)
 * Use adjusted cmd_buf pointer rather than sev->cmd_buf directly (Alper)
 * Correct typo in SNP_GET_EXT_CONFIG documentation (Dov)
 * Update struct kvm_sev_snp_launch_finish definition in
   amd-memory-encryption.rst (Tom)
 * Fix snp_launch_update_vmsa replacing created_vcpus with online_vcpus
 * Fix SNP_DBG_DECRYPT to not include len parameter.
 * Fix SNP_LAUNCH_FINISH to copy host-data from userspace


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

 Documentation/virt/coco/sev-guest.rst              |   54 +
 Documentation/virt/kvm/api.rst                     |   34 +
 .../virt/kvm/x86/amd-memory-encryption.rst         |  147 ++
 arch/x86/Kbuild                                    |    2 +-
 arch/x86/coco/Makefile                             |    3 +-
 arch/x86/coco/sev/Makefile                         |    3 +
 arch/x86/coco/sev/host.c                           |  524 ++++++
 arch/x86/include/asm/cpufeatures.h                 |    1 +
 arch/x86/include/asm/disabled-features.h           |    8 +-
 arch/x86/include/asm/kvm-x86-ops.h                 |    3 +
 arch/x86/include/asm/kvm_host.h                    |   23 +
 arch/x86/include/asm/msr-index.h                   |   11 +-
 arch/x86/include/asm/sev-common.h                  |   30 +
 arch/x86/include/asm/sev-host.h                    |   37 +
 arch/x86/include/asm/sev.h                         |    5 +-
 arch/x86/include/asm/svm.h                         |    6 +
 arch/x86/include/asm/trap_pf.h                     |   18 +-
 arch/x86/kernel/cpu/amd.c                          |   24 +-
 arch/x86/kernel/cpu/bugs.c                         |    7 +-
 arch/x86/kvm/Kconfig                               |    1 +
 arch/x86/kvm/lapic.c                               |    5 +-
 arch/x86/kvm/mmu.h                                 |    2 -
 arch/x86/kvm/mmu/mmu.c                             |   15 +-
 arch/x86/kvm/mmu/mmu_internal.h                    |   39 +-
 arch/x86/kvm/svm/nested.c                          |    2 +-
 arch/x86/kvm/svm/sev.c                             | 1802 +++++++++++++++++---
 arch/x86/kvm/svm/svm.c                             |   53 +-
 arch/x86/kvm/svm/svm.h                             |   38 +-
 arch/x86/kvm/x86.c                                 |   17 +
 arch/x86/mm/fault.c                                |   21 +
 drivers/crypto/ccp/sev-dev.c                       | 1064 +++++++++++-
 drivers/crypto/ccp/sev-dev.h                       |   16 +
 drivers/iommu/amd/init.c                           |   57 +-
 include/linux/amd-iommu.h                          |    3 +-
 include/linux/kvm_host.h                           |   10 +
 include/linux/psp-sev.h                            |  304 +++-
 include/uapi/linux/kvm.h                           |   74 +
 include/uapi/linux/psp-sev.h                       |   71 +
 tools/arch/x86/include/asm/cpufeatures.h           |    1 +
 virt/kvm/guest_mem.c                               |   48 +-
 virt/kvm/kvm_main.c                                |   75 +-
 41 files changed, 4383 insertions(+), 275 deletions(-)

