Return-Path: <kvm+bounces-15137-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BCE2A8AA310
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 21:43:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E0B951C229EC
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 19:43:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADA80184113;
	Thu, 18 Apr 2024 19:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="H6fhf23h"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2077.outbound.protection.outlook.com [40.107.94.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E44FC179204;
	Thu, 18 Apr 2024 19:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713469370; cv=fail; b=ggibOvXtnV7cvOifr41ykQio46PfBd5N5rfN67K0eu8Wdw/+kFhiNX9tQK7IIpVvyv5wpzc2gGsuMonIUVB+rizkreuYJY3z1MOhlDVXUbjBv2Hvyv4L478aBdtkHALNpTyzQ3qGp1BwZ6JnLzw91GpkyFxXaaPxZ4SuAIW7RXI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713469370; c=relaxed/simple;
	bh=1UBsr06sOMoyd6SDaEHONrGGz6iQmxpcTP1NiJdrGLc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=JfoaXuo5rQMT08rxJXriKU09bi8gqToAcdI+xj9HGixIbhXrGlCtAu8AZMrX4S7tH3HSRCrJrmZjyBHlB1Sj14oprowu6RXvikZK+ThLgWTDOYIZUAJI6bc/8vHBPhK3Q9XX16zPHX/aBvcplZjBcLExsSk1dOJH5jowYhnKa4M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=H6fhf23h; arc=fail smtp.client-ip=40.107.94.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nT4htT53ZOfySWPkZmMT97AAWCzM4pIabmQcpA2ZVEXKLylp7ZrIu3a5YZ4+kXjwYvOQNGQZL2nsgaikKhDSPOvFcw9eHQlFF4WTCu0WpCVKs+xrAikJwmqtQPqSRznil5eypi3uS7m16ytpH3lm7zWSjZ765IwdijNx/uWMqLsvqHzrNbuG/65zPFFkIXJsjOgSqbypEX7R8688hnCjMa3VGC6hauhzLpuqtsDU2Nneks+wOm7aZ9bSShEmV7lFuNfzKkYyakt+IFPDnU6brcMWThS1j10BSMv11P9AY6FFh/DRV16G3GnzBkBpVpZ9L59kh1J+SpYJ0lYIPgtRTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eeKncTltXTFka3BHa878W9+1JCjyq1XF58bm4EvN1IM=;
 b=Mg6ExwPhnviNZzIGqf3I03M96umJDN+wt7IIRu4ePFa+vxEwYoDUqUs5IUH/iyMR6AGvLNFJSg1105npAzSIVWjmMet+il6LZ1JmgSh4YBbP+4lkl0vA5oY4fbCl3c+9ZoqsHHzsa6yxD+9idiayent24Vtw6cTPlbJ2lyBcR3MpAK9iqdNG7NEkgiU5dQzP2aklatyqtQPcT8ta/XaJyb8aXcMp0OaKgXK6BpIrb/fSUHbyF1E70frrJ//Gqh1QDLvhtJtSIi4lNInP7Zv1repWEEB1MB9hyX9MiyWSyxxOvqltfR4OuXLSdWOhPy4eWzQcMVKbKDgr7GwycIk+qQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eeKncTltXTFka3BHa878W9+1JCjyq1XF58bm4EvN1IM=;
 b=H6fhf23hsgLDS4/XgsGCbyE6sUW4OEldMJ1/rgmZ9gOZgt9tqCSOR/+baNvdF+mOuy597firZUlTct6FUhL+ytrW2MQBI7QZIAEKCp8MkF7U4l3/nLcdCFxGjsS1PMgeIHQEZbgeCOiaMysPL+/mASSyG2+P3oOUip6tnbOi1ZM=
Received: from SJ0PR13CA0101.namprd13.prod.outlook.com (2603:10b6:a03:2c5::16)
 by PH7PR12MB6588.namprd12.prod.outlook.com (2603:10b6:510:210::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.41; Thu, 18 Apr
 2024 19:42:45 +0000
Received: from SJ5PEPF000001CB.namprd05.prod.outlook.com
 (2603:10b6:a03:2c5:cafe::be) by SJ0PR13CA0101.outlook.office365.com
 (2603:10b6:a03:2c5::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.11 via Frontend
 Transport; Thu, 18 Apr 2024 19:42:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001CB.mail.protection.outlook.com (10.167.242.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7452.22 via Frontend Transport; Thu, 18 Apr 2024 19:42:45 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 18 Apr
 2024 14:42:40 -0500
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
Subject: [PATCH v13 00/26] Add AMD Secure Nested Paging (SEV-SNP) Hypervisor Support
Date: Thu, 18 Apr 2024 14:41:07 -0500
Message-ID: <20240418194133.1452059-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CB:EE_|PH7PR12MB6588:EE_
X-MS-Office365-Filtering-Correlation-Id: 48f224e9-9bc5-429f-513a-08dc5fdfb86f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Mhy1/WarZsdAJPbiKRuy6qKdZtbIVtldsPGyQzsXxcwehl5iVmNQA60ctWN0HKbV7eWJtvKdzPk4nKf6yqjpWrPy3bjY/K2yevjpp3NlO++iMi1Z418pjdEfQKsf9OpDWO/QndeQ+Cb/zwcC1uYSAHHWJOMD6Oi4FdyJwSKPINqRerj7E0HC6RWG/L3YnjILWhMlt8lo3u2FKX5YfTWlO9AWPOmIcZR+QBVTQaNXD2rnD9KLODetz7Xz2rYziPihOVPn34n+VC/fQV5+n2pCnZ2kd1b/7p51pNHGAVo1HBgfLBvF6W1dW3Dl5N7wJkq/BSi1TpU2Xa8Q22g2H4JH5HqEUa+u3ItL0ehiFDLMPoACGRcEM2+zEZGHYnHWaH07BXK5q9W0VQLS+PXSt8IKqMl/pXknKUaPdkLD7cCmzshe7YINBTBFIL+r12KWF0pzavzMNSA8VJIE/y6J2KxNT8wJlyw/LV23I22JKh4E/nXpPDMrfoEAypkZs9FhZq1L+6Fds+446WXm8mNisXOavCNP8uGRqU/FO1vvxuZR4omtitDq4OaE7Go4z9wHp3vUitO/gl6V/mAPgb18/3Y4fPsOHAovz/1Vyu8EJGa+I5RbcEMuVPOsYVV5qs6LOFd8w5/OREeKwtkh+aJ8dm5uSrEcChwV2lGk6NPQhQziTcqWFDpokiX10dfXmqq2WnfiXJ5S7OPAJy5DFtEyI1wt36rSOObgMXqVDlAUuxej6H8hq2tcHTtwl8kz/iFUUqxKWZJYZfRV8eZZG9DJkp5Zmw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(7416005)(376005)(82310400014)(1800799015)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2024 19:42:45.5166
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 48f224e9-9bc5-429f-513a-08dc5fdfb86f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CB.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6588

This patchset is also available at:

  https://github.com/amdese/linux/commits/snp-host-v13

and is based on commit 4d2deb62185f (as suggested by Paolo) from:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git/log/?h=kvm-coco-queue


Patch Layout
------------

01-03: These patches are minor dependencies for this series and are already
       included in both tip/master and mainline, so are only included here
       as a stop-gap until merged from one of those trees. These are needed
       by patch #8 in this series which makes use of CC_ATTR_HOST_SEV_SNP

04:    This is a small general fix-up for guest_memfd that can be applied
       independently of this series.

05-08: These patches add some basic infrastructure and introduces a new
       KVM_X86_SNP_VM vm_type to handle differences verses the existing
       KVM_X86_SEV_VM and KVM_X86_SEV_ES_VM types.

09-11: These implement the KVM API to handle the creation of a
       cryptographic launch context, encrypt/measure the initial image
       into guest memory, and finalize it before launching it.

12-17: These implement handling for various guest-generated events such
       as page state changes, onlining of additional vCPUs, etc.

18-21: These implement the gmem hooks needed to prepare gmem-allocated
       pages before mapping them into guest private memory ranges as
       well as cleaning them up prior to returning them to the host for
       use as normal memory. Because this supplants certain activities
       like issued WBINVDs during KVM MMU invalidations, there's also
       a patch to avoid duplicating that work to avoid unecessary
       overhead.

22:    With all the core support in place, the patch adds a kvm_amd module
       parameter to enable SNP support.

23-26: These patches all deal with the servicing of guest requests to handle
       things like attestation, as well as some related host-management
       interfaces.


Testing
-------

For testing this via QEMU, use the following tree:

  https://github.com/amdese/qemu/commits/snp-v4-wip3

A patched OVMF is also needed due to upstream KVM no longer supporting MMIO
ranges that are mapped as private. It is recommended you build the AmdSevX64
variant as it provides the kernel-hashing support present in this series:

  https://github.com/amdese/ovmf/commits/apic-mmio-fix1d

A basic command-line invocation for SNP would be:

 qemu-system-x86_64 -smp 32,maxcpus=255 -cpu EPYC-Milan-v2
  -machine q35,confidential-guest-support=sev0,memory-backend=ram1
  -object memory-backend-memfd,id=ram1,size=4G,share=true,reserve=false
  -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,id-auth=
  -bios OVMF_CODE-upstream-20240410-apic-mmio-fix1d-AmdSevX64.fd

With kernel-hashing and certificate data supplied:

 qemu-system-x86_64 -smp 32,maxcpus=255 -cpu EPYC-Milan-v2
  -machine q35,confidential-guest-support=sev0,memory-backend=ram1
  -object memory-backend-memfd,id=ram1,size=4G,share=true,reserve=false
  -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,id-auth=,certs-path=/home/mroth/cert.blob,kernel-hashes=on
  -bios OVMF_CODE-upstream-20240410-apic-mmio-fix1d-AmdSevX64.fd
  -kernel /boot/vmlinuz-$ver
  -initrd /boot/initrd.img-$ver
  -append "root=UUID=d72a6d1c-06cf-4b79-af43-f1bac4f620f9 ro console=ttyS0,115200n8"

With standard X64 OVMF package with separate image for persistent NVRAM:

 qemu-system-x86_64 -smp 32,maxcpus=255 -cpu EPYC-Milan-v2
  -machine q35,confidential-guest-support=sev0,memory-backend=ram1
  -object memory-backend-memfd,id=ram1,size=4G,share=true,reserve=false
  -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,id-auth=
  -bios OVMF_CODE-upstream-20240410-apic-mmio-fix1d.fd 
  -drive if=pflash,format=raw,unit=0,file=OVMF_VARS-upstream-20240410-apic-mmio-fix1d.fd,readonly=off


Known issues / TODOs
--------------------

 * SEV-ES guests may trigger the following warning:

     WARNING: CPU: 151 PID: 4003 at arch/x86/kvm/mmu/mmu.c:5855 kvm_mmu_page_fault+0x33b/0x860 [kvm]

   It is assumed here that these will be resolved once the transition to
   PFERR_PRIVATE_ACCESS is fully completed, but if that's not the case let me
   know and will investigate further.

 * Base tree in some cases reports "Unpatched return thunk in use. This should 
   not happen!" the first time it runs an SVM/SEV/SNP guests. This a recent
   regression upstream and unrelated to this series:

     https://lore.kernel.org/linux-kernel/CANpmjNOcKzEvLHoGGeL-boWDHJobwfwyVxUqMq2kWeka3N4tXA@mail.gmail.com/T/

 * 2MB hugepage support has been dropped pending discussion on how we plan to
   re-enable it in gmem.

 * Host kexec should work, but there is a known issue with host kdump support
   while SNP guests are running that will be addressed as a follow-up.

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


Changes since v12:

 * rebased to latest kvm-coco-queue branch (commit 4d2deb62185f)
 * add more input validation for SNP_LAUNCH_START, especially for handling
   things like MBO/MBZ policy bits, and API major/minor minimums. (Paolo)
 * block SNP KVM instances from being able to run legacy SEV commands (Paolo)
 * don't attempt to measure VMSA for vcpu 0/BSP before the others, let
   userspace deal with the ordering just like with SEV-ES (Paolo)
 * fix up docs for SNP_LAUNCH_FINISH (Paolo)
 * introduce svm->sev_es.snp_has_guest_vmsa flag to better distinguish
   handling for guest-mapped vs non-guest-mapped VMSAs, rename
   'snp_ap_create' flag to 'snp_ap_waiting_for_reset' (Paolo)
 * drop "KVM: SEV: Use a VMSA physical address variable for populating VMCB"
   as it is no longer needed due to above VMSA rework
 * replace pr_debug_ratelimited() messages for RMP #NPFs with a single trace
   event
 * handle transient PSMASH_FAIL_INUSE return codes in kvm_gmem_invalidate(),
   switch to WARN_ON*()'s to indicate remaining error cases are not expected
   and should not be seen in practice. (Paolo)
 * add a cond_resched() in kvm_gmem_invalidate() to avoid soft lock-ups when
   cleaning up large guest memory ranges.
 * rename VLEK_REQUIRED to VCEK_DISABLE. it's be more applicable if another
   key type ever gets added.
 * don't allow attestation to be paused while an attestation request is
   being processed by firmware (Tom)
 * add missing Documentation entry for SNP_VLEK_LOAD
 * collect Reviewed-by's from Paolo and Tom

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


----------------------------------------------------------------
Ashish Kalra (1):
      KVM: SEV: Avoid WBINVD for HVA-based MMU notifications for SNP

Borislav Petkov (AMD) (3):
      [TEMP] x86/kvm/Kconfig: Have KVM_AMD_SEV select ARCH_HAS_CC_PLATFORM
      [TEMP] x86/cc: Add cc_platform_set/_clear() helpers
      [TEMP] x86/CPU/AMD: Track SNP host status with cc_platform_*()

Brijesh Singh (10):
      KVM: SEV: Add GHCB handling for Hypervisor Feature Support requests
      KVM: SEV: Add KVM_SEV_SNP_LAUNCH_START command
      KVM: SEV: Add KVM_SEV_SNP_LAUNCH_UPDATE command
      KVM: SEV: Add KVM_SEV_SNP_LAUNCH_FINISH command
      KVM: SEV: Add support to handle GHCB GPA register VMGEXIT
      KVM: SEV: Add support to handle MSR based Page State Change VMGEXIT
      KVM: SEV: Add support to handle Page State Change VMGEXIT
      KVM: SEV: Add support to handle RMP nested page faults
      KVM: SVM: Add module parameter to enable SEV-SNP
      KVM: SEV: Provide support for SNP_GUEST_REQUEST NAE event

Michael Roth (10):
      KVM: guest_memfd: Fix PTR_ERR() handling in __kvm_gmem_get_pfn()
      KVM: SEV: Select KVM_GENERIC_PRIVATE_MEM when CONFIG_KVM_AMD_SEV=y
      KVM: SEV: Add initial SEV-SNP support
      KVM: SEV: Add support for GHCB-based termination requests
      KVM: SEV: Implement gmem hook for initializing private pages
      KVM: SEV: Implement gmem hook for invalidating private pages
      KVM: x86: Implement gmem hook for determining max NPT mapping level
      crypto: ccp: Add the SNP_VLEK_LOAD command
      crypto: ccp: Add the SNP_{PAUSE,RESUME}_ATTESTATION commands
      KVM: SEV: Provide support for SNP_EXTENDED_GUEST_REQUEST NAE event

Tom Lendacky (2):
      KVM: SEV: Add support to handle AP reset MSR protocol
      KVM: SEV: Support SEV-SNP AP Creation NAE event

 Documentation/virt/coco/sev-guest.rst              |   69 +-
 Documentation/virt/kvm/api.rst                     |   73 +
 .../virt/kvm/x86/amd-memory-encryption.rst         |   88 +-
 arch/x86/coco/core.c                               |   52 +
 arch/x86/include/asm/kvm_host.h                    |    2 +
 arch/x86/include/asm/sev-common.h                  |   22 +-
 arch/x86/include/asm/sev.h                         |   19 +-
 arch/x86/include/asm/svm.h                         |    9 +-
 arch/x86/include/uapi/asm/kvm.h                    |   39 +
 arch/x86/kernel/cpu/amd.c                          |   38 +-
 arch/x86/kernel/cpu/mtrr/generic.c                 |    2 +-
 arch/x86/kernel/sev.c                              |   10 -
 arch/x86/kvm/Kconfig                               |    4 +
 arch/x86/kvm/mmu.h                                 |    2 -
 arch/x86/kvm/mmu/mmu.c                             |    1 +
 arch/x86/kvm/svm/sev.c                             | 1444 +++++++++++++++++++-
 arch/x86/kvm/svm/svm.c                             |   39 +-
 arch/x86/kvm/svm/svm.h                             |   50 +
 arch/x86/kvm/trace.h                               |   31 +
 arch/x86/kvm/x86.c                                 |   19 +-
 arch/x86/virt/svm/sev.c                            |  106 +-
 drivers/crypto/ccp/sev-dev.c                       |   85 +-
 drivers/iommu/amd/init.c                           |    4 +-
 include/linux/cc_platform.h                        |   12 +
 include/linux/psp-sev.h                            |    4 +-
 include/uapi/linux/kvm.h                           |   28 +
 include/uapi/linux/psp-sev.h                       |   39 +
 include/uapi/linux/sev-guest.h                     |    9 +
 virt/kvm/guest_memfd.c                             |    8 +-
 29 files changed, 2229 insertions(+), 79 deletions(-)



