Return-Path: <kvm+bounces-34647-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DEE85A03383
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 00:49:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 469641885847
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 23:49:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 898111E25FE;
	Mon,  6 Jan 2025 23:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="mhGZCQGJ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2084.outbound.protection.outlook.com [40.107.243.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA7F1DA634;
	Mon,  6 Jan 2025 23:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736207349; cv=fail; b=QieaOMBveugeqfB/4nyAiuKDO/wTLF93O8WXoDV7G9TRwPaEMVSJzLCBe9UT027xWb55nnqDUzCPjYCn4zpNBd8rcD7tXzqjmhZOgbO7f366gb0TZ23Brzlf/vHmF4rPJI4X/RW57meqYc1qhSpcT48jFYvcp7hXKo4NPuKoFow=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736207349; c=relaxed/simple;
	bh=S+8HYHBwZt4vGohlegcLAat1v6LIhTkpA71i/a40xYI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=m3GhQR/asrekxqWbeByIpuEiO7SWoHPEORyWwlgXT17n5dNiXbu5xujG8G+zzz0lZzjWukPDKd6Wyh4G1PZ46+b82nciCh4c9oalThgdAcSE7/ovYqEs5TOzlOmfknmG/nVUPHPjwg5AccHryHYj8wi7f+hyqQ4/I98JmE44ttk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=mhGZCQGJ; arc=fail smtp.client-ip=40.107.243.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YIuj7DVmLsJqW0a3jGCIsWBrF80x/VPTPmNko/7JGmjvNH+pok5cyotbHJw48+OB1EX7yp5NKdMDi8StKvvbobkJFRohhhFPuiYxnb74MzECLOnLMfhB946PKJNwZnW7soA9qVOc7cGKTUZGjbryQ5oyehFovFmqivFW6er3LmCPMEnaG2i+FyCrB57avpSfiaQ8bViIYlAOQ63Vg1+IShZyUGRQ4CPr/6b1rXWoJDU8O9yFO2feQL8bWN/wWnRZYUJfywHM0l6ii1k+vdcyJ1q4i4uUPwC/MPyzu5zWcB1mL/xHLV0h+xbQ4vbvqKxTTBtMXQb+rnk7uMbEvh2ujg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qln1IRWpA1KZP8E7yNKceZXbga1IPCD9NZEZ2uFniak=;
 b=ObzKXYbStlgT/20OPG6CPFuXZcNjLlLfWpBEnCNa+KuP0bziVVVplXzXD5AH3/wKf0rLWNwW/a7SeNZs5SrbtbuKjn+iBkAFkO6LBYFkmSPgyYecFIphYz5Kwbr04mKbaW78gHXW8ee8LUBXLa95CUh5fIIqTcNzKlf8mRyvswxMU3h3HIvec42txTDKtuBd7qJaAV1guiSivhN0l1JkdltGJIKye3Q7UjEeLZlab+UBHSop8ABGRyVeERYajRwwyvXbFVNzjpVLohaPIqONPZ5ooGmOr40iaWmbPKfX08ceX89F/fQCAXucfYHuLmepYCr8XU7NItKLh9krYC1Y3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qln1IRWpA1KZP8E7yNKceZXbga1IPCD9NZEZ2uFniak=;
 b=mhGZCQGJ3tcW6ewegXwE8y8Z/Dhw14lt9Drws4/o8SQ1x5E2jx1MdaOiuxKcPcVr09v9t2roVVpZZlMSRgR0VXvBZ/JqiY42e4OMBZJt2PuG+m3YVq4CWFvOhb1odustHWEDTPOS2T1teOe2VFQ7EIS3jrDHsCHG1oyFeGAtu6U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by SJ1PR12MB6169.namprd12.prod.outlook.com (2603:10b6:a03:45c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.17; Mon, 6 Jan
 2025 23:48:59 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef%3]) with mapi id 15.20.8314.015; Mon, 6 Jan 2025
 23:48:58 +0000
