Return-Path: <kvm+bounces-43140-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF735A855CE
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 09:48:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7522D7A6A47
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 07:47:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EDB228F931;
	Fri, 11 Apr 2025 07:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="NDwuxaWp"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2048.outbound.protection.outlook.com [40.107.220.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA44F1CEACB;
	Fri, 11 Apr 2025 07:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744357693; cv=fail; b=A0t/XRalXUQjjCRx1OYV+qB/1nTH3Mh1lwjld/RZI+vXWbkOolQqdgvyAslnM4mrBvLHjS7DiKKFOWptLgQSdL8Hc/WV3Jrafd+pJsrQV173FZA+SylihH+eP5wOjvrDhz/GNABJQR0DGknjzr8gsYJGpFyErsLOXnopxcelUrg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744357693; c=relaxed/simple;
	bh=dxxwTqZ0pmoA55d3YDPX0Z8GV1YM16E4aAa074wyacs=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=WC7xPregKoZV3oy6PD6aUXuAQxMFNi4MjD4/nmn1ErbkUvWuVJYToMdg71ld80UXjhUuUWlecBuOmx+2YL7brfPTd3TV4xg/e2lR4fSy7zLiw9VlR1EsoMMKo58mH/67taoHS99t1Zc5OTZyTaQ0GPIomPcAVhvt+uO0XZPME/g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=NDwuxaWp; arc=fail smtp.client-ip=40.107.220.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uAHAFvqaUN9e44EMhkDr6QqHTq92bo7I0yFytDd+C1gr3jwplrB0tDt4s8f4NgzorTZpRQRKfE8d9LVjJ4X71BTVny0GyJnobqC+uY6GTF8caNT1cID9UClikPgMZoot/XaMbG5XTZt1uVCdRL6s+Vd5fJQqbTJ5AZqF+z+kE27VbkBPku/gLAqKmQjlmP6oC4Qo3xhQmSwMxNqJh674/QnvAq6swV+Q4b+YMmiGvdGMM7Hc4zEvfaZUAohNzLmF5B1F6+9S6iIEhXwJmccWKCoYufpuMH0oI1Paprvruw68GnSThR9tcI7NQTFMk4BWIcwAN6krVndPwf4tZkX6bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9oqrF0dTSsULB44KUI7GFe0malehQY0HMNPfTYLPDNI=;
 b=lOSHyKryZkSvz7J2/rxJ7zJiEYAYLSloSZsTPgSTy4VDEXOh208gKO0AgH/yM0GfYok0EexNTf/XZENSR96Ystpdllw2wpYtEA4keLbIr8shtCV+djTQEiKCr1Lcr0toQ4rQnW+cKnUArHAeL2/Jfn2ikuTu6GPMAUrhohir4a95j3o8PF+Hd+WAZzDTibTeX54ggStyQkljySHHDlfqr7geX9Y8w+hRnlMiVXBM6rJYAQbiWWQ5BznhEHPY924T+uRDo62LJ/D2ZVuxMqYxkPMz0jThGJvlKICjUsfn6rrGMxA5vk51KoGLJn9hgV6nMTUxkTlHF8nGmqPocx3z0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9oqrF0dTSsULB44KUI7GFe0malehQY0HMNPfTYLPDNI=;
 b=NDwuxaWp7uOx+F1opW4jMvjscRHNLSreY/c2LxUHKyxk3p4Or71qOgpf7VQ5gL1JsQawjnPaak+lhZ53167JBSDLw5JqO9jBeAFX9g+AVvpW10UJrWFrsPtzJbagyGtjzWePhm2wVSFEu8U+pkr5T9Zblh52WI0Yq96LJ13q7fM=
Received: from BY3PR05CA0049.namprd05.prod.outlook.com (2603:10b6:a03:39b::24)
 by DS7PR12MB5981.namprd12.prod.outlook.com (2603:10b6:8:7c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.23; Fri, 11 Apr
 2025 07:48:07 +0000
Received: from SJ5PEPF000001CF.namprd05.prod.outlook.com
 (2603:10b6:a03:39b:cafe::fb) by BY3PR05CA0049.outlook.office365.com
 (2603:10b6:a03:39b::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8632.19 via Frontend Transport; Fri,
 11 Apr 2025 07:48:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001CF.mail.protection.outlook.com (10.167.242.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8632.13 via Frontend Transport; Fri, 11 Apr 2025 07:48:07 +0000
Received: from [10.136.43.133] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 11 Apr
 2025 02:48:03 -0500
Message-ID: <d6ccf531-2ed0-4e38-97a5-2b747497fadb@amd.com>
Date: Fri, 11 Apr 2025 13:17:53 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/67] KVM: SVM: Track per-vCPU IRTEs using
 kvm_kernel_irqfd structure
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>, David Woodhouse
	<dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>
CC: <kvm@vger.kernel.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Maxim Levitsky <mlevitsk@redhat.com>, Joao
 Martins <joao.m.martins@oracle.com>, David Matlack <dmatlack@google.com>
References: <20250404193923.1413163-1-seanjc@google.com>
 <20250404193923.1413163-10-seanjc@google.com>
Content-Language: en-US
From: "Arun Kodilkar, Sairaj" <sarunkod@amd.com>
In-Reply-To: <20250404193923.1413163-10-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CF:EE_|DS7PR12MB5981:EE_
X-MS-Office365-Filtering-Correlation-Id: f535272b-858a-4683-327b-08dd78cd32c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UTM4RVlLamtoaUZpVFArRWR4WGxCS2lSUlgvZ0tvTERWL0JUa3kzMWlGblpK?=
 =?utf-8?B?VzcxWGRIMWlSNkdZMy9aaHR5UWduSTRSM3pEdm1oMFQweGFsTGlkcUovZzI3?=
 =?utf-8?B?dGVHZGZLM3VIZnZVRUl5NkRiN1pvN3FMV2JlQWJCREluSktSeFRnMk9RNzlV?=
 =?utf-8?B?cVk5SVk1a0xsWERlV0JIOXM5TzFvV1FFSVhhcVByUHpzQk90YmQyeG01ck92?=
 =?utf-8?B?MDVWbkMrcVl4YlErUGFpRm03SDN4V2tJTUdycytzRUZ5SGgxeTA5SmJyVmdw?=
 =?utf-8?B?Mk1ydlBuVk5qdWVMMHNuV29TMFRzT0R2MkFldm9SM2xPOXdDSE5GMVBITTUr?=
 =?utf-8?B?eWx4Ky9DZUZoVHdxc0ZMRDVzMllpWU1mWDEzd2hBRTBNY2UydFMyUEZud1c4?=
 =?utf-8?B?WFNTc20vTFY5MVRDMVFhUzQ4dEtRZC9GNHhiMDgyN3Fjdk5YT1FSK1I5OVRu?=
 =?utf-8?B?RndSZndOaVg1bG4ydUlrMEIyRDBnVzdjb0FwK3lpc3dLZE9Va1hmL0JFV1lx?=
 =?utf-8?B?ZzE4aSszYXc5RXZ1eUVyaDBsd3VnaWErUDhWRkl0bTh3SDRkOFBLUVc0U2ly?=
 =?utf-8?B?cDZybTJZNDEyempVWHNYamc4TkE5UGhNQnhENWtHNDU3Ukp0cGFjRW9YR1R2?=
 =?utf-8?B?MlN3YW5JMC9IQjFQbTV0c1U3aW5EeFBBNXJ6aXFWRGVSeURwUThyUjJDQ0Zn?=
 =?utf-8?B?a1cwdUhVa0FGZncyT09jQVRiRVFwV2lWVXdRb0Q1enBxejhnZ0p1T0ZUTmNB?=
 =?utf-8?B?QlJQanU2aEY3SHZ0Z0JYdjE5UmJzWFg4cGNhTVh1aUxiUVh1WEoydkd5Nk9Y?=
 =?utf-8?B?VE1sczMwQ0hKdURGaG9UUGZlbkRXUkMrcGJCS1hxdGdMTjh3eDRMeElTY3N2?=
 =?utf-8?B?WDJOcHJhUHcwbHlPTE5QZVFrSGhkZitFWUFGYlNQZE9odmMxczBxMVRmOWsv?=
 =?utf-8?B?dC8rc2R4TE1XMCtSYXpnVzlyZVVvSVlMZVZ5R2RJWFM4RGZDR3c5c3pTcVhQ?=
 =?utf-8?B?NThOUU04RTVsRjZkV3hablFNZDRZc1lmT29QTGFiU0REaUtBb1pRS2s5TWkr?=
 =?utf-8?B?YzNrQUVTSGM4L0ppbUdGR05wQjB6bGhQNUdodVArUEJDVm5leFg0akx6M05o?=
 =?utf-8?B?NFRmUk02SmZoZUZybWJBNU1OeXQxU2Vndy9oeUxVV0pxWmlTd1djMFN4czNm?=
 =?utf-8?B?K00wSCtjOW9LNjQrU3B1SDBHL2p6TDRyTEJxcThqYUhScHRZWnBzaHJRYnJw?=
 =?utf-8?B?Q2w0dUwrSWFNS2ZKZ2R5RXBENTlwMU52TC96cU9OT2RjaDl1Tkx6ZWUxeFhB?=
 =?utf-8?B?WnlKQlFnODV6S0NMQ0pjcGpNMDZZaGFCT2hxcWlnYi94REdZWXowUUpjdzlk?=
 =?utf-8?B?c3g4NVRCMDliZU1hbjBhb21ha1pJZklxTFFTdmQ4aGRqMGxUSXZYcUVjTVMr?=
 =?utf-8?B?eTJsWmNnem1pUmZaQ2cvU2Q0MHhDVVBRQmlueVgvdG90cFdOcGlESWZGL1VS?=
 =?utf-8?B?L1Y1dXJMejhOMVpGM0RWNGtuejg1b2o1eUlBVkovVm9nSmJZbWtKdFlGNW9O?=
 =?utf-8?B?UG55dWFIeUJNMGVxUXlHcVZtTVM4aklma1htcTVZaFhMeUN4VHBHODBDNVd4?=
 =?utf-8?B?WDhQc0Jzd2E3aXkxM0UyV1lYU013V3h2RDhicWtZWlRtRFlDaFlJRlp3cmFo?=
 =?utf-8?B?cC80Ui9kdGxQNU9penI0NmwzOTJma0crU2l0TmZzNW5YMmxPS0xVa3UyTHVV?=
 =?utf-8?B?cVIxZFBpSXBmQWpUcFJoUkJtTzZqc1REV0o3cXE1a2s1ZTBuTmk4dnJTUC94?=
 =?utf-8?B?NjVqYm5wYWFDMi9vL0RIVEJCSlZMTnFvSmVUMWdFUkVyS3pPNXdhUGsyUkkw?=
 =?utf-8?B?V3JrQjI5VHdmakFOQ2RFR2FIeFRSeURGbkthT20rNnFOcHFIYzZlVWwybjA5?=
 =?utf-8?B?K29oLzNwblVxaGk5angvQnRmVkhTRVkvdVF3b2QyYWM2OEgrbTBXTzdXSFpP?=
 =?utf-8?B?akJ6TnRSZzB5eXJPVHQ1TWR2ZEk4bkEvMUlVNGJtSDJoSkNNU0xSWk9yTFVQ?=
 =?utf-8?Q?AEXANV?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2025 07:48:07.0157
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f535272b-858a-4683-327b-08dd78cd32c0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5981

On 4/5/2025 1:08 AM, Sean Christopherson wrote:
> Track the IRTEs that are posting to an SVM vCPU via the associated irqfd
> structure and GSI routing instead of dynamically allocating a separate
> data structure.  In addition to eliminating an atomic allocation, this
> will allow hoisting much of the IRTE update logic to common x86.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/svm/avic.c   | 49 ++++++++++++++++-----------------------
>   include/linux/kvm_irqfd.h |  3 +++
>   2 files changed, 23 insertions(+), 29 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 04dfd898ea8d..967618ba743a 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -774,27 +774,30 @@ static int avic_set_pi_irte_mode(struct kvm_vcpu *vcpu, bool activate)
>   	return ret;
>   }
>   
> -static void svm_ir_list_del(struct vcpu_svm *svm, struct amd_iommu_pi_data *pi)
> +static void svm_ir_list_del(struct vcpu_svm *svm,
> +			    struct kvm_kernel_irqfd *irqfd,
> +			    struct amd_iommu_pi_data *pi)
>   {
>   	unsigned long flags;
> -	struct amd_svm_iommu_ir *cur;
> +	struct kvm_kernel_irqfd *cur;
>   
>   	spin_lock_irqsave(&svm->ir_list_lock, flags);
> -	list_for_each_entry(cur, &svm->ir_list, node) {
> -		if (cur->data != pi->ir_data)
> +	list_for_each_entry(cur, &svm->ir_list, vcpu_list) {
> +		if (cur->irq_bypass_data != pi->ir_data)
>   			continue;
> -		list_del(&cur->node);
> -		kfree(cur);
> +		if (WARN_ON_ONCE(cur != irqfd))
> +			continue;
> +		list_del(&irqfd->vcpu_list);
>   		break;
>   	}
>   	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
>   }
>   
> -static int svm_ir_list_add(struct vcpu_svm *svm, struct amd_iommu_pi_data *pi)
> +static int svm_ir_list_add(struct vcpu_svm *svm,
> +			   struct kvm_kernel_irqfd *irqfd,
> +			   struct amd_iommu_pi_data *pi)
>   {
> -	int ret = 0;
>   	unsigned long flags;
> -	struct amd_svm_iommu_ir *ir;
>   	u64 entry;
>   
>   	if (WARN_ON_ONCE(!pi->ir_data))
> @@ -811,25 +814,14 @@ static int svm_ir_list_add(struct vcpu_svm *svm, struct amd_iommu_pi_data *pi)
>   		struct kvm_vcpu *prev_vcpu = kvm_get_vcpu_by_id(kvm, vcpu_id);
>   		struct vcpu_svm *prev_svm;
>   
> -		if (!prev_vcpu) {
> -			ret = -EINVAL;
> -			goto out;
> -		}
> +		if (!prev_vcpu)
> +			return -EINVAL;
>   
>   		prev_svm = to_svm(prev_vcpu);
> -		svm_ir_list_del(prev_svm, pi);
> +		svm_ir_list_del(prev_svm, irqfd, pi);
>   	}
>   
> -	/**
> -	 * Allocating new amd_iommu_pi_data, which will get
> -	 * add to the per-vcpu ir_list.
> -	 */
> -	ir = kzalloc(sizeof(struct amd_svm_iommu_ir), GFP_ATOMIC | __GFP_ACCOUNT);
> -	if (!ir) {
> -		ret = -ENOMEM;
> -		goto out;
> -	}
> -	ir->data = pi->ir_data;
> +	irqfd->irq_bypass_data = pi->ir_data;
>   
>   	spin_lock_irqsave(&svm->ir_list_lock, flags);
>   
> @@ -844,10 +836,9 @@ static int svm_ir_list_add(struct vcpu_svm *svm, struct amd_iommu_pi_data *pi)
>   		amd_iommu_update_ga(entry & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK,
>   				    true, pi->ir_data);
>   
> -	list_add(&ir->node, &svm->ir_list);
> +	list_add(&irqfd->vcpu_list, &svm->ir_list);
>   	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
> -out:
> -	return ret;
> +	return 0;
>   }
>   
>   /*
> @@ -951,7 +942,7 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
>   			 * scheduling information in IOMMU irte.
>   			 */
>   			if (!ret && pi.is_guest_mode)
> -				svm_ir_list_add(svm, &pi);
> +				svm_ir_list_add(svm, irqfd, &pi);
>   		}
>   
>   		if (!ret && svm) {
> @@ -991,7 +982,7 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
>   
>   			vcpu = kvm_get_vcpu_by_id(kvm, id);
>   			if (vcpu)
> -				svm_ir_list_del(to_svm(vcpu), &pi);
> +				svm_ir_list_del(to_svm(vcpu), irqfd, &pi);
>   		}
>   	} else {
>   		ret = 0;
> diff --git a/include/linux/kvm_irqfd.h b/include/linux/kvm_irqfd.h
> index 8ad43692e3bb..6510a48e62aa 100644
> --- a/include/linux/kvm_irqfd.h
> +++ b/include/linux/kvm_irqfd.h
> @@ -59,6 +59,9 @@ struct kvm_kernel_irqfd {
>   	struct work_struct shutdown;
>   	struct irq_bypass_consumer consumer;
>   	struct irq_bypass_producer *producer;
> +
> +	struct list_head vcpu_list;
> +	void *irq_bypass_data;
>   };
>   
>   #endif /* __LINUX_KVM_IRQFD_H */

Hi Sean,
You missed to update the functions avic_set_pi_irte_mode and
avic_update_iommu_vcpu_affinity, which iterate over the ir_list.

Regards
Sairaj Kodilkar

