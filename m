Return-Path: <kvm+bounces-12221-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E203F880D46
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 09:42:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 96183281BF3
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 08:42:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE0D9381DA;
	Wed, 20 Mar 2024 08:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="tCr39Dp4"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2064.outbound.protection.outlook.com [40.107.237.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2803F22079
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 08:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710924123; cv=fail; b=XAbtX45m965dmhKMHQZhQTeH7q6IjsLXGGPe5t5MPz39zkMWxKYKVki90ISpSpL3rTMhNy66rkbwsfEZnPqQ0O7E//UbjSDydYXXM+yyG0WG+fx2eJ++NLHLEdsenPUwrz0WDI0Cnz8z0xZvPUdoOiS1deRDw0kqo6Y/sqmMfGw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710924123; c=relaxed/simple;
	bh=et2PJPRoHYtjOtjkbRZAOeI2o+eO966WYhXKF8B0ss8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=E7TQSWIit1w2HotQG4liqs+AshkbmSV0/NhuqC6c64FteSXJbFI31MHb0vC4Y/7F1ou/9m2znbiJd9R9IL3JdUWFQHmscvbm9JMIGIT8P7ZXYsIamCGKFV1WW3JCDEXPHmXXwQpeiZqcrJe2lxTIASynKDjFMVAtIkBfHXvve8w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=tCr39Dp4; arc=fail smtp.client-ip=40.107.237.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=chYSWaOpw9japs2eM2flOUGTyQNYMNMdSfEr55Q98edV8HVafLsdEI6WHyx8lSEgsf4BPUj0ko44e/ybfjbvTUp5i7EOo/1gu64CxQ7mZxVfKdrdF2ZFzx5oXJuUO0+TB2nLJCN1VHxuwyzgtB3SCgBSN5mk65zuSBy3w7RQ11gj39BC2qt3/dsjbhv24DfxeUzX33YkeAhJoBaF/10eCgIBrUEKVmP27UpyOjElPWuSNxVs2sPSOd11lHhMrM2ArXikTgCcMBQ3xtVGZ018Pt/x4PJA2KnD9PR3ksJtdWZZn07JjMGlGPMQpftRR/WzAUcXvjkXzxBlAtMFoKdbYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=flMN7/q3dSZcTGdRyI0p7xeMsi6+5+bZ/uQ4y2QJSPQ=;
 b=j/SVZEXPMByr6DWPDpPoXQahISXTgjr6IhCvFGjPKDncRYd1LtweJXG2QA+Oo6T/hl8JZaEyPqZl14seWVt5xAGES5vHRgPQKZW1FwQ0lV8ri0xFz+NPMY+kVZNo5XKMwZX/rsKVbPHBq+LulL/iz2xkXIR4TREyOZl/2SaYaT7cU8vdplXX2AxaAwSjjtKu97HVo9RE0GOQXrzmwV/pCZiPoDiul7lEfxBNR/uXZ2+UQXNSD1UI3bCkhFnMqCI3PraiAO7hwI1jK3n/p1CFpCc/JYtsYNr+I6TfaH9qsaxfHTxPYWqZYb7N7auWAqW22007BPeE2LgysEo4UIC4Zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=flMN7/q3dSZcTGdRyI0p7xeMsi6+5+bZ/uQ4y2QJSPQ=;
 b=tCr39Dp4/hdxfGsEdoeABrJUho3HUlZmJyNNa30dU7sWeL+N1+8fYjJm5qeLtFMOqbvld8JB14/0Y6J7pOhBskSB9qBoPwBhu4N/cKJR3wJPUvdorjoc40DiVu/aGI4jBtNYg4CTXEwg6POqr5HVzV/DgIx7ALffrhUi5UMQKak=
Received: from PR0P264CA0092.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:18::32)
 by PH8PR12MB6746.namprd12.prod.outlook.com (2603:10b6:510:1c1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.30; Wed, 20 Mar
 2024 08:41:54 +0000
Received: from SN1PEPF0002529D.namprd05.prod.outlook.com
 (2603:10a6:100:18:cafe::b0) by PR0P264CA0092.outlook.office365.com
 (2603:10a6:100:18::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.27 via Frontend
 Transport; Wed, 20 Mar 2024 08:41:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002529D.mail.protection.outlook.com (10.167.242.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Wed, 20 Mar 2024 08:41:53 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 20 Mar
 2024 03:41:49 -0500
From: Michael Roth <michael.roth@amd.com>
To: <qemu-devel@nongnu.org>
CC: <kvm@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?=
	<berrange@redhat.com>, Markus Armbruster <armbru@redhat.com>, Pankaj Gupta
	<pankaj.gupta@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata
	<isaku.yamahata@linux.intel.com>
Subject: [PATCH RFC v3 00/49] Add AMD Secure Nested Paging (SEV-SNP) support
Date: Wed, 20 Mar 2024 03:38:56 -0500
Message-ID: <20240320083945.991426-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002529D:EE_|PH8PR12MB6746:EE_
X-MS-Office365-Filtering-Correlation-Id: e5702797-a8ca-4a5a-5b17-08dc48b9980b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	alD421uBZvSYXR3z8ruKMQbAO+UnzRNlmdTBVkBc5UOclMMKm/apGnMNNwiqptAzIeX4hu8xziO3NixEZvFL0R5H7eL6MLHZfYwsszcbXDyio/l/7eEdIjn5wD9lw8a6/h3bTz+9zwBEO/WjSXTA8qhkEilUSIZ94uP+M5nJIsy0VQRLoTViEsdvwlDlqZkxikueSTOvQnJoKTXdEmNKUF8YHoomKThPCZ9VG/vTgun21UqgUMXZmnunRiEOEC+xB02IWnhwyRxy/TU3cl1hFBOwinPU/v0b3tGttG5cNB4PemIvLE+rSgQpAHfXe+nznD6grtEupU8e9zgxcnPuis8+dpe5JWNd1rpJlMNzR2B+Nnyg6UaVKN0+cTbYVOJrVqKWzNUcc2Raq1QRghMWYrTmko/zjveQo1Wb/Q85VntSd8oR2XoC5veuk62EJXY3wIWYw7UZh87tyLOP9zY+/XPWnJaA2/UYxsQ0fXuVOPXfs9UTGY51C3og+VcwYsFdFIRx5gXT/NjatW3+Yw3lHdknjkXe7XSwTYAOTp15lgZO8vVKvm2P2dMAUMRimnnWJHXmfv0jUE/MhFhdjddWsgS8TsWCePZ5Q6ECMxbK/lyHYmCwBvzJ0okZfAW06Td0AQmSVzRmhLIWxq7+Zj4fen2lYt1SQI867IVAzYF9KobJPHAfvJQD48BJpk5vvNcJk7aGui9NV2a6Ye1xB4+5FQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(376005)(82310400014)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 08:41:53.6173
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e5702797-a8ca-4a5a-5b17-08dc48b9980b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002529D.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6746

These patches implement SEV-SNP base support along with CPUID enforcement
support for QEMU, and are also available at:

  https://github.com/amdese/qemu/commits/snp-v3-rfc

they are based on top of the following patchset from Paolo:

  "[PATCH 0/7] target/i386: VM type infrastructure and KVM_SEV_INIT2 support"
  https://lists.gnu.org/archive/html/qemu-devel/2024-03/msg04663.html


Patch Layout
------------

01-05: Various changes needed to handle new header files in kvm-next tree
       and some hacks to get a functional header sync in place for building
       this series.
06-18: These are patches directly plucked from Xiaoyao's TDX v5 patchset[1]
       that implement common dependencies between SNP/TDX like base
       guest_memfd, KVM_EXIT_MEMORY_FAULT handling (with a small FIXUP), and
       mechanisms to disable SMM. We would've also needed some of the basic
       infrastructure for handling specifying VM types for KVM_CREATE, but
       much of that is now part of the sevinit2 series this patchset is based
       on. Ideally all these patches, once stable, could be maintained in a
       common tree so that future SNP/TDX patchsets can be more easily
       iterated on/reviewed.
19-20: Patches introduced by this series that are  possible candidate for a
       common tree.
       shared/private pages when things like VFIO are in use.
21-32: Introduction of sev-snp-guest object and various configuration
       requirements for SNP.
33-36: Handling for various KVM_EXIT_VMGEXIT events that are handled in
       userspace.
37-49: Support for creating a cryptographic "launch" context and populating
       various OVMF metadata pages, BIOS regions, and vCPU/VMSA pages with
       the initial encrypted/measured/validated launch data prior to
       launching the SNP guest.


Testing
-------

This series has been tested against the following host kernel tree, which
is a snapshot of the latest WIP SNP hypervisor tree at the time of this
posting. It will likely not be kept up to date afterward, so please keep an
eye upstream or official AMDESE github if you are looking for the latest
some time after this posting:

  https://github.com/mdroth/linux/commits/snp-host-v12-wip40/

A patched OVMF is also needed due to upstream KVM no longer supporting MMIO
ranges that are mapped as private. It is recommended you build the AmdSevX64
variant as it provides the kernel-hashing support present in this series:

  https://github.com/mdroth/edk2/commits/apic-mmio-fix1c/

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

Any comments/feedback would be very much appreciated.

[1] https://github.com/amdese/linux
    https://github.com/amdese/amdsev/tree/snp-latest

Changes since rfc2:

- reworked on top of guest_memfd support
- added handling for various KVM_EXIT_VMGEXIT events
- various changes/considerations for PCI passthrough support
- general bugfixes/hardening/cleanups
- qapi cmdline doc fixes/rework (Dov, Markus)
- switch to qbase64_decode, more error-checking for cmdline opts (Dov)
- unset id_block_en for 0 input (Dov)
- use error_setg in snp init (Dov)
- report more info in trace_kvm_sev_init (Dov)
- rework bounds-checking for kvm_cpuid_info, rework existing checks for readability, add additional checks (Dov)
- fixups for validated_ranges handling (Dov)
- rename 'policy' field to 'snp-policy' in query-sev when sev-type is SNP

Changes since rfc1:

 - rebased onto latest master
 - drop SNP config file in favor of a new 'sev-snp-guest' object where all
   SNP-related params are passed as strings/integers via command-line
 - report specific error if BIOS reports invalid address/len for
   reserved/pre-validated regions (Connor)
 - use Range helpers for handling validated region overlaps (Dave)
 - simplify error handling in sev_snp_launch_start, and report the correct
   return code when handling LAUNCH_START failures (Dov)
 - add SEV-SNP bit to CPUID 0x8000001f when SNP enabled
 - updated query-sev to handle differences between SEV and SEV-SNP
 - updated to work against v5 of SEV-SNP host kernel / hypervisor patches

----------------------------------------------------------------
Brijesh Singh (5):
      i386/sev: Introduce 'sev-snp-guest' object
      i386/sev: Add the SNP launch start context
      i386/sev: Add handling to encrypt/finalize guest launch data
      hw/i386/sev: Add function to get SEV metadata from OVMF header
      i386/sev: Add support for populating OVMF metadata pages

Chao Peng (2):
      kvm: Enable KVM_SET_USER_MEMORY_REGION2 for memslot
      kvm: handle KVM_EXIT_MEMORY_FAULT

Dov Murik (4):
      qapi, i386: Move kernel-hashes to SevCommonProperties
      i386/sev: Extract build_kernel_loader_hashes
      i386/sev: Reorder struct declarations
      i386/sev: Allow measured direct kernel boot on SNP

Isaku Yamahata (2):
      pci-host/q35: Move PAM initialization above SMRAM initialization
      q35: Introduce smm_ranges property for q35-pci-host

Michael Roth (30):
      Revert "linux-headers hack" from sevinit2 base tree
      scripts/update-linux-headers: Add setup_data.h to import list
      scripts/update-linux-headers: Add bits.h to file imports
      [HACK] linux-headers: Update headers for 6.8 + kvm-coco-queue + SNP
      [TEMP] hw/i386: Remove redeclaration of struct setup_data
      RAMBlock: Add support of KVM private guest memfd
      [FIXUP] "kvm: handle KVM_EXIT_MEMORY_FAULT": drop qemu_host_page_size
      trace/kvm: Add trace for page convertion between shared and private
      kvm: Make kvm_convert_memory() obey ram_block_discard_is_enabled()
      trace/kvm: Add trace for KVM_EXIT_MEMORY_FAULT
      i386/sev: Introduce "sev-common" type to encapsulate common SEV state
      i386/sev: Add a sev_snp_enabled() helper
      target/i386: Add handling for KVM_X86_SNP_VM VM type
      i386/sev: Skip RAMBlock notifiers for SNP
      i386/sev: Skip machine-init-done notifiers for SNP
      i386/sev: Set ms->require_guest_memfd for SNP
      i386/sev: Disable SMM for SNP
      i386/sev: Don't disable block discarding for SNP
      i386/cpu: Set SEV-SNP CPUID bit when SNP enabled
      i386/sev: Update query-sev QAPI format to handle SEV-SNP
      i386/sev: Don't return launch measurements for SEV-SNP guests
      kvm: Make kvm_convert_memory() non-static
      i386/sev: Add KVM_EXIT_VMGEXIT handling for Page State Changes
      i386/sev: Add KVM_EXIT_VMGEXIT handling for Page State Changes (MSR-based)
      i386/sev: Add KVM_EXIT_VMGEXIT handling for Extended Guest Requests
      i386/sev: Set CPU state to protected once SNP guest payload is finalized
      i386/sev: Add support for SNP CPUID validation
      hw/i386/sev: Add support to encrypt BIOS when SEV-SNP is enabled
      hw/i386/sev: Use guest_memfd for legacy ROMs
      hw/i386: Add support for loading BIOS using guest_memfd

Xiaoyao Li (6):
      HostMem: Add mechanism to opt in kvm guest memfd via MachineState
      trace/kvm: Split address space and slot id in trace_kvm_set_user_memory()
      kvm: Introduce support for memory_attributes
      physmem: Introduce ram_block_discard_guest_memfd_range()
      kvm/memory: Make memory type private by default if it has guest memfd backend
      memory: Introduce memory_region_init_ram_guest_memfd()

 accel/kvm/kvm-all.c                                |  241 ++-
 accel/kvm/trace-events                             |    4 +-
 accel/stubs/kvm-stub.c                             |    5 +
 backends/hostmem-file.c                            |    1 +
 backends/hostmem-memfd.c                           |    1 +
 backends/hostmem-ram.c                             |    1 +
 backends/hostmem.c                                 |    1 +
 docs/system/i386/amd-memory-encryption.rst         |   78 +-
 hw/core/machine.c                                  |    5 +
 hw/i386/pc.c                                       |   13 +-
 hw/i386/pc_q35.c                                   |    2 +
 hw/i386/pc_sysfw.c                                 |   25 +-
 hw/i386/pc_sysfw_ovmf.c                            |   33 +
 hw/i386/x86.c                                      |   46 +-
 hw/pci-host/q35.c                                  |   61 +-
 include/exec/cpu-common.h                          |    2 +
 include/exec/memory.h                              |   26 +-
 include/exec/ram_addr.h                            |    2 +-
 include/exec/ramblock.h                            |    1 +
 include/hw/boards.h                                |    2 +
 include/hw/i386/pc.h                               |   31 +-
 include/hw/i386/x86.h                              |    2 +-
 include/hw/pci-host/q35.h                          |    1 +
 include/standard-headers/asm-x86/bootparam.h       |   17 +-
 include/standard-headers/asm-x86/kvm_para.h        |    3 +-
 include/standard-headers/linux/ethtool.h           |   48 +
 include/standard-headers/linux/fuse.h              |   39 +-
 include/standard-headers/linux/input-event-codes.h |    1 +
 include/standard-headers/linux/virtio_gpu.h        |    2 +
 include/standard-headers/linux/virtio_snd.h        |  154 ++
 include/sysemu/hostmem.h                           |    1 +
 include/sysemu/kvm.h                               |    7 +
 include/sysemu/kvm_int.h                           |    2 +
 linux-headers/asm-arm64/kvm.h                      |   15 +-
 linux-headers/asm-arm64/sve_context.h              |   11 +
 linux-headers/asm-generic/bitsperlong.h            |    4 +
 linux-headers/asm-loongarch/kvm.h                  |    2 -
 linux-headers/asm-mips/kvm.h                       |    2 -
 linux-headers/asm-powerpc/kvm.h                    |   45 +-
 linux-headers/asm-riscv/kvm.h                      |    3 +-
 linux-headers/asm-s390/kvm.h                       |  315 +++-
 linux-headers/asm-x86/kvm.h                        |  372 ++++-
 linux-headers/asm-x86/setup_data.h                 |   83 +
 linux-headers/linux/bits.h                         |   15 +
 linux-headers/linux/kvm.h                          |  719 +--------
 linux-headers/linux/psp-sev.h                      |   71 +
 qapi/misc-target.json                              |   71 +-
 qapi/qom.json                                      |   96 +-
 scripts/update-linux-headers.sh                    |    5 +-
 system/memory.c                                    |   30 +
 system/physmem.c                                   |   47 +-
 target/i386/cpu.c                                  |    1 +
 target/i386/kvm/kvm.c                              |    4 +
 target/i386/sev-sysemu-stub.c                      |    2 +-
 target/i386/sev.c                                  | 1631 ++++++++++++++++----
 target/i386/sev.h                                  |   13 +-
 target/i386/trace-events                           |    3 +
 57 files changed, 3272 insertions(+), 1146 deletions(-)
 create mode 100644 linux-headers/asm-x86/setup_data.h
 create mode 100644 linux-headers/linux/bits.h



