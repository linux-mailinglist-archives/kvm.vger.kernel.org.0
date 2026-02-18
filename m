Return-Path: <kvm+bounces-71260-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mHW9DCzxlWlTWwIAu9opvQ
	(envelope-from <kvm+bounces-71260-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 18:04:44 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 928A11580B7
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 18:04:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AC560303FDD7
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 17:03:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75D41344D9A;
	Wed, 18 Feb 2026 17:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="gM+W16Zm"
X-Original-To: kvm@vger.kernel.org
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011027.outbound.protection.outlook.com [40.107.208.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A07832F766;
	Wed, 18 Feb 2026 17:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771434207; cv=fail; b=VQHO+8hS1tjQikYZJUrcqZbNHTdLt29+QP48xFDR/hXIeJinz/LBmbzJXm8jHfGEYn25KWOY0bz7ueP1p/xkRXauydx5dFWQu7jou61hi1kU5ha1yfilvdfzGxuvV/fiDycCVeZNkCx01GCH5NmYSa9sy8KskouvcabCJFY95ns=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771434207; c=relaxed/simple;
	bh=eVCXPxnd2LWKo2Dv3uYSsMSH9IXqz4LmmtNlnPmrOAE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=k3a8S0HZjFBXrZ6/5/Um4mCYG/Mok2OmuGPoY5Pz+/8MSE50UYN4R4Rr2nF5/D9JlPUPwe+KuvEFeknjNvAXiX/njYjMWZAAYD0pvaJudJEhHNG864Ckw5PpEdlA4Pu8SA3jVlMkR0z1yOcfJm+5NKqekdqB27V5IOLVvBl0vQA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=gM+W16Zm; arc=fail smtp.client-ip=40.107.208.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n6JI+HTs9OHv51PrAEr33XiRLrVwXe1uoq2GK1BnvM83PzgaCp2QhXkpDywjfVTb0KShOMQ8DCa+t5aWS61A+R07qUSpm2gEKDajpz5HWcRfxcTyvuPyz8hFB8JM0thag4xBgVM7jZn2B6/1tuXiDADSiSbLK3tKnCE6oIPCu5jX1QAj3tGDsfpual9xXLvBRVZ4EoUivns/MRtTeqXY3o0IgubAvrAPyBvcteVUigBIactg7cwq1ql+cTVHJb7iquQ7Cor4WsJ0KgxBMbEhlBVNq5izaXOEwZlAAH6gzsBYQyl8WqRJkRUCWo4lwJh94kQa8Tc5eHd8YXJDRAyuYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qFadgdCew5O9OcA8rvcLAuoynsrNi1yLbzWdE+VyIeA=;
 b=QLfIyzE6DJy2+Z9h1061h2lQ792OarmcdT7l+nU+hnh1B5/tMOiw7wm/a1Yc3QQChpdg5IybSPO6hi5hErjyVULUgcRpKw/s9ciADVist8zQHgjpCTECT1iE/lgn9hpvb2B8QjHGHmW7cM0j9UBt8G4NA7+TpB1XzWPb6Etshx6mRJkSBO1NFxcVoSPulejYhr639CSeumtmo2djk+pYZ/0BUjqJDfC9gJ9dfU0ZAHDOCxr9xGjZ3wdLsww4BY7rkk+i2Wvi3cC16uIuvhFpHi/xqlGvDd/WSiVM9HzmS1zE3Xmb/OIhMg7ez0Xpw4aJkrm08wI4zCuBPQnKjyQxZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qFadgdCew5O9OcA8rvcLAuoynsrNi1yLbzWdE+VyIeA=;
 b=gM+W16ZmLIndgft0NbyERnZvS/VARvypYzQU5J7B9nbqe8fsP/jKFJtx6MxJ3jQYUZs2CHcA9O8gGrJyRF7osdHmyevJYOlVwgrdWyHC8rOAmzJ6/Xo+Q3bvwcw1VFkiShpuxKs3I5rcCedojyr3BAV09FlY+IODp3so10+t0EE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB9066.namprd12.prod.outlook.com (2603:10b6:510:1f6::5)
 by DS0PR12MB6557.namprd12.prod.outlook.com (2603:10b6:8:d3::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.14; Wed, 18 Feb 2026 17:03:18 +0000
Received: from PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::f71e:4264:146c:b356]) by PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::f71e:4264:146c:b356%6]) with mapi id 15.20.9632.010; Wed, 18 Feb 2026
 17:03:18 +0000
