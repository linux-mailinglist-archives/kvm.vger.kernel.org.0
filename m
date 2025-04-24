Return-Path: <kvm+bounces-44064-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BF8AEA9A029
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 06:40:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 543F45A2567
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 04:40:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 180541C6FE7;
	Thu, 24 Apr 2025 04:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="u5+DPu8A"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2067.outbound.protection.outlook.com [40.107.92.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41ADA1B0420;
	Thu, 24 Apr 2025 04:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745469610; cv=fail; b=ecW+yAKnpe5GLlMTpYmkQN1fT1A9CrUSE3I8i1I72x7PI5Ui7gEGpPvAYC7gMkIr3pTqFGO4JcONqX53rXhnIp+E2BRbwhWahKNhA54Iz3rFOCLvCz5kB0uPUfIm68M13Y+l+LFVuIzF4LPW194rx3oSzUDJvogYclAl7yjFRh4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745469610; c=relaxed/simple;
	bh=SmKI3GfNez1nNaLZ5SOWrvgILQxTcAoDvJhanu+GTaY=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=YOGJdGSiHNaxpm3Ik7/6ZEdcydT2PPE3TfPlzSErhy5A5JExw5lyiaRfIiOtwinuJ7Cgphjzp7ylpcXHVEY9Zi/YGBkCO7MfHrd7HrYWKWSphUjbpj11Jx+CMxp4kQwXOG+uo2FWDmppbP2Flb0a9LIzHulreCBSqeUOHTyJTnI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=u5+DPu8A; arc=fail smtp.client-ip=40.107.92.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sl0tUyt4aDxjpglFd49NZRHpOa92LiNe6Z7yaMNyqABqu/uMgiKw+DIONPXx6rVmVHDCYVVkn1DJXpoYsz5GV3rgW0R1egBfYetJLOEcTg9HnwVTTefc8777l3f4Ih6XMg42y6p+v8blW2aQyHHOhuxOoJwDR+u7o48CGrXCb3XEmFCL1RrGvr84Yav7BI0mbyuR1eB6AH5YMzMnmpHD4k0Pwjw0wn/dbH6UhBSMODg5OpRco6/wnVQeFxux6NLEoQw/9PhBylz2+zf4Q7su7d1mTRbMYgImjaZi5IfB/pPsNKDJ0uHA0jr3kyCEdOJ1GhNv0kY/p5vr6Ue7CUeRHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6euvhKUaDaRGdDRW7q02t0Ih2rsnvPGUAq6hlzFwKZA=;
 b=jCzh5YS3S7cdJaWXgMCCpL8cg41iD9Dx6hYhfu9/rfOVyC1Gw38mnUVGvFgyWAcfWVtaeMKhLTustXMsSfp/iVcI2PFlEFvxdO7R1+lYZl9L3R/k8m9y2Y91d+QdXUWMPEeu65HCRnjJTQroeGi3yAeCXN3K/1KxpOset9jKDJswzslGObb0awlBMd8yb8Hurs8n123yv92urBThYhFTjO93P6CiY4q7TD0GeDyadtFYkBclGf8CQGJzyfEQQBrS93SE1qn2d0dsJR0YrB4He3kyDngCVN6UsIx2eFlWJ2qPKsj6OubEiHs6uM5sigw3k1Gow1Puw+jCZHEMMa8GOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6euvhKUaDaRGdDRW7q02t0Ih2rsnvPGUAq6hlzFwKZA=;
 b=u5+DPu8A9vb3U2czO0vbvqC6LlLcCk7EkHN9qiqhYf+6u16F8dudnTv9adRRjrWOrq/BubBVNXVey5y1dBa6Hk62ELVXLwyOBGWHwbfZ4svEaCz9reBgaa/HG7WEeE/RKGCf4uBMjIIMixwrsL5h758lyRF6UB86RZHAyfBb5bw=
Received: from SJ0PR13CA0184.namprd13.prod.outlook.com (2603:10b6:a03:2c3::9)
 by MW4PR12MB7016.namprd12.prod.outlook.com (2603:10b6:303:218::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.23; Thu, 24 Apr
 2025 04:40:00 +0000
Received: from SJ1PEPF00001CE1.namprd05.prod.outlook.com
 (2603:10b6:a03:2c3:cafe::aa) by SJ0PR13CA0184.outlook.office365.com
 (2603:10b6:a03:2c3::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.15 via Frontend Transport; Thu,
 24 Apr 2025 04:40:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CE1.mail.protection.outlook.com (10.167.242.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8655.12 via Frontend Transport; Thu, 24 Apr 2025 04:40:00 +0000
Received: from [10.85.41.53] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 23 Apr
 2025 23:39:56 -0500
Message-ID: <1fa0f7f8-be88-4617-a0b2-57d4204c6d6f@amd.com>
Date: Thu, 24 Apr 2025 10:09:49 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 33/67] KVM: x86: Dedup AVIC vs. PI code for identifying
 target vCPU
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>, David Woodhouse
	<dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>
CC: <kvm@vger.kernel.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Maxim Levitsky <mlevitsk@redhat.com>, Joao
 Martins <joao.m.martins@oracle.com>, David Matlack <dmatlack@google.com>
References: <20250404193923.1413163-1-seanjc@google.com>
 <20250404193923.1413163-34-seanjc@google.com>
Content-Language: en-US
From: Sairaj Kodilkar <sarunkod@amd.com>
In-Reply-To: <20250404193923.1413163-34-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE1:EE_|MW4PR12MB7016:EE_
X-MS-Office365-Filtering-Correlation-Id: dddddae9-5812-4185-52a7-08dd82ea12df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QXhZZDhZc3plTmppOURLeExFejZQdnF5NW1qdS9nR2ZEbEVZZFZPMDFnZUkx?=
 =?utf-8?B?UEs4a3ZldVNML0xOMFI2cC9XZkF5eWt3ZzVkY0ZROU9FdDArQTc2VXhuQk5n?=
 =?utf-8?B?NGJBcFdEcHJ0MVNXNHJxNDNxcUhCM29NanpwWW5MaDIxTnppeHV3ZDU1RUhr?=
 =?utf-8?B?LzA3bUM4UlpTZ2lzMERZU20zSjVnR3IwTE9kVXRWRDB1SE02TkxSSy82cDRj?=
 =?utf-8?B?SnZ4K25tbHVQYWFiTkVHdDR6ZGhVbFBjUHdHNmxsMDZvZjdacDh0R29HYUxl?=
 =?utf-8?B?dUhTeWtCSFkzYzJSbnBxRjRIdS8vbDJWakhWWUdzQVg2Q0MzdEVQZklNSGJE?=
 =?utf-8?B?dzArSjZ2S04zL3RCRUxQcU9LZko2ZnlwY1ExSDhHSVkxb3FaaUtIeGN1a2Yx?=
 =?utf-8?B?VzcvcGRiRjlaMXBUZkxiWGVJNUdybmVXb09BcjZ6UXB1RmpqekJzUnlIY0xl?=
 =?utf-8?B?YUY1VllHZ3JxSTlMTVhXWFZFT1NzUWNGeDU2bHYzRGttenBBWGFCK1ZtREtZ?=
 =?utf-8?B?N0Z6YW1ycEpDaXBnazZzVE9kTjRyaHBybGFkK2FNNTRERHhhZUtTWGFQNVZk?=
 =?utf-8?B?RGNHTXhzUHhQN2R4UU1Qek13L1llWVBCN0wwZUgwaDM1WXhNRnFJLzhjQ3Vo?=
 =?utf-8?B?djlKVitMNjBBZ09Ia1Jpc1ZEYzZKcHN3NkVUTGZvUlkxeGhlcGt4SUkzR1ls?=
 =?utf-8?B?dHBqeUJFZzJacE1sWUNXc1pXWWJSUHVSejY3WjhsSm5vQjJyL241R2c2TWZE?=
 =?utf-8?B?M29lQXhxNEM1RHNESi91TEFrWUxpVWxGdGRlZXh4Zlc1alJ0eEhlV1g5RUJO?=
 =?utf-8?B?YXdObXJnNkxDeGxybU9NaTRVMXRjdTRiN2RzS1VsS01nODE1ME9ScVRlaTVM?=
 =?utf-8?B?dFU0YStvVUFXaVhEZWtjQlBVRjNHdEdnWWtreWpReGlSNUc4NW1BWldzdlNU?=
 =?utf-8?B?aHdaV1gyQnNoTk54Sndtb1FlTXovdmxhZE9NMHQwbFN5bWI5cXNaUDgza2lp?=
 =?utf-8?B?ck1MbHhyU3EyV1BhTklhTjY5d0h6ZFFrVURJRjBFcmpTT1JNWkU0bmFYbFdh?=
 =?utf-8?B?N3BIcUJ5T1R3UHAvQUxZZUI3OFlHN3RFU1hTenNZNmFnNUh6Ky9IZXlTT2Ro?=
 =?utf-8?B?UmZnN2l3Wm5kYzBLbXlmUjkzRXRsOHducDd3SytvTjA0aDJRTk44QWNGVkdZ?=
 =?utf-8?B?ZGNsOU1IRDFURmhzbmpQSXFoZmN3Q3dUejgxL1Z6Ym1jSEp4a2h1WFQ4bHFo?=
 =?utf-8?B?c3VwV3YxQ2gyUklLQzgySXk0MWVvQ3FiSmNRTkZiMFdxVTVTNlNCOVhGcEFn?=
 =?utf-8?B?azN1Um14K2Q2S09vdm9qOXhHelhjcmk0VEpyS1VnTGdHNy9JS3FoTzh4ajJt?=
 =?utf-8?B?NkVYREJzWWhCc3JRK2dFVmxYY1RkdkFCYlFTVCtCbkVKbStJMk5QWnFENXdX?=
 =?utf-8?B?Ui9ZY1c4SFdOZEQ0Qld5RFZVbm1pRlJOOWRmcEpRUTlYaG9YOHg3cWZUNGxQ?=
 =?utf-8?B?cUxIQ0dMczZXR2ZaT1JGUGZXUzM4U05WNnI1RGg5aEpodFpjSnBTSnRhYWxk?=
 =?utf-8?B?N25kTUR5anhIL1hkVEF4M0gvTnpRbDA0Z09SSjJDUnQyS2RsTmZNcFBYM1Bi?=
 =?utf-8?B?RzRuUXVXUG9DeWl2YjR6bWNQSEVzTW16MkRqQjRmWk9OT3hKZ0NtYndSU2hT?=
 =?utf-8?B?dDJVS1ptdHg3ejFDWGw2VXFXbmJtYnEwUGhBcEY0cEhuUm1neG9UcVZqdTFh?=
 =?utf-8?B?QVJEUERZbEtINHR1M0dqckVGTTB6cmhwVkFKeC9pUFREOGtMVjF6NjJGVlJz?=
 =?utf-8?B?Q041OEkzVWk4b2d1aEFzcTIxOUpmTnNMelNXazBiSlFZaXpoVGZ1azlHUDBj?=
 =?utf-8?B?L2hDVkxRU29zSHVhdTIydVplMXlEN2JDZDI0YmZ4VmthcG1vanI4Mm9Jckxx?=
 =?utf-8?B?c2t4VVY5OGJGbDZzNWxxVWlSeXdnYTRZYVE0Z3dPUm9mUEJScTJtRUN5cU5W?=
 =?utf-8?B?eVl6Y05Md1lkcW5yN3Y3RXBIc3BWUGhxQVRkOGZ2ZGcyZXRueE03Tlp6c3VE?=
 =?utf-8?Q?rIjire?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2025 04:40:00.5343
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dddddae9-5812-4185-52a7-08dd82ea12df
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7016

On 4/5/2025 1:08 AM, Sean Christopherson wrote:
> Hoist the logic for identifying the target vCPU for a posted interrupt
> into common x86.  The code is functionally identical between Intel and
> AMD.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/include/asm/kvm_host.h |  3 +-
>   arch/x86/kvm/svm/avic.c         | 83 ++++++++-------------------------
>   arch/x86/kvm/svm/svm.h          |  3 +-
>   arch/x86/kvm/vmx/posted_intr.c  | 56 ++++++----------------
>   arch/x86/kvm/vmx/posted_intr.h  |  3 +-
>   arch/x86/kvm/x86.c              | 46 +++++++++++++++---
>   6 files changed, 81 insertions(+), 113 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 85f45fc5156d..cb98d8d3c6c2 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1838,7 +1838,8 @@ struct kvm_x86_ops {
>   
>   	int (*pi_update_irte)(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
>   			      unsigned int host_irq, uint32_t guest_irq,
> -			      struct kvm_kernel_irq_routing_entry *new);
> +			      struct kvm_kernel_irq_routing_entry *new,
> +			      struct kvm_vcpu *vcpu, u32 vector);
>   	void (*pi_start_assignment)(struct kvm *kvm);
>   	void (*apicv_pre_state_restore)(struct kvm_vcpu *vcpu);
>   	void (*apicv_post_state_restore)(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index ea6eae72b941..666f518340a7 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -812,52 +812,13 @@ static int svm_ir_list_add(struct vcpu_svm *svm,
>   	return 0;
>   }
>   
> -/*
> - * Note:
> - * The HW cannot support posting multicast/broadcast
> - * interrupts to a vCPU. So, we still use legacy interrupt
> - * remapping for these kind of interrupts.
> - *
> - * For lowest-priority interrupts, we only support
> - * those with single CPU as the destination, e.g. user
> - * configures the interrupts via /proc/irq or uses
> - * irqbalance to make the interrupts single-CPU.
> - */
> -static int
> -get_pi_vcpu_info(struct kvm *kvm, struct kvm_kernel_irq_routing_entry *e,
> -		 struct vcpu_data *vcpu_info, struct kvm_vcpu **vcpu)
> -{
> -	struct kvm_lapic_irq irq;
> -	*vcpu = NULL;
> -
> -	kvm_set_msi_irq(kvm, e, &irq);
> -
> -	if (!kvm_intr_is_single_vcpu(kvm, &irq, vcpu) ||
> -	    !kvm_irq_is_postable(&irq)) {
> -		pr_debug("SVM: %s: use legacy intr remap mode for irq %u\n",
> -			 __func__, irq.vector);
> -		return -1;
> -	}
> -
> -	pr_debug("SVM: %s: use GA mode for irq %u\n", __func__,
> -		 irq.vector);
> -	vcpu_info->vector = irq.vector;
> -
> -	return 0;
> -}
> -
>   int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
>   			unsigned int host_irq, uint32_t guest_irq,
> -			struct kvm_kernel_irq_routing_entry *new)
> +			struct kvm_kernel_irq_routing_entry *new,
> +			struct kvm_vcpu *vcpu, u32 vector)
>   {
> -	bool enable_remapped_mode = true;
> -	struct vcpu_data vcpu_info;
> -	struct kvm_vcpu *vcpu = NULL;
>   	int ret = 0;
>   
> -	if (!kvm_arch_has_assigned_device(kvm) || !kvm_arch_has_irq_bypass())
> -		return 0;
> -
>   	/*
>   	 * If the IRQ was affined to a different vCPU, remove the IRTE metadata
>   	 * from the *previous* vCPU's list.
> @@ -865,7 +826,7 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
>   	svm_ir_list_del(irqfd);
>   
>   	pr_debug("SVM: %s: host_irq=%#x, guest_irq=%#x, set=%#x\n",
> -		 __func__, host_irq, guest_irq, !!new);
> +		 __func__, host_irq, guest_irq, !!vcpu);
>   
>   	/**
>   	 * Here, we setup with legacy mode in the following cases:
> @@ -874,23 +835,23 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
>   	 * 3. APIC virtualization is disabled for the vcpu.
>   	 * 4. IRQ has incompatible delivery mode (SMI, INIT, etc)
>   	 */
> -	if (new && new && new->type == KVM_IRQ_ROUTING_MSI &&
> -	    !get_pi_vcpu_info(kvm, new, &vcpu_info, &vcpu) &&
> -	    kvm_vcpu_apicv_active(vcpu)) {
> -		struct amd_iommu_pi_data pi;
> -
> -		enable_remapped_mode = false;
> -
> -		vcpu_info.pi_desc_addr = avic_get_backing_page_address(to_svm(vcpu));
> -
> +	if (vcpu && kvm_vcpu_apicv_active(vcpu)) {
>   		/*
>   		 * Try to enable guest_mode in IRTE.  Note, the address
>   		 * of the vCPU's AVIC backing page is passed to the
>   		 * IOMMU via vcpu_info->pi_desc_addr.
>   		 */
> -		pi.ga_tag = AVIC_GATAG(to_kvm_svm(kvm)->avic_vm_id, vcpu->vcpu_id);
> -		pi.is_guest_mode = true;
> -		pi.vcpu_data = &vcpu_info;
> +		struct vcpu_data vcpu_info = {
> +			.pi_desc_addr = avic_get_backing_page_address(to_svm(vcpu)),
> +			.vector = vector,
> +		};
> +
> +		struct amd_iommu_pi_data pi = {
> +			.ga_tag = AVIC_GATAG(to_kvm_svm(kvm)->avic_vm_id, vcpu->vcpu_id),
> +			.is_guest_mode = true,
> +			.vcpu_data = &vcpu_info,
> +		};
> +
>   		ret = irq_set_vcpu_affinity(host_irq, &pi);
>   
>   		/**
> @@ -902,12 +863,11 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
>   		 */
>   		if (!ret)
>   			ret = svm_ir_list_add(to_svm(vcpu), irqfd, &pi);
> -	}
>   
> -	if (!ret && vcpu) {
> -		trace_kvm_pi_irte_update(host_irq, vcpu->vcpu_id,
> -					 guest_irq, vcpu_info.vector,
> -					 vcpu_info.pi_desc_addr, !!new);
> +		trace_kvm_pi_irte_update(host_irq, vcpu->vcpu_id, guest_irq,
> +					 vector, vcpu_info.pi_desc_addr, true);
> +	} else {
> +		ret = irq_set_vcpu_affinity(host_irq, NULL);
>   	}
>   
>   	if (ret < 0) {
> @@ -915,10 +875,7 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
>   		goto out;
>   	}
>   
> -	if (enable_remapped_mode)
> -		ret = irq_set_vcpu_affinity(host_irq, NULL);
> -	else
> -		ret = 0;
> +	ret = 0;
>   out:
>   	return ret;
>   }
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 6ad0aa86f78d..5ce240085ee0 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -741,7 +741,8 @@ void avic_apicv_post_state_restore(struct kvm_vcpu *vcpu);
>   void avic_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu);
>   int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
>   			unsigned int host_irq, uint32_t guest_irq,
> -			struct kvm_kernel_irq_routing_entry *new);
> +			struct kvm_kernel_irq_routing_entry *new,
> +			struct kvm_vcpu *vcpu, u32 vector);
>   void avic_vcpu_blocking(struct kvm_vcpu *vcpu);
>   void avic_vcpu_unblocking(struct kvm_vcpu *vcpu);
>   void avic_ring_doorbell(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
> index 786912cee3f8..fd5f6a125614 100644
> --- a/arch/x86/kvm/vmx/posted_intr.c
> +++ b/arch/x86/kvm/vmx/posted_intr.c
> @@ -266,46 +266,20 @@ void vmx_pi_start_assignment(struct kvm *kvm)
>   
>   int vmx_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
>   		       unsigned int host_irq, uint32_t guest_irq,
> -		       struct kvm_kernel_irq_routing_entry *new)
> +		       struct kvm_kernel_irq_routing_entry *new,
> +		       struct kvm_vcpu *vcpu, u32 vector)
>   {
> -	struct kvm_lapic_irq irq;
> -	struct kvm_vcpu *vcpu;
> -	struct vcpu_data vcpu_info;
> -
> -	if (!vmx_can_use_vtd_pi(kvm))
> -		return 0;
> -
> -	/*
> -	 * VT-d PI cannot support posting multicast/broadcast
> -	 * interrupts to a vCPU, we still use interrupt remapping
> -	 * for these kind of interrupts.
> -	 *
> -	 * For lowest-priority interrupts, we only support
> -	 * those with single CPU as the destination, e.g. user
> -	 * configures the interrupts via /proc/irq or uses
> -	 * irqbalance to make the interrupts single-CPU.
> -	 *
> -	 * We will support full lowest-priority interrupt later.
> -	 *
> -	 * In addition, we can only inject generic interrupts using
> -	 * the PI mechanism, refuse to route others through it.
> -	 */
> -	if (!new || new->type != KVM_IRQ_ROUTING_MSI)
> -		goto do_remapping;
> -
> -	kvm_set_msi_irq(kvm, new, &irq);
> -
> -	if (!kvm_intr_is_single_vcpu(kvm, &irq, &vcpu) ||
> -	    !kvm_irq_is_postable(&irq))
> -		goto do_remapping;
> -
> -	vcpu_info.pi_desc_addr = __pa(vcpu_to_pi_desc(vcpu));
> -	vcpu_info.vector = irq.vector;
> -
> -	trace_kvm_pi_irte_update(host_irq, vcpu->vcpu_id, guest_irq,
> -				 vcpu_info.vector, vcpu_info.pi_desc_addr, true);
> -
> -	return irq_set_vcpu_affinity(host_irq, &vcpu_info);
> -do_remapping:
> -	return irq_set_vcpu_affinity(host_irq, NULL);
> +	if (vcpu) {
> +		struct vcpu_data vcpu_info = {
> +			.pi_desc_addr = __pa(vcpu_to_pi_desc(vcpu)),
> +			.vector = vector,
> +		};
> +
> +		trace_kvm_pi_irte_update(host_irq, vcpu->vcpu_id, guest_irq,
> +					 vcpu_info.vector, vcpu_info.pi_desc_addr, true);
> +
> +		return irq_set_vcpu_affinity(host_irq, &vcpu_info);
> +	} else {
> +		return irq_set_vcpu_affinity(host_irq, NULL);
> +	}
>   }
> diff --git a/arch/x86/kvm/vmx/posted_intr.h b/arch/x86/kvm/vmx/posted_intr.h
> index a586d6aaf862..ee3e19e976ac 100644
> --- a/arch/x86/kvm/vmx/posted_intr.h
> +++ b/arch/x86/kvm/vmx/posted_intr.h
> @@ -15,7 +15,8 @@ void __init pi_init_cpu(int cpu);
>   bool pi_has_pending_interrupt(struct kvm_vcpu *vcpu);
>   int vmx_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
>   		       unsigned int host_irq, uint32_t guest_irq,
> -		       struct kvm_kernel_irq_routing_entry *new);
> +		       struct kvm_kernel_irq_routing_entry *new,
> +		       struct kvm_vcpu *vcpu, u32 vector);
>   void vmx_pi_start_assignment(struct kvm *kvm);
>   
>   static inline int pi_find_highest_vector(struct pi_desc *pi_desc)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b8b259847d05..0ab818bba743 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -13567,6 +13567,43 @@ bool kvm_arch_has_irq_bypass(void)
>   }
>   EXPORT_SYMBOL_GPL(kvm_arch_has_irq_bypass);
>   
> +static int kvm_pi_update_irte(struct kvm_kernel_irqfd *irqfd,
> +			      struct kvm_kernel_irq_routing_entry *old,

the argument 'old' is redundant in this function.

Regards
Sairaj Kodilkar

> +			      struct kvm_kernel_irq_routing_entry *new)
> +{
> +	struct kvm *kvm = irqfd->kvm;
> +	struct kvm_vcpu *vcpu = NULL;
> +	struct kvm_lapic_irq irq;
> +
> +	if (!irqchip_in_kernel(kvm) ||
> +	    !kvm_arch_has_irq_bypass() ||
> +	    !kvm_arch_has_assigned_device(kvm))
> +		return 0;
> +
> +	if (new && new->type == KVM_IRQ_ROUTING_MSI) {
> +		kvm_set_msi_irq(kvm, new, &irq);
> +
> +		/*
> +		 * Force remapped mode if hardware doesn't support posting the
> +		 * virtual interrupt to a vCPU.  Only IRQs are postable (NMIs,
> +		 * SMIs, etc. are not), and neither AMD nor Intel IOMMUs support
> +		 * posting multicast/broadcast IRQs.  If the interrupt can't be
> +		 * posted, the device MSI needs to be routed to the host so that
> +		 * the guest's desired interrupt can be synthesized by KVM.
> +		 *
> +		 * This means that KVM can only post lowest-priority interrupts
> +		 * if they have a single CPU as the destination, e.g. only if
> +		 * the guest has affined the interrupt to a single vCPU.
> +		 */
> +		if (!kvm_intr_is_single_vcpu(kvm, &irq, &vcpu) ||
> +		    !kvm_irq_is_postable(&irq))
> +			vcpu = NULL;
> +	}
> +
> +	return kvm_x86_call(pi_update_irte)(irqfd, irqfd->kvm, irqfd->producer->irq,
> +					    irqfd->gsi, new, vcpu, irq.vector);
> +}
> +
>   int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *cons,
>   				      struct irq_bypass_producer *prod)
>   {
> @@ -13581,8 +13618,7 @@ int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *cons,
>   	irqfd->producer = prod;
>   
>   	if (irqfd->irq_entry.type == KVM_IRQ_ROUTING_MSI) {
> -		ret = kvm_x86_call(pi_update_irte)(irqfd, irqfd->kvm, prod->irq,
> -						   irqfd->gsi, &irqfd->irq_entry);
> +		ret = kvm_pi_update_irte(irqfd, NULL, &irqfd->irq_entry);
>   		if (ret)
>   			kvm_arch_end_assignment(irqfd->kvm);
>   	}
> @@ -13610,8 +13646,7 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
>   	spin_lock_irq(&kvm->irqfds.lock);
>   
>   	if (irqfd->irq_entry.type == KVM_IRQ_ROUTING_MSI) {
> -		ret = kvm_x86_call(pi_update_irte)(irqfd, irqfd->kvm, prod->irq,
> -						   irqfd->gsi, NULL);
> +		ret = kvm_pi_update_irte(irqfd, &irqfd->irq_entry, NULL);
>   		if (ret)
>   			pr_info("irq bypass consumer (token %p) unregistration fails: %d\n",
>   				irqfd->consumer.token, ret);
> @@ -13628,8 +13663,7 @@ int kvm_arch_update_irqfd_routing(struct kvm_kernel_irqfd *irqfd,
>   				  struct kvm_kernel_irq_routing_entry *old,
>   				  struct kvm_kernel_irq_routing_entry *new)
>   {
> -	return kvm_x86_call(pi_update_irte)(irqfd, irqfd->kvm, irqfd->producer->irq,
> -					    irqfd->gsi, new);
> +	return kvm_pi_update_irte(irqfd, old, new);
>   }
>   
>   bool kvm_arch_irqfd_route_changed(struct kvm_kernel_irq_routing_entry *old,


