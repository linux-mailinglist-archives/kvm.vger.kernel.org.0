Return-Path: <kvm+bounces-17791-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C2D028CA1D9
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 20:14:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 530321F21A06
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 18:14:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BA81137C57;
	Mon, 20 May 2024 18:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="H2I+x46Z"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2047.outbound.protection.outlook.com [40.107.223.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAAB1137744
	for <kvm@vger.kernel.org>; Mon, 20 May 2024 18:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716228886; cv=fail; b=LRD48yxQxLRkCxNfwya+TwUxJfLsJA+9tg7H/h3Knuzyj4/MbE5P6HwArEub9B9hVzWhFERWTBBTW9qiMgGEKhtnUNvojc9lsN/6dRbFc1aVkthSZK6o3mlZWAqbDs9YQ5VlzKC45D70x0Ka+DHdvR64yrqLiixiTEqVzrk+TrI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716228886; c=relaxed/simple;
	bh=KDQyS2hPiKOenpsojB94TBtx6bYPy6gPxIg9+pu1ZEU=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dAm7BG+8m++JG2MhBDSEGywOD3RKzbZ4EGJDuNU+3U68FCKNT3+oxe73rAG3m08o/puJLCt6idVOcRuGwyCuBh1Dc/nbgHSy/7uYmf/wG+UCDRlDqLggjTFpe6QnU71keDJZs3Rh7l0k07JutSiWtd+agmu9UTLSvgzFku/Vtuw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=H2I+x46Z; arc=fail smtp.client-ip=40.107.223.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ksIxrSsTFZNSLb0j3+KaauFyKgipezrEN1cRqIiF8MEvYjHv/MX2G8/G0uesEwK9IJzEhh35Nx3/l1Z5mAYqfhPB7UPZm6OgI9B4Hk7dHYFgKhHJbwzb8cEMqmLqyymQoGmi8Qti4OhFZ4OtauiW4IirI+R67HfKlBdEtxRrtSJDeZt/zHlxP3DR2qd2aHtoJBAjcXfHDc7eZt73zSTqiaOmS51OTr/DuaT6cQ/5bIkYApZ4UGMJ3P/Q1vC5mwbGAj1UyCbGCbLHsidE/dTuPeQuObttwGHlxN3m+jXLitl0zccOfHjox2OBv8oRGegoukzzZXiJSSlJ4wroWFz4qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JseHux1N4IAmhCbbtUgu6rtFJgSLMMaXXosZDKuxUtU=;
 b=HcO8SEiuxR0ZY7vLphLbTNsbo/q26HCwl4gH+xSqJpK6+a/7SZaOWQzdUpLU9zlnB5r4WU/SQc0u7r92BUnvqnTpS/Mh/A+0ACwHBMhFOjTsllSdDP7/4IovBuAMq5Ytsm1kwxIxKiPvMDrJncaUztHqRakeA4JjaJogTxmG/DYnfPGF/MRRy9Y+TCh5BjFhFtvpAO8mfmr0a2uDMDh67UT5Dubnjkk1+XOtQ+Kt9pzzQ5SJOoFEjUTK34zQgINYvxP0/nEORcyRTJ/5aU56UyXTjMFY24z6nOTq/N4o8hny+0cpIYfkAwxmiiE1g6JUUl01Rb43tokmVjK2vAY+Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JseHux1N4IAmhCbbtUgu6rtFJgSLMMaXXosZDKuxUtU=;
 b=H2I+x46ZwGnF7Hl1kkSsigbxjzUyU9Iqy8xxWr8XOlGmS1tJbA4K8cav20utHdBrq8rakVH14zBW6WXsUsGuEz05lYUnRVm+3Hb6qdeRk/LqH379kGuKhf+dmtmqjzi5b35Nqu77+eWGIenV8HmRbJMRQdncVWGWeprxZoxlRbg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by IA1PR12MB6212.namprd12.prod.outlook.com (2603:10b6:208:3e4::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.35; Mon, 20 May
 2024 18:14:42 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::bf0:d462:345b:dc52]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::bf0:d462:345b:dc52%7]) with mapi id 15.20.7587.030; Mon, 20 May 2024
 18:14:42 +0000
Message-ID: <70a758ed-7f50-560e-9290-6baa32977846@amd.com>
Date: Mon, 20 May 2024 13:14:39 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v3 1/3] KVM: SVM: remove useless input parameter in
 snp_safe_alloc_page
