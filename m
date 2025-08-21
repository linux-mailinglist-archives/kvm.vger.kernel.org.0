Return-Path: <kvm+bounces-55262-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EA0AB2F1E6
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 10:33:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 135CD1880526
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 08:27:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F3C72F49F4;
	Thu, 21 Aug 2025 08:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b="scNXAoj/"
X-Original-To: kvm@vger.kernel.org
Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazolkn19012051.outbound.protection.outlook.com [52.103.43.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A0812F0C57;
	Thu, 21 Aug 2025 08:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.43.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755764549; cv=fail; b=BJ6Gre6MBHXT6cQaytL0fJPiAYyA+oR1PAxLvtCRjQbcU/kr2DMqaSkF3CfYrlibXk+dJkQa9xS36ICLYJOXLXtL5nJ3AkuB3sh2yRgw/O20Xa+qVgZhlen5QySR2+2QYnLs/N9EhcqtjVeJXWwbyYy9WpgeVcxq7IpLksWkIo0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755764549; c=relaxed/simple;
	bh=d3SC4OoEA/3r17kNgFoRmh1sHaba7+q5ATjWzlSaELI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cE7NW9cUPC5DPWiHbl6YTC3IPsIqoHWZ1MST+EUQplY0/Qze8SmIK0PK0YUBWOhQ45mGhphBZfstOCEgT3TY+yvOkFKUkObKkjHxDpG1ZzdeB1B0wcq25bY//M21kpVWaSme+o0NcOTIMFcBhCeX2XgnzBm/XQOHMCSHJfpBq2g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com; spf=pass smtp.mailfrom=hotmail.com; dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b=scNXAoj/; arc=fail smtp.client-ip=52.103.43.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q+q6KUl6mrX0LhDf3tvbQsVoB2pphi5o/3OdCC/MXEfQP0ymo8UHWIYRisTKnA1GrSyklOaA1eF982dgobIoeJdfSjb384CPu9mVluoM6Pqeu3NZg5w1CyNz14igVJDY+OSsr3oXUvKRgHtKyflyjO6Q3azgJb7Df2Kbe0GfM4E/rYCeux0oIjU4Zrj2XKoWgcFlmp4koFdH0G4cmJjT8uRURQ58jrRpS52fHNJTGtKxmX/eiOS2vwfEeZ+CoAW6cJB125CrkXPYvSBG7uKdIBe64YoMUDdb2k2kFedi/TN1i+j8Z69s9xM9dmR9OL4grSM4qSjeb9YPyAr5P7jmSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HPuInCWj+CcNPNqRZpyC7f1juoKyYvbbDvvDEYvyirM=;
 b=iaolWl4bW/I+hLQL23QBjsZpjzmwFIsBRek72cu9fXck9q8qdby83lznaPfrSikNwLAT9BfuzvsbyJWbEuuTyIySU7TWuv5gsGM33AhoCgUJK6C1yQTVmJL9VDmlyORJap8Fs90g71w33vI35ikjixuk7SCYuCukV9Dv/ojCBLIRSq8r5tDvbg2qc913LeXIgBV2GZE+Xdw2VblNjLgN/m7w/ChOameWAVhfA+CXZpz2vsoYR3RA/qQmJeclNtmHtFgHpdT5SuJYjwcw24DIb6lyfET9WTR9i+leJ1t91WvOOReWCvKOujbezDMCiBo/xfJzPZ7EdyHwIVBEBNLPtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HPuInCWj+CcNPNqRZpyC7f1juoKyYvbbDvvDEYvyirM=;
 b=scNXAoj/KQL2+gy6CmrzE8MC+BtB/uyoF154WLNZTxVQVeYq5SE6RlAOXYiRHhvdkSGBnrmo54idsGe1Zc8VzA2lfgcrwJDivGVblkNiYbLcCcEwZS7GaiWbdyZi4ZfeO4gAFg5tuPWkAAiLJUQrAwoyL6L0hif5X0zFyeIHdb3GvSSVafPCnKYholzYb0dTwT/4BA4Whkhuf8j8wSWtuwv1xEJ8xm7VfMDbGgROkgsZrf/o3oDriy8VIn2Y5eofA0rLk06myjWopj09200UpXL621A/lWj3lH3yEuSwXrAN8x61CIblPRHy5BkK7Y6fNjTjBJRzE2VIy5SNrAyi+w==
Received: from TY1PPFCDFFFA68A.apcprd02.prod.outlook.com (2603:1096:408::966)
 by SEZPR02MB6584.apcprd02.prod.outlook.com (2603:1096:101:131::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Thu, 21 Aug
 2025 08:22:22 +0000
Received: from TY1PPFCDFFFA68A.apcprd02.prod.outlook.com
 ([fe80::209a:b4cd:540:c5da]) by TY1PPFCDFFFA68A.apcprd02.prod.outlook.com
 ([fe80::209a:b4cd:540:c5da%6]) with mapi id 15.20.9031.018; Thu, 21 Aug 2025
 08:22:22 +0000
Message-ID:
 <TY1PPFCDFFFA68A2A32AC6CAE356148712CF332A@TY1PPFCDFFFA68A.apcprd02.prod.outlook.com>
Date: Thu, 21 Aug 2025 16:22:17 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] riscv: skip csr restore if vcpu preempted reload
To: Jinyu Tang <tjytimi@163.com>, Anup Patel <anup@brainfault.org>,
 Atish Patra <atish.patra@linux.dev>,
 Conor Dooley <conor.dooley@microchip.com>,
 Yong-Xuan Wang <yongxuan.wang@sifive.com>,
 Paul Walmsley <paul.walmsley@sifive.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20250807114220.559098-1-tjytimi@163.com>
Content-Language: en-US
From: "Nutty.Liu" <nutty.liu@hotmail.com>
In-Reply-To: <20250807114220.559098-1-tjytimi@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR06CA0235.apcprd06.prod.outlook.com
 (2603:1096:4:ac::19) To TY1PPFCDFFFA68A.apcprd02.prod.outlook.com
 (2603:1096:408::966)
X-Microsoft-Original-Message-ID:
 <583957c9-e2b4-4eb5-96d4-005b31770a4c@hotmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TY1PPFCDFFFA68A:EE_|SEZPR02MB6584:EE_
X-MS-Office365-Filtering-Correlation-Id: 819d2d29-c3d1-40e7-be59-08dde08bd9fe
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|6090799003|461199028|5072599009|19110799012|8060799015|36102599003|15080799012|23021999003|440099028|40105399003|3412199025|51005399003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U002MXBpZ3lQK1Vhdk5ySDlEYTJVTU83MEtHcVNKL2dGbnlZMVZ2S2J6cTBG?=
 =?utf-8?B?MzhsaXpxZ0lCM2lmZ1Y5MHdZWHQ3Szh5SHBSUWlVT0FZZm83R0s2YitRNTZ3?=
 =?utf-8?B?bG85SHlLR29mQ05MUVFlcEVQdE5NREJSZkRKSFpWM1lYSEx3eXp1MkxuVEV1?=
 =?utf-8?B?T2JNNWZGL1lsdmExdEN3eGRqUVJUalZkbVJBU040dkpuaWpIaWhqS2xrOHJa?=
 =?utf-8?B?MlJEVzd2alNpbFFrSmUrbHYvdGU4d2hYUzNtcSt5N1ArL2FYNGxFMnN0OFYv?=
 =?utf-8?B?RWNjaTYxeWNXNWYrOC9RMVRyeEJVOUZzUm9XRkdxVkh2Q25nUHRXaktDcksy?=
 =?utf-8?B?U3NwRWpxbUNDK256Vk9KWlhIZVNYdU0yZTdSQit2ZTNTZ1cwQ1JsVGtZbXY5?=
 =?utf-8?B?eHF2V1p2bnFBNE01MEJrdlNTMFU2QWRIK2duM2RQOTZHZU9NMCtWOFVtYm5v?=
 =?utf-8?B?dTM1ZDFzRG5ZQjNYanJZYzloOUIwRkhaMGhNdUxuRUJLeUJVc0wwTVlrcVBr?=
 =?utf-8?B?WU9ZK1owSHRXRHYvS2t5UHpFSDNkMUlXVElnUWhEZ2JqYjlLYk5OazZCdTZ4?=
 =?utf-8?B?WUNpRldQeWhJWkpRRmt3L3R1SXByQnI4OGZpMmtlbGZ6cnNoREFGYnJpK204?=
 =?utf-8?B?ZVBucEp0ejNOaTVSSWVNeE03b0tJek1MRlFEMHkzL2pYcnA1b1ZLdXJ3V1d5?=
 =?utf-8?B?SlBvay9nTVA4eDRyemtpeC9yQWJvVUVXRFBTNkk5UkJ2UytweTdhZGZWa2NK?=
 =?utf-8?B?VzNDZ0xxbm1PSzZqUkdobTdDMGtSY21zakQxV0ZzRUNVWWJyb1kzTzZQZDE2?=
 =?utf-8?B?eGVzN3RXK2tITDA5ZktSTURka09OUFpNczJEWXRuT252a3VqVEtMVkEyVVhX?=
 =?utf-8?B?QlhhdFJOdmlUd3ZrT2RzZm8xam44UUZjVWxpb295ZWpnTS9yMk9MaFhyWStw?=
 =?utf-8?B?aWMvdGE0SGVYYUZWOHZuczloTm5meUIzMWNscTg1cWtSRDJRRUwrS2NWUy92?=
 =?utf-8?B?QysvMWE2NFd4RUFtS0twVm5vMjIxaDhKanpvblJ0OEtPcVRPcjFSNnZPQkJF?=
 =?utf-8?B?Z0d0S0F1UmV1S05BMzdrd04xNjlyb2YyN0VvbnczcHVXWnlBMHdEOWlENEdR?=
 =?utf-8?B?dW5jZWlpV1N2dllMTzNGUllFbHJZOURWbHo2SjU5WE1nTm5nNlFuWncxTnZU?=
 =?utf-8?B?RGdwL2lrRVdxcWNhV0MrVEJaZWl0NElpbzZTUk5qdE54OENrU0JRNFZUbnpV?=
 =?utf-8?B?ZGJoWVJobzU3Slo0RENHeGZCc3dqN1FqUWwzaUZuNGhlNTRVSndNWFV2Qktq?=
 =?utf-8?B?S0RMQ1dxdFZNTlpiUHVDWVFZeU8xTm9tbEVkYzBkY2ltNEdKbmVCUTVody9P?=
 =?utf-8?B?dHRETUhkWnhBeGpqUytiSGxEalFBV0dXa25ZeVdkeWxtNWRHRjB4WHJoSnli?=
 =?utf-8?B?dW1sbm1iQ3dXcTdIM1BRaDZjNktLRHlTTSs1by9BMzAybkIwanFjbjExdHA5?=
 =?utf-8?B?c2VlT0FjVndBTVdROXJTUU5oUWtlYUZ5RFN5YXByTnEvcXB1Q1pqVUlYemhS?=
 =?utf-8?B?V3M2L295eXROOXZESW92WW1TZit4Rmo1MmpmUUU4bmVjQjRsRFBPYmRIZGRQ?=
 =?utf-8?Q?arLzTNnZk7gVzmMjZIWIWrRNSN1sU/gQ8//lx+dKI07g=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VGdlVGFxWm1QdkdHdjZobjV3NHdxckw1TEtQblJmOExpcEhDV1pwTE1HTmN2?=
 =?utf-8?B?MDNPYk1uVzc1VHVVYmFpWXJsOUlzWUx6VXdHZWRIcnFEMVRzRDZqN1crbEp1?=
 =?utf-8?B?ZUdxa2RPdjNGTTJiQWhnY3lDTTZpRWx1cjB6dkFFMG56KzVvTWd3VHpsSVZI?=
 =?utf-8?B?eGpndzUxcUhEenBQOUVoTGc0MGdkbzc2THArNU9TbENBS05OZ1R6eUhPOFJN?=
 =?utf-8?B?OEsvaW1Oc2M3WXZaVVRIVW80emE3U2NBbUpMUVRBT1ROS2xkUGRpZkEyY2ZM?=
 =?utf-8?B?dE10Z2t0citjUk5MeFU1cEQ5QmNicW8yWnlsZTA5WmhBVkl6S2dRNFlOUW9F?=
 =?utf-8?B?TE5UeWg4dlJidDN2cFRyT3kyNVl0Ykx2dUVLZEFobFdLZ08wS1ZhS2Q5K1JZ?=
 =?utf-8?B?bis3ZWtNQWtvRnIxSWVTN1gwMDFoTW55WlBYeTgvTG1IaGxFNmlqb3ZBRGds?=
 =?utf-8?B?Y0pUVUVIbDFDUldaVTFTVFBnNld1R3FBeEhRV3BQMlp4Z1pHSTZjQURDSTVH?=
 =?utf-8?B?cFRCUEQ4YzdwSTF0aXppY3Y0VCs3QncxM1FBMUMyeDdRTmd3YjZ3MDFaQ01m?=
 =?utf-8?B?SmdRQzZkRlhRMVpOd2kycFk0NHlWK1hLY0N5dEJjcGlla3VCQ0FZVGtpSFli?=
 =?utf-8?B?c2lUOWhqd2tHTWhyS08xWUo2L0h4dUYwZjVZdE1JbmhMcmpQYm05OGhMcEFV?=
 =?utf-8?B?b2JscVc1MUxVRUs1Y3dOWUY3TjBmVmVyVlZmM1U4RVRhcUc2dmErZFhXcGlz?=
 =?utf-8?B?U0xwcXJCMnNiS0ozeDMwek1aWDhjUTMwNHhCeU1waU1JYlFKbVhQYjQzMTdy?=
 =?utf-8?B?MGw3TUtaQVFpRFhVR0JlRDBxTnBQb1NoMS9COFNoU1d2MXNYWGJCaTFIT0tp?=
 =?utf-8?B?dEZablBRYmpzeHR5OGphZUdEZXVNeXZnQUkrVVlrM1RGUDlQd3RJb01PS1A5?=
 =?utf-8?B?R3gycUIxdWdTanpUQisxSW53RE5jMHd5N2x5WWdwOXhmWEpYMXhIeHFWVFVJ?=
 =?utf-8?B?bXhKOG1DenMwRGxZS05zeVpHZ1B1QVFIS2twSXhxSThqZFdyZmRvWDVNSVZB?=
 =?utf-8?B?bVUwMEJ4dlVpaHVYMEF5MFlDMDRhQ3U5NkEvN0pJUGdGRE1zVTNuK1hJMldV?=
 =?utf-8?B?a3JlcXBqb2hmYmk5YWxzYTg0NDBxYnEzYk0vcjJGVUZsckszR3loaUxHaXpK?=
 =?utf-8?B?cXhhVVpTUWkrMW9sdUxmbmlTdDIwN3JKNjNYK0V6aURuMkdCOHR0YzVWaXNx?=
 =?utf-8?B?RytPeGdqUmNXcGtldXRhVDRVS1l6YjVOc3Y0OUpJbnVTaHlQbDI4YVlHT1Nq?=
 =?utf-8?B?WmRrQ0s1bnBMSnlxY3lwOGxmVXZZLzNRWUd2TTh1MHhUaG1jbWVoeXAwb1F3?=
 =?utf-8?B?amhQbzY1NUxrUGxHR0J1S24xRHdFQjlpR3JmTUJFYk5zdmRGK1NMa2FNOHdD?=
 =?utf-8?B?Wkk5d3dOSEFISVkvOTZiZ013ZnRLV01keG1XdnJiUk5GMDVsbFRMYXBYSEdh?=
 =?utf-8?B?SHlPcmVSVTUwdWg1UGpIMDBYVmhrcmhnbXFVc2t6MUpUL2NIMGd1MlhHZnho?=
 =?utf-8?B?Y1YvRzBSV3p2alhINjh3aTFtWldVaFRtcGFDWXlyd0ZNSnhHakRpKzZoZjgv?=
 =?utf-8?B?Nmd6bFR6bVBTQUNWSmtQWWJDdGNsU0Fxd2xDRUZEZVF6UVdXZzA2QXpqUDNU?=
 =?utf-8?Q?rKMfJJpTpZnc/9BtqL6I?=
X-OriginatorOrg: sct-15-20-8534-15-msonline-outlook-c9a3c.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 819d2d29-c3d1-40e7-be59-08dde08bd9fe
X-MS-Exchange-CrossTenant-AuthSource: TY1PPFCDFFFA68A.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2025 08:22:22.4331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR02MB6584


On 8/7/2025 7:42 PM, Jinyu Tang wrote:
> The kvm_arch_vcpu_load() function is called in two cases for riscv:
> 1. When entering KVM_RUN from userspace ioctl.
> 2. When a preempted VCPU is scheduled back.
>
> In the second case, if no other KVM VCPU has run on this CPU since the
> current VCPU was preempted, the guest CSR values are still valid in
> the hardware and do not need to be restored.
>
> This patch is to skip the CSR write path when:
> 1. The VCPU was previously preempted
> (vcpu->scheduled_out == 1).
> 2. It is being reloaded on the same physical CPU
> (vcpu->arch.last_exit_cpu == cpu).
> 3. No other KVM VCPU has used this CPU in the meantime
> (vcpu == __this_cpu_read(kvm_former_vcpu)).
>
> This reduces many CSR writes with frequent preemption on the same CPU.
>
> Signed-off-by: Jinyu Tang <tjytimi@163.com>
> ---
>   arch/riscv/kvm/vcpu.c | 9 +++++++++
>   1 file changed, 9 insertions(+)
Reviewed-by: Nutty Liu <nutty.liu@hotmail.com>

Thanks,
Nutty

