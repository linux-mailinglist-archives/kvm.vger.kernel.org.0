Return-Path: <kvm+bounces-66242-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B9B3BCCB290
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 10:25:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8362B30285F1
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 09:19:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81618331A44;
	Thu, 18 Dec 2025 09:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Hfca2GaE"
X-Original-To: kvm@vger.kernel.org
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012041.outbound.protection.outlook.com [52.101.43.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B3392F1FFA;
	Thu, 18 Dec 2025 09:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766049591; cv=fail; b=kKOgo4Vmfj58Vg73SxV2Vgizca3PYRKI+B+x2w49l1E//1imf/R55bzIJmd/9mwpXqBQfIpRmCWVAjP4d4Y9KN6FFBHKhieCJCiuR9dnisNn6eciUUrrfC55lEeOravugu17lYzAidRn6h5Y75geQwhNvOyZN+kqDNgITtL/ZoQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766049591; c=relaxed/simple;
	bh=pN5birVFswPGyzmDY5oz4guB9UfDnAgE2zKYmBvkdgM=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=YGBh/Aln2OSdOszBuNOKza5CXyn31qlF9LBwKhS3/oPMW8VGkMHgP2KrqBJWJburoyh1T5w73j7b49hSZDLZW+HEpT1oCgGIiy4mbTRElnivzOoekvtvM+YDKZrh0PwPcUx2zwp2gkpfgB0u/GimFP8tTaW39p9dIzmo9wgFYeQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Hfca2GaE; arc=fail smtp.client-ip=52.101.43.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ObSM2vFi2L84I782WDo3/oqfIAZOO/FEW/IZVO7Z0BrzGODJ3zZXj35hH3m0Q5eDLgrYajmxgnTlp/mnYa3LRAnhj3gMidJafFN2f19oz0BXGVM6uk9bhkZN+T/7DUKrT+NW1uNt87YhJ0QVFnyxI8UvEO0PyFn26jco2lc/vXITI7/wg2Yq0ZaHBVbpmjp9mcbsMS7+BYUV7Mmd6TcQ/BL1MJQhDubunTB8wAq6cDky/b5ct7YsO2/mPqp77diLj42QrfnGHR5XuHxF1Xi83TUUPzfhyyXWycNdqGt8Qc0qpFlEbg4368OLYJ0pNITk38qtqh9tbI/vazIlpmPLHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OqMOpAN9R5MslrgIqeQxp1PVShpqEea3zlFkjgV7CRw=;
 b=KKm78j/aICLbDwzsLmtvOQmDWfBKhGCFly9KhL82JAvGWfI0c8do6201FBBHN8vjabTlfUipzD/iTOO0XzgO59w/9h3Xog5F2HRCZWObRj+XWq1IhwIfYppGuO/BnJ6jzMvNPq7s21cvx4NIDltrYelJMeTYE/TNgu3hmLvImlk72d+MjuXrRrNQNTOvJHYHDYj2E51VNY5iiYhD+B5g+BKxe1vIWEGFD8aIOpDsU68UkTeGqqOcNepCVQrSFKcShlzRLDTKWmQ+axTN9sdt9fLyak0W400HUU/oUkSSCa4oClYOxPiXDDvLdV8T6ezhOTDdHaTGuHw+5FUAiaUt8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=infradead.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OqMOpAN9R5MslrgIqeQxp1PVShpqEea3zlFkjgV7CRw=;
 b=Hfca2GaE2BibD/dqKPoeJNWHS/QK3M0fLjsWgl8E6Dzmo+k7x8CZ8F94nitFi2mEPOYi5DzFGvry3y4egJh8Th+VRUVDDWn2HdZTbu3NfxP7rIW3bZYWQqnm6dJeUAeB5OgI5e+rVNNg24bK1T+7pnDhhofggZ8KkUyMatmjfjs=
Received: from BLAPR03CA0011.namprd03.prod.outlook.com (2603:10b6:208:32b::16)
 by DS7PR12MB8371.namprd12.prod.outlook.com (2603:10b6:8:e9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Thu, 18 Dec
 2025 09:19:45 +0000
Received: from BL6PEPF0001AB72.namprd02.prod.outlook.com
 (2603:10b6:208:32b:cafe::95) by BLAPR03CA0011.outlook.office365.com
 (2603:10b6:208:32b::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6 via Frontend Transport; Thu,
 18 Dec 2025 09:19:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF0001AB72.mail.protection.outlook.com (10.167.242.165) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9412.4 via Frontend Transport; Thu, 18 Dec 2025 09:19:45 +0000
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 18 Dec
 2025 03:19:42 -0600
Received: from [10.252.198.192] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Thu, 18 Dec 2025 03:19:35 -0600
Message-ID: <f6408786-8b40-4ded-8a20-307fe0133e98@amd.com>
Date: Thu, 18 Dec 2025 14:49:34 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 00/44] KVM: x86: Add support for mediated vPMUs
To: Peter Zijlstra <peterz@infradead.org>, Sean Christopherson
	<seanjc@google.com>
CC: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, "Tianrui
 Zhao" <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, Huacai Chen
	<chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, Paul Walmsley
	<pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou
	<aou@eecs.berkeley.edu>, Xin Li <xin@zytor.com>, "H. Peter Anvin"
	<hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Ingo Molnar
	<mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim
	<namhyung@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	<linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<kvm@vger.kernel.org>, <loongarch@lists.linux.dev>,
	<kvm-riscv@lists.infradead.org>, <linux-riscv@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <linux-perf-users@vger.kernel.org>, "Mingwei
 Zhang" <mizhang@google.com>, Xudong Hao <xudong.hao@intel.com>, Sandipan Das
	<sandipan.das@amd.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, Xiong Zhang
	<xiong.y.zhang@linux.intel.com>, Jim Mattson <jmattson@google.com>
References: <20251206001720.468579-1-seanjc@google.com>
 <20251208153738.GC3707837@noisy.programming.kicks-ass.net>
Content-Language: en-US
From: Manali Shukla <manali.shukla@amd.com>
In-Reply-To: <20251208153738.GC3707837@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB72:EE_|DS7PR12MB8371:EE_
X-MS-Office365-Filtering-Correlation-Id: d67c9980-5904-4dbe-4d1a-08de3e16957a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QzlMeThiMnRmb2k1VE13NWtoR2ZsaThSaENWdkpMWHNmd1FuTnNJYWYxY1RM?=
 =?utf-8?B?b2kxbGxTRWZhMnh6U01EN05TbVRjeXphWERrbEJTbHhmbHhkNitzazJZS2dZ?=
 =?utf-8?B?NmtzeXRYY0g0T1VZNVBZanJ2NUllSVRNcUp0ZXNtTTRJVHcyblJLUUthK1Rw?=
 =?utf-8?B?bHZ4ejhkdzU5SGtUeUVtTkViQjV6bVYxaitqK2JRNXlweW1sUW42OEp4RlUz?=
 =?utf-8?B?UHJMeEN1NmxZTk9Qem9oNEY5TnRTL0ZJSVM2NXdzcVBPSW43VDFlMkdxQm5i?=
 =?utf-8?B?ck9Qc1pLOEJ4MEljRnI4VERuNmh2TjI0WmZiaGZPQUJaWVdRNlE4cmdpNjlp?=
 =?utf-8?B?cFZRNWZHQW5jcDRZN1FmRVBSMlY3QmVlRmloWHp2K0F5YmJsRHF5amxWVjRj?=
 =?utf-8?B?eHM2YTBxWDMwSmRlYVRRaW9BSDkyazlpaFZ1b3h6L1hJbks4MklnaDhZZWxS?=
 =?utf-8?B?UGlZaUFCbUJHZEpUSERCM1lJdXR0eElwWE1xSDhkR3J6Z1pqM3JwQytkS2JE?=
 =?utf-8?B?WGU5dmFvMTFWVmJ1aGRGSFRZdnJZaGdNelpUSDQyUW5BK09UODErN3JUNzk2?=
 =?utf-8?B?dlFaTDcvUHBMQi9aZ1Q0citQSk9SYVhOZG1zRk10V1o2WGZ5U3p0SUFhejQ4?=
 =?utf-8?B?OVFtT292TFdLZUxrQTU1eU9Sc1ZTdHdUSkNFbndwQ3FKR3h2WUkyTlZQdnI5?=
 =?utf-8?B?ZHZJSVBNTTRncWZPNFJBUC9LNUprdVR0c1ptWW9BTExlMEgzZU52MTJuRmpD?=
 =?utf-8?B?SjZ4VGVGT2hPdktXZ1pIc2VVVTlJZjUxWlBRWWhiSlNIVDE1ZG9RRm92Tytz?=
 =?utf-8?B?L0h1QXNtdjhoc2JIMHZwcXZkM1FtbndSMWpBcnEzVHMrY1dybnowcFNuT285?=
 =?utf-8?B?NHVpcUgvSWVrTEhrcE95c1Z2ZWt6SWhCUFdIYi90cVFCTHVtaHhlR1I3a1kx?=
 =?utf-8?B?ODI4MCtzWWtaTWdxMzV3QXRZOHFYbW5mT1haM3RLUkdUUlFiclpkaVcxUG56?=
 =?utf-8?B?TzFWN0I5UFdXMld4N3NkdXkrc1Q3QkxtTjBydUZ6MzhacTdRMnhuTHlEN1M2?=
 =?utf-8?B?eWtnV3AzVG40ODJrYlc2L1V1TkNPNEhSSy9QazRhU1VFRHdFT2hEUHRXVEJH?=
 =?utf-8?B?UWFpWE5ZenB0WW9aMkZ4ZFNFeFJ6QW5uSUt4aFBuVzRPelEvR2NYc0FDUXMx?=
 =?utf-8?B?b25jbXl2OEloaWpUNlVoNUZFUkxNaFllQzlKbXQ4WUo4bFo1eG83VEtIb1JF?=
 =?utf-8?B?RElDWmtUalZjRENjcDd4ZU9iR0hnMytySnMwUVk1Z2JqdEhZVVRLbk5YaDVx?=
 =?utf-8?B?WWNiMUNvN1k5OGlnMGk0MGdFSGxEVnpoZzBSWHN3UFNWbTg4V2ErYVRyQTVx?=
 =?utf-8?B?dFhkYmE3c0RTTkVtUXBjREpWMCs0cFVlanNwQjlGb3h3NzNjaGV2YWhHRWJi?=
 =?utf-8?B?U0NFcVdNcGUxQUhDeXZZR3BUS0J4MDJhK0pVbVlvOWU2dXJQWXJTRm1BbXV1?=
 =?utf-8?B?RlgvbFptSzJsMWU3SndUZm5MczZ0QUxWNVBqQndHVFM2YjhlaVlPZHcrcFBU?=
 =?utf-8?B?MnRjV3M0MjZjd2l1Q0FtTUppRXBob0Q2dXQ3a3hhS1g5WC9wV3hVZjJ5T1R0?=
 =?utf-8?B?NVVQcHRmUmFkQ0xsRWN1MjVjckpJbEZ4TUJoNEl3aUM3bURwR2JHTDlWOGx3?=
 =?utf-8?B?Q1gxaitqV2E1eWR0L3docnZmK0x3cHgwQm1pOVkwS1NWQ2VHcFc3bUk0cGo5?=
 =?utf-8?B?dXNDcmRNOFVBcjlVVmhoNjZoZENtMjdkdmIzb2sxdFJKVUc3UDlUclpFQlhz?=
 =?utf-8?B?R0hab1dsbGhWMkkyWFZhWXFUMHJ5dTZWdjl0OGllTXBkeUpHaUxVYVBHK0d6?=
 =?utf-8?B?ekhoTUFFNStSZkF2aTNSQ2ViK2gvcWZMYjVkQTQwdGZrUSt3cFBpaUdHVDBK?=
 =?utf-8?B?cnhJVnFvUGUyT0NQL2RhNFFaalJkSS8zTHNGc2ZGOE1ONThaandGSERYUzJS?=
 =?utf-8?B?WGJMQXNqNnZHdXJyejNTU1J6ZVBMc2NmNE1xZUwxQ3haNGpaNmdvSHZpbElX?=
 =?utf-8?B?SDVPRFRibkRpWGRVWDJmUVMwcnB6M2lWNUlIVjRFaWt4aEFaY3dzZWZNWWxq?=
 =?utf-8?Q?ZL6E=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2025 09:19:45.0846
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d67c9980-5904-4dbe-4d1a-08de3e16957a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB72.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8371

On 12/8/2025 9:07 PM, Peter Zijlstra wrote:
> On Fri, Dec 05, 2025 at 04:16:36PM -0800, Sean Christopherson wrote:
>> My hope/plan is that the perf changes will go through the tip tree with a
>> stable tag/branch, and the KVM changes will go the kvm-x86 tree.
> 
>> Kan Liang (7):
>>   perf: Skip pmu_ctx based on event_type
>>   perf: Add generic exclude_guest support
>>   perf: Add APIs to create/release mediated guest vPMUs
>>   perf: Clean up perf ctx time
>>   perf: Add a EVENT_GUEST flag
>>   perf: Add APIs to load/put guest mediated PMU context
>>   perf/x86/intel: Support PERF_PMU_CAP_MEDIATED_VPMU
>>
>> Mingwei Zhang (3):
>>   perf/x86/core: Plumb mediated PMU capability from x86_pmu to
>>     x86_pmu_cap
>>
>> Sandipan Das (3):
>>   perf/x86/core: Do not set bit width for unavailable counters
>>   perf/x86/amd: Support PERF_PMU_CAP_MEDIATED_VPMU for AMD host
>>
>> Sean Christopherson (19):
>>   perf: Move security_perf_event_free() call to __free_event()
>>   perf/x86/core: Register a new vector for handling mediated guest PMIs
>>   perf/x86/core: Add APIs to switch to/from mediated PMI vector (for
>>     KVM)
> 
> That all looks to be in decent shape; lets go get this merged. There is
> the nit on patch 4 and I think a number of the exports want to be
> EXPORT_SYMBOL_FOR_KVM() instead, but we can do that on top.
> 
> I'll queue these patches after rc1.

I have tested this series on AMD EPYC 9745 (Turin, 128-Core Processor)
with 12 hours of perf_fuzzer runs across multiple configurations. No new
failures were observed.

Test Platform:
--------------
Hardware: AMD EPYC 9745 128-Core Processor (Turin)
Test Duration: 12 hours of perf_fuzzer per configuration

Configuration 1: enable_mediated_pmu=Y
---------------------------------------
SVM guests:
  -cpu host
  -cpu host,-perfmon-v2
  -cpu host,-perfctr-core

SEV-ES guest:
  -cpu host

SEV-SNP guest:
  -cpu host

Configuration 2: enable_mediated_pmu=N
---------------------------------------
SVM guest:
  -cpu EPYC-Genoa-v2,+pmu
  -cpu EPYC-Genoa-v2,+pmu,-perfmon-v2
  -cpu EPYC-Genoa-v2,+pmu,-perfctr-core

SEV-ES guest:
  -cpu EPYC-Genoa-v2,+pmu

SEV-SNP guest:
  -cpu EPYC-Genoa-v2,+pmu

KVM Unit Tests (KUT):
---------------------
Tested all combinations of:
  - enable_mediated_pmu={0,1}
  - force_emulation_prefix={0,1}

CPU configurations tested:
  -cpu host
  -cpu host,-perfmon-v2
  -cpu host,-perfctr-core

All KUT tests passed as expected across all combinations.

Tested-by: Manali Shukla <manali.shukla@amd.com>

-Manali


