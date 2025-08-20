Return-Path: <kvm+bounces-55092-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C6406B2D2A4
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 05:37:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CBD093B8553
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 03:37:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86D0822AE7A;
	Wed, 20 Aug 2025 03:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="GWY53Ozr"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2061.outbound.protection.outlook.com [40.107.220.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 652C63C38;
	Wed, 20 Aug 2025 03:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755661025; cv=fail; b=HBgFeUn4/vyo++GMeENsuFYo+8SpP1BYDeQPokTci/QpwbxMc3XpbXqgXus9Q3v8xcsHRGSTxRPKmEDyNK2GWWraF57DOsbxCJmMFw9CslOpGCxRRb/BWteod3EQ1Mm9JG6DjEwUG3/f5EqQprOc7M1elVXwpqX0PFWpUrTZnXM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755661025; c=relaxed/simple;
	bh=QSwItDxGOOlgXlO7F5aj0bsdb9dZhdyUtBvjjy44FHw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=iYgRPJPBVf76saEP1GguXHslT8r6M57prAzqlFBzBwFya9+j0VdhLpFie7dfCqvdfL+0iEUFj9JPrgkhLd51AR72r84l4e+g7SoIpc0JdbjSmhWe/5XtIKjAIHcbydEJghy3SbuMI6jV1bXP1LTj8rue4WdFtLBhv0KwDOPFCXM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=GWY53Ozr; arc=fail smtp.client-ip=40.107.220.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bG087LEZC0TQuYPTlKTK7+21IOYuLyZzobxAZ3NOeb5CuXj8PpAEDqj6x5IZk4b/xML858qXfVe7Uza5CXK4FfgAtTsRrfS2Avu35RjcSrHduAg9O8PfnIb8vBCtvunQU8w2SIPK2InT6ijm9Cw9cfWQqjVVG4aCZTfJZSN840+kyOEikfMRGDc22Kaaul1Mw+KpmKkUCF6pcFzU9pig+za6PPlA2wwg3VMkqqzMqSpDp/+4FNlFrwjQ+oPszQhhemOSQR7yT4ewAWnGdJ8XsNpTRuFjmMz29uXgtcNFDEC2aLhuMp8dQb6HOS3n5eZkM9PYQF+f+6M3TGIxPou4tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EQQFQAJ5HTVGVWwqUXFYOmAgRCZowmKnoynPE2tVjmA=;
 b=RxLMnWTS7yujtcyGrR2HRabFdEOxpg8j07rSNUjM9mAVW66fVt1sLkkdspsSV1Cq3ifpllsw9Lee4nSNNRSqKC16IbYtG/uq2LPlvM/kfNwfJ5+kpRIRFgJ7ZEBfKyxKmB2SxUrHUxu3+JGB/gOylOAHS4bYfJ5waLWfMLaM/Hn8BwkfhrVY5id6J8huSPIZhzpKv3eYqCIO55C5yDl1cw/VZB94+664Lc3XcZVzssgOKBwzsB2WegGwHp8wkFEwOhVRNJyLmmlnZQMTBP7eM00uZElsotYRdZWKcwWf0iIlqOD3sVrzuwlx+y0GSxMGUxzI8v9qFQT2h6M9RKDiog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EQQFQAJ5HTVGVWwqUXFYOmAgRCZowmKnoynPE2tVjmA=;
 b=GWY53Ozrune/xu8fzB++NI9MWxlLyOq0bnBF5Q6m+AymoXJKltzypT3E2HtIKbYqtuiZvFgxXGIXgfgBmXKX+efHAQha7KlPcTbHO8bEKWZCvGuVmy7n0IshmZiwQ4ufhuVT++5EP2IjjfT1MWk5Y21W0W1MEl0kqDZQvh6Fe14=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 SJ0PR12MB6688.namprd12.prod.outlook.com (2603:10b6:a03:47d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Wed, 20 Aug
 2025 03:37:01 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%5]) with mapi id 15.20.9052.013; Wed, 20 Aug 2025
 03:37:01 +0000
Message-ID: <c079f927-483c-46c4-a98e-6ad393cb23ef@amd.com>
Date: Wed, 20 Aug 2025 09:06:52 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 05/18] x86/apic: Add update_vector() callback for apic
 drivers
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
 dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, nikunj@amd.com,
 Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com,
 David.Kaplan@amd.com, x86@kernel.org, hpa@zytor.com, peterz@infradead.org,
 seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
 kirill.shutemov@linux.intel.com, huibo.wang@amd.com, naveen.rao@amd.com,
 francescolavra.fl@gmail.com, tiala@microsoft.com
