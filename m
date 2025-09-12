Return-Path: <kvm+bounces-57421-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D0E2B5541E
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 17:49:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 65ABDAE4FC7
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 15:49:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF49A266560;
	Fri, 12 Sep 2025 15:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="PXzP+ZBH"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2043.outbound.protection.outlook.com [40.107.93.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5BB9247281;
	Fri, 12 Sep 2025 15:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757692149; cv=fail; b=akikFL1T3xAPJMFDrev5muhgSLPRAtf0H+KCY6fjW3ekJ+LOpMQVTSwi7EmsdmecrUteyQXPoi/zKRHn78g6GPt1TIezJ5ZRapp6IAE0+V8KecQiSoulPB16Mcv1FMF+qRHnYnIXcsmdXjjSoiOjkJjhx63cob8LdVgDMgOJxss=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757692149; c=relaxed/simple;
	bh=W34LS5/mn2ZAk1wxfLaXMVbO/C5iPvcE+WqVm62M4cU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hu6ztd/hpk/x0ZGEyW9YLkoeH1N56zpNf6/vzYC0WoGF8rrheHcrbLG/KwRxCXOzeTif/89F/rYCCs2SRzJ3vbpC0f7S4gsdIRBVFo3Cb80CmLS/fDOUmt2x0vWZMEZgVZfZrWv3fIOo9PGWIXr+9pW4Xm0iMPJAyG0KYRJxdcc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=PXzP+ZBH; arc=fail smtp.client-ip=40.107.93.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IgdoMaB3FTEVOjouMQS5Y3k8XU8m+aB2k/BQkIIqBebjmxHkBHWDq060ka7j/ksPUr5XYMf6bQXxodfxFnxdsxXlUTEK30wqW6ew9nX69jRHev9+m+n0PADmv6Y1lmRrYFI3gZeEE8uk9hoiCYkPwuGvMCliIxUWF2HpuBV+JtK5f+f36Enw2YUPJ0tNmd5aMmOrdSe7NJU05HQJmUBiylR0m3HOl2IF+kaNJzHhiWaQgq0xv0/6owoSQqSZ1f6P6q2V07JR85C1RnW/FuccYHkzqPGsuTuwAIVtJeYvN9rOU5pVguqamSZHNOLNyeh7nqKlG6RwjkX5UacNtAmH6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EbtGH/5Bi/ucZW6eL+zTRB+vBHe1xOzlGMU9mQWvEzU=;
 b=xDyHMqtbW7p0k5TGKIKgp47xkPqIAE6Bz0/XNEKgeLWfSqNyeFnfHdHomo/G7Xezz82Gg9JYkO73ECkpRx/EDZ9jvYLkY4p3NhLT7UaacMz4zcV3xdQlgYqhANKzPJU2gfuLi5lNkjJ1cr3Krl3mmhd0keKsIAG15MxuohgsVgyV94jJPawrR3H2gxxv0j7ATS1KYwsuJznRoXKX9Jty01AXcOhHSr4jRPh9VJeVaxBAZ0YV3ZYRQX8DOR51JPc4a35txjO/5WnOaz7QextYSTxs8q7O/tVenSvegmDTSF5m94ReOrBrKCVTTz45VFC94BCDMdzLVPikPeqyhX8Mmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EbtGH/5Bi/ucZW6eL+zTRB+vBHe1xOzlGMU9mQWvEzU=;
 b=PXzP+ZBHsdSCBoO+z+tJtY1PHWX4BVBlZ2qszfTrqSxvjYVk672PYVKBbf2YZ3Kb1zvHraMWVMhyHYUa/sovwwX0uVjosTHwoDhHHs+6hXZi/4nt6wYcGtYpFlVrttyCGNz+iLMUoupA8gi7kBSwMirhE6UKeYkPP8BvpscLQyo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5062.namprd12.prod.outlook.com (2603:10b6:208:313::6)
 by BL1PR12MB5804.namprd12.prod.outlook.com (2603:10b6:208:394::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.18; Fri, 12 Sep
 2025 15:49:03 +0000
Received: from BL1PR12MB5062.namprd12.prod.outlook.com
 ([fe80::fe03:ef1f:3fee:9d4a]) by BL1PR12MB5062.namprd12.prod.outlook.com
 ([fe80::fe03:ef1f:3fee:9d4a%7]) with mapi id 15.20.9094.021; Fri, 12 Sep 2025
 15:49:03 +0000
Message-ID: <2b099228-56d1-4092-9626-6aecd7ace9d0@amd.com>
Date: Fri, 12 Sep 2025 10:49:00 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/3] crypto: ccp - Add AMD Seamless Firmware Servicing
 (SFS) driver
To: Ashish Kalra <Ashish.Kalra@amd.com>, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
 hpa@zytor.com, seanjc@google.com, pbonzini@redhat.com,
 herbert@gondor.apana.org.au
Cc: nikunj@amd.com, davem@davemloft.net, aik@amd.com, ardb@kernel.org,
 john.allen@amd.com, michael.roth@amd.com, Neeraj.Upadhyay@amd.com,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-crypto@vger.kernel.org
References: <cover.1757543774.git.ashish.kalra@amd.com>
 <7be1accd4c0968fe04d6efe6ebb0185d77bed129.1757543774.git.ashish.kalra@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 vFkWitqCJg==
In-Reply-To: <7be1accd4c0968fe04d6efe6ebb0185d77bed129.1757543774.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR08CA0023.namprd08.prod.outlook.com
 (2603:10b6:5:80::36) To BL1PR12MB5062.namprd12.prod.outlook.com
 (2603:10b6:208:313::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5062:EE_|BL1PR12MB5804:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c05ac37-5527-4f66-7f40-08ddf213e5bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U0ZUVGdRcmN6MHE3N2RCcWJxVEdnclYxWTY5emxxN0dtVnhtcklLZHJTUVdF?=
 =?utf-8?B?c2dGYWQ1SEtEU3dKK3FLVTZYWVVsZWtOOEk4aGhEcm9Ua2ZwaVVPZzRXYjdH?=
 =?utf-8?B?U0RmTk92akk4ZTdyeFI2NjlUZGRDeEJBQkFxNGZuU044Z3BkbmJYWC9GQXRZ?=
 =?utf-8?B?eEEzVkF1b2xwNWtxaG44bUk4KzV5aDFERlNxTlhQRzJwVzl6QlNTdXdyYTNx?=
 =?utf-8?B?N3RMdW5lRU9Wc2lGckRsVCtIT2RFOFZoZDZCSGkvNmhjOU1YUndUcENzM3Rn?=
 =?utf-8?B?TUhKNTNlMThSa2pCUDBMeDRMbWc0OUlxSUZnbHlsL211eG9RaGdqdkMzV05i?=
 =?utf-8?B?MDNuS0EzZVJwR013ZUM1VlBxbStQRVNBQTMzbWxGZFVKQjNGTjlDRjFWb0g5?=
 =?utf-8?B?Vi9rcFRrY1BIUUF2MUVQL0dWVXNtL0wxYlhFOXp0U29vNXR4ZjRadnJSQmRR?=
 =?utf-8?B?MnpTME1MU3ExbmVYdWUxMWY1R0UwdFllclJ3NnU1MWlycUV6Q1BsT2RlWk0z?=
 =?utf-8?B?NS9leXBQazFtZ0RlY1hrVTZmeUlMSG1McEtHckJsL3EwK016WklsTC9Vc3g2?=
 =?utf-8?B?OU1xTzlHS0hwQ3o0UnJyNDRDcmREVUVRNUl3MW94d212cS9sWExXQjkvc1JO?=
 =?utf-8?B?V0RYbjRsMkl0QW9udHM2NjAwL2owK1Q5dWF5aDZMTGRhdFdzMC95bHRmQTZQ?=
 =?utf-8?B?VWlrV1hvbHRYclJ5Wkt4MG9ySldKQ0pxNHBUdFJKeXJRTlFsRUxTUUdWckQ0?=
 =?utf-8?B?MFJkSm56L1VRZWFhSDFTVnplOFZDUWJzbjIvL29IWm5oOFJabTdqT2JicHJk?=
 =?utf-8?B?akZHanFVWEx3dXNmYXpqeGVXNkt5dVFrTVM3TnpFeFJrUjlZR0h1N29WN0lj?=
 =?utf-8?B?RGxSa2V5aHVGTHBXbzVHMUJtQjRHREZwU1ZGOVF2cW9sUWVIV2RVaHpUQkNR?=
 =?utf-8?B?UWxzUTdseUwrbmViTWZESVNoRXRxZGR1aHhOSCt2czdEYUlpUGp4NlRMOHo5?=
 =?utf-8?B?TnN2UXZHWklUbHZOcGNxNVFLL3U0YjExMEhIS3JMaFpCd29Qb2ZmY3BuTkhX?=
 =?utf-8?B?WElmZ053NVNXWUJRb0ZiTERqS0dRc2U5NmJncHRFc0U5YjFMb3czZ2plaEph?=
 =?utf-8?B?K2RoU0cvdWNzZFJadmFkaGlTZ1JKNGZuZ29XZEVuQzlSMG9HbmhVUytvM3JX?=
 =?utf-8?B?ME00TXQ5djZ2QjFhV1Y0OUE5L09oM2RBc2tsNExTQi9SMlVKanZCM0N0MDFt?=
 =?utf-8?B?blNGcGJUczBkb0JYSnNpMFlxdUU4M25vME9lcmJic2lDU2dnTE9qRlZlUjIv?=
 =?utf-8?B?V2NWcGpZQVlnYzd1dUM1RTFBSy8wRlFHTGMzUk8rUEg2TU1JUk44dFFLdlk3?=
 =?utf-8?B?OHJvYUpMa0tPbGp4bkN0dnVaYjMyRnZ0R0h6ZEZIZm5VdXhNODlVZU9UWmRG?=
 =?utf-8?B?clFuT09FTUx6S3QwdFNySnZCUy90QTF5NmVzdVUramJJNTZSNVE1YThzZUxl?=
 =?utf-8?B?bzBuTkU3cjJ0RVF4VGFTTngvQ0pyRUw5cjd3UjhTWHRPWlZnWXM5bGZNaEcz?=
 =?utf-8?B?MHlCTzFNeGxNQVovQnc3M3p6bEZDUG1NZE50d2dXc21scnIzNlAwYVZGQ3RK?=
 =?utf-8?B?bzVyR2Zxejl6TFhMNFVlTndpSnh1RGFNTnJiYVR5a0VYZmh3Tmd1N0RMMDIw?=
 =?utf-8?B?eTFUYmc2dXdDKzNKU1pBVVY0b2loc3ZBeUFYZGVZOWhnSVJRSkdYdUx0MW5h?=
 =?utf-8?B?bGVWRW84aTJFNW01dDRTemxNblpNWnd1aFFDckZweXExY2NSUFUzUDRoSlll?=
 =?utf-8?B?ekhha2lJWnp1ZUxHOERsWlJlT3NsWjdpLzFnNk8zOWE4aGVuTURFdW9ySDB6?=
 =?utf-8?B?ZmxkallXR1psa3VLZllVVDN6VTRkR3FvbkhoV1JTVnI0SXFPZEYyWmxiako4?=
 =?utf-8?B?MUhDeUJIZ1Q0bHlGZkZXeG44dUN4UXA4VFJldFJ2UUFKSmJhRGdjby9OeW1R?=
 =?utf-8?B?MmczV3VGWEl3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5062.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a3hpZXlhWnpUenlZN1JjRWtpblNMWHZmeHpvRmYvalVEVzI3TXF5TENCUGFO?=
 =?utf-8?B?Sk9PeTJQQjB4YTFTc3ZydjVURHN0UFhIWkp1dGlqU1Jja1VYY0ZQeGt0OUNK?=
 =?utf-8?B?cnNoT2tEelJMVTdWZENjNDRVakdIMktmTTVKN1pWVGtGdjNjWnZmaVJDRXVO?=
 =?utf-8?B?U3FFMGJkdWdVajZXY09KVGNJNlh3MmxPMitUYnQza0JxL2UrWm03QWJRbTlr?=
 =?utf-8?B?QzRQUXlxN3VlMkt4VjJCQkhkaHd2a2MzenNTY0ZwS0xyQmhZanlGZkpGb0kr?=
 =?utf-8?B?TmJuaGxqREEwSUFvKzBYVWVUZFp2SGN5bzVwRSsydTMxbWRTTitxUUJNT3Bq?=
 =?utf-8?B?YThQUHIyUGRDdEFwSTFVSlZPSndscWx0WkF2SGl3OVJCdmVrenZwMzNNZEor?=
 =?utf-8?B?ejVhTFlIVGFNa1BsNXJkdlpkMUhMVmRFQWluN2RLRDNmQmx0Y0F0MENRcFdH?=
 =?utf-8?B?VVUyeE95U3BMT1ZjWFVEb3RsS2FVekxYeUlHRVdWNklQeE5rVm9ET3ZvZGpB?=
 =?utf-8?B?WUlleWpIaXJUL01ibDh3N0VCRnkrdmoxenk0bzQrWDE1V2NqRU5FSGZyVnpK?=
 =?utf-8?B?Skc1cXFvYk5uODZjSmFPU1FhQk1OMWErMkVNN0lSRzEwK0NqaTcyYUNadFBI?=
 =?utf-8?B?ZUROQVppeWpXenFyc3BwamhKMG1sOHJoRW90UDR5MWRNREFOdll4enl0bjNQ?=
 =?utf-8?B?QjBWNkI5dUZjdmVibk5LTE4zd2FqSTdIMG11UGt5QWJOcldIUGhFUTBMTnNR?=
 =?utf-8?B?R04xd1ZhVVBoMkQxWVQzZktYSVNaRFlwSU9xc0Ztc1dTSTJhTk9qVzdyUGRI?=
 =?utf-8?B?NUlIbEttZHY3dDFGcGs5N0l1MCtSZ2NacWxKTVhjTzBIRElKTjR4QW9sN3Ry?=
 =?utf-8?B?dTZscEZ3Nnp1U2hVeUEwSXhjdDE1Wm9OTmhOZkpNTU1CVzNYbGxKR1VWYm5I?=
 =?utf-8?B?NHViamFKZmxNWnV6bTdwaDlUT0hVeFRXTEJnZUZBaWcxbElJSmlaUlNZUDM4?=
 =?utf-8?B?N3UveEhJRHlzVmFSNFREcDRVVmJxQm41Q0dwU2hkMkNMWkdIeHJRYXhKMjhn?=
 =?utf-8?B?WkhHMXhDbXFaMERrQzk5RXhJRVplMkFtcjVPMUVJUVhtMmVxaFhxYk9UeWFx?=
 =?utf-8?B?anJSb25NcE11MmkwOUpNdVBwTGUydjBEUzZKRGFOdFMrOGxEWWhlRDl5K01l?=
 =?utf-8?B?V0czMlBFWCs0ZXdNSGRoYTdscElVVUNVQ2NHMnBhNnA0ejMwZFpTWkNZVlRl?=
 =?utf-8?B?M0psQjdvMkVlS3pMTUtLU1NldkRKd1Vwd014NkdyYWpubzZnNGxNMHdhbUFI?=
 =?utf-8?B?bGU1MEV4ZHNHMG1vcnhnVVYzeHhQQ25qM0labWhwVDlDSWlGdk5oeHkvQU1F?=
 =?utf-8?B?WnVnM2dlNWVYWjZoellSMjhhRjRNbXgvbWVwQnhyM1hXaWpicDU4b0MxcjUx?=
 =?utf-8?B?UEN2Mmt6SFVSbjRDa0hycEtKMFVTVWhMRDZqMHJXS3RIeEtQVndRRjhMKzhk?=
 =?utf-8?B?MGs2aHNTR0pid29qL21peVYwSGVZd3NTdXVLeTdVSk1tWjBYU3lUOXhOWERj?=
 =?utf-8?B?TFNBVlNNSHA5WHdhcGRSK2NUWlJxeFZPMm85VlFOQzBacnhPOElvb21jVU1V?=
 =?utf-8?B?Q21NTnFBVnlmODYwS0lUeU1kNmhmMkVUZk1Pa2cyUEtqc3lwMWdTQ2RmeFZV?=
 =?utf-8?B?UGlia3hMTUJ3NGkvMThsSnF1QzljY1F4akJMNDJXRkdkb2Rpdi85dzZmUlkz?=
 =?utf-8?B?OHNWbkxpNmxqMVJNeFN3NmcrS1RKUS9YNUxOTExmbXJqVm44NTJ1M0J6VWhX?=
 =?utf-8?B?ckg4UmxHbVNlRFpNaE9wK3VKZFBzUy8zWkVRQVJRNUNHZW5CaXEvVjRYRjlO?=
 =?utf-8?B?Zm5kbU5TUUM0Zlh2TTdyUGc4RlZmZXMxUFlwZU9xMDZLR3B0RHFMTFBJbm16?=
 =?utf-8?B?YnFqVFQyVzRBUVlxQ3BTZityVUcxTkpEaXMxbE1nYVluZzhtZXA4ZlBjb1lV?=
 =?utf-8?B?S0hZY3JtaWFROHZaQmtHTWV0VEZ3TzV4bHhBdy9ReXBDYjhsZUVKREdsUk1p?=
 =?utf-8?B?WlV0a2pvQmJ5VEpNaW0rN0laUW5kKzdodFM2TGt4OGFNc3lpK0VVMENmeTNT?=
 =?utf-8?Q?T04jKsBc0bwpLKatlF74RDKZ/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c05ac37-5527-4f66-7f40-08ddf213e5bc
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5062.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2025 15:49:03.1482
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jQF7Pq0XfdbEPhOSotawajwmA2LQVR9Q1uF031buRR9rEIeyQxaRV0YbOT1NDoen129c+oSzZdU4ZeAA00tWcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5804

On 9/10/25 17:55, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> AMD Seamless Firmware Servicing (SFS) is a secure method to allow
> non-persistent updates to running firmware and settings without
> requiring BIOS reflash and/or system reset.
> 
> SFS does not address anything that runs on the x86 processors and
> it can be used to update ASP firmware, modules, register settings
> and update firmware for other microprocessors like TMPM, etc.
> 
> SFS driver support adds ioctl support to communicate the SFS
> commands to the ASP/PSP by using the TEE mailbox interface.
> 
> The Seamless Firmware Servicing (SFS) driver is added as a
> PSP sub-device.
> 
> For detailed information, please look at the SFS specifications:
> https://www.amd.com/content/dam/amd/en/documents/epyc-technical-docs/specifications/58604.pdf
> 
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>

With the comments below addressed:

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  drivers/crypto/ccp/Makefile         |   3 +-
>  drivers/crypto/ccp/psp-dev.c        |  20 ++
>  drivers/crypto/ccp/psp-dev.h        |   8 +-
>  drivers/crypto/ccp/sfs.c            | 310 ++++++++++++++++++++++++++++
>  drivers/crypto/ccp/sfs.h            |  47 +++++
>  include/linux/psp-platform-access.h |   2 +
>  include/uapi/linux/psp-sfs.h        |  87 ++++++++
>  7 files changed, 475 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/crypto/ccp/sfs.c
>  create mode 100644 drivers/crypto/ccp/sfs.h
>  create mode 100644 include/uapi/linux/psp-sfs.h
> 
> diff --git a/drivers/crypto/ccp/Makefile b/drivers/crypto/ccp/Makefile
> index 394484929dae..a9626b30044a 100644
> --- a/drivers/crypto/ccp/Makefile
> +++ b/drivers/crypto/ccp/Makefile
> @@ -13,7 +13,8 @@ ccp-$(CONFIG_CRYPTO_DEV_SP_PSP) += psp-dev.o \
>                                     tee-dev.o \
>                                     platform-access.o \
>                                     dbc.o \
> -                                   hsti.o
> +                                   hsti.o \
> +                                   sfs.o
>  
>  obj-$(CONFIG_CRYPTO_DEV_CCP_CRYPTO) += ccp-crypto.o
>  ccp-crypto-objs := ccp-crypto-main.o \
> diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
> index 1c5a7189631e..9e21da0e298a 100644
> --- a/drivers/crypto/ccp/psp-dev.c
> +++ b/drivers/crypto/ccp/psp-dev.c
> @@ -17,6 +17,7 @@
>  #include "psp-dev.h"
>  #include "sev-dev.h"
>  #include "tee-dev.h"
> +#include "sfs.h"
>  #include "platform-access.h"
>  #include "dbc.h"
>  #include "hsti.h"
> @@ -182,6 +183,17 @@ static int psp_check_tee_support(struct psp_device *psp)
>  	return 0;
>  }
>  
> +static int psp_check_sfs_support(struct psp_device *psp)
> +{
> +	/* Check if device supports SFS feature */
> +	if (!psp->capability.sfs) {
> +		dev_dbg(psp->dev, "psp does not support SFS\n");
> +		return -ENODEV;
> +	}
> +
> +	return 0;
> +}
> +
>  static int psp_init(struct psp_device *psp)
>  {
>  	int ret;
> @@ -198,6 +210,12 @@ static int psp_init(struct psp_device *psp)
>  			return ret;
>  	}
>  
> +	if (!psp_check_sfs_support(psp)) {
> +		ret = sfs_dev_init(psp);
> +		if (ret)
> +			return ret;
> +	}
> +
>  	if (psp->vdata->platform_access) {
>  		ret = platform_access_dev_init(psp);
>  		if (ret)
> @@ -302,6 +320,8 @@ void psp_dev_destroy(struct sp_device *sp)
>  
>  	tee_dev_destroy(psp);
>  
> +	sfs_dev_destroy(psp);
> +
>  	dbc_dev_destroy(psp);
>  
>  	platform_access_dev_destroy(psp);
> diff --git a/drivers/crypto/ccp/psp-dev.h b/drivers/crypto/ccp/psp-dev.h
> index e43ce87ede76..268c83f298cb 100644
> --- a/drivers/crypto/ccp/psp-dev.h
> +++ b/drivers/crypto/ccp/psp-dev.h
> @@ -32,7 +32,8 @@ union psp_cap_register {
>  		unsigned int sev			:1,
>  			     tee			:1,
>  			     dbc_thru_ext		:1,
> -			     rsvd1			:4,
> +			     sfs			:1,
> +			     rsvd1			:3,
>  			     security_reporting		:1,
>  			     fused_part			:1,
>  			     rsvd2			:1,
> @@ -68,6 +69,7 @@ struct psp_device {
>  	void *tee_data;
>  	void *platform_access_data;
>  	void *dbc_data;
> +	void *sfs_data;
>  
>  	union psp_cap_register capability;
>  };
> @@ -118,12 +120,16 @@ struct psp_ext_request {
>   * @PSP_SUB_CMD_DBC_SET_UID:		Set UID for DBC
>   * @PSP_SUB_CMD_DBC_GET_PARAMETER:	Get parameter from DBC
>   * @PSP_SUB_CMD_DBC_SET_PARAMETER:	Set parameter for DBC
> + * @PSP_SUB_CMD_SFS_GET_FW_VERS:	Get firmware versions for ASP and other MP
> + * @PSP_SUB_CMD_SFS_UPDATE:		Command to load, verify and execute SFS package
>   */
>  enum psp_sub_cmd {
>  	PSP_SUB_CMD_DBC_GET_NONCE	= PSP_DYNAMIC_BOOST_GET_NONCE,
>  	PSP_SUB_CMD_DBC_SET_UID		= PSP_DYNAMIC_BOOST_SET_UID,
>  	PSP_SUB_CMD_DBC_GET_PARAMETER	= PSP_DYNAMIC_BOOST_GET_PARAMETER,
>  	PSP_SUB_CMD_DBC_SET_PARAMETER	= PSP_DYNAMIC_BOOST_SET_PARAMETER,
> +	PSP_SUB_CMD_SFS_GET_FW_VERS	= PSP_SFS_GET_FW_VERSIONS,
> +	PSP_SUB_CMD_SFS_UPDATE		= PSP_SFS_UPDATE,
>  };
>  
>  int psp_extended_mailbox_cmd(struct psp_device *psp, unsigned int timeout_msecs,
> diff --git a/drivers/crypto/ccp/sfs.c b/drivers/crypto/ccp/sfs.c
> new file mode 100644
> index 000000000000..d56412f24669
> --- /dev/null
> +++ b/drivers/crypto/ccp/sfs.c
> @@ -0,0 +1,310 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * AMD Secure Processor Seamless Firmware Servicing support.
> + *
> + * Copyright (C) 2025 Advanced Micro Devices, Inc.
> + *
> + * Author: Ashish Kalra <ashish.kalra@amd.com>
> + */
> +
> +#include <linux/firmware.h>
> +
> +#include "sfs.h"
> +#include "sev-dev.h"
> +
> +#define SFS_DEFAULT_TIMEOUT		(10 * MSEC_PER_SEC)
> +#define SFS_MAX_PAYLOAD_SIZE		(2 * 1024 * 1024)
> +#define SFS_NUM_2MB_PAGES_CMDBUF	(SFS_MAX_PAYLOAD_SIZE / PMD_SIZE)
> +#define SFS_NUM_PAGES_CMDBUF		(SFS_MAX_PAYLOAD_SIZE / PAGE_SIZE)
> +
> +static DEFINE_MUTEX(sfs_ioctl_mutex);
> +
> +static struct sfs_misc_dev *misc_dev;
> +
> +static int send_sfs_cmd(struct sfs_device *sfs_dev, int msg)
> +{
> +	int ret;
> +
> +	sfs_dev->command_buf->hdr.status = 0;
> +	sfs_dev->command_buf->hdr.sub_cmd_id = msg;
> +
> +	ret = psp_extended_mailbox_cmd(sfs_dev->psp,
> +				       SFS_DEFAULT_TIMEOUT,
> +				       (struct psp_ext_request *)sfs_dev->command_buf);
> +	if (ret == -EIO) {
> +		dev_dbg(sfs_dev->dev,
> +			 "msg 0x%x failed with PSP error: 0x%x, extended status: 0x%x\n",
> +			 msg, sfs_dev->command_buf->hdr.status,
> +			 *(u32 *)sfs_dev->command_buf->buf);
> +	}
> +
> +	return ret;
> +}
> +
> +static int send_sfs_get_fw_versions(struct sfs_device *sfs_dev)
> +{
> +	/*
> +	 * SFS_GET_FW_VERSIONS command needs the output buffer to be
> +	 * initialized to 0xC7 in every byte.
> +	 */
> +	memset(sfs_dev->command_buf->sfs_buffer, 0xc7, PAGE_SIZE);
> +	sfs_dev->command_buf->hdr.payload_size = 2 * PAGE_SIZE;
> +
> +	return send_sfs_cmd(sfs_dev, PSP_SFS_GET_FW_VERSIONS);
> +}
> +
> +static int send_sfs_update_package(struct sfs_device *sfs_dev, const char *payload_name)
> +{
> +	char payload_path[PAYLOAD_NAME_SIZE + sizeof("amd/")];
> +	const struct firmware *firmware;
> +	unsigned long package_size;
> +	int ret;
> +
> +	/* Sanitize userspace provided payload name */
> +	if (!strnchr(payload_name, PAYLOAD_NAME_SIZE, '\0'))
> +		return -EINVAL;
> +
> +	snprintf(payload_path, sizeof(payload_path), "amd/%s", payload_name);
> +
> +	ret = firmware_request_nowarn(&firmware, payload_path, sfs_dev->dev);
> +	if (ret < 0) {
> +		dev_warn(sfs_dev->dev, "firmware request fail %d\n", ret);

This should include the filename, something like:

	"firmware request failed for %s (%d)\n", ...

Also, since this is a userspace request, this and all other messages
possible through the ioctl() should be ratelimited, i.e.,
dev_warn_ratelimited().

Thanks,
Tom

> +		return -ENOENT;
> +	}
> +
> +	/*
> +	 * SFS Update Package command's input buffer contains TEE_EXT_CMD_BUFFER
> +	 * followed by the Update Package and it should be 64KB aligned.
> +	 */
> +	package_size = ALIGN(firmware->size + PAGE_SIZE, 0x10000U);
> +
> +	/*
> +	 * SFS command buffer is a pre-allocated 2MB buffer, fail update package
> +	 * if SFS payload is larger than the pre-allocated command buffer.
> +	 */
> +	if (package_size > SFS_MAX_PAYLOAD_SIZE) {
> +		dev_warn(sfs_dev->dev,
> +			 "SFS payload size %ld larger than maximum supported payload size of %u\n",
> +			 package_size, SFS_MAX_PAYLOAD_SIZE);
> +		release_firmware(firmware);
> +		return -E2BIG;
> +	}
> +
> +	/*
> +	 * Copy firmware data to a HV_Fixed memory region.
> +	 */
> +	memcpy(sfs_dev->command_buf->sfs_buffer, firmware->data, firmware->size);
> +	sfs_dev->command_buf->hdr.payload_size = package_size;
> +
> +	release_firmware(firmware);
> +
> +	return send_sfs_cmd(sfs_dev, PSP_SFS_UPDATE);
> +}
> +
> +static long sfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
> +{
> +	struct sfs_user_get_fw_versions __user *sfs_get_fw_versions;
> +	struct sfs_user_update_package __user *sfs_update_package;
> +	struct psp_device *psp_master = psp_get_master_device();
> +	char payload_name[PAYLOAD_NAME_SIZE];
> +	struct sfs_device *sfs_dev;
> +	int ret = 0;
> +
> +	if (!psp_master || !psp_master->sfs_data)
> +		return -ENODEV;
> +
> +	sfs_dev = psp_master->sfs_data;
> +
> +	guard(mutex)(&sfs_ioctl_mutex);
> +
> +	switch (cmd) {
> +	case SFSIOCFWVERS:
> +		dev_dbg(sfs_dev->dev, "in SFSIOCFWVERS\n");
> +
> +		sfs_get_fw_versions = (struct sfs_user_get_fw_versions __user *)arg;
> +
> +		ret = send_sfs_get_fw_versions(sfs_dev);
> +		if (ret && ret != -EIO)
> +			return ret;
> +
> +		/*
> +		 * Return SFS status and extended status back to userspace
> +		 * if PSP status indicated success or command error.
> +		 */
> +		if (copy_to_user(&sfs_get_fw_versions->blob, sfs_dev->command_buf->sfs_buffer,
> +				 PAGE_SIZE))
> +			return -EFAULT;
> +		if (copy_to_user(&sfs_get_fw_versions->sfs_status,
> +				 &sfs_dev->command_buf->hdr.status,
> +				 sizeof(sfs_get_fw_versions->sfs_status)))
> +			return -EFAULT;
> +		if (copy_to_user(&sfs_get_fw_versions->sfs_extended_status,
> +				 &sfs_dev->command_buf->buf,
> +				 sizeof(sfs_get_fw_versions->sfs_extended_status)))
> +			return -EFAULT;
> +		break;
> +	case SFSIOCUPDATEPKG:
> +		dev_dbg(sfs_dev->dev, "in SFSIOCUPDATEPKG\n");
> +
> +		sfs_update_package = (struct sfs_user_update_package __user *)arg;
> +
> +		if (copy_from_user(payload_name, sfs_update_package->payload_name,
> +				   PAYLOAD_NAME_SIZE))
> +			return -EFAULT;
> +
> +		ret = send_sfs_update_package(sfs_dev, payload_name);
> +		if (ret && ret != -EIO)
> +			return ret;
> +
> +		/*
> +		 * Return SFS status and extended status back to userspace
> +		 * if PSP status indicated success or command error.
> +		 */
> +		if (copy_to_user(&sfs_update_package->sfs_status,
> +				 &sfs_dev->command_buf->hdr.status,
> +				 sizeof(sfs_update_package->sfs_status)))
> +			return -EFAULT;
> +		if (copy_to_user(&sfs_update_package->sfs_extended_status,
> +				 &sfs_dev->command_buf->buf,
> +				 sizeof(sfs_update_package->sfs_extended_status)))
> +			return -EFAULT;
> +		break;
> +	default:
> +		ret = -EINVAL;
> +	}
> +
> +	return ret;
> +}
> +
> +static const struct file_operations sfs_fops = {
> +	.owner	= THIS_MODULE,
> +	.unlocked_ioctl = sfs_ioctl,
> +};
> +
> +static void sfs_exit(struct kref *ref)
> +{
> +	misc_deregister(&misc_dev->misc);
> +	kfree(misc_dev);
> +	misc_dev = NULL;
> +}
> +
> +void sfs_dev_destroy(struct psp_device *psp)
> +{
> +	struct sfs_device *sfs_dev = psp->sfs_data;
> +
> +	if (!sfs_dev)
> +		return;
> +
> +	/*
> +	 * Change SFS command buffer back to the default "Write-Back" type.
> +	 */
> +	set_memory_wb((unsigned long)sfs_dev->command_buf, SFS_NUM_PAGES_CMDBUF);
> +
> +	snp_free_hv_fixed_pages(sfs_dev->page);
> +
> +	if (sfs_dev->misc)
> +		kref_put(&misc_dev->refcount, sfs_exit);
> +
> +	psp->sfs_data = NULL;
> +}
> +
> +/* Based on sev_misc_init() */
> +static int sfs_misc_init(struct sfs_device *sfs)
> +{
> +	struct device *dev = sfs->dev;
> +	int ret;
> +
> +	/*
> +	 * SFS feature support can be detected on multiple devices but the SFS
> +	 * FW commands must be issued on the master. During probe, we do not
> +	 * know the master hence we create /dev/sfs on the first device probe.
> +	 */
> +	if (!misc_dev) {
> +		struct miscdevice *misc;
> +
> +		misc_dev = kzalloc(sizeof(*misc_dev), GFP_KERNEL);
> +		if (!misc_dev)
> +			return -ENOMEM;
> +
> +		misc = &misc_dev->misc;
> +		misc->minor = MISC_DYNAMIC_MINOR;
> +		misc->name = "sfs";
> +		misc->fops = &sfs_fops;
> +		misc->mode = 0600;
> +
> +		ret = misc_register(misc);
> +		if (ret)
> +			return ret;
> +
> +		kref_init(&misc_dev->refcount);
> +	} else {
> +		kref_get(&misc_dev->refcount);
> +	}
> +
> +	sfs->misc = misc_dev;
> +	dev_dbg(dev, "registered SFS device\n");
> +
> +	return 0;
> +}
> +
> +int sfs_dev_init(struct psp_device *psp)
> +{
> +	struct device *dev = psp->dev;
> +	struct sfs_device *sfs_dev;
> +	struct page *page;
> +	int ret = -ENOMEM;
> +
> +	sfs_dev = devm_kzalloc(dev, sizeof(*sfs_dev), GFP_KERNEL);
> +	if (!sfs_dev)
> +		return -ENOMEM;
> +
> +	/*
> +	 * Pre-allocate 2MB command buffer for all SFS commands using
> +	 * SNP HV_Fixed page allocator which also transitions the
> +	 * SFS command buffer to HV_Fixed page state if SNP is enabled.
> +	 */
> +	page = snp_alloc_hv_fixed_pages(SFS_NUM_2MB_PAGES_CMDBUF);
> +	if (!page) {
> +		dev_dbg(dev, "Command Buffer HV-Fixed page allocation failed\n");
> +		goto cleanup_dev;
> +	}
> +	sfs_dev->page = page;
> +	sfs_dev->command_buf = page_address(page);
> +
> +	dev_dbg(dev, "Command buffer 0x%px to be marked as HV_Fixed\n", sfs_dev->command_buf);
> +
> +	/*
> +	 * SFS command buffer must be mapped as non-cacheable.
> +	 */
> +	ret = set_memory_uc((unsigned long)sfs_dev->command_buf, SFS_NUM_PAGES_CMDBUF);
> +	if (ret) {
> +		dev_dbg(dev, "Set memory uc failed\n");
> +		goto cleanup_cmd_buf;
> +	}
> +
> +	dev_dbg(dev, "Command buffer 0x%px marked uncacheable\n", sfs_dev->command_buf);
> +
> +	psp->sfs_data = sfs_dev;
> +	sfs_dev->dev = dev;
> +	sfs_dev->psp = psp;
> +
> +	ret = sfs_misc_init(sfs_dev);
> +	if (ret)
> +		goto cleanup_mem_attr;
> +
> +	dev_notice(sfs_dev->dev, "SFS support is available\n");
> +
> +	return 0;
> +
> +cleanup_mem_attr:
> +	set_memory_wb((unsigned long)sfs_dev->command_buf, SFS_NUM_PAGES_CMDBUF);
> +
> +cleanup_cmd_buf:
> +	snp_free_hv_fixed_pages(page);
> +
> +cleanup_dev:
> +	psp->sfs_data = NULL;
> +	devm_kfree(dev, sfs_dev);
> +
> +	return ret;
> +}
> diff --git a/drivers/crypto/ccp/sfs.h b/drivers/crypto/ccp/sfs.h
> new file mode 100644
> index 000000000000..97704c210efd
> --- /dev/null
> +++ b/drivers/crypto/ccp/sfs.h
> @@ -0,0 +1,47 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * AMD Platform Security Processor (PSP) Seamless Firmware (SFS) Support.
> + *
> + * Copyright (C) 2025 Advanced Micro Devices, Inc.
> + *
> + * Author: Ashish Kalra <ashish.kalra@amd.com>
> + */
> +
> +#ifndef __SFS_H__
> +#define __SFS_H__
> +
> +#include <uapi/linux/psp-sfs.h>
> +
> +#include <linux/device.h>
> +#include <linux/miscdevice.h>
> +#include <linux/psp-sev.h>
> +#include <linux/psp-platform-access.h>
> +#include <linux/set_memory.h>
> +
> +#include "psp-dev.h"
> +
> +struct sfs_misc_dev {
> +	struct kref refcount;
> +	struct miscdevice misc;
> +};
> +
> +struct sfs_command {
> +	struct psp_ext_req_buffer_hdr hdr;
> +	u8 buf[PAGE_SIZE - sizeof(struct psp_ext_req_buffer_hdr)];
> +	u8 sfs_buffer[];
> +} __packed;
> +
> +struct sfs_device {
> +	struct device *dev;
> +	struct psp_device *psp;
> +
> +	struct page *page;
> +	struct sfs_command *command_buf;
> +
> +	struct sfs_misc_dev *misc;
> +};
> +
> +void sfs_dev_destroy(struct psp_device *psp);
> +int sfs_dev_init(struct psp_device *psp);
> +
> +#endif /* __SFS_H__ */
> diff --git a/include/linux/psp-platform-access.h b/include/linux/psp-platform-access.h
> index 1504fb012c05..540abf7de048 100644
> --- a/include/linux/psp-platform-access.h
> +++ b/include/linux/psp-platform-access.h
> @@ -7,6 +7,8 @@
>  
>  enum psp_platform_access_msg {
>  	PSP_CMD_NONE			= 0x0,
> +	PSP_SFS_GET_FW_VERSIONS,
> +	PSP_SFS_UPDATE,
>  	PSP_CMD_HSTI_QUERY		= 0x14,
>  	PSP_I2C_REQ_BUS_CMD		= 0x64,
>  	PSP_DYNAMIC_BOOST_GET_NONCE,
> diff --git a/include/uapi/linux/psp-sfs.h b/include/uapi/linux/psp-sfs.h
> new file mode 100644
> index 000000000000..94e51670383c
> --- /dev/null
> +++ b/include/uapi/linux/psp-sfs.h
> @@ -0,0 +1,87 @@
> +/* SPDX-License-Identifier: GPL-2.0-only WITH Linux-syscall-note */
> +/*
> + * Userspace interface for AMD Seamless Firmware Servicing (SFS)
> + *
> + * Copyright (C) 2025 Advanced Micro Devices, Inc.
> + *
> + * Author: Ashish Kalra <ashish.kalra@amd.com>
> + */
> +
> +#ifndef __PSP_SFS_USER_H__
> +#define __PSP_SFS_USER_H__
> +
> +#include <linux/types.h>
> +
> +/**
> + * SFS: AMD Seamless Firmware Support (SFS) interface
> + */
> +
> +#define PAYLOAD_NAME_SIZE	64
> +#define TEE_EXT_CMD_BUFFER_SIZE	4096
> +
> +/**
> + * struct sfs_user_get_fw_versions - get current level of base firmware (output).
> + * @blob:                  current level of base firmware for ASP and patch levels (input/output).
> + * @sfs_status:            32-bit SFS status value (output).
> + * @sfs_extended_status:   32-bit SFS extended status value (output).
> + */
> +struct sfs_user_get_fw_versions {
> +	__u8	blob[TEE_EXT_CMD_BUFFER_SIZE];
> +	__u32	sfs_status;
> +	__u32	sfs_extended_status;
> +} __packed;
> +
> +/**
> + * struct sfs_user_update_package - update SFS package (input).
> + * @payload_name:          name of SFS package to load, verify and execute (input).
> + * @sfs_status:            32-bit SFS status value (output).
> + * @sfs_extended_status:   32-bit SFS extended status value (output).
> + */
> +struct sfs_user_update_package {
> +	char	payload_name[PAYLOAD_NAME_SIZE];
> +	__u32	sfs_status;
> +	__u32	sfs_extended_status;
> +} __packed;
> +
> +/**
> + * Seamless Firmware Support (SFS) IOC
> + *
> + * possible return codes for all SFS IOCTLs:
> + *  0:          success
> + *  -EINVAL:    invalid input
> + *  -E2BIG:     excess data passed
> + *  -EFAULT:    failed to copy to/from userspace
> + *  -EBUSY:     mailbox in recovery or in use
> + *  -ENODEV:    driver not bound with PSP device
> + *  -EACCES:    request isn't authorized
> + *  -EINVAL:    invalid parameter
> + *  -ETIMEDOUT: request timed out
> + *  -EAGAIN:    invalid request for state machine
> + *  -ENOENT:    not implemented
> + *  -ENFILE:    overflow
> + *  -EPERM:     invalid signature
> + *  -EIO:       PSP I/O error
> + */
> +#define SFS_IOC_TYPE	'S'
> +
> +/**
> + * SFSIOCFWVERS - returns blob containing FW versions
> + *                ASP provides the current level of Base Firmware for the ASP
> + *                and the other microprocessors as well as current patch
> + *                level(s).
> + */
> +#define SFSIOCFWVERS	_IOWR(SFS_IOC_TYPE, 0x1, struct sfs_user_get_fw_versions)
> +
> +/**
> + * SFSIOCUPDATEPKG - updates package/payload
> + *                   ASP loads, verifies and executes the SFS package.
> + *                   By default, the SFS package/payload is loaded from
> + *                   /lib/firmware/amd, but alternative firmware loading
> + *                   path can be specified using kernel parameter
> + *                   firmware_class.path or the firmware loading path
> + *                   can be customized using sysfs file:
> + *                   /sys/module/firmware_class/parameters/path.
> + */
> +#define SFSIOCUPDATEPKG	_IOWR(SFS_IOC_TYPE, 0x2, struct sfs_user_update_package)
> +
> +#endif /* __PSP_SFS_USER_H__ */


