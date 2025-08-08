Return-Path: <kvm+bounces-54308-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B1345B1E0D3
	for <lists+kvm@lfdr.de>; Fri,  8 Aug 2025 05:10:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 523E6627839
	for <lists+kvm@lfdr.de>; Fri,  8 Aug 2025 03:10:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24ECE19CC0A;
	Fri,  8 Aug 2025 03:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b="M1A8AjoI"
X-Original-To: kvm@vger.kernel.org
Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazolkn19012055.outbound.protection.outlook.com [52.103.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8574D645;
	Fri,  8 Aug 2025 03:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.43.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754622607; cv=fail; b=lJuqDEQV+o1J6yCIGqoOSxfmud5dJp1uqj1WRtqYSxQNim0yfQYPW+ANKBHMX7fcyWfmCN5nEp8Dkh6ZOKmCaZ+rW8m13/lmFu7BgDKv7BGYh79ukKihYoEybgUkaBRWaemKTrTHCyQxr6RFi0r4ifYw9JdfuXkPuc0lSQ8bM7E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754622607; c=relaxed/simple;
	bh=pPm0WjF7MZ6ZAS8wMwZBPRvfsUbRoQWFzJDBGu7/cf4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=avhvxeoFmTYuumjHRMDOYm7xuq3sI8SgE8U6h+XkoaXTvOHN9pbGhLFpfdc04kktPK2kZiNwNaRyPXk4fm+HzMXsM1G6bSbZjTXtq0+hIhKUVg6o8bygPi3JHOHYVMKb/G/HfNIRg5BGh8x5pVea2PBQszHPWWOBTBZnAJ5ZgMo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com; spf=pass smtp.mailfrom=hotmail.com; dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b=M1A8AjoI; arc=fail smtp.client-ip=52.103.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WLdbQO+SkLzl3zPf4+BDyJmlv/lMNHGUDLWqe4o9e++pvJELYB1h+Ud+zfb+FxPWb0LcGf9/Uh3g3nLQvhpSDGMxzGTUKI2fne7XfkbQ33hKVtbx6Ot2iJunTkJoDrp71kHBhQI2vUOiggc8n12zgjHfiPlegraeF7l2cQWdtzlvRVs8CvmTjQF/pNAN4eBrU5LUBTKn7caBcWNurPMor6QlOCZRqRfyYEbNuc+B6x7WLy0zCE43DyCDz1FZ1dNr+Ktl3MD/Hq2E+xD6D0nBrimQqYc8JpuuhmyN7Poj+/X4PHoJnZL3b6nwMa7aqVKzRmK57e8Wzt/AoUmlfrkYCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QHvCSPwQ0Z3z4AcVW+4YSIvsCo1xx2o6/L6gwmKltso=;
 b=cKVbVGHTbOZbij9U13dmyWkBHAfnKnpFAWyJjLDBWXuNAQOUUvb3E12Doqb49oQ0ksCN1qZKDRhhZLgvaNkJHB5TJel9fY5pzUWRRfLNtw0l3YXrbzgfwxSROf/fKBsUH7WMdelaBj0ZwiD+LINUivg1VSJPIX67p183bOcNPyY31VqYRK9WqVylFwHdEzNv2E3MeJsWWk7wJbxUmsFrOgd+dar7rs6SV4xbdjIM3VfmutYeW80j+x7s1PZnKEJJkbEvgrHvjlKb6/8NHK2AoujoxAFOo9q2iOWjcWenYy0wcx0gNickbBLD3SOwl4NujkfxKauKceeh48LOW3oaTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QHvCSPwQ0Z3z4AcVW+4YSIvsCo1xx2o6/L6gwmKltso=;
 b=M1A8AjoIH0E+EWUE5/EzfCyY1KTtORPn3dISHhlnNzbQb5w7km5zPBBBdzeOJemVNmGSFHsw6yCStbDV8GPxKi6zLL08LLtQcI9Cg4XI6+vSdeYrMehL8cjJZtLNeVVHrE0nZwBaU6R0WxawgnV6f3/TkclJ3HEzhPQJ87gV1gTVIlHx09B0QlHhE+12Vve+J4xI9sknsYmq7Xk8UkkvNn3oThPq09UxUvhpWvGxFy8oFrw1Z92VJpzRTd1lJq+qVTI4Yz9aQupNf9Shga2tfXQnY6jlPnh1T+Y6ev5RHxTzJR57Cq+49xRA3mtojFXUfczgYi7ujfWhtyAVvV00Uw==
Received: from KU2PPFB98B58DA6.apcprd02.prod.outlook.com (2603:1096:d18::466)
 by KL1PR02MB7407.apcprd02.prod.outlook.com (2603:1096:820:118::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.18; Fri, 8 Aug
 2025 03:09:58 +0000
Received: from KU2PPFB98B58DA6.apcprd02.prod.outlook.com
 ([fe80::a44d:d17e:c1f1:2eda]) by KU2PPFB98B58DA6.apcprd02.prod.outlook.com
 ([fe80::a44d:d17e:c1f1:2eda%4]) with mapi id 15.20.8989.018; Fri, 8 Aug 2025
 03:09:58 +0000
Message-ID:
 <KU2PPFB98B58DA6DD6E50BA60CE58174011F32FA@KU2PPFB98B58DA6.apcprd02.prod.outlook.com>
Date: Fri, 8 Aug 2025 11:09:52 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] RISC-V: KVM: Using user-mode pte within
 kvm_riscv_gstage_ioremap
To: fangyu.yu@linux.alibaba.com, anup@brainfault.org, atish.patra@linux.dev,
 paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
 alex@ghiti.fr
Cc: guoren@linux.alibaba.com, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <20250807070729.89701-1-fangyu.yu@linux.alibaba.com>
Content-Language: en-US
From: "Nutty.Liu" <nutty.liu@hotmail.com>
In-Reply-To: <20250807070729.89701-1-fangyu.yu@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR01CA0136.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::16) To KU2PPFB98B58DA6.apcprd02.prod.outlook.com
 (2603:1096:d18::466)
