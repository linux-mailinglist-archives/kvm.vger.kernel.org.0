Return-Path: <kvm+bounces-60900-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C445C02BFD
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 19:37:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 091204E63DC
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 17:36:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B71C734A767;
	Thu, 23 Oct 2025 17:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="loaa9cLq"
X-Original-To: kvm@vger.kernel.org
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010068.outbound.protection.outlook.com [52.101.61.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8533230AAC2;
	Thu, 23 Oct 2025 17:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761241007; cv=fail; b=betg/8i3vs6iXWXa4vvz+iudmCQkeyXU3JMOX6leEAldkWs3ZQVZbcAJkuejcLRvZ+8V77lDRYlMnTVL1s7yxnxmKs4W96czpVZrXgs3Cl7BIGopuz+3ltBKDVNP1j1CHdGUpI5Ryr8uMV56ve3srd0KjCAtLK6bX4vDrQwMJrg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761241007; c=relaxed/simple;
	bh=7YGXPpLeuZDh8nuH10HX1V+WHq1E3Bz+LnzHeQvLIwI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=o9UEVxkVYd3NqiYHmc6MhKlJCMeZB457q9OTyIdztmj9XZKvQjXbATvmIrLCic7Y7N3MyDP81u5Fdqa2Nim+Bns1F6W5M0J7A+ojDb08/PlDpE766Dtti6hkvBeSv6leDdqzLrwGS24kmbny/ye+W3AinoSHvRTD4PymncNXj/0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=loaa9cLq; arc=fail smtp.client-ip=52.101.61.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KwFWRJeg8rvr3knqWXxh+vRI13mF1nVQnHB2leocJWoya5mpf1MYRIlDki4OktPUnXMaSIw9GUVzztIvdCxkdito2FFjvSxTCR9H9EWtCw7eszYwnfSMp2yBjNlbIy2/K6PrFICubYszBOqlpIX6r6pASiyDRIgFmPwSWLqcFv8r9etyPkGZiKmgEmLtq+GpSaHSF6BT9M+438ukHChPijc8BktV5Y11miMPywrLSquSA1/082FjyXSy+rZy/+tHVa9cMU4Y1k+aS2qaVrjSs3DhS88JX4QVR3Qto/GH49PAWJHuwVLxBBynKeNoIa1NcVpt4cFxNVVFluZgZUBRGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ThwNIHocAmCNYI4saTGCWg1Si7KVwyCGb7KGXVBrlE4=;
 b=fOfu3uukHwGLFPSay8W9pRJiWTjY4Jr/dlbwOUMi/uxAyoooi/rqX29l2agVdPlos7sBbDW181T91oDumYmt/5a0hKnHmxqyiHmborp6wbvCZLTuZsYfFnOpkdjbo3pHIwTOnP4NoODBHZl1Jn/GOU+wjve2jWeNYSNF1dnAQ1XlqBSYg7XLD170wOM1psOXASlwOUH2jREi+V9FXiC+J9PJzwg2tbSA9aQaNR2Wi/d2mzKorBb2DTf1Ue7mrT/xA47WKvhLwjRNia4sNria7JWYrERZVT5xJqlGZSxXzr76mqoDsp3gPWHrA0WZNsLO6LuM7m/cehYfL1CkM+/Cfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ThwNIHocAmCNYI4saTGCWg1Si7KVwyCGb7KGXVBrlE4=;
 b=loaa9cLq6ksZggpT7Rl+5jLDMpwuFDYBfT3BZxwSqzFhqM8QH1JstVe8ooMVd+LYZ/gAWxiUWVTiHJJnAOqIqfWnAf0nvrGUK5zX8uKYdyq4Z/UIyyReXDCA+L3NpuYY/20RGSdyBuV/MxR9jTeNR6mCgn8KOE0V6/w3PfVQ+hI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SA3PR12MB7949.namprd12.prod.outlook.com (2603:10b6:806:31a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Thu, 23 Oct
 2025 17:36:41 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%3]) with mapi id 15.20.9253.011; Thu, 23 Oct 2025
 17:36:41 +0000
