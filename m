Return-Path: <kvm+bounces-15428-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 238608AC070
	for <lists+kvm@lfdr.de>; Sun, 21 Apr 2024 20:04:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 90AC41F210F6
	for <lists+kvm@lfdr.de>; Sun, 21 Apr 2024 18:04:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C74823BBE3;
	Sun, 21 Apr 2024 18:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4IYqzs4B"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2085.outbound.protection.outlook.com [40.107.220.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 244DF3AC34;
	Sun, 21 Apr 2024 18:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713722650; cv=fail; b=cg46BI9xM7FiNYRiTV9dKJ/8JT402TVOa5ZniJZTs5Sgt9zezdjfahxPUWcGFLeepwwzKYzB/05FFtbDkd3x59cPTFxswLGCkByBYUuHyecWozn1pQTLrzF79HGROfW1aYGIQ02CNRnV5gX9Pbt+LLew8ZgIlDrQESJJPc3b8GU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713722650; c=relaxed/simple;
	bh=wmWrFX6BbcCTB3sxNjf36voLYu/jjORwbtrjU6CmqG0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=cjkvrhHKSqt5UjoSR1CNgKpNtzEnm3uHhF7l2ImlOqTzyoHMoPbleRNC/03WqOBhJ5Y7PwBJSP0F4tpuUtAYUVXqS7VU6JiIp3vyZX5FanNjfLFMzisOdtM1mSv1OcCPIx5YniHYocF7kM2GNcviJ0vgmPVwV703ZozyCQ4ejSY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4IYqzs4B; arc=fail smtp.client-ip=40.107.220.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oF1aYYGpQDxWTxMz3I9VWM2b+dLcrVcV3UP9Axh6vdLOD7b+XNV/M/O4jXQ/kR9PyXbq9UiORi9UxiNJ7kZL3uK/Yq3Mmt+htFnuQLyzXpFGllvRssme3xfUqqGrZ+lksm6M09kr7zDHThW2TKodcCYvf9Wi20XolQqVbOM695+4LP7rD7z4w6wmYdlgXl2+F2lJKeki1fcCIkfwBy52EFvFnIESj4IWfz9ih5RYnY4dpM5WkaTovX8hzegm164l2BaJsqyDw63KyGYaoeLllIIJu5pe0rieZ36ZdV6ocgmYqn6t5/Txjv4dBgKSbSV0h/G5jCZhXd2kN19B3fW8Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IuujAtDVbUa+N3+9ahDzXugZQ28JCmpW1NoSSp1apTI=;
 b=BZJwQnRo/AaONdMWxVz5IZVY4Zc2/iRooB1PXQr5AGWURjIav8m9ua48uE7lWZwh5Mme8gId30COruAq0/b02nICTPCrPt0r+F5jBJ7sVQPVjyOIYenoTjEY2XA/WAR5ZUYYT9sZP7eCOPdqe73NMJPR8KxX9HC8zlIbcElNxOi48C9SILhySWNm93NiM2WzXzEQYaLSYhibIZ9bKuoQR7cL/R/DcxiaFsDtIqkKO1jV6T2WZVxatUHZ1j9za1o3/LzmrAKlGGZTZHNvxKxwdBQIfZLUBf9tB47/28ixc6e2UBMlpQHHXbStLxX/ahwYuUma2Hd0LwEg8fMbrtVw9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IuujAtDVbUa+N3+9ahDzXugZQ28JCmpW1NoSSp1apTI=;
 b=4IYqzs4BOnOWjBE7GTS9HqBeXuOw7UVEmgL659dZ/Iw1a+mszYGm9a2+X/zm6K9B0fFc6nPAgkQMKMB6a7Oqy3Z0QOKyScDk48JXFkiPmQzdzUr9jJCgikAbXPrgGLkroLVWSYnQ1jtUADTuI68nx0lWyUiBJ3ygSzoz+qb3cbE=
