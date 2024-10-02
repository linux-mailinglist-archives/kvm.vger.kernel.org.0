Return-Path: <kvm+bounces-27829-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F023098E597
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2024 23:53:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 24DF11C2264F
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2024 21:53:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECA9E1990AA;
	Wed,  2 Oct 2024 21:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="NGEViO/i"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2068.outbound.protection.outlook.com [40.107.94.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19FE197A6A;
	Wed,  2 Oct 2024 21:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727905982; cv=fail; b=BWcKMjC7zPD4uhatjAqJEhGyVCtTDcTEGc8vn9GM8Lrgytp4x+8iJLZo7uSXoFssV0LyhA/z30UGlJpzmR8ZMa2d7s2YS7DtSVIO31Esis0NbLzX7bCgprcFwakkZ0EgfxlD4G/LPVB6IxNil6wnMTfIs1luEAJCYM663e5T3Ws=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727905982; c=relaxed/simple;
	bh=PtC88pH0CPwpxL0IBG4uJtx3WeoBhRecuzxposAZpBk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lTKIb+t9bN9w8xpDB2FRypPv0WzUY3lGQe+mPTmnoSVHXIKv2MRmmRAm4PHvKpgGLrz7ADCgBzkINc8gQAbwIwIGZNhjSrKBcYjXGvsR0NlLO9GjzNfmRgC/vXIbepHKaCsiaBSZzyeJMtPhRYW+CMMPB/3e4DojXKJe7pKXj9c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=NGEViO/i; arc=fail smtp.client-ip=40.107.94.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t3Skzbn8M2Tpl9QP8+VNRei+PNiEBZ5hKivkcQGvugyDdchJNSXX3FX2HG87dE5sX9pGsMV42Guz1LnyLN8kh102Omb3E0WSA67HUg97OE3/mZSfTAa0q1KFRtuSwoVdlBiiDShHnPZsDltU9DdeEuornqzoXvQETzd9gHPfWY4ZnXSHa5QtZxLEH/uzbITIofmL4QSg5LJLSvs90bXjcANF30xbes4HgBL0HwL9gLEpzBHowICfZQfSPU82QwRrI31WIeHYJv5OZEY3fMrJ+U4fPQcOOMhR0bdVKg4I8rHjd+s6wukErt6c2SaoYHWB0sGMf0NQbnLMnRfgpZNEag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D2ERhcMiKZTzzWHCGTTPY1yiLXBxOr+aujWcqCJDstE=;
 b=v3NT+SvyQer0xBZQWQKGNYSqXkr97q7nZXwtjEmhTgqARtK3FuIyVj+dq3K0Aig14B/5a7b5KEokanJs0+HTtAdpyiqfAXey0PtDXt/X4YvJ2qSDB09zAScHquSnPezr3jm65ocxhBKOtzrgNAsQZ1BAoY7erkccmyANuGiOlfYRoO37V6alw9IJ3odXJXVOG98g4PgTV6bdhdjsmQ52dN+J8lfUBaQWlaec2RLR2qwRYC0tbQ1wxcSsq4M1YDdvacUEVsEBH+bN3VGNGLCBKSjW+mqSKNo1DSgQ56Zg55/nlX7eevoOc9D2JXmRBcyuGi62RyiKs480J/BDx3hB0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D2ERhcMiKZTzzWHCGTTPY1yiLXBxOr+aujWcqCJDstE=;
 b=NGEViO/ibuCJpvb5JtqBP2J8tNTZYsBt89MzlKjmJkplpIbyMcpwkQUWUhmgqH2AIbaydyRtv1KQAj/fpYLvJbq+qtDVJZpLv7VNaq3WunzSCMO7CALhjipkrvXbwVCKA3JibHolJjZMnDSkNr3HEk9Ri2dbkLUuMmNuU4upLTM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by BL1PR12MB5874.namprd12.prod.outlook.com (2603:10b6:208:396::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.16; Wed, 2 Oct
 2024 21:52:56 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8026.016; Wed, 2 Oct 2024
 21:52:56 +0000
Message-ID: <df49ffea-e1fa-43f9-6b78-10bf6a416b35@amd.com>
Date: Wed, 2 Oct 2024 16:52:54 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v2 3/3] x86/sev: Add SEV-SNP CipherTextHiding support
Content-Language: en-US
To: Ashish Kalra <Ashish.Kalra@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, herbert@gondor.apana.org.au
Cc: x86@kernel.org, john.allen@amd.com, davem@davemloft.net,
 michael.roth@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org
References: <cover.1726602374.git.ashish.kalra@amd.com>
 <f2b12d3c76b4e40a85da021ee2b7eaeda1dd69f0.1726602374.git.ashish.kalra@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <f2b12d3c76b4e40a85da021ee2b7eaeda1dd69f0.1726602374.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0058.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:2c1::9) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|BL1PR12MB5874:EE_
