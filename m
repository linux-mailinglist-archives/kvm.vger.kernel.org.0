Return-Path: <kvm+bounces-42571-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F886A7A216
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 13:43:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 30CBF3B3342
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 11:43:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BFA624C086;
	Thu,  3 Apr 2025 11:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="K4b1rFVK"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2044.outbound.protection.outlook.com [40.107.237.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764F53FBA7;
	Thu,  3 Apr 2025 11:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743680595; cv=fail; b=G8ab/n4mUlq/i1frElniWKLmE6pikbzMJQwG18XUllZZvqA16f9s88wOWcRo/EI8omJHyPfQG44jR+usl7xhqMvcupuz24zxGxhvLrWBJ2Mf0stZK+TWV3rGx26ysMq0OG1d1mzWSR0a4up5OekkZged1PrISa4/P65zQo98fFU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743680595; c=relaxed/simple;
	bh=3zJ2Gd01aq6qGQWobWdC0xpYkanLSbW7bI+R4CbJtDU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=P8zKbCycm3YNA4RXVZUUANn1SwbVPyZcmrSz/w0K0PYNS9sT50HhNAD2GE38Mn/7SDHaGbSZHZrMgljdGz8v3CPSIZzZN9gt2utzM1EqF+P0WOQoRuhky34qZN/RlHTBOvOmB0AgR441hb9yKLxN1i3X0BVqEVyDhiyMr/oBfqQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=K4b1rFVK; arc=fail smtp.client-ip=40.107.237.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RiQC1lWVygYoRj3BalXGJpQu4moYoKHTfLjhQ1PekTJ7k5kum0FKP6jJNb/nIBKaYxc7bd2QzkYN5dgQysrmupad+LLe9MlvAyMtocejjl6Wuf6IbLLclsJT7ywBTRJJHYBtSaf7dSALl9G9YNATb7+uVEKcULZEbi3DF5GOUC6ZCUsV/iG+A1Kq05x90TJNRzmqp1WcmKHhzde/UdK0/bz9BL87IcsHJXukyJG/zJTlYBWeW1mCkES/vqcu27X+6RyaVibUCfwHAU/eTc5lzOdAbY2fIm8mQKV9Djtzq40+kuSlPYp/7pBG6oq8p8svqJZq1JWSKCZeIqSjGchWgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gNdZgQ0QeYJWOGxrIex6b8gyaZNCGeOjjAxI8on3GJ8=;
 b=VTCCJYvP2dW5FnbiW4/RccVILyXwflOGd/pmia2+peP8LDHvh6FQD0XdGqVAtFouRbdMj/+x/1hhtSA25W45mxaqkdqtkc+nbtSnni40rShIm2qMzK677Whxcms050zlmGksGAanJJkrudDUZ9pNY5H/3FwzC9mmzZZnR7J6NaasMVR8trzvWypNFO39upz10umgtQvminvWOz3BXQj4GK8bG05AbU5lh2GjLhxAmMMNf35mpKzpt18OrEgfMGhYI+O0MJ7ikY7r8RHj8cyj6unmEPM7gozLGdnNNcuUWAIXkjpJ2lZe7kcUJdy0wR2Qqta5LZ9P+N/zU58hPtFmXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gNdZgQ0QeYJWOGxrIex6b8gyaZNCGeOjjAxI8on3GJ8=;
 b=K4b1rFVKzggXsSOn9eKYalpwpAunb9nRoQ5oZODmBkpbp798Dtb/37yaXkQ09367Y4igpfS/ZHYf3F68PFo8PiXmVh571yRp2WvI9tsKaS+g0YYQ2QJ2MoebnJ0tklM+mL2ppQSEAwn7oTsnfN9/qTNsemIz7k6wPDGsuGkXiNQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 CH3PR12MB8257.namprd12.prod.outlook.com (2603:10b6:610:121::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.50; Thu, 3 Apr
 2025 11:43:10 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%4]) with mapi id 15.20.8534.043; Thu, 3 Apr 2025
 11:43:10 +0000
Message-ID: <c1e5b02b-f5b8-45f8-811a-ce1e05d166c9@amd.com>
Date: Thu, 3 Apr 2025 17:12:58 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/17] x86/apic: Add new driver for Secure AVIC
To: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Cc: bp@alien8.de, mingo@redhat.com, dave.hansen@linux.intel.com,
 Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com,
 x86@kernel.org, hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org, kirill.shutemov@linux.intel.com,
 huibo.wang@amd.com, naveen.rao@amd.com, francescolavra.fl@gmail.com
References: <20250401113616.204203-1-Neeraj.Upadhyay@amd.com>
 <20250401113616.204203-2-Neeraj.Upadhyay@amd.com> <874iz5wk9v.ffs@tglx>
