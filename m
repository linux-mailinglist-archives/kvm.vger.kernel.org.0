Return-Path: <kvm+bounces-54946-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CCA6EB2B7E2
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 05:43:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 384785E509F
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 03:41:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15BB729D272;
	Tue, 19 Aug 2025 03:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b="L1L+ptLC"
X-Original-To: kvm@vger.kernel.org
Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazolkn19013084.outbound.protection.outlook.com [52.103.43.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A81501F4CB6;
	Tue, 19 Aug 2025 03:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.43.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755574904; cv=fail; b=lEAiyIAaHU78cf3xIo25fII+PoB4qf6NIDG+U2xpoKgALRFfeSgXiAX6est5PXsNS+lfU/nAFgVJ/p/7Dz/ONOLKzuf/EXdDheL4FPOGrgD2GelLJtbKSifRi9dv9TAKQUHWjAchrvzbJcsT7aqaXmsdWwThFmMNpDFMxQlePGk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755574904; c=relaxed/simple;
	bh=yXwkCQuAFJirZ4rL0nsxBkcZVEZBHGhwpMiPzQviKHo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=epQ81wJiaHK9OpO8vQraWymbJEasxLN2BtjgrHv09vMqS1c3AxBju5490YUN9qAe18tVQJw6TQEnqzlPRt0MQMfe3t/Su5lw7xARZbVWL85ZyD8dvoBb4hA24AI6eDw/kG2+Sujri+BglolE0UJva31ht9WHjfAUPhEqbX2kXfw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com; spf=pass smtp.mailfrom=hotmail.com; dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b=L1L+ptLC; arc=fail smtp.client-ip=52.103.43.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KBnX4gSC9kZu8jrz36BW38A+sReB8rruNbzGS7r0RRn1ATxmgLTQwI7HI2P7rbJxidO/p0xJYlpMw/CdpORU88PPdO3fHICefDVGMGnFVaSRO5LC2F5Ej6T31OBMrMqecCdVDca9FhphBg8ktzfJh7ZXBIudZQY4WP83WfFfm0DCB1aYwRy+xRSLrHpFiA5uPQfPxfF/67APhsTRVY6l1VF2tgPgnLasXwWuN8VLKgjWbid/TJeDEqN06ZQVXuPI/k3eDz74+b07cPWgaFGKHhLsmzgcDEnjWmWvPBlhyl5slGtlaXINZGhybWpXtAG4gxGUZDghb8MJGCQHhWqe1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ak11IexJLFkXFOHj12vuY45GCbK1FAC8ifN3CYRGb3o=;
 b=QSbZW40CExbREGWoLVKl+C9ZZghLRIaf+TDwPhdl7Y7zOPH39VtRBSkTFaU8DMCPBSUhHS/QOM/on7bBga5njYiBd4b+GuHFM9IKNApt+n23JN4KlPSdZZKOJMnCGMmLk4ZLvoQLMdQXOTYmBl6x/v466MOp8KFjuxNUOi6bJ8iM8ugGAIq4Ix+Y7XDEY6sNFFYNH6uW4YuPkG9srvOJ+lsKGN1el5D6xdsUNeClHEFgqjd+l/Ae9jHOV8MKlTYkFrFMuMze5nNQuzppgZLSGws7TvPhajesOhZzvKZQ9vNm8fsBk0nMZR2N0lS1clFjbOcfNptPAo0KP5dVb3QUig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ak11IexJLFkXFOHj12vuY45GCbK1FAC8ifN3CYRGb3o=;
 b=L1L+ptLCoNZC/+QyjoIP8L0C+WmPKpkcCGwh5quqFl4H4gxzrEWFeRcW0zEb3j9xgvtcQLbo58zCJvm0gWSfe8BwEnHAmELwcd2UXHWprxXOUHA3pkfrBgBaDIEWPPTRH6f+0hjevzVG94N3AMh8aRs5HEll6LRoWAyIrZJ0ViT9Sycg3kUxZSAyErhM0DATpfTT3BSesbNxM8GEKC4LnPFNLE7SxzeNBJmnrQRagL4c7DR5baaGcyG71XcrQDJrWrk5gqXnwYYc/Ls/zXMM6vUhDrUesaQ/afG7ekRWUiVQmEu3CfQBU9gcJIdT2f3H/OXycN9WtI7NOOwJ1cZdrw==
Received: from TY1PPFCDFFFA68A.apcprd02.prod.outlook.com (2603:1096:408::966)
 by TYSPR02MB7782.apcprd02.prod.outlook.com (2603:1096:405:57::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Tue, 19 Aug
 2025 03:41:38 +0000
Received: from TY1PPFCDFFFA68A.apcprd02.prod.outlook.com
 ([fe80::209a:b4cd:540:c5da]) by TY1PPFCDFFFA68A.apcprd02.prod.outlook.com
 ([fe80::209a:b4cd:540:c5da%6]) with mapi id 15.20.9031.018; Tue, 19 Aug 2025
 03:41:38 +0000
Message-ID:
 <TY1PPFCDFFFA68A3264F71DB64EFD17530EF330A@TY1PPFCDFFFA68A.apcprd02.prod.outlook.com>
Date: Tue, 19 Aug 2025 11:41:32 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/6] KVM: riscv: selftests: Add Zicbop extension to
 get-reg-list test
To: zhouquan@iscas.ac.cn, anup@brainfault.org, ajones@ventanamicro.com,
 atishp@atishpatra.org, paul.walmsley@sifive.com, palmer@dabbelt.com
Cc: linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
References: <cover.1754646071.git.zhouquan@iscas.ac.cn>
 <076908690c15070f907f43d2ff81ba7e95582ec7.1754646071.git.zhouquan@iscas.ac.cn>
Content-Language: en-US
From: "Nutty.Liu" <nutty.liu@hotmail.com>
In-Reply-To: <076908690c15070f907f43d2ff81ba7e95582ec7.1754646071.git.zhouquan@iscas.ac.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0002.apcprd02.prod.outlook.com
 (2603:1096:4:194::22) To TY1PPFCDFFFA68A.apcprd02.prod.outlook.com
 (2603:1096:408::966)
X-Microsoft-Original-Message-ID:
 <fb85d6ed-5bb2-4b67-aa2d-ee7dbfbc23fb@hotmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TY1PPFCDFFFA68A:EE_|TYSPR02MB7782:EE_
X-MS-Office365-Filtering-Correlation-Id: a9e0179c-3a65-4d65-ed6a-08ddded24d69
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|8060799015|36102599003|19110799012|5072599009|461199028|6090799003|15080799012|23021999003|440099028|3412199025|40105399003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?c2d4d04vb0FBRGsyNkVKRTVlSTdKOTEweWRlWUdZWWFQdmtUS1JhTndXN1g3?=
 =?utf-8?B?amVFS3phMzN3TlRqT0I1U0huVUxhK2Y0ODVaMXFsblhxM1NWQlBaRGU5WTlt?=
 =?utf-8?B?OW1PTG83RExTVGlvWHA2aUxlcWp5bDRWOFdoaFVpamZ2VVpRN1pNbnVDeEJC?=
 =?utf-8?B?czZpUEd3VG1QaVdZTEtDUnM3aTVldHFoczVpZzJnS3lsTElFSGdReWJKN0Ey?=
 =?utf-8?B?Z3BQLzBOUU4yMlVESTdKNFZQcTBCTG1ZbWVGNXRjVTN5YzdnWWRvZlg0WStw?=
 =?utf-8?B?Vm5VR3NjYlBEeGt1M3Z4VnBFd00yRk1nYVdUbWNiWnVqV0hNdVQxZ3BBUlNx?=
 =?utf-8?B?Tnc5bXBMaG9PS2hab0h2eWVSbUlOSUdmVVpTK053QXZzN3RmZXBjWko1OU9Y?=
 =?utf-8?B?ZDJuQXVRUjJIeGxDTlVOUHl4NkFja0Zsek8zdHNoSFRrV0J1dDJPL1B6aUd5?=
 =?utf-8?B?Rk1saHJqUkxYaFFoQmxxTTdGQVFMYWFsbTlzWllqeDlrdDJZTGptdmFWUjEv?=
 =?utf-8?B?WnptS3UvR2dIUWJ0YXVTSXJFbkIvYmcySVhFVUVneFdnTC9WRnRMUFo4S3li?=
 =?utf-8?B?Z0liSitzNncraGRTUEMyQ1FrdnpiOTRIUldMVFp6SVNraEo5czEvMkdyNmtn?=
 =?utf-8?B?WnkweTk2b1ZBNDdvWXlLcFd0QWNCdG9wNithcXFPbnhkZ2k2SkJrenhqYndt?=
 =?utf-8?B?ZHk3TWlLYTVJMzZyeFJMeHdGWDZXRDRIUGcrWE55dzNUTUpodG1VWVlHamZF?=
 =?utf-8?B?UmlPK2VTWTlJbGdheU9jM0V4VDRBdjFXV0psTjM2TmQ2L2xSU25pVGRQSWtY?=
 =?utf-8?B?bkFyWXZOMFYzUDJ4Q1FmWkpHaytWNk5rOTZBYzBBSjAxbC9iU0xxcGFvWldV?=
 =?utf-8?B?ZERHT3NOS1JxbE55L3MzQnoweUNxYWQ0d09zM2JTWGNoSGZva3hNMXhGNy9K?=
 =?utf-8?B?cTZ6bEN0T21qRDZLbU9FbytDNUc5QmIyU2NteDAycXhkcldMaVJzcUJLMDNQ?=
 =?utf-8?B?NmNBSkNMbUJXYzF6OUdHTlhkOFF1L010T1RKSkxpdUZ1OEVVbXNYRUFkK0ZX?=
 =?utf-8?B?R21RaGlLakNGZnBXS2twc3lDN2oyY2lYQ1BKa0dXTG5yc0Ywc0wzeGpFL3ZT?=
 =?utf-8?B?RUh0d2FhUXltd29kRWs4cVVtU0xZMUZUOWdUM3hTRGZEbHdLRGRQbVljS2tY?=
 =?utf-8?B?ZDVJLy9hRlRiODhpL05SN2tMeGZ2bEl0SE5MWWhaeDloMUs1L1hoOW9GcUdZ?=
 =?utf-8?B?TWhuaUZkSXlJUE9ZVWVFaHJpRk9rbWVkRkhzbW05K0hQTGM4SkErTzNxM0t5?=
 =?utf-8?B?QUFrYzFQRWNnRXBUVW90NVNnQWkxZHJ4Y1g0azRUcjNWczJxdlJyTzQ0OEVK?=
 =?utf-8?B?bzVlZzVnN3JaRTl4V2ZiaUVkNGpkMDZma3d3SkdoTFRHNlVmc3dYanM0V0lW?=
 =?utf-8?B?ZndZN29henQ4ZS9WNUtLSlNJam5zclBOL1ZiRGdleUVIZnM2WXVIcFhEVEV6?=
 =?utf-8?B?WWJDaVFac1A2Tk0xZlRYa0J6ZVozVkxxOWNnSVN6YWE0dWlmZlBRd2MxOExT?=
 =?utf-8?B?UlU4NDJKdjBZSWZkdzdNZU9ZcktyT2FZTzRXSEZlS0s1RGI4QmY4WHlKcWoy?=
 =?utf-8?B?UTVCK1liK3dRMzZEY0dMU0xIQW5LYmc9PQ==?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dkt4SmZPQTVNUUx1SnBLTE9NaUhVY0EwUlNkdVpqd1BiaWgyT1BiL2lGVVJE?=
 =?utf-8?B?UDkwR1ZWMnpIQlFhMVNObkJNRkM2MTRmV3FERk1yUUR0WlhrYm4zeXV0bTBF?=
 =?utf-8?B?bG1jcFlBbVVRSm9HWGVhZklHTzFsR1NCbHVRU1Nwb2FnYy8vQVMxK21tUDd1?=
 =?utf-8?B?b1N2TWExSURCOHlkVVdtbFV0dWt5WmNGMHZqckhBbmRYNXAxYkJVVjlWVUdl?=
 =?utf-8?B?UEhDVitPVk5rNmp0UDkzZ3Y4Snd1aEhZY1JHcExwWE1TVkJqMFFKVVl1cGtY?=
 =?utf-8?B?NHZCN2ZoQTR2aTZ1UUQzOWp3USt3TG1HNWIyNkhzSzZHckpjQU9FQjNoVVJa?=
 =?utf-8?B?cCtGQUpMdS9wbkhNTGFLN3VnS2t6MStSVytpV1JTOVNNV3RZTDJnVHFkam83?=
 =?utf-8?B?NHU4V3FoelJuSnBrRnkrbWx4Z2sxUDYxMzROV3ZoVTlpYWc4QzBpUHhyR0lC?=
 =?utf-8?B?c2k2czFjOTBNNFpQaUZiYjRaemlSTU4zQ29aeXBndjJsVGpBaG5la0txZXJa?=
 =?utf-8?B?WmtRcndTWVhsenZ0YWVNR3A1ZW4xNkV2L3JsYXVPam1PYUhYVkJ5MU5YMTNR?=
 =?utf-8?B?STh5eUg2SGR5bTVFNTJ3RnJ0eURMZ1BsSUVmTWsrSjRYaEI2Tnd3N1U5RStJ?=
 =?utf-8?B?SEptTWpYSnVuRVZ2T1Eva2pZbzNqUmNRaklRM3RBcDZObjA2OTZlbmg2b1Rs?=
 =?utf-8?B?dFl3a0RzMWRLZitsTjA1MVk3UjZTVHdGY2tPdzJjRDFlUjVCM3pxWFBuM1Bi?=
 =?utf-8?B?UDRWOXdYK1R4NTRjYXI4VFZhczY0eEkzNnhoblFwNmVMMmxjbTRaSFlBK0E3?=
 =?utf-8?B?TlN6dERzZm83K2pGUVRyNDhQTXRHSDNWbXhNOXdaUzl6b1prUFdsc0xReU5p?=
 =?utf-8?B?VjRwN3IwbzA1TW0rK1RHUGhWek55ZVRUOThDMWFMa0grVmpSYktIWVNVSlZB?=
 =?utf-8?B?WHltZEw2dDJnbjM3RGlkL1YxTFg0dFdHL1hOU0luN2t4dlRNbGJRM29GaktO?=
 =?utf-8?B?R2lnMU5GZ3dRYmNESENUYWdXaGs0SU1Pc0FoTXVmRHVRYlRwTjYvdXR4NTk0?=
 =?utf-8?B?Y0pmdGFmdnlJaklLVUhRN3hxdG5EQjlSTmVUS1lCYTJnWG9oYWtUSVVCMmtX?=
 =?utf-8?B?MkxJdEpGOXExVU1Wbm8xOGh2dzRlK2tZNmV2N0xsdlVRc2MzWVBBKzNFVkJ1?=
 =?utf-8?B?YjkxUStQa3orMGpiVVhYOFZSWU84YlZvekhqb3FjRDQwUURJcUgyR1ZOWnVH?=
 =?utf-8?B?TVgrdHkwenVCYWpDdnVML0pUU1IvQTBBdGlUY3d4ZnVsU0xtRm0vK3M1Rlpv?=
 =?utf-8?B?dlBZWmpMY0pTSzU5UmRyTGZYSlFsOW9QdmJSL1hoQ2dWRzhFUllQTzB5WGhx?=
 =?utf-8?B?R2VZcFpjb3BqbjVrZzg5WUUrMk5LRUd4MkxhSVpJTnplT3BVcnA5WHQ1N29X?=
 =?utf-8?B?SkltL3ZhY3U1SGZLUndmZFY0TmVxUExrYlVJdmg0RFJKOHcwNkY0Wkx5dVVp?=
 =?utf-8?B?L0xhdjBjMEJRSmphZHY3dVREWVlla01TZkxsanV1RHpVSXRuY1o1Z1hQTFNk?=
 =?utf-8?B?cjZHMkRpS0ZzaFY0bmpVMWl3S0lOVlBIUmF2SG9tZ3VlNER5TjBhNk5PalF1?=
 =?utf-8?B?bGI1WFdtL095bmVwc3A4M1pxS3FFdUx0VVF0bEt2ZVhlcEpmOFFhQ1FYVVFw?=
 =?utf-8?Q?scr3ct12flAaMXWhiq1c?=
X-OriginatorOrg: sct-15-20-8534-15-msonline-outlook-c9a3c.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: a9e0179c-3a65-4d65-ed6a-08ddded24d69
X-MS-Exchange-CrossTenant-AuthSource: TY1PPFCDFFFA68A.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2025 03:41:38.3693
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYSPR02MB7782


On 8/8/2025 6:19 PM, zhouquan@iscas.ac.cn wrote:
> From: Quan Zhou <zhouquan@iscas.ac.cn>
>
> The KVM RISC-V allows Zicbop extension for Guest/VM
> so add them to get-reg-list test.
>
> Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> ---
>   tools/testing/selftests/kvm/riscv/get-reg-list.c | 13 +++++++++++++
>   1 file changed, 13 insertions(+)
Reviewed-by: Nutty Liu <nutty.liu@hotmail.com>

Thanks,
Nutty

