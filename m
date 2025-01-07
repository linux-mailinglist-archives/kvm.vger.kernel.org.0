Return-Path: <kvm+bounces-34711-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F096A04AB6
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 21:10:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C42EB1883859
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 20:10:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EFDF1F63E3;
	Tue,  7 Jan 2025 20:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="D6CuFGgC"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2072.outbound.protection.outlook.com [40.107.95.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C0738F6B;
	Tue,  7 Jan 2025 20:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736280609; cv=fail; b=LaORmujmlwjQ3u2b4NYOanmKa1LuNLnDWsrtNBdhS5x5JWR7l5TPLKr6CO3vRN33F1Sh0zVP8MU94FEeFBwQHA6x67e2h9Q2DS7m2Qj5Edd43uYmMju00m7ilwwi0/2FptgQtJ2nb1UhBFOgLqdonXRubr9i62MkQUf2MzFhMQ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736280609; c=relaxed/simple;
	bh=eHQovCBVDkmgbX/U3gzktldGsnRu5FMAzDLWGwE7WCc=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=qULruQf34W8RZGI+yaebgOxhG5XaZCqM2k5kd2iRFdw+gz+JEJL5bjAvziqnRPWXVouiAc4mN93vE0qPGMrtYmCijDPl1PVX64dzclo/TqCy1pqp3tP82DCKnY4xouhvLpsn2eDSytuXTDeezXc7l15QtpgblmpfNXMHSduxyOo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=D6CuFGgC; arc=fail smtp.client-ip=40.107.95.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w47Id+bt8IwyzzBWdhSCh/EuLyr0MhC+jo/uhhAO56/3SrMZc9R1dMWZSxYNp3AN35A3s/UwlsnhfL9FAHZlgUhjlZ86hdMbxQ40KIzmdti9ZdXU2k200ZFA0iuUGEcltlYldZhhavRGeJ3N1IZ4AAjSCa7IWU0AdImrf/8witgw4BMhiTxXhbYiST9oeGcaTEfVTxspmXnCqVtQQfYsD26aZaN27SVKXqceCa4b/dVLY7+SJdISQB1RgwU3x+C0L94I2FTged610VbyiizSgL+fzFaZMlsXBSgT92+FmPuiw3Ek3kDjSmaUdoLQ7Yy8jY9fXHMUqKDt+n4qcaRpTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ih2xskXXa5itEK5q4K7T75g5n+RRTDuwKfTZ302iuIM=;
 b=r2QUpPgBOyncNTUSPVwX1xi+wPdoQqKT5zWOoX1LU4sG2ttCpcsgKIxpNnKKZfD6bwUr4IoQFX3feOBQsViBo+WqxXY0wGaiQQ0Vavru5GATgyXKlyQNowVREH3zvK+vktoddUgCinF6hVylCi0YIR5RCa+csi36KUfRhFFhzsgeiYUNPYGDmPSRw1quGQpCret/fy0gK7yrmOvUl2rooGhowg0/e6uGDuu5aH4+8Q1+PxB6zZfCA3EL5UsBgGFGp3YhmmEx76HWqL94Jz2v484Pmdn8wKKqaMsOVKJsrvuWwo7pjKCGPZoBlxLIywYPxt3anWEPLM9NpuQKldXmrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ih2xskXXa5itEK5q4K7T75g5n+RRTDuwKfTZ302iuIM=;
 b=D6CuFGgCNsXNsdezQf0Lb7cMbCCdX/zaJD53YXntEEwvGdnCi6LZxQT7yZUrVK+rM+0ugpzyZlO26IU7ebK/wmakHntru/EOD46CAFgPVI3xMXjmDp+tv6BUVw/3C6KaSDipJCTrXkwbWTJQ9gMW8gz40eCpxrbZAKAnMhpCOmM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DS0PR12MB8069.namprd12.prod.outlook.com (2603:10b6:8:f0::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8314.17; Tue, 7 Jan 2025 20:10:00 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8335.010; Tue, 7 Jan 2025
 20:09:59 +0000
Message-ID: <a3d19b63-e153-3693-f5e0-353f955caa3d@amd.com>
Date: Tue, 7 Jan 2025 14:09:57 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 bp@alien8.de, x86@kernel.org
Cc: kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com, francescolavra.fl@gmail.com
References: <20250106124633.1418972-1-nikunj@amd.com>
 <20250106124633.1418972-7-nikunj@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v16 06/13] x86/sev: Change TSC MSR behavior for Secure TSC
 enabled guests
In-Reply-To: <20250106124633.1418972-7-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0133.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c2::18) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DS0PR12MB8069:EE_
X-MS-Office365-Filtering-Correlation-Id: 64781e12-65d4-4f14-6286-08dd2f57434d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?N1RCVWhrUHpyR0NTNWs4Tm9GWTh4UHFIeGIzMXp6elNpSzExeHRwbGpvR1M4?=
 =?utf-8?B?MTJsa1RMUjREZk5OeTh3OXlaSDZSTVJUWnhZRFVxN3pHOHlHdWI1QjhCb25K?=
 =?utf-8?B?STJqb3hleE42WUs0ZUxDcllyb2xUa0ZXclRvRnpQYTdkQXNJUjJOcXFMSFRh?=
 =?utf-8?B?Q3VIa0k1REZhcy84eGU1U3VRZUdCV3Q3NkFVZWhVZnV4WkN0L08vMlpLTEZN?=
 =?utf-8?B?SmdJcHc1cko0YnQzMm1lTSt1NU51TUVUdnduaU5ab1RRcm1kRmFUYzJncm4v?=
 =?utf-8?B?bm1mQ2JxanlXL0FxSFU5YjdpaXRrTG1UdGZMYVRoM21lKzh3VjVRWGtrTUF3?=
 =?utf-8?B?Z2FNK1NQOFNGT0ZROHFEOVU4Y2xDaEFVSGsyZ2N3RzBId2ZjbDBQTXlpeVBv?=
 =?utf-8?B?SnF1VkxkZlpucnh6N2pJdmY4Y0JXeC9Xb3FSWkZNb05pMlJEQzgxYmpaK3g3?=
 =?utf-8?B?SktQaFNFR25mUWlRSEovMy9OckxBeWxWaytJN0s4aWRUOTNaWE1tVXdUNVlL?=
 =?utf-8?B?NXRIOFF2MHZ1Vm5mc2cwbzd0czgzbm1oYjBpTTRlK1hjdmxCRlRoNjBySHBD?=
 =?utf-8?B?dWlKNnVHOWJoSzNQdDBObjR3QlhUVkJtaDhJbENBNFQ2OTV6bXpUM29vT05w?=
 =?utf-8?B?NmhqakdQcHpyVFFRN1I5WVU3ME5QUG1od1JQeFlpWms3S3R5a04xWlhZVms2?=
 =?utf-8?B?U0NXRm1HcnIyblg3dUM2eVdpSGx3THp1dzljVHZmWEJBUWtGVm0xTXdwVTdP?=
 =?utf-8?B?YWhnNExGN2tZd3hZRndLc01QRjFKNlcwa2RoRHhZejJzUWJCR1FtdjZpZXhR?=
 =?utf-8?B?ay8zM3MzdkVkQU5ac3BubS81YVZBWVRkSEF2TmlqaEZUdkhBK2JFRGpVZGkz?=
 =?utf-8?B?UG9QRGNUQXN3bGJlTWVrTTQ3b1RTOTBGblNYaUJuaFdwRmFnU0pLYjB2aVZB?=
 =?utf-8?B?T1ExbEo1RURVenhrNzliaTMyS2V4dSt4cHFERWVDdTlGa2FIQ3JHcTJ4OEhp?=
 =?utf-8?B?S2JZYmRtSS9UOTZwcWFFOU50TU1YTXFvOUJIcXZodTkwbDIyTC9sTGNsMVVs?=
 =?utf-8?B?U2h1L2dXQWJseGFDNFlWd3d4T1JubEpUakZwNDE0T01EUE9TWjhtUlNwUU82?=
 =?utf-8?B?ZEJ2UUp3amVHcFVEaDE5UWNaeElSTS9WWVFZY0xIMlU5QVF3WVhZUkw1WGFB?=
 =?utf-8?B?RnV2OWRVcTZTb0pOVEVkaXpIQitLTlVZVlNQdFI3aXRGZlRWWlJHTng0V3hG?=
 =?utf-8?B?d2h2dTdLWkR5dmVUcDhJbzBJQWYyZkZYUGxYN01ob0VrbHlpNGVHL2pQcHlP?=
 =?utf-8?B?OWZnR21VaU9HUmxJZ3h5QVZYeitiWVlhUFJpYlJrUTJoQ1Q1RjVweCtzUDVs?=
 =?utf-8?B?L3QwakJkR3VVbWVMa201RnZZMkgrY0w1cU9FTjdsYmtOaERhOVNRdUp4YUVR?=
 =?utf-8?B?UDdYNFluTm5VSmpPTVA5MGV0cnpnQXEvN0kvTXUrUUprSXJyajVsZjhVN2pN?=
 =?utf-8?B?bEFTc3FsOUpaeXhvdkdaeXdoR014aHpINGgxZk1ydDJNNFZEYmtlcWpLbi8y?=
 =?utf-8?B?bFJLNmlwS0htZzRESE4yeEN0djRKWmd4ZWJJMHZoTlpmUmpzbWxNeTh5Wkt2?=
 =?utf-8?B?TGI4ZnFNTTZRUDFSdHFFVzVLWURGYUVBK0RWTmFXNUJwSzRkcTJiTTlqS3d1?=
 =?utf-8?B?aG9CYm94WGdzSkw3MSt2L2NFVUYwWVVlOVBvZkJKN0s1cXpDSW5RS2V4Q0JR?=
 =?utf-8?B?cjlib00vTENHWDZob2RKZVd0U2FRMFpVNHlCb0hhNFFYOExDS0VCSHNyVGdv?=
 =?utf-8?B?QzlnSk9WOC9LWWxxZC9NZXhXZFdsWWJWNGZMMGl3VGtrdk9DZnJiTjlTSi9z?=
 =?utf-8?Q?qj6jt5hyF7cCe?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?djRNTWVNK0lzRjA0UFB0YjNRVXoxNytNUDRuNmtHSUNYZkxMZU1KdWVFTVF5?=
 =?utf-8?B?eithdlJ4SldzeDhQZ1puWUtDWk1UMWJRQWFXR3h6OXBFZEovcVNRbnpwNFg5?=
 =?utf-8?B?dzI1dDUrZ2prMXcySWpoaXVQZW4xNzQwYVdROHRPZGpoTmU0Y1VDSTRGcXlX?=
 =?utf-8?B?aDhJYzFkTUVmcXpHenAxTzhuMGtrTlQwanJYdXRDQmYyUm0yT1BXMktBam1p?=
 =?utf-8?B?WDdSUEhTSFJWNWdDVE9nZjNSTk94d21FaVJWcGNLU0Y4UW1aaGpUc3cxQ2kr?=
 =?utf-8?B?TEUzWGZLSDRXaEdaM3Z5elZsOFNBeVplOVd6ZWxNQnJNTE5GMC83S0ZNMGZX?=
 =?utf-8?B?MklZNEhrcVhGcjFjMEplUkQwRVIzMm1IWFlHYm1OaVhuMDRNek56NEFNTTQr?=
 =?utf-8?B?RGxiN0R6NmpGazFWVnc2WEVwVUdLbzFnbGxUK1lzTWNIa3ZyY3l6ZXNuYVV4?=
 =?utf-8?B?SEl0YWVFWVpEeXB2Sis5RnF4akFubS8xUHJCUXVxTXc2aDdodE9FV2lsTzJH?=
 =?utf-8?B?d0NIeVlobENMRzhIZ21KaDFmSjYvc2tlamYxN1FVaE93MExTTjhwVW5FRzVD?=
 =?utf-8?B?Qy94dWJ5L0puNURjYmlQRTl1bTA4Vkh1TWd3RjZtd2hXaVlha3lsWUMrQkVa?=
 =?utf-8?B?Y0RrVkJINGd5RnVsaU51SnY0dTZHVTZDOVluQXpnVENwQkxYbzJpRkE2bTBj?=
 =?utf-8?B?Q0NTR0hKNjQ4ZzV4NEpnUlNTZlh2NmtFSkYrQ3FaYUVaeXF5b1hBWUd0ZlV3?=
 =?utf-8?B?eXVJaVI2eE55K1NFM1o2ZUNUN1duT0hnbGYxeDV4dVJGNW0wc1ZMYURtd09F?=
 =?utf-8?B?bEFVWGtsVlJTNVo3V2JPbzgreWl1V0VpeVY2dDlRMXlzWkNtNjZwem0rbVJx?=
 =?utf-8?B?QjcyVmpTbWNtZm1QcXRodVZiVnMyejJnOVlSREpzZHhqTTJrNTZQdGtOUnN2?=
 =?utf-8?B?VHpMRmNkMS9CVnQ0Yi9vUTZoT3Q0RC82K21Zcnlyd2ZzV1hpb3MwK3VVK3BG?=
 =?utf-8?B?VHNCa3pPKzVxRDRvZVFBcjFMbHZ4UXB0WkV4dEZPbWZLOCtIdisyYWVaZFJ6?=
 =?utf-8?B?UnFYb09Bb0JDQzhoMkltUkV3SXpPTlZ5dzNqRTJ1QUVIK0MrcnB6c0tjK2xu?=
 =?utf-8?B?K3hialVUWWRxeWhVVnRzcXlNVVpKUWhvV2U4dzZYRnp1Q2p0L2UyV3BwY3Uy?=
 =?utf-8?B?MTRiSEV1aldzNUVnL2dXWXBYS1NXZkxHZzBEbERSd1oyazdwbm9qY0JqNlhP?=
 =?utf-8?B?ai9acE5YcjUyWUtma2RsUC9sVTRpTUNhR1hKY1ZFMXlzeUNERkZjWENiTlRk?=
 =?utf-8?B?TUpZT0I2MGtCbGtwbEVnS0wvNFR4K3Z3L0RYNThCcFpmQ0ozanB6WnZ1ZEkw?=
 =?utf-8?B?SS9wS3ZWU1I3UUxRa0JBSm1ZQnJ5a1dlN0JOQ01ITUM3U21SWXVxYTcyZHhQ?=
 =?utf-8?B?NUQ2a1VTOTdWdFhwU2ZkK3VkcjRzTFUxZXdQK1JISktnR2phclRQR1QvYUY1?=
 =?utf-8?B?S0J3ZmdpL0YzZjB0UFNmVDZPczVMS3h4WDNmdm13V1pyUEtaV2VsUE12TWlX?=
 =?utf-8?B?bi9oV3VhQnYrQzhGZTVWOTNPUk9sWGRPTWQ2VlJ2aFFma2VLZmhVWVUvbllW?=
 =?utf-8?B?WUdmcEU1WnljK29NUzdRblBya09hYXB2U3ZXMmhDcERqL1dLVTJpRVArbzVG?=
 =?utf-8?B?QWdJcUhuOUl0YVRnand4d2VoYmFYaGRBMkhoR0RLVlQxNkltWTE5NHMxWXpm?=
 =?utf-8?B?cGhxWC9pSFplbFpVNjY3RzltTDJrcG0rZHVSMk1WTnB4MDk0MWp4T0txVGJ0?=
 =?utf-8?B?MU5LeGVIa0h1U0x1VW9qWWNBbndvTUFnK1FKT2x5aThjVTg2MVF6TS9rY0Zz?=
 =?utf-8?B?Uk9vajNra2JoeFRGZ3MyZUYxTStHQS9velFkRW85b0VZZnB5UDJJb2M2TTRW?=
 =?utf-8?B?TE1hWlhJd0t6MU1QejBQVHB0cFM1Qm1qaUxnMzU4VjVaMHBQWDhUV1JEVjA4?=
 =?utf-8?B?LzgwSHZTTmkrRW1NU2g1dG1ScEtXbWRCTGhvbVNxTDhENVorc3p5dDFEZE5Q?=
 =?utf-8?B?RHdObjcwdmllZWpwRUZEeURIcU12ZzFDSkdXaXUwa2pzQUtERzZWZk42S0NZ?=
 =?utf-8?Q?Edg7B67OFxalaM+JxJxR5B6VO?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64781e12-65d4-4f14-6286-08dd2f57434d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2025 20:09:59.5754
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pp9QA+QnRbSfbPEwI0XG8OcbOMxDn9g+I0roNq8DfoUXtx5wm7EpXMtYhksjjR4aQgVyguIIsWxQtznODUHuyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8069