Content-Language: en-US
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <874iz5wk9v.ffs@tglx>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0019.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::15) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|CH3PR12MB8257:EE_
X-MS-Office365-Filtering-Correlation-Id: 4433e3d6-8312-493c-d62f-08dd72a4b58f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bk8xV1lNREp0VVBaWGxwVCtObDhWTVhjLzVVZFJCWXd0Q1VTN2ZrYUJrSGcz?=
 =?utf-8?B?UVFVaDAwN0lxRzZHa3ZQd3BJelg5ekR6bVo3aVp1Qm5NbXU4Ullvbzh0L0NC?=
 =?utf-8?B?UEk2bVd2QU41c0JuanI1VFpzV3NtVm8zRGVIcTh0eVl0T1N2dlM2VXkyNmdj?=
 =?utf-8?B?ajhWcmMza2pxWnZ2dG1nTTVHSmwvQTRjMWgvZUFSL0xuMUhIZkY4cmFCNlZY?=
 =?utf-8?B?QUhKMlZEa1o5WjhkL1F0ZERHUk1tRVlnS2JjdG43dDZobS8rdFRDa1JkZE9p?=
 =?utf-8?B?MmwyenN3K2JYeDd6S001Ky9QWks4Qkk0OGdTYm1pUmFsS1hlOWZMV3IwVGFn?=
 =?utf-8?B?eXBkN1F1NWdLckQ4MU1mU2YrNXp5WVVYVm1kZGpjR2I5OFRMNEh0bWRYbWty?=
 =?utf-8?B?dU1VSXlmdnRMdkoyL09idWdhVnErVnNNV2JTSXY5QXFqOGlja3Vwekk3S0JC?=
 =?utf-8?B?UllCenJ5YkY4QVJ3N3hOSkhCSkZGOC9yOGZsZU01Q2hIWVZRZzNCQjZGazdO?=
 =?utf-8?B?S01GT0xiZEhiMUtNRVhkZXhBd0dxYWgxdEkzS2ZjZFBXMWJKUVkzTUNVdUt5?=
 =?utf-8?B?ckRnUHJpYnF1WktKUUg4MWdYb2FreDJOcWpObk5JaHE3RzFvZENFN3o5Ulg2?=
 =?utf-8?B?dGVRcEZTTFJxTlVhWWJRVDhDeHFhMnUzKzYvbGtGbWNkQTlydnVmK3Q4eGU3?=
 =?utf-8?B?WnZlZ05FTlRDL0xUSkxBL1dKd2VRNG5iM2JVRkN2QjF6V2RUUzg4Q1R2bHZh?=
 =?utf-8?B?SEpocFJtRmJmWE0vWUl0OVJTNWZvd2xaN2FQeFF1V0YySnJDdzREYlRkNkNu?=
 =?utf-8?B?emEzMG5udExpRUVra3BPK3RjVU5PaWUvb3gxNjBPeThuTUVkZlVaeWtzem9z?=
 =?utf-8?B?MDUzaDRpMHVoR0U2NUFxNVc3V1dkdzVZdStBbi9JYVFuVmVpZDRZNXNVMHA3?=
 =?utf-8?B?RFpBVlplL2RpeGl2bWFRcG1yS2VldlRWOTZXazBOaTBWbStYQzJPODdibk1Z?=
 =?utf-8?B?NmFVc3F4d0RydVdJQ2kxMkduNEwyRW9XN2dJYXpSUHVwK0pmSGRtZkJLbXh0?=
 =?utf-8?B?eCtCTC9jb1hObUFZZHJ4cCtMOU1ickJiZzVhMWIrVjE3OWRsWVpvdTV6cFVI?=
 =?utf-8?B?NW9qTjBjcEdZby9CZkhybVVYcW05amZQb3dPQ2ZDaWxqYWdOWldHT1RzeEUw?=
 =?utf-8?B?QldaYXUyU2F0WlBPaEd1Rm0vZWRrRldYQ1d3WURZYWplcTU5M1oxNFlja2Zo?=
 =?utf-8?B?dFlUQWJNd1d3N1FFZEZHVzNBcjRRUGZPZ0tjQkU0N3J1NUlCK2lYVlBkSWxG?=
 =?utf-8?B?YTRlVjIxM1hOQWhCTTlFbWt2TmYyZVMzZWliNk1PM2xZNVU1TFFocDRrcFAx?=
 =?utf-8?B?ZG9ISXRnakVlbzBYcFd0U3J5VnJYQUMyOEd4cHpRTVQrWDk2Qmwzbm5KVU5Q?=
 =?utf-8?B?Q0tnSDdtV09XbERuOWpFUUlrcldueXRJQzI2RTgrOXo0alJXU3NzMlQ5dzl0?=
 =?utf-8?B?Tzd0ak1ZeHR2clNlc3hjMXpyU2MwOEtEUnduci9VMEVxRVpMTEpQQ0J3WmxF?=
 =?utf-8?B?NldxWWJQa0JsZDFQeTJ0dHpJandpVHVlYklhY3RRVkk1MkZUYWVCR2JJSkk0?=
 =?utf-8?B?K1ZVNy95UW11WWFFR0IvYzNMQ1QxM2NRUERZeGxlZjRJYzlsYjB3WHJQNTZl?=
 =?utf-8?B?SUdMTXhmeUVHVFowcmw4SXVRaTdyMWdjSzFob3lmUzJKNWJ0MkNYWnFUU1F1?=
 =?utf-8?B?eFFKNjdvRzhvRzdPZktrdHFxWlJFdHhmNDBXdUZ4TWZxYXJsODB0UXBFZ3hY?=
 =?utf-8?B?VlFPVWg0Z0ZJcit0ZnJyZGErN1RlcFpUWGZzcjkzaWRqSUZ1bXdRaGFocHBH?=
 =?utf-8?Q?9WfbI8BudkozA?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dUpYNVgxemZYeUdLc0k2NUJ0eEltcmp0bUJSNVBOUlRoVmtKVi9jYUZDaXpt?=
 =?utf-8?B?ODl0K3czY21oMzJzeWZpVTdMd1FBS2pRMUVJdTlGMTRZOGxKNGs4clVJWTZi?=
 =?utf-8?B?aGpmNEZWTERNVzVaMkxYZ2tPdTdKUzRhMTE1YnVDL3Z2NE5WYUM0VG5TZGpw?=
 =?utf-8?B?VGR0eVFBNHI5ejd0OHhXREkvMi9PS2wybTN1SEUyNkJhUEdxOU1OTDFJQ2l3?=
 =?utf-8?B?d1RYbC9uTCszZFQxelFGeTREYjFlYXZ1L01mWnpWcHJpUHdKWTFBbGRHRW9v?=
 =?utf-8?B?WU5kKzNKbG1LZXFtWTFva3VNZ2wzNUx2QVByWUJaR3d4am0wNnlncXNHalhS?=
 =?utf-8?B?SEIvdXplNEJXNEFxVmFRL1JIK2N1YlVBVjBCSnR5NGdqUWdLeTl5aE5rRzI2?=
 =?utf-8?B?aktGR1BZN0M5a09zTGRKekJOTHlSd0pTYXNhWkh1Q2JUbVpyUHV6Z3BWQldT?=
 =?utf-8?B?TE15Q0NNZ0J4ZVVUSXhBMUwzakpWVDJaczljOVRZLzJlRWxaazdwVmVCZGU1?=
 =?utf-8?B?R0VLbEdSb2l3cEVRclFiZElHS0V1dzE3KzJGclN2bm9mclVBRFF6NFV6NHNh?=
 =?utf-8?B?T1ZpQnNrOFZBSVlOZEhRdDJXVi9ZR01nTk1DV2Z6YjJYamhoZ3Z6a1FibVNF?=
 =?utf-8?B?eHJjUlRVSkZjSzJvOGJoSmJ5cExITkN4c0xzbEtEOUhhWnR6anNjcmNaTm4z?=
 =?utf-8?B?a1RHaEM0TVJhTStOMEN2TlNid3ZVRWwyb1o1bU5YWEYwZHh4SFdLb1lhckk3?=
 =?utf-8?B?bDlNMmJjd09CZFRWQS9ZVk1HZzY0VGw3UCtjdFpEbWRzTXZoUHZNSDhBVEk5?=
 =?utf-8?B?WHIvRVpMS3lEMGZkQVZNOVhuRXZiZDJINWlja2pwd0cyM1Q0UzJVenJZYjA4?=
 =?utf-8?B?c3RWUmJqQ2RtVDlxeWhCWU1RZFhOMmtvR3VHTTF3UE84emNsOE1ZREZuTS9p?=
 =?utf-8?B?bFJKVXo1ckJQRzJLaGVOWS8wYUVZUjhmb1QrUklWd2xjOFVwZ0sra1NPRWtO?=
 =?utf-8?B?d1BwUGdvZnJNaXpKcHJ2WWUxbVJZTlljTkNnKzdIVmZxY2J6dDVoZkl2N040?=
 =?utf-8?B?aTVpQnN2R1J2WWN4RitOUG1tdjlVQWd5eUlKVkM2c1FtWHFGaHJvcGY4RG5Q?=
 =?utf-8?B?R3I4Sm1STnErMXc0bVdlOWVZNjBqbEZ6KzVPSTJXVE5FMEdKRUZKUkQ4RlFp?=
 =?utf-8?B?dUR5RHlqemtTcHdXSW9wV3MyVjFkRXNLZVJxRkdmdmVPc3ZXTzBudXNLaXVv?=
 =?utf-8?B?czRtRzg4UVNvNHZJRlpaOTZqZE5ZclBveks3dHdWYy9Nek5od2Fuai9rb2ZB?=
 =?utf-8?B?bzIzLzhoYk5EVzRmb1ltTFNHRDZiU3VJMS9ET0tlYUE1WUZCZVFleDNqVjRY?=
 =?utf-8?B?WkZybW5xdmpiUDRaYVB0My8wOGlxNXNKUEVyWUNNRkYzYkJKWmRKUGJPU05C?=
 =?utf-8?B?a0JHMm5tanBpZ1VoRVg3TWxkV1lxQW5wQWJLR0lmR2dzampsY0VZMmtmaTdw?=
 =?utf-8?B?ekFXdFpvWXBMblo1OHh0SmVVY1NMb3hwNkRqVEE2ZzJpRDNhQWM0TXFtUXAw?=
 =?utf-8?B?TWs5eGhaNHFIbEZTS3hrVWdxQi84TVpweEVQc1E3TXcyMmF3aDMxeW5ZRDgz?=
 =?utf-8?B?UDBrcERUbG41Z1ZRNTgrQTgxK3p4WW9SMHJsNDVtV0FxN1czbEhwR25pdFEz?=
 =?utf-8?B?NFVzUVptZmlwRitBcS9DcTdjZ1JNRjdvUkF1NGdiOCtiT0NyODRva1Nnc0ZV?=
 =?utf-8?B?SmNLczgxK1UyUEh4eFhjQ2hvQmFUZHdiVXNHSXNsTVFVRzhtdzg4ZHZxN0Zs?=
 =?utf-8?B?V2kwdFhUWGtwWWdsY1MxbThvalUyWlZkWkV4bzd2L1E0ZU5YdGFkck9iWFlQ?=
 =?utf-8?B?bTFldTBGMm1weTZCazUwdkdNd3BFQTBuNGVYcCt4aHd4MEhwcm5mV0ZzZjRu?=
 =?utf-8?B?bUpiY2I2Mnp2REdmcWtOdW1JbXk4aEZqRHZJZTFmYXpBNGpjQVVjSFFsK05X?=
 =?utf-8?B?dHpMZzREOGxHdWIzSmptWENaMjN6V2FWUWhGRHNPQXBtdlZ1aWM0dVZWdjdT?=
 =?utf-8?B?bUdMSlNVT084RTZGaUhObk4rQ0VlYjJ2V0QvRGtuRDVlaTgxQzA4bTJvZUtH?=
 =?utf-8?Q?jx6q7zSn0qGmhN/skJMo6o6DM?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4433e3d6-8312-493c-d62f-08dd72a4b58f
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2025 11:43:10.4202
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WYdva5OW9/10vw89zXXDWpdhF0uaSCJATtXFCg1fEWnPWvZtY/p7HZ/2lydH6ElkvrBQUSxrDZaZvbepGLSZHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8257



