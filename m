Return-Path: <kvm+bounces-35126-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 296C7A09E38
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 23:42:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 49768188A721
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 22:42:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CD34215F40;
	Fri, 10 Jan 2025 22:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="DjNFB2Li"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2070.outbound.protection.outlook.com [40.107.244.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC2D2144CF;
	Fri, 10 Jan 2025 22:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736548916; cv=fail; b=VFQkk+nteTtIDz4ETDWr5gEBCa0YoHL/VZFEID46eZ2nS4aFc8efMmAIMA2HSAEN7Arp3cnwoD78w+xxx8F/sdBdVdOX/FNisUnscXILn2ykiCRK1D1x13ORT1b0e2Vo8MEnA37o145a74N6Vq8zgq17L0f1Gei6fNeJM2MTjso=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736548916; c=relaxed/simple;
	bh=go3NET/+oo0fzOex02O9hBYz0T0XTcHvYYUzqN4yW+c=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LtsD9zyrSE9b+RahjrVbu5fvdlEphmL6TUy0kcYKHz9vahZHkhsEamE8gtHZauJa6cpSK3w7pwqNO3QYEHj3tTo5olUI7CPXLquSyYjPq8bEOxO4KgjmPKD4hqrfo2chVs2nmOnGie3X8z25sJQSmf8JMeAFxEKDt2XreA7gIgg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=DjNFB2Li; arc=fail smtp.client-ip=40.107.244.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZXZrOB/sCrg9zB/mkdRbBN1Q3uunavALWxw/J5PA1mcVFW3351hTHAy3C82RPtGR/T+rqYdqkWv9a+jw//mQiVcexIFb9eCqz/p8Xea9/6D4stlWZzVGymntyq2hpsj+/QY0ZVXfMBoQs27fEBGSANw5GERkRqBd2ngORYxaxhcjdADckaliTX+lEYa6/mrwuMhvs+WTUWTUQa33/SjLxibTts43vLZgR+kVMqrRbf9mG2NizzBdRZeLWALPztTEtSGcWdH36+n6oKo+udrxxa7TtZcp4Pr04QIaQ7SREciWIfLi+k0f7pUE2CM97+DtsKC9MIkG8AvH/OUQmQOKUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2fKqHDFulIHL89+IxNZ20ddvhRDnsks3kKn193uzMpc=;
 b=R3teysqD/Y5Zqnwjqiam8IFAgkpjLxJNpUJhtVLCoqS7e41rfuhTcB6ElZMFaAak2mjd6KjgVUsjmxPc4Zhnxm53oAwXBpDPdXDrypuI3topphTDKzOGW8oDfPzG3Ci5UMmtFuj1tVD2/LwFkYSxIMf8cn9gq9AgPe+YflDobkG+4BTM48cxUClCxb1WNS1HdHTQwOAJ1+eFiPyX4QrcpgFEfXb0B5TWeXv7N/ondulJSUNiGhpLFbye0WCXDVAq25j89xfmsVip1mimQkHKYBAZ/p6BCV4sq6nNYVhqobarI0a4BWoGXKHH8jg8aserFoQ+6Kc/KVkEtNCL8Xd1Cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2fKqHDFulIHL89+IxNZ20ddvhRDnsks3kKn193uzMpc=;
 b=DjNFB2Lia6iTCCtospChqcQ3WPKdRfbVQsiGeMKWstemdHL2kikx5qjmqD5sZFfT6gVLaoP0EWtHVZDbLCxTOZUW/pnY4Dr9dYefyhfP+qFQVg6VnvYdHdoD6ez9pxno4z/Q92Dfn2ynqWXobgrYfQK0jG+stgzQTqSx4P9oEio=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by PH8PR12MB6820.namprd12.prod.outlook.com (2603:10b6:510:1cb::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.10; Fri, 10 Jan
 2025 22:41:50 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef%3]) with mapi id 15.20.8335.011; Fri, 10 Jan 2025
 22:41:49 +0000
Message-ID: <d6d08c6b-9602-4f3d-92c2-8db6d50a1b92@amd.com>
Date: Fri, 10 Jan 2025 16:41:45 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/7] KVM: SVM: Add support to initialize SEV/SNP
 functionality in KVM
