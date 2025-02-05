Return-Path: <kvm+bounces-37368-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 604E0A296D5
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 17:56:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4A5FC1648E4
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 16:55:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3A6F1DE2C1;
	Wed,  5 Feb 2025 16:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="yVmpjhC0"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2082.outbound.protection.outlook.com [40.107.236.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C44B25776;
	Wed,  5 Feb 2025 16:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738774542; cv=fail; b=PkWMPJWr8Hmq9ZE6VCDvn8ZhRuu/oap2dLJk2ayXAsVfsGuypq+iDqAcC+ZlAy0i0eAqSSf1JgVuG86AMKvMnyogi47jj4vfVY87KIquMuf1Z/sg5Y3AIMqFBobwcQNrsyB1nGBxWYYeOaWbXhJRyMvwAun1LN3hR0wLK24LDUc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738774542; c=relaxed/simple;
	bh=1hrOM5ifXpdsDkujhdB6FOPO3D26j31oj58AHqaI874=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WJa5oZsP4vWswa9FIpk0ozW+IggA4Ndr8BaF7222Ir7A17b3lmMou42IceOCgFMlCWn+DRMoW3PafUwwiTsckdAjz0K3WEDhw1+MtasVShz1katvKwXUTlC6w28dAjOIncVBpOuBXQ9izdIgpTUo1sxR0qyUb+wAJ9aU5gGsK90=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=yVmpjhC0; arc=fail smtp.client-ip=40.107.236.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BjvconKMzvgAjXdaPSYVpUFJtod4oSunCIN8r2CwSVYEOItuHZV75RECKWy4f6oErtBVqpe3QLY8NGoSRJyWmZ2+YVW8bFmYWBnElTttRu4gSus8C75drGf6IcgdettKv237doqBq6tQPCjQQaB1VUXsIKZc21E3MnHE91gNS73DFSbWoqi8fzgesLcN3ELA3LilCgtt1UxINlLhxTRAMRKtGfe6VfCBr0qYO4W+LJyAjnbWQWL+FjUNvwtB4EznqUQyNxLuw6BSwzeMBMaqct5/4HhKByg3CpqoYArR0o0vtpAEKTkduxKPcUhx/o7VwPmrj8heoNzMU5FhlAhrdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y/L30KLOYqsdS2lZu0NemPq6ggWfpBWfSVLpXom36Kw=;
 b=Cm9N8WSNQ4LFSRaXIB2D5nbGpJphYBllALebo68wqxpsok/1LBLi4/+8fcrsfen+Sjzn5thU853W8UyyKnF00haDAdfrObNhbnx5lBpLx7axG3lB8OmN1GZg965OVXMft6ZrxQ645/+hlyvhrrk1lYQkhrReEjaRazjhn89Ur1yxxXjzkjetnsCLphFm8w04Q+5Ah8hhiMyBy8XoqCjpPCMfM/wJGto+3DjzNwSi01/IKWhXh6pfc5L4i8+c8N3e5UufoBZYG1ZkzfJPCQTEgVF/0FVYp8WMDh/xrUvm5sRqXIKXZ+Nkqu6MvfIVsrLHqw9EELL1OvAJcFbnExZdjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y/L30KLOYqsdS2lZu0NemPq6ggWfpBWfSVLpXom36Kw=;
 b=yVmpjhC0KjjerVb1WIsUoWHMVsWn0wmCQ4tXlhlVQS4mHNvbr3q2pxh2X/xM+B+6/ZrvpgiNrI1pTZustp1CFNFwxU7xj9GMayRZi93DBdi6HvWx+2VD+8kejFRuysluN202jo61WcNaFeQiXNzjTb0RncovjIpesXKYi9VeYn8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 SA1PR12MB8743.namprd12.prod.outlook.com (2603:10b6:806:37c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.11; Wed, 5 Feb
 2025 16:55:37 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%6]) with mapi id 15.20.8398.025; Wed, 5 Feb 2025
 16:55:37 +0000
