Return-Path: <kvm+bounces-5372-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ECA0D8207A6
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 18:25:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 59327B2156F
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 17:25:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 482F2F9EB;
	Sat, 30 Dec 2023 17:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="pYF6AYMM"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2075.outbound.protection.outlook.com [40.107.243.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36833CA47;
	Sat, 30 Dec 2023 17:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UqjzaQGlPwr5CnXNSnTENVzUMYDz93zfSHTOTgxC41gIeOGkSuZa1TfOKFq+T+Z5qDRbCDXfp4jrLheEj7w6C5AqpOlI64I2miWg9r0wsKTZx6wV2ykCu2CFLWDRJHJCBaYc2Lx0NAcqTW8CdWVq700jyhD1V+Ooo7umRw4b7rfAu0isaQlf/qCHpdatCNGRB6btcPefj+Eqc8QYdUY5kOZ7Q4gqNjeukHeb7n8Kl1399VJdre09Awb/0xvvX6PG6Y7tNzWJn48gl9NmDdJXdS2VmXcdN+TLk7Qkvnzs2dchBXRvzJh4GZCpxa+CJI9QfJzTgUsC7RNzid/ThzOy6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yzYWm8UMHK2D1V4fVc6c8ap/+H9sqBA9lscpSGCBd6Q=;
 b=emHegfPSLUXzagVRGLTFC79ze/LScKXA50Iu52Pcyzt8X15KNDudqnG6ecmdsqotMk6pAwZY/M6Ryl5Id0+gvG9T5sCf7zTPKTJKNU/rLERV4H/+vghoQ93ZtmVjPoV13VymqN76WjA+2+lrR3AG5pggqGdX0sk1cQYe+oaSdBadA6cNspJIODOzZdGOUQZxkfqDZqejTHclxlcjuuAvlzv7wka2vUTfXt/Ap3TGRv7FLdeeLpnBRqIOgIfkP9d1vMAyEhyI6tfm5XWFtTB+6UvqgBn2xZAryBLmNfbLRiyEZ4rydK4h9MoxN/KXpgZD6H0N9j6NkNdFi0s8FJLlEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yzYWm8UMHK2D1V4fVc6c8ap/+H9sqBA9lscpSGCBd6Q=;
 b=pYF6AYMMMdrT4nNtntRoUZWBAf0zH1yMCS6p6K6ZAT+Yw0285lmCPC8UBqraxYrzhMTUxUfuDAnGIRqabIsJoDP3uYdl7R9suVSQpPqP8CumFhA4K+41icP9OjxntwyA7GcQvLSctW8IPu/mHKMs2r66v8/IEta6Lg046KAez8E=
Received: from MN2PR11CA0007.namprd11.prod.outlook.com (2603:10b6:208:23b::12)
 by SA1PR12MB8947.namprd12.prod.outlook.com (2603:10b6:806:386::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.21; Sat, 30 Dec
 2023 17:25:03 +0000
Received: from MN1PEPF0000ECDB.namprd02.prod.outlook.com
 (2603:10b6:208:23b:cafe::4f) by MN2PR11CA0007.outlook.office365.com
 (2603:10b6:208:23b::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.21 via Frontend
 Transport; Sat, 30 Dec 2023 17:25:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000ECDB.mail.protection.outlook.com (10.167.242.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Sat, 30 Dec 2023 17:25:03 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Sat, 30 Dec
 2023 11:25:02 -0600
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vkuznets@redhat.com>, <jmattson@google.com>, <luto@kernel.org>,
	<dave.hansen@linux.intel.com>, <slp@redhat.com>, <pgonda@google.com>,
	<peterz@infradead.org>, <srinivas.pandruvada@linux.intel.com>,
	<rientjes@google.com>, <dovmurik@linux.ibm.com>, <tobin@ibm.com>,
	<bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>
Subject: [PATCH v11 00/35] Add AMD Secure Nested Paging (SEV-SNP) Hypervisor Support
Date: Sat, 30 Dec 2023 11:23:16 -0600
Message-ID: <20231230172351.574091-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECDB:EE_|SA1PR12MB8947:EE_
X-MS-Office365-Filtering-Correlation-Id: a51ee757-9f7b-45f4-dcc6-08dc095c4235
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	MQ+4SDPcTLJrUrNzFcKLhbnMmShHyuB7qEYQW+6knIPC4glWaRx9jAHbwmMmGnmhNUpZPxj6HNQZ9WzGL6R6DsJbngNDKexczY63QJrDElBHqqCXFWPFPODy8eO/nGefhMvc6hFh2CVgXnvc3F5QCWjibLwJTZRRjbIktbiuzoFdFuW5BoABUW394Q2Hjfd0uacaNEJBqrGJe5lOHHg0ebFnQe3ZXZRzs+GkBDiGjzUst6N40ozLLXFuQxLKGo8RZPRokv5QwoVD+l/OtkWdS/j6X8AT3RUyxac0RhWlPaIwwqIcW5Uqt3/NstfTJ8WSX0F5jTRdSV0/r7mQbIidm6BQdPE6GZv6Tr91qQyKe6obhdOZmo7dKaS+BriWevzqbVZGN2rnF7rXRs1CrjBQW4hZZX58VoTyOGKwISy+EDtEbFBPjKmaVVpvIq7BE8H1mJfn2dVhFWUfzdBQAWRrxiOax3PdNItp/mVqerOzEz3ERF7Fey2vUQNLX5eheB1rxPEf3OJtrEQfEkZ4wxCUAZyqZnOAF5ocGVWChW0Z4fWweykUhIlM4oKlOB6j/bo7Q4FkWVV64+vgHOxUbeWvPpy725xU8sSCzUA21OCltM7BIjdbM9mU04sFjD+SCerRqOQEX0IbG+90CD8VontD9bMEbGHGjGahrrr20SbheAxBI/7jyz+E4nmOIKOhAEPh3lN22VvxXJszLCJtciPf+vUpilAHmNNmiYeBMYhQY24FAgVMnHHKf283czle+im1mkVK1mRXMr+rA4FHiTOoDJK+xiHjTwRH/g6KpueqXX8=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(346002)(396003)(136003)(376002)(230922051799003)(64100799003)(82310400011)(1800799012)(186009)(451199024)(36840700001)(46966006)(40470700004)(7406005)(2906002)(30864003)(7416002)(44832011)(5660300002)(26005)(41300700001)(336012)(1076003)(426003)(83380400001)(40480700001)(36756003)(16526019)(36860700001)(47076005)(6666004)(966005)(356005)(478600001)(2616005)(86362001)(82740400003)(81166007)(8676002)(54906003)(316002)(4326008)(8936002)(40460700003)(70206006)(6916009)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2023 17:25:03.1610
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a51ee757-9f7b-45f4-dcc6-08dc095c4235
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECDB.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8947

This patchset is also available at:

  https://github.com/amdese/linux/commits/snp-host-v11

and is based on top of the following series:

  "[PATCH v1] Add AMD Secure Nested Paging (SEV-SNP) Initialization Support"
  https://lore.kernel.org/kvm/20231230161954.569267-1-michael.roth@amd.com/

which in turn is based on linux-next tag next-20231222

The host initialization patches have been split off to a separate series
as noted above to more easily shepherd them into tip/x86, while this series
now focuses on KVM support. Additionally, the gmem RFC[1] that this series
was previously based on is now included for better visibility and to provide
more context. Please see the RFC link however for more context on why the
gmem changes/hooks are implemented in their current form.

[1] https://lore.kernel.org/kvm/20231016115028.996656-1-michael.roth@amd.com/


== OVERVIEW ==

This patchset implements SEV-SNP hypervisor support for linux. It
relies on the SNP host initialization patches noted above, which we
originally included in this series up until v10, but are now posted
separately for inclusion into x86 tree, while this series is targetted
for the x86 KVM tree. Both aggregate of these patchsets are being based
on linux-next to hopefully make it easier coordinate and test against
tip and kvm-next. 


== TESTING ==

For testing this via QEMU, use the following tree:

  https://github.com/amdese/qemu/commits/snp-v3-wip

SEV-SNP with gmem enabled:

  qemu-system-x86_64 -cpu EPYC-Milan-v2 \
    -object memory-backend-memfd,id=ram1,size=2G,share=true,prealloc=false,reserve=false \
    -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1 \
    -machine q35,confidential-guest-support=sev0,memory-backend=ram1 \
    ...

KVM selftests for guest_memfd / KVM_GENERIC_PRIVATE_MEM:

  cd $kernel_src_dir
  make -C tools/testing/selftests TARGETS="kvm" EXTRA_CFLAGS="-DDEBUG -I<path to kernel headers>"
  sudo tools/testing/selftests/kvm/x86_64/private_mem_conversions_test


== BACKGROUND (SEV-SNP) ==

This part of the Secure Encrypted Paging (SEV-SNP) series focuses on the
changes required to add KVM support for SEV-SNP. The series builds upon
SEV-SNP Guest Support, now part of mainline, and a separate series that
implements basic host initialization requirements for SNP-enabled systems.

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

Changes since v10:

 * Split off host initialization patches to separate series
 * Drop SNP_{SET,GET}_EXT_CONFIG SEV ioctls, and drop 
   KVM_SEV_SNP_{SET,GET}_CERTS KVM ioctls. Instead, all certificate data is
   now fetched from uerspace as part of a new KVM_EXIT_VMGEXIT event type.
   (Sean, Dionna)
 * SNP_SET_EXT_CONFIG is now replaced with a more basic SNP_SET_CONFIG,
   which is now just a light wrapper around the SNP_CONFIG firmware command,
   and SNP_GET_EXT_CONFIG is now redundant with existing SNP_PLATFORM_STATUS,
   so just stick with that interface
 * Introduce SNP_SET_CONFIG_{START,END}, which can be used to pause extended
   guest requests while reported TCB / certificates are being updated so
   the updates are done atomically relative to running guests.
 * Improve documentation for KVM_EXIT_VMGEXIT event types and tighten down
   the expected input/output for union types rather than exposing GHCB
   page/MSR
 * Various re-factorings, commit/comments fixups (Boris, Liam, Vlastimil) 
 * Make CONFIG_KVM_AMD_SEV depend on KVM_GENERIC_PRIVATE_MEM instead of
   CONFIG_KVM_SW_PROTECTED_VM (Paolo)
 * Include Sean's patch to add hugepage support to gmem, but modify it based
   on discussions to be best-effort and not rely on explicit flag

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

----------------------------------------------------------------
Ashish Kalra (1):
      KVM: SEV: Avoid WBINVD for HVA-based MMU notifications for SNP

Brijesh Singh (14):
      KVM: x86: Define RMP page fault error bits for #NPF
      KVM: SEV: Add GHCB handling for Hypervisor Feature Support requests
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
      KVM: SEV: Provide support for SNP_GUEST_REQUEST NAE event

Michael Roth (15):
      mm: Introduce AS_INACCESSIBLE for encrypted/confidential memory
      KVM: Use AS_INACCESSIBLE when creating guest_memfd inode
      KVM: x86: Add gmem hook for initializing memory
      KVM: x86: Add gmem hook for invalidating memory
      KVM: x86/mmu: Pass around full 64-bit error code for KVM page faults
      KVM: x86: Add KVM_X86_SNP_VM vm_type
      KVM: x86: Determine shared/private faults based on vm_type
      KVM: SEV: Do not intercept accesses to MSR_IA32_XSS for SEV-ES guests
      KVM: SEV: Select KVM_GENERIC_PRIVATE_MEM when CONFIG_KVM_AMD_SEV=y
      KVM: SEV: Add support for GHCB-based termination requests
      KVM: SEV: Implement gmem hook for initializing private pages
      KVM: SEV: Implement gmem hook for invalidating private pages
      KVM: x86: Add gmem hook for determining max NPT mapping level
      crypto: ccp: Add the SNP_SET_CONFIG_{START,END} commands
      KVM: SEV: Provide support for SNP_EXTENDED_GUEST_REQUEST NAE event

Sean Christopherson (1):
      KVM: Add hugepage support for dedicated guest memory

Tom Lendacky (3):
      KVM: SEV: Add support to handle AP reset MSR protocol
      KVM: SEV: Use a VMSA physical address variable for populating VMCB
      KVM: SEV: Support SEV-SNP AP Creation NAE event

Vishal Annapurve (1):
      KVM: Add HVA range operator

 Documentation/virt/coco/sev-guest.rst              |   33 +-
 Documentation/virt/kvm/api.rst                     |   73 ++
 .../virt/kvm/x86/amd-memory-encryption.rst         |  103 ++
 arch/x86/include/asm/kvm-x86-ops.h                 |    3 +
 arch/x86/include/asm/kvm_host.h                    |   15 +
 arch/x86/include/asm/sev-common.h                  |   22 +-
 arch/x86/include/asm/sev.h                         |   11 +
 arch/x86/include/asm/svm.h                         |    6 +
 arch/x86/include/uapi/asm/kvm.h                    |    1 +
 arch/x86/kvm/Kconfig                               |    3 +
 arch/x86/kvm/mmu.h                                 |    2 -
 arch/x86/kvm/mmu/mmu.c                             |   28 +-
 arch/x86/kvm/mmu/mmu_internal.h                    |   24 +-
 arch/x86/kvm/mmu/mmutrace.h                        |    2 +-
 arch/x86/kvm/mmu/paging_tmpl.h                     |    2 +-
 arch/x86/kvm/svm/sev.c                             | 1362 +++++++++++++++++++-
 arch/x86/kvm/svm/svm.c                             |   38 +-
 arch/x86/kvm/svm/svm.h                             |   40 +-
 arch/x86/kvm/x86.c                                 |   44 +-
 arch/x86/virt/svm/sev.c                            |   51 +
 drivers/crypto/ccp/sev-dev.c                       |   44 +
 include/linux/kvm_host.h                           |   24 +
 include/linux/pagemap.h                            |    1 +
 include/uapi/linux/kvm.h                           |   84 ++
 include/uapi/linux/psp-sev.h                       |   12 +
 include/uapi/linux/sev-guest.h                     |    9 +
 mm/truncate.c                                      |    3 +-
 virt/kvm/Kconfig                                   |    8 +
 virt/kvm/guest_memfd.c                             |  132 +-
 virt/kvm/kvm_main.c                                |   49 +
 30 files changed, 2175 insertions(+), 54 deletions(-)



