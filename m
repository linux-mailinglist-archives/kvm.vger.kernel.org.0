Return-Path: <kvm+bounces-51726-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 10642AFC309
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 08:45:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B1CBF7A4492
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 06:44:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93C78221F26;
	Tue,  8 Jul 2025 06:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="SLj6P4IT"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2049.outbound.protection.outlook.com [40.107.236.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B93D3FBB3
	for <kvm@vger.kernel.org>; Tue,  8 Jul 2025 06:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751957142; cv=fail; b=PIzfdPsyADo+BDRDiVhU4vKCpEd7Qq3VfEDGweLvx1NJbUxJIBY7Hyi6xJG6EfEmg0gLUCU5ViWXM7b6cq47bkX0Fej81sOSAEnq8xu7SNJnTeQ6UlpTUI0lgTBg2ecn7SZVTxQQlzMJa7TqcDepMadKhs1HQq/7KICOK/edOBE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751957142; c=relaxed/simple;
	bh=li9m/BMpDA/i2klKPmklNMldjTnSzMgQr5Dn+NA+jJw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NoDVSjFoKy75uq6ZeMikUdYv94QamXvhQFIN6GjUZdyIy9mtD3rewsc1Tdt0sjtdqU4G66Gc/9tAJDVYVBGZrBm1bOoejw5L1D7HW6sE9ti0cPd5uqhNRTVT1cOR1MC8vjwkVzKVoXZaJqnBk7VZ95FIsGqtAU3+MDxWY/UEN5c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=SLj6P4IT; arc=fail smtp.client-ip=40.107.236.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bwLTelmYkqtPHW4NcIVVw/UkX2qnf0SN3o9KiNXN1cmvXKZ900Eb454HvK4U1E2PnJ0/WMMIdSMrMFw0jAyEE+jZRF2t69eWFdARsi5/ztkEZnExqUMu9ySb6I2jxZww/hgL6opOOswMb5NzlvxcFaNxfV3YQOXSADRaxM4g0duT2NTiJgXL9mVGy8RUsfuFme5shgtkSy09nlJ7qCxWgZFaTqEwN21JN66c4/lHXd3zpFVaijdWHspNE2ZeIuew7fi+sHcPhA8H3V6dvK9TAczO4JkZ5THxKGqh/SkFRSSBXBSzHJuO7jjYHtgNvLF8SGoLUJSAXjERONpzdTt6ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5ljxzNJtyI6f5IE+9HuGcbEoKXGLp6lqTJnyae3OVfY=;
 b=HHNN7fbBrJg1jouYwNv+Wxl9ThjUsBl3YGKCG6BcNk7gLX07hF3yIqaxyicjbCL/FBMdXSM7X6xt+e3k4Fn1AkZ1vegDSmDckc4SZ5aJ3Ado4POxSr8tdHbBgeRi6hhbr6QqyAOR/fPopYamUuG9S56wCvjJp9mTCWyf20JIr1DIznf2FbuTH2UzwlM6lq2ePBA/ZalEvbrurM8S3L5447n811AWib5BQDcQjkD8SMhQl9s9xK1LgiA+IMYj8tqgSfoYXMxecCmuNh1VHxwIcS8zag6AnerBVSq+kKdQ4zo5vLhHC/m8JKdavYPQp40VjV1lld/rxmpfM6ZVh1o45g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5ljxzNJtyI6f5IE+9HuGcbEoKXGLp6lqTJnyae3OVfY=;
 b=SLj6P4ITLHouBp/cupoKZSbu4J2xmQLrfnjfM1wGNN5YtpqPPBh6dP4jJxPjGChpQBi5v31gCUsLV9L24c3D9oKcRJLjQ9zzkxNhUndR8jnIwAVKvzRO9EDezaoLR3Yzakicke20rFEwi7IBXaq2schq0yL6H+0VW9lj9G+RqYE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6317.namprd12.prod.outlook.com (2603:10b6:208:3c2::12)
 by MN2PR12MB4453.namprd12.prod.outlook.com (2603:10b6:208:260::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.26; Tue, 8 Jul
 2025 06:45:38 +0000
Received: from MN0PR12MB6317.namprd12.prod.outlook.com
 ([fe80::6946:6aa5:d057:ff4]) by MN0PR12MB6317.namprd12.prod.outlook.com
 ([fe80::6946:6aa5:d057:ff4%6]) with mapi id 15.20.8901.021; Tue, 8 Jul 2025
 06:45:38 +0000
Message-ID: <57a2933e-34c3-4313-b75a-68659d117b14@amd.com>
Date: Tue, 8 Jul 2025 12:15:31 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 2/2] KVM: SVM: Enable Secure TSC for SNP guests
To: "Huang, Kai" <kai.huang@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "seanjc@google.com" <seanjc@google.com>
Cc: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "vaishali.thakkar@suse.com" <vaishali.thakkar@suse.com>,
 "Li, Xiaoyao" <xiaoyao.li@intel.com>,
 "santosh.shukla@amd.com" <santosh.shukla@amd.com>,
 "bp@alien8.de" <bp@alien8.de>
References: <20250707101029.927906-1-nikunj@amd.com>
 <20250707101029.927906-3-nikunj@amd.com>
 <26a5d7dcc54ec434615e0cfb340ad93a429b3f90.camel@intel.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <26a5d7dcc54ec434615e0cfb340ad93a429b3f90.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4PR01CA0054.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:274::12) To MN0PR12MB6317.namprd12.prod.outlook.com
 (2603:10b6:208:3c2::12)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB6317:EE_|MN2PR12MB4453:EE_
