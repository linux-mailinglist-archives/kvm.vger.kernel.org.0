Return-Path: <kvm+bounces-63181-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 3847CC5B7FB
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 07:19:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 1413D4E42CD
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 06:19:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7D5B2EBB8F;
	Fri, 14 Nov 2025 06:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Rw8vPHr3"
X-Original-To: kvm@vger.kernel.org
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010037.outbound.protection.outlook.com [40.93.198.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF2C1EDA2B;
	Fri, 14 Nov 2025 06:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763101186; cv=fail; b=BSj/jEfgDMv8YdQxzk3KALW3+lA+7YObTv+A05lcX8ijlPwyHicHC1N2FpXXuBXAanQ0BGY6NlWg137WyvuccyLbp15Ut5oSyIry2QwXqD/r7zJtnkfqnocOb9V2AB9jNbhlHWw70czEjqa36IrjCZxY8CdTsRU5t1EIuHGJeK0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763101186; c=relaxed/simple;
	bh=LJjpujdKKNydWOOsi4NYg9QKP06hnwA4DscVAyPUMdQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=O89hbULIEcAtOkUI2HlbOJBETgGhGIYJ2g8JWOQiWaXG+iNgo+Z88BPFAFo40KiGBcsRsHDWfWw8EVt5BlYFhFmeDzzrqrds/16ox+IU0V7vfebNgSVv5NV9JU0P8INeU5erfyPhP99qbHN/SBJiaOBuvx9b7hSEIjDfQ7ckAQQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Rw8vPHr3; arc=fail smtp.client-ip=40.93.198.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bawfsQ1j8r5AhLTdx89qIuG6ZbuTlRsKHGXKZeSY2hiF9xyJdbA/aHdC2UQzpIukAY4rw1jX3M0sSRfK7zC/BkPEqRAFPyIqgCF09imI6S93J3DBJHbYcc7QAohmjcbRPx7J3a34uLkrOF8wqoNiV61VYSjd+tCyTONTYWySbPO3Oo3W1AYbSzStV4JvHBocyKyDUzoFZd0t40ed9c98Cg9r8m7VxPom2n9ciE/jb747vRhyUopLEzXpDRl7QItC6YD5B3WZLKDCrfT7ySB9mZfZXWq7d+yMgtNrCDUBH9HGeo9jqYsF7bv4uIUjK3cPmE3kRV9xovZFROSGFyq0rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BlY0JjOFu+SpS7sZ5ysQugPxTdZPr6s6LuborW5uUCU=;
 b=Mm9E/LZ9cgEc8HcTnZCePJuxpWOeXltXGHA19Qzt5zOoMEzna5i0rpBo1L1VBfJl5Hra43Tf7KR9WKzmrZSvCer8h+FBZxeVf7gJe3GYXYWJ0lTVIW8PYikFM7ycT6B+6ybO9XkKm+VrMwv0+APmVll7/EXg7UV+/j0IWO02QI81ve2NxzDHE3vW8uCRYcvvFLdaoRJgbNm7KJ3ttKIGDGvZYJm+Qro12Zdq63sQTjdZiVi9mRn46Gjkga2K8h74wVxWjUW0yrhTtRn8GKXcZbXXuvfHcs7oyzZS+1/1U0FzdITlf/Rr0AWpQjj1l9fmEITKwY5a2RKoevfSYqL8FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BlY0JjOFu+SpS7sZ5ysQugPxTdZPr6s6LuborW5uUCU=;
 b=Rw8vPHr3RRaGwTmewqYz/uxJEdmH8J8tQtFv6PsKAlScL3nIDaaooAEpk2DqsR1nwz+iqG6DCg7wdkLTycKFAxYAuI7HfJgx3GM/vv12ddFinS52nSesZUVjuTfBykCEsLuURlvbbLqxK2oDF9Egf0n9FPwhii0Z7+LszonZkxg=
Received: from BYAPR08CA0031.namprd08.prod.outlook.com (2603:10b6:a03:100::44)
 by SA3PR12MB9158.namprd12.prod.outlook.com (2603:10b6:806:380::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.15; Fri, 14 Nov
 2025 06:19:40 +0000
Received: from MWH0EPF000A6730.namprd04.prod.outlook.com
 (2603:10b6:a03:100:cafe::e2) by BYAPR08CA0031.outlook.office365.com
 (2603:10b6:a03:100::44) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9320.17 via Frontend Transport; Fri,
 14 Nov 2025 06:19:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 MWH0EPF000A6730.mail.protection.outlook.com (10.167.249.22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.13 via Frontend Transport; Fri, 14 Nov 2025 06:19:39 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 13 Nov
 2025 22:19:38 -0800
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 13 Nov
 2025 22:19:38 -0800
Received: from [10.252.219.240] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Thu, 13 Nov 2025 22:19:31 -0800
Message-ID: <780ec006-ca77-40bc-ae9e-8ed0ec093dc5@amd.com>
Date: Fri, 14 Nov 2025 11:49:30 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 44/44] KVM: x86/pmu: Elide WRMSRs when loading guest
 PMCs if values already match
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao
	<zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, Huacai Chen
	<chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, Paul Walmsley
	<paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou
	<aou@eecs.berkeley.edu>, Xin Li <xin@zytor.com>, "H. Peter Anvin"
	<hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra
	<peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, "Arnaldo Carvalho de
 Melo" <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, Paolo Bonzini
	<pbonzini@redhat.com>
CC: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<kvm@vger.kernel.org>, <loongarch@lists.linux.dev>,
	<kvm-riscv@lists.infradead.org>, <linux-riscv@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <linux-perf-users@vger.kernel.org>, Kan Liang
	<kan.liang@linux.intel.com>, Yongwei Ma <yongwei.ma@intel.com>, Mingwei Zhang
	<mizhang@google.com>, Xiong Zhang <xiong.y.zhang@linux.intel.com>, "Sandipan
 Das" <sandipan.das@amd.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>
References: <20250806195706.1650976-1-seanjc@google.com>
 <20250806195706.1650976-45-seanjc@google.com>
Content-Language: en-US
From: Manali Shukla <manali.shukla@amd.com>
In-Reply-To: <20250806195706.1650976-45-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6730:EE_|SA3PR12MB9158:EE_
X-MS-Office365-Filtering-Correlation-Id: 7bae66b6-14ce-4d0f-b4e5-08de2345cad1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|7416014|1800799024|7053199007|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VUNpOGpobXdNZkx3NEhVcE9relBCUVBnbXF0aTI0UUJJVVY4b1RPdXZiVS9T?=
 =?utf-8?B?aklXTkcvTGNuZmlNYTdpZHg2TDF4eG5nMFRVd1NiQ2hpQm5RWXkzcHBXQmJ2?=
 =?utf-8?B?N1pDS3llZ2N4SnZPWUFMcEc3cStuT2dZdmZNSlgyNjZhZjhiejRUYjlrWmFJ?=
 =?utf-8?B?UnBITDRCdjdoU2U3bnFJRG4yMmR2T0hjcU1GT2tvVVlrVG1TeXZKVG1kdVMx?=
 =?utf-8?B?dkk0TlBxcmErcGtSUmdhZzE5WnRlcnFnOS9jZStpQzJBWkNJVmlwUXFMeFhx?=
 =?utf-8?B?KzNjQVVjSXMwWW42RWZuZ3J4NUNBaHBRNDNKUVVUS0FEblpBT1Q2TVo2bEZ6?=
 =?utf-8?B?amxlbytYRkI5UHE1UXpTYVk0QTVlOFcwQkc0ckRJM1RNeG9xZkYrVmtrTUhl?=
 =?utf-8?B?TVMwS0RVd2dRQjVYWE5RUXNTWjdPcDNZSW56eXJGR3VtZjhxOWR5REppSWJS?=
 =?utf-8?B?NHFOblVUT09UVkd1dDBDaXE1VmV2TW5mazd2L0pzd2tYT0I3SnBCUGJIN1pJ?=
 =?utf-8?B?dzVCL1N0QmNUUlE1bWxYdXZrSmhPZENKbWFIcS9wWHRMQ2xEbitPVU9GWjZB?=
 =?utf-8?B?NkpaeTRJVUoxTytJN2xQSXVEVUZHQ3JQU3I4WlhUUFE0NUNtNlJ3cWRZSUpi?=
 =?utf-8?B?OEZXUGZ4V0xOVVJra1p3ZlJrbTJpUDE2WlZodEdMbEljaGNpK1RSd0ZTUGw1?=
 =?utf-8?B?b1k0c1BLUjBuU0kya0V2NTdRMkJSWTdlRzNNUVk3SFZzYkg1OWw0a0t0VmQv?=
 =?utf-8?B?aXV2MUp3RytBRjR0M2w4T2xBcmxON1pYWENIK2hVWlRWRWJWRHkxVVRNZVR6?=
 =?utf-8?B?STVrakVkMlV6L2t2Q2RXOG5SR2dWdVIrUFFjck9iR2xKUkdRZXBraG1MWEZi?=
 =?utf-8?B?NkpFQlVzTXBjUlNiQUcxK25ZSWc2dDVsMVVYSEk0blkzUWtnWVh5a2QzaHNy?=
 =?utf-8?B?TDlWa3pQcVpmT3lNR3FVakNEdndTK1ROYW1iL0N4b0lBN2dSQVgzalA4SHI5?=
 =?utf-8?B?SlhBTldRWGlWOXBYRjBiVWZmald3L2FkSmprWEdnb3lPQlJHOU9PM1FsclRK?=
 =?utf-8?B?MlVQazZ2T25FendnRlJBemo1M0lCZm1OT2lvbVVJdGVnOGVzY2poTUlyeFlR?=
 =?utf-8?B?Q0xaTjZKamZ3b2VvanlvNVFVMVVBMVlqVTAzUmFncnoxMFVUd3RGQVdYT3Ex?=
 =?utf-8?B?eE8xUFk1Mk95VldjK2txcVBaVm1wTzk5bnMvYTU1SEpucnl3QlEzOGJ4MXly?=
 =?utf-8?B?OWw3SDN6RXREVndSRHoxRHJVK0VhelZXS2kvNytldFRTTVJsSEhld3p1V0Jq?=
 =?utf-8?B?UGFtMmwxM0NVOTl3WGt5ejd5bzFNb2FVUFhFZGhmR3VhYWY2TitwQlgxT05y?=
 =?utf-8?B?MzBxQVZRa1JaQjlKbjhiak15Wm5mMGtEWFVicWZWZFUyUS9saFJldG9QTzM4?=
 =?utf-8?B?RGJQSTFFOE5SMkJLRkJjNlRQTDBZOGljOE1BdXh6S2tNK2g1T3BSLytEcUNZ?=
 =?utf-8?B?NnRxaUd4dW9vRDAxMVpmQnRJVGxmMjNoZFhKeWh1ZjBLYXNKbGN3a1lYTEFz?=
 =?utf-8?B?bVgwSjcvNGZOdFhEMlNlYmkxS0NNeEo0Yi9MRFEwMHdLclJjMzFmcmhWOWFo?=
 =?utf-8?B?SEVuN2lyMzhveUdpNldYV2ZEaUtEY1l6QUd1Nndsbm54THFEVXEvSWxhZ1ll?=
 =?utf-8?B?YTE2OHBuVG1TL0VFUHdKOElEQnFDWE9SWVJ6WHRyTzNPS1hvU0dEVUZjb0tU?=
 =?utf-8?B?dDd0dTB3NkF0S0s4ZVpwb0dHL0ZtekRrOEF1dlZKc0ZEUUR2elUyZVVWLzBm?=
 =?utf-8?B?aXR2SUhDaUc5cy92Z3JtRU41MFk4NFZmdEU4TnF6d3NXQmNCNDh6SmVxY25D?=
 =?utf-8?B?UkxRRTFBaXhyYzNNQUlUUmJlcDR0MHB2N1FmMTMxTm90UE1Zd3EwMmVyMjJP?=
 =?utf-8?B?NGhZVHJUcnRqeCtZZTVOaWNkVUtLVng4b2VhZzluR1FHTE1NYlVzakdyTDVu?=
 =?utf-8?B?MCtwM2lCVVZBMmdGclAvL0ltNWZRSFpwY3VLZEdLMmpLRmlPUkZnMUIyK1Ax?=
 =?utf-8?B?STBFdzVyUkJUcXFXazRvL1JUdGczdSswTGZLYW40ckJqQWpWSVdobHhuRDF1?=
 =?utf-8?Q?KFiy63jKx4vPBSIhvOwkZIh/n?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(7416014)(1800799024)(7053199007)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2025 06:19:39.4251
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bae66b6-14ce-4d0f-b4e5-08de2345cad1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6730.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9158

On 8/7/2025 1:27 AM, Sean Christopherson wrote:
> When loading a mediated PMU state, elide the WRMSRs to load PMCs with the
> guest's value if the value in hardware already matches the guest's value.
> For the relatively common case where neither the guest nor the host is
> actively using the PMU, i.e. when all/many counters are '0', eliding the
> WRMSRs reduces the latency of handling VM-Exit by a measurable amount
> (WRMSR is significantly more expensive than RDPMC).
> 
> As measured by KVM-Unit-Tests' CPUID VM-Exit testcase, this provides a
> a ~25% reduction in latency (4k => 3k cycles) on Intel Emerald Rapids,
> and a ~13% reduction (6.2k => 5.3k cycles) on AMD Turing.

Nit. s/AMD Turing/AMD Turin

-Manali
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

