Return-Path: <kvm+bounces-26841-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D72D978697
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 19:23:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 81EF8B21457
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 17:23:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AC0084D13;
	Fri, 13 Sep 2024 17:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Pxx/orLm"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2053.outbound.protection.outlook.com [40.107.93.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F092181AD7;
	Fri, 13 Sep 2024 17:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726248159; cv=fail; b=WAzQuglV26W1XWM/EyHGFyCViGScvILWUjd5UsocXsuAitBUMoLz9hgXb9BTssyqKoIU2LwXPu8QjLdiqX2Po1DiHf00Izr8WIq2EITEiFZpPQrym49LdbR64ruogwfmAQMForqEHmuS+fB0tKahqjBGR6Yh6DpIVvzvlwiXmLs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726248159; c=relaxed/simple;
	bh=ohKT095S+SbpiVTa+/BCxqva81fRi88jBpiE9xPMGxk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZDnCD/dr1vvdVVKzPMU5wMShCBZNvFBt3azeXRXOF49cv7VyZddOJsknkQEVUQJvTLisbwb+rR7FXUo9XRJ5M6lCYqtfpdqiEk8jHy082qWbgzow0z0kLhK8iMqEMlLllD/wAffsrhLgW2AU8KwqwArJjYbjwVv8zhI2lUp1st8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Pxx/orLm; arc=fail smtp.client-ip=40.107.93.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qMM73XgG8nofgyr78j+tRmhWFASaC5UvSgME18qubnf/qCEbYglQtWUNc6YWupapvfzHV2EaGuBqALLefSC6jYCK1/ujocjgpJxujUnmyMpBOtMfodPwCJnv+95IJEPUv7xxaPosD0Fs8cw06+E8JF88Ze3nSuGNSePsg2EMECwFKHwpZkQdGgJF8mNk2l+6ItJD2WugIJQhlE/9ko4asBMYIkDf75XI5j52tN2XaeZJACQapnpFDyfxAmHQepktzhQpwr2URsO/Q74h5D8oiIVeiAU7ts5Btk4AmxdQXiUOhy9trkofYhieIHo6iwRd/N8KvCn0BFJ8V3NsDwd4Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iHB2oTE3JWv21fdRXFqod2B4b1auiYBt4/XeUV64oZU=;
 b=JnFUod5hwMd5/EPdsMkwZdZms/+76uVBl305BAZyupgn3bjDVyoHsmT8nDS7v0hKcv7UrhqJKBli/BmdkbjRTDx3h56UztTmElmgYAqQi/Ql8KedkuyNZ3L/JiHQHaM/gy9IQasOqWN/kjAVdpCvOuFUmcnAWYd3M/YFAX9tHSs5xGm0jVMAHxj3Vy6QLFlgkDcj5YxrxoAnG48iLehDvOxkoBGdOEJUJytuK2aXo6//E2p1rBDxuxvuS1zqeIKP7QUbNcG05YGT209bj8+XiPwZLP7X1AOiBGvpP6/pdsT0zpFhxKOJuGbrxXg5qK/BtnE8xgRNMgCNJGYPfQGN+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iHB2oTE3JWv21fdRXFqod2B4b1auiYBt4/XeUV64oZU=;
 b=Pxx/orLmjcn4U08Ph5KLd8/DMKGt2kvr0w+rYIREUcLuKpESkGb0rg4WrCS58sD1IZFDH/edHPNQI2wRPg/zJXYJLJDaHRn0TLX9r86FYTzCJyF8z0ZtO9xSiCSA97zWYNxSQmW88GNkTrGGtxK8+/w45rcF1VmzNOXjl8BY2q8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by PH8PR12MB7207.namprd12.prod.outlook.com (2603:10b6:510:225::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.18; Fri, 13 Sep
 2024 17:22:35 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.7962.018; Fri, 13 Sep 2024
 17:22:35 +0000
Message-ID: <16af70c2-ddc8-409f-958a-cc3dea31603e@amd.com>
Date: Fri, 13 Sep 2024 12:22:38 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v11 02/20] virt: sev-guest: Rename local guest message
 variables
