Return-Path: <kvm+bounces-27192-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5946F97D0E3
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2024 07:15:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 782B71C215E5
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2024 05:15:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1E103A1B5;
	Fri, 20 Sep 2024 05:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="IPOBOpHH"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2075.outbound.protection.outlook.com [40.107.96.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A79B2AEEC;
	Fri, 20 Sep 2024 05:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726809331; cv=fail; b=piErlvcVPLP2gUpKbpA1QRO+KLHCLlsnd6Qte0ZlEH6opMvs51CSR1WOCTNccaE/i1Y5cLwPNtDWSOSR+BlfvzzZtIA2uZhe28eWQZYNmyjy2KQldKRqcnzOBPONtcaHL5KTw6fS35dZxa07huLeanqvBGbHW81P3iMPing6ZG0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726809331; c=relaxed/simple;
	bh=vJSy0RuU0u8xiWEfIi9F1qevmE2KPGGvJUESdk+/BKA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CQLqRqv6C8r1fGNTap2cPqVmr0DlloQViNFHV6t5OYMz6JTgLHi1/x6U3dNVQANfUZix5034huzHJqkwF9u/FmTtbQfjSoaM6YVq1ygVBcvkNqfHcAneKR6yLYoe6rsrWyw9dqpMxIDcreZDnx0lQCF9HKGYgVaOSo8VOD8zBzc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=IPOBOpHH; arc=fail smtp.client-ip=40.107.96.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cxZrSQ4MdNjteR2+4G3NLfY103jqAUq4JB4iyKqcwbFUOUA89aDqLb43V02wnlk2CDfxzoTt2TPWNsyGrgUGAXpMBmgc7FrYWSQoa8C0DwQTmhlvyK7nrkTXU4ahrGA1GNS8TY+sYAKstrcgwttLDu9Ohai709IQvyb0vgZI1BO5gVYbkVlfeMXX9gzjUyX0sdAaTOJiYpsy/qFGSw02gBy3BucdPP0nwb8o+J35JtG1oe3hZVM+XFC9y/nMW/P/xJ7Jf4FtFABzIH1ThqqySL90YEYsZXdI6KgY/NQx+WazK6DG8CZNFjgN3meNZZ+Cbu3VJcYOyrJsic5tBCAncA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o2WDXyzQB3xqULWYSnspG4wF7WwyZD159Zouo5R95Tk=;
 b=EmX9DqXQ6iRpXQ0E50s5iPhiwL4rzJZtB9krV9ylFxGv7SYtrvgGCxH7vtAv1LsNSlD3oXmJ8FxAVTVhHgweilr4uVLBLg155lV+PejM5vgNG0496yT/Aq9bz5tgpZK294fJs3n6G52nW7zaQ+5/FpJitn1pnk7KgSSCTeKNMoJMQ4vXwL0dfdn0Dk2Z4dTfMw1B/JC6v1gxV3Cr0qwX5J1Ad/IpTArTElMy6iQFLvbobOjTEhOPUAAeNdz3AaJWX38H8XNY9rb0eBlU7BShHxYhVkpJqKjnSvfJkUk+QT8RUcBiREamyLGDZjk2x4D08ukeGOyaSFCyEGMOVVuGlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o2WDXyzQB3xqULWYSnspG4wF7WwyZD159Zouo5R95Tk=;
 b=IPOBOpHHI6ieOTN6nDREs5xMadjAl6Y1PqBV8oDUnUE0lOjdX9AQkZNRMxIaSCNLPdnWfsW3fWioXBPFOYUhqpM4iXm/pHSM4TfWBkh+GEbcvpDr1FrzNSSxrqV97sFFGKpPtYiQ+wT0ql4W0fBAamM8pmU0qEhRryzEJnSECq4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 LV3PR12MB9356.namprd12.prod.outlook.com (2603:10b6:408:20c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.22; Fri, 20 Sep
 2024 05:15:24 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%6]) with mapi id 15.20.7982.016; Fri, 20 Sep 2024
 05:15:24 +0000
Message-ID: <2870c470-06c8-aa9c-0257-3f9652a4ccd8@amd.com>
Date: Fri, 20 Sep 2024 10:45:15 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH v11 19/20] x86/kvmclock: Skip kvmclock when Secure TSC is
 available
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, bp@alien8.de,
 x86@kernel.org, kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, pbonzini@redhat.com
