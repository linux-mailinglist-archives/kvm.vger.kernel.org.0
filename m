Return-Path: <kvm+bounces-21831-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CB08E934D6B
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 14:49:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EE0601C226D1
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 12:49:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3227E13C80B;
	Thu, 18 Jul 2024 12:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="CFhTO5p3"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2076.outbound.protection.outlook.com [40.107.223.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5D954645
	for <kvm@vger.kernel.org>; Thu, 18 Jul 2024 12:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721306986; cv=fail; b=GzUCC9g9zLAjtjWX8qDjH+FDnc1qHwv2znF9aPPaB+yu0M3JdD1i6UXr3NECpxNRUXkAalT0x6khTI8hw+bKQ/cv09NFGdQP63Gs0oM0NCx93fcw8Z+MS1MD6FsoZshWfKdTjzoMhn4Bj07/FR0ORf6O5swgpobsbzHDfvOIB7Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721306986; c=relaxed/simple;
	bh=KXMvAIy4Ie73c8mRXtlFmQ0zhbWQbmonBAxmL6REPwc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=SLPcxEDRsbE3+gqJJ6SJYFkmDA/65iMGjvCDSKpppEXpltEEwmlj/4gJdPSnCxAsASX3j3XNJPaEoma5ZGx+o8UZfPVXhdnEpyE9WMKXuFNcV3HxJ/7KUNov7AUw51Qcb3qaebXo4wkGYf9vJUyXOpw2C+gonHhPvk55r+GjHIk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=CFhTO5p3; arc=fail smtp.client-ip=40.107.223.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vxz6IRCcLqxtsQgmEB3KcS8Z+pyVNoZbHExMhh31Xchu1LHFUZkDmP6MK6a4lWl42vjMwOIgFH8NmAtyaKQ7w1RfjiDKtemGV3FFUDt+U0DJNau1z2obNXp5bP3LN5aY9dgWpe5goI5wZD++azGpkCF237vLA3aCt4ZCHyraMdM/NpmOrDI//Tpd0MWZs1AXZ7yjHrdTWsRjglTjsLt75+Iw9VwHqttT6Fn/AvY8N31S66n+OVSgv4VqOJegvOQ+Is/yoqlRx4BRL0ECKXPF+pksx3xxvy9l8icCKjuDOp5DBSkssseLxSa+1LANKoAtZ4uZHnQZ/jsNQkf+rZ0IXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V4bZI6UZqafFApv1JSBC+NnHk1htfDkG7I44SZgezkM=;
 b=vN4i6CXK+eQUnoNiEM2b5MqlROC6RAFpNtM8VN8D78f9Hh/57lJMrcUTRxkGiCCe1MNaQnyWP6AHoamdVMkwFTlklEStfBEkCIQByr6JK9k70Hf8karm9IpBJPM84WpUS1aHhlFT/7JjCN0lVu2bb7dkgOHz7xiYnJi3WC1CN4e6aYE7RGfNuI7fLtHgWa3gnwatWzlzme4iobMsmQUX76NzFVnyUepdjjhyWGAwbziuaiIrDjyYr1ffapv5Kwhm92npIJ4gqOS+0FATnevMGs1CcfoNxvq572l9rFj1TyK5v/52W6CnRk4pgcJr3GqKZUSG9Qs9cFokOBGYWwnDxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V4bZI6UZqafFApv1JSBC+NnHk1htfDkG7I44SZgezkM=;
 b=CFhTO5p3IFL1pamuT2MXK8UBksG6s0L+JuHM3c4JRN1ejK7Qi5kvjNmLfn1+vrCBsz8skPCaS/VC0LvrzO3+ed7RFlTk4uu01ys2sPpt3x/YrCYMjYFQLUGQF3W/FqGO5jz+ym+2jktydh8jKsZ03zJqnFX8Dk+IVwJEz0Kodvk=
Received: from BN9PR03CA0328.namprd03.prod.outlook.com (2603:10b6:408:112::33)
 by SJ2PR12MB9007.namprd12.prod.outlook.com (2603:10b6:a03:541::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.16; Thu, 18 Jul
 2024 12:49:41 +0000
Received: from BN2PEPF000044A8.namprd04.prod.outlook.com
 (2603:10b6:408:112:cafe::c) by BN9PR03CA0328.outlook.office365.com
 (2603:10b6:408:112::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.17 via Frontend
 Transport; Thu, 18 Jul 2024 12:49:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF000044A8.mail.protection.outlook.com (10.167.243.102) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7784.11 via Frontend Transport; Thu, 18 Jul 2024 12:49:40 +0000
Received: from ethanolx16dchost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 18 Jul
 2024 07:49:39 -0500
From: Pavan Kumar Paluri <papaluri@amd.com>
To: <kvm@vger.kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christophersen
	<seanjc@google.com>, Michael Roth <michael.roth@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Pavan Kumar Paluri <papaluri@amd.com>, "Kim
 Phillips" <kim.phillips@amd.com>, Vasant Karasulli <vkarasulli@suse.de>
Subject: [kvm-unit-tests PATCH v2 00/16] Introduce SEV-SNP support
Date: Thu, 18 Jul 2024 07:49:16 -0500
Message-ID: <20240718124932.114121-1-papaluri@amd.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A8:EE_|SJ2PR12MB9007:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d7bbbbb-c902-4c26-7337-08dca72816dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7HTN9RXawdYLWjgX5rDF2m8kn1E13FYFLmYHD4OHgRBQNUNrP49msImUoKsM?=
 =?us-ascii?Q?M3KBD7CfarjacKeNcULsjDXz7lqX3yNbd19qlmmTsTLBvHlvKmRtsh9zU7Lb?=
 =?us-ascii?Q?wXFsJPOCVy+25qoLlIKZq1exi901zcVJiUOs+gXLxh3dv5GXvlj7RO7YL0nE?=
 =?us-ascii?Q?tUMryWhHOAt5oQnJg2KqXiefYianYmAiftR1RNRszJfSLOdndOsbKrrKAnrq?=
 =?us-ascii?Q?VbkZztohMu68vEDbhEly+iaJzHF2fqHnrmgX0E9L6FZuc6IBkHV0DehJGj+D?=
 =?us-ascii?Q?8+1lY0b+cYq9pt4m/vtpenZijbj3tNAL75UQrggWrwKD7zkQ6MFeAVU49BGL?=
 =?us-ascii?Q?b3prGaF3HWlGR/Sfza7gceNDP1QiQeiQJtJCroCdoojp5MKvGto0TyBvYjic?=
 =?us-ascii?Q?G5JY+9305z5FPksBiZFJmOE6/krttgwFASOVe2eJ2nf9z1TuHl+kjjPcPUvj?=
 =?us-ascii?Q?hK3/t9XJQ7fBxs9xim48KA+JRP0MMCkvsY8kOtZj3InNMwM++BrPJDsfEUVo?=
 =?us-ascii?Q?ww/9z8Tb+9nzGcybexyP3CG2dQU8CN/aUFcIVKTMJRL6uCJcjymnbkYFnXil?=
 =?us-ascii?Q?BjiUcQp5J7a5FHmsh9Ae7ExH5ILCiJzE6LucCfHCG0YFkCRyY7RG5e1jEu2J?=
 =?us-ascii?Q?BIWPvHc5jyalFq5ufVS056y3CKrx9fHkrqd++VHzaCSbn9eiL5N/D5zLMdvq?=
 =?us-ascii?Q?CvimOzsmtUHYCEQeODaegR2TlH9oqbKErmRj9Z3n26lhReal0eVHI10QVnrp?=
 =?us-ascii?Q?C0c+7yj9XooQbC/brRwSK0iJEvWpVqeSt6nOZso0xhs7Ui+tNOIay9bu04eC?=
 =?us-ascii?Q?pgxuOkZaxmOtkbFFlaRRZFZ5ukkMvfMSK4SYLX8fA/TfUEaPh78arfmOjV9p?=
 =?us-ascii?Q?CwLJn6G+U4gjFeyLq0YguFZ1cJjtrvZqkbDrmgZiklXQR6O3+pTV4Y1kvKUZ?=
 =?us-ascii?Q?p/ZuTWyVwQ6/b10huYNFC2RfHTBFMJkaKWh7PB70sIaRl+XMSPZK9+9PaOww?=
 =?us-ascii?Q?7BHDEbRmPm14IgbDh/x98xqFZi4RZ1s3mKmqeqKPlTd8HyzYVFD0SSeBB7Pk?=
 =?us-ascii?Q?LeGaBOvfesGLzDWi5/gon1Yt0OD0/amB5gbsDAFm+XOotxj+AX0Cwj1HI/f8?=
 =?us-ascii?Q?zI6BVKI1cipqCKDAAfdLRCVcO6tYjsFl8idfY90O7xRrpGMsS5UPVSQVqSzi?=
 =?us-ascii?Q?/eCEQsmGPsZlml9HZQwBmhj1bbNlutHRMm34tPJaY0ZAnEqeWMeSkerg20+b?=
 =?us-ascii?Q?WmMzMHK4l4XM47a+YLvJ2CfgJy3FZHjjKiQaLXKrjR9SRGWGzUkQc6xi+2+/?=
 =?us-ascii?Q?MymsKHhzGHL/CLeEsxFRZA2S7tDulERxSFOUHYIbp4xX07JfdVnvd2fisKcg?=
 =?us-ascii?Q?Q6FBS2xRP7HEc+mP28+Svc4B29JWv2qJ7wVStX3UmKCWo0sTqQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2024 12:49:40.2281
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d7bbbbb-c902-4c26-7337-08dca72816dc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A8.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9007

This series introduces support for SNP features to KVM-Unit-Tests
environment. Goal of this work is to use KUT to build and develop a test
suite for KVM hypervisor with SEV-SNP support to test basic
functionality as well as determine whether hypervisor can handle edge
cases that a normal SNP guest otherwise wouldn't perform/request.

These patches are rebased on top of [1] and are available at:
https://github.com/pvpk1994/kvm-unit-tests-1/tree/SNP_RFC_v2

which are in turn rebased on kvm-unit-tests/master (201b9e8bdc84)

============
Patch Layout
============
Patches 1-2: Provide MMIO access support to the APIC page by unsetting
	     C-bit in guest page table for SEV-ES/SEV-SNP guest.

Patch 3: Renames SEV-ES's #VC handler to a more generic name that
	 applies to both SEV-ES and SEV-SNP. No functional change.

Patch 4: Adds support in x86/efi/run for running SEV-SNP unit tests
	 under UEFI

Patches 5-6: Adds support for SEV-SNP enablement and CC-blob discovery.

Patch 7: Sets up GHCB page table attributes for new page table.

Patches 8-12: Page state change conversions using MSR and GHCB protocol
	      approaches.

Patches 13-14: Page state change conversions from 2M intermixed states
	       to 2M Shared/Private states.

Patch 15: PSMASH/UNSMASH page state change requests on 2M large pages.

Patch 16: Injecting random non-zero page offsets via page state change
	  requests.

================================
Procedure to run this test-suite
================================
SEV-SNP KUT guest requires UEFI/OVMF to bootup. Information on how to
run the SEV-SNP tests with UEFI support can be found in
x86/efi/README.md introduced in this patchset.


Tested this patchset against the following: (Kernel, OVMF, QEMU):

Upstream QEMU:
 (commit: e2f346aa9864)
 Merge tag 'sdmmc-20240716' of https://github.com/philmd/qemu into staging 

Upstream OVMF:
 (commit: 11c50d6ca10a)
 MdeModulePkg/UfsBlockIoPei: Wait fDeviceInit Be Cleared by Devices

Upstream kernel: kvm/next
 (commit: 1c5a0b55abeb)
 Merge tag 'kvmarm-6.11' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD

System can be configured as follows to run UEFI SNP tests:
    ./configure --enable-efi
     This will configure KUT to use #VC handler that it sets up once 
     GHCB page is mapped.

    ./configure --enable-efi --amdsev-efi-vc
    The above configuration option will build KUT and let SNP test use 
    #VC handler that is setup by OVMF throughout the lifetime of SNP 
    guest. 

The SNP tests introduced in this patchset run well with both the above
configuration options (--enable-efi and --enable-efi --amdsev-efi-vc).


Once configured, SEV-SNP unit tests can be tested as follows:
    export QEMU=/path/to/qemu-system-x86_64
    export EFI_UEFI=/path/to/OVMF.fd
    EFI_SNP=y ./x86/efi/run ./x86/amd_sev.efi

==========
References
==========
[1] https://lore.kernel.org/all/20240612144539.16147-1-vsntk18@gmail.com/

=========
Changelog
=========
v1 -> v2:
  * Rebased on AMD SEV-ES #VC handler patchset [1]
  * Rebased [1] on KUT's master (201b9e8bdc8b).
  * Introduced a new test where test issues PSMASH/UNSMASH page state 
    change requests on 2M ranges.
  * Introduced a new test where test injects random current page offsets 
    to examine how hypervisor handles page state change requests with
    non-zero page offsets for 2M large pages.
  * Implemented non-identity mappings for all page state change tests 
    (4K/2M) to avoid any odd side-effects arising due to page state 
    conversions on identity mapped pages.
  * Implemented a new helper (vmalloc_pages()) to allocate non-identity 
    mapped pages that would also be helpful for non-SNP related tests.
  * Introduced pgtable_va_to_pa() to help convert a guest virtual 
    address to guest physical address by doing page table walk that 
    would be helpful when we have non identity mapped pages where 
    virt_to_phys() won't work.
  * Introduced snp_free_pages() interface to help bring back all the 
    pages back to default guest-owned states before freeing up the 
    physical pages after the SNP tests finish.
  * Got rid of the check where end_entry is being forcefully truncated 
    to 252 when sizeof(struct snp_psc_desc) exceeds GHCB shared buffer 
    size. Instead, VMGEXIT_PSC_MAX_ENTRY is now calculated based on
    the size of the GHCB shared buffer.
  * Introduced add_psc_entry() helper to facilitate easy addition of a 
    new page state change entry for patches that need individual 
    entries to be added.
  * Dropped "RFC" tag.
  * v1: https://lore.kernel.org/all/20240419125759.242870-1-papaluri@amd.com/

Pavan Kumar Paluri (16):
  x86/apic: Use common library outb() implementation
  x86/apic: Add MMIO access support for SEV-ES/SNP guest with C-bit
    unset
  x86 AMD SEV-ES: Rename setup_amd_sev_es() to setup_vc_handler()
  x86/efi: Add support for running tests with UEFI in SEV-SNP
    environment
  x86 AMD SEV-SNP: Enable SEV-SNP support
  x86 AMD SEV-SNP: Add tests for presence of confidential computing blob
  x86 AMD SEV-ES: Set GHCB page attributes for a new page table
  x86 AMD SEV-SNP: Test Private->Shared page state changes using GHCB
    MSR
  x86: Introduce gva to gpa address translation helper
  x86: Add support for installing large pages
  x86 AMD SEV-SNP: Change guest pages from Private->Shared using GHCB
    NAE
  x86 AMD SEV-SNP: Change guest pages from Shared->Private using GHCB
    NAE
  x86 AMD SEV-SNP: Change guest pages from Intermix->Private using GHCB
    NAE
  x86 AMD SEV-SNP: Change guest pages from Intermix->Shared using GHCB
    NAE
  x86 AMD SEV-SNP: Issue PSMASH/UNSMASH PSC requests on 2M ranges
  x86 AMD SEV-SNP: Inject random cur_page offsets for 2M ranges

 lib/asm-generic/page.h |   2 +
 lib/linux/efi.h        |   1 +
 lib/x86/amd_sev.c      | 357 ++++++++++++++++++++++++++++++++++-
 lib/x86/amd_sev.h      | 124 +++++++++++-
 lib/x86/amd_sev_vc.c   |   2 +-
 lib/x86/apic.c         |  22 ++-
 lib/x86/setup.c        |  15 +-
 lib/x86/svm.h          |   1 +
 lib/x86/vm.c           |  70 +++++++
 lib/x86/vm.h           |   6 +
 x86/amd_sev.c          | 420 +++++++++++++++++++++++++++++++++++++++++
 x86/efi/README.md      |   6 +
 x86/efi/run            |  33 +++-
 13 files changed, 1038 insertions(+), 21 deletions(-)

-- 
2.34.1