Received: from BL1PR13CA0094.namprd13.prod.outlook.com (2603:10b6:208:2b9::9)
 by IA0PR12MB8352.namprd12.prod.outlook.com (2603:10b6:208:3dd::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Sun, 21 Apr
 2024 18:04:04 +0000
Received: from MN1PEPF0000ECDB.namprd02.prod.outlook.com
 (2603:10b6:208:2b9:cafe::1a) by BL1PR13CA0094.outlook.office365.com
 (2603:10b6:208:2b9::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.20 via Frontend
 Transport; Sun, 21 Apr 2024 18:04:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000ECDB.mail.protection.outlook.com (10.167.242.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7519.19 via Frontend Transport; Sun, 21 Apr 2024 18:04:04 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Sun, 21 Apr
 2024 13:04:04 -0500
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
Subject: [PATCH v14 00/22] Add AMD Secure Nested Paging (SEV-SNP) Hypervisor Support
Date: Sun, 21 Apr 2024 13:01:00 -0500
Message-ID: <20240421180122.1650812-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECDB:EE_|IA0PR12MB8352:EE_
X-MS-Office365-Filtering-Correlation-Id: f27a584a-0810-4495-2e8e-08dc622d6e83
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IyriSh++16kr/PtMMqPNapouefGjBjzvxBIBDAAyE3nNETHyKIfIn5Itd4Gq?=
 =?us-ascii?Q?UqOz5XJPYhmdPP3TU5NG3M13ceZO0YPyWoXtlEgQcCbR1OZNlXSspJykuftr?=
 =?us-ascii?Q?y1aGbotnHmvUCXacZeV67osp1dwSOhQ0NAZnRECFjCxy4ZUhVQBDfeLWu12O?=
 =?us-ascii?Q?MPmk4dGB7eJoJY88mZ6jF5jNIytZjDNX/8MC3nSv81w4VTBs1f0PvaCYR8s+?=
 =?us-ascii?Q?c2jsjRLAo0sm4eiEeYbQiX6V3BO8bi5JxlbQ3HYOltaHVAr2219cibJgqG6r?=
 =?us-ascii?Q?s0hsN6Wsdo4h2Ri+CFh3TA8ECfCtakaDItVSAd98Tq5t6KE+3EDWz2w84Lhz?=
 =?us-ascii?Q?oKfkx0djHEaxB1MMMk98RdiYoSIAdQQA80QktjKd7LycHoQgCvnCwoiw0eVm?=
 =?us-ascii?Q?dt1ooldt68zt5if8qlMvRp06uR7fXxsc/HZYDUWzNg/wr1WQUihyPnqLDSX1?=
 =?us-ascii?Q?sJy9kbmUUoqqYZhoP1wkpVe/r+j9vXhBrp2uAieqjmGbU3Kwl/SwyRjMcy7K?=
 =?us-ascii?Q?EOfZbjZtEP+yHx8HMx9thgyiwo064Jk0xRYmoFSOwzUNS2Ou7B+okYnNha1Q?=
 =?us-ascii?Q?c+rfdLA1AJrw3wrHBbp8vl4bxFD5QOOQXS+OB6+QHG40PbqKfi0wNuDqsrDz?=
 =?us-ascii?Q?39RAs90YCZgKuWduTFnuAPWi3MIPqmONwP5kBCRojftfxdzybpGUOjW339md?=
 =?us-ascii?Q?3apSwW7MLr2zXtghJ9UGfP8eA5qQNzCMaovGLlB2FzuA6Lq3yVaaoP1wBuXb?=
 =?us-ascii?Q?RDbbe5lEnuJwSg7q3Pfn0eziLSkF2A1dT7ejTFsMzG6Aev8+E9uJziCnvOHN?=
 =?us-ascii?Q?cupVgLNWjLGiLAb9wc92dhQfCqHjtqU40n/KP8JB2BAwMZrajAM5fP1y6Kyu?=
 =?us-ascii?Q?uvnd/ageDUnUiNpoLrnYOlugBxS0BQ+EXjYPDYXL26tWYIfAaOPbuMcxPtpw?=
 =?us-ascii?Q?GXE/2pvJ3Y6SjkNKQOK8PhUdbw5t2goLzz1ed/7kJw2MHThk81PEjj7F1kS9?=
 =?us-ascii?Q?9KjWrHKaA86ItTl4Z8C3ePyhuqbFD0xVSvQX+dYBC0q2q6fWzCZLNzIjo+qK?=
 =?us-ascii?Q?Ws4FMQHam/9qJGE6s5HvYr/pHpQDBSVf7CwLy0GDZW4vj5lw8Kra3fnM+WuI?=
 =?us-ascii?Q?p9Ogzxib9v+PVheEt3JtVj2kV0cgA0Br3+pZ7l5jESGRCXvESxMJdCREiTRK?=
 =?us-ascii?Q?eAjReFJDG0Zdtfd4s1i1Hv1tmQRnz5iwsRHsv4A4DgsjNMHKxlbUR2zuUq/6?=
 =?us-ascii?Q?2K2fOmALE6oytFPV5E91YidRChJFhbqDXQ3q+AGKoaGmNSJVXogZquheAq+0?=
 =?us-ascii?Q?9fuhS82OAfi3+RsmbFcn+7XSdSfG2o+75dvQUmjylnDmA0tfPwmYj9izgJTw?=
 =?us-ascii?Q?QrlOhi7GMI0VIqFGXkzCe4YE0tlm?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(376005)(36860700004)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2024 18:04:04.6440
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f27a584a-0810-4495-2e8e-08dc622d6e83
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECDB.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8352

This patchset is also available at:

  https://github.com/amdese/linux/commits/snp-host-v14

and is based on commit 20cc50a0410f (just before the v13 SNP patches) from:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git/log/?h=kvm-coco-queue


Patch Layout
------------

01-04: These patches add some basic infrastructure and introduces a new
       KVM_X86_SNP_VM vm_type to handle differences verses the existing
       KVM_X86_SEV_VM and KVM_X86_SEV_ES_VM types.

05-07: These implement the KVM API to handle the creation of a
       cryptographic launch context, encrypt/measure the initial image
       into guest memory, and finalize it before launching it.

08-13: These implement handling for various guest-generated events such
       as page state changes, onlining of additional vCPUs, etc.

14-17: These implement the gmem hooks needed to prepare gmem-allocated
       pages before mapping them into guest private memory ranges as
       well as cleaning them up prior to returning them to the host for
       use as normal memory. Because this supplants certain activities
       like issued WBINVDs during KVM MMU invalidations, there's also
       a patch to avoid duplicating that work to avoid unecessary
       overhead.

18:    With all the core support in place, the patch adds a kvm_amd module
       parameter to enable SNP support.

19-22: These patches all deal with the servicing of guest requests to handle
       things like attestation, as well as some related host-management
       interfaces.


Testing
-------

For testing this via QEMU, use the following tree:

  https://github.com/amdese/qemu/commits/snp-v4-wip3b

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


Changes since v13:

 * rebase to new kvm-coco-queue and wire up to PFERR_PRIVATE_ACCESS (Paolo)
 * handle setting kvm->arch.has_private_mem in same location as
   kvm->arch.has_protected_state (Paolo)
 * add flags and additional padding fields to
   snp_launch{start,update,finish} APIs to address alignment and
   expandability (Paolo)
 * update snp_launch_update() to update input struct values to reflect
   current progress of command in situations where mulitple calls are
   needed (Paolo)
 * update snp_launch_update() to avoid copying/accessing 'src' parameter
   when dealing with zero pages. (Paolo)
 * update snp_launch_update() to use u64 as length input parameter instead
   of u32 and adjust padding accordingly
 * modify ordering of SNP_POLICY_MASK_* definitions to be consistent with
   bit order of corresponding flags
 * let firmware handle enforcement of policy bits corresponding to
   user-specified minimum API version
 * add missing "0x" prefixs in pr_debug()'s for snp_launch_start()
 * fix handling of VMSAs during in-place migration (Paolo)

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

Brijesh Singh (11):
      KVM: SEV: Add GHCB handling for Hypervisor Feature Support requests
      KVM: SEV: Add initial SEV-SNP support
      KVM: SEV: Add KVM_SEV_SNP_LAUNCH_START command
      KVM: SEV: Add KVM_SEV_SNP_LAUNCH_UPDATE command
      KVM: SEV: Add KVM_SEV_SNP_LAUNCH_FINISH command
      KVM: SEV: Add support to handle GHCB GPA register VMGEXIT
      KVM: SEV: Add support to handle MSR based Page State Change VMGEXIT
      KVM: SEV: Add support to handle Page State Change VMGEXIT
      KVM: SEV: Add support to handle RMP nested page faults
      KVM: SVM: Add module parameter to enable SEV-SNP
      KVM: SEV: Provide support for SNP_GUEST_REQUEST NAE event

Michael Roth (8):
      KVM: SEV: Select KVM_GENERIC_PRIVATE_MEM when CONFIG_KVM_AMD_SEV=y
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
 .../virt/kvm/x86/amd-memory-encryption.rst         |  110 +-
 arch/x86/include/asm/kvm_host.h                    |    2 +
 arch/x86/include/asm/sev-common.h                  |   22 +-
 arch/x86/include/asm/sev.h                         |   15 +
 arch/x86/include/asm/svm.h                         |    9 +-
 arch/x86/include/uapi/asm/kvm.h                    |   48 +
 arch/x86/kvm/Kconfig                               |    3 +
 arch/x86/kvm/mmu.h                                 |    2 -
 arch/x86/kvm/mmu/mmu.c                             |    1 +
 arch/x86/kvm/svm/sev.c                             | 1447 +++++++++++++++++++-
 arch/x86/kvm/svm/svm.c                             |   44 +-
 arch/x86/kvm/svm/svm.h                             |   50 +
 arch/x86/kvm/trace.h                               |   31 +
 arch/x86/kvm/x86.c                                 |   17 +
 arch/x86/virt/svm/sev.c                            |   80 ++
 drivers/crypto/ccp/sev-dev.c                       |   83 ++
 include/linux/psp-sev.h                            |    4 +-
 include/uapi/linux/kvm.h                           |   28 +
 include/uapi/linux/psp-sev.h                       |   39 +
 include/uapi/linux/sev-guest.h                     |    9 +
 virt/kvm/guest_memfd.c                             |    4 +-
 23 files changed, 2155 insertions(+), 35 deletions(-)



