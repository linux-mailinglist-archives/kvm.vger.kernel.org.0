Return-Path: <kvm+bounces-57136-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CAF5B506AF
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 22:05:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4E76C3A332F
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 20:05:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA792305976;
	Tue,  9 Sep 2025 20:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Pz78FmLO"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2081.outbound.protection.outlook.com [40.107.244.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F4F1258EE9;
	Tue,  9 Sep 2025 20:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757448298; cv=fail; b=CvQKKXNSPlpp1PPOcMS64ngHhduCKrSUJSbz6eMAuMMUg+xsvLN0F9r9FWLK61YQKbxGj5XvhcwKnsggJudPO/ZFyt55+eOo/4EHE9xdVuKlryns83OBZpZiWjMTCywxIExzbCY5ls6VB47Hf0+weA+7rpLdb/waNvvek31+fe0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757448298; c=relaxed/simple;
	bh=HnKYOTgrX0s/0dUdxdWK/LOYTd8dNYErOAeOpSgy2Sk=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=jlXrQIfd0XKeptnwv/Xnl8pxXw9WXvCvC+39im9eNnmXcHPu47x8cAcX2e0v6/OsTQW9G9y+JzAvWKFAvZbkDKE1wJ2AeNskOuabMdAYQBx9N08V3EsAm1nj1gkwYMeW+odmFpydRRHjlEsE/j4AGXjUzBOutgQZls49wFMvSuU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Pz78FmLO; arc=fail smtp.client-ip=40.107.244.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aQi+Me0XUNWDb8TvXM8X8n5EkpOVn/nm/V9cN4mgeROPoNisSlNURwzywnpzEOiEDfkGzJrOW6YwzBzd0RUtz+a9cjLqC4na5EJ4Vf6kym2YCJMlhejlIzRH418jaewtXz23EHji5vv6iCZlWsIcfreTdXwZAO4ppWcBcyoPOPMeDDLh/pdZM1FRmqBrfM/d69b/ecmsvmBOlwhDmxc2E2VQtgFzyedZJQ7lvs9saSIy7JpOwaAB7xY+oezZpW5Mq5vkZVkaboVZbiMgFC8KKn038XTwGBmr81dg6UqcfM3QvFJwoMqmXTmD2MAtwC7Sgk1o1NpW1zq47WcFmr98fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fxwfjn5l8QQFa6OCuOelcbFxiHPPoWIlgv4sRJWu0Do=;
 b=unOQvjf+0vwwaQcZm+W9+PSLSYgWyZH1V02h1dv0ePIXmGTsA5SUthDY9n3EOYI6IrHYeRPiZeyR0DUb5AhZKfOsrOnDoVJ3LBjD365O0iCu5lGEQv0ULtQSRlogepOCckl1mK+Zglq6DJeUae7WfOwUHl10J141LOy+6pVhzXvqq6lg7LNLv/g01twCsYY86SWnQohBFduWhFCOqIHl9MU2tIVM0fbiRCM5aXA5P0pJSpQlfMG2f7UmkivSKd62kvVbPn2fLF0c9crKfEP6lvDeWcgbzTJtgFRWrydQVtHB7c6Onf5M67mv8kyywoeb7ulEZPEyHSrT15YN0J6kOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fxwfjn5l8QQFa6OCuOelcbFxiHPPoWIlgv4sRJWu0Do=;
 b=Pz78FmLOIS6yQEr3uUX5TPBbvRqahrRvC4rm17SfwBPbqrVOK6YflsxtdHTDdjuT4VQZ9POwO08QB6016ScQGCID4NfCIcMxInIt/jT0SHk47UTyDHNq9h+/RgLYnn9hQ66y2lGr4laEwSIJqW/qlTfS4CUP6ULigswg66aVPtE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CH1PPF9C964DBFE.namprd12.prod.outlook.com (2603:10b6:61f:fc00::61e) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 9 Sep
 2025 20:04:48 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%3]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 20:04:48 +0000
