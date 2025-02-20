Return-Path: <kvm+bounces-38640-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BAAE6A3CFC9
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 04:03:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8709C188A624
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 03:03:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D998E1CB51B;
	Thu, 20 Feb 2025 03:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="MRWILDYu"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2065.outbound.protection.outlook.com [40.107.223.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D84CC10FD
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 03:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740020591; cv=fail; b=YL6J2Mb84abqv/uGhLHHANCZeHrR1/Van22P2uDfVNkWCyBn4EBIaMADGmozdfoAsOGL0URCAByypSE9hG0gmSh7YfwzFrNSiwJGE1rdtyM/9By0Cux1w4OqxPwcxX6Jx7uslpoOCEVaPYv+2mNymgNi/tD857I9KmSHbyBpr6w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740020591; c=relaxed/simple;
	bh=ZPzepOKgkMmTAwusCztHGGZZevitLRl9xnP8i6qqDwA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=KUt7fiviawSrwIlgQX7oXBf10P6IVl3zeujipmebW0/xZQRpsHK4I7hrDht9R9/yM0g5OdRnt9oIlPjPdDS7jyJUKa+LquLsUIjaIJiXVqy4/gEl4VoObylOhtYaD00RHbgdDTmQ1KDtwMzv3zUPNRvV34REbDgVAu5WAtO2MFk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=MRWILDYu; arc=fail smtp.client-ip=40.107.223.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XxCSRFmTyhO+t6fiXbwsbQP2p5v2iOW1A0uLsTDMtAbecRKDCpQ8l4DSieemG23yv9DFP+5r6LlYPpDKM9rj1mXWRQv+CT70YnqfpUceYLRMbUQklhGMhRRgOTFAhmHj1Ku+ULYn2eg1L1pZuNlMv8mRy6ggkNzxHDcAZsRwnFYOPkUxl+MwK9DGAvkWBBePCFkdmiBTNI7CJDfkU8S5FdiNw8TSLzdyRZCYgqvbomEnMDgzGHsambmI7ZJHSaav3lbRhRDWT0ElX//v0CGBKLtxXGitVjU8V1yt1guLs+fq0cbZCi9dfDQkBteV94YGwxtJubQNDCaLUg7KJXaPGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RQodD4z6q/4Lk6ff98xUh90lzpoKym8baRhlogKi1s8=;
 b=ZauDuOjS5+khH+ZDHgx+Fzfa0iY9aEBdJS9Doly1DCrsqc0iKUdzFqIs+Er6bzxbth9CHixjy/195TCveNFARXpxMrZoQBMIVU7hqdUDgjOYlyOs7wXoc3eh9XL6K4Q6QIRJvclb3VFYc//ovOGF+238G5YJAV6cVt7psK/cKT81Upt1BBxNGqv1u8BIdcfAvWJ2baKKDbDUqIzQRh6E3n6RATuC95N4HJWjpplyAlwO2vXJBjV2ZFspYQCYMf6l4Bjs5tYr0+DVXPguftxCxEgA+qz/gQWA25pZfRfqaegVRg87c1fp0YoO1JT6va3iH+LWo/Ihk2czQ6XoNA/pZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RQodD4z6q/4Lk6ff98xUh90lzpoKym8baRhlogKi1s8=;
 b=MRWILDYur6LvmgE5w3BjF/7UwdT44gVmXe3iMyg45l6rS8fdJRgGEQ09TY5R2hiVzYCYtDsyGTeU7B+sfXorPGtKRtblDvf1jy7tJ9Rv1CFGbem28NWJmGUjecCD4iHmAKRe3A3BGFnmBRVMba3EBxQ4ODi4sC4P2ZsQPCT07lA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by MW6PR12MB7086.namprd12.prod.outlook.com (2603:10b6:303:238::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.18; Thu, 20 Feb
 2025 03:03:05 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%5]) with mapi id 15.20.8445.016; Thu, 20 Feb 2025
 03:03:05 +0000
Message-ID: <89e791a5-b71b-4b9d-a8b4-e225bfbd1bc2@amd.com>
Date: Thu, 20 Feb 2025 14:02:56 +1100
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH v2 3/6] memory-attribute-manager: Introduce
 MemoryAttributeManager to manage RAMBLock with guest_memfd
Content-Language: en-US
To: Chenyi Qiang <chenyi.qiang@intel.com>,
 David Hildenbrand <david@redhat.com>, Peter Xu <peterx@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>,
 Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>
