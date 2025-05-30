Return-Path: <kvm+bounces-48095-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F0F5AC8BF5
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 12:14:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BA4761BA23D6
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 10:14:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D67C32222C3;
	Fri, 30 May 2025 10:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="JLFU45Ft"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2083.outbound.protection.outlook.com [40.107.220.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85DCE219A6B;
	Fri, 30 May 2025 10:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748600018; cv=fail; b=TCOt8ZpozW84V24TqYqTy1YBf3+6zYQear4AFHXY4JX2CLYAIr8cINueLT+RcqUbiqp20yOVBHmb+UDmKh8VZ3NhGaQ6QbGPavSLf1HtNNuImkHJKR7oWywMUyUzCDCOlLM6rJIOxnPP9xW+kk05XJxTbgnWUs1eetlSz8Uj52U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748600018; c=relaxed/simple;
	bh=iNML0atFvXPUPgCezVEszgygtwEVI/eatbKPi0H+oD0=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=MKvFWDmgTSLeXA2fjck4U8jy6uRYGrCIZflOnIg6J+d4OI/uERHXN6MULT25lr+wm7uZnhHmDJU0jyB0ZuRRk5EnrtRb7HEvHeIfthfuQtY3QMy+JEUoKh6aG4R6OBDsji20ClFKhj+rNjk4FTYfmxFHjobBpTn8RiA32JoppyM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=JLFU45Ft; arc=fail smtp.client-ip=40.107.220.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OOehag+Pj3qAEjwPOegAyV0wGg/v4Vcdg4zMoNxz6+/3ZhZ6n5jKieXA4xZrzXgOuKEpEr2RSnog4z2kXIZY/2vFPar/KVAGxOZiFHtzYXECHJgg7ggLjLgJDHuHSqX6mnMsSk3jH5vIQ/Cebv/P5e0/1AT9qFvQGvHTNGia9TM2nWiGbNJoU/xWRmMREtdR3yZI7WjoxrIDkV82L/gqLVRxGBy6CBdJhu89KnhB0z+gtdfXRgqT6OqMfaRbK9qIV5XNPPheHqhO4qPkXfX0If0qnVDJ/RNDUMiMW1QwIreKBAN/NyvoxcnTH6vnqdUqYj6uhC05n718TnYjYk1Unw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f7+gbaxTROaXOfg4lDayU1clmpb7CYOAPD2WsYDg8As=;
 b=zQx4eKAisDUaknKUYg5pQM4nNGeHuwXP4fN46JPneR9NCrRC7YLMpTPq5bl+9TbXNYRlM4/1YWzz7aIjzaOfK6rsk408MiRRxPCOLv0Nof7J76gizw1C04FPr6xjzC8Z+c3CwyyidkmH8cQNKUfWpLLGpLydDG2Aq+g2sEdLjTgaCE8EKJIliNBcB5ajLbhOV7P5Ofcb94pY2AabS1j2gKVecR7HMKTB6FBQ4ErEwV9VZToF4cESX8yEW2gv0Uyv6Aao0w3M+gxHuQZFDpejHLf6H2azcdgy5OjgCmtSkfQPM3mkNs6A+r1++3u/7Va64wdYwb+E83zu1mJiBMjNfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f7+gbaxTROaXOfg4lDayU1clmpb7CYOAPD2WsYDg8As=;
 b=JLFU45FtlHTHOeRUi4cCcITmKZt4eQCFfGmVfHCvhqwnGvZbS7i8I6Y2RsTsz4aCEAxRxxova43CLfg9SKDuKqFRKrXrWCD7f6IrZSJAq0Gk4PqpyXnGi7GagH1LraLi01n9t0eI8FNSh5+OH6rIzqE6Q1hjAczRBAPC31qsZMs=
Received: from CH0PR03CA0045.namprd03.prod.outlook.com (2603:10b6:610:b3::20)
 by CY8PR12MB8361.namprd12.prod.outlook.com (2603:10b6:930:7b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.27; Fri, 30 May
 2025 10:13:32 +0000
Received: from CH1PEPF0000AD7B.namprd04.prod.outlook.com
 (2603:10b6:610:b3:cafe::b) by CH0PR03CA0045.outlook.office365.com
 (2603:10b6:610:b3::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8769.22 via Frontend Transport; Fri,
 30 May 2025 10:13:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000AD7B.mail.protection.outlook.com (10.167.244.58) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8769.18 via Frontend Transport; Fri, 30 May 2025 10:13:32 +0000
Received: from [10.136.33.30] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 30 May
 2025 05:13:28 -0500
Message-ID: <9a64d394-e693-49fe-887b-3e4fa0f70878@amd.com>
Date: Fri, 30 May 2025 15:43:26 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 38/59] iommu/amd: KVM: SVM: Infer IsRun from validity
 of pCPU destination
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>, David Woodhouse
	<dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>
CC: <kvm@vger.kernel.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Vasant Hegde <vasant.hegde@amd.com>, "Maxim
 Levitsky" <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>, David Matlack
	<dmatlack@google.com>
References: <20250523010004.3240643-1-seanjc@google.com>
 <20250523010004.3240643-39-seanjc@google.com>
Content-Language: en-US
From: Sairaj Kodilkar <sarunkod@amd.com>
In-Reply-To: <20250523010004.3240643-39-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD7B:EE_|CY8PR12MB8361:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b11dd62-2949-4d3c-91b8-08dd9f62a184
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|7416014|36860700013|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aGVLWksxNUFOa2RQUWlVMUwxZkJmbHI0QS9pWkVEWE1sSmdNK3hVWWZDNmFp?=
 =?utf-8?B?WFc4S1NsOTlSUUVVM3N4WmZVWGt4SEl0WjFtMFZIK3dnWk9hUmg3VjhlS3pN?=
 =?utf-8?B?YXYxM3hZRUxjUWpBY2NhQXNnbWh1aHVhR1NPV0dPblc5UExDT3pUM2c2YXhE?=
 =?utf-8?B?YWdiaW9ERFNYL0hoVVpPTEN1a2JvZGRsNnJkZnlNZFdYdThCZnpzdjhjVWd4?=
 =?utf-8?B?QVJnZDk3dnhvdmtaWFUrTWdDd2MyYjgyc0hhVHdFOFp2YUFCdmhtaEdLdGNH?=
 =?utf-8?B?Yms2dUkwYmhlQ240Ujh0OGcrOEFlVE1FUHFoTmNSVmFyQ2RST0dYQ29xc1FK?=
 =?utf-8?B?aXJTM2I0QTR1bFh6VVFuVzBMb2pPb0ZjejBwU3VjMHgxcFliM3g4OXNTbUZv?=
 =?utf-8?B?UmlhMHhUVDc2UDdmNjBtVXFQajE0M3hNR2pubGs0eGx5aFFZODMxTTc4T2wv?=
 =?utf-8?B?Ky93bUYzbkVZN2hSRlQ3TVp1L1hoZFNmQ1hEdkhXaWJJOHMzN3dnR3VndE1P?=
 =?utf-8?B?cUR0dVd5K29KamV3TVVvMDY1eUJpY2UxMG5MYWxRZzJGOVVxZ05JY3JnRWxt?=
 =?utf-8?B?TnhKbytPTCs4cG1OZzhwSWUrZkl2Q2tTbnAwZ0M4NVVVeG1oOUxRVFBYdE92?=
 =?utf-8?B?elJ3dm9BV2RMc3VlNUFYL1ZYamVaMHovbzVaREdxOGRqM2F1NThpT1VzQzlu?=
 =?utf-8?B?TEFwMDM5ZG05Um8xZG9TSWFvR3hkdUZaTlN2Mkk2Tjh2NThVZFRFdjlwM2N1?=
 =?utf-8?B?QlJqZFZXaGJaR2tnWG1LYktkV0lwZkozTExDSkI2L3pIZUVJekczbm10N2RI?=
 =?utf-8?B?RlBTVC9ISWhSb3NPd0xUMVE0bXBwbU8wa3Q0Vi9Tb0xaRDMwWTJ2aTcvZFRY?=
 =?utf-8?B?ZUcyMmM4OWd3UHo1cGFUSS8yWEhPRHZMTE9GMkRXK3crOVI0YXFiYmZNNG9M?=
 =?utf-8?B?T1FiQlFvNWJuNUN4Uyt2T0pWV2F5WTFENnBSWHFiY0lWd2c0bUx5RmFiSkYx?=
 =?utf-8?B?MHB3U3NQYktBUGpQY0ZGcWFBTWNLbUkzM0VsS2h1aEgxdjFGTTVwS3JKLzBl?=
 =?utf-8?B?RzNSOEU0NkZjcGhOQm9HR2R6N2pXMzh1TDBlOTVLQ1I0MFdveFBMSmw0QnhS?=
 =?utf-8?B?WVV4SU9KR0dTekxRSzhYbFVIaml2T21iSEd1MnRrRERsWCs0UW5YYlBhS0Vj?=
 =?utf-8?B?ODAvZnFaS0hCNnlFUEtEM0JzSnQxMVB1SERSczFhR01Db2hBKzVMVHpSbVpX?=
 =?utf-8?B?UGZOSXhFcWRPN0pISFcvbjhySCs3dGtGUjBYdmpObERWR1ZnMWQ5VXBSbzNT?=
 =?utf-8?B?YWlxSFY5cDZ0QkcvTXByRkRnT1I1YWtrT2ppR2pnSzMySnJyZnZyR1BGcUlI?=
 =?utf-8?B?L1dkN0hvQUExWXpNQ0YwK3NPdjM4UGsrZEhNWlEvQXYyK3ZOSk1Ea3hnWEdK?=
 =?utf-8?B?SmpQeGFXdDhpWmdVWTBrcHhNMGxDTmtaM29td2s5YmtJaXREZ01TV0lpeUsy?=
 =?utf-8?B?ZEVkaCtZVXh3QWplWU8wQmt2S0hJNmJMcFdoSkZmZndzY1JjQU5MRmFDT0RT?=
 =?utf-8?B?VFhMcWFMcTYwL0pvRnV1ZU96ZFM5V002NWE0MmxlRFpzVnBrNDRNdjNkcDA0?=
 =?utf-8?B?ZEpSMm9hQ3hqQVlGTkdSS0p6Nk85SjJ0STJsSWlEeVNWa1RmNlFHZGo1ekVY?=
 =?utf-8?B?Q2xqZDFPeHZSOHFyNGM3SFNxd1k1S01XemlVdkdrcDVBaERQYkFSRVA1NHB0?=
 =?utf-8?B?Sm5QeTJ6NHJ5ZElPRFRUWDcwTVBFWENjRllNL0sxR25FWDRsVDNLbUxmMVZt?=
 =?utf-8?B?Z2dvaDhKZkw0WU03cXFEc3VxdkZtMGlzd3FjdFFCaVlYcm16clk4U2F3aGF3?=
 =?utf-8?B?bFdjenFMT3ZYc2QyMXVCbEhLVzNVeXBDTVh1VVQrSkZubFdvM2wyWkM5cXBn?=
 =?utf-8?B?clNjM1k0NEEyM0tMVmhUNzdjVmxUUm9UQzBzNFdtRk54V1hWN3JzNTlpODgx?=
 =?utf-8?B?Uk93VEtucjlObW9WMitXaFFKczVxQ0d0RzUzYS8wa0RkazhzZnc3SzNSVDhU?=
 =?utf-8?Q?7oAN76?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(7416014)(36860700013)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2025 10:13:32.1352
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b11dd62-2949-4d3c-91b8-08dd9f62a184
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD7B.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8361



On 5/23/2025 6:29 AM, Sean Christopherson wrote:
> Infer whether or not a vCPU should be marked running from the validity of
> the pCPU on which it is running.  amd_iommu_update_ga() already skips the
> IRTE update if the pCPU is invalid, i.e. passing %true for is_run with an
> invalid pCPU would be a blatant and egregrious KVM bug.
> 
> Tested-by: Sairaj Kodilkar <sarunkod@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/svm/avic.c   | 11 +++++------
>   drivers/iommu/amd/iommu.c | 14 +++++++++-----
>   include/linux/amd-iommu.h |  6 ++----
>   3 files changed, 16 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 4747fb09aca4..c79648d96752 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -832,7 +832,7 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
>   		entry = svm->avic_physical_id_entry;
>   		if (entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK)
>   			amd_iommu_update_ga(entry & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK,
> -					    true, pi_data.ir_data);
> +					    pi_data.ir_data);
>   
>   		irqfd->irq_bypass_data = pi_data.ir_data;
>   		list_add(&irqfd->vcpu_list, &svm->ir_list);
> @@ -841,8 +841,7 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
>   	return irq_set_vcpu_affinity(host_irq, NULL);
>   }
>   
> -static inline int
> -avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu, bool r)
> +static inline int avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu)
>   {

Hi sean

What if define cpu as "unsigned int" instead of "int" and use nr_cpu_ids
as invalid cpu id ? I see that it is common in the other subsystems to
use nr_cpu_ids instead of -1.

Thanks
Sairaj


