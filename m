Return-Path: <kvm+bounces-16308-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DBCC68B871C
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 11:03:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 923A3281FBF
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 09:03:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D50A502AC;
	Wed,  1 May 2024 09:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="hvLSoOs4"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2083.outbound.protection.outlook.com [40.107.94.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCEFB50282;
	Wed,  1 May 2024 09:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714554182; cv=fail; b=sZeTme97g8qhqrUEw7HdOoUmpPv1OblIkEltYgSEoMSrHs6aqfLbltstMB8mg8Jf6Gr6t5q9x2VYCLnCtYO52+7pmXs1lv/DTL8HZj/Zwuh53y2b4ZJJN0ksWryTYOB0ft2gJvErIuhYLY4AgMvitiXCekB/Fi9/9RtDnGGefrg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714554182; c=relaxed/simple;
	bh=6T0948CoDsinUaHBX9Ln3aJCoq9A73LSQ201rsDNQ8o=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=p8r/Zr5yxXhQACXWKuyvv/W0PIoy09DGrHXQpD8i0R9XtaP9GjdRfJFbLFreGPCzPWawC4AmjPhD2EQMLPBoD5re77RmRwkS68m3EaFAJSTCuHayh10pOdL7FvaLEKYJwmN7xpnOAgf+7Okx4iIhjNZuZCn5GJvrxHKqgj/yFuU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=hvLSoOs4; arc=fail smtp.client-ip=40.107.94.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AIvgcpgiO3mDnwr22yunK1/6UGg+PK9nkcOMdaMo3Z7LMUZj4rVpKOGpwjPMZiWYFIC3SzgbNwMcTzFZQAV1XCt6ZyUqY0TEaA9t7jguR5ZhnMTcfkPPkU+6o2ZTM/qD29v1H7HvGnclZ8m1sI6TUer1VOYG+FSIyqyhPKWT7RmSooyecu+jw++6qmc5wOrPx4UYu00KCQCGo14PBmnAfFNrGcTRkC/SCStgFhsgQi7nDu6MhYA3XJb0XrPP19fT5I/HOqbXNAYvbsxX33gcxcWZkijRqnw+L+4kw5MazQPx+S2+q63SUyod+ZaPyV5Vsh/FgFLAXxpB3Ol9WmCn6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fe16hLil5QsGIm7ZpgvEyhK6VexI5qxtc34CI1K3RMw=;
 b=CSOq6JJW00MJtL2PxPW5ZyxEqwsze0HWXxHA0PIF9kwG2tNpqg9K+V1MQxdB9bfHpewuGW6pD5NhFmb6SngDoXdes9dyfCDBus4c6SiSBDMb62wT42Fzi3bXI1Yv+fy4oYVxgaaW1diPJDc9nM5w2kxxJ6jHpg9bzl5i6/RTkNOyTGcV2NWLyOVxEtK7j86154L1Uvi/kES9+/4aq5pcUnjgBhJXc3CO4idslhOf3eRnE7kNH2PiDzDwqBq2qi1yQjHjI5AObItpY2Og0wgA+Wch8MCQshQPmt9EHzRpa1Mhdqf38Jq5PvwJOKsf+TX1YXkLSjupyP37kXFpAdxoTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fe16hLil5QsGIm7ZpgvEyhK6VexI5qxtc34CI1K3RMw=;
 b=hvLSoOs4uy5ZbyaHpCEGqkJJkQK3SVMOnN1ScOGosuXIKEMBpG4jbCrNtu5Zy1KZ4Hif+7xdm/uTusxPonB6F5XrHJMruA+XH3o/eOUKUmF1a8y/P3DywJcwcy+/74PzVGvGP6JQpsMzaohdBYmuqx13cXGAa415YVJfEQMh8j8=
Received: from SJ0PR05CA0160.namprd05.prod.outlook.com (2603:10b6:a03:339::15)
 by CYXPR12MB9338.namprd12.prod.outlook.com (2603:10b6:930:e5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.35; Wed, 1 May
 2024 09:02:57 +0000
Received: from CO1PEPF000044F1.namprd05.prod.outlook.com
 (2603:10b6:a03:339:cafe::f2) by SJ0PR05CA0160.outlook.office365.com
 (2603:10b6:a03:339::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.28 via Frontend
 Transport; Wed, 1 May 2024 09:02:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044F1.mail.protection.outlook.com (10.167.241.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7544.18 via Frontend Transport; Wed, 1 May 2024 09:02:57 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 1 May
 2024 04:02:56 -0500
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
Subject: [PATCH v15 00/20] Add AMD Secure Nested Paging (SEV-SNP) Hypervisor Support
Date: Wed, 1 May 2024 03:51:50 -0500
Message-ID: <20240501085210.2213060-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F1:EE_|CYXPR12MB9338:EE_
X-MS-Office365-Filtering-Correlation-Id: 60325862-7cdb-4705-effb-08dc69bd7e9f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|1800799015|376005|7416005|82310400014|36860700004;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?L3XJXBURqqXAe/mzjUk18iek+0B9rqy5d8MnlfRgnyRgd/i8JOE04bIa18sB?=
 =?us-ascii?Q?65Xo2fO7cFjUOY7SYbC4nQliX3t+sEE2dTNhTpiblYM66/7QdcA/oL8tkkxB?=
 =?us-ascii?Q?PN3coYN1rwN8FOGywht8gS55hLXzO8cc5JJE6QJnfuKZl/Xh+Yn5bmn3VKzi?=
 =?us-ascii?Q?sCt6zC0cUuBH3p8/AQ7fX88hmFPLHB3EDKRSxjoXOHwYU2Ln668yZpAIKwRl?=
 =?us-ascii?Q?RwTZ8u7Xa/c+G4kRB4Z/2J9wvFktu22OefPpUEexoKeukYljInTphoji4M7/?=
 =?us-ascii?Q?7fHa9XAodSjHrkuTpzQ+ZR5Bm0o1t1Ph+sMFu0I33EbeupPMHtZNOkxQcBTv?=
 =?us-ascii?Q?akI0K7bTDSkI2HnJbUDQAXg7bvDQOIebX71Mh/teSVPixYwABOOiikEbXVKD?=
 =?us-ascii?Q?LcqG7CEhUfuffcp+8kUF6Piy6HqcT/mSB/SD1ju6rLqfLZgT7Q7gt9fBFsGH?=
 =?us-ascii?Q?fnlAlLbIjtnKRp0ht40q3LsL8XDcIcuZrcMbrTZaoxY1IctezioVHcFUy4cL?=
 =?us-ascii?Q?QF5vFl+I+g9zPVBukHAiuO1a8EXLjqrrRO1JT7okd5HIeZqvxHpMm8Cy1yW0?=
 =?us-ascii?Q?mJKJhSFN/RRub36Tf3glSc5Kd+xw02xxgdAl5nmmZSqCWVXIqjxV6n/auNyi?=
 =?us-ascii?Q?6kqjkpq7IC9UkKC/56mCCwUSqew4TxKSjSd0HJeKC/8/F0cqD5CMwC1GxOAQ?=
 =?us-ascii?Q?82wRinKKFjib7PQDl/DrzetpVOQdeiVj8thF4IyuTa/MV4OFIdg3ANWnOk8Q?=
 =?us-ascii?Q?eERBQQ9OC/AkwkxjkTNxF3ASZiIBBrMamzpCRyoWefnX9HnSbKmayWvpG/xA?=
 =?us-ascii?Q?pV/zCjk+IGGsNBXgBQusLnpZ9sANTpSXYqlFlbEtal5uT+eCfEOLOIqQHyHZ?=
 =?us-ascii?Q?s1LlauBTvvZg4Hr3grdXYDxisJC7kuZYFT4w+SsKE++jD5/5hmcdY27GPp3B?=
 =?us-ascii?Q?5ffnCMF1J5LedFFDyV6LxACD0IZFNZPqUeGhaw3yPCmCnUXbqU/LRhHdGJBe?=
 =?us-ascii?Q?NDWBRBHLzdumUL4vudPejc3ZhSLlly4p7riXVmmwov8V+bppV7rlyiVZpY8H?=
 =?us-ascii?Q?LkypDxmhccSLB4tAaJBcoFwzRjk9Ijw5D7yrn+RvrMe8n90MnBYVtmWV1ge5?=
 =?us-ascii?Q?Zg15gcFo0WOifdfP+lAdmYgsp/ssG7tLkcZsM9etlaR+YBYH+8P+/8T7gPZ7?=
 =?us-ascii?Q?KzoAYnKYbd3aVurndhNtovXAtiegBGgg34usKhiPNGmG0Q/QjpD3b1njw0df?=
 =?us-ascii?Q?9Er7kYlcK1x2KcYrHO65lhujQPFVQ8flepVhw+naotUZeYaGO8IFoTjU0NLk?=
 =?us-ascii?Q?0VXIKZ/uB5CJ7pMWiTNhyFmiNwF2Z7BP1sSgVrCAypPePw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(376005)(7416005)(82310400014)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2024 09:02:57.2351
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 60325862-7cdb-4705-effb-08dc69bd7e9f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR12MB9338

This patchset is also available at:

  https://github.com/amdese/linux/commits/snp-host-v15

and is based on top of the series:
  
  "Add SEV-ES hypervisor support for GHCB protocol version 2"
  https://lore.kernel.org/kvm/20240501071048.2208265-1-michael.roth@amd.com/
  https://github.com/amdese/linux/commits/sev-init2-ghcb-v1

which in turn is based on commit 20cc50a0410f (just before v14 SNP patches):

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git/log/?h=kvm-coco-queue


Patch Layout
------------

01-02: These patches revert+replace the existing .gmem_validate_fault hook
       with a similar .private_max_mapping_level as suggested by Sean[1]

03-04: These patches add some basic infrastructure and introduces a new
       KVM_X86_SNP_VM vm_type to handle differences verses the existing
       KVM_X86_SEV_VM and KVM_X86_SEV_ES_VM types.

05-07: These implement the KVM API to handle the creation of a
       cryptographic launch context, encrypt/measure the initial image
       into guest memory, and finalize it before launching it.

08-12: These implement handling for various guest-generated events such
       as page state changes, onlining of additional vCPUs, etc.

13-16: These implement the gmem/mmu hooks needed to prepare gmem-allocated
       pages before mapping them into guest private memory ranges as
       well as cleaning them up prior to returning them to the host for
       use as normal memory. Because this supplants certain activities
       like issued WBINVDs during KVM MMU invalidations, there's also
       a patch to avoid duplicating that work to avoid unecessary
       overhead.

17:    With all the core support in place, the patch adds a kvm_amd module
       parameter to enable SNP support.

18-20: These patches all deal with the servicing of guest requests to handle
       things like attestation, as well as some related host-management
       interfaces.

[1] https://lore.kernel.org/kvm/ZimnngU7hn7sKoSc@google.com/#t


Testing
-------

For testing this via QEMU, use the following tree:

  https://github.com/amdese/qemu/commits/snp-v4-wip3c

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


Changes since v14:

 * switch to vendor-agnostic KVM_HC_MAP_GPA_RANGE exit for forwarding
   page-state change requests to userspace instead of an SNP-specific exit
   (Sean)
 * drop SNP_PAUSE_ATTESTATION/SNP_RESUME_ATTESTATION interfaces, instead
   add handling in KVM_EXIT_VMGEXIT so that VMMs can implement their own
   mechanisms for keeping userspace-supplied certificates in-sync with
   firmware's TCB/endorsement key (Sean)
 * carve out SEV-ES-specific handling for GHCB protocol 2, add control of 
   the protocol version, and post as a separate prereq patchset (Sean)
 * use more consistent error-handling in snp_launch_{start,update,finish},
   simplify logic based on review comments (Sean)
 * rename .gmem_validate_fault to .private_max_mapping_level and rework
   logic based on review suggestions (Sean)
 * reduce number of pr_debug()'s in series, avoid multiple WARN's in
   succession (Sean)
 * improve documentation and comments throughout

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


----------------------------------------------------------------
Ashish Kalra (1):
      KVM: SEV: Avoid WBINVD for HVA-based MMU notifications for SNP

Brijesh Singh (8):
      KVM: SEV: Add initial SEV-SNP support
      KVM: SEV: Add KVM_SEV_SNP_LAUNCH_START command
      KVM: SEV: Add KVM_SEV_SNP_LAUNCH_UPDATE command
      KVM: SEV: Add KVM_SEV_SNP_LAUNCH_FINISH command
      KVM: SEV: Add support to handle GHCB GPA register VMGEXIT
      KVM: SEV: Add support to handle RMP nested page faults
      KVM: SVM: Add module parameter to enable SEV-SNP
      KVM: SEV: Provide support for SNP_GUEST_REQUEST NAE event

Michael Roth (10):
      Revert "KVM: x86: Add gmem hook for determining max NPT mapping level"
      KVM: x86: Add hook for determining max NPT mapping level
      KVM: SEV: Select KVM_GENERIC_PRIVATE_MEM when CONFIG_KVM_AMD_SEV=y
      KVM: SEV: Add support to handle MSR based Page State Change VMGEXIT
      KVM: SEV: Add support to handle Page State Change VMGEXIT
      KVM: SEV: Implement gmem hook for initializing private pages
      KVM: SEV: Implement gmem hook for invalidating private pages
      KVM: x86: Implement hook for determining max NPT mapping level
      KVM: SEV: Provide support for SNP_EXTENDED_GUEST_REQUEST NAE event
      crypto: ccp: Add the SNP_VLEK_LOAD command

Tom Lendacky (1):
      KVM: SEV: Support SEV-SNP AP Creation NAE event

 Documentation/virt/coco/sev-guest.rst              |   19 +
 Documentation/virt/kvm/api.rst                     |   87 ++
 .../virt/kvm/x86/amd-memory-encryption.rst         |  110 +-
 arch/x86/include/asm/kvm-x86-ops.h                 |    2 +-
 arch/x86/include/asm/kvm_host.h                    |    5 +-
 arch/x86/include/asm/sev-common.h                  |   25 +
 arch/x86/include/asm/sev.h                         |    3 +
 arch/x86/include/asm/svm.h                         |    9 +-
 arch/x86/include/uapi/asm/kvm.h                    |   48 +
 arch/x86/kvm/Kconfig                               |    3 +
 arch/x86/kvm/mmu.h                                 |    2 -
 arch/x86/kvm/mmu/mmu.c                             |   27 +-
 arch/x86/kvm/svm/sev.c                             | 1538 +++++++++++++++++++-
 arch/x86/kvm/svm/svm.c                             |   44 +-
 arch/x86/kvm/svm/svm.h                             |   52 +
 arch/x86/kvm/trace.h                               |   31 +
 arch/x86/kvm/x86.c                                 |   17 +
 drivers/crypto/ccp/sev-dev.c                       |   36 +
 include/linux/psp-sev.h                            |    4 +-
 include/uapi/linux/kvm.h                           |   23 +
 include/uapi/linux/psp-sev.h                       |   27 +
 include/uapi/linux/sev-guest.h                     |    9 +
 virt/kvm/guest_memfd.c                             |    4 +-
 23 files changed, 2081 insertions(+), 44 deletions(-)