X-MS-Office365-Filtering-Correlation-Id: 739bddc7-97b3-401d-447c-08ddbdeb0c53
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U2ZDbUpoQlJRdnZxY0p2MysxYklIRjZGbWFMcWFqbE9GUWV5emJWWFRqTGMr?=
 =?utf-8?B?di9qOE9LOGxybklheW5QZEF2TkUxMUNSYTVpQmpGV0E4WVFFRVB3blBMRXp3?=
 =?utf-8?B?aUZGSUtVZlZOa0tMaEprSU1CYyttR1pMckdyWWtuclJUcUV6YXEyNFI3QnpT?=
 =?utf-8?B?WCtkcVhWN0YwY3hzYjdYbFYyVkxnVUVxUHcvMmpZWWFjeUFQKyswVHpmNVhE?=
 =?utf-8?B?MVpiTVRiSmNmMFNaRHF4alREWURQbmltWkVjbHAxN0d3WklsNXhDd3hlajZv?=
 =?utf-8?B?Umx1dWFNMXJRd1BJRGJMQWt6V1BRUUkxQVlmUnFsNk1GdkcwZUNmQ0FrQUFK?=
 =?utf-8?B?ejlERDhTdUxsdnlYWlhCVnA3KzVSYm8zU21Bd3huOUI5azJKZG1RSksxK2FE?=
 =?utf-8?B?OWNXWFFJRU84VVltWm9sVE41aWtMd3hNU1hzekQ3UUdKTUhwSHZqMzZwcUNO?=
 =?utf-8?B?Z0ZkeFZDbFVzSHEzUytQbVY1cUI1b3JKYU1oRXVyOE1CbGxRTlQ1dmdEN0tV?=
 =?utf-8?B?UnVHVzc0VFd2S1RKTVBMYzF4SDRiV0NXeDg0d3lZSXZGTGJ6Wk1jcERCN21p?=
 =?utf-8?B?MkttSWxTUEM2WkEyNGN6UU9nZzFmVkV0bW9lZWtTNUxjb29MOWlxRU9iR3Vy?=
 =?utf-8?B?T3RCM2Z4ZkkxVnNnY0tsSlhzdmpnOUNDYmlYUkFpekl2NS9BdjJUTlZxdG82?=
 =?utf-8?B?YURKSnVIdFQzbER1blY0akhHUW0weVZYZTVlZ1I5UkNJeTZuam9FSFNnM1d4?=
 =?utf-8?B?RzBUQStlSXVJNld1aktMbHJNcmJaV0Yzb1Y0a2dwTENWSCtldkdxRzk3N296?=
 =?utf-8?B?NUpUd1llN053YmZRcXY1WUVkbHhrSzF6NFUwUko5VElLRnVmb3VPMGlXdXZK?=
 =?utf-8?B?YnlEZ0FKM2drY2JBcXNldWRjd3pjQmM5VE1USklUdFFQajI5QWJBVGZEVDBX?=
 =?utf-8?B?SW5CbjZZSmNkY1lFNXNsalphbkF0S0N1SE9zdFB0R2ZoMlJLaWJ1N1g2SUFz?=
 =?utf-8?B?WHB0YTh0b1ErWnNLcUIxRG8wOS8rVkt1MXo2Y2kwY3JpRXFkbjJJZTFtSC9v?=
 =?utf-8?B?WTc0cWw5YUxmK3A2NzdNazI5Mk84SkhUeFB2Y3JNa1ZLdlpiMFM1ZzlVQ1hI?=
 =?utf-8?B?b1dwOG8xSjE0RWwxRm5EUzRHeUt6UnkyM1JFaXdnSE1iZXFYa0lGWkpqWkw0?=
 =?utf-8?B?WWdwZUQ2a2gwcjJQSDhRRURaNUhZRkswb3l1YWlOZXc4RHpqaWlXMFQzOTVq?=
 =?utf-8?B?cWRHbFltZHFCUzkzNnZPTngrNkVhWTlyZzZaNGNuTU5MNzlRczhiMXorT1U5?=
 =?utf-8?B?dHVHc0hSRmsvWitqVGFYc2pPcWNIWEdCZ3Q2cXNrWW0yNGZmR0ZxTG1KYnVm?=
 =?utf-8?B?aExIc2k4KzkzRUVSZU9JZWVNc1Q5WFhYRDAyUmd2a1RrTVlKV0laNzl0L2tx?=
 =?utf-8?B?MlJuTVVoeHQzdFEzSE8vVUI1dVduaVBFelVRTXM0QVk0cEtBbWFtY3QwRldE?=
 =?utf-8?B?b3U0Q3UxdzBCUmRMRytIUWlDQktoQ0k0VzRjUnowMTNmaEpaYXFrYS9jRGVN?=
 =?utf-8?B?dXJ5NjdGQU9yTzM3cTJ2ckhmN1V4QThyWUNGMzdDei9HZm4xQnFVdnFJOTht?=
 =?utf-8?B?V05rNTAwakIrRHV0bmlSdWNJOHY0SWdSRlExczJScDdjRlBXZE04Sm14V3ND?=
 =?utf-8?B?QkwrMHRnSGZ1SElOS2orQk12K1lNVkpOY21UdTR6MVMvV2xJNGRzZDV2U0JH?=
 =?utf-8?B?aXJTYURzemVWblUwV2graEczMlArOG9VQTZ1V3JvNWVhZWxydVYyWUVINDda?=
 =?utf-8?B?NHFWY1pmU2R2T2pTRTcydE9Vb0FMN2VPSnU3V0dPOTRiNjF4elFoQnNnVTB3?=
 =?utf-8?B?OVIvNnM4S3pKZFlVbjR3K0dRYTNGYUlYMjB4UzNoempCM3dkb1dVemt2TzE2?=
 =?utf-8?Q?cgt3cz4BciU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6317.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eG9FUmlEYWNyM1RxUHRHTEUyMzBYYnNDcHZHYzE2YWV0RlNIaFdCUXhNT1l5?=
 =?utf-8?B?a3EyV0kzN3hTTUVSbVpYdjI2R3Y0b3AyTWJsSzZHL25XeDR6V2NKNFlLNmJm?=
 =?utf-8?B?V3JrQWl6V1hzVFM1WGdidTkwdmJPV1Z0Y3hNNUp0WXpCTGl3aDZ4NldINExK?=
 =?utf-8?B?MC8zWmlpOE5jN0Y0N0t1dGRMQ2ZLTFNkQ0s2eUEvWUkwcHR2YlJPa3pQcXpE?=
 =?utf-8?B?M3p5SE9BaXlzWmlRRzQrY2x3TktraDFYMlZXR3g1ZTJxSCt6WnA1ZUNETVBu?=
 =?utf-8?B?UVVHU2N5ekdmV0l0dThNU1Y2NlZjL1cxQ1BkbWNEeVVjSlJtQ1V4VDhBZ0VF?=
 =?utf-8?B?R3lFVUR1R3NRb3hBRGxVc09PRUp4cVM5UUsrSGRoRTg1SXZDbkM4NWUvdW1w?=
 =?utf-8?B?dXRXNjdCaGJTTXY4RVN2Ty9VekxzQWtJWEllSHZmOStsZ0NXUGlGNzhZZGYv?=
 =?utf-8?B?MkswTldtYldEYU5jN3Z2MjlPNkZTdnBFZS90QUIvL2kwbisrd3FDYVZhVHN5?=
 =?utf-8?B?WXZNSW83cktpR3dmWWdHQlpySnBPalQ2NmVNa3RZZ2dvMjMwQ0hQYWJyWm1r?=
 =?utf-8?B?N0dsNVl0MENKdmdxRTBoalNXdzVaRVJUWFN5U0pjem1QZXBtVGJiQWlHMFNX?=
 =?utf-8?B?TjBtNDdkWm91ajBPeUFUcUwrUzArQjhqV2pDbVZLZExxSzlEdWI2R281NEZm?=
 =?utf-8?B?bVJkb3kvTjJqQjA0T2MxYzJBNUdxWTVqNFRDMnBUTFYyZDFqS2pIQVFxMWt6?=
 =?utf-8?B?VGxsS2NzV0FrWjVnQzIyWGNQbElYOG9WVjkvM25mSDc4VlEyajAzaVA1RVox?=
 =?utf-8?B?T3Q4b1JLNFAwY0tLc29rM2ZIRklrblZBc1U0WVFwakI2dGp6TjZXMlVjQVVx?=
 =?utf-8?B?b0hEcWE5ZWdHMzRaMGNNWW4wLzIxUDdBZDlieTZNZWFtR3NnVE82RUVBTWZm?=
 =?utf-8?B?L0piTjlFdlpQTGFXaCtjQUNCbTQycnJDRWRSL2Y4Qkw1aEJSRmRjanZkVldV?=
 =?utf-8?B?enV6MCtTWk1sMld3anMyQmdSTVFiTmxIWjE5YTZRY25Wd3dlWGc5bHlWVkxw?=
 =?utf-8?B?UzhxYUdReUYvMTZqZWNFWTNva0wva0Y5cmRNdG5BdXluTUZUdTlTTmJWaVNP?=
 =?utf-8?B?QW9UUFhBT29NY3Q2NXY4eGpBcDJBMTVDcGdzekV3eEUwVmRCeUt6OFcrQ1d6?=
 =?utf-8?B?a3hFeCtQWTdlc3o0cmJUK0cvNHlIMDFyaExHU2FDcFNFZTJzSGQ0QkQ4QUJh?=
 =?utf-8?B?VU1mMnBrVVEvT3dVWEJoelpKbS93M1hJSmdPQUVLNElLV0hGQkdkSUVPamE2?=
 =?utf-8?B?bytZWDk4cEVBeU53anVNcVNLR3EzckpKQi82ZG9RV0s0U094MU9BOGxsZldO?=
 =?utf-8?B?a0x2dUZreDZWS014S1hwRzhXQVNzN0w5VmlqUEY2ZVVERDdUTVNYS1JNWWMz?=
 =?utf-8?B?SjFjSHphU1ZDdUVjOFV1RXBjRENjdkxlc3BmK0l4UWQvL0tPZ05FQjZqL1Fy?=
 =?utf-8?B?cThmdzZIKzBmdXBuSWFPYy9QczFuMlNZNHI0NXZGZUFFcWcwTnBuOXlXZUZC?=
 =?utf-8?B?NG8waEJ6T09pN0lPblVEdXRKemNSR1g2SWhIK3RzamxjMzNDV0kxMFNxQlJO?=
 =?utf-8?B?TUZBNVhseU84VVc5NlpBeUwrNVJtN1h0dnNGRy9KTFlmWWluYm1acjVuZGhJ?=
 =?utf-8?B?QVVjYmI0V3RCVnk0V3lzOWQrT0VCSE9OV1FITGlsUERHUStHaGJyWnE1RWN5?=
 =?utf-8?B?QnJDN0FlQXlOOVZTZDM0aGhORm5adTdIUTZVcE5rREFYdVFrcFlqOStBT1NG?=
 =?utf-8?B?b0g3UzZpY3orN0c2QTdQU0QvZjVNMTdyc2RZc2VRbWc0ejVCek5kcGlZRHJP?=
 =?utf-8?B?eGVqd0xmL0M3RlNDakx0c0ZkRTJwZ2FnQlVBNlZEUmVkQTQxajdFcHNlWnJH?=
 =?utf-8?B?UlgvWWRQNFdxczAvdUlYR0sxcEtYRkFrZnAwL2JoMThhb0tWVjhuWXl0djlw?=
 =?utf-8?B?K2xyaUt0NEhwV29veG9GZVJpenQ3V3ZDNytNeWs3STJXN0ZkdHVmZmpKRmlL?=
 =?utf-8?B?WW5ZS2dWSHBRaE5tUmpuR1B4WVZwMDR2NS9TMXJJOGhSNWRrbi95akFTTGds?=
 =?utf-8?Q?s5mBKacwwcnThg2uWeQATzvNi?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 739bddc7-97b3-401d-447c-08ddbdeb0c53
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6317.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2025 06:45:38.1504
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F6ywuPSVcYnTFv4TaA9Ppd/HND8kbov9f8sX3GuWsluYyHArZKECI1V5FDgjiJBVIQVFMwjnzIsAe4naqME/Ng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4453



