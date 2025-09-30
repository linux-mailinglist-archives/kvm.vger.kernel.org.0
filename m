Return-Path: <kvm+bounces-59123-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 70354BAC04C
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 10:25:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1AD4316CC4B
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 08:25:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BC442765C3;
	Tue, 30 Sep 2025 08:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b="bZjVaN/V"
X-Original-To: kvm@vger.kernel.org
Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazolkn19013082.outbound.protection.outlook.com [52.103.74.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 974E6255F27;
	Tue, 30 Sep 2025 08:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.74.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759220738; cv=fail; b=kovwNS9CHNtq327wTSpUHSRVPcRcWAhAg76lM7DFr3yaawpGM/y4WZpgvCcQEVq8p6RRrA0AsW9j4AKzQ0DOUL+wQ+IhVp3UU+J1wDVHijbfVbkL3pC/KQHtDZZaQQZJPaD8T0kFnmLyGrNBLvv23YEYbWvoYtUS5tIrt+jvUYs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759220738; c=relaxed/simple;
	bh=hCk8MIfP9JqtJRvC8H5NJIiV2Rb6lwc0nfy1FilBZSo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qPY4AZ0PsbV8nX5EiA7RWZ8A5aUazIcjfW8H+S+C085mWMMfj/agZ2VG0W7/8eHPMzlLutUfPLqzl2Tozbv4jxQIg1Z07qWe4CZOpQtuj2cah29SYi60uDvXlf11GmCPX6xYda2b/8CAWtysmFbsuyUUhgQRpcV4+1WFaftVabU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com; spf=pass smtp.mailfrom=hotmail.com; dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b=bZjVaN/V; arc=fail smtp.client-ip=52.103.74.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s+sGYKLtUHOVxHYhYVNS5o9mJ2YfpzJN7VDfpymhdj8ikssGjDychbbl7njHeXW6dLCy35JzPDDRCxl9dusOkfUmXzxPD38yczgMq/CTDQCDL8qj8BZBBwywN+4rKldyel+C/ds45ryVeVUk4AvSGt3qoUnCnbJFmA8gq6tJfYIpCHfiHkAqDNmqIONBFJWAj4AG4QgQbJE79YJsqS982GsBqwgkHFuXUyWHJOR3oBW2bJQsaMs+j2ChNXyrNZPCHHLI2wBRGAoV+cW9UPiKA6HnTQ0Szoa99gFg9P8EKCmUYfJDXosRdoqrz662LX6nIlVLWo7YcJBc4meiQxakcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l9f5BewTscpZDFVos48CwY6vXY4BwieARbVqyrBhWe4=;
 b=xOJ0f45weMp0CM9F/CWcAWqN72ydsfywQKFDuuC9dNsmTVif6vAMcMYUNYLnSQuhE+Pbv196U7CbW3fovWia7XoY2LPrFuyzrlZsezYme4SkRHVI1ELmO7ALM1ljVPVvO4TXzqPNFUlfiaeaqVebSRkcdvSLzDvqqn53pUYekTaFtNtbRCzu1m3kxBtOePtwgW1OUPJwrR0inbV0BHfk79pt3u4Az5xBo3V0GP8gGMLq9zFoURnxpurppeHKP6nO/D3bG0Cr0DjL7GAqtBxyAPOWbjweFJDg9r4qm8G/6rsQRMK48rK0LDzfR+0H8X8/CQiFNJlhN3ny2HsQsraqzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l9f5BewTscpZDFVos48CwY6vXY4BwieARbVqyrBhWe4=;
 b=bZjVaN/VcLzl/hawldoW4Ck24+FJpCjVku0fpZyqUo8GFdzkC3knoWvpk/BroxQnzEqeKWKeAyx5wVb7+HfaxW38UaOe/IGTwf7Ws1vXkdQnG18YA+lIEUgzn6o97+yR96SUiqd1bRHiOCqdaeJIaai6YRi31Z+Fe2dXixPlwwyfyYqoUTqBMo5hrVtjSFr/ZhYS3ttnc4C8ahopK5841guND62WMoCyNPEQuHIzaXsp5xk1SuVk70HCMU9Vqw2IDgZUfXNU9BgAhVH+DwgAeIl4hLLNDbxtg8XAhsig3qr49EelEre1jeA+FZX5p4YI8goRCEbdu2CQpk8qFPwK4Q==
Received: from TY1PPFCDFFFA68A.apcprd02.prod.outlook.com (2603:1096:408::966)
 by SEYPR02MB7297.apcprd02.prod.outlook.com (2603:1096:101:1d3::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.17; Tue, 30 Sep
 2025 08:25:28 +0000
Received: from TY1PPFCDFFFA68A.apcprd02.prod.outlook.com
 ([fe80::209a:b4cd:540:c5da]) by TY1PPFCDFFFA68A.apcprd02.prod.outlook.com
 ([fe80::209a:b4cd:540:c5da%6]) with mapi id 15.20.9094.021; Tue, 30 Sep 2025
 08:25:28 +0000
Message-ID:
 <TY1PPFCDFFFA68AD67F6ABDD2F9F9644526F31AA@TY1PPFCDFFFA68A.apcprd02.prod.outlook.com>
Date: Tue, 30 Sep 2025 16:25:13 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 01/18] genirq/msi: Provide DOMAIN_BUS_MSI_REMAP
To: Andrew Jones <ajones@ventanamicro.com>, iommu@lists.linux.dev,
 kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: jgg@nvidia.com, zong.li@sifive.com, tjeznach@rivosinc.com,
 joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, anup@brainfault.org,
 atish.patra@linux.dev, tglx@linutronix.de, alex.williamson@redhat.com,
 paul.walmsley@sifive.com, palmer@dabbelt.com, alex@ghiti.fr
References: <20250920203851.2205115-20-ajones@ventanamicro.com>
 <20250920203851.2205115-21-ajones@ventanamicro.com>
Content-Language: en-US
From: "Nutty.Liu" <nutty.liu@hotmail.com>
In-Reply-To: <20250920203851.2205115-21-ajones@ventanamicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYWPR01CA0047.jpnprd01.prod.outlook.com
 (2603:1096:400:17f::12) To TY1PPFCDFFFA68A.apcprd02.prod.outlook.com
 (2603:1096:408::966)
X-Microsoft-Original-Message-ID:
 <b95833c2-a288-4782-be5b-0ae5275d8c38@hotmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TY1PPFCDFFFA68A:EE_|SEYPR02MB7297:EE_
X-MS-Office365-Filtering-Correlation-Id: feea81ee-0c04-4158-1240-08ddfffae955
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|5072599009|461199028|23021999003|6090799003|15080799012|19110799012|8060799015|37102599003|440099028|40105399003|3412199025|19111999003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?K3htU3lUSXZxUUZLemNsK1VQMDlVZzJOMmNrZnl3M1ZQQk1wb0lLZWV0SlZx?=
 =?utf-8?B?MUVKdFQ0Z3NKREpXZVE2YXEzS3VuUzFkRDk3SitNY0NVNUU1NHZLQXF6ejNR?=
 =?utf-8?B?TkVVaXhEOHJYU0ZzOHQ4aTlpMEJhbjRmQVBlWFJLUEdaR3UvQ29QZCtNRkpH?=
 =?utf-8?B?MVVpeDZFV0MxZ2tKSDFKUnROdCtRZ1JSblZhaGdaZDhGVXI5SFE1TndOOUdE?=
 =?utf-8?B?R0djeGRJMTJJM3E4UTRXcVh0akp1NkZJT2N1d0JienNrVFdNcDVMZi9VcEFL?=
 =?utf-8?B?czgraUhtclF1dlVZejErZ1NDL0lhbFRPK3pvWUE4b3ltNmMvcTBWT3dhV3pB?=
 =?utf-8?B?L1AvR0hqYzd2Wkk0dDlObmpWQmFIK2duRVFRUi82OVA4RTFIdlM2dmY2WmJ3?=
 =?utf-8?B?cmh5MTdnSzA1b0x2R1hMcGdxYldmV0h1SUZjcGRoMEMzckt4QTVGOFUvUkNJ?=
 =?utf-8?B?bUpTbWxmLzFsejRUZVlyN0hWVHkydVdnQkxJd0VNVUlZZ2VZUEZyQnBXVHBi?=
 =?utf-8?B?WVhWODM3a3Z4cVQ2anR6MnRjSG11ME04TjQxaE92aFlXaGtEMndHZ2l2ZXpX?=
 =?utf-8?B?UU0rSm5vS3Ywb3J3NVNQL1E0RkNwbEVidCtVQ0RwMTNzck42Q1BrRGEyQjJN?=
 =?utf-8?B?ZWloY2tKUjNDZVZMS2dJS3VxcVh2Wm1EdG11SHVCU2ZtY0cxOUZqTUxWVW8v?=
 =?utf-8?B?SHZqbHp1NVdwTTFiNTJmcmxpOGNWOWhrbmorajNrT0VZc1BVQlhEVTU3UTds?=
 =?utf-8?B?UlQ5MmlycGZ0dnhOLzVvNm51eGVURWMreU10ajhycndqVnZzcDZVcHRnem16?=
 =?utf-8?B?QmNTaW9CYWFDMkcvTzEybllqL29FNnhSV3F4N3FGbjM5bFRhejV5TmxOTzdG?=
 =?utf-8?B?bERJTmI2ang1OGNWdkJGRHAxaUlrQnZTT2tPRCt6MFRZVmhiT3o0UHhMZ0J1?=
 =?utf-8?B?aDBiOE9Ebi9vQ0NDcEFTQVp3QkVFbHpZUFQ4VzRydHAyVmhURDJ0bm1ZKzJz?=
 =?utf-8?B?Ni9xcEk4b1IvYzhYeS9YUXRqaE5SWXRWMXNzbE5xY3dxdlRIeGR4L3hJR0dj?=
 =?utf-8?B?Mk1kdmd0S1FwdkN1SzJtOURLUjgzOFVqeGNnVGo0Nmd6MGYzVC9ybUl5STUw?=
 =?utf-8?B?aWJOMzFZWUM1UXJWWmJZeGx1aHpqdjlyTlBoZGxDb3IrbEZIMnhlbU50OEdV?=
 =?utf-8?B?N1RHTGlIS2RtOW02Sy9zdHl3ellCajJMcDMzdzVDWXphK3dRZm01NW9pR1VC?=
 =?utf-8?B?TGkyaEVONFVsTnc4SzM2ajd4MnVsOWZFQ2lkOVZ0bDc0MTlyR1Nhd1dXVlFC?=
 =?utf-8?B?VW5LbGp5TkZQLzM3NGJ1TTBpb3BHMFNNeHZCNHpQZC84MERManJFTVM4RmNF?=
 =?utf-8?B?bGJOb21QZ0NCb1Q1ZkhZZzg2VXVBZStid2ZwRjlCTC9zZ29tVVJ5RVl4OUcw?=
 =?utf-8?B?L084MDVyditOczlPcUVIUi8xeWh1enhFbkxiN1Z0U0hTZDN2UUpDUUdod3JN?=
 =?utf-8?B?bk5XK2tlVmI3dnJzakJjL1EydmY4WHBKVEZTTzc1NkZJcTl6QXRsYVR1UW5s?=
 =?utf-8?B?enRyK1dub1FFakVOZnVLOElrY1hzWjFURG9FMmxNVGx5Q0NqZ2lWNjFzU1Zu?=
 =?utf-8?Q?EijI/PWRzySZTn9A/K4BYg8ytkTdmGjNFVbaNakejdN4=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZFpEK241d1ZBVFJQUnlKMG42U2IwRC8yN0hFbUNNSHp1dTNDcmJtRW1FeDNq?=
 =?utf-8?B?b0N3OTNDbjdoMUtENXJaMzkwUXVub2FlbGV2M2VnWVUyZWlVRFdFWHAwQmNr?=
 =?utf-8?B?OTlxZ0ppS2xRTERWRWRBbmpnazByMkRSWGh5RTdyMEQ0U1p2NzhlN3FncmFW?=
 =?utf-8?B?RlFva3VNL0RmYnk3UnlOWmVCTUNOSDJuZzdNT1UrK3N6eHhDV2NPV2piZGJ6?=
 =?utf-8?B?dUJOM3Z1RFFzazFLVEZiQkpBUzVrNmJyZmxqdXd1STl6by9NL2NBbVJ6dUs2?=
 =?utf-8?B?Z3lGTXVMVlVBTmVzOHdSbU1zV3NSOUNPUWtIdmtkaXQvODVTQU1aSDhYRmY3?=
 =?utf-8?B?b1hHQlNYMll6TUIvV3d6ZEZXVUdZRkhEbDlkYnlMdDZ3ZEpPeWpaeGVVV1lP?=
 =?utf-8?B?M09YVUhLV2RucTdMc3Fod1d6L1JpTXBlc0ViMDgwRTdSV1kzUWI2TjA0QzhZ?=
 =?utf-8?B?MGxEYUIvNkczakZZMEIvTnZxYUp1RmM5WGpyOFZaaSthamo0NGF4TmhiQ05H?=
 =?utf-8?B?WXAwRjlWYVRuTlV2VDVDRHQrcGo3QXhacHZNMXF0dERxVHExWHRTM3BiNmZB?=
 =?utf-8?B?WGQ5UGJqTGM0Y1FsS3RzaXdsellQZWhVUE43TllHZklyU0xwMmVGZk9oN1FN?=
 =?utf-8?B?SlhyMHhoRmdjOUIrZFVRSHpOYWxaZks2VmZFbzhxeHJFeFhuZlhEUHNNSitD?=
 =?utf-8?B?dEFlOU5Jc2YxQ3orQ1hIbkluUEI4MEFOQldXK2Z3WGdRbEh0RGhzL0lvazVG?=
 =?utf-8?B?R2EzTlQ1YUFrQkdkblZVRjg3cGhqRENaY0NLK2FaRS90MzdVMmtGMHR6cjVH?=
 =?utf-8?B?b2hIOXh0UW54YTNYWjNPczNYZVR2ZnBVZmtra0s0Q2s5NGtqUU5sQ1g1L1Mw?=
 =?utf-8?B?bi9iVXQyamEzWm42SG5TVmw2TnpYR2FTYnFZRGJmYjErMi95ZUVzM1FDdHR0?=
 =?utf-8?B?dm1xVGsxWXFDOE8ydWowWTR3NThYUSt4eHVHQUw4Qm1ZS1FJdm9rREZsNnJz?=
 =?utf-8?B?TCtUaCtzU3JzdG9zbHU5M0lLTnNtVWI3NFJyaGhCRlZjU2hjdCtxZWYrL1Qz?=
 =?utf-8?B?bmdFQ2ZudzY4SG1VUjRaeFIzMEtNWjdpK0w2Z3ltTElpNTVEeS9BRTNKMmtw?=
 =?utf-8?B?a2FGRndUUnFsOFYyQW5DNFg2NHB2ajhITkFJUkkxLzlxWmFMNWRrMlhFajJZ?=
 =?utf-8?B?TlZFSHBoT21xUUxQaENxVmMyM0VYZE55aWlvNGhrVE1wUEI0K253SURLYlV6?=
 =?utf-8?B?RUtZcTJzMXlIM3FyRTBHRmh2SDVnQnBJZTI3WXZib0dXelNHRDNJYUQ0UkZZ?=
 =?utf-8?B?MEhSeEx6cWVlOHJpd2VOUnJ1R2tLbml3eU5zTVJjUDlBZ3Yxb2R0eEdZRWgx?=
 =?utf-8?B?a3Uwbk9SVm9raTV2TEtVUFl4Z1I1bU8zZEhEVS9pR3JZUHFGbVBDcWt3bUlW?=
 =?utf-8?B?QmRkdnk4dE1NWWZyTTJxNTRxNEFpWHNiRnZTSUFFbGhKK3hYUDZlRUpPNGsx?=
 =?utf-8?B?L0xQQ0pSU0wxZlo1VkxyNWZ4ZHlkNWNubjFZdDhidEJtRnkzaEZST2lZNjBv?=
 =?utf-8?B?eEtQdk5HaDFQSk5Qc2hLQkVBT3dSQVVHbFJ4aHZrVXBuenVYOTNQVmtBUzQr?=
 =?utf-8?Q?ich3z2rmg9ob09PZuiRONJCGPO26m0pNoIgSF7uCdr84=3D?=
X-OriginatorOrg: sct-15-20-9115-0-msonline-outlook-a092a.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: feea81ee-0c04-4158-1240-08ddfffae955
X-MS-Exchange-CrossTenant-AuthSource: TY1PPFCDFFFA68A.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2025 08:25:28.3059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR02MB7297

On 9/21/2025 4:38 AM, Andrew Jones wrote:
> Provide a domain bus token for the upcoming support for the RISC-V
> IOMMU interrupt remapping domain, which needs to be distinguished
> from NEXUS domains. The new token name is generic, as the only
> information that needs to be conveyed is that the IRQ domain will
> remap MSIs, i.e. there's nothing RISC-V specific to convey.
>
> Since the MSI_REMAP domain implements init_dev_msi_info() with
> msi_parent_init_dev_msi_info(), which makes 'domain' point to
> the NEXUS domain, while keeping 'msi_parent_domain' pointing to
> itself, there's nothing to do in msi-lib to add support except
> to accept the token.
>
> Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
> ---
>   drivers/irqchip/irq-msi-lib.c  | 8 ++++----
>   include/linux/irqdomain_defs.h | 1 +
>   2 files changed, 5 insertions(+), 4 deletions(-)
Reviewed-by: Nutty Liu <nutty.liu@hotmail.com>

Thanks,
Nutty