Message-ID: <797c84fe-aec7-3e29-a581-d6d1a3878aaa@amd.com>
Date: Tue, 9 Sep 2025 15:04:46 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: John Allen <john.allen@amd.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, x86@kernel.org, seanjc@google.com,
 pbonzini@redhat.com, dave.hansen@intel.com
Cc: rick.p.edgecombe@intel.com, mlevitsk@redhat.com, weijiang.yang@intel.com,
 chao.gao@intel.com, bp@alien8.de, dave.hansen@linux.intel.com,
 hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de
References: <20250908202034.98854-1-john.allen@amd.com>
 <20250908202034.98854-3-john.allen@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v2 2/2] x86/sev-es: Include XSS value in GHCB CPUID
 request
In-Reply-To: <20250908202034.98854-3-john.allen@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1PR03CA0004.namprd03.prod.outlook.com
 (2603:10b6:806:2d3::8) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CH1PPF9C964DBFE:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a0c750b-2329-434b-6694-08ddefdc211a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZlY0VVJGMTArNktDa09ucVBaS09MNXVYSndoNmpKcStldlE5Y2FvamNLZHRv?=
 =?utf-8?B?dFpkTlUxUXJVdGthMnVKSWM5UVNtZm5SZ01QRzdsb3liYkVGUHFySXBrbS9p?=
 =?utf-8?B?ZzVJUlZnemRYODd4WG5xRHBFYXNtMWdNUU9GSGNPbmRRQUY0dGljdU41dW5X?=
 =?utf-8?B?aVR1ZndJdVVJQzlvVnE1OVRteXNoaGV2cFAxZ3BoRFZ2U2dUSmx5OUxtQjZv?=
 =?utf-8?B?Mzc4QnRBeEd4T3QyeEZYZmIxL1E0UGplNUFGby94QmIxajNDZ3pGQkV3QlNz?=
 =?utf-8?B?c09xSnUzRHh4K1pmZmpVNU5sTEdEUlNLVHFteDIvY3FzUW5qNG13Tm45YVN5?=
 =?utf-8?B?WFhtVEgrK0ZZS1NkMmdkWGtBTlIvZTlSVnRTYlVwZWtBV1d2SHU2a0Q3NURL?=
 =?utf-8?B?VEV2REp0eGJKY2g2MFBTcVU0dXhEMEtPUnorL01zdzlpQjV4NHRQclIva3kv?=
 =?utf-8?B?OFZBOGJnZFdlSlpyUXVrYWlWY2JDSmFEVm41azBhRW9MaXZoZ29tODVVclZz?=
 =?utf-8?B?ZWp4K0RwU3RrVGVDdFJtL3JSRjJYUTVGM3FsZWJTNGgxbVpWaGJOYlB2ejF3?=
 =?utf-8?B?d3FCbGNGQWYwYzJPYzU1ZFhoSVRSWGRFcnRLUjgwVjFBdXY3T1pTV2pYdkJu?=
 =?utf-8?B?MGFjdkpqRXhHa2o4VEVTQVFyc2dQcFE1cTE2UFliVDRGYlVYcldleERZb2x6?=
 =?utf-8?B?KzRhOGtlMjFwUG94cXYrdHlwbUhSdW5QU0lzZEtaWDZIQ2NIOUpEUEt4SVRX?=
 =?utf-8?B?THRabGFCRm9WSmwweHpqS0ljWUxaNU9iZk1FbW5QRlptcVZ3L1dpUE9zTDRn?=
 =?utf-8?B?WjJYMzl4R1dCZGxWeHRaSDYyaWZXQ1NOZngybFpxT2pFRFJ6a2hMbGN5cmFs?=
 =?utf-8?B?SjV5MncvaGlEQ2hveEVYbUpVaExSZm5wNk1seEJkL3lYb29zVk9ZWTVnZGt3?=
 =?utf-8?B?RTc4VEYzNmJwR2NYeTdXRmNGKzBUNXMwdnlsYXhWcUpsTVpDSlFmdEphdjFU?=
 =?utf-8?B?dGVQRHgzaDMvdlQ2VlprM0xVa1hLRjF2bnpoalZvQXgxVWV1ZE1ZWEErdjRB?=
 =?utf-8?B?OVM2bTAyTEZTYitsWjdtelBmd0tVTlhYTzY1azNhOXA1ZG82aW8rSlQxclpN?=
 =?utf-8?B?YmRTWTdiaGRMaGtzOVpzSnZYVU56SXRnV29OZEkyelllQVo5N0hDRVR5cEZw?=
 =?utf-8?B?ZW53TmVQQkdkenJ5TDRkUmR0d2FNN280djFvRlVQVFhiZ1crY0pBN1ZJb3U0?=
 =?utf-8?B?Tmpxb3RoSGppOFJEUDBsZGNzdDgyZld3V2JYTFU2WjhyaGd5L005YU1QaXlu?=
 =?utf-8?B?YjZ2VEF0LzVYQjZzdTdNbk56eTcwYVRPd3NySnprN3NidElKQTNSR1R1NzYr?=
 =?utf-8?B?VW5YbmVOZWw0WlhFZkNWV2xqbjY4WHE3WHIzNlI2MWhFQTVQWHJxZUwvM3Ji?=
 =?utf-8?B?U0ZzaXdyZzE5MVR0YmIvZ053MFVxSXFvVWx0aFIxVVZnb04yR2k5WTM0QkRS?=
 =?utf-8?B?eHc4QllIWE1IR2RRdE55MDVlZzZxZGVVandtclp0R3oxd2pOTC9sVGhYaW5T?=
 =?utf-8?B?Umd6OGZxNU1FQW8ycHpiOWRCZkVHbWxDMHRiYlVtUlJWME9xK0xlN3ZUN0Nt?=
 =?utf-8?B?cEdlY1hVU2hwN3hCWkVHVDdHSEQvNUI3d1o0TU5XY3VaZXc1VVN1NEtYQWlW?=
 =?utf-8?B?a0hqRzlLTk82MHcyY0tIc1NCeElNNDEvbmdhbTNJYUgrdzdid2pUQ3lQTnhE?=
 =?utf-8?B?cWpORHg0dGdyc0o4UU9WUWR6VEFRdnRrRXlRSHJZR0g3Z3UyVDVOL0Y1TGxq?=
 =?utf-8?B?TWZ4eVdFSXRGb1VQZ0xyWVZwdTR4c1lDSC9MK0RPKzFuVUVkYklLT2h2dEZu?=
 =?utf-8?B?QTNVWGpVM1hENkxTcWFqYlc2TGZiazAzcjhIMG9hZWZFdXNvMW83eS9zVWdl?=
 =?utf-8?Q?oE7QSw9iX9Q=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R3RGNUxXV1JHM1c0cFR6WUFSU3RocVE3aSt0WkZFZTh1d3JVUjVnUkc4S0tC?=
 =?utf-8?B?MGQyYUxwZlRZNTZadkMvSmgrOGVCVnVWRXJLU0RiSnNtSDJiMGRHMlFtUGJH?=
 =?utf-8?B?YnZGWXJUUHVZbEJhN1VnbGVuQ2g1V0srTDFWcnplZlIySld4ZzZid1p6QWd0?=
 =?utf-8?B?MG9FK2NZblRmT3pYc3RqWVR0TFBsaXJmc0ZUTDZWQk1XMVpzR3RWd0RFb3pE?=
 =?utf-8?B?TUp6Y1c2QlBtclUvdnFPQzVuWUU4VW9rUXlCVVhUWU1RYzhOWDRwVTdpejVO?=
 =?utf-8?B?UFAyUlM2MTlmbC9YYTdKVUpMcWo5d1ZZcFRrQ0J5L2NRbXhxOUpZUjcvU2xm?=
 =?utf-8?B?U0JKZ1RVdmM5enQzNFFZUzViWkhrYzFDZGpVeUY5WEdJT2dJNGYrZm4rN3E4?=
 =?utf-8?B?a08wTGdnUi9aR2I5WFdkNlJUUXliZHdqS3JJTENCU3o1QjBvMFZrc2FFVk9F?=
 =?utf-8?B?QjZBcjI5OTR4aGNNUWQrSWZDbDZsYjIzZG9LS0xIdkZDTXh4K282VUI4emlu?=
 =?utf-8?B?Uzk2RDI4YXZMN2pMM3RVdFZJSHV4VldUODZWSGhzYTJZZ1BJOGhIaC82ZWxV?=
 =?utf-8?B?eTZPMk9yQ0tSbXY2SEZiTGpvcURza2Fyc0FKc0FyTURYeXVJNlJyTmNrbGw3?=
 =?utf-8?B?M0NsZytKdzhXeXpsK1N1eXJuUWhwNWtRTkN0M1AvN05qMmhFM2NpcUxTWnJJ?=
 =?utf-8?B?dUJaK3BBTjI4NzZJcW1ZQWRKeVZxbVJZWHhIQ2c1QWU4VFVZNGRLWXpEMVli?=
 =?utf-8?B?ekg3ZWp2eEN3WGRpREFDaUE3WEVBZStJdmsyQ2xrU0Fxd0RVK2o4MFJpY3Rx?=
 =?utf-8?B?Q05sOVVSdnZ3aHdnREFtVlFqMW5tODdCQ1N5UVJxcDhyVVVaa0ZsS1o3aGs2?=
 =?utf-8?B?SmF4YWIrUmZsTWdoWHRQK2I1RlFleUhWRUpQcWcwd3hJbVFlM2EyUXlsTzdK?=
 =?utf-8?B?c3IrYWVEVCtLc3poTW9UYVl3TmRpWTd6aE5mbmx1RDNUMUFvS2YrRm9XY2VV?=
 =?utf-8?B?c240NVRrcFdtYUppN3RPWXBrTHpleVQzcjE2dER1SlBNa2JHTmtCU084cU5E?=
 =?utf-8?B?TFJKemZNZURXV1ozYVJteGF6aElnOTlWNDJzYkxkazlqMVFhN0p4RDh3ajBi?=
 =?utf-8?B?RkJ1ZGVBUjNkckhUalNLWGQ1VEdFeTUvTzNUVC9LbHlBTnhLVy80eFUxYy9Y?=
 =?utf-8?B?dmpnTVpHM2kvYUJtWjZweFRMdk5jcG9obWxxTytzV0lubFFXZjY1Y2tITm1I?=
 =?utf-8?B?TDJrNllTanY1VFN5N0tWSnlCTjdJUVJtdis5UjBUdThpZjFPdkFwK256WWtn?=
 =?utf-8?B?Ry9UZFVONDVWK1B1eUM2LzFCQzZTOWJaVlZqeDNRalh2SVJUc1Qva2J5WUIy?=
 =?utf-8?B?LzJGOHhNc2VtWWpoeWw5dVRTWllmcEZZQnAxVTZDK2QyeVBBczNEVFUvbXRK?=
 =?utf-8?B?NEdZeUtjdlJ5Zi9VWUdFMVJsNnNhcDVhRVFlNklIdjZGZStReHJwN05EM01r?=
 =?utf-8?B?bXQwQm45MW1UMTcydUVyTExiZXZ4OVpDRXVWWXB6amNlVjFHRSs3RlplamFG?=
 =?utf-8?B?dytTakJMeEVGTnNKdlRWWFNKNDZENGFJbThQOXVxZkh0N2QzcXJmY2NPZDQy?=
 =?utf-8?B?OWMwYkZBM2pDejBJNklzNElQb3B0RW5MbFkwTjQrWjYvT040elp3blZkVXhH?=
 =?utf-8?B?dkYrRzltZzU1T1YvTWlna1hWUlBiWEl2OFdVZU0yR1JZTjJiUFhsTXYxdGp3?=
 =?utf-8?B?Z2RoVXYzeGpua0VYR0R2V08zWE9RaEhIcTVuZHpSZ1ZMdk5oVk4rbHZmL05H?=
 =?utf-8?B?dzFhL2dGUUNBMVhUUmNMZXB0ZFdnWDNFNmRzRXBLc3ZLMWxXbzBIbHNVRDFh?=
 =?utf-8?B?QWx2cFVtUEQyRU5aTmJXQ0ZiNDMwUmZTdHVldmU3cDJ6c2ZpOG5taGY1QnhP?=
 =?utf-8?B?NmpncGlHbXd3RSt4b1V0UlM3NjFneFdUYUx2NndDZkRtM3dRK3I0LzVxb3J4?=
 =?utf-8?B?STd4S2ZNWUV4K3Q4Q0ZydHZtM3hJTFozeEZOY3ZSY3lrcWJjV1k1SHFBMTdP?=
 =?utf-8?B?SWV3WTlhdUdjSHA5WXZ6R2ZQUnV2MWY1RnROSDdHTEJ0dVJzdGFVQ0NrWUlJ?=
 =?utf-8?Q?ltLpc18iB6ODN0ehGbCcc6M2L?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a0c750b-2329-434b-6694-08ddefdc211a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 20:04:48.5697
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7YKxp8aXMcssi5DUKau/984H0cN0CjM42jvHsATTD0+JhPHleJL+0qElH2FkrRUhgXgWljrixolt71v/mHcc1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PPF9C964DBFE

