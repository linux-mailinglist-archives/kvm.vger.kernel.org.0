Return-Path: <kvm+bounces-34701-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A8F6A0495D
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 19:38:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D824A7A3525
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 18:38:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2290A1F37BE;
	Tue,  7 Jan 2025 18:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Wymhp0Iv"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2081.outbound.protection.outlook.com [40.107.101.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52A9190052;
	Tue,  7 Jan 2025 18:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736275091; cv=fail; b=I6aGTs3rKBZlh/Eq6/lbWkNQlcmqUuT2ALvEUM7TssWt+gj974oY+iB/kYdHbstUBYxUkvJt9iKUCPu+UgejbgcqBNv8AQ9MpoIEJzGGPhzLpvq56UyDGIMV2PdC5pTKkSYHvod6AxqoapAb+DholsnMT3hPlXJsA6m1ZjSIo5M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736275091; c=relaxed/simple;
	bh=8XJALDu7coJVD8dkQR+u1o5lwN1I00CD1WEyhUewQnM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HQjj/EQsLrLBHYlApmeqBB51iA0D3GCs7d8Sbhj1rz3BHBApSJ3tbFVqHM7r9OxOpwR56Ns+JuILIGiffJU7EB7XavU2j0JDW/GToT1rmmYWNIz30FH3bzVQpi/YCUGFx/dtC0IcYv0z6gf0wkfJaZm41Ss72KUo2lXmNJJa91o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Wymhp0Iv; arc=fail smtp.client-ip=40.107.101.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=awFC/378wnH8gA8/9glrFqn4BthqxNipU82MU/IDmStJpJESZjdBcWxt0ALecUtqfkXqhBx1bXihj5OwlHgu5D3XvL+6tSPV25yXOi4ni3jMv8CYp+q0ail0kd73NEWbVinHgobgXmWoKnkbAJzd5f3en4mYAjMjaEgA/48KueBdJeTdA5EflLFJ5VUEYXdXLvApiRChgqTgft3PWiqqOeQ4yszeJcGW6Y1iS9zMUVX7D5buZwGpKiNGlJfjSGRY3gl01C220pfGCQORrolNo8TZsFa3Ia1i86KOGjhGJq1S8orb3eFrKZp8EZeOlqu9JTZCRN37zchx9UhjnId87g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yvFdloemVMdBZMNg7Hz+4v/pPM4Tlg7P4VGx/GyiOt8=;
 b=WKcJbLIZJ1EQn8g5GtmvBAiXsJQnBP7idKd/Jq6fIM6DzobwYhYXor+qEqMflv6TpTvL73aspPlm3qG9ntuJlxP0Nc27mZdQHPg+TqgibaYVkC70tWTP3SWJ4cQTnE8DbG7ipuDdEjMdJc5wl2mCCe1KLuFthkuW18CaGe18Euq7d186Zn5x5IF/oP0nIKfwMHqQSw+v99BXNIES0ANHjwsQ3MuTN6GJfbc2dYBCRL/481Wc5q3nU9qQW+42b08caVqulIrCohh/JgRAmQWH+1+0wb+j/6j/XPbFRvhb9m56hsR7AX9ePJCYH6oVI34KwcMlQ79XIHdLd7GHTIiO1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yvFdloemVMdBZMNg7Hz+4v/pPM4Tlg7P4VGx/GyiOt8=;
 b=Wymhp0IvAwTbKbja6r7tMoFhgiFch6zVKMYPTjVkKfKsVFbFFOhODiL6GTS5Gs1mePQoOM3nmvIRATHZmYsRjad3Iy9pfnYoixBBQ9dEn76MnC614G2eJfDH7bSv4V1RTDp3xnE9uKZYTq350MjZYOQwEiefP/iJe6mYEeG3arY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by MN2PR12MB4486.namprd12.prod.outlook.com (2603:10b6:208:263::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.10; Tue, 7 Jan
 2025 18:38:07 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8335.010; Tue, 7 Jan 2025
 18:38:07 +0000
Message-ID: <4dde8da4-e29d-ebea-f33f-8389b2f47613@amd.com>
Date: Tue, 7 Jan 2025 12:38:05 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v16 01/13] virt: sev-guest: Remove is_vmpck_empty() helper
Content-Language: en-US
To: Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 bp@alien8.de, x86@kernel.org
Cc: kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com, francescolavra.fl@gmail.com
References: <20250106124633.1418972-1-nikunj@amd.com>
 <20250106124633.1418972-2-nikunj@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20250106124633.1418972-2-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0024.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:22c::26) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|MN2PR12MB4486:EE_
