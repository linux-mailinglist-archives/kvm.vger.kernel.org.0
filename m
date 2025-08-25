Return-Path: <kvm+bounces-55595-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3232EB3365E
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 08:26:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8CE597A4D16
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 06:24:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9F8227FD48;
	Mon, 25 Aug 2025 06:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="WmpdnK5t"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2080.outbound.protection.outlook.com [40.107.220.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 599DA1F1518;
	Mon, 25 Aug 2025 06:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756103159; cv=fail; b=omgEZXXXb2QuEeC/NWPpy388VlqaBq3xMpUzzCKdlBKjAfLces1tIwdqmg+DTZQSfb1dfFPzSaT3SlE8vn+ChgNQWeioyicWWDWM/aHEaFmfeogMqK76V2dyKO1wWC8/jEIKSYi9SaywkhJqX3VKo5/gd/LPIMifPwyM3vRcHkY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756103159; c=relaxed/simple;
	bh=6jOI4MWNPOfX9NzcQzl2CFPc0vk26wNLfYJ0hp03QyI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=g0WBbGKbSpZBxbqiH3ghwoL1Tv1m9nqTSGH6paGcCiAGYpL9dMIaAlQk14esptiSnCijueRuD5ujS58JliETZdmzfO9UtEnZttFORE4XqcMvH7Zlfv/AGaQGGE8zLGEx61ptElDrSrsbvD3bc+etyGzRxN/M51ERoSyh9CWGMxw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=WmpdnK5t; arc=fail smtp.client-ip=40.107.220.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LVCEjrq//NziteQ20XjSYyxfOuLlOYm8pNgBgZ0vYxPp0Modaf2klLtLKeSn371qTpFj8xFEmUxZZPdCK02r1kbAx5dhfnUEV2vVuhCoewyINrSHig1ZgWKctTN+SLtz85lCHdjVtWBh4twUU9vU2nxMIkPEoi8lohaF2o8abd2pj7p9v2GcW7zXfUMVfghueC9zivVfb1pIHiC8VMZTKjPG2BIjUgGk0SVT0BXxiKkARqMgWWVxbmDJFLkzs9m1PSvUfkRfcAdpHjMlJl90AEC4rDUtY9+tecpQ5iKHcTcGZklSTVo7Rk6UtyF2BbeHmleVASgzkEWuCHr966MZTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D0SsX4SJKAcUkguRtRdto2zl+o1zICswxqoSXWQQnP8=;
 b=HrLEwsO4pbDwSS4lUxJfXRwqaKVd5eC/7KuclDiLXc8MHLfknlxFlVr+Xhu8eIe3oSzNxJO/IIlEsZdXLUJI9ZUzDJXcj6wv6N5iPzDgT4VJIfknk5CgvQctaHwPIZBB7fltEnxw6EUZ9h9XycZ6F8NE2t+K0goMiayQ2kbkcUw2QKaRqmvdOP2xFyk2ZzL8xQIRBgUSLD3nzA8wWK1Jh07Ulr4ZKs8SMbYG8Ff7I9wxvCXrLFFFvG130zldz4x0KtmRihtK4l41carP1InJc0kck5W2jr8ygmel1r6kAY0i4T9AqWwdO4SPP0Rbz9NN9m8Z6H/vZOoOQ03fE+LFDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D0SsX4SJKAcUkguRtRdto2zl+o1zICswxqoSXWQQnP8=;
 b=WmpdnK5tlmfVkc/SZHwS326vhnwtCJzRWqIepDeLiU0ZWOQ4CtzLhPGAEmXgUSqpslA2X98EZ578m2vJ4uWX9G6fas3JyjHafmfAp5CLVQyB6BgKDtjay1b2xy2c9jZi8SZFWUxovYUUYXNS0qMzNRs2U8Gm48G45qjq7iy0kWI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 PH7PR12MB5654.namprd12.prod.outlook.com (2603:10b6:510:137::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Mon, 25 Aug
 2025 06:25:54 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%5]) with mapi id 15.20.9052.019; Mon, 25 Aug 2025
 06:25:54 +0000
