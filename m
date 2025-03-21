Return-Path: <kvm+bounces-41671-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 83824A6BE5F
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 16:36:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E4F1146522F
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 15:36:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DACF1DF721;
	Fri, 21 Mar 2025 15:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="PIQHcQR0"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2070.outbound.protection.outlook.com [40.107.223.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BAE49461;
	Fri, 21 Mar 2025 15:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742571371; cv=fail; b=Jg0UKyfj7drooGb4l9qvYLvnkv+5a4nWJKHGrT6lMx3uogdenjjDFizRWXMUepun1I5ZreyVpYQRDXWVb/AVYY6/eOpvZdX3bd8c41UAXEJW9SZBhTkcNOG9m04DzXhTC+Q4Xi41cDlUDxytrEEqSQE1rVnPHMR/KBFlRowG2SU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742571371; c=relaxed/simple;
	bh=YyYems16syuOLpThbpIe2IW2wIPHoEyR+EAuCna7hh8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=htHzrBDJzPmBmz4b2RVWUXu5MbxlUe4Dx/VtvLHjUnoBVS7O+E7qAJXuwGbEy7NHLxLHfBu0oze39CERqLhjzVILwFQLjMUZX+WgqTXZ73aVAC6jDiG1au3PE+8KmbSISMRbXtyKSP++qf+U2UtsB9bKGQsidy4U4s3JIqXZ2hw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=PIQHcQR0; arc=fail smtp.client-ip=40.107.223.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y9wTPKtwqP2lUwBWCuKtUjruCJz7TVoatisxvnt+gl5q7EDQOBJGTRoHt//crBYRHCzpYWwXWhomAkAYpWtPqUasYfN9AXgVtKlzPs0CW3Z2gK+C78+pf8JLlK2K+XhgKA6OvEXg6Db98d6ypVjAkFdLpXvKV8Pr11wSsO0eCRimge8Rc8f4KrTrpjAbKBn7u9BYU1j9MCh74KV9+p+7UC44uBQoLC6J0ceX+CrupALudxDhmhotv01ZbVPQ/5Q+k6sTRtEojpOyhEvkZ042aOgP/y3eqxHboxAUNX9ig3/tLL3uOUXjd9+pDtMN4Kp3YIg7f67uhxwxoR5ubq9LRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CPGZHjYhG6Dy8tkk6aHc94806I4Z6LoPe6oj+3TqGTM=;
 b=QjGJOHesxipKfCh2lOa1Y0/vvE5j3wEoA/UMPwY2zcCTFRRPdyoh8f1/llu4i9cxW53EUA64+lNroYSB1LVKThurPDsjq66/6MnBoRFQimnTyBevhFKwqTuJ5LxH6iXW7zJRO/88le6xhVmClCO77ahFW2LvHyco4qVdwrweeBuZkiVAz1BOrxkjcggiZjZzbNQO6+Xl0gxwjf2hZsFdkL14NGOtnIxVJPTpZbkEuGlFQYkvofcJabWhh2QFnyW5S3qzGftjxF/7r8GbedvjxvFm6W9KxjR0CXXBvT7ixuz+VgW0PyGt0S1ceST+lmgD7vv6PmxxBK6qoOZFEPmVVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CPGZHjYhG6Dy8tkk6aHc94806I4Z6LoPe6oj+3TqGTM=;
 b=PIQHcQR0KCNXJ+zEeH2aYBHTLG93a534vR5x04JTRHRSNUXzZFlYni7r1R8n6QncARQ+dD5h0uwow3J6r0in1Av8rrbTHl1eHiqda0Yorm2hTYtseNTg6qYwBSQovwaPYf8mQFX+7utFUTTwibV/dKOkSXvavSQMr3HVibfTfIs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 CY5PR12MB6621.namprd12.prod.outlook.com (2603:10b6:930:43::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.36; Fri, 21 Mar 2025 15:36:06 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%4]) with mapi id 15.20.8534.034; Fri, 21 Mar 2025
 15:36:06 +0000
