Return-Path: <kvm+bounces-26833-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 50FA39785C1
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 18:29:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0F02428876C
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 16:29:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA2B86F2EE;
	Fri, 13 Sep 2024 16:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="OzCDppUu"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2050.outbound.protection.outlook.com [40.107.243.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 880B047A73;
	Fri, 13 Sep 2024 16:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726244945; cv=fail; b=JIi19LgZJ82Sx8tXlBPzua1FnmxGgNcj5dNThKewtITbhx3rqhIuYrFyD/ios4aeE0h0ABq2QZPZQfqjmUy1F3bUpY9mAdi48TGeMoLOr8E6n8ft+WxQkws10t5JF6gtyMcXKJzsOV/c+eoRNsJONWnnlguARgZoOHFUYHdqBJs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726244945; c=relaxed/simple;
	bh=pIhwjH5MGT3qtrZOP0PwCkKucBeNTlifKQKAst7K6no=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JJSzdrCRHlHMTmIVUC39TQMiJjTtzqFCIZ/I/mbAoXX26OEGQ/piAm9LojIxq8y/O1qM9wPGu7aqA9BDAnoAifAxn9v2TwkHLyowUHvjtFP1bpu4wuQxycdqz5sQ/3tn2Gze5t1ERZcyE3N9JEZB0+SC0tr1JtKR0eNU0P/gRTo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=OzCDppUu; arc=fail smtp.client-ip=40.107.243.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L+nLpzYwePCUZTREPTvO0grwX6bbSCKvDJmZ4eAlFG0mxd6pwHJVIip+h4M8ZAV83Y30dR1vz8BmnAmrCNOdVNIE4xE8G0SOrSWqthtfiz/3ZgxnHJJgnFYiOES4biw38SJ6xPz47dypMx84xKbpXT8BxBy0CXAQIiDeQR6T87VWZZugiVDjsBR3xK4Btpqi2VPALkNUWZT0ASE2UEoqvlVC/rLNCSc46CWCYdm61F1WlqyoZTCS63nZY6SUkP9f4y24ekwNYsYrdT+/nhAL2nCpcoNzaPEXvS760xNulW0/rkb59rL1fJwQSL97dOS/Y46wz0mi7Taj7WqaYht89g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XKLHp+2bqhm50rzBJEHMzCkSJ1dQS/mltVBTryL0KmU=;
 b=nsSlWKkgiuhVgmJbN3VOSP4ODBgatXdb0toMGDkmug890kUWtU7Q+MTiP1uaZprIVN0wCgAPOyfktvNyO05+Blp9Th3Ar8/YdyKVzMK3ZBOueAiJEIuSO5DQ6HNeE/zuO0Z9ZjlcW/7jfpCK1j8q6AGSOQd4oIcOorAQlEnw2IN4PE0qRIzZZrQ2KmcaEN6bW4dIgzcfZKQ5ukjbTuhz7/dD7M4hoXIPunD8xxSEPIekQDAmaSM0bCPDd2F9VJ/kHtmscmJESsPgdhJ/LmpftECz+LW9OmY8nkdE/pV/AOGZslgZXSw8MD7QPmPGgH0Dq6yUYdl7tzZIl8E5D0Plmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XKLHp+2bqhm50rzBJEHMzCkSJ1dQS/mltVBTryL0KmU=;
 b=OzCDppUu+dijoEWdfh/hvggJ8ERXamEVEg9GI1JW2z3fenTRA1Ma7jtt9RPqGKkglpK//3kFcvVsWukEdMc+VW0aP6mZ8RwMZlBV/fu07XCPSCkblxasc9F/oLqdYoUuLRqoRw3eGgpBWinzUZSDIoQbAb7Af1IFHSKmDa764Sk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by LV8PR12MB9451.namprd12.prod.outlook.com (2603:10b6:408:206::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.25; Fri, 13 Sep
 2024 16:29:00 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.7962.018; Fri, 13 Sep 2024
 16:29:00 +0000
Message-ID: <a98c1ab8-ea15-4a31-9246-754675e13928@amd.com>
Date: Fri, 13 Sep 2024 11:29:03 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v11 14/20] x86/sev: Add Secure TSC support for SNP guests
Content-Language: en-US
To: Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20240731150811.156771-1-nikunj@amd.com>
 <20240731150811.156771-15-nikunj@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20240731150811.156771-15-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0072.namprd11.prod.outlook.com
 (2603:10b6:806:d2::17) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|LV8PR12MB9451:EE_
