Return-Path: <kvm+bounces-36511-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 75D4CA1B706
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 14:39:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A91E9162970
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 13:39:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2854A12C54B;
	Fri, 24 Jan 2025 13:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="I1yng0zg"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2066.outbound.protection.outlook.com [40.107.223.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBEB74436E
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 13:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737725920; cv=fail; b=DAKivP1VNtZTscrsnZQwVOYsN4IxOO3Y6PDcZ+cE2e35Lo18mdk8Q5hEecvizXLTYA+w5B3KqPHBDDWvGifot00ywiBkJt9T4wqxSAP2MK57/wb3ZYqJoGQXrGQ1U1YN3+9jKBZACWdF7DoGVTGElpug6MAABxOykHJb3YBpwR8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737725920; c=relaxed/simple;
	bh=x8ZUg+4/UhCyuWgHyOxSZRnpDQk7z11TZE9P2Pf6ujc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jyLmYB6ZjjiIWnABHSclC/acKRIPhoZhvHCavJZ0/8PW3H59NOk73kOUFDVKD5Cfhm7MBDKqrhYvSev3SDjurMl3JkDnVVyVTHbqXBC90cBDlqC0eRXiHD2MmNvR03TLy+3lHzi/JnLYVmGCJ1x6mXGe+ag5iFb9oc/8Mk6oM7w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=I1yng0zg; arc=fail smtp.client-ip=40.107.223.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CZYz7+51M/JYOfwtIlV8AWKlJnprv1Bj6kWkqjUn8YYCdHPWtppNO26xaum9JZaIljSFsf1yLMHRF8onaoOhjVWLLpqiLAg0YrOTz7Qa387bxvRqGqbQfiWiQdOyZ+Y0MYlVdCjQyvlsQuVazlYzqnaXHQWVy/GQFK4wpHQM9TSAabQuH/FgohwULw+tvqMZ3VZAS7kb7TLFKe4Bf4V4erWsehzYwIU+7c+Zfqll9wiMUiQPZaWUCRv2HiisK2JixHQoJaamwTlqronbhtOA1oG8ahONh0ta78KVCZUuRroiUatjnx4C9z8wcr3PyrgHnWyRYJaKoptDP+a+nscfKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R8ZebGFq5vQ1m+QpNXaMo6qaXJTY4xNLtFGncDtqty8=;
 b=gHkfEgctVZLTj/G6Smx/HvtBUxNYnMkFkm1mmbxH02IKDj95/hJnzLyBeNeJsrio7ut6tMEpNiS6B3qq+FmN4VJRe6RZPZL9QOOYOCR1RekLZkq8sZqF5bysIm8rY2QTVFL/PQfajvw73R/6NR6T9EUVx/h12tmb/ywiTij0kX7grfyuu1xZHDrQkPOmhvVcmlJYJ3qsTkfvSfsZCM157uUN575RlXlYaN+E+QQJL8JwVwI+O6vDhargmVfowdGUZO9VV0mGRWgXBmQuH+seBwEF/F8vU69Nhlee3SAYe/KiCj9lRHsQOpH4+fKbflkD/R0DvYDywPKa/IgrFqfhwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R8ZebGFq5vQ1m+QpNXaMo6qaXJTY4xNLtFGncDtqty8=;
 b=I1yng0zglrEcKT0Q9yb8SmeVA9ryZEjihcyKzqpKe3mukBaSc8NgdFXnAzd+m043iSarHG0bhpdv52SQyFMKXYDyuCgwR0GT7vHhddsVWeyB/B4P0sddTWHNz4Qr1ecuWY4t9X6gmsUNiipE/kQC7PQ/Tr4MqBskIijCmz5LPNk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SA0PR12MB4447.namprd12.prod.outlook.com (2603:10b6:806:9b::23)
 by DS0PR12MB7770.namprd12.prod.outlook.com (2603:10b6:8:138::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8377.17; Fri, 24 Jan
 2025 13:38:35 +0000
Received: from SA0PR12MB4447.namprd12.prod.outlook.com
 ([fe80::b4ba:6991:ab76:86d2]) by SA0PR12MB4447.namprd12.prod.outlook.com
 ([fe80::b4ba:6991:ab76:86d2%6]) with mapi id 15.20.8377.009; Fri, 24 Jan 2025
 13:38:34 +0000
Message-ID: <97712ebe-fd9f-4549-ab95-e638bc9f3741@amd.com>
Date: Fri, 24 Jan 2025 07:38:32 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: SEV: Use to_kvm_sev_info() for fetching kvm_sev_info
 struct
To: Nikunj A Dadhania <nikunj@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org
Cc: thomas.lendacky@amd.com, santosh.shukla@amd.com,
 Pavan Kumar Paluri <papaluri@amd.com>
References: <20250123055140.144378-1-nikunj@amd.com>
Content-Language: en-US
From: "Paluri, PavanKumar" <papaluri@amd.com>
In-Reply-To: <20250123055140.144378-1-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR11CA0024.namprd11.prod.outlook.com
 (2603:10b6:806:6e::29) To SA0PR12MB4447.namprd12.prod.outlook.com
 (2603:10b6:806:9b::23)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA0PR12MB4447:EE_|DS0PR12MB7770:EE_
X-MS-Office365-Filtering-Correlation-Id: 223fb180-6c62-44f8-21d9-08dd3c7c662b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Mk9lbUxjRThjSGp0aW5jVll0eFRJUkZYemxab0VOSGQ5MnEvUU5Za05Qck05?=
 =?utf-8?B?MnlwZ1NWNlFvelUwMXYwL0ErZ3F0Ky9LaGtBUVMxUkFtOGdFUmYxaU00N0ZU?=
 =?utf-8?B?cThKbVF5d3NyaEdpUXlOSnAwRlV2UnNQQ3lWUXJHdXJvcHNncUs2dVV6Tkxp?=
 =?utf-8?B?TjRHYUMyelBmK2pkNUdXMndRNm5BZ3Q1bmNuTGFSay9wYlBUcktNQkFlN09t?=
 =?utf-8?B?VU1VMEdXUDNUZlpFL3VmT3h1aVh3S1A2a1AxME10d3ZkV3NQbE81MXltZTZh?=
 =?utf-8?B?OXN5bWUzVSsvd0swcXZyeGlGcXNadzFEcE5mTms0aHVwM1BBdVhreGd2Z08w?=
 =?utf-8?B?SUFIcWdtTFhtQkFZWWFhbzREMzB4dFBwMEZoUjh0aElwMnpUNmR6aStGWDZy?=
 =?utf-8?B?WUZWM0hISTRHbGlHTlcwRkd3eUVqNjk4OEQxQTliM1dXVVFUeklrM2d6NXpu?=
 =?utf-8?B?aTd2eStqRldDMVZtcUh5cld0UnpNTmNlM2pySWtEVHp6TDM4T2tseEtHb1VD?=
 =?utf-8?B?cm1yUWVSMDIyL3JaQ1B1ajl1YWJ2aUl5ZDVVRzN6aEVjMUhuTFVZMFZVajgw?=
 =?utf-8?B?S1RmR0tJUmV6TFhsOTdqdC9XckdLSTZkUkJoS3BlTjYrMWlSOHRaRmhlcVNW?=
 =?utf-8?B?cGE5YXV1ekVCYUFRV2xnVEtrZndybXFUakFaWlZCMjgxUWhaWlN1V0V1MXBJ?=
 =?utf-8?B?RG5XSkJxQUw5V0lJbHVXeE1LKzZDRlVreHR4UklheVRGTSsxOU8yZW12cHlL?=
 =?utf-8?B?SWpVR3dMWXJkN2dmNXlEY1BkQ0d0WjJnbU05T1Q2V2VpMk9LQmQzeTN1Q28x?=
 =?utf-8?B?SFlvN2JwdnY1WVdsYTZqNEllcUt2RHZPZHpMaDR0WFN2UVN4QnJYTVh2QWpH?=
 =?utf-8?B?ckNhWU1TR3BQT1o5VGZNMS91WVdtdXl3RG1WVkpHdlE1K1ZnME02Yjc4WWoy?=
 =?utf-8?B?ajdweVVreWRtaFZKWFlFUjdFcXdGdDh4R1pqWkdKZUxaOUd2Zjg0QXZhMXg2?=
 =?utf-8?B?UStxTTZxREpSQXpSb1dxZS95ZXFTSE1TMk1oRWNiaWxaeTMrMndUV1hjaUxK?=
 =?utf-8?B?SHEwcGJMWnpwZ0M4K0hVcjFMVm91Y095U3g4SS9sT1JpTFVpcGdINFRRR2Ni?=
 =?utf-8?B?TFFXV3lja3Z2Uk9Hb1VCTlkrSS81eGNiWm1Lb1lvV3FzRkNOcm9EVmYvaVR6?=
 =?utf-8?B?QTJhbTVkcUlSeUgxdXZaa2U2K2hVUldpdWRwTStBSG15OGdRYUZXSGsvTTZq?=
 =?utf-8?B?OGQzeU56YmllOURtMTA5dnExK242MFlrZGd2a1M3d3ovRWJTQ3hQTkhzM1lM?=
 =?utf-8?B?SnRRZ3hLTHFBaVg0dm1wWnVQdnBhTjdOaFpzTUp1S0JxSGtJQjZxSGRwRVFz?=
 =?utf-8?B?YVVBWms3K3cxbVdvMkhqblBWb1g4WnJUMkFIZys5VXNQRlVSdGRPTDgwY0Jo?=
 =?utf-8?B?eDBnNjdtMnJUWDA3NHdQbXlFdTFMNlZ3TnEzMzlPT0RjcS96dERwdVlxbTBW?=
 =?utf-8?B?MWNhTktDQVdmN1RRVHcyVDNoWXM3ZGxpWGU1UDNWQlp4MVpKVGJGZngwbUNt?=
 =?utf-8?B?YUUycndMVGJSZ091WFUwRGQwTlBZbDFHUk1YRTRzRCtDbUZzbklackI1VmZv?=
 =?utf-8?B?dGFoNlRLMmtrb28vL0ZpT0dGYzFQcW1xTVFoSC9hQkVyc0t2NGNaWkdFZHJx?=
 =?utf-8?B?bFlla0MrRHdSRENUK25SRmdEODZEcitJRzI0NmFXRHFORjEvVzl2Rjd5TGg1?=
 =?utf-8?B?Z2tkUXN3a3E5RklpdktCeExOM0xNM1RkNEloWWN0OWhhb21kM2ZOc255bFUx?=
 =?utf-8?B?Z0prcEVrRlN4K05WR0IyTzZwYWtVUTZhVkZNc3o4REhZdDdJeCtXM05tUlhW?=
 =?utf-8?Q?PutzvN/ESt4nc?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4447.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bTdpM0dYNlNqSzRrQjI2WXJFNWlQS3haMW5zdE01K2l2RmcrazVvZHYzVzVQ?=
 =?utf-8?B?LzdxNnZZNHNrQ1BXODNjRFIzY2dnUEtaOEZIRGoyYWluNzZYdTNUbWZRdGl4?=
 =?utf-8?B?Q0RuMlNDVGFlLzllUHR4RjcyNUgwdVdCcFJSZnZPSy9nbnNRc1hrZVUxamcx?=
 =?utf-8?B?cUZTL2ZIcnVBa2FITWppZDh0QWtVNjY2RzhWT2FzR2Z5WGlza0lvMVhNTVZU?=
 =?utf-8?B?QlM2RjVpT1RZRHJHdmdLc29aME82a0dyWW53Ri9pZU9LUnd6QU9kQTRHVTll?=
 =?utf-8?B?U1VQRjlwTkRTUHVrUGFtNzdsQUpvL3VhTHlKV0ZsUTNqc0ZKbVRtRklTVTh3?=
 =?utf-8?B?cEV0VWRrWGNUY25vL0ZQYzNsWm40Qzk3a0ZGcVN4WkxqRk4wVUhpeW1sNXFa?=
 =?utf-8?B?ck5pekxxZnFiOS9zVGR2b0lOWmprVDlkY1MxZDZYbUhXK1J2MDdsRU9Jay9Q?=
 =?utf-8?B?K0JGdHF3ZFpTZUtYdm8vMVdON0NtdXQ1TE5tSzIrdTA2YjBZb1E1MVVpVWNQ?=
 =?utf-8?B?aVlTQ1hyc3RGZEVBMmMvUU1xL25NSFlLOElra04zaVBXcnphVkIzTXNacFBq?=
 =?utf-8?B?NSt5L3ovRmNMdFhaaUhpSHhmL3ZIK2gxRG9RQThVcWlpaDRXM1lvV2xSZU1k?=
 =?utf-8?B?KzA0bUtxNG9LVGxWSEtoRm84Wm9ZZ0s0Z2x6SFBqV1NmWFlnR1NvSnYzUjNw?=
 =?utf-8?B?SDRsTUpCd3VwNE1oNUhMeHZjWE9Nd082WHIrUU9ONlJ0aGYwSjBKeG1Bb04w?=
 =?utf-8?B?NHF2dExzMHNBSEdzQk45dTR5Vms5c3EzZWlMRVE0ZEV4N3ZqNklyWXZaMzNW?=
 =?utf-8?B?VUlUbVJQUjc1Z2Q1UnlKK1J3MVJaK0tzTUlSMVRubXdKeWhpRUl1YWpxQUMz?=
 =?utf-8?B?aFlxbHF2MTRNYTBhQlFIRm9GRTFtL1lvTWdlYW9TQm9LQXFwYS9qVmg2Y2kx?=
 =?utf-8?B?WkZGcDF0SWdsdTRCdzFYRmQ4Nm1qbmJiVkZYZk5sMC9Ha05BemZnT2Jpb05M?=
 =?utf-8?B?OXhxREFHd3JPZGludGQ0cVlBN2djVlREWTdubmp4cnJBZG1NazhhaW9Ba3Ey?=
 =?utf-8?B?SW9uUjJhQ3pENkg2UXZrSkVQUDVuV0VBWnhNQ3hiUXFucDhWbzBLNE4xaVNZ?=
 =?utf-8?B?TVBDNkxrUjQ0cHpKdGpuczI4OEZkSVc0a3VPM3ZrVUVmUXdGbS9nRWdNcCty?=
 =?utf-8?B?MmZlUGt5UTBGMnVEWWttOXN4NWc4UkN2aWtOUWNIbmNDRjhKOE43bUVVS3Rm?=
 =?utf-8?B?dXQwZlNMSE9VUC9Jbm95TUtrbjR0NGo1Snh2YjJ0cjA2QkFVU216NWs0MGhp?=
 =?utf-8?B?QUJsUzdyRWxpbERyN09tL0pJeG1sM0cvV2FtN0tONmNKRUdrZDhBajdzNGk2?=
 =?utf-8?B?NERGYmlPSDRaV1J5K0JxaUowblZVTm9wWmJnK3VJL1pQck43SnNaT0tna0M0?=
 =?utf-8?B?Tld1UXBDS2NTVWNUcExheEJtcm1SNmpyQVhBdFVyMGRUTndjbGt6V3dkTjlx?=
 =?utf-8?B?QmZlbzV5RElWNDJ3K1c5ZG53ajcrYThBWEs2aVRSSjlzd1pjQkJBRWdqODZS?=
 =?utf-8?B?M1FYL0ZxeThveHJUZkhIR0dKUnVjMU1Gc1VIZ2dhcFhzU1NRQ1p1ZUxUK3Iw?=
 =?utf-8?B?ZlAvZlF2VkNtcXJaWjlhTTdwSHpxUnY4a3hYd2I2V3JMTk1Cb2NTVjB1VnJn?=
 =?utf-8?B?blU4VC9jbmxudHFxcW5hc01CYjVVMXZlUFk1WFFGaTgzbEsxamJxM25pbHFI?=
 =?utf-8?B?SUtYOFpkZFhoQTQ1RXo0TjFVbE9MblBpU1l4K2JPQzFITytSZzRJdm9qdmlH?=
 =?utf-8?B?SVgxUDByWTZXT1IzbkZDK0hwV1YxbjlpdVg0QkQyMFN4d2tuSFh6TjRMZTlo?=
 =?utf-8?B?YjBodGszQVc5anJRa21iSitOdlFpNysyaGRhZG1pRERWNTFqajJXWkxXaFZP?=
 =?utf-8?B?SE1VUVliMmJiYzNlOVk5RGNqZFA2QWh4S2VBZ2ltWmlINENJNWpXazQ4a3Ns?=
 =?utf-8?B?U3VOZ3VUMWh2SUQ0Q1c1c1ZaSDMrOWw2SUZ0QkRSMmZmNllsVnQ2UVhGNXZp?=
 =?utf-8?B?VVp3bjJXUEZUN1UwMjhKU213L3ZDL3MwcUFlVjFwR0xaTVg5Qi81NFg5cXht?=
 =?utf-8?Q?u8ry0e2XkBDLXZ/yab0epB6u7?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 223fb180-6c62-44f8-21d9-08dd3c7c662b
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB4447.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2025 13:38:34.6201
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /PnSOpXD2xTBsodwOZ8b9fibE5FkERtCWMmdcq+WF4mg9um1EFQ4eSblFrC6h3ySixUrO2vOi99EoNq9aqpG0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7770


On 1/22/2025 11:51 PM, Nikunj A Dadhania wrote:
> Simplify code by replacing &to_kvm_svm(kvm)->sev_info with
> to_kvm_sev_info() helper function. Wherever possible, drop the local
> variable declaration and directly use the helper instead.
> 
Just thinking out loud...

I still see local variable retained in couple functions (sev_es_guest(),
sev_snp_guest(),..). I understand the return would become unnecessarily
long when replaced with to_kvm_sev_info().. makes sense..

> No functional changes.
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>

Looks good to me

Reviewed-by: Pavan Kumar Paluri <papaluri@amd.com>
> ---
>  arch/x86/kvm/svm/sev.c | 124 +++++++++++++++++------------------------
>  arch/x86/kvm/svm/svm.h |   8 +--
>  2 files changed, 54 insertions(+), 78 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 0f04f365885c..e6fd60aac30c 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -140,7 +140,7 @@ static inline bool is_mirroring_enc_context(struct kvm *kvm)
>  static bool sev_vcpu_has_debug_swap(struct vcpu_svm *svm)
>  {
>  	struct kvm_vcpu *vcpu = &svm->vcpu;
> -	struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
> +	struct kvm_sev_info *sev = to_kvm_sev_info(vcpu->kvm);
>  
>  	return sev->vmsa_features & SVM_SEV_FEAT_DEBUG_SWAP;
>  }
> @@ -226,9 +226,7 @@ static int sev_asid_new(struct kvm_sev_info *sev)
>  
>  static unsigned int sev_get_asid(struct kvm *kvm)
>  {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> -
> -	return sev->asid;
> +	return to_kvm_sev_info(kvm)->asid;
>  }
>  
>  static void sev_asid_free(struct kvm_sev_info *sev)
> @@ -403,7 +401,7 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
>  			    struct kvm_sev_init *data,
>  			    unsigned long vm_type)
>  {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
>  	struct sev_platform_init_args init_args = {0};
>  	bool es_active = vm_type != KVM_X86_SEV_VM;
>  	u64 valid_vmsa_features = es_active ? sev_supported_vmsa_features : 0;
> @@ -500,10 +498,9 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  
>  static int sev_guest_init2(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>  	struct kvm_sev_init data;
>  
> -	if (!sev->need_init)
> +	if (!to_kvm_sev_info(kvm)->need_init)
>  		return -EINVAL;
>  
>  	if (kvm->arch.vm_type != KVM_X86_SEV_VM &&
> @@ -543,14 +540,14 @@ static int __sev_issue_cmd(int fd, int id, void *data, int *error)
>  
>  static int sev_issue_cmd(struct kvm *kvm, int id, void *data, int *error)
>  {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
>  
>  	return __sev_issue_cmd(sev->fd, id, data, error);
>  }
>  
>  static int sev_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
>  	struct sev_data_launch_start start;
>  	struct kvm_sev_launch_start params;
>  	void *dh_blob, *session_blob;
> @@ -624,7 +621,7 @@ static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
>  				    unsigned long ulen, unsigned long *n,
>  				    int write)
>  {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
>  	unsigned long npages, size;
>  	int npinned;
>  	unsigned long locked, lock_limit;
> @@ -686,11 +683,9 @@ static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
>  static void sev_unpin_memory(struct kvm *kvm, struct page **pages,
>  			     unsigned long npages)
>  {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> -
>  	unpin_user_pages(pages, npages);
>  	kvfree(pages);
> -	sev->pages_locked -= npages;
> +	to_kvm_sev_info(kvm)->pages_locked -= npages;
>  }
>  
>  static void sev_clflush_pages(struct page *pages[], unsigned long npages)
> @@ -734,7 +729,6 @@ static unsigned long get_num_contig_pages(unsigned long idx,
>  static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  {
>  	unsigned long vaddr, vaddr_end, next_vaddr, npages, pages, size, i;
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>  	struct kvm_sev_launch_update_data params;
>  	struct sev_data_launch_update_data data;
>  	struct page **inpages;
> @@ -762,7 +756,7 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	sev_clflush_pages(inpages, npages);
>  
>  	data.reserved = 0;
> -	data.handle = sev->handle;
> +	data.handle = to_kvm_sev_info(kvm)->handle;
>  
>  	for (i = 0; vaddr < vaddr_end; vaddr = next_vaddr, i += pages) {
>  		int offset, len;
> @@ -802,7 +796,7 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  static int sev_es_sync_vmsa(struct vcpu_svm *svm)
>  {
>  	struct kvm_vcpu *vcpu = &svm->vcpu;
> -	struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
> +	struct kvm_sev_info *sev = to_kvm_sev_info(vcpu->kvm);
>  	struct sev_es_save_area *save = svm->sev_es.vmsa;
>  	struct xregs_state *xsave;
>  	const u8 *s;
> @@ -972,7 +966,6 @@ static int sev_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  static int sev_launch_measure(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  {
>  	void __user *measure = u64_to_user_ptr(argp->data);
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>  	struct sev_data_launch_measure data;
>  	struct kvm_sev_launch_measure params;
>  	void __user *p = NULL;
> @@ -1005,7 +998,7 @@ static int sev_launch_measure(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	}
>  
>  cmd:
> -	data.handle = sev->handle;
> +	data.handle = to_kvm_sev_info(kvm)->handle;
>  	ret = sev_issue_cmd(kvm, SEV_CMD_LAUNCH_MEASURE, &data, &argp->error);
>  
>  	/*
> @@ -1033,19 +1026,17 @@ static int sev_launch_measure(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  
>  static int sev_launch_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>  	struct sev_data_launch_finish data;
>  
>  	if (!sev_guest(kvm))
>  		return -ENOTTY;
>  
> -	data.handle = sev->handle;
> +	data.handle = to_kvm_sev_info(kvm)->handle;
>  	return sev_issue_cmd(kvm, SEV_CMD_LAUNCH_FINISH, &data, &argp->error);
>  }
>  
>  static int sev_guest_status(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>  	struct kvm_sev_guest_status params;
>  	struct sev_data_guest_status data;
>  	int ret;
> @@ -1055,7 +1046,7 @@ static int sev_guest_status(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  
>  	memset(&data, 0, sizeof(data));
>  
> -	data.handle = sev->handle;
> +	data.handle = to_kvm_sev_info(kvm)->handle;
>  	ret = sev_issue_cmd(kvm, SEV_CMD_GUEST_STATUS, &data, &argp->error);
>  	if (ret)
>  		return ret;
> @@ -1074,11 +1065,10 @@ static int __sev_issue_dbg_cmd(struct kvm *kvm, unsigned long src,
>  			       unsigned long dst, int size,
>  			       int *error, bool enc)
>  {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>  	struct sev_data_dbg data;
>  
>  	data.reserved = 0;
> -	data.handle = sev->handle;
> +	data.handle = to_kvm_sev_info(kvm)->handle;
>  	data.dst_addr = dst;
>  	data.src_addr = src;
>  	data.len = size;
> @@ -1302,7 +1292,6 @@ static int sev_dbg_crypt(struct kvm *kvm, struct kvm_sev_cmd *argp, bool dec)
>  
>  static int sev_launch_secret(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>  	struct sev_data_launch_secret data;
>  	struct kvm_sev_launch_secret params;
>  	struct page **pages;
> @@ -1358,7 +1347,7 @@ static int sev_launch_secret(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	data.hdr_address = __psp_pa(hdr);
>  	data.hdr_len = params.hdr_len;
>  
> -	data.handle = sev->handle;
> +	data.handle = to_kvm_sev_info(kvm)->handle;
>  	ret = sev_issue_cmd(kvm, SEV_CMD_LAUNCH_UPDATE_SECRET, &data, &argp->error);
>  
>  	kfree(hdr);
> @@ -1378,7 +1367,6 @@ static int sev_launch_secret(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  static int sev_get_attestation_report(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  {
>  	void __user *report = u64_to_user_ptr(argp->data);
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>  	struct sev_data_attestation_report data;
>  	struct kvm_sev_attestation_report params;
>  	void __user *p;
> @@ -1411,7 +1399,7 @@ static int sev_get_attestation_report(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  		memcpy(data.mnonce, params.mnonce, sizeof(params.mnonce));
>  	}
>  cmd:
> -	data.handle = sev->handle;
> +	data.handle = to_kvm_sev_info(kvm)->handle;
>  	ret = sev_issue_cmd(kvm, SEV_CMD_ATTESTATION_REPORT, &data, &argp->error);
>  	/*
>  	 * If we query the session length, FW responded with expected data.
> @@ -1441,12 +1429,11 @@ static int
>  __sev_send_start_query_session_length(struct kvm *kvm, struct kvm_sev_cmd *argp,
>  				      struct kvm_sev_send_start *params)
>  {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>  	struct sev_data_send_start data;
>  	int ret;
>  
>  	memset(&data, 0, sizeof(data));
> -	data.handle = sev->handle;
> +	data.handle = to_kvm_sev_info(kvm)->handle;
>  	ret = sev_issue_cmd(kvm, SEV_CMD_SEND_START, &data, &argp->error);
>  
>  	params->session_len = data.session_len;
> @@ -1459,7 +1446,6 @@ __sev_send_start_query_session_length(struct kvm *kvm, struct kvm_sev_cmd *argp,
>  
>  static int sev_send_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>  	struct sev_data_send_start data;
>  	struct kvm_sev_send_start params;
>  	void *amd_certs, *session_data;
> @@ -1520,7 +1506,7 @@ static int sev_send_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	data.amd_certs_len = params.amd_certs_len;
>  	data.session_address = __psp_pa(session_data);
>  	data.session_len = params.session_len;
> -	data.handle = sev->handle;
> +	data.handle = to_kvm_sev_info(kvm)->handle;
>  
>  	ret = sev_issue_cmd(kvm, SEV_CMD_SEND_START, &data, &argp->error);
>  
> @@ -1552,12 +1538,11 @@ static int
>  __sev_send_update_data_query_lengths(struct kvm *kvm, struct kvm_sev_cmd *argp,
>  				     struct kvm_sev_send_update_data *params)
>  {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>  	struct sev_data_send_update_data data;
>  	int ret;
>  
>  	memset(&data, 0, sizeof(data));
> -	data.handle = sev->handle;
> +	data.handle = to_kvm_sev_info(kvm)->handle;
>  	ret = sev_issue_cmd(kvm, SEV_CMD_SEND_UPDATE_DATA, &data, &argp->error);
>  
>  	params->hdr_len = data.hdr_len;
> @@ -1572,7 +1557,6 @@ __sev_send_update_data_query_lengths(struct kvm *kvm, struct kvm_sev_cmd *argp,
>  
>  static int sev_send_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>  	struct sev_data_send_update_data data;
>  	struct kvm_sev_send_update_data params;
>  	void *hdr, *trans_data;
> @@ -1626,7 +1610,7 @@ static int sev_send_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	data.guest_address = (page_to_pfn(guest_page[0]) << PAGE_SHIFT) + offset;
>  	data.guest_address |= sev_me_mask;
>  	data.guest_len = params.guest_len;
> -	data.handle = sev->handle;
> +	data.handle = to_kvm_sev_info(kvm)->handle;
>  
>  	ret = sev_issue_cmd(kvm, SEV_CMD_SEND_UPDATE_DATA, &data, &argp->error);
>  
> @@ -1657,31 +1641,29 @@ static int sev_send_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  
>  static int sev_send_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>  	struct sev_data_send_finish data;
>  
>  	if (!sev_guest(kvm))
>  		return -ENOTTY;
>  
> -	data.handle = sev->handle;
> +	data.handle = to_kvm_sev_info(kvm)->handle;
>  	return sev_issue_cmd(kvm, SEV_CMD_SEND_FINISH, &data, &argp->error);
>  }
>  
>  static int sev_send_cancel(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>  	struct sev_data_send_cancel data;
>  
>  	if (!sev_guest(kvm))
>  		return -ENOTTY;
>  
> -	data.handle = sev->handle;
> +	data.handle = to_kvm_sev_info(kvm)->handle;
>  	return sev_issue_cmd(kvm, SEV_CMD_SEND_CANCEL, &data, &argp->error);
>  }
>  
>  static int sev_receive_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
>  	struct sev_data_receive_start start;
>  	struct kvm_sev_receive_start params;
>  	int *error = &argp->error;
> @@ -1755,7 +1737,6 @@ static int sev_receive_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  
>  static int sev_receive_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>  	struct kvm_sev_receive_update_data params;
>  	struct sev_data_receive_update_data data;
>  	void *hdr = NULL, *trans = NULL;
> @@ -1815,7 +1796,7 @@ static int sev_receive_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	data.guest_address = (page_to_pfn(guest_page[0]) << PAGE_SHIFT) + offset;
>  	data.guest_address |= sev_me_mask;
>  	data.guest_len = params.guest_len;
> -	data.handle = sev->handle;
> +	data.handle = to_kvm_sev_info(kvm)->handle;
>  
>  	ret = sev_issue_cmd(kvm, SEV_CMD_RECEIVE_UPDATE_DATA, &data,
>  				&argp->error);
> @@ -1832,13 +1813,12 @@ static int sev_receive_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  
>  static int sev_receive_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>  	struct sev_data_receive_finish data;
>  
>  	if (!sev_guest(kvm))
>  		return -ENOTTY;
>  
> -	data.handle = sev->handle;
> +	data.handle = to_kvm_sev_info(kvm)->handle;
>  	return sev_issue_cmd(kvm, SEV_CMD_RECEIVE_FINISH, &data, &argp->error);
>  }
>  
> @@ -1858,8 +1838,8 @@ static bool is_cmd_allowed_from_mirror(u32 cmd_id)
>  
>  static int sev_lock_two_vms(struct kvm *dst_kvm, struct kvm *src_kvm)
>  {
> -	struct kvm_sev_info *dst_sev = &to_kvm_svm(dst_kvm)->sev_info;
> -	struct kvm_sev_info *src_sev = &to_kvm_svm(src_kvm)->sev_info;
> +	struct kvm_sev_info *dst_sev = to_kvm_sev_info(dst_kvm);
> +	struct kvm_sev_info *src_sev = to_kvm_sev_info(src_kvm);
>  	int r = -EBUSY;
>  
>  	if (dst_kvm == src_kvm)
> @@ -1893,8 +1873,8 @@ static int sev_lock_two_vms(struct kvm *dst_kvm, struct kvm *src_kvm)
>  
>  static void sev_unlock_two_vms(struct kvm *dst_kvm, struct kvm *src_kvm)
>  {
> -	struct kvm_sev_info *dst_sev = &to_kvm_svm(dst_kvm)->sev_info;
> -	struct kvm_sev_info *src_sev = &to_kvm_svm(src_kvm)->sev_info;
> +	struct kvm_sev_info *dst_sev = to_kvm_sev_info(dst_kvm);
> +	struct kvm_sev_info *src_sev = to_kvm_sev_info(src_kvm);
>  
>  	mutex_unlock(&dst_kvm->lock);
>  	mutex_unlock(&src_kvm->lock);
> @@ -1968,8 +1948,8 @@ static void sev_unlock_vcpus_for_migration(struct kvm *kvm)
>  
>  static void sev_migrate_from(struct kvm *dst_kvm, struct kvm *src_kvm)
>  {
> -	struct kvm_sev_info *dst = &to_kvm_svm(dst_kvm)->sev_info;
> -	struct kvm_sev_info *src = &to_kvm_svm(src_kvm)->sev_info;
> +	struct kvm_sev_info *dst = to_kvm_sev_info(dst_kvm);
> +	struct kvm_sev_info *src = to_kvm_sev_info(src_kvm);
>  	struct kvm_vcpu *dst_vcpu, *src_vcpu;
>  	struct vcpu_svm *dst_svm, *src_svm;
>  	struct kvm_sev_info *mirror;
> @@ -2009,8 +1989,7 @@ static void sev_migrate_from(struct kvm *dst_kvm, struct kvm *src_kvm)
>  	 * and add the new mirror to the list.
>  	 */
>  	if (is_mirroring_enc_context(dst_kvm)) {
> -		struct kvm_sev_info *owner_sev_info =
> -			&to_kvm_svm(dst->enc_context_owner)->sev_info;
> +		struct kvm_sev_info *owner_sev_info = to_kvm_sev_info(dst->enc_context_owner);
>  
>  		list_del(&src->mirror_entry);
>  		list_add_tail(&dst->mirror_entry, &owner_sev_info->mirror_vms);
> @@ -2069,7 +2048,7 @@ static int sev_check_source_vcpus(struct kvm *dst, struct kvm *src)
>  
>  int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
>  {
> -	struct kvm_sev_info *dst_sev = &to_kvm_svm(kvm)->sev_info;
> +	struct kvm_sev_info *dst_sev = to_kvm_sev_info(kvm);
>  	struct kvm_sev_info *src_sev, *cg_cleanup_sev;
>  	CLASS(fd, f)(source_fd);
>  	struct kvm *source_kvm;
> @@ -2093,7 +2072,7 @@ int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
>  		goto out_unlock;
>  	}
>  
> -	src_sev = &to_kvm_svm(source_kvm)->sev_info;
> +	src_sev = to_kvm_sev_info(source_kvm);
>  
>  	dst_sev->misc_cg = get_current_misc_cg();
>  	cg_cleanup_sev = dst_sev;
> @@ -2181,7 +2160,7 @@ static void *snp_context_create(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  
>  static int snp_bind_asid(struct kvm *kvm, int *error)
>  {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
>  	struct sev_data_snp_activate data = {0};
>  
>  	data.gctx_paddr = __psp_pa(sev->snp_context);
> @@ -2191,7 +2170,7 @@ static int snp_bind_asid(struct kvm *kvm, int *error)
>  
>  static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
>  	struct sev_data_snp_launch_start start = {0};
>  	struct kvm_sev_snp_launch_start params;
>  	int rc;
> @@ -2260,7 +2239,7 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pf
>  				  void __user *src, int order, void *opaque)
>  {
>  	struct sev_gmem_populate_args *sev_populate_args = opaque;
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
>  	int n_private = 0, ret, i;
>  	int npages = (1 << order);
>  	gfn_t gfn;
> @@ -2350,7 +2329,7 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pf
>  
>  static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
>  	struct sev_gmem_populate_args sev_populate_args = {0};
>  	struct kvm_sev_snp_launch_update params;
>  	struct kvm_memory_slot *memslot;
> @@ -2434,7 +2413,7 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  
>  static int snp_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
>  	struct sev_data_snp_launch_update data = {};
>  	struct kvm_vcpu *vcpu;
>  	unsigned long i;
> @@ -2482,7 +2461,7 @@ static int snp_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  
>  static int snp_launch_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
>  	struct kvm_sev_snp_launch_finish params;
>  	struct sev_data_snp_launch_finish *data;
>  	void *id_block = NULL, *id_auth = NULL;
> @@ -2677,7 +2656,7 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
>  int sev_mem_enc_register_region(struct kvm *kvm,
>  				struct kvm_enc_region *range)
>  {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
>  	struct enc_region *region;
>  	int ret = 0;
>  
> @@ -2729,7 +2708,7 @@ int sev_mem_enc_register_region(struct kvm *kvm,
>  static struct enc_region *
>  find_enc_region(struct kvm *kvm, struct kvm_enc_region *range)
>  {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
>  	struct list_head *head = &sev->regions_list;
>  	struct enc_region *i;
>  
> @@ -2824,9 +2803,9 @@ int sev_vm_copy_enc_context_from(struct kvm *kvm, unsigned int source_fd)
>  	 * The mirror kvm holds an enc_context_owner ref so its asid can't
>  	 * disappear until we're done with it
>  	 */
> -	source_sev = &to_kvm_svm(source_kvm)->sev_info;
> +	source_sev = to_kvm_sev_info(source_kvm);
>  	kvm_get_kvm(source_kvm);
> -	mirror_sev = &to_kvm_svm(kvm)->sev_info;
> +	mirror_sev = to_kvm_sev_info(kvm);
>  	list_add_tail(&mirror_sev->mirror_entry, &source_sev->mirror_vms);
>  
>  	/* Set enc_context_owner and copy its encryption context over */
> @@ -2854,7 +2833,7 @@ int sev_vm_copy_enc_context_from(struct kvm *kvm, unsigned int source_fd)
>  
>  static int snp_decommission_context(struct kvm *kvm)
>  {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
>  	struct sev_data_snp_addr data = {};
>  	int ret;
>  
> @@ -2879,7 +2858,7 @@ static int snp_decommission_context(struct kvm *kvm)
>  
>  void sev_vm_destroy(struct kvm *kvm)
>  {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
>  	struct list_head *head = &sev->regions_list;
>  	struct list_head *pos, *q;
>  
> @@ -3933,7 +3912,6 @@ void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu)
>  
>  static int sev_snp_ap_creation(struct vcpu_svm *svm)
>  {
> -	struct kvm_sev_info *sev = &to_kvm_svm(svm->vcpu.kvm)->sev_info;
>  	struct kvm_vcpu *vcpu = &svm->vcpu;
>  	struct kvm_vcpu *target_vcpu;
>  	struct vcpu_svm *target_svm;
> @@ -3974,7 +3952,7 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
>  		u64 sev_features;
>  
>  		sev_features = vcpu->arch.regs[VCPU_REGS_RAX];
> -		sev_features ^= sev->vmsa_features;
> +		sev_features ^= to_kvm_sev_info(svm->vcpu.kvm)->vmsa_features;
>  
>  		if (sev_features & SVM_SEV_FEAT_INT_INJ_MODES) {
>  			vcpu_unimpl(vcpu, "vmgexit: invalid AP injection mode [%#lx] from guest\n",
> @@ -4134,7 +4112,7 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
>  {
>  	struct vmcb_control_area *control = &svm->vmcb->control;
>  	struct kvm_vcpu *vcpu = &svm->vcpu;
> -	struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
> +	struct kvm_sev_info *sev = to_kvm_sev_info(vcpu->kvm);
>  	u64 ghcb_info;
>  	int ret = 1;
>  
> @@ -4354,7 +4332,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
>  		ret = kvm_emulate_ap_reset_hold(vcpu);
>  		break;
>  	case SVM_VMGEXIT_AP_JUMP_TABLE: {
> -		struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
> +		struct kvm_sev_info *sev = to_kvm_sev_info(vcpu->kvm);
>  
>  		switch (control->exit_info_1) {
>  		case 0:
> @@ -4565,7 +4543,7 @@ void sev_init_vmcb(struct vcpu_svm *svm)
>  void sev_es_vcpu_reset(struct vcpu_svm *svm)
>  {
>  	struct kvm_vcpu *vcpu = &svm->vcpu;
> -	struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
> +	struct kvm_sev_info *sev = to_kvm_sev_info(vcpu->kvm);
>  
>  	/*
>  	 * Set the GHCB MSR value as per the GHCB specification when emulating
> @@ -4833,7 +4811,7 @@ static bool is_large_rmp_possible(struct kvm *kvm, kvm_pfn_t pfn, int order)
>  
>  int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order)
>  {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
>  	kvm_pfn_t pfn_aligned;
>  	gfn_t gfn_aligned;
>  	int level, rc;
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 9d7cdb8fbf87..5b159f017055 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -361,20 +361,18 @@ static __always_inline struct kvm_sev_info *to_kvm_sev_info(struct kvm *kvm)
>  #ifdef CONFIG_KVM_AMD_SEV
>  static __always_inline bool sev_guest(struct kvm *kvm)
>  {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> -
> -	return sev->active;
> +	return to_kvm_sev_info(kvm)->active;
>  }
>  static __always_inline bool sev_es_guest(struct kvm *kvm)
>  {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
>  
>  	return sev->es_active && !WARN_ON_ONCE(!sev->active);
>  }
>  
>  static __always_inline bool sev_snp_guest(struct kvm *kvm)
>  {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
>  
>  	return (sev->vmsa_features & SVM_SEV_FEAT_SNP_ACTIVE) &&
>  	       !WARN_ON_ONCE(!sev_es_guest(kvm));
> 
> base-commit: 86eb1aef7279ec68fe9b7a44685efc09aa56a8f0


