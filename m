Return-Path: <kvm+bounces-67673-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DF0DD0F86E
	for <lists+kvm@lfdr.de>; Sun, 11 Jan 2026 18:40:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id EAAEE3002899
	for <lists+kvm@lfdr.de>; Sun, 11 Jan 2026 17:40:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 016A534CFDB;
	Sun, 11 Jan 2026 17:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="jf1MtmXE"
X-Original-To: kvm@vger.kernel.org
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010040.outbound.protection.outlook.com [52.101.61.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6FB21ABBB;
	Sun, 11 Jan 2026 17:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768153230; cv=fail; b=WXHe9nJfs8YQvvUpW3L7KBTwoE5rs3fKx3AdwJd9LmFxF3f6dn0oIQjyLk17G6dOb+XUCZW3y5f0MAkAtGTxNGEgOR2uLeZ09vVuwS/0DaDlK07JuVeVhFUNl/DKpgWRt9eeQSLYCJ5wKHZHBGn0Cytc8snh7MPVSeBM6s0Nbfc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768153230; c=relaxed/simple;
	bh=KdUbMK1LEIAPxkAnhneBB9ZBnrI5IRiq91B1vjQuir0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=iD6KnM0u59BlCcwXXN3ZVZerMOZmrHjy5gx0XuX6LYF+aplRHkK6OJ98ZoFokKnACXSGic+4mvrgncFFz6jAl6sseCe/Hch+2KoM7WDGX3F+wg0VltqDzZtpW0uDd51rAQYpKPyIWnRo3hPyiiB00YrFai5WyFTNeT4wobz14vc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=jf1MtmXE; arc=fail smtp.client-ip=52.101.61.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZNF7O+BYfTmAcfEgL2AwLeaMZXOX3NYeI1m7yj914Z3TgFu4GWyJwgRkh6ilWYUG/PqKdSMDn5cCktiqATtHWL+RaWVbjoDo6oC/Nb2nJPMNn2CI8ubSw4qK/LAPXLDyRCW2TMB0mGqFVLO25uxjjPaIIRczOv3lUwmmRpIILfD0Pi5TlhVP5Cq+tFV1zimy4+at9wNMXVOjusD1pQfOJKhc/b5vR/B3R4rGzReCiySuJH2x9g1GLCUPZAjYTIGy2dfVZOig/O1t/2DMbiDap2WsWHduoIvnM56/Z86ti9f7M4M0EQvPaSFrVclHhDmEbm+LV9M449IrSRD9VS8/6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PRo+XdCBsMEofI5cErHZYeqPdfrJV3CByZUZp9xfKzc=;
 b=sGve4QFwagxYOgu5VoZmfaxiGnKfJpnwgVzFP+BKfZivAKjlviCMinZ5JX0o5ltztj6YJ35eYxcvGvv6BHc37KHr/5krKMQXP4AZLb6cD68xU38KYJTOjdlJG7RI1raECWflipt4Ld2NoWETbeYuLQ5mSNkam7x8Exz6uYSZNTtVb4qVT8s3nA+oiuVQQkYvbgBiEs5VLy+/ehY5fTMiGLM6+ACsr6i91rKRkN8IkuPtwhrCCAfmM365MB5hZSMnMaDmf9j5qdNxwJypN5kaCIauR05eughGUmqmqkmRukGzih/pq6dZvaZNBmPd6oI6X33DDhl1g36i7Z270uw9cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PRo+XdCBsMEofI5cErHZYeqPdfrJV3CByZUZp9xfKzc=;
 b=jf1MtmXElrK3WiDUg6xMIqL2BgWbSEOdxRMom/GisE0wuHbWbmnOeeqAThuhuzuXdg9r6PFicjgWW7LmqpkJbbdx5SHrcjO6Jlh9TWAWenKcrv0Oaoifh3Ofm+qLwR3iwPLRnAFUMM1/oSOInv9pSCHkr22B5Ybrb+pRKJMm0HI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CH1PPF934D73F2C.namprd12.prod.outlook.com (2603:10b6:61f:fc00::61a) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Sun, 11 Jan
 2026 17:40:26 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%3]) with mapi id 15.20.9499.005; Sun, 11 Jan 2026
 17:40:26 +0000
Message-ID: <e1df40a6-6f08-42fa-b0a3-05e2bded381c@amd.com>
Date: Sun, 11 Jan 2026 11:40:25 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] KVM: SVM: Tag sev_supported_vmsa_features as
 read-only after init
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260109033101.1005769-1-seanjc@google.com>
 <20260109033101.1005769-3-seanjc@google.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260109033101.1005769-3-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR10CA0001.namprd10.prod.outlook.com
 (2603:10b6:806:a7::6) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CH1PPF934D73F2C:EE_
