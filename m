Return-Path: <kvm+bounces-18659-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BF12D8D84B2
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 16:16:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C3CC7B23122
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 14:16:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3ABB112E1DC;
	Mon,  3 Jun 2024 14:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="I/YuVgZx"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2062.outbound.protection.outlook.com [40.107.102.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A150212C478
	for <kvm@vger.kernel.org>; Mon,  3 Jun 2024 14:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717424160; cv=fail; b=Os5oMqJEvBHDy+k/t12IEIh3zl5JItJ8e9Mp4rIeJJGs5n4DNDPNNGL48Ke+2CQVc9KRwVOCVw7vwiZ8Gdg1OVPzR6xNIyr9mgpQXepVcNHYEkwq1+/y9q5S+aWZ7+X0GnNLkhopjlph2BpsLwihniMaq/7a/JuHaLT8nbEUrmE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717424160; c=relaxed/simple;
	bh=CDQUlB8J4Sbjy4UKS6BYQfj1nxO65nAqW89x4EB/eJk=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IIUnvBxNmd3V1GAPOup8pj/mG7q3IRJtUq23c/ekeg0ppx1cQj8UhT4CTcK7QITMr+UfDkrbhuDdz9KXQ8MF4xtADdGFUWg6k2sldJFU9byfYMVONRcqXlWYBr4bT6uQLSrE7jh8+ix76Sh0o/6cNe6sCvtVhodBmWBbe+gUR6w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=I/YuVgZx; arc=fail smtp.client-ip=40.107.102.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JOVnHD5pCkmgjl5eoKAJ3l0PwD3Cak5Adm1aja+Twp+eB82SZjPNtN2DEtuBPQ/Rh2dwDh+k6CMI+BOXUkfhBeWQlE3xgL7IMu8/ij7f37EVRh727X3lBnPvfkvAEyK5ojMsfat4H0/zlvO3aKjkEYUC98mmMYs6S3dfVAOAFW9GUFD27FpKQ2satEKS+7/70kW+8NT4xarKZuLh0XrIBuZexr71mXeInNkCCPaKrjsfbp4ug7q6cNYjpymxfuyfpDiM7xP4/KOKLg5WCw8lSlXt4bcTY665LSmitbGw7fNUfN0Ebrp5Bz360+yr2Zyy32e0pihqeQ6j3ek9vIgmrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5AVTRN4rx0epJn2VuwuLPuBJUFvcWNNHxvifF0fFvro=;
 b=KShD0/Lxblq4vNkwMLleTy8t5eYo/pul0YL0uRiTfjJiIKogM3cltXajwRZoBy9d0tOgK03V+VF4xtU8N4VkVjVvoc9DomNml/2pxG9DOIe9pll0V85TR0T8sUvGV7mNskCddLcqHHLctSi0GIsPH+813H4AS0cDu4vpQnTkPIlTefK/td7V5g/fqZrCnZWumwpXJgnaf7yxjC05ZawI7B+DXPRC6k8jf4yScn+/kZoCWa1iwHmOej/J83SRq+1/AcwTfCPoWSAeRy/v+DNIXGk/oYTAfPKuxozpqnGO3z+kFvYKb+oUjJvL98yE1G8m3Mprg+J4ooZgDXwAeS0FfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5AVTRN4rx0epJn2VuwuLPuBJUFvcWNNHxvifF0fFvro=;
 b=I/YuVgZxfOHycxAeiMZcwAmRbOH/ZyKASG05ahanbXNJUQ22KA3XUxiXU+bfDEGepQ4nwNLS5w4SSmtBNbfnxNUA14rHghXql4u0Aa2IMAamV7Tk3fKIRbvY9k2rd1aPcXGdzE/DC/LecuH42y5uEU2bPMp6lmtFmAWW0iDAGl8=
Received: from SN7PR04CA0187.namprd04.prod.outlook.com (2603:10b6:806:126::12)
 by CH3PR12MB7570.namprd12.prod.outlook.com (2603:10b6:610:149::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.22; Mon, 3 Jun
 2024 14:15:55 +0000
Received: from SN1PEPF0002636A.namprd02.prod.outlook.com
 (2603:10b6:806:126:cafe::4) by SN7PR04CA0187.outlook.office365.com
 (2603:10b6:806:126::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.30 via Frontend
 Transport; Mon, 3 Jun 2024 14:15:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002636A.mail.protection.outlook.com (10.167.241.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Mon, 3 Jun 2024 14:15:55 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Mon, 3 Jun
 2024 09:15:53 -0500
Date: Mon, 3 Jun 2024 09:15:37 -0500
From: Michael Roth <michael.roth@amd.com>
To: "Gupta, Pankaj" <pankaj.gupta@amd.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <qemu-devel@nongnu.org>,
	<brijesh.singh@amd.com>, <dovmurik@linux.ibm.com>, <armbru@redhat.com>,
	<xiaoyao.li@intel.com>, <thomas.lendacky@amd.com>,
	<isaku.yamahata@intel.com>, <berrange@redhat.com>, <kvm@vger.kernel.org>,
	<anisinha@redhat.com>
Subject: Re: [PATCH v4 00/31] Add AMD Secure Nested Paging (SEV-SNP) support
Message-ID: <3j2llxlh3gzyn33n6uo7o5jdx4dmi4rzbax5buluof5ru2paii@2ze452jtocth>
References: <20240530111643.1091816-1-pankaj.gupta@amd.com>
 <CABgObfYFryXwEtVkMH-F6kw8hrivpQD6USMQ9=7fVikn5-mAhQ@mail.gmail.com>
 <CABgObfbwr6CJK1XCmmVhp83AsC2YcQfSsfuPFWDuxzCB_R4GoQ@mail.gmail.com>
 <621a8792-5b19-0861-0356-fb2d05caffa1@amd.com>
 <CABgObfbrWNB4-UzHURF-iO9dTTS4CkJXODE0wNEKOA_fk790_w@mail.gmail.com>
 <05d89881-bdbd-8b85-3330-37eae03e6632@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <05d89881-bdbd-8b85-3330-37eae03e6632@amd.com>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002636A:EE_|CH3PR12MB7570:EE_
X-MS-Office365-Filtering-Correlation-Id: a9cbc08e-075e-4921-be13-08dc83d7aef1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|82310400017|1800799015|36860700004|376005;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Mk85c0Rad1NmTVZ2N2cxalVmcm8wRTZFdW45RjB0QmplNzh1Y1RzbnZlREJC?=
 =?utf-8?B?MytJTWp2cUlab3lzd2FKV1NlOEdpUEZaYkx6cDdLTTNhL0FPcENOb1dKZFNy?=
 =?utf-8?B?ZlJvbUtjTmNEVjVjQTZVa2tQdVpuN2lYNnlFOEp6UlJPQmpvd1J5SU1iQ0Vj?=
 =?utf-8?B?OGxWTWFOdFpxYU9LYTdFRnVQRE93S1hoQkdmUEVvN3Y0UnVrR2N1L3RsTjNl?=
 =?utf-8?B?UmhLOE5kY2QxRllGMWdEdHFjSm9LQ2JzMW5CRVRGRjAraE1HZERxalk0QTFX?=
 =?utf-8?B?ZTlxUGhZVzE1cTRDeGF3L3RRbXhsK2c0QWZwREhrSjRMeTg5NWFTaVpwdndi?=
 =?utf-8?B?YXBiZ0llZHE0V2ovcDNBMFd3VFJNUW1vc3hzbjZ5dWxDRmZqSkNiMWI4S2I3?=
 =?utf-8?B?RG1JdVhMcFZZUUw2dGJ4Qi9JbmVGTThBTDIzOEpjSVZpK015K1pZQmJ3TVQ2?=
 =?utf-8?B?UVNuUi9rV1ZjaEhaVVd5YkM5NUtCOFppckFtRklHa0FpYjM4SUErbHRTazJP?=
 =?utf-8?B?WC8vcVl0N2ZrVklBbTM1M1JLY0FpYVh2UURhVWtTRThLNnhQRThKang2bzlh?=
 =?utf-8?B?bThIMy9GYWxvdzZhMjJacDB1MjJZWnRNOEE3bmpDenVxZnBVK3NlY3lwdjFk?=
 =?utf-8?B?SjhwMkVWTDRYYUJTTWJLalRxWEVGZFdaZDQyUUpyNkpEcC9UVHN4V09wTEl4?=
 =?utf-8?B?aCtkdHRGL21Xbnk0aGtLT1J1cXEreTZQZk1aSlloVEFKbXRkUENtcCtOaGU1?=
 =?utf-8?B?QlJKcURZeTYyNmJDamV3SER1eDdMUlRtVWIzTGEwNENVS0Q3b3gvb3F6RW50?=
 =?utf-8?B?dzM3SjV6anFjR1puYzdqWVZYbWJWTHVoQ2wrek94VVR3bS9PeEttWW9NaU1X?=
 =?utf-8?B?dU9qb0w4Zi9lblEzNlpzV1JTakFtMDVhdkVSL0FvR1FQclhzNXA4VG1MVVhH?=
 =?utf-8?B?c09wdkFyTUJyMjZxcnZtS0xXL1ZHcW5VbHF2NmVNTlRwRWRIWTV3Qmh6a2xD?=
 =?utf-8?B?clRQUnp5dnNveXhtMzRldnZ5Ty9pNGhhWWdYZWM5eCtTZGVZZUtkVkMvUk0v?=
 =?utf-8?B?R1ZSSGZib0tBdjZjRWY1cXo5NzNkZ0VQWjg3R2RzeEFoMiswSDNNb3JhRW5p?=
 =?utf-8?B?NWhZWFkxdFRlUVRwcDBvcXdaelI3dlNCb0FpelRFQml0ejBCMndYOVFTTzU5?=
 =?utf-8?B?WVhlSDgvSXpEckp1SGNtV25rL2EyS24zbi9IWXMwelJPMXJTVFNwOThOYkxR?=
 =?utf-8?B?NVJESDZ5cXNqUTNvdDJaZlJMV205SENxU1BVM1pMME1aZy9XSXZkdVRSRCtZ?=
 =?utf-8?B?bXY2S2JjbHIxcU5XY25FRlRhb2xjcFdvcis5U2FyeTVUenpZVXQ5dVJSS2NK?=
 =?utf-8?B?a0NkRVJhYzhiVHlYOG1odk1oaHRuQ3JJNUc2VEkyTll3SWxoV0hLVEtuN1c4?=
 =?utf-8?B?dHJjazc3WG1BcXV1SDFIWjdsYnFWSVRTUUJ1b1JmVjJOWWgrSmZOd1psQ2dI?=
 =?utf-8?B?RFIwZ2pzRHMyckRrVzNETWFiWUttK3Q0U3AwWk1sTi9oMm11YU9PSDEvTFoz?=
 =?utf-8?B?YUtlZytoVFRZMkZ1V1d0YkdFcE44TlI3YjZqaEs2VGtmYkc5VnFMdzFnU3BN?=
 =?utf-8?B?bWIxMm4zYkszRmFaN2NaUXJuRVVxbnFHcXVTY1FZNHo4NEZZQmdBbmtYY0Iy?=
 =?utf-8?B?aVNhWkd6SWs3Vzgvc3hhYWNxakdiQUsybFhobUhtemU1a2JIODZ2bGxZeVBX?=
 =?utf-8?B?aHFJbWZwU0Z2RmtTRFc5OExPdnlvU2hDUjNWVk1kRmtOdUk3NTgwMmpoYnJt?=
 =?utf-8?B?OG1idHpTbWx0NEk1V0IyaWRCZURidytLWXRXTDB3QTViOC94MUtGSmQyR0tM?=
 =?utf-8?Q?Vym8dD5/Q5fHx?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400017)(1800799015)(36860700004)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2024 14:15:55.5272
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a9cbc08e-075e-4921-be13-08dc83d7aef1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002636A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7570

On Sat, Jun 01, 2024 at 06:57:21AM +0200, Gupta, Pankaj wrote:
> Hi Paolo,
> 
> > > > please check if branch qemu-coco-queue of
> > > > https://gitlab.com/bonzini/qemu works for you!
> > > 
> > > Getting compilation error here: Hope I am looking at correct branch.
> > 
> > Oops, sorry:
> > 
> > diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> > index 96dc41d355c..ede3ef1225f 100644
> > --- a/target/i386/kvm/kvm.c
> > +++ b/target/i386/kvm/kvm.c
> > @@ -168,7 +168,7 @@ static const char *vm_type_name[] = {
> >       [KVM_X86_DEFAULT_VM] = "default",
> >       [KVM_X86_SEV_VM] = "SEV",
> >       [KVM_X86_SEV_ES_VM] = "SEV-ES",
> > -    [KVM_X86_SEV_SNP_VM] = "SEV-SNP",
> > +    [KVM_X86_SNP_VM] = "SEV-SNP",
> >   };
> > 
> >   bool kvm_is_vm_type_supported(int type)
> > 
> > Tested the above builds, and pushed!
> 
> Thank you for your work! I tested (quick tests) the updated branch and OVMF
> [1], it works well for single bios option[2] & direct kernel boot [3]. For
> some reason separate 'pflash' & 'bios' option, facing issue (maybe some
> other bug in my code, will try to figure it out and get back on this). Also,

Paolo mentioned he dropped the this hunk from:

  hw/i386: Add support for loading BIOS using guest_memfd

  diff --git a/hw/i386/x86.c b/hw/i386/x86.c
  index de606369b0..d076b30ccb 100644
  --- a/hw/i386/x86.c
  +++ b/hw/i386/x86.c
  @@ -1147,10 +1147,18 @@ void x86_bios_rom_init(MachineState *ms, const char *default_firmware,
       }
       if (bios_size <= 0 ||
           (bios_size % 65536) != 0) {
  -        goto bios_error;
  +        if (!machine_require_guest_memfd(ms)) {
  +            g_warning("%s: Unaligned BIOS size %d", __func__, bios_size);
  +            goto bios_error;
  +        }

without that, OVMF with split CODE/VARS won't work because the CODE
portion is not 64KB aligned.

If I add that back the split builds work for qemu-coco-queue as well.

We need to understand why the 64KB alignment exists in the first place, why
it's not necessary for SNP, and then resubmit the above change with proper
explanation.

> will check your comment on mailing list on patch [4],
> maybe they are related.

However, if based on Daniel's comments we decide not to support split
CODE/VARS for SNP, then the above change won't be needed. But if we do,
then it goes make sense that the above change is grouped with (or
submitted as a fix-up for):

  hw/i386/sev: Allow use of pflash in conjunction with -bios

and untangled from "hw/i386: Add support for loading BIOS using
guest_memfd", since that's the patch where we actually start dealing
with non-64K-aligned OVMF CODE images.

-Mike

> 
> For now I think we are good with the 'qemu-coco-queue' & single bios binary
> configuration using 'AmdSevX64'.
> 
> [1]  https://github.com/mdroth/edk2/commits/apic-mmio-fix1d/
> 
> [2]  -bios
> /home/amd/AMDSEV/OVMF_CODE-upstream-20240228-apicfix-1c-AmdSevX64.fd
> 
> [3] Direct kernel loading with '-bios
> /home/amd/AMDSEV/ovmf/OVMF_CODE-apic-mmio-fix1d-AmdSevX64.fd'
> 
> [4] "hw/i386/sev: Allow use of pflash in conjunction with -bios"
> 
> Thanks,
> Pankaj
> > 
> > Paolo
> > 
> > > softmmu.fa.p/target_i386_kvm_kvm.c.o.d -o
> > > libqemu-x86_64-softmmu.fa.p/target_i386_kvm_kvm.c.o -c
> > > ../target/i386/kvm/kvm.c
> > > ../target/i386/kvm/kvm.c:171:6: error: ‘KVM_X86_SEV_SNP_VM’ undeclared
> > > here (not in a function); did you mean ‘KVM_X86_SEV_ES_VM’?
> > >     171 |     [KVM_X86_SEV_SNP_VM] = "SEV-SNP",
> > >         |      ^~~~~~~~~~~~~~~~~~
> > >         |      KVM_X86_SEV_ES_VM
> > > 
> > > Thanks,
> > > Pankaj
> > > 
> > > > 
> > > > I tested it successfully on CentOS 9 Stream with kernel from kvm/next
> > > > and firmware from edk2-ovmf-20240524-1.fc41.noarch.
> > > > 
> > > > Paolo
> > > > 
> > > > > i386/sev: Replace error_report with error_setg
> > > > > linux-headers: Update to current kvm/next
> > > > > i386/sev: Introduce "sev-common" type to encapsulate common SEV state
> > > > > i386/sev: Move sev_launch_update to separate class method
> > > > > i386/sev: Move sev_launch_finish to separate class method
> > > > > i386/sev: Introduce 'sev-snp-guest' object
> > > > > i386/sev: Add a sev_snp_enabled() helper
> > > > > i386/sev: Add sev_kvm_init() override for SEV class
> > > > > i386/sev: Add snp_kvm_init() override for SNP class
> > > > > i386/cpu: Set SEV-SNP CPUID bit when SNP enabled
> > > > > i386/sev: Don't return launch measurements for SEV-SNP guests
> > > > > i386/sev: Add a class method to determine KVM VM type for SNP guests
> > > > > i386/sev: Update query-sev QAPI format to handle SEV-SNP
> > > > > i386/sev: Add the SNP launch start context
> > > > > i386/sev: Add handling to encrypt/finalize guest launch data
> > > > > i386/sev: Set CPU state to protected once SNP guest payload is finalized
> > > > > hw/i386/sev: Add function to get SEV metadata from OVMF header
> > > > > i386/sev: Add support for populating OVMF metadata pages
> > > > > i386/sev: Add support for SNP CPUID validation
> > > > > i386/sev: Invoke launch_updata_data() for SEV class
> > > > > i386/sev: Invoke launch_updata_data() for SNP class
> > > > > i386/kvm: Add KVM_EXIT_HYPERCALL handling for KVM_HC_MAP_GPA_RANGE
> > > > > i386/sev: Enable KVM_HC_MAP_GPA_RANGE hcall for SNP guests
> > > > > i386/sev: Extract build_kernel_loader_hashes
> > > > > i386/sev: Reorder struct declarations
> > > > > i386/sev: Allow measured direct kernel boot on SNP
> > > > > hw/i386/sev: Add support to encrypt BIOS when SEV-SNP is enabled
> > > > > memory: Introduce memory_region_init_ram_guest_memfd()
> > > > > 
> > > > > These patches need a small prerequisite that I'll post soon:
> > > > > 
> > > > > hw/i386/sev: Use guest_memfd for legacy ROMs
> > > > > hw/i386: Add support for loading BIOS using guest_memfd
> > > > > 
> > > > > This one definitely requires more work:
> > > > > 
> > > > > hw/i386/sev: Allow use of pflash in conjunction with -bios
> > > > > 
> > > > > 
> > > > > Paolo
> > > > 
> > > 
> > 
> 