From: "Kalra, Ashish" <ashish.kalra@amd.com>
To: Tom Lendacky <thomas.lendacky@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 john.allen@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net
Cc: michael.roth@amd.com, dionnaglaze@google.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-coco@lists.linux.dev
References: <cover.1735931639.git.ashish.kalra@amd.com>
 <14f97f58d6150c6784909261db7f9a05d8d32566.1735931639.git.ashish.kalra@amd.com>
 <6241f868-98ee-592b-9475-7e6cec09d977@amd.com>
 <8ae7718c-2321-4f3a-b5b7-7fb029d150cf@amd.com>
 <8adf7f48-dab0-cbed-d920-e3b74d8411cf@amd.com>
 <ee9d2956-fa55-4c83-b17d-055df7e1150c@amd.com>
Content-Language: en-US
In-Reply-To: <ee9d2956-fa55-4c83-b17d-055df7e1150c@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0019.namprd13.prod.outlook.com
 (2603:10b6:806:21::24) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|PH8PR12MB6820:EE_
X-MS-Office365-Filtering-Correlation-Id: 40bdb66d-613c-449c-6ff4-08dd31c7f89b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?V0pKc1VuOWcwSW5wMzIvQnZqMkNYbWZIUmdsbmp0YmJjVEVTcnVSRVh4aTkr?=
 =?utf-8?B?alBBUmFXc2V0MXpCanJVQjdleHovL0d6VTJLMVdnYjNjNjZxOW9tVEswSTd2?=
 =?utf-8?B?KzliaTkxTmIzQVcvdWEya2FxK21NZHpKb2NiQ2RDN0xPZzdJODVuQStyeE9M?=
 =?utf-8?B?L21zT0NVYzAxNGxTVWY5UkIxVHJzZjBLTDU4ZWMyUW1CZkduWHU3Ty9JQmQr?=
 =?utf-8?B?MW84TldRS0x4ekRZVXRUZmc2ZXpoRldqaGNyRHdhZEdJSytFMTVVMnBtMVlt?=
 =?utf-8?B?cjBaeWJlMkw0V3ArQVlTbW1OQXV6Nm9pVXFHVWJhZTdlSXFmZ09MWE1yV1BG?=
 =?utf-8?B?SnFvS0RFTjh6YkVoRU5oMnV3RjR3ZW9VNWQ0SFlWTGhYY1ZmdTgvYUxYMi9S?=
 =?utf-8?B?YVhDWXIrSmI2UUYyQzFOblZqbFpWejBObGgxOG0xNTJnbmdzelRKOEo2Q0JI?=
 =?utf-8?B?eE9zUVptSVEwNWJmQUlETVFta051WkR2T2laV1lBai9UZWkxWHFpNEFsMGwz?=
 =?utf-8?B?anVXYk11dGluSDBoWDJJMWxpcW8yZ0NrRXFqWmhIK0lkVXBCWXROaGZGM3JC?=
 =?utf-8?B?dTJ3U0Q4YXBVVVNoU0xnK084bmZKU1BscEx1aCtieXZIdm1YeEwxMktwcHBs?=
 =?utf-8?B?UDYxV3lvc2JFZitBdll2WkxxUE9YWmh4Q2crV1phVmNvWTZ4cGQ2bjJ0Umxo?=
 =?utf-8?B?NnUrMTdrV3lJaUhkWmNtVDVLTTh5YTRHOERralQ2dy95M1lCV1QyR1AwMnNv?=
 =?utf-8?B?bElKUWpPa3hEdU5DWlp3RUNSSTR2Sm1vOTYxVk9qS3QwV3FEcUtCWGh4ZVIw?=
 =?utf-8?B?TU5OTVhYYTdFMDNoSzdjeEdBNS9xMU41bkVPTXFsUEtVUm9HMlZzZDIwL1ho?=
 =?utf-8?B?S2FuT3F4WlF1dWJqZE9iWkJxS2JGc20wSUJMcU8relJJaFBabjV0SkQ0OHl0?=
 =?utf-8?B?LzVSNTZsTVJEWFNVUjV0b1k4ZGQxMGQxREFDR0ZDU01CbW80QXZ6UWluZFd0?=
 =?utf-8?B?VUE5ckJlSnI5K3RONnpvZGQ4Q04zRWJ5L0RJa2dPU0s5VVpjeEpOL0VRZys1?=
 =?utf-8?B?ekNpTnhzaVNPaUsyMzVhVnJhd0xuZDNZU1RXYmlUdGh1TkxXbGVPVllhTWMr?=
 =?utf-8?B?ZmlGTG5Yanl4RUNOcUszVExYQmNrWHA5MVY1TlBydENvNUo5eTIvYnkyY2hT?=
 =?utf-8?B?UzFJQmJ0aURuK0l0MTlESWtlK2RKNnlMTVRLTVNpdVM5aXExM2M4b1hlTmpW?=
 =?utf-8?B?R2hlQ09ld0hyandkaEp2MHdRamZyQ2plY2xsY2NjNjJoenZDNHhHVEpIclU3?=
 =?utf-8?B?eDk0ODgrUmdXTGQzeVhrYStoSjE4MHJOVWxxbW44NGFUaWZaZUN2Zzdlejcy?=
 =?utf-8?B?MFhVTXE2bS80RTE4R3h3eVhlYnIrNXhYMU92ZWRVSkJFVzcxbWJHWmQ3dEpv?=
 =?utf-8?B?YTFFWEdkUWN5NzNKWFR5NGdabjdYRG1DS2l3ek1TTkFxS1piZTRaWFJHYUVr?=
 =?utf-8?B?ZGxKSHNKclBzODB6dHZ1YnVUbTJwQmY4c09zUGFqcTFzcUp1cEJxQ0hUdFRX?=
 =?utf-8?B?UlgrWThhQzhpVEVkL3hjYjY3T1k3NU5WYUR6YVFsR0ppQW9JQXovVWdadGov?=
 =?utf-8?B?MjZzMWc5azhEYnZrTzVuL0JWZmYyRmV1UDQxYVc4ajUvd2I1ajY2MHE2bGhY?=
 =?utf-8?B?UWtOU29ES1JOd2ZwbC80dTliVWg3eU5zTE1uRVBsUTdJd0RaVmtOVWt6S2Rn?=
 =?utf-8?B?aUtjRHh5Yk0vVFVCVXNyaG9NWVJJSUdNRlRTMC9kTExFQzJpR3NWRXZRSzFv?=
 =?utf-8?B?dHc0WCtYVTNzaE1tU2tUc1hGVFUrcHMwZUxXMjBrSUl6Q3pOd1FIY3pIeGFX?=
 =?utf-8?B?VjdCdm9SV0JoNWVXSjlwSXFVUXhlZGo4dzFnSERHUjlaOFg1b1pDZDJQZm5X?=
 =?utf-8?Q?TMw/f8Un4C8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aDRmM0QvYy8vN28zQkxzWUFHZXhjSTFVVWs0cUNqcWxBTlBUQWxRY2d0YWNQ?=
 =?utf-8?B?eHR0Nzg2RWdSdHRQWHBOQUtoRjR3Y0MyMXF6NnQ2cEFqL3NzTHRGbjd1NnFX?=
 =?utf-8?B?dU8rSjlBcVdCa0hNZ01sbzJnRzM0OHBJTFluemdsZlA4UkMwOU94eTdwb2JC?=
 =?utf-8?B?M1h0dG9wU045L0cySkU5NW1rRXJhY0ZiUFRyOEp4NnM1eGxNNFRhMlU5SW9U?=
 =?utf-8?B?Y3kyNnhmM1FlRGtKZm9YQy8zVVNad1hXZTNBUDN3b0tZM05sclc4bjRaTm4v?=
 =?utf-8?B?RWFIZFBQa0x6aVVsazhnbWFaWncxajFxcy9sUDR6VkNaKytERUl1ZTdGSzhU?=
 =?utf-8?B?bW5pVzJLZ3I2RzEvV0wxTXZIUkkrTGZjczhOZVhjNnhtZkhJNy9wbytRckJs?=
 =?utf-8?B?UUgvMzdRT3ZRNDFGd1FoWnlLWGxMMHRPMHdPa01TY291b2RWS2gwd3NKVnhX?=
 =?utf-8?B?ajZtOUMvZ05qUFl4eDI2eHlUeE5IN2d3YXo1eXNCRFBFeWE0NGNTMzhJd29l?=
 =?utf-8?B?ZEd3dHdPSEpNQXQwUTRjU09NdWpaZXZIS2tMMHFZN2ZyR09SUXZRY0U0Ykhp?=
 =?utf-8?B?SEZ3dHNxQytuemphL3VnYXA2WmFVWE1xODNqQnNnQkw1OVNNeGVUUUQrOVpW?=
 =?utf-8?B?WFZYUkZQem1ibUYzUTArZkQ1ZGZwRlFYS2dvbERvRzdLREtnTk1sTDIyUzhW?=
 =?utf-8?B?ODYvbm95S1J4OW9Jdk40VW82cUhGYVBZZ3hndFZuVW5uVG5Ba0dSWUhrcWxk?=
 =?utf-8?B?Q2Uzd1EyaG92VmUyL3hJSVRLZ2FIVTVhM2ZOVWhFSituWjBoV1V2RnJXd2hF?=
 =?utf-8?B?ZEdkbVBJbEpIaDJBWXQvYld3VENsOEEyZDFPdjZsT05jb09MOHdoK1NXeXZ5?=
 =?utf-8?B?T1ozWkNXSlAwWW1YcWtyVnd6MEZzeFhWS0tCR1REcExmWlJRbnFVa0crZTFH?=
 =?utf-8?B?WkxvNHMxUE9YeUlNRGpTcmx2NndlWW1FZjNOTnZCaThwOVlPdC9MaEhzcGpx?=
 =?utf-8?B?VDJBRW9rMm1XZXU0cDRNNWRHclNKSTl1Um51aExQWDZEZExOUmZrTVU0Snkv?=
 =?utf-8?B?UEdwcVlWL0xhUUo5Wmw2ZFRhV2N6c3ZIbnNiVldOR3pJN3Q2elFlRFl5bkV3?=
 =?utf-8?B?T1VkUk5SeHpIRitjMFFSdjIyazNRc05wQzNmODhIN1BXbnpNU2trUWlrRWZ2?=
 =?utf-8?B?ME9wSzFJN3dtV3hzaG44clc1MGcxangwSHNZZ0tXdWxVb1B6OVlCZFhlMCsr?=
 =?utf-8?B?S2ZtMFIwMExtbjg4cHJidHJuSTI3WUJZQVNiVHVKNzUxeG5mbHJFamFBSzdS?=
 =?utf-8?B?cmRhb21qK2dJUkZDTjA2SW4vbFl3OU04eGR3RmhzN1hPWUVHYkNCQUxWYStG?=
 =?utf-8?B?WHNuQzZBcTVKdm9vOTFMcXliSW9hVWl4NFRsVGx1N0VNWWxHOGJIUWxKczIw?=
 =?utf-8?B?T0szSXhOUHM2VE0vcldSOWN1bjh4YkM1NG9hRzM0SnRpTWlDekdNYzFzQWQ3?=
 =?utf-8?B?alM2TVAzVjN0dHZpdUc0RjhTSzRwK1BpYklWcW9mQVc1RHF3TXhobDdiSVEz?=
 =?utf-8?B?dCtyZWppek5OQzBzaElWNHc1ZUhFUUxJK1R0dnNnbUFLMStnQkc4V3o5WTB1?=
 =?utf-8?B?MW9xUmU1dzB0OU5CQ04ybU5OQkhaN1hTd0NCTUpaT0pMWGNhcThSV281V2Ni?=
 =?utf-8?B?SWY4N2FyNzlZZllwZHdUbXA4cWRnQno0Sm1LQWtVOTR4ODVnWGpQMzF5aHc2?=
 =?utf-8?B?ZlZZdlRsN3ZHRUZFTm1EZ2VkSzA4M3JzV3hLeGdOTjNEU3M1ZnY0Q0R2M0sw?=
 =?utf-8?B?VUwwTW1EMGZUUlIrd09yZWNEdU9ydFk0WmJJamZTTk1sbCtaZCtURDdrdCtO?=
 =?utf-8?B?ZmxBL1FzVll3SndJMSt5b3hQcjBhSnc1di9sbFpKTHN1TXRsdWNMeDJyOXVV?=
 =?utf-8?B?eXRUU05VSjFjYWt1d2M4T0plcFNWVnlxTTdYTnVTQktVUjViZ0RaM2FvSlA3?=
 =?utf-8?B?VE5Ca3c5RGR3eGNFQk5aRXdzamxoSzJkcGhFbEZQcCtlaHBtSURTTzRteHB6?=
 =?utf-8?B?Tks4aHFMWEtralhBQlF5R05KazBHT2hlZWRjZ0FIMWttZUxrUlJKWVpWdHRN?=
 =?utf-8?Q?jekP4ItuAWsZWRAEQiVXmAb3t?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40bdb66d-613c-449c-6ff4-08dd31c7f89b
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2025 22:41:49.7409
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2ulDcXwETIzb7n93IE6ZTvMviBtH6NINgfcvq9u6La4rjF0k9R278VlitH0pscmTiA1sgGtQ6yIEww3ZUsXukA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6820