Message-ID: <a91b5470-33a0-4a23-ac1a-a7f1d4559cc1@amd.com>
Date: Mon, 25 Aug 2025 11:55:44 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 09/18] x86/sev: Initialize VGIF for secondary VCPUs for
 Secure AVIC
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
 dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, nikunj@amd.com,
 Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com,
 David.Kaplan@amd.com, x86@kernel.org, hpa@zytor.com, peterz@infradead.org,
 seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
 kirill.shutemov@linux.intel.com, huibo.wang@amd.com, naveen.rao@amd.com,
 francescolavra.fl@gmail.com, tiala@microsoft.com
References: <20250811094444.203161-1-Neeraj.Upadhyay@amd.com>
 <20250811094444.203161-10-Neeraj.Upadhyay@amd.com>
 <20250822172820.GSaKiotPxNu-H9rYve@fat_crate.local>
Content-Language: en-US
From: "Upadhyay, Neeraj" <neeraj.upadhyay@amd.com>
In-Reply-To: <20250822172820.GSaKiotPxNu-H9rYve@fat_crate.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0149.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:c8::22) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|PH7PR12MB5654:EE_
X-MS-Office365-Filtering-Correlation-Id: ff5d38b8-37c5-4fc6-bdea-08dde3a03ea9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cjhGVXIxU0srS040NjRYeUVmeUF5MzFEak9VQlhiUU0veTJ0Sm1ZWXBYZnJP?=
 =?utf-8?B?NzdpUFY2R1pPbUY1RnVKVW12b05veEptS2tkN3N2dThBb2dTVCtrTllweUhG?=
 =?utf-8?B?elRmeVZiOEVVc21WTUlyREV3aEJqZEtmeUNWK1N3SFJEQVJ5ZFpBZDJvb04r?=
 =?utf-8?B?clpJQmc2MHEySHdvTDJQenY5MlNpTm1jRFNlcFEya1VabHZlTkpFRk1pR1E2?=
 =?utf-8?B?c1hlUmk4dSs3RStlVHRVUHgvKzRiQ1pBTDNtbGhKUkhNTDg3V2ZZQ3dZOEsv?=
 =?utf-8?B?NkpxV1UvSUI4ckdjK2RBVVNBcmRsdFFOaGs2RGZpWUczdFhxdEJORjZhLzh2?=
 =?utf-8?B?M1pvQzRJMDZjcUJmZzFmVkFodVRrZmNVZllKM1NMODE4azZZdDB6b1Q3MnMw?=
 =?utf-8?B?ODhnb1htL1luZW5qbDU4Z1FQamFwNCtucGxWVnNwZVBESnk5SzQwb2Q3aUtm?=
 =?utf-8?B?N3V5Q2xodi9Jb3dUQ3dyK3BUOE1RV09qUjgrdklGUEdnaGdONE1UOE5QMDkv?=
 =?utf-8?B?WTZ3T2VHeUpPdi9iVlpaV3lVMVZXcVNlcGxEREo3WkNpSlloaDZqT2lTeHJr?=
 =?utf-8?B?S3AxOGJOWjIvbGJDM0xWOS90MVYvRmQ2U01CTVZhY2NaSFNtVDNNcC9hbFl1?=
 =?utf-8?B?OWszSlM4MHpJY2ZLSWRSdW1hK0F6MUthNGJ6Q0Qwbm9xaVZaWmVmWlhWL3NG?=
 =?utf-8?B?QWU1NFhpWVVQam1iU3UwbWJpY2JMWENQTVBKYVovamFoVzRRTkI3QldPdnJO?=
 =?utf-8?B?L0xGNjFZbzdsczh4ajJVOVlpenYxaG5ZRG5DMWt5b2tHYmdVVk5XYk5TZXVX?=
 =?utf-8?B?eXYzc0x2N0NTclNIdHNadEd0VmZpNisvNzRMODdYZlJ2dU80KzgyYlhxVWpV?=
 =?utf-8?B?R2NPNVkxb1FDWHk2N1ArclhWVHZvT0ZtcUNlWUJXdkZ4WVROWFA4TkRxRkRs?=
 =?utf-8?B?UmM0a0RpK0lNTGtuVVR1R3FTb3E1Um1nVU1taG11WTYvWUJPZnZsRGg5Tm92?=
 =?utf-8?B?djlLeW12b3hqcFJINUVXcXBiVjJydjZvTDRBNzV5ZjFBbnA0ZjdzTVNwa0pK?=
 =?utf-8?B?YjdqVGc5R3Nibk5vTWlGYlRVUGV6VTdVSXdEaVpHRmdEYUl5NnNyMURqWU5D?=
 =?utf-8?B?R3g3T0FuK0cvNmE3WUEwNXFnZnRId1hpOUxHSlE0bi9vdmh0ZmEwNHY5M3NF?=
 =?utf-8?B?VFgxcVZENzNzcXhKT1czb09UWExMdDVKZjBUR0JNY2x3TUdMbjhRR2pCL0Iz?=
 =?utf-8?B?T3pGeEJ0WWQ0bmpPNWNtSkIxUThOdE9pYjAyd3NldW1WY293a2ZiS2VmZEhn?=
 =?utf-8?B?aUhvVkp5dFFhU1ZHSE92OURvdFhmWlhZSXlVdDJrRHFpTk5XSjYydEZqejhQ?=
 =?utf-8?B?K09xWE1pVWhmQUUvWjNRQUJPYnU0cXZHSmtuNWdmQkU3b0Zacnp1V3BYaE5x?=
 =?utf-8?B?R0sxYi84NmJSWjF5dyt5NXlNVUVMK3ZYcTVkLzg0QkNtWlJrQkJyOG9DOUMv?=
 =?utf-8?B?Zy9zUjRmdlkzaTJsTDU1RUZlTFYrOUlzUmllTm9PRHJ3WlBhcjBEWG5BQzV1?=
 =?utf-8?B?Nk1pZ1RZUVFSUHFuSFpFaUVpT0FHSFEwb21tdU1PeExlTWdlSHhVcVE5NmVF?=
 =?utf-8?B?QmRaaS9UdmxXL01BWDlxQ3BLWE1ZaFdyTEM1OE1DK0pnR2xodDd5ZHZtSmRN?=
 =?utf-8?B?RFJmVFkvSWw1L3Y4cVMyaDNaWGlsL1diUXIxZVQwYTlROXhKQXU2MGIwRXkx?=
 =?utf-8?B?TmZybjNYaGltWENNcUdWWTIvUlZ1Wjc4QTY4WFZaRWk1UHY5eGJEVlB0TTNo?=
 =?utf-8?B?RmJNQXFJeXhWeGhjYzM0cnNZK3ZOL3RnUUdPcjdTNDdRN0pSQ0l4c3JoSUNI?=
 =?utf-8?B?bHgwKzdvdHR5bk9tQjBOQm9YMCticTA0V0greUVtMG9jdm9VL0VMZG5PMy9k?=
 =?utf-8?Q?yUVRayrEb5I=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bHRIMnV0NDRiWHpMRHYxMXVRTWZPMGxMSUhZa1lvU25sMm5aOFNWZ3FJejVt?=
 =?utf-8?B?d0owN3NKbTJlZzMzQ1V2OERvdmkwSGIrVEV1RUUxd25ZU2JrcEFFOG9INURS?=
 =?utf-8?B?N3hrNG9TVWZ6RmsvVEQ1Vk9ObGt0aVhXVjFCU1BYMmJoazBHNmsrL21nYjU3?=
 =?utf-8?B?eVRLQW5xQnptYUNOa3BSbW5mcXR0ZGZOcjdFc0VZNG14cUlCeGZHUzBMZ0d1?=
 =?utf-8?B?NDRRSWNRTjhEVVFrWVpTR0psK25aazJ5VHI5YWZNclo4TWhLNWFGWTVTMUNw?=
 =?utf-8?B?RUdvOUhlQWJOTWdVM3BlVVFkaWNUbHJ5Q091NTFqcTVMckFzZGVTSW9IYWxV?=
 =?utf-8?B?N3RKaEIrdjVWRHRWRmVqS2hIa0Y1eUxOWTkxSWtXRnB3WUNienBwRllKRXNa?=
 =?utf-8?B?K2EzdjRoVm44cnJlL05XMkNIcC9BcytEV3J0SkNzek5PVW9OTzlPN0NxTzEy?=
 =?utf-8?B?ZUJKbGhMQ2xXR2RBU1UzaytFTFhtSVR2RWNPUzJjbzhDOGFUcmM0UXhXNmlU?=
 =?utf-8?B?NVpadVRsZGtjZC81emptK3ZMU2tGcmt0ZUlUN253N1hVazI1ekVML0xUM0Yr?=
 =?utf-8?B?aXJrbFF4ZUNjZUJUN3hDcVN2dEJ5NTlXcFNQdTIzcFZJRUZBbTN5Z081UHZ4?=
 =?utf-8?B?T0ZhYnFOSzY1ZnJ1SUhwRzlFQ1FxU0hpdXFiamxRYWhHMHJSL3EwbG4zTUl2?=
 =?utf-8?B?blRnV0RQS2xEZjdGM3ptMXBWa05ieWwwOVAyempzVnZ3aExKWDEzV1lXTmM4?=
 =?utf-8?B?Y1FpRjZYZzZWTlZwSkpRVUM2SVJjTGQ2YWUvSXBJQUxwcERJRjBZTDBtVENN?=
 =?utf-8?B?bHVuZkduWGRrcDVyN0wydUkxdEVGNEhrT09QeFVmT1ZmMit0RGVZVHpJTUw0?=
 =?utf-8?B?RUM0QVExVTRWbStlYVhvczRLY2dDanZDTHB5L21qL3JCclo1dlQ2L3NwcGdS?=
 =?utf-8?B?bUhkNUsrdm44RFA1Zk9jOGhheTg5bWMxRS9pWktsR2JzcVBha0JNTEhlRWlG?=
 =?utf-8?B?MmlaaHpFQ1Robm1XcEhzWnR6SERyKzRkSWZ1OTF0VDEzOVNpN0RVY1Z5bnJj?=
 =?utf-8?B?QzBQcHFKc2JYelJYVEZ3Zyt0WkozN0lUU212Vmk5OGQ1bWJ2VHJDMVdYcGVO?=
 =?utf-8?B?RDRMM2dtYWNzTk5iQklCZUVEZEdLMkhqMnp0L2JJVzlIejVGeGs1c2Z5cnps?=
 =?utf-8?B?UWUvZDZrZ1pNanV5enN2NHZqNWRtNVdlSTFLd0VCTXRaaUFUcHlFVzRzelFQ?=
 =?utf-8?B?K1lkNmhSV3FvYVdWSkJCUzFxZGlxN2x3dm1MTlFtUWpRbWs2My91eTk2dnMr?=
 =?utf-8?B?QTRDWVhod1dEZlg5RWlXNnpXUVNPSzNEMXBOVlVtbG9VMVE5TUFVZmM1aVNI?=
 =?utf-8?B?VFZvTGFQVWE4Q2Fsd05qMm5QNTVxaGN5bjJJczZSSXRNbW5qYktnbkpZRTVU?=
 =?utf-8?B?ZzFVMDJvQVkvKzFDZ25jSzkxM1l0ZjhKUmhTUUVaeENzZ216ZnBrYktBYTZI?=
 =?utf-8?B?c2hzeVB6V2FVdDAzdGlCTlFwTEdvL0lCU1NWWG9JTUl4VXZDNlMwdVFDbVk0?=
 =?utf-8?B?MktZTjFFZFN6RU9FYlUzQTRxWmNoRmdQWnlYUlR4V3E4amtkYUtwNXRJWDRY?=
 =?utf-8?B?WUZhSWoyQmxEZEJ6NStmRVY4RjVXTkRxcjA3NTZxcll4VjArMEl0ZTdUc1Ns?=
 =?utf-8?B?WEdNRnVXZkJaRldTdjFoTzJ3VnNMN1JvWmRsUHZMMXN1dTBEZ3F6NzJsQ09D?=
 =?utf-8?B?VWV4R2Y2eUxCZysvcWU2bGNMYk0wZVlsakV2TkZ4bkZORlVqUW4rT29xNm1m?=
 =?utf-8?B?cllZMUlLdzRlOEs0WUhibDFJTmxzdmFvcjlKTjAvN3J5UHl4TEkyQVU3QzFj?=
 =?utf-8?B?UDZqNml2bWZUcEtKZm5BNnI4U3BuV200VGxBS3hZVXMyRkxJaGhUeVYraGN2?=
 =?utf-8?B?K1EvaDRLUDE2Rk0xaExFVVNFQWZZM1YwK05qcko3ZzlackprSWdWSWxxeVFm?=
 =?utf-8?B?TncrWlkvTDZIdHhadjcwMTJyZlZlamVkVVF1RmNwTWNzL3pZZjV0bVZvdlh4?=
 =?utf-8?B?eFNWVWo0c0d5NGNjNW5uNVhvanlNYjd1SXowVmZkbkh1YTZMN2RpSVZDN2Ru?=
 =?utf-8?Q?uOt8uIz0Ly6sTIzetBCe0JB0F?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff5d38b8-37c5-4fc6-bdea-08dde3a03ea9
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2025 06:25:54.5960
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MXsA4S+g0OMkAeVUVrENxbqAch+s3kYSXZsy46SnqxrGaxaM7g+q9rS3imkIsklm+eCJzTJRkILztuUHd1dF7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5654



