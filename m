Return-Path: <kvm+bounces-65346-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E15FCA7F6B
	for <lists+kvm@lfdr.de>; Fri, 05 Dec 2025 15:31:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B7BDC3247182
	for <lists+kvm@lfdr.de>; Fri,  5 Dec 2025 14:29:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D093C2EE60B;
	Fri,  5 Dec 2025 14:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="glvGcKrd"
X-Original-To: kvm@vger.kernel.org
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010046.outbound.protection.outlook.com [52.101.193.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7B42248B8;
	Fri,  5 Dec 2025 14:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764944935; cv=fail; b=M5Ikh+1bG96p3MNddds8PBsM9jVQhts03StzaNc8WGZHMDpZ4kaLwAA++7xYzDfPt6i+Y+5RfkW82Zte0c3cfmkvsAuQm9FesBqy6GhAi+0S58SWvFWLgH05jKBIYrNk449sCeRFSCrL2Y7KkHAc/OAjepnjNQ3AVBGSSkZZ2H8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764944935; c=relaxed/simple;
	bh=fnFW8Tro9nF6iUQ+kEQYHGcaiQdEY84SsDkMRFH3LUw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TgwrfqKVfhbeidEYnMkb0uY3PkJi2QyhBhRmTSJ9FrV4eJ6+/eI7Ek8HkETdsy1n5juENczreLNyKBioQvyuCDQK2w6AlGvjVamKL7dwlzNm0ULBhIFLrkvAN/373yToNH8iLbUsPm6Xnf7PcdvbjM0HLIXEuQnDD/E7jwRIVts=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=glvGcKrd; arc=fail smtp.client-ip=52.101.193.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bOH03432G5ReY3uhsv6Gi29IMjV80EZeZ1pEYLPj24pUu/3yT+AoCjXL41xEkTPvtNM9vepm4dYWYAvUkeM6lXgMXsJekIUNVjhjRtYBZh3tFg0ylT7/xFAS6Z+bNby22PSC8DLzcT7z1Fzo+Ltnn8+fKxblq7513Y+u727s2FQ8QL8vjhodHgEw9t2vQMUnI4Pa3FVtGumEfcwstr8339Sdp8Oi6C7FUixi4Qq0cQRHirECyZBw999wB95JOyjCCKc+glzI0QD5sT+KWi+pqkhesYstq8mxbGf62NSi3cAxtduwu84WU/5daZH400z3TaP2RjKKOA21m7w6k1ZbaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MOlSw/abZBXMEWoZ3RMQONJ6+4Xc8mp4Hchhj8WXlv8=;
 b=Eeh5u3sFxoTQH+9OUTprvLoAN7ImSbbQplXZD5uLmFwF2UBoaqExXTDUxq8MU1hAB5cdvBjayT1qH2C3lDyOwBSar4Pauaek3Ywj9HAlBi4DhmWgME52Pp43FcyFEfXFAuuFbg8K5pgIrKboX6iIlTpOPGnhz90pLKJaExl/kiBo4M9+V1zdHK2Wbe2l8V+cbvVHpPrTx83HCu2u5xvDnJc2ECkhg3VtFNKd/mmYMsEj/BNh1xoRD+SkwME3bzZ7FiVf5r6sRWOBhLRfO0Te6euj5lBlmWJ5iO9itzPTRVAXMeSCwhVdudVz7YDOEHiCON/+eInyrIuzF2zQsp3b8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MOlSw/abZBXMEWoZ3RMQONJ6+4Xc8mp4Hchhj8WXlv8=;
 b=glvGcKrdA3dG81p8kFXoYVaEEDOKbjb0pz7tJCaVULeqRglLTAABkmc7Uh5/0H/efXKgGIbCG2LRoeQqr6O/3fe17eURoM2ddGJi7tQ44ZSYe9ShPgEVRT1PapK/tyHT0nq6EGbFu7Gd7464eshf0BkeeKgyEvMBPIRt5l+c8GM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DS7PR12MB6336.namprd12.prod.outlook.com (2603:10b6:8:93::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.11; Fri, 5 Dec 2025 14:28:45 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%3]) with mapi id 15.20.9388.011; Fri, 5 Dec 2025
 14:28:44 +0000
Message-ID: <7b3c264c-03bb-4dc5-b5c6-24fb0bd179cf@amd.com>
Date: Fri, 5 Dec 2025 08:28:41 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] KVM: SEV: Add KVM_SEV_SNP_HV_REPORT_REQ command
To: Thomas Courrege <thomas.courrege@vates.tech>, pbonzini@redhat.com,
 seanjc@google.com, corbet@lwn.net, ashish.kalra@amd.com, john.allen@amd.com,
 herbert@gondor.apana.org.au, nikunj@amd.com