Message-ID: <f58d3b55-352f-4771-8b73-5ac81025a162@amd.com>
Date: Thu, 23 Oct 2025 12:36:39 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/4] crypto: ccp - Add an API to return the supported
 SEV-SNP policy bits
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 linux-crypto@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Michael Roth <michael.roth@amd.com>, Ashish Kalra <ashish.kalra@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, David Miller <davem@davemloft.net>
References: <cover.1761154644.git.thomas.lendacky@amd.com>
 <3a86b3678a78a8b720d3818f4121972f67e2d0a8.1761154644.git.thomas.lendacky@amd.com>
 <aPpZrpfes8-SY4k_@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 vFkWitqCJg==
In-Reply-To: <aPpZrpfes8-SY4k_@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7P222CA0025.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::35) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SA3PR12MB7949:EE_
X-MS-Office365-Filtering-Correlation-Id: 22d3e88a-889e-4c23-9879-08de125aba20
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RW0wZXlobFhXaElmUW1TcjNSTzRCdUVBQ3NYSjZoTkxKUjlheHRZeGRJZkpB?=
 =?utf-8?B?MVhJbGFTcUdGR2xySHk0dGZieGsrS1RMVVBwS1JkWEVkMDAvVHRXRVEwelRC?=
 =?utf-8?B?U0dzQm5QV2FRc1crV01UWS82NUtobmQvVzVtejR5Z2ppcWVyKzVTeWxVb0Zl?=
 =?utf-8?B?aHcwby9iTU5yNzFnSmR6L1Z2OGRCaDZ3N2Fxb2FuZzdkVXJDbjU1RjdTYjJO?=
 =?utf-8?B?S0Z0WkJnVEJmbTZlR3dTQm9HSUVHZk11MnVFUVY3K0hpNkF4anJaR3lTejdm?=
 =?utf-8?B?Ny8xWDViUnhtdm1sT2ZFS0t3YTFLUGtnMDNmM3ZOUFNWa1NDUVI3bXgzQ1lN?=
 =?utf-8?B?ZllSVStVUG51RHBNTnVxVlYzTmlDNWVnUFU2MUptM2h6NzIxTkQ0WEFhWTlC?=
 =?utf-8?B?UkVIM3YzTXVIWFQrZFphNGlJU0RFbkRleGovVDRUUzVFTGthcWxONmdLTHR4?=
 =?utf-8?B?elBiMlAvR2thb1FiQjNnRjhWQ1pYbFA1UUpqUU12cXkwMmVMUnVDUG1xVUFT?=
 =?utf-8?B?Mk9ya1JXNXM1WjNsN2tJc1ZUS3IyOEdoMEhWcWMyMTBIaFBuSEZKL05UTzZo?=
 =?utf-8?B?cHdiMk8vTFVsZ292NGpxK0pqMDdxS3lIQ3hjMllPcFhOdDhRRzFRZnhXMVJs?=
 =?utf-8?B?NFdDWkY4Sy95bk4vbXAxSjBJK21LcVMxUElZYlcxaDhXNzc4OGt5YkhiRHMz?=
 =?utf-8?B?aEVBWHhMaGsxL3dCMkJxSmluUmpFZHlGa0NtRWNyOHZKbUZ0MjE0VWpZZVUv?=
 =?utf-8?B?NU1Tb0RqSWtRcC91OFBPMDh2NERnbkdLTDl6WWZRMmZOZmpGTk1rZ2Y4TXpF?=
 =?utf-8?B?RTV5UGFIYVlXOE93Z2tTTThLRHhRMkFzMk1yMG9YcEIzRk1MOC96Y0tKN0NB?=
 =?utf-8?B?NGJhNjlJNG9RSmpKeUZ6WnhzUDk4UW9PV1NIdHNaZXRtWXlud25ZQVNTR3lB?=
 =?utf-8?B?TTBWQStGUGNGMmYxMS9EK0d4Y2VtUTl2UGpjS21IaFJKVDZnTWZ5TzVYZjM4?=
 =?utf-8?B?MUY5Vnk2QXhpenphNko2MlBIcTF6R04xTkYrU0RndDErUmUxR3M3UnJGRHNp?=
 =?utf-8?B?MEhGSDB5QXpSWSttTU5wYnBFMmlGR09GUTFKUk5UTHUyOWo3bVhmTmd5OUJ3?=
 =?utf-8?B?empYYy9IWVlIUXZNcCtIYzg0TE1FRHZMSXJUemZjNWZkWnBlaW1zN09zajNv?=
 =?utf-8?B?Nld0aDlXREdTZXdkLy8zdm5aV0J1S2ZwRnE2N1krUXNIdWhvU0JOdmI5OFJr?=
 =?utf-8?B?U2F3WG54dUJNYXpiVFg5S2IxKzdmOW5lOURrbXhaL2FXZnZ5aUYrWlM2QmVW?=
 =?utf-8?B?b2tJQXNQc1h3UkNyUmlLVUk3UXZBNXB3SGxuNmFoWkxxRTBVSjlFeGZGbUt5?=
 =?utf-8?B?K1RPNHBQWGw3cTJSUEVsV20vcU1ITXBGWlJkYTlyMm9qMUNUZ1pUaldBVGhB?=
 =?utf-8?B?U2RxcnNwRDNkOUFnb0orSVZMaGhrTHZFTGlHZTB6MENtSUtyeHBaVXBENDFD?=
 =?utf-8?B?M1M5dng5ZTRYbnZoblR3UmNCNFhYSXdWemV2dkNrTlZHU003ejhoNnlmblpU?=
 =?utf-8?B?L2JYbTllamtJUVM5VjJpZFdXVUV6aHRqWFYrL29kVldib2xYeUdCcWNJbU1v?=
 =?utf-8?B?ek00U0w3N1FKdVJkclZvcVpiQlc5MVo2ZU8vbys2MVE0dzNLUEd4UitMdTZC?=
 =?utf-8?B?cEYzYng5Q0orYXBoWU83WGNCTEJrWWhOSTF2NEZSL1c4VTRxWU1uU05vYmN4?=
 =?utf-8?B?cFRBNjVoYXBCc0FkcjhhTjV0ZFJOUjJqVTRBRkRXRTdkanFsd1BMWTRVakF6?=
 =?utf-8?B?ak5IekRKTDZlZzVzd3lacWtUaVpqNHVQN3VHTTRYc3BUMGgyTkoyMFVNSUZ2?=
 =?utf-8?B?ZkN2S2ZZNzJmVkI2STFRcWEvT1NlTGR4aXJqSFZlaUhzY0lJNEw3V1ZwenFt?=
 =?utf-8?Q?UKbFC1pWhftvWZIIYopLcjFnTQ7Scq3U?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YmtMbURaV1RSY2hiZHN3SXRZU2tlTThERHZXNm5sMFdGa2xHZmd4Y3lwS2Fi?=
 =?utf-8?B?S00vcytxU2hBK05aYUV0QnQ5dHhLMWlybVp4aVRpZGdMNmh6ajhDd3NZaUl5?=
 =?utf-8?B?dWRJM042endRVmkxSEZ2TFRCTGlkM0o1UHl4TTVBaGlaRjZ5dWh2YnNCeGpP?=
 =?utf-8?B?ZmZwbEM2bVlDeUppK0xxcXZyUWFNaHEyNlFZYldjd1hRaGUwcGZOTDE3Zit3?=
 =?utf-8?B?TGJTOXNhWERCVkFzMzA0NURrd2JWa29sV3JncXpXdklVdk5QdnBYNi9XVWNI?=
 =?utf-8?B?WFA2VktVdGtKZmJ3anBZSmIrRE9id0pLRDhaUlpYUjV2M0RtM3NVUkpJbXkr?=
 =?utf-8?B?ME1QUkt3bjlvc0V3RUlwczk1WmFITWRJMTN3MGVWdHRidVVPSjR6cGJjMnpr?=
 =?utf-8?B?cWJJenJXYUt4MG1RVk8rMFhvYlpHUzNITEJFTmc4OHppbXc5TXJuNlE2T3Zx?=
 =?utf-8?B?VVExTVc0NnJ6QklZckM5aFZJS1hwTnRnWGVjZDhQdlJoWk00YmlhMHRqU3Vi?=
 =?utf-8?B?L2VVdWZZVkFaQm41VUIzRHU1dUZWM1BvZVpyZmVrcjZSMmRVWVJMaFVNNFor?=
 =?utf-8?B?bGYzcDV0RTVnOUVjRXZZWE5lN2JPWEg5SFRmbEtaZHJnYVFPMzRiZURCZ3hR?=
 =?utf-8?B?cDdvMmwwMVVkdC85NnMrLzY5bzkrL0dCamdpblBLc2VzUnpHeDNLSCt3cklw?=
 =?utf-8?B?cDhSa0t3RFFOcWNzMUMzL3F4NkxocWFzSmVYVUdZR3c2ME44VlE1SG91WHBR?=
 =?utf-8?B?VE1PQWUrSXRRbUliQjNhbnNYMm1XK0RvNDZuSlNhQXo0VXMyenorTnZmYm4z?=
 =?utf-8?B?N0tBejNQb1hFRHFXLzluS0w3dGx1c0tzbWFhY1huSVVzaG5iUEJHYzFnNmx3?=
 =?utf-8?B?bWljcWF0ekVaZ2doQ244SVc2aTBIME1qbUgwd0ZlYlNtRzFsVTNCL2tCVFBh?=
 =?utf-8?B?c1ZsSkhHK3JNdkRRR29way9VdDliV0c4TFlGWnIrbnd0Nkc3eTdzWVZQdTdk?=
 =?utf-8?B?djlXY08vdXI0d21lQThHb3JpK1JoZ0FpcHAvTEUzT3NoaXUvK2QwbkpLai9w?=
 =?utf-8?B?QW9xSlN4MW5EczNRT0sweDBBK0dLbnpnbTNreFhVTno5QmVic2liU0lWOWF1?=
 =?utf-8?B?b1FrclVobVBnNXFHVjNkWE1OVWllcVJDM05PblQwSlNBWGhOSjZDaEN4UVRZ?=
 =?utf-8?B?MjhOMVo1SVAweHc1TXVWK29KS1NMQ0Rva0xwaWxFR0NZc1prd3oyRXFxblpD?=
 =?utf-8?B?djQ5OE5TcFpiVmJHVnZNRy8rL0FmTytEQUc1dkdHUjdLdGF1cWtENUtHQ24w?=
 =?utf-8?B?cE9QaGRWVy9yblp0cG5Pamk1TXg5Q1B2M0pRaTkxQlVrSzBjbWRxYXNzRnBV?=
 =?utf-8?B?WXFERmlyeFB6dUk2Ri9vZGZRZ0xxRzZ5bGpER0h6ZmhPUFRaeGtuU2NrV1NG?=
 =?utf-8?B?Nzdhd0s0Vlozcmx6N2Q3dFZvQ0c1S1cxUVZKNEo4aVY1b0cwcnF3VTFaK1pn?=
 =?utf-8?B?SmUrM2YxWk5sQ0ZUOWhmNTc5T21wb1U1ZDlFUHFQT3p6cVRQaWlKTzVCZHBP?=
 =?utf-8?B?c1p1VG9GYUZROEJoYkpYWGc2WUtiWlVucDBBaUpsQWkrWVVFeTY1djRrRjEy?=
 =?utf-8?B?Q2lFN3MzUUxPUnQwcUZnNTd1VjFscXhRYUtvZWQ2em93RDFPZ2xnTkNqZTFq?=
 =?utf-8?B?a25sb0FIOEVTRGo1TjJDcWp4a0ZVWENIVy9WSC9iN3l3WkJYWkxibWFHRVhx?=
 =?utf-8?B?KzlBT0x1TmVtWkswTFF2NzNVR294c084MHgwWWkzWHJXa042dmdXU3grUEdB?=
 =?utf-8?B?ZHZCZC81TkhsKzZ4RUVmMThCV3FkOENBRmFIWWFqeWsvREd1VDNVQm5Vdkdy?=
 =?utf-8?B?MkNRQ2hKRnJJaFZBQkE0MU1hVkptVU51SXZvUThiYmJkZTlZV0tzcGViN2E2?=
 =?utf-8?B?RkJBRGMxZkxadDFzbm0zY01wVGxnSlQyNitJMTJZOXVYcmVLMDZrOTZrSS9K?=
 =?utf-8?B?SFlTR2U3U0hyd09uNnNXZnl0TGVHajFVMTFvdEVNTGRBcFZkL0l1dXJVNFYr?=
 =?utf-8?B?WFVVQUF1TEhoR2NkU2NzWGRFTlpQOTdEQ3RKVkJrYnJkakhZdnVvTmhQdXRU?=
 =?utf-8?Q?8gWLUp7vALZdwD5sovZeYDMKi?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22d3e88a-889e-4c23-9879-08de125aba20
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2025 17:36:41.4617
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SMdG1HHWeFp3BAqUKdg865LFih7U6MVtY1agQGEGTgbPBj8uFRK2kk5Or7MJYBlKPcGF11iFOgEMWYq+MwRH/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7949

