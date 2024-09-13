Return-Path: <kvm+bounces-26832-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 09F3B9785B7
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 18:27:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7F7ED1F25E4F
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 16:27:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5BC678C90;
	Fri, 13 Sep 2024 16:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="QzmC1XsT"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2051.outbound.protection.outlook.com [40.107.223.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0C514A85;
	Fri, 13 Sep 2024 16:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726244825; cv=fail; b=ZjJafoJE1NsawvGkA5hLSTVgQcYYPEhKgr6jKU11PSNgGuHsxkV72QfDafW5OkdgAFriucpa6Ws3xZqYkPLfzLei2J0YQ2Csb63OBfFZIRF98sSiXIHYDJ/j43N6HLQmIVBNhJIue9AwuSjHUl4cXqRy2CRADHjJiiPzh3V2Jbg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726244825; c=relaxed/simple;
	bh=8hrtmCVz0Cecrxfeq7/6TlKZF26PRHlsIQhwZICVOjQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=u+Ie697c+lXCQ8inFhFWIgiXRBE4u9zRL/WUIfWOXoZSHw4FUxo9MaZrok0SNAjhCBKj/P91TpXHTjZsiORnplWQt1D6inDE1J0akfSftV49pratvVAk5Yz9InKlsfGIt4EbHuNflzJs44JCfkDsMOQnQzbUirwCYLjU7/AM40Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=QzmC1XsT; arc=fail smtp.client-ip=40.107.223.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Yk+IwPTbTY8ttlJtCeXqFgiWBH0tMan8Dex8uc4fT/gqa2M7IJdDJzdov+AOfcd2M8XPIEIkaRzsNQB/vi9wCXTA6eLhpLYio49zle1A5kbSrBpJd/98S5zx/RHVax2LatTS5NNYULFLqJJ+i5sxZrWlim/ajHSWQthKU7PHCpH40vFyh1uB5BiT3KhqtpaQr3eJP6MEz7B2l9mbG+Y+OWDN//THli9p3duEy6yR3DO4TLcEgYkjjFwgoyTgZS+5qKEjVWLamOYg7KmZg3SBQP6xYHT4ERfGJER5J8Pj/aaxOGSFXU0/srF3crqpNgCTmwgJJW366iClKVMnB9tJAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UDnyVSNnzQtgmJhNRykZZWTOkOCVi08bQ/0Rm6i+hv4=;
 b=qYby9U7i2sIFvEwZHw3qKcW/8Y9xCIaYJMXqWMak4vI/0nqALtSlWHQyZFfNbV9qKqX3xCB8V/imjnk7Q9gzKDIYBkyYef1P3bd+fHJ3Zw3qmKw16ZHDIUSi+Rx+XOKyyRUPthUunLty8P7zv8CT/M3y1L4DA9Z7WzAyzx86XvzLc2k/Ssje7iO/1ee5T3xpLVp5INcScsOrP7GK+iM865qgMfT4VaT9QF1PtqCSrmU7SIWk4Q+9K9bShQl1MULvJx0ALUr3KdzwPBcKfcs14ywErO2/rDfyLofrXa+mWmYQ/TmYdV5Yn1C4h2bfGweaimEL+DylbTtg2ae5nHLvlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UDnyVSNnzQtgmJhNRykZZWTOkOCVi08bQ/0Rm6i+hv4=;
 b=QzmC1XsTSBDICw2BXuXF8mR3e5wvdrt5aoJL75LINawD+PzS6wAuViGt90kSTes6PshkUN9UrmWHkyGWGlbnVErsYUNsoMCn/N/isIyB4kVLbhoZAgZ6XzDQ3pnvS+oBw2oVzvdQYf93DkSJB/BiyXZM+YMv8HhC1/tja8oo0hk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by MN0PR12MB5884.namprd12.prod.outlook.com (2603:10b6:208:37c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.17; Fri, 13 Sep
 2024 16:26:59 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.7962.018; Fri, 13 Sep 2024
 16:26:59 +0000
Message-ID: <320d1d25-ae9b-a474-086d-95b43cccfe32@amd.com>
Date: Fri, 13 Sep 2024 11:27:02 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v11 12/20] x86/sev: Relocate SNP guest messaging routines
 to common code
Content-Language: en-US
To: Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20240731150811.156771-1-nikunj@amd.com>
 <20240731150811.156771-13-nikunj@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20240731150811.156771-13-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0106.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c5::11) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|MN0PR12MB5884:EE_
