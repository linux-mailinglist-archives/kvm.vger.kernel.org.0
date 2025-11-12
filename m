Return-Path: <kvm+bounces-62843-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 38373C50C09
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 07:45:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BE4A63A799F
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 06:44:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B28222DF71D;
	Wed, 12 Nov 2025 06:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="K9+Ymt4P"
X-Original-To: kvm@vger.kernel.org
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010011.outbound.protection.outlook.com [52.101.85.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 675C42D8764;
	Wed, 12 Nov 2025 06:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762929892; cv=fail; b=gvSOCmz9KkH8ndTGtJ+4okr1A4YLC6dvT4NEFl++pyaow9W611zhHcztDRVTbVHrThx0of0UAlImUSvgEcLDLHIlkGoNBEPLOMP1GcFC8B06uNOZImQ4TdZJOzeRzCMczlrMhmG6HujPiMbbYfNtsYdZTWsUwgLG/tjc1vUgOQA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762929892; c=relaxed/simple;
	bh=JWINmlT8PFLMRz9VfOmaiFE7gZZoxAAIS9AjQBAvJ5g=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:CC:References:
	 In-Reply-To:Content-Type; b=rTpRl6+tSNmY5JuRugskdwetG/rWqE2UHyREpg68xN59TX26HOX2AoG1h3p1AF1Vcj8hxfiHl3Z0snh3BPQu0EGlE1RUUjpwhxsIOXPD6US3W2h87G9f8XYf3mZa4kLTWGvQfspPMlFEaZhiO9GBb2W3PJDINatBfF84PsimIdQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=K9+Ymt4P; arc=fail smtp.client-ip=52.101.85.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TvQczpffcUsOF1ZEwj85CMGlyueFQs+VlPFGK7aI/g5b8Wt2Rt+FdinCC1wiWiSiBJ+oWbi5P7zUbcVzGO/DOFGgOwLkDcVx3bYGfsGtqlh6SAadhOgbIWPozc8bfaMQNHBekXyEZFuHB3vHp50S3CzG6CIRhsU4P9VcIcpwpeJqmHYoWc9CergYG4klNa96mGpi/51OSxp5AqROtwoNRTmzxJ+5oYrKDOQzUyILfvKu3GTKgjPBQt34uJVWPrwLfyfLFsaLkQK+37K3QHoK+u85HAq/yx+uVCkecXNfQ+VU7kReY8hZ4xmOOoLhPM38WFS6S1Jm+1K1ZhbFm3xZBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h3/O8joaaDCHIKvX7hukONhEq4YGMV5Yuiy/ji4KqN0=;
 b=lDrP/hiCpwCL+rFiwFSkBZ+zgX92w5jn/SDE+e0327kv2SUkxzFCjCTJE81Z04puvAjoVPseAHWmTel5RZqPwx/LgtNTqy/stCDhu5VIiMycfEvEd2j/3na8i3NzEAqFpOuICFOvwHc2N++i+jFQeTfUo1/aou4ZfoKk/k4o7GRdgHqaEXfGGHdfTkkdLq+KsutgaEUPTdVM4a6LrGOWFKy8ATsBZYVWC4FREtEy7o4vZxOZ727WYGFCPPI9x+jV13omQrSe3CxMfTBDigkHKS9n3yQRPuMy51ydQtd/3x8zgogc8DuJ5aAWASIoxLgzeldv5hCrm4nZExVFQhNMQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gmail.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h3/O8joaaDCHIKvX7hukONhEq4YGMV5Yuiy/ji4KqN0=;
 b=K9+Ymt4PyTYPwITKFe1SpKUKdJJXFCSpl80hJeZcJ4HnOHCH4eSoNLIdn7NDNlN1UC0Oi1oaXHZPtRgdSsfKHSBcXqpfv+YYrIcDmSoiYFfiOD8tBdsgaYVyOHFzWoNEFQQS1fEUP6puyV4GbzBsF1OJjlA/7yY5vZ6P6vQt3bs=
Received: from MN2PR06CA0010.namprd06.prod.outlook.com (2603:10b6:208:23d::15)
 by BL1PR12MB5803.namprd12.prod.outlook.com (2603:10b6:208:393::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Wed, 12 Nov
 2025 06:44:46 +0000
Received: from BL6PEPF0001AB4C.namprd04.prod.outlook.com
 (2603:10b6:208:23d:cafe::50) by MN2PR06CA0010.outlook.office365.com
 (2603:10b6:208:23d::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9320.16 via Frontend Transport; Wed,
 12 Nov 2025 06:44:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 BL6PEPF0001AB4C.mail.protection.outlook.com (10.167.242.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.13 via Frontend Transport; Wed, 12 Nov 2025 06:44:46 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 11 Nov
 2025 22:44:45 -0800
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 11 Nov
 2025 22:44:45 -0800
Received: from [172.31.184.125] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Tue, 11 Nov 2025 22:44:42 -0800
Message-ID: <b56f1c06-b935-4018-adb9-3702d8ff57cd@amd.com>
Date: Wed, 12 Nov 2025 12:14:41 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/10] sched/fair: Add rate-limiting and validation
 helpers
From: K Prateek Nayak <kprateek.nayak@amd.com>
To: Wanpeng Li <kernellwp@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, "Paolo
 Bonzini" <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Vincent Guittot
	<vincent.guittot@linaro.org>, Juri Lelli <juri.lelli@redhat.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, Wanpeng Li
	<wanpengli@tencent.com>
References: <20251110033232.12538-1-kernellwp@gmail.com>
 <20251110033232.12538-3-kernellwp@gmail.com>
 <015bfa4d-d89c-4d4e-be06-d6e46aec28cb@amd.com>
Content-Language: en-US
In-Reply-To: <015bfa4d-d89c-4d4e-be06-d6e46aec28cb@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB4C:EE_|BL1PR12MB5803:EE_
X-MS-Office365-Filtering-Correlation-Id: 0be8f29e-62cd-4b38-0204-08de21b6f803
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|82310400026|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bExTakdaNUdkNE1ZeVFxbTU1K0t4UHVFKzBlK1hSRTNtQ0loOU1LRlFGTzc0?=
 =?utf-8?B?dkhxRm5DWXdKTS8zM0JsQlp2MW8rNGRRZmQ2ZjVYLzRENVV4TDZMdFdnRGZU?=
 =?utf-8?B?eEg0Z3B2UTNGQmZGYjBPeW1iV296SWd1V3FyVkg4NmhVbzBibDhzbzJJK1Fz?=
 =?utf-8?B?SXBBT00rYXlXZ1BLaVBNTzJ6dDdHeGlIaEwwRlphcTB3cGdEdlNKL3VJalpk?=
 =?utf-8?B?TTE3dWs4Wk9KVGRmcURubUdTZlEybWNFaUJzeUxSN2VCZGtDeFNxSDFqU3Vp?=
 =?utf-8?B?NFJ6bXk4c2R2YVdIMTN0YmQvbElCaEdJK1lhM3EyNzJvdFlwV0FCUG9GT1Q2?=
 =?utf-8?B?VTh6ZDJEM1RYQXpVNWFReVlrMkw5YjRUL2VkZ1IxRlR2OHVrd245aDVCQ1Ux?=
 =?utf-8?B?aDZxc0ZJNVFGdldRc0lnZTBrNjVabWhETllmLzlPSmp2Y05uMW5yeUx1K0Rw?=
 =?utf-8?B?MTFaTFRvUHpQdXJaaC8xQTU5TVlRUUxFM3orejlUUXpCRDZyV2JCNVNhcjR0?=
 =?utf-8?B?MzNjYk9qQWRTUVlNSVprMGwzNVp0ODJKYU1vZHlFN2dGUGZ6cEtWZXZpTlYv?=
 =?utf-8?B?NzFlbS9rNFFyNU1XcTh1UW5rVEFpaEZINDBTMVZaN3NCeWJ2TVdENVRXdlh5?=
 =?utf-8?B?UEdLeXpUTVhpMGZGcHp5Y1V0dXhadUVhQUZMRjdIdm9nSDNnUTg0M242YlFK?=
 =?utf-8?B?RmNWZEpYT25vY1AwWkk0TVM1bS9ES3AxeG1LbkFxSkRPRWRiK05wdS9aSldT?=
 =?utf-8?B?VzVUNkJNZEpmUW12UVhaaUY4SnVkT3ZkQUJiQnlmbmh6MHZDZ0hZa3dkdW0y?=
 =?utf-8?B?RytMbGZuSUczeGV1eXRzN2VjcVlMTHZuTm1rVnh6blpOVERwbTN3YTRBSUgy?=
 =?utf-8?B?aWVTUENMZ0NLN2JmS1BqQjBnL1prWmw1OUcvRDl2Ny9XYmZwN1BTc3BEZHFi?=
 =?utf-8?B?OUxtdnZtMlRjb3EvajJTUEJpdk9rZHJha3ROUk1qZ1dnNnV1cWs0aHYzUkRP?=
 =?utf-8?B?NHZuSEtpY1VNd0J2WjNVRUhHS1dEMUVsWXo3Q3h3bUwyaSsrd2Z5bVVZRmR4?=
 =?utf-8?B?TVhsT0dLSFRJaVhjU0tJMzkya3NMczZaTzJvRkJsbFpnMmZQcW9Fd1lMWHBh?=
 =?utf-8?B?TSswNkV6Q05xdnVqTjhoVExzb1RxR3k0VXRBQ0ZUS1JFSnZCT0ViaHlKUUNF?=
 =?utf-8?B?eVFnVktWVVFsK2RVUFNHVjVtNUo5L1UrRzlUK09uVytQNUJMR2lWcGZWNEw0?=
 =?utf-8?B?bWk0WmdlNXBmcmh6NEtlNVN2ek8xMVJBWFVTczhMU3E4dDBFd0VWQTQrK0Yz?=
 =?utf-8?B?SDJiK1JKbXpyZ1Yxa3EvenhXNTA5VU02TkdVS2Fpdk9BZTMxbEtueEs4cnlB?=
 =?utf-8?B?WEsvSlpnSExad0haU1BrZm1kTGg3cmlBc2NIWHIrTGs5M25mQXF4RDcyOVRw?=
 =?utf-8?B?V1hXc21lNFhDUGR6ODlPcmU4LzkyTW5LK1NTeXpHM3dQbEJyOVN1L3NBNnY1?=
 =?utf-8?B?bzVVVnd2ZFlRd09tZFczOEtnUEVTYmdjdk1XMVRTWC9RTzkyL3oxbURzQUw3?=
 =?utf-8?B?VzRFUkQ0SW5odDlWRXdhRVNWbEladDB0ajhGdjc3MUZPYmc2QW5nRE9jTWd1?=
 =?utf-8?B?ckFjUFRQYkFnRHBscGNUMWtHUlI1Q083dWFtT0tkZHk4dTBIdnErTmcraTBk?=
 =?utf-8?B?NDhiMHFhM0NoMm9xOFd2YXlKcDA5OTNicTBsU0RsMEh5VldVeXdEc2ZORVVo?=
 =?utf-8?B?VWhvU1cvem1JL2tJSXVZWmEyZmRKWUl6dmV1cUxNVFpuam51UW5qQ2s1bXNF?=
 =?utf-8?B?NmErUkM3ZWZKb1dQOWtVMkpLT0lpc0ZGbDZ6NVdSd0RtWDVhNlpOeDFBdHNo?=
 =?utf-8?B?OWFUZlZxNmVKWGtaZzRoSFV0YitBWjluMmszR0I3WUFIYzB0cWxob0ZLQXFU?=
 =?utf-8?B?L1FDbjR5blQ4NDA2ZW5JdXUySk9CY1JLVXRZM1hCOFZtbnB4alhUMGc2MnRH?=
 =?utf-8?B?clJXU0l2VTlMRG0vNklnOC9UWW9qSkRDTUdHM3hFVlJhcXpPVEhiaVNMeTV1?=
 =?utf-8?B?N1lSc3owNHgyd1g4cHBqS3hScGhnQ0tMNnE3UT09?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(82310400026)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2025 06:44:46.1467
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0be8f29e-62cd-4b38-0204-08de21b6f803
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB4C.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5803

On 11/12/2025 12:10 PM, K Prateek Nayak wrote:
>> +	if (task_rq(p_yielding) != rq || task_rq(p_target) != rq)
> 
> yield_to() has already checked for this under double_rq_lock()
> so this too should be unnecessary.

nvm! We only check if the task_rq(p_target) is stable under the
rq_lock or not. Just checking "task_rq(p_target) != rq" should
be sufficient here.

-- 
Thanks and Regards,
Prateek