X-MS-Office365-Filtering-Correlation-Id: c7c8f8ca-cce0-4c00-6b92-08dcd4112c4f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YlIyc2ZRbFpJc3BvNitDM0hnSFE2WGI4TzlWV1ZRUjRrZkVOTTJBd004RHFN?=
 =?utf-8?B?TmI2anZFaFhpR0hVWkQzSEdtcnU1SVhTY3VVOGJNZlY5NW94a09zc1NoYk9B?=
 =?utf-8?B?K3JyUzNQNzZDb3FyUVgvZDV3VE1kT0JDSXc3UFd5SEpuMVhnMjFBaWJBYTVT?=
 =?utf-8?B?YnJNMjZiaFBJaVBkQ2VJdy9SRW1KTS82OWNHMWt2Q1M0RG4vRmFaWWdVQURC?=
 =?utf-8?B?cUQ4QnpsZEpKNXcwYjNUYUtFdUhBMXRTWmlUbDVmY0g0QjdYc1FiMzA2TWF0?=
 =?utf-8?B?S0NkdjhrS3Q4bnI5WlpJeUJWUUtLYkV3bG04OTNONko0NCtXRFpGTE5YTk5w?=
 =?utf-8?B?bEhBV0wwTCtBNlUvaU1ZS29TbWhwNHBpcGd3WUkxWktLUXhSNTkvblVjbTky?=
 =?utf-8?B?NFZTbnVuQXlRTzBidDZFT2I1MnBjM2xxbEFjOXI2VVovN0xWd29uQklEaEN0?=
 =?utf-8?B?Ymw3R1FvZC9MZms2UUcwb3dqV3FmUlVOWmVVbzRpRmpicnlrbXhCby9FckEz?=
 =?utf-8?B?VW9FbmNRVDZ4alozMGVwc3dqTWtyN3Z1RGFkd0tKd3pTRGV3ZGJ2OUpHMVNv?=
 =?utf-8?B?a2pjOHhIUVRyeHY5Mk9QTER5QXIwcDdQYVlUL1JPbTFWWHYzOTBwUkhhTE9u?=
 =?utf-8?B?S2d2OVNISWFSMjgwZUNyT1JyOUJZaVpkcmswOWp1YjM5MXlRQlpBbzhCelpy?=
 =?utf-8?B?bmRPS1JRbXZBSDk3SHpiZzJrV01vNEdIOTRCazJSM2ZXMU5YdzY3clI3cmlD?=
 =?utf-8?B?NExLeGRBaUkwVTdLUWNyTXovWjQxT0xLbXpsNnV4b0srYjNQOW5QWDVENER2?=
 =?utf-8?B?QXlpTmw1OHBrQnVlS1pzMlVLWjVVbGU1YnBYdWRZb3l4RE00cExBL014a3g2?=
 =?utf-8?B?YzVsRHZMcTZDOU41bjZFdUNEc3V4aDB0OEFDYUNCcExLbEZHU0Y2a1M3VEc0?=
 =?utf-8?B?S2RkajYwK3JPbXFmMTBBTnVnb0daeDNJaXlGa0U1UXZTZURTUjZEV09qV3Ni?=
 =?utf-8?B?RUs2UGFyZ3ZJQjdtS3ZwN3NIZlh3TUJCWlEzN0tDSzN1Z1ZuYk96TjBtSk5r?=
 =?utf-8?B?T0hyZS9KUnlTZzJlVUl0RGEwdUVkTFFjYmEyeVNxRytUNUlGY09EZmZOWXl2?=
 =?utf-8?B?MmJ4SDJweGkzZGovbjRaR1UyV3FMNWIxQXcrR3FmTGQ2TWd3VEVINTJ0c0Iy?=
 =?utf-8?B?Z2h4WDJ0ZlZneHJ6emx0cnEzMzZHanV3eGgxd09XRWU2M2ROVGZ5WDdSclN4?=
 =?utf-8?B?NzE3VUVxSXlRTmJLYm5aNmsvUm5DNXRTajlpU0hZcXhYeEI5aXlIZWVoTUFC?=
 =?utf-8?B?bUxVUWlUZkJTbDVUdHk0Zlo2R2pvNWFudElEMFBJQ3VkRW14ZU03a0RpQUlE?=
 =?utf-8?B?MkhKTTltcXdQUEJTWVpkS1cySzVKRnQ2Y05zWkNacWUxZkRHa2k4OThDVDVn?=
 =?utf-8?B?dTN2MXFIUzl6Q2hOelRFWGdPNlRneGc0YmQvVW5ucjNBY3NTam81eDc5U1N5?=
 =?utf-8?B?emNSclg3S2MxS1FwYU9XZG55Y0NHS2lhL004RFB1OHJWcWQwZFZhUUV4MUZn?=
 =?utf-8?B?UnNHMEdZUldtSjhvNTJ3bVdJTkc5cjlCdEdNTzRHTHp2WHBsNk1VbHJjbUxM?=
 =?utf-8?B?aHoySGQ3MFJzOTA2SHJtSGRaSmdDNEUybjVpSWNUZVJOZnY4WjFHclBZZjBV?=
 =?utf-8?B?VVRvUFR3RzAvTC9EM0o0R3B2ZmRQY1dyM0xwTi9ZVTloWkdhRDZZOHVpR0ha?=
 =?utf-8?B?bGFabmZHemhZcFRxTHBiQzZNNGNWeUZQUGtmdFkyN25DL2J0Tm5SZ3FOK0sx?=
 =?utf-8?B?aFFySFZ2NmNhc2MyaXFxQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?djNWVmZoem9CVTBHUlZzZkx6K1plVXVJRWdJZWplYUx1M0V0MmhMcGE3SVhD?=
 =?utf-8?B?NUNGdVFMeUl2WXV0c3dOaDl5MGNkQ1ppbDlvSmx4aFNUNkpXM1hEM0xvTUFj?=
 =?utf-8?B?b254K2t4Q0xaUUlaTHJHUW4rUWI4V1R1VjhBYmE0cm9jL2VDNDgvekdzZGZ5?=
 =?utf-8?B?RnlUT25CcWR4ZHZFbFNVWXc1S2lSS3ZQVXVRMG5iVEE2YU45b2xPL2lCenNo?=
 =?utf-8?B?cEtBWGIranozU1BralhyTGw0Zk1oL3hGTU81Z2xVRFRQWVBnclhqWTZsOC9i?=
 =?utf-8?B?NnR1TDMxVzBuczFpQ0o1TFU5K2lhY1crRFFrNDJ4NU5jbGxKb0xyS2dJT0I2?=
 =?utf-8?B?blJBeEkramVudkdTL3pjY2ZMaUlRU3kyTTRkeVF0WitLMElWUWVTMlBTNWM4?=
 =?utf-8?B?UWF5elErKzRCT2wxek1nR1FtREU0cHNWYkFkWi9ZeUpXUFZZVnhqa0FkNm43?=
 =?utf-8?B?UE5sYnA4VTRoTWVOZ1YxakxJK3JtVUVoK0s1SUNJZk5udzdLaXV0OFhUNnc1?=
 =?utf-8?B?YmlCRHBkT1lueFpqK2pDNjhxV09zWnpBZVJYYUlNRVgvQWFYclQxc0hpR0lp?=
 =?utf-8?B?UXJiZ2g3L2ZCc1lmcTRWc3R1TmNHWnhNTmI0WVJwbkhPOTZ2ZGRhRnRQUTU0?=
 =?utf-8?B?ZzJhbk1DNzFZUEFicVlaSGordldkMDRHcHRkSUw1V3pMY0Q3U2hqYlQxS2J5?=
 =?utf-8?B?K0FuMTZhZ0QzQUlLQXp3c0ZCY2RSY21yUSt5Qk1FUnVUdUZqam9ZeEsyNHRv?=
 =?utf-8?B?Q1VoTVBESmlEYVZpaURBTzg1WmFNOFBOUUNtWk9vYVQxV1FidWtTK1V1SGs5?=
 =?utf-8?B?dmVqakFseFpFVllneDBHNTlzNlpmNTFYS0J3TXk2bS9EbzNXRGs4Z3oxZGdq?=
 =?utf-8?B?UG56UVgxRUsxditBbEFIZFpnblBCQThySFM3SEtuR1Y2cnpFK3lMMWloT0p3?=
 =?utf-8?B?VUFGRzZpTll6ODhzbW5mYjRPRk42dlRUcWUxVml4enJZR01JV21xRjM1UmNV?=
 =?utf-8?B?cUxteFVmMk9uTnkzSGt3MFNEeWFRcFFOL0daMlFGY0lQV0NlWmZUbnQwbXN6?=
 =?utf-8?B?Y0RaV0s3VjJYYTJSSkV0VGRMczl0MzVDck50MG5TdXd1SUNyd3FoMzhhbnBt?=
 =?utf-8?B?Zks0Zk43Q252ZytaeVBQdUk2REpCcS81cGxGUDV1ZDBTZHhCdzlzcThseHBS?=
 =?utf-8?B?ckFwVEs2UTY5SnNFU1JMSE1CRjM4dVgrbkR2cVhQc3ZaRzc5dFR4ck5pbExS?=
 =?utf-8?B?RnZ3NWZQRlFtUndLSjF5NTZOanRzRWtEZzFDaHBKUVFoUmx5TWg0dEV3Wmtw?=
 =?utf-8?B?bXkyTHo2bHM5a1hoT1l0N0I5bmliRXVWdGt5RWJZOTRqenAvaW1pQ2ZSWU5z?=
 =?utf-8?B?dTVLZWxpZWUrbHVWL2dyTGJCdzJBRE5jb3pid1FIajhBdm0xVlJuRkt2Wnpt?=
 =?utf-8?B?ZXVHVzQ5OC93L1FmM3dTdTJWK3pQR2RKc2xGbDg4U01GSE9QNVMwYjJ4ZkdJ?=
 =?utf-8?B?WFAvRTVYZmFvWkJSTGtkd1M3bGV0K1BUb0dVNkpmZlJLNFR5cGFLVEJ0b0RJ?=
 =?utf-8?B?VTgxMjl5ZFZTTlFaZXdVVHdXVG9qbkxrYXl5dk11Ym94cWg1Z1ByNFhES1ph?=
 =?utf-8?B?SDZFLzFLd1g5NDVhV3AxblB2Ni90cGJRTldwQS8yN2YzcThhNjc5NUhDZWRx?=
 =?utf-8?B?eG05bE5aS3BXbjQzTUpycTJ2WXBsZmJVRnFRdnVpTXJGU0xSYkN1V3VGT2tu?=
 =?utf-8?B?b2NvM0hMTm5jblI0ZGhWNTQ3UzBVUHNzQXhQNkZLcG8zekN0ZFFROFlZNWxq?=
 =?utf-8?B?Wk8zZkNUY3dqSWdTWUR1UFB3SVRoVTd0VW1rY05qeEZuT09YM0QyQVdLRXBm?=
 =?utf-8?B?MXRYWHVtVzg1Uy9hZVpHTVM4V3ExdUlWWmU4VU44MkhLVmZsOHdjRzRLeUkw?=
 =?utf-8?B?UW9pcnpFdVRia2ZURHhoditVWkN3MU9KZ0pmK1Ztaks4S2VLenBMeThmVWhz?=
 =?utf-8?B?Y0c1UmdIWllHbmxMRVlBMGdEb25ySjR4VnhoTFU1ay9zenpHRUtlWVNGdW9I?=
 =?utf-8?B?YVZDM01XelprQk1NODk0Njdyb2dJc0dvci9MZkpXMmlXT2ZtREVOOG9rSzR2?=
 =?utf-8?Q?NVKBchnDfscVGV5wqrxQeL49S?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7c8f8ca-cce0-4c00-6b92-08dcd4112c4f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 16:29:00.4033
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d/dOZoN5ECotx4kPxAef/fPq2fsgQywfoF9Px0jDs9aCCcnjwhubpMQYCyKDmvlUtyHDC6K8hY+O1D+qJ5EO8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9451