X-MS-Office365-Filtering-Correlation-Id: bedd188d-3c03-4b9a-2db6-08dcd410e411
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WmljVEZkV2NqaTI1V0NFSVBBTElqUUNONkJMMG5KWnAzd2RBL2VtYjJKeWd3?=
 =?utf-8?B?TEtJOC9yZ0VVd1FacnNZMk1QNG1JM0t3b2Q2OUVraUI4d3hRUjFRRkxjN2I0?=
 =?utf-8?B?ZTRRM1E2MVRBb1A2UEpnQ0NnZXg4M29YcFZpM0RKeWNkY1JNK3dWWkV0WFkv?=
 =?utf-8?B?YW5YazJQZldBUXNzTWFwd2NoenZwejYrRVp4Y2JWM1ZMY25pSnhHcXpaeXlz?=
 =?utf-8?B?alFWKzVzY3crMi8ySlFOL2lSYWZOZzRzd2FnbXdLLzQzbVhvS3loK20ydzlp?=
 =?utf-8?B?Wk1wWFJXOHdPVllwb2d4OXVudXYrRmg2WmhORzB4Qjc1dmVCOVY1NjdNZ2tM?=
 =?utf-8?B?dUMvSis0U3FEdE1KbWlLdVlUQ2d2SmtnNEMwSEhHeEJUaUFLQk80YXhDSGds?=
 =?utf-8?B?SWVvaGtnVmVzZ2k2SHA2S2ZCTS9ZUmswWDQzcllMTkZUOHFYUDg0SW1JUkQx?=
 =?utf-8?B?NDhZcUFKemduWGwvMUNEOHkxblM2NXIrRUVhczNLMVdCZXlPNmwwMVFMT2xt?=
 =?utf-8?B?dUcyRTJ0L1M2djN1RWdxcjduaDZoNUdTZmd4K1hIM3hsTi95MnZBS1kxZUxu?=
 =?utf-8?B?Z09tc0twUTAwbjE1TS84Rk1kcjk4aStZTk8xMmtLam9pYWkvOVkvMXZpUkRO?=
 =?utf-8?B?SnBWVFVEMjBQOHJXQnJPQnBkTnFBbXJROUFwQ2lFRi9uOVIvSWRvNkxQNVRz?=
 =?utf-8?B?Vjl3MGdLV20wckdaMG0zOWdKbHVJc2VBS0RUc0JIa0YrN01taFhZNXZSTDhz?=
 =?utf-8?B?anl3RUd5dXZzdmRLTFVrWHpmV1hQWXVqUk1GYVJBYVBNNWEwM2JhR2hpYWk2?=
 =?utf-8?B?UU9pRHNRSGt0QlN5NnRWRUQ1T1RMZEdjMHUzeFJIR0NOWFplY2ZGS3VSeDZR?=
 =?utf-8?B?dlZUemhXS0xiTm1IbHZvN3pGbjBEck04TjJRcUNBcElnVDhpUnd6VkcxeTNs?=
 =?utf-8?B?QlViSXRQVFJXdWdXTDJmOXJaQjdGY1ZrOEZoNFhzc1M3dVgxVzNaV1E3MHFE?=
 =?utf-8?B?Y0RLbDB3bHN3ZkU4UGVSYlF3SWF3NnlsdU5kK0gwVVZIVVlUUG9uSS9jR1c4?=
 =?utf-8?B?SERGU0NzRVppL2JERkRIQ1RTZW13TUZrMjF1Rk5FUzl5RnM0OGkwR3dlTDRq?=
 =?utf-8?B?ZHd2SXdKQ1QwcDZNalUvOE5zcWtvbjdQeVhzc3QwTGxIWlY3Wk5EQ05MeDRS?=
 =?utf-8?B?SlBwNlAwaDlvdGlLbDJiRXFOVkZXNWE3enFtWmIwUWsrcndmQmQ3bXA0Wjhr?=
 =?utf-8?B?ZDk0VFhYaEpMbjZkd2xkVXZNM3BHOC81THhwS3d4UU9nOG5Cc0U2dzJ5QlJt?=
 =?utf-8?B?S0crR0VJRExyR1REVkRhVmJBUGd1WnhuRHZDblV6czh3R1lLMDN3TnE3YmV2?=
 =?utf-8?B?ZTR2VWJ6SzRKM1AwbXEyakI3eVdwalRya2l4NUdoa3AzaXZCSk9hYmtpc1BZ?=
 =?utf-8?B?S3lMd0t1VCs1amh4c1p2S3p0UEZqRWFxaEdsT3VDZUphbTRQc3kzQU52amV3?=
 =?utf-8?B?NUhVNng3Zm5VT2o0RGpGSXJTS24wRWNEeFhxU3FiZGc1MmNVdFU5UjRpVmpo?=
 =?utf-8?B?UWhjWkwvdmJBazBXSnVwZDlzSlNQWVVxWTRwSU9Wdm5aUG1vUXFLYnRndWQw?=
 =?utf-8?B?UFd4ZGFxb3BkOXZjczdXSU5RQ3Z4Snl3enVtSTdobVYzWk5vN0xSdTdUWWJ3?=
 =?utf-8?B?YWVmTWVncWZWMXlhMEROVUVtRjNTbjdZQkd1ak9OZ1o3aTNib29nTnJ3c0to?=
 =?utf-8?B?YzVZbDdzZVZDdVArRHp2U2NyZHoxYmczYmoxMlg5b2tkWlhxWVFzcmtsT3Zq?=
 =?utf-8?B?Uyt4VEFDc01aRGZMc015QT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cVJISzlGYS9TTEVGelFKTktDb09IV1JHWStsd3JXbHd3WXlCNXArbEZhYmhQ?=
 =?utf-8?B?cW9IeTJ2L3R3TWR4SzNyV0NmeSsvaXdrN0NDNHpOdDhoQlB4WWRrYkpZMlJW?=
 =?utf-8?B?aTlPem95RERqVTRja1F6ODJ6UFZKd0V6emQxbkxYbUlTUlpqa1NoQlVvUEtJ?=
 =?utf-8?B?WFpEMlFvcUhrTHhCR2hRdWV5WUZKWGsrenBEUm1waFRCa2tzOUVVSWVndG80?=
 =?utf-8?B?Zk82YzRrNTlMNER6ZGdueGd1NmF4MG14SDhCRXU0QnJGeEhSUnVUdFlpNDlP?=
 =?utf-8?B?ajVGdDRCZVdHMVdBQlZLZEFQTEZSOXRsbkg2NFJOZ0pJSlc3czBib0JNRnVp?=
 =?utf-8?B?L1c2UUVOZ1pFRWtReTB0S2N5RmM3VmdPVTM1ZFovdk82N0JYb2lIRFBWTnBB?=
 =?utf-8?B?ZjJ1Qm84OFVqd005ek5ycXBVR044Y2g1ME44THEyTThlZFlyTHVHdnhaL2dF?=
 =?utf-8?B?K2F3SzhKczNDNlk4KzdjTy9WQWEwMWRRUHc5VkFFeHF2VmI4MkJET0d2eGpx?=
 =?utf-8?B?UExIQXBkTGNjMWxVWExrYjBMdE5ubW1rZXlqd2dQY3AvRGZkbThVS0Q5Rnpt?=
 =?utf-8?B?b05LMkdNWFFYYjNHUWIzT21JZUVHYnliQ3F4bytaaUtxaktRejRaL1pRZjZa?=
 =?utf-8?B?MVVFdWlxUnFVbGxtcUc0TlJtUUtoNU51NFBhODNJZS9HME9lWWx4YjZUcFRD?=
 =?utf-8?B?cVl3dEVzbEd1ZWs0ZC9weTV4dE5vak5nV1NVNm45RnhobDcyb3k1U0txY1ZQ?=
 =?utf-8?B?czJWVnJsbWZicmpGdWFweFRGKzVIUm5JT25RaFY2OVdZQXNZL2t0cWRzdjZ3?=
 =?utf-8?B?czJsOVpxdkUvTXd3eU83TWdqMThuS1UyOUN6dlFlQ1NuNG5wYUJDSXdMSmdP?=
 =?utf-8?B?Sjh4bHlWZkt4bmJiWkRhVGRFUUFJQTlNYUhDems3MXp4WmVLemtHaG5DMXdP?=
 =?utf-8?B?c21UeU1RNFI3blQ5alAyMDFqQ1FqNDczbG1KTUdEK3BZWHlvekk0ZWlqaTVk?=
 =?utf-8?B?ZVVpeFpMaFlnWE1TMWF0UnppRVBVTSsycmE5Q3ZRVGdzdkZnbVVRRU9mMURz?=
 =?utf-8?B?K1diblJja3dDSHdjOW52cmdleTlnUlc2K1BZMGYzNWhwVmZTUGJNTDJzd1Fo?=
 =?utf-8?B?MklJZjFrZ09IWjA4ZFBaQllkNmwzUHBRSXhsRVhEbEdWZWYzZ2V3VnhnQzRo?=
 =?utf-8?B?NnV4Z0hoYUd1QkdOQlZUN0R2ODFlL0NFb2Rxem1UeGIzZ1dTbmo0OCtGdU5E?=
 =?utf-8?B?aWJEazNER3huRTF5eXNhSXFFT2Z0dnNsQ2MrdlF1bkNDVWM5bDNJM2VhZ1R5?=
 =?utf-8?B?bEs2WVBKNDEyc1czT3RFeDYwdGlLZzZzOWYvTmhNNlFCNTJNNnVWR2liZXZr?=
 =?utf-8?B?UEc4MWFnWEE0SmM4YVczRmY4dHpUTFNrM3FzSkhCSWdVRFFzTXNEbnFleTda?=
 =?utf-8?B?SUYrTVVzKzBxNXRuS1laY2ViajRlazBXK1JVWVk0WXQ3OHlvVExPMkV6MnBZ?=
 =?utf-8?B?b0Y4elNLZVhBUTNvb3JjUFB0RDFTb2diMkthQU1TT2dCN2NhT1hyeGNsWC9B?=
 =?utf-8?B?RGh3azk1S1hzREthTEw4UEV2TWgwNG5id2RrS2pSR1M1bDdqYkhkWXNwc1BX?=
 =?utf-8?B?cUNPbHM4cC9tVStYK1FrbFlOaXNlTVpFSFdBMHZZa1dUWmE5NUk0eXVYTGcw?=
 =?utf-8?B?OFA3WUxMWk9NNWN5WWpZSHZZUzNSdm1RZzBad3dnbm5WREdleTFmYkx5cmRq?=
 =?utf-8?B?NC9la0d6eFA3NEYydGRMMWF6aWtOeG1SN1lLNnVQVS9xWUJQSnJZaWdQNUpX?=
 =?utf-8?B?MFZLNlVWeGZSejJUcnZSaFJMNnFkc09rbUpSbTQvNW4rSGhNRFRabCtTOWtl?=
 =?utf-8?B?aUg3L0poK2s1d215ZGcra1QzL0NWeHJmRXBCeXFFT21IaGQwTHNxUGREY0ht?=
 =?utf-8?B?OXprWjlBQkJLd3IvY2RnYVhKRC9lTkthZUJ1cXlWU2Q4VldPY0N4ZjE4VkRU?=
 =?utf-8?B?dmMrM2tFSjdUVWNPKzNDN1F0OXZlemZIKzJFQmxCVjEzTGVqeHZraWRLd2kz?=
 =?utf-8?B?b1ZaYkUwM2tGSVZyUDhwcjV4ZjdpSnR2TCtmRVlkN2podkhrUkJFa3loZW41?=
 =?utf-8?Q?GWAN7+gd9a9AZ8btQhBCC9WI8?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bedd188d-3c03-4b9a-2db6-08dcd410e411
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 16:26:59.1808
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rUT7sQ5lmmO4YRJx6dk+Fxc9soaeEfQFyNlQsmJlO8/SPI0VUWf2phzlKZSItB7n7g9D2oWXoHFn9UikoEUNew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5884

On 7/31/24 10:08, Nikunj A Dadhania wrote:
> At present, the SEV guest driver exclusively handles SNP guest messaging.
> All routines for sending guest messages are embedded within the guest
> driver. To support Secure TSC, SEV-SNP guests must communicate with the AMD
> Security Processor during early boot. However, these guest messaging
> functions are not accessible during early boot since they are currently
> part of the guest driver.
> 
> Hence, relocate the core SNP guest messaging functions to SEV common code
> and provide an API for sending SNP guest messages.
> 
> No functional change, but just an export symbol.

That means we can drop the export symbol on snp_issue_guest_request() and
make it static, right?

> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/include/asm/sev.h              |   8 +
>  arch/x86/coco/sev/core.c                | 284 +++++++++++++++++++++++
>  drivers/virt/coco/sev-guest/sev-guest.c | 286 ------------------------
>  arch/x86/Kconfig                        |   1 +
>  drivers/virt/coco/sev-guest/Kconfig     |   1 -
>  5 files changed, 293 insertions(+), 287 deletions(-)

