Return-Path: <kvm+bounces-31961-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E339E9CF58A
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 21:12:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F0F5286C14
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 20:12:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBABC1E1C30;
	Fri, 15 Nov 2024 20:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="cLVqgtJR"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2069.outbound.protection.outlook.com [40.107.92.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B8317C219;
	Fri, 15 Nov 2024 20:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731701548; cv=fail; b=EQLN0VdryGG4qgYJyfRIQQgQfuDWwoPaQDlu4q8Ac+s0O77c5RC2W3vbl4ZiZOCzOUwjhtUJSWE/3O7FaTYQRxNfN6Sd53HeqWcY+fC0QD0gY0+XTIBtuZ8Fpd9c/iKW1+YicclO/wVVqDRW2xnyHVy4tUDFR1hkTWdaTiWtIbY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731701548; c=relaxed/simple;
	bh=hQEkmBl2I6Gzrd5OnyqTSHrw4+5N/4vdDof/6hM4kxE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OVIKdrtoBuxF0LiW8FzePuKZmK9voirMHiwB1L3LynBJycgOJIUs+n19LZAtB56LtSVP9s0QBj17KkIPfwLHf+GxoKK3ODyqeDAv2kRW09rVTjp6hwpdl4nkYqEo/bSjmzUJrcfcX6zaNLEjoiwyadkzYH2bmjwYTAMWItvxGuo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=cLVqgtJR; arc=fail smtp.client-ip=40.107.92.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OAd7EZNIGQQoavNNV8Z0H9PHWiNe7tCQ85ESH//suM4AV8otdi1MMoKV+mQ2rkGJAWDofv7Z/WAbqU6Vp42s0ZgQNvYd/6s6BU3+5lE2PpkeuPtdBBua8R4iJwD7l1pRSiZQxGMdFUZGA0ACPI/5Yb0NaAbKBVW5krJfEBgx7M5gMtbtEalEE1py5fm/ZgrQejTu6TACY/qJ18C2RsooMy8WWyvWZvl8kExMA/u10aV9tgpEtGf9v7FPFbQYuApBpXz/tcaMX0hXmPzOGuGrSwczsurxrnLgOx9ey6+rxZMf2IzXEyHZrcLpTYeF5Xo7ZpmGqiTSi0oBM/MhCRwpsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4RVKC09QbiyO5TyommPFOgz+QTA7DIgLlbzCwSrZmxA=;
 b=UgboHbMyndBCTshczqU36vI+gzVIhQVBs1ROPYHlLFspkztHkYJgrLbdc1YL9JADdJqVhgH++11otIySThkbrsMpGa1ZQmG8dYXBeFe9/qyNw14p+a+E7j921FPcbUkAvQaWyoOD9b0MAZDC7w095aGTIw8BGH4BWpaGDfPxMpCITpDpvk3iJSyBpLYSA/7vrJDg3E8YBJ9g/BKn4Yxuj7z0QrYqeICrWNV7YGEE6JwzZukuEmd7geQanSzeoTFjgGbjFBhaWfBe3aeR7AZXOPWZyLm2rVrW3TL3VsYBw7jiEu1h7apbT8DZXhi9WISbTcABRKwrafULElmlXzetuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4RVKC09QbiyO5TyommPFOgz+QTA7DIgLlbzCwSrZmxA=;
 b=cLVqgtJRgQooQWw2Mw2jg99gyqrX4guDiEq3XAu9qFw5nkolZgHuQhu4wV4RAclJeA0SNfTo9fsubs2LThfQt8RER7YL3e4av0eZMbnrNeuSXjmpj1X0inWOA30et7GYdmI/GyqpaWJfjo9HYrK9z5BuDbvWtIVAW4XGM9OXCoA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by DM4PR12MB7527.namprd12.prod.outlook.com (2603:10b6:8:111::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.17; Fri, 15 Nov
 2024 20:12:22 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87%4]) with mapi id 15.20.8158.013; Fri, 15 Nov 2024
 20:12:22 +0000
Message-ID: <2813ba0d-7e5d-03d4-26df-d5283b9c0549@amd.com>
Date: Fri, 15 Nov 2024 14:12:18 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Reply-To: babu.moger@amd.com
Subject: Re: [PATCH 2/2] x86: KVM: Advertise AMD's speculation control
 features