References: <20250217081833.21568-1-chenyi.qiang@intel.com>
 <20250217081833.21568-4-chenyi.qiang@intel.com>
 <60c9ddb7-7f3e-4066-a165-c583af2411ea@amd.com>
 <c5682028-b84c-4b4c-8c4d-f3b43d412e83@intel.com>
 <23e2553b-0390-4215-a19d-0422b55efa38@amd.com>
 <d410d033-dd1c-43fe-85df-1bdaecf250fd@intel.com>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <d410d033-dd1c-43fe-85df-1bdaecf250fd@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MEWP282CA0069.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:220:1dd::15) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|MW6PR12MB7086:EE_
X-MS-Office365-Filtering-Correlation-Id: 58cb21a4-d7f0-4563-b7d8-08dd515b1884
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eW1PTE1pQTREK0R5NDRkd2I2WDJYT0lvQ2dIOVJhUWE5R2ZDWmZodU9rVDhL?=
 =?utf-8?B?dlA5dndTK2JJNWMwa0Izblc2aXRxK1ZPT0o3elJmUkc5VlcyRXV0OGx6MGhI?=
 =?utf-8?B?YXJoaDhMYmxRRklBUkt3WjgvMmJ0TXZPdXNRNXNGa2ZQNDAyWjJnelM2bEQw?=
 =?utf-8?B?M1drRGhmbW1hbjNYZnJ3elJYTXBJRXgxS0M4WEpJUkdCUVUxQ2tPSFhDRjY1?=
 =?utf-8?B?eU1OKzlKdmNIbmFNSWJPdThUOUg3c2MvTHNMcmZHSFlLeWFrMjFjaDQxR2Y0?=
 =?utf-8?B?STBHVWtLdnVlU2VLaWNSV00wdnQrN29Sb043OVZCRkFSVDkwOHhZUm5MUmly?=
 =?utf-8?B?dzRHdElEV3NsUkZZQ1Z3OHNaN2FCUmk2WWhjL2ROZktvaFBoUnI5SDFBaWtF?=
 =?utf-8?B?RnAyNGptTi9BeW5vU0dhZFpYeUtXbFpRR2J0VVZwSVdHQVlZUVYxQ2M3alBJ?=
 =?utf-8?B?bUV1SVNZOFpWemd1OGZBL2xZejYvbUo2aElSY09neEpLeHhqS2owRlM0djFG?=
 =?utf-8?B?blpIT3NwbjQ5R2lRQXVTNXRxK0pEd0Z1UzBCdmk0Zy9XZFh1NHhNY3Qxd0t2?=
 =?utf-8?B?SEl5MTN1WUdBY2sxTW11RzZEMkJ6bmdIWVhzNE5QV2xSMWNSbHlLak5Cblhz?=
 =?utf-8?B?UFE4UFN1TTF2ZnhvMSs1OFQydTgvcS9kSzIreGpWWUJZUlFubC9ZTHF2RmRz?=
 =?utf-8?B?UXd3d0g1WVJjSmlLYXBYeEFma2NvVDVEMkNTNEpKemFPYS94Q2gyRDVYVUxL?=
 =?utf-8?B?bER2YjRXNUpUajk0bXpnOFNnQVVBRUcvSldpK1VIdGpSTWZhQTN0VzVLZmsr?=
 =?utf-8?B?NXloOVAvMWl0OGR1TGRLSHpEOXU4ZEZtSlFkY082RW04VmxycVRpVEVhd0Fz?=
 =?utf-8?B?VGhrNWVwZkZjS25EM2YvYnpuSVoxMU5ldXBJWTAxVFdUYzJITUd3SnNLa09D?=
 =?utf-8?B?TFB3eHlXOWZlM1RlZk1aYkhESXpGU3RrZXlYWmpwcVZqa1VVV1lwcmVrM1Ay?=
 =?utf-8?B?dWZFQWlydjh2dkxKdmJYcHo3NmNPcHVLU3kvblJuRFlLb2laWUtsaFRxcCtH?=
 =?utf-8?B?eG9aMktqZlVlbVdpYTNQMi92ejFIMWxBSlBnQjBQRU50a0Z1aDdwUjczem5P?=
 =?utf-8?B?L1lHQ0dBNTVsZVdLckxGTGJoVEhUQ3hVZ2FkVlZkZWhCME02VjI0NHV2SXhh?=
 =?utf-8?B?QWVzWkhmUGZoZlB4S1ErQ2REL2x0VVZYYUt6Uk9UOXUvcDVCKzhhbkp6bUpP?=
 =?utf-8?B?VWNOL0Z4Q0YrZXFlWTVENDU3TENvUUNCNXllcS9oNGhDWXVEQmxySEZiWW9T?=
 =?utf-8?B?dHRGV3IxQmQ0RktkVmx5Yndsb2FIRUZQWDZ6OGFlQkVqaTlpdWw2d1FjZ1ow?=
 =?utf-8?B?RUpRZU1DeGFGbWZBcUxzS1Zta0Vkd1M3aDI0UzVqTXR1Q3BwSzJSbGJsQUJs?=
 =?utf-8?B?QmlGZE5ERjFURzJHUEtBdFRpM2ZVREU2SWkydlM0SG1TaWNObzZISzQ2N2s0?=
 =?utf-8?B?TVoxNzRjanBWeE0zOGNtNVdoRVN3RS9PNXovWndXd3hRbGczcmU1Skltd0NY?=
 =?utf-8?B?WmVPbENuTElEL25lSVY2NytxV0dHY3ozTDB6OWx2WFpRamluL3M1VFdrTTU2?=
 =?utf-8?B?am8yVk1XTjkvU1hSRmxhZVMvd3FoSWp0aElGVVU0Y1FnV28wc2gyMlVKekZK?=
 =?utf-8?B?ZVQ3N1RCVVJFaDhJODljaUd4dWYyVzNKWFp0Nmdkd0twUHJoSmRLdm8zMWJa?=
 =?utf-8?B?dFpRbE9PMVV4b08rVUZMWFU3UGlFRUk2TVZLOU5sWDdhdVlaSWZPV3M0KzVO?=
 =?utf-8?B?cTBGMDM1WFFGRjdRVDZGcEZ6TGhKRGQzMEZJaDNkR0JrZUpGb0U4WUZkUEMz?=
 =?utf-8?Q?yC1xFHhdMEfU8?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UkhpUDRnM0grZVJWZXpzY01VcThhRHJwbjRWcmNJQXpGUDBLWkU3eTdiV0NC?=
 =?utf-8?B?Y3d4SXQ3L1A0STNwRUNxUGk3SWZvNW1xRTRRRFZCZEFSb3A3NzhFY0xkRW42?=
 =?utf-8?B?eTJ6c2NZdDRCM0ZtaUxWTi9peTk5VDlBN1RKOHZwWWIvMG1OYnNSektUMHZT?=
 =?utf-8?B?MmlBZVJwdVB4NVREMHhHQm9keHlqWVVkMjQ5a21mc3Z0Smo1VjArUzh0ZjIr?=
 =?utf-8?B?MG9EbHRsdUJLOWJybnNzKzEra0Y2SEgwUWsrUXVHeEM4bk9KdDMxQmVUR3FO?=
 =?utf-8?B?NzBGQ0x4bkhTZEVQbWNLQlV3Y3Jpa2swTU9GVXNhUnNNQkhFdUJjYU1CaXVt?=
 =?utf-8?B?YnZvcXVxcko3WGdlWFc1Z1R0b0VFQVFxbmFmbTNkT2dQZWE5ZHZxdGVCRHI1?=
 =?utf-8?B?UkVPQVkyQzJDK2xOU0oxTHh2Ty8xL0s2TTIzRG1sUk9XRjlxbFR3QnVSTnVW?=
 =?utf-8?B?VEpYSWc2dUwyNHFqcVRnVCtyNTFNang4ZjkvK1JqNWJCdnRtQWwyV1haclg1?=
 =?utf-8?B?U2s4alhpZzdPOEpsNjJHRXpoN1Z5UmRzdE1jSndjMHp3TFRieG9LT25hVjBS?=
 =?utf-8?B?T1V5aDA5MlIwakROemE5a0RmNTI0WjM4TVZyaVhHQlpBb0RSbnY1aDdMQmpi?=
 =?utf-8?B?VU1qeDdyZzlkR2hySkpFbndtL3BrUGhYbjNvbENJUlRLaFVSRTYzeFRyb0ls?=
 =?utf-8?B?bjZBNThTaEt6ZHZ2djd4NjVDNFpZYjBqWmg1Wk9VQmphUmlXZWxGWElmbTd0?=
 =?utf-8?B?U0NjOUpvUVpSYXR5QnhKWTFac290cytVNWUxRFQ4OXNuQnVDZzJ0RTJORUxm?=
 =?utf-8?B?dWJjZ0JVQWVzOFJ5Nnp5aDJEekJVOXE2M3QwZUxkbDIrenZVZXpndkFMdSsv?=
 =?utf-8?B?Yi9FZSt6MWZWMzlxS2ZQeVJRVDg2WG8xY0xwR0cxeGxSMGd2RkVXRzZ2MjVH?=
 =?utf-8?B?TVEreVhjcW5RYmttWmhIcHFlY3BFS0tDeDhkVXptd2ZoOFBzOG9XTHNqNWhh?=
 =?utf-8?B?QmZmV1ZyYy9hY2h6VVlNMTJxSGN4K1poUi9lZDhwanF2VjdQR1JveHU2WUhI?=
 =?utf-8?B?QlhyNWlJaDlqNkFNS0lmOUptcmhya1hDUTNmcEJCL3hxaXRKR2dlZVJLdG5j?=
 =?utf-8?B?RjZRY2w3WDNWcDlyY056WW80WkZ5dkxyOFplc2VocWVLZFVEczhWaUxxUEhh?=
 =?utf-8?B?bGlzelFtdWhEUldzTmIrQloxRCs0eUdCR3dzbXROMmJ4SjJWelgvdVJ3dllP?=
 =?utf-8?B?NUUydFVwMVBBcGo1RHlVNEMvYzFMZEhwVTE0c0IvdHFVdkFNUkhPL00zckRl?=
 =?utf-8?B?cXcrRHhBS3lwYzhnSVp5eHA3NXlwWTRCY3dQUTYzVWEyeFhkNU5jeVJBMU5a?=
 =?utf-8?B?TzJ1RG5lckE2bXQ3Rk52aVBRUkVrVmFDT3BpSnQ4QmY4MEJFUTl3bCtFN3Q5?=
 =?utf-8?B?R1gxOGhacEIxLy9nSjM4Z0dtT0xKMFZKZTB1UW1YZG9TdjBtUnRaSWt0YUh0?=
 =?utf-8?B?OERLSTVyOFNkTEYrcTdsakFjbUphaG5VWDMzcGxHaWJwUmZCWTlZVFNXYXlB?=
 =?utf-8?B?U3hlZUUxdnRyMktIZk9UQzl6clVZWTVqSTk3SWlqK3Y5ZmJ4dUJXVEE1WjBF?=
 =?utf-8?B?K3FUd1BOSnUvZzBTVzB6ZE56NzhjRGlrTlcwQU81Y3o4UmRJcFhNOTV4bW80?=
 =?utf-8?B?dzZSUlJqS1FpNERTcFhuNG5hdlJvRUNLc3UrVml5dEVzTWozRTMvWWhsYitE?=
 =?utf-8?B?NFV0MnR6RTAvanUxTW9LQnhYSjYzdUJtRkw3YWhiOEZHTVV4d2duUjZrK20z?=
 =?utf-8?B?aGl2N2xWK0VrNG14NTBjWkRUdnJ4SVc1STg0QUtDbk43Z0xlWlJ5VC9hUDh3?=
 =?utf-8?B?SE5oMFVCaEFlWFBEdDlENngzZlNHUkRxZ3VoT1dtZHA5emd1MENoNXdpU1Ba?=
 =?utf-8?B?TkJwRyt3Uk94VXVRaDVoRUFvRVJCU2REMW9ncURMVE95bnRQTTcrRWFRQXR0?=
 =?utf-8?B?TzFBbXMxVnFhR3BIY2YxL2JHQjdhWXo1a0k3RXY1VmMxZjBmWElQTnM0aUds?=
 =?utf-8?B?dmxoMmhOVHV2ZERwS3lVa1g3eTlvSWJER1gzbTU4Yk1VUDBsaG1lYmd4QW1q?=
 =?utf-8?Q?3T4CFswYqp98N+WPnyMv6IOrW?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58cb21a4-d7f0-4563-b7d8-08dd515b1884
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2025 03:03:05.5103
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vAPk0VTtrv8/vqJPOovyZgvx6o8jm8MHVAqa4CjY+jiiBz0YLc/lRm+RjWD0m6BUih4h71Ro+UwBL/oOVRb59w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB7086



