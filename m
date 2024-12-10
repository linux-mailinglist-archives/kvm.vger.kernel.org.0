Return-Path: <kvm+bounces-33438-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C10229EB7EB
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 18:16:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B1EFA283CA1
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 17:16:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D400D23024E;
	Tue, 10 Dec 2024 17:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ZZXmSMw9"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2050.outbound.protection.outlook.com [40.107.236.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C65230245;
	Tue, 10 Dec 2024 17:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733850801; cv=fail; b=XgHfUwmQfHUg53MTFZcEv+NNS1IJYuusr8w6STkO7w+jqFlJxS6ATcyrnzhADf21o+4YQM9eYBrYgL8VuPrCm9DX6FJ+Zmpa1SqyeBH2sy0OUy0lhbKSSrhioQKUzPXF7G4DviZ5QOx/WJFrNozgw/gIyI1Fh3Sf8r+sCA075mQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733850801; c=relaxed/simple;
	bh=IWEJauzillik+GkdmXubJMs7BLfmYEzWkZ18iaNjS9g=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dV2zn6W5f0JKplzCJHUq4SlfkXEUGkkXNet0z0Wnk66TFt1zlIeqQZuWBrxHWcXmOaH8HbwUNYZkU4v5kDBCkpsw2p+KEDeuT22YTzOsFkoMCEli3uDmjIABm8tRjXFCKwAfkiAngye9toe0oWPqtUIvJxZznj0/TA64KmziEko=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ZZXmSMw9; arc=fail smtp.client-ip=40.107.236.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bGzHHyJ8Xsf4CCtM/s2liThSCiiyhFxSvb6VLZOBvtcxFMT4cGuSH/Rc4J9a5Uaz5cpJFrpDYyWPAKP1lX3oZkdpXtD4zL9sR/iQD3ZKEWfolkvzzzlWJdc+DohmJW2XxQL8BCbMfXx2/bEMiPv+1cNpYX4bFcYMRiQLpEnPGWFMu3yMgzRDVKulA7k/H3xXxTsFNmJ/NCfbzvFI/aXAYl5kXhAPlCeIVDMmiaJVwLKwMeRGbUabiiSAtgU8AzrLyRtmmJVxit13cFNY7dwTxEaRMcBxhsRbJPZkhrvua8w+XwAmiRIeiYm4mPoxzxctQ2gbuO5D8sFCeB40kREdHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zh242c3FDHm6IpWYUawMbQhgXo3roANL8Nb03WBfuiE=;
 b=Yi/NmvqVkhsAmLHBeneX6jiNg03V8exOK6IKOQBZaQB3/GNGRZpeemy2mE2wzQLxVdDaX7wlpXS9/nG+ae6gXNMnv3sYqrD37V3jOQ+RreGE9J0aXPQwhPBTwA2NIHYDlidYt8xx3bNSgXoVXbHWsNfohe1NdVgyW9Q2va9Gb6UJIUnYcYhsYOc9cBASX/l/QfHMkoy7gmCOFsHB2VUv7wDKznj6GITxR+5d83GK6y9CmDHK9OZNiff2J5KceyA01FV6w8eSEbrN6s3HnvCHmQcru/JugGAtNI+3XskaV0yfS+aClHQDxqGwf9tfPxmHisUIod68V9QlqdpcErCqfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zh242c3FDHm6IpWYUawMbQhgXo3roANL8Nb03WBfuiE=;
 b=ZZXmSMw9h1/vdAIrkSn658krLAzF85QA+jAboHBrK7AVfExs6K6pNfHPYU4uP01wvbTPGHulU5ZgvriemFKNTCLu+TtRFbSdgpNtuIlVdVK8o2AjumGOwtwR1lhVEf5t0SM2q+Q+dJxw2QkG27onRWCTt3BQaz+8fdh2CFLXfjI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 CH2PR12MB4088.namprd12.prod.outlook.com (2603:10b6:610:a5::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8230.19; Tue, 10 Dec 2024 17:13:13 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%6]) with mapi id 15.20.8230.016; Tue, 10 Dec 2024
 17:13:13 +0000
