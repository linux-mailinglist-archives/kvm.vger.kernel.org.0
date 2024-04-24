Return-Path: <kvm+bounces-15737-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D23FB8AFD2C
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 02:09:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5BBB41F22D3A
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 00:09:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EF65BE4F;
	Wed, 24 Apr 2024 00:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="xIieUONv"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2064.outbound.protection.outlook.com [40.107.243.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7127C8C05
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 00:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713917347; cv=fail; b=HSUld4f0ldBncRotXEA+5aw8CcO4R4j+GM2pyBm2VR0Bbi+tz3mX4DkI+37v2OrASIgFYwbdk0VPUBHV4Cuju1A+soscz32waRNOMeScmQ76GxuifupjGeDCSzh5Y02zdOXaA1kkK1rb9xzBzhXme7f0lrWXx4sl82UTzqc+d3s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713917347; c=relaxed/simple;
	bh=C+PDYDxke+s6y6zexkvYvH2KdexhFKbuTBhzdttdLgQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FnK9JS8lQJkNXg1026X182dOIC12cWbis71y9qgFdXo8dnGMB8q7ICUxfLK1tgrb64G7Y/4ZZ3VXQfTrQKL5yN8ubXDAtxcviPRD1opJCu0sVfgq/qYCBBmFPjBUa7+xcfnwdumZl9PKJ49kNfSol12iFGnGIJLtKZYwM1tOzUs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=xIieUONv; arc=fail smtp.client-ip=40.107.243.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gP7PUEE+mCGXW8GCFZ/FjKR5qFKosUbQyzGk6txKadQpVMNgtTc3/gDJuTJaSLkpXlq1urbYYH5zYo/nYdPXzsuwotWq1EJppH7v04SoWatuBT10nIPvVwVP7Uwbc31D5rxRRSK3Ko/utQwJsKBnOTqw2RgwHR3O1QgVfFNorNJGq8gPfC2kLApgocFPftrlCFEIPz8RxyH1SlyYAl+XDisbFSC5uSwJZwHlK30uWeIGeW9sTmeMi+pQEb0pRjcabRVm0EMg76V+9qTzGBD69ktgJPvHJLArma6VknNdUB9gd4MTDrZ4H0T4d9+jil6sj7940cnD5qdc3yXZQykZvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SFj4VLXpPGAxeno9p5TXvZBa1bZ69tJHoOuMFF09Igg=;
 b=RXtvaxm8RC08uorjgn+w6qInFm0dHJiqhXtblXYLClhIWqKiz3Umky1gXMIEAzDGZ4KX/MgZBxi4fqN0XoyVb8r7c9ZpsJLEmRTA8fkTd6oCcrOMmKEY4kYNNex2Sll4Zr0ZNWDqpV8RdGAOu4n8W2jN4JT58AUGS79h1PqZPHxi+3HxMu+RC0H+xSt8j10aAxWPYOmswkyxeaQMQDieuwFRYZKr2bZExC5ofgoyAKR+giVHHeKkVltQwTkzmfQGJAbowyMGwgMMvycZNBfUzV2Fr7va1UeJqVwlBj0NDhduuVE5H/qL2SeQA5BjQCQf6quyJ2aT2yxWtFTsNbYM4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SFj4VLXpPGAxeno9p5TXvZBa1bZ69tJHoOuMFF09Igg=;
 b=xIieUONvv8wGODQSJaQEnexTErGfT58WbEyw3s7Q5GmDHRgDCYyXpm8THRH437tH08WGKA3dRyAAKJdcbKF89XUJ+lvL+5qAXHgDfr4l21sYpnkGHwNsSmIB9K+Jo5IOA55TwUoKmn1+CTRnOVsqwl373cBX7A4Tw1Shy5saZwg=
Received: from DM6PR11CA0065.namprd11.prod.outlook.com (2603:10b6:5:14c::42)
 by LV3PR12MB9355.namprd12.prod.outlook.com (2603:10b6:408:216::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Wed, 24 Apr
 2024 00:09:01 +0000
Received: from DS3PEPF0000C37E.namprd04.prod.outlook.com
 (2603:10b6:5:14c:cafe::50) by DM6PR11CA0065.outlook.office365.com
 (2603:10b6:5:14c::42) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7495.34 via Frontend
 Transport; Wed, 24 Apr 2024 00:09:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF0000C37E.mail.protection.outlook.com (10.167.23.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7519.19 via Frontend Transport; Wed, 24 Apr 2024 00:09:01 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Tue, 23 Apr
 2024 19:08:52 -0500
Date: Tue, 23 Apr 2024 19:08:38 -0500
From: Michael Roth <michael.roth@amd.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
CC: Isaku Yamahata <isaku.yamahata@intel.com>, <qemu-devel@nongnu.org>,
	<kvm@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?=
	<berrange@redhat.com>, Markus Armbruster <armbru@redhat.com>, Pankaj Gupta
	<pankaj.gupta@amd.com>, Isaku Yamahata <isaku.yamahata@linux.intel.com>
Subject: Re: [PATCH v3 48/49] hw/i386/sev: Use guest_memfd for legacy ROMs
Message-ID: <20240424000838.menxh32bnvnyvfz4@amd.com>
References: <20240320083945.991426-1-michael.roth@amd.com>
 <20240320083945.991426-49-michael.roth@amd.com>
 <20240320181223.GG1994522@ls.amr.corp.intel.com>
 <61462f83-1406-48ea-8f1a-fae848ff1443@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <61462f83-1406-48ea-8f1a-fae848ff1443@intel.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37E:EE_|LV3PR12MB9355:EE_
X-MS-Office365-Filtering-Correlation-Id: 53312bda-ed0b-41f3-93dd-08dc63f2beed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?T2oFQbR+HA6sTXibzfJrb9Fn8FkVVPDXPcjAm4C1poYi8InzzGtb3uXC40+4?=
 =?us-ascii?Q?VgsyeevypAaMIeVEXSgXLWzTp2BTL+RXkhm125hApogWMiTzB0cHjrpAaIhy?=
 =?us-ascii?Q?ftzEBVyV4aXynhNROS2bK9jnJNkPTZ+mFfJojQSlcm5V+YPWUyXCcF53+WsO?=
 =?us-ascii?Q?lPSKSf6umoqQD2EoAEY/glNntReEbq9im+bsffb5zI22xaXfnXJ0zQEQta5r?=
 =?us-ascii?Q?qcF6jnuRj4GX8tIncJUHjliXEl0sfR33oEaFUjRbWaKd4TFTzY4pkq7YrUFI?=
 =?us-ascii?Q?WbC/ZFLQXEH0tqU2NNHrVmTYjATu/a7eHRQbO2SUoj2ga2R3Ll2u2AmOn6eX?=
 =?us-ascii?Q?jyEt0CzyuJTPNdBPMXxgPI/lua3FRFSW/tpsw5zQVCMKLX6RdPSqv7n9hZ+5?=
 =?us-ascii?Q?cBUIwsyZx5WfaUqfmXPuHfwhfZxIKcEJzY1dPjTsakJkLX14SvOgXa4aB1GB?=
 =?us-ascii?Q?SFwMptuGCs9ES5iBDGGQia3h4QcMpT0R280R10I1/pd1ZtI6mfmH0SkN8njY?=
 =?us-ascii?Q?9oyWWvVEaq6bzDuvw/D/AZqqSp5mzsBNrCA1GBqInmQgOAneq2HkgqwfJJaE?=
 =?us-ascii?Q?mbs0yIweqTwAxh7VAxaEc5d5c77NsRWUsU4mlC9YxNpOmuc/DbL+vdKdmonZ?=
 =?us-ascii?Q?cT4z9VK3fWfLnx2Icd9vyhn/PY5pGwpTMYJUNVLg3J1ke4L+9FSdtA0R7SDV?=
 =?us-ascii?Q?vL4vaxklAYS4R9R8AvT0aY3zuOtCBkGyB55LUlspXW779dzNEzdUdhMmLMg7?=
 =?us-ascii?Q?36q2nF9vB7heuepF11cFl1jNlFly/CAEXI1JjnLDLQlvxRLxRTZvGnxGUV7N?=
 =?us-ascii?Q?E8FRCnfvjkD12b6j3GjtvHR9B3zcreJncGD5joBIm8gMzssYuLeO+L5yQ9HC?=
 =?us-ascii?Q?s/3dp6BvWhpL7S5GaSUkkihd3i88AeM28/RY4cRdUdQYPZlIGB8Trf5V3aWm?=
 =?us-ascii?Q?dKT/nq4tqQ89V5ICiVb6MyPqU52Fk5OHUyClgZgdcXNV6zioPZwCgaPWgoey?=
 =?us-ascii?Q?GkL8AaT+p6H9Wb6tfUTxLkx2k7nik9VGlopJ42QutmieFNJwUawo+FgiPWvG?=
 =?us-ascii?Q?JJYR7FEsWSUaoe1WR05J9WERg8q8TaefvGQnJpQfNYK9FBWixZPyzhe7h3L5?=
 =?us-ascii?Q?6RLzWMs9hA5ugdbv1altwgkuI3rR08AAVfFdKvVSyuqXFyzjzGGk1OUxsL+q?=
 =?us-ascii?Q?wwRxWorq6ht758wQiVPYlKufLjSCLmtI9XQ25Xe+UsL3Z7q/sdDvP/mQSR7u?=
 =?us-ascii?Q?5+CZUD+OQEMMHd344kIPd0LpRLjgTc36Z09/+EoRT9hbLoKBxXi0QUmpnDDz?=
 =?us-ascii?Q?Q35pauBxMetDJwJ9mqyMxIGb?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(1800799015)(36860700004)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2024 00:09:01.4994
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 53312bda-ed0b-41f3-93dd-08dc63f2beed
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9355

On Thu, Mar 28, 2024 at 08:45:03AM +0800, Xiaoyao Li wrote:
> On 3/21/2024 2:12 AM, Isaku Yamahata wrote:
> > On Wed, Mar 20, 2024 at 03:39:44AM -0500,
> > Michael Roth <michael.roth@amd.com> wrote:
> > 
> > > TODO: make this SNP-specific if TDX disables legacy ROMs in general
> > 
> > TDX disables pc.rom, not disable isa-bios. IIRC, TDX doesn't need pc pflash.
> 
> Not TDX doesn't need pc pflash, but TDX cannot support pflash.
> 
> Can SNP support the behavior of pflash? That what's got changed will be
> synced back to OVMF file?

For split OVMF files (separate FD for CODE vs. VARS) it can, but it
requires special handling in OVMF to handle MMIO to the VARS area using
direct MMIO hypercalls rather than relying on MMIO emulation. Here's the
relevant OVMF commit:

  commit 437eb3f7a8db7681afe0e6064d3a8edb12abb766
  Author: Tom Lendacky <thomas.lendacky@amd.com>
  Date:   Wed Aug 12 15:21:42 2020 -0500

      OvmfPkg/QemuFlashFvbServicesRuntimeDxe: Bypass flash detection with SEV-ES

      BZ: https://bugzilla.tianocore.org/show_bug.cgi?id=2198

For SNP, the plan is to continue to use -bios to handle the actual
CODE/BIOS FD, but to allow the use of pflash,unit=0 to handle the VARS
fd if a separate/persistent store is desired. This allows us to continue
using read-only memslots on the VARS/pflash side without being at odds
with the fact that read-only memslots are no longer supported for private
memslots (since VARS doesn't need to be measured/mapped as private), and
limiting the special handling to -bios where TDX/SNP both need private
memslots.

This is roughly how things will look with v4 of this series:

  https://github.com/AMDESE/qemu/commit/21fff075372ad25b2d09c5e416349c2b353fdb4c

I think (if needed) TDX could in theory take a similar approach with
similar modifications to OVMF and providing an option for a split CODE/VARS
variant.

-Mike

> 
> > Xiaoyao can chime in.
> > 
> > Thanks,
> > 
> > > 
> > > Current SNP guest kernels will attempt to access these regions with
> > > with C-bit set, so guest_memfd is needed to handle that. Otherwise,
> > > kvm_convert_memory() will fail when the guest kernel tries to access it
> > > and QEMU attempts to call KVM_SET_MEMORY_ATTRIBUTES to set these ranges
> > > to private.
> > > 
> > > Whether guests should actually try to access ROM regions in this way (or
> > > need to deal with legacy ROM regions at all), is a separate issue to be
> > > addressed on kernel side, but current SNP guest kernels will exhibit
> > > this behavior and so this handling is needed to allow QEMU to continue
> > > running existing SNP guest kernels.
> > > 
> > > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > > ---
> > >   hw/i386/pc.c       | 13 +++++++++----
> > >   hw/i386/pc_sysfw.c | 13 ++++++++++---
> > >   2 files changed, 19 insertions(+), 7 deletions(-)
> > > 
> > > diff --git a/hw/i386/pc.c b/hw/i386/pc.c
> > > index feb7a93083..5feaeb43ee 100644
> > > --- a/hw/i386/pc.c
> > > +++ b/hw/i386/pc.c
> > > @@ -1011,10 +1011,15 @@ void pc_memory_init(PCMachineState *pcms,
> > >       pc_system_firmware_init(pcms, rom_memory);
> > >       option_rom_mr = g_malloc(sizeof(*option_rom_mr));
> > > -    memory_region_init_ram(option_rom_mr, NULL, "pc.rom", PC_ROM_SIZE,
> > > -                           &error_fatal);
> > > -    if (pcmc->pci_enabled) {
> > > -        memory_region_set_readonly(option_rom_mr, true);
> > > +    if (machine_require_guest_memfd(machine)) {
> > > +        memory_region_init_ram_guest_memfd(option_rom_mr, NULL, "pc.rom",
> > > +                                           PC_ROM_SIZE, &error_fatal);
> > > +    } else {
> > > +        memory_region_init_ram(option_rom_mr, NULL, "pc.rom", PC_ROM_SIZE,
> > > +                               &error_fatal);
> > > +        if (pcmc->pci_enabled) {
> > > +            memory_region_set_readonly(option_rom_mr, true);
> > > +        }
> > >       }
> > >       memory_region_add_subregion_overlap(rom_memory,
> > >                                           PC_ROM_MIN_VGA,
> > > diff --git a/hw/i386/pc_sysfw.c b/hw/i386/pc_sysfw.c
> > > index 9dbb3f7337..850f86edd4 100644
> > > --- a/hw/i386/pc_sysfw.c
> > > +++ b/hw/i386/pc_sysfw.c
> > > @@ -54,8 +54,13 @@ static void pc_isa_bios_init(MemoryRegion *rom_memory,
> > >       /* map the last 128KB of the BIOS in ISA space */
> > >       isa_bios_size = MIN(flash_size, 128 * KiB);
> > >       isa_bios = g_malloc(sizeof(*isa_bios));
> > > -    memory_region_init_ram(isa_bios, NULL, "isa-bios", isa_bios_size,
> > > -                           &error_fatal);
> > > +    if (machine_require_guest_memfd(current_machine)) {
> > > +        memory_region_init_ram_guest_memfd(isa_bios, NULL, "isa-bios",
> > > +                                           isa_bios_size, &error_fatal);
> > > +    } else {
> > > +        memory_region_init_ram(isa_bios, NULL, "isa-bios", isa_bios_size,
> > > +                               &error_fatal);
> > > +    }
> > >       memory_region_add_subregion_overlap(rom_memory,
> > >                                           0x100000 - isa_bios_size,
> > >                                           isa_bios,
> > > @@ -68,7 +73,9 @@ static void pc_isa_bios_init(MemoryRegion *rom_memory,
> > >              ((uint8_t*)flash_ptr) + (flash_size - isa_bios_size),
> > >              isa_bios_size);
> > > -    memory_region_set_readonly(isa_bios, true);
> > > +    if (!machine_require_guest_memfd(current_machine)) {
> > > +        memory_region_set_readonly(isa_bios, true);
> > > +    }
> > >   }
> > >   static PFlashCFI01 *pc_pflash_create(PCMachineState *pcms,
> > > -- 
> > > 2.25.1
> > > 
> > > 
> > 
> 
> 

