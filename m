Return-Path: <kvm+bounces-42434-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 08240A78681
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 04:40:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 496811891986
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 02:41:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1ECB33C9;
	Wed,  2 Apr 2025 02:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="GLoQtc/b"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2084.outbound.protection.outlook.com [40.107.96.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B9763FC7;
	Wed,  2 Apr 2025 02:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743561641; cv=fail; b=FhG7aSalO8+bF604eTksES9B55/zaBAueOAh6gqR6JlW454o/z7uXkeMhlSjozVS6ruHlhIz6iHaDFLbqJTY23ZIAVfeXhpCDLsi7KjYtPY27U1GsB5raNHygvxFQsJfrjH8uL/Nq6AMo04N6dqvuXSLy6CnGuFewYvVRPkJCPw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743561641; c=relaxed/simple;
	bh=AhxpdACpPTdLh080URdBPDNrsh0zB9ljFyJEqcMxiO4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=i8TW2Ke+oMtwlHvDy+5KFaMPCVChgCx/ygUK3Of8jQo/HyNOkGKDXbDZ/rb0qyeuyNqp3MucYuNtLb2M1nfQhtxoCJ99ArUUwj62PgaFN4M2wPuYetAGzz7whQDt8GJVqWdyAflDoh7bzPVwHVRmOsMAPHQ9HIFQeMTX7sBJDMs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=GLoQtc/b; arc=fail smtp.client-ip=40.107.96.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MimWXA//7YH/fie100nAqSG5cOr+pckRQyLmzMukChefDgmNT3T50HkI1lD6vGbhoEmDCjs9wAUQ9Cs0isy2cETwBfpHRYx0ItufqnKAtOptii01Wd9IINCHFVWT4QwpbEMtTuVhGkOYDHOn0t0Irm/u7Pa1ASgluEI1FqWrfGKrKnrZnZauGtGPztGAAjx2Te1tx2xuxrBNyqnGKbe9nvJtFnvmi4Lnbucet2m9MKmoKzvQgPfBFQH1yBi8ZsDV8BljpPONLrid8lNqgTTSjpPM9/dX2WoeJ+wOG9P6lKhix2P7TS1eF53EgptHYoECbI6UCh+ubx/p5ipHHN9Ikw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r/EPc31LUKfQMaIe4Mt8qukMdqkZe2PL/rh/bSXat10=;
 b=oOtNwf2HIM/D6jCbZfHZZwQPBWT18/Byn4VFUzdr+dyhyl3uCrSMb6HHGF9/uoqyfKcwnG0JofXPIBVfTffWd3wcuLLMmXLMjeOh2oDyNpdFa+LYqKTR5A54K2BE5VCj5c7JAz9LfuU3IZbJexSfjYK8UvQ7XQg9abBX3lbDmoz4DHFFoltNos4idJNkZjxZ/TS008IcWp6oYHB3Pg2AtOMyrMtksAPIqUcGAB/QTqj5k8mUm3fTJWTi4GCZukeJtMa29CrcIl/MkRMv4HqoEox9WocsRqmP0dpJZelf9mdnDLoeoMsVeGtL+c0TMULzo/uSUZPM5AQ6xOm7TFDPxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r/EPc31LUKfQMaIe4Mt8qukMdqkZe2PL/rh/bSXat10=;
 b=GLoQtc/bGbLYnFKVUMl1FID0l8FH3rJbNSZQgbxqrWHX9Y0a8/WHkccdQyIhgk+0Nym1057bvG7noRmX1ttiq6nxx8sXV43A1EF6ji6dV00ArkiOie2L3hz1jM49KFTuRCfgcB9Mul70g5+RcEvWF6Yt6JqFE3ekyyAkHlwv9tw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 CH1PR12MB9576.namprd12.prod.outlook.com (2603:10b6:610:2ad::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Wed, 2 Apr
 2025 02:40:36 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%4]) with mapi id 15.20.8534.043; Wed, 2 Apr 2025
 02:40:36 +0000
Message-ID: <b797f1e7-81f6-47e9-bab9-b3db8f4c46e6@amd.com>
Date: Wed, 2 Apr 2025 08:10:25 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 14/17] x86/apic: Add kexec support for Secure AVIC
To: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Cc: bp@alien8.de, mingo@redhat.com, dave.hansen@linux.intel.com,
 Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com,
 x86@kernel.org, hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org, kirill.shutemov@linux.intel.com,
 huibo.wang@amd.com, naveen.rao@amd.com
References: <20250226090525.231882-1-Neeraj.Upadhyay@amd.com>
 <20250226090525.231882-15-Neeraj.Upadhyay@amd.com> <87a59e2xms.ffs@tglx>
 <be2c8047-fd68-4858-bb92-bf301d7967b4@amd.com> <87frirwx76.ffs@tglx>
