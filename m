Return-Path: <kvm+bounces-13114-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E3E5F89270E
	for <lists+kvm@lfdr.de>; Sat, 30 Mar 2024 00:00:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 49B1DB22D7B
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 23:00:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C705413E3E6;
	Fri, 29 Mar 2024 22:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="aSZaNB8m"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2068.outbound.protection.outlook.com [40.107.93.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F8C13D627;
	Fri, 29 Mar 2024 22:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711753189; cv=fail; b=KkzJ4D/hGOm6H7lybFTyphgcbndcau0OQMPGMJsmNWC/x9t/9udarNpuGuxJyPyaJnVmX1o3Z+bskjB4bbNnfizqxPl5tfOfn1mmirKOT5dS5jsb6vBK7ZyXLqk5KPcg9oc/sC7ExlRPL7QCTwc988a1J31/4gUX83WAT5lKaCg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711753189; c=relaxed/simple;
	bh=yKD6Z3CWCO1R5YG84VSYV4FFCsF/dwEriI482bu3JTE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Hk+wDZYD3447FsG7ra32Qs2LiWrfGrBfgJP5mvGU+fDcq/K12xfK0s8HNsSfuHFM9cGF0oegLiqFR+WZAi/F/e83YH4KsNf5b8i7C82bYGZsMPEUhYtVyArcbVLSjmQZ7ePFPwfWeFekg7eWuvemZykQs9kfH4g/TukLviJMg5o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=aSZaNB8m; arc=fail smtp.client-ip=40.107.93.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HBib6RTkprrBtKFMtciyzEOREcrm6zXD+6o7WlqixvaMcQrdqN5lNgQjN/GEZi9eZ/Uk0V3KQrkcfK6MxgN+m5GoOojwNh6na3LS7IC3fOmbFDZa9cE67LaZJc6sBW/yuuY7ko4s39KK02TxkA+EKzY3oEVwkT2HlNkRM2Sz5JphvXbMdUhbDVYDY/a1vYK+JYZ3oH0sIp1kvHEFe/JS/uRy/NBWxvTD22+Sgkx0Rsi8jPf8smMuSBvvgPm8IdRtrAmRmClERDJqUVvbEHbilI7MdPRTD1c/kVau9zlp3M8f/SXbWI0+AOAdBFr9MFJBCeRMqTFhFZ1QUmTI16SzwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W6XwIhnbyiFwjhaPLMCpe4b4WhUMyHdpcDV6YoH2FTI=;
 b=EOrYX9UVMszmMEC0P71nwPAUTk+oJ8bi0wa1+MNrizAoGeNfdhdZR7Ox5jdSjdr5B+tz/VzeSl28+cjaYCCDAupsQ6y2G3j5I+pYlO254zExpr55GgXFCR8da2ZwPzn1Xf+n7JOM7kQjHfPn5T9ANvMtKktahv1wC8C0JwDStphIexbWCSQ8lI6Mw2bwxwc3h4om8C/JQAEDAASeRZ2mVWpstThjplsnKgX1kLjb/H9KsbwoSnhjSEJ03o6LXH9291ts9Ge2OvVyQLcPd05YW0ZQo7x3P8BnKSI+rdgdGDAbWW4O1O6IvN8BlBRTwux2RYG0oH6JRgP/znFJSzFIgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W6XwIhnbyiFwjhaPLMCpe4b4WhUMyHdpcDV6YoH2FTI=;
 b=aSZaNB8moAiu1c+h0xVa328kTLaCLFbUIKInKDNjwnVJ2vKM0v7xkwoq3/yuh4TLG8CFWOMrdRP05xwspSuAYrCdvt/jPpJH5FDRsd5oNdeKvYbNLT7G6d4qdPiA6CSwEB14LCrm03jVWxWUHO78SGetvuSC4b/QAzNcI2JKU2M=
Received: from BYAPR01CA0061.prod.exchangelabs.com (2603:10b6:a03:94::38) by
 SA1PR12MB5613.namprd12.prod.outlook.com (2603:10b6:806:22b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.41; Fri, 29 Mar
 2024 22:59:43 +0000
Received: from SJ1PEPF00001CDD.namprd05.prod.outlook.com
 (2603:10b6:a03:94:cafe::86) by BYAPR01CA0061.outlook.office365.com
 (2603:10b6:a03:94::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.40 via Frontend
 Transport; Fri, 29 Mar 2024 22:59:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CDD.mail.protection.outlook.com (10.167.242.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Fri, 29 Mar 2024 22:59:43 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 29 Mar
 2024 17:59:42 -0500
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>
Subject: [PATCH v12 00/29] Add AMD Secure Nested Paging (SEV-SNP) Hypervisor Support
Date: Fri, 29 Mar 2024 17:58:06 -0500
Message-ID: <20240329225835.400662-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CDD:EE_|SA1PR12MB5613:EE_
X-MS-Office365-Filtering-Correlation-Id: 04df9763-f67a-45a0-895a-08dc5043ec53
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	QTkX01t/CQGSIM2UoVIeJlO6PgFFtT4/ZSzs6ZBMfywlsEggE0T3P1O6IwNW67dETu/srC97PsB2C3H82fJ3uFAuyuihNvj3DanNqrpJrReW55acuBpc5QoDloOchvUgSalLh6MC0rLNTWwNPDF32dQltsE3+4wtbctFxCOqTUcrw6dBf0mo1so3UfVvkquik/DNNRRQg74GsJnuYMgCehsqmObheftRlx7v9YyH39swtytXT5/355UaJXYiJ1ORIKodLig4A72a9GSfHFZv8gOtV53GAR2pQGQZNAXI3iUw66LXuInNVdZzYmNi7vke7jyb0Cge3DQgruXP3xEmR5/Q2YmOG8em5CByb7PjYC87PjHq3DoMD6LjXXLDKIo9k47RAXXDXJBIR+XyLuHrPTn9J2IL+50tzVVq65VdVgzN9Eaq0BH3EkABJc/zUIMUkVrQbMfEDe9qS5xwrcrgSjSd4/AAlw+/DvB+McKk/yYEVJgh+uCJCxPhqKHsOupwtBoekOJqFOU4WJR4dza9mOGnK5H6yerRNox+GCeM6zTpqAEsjBR4V+ThlPgAvjvm3slVfzeeoBIbBlMZX0AW8ryCEA4H6DX+UFKFOHRZPtmQPEg0+ZJpLNLRX4W4dPutC9cXPiRbY+G54XW9UA1BXl3VJz7eJ4VkbOAt7CxsxZINDvWCsSDR4wd++l86SfnluAbGk6N45Gsu/4LSRBGQ0g==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(82310400014)(376005)(7416005)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 22:59:43.6602
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 04df9763-f67a-45a0-895a-08dc5043ec53
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CDD.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5613

This patchset is also available at:

  https://github.com/amdese/linux/commits/snp-host-v12

and is based on top of the following series:

  [PATCH gmem 0/6] gmem fix-ups and interfaces for populating gmem pages
  https://lore.kernel.org/kvm/20240329212444.395559-1-michael.roth@amd.com/ 

which in turn is based on:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git/log/?h=kvm-coco-queue


Patch Layout
------------

01-04: These patches are minor dependencies for this series and will
       eventually make their way upstream through other trees. They are
       included here only temporarily.

05-09: These patches add some basic infrastructure and introduces a new
       KVM_X86_SNP_VM vm_type to handle differences verses the existing
       KVM_X86_SEV_VM and KVM_X86_SEV_ES_VM types.

10-12: These implement the KVM API to handle the creation of a
       cryptographic launch context, encrypt/measure the initial image
       into guest memory, and finalize it before launching it.

13-20: These implement handling for various guest-generated events such
       as page state changes, onlining of additional vCPUs, etc.

21-24: These implement the gmem hooks needed to prepare gmem-allocated
       pages before mapping them into guest private memory ranges as
       well as cleaning them up prior to returning them to the host for
       use as normal memory. Because this supplants certain activities
       like issued WBINVDs during KVM MMU invalidations, there's also
       a patch to avoid duplicating that work to avoid unecessary
       overhead.

25:    With all the core support in place, the patch adds a kvm_amd module
       parameter to enable SNP support.

26-29: These patches all deal with the servicing of guest requests to handle
       things like attestation, as well as some related host-management
       interfaces.


Testing
-------

For testing this via QEMU, use the following tree:

  https://github.com/amdese/qemu/commits/snp-v4-wip2

A patched OVMF is also needed due to upstream KVM no longer supporting MMIO
ranges that are mapped as private. It is recommended you build the AmdSevX64
variant as it provides the kernel-hashing support present in this series:

  https://github.com/amdese/ovmf/commits/apic-mmio-fix1c

A basic command-line invocation for SNP would be:

 qemu-system-x86_64 -smp 32,maxcpus=255 -cpu EPYC-Milan-v2
  -machine q35,confidential-guest-support=sev0,memory-backend=ram1
  -object memory-backend-memfd,id=ram1,size=4G,share=true,reserve=false
  -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,id-auth=
  -bios /home/mroth/ovmf/OVMF_CODE-upstream-20240228-apicfix-1c-AmdSevX64.fd

With kernel-hashing and certificate data supplied:

 qemu-system-x86_64 -smp 32,maxcpus=255 -cpu EPYC-Milan-v2
  -machine q35,confidential-guest-support=sev0,memory-backend=ram1
  -object memory-backend-memfd,id=ram1,size=4G,share=true,reserve=false
  -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,id-auth=,certs-path=/home/mroth/cert.blob,kernel-hashes=on
  -bios /home/mroth/ovmf/OVMF_CODE-upstream-20240228-apicfix-1c-AmdSevX64.fd
  -kernel /boot/vmlinuz-6.8.0-snp-host-v12-wip40+
  -initrd /boot/initrd.img-6.8.0-snp-host-v12-wip40+
  -append "root=UUID=d72a6d1c-06cf-4b79-af43-f1bac4f620f9 ro console=ttyS0,115200n8"


Known issues / TODOs
--------------------

 * Base tree in some cases reports "Unpatched return thunk in use. This should 
   not happen!" the first time it runs an SVM/SEV/SNP guests. This a recent
   regression upstream and unrelated to this series:

     https://lore.kernel.org/linux-kernel/CANpmjNOcKzEvLHoGGeL-boWDHJobwfwyVxUqMq2kWeka3N4tXA@mail.gmail.com/T/

 * 2MB hugepage support has been dropped pending discussion on how we plan
   to re-enable it in gmem.

 * Host kexec should work, but there is a known issue with handling host
   kdump while SNP guests are running which will be addressed as a follow-up.

 * SNP kselftests are currently a WIP and will be included as part of SNP
   upstreaming efforts in the near-term.


SEV-SNP Overview
----------------

This part of the Secure Encrypted Paging (SEV-SNP) series focuses on the
changes required to add KVM support for SEV-SNP. This series builds upon
SEV-SNP guest support, which is now in mainline, and and SEV-SNP host
initialization support, which is now in linux-next.

While series provides the basic building blocks to support booting the
SEV-SNP VMs, it does not cover all the security enhancement introduced by
the SEV-SNP such as interrupt protection, which will added in the future.

With SNP, when pages are marked as guest-owned in the RMP table, they are
assigned to a specific guest/ASID, as well as a specific GFN with in the
guest. Any attempts to map it in the RMP table to a different guest/ASID,
or a different GFN within a guest/ASID, will result in an RMP nested page
fault.

Prior to accessing a guest-owned page, the guest must validate it with a
special PVALIDATE instruction which will set a special bit in the RMP table
for the guest. This is the only way to set the validated bit outside of the
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

In this implementation of SEV-SNP, private guest memory is managed by a new
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

Changes since v11:

 * Rebase series on kvm-coco-queue and re-work to leverage more
   infrastructure between SNP/TDX series.
 * Drop KVM_SNP_INIT in favor of the new KVM_SEV_INIT2 interface introduced
   here (Paolo):
     https://lore.kernel.org/lkml/20240318233352.2728327-1-pbonzini@redhat.com/
 * Drop exposure API fields related to things like VMPL levels, migration
   agents, etc., until they are actually supported/used (Sean)
 * Rework KVM_SEV_SNP_LAUNCH_UPDATE handling to use a new
   kvm_gmem_populate() interface instead of copying data directly into
   gmem-allocated pages (Sean)
 * Add support for SNP_LOAD_VLEK, rework the SNP_SET_CONFIG_{START,END} to
   have simpler semantics that are applicable to management of SNP_LOAD_VLEK
   updates as well, rename interfaces to the now more appropriate
   SNP_{PAUSE,RESUME}_ATTESTATION
 * Fix up documentation wording and do print warnings for
   userspace-triggerable failures (Peter, Sean)
 * Fix a race with AP_CREATION wake-up events (Jacob, Sean)
 * Fix a memory leak with VMSA pages (Sean)
 * Tighten up handling of RMP page faults to better distinguish between real
   and spurious cases (Tom)
 * Various patch/documentation rewording, cleanups, etc.

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

----------------------------------------------------------------
Ashish Kalra (1):
      KVM: SEV: Avoid WBINVD for HVA-based MMU notifications for SNP

Borislav Petkov (AMD) (3):
      [TEMP] x86/kvm/Kconfig: Have KVM_AMD_SEV select ARCH_HAS_CC_PLATFORM
      [TEMP] x86/cc: Add cc_platform_set/_clear() helpers
      [TEMP] x86/CPU/AMD: Track SNP host status with cc_platform_*()

Brijesh Singh (11):
      KVM: x86: Define RMP page fault error bits for #NPF
      KVM: SEV: Add GHCB handling for Hypervisor Feature Support requests
      KVM: SEV: Add KVM_SEV_SNP_LAUNCH_START command
      KVM: SEV: Add KVM_SEV_SNP_LAUNCH_UPDATE command
      KVM: SEV: Add support to handle GHCB GPA register VMGEXIT
      KVM: SEV: Add support to handle MSR based Page State Change VMGEXIT
      KVM: SEV: Add support to handle Page State Change VMGEXIT
      KVM: x86: Export the kvm_zap_gfn_range() for the SNP use
      KVM: SEV: Add support to handle RMP nested page faults
      KVM: SVM: Add module parameter to enable the SEV-SNP
      KVM: SEV: Provide support for SNP_GUEST_REQUEST NAE event

Michael Roth (10):
      KVM: SEV: Select KVM_GENERIC_PRIVATE_MEM when CONFIG_KVM_AMD_SEV=y
      KVM: SEV: Add initial SEV-SNP support
      KVM: SEV: Add KVM_SEV_SNP_LAUNCH_FINISH command
      KVM: SEV: Add support for GHCB-based termination requests
      KVM: SEV: Implement gmem hook for initializing private pages
      KVM: SEV: Implement gmem hook for invalidating private pages
      KVM: x86: Implement gmem hook for determining max NPT mapping level
      crypto: ccp: Add the SNP_VLEK_LOAD command
      crypto: ccp: Add the SNP_{PAUSE,RESUME}_ATTESTATION commands
      KVM: SEV: Provide support for SNP_EXTENDED_GUEST_REQUEST NAE event

Paolo Bonzini (1):
      [TEMP] fixup! KVM: SEV: sync FPU and AVX state at LAUNCH_UPDATE_VMSA time

Tom Lendacky (3):
      KVM: SEV: Add support to handle AP reset MSR protocol
      KVM: SEV: Use a VMSA physical address variable for populating VMCB
      KVM: SEV: Support SEV-SNP AP Creation NAE event

 Documentation/virt/coco/sev-guest.rst              |   50 +-
 Documentation/virt/kvm/api.rst                     |   73 +
 .../virt/kvm/x86/amd-memory-encryption.rst         |   88 +-
 arch/x86/coco/core.c                               |   52 +
 arch/x86/include/asm/kvm_host.h                    |    8 +
 arch/x86/include/asm/sev-common.h                  |   22 +-
 arch/x86/include/asm/sev.h                         |   15 +-
 arch/x86/include/asm/svm.h                         |    9 +-
 arch/x86/include/uapi/asm/kvm.h                    |   39 +
 arch/x86/kernel/cpu/amd.c                          |   38 +-
 arch/x86/kernel/cpu/mtrr/generic.c                 |    2 +-
 arch/x86/kernel/fpu/xstate.c                       |    1 +
 arch/x86/kernel/sev.c                              |   10 -
 arch/x86/kvm/Kconfig                               |    4 +
 arch/x86/kvm/mmu.h                                 |    2 -
 arch/x86/kvm/mmu/mmu.c                             |    1 +
 arch/x86/kvm/svm/sev.c                             | 1410 +++++++++++++++++++-
 arch/x86/kvm/svm/svm.c                             |   48 +-
 arch/x86/kvm/svm/svm.h                             |   50 +
 arch/x86/kvm/x86.c                                 |   18 +-
 arch/x86/virt/svm/sev.c                            |   90 +-
 drivers/crypto/ccp/sev-dev.c                       |   85 +-
 drivers/iommu/amd/init.c                           |    4 +-
 include/linux/cc_platform.h                        |   12 +
 include/linux/psp-sev.h                            |    4 +-
 include/uapi/linux/kvm.h                           |   28 +
 include/uapi/linux/psp-sev.h                       |   39 +
 include/uapi/linux/sev-guest.h                     |    9 +
 virt/kvm/guest_memfd.c                             |    4 +-
 29 files changed, 2121 insertions(+), 94 deletions(-)



