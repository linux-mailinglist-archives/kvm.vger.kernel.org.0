Return-Path: <kvm+bounces-59503-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id E4F88BB94E5
	for <lists+kvm@lfdr.de>; Sun, 05 Oct 2025 10:45:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id DBCD24E2D16
	for <lists+kvm@lfdr.de>; Sun,  5 Oct 2025 08:45:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7ABF420B81B;
	Sun,  5 Oct 2025 08:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b="ZYk7bSsO"
X-Original-To: kvm@vger.kernel.org
Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazolkn19012054.outbound.protection.outlook.com [52.103.43.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E24C02080C8;
	Sun,  5 Oct 2025 08:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.43.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759653908; cv=fail; b=UNt1eQWlv839Pr5m9ij66TuS1G4mWr8dGetKtfIl1l1dUaX7cLy4s+CtVofs9m3R2/6w4uFoVrCWN5Im5Gg9/cHWGDUXYvfC58q2pYwR4K8/8+67v4maI7OIubTUTLiCoHsvXurGoSV07TWYwwheLIErSA+qIB/UyJJf/GmFnsM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759653908; c=relaxed/simple;
	bh=vFGCYPIPw/tc8ZlAZrzHvwO+ziMWSG25fmRuMUwirZE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sL/VL/YcWRbOGnQhH6WvqJCs4ipNSvIrxT2ny1vqmXNLVDxrkZkqnuyfWuYSZfaSMsaFxKZ5HI8ZQUZAPa13qycfoDmiMospQm2wefyDPbGMXOE3ulcfcI6yoiqIODwxPXGEH2PShD1EVEsPlzr7AyUUI8B05yaOyAYN8t7zm5c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com; spf=pass smtp.mailfrom=hotmail.com; dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b=ZYk7bSsO; arc=fail smtp.client-ip=52.103.43.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XRZ6r5VD5l/HB3H3rhWLp2/WhoOW5732/6MbHf+t09w3XgkSJPKZ6Q/bIrtJzZleZ49eQoIR64qz2TIlMTzZWziZGPMKMVCYekOYNApbIUPhIhDvHwb8sAV8SiqRTjuoy7slKM62Affi9lavNlHFOhyzqEB/LkftDfDLeNtT89jQtph/LIyYYBsb6B4oBAavEAL4J8ibSYKK75NrKPT3cXwWbpVzZ7v2ILWyiRp+MAL/GgGYjLLcDF0OSnrWmW9EXeQpnJY/ofYBfaBGVZTuXFU2tUNBF7/NBHlIi6X2VtDPyv546BTfPKPGcH8F8bEX/HMFyi8XmGEY2mtLzGOvzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OXJFgTe4oER/45wmSoYyxn7VsRpCH/CmzMc8e7FQufk=;
 b=g30Q+yA/Gtv40soM7btdmnj/pUmAU7voOhlXD4GxaddifKgygJZfYSbbsV5TjpvJmclmv/eWoptS40P4a8pgsyWi9pzOJQb3BJ+ivn1Qj8TyCE3Cnp67iCNkQH8o3L4NX3x3pfCJMNwk76vw+3nAf3i+0huvZFK7VNcsvXjpmBVeOcEtOiv1refrgBw2B8wo2LofzbhpOHFuj08CtUpLfa8NxsKVExVVsiHY6JPfA9XWQEascNWSo7tt7L6K5d2PmzBRIc2cZDNAuNFvmwSH1gOJKQ+cK4JbhYbU3C3Twf4COAz9BxXNRr/UA6cR3BaTCmY1+k0OiNvJLYmdHkIB0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OXJFgTe4oER/45wmSoYyxn7VsRpCH/CmzMc8e7FQufk=;
 b=ZYk7bSsOjXiBU0a8k5r8M0nYvmQDFvH4eE27ANm3umQNqpX44mzDCYeMKcqPioXvUpDUCKWXQ6FNfeyYP6u+DOLVPfTQqDcfE4xp5wTHKoTwqeOTRBWqJE41C3K9TY3UtbjPDOyBB77/irG7nVYgLzbUTgEoBL/Xl6pfca082FrCcn6grpxik/0BtX/RAQPjKExY3HwigJf9oKVCWE733krvDnKthvD8c5WSepUNQUqO1DvMVgRibLkdZefs0icSIg/VNRwD2Cqe1H2J9FRkFDettsN8FmNrMHzywg9y9615tIc/KrRA9olO0u+7NYCl7fUvV0RZpSZkXXI306cbbA==
Received: from KUZPR04MB9265.apcprd04.prod.outlook.com (2603:1096:d10:5a::6)
 by TYZPR04MB5805.apcprd04.prod.outlook.com (2603:1096:400:1fe::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.18; Sun, 5 Oct
 2025 08:44:59 +0000
Received: from KUZPR04MB9265.apcprd04.prod.outlook.com
 ([fe80::3c38:c065:daf4:cbfa]) by KUZPR04MB9265.apcprd04.prod.outlook.com
 ([fe80::3c38:c065:daf4:cbfa%5]) with mapi id 15.20.9182.017; Sun, 5 Oct 2025
 08:44:59 +0000
Message-ID:
 <KUZPR04MB9265F2B6E662CCF1C6745155F3E2A@KUZPR04MB9265.apcprd04.prod.outlook.com>
Date: Sun, 5 Oct 2025 16:44:52 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 16/18] vfio: enable IOMMU_TYPE1 for RISC-V
To: Andrew Jones <ajones@ventanamicro.com>, iommu@lists.linux.dev,
 kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: jgg@nvidia.com, zong.li@sifive.com, tjeznach@rivosinc.com,
 joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, anup@brainfault.org,
 atish.patra@linux.dev, tglx@linutronix.de, alex.williamson@redhat.com,
 paul.walmsley@sifive.com, palmer@dabbelt.com, alex@ghiti.fr
References: <20250920203851.2205115-20-ajones@ventanamicro.com>
 <20250920203851.2205115-36-ajones@ventanamicro.com>
Content-Language: en-US
From: "Nutty.Liu" <nutty.liu@hotmail.com>
In-Reply-To: <20250920203851.2205115-36-ajones@ventanamicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYCP286CA0217.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:3c5::18) To KUZPR04MB9265.apcprd04.prod.outlook.com
 (2603:1096:d10:5a::6)