Content-Language: en-US
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <87frirwx76.ffs@tglx>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BMXP287CA0012.INDP287.PROD.OUTLOOK.COM
 (2603:1096:b00:2c::24) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|CH1PR12MB9576:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d0733d8-26d9-4d0c-a2e4-08dd718fbf58
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eElzOVhVejdkdytmZ3VYUGZ4OU5JSUVqUkRlMGNLNkxlbWpFRGtsZy9NY3Jq?=
 =?utf-8?B?VTJVd3daVVdIT3Q1amt4VUsraFBVSmtqNmtyYmFhR2o2UWdWY3d5Mk9CZTc4?=
 =?utf-8?B?ZUhrYitaak5NcDlNSkpVcjI5WXlFTGdMeXlHUlZ5UE03SjQwQ1huQkdJdk9a?=
 =?utf-8?B?SmlYNW1tc0pWOWMwb1JoTSszTkVvMTIwNExJMzU1NjVLbkMyKzcvZS9PL1lk?=
 =?utf-8?B?MkNxNnkwdHZyZ1QxdXQrMkJIODJKQ0MzWWtKazk1NFhOejUydTNGU2FUWDZU?=
 =?utf-8?B?bVdlVG9kbXJTOUI4OFhNdjRqQVJNMytsSFFRQTNaWlZvWmlpL3kxd1JKZWJD?=
 =?utf-8?B?eFhPOURGRkNhN09vRitDZmZlUGszc1Jua2FmWUlRQjd5bXhwL2QraTdUSmd1?=
 =?utf-8?B?RFFLVjg5WmZONWVFd1daR21PN05yTW5EMnBZRUpRTnZsUWNaMWZWbmlDUGxZ?=
 =?utf-8?B?TzhUdWgrcWc0Q0c4TXVscng2RWc3bk1vUDUrbmVnVG5jN2xYdlQ2UXZmSFlo?=
 =?utf-8?B?c093TDM5UVZaRStiYXJ0UG8rck1PeHUxYzNqZHdCM3JHOFBWclFBTmd3Y292?=
 =?utf-8?B?UlJVVUFON2pqM3RPZjdJVHRZQVdlTlczamhOcFhQVTA3ajVzTjlIblZzd3FT?=
 =?utf-8?B?VjJlVmNoQ25UNHhKaTZITUxzamtWbjAzcExnMSsrZlF6NWdjc1ZLVHJmSGY3?=
 =?utf-8?B?VjhrL240Z3pKQzhqZXpsSWt2ZC9uTzh4TjEzR3cwVnhoRWw5THY0dTRmczhp?=
 =?utf-8?B?RVY4Snl2dldNbUJVTWFucXVVeGw4UUk2SDFsa1JlZ0FCYkNweC9WSjUwcEth?=
 =?utf-8?B?ZU5kUnZOamRHQTQwRHJnVm40MUtRczY2bXhaUVlxdHNZSCszY0pNbElKcVFn?=
 =?utf-8?B?dVBoMzV6UlJOeHR0cUtXZWoyYWpRYkpnT2VHUzkyZlp1V01ET3IwRWFPSDRO?=
 =?utf-8?B?VnBucHNPeE1PUzFsVEdybUtFWkpPQmRqcm9JVDNHRnoxWGI0VlAzWlpkNDVK?=
 =?utf-8?B?QkxUQkxTS3daRVAyczN4SDBpSUJYYjRGM1Fudjk2WDZkT1ZyQzFoekRheHV1?=
 =?utf-8?B?Y1pGYWg2S3RvMnJJdmdpRVhmR3ZBanRqdlpLNktVZ1V0TEVSdjY4TWY1SElS?=
 =?utf-8?B?dXk2enM0YktOSFhJRlVaVkx3WDc0V3d2YUdsSzZmM082YjNDeDVWNG0wU0xi?=
 =?utf-8?B?Zm5QVHRzRTk1bTA1UzJabksvcGR0UW5VL2ZYclRBelNQZyt2b1E5S2l0dmkv?=
 =?utf-8?B?WEVXUUNGYVBOemo4Ni9vcXhwWHIyNm13aW5EcWRMNXBTRXROSFRPRTlTeDBX?=
 =?utf-8?B?U0hkVEh1K0x2SWRCeHlUR0V5TmNmczRkY1h4NnJWK3JzeDJoVGZxRnJiUVp1?=
 =?utf-8?B?cjRvRnN3aHR4bjNlT1Q4SXcvZ3Q2UGFORzllTmlBM05nZ3BsNmN6T1liamdx?=
 =?utf-8?B?N1RpUnZaMWdYYTkrT2tCaWJTZWpHSHpuM1pwKzU5TURGY2RKRWtHNjhTQ3h1?=
 =?utf-8?B?RHVuc1BDS0FxNk9MTWk4dGxoblhmZmVjRTV1YmVPNjUwMEUyTkVsSlppODFs?=
 =?utf-8?B?UzVJa3NSaUpUdWNhK25iY2xLci80V1NGdlhSUy9hbXRWRDNKcWVCYWV5ckc4?=
 =?utf-8?B?RVl3a0d1UXphQ2RCS3MyTXVidElUNGVjTmovMnp0bnNSdWY2ODhid3Q0S3Bs?=
 =?utf-8?B?R3BZRGJMWHpzK2tWMW1kcFF4U0dDd3JJZFhHelZBeUsvYnhmaTUxVE85RkM1?=
 =?utf-8?B?M25sNll2VkkrNjYzdE96aDlmWFBFbzJVOWw0ckl6cTM3Nlh4RWZ2a21NUW50?=
 =?utf-8?B?Rm96Yk00K2ZIanFuTHV6bGRYMHRNVVpneCs1RUdvMnVFUmw5dEl3ZGVjWXho?=
 =?utf-8?B?SzBvaHM3WFY0aEtxQ0hreGNod1ZhWjZKU3h6Z3BGTTBxL3Q1UUtJb3N3ZkR2?=
 =?utf-8?Q?nnd8vLdh/10=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZGJFOGg0TWtEV2c4SUI4WkJmNGoxcmRKbmNOWjlYVFFJZFJWL05DcEhKVWhz?=
 =?utf-8?B?SnkxUEFwL0JVcHZKMUc3VytYTmM5Z3RmWGlxbjhBQ3NiRkZCSUd2UUsyTm1h?=
 =?utf-8?B?UzZtR2hSQURKSkJ6cGZIWEhOcnVsTWZPVGpueXpmZmFvc1lFcThJbEZCL3I3?=
 =?utf-8?B?YmJBamJwNDF6QmFzNXUwS0xrNjZvYXpIeS9malRPc1V0TlI5aTNsWEpaMG5C?=
 =?utf-8?B?NCtoVEs1OVB6cVRFMFMzeEc0MHFJQ1pITFVUcHpDakxBdlRVZisyWk1Hb0pJ?=
 =?utf-8?B?clNuYXIrbStkalZuaVpWc0JiY1dUdjBzbHcxekhWVHJ1Y2VYWlk1RGNDeWVn?=
 =?utf-8?B?NWhJYWp0dzRRSkhUL2lXY09vQTcxSjdTQ0JXRmhGcnpOWjJ0ZFN4bTNicjBL?=
 =?utf-8?B?bzA3VjZVSGhLMWxPYm4yOVQwcXRKai8yL3RpRkVGZnRnOXpVNlpJZHlvYks0?=
 =?utf-8?B?SnlUSVRISUU0eXU3TElrYzQ0SCtaempmU1pkRzl1cjQ3TzRYYXpHSVRPQlBx?=
 =?utf-8?B?UGZGVjhWYllmZUhvUTFFclVWTHVTc2NWSHowWmU4eWc0Q08vQ05UUzRFemx1?=
 =?utf-8?B?K2ZHanN3SWk1T2NJOW5XdysxdGdFZWJTelh0dlhLNEJ1STdPVGFMelR0M3Nv?=
 =?utf-8?B?VzE0YlpXbzF2MFVxYlR3bitaQXJEMDI0bEJhVU1DQVRialBLdXg3Y2RlamtI?=
 =?utf-8?B?dlBmMzl2cnEvNEYxMmRmVEJway84RTIzL0RkcncvR0F5SFFlbVpvd2lNdlIz?=
 =?utf-8?B?VG5CUFdEUXJpQnV1T2FyUzNETnZZRFhGZ0pvK0EvRExwL080bUdYaWU3V25J?=
 =?utf-8?B?dDQwNXdIY1dkcURrOFVyUEU4TDNQaVUvYi9DVTRHaENqS1RsWThWQkYxd1hT?=
 =?utf-8?B?a3NHTEg0ZThZQ0hidDBmeTlRWmlURzdva0M0RGtEZ1pyd3VVUzRGUk0xczgw?=
 =?utf-8?B?Rm91TFNIcTlJTnZWWGFFbzRkV2xYLzhkRmZIQzhrZVYxd3NpQTFRbVJMTm5v?=
 =?utf-8?B?c21LVkxiaFdJNm9tbVpNdkoyMDhIRGowT0JnSW5RdzlJV2JLK0dBVEhFMER0?=
 =?utf-8?B?dFYrRzdkTk4rWHVjWEVVeW5oSTZEOWdkdVFJM1dvOUVRZWFlWndJbWJra1ZL?=
 =?utf-8?B?VXFNaFJFNWVLWXdNMzJDNWtYNDBxTjEwUVdvUUEvYUN6cXZGQ1ppb2crUDcw?=
 =?utf-8?B?cDMwZHJnUXE2cTc4WWVxVG1GU1hEUnVxREhJenNwU3d0WVlweEl0Qk5TcVdy?=
 =?utf-8?B?SjlSRU9RNkpsZ3FreUZKc2Z6M1JiT3BZN1hWRVRnSEFCZXJxS2lOUEJFb1RC?=
 =?utf-8?B?ZExKaWtXQXEvekZxZEhqOWI4ci9vS2JDY3gzMlJQSUtMUklQeTRiMW0vYmQw?=
 =?utf-8?B?ZWtGYk1neWt3VkFIMU5aS09QSElsc1BCRGpLSm1mNlIyWWRYbGZHaitveHRx?=
 =?utf-8?B?VTZobHlleUZKeE8yOGZQeFg4c3RzMHkzT3NBZjl4ODVHU21pSVVmczRjVDhJ?=
 =?utf-8?B?YTFQQnRrQWUvME5hYmZuMWttZFNseEJzdXJocENHMGVxZ0d0dVJBWVRXZVZV?=
 =?utf-8?B?SnV2azBZTkhLSVVyUjJjeFhrakpocTZpWnduOWpuMzlMOVUvSE14M2VOTE0y?=
 =?utf-8?B?NTVKbkR5VkYxSkx4THVJNGU4cmZHSlZHcE5tSW1wbUEyMDhJdFkybEtjdmw3?=
 =?utf-8?B?QXpPN3FPTFQzSXZROVZ6eVowQ2oxV1ZJS2Zlckdzbm1CNk0zOVBUa2R1YWlS?=
 =?utf-8?B?K3NUUElHcC9zcStLbzR6RUl3ZEgyUVYyalNqdmY4VXovRlVPeTdMb2NiWG1M?=
 =?utf-8?B?QVl5WDJxb2JoMlh0WGYrU3V3Wkw5Nm01elg3OFV4SnJPRTFwb2ZVcGRjQ0hz?=
 =?utf-8?B?OEhLLzkyN25pSXZtVWQyRmc0OU1PUUpidjluem5hNXdnanpiRTJYL2RJL1ZE?=
 =?utf-8?B?MlhVazBjdlFUUzF4YWo1TldGVGd2QnYrVDJlbDExWUd6WHRjbUFHdWFxc0Rx?=
 =?utf-8?B?emtMTElxaEtQOGJLWTcrRGtvK0dvalVOUkFRTktmaE0wYTh3NEVHTXRqUzc4?=
 =?utf-8?B?cXJpd1pwVlR1Uzhkd1p4NGFkZ0tpbmRmVGRSNEVCUHlESm9uRGN0emVBNEZL?=
 =?utf-8?Q?NN6zpIxWwo76rjtIHgJvZ4E9G?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d0733d8-26d9-4d0c-a2e4-08dd718fbf58
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2025 02:40:36.4995
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RyfHESv56E/B67GBgyuBNU4RHoC12p3jtAC90yBYzl6ogbwYzaNVq7pTvX+M3iaw4LJ97Sn7zhC7xYKnZxRcfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9576



On 4/2/2025 12:01 AM, Thomas Gleixner wrote:
> On Tue, Apr 01 2025 at 16:05, Neeraj Upadhyay wrote:
> 
>> On 3/21/2025 9:18 PM, Thomas Gleixner wrote:
>>> On Wed, Feb 26 2025 at 14:35, Neeraj Upadhyay wrote:
>>>>  
>>>> +/*
>>>> + * Unregister GPA of the Secure AVIC backing page.
>>>> + *
>>>> + * @apic_id: APIC ID of the vCPU. Use -1ULL for the current vCPU
>>>
>>> Yes, -1ULL is really a sensible value - NOT. Ever thought about
>>> signed/unsigned?
>>
>>
>> In table "Table 7: List of Supported Non-Automatic Events" of GHCB spec [1],
>> 0xffff_ffff_ffff_ffff is used for Secure AVIC GHCB event
>>
>> "RAX will have the APIC ID of the target vCPU or 0xffff_ffff_ffff_ffff
>>  for the vCPU doing the call"
>>
>> I am using -1ULL for that here.
> 
> Which is a horrible construct, while  ~0ULL is not.

Got it. Will replace with ~0ULL.


- Neeraj



