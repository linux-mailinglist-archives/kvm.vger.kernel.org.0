Return-Path: <kvm+bounces-18663-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C00F8D84F1
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 16:28:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 537CF283864
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 14:28:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1453712EBC7;
	Mon,  3 Jun 2024 14:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=amd.com header.i=@amd.com header.b="d+i0YfuF"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2055.outbound.protection.outlook.com [40.107.237.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6704B12E1D4
	for <kvm@vger.kernel.org>; Mon,  3 Jun 2024 14:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717424884; cv=fail; b=LZvPDMeh1r+xweuvcD2b+XS5bcxMRtrdRrj4kAWq5McX5WoZk1yvFlwT89pEs5zw9+W/wGf8IjGwV9r6lcVdOJd44AEQhtVII7BDfVF9uXWIJ/1KUkcfRiScK2uGPO7xil2mV6R1rnIcMJkWNnh6UdaF53fv+aDFWwQxiiUDkk8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717424884; c=relaxed/simple;
	bh=n9Q+E2NSp6QLcj0geCAMKeC8Y2dqZKGYNyyotTsguK4=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BxNLPGwDvIvEC0xaVDphrXrQqQ3+QbFlWgoAZXYtsgNgYLhW55Chf8mtRG9X7LTGYN4HzKQvIK9qMrQvD8XvWybEupCd017ULaj8MaJZWoDncZSl6z5dEyN61S5RinPsNoetvVcgM2DLgJm8ONpVNpZa+oLs+lF1xckXmd81EP8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=fail (1024-bit key) header.d=amd.com header.i=@amd.com header.b=d+i0YfuF reason="signature verification failed"; arc=fail smtp.client-ip=40.107.237.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PdTHxS62v9KwkpZIwbfErFKEgUmhb4itQlGynRvNlTziD6xqbc9PkRRiujzQSMqBnfcCa6hUvIBYSMbZEq50riX4lJ+DhHbt1RFwz4qGhNgaHOtu9Zx6YGnZHYB+pcVhtMsSGe6ZawzZpElXVBS5yO+X9f3FJ/wwmB8R+9IgjDeRg9wvoZV7dfbkV0zTsg9oUyX8lp0WBXqCO8jrbb45VovGrHgYEAkUe8c7RQ3ZMLpPjFzoJUJ6nh85JnIejrRdLqh6Y1YoaphYRx+ZBF+8ROvziifACWotSqe+LlwILHicM6L1R3sBwBmYO/wZAgIfRms33TdPnZZyTF43mdsfkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ckUToxqsPpM77NODzw4ZqJhD7wXURHF7xAye3qu+Moc=;
 b=VsmIAipN2bNsuwYbX46eo0Dm4pDPqw6DyXvIot+YpQTlNlKwl7B5mZWVYJ0AA/1JzHtbxEKWmb2Rxpmk88J9woLbvKPMnGYIZy+jdF7QVPttWLpFCOoo72l25AkGFRyDNu2zOoEbrXcgFa4OJ2OjnXBvRG4MCdF2/qZ11nhfQQstQVYAmdvbhFX5rAR4XwCL0eN7zdHVhYVKXiKNQKoaFqyAAaQyHc8XP9UaozjQxjS0BSX7Wghx7yggGFfhPnWdz+s+zZNyfEd98WSOucIa++cGEpzf43zyanIflvF8rg+cDK/OPsAbmMHXY58kMZ6hNsXCZ6mS4DOQPJt/v+/06g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ckUToxqsPpM77NODzw4ZqJhD7wXURHF7xAye3qu+Moc=;
 b=d+i0YfuFOyTc6zRGrW1b4dPI7kYuAtpYjMZGIieRQnec6zleEUQcRW7HvNtlxI5GETVoI7l16SeC53TItwytUPyB3bmR007gkORPaJPEpY5KbwzBqFJO/SsVazF29xSuh75dLzJpOjIhZthOzPxfRTIq3GQoO5RDg5KHdPn8uNU=
Received: from BL1PR13CA0165.namprd13.prod.outlook.com (2603:10b6:208:2bd::20)
 by IA0PR12MB8893.namprd12.prod.outlook.com (2603:10b6:208:484::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.21; Mon, 3 Jun
 2024 14:27:58 +0000
Received: from BL02EPF0001A0FE.namprd03.prod.outlook.com
 (2603:10b6:208:2bd:cafe::a8) by BL1PR13CA0165.outlook.office365.com
 (2603:10b6:208:2bd::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7656.14 via Frontend
 Transport; Mon, 3 Jun 2024 14:27:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0001A0FE.mail.protection.outlook.com (10.167.242.105) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Mon, 3 Jun 2024 14:27:58 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Mon, 3 Jun
 2024 09:27:57 -0500
Date: Mon, 3 Jun 2024 09:27:44 -0500
From: Michael Roth <michael.roth@amd.com>
To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
CC: Pankaj Gupta <pankaj.gupta@amd.com>, <qemu-devel@nongnu.org>,
	<brijesh.singh@amd.com>, <dovmurik@linux.ibm.com>, <armbru@redhat.com>,
	<xiaoyao.li@intel.com>, <pbonzini@redhat.com>, <thomas.lendacky@amd.com>,
	<isaku.yamahata@intel.com>, <kvm@vger.kernel.org>, <anisinha@redhat.com>
Subject: Re: [PATCH v4 29/31] hw/i386/sev: Allow use of pflash in conjunction
 with -bios
Message-ID: <wfu7az7ofb5lxciw2ewxoyf5xggex5npr7j2qookddfuaioikk@3lf2nzapab5c>
References: <20240530111643.1091816-1-pankaj.gupta@amd.com>
 <20240530111643.1091816-30-pankaj.gupta@amd.com>
 <Zl2vP9hohrgaPMTs@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Zl2vP9hohrgaPMTs@redhat.com>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0FE:EE_|IA0PR12MB8893:EE_
X-MS-Office365-Filtering-Correlation-Id: d96aa5c8-6ee1-422a-b906-08dc83d95ded
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|82310400017|36860700004|376005|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?YgdQaNQs8Hv22k80MJXxhAvkj/AuOZkd539jKstls9oZ/HAGomUf9ARSAz?=
 =?iso-8859-1?Q?jynWm7PX5Jk2T1InRByLcAsv/gmDxt8eTCjbvQUMTH5rAwuMXJWykA0mmc?=
 =?iso-8859-1?Q?yU4Q0sRLlKjDfUQEj3G4awddnvbzDpGdKYzZnHPzHAyItSpSOW7gnlQj5D?=
 =?iso-8859-1?Q?LL3wyZzJ9eLEpw9Kl4icpgUE0z4zqePCinP+aApyS1FQa7WYVveRiQaMjC?=
 =?iso-8859-1?Q?wDwN99duh4KQAfr8+pXfaPYc41jFccxk53uRPQW8KaPyz69MA2V266Caab?=
 =?iso-8859-1?Q?aDVp2VLGk0Wxgz2UTrc4Fkri9ZY4fjuEJfEuhPzTm7IpUcNWafIEUj4mwJ?=
 =?iso-8859-1?Q?e2ecfKmPytU7zfX/esQgturGZeAtvX/bowCGI/GMinovBh/+jPAuycEYS+?=
 =?iso-8859-1?Q?ah6qOb/2n4fwGxOekHVmtvkcuGEPilXYjOVhuS6QWkguocZLjqdW9Gaejb?=
 =?iso-8859-1?Q?Vi2ZPBaU9YFD9X0VuLK2cTGvZ+M9/16Tqd9ZrHoESELLBTTaYpEJOL/rD6?=
 =?iso-8859-1?Q?IbvMjZxrbKC5LqlVTmbEI9ZSjxEf9s4892X5O59TKnt029+tD9wn7NJcvX?=
 =?iso-8859-1?Q?2K2ERFfd2DxvcJulK9umR7v7Q83LBaprPIOgIBy6Cz2SiHd2gy9DiQYa1m?=
 =?iso-8859-1?Q?fR79is3ReVAzjnf0yte5/fiuzIiCs5kevUtJySCO25UUMgTUTBjagW0iU3?=
 =?iso-8859-1?Q?kZC1rlqUvwRFryvnOasCm3byirW8YcrJ/aAO3Y9d/t1RK4iNf3HTxu3R/z?=
 =?iso-8859-1?Q?f+xG9Yrx7Kd7tRa0No47Y+tg1TlpmDJl4zRzHmkHujokqHC8mQub6vdc3T?=
 =?iso-8859-1?Q?REbfj00j5tUujvUT/FYpVatVR00cza4+VNV1VFtTXm3qvEWe5e9PF4xthw?=
 =?iso-8859-1?Q?pVe89XfpeoLfM6R6DtwXlawDQqSQ4C163Y5cJuU0RxYIwxmDOxUoW8Zg7I?=
 =?iso-8859-1?Q?9SoM6m8paLLXtqw1Y2OJ033ScPke7lQlS5NNF53oNJ/TnD6BggI2pC2q64?=
 =?iso-8859-1?Q?IO4zChrTz6UvFAs6iemJ/9JOuIB+g71jfxzMtyGpIEx5N3QbAuMEUB9zcB?=
 =?iso-8859-1?Q?RTNJz29/oA8wTz3QsnH2nqgiOHgN16Ssb8spArNq45CZLHa3fi4ehuuJbT?=
 =?iso-8859-1?Q?GGmQhEJuMthOpoQyyodUJ6NgXDG66BkcFaHUtyiQSani4KIZgmNYph6m6Z?=
 =?iso-8859-1?Q?0puwhge6mnu49pp51wSYIRmfQsEm2ufK96ldyQ0YZifSWZZlgk7jQEUrVW?=
 =?iso-8859-1?Q?dWi7qujlemb0RheYdtsKv4Vf3EQZ6lm/VKNLpcHNfYGw610YcyXpw6uZXO?=
 =?iso-8859-1?Q?uUJA79UCEKNVjLCsgP8VOJbPxa5ZmljtD0+wSxmtcb4/jVNKBxx99wZLlk?=
 =?iso-8859-1?Q?8egHztEAYt?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400017)(36860700004)(376005)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2024 14:27:58.6301
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d96aa5c8-6ee1-422a-b906-08dc83d95ded
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A0FE.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8893

On Mon, Jun 03, 2024 at 12:55:43PM +0100, Daniel P. Berrangé wrote:
> On Thu, May 30, 2024 at 06:16:41AM -0500, Pankaj Gupta wrote:
> > From: Michael Roth <michael.roth@amd.com>
> > 
> > SEV-ES and SEV-SNP support OVMF images with non-volatile storage in
> > cases where the storage area is generated as a separate image as part
> > of the OVMF build process.
> 
> IIUC, right now all OVMF builds for SEV/-ES/-SNP should be done as so
> called "stateless" image. ie *without* any separate NVRAM image, because
> that image will not be covered by the VM boot measurement and thus the
> NVRAM state is liable to undermine  trust of the VM.

Technically both stateless and stateful are supported for SEV-ES, so
this is mainly to provide similar support for SNP. Unfortunately we
can't re-use the existing QEMU topology because of the limitations are
using read-only ROMs.

But I'm not sure it's something we have a hard requirement for, and even
then maybe there are other alternatives to consider that would offer
better security.

In any case, I think it makes total sense to decouple this from the
series and re-submit this as a separate patchset if we determine that
it's truly necessary (and if so, address Paolo's comments, and handle the
64K-alignment thing in the context of that work).

So for now maybe we should plan to drop it from qemu-coco-queue and
focus on the stateless builds for the initial code merge.

-Mike

> 
> Using NVRAM for SNP is theoretically possible in future but would be
> reliant on SVSM providing a secure encryption mechanism on the storage.
> 
> 
> 
> > 
> > Currently these are exposed with unit=0 corresponding to the actual BIOS
> > image, and unit=1 corresponding to the storage image. However, pflash
> > images are mapped guest memory using read-only memslots, which are not
> > allowed in conjunction with guest_memfd-backed ranges. This makes that
> > approach unusable for SEV-SNP, where the BIOS range will be encrypted
> > and mapped as private guest_memfd-backed memory. For this reason,
> > SEV-SNP will instead rely on -bios to handle loading the BIOS image.
> > 
> > To allow for pflash to still be used for the storage image, rework the
> > existing logic to remove assumptions that unit=0 contains the BIOS image
> > when SEV-SNP, so that it can instead be used to handle only the storage
> > image.
> 
> Mixing both BIOS and pflash is pretty undesirable, not least because
> that setup cannot be currently represented by the firmware descriptor
> format described by docs/interop/firmware.json.
> 
> So at the very least this patch is incomplete, as it would need to
> propose changes to the firmware.json to allow this setup to be expressed.
> 
> I really wish we didn't have to introduce this though - is there really
> no way to make it possible to use pflash for both CODE & VARS with SNP,
> as is done with traditional VMs, so we don't diverge in setup, needing
> yet more changes up the mgmt stack ?
> 
> > 
> > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > Signed-off-by: Pankaj Gupta <pankaj.gupta@amd.com>
> > ---
> >  hw/i386/pc_sysfw.c | 47 +++++++++++++++++++++++++++++-----------------
> >  1 file changed, 30 insertions(+), 17 deletions(-)
> > 
> > diff --git a/hw/i386/pc_sysfw.c b/hw/i386/pc_sysfw.c
> > index def77a442d..7f97e62b16 100644
> > --- a/hw/i386/pc_sysfw.c
> > +++ b/hw/i386/pc_sysfw.c
> > @@ -125,21 +125,10 @@ void pc_system_flash_cleanup_unused(PCMachineState *pcms)
> >      }
> >  }
> >  
> > -/*
> > - * Map the pcms->flash[] from 4GiB downward, and realize.
> > - * Map them in descending order, i.e. pcms->flash[0] at the top,
> > - * without gaps.
> > - * Stop at the first pcms->flash[0] lacking a block backend.
> > - * Set each flash's size from its block backend.  Fatal error if the
> > - * size isn't a non-zero multiple of 4KiB, or the total size exceeds
> > - * pcms->max_fw_size.
> > - *
> > - * If pcms->flash[0] has a block backend, its memory is passed to
> > - * pc_isa_bios_init().  Merging several flash devices for isa-bios is
> > - * not supported.
> > - */
> > -static void pc_system_flash_map(PCMachineState *pcms,
> > -                                MemoryRegion *rom_memory)
> > +static void pc_system_flash_map_partial(PCMachineState *pcms,
> > +                                        MemoryRegion *rom_memory,
> > +                                        hwaddr offset,
> > +                                        bool storage_only)
> >  {
> >      X86MachineState *x86ms = X86_MACHINE(pcms);
> >      PCMachineClass *pcmc = PC_MACHINE_GET_CLASS(pcms);
> > @@ -154,6 +143,8 @@ static void pc_system_flash_map(PCMachineState *pcms,
> >  
> >      assert(PC_MACHINE_GET_CLASS(pcms)->pci_enabled);
> >  
> > +    total_size = offset;
> > +
> >      for (i = 0; i < ARRAY_SIZE(pcms->flash); i++) {
> >          hwaddr gpa;
> >  
> > @@ -192,7 +183,7 @@ static void pc_system_flash_map(PCMachineState *pcms,
> >          sysbus_realize_and_unref(SYS_BUS_DEVICE(system_flash), &error_fatal);
> >          sysbus_mmio_map(SYS_BUS_DEVICE(system_flash), 0, gpa);
> >  
> > -        if (i == 0) {
> > +        if (i == 0 && !storage_only) {
> >              flash_mem = pflash_cfi01_get_memory(system_flash);
> >              if (pcmc->isa_bios_alias) {
> >                  x86_isa_bios_init(&x86ms->isa_bios, rom_memory, flash_mem,
> > @@ -211,6 +202,25 @@ static void pc_system_flash_map(PCMachineState *pcms,
> >      }
> >  }
> >  
> > +/*
> > + * Map the pcms->flash[] from 4GiB downward, and realize.
> > + * Map them in descending order, i.e. pcms->flash[0] at the top,
> > + * without gaps.
> > + * Stop at the first pcms->flash[0] lacking a block backend.
> > + * Set each flash's size from its block backend.  Fatal error if the
> > + * size isn't a non-zero multiple of 4KiB, or the total size exceeds
> > + * pcms->max_fw_size.
> > + *
> > + * If pcms->flash[0] has a block backend, its memory is passed to
> > + * pc_isa_bios_init().  Merging several flash devices for isa-bios is
> > + * not supported.
> > + */
> > +static void pc_system_flash_map(PCMachineState *pcms,
> > +                                MemoryRegion *rom_memory)
> > +{
> > +    pc_system_flash_map_partial(pcms, rom_memory, 0, false);
> > +}
> > +
> >  void pc_system_firmware_init(PCMachineState *pcms,
> >                               MemoryRegion *rom_memory)
> >  {
> > @@ -238,9 +248,12 @@ void pc_system_firmware_init(PCMachineState *pcms,
> >          }
> >      }
> >  
> > -    if (!pflash_blk[0]) {
> > +    if (!pflash_blk[0] || sev_snp_enabled()) {
> >          /* Machine property pflash0 not set, use ROM mode */
> >          x86_bios_rom_init(X86_MACHINE(pcms), "bios.bin", rom_memory, false);
> > +        if (sev_snp_enabled()) {
> > +            pc_system_flash_map_partial(pcms, rom_memory, 3653632, true);
> > +        }
> >      } else {
> >          if (kvm_enabled() && !kvm_readonly_mem_enabled()) {
> >              /*
> > -- 
> > 2.34.1
> > 
> 
> With regards,
> Daniel
> -- 
> |: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
> |: https://libvirt.org         -o-            https://fstop138.berrange.com :|
> |: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|
> 