X-MS-Office365-Filtering-Correlation-Id: 66f227de-eb11-4f64-d46a-08dce32c930c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cERKWVNYMHl5OUI1Z1JYZzNCZG9qQWp0UU1aQWdQME12RHJFZGIrVFJVWFZE?=
 =?utf-8?B?ZGZzTXNPNnVBajl5NWo4Rjl1VzlhQXlmR1UxUU9wTDRoM09oQnhadnFyZE91?=
 =?utf-8?B?Rm9RUUF6RjlWTkxKbG1ublZSSWZYamhGNEo3TWpGYkVPbUxYdlI4Nndha0hz?=
 =?utf-8?B?R0FFWmYwdXI5K0I3cnNqUFo0c05WU0lrWHVFVTExNGhSbGFBZ1E0Z0RUR05u?=
 =?utf-8?B?QVBzUGVNTEZ3cXNRNzJPU0VPaExrMnJ6RTJSdHBkL1dwQkIxcHEzMXZFTWxm?=
 =?utf-8?B?ZDJ0VVlYZDZLV3hWMzRZb3psR24rZk5FNHlBUHpVaGIvMGJ4R25iUW5sK2R6?=
 =?utf-8?B?NzNHYTR3ZlVydnAvMHZsaUlTbkFYMUptTGErYU5wTytsamdPdTc5dkhLUCs5?=
 =?utf-8?B?NUV5eG9DZFdjMWhPRVlEQnNHK0RrOStpRmVQWXRDemRucEpQRWRmcFIwalM2?=
 =?utf-8?B?RXdzS28wbGVKSHMzK0dwcmw5UlhoNExzRFBNTUVjVGMvMWxobXJVOGxnVVRt?=
 =?utf-8?B?UTh6YVZCRk5vUFpPUW05OU10dklnRG9sL2dPUHpvMXNCM2ZJRHFpSmFaZzdP?=
 =?utf-8?B?b296dEN3WGlGay9CTzk0dytkSEFvcWViT2VZbDZKNDltdVk0VEliSE5tYW9E?=
 =?utf-8?B?MWRuTi9SaFI2ZjdRQ09CVytFWFh4QkZsZEROSldGWE44TjZsOVJFMENaNWRS?=
 =?utf-8?B?TDkwVGFKR3hZcHNsbDVYem5Kc2xSSnZHRHlyVHV0bGxEQ09ySHFaeWp0VmJO?=
 =?utf-8?B?bWFSMFNNM0VKY0NibXZFL1VMV2xxRnMwYWovbkhVZHYvQXlHRDA4T1o1NG1F?=
 =?utf-8?B?ZkpReW1MbkJGWW1OaENDT0VrV1B6NXhINEFmTjFrc1lodkY0YU0vbTJVRDA0?=
 =?utf-8?B?dGZSMlpKSmtHSjBTbXBoTkRNREpHc0wvbzlpNWVOZmFJVjVGREVUQlRmTm1k?=
 =?utf-8?B?SkFGUmx2RVdncnU1ZUd4ZUdBbURoMFhRTFBGYTM1K3dMZmpSZHZxYTJCTjZi?=
 =?utf-8?B?dHdNK1lKM0dYWnl1NGxzUm9oSk4zemt1UVg2UUY0RXNYSTYraWVvbUhmaGRD?=
 =?utf-8?B?U05XbmRvN2ZLNzVjYnBqZVJnMHVaTytlUDBaT1pVSnRRR0JsK0VqLzdMQW5t?=
 =?utf-8?B?akgzVEpQTGtWSm9FUEVzc3VuZVUrUmJ6MER3RWR3aEJFZDM4T3pQY0ZJZCt0?=
 =?utf-8?B?Zm5jYW1hczI1QVArQ3YwOXhKUVpoWjA0Rm9tOFA0bnRicVBPeHE5R2tKQ0l1?=
 =?utf-8?B?aVAvTDlVQkR2T0hKYXF4bDJ3NUtqTytzTzdTNVQwTEF2cFd0WThTd1lOaTFa?=
 =?utf-8?B?ejE1c0QwckwrN3V4dzJZNHkrQWVVOHd3Nm51T2djMzdPMkk1eENyTEFWanlP?=
 =?utf-8?B?dzJPMnhDcFhXMHVmaXEzd2hFSlVNeGxjYW53ZmpQbFY3ZGpyVGpZWUVDR3Bu?=
 =?utf-8?B?QVBaenZqcmpNcDg5T0dFL0FWeHRua00rZzBXZlZPT2pKQnJjUUpzYTU1czdr?=
 =?utf-8?B?TGhMa0dQeEQ5SExUNFQxbWZpOHVSWitaMWVPWkdzK002ajcrbzlYTmh4UUlt?=
 =?utf-8?B?bWJvWWpaUWxvblVTKzVuelVNSHBGR2tzTkZZMXBEakpkM2I1bVNOcm1IdVZ3?=
 =?utf-8?B?MHVlNlNLZ1haaG5hdnBtbDFwOFFNZ0dMTm0wYjhlMERoSWs4LzI1bDhGR0Yw?=
 =?utf-8?B?amc0UStBRm5qZ1N4L2xjR1JkZHAxSldSOGlEUmo5aFVUalh1OVdKaDNRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V2lodElWZWxLeWF5MDVkcy9TcjNwY05TVWlWbWIxazB6U2h5WG9KMTRhVGRK?=
 =?utf-8?B?a0xqbTg0ZXYxSC9JbUswV0lFQ3h4VWV1S3dZaWtyVjdRb0VkeDRna0JxdjZ5?=
 =?utf-8?B?SFEyb3A4eDRXZXlWWnVsN0cxUWN5UWVLUWIzVmdnZktOYUI5bEF3ZEpQSXpk?=
 =?utf-8?B?LzYzV2RiY25OMDA5bk4yNjJVa3FtQ002Q1c3WkEzL2tFNHY2T2UwUGUzZ21L?=
 =?utf-8?B?ZjRjVmtOVVJmdjdlSnJIZ21JaU8ycEQvWWZ3QWwycXRFK202WGRheTdiYkdB?=
 =?utf-8?B?ZVRBZXRsSjNFa0I0aEw1NDlVZXZPUzRnSW16OTFVUmpmR1hMYTBieWJLL3g0?=
 =?utf-8?B?cXJDaGZUWTF3UmxIN2VnbE4weEZUcGE0WHR6N1UyWStnL2pJSmZwT3FzeW1u?=
 =?utf-8?B?ajZLT0FVb1hPU1NuRFpXR3pqcnJhajFLZ3BDeXpKUFlpanZ1bUIrUmVsNG54?=
 =?utf-8?B?ZE8yZGhuL3pva3JCeDNlVk1MNmROMWhyTThoRHJvNnIwN3pkVVVmNTJxZFJE?=
 =?utf-8?B?TkNqU040TlN4bkpYV3hTd2d2N1ZDMUpxNVI3L3VHR1AwbTVHL0RIV056a3Q4?=
 =?utf-8?B?ZSswL3VCemxLRDNIbVhuWWErb3VTb3FIeFpqZUw4RTZxdE4vaW1LT3lTSFFs?=
 =?utf-8?B?MllkdHhyVzBZaDNLcUZZY2wxU3hHV24zSEYvY1Z0Nmp1MXN3NEkwVUJ2UTkx?=
 =?utf-8?B?cG02K0Y2QlMrWGZwZTg4VGdKMzJlcnp1cWZrMUtoRmhpNXZybWNtSU0zKzhG?=
 =?utf-8?B?bVlpbXZHNmNzcjNtdE5ocjE1QVRVVmYreXd4WXQ1TzFrdlVmT0JFVUd6ZGFw?=
 =?utf-8?B?aWFJdnVqc0tyNU1sOVdnUmRabGN2bzFxVEU5QThHRlM5eEt6ZXlzNjA1ajJw?=
 =?utf-8?B?Yk9nV2gzZnNMZFFLNFpKdXcxaFppU29UN1Z1RjRza1AwWDJ3Nkg3MnkwdWN1?=
 =?utf-8?B?MGVuZWtDeldBOCtnU3dITlFyU284elY0VzNZVzhucU9oOEZzb29PKzg0U2gr?=
 =?utf-8?B?MUVEOGp0cTV0d1U3WWRKb3lzWm5uNTB3ejJKVlBpTzNKeGxZVjdtZnpmT3E2?=
 =?utf-8?B?NWhMbVdFMEN3TlAwVDFRd3NweWE0TE43d1E5cG8vWFdFZFVvWGZPTXkybzRQ?=
 =?utf-8?B?YnlFUldxdjUxTkFrN2NUSnpwcTdqRlFqYWZtd1MyL2hEKys3NmQydmhPejVC?=
 =?utf-8?B?Umd6TFUyMVRpMDBOME5nYncvWmJpMERUcWNRM0pxTnFjanEzLzA2NG4rWi9Y?=
 =?utf-8?B?RG4wcDM1Rjl3YkFybmRqRVpCcDZTbGxrcGNGMWlVeFZIdUZGRG95Q0pRSS9O?=
 =?utf-8?B?QnVEdEFjMmpvRW9wR2JHWFUyV2FhTk9CUDJad2RLbkcvSlRWa3RJYmhSOU82?=
 =?utf-8?B?eWVMVTBrNUhsVzFvOTMrTGh3TkNlQURzcmlRSm1QUVhiQ1ljZUxUeUp0cmdF?=
 =?utf-8?B?TUxkWlRCNXVpNXN4TjltQXdBL1ZlMFMyRkZYdVFWbkh4d2ExTVByTjNseDBG?=
 =?utf-8?B?dk1JUUh6WC9VazhIVW5HYWVBYy9QNFQ2UTdXZVVDQlRGUEZheENSS2cwUTEy?=
 =?utf-8?B?WDFFaUJndkJwVzRtbzlHemI4b2JENGs1V3NnM1FBV1hxNHNuejJYNURkd0Rv?=
 =?utf-8?B?dTZLSjN1eW9zNEp6Z21yTlFmc3h1L0J5TWwyV3VMeUhleWVaTnZDcnAvcnVp?=
 =?utf-8?B?dnRpQXFzYnY0OCtySEQyNUlGcGxZQno0WFh2VDltV3VuZ3BzUnNLUFJ3VjF6?=
 =?utf-8?B?cUw1cG5EaDc3U0twZVpqYnA0bDNjRlBnUzUzcnpGVjhSYUt5NWpPMy9Dclc3?=
 =?utf-8?B?VXUzYVlCWnA3aloxbUpYUTk1QkI4Rms4eW44S3NJNmRzVE1YdThuOE90akx3?=
 =?utf-8?B?Sm95VCtCWXVodGxxZGRwN3MzamdZU2xSdW1KOWs1UWR0bWI4aFlESnM1SXJt?=
 =?utf-8?B?NDhOdEhRSVR2akFvcWRkeVFrbzRCTHJvZ1pkK2diWUNsRWpmZ2tsSUx4UHZr?=
 =?utf-8?B?VVhtWTRRY2RQRS85WXk3b0htcEJEOWNRdjhBM2ljbjg0b2tRbWFLNVRlMUNl?=
 =?utf-8?B?dFc5T3FLSG9Udm1oT3ljTDk0aWEvVktDNVhYeU1yM0NTMGFQTm12S0x5cTZq?=
 =?utf-8?Q?jdMBa2Uvvc3ZQyFHg1tL88Y7E?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66f227de-eb11-4f64-d46a-08dce32c930c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2024 21:52:56.6266
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2RAwllbdiVv0wmd+2kg6hLRTI874mnwPZHMwjWIZOJ+ikSWuMzGkjE6PflIfBwcoMJnvo6K3/kHajhaJAQ5Uaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5874