X-Microsoft-Original-Message-ID:
 <3280c608-24ae-4ea5-aba3-a401c39f4ad6@hotmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KU2PPFB98B58DA6:EE_|KL1PR02MB7407:EE_
X-MS-Office365-Filtering-Correlation-Id: d587020e-a77b-4bca-2b77-08ddd6290dc3
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|6090799003|15080799012|41001999006|10112599003|8060799015|19110799012|5072599009|461199028|3412199025|440099028|53005399003|40105399003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Wkl3TEIvQXlKN21IaUtGOTE4Z3BVZWhBRjE2SzBYSU5YdStNZHZJM0FQeVFV?=
 =?utf-8?B?MUdyWngwVHBCTSthM1d3UHRJS1FGUmMyQkZ6WkxDSjNuWWZyTkN0cVNPb2Fj?=
 =?utf-8?B?UVlwL0ZSNkZxeUwwNzc5QnZTZjNJZXRzdmdmZUEzSXZRbEF2UDJZQ1lRaVBx?=
 =?utf-8?B?WkdrMWdRS2F4SXdkeUNRVWQ1WHJ5OE5vRXJwUHFyVytUUlB0aXZud3d5Mldw?=
 =?utf-8?B?aEd1Sk5HaUNWZXhzRlh4UmJ3ZUh2aWZ6UjgrRmY3L1JLNG9lQnI4MkhEcktv?=
 =?utf-8?B?LzVsWUVhZkZxVTcybEsrVmpRZSsyNHhSblEzNlhVR1pjK1BRTms5Nk9QVlBS?=
 =?utf-8?B?L291SnRxNFF6eVNjcTZudGVHVTJaVUV5NHNwdkM4UGN3dlpUdzQ3bDZRaTBP?=
 =?utf-8?B?UlpXUXF5Qy9LY3ZHRHBEQSsxUHNSQm14Z09oQmhTaytJSnpxZ2thYVlqdHN3?=
 =?utf-8?B?amFJQmVSOGJrMXNkWmpRUno3T2w2L1hvTkxYTkZXT3lrSEtZcHo5cTlyTWZ0?=
 =?utf-8?B?dmlUaG9VSk52amFBNlBFcERJZzMzb3VleHFiVDRTeUVCbUtEMmlmTmxNK2g5?=
 =?utf-8?B?MFlMM2NDN05LemFFK1lvUDdLY0FqZE5JdWo2STBGQWtkSEJvYlB6WG1wZ0V1?=
 =?utf-8?B?U3dLdTJLaFd6djlPaUFpWjhQVFY5N3h4RW1meDFwclp6ZUs0YzlLc3kwUWFX?=
 =?utf-8?B?MDhRVHdPR3ErdSs4Q01Gc21LbEE3VmU5MHJmbi9aMzhMb0tkcEtsUlMyZG5j?=
 =?utf-8?B?aGFLMVNQZWVNaFI1K3duRkYyb0tBTHJyd2NSeGlWSVM3dnpiMXBkMGg4akwx?=
 =?utf-8?B?WlY0a2U2NHNGMkxrWjFpSkxDc2ZqK0pXU0RjaCt0UmQxSVdiUFVCL3ljMEg5?=
 =?utf-8?B?Rm16d2NDdmoxN3g5ZXkxc0ZZbjRibVRxWDF4ZldKOWsrVU5qd09DVWROSUhT?=
 =?utf-8?B?ZmltTlp0dFpiZ2p0VTNxSmlzTkRUZFM0QXREWVJ1aDlyQ0dmdmJaalRBWTk1?=
 =?utf-8?B?NFduL0o4ZUNPVW42RlR4b0s3czMwM0pCdk5nL3NIUVh3ZE52RXZmUnlsNDQ5?=
 =?utf-8?B?OHBFR2EzVGNRbTNiSlBmV0hhNk4yMTRxdzhjUDRLTUNBQUdKOUlxQzJ4NHhP?=
 =?utf-8?B?aGJFelkzcHh0MnJ5VDVxdjBiUFJxZUsvb09xOGRuMkRqUTF3eWl4eStWOCsr?=
 =?utf-8?B?YVppYlIrckFIR3YwWll4L1RaakRRc3VTTEdLeU5uekRiY21MdXRqaFZoZ1Bh?=
 =?utf-8?B?czBiUFc2MlE2OGlxb1Brb0VxL2Fzdjh6SmducE1hRU1lR05UV1VEVGdXeUl3?=
 =?utf-8?B?WVVjOXQ1RVppeGszWkZnN3FnV0dVbFBvWGljTXhjSlZqVXhobEt2azdUNmlS?=
 =?utf-8?B?WThSUVFjVUxYOHpsUDRjOVpMczN0ZFY0L0F5NWcxaDNWZGNVeFZqUDIvSHRp?=
 =?utf-8?B?YU5yREhiUm1QS0Z6YUxLU1NmTnpYRHZCb1dVdXNVdjRsZHloWTducW1TZVFt?=
 =?utf-8?B?WFVaZFdyMEtpWXh1RlFrNitYeU9pK05ZRFlTaDVBYTdKc3ZVUFBYMlkrbXJi?=
 =?utf-8?B?OXVMUWJ3d0lGd3VoN1gzOEx2NEFNWUpSZi96SndycVZLdGthY2tVbWE0ckV2?=
 =?utf-8?Q?8/oxt1bBKKWdOje4Os3Ym7gRTIw6BgK1x/QStAw4DEhE=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dEdTMVRPUFpScWpjTDcvZklKRURldEtMalYycXNMVjBiUWxZMitYVWVHSGZQ?=
 =?utf-8?B?WWxndXJVeXJnMUhLSUNSZ2hHRUUwTmJJUUJBVm8yMzFrUGFpdjhRSGdkTE1E?=
 =?utf-8?B?L2ZZRUw1blFuby9nclVGbVJDTllYRnNlK2orbkV6VVg5Ui9iNk9jUjY0UlRM?=
 =?utf-8?B?SzFnVE9UQmZDS3BPNWx4SmNtMFhUdldpUUdtcXcyZjJOcUk4eFoyMmVCR0s3?=
 =?utf-8?B?S0FCM3lzZzNNb0pveUhaU3IyZUNFNldEdmZ3bnNJR3dRZWFkdUFVSTBaWGhn?=
 =?utf-8?B?MHdzUk1velZpUEcrbWszb3lIMEkrd1ExbXRsNWI2YXJjVm9PSkFBeHljQVZB?=
 =?utf-8?B?TGdWS09uVSs2SVcxa054SVIxdDNSRERBL3hzY3RMZEJRS0thMnhGRW9MalFQ?=
 =?utf-8?B?RWdURFNEUmdWTWdXblJpODE2ZjVYNUZJZWl3M3creDF5c3ppVklRTlJQS29k?=
 =?utf-8?B?ZWhMTjlRSFB2d0JsTitwekx4bFowYXYrNGdSc3JpWVArWFVHMllhMll4MlJC?=
 =?utf-8?B?V2RxN0NUM1FNVFNzbDc5d0UxRWdaMytBbXhBSlIxS2ZSTm01clQvWFpGOUtL?=
 =?utf-8?B?RGNZNmJtUFpQMVVXWTNlaDNHaU1oeS84dE5YSENIZ0k1ckdqbUZyWGZkOWJ6?=
 =?utf-8?B?NEVUNUc5K3BISGtlQ0t2MEk1dXVPN0ZacExhS2tnT3pKVjVJb2RIa0dqUGE2?=
 =?utf-8?B?L0pleG1UUURWSmUvbE9lSFVCanFlYW5FVUJRNjRaWTJNemtZVythcE90UXV2?=
 =?utf-8?B?QmVPK092QUg4TFZNZlRKaU42NVE4TmRZQ0c1SHpmb2ljcG1kVGtxYUZYdTFx?=
 =?utf-8?B?MjR1TWdoSHJxS1pGa3NESC9kRG9nS1NTdGRWT2pteENtRjF6ZlpPQ0J2Tkdq?=
 =?utf-8?B?VmIrV2c1Sk90M09RLzlXdjdEelRCWmk1K1Z2QXg3RGJRWWpXZDVyWjBySHVJ?=
 =?utf-8?B?eE85QzI4ZzR3QUlvaGc0M2JyVkFjRDRHY3o2MjQ4M0taNVZoVkpPV21yanFZ?=
 =?utf-8?B?UE1SeHdqUys1K1Zab3pIUlQ1UXp0emxVOVZSNW5IcVRkQVlKRzhsQ2g5NVpN?=
 =?utf-8?B?SWFua0Q1MGpuWjE2N2g1ZUZnV1NuYWJ1Y0Y4bGN4QVQzbnp6WkM4RlVJdWR4?=
 =?utf-8?B?ZTN4WVRGMjhUT1BPL0ZmbkJWZE9OalBOZ3JLekJPb2ZhSC9vQldGRmo1OGd4?=
 =?utf-8?B?cWtWZU40ckgwOWFzREYycmZsUEZUbDZqQ21RRnJCT0NKZENmOXNiNUo5NUlK?=
 =?utf-8?B?d3Y0cVN2WDFUR1NTb0hmZFhTZGpEbTdJWVdWSDJqNS9zKzFrNHM0cStqOFlK?=
 =?utf-8?B?Y09VRTFqdmRvRmczcmYyL1J1bmNnME56TFhMVUNnVkM5bWt0SFNRRUxXMlFW?=
 =?utf-8?B?UmVvejVIbzZkbWNMaUdRaTVIbDgxWG91aGY0WUY1WlN5MWNSOWtGWTQyNVJp?=
 =?utf-8?B?R0MxZFlHSFVLUW55RWQvMjFyVXBBeHRJUjNjMnBnRWZHN2d3N1k2YktmREJT?=
 =?utf-8?B?S24rSnV0RW5DVlk2WlJjS2dUOG5mc2IzbkNuUEVteEVXcGtQa0xVQ3ArZVFn?=
 =?utf-8?B?VHlIUmx4Sm5FOWJadWd4aW1RWEpVWThLRzl6ajFjT0Jxb0F3Zld0WG5IOXVt?=
 =?utf-8?B?TFZPVlc0Vi8yVkdrVE1Vc2Q2ME1LQmo1VVloSHcwZnBCd1F3ZU95ZDhkV1Vm?=
 =?utf-8?Q?uNAjMRDIeSizI4mklqMk?=