Message-ID: <b1d90372-ed95-41ce-976f-3f119735707c@amd.com>
Date: Tue, 10 Dec 2024 22:43:05 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 06/13] x86/sev: Prevent GUEST_TSC_FREQ MSR
 interception for Secure TSC enabled guests
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-7-nikunj@amd.com>
 <20241210121127.GBZ1gv74Q6IRtAS1pl@fat_crate.local>
Content-Language: en-US
From: Nikunj A Dadhania <nikunj@amd.com>
In-Reply-To: <20241210121127.GBZ1gv74Q6IRtAS1pl@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0080.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:9a::22) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|CH2PR12MB4088:EE_
X-MS-Office365-Filtering-Correlation-Id: 4bfe918f-0891-4904-f731-08dd193dedbc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QmtBdFNUNWR0ZUdkMXJ6eXQ2cVowSUhRenAramxQN25EdktkeldLeEk2Sng3?=
 =?utf-8?B?eXluZmFiU0g5YnNUZWRseE1URU1xcVN6NmdpZFl6ajFTcVpiRy9MdWkyUjM0?=
 =?utf-8?B?MU1mT2dFUFNjTXpKNGZabCs5WE5udFZnUEJ0OWYva2M1N2JHdkJWQURzMlVP?=
 =?utf-8?B?dGdJNHQveSsyT1RhMjB0M2dUdml5aFJtTFlzb1pGWnMwVEdERTdEaXVyR2w1?=
 =?utf-8?B?YzBUNGhZTjQzRnN0eTlSRlZET09peVBsSjV5OW5MdzBMaGo2RWhQQ0JqY2pY?=
 =?utf-8?B?S2dJckpIbEN5R0RzZDdUeURPL0Z4VWVOZmtHNWhGVWYrSCtNZGdRVytLWjVE?=
 =?utf-8?B?VVMrUFR5a0dCZjRhc3hWUmx6UEtZT1JyMVc1QXVFWVhBT1Q5dzVIZGNJcDJF?=
 =?utf-8?B?MDVFQktxeVAybmI1eGlPaXVabjRIbVJCaFZvblgwSURYVnkwN2xsSEJnb0dx?=
 =?utf-8?B?UHlaSWh4RUhyZUlOTHVBUWFpOVh0bUE4d0JEcWM3TXpLcGduVVhDTElLcXlI?=
 =?utf-8?B?QTdSSExpWnZFTVZOWEloaStjMHVwNmNRYnNmdFVLdXhsMnpvaWFjdERYUGY4?=
 =?utf-8?B?aVVIcVFQK29ZZEdMZ1ZVYkRyRXMvWmE2TUYxVWV1QnM5YUZIRnRQM2FqemVV?=
 =?utf-8?B?YThLTVVHMWpMNTVic0o5UVQ4ck1CdU5NL3lsRE1xTDgzZzlNQys5dllUdFVK?=
 =?utf-8?B?NFVQM08rMVEvK2hvcG9ZRlB1UTlDb1lrM0IzYmh4YkVhZzlwaXNkbTRWZ0tn?=
 =?utf-8?B?TkI3TkljUHdKV21zUzZMUmxNSCtnY1o3S09kQUlpaXRneHVOSkZFT05rci9h?=
 =?utf-8?B?UGN5S3RlVlE3SUFPYlR1TGFLTjJoVURUYnZMUUUxL3lGaUgyZm5FWjJFcVJs?=
 =?utf-8?B?MzNTMHF6b1RQd0VSMzlteFdCN3R5R0RpdlpRbXoyMXhYV0FXNDlOTVBaVkZD?=
 =?utf-8?B?alBPL0dzUHRxRWE3QXl1S0k5b0RkS3R3SUFjV3lLU3dWNVFTOTdpUi84cDRL?=
 =?utf-8?B?VFZsZEtack1QTERuWlFkVmR0RWFZek5KRk5oWTZaQzFRcDZYVUM1Y0p5ckZj?=
 =?utf-8?B?cXdUczY5VDJBMVBwMHJ1bmI1N0haRkdXaHRvYkZqVEI2WDh0dm8vRUVOVXlJ?=
 =?utf-8?B?aUNQQ0ZtSVBMZHVZdk5kMW1vTThVbFRVbXlReG5sWEkwditweGJGMkxtb0hz?=
 =?utf-8?B?aXZTOXhpeDV2SmR0ZTRYTVpncXo3OVZNZ0R6OG1hRVhwZWs5RmpYbHYvVlRo?=
 =?utf-8?B?U3RJM0VZU0pLLzNkRFAwcERhNXVLZnNETDBISlhXWnlrbEEvbks5a29UdVAx?=
 =?utf-8?B?eTVxTEZjODQwVXRVN2g0NkE4Q1J3OHFYNUY3a09VOVhiSitRSnUyQ3E5TXQv?=
 =?utf-8?B?NVYzM1ZPN3JFNlJDTGRUaWRRZ1Z0N0FqZ1NkNnQ2Zi81SEpvaTF2cnJWaURt?=
 =?utf-8?B?MmFFNndmRk9JOXluNm11OERaMWVPVlhZNjg1MXBNY0loQTBKYStLNENVSm5r?=
 =?utf-8?B?enE5cy8yQnhGYTJ3S3FhcTJBV3grR1YwaXp3S0wzT2ZqcnlSZEtWRVMxM21H?=
 =?utf-8?B?Z3RHc244WGZ6bjNyOEFwV21JMS9vWXV6eHI2UEtmM0FNS05abEEwbVMvWnFx?=
 =?utf-8?B?cDIzdGZ2K1d6ZXYxL0g4SExMOWZnRmRpVzdnbGUvRFJTanhOOUtaSTdJVUU1?=
 =?utf-8?B?R0g1cmhxWWIvVVVQVXB5L2hTWFhSb1NNNjVMcEJqVmNaT0RKcUJEUFhzQVJS?=
 =?utf-8?B?TkRnUGFNYmxTSkIvaHMvZjdVb1ovczF4bGVEUmQrRlZDN2Q3WmtvdjhoL3p5?=
 =?utf-8?B?QklJNWQ2Z0dqKzRxWVVNUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z0EweTA3WmNPcTMxV3huR3RjYzdNdU14Z1Y4bzFwbWJ2U2FuT1c2c2k0U2k4?=
 =?utf-8?B?TEJxdXkySU5xc25vMWpwNHZxOHIxUko1d3hWaWcxaE1GWlFUZkl4Yjc0bXk4?=
 =?utf-8?B?azNwaWFpRXlqVDhYaXNCa1h3b3o3RXBnTFJ2L2tJWTJQa0hsSFlIZ3c3MHpB?=
 =?utf-8?B?M1hJblBzaHl3Q1NpYmhocWJWSENkOGhvMmZ0ZUpIRXhWTmhlVWVkK0xYYTRN?=
 =?utf-8?B?YldpT2JvYlZFaytqbkZ1d2RaY0NWbGtGOVZ6d2F5VFcwVEVoUmNyb1RzbDNM?=
 =?utf-8?B?N081a3ppRkw2VXc3SEREZVFsaFVRVTFtT04xQlVLelhNQjdSY1UwbWU4YmlT?=
 =?utf-8?B?Smp5TVUzVXd1WTlOZjhETGptY0RQTmVCYlFvV0ZyNzkzOENkWGUxTG5zeGNI?=
 =?utf-8?B?WlZQdlRsaHgzN0VkSVZYRTkxUVN5eW9PaFhHV2wyVlZFSWVWTzVEYlY4bEll?=
 =?utf-8?B?bDhTdks3ejhiTVdKQy9sWFd5RU1QSGFySnZYaXltd05keU0rbmhMdnVZTG9P?=
 =?utf-8?B?WVhJUXBEWWJmUEo3UFlRdzVPeVB4ZWlLeHgvcTBmRHhOMXArL01JRWVZR3By?=
 =?utf-8?B?aWJiZFRhd0U4UUNXN3VEeWlOWTNTdDZrZjhPZUlIZ1dudk5CdzczRFBuOUcz?=
 =?utf-8?B?WG5YTisvR3ptU01pWWcwaU5LNHBFWkdPL3RJYkRPSjFxVUdGYWJnejhqZloy?=
 =?utf-8?B?azZlc1J2d3lSU3BkOTZMTXpVREFhUkw2NDBuNFYyZmxuNFVEUjRLYjNDWDc2?=
 =?utf-8?B?K0M0ZU1qYzVNZVJiZUUrallUVlRDZVlkTlJQa1hFajBpcTExQ1U0M0dUVUdp?=
 =?utf-8?B?Y29EZGZKRkYzYlNENmlzZTZSY1RiZHZhZ293TUlySlB6ZGRYS3RtdkowNDdK?=
 =?utf-8?B?enNBS1FGWDQwR0s2NWYzMll0ZGxmYitoWDV2ZUFuL1lzQStyS2VkU0YvRnk4?=
 =?utf-8?B?VDlKdEhyNFdhczhNVjBPejRuNVN3SFRyQWpvdCtEVlkrYUJaejNUMEZIOHhQ?=
 =?utf-8?B?VDNzRUtPNHhkUmx0ZlRsRXI4OFNIRU91VkhITnkrekdaQWNMTUV3SlNFQTRr?=
 =?utf-8?B?d2RMc1pmbVIrSDREQjJFV0ptMTBMdFhhZWdIemUrdkR0SGFQWVlwMHJRSWlm?=
 =?utf-8?B?UkloMzhYMnVjeG9MU3ozbnNOa1FRL3Q1L21HY09FSWluN3VPMXhBdVJvVUMw?=
 =?utf-8?B?NDgxWVdOVktEdUJTaEgxNmticmpCSUM4ZHdBcHY2K1pZMlpjR2ZzS1FEMmQ0?=
 =?utf-8?B?RHVTWlJVd2xQTnJNT0t5SE04eE1XVW5xNHVQR0Ntc2h1TkJhNHBnQ0YrcHdL?=
 =?utf-8?B?dnYvY3RNT00wQ2JaeHg5VVM5L0dDUkhvUk5wVVBKZVZYY0QwVG5xdTgwd215?=
 =?utf-8?B?RFA2Snh0RzhFMXlCTnZhbDZqUnRMNk56SloxSDNEZnorWmhlbEJla2RtQkdu?=
 =?utf-8?B?U04rcEprNVdCMEE5TnJLWXhWWXcvYTRGQjVmSVliOENFa1BjZm5ibWZmUXBk?=
 =?utf-8?B?cUc3MHZ6K2MvanVhNThVZUpuL3ZHeDc2QTF4RVBFRWxiNm9CRVNZK1gzcWo0?=
 =?utf-8?B?K0k2RGlnNUEzMmd0SDVCQkhoeUhXM3NwT2ZvWklWZWpQbGxwd2dJdUFTdzlp?=
 =?utf-8?B?NzdvMlY5eURjdkJNcEZQekxSY2UreStqS2F4dUIxOUtsQis0eTZiZjFnWXZ2?=
 =?utf-8?B?MTNpdzQzTmc2ZThmbkU2MTNBM0xva3dzcjk4ZTdLSTNUa2FGTkVGVk00OG14?=
 =?utf-8?B?M3VLRjhoRFoyK2dZQzE4WWszSitIYU9KMG0wRHNUK0VaN21BbU1QYzJ6VTNv?=
 =?utf-8?B?L1pBWnduNWFMcjJDVHpaMDBkanZJSjAvQVR1dGVxckZBTG5KRjFUdU02cm8x?=
 =?utf-8?B?NGdFMXpiY1M5c3MzeVRUMWw0NlFxaW1nWnNtdDJYY1EybVZqRERIcURNMnpx?=
 =?utf-8?B?UXdzb0cvVFhpVURlSmNHQ1F6YWRuaGhoQ2tIdmxSQWJWWFlmS1MzMUNlK0pi?=
 =?utf-8?B?SUQ1dnNXK096VG9ZOUE5NXNnbzBQdlRCWER2Y2I3MS9xQkpxQ0ZDeWNCOTdV?=
 =?utf-8?B?MkFsSU51aWZKYUdmOUJUd0ZTSS9iR1RHM0hJZ1dkRVVEcTllSU00TUYvcXBV?=
 =?utf-8?Q?QsGH8WxaX8fjR+IX3ssDgQAFv?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bfe918f-0891-4904-f731-08dd193dedbc
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2024 17:13:13.2108
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mYfqgJ+yqLTizvYbMl/m6tuCkJJfkBfNi5crdlZWTKw4jWyiyI7zhDyU4pfM4FBB65AM42LYs9ZyIsjlmrKJUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4088

