Return-Path: <kvm+bounces-36272-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 66FD1A19616
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 17:07:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C21173A46DD
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 16:07:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 166C5214A8D;
	Wed, 22 Jan 2025 16:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="XjeWOb05"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2089.outbound.protection.outlook.com [40.107.100.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B03921481B;
	Wed, 22 Jan 2025 16:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737562059; cv=fail; b=ImZN5DSbLxcJ9Il8kxRagLXO+k7kB3F/I3tj7Lc627HwCF/szuwU9ufDaXknQgbius8qmnElWPPabogKsFzdVfczpImEy+lNO383UfShpYtnKVvf/wXlBqrX8nbv/OJxpUn1oDMaCwpwsj8ogp/Ox/tyJfrPiwMinyXaHykpiPo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737562059; c=relaxed/simple;
	bh=MnbTUk/gckk/ENA2tO1LP+8OrBW0fSlX2SzIXMUQd/g=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bzvRDFLYseWrYe3aFy/5CvmL56lNcwwaKq0StKuFGAChFMySX6anOCSyKdObKL0pQGrae6NO+KWB8HcZNY01+ULi7KRjWL7XNfTvBomg2QJycOrtkYwv3uStsODp/3vAdl3oFqXP/as+QmBefh/iQ9mApp4q7qAAbZ41UECdbz4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=XjeWOb05; arc=fail smtp.client-ip=40.107.100.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=snfYDPthkHvujyEfRQvo71SU74TTv4JnK+ZATaEbnbpOM1SgNfydcaPZOpOiKYBjC7V5OPVnhQdW5tapfLzCqDj9Nt1iphzK3wgZu6tbPTF84Z2CIrZi3x+AobamcDHPpZ4BW+sYwZf5ZNAehkVZxGky+P9aywgP+Yzw1AU3orrTLSL3j9Ve0v8+ONM46XGx/2OHd7egL7j7JWk6UYub5R38zLIXJbJ052l3d73QF7wvrMI73ZjnRSLbNgy3s54q+b4N6KQqyn7GiAtLgvtrsS5V+zbe5gVtxnP/6+/lnLQ8L5thN2oSaJL4Mzs5/Sk/gE2PeTDmo3nRbksJoHB8YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gn7rmMQc8wiTRXQxjr4gPez3+W3QzX8W6OEh3iBdX+g=;
 b=fTEHFmFWqeQs1qADeXbkRuWLjcrpBbpNci8Vmo8oaMO1UNMwdPVUM+TBLeui7LW2omTg5iF+YnFpl8V8NxZUpKnoH3mzFM0YInMUKINtmobkPmceC8TCPfY7DtyN6SRmpAnJH0bCZKIPBZjiFXmuQwgfT1z68X/xoyGZCpQnhENCNd38WL71uFiqJaLo3U9nwYgRMlmXPSW+zgZmpuU25kFLVFA5fUKrhWejAfvxiiYrl6i+TNIVyPQd0wnUl6l0ScJokSKiXXoEBNs9unnlpqAiWDCTOolM9i/jN8XtFl18z02obMmSK7zmUfE1sP0XKr35BtnrgdFppxczCUZYQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gn7rmMQc8wiTRXQxjr4gPez3+W3QzX8W6OEh3iBdX+g=;
 b=XjeWOb05250QZvFSAUxvW/5q7WJic+Y/WHPBF5fCDhCFqNK8HKmxpJ8Fw8uJxF9/FBKDvVi3t6acTktaA+ahj4x1eFVWyB9Gbaku1n9bg53sdwpvjerLkfmGonH0hI1fVtMABrwCtphuLylxgTHXbXUnsxU/8Q+iYujtau7PaIo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by PH7PR12MB7985.namprd12.prod.outlook.com (2603:10b6:510:27b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8377.17; Wed, 22 Jan
 2025 16:07:34 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8377.009; Wed, 22 Jan 2025
 16:07:34 +0000
Message-ID: <e363f428-0a49-a22c-530b-c8a17038cabd@amd.com>
Date: Wed, 22 Jan 2025 10:07:31 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 4/4] x86/sev: Fix broken SNP support with KVM module
 built-in
Content-Language: en-US
To: Ashish Kalra <Ashish.Kalra@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 john.allen@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net,
 joro@8bytes.org, suravee.suthikulpanit@amd.com, will@kernel.org,
 robin.murphy@arm.com
Cc: michael.roth@amd.com, dionnaglaze@google.com, vasant.hegde@amd.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev,
 iommu@lists.linux.dev
References: <cover.1737505394.git.ashish.kalra@amd.com>
 <6fc4cd0f07f884da4345951670aebff8815270b7.1737505394.git.ashish.kalra@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <6fc4cd0f07f884da4345951670aebff8815270b7.1737505394.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1PR04CA0002.namprd04.prod.outlook.com
 (2603:10b6:806:2ce::10) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|PH7PR12MB7985:EE_
X-MS-Office365-Filtering-Correlation-Id: e0c28dac-8142-4bc4-0ef5-08dd3afee1e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TGtZUVR2emlucm5vd3UxNXdKVk5mMDJMcUJtbTF4cEwxV1NDejEyNmxxVTZI?=
 =?utf-8?B?TUlobGx5ZXFZS0x6QnRzam90ODc4YlZMTzBSdHgxcXhMeHo5c0oybUpaeUNZ?=
 =?utf-8?B?a1ZqOTdtZGR0Q2FzWVREanNIdS91bjBsWEJ5UTl2dDVvRDh2eHlUcWU5cCtB?=
 =?utf-8?B?QXEwSHJkcDhiUTJObjJsOFJFT3hmb1FoY3YxUHhTbmNFY0VxWElOa3F0USs2?=
 =?utf-8?B?YUNZcWx1eHNHTXh4d3BUb0tvcnBhTzBQY0dWcnVaU2NpTUZWMWpFeDFCSUts?=
 =?utf-8?B?U2ZYcjF3Q1lEbmE1blFmekFMUmZkcXUxenVTalpyK2NZTmQrSEd3WXg2bGZS?=
 =?utf-8?B?MFFqSnVhWjd5WWZ5bjJlcWdyVEQrSjZKMXZEMVpBRGJQL0RBRzZRK2QraWlE?=
 =?utf-8?B?WXQ1cFp2UFRlbnF2TkM5ZmpBUUlLOHVyc3NzNWd6NFAvYTE0YytvYkh5cHE1?=
 =?utf-8?B?OEFQUnlpSjE2eFZzNTZTY3VPZ2J6OU56bkFlQmxiNGpubXVYL3lMTkVmVXNO?=
 =?utf-8?B?ME5EV0RsNEp3bnRpdnZ3UWJDZlBFVzhvcHVqV1hJU1dzMU9OZlZGV1Ivd1do?=
 =?utf-8?B?YUNPOEVMVWROdGhQTTBZVzhSeWpBZ3RJYXNkaGZTdVhaRWJrWW83YzV1cHFV?=
 =?utf-8?B?VUZsMDdNOGd1bFEzS0FCd3NXTUh2WTNHRGhPdUFINUFUSXdWYlZVYU14cThq?=
 =?utf-8?B?ZjFvSitFdk5pdG4rNy9wQWZ2TDFFRHhzeVl1YzZiamZoMENyLzhaSnR2c3dR?=
 =?utf-8?B?RG5DZzlsbDNjcjRxVUFMQk1aNEh3R1FzN29kV1pTaHdzZ3M1TTFUcllkOTM5?=
 =?utf-8?B?U1d0NEF1b3p3VlpidnJMbWtrczNhYjUzZHYwczBUQ3V0M1dwYUh2RXpDQUlq?=
 =?utf-8?B?N044MlkweUlkVzYyYnVlSmlVcXYyOXhMZVlaRzg1VEw5QVdEanhRVG56S2FZ?=
 =?utf-8?B?Q1FPcnhBYWdUa3paVlN2SUovVVhoZGJXQjFGZFpiMW5yT05Bc1h1ZUdubzRx?=
 =?utf-8?B?UDVURnAvV2xjeFArd293Z3ZUb3JZVlhscFBvTkgxU0xWd2dvT2dWcGU2SzBo?=
 =?utf-8?B?OUdHUTBrTEthZGpiQS8vNVJycVV0QUpJQkJENDJtWnV6dkMyamhpamx4ajFt?=
 =?utf-8?B?alBkV2ovUjNub20wTFNUQjRLSnVhNUdkOWh5RUpnZEpRSGFyM1J6ZEVZQWhv?=
 =?utf-8?B?eTJtQXpnRW9xSHhCQUN4ZTVtTzZrYUVLQUI1Z0lTTW5oR3JmUFBLeVJpSkFV?=
 =?utf-8?B?d3pyV1dBVFVnNnNSN0ljRndxUzVDK0lncGlzUStHb1FJM2ZMc3phQ3o4RUNK?=
 =?utf-8?B?c294bE1ka3ZtTGE3YTVGaXlwblJKNWU3ZlRuNExUL2xMY2RCVWgyWVFYSEFx?=
 =?utf-8?B?WndvM0xOaHd1ay9MdlAzOGV0em5Mekc2TGQ4TmhhMFRvZ3VGbWVpLzY2K1lp?=
 =?utf-8?B?OWVkdTB0MlQ2b0tERVFRL3ZSbm9YLzVDQVFjYzRYZ1l3bEJwT05STk9yS1dw?=
 =?utf-8?B?ck5kd2hsUUdFa3B4TCt2U09aRVVRZXp2WHQxZVlxU2RIZlcxVzhXclE0UE9q?=
 =?utf-8?B?Qjk0S1NEMHhKcDFOcWFXK21aYnlMRnlhRDJzd1ovVVIzblZqMWxUaFFIWDRl?=
 =?utf-8?B?a2tmNWNBbThjVCtPRUxGNDZhYzhQL3JQQXRtSnZ1WWd4UjErQ01zVXA4RnA4?=
 =?utf-8?B?Y2l1d09kZUpMaDVudnlKU083WEZFZmE0cHNLL0ZNVDIrTWZXU0N4dGtnenRy?=
 =?utf-8?B?RHVTanFyMFkwQWR0a3MreDgyNFNzT1lndDR6Nk1kYkdsRU9xVStwNTczU0tz?=
 =?utf-8?B?TDZuM1duTC9JSWt4ZFF3em5PY2t6akwwOFp1VnhIR1lwRVZPZnVXT1FKT1V5?=
 =?utf-8?B?aTQxNVhZWXFlV1hpbFRvTTlqdmlXQ3hadFM1WnBpa29IMkVRVUw4U1hCS01t?=
 =?utf-8?Q?yxdl+atB5jc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aTdMQi9iUXVERS9uNk1zRjRIZ3ZQWjE2WVJRMU04WGUrRjNtczJUd3RvK3Bq?=
 =?utf-8?B?MmcxMjNoLzZIMUY4M3lvNktuc0tlTERZcXBlRHhXMUlOQ2tncmtVYzA4RjZo?=
 =?utf-8?B?bVJpUmk4R0dLL3hlQlFCQnVKOWVvcUwrZ1FlbHFISlNUQ0ZITmpMaXQwTkhq?=
 =?utf-8?B?cUs0cFFiN3R1Vk9keXNGdFVBd1VaS3RxR1dXQ1dZeWljQWdweGNuQUZ0WTNm?=
 =?utf-8?B?c1BVOHNrSkhKb2oxMHdCSzlkZFZZZytVWi9qTnA4eC81cjd0ZjI0M2lydE5j?=
 =?utf-8?B?MzBDYXl4TGVkUkRORVlIVFFtSWZwMmxKMC9CMnV4d0YxSFYxNzNIMWxMbU15?=
 =?utf-8?B?aE1pRjk3QzZuamZpYmRIR09mSXcvRFVmYmtsSVM3cGVDbThWM3ZUYXFRS1Rm?=
 =?utf-8?B?Nmtwb1RWdjdnRU50UTl4UnRheDMrSWE3d3U3cGQweGRnVUVyN1lCY3dxZ2hU?=
 =?utf-8?B?bENxVTBPYi9pK0M1QmxwVFBPNmZPa2ZnaStlRTBwZzE2OEVGWlBJMWpLdTlw?=
 =?utf-8?B?QS9KaTkrZVN6SUJpTjE0VnM1ZXg4cmhFYzI0MFZheWMzNElKQThpQ3g4WEUx?=
 =?utf-8?B?WXA2NUREK0VLUFZ3Rk1xTEZTek5jWFZITWI1Q3d1bW5zek5TZTlOVVpySWpW?=
 =?utf-8?B?ZEpPRDVNM0pNNW1MYWF2TVgrNmJXYXhydUlTMXg4eFFMZEpqUCtXSGdDRW9P?=
 =?utf-8?B?RjdYZnJqR0g0WDRNMTB6UVlxZ0FxTFUySjdMeUxMbmhEUlNESHlCRkFWYU40?=
 =?utf-8?B?Zmp1MjNObUxoRUF1bTkraEZlTUIwR0V2R2V6U0xFNUkybHBpV2lxMS85a3o4?=
 =?utf-8?B?b1owN1VvOW5JTXBhRmFIb0RRbGpZWEdGUmxkcVVZK0tnQ0ZGd1c1Y0MvMGpM?=
 =?utf-8?B?RVlrYnpodVo5V2c0RG5nYjd1N0tpanVVam5MWE1DeDdBaFdKdmhFdjd4MXp3?=
 =?utf-8?B?VEJEY3dwdzRCUmxNQXd4NGg5djUyd25tdTFhSzRob096d3BLdkduYk45OG1I?=
 =?utf-8?B?dndLNDhtTkRxZ240YkNYSEFvOFJMc2Z6ZzlwdzVFNmkvWk5PUXVWRFl3U0ZC?=
 =?utf-8?B?cVlDZ2NZemVCMUlqNXN6R0ZrYUpVWDQ1WnVaZUk3RWRUb0FWSm5WTjZIOG0z?=
 =?utf-8?B?N0p1RXp1VnpleUkwRVFqaHQ4dy9VS1Q1L2xVbUtIeituTWFjVDMvYmNuRHd1?=
 =?utf-8?B?RG5xTW8zUEIyYjN3TExvL3hyNmJSZGhjci83TkFURG1Ma1p5L0JQZ2l4RWZR?=
 =?utf-8?B?UVlqL2tETGRvK21vK2xJRUNCdmFOVkFuOFNMcC9pN1JaLzhvK0dCV0NYdmE4?=
 =?utf-8?B?blBrZHowZWRnS1AzU0tOOTlZd29VaE9kT2FSemZyR2NoK05ZS0Qzd0Jualhy?=
 =?utf-8?B?SjY2OG1ha3FDZlU2Wkp1VzF2SjNlNGJwY28wVGFLRDBpcGIzY1VYUkROY2dI?=
 =?utf-8?B?NUN0amNFZ0pld3k2QVZzL0RnR1BLTDFnVVJyc0tqUHJPNUhTRXYwRmEzSy9h?=
 =?utf-8?B?d1JGUU9ndzMraThZRkRQS0ppclM5cU4zWDNVeDdlK1ZuT2hEN1RsV20xN0hR?=
 =?utf-8?B?Z2JDeDZ3Q0w0QkFKRHU4Uk5HODlIdDdKMjdsYS9FODhXdlRxSDZtZVdsQWlU?=
 =?utf-8?B?VmVQUlNqUEtJanJtSmV5dnJMcG1RR3ZScFNCRFJoNVkzMnpMTW45bitWbVFy?=
 =?utf-8?B?UmRvai9scUpSOWMxM2RTd3Q1dUVWdDBJOHo5Q3phVkhOUXZzeUhWVnZ6aC9y?=
 =?utf-8?B?aW5YSnA3bEZPVUl4MUd2bTV1VW0yQWdIMGQweWlBOVJ0ZjdqY1Bra2YrVC9p?=
 =?utf-8?B?Ri9Oc3RwMXc4R2YvVFhiOXZrMjJIaU1ndEF5ZWRVNlpQYkpJa0F6NFc5dzl4?=
 =?utf-8?B?dHdXS0xOcWZmOVBMTHhJTUtmbWUxRkg1QVNBNE5xOUpVN2tmSWloSER2MHYw?=
 =?utf-8?B?YkxYOTVOTTZYZHdjc1lhVUNkQjFvU29PV2tCNGxzMk0yOTlaOE5HS3M0OXho?=
 =?utf-8?B?Nncra3dxN20yb28rVmlPMnQxdlpoMnFXUFpVdU1rVUw0QTlURmJJZnh6YU1l?=
 =?utf-8?B?SytMV25XaTJjZG82a2lXelNnVzlYQ1dtQnM5YjcwT1o2QjAwYjd5dmZVYjc0?=
 =?utf-8?Q?rmlsusOrmcGRpyZUggUN3XqP9?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0c28dac-8142-4bc4-0ef5-08dd3afee1e6
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2025 16:07:34.4541
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QBxv4ktDiDPlNUm5IK30PT0jOAW3E1FpP+HwyTulUqVi23GodLVfBuoyuf+PHk6LybtOttMqDO1o4s1l44fpug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7985

On 1/21/25 19:00, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> This patch fixes issues with enabling SNP host support and effectively
> SNP support which is broken with respect to the KVM module being
> built-in.

Should this be the second patch in the series, since the first patch is
what allows the change from device_initcall() to subsys_initcall()?

> 
> SNP host support is enabled in snp_rmptable_init() which is invoked as a
> device_initcall(). Here device_initcall() is used as snp_rmptable_init()
> expects AMD IOMMU SNP support to be enabled prior to it and the AMD
> IOMMU driver enables SNP support after PCI bus enumeration.
> 
> Now, if kvm_amd module is built-in, it gets initialized before SNP host
> support is enabled in snp_rmptable_init() :
> 
> [   10.131811] kvm_amd: TSC scaling supported
> [   10.136384] kvm_amd: Nested Virtualization enabled
> [   10.141734] kvm_amd: Nested Paging enabled
> [   10.146304] kvm_amd: LBR virtualization supported
> [   10.151557] kvm_amd: SEV enabled (ASIDs 100 - 509)
> [   10.156905] kvm_amd: SEV-ES enabled (ASIDs 1 - 99)
> [   10.162256] kvm_amd: SEV-SNP enabled (ASIDs 1 - 99)
> [   10.171508] kvm_amd: Virtual VMLOAD VMSAVE supported
> [   10.177052] kvm_amd: Virtual GIF supported
> ...
> ...
> [   10.201648] kvm_amd: in svm_enable_virtualization_cpu
> 
> And then svm_x86_ops->enable_virtualization_cpu()
> (svm_enable_virtualization_cpu) programs MSR_VM_HSAVE_PA as following:
> wrmsrl(MSR_VM_HSAVE_PA, sd->save_area_pa);
> 
> So VM_HSAVE_PA is non-zero before SNP support is enabled on all CPUs.
> 
> snp_rmptable_init() gets invoked after svm_enable_virtualization_cpu()
> as following :
> ...
> [   11.256138] kvm_amd: in svm_enable_virtualization_cpu
> ...
> [   11.264918] SEV-SNP: in snp_rmptable_init
> 
> This triggers a #GP exception in snp_rmptable_init() when snp_enable()
> is invoked to set SNP_EN in SYSCFG MSR:
> 
> [   11.294289] unchecked MSR access error: WRMSR to 0xc0010010 (tried to write 0x0000000003fc0000) at rIP: 0xffffffffaf5d5c28 (native_write_msr+0x8/0x30)
> ...
> [   11.294404] Call Trace:
> [   11.294482]  <IRQ>
> [   11.294513]  ? show_stack_regs+0x26/0x30
> [   11.294522]  ? ex_handler_msr+0x10f/0x180
> [   11.294529]  ? search_extable+0x2b/0x40
> [   11.294538]  ? fixup_exception+0x2dd/0x340
> [   11.294542]  ? exc_general_protection+0x14f/0x440
> [   11.294550]  ? asm_exc_general_protection+0x2b/0x30
> [   11.294557]  ? __pfx_snp_enable+0x10/0x10
> [   11.294567]  ? native_write_msr+0x8/0x30
> [   11.294570]  ? __snp_enable+0x5d/0x70
> [   11.294575]  snp_enable+0x19/0x20
> [   11.294578]  __flush_smp_call_function_queue+0x9c/0x3a0
> [   11.294586]  generic_smp_call_function_single_interrupt+0x17/0x20
> [   11.294589]  __sysvec_call_function+0x20/0x90
> [   11.294596]  sysvec_call_function+0x80/0xb0
> [   11.294601]  </IRQ>
> [   11.294603]  <TASK>
> [   11.294605]  asm_sysvec_call_function+0x1f/0x30
> ...
> [   11.294631]  arch_cpu_idle+0xd/0x20
> [   11.294633]  default_idle_call+0x34/0xd0
> [   11.294636]  do_idle+0x1f1/0x230
> [   11.294643]  ? complete+0x71/0x80
> [   11.294649]  cpu_startup_entry+0x30/0x40
> [   11.294652]  start_secondary+0x12d/0x160
> [   11.294655]  common_startup_64+0x13e/0x141
> [   11.294662]  </TASK>
> 
> This #GP exception is getting triggered due to the following errata for
> AMD family 19h Models 10h-1Fh Processors:
> 
> Processor may generate spurious #GP(0) Exception on WRMSR instruction:
> Description:
> The Processor will generate a spurious #GP(0) Exception on a WRMSR
> instruction if the following conditions are all met:
> - the target of the WRMSR is a SYSCFG register.
> - the write changes the value of SYSCFG.SNPEn from 0 to 1.
> - One of the threads that share the physical core has a non-zero
> value in the VM_HSAVE_PA MSR.
> 
> The document being referred to above:
> https://www.amd.com/content/dam/amd/en/documents/processor-tech-docs/revision-guides/57095-PUB_1_01.pdf
> 
> To summarize, with kvm_amd module being built-in, KVM/SVM initialization
> happens before host SNP is enabled and this SVM initialization
> sets VM_HSAVE_PA to non-zero, which then triggers a #GP when
> SYSCFG.SNPEn is being set and this will subsequently cause
> SNP_INIT(_EX) to fail with INVALID_CONFIG error as SYSCFG[SnpEn] is not
> set on all CPUs.
> 
> This patch fixes the current SNP host enabling code and effectively SNP
> which is broken with respect to the KVM module being built-in.
> 
> Essentially SNP host enabling code should be invoked before KVM
> initialization, which is currently not the case when KVM is built-in.
> 
> With the AMD IOMMU driver patch applied which moves SNP enable check
> before enabling IOMMUs, snp_rmptable_init() can now be called early
> with subsys_initcall() which enables SNP host support before KVM
> initialization with kvm_amd module built-in.
> 
> Fixes: c3b86e61b756 ("x86/cpufeatures: Enable/unmask SEV-SNP CPU feature")
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  arch/x86/virt/svm/sev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
> index 1dcc027ec77e..d5dc4889c445 100644
> --- a/arch/x86/virt/svm/sev.c
> +++ b/arch/x86/virt/svm/sev.c
> @@ -571,7 +571,7 @@ static int __init snp_rmptable_init(void)
>  /*
>   * This must be called after the IOMMU has been initialized.

This comment is slightly stale now. Maybe modify it to indicate that the
IOMMU SNP check must have been done.

Thanks,
Tom

>   */
> -device_initcall(snp_rmptable_init);
> +subsys_initcall(snp_rmptable_init);
>  
>  static void set_rmp_segment_info(unsigned int segment_shift)
>  {