Message-ID: <9c63bf9c-2846-42f7-a934-262dc7858981@amd.com>
Date: Mon, 6 Jan 2025 17:48:55 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/7] crypto: ccp: Fix implicit SEV/SNP init and
 shutdown in ioctls
To: Dionna Amalie Glaze <dionnaglaze@google.com>
Cc: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
 hpa@zytor.com, thomas.lendacky@amd.com, john.allen@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net, michael.roth@amd.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1735931639.git.ashish.kalra@amd.com>
 <be4d4068477c374ca6aa5b173dc1ee46ca5af44d.1735931639.git.ashish.kalra@amd.com>
 <CAAH4kHaxpATK_dULAe67pV_k=r2LzFZrGn7pspQ2Bw0cUwo+kQ@mail.gmail.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <CAAH4kHaxpATK_dULAe67pV_k=r2LzFZrGn7pspQ2Bw0cUwo+kQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9PR13CA0146.namprd13.prod.outlook.com
 (2603:10b6:806:27::31) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|SJ1PR12MB6169:EE_
X-MS-Office365-Filtering-Correlation-Id: 760faa36-0365-403c-d188-08dd2eacb066
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SnRGZ1dtaGRtUXJRaXhGMmo5SFc3OEc3QllpM056L2p6ekErcGpRZmduMVVi?=
 =?utf-8?B?cStkZ1cwNlJNTUsxei8wMHRDRzR2d3ZWcUFEcUt4TURrN1J5V2EvcHJTZUt6?=
 =?utf-8?B?TEF1VTNWQnZFbDZ1Q2NkS1JpSTJKK01DWjA0cWxwemRkeGovN1hxWXlxM0pK?=
 =?utf-8?B?dlpEV3ZQRFpvb2JLN1QxaFIvS1U0T0tpRmRkNnQyQ3VDcFEwQnY0c3lRWkpU?=
 =?utf-8?B?U0RCa0I1aWNJWFVJNWJvNHJVajRzYktnemc3QXBsN2N6aUNETHJxYlh2NnNP?=
 =?utf-8?B?NUJhQ1lQUzA5eGlqQ0xtaVNHa0VFRndkUEFJSDI4eUJFeElHWHRXSXBkSUxp?=
 =?utf-8?B?RzViS3h4Qk1yeDhaWVJmSXAySklTK3JuWkNUWTk1QjRZSkhvTmdyemg5V2w0?=
 =?utf-8?B?WG1LVGlzdjQwSHUya3Q4SFdJNEpNYlVMak85dU9lZ2JCQmxQakhlYmllcU03?=
 =?utf-8?B?Z2lLeHVmU3Y4bHl1ZkhUaUkzZ2tJck0yZzVDWHRHenlINkVkWXZESHh1c2RG?=
 =?utf-8?B?VW1pYlZZNEx1VExtNlV6dVhzOFVuKzdJTEwxaUMxZWV5ckdka3ppK1hjeTZU?=
 =?utf-8?B?UE9WN0Zad2duNldsK0h2d2xwZkJRY3JNaG9veGh3MkIwVm5Ub0NXdi82SW0y?=
 =?utf-8?B?NUxMcmtQZitoU0JDN2RqRDlYYkVWbzd0UlU3Z1I4NW55aHJWZ05lbnhTcmtw?=
 =?utf-8?B?WDFxQ2N3WGhtNHJWRFlIVWREeDlmbVBqN04xSHRZa0NGNGJqTk9LL1drUkhG?=
 =?utf-8?B?aHRPdnBkdzduQTdramlsVGV6RGZReHJjMkJpYkNOS0JwNWd6Tzc2bzVteHFF?=
 =?utf-8?B?SSt6UitCU0xJL1U3VmpCZ2RWZnlUQmZSSTlYUjFNa0xBSXF4NDB1MEdMVHNV?=
 =?utf-8?B?dE9RMXZCa0JTajYwajdRWkU1bzAwcFlyYXAwWEs2VXM2cUdUZC81MVRkUWxF?=
 =?utf-8?B?bUpjaUJ3Q3hJT2Vvd3dpUUJlTzhnbm1DNndUNERoZVNQNnM3V056dUNvbFE4?=
 =?utf-8?B?MmxhUUJTNGFGZ1hsWGowM0toQVdNYTE3SkxwZmduOXVCRTEwQ2lEQTV4elRB?=
 =?utf-8?B?bzhJK3owNmhpbExuQUhoTVQyWnptWGNqZEN6UHh0Nm1BMGZwcU1sNHEvZFZO?=
 =?utf-8?B?eGJrS2FVazkzZXZocUpuNmdtbVRHejQ3MHdsRHVLbTdZV24yUjg0elErZGtx?=
 =?utf-8?B?N0JSZHZLNEVPZVhnMVlYejRlcGxZd1Q1a3phZE1YRGxaWmpaL3cxMHl1ZnBl?=
 =?utf-8?B?OTV3U2MvNkhFNjMzRmRyYmppSDlOWjJ2UEJyMEtUWWFNcjczVld4cnVyeHNa?=
 =?utf-8?B?UWRWTFRsektxOXgxSnpCcDRNQWRlUklzeUpLRFlIQWRRb2tSb2tFVEJzeGpx?=
 =?utf-8?B?L3ZkdE52VHhEZU9MZ25JWEtmNkRtQTg0Z25DWCtLSFYyM0FBK09RcDRZQ3Rx?=
 =?utf-8?B?WjMrbzF5OTdlNnlOWUVxenY5MnV6U1l5bTlKM3EvaHIzYmg2ZTRuYWZyWlJL?=
 =?utf-8?B?Qi8vNzAwcWFLeVJBU3E5SzNjQ1Evb3hERXpCWC9aSjBwbm13anlLNzk0aktz?=
 =?utf-8?B?bWFQaTFiQ1BNTlZDMzhoY2xJQmpPNndUYlFZYTR1MGxsUTl2R2U4RjZDWjNN?=
 =?utf-8?B?UzhxditlUXA0UTFIclFMT0N5aXJ4aFRVck5oN3djMXhzZmw4dFcvTE1xOWVl?=
 =?utf-8?B?OWJ6NE9DUk15d2VhcU5sc0FkRm50Y01XMzZqa1BtZVE1Y2xDdjhFRS9UZk1y?=
 =?utf-8?B?WXh2VHpSSWtPZUl0dHJsdU1aU1VuaXpGbXNZT2ZxWG40VkYrOXVMQS9pQUZx?=
 =?utf-8?B?YVk2NEt5ckVyNWo3cFhWTG9uQnhteXNhN2J6YmQyTE1ad0o1ajh2MFg4dEFo?=
 =?utf-8?Q?5h9GGEgHb4oJk?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TDFQdUxTSXE1Y2FRcWpJUTN5SWpLOVVjZTRueDJYS0cxaFdLcFgxYkNZSm0y?=
 =?utf-8?B?bHRBcEhhZVV0OWp6UVplRXhINGI0UFJJM2c3cjhkc1NoZmZ0cjlFNWNudk1o?=
 =?utf-8?B?OHMrNk54azNmeXh1UXQ4NGpPeHkyTEpsUmpkcERaeUtVM0l2eHBTakErUVNp?=
 =?utf-8?B?LytDSXRqM3Exa2pwNVNRL29kSUNyaVE4R0t0SDVpSjRwbm5ZT2tDbFFGWmxs?=
 =?utf-8?B?OWMreU5rQzYzRmR0K3dLWGJhZGxQK2p1TWNMSktCa1pGUkFZTElaa3M0a2py?=
 =?utf-8?B?dzhKdEl0eDJseTh5K1hCdTVpSDhhNUN0Um4zNkErU3JUK0xjNzVURXJtSExK?=
 =?utf-8?B?WHUzdkErclVtT01pNWY2VTFqYU01S3cvT2UvUjIxcUlWZ0NrL3RyMlJhUkZN?=
 =?utf-8?B?S21UdmNmMnFGVUdYK0o5ek9vMC9yTkF6SjN4OVA5OEVLeWgrcHBaOGE3bEhM?=
 =?utf-8?B?Tm1PRUpqaTFVQXRaUjNmc2xndlBiS0paSTBIdzVRMWlDOFd5YnBFa1lVaFc0?=
 =?utf-8?B?a1ZYY3lVQXNTY2Y5VGdxQTJOSExTT0dOK293MS9SdFI3WnRWNnloeEc0Tkdu?=
 =?utf-8?B?UHpJUWxrVm9VTGp4cXdhZU9ham40VVE3WVAyK3pORzdIMVZSdyt1R2wxTHh6?=
 =?utf-8?B?TEhYZHVZMURnc0FEMTRoa3FyTGFYZUhrSDUzQVU5TCtZUHRmN2NsaG5MeEpM?=
 =?utf-8?B?VTdvdFU1RndvWWhCbHpYNHhET1dQVGZhbElEOEE4dDNlUVFOWlJWaW9YdzRZ?=
 =?utf-8?B?Qll2OFh0eDhpWmhNaGk1YkhDSFJwUVBwSnZscUFXdlJDZEV2QUlkT0NhVTBn?=
 =?utf-8?B?MEZPbTFlTXJjQk43YWQzd3BHcHphZWJBdzdObDRIME5UYkhIK2svOWIwRzM1?=
 =?utf-8?B?VHdsK0d2R1NvMUtzLzVLV2pNLzNaMkpTbUJuOG83cmExUCtoVFlpQnFBdG9x?=
 =?utf-8?B?cWRoTTRTOEdXVm9NcFZQZlFoZTAySEhSV2w4d1F2aFpUNkZFdmNUUi9neHZa?=
 =?utf-8?B?bXNoeFJHdnhGVHN6ajFDYklsMVR1NWUxTDhKVks4WFUwVXREV2xGMkVWMjBX?=
 =?utf-8?B?Y0JwK01yRXhBTG5pbzdwaFBKWDNvYmpVREE3SC9XemlXaUhXaFVNTGphOGVm?=
 =?utf-8?B?aG8zZ0pWMEdvdHZoMUxiaXM2Ykc3NEJhTFMyN2REVGhocHNsN2hOTTRMZ1c4?=
 =?utf-8?B?bkRYWnkxWnB3Vm9COHRTdUN1eVFGQ2lReFo4a1NMZS8xSVgzWmFtZElTMS9U?=
 =?utf-8?B?ZkFTMDNZaXJXVUVSWEw2RUtCT21VSDE2bzEzNGR6YkJCdisxTnZKcldtZTJG?=
 =?utf-8?B?dzJBcjNlOUtLVm1BWjFickljYktBVzNBaCtqVlJPNEkxWkt4ZnBqRzZUV0hK?=
 =?utf-8?B?Vlh3NE1JY3RFbjQxOTFwcW05R0p3OS9EelJxSkNLaExPTFppblRoUjQ1eEth?=
 =?utf-8?B?UDNWVk1DcDh4MTkxSVhCZjZwZ2FybU5scUFRTTRtbW5VajdYTm04OTk2L2h1?=
 =?utf-8?B?WUVQY1QwcjVMRUI0bnhEa21yUnd0emFOcE9VWEUza28zU2E3RTVBZXlvdzNm?=
 =?utf-8?B?OWVLdjdFajVpYVZaZklBZnBDeTN4OWZVcTJ6RU5HbmxSemFpZW5Oa0xsSzR2?=
 =?utf-8?B?WUtXZHlzcitFYTJSM3A4YnkvNU1NM2Y3K2psVC80eGVrZm9ob2F0aGhVTldD?=
 =?utf-8?B?K3pOVitxOVRrbC8wdlU5dFZ3dnFpc3lnelFNb2lpUitZY1l2NVg1MStxQ0FR?=
 =?utf-8?B?UUNLREJZb1BVYjdOOXNFTXNUMWlvdy9KVEc3TmRZcWd5T24zejlJaDdyZk0z?=
 =?utf-8?B?MnRoZmZmUWh6QjJPRDhQK3d5enM1My9kcXhlSGEzY3h3Y0VOZkE5MzZQdHI3?=
 =?utf-8?B?UWlpNUdNbDIvL0VCc2JIaFBZS1BvYi9PM05CN214ZExaU1dDcFdqeExlZmxI?=
 =?utf-8?B?cUNmQU1jMEtYTG9DNEh6cFV1Q1dYVXdGajRpUVFRYmlRZnlpamlab1VQWGMz?=
 =?utf-8?B?YVhCSE5pQjVybFlpWjZJUUxNakhPVThuMC9WYWhtS3QxMit3MVMvS05xMDVK?=
 =?utf-8?B?RmVPQ0NUU2grMWJzZVdya2REeWQ3a0p3dzJFRDRidmMxYTg3citUVWdWa0lv?=
 =?utf-8?Q?jAjyjku0xeo+i0AN7+2FIwZDp?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 760faa36-0365-403c-d188-08dd2eacb066
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2025 23:48:58.7399
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WF2O+CQhLcaMSU6XItOy3E/t8KJxTa5GGpL9nOFTwS9hZv+oHnkLKzDSAyh8L+r+uPAP+NRKHbcfFS4ekc9Hhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6169