On 12/10/2024 5:41 PM, Borislav Petkov wrote:
> On Tue, Dec 03, 2024 at 02:30:38PM +0530, Nikunj A Dadhania wrote:
>> diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
>> index af28fb962309..59c5e716fdd1 100644
>> --- a/arch/x86/coco/sev/core.c
>> +++ b/arch/x86/coco/sev/core.c
>> @@ -1473,6 +1473,14 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
>>  	if (regs->cx == MSR_IA32_TSC && (sev_status & MSR_AMD64_SNP_SECURE_TSC))
>>  		return __vc_handle_msr_tsc(regs, write);
>>  
>> +	/*
>> +	 * GUEST_TSC_FREQ should not be intercepted when Secure TSC is
>> +	 * enabled. Terminate the SNP guest when the interception is enabled.
>> +	 */
>> +	if (regs->cx == MSR_AMD64_GUEST_TSC_FREQ && (sev_status & MSR_AMD64_SNP_SECURE_TSC))
>> +		return ES_VMM_ERROR;
>> +
>> +
> 
> If you merge this logic into the switch-case, the patch becomes even easier
> and the code cleaner:

This is incorrect, for a non-Secure TSC guest, a read of intercepted 
MSR_AMD64_GUEST_TSC_FREQ will return value of rdtsc_ordered(). This is an invalid 
MSR when SecureTSC is not enabled.