X-MS-Office365-Filtering-Correlation-Id: 8adb9e90-ce19-44d5-aafc-08dd2f4a6ded
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UlRIRzg2eUxTbFNzOGs4QmJsaE5KaU5rdEdsUmM3aWk2QXJhVFZ6Y1Y2c1B4?=
 =?utf-8?B?SXZPK0F4L1hRT0VkM0JwUHdKZ1duaHlmU3VGL2VVNFppQ21vbmVkOXNsNEFi?=
 =?utf-8?B?WTN5Rll3aUVxS0ROaERDam9kMU5aMk1JcGpnUDhkN1pkaGhJSWdvT1ZQeVMx?=
 =?utf-8?B?Y0pOOUgwNVpIakpOaUhvbUlJTVhnYzRuUFdiM0xKWjFseldlTU1Rdk5SallH?=
 =?utf-8?B?T1htOXVMRzhiMTZWWmZueXRaWGRWeU5uNkpvbUdKTXFORStxVEVIbU9sY0VX?=
 =?utf-8?B?SWNyRHV6eGtLTzZ2b2pOVnJhQTR4dVh6Y0l0MzEvSk15ZVo0MnUxNkRwY210?=
 =?utf-8?B?WXhhZUFkTmg0YU5iYmtGTkorMFNocnI5bk56Wnh1NDlTZkJ6VWRRQVVNdVpw?=
 =?utf-8?B?cFlTdkxubXFiTjJpMkRWME8wcmhtVVZXWHFsVnc5SlkxMCt3OU1wdTJSV0Z3?=
 =?utf-8?B?bjRURDFZcjYwdkNEeEprWlFuN2k0SFFHWU5BczNUMGh4S0dkZ0ZNdjF6eWZU?=
 =?utf-8?B?YVhtdllDcXdaejExVDFLRW82RmkvbDVMVFgwMFd6M3dwV0lPM3JoblFWcFpP?=
 =?utf-8?B?aHZockYxS25kWFd3WFk1L3o3NVRJTW5QeXlKa3BndTkrak1sdy95MkNZYlor?=
 =?utf-8?B?OCs4c0plOENYSk1HS2lTU0orY2NobVN5a21jU2x3bEpRdDJXV092L3dMbXUw?=
 =?utf-8?B?R3JWdXQwTllPL0VkbGNFckZaZFBFMk5mVlBkTkJlNk52Mno0Z0tXRjRTSjI0?=
 =?utf-8?B?aHlhWVU0OTJhSkpaU05SNUFveHUvTzl6U1pKNThtTU1HMmlmRkcxVDlOMER3?=
 =?utf-8?B?RHZrMjVmQ3krYmsxRHAvRW8vTVNaUC92U25NYzczaDNEblp2VnorSUN1eDh0?=
 =?utf-8?B?M21lZ2szRDU2L1JxbWRGNFVtME1qOWtmNGxDd1NZTXQ5cEExcFZiUmszMFl0?=
 =?utf-8?B?SjF3bVArOG5hdjVqTjZZd01oMkUwd2FZcHJVeU5FYkthN3JNQm5QTXpZdGIx?=
 =?utf-8?B?YmRDek1kVDFGeUhEWVB3TFhBTkhONkpoVThWNFpjTEZ5WlF1NFhjMXNjNHlV?=
 =?utf-8?B?cDNXVTlGaGU4bkgvV1d6bE9FeXI3a0xpNVFWVVltQ2M2VitkMjFlOHBCUFh1?=
 =?utf-8?B?QjRFWHVLOEVWRGF4bWxOOG5ZcEhRZ3dRVFpGbngweElVUVRiZmc0S3piUk16?=
 =?utf-8?B?NmVnZ0xCRVNWSWJSUC80K3hBdWt2OW1Dc09aZGVWeDVFeG11WEJUQ2I1UjRo?=
 =?utf-8?B?T2d2WTJXYmQrQ1FGOGJFNUh4MXY4Y2VLdnRyZ1hITk5aWjNoYXQ2ZWpuYzh0?=
 =?utf-8?B?NVpuWVVJc3ZZNUdseng3bmU2aGxNcU1NZTdWMkxLZFJrMjF5clhEODVPajR4?=
 =?utf-8?B?TzF3MysvNlNtSW92N0wxcHlXWmw0SUdOL0JTc2RIeHJCWnVGaWxLcHlMdng3?=
 =?utf-8?B?RzdkOGdSemxEUjUyQUpGbkxXNndGb0t0alc0TTNsdTRlZkR5cVpUa0xUVFAv?=
 =?utf-8?B?SUU4bktDQ2ZRMmU1cWFGTkN1OStJOGdYSjNaVk1LTlcwVGl3OEF5WXFmREdW?=
 =?utf-8?B?WXdNWWdBN1R0cE9RUEgvbG5vRytqaG14dGpNbUwxbnVxeE1tL3hadEFrODds?=
 =?utf-8?B?U1hVc3FWU3VpUXZPOU5nOCtEaURsWVBPWTRveHBmMjZURHhnTHNZRWpNcTFV?=
 =?utf-8?B?ZjFWbFpram16eWNaakpUYXFqL2tnMnFpblVLcGs3Mi9jT2VHdEpQVjdEVkJC?=
 =?utf-8?B?SU50aUVWRmdNcVZ3NDRYTU5ybHhMeHliYndVVDdOV2NNWXBUbGlrWDgyamJ0?=
 =?utf-8?B?eTZDUUE2UHJBcmlHa3FzTjA0S29JZU1UODZuQTMxbml2NmhoUVVEZlRtYUtW?=
 =?utf-8?Q?+J0NH1DHHgeUe?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eDd5L2IySVM2eGwyTHJaRjV4WlM4bFlQQmZPS0pJdmUveDhyak9IZzNEc1cw?=
 =?utf-8?B?cWNnNmN0TGo1bE9DQmJQT1NEWnZ3b3ArUmZhdmtwRTZqSW1iK0k2dW9zYkZ4?=
 =?utf-8?B?YXl5MldHSkF1a3RJNmNhVGQ0aU9odVN5R1I1Y0xENzJQZHNlenFsU3kvNjlu?=
 =?utf-8?B?b2ZBVlZvMU02ZjJVY3RpNHlWODZvVStxYUdxVi84VFFSZit4SExBeTlkeHE5?=
 =?utf-8?B?ZXlYdUJGbHRiSUtpMUZCQlFWQjVVY1k2Qi9sSEhtc3lHeWQvcGtsei9KcmpJ?=
 =?utf-8?B?T21NQ3RtMzRXUDJQb2s5b2JFL29GdDZiLzAyWEdHY2RkYXZzM21HSWRrOU94?=
 =?utf-8?B?S3RscytVMVl2cUJINWxTU2s0MzRKa04xOGV1ZDNKK0tqMUwvN2pNRHR3cndi?=
 =?utf-8?B?MnFLVXM0dE9xaXVhS3EyVUNBcVl0dUYxUVRUdFJmREltaEJEclhHd3BHR25t?=
 =?utf-8?B?QkhGOVRxZzhzdFZKSUd3bjhEM0oydFo2M2l5bEM5eVNSK0dzSkJ3L1JJVkhr?=
 =?utf-8?B?RHc1SGdiK25COU9CaVZKeGZ2NTQwTEkvUThKUzY1TW1HR0pEQnUrNFkxK1RG?=
 =?utf-8?B?RFQ2U05CS3NiRGxjUi8wRyt3K1B1R2tSWHJJT2VNOFh2UVBNR0VLOThXS1V3?=
 =?utf-8?B?Q1ZNdlkyUUcwSmhIVFgrRWNwOGRVUVRTN3I2Y2FweFF2anZ0RVlxNmFhUnFi?=
 =?utf-8?B?K2JwcEdCT1FMUzRPQlB3K2hUMjdzNWxBTHMwRThJaGlRcm5QSlZTanBrRE1Q?=
 =?utf-8?B?MTVuWXlBbUtxUURvS2p2cFdPQjdnSnUxMHJ6RmkyNmNaaEZHb2NHOHdFcS9w?=
 =?utf-8?B?MDZMZm8xZSt0bitiMEZIWWtqTTBUM3Q3NFY0ZDM4SUNYaWlLc2Z4cDN3WmU4?=
 =?utf-8?B?RzBNK2Nqc3BFb24rUlZuaWNwRVo4YWcvb2x1Z3I5dFRMSUVtYXYvek44NGJo?=
 =?utf-8?B?K3ZiOGZybzd5UXoxdUlORnd5R3JnMndsS3BUeEhjYjdTZDhSQUFoSlJ4ZGY0?=
 =?utf-8?B?WHI3QlE1YkxRRXBXR3hGSDNvQjFTd2RERFFhOVBxdktVYldmdjBIVU8za2l2?=
 =?utf-8?B?MlJLSWljNEtFbWhjTG5FRlMxazRIbDhoVHF4NmpPbmlvZGxlUFRRTE93VlpG?=
 =?utf-8?B?bUs5UWVRVlZ0NDNjMTJJbHVYOVRsOU1uVGhYOEhsSDdUcStIUlEzQjY1MzZG?=
 =?utf-8?B?VlluWXJxVHo5MTFDTVRUWXZzWTF4ZWphYlVzS3pycFQreE9CK3loN21Xck9U?=
 =?utf-8?B?NFRXcGltYWVmRXcrK0czUnFKZG9kUndDcExlV2prYjBlMUN5d2VmUlJUZDMz?=
 =?utf-8?B?SnV5YWJmSnlvVDB0K0MyUkh2U0ZsWi9RcVJjOEEyYm5vVDMyZnRucVRIWFlM?=
 =?utf-8?B?ajJDeG9vMjY0UXhiMkVXMEsvWnRzNzFvMW84RGJJZzNRU1ovTXErSUM2cWc1?=
 =?utf-8?B?V0tHMGJYaXc0TkcrdngwTXBVKzBma2Rad0cyQ2VTb0p1YWRTZkNoTitHVkkz?=
 =?utf-8?B?S1dnT1pwRlp4MWpLUVpXcTZmcDFRcm1pM1oycXFrQkl1ZVhOVFp5RkljSi81?=
 =?utf-8?B?VDc5L0NybERZdjBwVFRVSjYvdDI5c2thY2VpNkNEM2tJaHBxNHFDQWFpL1pL?=
 =?utf-8?B?NU5sZ3Y3MnZJMURlbCtWL2NWZmU5dFdyWUhTM0E4OWlCS2NEYjEzc0JQaG4z?=
 =?utf-8?B?WFUzRis2MzhpYVBPODA5QmlSdXRwSlUvL0FVVGw4VGMySnpTNytKKzVoZFBW?=
 =?utf-8?B?bm1aYTZZYi94S1hsemhJQTJvWXM5akNyNWQ4NDVHcy9iMjFyZ1pveGMrRFZx?=
 =?utf-8?B?VGM5Qmd5Q1hibXhrbWp5Zk5LYmI3VVQ0eHJZeFFiSHpNVVZWRTVxeGdUR0d2?=
 =?utf-8?B?b0xpRk1uWkNtakdXdzd0US9UYjdiN1RVekNHMXdoYjJHZ2ZJeHBPYTA4T0Vn?=
 =?utf-8?B?WCszTFFiNkdaeGF2VE9jWWZKNGpqQkViVGo0bG05WUdsUXJpRWMzanpNYmxE?=
 =?utf-8?B?MDBlVzVZZDZ3SzROQS8wcUJNMFlna2lRMlJDQjdOamFlcFVqR1lMNFFadEg3?=
 =?utf-8?B?QlpCVUlweWhUOHh5Wk4wcE9xQkgzWjRJUUNuUnZ3WnVJcFZGR05HUHR0aDZU?=
 =?utf-8?Q?b/DrsHa6M5eeMBWK60Tkc7UJk?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8adb9e90-ce19-44d5-aafc-08dd2f4a6ded
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2025 18:38:07.6396
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DInMc1nDhn8Tng6TGSSa0K7elOMWFH/i4thgdBYrU6RE91Ooi0vwVyhv+YSLPOH5foRrw5b6ZW7YkwLJwqPGtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4486