On 19/2/25 17:33, Chenyi Qiang wrote:
> 
> 
> On 2/19/2025 11:49 AM, Alexey Kardashevskiy wrote:
>>
>>
>> On 19/2/25 12:20, Chenyi Qiang wrote:
>>>
>>>
>>> On 2/18/2025 5:19 PM, Alexey Kardashevskiy wrote:
>>>>
>>>>
>>>
>>> [..]
>>>
>>>>> diff --git a/include/system/memory-attribute-manager.h b/include/
>>>>> system/memory-attribute-manager.h
>>>>> new file mode 100644
>>>>> index 0000000000..72adc0028e
>>>>> --- /dev/null
>>>>> +++ b/include/system/memory-attribute-manager.h
>>>>> @@ -0,0 +1,42 @@
>>>>> +/*
>>>>> + * QEMU memory attribute manager
>>>>> + *
>>>>> + * Copyright Intel
>>>>> + *
>>>>> + * Author:
>>>>> + *      Chenyi Qiang <chenyi.qiang@intel.com>
>>>>> + *
>>>>> + * This work is licensed under the terms of the GNU GPL, version 2 or
>>>>> later.
>>>>> + * See the COPYING file in the top-level directory
>>>>> + *
>>>>> + */
>>>>> +
>>>>> +#ifndef SYSTEM_MEMORY_ATTRIBUTE_MANAGER_H
>>>>> +#define SYSTEM_MEMORY_ATTRIBUTE_MANAGER_H
>>>>> +
>>>>> +#include "system/hostmem.h"
>>>>> +
>>>>> +#define TYPE_MEMORY_ATTRIBUTE_MANAGER "memory-attribute-manager"
>>>>> +
>>>>> +OBJECT_DECLARE_TYPE(MemoryAttributeManager,
>>>>> MemoryAttributeManagerClass, MEMORY_ATTRIBUTE_MANAGER)
>>>>> +
>>>>> +struct MemoryAttributeManager {
>>>>> +    Object parent;
>>>>> +
>>>>> +    MemoryRegion *mr;
>>>>> +
>>>>> +    /* 1-setting of the bit represents the memory is populated
>>>>> (shared) */
>>>>> +    int32_t bitmap_size;
>>>>
>>>> unsigned.
>>>>
>>>> Also, do either s/bitmap_size/shared_bitmap_size/ or
>>>> s/shared_bitmap/bitmap/
>>>
>>> Will change it. Thanks.
>>>
>>>>
>>>>
>>>>
>>>>> +    unsigned long *shared_bitmap;
>>>>> +
>>>>> +    QLIST_HEAD(, RamDiscardListener) rdl_list;
>>>>> +};
>>>>> +
>>>>> +struct MemoryAttributeManagerClass {
>>>>> +    ObjectClass parent_class;
>>>>> +};
>>>>> +
>>>>> +int memory_attribute_manager_realize(MemoryAttributeManager *mgr,
>>>>> MemoryRegion *mr);
>>>>> +void memory_attribute_manager_unrealize(MemoryAttributeManager *mgr);
>>>>> +
>>>>> +#endif
>>>>> diff --git a/system/memory-attribute-manager.c b/system/memory-
>>>>> attribute-manager.c
>>>>> new file mode 100644
>>>>> index 0000000000..ed97e43dd0
>>>>> --- /dev/null
>>>>> +++ b/system/memory-attribute-manager.c
>>>>> @@ -0,0 +1,292 @@
>>>>> +/*
>>>>> + * QEMU memory attribute manager
>>>>> + *
>>>>> + * Copyright Intel
>>>>> + *
>>>>> + * Author:
>>>>> + *      Chenyi Qiang <chenyi.qiang@intel.com>
>>>>> + *
>>>>> + * This work is licensed under the terms of the GNU GPL, version 2 or
>>>>> later.
>>>>> + * See the COPYING file in the top-level directory
>>>>> + *
>>>>> + */
>>>>> +
>>>>> +#include "qemu/osdep.h"
>>>>> +#include "qemu/error-report.h"
>>>>> +#include "system/memory-attribute-manager.h"
>>>>> +
>>>>> +OBJECT_DEFINE_TYPE_WITH_INTERFACES(MemoryAttributeManager,
>>>>> +                                   memory_attribute_manager,
>>>>> +                                   MEMORY_ATTRIBUTE_MANAGER,
>>>>> +                                   OBJECT,
>>>>> +                                   { TYPE_RAM_DISCARD_MANAGER },
>>>>> +                                   { })
>>>>> +
>>>>> +static int memory_attribute_manager_get_block_size(const
>>>>> MemoryAttributeManager *mgr)
>>>>> +{
>>>>> +    /*
>>>>> +     * Because page conversion could be manipulated in the size of at
>>>>> least 4K or 4K aligned,
>>>>> +     * Use the host page size as the granularity to track the memory
>>>>> attribute.
>>>>> +     * TODO: if necessary, switch to get the page_size from RAMBlock.
>>>>> +     * i.e. mgr->mr->ram_block->page_size.
>>>>
>>>> I'd assume it is rather necessary already.
>>>
>>> OK, Will return the page_size of RAMBlock directly.
>>>
>>>>
>>>>> +     */
>>>>> +    return qemu_real_host_page_size();
>>>>> +}
>>>>> +
>>>>> +
>>>>> +static bool memory_attribute_rdm_is_populated(const RamDiscardManager
>>>>> *rdm,
>>>>> +                                              const
>>>>> MemoryRegionSection *section)
>>>>> +{
>>>>> +    const MemoryAttributeManager *mgr = MEMORY_ATTRIBUTE_MANAGER(rdm);
>>>>> +    int block_size = memory_attribute_manager_get_block_size(mgr);
>>>>> +    uint64_t first_bit = section->offset_within_region / block_size;
>>>>> +    uint64_t last_bit = first_bit + int128_get64(section->size) /
>>>>> block_size - 1;
>>>>> +    unsigned long first_discard_bit;
>>>>> +
>>>>> +    first_discard_bit = find_next_zero_bit(mgr->shared_bitmap,
>>>>> last_bit + 1, first_bit);
>>>>> +    return first_discard_bit > last_bit;
>>>>> +}
>>>>> +
>>>>> +typedef int (*memory_attribute_section_cb)(MemoryRegionSection *s,
>>>>> void *arg);
>>>>> +
>>>>> +static int memory_attribute_notify_populate_cb(MemoryRegionSection
>>>>> *section, void *arg)
>>>>> +{
>>>>> +    RamDiscardListener *rdl = arg;
>>>>> +
>>>>> +    return rdl->notify_populate(rdl, section);
>>>>> +}
>>>>> +
>>>>> +static int memory_attribute_notify_discard_cb(MemoryRegionSection
>>>>> *section, void *arg)
>>>>> +{
>>>>> +    RamDiscardListener *rdl = arg;
>>>>> +
>>>>> +    rdl->notify_discard(rdl, section);
>>>>> +
>>>>> +    return 0;
>>>>> +}
>>>>> +
>>>>> +static int memory_attribute_for_each_populated_section(const
>>>>> MemoryAttributeManager *mgr,
>>>>> +
>>>>> MemoryRegionSection *section,
>>>>> +                                                       void *arg,
>>>>> +
>>>>> memory_attribute_section_cb cb)
>>>>> +{
>>>>> +    unsigned long first_one_bit, last_one_bit;


btw s/first_one_bit/first/  and  s/last_one_bit/last/  as it is quite 
obvious from the code what these are.


>>>>> +    uint64_t offset, size;
>>>>> +    int block_size = memory_attribute_manager_get_block_size(mgr);
>>>>> +    int ret = 0;
>>>>> +
>>>>> +    first_one_bit = section->offset_within_region / block_size;
>>>>> +    first_one_bit = find_next_bit(mgr->shared_bitmap, mgr-
>>>>>> bitmap_size, first_one_bit);
>>>>> +
>>>>> +    while (first_one_bit < mgr->bitmap_size) {
>>>>> +        MemoryRegionSection tmp = *section;
>>>>> +
>>>>> +        offset = first_one_bit * block_size;
>>>>> +        last_one_bit = find_next_zero_bit(mgr->shared_bitmap, mgr-
>>>>>> bitmap_size,
>>>>> +                                          first_one_bit + 1) - 1;
>>>>> +        size = (last_one_bit - first_one_bit + 1) * block_size;
>>>>
>>>>
>>>> What all this math is for if we stuck with VFIO doing 1 page at the
>>>> time? (I think I commented on this)
>>>
>>> Sorry, I missed your previous comment. IMHO, as we track the status in
>>> bitmap and we want to call the cb() on the shared part within
>>> MemoryRegionSection. Here we do the calculation to find the expected
>>> sub-range.
>>
>>
>> You find a largest intersection here and call cb() on it which will call
>> VFIO with 1 page at the time. So you could just call cb() for every page
>> from here which will make the code simpler.
> 
> I prefer to keep calling cb() on a large intersection . I think in
> future after cut_mapping is supported, we don't need to make VFIO call 1
> page at a time. VFIO can call on the large range directly.

> In addition, calling cb() for every page seems specific to VFIO usage.
> It is more generic to call on a large intersection. If more RDM listener
> added in future(although VFIO is the only user currently), do the split
> in caller is inefficient.

It is an hardly measurable optimization though. Could be a separate 
patch. I do not insist, just do not see the point, If others are fine, I 
am fine too :)

> 
>>
>>
>>>>
>>>>> +
>>>>> +        if (!memory_region_section_intersect_range(&tmp, offset,
>>>>> size)) {
>>>>> +            break;
>>>>> +        }
>>>>> +
>>>>> +        ret = cb(&tmp, arg);
>>>>> +        if (ret) {
>>>>> +            error_report("%s: Failed to notify RAM discard listener:
>>>>> %s", __func__,
>>>>> +                         strerror(-ret));
>>>>> +            break;
>>>>> +        }
>>>>> +
>>>>> +        first_one_bit = find_next_bit(mgr->shared_bitmap, mgr-
>>>>>> bitmap_size,
>>>>> +                                      last_one_bit + 2);
>>>>> +    }
>>>>> +
>>>>> +    return ret;
>>>>> +}
>>>>> +
>>>
>>> [..]
>>>
>>>>> +
>>>>> +static void
>>>>> memory_attribute_rdm_unregister_listener(RamDiscardManager *rdm,
>>>>> +
>>>>> RamDiscardListener *rdl)
>>>>> +{
>>>>> +    MemoryAttributeManager *mgr = MEMORY_ATTRIBUTE_MANAGER(rdm);
>>>>> +    int ret;
>>>>> +
>>>>> +    g_assert(rdl->section);
>>>>> +    g_assert(rdl->section->mr == mgr->mr);
>>>>> +
>>>>> +    ret = memory_attribute_for_each_populated_section(mgr, rdl-
>>>>>> section, rdl,
>>>>> +
>>>>> memory_attribute_notify_discard_cb);
>>>>> +    if (ret) {
>>>>> +        error_report("%s: Failed to unregister RAM discard listener:
>>>>> %s", __func__,
>>>>> +                     strerror(-ret));
>>>>> +    }
>>>>> +
>>>>> +    memory_region_section_free_copy(rdl->section);
>>>>> +    rdl->section = NULL;
>>>>> +    QLIST_REMOVE(rdl, next);
>>>>> +
>>>>> +}
>>>>> +
>>>>> +typedef struct MemoryAttributeReplayData {
>>>>> +    void *fn;
>>>>
>>>> ReplayRamDiscard *fn, not void*.
>>>
>>> We could cast the void *fn either to ReplayRamPopulate or
>>> ReplayRamDiscard (see below).
>>
>>
>> Hard to read, hard to maintain, and they take same parameters, only the
>> return value is different (int/void) - if this is really important, have
>> 2 fn pointers in MemoryAttributeReplayData. It is already hard to follow
>> this train on callbacks.
> 
> Actually, I prefer to make ReplayRamDiscard and ReplayRamPopulate
> unified. Make ReplayRamDiscard() also return int. Then we only need to
> define one function like:
> 
> typedef int (*ReplayMemoryAttributeChange)(MemoryRegionSection *section,
> void *opaque);

This should work.


> 
> Maybe David can share his opinions.
>>
>>
>>>>> +    void *opaque;
>>>>> +} MemoryAttributeReplayData;
>>>>> +
>>>>> +static int
>>>>> memory_attribute_rdm_replay_populated_cb(MemoryRegionSection *section,
>>>>> void *arg)
>>>>> +{
>>>>> +    MemoryAttributeReplayData *data = arg;
>>>>> +
>>>>> +    return ((ReplayRamPopulate)data->fn)(section, data->opaque);
>>>>> +}
>>>>> +
>>>>> +static int memory_attribute_rdm_replay_populated(const
>>>>> RamDiscardManager *rdm,
>>>>> +                                                 MemoryRegionSection
>>>>> *section,
>>>>> +                                                 ReplayRamPopulate
>>>>> replay_fn,
>>>>> +                                                 void *opaque)
>>>>> +{
>>>>> +    MemoryAttributeManager *mgr = MEMORY_ATTRIBUTE_MANAGER(rdm);
>>>>> +    MemoryAttributeReplayData data = { .fn = replay_fn, .opaque =
>>>>> opaque };
>>>>> +
>>>>> +    g_assert(section->mr == mgr->mr);
>>>>> +    return memory_attribute_for_each_populated_section(mgr, section,
>>>>> &data,
>>>>> +
>>>>> memory_attribute_rdm_replay_populated_cb);
>>>>> +}
>>>>> +
>>>>> +static int
>>>>> memory_attribute_rdm_replay_discarded_cb(MemoryRegionSection *section,
>>>>> void *arg)
>>>>> +{
>>>>> +    MemoryAttributeReplayData *data = arg;
>>>>> +
>>>>> +    ((ReplayRamDiscard)data->fn)(section, data->opaque);
>>>>> +    return 0;
>>>>> +}
>>>>> +
>>>>> +static void memory_attribute_rdm_replay_discarded(const
>>>>> RamDiscardManager *rdm,
>>>>> +                                                  MemoryRegionSection
>>>>> *section,
>>>>> +                                                  ReplayRamDiscard
>>>>> replay_fn,
>>>>> +                                                  void *opaque)
>>>>> +{
>>>>> +    MemoryAttributeManager *mgr = MEMORY_ATTRIBUTE_MANAGER(rdm);
>>>>> +    MemoryAttributeReplayData data = { .fn = replay_fn, .opaque =
>>>>> opaque };
>>>>> +
>>>>> +    g_assert(section->mr == mgr->mr);
>>>>> +    memory_attribute_for_each_discarded_section(mgr, section, &data,
>>>>> +
>>>>> memory_attribute_rdm_replay_discarded_cb);
>>>>> +}
>>>>> +
>>>>> +int memory_attribute_manager_realize(MemoryAttributeManager *mgr,
>>>>> MemoryRegion *mr)
>>>>> +{
>>>>> +    uint64_t bitmap_size;
>>>>> +    int block_size = memory_attribute_manager_get_block_size(mgr);
>>>>> +    int ret;
>>>>> +
>>>>> +    bitmap_size = ROUND_UP(mr->size, block_size) / block_size;
>>>>> +
>>>>> +    mgr->mr = mr;
>>>>> +    mgr->bitmap_size = bitmap_size;
>>>>> +    mgr->shared_bitmap = bitmap_new(bitmap_size);
>>>>> +
>>>>> +    ret = memory_region_set_ram_discard_manager(mgr->mr,
>>>>> RAM_DISCARD_MANAGER(mgr));
>>>>
>>>> Move it 3 lines up and avoid stale data in mgr->mr/bitmap_size/
>>>> shared_bitmap and avoid g_free below?
>>>
>>> Make sense. I will move it up the same as patch 02 before bitmap_new().
>>>
>>>>
>>>>> +    if (ret) {
>>>>> +        g_free(mgr->shared_bitmap);
>>>>> +    }
>>>>> +
>>>>> +    return ret;
>>>>> +}
>>>>> +
>>>>> +void memory_attribute_manager_unrealize(MemoryAttributeManager *mgr)
>>>>> +{
>>>>> +    memory_region_set_ram_discard_manager(mgr->mr, NULL);
>>>>> +
>>>>> +    g_free(mgr->shared_bitmap);
>>>>> +}
>>>>> +
>>>>> +static void memory_attribute_manager_init(Object *obj)
>>>>
>>>> Not used.
>>>>
>>>>> +{
>>>>> +    MemoryAttributeManager *mgr = MEMORY_ATTRIBUTE_MANAGER(obj);
>>>>> +
>>>>> +    QLIST_INIT(&mgr->rdl_list);
>>>>> +} > +
>>>>> +static void memory_attribute_manager_finalize(Object *obj)
>>>>
>>>> Not used either. Thanks,
>>>
>>> I think it is OK to define it as a placeholder? Just some preference.
>>
>> At very least gcc should warn on these (I am surprised it did not) and
>> nobody likes this. Thanks,
> 
> I tried a little. They must be defined. The init() and finalize() calls
> are used in the OBJECT_DEFINE_TYPE_WITH_INTERFACES() macro. I think it
> is a common template to define in this way.

