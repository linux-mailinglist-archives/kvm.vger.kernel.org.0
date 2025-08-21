Return-Path: <kvm+bounces-55226-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 31FCCB2EB6B
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 04:50:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 14075725327
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 02:50:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3CF6267B90;
	Thu, 21 Aug 2025 02:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b="c1WUH/Qg"
X-Original-To: kvm@vger.kernel.org
Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazolkn19012051.outbound.protection.outlook.com [52.103.43.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231F9264F85;
	Thu, 21 Aug 2025 02:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.43.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755744603; cv=fail; b=BtvhJnjrq7MrvA8tGqdNU5ytrFJ6FfysGSdT9zKzVLu7x2zwh4f5FIFF92QZNhTklDaD9O300jsyCx7hfUwErvprTPurTFS+Yxuup57PAaK04/gprNuvz8F+QScYDou8mIAqIY+Xjsctdhvei39S48Wy87K11foLhrVxDuTCARY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755744603; c=relaxed/simple;
	bh=+xu2JhTF1VpJ0C1692wcqnLGq5/zjuxiL8beSHWAyzc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=atxzMYItMoodKZPwX+TK4ZgGH5zenYXoRZpDO8/YdpfVojHQoWuqzG8hjgCc+4dTwK2H+8pXdkYyxd5432aWint3TcMi9BLjUkoiRJPeZohgo9hC01RCRqEu3lQg4mJROhszl8l/6mwx4U6+tFZsBC8JoTkO7mrL48lnvqM5txg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com; spf=pass smtp.mailfrom=hotmail.com; dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b=c1WUH/Qg; arc=fail smtp.client-ip=52.103.43.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gihGxLes+a6izttPhf2XH8v10tLcWHHlGTmKmHTLnNljWXt0rwblDM7IITYvu+E+rEptSWRcTOCkIrpbZRjzd/tVxN3kGyXfTfVPLtpsMdjsZXQhqaD5sMwA88LtLlXJNvqDXlxweugU3/0BZEMEIjL8aBVNdbiyNtMLjrxVu+66jo8OF7wHE4PEFeXuEXWO2oqGG4QPttOIqLxTk2O5VEKMq5nWTLF1aoJPi14m+GmpJc9WGEwvT1ofkQfKdD27SP3MdL7ssEgeJz5T5Yvp977VZ3NrDR9Cgq1Zjp4maQ/6V71VsGETUiudMeNMEHMeUoIdRer6JspqEpMmmj9Gsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4Wh8qPuvQgHTOf/Ub2JiwYRJnnOF2t7CaRxUU05fr78=;
 b=NUiaxl/vrcKN8cjpsEw+271Uqg7SWch3OC0Vn56d1hDIpTf/Pr1L7FJ1pFX6ytoX+ijuwBVFPgkfsjpvwWp5kvh+FOTFS4CWiQhaabNwJR0qsqQEXcjDArs9SYcwxPuwGkb9IdkvvwMss8WD0V0JkCs6r0vYT9Jd4LswMg1Ixk3BohJjk131t52uryg+eKGheLa/+URxEnZ2uWTq72Z3uLM/nA6sGSk+jB0SCvzGyFtOHacVhxMI5vCyXDz9mh6NMN06a7ovBA+oeTrscjyqa6VL4zsFRB/wM/eS1MLpHhEqVVI9skwnfcL5poGK8D4/rYuIE6bxELFRQmVsqF2R8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Wh8qPuvQgHTOf/Ub2JiwYRJnnOF2t7CaRxUU05fr78=;
 b=c1WUH/QgQFNzvcQ8L2rGnw25atMBULWXX1qKDpzhok5Mq2chu+8JJDIyP6pmjMJtXzSsBalBNkDwTaMJUdEyqFUlfisnBvnosXBtQP1L/ExhnJPZFA0kQxHUfAAp/RpV13g7oqQz+uHmw0UQ8rV2kt0ARoRDFEyw27TZJhvcKmlb7P/yF1x1OUEZTBRqGtN20IpqrdMvCqKyvWojHy+DyX5TzugV5ecnlhC6iwOgUxsQayxEVkWg1S2TaLyA4GmRnSXPtV/DQvoY9/esTuxl6S1oqX/RgpuDoixAHtziUuUA+bZSy8tDNo2MyNFZHZBuh/FoPyagitZOEQZOtrKXEA==
Received: from TY1PPFCDFFFA68A.apcprd02.prod.outlook.com (2603:1096:408::966)
 by TY2PPF0E7B5C0D8.apcprd02.prod.outlook.com (2603:1096:408::985) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.14; Thu, 21 Aug
 2025 02:49:56 +0000
Received: from TY1PPFCDFFFA68A.apcprd02.prod.outlook.com
 ([fe80::209a:b4cd:540:c5da]) by TY1PPFCDFFFA68A.apcprd02.prod.outlook.com
 ([fe80::209a:b4cd:540:c5da%6]) with mapi id 15.20.9031.018; Thu, 21 Aug 2025
 02:49:55 +0000
Message-ID:
 <TY1PPFCDFFFA68A1D3B18B1133B8B28B1C6F332A@TY1PPFCDFFFA68A.apcprd02.prod.outlook.com>
Date: Thu, 21 Aug 2025 10:49:45 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] RISC-V KVM: Remove unnecessary HGATP csr_read
To: fangyu.yu@linux.alibaba.com, anup@brainfault.org, atish.patra@linux.dev,
 paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
 alex@ghiti.fr
