Return-Path: <kvm+bounces-54932-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 194BBB2B524
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 01:58:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A268C7A2BF9
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 23:57:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1137F27F754;
	Mon, 18 Aug 2025 23:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Cp97+Mh/"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2044.outbound.protection.outlook.com [40.107.237.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68DE827D773;
	Mon, 18 Aug 2025 23:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755561501; cv=fail; b=jyx430Uq9bWeh9hOpKknQVLJVwxm1XFaJksVwaPiQUaqo/H6p8qE99B2dqiARrVGlgwlmaQ2EWitryqUx99x7oHZ7Q2bce7SrUARyWVFZMmKscPdYe8gJ03Xx27JdxguWAbmSxE98FCR8sYBAX0CizWh2ra5Dnui+zNiJ+To0eY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755561501; c=relaxed/simple;
	bh=+i91BjQnD1E+OJFZa0OjjbmGciBZOke55N3p8ygplQE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UzVTwRBeDOauPlQbfPrQO8KOYU4Mh8tJtC000gLhtmpkNwvRSYvjbV5AW5q7j/gYj4qXsESbcvmJU5iI5kymxqR2L4BfInEuZcTrtY8fgktsNsRITR4KBvQUl0NhmmdVF4vTsAZHaLBkiCUmpj1YRfSFEwa0r055aMoAEBV/tcI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Cp97+Mh/; arc=fail smtp.client-ip=40.107.237.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zOvGZXzmRGKy6Nl1inrRqZk+lSQQos798ktqCh4zSuwMOG8YnPHG4V3BwfbMGaOA+ZHDl1On6lqxQJ7IgIiiW6ZhtdPxfJk+pObyJxeShNuCAPHebyoKuyGIKf9c2y+bxR0+IFsnneOIfcSeMRU6RD0e5+bT/sMhPJZ7jdQOfhzlVjG2Wc0dRxNBfs1mPVAG6D1WCAjb88tH6AA3PofobSr7INYjUGWVA2SUREL9enAUlDGmPuJdaQq5LVNCy08jIuyqDy5oToSllu23PWnYk8KKkfUd4hIfo7ZePzVI6Z1g02jeGci3L4bWkRM/kHaM3um+z8MZv6ANVRFdpIN3qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s7/knl6khFUDzEwEOV++ySUxDMQuTZRTghQI4IDyXok=;
 b=VHsUYRIVHDKCCVazNMwWTJIl13YeCMGGFfIFrL+zgKKOF3/l3BqvbW8jkQglQXDwZrLLYoVyEB2St8+H9dAVXQASj6FVHLoWSCyyAoBYxgfVTaJHPIOQNsLJ0M30Iv3eKeoWcT7SUBINOGU5CBgu3wnNNo9ZNymTy9KUPwrwfx3fok6CgfBjz5DQbPb9AXkNKD6yPDYgM4jfsj8uGTeUaVHM5vjP+kaTP/YHQgfGHrYX2qWPkL/26cNVOSbd17XfHqKmyeFYtRroPxWkfgEEG7T1Ts283w4Zl33lpLtvQ/ItDWnxcISaIuMu8hmuigiV20IGfxlNQagbIXD2lODJHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s7/knl6khFUDzEwEOV++ySUxDMQuTZRTghQI4IDyXok=;
 b=Cp97+Mh/Ml7ClzLg1gH6Cb6ope+/PR0n5VfgDT1dJ6ZCca2SZS3IAmO2JP4rtz10+54/tZeob5RwbTGH/qpRMlzYZ9Ig7VvsFQwsjwJM0yx9veGmZRS9J1XRyjLqF0c4PzfoNiYutU1ry4RtgALQChVvjoEwd2rHLfSJkNZoIPM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB9066.namprd12.prod.outlook.com (2603:10b6:510:1f6::5)
 by DM4PR12MB6110.namprd12.prod.outlook.com (2603:10b6:8:ad::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9031.24; Mon, 18 Aug 2025 23:58:15 +0000
Received: from PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::954d:ca3a:4eac:213f]) by PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::954d:ca3a:4eac:213f%4]) with mapi id 15.20.8989.018; Mon, 18 Aug 2025
 23:58:15 +0000
