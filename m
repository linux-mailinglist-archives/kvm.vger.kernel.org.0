Return-Path: <kvm+bounces-16611-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 378308BC698
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 06:49:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 368EDB2126D
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 04:49:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3919C47F4A;
	Mon,  6 May 2024 04:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="aB2+YbNy"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2076.outbound.protection.outlook.com [40.107.212.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2339345943;
	Mon,  6 May 2024 04:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714970963; cv=fail; b=Tk38plm1/v6Eagy+/PDvJJUU9x6PCuWP1OiNPrrJ/lb9bsEwaKgqYDW0Be48VdDW8/F7MR46Il7LHKL1cnFc048WzLhl/FOZCdA9fn2njoWc61twNfrvp8BRX5IC2sgO2FRrsh5fhR3wb6Xo/LK7g1gJ+qJMtNncAZ9TBG/XtBc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714970963; c=relaxed/simple;
	bh=mfB8NTYkh/wTP/xKaBKwLTj1+Z4KkYqahvSPCA+U+Bk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kd4mErIT7dmBOIEqrWykNw6IbaHIgEI96ch1lAPk0JoXZw2yQN+m+bU4ZAtT26viPUZG+Yh4DJcP2ZVSKpmUcaV13aljS5lkqgVBeql/RNRq+ry6v5KDKBy8gCkIKcnAMfrbi7zijGaJ/50zmJd0riOe1MV3kf9OPREM0+JGcL4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=aB2+YbNy; arc=fail smtp.client-ip=40.107.212.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UidfyqCoorawTeflRliugvWejv/KNuql6xuX6ll2GpC2eCVNYHWCqLw4jNkIaFJnfoxCP8xl46IBWp/ZhQaH0QwoEx2+qMouafOlfAlFz5Dy3N5XhMKLrySXpz/cz6tB4nBJ63l5a1spYlcBlE4pCngXuXHFbUJV+YzlPbAQIg6aipJDpKIW7csdzWe+xZN5gqiFEOAMTJsB7eIVbO8Pc8GZxHp5EF2Enrru6GVPKDK159qM5IABZUQDs6yE2Fk77rDYo0aIhF+O3ZAXiPJXZ1WGLnz/MtgjOhTYJysglbpoXUNqsRmW189BE3Nd9jG/S2tf4urvC1dwGMn8fC/eAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cKZvdIFbpRou2pU9PEf2THyxHuMdbtsqpHz4hveELvw=;
 b=GdOgtMA4J3u3V8rqxWWPF/R+ZDlkE3R5o6dhx90/zM4Wc4VgVMMU3P3a85Jf5lDYVptbs/OTqDBAU4fiNNxyNjpDedcEXYpQDwfjIFrHxZyplsNaekbQVEJQK+t4nPIROa1T/EW1gB16TQO3Z7Qbz6qvds7ASZwdGJym+PrIuKwNIQnZfbWOoaVmT+0+pDCiKvRWHazXAILFabVmumRqZ+XI5uwxdN5edDXAD+LPS2WDnxbf9lm5AY06bbHj5LGiTyq6GA6O4nwtpunaMv/FA8v/XwYoY7lkacM8m6qh3tmhwPiJVmPj3fLzJm18UD4ZJ2mvnMJ+xy4zN4Z7ZIRB6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cKZvdIFbpRou2pU9PEf2THyxHuMdbtsqpHz4hveELvw=;
 b=aB2+YbNy5J83rmNF7Xt7zzq4LlpeAWH2yYbGLh6UJfZFY4MGOZHX40Z8Q8fiNLbVlwg5RXKiQa2Ti3oC2whf0B25IRomxk9MQS7yw1nd53a5vixbbRwXURL6dMR/AslL0oPs4L5EWax+Bz5K+OReQvVx4z9f696UwZ+MaowJbg8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB6588.namprd12.prod.outlook.com (2603:10b6:510:210::10)
 by DM4PR12MB6566.namprd12.prod.outlook.com (2603:10b6:8:8d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.39; Mon, 6 May
 2024 04:49:16 +0000
Received: from PH7PR12MB6588.namprd12.prod.outlook.com
 ([fe80::5e9c:4117:b5e0:cf39]) by PH7PR12MB6588.namprd12.prod.outlook.com
 ([fe80::5e9c:4117:b5e0:cf39%5]) with mapi id 15.20.7544.041; Mon, 6 May 2024
 04:49:16 +0000
Message-ID: <9252b68e-2b6a-6173-2e13-20154903097d@amd.com>
Date: Mon, 6 May 2024 10:19:05 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2] KVM: SEV-ES: Don't intercept MSR_IA32_DEBUGCTLMSR for
 SEV-ES guests
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, thomas.lendacky@amd.com, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
 hpa@zytor.com, michael.roth@amd.com, nikunj.dadhania@amd.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, santosh.shukla@amd.com,
 Ravi Bangoria <ravi.bangoria@amd.com>
References: <20240416050338.517-1-ravi.bangoria@amd.com>
 <ZjQnFO9Pf4OLZdLU@google.com>
Content-Language: en-US
From: Ravi Bangoria <ravi.bangoria@amd.com>
In-Reply-To: <ZjQnFO9Pf4OLZdLU@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0248.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:21a::19) To PH7PR12MB6588.namprd12.prod.outlook.com
 (2603:10b6:510:210::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB6588:EE_|DM4PR12MB6566:EE_
X-MS-Office365-Filtering-Correlation-Id: 2cf128c0-9efd-428f-628d-08dc6d87e25e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|7416005|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Ymp5blZFSGFGL0x2eE9BWmlnVkQ4ZkxKVEpSVkNLeG4zd2MwWVpVcUdIUmJt?=
 =?utf-8?B?M1NpREVhNTZ2MWROaCtlQ1poMmpvZno2cGhwbEhvOUQ0aTN4cmJ4amJkSW1x?=
 =?utf-8?B?akJJeE5nbEtWdUNYbjlJdm9jVXl6M09GUTlScDhuYjNSbTV5cXVUdVhabDVD?=
 =?utf-8?B?dHJGL2doSVFIUGZxcS90THRxbW05Z0JJZmR6M3I5VmhONGtvaDQ5MkpuK1NS?=
 =?utf-8?B?UkJoTXc0VVpvdTdIaHVyNVZMSVhyaU9IT3hTaVduY1pTWG5mcE9XNnRSS0pp?=
 =?utf-8?B?amdCZURFbDZudWJqczNLMnF1MWY0dm5SNmtNMjhTcnN2eEFKZVdQTnRWL0pl?=
 =?utf-8?B?N285SGRqNm9yUHM3aWhzd2VKZUlPd05NdzJEcTFhdkZ2eXByODZFVXhieGk3?=
 =?utf-8?B?SXRzM3REWFd3aXN5TGpSUXNpclRQVEhxby9PekVsT3I5UWpxZy80ejZIVmNu?=
 =?utf-8?B?YXFFRFBTeXRzMlRzUlUzY25qNXVJOVo0blhKNENBWDd6K1JNZmtHbGlGZ0w5?=
 =?utf-8?B?ZlMyVlIwMnA5Y1dyOU5TZVpiK0MvdWZUNDljNVZmcGwvZUFmRDdTaTBSbXlE?=
 =?utf-8?B?T3pqRHhrNWZXc1dWVy9QUE56QzFZNHpIMS9URTN1ZkRuVndzS0hkVTYvVXNE?=
 =?utf-8?B?VVB6end3aW1iSFp2U2kvazhldlRWY3NjRGR3VXlSQzFIc1VCeVZmZFZZd24r?=
 =?utf-8?B?ODl3UlQ4VVhSMjlUUnJRMEQvMmtjRnAvYW1UR3JZR0NmWi9jRXVZV2lFWHFD?=
 =?utf-8?B?YVdSdXYxZ2c5amFSNHd5Wk5LTCs5cGRRLzkwSTNnMU1ZbXpsbXFIQkRIWktD?=
 =?utf-8?B?KzgraG14ZEFXVHJzSXovVTVuZW5MaDRZaUNISUJROFhpaU9rL2Zxa1YvSVpn?=
 =?utf-8?B?enBBRDgzN0Q5REw0M0FxdVhZY3hjb0N1NDkvZ1V3VU5CWnRNWDdmSmFSb3NH?=
 =?utf-8?B?eUlZY0w2Nk9oVFJrZ0RSZGFJZXlXQ1A3UTlWL0dLOU9NYkUvaU9jWW8rdEFZ?=
 =?utf-8?B?S1RRZjdHYVRnZVg4em9oMnhza3RjNXd4QXNrWGtsQTZnWlVRdjlVV3ljd1Bv?=
 =?utf-8?B?VkpDMEVaQ3VnUThEMk5LOFZqZ08vZk1LNXN6cWxLaENkcDFwaTM2STA4YkJ3?=
 =?utf-8?B?eERYMEF1WGtCSHJFbDBYOUR4ZzQ3QVkzdUsvZ2JURXFMcDZnbkFNcndmdUZK?=
 =?utf-8?B?cTRnSmNQNis4cW1RTS94T2Q2Mlc3ZjVFWDhqQnlMTHhTNUJHeGhiTEU0ajlJ?=
 =?utf-8?B?YjJHQjZyaFRJK3dvTWY5eTZ6bEJIY1JoY1NhS0Y1eitjK0dnbnMwYU9xbS9I?=
 =?utf-8?B?SnF0bHE3TWhaRU5QYjg4YXlXTjZ6MnhpTUdwZ04rQjI1LzVzSWl1a2IvVWZ3?=
 =?utf-8?B?RVBhTWlzMkt1L3ZnY3Z3YzF2MU4za0JQdE5BVGtWZGhaZFFBNzFmK3grZUxZ?=
 =?utf-8?B?c2h6MXJwRTBvUmxJODhSRmkvR3BXd2ZyZDVXM0hQOFhrOTJuNWlhZVRXbjJU?=
 =?utf-8?B?Qy8xSkFkbU1BK3VxcmhVMTFwd2V0VElxWGpUQ2VNNm1zNEZYMjBLR3R5L3Uw?=
 =?utf-8?B?RUowdXhjeEh5bnE4QjJRKzZwMzhBaXdUTkJoMzNXRVlEQ0xNa0JUTXRxN3VL?=
 =?utf-8?Q?IhJlh0SjgH3p+4m40/RTeVhUpsXSWPVewOZb32OMo5FY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB6588.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(7416005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZG5ua29ja0piOStLMEovRlRPTHVOd0JnSnI2ZVVqY1krUHlKb2dOSmpSWDlp?=
 =?utf-8?B?L2Qva2xmVEdRdUc3Z1RnTWgwYzZ5aGE5UVVMbW4raFhvR3JTZjdrNktuNWUz?=
 =?utf-8?B?NTJGeGdPU2RkVzh0TGwvd0xPVnFVUlJCZWpWbUVnUDQzeUJocmx5SHFaMUp6?=
 =?utf-8?B?UHRQOGpnanRibDcrZTFJK2l2T2NsM1h5WjdjZjNXTnBnVi9iN3JJT0t5ekJm?=
 =?utf-8?B?UVJsblowbjRCVGtjanVaSk5EWnZTOUxxRWNSeE5VM25PbkxSUlVKVFFwZ2g3?=
 =?utf-8?B?bUc1Rzl3Z29HN0VIcktObzVVSC9uWlFJRzdMK2U5WDF3SklPVFlVdVZZdEZ3?=
 =?utf-8?B?WVlST05kbGtUeTZKSFZKS3kzMDBXQkJrTmh6U3hzTm9pMlBBUmdpTlNxaXpr?=
 =?utf-8?B?VGlTNnVReWFVNGRla1RmeXZXWS81bC9NeUhDUkV3V1oxVHpBVEp5OERhR1Bk?=
 =?utf-8?B?ME43L3FhWFRyc1grZ3Q4VEE1SVloYWsxL1hxWnlmTXQ4SkhmbE13b3YydnpE?=
 =?utf-8?B?Q25kenFEbFhrQ1NOcXQzeXY0NkF4WVlvUmFRM1AxbnY3Q2xzM2Jhb01zUXBH?=
 =?utf-8?B?eTJPVThkaGJzYjAweGJUaGRXVmtLc3NsMStBWjBRbk96ZWYrOEFwTHFZMFI1?=
 =?utf-8?B?dkJVTlZWMld5dmVlOFlRUU1ZUW5rV2RGclBGOUE5US9FcDJrMXBEVVk1KzRM?=
 =?utf-8?B?RzFybjY5eUlzRHovUTVHM3MwcHFzNlE1NVlIWFVwc1hCR2laSi9jYVJ0cEZS?=
 =?utf-8?B?d0JxRlBoNnBOQmlURyt4QmxsZnc1UklqLzNUeDRGUlNjMjdvT09yejRkQXhQ?=
 =?utf-8?B?ci85R3Z1YjBKQjc3dkNXQ2tsZ3FNL0Y4QVJWYUR4WGl6c2dUaDhRc05uODNQ?=
 =?utf-8?B?UHI4VC9iM2J5ejhhSkc4THdUNjRYZ3VvN1VCRHFQeDdsZ0lmWUxjVkZOOXIr?=
 =?utf-8?B?bElGV1h5L0xYeEVwZVRPOVZJakVGK0ZGMFZveG80RkFFT2FndTg2WU1USzVt?=
 =?utf-8?B?ZmRmcXFqNTltZytndlBuS0pDcG9ueExnYXZSV2hWR0k3NFUyZTFJcHF6a3N5?=
 =?utf-8?B?R0I0dldjWDBwbFdtNW96UW45M25iUGQ2eTNhYnlHNkQxWFBQOUdTd2J6MXVD?=
 =?utf-8?B?MDVKd0ZLOVJlYXJjMysrOTRhdW1DaDRiQ096eWM3bUtscFRIYk1IbXZLR0Vu?=
 =?utf-8?B?cjRueTlFdjhwVmZkTmxsL1E0Q2FHL2VnWGNMME4yM0VNYy9UYVgwWEtmdHRs?=
 =?utf-8?B?bEcwZCtkSWNLQXdZb1NvRjZDQTc2QVhWV2VlL0c3SXBINWxUbm1mSXJVU2o1?=
 =?utf-8?B?d041NTl6SURaSHVOang3WUFTcW5jYkRmNWNvNWc0bmkrTll6ZG5FeHJxT0hq?=
 =?utf-8?B?TTMwU1d6KzFYTlRWR1RBOFh0dld5V1N0V2p3U1hxNHRINGUrbUdsenVSM3ZW?=
 =?utf-8?B?SUxDYkdueU9OL3pIMkhsdU1JeDlIWXB5Um54UnBNSVNWZFp2c0wrYUV1b3dG?=
 =?utf-8?B?LzE5MHlVSW44SW5rR1lYUHRJd0N3M0YyVnFCdnVjcTFhd2VXY25hQmdQTFpP?=
 =?utf-8?B?K2pGY3lMTVZWYlVsNmRJMVJtSGt1WGQyb2Jrb1cwZEx0TlUwMmlickhBVjJp?=
 =?utf-8?B?TEpJcVFNK203bnNZR3ZyaXZJQ3NEZ0RZK1RxV1A1dkNlbHNiRVgvMW04a0g1?=
 =?utf-8?B?Z3FiVnJKb1JLYXVlMGpxTDc4UlRxU2lQN3lHK3pFa01WQkVyV2twSWI1VzBu?=
 =?utf-8?B?aGU1OE0rLzNEaGlvVU10OUtoeXJpRFVERlpLck93NUVqajRQcWcxUDQxbklx?=
 =?utf-8?B?TjRoNW4vempOQ2xGT0pWZGk3UENqZ0hwUWd2N3QwcHovcHZKZ0ZHVU9heVZH?=
 =?utf-8?B?aWJyaHZ5Qi83cWV0QXBqNnZVWFNRZjA3aGpwL1M0MU5Od1drREh0OEdVMkJY?=
 =?utf-8?B?K2FpMWNiM041L1lOL0JqdFJmQkZxQTNxS2xQNEFlV3BucHlYZzJpSXdpbmdQ?=
 =?utf-8?B?WDgrRFhmOHBjQ3dFOU5scDRKOS9UaGwvN1BlUHVUL0FUWllrMEptVWM4UGgw?=
 =?utf-8?B?eHhwT2ozQzl4WFhoZmxnU2Uvcy9TUjVGYlByTzEyYUdpcUF0dkFPNnpzaGtZ?=
 =?utf-8?Q?7riaYcDkqkmskU2pGcuQliNFv?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cf128c0-9efd-428f-628d-08dc6d87e25e
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB6588.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2024 04:49:16.7213
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3gqdTAAnt7Zmr+5dIXmfg89LZ2pHQ3g5xjrkMRa8Smrzy3iGZOpUbc+Gx4HbcKr+AGpazgYKlCP/Y4QmkQoCPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6566

On 03-May-24 5:21 AM, Sean Christopherson wrote:
> On Tue, Apr 16, 2024, Ravi Bangoria wrote:
>> Currently, LBR Virtualization is dynamically enabled and disabled for
>> a vcpu by intercepting writes to MSR_IA32_DEBUGCTLMSR. This helps by
>> avoiding unnecessary save/restore of LBR MSRs when nobody is using it
>> in the guest. However, SEV-ES guest mandates LBR Virtualization to be
>> _always_ ON[1] and thus this dynamic toggling doesn't work for SEV-ES
>> guest, in fact it results into fatal error:
>>
>> SEV-ES guest on Zen3, kvm-amd.ko loaded with lbrv=1
>>
>>   [guest ~]# wrmsr 0x1d9 0x4
>>   KVM: entry failed, hardware error 0xffffffff
>>   EAX=00000004 EBX=00000000 ECX=000001d9 EDX=00000000
>>   ...
>>
>> Fix this by never intercepting MSR_IA32_DEBUGCTLMSR for SEV-ES guests.
> 
> Uh, what?  I mean, sure, it works, maybe, I dunno.  But there's a _massive_
> disconnect between the first paragraph and this statement.
> 
> Oh, good gravy, it "works" because SEV already forces LBR virtualization.
> 
> 	svm->vmcb->control.virt_ext |= LBR_CTL_ENABLE_MASK;
> 
> (a) the changelog needs to call that out.

Sorry, I should have called that out explicitly.

>  (b) KVM needs to disallow SEV-ES if
> LBR virtualization is disabled by the admin, i.e. if lbrv=false.

That's what I initially thought. But since KVM currently allows booting SEV-ES
guests even when lbrv=0 (by silently ignoring lbrv value), erroring out would
be a behavior change.

> Alternatively, I would be a-ok simply deleting lbrv, e.g. to avoid yet more
> printks about why SEV-ES couldn't be enabled.
> 
> Hmm, I'd probably be more than ok.  Because AMD (thankfully, blessedly) uses CPUID
> bits for SVM features, the admin can disable LBRV via clear_cpuid (or whatever it's
> called now).  And there are hardly any checks on the feature, so it's not like
> having a boolean saves anything.  AMD is clearly committed to making sure LBRV
> works, so the odds of KVM really getting much value out of a module param is low.

Currently, lbrv is not enabled by default with model specific -cpu profiles in
qemu. So I guess this is not backward compatible?

> And then when you delete lbrv, please add a WARN_ON_ONCE() sanity check in
> sev_hardware_setup() (if SEV-ES is supported), because like the DECODEASSISTS
> and FLUSHBYASID requirements, it's not super obvious that LBRV is a hard
> requirement for SEV-ES (that's an understatment; I'm curious how some decided
> that LBR virtualization is where the line go drawn for "yeah, _this_ is mandatory").

I'm not sure. Some ES internal dependency.

In any case, the patch simply fixes 'missed clearing MSR Interception' for
SEV-ES guests. So, would it be okay to apply this patch as is and do lbrv
cleanup as a followup series?

PS: AMD Bus Lock Detect virtualization also dependents on LBR Virtualization:
https://lore.kernel.org/r/20240429060643.211-4-ravi.bangoria@amd.com

Thanks for the review,
Ravi