Message-ID: <ecc20053-42ae-43ba-b1b3-748abe9d5b3b@amd.com>
Date: Fri, 21 Mar 2025 21:05:56 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 05/17] x86/apic: Add update_vector callback for Secure
 AVIC
To: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Cc: bp@alien8.de, mingo@redhat.com, dave.hansen@linux.intel.com,
 Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com,
 x86@kernel.org, hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org, kirill.shutemov@linux.intel.com,
 huibo.wang@amd.com, naveen.rao@amd.com
References: <20250226090525.231882-1-Neeraj.Upadhyay@amd.com>
 <20250226090525.231882-6-Neeraj.Upadhyay@amd.com> <87jz8i31dv.ffs@tglx>
Content-Language: en-US
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <87jz8i31dv.ffs@tglx>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2P153CA0030.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::15) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|CY5PR12MB6621:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e80e7d1-900d-408e-4c19-08dd688e188d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RG12TGFRS1Y0WCt3MTNoNnVXRUlsWThzMXZFbFVmUTRVcGZicVNyVnNXMjYz?=
 =?utf-8?B?eE5kbDFtWWhTVVc1N0pFZVA4a1diWkRVaXdlUGFrOW9VdkNLempDNEh2ZU5O?=
 =?utf-8?B?dE9JWnhycXVJT0g2RWdQMFNWNXBPUWsxRjQ2K2daT3ZONUpYN1lxTXUxRURT?=
 =?utf-8?B?Sk1CeExLcWZRM1E0QXZ2eFdtZXZJcTdyOU9qWXhtYzhxaGVTRHpLMjBPdkJI?=
 =?utf-8?B?b2NnY09OQ3ZqMkdlREZCbFNxNW5RS2dSSXpkakRPQnZvaGUrdE1oNkt1Z0Vp?=
 =?utf-8?B?bm5GOFBhcDJLd0MrQUVQQzRNalB4bU9JcDJGK1Arb0hHL1FqSzU0YTY5MEcr?=
 =?utf-8?B?SmF0dThrTlhGanArK2F5d1pGdVZLRTVSdDZROUprSW5rSkJUTkJyQno5SDdh?=
 =?utf-8?B?dXFsZzJiN3REUWFCSVRhR05PVFJMTTVTWGEvVjlKWEVUczduVnhvRjNYdFJi?=
 =?utf-8?B?RExBWmU1cUZmYWR3ZzRlZXlNemZDUWFURm0zN3loU0FtYmNBWkp3YmJBRGly?=
 =?utf-8?B?NFV5c1VLUEJ2UG8yTG9lOGs3dXRXM3hlcGwxWHJJNkRZNno4R2lGZlVMNnBW?=
 =?utf-8?B?K1dxWXdqKzBLd2dkRHByb2JPWjgxUmhxdWRmZ1N6YVRLY0krc0dxcHMzZUVu?=
 =?utf-8?B?Z0hTZzQvdTJRQjJ0U29NNURXaWova1BjQ0tyTGcxLzI4WFFwWFpyOXp5YmQ4?=
 =?utf-8?B?aWU0VEc3Yk5EMFF5SEIwcWg0YzhYMHhHdjQ2RzRwN2FuQWNiL2tRS3M3SVk4?=
 =?utf-8?B?QU9CTVJuYnlza3V0QWZNUmVJdC9sTnNVUDFjL1B2enpHdDhiQ1RIbU9QOVRv?=
 =?utf-8?B?eEdaa0xjWkFaVWNFZmhXZCtxTjlPdE5VU0cwT3FTL0FKb1JDamZPbmVWT1ND?=
 =?utf-8?B?WlBDTG9NazF5aitOaE5yNHlDQTA4RHlrZlBHMTMzRmYwTkdJV09BSTRPZm1o?=
 =?utf-8?B?SEpDek5Gam5YZ1EwTFQ3MWxXZ0lDL0drZ2QzNzdFNkVYOWZhcXFZSm11amtI?=
 =?utf-8?B?R3l5Sk5RdXdzRFlETXFaYlJLVlhNK3JNM0RoSG0yK3dzU1VFa3dNbk12NHNn?=
 =?utf-8?B?T0pNUWN4enJCNVZhclVhcHRrWThDR05KNUZTSGorZCt0dlAxMkxSOUpCOHIv?=
 =?utf-8?B?bllaYzgvK3ppNGJyTi8zdWpMZGJveVpsK3BZdE9pNlVtZHlSald0MzZ4VGZp?=
 =?utf-8?B?RmF2Skl0ckM5WVc0NVB1L21lWVE5aWV0TU5JVmZkVkw5WTREaEd6QTFtZnFp?=
 =?utf-8?B?VmRPOEtiV2l1Ny9udzdxTG5IU0o0V29zZmJKLy9OMkk0RFZ3L2VLMkppK3l4?=
 =?utf-8?B?RmFOc2t4Qy9aUFdnQnhRTHZpK2QvbnhUalRVdm0zSENmd2lxYlFYeUQ2YkQw?=
 =?utf-8?B?Q3BpY0M2Z1dhaExiakI1WWMxQWtHcU9VY0RlUjk3RndIY0xuTEorSUx6ejFj?=
 =?utf-8?B?OEVBakw4UEpGT0VkNGJFeWg5SjZWYTVHSXBxR0JoL0R2QmhxMEVjbGkvUjlr?=
 =?utf-8?B?U0h4SmxGZlJ6WE1NVG9iOTZGVUcxZ29YU2lpVi9VeXFuWlZLWHgwNnZFc0xM?=
 =?utf-8?B?NDc4NXVIYVh3bG92N29KY3BqZjVzelN3bklqdUdLK2s0NGl3aUdERm83Rmpy?=
 =?utf-8?B?THArN0M3RXUweWhySk9nVk9GWXYxZGNXTlg3cGlzTnBwS2dSY2RkeXh1Ritl?=
 =?utf-8?B?ZVFwSVVNa3VUOEVXeEU0NG9HWnpNcTdwTkh3L1dWelIyemxqZzJKSkx1bkJF?=
 =?utf-8?B?K0xRcnAxVEhmLzMwRGFvZ2FDSzJ2dHo2dXdVRkh2NjB4a2ttcEdQNld2OGpV?=
 =?utf-8?B?QlcwSGpzZ3ltTno0Q3c1dz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NWgzalJuQnRrNUk0WUJIUVJXWlpJZmNkSTlXeEx2YXNsVkpqVlFOZ3hBY0Nn?=
 =?utf-8?B?QzBPTW1mRXBVQUIxMWRnbU1Ndyt5RnQvOEJqZGlTWmlENnAyTWZFdk1hZENy?=
 =?utf-8?B?M1E5bDhVWkxCWkRSeVpQS2t1ZHZGQlJTUm5KTThaME1DQ1FoWHBaRjlrbEY3?=
 =?utf-8?B?RXk1UmViV0RoNTRnSm1pZmQ5WjRXejZHL0dBb3NxcXZJaXMvcmEzczU3TlJu?=
 =?utf-8?B?QzYrY1EwT0dIZ0pDYVJmTTNjdnJvaDBYaW53QUN4TG9jMmtyNHZ1OXVPQmhP?=
 =?utf-8?B?c0xqQ0ZEd3U5MHNoNm05UWpqL0tDV0hhVEpqYkx6WUJHYzVXVkwrVndySnhN?=
 =?utf-8?B?ODF1QUZJUHVPenVWOVNESEF2UlZCZTNNM3lmTEJVQ3Jxa2o0RTNLQzFpSjZu?=
 =?utf-8?B?Z2xhQWZUekxZN0J0T2F3a1cwa0l4ckhieklQZUNURlVqODBYTk9SNVpSa0xL?=
 =?utf-8?B?eUJvZ0FqV2E4SnVKeXNBeHFOc3NuMXFRWHEvNVZYZFhsVkZJSG1Ra2dJQ3NR?=
 =?utf-8?B?MFlHeGtXd3F3VVZNRExDZUM5OWpabU9XSjVobjVUTTQxTGJJN2dpeUdiN0lq?=
 =?utf-8?B?ekwvZk9ZdVFIaGY0NHF5N3lEamk0a1cxUVBOZVd6RG02bS9QSk51ZmN0UUNY?=
 =?utf-8?B?YWJ3Uno1QXNTRjZRNlJmQ0UzWFQ5b3VHMktjdUtvZUxKZHpSTGRXZjd3Vit5?=
 =?utf-8?B?M2ZvdXhpZ1JMSnVCWGlrMkR6WHhMbER1SDZLYUlDWjAzNFhMMUlNMFFhYk8x?=
 =?utf-8?B?aFBBMmF5ZVgxeFBUR1J3MEVzV1pnaXZReStBVXFDV2pwYlU0OUpid0o1U3J4?=
 =?utf-8?B?eFNjNzN0WUF6aGhKRjRPZlI1YmgwRlBlZ29JRmR2QktuOWFhbWVsRVJqZ1JC?=
 =?utf-8?B?L2NpbGhYKzA3YUhPcnA5aVE4TW9rbldnMG93alYvT1VEMnZXZDUrOCt4bG9k?=
 =?utf-8?B?OEI1MWlqZlFjVnJzTy9aTHBDb3czK0EzTWdDS05KYmMxdkFDMnh3S3ZrTnFL?=
 =?utf-8?B?OW1FZEhMei9OK3NWbHRVL1dZRzlhQ0VhZnl6Zm5BV0R0R1FRcUJCd3hRQkZ2?=
 =?utf-8?B?QmRIbVB4MXV0MnF4OFhLNEJ0S2o2czRnV3BsK2R0QjhwbG1aZ2c2amJBa0dE?=
 =?utf-8?B?L2I3VFhHN2JFSjFleXlCU1hjanN2T1RLdTZpOEZvbHNqSGJLZFp5L3pWR2Z5?=
 =?utf-8?B?VzI1TTFLQkVCS1pVaFVRcDBZK3ZlekQxaHFQODRBNG5RNTgyaTZpeWcvSWhl?=
 =?utf-8?B?REUxbkV1OHdDK0RWc1VqbmVuaEFwNGxSbHE0eU1jZ0hCUE5XRFo2YmFoak9U?=
 =?utf-8?B?TmE5cHNjOWpzV0NCOVlFWHNWdnJlallYNmZlSmVhTXNIR3hTdkJwYksxVGVu?=
 =?utf-8?B?cVc3bEZBcWZ5MEwybWhXNmZRYVVreEdKWGQzRlFzUmVZOVFleVVDNnJaQ2JD?=
 =?utf-8?B?bWhrbjQ4VUxia0lQZjdhTWNoOHBMTVBLZjVicy9PejR1Q3k0YWs1TkhCZzl5?=
 =?utf-8?B?bG9oejVJTDVDMUhoYnVJOWF1VTd5cUo1NExWNTZRSVZqTnNRZ0xBZlNDMkx5?=
 =?utf-8?B?R21ScXJsakwrcmwweTRST29QcXFvUXhzcUdtZDNYb3A1OVp4QXlhTlIvUjQx?=
 =?utf-8?B?RkdQQUdoKzdEUkdRcHZCTmFPb0xVazZ4NG5JV2JXY2Y4b1BCT3dWejJtc2lk?=
 =?utf-8?B?cisvTi9yam9ROGM2VzY1cVIwRHJRRGpSTmw4MlBmQ0lYbEZzeHozOWdlNEVM?=
 =?utf-8?B?c0xEWkc0SEdkTC9XbXFnaFg3U2JtMVBtVmF5NjNmUnRjTHVSdWZmN1NxT3Br?=
 =?utf-8?B?QTVGYitXMWFUWmg5S0c4cnRWZlV6UTZHSnpIcGtBM3F0RStxNUlaZU9yWk5I?=
 =?utf-8?B?UGk3VnBlT3Q1aTZHb0ZaRGwyZEgwSDdJNFU5S0R4bThUNkM1dTlZR2FjeHlD?=
 =?utf-8?B?Ukp3ZkRJdUJHNVhXdlFzUEx3cm9yLzU1enhMTWFvMGpUS3NjMUljZVdzN3p0?=
 =?utf-8?B?WHVhTGp1K3Mrb0poNlVHRWFYOU5pcE1pSmJCcUhyZDlGYmRxOGhYdWhjdHFm?=
 =?utf-8?B?dU9ZSFpDWXg2N2wxTTIzU045VzV4VXNEamQvd3hqcjhzNC9CYnd3K1pIYXph?=
 =?utf-8?Q?LiMuROgkn1W+goiJxwU6Z9GLG?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e80e7d1-900d-408e-4c19-08dd688e188d
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2025 15:36:06.6266
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cQL6tinV9guMLy3lsY8yXHDKSxzYNR8Lp1GW/bl4Co8hOJUy3qM3zKCA8BYYNdAqOPwysGan5OMN/YazjySoQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6621



