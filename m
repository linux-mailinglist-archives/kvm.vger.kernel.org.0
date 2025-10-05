Return-Path: <kvm+bounces-59500-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 16C7DBB94D6
	for <lists+kvm@lfdr.de>; Sun, 05 Oct 2025 10:42:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D966418987AA
	for <lists+kvm@lfdr.de>; Sun,  5 Oct 2025 08:42:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 222C3207A32;
	Sun,  5 Oct 2025 08:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b="cLd6622z"
X-Original-To: kvm@vger.kernel.org
Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazolkn19012059.outbound.protection.outlook.com [52.103.66.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC49219539F;
	Sun,  5 Oct 2025 08:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.66.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759653723; cv=fail; b=IN6eHrP7vY1Xsr/fVx/bzTbnrx4pTppveBi1LaGp6IYM/cviL/SDFAWpPqIEs7G/GjpHq3yV5EVhNuCZypvPSV8BM4dUsyPguN59UFaZtJsGmFCLLPyO5PPA/RQzI+ChBRtvWG4354y4QObgUo2Ky9L5rc6aVHMypQ1SP0r3WVk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759653723; c=relaxed/simple;
	bh=IMXFaBA+6Qzxw7SjE6ey5cnbwMdVuxG0mqoU9L+1Bbc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=e+y7ECZTRgkVbYktMPB47zfTNSshi4kH65K99a2TDh7GSA7hEMkCLDQHIfT+egyaiERmzdYJsFftseryAGnEUKYpTp5r9OyWXvqxZhwfgdp+I+ciYmRThPMl8QuZV/x3lbSeM3u/2AWx6AQOMHo2FNNr8MDA57+zw8Q1a71S3YQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com; spf=pass smtp.mailfrom=hotmail.com; dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b=cLd6622z; arc=fail smtp.client-ip=52.103.66.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R7inD+oV+0UTPFdO/zL4C2FN4p5nKXfNTSoOVIW+MiD34+vu//SgqPYG52CPKk1K/4at62IYFzQQfkNvagbU2AC9Z7dQpWm/8SHwVkUAfQZjDN8VI37xDavK/eqBUm6k+yWnJuFpcTricSC/fAg4/TGF+DuFvDCUNoKfRLmFV5HPYzpW1NusJe4Wwj21sEX/iS/05muM0A7P07+ipFc6mNiP5PdnblAZYExyJOul4INzqeHKzO19d66iPsjV2oBz5jraEUw6LYl0Zq0+luRoYk26DwQtydw6aOd/5SNx2Yz+oIDYVAP9PNJW89KR3McMDUGaeyp0L1aiWKDEXPRa9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Is9pvifWH/9K8qccZXthCJG4JBrJe1Ll9eVEBChJPzQ=;
 b=g/QhJexauwAUdt6pFZtpijz0+h7eNP5AuXxbXwaPXaaWnbY34gs3qNgX3D1HQGANBaErfpozoIMvodzCZZV0LFRQwwgTBKyBzR6eHX13f6+VpClxzLJxa0w/HS6X/dCPn5qarqEwAfvZX88w9IvkqhQYB5nWI8fw7wRe++Hs+Z578kMdDR/cGhTKmvvT6P9JEZ7z/V42OXaDJ1tcuNancDwL2u5sjTtb+m2Vd0cRJMpJ4Uh17JxKgqwX/dSOwTne4LhbIAIos7dqyADiMNbIZjsI8HgEI3uqlo9rGp0jMecg0v7Nt/AI0Qsqq/FVPDM4mhUqrfQ+uk7INGT8DJcioQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Is9pvifWH/9K8qccZXthCJG4JBrJe1Ll9eVEBChJPzQ=;
 b=cLd6622z0yPlo4zSNPfzypCRWHGm4jbhInnfO5PrC1+fZ/aOzOZZ6P+1tpAScdx8hk0ohF4ZS8kykc8uU+fc0Y8zsYkzPmFH5a4M+hDAXyboIU4ZR+UT3xl1FTqUQKxY7PjwatLYLyXwgOelllsdl+rRdt1FV/5vVrMuskSIPw+UffvucLcg7qKQ0UHuAmN4KwrrtS/QqrLH2LsG7bEvbl1HxfaruDPFrf7fuuHr8rIpTDBwoaB/aFaviDRzVPk8cc+/Pvcg8jVckcyzCEDuL7eVrOLMknraJe0Ogw4cvx6c07SbzYeZgfNqdOWOCM5hcUOPB4bF6l5eoTwl9OU+sQ==
Received: from KUZPR04MB9265.apcprd04.prod.outlook.com (2603:1096:d10:5a::6)
 by TYPPR04MB8960.apcprd04.prod.outlook.com (2603:1096:405:314::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Sun, 5 Oct
 2025 08:41:56 +0000
Received: from KUZPR04MB9265.apcprd04.prod.outlook.com
 ([fe80::3c38:c065:daf4:cbfa]) by KUZPR04MB9265.apcprd04.prod.outlook.com
 ([fe80::3c38:c065:daf4:cbfa%5]) with mapi id 15.20.9182.017; Sun, 5 Oct 2025
 08:41:56 +0000
Message-ID:
 <KUZPR04MB9265D17F7582A0489110D1DBF3E2A@KUZPR04MB9265.apcprd04.prod.outlook.com>
Date: Sun, 5 Oct 2025 16:41:52 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 10/18] RISC-V: Define irqbypass vcpu_info
To: Andrew Jones <ajones@ventanamicro.com>, iommu@lists.linux.dev,
 kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: jgg@nvidia.com, zong.li@sifive.com, tjeznach@rivosinc.com,
 joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, anup@brainfault.org,
 atish.patra@linux.dev, tglx@linutronix.de, alex.williamson@redhat.com,
 paul.walmsley@sifive.com, palmer@dabbelt.com, alex@ghiti.fr
References: <20250920203851.2205115-20-ajones@ventanamicro.com>
 <20250920203851.2205115-30-ajones@ventanamicro.com>
Content-Language: en-US
From: "Nutty.Liu" <nutty.liu@hotmail.com>
In-Reply-To: <20250920203851.2205115-30-ajones@ventanamicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2P153CA0018.APCP153.PROD.OUTLOOK.COM (2603:1096::28) To
 KUZPR04MB9265.apcprd04.prod.outlook.com (2603:1096:d10:5a::6)
X-Microsoft-Original-Message-ID:
 <fb443610-0b95-417b-b2c8-3baac22b92e7@hotmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KUZPR04MB9265:EE_|TYPPR04MB8960:EE_
X-MS-Office365-Filtering-Correlation-Id: d5383e9b-c89e-4664-77d2-08de03eb0a97
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|5072599009|15080799012|461199028|6090799003|8060799015|23021999003|37102599003|19110799012|19061999003|3412199025|40105399003|440099028;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?L2g5bnVTOVh4YmlZcGtLMTFKZWF3cFpNclY4ZXhwUjVxTnZ6WDdIUlhKcjQ0?=
 =?utf-8?B?MFgzay9iSDM4ZFhXTFZSR2ExNlROdEtyVUhseEtRSVN1S0RHWSt4ZzFBU2FV?=
 =?utf-8?B?NGhXeHQzOG9HUkRBM216bWl5YTZhWE5iOXpiRmdreWxsMkVoaGJHT21jT3Fz?=
 =?utf-8?B?bHdLTmxQWmNYdVBkajl0Q1FSUDZJd0VmZ1J1OUIyZEdaalBQQTFCcHlEMGhM?=
 =?utf-8?B?R3lMbXJ4SENISVFGVmJlbWsvZ01XclJqM3dTWVV1aW1Wa2drQzV6OTFTeU5O?=
 =?utf-8?B?TEJ5RmJyVDlsSlpIRnBrMUFRakwvNWhEZkRDVjk4YzJEWndlWDFZdlFRVGN5?=
 =?utf-8?B?R3pDSXJ2VWdYUGExdmFYdDVLQ2FGcXh0WHEwSXA5SVhPbWw1eVB0bXNULzJa?=
 =?utf-8?B?V2cvOGcrTVprT0xyU2hGWW9FeVFxR25XbVg3UVFWREF1NkRnZ0g2Q3o4Y1do?=
 =?utf-8?B?V2tLZGR3R0l4aUkwRjZNUHp5TkxFbGF5L3E4RUh5OTk0Rzd1UlJWT0Q4VDhk?=
 =?utf-8?B?WXRGZjE4ajNKdTEweXV5aFNhd1ROWk9IejVacWhScHVaQ09QQi8yd1RxTDc3?=
 =?utf-8?B?UlF5ZGpPSCtMZXZGaGM0RVh4MTJncGxRUVhqdHRpcGJ1TGVSTGJ3Sjc3YmtS?=
 =?utf-8?B?VkFpMU81a3RVaGFoc1lLNWZWckMydlhZRHAvSTlHWVF1dE81REhMdGI1SmpT?=
 =?utf-8?B?M0VTZkdSeHdSN1RqRVZoRjQvU204cTh2OVpOdDA5UURHdzJNMTN4OGUvVTFW?=
 =?utf-8?B?alhOOFQ0ODdocmQ0U1RmTWJ2b2dITlZVWEhJK2NyQ1doK3YyZnBKRjRzUEQx?=
 =?utf-8?B?N2t6NnRRUjU1UUJnZjVzYWJ0cDNQQzkxSE5uSGE0RmhLcTFCTWtmNnZlRmRm?=
 =?utf-8?B?bXFTblNjUTVTaE0vUVB0TVlkUGlVZ1NEZVBlSDJ6R3ZXK2NKU2x3LytqRktB?=
 =?utf-8?B?dlZQVzYwbG9YWjdQTjJtRUx0bkVDNU9wVStwQU5kVjlmTENQSjI3Y2RTOG5D?=
 =?utf-8?B?RHVTMFFUNWp6b29BNlhHRnVTdFR2ZnByOFZPdk5sTlpiekVlNEoyalZVZFhv?=
 =?utf-8?B?SE5RR3BKQTdMSERkc1NLVHhNQ1BzcUxjV1ZvdFZUWWVSNkt0ZXlxTHQxRUgy?=
 =?utf-8?B?WVh2QzNHMEVRdnFYMzZWSzBEMEVFZDQ3a1VqaHYvRzZ2OW5wY2ZmL08zN20w?=
 =?utf-8?B?d0dVWEp5c0EyMHlNd3Y0Uk9oZEFoYTBDNFM2KzlQWkJQT3lHTWQ3SWJ4eWc4?=
 =?utf-8?B?RWtyK2J1K3pmeHZKekRCY1RIUkR0cGdUK1c2ZDV6K0RtVktiaEJNcUFZaE9K?=
 =?utf-8?B?alk2ZThINmhIdVBrUmMrS044WkYyZGdQRmFwNUVsQ0ozVHl3KzZCU0srU0xt?=
 =?utf-8?B?NHlPcWFBdUpXeGdZSTVkQzA4VGtXT3ZVSmJpNDluaGlud2hPVUpBbHlodDRX?=
 =?utf-8?B?OEFmUzVKdzVmaFJJOXNsMVF4L2xUaUVFejBaVHM1OXNOOGVWK01mSDZjRTgv?=
 =?utf-8?B?aGJrYkVuQ3IxbFk2Y2VYenVCSmlYSnFZRVdJUGMrOWx5VDZXdXAySVdFYm00?=
 =?utf-8?B?UkhrQ2d0cWpqUWg5UFk0YkFJUkZ3UTJpN2Jna0c0WHZqTW9tNG1VQ09oTDl4?=
 =?utf-8?Q?FHba5EooS88N5B+BbAriq5Q6ZMvkg72zcsFV2by77pFg=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dFdLNGpWNUt6amZLaENlaFJJcEV5UnZ0d3ZtT1JoWGd4QS9YbEpFYjI1Wmgv?=
 =?utf-8?B?WWNCMHFvRHRHdkJXbUFYMjlId01HQUpNb0syNWFzWlpHaWpDR2hDaTJlaUNU?=
 =?utf-8?B?MGhtTHljYk1JWjVwd2NwUU9oM0hTNS9WOVB0UVR4UlRMRVlReElzSXVFUkV0?=
 =?utf-8?B?OG01SDRya0NwMDhTcEpjenVDbWxsYWdYZE5tbi9SdkkySFRwK3VFZ2F3T1VT?=
 =?utf-8?B?Ykd2SnR0R1BMbUxsYUlHZzVzNkpSL08reHVBR1l5YThpNXQyc1JSZFlEcGdx?=
 =?utf-8?B?SWE1bE8yQ0FqOEpTdk9oV3hXbmJXdXhoNlV6TUhwMU0vWXBYbE93U2RESG9m?=
 =?utf-8?B?bjcveUFNcjBjeWlhR3hkZnJ5MmFNcGpSMHNReEtnNWRYQURVekdPUVFEZUNS?=
 =?utf-8?B?NUhZbnQrMk1qS3FnbjVsckFCM2Z5akRZQ3BkRmlwY3gxbkZabkNKcGpNRG9s?=
 =?utf-8?B?cWZvNzQyN1JnRjZUY0dwb2luODFpV29ISVBZVzRQUWtDTDBHcVVQRGNoUXdl?=
 =?utf-8?B?NnphT3RPL3g5cEFFeFJuQ1JScndzNU0rVmIwaVRlcEl0Y0pUZ0U1UFZGNDJy?=
 =?utf-8?B?b2tLKzZta250MnZ5TTNaT0ZpKzZoSE5UdE43TmJvUmJieXBQY3lmS20ySFRW?=
 =?utf-8?B?ZE50dGczcHZGeGdlYVFNczNlTXI5OXBCUXljQ0pMTDFsSGxvajdVODNlK2lD?=
 =?utf-8?B?QTE3V3E0WVhMRW1RTlpObVBqOHlnRE9ua1EreSt6aGpUclpMeWNRUjFpWkFD?=
 =?utf-8?B?M3RGa2IvS2hwRERHU3dxcmo1NklKQXRtVEo3THVuRHBndkhQdnhsQXZKN3RX?=
 =?utf-8?B?M2VPdzBxRmY1Uk4yRi9kb05jOFRhZXF4d2o5TUk3ZDBmakN6ZTRIWTNDOEk1?=
 =?utf-8?B?aU0reHJlQnc3Y05JL2c4ZnlVcC80bVd1TjB6K3FoQzU0ZmhjekhUY2ZDUFVv?=
 =?utf-8?B?TENpd0NNaDVmRkJrbkUxRW5ZN0Y3ZHkxYThPUGJjUnArQkFZZFc3d0dVdlpj?=
 =?utf-8?B?YXk5dllBTkZSQXlQUmpNSkFqdFpsVUVxRlp2a3BlYktlOWpRdXBzbmV4am40?=
 =?utf-8?B?N1hUVER3RFhoMkdmQ1RVRzY5YnJuUFBSa01QcDM5Nndpd2s4UGNzclp4MVdj?=
 =?utf-8?B?U21tWGJHNFVRcEQ1K1pkNEp5RDU2VlhQb3k1YnA4V1dkRzR6b0YvQUJlL2lZ?=
 =?utf-8?B?R0hlWTlhSUlmSkxMd0JOSVl2dm9jTkFCRU9GMHBLY0w5OWgyOVF3T2dWaUJY?=
 =?utf-8?B?NXdTWWdBMGVuWFROa3IzQ0hYdDV6LzBLY1FKM01TTmwrVDU2MWlXVlNVV0NX?=
 =?utf-8?B?RnZ6emZBeHNwZ1B2NWt5NytBNjNvUGpiN1pSMUZOdnhMQ0loZGZuSVR0VWJZ?=
 =?utf-8?B?NllrdHNGeVpmSVZubTFGbmRnUUJ3NHBTY3hvK0EzMWYvUkNPdlM4b2h5bnh2?=
 =?utf-8?B?RzJIT3pyTzBZSkZFdnk0VDdqTXFGTDNoVDFaMThuOXlJeUtyMzgwZW81cXBC?=
 =?utf-8?B?QVZ6SjJQOGZGcHRmdk5CZjNxd0NNUk90Z1dVUVpac0swWXAwS1lZVUFNKzNp?=
 =?utf-8?B?ekhpOUYyMDVKWWI1V2xPM0xVUVpBVDZUZktDVnVZTzRHa205R2twcVVabm9k?=
 =?utf-8?Q?kR2NzjQNT2OeHodt2Y+fQYnXKSKBEpsoW6EUrHFWMp0o=3D?=
X-OriginatorOrg: sct-15-20-9052-0-msonline-outlook-38779.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: d5383e9b-c89e-4664-77d2-08de03eb0a97
X-MS-Exchange-CrossTenant-AuthSource: KUZPR04MB9265.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2025 08:41:56.4520
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYPPR04MB8960

On 9/21/2025 4:39 AM, Andrew Jones wrote:
> The vcpu_info parameter to irq_set_vcpu_affinity() effectively
> defines an arch specific IOMMU <=> hypervisor protocol. Provide
> a definition for the RISCV IOMMU.
>
> Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
> ---
>   arch/riscv/include/asm/irq.h | 9 +++++++++
>   1 file changed, 9 insertions(+)
Reviewed-by: Nutty Liu <nutty.liu@hotmail.com>

Thanks,
Nutty

