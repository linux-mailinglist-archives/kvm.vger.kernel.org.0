Return-Path: <kvm+bounces-54969-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C59DB2BD80
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 11:35:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E60FA1960634
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 09:31:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6D3E3115AE;
	Tue, 19 Aug 2025 09:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b="r9rd7lAH"
X-Original-To: kvm@vger.kernel.org
Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazolkn19013087.outbound.protection.outlook.com [52.103.74.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3099F3451C9;
	Tue, 19 Aug 2025 09:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.74.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755595844; cv=fail; b=DoduVQS2feSe3SoYDznSZ/eiV0NPLG+qnt4kwHR2KOnplF2Nol9lyP9OMORaLoQsyLAdBzfqEPjeYRlKEeyL3yiepZKTVZHeqcaoNu2234oUrH3xTLbO28nerF2W29/PqF9VGunV4qGSxMMFM25LXjHE6XK/0KjDkHGb/aLWMvk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755595844; c=relaxed/simple;
	bh=Pvuc06v7SfS70x8YkOqRDu+wpQQLmL2siZpldiM8h5E=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NJJAnxoL+jzc+K32VFsB91dC0lHWM7FPfXp2S9euozfjkxnWK5VKoYROoQa7Ov3VILXy77EZegky+rwPzN2/GHzg6C+iBIzAYXMQ4I2CU/AUfZeH9W+JdWkVBnXvdmWrRSP9s+r/4zqiuemkNcKpRY/cIPLqX2RA/4WFYalldeQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com; spf=pass smtp.mailfrom=hotmail.com; dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b=r9rd7lAH; arc=fail smtp.client-ip=52.103.74.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lBi0El5lutCLaxbUfXIaEax4oUPU+LdB0ZBSyOIhlByNkMY4VAKomMSsBx3moafjEeP9DP43QxpsAYCox9B1ig/QZqzHdCoH3eIz+N3t2U/PJcpMA7C0VqxS6Mz6hu5yUZuQ79ssAfuvbDtT7/fywSBcLu4bO+Va7q0hrSxmKQehklBMSwXU1D/2vkqBHNdot8Z/i3XvPxx2/7uMsMr/PdiBo21bX74UsTfzvq3Drno15McKK8Mt2XHafrNgk0ke5MHWjGgv/waRsHfzYbfNWtoIZFuOl8ItDkjb27EBJelY0WfJxrc3nRWF0GswB1QNGyMIXqS4vIa+WtmYNdKdCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3RPqyFBrgZYM94pUKJo+j4Kor0ONiDIx7SF2EsYOrv4=;
 b=D1D+EJsFBBqvcN/CLZ7IgvzPPuTQHhesOX2d5R1Y3SAKSdSmwrNl1l9j02oKxXln0OjFW0SNOixyEQpsrpNVUAi4hKGXJfCyn3itWUCu+W8vo+srb+je9fUZMhQ+q3NZ2EgKJRXe/d1eZLBMi5s42wEiGa9EvVS8X5D7uVRHEpluDXrLIyNia0HI6holVbenMjk4ttynGMsU2L+tT2hEaAPzUYUGAaExUWXNYwFRSzFdmErwt2akI2R81N8VCXUTi68F2GkojpKxPoZg+2D5lWZinlFxR//hFY9TRWIt+4PSl/jCd8sFLoAHLt0lLJMd+xldZMrgfRVT63WwLbOFQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3RPqyFBrgZYM94pUKJo+j4Kor0ONiDIx7SF2EsYOrv4=;
 b=r9rd7lAHJk2LFoA1S/jy6DtvPunhKBirDOlKWbEcX2MNrFecEfFSW9lqCDMOCSCzUV6Sq0THGzBSiHt3UKA1sfmtWzeBP5pZKQDBjfiXeO9rdez/y1NYajBc/4ZcnNIVbTKUWQPQ4rvnXMlY+r/neD8cNzq/QfKfU6IA9vV3er23GmY9qp0owK0vkHyLVZ4ODnNdZY2dFrnexsxX6m9FJL3K0niXMwvc0+LtphjmBDmS0+3HlmypyI0g37ie/jrknSa5xYVJveP45NduWo2R+wWEbzqsxGt8jpfPiPLrOojD7JOfnexR58OI7bgSM5oJKUiv+wxWyiK/OF7VqbEZCg==
Received: from TY1PPFCDFFFA68A.apcprd02.prod.outlook.com (2603:1096:408::966)
 by SEYPR02MB7199.apcprd02.prod.outlook.com (2603:1096:101:1e1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Tue, 19 Aug
 2025 09:30:38 +0000
Received: from TY1PPFCDFFFA68A.apcprd02.prod.outlook.com
 ([fe80::209a:b4cd:540:c5da]) by TY1PPFCDFFFA68A.apcprd02.prod.outlook.com
 ([fe80::209a:b4cd:540:c5da%6]) with mapi id 15.20.9031.018; Tue, 19 Aug 2025
 09:30:38 +0000
Message-ID:
 <TY1PPFCDFFFA68A6B6DC1935A24DE9A3319F330A@TY1PPFCDFFFA68A.apcprd02.prod.outlook.com>
Date: Tue, 19 Aug 2025 17:30:32 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] RISC-V: KVM: Prevent HGATP_MODE_BARE passed
To: guoren@kernel.org, paul.walmsley@sifive.com, anup@brainfault.org,
 atish.patra@linux.dev, fangyu.yu@linux.alibaba.com
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
References: <20250819004643.1884149-1-guoren@kernel.org>
Content-Language: en-US
From: "Nutty.Liu" <nutty.liu@hotmail.com>
In-Reply-To: <20250819004643.1884149-1-guoren@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR03CA0111.apcprd03.prod.outlook.com
 (2603:1096:4:91::15) To TY1PPFCDFFFA68A.apcprd02.prod.outlook.com
 (2603:1096:408::966)
X-Microsoft-Original-Message-ID:
 <2e8ad150-bff1-4d38-aea6-2dff9fb3bd1b@hotmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TY1PPFCDFFFA68A:EE_|SEYPR02MB7199:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a150861-2e6c-4b2c-6eac-08dddf030e54
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|15080799012|36102599003|23021999003|6090799003|461199028|8060799015|19110799012|5072599009|19061999003|440099028|40105399003|3412199025;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ODREYitpVGNIaTlwN2JMQ0U5S2luTkJxVStTU0lVbmdFN2FSTzVwSUF4dVgr?=
 =?utf-8?B?eWo5V0cxVmg3VjBDZlVTZVZ6V0lUVThNMFUvM1EwWEdBQi93U1M4Qjg2YVNx?=
 =?utf-8?B?dVRCbERzYTdXc3ZDWjVWV244RTNSRFFpZG8rdlZmZ1NRL2QzUWhvZTZvMEx2?=
 =?utf-8?B?VTREMVUyYS9mNmVzVWI3NDZ0Q3MzTy8vMkN6V2ZVbmdNUmV6OEZkMXVHdGVT?=
 =?utf-8?B?QjlrWjdIbC9vNFZ3d2FTWkU3b1NleW9nSnVBckREZ0g0TEZvYVdmRGZzeGtT?=
 =?utf-8?B?ckhCSVU4K3ZVZGQyOU5sbWw0cXRhTmg4aUdDbmRpMkRyUXUxZWY5bEZFUnp2?=
 =?utf-8?B?Nk50QldncnJYQWRESTVhemxhL0lGZjBFcVZBc1JDN2NtSWlNMjFNd1BkeVov?=
 =?utf-8?B?N254MGxCRHV3L3RuWk52VjBkck83Q0RZYnFkY29PSDBlQTZLSEJmUlVEazcv?=
 =?utf-8?B?TkJGS3ZaOVY5dDc3YzVuR3preTkrZm5iaHZ0ZHdQRUIxNkVpajB5eG5YZ0Fa?=
 =?utf-8?B?Wjd1djFYKzNZVnZnaUN0aGk2MkRHaXg4WVphb0s2R1VvVmVSdjFVSFgzdk5z?=
 =?utf-8?B?VHk0VWEyK0xMQlBRR2d2bkNrYXBKVi9kREFCNW5UT2J4b0hjdVU5OHE3M1Q1?=
 =?utf-8?B?QnBDV3JuWGJZWWZsUWZ5bkFRbWNZMXM1dExoR3RkSXNZOXphVngrZ21SRDVS?=
 =?utf-8?B?SFNLaWd3N2ZhY2twcitoQlgrNkI5bHZYS01XMXE5U1d3cFJ3TlBzTzgyVjN1?=
 =?utf-8?B?cU05WnhMTzNsR0FxL05vQWUvenRyUDhPb0pJemxKejBmd05aYjFUOUhucWt1?=
 =?utf-8?B?ZGdQcGlvZFVDMmZ0UGM1NXRXUm5vQVQ5UUhTNVJNT3F3cHRnS3czRzVnZnNS?=
 =?utf-8?B?MXM2ZnRMdTB5dzBjMnB3TWhzN0hIaHlHeDhnUEdvMkZWV3Nvdi9GQkcyZ2pv?=
 =?utf-8?B?L3hiQVdpNlhKNmRUWTZsRTRhTnpOSS8vMnp2UWYxRmJsRkpiTUFPMDQxeUlD?=
 =?utf-8?B?TFQ1TDQ1ZXRjYk9qY1A3QTJzclRrNkVJbzNhdXhGL3pITFBXd2pFc2ZrTUdT?=
 =?utf-8?B?WmE5Y1UrT3BwKzdRLy8wSlRnbk04Q2dYRTJMVDdnS05mMXZxWXZ6RXFTRmxk?=
 =?utf-8?B?eHFPNVNvc2hLOWZjNVlvbno2TFBibzdoUGMwV2lyN3dDc1c1U1RNTDZhZkRP?=
 =?utf-8?B?VG9uZmplZ2xnNU5ReWE0K3lrdWFxVGVVOW5YU2gwMzVuMGZjMjYzQzMvRHJJ?=
 =?utf-8?B?LzBPVjYxUVVScHRDRjQ2blI1R011aHVuSmJVSDh1ZDk3cXJmc1V1cUg2UWpw?=
 =?utf-8?B?MDhGcW5aYmszOGtuVDlTeWZNRFJodkxHcmZ5dXhVZlhpY2xpZG0vNHNOMXpX?=
 =?utf-8?B?Sm5vK0RVRXR3NVJzOFY2QUxJNnhlOUhNRW5tOTMxOWNoRVNBSlRoSElBM2hF?=
 =?utf-8?B?R0JUbDVlR3lmOVZYdjF2N1ZjbTNpQWhoODJsNWJhbzlPbDRuL05oUDBQWHBw?=
 =?utf-8?B?UG5RZ3R6QzVUVU84ZkFHb1pEUWorSk5USytySm95cmhybGE2czBZbmx0dm9M?=
 =?utf-8?B?UHlIZVIrOHdZRHl6UUs5ZHFZUWxaZGlsWjhVcUU0Z21BdlMwRkg5eW1jRmNt?=
 =?utf-8?Q?KF9wI0yivDjB682EGcKgd5zWfseS3i1gTxGpOB/ahyOI=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WFpVV01nK21JWjludEhmTzc3Mkc4U0dOQmhydlpxcUFLdDJMbHhubzFlRktu?=
 =?utf-8?B?YnRJbjVDRmw1UmJTUklBMmI3M20rTHJJZzAvUDZjaHhsblFad0pFaGFnSTQr?=
 =?utf-8?B?c243UUNHYkQvTkJVeTFLMTc1ZDUwMDBuVTJNUmltVUNiSDNMSk1wRVJuRldU?=
 =?utf-8?B?RUM1MTFvS0Z6eXF1TW1aV3dicS81cm1tWnVkUjhONTlTcmhyakF0THFrSitQ?=
 =?utf-8?B?QS82bm5HdWJVK2tLM0pvR2Npc3Y5QXJ0VFN4MERtZlZGNnAvUWJIYTZnVWZs?=
 =?utf-8?B?dW42NTZxa213bW9nY3U5ZTh5YkZKK2lEamh2aE9DQ1FOeXNQaUt5Vy90bFpm?=
 =?utf-8?B?bDRpVjNETkE5S0ZFZzZrVldvU0lTMUFuU0NGckNSS094dkFib1oxZjJ0SzBC?=
 =?utf-8?B?Mkk3M0lTQUR6MEprRHFoc05oTVJnUStvbklqN0tXOGdIK1hoOG1MSnFUSERj?=
 =?utf-8?B?OUlsbjhCSWxVTldvSi9rT0FmbTlOZldaS2x2WWc5LzNQRzN5citYdVdkVTJy?=
 =?utf-8?B?K3hCdCtoNXMyV3FHT2VZNnpvbjdUZEpSOGo0OUtEaStRM0lUTE52TmJVNHhO?=
 =?utf-8?B?WEJFNklBU0k2b1dJNG0xTFZ4YU5BL05iZlpiRHV5b1MzUHU2eFFBQks3c2JX?=
 =?utf-8?B?eXRaVnRKYnVvcEhCSTNwVFA3cnRGQUliQUNTQmc0Z1VqU2VzcE5tL1IwcTYr?=
 =?utf-8?B?dDNDOUx5WnY4cnNsQ1oxRlQxOFNkeGdXaUtQNUhUTHM4ZjV1V1lnbGdvRDZj?=
 =?utf-8?B?MzhUay9LOWlVdnEwSm9NZG9lWmIxa0tvZFRMS3llTE1TbGhiOVNKdFhzNlFN?=
 =?utf-8?B?eVFpb1h1OE4xVXhjVjdJMU9IR2pTczRrRFJaVm9qNGgxUlh6NEZpOVN5ZERz?=
 =?utf-8?B?VGo1Q3R2eHlZSEFEejM4RzZzU2hlbTFsSGRlcHF4Sml4dHR1OUJUT210NWtj?=
 =?utf-8?B?S1NaZGFrNmtQQmhxUUxnSTFHenpoY0ZVVHp2aTBHY25FSWh2eWVnd0tOTnJu?=
 =?utf-8?B?VnpZUXhEL2x2ZnI5aXBHaFYyMkdwenBNbFF3bUpQTEpsSkRMdWRBL0hkYVlQ?=
 =?utf-8?B?NElQTWpBZDNQWDMyU1FzM1ZsMXA5MVROeVFGNlZMeEJmdlRGVXB3aEpTYjVE?=
 =?utf-8?B?aWh3M2s1YytrOG9xTnRjM2Zwc2J4SSt2MDU5SUFBTWZQVnFOSzNqNk5jMkhQ?=
 =?utf-8?B?ZThMMmNSWDl5YzB3RllsUllsMUlLQ202ek9hQ2czdFJPakkxNEJMUW5vTk8x?=
 =?utf-8?B?T1NFTVcyNkpNVzg3VG1ZcWU1ZERMV0xoWkU4NHFxNG5oNkgyQVVjQXBiUm4r?=
 =?utf-8?B?bE81Nk8wUGJ0YXRIaVFqU2FoUEF5OFhRdUZ3NTc0UTBtRXlwcTdDb3RGNmFs?=
 =?utf-8?B?aTdaYXI0bmFyVllJM3BUaWZFckhCZkRCYWxGdWNTSmtYbC9UMzZMMnphdm1V?=
 =?utf-8?B?czdoM3RXZGJBVGhZOFJEaWRISUhTcUFXSkdicVRzVkdzRFBWTThHNWMrQUFU?=
 =?utf-8?B?NHBnRUF4ZHJidCtLWEdYS2k3RHRjRlhuTDdJcktJRGRBdGhNeDNPS1ZRc09n?=
 =?utf-8?B?Y2tCTWxnckJhVFVtanJoNFdLdFBFL1grbWJuNGZJVHFuU2VtN2YrSk9HWUE1?=
 =?utf-8?B?cWxIWnRIUVZtRnRUam5VREJSYUJQMXNSQVVkMmlQVVlESnQzV0Erd3BHVWMr?=
 =?utf-8?Q?ZVzrv8FRHkNeJ8WPGDGP?=
X-OriginatorOrg: sct-15-20-8534-15-msonline-outlook-c9a3c.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a150861-2e6c-4b2c-6eac-08dddf030e54
X-MS-Exchange-CrossTenant-AuthSource: TY1PPFCDFFFA68A.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2025 09:30:38.0656
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR02MB7199


On 8/19/2025 8:46 AM, guoren@kernel.org wrote:
> From: "Guo Ren (Alibaba DAMO Academy)" <guoren@kernel.org>
>
> urrent kvm_riscv_gstage_mode_detect() assumes H-extension must
s/urrent/Current
> have HGATP_MODE_SV39X4/SV32X4 at least, but the spec allows
> H-extension with HGATP_MODE_BARE alone. The KVM depends on
> !HGATP_MODE_BARE at least, so enhance the gstage-mode-detect
> to block HGATP_MODE_BARE.
>
> Move gstage-mode-check closer to gstage-mode-detect to prevent
> unnecessary init.
>
> Signed-off-by: Guo Ren (Alibaba DAMO Academy) <guoren@kernel.org>
> ---
>   arch/riscv/kvm/gstage.c | 27 ++++++++++++++++++++++++---
>   arch/riscv/kvm/main.c   | 35 +++++++++++++++++------------------
>   2 files changed, 41 insertions(+), 21 deletions(-)
Reviewed-by: Nutty Liu <nutty.liu@hotmail.com>

Thanks,
Nutty

