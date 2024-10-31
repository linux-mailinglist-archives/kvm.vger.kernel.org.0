Return-Path: <kvm+bounces-30151-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2034B9B7631
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 09:17:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5E138B2159F
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 08:17:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A3C912C526;
	Thu, 31 Oct 2024 08:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="AApTW5xn"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2045.outbound.protection.outlook.com [40.107.237.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32F371487C5;
	Thu, 31 Oct 2024 08:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730362648; cv=fail; b=qSMckjj7/YX6unmJScHI525BxN8OWeFjrn1U+k9XJX5lomfgWD/NNotLZI8fC27gSXof1skzKQRriW1p4tZaMMT9dV5Esy/AoHlG3g79+P1TT3JqBz9mrQ9pGxA0D/t/JYfHV0j0nkewH8xhWaFrgDF4ZaLxG+o47hcfoLaBWk0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730362648; c=relaxed/simple;
	bh=8lEhhYhQGgQyhcPnAwp5fFZaIoUc8uvgbz6/wmlgnCo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GY2U3O20x1GPpk5T4PiaT+jkV2bYeYTr98ryR50QD6LvnJcdFsx//l3sGLmRSUbxe66JvJqrhPpyEuoKuyhXB9qpTx9aRYxq1IjER3+URFXB+8IaYUqmZy9ILYqr4LuOM9lUPTlOxl0eruusYRiy8s/SvCWEiITLGWxd3j4FuS8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=AApTW5xn; arc=fail smtp.client-ip=40.107.237.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OCPy9Z9nLq668jzEtgaiK29EfuZ7rQk1YqqXLeSeNik/Qsq34H9vp/RAS8mI+qwdeMvFUbDqrDS+rRICQRnpqCu2kP7DaazO3NMyZ8+YStYZhMg4f7lxLvEy+BsXKSH478eTdB7HHrtl0Y9yhgQVh5feKeizsG9MAJ1IHM6jhr/NP1F3N2e/i4ip1mkj52+cqOf4UGNLUqo43cDONBjQ2f+3tE9R0N+N31QrGx6iqn/uaR5vBn0/DXewZ+F1gHtJZ6ojOi3C+52fN1ezZz/c/bbFrWsJ0sPQzNfRdwB9yPQbvb49h23kw7U9BtzEwsqM3sHwmeQlppM2L5EoS1Y0WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WIl3FAG0IReXEAxDdpeWB3iKlPerwEVD8bNdRBeTa2U=;
 b=fkkEWDP0nTTQqicjudJTyo9VSQ6tefKxWfXLC20DEmSqfYs0pSfN4fSS22siegB1+tiYS1VLScFPYN+/lBhie7uDY1yRnKhpKSiYI7xSPqODici8LCEViKAJ/2uIYdU9YcT/gH1B+D2j1Y4LjgKhofyeLhU+CdWWO7Wl2rqZ7zd9j1PaXQRfd0TimJSHMRAS0jRk8LiDvP/uozKZVp79JxsCiwea0w2yUf/4Q8OwVCaQToWi9YXoWzcPeMoHSCqDCT4Jxd6bTeUZmTNN2eMwG2LE8MNZdPvjCa9FdYA9NZp2LOBIiZUrDZuyI4TXD8La9yBPS6xzJ4LqKRnpvZOoAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WIl3FAG0IReXEAxDdpeWB3iKlPerwEVD8bNdRBeTa2U=;
 b=AApTW5xnCKzEDZVAzJZ8hAP8owUE+nva4/r6Ktwj2Sqafe2BVP5T2pykLRCxAwywoYvaksyqu6fwK9nOWNBTcYYv09UT7eh06YMbV1/Vl47HHPjZoCk0PkotlKFEeuWZANlIGtoRM07/GjnqUufpZsthGAoFKJPktTSrvm33xUk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by DS0PR12MB8504.namprd12.prod.outlook.com (2603:10b6:8:155::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.24; Thu, 31 Oct
 2024 08:17:23 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef%4]) with mapi id 15.20.8114.015; Thu, 31 Oct 2024
 08:17:23 +0000
Message-ID: <35b66cd3-5124-4950-b8ca-d0e52f725e34@amd.com>
Date: Thu, 31 Oct 2024 03:17:12 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] KVM: SVM: Delay legacy platform initialization on SNP
Content-Language: en-US
To: Dionna Glaze <dionnaglaze@google.com>, linux-kernel@vger.kernel.org,
 x86@kernel.org, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: kvm@vger.kernel.org
