Return-Path: <kvm+bounces-18389-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 16C3B8D4A22
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 13:17:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 815DE1F219DE
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 11:16:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C88B172BB6;
	Thu, 30 May 2024 11:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Zube9h/D"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2086.outbound.protection.outlook.com [40.107.244.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 187266F2F7
	for <kvm@vger.kernel.org>; Thu, 30 May 2024 11:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717067809; cv=fail; b=K24Oxk4gEpKf3i8tu9HPMMpe0gA0YJiUZWkT99RfSQEF0AaJ9Acp6GFSSXEryuSMT6iiHImPOd6M7fiwUCmt5LDRcFriGXMeIJZeS745qt6KoqGroY76HsbesLWY2R847Gbm8YmjKx6VbP2CarGhhrnLv0h4Q0kP45I0uuVuABY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717067809; c=relaxed/simple;
	bh=N8uQtSXE432WTTWg+sDrJezgpVY/TAj63wM5naCW08Q=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Gt9VGcnvkPADFUjUSRsuLK8S7HUPdWQXqE5Jx5l61pyPJtup0292sG780gWuuQDg7Ni1NJn7Dm0Orye/jOCdXk/0OtnNiIfkher615cldEt7t1bOJ2Rr3j0owYYeiQ4E/tT4w0OUYCwNWBG+KadiJNCZoARqv8D3/BJ3/Eo+KaM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Zube9h/D; arc=fail smtp.client-ip=40.107.244.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PL6XjXmkOzIyL+LMAJtNo84eUtWfm8/TzK9hox+zr6lpNZcG5T8sIPtFp7Xs8XCNascX+M7g442+OPzfcd5qbTnUitCZ8ePrbzyUOM799KZLwUPPpxwrhKiEnXHafvCMj2dod4Fk4sbnU+hwgfVE8FBBLrnGNU4osz2oLs5YNW6xg35iJK15eapJV24MrnzSEZ7ISCRzg5N82SwijPCS4PKxWET3pDzgfV8e0F79mOVgaEZ9Z4vALHiLHlI3StC5L921wUVN4VIBHuM4J/F19dQI9uWITZioEO3NQq2deniarCyFpeS67lVlywkVtW3Lj4nXyuRaauAIeYpJQP1rJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+MMb1Rjt1P7H2Hob0gs0J4ThrYXrWCJOcdW6R6BAsmw=;
 b=VROBlwMbhfLWsoxtPPCd/vZNCPhk8UKqWiPQnWMlUOYUJ4N8B7Ps+JOqlYV2udhI1JFmNjHYXZ/XM4e6eNTNIJSGTYV3kz6CL19ji3v0xoEUwiJDzpxDgVKZxs+K7MreYira6DM+M1Qi1zNu9KxSUrGayKfygq43nlXrl+Zvh7/0Lw7RRrF6LtdzG4m1Ur+Qpl+XFa5GAh5Z/XNxHSGdPRLVaU+m6H8x0zQ94xsxDRRm3ie/h8KDFiEF9zYX77vbCk8ZF2Gwt0NuVLYzaARB8xaOEAsyrp5hMIanHgcB+AH5i49P2/ogBMPuij61TTIe7gmp5ldFIBs06eScVsqyNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+MMb1Rjt1P7H2Hob0gs0J4ThrYXrWCJOcdW6R6BAsmw=;
 b=Zube9h/DFAU/c3oHPIasoyfGyENBwRD2R77aDHX6drMpGiguysNFldkld1nCDI9fZuxG4bv2c7cxioh7fAvX3eH8Ig2rzMgo8/1b3f8TqO0ZBvmlTbahUTUY7BKDYSXjH49Rz4/dqf35nln2LoojTYvGT1XaQ05idpZkoUTHtYc=