Cc: guoren@kernel.org, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20250820125952.71689-1-fangyu.yu@linux.alibaba.com>
 <20250820125952.71689-3-fangyu.yu@linux.alibaba.com>
Content-Language: en-US
From: "Nutty.Liu" <nutty.liu@hotmail.com>
In-Reply-To: <20250820125952.71689-3-fangyu.yu@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0090.apcprd02.prod.outlook.com
 (2603:1096:4:90::30) To TY1PPFCDFFFA68A.apcprd02.prod.outlook.com
 (2603:1096:408::966)
X-Microsoft-Original-Message-ID:
 <b948a281-dbeb-4d0e-88e6-a5173b75003b@hotmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TY1PPFCDFFFA68A:EE_|TY2PPF0E7B5C0D8:EE_
X-MS-Office365-Filtering-Correlation-Id: fd410fa6-a931-41fc-4eb1-08dde05d6783
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|36102599003|5072599009|8060799015|6090799003|19110799012|15080799012|23021999003|461199028|3412199025|440099028|40105399003|12091999003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QjhOYXd3SERqVVUxL0ErdVJMNnZQREN3U1Z6Vi96YW4zcGNHMjlqYzVPV0Fy?=
 =?utf-8?B?QzRkUWRzM0taVklmbVE1V3JCSWNnc1pUdENKcXVGd0wxcG9nbWRPcDhEekV5?=
 =?utf-8?B?Zi9VdFY5MVBwUTdrZDFDdG5ZRmZ4UzBuNDRjTGhUUXNzSkh6ajRWU3pZUDJa?=
 =?utf-8?B?T0ZlcTU3Mm9pUzQzM0pWZ0FZQ0puNEt4eGdvT2Z0M3E3bThTWElQYTFWMTRy?=
 =?utf-8?B?NmtoeE9aclJHQmxRTGFDOUJxRkZIOTd6YWVJVnJoU1c4NnFkdUhLeENKaWJ3?=
 =?utf-8?B?cWVqd0N3eWJHd0pTY2FQdmN5dzljeE5KVmJHM1NDbjNiSjNsdVRqUkNLUmJC?=
 =?utf-8?B?VGIwY0hpU202WmQvYWhlNkNqR1FLWGRhYU4vbXd3L2hINm9IemhERDhkdEV2?=
 =?utf-8?B?UXBWMGpYTktnTXl6ZS9uQWRCNW9BVnIwOVk3T01xUDZaNUF3SXZOaUpRZGNH?=
 =?utf-8?B?U0hlbVp4RUZWYjBGaEhzNnJxUWplaGFwNm1BQTFTSWdqMVlwVFh5SllyVHgy?=
 =?utf-8?B?QzJsc0N6ZE5kTnphakYxSTgzdHYzekMzMDI4dnBrOVBRZ0grak8zRDNENFFG?=
 =?utf-8?B?dDkwSWpyNmFFT2VHV3JMbGNURExlVFhGL2N3bS83eUJFUDdjaXE3dlM3dUlE?=
 =?utf-8?B?M0xJejRRZ2M4dTZ0NXlib3VTMk10aTJCRmxiT1VBckVjRDdBZXlrUGJUa0wx?=
 =?utf-8?B?Q1BiaTF2SzFlRkppTVpDcnhFaEJDMXZRSU9SQ3hxdmthcm1aTkY2VENUdWFo?=
 =?utf-8?B?QURENXZGSW9tSHlrV2k1YmM0bU41UTBiS0M1dDZuS3QrRkhIQVVnd2ZZa1RH?=
 =?utf-8?B?VDBxTkpLNWxpMVZ3MTg0dEZRSnhPaHYwSnhobXAxQklBOFlublU2aGszOUln?=
 =?utf-8?B?VHRsTkYwT1B3QnBNQ1lqV1RDa3lwa3JucXU3cWF3M3lpOXFNeDIrRFNacDNW?=
 =?utf-8?B?NkRMdnlNSlRpeGdmcS9Yb09USEM0RFVwVEZIOThoZVEyTXVjbUNuZm9wNUVj?=
 =?utf-8?B?ekdNbUhJK0tDNHZXbWJGQjRRS1VWaDViNUpHZkloNEJMZjRnV3AxNkJEc1M5?=
 =?utf-8?B?SWg5Vkdnblo3c3g5ZzJkUkV3ZlVUeDEzbnJrNnJVK0cwS1pzeEZRdjB0bWM5?=
 =?utf-8?B?WGIvWnFhNUVITjNnYklqWGdGSFdwSG13eGVLS2FuN3d4QTg4c0tjUXpEbk9H?=
 =?utf-8?B?bm1ieUduU29wTmdXZkJmWDNMNmZ5NXM0U2hMdWJkb1Z1aEdLQjUvdW56b3lC?=
 =?utf-8?B?SCtkVjNBMDVhS2R5RVRpU2tkSDhwK1kyY0dYblQwQ2h5OURRUXlkL2E1MmVv?=
 =?utf-8?B?eTBoYjU1TExER2JrVENlRzJyUGpFcW5qN3FvMzRKQzNScTFjVDNBMmJDTVVL?=
 =?utf-8?B?enRyOWcyT0lTUWRrTXpRZFIvT0FlNllPMWpGdkZSQ0xLeHZYbmZ6MFRNYUpE?=
 =?utf-8?B?SXVXTGI2UzM0ZWdiMWF2NXRsNGd2R0p1Q1J6OGx5NHN6Z096V3RWYmFtTmp1?=
 =?utf-8?B?SWc1UHBFMFYvUE5ld0JjYlZSOHVKM05iMmZoWUFTQVdoOXVRU2JFOGZMSU42?=
 =?utf-8?B?OTY3VTVZMmMrM1pscVVzU0xnSE4rbmlXZWYzdkV5ZVFLTXRDNFlDZG1qTkVB?=
 =?utf-8?Q?J4s/DcZItN+LQpiKdo63RAq473UtuD6GbK1jxgkXscDs=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Vjc2Y2NJMEdITVBQaFJLYlVpTElXOER3M2ZUZUJrV3dRdG16N3M4SkZpZ3My?=
 =?utf-8?B?TU5FS1NaeVpXbm5jY3BEcEk3d2s2ams4dXBxZ3R4bkhDL3F1YVd4REFjYlJi?=
 =?utf-8?B?QWpyaUJ4QUdRZ2wzbVg5d2s1L1B0UlNxRjdCeXVmMHJFVFFGaGxuS3pRNVNw?=
 =?utf-8?B?WG05cDdMQjJKU2NuUE11RXRTRkZBZjZuZzdGeVBEanBmeWVFemxMVnJIdVRx?=
 =?utf-8?B?U1I4alByY1lmOG0xd00yWHdkQTd4aWdrZzJDRXdCWmN1YklHV3hyTVNvZXNu?=
 =?utf-8?B?dVN6VjRSMFo5aElUSnI5bVpSVGoxQzRBZjBraFBmOUlRTVVFMU1yOXZ2L2V1?=
 =?utf-8?B?SEsyeGZxOUV1U1hKTHdGaWxuQlo3TU1WVEROMmM3bXMwZ1JaQ1U5NVdQaFVR?=
 =?utf-8?B?QUcvNVVZaVJUOU1Yd20yQUhXWndEUi9EZ3FiaWE0bTlnbVM5Tll0YjFVRFFB?=
 =?utf-8?B?OU84SE5sMzZvWEtSNGl2ZXJac0tUM3MxcGNrT1pYUXIveDMrZ3hoelpHYUpi?=
 =?utf-8?B?ck1KOU1HV2VMVVRDbjVNOUF1L003bjBiK0NuL3JrOEVzY2tLQlYwY203WTFi?=
 =?utf-8?B?TjV0dzJGcWh4UllZQ0tmQ0xta0YvTG0ya2ZaMGxvQmdNVEROSG1WREFHRlFu?=
 =?utf-8?B?MkJycnNEd25OV1VwNXF1MkpNM2VJdzFhR2FEcUF5NzkzOWM0L0RWeWw0VTIz?=
 =?utf-8?B?ai9hM3lVN0F4NkluMTVQbVhmcnM2ZVMrWmRPVGZvL2tMSDhEaFY3RlJXd0JT?=
 =?utf-8?B?SEhUb3lGTzA0bEdmcnRaeE9iaWpmMzNobGwzNTkzOC94VVRSdy80N2hRVzJr?=
 =?utf-8?B?a1VTUVFqbE55WUFvVjgvU1R6Y0ZLMXVPbWxVYnk3dDZmNHpaeUVPUk1lYmlx?=
 =?utf-8?B?UW5ZWDQzZHRhOUQ5bVZiVGY5S2FrcUN4djZlRHYrdzZwQnViUzc3M2FieU5T?=
 =?utf-8?B?MWtFL0d4d3h1ZSt1cUNaT2Z4cFNaaVE2NmNtTStWUTVhYmFUWmV4a2xBTE1F?=
 =?utf-8?B?K0FrN2hrcGlpVVpaYThDNlpKZnRuSFFsWTQzQ2ZEWEtXbSs5Uk9YTEpUZVdL?=
 =?utf-8?B?OVVRZWpnSU0zakQwZXNwd2RnSW5LUmpuNzRNQWo5UVMwMndROVB4U2JGVENJ?=
 =?utf-8?B?ZzdKcEt1MjdITjlnUHQ5R0MvdmQ5QlFsUnNZVWJBSEJ5VldWd2ZpZ3NVRy8r?=
 =?utf-8?B?MENaLzEvZzNLWityL0xmcUova21oMk0rNmRyZzdQanFhRzJTRlllbzhocmxw?=
 =?utf-8?B?bmxGOGx0c0d4b1piQ1JLOXlQQVZpb2J1cXRMS3FWeFA0dWtQc0hZZFZxYzlJ?=
 =?utf-8?B?Y0RLOTNMRk1UZlNoZjRZQm44LzQ0cmFmMVBtTGUwYUtzdk4rSnlNYS81K2VP?=
 =?utf-8?B?L2drMjluRXJ0S3pTUk9qTTZMbzU1bzF4eVF3UVlEWWM1Vy9kNzN3cjNsU29G?=
 =?utf-8?B?cGlYL3R5NFhIK0RXVzlsUFc4enNPM0NreUhBVlYyaDAyK1l2WHhkaTFCSWp6?=
 =?utf-8?B?TklxckJYU3h5Z1lEUTB0WGFJSTZkODF0WjV6SjhzcG5ncmpRVk5sR09SM1h6?=
 =?utf-8?B?WG5iMC9hRzNJM0FSNmRTZTF2RDl1VWE3N0FQOStRTExNcHB3NXEvUlRKL0Jh?=
 =?utf-8?B?REVCaTFzNG5vR0NXWVJUS2NlRFpicU4rRys2cExXV1pMaG0rMlc3eFdJMlIz?=
 =?utf-8?Q?MuQiF5QtYH/eTWpv4aTM?=
