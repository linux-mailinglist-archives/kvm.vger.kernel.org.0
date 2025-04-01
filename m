Return-Path: <kvm+bounces-42298-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EE461A778EE
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 12:35:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A03B01673D9
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 10:35:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2099A1F0E4C;
	Tue,  1 Apr 2025 10:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="fgRDtTx4"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2041.outbound.protection.outlook.com [40.107.237.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFEB41F03EA;
	Tue,  1 Apr 2025 10:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743503737; cv=fail; b=QNPJfCwfbtC5pWaVqwGh7czmg72LBBign5MvjGl9nioCP450SCVfau+LAYjeAu79INNRBqmRmE6FdXwmtdKT84CGi2AbCy2kEG/7ufk8p9RNlMI2Qc0n+c6vZvQaIC1ADe/P4m6m6AkiHFMdpT0sLCsUWkldJn6tlJIKGGMKPT0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743503737; c=relaxed/simple;
	bh=Y+epiSjVM/uZam1YSWcp5uhNJerI0uQQCNhJfpRf7IU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=K3ls1SIaYxxSkjZbkC9dRXd4kvyVvWZT/nHbP2+lS634/x458yGBsd+wHKsiVNYQ5Ay4Zo7q+phNG11DXTgQv45YBBYzO0fqitxI6T5DSXst7kTrRhZ7sbIat3/4esf6arCtSkV/+/kh2a6u+DB8LdrmGf69gSU1e821cz8OY+k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=fgRDtTx4; arc=fail smtp.client-ip=40.107.237.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DSNo9OeHiqtfpads+5RiNbGWPUjPhG7E4q0x+jVg34gTg1sljOy+ReS8Fnh6YS2qpHqemzVU4ERynS4v/cv0kisYNHF55h2lyZpPww32YB7xHarHKLifoyQkYHW0SH9lQjlHl2pBsYeZ+FaH7lKqSPx6kDoYj9cYvt/x7aQciLhG3pt5X7dC6p98sCcuNWhpFwu/ZLn/81pK1TGGbbKPid7MSoNvcDuk3XuzDUWgfPjipbmbCuHG8CLuB7abwbS+dzbNpm50i3JtKUkmei84wPGAy9tgaKL7/bf+Lbd5Dfy544vNkzwdnSR2QpNk99d07azo1aXG6yWnpu8m6cCT7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dcP+OkfZ8mYHJfisqbzhuWumbNIUy61Drf1eToVHAhM=;
 b=OYpq5l09defhFR1Ual6c2PKPQ+yG1SNjPh6nHJdtiC8/sMKCTFL403z8HBQZpQeXEPPCpt40QCjyeVHVBSlQOQ7BJb41GW2sU8n3oq+aeLngfuQ+JHISyvlJQA8pnqMROeXcG8KUQ2Dm7JyBWAcQiDhv8jZpHXxekJ6RiYz6rifjJGKIQrz/NflcY+HJ7GMwDzHdhI8YHVh+ZfWUMwZ9JRr0af0AmSc7D45J+/BDqHceDUWyUZWLJZzLhNkNGo/yAHn3kBvetVDpoO/Lm5Iv6g6C2orwHt86fLtpmBhAJOy0gqBEwGX0A3fr8qnWMrmyjeu7bsgZzjTBRNTZuvzmNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dcP+OkfZ8mYHJfisqbzhuWumbNIUy61Drf1eToVHAhM=;
 b=fgRDtTx4ryZ53QsNAYlWvVrmJdJ1//NiREB51s4MxO1X3/116oKt7jWJMfKCFNcHGuT+W1jSfNjIkNuHs2h/Q0/tNgeqrGt4lL3LyOa1MWkqjunTOXPdf+dksYVug/y+MaBlc/z3eDKD8jihsil6m9IyYoCpE4hMJ9kEryMDsIc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 CY8PR12MB8193.namprd12.prod.outlook.com (2603:10b6:930:71::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.50; Tue, 1 Apr 2025 10:35:33 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%4]) with mapi id 15.20.8534.043; Tue, 1 Apr 2025
 10:35:33 +0000
Message-ID: <be2c8047-fd68-4858-bb92-bf301d7967b4@amd.com>
Date: Tue, 1 Apr 2025 16:05:22 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 14/17] x86/apic: Add kexec support for Secure AVIC
To: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Cc: bp@alien8.de, mingo@redhat.com, dave.hansen@linux.intel.com,
 Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com,
 x86@kernel.org, hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org, kirill.shutemov@linux.intel.com,
 huibo.wang@amd.com, naveen.rao@amd.com