On 1/6/2025 12:01 PM, Dionna Amalie Glaze wrote:
> On Fri, Jan 3, 2025 at 12:00 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>>
>> From: Ashish Kalra <ashish.kalra@amd.com>
>>
> 
> The subject includes "Fix" but has no "Fixes" tag in the commit message.
>

I will change the commit message to be more appropriate, it is not really
a fix but a change to either add a SEV shutdown to some SEV ioctls and
add SNP init and shutdown to some SNP ioctls.
 
>> Modify the behavior of implicit SEV initialization in some of the
>> SEV ioctls to do both SEV initialization and shutdown and adds
>> implicit SNP initialization and shutdown to some of the SNP ioctls
>> so that the change of SEV/SNP platform initialization not being
>> done during PSP driver probe time does not break userspace tools
>> such as sevtool, etc.
>>
> 
> It would be helpful to update the description with the state machine
> you're trying to maintain implicitly.
> I think that this changes the uapi contract as well, so I think you
> need to update the documentation.
> 
How does this change the uapi contract, as the SEV init and shutdown
is going to happen as a sequence and the platform state is going to 
be consistent before and after the ioctl, the next ioctl if required
will reissue SEV init.

> You have SEV shutdown on error for platform maintenance ioctls here,
> which already have implicit init.
> pdh_export gets an init if not in the init state, which wasn't already
> implicit because there's a wrinkle WRT the writability permission.
>

