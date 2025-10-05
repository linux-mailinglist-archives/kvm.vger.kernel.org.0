Return-Path: <kvm+bounces-59501-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 055C5BB94DC
	for <lists+kvm@lfdr.de>; Sun, 05 Oct 2025 10:43:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 9F4F7345B19
	for <lists+kvm@lfdr.de>; Sun,  5 Oct 2025 08:43:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 127EA207A38;
	Sun,  5 Oct 2025 08:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b="fulXq23/"
X-Original-To: kvm@vger.kernel.org
Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazolkn19012062.outbound.protection.outlook.com [52.103.43.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81F7219539F;
	Sun,  5 Oct 2025 08:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.43.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759653812; cv=fail; b=AdeOduA04cbt5HGUhTSqTuqLqdCPgwuf80rkqnWdj2EDeinzCfZZ697KWXyZXEV0PbYdZjWEbxBmZWnnCWn7seiv6/6LZyWxUyoWFOsCJSrH8vgX6O32KpuzXAaNdWBqsFTLreV1QG7TfpptSGBPLdV8H71i7mfhoT1Y/A2HNOY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759653812; c=relaxed/simple;
	bh=9a/XSZ0Mzg6s1WDXsM65jNHmCsZCRDH/+jF3xXdlewU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gVS45r/15lWsTh8BCRw+z4gwqLnU5FHiK0ty4gPY/mGH0BmGlCn08USC6b84357ZRdtOoajECacOVwBsM6LPQxzeRdsfP/rDnsNaz+yXx6vMce/IVQGIiL3hTmes3PZNm8n/irajT3e0m/AZR04c/ldkAmSzCg9ZQHvIE8D+DQg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com; spf=pass smtp.mailfrom=hotmail.com; dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b=fulXq23/; arc=fail smtp.client-ip=52.103.43.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J0NZc6k9MhWhZ3v/qw/TA299RV2ZAoOYxa9kieX83RBcGbIcVF1oWiNb89QvPSw/YK9BVcK5149I+7R/UDxGpvHl7r41HuquIxSinet+s9ZQ2wvlb/IY71mT8BOel4kdPIiodzGK751PH1reAlkfml5mf8XSEhdFS0pSIkeFzThpGmxKJQeSogeYfQSuIF0kB+NYxVBuFEFhTrw6euaYbzpJGhcAu7KZrc3Z2yrLL7sbghC3l00+X2iOjADeY/cg4HBQRWWsA6CVLphN8ebEfSBK8VP2DsqFk2mx4ojbTt7iUBeueE3n/edkvEJUagIjZ5lP3TiBNGzHcaHysD0FnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PnagC2eD95c83JqbyKwjfhmDSFogNt5AONxCPdaXYhc=;
 b=WrOrAqPLcExRX1w/yH9a07GuDntAbCLTs/hS8DILnahZX7K1otx2XJxWY7Q2gRO7Nx55uvF26X09ixUXaZ1BWQFgjoJygbyV2jRVkta3wUCZZgSltrgBeDOQjhMGe72O+8+5m3paF55JyVY4Jh+TAXnfmciOSprBVH5ZJw3I9w0VjdQRn68QeDkxHzL5NZJyAssok62g13ISxk3jFPuzIvZYqhF8Yn+plvLZapqsTSeIeXvdBMg/MNiV9C53q6oyd4keMks3yYZSRZfmQ/fEdslYpdG1cbW67u4r04nNj2y7azcnM+y44KncVJpZfjDGpK6/t0GIoHKsv2TE86ShXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PnagC2eD95c83JqbyKwjfhmDSFogNt5AONxCPdaXYhc=;
 b=fulXq23/ASsQ0k0fWBbLNHhFk29SAE6/0EFSJS9CAdF3YQdiHUxvMiKJ8gSSDM1tKWj0+lN62LoiJE3GnT8PGRnqargTTPYzIDWKCOZ1wmhhVB8wKXlQLkIJCpoUBdSkNG4Wd+3FzS805AGZGagMoNVHQD3RWlqzIOzmaGObAdG7dlY8va6e7E32Yz40jbo/8ewFkxYSqRanyaWxNGxE/kaw1WAet9DLxsTJe2xpUFyOEHAMTDekaITw/jgO0oGCDlQFYt1Lyg7BelxTpIuh+zkUQuZhxIk3wU0AjL1ydTv08DN5fJaZkYdYhotBLyerAaIhWriftOafrwYpnZl94w==
Received: from KUZPR04MB9265.apcprd04.prod.outlook.com (2603:1096:d10:5a::6)
 by TYPPR04MB8960.apcprd04.prod.outlook.com (2603:1096:405:314::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Sun, 5 Oct
 2025 08:43:23 +0000
Received: from KUZPR04MB9265.apcprd04.prod.outlook.com
 ([fe80::3c38:c065:daf4:cbfa]) by KUZPR04MB9265.apcprd04.prod.outlook.com
 ([fe80::3c38:c065:daf4:cbfa%5]) with mapi id 15.20.9182.017; Sun, 5 Oct 2025
 08:43:23 +0000
Message-ID:
 <KUZPR04MB9265D45020D114BE45DDDAFBF3E2A@KUZPR04MB9265.apcprd04.prod.outlook.com>
Date: Sun, 5 Oct 2025 16:43:15 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 13/18] iommu/riscv: report iommu capabilities
To: Andrew Jones <ajones@ventanamicro.com>, iommu@lists.linux.dev,
 kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: jgg@nvidia.com, zong.li@sifive.com, tjeznach@rivosinc.com,
 joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, anup@brainfault.org,
 atish.patra@linux.dev, tglx@linutronix.de, alex.williamson@redhat.com,
 paul.walmsley@sifive.com, palmer@dabbelt.com, alex@ghiti.fr
References: <20250920203851.2205115-20-ajones@ventanamicro.com>
 <20250920203851.2205115-33-ajones@ventanamicro.com>
Content-Language: en-US
From: "Nutty.Liu" <nutty.liu@hotmail.com>
In-Reply-To: <20250920203851.2205115-33-ajones@ventanamicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYCPR01CA0110.jpnprd01.prod.outlook.com
 (2603:1096:405:4::26) To KUZPR04MB9265.apcprd04.prod.outlook.com
 (2603:1096:d10:5a::6)
X-Microsoft-Original-Message-ID:
 <b7d2a696-8da3-4168-9ca8-220c57de8b97@hotmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KUZPR04MB9265:EE_|TYPPR04MB8960:EE_
X-MS-Office365-Filtering-Correlation-Id: 1861c5d1-0317-45b1-73ce-08de03eb3e98
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|5072599009|15080799012|461199028|6090799003|8060799015|23021999003|37102599003|19110799012|3412199025|40105399003|440099028;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eHo1b05BUlh3TEtzMEtjcUpUQ2grZVRYcHZHYUVTRVQ2eVRwRWcxNHlYLzF2?=
 =?utf-8?B?Vit0UU9wUkovQ1lYQ1NQeHN0dUcxU0VGWHU2UkZDNDlSNklmWG5BQ0tWU2dE?=
 =?utf-8?B?NUxOVVJpUks4b1JmNnhBbkNlUGZpdWFKZ1ZPc2d5T2xxYW1Hd25Ddno5bTdy?=
 =?utf-8?B?TThnQWtUdkN5cTlQNHIrVC85OVJiUjRTWXlKQ1dXZDF3eUZHaUVURVNkbG1l?=
 =?utf-8?B?Z0xKeXJvMTNWVlNXWTc4L3JuWXAwQXpjWlR2NEFaWEd1YWtKRzZaR25RRWlt?=
 =?utf-8?B?ck80SUVkN1pOZDVMbnh0Vi9WMDV0SEkvS3dDZ3V4TWZ3S0dsNkZiNnZYcmhh?=
 =?utf-8?B?WTlYNHRjcG9ZN1NIYlQrdGp4NXFLZ1VMSlpUN29Xdnpsei9rc1Boa2U0UGtX?=
 =?utf-8?B?eXZnVW1INzNGMWJJMENsdVFZcmhwcThxbWFtdTQyMGIwd3NmQ1RySnIwVmox?=
 =?utf-8?B?WHIwNmFDSm03bGtaSFdkdHM0QVJDdjhobHR3ZFVZdmhNT0psVEZZSm9uSXpT?=
 =?utf-8?B?MlZ5K3NaS3I1RDcrZ1o3Zjl5Qy9pOU4zdURxZjYxTWdUZ1g0bUo3aCtzMXJa?=
 =?utf-8?B?WExzbll4aTd5bXFBRllOTnN6cHhpdm1rWkFyUjQySGE4eElwb1MwejFFeHFq?=
 =?utf-8?B?Z2dJdktBc2RGMnJoeXNnWDV3NGVuSHBoL1VxV0NPc3dCY0lNTkFVR2FYT0pr?=
 =?utf-8?B?aDlkMFQybU90bWY0VWhPUVp3UnFidDF1bFFnNDFsRGJ3MkFPdnFINDU2UXJ5?=
 =?utf-8?B?WE9KRFhzS1dHY0xHTWpObUpuQ2VCTmU5UVR2TUEwMzZ3K1BEYXJGRlVwTW54?=
 =?utf-8?B?Z1oyRmZEZGFFMjRBNVN1QUtBMGNTc093UDhmUHRPUXZBbkt4eDFkVG1YS0Nj?=
 =?utf-8?B?aSswWHR1aHg2Tkswci9naGRGTVo3Z3dDbUpPYVNMT3JXeVU1OG12Nk5zTksv?=
 =?utf-8?B?S3dac21EU1F1Z1FRWWlSNC9WS0xrRUdySW9QSTlYN0lROUxCaUF6UEZpS2Y5?=
 =?utf-8?B?SkY0YnZYVlV1bGFxcEl6akM1dlhEcUNTVUZyTlNnK1FhV2RTSnVzMFozdWp2?=
 =?utf-8?B?WHBScy9STkFEWFR0TW0yZ1NpMFkvdTBYUFB1UEsvQ05HcGJBa3lYenA2Ymd2?=
 =?utf-8?B?aEh2YUVncDBZTEJxN011TWNBWmF6aVBHMlNxSlBrTld1ZnlHUE5ieDdTeks0?=
 =?utf-8?B?SURWUHBrbWVRRDRpeWsvbmszZ0tzeXFvM1pOZTZyZ2h1cmsxTWZuMDJDUzVH?=
 =?utf-8?B?UzFPYjVoTXBnc0dwNFpPbUdxdEQybE91M2cxUnlIcHFQbHhlblZpaVQ3R3ph?=
 =?utf-8?B?WS9sUjVERVpxckJsNXhNZFJweGRYaHFSR0NaVHJJbno2MURKWnpWWGZZcVhy?=
 =?utf-8?B?NmxxZDVOKzFCMjVicFllbFgzVTZaS3ZBUGEvcVVyYUl1Qkp2NVFtR2NEOUIy?=
 =?utf-8?B?aVlra1Zsb1ZRWFR0dUZKU2NKclJXYWlvY0pPa0EwS1hvOVRLQzhFSHd1RVI5?=
 =?utf-8?B?cGJIcFlBK1pJKzF5ZmUweWdlQlZHaHZjMU83M2dLWnZFckdocUxQc3VHZy9R?=
 =?utf-8?B?VHF0VUVjK2J5c0pPb1FOcTNRckV4dmxxakFVcW5uNzhSV29HM09JYVhjbzZK?=
 =?utf-8?B?SGkvK1RDMUZCNFBDWWVVc0RpaXRIY1E9PQ==?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QlZJNXRwRHhnSjlkZEkyRm9od0NRbEh5TWVMZEdhazBJTy9NSzlCSi9PUDlG?=
 =?utf-8?B?d3NNNWw0UlpRUmtERVhGZ3V1ZXNBZHA5UEFIaHVLaGJFODhSUjVjelQ2Q3dm?=
 =?utf-8?B?VDlqRERtT2YxZHQza0tBQ0ZQRTdjQlY0MVp3aVd2U2xpSFl6VmRuazVsYjQy?=
 =?utf-8?B?SzJaRzRIQ3A2SE9mSE5VU3VNOGVKRmFYR1dEOTMvYlJYYisrYUcwMElHelRZ?=
 =?utf-8?B?RExhSkk1bk5pKzFCUHp4RGlDbmFNYTVyeTMweFVKMy96akhsdWJpQlpIdG5O?=
 =?utf-8?B?SGpKdWtCUFlwUmNXS3FOL3l2UWFJdFRzWG0xZWFEYnBZajhKS0hTdzUxT1hC?=
 =?utf-8?B?M3BuejB3VFN4Qzk0K0UvOUsyS3FwQWdXUnlyZHhUcU5ST21ZeEttQlY5M1ZX?=
 =?utf-8?B?TjNSd1EzaXpuNytJSHp6R3oxODB2Yk1NVCs4K2V0aVJRYkJTd1dtTTkxWThK?=
 =?utf-8?B?VEZGaWhuckp2RGtDVFczdk4rZmdRSWdVczNhekg3Zk1TQVlHRmRUSnRTR0RK?=
 =?utf-8?B?UXJOS2ppb0p3S0lxS3lXWWt4eElHSXNzVEU1d3RvUEZjOVV6UERpTGl3Z0c3?=
 =?utf-8?B?b0o2d2t3L2JPV3VYSHZuNWx2RUxYZDNySnk3VjZaell0bXRiZnc0V3FRMkxE?=
 =?utf-8?B?UUVlcXR2bGw4N2F0YmxRc1draG55UW1oeFJDOGxnRjRFSmRtWVBnQUhyOUw0?=
 =?utf-8?B?S20ySmtjZHNQWU41MUtPdnZzSWFWdXQ3bmJzdjVCaFl1ZlJkZkQveE52S0pB?=
 =?utf-8?B?dVM3VGdpOE80Vit3VURkWlRuQUlXR2xiMDNJcUF1S0xncUJhQ0lpWVR6bFlw?=
 =?utf-8?B?WXFNNkVoNWtWdlMwalovcTFIVUcxQUN4S0JxNkYxNnlERVpwUXI1ZlBtNmJL?=
 =?utf-8?B?ZWlaMXg4dzJZNmJMY2tpOEJvR2pIVFcwNnpzOEFTdXkxcGtHNkVNZW9VQTh1?=
 =?utf-8?B?dm9ieTBqKy9uZDRJME9MY0tBNFBIM3M2MTlDTjdEaldITlBjbGNNT3NGblFi?=
 =?utf-8?B?WE90anI3THBUQXhuK21lS0ZKd1pGM2YxWUlYZGpKaU9aa210aUo4Vjh0b2pG?=
 =?utf-8?B?RytyQU9tS1lWdXpialpJbUtKTEhhbmMwcGhXZFRpRkYyU3lMcGgvRVFhRjBP?=
 =?utf-8?B?d25Qa0YvWUtWYVNUeGFza0JlTzRNMVp5c2pKMlM4ZFJYQ0dWSzVub3l0cG1m?=
 =?utf-8?B?akpkTXRNVDA4Nk84YWpqYTFEb1ZXMDkzbmRqYmpZcmVDdzdMdmhnQTdkczB5?=
 =?utf-8?B?WTBuSVc4Q09NUHYyOEJFR0ZqOGVtKzk5Yzg2VTU5L3R4Z0RhdmlsRnRuRXMr?=
 =?utf-8?B?d1Y2aEZTeDZaUzJsTVk2bkNlS3Q5aXFldVAxbTdwN3RZWUJsV0RWbUJqL1Nm?=
 =?utf-8?B?U0pSVnZvUHNUazRZWWxaNVRqTENHT0hlaERQOUNxck90ZlM4bDBkQlFDV0Q1?=
 =?utf-8?B?dVd6cVZlYkFPdVhqNXU4VHJhSGF4MVNWejZwV2tpdHhZOUtuQUtGZ3hvMkxq?=
 =?utf-8?B?eU9Rd2dEU082U2FEaW10dHFCeWVlTjFsZ1BBYWFNZm15L2lsTFFQRTltWHJ3?=
 =?utf-8?B?Y3I4RmI1UWo2clNGYlErVTZOL1pXM0s4OFFGU3J2bXJaVlBvbkUxZlZidEdp?=
 =?utf-8?Q?5bqwNjfxoKHCcvcaAVE+W3Mr+p2dRfhOHsBbBOqZuYnU=3D?=
X-OriginatorOrg: sct-15-20-9052-0-msonline-outlook-38779.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 1861c5d1-0317-45b1-73ce-08de03eb3e98
X-MS-Exchange-CrossTenant-AuthSource: KUZPR04MB9265.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2025 08:43:23.7645
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYPPR04MB8960

On 9/21/2025 4:39 AM, Andrew Jones wrote:
> From: Tomasz Jeznach <tjeznach@rivosinc.com>
>
> Report RISC-V IOMMU capability required by the VFIO subsystem
> to enable PCIe device assignment.
>
> Signed-off-by: Tomasz Jeznach <tjeznach@rivosinc.com>
> Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
> ---
>   drivers/iommu/riscv/iommu.c | 12 ++++++++++++
>   1 file changed, 12 insertions(+)
>
Reviewed-by: Nutty Liu <nutty.liu@hotmail.com>

Thanks,
Nutty