Content-Language: en-US
To: Li RongQing <lirongqing@baidu.com>, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org, yosryahmed@google.com,
 pgonda@google.com
References: <20240520120858.13117-1-lirongqing@baidu.com>
 <20240520120858.13117-2-lirongqing@baidu.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20240520120858.13117-2-lirongqing@baidu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR2101CA0011.namprd21.prod.outlook.com
 (2603:10b6:805:106::21) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|IA1PR12MB6212:EE_
X-MS-Office365-Filtering-Correlation-Id: 55c94bf3-acfa-4ed7-e9f3-08dc78f8b834
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aWxTTWJ6YzhoSXhhaTBXY3RvQkhkVGlOU05Jci9rSkhQT0EvWHVndVBjLzNs?=
 =?utf-8?B?WnRhRE14VVg3RllaVEZ0TkNwZkRjNG1BQlNYanYrWktKTnFIeHB5bCtIcTVX?=
 =?utf-8?B?SjhYZzhKNXNMTWcyTEdieWhaVFNmODdYL3dHekFpb2RYa25acE8wT3ZVOThz?=
 =?utf-8?B?cFY0U2pVQmp2M3NyOWpIdnRUdG5YZnFqdkJYRG80TUNmSmpubzEwdTFYZVdw?=
 =?utf-8?B?WHB0Kzh1eE5pS3pZVnZJNTJ2NXNzNlArdXpKUUExTVg0R1h6Y3FKaVd3Qm9l?=
 =?utf-8?B?Si9CYmovenpMTUZhNDJqUkoyYjBnL1NZYTBndS9wRzdYUzl3R0dYRFp6Z1lu?=
 =?utf-8?B?TEJjaW1TZGt5dnBkZVVKV1pwamVjMnhmalZMTWJ1MWJ6WkJhYzRqMHFQMzY1?=
 =?utf-8?B?RkZKMGV4TTA2V0s3ZWNpczRDbnhvMzU3YUlKblBzSGIydzRPdEppRnZDUDJv?=
 =?utf-8?B?bzdzMFgxR2YycGlLa2tHa1JYNXVYMklYZTgwcWpJSDQ0QlVQVzZtNStYclIr?=
 =?utf-8?B?anVFRmlFall4SUZXL1VPRDNURkcwcXpENUhiZ2RBT0ZoU1oyWnpSLy80aVBq?=
 =?utf-8?B?ZUxiR1dFc1FvNkI0bDZXemFQZUppUGJLTnJQQVVSMU14ZlVzR2huUllMQlRS?=
 =?utf-8?B?YS9FMExkZ3RKNmZ5dE5ScUJtdGpWUFdOVWtCTjhXdW5pLzV0Vzg5RUxJVTBU?=
 =?utf-8?B?RGRtSW1jcmt5VUF4QUxqbG9QNGErMURSSkdQTjRZS09qMXJNSldHb24zYTRn?=
 =?utf-8?B?YlFDbCt2b0xpbnVQSTB6Ym9sK0hXcEFuSkdPYnJtdEN3VUF0N0Fod0J6Witp?=
 =?utf-8?B?amUyUyt5d1hLNTJ3aGNVUGI2SGJwYy91dm5pZ3dGVVQyYy9BZGlGZnY3Lzc2?=
 =?utf-8?B?anRSSWxpSGhva1pXWGtrZmpqcFVnbG0yc0ozMEJLUThHSTdjbExxbWt5cHdy?=
 =?utf-8?B?OGpzTVR1OGFXbnRQYktKSWJGeEo0SzlqUjMxc0E2MlRFNC9xRUJVc2Q2bzRK?=
 =?utf-8?B?NUdWTzlhT2N1MEhOcDN1bGxEaXRXcUFpR29naUNvci9YaUpoVVdFU0ZsYmJC?=
 =?utf-8?B?citHVFFRcGp1RU1RWngrWkpYWU1LSThYY0M1NWRyTlEvRHVyMWtOQTJXVUVE?=
 =?utf-8?B?RnNMcVpOait0WHQxQUZBSHA0MjZEeUcwaTlLZUZXWVFJVTdWQngwWHZGSTVy?=
 =?utf-8?B?NTNHaXowWml4bFZDaUdIVzVhNEp4ck1jbWZLSDZGeFBiZHZnbVNoNlRveUQz?=
 =?utf-8?B?SXlwUEZ5Z1VZTGs5ejhpR3h5UG1lNjEwemdmcXAvUTZGNGt1VUtpaTJWbG1R?=
 =?utf-8?B?NGozTExXMjNRWEtYMEt5c2k0TGZSSUp4Tnh2UGVyd1hFeFozb21HNVl3dnUy?=
 =?utf-8?B?NjA5M094TWVCOWxjNUN0U3VaaUlCdUFEbExMTXBvOGUrSVBaTlcrcDlJeDJC?=
 =?utf-8?B?Qi9wOW81ZHhOeko0dEgwUDQ4aTBjc3M1ZE1kK0Z2Z2pId3BTUjQycWlEaEJW?=
 =?utf-8?B?K2xTNzB5a3dxVFRCekFhaEJQY0VKLzFkd0NKSVFWcTlXMjZRY1kxRmNGYzdY?=
 =?utf-8?B?YUtIZlhSZW9ENTUrOWRPSXZUdkMrY3NWa1NoY2RGWjJINHIxSU4rbmVhK3lp?=
 =?utf-8?B?QzNwWW83ZjJDMXhLeHdqdmVHZzJLaG12ZXViNUc2Zy9MeUxzUXlyWUdrbDhj?=
 =?utf-8?B?NlRuZXVocUxhbnI5UlNXSTdzZlkwZ2dBeVYwYmFNMmd3cWR5a1BpNW5RPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aVlHL0w2TytQWjMxOFZ3OEhUMnRDdDRtbStzSjZGbEJ1dGd1Rmk2VTgvZ2Vw?=
 =?utf-8?B?U3hZRTNJbVl2bzlmdndwcCsxRXNUWU1ZaFk0WmpQMG9PbEU5MFFQdjM3L2xj?=
 =?utf-8?B?SE1tdm5DaCtjcDNPTU1YR045T3FBYVFOUWx1UU02Y25EQlhuc28xTXR0Sjdm?=
 =?utf-8?B?TnUwendYQUN2dTJJTUhLekFQL2V2Wm9CVDdMb2lEb3dXRWVzZGNVS2xDa0Yr?=
 =?utf-8?B?L0xNb3BYQ2VmdEdqYzNYOENFdk53dHVWWXR2S3YxZWZlQ09HUlFoOTMvRkRy?=
 =?utf-8?B?SmhuN1pTV2huY0NYTVF3UHpqSStPYnNnbTgvR1o4TUpiR0FMTmUwK0dKQ0tO?=
 =?utf-8?B?VjJ6cVdOU0N4N283QW9pMitiRkxMQS9FWlVabE9VbWwreWJKSEx5YmdZNkRo?=
 =?utf-8?B?T0NXQ3YzbEFNTE9FVERvOGJZRlhMUFNXK2crYVZudVZGck5pdDg4M2tSL3ZZ?=
 =?utf-8?B?SlBsU2tRcm0yWkRWSFFWcStIMGFwNVhwWDJ3NkJkYmVrblBUdzZ3Q29HMVVw?=
 =?utf-8?B?Y3NtQi9Lb0RjMy9oMHZJUCtaUnNEbDFaZERwQ3pCdHlndDJJWHRkcDdIS3E4?=
 =?utf-8?B?WVBFUmp1Nlg5UVlhMmE1dE5SUEh3VUsxZlUvemRwcWpnNGM5WEJDME9ZU3hF?=
 =?utf-8?B?cDhsamJyVTJ6SWo3TStjaXVSdE1ESW9YeWVPWmJQZWo5bE5vNy8wMHIrbWdG?=
 =?utf-8?B?OWk5UFBaU0VGcGt5Y2Jzc0VXazB6dHNiUS9oR1kyUEd6cE9VbE55YmQyUHc3?=
 =?utf-8?B?dUlSV2ZwQmU5eEhWWkpBSFo5K054QXBFMjBRUklCSEN2KzFKSVpBT1VWeVhY?=
 =?utf-8?B?SlNWQk5ZSFZrcjhndDJMQ2ZnYXVlZEhyYWpGZWJvb0kxQXdsRDdkOGFoZ2Jy?=
 =?utf-8?B?WWtxNnR5eFVWc3h3S0d5QmZoZzhMS05NOEt5bTZMSEJMSlhpQmlGempkdnZs?=
 =?utf-8?B?T1YrSTNROS9ibm4vTlFhbmhPdFF6T1Jvbm9BZTJnS1BGM0ZNb0N6U2I1eXVR?=
 =?utf-8?B?SEJmaUpZRyszSWdwakJnb1M4dEZMakVxVW01cmp6bCtDMzBFdlVIWjAwNHNa?=
 =?utf-8?B?cjUyd2FZdVU2YWpkUitCQUNCbjJsNkYyQjY0WVVIdzNnL2FUaU14VHNnUkJz?=
 =?utf-8?B?OGhvNUJPYmxWK0lBbXdRaEtsbXRZZFlSMDJHQkpEVjV6dnVwZ2FZa213L3JE?=
 =?utf-8?B?QktodHVNaytadzRTVTRlb2hockwwOUZSNWdDbmdHVEU1bTIyVk9hTjcyb0lt?=
 =?utf-8?B?YkZhYkM3OTZnZUVuNEE2MkJIKzlsUXlUcy9ORDVIRTNqVDJoYVl4S0xnUXFT?=
 =?utf-8?B?djNyM1NLbVYyTU91bUtGNFllWGE4U3BMVitiMkp4RlpPeUlrUE12bFFyVUt4?=
 =?utf-8?B?Q21uOUV5aUtEN3FPU2IyYktGdnd1VURWRk9QMlVocWhIcFVIOXBPNktHQWdv?=
 =?utf-8?B?VEJHRm9ldkdOTjBNRjRkQUFUWXdEYUZxcUQ3ajNIcEc2TXYvYkxCekRRNHFZ?=
 =?utf-8?B?Nk1EMmNISjNTVy9NcnRuK3R6Q1V3RVczQjA2clNLbFVjMzlEMjd0dExKS0pU?=
 =?utf-8?B?SEowZHhQeU5lSERxMVVLOEhCTWt0UDNPRWtDRXEvbXdZa1JLRkVEWEFac3BV?=
 =?utf-8?B?di85cWU3b1BZeTJpcWg1SDc0UkE2M1R4bE8wWjhnN2ZxYUs1UnRGVlZmRTRJ?=
 =?utf-8?B?VHN1MjdQa2l4WmMrdVkwU294U09FeFcyUXNNSGVwRHlkVVNqbExhQ0REVXRP?=
 =?utf-8?B?dXFSNWZFdUVXRUl6OVRQNWluZTBNeWlmNnNzVDIra045dUZNS09SRHN3RUR1?=
 =?utf-8?B?VGNzV2s5TCtTY05BM044TGRLNmNMYUJyVkN3UXdSdUMwcGM0ZGlLZ0d0ZGI1?=
 =?utf-8?B?QjdRcHdURGw0ZU9YR3BUWDdndFRxL0hsSDdNMFpZRStzMCtHcEdoR25tbktT?=
 =?utf-8?B?NzR2R0FObHAyUVRZN2tWNjF4M1JrQjdnYVJ3VS9JVE1seVlpaHI5NkVjZGhF?=
 =?utf-8?B?eEcvUVltU093ZGdCRnNlbVJOSCt0c2hzQUNjdjVEK296NzhHbFdkTFBwSVhU?=
 =?utf-8?B?N1lKNGRTZDRPekhhakZiUnVHYTg1YU9JM1Y2RTNwRnJ2YVM3TXhkY21XSXpi?=
 =?utf-8?Q?ecf6GxkNxBmqEsnvnKt8M7Xrd?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55c94bf3-acfa-4ed7-e9f3-08dc78f8b834
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2024 18:14:41.9308
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T0spBB1i3JqCRcCTPatrSHvSE10cr2n+PI6UBi+tlSKnu2GYKT6xA8Zsv6honIy0UxoBf+YRRSHCd3C3rL4T8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6212

On 5/20/24 07:08, Li RongQing wrote:
> The input parameter 'vcpu' in snp_safe_alloc_page is not used.
> Therefore, remove it.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Li RongQing <lirongqing@baidu.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>   arch/x86/kvm/svm/nested.c | 2 +-
>   arch/x86/kvm/svm/sev.c    | 2 +-
>   arch/x86/kvm/svm/svm.c    | 8 ++++----
>   arch/x86/kvm/svm/svm.h    | 5 +++--
>   4 files changed, 9 insertions(+), 8 deletions(-)
> 

