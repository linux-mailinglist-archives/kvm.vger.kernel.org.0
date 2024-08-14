Return-Path: <kvm+bounces-24092-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 23F42951363
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 06:14:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 99EB61F23CFA
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 04:14:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D41149650;
	Wed, 14 Aug 2024 04:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="poGyrZl+"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2087.outbound.protection.outlook.com [40.107.237.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7142639AF4;
	Wed, 14 Aug 2024 04:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723608887; cv=fail; b=nGF0ZG2TLinIJw7LvzwK12B/2EgFa2RXkS61fZdLcQ5TM8ldO4arLUBX8nwAGNB6ad88DyxI7PNk/IQqHIEITksdg/PBE9iW5+1V99G3KIzoGyMjx7n3FcwsyEkuymvG1kfLfNyUv8avapzcUE/DwtKpLMu3ST15IWBbs4irWb8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723608887; c=relaxed/simple;
	bh=UNPqglSjTgF6HHoD39qgdZ8wojnsB6odL7Qi9AZqYrc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QHEznafLl9FmViXprvA5Q2YJokbBFLd4nEwiPqgqqCny5B2oVvhOe/DeowQ0Pw+ou1Vqnv/q75mjMaMmtC9OMQh5Vv7rvT66JGWZ966CQfaXSje1pIqmZKSPn9LTEs/RGEWKMVzKWpE2dLPeCAhUN7W1ojQo0cmLf04741itckU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=poGyrZl+; arc=fail smtp.client-ip=40.107.237.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UswidfctrcRQxMCkbi6psREHW/8fIACl4Y5Rd8yAJn83PhRWN3AinOcCXGiRNkNu+JDTnqSPNUwLHy3mMR6gvMFmp7hRhmP5oAJLMPFFpKYDjq1Tkb6N7/8hp3KZIUDe1+D8+0xHU2hPM5kqnibzCx8gx/7gOOkcl4abGLYKLhIZsWFcQhGlvUsBR5FvTkeNHHru04GlsePQ111kQrQyNIAySZ5rCrbITVhcFPijooLaFbVooL25cpOMviUVB7TqurIXFYYFe78NBMF0ArokAO3IE6ncKfuMVeinSE5l7CxHwiCEHH62mOgzaNa5/5FfY16soWCyINHvfiZHcWQQdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xTRAeyof+5VgsMxwk1LXmbrRItlJSE12r2NPk43M/A0=;
 b=zDstJJewcrMxv0Y6i6Sb8Eg5JHwNln1qU/mdP3491UHrILKNb446MZ/3pRxv8V+RQDWPXxFTqNSFoSIJb/Q/Ss8IdYWM1BY9htPH28Uh7aJ+49mYexYgLxUADe8BAu7wwDQV5+ClsbRuOnWrtWcY/t7R794vk20Zx3CDkO2gFHH8aBJ/B/Y2ex/cLHhH5DoeenbLDykwLva/RcEILrGg+x1hMuN6yEFxHcvCI/Ocnir+48TsbXGFn9iKTP+/iHYFHcWcR7MANrcXPWjt5tcH0Z6zB8yUIdyWJdmf4HWH0uMTsJLEOfWkcmTfhjiZ7FGUgEJnmBt8ojd9AkKTknt7/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xTRAeyof+5VgsMxwk1LXmbrRItlJSE12r2NPk43M/A0=;
 b=poGyrZl+ekSrLVbhb1qvnth7OR2sKO4FR5gnJBLTQhXrbej5Pn4mUxyclIl4Ug24+siQ54a2fGw32+hvLuzvnDbptrmYG6mzXRHPeruvLNcM4RL+SYI88LXAAH8yS99vZF9GaOnbxOr2qefbqK1TZmVxbX6lysU6NwW9LQ6v2jU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 MW4PR12MB6951.namprd12.prod.outlook.com (2603:10b6:303:209::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.22; Wed, 14 Aug
 2024 04:14:42 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%6]) with mapi id 15.20.7849.023; Wed, 14 Aug 2024
 04:14:42 +0000
