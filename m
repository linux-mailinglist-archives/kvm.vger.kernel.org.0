Return-Path: <kvm+bounces-59496-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EF96BB9491
	for <lists+kvm@lfdr.de>; Sun, 05 Oct 2025 10:29:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BBAC73BBC38
	for <lists+kvm@lfdr.de>; Sun,  5 Oct 2025 08:29:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40DB51F03FB;
	Sun,  5 Oct 2025 08:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b="JR0/A5o1"
X-Original-To: kvm@vger.kernel.org
Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazolkn19013072.outbound.protection.outlook.com [52.103.43.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C8141E47B3;
	Sun,  5 Oct 2025 08:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.43.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759652946; cv=fail; b=Md7/ry8akwloVRGOzXWfZoXvi6t7p+NuAfVtWrT8Uh8ZC3m+/n2d+Eo7baMHr+Gjqbfet0FvMiDQhPIM7O4g1ZfOuxQ7X/cJENKq7rUMzh8Nf/HFU593UfQhqE9LvOuHyl7bUtu1CVdwqpEIL3NxdRd0RZk9vpqWgsHMR1qhLE0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759652946; c=relaxed/simple;
	bh=ckcWjQfxrqMjP6HTtAFs5Ih4bT6BmqfaG3uz7YLutZw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=czzUS0Gy5EdcPMP1QK5oFwM4LEPCifDxHpWrDQ0jqrSkIZSjO5xq3Q48sHfNdYiUoUQHVqV3WNRqG87hlk1Jfeur1Jomq0ZvHo0vVFeRh11BXkZv0WxK7q5n9tU329bLcIAE46GIxBM6Ps6fIE84AuNYcrMQ3367t7wz5kzi7ss=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com; spf=pass smtp.mailfrom=hotmail.com; dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b=JR0/A5o1; arc=fail smtp.client-ip=52.103.43.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EudmFWCZx7WhLeWuXj85msnAJWyX1WPdMxX3xWl/yn4ipgjsKbIqpz2x6hVIgwW6LE300Bw7q9JTGcW3kD6j4pguLpyOqkj0/4ONpVeV73i1Rc5JuamQd2ZyaaJLhOhc9Wtj+twWDkhcsEi4jZ8cUJM8u7OH8fXNvSpUOpOMMUUQV0T5nVKSIfgT3q9OLGSsvtD0Hy2kQYIbbB8DEqWo+Fxf4ZkEukjtiGpBXHbQOUmG49Dr66dQvXTuFy+B/y2lgQbmqCnBOLAWb8Pnznz/yG48kdsGYiHR3vrJQvOzq/n9lAMzp3YKNA0E0QaMr6ehlvwNF4EF+Au63jaVrV6BcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f3Q6qRPOTogd/8ivxkckdQB3tZANWiJhV3vzfn9GLjk=;
 b=L5yee1t9/Akx08SDWzKz3CkG9rsq71q80q+s7d2O68Krx8McSMChyriF+caYItJO3LYREK8P/7Kx94IV5BjPc98fF3Yf014P6h0IGmL0WCRa7e8W4Qzs8uXNERj/C+wQbKWKqPKW+ON/hDCYbImDohgenIXdlgfvwwMvaVeYhi7VLxqvXFNkZQDcwGYXFsXnF3FWaaVhWk3k6pxujJqgY/QDMNgWh3WNsoEdGm5vVzB7J9wan2YQTTj18hYro59sVrzzHv1jqCwxgppT3UlvQqOdXrsQFUfuPRfYGK8lzcRHDKqeUj4hULlmxqdAxb5diHljzlM+j9BDL4XHXRJ2rA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f3Q6qRPOTogd/8ivxkckdQB3tZANWiJhV3vzfn9GLjk=;
 b=JR0/A5o1howE9HUpy8Hp3K6aK/HRthbGSi3pdE1UxRNcG9MY81vqT3waMofWZMx93vhggu34X+PywMiKGHdjQ4sn4zgTrYTg5oHJj5ai6w1+uoI5fCuqWa2FGf25NsQDI3m+0DiCklKpoBNlRQGZLzVg3LrbD4YslHtWXScDpPBc9K6JgE9RjCJ9bD4cW6SwS8cOD9lnv+cbFzjljJhGkeQF7K/JpbHMq/ESVk1oTfl6kd57szqw9zjkwsq86viTinewoaL/kQusAMtFk+7QcsjreePuLjGaugpodKSGzryqXOe/Ag5gyCT3cwzwfCae6U/xlmp4a5fuA2ozDf18IQ==
Received: from KUZPR04MB9265.apcprd04.prod.outlook.com (2603:1096:d10:5a::6)
 by TYPPR04MB8960.apcprd04.prod.outlook.com (2603:1096:405:314::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Sun, 5 Oct
 2025 08:28:59 +0000
Received: from KUZPR04MB9265.apcprd04.prod.outlook.com
 ([fe80::3c38:c065:daf4:cbfa]) by KUZPR04MB9265.apcprd04.prod.outlook.com
 ([fe80::3c38:c065:daf4:cbfa%5]) with mapi id 15.20.9182.017; Sun, 5 Oct 2025
 08:28:59 +0000
Message-ID:
 <KUZPR04MB926510C2B83347B393638AA2F3E2A@KUZPR04MB9265.apcprd04.prod.outlook.com>
Date: Sun, 5 Oct 2025 16:28:51 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 06/18] iommu/riscv: Implement MSI table management
 functions
To: Andrew Jones <ajones@ventanamicro.com>, iommu@lists.linux.dev,
 kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: jgg@nvidia.com, zong.li@sifive.com, tjeznach@rivosinc.com,
 joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, anup@brainfault.org,
 atish.patra@linux.dev, tglx@linutronix.de, alex.williamson@redhat.com,
 paul.walmsley@sifive.com, palmer@dabbelt.com, alex@ghiti.fr
References: <20250920203851.2205115-20-ajones@ventanamicro.com>
 <20250920203851.2205115-26-ajones@ventanamicro.com>
Content-Language: en-US
From: "Nutty.Liu" <nutty.liu@hotmail.com>
In-Reply-To: <20250920203851.2205115-26-ajones@ventanamicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYCP286CA0078.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:2b3::15) To KUZPR04MB9265.apcprd04.prod.outlook.com
 (2603:1096:d10:5a::6)
