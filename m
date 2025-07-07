Return-Path: <kvm+bounces-51677-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E8B99AFB82F
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 18:03:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B1434179A39
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 16:02:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9783E2264B6;
	Mon,  7 Jul 2025 16:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Ej8LiSe2"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2077.outbound.protection.outlook.com [40.107.102.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAAA8225A40;
	Mon,  7 Jul 2025 16:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751904101; cv=fail; b=ZiyW2gmUFzJU+SGDTTpWS52F4QWtOLitu+ySdkRGQiJeUjceJAO7v/4+Q3C/cFtpslF8xsQW7FMP1FeSJV0D9b+y62BHMY9zRXxNRhXPjLcqa2EnikdNjYxhIZffSYEendsFrNK7Ag13wEOxcx+l79qN8idP6wl0oNsqRfFMaQo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751904101; c=relaxed/simple;
	bh=/SZUpSQzriSs8yObF1+pSFCvcfm7FFf7IVl72Dmn5RI=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=a6ZwIX5GnJZNsekBxc+1Prj47yCKXmM2qmaWU/s4pbo//BxPVkc7bI/AVfqkgDYmHEJbflgvg5NzqLYWc79OLZmJrBCklOKNAfQ0L9WhCd60q+P1Wxnf2ZbLsjGKZ6ArOJpnc87iwwXzIcIzysnUy2m5tWUmTiSkg+wcTxhM3B0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Ej8LiSe2; arc=fail smtp.client-ip=40.107.102.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZbyTRkzwpM6qJp9Qh/uzFJ3b6446CSM6JW70Qv21yc2nzDFUSd4gNjGizEYqq/lz5amEF3CUlVFk3FOZli4yq3/OPKJJrWQQapCU6vFu+1I7NxNEmAV1XaTwJvIBmvaWsrhoCtOTJFYK+HLDS1LbtomukhHj3c7DIO2GXwY8tEY1qGmql2fW4/2HdLuEUZBrCRT7iRx9HoywV1DiRlIRTJZQP7AUe1kzHFtMma0IIMkX+b2fEZjEUCTh6/adWBmxUSOTQ0jlBZqNRkm3HAWLCp0UOT6mVmoFsai5gzQ7gFGfDv6HJWKcTkjNY58ml0tCCY34/Xmvahx6EW9y/kfmGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oboT4UUGWkdgRADpn3n89TCHPoVUZidJAjmqZGDH4jU=;
 b=wJVWadxtbY1pP5mpehLd8kKR0zsW5iNlopYMVuXUE1mS580UX79IsynNbWOjG9e/bzk+cFVFNxq/+h6BtWWMfWeMxPlKew1WwKZS0OxeWlJipatpGp1YDEFIFbG4/gzDXsGXsHLKVOVUB/qsKnqWy68mYmnut4XrJYMpgxnz0eW9IL7VAauN034Sf2d2s1Pgi3n0NIpg/HBElshUqrqPsEy2mErUDmptSJNhVLCnbeeSNesxr90U2SAMx84GxGf5j5i/jQCDVyD3drctmqR7fjIMJgPfnwp6DiOO8YGaiNWf7r6c0WLv/QMlZ229OZQyAwXqXU4zbyvemhdwOeIV5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oboT4UUGWkdgRADpn3n89TCHPoVUZidJAjmqZGDH4jU=;
 b=Ej8LiSe2R8mfxNvQMTWgc4dcxoLsNUKhv7/acgA35PL7eto9YHXDJoA7Lff8rwyhi1FONHR1wAb9D2YpnQHgBtXDwxs2IgJWbjOp+GgF4MHNL6dkk+0t4HMvJlnp0n/I5KEcw5XOR4PvT9c1IRShYf4pAmo1WiRAwun7TewM9/Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by LV2PR12MB5846.namprd12.prod.outlook.com (2603:10b6:408:175::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.26; Mon, 7 Jul
 2025 16:01:32 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8901.023; Mon, 7 Jul 2025
 16:01:32 +0000
Message-ID: <66b5a45f-d570-8aaa-ad1f-0aedfc990b7d@amd.com>
Date: Mon, 7 Jul 2025 11:01:29 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Ashish Kalra <Ashish.Kalra@amd.com>, corbet@lwn.net, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 john.allen@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net,
 akpm@linux-foundation.org, rostedt@goodmis.org, paulmck@kernel.org
Cc: nikunj@amd.com, Neeraj.Upadhyay@amd.com, aik@amd.com, ardb@kernel.org,
 michael.roth@amd.com, arnd@arndb.de, linux-doc@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
References: <cover.1751397223.git.ashish.kalra@amd.com>
 <5048d1bab32530214e7f3e4d73a4756cf374dee6.1751397223.git.ashish.kalra@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v5 3/7] crypto: ccp - Add support for SNP_FEATURE_INFO
 command
