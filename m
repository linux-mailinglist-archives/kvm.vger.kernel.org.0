Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6CDE7CA963
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 15:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233582AbjJPNaC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 09:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233499AbjJPNaA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 09:30:00 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2047.outbound.protection.outlook.com [40.107.244.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CEB8F1;
        Mon, 16 Oct 2023 06:29:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IB3+YBnNVvTF+3Z6/fRMpvcW5vCiQpN9ZbAXbDZKLcRch/gCY0aYoyYekPSVzUmqCOxep+yt/lolP8qx2U5qKVzZiYxYYSVCDbxgzw2e5Nuk1/+zG44H2c6sr7DOd++gNFWNtY8FifZ87SQn4qk7RbxZjQqUu+RDbJkcWRFb494X1899g2pqoPgO1U6v8D7EBsF64zyn7TUZ5ekrJKKPs38pzrAsutewznp9TX20v6QI/t0CkY5yduF/IeiTvOU2Z2p6RjzQKbTJRfG23PGWZl266e1wpbPrZMAYPmtnZRLg+j2HxmUCmKaO920JQbL7SJ6weZ7HSgU29lRSl8tjwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5lNL5Kk1tZd9q7EDvKPjb+bquzuBAFnx+gYZsMvoc64=;
 b=iWc+e2a4oXw0xlnAfCeWUpHc222u0hCuTDgNn4PitxJPJWsadvCjXb+BLeMCllxbCTS8yrgpHlt++v44Us+NTTJZQ74J3YmDy9GNMN5U6uwRU2Ku2KQF94NzVxkaFb8933IbCrcBl5j8O4CGirZp09FLysq/fsxzXswpsZow3RyftvjWLmiCpxoOLu2yv0tqM8WZ1v4wC5EqWwCHrPCNd3zuAhUWwTCAYz+FwCY6qoGYY/HSh441TR5KUSZfhU1FR3pFMpSg0FpKAA7v89QrCzFopgkg/m2ol5jfDvY2K/A5mb5apS2w6N3lY98reV5UK07gVxkNgToTurXH0IPNDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5lNL5Kk1tZd9q7EDvKPjb+bquzuBAFnx+gYZsMvoc64=;
 b=aOUbh0AIovZyrEpkeAYkyuZM8rO8452nW6KGbZQ+8MUMKsmYrhX8IakoTIud8gHXa/AhsoTWN/CwTCen9QD16GUV1bkKHEYfCHNjJkes92krb6O0PRzvDl5RYiAN05hUAoSjVxqxsAlr5+z5iGlM+djHHzA8EDpwtyvJYuOO8AI=
Received: from CY5PR15CA0040.namprd15.prod.outlook.com (2603:10b6:930:1b::35)
 by IA1PR12MB8240.namprd12.prod.outlook.com (2603:10b6:208:3f2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.34; Mon, 16 Oct
 2023 13:29:54 +0000
Received: from CY4PEPF0000E9DB.namprd05.prod.outlook.com
 (2603:10b6:930:1b:cafe::cb) by CY5PR15CA0040.outlook.office365.com
 (2603:10b6:930:1b::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35 via Frontend
 Transport; Mon, 16 Oct 2023 13:29:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000E9DB.mail.protection.outlook.com (10.167.241.81) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.22 via Frontend Transport; Mon, 16 Oct 2023 13:29:53 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 16 Oct
 2023 08:29:52 -0500
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
        <alpergun@google.com>, <jarkko@kernel.org>, <ashish.kalra@amd.com>,
        <nikunj.dadhania@amd.com>, <pankaj.gupta@amd.com>,
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>
Subject: [PATCH v10 00/50] Add AMD Secure Nested Paging (SEV-SNP) Hypervisor Support
Date:   Mon, 16 Oct 2023 08:27:29 -0500
Message-ID: <20231016132819.1002933-1-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9DB:EE_|IA1PR12MB8240:EE_
X-MS-Office365-Filtering-Correlation-Id: c5fdc313-c8b9-462e-0f78-08dbce4bfb62
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8q0FtzAK/4xBsFIMekH0ZVldMgViJnY2p6XS4TMAs8vCCK8OVRt3bdBS0jwPFa9Ujxk+l67OdtgWhNQw5iZTq2jgnCCNQAnGJTSdO/xua8S7AATHGeafo7/a1vxRZtcn9qOxDBsBJAwKEX7u/SOZ2aE9mYoIRU1OEfIpqMVJXCVBanx3qPCzqjOpygxDimExGF2BCh6k8pjwkApu3h1JAprvsXB0v6l6CINKs1GNTHzdojxW2+22o2D7Zsm2gJNCHhn1iaeSXXX8Lh0w24jU81YK+8S3yciEJmyPkO0Pabe12wjzy7BlVg1NN0vxxXJugtK3MNTAVqKB2MwE6sR7iIinKmsbU5+KVkL/eMyH6NR6CVqrYXD6PLAnVH7mBpw/TlDZLs7xzjXIgsnJ8bKal7BtIQFrbbT4aCG4ngZuKrlTge2c02hVHb58QUZZ3cRVhZ8dgwhNYc6JxDhkah9JiaUWzXhUVnChUn5DC5MJt5ZOtEuWyaz+05N6soCVuhQmOtXswAUQr9ASIQBg94pT7DoRdH0EoYzw95EgK+jMde9gp0gVFadz6R00Eq01k6rlJ4xsoGixP30Zt4NW59llXK5y9a3Cl41u3LLkcPfWoX7hhvDDpkJoaGiwTeEmAMBkPuYg+XFn7RTEGULkxuHtenrwEh7+IONB0EUTXjgMN89h8eS6VzqfCqmJMwXkCQueHUHdV9gjPCGAvhuwzcRsUx4uoSoWZ7sS07WDhysx5JqYR849vMOBtGfy+a9Wyf1QZN9lV1M/PnbrVV80KeUkF1F5iTPNtV0vCUjyzFW7C3k=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(396003)(346002)(136003)(39860400002)(230922051799003)(451199024)(64100799003)(82310400011)(186009)(1800799009)(36840700001)(40470700004)(46966006)(40460700003)(1076003)(26005)(6666004)(2616005)(30864003)(16526019)(336012)(426003)(54906003)(36860700001)(83380400001)(47076005)(41300700001)(44832011)(7406005)(478600001)(5660300002)(4326008)(2906002)(8676002)(966005)(8936002)(7416002)(70586007)(316002)(6916009)(82740400003)(81166007)(356005)(70206006)(86362001)(40480700001)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 13:29:53.7496
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c5fdc313-c8b9-462e-0f78-08dbce4bfb62
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000E9DB.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8240
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patchset is also available at:

  https://github.com/amdese/linux/commits/snp-host-v10

and is based on top of the following series:

  "[PATCH RFC gmem v1 0/8] KVM: gmem hooks/changes needed for x86 (other archs?)"
  https://lore.kernel.org/kvm/20231016115028.996656-1-michael.roth@amd.com/

which in turn is based on the KVM-x86 staging tree for guest_memfd:

  https://github.com/kvm-x86/linux/commits/guest_memfd


== OVERVIEW ==

This patchset implements SEV-SNP hypervisor support for linux. It
relies on the gmem changes noted above, which are still in an RFC
state, but other than those aspects, the series is being targeted for
inclusion in the KVM x86 tree to support running SEV-SNP guests on AMD
EPYC systems utilizing Zen 3 and newer microarchitectures.

More details on what SEV-SNP is and how it works are available below
under "BACKGROUND".


== PATCH LAYOUT ==

PATCH 01-02: Dependencies for patch #3 that are already upstream but not in
             current guest_memfd staging tree
PATCH 03   : General SEV-ES fix for MSR_IA32_XSS interception that fixes a
             minor bug for SEV-ES, but a more severe one for SNP guests.
             Planning to also submit this separately as an SEV-ES fix.
PATCH 04-19: Host SNP initialization code and CCP driver prep for handling
             SNP cmds
PATCH 20-43: general SNP enablement for KVM and CCP driver
PATCH 47-50: misc handling for IOMMU support, guest request handling, debug
             infrastructure, and kdump-related handling.


== TESTING ==

For testing this via QEMU, use the following tree:

  https://github.com/amdese/qemu/commits/snp-latest-gmem-v12

SEV-SNP with gmem enabled:

  # set discard=none to disable discarding memory post-conversion, faster
  # boot times, but increased memory usage
  qemu-system-x86_64 -cpu EPYC-Milan-v2 \
    -object memory-backend-memfd-private,id=ram1,size=2G,share=true \
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

The gmem / KVM MMU hooks implemented in this series will then update the RMP
table entries for the backing PFNs to set them to guest-owned/private when
mapping private pages into the guest via KVM MMU, or use the normal KVM MMU
handling in the case of shared pages where the corresponding RMP table
entries are left in the default shared/hypervisor-owned state.

Feedback/review is very much appreciated!

-Mike


Changes since v9:

 * Split off gmem changes to separate RFC series, drop RFC tag from this series
 * Use 2M RMPUPDATE instructions whenever possible when invalidating/releasing
   gmem pages
 * Tighten up RMP #NPF handling to better differentiate spurious cases from
   unexpected behavior
 * Simplify/optimize logic for determine when 2M NPT private mappings are
   possible
 * Be more consistent with PFN data types and stub return values (Dave)
 * Reduce potential flooding from frequently-printed pr_debug()'s (Dave)
 * Use existing #PF handling paths to catch illegal userspace-generated RMP
   faults (Dave)
 * Improve host kexec/kdump support (Ashish)
 * Reduce overhead from unecessary WBINVD via MMU notifiers (Ashish)
 * Avoid host crashes during CCP module probe if SNP_INIT* is issued while
   guests are running (Tom L.)
 * Simplify AutoIBRS disablement (Kim, Dave)
 * Avoid unecessary zero'ing in extended guest requests (Alexey)
 * Fix padding in struct sev_user_data_ext_snp_config (Alexey)
 * Report AP creation failures via GHCB error codes rather than inducing #GP in
   guest (Peter)
 * Disallow multiple allocations of snp_context via userspace (Peter)
 * Error out on unsupported SNP policy bits (Tom)
 * Fix snp_leak_pages() stub (Jeremi)
 * Use C99 flexible arrays where appropriate
 * Use helper to handle HVA->PFN conversions prior to dumping RMP entries (Dave)
 * Don't potentially print out all 512 entries when dumping 2MB RMP range (Dave)
 * Don't use a union to dump raw RMP entries, just cast at dump-site (Dave)
 * Don't use helpers to access RMP entry bitfields, use them directly (Dave) 
 * Simplify logic and improve comments for AutoIBRS disablement (Dave)

 # Changes that were split off to separate gmem series
 * Use KVM_X86_SNP_VM to implement SNP-specific checks on whether a fault was
   shared/private and drop the duplicate memslot lookup (Isaku, Sean)
 * Use Isaku's version of patch to plumb 64-bit #NPF error code (Isaku)
 * Fix up stub for kvm_arch_gmem_invalidate() (Boris)

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

----------------------------------------------------------------
Ashish Kalra (4):
      x86/sev: Introduce snp leaked pages list
      KVM: SEV: Avoid WBINVD for HVA-based MMU notifications for SNP
      iommu/amd: Add IOMMU_SNP_SHUTDOWN support
      crypto: ccp: Add panic notifier for SEV/SNP firmware shutdown on kdump

Brijesh Singh (29):
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
      crypto: ccp: Handle the legacy SEV command when SNP is enabled
      crypto: ccp: Add the SNP_PLATFORM_STATUS command
      KVM: SEV: Add GHCB handling for Hypervisor Feature Support requests
      KVM: SEV: Make AVIC backing, VMSA and VMCB memory allocation SNP safe
      KVM: SEV: Add initial SEV-SNP support
      KVM: SEV: Add KVM_SNP_INIT command
      KVM: SEV: Add KVM_SEV_SNP_LAUNCH_START command
      KVM: SEV: Add KVM_SEV_SNP_LAUNCH_UPDATE command
      KVM: SEV: Add KVM_SEV_SNP_LAUNCH_FINISH command
      KVM: SEV: Add support to handle GHCB GPA register VMGEXIT
      KVM: SEV: Add support to handle MSR based Page State Change VMGEXIT
      KVM: SEV: Add support to handle Page State Change VMGEXIT
      KVM: x86: Export the kvm_zap_gfn_range() for the SNP use
      KVM: SEV: Add support to handle RMP nested page faults
      KVM: SVM: Add module parameter to enable the SEV-SNP
      crypto: ccp: Add the SNP_{SET,GET}_EXT_CONFIG command
      KVM: SEV: Provide support for SNP_GUEST_REQUEST NAE event
      crypto: ccp: Add debug support for decrypting pages

Dionna Glaze (1):
      x86/sev: Add KVM commands for per-instance certs

Kim Phillips (1):
      x86/speculation: Do not enable Automatic IBRS if SEV SNP is enabled

Michael Roth (9):
      KVM: SEV: Do not intercept accesses to MSR_IA32_XSS for SEV-ES guests
      x86/fault: Report RMP page faults for kernel addresses
      KVM: SEV: Select CONFIG_KVM_SW_PROTECTED_VM when CONFIG_KVM_AMD_SEV=y
      KVM: SEV: Add KVM_EXIT_VMGEXIT
      KVM: SEV: Add support for GHCB-based termination requests
      KVM: SEV: Implement gmem hook for initializing private pages
      KVM: SEV: Implement gmem hook for invalidating private pages
      KVM: x86: Add gmem hook for determining max NPT mapping level
      iommu/amd: Report all cases inhibiting SNP enablement

Paolo Bonzini (1):
      KVM: SVM: INTERCEPT_RDTSCP is never intercepted anyway

Tom Lendacky (4):
      KVM: SVM: Fix TSC_AUX virtualization setup
      KVM: SEV: Add support to handle AP reset MSR protocol
      KVM: SEV: Use a VMSA physical address variable for populating VMCB
      KVM: SEV: Support SEV-SNP AP Creation NAE event

Vishal Annapurve (1):
      KVM: Add HVA range operator

 Documentation/virt/coco/sev-guest.rst              |   54 +
 Documentation/virt/kvm/api.rst                     |   34 +
 .../virt/kvm/x86/amd-memory-encryption.rst         |  147 ++
 arch/x86/Kbuild                                    |    2 +
 arch/x86/include/asm/cpufeatures.h                 |    1 +
 arch/x86/include/asm/disabled-features.h           |    8 +-
 arch/x86/include/asm/kvm-x86-ops.h                 |    2 +
 arch/x86/include/asm/kvm_host.h                    |    5 +
 arch/x86/include/asm/msr-index.h                   |   11 +-
 arch/x86/include/asm/sev-common.h                  |   33 +
 arch/x86/include/asm/sev-host.h                    |   37 +
 arch/x86/include/asm/sev.h                         |    6 +
 arch/x86/include/asm/svm.h                         |    6 +
 arch/x86/include/asm/trap_pf.h                     |    4 +
 arch/x86/kernel/cpu/amd.c                          |   24 +-
 arch/x86/kernel/cpu/common.c                       |    7 +-
 arch/x86/kernel/crash.c                            |    7 +
 arch/x86/kvm/Kconfig                               |    3 +
 arch/x86/kvm/lapic.c                               |    5 +-
 arch/x86/kvm/mmu.h                                 |    2 -
 arch/x86/kvm/mmu/mmu.c                             |   13 +-
 arch/x86/kvm/svm/nested.c                          |    2 +-
 arch/x86/kvm/svm/sev.c                             | 1903 +++++++++++++++++---
 arch/x86/kvm/svm/svm.c                             |   64 +-
 arch/x86/kvm/svm/svm.h                             |   41 +-
 arch/x86/kvm/x86.c                                 |   11 +
 arch/x86/mm/fault.c                                |    5 +
 arch/x86/virt/svm/Makefile                         |    3 +
 arch/x86/virt/svm/sev.c                            |  548 ++++++
 drivers/crypto/ccp/sev-dev.c                       | 1253 ++++++++++++-
 drivers/crypto/ccp/sev-dev.h                       |   16 +
 drivers/iommu/amd/init.c                           |   65 +-
 include/linux/amd-iommu.h                          |    5 +-
 include/linux/kvm_host.h                           |    6 +
 include/linux/psp-sev.h                            |  304 +++-
 include/uapi/linux/kvm.h                           |   74 +
 include/uapi/linux/psp-sev.h                       |   71 +
 tools/arch/x86/include/asm/cpufeatures.h           |    1 +
 virt/kvm/kvm_main.c                                |   49 +
 39 files changed, 4497 insertions(+), 335 deletions(-)
 create mode 100644 arch/x86/include/asm/sev-host.h
 create mode 100644 arch/x86/virt/svm/Makefile
 create mode 100644 arch/x86/virt/svm/sev.c