X-OriginatorOrg: sct-15-20-8534-15-msonline-outlook-c9a3c.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: d587020e-a77b-4bca-2b77-08ddd6290dc3
X-MS-Exchange-CrossTenant-AuthSource: KU2PPFB98B58DA6.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2025 03:09:57.1991
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR02MB7407


On 8/7/2025 3:07 PM, fangyu.yu@linux.alibaba.com wrote:
> From: Fangyu Yu <fangyu.yu@linux.alibaba.com>
>
> Currently we use kvm_riscv_gstage_ioremap to map IMSIC gpa to the spa of
> guest interrupt file within IMSIC.
>
> The PAGE_KERNEL_IO property does not include user mode settings, so when
> accessing the IMSIC address in the virtual machine,  a  guest page fault
> will occur, this is not expected.
>
> According to the RISC-V Privileged Architecture Spec, for G-stage address
> translation, all memory accesses are considered to be user-level accesses
> as though executed in Umode.
>
> Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
> ---
>   arch/riscv/kvm/mmu.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
Reviewed-by: Nutty Liu <nutty.liu@hotmail.com>

Thanks,
Nutty
> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> index 1087ea74567b..800064e96ef6 100644
> --- a/arch/riscv/kvm/mmu.c
> +++ b/arch/riscv/kvm/mmu.c
> @@ -351,6 +351,7 @@ int kvm_riscv_gstage_ioremap(struct kvm *kvm, gpa_t gpa,
>   	int ret = 0;
>   	unsigned long pfn;
>   	phys_addr_t addr, end;
> +	pgprot_t prot;
>   	struct kvm_mmu_memory_cache pcache = {
>   		.gfp_custom = (in_atomic) ? GFP_ATOMIC | __GFP_ACCOUNT : 0,
>   		.gfp_zero = __GFP_ZERO,
> @@ -359,8 +360,11 @@ int kvm_riscv_gstage_ioremap(struct kvm *kvm, gpa_t gpa,
>   	end = (gpa + size + PAGE_SIZE - 1) & PAGE_MASK;
>   	pfn = __phys_to_pfn(hpa);
>   
> +	prot = pgprot_noncached(PAGE_WRITE);
> +
>   	for (addr = gpa; addr < end; addr += PAGE_SIZE) {
> -		pte = pfn_pte(pfn, PAGE_KERNEL_IO);
> +		pte = pfn_pte(pfn, prot);
> +		pte = pte_mkdirty(pte);
>   
>   		if (!writable)
>   			pte = pte_wrprotect(pte);

