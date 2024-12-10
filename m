Return-Path: <kvm+bounces-33455-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 052419EBC2E
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 22:56:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 55287188AE60
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 21:56:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 748492397B9;
	Tue, 10 Dec 2024 21:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="AaIidlvp"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2062.outbound.protection.outlook.com [40.107.102.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 054D723ED78;
	Tue, 10 Dec 2024 21:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733867762; cv=fail; b=rpifr3xtQWX4pNCt2v9VDKtthkcoYcNIQvxTjWHC2Syl6HTqUAQh0PEZz41TNxoNFa+P8MbORbMu4skFCp3lbHLiVTf8U4AgCCoxjI6hQ3V3NjBDzMWcAh5xhZTZvP6+mfUaF88so4FnCCG/CjvUW61RSmXxYY5807SCCwug7jk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733867762; c=relaxed/simple;
	bh=7uE5XPPVunDnozq0hlBloV1XT2qX3zHiYHheV7cpbQQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=t39XlFug11aMiN2WVSnIKz/EOMWyWYp1AkEzC5d+NQtiebx4FoTzPZRmfUZ9o3ExRBK8aVvYUim6mY9VD5mJYrDGsJRWv74NV6ikPv0dCOJMgWEa8JzWedf8Catnz+l7L/jzMTuP+FLtV5ndUNexaYyNqqUTMH9gmG5//2Iw/iY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=AaIidlvp; arc=fail smtp.client-ip=40.107.102.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lCVffeLRvxwepG34EkiCLAPKMTnaBab9siVcWG3wJSgIQIzG93eoZBz33KOxf8h97gl/vjg+OXYfkNtQSzn1wsnIJlTVV+WueqsRuUJnro6usm67RUY5j/nMTafo5o2wWDcH7285CuHq/7ZR/kQuOeCK4cBQ7Wl5Frkd4pCR//N+t8iGrN8RvQDaJ9xDhhYmIRzq4JM1lIqyyYECrVtUSna7l/ekpaOghCROHgZwnAq5emrHTssBPrhjIC4kC5CL7keEfBrHEXfFezt5ab5A4SDVP5Xn8s/B5V7Su9dqTxMgoIf+rtT35dv/Q/hnOrfyR2fYG50G84QtVhzBepcc+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ozTjs2ChwAPSUQ3Kx47O/Siax8X9+Tq3he7dFRJx9Qs=;
 b=XHnNSDj5JF1xkn1lyX2Sbee9OIE5qjx/guYzC3ucZ4mJjX/TWRNmO8CUfRekY7yaU/bnv663Zl599zVY9CS+1CLUVSaU7bli1keSQ7HUD7PvaQCK5yfdZqqqVSjQRUB3/jg5khMvzN1+kIQOP3rkXjnlA7ESUJs1/L2fqhOj5fywaqsNffRrfN0ce6QeahtdwtSQ2icIHYsB//jc8cJr5pOYVGAjr3QnJz6/IZOxb5OH9ecBHZKQQbXuw8HHQZQK2keSdpWjMowo0Xi7iBkkG8f/HqEbu0b0AeUDst4Smr0WJ+ihSqj8QN0YI6mf+01JZ6gFu/vWbog260hJFFfHfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ozTjs2ChwAPSUQ3Kx47O/Siax8X9+Tq3he7dFRJx9Qs=;
 b=AaIidlvpcmDRLL7WzNW69vAv7ndqNeYrSpk4hZnHrqw0rEiGNGmswkUXUuZZK381xbxllblpPrmUlfC74jKLL4iOmj/fGeX72F4VTKUEMsHs+advthA+FPyixcACkFMR2HW1+7vgVhHMJgqHizJkux04MpIPv0B4FYOKD+IC/X0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by BL1PR12MB5873.namprd12.prod.outlook.com (2603:10b6:208:395::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.12; Tue, 10 Dec
 2024 21:55:56 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8230.010; Tue, 10 Dec 2024
 21:55:56 +0000
Message-ID: <0c20c9d1-fdd7-4f2b-73f6-990aaa84a235@amd.com>
Date: Tue, 10 Dec 2024 15:55:54 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 4/7] crypto: ccp: Register SNP panic notifier only if SNP
 is enabled
Content-Language: en-US
To: Ashish Kalra <Ashish.Kalra@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 john.allen@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net
Cc: michael.roth@amd.com, dionnaglaze@google.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-coco@lists.linux.dev
References: <cover.1733785468.git.ashish.kalra@amd.com>
 <cf956c36ee9f89a5273cbccd55e2ab50855d754f.1733785468.git.ashish.kalra@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <cf956c36ee9f89a5273cbccd55e2ab50855d754f.1733785468.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0087.namprd11.prod.outlook.com
 (2603:10b6:806:d2::32) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|BL1PR12MB5873:EE_
X-MS-Office365-Filtering-Correlation-Id: 7876a81d-f79e-4d37-b878-08dd19656c9a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cUhYS0MvODJUcE5Gb3d0eHptdFdEeUxkdDMxbm4wSTkzQWU3RmxPbWlMajZJ?=
 =?utf-8?B?YWlhbFp3N05DekxiNnppNVU1aUdnaU9xdFExenFQU1A0TkRGMFRBRzh5WXpX?=
 =?utf-8?B?M0ZpVktrZk8wQ2sybmJGZUZENzUrVlc1azczZHF1dTBhcmlnZ1pmN1ZxcmZE?=
 =?utf-8?B?OGowanFKTW5EU2pGSUNjcEp3dmpZYlQxN3VGTkZQVVQ2U1ZVRU9jMlVsNGxx?=
 =?utf-8?B?VUxiamZ4b1JURFdlZTJ3QW52eHVTMXZtdzlrc2V0ODF1TWUyeXFBeWcycFQv?=
 =?utf-8?B?WW5lUFN6MVptblBKT09MM1BzMkxEdkQxakI2dC9ZRVJjNzN5dEdIQXRMNTVl?=
 =?utf-8?B?dys3NUROZTBrZytMUktmUW0xR0EwRW4xd1JjVGhPU3FUMjhWcm9SNDN4Z3JC?=
 =?utf-8?B?QXlOU0Q0WlNCbVViQzVmbXhTUFBNV25BNmJRM0t5K1NhdGxqK0ZvSTNvUUNT?=
 =?utf-8?B?eE5xY3dZUDIyQVU2ZmpQVUJCdGs2RGJpd1RCMG5oMnBUQzRVK3l1UW5yanpj?=
 =?utf-8?B?NzdqeW1hT3B1NGhJSmp2OHdJQXM5UFdSK3J2N3BoYWs1cmRyWlduaDM3blRX?=
 =?utf-8?B?RHBYYkxDYS9HR2QyRTZZbmNTaWwvV3BsWTRMVUx5UHJpSkNVbHBDOGtjTm9w?=
 =?utf-8?B?RUNGbXl3K2cybXVuYXBxSXNPeE53MU8yR21Ud0RQVTYvcTI0cEU5QkdOVDlx?=
 =?utf-8?B?M0dKd0FISnBJbEZFNXVxczNtWkpGRUZVdnVNY0RjOTZlRngyTU5hWjRFZThN?=
 =?utf-8?B?UEpXQWRZdnZCa1JXbUxUY0I0TU9lZmxUa1JMOVJUbEtobEM5Q2VCQy82WFJs?=
 =?utf-8?B?TmVJYWlybWVUYWd6Zlhpd0JrMDdVbmN5dVNGRzkrK2N5U2JMZ1o1ZWtaRUhY?=
 =?utf-8?B?c0hhSEdwbmg2bFlxSnRHRlc2SUgvTkZDb1ZFeExhNzVlUHU3ZUlKaVV5QVIv?=
 =?utf-8?B?NUZsbUFsVHZCYU1ibUQ4S2x0M1h6V1pXNUc4NWVoMGpHNmw1ZWxjVXBwaW9m?=
 =?utf-8?B?c2NtVzhZcGNheXNVNmViNlRZQlBaS1BXRndCbEpVUTdXc3hmckJsNTJaMlpB?=
 =?utf-8?B?R3daQmFaNU9DZ2RFRTc2aUd3bjNOZkNtZlpjVW5TU1dRQTArR29UQlhZak82?=
 =?utf-8?B?UHJTQ043VHhSLzhhNmV2TWJsaW12dkMrV1UvQU9yd2g2YTdrdEFNVGtVQktT?=
 =?utf-8?B?NTdNb0dEczJxc3JRWUJYVGtQeTdhNEwzOXIyczM4TTVzb0t0MjBTMlJZOVJB?=
 =?utf-8?B?Nlg4YjZTdy9scUh6MzdZZHJjWlZHeDlHditFMXgvN2lseVBsWkJndzBwdmMw?=
 =?utf-8?B?bXoydHVhNnN0RFMweFFtMnVVejQ2RGhkWm90YldvV3NkZHJ0MDFXYkk4NDgr?=
 =?utf-8?B?aWt6anpHZHdwNVNhMDJ4VzBPTHJSUXloWk5DVTR3R0pjUGhNeCtRQTBoVmxx?=
 =?utf-8?B?TDg2S2xMQk0yTWZ0cGFER05lLzdDYUFsZEpUYVJ4UUVydkkrb01nWmtIMnBu?=
 =?utf-8?B?ZjREUDJPYWtwZVJaNjl0VU9Lcm9kMGJRc1MrK3ZVVVBaQWFjaHVrQ3oxT2tl?=
 =?utf-8?B?NXdmcVhMQlJaZlJqbTQxSWRGdkdvaThwVjBGcWtGdE91SUp4VWg2WTZjcHZI?=
 =?utf-8?B?d2pGcU9HcllJcmQwVS9RY2ZQb1doK2p3OU9XS2pGcUZ1QmlLdHVmeFk4R2Ex?=
 =?utf-8?B?a1NiTEtDZGtEeDBQZm9lL1VkRnVhWVZ4ZU1sWndISHJIZU82eXoyOXg4RDNW?=
 =?utf-8?B?OVFDYlozSWx6MFlVV1RHNlBWNEtvdWEzOUJVaHdZakQ3MXBGRnJzalAvdkUv?=
 =?utf-8?B?OXJmbXROMWVPT0VVS2kyalhjT1lsdkx3UzZiWTU1YU1DMmFuSXJVVjU2WWls?=
 =?utf-8?B?Z0pxUjB2MXVLM09hekxIVTRPUERiMVB3SnJKN0FIK3E5NXc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cXpNRXRIc1dYWFhQemlEVGtNVWNKSlFPeGpEWEZjZE1GVWZtTWJVRExHdUpN?=
 =?utf-8?B?MTludG8rTndobmtqc045d2pQTUE1elpyUzdBSmZiTTZtSjNJaHJaMGRNZ0hs?=
 =?utf-8?B?YVBZcXkvVzViejIyRW9HNkNwaTdMUE40UlNDelYyNWZrOTZzYVpJRGc4d0Rm?=
 =?utf-8?B?Wm41UGt1eS9GOFBpTHZ5RC9rVGV0MWJoNyt2Z3hIR2pvdjJMMm9tYldidzVy?=
 =?utf-8?B?OWhkNmJES04xdWt3V0t2TWFZVWlJWjlPaWV1SUg4MUhBQytnRzVJcE53VHJS?=
 =?utf-8?B?VU54WkZXV3pBMXNvM29SUllUcGhVamtLRHgrSGlUOWJJUFM0SFRObCs5cGcx?=
 =?utf-8?B?akFIdm5xYmdNUitNbkYrTmU2RXlOa2xHZmxQcUFGUDh6ZzR6dEJCbkxTRXA1?=
 =?utf-8?B?eHJRSTV1T05tVm9iaWNHUVhpdmg4U0EralluM05nZytHcGRtb2ZyeTA4azdz?=
 =?utf-8?B?ZXdxUFIvUGdsejdsenA1U0ZhY2R3Ky9TMUJxS2dWa1NEN0dnRFdRWVNMZU81?=
 =?utf-8?B?QkZZajBZWDRuclhCc1gyNXE5UHJWWThObjhwb2ZaKzZlWFlaYUJtUU5taWNh?=
 =?utf-8?B?QmRRVHgraFU4K2NOcXZPZTVQZExvTVNtUWhCTTVrREg4YkhleHRFYjVKb1Jp?=
 =?utf-8?B?OGNEbzBvVUNCa25NcXNhbTZSejN5SVU5bzRJUUtEdEo3KytYeGk5Vk5GNm15?=
 =?utf-8?B?elF3Q1VvUGRaOFVrVnVQZmxTL0ZwdjExNGlsT1ZOZ3VUQk5HdmVya0ZOUTV0?=
 =?utf-8?B?dHZoM3RwWEoxSVhaaktCb1A4Q091c1RuUEVtMTIwM1VhV2ZmNVBmMFdwQ1k0?=
 =?utf-8?B?dE1NZXFLZEhnMmptK0x0TDE3QVVkL05WamdNK0luTE5mYk4xZEEydU9heUNS?=
 =?utf-8?B?cVdFVWRjN3V1Sm5QN3JqK0lRY1p4RHBaWVczeWRVZTBkMHdVbTA3eVpYQWhR?=
 =?utf-8?B?RkVLVHhOQW9YS1MwTng1TDkzb0Zxa2pQSFFJUDJueGY4MHZxRjdGaGxFL253?=
 =?utf-8?B?eXc0ekRoQmlKTWFQTFV0SUVJRHRsbk43aXNCb0REc1hXdDVoRVUwdk9UQ3Jk?=
 =?utf-8?B?NXMwOVBXMDFRbEdySThWV09pN3VVek0wOHlydXhJRDVGd0xoUllTdlMybjE0?=
 =?utf-8?B?MFFrVVNJVzU5bUF3dU0rbm1JRTY5Y0VLRGJKQmQ3bjZzOFpPM0YreUZaUW9Q?=
 =?utf-8?B?WW1oS1J6RnNzUDlqK2ZnK1A2dFF1RHUyamQ4b3BBdzlxOVByZWZpb29rcjVL?=
 =?utf-8?B?ZHhqYk54dnhRamdJUWVoVmRCRFhqdzFER1dyNlVsamdaMzd5RzRrbUpPV2hZ?=
 =?utf-8?B?Q1dwWnRUWDdIODJTaUJYUC9ZdDZNcENRbVpnRCt6UC9Za05hZnhGWnIvL3JH?=
 =?utf-8?B?d0QxZng2b1hWRDZQbVVESE9yUG9SQUw4ZmtRaHo1SkdkVFNndk1ZejN0K1l3?=
 =?utf-8?B?RTRBQUcvdjdJYmNGWjFOUGNESy9iRU1ydEFzNzE3QzNHWnhpQlNtU0pORmdW?=
 =?utf-8?B?OHNNSTh6TyttNXpBNEMydjJPWk1Nc0w3UjRnRldnTHlrZ29LVHRTRWxEWDVF?=
 =?utf-8?B?QlBWcmZaMTZOQ1M3TER5YkRzTzhoTktGMnByYm1pOXptdTBCcVBvVWQ0VitO?=
 =?utf-8?B?REJ0akc5MFArZGQrWWFoMThmVzB5NTgvenNRUkxoUG9zRDNBWWVFYXorOWJs?=
 =?utf-8?B?TWNiT21sZU4yc25SeUZGelpzVDRnbi9scHo4eDlnMWNuM3plRGZBdFlnaFBE?=
 =?utf-8?B?eUdRZXZqTTdRb3M2R09qNEhYbmk4Wmd1Qm9YbkpVTlRuMG5tTzUxcmJOam9k?=
 =?utf-8?B?dDFsd1QxVkRnNEREMkxmQUJjZ1N6eTd6Ti91bVZvNCtjOEQvK1hRZXZjQTdm?=
 =?utf-8?B?RmQ2YVk2dFJma2dMcU5ySnI5MkJnRThjRll1ZUNXMmJDS3FESFE3M000V2Mx?=
 =?utf-8?B?elJqUGM1Z25Uc0tCcnJ0K0tXdWZyNCtrK2Q2V3VEbGVSZm5JZU1LWjNwc3NH?=
 =?utf-8?B?V3V5bVJLYlRSbkVsSmZGNDVUb083QzhRRkFaSDQ0UDZXZkVVUTY1K1czNkdF?=
 =?utf-8?B?OVc3VDEyeHpITUlycmNhZ1ppUWdZdkcvQkVJN0lkdDhQN0swckc0M3NVZzhP?=
 =?utf-8?Q?jF2yWfMBbGw08TpXea0vy5qzF?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7876a81d-f79e-4d37-b878-08dd19656c9a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2024 21:55:56.2652
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5hgUOSFofYscDjl0WFJUgQVUN2lWmf5sciCqc0E8ECf89D3wStdrY7816/vRoDvVf/HpX5bcxzFrT16doYQ4jg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5873

On 12/9/24 17:25, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Register the SNP panic notifier if and only if SNP is actually
> initialized and deregistering the notifier when shutting down
> SNP in PSP driver when KVM module is unloaded.

Talk about why you are making the change.

Thanks,
Tom

> 
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 21 +++++++++++++--------
>  1 file changed, 13 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index bc121ad9ec26..21faf4c4c4ec 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -109,6 +109,13 @@ static void *sev_init_ex_buffer;
>   */
>  static struct sev_data_range_list *snp_range_list;
>  
> +static int snp_shutdown_on_panic(struct notifier_block *nb,
> +				 unsigned long reason, void *arg);
> +
> +static struct notifier_block snp_panic_notifier = {
> +	.notifier_call = snp_shutdown_on_panic,
> +};
> +
>  static inline bool sev_version_greater_or_equal(u8 maj, u8 min)
>  {
>  	struct sev_device *sev = psp_master->sev_data;
> @@ -1191,6 +1198,9 @@ static int __sev_snp_init_locked(int *error)
>  	dev_info(sev->dev, "SEV-SNP API:%d.%d build:%d\n", sev->api_major,
>  		 sev->api_minor, sev->build);
>  
> +	atomic_notifier_chain_register(&panic_notifier_list,
> +				       &snp_panic_notifier);
> +
>  	sev_es_tmr_size = SNP_TMR_SIZE;
>  
>  	return 0;
> @@ -1750,6 +1760,9 @@ static int __sev_snp_shutdown_locked(int *error, bool panic)
>  	sev->snp_initialized = false;
>  	dev_dbg(sev->dev, "SEV-SNP firmware shutdown\n");
>  
> +	atomic_notifier_chain_unregister(&panic_notifier_list,
> +					 &snp_panic_notifier);
> +
>  	/* Reset TMR size back to default */
>  	sev_es_tmr_size = SEV_TMR_SIZE;
>  
> @@ -2489,10 +2502,6 @@ static int snp_shutdown_on_panic(struct notifier_block *nb,
>  	return NOTIFY_DONE;
>  }
>  
> -static struct notifier_block snp_panic_notifier = {
> -	.notifier_call = snp_shutdown_on_panic,
> -};
> -
>  int sev_issue_cmd_external_user(struct file *filep, unsigned int cmd,
>  				void *data, int *error)
>  {
> @@ -2541,8 +2550,6 @@ void sev_pci_init(void)
>  	dev_info(sev->dev, "SEV%s API:%d.%d build:%d\n", sev->snp_initialized ?
>  		"-SNP" : "", sev->api_major, sev->api_minor, sev->build);
>  
> -	atomic_notifier_chain_register(&panic_notifier_list,
> -				       &snp_panic_notifier);
>  	return;
>  
>  err:
> @@ -2560,6 +2567,4 @@ void sev_pci_exit(void)
>  
>  	sev_firmware_shutdown(sev);
>  
> -	atomic_notifier_chain_unregister(&panic_notifier_list,
> -					 &snp_panic_notifier);
>  }

