Return-Path: <kvm+bounces-59498-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A0813BB94CA
	for <lists+kvm@lfdr.de>; Sun, 05 Oct 2025 10:39:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 48DD118987B0
	for <lists+kvm@lfdr.de>; Sun,  5 Oct 2025 08:40:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7574B205AB6;
	Sun,  5 Oct 2025 08:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b="cfIb5jmS"
X-Original-To: kvm@vger.kernel.org
Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazolkn19013074.outbound.protection.outlook.com [52.103.74.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0EDA1DED5B;
	Sun,  5 Oct 2025 08:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.74.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759653577; cv=fail; b=EmiSwQXis9ga4gGdnlYs+cLPytxDWapcdkq9PUdVFpgURBCp99r853rDovq4iRX5UTQDTB0Hj2dyz/CnYe3bZIt+loJBUGAM/vzi/t1VQ8NWdh1PbHWxPUUzD4GKsHoNCaqyDtB9cn1xlWRV2mpAzqaf5+pYwGiDTq8mJeqjFCQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759653577; c=relaxed/simple;
	bh=U4QSthL58EK/bz0/QZEWtF38ZIpwXOAeY3ZadCPHITY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=h1ui6CX/g871w2lqCposoj0Judkg7kfaOWEHQ/W/2p+rb9KvYpoF3RD4IptD1LpR0vOExABqXJYV8mymz7oP/F5+xmhaX/+aDqpG0JB1kbTUQNaWtAWEhfHLgMKre2guaV9fGi8NMf9tQ57fzZVQMkbN8G2n1B2Km92OBXDDQmE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com; spf=pass smtp.mailfrom=hotmail.com; dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b=cfIb5jmS; arc=fail smtp.client-ip=52.103.74.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ojJ4pqbx2CSn0RUNj7Z9IPy6tkI6r/oKEBasCAsTOHfaQ0PebiswMOk6LcHGoFTIxpbovYU0gXqPkxHsaQ4V2PmwD51OxcNgbw4xAYeDcMij18OIPZ6GoK4nqdROWsU5pEJBqWd21+eUa3QsZVW9ztCmv+O5yhRK49OHlax9S51lxyMUFomRhdcbP3QqhAvhaZ+A9aDAx0cWNu9vp71KSPrY8i/tadvWMf3lyVN3TIDKpCiy4ztZc0HW9GsH1iaZeuTJYXoMg61VK3pEuawagSsph0R89F2780d70ryM4FSyAWrJJSLyhUMo+6AvuLf02TIrP9fSRxnSS5IGGxJWXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OmXUSyVnWHo5x5gm539+l+Gi+160E8SPApVoJyhHS44=;
 b=D4tYIHJuNkqUzyM8UhPyMtjocsOLiKyxJuk8jPo3YUMDhDkKfO4nDygCDZe20jeCqA8s1BFCp7N0TJkvW/ks/xAabG0z0QhT07hi0z2EY52QuW+9cEbMAYLnV3tlQ3UtHZfC55yaOgfsIg9mFAAqpMqOy8xjp0dHmlIrNNt79GAl90CyQt2ebblwXCrhmbXSKR9J8LxVlsFdLc1+c0KIpcEOPaz10TED/gBYsLr4yn0aUhQ1eNF9R1zXZzpRuxOJJnJGQWe7gBhhid278GjojYQMP9WJjFcBXjBEvqyKyDdYSjEv7ZhAQT9t14LUkq0eR+s8HEzQOS8facXTifGyQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OmXUSyVnWHo5x5gm539+l+Gi+160E8SPApVoJyhHS44=;
 b=cfIb5jmSgXPO0GRjwpMyfbwqFTSh5ChxqkKF5ksfEvnsjI0wl72yVAgQk0b1dcZ7JSRj6OrJH3kuIOlQ4+u936Zzjau6p7vQCVB6GtfzALUGZzdzzfWjco3BDiUzSHDS0QGv7HgwezehtfZ5yTi7+DkVeIVNpFtxPlDcSes4QvKCkDdVi9u8HKZxOSnATCPjOlxUlWfsbCSw6iJYoetWwQwRslfhMG456GTZ/j1KOwdJAH7CguNSS39mALoOtrnBuHUVPsfh4470VAfFhSqB9Yt8SncO+dlz1NjuReCD/MyJ5V/WX07fYdy8jXGfg0mJrtkpP08CKG4PqRLMvZng5w==
Received: from KUZPR04MB9265.apcprd04.prod.outlook.com (2603:1096:d10:5a::6)
 by TYPPR04MB8960.apcprd04.prod.outlook.com (2603:1096:405:314::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Sun, 5 Oct
 2025 08:39:28 +0000
Received: from KUZPR04MB9265.apcprd04.prod.outlook.com
 ([fe80::3c38:c065:daf4:cbfa]) by KUZPR04MB9265.apcprd04.prod.outlook.com
 ([fe80::3c38:c065:daf4:cbfa%5]) with mapi id 15.20.9182.017; Sun, 5 Oct 2025
 08:39:27 +0000
Message-ID:
 <KUZPR04MB926507882EE097EC5219A78BF3E2A@KUZPR04MB9265.apcprd04.prod.outlook.com>
Date: Sun, 5 Oct 2025 16:39:22 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 07/18] iommu/riscv: Export phys_to_ppn and
 ppn_to_phys
To: Andrew Jones <ajones@ventanamicro.com>, iommu@lists.linux.dev,
 kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: jgg@nvidia.com, zong.li@sifive.com, tjeznach@rivosinc.com,
 joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, anup@brainfault.org,
 atish.patra@linux.dev, tglx@linutronix.de, alex.williamson@redhat.com,
 paul.walmsley@sifive.com, palmer@dabbelt.com, alex@ghiti.fr
References: <20250920203851.2205115-20-ajones@ventanamicro.com>
 <20250920203851.2205115-27-ajones@ventanamicro.com>
Content-Language: en-US
From: "Nutty.Liu" <nutty.liu@hotmail.com>
In-Reply-To: <20250920203851.2205115-27-ajones@ventanamicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR03CA0105.apcprd03.prod.outlook.com
 (2603:1096:4:7c::33) To KUZPR04MB9265.apcprd04.prod.outlook.com
 (2603:1096:d10:5a::6)
X-Microsoft-Original-Message-ID:
 <c855af1a-d2e7-4e66-bf6f-7ead9938da44@hotmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KUZPR04MB9265:EE_|TYPPR04MB8960:EE_
X-MS-Office365-Filtering-Correlation-Id: e070c8fc-0d5d-40fc-3c62-08de03eab20a
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|5072599009|15080799012|461199028|6090799003|8060799015|23021999003|37102599003|19110799012|3412199025|40105399003|440099028;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ejlMcVVhOTBBaHExRGltdFM4YURVbEY1S2ptV0Rpa1F4VEJoSWV2aFE1Y2dX?=
 =?utf-8?B?ZDJScEhrZTZLSUlXWDVTbUhEVXgrZ3F0dEF4MFJNWlF0a1pTRU9GcDJNZGNo?=
 =?utf-8?B?L051a1A5VzdGV2sza0hpNlY0VHJJdlEzd2U2MjZ0YkZQaGtqTFpxaENkRmZR?=
 =?utf-8?B?VEdqbGx0anN4MlRqSFdhM2N3ak9tWFN5OTZIU1l5SVNCemJzcmtIdk1OQytM?=
 =?utf-8?B?TmFONjFPYVhXYjVhTlBGR2haRHVsdU1SM2NiMkYvekswbkFxSnYrZU1OQ3VQ?=
 =?utf-8?B?WnRUVnNQcGJ3N0RoYWE2VUh0b04rYVB3d1RKdmxnZ0M1RnZud0RONkNKOEN4?=
 =?utf-8?B?NVhaNFpidmx4THJ5UDRKOFhhVFA2dG8wRzNaMEdOcHd2eTNDbEpBSWRKa2xZ?=
 =?utf-8?B?Umt3VTJXOHFQQnY5MTZXLzRmWHFSV3RETUkzQlNTQkF5cXpPcHg5a243ZldC?=
 =?utf-8?B?d3QydFlxQlNUelVwaEM0VE5hRzlNWGZ4a2lTRld4TEFqdzQ2SDhxNENWNkxt?=
 =?utf-8?B?M3NCQk9OeWxNQW10QXJrR1lUNWZHWHVlNzJBbnNCNjJZMXBrMlEyTGFNUUNW?=
 =?utf-8?B?YUFyY2dEb05zcXArVTJHRGsxNXJPZHovTFRmTVJnazVudEhtRHJLNVVSc3VL?=
 =?utf-8?B?QWVmT012TEdQZUdlQTZObDduejdBODJXRFN1Y0o2NFQ1VjVMeXNKREhCUzNx?=
 =?utf-8?B?L1lFRjN5bkY3NU1FYllibWJmNW1ZVno3cjRrdDAwUW5JclVMR0FBS3FXN1dV?=
 =?utf-8?B?TDdqRUw5eWRmZW94OFJXQWVGTi9kWmkyMUpPZ2dzZ0Z3S2Jod1lwbFFCSnV4?=
 =?utf-8?B?enVQVlB1RmREL254L3k3c1crRHowTzlBcUxXd3dXTUtRcEFWWEFMSnByeFBa?=
 =?utf-8?B?NzFpZnJITVVPQnFQQ3Zla1F1bFhMeXlmaGk2TjZZYmJRTllMSXVLejBxNlpC?=
 =?utf-8?B?RWhLUG5CRlk3UkhndWpCZ0g4ZWpRWHBBY0Q3c3phbnZiWmdxb01kVjkyeDNm?=
 =?utf-8?B?VUdoeUM1cVRwdmRENlB1T3crRC96d1k4U2FZaW8yQzNYclc5NzNyalY2Mjda?=
 =?utf-8?B?UHZmUGJEbGk3dUVJd0R1T21uRkUvakVRUjZkclluTXVKZzRQOHZsbWl0c2FQ?=
 =?utf-8?B?VGdvMWgranhncUFFNVVSTUFqenI1bTV1Q0tQUVJEYXpWNXMySkN3RkNQMUFD?=
 =?utf-8?B?TGE2OFhJUURITFhnYVppQ1dKeVRRNGkxUDM0cFlITVFxV2FibDFwSTk4cWJV?=
 =?utf-8?B?bVNQK0d6ZkRrNnNaUE1BSDNCSDN6TUN4d2RzNEMzek82ckk1VytlZUtWUk9h?=
 =?utf-8?B?VEFxSmFocEREQUdUVUozQmI4ekpRV2pHU3VJcVQ0YS9mVHZ4aWJPUWhPWDJt?=
 =?utf-8?B?T1dVc1VUaDJxcWlmMTRjVHJZait4bTZGY0NBS2FnZEtpamtQaWlZcVUrZ0ZP?=
 =?utf-8?B?MHp6VjZZcndOREh4YlFJbEs4YmpvWnc1djVaRmNxWXh4SVBKaW9UMGNFMnNF?=
 =?utf-8?B?QTlJTmZ3dmhaWG11RUN1NGJKeXhTb1dYb0lDTkZJd09nUXlqNlNwamdLdU1K?=
 =?utf-8?B?V0FsZHQ1bU1YYXBIWHhVQVFkSjhIK2hjL09kZndPbjh6WVZWODNVeVJ5QTNH?=
 =?utf-8?B?Ni9yRjVwUklmL0F4UDNHWHJubkRqOWc9PQ==?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZW9LZ3FCckRWbDRYUi9RN0RaaS9WVjFkbGVxaDRDM2JJR0JjdExramduRVpG?=
 =?utf-8?B?UnJuWUhzVEw2enpaUFoybi9NeDdGbGIwM21mVk45RVhHQzZMR3FnUS9QREdr?=
 =?utf-8?B?MWtDYjVwaWs3Q3A4Q2Vzbjhub3F2aEVDc2JUSzd5TjhSYlB5KzB5YkIrMVUr?=
 =?utf-8?B?WVVvYzRyUzUzS2xxT0oyczBBVmVDRGVkMUZyWVdybUJBeXZXOXd0THB2VlRx?=
 =?utf-8?B?dTU2VkxsWHBJSXNDUEdiSVEyTmNEWkZqRm1LQUVzNENJTDBnTCtqR21jNDlK?=
 =?utf-8?B?UWV3QTRKMTBYS3d3Z1psbkpCdW9FUG1JYm5BMDBhZEdjVDRjbEpVWUpNRnBm?=
 =?utf-8?B?RXBoUWhVWjdmODVMdEVpOUo1eGVqbUk4SWIzY3FnTUJBc3NmVVhFSkRxR2hM?=
 =?utf-8?B?UjJJZDlZWm1aZDk1NTNUbHVKa1ovQ1hoK0dqYXhaajlnalRNNlZWd283WWpu?=
 =?utf-8?B?K0FxWUM1dld5THYzTkhYQTFMYUxYRWsxalhmcGlLVFhMV1VuSk0wclFpRmxa?=
 =?utf-8?B?cVJqREVlZHlaaS9oVGlaUTNUS0MveG9KR05JbDRKQXpJajVNUHppQ2RsT0dx?=
 =?utf-8?B?NlNrYzgraVVoU1RpdEluWWppVWlwejF4YWpxeEZwd2Y1dk43OHBSeXRkTlNQ?=
 =?utf-8?B?VlRNMnNzdjJuNTU5aVEvK2pwUFRkRTM1eU8rRndHdUpjY1U0UWhHdmNrNHdh?=
 =?utf-8?B?aG04RUZERkJGRXVrQ1Z0VVFsT2Z5dm8ram94bW9KWTV5MitNRDdldE1MSkZs?=
 =?utf-8?B?TElzNGt1L0RpVTFHNTZMYTI1dEFtcWhGT0NuVU5PVmlBSGU1VXVsaytDb29K?=
 =?utf-8?B?cGUrbnZBSG56SHhBTkk4Q3NTcnY4NzlZMVNTdEZhWnJzM1hCcERqdEhxZ1Rh?=
 =?utf-8?B?Wm9zalRFd1Vvaml5TDIvMmdmOTl0cWhXNnh0WktiYXQxc3JXRmEzKzJOU2dZ?=
 =?utf-8?B?UzZudnVBekVoMzJvNTVpYVJWOUxueTYzRGYxU1VaZGczSkQzbDFrZXR6MXhX?=
 =?utf-8?B?VTlMb0t3dkgyNm5sTHZmNktweEJYeXV2RFEzMGxKbjhlQmsrd1NiQ045aW83?=
 =?utf-8?B?cWZFZzRIUTllamZ6bXdUTGIzVDRtR2NGQm45dDFUY3lDN1dRSXFma3dRQ2F6?=
 =?utf-8?B?MHhYYVhPTWJSZTREeXo1S1FGei9MWmdjZHNjMFJuWDBzOEk5NFd5Mzk2b3h0?=
 =?utf-8?B?djdaQlRRY0Z0cmlWTWhMSktrR0FDWFhjdkhWcjhpb3VDdENhUnFlMk1SNGFK?=
 =?utf-8?B?K0gwMm1Ca0F2bng0Uk81dHhuSFRLTjNGZHRsZ1VDbjM1VFg2NlBDSEZWc3VU?=
 =?utf-8?B?SGRPMU5SQWoycG5jS1dwUTFDVlYvRU9OVVozazNXejNlbm5mVmU2Z2hjSFNL?=
 =?utf-8?B?bURWVklNSFZyVTJ0TDc5ZUhZM2d6MVhBZHMxSFBWOTgyVEJFbnN0Rkg4QW8z?=
 =?utf-8?B?Nzl6eURTSGk1NHo1V1pPYXFZWkxYUmJseFFIZDB5SHlrTlJEQ2tNMWs1a1o1?=
 =?utf-8?B?VU9WRHZtcTQyMXdPUU9aTDZWN2VwNE1BTngzZTBYVHVIT2RzVEU3RmhOWFBa?=
 =?utf-8?B?RnRoZXoxT2l3OVJnaHJ5U1RVWTJwZ3k3NU00VldNa2t5SDl6YkZDNVNDUkFq?=
 =?utf-8?Q?eI4BQVwFf7EHHesCoY5keXT01jxqH8pJfbbIcmK4zuBc=3D?=
X-OriginatorOrg: sct-15-20-9052-0-msonline-outlook-38779.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: e070c8fc-0d5d-40fc-3c62-08de03eab20a
X-MS-Exchange-CrossTenant-AuthSource: KUZPR04MB9265.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2025 08:39:27.8900
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYPPR04MB8960

On 9/21/2025 4:38 AM, Andrew Jones wrote:
> The riscv iommu uses a specific set of bits for PPNs (53:10). Export
> the translation functions so iommu-ir can use them as well.
>
> Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
> ---
>   drivers/iommu/riscv/iommu-bits.h |  4 ++++
>   drivers/iommu/riscv/iommu.c      | 14 +++++---------
>   2 files changed, 9 insertions(+), 9 deletions(-)
>
Reviewed-by: Nutty Liu <nutty.liu@hotmail.com>

Thanks,
Nutty

