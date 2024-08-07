Return-Path: <kvm+bounces-23481-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 442C994A19F
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 09:26:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F3973286540
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 07:26:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F1DA1C7B90;
	Wed,  7 Aug 2024 07:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="oKHopScw"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2069.outbound.protection.outlook.com [40.107.100.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7757E2868D;
	Wed,  7 Aug 2024 07:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723015554; cv=fail; b=Fh902saA/WME9lHGYta7b9GyjyBf0/+HH3Q6bmH64JkOiwrmHoFwqKNCw5dajzpHrD6psmOaXLh6DvaFBqjyyIpw9k7Lkn4xY33MXYc1em6G3xsSn86id4cShuWL7yUFtTRBHzxnKaG/QZXaO40egxyNaChMoAyQqdVzxKkZ87U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723015554; c=relaxed/simple;
	bh=sED/Uq5wp7pu7sFkN/Lx8YW3bXcwLh1hKvq8cfg07mY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HAkIfoANgNbd6id+fozrO66SJ2mJJNXDqgyrmaO1WVc3Tvh9DLf7fBBQc2zzDMMwVE1fCfpg2hYUDGPTraLM872II3sC6F26TyZjV2vr84XfOQ0HJbwO6bQkW91wgmtG6zWDNBLzX5JxV4p8b4EBq4pW+gzj/BUld7F8Ybs1WuE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=oKHopScw; arc=fail smtp.client-ip=40.107.100.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qXiaoCjAFB0ZuceWopZb/ZRV+8UyDHjDFyGmtwmLn06AmoVlN+lmlUXgdjN/jExPwI0t0xqAKC6PD3alnO7abQMwJRXnfTpvFLWUzs2KaAbHumV8N6Wjfy5OD81+O7eoioh0Pfnh4qBMeqqd12Gg0hqWQ0sp+ab9JqC7QPMMbyqR5yMy+aA0JoRA7xm5R/u66dBLUxfactOmS/nPNcFnNH9+qbBNzUp3a1zUbBmxfSRF98qSMiamBV3Su83PN9U+y6WqFV2dNa2G0dUa9Zv9pUVWmBPc7IMQ0IvPDVKnFqqIP+2dDqdW8J7IjHQxbjvQJw2+tlVAIpZpSpc+2VfZ8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dO1EfKRdzixGg7LDBwqs6g9f05YF/7eoBvc1QLPChEs=;
 b=U8yfUD3aZvZb554urmPBSm94EjCrpxyIFyw4/7Iec3qHmR1rLw+LnoDcpk5VLzzwl4qy3EMwDOXPOg41OEe6zDp95hKXO2s1Ruop0bcoAJTSngaxg8sD4S3BaeIFZezNj5JkvYvKZ+x7VbZDT3eNNxtbjtNjlOfvqR4iAaChGjheH3HB+BY2Mnzwu1KWjUS6qrGteWDMoNniketIDDRpwElTCKO54TY/FLNxL4VKd5kCr2xvcQ6nTre4bBHWKR1obu28QI/SiXlWaoEhvAto1Lb6UM0U+7Bet66gLhtSPNsrss1vktwa75u4zpZDiXz2gmP0f80Uci8WR27Oe6ae2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dO1EfKRdzixGg7LDBwqs6g9f05YF/7eoBvc1QLPChEs=;
 b=oKHopScwAEdWYvzOrHawGiLXzVwR9xg9pUQT4xIoTMFEK8dF3UGYlW1PR4IX+s3NK2ZPGL3a+CZl6ynTqs55mPjDGa3/RfkpWnO8U5MLyuEdnbQqGpdqMe8R7RpNbDTnuj+9+yeEslOypEggBkOD00L75Hs2IDrZ85lULxum2Dc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA1PR12MB8189.namprd12.prod.outlook.com (2603:10b6:208:3f0::13)
 by MW3PR12MB4363.namprd12.prod.outlook.com (2603:10b6:303:56::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.21; Wed, 7 Aug
 2024 07:25:48 +0000
Received: from IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48]) by IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48%6]) with mapi id 15.20.7828.023; Wed, 7 Aug 2024
 07:25:48 +0000
