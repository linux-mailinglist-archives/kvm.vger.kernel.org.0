Return-Path: <kvm+bounces-34478-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5091C9FF767
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 10:30:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A53DE7A01C9
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 09:30:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D651119CC37;
	Thu,  2 Jan 2025 09:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="CzofBbAx"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2068.outbound.protection.outlook.com [40.107.94.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4DD9199938;
	Thu,  2 Jan 2025 09:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735810225; cv=fail; b=QZhCGgZyI1Rla02oclp4z7Q/M8ixA2j17EqG89ctdimAQqPD0Xc7l6jxXbjqCoyNg4qg/PdinukjfdKoCZyW5AiGWZ8sY1fFwrUIFOx5S513sVQExdM7JuB08etONAJ+EjPLElV6tCN8vzGyt/CzStinkSGMfoujoZgBA4deGds=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735810225; c=relaxed/simple;
	bh=UPsqcE/lFQnM84wAWc/5OUOw+Py2w/KwuxzDBgPrHEQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=AEoqwYD9VoWbbERHr8o7ktwMa4tkWWAVyrLtMNzxBLUI8uXzkI0pchM66Ys30EfoHIpXb8AYaaTLZN7X6Eo7WYSvKJsfnXKqfAq5ocbmvJdnBSrsLfJCkftLQYGVcCS6mmunhhL388AYAaL58VWqhiJlZfXqzdvzRkjdAy+6Nf0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=CzofBbAx; arc=fail smtp.client-ip=40.107.94.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iPj3sbXJ26CVg0nXaIQB40CpmSfkQMgz5HDbIJqNjfGe4vo/m340+H68gDfZWOTgxZIegsJVYbCB+JuFyS2yx7IMZPJJRcacBme9Z02Ipc3pMXk7lQGaGwkQ9vmZHus1fPnFgrnLPF8EvvGNucISYA6GXGSJ+oShFRWqOvUEkdMkzhUruRTC/1wqd8z2M65ifX3XYA2/oyfXXnaHrr30ODySToqW7s0H1iH9H5MlGt00zjcUpfQnwAcKRLkeSo9skTGjgsngOvZuIWxJkIunf9SnB0ohQzYZRk5N4ExzWwz5FAC3RvWev1NNZkb5Fp/iigQa1zg0R1Ab2W2yLDj3wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sVDnoYg58hpuziik8SFyLTq4p2L6XRifIVZNZHuYrtY=;
 b=XX1bLwM080OkmOh8P2yKoacqNw7peb2dc7Ql3c9B6yHnxOuLGhENnksnqIl7nYzQHj0wzOdYqQ+9VqYX2aQcxFkEGbX9cYUkZfj3HgzT+lgx2h+dCqDXmderh0nziNvzyddFVCZ/dgRDXFwKo1fRwBvD22RTBg2lc7fSRn24aTkq06yMAaniN8m8zk7ghMLJyNwT4xamCE3Y+ioAuYME6lX5V7GDTv261AoX2Pms5geS0ErQ1A5YC22BEj8InLEzWVUmzyei0Y5Q+msMkg3rruiimAc7/ziZkGe9m4ROYWcpQMm5d0QvGQbMfqLzwG1gf0IpcPzG3AhLFZU7X9BXjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sVDnoYg58hpuziik8SFyLTq4p2L6XRifIVZNZHuYrtY=;
 b=CzofBbAxM6csC9mipbJY+VZyKp3bFQvO682Y9cucdmcxF5emiNOIsPCLnbZ1imAoSA1zF83RSdlxpwovZOPrq6zeGoHFJHlMK81WfKW2ZaR0/adha1UwqGX4f2e9wB0Iw0FH+K1qML6/pUi2AEHjnQGlbM6mZCLhU/ryzX+Ecz0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 CYYPR12MB8989.namprd12.prod.outlook.com (2603:10b6:930:c2::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8314.13; Thu, 2 Jan 2025 09:30:17 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%6]) with mapi id 15.20.8314.012; Thu, 2 Jan 2025
 09:30:17 +0000