Message-ID: <76ac003b-2502-459a-bf94-55f7b15e2e1b@amd.com>
Date: Mon, 18 Aug 2025 18:58:08 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/7] Add SEV-SNP CipherTextHiding feature support
To: Kim Phillips <kim.phillips@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>
Cc: Neeraj.Upadhyay@amd.com, aik@amd.com, akpm@linux-foundation.org,
 ardb@kernel.org, arnd@arndb.de, bp@alien8.de, corbet@lwn.net,
 dave.hansen@linux.intel.com, davem@davemloft.net, hpa@zytor.com,
 john.allen@amd.com, kvm@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 michael.roth@amd.com, mingo@redhat.com, nikunj@amd.com, paulmck@kernel.org,
 pbonzini@redhat.com, rostedt@goodmis.org, seanjc@google.com,
 tglx@linutronix.de, thomas.lendacky@amd.com, x86@kernel.org
References: <cover.1752869333.git.ashish.kalra@amd.com>
 <20250811203025.25121-1-Ashish.Kalra@amd.com>
 <aKBDyHxaaUYnzwBz@gondor.apana.org.au>
 <f2fc55bb-3fc4-4c45-8f0a-4995e8bf5890@amd.com>
 <51f0c677-1f9f-4059-9166-82fb2ed0ecbb@amd.com>
 <c17990ac-30b2-4bdc-b31a-811af6052782@amd.com>
 <a16f1420-fe20-4c3c-9b75-806b1da22336@amd.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <a16f1420-fe20-4c3c-9b75-806b1da22336@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DS7PR03CA0035.namprd03.prod.outlook.com
 (2603:10b6:5:3b5::10) To PH7PR12MB9066.namprd12.prod.outlook.com
 (2603:10b6:510:1f6::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB9066:EE_|DM4PR12MB6110:EE_
X-MS-Office365-Filtering-Correlation-Id: 350197d7-9b72-4ce3-7bd5-08dddeb317a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VXFWc0ljVzZ4RmYxZTlpZi9SSDRNZ0pIemU3OElBRW02UTM2M0IzaHJsYlVp?=
 =?utf-8?B?M21UWmJoaXQ0S3hDek9WN1AyTFdyVFI2QUJNcXk2bVhseC9samxGNFpGQ0VV?=
 =?utf-8?B?anE1UlRwTTdLclNIWFZLdGY1Y1ZNQ3ZuUUVvSnZJbk5vYUJla3prQXpmOURF?=
 =?utf-8?B?TGN5c1ZkS3dzMTI5T3Zacm5ldzFTUmdCQVIzSWxyakh4RGhxMmVRcFpzNTFp?=
 =?utf-8?B?RmhFb1YzMmV2eGk4U2NHOTUwMGNXOVV1V2J2OUVWUzU5bGZpclJtV2Jtbmtn?=
 =?utf-8?B?Nk9LQ3ZiRUg3UjM1dXdHdkRzclQ2Wk8rOGsyL2Y3RmorYmZDK1ExUWNnbmgx?=
 =?utf-8?B?R2hTRzF2ZjRKWkR2d1N5bm1MYUlZTkJxL1FXbE9aQ2xyNk9ueXFFd1MwYUFv?=
 =?utf-8?B?anBjTGtFWkh2UUFaaVJ0dGZZamt0ZThPeC9vaWkvdVNtZk9WQ3JQZ2hKcVlr?=
 =?utf-8?B?b2Z6ZEovL3YxWkE2dklHejJNRDhZczlidmVkOWU2bVhobWIwY3FCclZPektM?=
 =?utf-8?B?Q3RhcVQ4Qk9qQ1Rwa2xibDc2Yk5GTTVLQ09vS01xZHVqVE5XeTBPby83c2c2?=
 =?utf-8?B?N2R6NkIvUFlPQU5RL1ZZRlR0S3o1eTdMWnh3d2haM0RMWUdLcHNZcnNFbjJ0?=
 =?utf-8?B?Nko3QXcyL0JWeDJWZnNHUXp3eGpmR1A4ZGpuWTRsdDdST2lnVlpZYm1lOWtn?=
 =?utf-8?B?UDRSY1A5bUZXelozazV2aW9XVG5XMk9qaGttTWtaUW9tUUJud09VVU1FZnQ3?=
 =?utf-8?B?WHJVeTU3VTNIcXd6b2JhN1hOTXYzNWFLZWFXaisrbWZOWjNldStPS3VGKzNz?=
 =?utf-8?B?T1lkczJxN256MnV6YTNObmpOTzRxL01jOWFkUUI0dUt3WlJtSTFja2pCWDZO?=
 =?utf-8?B?RTJtUmNSeW5sYVVFZmtCc21RZWpHUXFyZFlSeDRSa1ByejQxTE0yL2E2VldZ?=
 =?utf-8?B?MWtvbkdYcTVwcGhTblNDbkNySFhQZ0VWSTZ2dXYrRGZOcmpOSG9UTXBvNXJo?=
 =?utf-8?B?bjhyS050enVPU1BaTDZkNWV3d1I1MzhGZ3BiQjNXaTh2UE1jQnRoM2tBekJk?=
 =?utf-8?B?S2FzM0ZYMXlhdGRvc1Q5VlVRL3ZEV0xFVmNPenowOFZYdnp6SU9tN21ESGFq?=
 =?utf-8?B?OHNZbUZzWlBPdUlXZXdQYlRjbVBXWS9PU0Q4QXhkMElSR2lsOFcydklZcUNR?=
 =?utf-8?B?dUIyZHJvTExrV0FMdXQrN0srTHhyY1FyS0tITncwaWVIdk5GaWFUcXdWc1hJ?=
 =?utf-8?B?dVdnY1duTjkyQUF3eE1VUjdBWFFwQUJ1MXRESkFZRjY5OXJMTm9RWVNJWW16?=
 =?utf-8?B?bVhoemh3dHA1ZEtEM3VvcGkxdlFFRHd0bEFLY05ZeTVteHFWWlBxQ1gvb0Zt?=
 =?utf-8?B?YWt4OHdLd0JINWY2ckU5K0tYMmMydS9BOEJpcVB1MjhUZzJraHd3Rnc4K2th?=
 =?utf-8?B?NjRKLzd1aXdCQzdpa2YvanQzbDZDbTZpazE3d2JCM1p4TDkrd2JwUitGNC9N?=
 =?utf-8?B?MVNscEhOOGFWZmsxOW5OYXRXNk9KK3BYNysycTdGcUxyV2JCZjYySzdxOFY5?=
 =?utf-8?B?L2RHVWg4RmF0c21oR3d6SVI1QWdCTFZjUHlaZlVzNm55RzJBUUx4eDBkR0FU?=
 =?utf-8?B?bUFFS1c1SWlzaGpkNFNNWm1Ecy9PSzdnSnN0WCtOcXR0eW9DNi8xb2FhWXVs?=
 =?utf-8?B?T2gwYnpoaTB4Z1hGNUk4OHBweWxVamN4UjVRMDVmZnRTb3FzeUhmSmlleVZj?=
 =?utf-8?B?b0Nxci8zcENGZ0djUjhFYzVuUDJRUVJEZnRFK1daMDNxUmV1M2p3NnVNekhy?=
 =?utf-8?Q?l4fEEHK1JiqPz1hSMLIslTIaWyoxlYtUKHN1s=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB9066.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L1FFYWFCSmJpZzFhMHZKZ3kvVzFnRjZpc0VxVHdXemZkWUg5NkRzRHZENkdM?=
 =?utf-8?B?T0xHdHd1QnBoTzl3ZSsvb05NQW0yK1hFV1NKQ09Tc0VkY282dVIrUHgvU0Y1?=
 =?utf-8?B?L1FkYkg1MldUZEU4aHJUWHJsd1MwVzBRNHowN3RwMXJIcURicExMMVlPRUdo?=
 =?utf-8?B?UHhFa0V5SzNXRTQ1UWFFVlZDbk52RnlkNW1FMmNIWDkrTFBwdmdSY0NRTWVO?=
 =?utf-8?B?TExDdU1RRlE4cXJVaEZDMFBMbUlXR29ZKzVoOWVhRTR0YkQ1bVNLaVlqRjJC?=
 =?utf-8?B?Y1gwT3FIbWxMUDhhWk50M2tkYVAyUERIc2wxbnVkMjhORXR0TDlBZ0lJY3Nv?=
 =?utf-8?B?aERwNnFIRFd1cVljTzlKTzZNRkpHc2FjSXU5K0hsK3Y3U05sSGhFWHR3T0ky?=
 =?utf-8?B?WUVDRXR2aWlyNEloRTgwMjNtZ2NHenBLWmFPdlBPTnRjd2xybHJHcVE4MjJ2?=
 =?utf-8?B?NElrWjVCYlRuUUdWQ0JsNGd4K3pTaXd2R3Rzd3p0MFZkM29JN0JnRnFqM0ti?=
 =?utf-8?B?MElKbWQvTm9yei9TMVYxOTgwK0JhandKeVdDMTVXbGMxb3JHQ21NTnQvTXIr?=
 =?utf-8?B?NCtUZ3dCYXJnN3dQZ0s1TTRLTnRZY1duTTVBM0ZHeGQvVURoYWUyWkJLaC9H?=
 =?utf-8?B?RUJZckNXQVU5WlltU3hkUVhlVE5RVFpKbXVOMUg1Qm5qNXNwcUZybzlOUEY4?=
 =?utf-8?B?RHh1SE9xODVBbDBobGJQanVxb0hPWHhhRTc2dnFmVUs1azRHVmtwaUkycStS?=
 =?utf-8?B?TWQ4UXNVOWxVNEFzbFZUVEx3Z3MwWkd0WUZuOWMwUVpDcVZqQVNrREtSUmd1?=
 =?utf-8?B?ZlN3a1pnaHlFTUtKNWY2YzdnbnZad25Qb2RhRzRqWmNvcFU1RWwrZkxxa1dm?=
 =?utf-8?B?b0V3SS9DQXVTamVVUmxYVW9UeGFCa2ZsL2hwcWRsS013cEpSaXhhWVZqSmUy?=
 =?utf-8?B?TWtxT1FpYWFPMkZWZ0VxVDhaV2JJT0l3OEZ2QjRrbFVsVmlhSjhTLzJZQkNx?=
 =?utf-8?B?ejhoQVNLWHZqY2Z3dnZ6WDNHVjZaUDE3cGdkM1FjUkhsRktHQUhPa1o0cDVt?=
 =?utf-8?B?R3V1dnhMNm4yaHBMSHd3NkRSV1N4UW9IZnlvWkNPbGMwTkY0dWNHcm9rc3A4?=
 =?utf-8?B?Sjd3NU05L3d3UW9nOXZPVnZVallqa1daMjF4Yk50UEl0Q1dWYlIvSWxIdUdI?=
 =?utf-8?B?OWRncml5a3pWNWtoNjR5dEd5YkJkOFdCUkRzWW1ScC9rKzRiNXVJUU4rQTRw?=
 =?utf-8?B?UkFhbm82Z1VYYm5HcHVTMmxWMlBvV1JhRGFrbUx3b2JyS256YWtWempkUGkr?=
 =?utf-8?B?M0RvUXAyanFSWXZWanVDVHByb0JHcGtNeElZS0lFOVB5blNpaFB4R2I1Ujhh?=
 =?utf-8?B?M0FsbVFmcVlxSEUrMEt1L2V1UDBXL0pYYnppc2t6NE9CSzNhU3lmZGpMRS84?=
 =?utf-8?B?Y05HUVJLeG5rbW85M2Q0ZlB5YUVzcnZWMjFxYjVQMVE4T0VGWFZjNzM2ZGxv?=
 =?utf-8?B?YXVjRms3RG1iZCs5a3ZQc0dCcnNMeUNJRnFVNGJxR2FBT3hMRi9Ycm9SbFcv?=
 =?utf-8?B?ZDIxaERWK1piTGRnNW5pcVFiVkt4S1pRaDJGanYrY1QvU3QyMG0xbjZObXJW?=
 =?utf-8?B?RTY1Wk1ZNVB4MW83aFRha3B6bWhZaUdzRkhSWmROcHh6VlpscE5NKzF1SWR2?=
 =?utf-8?B?QVV2RjZPSXphZnU2NlBiemVZNGFTWlhXRGVZS1g0Q3h4OW5GV2VXdk5paVdW?=
 =?utf-8?B?ZURwZGZCNW9STitETnpLVXlPbVFheTJ5cFpUUUs3cU9sRGV4ZWRzY2hjN2wy?=
 =?utf-8?B?bC84WkM5TThUNCtIblpoWUpjL3J0b3UwM1orZXZXM05sOVljUnJBa05tVW9N?=
 =?utf-8?B?ZDIrQ1lxVTZTZWRJcHFSZ0hWZ1JRRFpyMHZOMnBlSTNSenBQd2I1K0FNK1Iy?=
 =?utf-8?B?MlBQVEtEbng1UEFHNEdydERyS1ozb21ycmpFanBjcjk2WEFLZEUxcDArK0dU?=
 =?utf-8?B?WU5vbkpRVUZRa3k2SlUxbGtqTDN5UVhNTmYxMnlxNnVpMTVJRW1MZllOZTZJ?=
 =?utf-8?B?dGloSXBqUnhVWVRDbm1hYmJVTXpMeldNNm1iY21pUkhlZHlsS1dSaHNGbHRy?=
 =?utf-8?Q?IZ2zwnzjaWVrGhEKf9lztPlcI?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 350197d7-9b72-4ce3-7bd5-08dddeb317a4
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB9066.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2025 23:58:14.6344
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2YIhEZgecW64AJ/W7/h2m28Rl+8+vbVRwtg81kWjnB579M/sLDY8zrNEpNgHCDZ+MntNT74CKbhEo17gR9utRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6110



On 8/18/2025 6:23 PM, Kim Phillips wrote:
> On 8/18/25 3:39 PM, Kalra, Ashish wrote:
>> On 8/18/2025 2:38 PM, Kim Phillips wrote:
>>> On 8/18/25 2:16 PM, Kalra, Ashish wrote:
>>>> On 8/16/2025 3:39 AM, Herbert Xu wrote:
>>>>> On Mon, Aug 11, 2025 at 08:30:25PM +0000, Ashish Kalra wrote:
>>>>>> Hi Herbert, can you please merge patches 1-5.
>>>>>>
>>>>>> Paolo/Sean/Herbert, i don't know how do you want handle cross-tree merging
>>>>>> for patches 6 & 7.
>>>>> These patches will be at the base of the cryptodev tree for 6.17
>>>>> so it could be pulled into another tree without any risks.
>>>>>
>>>>> Cheers,
>>>> Thanks Herbert for pulling in patches 1-5.
>>>>
>>>> Paolo, can you please merge patches 6 and 7 into the KVM tree.
>>> Hi Ashish,
>>>
>>> I have pending comments on patch 7:
>>>
>>> https://lore.kernel.org/kvm/e32a48dc-a8f7-4770-9e2f-1f3721872a63@amd.com/
>>>
>>> If still not welcome, can you say why you think:
>>>
>>> 1. The ciphertext_hiding_asid_nr variable is necessary
>> I prefer safe coding, and i don't want to update max_snp_asid, until i am sure there are no sanity
>> check failures and that's why i prefer using a *temp* variable and then updating max_snp_asid when i
>> am sure all sanity checks have been done.
>>
>> Otherwise, in your case you are updating max_snp_asid and then rolling it back in case of sanity check
>> failures, i don't like that.
> 
> Item (1):
> 
> The rollback is in a single place, and the extra variable's existence can be avoided, or, at least have 'temp' somewhere in its name.
> 
> FWIW, any "Safe coding" practices should have been performed prior to the submission of the patch, IMO.
> 
>>> 2. The isdigit(ciphertext_hiding_asids[0])) check is needed when it's immediately followed by kstrtoint which effectively makes the open-coded isdigit check  redundant?
>> isdigit() is a MACRO compared to kstrtoint() call, it is more optimal to do an inline check and avoid
>> calling kstrtoint() if the parameter is not a number.
> 
> Item (2):
> 
> This is module initialization code, it's better optimized for readability than for performance.  As a reader of the code, I'm constantly wondering why the redundancy exists, and am sure it is made objectively easier to read if the isdigit() check were removed.
> 
>>> 3. Why the 'invalid_parameter:' label referenced by only one goto statement can't be folded and removed.
>> This is for understandable code flow :
>>
>> 1). Check module parameter is set by user.
>> 2). Check ciphertext_hiding_feature enabled.
>> 3). Check if parameter is numeric.
>>      Sanity checks on numeric parameter
>>      If checks fail goto invalid_parameter
>> 4). Check if parameter is the string "max".
>> 5). Set max_snp_asid and min_sev_es_asid.
>> 6). Fall-through to invalid parameter.
>> invalid_parameter:
>>
>> This is overall a more understandable code flow.
> 
> Item (3):
> 
> That's not how your original v7 flows, but I do now see the non-obvious fall-through from the else if (...'max'...).  I believe I am not alone in missing that, and that a comment would have helped. Also, the 'else' isn't required
> 
> Flow readability-wise, comparing the two, after the two common if()s, your original v7 goes:
> 
> {
> ...
>     if (isdigit() {
>         if (kstrtoint())
>             goto invalid_parameter
>         if (temporary variable >= min_sev_asid) {
>             pr_warn()
>             return false;
>     } else if (..."max"...) {
>         temporary variable = ...
>         /* non-obvious fallthrough to invalid_parameter iff temporary_variable == 0 */
>     }
> 
>     if (temporary variable) {
>         max_snp_asid = ...
>         min_sev_es_asid = ...
>         pr_info(..."enabled"...)
>         return true;
>     }
> 
> invalid_parameter:
>     pr_warn()
>     return false;
> }
> 
> vs the result of my latest diff:
> 
> {
> ...
>     if (..."max"...) {
>         max_snp_asid =
>         min_sev_es_asid = ...
>         return true;
>     }
> 
>     if (kstrtoint()) {
>         pr_warn()
>         return false
>     }
> 
>     if (max_snp_asid < 1 || >= min_sev_asid) {
>         pr_warn()
>         max_snp_asid = /* rollback */
>         return false;
>     }
> 
>     min_sev_es_asid = ...
> 
>     return true;
> }
> 
> So, just from an outright flow perspective, I believe my latest diff is objectively easier to follow.
> 

All the above are your opinions and i don't agree with them and my patch is bug-free and simple and easy to understand and works perfectly, and i am not making any more changes to it.

Thanks,
Ashish

>> Again, this is just a module parameter checking function and not something which will affect runtime performance by eliminating a single temporary variable or jump label.
> With this statement, you self-contradict your rationale to keep your version of the above to Item (2): "isdigit() is a MACRO compared to kstrtoint() call, it is more optimal to do an inline check and avoid calling kstrtoint() if the parameter is not a number". If not willing to take my latest diff as-is, I really would like to see:
> 
> Item (1)'s variable get a temporary-sounding name,
> item (2)'s the isdigit() check (and thus a whole indentation level) removed, and
> item (3)'s flow reconsidered given the (IMO objective) readability enhancement.
>
> Thanks,
> 
> Kim
> 