Cc: x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org
References: <20251201151940.172521-1-thomas.courrege@vates.tech>
 <30242a68-25f5-4e92-b776-f3eb6f137c31@amd.com>
 <85baa45b-0fb9-43fb-9f87-9b0036e08f56@vates.tech>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 vFkWitqCJg==
In-Reply-To: <85baa45b-0fb9-43fb-9f87-9b0036e08f56@vates.tech>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0023.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:22c::15) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DS7PR12MB6336:EE_
X-MS-Office365-Filtering-Correlation-Id: 25abb6d8-d0ac-4b77-8236-08de340a97f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Z0YxMUFHNXhnZzF4MExNbHVVd2MreG9xSG9zQmVISllETDhKY0VWRnB3Y29E?=
 =?utf-8?B?eWMxVUQ5R3dyb1BaWENINlVWeVFlTDgvWFJGWDFUNTRTZnM0L25pMmVxdUtM?=
 =?utf-8?B?L25iYWl5TEhHWldrRGNiOGZaTHBKSmIrYkpKMnh3c3BHeU8yVVlJcFZwK25l?=
 =?utf-8?B?Qk80SENTNWgzTW1FY2FCME50dEQ5bisrUUNwVE9zSjlMQ24wbmRlblpIS1hu?=
 =?utf-8?B?bk5VQnRKUmhXWGMvcytaNEFSNEx4TmVNTjQyZlRsVlQzU2ZIcjFOWGxaaDdk?=
 =?utf-8?B?TTZtelo4b3VDcGp2L2RkVzdBRUhyRDFuVFExdEE4dXlBZDQ2S0hiMWd3b3JL?=
 =?utf-8?B?bk55a2ZZWHRsejZ0YWg0bmM3UHlHUEhnZnhkVkMvY0hnYVJqa2laNFBlR0Fn?=
 =?utf-8?B?MDBsWlRadUdaTjJMbDNBQzFLSTk5TnozYzdKV01pbnVacDdHRmJxSGx3VCs1?=
 =?utf-8?B?Z2tYd3pDTEQzNWlEYnd6dnV3T2xzZEp1dmQzbEkzZ3RZRXo2SE9FWjhrZWxL?=
 =?utf-8?B?VUVPcTVqaEhscDBOc1ZrN1NqYmd2NVh5RnJBcUhyM1M4bWVnSnVzREptUzRL?=
 =?utf-8?B?WjY2MGE4V0ZiMUlBczdIdVhvektRajdLQVVSdUJZejJ6SDNOSUM4M2gwdWdV?=
 =?utf-8?B?R3FEOHA4dTh0ZWZVWlo5TGlLbnlaTmozaW5LSExhVjI2RGpjbGlvTktqOVhh?=
 =?utf-8?B?UlF4TzRVZ2tFTjRNWkRpa1VIS09vdE9qek8ybDU4bW9BMTJUNURKRHA1RThj?=
 =?utf-8?B?a3d4Y2VMZDFXMDM5ZitKMjdJUDVKdE4vUmV2UndMOEJPSncrK1R2c1UyVWI4?=
 =?utf-8?B?bkdxTEplUWI3RkpWeEJtWFo3bnVkSHJhN3JsNVJ5SGZLaHRJWUY3SnpRbCty?=
 =?utf-8?B?V2JIM2FuaFBhaXlpYzk3ajF3dVgyMXZ4cEZQR01USC9UQUFaeWpXSEN2VDZq?=
 =?utf-8?B?c0Q5dkRXbUFRSUxNNkVFQVlqQkdQd2d0UitxVDdScmM3N3padCs5a2NHNUt6?=
 =?utf-8?B?Y1ZRODVJT0RVRWk0bU9wNmh1QU5nZGJCZ0I2RTJ3ZWpkR3ZOU1hRMDNCVXN5?=
 =?utf-8?B?MjI0NytzTG92V3p0ckU4NmNMK0JVbDFUaDlKckQ3ZUNkWkNSeFhPa0tJV0pi?=
 =?utf-8?B?QkIvK3FkT3FnR3E3cWJWVm4zdGsvK1dGQjZtSHF4azZkMkJuZDhNSDNNZUlM?=
 =?utf-8?B?QlFFT3JvYVQrQlRGUzZjZUFHeDNWUXFXak9BS0VHV1RXeTN3elBsT2F6MkU0?=
 =?utf-8?B?RWJYbW5adGw5bk9GWWJERk9ZN25DMWpKaVB1QVlLbXpITEJ3cURPcjhTTHRG?=
 =?utf-8?B?VGFPRnN5R24zbjU3RlBRUEIzQzRQaEpncGpFWjF0QWR3M2J3VnN2emtLN0xy?=
 =?utf-8?B?RUtaQ20ydFlHclZEZTlFb2x0UEc4Y1YvdmNKLzgvQisyTEZiQlpIY0NYTEww?=
 =?utf-8?B?YzNTWlBpWkdjcW96dXV5TzdiUDFNWm1ZNHZMdWY5YWdLVEE0S21wN0NRWkh5?=
 =?utf-8?B?T1VpTlNWVnNKWlA1dlk1VGFDK1pwUXBuelF0YWlKb2Zva1AvcjgzMU04akN4?=
 =?utf-8?B?R21IZFk2L3F1WTgzVWFjTGgrK0dIRXQwWnl0M1JnVktOT3ZQVVp5R0tBY3RN?=
 =?utf-8?B?R1RxNC9tNUhMb0cvMGh0dWc5UUFrWjY4cmZDdWpBWGtmQjlHK3hpZEJWNThI?=
 =?utf-8?B?L3NHdko0UjZSZWRvWHVNUU95Tm5iUGxTM0JQd1IrN0hSTUdCbnhXQWFjeEJL?=
 =?utf-8?B?aU9qdzA5dzZheW9uNy9LQ0p3ZDNKNGp6WXh6cDYrZFlqNkVkMDc3eWxVaG9r?=
 =?utf-8?B?VzdmRlk0MWROb0h6WGpPUEFMTUV5T05VdmNldkltQkVtVStDREk5SnhhYTNm?=
 =?utf-8?B?N2VqbnorUWJ0NEwvdzhxUXhnNDZxQ3NLTHJ3a0R2aFk2Nm4xQmFwKytXamhT?=
 =?utf-8?Q?ohCRSkuy54eHOUDGDdo5V1OvwrT/94fC?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y3RPeHRNSElyaUM0RVBZSG94ZUFlUWU1d2k5aDNmZHNxTm5BM1dVMzgxRnFY?=
 =?utf-8?B?bXBIaDVmU0dMWk5WNjlyaVI3b2ZSZnlBV3R3ZU1USDJET09uWVE5bHV1MFBz?=
 =?utf-8?B?dGNvcms3bk00bHAyQ2dEbVJzd1JnNFNyd2JESkxNSXpSZ3RvLzdNRnRnU0xL?=
 =?utf-8?B?cDVGRkJEdHZlYzIyK1QzSFBYdUlGMXNXbnZHK1owTUJralNON28rcnlhY0NB?=
 =?utf-8?B?L1VSMTF6MzF3L1pPVHIzejVtR1pUQWtSMzhpWHJJVWVFSEpLV1UyT2ZwWnBm?=
 =?utf-8?B?UVU2ZWo0UlhWMUZJeEc4b3R0MG9VZHBhSUIzcERRY2xmc0VLMklPbkZwYWRC?=
 =?utf-8?B?c1VyTk5WTG1qYmJqN0thbDdHelVsOXdoRm9Mayt5ZGxQMGllT0xoUElzZUo4?=
 =?utf-8?B?N2NKTThUaWtPenZveVFSRVQwT2VyYXlWUlBjWEJUa242dWlobzNrU3Rob2RB?=
 =?utf-8?B?M3R2VVZEYnlNdEpsREQ2WjhCUnFlb1Ztc0hmRGNuMmhGRlNyMXlUZWsvQ2Mr?=
 =?utf-8?B?LzJSQVgvVUFRWG5JaGVLVnpCblMveGdlUFoxM2wyVStzbGRRTXg4NVNGNXd3?=
 =?utf-8?B?Q0k0U1ZHN2I5Ny84YlFld3ZNckJPdDNsZmcybU5IZWtsakVJa0c3MERmRGRw?=
 =?utf-8?B?ZjcvdUFRTzFsWlFlempKVHRoa0E0TEJSa2g5MWlNeDhYRWhkV3RaWUFWN1Ro?=
 =?utf-8?B?TDJDT1l1aHZQZS9lU0d5YlVLU1IyMHgwNHhydVQ1WVd2aW83Mk5zaWEvR0pq?=
 =?utf-8?B?UndENzRrRWZmU0ZnQ0RnRE0zd1FvSVRGcmRnZlpWaldXTnExYTVvV0xvWDRT?=
 =?utf-8?B?UHlVRnRUYzlNSENRUjhVWlhFcUFwOXkxY2lQS0tqTFNLVmovRy81UWhCbWR1?=
 =?utf-8?B?d2pNL3JsT2RQMXdHSmJiQjR0bXN3YWRacHhRV3RBU0FZUDYvUE9qRDgrS3dO?=
 =?utf-8?B?dHpTRTByK3JoQnp6WVhZTW1ZblZPMzl1aFh0MUo0YTVjOVZpTUVrSkc1SGNL?=
 =?utf-8?B?ZnRkZXNZQ1ArV2dSWGV0M01mcG5EQlN5WHhsY0t3QXlmVEkxY0JUc1B0eGZh?=
 =?utf-8?B?YW1RbFBsbUJvOEdMS243VEVnTzdjNlpPT0ZOK0wramROTjJLMmRSaHp1cElu?=
 =?utf-8?B?OXFjSjZFSytlMnlhYll3ZVVMY3JkMWdRMFRYamZhcEVaRlQ4UG9jL001U1Q5?=
 =?utf-8?B?YzRqbUhWVmRwbUVZWWxZK3JvdHdiM1FVNStVYlVCNlNvSytPU3RlaHhydWNL?=
 =?utf-8?B?UzZUc0JmSzRoeFpYVDJOaU56dUIrdW9NcDVGN2h4QVhQZXNuaW0vdG9nS0or?=
 =?utf-8?B?cU5wOE9FdlFuOXhBWTgwejkxUVUydGZPSGFSUTR1cTM4dURrdlZkNm5FZUkv?=
 =?utf-8?B?SlVKakdCc3FlUjVqcGFpSTRJdUFvdzdCK21PZ1czTE83YUFqaHMxNmNnZEZj?=
 =?utf-8?B?ZWtBOWdVK0lNTnRFY0xSYTMxRE9WT3JEMHdiK1JuUHI0TXlkSjdFVHAySFlp?=
 =?utf-8?B?TnpJSVl6S1NHTHQ4MEpaSXlhUzRLMHgrTWF3My9RNmNpQlh5ZSsxYzhiVno1?=
 =?utf-8?B?NVRubUhVN0dXeXpHR2xaQkl1ZTNyL1o3TFdyWHlpSzFVWTFJWG81VFlYVmF5?=
 =?utf-8?B?UUhQWC9YZjhPdVF6WlVUSmVpazRQT3hLaWxWYVBtZjVza290UFZRd0ROejBN?=
 =?utf-8?B?aVVqZDM0RnpIVEp0N1AxTVF6QVJtN0hDN3QzOG5FdjlveUgySmxMaGk5R3F5?=
 =?utf-8?B?L091ejFJL2JqOElOcTZHR1MwZ2k1SGhQQjFVZHFMMFZudUFwaS94MU9Qd3lN?=
 =?utf-8?B?eFlLZUJmdFNZQm5zd3A4RlVjMEtTMmRlZlhCSmg4eDVNa2kzaWgzem9LSEZ0?=
 =?utf-8?B?MytKcVQ2YU5va01rTzRoY3JCMXoyelNPTkdVRVgxdzlka2ozbU5XSVZYZGJC?=
 =?utf-8?B?SW5qT0ZwVGl1eVoxUDNMU3NmNHRPaDJzK1BWcC9QNkxCdERrSUR2WnFXc0ND?=
 =?utf-8?B?ZDdnOXdvdFZlQWhVTEZkNlVubTVkKzEwaXhyMjYwTHpZbTd4d0dUdW9KWEMy?=
 =?utf-8?B?dWhia1BxdC93L0NOTFVQRnhyQkZHaTBESFh0emM2aDJKSHp2dHVSUG5SUFY4?=
 =?utf-8?Q?Xe5lEZ/rrC2Cs4zgMcsHaLGav?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25abb6d8-d0ac-4b77-8236-08de340a97f9
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2025 14:28:44.5139
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xq9FTAweSKVVCptEBkfdYEFN3CxMRr3XUAS319OQxhbM40xYbnT/P30uXCQGk7pr2K8FEw0BlqNG8jVFbpCm6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6336

On 12/4/25 07:21, Thomas Courrege wrote:
> On 12/2/25 8:29 PM, Tom Lendacky wrote:
> 
>>> +
>>> +e_free_rsp:
>>> +	/* contains sensitive data */
>>> +	memzero_explicit(report_rsp, PAGE_SIZE);
>> Does it? What is sensitive that needs to be cleared?
> 
> Combine with others reports, it could allow to do an inventory of the guests,
> which ones share the same author, measurement, policy...
> It is not needed, but generating a report is not a common operation so
> performance is not an issue here. What do you think is the best to do ?

Can't userspace do that just by generating/requesting reports? If there
are no keys, IVs, secrets, etc. in the memory, I don't see what the
memzero_explicit() is accomplishing. Maybe I'm missing something here and
others may have different advice.

Thanks,
Tom

> 
> Regards,
> Thomas