On 7/31/24 10:08, Nikunj A Dadhania wrote:
> Add support for Secure TSC in SNP-enabled guests. Secure TSC allows guests
> to securely use RDTSC/RDTSCP instructions, ensuring that the parameters
> used cannot be altered by the hypervisor once the guest is launched.
> 
> Secure TSC-enabled guests need to query TSC information from the AMD
> Security Processor. This communication channel is encrypted between the AMD
> Security Processor and the guest, with the hypervisor acting merely as a
> conduit to deliver the guest messages to the AMD Security Processor. Each
> message is protected with AEAD (AES-256 GCM). Use a minimal AES GCM library
> to encrypt and decrypt SNP guest messages for communication with the PSP.
> 
> Use mem_encrypt_init() to fetch SNP TSC information from the AMD Security
> Processor and initialize snp_tsc_scale and snp_tsc_offset. During secondary
> CPU initialization, set the VMSA fields GUEST_TSC_SCALE (offset 2F0h) and
> GUEST_TSC_OFFSET (offset 2F8h) with snp_tsc_scale and snp_tsc_offset,
> respectively.
> 
> Since handle_guest_request() is common routine used by both the SEV guest
> driver and Secure TSC code, move it to the SEV header file.
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> Tested-by: Peter Gonda <pgonda@google.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/include/asm/sev-common.h       |  1 +
>  arch/x86/include/asm/sev.h              | 46 +++++++++++++
>  arch/x86/include/asm/svm.h              |  6 +-
>  arch/x86/coco/sev/core.c                | 91 +++++++++++++++++++++++++
>  arch/x86/mm/mem_encrypt.c               |  4 ++
>  drivers/virt/coco/sev-guest/sev-guest.c | 19 ------
>  6 files changed, 146 insertions(+), 21 deletions(-)
> 