Message-ID: <6a82ee1a-b0d0-b6c2-21e9-8d8e2d2b6827@amd.com>
Date: Wed, 7 Aug 2024 09:25:42 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v2] KVM: x86/mmu: Clean up function comments for dirty
 logging APIs
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 David Matlack <dmatlack@google.com>
References: <20240802202006.340854-1-seanjc@google.com>
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <20240802202006.340854-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0171.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b7::18) To IA1PR12MB8189.namprd12.prod.outlook.com
 (2603:10b6:208:3f0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB8189:EE_|MW3PR12MB4363:EE_
X-MS-Office365-Filtering-Correlation-Id: 585cc3e0-1dbd-43b5-c453-08dcb6b2286c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OWpDV2VwYjVmeDFBcG9kZGhnMkNXcjBReTlnN1haVEcrcnNleHIraTVuZS93?=
 =?utf-8?B?NE5UdDRvRkViNkUzOXNLMnBQNHFXdU8zRVBDejVhb0JjTjRRMDZ2dk9lWUhk?=
 =?utf-8?B?cys2UWkvcDQvZVN0QWZZbzR5S3BreS9OZnVTTkZVbmJBTzU4MnpZeTZPOFNw?=
 =?utf-8?B?VzRnN09jTHJRZFRuYUkyeTBnRHpTR0FXNi90U29SMjlsbXo1REEvYWlGY1o0?=
 =?utf-8?B?YlhxcW1oM3FadVBrdGN1NmlKVGEydU9EdDBRSGNSWEVtQkFpQmFiVnNBeWY3?=
 =?utf-8?B?M3dYNGdzMEJ5ZEJZTVNLUHVocUUwdWdQNGFkWlRrMkdSaThzeHdCRllWWXNs?=
 =?utf-8?B?cVN1QzNiMGZESGpSL2duWVNLRFR4L2JqdDlWUzlnK2ZrRWI1K21vcXFLdVRB?=
 =?utf-8?B?VXJWdFA3SzNZRW81NGVzQzhnU0o5TWJ1bDJKcjliWk9KVytkdVo2UGVxbUtP?=
 =?utf-8?B?VkN1MkJObGRBQnVuLzR6Qm9ZRGNuYmdvSnFScFRidmozN2Z4cjByWEo2NkpL?=
 =?utf-8?B?MTNUbmxWM1hhTkFyN0Z3NHlwMEVubThCZ25nbHVjUEt3MmhqSGFZcjRQMTJs?=
 =?utf-8?B?cWo2UUE4UkVnbENJeHVLOGZPT21uejVvZDhUT3pINDhyY01EczFRZXBBYm01?=
 =?utf-8?B?V2dXUDNmQ1NiSnh3MytBbUx2MElzSVl5U3JvZ2JsVzVYZXR5Zmp1NlR2OG1i?=
 =?utf-8?B?bkRSbllqMmdXSEduTzZmdFRIWkdoOElUcmdkRm41c0p2M3NlRldHUUxDcmVp?=
 =?utf-8?B?MStIM250bEFlV3o4czlXeXhkdUtxSVQ0bFFCQWM1ZStXRVhYWVJ3SldQbllk?=
 =?utf-8?B?WjVNeHFKaG5ySElYK0Ftd1pHMm9yWWlyZHd5MzJRM0RXYlhqSGd3NVJSSVhY?=
 =?utf-8?B?dVBwbnByVTlaVnM0dkpSUjJMbzFNd1FKcjVHOUl1cWdybmFFQmdXVGltNFlC?=
 =?utf-8?B?WjIydnNEbEpUL0p5WDJiNTBkMUJmZUZOUngwR202RndqNG85R3FWUWhJSFJ5?=
 =?utf-8?B?TklXTTNTSHhqNHh2c0NhNWpJTUtHcDNMS2ZSeW0vSFoxSVFqejVQVlBKOXda?=
 =?utf-8?B?QkxVR1N0elgzRDY1RXVacCtDMmxwTnZkSzBhazVyUjBUTmp3V2xTeExHbEZT?=
 =?utf-8?B?Vi9jbDR0OGptb29tc09zUG9DUjNmL21maG9TNVREOUkxcGxmT2NVOFNNVEpY?=
 =?utf-8?B?QnV3T0NUeFZoZFJsVXdiWlExZGtpbkN5UFN1OUIreHFsVHhxS0w3R1NQTHIy?=
 =?utf-8?B?dTVKbWhWM2x2dzk2dXFtT0dOR000OTU2bzRXOHZyWHl4UkZqTkZ0SFdRQ3Ny?=
 =?utf-8?B?ditGRjVYRDRyUGVmc3FVSFBMRyt1SkdHRmFKTlRURHBPUFc2dy8wNnM3ZlQ5?=
 =?utf-8?B?K2hjKzQzR2VUVG1nNVN1ell6dVpBalI2RkVNaHA0bUQ4UmtVcUNYVkltcGNW?=
 =?utf-8?B?TzZ1d0pvR29JcEpqdFJKMTRLbnRJVzRPS0FnU014ZzVXM0lqOXZrVUVRU0NZ?=
 =?utf-8?B?QVR6OUJwTjVjZWhocHhNVnk0ZGFNUzJmNHk0dncyV3Z6Qmc3YXhSbGJFMnVM?=
 =?utf-8?B?WDFBSmpPYURrb1liN0FQZzh6cUY5Mzk0RWFXaFlxckZSL05RNnlvUW1vTGZT?=
 =?utf-8?B?MFJObk15UFhmVXNoVnFzOTJVenlWT2M5aEE2bUFaVXVwVCsvaXBHWEhtNUtG?=
 =?utf-8?B?T3lieXJHbmY2d0hNMituSGVKM1NrWnd0TWtjcG50cXFWamcraUJiOGFvcGMv?=
 =?utf-8?Q?WRsc5Br0z+kCr5WpLM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB8189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?THFTb3UxcFhjOG5IZmVrYmhzd2FHUXg0TENpUjdrcEpnOGtHYzFRSS9MRGl4?=
 =?utf-8?B?NENkSnBXNlNPaFNXVzJBUmV2RkxPY3l5RkVEOWQ1MytERmpBcEJod244dlJj?=
 =?utf-8?B?blF1ODNEOGkrSlY3V3ZHcUo0blZ1TVY5ekxabEhOa3QyQWkwaUNRSTBOQ1lV?=
 =?utf-8?B?L2kzR2xSa2F5aWZrRENsTFp3YjN1dDlyTDhRVHJYdXlTSm1vcGRlVkhKZFhC?=
 =?utf-8?B?eS9VTEhaTEh1cG9wN3BVejgyWE0rcFFtcWxqMDFGRUxvWTJqV2xaVU5IN0J1?=
 =?utf-8?B?d2kvRnpXZnZ3dFZEZHJtZE1DNlpXQTNhZFl5WmtYdlppNWtFUEhQTW9IK0F0?=
 =?utf-8?B?V3lRSVpXMlVZdEZHQmFUb3ErVE9CWGs3M3NucU1wSUR4MDMyU205QTJJeFp4?=
 =?utf-8?B?ZncrQVhtU2NCODJKTWE5Tkw3SkxyT2d0SWVqRmlob2M4MDVSN3d4K0pCTWEz?=
 =?utf-8?B?RktZdkR6Y0d0VExWaEtmVk5ZQVdiSnZLcGkwSWVOUlllOVhjOVkxYlJJQkVF?=
 =?utf-8?B?Mnp6YUhxVXNocjFWd2ovMUZQZ1d6MWhuZ3pjdkw5WjhScFVObkVkRlNvMEJD?=
 =?utf-8?B?clBXY2xycnovVG1STTYwQnhacFBxRzVsUnVYVUdZcVhtV2ZhZHE0YXJwaUxs?=
 =?utf-8?B?RWFKZnlNWEYrT2NVNFlUK3JxR0FvbG9LNVdRZEhINldTRWoxM29obTdzMXFu?=
 =?utf-8?B?RG5oajBHOTdUa1lEdXA0MnJHdFV1WC9nb1kveWhkZ3o3NmlyUk5VZWt1QVVJ?=
 =?utf-8?B?T1RxbWt6cUhTUzZKdU1rUmNEcnRYdXdCUVIrcm0wSU1lKy9PWk1JVkdmV2R3?=
 =?utf-8?B?VmRWYkNUMEFWZ2xXMmRVR3Zubi9DaE95K1E2SHZvaTA3aE1jVklteUkxZjkv?=
 =?utf-8?B?QWNWNW5RelZ1U3RnaWRLdVBpcjZpdUtoWXVXdFFTc3NXaFJFSDUyYmZmUEhP?=
 =?utf-8?B?Y1FDYk1Ndi9KUkpoMUdOQWdkdkVyU1p3SjVSb3B1M3ZPeDRaWVUvVGFKVUMv?=
 =?utf-8?B?amQ5N2RXaEFHVGVrSUlGKzdZc1piVm1IUERaT0tITXlQZE9jY3AwWEhKYWE5?=
 =?utf-8?B?R2ZydkF4NDgrVEJmVXByUXlNQUhtajc2QnJ1RUtxa1FLUUlpRTJRRE56WDUy?=
 =?utf-8?B?NDgrWmd2Z0wvcWRvRm1YK1JYOVFyL2ZKWktlMW1HRVA4UEo3THpRSjJiOXVM?=
 =?utf-8?B?Mi8yU1lNS204M2NXbDdyV2lOb1VwMFF3ZnJlVGhRWUJUUWprZk0vS2E5djhq?=
 =?utf-8?B?OWxwWjJLR3k2YndhbTZoZGhhR2Zaa0VjOVdXb1Z4YS9hMjl2QXJqc0h0MlR0?=
 =?utf-8?B?MDdxUWc0bFpFRUxpdDdvY2Z2OW9LcXltT2Nra2IzelpESkQwQmM2aWhvU3FM?=
 =?utf-8?B?NTYxeXpsVWNkOFZHTGs3QTBMVHVESCtGTGlCaHRnR0NtbUwxZ0VSV0Z2UHRB?=
 =?utf-8?B?RFZrajlWNTVQSkV0ZUM2ZzBJbEJ6K3ZpQ0RnaUJHZ0xjcDdSR2w2VzhFbDhK?=
 =?utf-8?B?V2lXbDAyRG14WHpGa25QVlZIakNIN1h2VHFKNFRHWHFZQ2tkV3J4eUt3djBr?=
 =?utf-8?B?dUI1bDVlSEVLeUtzUmp0NTl1N3lSa0NVeEloWE5qdFQwRGhXYWxKZjk3V3Jl?=
 =?utf-8?B?dUZUd1dKYXhEOGZJOHJScU9QcnNNRUFQZVFxSHJjbTA0SmlyY0crSEtXRHhv?=
 =?utf-8?B?V0FqalRUb2poaFRMckQ2ckZpRFZ4ZTRadGNZeDRmVERud2ROM3FjQTl0TTRC?=
 =?utf-8?B?QWhaalNvMEJTbmhaSXdRWnpXRHQ2b1YwWFRkdGxxRHNDYXlINjFnQit5a292?=
 =?utf-8?B?MThaNTRLd050YUVzbS9NR2hESXRic25IalRTOG44Y25PK1JFMSsySDFDTmV6?=
 =?utf-8?B?dkg2aEkzQXB2OUNMb0hneXRqdjV0bWtBN0gyQ2VLd0pkSDY4Z21GQTljeGZT?=
 =?utf-8?B?MjUwYlF0cjRvMWt2RjFNNWUzcUJid3BxNktoRXBIbENEMGtsb3pwSHk2Unp5?=
 =?utf-8?B?QzJPRm9TZm5EWjk4UFMyUlI5RmVwVGpLRmE1aUVUL3R3T3hTTXA2U3c1d04w?=
 =?utf-8?B?VlE0dGFPSUMrbVdTNHZhNkVQNXNuaFBoQ2xoUzNQQXltVFVGcE5IRmlhYjlS?=
 =?utf-8?Q?wzBhdau2t6f+8VT08berRPm+d?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 585cc3e0-1dbd-43b5-c453-08dcb6b2286c
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB8189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2024 07:25:48.0281
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mwJw2UTxpDB7z4cNb2W0hJdu4znRyz7SJpv2zRUx5kN99161xcLXk9ovZSawlIujG3SqI+K14oKUYCTq/QQv9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4363

> Rework the function comment for kvm_arch_mmu_enable_log_dirty_pt_masked()
> into the body of the function, as it has gotten a bit stale, is harder to
> read without the code context, and is the last source of warnings for W=1
> builds in KVM x86 due to using a kernel-doc comment without documenting
> all parameters.
> 
> Opportunistically subsume the functions comments for
> kvm_mmu_write_protect_pt_masked() and kvm_mmu_clear_dirty_pt_masked(), as
> there is no value in regurgitating similar information at a higher level,
> and capturing the differences between write-protection and PML-based dirty
> logging is best done in a common location.
> 
> No functional change intended.
> 
> Cc: David Matlack <dmatlack@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
> 
> v2: Put the comments in the function body. [David]
> 
> v1: https://lore.kernel.org/all/20240611215805.340664-1-seanjc@google.com
> 
>   arch/x86/kvm/mmu/mmu.c | 48 +++++++++++++-----------------------------
>   1 file changed, 15 insertions(+), 33 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 901be9e420a4..45e7e9bd5e76 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1307,15 +1307,6 @@ static bool __rmap_clear_dirty(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
>   	return flush;
>   }
>   
> -/**
> - * kvm_mmu_write_protect_pt_masked - write protect selected PT level pages
> - * @kvm: kvm instance
> - * @slot: slot to protect
> - * @gfn_offset: start of the BITS_PER_LONG pages we care about
> - * @mask: indicates which pages we should protect
> - *
> - * Used when we do not need to care about huge page mappings.
> - */
>   static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
>   				     struct kvm_memory_slot *slot,
>   				     gfn_t gfn_offset, unsigned long mask)
> @@ -1339,16 +1330,6 @@ static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
>   	}
>   }
>   
> -/**
> - * kvm_mmu_clear_dirty_pt_masked - clear MMU D-bit for PT level pages, or write
> - * protect the page if the D-bit isn't supported.
> - * @kvm: kvm instance
> - * @slot: slot to clear D-bit
> - * @gfn_offset: start of the BITS_PER_LONG pages we care about
> - * @mask: indicates which pages we should clear D-bit
> - *
> - * Used for PML to re-log the dirty GPAs after userspace querying dirty_bitmap.
> - */
>   static void kvm_mmu_clear_dirty_pt_masked(struct kvm *kvm,
>   					 struct kvm_memory_slot *slot,
>   					 gfn_t gfn_offset, unsigned long mask)
> @@ -1372,24 +1353,16 @@ static void kvm_mmu_clear_dirty_pt_masked(struct kvm *kvm,
>   	}
>   }
>   
> -/**
> - * kvm_arch_mmu_enable_log_dirty_pt_masked - enable dirty logging for selected
> - * PT level pages.
> - *
> - * It calls kvm_mmu_write_protect_pt_masked to write protect selected pages to
> - * enable dirty logging for them.
> - *
> - * We need to care about huge page mappings: e.g. during dirty logging we may
> - * have such mappings.
> - */
>   void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
>   				struct kvm_memory_slot *slot,
>   				gfn_t gfn_offset, unsigned long mask)
>   {
>   	/*
> -	 * Huge pages are NOT write protected when we start dirty logging in
> -	 * initially-all-set mode; must write protect them here so that they
> -	 * are split to 4K on the first write.
> +	 * If the slot was assumed to be "initially all dirty", write-protect
> +	 * huge pages to ensure they are split to 4KiB on the first write (KVM
> +	 * dirty logs at 4KiB granularity). If eager page splitting is enabled,
> +	 * immediately try to split huge pages, e.g. so that vCPUs don't get
> +	 * saddled with the cost of splitting.
>   	 *
>   	 * The gfn_offset is guaranteed to be aligned to 64, but the base_gfn
>   	 * of memslot has no such restriction, so the range can cross two large
> @@ -1411,7 +1384,16 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
>   						       PG_LEVEL_2M);
>   	}
>   
> -	/* Now handle 4K PTEs.  */
> +	/*
> +	 * (Re)Enable dirty logging for all 4KiB SPTEs that map the GFNs in
> +	 * mask.  If PML is enabled and the and the GFN doesn't need to be
> +	 * write-protected for other reasons, e.g. shadow paging, clear the
> +	 * Dirty bit.  Otherwise clear the Writable bit.
> +	 *
> +	 * Note that kvm_mmu_clear_dirty_pt_masked() is called whenever PML is
> +	 * enabled but it chooses between clearing the Dirty bit and Writeable
> +	 * bit based on the context.
> +	 */
>   	if (kvm_x86_ops.cpu_dirty_log_size)
>   		kvm_mmu_clear_dirty_pt_masked(kvm, slot, gfn_offset, mask);
>   	else

Thanks for fixing this comment. Indeed it required to look a bit in code 
if the condition means, PML is enabled, I faced this as well.

Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>


> 
> base-commit: 332d2c1d713e232e163386c35a3ba0c1b90df83f


