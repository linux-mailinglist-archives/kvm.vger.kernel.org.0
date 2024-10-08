Return-Path: <kvm+bounces-28099-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 19841993E4A
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 07:22:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 93FB91F244C3
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 05:22:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9BBB13AA4E;
	Tue,  8 Oct 2024 05:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="R3wip+TE"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2054.outbound.protection.outlook.com [40.107.95.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C6D41DA5F;
	Tue,  8 Oct 2024 05:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728364965; cv=fail; b=LjcxwtY9NX+bSgKQbZoTZaNURa8UG9BE9ngMXvz+3paeQtq+vj4sNDPsHMxRONOGjv/UkbYEHuI8w8fc37s7gIPRvfuE/VENiZOFAvTGuCOOw30GjuCwIfDuWnfKENjPwBtxrfK8uuZemhJGyOINgYp7YonRg7hV3lmeGko3VN4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728364965; c=relaxed/simple;
	bh=2L1P6AbAtagjiwA7LmdepHq2DAoabYP5yZj6bHeLuzs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=D4hfjSrAY+g7FADDblQ2BDEWjc5Z95aRqJbnlhg1O7NUwcitSaeD6u34yKWHZn7oTE5trlWxRC/VsZ4ypuYNNvkBTHGZGhBJFgk9pN070408eADgROqrivXNoinI5iPD+miizn99NdQORtinJkKFBYAAFIjnc+5+PWDJEQsYvuc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=R3wip+TE; arc=fail smtp.client-ip=40.107.95.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y5GeXmHOSS59mXjIHJOfvCa/lqzi8NTbkcAtaYJSTaqgAW3p5f/y8guud4RsEZse+OQ/S8gewuFICWWJGMoKyefFWxu8rEJ9b5l5R55kjgKxXLgdEsKSIh6k2Ub1IGZkmpnKRcKWKETXft5ooOSgKksfZR72fqlb3Z4ysCzTfoOun7Nujzc77FQ8qVQd+LHJ0vhPJOJ0UziZps+MvejrFlOaFhua09G2shv4E++DM26dNLMDKY7DcgjknlSXn6+kPMjbSmmHi07Bz3wC0bwOKGja3zxgjOICMS3OhWY+EqfxGo7rdWZHAh5FrxzGlVyb/xKGleh7OgfzNsmNU+ZhHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MMleAi2yuKAhRj7bkZ1ovCm+5PE6+SEFXIttlM4A9/E=;
 b=Q2VG1R32TZruqVvlTK+Py1E6lrpfq4PI/N41sY22oOsVhuCQx0O2dCOqTW9BlvaAqmN58Cs3d8hqCEyCB4KWhSs+/8ZqhNJ3vjgyFxX5nut1U2H+VEWOfp1Vu/6GjowK2EMDmZ3YyzdyWKP8HjARQJOcvFokg9+tNxV27IkIgty5w/2GSqcLXjDy9zBMCFUlimcFLEJ290oJCFv2eSwH0xjxmMweTlGOnfvctDi5nlEPV7Tp//WqVLkDUaQzt62h+tcPmyqEzLW/3D0+BYwHl/kxUq2zwcSh279J+AJ+Lly0FI9FJFWHN9eBkbPIZW7EML1TfgT/2Zaj85aWe3y9MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MMleAi2yuKAhRj7bkZ1ovCm+5PE6+SEFXIttlM4A9/E=;
 b=R3wip+TElw1rhuFbAx5Z4ePbxAfCjV+KSwMltq7LbIcwMu6eX1kWUxLeWhZ7F52klpMCO1RJbzbywsJxLKkZATnQwxpajStjZ2wk9YMar3F9nqXUQYsQG3CIS96KB7seO9Vxyk9hpNa46h//oCFF06vzw3wfwDtb9mSKMB1OnO8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6214.namprd12.prod.outlook.com (2603:10b6:8:96::13) by
 SA3PR12MB9107.namprd12.prod.outlook.com (2603:10b6:806:381::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8026.22; Tue, 8 Oct 2024 05:22:41 +0000
Received: from DS7PR12MB6214.namprd12.prod.outlook.com
 ([fe80::17e6:16c7:6bc1:26fb]) by DS7PR12MB6214.namprd12.prod.outlook.com
 ([fe80::17e6:16c7:6bc1:26fb%5]) with mapi id 15.20.8026.020; Tue, 8 Oct 2024
 05:22:40 +0000
Message-ID: <13d192bf-8151-415f-b508-7a4ebe4766f2@amd.com>
Date: Tue, 8 Oct 2024 10:52:32 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] KVM: x86: Add fastpath handling of HLT VM-Exits
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Manali Shukla <manali.shukla@amd.com>, nikunj@amd.com
References: <20240802195120.325560-1-seanjc@google.com>
 <20240802195120.325560-6-seanjc@google.com>
Content-Language: en-US
From: Manali Shukla <manali.shukla@amd.com>
In-Reply-To: <20240802195120.325560-6-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0029.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:97::18) To DS7PR12MB6214.namprd12.prod.outlook.com
 (2603:10b6:8:96::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6214:EE_|SA3PR12MB9107:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b055315-e713-4e05-7a40-08dce7593a6b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Sm4xYmY0UkRZOWhSQi9BTEFjR0huM1VZSzNVUTg4TGpLZ0ZpVUZNaW92aElG?=
 =?utf-8?B?Sk8vTGEyNU5VaEpqdksvdDBVQ1FYUEFmU2xUMmFtdERSK3A5UzRUbU0vOHYr?=
 =?utf-8?B?VW1paDJ1WlFSMEhLbXJlYURwL3dHOXRuQlhmTFZjMmNhTWt6Z2V1U3FYeDc1?=
 =?utf-8?B?RVEzZnE1aUtpb2JqVGFQUFNFNnI0ZjRkTnQzQ3YvVG9xRS9CYldjSGpnQ1o2?=
 =?utf-8?B?NDdweDlmd2xydXZwNlM4SFRsYVlIQ2V5Zy9KSFd1MVhEcTBTSUtyclZjK25S?=
 =?utf-8?B?NkFxMHBURUhqbnVWS3M4dzZOcXAwR3VxOXRwNW0velR1TmpXalJaMUQ1aUtB?=
 =?utf-8?B?VW9zTWNhMlorK25oTnFHQ0tOLzNJdW54MGorTzZrQ2xlOGduR3lDVzhuMEla?=
 =?utf-8?B?ZUZiRmNMNHdtVmVsTkRnSVZ4cVZwV2hYR0RwSnhoeFhWanZiNUp6QTg1emNp?=
 =?utf-8?B?Z1BUWFE0c09kQjBqMlNxaFNjS205UWlUdVI5SjIrb2ZlQW9zemNCaHVraTV5?=
 =?utf-8?B?cmJLdit4R05lN290dVl6YnFnVEpRSkQ0eEhFa3hBRjU4aXlXLzExTWhMYnBa?=
 =?utf-8?B?YVRNZW1Td3ZOTzFiSWl6RjM5N2lrUGtjdDIzNWoybDhOempwTGlBSmFJaW9F?=
 =?utf-8?B?TWpvcTRIVStkNzdFUGliT0UxTTRBaElialVmUkZ3TzcrSDdpMmJPSzh4TUVF?=
 =?utf-8?B?eW1FbDdrcnVNODZLNVRJU2RoalQxemIxVXIwUnlpa0h1RnNUamtWWGdLeC8w?=
 =?utf-8?B?cXdJV0x6U2FyWnFORUhNWHJJUXFmTWdrMlNSVWM4RU91WklUcGdVTmdMRFNE?=
 =?utf-8?B?alB0QzRMVDM3MEZXbWcvWnBEYitrQURabXcyTk51Y1dmNlhULzkzTWxsb1Q3?=
 =?utf-8?B?cmhJR2x4WGJxblVMSGxtdTQ1VVpTdk9qdlc5eUI5dmFGbVdvS1BOV0xaSFNY?=
 =?utf-8?B?OUo5anhCdnhiMm1jYk92QzdQLzZaVlU0bXNQMUZTVjJZeUNieVY4YWhXSEdS?=
 =?utf-8?B?dC9Lb3ZwRXpOQ0ljeXNPWndTdG42Y2gyYkFRUW5WTlRnZitiVkxta0htNFpy?=
 =?utf-8?B?ck52QUdsR3dCSHZVdEdZUVJqeXBoRkR6REMrTFBxSGZUek4rM2I0SC9FT2M0?=
 =?utf-8?B?ZnhUZUMxbUVhZWlzeW5pVTRPWXBJTDZFaDV3ci9JMWpLSWUzYTV5QXFKdzRh?=
 =?utf-8?B?K0RwUzQwOG1BR2ZGNFJDakFDRFhVWUMrYmVLQ1QrK3dmeG1mVjJHMHhjN04x?=
 =?utf-8?B?UElEenp3b2dBVnRKdHJKam9RNXYrTS92ZWd2Y2xZdmk3a3ZaRlR6Z2FvVUJa?=
 =?utf-8?B?YWJsMnIzamw1UktEL0c0TEh0QjJUWHJMMXFpVUVGbzNzZmNjSVlpN3lGZUpi?=
 =?utf-8?B?V3dhM3NYTmVJRm1UdUhWVGFHTHJ0NVZoR0V0Qi9TOVBTdU53WkR2bnNiZHd4?=
 =?utf-8?B?NVVlUVBXbEhCOVJqcnJqdGdwUHRvZSt0YjY5eStaMlJpVTNBVHRicUxIU2d3?=
 =?utf-8?B?Vk9VUXhkVGVjSlFaWEplQnlJYSt6bjhNdTRBd21DSEJZR3d1dTkxOE9rKzZw?=
 =?utf-8?B?a3BpemVtbFVhTThta2JYMzU2WGZmcmdSSHAvc1JlYlJzYm9rVjBRaC9wQWVr?=
 =?utf-8?B?Y2NqU3V5NFJncWV1dEpjakVQalpRYlRJNERIQ0xOT0huRisyV1F4NWMwaExI?=
 =?utf-8?B?dDZZOXRlOWZCSlU2L1pJK2VmdXk0MW5SSjJuUXZQOUwzWS9URGx0a2RBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6214.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RUk5RURTR1E3dGd1RkI1d3h6TlhDVFhubUNaRlBTT0dYTlpBeitmcUVzcVJF?=
 =?utf-8?B?VnZJMU5iUjhKWDlTM21BWWExano5dkRSVjFQYW1HS2JwV3F4QitUSkFqVGRO?=
 =?utf-8?B?MTM1L0lXT2VtTFZ3UkVhK0x4eEtKSWJTK1lkcVBYdnJEYWh5V3JOMm5qT2pO?=
 =?utf-8?B?NUVBeUlRcnBvUGI5UzlicmVSMjBqd3lRR05MeGtmVTJybTFWZ3c1ekgvVmhw?=
 =?utf-8?B?cnoxR0NmeEFpV2dqZmFxQUt6cXovTWtEMDU1S2lRQzBDTnd2RWNQanFNV2cy?=
 =?utf-8?B?bEdKZE5CcXJCbGxMZ3FPa0hQZ1ZSLzhrRnJ0N3JocWJBMFVmZDlDMVZLRzYw?=
 =?utf-8?B?Mk5iSHlBTTd6Y29yRFBaTzNNZVhVL3RoeHo2SE9QazlmSUZ3RXFOVnlIb0to?=
 =?utf-8?B?V0kyL3BoOVJZTE4vVFFubUR5bm00WFdrYzY0by96Skg5RllzSUI0TWdsMUxZ?=
 =?utf-8?B?OHdYdUpaTVFtVjl5VFpNQmhjNGpISFpTd0VtN3BQRFM0clJqNUxMUU96OURW?=
 =?utf-8?B?dlpWdmd3YytpbmlvbFpOT0dIUmltQkZQOUQ1OFE5NGpyOWZXTTZScmlNdWEx?=
 =?utf-8?B?aHlnNGVzS1F4TnZoV283b1dLMnZTS295Yi9nSG8wVkpJTExsS1NwZXJwdzRz?=
 =?utf-8?B?c0xIYkNnb0w0amxZZTNSWjZZUUt1ZXhIRFplMnIwejQwVUwwcy9SejdHV0hF?=
 =?utf-8?B?dVRPZjY4WGNMZE1aKzRlcTlDUFZrckNkZGFSYmRicTlRc2tDYVg0d1pTQmVq?=
 =?utf-8?B?Zm1lN29vLzNwNWk0UEo5dGRqUG1wS1g4UUZybnFZV2c1Sy9ERGR4RHNJL2Vn?=
 =?utf-8?B?RURzdWYwU3VHYk9mM2tnRy9OK2tCV1UwRjZMN296UlphdEVrc1JTR3ljc2ZX?=
 =?utf-8?B?bUdhclZ3K0FZUmwrOHkrRkUrUWVGLzZ6N2k0SmF4bklNMnJwOUlFL0JEdkdk?=
 =?utf-8?B?R3BtTkl6MUp6M2lrTlpTVWt4TmltQlQxanYzL2oxRzFpN1RJSVk1dnIyYUVi?=
 =?utf-8?B?c2ZIamJaNGpUK3dXTWFxanBwcU11cm5FNGNySmRxZVROdGJYWmpvS21meTYv?=
 =?utf-8?B?cTlwRU9UaFZUNTIvYXZyTStMbVlXcUxDQWJ6RFI0Z0pMQ0lWZW1TTTRPSEh2?=
 =?utf-8?B?aHp6WjJqNEFpTGlMMStJTjBybjFGSU5TY1N4d1BhQTRtT1RQRG9kNUhkYy8w?=
 =?utf-8?B?ck5NeWJGb1NEYW5xMDJpS3I4eC9zb0hJbnVlbTBzdHdjV0xwZjB4MzFMOVhT?=
 =?utf-8?B?Nlc0dXJ2c3JkNmFSWFd0ZE40ai9nWDI1Ri80MVA0dlhBZEU2VHp6ZURialVF?=
 =?utf-8?B?c0daTnJzZXg2cGtmUHZiVzZlOE9IOXFTeWU4ZHRKa0VSeEM5WFdLN3k0aXdp?=
 =?utf-8?B?YnBsZXFrSTVTc0NkZGtXbGJxRkpHMVJsR2hQaG5sUzlFTHJwM3pzSUUyWml6?=
 =?utf-8?B?NlI3dlM1MmJ3a1Y3TEw0RXN5VU15N1ZiTG1CU2FFbDJDWmNHQVo2UHlQMkhJ?=
 =?utf-8?B?ZllBK1NvRzVVdHNrZnl4Q3dZdlA0QkRMclkySk9LazRlbEFGd1N3d0JiSUww?=
 =?utf-8?B?emx4UGUzcDVQVGpLSDA0UjRwNTlvcTRKZGg1b2FhaTlzTjdndzFOWHRZckRx?=
 =?utf-8?B?L0VCcFE4Q0pZS0pIYXNJVURlZC9VQkcxL3QrZUNocWtuWEhQVTdESld1dzNQ?=
 =?utf-8?B?b3lnUUxWY2lNNWoxMStBeVplVUw4aDdWU2t1M2NaWmZMRStHZ0JzbGtwQVli?=
 =?utf-8?B?eVQ3Y1FRNWo0MEVJMFJJWmhGMlpjaDlwKzVDRHkzVVBPZjdWSk44cG43Rmkv?=
 =?utf-8?B?T3ZVeDVQeXVQNzM0RVRsYWdnTGdWSGtiL0FaTzdzek52dXRVdjlQUXg5cXNQ?=
 =?utf-8?B?V0xZb2dvQUcrL2FMNjcvZVVrY2lzS0lhMlVtUURqVE5yakVmWXg4NStNRWVu?=
 =?utf-8?B?NFJSbEpzMzhkSkdJb1piejJoZkszVUJ2cWQxaHR5anByWWVxYnNVV2FFR0Vs?=
 =?utf-8?B?RzMwQWxYTHJSMFVSblI5TEttakZGMzVZZjR5bU14TWJFRlNGRE1XenRySjh3?=
 =?utf-8?B?RFUxWUNxUUZMQTVNalhPYXBCbWhRY3VkZk1LZGNBRytNMmZQQ21pRU1wcWFu?=
 =?utf-8?Q?m83vr8JQa0KJKwwkcJZwT63Ng?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b055315-e713-4e05-7a40-08dce7593a6b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6214.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2024 05:22:40.1438
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E7Y6w/4gJM36JdW7gFSXtQPc/Zxf/r0jxADfnpTZEcB9M9hlzJ3egs5AQhuICOcwCaYkUGhLNoirxfcv7DzN/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9107

Hi Sean,

On 8/3/2024 1:21 AM, Sean Christopherson wrote:
> Add a fastpath for HLT VM-Exits by immediately re-entering the guest if
> it has a pending wake event.  When virtual interrupt delivery is enabled,
> i.e. when KVM doesn't need to manually inject interrupts, this allows KVM
> to stay in the fastpath run loop when a vIRQ arrives between the guest
> doing CLI and STI;HLT.  Without AMD's Idle HLT-intercept support, the CPU
> generates a HLT VM-Exit even though KVM will immediately resume the guest.
> 
> Note, on bare metal, it's relatively uncommon for a modern guest kernel to
> actually trigger this scenario, as the window between the guest checking
> for a wake event and committing to HLT is quite small.  But in a nested
> environment, the timings change significantly, e.g. rudimentary testing
> showed that ~50% of HLT exits where HLT-polling was successful would be
> serviced by this fastpath, i.e. ~50% of the time that a nested vCPU gets
> a wake event before KVM schedules out the vCPU, the wake event was pending
> even before the VM-Exit.
> 

Could you please help me with the test case that resulted in an approximately
50% improvement for the nested scenario?

- Manali

> Link: https://lore.kernel.org/all/20240528041926.3989-3-manali.shukla@amd.com
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/svm.c | 13 +++++++++++--
>  arch/x86/kvm/vmx/vmx.c |  2 ++
>  arch/x86/kvm/x86.c     | 23 ++++++++++++++++++++++-
>  arch/x86/kvm/x86.h     |  1 +
>  4 files changed, 36 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index c115d26844f7..64381ff63034 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4144,12 +4144,21 @@ static int svm_vcpu_pre_run(struct kvm_vcpu *vcpu)
>  
>  static fastpath_t svm_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
>  {
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +
>  	if (is_guest_mode(vcpu))
>  		return EXIT_FASTPATH_NONE;
>  
> -	if (to_svm(vcpu)->vmcb->control.exit_code == SVM_EXIT_MSR &&
> -	    to_svm(vcpu)->vmcb->control.exit_info_1)
> +	switch (svm->vmcb->control.exit_code) {
> +	case SVM_EXIT_MSR:
> +		if (!svm->vmcb->control.exit_info_1)
> +			break;
>  		return handle_fastpath_set_msr_irqoff(vcpu);
> +	case SVM_EXIT_HLT:
> +		return handle_fastpath_hlt(vcpu);
> +	default:
> +		break;
> +	}
>  
>  	return EXIT_FASTPATH_NONE;
>  }
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index f18c2d8c7476..f6382750fbf0 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7265,6 +7265,8 @@ static fastpath_t vmx_exit_handlers_fastpath(struct kvm_vcpu *vcpu,
>  		return handle_fastpath_set_msr_irqoff(vcpu);
>  	case EXIT_REASON_PREEMPTION_TIMER:
>  		return handle_fastpath_preemption_timer(vcpu, force_immediate_exit);
> +	case EXIT_REASON_HLT:
> +		return handle_fastpath_hlt(vcpu);
>  	default:
>  		return EXIT_FASTPATH_NONE;
>  	}
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 46686504cd47..eb5ea963698f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11373,7 +11373,10 @@ static int __kvm_emulate_halt(struct kvm_vcpu *vcpu, int state, int reason)
>  	 */
>  	++vcpu->stat.halt_exits;
>  	if (lapic_in_kernel(vcpu)) {
> -		vcpu->arch.mp_state = state;
> +		if (kvm_vcpu_has_events(vcpu))
> +			vcpu->arch.pv.pv_unhalted = false;
> +		else
> +			vcpu->arch.mp_state = state;
>  		return 1;
>  	} else {
>  		vcpu->run->exit_reason = reason;
> @@ -11398,6 +11401,24 @@ int kvm_emulate_halt(struct kvm_vcpu *vcpu)
>  }
>  EXPORT_SYMBOL_GPL(kvm_emulate_halt);
>  
> +fastpath_t handle_fastpath_hlt(struct kvm_vcpu *vcpu)
> +{
> +	int ret;
> +
> +	kvm_vcpu_srcu_read_lock(vcpu);
> +	ret = kvm_emulate_halt(vcpu);
> +	kvm_vcpu_srcu_read_unlock(vcpu);
> +
> +	if (!ret)
> +		return EXIT_FASTPATH_EXIT_USERSPACE;
> +
> +	if (kvm_vcpu_running(vcpu))
> +		return EXIT_FASTPATH_REENTER_GUEST;
> +
> +	return EXIT_FASTPATH_EXIT_HANDLED;
> +}
> +EXPORT_SYMBOL_GPL(handle_fastpath_hlt);
> +
>  int kvm_emulate_ap_reset_hold(struct kvm_vcpu *vcpu)
>  {
>  	int ret = kvm_skip_emulated_instruction(vcpu);
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 50596f6f8320..5185ab76fdd2 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -334,6 +334,7 @@ int x86_decode_emulated_instruction(struct kvm_vcpu *vcpu, int emulation_type,
>  int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  			    int emulation_type, void *insn, int insn_len);
>  fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu);
> +fastpath_t handle_fastpath_hlt(struct kvm_vcpu *vcpu);
>  
>  extern struct kvm_caps kvm_caps;
>  extern struct kvm_host_values kvm_host;