References: <20241029183907.3536683-1-dionnaglaze@google.com>
 <20241029183907.3536683-5-dionnaglaze@google.com>
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <20241029183907.3536683-5-dionnaglaze@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0047.apcprd02.prod.outlook.com
 (2603:1096:3:18::35) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|DS0PR12MB8504:EE_
X-MS-Office365-Filtering-Correlation-Id: c5fd9e21-95b0-4560-eae0-08dcf98472b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WTNCRVBCVzdnUUhLbGNlV0R1ZHVnMW9GaTBUdTZzbmQzdWhXeE1DbmcxZzBs?=
 =?utf-8?B?Y1hVbTdoZ29vSHdxdXlGT2hmWm1tR0tBaFk1dWVYR0ZOTE5yUlNEbitERnVR?=
 =?utf-8?B?NTRiYmhScWNOdE9vMGhNZUxpa251R0lwTU1TdEhiRTNUWHp3MVA3VmFTLzVQ?=
 =?utf-8?B?VlRRa2svTHF2YTM0Wk1hTVR1R2lsZVNyOVQ4eHdWeEp5M1FzS29ZRTFVWTZj?=
 =?utf-8?B?b0dlZVZ1TGRZdTNaUks5ditiQWJXN2NoMjRTQTY1OG9KNEduUUxjOWtLcG4x?=
 =?utf-8?B?Z2tjUmNUWUlCSzg2Wjg5UWFycTI0dmJVSDM1Uk5XU0M3VFlOK2x6bTUzby9T?=
 =?utf-8?B?VHhVSm5UOUdrNyt5Mnd5MEpFOGI0ZnJLRlplN2x4NXMwV2h4d0dZYnc1L214?=
 =?utf-8?B?ckJsTUlOUXRpVmNnL0QrdVZWWlR5dGRYTCtkSjlRTFZPRms1MVV0cmV1ZEs5?=
 =?utf-8?B?bzZwMmZ0dExaRTBFZStHMUhKZnVuLzlaKzE2ZVRZQktOc0ppd3UvRUsvVmZy?=
 =?utf-8?B?VmUzTkdqczlyUGw4d1kzNVdLbktVdUpxQVNNTitoZDc4emtaaXZMSWpaWHJj?=
 =?utf-8?B?VzdFcHlFNWFYcGhiay9yWWlIbitHSEdkdzJDZ2xzM1NyaXFnQ0RjS291U0Jv?=
 =?utf-8?B?WktGSnZ1K0thcEc0bnZmbHhJZVhZQXFndlc1ZzlYa1JvUmRsV1lVREUvSjBn?=
 =?utf-8?B?SndLUkZhbXU5M3BqZFF5Y2tVTUxwc1RBb05hanhGMGNrd20wNjMybTJMUG14?=
 =?utf-8?B?R1I0amhkRTJ0M0hjdTZkRVMwai9RTXQxZUN2UDF5MXdqRjg4VmpNanFDOFdC?=
 =?utf-8?B?dE1OY2NaWDZCRnVSVmhkRjZtUzVXRW1KRjhsYXYvQ0NyWHFYWWtqdURhVjdv?=
 =?utf-8?B?VTl6TVhEc2VKdDM2QXhteXdCNWNHZ2RRU0Z5Q2dtVkhCaEJ3enZ0RjlRUzBN?=
 =?utf-8?B?aGhYRUw1V2lJd2NXT1hlanVtWHRlNlNiNDUra1ppZXlpQUFmcWRGTis2VVBr?=
 =?utf-8?B?eG00amZNUUFMYVNiVithTlE5cHFJTkEzT2JXZkxaMU5BSzBwYS93V0l6cFFG?=
 =?utf-8?B?MWVRb0gwRWkvQlNHTjNUbjN3dklBYVBiMTJORTcvOWdVZjFLM00wMmw0Y0sy?=
 =?utf-8?B?d240a01rS2V4a3JvdnljKzA5eW9CV0VZbGR2L3gwVHN2ZTNxWStyYldQaGxC?=
 =?utf-8?B?UUZIQlJ5WkdYYzh1ZnFQUCtNak1FVFkyOTM3Y3VNaTlNd1pZbHRZdGhpVlps?=
 =?utf-8?B?Nk8wMU13S0tHMHFvUktUMyt0STFIRWd1Um9FY0sxOVEwdmZrbk1FSG10emV6?=
 =?utf-8?B?RzZxcnJHNFN0ZW9MRFo2OEFhYk1kQ3FMUmFtQ2VGL3RFVXRhMGFUS1d0bFB6?=
 =?utf-8?B?S3h5S0VmS2JvNHN2a0laYmdsM3NaVGhhcVFWajJVUEtIbWR0VlZwcE82V2Vo?=
 =?utf-8?B?TERHTHVkYzZlemJ3VkVaTUw1TVFITlJjbHp6bFNJcnY2TjdmMGpIZVJFZVJF?=
 =?utf-8?B?SndtOXRkbFZ1T1hUVkNBWEk5cktnelpwVUZzUU9GYWxhQ2hhbVZKNHZyR0Q0?=
 =?utf-8?B?OTRGQmJoQ3IrZ2NCQkxHdXk4QWE1c1ByVVlNYnZlZG5VUlhUU084dk05UHhJ?=
 =?utf-8?B?NVJWVTRzZ1hLT0h1bWxPMCtwUnlhWFdTVTJ2bFNEN25EQXJlWDJoQ0IrWG1i?=
 =?utf-8?B?aGt0SHgxZk5Yd3dKOThmSmFFWFhqUVRQU204TUIxaG0xc2xjbFhabVkxQmhj?=
 =?utf-8?B?ZHBPaFBCM2ZGaTJYaHlJbGVHcUptK0Q5UEFWK3JwekxadkdSVXZ6OUV6bEk3?=
 =?utf-8?Q?L+cY114QPkHca8z9WXE2etGp2k8d5v0+wavqE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SGhrRXF1OUhVdUxsZEI5ajhQbjV6VGtnc1dnK2xGOWRJTXp1SGtrL2xhT0dP?=
 =?utf-8?B?em4yaVlTTW1ZVUdLNFNqbitqQUYrM0o5V2JRWk5uY1VPbTZ3dmc3dnU4QmhD?=
 =?utf-8?B?WmFkbmRVTnhuZkQ2TGJ4T3gvSFFha2NEelByWlVtWjczclhzN2toeFV1Z0g2?=
 =?utf-8?B?Q21jeGJiVVJEazhQTEdSTDVDVnluSEc4VElTRXZWNEJiWE1DM0l6blZxczJ0?=
 =?utf-8?B?VWRHc3p2MDhWUkZZUUIvOUh2NUpiT1JaZkNSSk02MjM0WERrZnhrakJYTEJO?=
 =?utf-8?B?QWltYTlZVGNoZEhycFREV2dDRW1oZzhBMXVVNEt0YkxnRjkvOCtrMkh2VDJ3?=
 =?utf-8?B?MlVXUlU3RThoM2RIQTlWUjUzelprNG9hbFhIWGtzN2FINXc3c0tmU0VpVlpr?=
 =?utf-8?B?bFlLTkY0MUk1aHZFT0FKM1JpU1M5ekUrdjArYkQyVm5yVGozNDBGbVowRmEx?=
 =?utf-8?B?aWI0cDJTOURUY0duM25MSEpsdngyMHppUVFwekxUSTlTVy90endMZVM5Szcz?=
 =?utf-8?B?NU9rd1dQMytTUU00MlpBOG5QSFp3S0EvOWNTbHlFQXk5dGxqcHNYaUpWbUFx?=
 =?utf-8?B?cmpDWGxyb1haVTlEVm0zVDk4WVVUMXlFNUlrM3RPb2l5cnVwYkQxWWRtNVBL?=
 =?utf-8?B?VzU5WCsrSDU0VEJYYXdqSnZybjk2cHIxeUlLQjFZK3hZTGw5UEVBQ2d4U2dl?=
 =?utf-8?B?QVg3cWh5MVFNKzBCUkNkMWRXaEtqRUlkRm10OXBjT29MRXpaZ3RVU3hNK0k3?=
 =?utf-8?B?c21kbkZwYlYvN1RYV1JWWDRvMUhlVHpUT1JCMmViVTNwdGFSSDNaWWQ0SDJa?=
 =?utf-8?B?WlljTlpndlYwNTFNL1MvVjhLTEhndlFpMFRGZmpwWkEwOUZrNUczTzc5ZGg1?=
 =?utf-8?B?S2hBMGRTZHRBaGhtSExmMjZIYWFhTmlBNGRmY3QzWXdLNUZXeVEvOTYrc1Nt?=
 =?utf-8?B?UWtLMmczb1VLMFZra0JVU01DdVd5WFFyUHFSTjBPc3NPNlhEM3NLeTB0d2U0?=
 =?utf-8?B?a2o5dWFxNWtBQ21GWE5XcFFieEhXc2QwQk8zUHp2TktpKzBSQi9saVVEWmk4?=
 =?utf-8?B?dTUwV0ZvcFZBbko4Sno0SlZvOTYzWElkditzRklvb3lGaCtvRDdkUm82ODdP?=
 =?utf-8?B?WkxBdjAwZERJdXBjZzBreW5PdlRSY1RsdSt2RmkwNEU1NFFNUG1tTnVnN3lU?=
 =?utf-8?B?aDBkR0lacFA1U2IrczBUR3ZMeUFpVmIvTGo5OGZsVldKaHVGQ2RjaEFJbHB4?=
 =?utf-8?B?dlRLU2ZlSmdHOGgyb0szeTByRlc0YUxpdlU4K3FIRFFidXdJUEQ0YWVlak9U?=
 =?utf-8?B?aDhhK0prWlNva2M2eUNSaG13SXBtcDZXQmFmdWZIWlZkai9BN0JDeDVkZmcx?=
 =?utf-8?B?TlNHa0F3V2dlWkhpMGRMRnBuQTIxaHpFWjRyWmlXUnFuaWpreWdVbW4vRWI3?=
 =?utf-8?B?ckxkVmI4V1k3a0NhVUJIa3ZZbGdnbzAzWExESWRHU0RMYVFUMTZWRjVneXdL?=
 =?utf-8?B?aEJoTWRTQVM4V0NQa3pMbm5ocHg1TkNCK1JtVUdjVlpRSm5KS1BlUm1lN2tD?=
 =?utf-8?B?TzhFVk9mV0RhRW03VDlrVFU2RURRVHFxTVhBUnRSNXhJRHpNbFA2TVNPRVZm?=
 =?utf-8?B?YWF1WUtwcm5yclNxY0YyZ3BpSVFlbi9GRkFObEs3L1R1QjYxUStTVGx2b2oz?=
 =?utf-8?B?VnFUTVBYL3NUcTdGRjRBU3dlNHMrMmhCYVFnNzN4bHpwSXJsdkxPSE16WTdw?=
 =?utf-8?B?RVowK2ZFdm9BOS9ibVJQTjl5elRjaW1KZUlxRERnb1dkaTNoNU9jbTEwNk8y?=
 =?utf-8?B?MEc2TWxta0wwSWNrWTkyakswN1o5UWJYRnV3VGh2SmVJdXNVQ2t3cWVzYWpa?=
 =?utf-8?B?MnlBdDArb3BFbUFpWXNaSkgrNy9YbEpsNVcwVUN1UUlLQms0a2lKSzVRNG5P?=
 =?utf-8?B?V21iZ05MaU4xb0FiMWw0UTk4VUJRbDdDSzVJTDBjcUJlQXpiMXJicEQ2Ym1k?=
 =?utf-8?B?RDdwT2w5Y2VmQVY3YSs1dzZ4TlBJdnpMckxBd1Y5Yk0xZnJWa1RMVEY1WTFK?=
 =?utf-8?B?MmczallHdi9xbEM0dXBUTW16ck44UzFDS29FOEx3K3gwVGhyaFRlOE9KalpI?=
 =?utf-8?Q?DkRkXiN36gvIA1ADK0jWRFYUf?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5fd9e21-95b0-4560-eae0-08dcf98472b3
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2024 08:17:23.6396
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9UEWrdba414o2lT43NhmFQRopKSO0ITn+TZ+4QCAgGY/VZWMRZdPpZbGwiAIjDsZ7EnmyI57xBF+gviF/DGrLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8504



On 10/29/2024 1:39 PM, Dionna Glaze wrote:
> When no SEV or SEV-ES guests are active, then the firmware can be
> updated while (SEV-SNP) VM guests are active.
> 
> CC: Sean Christopherson <seanjc@google.com>
> CC: Paolo Bonzini <pbonzini@redhat.com>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Ingo Molnar <mingo@redhat.com>
> CC: Borislav Petkov <bp@alien8.de>
> CC: Dave Hansen <dave.hansen@linux.intel.com>
> 
> Co-authored-by: Ashish Kalra <ashish.kalra@amd.com>
> Change-Id: I3efb5fbbd0da05ab29f85504a86693f5cdf49050
> Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
> ---
>  arch/x86/kvm/svm/sev.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index f6e96ec0a5caa..8d365e2e3c1b1 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -445,6 +445,8 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
>  		goto e_no_asid;
>  
>  	init_args.probe = false;
> +	init_args.supports_download_firmware_ex =
> +		vm_type != KVM_X86_SEV_VM && vm_type != KVM_X86_SEV_ES_VM;
>  	ret = sev_platform_init(&init_args);
>  	if (ret)
>  		goto e_free;

Reviewed-by: Ashish Kalra <ashish.kalra@amd.com>

Thanks,
Ashish