X-Microsoft-Original-Message-ID:
 <5319ea7d-41e4-489b-b2af-4b4a5a21e83e@hotmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KUZPR04MB9265:EE_|TYZPR04MB5805:EE_
X-MS-Office365-Filtering-Correlation-Id: 175a39fa-2d14-4b92-9235-08de03eb778d
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|6090799003|461199028|8060799015|19110799012|5072599009|37102599003|23021999003|15080799012|3412199025|440099028|40105399003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bVdvRzBwWVFCdXRoVmlGWXhWQkVNdE1mWkJnNlJibFdxWmlGcVcyMGJoRFh4?=
 =?utf-8?B?OU9TZ0JEKzV3Zjd3VG5oRzNpcFZwSjdvTGF2eEhKYzczU2M3WjdOMnpRbG9k?=
 =?utf-8?B?YkVSSnF6dFNLRjJNL29sSnJPdGpZU2o0MHljT2R1Zk90VkxRSGw3eGRLdHE0?=
 =?utf-8?B?NUUxakNXdy9LdnNaMmJKSjRicEl6b0EzWndFcDUwampNaWxzVUwrbGE2WXRV?=
 =?utf-8?B?RTlVL3BxZE5iV1lqU3FJTnpqeTNDR09FVFM2NmhEZ1Q4K2s1N2hCT0hBVmxl?=
 =?utf-8?B?L3pmc2VJTFRVWHFleTFmV0E1U3MyUFFmeVp5aUtxdms1akZqbnRVdkNKU2lK?=
 =?utf-8?B?M3JLQ3R4RnBubGVvRk5LZ25paFNWeFJVclRTNlB5VGxxN1IyRlJaNlhlNjVY?=
 =?utf-8?B?NUZqb3ZscGhMOHI4NmNoOC9LYVg1VlZ0N3JDd0k3dlFSd3BEWlpuZWIxZFdP?=
 =?utf-8?B?VUVHUitMcnhDcmErQzV4R0ZlbWJPemViV1F2cVZTdHBwZDhsZlNXWTNnMGdW?=
 =?utf-8?B?ZVIzY2NCZnRjSlFKa3ZHNVNnd0dobDdvK1hxNkVFdGJucjlXU1JHOEM2azBu?=
 =?utf-8?B?bExQK1BoSEZMaE94bG15N2ZqcFJHQ2J2ZVdNT3pBMVlWRmQxQWRGOUhVKzF5?=
 =?utf-8?B?SDhxWDJhaXFWbW8zdmZiZFZJdGh1bkFrQ1diNzBJRkVIdE5DcHlRTzNkcmZw?=
 =?utf-8?B?YUZMQlQzQ0lKZlVQWHdQdEV0aCt4Y1o4clBOLzIweE1seFErZURERG9LRUZv?=
 =?utf-8?B?cllBcTZDcHFXMnFUSld2QUJkTzg4L2RSSisvbE5rZGVVTEtXR1BhdXJZMklw?=
 =?utf-8?B?L3g3Q0lWbXVjem1kbklOb3U1Q1FCSmxacnU5c1dTMVpXbUdZUE83TzhJVWkw?=
 =?utf-8?B?NHFSaXJwUE9tT0RuSkVPcjh1SElHQngrVFkyNUZFQ1RobFA4UHc5TENFODgr?=
 =?utf-8?B?ZGQ3T0ZrN1RvRnZ0cnBBZ0oyTjE2UlpLNU1EREdPSjhMdWxBaVFPQ1hIVHRp?=
 =?utf-8?B?aW5aRFVSOVNJN2xUbnFMK2V4T093YmhuQVV2WlF6cUY0NCtWU0pyb0xhYlhU?=
 =?utf-8?B?ZldpaTlYMytDcXY1WkRjdjZab2o0aElkUTRzNkE1MUszUE9sbWNZU0xvU3h1?=
 =?utf-8?B?YmkyNzlqNTNhUHpQUUxNVUJMUlRrdFRwMktEMG42WXkydkU1K2daalhNYkJ0?=
 =?utf-8?B?NjNUdkI4bnF3ZGVYbndZcXBkM3hIK29vYTN2VHlXcUxPRzE0S0l3NDNuWDFE?=
 =?utf-8?B?WmdaVUhSOThWcHFSTm90QXV6elFMOTM0cVNhSmlabC9YMVRWR2dSZFZUcCt5?=
 =?utf-8?B?ek9wdlYySk8vU2k2MXhkL0ZQK05pUURWQW9LZmVmb2dRYzJ3UkR2N0JkUTd1?=
 =?utf-8?B?OTZ3TENBYmE5Y1lNUldmWVNtNFVtRm96VHU0TnlMeEhBMnRpN3hIU0pxNTYv?=
 =?utf-8?B?OWxmd1JUaFJ5OWZuZ0I4QjF3UXQwY1FVM2lyS1F2WDJQNk41U2M0M1RTbHgv?=
 =?utf-8?B?OThtem9LZUs5L2hQbWpKSjBCNHFUNGtsUFdTMlpQWVJpWlRmZTllWjRtWDJq?=
 =?utf-8?B?UVkyeGRPOExkZTFBSUV2djd3b05udWloUUVhYm1yNkkyL01MVjFkS2d3YXcz?=
 =?utf-8?B?L1RNQ0owMzJxMno1RTZreUhaclpsRVE9PQ==?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eGthMHRDOWVjWG5VL0dsUys3a3Nod1R4RDEyY1kwblM0b3F5YWtWRDJ2ekZQ?=
 =?utf-8?B?Z3p6WDdGMjdPVGMrc1VyelA2NXRaYjA0MzdzTHpublNibFBIM0x5N2Q1Sjc3?=
 =?utf-8?B?K0V1R2pIU1dRdG5QZXFDOHBJMys4Nkl5d1UvUlNXbXNVMGJIQi95cHdXYkoy?=
 =?utf-8?B?ZGJLelZHYmpXTklEdEdVVXlrMUlaQkNXbEw0b1NUUHZoMjdtaU9FRUZJcG9Z?=
 =?utf-8?B?SUllUXBtVHlOVzBOd0NTWldxQ1NFMU5SMmJ1MGwvYVhYOXA5NTlHUEZ1bDFt?=
 =?utf-8?B?ZHI2ZVV3bTlhZ1lCbGR4ZTRHY1ZiNW5Nakh4dzhqcHJUTzdVbVVyamk1ekx5?=
 =?utf-8?B?S1BKZmZwUFRSWFdtRm1FaXNwc2lyMzV4dnBzMzI3SS9wMEY1UHg4T1R3bFpS?=
 =?utf-8?B?ZlMzdHhvRFhHM2ZTK2pRdjh6Tmt6MHpaVHVDQkljUXpmUjFhdjBrV3Y1SThE?=
 =?utf-8?B?SytGOThZRlVrK2MvZ0Y0cnB5bTloN3VzZ0M3WHZFSDdtaDlibEpkWkJFam9h?=
 =?utf-8?B?cnFxd3dlRE94Z29Ha0QyU3h0L25YalVLZHBkMVhXYkUzemNoYjZZbWxIQjQv?=
 =?utf-8?B?eEhLUmRNaFpMcjlsN0FVT1NQaEFLNjhzb2lzc2RCeWFBbmdDa21ZMG1iejhX?=
 =?utf-8?B?WEUwMnpJemhtaWJ3NzdxL2EyYTVCNk1IekFpTGtlcjhtUjBneXVMM25qTmla?=
 =?utf-8?B?ZEU2ZXF6d3lBWWFaYmFTMDM5WW8yNGdKWkRlR3poVm9vd0d2c09HaUY3a2xr?=
 =?utf-8?B?bnNlN0FMVldraSsyekRXK1J4NGhDNFVZR0kreHlhajIvMWRxdnNKdk9YVFpN?=
 =?utf-8?B?ZitaSkgzL2pTZXlXY2lJZlk0M1ZGVmRrdHFzanJ4SVZ2RmF0VUZHdWI2S0c4?=
 =?utf-8?B?V0Ivc3ZIMFlMcVZzdnZOWTZxNVVra3V3end2ZTZRdVVtLzBoY1BVTWI1WFlP?=
 =?utf-8?B?NEt0NzAvb1lZeXFwK3ZKZUJVRERuT1dZMGhYdURNUThka1lyZU04RzZnazl1?=
 =?utf-8?B?WGhzanIxSE1NNEhxTy8zeDUwS2dpelE4T1c5QnNZTkxERm5LMUdmNXd4aDdQ?=
 =?utf-8?B?QWovYlJTTmd2S3lsYmdkUzNSYlhUTUVacnNBclhXYk54blRyN01TZ0J5MEw5?=
 =?utf-8?B?QW9wOTUyUlExNXFNZHJUZmNwYUcyMDdwY0VMeG1uMWZxZ0VycDhqSzAyN240?=
 =?utf-8?B?Qld4QU5QVkhYd01PN29tdmpCSTFZcFBmd2FkTHJVK3VWdjlQYXpNanNtTUEz?=
 =?utf-8?B?LzFaaHZQWDdLQ2hUdWpBT2FYRkpFb29jc2ZJamtDZGJzSnlnTGJxbVFtbk45?=
 =?utf-8?B?K2lRbk1Ra3IycVdSOHZIamdGckhmMUY1clBSM0pSYlFxVHNQYytZWnpYQ2Rj?=
 =?utf-8?B?VldGQUI2NkljTWptVW56UWRQcU5YRXJOYlFNUW4ybzhrelc2Wmd2aHl2TGVY?=
 =?utf-8?B?VXpGaWZ5M0FyRTQ5TXR5R3lxUEdQd2c5TkJrQ3k1Z2EzN096SXl1MUtzS05y?=
 =?utf-8?B?bm9WS3lhYnIwcmJBa25oaUJxbC82M3B1Y09WNmdCVDdZcTl5MHdrdjBleWNU?=
 =?utf-8?B?S1pzVGxmOXc0YnRjNk5KRVhDdi9QV2Q0NmczcklKOXk5dFRVTDRCTGVvUkc1?=
 =?utf-8?Q?rZZDfrdlgW0hLWRZCpV+Bogsjee6yPXNRX1elWZh8J6E=3D?=