On 4/3/2025 5:04 PM, Thomas Gleixner wrote:
> On Tue, Apr 01 2025 at 17:06, Neeraj Upadhyay wrote:
>> +static void __send_ipi_mask(const struct cpumask *mask, int vector, bool excl_self)
>> +{
>> +	unsigned long query_cpu;
>> +	unsigned long this_cpu;
>> +	unsigned long flags;
> 
> Just coalesce them into a single line: 'unsigned long a, b;'
>

Ok

 
>> +	/* x2apic MSRs are special and need a special fence: */
>> +	weak_wrmsr_fence();
>> +
>> +	local_irq_save(flags);
> 
>         guard(irqsave)();
> 

Ok

>> +	this_cpu = smp_processor_id();
>> +	for_each_cpu(query_cpu, mask) {
>> +		if (excl_self && this_cpu == query_cpu)
>> +			continue;
>> +		__x2apic_send_IPI_dest(per_cpu(x86_cpu_to_apicid, query_cpu),
>> +				       vector, APIC_DEST_PHYSICAL);
>> +	}
>> +	local_irq_restore(flags);
>> +}
> 
>> +static int x2apic_savic_probe(void)
>> +{
>> +	if (!cc_platform_has(CC_ATTR_SNP_SECURE_AVIC))
>> +		return 0;
>> +
>> +	if (!x2apic_mode) {
>> +		pr_err("Secure AVIC enabled in non x2APIC mode\n");
>> +		snp_abort();
> 
> Why does this return 1?
> 

snp_abort() would terminate guest execution. So, code below it is not
reachable if we reach here. I will add a comment here.



- Neeraj

>> +	}
>> +
>> +	return 1;
>> +}


