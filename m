Return-Path: <kvm+bounces-58935-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3036BBA6D9C
	for <lists+kvm@lfdr.de>; Sun, 28 Sep 2025 11:30:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CD72117D721
	for <lists+kvm@lfdr.de>; Sun, 28 Sep 2025 09:30:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABD672D8DDF;
	Sun, 28 Sep 2025 09:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b="m15ZrRW2"
X-Original-To: kvm@vger.kernel.org
Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazolkn19012056.outbound.protection.outlook.com [52.103.66.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53A72C21DD;
	Sun, 28 Sep 2025 09:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.66.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759051845; cv=fail; b=uP64n99jTuz8xw5MrgzFZs6QYI6jD+arsJe+jho1351YbPzbfHXDyxg+PxPSLjEJ7C60fEF/pXHbg+fQtp+S1yZqIhgHzf26brE8iLbNSE1KEDFAkVu/0coLSz52OC/M/z4PCyBHY+uFj8DXNyVDoDH54/lQaXY+hFhlIPXWWY8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759051845; c=relaxed/simple;
	bh=2wMFseewNWA8Yg2lRDrytXUzQsYg2EbA5JdVHIgxhVw=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ERspcMlveqFqj5zBTKR49uHRiZgGjLAHEMnrnaym0t+6V9H4g/REv2Z4RYwZCuMTKLa6ArH1HnNNTqJ+mOwaNt9/sVNyZWrEvsm353LbS7ibCoAJ35hR2KhoFWSdDGlwwG14BWYEONLsMv73UW4taWYGcVkt5t8xlSICp56Rj/U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com; spf=pass smtp.mailfrom=hotmail.com; dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b=m15ZrRW2; arc=fail smtp.client-ip=52.103.66.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V9xBGoKT19G5/Pp8XnFJSDJXHZQKGWaGSYoJZ0kWZI6XGW/G4NoQ9u1deldg66oTVtsXaVpjE0bsJbabEolv/qO+ayfGoKloUYWLMkV+zq3OzTK1kz9joosFjWHqNDzD3Th/QZ8A5N2qJ5xfD/AlQjdxW9udzs7r3NqCNxojq/5X45F7G0VvgqQq5FVVtYomf0DdNXFKNAVkZH5s+1Him9mhBvX5AIsuHcl2IsGMZZaofFHsMs2OYZK9K8I6Qkx8t51QrM9059GSevk2ceB9RjOpyd280aNLC89pw9e/IwcA/JVuEJXbBOmDeHWe+MUEQmMWRG1jW3+JryG4floz/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TXE45bbZ2O+3AwlteHlZGra4JghQ889bmZ9HPLXlJO8=;
 b=GdZFhfnTUm5SeBhQEso1NYI3DxdTkL/S9sgWM2ZBDt05sV0YhhYl7fgMZY80QAlOv9nzjGtZA9uE9GFuZ4EuczkJ27bF1020Jkj7vgOxHmXsOGcO07m597X4E7EVqD2cnT7FXCfz10VR3Pm9aEOzGXyaFYbnMfdP86R0uT8UEG+Dp6EWBqIe9UD25jEw131WOt89QtkREcSXEzguzjOPa31hkcLJVYX7TwEwKKlt5HyUuRrqAsecjrwm5JUb5kxvwBSp50zGkCF/mDbaM1r/0/6mwn5A9o9MP5c9Wksco1Ot9G/GH2U+UM7GzneEoGTYG/lxjgDL7Moo0WavKRPcQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TXE45bbZ2O+3AwlteHlZGra4JghQ889bmZ9HPLXlJO8=;
 b=m15ZrRW2rkgO1h27kK9ujZS7CVxSdBZPt0uUJcrzWBM4najI6CtB0ODGZ62ZZuvGlQFisLonepXDHIzb4Kzr6GlzOL3hXqwrKZmTejjNMLzQiTMGYjvn4I3OdHy0/1bDnz44IvEn2xhLYjLxvkzK75rXWFS+/xKF4MslN+HDbhZOOA3QaOmURFHZHZSspXegueBNv+Cpx/ESZPWxSYEntDHQN+DPCfj5yQM2gErguHonx2exy7zvqkJAUIXYHJ0AFEfiz5X1L1pr26y5rBRaJdJPRZZfk4jmHOKUC3VL0c3Ath4noXLE3rZYGV7nXu9u2nz9rTTjuo6romJs27iOWA==
Received: from TY1PPFCDFFFA68A.apcprd02.prod.outlook.com (2603:1096:408::966)
 by SI1PPF7CE38F105.apcprd02.prod.outlook.com (2603:1096:f:fff6::759) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.21; Sun, 28 Sep
 2025 09:30:33 +0000
Received: from TY1PPFCDFFFA68A.apcprd02.prod.outlook.com
 ([fe80::209a:b4cd:540:c5da]) by TY1PPFCDFFFA68A.apcprd02.prod.outlook.com
 ([fe80::209a:b4cd:540:c5da%6]) with mapi id 15.20.9094.021; Sun, 28 Sep 2025
 09:30:33 +0000
Message-ID:
 <TY1PPFCDFFFA68A1C49C083357FF49575AEF318A@TY1PPFCDFFFA68A.apcprd02.prod.outlook.com>
Date: Sun, 28 Sep 2025 17:30:26 +0800
User-Agent: Mozilla Thunderbird
From: "Nutty.Liu" <nutty.liu@hotmail.com>
Subject: Re: [RFC PATCH v2 04/18] iommu/riscv: Add IRQ domain for interrupt
 remapping
To: Andrew Jones <ajones@ventanamicro.com>, iommu@lists.linux.dev,
 kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: jgg@nvidia.com, zong.li@sifive.com, tjeznach@rivosinc.com,
 joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, anup@brainfault.org,
 atish.patra@linux.dev, tglx@linutronix.de, alex.williamson@redhat.com,
 paul.walmsley@sifive.com, palmer@dabbelt.com, alex@ghiti.fr
References: <20250920203851.2205115-20-ajones@ventanamicro.com>
 <20250920203851.2205115-24-ajones@ventanamicro.com>
Content-Language: en-US
In-Reply-To: <20250920203851.2205115-24-ajones@ventanamicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR04CA0018.apcprd04.prod.outlook.com
 (2603:1096:4:197::9) To TY1PPFCDFFFA68A.apcprd02.prod.outlook.com
 (2603:1096:408::966)
X-Microsoft-Original-Message-ID:
 <0be8b7c6-bfa0-4be4-a3ce-c819882bea77@hotmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TY1PPFCDFFFA68A:EE_|SI1PPF7CE38F105:EE_
X-MS-Office365-Filtering-Correlation-Id: 7fb86983-5042-4bea-6e60-08ddfe71ac30
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|41001999006|23021999003|8060799015|12121999013|6090799003|5072599009|19110799012|461199028|37102599003|15080799012|3412199025|40105399003|440099028|19111999003|12091999003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YWRNTmJuTk5PdzJhc1pIMm1MN0cwTFZxT1NUVkFPTy9HNjVKajhwMUpLa21Y?=
 =?utf-8?B?YlNXWGhOZEtldnQ1TTFWV1h1aHQxQTR5U2s2cldWMGl0a2hsN3ljQXc3UlV4?=
 =?utf-8?B?bkx5a0hUVHdmWGE2Q3lBaEEwM1ozUXdXbGlWNG9aaVpmL01VMnBuOG1kNzJ2?=
 =?utf-8?B?USs1dkl1ajNYRDdHRFJydXBYcEZ2RFNkdUNhMXpmTzBhT0sxQWhoaXlheHJz?=
 =?utf-8?B?c1JxNDVES1NCR3dQNVFwTHo2cVVkbkU3MGtGckZOVEhwbWU3ODhLaXR0cTZt?=
 =?utf-8?B?ZkMvSTQ2NnljcVNhTDZoZVZibW9tNHk2TDN2Z0VONDZNODlyRm5xQjFlaGJC?=
 =?utf-8?B?dzhGQ1ZEUkEvYmxoRkhXaHRDM0hpcTdocGl0MWJtVHpqdFFmWVJsWlh1Mnh5?=
 =?utf-8?B?VXBjREVPQkFOWlZ4bjB5UlQzK0IvVjYwSUR5R0tmQmM4aEhKY2J2U1JrbFZ3?=
 =?utf-8?B?bXY5Z1c3dE5iK0kxY1hVTjRnZnZqT3RnRW9hRmJzbzNpWVZoVXVwT0dFcnFN?=
 =?utf-8?B?YkFkZVVuRTdtVFlObXRaMGJiamxiWlRPZXZrc3FPaXRxWThhS2RYMmFQQkVk?=
 =?utf-8?B?Ynl5SCtEVUpadGM2QXNZQU9KVzlsNzM1c2ZpOFZ5dWtUVzRoL3I2UjI4bkF1?=
 =?utf-8?B?TzhySTRncEh5eE5SNGVENW5IRWJBQ0NmK1g3OE5yTDNGSmp4K0pFMWg3Y1Vi?=
 =?utf-8?B?bUpxZjN5dW1NbDlBN3kzNlloNklTSndOT3pLRW5kbFhIRk96U1daOGd5NU1k?=
 =?utf-8?B?UEVHL2J2dzc0TWZJR2pUdVppN2I5dS9GOFRaUFBHSmJXN2F3R2NWMlZQZWJa?=
 =?utf-8?B?bW4zMC90YmI2eDR6L2h6UzlWY2REYmhHSmJ0b2ZPZVpHRFloT1lwcGVGL2ZM?=
 =?utf-8?B?RkZYN2hkK0ZOMzRyeUNVMndXblhrNlJwdjNJWlBWM3dTQ0hWZXJxUHRyQ096?=
 =?utf-8?B?UFVyVFlua1p2UXFCS01ucENMVFNaMmZaVWFIc1VHdmoxd1E2UmpDR3BjOXQr?=
 =?utf-8?B?cnZPYVllQVRrSTNOT2FnejRGazZOK2FLVFdpZjhvUXBwcHQzcWhtejJwdTB4?=
 =?utf-8?B?UUNTbHlUWm9rZlhueXZDR2w5bW1DWWU4aG45MktyUlBtYkxzMHYrMzJYQWVF?=
 =?utf-8?B?OFdFL2hqd3doSWNhUHR0SjRDU2F6VlVyWHdLVWZ2eXZxdGpKenNSOSsyTHJ6?=
 =?utf-8?B?ZXAzWE15SlZDOGtBeWdMMmJjbjZyL2ZVcnN2OGw1QkRLRDh5VWQzNUlscDFy?=
 =?utf-8?B?aDVEK2x5RDN0SWJPaDZ3TWplbXdCaTZkTXQrRGRYRHNQWnlVWTd0NHY5OUFh?=
 =?utf-8?B?cDRIVFhTSVdVazF2YTIzNXlwZnhsUVBoc0hjdDd6eWpWSkhpYjFwSTdvL1Vi?=
 =?utf-8?B?TXVwQUZxL05haHpRRFhYdXc4Qk5GSEJROWpQMTJNS1ZJTE1WWWdWOVZEY2Jz?=
 =?utf-8?B?bFQ3WlBNSDhDOGhBNFBNMkZCb0htcTF0bFJOQy96SnkvVHMzTERMTHVHVTc1?=
 =?utf-8?B?Y2dPWXJFYThOam15Sk1XUTZjdGFGMkwrYTl1Rkx1YTNoc3JoNXVvRkdFWTcv?=
 =?utf-8?B?UFF5S1FvRnJoaldSZ3liaENYM2I2VC9SYmVNcWZwTDRiSExrcmtDZVEyaFlp?=
 =?utf-8?B?ejZsSCtreFI2UERqK3ArUEgxeW5iRlNqQWltMGZraUJJMXVVOXNtOTl1blI1?=
 =?utf-8?B?Qi9nRDh5d0t6ZCtORDFmRjI2Smd5NjVsMnhpM0pheGdzdXpmQnNCWjA1UXA2?=
 =?utf-8?B?ZXdPN1JxcGQ1VDUyeS9jbXd4UUNEM0YweHhSZldDWW9XT3JYYWxCRERueFl2?=
 =?utf-8?B?d090MDk3amNRQkhESDg3dz09?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SFpzWExIdUtsK2lmNFNJS0hRc01wb1lvVTE5c3pUQTJmSllreExrSDEvTDZi?=
 =?utf-8?B?UHRjTTZvcVBFcEllRnVIOC8vSWpzZG1LYUxCTkhNS0FxenI4Q1hxVXFHMjJR?=
 =?utf-8?B?cFNTSTJkT3dQUUJNVFozZHp0THVjWWlRUWdlazJMQ2RsYjBNbUw4WGVkSDFD?=
 =?utf-8?B?K29nQ1JxSFYySFNqdk0xVFJhSmUwS05zREdRUC93WVlPYXg3NzY2czlqaVpH?=
 =?utf-8?B?aHFDeXJDM2E5dUErdWFHeFVTT0d1T1Nqb2d2T09jYWEzK3N5K1ovZU9JOXVl?=
 =?utf-8?B?S0VGc0huZ2l2ajJISUh6ZjZBMm9qVmlrZUgrcnBQVkMyZkNMVW4xc0Zqak1v?=
 =?utf-8?B?MloxQWdHOXFSdXNLb0lMQnJGUTJUQ2ZwSU9wNWhUSzJINjNkVE93dmw2UkpC?=
 =?utf-8?B?YnZPTnhiM1U2eTJWR2FScU9rK25CM2UveCtzRTNweSsrMnFkZFRUckozNm5F?=
 =?utf-8?B?dHMwMzl5TGtTL3lIR1Q4eHpnOVdSZ1lpWDFGTFhDUitRbkhQVnZ1c3dMRndS?=
 =?utf-8?B?ejlIR1p6VVpNWnY5YmlVem5YMFZ5cjJoMWtrMm5QeGJTampLSWtBUlpjcEky?=
 =?utf-8?B?YzFUTmtLVnpyT2ZNaDBBVHRUS3BxQjRVTlZxV0NHMkpKUzBGZzRQL0drbk1R?=
 =?utf-8?B?eTdKMzZ4NXl5akxSbG1WdTZvSVJjbHFUZTRBQ2wxNnNIV3F2Vm1sd1pmcFg2?=
 =?utf-8?B?ZVpjRjRLYzFabkVBRnVZM2RaTndqN2JJeG1haCtmek05SWRiaDZYYUxrbG95?=
 =?utf-8?B?cmYvL3FDTVlCWEdXSnkzazMwb2tDMnJscDVEc2FYT3grSXpvR2tUb001T1Yx?=
 =?utf-8?B?YkRIOWdBZnpqaXBESVh1WlA3SlNPOFd4UGdOSWdaaDJONmRlNjhnUmhiTkZj?=
 =?utf-8?B?ZmFPbmRUU3dnZVlacUg4b3JlN2IwRFRhTmxjbmVvOHRmaURCSEhuYm1mblk4?=
 =?utf-8?B?UVhLaTZldnFGSUl4a1VTdW8vRWFwaGF2aGJDSm1adklaNFJVMXZOeVluM2FP?=
 =?utf-8?B?clNWUVk3OWE2Tk92Rjc2dW9PbG1IN0xpaGNabXdMWk01WU0zNjZVRWtwOXk5?=
 =?utf-8?B?MXBVRVRhTzVxbmdCbnJmdForNUdzd3ErRGptRkxxa3Rya2tucVZNMi9NWFRS?=
 =?utf-8?B?R0FhOXlvMDJVeVYvWm5QdWdHVjM5VXMwekhsbEY0NU1rRTFhQ0ppL1dIbXMz?=
 =?utf-8?B?QXVMWUoxNlF2L3F6Z2NtV1hTT3Vmb0MrZDI4aFk1UFZFZ3ZVWGFJZ0llZ0tD?=
 =?utf-8?B?UHJEYUkwWlF1M2tXRE92MHNvckxTNTZGUWlIbEV6ZnFBSEV5Wk1vLzUyQStn?=
 =?utf-8?B?dDJ4ZDdydnQzVWRuWU15V1hKZzN3ZUZOSHBialBTSUhjOFc3L1BkLzZNRUV1?=
 =?utf-8?B?dHhvOEo3TzF4a3Bzd0NKTWN6VTVGL1pFd1lVeDlmN0hlNkM0UlJWL3EyKzBi?=
 =?utf-8?B?RTA5VDFhc2MwdW5vVUNYc215TkdGeVVTTmgyMlI2aE9qVnZwS2FURjF2U1Ew?=
 =?utf-8?B?Z3RwYmx1bWxPOGsvRG5iTFYxMmFRMHAyMnBlcE9vQ2hkNUpIME9lTnA1NUE5?=
 =?utf-8?B?YkVWbkIzZTFoRG5WL2x3cVJaUnJrTGNDakN6QW4rWVhwcTk4QU9nRFRCMDZa?=
 =?utf-8?Q?VfKaoyYl/rYNYzmOJg4xoB3MS9CLWYSo9FvbpDbN1nF0=3D?=
X-OriginatorOrg: sct-15-20-9115-0-msonline-outlook-a092a.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fb86983-5042-4bea-6e60-08ddfe71ac30
X-MS-Exchange-CrossTenant-AuthSource: TY1PPFCDFFFA68A.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2025 09:30:33.4232
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI1PPF7CE38F105


On 9/21/2025 4:38 AM, Andrew Jones wrote:
> This is just a skeleton. Until irq-set-affinity functions are
> implemented the IRQ domain doesn't serve any purpose.
>
> Signed-off-by: Andrew Jones<ajones@ventanamicro.com>
> ---
>   drivers/iommu/riscv/Makefile   |   2 +-
>   drivers/iommu/riscv/iommu-ir.c | 114 +++++++++++++++++++++++++++++++++
>   drivers/iommu/riscv/iommu.c    |  36 +++++++++++
>   drivers/iommu/riscv/iommu.h    |  12 ++++
>   4 files changed, 163 insertions(+), 1 deletion(-)
>   create mode 100644 drivers/iommu/riscv/iommu-ir.c
>
> diff --git a/drivers/iommu/riscv/Makefile b/drivers/iommu/riscv/Makefile
> index b5929f9f23e6..9c83f877d50f 100644
> --- a/drivers/iommu/riscv/Makefile
> +++ b/drivers/iommu/riscv/Makefile
> @@ -1,3 +1,3 @@
>   # SPDX-License-Identifier: GPL-2.0-only
> -obj-y += iommu.o iommu-platform.o
> +obj-y += iommu.o iommu-ir.o iommu-platform.o
>   obj-$(CONFIG_RISCV_IOMMU_PCI) += iommu-pci.o
> diff --git a/drivers/iommu/riscv/iommu-ir.c b/drivers/iommu/riscv/iommu-ir.c
> new file mode 100644
> index 000000000000..08cf159b587d
> --- /dev/null
> +++ b/drivers/iommu/riscv/iommu-ir.c
> @@ -0,0 +1,114 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * IOMMU Interrupt Remapping
> + *
> + * Copyright © 2025 Ventana Micro Systems Inc.
> + */
> +#include <linux/irqdomain.h>
> +#include <linux/msi.h>
> +
> +#include "iommu.h"
> +
> +static struct irq_chip riscv_iommu_ir_irq_chip = {
> +	.name			= "IOMMU-IR",
> +	.irq_ack		= irq_chip_ack_parent,
> +	.irq_mask		= irq_chip_mask_parent,
> +	.irq_unmask		= irq_chip_unmask_parent,
> +	.irq_set_affinity	= irq_chip_set_affinity_parent,
> +};
> +
> +static int riscv_iommu_ir_irq_domain_alloc_irqs(struct irq_domain *irqdomain,
> +						unsigned int irq_base, unsigned int nr_irqs,
> +						void *arg)
> +{
> +	struct irq_data *data;
> +	int i, ret;
> +
> +	ret = irq_domain_alloc_irqs_parent(irqdomain, irq_base, nr_irqs, arg);
> +	if (ret)
> +		return ret;
> +
> +	for (i = 0; i < nr_irqs; i++) {
> +		data = irq_domain_get_irq_data(irqdomain, irq_base + i);
Nitpick:  Would it be better to check if 'data' is NULL ?

> +		data->chip = &riscv_iommu_ir_irq_chip;
> +	}
> +
> +	return 0;
> +}
> +
> +static const struct irq_domain_ops riscv_iommu_ir_irq_domain_ops = {
> +	.alloc = riscv_iommu_ir_irq_domain_alloc_irqs,
> +	.free = irq_domain_free_irqs_parent,
> +};
> +
> +static const struct msi_parent_ops riscv_iommu_ir_msi_parent_ops = {
> +	.prefix			= "IR-",
> +	.supported_flags	= MSI_GENERIC_FLAGS_MASK |
> +				  MSI_FLAG_PCI_MSIX,
> +	.required_flags		= MSI_FLAG_USE_DEF_DOM_OPS |
> +				  MSI_FLAG_USE_DEF_CHIP_OPS |
> +				  MSI_FLAG_PCI_MSI_MASK_PARENT,
> +	.chip_flags		= MSI_CHIP_FLAG_SET_ACK,
> +	.init_dev_msi_info	= msi_parent_init_dev_msi_info,
> +};
> +
> +struct irq_domain *riscv_iommu_ir_irq_domain_create(struct riscv_iommu_device *iommu,
> +						    struct device *dev,
> +						    struct riscv_iommu_info *info)
> +{
> +	struct irq_domain *irqparent = dev_get_msi_domain(dev);
> +	struct irq_domain *irqdomain;
> +	struct fwnode_handle *fn;
> +	char *fwname;
> +
> +	fwname = kasprintf(GFP_KERNEL, "IOMMU-IR-%s", dev_name(dev));
> +	if (!fwname)
> +		return NULL;
> +
> +	fn = irq_domain_alloc_named_fwnode(fwname);
> +	kfree(fwname);
> +	if (!fn) {
> +		dev_err(iommu->dev, "Couldn't allocate fwnode\n");
> +		return NULL;
> +	}
> +
> +	irqdomain = irq_domain_create_hierarchy(irqparent, 0, 0, fn,
> +						&riscv_iommu_ir_irq_domain_ops,
> +						info);
> +	if (!irqdomain) {
> +		dev_err(iommu->dev, "Failed to create IOMMU irq domain\n");
> +		irq_domain_free_fwnode(fn);
> +		return NULL;
> +	}
> +
> +	irqdomain->flags |= IRQ_DOMAIN_FLAG_MSI_PARENT;
> +	irqdomain->msi_parent_ops = &riscv_iommu_ir_msi_parent_ops;
> +	irq_domain_update_bus_token(irqdomain, DOMAIN_BUS_MSI_REMAP);
> +
> +	dev_set_msi_domain(dev, irqdomain);
> +
> +	return irqdomain;
> +}
> +
> +void riscv_iommu_ir_irq_domain_remove(struct riscv_iommu_info *info)
> +{
> +	struct fwnode_handle *fn;
> +
> +	if (!info->irqdomain)
> +		return;
> +
> +	fn = info->irqdomain->fwnode;
> +	irq_domain_remove(info->irqdomain);
> +	info->irqdomain = NULL;
> +	irq_domain_free_fwnode(fn);
> +}
> +
> +int riscv_iommu_ir_attach_paging_domain(struct riscv_iommu_domain *domain,
> +					struct device *dev)
> +{
> +	return 0;
> +}
> +
> +void riscv_iommu_ir_free_paging_domain(struct riscv_iommu_domain *domain)
> +{
> +}
> diff --git a/drivers/iommu/riscv/iommu.c b/drivers/iommu/riscv/iommu.c
> index a44c67a848fa..db2acd9dc64b 100644
> --- a/drivers/iommu/riscv/iommu.c
> +++ b/drivers/iommu/riscv/iommu.c
> @@ -17,6 +17,8 @@
>   #include <linux/init.h>
>   #include <linux/iommu.h>
>   #include <linux/iopoll.h>
> +#include <linux/irqchip/riscv-imsic.h>
> +#include <linux/irqdomain.h>
>   #include <linux/kernel.h>
>   #include <linux/pci.h>
>   
> @@ -1026,6 +1028,9 @@ static void riscv_iommu_iodir_update(struct riscv_iommu_device *iommu,
>   
>   		WRITE_ONCE(dc->fsc, new_dc->fsc);
>   		WRITE_ONCE(dc->ta, new_dc->ta & RISCV_IOMMU_PC_TA_PSCID);
> +		WRITE_ONCE(dc->msiptp, new_dc->msiptp);
> +		WRITE_ONCE(dc->msi_addr_mask, new_dc->msi_addr_mask);
> +		WRITE_ONCE(dc->msi_addr_pattern, new_dc->msi_addr_pattern);
Since the MSI page table pointer (msiptp) has been changed,
should all cache entries from this MSI page table need to be invalidated ?

Otherwise,
Reviewed-by: Nutty Liu <nutty.liu@hotmail.com>

Thanks,
Nutty