On 9/8/25 15:20, John Allen wrote:
> When a guest issues a cpuid instruction for Fn0000000D_{x00,x01}, the
> hypervisor will be intercepting the CPUID instruction and will need to access
> the guest XSS value. For SEV-ES, the XSS value is encrypted and needs to be
> included in the GHCB to be visible to the hypervisor.
> 
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: John Allen <john.allen@amd.com>
> ---
>  arch/x86/coco/sev/vc-shared.c | 11 +++++++++++
>  arch/x86/include/asm/svm.h    |  1 +
>  2 files changed, 12 insertions(+)
> 
> diff --git a/arch/x86/coco/sev/vc-shared.c b/arch/x86/coco/sev/vc-shared.c
> index 2c0ab0fdc060..079fffdb12c0 100644
> --- a/arch/x86/coco/sev/vc-shared.c
> +++ b/arch/x86/coco/sev/vc-shared.c
> @@ -1,5 +1,9 @@
>  // SPDX-License-Identifier: GPL-2.0
>  
> +#ifndef __BOOT_COMPRESSED
> +#define has_cpuflag(f)                  boot_cpu_has(f)
> +#endif
> +
>  static enum es_result vc_check_opcode_bytes(struct es_em_ctxt *ctxt,
>  					    unsigned long exit_code)
>  {
> @@ -452,6 +456,13 @@ static enum es_result vc_handle_cpuid(struct ghcb *ghcb,
>  		/* xgetbv will cause #GP - use reset value for xcr0 */
>  		ghcb_set_xcr0(ghcb, 1);
>  
> +	if (has_cpuflag(X86_FEATURE_SHSTK) && regs->ax == 0xd && regs->cx <= 1) {

Just a nit, but I wonder if we should be generic here and just do
has_cpuflag(X86_FEATURE_XSAVES) since that should be set if shadow stack
is enabled, right? And when X86_FEATURE_XSAVES is set, we don't
intercept XSS access (see sev_es_recalc_msr_intercepts()).

Thoughts?

Thanks,
Tom

> +		struct msr m;
> +
> +		raw_rdmsr(MSR_IA32_XSS, &m);
> +		ghcb_set_xss(ghcb, m.q);
> +	}
> +
>  	ret = sev_es_ghcb_hv_call(ghcb, ctxt, SVM_EXIT_CPUID, 0, 0);
>  	if (ret != ES_OK)
>  		return ret;
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index 17f6c3fedeee..0581c477d466 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -701,5 +701,6 @@ DEFINE_GHCB_ACCESSORS(sw_exit_info_1)
>  DEFINE_GHCB_ACCESSORS(sw_exit_info_2)
>  DEFINE_GHCB_ACCESSORS(sw_scratch)
>  DEFINE_GHCB_ACCESSORS(xcr0)
> +DEFINE_GHCB_ACCESSORS(xss)
>  
>  #endif

