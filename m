Return-Path: <kvm+bounces-59499-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E68B8BB94D0
	for <lists+kvm@lfdr.de>; Sun, 05 Oct 2025 10:41:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 27B121893156
	for <lists+kvm@lfdr.de>; Sun,  5 Oct 2025 08:41:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90E3920A5C4;
	Sun,  5 Oct 2025 08:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b="N1C0Gpji"
X-Original-To: kvm@vger.kernel.org
Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazolkn19012058.outbound.protection.outlook.com [52.103.43.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C2B1FDA9E;
	Sun,  5 Oct 2025 08:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.43.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759653671; cv=fail; b=bOm6D8uowbdtpig755gg4KNeUZHPRQzmG8BfF39Vy9GI818GIKYJDuiKYU2MAOse82t5vruYc/zMHKHY96Yx4u4B5NwxaNG46Fnu13EZz9Yp22T0x5xhVRLv1gO7s97UWS8kWmr1blnUnR1i+chiHaNkb6A4I/8d4xN8wBUEMPM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759653671; c=relaxed/simple;
	bh=akAC7Z2IEa5b1KS/ynxD6oGGfAA6ABYWkRaPq6Ro4O4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CH2q734JAMp6zO0oRxxybtHdUSN9jDMuTc1W9clfGZO1uHa+t+fdBVAUZI9auLmZ3gOizncpVmnwXd5+0yFTpJwah0n8UVKmtJtCDGOqICzebXWRjPaQt2WKasnPveM/zVpJ+114Ew+JygezhFn2vJXXKBJF17gVcCi0mx4BM2k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com; spf=pass smtp.mailfrom=hotmail.com; dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b=N1C0Gpji; arc=fail smtp.client-ip=52.103.43.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MxBeepOkkbiuceURJEWqjHzX3BdQw5bFgZhunJguuHXWx1vu+mWKWufKogZ3wZlQmWWxO5rOyqhoynQiR1e3TOEIhThG2sOQCoiyopJUK5Pg91r7ks26uouFxbaEGbyQI205r3jgQjNZhSHdpCAOUIfujg7be8xUH1JZTzzYIVOVVdGZ2lq6b4kG8FOLBryK8TLGKni6pUwW+gCktdZAcQE32RThSbk9HChHn4dkSO5SbQtYMK89XbPcWxJyYbWdPf0Q4S/6mrE0+7L97fNjfNcwi7fssL3VV3YCQpnrgUWZgZHFon/IZSoSFgIrsD8S74QKnjLARp3dsonI2YprLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dr/LLVziW5W4yLa9hjA8TBxRC9lgXF23XhqTSkDQ1c4=;
 b=xH2QvTkeXbpyLU66FatxP9LzWIvrDKK8AqvDpudbmercCFLB/LvG3hLr/pVlE0F67hKdmy4V3Bpf6gjiotAyqEAtoDzAu9Rdu+fsGEWdc7EQ1jkTYBwo+E2inC6JeVDtXbASFD93nGwVRwTUK3rIAxSn1UQaeALSgFfVDU9z7mSmaPKtOU1fVi9jXs41+JRnCm341aUaLJsTOfhbrVa6nvZW1t+QGrOc3FuLTGSCGMTLLaVfeFdHGs29MHQNwvDce6eAG1lOOrRJZ2zf8XoX6PC4P9+t4bsLXR0vxiq/PP6rwPFjajH/omvs4iA5MKnBVgDiw1Wp9TBwxQOJXhcxKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dr/LLVziW5W4yLa9hjA8TBxRC9lgXF23XhqTSkDQ1c4=;
 b=N1C0Gpjixoc5tWENmpyOklxHeATrSjTZZS4FqAurIUDOK+OaFAEFyMyDpHVZsqIeTL6MHHx9VQT+mczbzjHIyoRptMXR+x1yO+2MQJPICrDcgo01dWaaoPM/bG90PFw0KnHn0VA5l3zZnnesMrV+xD9c3Cn601wgwnuWv8Z1PrA1/eDBfe45FmtP3QBG6eDBxdImdYxLrNr+77R3oCVmCD48OEJwmQZ+or9JIXCUrxIBlC/fbrJtXkvNX78p7S+q9aFdDgRUvfnf7d1FZ+J/7+EByvunIFcMpaFcCSjtfhhd11kl7KEeFUiBnasq5brjAab2+52fJ7WYoSnUjGF2qA==
Received: from KUZPR04MB9265.apcprd04.prod.outlook.com (2603:1096:d10:5a::6)
 by TYPPR04MB8960.apcprd04.prod.outlook.com (2603:1096:405:314::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Sun, 5 Oct
 2025 08:41:05 +0000
Received: from KUZPR04MB9265.apcprd04.prod.outlook.com
 ([fe80::3c38:c065:daf4:cbfa]) by KUZPR04MB9265.apcprd04.prod.outlook.com
 ([fe80::3c38:c065:daf4:cbfa%5]) with mapi id 15.20.9182.017; Sun, 5 Oct 2025
 08:41:05 +0000
Message-ID:
 <KUZPR04MB926516CEFC1CBF2C5071658FF3E2A@KUZPR04MB9265.apcprd04.prod.outlook.com>
Date: Sun, 5 Oct 2025 16:40:57 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 09/18] iommu/dma: enable IOMMU_DMA for RISC-V
To: Andrew Jones <ajones@ventanamicro.com>, iommu@lists.linux.dev,
 kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: jgg@nvidia.com, zong.li@sifive.com, tjeznach@rivosinc.com,
 joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, anup@brainfault.org,
 atish.patra@linux.dev, tglx@linutronix.de, alex.williamson@redhat.com,
 paul.walmsley@sifive.com, palmer@dabbelt.com, alex@ghiti.fr
References: <20250920203851.2205115-20-ajones@ventanamicro.com>
 <20250920203851.2205115-29-ajones@ventanamicro.com>
Content-Language: en-US
From: "Nutty.Liu" <nutty.liu@hotmail.com>
In-Reply-To: <20250920203851.2205115-29-ajones@ventanamicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2P153CA0006.APCP153.PROD.OUTLOOK.COM (2603:1096::16) To
 KUZPR04MB9265.apcprd04.prod.outlook.com (2603:1096:d10:5a::6)
X-Microsoft-Original-Message-ID:
 <f2251156-a2c0-4658-a90a-d76b08fa222a@hotmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KUZPR04MB9265:EE_|TYPPR04MB8960:EE_
X-MS-Office365-Filtering-Correlation-Id: 35cd974b-f88c-405d-a5af-08de03eaec14
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|5072599009|15080799012|461199028|6090799003|8060799015|23021999003|37102599003|19110799012|3412199025|40105399003|440099028;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QjlDOGl2bDA4Qk1kUUwzbVF0dEEzekZROXJzUS80ZEUzMUJVKzVheXRRMEpR?=
 =?utf-8?B?ZmM4NGtFRlRSc2ppV05Nd1VqQzIvK0hZdS84RVVJQThMSzkxSXRGOVhkZUtJ?=
 =?utf-8?B?QmlmL3lpREVidWM3Z3BZS0ZtQU5pclBtc3JVektRY0pqQXFENE1rSW0zVWVD?=
 =?utf-8?B?NXJlU3grV0xHV3l0SkhRdWp0RVB4djZ6OEdpT0p5RGtaOTczV2NvRHdNVC9B?=
 =?utf-8?B?dWFGanpmT1RCVVZMNjRIZXMxdjdqdkFsTEl4SWZTQkxzcXZZbjJWMkhNbEg3?=
 =?utf-8?B?MWZZNHFlejZDem5Sb3F3dlFjM09HbHF4WDRQZHh2V1B6aUs1ODZwbkFRR1Nw?=
 =?utf-8?B?b1FRSEFyUnVqbHF3MG1JTXhoVy9Tc2FrVXE5RUZSNWJWc3lZRkt2YjgrVkIw?=
 =?utf-8?B?a2ZpWDNRM2t3dzJmY0pxVHdKQVMrVmp5Y2MyeVdIRTU5QkZFSGMwSjlBUmZa?=
 =?utf-8?B?SFdqK3RVRXZaV0IzdXZkTkJlbWk3WUNra2tjSnd2dGtnc25zdWdBL0VudTFG?=
 =?utf-8?B?eENiSnZEMWphb0JTYTlaRTBNQUUxTlU5amVILzkxOVBzcGw3QTR3OFBaYk1D?=
 =?utf-8?B?L01zVUVPTTVJZmFOYVhQZ25WaGJLdHFTNzZYaG52SjBJQm5mVnVCdWRKWjRx?=
 =?utf-8?B?ajZJaTBlWlV6SGt3bFl6RmNWU2Y1ZVlrREJHdGRjRXZxTDhwdForZEc2ZXZw?=
 =?utf-8?B?YUNuUWNkS1JpbWwwK1FTYjlRMFQwUVIvWTZGQXFaRFpLbEdYN3M0aks4NXRa?=
 =?utf-8?B?T3M0M3lOTkkwaEZUTS9UeGdId2J0dTlMTzhLN25YWVp1aWdPbWxmWFNCMkh6?=
 =?utf-8?B?K2M5WmY0a1MzRE1aRXFudUhiRVFUekdieVVINHZLRDIrcFBGMUVJR1RpNW80?=
 =?utf-8?B?OG5wV0xISnBpRklZK1dXQ3JqcXlUZTlGZG9WbFFMQ1Vod29uNFVGRTFoQkxj?=
 =?utf-8?B?OGw5cEFsMStDWXFOY0JPQk8ycXF0WTYwZWtGL2dHbVhFdm9UKzhOQzFUSDZ4?=
 =?utf-8?B?TDFYMlpXcFRrWDJ4cjd0aUF3K1FMLzRNZWJaOGtIV1E3Qngrd1BkVmJLS2ww?=
 =?utf-8?B?SGxONUswNDh6cjZHUVBYRXBFMnUrRlZTcjIvVytBZXZBbVZ5Znk3SnRpTnJ0?=
 =?utf-8?B?YW40eHEzUUhpbndVT2JoeXhLV3liemhlRHVSbjFZd0pzZk9OcnZ4S1pUblZa?=
 =?utf-8?B?WmpjcUErUS8wbC9URU9pVUIzaVlma0gvWENkTm83ZXlYdllBYkxUOW1sZG90?=
 =?utf-8?B?djIwYWF1TU15UG1mbmxCNXFUUWszSE5oeVl2dFJXK2ZibzNsc2NoQWFaYit4?=
 =?utf-8?B?eTRNVloxOUw3b1NvcVFBNWlnY0QzM2VuZXVrd1dJN1ZCWGU5MzZVaElGbFR1?=
 =?utf-8?B?cmh4ZnFWRjVnZ2hsUGNLRFFlMnJSV242UmNRd3dCSHlIRzk2cVBSSktvdDRW?=
 =?utf-8?B?cVgydENOYkFLc255U3VTcXVUaEpKbHdqVFUvZjJmckRVRCtOSFZuM3lzMHpo?=
 =?utf-8?B?UVo2VUFqMUlSTUg2cTk4YXVUemNUUlJheWpMWWFLWG93bFhOcG1mOWpFd2VG?=
 =?utf-8?B?QjVYVE1Idlh1YnVHTEl1VmR6dFVnd1VySHRYNXpTVDFYK0xvRXJ1R2VTZWRu?=
 =?utf-8?B?VWdjS3BpVkRXeU85Vi9zVk1xTlFJaFE9PQ==?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dzlyMDhBWWYwNVNodWtabVJ4bVZDUG82cGp4aXQrckh2U2JBT000Mm90MVNu?=
 =?utf-8?B?UGU2emtpenJkekNyOTkvT0xwWnozcUk5ak5oSjJVeHFJT0VVWXJmRlJaWU9v?=
 =?utf-8?B?QUFGU3VjSm15eE5DcG5MQUwyVVdjNkhlNkN4NU9LMXJKck1pL2pNRFdtaHFl?=
 =?utf-8?B?VHZEUGNIRlBBNTF6M1diTk5iY0NSUVNwRjVpR09kbk15bU4zQlJlV3RQVFNl?=
 =?utf-8?B?ZlhYN0NPdXNJMTQ5QkxWVG51VlM5MFNqOEwrcVRoVFdJVzBoUk1zbTdVU1BO?=
 =?utf-8?B?VU9POVVDNy9hbG1oMEV2VGlCdkFTeDluSmtRTUJCWks2Wmg0dnZyL0cvRVlL?=
 =?utf-8?B?R2FJeGdsc1lGV25ERHpZbzZHb243eHJnY3pDZnlZWWwvSXA2S2ZpWmswcFlL?=
 =?utf-8?B?WWJvczRpZktoUm1GMDN2VWFxcTZoY1V5ekxUd0tud2swb2Q1cXhwOCtyekJI?=
 =?utf-8?B?b0tyY1EyS2pWdEZDL3F4WjZKSVQ4WDFXRndoSllpYXhzc1QyM1Y0QnJSdUN3?=
 =?utf-8?B?QzB1SjY4VVRMa3V1ZmpPTjA2UmpIbXhCNEZtTkJGSzhDam5CR1liRU9Ma0pn?=
 =?utf-8?B?cmFCQUlZOU1tUC9vWVdCUmhiSGpwUTNsclhjS1pjOGRza29OYXVLSlZyZW1r?=
 =?utf-8?B?cG9iNlFsdUEvdzRkZWZEUndUVkNZdlFZRUxnaGFpQi9NRUVhL1ZqZkRBM0hP?=
 =?utf-8?B?b043ckl1d3Jad2gwM01oR1FLKzliUUhybXNvUzd4amlYVXhQcVlqM2lSYUFF?=
 =?utf-8?B?aDloUjhVWkdRNFlmMU1wemNvVForWFVaN3JtR1QvVGt5YTZxdEozNy9uL20w?=
 =?utf-8?B?Qm5vVFhYQkJZb2RaMi82U29qUit4T3BEbGs3bHEwL0VSQThBcm9keVhWMTRp?=
 =?utf-8?B?TWdiQXNXTU9NbWUrc1VCTzk2T3BsR2M1RW1BN0FIREEzWnBseHJKS0dHSC9X?=
 =?utf-8?B?Mnd4bUZraStLMFhmZ3I3N2VXSE85bWM0VXN0UmdQMjBKR0Nna25kS1JiWGJv?=
 =?utf-8?B?Tzh0TFVLZ205amQrQ0VsSVJ4YWpwZkRwTE9XTnB4ZjJHa2RkWTdLV2QvZTdS?=
 =?utf-8?B?RC92Q3BJV2NOV3M4SithK2hxRk9VRDM0aUllQ2E2cmV2QkdQbllFQkJGdWxi?=
 =?utf-8?B?b0IrN3dsUXBFenZLR0RyNTIyMzJyU2VCSUV5NWgwZmZtUlk0U2lGS3lOTHZO?=
 =?utf-8?B?QzFzdldPTDI2NytSSXJZdHdmdUlvSTMvNDRzekJiYVJyaVFVUEdKNk9PM1hm?=
 =?utf-8?B?bGp6YUVHZUhsVkFkR2dhQ3psbll3MUFhUWh0Rkt3ZnpISFhoQTNxazc2TGl4?=
 =?utf-8?B?Y0x3SGVGcXBtekJyTS8rRmxzMVlSOWJpMEExenVVYmo4dHZYaWJyUDdLb1hq?=
 =?utf-8?B?VnJDdGxKRmgyeFNuRXpxblpLNlJPZVRNRmxQcXVMUjlPeUlIbG1iTHFRaE5r?=
 =?utf-8?B?REkyVmp1K3hQL1EvWTVuZUIrNnk0UTY5MVR0aGJObVdCQTQzL1hRMlZxdGVR?=
 =?utf-8?B?R0ZRTUpJd1I5QjV2bGJMK1BrL3pZdFpUenM0bFNFRFVCaFVMUHRPRG1lNE9m?=
 =?utf-8?B?WUVGZ0ovM1plb2pLbU5OQjhQVUxML1NSVUpla1pFNGVMQTFJdmJ3ZitoZURE?=
 =?utf-8?Q?UYD7YuxNvqh75pzYabgHBNVTH9s6CRFL1J6Qkc7BCqEs=3D?=
X-OriginatorOrg: sct-15-20-9052-0-msonline-outlook-38779.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 35cd974b-f88c-405d-a5af-08de03eaec14
X-MS-Exchange-CrossTenant-AuthSource: KUZPR04MB9265.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2025 08:41:05.2774
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYPPR04MB8960

On 9/21/2025 4:38 AM, Andrew Jones wrote:
> From: Tomasz Jeznach <tjeznach@rivosinc.com>
>
> With iommu/riscv driver available we can enable IOMMU_DMA support
> for RISC-V architecture.
>
> Signed-off-by: Tomasz Jeznach <tjeznach@rivosinc.com>
> Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
> ---
>   drivers/iommu/Kconfig | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
Reviewed-by: Nutty Liu <nutty.liu@hotmail.com>

Thanks,
Nutty