X-OriginatorOrg: sct-15-20-9052-0-msonline-outlook-38779.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 175a39fa-2d14-4b92-9235-08de03eb778d
X-MS-Exchange-CrossTenant-AuthSource: KUZPR04MB9265.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2025 08:44:59.3383
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR04MB5805

On 9/21/2025 4:39 AM, Andrew Jones wrote:
> From: Tomasz Jeznach <tjeznach@rivosinc.com>
>
> Enable VFIO support on RISC-V architecture.
>
> Signed-off-by: Tomasz Jeznach <tjeznach@rivosinc.com>
> Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
> ---
>   drivers/vfio/Kconfig | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
Reviewed-by: Nutty Liu <nutty.liu@hotmail.com>

Thanks,
Nutty
> diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
> index ceae52fd7586..ad62205b4e45 100644
> --- a/drivers/vfio/Kconfig
> +++ b/drivers/vfio/Kconfig
> @@ -39,7 +39,7 @@ config VFIO_GROUP
>   
>   config VFIO_CONTAINER
>   	bool "Support for the VFIO container /dev/vfio/vfio"
> -	select VFIO_IOMMU_TYPE1 if MMU && (X86 || S390 || ARM || ARM64)
> +	select VFIO_IOMMU_TYPE1 if MMU && (X86 || S390 || ARM || ARM64 || RISCV)
>   	depends on VFIO_GROUP
>   	default y
>   	help