In-Reply-To: <5048d1bab32530214e7f3e4d73a4756cf374dee6.1751397223.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0121.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c5::9) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|LV2PR12MB5846:EE_
X-MS-Office365-Filtering-Correlation-Id: d33337f1-1088-4fba-f591-08ddbd6f8a72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RGgwcTkyUTVlODRYNXIvZ1dob21RT2NsTllXd1NVcC9MM3QweTZrczdUTzdH?=
 =?utf-8?B?dGNOVlhVeEN4UjRJM1V3K2VyVGI2U1BiUndkYU4vS3l0VXd0WlFaSUR1ZVM0?=
 =?utf-8?B?M2tvaU1oR29wSExuV3lCYXVRbG5WckxMaVByUXJiRktmK2xjWDJaM2hWSmg0?=
 =?utf-8?B?Uk80SURGYWhITjFTWHgzc1BmQmg0ZnZSMVAvTVBSNlhyMjRDc2paV1NDTDU0?=
 =?utf-8?B?QzBjYUkrbk5neUhDdWlmRHJvRmU5bGR5Q050WnJGZlI4Zkg2Ly94RG9saTRJ?=
 =?utf-8?B?dGJ1OWI1eEpUTkdzMHRIbVplYXZyRTJ4cEk5eXlxNnlxNzc0Q0IwZm1Ia2ky?=
 =?utf-8?B?N0xYK1FTR3JPU3Q1Nys5UDhKWnhFVkZyMDJOQU83UFkwcnRBd05TSjduS2xw?=
 =?utf-8?B?YzFTOVVoSkpvS3Vmb1VvbG4vc0dIVW5HT3ZVOGxwV1J4dis4ckpzaENhK0px?=
 =?utf-8?B?Ukc4d2dGRWMrWjlmNFp3dWZnWnRpVTJNTFRJZHY5YjlTVkRWb1ZnWkhxNGRy?=
 =?utf-8?B?Vk5oTTRtcVhDT05mQ2FGdnlUbEVvZmZLSTE3MFVDNmpVQTdDOXpsOEQ0anVi?=
 =?utf-8?B?WXJGR2R2VS9iR1NHTDd3ZXVZR0lyVEcrWldhRFpxS3g5Q0hsTU5RZWtmS2Fa?=
 =?utf-8?B?bzQwcThIc2t5YUFra1FaeEg2Zmc0cWo4WjVxNzQ0bVlzKzA5aVNlRm94M1A2?=
 =?utf-8?B?a0xZUStETDUzS0k4MlE1K0dFK21uSUlTQ1VBZGdhalNuejhvdFVOS0didWpm?=
 =?utf-8?B?NWp3L25KV3FzeVE2cGEvT25nUTFYK0VkR201aHByRlk1VWcrUnA3SHJrdjlK?=
 =?utf-8?B?YkpMZjVUUHJReXpLRHl6LzB4cmpGWTJUQTJRZ0JKcXFmWWR0N3VvZkRXMHd3?=
 =?utf-8?B?cEwyS0VJT2czYy9ZSE1MTkNxM0s4UmpOUjBaS2tQRFJWcU9wMEhWU3Vkb2Mv?=
 =?utf-8?B?cEZHVGRZOTFGRG1SbUoySXdZOENpbmdLc054TFY4bjlvaVJrV0tPMTd2S0Mx?=
 =?utf-8?B?b2VWRGx0MmlzcmFhTWcwaFdSMEFvWEVPT3p1NEtJbjhuaHBkdTF3U3BhY0dK?=
 =?utf-8?B?Z1pzdTU2dUpSRlo5eVkvV3kyMy9NU2szUHJMdmxvUTc5NlFzQXlOTlVDS3RV?=
 =?utf-8?B?bi9QSjRrT25MSVFjOHQrS0tGY3JOazU2Ni9DdjBlK0tyd3JTS0IyR2t4UTBo?=
 =?utf-8?B?Wk9vQVovd2tBVmFOMDBKS2hjSzJLZ0NnRjNZb1J2Tzh5UU5iRTdnTEtQTVoz?=
 =?utf-8?B?UjBQa3pDUnZ2QkFoUG05MFhSNkRzc2FuNXZMWWlGc3d0ZGd2R0NlVnFuOUpD?=
 =?utf-8?B?d05HWUNVd3N1aml2SVYzUThLcGxWMkptd0t5L2pkck9qUjUyT2lSS1I3UFJo?=
 =?utf-8?B?T2luMDJ1MFZmaWgzcFdGbDJXaDZSMmxOVGRGRGZ0TVV2V2xQcytCNTBHcDBM?=
 =?utf-8?B?c3NTUHUxdVFFd2FjeEFXWmR0VXdPMG54QnNJdS8vbUkwc3pkd1pYQ0tVZTdo?=
 =?utf-8?B?M1Q0VEZVNmd5RXBVMnJxdVg2c1B6Snd4WVNKZklmUmFKOFpDeU5nSXkzOWFS?=
 =?utf-8?B?eHlkcERjYzdmd3NrdjZLUUVwaWprTzJKRW1OVnBva0lLcS83Qk9WVk8wWXFB?=
 =?utf-8?B?c3B2Wk9xSHZmVkNubVV0ZTNrVkFNeDM2cHNROW5tckhPZ3FPSVJVNXZ4RVpo?=
 =?utf-8?B?U2hmYVRMNTIxNGhGOXhoVk02WGtNR3VRZzZVSExlbFZVUjliMDNGSFM2RU05?=
 =?utf-8?B?akV5RHNwZElBczRpQm9oQ0c3S0ZCMjBrMHkwVjhnNEpiRS9FS2dyeUlKY1Jz?=
 =?utf-8?B?UHZXSmFWekI4VFA3U2NQN1EvbTEyMktiRGl0Qi83eU1oMFZQMG9TL0FZZk1R?=
 =?utf-8?B?bms0YUdzeVcyRngvcVh1UkJtVnE1SDZUdm1lbU9UZlpGa3E3NWVZMlkvTkhK?=
 =?utf-8?B?Vk0xbERkT0loakx2NGRmRkJmdjh3ekJQODJrV3ZKeG9kSjRPOWtua1RUeWFW?=
 =?utf-8?B?Ny9pVHJzNUJRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q0JlaXUxdjZkcndRM2pEc3llU3RlNlN4b2FaanpuOEYrSFlhNHZEL1ozRGRk?=
 =?utf-8?B?aENEbk9NMWMxdGxXb1Voa0R5VFZJamZOUHVQLzBITW9PNVlxWnN0RWU2QzhY?=
 =?utf-8?B?Si91ZTRuOWVtaWFsWUpTY0RiTmZLT0JyNEJHRzFhTXo5aVR5Z0ZmcWU4WXE0?=
 =?utf-8?B?bmgxdXp4dEhYd2VuT2xHMVY2cTdyZVFZa2YyRXE0VGtOY2I4VWhVYUhVNy9n?=
 =?utf-8?B?RmI5N1l5Q3RrcmhqN0dtUGVpdlkwWEx6cmRNcTA3dUYzZWlGQVk1VUdGTkxa?=
 =?utf-8?B?VVFZMjR6K1pyYzdwU2owczJ4VnNweTltM1hZakRZb1U2Q2hNZzNjSGVZeUdz?=
 =?utf-8?B?dDBpdHRIS3pCSUFWTGhSV2xXdW9ZZnZXMUJrU0FVWVV6QmZmRlNVSzZTbGNa?=
 =?utf-8?B?NlhoSTJPOVMrd3N2ZXZoRU1zWTMraUNaLzYvWUZhWDI0cTRTb3ZtN2tmbnJC?=
 =?utf-8?B?S3V0a0JOSVF6T0VCYlhXbmd3QktxWjl6MWNTWkZ4N1oxMmpCNDk5akpKRzBx?=
 =?utf-8?B?WHIyVHZsYVZkVTZiR1pBVzlMbStGNUdnU0tzNHdEZ1krNDRhZ1ZZUXczc3lM?=
 =?utf-8?B?MHoxZFRvaWkxMk9hRzRtY2ppTXFkeGJSbkRUZXd5THNHNVdRSndwZzBqYmU3?=
 =?utf-8?B?ZGsybkxrL0IweUZZMjV6Q1hZT2IyZCtVK2VGeHUvR0tyUE9OM0pvSDhzd29u?=
 =?utf-8?B?UWIwY00vV0QrVnVHT2JHOWpTQkcyMk41ZmZzMG1TNFhGRXAzL0RBWHVCM2Nr?=
 =?utf-8?B?cmxaa01FaURtZGQ5SWdZZ0l1NzZneG5ZYjMzWGVUemRnUHVnMWdkR2RyODdH?=
 =?utf-8?B?S3VHbDh3UEZoazBhOFJ3czN3WGoyN09TU3JzQm1JbXhnM2RNcGRNZUJ5bC8y?=
 =?utf-8?B?UEtkbUJSRXZ6aXRML0lvVjRCMGR2dnBZQjV1Nk42K3B1M3NLWUs2TFltK1Zs?=
 =?utf-8?B?RWM0UDhvMGpTVTR1a05GSHhqN2wrMm1ySUMrZWErRXpJREk4Q3hNUDI4aWtC?=
 =?utf-8?B?S01GS3E5bnNCQ09ZVlljTHFTR2ttdWhWUnJvT3NGLzVob2JTVXhZK042QkZt?=
 =?utf-8?B?dHlPVDVFTHZ4eHFtMDJhUm1jeG42VVRPdmdaVWIvanRTamZmbFRHRnd3bXI0?=
 =?utf-8?B?eTVnTlFGQVpDc20rWTQzUW5qZHdZMDhZYUk4aENQWnRoUmErTUlpNFE4aGc3?=
 =?utf-8?B?SUJQVmhVN0RiNW1IS2s2MmUyVDlKR0xaNTFoZUQzYWV6VXp4R2kvTVlsMDZ4?=
 =?utf-8?B?ZHI4Q1k4ck9EUFV0Y2dGN0IyMjZUYkV0dlBCeTNwOG95ekdOc2FVS3AzcXhW?=
 =?utf-8?B?TVdObHNKTWZzbWZEbmpxaEdiZXk4S3RFSTRzT3J3dzdPZEF2TitwUVIvbG9F?=
 =?utf-8?B?YVBNUG1GeEdjVExaWTBJQXpYcVZvYmJFcUlyT3dqZFltQzdnRXUxem9ueGpm?=
 =?utf-8?B?REdBYUl5dG4xeWtuMjlwdngyZU52TVhuYmZvMXR1QzdtNFBZTTNGbk4vRUE5?=
 =?utf-8?B?VEVMeFViZ2xQNFlhOU1TbGZxbm4vOEkyaXdFTlBKNktwT0JVUnJpRXpvcURs?=
 =?utf-8?B?Q0VSWWMrSzBOQmZjUUlKbjJaMXd0b3gvR3ExZlhyZURhdkZlYVpMY3A2Y1hT?=
 =?utf-8?B?cGNRbjdyajFscWdidFlXTExaVFJWaDl1d1prSkRaSEluQzBGdUtwdnV2YjFr?=
 =?utf-8?B?NkV3QkdwWkNFSE9xY1QxK3VPd09zUlFGek9sSVZCUWUxaUEwL3RyNXV5Smpi?=
 =?utf-8?B?MEs3TGZLR3BEbTdYU1pOYzhKanNIVjdLYms3dmR1RzVQeUQvUGlaKzI4bDJB?=
 =?utf-8?B?d3NjcEJXUzMxUzgxZHZNZlNQWFp2WUhSQXhhWGFKdVlhdHhvNXpER2xTL0hx?=
 =?utf-8?B?bDFDTGNiRi9YaFFJbGdHcnJ6VFZWWHNCMEc2cURUNEl0OE9USmpPTjk5RC93?=
 =?utf-8?B?QnJ0NjlmVHlCeEZ0azdkMU42Yi9peWZmWnM2WUgwbllDVlEzdzFQNm1JUzVo?=
 =?utf-8?B?TTdGNDNiVTR0eFhYSVNTMjd5Q3lOMmJoVTlqWVdQZkxsb1BYM0JEbXFLYkR6?=
 =?utf-8?B?VEE2WVlMSzk1NUtnWm54RkxMcmJpZjBHdFM4dVhJR3htZ1VPMTdqd1NEMGl2?=
 =?utf-8?Q?Cn+erVBwtOI/uOyCqaiTKhNIP?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d33337f1-1088-4fba-f591-08ddbd6f8a72
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2025 16:01:32.1882
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 79+/hWaWwW0R0qO+OpS6/mMssEoYQNsHfm+mxKcDKpr7nyDCev6GmI+B3H4lz8/Q76K3Z3u3DAVC5w9EmWSIdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5846