On 1/6/25 06:46, Nikunj A Dadhania wrote:
> Remove the is_vmpck_empty() helper function, which uses a local array
> allocation to check if the VMPCK is empty. Replace it with memchr_inv() to
> directly determine if the VMPCK is empty without additional memory
> allocation.
> 
> Suggested-by: Borislav Petkov <bp@alien8.de>
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> ---
>  drivers/virt/coco/sev-guest/sev-guest.c | 14 ++------------
>  1 file changed, 2 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
> index b699771be029..62328d0b2cb6 100644
> --- a/drivers/virt/coco/sev-guest/sev-guest.c
> +++ b/drivers/virt/coco/sev-guest/sev-guest.c
> @@ -63,16 +63,6 @@ MODULE_PARM_DESC(vmpck_id, "The VMPCK ID to use when communicating with the PSP.
>  /* Mutex to serialize the shared buffer access and command handling. */
>  static DEFINE_MUTEX(snp_cmd_mutex);
>  
> -static bool is_vmpck_empty(struct snp_msg_desc *mdesc)
> -{
> -	char zero_key[VMPCK_KEY_LEN] = {0};
> -
> -	if (mdesc->vmpck)
> -		return !memcmp(mdesc->vmpck, zero_key, VMPCK_KEY_LEN);
> -
> -	return true;
> -}

I still like the helper, but just using memchr_inv() inside it instead,
e.g.:

return !mdesc->vmpck || !memchr_inv(mdesc->vmpck, 0, VMPCK_KEY_LEN);

But either way works for me.

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> -
>  /*
>   * If an error is received from the host or AMD Secure Processor (ASP) there
>   * are two options. Either retry the exact same encrypted request or discontinue
> @@ -335,7 +325,7 @@ static int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_guest_r
>  	guard(mutex)(&snp_cmd_mutex);
>  
>  	/* Check if the VMPCK is not empty */
> -	if (is_vmpck_empty(mdesc)) {
> +	if (!mdesc->vmpck || !memchr_inv(mdesc->vmpck, 0, VMPCK_KEY_LEN)) {
>  		pr_err_ratelimited("VMPCK is disabled\n");
>  		return -ENOTTY;
>  	}
> @@ -1024,7 +1014,7 @@ static int __init sev_guest_probe(struct platform_device *pdev)
>  	}
>  
>  	/* Verify that VMPCK is not zero. */
> -	if (is_vmpck_empty(mdesc)) {
> +	if (!memchr_inv(mdesc->vmpck, 0, VMPCK_KEY_LEN)) {
>  		dev_err(dev, "Empty VMPCK%d communication key\n", vmpck_id);
>  		goto e_unmap;
>  	}