ah, I missed that. OBJECT_DEFINE_TYPE_WITH_INTERFACES means they have to 
be defined, never mind that. Thanks,


>>
>>
>>>>
>>>>> +{
>>>>> +}
>>>>> +
>>>>> +static void memory_attribute_manager_class_init(ObjectClass *oc, void
>>>>> *data)
>>>>> +{
>>>>> +    RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_CLASS(oc);
>>>>> +
>>>>> +    rdmc->get_min_granularity =
>>>>> memory_attribute_rdm_get_min_granularity;
>>>>> +    rdmc->register_listener = memory_attribute_rdm_register_listener;
>>>>> +    rdmc->unregister_listener =
>>>>> memory_attribute_rdm_unregister_listener;
>>>>> +    rdmc->is_populated = memory_attribute_rdm_is_populated;
>>>>> +    rdmc->replay_populated = memory_attribute_rdm_replay_populated;
>>>>> +    rdmc->replay_discarded = memory_attribute_rdm_replay_discarded;
>>>>> +}
>>>>> diff --git a/system/meson.build b/system/meson.build
>>>>> index 4952f4b2c7..ab07ff1442 100644
>>>>> --- a/system/meson.build
>>>>> +++ b/system/meson.build
>>>>> @@ -15,6 +15,7 @@ system_ss.add(files(
>>>>>       'dirtylimit.c',
>>>>>       'dma-helpers.c',
>>>>>       'globals.c',
>>>>> +  'memory-attribute-manager.c',
>>>>>       'memory_mapping.c',
>>>>>       'qdev-monitor.c',
>>>>>       'qtest.c',
>>>>
>>>
>>
> 

-- 
Alexey