On 7/1/25 15:15, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> The FEATURE_INFO command provides hypervisors a programmatic means to
> learn about the supported features of the currently loaded firmware.
> FEATURE_INFO command leverages the same mechanism as the CPUID

s/mechanism/output format/

> instruction. Instead of using the CPUID instruction to retrieve
> Fn8000_0024, software can use FEATURE_INFO.

This makes it sound like you have the option of which to use, but that
isn't the case. Fn8000_0024 can only be retrieved via the FEATURE_INFO
command.

> 
> Switch to using SNP platform status instead of SEV platform status if

For what and how? SEV platform status is still called afterward, so what
does the switch consist of?

> SNP is enabled and cache SNP platform status and feature information
> from CPUID 0x7fff_0024, sub-function 0, in the sev_device structure.

7fff_0024 ?

> 
> Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 72 ++++++++++++++++++++++++++++++++++++
>  drivers/crypto/ccp/sev-dev.h |  3 ++
>  include/linux/psp-sev.h      | 29 +++++++++++++++
>  3 files changed, 104 insertions(+)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 5a2e1651d171..d1517a91a27d 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -233,6 +233,7 @@ static int sev_cmd_buffer_len(int cmd)
>  	case SEV_CMD_SNP_GUEST_REQUEST:		return sizeof(struct sev_data_snp_guest_request);
>  	case SEV_CMD_SNP_CONFIG:		return sizeof(struct sev_user_data_snp_config);
>  	case SEV_CMD_SNP_COMMIT:		return sizeof(struct sev_data_snp_commit);
> +	case SEV_CMD_SNP_FEATURE_INFO:		return sizeof(struct sev_data_snp_feature_info);
>  	default:				return 0;
>  	}
>  
> @@ -1073,6 +1074,67 @@ static void snp_set_hsave_pa(void *arg)
>  	wrmsrq(MSR_VM_HSAVE_PA, 0);
>  }
>  
> +static int snp_get_platform_data(struct sev_device *sev, int *error)
> +{
> +	struct sev_data_snp_feature_info snp_feat_info;
> +	struct snp_feature_info *feat_info;
> +	struct sev_data_snp_addr buf;
> +	struct page *page;
> +	int rc;
> +
> +	/*
> +	 * This function is expected to be called before SNP is not
> +	 * initialized.
> +	 */
> +	if (sev->snp_initialized)
> +		return -EINVAL;
> +
> +	buf.address = __psp_pa(&sev->snp_plat_status);
> +	rc = sev_do_cmd(SEV_CMD_SNP_PLATFORM_STATUS, &buf, error);
> +	if (rc) {
> +		dev_err(sev->dev, "SNP PLATFORM_STATUS command failed, ret = %d, error = %#x\n",
> +			rc, *error);
> +		return rc;
> +	}
> +
> +	sev->api_major = sev->snp_plat_status.api_major;
> +	sev->api_minor = sev->snp_plat_status.api_minor;
> +	sev->build = sev->snp_plat_status.build_id;
> +
> +	/*
> +	 * Do feature discovery of the currently loaded firmware,
> +	 * and cache feature information from CPUID 0x8000_0024,
> +	 * sub-function 0.
> +	 */
> +	if (!sev->snp_plat_status.feature_info)
> +		return 0;
> +
> +	/*
> +	 * Use dynamically allocated structure for the SNP_FEATURE_INFO
> +	 * command to ensure structure is 8-byte aligned, and does not
> +	 * cross a page boundary.
> +	 */
> +	page = alloc_page(GFP_KERNEL);
> +	if (!page)
> +		return -ENOMEM;
> +
> +	feat_info = page_address(page);
> +	snp_feat_info.length = sizeof(snp_feat_info);
> +	snp_feat_info.ecx_in = 0;
> +	snp_feat_info.feature_info_paddr = __psp_pa(feat_info);
> +
> +	rc = sev_do_cmd(SEV_CMD_SNP_FEATURE_INFO, &snp_feat_info, error);
> +	if (!rc)
> +		sev->snp_feat_info_0 = *feat_info;
> +	else
> +		dev_err(sev->dev, "SNP FEATURE_INFO command failed, ret = %d, error = %#x\n",
> +			rc, *error);
> +
> +	__free_page(page);
> +
> +	return rc;
> +}
> +
>  static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
>  {
>  	struct sev_data_range_list *range_list = arg;
> @@ -1599,6 +1661,16 @@ static int sev_get_api_version(void)
>  	struct sev_user_data_status status;
>  	int error = 0, ret;
>  
> +	/*
> +	 * Cache SNP platform status and SNP feature information
> +	 * if SNP is available.
> +	 */
> +	if (cc_platform_has(CC_ATTR_HOST_SEV_SNP)) {
> +		ret = snp_get_platform_data(sev, &error);
> +		if (ret)
> +			return 1;
> +	}
> +
>  	ret = sev_platform_status(&status, &error);
>  	if (ret) {
>  		dev_err(sev->dev,
> diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
> index 24dd8ff8afaa..5aed2595c9ae 100644
> --- a/drivers/crypto/ccp/sev-dev.h
> +++ b/drivers/crypto/ccp/sev-dev.h
> @@ -58,6 +58,9 @@ struct sev_device {
>  	bool snp_initialized;
>  
>  	struct sev_user_data_status sev_plat_status;
> +
> +	struct sev_user_data_snp_status snp_plat_status;
> +	struct snp_feature_info snp_feat_info_0;
>  };
>  
>  int sev_dev_init(struct psp_device *psp);
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index 0f5f94137f6d..935547c26985 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -107,6 +107,7 @@ enum sev_cmd {
>  	SEV_CMD_SNP_DOWNLOAD_FIRMWARE_EX = 0x0CA,
>  	SEV_CMD_SNP_COMMIT		= 0x0CB,
>  	SEV_CMD_SNP_VLEK_LOAD		= 0x0CD,
> +	SEV_CMD_SNP_FEATURE_INFO	= 0x0CE,
>  
>  	SEV_CMD_MAX,
>  };
> @@ -814,6 +815,34 @@ struct sev_data_snp_commit {
>  	u32 len;
>  } __packed;
>  
> +/**
> + * struct sev_data_snp_feature_info - SEV_SNP_FEATURE_INFO structure
> + *
> + * @length: len of the command buffer read by the PSP
> + * @ecx_in: subfunction index
> + * @feature_info_paddr : SPA of the FEATURE_INFO structure

s/SPA/system physical address/  to match use everywhere else in the file.

Thanks,
Tom

> + */
> +struct sev_data_snp_feature_info {
> +	u32 length;
> +	u32 ecx_in;
> +	u64 feature_info_paddr;
> +} __packed;
> +
> +/**
> + * struct feature_info - FEATURE_INFO structure
> + *
> + * @eax: output of SNP_FEATURE_INFO command
> + * @ebx: output of SNP_FEATURE_INFO command
> + * @ecx: output of SNP_FEATURE_INFO command
> + * #edx: output of SNP_FEATURE_INFO command
> + */
> +struct snp_feature_info {
> +	u32 eax;
> +	u32 ebx;
> +	u32 ecx;
> +	u32 edx;
> +} __packed;
> +
>  #ifdef CONFIG_CRYPTO_DEV_SP_PSP
>  
>  /**