On 7/8/2025 7:51 AM, Huang, Kai wrote:
> On Mon, 2025-07-07 at 15:40 +0530, Nikunj A Dadhania wrote:
>> Add support for Secure TSC, allowing userspace to configure the Secure TSC
>> feature for SNP guests. Use the SNP specification's desired TSC frequency
>> parameter during the SNP_LAUNCH_START command to set the mean TSC
>> frequency in KHz for Secure TSC enabled guests.
>>
>> Always use kvm->arch.arch.default_tsc_khz as the TSC frequency that is
>> passed to SNP guests in the SNP_LAUNCH_START command.  The default value
>> is the host TSC frequency.  The userspace can optionally change the TSC
>> frequency via the KVM_SET_TSC_KHZ ioctl before calling the
>> SNP_LAUNCH_START ioctl.
>>
>> Introduce the read-only MSR GUEST_TSC_FREQ (0xc0010134) that returns
>> guest's effective frequency in MHZ when Secure TSC is enabled for SNP
>> guests. Disable interception of this MSR when Secure TSC is enabled. Note
>> that GUEST_TSC_FREQ MSR is accessible only to the guest and not from the
>> hypervisor context.
>>
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> 
> This SoB isn't needed.
> 
>> Co-developed-by: Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>
>> Signed-off-by: Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>
>> Co-developed-by: Sean Christopherson <seanjc@google.com>
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>>
> 
> [...]
> 
>> @@ -2146,6 +2158,14 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>  
>>  	start.gctx_paddr = __psp_pa(sev->snp_context);
>>  	start.policy = params.policy;
>> +
>> +	if (snp_secure_tsc_enabled(kvm)) {
>> +		if (!kvm->arch.default_tsc_khz)
>> +			return -EINVAL;
> 
> Here snp_context_create() has been called successfully therefore IIUC you
> need to use
> 
> 		goto e_free_context;

Ack.

> 
> instead.
> 
> Btw, IIUC it shouldn't be possible for the kvm->arch.default_tsc_khz to be
> 0.  Perhaps we can just remove the check.

I will keep this check and correct the goto.

> 
> Even some bug results in the default_tsc_khz being 0, will the
> SNP_LAUNCH_START command catch this and return error?

No, that is an invalid configuration, desired_tsc_khz is set to 0 when
SecureTSC is disabled. If SecureTSC is enabled, desired_tsc_khz should
have correct value.

> 
>> +
>> +		start.desired_tsc_khz = kvm->arch.default_tsc_khz;
>> +	}
>> +
>>  	memcpy(start.gosvw, params.gosvw, sizeof(params.gosvw));
>>  	rc = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_START, &start, &argp->error);
>>  	if (rc) {
>> @@ -2386,7 +2406,9 @@ static int snp_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>  			return ret;
>>  		}
>>  
>> -		svm->vcpu.arch.guest_state_protected = true;
>> +		vcpu->arch.guest_state_protected = true;
>> +		vcpu->arch.guest_tsc_protected = snp_secure_tsc_enabled(kvm);
>> +
> 
> + Xiaoyao.
> 
> The KVM_SET_TSC_KHZ can also be a vCPU ioctl (in fact, the support of VM
> ioctl of it was added later).  I am wondering whether we should reject
> this vCPU ioctl for TSC protected guests, like:
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 2806f7104295..699ca5e74bba 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6186,6 +6186,10 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>                 u32 user_tsc_khz;
>  
>                 r = -EINVAL;
> +
> +               if (vcpu->arch.guest_tsc_protected)
> +                       goto out;
> +
>                 user_tsc_khz = (u32)arg;
>  
>                 if (kvm_caps.has_tsc_control &&

Ack, more below.

> 
> TDX doesn't do this either, but TDX has its own version for TSC related
> kvm_x86_ops callbacks:
> 
>         .get_l2_tsc_offset = vt_op(get_l2_tsc_offset),                   
>         .get_l2_tsc_multiplier = vt_op(get_l2_tsc_multiplier),           
>         .write_tsc_offset = vt_op(write_tsc_offset),                     
>         .write_tsc_multiplier = vt_op(write_tsc_multiplier),
> 
> which basically ignore the operations for TDX guests, so no harm even
> KVM_SET_TSC_KHZ ioctl is called for vCPU I suppose.
> 
> But IIRC, for AMD side they just use default version of SVM guests thus
> SEV/SNP guests are not ignored:
> 
>         .get_l2_tsc_offset = svm_get_l2_tsc_offset,
>         .get_l2_tsc_multiplier = svm_get_l2_tsc_multiplier,
>         .write_tsc_offset = svm_write_tsc_offset,
>         .write_tsc_multiplier = svm_write_tsc_multiplier,
> 
> So I am not sure whether there will be problem here.

For the guest, changing TSC frequency after SNP_LAUNCH_START will not
matter. As the guest TSC frequency cannot be changed after that.

> Anyway, conceptually, I think we should just reject the KVM_SET_TSC_KHZ
> vCPU ioctl for TSC protected guests.
> 
> However, it seems for SEV/SNP the setting of guest_state_protected and
> guest_tsc_protected is done at a rather late time in
> snp_launch_update_vmsa() as shown in this patch.  This means checking of
> guest_tsc_protected won't work if KVM_SET_TSC_KHZ is called at earlier
> time.
> > TDX sets those two at early time when initializing the VM.  I think the
> SEV/SNP guests should do the same.

Setting of guest_state_protected is correct as it is part of
LAUNCH_UPDATE_VMSA, from this point onward the guest state is protected.

For guest_tsc_protected, vCPUs are created after SNP_LAUNCH_START, so setting
vcpu->arch.guest_tsc_protected there is not possible. We might need to have a
kvm->arch.guest_tsc_protected which can be set and then percolate it to
vcpu->arch.guest_tsc_protected when vCPUs are created, comments?

Regards
Nikunj
 