On 10/23/25 11:37, Sean Christopherson wrote:
> On Wed, Oct 22, 2025, Tom Lendacky wrote:
>> Supported policy bits are dependent on the level of SEV firmware that is
>> currently running. Create an API to return the supported policy bits for
>> a given level of firmware. KVM will AND that value with the KVM supported
> 
> Given "KVM will AND" and the shortlog, I expected a _future_ patch to have the 
>            ^^^^
> KVM changes.
> 
> That's partly a PEBKAC on my end (I mean, it's literally the first diff), but I
> do think it highlights that we should probably separate the KVM change from the
> PSP support. 
> 
> Hmm, actually, the patch ordering is bad.  There shouldn't need to be a separate
> KVM change after this commit, because as things are ordered now, there will be an
> ABI change between patch 1 and this patch.
> 
> So I think what you want is:
> 
>   1. KVM: SEV: Consolidate the SEV policy bits in a single header file
>   2. crypto: ccp - Add an API to return the supported SEV-SNP policy bits
>   3. KVM: SEV: Publish supported SEV-SNP policy bits
>   4. KVM: SEV: Add known supported SEV-SNP policy bits
> 
> where #3 uses sev_get_snp_policy_bits() straightaway.

Ok, let me rearrange things, resend, and see how it looks.

> 
>> policy bits to generate the actual supported policy bits.
>>
>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>> ---
>>  arch/x86/kvm/svm/sev.c       |  3 ++-
>>  drivers/crypto/ccp/sev-dev.c | 37 ++++++++++++++++++++++++++++++++++++
>>  include/linux/psp-sev.h      | 20 +++++++++++++++++++
>>  3 files changed, 59 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index 45e87d756e15..24167178bf05 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -3099,7 +3099,8 @@ void __init sev_hardware_setup(void)
>>  			sev_snp_supported = is_sev_snp_initialized();
>>  
>>  		if (sev_snp_supported) {
>> -			snp_supported_policy_bits = KVM_SNP_POLICY_MASK_VALID;
>> +			snp_supported_policy_bits = sev_get_snp_policy_bits();
>> +			snp_supported_policy_bits &= KVM_SNP_POLICY_MASK_VALID;
> 
> I vote for:
> 
> 			snp_supported_policy_bits = sev_get_snp_policy_bits() &
> 						    KVM_SNP_POLICY_MASK_VALID;
> 
> which makes it visually easier to see the policy bits logic.

Will do.

Thanks,
Tom

> 	
>>  			nr_ciphertext_hiding_asids = init_args.max_snp_asid;
>>  		}