Content-Language: en-US
To: Maksim Davydov <davydov-max@yandex-team.ru>, kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, babu.moger@amd.com, x86@kernel.org,
 seanjc@google.com, sandipan.das@amd.com, bp@alien8.de, mingo@redhat.com,
 tglx@linutronix.de, dave.hansen@linux.intel.com, hpa@zytor.com,
 pbonzini@redhat.com
References: <20241113133042.702340-1-davydov-max@yandex-team.ru>
 <20241113133042.702340-3-davydov-max@yandex-team.ru>
From: "Moger, Babu" <bmoger@amd.com>
In-Reply-To: <20241113133042.702340-3-davydov-max@yandex-team.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0064.namprd05.prod.outlook.com
 (2603:10b6:803:41::41) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR12MB4553:EE_|DM4PR12MB7527:EE_
X-MS-Office365-Filtering-Correlation-Id: a2a7a391-1146-4052-3cf3-08dd05b1d057
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TzJDNEJaYWVPOFpVNHE0bjZmcHhReVdsQ2xDc3Juek1oMjRCb2tYZ09jaWpx?=
 =?utf-8?B?bmVzZCtUKzBpVDBqWmZkMWVzdzR4U0FpeWZ2eEVaUG96WlJVMmQ4RlZnMlF4?=
 =?utf-8?B?eHpMNjlSTEZRU2xTWGFmMlRwVjRYTGdhRFRsVWkvS3RiVUoxZllPSlpxWUVN?=
 =?utf-8?B?T2VOSWtJYW1IZHY5QlhXWlNSQWZqNlRRNElHUUoyN08wMzJxaHU0dlh0TlNL?=
 =?utf-8?B?ak1VSG9kcEJ0QjdmdlpGVWh5andjNDA4OC9VbHdRT2RndWg3UVdyVlZzZElT?=
 =?utf-8?B?c01hdDU3S3F4UFh5LytZR0d1aXdzeTJ1bm8yd21oc3ZGMmlFVmRhUjBvUWN2?=
 =?utf-8?B?azBEdWtPa3dGQjljQ05EckIvOFFtYlJ4MGEzd1M1c3Fham8zSC9FZFQvYnhR?=
 =?utf-8?B?aURINjFrTUMvMW9NNS8zUDVUVHdyRlUvUy9tVkUyQTkwTUd1NEtJbWFxYzZL?=
 =?utf-8?B?MXVBWW5xelhIUUdSTnJIVExvM0FoZ2dRdjk1UnRKTUd2blNPT2RrK2xURi9I?=
 =?utf-8?B?Qi9kcEUyajFRL0FHa3dMc01qUzRtRFNndEE3cEw2bGQrc1FvQ2VETklvc3RN?=
 =?utf-8?B?cVhPeDFnZ0lIMVJXNGc3TWJnMjVtOFB2a0t2QnlEaDExL1g2aTJ4cTdOMUd0?=
 =?utf-8?B?ZTVaNitIaFlRaDhsSVlaak16Ym9hKzE2cnVFMm9zSlZDa21ZMVQvUWhQSGxz?=
 =?utf-8?B?M2tTZWpQdjdyeHZYYjU5Q25nMzcvKy9pVE9ORENpaXZSRVZmQXFxRGpaYkE2?=
 =?utf-8?B?OURGbnZHcjNVQmV5VkVQdURXRldxTUw2TEVjUWVBWmVGVFhxcDZia3FSN3ZR?=
 =?utf-8?B?Zi8vbU9wSmEzcCtVQTJGUlVYQWl4aEFwNUdDRlM2VVdDNXVHOVd5YktWdzhx?=
 =?utf-8?B?cVU4VHFsc08xZkI4ZGNqK1Y1d1p0ZE1CRWlXQVZzUjQvOXg1NytzY2c5eGlR?=
 =?utf-8?B?YjRpNSs3RjVKeGlhMlA1UDJsSmJZVjdjZjRVQ0RKTXhBUjYvd2ZKOTI0bXNn?=
 =?utf-8?B?a0Z6bDBxT3FVcjNNdU9XdnVGc3BoV1VudHNyRGVoaENycGlkR3lkY1hyeTJH?=
 =?utf-8?B?Nlg2eWl1dElIWDJQMTRXR0tsck43VUZFVUdrbWdxSlpSYXQrVzNnanR3Mm9Z?=
 =?utf-8?B?MGNYbitIRnRNaTdLMXkwb1pDeGNvdC81Y3dzNk9nbkhlMCtSL0lhZ3YxRkpX?=
 =?utf-8?B?MS9LT1BGUGEvM3IxeXdkTWdGQng4L0JSOWQrUVM1ajRzV04zYmcyZkZVK3Vu?=
 =?utf-8?B?bUpVOHMyN2lpQ2xJNFJZUWVBMWJlZWxDbkJSWkY4QjNsbWNtSHdNcklyUzd0?=
 =?utf-8?B?TEdseXVOY3d5aG5UVzI0WHNRMHJ6eTRwZ3g2cVNjRHpJM3hEUjR0RE1MaDlF?=
 =?utf-8?B?YnZUOXRxRjRKQTh6aGJPcGhOSlpmWkpobXQ4L0U4ZlF6SzVJK3FiRXU4UVpw?=
 =?utf-8?B?N1Nhc3FWeVJuZkVzVXRMYTVCWXpGcU9RS3BMRzVZR2YraGxBSjMrTk9MM3RC?=
 =?utf-8?B?b3NHdllEb1RXTFVxTHhhS1hIMitrN0pEeUd3L3h3ZG1VblBONnpmL1BTeERu?=
 =?utf-8?B?UWlzb01xNlNxLzc3em40Q1lUQ2k0NkI3R2E4bFR2dnluSUlXSUhKT25zbzE4?=
 =?utf-8?B?Zm1yQXMzSjJTYURCZlFDdloxU05XQzBWbXFWVjVsaEVIR0JmT2gzK2NhM1ZE?=
 =?utf-8?B?aTdMUC9qcGVTUXFFYUNnV3BBOE9PYTcwMmVUMFZZYjZjSVphQmh5WkhscG1o?=
 =?utf-8?Q?au8GI4vhCoo7ZrHDOVail/1Ba/aZ82xpI/pfma7?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MExTbnZCV0oxdVcrb3dTTkZhdGJ3UVc0WmdNQ0dnZUc1N2xJSzBFejEzeGNw?=
 =?utf-8?B?c1VkVGJXaTkrRUhKbGNubGs5M1JvU3FNYnFsTGFKRHlKQ0dGTjc3cjJEWU5X?=
 =?utf-8?B?M05EODVxOXZkaDFSWTdUM1ZFcVc3Tng1WUxxTUloMC8xWS9CZUxtZlV6Misr?=
 =?utf-8?B?aVc0VVdIODcwMDRpS0R3b1JObjNhbTlKeXVDbk5hN1RkOHNBakd2UU40Z2Qw?=
 =?utf-8?B?ZXg3TzBldk1UQ05NK2xsUGJsa0J4bVlVQVNHdm00TFV4a054YmcvZ0dPemFl?=
 =?utf-8?B?TzQ3anJHenhIMGpYcENqQ0R0NUd1cVUyL0dpUUxaYWp4RktUNWU4RlowaCtB?=
 =?utf-8?B?TXllMXdWSzFVSmNqQ0VURDlnSTNZcDVjZGNVTDI4Z3lBbVhxMlNxVk1ENEI1?=
 =?utf-8?B?Rmk4MU5kbHVnL3E3WkMzTFgzNDMxaW96N2xNUzBjYUZDdTFhTjZNMDVFQnJB?=
 =?utf-8?B?cE5aRStGVVc2dzhQRnAva1JqK0ttUFk3blFNTDA3SHY4Qjl0M2h2aHd0Zkpv?=
 =?utf-8?B?eEZ3Q1d5UlAyQmdqMVVnSzlOc2o5K2V4WHBRQ3k3RFBMaGxKSWdHZjMyU3dP?=
 =?utf-8?B?akg2a1RwS284TGRTTW1IRGFUdUhMd3RGQTl0TW1FNTVjUTRUcXZkNzNHNUpV?=
 =?utf-8?B?TUVTMEUydkc5cVNWZDhNTkRRK2dnbGViQ09WcTl5R0drMlRYNWkrcmd5N0Uw?=
 =?utf-8?B?UkIwa0t0dnJNck5YdStXbmIvSm1Ka0JtYWFLdDhqTEdHZDdDVlROMHlwUzU0?=
 =?utf-8?B?c3d5UCtWOGp6NnBIdG96U1JFbndId1p5dzVlME52cFhEQnBFWVU2MXVZelhh?=
 =?utf-8?B?Wm01RXozeVBuSHBJUmlsM0NaTFo2enkzam5LL3dCR2RiVFI5K1c2dTcyeEpm?=
 =?utf-8?B?NHlRK0VhWm80SnNjaEpaQ2ZiYzRrQmIzZE9JNWlsWW1ZaDlzblFOdFVLZnF3?=
 =?utf-8?B?MkNTL3ZQd1g2R0JPTnpGZFNxMzN4TkFkNkNkRUxhNndLWHd1c0I1K2J3NVU2?=
 =?utf-8?B?L1Rib2lneXc4NW1Xd0V4OWlvWkIyc1g2UTVNa2NOVUlLYnNWY3BqTVdoT2sw?=
 =?utf-8?B?dGQ0ZjVjWWFMYUFMZkkxbS8xbFlLLy9qdzJna0NwajhnOGJheVBIRmRZM3ln?=
 =?utf-8?B?ZUlZb3lJaVMzOWhYTEpIVFBCUVhialdOMyt0Z3RHWi9xMTJqaFNVT292RFdJ?=
 =?utf-8?B?YWpmZEZWZDNVV1BodnBDdE8xQWRuTU5LclNPM1BwRVhsSmcwTXVhalE1YzZN?=
 =?utf-8?B?L2U2ZVo2Y3NwSmhyekU4NlJCb0VURVJCVDFhOEVHVS8zL2Q1K29LN0tSSUtm?=
 =?utf-8?B?cTlTNEpnYXFZUkZva21XZmRFUUViNVl6YWs1MFhDeFF3bnFzY05ZVTFTeEpX?=
 =?utf-8?B?dGFqZUg3QjlLQWxtRU5ueFIyRnBTcXJZRVRBbXFkZUpMWUNaMG11dTl4SDhp?=
 =?utf-8?B?akZmNSthWUsrRGRaL3gxL3BpUTltVXlvZUEvTTJ0MXNIaTlQbkMyT2RXVTZO?=
 =?utf-8?B?QmVKclV5V1p5S2VhOWg4MCtOZE5XcGNyb3prRkdNdmxIOHZNNkNMN25CS3kv?=
 =?utf-8?B?b3NVY2tsWUtHd1JkTjlXbHZhK3owRmFBTVFYZ1hYcWlxcEJvZmh6SHZPWTZY?=
 =?utf-8?B?NkdjYmZHR3FoaEkxMGIvTXdKQTJjaTdzbkREbVpaUjFhc2sxUzRhb0JBT09N?=
 =?utf-8?B?S3lOa2pGMzJDWG9mMW42OHpUSElWRTdZK2EySlBPNmZOanFUaEpsVlZJZWVs?=
 =?utf-8?B?Qk9xaVJKMnlteTI4Q0hTSkc3cnVkQmY3b0l2TjJQdVI2ZnhxNjI3UUE2cHlZ?=
 =?utf-8?B?czA5aXZ4dTFFK203Qk5kdG9MRlNqK0NOSitrTGg5ZVNmd2syajZYUDBJUHA5?=
 =?utf-8?B?NzZITFFoQStPdjEyT0VpZkM1MDhPeHRjNUF1MjVxL1A0cUI3cmgzbUR1SCtq?=
 =?utf-8?B?Mll5ajBjWFJNMHFhajJ6eHZJWUNjMWdBM1pTZ3ZUWW9BSXBady9QcEc1Wkpk?=
 =?utf-8?B?Q0w3dGtXMVh1Unk0V082UHlzSWcyV1FWSkpvMHB2RHRFeGhXckhZTGVOQmc1?=
 =?utf-8?B?MjZtME5CaHQrcnpWMTY0NWNHd0F4Q3hmN1RodUMvZGhMeUlDMVozN3hTZjNN?=
 =?utf-8?Q?jYJVl+fZ2009tFjPpeMRWTy8G?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2a7a391-1146-4052-3cf3-08dd05b1d057
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2024 20:12:22.1354
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vtGpe2DFirrR17S9oS9eedFCd5qC5bSvRjg1vZuXuwGUI60qYZA0bXbDPPdw2DSb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7527