Message-ID: <8f7822df-466d-497c-9c41-77524b2870b6@amd.com>
Date: Wed, 5 Feb 2025 22:25:18 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/3] x86/sev: Fix broken SNP support with KVM module
 built-in
To: Sean Christopherson <seanjc@google.com>
Cc: Ashish Kalra <Ashish.Kalra@amd.com>, pbonzini@redhat.com,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 thomas.lendacky@amd.com, john.allen@amd.com, herbert@gondor.apana.org.au,
 davem@davemloft.net, joro@8bytes.org, suravee.suthikulpanit@amd.com,
 will@kernel.org, robin.murphy@arm.com, michael.roth@amd.com,
 dionnaglaze@google.com, nikunj@amd.com, ardb@kernel.org,
 kevinloughlin@google.com, Neeraj.Upadhyay@amd.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-coco@lists.linux.dev, iommu@lists.linux.dev
References: <cover.1738618801.git.ashish.kalra@amd.com>
 <e9f542b9f96a3de5bb7983245fa94f293ef96c9f.1738618801.git.ashish.kalra@amd.com>
 <62b643dd-36d9-4b8d-bed6-189d84eeab59@amd.com> <Z6OA9OhxBgsTY2ni@google.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <Z6OA9OhxBgsTY2ni@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0242.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:21a::8) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|SA1PR12MB8743:EE_