On 1/6/25 06:46, Nikunj A Dadhania wrote:
> Secure TSC enabled guests should not write to the MSR_IA32_TSC(10H)
> register as the subsequent TSC value reads are undefined. For AMD platform,
> MSR_IA32_TSC is intercepted by the hypervisor. MSR_IA32_TSC read/write
> accesses should not exit to the hypervisor for such guests.
> 
> Accesses to MSR_IA32_TSC needs special handling in the #VC handler for the
> guests with Secure TSC enabled. Writes to MSR_IA32_TSC should be ignored
> and flagged once with a warning, and reads of MSR_IA32_TSC should return
> the result of the RDTSC instruction.
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/coco/sev/core.c | 39 ++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 38 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
> index 00a0ac3baab7..f49d3e97e170 100644
> --- a/arch/x86/coco/sev/core.c
> +++ b/arch/x86/coco/sev/core.c
> @@ -1428,6 +1428,34 @@ static enum es_result __vc_handle_msr_caa(struct pt_regs *regs, bool write)
>  	return ES_OK;
>  }
>  
> +/*
> + * TSC related accesses should not exit to the hypervisor when a guest is
> + * executing with Secure TSC enabled, so special handling is required for
> + * accesses of MSR_IA32_TSC.
> + */
> +static enum es_result __vc_handle_secure_tsc_msrs(struct pt_regs *regs, bool write)
> +{
> +	u64 tsc;
> +
> +	/*
> +	 * Writes: Writing to MSR_IA32_TSC can cause subsequent reads of the TSC
> +	 *         to return undefined values, so ignore all writes.
> +	 *
> +	 * Reads: Reads of MSR_IA32_TSC should return the current TSC value, use
> +	 *        the value returned by rdtsc_ordered().
> +	 */
> +	if (write) {
> +		WARN_ONCE(1, "TSC MSR writes are verboten!\n");
> +		return ES_OK;
> +	}
> +
> +	tsc = rdtsc_ordered();
> +	regs->ax = lower_32_bits(tsc);
> +	regs->dx = upper_32_bits(tsc);
> +
> +	return ES_OK;
> +}
> +
>  static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
>  {
>  	struct pt_regs *regs = ctxt->regs;
> @@ -1437,8 +1465,17 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
>  	/* Is it a WRMSR? */
>  	write = ctxt->insn.opcode.bytes[1] == 0x30;
>  
> -	if (regs->cx == MSR_SVSM_CAA)
> +	switch (regs->cx) {
> +	case MSR_SVSM_CAA:
>  		return __vc_handle_msr_caa(regs, write);
> +	case MSR_IA32_TSC:
> +		if (sev_status & MSR_AMD64_SNP_SECURE_TSC)
> +			return __vc_handle_secure_tsc_msrs(regs, write);
> +		else
> +			break;
> +	default:
> +		break;
> +	}
>  
>  	ghcb_set_rcx(ghcb, regs->cx);
>  	if (write) {