Message-ID: <3fe8b6d0-f01f-ea12-c04e-1e69a8697e19@amd.com>
Date: Wed, 14 Aug 2024 09:44:32 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH v11 00/20] Add Secure TSC support for SNP guests
To: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, bp@alien8.de,
 x86@kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com,
 kvm@vger.kernel.org
References: <20240731150811.156771-1-nikunj@amd.com>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20240731150811.156771-1-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0246.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:21a::16) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|MW4PR12MB6951:EE_
X-MS-Office365-Filtering-Correlation-Id: 70608f7a-0a8b-4ece-6020-08dcbc179f1a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	lN7IrCm/DUsBIpXYY0smlJbB9cyRCecnYfvzKGHSz7Z/rvi6Qu7NjuXOfKm8/RAYdGHnfFgYT2+NvTsYiP9OTC2qMK5MePA+zXxvy05DsZfYoh1EDO32enwd171HBmpGrL4VSbwFpwJt9rIba7zNs8i/4PFl7Fsp+6J5/9/AR2a+mXImma40a2gAioiKNOcIZwjr6zkHNTwAnZDnQjU2yCcqY1E5w5tmIDFxFLOpbHeKokWxdwWba4qzjrHLB/VAMsAtol7hnpID1cqA41KJjffae4vHC2m3k7Y7x8/xxEE/ReFn63B493Z/tjD5TZynrd3tD4f2e0w94zriHVfiFE/fX+Gfh6JucjXkMC1qLEadGTxYYduMhcd2oTqTQlxLlbV/fviIl6ZwqvhXPuwZCUSuJ5P9U/Vg1/ou0Ewds4DpWVkeNgUsLnQNK+3NCAMDZ2S6kKs4WJ/6/m4xaP6QbhXGKbUSx4+D7yD0XSSyg8PKpMEQqJ0sVPlc9v0dBkYpLQ3Vzuc0MjoYTv4ben579S2wOuxaWoMF155urkA6OPHiPD9dOvCWfqHvdxGF579qln6TnoS2uE8GAWf3TzYRQWxv0SljM/RriacH3Las75Q=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MXhxYkpZUmp2alBqWmtONmcybTFWOGZRQzhOQzZEZmx6K3hRT0dIWkhCQ2ZT?=
 =?utf-8?B?VnlpV0FhWGFNSjNraTFrQmtseGdsMWNKL29YOFhJOThxVEFSYm1HNDlYdG92?=
 =?utf-8?B?Y2JCbVhEQ3V2bTRXMzNCZk9TRGU3SDYvTnNaalZYdFFPL2NsWWlPeUJRdm9n?=
 =?utf-8?B?RlNzcUZtUXIrQmZmWk9qYVNMam01amlEVHJiZFllTHhGK05zNVFWd09sazQ0?=
 =?utf-8?B?TkRCVVNqd0dIR3ZMa3NWRGRJTENnYVdnSUZNaXVWcG0wdkdGeGVMTDNIaUY2?=
 =?utf-8?B?bFl5S1hwU0U3MGR0ZTRHbUkxVk5wWkVoei9yRVErd2k2UXBnd0t3V2U3MHpo?=
 =?utf-8?B?ZHEzcVFiV25lazBtZitYSDBQVE1OZytpczFzM3RWdnQrbTlwL1d1V24vYWll?=
 =?utf-8?B?dlRVV1FoOHcwazdwUXFJYTdYbUtoNGNHUno0Z2R5NXVHbE5MbEhHUTlwbU16?=
 =?utf-8?B?VkhJU0o4RkhJRmdBQVJGU05ISFIwRWhmejUrN0I5T2Mwcm9sR243djlIRlc1?=
 =?utf-8?B?N2hrOHJHbXFpRkhBUnMyTVVFQVppRGU3UUVXUVlDcUZZSHJSSVVpcTJFNVN0?=
 =?utf-8?B?MU9QNXA5cnVWL2l6dlRGaldlUWprRWVnaSszZm9FaHAybGhCamRCNDZSbCt4?=
 =?utf-8?B?OWxrSFMxck0zMjZ3UU52dXdMeml2bHhQUkdlYTg0TDMvbS9sbGJQQklIbU1N?=
 =?utf-8?B?TTVkd0N1eVZiVUdYZkhZY24wU0RBbStML1Q1cVZpd1pjQUhMazFHaFV2aVN1?=
 =?utf-8?B?NllHckgwQ0NNaUg5N1NDV2U2UURYZ2syNmxiV1BSdFlyeUl3eCs1UWlzbFFM?=
 =?utf-8?B?WjhncUNxcjBERjQvMEpBOTRLRVZOUVo2dXhWRitmTWZFM2xTaXVBRlJRY1Ji?=
 =?utf-8?B?WEdvb3hzMUNHMVdDclVuamlUbWt6cWpmT3AyUk9JVUswNVVXT3NUVXc0U3RD?=
 =?utf-8?B?M1h4aUxFTzcyb2w3UTlEQVl0RWIyemtQTHJ1SFNrZWFRZFBxZ1ZsZi9LcUJS?=
 =?utf-8?B?YWZhR2FNbW9KR3BuVjZtQTRDaHZwODUvYmdpY3NBOWdDS1BaelpsakdsVS9Q?=
 =?utf-8?B?cFUvVDV1UEdtQlF2RFNxd2gvYVdHRTc4N3JjQVdhREVYV0hITkViWDBnWVhp?=
 =?utf-8?B?VnBEWDM0czVlOXB0aEwwaWo5eHh5RmJLMy9BT0NBdy9lRm9oS2g0bGNhcUx4?=
 =?utf-8?B?OW40SjFkKzlFMlNtbTM3WVdqUXRXc0hwRTFhc29mQjJlVzRZbDB4Q0ZGd3Ay?=
 =?utf-8?B?S1JlRmVJRXU5REl2WGhVenQrQWt3YXBib3AxeFlxU1Q2dUtBaWlYTHVuYi9j?=
 =?utf-8?B?QVNXaWdQTVpsVS81TDJlSHUyTHE5U25lUUp6S2FBZFZhMW9RMG04T2ZKTkhO?=
 =?utf-8?B?MjhVbXdkSURDTysrR1ZndThJcTlUdTVsSlg0R3RhSndxR1l1YW5hUU5wMUlu?=
 =?utf-8?B?d2tZOGJIMGROM3FwUTJ4TWZyVzlnV0xiUGpmTVpkMEhsTWNiY2cwRk5MTE5C?=
 =?utf-8?B?MlBQMmo0Zjh0STcra3NhMUJneThXeDIxU0JXWk5XVlAydFFKdmVqempFNkR6?=
 =?utf-8?B?K3pBYXJwREJJQTM3OHFELzhNSG51aUlucGVCR2ZPNElzYjNlMml5elByVERU?=
 =?utf-8?B?enJJdnA2R045TUFSQnBMVkZwMTMydE13ZmpPZndNSmoxRk9xME9IVnM2WEIr?=
 =?utf-8?B?eDk5WWlEUUNIZlhlS1grSVhPMmxNOTk5bHZ3SEhUazN3Y3VsNS80M21NWWVh?=
 =?utf-8?B?TkQzRWtLcnZKcW0xUGNMMTJTQnZGVDRQMTN3QzhlTDFQYTlUNGJMU2d6bGJR?=
 =?utf-8?B?Y0crUFUreVl3Rzc0Z0Z6Q0pOczFpZ04xOE04MHl2NnVJZnliWmM3TGlvY2RN?=
 =?utf-8?B?Rlg1OEpSdlVudFZScFRFYm8yU2Q2aGZ2N3A3aHBpdStGeUtiMWwyemhNR2FQ?=
 =?utf-8?B?QWxQeldZZzljWUVHeEVtVm1SWEpQNGtvQ3VkQkd4b0tyNUJXQ2JNSnk0OGR3?=
 =?utf-8?B?YTJKVmxaSWVmWUpvWGdMNWRiNzRIdDJtajVpU1N2WmJvM2FxN2FPejZ1c3l2?=
 =?utf-8?B?S3c4MHRDSFBTUm1XUHNrWTFwcHNDbURpbVo3MWFNTmVhVElLaFJVcUcvRkhX?=
 =?utf-8?Q?YJvaQoWmfpK5TYzERjP1e4AOT?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70608f7a-0a8b-4ece-6020-08dcbc179f1a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2024 04:14:42.2645
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sMsHGY2l5TRaFGDD6M8HKHNJtDJG2uK6pLEs14NCs419LwoDngmsAl7dfE6JOmX++s7gjcK448e1yopaAWaZ9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6951