Message-ID: <fe09ff1d-4a9b-4307-92c0-767cd3974152@amd.com>
Date: Thu, 2 Jan 2025 15:00:07 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 06/13] x86/sev: Prevent GUEST_TSC_FREQ MSR
 interception for Secure TSC enabled guests
To: Borislav Petkov <bp@alien8.de>
Cc: thomas.lendacky@amd.com, linux-kernel@vger.kernel.org, x86@kernel.org,
 kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com
References: <20241210121127.GBZ1gv74Q6IRtAS1pl@fat_crate.local>
 <b1d90372-ed95-41ce-976f-3f119735707c@amd.com>
 <20241210171858.GKZ1h4Apb2kWr6KAyL@fat_crate.local>
 <ff7226fa-683f-467b-b777-8a091a83231e@amd.com>
 <20241217105739.GBZ2FZI0V8pAIy-kZ8@fat_crate.local>
 <7a5de2be-4e79-409a-90f2-398815fc59c7@amd.com>
 <20241224115346.GAZ2qgyt3sQmPdbA4V@fat_crate.local>
 <a28dfd0a-c0ab-490f-bc1a-945182d07790@amd.com>
 <20250101161047.GBZ3VpB3SMr9C__thS@fat_crate.local>
 <9d4c903f-424b-41ce-91f7-a8c9bf74c07c@amd.com>
 <20250102090734.GBZ3ZXVqpo0OgEwbrQ@fat_crate.local>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20250102090734.GBZ3ZXVqpo0OgEwbrQ@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0096.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:9b::13) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|CYYPR12MB8989:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ea3683b-c4ed-4d9e-b89c-08dd2b101146
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZCt0L1ozRFkzejkxTWhNUE5mZDBBUXZvZm02MmVIc0I0bFdQWUpCaDhTTVZt?=
 =?utf-8?B?N0ZLWGgvNU1COEZFMDZLUjZHQmJNMWFhcHlmTjNYWGNYVjZ4OVpmTVZDVktO?=
 =?utf-8?B?bzhmVmFneDI3ZGZod1BGU2gyOVViUldKNnoySmYyTGhqK2F4M2xtVVhjaHp3?=
 =?utf-8?B?TzIzbUZzeWVuMzcxZ0hPRkRhVHhPTEhlYk9PTm1kejBSS1B6c1lvTy8rYzNr?=
 =?utf-8?B?WENsL1NZTGo0RFNRTUg5b05BcWlPOS9wYy9XeTNiaVlXeUpxZkVyU0tGWnYw?=
 =?utf-8?B?alU1V1Fhb2lZanVLMHNwU1lMYitzSitTY1RQYzJBK3JVWjFYWEgrQkNzbW4x?=
 =?utf-8?B?MVZhcWxYYnBmdVRNWDNuTzgvQ3NjeGJBUU9ya2NHUVVnRHZ3UVluZk54Qnk5?=
 =?utf-8?B?R2ZJTW9BMEhzODZVUDRJREtsdlZ4aDMwNENaWXNVbXNRcnNhZjZjbnNmYzgw?=
 =?utf-8?B?eVFDUEJLdkJWNll5SkxKSzQ1SEE0QXZnS2prRS93eFgvS1grYVNHTWcwb28y?=
 =?utf-8?B?WGtYdVdqZER2NURsNTRDTGx1OENYQmwvd214MDVYT09FRG9FWWhVMngwTEpv?=
 =?utf-8?B?QnJ3ZUV5cE43OHZWVmplNnJaaTFyNDhiSjVpUGRScVBYWVVJRUlmaG85ZUYr?=
 =?utf-8?B?M1o4SUh4UC9udlZkMnpSb1FWM2ZtaHRuZHdSTlJqZzNnbHBzaE9aQUJURVVE?=
 =?utf-8?B?azh2TGo2ckd2V3djamdWdExoQ0dqTjZFb09MOHNpc3o3ZXo0RDc4T2RzTUpq?=
 =?utf-8?B?Q0x6ZXVVVnFpdWwrNlM0a0lkaXhxTVlWVW95YXh4Y1RTUC9MZmZOaDFmTU5y?=
 =?utf-8?B?N2loYTFlT1lySW5zeFA1akRSQUhJN3dtdkdFdk1TMlNXWkpSMWRwcHBIRjJ0?=
 =?utf-8?B?VTJFZjFaWlVxdDdYVDkzMEpQNVVlNjNtWi9wSHU1czNZdlpDelFhU1pscWFK?=
 =?utf-8?B?THlEaXZKZXRvYURtZVFmaURtVFZtOFBpcFVBbkFVVW1tR2cwZGd3STlaMXJH?=
 =?utf-8?B?cXN2cndOdHpOUUVMRmJSZklPb28yYXQyWHlwOWY5OUpsSm5YTm1ZSzFpcndH?=
 =?utf-8?B?S1J0OW1QU0RRUU8rWFVGSE52VmovTzdPeWthZ3ovb05uVEpkdXhNdTkvUWZl?=
 =?utf-8?B?R1NPRERVUDI1SkJueGY4NW55R0J5M0lUZU4xcUdTV2dNY1crNWJZUlkyYjJ2?=
 =?utf-8?B?TThydGdncjBQaDViMUNTL0w5YWxJckUvN1FEWWxFRkVReDdnTkF1WlczVHRk?=
 =?utf-8?B?Mm4vVGgxK25zdHNnZmRUWmxCTkxiMFJXa3k3S0RLZ2JCQ2pTRjJzN0RHL0dJ?=
 =?utf-8?B?NTBndUU0cGthM0pUNE9DLzFsRkhYdnRudjNaS1FndkZrWEt3NldpMWdFVEtD?=
 =?utf-8?B?djJoQkZycFE2NWpUMnVISWdtbWdCS2hhRWtBVXpJbTY0NG1FazVpMWRTZ1JK?=
 =?utf-8?B?alNPSWtRMEFDM1VsUTlmNXBmRjQyTTViTTJJQ0ZLOTUraTVCVE1zYTljNGdx?=
 =?utf-8?B?UEVvc0pZYUZOQU14ZkFIQk9sTDVtNVR0TmV2Zzd6clF3bVJMZnk2cW5TclVx?=
 =?utf-8?B?MjlLMFltcGo0QXh5Q3M0MjZVQVhjT25iZTA4ZFJwa1N4b2xKWk1kOHBKNGNw?=
 =?utf-8?B?N1RKZ0FQUlZDQVhOTXhJTXNmb2hwVnhjY0VrUjFMY1oxSWdUV0RESFpLeDlC?=
 =?utf-8?B?ZTBrNVRMeHVaOVVZUDZvenozNEQyN0trM2dVdVg3a1BQUjV5eE54NFpGa3BV?=
 =?utf-8?B?VnBJWk9ZYmd6ME5PMVNLcitpL0dER3VVRWRxUWhMdDBSRmhaSGUzalZva1h3?=
 =?utf-8?B?S2piU3dRd1hUbnFDbmNqUi9ZNXpuRDEwNTAzcmsrelJVdmhCWE5RV2J3ZUZn?=
 =?utf-8?Q?jnWynyJ9LMz+I?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c0dSUGVYUG5BZUxwUTVXTkxXVU5Uc3p5UmdsL0REUVpwQWhiSFdqMG10MlhY?=
 =?utf-8?B?bnVVMklXaGJSdUJuczlYN1ovN3I4M2s4UmJrMnJtcEVIanFreUxERmdreHV2?=
 =?utf-8?B?S3gzNkQ4TDJyTytXUFFobVRxN0M5Zk9vS0pEem5JeUVkd3NEV2RCMEZVUG9X?=
 =?utf-8?B?L0R0K3VrUG1idkZYTEJHUkErQzdUY2hOb3lsYlJZV3BpWEd2TXRWdEdPUGpC?=
 =?utf-8?B?YlBUMmZRUGJob0FjRTRGY1ZjOGVWMjFPalJGL053UU1BZS8xVVlmeUdLZnNS?=
 =?utf-8?B?RG8vVFA4UlpsRUpKaUV6Q1ordjk4eE9hKzBLWnBZV3EzUm80ekZudkZ0NFo2?=
 =?utf-8?B?WDBXQXJ2aTZXSW9mV3NjTDZxM21HbkFpN0QwVlNQanBpNzJidHdOcjJZR2gz?=
 =?utf-8?B?d1htNDZFWG1zRlo0R0RHb1NWRzlVRTY0QjhGRXVGbnRoL2VSK3krRUlNZGp1?=
 =?utf-8?B?MFMrc3RhNDcxb2RXQ2RUYWdIT3p5L0pHb1J4RnpWWXdweW5hblpNNjA0M1Ri?=
 =?utf-8?B?bTh6ZXRHcXhzSHN6bWw1czdkS2VoZnVpbVlyYnRtQWE3L0QvaDNWeUsxRkhQ?=
 =?utf-8?B?YmRCZUxraFU4MTVnK3VtSVFFcEI3bUY4Q2c4WWFRZEZEb2RmUy9wdTB5UVc4?=
 =?utf-8?B?SnRvQk1hMGw0b25vRDlHQy95L3dBam5YMGZHTzlJL0pmcGhHT2gxTkdPSlJu?=
 =?utf-8?B?REtHSXNNQTFCeGZZendYUk9DaE5MUFZ3czc5RGFPTnlhdVNDanp4bU9JdUxH?=
 =?utf-8?B?YlNObkNqeXRrTU5tek0wbEtzYTR2cWlVQXhTSjZTY0pyM2ZtRWQ5bDdrKytM?=
 =?utf-8?B?aGgrRnMzQ0JJY29CZjRoM2lMbnAyajR5UlY5WStRYTNzbjladlRlZDN6WTlu?=
 =?utf-8?B?ZWxCa3lEWEd4ZjlReTVERHlVVmFnbXZjeER4TnlENWNONE8xQnpSWklpeGRr?=
 =?utf-8?B?MWZuajNFSWVXWGRjd20ybzliRUp2MnY1VC9TUkVRNzRnZEJNUFNOMVFMcFU4?=
 =?utf-8?B?NDFubFlwYlhzTlQ0ekpuNmN2MDZLQUl4OUovNDZTai9pR21pWmtFQ29ab3Jh?=
 =?utf-8?B?ZEVRMnpOcWJ1UkFHV3JVWDNMRVhuWG1JZGpjeFNIaUhUeitHQU13d0lwdUli?=
 =?utf-8?B?Z296SmZsWFRYVUxuOVZTWTc2V1UzMmdLRU5ob1loZlh1ZURabS9IZDRJRU5k?=
 =?utf-8?B?YTBWWklYWGprQUpEUkRYOXlyaEhiclhoUHlCd1BJSVhqbTU5Y2g4VWZFblVE?=
 =?utf-8?B?RUxXSEdUVEhHbGdYbGZZZEp1Y3NZUHplZWVBKzI1MnlBVHZNSnNDOVNYVTNG?=
 =?utf-8?B?ZlphSU1aTENZcSszUjJLZTFjcXZvRmNVeFpTbWNvTGZsYU5UR3h6SlJXMmhI?=
 =?utf-8?B?dGlFQVhaTldxNkx1QjZvcnpjeTBqMzZJaHdPMmoyMGVycWlOUTJPNG1qdmRI?=
 =?utf-8?B?ZUhZdTB6V0dGRmduM0tseTNENGVzSU51NEprZTkzcEtkc2JEN0tkcHFIaElR?=
 =?utf-8?B?NWtYNVQ5L29PaVB5aVdTMldNa2NwcHZiOHZoRGhiODRuVEE1bkdsYXlHU0lF?=
 =?utf-8?B?bEFQaDZwblA3SUNtbzQ5SEVVWEdrL01kQVIwL2xrQkl0dG1oUkM2TDhFUDY3?=
 =?utf-8?B?K2QxTHFmTHJ2bStIZFZYSkREL0xkRWxzazZjV29MWHg2dWlQcFhONElNVVB6?=
 =?utf-8?B?R1hrckRzMHpLNU9ocnI3eVJWblBQQjQvdFdsZXpXSXVsWGQ1UDZkdjd4WUJ1?=
 =?utf-8?B?blpLZUhyc1ErQW9idlMrcWk3MUl1d0IzRkRkOEdZR21ialZCWVo5VitlSzhV?=
 =?utf-8?B?L2FiejNKTzFpOFRaQmdLU3QyWmFiVlRDTE5SamhkVjZlZkRlenA4c0JFS0hX?=
 =?utf-8?B?bFNkRDhRaGdldUZoWE1kU0tMSnBERHRjQjg5blRHcVpSMk1qMlVsbzFkOGFs?=
 =?utf-8?B?cjhKR2JFNklWNjQrWENKV2VrTjd1eE9rQTdhdEg2WHIvR3VyTWVpdWNKQUpI?=
 =?utf-8?B?UW5MQ0FoZmh4NHdqaTRuaCtmakx2VlBnUndpbitBR1k3eE10Mm5QVXVnZ3NY?=
 =?utf-8?B?S2dBV2FiTlRveG9MT1lmU0RJVUR4NmV3czFaQ0IrUWl1NjRvL0NsTU1ObnJP?=
 =?utf-8?Q?TAYUqgdTpk84YIPbYyzdwyWFc?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ea3683b-c4ed-4d9e-b89c-08dd2b101146
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2025 09:30:16.9253
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qSCU2wPpNo6Pe9kdIKvZ+wp42bvhIuzthoRL+OUpDKENxY482o21Johj/0Zu4RVdxqZH9p91WUalhKcIKi+VxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8989