> 
> diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
> index 050170eb28e6..35d9a3bb4b06 100644
> --- a/arch/x86/coco/sev/core.c
> +++ b/arch/x86/coco/sev/core.c
> @@ -1446,6 +1446,13 @@ static enum es_result __vc_handle_msr_tsc(struct pt_regs *regs, bool write)
>  	if (!(sev_status & MSR_AMD64_SNP_SECURE_TSC))
>  		goto read_tsc;
>  
> +	/*
> +	 * GUEST_TSC_FREQ should not be intercepted when Secure TSC is
> +	 * enabled. Terminate the SNP guest when the interception is enabled.
> +	 */
> +	if (regs->cx == MSR_AMD64_GUEST_TSC_FREQ)
> +		return ES_VMM_ERROR;
> +
>  	if (write) {
>  		WARN_ONCE(1, "TSC MSR writes are verboten!\n");
>  		return ES_UNSUPPORTED;
> @@ -1472,6 +1479,7 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
>  	case MSR_SVSM_CAA:
>  		return __vc_handle_msr_caa(regs, write);
>  	case MSR_IA32_TSC:
> +	case MSR_AMD64_GUEST_TSC_FREQ:
>  		return __vc_handle_msr_tsc(regs, write);
>  	default:
>  		break;
> 

Regards
Nikunj