Received: from BN9PR03CA0235.namprd03.prod.outlook.com (2603:10b6:408:f8::30)
 by DS0PR12MB8018.namprd12.prod.outlook.com (2603:10b6:8:149::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.21; Thu, 30 May
 2024 11:16:45 +0000
Received: from BN3PEPF0000B075.namprd04.prod.outlook.com
 (2603:10b6:408:f8:cafe::52) by BN9PR03CA0235.outlook.office365.com
 (2603:10b6:408:f8::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.18 via Frontend
 Transport; Thu, 30 May 2024 11:16:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B075.mail.protection.outlook.com (10.167.243.120) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Thu, 30 May 2024 11:16:44 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 06:16:44 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 06:16:44 -0500
Received: from pankaj-M75q.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.35 via Frontend
 Transport; Thu, 30 May 2024 06:16:43 -0500
From: Pankaj Gupta <pankaj.gupta@amd.com>
To: <qemu-devel@nongnu.org>
CC: <brijesh.singh@amd.com>, <dovmurik@linux.ibm.com>, <armbru@redhat.com>,
	<michael.roth@amd.com>, <xiaoyao.li@intel.com>, <pbonzini@redhat.com>,
	<thomas.lendacky@amd.com>, <isaku.yamahata@intel.com>, <berrange@redhat.com>,
	<kvm@vger.kernel.org>, <anisinha@redhat.com>, <pankaj.gupta@amd.com>
Subject: [PATCH v4 00/31] Add AMD Secure Nested Paging (SEV-SNP) support
Date: Thu, 30 May 2024 06:16:12 -0500
Message-ID: <20240530111643.1091816-1-pankaj.gupta@amd.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B075:EE_|DS0PR12MB8018:EE_
X-MS-Office365-Filtering-Correlation-Id: d2ee65dc-4384-4e31-9d95-08dc8099fd60
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|82310400017|36860700004|376005|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6bx+0OohDhX2Mb6fgnL1V5i8QgE9NlXlzo9KeoLBBnbANUhjjGb6P4sRoj4h?=
 =?us-ascii?Q?8XCTLdDSKtOrLQ3LGwL0Vw1fekiqk9nCiVD7zKNlhyvOBCMEdrSZCoeIpYX/?=
 =?us-ascii?Q?doWgH9IWFeZujR2MPwYrWnotZxehMTmcANVwUO+Kv3Ex+tf6AqPLYRyhYjzz?=
 =?us-ascii?Q?jXtWBHUBzBNGTnFy8/xkTyF0sRM65Yneiy1tiaQg6k9CMkrs3VhPf1NZv2jl?=
 =?us-ascii?Q?7wUcya0hsP7vrgXqfoG50GVkmxElkMmDDmisdfxjClJFGhbSIlivi+kcr1hW?=
 =?us-ascii?Q?klkABEfz9pBsVOxBQZCW25k0UO7nn3FM+Nyhie23hohQgJ1exNu9YQpoJTsl?=
 =?us-ascii?Q?hRVd1/zDXjHoUf1k+23io7Ndl/Ty8bUlHpOcFWCIf4qELCSeD5Z1vOJ/DX62?=
 =?us-ascii?Q?6pR2cWcp1qSbDrtAzKYr6Woc2oMMyD8BGxTkXM5Wnm/a1UVZz2Mvasfi5dYl?=
 =?us-ascii?Q?OKuSyT6BymWFZ3DuAJ5FN8jN6xG34riZ0tAolXc1wflViZy4X5df5IPbRxmv?=
 =?us-ascii?Q?RsvQQEQLXZWrEE/mxDMCTVuKX+CbGJaBs2h7oOtCBBQ1ktUq6H9Cik7RFcVQ?=
 =?us-ascii?Q?4/H4K4K78Utaf6MAP3W3W7bgpDGGIDtprw8RBQj9JvmkqQnB/1ZRDtV1geD5?=
 =?us-ascii?Q?UCcw8qpapBZo7IHY/B/Vo58N4CFswwbBjaSY4u5RLb/cRGqaIx8hemipIfxu?=
 =?us-ascii?Q?hS1WfQJdm3zsZltMK9Lq8D7frH9Cf4jjh2znmxTMZTf2Bm+rS3+IenrTRcoD?=
 =?us-ascii?Q?ordqqxuIlaJ9Nd/GoILqrruh/7VMi2mbJ113LqGJDgfq4MJf3WVIdiCx5U5g?=
 =?us-ascii?Q?E6rhw2cpKudOqd9ltU3wi1ojMeoBELdZrLuZW1TGAiir+KCT6EAAP6sMTWgX?=
 =?us-ascii?Q?zbJV8Vr7jRHatoBfSM15naZXREKqroBB/MIb4Wc9tNC4UzWy/pnC+bedBFPX?=
 =?us-ascii?Q?jtj78q2dnhwSF/V8cgAA8zNYdFfQu3PojucC/H3vT1KiEwF89XEBA1jfb20A?=
 =?us-ascii?Q?pAF9sxzK1S5l09KncCfQwJUMKIo9fSnJmNkk1XU07B+XWy2WWagjMFxBFLLW?=
 =?us-ascii?Q?i1D+klPi3csj5xOVlrhgqONE1okQVk5FngCF47kkrFcg4Lb3DCbMotxJdr20?=
 =?us-ascii?Q?4JXnvpZA7FyKOHYX6tsBIFew76wRSCoRpsLkLJm1eSFqLNpfi1IM8tdTVbJi?=
 =?us-ascii?Q?fTS8xxWDgm4wIUkyq8GL44DVuU8MLEqeSrqfe2jN4CzOY3VHTi2ypAqLDObS?=
 =?us-ascii?Q?9ngeW18uGQfmL01zs7rpxKfWnBfn3BZ3jglVUrpel5b61MFQXhGRcHWueVr3?=
 =?us-ascii?Q?gYgXkKxzQXKtrtGFqfEw+NLmVdPvP2TqX8X+6mfh2P8McA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400017)(36860700004)(376005)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2024 11:16:44.8774
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d2ee65dc-4384-4e31-9d95-08dc8099fd60
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B075.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8018

These patches implement SEV-SNP base support along with CPUID enforcement
support for QEMU, and are also available at:

https://github.com/pagupta/qemu/tree/snp_v4

Latest version of kvm changes are posted here [2] and also queued in kvm/next.

Patch Layout
------------
01-03: 'error_setg' independent fix, kvm/next header sync & patch from
       Xiaoyao's TDX v5 patchset.
04-29: Introduction of sev-snp-guest object and various configuration
       requirements for SNP. Support for creating a cryptographic "launch" context
       and populating various OVMF metadata pages, BIOS regions, and vCPU/VMSA
       pages with the initial encrypted/measured/validated launch data prior to
       launching the SNP guest.
30-31: Handling for KVM_HC_MAP_GPA_RANGE hypercall for userspace VMEXIT.

Testing
-------
This series has been tested against the kvm/next tree and the
AMDSEV tree [1].

[1]  https://github.com/AMDESE/linux/commits/snp-host-latest/

Below version of OVMF is used to test the changes.

  https://github.com/mdroth/edk2/commits/apic-mmio-fix1d/

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
  -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,id-auth=,kernel-hashes=on
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
  -drive if=pflash,format=raw,unit=0,file=OVMF_VARS-upstream-20240410-apic-mmio-fix1d.fd,readonly=off:
 
 Any comments/feedback would be very much appreciated.

[2] https://lore.kernel.org/all/20240501085210.2213060-1-michael.roth@amd.com/
--------------

Changes since rfc3:

- added class methods (SEV & SNP) for functions changes suggested in RFC v3:
  launch_start(), launch_update_data(), launch_finish(), kvm_init(), kvm_type() (Paolo) 
- improved qom.json, query-sev QAPI text suggestions (Daniel & Markus).
- moved 'pc_system_parse_sev_metadata' to 'target/i386/sev.c' (Isaku).
- moved SNP specific methods (set guest_mem_fd, no smm check, no disable block discard)
  to sev_snp_kvm_init().
- squashed qapi changes for SecCommonProperties into 'sev-guest-common' patch (Daniel, Markus)
- made legacy bios support to SNP only.
- switch to using KVM_HC_MAP_GPA_RANGE to handle page-state change
  requests rather than directly processing GHCB page-state change buffer
- drop attestation certificate support, will revisit once the KVM_EXIT_*
  event mechanism is finalized
- sync headers with kvm/next, which now contains base KVM SNP support
- some more fixes including missing 'return', length checks,
  monitor logs improvements. (Daniel, Markus)


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
- rework bounds-checking for kvm_cpuid_info, rework existing checks for 
  readability, add additional checks (Dov)
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

Brijesh Singh (6):
  i386/sev: Introduce 'sev-snp-guest' object
  i386/sev: Add the SNP launch start context
  i386/sev: Add handling to encrypt/finalize guest launch data
  hw/i386/sev: Add function to get SEV metadata from OVMF header
  i386/sev: Add support for populating OVMF metadata pages
  hw/i386/sev: Add support to encrypt BIOS when SEV-SNP is enabled

Dov Murik (3):
  i386/sev: Extract build_kernel_loader_hashes
  i386/sev: Reorder struct declarations
  i386/sev: Allow measured direct kernel boot on SNP

Michael Roth (12):
  i386/sev: Introduce "sev-common" type to encapsulate common SEV state
  i386/sev: Add a sev_snp_enabled() helper
  i386/cpu: Set SEV-SNP CPUID bit when SNP enabled
  i386/sev: Don't return launch measurements for SEV-SNP guests
  i386/sev: Update query-sev QAPI format to handle SEV-SNP
  i386/sev: Set CPU state to protected once SNP guest payload is
    finalized
  i386/sev: Add support for SNP CPUID validation
  hw/i386/sev: Use guest_memfd for legacy ROMs
  hw/i386: Add support for loading BIOS using guest_memfd
  hw/i386/sev: Allow use of pflash in conjunction with -bios
  i386/kvm: Add KVM_EXIT_HYPERCALL handling for KVM_HC_MAP_GPA_RANGE
  i386/sev: Enable KVM_HC_MAP_GPA_RANGE hcall for SNP guests

Pankaj Gupta (9):
  i386/sev: Replace error_report with error_setg
  linux-headers: Update to current kvm/next
  i386/sev: Move sev_launch_update to separate class method
  i386/sev: Move sev_launch_finish to separate class method
  i386/sev: Add sev_kvm_init() override for SEV class
  i386/sev: Add snp_kvm_init() override for SNP class
  i386/sev: Add a class method to determine KVM VM type for SNP guests
  i386/sev: Invoke launch_updata_data() for SEV class
  i386/sev: Invoke launch_updata_data() for SNP class

Xiaoyao Li (1):
  memory: Introduce memory_region_init_ram_guest_memfd()

 docs/system/i386/amd-memory-encryption.rst |   70 +-
 hw/i386/pc.c                               |   14 +-
 hw/i386/pc_sysfw.c                         |   76 +-
 hw/i386/x86-common.c                       |   24 +-
 include/exec/memory.h                      |    6 +
 include/hw/i386/pc.h                       |   28 +
 include/hw/i386/x86.h                      |    2 +-
 linux-headers/asm-loongarch/bitsperlong.h  |   23 +
 linux-headers/asm-loongarch/kvm.h          |    4 +
 linux-headers/asm-loongarch/mman.h         |    9 +
 linux-headers/asm-riscv/kvm.h              |    1 +
 linux-headers/asm-riscv/mman.h             |   36 +-
 linux-headers/asm-s390/mman.h              |   36 +-
 linux-headers/asm-x86/kvm.h                |   52 +-
 linux-headers/linux/vhost.h                |   15 +-
 qapi/misc-target.json                      |   72 +-
 qapi/qom.json                              |   97 +-
 system/memory.c                            |   24 +
 target/i386/cpu.c                          |    1 +
 target/i386/kvm/kvm.c                      |   55 +
 target/i386/kvm/kvm_i386.h                 |    1 +
 target/i386/kvm/trace-events               |    1 +
 target/i386/sev-sysemu-stub.c              |    2 +-
 target/i386/sev.c                          | 1588 +++++++++++++++-----
 target/i386/sev.h                          |   13 +-
 target/i386/trace-events                   |    3 +
 26 files changed, 1833 insertions(+), 420 deletions(-)

-- 
2.34.1