On 8/22/2025 10:58 PM, Borislav Petkov wrote:
> On Mon, Aug 11, 2025 at 03:14:35PM +0530, Neeraj Upadhyay wrote:
>> Subject: Re: [PATCH v9 09/18] x86/sev: Initialize VGIF for secondary VCPUs for Secure AVIC
> 
> "vCPU"
> 

Ok

>> From: Kishon Vijay Abraham I <kvijayab@amd.com>
>>
>> Secure AVIC requires VGIF to be configured in VMSA. Configure
> 
> Please explain in one sentence here for the unenlightened among us what VGIF
> is.
> 

Ok. Below is the updated description:

Virtual GIF (VGIF) providing masking capability for when virtual 
interrupts (virtual maskable interrupts, virtual NMIs) can be taken by 
the guest vCPU. Secure AVIC hardware reads VGIF state from the vCPU's 
VMSA. So, set VGIF for secondary CPUs (the configuration for boot CPU is 
done by the hypervisor), to unmask delivery of virtual interrupts  to 
the vCPU.

> Also, I can't find anyhwere in the APM the requirement that SAVIC requires
> VGIF. Do we need to document it?
> 

I also don't see an explicit mention. I will check on documenting it in 
the APM. However, there are references to virtual interrupts (V_NMI, 
V_INTR) (which requires VGIF support) and VGIF in terms of functional 
usage in below sections of volume 2. In addition, as event injection is 
not supported (EventInjCtlr field in the VMCB is ignored), virtual NMI 
is required for NMI injection from host to guest.

"15.36.21.2 VMRUN and #VMEXIT

...

The interrupt control information loaded from the VMCB and VMSA for 
Secure AVIC mode operation is the same as the information loaded in 
Alternate Injection mode. "

Alternate injection section talks about the interrupt controls:

"15.36.16 Interrupt Injection Restrictions

When Alternate Injection is enabled, the EventInjCtlr field in the VMCB 
(offset A8h) is ignored on VMRUN. The VIntrCtrl field in the VMCB 
(offset 60h) is processed, but only the V_INTR_MASKING, Virtual GIF 
Mode, and AVIC Enable bits are used.

...

The remaining fields of VIntrCtrl (V_TPR, V_IRQ, VGIF, V_INTR_PRIO, 
V_IGN_TPR, V_INTR_VECTOR, V_NMI, V_NMI_MASK, V_NMI_EN) are read from the 
VMSA."


- Neeraj