Hi Maksim,


On 11/13/2024 7:30 AM, Maksim Davydov wrote:
> It seems helpful to expose to userspace some speculation control features
> from 0x80000008_EBX function:
> * 16 bit. IBRS always on. Indicates whether processor prefers that
>    IBRS is always on. It simplifies speculation managing.

Spec say bit 16 is reserved.

16 Reserved

https://www.amd.com/content/dam/amd/en/documents/epyc-technical-docs/programmer-references/57238.zip

> * 18 bit. IBRS is preferred over software solution. Indicates that
>    software mitigations can be replaced with more performant IBRS.
> * 19 bit. IBRS provides Same Mode Protection. Indicates that when IBRS
>    is set indirect branch predictions are not influenced by any prior
>    indirect branches.
> * 29 bit. BTC_NO. Indicates that processor isn't affected by branch type
>    confusion. It's used during mitigations setting up.
> * 30 bit. IBPB clears return address predictor. It's used during
>    mitigations setting up.
> 
> Signed-off-by: Maksim Davydov <davydov-max@yandex-team.ru>
> ---
>   arch/x86/include/asm/cpufeatures.h | 3 +++
>   arch/x86/kvm/cpuid.c               | 5 +++--
>   2 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index 2f8a858325a4..f5491bba75fc 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -340,7 +340,10 @@
>   #define X86_FEATURE_AMD_IBPB		(13*32+12) /* Indirect Branch Prediction Barrier */
>   #define X86_FEATURE_AMD_IBRS		(13*32+14) /* Indirect Branch Restricted Speculation */
>   #define X86_FEATURE_AMD_STIBP		(13*32+15) /* Single Thread Indirect Branch Predictors */
> +#define X86_FEATURE_AMD_IBRS_ALWAYS_ON	(13*32+16) /* Indirect Branch Restricted Speculation always-on preferred */