X-MS-Office365-Filtering-Correlation-Id: ba28005e-2599-4a70-8270-08dd4605e9e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RW80aGF2KzlwQnNjS3lYMkZ3L1B1S3NiblBjdktJQnNwaEE0S3JOL1k4REo5?=
 =?utf-8?B?OFdVbUpod1NHMW9INVVBa0ZXbEcyQTNlVGZ0UDUvRVV3RW9qTDY1WXo2eS9u?=
 =?utf-8?B?blFwZmVmbjVkZTZiWDJnWE5hNFZYdjN5Skcxb0JRcVZWVVc0Rm9uRWkzVEVS?=
 =?utf-8?B?VHFNMU9nRjJBYmRpdnpXNVNCazdUNXdOWTgyd0c5anAySkh1ekpGM05kb0pk?=
 =?utf-8?B?OVdrUnpqT1BETTEwaXdPYktOaUhySE1BS3RHSGlRSzY3R1FBSFpVWnBGczhZ?=
 =?utf-8?B?V0lIVkNDUnMrU1g4UzdSYUtlb3B1MXhsQ3ZhUUdSclN1MXFQL1RQUDBvMHhO?=
 =?utf-8?B?NHBMUStPZS9IM0lOU1dHL1E3K28zdzhQOUhVNmRlT01hV2ZINk9zV1dqdTg4?=
 =?utf-8?B?d1ZaTGpXVVhiWnpsL0REZWJFL3FXTi9ZKzI1VzhVMlFNWjZOTW9BZ1lITXUv?=
 =?utf-8?B?NjhaeGVtTGdya1ZjZWRoQmlGS2t2TlNuSDZGdVU1Z2JOL1BjZFJJOWkvRDJN?=
 =?utf-8?B?bTIzQnNBRTNWa1kzQXJRWDRMQ01nWXNVL2Z3eDRUSmNrM1I3RWpaSytoS0F0?=
 =?utf-8?B?NnpobnN4VlNDMDMwWHNRNTNFdnFhVXplZVNpdjlTVHdaWEtHdm1IT2NCT044?=
 =?utf-8?B?VWxaaUJPeHVYb2NidEVFcEM5eVd2QkZjQ2lKMUVQZzZoZTdJcVZ2STNMckd3?=
 =?utf-8?B?anNQcStIS09yN1RYak93VmRJM3BjNWJrY3U0QllWQXdhNzM0amFxOThrM3lj?=
 =?utf-8?B?Q29TOHI2LzN4cnB4NHRTQ056dko4cklJWTFvd1QrRWdFaFhKenFybytlREM5?=
 =?utf-8?B?d205RmlMWGdkQmtrekZzMDBxVjBjNzhsa0NPL1ZhNGVEeHdzNDdYRDFFRENw?=
 =?utf-8?B?ZElINVZVSUJFQWFhV295M1hKWWN1SFp5T2pRZEgvVjIwekgvWnBaUTNXbHph?=
 =?utf-8?B?VzRXQjhxdS9ONXRNQzMwVjI3NWNpUmJqL3NuajF5c0tIS0JFRGQzWU1Jd1Jq?=
 =?utf-8?B?WXgvZUpZQmFmZjNtZm9sa1luSUFoL1pSS2N2RGwzM2hvYWNuRlYrbk9sTnNj?=
 =?utf-8?B?VE5oSk5zaEE5bGQ5REdJd2N5TTlZQlZJV3hDWVBsc3E4Tnp5L2NlN3hpVE9x?=
 =?utf-8?B?NGhVdFMvaDFGRVhWMjdHY1dkR05vN0syOWRBUmtvdXBmSGFOZWxETStMWGVQ?=
 =?utf-8?B?QzNLb3hiMCsrb1Fhd2hFTDlTYnFZamNWWUI5VTY1WXZqelY4bVdNSTBzUUly?=
 =?utf-8?B?NGdwcjV6ODJXUUxHdXlYS1lndGc4S3k3bzZlK0tIZzFTQnQ2QTIzMTNvMlZq?=
 =?utf-8?B?NlorUmZxVmJGeVBJdEtscFhtQ1RDVXNOdnh2QlNob1hINnJ1aGpwUXVHb3Mz?=
 =?utf-8?B?VWJvYXF4OC9sNktEek56LzUyOWtyaWZkVWFUZXF3dlVGUldlcEdqMEVxKzdo?=
 =?utf-8?B?N3hjcmJzRWlPNjNqbjlvSm16Tmt3cnFVQW1NRDJ0S1d2Sm5zTC8vY3hGYjdl?=
 =?utf-8?B?K3RFa0JNZ2M4Q09ieWgvczlHbjAvNk9JaTF4RWpwRGlNWWpuVkxERVBCR3Jh?=
 =?utf-8?B?bElDaG0zZGx6RjVKRXVSMU9kYUlma3JMTklldk9mRVB0dEVlc0l5VmQ3cmMr?=
 =?utf-8?B?OFVBUHJaekd6d1lWS3IvcThDOCtBVkg1My80YTBCZEhRcGdiTDFnWmlncHN1?=
 =?utf-8?B?cVF1ZzF5RmNCdVVzcFUrOERiWUtmTzBEdlFsV1dtNHNTaVVpN3cwNGFmR0hX?=
 =?utf-8?B?aTJoaXBQakhRajkrS0JsQ0FKcHNlWVdVZVZSdXNuL2hTOE5SaVROdXVlTk9n?=
 =?utf-8?B?Yk5jSEVocUZ3aFZPRjFDWExnVm1CMi9JbEV2QVFOYW1UQUUxRGUzSUk3UmVn?=
 =?utf-8?Q?Vs81Uu4FzAN/R?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cHVkcXEzOWpMOEZyODRBVVVIQ0FINWV1MGNkOG5aQkRuZko2ZFlVdVdURFg0?=
 =?utf-8?B?K25lcXJCMnFVNW4vSHAvcDBqOTRPdU1qd2ErTVVYemFpRlFFTGR5czN3NnBw?=
 =?utf-8?B?U1Btd3hLcHFta1plNzZYSmREZlVTckdaazBJbkZaSkd3MGEwdSszSHBJbndh?=
 =?utf-8?B?T0pCcmMwMlBPcDV1QVJQR2xlRFJoK0R2N0tSbzQxdkZ1WGNUaFN0bkEyUEVM?=
 =?utf-8?B?TXVST01PSzI5WkJhRUlMNjBrN1hTK0lZRHpGejhpUDJtbHRNS1RLM3dOSlVk?=
 =?utf-8?B?OGJ3UGdxeU8rcUN4YTRVL3kzWFV1bzF0eWFaOU9POVh2QjJKWWNIMzRRSDdF?=
 =?utf-8?B?aVdTMm1taHhGNDZyS0FnTmRHTXJqQS8xOVF6bWpubHJXVXVDaGV3bDdoVUxH?=
 =?utf-8?B?Q3hockxFZm5nWEordENBM0hZOUhlNTVLZEc2S2JRL25McUM1MWN6YjRKUGxh?=
 =?utf-8?B?U3pQdWdZblZmbUFqaXNmdEhuMDhMU2FjdUljdjBic3dTaXlsM3JyVEFYNmFO?=
 =?utf-8?B?RklsWGhFeVJhem4yUFdyTDBRSDYydHZ4N0NLLzhGcGQ1WUd0b1RsVGNUTGNn?=
 =?utf-8?B?TUFGd05adTBLa25ULzNuQ3BkWG5jN2V4VVA0YWZrUGtHZVVPdXpsRHlvck5w?=
 =?utf-8?B?K0JDYUtXcmpxTkJJWmVRcGp0bGZKM1A4bnhnU29SOVdHYXY3azViRmJyZGJD?=
 =?utf-8?B?blJMeXN1ZEsrdU14dWhMcGRUb3NQbENCdHZHMGFyRnpQQWRBOUx0elJka1hL?=
 =?utf-8?B?SHVWb2pEVk5yclorZGJ6RklPNm44NHhyK21OYkovaFZ1KzBYMEtsYS9ia1A0?=
 =?utf-8?B?YmlLSlRyZWlmYTZTTVJSOTZ3QzYweXhiK0JBWjlKV0F6b3doTWIzNkI2TENi?=
 =?utf-8?B?dGYwT25OUGg3OHhKTWJVeGNWWlY5VTd2aU8zMjRJNHdkOTVzNDBrbFNzUHZk?=
 =?utf-8?B?VEppUUNRWEFmZ294Y0tOb3plUnZ4R2xxdDRSUjgyM3hQYjZqZnlNLzJtTDAy?=
 =?utf-8?B?dzBwK2lpRFYxUm1wL0ZaMFFTMUhZQWQzZlRQTVRMTjVkVTJVbjZiNFB0b1dM?=
 =?utf-8?B?Q2tPc1ZOenBYdkQ4OGJyUXZOeVg0aU1ia3lFdy9xYmhXNCt2R25MdStPMmNW?=
 =?utf-8?B?TXNieVVkTUovc09Pd2VlMkFmR2NkeFVNUVp4bkJCbEdkMURWNlMvZ0lDZnJM?=
 =?utf-8?B?dEY2T0xudUYyVGp1QlFuUFNFdUtQUk5JZTFRUXFDQ01oZ21ESmFOZGZMdUVj?=
 =?utf-8?B?TnBncXBUc1czMWlXNWtnSkhlbzQyZUY0bWJDcHhRL2tYeHdXMXMrOEZCN0xO?=
 =?utf-8?B?NWFjMUsxenNRTEl2VGR0eEhtWEE0eEd6MGgxeGdaQytiNWxkck1xNHk2TUhx?=
 =?utf-8?B?VVNqSm1HeXhjVXhXWXl5VmY0Y1JidFMzT1czNmpGdVMxZkpRVlh1UHRwTi9s?=
 =?utf-8?B?YUR4bHplNTJnUFAxa1RUSFhsY216bktjSnNDMEt1Si9WL0dRZnc2WmNOSDEx?=
 =?utf-8?B?bWZGNmE0MnlCcUhwVzJ0UGRDeGR3cndvZ01NeTZ6WXdHMElLeVRBNVIrZGMr?=
 =?utf-8?B?Ly9BL3FzeE5NMXpZNHlBYVQxNWUvdmxrR3dqWDFKMVVUMTRlYmZoS3BHNHc0?=
 =?utf-8?B?SGNxZlR2cEQwOHpBZW9ZSVROdko0SlkzcVRCNXBRQmY5c3RuZEN5aFN0YlFv?=
 =?utf-8?B?VlBMRHpLMmZlcWxmVVVDYWJWUmhnZ05pZXJ1ekFiSVhXY2tkYUZNQmtxK1hT?=
 =?utf-8?B?bWZ2R1FJb0NtT0pTRWpvQ3RPSjdzVXprR1VBd2V3VzROUXhodDhadVJLdHZB?=
 =?utf-8?B?bUQvSHNJc3E1VjNkbmU0Zzk0aGNKSk1kWXgxOFVObW5pRmc5NlpBN0UxcGtE?=
 =?utf-8?B?M1ZKRFd2Zm8wRVltNjFTcjl0SGFCRndLMmxKYmg4WkJvU3QvaDNuUVFJd3Zh?=
 =?utf-8?B?WlpEaDVKTk5iZlg1Z0lxdVZwTitOKzVLbFNzNFZUc0FmeW14ejZYT1dVbWVV?=
 =?utf-8?B?bDdOcUVNdVUrcXlxb1hkaTRWYmdwc3BTSGxObFdHd21ZdGNUWGhJSmFycndt?=
 =?utf-8?B?RlgwUGZLQmIwQUxnb0x0bEpPZHVFcDNOSTdrZElhQXVuaUtDWlVmZDBnOThL?=
 =?utf-8?Q?fnx2d9Av76FsgZUKPvk7ZLqMd?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba28005e-2599-4a70-8270-08dd4605e9e7
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2025 16:55:37.3599
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aKh+ajKs7UOyI3EC//5uuVCECyw4xMO5xXWBzSQ9FmJfe3mZEdhm8DZkbnuxED8RmhWKvqRkGyd7jsw5VsA4Fg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8743

