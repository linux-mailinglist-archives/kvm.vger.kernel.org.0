Return-Path: <kvm+bounces-59504-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E0C23BB94EE
	for <lists+kvm@lfdr.de>; Sun, 05 Oct 2025 10:47:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8000F189866B
	for <lists+kvm@lfdr.de>; Sun,  5 Oct 2025 08:47:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F4F621FF38;
	Sun,  5 Oct 2025 08:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b="WmxTi5Ar"
X-Original-To: kvm@vger.kernel.org
Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazolkn19013075.outbound.protection.outlook.com [52.103.43.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1FDE20298D;
	Sun,  5 Oct 2025 08:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.43.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759654042; cv=fail; b=il84cM3RI1bejAGZGldF52laTwpUjUOneB5lIl1rvYT81ZD5UXAxNRkFXYNeL5pTUDhU9T1FhcPAa7lk4ixohwIC3V/CVNDMxFPirg/2iZHF79XZcD48lZn0mxVj1yLjQALWwjltFnrygpb6B+UNrtjw2W5AhCogbgnSzMjfqgQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759654042; c=relaxed/simple;
	bh=qlBLIGCV25QwMKa5ZKtD7Y8B1vyTxhBNzR2YVoDzGhY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VUGi9aePitlNaGvUWb38LBbWJ4vzfIKxv1wN7gQIK62sDQbBHZQcqPeRfKFz9c3T2gBFpx+KdPA4ojUt1KkYsmGFGz5RhZH/HF4s58DQ7f8A6oU9FbPL61Xb37dmzdX6560lSBt1vNHM8qwmNpf9OUGyuqu3sDnZkxXY+6OFeQI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com; spf=pass smtp.mailfrom=hotmail.com; dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b=WmxTi5Ar; arc=fail smtp.client-ip=52.103.43.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GCfgW7g2+69VWv1JUEq8708vjoF8pg8fRnkqRbeUS56wsPGDRtqRujSY7i/xFnwynnMDCXNZERqMVEcZEXb6+lEo+6fr6+ahPbLsprVy89mkt1SQZLlmUA/CBH1NkalYvhNKQQOFUwuo1u6Ik6zPgRJxwrHFapliUudcnW9nfQUxP7sfhojVOKMrnT7M5IMu/27Rbl2a4mkOfVjzB7vgQ+wTuFNMy0eoFtptQrQN/lzImjuIIHgGchnTUW35M/tk2+BK+G2ULENrCrmdlt2mIaWdoeKibXH6E2k0mDYz2qw0jg3wv5kTpKMRWfFCxDzSAZ//V3nfDsf3fLtB6tTAAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MiFYrcWxWc3nxR8Q9l3d6nw3Rilh1KJdnolVm7bmTJA=;
 b=fUJ8xhEAbsVntJMeTdecZ/aRPg/HdUw0gABnmTQivHXSPPCRKUIxZ4uc5eomeN8cIheqMOePRGP0PQxc46/mpfOUVc1cKcu+l+TqjDBRArxqub2dtZgqTZQjMZcNDEHLEUwhqU3vy3WawC/Bfr3DldjiJcr47Zb0XqQHj+jyQyXLlXPfFzYh8HbnAeWcLQBQ5D3ZOClIfvPeNXV4TOU21s7QJYEFWKqv+BnX06Wu/iZzU9LO0HFzM7JcSafjJTETqXhU3rn8QRHcjDWLmx42ZVY5h17BgmSELjbYl5vcgNFvvz9kWAWGHz5rz9XkkX+8J9gzSoJwHLgHsmimRciI6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MiFYrcWxWc3nxR8Q9l3d6nw3Rilh1KJdnolVm7bmTJA=;
 b=WmxTi5Ar6g1I/9mXgznNcdl8vVU3TxMZkw8hbYGJUBgKAkLnlOuK9ULGPrf2fYiAAQnwqJOTTDVomzOYq+xKkhR6lFFQtHksaNvP98oXizI/Xk+N6GargjEbdr8jAQUv0zDzQl4B5fS6SfrDmX2ZdfPGHLMv1GvFv9fVPw97MqCW310FPFsju+RSW+aysIYLmNXi5wqwguQG+8oneprmS+e6ZJ93PPlW3nO29CkcbT2rBHO83kRwg3LPzjpwDtPS/ovekZa0bupAJw4m33fuDmdJo9bmvYmQ5R6E6qIdD5oOa1Im+oEMCTShgqdgfTRG7G5RgXe0DtLmDjmNCLquyg==
Received: from KUZPR04MB9265.apcprd04.prod.outlook.com (2603:1096:d10:5a::6)
 by TYZPR04MB5805.apcprd04.prod.outlook.com (2603:1096:400:1fe::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.18; Sun, 5 Oct
 2025 08:47:14 +0000
Received: from KUZPR04MB9265.apcprd04.prod.outlook.com
 ([fe80::3c38:c065:daf4:cbfa]) by KUZPR04MB9265.apcprd04.prod.outlook.com
 ([fe80::3c38:c065:daf4:cbfa%5]) with mapi id 15.20.9182.017; Sun, 5 Oct 2025
 08:47:13 +0000
Message-ID:
 <KUZPR04MB9265E71480FBE9529882AD49F3E2A@KUZPR04MB9265.apcprd04.prod.outlook.com>
Date: Sun, 5 Oct 2025 16:47:03 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 17/18] RISC-V: defconfig: Add VFIO modules
To: Andrew Jones <ajones@ventanamicro.com>, iommu@lists.linux.dev,
 kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: jgg@nvidia.com, zong.li@sifive.com, tjeznach@rivosinc.com,
 joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, anup@brainfault.org,
 atish.patra@linux.dev, tglx@linutronix.de, alex.williamson@redhat.com,
 paul.walmsley@sifive.com, palmer@dabbelt.com, alex@ghiti.fr
References: <20250920203851.2205115-20-ajones@ventanamicro.com>
 <20250920203851.2205115-37-ajones@ventanamicro.com>
Content-Language: en-US
From: "Nutty.Liu" <nutty.liu@hotmail.com>
In-Reply-To: <20250920203851.2205115-37-ajones@ventanamicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR06CA0010.apcprd06.prod.outlook.com
 (2603:1096:4:186::6) To KUZPR04MB9265.apcprd04.prod.outlook.com
 (2603:1096:d10:5a::6)
X-Microsoft-Original-Message-ID:
 <d1c32f8c-b93f-44f7-bb09-74ed85f47c62@hotmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KUZPR04MB9265:EE_|TYZPR04MB5805:EE_
X-MS-Office365-Filtering-Correlation-Id: 175c3051-96e0-4f02-28d1-08de03ebc7b5
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|6090799003|461199028|8060799015|19110799012|5072599009|37102599003|23021999003|15080799012|3412199025|440099028|40105399003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UW5hcVdqWk1oa1FiakJOZXh6NGtJTHY1bXZGV3FRMDQvYVpRU0JoR3FRaUhy?=
 =?utf-8?B?ajNjaUYvTXBpZjI5TW5Kbm5GcmJtdzFrSWVUQ2dKdUxHYWRBTTVTZTFPT3hj?=
 =?utf-8?B?cU5QMmJTenJyd3ZFb2Q1WVBsU2RsNWdxNlVmTzVhcktYUzdDMW9BclhKdW1P?=
 =?utf-8?B?dlBLRWxUbHExbC9LR09LYjJSa1Rhci90VzMzUnNFUFZFSGxaQjNsVW1Wam9v?=
 =?utf-8?B?dVlITU8yVHc1d01Hb0tkSFRJQ3p1eW5WUUppcnl0cG5pL3I3SldvTVR5TWFl?=
 =?utf-8?B?K3B4a0p2dE5TNFhjOG5OdjN3WkhhRlUyL21tb05seDVFWDdoN3NVem9UQ0Ju?=
 =?utf-8?B?d3JLcDh3ajF5SzBZdnNlUjdvYktJQ3RQMXJYVCtZalkwWHN6U1pYZ1NTdk5p?=
 =?utf-8?B?VHRYRlBwRmhTODh0VmF1MXFvWTQ5cHNOZ2tUVHZzNGV0SnhqR1NkNGliWmgz?=
 =?utf-8?B?UThpSG5adTJWRFd6KzRFc09SZSt6NmFSQkxKRHo1UzVnSkhHNElhMGgwL08x?=
 =?utf-8?B?alFiODBUaktscGY3dUd3MXg5VXZxcWxQa09zNVluYmxDSHhCenNQdmJCOXpN?=
 =?utf-8?B?T1UrSWc2akU4dTF1VmlYMmFMU2dSNmY1dUoxeEtUSHZ5azN6ZndRN2hua05T?=
 =?utf-8?B?b1JtUlJrMXg2dFBlM3lpVU15eWlVRmtsUUlsWjFQb09vL2Uxc0R0bUVGZklN?=
 =?utf-8?B?WlB2UVZ1NjE2d3ZGMDluZHd4UHcxMWwrSE5aK084OW1pQTgwR0RmckNQMkRx?=
 =?utf-8?B?aUh1TU1FaExpUG9XR2FsT0lDMWVsSDhhNytGdk5uSEhFMjNhL0JhNnFtZG9i?=
 =?utf-8?B?MWh2eDRSbERFcUVPN3k0eExScW9yTTBxa3R0MzdLaTNRbFltKzB5S044MFQ3?=
 =?utf-8?B?emxJelFCTjBXbVBDY1ZRYmV3TUgzSEFZTWl2YmsxOEFsdTVmeUF5YmJVbjdu?=
 =?utf-8?B?L2NEWnU0OEIxdVh0WDlJNjRxbktXNGZrSUlPMUV1bDVrd0x0T3AwQVd3UWFk?=
 =?utf-8?B?U1p4NWk4cDB1ZXN0UFY2dFpic29BT0RpWmR1M1NDNkY3WWI3Y25UZ1VoNjUz?=
 =?utf-8?B?dG5VTFplVGMyRk4zczhHUU1FQk5SQVZJdVRwbGtXcUlsNW1vL1FQQ2pIREJ6?=
 =?utf-8?B?dWNld1R6Wmt4ZDVMYllwK2pCa3lpa0RIQ1BkSTRyM3NLQUdob2VoNnZLaFpC?=
 =?utf-8?B?TnFxNVMyR21PaDlMM3p5dDM5ZnViK3BmWkhKdGJ2Ukdjbjl6cFFsb1dJWWFG?=
 =?utf-8?B?cUo2ZUhjVzlyWjM4NzNNc3J3ZG5uVXRzQWlkOVBldmV1N0UvMTlCS0tMWmJH?=
 =?utf-8?B?Ujg0OFh0N05uVC93ZXRnVWtFdHlGVGRtSmh5UnlnK3ptcXVUUms0NVJtaFlq?=
 =?utf-8?B?VDhja3laK28xclk2VmtDMmJROTNqdzE1QzhFYTI4dVpnMmhhM3I2K2I2S2Rm?=
 =?utf-8?B?c3NFNTh6NUNoT1pjdGVqNDBvQzRkMGJYMGt1dWhLUFhoc2ZDWk55WVBIaTZU?=
 =?utf-8?B?dUwxcTczbFB4MkRLdmhJUEQzZFdXbGJxYTVsSFZoeVdwcWo3djVaUE9zQ2or?=
 =?utf-8?B?NEZFWTlxWDRMRDEvZWdKK3k1a0JERW1DaDduMU5weWNaZkM2dnF5cEFTM1Uy?=
 =?utf-8?B?VTFKNUU4TjJYdVQzTy8xbUhkektpU1E9PQ==?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WFpxcjJaVVIyaFZHcGdLSXQ3YU9vdnJWZVRqNzVudUxleUVZYmsvUjVjbG0v?=
 =?utf-8?B?TWdnSXBDQjZuMFIrWmtzOFJFdWMzbFU5RTdsTjZQaFlqNzl4OGtMZ1RRRzNp?=
 =?utf-8?B?akZpWmI2c1p6aTM5K0dLNXY0ZDBsYXpheDlaSXJwTTg1dldrRUxneWRqT1U0?=
 =?utf-8?B?QTN3ZWQrb0lXS1FuanMrVWtPc2gyVXdId3FWM2NWWkh0a1JPdlJJaktCWnpx?=
 =?utf-8?B?bXFBSGJLQnFSMC8zYldxYTZ0OE44bVZBa2Z3QUNQSEFtNnU0a3d4Vy9jOXdN?=
 =?utf-8?B?VnJoV0x3NDFQQnE2SmZ6RndFbU01eDdjZ3hWUkNIRld0THhlRTEza1FUTUNJ?=
 =?utf-8?B?M1BwbUNCbjAvVG1OcDVSUVh6Sk5nVXhubFRNTmdhK09lY1BxZkk0MDExbHlC?=
 =?utf-8?B?SkpQbkNzN2JoMTBmVzNQTE5HeExIQThvSVBrTmNZVTBqTWZ4SjJPV0drQTkz?=
 =?utf-8?B?UG4xQ1FOSnRiUHZodDJnZTdEbTJ5ZkdBTFA4c2oyUFRyczBSZVAyUWY4emM0?=
 =?utf-8?B?QkFHRkFaTkRQbE9FT0xwNEZESnMwNkx2VEdmMXp1YWl0dE1Fell0cDU4Kzkv?=
 =?utf-8?B?ZGVaTGNSZUFmQXdyaktaQ3BvZGVhNmhLc2g2dXRZbHg2ckc2Snp2ZjBCQ2wz?=
 =?utf-8?B?Z2l2a1ZDTTNUK3Fyb2tqek05Mkt0ak5UaEdmRkpONjd5ZUlqSG9ZMFI1VXhR?=
 =?utf-8?B?ZkpRSGQzdXJJSTBZM3lkck01eE9pZDhKNzQrMkVQNUc5MStsNlg5Mk4zUm9l?=
 =?utf-8?B?OTgxcG4wWmVKTlVnakNHV2M4czVCS2diRGhGY2F1aHU1NUFQRWh4eDdaOVpj?=
 =?utf-8?B?SFZqYkd3bGMxb0N2UC9JaUZmYkYzendsYzJVZlVhbXhVSHI0TTkxVlpMNlpz?=
 =?utf-8?B?c2hBa2wzVW53ajcyODRpTUYyUDZ4RVBMeTJkMTR3YUM1Q1ZySi9aKytObytE?=
 =?utf-8?B?aXQ1UzN5anhKanBkbHhxVWs1Nmhua1pUa291RERSejdMalZVZmtRS20vcmRB?=
 =?utf-8?B?U01QcTdRTnJkdG9DZktieW56MDVFbkxSSWF3b3pQandraXZPSGxhblV1c1Ft?=
 =?utf-8?B?RG9uRVUzQ3EyZmpGQ1JaQURtUnNDRmxacGdQNGJkb2VxQk5qSnJwbGc0VThy?=
 =?utf-8?B?MjFxS0F4UFgzTFBTclBlR3dlTXNFVzBLeXV3R09sWFkxTVFjOFo5ZnQxeUc2?=
 =?utf-8?B?NFVlVkRtbzlSaS9CK0luMWdnbU5pYlpNWk5FdHRGSmtTejdCcVZmMzlVY2I1?=
 =?utf-8?B?RmtITkRCemtRL2NOUG1qdXJNbXhja1VVSUtHR3RQSnJIVUFBWm1KMTFHWTd5?=
 =?utf-8?B?c05mempwWVBFL21Ya21uQ3F2VWx5bnFiY3g3L1kwdGUzK0dROEF5UEJaWEhU?=
 =?utf-8?B?YUNiWGJqUWpSR2sxbU1CTDZXOW5oL3RiWE50REdrcWQ2U2tiRi9kS2t2ZGpt?=
 =?utf-8?B?NFZxalA0QjFIcXBKcGRnU1lRM3JtSjR2RGwzVkhyNVorUjlpWGxZcm5aWHpI?=
 =?utf-8?B?T0VqNGVXaUs4MWo0alRaRFZqZ3NPK0ZwOWtDRTh0bEROVzZ6aWNVc1Jsck9o?=
 =?utf-8?B?dk05anJDdHM0aVRwSkg2d1oxTE1VanhabHVxcVhONmptdHdWK0hicHl6ZW9k?=
 =?utf-8?Q?ENJk57o7OTQn3w/JdBhCkehT3iDivBovRPL2zgbaHtpM=3D?=
X-OriginatorOrg: sct-15-20-9052-0-msonline-outlook-38779.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 175c3051-96e0-4f02-28d1-08de03ebc7b5
X-MS-Exchange-CrossTenant-AuthSource: KUZPR04MB9265.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2025 08:47:13.7691
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR04MB5805

On 9/21/2025 4:39 AM, Andrew Jones wrote:
> Add the VFIO modules to the defconfig to complement KVM now
> that there is IOMMU support.
>
> Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
> ---
>   arch/riscv/configs/defconfig | 2 ++
>   1 file changed, 2 insertions(+)
Reviewed-by: Nutty Liu <nutty.liu@hotmail.com>

Thanks,
Nutty
> diff --git a/arch/riscv/configs/defconfig b/arch/riscv/configs/defconfig
> index 7b5eed17611a..633aed46064f 100644
> --- a/arch/riscv/configs/defconfig
> +++ b/arch/riscv/configs/defconfig
> @@ -242,6 +242,8 @@ CONFIG_DMADEVICES=y
>   CONFIG_DMA_SUN6I=m
>   CONFIG_DW_AXI_DMAC=y
>   CONFIG_DWMAC_THEAD=m
> +CONFIG_VFIO=m
> +CONFIG_VFIO_PCI=m
>   CONFIG_VIRTIO_PCI=y
>   CONFIG_VIRTIO_BALLOON=y
>   CONFIG_VIRTIO_INPUT=y