References: <20240731150811.156771-1-nikunj@amd.com>
 <20240731150811.156771-20-nikunj@amd.com> <ZuR2t1QrBpPc1Sz2@google.com>
 <9a218564-b011-4222-187d-cba9e9268e93@amd.com> <ZurCbP7MesWXQbqZ@google.com>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <ZurCbP7MesWXQbqZ@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0195.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:be::23) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|LV3PR12MB9356:EE_
X-MS-Office365-Filtering-Correlation-Id: 0fc54d38-7421-43c4-3699-08dcd9333b74
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SEM5UERLOVpSTEs1NjdmbEtlZWtnL1lTUzlOUE90UmljZllQRjNXRnhiM3VB?=
 =?utf-8?B?anRzaEVrYzRJNnBYT1Yva2hOcHVRTHpVNDVab2lGUzUxai96VHdVRDF6QWNj?=
 =?utf-8?B?Snk2d210MHMvNnFPYWJaSDFEempwS0tzRXBLMG5pR0N6SG1YZVhQSVVFcFV0?=
 =?utf-8?B?anlYa3hzalhlZy90RHVUbjZiSEJaaFQ3RWh5VGlNUm16K0xDUzNEYkNIU3g5?=
 =?utf-8?B?MXZ3cUFrVFJrbkxBaytaL0Z1b3BsRTVPcTA3UW1jc3dNZDZLY2UrVFBmTTVs?=
 =?utf-8?B?VXJMUTFFV1llZktFQXVlbm9lLzh1RGU0OHVCQVhDR05OUFloelpDZ05nTUVy?=
 =?utf-8?B?OVRtNzJkYmpLcldJaThVemhLQks1MzVoVGJ6WHVxL1B1c3ZNL3VVU2piMUZV?=
 =?utf-8?B?SDFxSEtPK1ErakhNS29uY0lyL3FRVm1XVDhuVE5LK2JQRENYTjhuVFZLVmNG?=
 =?utf-8?B?T3lIRkJoeWswVzE3K1Z4S29PVWRWQlBwMDFWaHVSbVY2K1RPd05MMk1KZFNz?=
 =?utf-8?B?bXVLS0Z6a1RGMHc0WXExRG0yWnN3emVCQ3NtQVp5ZTZMS2QxWHZuWUs4dmFN?=
 =?utf-8?B?MXVkUzNjTXlYSEYzRS9TZEovTlVRN2Z1N0Voc1piZDFvSmJZSzBCaUZTTzlQ?=
 =?utf-8?B?SWdVNGxRc0kxWG4rNEVVZndtVEtibGhUUTV5M3FEczY1YUEyUGJRMHYvNjYr?=
 =?utf-8?B?N2N5d1BIcytubXFPTXIyaTlFWlJjcDRmTWI0cEtTVXpHeVFsZE94Z0ZFMTRj?=
 =?utf-8?B?QVZVVnNqNDdtMENRWmR5Kzk4UlpVZXgyNkRzQUh0WjhRK1FhbTFBQy82SWx2?=
 =?utf-8?B?akd3L2NYTkUwYlNGZVFJdkJJVG1JVDRzZlhMbyt2d01hYWhldHU3dzZZQXdz?=
 =?utf-8?B?ajIwbms4V3hOUXpjYmI3OVJ2QWN3TnJCbEhCSFBVOEhBN2xvaXVWZVpncldw?=
 =?utf-8?B?dGFzVWppL1JUbk53S2pkdVhoeEIxN2tMc2VSa0tuZmVLcE9hMXpVNXZrbTN1?=
 =?utf-8?B?RHJIRVBjQ0hNeEpoRGhGWDloWHk2d3g2TEdBb1VLazRKWno2SWxodUlSUXgx?=
 =?utf-8?B?VUhhdEhlOEp3MmZmQnZ4bHJEZGI2c1NkVHlrSlJHaTk3RW9sb09rM1RVZksy?=
 =?utf-8?B?Y0ZPWEpuUG5CYi9BdmxraGI1NlJVZXUraE9qZ0pOYnpnZElKLzBQRzBaR1Uv?=
 =?utf-8?B?N3ZPZWJzemRMdWZ1dFJ0bG5BbGpSZVFKTXg3eWc2Tm9pbmFGbnRXVjVLRTl6?=
 =?utf-8?B?ajJkMlU5VmJDNmdFSG1ZRldzdVBBc0ZkSC83UUhPa0s5U3NSbm1vbUdva2xi?=
 =?utf-8?B?cy85L3ZzaUV3a2wveEUvUjYyWDR1eVA1VDlsVTJtckl2ZitXS3NuZkJxdE03?=
 =?utf-8?B?VklpK2tvbUFsSnB5R1pqRlo2VjNBV2F0aUFqT0ZDWmNVU2FIUlpFOFlKbk0v?=
 =?utf-8?B?Vk5reEhwRjNxNElIOWg5SWhQQUE4M0gyVnQ2ZlMzR2RqcCtzMzM5THJQQ0py?=
 =?utf-8?B?SFFFT2xwRENZUWx4eUo4SmZkNmRqZlVINkJsTEdVWmM1NDhRL1ZqZEg2U3lT?=
 =?utf-8?B?RFAwY25QS1hjVVVUVzVOVVlxTGY1MTRjamZ3VXA3cGlFYjNzclZiT0ROOEdL?=
 =?utf-8?Q?boRVN4AgxuLZu6B2+Be9cKIo/74WvnwF9uKL5PBe3D7I=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QzdkL3ZPRXVhdjNwanV5MzhvNmw3UFpNdjdQQ0hqQnhSeS90a3B3YVQyM1Np?=
 =?utf-8?B?MDF6WGNWYmlReS9LWFdoZmJESlZXZkF5aTU1OVdyc0hkTGNwZ2tiUFpqQkZF?=
 =?utf-8?B?RWdRd0FoUmovMHpJZEpUQ0NrcEFCMXhWOUk3K0FkK2tFS1ZUYnpXSHRyVWJZ?=
 =?utf-8?B?Sm9xNkhFR0FtNTNBLzBLRGR0ZFg3U29tamxnUEsvckVmTjNKN0czQVRERStL?=
 =?utf-8?B?dGdzSWlhNE05VTZUL0RaYjFUOWsyaytYcG1XUnorOXlLZDhPbHZkRzdOdEhm?=
 =?utf-8?B?WUY5bmxtQXRhOXFEenVkL2I3UEZoSXZ4NFFhYmZjYTdhYis2Ry9ESUJLS05D?=
 =?utf-8?B?VUFYQ1NJTkVtSlIwVEFKZ0VXVCtuVk1nOWFWVnA1M2pvZU4rTVliT0pFck5a?=
 =?utf-8?B?cjFiMXRPSWZuM1RVU083YWF1bVNkUTRobVR4bEthS09vUU9hMVlzbXRMMTBq?=
 =?utf-8?B?eHgzd3BNblBpalVVcTV6S0tzMUdzS3VSb2owcEZHNnJ3RWsxcHVrMGNKWXdj?=
 =?utf-8?B?ZTgzclNTdHh6UE5YalArY1hhMXl4ZnhxMVVMVVlZdko3Zk40MWc4UWFiRnFN?=
 =?utf-8?B?ejcxRjV5dG5hRjNReXNmQkREM0tMNHZ0c1g2ZVc3ZFFHdFZONkgxSDBxZHBZ?=
 =?utf-8?B?NWVZQnhmU29xeG1WQ3k2YTRpUVJ2NlROME9ZaFF2KzhnSzZLRld0OGl4c0tB?=
 =?utf-8?B?MlpDcXhnZGxCQ3lYNFVxZWdxM1NpZ3VVZTlZUEZTcHFSWEF0Qmc2d0FFalEx?=
 =?utf-8?B?czl3eTBIdUkvMHhCWno0b3RRak5ReVordGRmSlpDWVBVQTFDVG9VRkdRY0pK?=
 =?utf-8?B?bTF2QVY3LzBZUko0VkMxamNTL2FacUFzeWROVTNXdTgxUm91VHEwZnRnNnBS?=
 =?utf-8?B?ektldDh2TTRIODZTYm9Zd3I4K3ZMZWJvVUtMR0k1VUxBSm12citJOGVsb3Ji?=
 =?utf-8?B?anVyb1FNSDF1TG1IdTNDNjdQN2ZpNVNGNHBMSSthZ1Q3Q0xDNlRvRjB3OEFN?=
 =?utf-8?B?MWFuVDZHQzQvVFFiM3RTbWh3NWhTay8wMklXM3htK2tQV2FVOGNEZTMrZFRX?=
 =?utf-8?B?UExnSm1xcUZSOWRnZ3RFVCtDUGdyWEpHditsSzdONThnZWpzY3lQQnlzdlJm?=
 =?utf-8?B?ZnBBUW4rTVM5SUdqeEZjd05yYVNSNWxhVDlSNHFKNmRCRU9NQTc4M2d1U2lq?=
 =?utf-8?B?THdodjI1bTNwU2FsdjJ0ckREcXBhVE8rcGpiaDI4OGRHeHY3YWsyVWwxNGcz?=
 =?utf-8?B?ZWMwUStJOXhWbWlkNCtVOURrTU5pUkFNZndnODQ5TlZ4eUhYR3RXUCs0dmc5?=
 =?utf-8?B?bThaMlc1RHRMYWtWYTdJbno3RSt6ZGRLd3VZbmEzRnBYNDFvbWM4dG9QZ1FD?=
 =?utf-8?B?WVBXempJN3hCZXRtdGkwaldxQ3lBa1p1QnRQRE8vOGx4L3JyMjJYN3FzcCtS?=
 =?utf-8?B?aCtOeEdLL0QraFNQU2ZSZ2R6emlIa1NWSUhvYlFDMlB3SnhpMkM2bFVZRk5E?=
 =?utf-8?B?SzEwV1JVTm9LbkV5bWVpa05oc2hmVENhdHIzYXlMWkdmQWFrQldXc1dYUmkw?=
 =?utf-8?B?bG83WHViT2VLN2Y0U1VqSllKOXlyS1J4dVJTMGdQcU1Oa1RjL0NLL3BBQ2xT?=
 =?utf-8?B?V2pBVjdJZ2ZneEVob3JPSWU4K0l5RzhpM01VTmQ5VWE3WmdQTFRTdWdHM29K?=
 =?utf-8?B?OUxvS2E2aGFCc1ZUS3phYW9INU44Uy9rc2I1elBXcTBOaml4T3pJdGhFUnFt?=
 =?utf-8?B?R3gwcjNOeWc5dE5hbStaQ09qK1FSejJVUlJ0eFVmOW8wOXhMaWM1U3I4Tk54?=
 =?utf-8?B?MUFsZmI4TFIyUEVPNUFjQUdUV1J3anhWMkE1K3pYcFNlTUJVWXVxd2JtTVQr?=
 =?utf-8?B?Y2lHalJUMTZLclpyS2pyZExtYkJUMzlLaUV5NGo1djRGTE9HWWFFeFNBRVFM?=
 =?utf-8?B?RVFJYVlVZVZ6ejc2aXlJSkxPTDVpdVM3Ky9Bc1Y1RlVlVDBKVTVhMFQzY3Uv?=
 =?utf-8?B?OUdvQVV0eVFtdDdZQ296YmxwY1cxWEhIdUJQYmcwQ0ozQ3cycDZSMERhdnMy?=
 =?utf-8?B?cm1NcVAwSnphWGYzZjVDTTJvWGozOTZnc1FuWmV1VklGaHF3U0w0RyszdkJG?=
 =?utf-8?Q?huAZP721kuxhuJJRxKp8OfR05?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fc54d38-7421-43c4-3699-08dcd9333b74
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2024 05:15:24.7561
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zgu97vixPd3/xi4FpKvQvRB44loWWBUnGs8u461K1UAsrYNvThpnCQpcwLUcZM2pSr6gnQLitY1My+mHI6J04Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9356