Hi Sean,


On 2/5/2025 8:47 PM, Sean Christopherson wrote:
> On Wed, Feb 05, 2025, Vasant Hegde wrote:
>> Hi Ashish,
>>
>> [Sorry. I didn't see this series and responded to v2].
> 
> Heh, and then I saw your other email first and did the same.  Copying my response
> here, too (and fixing a few typos in the process).
> 
>>> diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
>>> index c5cd92edada0..4bcb474e2252 100644
>>> --- a/drivers/iommu/amd/init.c
>>> +++ b/drivers/iommu/amd/init.c
>>> @@ -3194,7 +3194,7 @@ static bool __init detect_ivrs(void)
>>>  	return true;
>>>  }
>>>  
>>> -static void iommu_snp_enable(void)
>>> +static __init void iommu_snp_enable(void)
>>>  {
>>>  #ifdef CONFIG_KVM_AMD_SEV
>>>  	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
>>> @@ -3219,6 +3219,14 @@ static void iommu_snp_enable(void)
>>>  		goto disable_snp;
>>>  	}
>>>  
>>> +	/*
>>> +	 * Enable host SNP support once SNP support is checked on IOMMU.
>>> +	 */
>>> +	if (snp_rmptable_init()) {
>>> +		pr_warn("SNP: RMP initialization failed, SNP cannot be supported.\n");
>>> +		goto disable_snp;
>>> +	}
>>> +
>>>  	pr_info("IOMMU SNP support enabled.\n");
>>>  	return;
>>>  
>>> @@ -3318,6 +3326,9 @@ static int __init iommu_go_to_state(enum iommu_init_state state)
>>>  		ret = state_next();
>>>  	}
>>>  
>>> +	if (ret && !amd_iommu_snp_en && cc_platform_has(CC_ATTR_HOST_SEV_SNP))
>>
>>
>> I think we should clear when `amd_iommu_snp_en` is true.
> 
> That doesn't address the case where amd_iommu_prepare() fails, because amd_iommu_snp_en
> will be %false (its init value) and the RMP will be uninitialized, i.e.
> CC_ATTR_HOST_SEV_SNP will be incorrectly left set.

You are right. I missed early failure scenarios :-(

> 
> And conversely, IMO clearing CC_ATTR_HOST_SEV_SNP after initializing the IOMMU
> and RMP is wrong as well.  Such a host is probably hosed regardless, but from
> the CPU's perspective, SNP is supported and enabled.

So we don't want to clear  CC_ATTR_HOST_SEV_SNP after RMP initialization -OR-
clear for all failures?

-Vasant