X-OriginatorOrg: sct-15-20-8534-15-msonline-outlook-c9a3c.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: fd410fa6-a931-41fc-4eb1-08dde05d6783
X-MS-Exchange-CrossTenant-AuthSource: TY1PPFCDFFFA68A.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2025 02:49:53.4390
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PPF0E7B5C0D8


On 8/20/2025 8:59 PM, fangyu.yu@linux.alibaba.com wrote:
> From: "Guo Ren (Alibaba DAMO Academy)" <guoren@kernel.org>
>
> The HGATP has been set to zero in gstage_mode_detect(), so there
> is no need to save the old context. Unify the code convention
> with gstage_mode_detect().
>
> Signed-off-by: Guo Ren (Alibaba DAMO Academy) <guoren@kernel.org>
> Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
> ---
>   arch/riscv/kvm/vmid.c | 5 +----
>   1 file changed, 1 insertion(+), 4 deletions(-)
>
> diff --git a/arch/riscv/kvm/vmid.c b/arch/riscv/kvm/vmid.c
> index 5f33625f4070..abb1c2bf2542 100644
> --- a/arch/riscv/kvm/vmid.c
> +++ b/arch/riscv/kvm/vmid.c
> @@ -25,15 +25,12 @@ static DEFINE_SPINLOCK(vmid_lock);
>   
>   void __init kvm_riscv_gstage_vmid_detect(void)
>   {
> -	unsigned long old;
> -
>   	/* Figure-out number of VMID bits in HW */
> -	old = csr_read(CSR_HGATP);
>   	csr_write(CSR_HGATP, (kvm_riscv_gstage_mode << HGATP_MODE_SHIFT) | HGATP_VMID);
>   	vmid_bits = csr_read(CSR_HGATP);
>   	vmid_bits = (vmid_bits & HGATP_VMID) >> HGATP_VMID_SHIFT;
>   	vmid_bits = fls_long(vmid_bits);
> -	csr_write(CSR_HGATP, old);
> +	csr_write(CSR_HGATP, 0);
Seems there is no need to set 'CSR_HGATP' as 0.
Otherwise,
Reviewed-by: Nutty Liu <nutty.liu@hotmail.com>

Thanks,
Nutty
>   
>   	/* We polluted local TLB so flush all guest TLB */
>   	kvm_riscv_local_hfence_gvma_all();