References: <20250226090525.231882-1-Neeraj.Upadhyay@amd.com>
 <20250226090525.231882-15-Neeraj.Upadhyay@amd.com> <87a59e2xms.ffs@tglx>
Content-Language: en-US
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <87a59e2xms.ffs@tglx>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0213.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:ea::7) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|CY8PR12MB8193:EE_
X-MS-Office365-Filtering-Correlation-Id: 46523feb-8d3c-48eb-f738-08dd7108ee13
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dnlCZUpjZS80QmNndFNHbldaazlPYlZiR1FTZVpmSGN5eWlNZWd4V0Yvd0ZM?=
 =?utf-8?B?QTU4OSt0QzFDNHI1T1VUeE9oMVZ4eUZuWFVGM2tBcENnRW5NbW51VytWZXZi?=
 =?utf-8?B?WlI4eXlqZklkWGozRGh3cGRld2k2WU1UcGd6RElZelNYMm5PZUpKa2FwMVUy?=
 =?utf-8?B?K2ZwZUQzOWowTHducDdYVVVNSkp1b01ncWtsQkcwc0JTM0NteDZSTm5oOVo0?=
 =?utf-8?B?cGloM0VKL1FBWFl0czFud3pqUXZqZEY5K3BJTG1STXN0ZHJHdFlNSGhra28y?=
 =?utf-8?B?T1l3Zis4c2ZNSGgrcmFEY0lCemJyN3lORjZyMENSRkl3c3JuZUFzOEpzNUdS?=
 =?utf-8?B?V3l1bGloQm9lcXhQY05yeGdSMzM4RjNTV0NXOWJmOVlLNWd1dUw0TS9PMzM3?=
 =?utf-8?B?SHBNUmNOYWdHMTd2SmhwbXZKejR5SGlVNjVubHl5Y1VManZXRUp6UE1jRFVa?=
 =?utf-8?B?bGRCdkJQRVJFOTVPNE5KUW1JL3AzR3pGSUtOWXBNZmNiOTJOWTlROXFGZWpE?=
 =?utf-8?B?cS9WMkZkem0xdGhNenNqbXdFOFFzbnFKUkhqWXo1NHpKb1VPTWdCREFJNlZ2?=
 =?utf-8?B?M0FzenZvNVJiVWdlOUsrQ0V1a3JYV21MbHFHY0Z5Rk9BTHU0MHF6T1hxZTBw?=
 =?utf-8?B?MThoQTgzVmtZSW5aRUFmQUtkSHg0NnJqUDZxVlY3RDRvWWtWQjRzL2RTNGpN?=
 =?utf-8?B?T0hpekMvS3AvOE1XRkNhZjF3eFZIS2lZQnZ5U2ZNOEhEaXpXZWNjQ05uQ3Av?=
 =?utf-8?B?bGhET083NC9aVUhVbytINjV4R3RvMzhXZTlZeUh5T3dGVml3RkRjYk1EVlpw?=
 =?utf-8?B?cFZLNnJVQmxlTjd5ZWppNnRqRU52NDdlUkVmT1QxcTZsQWtvMFAxZEkwOWQv?=
 =?utf-8?B?SHZZaUVuZVFNeFd2NkU1bXBLTElFVmhlZEVVRVNFTXJldVhZazRidXJoZE4v?=
 =?utf-8?B?L2s2ZFFKNGlhNkNiV3luT2NiMVdlZWwyQk04S2lXT09rU2gxcWV4ZFhpWGxM?=
 =?utf-8?B?enhaakc5cGVsVHk2SjkwK1ByaDBteUlQNWxtSXl6QnJJUnk1QytLTnhjNGsv?=
 =?utf-8?B?R3dNOStCQ2NkbldZczhIYk9qbXJhSXN5bllnU1ZCanBQczJZNU1FNnhRdDMx?=
 =?utf-8?B?K1E3elFVU1o3VzdpcUk2cjNjcHJjdm1nZkVkM2tiNTdSZ0V5c25PWjVYODVO?=
 =?utf-8?B?Rndmb0JHaVoyT1VtTkFqYnlNdGprL1hiNFJqbXh1Y0hMUXRwZGNMSEdOTFJk?=
 =?utf-8?B?S3JUbUpxQlY4bVdyQ1RtSHp6NjFrN3VUMjJ5WVdqSHZxQmNaRWplazl6MmZs?=
 =?utf-8?B?eGk5ellGUENGNk11NWhVYnBxcnJZaXhLaWI3ZTBSNnZlb1VubUJmWHUvQ0xF?=
 =?utf-8?B?NU4wN2xYYW4rVi9Pd3BQb0JsOUw3U2N5ZnNDaXByV1ZEY1V1Mkt3Q0RaMXM4?=
 =?utf-8?B?R1hIeCtsRTZtbFNtVVA1WGJnSGV6QkZTRXRDaWxONEJhL3k0Qnc2VFB4Mmw2?=
 =?utf-8?B?UllhN0Z3TEtZazZMb3BpV0hLd1V1cHAvenNTVGlKZVkwU240WmlFaGVVM1Rw?=
 =?utf-8?B?SmxGc0ZJTEs3MmkrNkFFQi9BTFBNSnNZc3A0S0tsakFtbitKQU96aUNyaWxz?=
 =?utf-8?B?TCt0SDhmYVBXYituWHpiL1dDZWtrSTBtR1lONStMNzRxaE1SMjVVUnYvc0Ny?=
 =?utf-8?B?TXhVeU5ERkl3SnRoSUI5MnQ5eTUxQ1k2MnozQjkwc2FZNmlZdWkxdHhvd3dP?=
 =?utf-8?B?aGErOWpxOFNkbzZvelhwSkdmYUxvN3p0K2NOQVp2Q2pKV1h4Zm40b1Fsb1A3?=
 =?utf-8?B?UWJ1aFpmbzZuaisrN3dNQVFxeGhqeWIyNEdFTmZPQlE3cWJibHZ6a2FaNGFW?=
 =?utf-8?Q?GXobZmj0UIZ6I?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aGk1eENMOUYwMStCL0RZb2FDRm01RldhaEkvNkpOcHN2eGhnVEl5SUd0Y3NG?=
 =?utf-8?B?T0xUN2dWYjlPOWh0RDRWNENpUUhuSGhuaHkraVBRR2drS2Z4SlBxUjNFRVB2?=
 =?utf-8?B?dVVMSFRGNHR6U2NVc3YxZCtPUEErU0NUcFdXWEsrTHpoL0U0ZEs1QzArbkt5?=
 =?utf-8?B?aWkvNHVEem9HRWJWVzhhTzAyMEd4NzZuMVR4emR5MjV5QUFPaWlDeGVCUGNC?=
 =?utf-8?B?N3JTazJ2aTRyaGZkNHdsb0F3Qkc0T1prK2N1Y0lSbE84aHZYVXVxQmZZSDgv?=
 =?utf-8?B?aHZGUzk1YTdpbXY4dkdETDF6V2FSSjd1aXFmMmxSOTljSlNRRUxTNEhqd0No?=
 =?utf-8?B?SXJicFlUZ241WE9pS1ByN1RYOFY0QlhUYWo4RzZnTUNzcGhXSGdJclBoL042?=
 =?utf-8?B?cWFvM0hEaXVQMlRXM3lTbkduOFdZRzNxUHFZc0ZEWi9wQWc0cXh2VEpTK2tr?=
 =?utf-8?B?clV0QUhQaDRVK3NFb1dobjk4eC90ZGRETWtubEtpVHc0Q1BGZ2FVb3g3K2NN?=
 =?utf-8?B?NWw4OTNLcTZsOEF3Um9pY3N0anJkU0RoSzZEcEZFR09Hb1h3dHJyM3dIdFhx?=
 =?utf-8?B?TkV6bUNzTWUyblNCa0I2QUpRNko1Q0JxOVExZDNaaFlRYmgvek5BQ3hWSEVB?=
 =?utf-8?B?VEV2YktiWXNwaVhFR1diMDlPQjZRd1NwZ1BMT2kvV1JFeEluZWdwTHFKWG9x?=
 =?utf-8?B?N2FmY2tuRFFwNjF2UUJwdzRaWU9tSGx0cVNpMmwzV1dJSTg3NFdTZERNalZL?=
 =?utf-8?B?WDVnY1RaVGNDZkdaMkRxSGJobjBTRENCYUNzaWVVdDVKR1Nna21Uc3JKZHpn?=
 =?utf-8?B?RXhoTjFsZk4wejJCRjRZQWlrNEtYREFVSE44TjhWdHpPSTM5ZTM4WHV1ai9B?=
 =?utf-8?B?NTI1bUdMUTRRMFVOQnFJd3VIN2luR0o2N05USjQ3TjREbmMxUzJGSytCTkVD?=
 =?utf-8?B?aGlqbXJJc24za0FqeFJNdmZKUkQwS1ZzOGV4N3IySE10RSsrM1BqS0xPS1Bl?=
 =?utf-8?B?SDJIQmkyNUE4Y0xxQUp1WXF2cktKVHFuZWFoUWxMdjczQi8wOFZGS3hyYnc5?=
 =?utf-8?B?dE41cUt2UVEvWS9yMXBJaG8rZTB3OWRVUjY2WTZRUGs3UTJ1NVdxU2lWZHpT?=
 =?utf-8?B?ZEUwU0MrU2IwRFlhcTBQTmFycWgwWmlmUXNkUC9DWkFQT29TSVQyd3lVcVBC?=
 =?utf-8?B?VEpQVG1nd1B4d3hPRXZZdEd3STkrc1JYeHB0UmQxWEhEOG1FM1NTRnZFVUJp?=
 =?utf-8?B?YzZEWXYvSDZOTE44QVZ3anF3VVp6MWM5dytWKzFPbS9JamRYc0hHdzhUOXBJ?=
 =?utf-8?B?aXBQYVZaMndGY0RvSlU5aVI0ZGZ1WGtSY1VXRXFWd0NjeDhTd25DeDB3R1Qw?=
 =?utf-8?B?TThXamhRWnRxQ1VYb3dQeFB3djZtM1JYa0ZxSFFuZHIxbHFkd1ptb1d3dHpZ?=
 =?utf-8?B?VHBwTnVRWk56ZldJamV1cmxpTDNvbmI0OE4zbnhqMUoyblp1ZWMxTk1oa1d4?=
 =?utf-8?B?NXRBZHA4VHlGMjZLM2RxeVoyeFIrcTJiUzN3blArT3dqbldlNFRKU1Fwc2ly?=
 =?utf-8?B?dExrNmJyMWV0U1VkdHQ4QzJMQm0zMGFGaXJaQ01CU245ZTZxWEcxNkxoUmt1?=
 =?utf-8?B?eDdOdHRCNzlrdUs3MU9VeEJ4aStybG1WL3VDNmRYc0xWVG1VcFg1ajliM2cy?=
 =?utf-8?B?M2Z5Z2VHaXFSR1NWM0JvMmltNXVwYy9KTGdTQk8yUHduQ3JJNGNiNkRsSFVF?=
 =?utf-8?B?MWpVamR6SFE2U0l3dUV5K1FPVFJ5akNrc0xNSTZsc0ZRejVTV21DOXB4UVVw?=
 =?utf-8?B?Y3FqWlhQdDVOMnhQQTBob3QyeDBwZHNhaWRIQXRlVU13bWlVYXNSeDlCUDZj?=
 =?utf-8?B?eGwxdHRMSzQrbjZBN2FJVUpOZVFabmRhYVUvMU8wTVM4aWFLUWgwYitvcGEy?=
 =?utf-8?B?bXllWFZrb1dJemdRY2k4TjNQc21ybHhGNkdzWG91VVZZc1c0RmVibk04djUr?=
 =?utf-8?B?YmgwSEY5RGRUWWtJQ09OZGduUWVLNXVmS1NyYUZjWm13eHBRQmxmR3lSVG1x?=
 =?utf-8?B?VDRwY3hnUVZBazZTZysxUm5CWWV1c2VhTDgxNEo3bmNUTUNncXkrQllBNmpr?=
 =?utf-8?Q?42AVGWvAAH8avExTK0Bj26aGX?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46523feb-8d3c-48eb-f738-08dd7108ee13
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2025 10:35:32.8980
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gqnrwZ0tbPuviUS7B049EQmjahCZQIO2uldrWy/SA0Nz7FADP86hlqIdze/iziDw7xswspz6X8nE9WiUKTP0ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8193