On 7/31/2024 8:37 PM, Nikunj A Dadhania wrote:
> This patchset is also available at:
> 
>   https://github.com/AMDESE/linux-kvm/tree/sectsc-guest-latest
> 
> and is based on v6.11-rc1
> 
> Overview
> --------
> 
> Secure TSC allows guests to securely use RDTSC/RDTSCP instructions as the
> parameters being used cannot be changed by hypervisor once the guest is
> launched. More details in the AMD64 APM Vol 2, Section "Secure TSC".
> 
> In order to enable secure TSC, SEV-SNP guests need to send TSC_INFO guest
> message before the APs are booted. Details from the TSC_INFO response will
> then be used to program the VMSA before the APs are brought up. See "SEV
> Secure Nested Paging Firmware ABI Specification" document (currently at
> https://www.amd.com/system/files/TechDocs/56860.pdf) section "TSC Info"
> 
> SEV-guest driver has the implementation for guest and AMD Security
> Processor communication. As the TSC_INFO needs to be initialized during
> early boot before APs are started, move the guest messaging code from
> sev-guest driver to sev/core.c and provide well defined APIs to the
> sev-guest driver.
> 
> Patches:
> 01-04: sev-guest driver cleanup and enhancements
>    05: Use AES GCM library
> 06-07: SNP init error handling and cache secrets page address
> 08-10: Preparatory patches for code movement
> 11-12: Patches moving SNP guest messaging code from SEV guest driver to
>        SEV common code
> 13-20: SecureTSC enablement patches.
> 
> Testing SecureTSC
> -----------------
> 
> SecureTSC hypervisor patches based on top of SEV-SNP Guest MEMFD series:
> https://github.com/AMDESE/linux-kvm/tree/sectsc-host-latest
> 
> QEMU changes:
> https://github.com/nikunjad/qemu/tree/snp-securetsc-latest
> 
> QEMU commandline SEV-SNP with SecureTSC:
> 
>   qemu-system-x86_64 -cpu EPYC-Milan-v2 -smp 4 \
>     -object memory-backend-memfd,id=ram1,size=1G,share=true,prealloc=false,reserve=false \
>     -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,secure-tsc=on \
>     -machine q35,confidential-guest-support=sev0,memory-backend=ram1 \
>     ...
> 
> Changelog:
> ----------
> v11:
> * Rebased on top of v6.11-rc1
> * Added Acked-by/Reviewed-by
> * Moved SEV Guest driver cleanups in the beginning of the series
> * Commit message updates
> * Enforced PAGE_SIZE constraints for snp_guest_msg
> * After offline discussion with Boris, redesigned and exported
>   SEV guest messaging APIs to sev-guest driver
> * Dropped VMPCK rework patches
> * Make sure movement of SEV core routines does not break the SEV Guest
>   driver midway of the series.
> 

A gentle reminder.

Regards
Nikunj