You might have to remove this.

>   #define X86_FEATURE_AMD_STIBP_ALWAYS_ON	(13*32+17) /* Single Thread Indirect Branch Predictors always-on preferred */
> +#define X86_FEATURE_AMD_IBRS_PREFERRED	(13*32+18) /* Indirect Branch Restricted Speculation is preferred over SW solution */
> +#define X86_FEATURE_AMD_IBRS_SMP	(13*32+19) /* Indirect Branch Restricted Speculation provides Same Mode Protection */
>   #define X86_FEATURE_AMD_PPIN		(13*32+23) /* "amd_ppin" Protected Processor Inventory Number */
>   #define X86_FEATURE_AMD_SSBD		(13*32+24) /* Speculative Store Bypass Disable */
>   #define X86_FEATURE_VIRT_SSBD		(13*32+25) /* "virt_ssbd" Virtualized Speculative Store Bypass Disable */
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 30ce1bcfc47f..5b2d52913b18 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -754,8 +754,9 @@ void kvm_set_cpu_caps(void)
>   	kvm_cpu_cap_mask(CPUID_8000_0008_EBX,
>   		F(CLZERO) | F(XSAVEERPTR) |
>   		F(WBNOINVD) | F(AMD_IBPB) | F(AMD_IBRS) | F(AMD_SSBD) | F(VIRT_SSBD) |
> -		F(AMD_SSB_NO) | F(AMD_STIBP) | F(AMD_STIBP_ALWAYS_ON) |
> -		F(AMD_PSFD)
> +		F(AMD_SSB_NO) | F(AMD_STIBP) | F(AMD_IBRS_ALWAYS_ON) |
> +		F(AMD_STIBP_ALWAYS_ON) | F(AMD_IBRS_PREFERRED) |
> +		F(AMD_IBRS_SMP) | F(AMD_PSFD) | F(BTC_NO) | F(AMD_IBPB_RET)
>   	);
>   
>   	/*

-- 
- Babu Moger