References: <20250811094444.203161-1-Neeraj.Upadhyay@amd.com>
 <20250811094444.203161-6-Neeraj.Upadhyay@amd.com>
 <20250819215906.GNaKTzqvk5u0x7O3jw@fat_crate.local>
Content-Language: en-US
From: "Upadhyay, Neeraj" <neeraj.upadhyay@amd.com>
In-Reply-To: <20250819215906.GNaKTzqvk5u0x7O3jw@fat_crate.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4PR01CA0093.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:2af::11) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|SJ0PR12MB6688:EE_
X-MS-Office365-Filtering-Correlation-Id: d9b9f9a5-5d85-4c5f-01c9-08dddf9ad2c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WkdNcS9DZURsbVUyRUdDOEV2a2pVZmNVZmNvN0FBT2NvNzkwZFhML3U3ejdV?=
 =?utf-8?B?OFlFOXozYjQyUUZlREczMW94R2xDVmVIaVN0aFQyaVAzbjB2Yk1JRXNDZDls?=
 =?utf-8?B?Q3l2MzIxaUpEMXNXODltRDFJWGZpRGt3S1pNQUxaNDFReDFhaWVhYndyQTJo?=
 =?utf-8?B?Y0RKeTJzZjk1ZU1DZ05rTk02N2lVdTZRWjFOL0FuS3N3Wko3eDNZcm9JSjZu?=
 =?utf-8?B?K0FyT213QWpwOGtGL0drQlhLcURMRGRrZk5yaDBOZWErMEsvbzlWdDVVY21O?=
 =?utf-8?B?VHpwNlVTNVFlcVV6TnFXK0NWaGlOckkzTTZXSE1mdDljWS82V2J4TjdVT0sz?=
 =?utf-8?B?d2RlWGM0NDFiRVRiZy9DSUR6dmgwL2IvRkY3a1VtNjlwK3RkdzFRTkFZaTJ6?=
 =?utf-8?B?Q0xlUmdzKzVKaGF4ZVI5VlIrY1pkdEJhRlZLbFRuK3YzTlN1ejU5OTcxbVRh?=
 =?utf-8?B?ZEVMT0FURDErSURvWjlTbEhlMHdpZjRVeGl1SFo3cGNINUtqUGlya1MzVXdp?=
 =?utf-8?B?THFKbmVlNVc0U2hEZTJ0NUFYSzVDbG54K0x5RGdTLzZrSUVWZk1jT1RkZnRL?=
 =?utf-8?B?SzZabGEzdlN6VitCVDZzeHcxd1UrOXVsa0txRnh5aTZKRVJJNG45akkvb1Iy?=
 =?utf-8?B?ajUyelVRUjJmSks3Q3JlYXhpbno2eWpnc1hVWGpUVXd4ajJ1dG1CLzlPTSta?=
 =?utf-8?B?Z0NaeDROelpRU0JEdWNveUh2TnBhT2Mva2tJUEZYSFNoTFhxdVIxYjdSZXVh?=
 =?utf-8?B?ZktMTmV2RnJLTXY0clNqUWZqbmR2d1Z6bjlJZHVweGhJTUxra0pqSXByQkZa?=
 =?utf-8?B?YkF6eTZDQ3lpV3hNWWNVeHFSMkZlYm45dE4rRUdKaXZkRHRpOHBuSExWTDBX?=
 =?utf-8?B?Z2pjSFEvQ1gyMnNtWmxaK21YdzB2OXNEUUdRRkp0bzcxc1hBUWtUT2VWaEtK?=
 =?utf-8?B?WHFUSGFKOW9JM3NkcDVKRlVyNm9JbTh3S1piMU1JL1AxOGRkejBzM3o3UGdp?=
 =?utf-8?B?cE5JUnlHRnpYeVFpQXZFeDdmeVlvNU0rd1hhWU1HV2R1ZmR3N3FLZHRwc3Vq?=
 =?utf-8?B?RmtFVlV3QUtVelJoREt3TXR0YXB5QkVzU1NOTUJDMy9ESEZjR1cwT1J2d0Ja?=
 =?utf-8?B?dXFxZkZzclZKZEtScFNLdzlDNk9IbnlrSVQxV0sza2s0Mm9HSUE5OHpveFVp?=
 =?utf-8?B?emhWcWQvNWJUM1plNEdCNjlWWE1UanVVWHEzWWJ5d1BTTTNBVG4yWDI3alpn?=
 =?utf-8?B?akJ0cDg0NEhBTTBCYTJWazRzQXZTNWo4ekdDcnIybW1WMDdFMHhQQVhwWitH?=
 =?utf-8?B?aGs5TE9XcGtQTVVCU0EzTTRKL2xUSWZRN0RYb1lUYVRrRjBjWWFRMEdJYjBF?=
 =?utf-8?B?MGpoc2p3bGlrVXBEQ1J1VCs3dlFuWDJlWmduVkFJTlpVdWVqK2hwT05yYnoz?=
 =?utf-8?B?dG16SWptMmovbVFSK1hqUTQ1MlFwZEdLTlN4WXFTM04zWDhhMEY5clZjNDBv?=
 =?utf-8?B?OG5XNnF4Y0lubW42ekJ0MmNLZE12bHcwZlBTV2JwRzcvNzZxNVFJNnZ4MjMy?=
 =?utf-8?B?TFdSUVBkNSsyaTlmdUIzL2NOMDVCeTJveDFtM3FTMHRzelhoWWVLZXoyWmFm?=
 =?utf-8?B?N1BEMWZvWEEyRnFhZ3cwaDVDUEVacUd2UmsyOSsrTVFUd3UzdGpOcGZxa2ZJ?=
 =?utf-8?B?TGZoQ2w1NDJ3SXJsd0ZnbmR1bFlVMkVqaitBTFVQQmtjczQ1dVRndDFKREdW?=
 =?utf-8?B?cHQ1U3RDR0RKVmZlZGpXN1h1dldRVzdLSnlrY1JpT1A3QVU3SWV4L0dQc0dP?=
 =?utf-8?B?aytTaWJ2UUVnd05CMHpQVnFnZE02ZTVkMndCdTBYaFpxLzIrak5icytXbkx6?=
 =?utf-8?B?RTBZckRoR2RyVmRzYnZ6VTRSWVJ1NUVVQjQ2dnV4ZHovWVY4ekdCSXFtQ1lH?=
 =?utf-8?Q?SniPcJvOVG8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UXoxRGp6NGYxa0ZWR2JyNnBMZmlVWWRtOWNpSnorMk5mWUloMkcyZWpLaDZs?=
 =?utf-8?B?SFAvRWttL2lyYnh4UjVQa29IUGpuM2xPZGFISGxuUXBmditoeTRvQTJCM0Z1?=
 =?utf-8?B?RVBESVMzVEZ0TW56UFRhdGFldlZlSkcyZFZaWnluRUNuMTZGbjhEOFllUS9U?=
 =?utf-8?B?ZWF5Y0RVNTQwNlhMYkNwOGJONUlWZnU3Wk5Wdys3RW9QcTU3VHVXdDM4Ukt6?=
 =?utf-8?B?R0k5ZG1tdVVWYktuZUNCWUpkTWlpL1JvYndjbSt0cHgzcU45Y0Qybjc1alJF?=
 =?utf-8?B?M2dpOHJwUkpVV1JJZVdCZ1BjeDhOUXZQSlhrVUQ3eWF1bmlGZFY2cTdlM0N4?=
 =?utf-8?B?NlR6SmNyZ0syM2lCcWVOZkE4eCswM1RiTEJiOE1oNW1VSXYxSUMyS3BKY2FH?=
 =?utf-8?B?ZHBMUlgzcmtqWkg5aWY2Nm1BcnNDYTE5U1lKQjdpVkNZOGI2RkRJRkNmZDFq?=
 =?utf-8?B?V3FveVFWUWhmYTJKMTlpV0tKYmorVzZPVWhHeXI4UTBOODRWODBPM01Ra09M?=
 =?utf-8?B?NkJ1c3JuUGFMQzVFSGR5a0FiSHRCU2t5LzN4Y2F6MjFuN2JFZlgxMklhLytm?=
 =?utf-8?B?a0w5SlNUWHNJcjdhTkpXVkdIVkZCNS9QTWxzaXN6bHZKOE9XZnZRT3Qza3I1?=
 =?utf-8?B?eFZlVkNWN2daZUk4TGx3VWtBelVqN2VJRExPR1p6M2dxZkhJSUk4bXAwdXRu?=
 =?utf-8?B?WVNiSnB6Sm9yVzAzS2tPb1dWdVdmY09uS0NnOFlmWG1ZOUdmMW13WW1jOWU3?=
 =?utf-8?B?cjdwRWJmMHd5STFJOHRqdjlDS3ZSVGdnSEd2UVp2SjJabzgvNlV2QlM5SUVW?=
 =?utf-8?B?VzM1MnYyVUFmUm04Qlg3ZjRyN3ZrVEJVS2hsVFpVOHBHNU00anl3SkJ2VW1s?=
 =?utf-8?B?MlNXOURRTjZDQUxWVmpSWjZIeWdmYkdJU1hTbktYQ2ZSWEpQSTV5VkFFdUZj?=
 =?utf-8?B?NWlOTjVCSFJveWVIN2dDVjJzUlFSRlJsR3AwY1dnbWN4Ym10S2hYMGV4dlZI?=
 =?utf-8?B?Z0JzcVNXYzE0TkFCMWR1SHZBUitPeTNxcUlUQmI0VHJyRlVmZVhSUUNoZnZS?=
 =?utf-8?B?NUNwVUdGSVMzckRLSmRYOHl1Z01lL1JtSW9GYnJaakFORjlGdXJURlFEVThq?=
 =?utf-8?B?ZHNVWlFkZjhCN25BZUFtRzhtRmJ4Yzh5b2tkdEpwSU05SHZyMkcvZHhWc0JQ?=
 =?utf-8?B?NHlXS2hmUmcwTGtiRDNZcjhSZVZCd0VDTkVvY3FTUWhZdDEvT05aSGhpUTlj?=
 =?utf-8?B?Vk90YnZpY2o1WDZQa3JIa0ZjSldRanc2MEpjT0dNWlBKZ2o5R2lxRVl4YXBS?=
 =?utf-8?B?ZjRocXY4b2tSMXIvenhnZUhDUFZGTldjMVV4eUQyQ1Q1MlF3Ynpyd3ZNUVp0?=
 =?utf-8?B?ZnBQLzlZQVl1bXBpYVV1OERZelFzS0lKaTZWWmh3NWZ3UWlSUWZiVzNGS2Nv?=
 =?utf-8?B?L2lxRCtkYkxwWkkyc0dUbUVEd1lDamhHemtBSUU4S1V5b2ZjWWdMd0JxVDNN?=
 =?utf-8?B?Ull3dHFjNXFOSGM4NWtpdTU2Tkp0Q2lTM0ZYVXBDdkI2S21rS1ZITG5mNHdJ?=
 =?utf-8?B?c3FaTzgrclZGdVM4c3gvZXl3ZS9qdFJ3VTVPYXY2c1BPRG5PSzVydEloNHpN?=
 =?utf-8?B?Ri84TC85dUdhV09rZzBHZHNCckRiYXJVN0dGcCs3UGd4akVXL1U2VEFIeFV4?=
 =?utf-8?B?MW1wNTg0dlhhQ3ZVeUNEWVFJeHo2emZIVHFFSTlTQksrV0tZQUl4Qi9JMmVT?=
 =?utf-8?B?MW5XYXdlcHY3VVpOT1QrU2ZXUmsxUmJ3UHZPYVFTTUVXNS9OaUNsMjlGMzlY?=
 =?utf-8?B?QWFxcFF5aFRaWFpTalppMmU3UWEzUHRSY0t2SzZwR1UzR3B5YlFyMXdVZ0pX?=
 =?utf-8?B?ZllpSEhlQytrdkdsSjJXeDU2U3M3SHQ3M0h0Q2J5ZVh5ZjRFeU9BT1ZlY3Jk?=
 =?utf-8?B?WUd6WTN0WmtGdW12RXhWUXp4U0hDdVVaN0FHVTM5Q1VTT1Q3RTFTZjBjWXdV?=
 =?utf-8?B?T1hHeHhVVXY0a05OUEIzdnlGbGRsY2l6cEtTU1ZacksyNzluZHlaMm5BSEdr?=
 =?utf-8?B?TjNzSUs2QTg2NVVXUE9lSWpWaC9VeDNYczN1Q3N4aG1ic0FkdEtXTWdybTBW?=
 =?utf-8?Q?AVmWd3w3LYq1WSY9OP9qUbX02?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9b9f9a5-5d85-4c5f-01c9-08dddf9ad2c4
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2025 03:37:01.3755
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fAyvbEyJJmpO9Tu0tqm6/7ajUi7SDX8SutrKdkhjX0n+05XR9rJlOobZtwzc385y90HVnq6FbJJ+d74OGCi/hQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6688



On 8/20/2025 3:29 AM, Borislav Petkov wrote:
> On Mon, Aug 11, 2025 at 03:14:31PM +0530, Neeraj Upadhyay wrote:
>> +static void apic_chipd_update_vector(struct irq_data *irqd, unsigned int newvec,
> 
> What is "chipd" supposed to denote?
> 

chip data (struct apic_chip_data)


- Neeraj

>> +				     unsigned int newcpu)
>>   {
>>   	struct apic_chip_data *apicd = apic_chip_data(irqd);
>>   	struct irq_desc *desc = irq_data_to_desc(irqd);
> 