On 3/21/2025 9:18 PM, Thomas Gleixner wrote:
> On Wed, Feb 26 2025 at 14:35, Neeraj Upadhyay wrote:
>>  
>> +/*
>> + * Unregister GPA of the Secure AVIC backing page.
>> + *
>> + * @apic_id: APIC ID of the vCPU. Use -1ULL for the current vCPU
> 
> Yes, -1ULL is really a sensible value - NOT. Ever thought about
> signed/unsigned?
> 

In table "Table 7: List of Supported Non-Automatic Events" of GHCB spec [1],
0xffff_ffff_ffff_ffff is used for Secure AVIC GHCB event

"RAX will have the APIC ID of the target vCPU or 0xffff_ffff_ffff_ffff
 for the vCPU doing the call"

I am using -1ULL for that here.



[1] https://www.amd.com/content/dam/amd/en/documents/epyc-technical-docs/specifications/56421.pdf


>> + *           doing the call.
> 
> How would this function ever make sense to be invoked from a remote CPU?
> 

I will update the interface in next version. Remote CPU interface is not used.

>> + * On success, returns previously registered GPA of the Secure AVIC
>> + * backing page in gpa arg.
> 
> Please use proper kernel-doc formatting and not some made up thing which
> looks like it.
> 

Ok. I will update this.


- Neeraj

> Thanks,
> 
>         tglx


