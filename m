Return-Path: <kvm+bounces-54949-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D2076B2B7EF
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 05:48:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C32503BDB8E
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 03:47:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BA4C20469E;
	Tue, 19 Aug 2025 03:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b="GuXS/lzV"
X-Original-To: kvm@vger.kernel.org
Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazolkn19013086.outbound.protection.outlook.com [52.103.43.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C82CBA4A;
	Tue, 19 Aug 2025 03:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.43.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755575268; cv=fail; b=oKrj5G7n+B8wQUOrnsyyF+PUuxKVR/GMgiY06J7bEmO+O2+M95WxRbkzL1jBoROVrmyHHY7FA8MBQkmvldSmcDRR3T7PJIE9pWRqwrD0c0uEr1HlEFVkTljH8MFF+ZPE11NAR4nraNWcYieVywi7mO9x+RxdA3TAVs9mE/ZDZlg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755575268; c=relaxed/simple;
	bh=Bnj0W/ztcPnsa3a5QGQ/Xd17VB3NNh/Mmtu/+e40cmE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=j10fLbAHeR81wJsyYtJ4sShtgi6KRYyB1QtnCzrYowSQ3Oro9buVP0BKo30/3U3rMBBt6ymOxYDEHw+lzTmapZ/NIbWQ8GZ32HALI4ClealaMI9c5HlfNmn6SmjU04v2SSnA/eL9M7MvMT0VwlytPL3V8jAmXv2vM1jJKh21Tcc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com; spf=pass smtp.mailfrom=hotmail.com; dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b=GuXS/lzV; arc=fail smtp.client-ip=52.103.43.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rQKm7FXpV2cq9OFqWLEqFKePyMxHU9ulBlUl81c3c+jF0Fk6sbxR3RKj3x+ahA+oK2QiBAyyp7qMpE+uODjtaBd/8tMsk+a1Z3GSdAYbzQYKH9rD+Zwqcc+s/mlI5juF7cMRTcByG9I2AIFGHstKu0RO4/Zz6vSoYIiK8aw0BEs7yWEqdrySXA+IjNRYJjSQBGknrn18kPa/IyI865qKCtO5z68jXAAjw16J/UawEPI8plMkMCE3kusVMZ7bp9/sVHe1E9VUHZgod+hR0sQrJmKL2uzTDrO1Lk3OqTuv+jkH+DRpFckcgK+LFugUiNd/IxyyCe6CjZQyfF+YEXco6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZbwvMgtXAuxRCQKXZe/3dHIB1bHiO7lObxGGGB5koIg=;
 b=gfBaj+JGOJptHBlQ7vMe0ZyVOFCvjGowKwu/iW0iLOkA67MFcXfZOk8Z96h7k7e2kiyd7XRCLc5AwKHr0gEe+kjp4pjSqT6qYLRHZWv2Lr0cu6IbElMwisIUS+C0XT2J3RE2vERs39dRbUU4y2pbTSgCno/9eHckcdiCYDpJdi4+wL3n8RrLOg4rpJuZc9Ia8PxTXC5eoMjKIt4tQJOFRKcnJgjubTvpWceF9NaKemKMO82+LDSzyw+oKtOtdKhpHpljwfPQEpISA2SNI4GWz9ylKtf9lhR9A23jNasIReN4I9Uk5J6393zwRil/ShvlauC8JEIo/OifRsgLEDyzLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZbwvMgtXAuxRCQKXZe/3dHIB1bHiO7lObxGGGB5koIg=;
 b=GuXS/lzVr5yEt4/xsAkY/djJPSeMGOOLxuegmJ8XBpurwhj1bD9q+1h/u41aM7oTgoWSNNGl9vq4rsTZCc4iHa+Io+94X9ZXdlSs6CyPldw10a5SOcKu2zH11iEFV2JJQ0NBt7+06fbXUTrY/ngXojndR0DnBkkIzSUBD3jReEo978TM5sdwrJb+//aghuJsK9ab5K/LaejGn45/oxSdMhWLBdPZaQSLIn5xjHyqThp+1f4G41U+bfvGanzNJsYxIae3Eof6u/fczGISh8RAr9yd7HDB6QV1I3Bp6zL1gRMduoXePocRZmSEj46LctIlkUY6QhtLRI4AKvCIzIbhLA==
Received: from TY1PPFCDFFFA68A.apcprd02.prod.outlook.com (2603:1096:408::966)
 by SEZPR02MB7913.apcprd02.prod.outlook.com (2603:1096:101:237::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Tue, 19 Aug
 2025 03:47:41 +0000
Received: from TY1PPFCDFFFA68A.apcprd02.prod.outlook.com
 ([fe80::209a:b4cd:540:c5da]) by TY1PPFCDFFFA68A.apcprd02.prod.outlook.com
 ([fe80::209a:b4cd:540:c5da%6]) with mapi id 15.20.9031.018; Tue, 19 Aug 2025
 03:47:41 +0000
Message-ID:
 <TY1PPFCDFFFA68ADB818EF448346B258B14F330A@TY1PPFCDFFFA68A.apcprd02.prod.outlook.com>
Date: Tue, 19 Aug 2025 11:47:33 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2] RISC-V: KVM: Write hgatp register with valid mode bits
To: fangyu.yu@linux.alibaba.com, anup@brainfault.org, atish.patra@linux.dev,
 paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
 alex@ghiti.fr
Cc: guoren@linux.alibaba.com, guoren@kernel.org, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <20250818054207.21532-1-fangyu.yu@linux.alibaba.com>
Content-Language: en-US
From: "Nutty.Liu" <nutty.liu@hotmail.com>
In-Reply-To: <20250818054207.21532-1-fangyu.yu@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR04CA0001.apcprd04.prod.outlook.com
 (2603:1096:4:197::12) To TY1PPFCDFFFA68A.apcprd02.prod.outlook.com
 (2603:1096:408::966)
X-Microsoft-Original-Message-ID:
 <fa5da2f5-e744-4787-bab4-77a844878a92@hotmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TY1PPFCDFFFA68A:EE_|SEZPR02MB7913:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ac8d9d2-b0e5-42c4-a241-08ddded325b0
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|36102599003|15080799012|19110799012|23021999003|461199028|5072599009|8060799015|6090799003|3412199025|440099028|40105399003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?b3ZyMWxHN3ZOcUtsZHBINE53WXNMejJEZGw2dVVDcE42Y2draDdYbVBEa1Rk?=
 =?utf-8?B?aWtxbkpCL20rM3lvdldNb21uaFlmckFZaVZRN3VvSVU4aUlVemZBRG55VW05?=
 =?utf-8?B?R2JYbTZGeW9kcGxOSVp4Zm1EQ0k4WXFJd1k0dkt6d2J5T0VUSjZGVFFQTE5h?=
 =?utf-8?B?OTlXdFkvd3o1MHRRM0xNTzNVRTJVLytDMlQwaGFnU2UxWDMzK012bTVIbm1D?=
 =?utf-8?B?RHZCQkNOajZvTm1vdTcyRjdZa3FTTFB3TzlDS0s4MEpUb2pxRmV2NS93S3or?=
 =?utf-8?B?dmlEWTlxTDVPcXVnZHJiM2VhM1V3cE9VM3VLWlNyZzAvcFByQVJvNjdWOXBU?=
 =?utf-8?B?REsvNW5PZ1NuL0JvaGZ4dWw3VDNMV1VzSUFmN05mNHpXVDRwN2ZkSytCdHpZ?=
 =?utf-8?B?SkMrZ1o1dnVHTll3U2NIQkhYeDdTRVMxLzNiUUpZSHYxenNFRXVoeCtaMWRh?=
 =?utf-8?B?ZndFWXJpTXNISTFkQ3R1cTIzb2I3aGtMeFpwUnZvdzNnWmhNVUVDeXhrazFi?=
 =?utf-8?B?YWJNQTlSYkZKTThIT0QzQVVNdDBlYTlHZFR5MVllUit6QlVnMUJwanZ4WXhL?=
 =?utf-8?B?WGRrWkh2NWttUDFDUytDU2UrTGJ3VVVsblFrQ3ZxT1BNRGFWaFdSNVYrdjFM?=
 =?utf-8?B?cHdQbE9vOGh1djFPVjFyM0tyeDZLcUFsUy9NdjVESjRSaEpQaWFDRnVNVXl2?=
 =?utf-8?B?aVV2enB3NTloejNCd2tmcmhmck9heUlFREtNTEswWmFqRnBSMXJpRUFuMkhH?=
 =?utf-8?B?Zkx3K1F4alE2R3hTZjUwQXhVcU9SdWMxSGtLaUFjS0hDc3MzNU1CRlk0V3ZC?=
 =?utf-8?B?ZlBzcnRUQ2hrRVJSRzZlVHdTSU4xa3ZqUzdvdHdmQ1ZpQythOXBPODU3Z3FW?=
 =?utf-8?B?ZmgzamRDRGVQVGpVaUo1NmpkMEVBN2FxVElVcWZsOHJpbmtWTjRTck4vVGJU?=
 =?utf-8?B?bTVjSzdHUkdaTHpoNWQ3SlZpTWNuQmNMT2VaaW1aQXpuQ2NtTnAxTmNaMjk1?=
 =?utf-8?B?ajh0Zk1YdG4xRXlLT1hzUjN4dlBCOE5kMzNZempudWRRUnBESkFrcWJ2NW9F?=
 =?utf-8?B?NUtiNkJkdGJqaWdhN0ZaM1ArUXlmZS9Sdk5sK3hibVQ4UXBwNnNBaFZxLzIv?=
 =?utf-8?B?V1lYbkIwNTZmZytlZkVnVzIxNTRyaHNPMjdEQXI2UXVxSXNrL0RRc0VaNmdR?=
 =?utf-8?B?NzRzQmZrSHg3ejhocWJ6UTFCZFNCRXVtR1hQdnB6WFRwcGVlYTh3am4zM0J1?=
 =?utf-8?B?c21WT3dHOEcydzljZ3Nla1FWd1JwQUVMNGg2UndzOVlYVlg0akRNajFXeENP?=
 =?utf-8?B?MGw5MllaTG9Sb1Avd3gydmdERUp4V3l3TVZ5OWcvRDVBU0RwUXhpak56SU1l?=
 =?utf-8?B?aVdUQlAvY0kxNWVZZW1hOU92MGtIVUVhdWRNTkl1UTFhcHlIeXZhVXM0Lys1?=
 =?utf-8?B?NFJwTVdva1BnNWhsWnN1QzNoaVg4RW5xMlVjdWhXWHhpcE1iWmhwMzBHd2Ro?=
 =?utf-8?B?UndNdXVwaXc3S1lSTnpOYU9mQnNab3dvSHA3d1BxSHpsWmE1djZPV2hiNG1T?=
 =?utf-8?B?WndZZzdPcVh2bEM5U0JrWGRZZEZUTGlHY2crS0NhQU1WS3pVQ1ZJbmt6bmRz?=
 =?utf-8?B?dzZVYkdIeWRuSzAzYnN3TkRwSUw3d3c9PQ==?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a1hCTXFxNWkwRVdEMzY2VFlnUU52T09qUnloQUs2NEpuZWJ3UXhHOTRDcjM5?=
 =?utf-8?B?dWNlZHJpZmtBVCtjWUxvLzF1dEdsUEFpNWZHaFBtK2lCQjM0OUtET0lPSENN?=
 =?utf-8?B?bmp6N2NIOXcybXYvN3pSTkVlV0hCTnJ6eVJwTjAzNFpnOEtCelMreklrdjNz?=
 =?utf-8?B?WU40RmV4dExiNEFKMDNDK1d0T0lJeVhjRzR0RS8zTzRhSGhiS2JXa1RHVW5Q?=
 =?utf-8?B?Q3FaVkx3cGNwS2NjdXJjSjViY1pVL0c0YTRwL0J3T25ITXhQcjl0UDJUdURl?=
 =?utf-8?B?K3Y1VzlkVU1pdCsra3VaeFZOcVo0anZyVldMVkxwcmNBYW9pVkNUeFFPVDlv?=
 =?utf-8?B?L0lqb2N1UFl0ZitQMnVsZllyUWtjb2UxWXBLVGZQUDNvVU9ibkhZNC9OZlNs?=
 =?utf-8?B?OGFBak5qKy9Id0xjRStKSlNUZnA1Z0J5VlA2UW5nYzBQcWNsTmRJRUlWVExR?=
 =?utf-8?B?QkxweVBPZXUrMysrUjdNK1dwYWZTY3RBRWIzUlViK0RiUk1ySmJrVWlWUEhD?=
 =?utf-8?B?cEhWdzVvbXFhaEZVYmozdWEyeXFZalRneHJHSWY1c3BZZW4yOHA4bFBYTzI0?=
 =?utf-8?B?Tk1Wa1plMEhKTVF6RHc2cVB3RXNONVJqZml0SXYvVG9wT0VKNnJGOFc1Nkdl?=
 =?utf-8?B?anB4cGtITGxLN01sR0hjSHJVSnNUK2k3Y2FmdGNBWldHb0RXNlVPTEk1Z2Vl?=
 =?utf-8?B?Zk5DN20ycXBheW5nVk9PWExQZHFxb3NDdVUvN1pKY1o4QVdvWG40T045L216?=
 =?utf-8?B?ck1UTDZyR2VtOHdJY3FQWXluK3hGSXYvWm5hbXdxMStKc3hSeXZvQUh4SWoy?=
 =?utf-8?B?eGNHN3k5bEZpM2U3aDI3U1Z0OFVqbTlIVUkvK1VBNGlML0FvNGNVQnRSU3o4?=
 =?utf-8?B?S1p5UWk4bE5uY1NaN1RadnZ4QUtqdTZDaTBZQ2VzUEVBaWdQUFB3MVpZalFh?=
 =?utf-8?B?WjJtdXNDTUF6bFQySFgvUmpNQXg3QlhaSTR5V3RtWm80UWJkM05wSktGLzZ0?=
 =?utf-8?B?YkFlbjgxVDVwamQrNTVRSTJ1MStTVERMRk5JbkV5Y3RwOElJTGp2YXRBVE5E?=
 =?utf-8?B?TmdSa2ExNFpsMFArL3k5Yk5QS2d6S011UXA1L0xOTU5mRVNRVEhndHZKamxr?=
 =?utf-8?B?N1FEWmxGazVNOXhTeXIxL3ZKeVpCMTErR0JWVDNmdWxCY3hveElZelg4TWIv?=
 =?utf-8?B?UWJwRDVjdjVJQ2l0MHFjc1J4Y2txamhNcW10Zko2ZXY1SGlZQTBNaytZSUhs?=
 =?utf-8?B?d2ZrMTcxYnZUMm5neVk4TzJxQTlHRWhUZ0VUeU16ZS9MR0tpNmNmUnJJUitu?=
 =?utf-8?B?VHQ3YzAxR1QyTVBoRnJDaHR2WFdzZ0JWUlM1UTMrejZQL3NyckRNMkt4RDUz?=
 =?utf-8?B?dlBTbWY0L0owL09FTU5lcTlSM010eE1VWjd1cmE0V2Z4UnNxNXBRMXRvYVFh?=
 =?utf-8?B?TTFZejRYNWZRVWU4WmRPaHhOd1lxZUhGNzVGa2FISHBSS3lRR3JyNmVIR2V3?=
 =?utf-8?B?MWVkZjJ0WHo2dlorRnhDOUxCblBtUnFvb3l0djJiTzZSazc3a1dZMHNsZ2ti?=
 =?utf-8?B?aGVQOWkzUUY4UjRYL1pDYU5LaW5XUXpQQlRXbjhuaWw4dFJYSW11eWlrck53?=
 =?utf-8?B?aTdSc3FtOG1wYU5PYSt6eENlbGlIR0g4UzNHc2JFNWJsdUFmQjdMU20ySjhs?=
 =?utf-8?Q?ML7LPyoS9J0sGjpYKQnp?=
X-OriginatorOrg: sct-15-20-8534-15-msonline-outlook-c9a3c.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ac8d9d2-b0e5-42c4-a241-08ddded325b0
X-MS-Exchange-CrossTenant-AuthSource: TY1PPFCDFFFA68A.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2025 03:47:41.3359
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR02MB7913


On 8/18/2025 1:42 PM, fangyu.yu@linux.alibaba.com wrote:
> From: Fangyu Yu <fangyu.yu@linux.alibaba.com>
>
> According to the RISC-V Privileged Architecture Spec, when MODE=Bare
> is selected,software must write zero to the remaining fields of hgatp.
>
> We have detected the valid mode supported by the HW before, So using a
> valid mode to detect how many vmid bits are supported.
>
> Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
>
> ---
> Changes in v2:
> - Fixed build error since kvm_riscv_gstage_mode() has been modified.
> ---
>   arch/riscv/kvm/vmid.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
Reviewed-by: Nutty Liu <nutty.liu@hotmail.com>

Thanks,
Nutty
> diff --git a/arch/riscv/kvm/vmid.c b/arch/riscv/kvm/vmid.c
> index 3b426c800480..5f33625f4070 100644
> --- a/arch/riscv/kvm/vmid.c
> +++ b/arch/riscv/kvm/vmid.c
> @@ -14,6 +14,7 @@
>   #include <linux/smp.h>
>   #include <linux/kvm_host.h>
>   #include <asm/csr.h>
> +#include <asm/kvm_mmu.h>
>   #include <asm/kvm_tlb.h>
>   #include <asm/kvm_vmid.h>
>   
> @@ -28,7 +29,7 @@ void __init kvm_riscv_gstage_vmid_detect(void)
>   
>   	/* Figure-out number of VMID bits in HW */
>   	old = csr_read(CSR_HGATP);
> -	csr_write(CSR_HGATP, old | HGATP_VMID);
> +	csr_write(CSR_HGATP, (kvm_riscv_gstage_mode << HGATP_MODE_SHIFT) | HGATP_VMID);
>   	vmid_bits = csr_read(CSR_HGATP);
>   	vmid_bits = (vmid_bits & HGATP_VMID) >> HGATP_VMID_SHIFT;
>   	vmid_bits = fls_long(vmid_bits);