On 9/17/24 15:16, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Ciphertext hiding prevents host accesses from reading the ciphertext of
> SNP guest private memory. Instead of reading ciphertext, the host reads
> will see constant default values (0xff).
> 
> Ciphertext hiding separates the ASID space into SNP guest ASIDs and host
> ASIDs. All SNP active guests must have an ASID less than or equal to
> MAX_SNP_ASID provided to the SNP_INIT_EX command. All SEV-legacy guests
> (SEV and SEV-ES) must be greater than MAX_SNP_ASID.
> 
> This patch-set adds a new module parameter to the CCP driver defined as
> max_snp_asid which is a user configurable MAX_SNP_ASID to define the
> system-wide maximum SNP ASID value. If this value is not set, then the
> ASID space is equally divided between SEV-SNP and SEV-ES guests.
> 
> Ciphertext hiding needs to be enabled on SNP_INIT_EX and therefore this
> new module parameter has to added to the CCP driver.
> 
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  arch/x86/kvm/svm/sev.c       | 26 ++++++++++++++----
>  drivers/crypto/ccp/sev-dev.c | 52 ++++++++++++++++++++++++++++++++++++
>  include/linux/psp-sev.h      | 12 +++++++--
>  3 files changed, 83 insertions(+), 7 deletions(-)

I missed this on initial review. This change goes across multiple
maintainers trees, so you should split this patch to do the CCP updates
first and then the KVM updates.

Thanks,
Tom

> 

