Return-Path: <kvm+bounces-25240-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F353F962494
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 12:17:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AE0B6286834
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 10:17:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBCBE16C870;
	Wed, 28 Aug 2024 10:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2DMIzrQX"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2042.outbound.protection.outlook.com [40.107.220.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8490116C438;
	Wed, 28 Aug 2024 10:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724840196; cv=fail; b=AU72pHi4VgHf6/GBfMV7lEZp608FDmVkj1BZjcl/jLYJX2bWXpPrYHuBRR3QwTKoFPtxVs0FntzWVTBTq9qZrYBTdAtyJotRqYxdANLcbxy5V13Dfg8AaGaMGE9iXY8GDig7AU0vCvoGg86GwI9miwV6Bgn3r/SPZ3mp8SSnRbg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724840196; c=relaxed/simple;
	bh=lM3SbVFW1Ba9ayIu8VJ/OFJ2JtKVhXEif5utptXc3ms=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=INXOdNwpTWsAtQVrUE8OeNRwijxTNZsKHJoZsx7HVkyM+ly6fD5GPxQNPAzevoUJ1qUKsy4Pf5GqkxNpQnxLSW6W+Ugqu8fY3vA0x8h9bU/1B5coSd9TPsnvPI05Pvm7QZe2DbMQ5+V6rYZsVj8y5szEmkxB/NwnlDn2zXTRr9M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=2DMIzrQX; arc=fail smtp.client-ip=40.107.220.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fEY6E8PQggtyaNrP/AJGpH6/2aurzA8xLnXgI5OY9pbTuiKJvsPg2G9l/bs21zrXqwPkW7c/E19yU3PYxSjapV06NLl8Pab0Q60EufqkOcjVnIcyysWX/z8tXag+vmbtcGaVkRYeHvG5Y7+BplD9rHPdu9gP8Wc7cbOw2+dYjoOTD48ezFtkkODfqISwNJP0Nl6esbAhJrSbOjsfO7H1tmxNsupHDtP2qMCutkX3marvuO75WcPmI8Q+teIrqNYPWUQoOFsAouI30b/HG5mcX0cvpk/Dt2IjiH5vK4gXaF4/nMP6HbSqt4yjz+MSKU3S6pN/w314BOaJ7lK0hRx7PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GxMMvnuNvmjrBJ/+tokqev3ZrMpNptpr09U85QiopxU=;
 b=AIxnet0uQiYbk7gB+P83W26q32a/+JWixthQNHQ4edq4VJIwmw4T5RvVjwcCqW79Zk+lZQ4X8Nt0Zu5AdVWOGYzRtU5nVN4R2qQYLLoIb0YHCEzISSG1cpGsYh+fvje2DEZJg5lWXbLdXO14YSgueID2fra4SegVrsAfkYDcYT/1FBf8uZoqp3N5r6zkVbm012UcTA6RIGOFz/3Nd2ScyFx3S+d+JsZFemUqaISNh6m2V8fOzsxuZXz048P8nvffYazkX7E7tUZPju/VDvEoAihsqmixadd/QgC7g0upfhElV40UIjIgH+8tSo2hR8KgPwB5kzNeVHGQPjKtoMu8og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GxMMvnuNvmjrBJ/+tokqev3ZrMpNptpr09U85QiopxU=;
 b=2DMIzrQXhrBWSPIHiIgvEGiXFNEzUDcV0yrMUuKNSnuXe2wYHCzoaZJnd9vUkEhqKUr/74dEVDBz3XcekbfWqSFD3Ptl4Qyi7MtQZtLNHjN3KXApVdC9v4me8+zLCEDCiRs5cIEUyvBDDaYB2vRriU6j8x5KE9nS7HQ4TcASnGo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7SPRMB0010.namprd12.prod.outlook.com (2603:10b6:8:87::8) by
 CH2PR12MB4262.namprd12.prod.outlook.com (2603:10b6:610:af::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7897.27; Wed, 28 Aug 2024 10:16:32 +0000
Received: from DS7SPRMB0010.namprd12.prod.outlook.com
 ([fe80::b021:a6a0:9c65:221e]) by DS7SPRMB0010.namprd12.prod.outlook.com
 ([fe80::b021:a6a0:9c65:221e%6]) with mapi id 15.20.7897.021; Wed, 28 Aug 2024
 10:16:31 +0000
Message-ID: <94899c78-97e3-230a-a7eb-d4d448d9fa75@amd.com>
Date: Wed, 28 Aug 2024 15:46:23 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH v11 06/20] x86/sev: Handle failures from snp_init()
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com
References: <20240731150811.156771-1-nikunj@amd.com>
 <20240731150811.156771-7-nikunj@amd.com>
 <20240827113227.GAZs25S8Ubep1CDYr8@fat_crate.local>
 <5b62f751-668f-714e-24a2-6bbc188c3ce8@amd.com>
 <20240828094933.GAZs7yrbCHDJUeUWys@fat_crate.local>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20240828094933.GAZs7yrbCHDJUeUWys@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0097.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:9b::16) To DS7SPRMB0010.namprd12.prod.outlook.com
 (2603:10b6:8:87::8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7SPRMB0010:EE_|CH2PR12MB4262:EE_
X-MS-Office365-Filtering-Correlation-Id: 5cecbe33-0ee6-4b70-5e64-08dcc74a7cd3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?a0NBYmFVNXRtY09Pc05LRDQ1UlhPdEh2azZlTWthNWZkTFo5Zm9XajJ5dmNo?=
 =?utf-8?B?bHg5Wk52NDdFeG9mMzg5QnQ5a3RIdlVLNHo0dnQ5N0x6aGFRU29lR2RwTlps?=
 =?utf-8?B?VjVsTGVGUm1Rb0svSEwxOHFsUmg2VDZJWEFGNnZoYXBQbE10bmtzWXhteVI5?=
 =?utf-8?B?N29ybU9teVpXYkRKSEhYMUJLYWw4QzNLNUpjeDFwQ0czc3dXb2V1LzNXOGFm?=
 =?utf-8?B?WTIwVFlsMWNUUU42MmlZTmFBSGVneXArRGlQV2FmclczQjVmY3g3eHY3RlJI?=
 =?utf-8?B?YWdmWURxUFBXRHdaaUpkUnRzK0tTbDVMM1Y1QTNOSkFXdjZaTDY2TU1JWHE0?=
 =?utf-8?B?ZXlkc3daYUJDMHBuVEJaVG96MjlIOGJaOE9sVWVxTzBpY055OXFiam90RXA3?=
 =?utf-8?B?dDRuSTNhUldjVFJ2UEk2M0xsNGhLVlE0aGpnZlJxOWU1bWw3L2l1dDBzRllQ?=
 =?utf-8?B?cEtvL1B2YXJYUFR3OFhMZVFROUF2RnY3ZjF2OWkyMUM1MmY5MkZpWGM5QWhJ?=
 =?utf-8?B?MXJEcUlEYjg3ZDA2VHJEbkxLWFhPQVpuSXdzd21uY1ZROHcvcnlKYytvQlNh?=
 =?utf-8?B?clc1bXZTTG5Ib3hTb2xzYXZDMndKa1ZWeVlESk5vN25RZFRLQ083eHVhekVI?=
 =?utf-8?B?MnZ1U3gxclNnNlNKRysxYnRDMUdoVjhPM2ljVENVd3lPUHppMm9RT3JzVE1t?=
 =?utf-8?B?UlN6Nk9tYk5JNHdyTjJzcGdoZUdSbHJOeHVEa1lHSkVkT2gzL2ZiU3lvQUVG?=
 =?utf-8?B?djZHV0hOTEd2OFNRS3lJdGtRcVYrTkZTMXRjWTd0NS9tbkJvTk5zKytIUlRn?=
 =?utf-8?B?UHFmcUtFUGp1VkVZWTBRVi9GUFRONHFjbm1NRDR0Lzg3dnE4ZWZ5YzhNTkMx?=
 =?utf-8?B?NjdycGlDbWNnUGJEeXUzNHF1K2YzYTFLc3g3Z3NRRFZ4d3JLaU5EaDlUYkFE?=
 =?utf-8?B?dFF2RFhGRnJzV3FCWHovMUlXWWdVa0N5NytaeVhBVVVxMEhGK1JhbTgvd2E5?=
 =?utf-8?B?U0ZSRS8yTzJxaGFOTzZJSzR3b214TzVaemtWdkE1c2JHRTkraENYaE9hVTZy?=
 =?utf-8?B?U1BFTFJsVi9DRTQ0V3VWZ0VDK3VTRVd3SldyL1h5UUd6ckQ3N3hkeUhrQnR0?=
 =?utf-8?B?ZlJrcVZZT2pVTDg4aVgwUGZod2FSVUxQUlgvMkJBS2l4V0h3TGxtR2d2d3Jn?=
 =?utf-8?B?MXZnVzBwbkdua29CNWp3NDdoMStZWDZ2eCtLbHp5V3N3cVdBZmpzWUJGdTUx?=
 =?utf-8?B?MFRyeE9TV05kVFY1c2l4ZVVNRStJK3Rick1Wb3QyZGQ5ZzlZeDBWMzJiWUhI?=
 =?utf-8?B?STdJQURXdE02b2xJaXFqMG92M3pSOXdlRVZMeitqeDVFYUJFL1BvTVMvNVhJ?=
 =?utf-8?B?KzBaSmVmZUtCbTJGaGN2aXAyWEF4SjZPWVZHeG9YdVV2L1dPZmVnOFF3RE56?=
 =?utf-8?B?U3pxMndsQXJ6RkQzVVJaZklqSjJycENVQmF1a1BUQnF1cEFtL0tBcjhjeS9O?=
 =?utf-8?B?K3FGOGlydHNHQVJXS0k5Y3FlMHJhdW5jSGdadkJ0cU83TkF0b0VwNDZLdWdu?=
 =?utf-8?B?OE5lQmZxTlJmTU5tUVU5WUpKL0ExbEdTOHpmc2hBTm1ZZkdORC9OSllNdGlG?=
 =?utf-8?B?Sm1vaXRtaWZldGJHMGhJT0N4WjNVTzRVN3JpV0pld3ZEZW1UQU5aOTFDRUNz?=
 =?utf-8?B?eTJrc2pUUkNDSW8wTjJFKy9oblo1YXgzVGxMdG1qVUhyaTZ2OEo4MHg2RDI4?=
 =?utf-8?B?eVo3M29oN0RCVW9GY2NQR09TZFp4ajlSaTMwNUZtaHBYVVA3eHU2UzV3RjZ4?=
 =?utf-8?B?TEFydGZWYWZQS3IzMXpJQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7SPRMB0010.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N1YyWnBHemMzNUlVTGhKTGg5cFFqNGVUS0hrZXF0R2FMSG0yUERmR1FVRWYx?=
 =?utf-8?B?OFVNVVV6NDdSVGhuUHRVVWVSZVMrRGtscFNyaVlwaDVUbm9EamVnWXhocWtO?=
 =?utf-8?B?aGlZS1R6K3hlMWNsM01zRHFDNzFaSHJsODVOYjU2TUd5cE45VkpCc09nbXdj?=
 =?utf-8?B?dmhhUDVuYTBieXgvWkFmczJZUDNmK2Mwd1E5VHFiaGxNejJIL3N4Q0tINGQy?=
 =?utf-8?B?cTc3MW00VDVhSGE1OHc4TnBoOXhzR0YzbFZCZHg2aEs1UkZPWnpaaEphRTRa?=
 =?utf-8?B?SDRibWZxMW9GdW0rYmJiYTZzWWJQQWFPa3RYdkRMZnZ5N0dHdGsrMks2bWNF?=
 =?utf-8?B?SUZVRkgwRjlScEFhTm9sM0JuWFdmdTU3anUrelNKWVJCaStMS3F2bHVqYWhy?=
 =?utf-8?B?Sno0THhqcGV4aGZYK1ZZWlhTS0JtSk14cGF1TFQraVVFZWpDMkZiSjY2citE?=
 =?utf-8?B?ZXFRRHpjUklWZFZXeXorenNFZEhibFJXSXVmek5kbzVWbDRpT0czcE5vVU1E?=
 =?utf-8?B?MGF0QnZtckJLcE4yU0w2NjVMS0ZyUHRaaEFPS3YwSFhJY0R4S1lUQ1dteHpo?=
 =?utf-8?B?RFJzTVZIZGpaSEJWeU43QzBVNDFSVVdBM203K3hLU1d4WnVRSG1Oc2VuUTdv?=
 =?utf-8?B?ZkQ3MkxFQmZ5a0JkN014eXk4SGhoNlBXZkg3VndicHRKZ3ozZnhYWW1VdUFi?=
 =?utf-8?B?U3JwT2FENmg1eWx6OEpyUVRublphWTV0TU1JN0RGcnRWQ05ESFBMRk9ZZ051?=
 =?utf-8?B?ZEZhcnNDRS96T0UzV3VqMVI5ZUxEUElNTFEvUmNiZHBPcFM4STRPalBPckxK?=
 =?utf-8?B?N1YycUF2NTZuUlo4UmszNWNoeWxDbzF5Q3RVbExhQTV3dHZNa2orNHpZTTF5?=
 =?utf-8?B?c3ozcXJYdFM1UURyTERnejdSSkdUQTZTR0thQURsWit1VjRuZkFuVStMM3JY?=
 =?utf-8?B?Qk0yUytwUHVLRmxmTFhSOTFaaUtLWmhjdGkwVU5WS0ovaHd4bmhpa1VDcU13?=
 =?utf-8?B?SHArZVBwSHdPRDFjbVZCYWFEa1l1MnZla3VPUllmUk9ZMDlya1p1MGlDT2dK?=
 =?utf-8?B?VEpTNUNvRW0renY3clNXZWZLWko5QkJic2g4dTJTZncwZ1R2N1ZWZ25VTEZO?=
 =?utf-8?B?b1dBMHFENmJBNk1iRGhiTXlhRTBOU0NiTGNhYzBSVXF6Sm1xLzV3MU9TWktV?=
 =?utf-8?B?VDNBYkNGRlJ6VzFZK2tvQVlSOHV4OXJJYWRZMHErMGQ4WG5VQzZEdk9ESHha?=
 =?utf-8?B?TGFLdjR2VzFPaGt4YWthMG50Y1FocVNyVmxPTkJNbXVkeE0veENVNVZkRUky?=
 =?utf-8?B?U0N1RWp0a3RjZzBEbmw2ZUtNMUk3ZXB6Qi9lSzd5MUFkcmdmbkZxa01XRUJJ?=
 =?utf-8?B?QVFPNGdrc2pLSlpFZWN3T0JTVGcxZU4wangxT0NPWkt3VmtCOUo5QnB5aWxv?=
 =?utf-8?B?NDhWSkJPbFpFbWNDQ0dxbThkT045cGlMS2Y3SENjNklLelMyazVGbUFjMm4w?=
 =?utf-8?B?YjBSd0Y2aklMSEUreWpWVk1XcGZ5Y1hPcGFrS09RSnNaaVRIWVg0T0FPQXhV?=
 =?utf-8?B?VUlYelhRNXp3TGFxdFpiUzhlMzR0dEdrV2NmM0YzakowS0FPTFgzSHZ5dllD?=
 =?utf-8?B?WGgwdkszZ0xjSmlQZDBEYmtpMkxxTTVrd2FONEhVREg5OU9CQjhXWm9PM3Fi?=
 =?utf-8?B?NERYdUlSTXdyMTh3T2dsNXdBa25GUWpqbTFPMXhPZEZwZHRRVnRHS3lUK1Z6?=
 =?utf-8?B?TC9PQksrYnRxOWE2b1F5N1RTcU5vcUh3R1pob3p2M1BnTnAyeloraVJIdGZN?=
 =?utf-8?B?VTR5aSsvbUhpNWpMUTJSUGlvVzUrZTNhTEJqWndIcEpQSDZwY1F2NXBPNjFQ?=
 =?utf-8?B?UVdpYlFhUzRZSFZIaWdIS3ZHVTJST3c1NGFBL3BBZmhzaHJpMmVqdFd1TjVE?=
 =?utf-8?B?WlJ2bElZb081NUlZOUsreGxrZFhWbGpOcEdqcFFSRWxxS0pRVW9MbUpYdkdX?=
 =?utf-8?B?eTNodHdGOFozekFzT3pNSXp0RWFrdkFiSFN5V2NsclIxTHNCZ1djUm9YUUVz?=
 =?utf-8?B?cUFKbkhKekV0dW1IUVVDbEU2dGc4NlQ0M09rWUUwTzhmREpBMUpuMGcwSUVX?=
 =?utf-8?Q?0h4XkHZes2GwrwrhWstLfOtXz?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cecbe33-0ee6-4b70-5e64-08dcc74a7cd3
X-MS-Exchange-CrossTenant-AuthSource: DS7SPRMB0010.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2024 10:16:31.8757
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9Y6BIXOQgzZ9KWFptq+ubVrFDK8v30k5sm4fq3ao7kt5LV+wpVKiuPzKr39pxwRD2hXPP3ugjXCNPEKr9+TQmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4262

On 8/28/2024 3:19 PM, Borislav Petkov wrote:
> On Wed, Aug 28, 2024 at 10:17:57AM +0530, Nikunj A. Dadhania wrote:
>> +	if ((snp && !snp_enabled) ||
>> +	    (!snp && snp_enabled))
>>  		snp_abort();
> 
> And which boolean function is that?

Ah.. missed that.

>  	/*
> -	 * The SEV-SNP CC blob should be present and parsing CC blob should
> -	 * succeed when SEV-SNP is enabled.
> +	 * Any discrepancies between the presence of a CC blob and SNP
> +	 * enablement abort the guest.
>  	 */
> -	if (!snp && (msr & MSR_AMD64_SEV_SNP_ENABLED))
> +	if (snp_en ^ (msr & MSR_AMD64_SEV_SNP_ENABLED))
>  		snp_abort();
>  
>  	/* Check if memory encryption is enabled */
> 

Do you want me to send the patch again with above change?

Regards
Nikunj