On 3/21/2025 7:57 PM, Thomas Gleixner wrote:
> On Wed, Feb 26 2025 at 14:35, Neeraj Upadhyay wrote:
>> Add update_vector callback to set/clear ALLOWED_IRR field in
>> the APIC backing page. The ALLOWED_IRR field indicates the
>> interrupt vectors which the guest allows the hypervisor to
>> send (typically for emulated devices). Interrupt vectors used
>> exclusively by the guest itself (like IPI vectors) should not
>> be allowed to be injected into the guest for security reasons.
>> The update_vector callback is invoked from APIC vector domain
>> whenever a vector is allocated, freed or moved.
> 
> Your changelog tells a lot about the WHAT. Please read and follow the
> documentation, which describes how a change log should be structured.
> 
> https://www.kernel.org/doc/html/latest/process/maintainer-tip.html#changelog
> 

Ok

>> diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
>> index 72fa4bb78f0a..e0c9505e05f8 100644
>> --- a/arch/x86/kernel/apic/vector.c
>> +++ b/arch/x86/kernel/apic/vector.c
>> @@ -174,6 +174,8 @@ static void apic_update_vector(struct irq_data *irqd, unsigned int newvec,
>>  		apicd->prev_cpu = apicd->cpu;
>>  		WARN_ON_ONCE(apicd->cpu == newcpu);
>>  	} else {
>> +		if (apic->update_vector)
>> +			apic->update_vector(apicd->cpu, apicd->vector, false);
>>  		irq_matrix_free(vector_matrix, apicd->cpu, apicd->vector,
>>  				managed);
>>  	}
>> @@ -183,6 +185,8 @@ static void apic_update_vector(struct irq_data *irqd, unsigned int newvec,
>>  	apicd->cpu = newcpu;
>>  	BUG_ON(!IS_ERR_OR_NULL(per_cpu(vector_irq, newcpu)[newvec]));
>>  	per_cpu(vector_irq, newcpu)[newvec] = desc;
>> +	if (apic->update_vector)
>> +		apic->update_vector(apicd->cpu, apicd->vector, true);
> 
> A trivial
> 
> static inline void apic_update_vector(....)
> {
>         if (apic->update_vector)
>            ....
> }
> 
> would be too easy to read and add not enough line count, right?
> 

Yes.

>>  static void vector_assign_managed_shutdown(struct irq_data *irqd)
>> @@ -528,11 +532,15 @@ static bool vector_configure_legacy(unsigned int virq, struct irq_data *irqd,
>>  	if (irqd_is_activated(irqd)) {
>>  		trace_vector_setup(virq, true, 0);
>>  		apic_update_irq_cfg(irqd, apicd->vector, apicd->cpu);
>> +		if (apic->update_vector)
>> +			apic->update_vector(apicd->cpu, apicd->vector, true);
>>  	} else {
>>  		/* Release the vector */
>>  		apicd->can_reserve = true;
>>  		irqd_set_can_reserve(irqd);
>>  		clear_irq_vector(irqd);
>> +		if (apic->update_vector)
>> +			apic->update_vector(apicd->cpu, apicd->vector, false);
>>  		realloc = true;
> 
> This is as incomplete as it gets. None of the other code paths which
> invoke clear_irq_vector() nor those which invoke free_moved_vector() are
> mopping up the leftovers in the backing page.
> 
> And no, you don't sprinkle this nonsense all over the call sites. There
> is only a very limited number of functions which are involed in setting
> up and tearing down a vector. Doing this at the call sites is a
> guarantee for missing out as you demonstrated.
> 

This is the part where I was looking for guidance. As ALLOWED_IRR (which
tells if Hypervisor is allowed to inject a vector to guest vCPU) is per
CPU, intent was to call it at places where vector's CPU affinity changes.
I surely have missed cleaning up ALLOWED_IRR on previously affined CPU.
I will follow your suggestion to do it during setup/teardown of vector (need
to figure out those functions) and configure it for all CPUs in those
functions.

>> +#define VEC_POS(v)	((v) & (32 - 1))
>> +#define REG_POS(v)	(((v) >> 5) << 4)
> 
> This is unreadable, undocumented and incomprehensible garbage.
> 

I will update it.

>>  static DEFINE_PER_CPU(void *, apic_backing_page);
>>  
>>  struct apic_id_node {
>> @@ -192,6 +195,22 @@ static void x2apic_savic_send_IPI_mask_allbutself(const struct cpumask *mask, in
>>  	__send_IPI_mask(mask, vector, APIC_DEST_ALLBUT);
>>  }
>>  
>> +static void x2apic_savic_update_vector(unsigned int cpu, unsigned int vector, bool set)
>> +{
>> +	void *backing_page;
>> +	unsigned long *reg;
>> +	int reg_off;
>> +
>> +	backing_page = per_cpu(apic_backing_page, cpu);
>> +	reg_off = SAVIC_ALLOWED_IRR_OFFSET + REG_POS(vector);
>> +	reg = (unsigned long *)((char *)backing_page + reg_off);
>> +
>> +	if (set)
>> +		test_and_set_bit(VEC_POS(vector), reg);
>> +	else
>> +		test_and_clear_bit(VEC_POS(vector), reg);
>> +}
> 
> What's the test_and_ for if you ignore the return value anyway?
>

To not set it again if it already set. I will switch to set_bit/clear_bit()
as test_and_ is not necessary.

 
> Als I have no idea what SAVIC_ALLOWED_IRR_OFFSET means. Whether it's
> something from the datashit or a made up thing does not matter. It's
> patently non-informative.
> 

Ok, I had tried to give some details in the cover letter. These APIC
regs are at offset APIC_IRR(n) + 4 and are used by guest to configure the
interrupt vectors which can be injected by Hypervisor to Guest.


> Again:
> 
> struct apic_page {
> 	union {
> 		u32	regs[NR_APIC_REGS];
> 		u8	bytes[PAGE_SIZE];
> 	};
> };                
> 
>        struct apic_page *ap = this_cpu_ptr(apic_page);
>        unsigned long *sirr;
> 
>        /*
>         * apic_page.regs[SAVIC_ALLOWED_IRR_OFFSET...] is an array of
>         * consecutive 32-bit registers, which represents a vector bitmap.
>         */
>         sirr = (unsigned long *) &ap->regs[SAVIC_ALLOWED_IRR_OFFSET];
>         if (set)
>         	set_bit(sirr, vector);
>         else
>         	clear_bit(sirr, vector);
> 
> See how code suddenly becomes self explaining, obvious and
> comprehensible?
> 

Yes, thank you!

- Neeraj

> Thanks,
> 
>         tglx