This patch only adds SEV shutdown to already implied init code as part
of some of these SEV ioctls. 

If you see the behavior prior to this patch, SEV has always been initialized
before these ioctls as SEV initialization is done as part of PSP module
load, but now with SEV initialization being moved to KVM module load instead
of PSP driver load, the implied SEV INIT actually makes sense and gets used
and additionally we need to maintain SEV platform state consistency
before and after the ioctl which needs the SEV shutdown to be done after
the firmware call.
 
> snp_platform_status, snp_config, vlek_load, snp_commit now should be
> callable any time, not just when KVM has initialized SNP? If there's a
> caveat to the platform status, the docs need to reflect it.
> I don't know how SNP_COMMIT makes sense as having an implicit
> init/shutdown unless you're using it as SET_CONFIG, but I suppose it
> doesn't hurt?
> 

Yes, and that is what this code is allowing, to call snp_platform_status,
snp_config, vlek_load and snp_commit without KVM having initialized SNP.

If you see the behavior prior to this patch, SNP has always been initialized
before these ioctls as SNP initialization is done as part of PSP module
load, therefore, to keep a consistent behavior, SNP init is being done here 
implicitly as part of these ioctls and then SNP shutdown before returning
from the ioctl to maintain the consistent platform state before and
after the ioctl. 