X-MS-Office365-Filtering-Correlation-Id: ebc24b43-b403-459c-e730-08de51388166
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UHB3ZHZ6MUhVU0s0c0N2bGZ3OFBWY1VOamFYdFRRVldqZWc4M25CbG9hVDMr?=
 =?utf-8?B?ZEZ3KzhLMTVoVjQ5Ty9tcUhWSzJtcFBvM1RXa0Y3WWhjTkZDd2N4aDZnZlgz?=
 =?utf-8?B?OGx1OWdCNGlmVXVmaUQrR0hkZ3BCNWowTWd2cHBCQjZjbEFUQ25YbFVOdDll?=
 =?utf-8?B?cnRySUp2L0pPdEZYUzI4TFRubnFuejVNRkYxWjBEVmYvRStDV0k2OC9NSnBY?=
 =?utf-8?B?QUN0dzhZNE5Bb1k1OFpTZ2ltc3EyTGJ5OEhvd2o1YTNkRjN5ekJydlFpS2RY?=
 =?utf-8?B?TWNlT0ozY3BEWkV0UU84KzhiWXRnLzVUOVhrVlVZWlRYeEpKckRzajgxT2Z2?=
 =?utf-8?B?ZEw4UkREQmg2YkRFNk5OOHUzeWNraUpnZmp0QzFzckxvTkRxbFBnWVdDNXF4?=
 =?utf-8?B?MlkyQzJHbXNlUjRhMU5na0Q5cGd0TS9XS2JwTjBNSndHdHgvKzhoVGZjdGND?=
 =?utf-8?B?Y1lSa2lLaDR6WUg4Qi9CYXhvUmFLVkpDUHNVbCtpVDN1YjZBb3NVN1dCeith?=
 =?utf-8?B?Z3Y3VW5jbnNXOC83dUZCMkcxME5qaytXMnpZaDdRMFdYME5FaVU0aXlkNzZm?=
 =?utf-8?B?Qy9hWUQrUXo5YjViVzlXRHVIZDlrU1Z4LzRwZUJQZm1NQmpnSlVlSmFZalh2?=
 =?utf-8?B?YmVrS1RUSkkvTUh3djQ5OHg4NlZHT0VPUFJHbVVuT0ZRV21Jc205Qnpmcy9J?=
 =?utf-8?B?Uk5NaU5uQWpSZ0ZyejRnNE1SVTdRN0J5MjlEMHJzRnBwa1dkdDZGYWRad1Z4?=
 =?utf-8?B?MklSZm43TWZWR0Zaa25heStVYzRDZmJxVy9HUFBockF0NHZzQWIyWnZwQ2Yw?=
 =?utf-8?B?SzBwNkJjVnh1L0ZsdnlQRTZaVGhwendlRU5iZk5yb1Zyck81S0h4eS9idTJU?=
 =?utf-8?B?alR3VFNIZFJWWXFpdHZMc3MvMTVYL2FVb0x4dkdrYTBObFVmRm5waFNIRXZz?=
 =?utf-8?B?QWVFellmRHlwSWxXdytGVDdJNzgzTzJFc3JKOXBJSDNLRmoyTWdsNG5NMk4w?=
 =?utf-8?B?emlPcVAvUFNoVWU5MVcydTM0dUozYXRSNWRnU2JmdGU0cGVPVHVRazJBV2dv?=
 =?utf-8?B?cVhJYngzUzZLd1BUK2pqQjlQNExFcUZrb1BhcFRtcW8vRDhwOVAybCtuZFY2?=
 =?utf-8?B?ellnajlPZjFJWlAwSXNzUk01aWQrR24zY0FlY2lxOFl1MlM4cXVHalMzOGxH?=
 =?utf-8?B?d0FXaWVBSzJCVVMyOU5kL2lQODVQNGcwUG51dU1lT2dmTS8xNmlRUnNCZ0Rq?=
 =?utf-8?B?Q0o1ZnhjbHcyS0I5NnJSajdhS0c0aFlPc1R5eUZIODFuTGVwNVZ0dm1oQjZv?=
 =?utf-8?B?a1p5TjZQd3pkK29CcDJ5V0NXL3hhTTdyQlR0NXh4N2NxaWRiUFU5ak1XTWRx?=
 =?utf-8?B?bnZCQmVyTEV5S1NGaFJkV2MzN2FTT3phNjB1dDZCbysvaVBmNTNQaTFmOFBL?=
 =?utf-8?B?VWNrTjc2M0tCbWlaUlVRaTlZZnY4S1Bla3M4a2t2a3FFK3lLbUxvRGVPb1Rj?=
 =?utf-8?B?OUd3bDNKOE5kb0JEK0UvS0Q4VzhsMkpFaUoxbDFUTWNxODV1VmRXVy9XaWtn?=
 =?utf-8?B?QTYxSEVWUzBUdU9kLytHdDhCbEJCTmVBSW0rNXBHUGJmdDgrUkFKZG5MbkRX?=
 =?utf-8?B?MnJhSlk3a0dpUFVZNXhSWjdqa2ZKQnBwQis1azBjaUU1QlVrbmRSanF0Sm9S?=
 =?utf-8?B?NmdFbDQwYWY3Z0JYb0k3dFhaRFBMMnBneFdieGdGRW5qbVkzS09FR2ErZU9k?=
 =?utf-8?B?Rlc5d0JxdlVZd2RDQTQ2WFZ0aTd1Ni9XcHYrV3hXMlhtZTNYNWpONFFQWlhz?=
 =?utf-8?B?ZzZPazFIblBuWGVLY2hKQjF2NHEvc3pRRFF4OURhUVJXNlR0RjAyUFhKV1Az?=
 =?utf-8?B?eUpMSnNkV3VXcjFDaUtUcUtGWW1xeXJwMi9VZllkcTZvRVNuZ01KRDA4SEdx?=
 =?utf-8?Q?JJRTRBUbeBjyQAaZpRGZRpQ2Is0VOd2f?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R3RwbFdCa2dNdWNQMTlidnY0c29OcWltZVdPS25sYlZrTzZKSXVieTVkajk0?=
 =?utf-8?B?TkhSTXBDR0xodGhJQUF0RUJibDRwdUtCOEFEUkpqZkdDSVBDNHpkVzZ4cTNw?=
 =?utf-8?B?MXc0U1loemlVZnhQLysrNk0wVWJpaHQwVWQvQitIdFB0NUpqNjFrYkZzNitn?=
 =?utf-8?B?blBoendXcnpLaXdMc28wWHdXV3cybWY2L3FXY0kwaUJLS2pscSs3MnhsRitG?=
 =?utf-8?B?QjE5dnEyYVcwTnRCdEo4V0FVMjRhNEFvclRhTmZtVVRoQ0xuWnpKblUxdG1Q?=
 =?utf-8?B?bStrQlZoZ0llWVBhdGNRWWppOUF3S04xaXR3U0s1VHFuMDdhaHVuSC9GdnFT?=
 =?utf-8?B?V0JZMkhPNWVLV0FxUmVJR3VEamNaUnl5Nm5MaC9oUGJnS0F4RVJaMEZ6V3NW?=
 =?utf-8?B?SEFtNG1DRkVwVm1jbzRvb1RkbE5NK3doVTFmUXc5dDNiUnhEcUdyZ3J6OTg1?=
 =?utf-8?B?U3FJL3Q3VS84K2J3eG1CNkw2N2hmSmY5a1h4YlJGM254U0Vqa3QyTCtUMURL?=
 =?utf-8?B?NXdLekYrNjBCSFZ0OFBTTjMvSTV5L0p4bVlZY1RvL1dHYW9BWjRHdTJoVFdH?=
 =?utf-8?B?ejVJWkhvNU9Lb2k4Q3psVGJua2JDYXN3SW8yV2Zrb2YyRHdBRldsMkxYTlpl?=
 =?utf-8?B?VU5xTGFPdkNIY3pTRmhyQ2JEeHdXUE1UVHk4NG1iVERHbTIxZFhDVllVSTlh?=
 =?utf-8?B?cmhsL1dRRlY0ME51VDNEMERhUno5b0VpNDRPMkZxY0FWVzB6N25BK09pcmpY?=
 =?utf-8?B?N2xId3RyU1A1eEFlY3NpSi9RQlJrdFYxWTU2ZmRTM0tlMjZtV1VWQkZaTUJx?=
 =?utf-8?B?Y20wK0NKbTVCaUJUcS8wWTJ1R1llOFljbTlnQitOSnFxdTQwc2l5cGd5TThz?=
 =?utf-8?B?Y2tYTkdjQ3lESHJYcmNpUkFWcmVuS2VicmNtcUg0bGZ1ZTl1UGw2WDJjWndQ?=
 =?utf-8?B?Wjk0cGthQ3lpTFpoaGhjN1VQMGFUSmo0SXY3SFFsQ08vVjY1Tis1eXlxd1RE?=
 =?utf-8?B?MG9NMis4dkZKWndyeWprQnpIZkt3UmFPS3UyNjVTWENHS3NpeGJyT0hMU1Y2?=
 =?utf-8?B?YTh4bFZMYUhtcWNzMFBsWjlaMEtNenZnZmEyVnpBbkpPQzlPTVJ3N0xnWEY1?=
 =?utf-8?B?VStjODVLRlh1YVNhcTlMcC8yZmw1c0hWeW1FT2h1STZCUUZFNzRGaWJ0NFd6?=
 =?utf-8?B?ZlgyRW82amZxRjhZby9SV2RodDY1eG9mTFJYNkx3OThDUkpOQmVxY29VRVRi?=
 =?utf-8?B?M2Z1THpiQVJPQXpXVUV1dk1HRnpEb0tIVU12dmVIWkdKcFdZazh0Mk0zMlll?=
 =?utf-8?B?VzlHcjVDMi90UkJEbjJVYlNpdEs5a0VWelNLMExaa0tQV09tNktVRjJnYXhM?=
 =?utf-8?B?MGxLQ1dqNE9nS2llNnJxNnltZVJ0TlhjQitWVnJ3SXF0ZGkyZXZLcFpJNlRh?=
 =?utf-8?B?SmpKRmVraFVKWWJrTUcwWUZSb1hYbko4NnpiZ2JKVXo0QVdFREtneUE1STZZ?=
 =?utf-8?B?czdQd0ZFZWVWWlc2aVRtNUY5aU1lZTR6N2EvMFppWk1hR21EalZaeGs1M2JV?=
 =?utf-8?B?R053MC9Ud0RKRDJSenNhNzdSR3cyMHN6QWJJaTRNTnhjY1J6RUZwWXRVeVVm?=
 =?utf-8?B?T3Z5bFkrUzJKRldzV1hHYTZLWHNTSldURG9yeThhc3pCRjg4UXdkSkM4WWgr?=
 =?utf-8?B?aW9NTnVrRGwvNVNUUlVFcUJacGlNVmtQaHovWUcxUnRmeXF4QXhDV3JOcjVM?=
 =?utf-8?B?RTZVdEQwYTFRY3VqV3kvVHhqR3ZzNkZpNm1qUW92b2FUMzFFRXVCWlIzdExF?=
 =?utf-8?B?d2R3RlZyNHB6SzMreUs4OElBaE5ubTV5ak15eVQweGNSd29hdzZzY1lMYkdY?=
 =?utf-8?B?c3lqT0QzV0VyN3l0cEloU3FadjI3L3ZjNkFjUjAxdzJod1dHaVZQTDVEU05q?=
 =?utf-8?B?QlJFTUk2K2s0c1A0WXhMSG93N0xOeWQvbkprd1ZpYjI3QzNkV0E0MHMrcTJU?=
 =?utf-8?B?akVaNm4vRmpnSHVhSmN2NFF3aGlxOHNOakxDTGttd1dwOWxvbS84VXUvc1Zp?=
 =?utf-8?B?d2dqbm51SGVRd0JSMnE0enN5VFAzU2FhcmxrckpJdS92ODg5bVh4ZDREOXRF?=
 =?utf-8?B?UGtOMGllKzI1WmlLQzlmb3NlOFBaT0dGMnVUdGNDc1EvRFNUeFYwTmR3dGgv?=
 =?utf-8?B?SGliRWlYRGJETVNHd3JndmJJNWxpM2ZYTXQrSDIrYUVJUEdRZDBKLzlaWmww?=
 =?utf-8?B?ZktsTGN0Z0tPbmd1K08yMkd5ditkSHVwK0UrcW9DOXJNLzJQemxOeDVHTjZH?=
 =?utf-8?Q?Xyw5mVnJUv5HKllK40?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebc24b43-b403-459c-e730-08de51388166
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2026 17:40:26.5642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8b/xdU8lQjeUdCoIHso+Et0vAD5nvely5zpHmxYdh3g3yh0YKWs9rP1vSDUsj1snUTPMtxAHruYM6ZITlXZyTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PPF934D73F2C

