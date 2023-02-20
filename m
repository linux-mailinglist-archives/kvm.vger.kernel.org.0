Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5008369D2D9
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 19:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232475AbjBTSkQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 13:40:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232410AbjBTSkO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 13:40:14 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2068.outbound.protection.outlook.com [40.107.243.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CAA41E1C4;
        Mon, 20 Feb 2023 10:40:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D8Ew/Gdbx6zaQk3x8xUD8jrLaGT7iZpy8qkDr+3dnB1SaAqmijhX5j4Br+sYy/YxCYleU3OyNkTqquNcLaUiFivTPz/dWKtt6in3Wgq5n+cQ8tnnZYT+3cDyA5lEELqAgnLx3sboVP/SRtYY3ThC0EAz3y18WP8ll5haA+Y2ibMvCpSupj+4B1S9XgB+Bm5xdcY+veiETmbUHoDRNcbMj0D4dnwxtogBvYOf1/N9Xw/dJ1aBGXIJpok9gJVT37eilkRUmzuNqSKN/3DKt+X9dLr3oCpFRrVkycLbqYBAyILWRbvf+YslR8M0293tlZ+QSh/XLm+pFUcN4wZcofLb7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RGQJWxkIdVdKzSADsbIViZYVQZI3j5u+ldA+XGzEzOM=;
 b=fMlHl9CnZdOKswqg7cym9yNElXlXwAGW4XPKWWuqveoUbWZMclnrISAtzD8Dgq8rdogG1faanbxfRsc4ZwIqL4gW1nmwxwOg1Fdri5089EbRE12AXRMy+8fJDFmcQvO6ksebRCVIVcbbDRxVj4VusuRhpVPYGZmw/odgGCn1eeYsKbrUuvmkSSkF0cpMAYULOpjkmGhAXxVkrqpHNGdvbfmj3tpVEveHgE6NCerTk/2zggl8vgEgYnM1BF8aZDyw2Wg6sqB940g9vsyqn8UzEdN7TGwvvzZTUWIdGQQWcR93zrGwNvu1a0vXCrVrafK7D6F/EBLJklSUwGxEqpEsqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RGQJWxkIdVdKzSADsbIViZYVQZI3j5u+ldA+XGzEzOM=;
 b=avYgH7wRRyV32CDrnTTiMRWDriEK/mH1qtFmesWEBmDXPEy9Hcw/7MeeGaJIOvWxjME6M8TMcbMGfhyg2MeruEQbJBUeB4SwfhKi9J2ORlV/x03X7CBPtHSfqF69Gi/e+EGR+Ax5hBa7isQzgUD+OPFTlQb5zfkdWsDszpUC1B0=
Received: from DM6PR02CA0123.namprd02.prod.outlook.com (2603:10b6:5:1b4::25)
 by SA1PR12MB7198.namprd12.prod.outlook.com (2603:10b6:806:2bf::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19; Mon, 20 Feb
 2023 18:40:01 +0000
Received: from DM6NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1b4:cafe::7c) by DM6PR02CA0123.outlook.office365.com
 (2603:10b6:5:1b4::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20 via Frontend
 Transport; Mon, 20 Feb 2023 18:40:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT010.mail.protection.outlook.com (10.13.172.222) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6111.19 via Frontend Transport; Mon, 20 Feb 2023 18:40:01 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Feb
 2023 12:40:00 -0600
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
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>
Subject: [PATCH RFC v8 00/56] Add AMD Secure Nested Paging (SEV-SNP) Hypervisor Support
Date:   Mon, 20 Feb 2023 12:37:51 -0600
Message-ID: <20230220183847.59159-1-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT010:EE_|SA1PR12MB7198:EE_
X-MS-Office365-Filtering-Correlation-Id: 28602cc8-5ee7-4735-9c77-08db1371e027
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +EPD9Hd7JK2sur04QqeRzVTKfCAfGouHob6d5nAFU67mBo3VpC2MYWEYZ+Hc2Z7hlndclK4FhQxXkPtZC3IjmIPkKPNhfjFxIvDnbaBGHCK97BrkkYSRmsBj1LNUifIbyU75Ydn7XIG5nyNc+f83WaGM+wXXIn3CHYhAIJBqu8h+qcan/4v8DqHl1aET/336uLgKhgZr49vAXyOpckvgjyIKWXMzPyPYtdpi1xbYwKk2xyOnumqoI26XBy0WzpFUKa5nsUNIyt/VwrnCEK8uh6PoUf7vvw8Yz9CajzFhe0XSB0zPrB2sP2kV7Z5QtFHy6Vo/I3rHIGK1tiMap+mUC7lAqTFQsxAd1/QfqhnHVbgb+7VqleGh2dCg0At+gyAhddN0c1JvoycRcIb7jT5mMZNqMvL1NnifNHXCnCewgmAyaQQKo6QufCzQgmB/aaRDWUUAnnBvzgY8wx5P5IPe1h4wiSMISVljUz4KJkYSveJmphqgWHTyEhKA+gFCaOdcD3cZu0//nL8XM+7RuNiAvhr22VOxkQCln+PjnyOgFdGgbKC5rPXX5+BND5Uei5tXY/OhFIcVZDcBexNRR9+Z45YArxPhaOBmGBIOb7VScKgxFH5fxy4nZXoYppUQzW++hBMmxHIYab4OFdNlDkzeLS6TPczIMG1ayIihdOMjZMCmvET+UkSCJWC9Bc7+/QiCFvA9Ko8knud12IrRK9tEG96vy5dpyN982SPwQMD+Y9gwNbewMgZGbMau+Ncd40I9OiJuEMfXICqOTGXgoSAu3w==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(346002)(136003)(376002)(451199018)(40470700004)(46966006)(36840700001)(70586007)(70206006)(6916009)(81166007)(8676002)(4326008)(82740400003)(82310400005)(36860700001)(316002)(426003)(47076005)(83380400001)(36756003)(356005)(41300700001)(8936002)(54906003)(26005)(186003)(16526019)(5660300002)(86362001)(2616005)(7406005)(7416002)(336012)(30864003)(44832011)(6666004)(966005)(478600001)(2906002)(40460700003)(1076003)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 18:40:01.5044
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 28602cc8-5ee7-4735-9c77-08db1371e027
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7198
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patchset is also available at:

  https://github.com/amdese/linux/commits/upmv10-host-snp-v8-rfc

and is based on top of the following tree:

  https://github.com/mdroth/linux/commits/upm_base_support_fixes

which in turn is based on Sean Christopherson's UPM base support tree,
with some fixes/workarounds needed for SEV/SNP support.[1]

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

Outside of UPM-related items, we've also included fairly extensive changes
based on review feedback from v6/v7 and would appreciate any feedback on
those aspects as well.

== LAYOUT ==

PATCH 01-03: pre-patches that add the UPM hooks and KVM capability needed
             to switch between UPM and legacy SEV memory registration.
PATCH 04-09: implement SEV lazy-pinning using UPM to manage private memory
PATCH 10-28: general SNP detection/enablement for host and CCP driver
PATCH 29-56: SNP hypervisor support

== TESTING (note updated QEMU command-lines) ==

For testing this via QEMU, use the following tree:

  https://github.com/amdese/qemu/commits/upmv10b-snpv3-wip

SEV-SNP with UPM:

  qemu-system-x86_64 -cpu EPYC-Milan-v2 \
    -object memory-backend-memfd-private,id=ram1,size=1G,share=true \
    -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1 \
    -machine q35,confidential-guest-support=sev0,memory-backend=ram1,kvm-type=protected \
    ...

SEV with UPM (requires patched OVMF[2]):

  qemu-system-x86_64 -cpu EPYC-Milan-v2 \
    -object memory-backend-memfd-private,id=ram1,size=1G,share=true \
    -object sev-guest,id=sev0,cbitpos=51,reduced-phys-bits=1 \
    -machine q35,confidential-guest-support=sev0,memory-backend=ram1,kvm-type=protected \
    ...

KVM selftests for UPM:

  cd $kernel_src_dir
  make -C tools/testing/selftests TARGETS="kvm" EXTRA_CFLAGS="-DDEBUG"
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

The RMP check is enforced as soon as SEV-SNP is enabled. Not every memory
access requires an RMP check. In particular, the read accesses from the
hypervisor do not require RMP checks because the data confidentiality is
already protected via memory encryption. When hardware encounters an RMP
checks failure, it raises a page-fault exception. If RMP check failure
is due to the page-size mismatch, then split the large page to resolve
the fault.

The series does not provide support for the interrupt security and migration
and those feature will be added after the base support.

== BACKGROUND (SEV Lazy-pinning) ==

The current implementation of SEV relies on a KVM_MEM_ENCRYPT_REG_REGION
ioctl to pin all pages in advance, since they may be used as private pages
by the guest. Previous iterations of SNP also relied on this interface. With
UPM however, the initial shared pages are not converted to private, instead
private pages are allocated from a separate restrictedmem backend, which,
by design, will handle the pinning internally upon allocation, which
generally occurs when the guest faults the page in for the first time.
This provides all the necessary characteristic to support lazy-pinning to
improve boot times for SEV guests, and well as a bare minimum implementation
of a UPM-enabled guest that can provide basic infrastructure and testing
flexibility that SNP can then build on, which is why it's included with
this series for now.

It should be noted that SEV guests don't have a mean to issue explicit
page state changes like SNP guests can via GHCB page-state change requests.
They do however need a way to inform the host of shared pages so that
non-restricted memory can be used. This is done via the MAP_GPA_RANGE
KVM hypercall interface which was introduced in guest kernels to inform
the host of shared pages to support live migration. This allows support
for existing guest kernels, however OVMF is still lacking enablement
for MAP_GPA_RANGE hypercalls, which is why a patched version is needed
there.

== TODO / KNOWN ISSUES ==

 * Failures in the rmpupdate() helper have been observed when running many
   concurrent SNP guests while THP is disabled for restricted/private guest
   pages. This has not been observed when running with THP enabled via
   `echo always >/sys/kernel/mm/transparent_hugepages/shmem_enabled`
 * CCP driver init ordering considerations (Jarkko)
 * Reclaim firmware pages in case of SNP command failure (Alper)
 * Return 0 to userspace when generating KVM_EXIT_VMGEXIT (Tom)
 * Rework interfaces for issuing SNP guest requests to firmware (Alexey)
 * Incorporate guest request throttling patches from Dionna
 * Incorporate suggested updates for instant certificate support (Dionna)


[1] https://github.com/mdroth/edk2/commits/upmv8-seves-v1
[2] https://lore.kernel.org/lkml/20230213130102.two7q3kkcf254uof@amd.com/


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

----------------------------------------------------------------
Ashish Kalra (4):
      x86/fault: Return pfn from dump_pagetable() for SEV-specific fault handling.
      crypto: ccp: Introduce snp leaked pages list
      KVM: SVM: Make VMSAVE target area memory allocation SNP safe
      iommu/amd: Add IOMMU_SNP_SHUTDOWN support

Brijesh Singh (32):
      x86/cpufeatures: Add SEV-SNP CPU feature
      x86/sev: Add the host SEV-SNP initialization support
      x86/sev: Add RMP entry lookup helpers
      x86/sev: Add helper functions for RMPUPDATE and PSMASH instruction
      x86/sev: Invalidate pages from the direct map when adding them to the RMP table
      x86/traps: Define RMP violation #PF error code
      x86/fault: Add support to handle the RMP fault for user address
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
      KVM: SVM: Add support to handle GHCB GPA register VMGEXIT
      KVM: SVM: Add support to handle MSR based Page State Change VMGEXIT
      KVM: SVM: Add support to handle Page State Change VMGEXIT
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

Michael Roth (10):
      KVM: x86: Add 'fault_is_private' x86 op
      KVM: x86: Add 'update_mem_attr' x86 op
      KVM: x86: Add platform hooks for private memory invalidations
      KVM: SEV: Require KVM_PROTECTED_VM when AMD_MEM_ENCRYPT is enabled
      KVM: Split out memory attribute xarray updates to helper function
      x86/fault: Add helper for dumping RMP entries
      KVM: SVM: Add KVM_EXIT_VMGEXIT
      KVM: SVM: Add SNP-specific handling for memory attribute updates
      KVM: SVM: Implement .fault_is_private callback for SNP
      KVM: SEV: Handle restricted memory invalidations for SNP

Nikunj A Dadhania (2):
      KVM: SEV: Rename sev_{pin,unpin}_memory
      KVM: SEV: Handle memory backed by restricted memfd

Tom Lendacky (3):
      KVM: SVM: Add support to handle AP reset MSR protocol
      KVM: SVM: Use a VMSA physical address variable for populating VMCB
      KVM: SVM: Support SEV-SNP AP Creation NAE event

Vishal Annapurve (2):
      KVM: Add HVA range operator
      KVM: SEV: Populate private memory fd during LAUNCH_UPDATE_DATA

 Documentation/virt/coco/sev-guest.rst              |   54 +
 .../virt/kvm/x86/amd-memory-encryption.rst         |  147 ++
 arch/x86/Kconfig                                   |    1 +
 arch/x86/include/asm/cpufeatures.h                 |    1 +
 arch/x86/include/asm/disabled-features.h           |    8 +-
 arch/x86/include/asm/kvm-x86-ops.h                 |    5 +
 arch/x86/include/asm/kvm_host.h                    |   19 +
 arch/x86/include/asm/msr-index.h                   |   11 +-
 arch/x86/include/asm/sev-common.h                  |   28 +
 arch/x86/include/asm/sev.h                         |   28 +
 arch/x86/include/asm/svm.h                         |    6 +
 arch/x86/include/asm/trap_pf.h                     |   18 +-
 arch/x86/kernel/cpu/amd.c                          |    5 +-
 arch/x86/kernel/sev.c                              |  472 +++++
 arch/x86/kvm/lapic.c                               |    5 +-
 arch/x86/kvm/mmu.h                                 |    2 -
 arch/x86/kvm/mmu/mmu.c                             |   31 +-
 arch/x86/kvm/mmu/mmu_internal.h                    |   37 +-
 arch/x86/kvm/svm/sev.c                             | 2089 +++++++++++++++++---
 arch/x86/kvm/svm/svm.c                             |   55 +-
 arch/x86/kvm/svm/svm.h                             |   43 +-
 arch/x86/kvm/trace.h                               |   34 +
 arch/x86/kvm/x86.c                                 |   10 +
 arch/x86/mm/fault.c                                |  118 +-
 drivers/crypto/ccp/sev-dev.c                       | 1054 +++++++++-
 drivers/crypto/ccp/sev-dev.h                       |   18 +
 drivers/iommu/amd/init.c                           |   53 +
 include/linux/amd-iommu.h                          |    1 +
 include/linux/kvm_host.h                           |   14 +
 include/linux/mm.h                                 |    3 +-
 include/linux/mm_types.h                           |    3 +
 include/linux/psp-sev.h                            |  351 +++-
 include/uapi/linux/kvm.h                           |   74 +
 include/uapi/linux/psp-sev.h                       |   62 +
 mm/memory.c                                        |   15 +
 mm/restrictedmem.c                                 |   12 +-
 tools/arch/x86/include/asm/cpufeatures.h           |    1 +
 virt/kvm/kvm_main.c                                |  117 +-
 38 files changed, 4714 insertions(+), 291 deletions(-)