On 9/18/2024 5:37 PM, Sean Christopherson wrote:
> On Mon, Sep 16, 2024, Nikunj A. Dadhania wrote:
>> On 9/13/2024 11:00 PM, Sean Christopherson wrote:
>>>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>>>> Tested-by: Peter Gonda <pgonda@google.com>
>>>> ---
>>>>  arch/x86/kernel/kvmclock.c | 2 +-
>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
>>>> index 5b2c15214a6b..3d03b4c937b9 100644
>>>> --- a/arch/x86/kernel/kvmclock.c
>>>> +++ b/arch/x86/kernel/kvmclock.c
>>>> @@ -289,7 +289,7 @@ void __init kvmclock_init(void)
>>>>  {
>>>>  	u8 flags;
>>>>  
>>>> -	if (!kvm_para_available() || !kvmclock)
>>>> +	if (!kvm_para_available() || !kvmclock || cc_platform_has(CC_ATTR_GUEST_SECURE_TSC))
>>>
>>> I would much prefer we solve the kvmclock vs. TSC fight in a generic way.  Unless
>>> I've missed something, the fact that the TSC is more trusted in the SNP/TDX world
>>> is simply what's forcing the issue, but it's not actually the reason why Linux
>>> should prefer the TSC over kvmclock.  The underlying reason is that platforms that
>>> support SNP/TDX are guaranteed to have a stable, always running TSC, i.e. that the
>>> TSC is a superior timesource purely from a functionality perspective.  That it's
>>> more secure is icing on the cake.
>>
>> Are you suggesting that whenever the guest is either SNP or TDX, kvmclock
>> should be disabled assuming that timesource is stable and always running?
> 
> No, I'm saying that the guest should prefer the raw TSC over kvmclock if the TSC
> is stable, irrespective of SNP or TDX.  This is effectively already done for the
> timekeeping base (see commit 7539b174aef4 ("x86: kvmguest: use TSC clocksource if
> invariant TSC is exposed")), but the scheduler still uses kvmclock thanks to the
> kvm_sched_clock_init() code.

The kvm-clock and tsc-early both are having the rating of 299. As they are of
same rating, kvm-clock is being picked up first.

Is it fine to drop the clock rating of kvmclock to 298 ? With this tsc-early will
be picked up instead.

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index fafdbf813ae3..1982cee74354 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -289,7 +289,7 @@ void __init kvmclock_init(void)
 {
 	u8 flags;
 
-	if (!kvm_para_available() || !kvmclock || cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC))
+	if (!kvm_para_available() || !kvmclock)
 		return;
 
 	if (kvm_para_has_feature(KVM_FEATURE_CLOCKSOURCE2)) {
@@ -342,7 +342,7 @@ void __init kvmclock_init(void)
 	if (boot_cpu_has(X86_FEATURE_CONSTANT_TSC) &&
 	    boot_cpu_has(X86_FEATURE_NONSTOP_TSC) &&
 	    !check_tsc_unstable())
-		kvm_clock.rating = 299;
+		kvm_clock.rating = 298;
 
 	clocksource_register_hz(&kvm_clock, NSEC_PER_SEC);
 	pv_info.name = "KVM";



[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000001] kvm-clock: using sched offset of 6630881179920185 cycles
[    0.001266] clocksource: kvm-clock: mask: 0xffffffffffffffff max_cycles: 0x1cd42e4dffb, max_idle_ns: 881590591483 ns
[    0.005347] tsc: Detected 1996.247 MHz processor
[    0.263100] clocksource: tsc-early: mask: 0xffffffffffffffff max_cycles: 0x398caa9ddcb, max_idle_ns: 881590739785 ns
[    0.980456] clocksource: Switched to clocksource tsc-early
[    1.059332] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x398caa9ddcb, max_idle_ns: 881590739785 ns
[    1.062094] clocksource: Switched to clocksource tsc

> The other aspect of this to consider is wallclock.  If I'm reading the code
> correctly, _completely_ disabling kvmclock will case the kernel to keep using the
> RTC for wallclock.  Using the RTC is an amusingly bad decision for SNP and TDX
> (and regular VMs), as the RTC is a slooow emulation path and it's still very much
> controlled by the untrusted host.

Right, this is not expected.
 
> Unless you have a better idea for what to do with wallclock, I think the right
> approach is to come up a cleaner way to prefer TSC over kvmclock for timekeeping
> and the scheduler, but leave wallclock as-is.  And then for SNP and TDX, "assert"
> that the TSC is being used instead of kvmclock.  Presumably, all SNP and TDX
> hosts provide a stable TSC, so there's probably no reason for the guest to even
> care if the TSC is "secure".
> 
> Note, past me missed the wallclock side of things[*], so I don't think hiding
> kvmclock entirely is the best solution.
> 
> [*] https://lore.kernel.org/all/ZOjF2DMBgW%2FzVvL3@google.com

Regards
Nikunj

