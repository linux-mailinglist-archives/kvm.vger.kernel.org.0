Return-Path: <kvm+bounces-62837-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 5ED0DC50AC7
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 07:08:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 52C394EA525
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 06:07:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A71042DC32B;
	Wed, 12 Nov 2025 06:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="1pF643ZE"
X-Original-To: kvm@vger.kernel.org
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011041.outbound.protection.outlook.com [40.107.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2179C1D618C;
	Wed, 12 Nov 2025 06:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762927630; cv=fail; b=aWaHzxg07seQs6HDbEI0hV9RIXdTIfOkNNbdL8u3hfuWG9ADHSlveSXu9YsvEiQr8Z+hSM7zZMTNaeX8NaQqHKgJ5i1xonV2EIG+rrKcW4Q46CKM+lXa1Sr6aqZMyzrnmoa6QkxzhALS+PopC9KNVFgmUrBDUrKTzHiEDRapDR4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762927630; c=relaxed/simple;
	bh=aeEX8zTSxV3tTBPWrEnyWBeGg3ylmFsaaF6VqJJqrGk=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=oOKy0a/DVYg6h8viekWnwbFWj3xJo4iFBDsHZLoKLhjCc+UAEzvsLUP/bmGqtl+L2xBxihUKjQnXeCvZi+bj/UItoSzvt2A0T1ZSIWY2yVKAgVyG1Nqi8BmSCno26dmgUaka7t5/OYe2R9GCs3Nz8LuDXoKkvvd7XczUaf7kqcw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=1pF643ZE; arc=fail smtp.client-ip=40.107.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dHbSHiqBzHyZgVvzsM2twh333Mu5mkItkEeQYzDSZlKjHRm239oFyeIkcN7JIelgloOCXsM2m/ibPv9k2Urvc9esEZVfOo6va0Bqg53BOrQRk+ZlrxnuXaxzROk5/VjOKh68OJDXSDY0hs4jjWauqOrbmbjs+T8h/8XMEHGcN5N8X99VVnAK4d/VO7V468X4t/DW3wbDnVhdfza/RJKDfz5GJ6Y9PVMor9SAmAPgzTjY/ua8fr34IgilS9ICTcmIpj+QjwBYDrsDBvMmIEKCiRxVKSNT4mt70nzrP16vrjzoPZpdeUI7DTf28JcnQt3VkV7hbcNe9UB872jeWMXcqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HHG6b/wBP/E4F7QF7TsNyOjX1S4KKSZCgyasVs6ZrQw=;
 b=d80mi8mC7UpuJXcx0MPCaxAYRTN6g9eiSnvpFK5q2D3Zb1Bk7QzvvGt6EsEbNZMo1fPz+WEX1JTAmWqnu2bi7nvgkgiqAO7ZO5ykojlFQJsiPCroP7xmlnFtawSad1qqA9UqdFusjqEHColJrLbS5iNOpkaBavjDXRSESZOveSn3PzWANfKWlb7dDf9lrLmR8zaUSqBhDqHFgGFzJ/uheEd9an3F4mXlaApPVOubYGCdb7b88r91AlI8mRQXOX0E5z1QjN/hd3l2bWLiy9W69t/aqYGk/B2sg0Tn3GVZ8cLGbair+kQ3BnMDPC4v136OpedS6T57j76nuQfD2qoaIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gmail.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HHG6b/wBP/E4F7QF7TsNyOjX1S4KKSZCgyasVs6ZrQw=;
 b=1pF643ZEjUmBuBhooaE/K4gq3n+NyuBbjVED6r+BpLELinecQ4zGXjdRWh4L1SP7tjhQecVrzHBaDxrkAXbJZMIP7uhk6ptaK9iNhRnHeSlfohN/sSYqkRvhVMJX2Rr85R22IGUcgaxuM5Cps2xMJPiE4qny7RZij8Ybyb/GIHM=
Received: from BYAPR08CA0062.namprd08.prod.outlook.com (2603:10b6:a03:117::39)
 by CH3PR12MB7500.namprd12.prod.outlook.com (2603:10b6:610:148::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.15; Wed, 12 Nov
 2025 06:07:05 +0000
Received: from SJ5PEPF00000204.namprd05.prod.outlook.com
 (2603:10b6:a03:117:cafe::f5) by BYAPR08CA0062.outlook.office365.com
 (2603:10b6:a03:117::39) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9320.15 via Frontend Transport; Wed,
 12 Nov 2025 06:07:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 SJ5PEPF00000204.mail.protection.outlook.com (10.167.244.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.13 via Frontend Transport; Wed, 12 Nov 2025 06:07:04 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 11 Nov
 2025 22:07:04 -0800
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 11 Nov
 2025 22:07:04 -0800
Received: from [172.31.184.125] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Tue, 11 Nov 2025 22:07:01 -0800
Message-ID: <27c6a3f4-ca70-45ce-a684-fe8e9b33efd1@amd.com>
Date: Wed, 12 Nov 2025 11:37:00 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/10] sched/kvm: Semantics-aware vCPU scheduling for
 oversubscribed KVM
To: Wanpeng Li <kernellwp@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>, Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>, Steven Rostedt
	<rostedt@goodmis.org>, Vincent Guittot <vincent.guittot@linaro.org>, "Juri
 Lelli" <juri.lelli@redhat.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, Wanpeng Li <wanpengli@tencent.com>
References: <20251110033232.12538-1-kernellwp@gmail.com>
 <7bc4b0b7-42ea-42fc-ae96-3084f44bdc81@amd.com>
 <CANRm+CxZfFVk=dX3Koi_RUH6ppr_zc6fs3HHPaYkRGwV7h9L7w@mail.gmail.com>
Content-Language: en-US
From: K Prateek Nayak <kprateek.nayak@amd.com>
In-Reply-To: <CANRm+CxZfFVk=dX3Koi_RUH6ppr_zc6fs3HHPaYkRGwV7h9L7w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF00000204:EE_|CH3PR12MB7500:EE_
X-MS-Office365-Filtering-Correlation-Id: c81ede63-8244-4bf5-82e2-08de21b1b437
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RXJGdzZvM0ZNb3B5MGdkMitMd1RMWjZJNFdzdzRtZ1dEcS9FNnoyTmk5WEdq?=
 =?utf-8?B?SC9OT1FlMDkwSVh5dEtZN29oV2laMndSU1FBbDdGd1pXR2w2aXZXbEZVaHpD?=
 =?utf-8?B?TW1mMUJSYkZZRXR5aDRCa2tqWWszWE9mNFErLzdKcUNERVVDZmphWUhhNE9M?=
 =?utf-8?B?RnFJZGo0ZEk2a3ZRcmZhUkpUcHlaRkRVMTdpM1FWeFMrTlIxTGh0TzFvUUNa?=
 =?utf-8?B?T3FabmxwR0pSaHVFdGExWWhiemNnUnZRdDZLZnBhdmtOQUJMY1c4Qlo5MVVG?=
 =?utf-8?B?TXNnanV1TkZJZ3R6N3FjZk1BeHdsb1NRTUg1SUVtWEZXU2hBQXF3RCs0TnVX?=
 =?utf-8?B?TWZ6NG92VXA3blFHWVlGQ0V6aVBFZHBvMW94d3d3LzJxcy9BSHpmaDI0Ym44?=
 =?utf-8?B?TnZIOXMyK0RTM3dGeXR1ejNhMysxN0xhemhEMWN1TDNRNC9FdEhlK1lGc1lU?=
 =?utf-8?B?NFgzSHBLc252SStiN055VUFEVHV1OUFFNURSSUo4dmNzbFd2T2dpUmRhL3dJ?=
 =?utf-8?B?bDFHc1QvMHBvS2pLWlZFNU5pOFBiSHNJS1FaOGtkUnltRFFIbmIzeUJVZE5l?=
 =?utf-8?B?ZGVyNm1ZQ1YvN0YrWGk2M3pIdVZMZFdnSG15QWlSZks1UmNYU1ZXRDRGSVlV?=
 =?utf-8?B?QXhxWHgwUFRaZzFuQ3AwTFducmVPb2ZjQVl3OG04alJ5c3htQThrRTIwZUIr?=
 =?utf-8?B?QmM5b3IrZ3dVQkNGQWRDWjJ1ODdKekt3VWRDdlpLdTIxZTlFVGpoVi9DS0Rq?=
 =?utf-8?B?aFc0SCtpZEgycEV4L2NZRTZUSFJrTjVKTDdDaktNY2lmcnd2dkNhRkR5OW5N?=
 =?utf-8?B?YzZ5dnV3UlBxNW9sMjllTSt4QWpjMFV1WUZVOXBWNjhjaDFJWDN4cENJL0dk?=
 =?utf-8?B?Y2dxR3VtaGx1dDEwM0V2TlJtb2NRODZCdTl1SDFLSmhxeWJZajE0T2JsblE0?=
 =?utf-8?B?YWd5dkFPZ0kwd09iUlNsN2pJS0hKMUxuN3lJRzFYZjk1amhlNWh5MUZya1Qr?=
 =?utf-8?B?T3dKSXB4TlE0Rmd4ZE5IQjNKelhYRHNNQ3ZHS0h2OTJWcHJrS1pjN0FjYndy?=
 =?utf-8?B?cTR1NEw3aGNrRG5CVWd1VVU0am5US2tOK3FUOThUeHJyZjRMa0hEL2Q0L3BR?=
 =?utf-8?B?dWdCRGRTNmZlSTBROHBwWXViRnlIVEIvdWVVREphMmVmN1ZkQ3IvNXlPNTk0?=
 =?utf-8?B?K0d6RVJwRk9OU1JVbWRwK2JURzFsMXBHWTE5QkpCY3dibVJJU0FiRGlKVTNS?=
 =?utf-8?B?QlgyRGl6Z0kyRnJFZHBxdi9yeDZkUVI4V1dNVWVCMFR2ajJDRjlBNjN2dnJl?=
 =?utf-8?B?elhlcGxjWVIvcGVNT3JYMmhYb2FZNG1qUERiRzlmc3pMTTUxQ2l4N0VWNnBJ?=
 =?utf-8?B?UnI3Qy9vY0gwTXEzVmRMVTVLQWo1cXBVS01iNUg1amg4R0pwQnJ2KzJZWkV3?=
 =?utf-8?B?Q3JjNzhONnk2MXBYanlZRU0xMHVJUUZVLzVEWUFSYzFXZVFTOUNZbFp6N1E1?=
 =?utf-8?B?Mk1JTE1XbVA4NHdmenVmRzRYNlRiSzNjb0JMVmRVMnVNNzFtYTV1ZTNsTmZY?=
 =?utf-8?B?Z1RPeFZUVmZoZUVuc3RnMTRHNXVaUEdnMEFMQ3QyM0xsK1dwNmZHMFVYa0Rh?=
 =?utf-8?B?Z0JuOVlOa3h6b05vMmdaQzFydytoNjNBS0VpOWlrV0VSem53N2xuWHpLcHZy?=
 =?utf-8?B?QmJMVU9sQ21RRlljejdFWlptOVhLRFZGVkc2ZFR3aDBPMjdJRHVHeXQzOTBq?=
 =?utf-8?B?b3VrRm85ZHdabEcxeEwySmZOdklRMi9xYXlTZ1VwSHVjZnNoMkt2cy9idG41?=
 =?utf-8?B?S0Q2ZzZTbzRHWWk5dk4wTC9SNEhmT25ndkVJc0ZGQWh0by9xc3lqc1ZVMVZu?=
 =?utf-8?B?a1NEMmNQYi95UTBTb250RW9sMlRmVlU1WVZoaFhLZ0ZaQjVLLzRyUHBCSmE4?=
 =?utf-8?B?aVhXanVXVmVKQURkTGVPL2ZKSEtFaVUyK0s3YUdYdkZnVm82Z2gvdDZ1OFU0?=
 =?utf-8?B?cjdyRFR5aW8vZVQwakRwZ1JKMjhiTDlqRXdTOXFUT2xXME1RQi9RclkvaURD?=
 =?utf-8?B?VEptazN6QVFZb1ltYVBJY3hhRm00TXFBNkxaQT09?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2025 06:07:04.8323
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c81ede63-8244-4bf5-82e2-08de21b1b437
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF00000204.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7500

Hello Wanpeng,

On 11/12/2025 10:24 AM, Wanpeng Li wrote:
>>> Problem Statement
>>> -----------------
>>>
>>> In overcommitted virtualization scenarios, vCPUs frequently spin on locks
>>> held by other vCPUs that are not currently running. The kernel's
>>> paravirtual spinlock support detects these situations and calls yield_to()
>>> to boost the lock holder, allowing it to run and release the lock.
>>>
>>> However, the current implementation has two critical limitations:
>>>
>>> 1. Scheduler-side limitation:
>>>
>>>    yield_to_task_fair() relies solely on set_next_buddy() to provide
>>>    preference to the target vCPU. This buddy mechanism only offers
>>>    immediate, transient preference. Once the buddy hint expires (typically
>>>    after one scheduling decision), the yielding vCPU may preempt the target
>>>    again, especially in nested cgroup hierarchies where vruntime domains
>>>    differ.
>>
>> So what you are saying is there are configurations out there where vCPUs
>> of same guest are put in different cgroups? Why? Does the use case
>> warrant enabling the cpu controller for the subtree? Are you running
> 
> You're right to question this. The problematic scenario occurs with
> nested cgroup hierarchies, which is common when VMs are deployed with
> cgroup-based resource management. Even when all vCPUs of a single
> guest are in the same leaf cgroup, that leaf sits under parent cgroups
> with their own vruntime domains.
> 
> The issue manifests when:
>    - set_next_buddy() provides preference at the leaf level
>    - But vruntime competition happens at parent levels

If that is the case, then NEXT_BUDDY is in-eligible as a result of its
vruntime being higher that the weighted averages of other entity.
Won't this break fairness?

Let me go look at the series and come back.

>    - The buddy hint gets "diluted" when pick_task_fair() walks up the hierarchy
> 
-- 
Thanks and Regards,
Prateek