Content-Language: en-US
To: Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20240731150811.156771-1-nikunj@amd.com>
 <20240731150811.156771-3-nikunj@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20240731150811.156771-3-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0160.namprd13.prod.outlook.com
 (2603:10b6:806:28::15) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|PH8PR12MB7207:EE_
X-MS-Office365-Filtering-Correlation-Id: 24ae9af7-2b3f-4087-c8d5-08dcd418a881
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NEJqL3VzTmtmaTQ5dS9UNWZVOUxOOUttOGVOeDk4N3VIVHJMSlo3cGU4U3h5?=
 =?utf-8?B?aEZiQm1xOS9KWmEralA3anczU3NFRTNZNkhtck8wanREQTlQY3IxNWo2Slgz?=
 =?utf-8?B?MlRHTmJucDNSWUtWaUNSQVkzZm5ZenZhYkJRTkpaME9wOVR0Rmwxa1VraFdl?=
 =?utf-8?B?VWRiYzVoLzZhY3JISEExemhjTkpBd1k0cXY2R3p3ZGJGc2YvM1l3WEpoS1JJ?=
 =?utf-8?B?TTlLTEdVZUJUZzBta25RcDU2STFJbklXRGZ3VlJEamZmTEJOcDRsWmxvZE5B?=
 =?utf-8?B?VWtmOTFRWC9teDE0VlhFZy84L0tlVjVNallnTy9UczBtRGhUQXVXMW9JNDdh?=
 =?utf-8?B?RFY4amZ4WFhPZWdHRWp2cVlhVlpCc0wwdXZjTjcwdEtwcGppdnpNazJwOFBQ?=
 =?utf-8?B?QkJKQmZpTFM3T1lnKzhEeEhlNmlVbTFnaG1KLytRYlo3Sm50SHNKTC9YNGdu?=
 =?utf-8?B?TG8zdGFDeEgrbFZ0ZXZkZmVoUUZwZVovdy9UdWhIdCtCRGw1b293RU03VzlX?=
 =?utf-8?B?UVUzRWxvS1RIWHdHV3JIbEZ6akMxYVhHcUVUZDRWcTh4UTRMeGlCOXRQbWdh?=
 =?utf-8?B?czRHWUFwTDVMSnoycjIwa2FnTUVGVkdyZ0FFQWd2RG5qRVpLMDQ1WlJLK3dx?=
 =?utf-8?B?VUp4dmNpWUozV1lCK0RROUJOcUJEbVY1ZmU3RktobkYwaFNVaTRKS1VhOU8r?=
 =?utf-8?B?blBOcUdkWkd6M01SSFU1bFI1Uks0WWpTTTZnZEl0eFE3VlNnTGFBWWRIWlNB?=
 =?utf-8?B?SWlXZzlBUVpWWHBHVXBjZFJRcUpjV05ZUTJhRTd1bkRHa1pld2l4TXZKV3ZN?=
 =?utf-8?B?RFV3bW1acTEzVVlYbllYSmg0SHFzdXk4RnNUUXBtbVkwUEJKdFF4alR1K3RB?=
 =?utf-8?B?RWdZSUZLK3ZKZ3dxZXg2d3FYSDRDUXFFY1luYjMzY0ltemQ1aTRUaEYvMW9O?=
 =?utf-8?B?UHA2ZFFFaHNQc1g3K201Qm5Kb0x1djc2c2FDOXZ6SFIzS24yRVUyVXVEeWp0?=
 =?utf-8?B?Z1lNNTNraHNWNDYrY2g0SWl0Y1UzVUhPbUd5UEl4aVhPaFcxaVVGclcyV2J4?=
 =?utf-8?B?WjF1czFzYnpzbzlIbGZWaFNMWXdJWWNPSm5MSHFLeEMvM0s2ek9zMGsvR003?=
 =?utf-8?B?U1E4cDBZY3ZjamZUVWNFSnVtN0l5dVZsMzB6TUZMOXk4RzJBeVlLWEFwcElP?=
 =?utf-8?B?NWR2UjBnVHI1dVIwNm9XK1BqdWFGUkVyVkhTc0trd05nLzJaclYyRUxNUHdJ?=
 =?utf-8?B?Y0FQc2x4S0RMS0hnM01CY2Y3cDhMVG1yQlBQMUdmd0RXOU12cjJUblZ2VkRw?=
 =?utf-8?B?WWNnYm9ycEZvRElnV2x0Y1BaYWRFdXVsSGNBUlF3TEZJM3ZFTHF3bUpZZU1B?=
 =?utf-8?B?ZlNlU0NHcHQxZlIraThOWGFqMk1yTW1ld2NoVDVTcysrNHFVNXlMTzEwSS8z?=
 =?utf-8?B?enc2NDNWS1Q3UXVRbmw1dWNFWExYR29sUXhsN2xvZUgzMVRKYjA3cU9xcGpk?=
 =?utf-8?B?VGVlNi8zUFE2SVpES0lEb3FEcndJQ3ZjcW9RKzJVY3RkcDdVT3g5RHBkWkpT?=
 =?utf-8?B?RDVzU0UybkVrMkZJU1NRTEZZMmFQbmJKUmdlK25HMHVwZ3UrWitkWHY4anRT?=
 =?utf-8?B?MWpyTE40N0YvaUEzK3VYQjkvTm96UXdxdGJERmJrSHdkZmlWRDJ4MmQzeWt3?=
 =?utf-8?B?aGU2bGozRkYwM3p5cTNOVkhxbERrOFJvTlNnTVBHMTRqalFadmFjMGduT1Nz?=
 =?utf-8?B?b3BRWC9zVDlNbktBamNhZWxVS0J5R1V0TFRJc2p2emFNTkRrbHgxYlN0MGJq?=
 =?utf-8?B?ZHp6OUVKOWhtWTFISVZQQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MTJ4VzRya2hFTHZLSXY2NEhSdkN5MWI2NWhWUHFMTU5Dblhob1Z5MWFYaU9V?=
 =?utf-8?B?aXNNS3FVcTQxZytueVo5QWprdE5EZ082N3k4Q1JnUGRVUHVUa1NnWFAxQnV3?=
 =?utf-8?B?NWJvU3RLUHhiYVZ4R2xHalN2T1czN2pFYTk2OUZwRmV6a000RlZSYW1STjBm?=
 =?utf-8?B?RWd1d1hWd29HQzRkcStDNXREOHRvN1lHaUwxSUFnZlY4TkpJalZ3bjdnZVJt?=
 =?utf-8?B?VDk0NFBIWjVVZzd4NWNubngvUFVhOFNlMmNRS2RBWHFYd1dWeUYrcmxDSkQz?=
 =?utf-8?B?eTRLWWQ5RS8xR0VIUjRiaXVRSXJIVm44aDU4MGFSYWJHWlRsOC9lb2NiMzJx?=
 =?utf-8?B?KzRHdGZSV1FxOU11bnJTWUFMRHpJaVhObno4WXZJTGxJMmowQWtwWXpmSzVw?=
 =?utf-8?B?aURCamdscXNjSWo4WUlKYkpmZ3V1U3BMeUhTMFhrdHpDZUlEeDBrK1ZMOThW?=
 =?utf-8?B?ZVd4U2Y1RjBRRjNoam1xb0grK3I1WlZtK1hGVU1PT0VOc2h6dExvOWV1U3hH?=
 =?utf-8?B?WkVkeHkwcHdlVDNIbkxqQUlnL3NSSURxcDFKLzV3ZXMveGRTMVFzS3RCS0tW?=
 =?utf-8?B?RVJXc1B6SDMzcTE5SFJPZTVKNVJ0azEvak00bGUvNnNHV05udktRL1g4bUIv?=
 =?utf-8?B?Sjkrb096L2dCdFBFM1hrUlpZL2lEUTR4M2ZNbUp3TUFjY3pFVTVMNi8xUHU3?=
 =?utf-8?B?WjB3M3hwMW1odnJIWmZJQlV5UWdCTDJFbHdVMlNleXE4NjdjcjAvSEY1WWVX?=
 =?utf-8?B?WkwxR3BXdlp0T2prenlxaXRuVmJNM2dzK0IxK1VCenJRSEp4RE5NNnVxa1F2?=
 =?utf-8?B?a0dOcW1YekVzUTRaY241QUVOQU13SWZQMWY2aEFZSVpvZUl1WDFXdXhTSnAz?=
 =?utf-8?B?dFl1ZE9zelc2Z25qZTZoNmI4SWVBZXBMNHA0eGtLVHdGbEtDbWdTQnZnUVpJ?=
 =?utf-8?B?djhjM01mdVBIbllaOUtKUzVsamV4RmMyZjRlYnB2ZkthVk1CRDBZNTFtV0Nv?=
 =?utf-8?B?ZjNzU043RExueC9nMVRHeTN5bXZsTldSek5nMktOTzk3bjQ3VHVKMUhjSGlW?=
 =?utf-8?B?NTdFYmRDWlpvZ1EwcVFZektLS1FCS0w3dW1NR2VnUGt6UmdWMDBZVkdoc1ZE?=
 =?utf-8?B?bHVzUkdYYjhPWkpKdzhpeHZPbUtqNXRFRkl2SDY3Z2labzQ4N1NUYmZqTDVN?=
 =?utf-8?B?Q0cvQk5WSHZQUGk1VVpTMFVvSWhxc3pQSmt2WDg4dDRRN1lzWFNtbG50THQy?=
 =?utf-8?B?OENla3M5OHNlWkpyZ1psYlJkOFlSTDVsM1dJNUppUmExc1Z6SWo1Qkg0Nmdy?=
 =?utf-8?B?dTBqbGNDV0dyRndIMmZReW5sSmNzd0RFdkdwY1NEV1hHRnNpVnRYTWF0enFi?=
 =?utf-8?B?Qm4wb2JkbVJ4aG9NUDBCem94L08xQklKRDVjcVFBWDZEN09lOEpkd1EvWVhU?=
 =?utf-8?B?RzNtd1Zob3B6ZzVNZmxNVlJJWnAwMWI5Um1hc08xZWhiczJwRklnM3k0MGMw?=
 =?utf-8?B?Q2w4NzBlcG1rcWl4VVc3SUtyK3luaWtnWXFhcWxaMWNnUEY1YzBHdlltajky?=
 =?utf-8?B?aVBnTmlxaE1jdC9xdlBoS1FWRDhFaWFqTVFoK3Evdll4THVYdktMeUZIUlhp?=
 =?utf-8?B?NmhhT3JPenRsUjcxVmlldzNFa3l6cXg4emloMkRYa2UwNnNhZGRjK2duMk9J?=
 =?utf-8?B?ZHNTenZ6dkNaTm5JcUZOK3EwRmwySWtWZVdJMTNpVk9Ma3M3QTl0bGxQSjJD?=
 =?utf-8?B?TlpQdDI0c3ZZOHdwY0NPOEV5ekM4OWdXa3FMa3FhbXpkZHpQclNOejdpR0I5?=
 =?utf-8?B?RVpFTFdaRlNQem1sbm5OZDdYRngzc290WFc4R3Jyb0FYZVVTbkpGR2tQRWN6?=
 =?utf-8?B?aUlNOW5HRzNzRGx4bytzcW1SU2xzUWorVWEzcXRrMUZsVGlLUW5DckNheUNn?=
 =?utf-8?B?MEYxY1MrNjEyZk5qeHAwOGU5TG45aVpFdWh2WTYvZWc5YVIzc2dRU3JsUGJR?=
 =?utf-8?B?WjZsaDN6VS9remE0MmlCK3dGa0toVWMwOTBZTjBIR2ppNi83YmJyT3BwM214?=
 =?utf-8?B?SXBJZXZObXBhRCtka1ZENzA2Zi9TV21IcHJRWnk4NlVtcHA5cU5jMnlyVGp1?=
 =?utf-8?Q?1m8nGPyrlZrwaNf95TmTXBacc?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24ae9af7-2b3f-4087-c8d5-08dcd418a881
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 17:22:35.2373
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0GVLWTUkwI/T4amHgTI+hEKYgR/53bUD2J8lvdaotgLZuuiCzkgt+tIXq84Ofj9tfbGRGm+Gsn7Ox4kZOP62Ag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7207

On 7/31/24 10:07, Nikunj A Dadhania wrote:
> Rename local guest message variables for more clarity
> 
> No functional change.
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  drivers/virt/coco/sev-guest/sev-guest.c | 117 ++++++++++++------------
>  1 file changed, 59 insertions(+), 58 deletions(-)
> 