On 1/8/26 21:31, Sean Christopherson wrote:
> Tag sev_supported_vmsa_features with __ro_after_init as it's configured by
> sev_hardware_setup() and never written after initial configuration (and if
> it were, that'd be a blatant bug).
> 
> Opportunistically relocate the variable out of the module params area now
> that sev_es_debug_swap_enabled is gone (which largely motivated its
> original location).
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/kvm/svm/sev.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 9b92f0cccfe6..28150506b18c 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -53,8 +53,6 @@ module_param_named(sev_es, sev_es_enabled, bool, 0444);
>  static bool sev_snp_enabled = true;
>  module_param_named(sev_snp, sev_snp_enabled, bool, 0444);
>  
> -static u64 sev_supported_vmsa_features;
> -
>  static unsigned int nr_ciphertext_hiding_asids;
>  module_param_named(ciphertext_hiding_asids, nr_ciphertext_hiding_asids, uint, 0444);
>  
> @@ -81,6 +79,8 @@ module_param_named(ciphertext_hiding_asids, nr_ciphertext_hiding_asids, uint, 04
>  
>  static u64 snp_supported_policy_bits __ro_after_init;
>  
> +static u64 sev_supported_vmsa_features __ro_after_init;
> +
>  #define INITIAL_VMSA_GPA 0xFFFFFFFFF000
>  
>  static u8 sev_enc_bit;