On 1/2/2025 2:37 PM, Borislav Petkov wrote:
> On Thu, Jan 02, 2025 at 10:33:26AM +0530, Nikunj A. Dadhania wrote:

> As in: I will handle the TSC MSRs for STSC guests and the other flow for
> non-STSC guests should remain. For now.
> 
> And make that goddamn explicit.
> 
> One possible way to do that is this:

I agree, if renaming helps to make it explicit, this is perfect. Thanks.

> 
> diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
> index 6235286a0eda..61100532c259 100644
> --- a/arch/x86/coco/sev/core.c
> +++ b/arch/x86/coco/sev/core.c
> @@ -1439,7 +1439,7 @@ static enum es_result __vc_handle_msr_caa(struct pt_regs *regs, bool write)
>   * Reads:  Reads of MSR_IA32_TSC should return the current TSC
>   *         value, use the value returned by RDTSC.
>   */
> -static enum es_result __vc_handle_msr_tsc(struct pt_regs *regs, bool write)
> +static enum es_result __vc_handle_secure_tsc_msrs(struct pt_regs *regs, bool write)
>  {
>  	u64 tsc;
>  
> @@ -1477,7 +1477,9 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
>  	case MSR_IA32_TSC:
>  	case MSR_AMD64_GUEST_TSC_FREQ:
>  		if (sev_status & MSR_AMD64_SNP_SECURE_TSC)
> -			return __vc_handle_msr_tsc(regs, write);
> +			return __vc_handle_secure_tsc_msrs(regs, write);
> +		else
> +			break;
>  	default:
>  		break;
>  	}
> ---

Regards,
Nikunj