Hello All,

On 1/8/2025 6:27 PM, Kalra, Ashish wrote:
> 
> 
> On 1/8/2025 11:22 AM, Tom Lendacky wrote:
>> On 1/7/25 12:34, Kalra, Ashish wrote:
>>> On 1/7/2025 10:42 AM, Tom Lendacky wrote:
>>>> On 1/3/25 14:01, Ashish Kalra wrote:
>>>>> From: Ashish Kalra <ashish.kalra@amd.com>
>>>>>
>>>>> Remove platform initialization of SEV/SNP from PSP driver probe time and
>>>>
>>>> Actually, you're not removing it, yet...
>>>>
>>>>> move it to KVM module load time so that KVM can do SEV/SNP platform
>>>>> initialization explicitly if it actually wants to use SEV/SNP
>>>>> functionality.
>>>>>
>>>>> With this patch, KVM will explicitly call into the PSP driver at load time
>>>>> to initialize SEV/SNP by default but this behavior can be altered with KVM
>>>>> module parameters to not do SEV/SNP platform initialization at module load
>>>>> time if required. Additionally SEV/SNP platform shutdown is invoked during
>>>>> KVM module unload time.
>>>>>
>>>>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>>>>> ---
>>>>>  arch/x86/kvm/svm/sev.c | 15 ++++++++++++++-
>>>>>  1 file changed, 14 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>>>>> index 943bd074a5d3..0dc8294582c6 100644
>>>>> --- a/arch/x86/kvm/svm/sev.c
>>>>> +++ b/arch/x86/kvm/svm/sev.c
>>>>> @@ -444,7 +444,6 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
>>>>>  	if (ret)
>>>>>  		goto e_no_asid;
>>>>>  
>>>>> -	init_args.probe = false;
>>>>>  	ret = sev_platform_init(&init_args);
>>>>>  	if (ret)
>>>>>  		goto e_free;
>>>>> @@ -2953,6 +2952,7 @@ void __init sev_set_cpu_caps(void)
>>>>>  void __init sev_hardware_setup(void)
>>>>>  {
>>>>>  	unsigned int eax, ebx, ecx, edx, sev_asid_count, sev_es_asid_count;
>>>>> +	struct sev_platform_init_args init_args = {0};
>>>>
>>>> Will this cause issues if KVM is built-in and INIT_EX is being used
>>>> (init_ex_path ccp parameter)? The probe parameter is used for
>>>> initialization done before the filesystem is available.
>>>>
>>>
>>> Yes, this will cause issues if KVM is builtin and INIT_EX is being used,
>>> but my question is how will INIT_EX be used when we move SEV INIT
>>> to KVM ?
>>>
>>> If we continue to use the probe field here and also continue to support
>>> psp_init_on_probe module parameter for CCP, how will SEV INIT_EX be
>>> invoked ? 
>>>
>>> How is SEV INIT_EX invoked in PSP driver currently if psp_init_on_probe
>>> parameter is set to false ?
>>>
>>> The KVM path to invoke sev_platform_init() when a SEV VM is being launched 
>>> cannot be used because QEMU checks for SEV to be initialized before
>>> invoking this code path to launch the guest.
>>
>> Qemu only requires that for an SEV-ES guest. I was able to use the
>> init_ex_path=/root/... and psp_init_on_probe=0 to successfully delay SEV
>> INIT_EX and launch an SEV guest.
>>
> 
> Thanks Tom, i will make sure that we continue to support both the probe
> field and psp_init_on_probe module parameter for CCP modules as part of v4.
> 
>>>

It looks like i have hit a serious blocker issue with this approach of moving
SEV/SNP initialization to KVM module load time. 

While testing with kvm_amd and PSP driver built-in, it looks like kvm_amd
driver is being loaded/initialized before PSP driver is loaded, and that
causes sev_platform_init() call from sev_hardware_setup(kvm_amd) to fail:

[   10.717898] kvm_amd: TSC scaling supported
[   10.722470] kvm_amd: Nested Virtualization enabled
[   10.727816] kvm_amd: Nested Paging enabled
[   10.732388] kvm_amd: LBR virtualization supported
[   10.737639] kvm_amd: SEV enabled (ASIDs 100 - 509)
[   10.742985] kvm_amd: SEV-ES enabled (ASIDs 1 - 99)
[   10.748333] kvm_amd: SEV-SNP enabled (ASIDs 1 - 99)
[   10.753768] PSP driver not init                        <<<---- sev_platform_init() returns failure as PSP driver is still not initialized
[   10.757563] kvm_amd: Virtual VMLOAD VMSAVE supported
[   10.763124] kvm_amd: Virtual GIF supported
...
...
[   12.514857] ccp 0000:23:00.1: enabling device (0000 -> 0002)
[   12.521691] ccp 0000:23:00.1: no command queues available
[   12.527991] ccp 0000:23:00.1: sev enabled
[   12.532592] ccp 0000:23:00.1: psp enabled
[   12.537382] ccp 0000:a2:00.1: enabling device (0000 -> 0002)
[   12.544389] ccp 0000:a2:00.1: no command queues available
[   12.550627] ccp 0000:a2:00.1: psp enabled

depmod -> modules.builtin show kernel/arch/x86/kvm/kvm_amd.ko higher on the list and before kernel/drivers/crypto/ccp/ccp.ko

modules.builtin: 
kernel/arch/x86/kvm/kvm.ko
kernel/arch/x86/kvm/kvm-amd.ko
...
...
kernel/drivers/crypto/ccp/ccp.ko

I believe that the modules which are compiled first get called first and it looks like that the only way to change the order for
builtin modules is by changing which makefiles get compiled first ?

Is there a way to change the load order of built-in modules and/or change dependency of built-in modules ?

As of now, this looks like to be a blocker for moving SEV/SNP init to KVM module load time as this approach will not
work if kvm_amd is built-in. 

Thanks,
Ashish

>>>>
>>>>>  	bool sev_snp_supported = false;
>>>>>  	bool sev_es_supported = false;
>>>>>  	bool sev_supported = false;
>>>>> @@ -3069,6 +3069,16 @@ void __init sev_hardware_setup(void)
>>>>>  	sev_supported_vmsa_features = 0;
>>>>>  	if (sev_es_debug_swap_enabled)
>>>>>  		sev_supported_vmsa_features |= SVM_SEV_FEAT_DEBUG_SWAP;
>>>>> +
>>>>> +	if (!sev_enabled)
>>>>> +		return;
>>>>> +
>>>>> +	/*
>>>>> +	 * NOTE: Always do SNP INIT regardless of sev_snp_supported
>>>>> +	 * as SNP INIT has to be done to launch legacy SEV/SEV-ES
>>>>> +	 * VMs in case SNP is enabled system-wide.
>>>>> +	 */
>>>>> +	sev_platform_init(&init_args);
>>>>>  }
>>>>>  
>>>>>  void sev_hardware_unsetup(void)
>>>>> @@ -3084,6 +3094,9 @@ void sev_hardware_unsetup(void)
>>>>>  
>>>>>  	misc_cg_set_capacity(MISC_CG_RES_SEV, 0);
>>>>>  	misc_cg_set_capacity(MISC_CG_RES_SEV_ES, 0);
>>>>> +
>>>>> +	/* Do SEV and SNP Shutdown */
>>>>> +	sev_platform_shutdown();
>>>>>  }
>>>>>  
>>>>>  int sev_cpu_init(struct svm_cpu_data *sd)
>>>
> 