X-Microsoft-Original-Message-ID:
 <50e239d8-d8b8-4c75-b492-13c2f1dc95ec@hotmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KUZPR04MB9265:EE_|TYPPR04MB8960:EE_
X-MS-Office365-Filtering-Correlation-Id: 8272999a-e58f-40d0-e060-08de03e93aa9
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|5072599009|15080799012|461199028|6090799003|8060799015|23021999003|37102599003|19110799012|3412199025|40105399003|440099028;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZmF1VlR2WXkrTnBQV21XRGhWcmh4WG43SnM2a1U4SzAvUUZFT2NjTWdQZUR6?=
 =?utf-8?B?azN5TVVsRmJnWjUzVkt1U0JCOU5sQXhZSGJSUzRXWXlzdzVBeEpKSUdHNjQx?=
 =?utf-8?B?Z0p1YjZPbzBFZG5PNThCa1BUQVZlNDQxYjlMbjMyM1djUnRVeUhPQks1WGFq?=
 =?utf-8?B?aVdmM3dFTUl6WS9qN0hhd0cxblJQZ05GVFJpTXVDUjRJeWkyN2dzUThHL21U?=
 =?utf-8?B?TVJiSFNjTEIxS09CaC9zaTJxbzVHUE9pcGdxTHdhWHJ3ZUZpelA0Tlo5eGtM?=
 =?utf-8?B?NjVyWUk3NkQrZFJDcEZudm1WaG4wclFDbGFWTGhsUUllV3ZhRUVyR3dWSVUz?=
 =?utf-8?B?Y3hIVnBnWlhrbitVNmU4aEJ3TThJRHRZdFBlMW9yL29UdVg0aWdPb3VUdTZB?=
 =?utf-8?B?VWhrNW9Pc3JJSzlUeFFnc29TaEtiVVpsZGlzN2dLT3lidmVnTXJ6azJFWnds?=
 =?utf-8?B?WFpOTFR1RWNVbWo5NTdYa1ptMDZXd01sTzd3ODk4ckJSQUIxdGoxaWR2Wkxi?=
 =?utf-8?B?SWhoR2FTc3lrMlltVjFlQURtK2dwMENCdzQxR29qdjFxayt3bEwvK2I4MXNW?=
 =?utf-8?B?ZFkzaWtXeHFVQk53QmlqYXlGaWdzUFFPc0xlK3JzcVJxN1lIbEtKM3AvdWtV?=
 =?utf-8?B?UU9oRHVEZHpud0t0RnJMY0RHSGZJNGZKUjExTUxaUTNWUkVkcXB2TjdnOGtH?=
 =?utf-8?B?TFRZbXFXb3dwN2k1Nm1BaXREcUh3WjdaeVpFMENPZXgvVGFDZEJRVTF1NFFR?=
 =?utf-8?B?V29DQlNaNWZNdy9Va1l4cmVJY1JKV211REdjckxKalcycHVYRUUzeDAvUkRY?=
 =?utf-8?B?MXE3WjBreFRvV1dDZFBodS9IaFh6N2wyN1pDOEZpN0MrQ1FzeCtSQVlMTjRt?=
 =?utf-8?B?WHdVNjcvcVpEdWdhaHM4NHVHT0QwWENEYmp0UkMzeDhJQjdrV25iemhPc05n?=
 =?utf-8?B?MjdoNXY1UlY2dkxkMUpkMndRYXVuRmFyOW9Lb2FCRXJjUi9PWlJZZTdyMUk1?=
 =?utf-8?B?cURQN3MwVDM1RVdBdkgxWGpiZ1ZNbzkvZ0tTWDU3T2MxbGFNODdLamdSWWZJ?=
 =?utf-8?B?dnE5c2JiVlI3WFdNek10bjV5bU55aGdtME9KUkVPb1RaK1k2Smlmc1VvVVV1?=
 =?utf-8?B?MEZxb3dYaHRBbFVEQU1zZERFTUw1NVh6cUp2UVRsRm1UMVExNXpQeDU5U0k3?=
 =?utf-8?B?eFk4Z2NTdVVhdkt5UElyN0xhamlzajFuZUZXWEdJdVVDQjl6RmFmSkdmN2R4?=
 =?utf-8?B?c05GdWdHa0lHU1N2WUZGemlGQTlDNHE1WU9CUkhsYzcwa1BZWEMzb1FMa3hW?=
 =?utf-8?B?MDUrdi9mQ3lMQmhLQUhEY1dRc1R0MWNtMnJxdlNRSUpMTmZzbnp6b0FDUWpL?=
 =?utf-8?B?U1RMOWJZbjdMdzlPcXJNeUxXRm1ub3RVYXZmaG9ORitUaGVpaDZhS0hKZ3A2?=
 =?utf-8?B?OFBhUnRTSzZsRUxST0NxU0ZqUTVKZnV0a2FuVnl6VmtNdGJMQTZSakFwK0F5?=
 =?utf-8?B?dmZqbHAydWF5ZHBDL3gvNDBKWDIyZFJ1R2pBV045VW9FdVhQVVREbUVQR25k?=
 =?utf-8?B?cXMzTGVyRUMraTJvRmRyaldZK3E4R0xPQnhPZ0U3QWthNXNNdmdiNVJlcTRS?=
 =?utf-8?B?TExvUERiNGViSStRQTVPZzZ6bTRtQ0E9PQ==?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bmVHL0NWc1JtN3QxR0NLVTFlSnJtMVJrVWVaSnFTeFcxZklYN3RjL2sxMUxF?=
 =?utf-8?B?d3lVNEhPUE5Qd0ViSnhPTFppZ01zT0NWSUhWTTFoMURmSzlEdUJkYkVGV1Rt?=
 =?utf-8?B?WVlydU5aQkZ4YktYOWU2azhMc0I0Q0Y4eEM4bXlwWCtoc1c2Z2c2YzM5L3g2?=
 =?utf-8?B?RVRkRHZJT3hyRlcrTVd1MXluZE9Uc2RuSC83VE1YZWQwRGJOQUl2dENhd21U?=
 =?utf-8?B?K2hSUjA5N1pQLzJGUmgxUTR4bXVkcUVWNmFhMXhBWVRLdlNwa003UjN2OGkv?=
 =?utf-8?B?clB3MndUTHFXeXhhcGhXWG9LSEVwL0ttSlpNdlpNRzdlM1oydHV0RmJIaFFP?=
 =?utf-8?B?SzI3aVY2R01xQzF3eHdzZVM5MVdFZnRkL0Z5aDM2MlV6UjQxZzk1VmZxUTdq?=
 =?utf-8?B?dmpwSFMvTVdjQlc5TnNiL3haZmc4Y0UvdXd4WnhrS3dFYm9GMlJnR0gxSjZX?=
 =?utf-8?B?VnFmcUl5eTNnUisySG4yTjBDOWgvaFdQc2YrT2hYakQ0V1NZbUErSk1teCtl?=
 =?utf-8?B?NFhRV0R0aVpaUHEybFR4M2NydWJUbU9KUmdLZXFZVWk0M1ZMVEhIc01CUGht?=
 =?utf-8?B?S0x6N2s1eFJVL2ErMHZNZ2JMVDN4N0JiWEtLQnkxUm5uTk41cjNPK0YyWWky?=
 =?utf-8?B?TGU1bDFyaW92QzFQekdiTHNyQjM2d2RCcndvZEM5ZXI1Z2JFQm5YSDA3YmxU?=
 =?utf-8?B?WlhPRFZZdXFPN04xNlpBblo4NGYydkQwMHlNL0NXZDN0RWJ4SERlUVp0d2tN?=
 =?utf-8?B?TjVlZTBEWEE5bzcwTVQ5bGh4SXF0RnN1NFVIZy9nZEhUTDlwY0pOM3VURS9C?=
 =?utf-8?B?S3JNNE80WWg1WkhuSmZ0ek9GamF5bTlhaUU5NnFOZnN5UjVOb1pBSFBubWdn?=
 =?utf-8?B?YVpyQ3RwZ0U4Wlo5TFdpZ1BCQ2NRSGY2QTRqZmVZMXRZYUhIN3RrUVZwK1Br?=
 =?utf-8?B?OXdPaVNVZll3U3JpRWtSQ1RoeXRuaHN4RURLMnN4em1Pby9sdXNaeG9EdDZa?=
 =?utf-8?B?d1ErOUpkbm9tN0RLZmh1dHN1Um5MQU56a08rL0NvQ2JHMnM3R3hUL1Y0cXN3?=
 =?utf-8?B?Wnd5cC8yWmlIamNpK1V2ODJxY0czVjJrSUZELzBvVWo0bExEU1ovYldER210?=
 =?utf-8?B?bFBoNEdWcUNMcE40RWptK2wwanMvUFkzOXQxM1JyVVBLYjdqS2M2VXBCNHpz?=
 =?utf-8?B?aU83d0h2eU1mWmZkYk52dHdWY3BYcEpKbXpxUCtkeDRwcTJUWjBOVjJrUTIz?=
 =?utf-8?B?NUQ1SHBNMFA3VXI2YlhoVnFOSGs5a3RlQ0ZCTXFrVllmYjB0bjZ2NkZPQ2Fz?=
 =?utf-8?B?T3ZHS3RqM3J3RG5QY29JOGtzU1JENmtkbGk1cTRwU2FvQlRIZlFBMDNZOHFZ?=
 =?utf-8?B?VmxSZHI3UUNDUEZuUStIWjNnMEJQV1lScXYxOTRMMVQwVDIwNVZGRmZQcjN2?=
 =?utf-8?B?bUM4WFJ5NTlNN3cyeE1vNW1hQk04WmNWdkNUaExvc2FFSHBsRGZoKzdxSzd5?=
 =?utf-8?B?T0lSVjVwT05PVlpRUVprcEFnUjQzSVkvckhwN3QrM0dYMEFCTnlSNG1hS3JW?=
 =?utf-8?B?YjEwWTIwZSt4VWRpOHVGRUxxYzVYcDBsR0lPLzBLNHVaTEhCVkdUZC85bFYv?=
 =?utf-8?Q?XDZYwoQ1UQ+q3byVxzUUU6WrLF8wkJy3u30u4yWC7z3U=3D?=
X-OriginatorOrg: sct-15-20-9052-0-msonline-outlook-38779.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 8272999a-e58f-40d0-e060-08de03e93aa9
X-MS-Exchange-CrossTenant-AuthSource: KUZPR04MB9265.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2025 08:28:58.2241
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYPPR04MB8960


On 9/21/2025 4:38 AM, Andrew Jones wrote:
> Export more in iommu.h from iommu.c and implement functions needed
> to manage the MSI table.
>
> Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
> ---
>   drivers/iommu/riscv/iommu-bits.h |  7 ++++++
>   drivers/iommu/riscv/iommu-ir.c   | 43 ++++++++++++++++++++++++++++++++
>   drivers/iommu/riscv/iommu.c      | 36 +++-----------------------
>   drivers/iommu/riscv/iommu.h      | 32 ++++++++++++++++++++++++
>   4 files changed, 86 insertions(+), 32 deletions(-)
>
Reviewed-by: Nutty Liu <nutty.liu@hotmail.com>

Thanks,
Nutty