Message-ID: <cc930514-b0c0-4b9f-8287-aaee2878e668@amd.com>
Date: Wed, 18 Feb 2026 11:03:14 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/6] Add RMPOPT support.
To: Dave Hansen <dave.hansen@intel.com>, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 seanjc@google.com, peterz@infradead.org, thomas.lendacky@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net, ardb@kernel.org
Cc: pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com,
 jackyli@google.com, pgonda@google.com, rientjes@google.com,
 jacobhxu@google.com, xin@zytor.com, pawan.kumar.gupta@linux.intel.com,
 babu.moger@amd.com, dyoung@redhat.com, nikunj@amd.com, john.allen@amd.com,
 darwi@linutronix.de, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1771321114.git.ashish.kalra@amd.com>
 <9c77e206-442d-4891-bb29-295bc8bffe20@intel.com>
 <65986f9e-59e8-4f1c-aaa7-1edf45af24d8@amd.com>
 <31b42ba3-dd0c-42e7-ad1e-800c5cd2bcf8@intel.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <31b42ba3-dd0c-42e7-ad1e-800c5cd2bcf8@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9PR10CA0017.namprd10.prod.outlook.com
 (2603:10b6:806:a7::22) To PH7PR12MB9066.namprd12.prod.outlook.com
 (2603:10b6:510:1f6::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB9066:EE_|DS0PR12MB6557:EE_
X-MS-Office365-Filtering-Correlation-Id: 7458e8a8-2b6c-4596-f9e9-08de6f0f9cf7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?T0hkQjFyVXpCeDZUd0FMZGdCY0xkL2dKQVBWSXpUYjF3MTViaEQySCsxZ0JO?=
 =?utf-8?B?Uy9qUVUzTUNSdWY2UXBBMG5CZnZaWnFIV2JuTDYvc3lQM0x6Vmk4UkZxRUFI?=
 =?utf-8?B?NTNhRWFTb3ZQT3RzdzhsM3NZeU9EVE9VRW9KclNnK2hXbVNEczFGUTZNcDRW?=
 =?utf-8?B?a0FKMkZMTWMxajJlMTdvZlhNQlNsNTNseFkyYWFqaXRpZktOMEdJMzg3K1Za?=
 =?utf-8?B?a3FyWFVxV3FkZDhIY21EemR0S1JjL2Z6YW5GdEVYcEF3QkFPRjJrWW1yRTNm?=
 =?utf-8?B?Z2NCTUdhdkM2T1JQYVRKeDFxSzMrYlRUR3R5OEFEVncyV1lXWUZDKzhMdzVB?=
 =?utf-8?B?c3V6SHNQUW9mSEFCK0hKZnFGR3pySmFaWi9nZGtwNXZUblpkbVVlNDAvV0Uz?=
 =?utf-8?B?bklrQXBDRlB6ZzZSajErQmZ1TURBa1ByMUQ3alRSZUgzVnJoc0ZIN0g5UXRm?=
 =?utf-8?B?QTd5UCsxRHFtYU5Jekd1MUtJc0tTTVp5ZUh4c0sxeER0bWRsWmtIdnVRaXMw?=
 =?utf-8?B?eFlISUgvRmE4R2Vrc09lUWRuTjZmVk16OXVaakNrRk91K1R6Y3llY2UrM0Yw?=
 =?utf-8?B?N0Z0MVBIOExzTUxUd25aSEYrWGo5U3VxcWZUT1YvWmltV04rRGF3eU52RkVC?=
 =?utf-8?B?ZUlQOG9uUjVKU1RRRGN5R0VSQmlqMGhzR1ZUZWQybTM4eXorOHZzRlZwbHY2?=
 =?utf-8?B?UWp2MmFBSnUvMlJDK0lUUnVHR0ZnaXJyNW1keFlxTDdueHFPRS9SRVNHVjk3?=
 =?utf-8?B?NUtmOEtEa0w2NkZMMTJqdnFuQXllcUJaYzQ4dXdFZmdrYXlYc01FSmlJOFhJ?=
 =?utf-8?B?VEROYU9VQlhpRTlUR3R5STdGNjVnbUNjaFhvQXdjVWtEUVloajRyVFB1TGlr?=
 =?utf-8?B?SUwzRXpLOHlLVmhzd1ZYbUNTaksxTEFWMHk2bnpoczA0WEF3SUxtZlZzRGkv?=
 =?utf-8?B?T1BLT1dBaDhwTThrZWs0S2VFSURtYUhDN0phNElSRkFnQnhKQ1BxYWV1bE1h?=
 =?utf-8?B?YVdzU1RNR1pLNmdBbC9NSTZHY21Wa25uRUtHVEcyYkM2Wk96cU84a09Xa3pV?=
 =?utf-8?B?OFV2dHVsU1ZUbGsvWkN6ZzRjeGpjSEFpcFFRQytFNnNXTmpDbW5VSjVFK0dk?=
 =?utf-8?B?L2JsMVVqOXpOamxHMGpOL1VYQkQ0VEQyd0dKaFFqUm5pM3VPU3djTlZudmJj?=
 =?utf-8?B?SFhNR3pDSlA5ckx6aTE0MzBNcXBPZlRWaDJIL2U5Wk9HWnEvKzB1YnRrVkF6?=
 =?utf-8?B?OEVXNlZiUzJLTU5SeVVON1Z5SnNtZGNwYUhlU3ZYeWJ0amRPVnZKbmRNbnpu?=
 =?utf-8?B?MXJuRTlsc1dnRHIrbEdWUktyRDNCS2FibDlhdWpiWG1YcVNzaEYzS2I5OHNL?=
 =?utf-8?B?YWtGZDlUVTRQclFyUm5mOVpxUXlCQmN5Zlh5SUNFbE5IbGVsekxjMVJKU3BS?=
 =?utf-8?B?Y09mazlzRi8wbnlQR3hzYy8vK0NTTTZHQjM2cmU5VC9iR3RTSUx0bkRac051?=
 =?utf-8?B?YTViV3VxTWkybmplZ3liSXZuK2l1M2JaczRuMHNiTzNTMFljYXpiUWVhVzlQ?=
 =?utf-8?B?NFdTR1pQR1N4UWNML2FxVUhaRnFDc05LVUdONG5HT3RLcXdxb1JkaXl5cS9N?=
 =?utf-8?B?WUZSYmozWGFnTDBrcVMvRjZPWllLV0t4dmYwL2hhNUNvWFM1WXl4K1BvYW5Q?=
 =?utf-8?B?U2lTWkFqeUNWSXczaEgxeDlWNTFyb000cHQ4SkVUVFlaaSswQU1vU3g2YzBR?=
 =?utf-8?B?M2FjU0JwcDZKVlJyUUNhWWpLallMNE1SMGNDMlNJeE9KOXB6MXFEY3dPd1JH?=
 =?utf-8?B?TGJEQXJXWCtFNm1sSGZvZFJEYnA3TVpFTmRvaWRPcEhNZWVIL28wbTVwdisz?=
 =?utf-8?B?U2hKVnBZeHdCdXQ1TCs0aDg5dTNYNnR6M3I0V1FjMStsOGtYaFpodGFQWmFX?=
 =?utf-8?B?eWVGckozZTVwTkxJTTVRZVJLNTFwaXhqYlg1U0lEK3dvbkdFd1BtSTBreE5o?=
 =?utf-8?B?L1FmWUFqczF6c3ljVUhIbnIzVjJ3YUh4Uy9pYlRURmI5QjAwZXJlUmlnZXVn?=
 =?utf-8?B?SWpFQ25WaVZSSFBKUklLdUdFeW1xVndWeEFEYVBucFo3VDduYXVRbExiM25V?=
 =?utf-8?B?Tmc2L25SV2xqb044TW9jbXhCSjR6MGZGQmxmYjRQSEpoRVIrdDkwRlllYmQw?=
 =?utf-8?B?aGc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB9066.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TkxMbjhRRDFYV0doRndWVWpKMHBrTFJ2SmtMK0lLSDZSa0w5b3Jjc1BnSCs5?=
 =?utf-8?B?UGhMOTNwMnNmck1pSE1ZSW9YbkJldHNscVh5Z1JxMkhiU0c3aWRveVNzU0tD?=
 =?utf-8?B?QUZpRkswS25xZnYwR0RMSktGVkE5K0RNV2JBSFhCZU1wQm5ZQ3dmd2JzSDVN?=
 =?utf-8?B?azNITkZ5a25nRFkyOG9OZGRUNDVGWmlnUEpFeGtGM013ZFFDb0xaWlN1L0Z2?=
 =?utf-8?B?aHFKUHdEazFWNExjT3BIUzczM1NURnE1VFZDMUFOaEFuM3kxLytodFEwYkl4?=
 =?utf-8?B?T3NzSytIcTlpQUVWQitvb014anRHRk15bXk5VEU0ajBSeGhJRlNmWE9LZGwx?=
 =?utf-8?B?TkswNjBabndySHlHZDFpd2QrYW1hbUs1Z3ZEaER2N2NVdlRYMUxMdXdWMXky?=
 =?utf-8?B?WXpSS2RoalNtR0pNNnNHU3A0QWUxc1d4Mm1sRGpsaEtVYjVLUXVEdHlSdXM1?=
 =?utf-8?B?cXpBUm56Wk50N05LRUY3dzZ4VEF6MFFKY3Rob2RtRlJTaXNWMUJBWllqc01T?=
 =?utf-8?B?RjdoVVhhZ0R4d2U0NHcvck9UNU92dEc1U0d6YUJYUXpzdmhhMGtRV3ovZkZr?=
 =?utf-8?B?MUpicUFyRGpFM2N1UUE4anAvZ04zSWM3dlRyb3R4UHlBckZtUG9JbGNxbW1i?=
 =?utf-8?B?UWtBNlZrbGl5M0JBOURiZEtMcUV3eStENGpsT1duMFFNajJEZTFYaGJXSUMw?=
 =?utf-8?B?QWU5M0U3SEQwQ0ZnRlNyVFduYjBuWGFSS2RsVEhFZEZIU0VkMlNjMldyWnhH?=
 =?utf-8?B?dkRkU0Q1WmV0SjdVZWR0bEpSZC9KY1VlM3JnWTJDQUlSZWFjTkV0bFZQMVd1?=
 =?utf-8?B?QUpQaHdvL3Q0RXVGSjlvYWxtQUUzN3hna1gxSndhL3ZLTVpWa2hrbnpIMVJU?=
 =?utf-8?B?cjZZaWRtUkpIYTZHcC8vemZDQ0pWZ1BKeEVxK2M2K1JkMTl6TURvY281Zlcr?=
 =?utf-8?B?Rjh4WWdaVlIrbGsyMTFpMGlaK1FEU285N3AwU2VPLzdoK0MxaFdpbXJmdjJp?=
 =?utf-8?B?VGh2UTBkcTZCdEZhRnNXcEw1R1l6MmxCT21WYnJKZmhhNnIvNG9vOTFTZUMr?=
 =?utf-8?B?NVkwR0lTOVpDYlA0U2szZW45aEdCcUdDY0RzWGozYWhjL2NGS0dUTXNFYXow?=
 =?utf-8?B?UWpSWExKTmVvZjYrWmR4QnNlenczNkN0WS94THpwMm9JNGxUTVY5VVdHaGtt?=
 =?utf-8?B?ajBGdENxbTAxM1RjVHRrcjdkUFBOakMvZlV1dWU1MTU5MmZKbWVTYnZMdzh1?=
 =?utf-8?B?M0xsSEFybVo0NUpBTzg5dmFNS3o0ZVF5c29UdUUvYVQ4dVRJMVNtYWR3cGxB?=
 =?utf-8?B?TW1UZUJsSm1xdTc5WkF0R2pHL1QxNG5QRHJ0YmU5VGZ2VnZuN0laZ1Z0Y2lU?=
 =?utf-8?B?NUZkVFdPYURsNllCcDNZdmhSdGh1R0FXRElzc0FweUdicko1aWNnZnVrWHVi?=
 =?utf-8?B?ZHZEZmYxSG5COW1yWjNuR0JuUnFJQ3Q5ZXB4bHhxR0NRWDFqWmRjT1BSOXUy?=
 =?utf-8?B?Y2xWY0FHdGg3cXRXV21HMW1PRjEyS2lrRlpjRnBiY0U2T2tmNHNVSEVOUGZM?=
 =?utf-8?B?WFVnZ0JoN0c2dWFaL2pTdGIrTElwRVl6VzlhQytPRWtKdS9wRG9UZExFNFFV?=
 =?utf-8?B?c29QeFpkaXA0dlZBbkQvTnBPaG5rT2FFV3dEdUZtbmtvdTBScUdSakVsN2xC?=
 =?utf-8?B?ckFIeVRONkFCcEx1SXNiM0JmdG1mZm5tcU5ZUmk3YVpIeFpqaGlXUlZ1akxu?=
 =?utf-8?B?ZEpWbEJWWUpYRkVVcHRlRDdQTGp5UmpYdktIanYzU0k1dE1NdGNkMndSUGt1?=
 =?utf-8?B?N2NQU00wNHNqbXBVWDg5bXRpOUpzUkdNNThpancybjFFTnBFdmdTckYyeFE1?=
 =?utf-8?B?ZS9rSmU1NjV0RDhON011UUtlWnI0NW1saUU1MDNXaTRWdWs0QjdsbFNBTVo4?=
 =?utf-8?B?MVRicTJGQzE5ZTJoU2lDSlpyREdZbzRtR2RvRk9qODVNNTRhUVVlRFJvcjhs?=
 =?utf-8?B?ZDZBS0JOSy82QldSbU1DT1FQNUthSmVucEd3VVhjek1ZdC9MU241ODZ0aGFB?=
 =?utf-8?B?VzkyME80RW12bmwzbTdpdVBXdnRTT0xPRTl1K1IxQmFUR2o5elRhSDFqc01s?=
 =?utf-8?B?NVpTKzAxV3YvMExyQVdWWm5iTHlpR1Q4NkFjQWErSE04M2hQOElFcXBGRENU?=
 =?utf-8?B?WnY5WkNhN0JBWUI0UEtlRGxrb1JEamltZElkekxWdExDb3NzbkE0clJYTzNV?=
 =?utf-8?B?UTRqMVpvTThEZjJpZTRWdWtnYjY0bmVJNFBnYzNTcEtiSlZHVTQzd3d6Z0Q0?=
 =?utf-8?B?cjNRV0x3YmVhZEI2NGRaMDFrZmYxT0FpaFgwelp6dnk3Vko2dFQwQT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7458e8a8-2b6c-4596-f9e9-08de6f0f9cf7
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB9066.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2026 17:03:18.4292
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CQqOIQ0jaYsr1K4koXfVdIXWIbON68a6Hp8HW40PkCfFLP4TL7LtRC4m+ozqLU6xwVZ9YZtPKeVUklpFtX0tCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6557
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_FIVE(0.00)[5];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[34];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_FROM(0.00)[bounces-71260-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:mid,amd.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	PRECEDENCE_BULK(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ashish.kalra@amd.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[amd.com:+]
X-Rspamd-Queue-Id: 928A11580B7
X-Rspamd-Action: no action



On 2/18/2026 9:03 AM, Dave Hansen wrote:
> On 2/17/26 20:12, Kalra, Ashish wrote:
>>> That's not awful.
>>>
>>> To be honest, though, I think this is misdesigned. Shouldn't the CPU
>>> *boot* in a state where it is optimized? Why should software have to
>>> tell it that coming out of reset, there is no SEV-SNP memory?
>> When the CPU boots, the RMP checks are not done and therefore the CPU
>> is booting in a state where it is optimized.
>>
>> The RMP checks are not enabled till SEV-SNP is enabled and SNP is enabled
>> during kernel boot (as part of iommu_snp_enable() -> snp_rmptable_init()).
>>
>> Once SNP is enabled as part of kernel boot, hypervisor and non-SNP guests are
>> subject to RMP checks on writes to provide integrity of SEV-SNP guest memory.
>>
>> Therefore, we need to enable these RMP optimizations after SNP has been 
>> enabled to indicate which 1GB regions of memory are known to not contain any
>> SEV-SNP guest memory.
> 
> They are known not to contain any SEV-SNP guest memory at the moment
> snp_rmptable_init() finishes, no?

Yes, but RMP checks are still performed and they affect performance.

Testing a bit in the per‑CPU RMPOPT table to avoid RMP checks significantly improves performance.

Thanks,
Ashish