Additionally looking at the SNP firmware API specs, SNP_CONFIG needs
SNP to be in INIT state. 

Thanks,
Ashish

>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>> ---
>>  drivers/crypto/ccp/sev-dev.c | 149 +++++++++++++++++++++++++++++------
>>  1 file changed, 125 insertions(+), 24 deletions(-)
>>
>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>> index 1c1c33d3ed9a..0ec2e8191583 100644
>> --- a/drivers/crypto/ccp/sev-dev.c
>> +++ b/drivers/crypto/ccp/sev-dev.c
>> @@ -1454,7 +1454,8 @@ static int sev_ioctl_do_platform_status(struct sev_issue_cmd *argp)
>>  static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp, bool writable)
>>  {
>>         struct sev_device *sev = psp_master->sev_data;
>> -       int rc;
>> +       bool shutdown_required = false;
>> +       int rc, ret, error;
>>
>>         if (!writable)
>>                 return -EPERM;
>> @@ -1463,19 +1464,30 @@ static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp, bool wr
>>                 rc = __sev_platform_init_locked(&argp->error);
>>                 if (rc)
>>                         return rc;
>> +               shutdown_required = true;
>> +       }
>> +
>> +       rc = __sev_do_cmd_locked(cmd, NULL, &argp->error);
>> +
>> +       if (shutdown_required) {
>> +               ret = __sev_platform_shutdown_locked(&error);
>> +               if (ret)
>> +                       dev_err(sev->dev, "SEV: failed to SHUTDOWN error %#x, rc %d\n",
>> +                               error, ret);
>>         }
>>
>> -       return __sev_do_cmd_locked(cmd, NULL, &argp->error);
>> +       return rc;
>>  }
>>
>>  static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
>>  {
>>         struct sev_device *sev = psp_master->sev_data;
>>         struct sev_user_data_pek_csr input;
>> +       bool shutdown_required = false;
>>         struct sev_data_pek_csr data;
>>         void __user *input_address;
>> +       int ret, rc, error;
>>         void *blob = NULL;
>> -       int ret;
>>
>>         if (!writable)
>>                 return -EPERM;
>> @@ -1506,6 +1518,7 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
>>                 ret = __sev_platform_init_locked(&argp->error);
>>                 if (ret)
>>                         goto e_free_blob;
>> +               shutdown_required = true;
>>         }
>>
>>         ret = __sev_do_cmd_locked(SEV_CMD_PEK_CSR, &data, &argp->error);
>> @@ -1524,6 +1537,13 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
>>         }
>>
>>  e_free_blob:
>> +       if (shutdown_required) {
>> +               rc = __sev_platform_shutdown_locked(&error);
>> +               if (rc)
>> +                       dev_err(sev->dev, "SEV: failed to SHUTDOWN error %#x, rc %d\n",
>> +                               error, rc);
>> +       }
>> +
>>         kfree(blob);
>>         return ret;
>>  }
>> @@ -1739,8 +1759,9 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
>>         struct sev_device *sev = psp_master->sev_data;
>>         struct sev_user_data_pek_cert_import input;
>>         struct sev_data_pek_cert_import data;
>> +       bool shutdown_required = false;
>>         void *pek_blob, *oca_blob;
>> -       int ret;
>> +       int ret, rc, error;
>>
>>         if (!writable)
>>                 return -EPERM;
>> @@ -1772,11 +1793,19 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
>>                 ret = __sev_platform_init_locked(&argp->error);
>>                 if (ret)
>>                         goto e_free_oca;
>> +               shutdown_required = true;
>>         }
>>
>>         ret = __sev_do_cmd_locked(SEV_CMD_PEK_CERT_IMPORT, &data, &argp->error);
>>
>>  e_free_oca:
>> +       if (shutdown_required) {
>> +               rc = __sev_platform_shutdown_locked(&error);
>> +               if (rc)
>> +                       dev_err(sev->dev, "SEV: failed to SHUTDOWN error %#x, rc %d\n",
>> +                               error, rc);
>> +       }
>> +
>>         kfree(oca_blob);
>>  e_free_pek:
>>         kfree(pek_blob);
>> @@ -1893,17 +1922,8 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>>         struct sev_data_pdh_cert_export data;
>>         void __user *input_cert_chain_address;
>>         void __user *input_pdh_cert_address;
>> -       int ret;
>> -
>> -       /* If platform is not in INIT state then transition it to INIT. */
>> -       if (sev->state != SEV_STATE_INIT) {
>> -               if (!writable)
>> -                       return -EPERM;
>> -
>> -               ret = __sev_platform_init_locked(&argp->error);
>> -               if (ret)
>> -                       return ret;
>> -       }
>> +       bool shutdown_required = false;
>> +       int ret, rc, error;
>>
>>         if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
>>                 return -EFAULT;
>> @@ -1944,6 +1964,16 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>>         data.cert_chain_len = input.cert_chain_len;
>>
>>  cmd:
>> +       /* If platform is not in INIT state then transition it to INIT. */
>> +       if (sev->state != SEV_STATE_INIT) {
>> +               if (!writable)
>> +                       return -EPERM;
>> +               ret = __sev_platform_init_locked(&argp->error);
>> +               if (ret)
>> +                       goto e_free_cert;
>> +               shutdown_required = true;
>> +       }
>> +
>>         ret = __sev_do_cmd_locked(SEV_CMD_PDH_CERT_EXPORT, &data, &argp->error);
>>
>>         /* If we query the length, FW responded with expected data. */
>> @@ -1970,6 +2000,13 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>>         }
>>
>>  e_free_cert:
>> +       if (shutdown_required) {
>> +               rc = __sev_platform_shutdown_locked(&error);
>> +               if (rc)
>> +                       dev_err(sev->dev, "SEV: failed to SHUTDOWN error %#x, rc %d\n",
>> +                               error, rc);
>> +       }
>> +
>>         kfree(cert_blob);
>>  e_free_pdh:
>>         kfree(pdh_blob);
>> @@ -1979,12 +2016,13 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>>  static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
>>  {
>>         struct sev_device *sev = psp_master->sev_data;
>> +       bool shutdown_required = false;
>>         struct sev_data_snp_addr buf;
>>         struct page *status_page;
>> +       int ret, rc, error;
>>         void *data;
>> -       int ret;
>>
>> -       if (!sev->snp_initialized || !argp->data)
>> +       if (!argp->data)
>>                 return -EINVAL;
>>
>>         status_page = alloc_page(GFP_KERNEL_ACCOUNT);
>> @@ -1993,6 +2031,13 @@ static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
>>
>>         data = page_address(status_page);
>>
>> +       if (!sev->snp_initialized) {
>> +               ret = __sev_snp_init_locked(&argp->error);
>> +               if (ret)
>> +                       goto cleanup;
>> +               shutdown_required = true;
>> +       }
>> +
>>         /*
>>          * Firmware expects status page to be in firmware-owned state, otherwise
>>          * it will report firmware error code INVALID_PAGE_STATE (0x1A).
>> @@ -2021,6 +2066,13 @@ static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
>>                 ret = -EFAULT;
>>
>>  cleanup:
>> +       if (shutdown_required) {
>> +               rc = __sev_snp_shutdown_locked(&error, false);
>> +               if (rc)
>> +                       dev_err(sev->dev, "SEV-SNP: failed to SHUTDOWN error %#x, rc %d\n",
>> +                               error, rc);
>> +       }
>> +
>>         __free_pages(status_page, 0);
>>         return ret;
>>  }
>> @@ -2029,21 +2081,38 @@ static int sev_ioctl_do_snp_commit(struct sev_issue_cmd *argp)
>>  {
>>         struct sev_device *sev = psp_master->sev_data;
>>         struct sev_data_snp_commit buf;
>> +       bool shutdown_required = false;
>> +       int ret, rc, error;
>>
>> -       if (!sev->snp_initialized)
>> -               return -EINVAL;
>> +       if (!sev->snp_initialized) {
>> +               ret = __sev_snp_init_locked(&argp->error);
>> +               if (ret)
>> +                       return ret;
>> +               shutdown_required = true;
>> +       }
>>
>>         buf.len = sizeof(buf);
>>
>> -       return __sev_do_cmd_locked(SEV_CMD_SNP_COMMIT, &buf, &argp->error);
>> +       ret = __sev_do_cmd_locked(SEV_CMD_SNP_COMMIT, &buf, &argp->error);
>> +
>> +       if (shutdown_required) {
>> +               rc = __sev_snp_shutdown_locked(&error, false);
>> +               if (rc)
>> +                       dev_err(sev->dev, "SEV-SNP: failed to SHUTDOWN error %#x, rc %d\n",
>> +                               error, rc);
>> +       }
>> +
>> +       return ret;
>>  }
>>
>>  static int sev_ioctl_do_snp_set_config(struct sev_issue_cmd *argp, bool writable)
>>  {
>>         struct sev_device *sev = psp_master->sev_data;
>>         struct sev_user_data_snp_config config;
>> +       bool shutdown_required = false;
>> +       int ret, rc, error;
>>
>> -       if (!sev->snp_initialized || !argp->data)
>> +       if (!argp->data)
>>                 return -EINVAL;
>>
>>         if (!writable)
>> @@ -2052,17 +2121,34 @@ static int sev_ioctl_do_snp_set_config(struct sev_issue_cmd *argp, bool writable
>>         if (copy_from_user(&config, (void __user *)argp->data, sizeof(config)))
>>                 return -EFAULT;
>>
>> -       return __sev_do_cmd_locked(SEV_CMD_SNP_CONFIG, &config, &argp->error);
>> +       if (!sev->snp_initialized) {
>> +               ret = __sev_snp_init_locked(&argp->error);
>> +               if (ret)
>> +                       return ret;
>> +               shutdown_required = true;
>> +       }
>> +
>> +       ret = __sev_do_cmd_locked(SEV_CMD_SNP_CONFIG, &config, &argp->error);
>> +
>> +       if (shutdown_required) {
>> +               rc = __sev_snp_shutdown_locked(&error, false);
>> +               if (rc)
>> +                       dev_err(sev->dev, "SEV-SNP: failed to SHUTDOWN error %#x, rc %d\n",
>> +                               error, rc);
>> +       }
>> +
>> +       return ret;
>>  }
>>
>>  static int sev_ioctl_do_snp_vlek_load(struct sev_issue_cmd *argp, bool writable)
>>  {
>>         struct sev_device *sev = psp_master->sev_data;
>>         struct sev_user_data_snp_vlek_load input;
>> +       bool shutdown_required = false;
>> +       int ret, rc, error;
>>         void *blob;
>> -       int ret;
>>
>> -       if (!sev->snp_initialized || !argp->data)
>> +       if (!argp->data)
>>                 return -EINVAL;
>>
>>         if (!writable)
>> @@ -2081,8 +2167,23 @@ static int sev_ioctl_do_snp_vlek_load(struct sev_issue_cmd *argp, bool writable)
>>
>>         input.vlek_wrapped_address = __psp_pa(blob);
>>
>> +       if (!sev->snp_initialized) {
>> +               ret = __sev_snp_init_locked(&argp->error);
>> +               if (ret)
>> +                       goto cleanup;
>> +               shutdown_required = true;
>> +       }
>> +
>>         ret = __sev_do_cmd_locked(SEV_CMD_SNP_VLEK_LOAD, &input, &argp->error);
>>
>> +       if (shutdown_required) {
>> +               rc = __sev_snp_shutdown_locked(&error, false);
>> +               if (rc)
>> +                       dev_err(sev->dev, "SEV-SNP: failed to SHUTDOWN error %#x, rc %d\n",
>> +                               error, rc);
>> +       }
>> +
>> +cleanup:
>>         kfree(blob);
>>
>>         return ret;
>> --
>> 2.34.1
>>
> 
> 
> --
> -Dionna Glaze, PhD, CISSP, CCSP (she/her)


