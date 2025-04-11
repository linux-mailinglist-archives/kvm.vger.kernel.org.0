Return-Path: <kvm+bounces-43141-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 81553A85634
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 10:09:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7304B1BA3B9E
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 08:09:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17B3727E1CB;
	Fri, 11 Apr 2025 08:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="zYpf7eoN"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2086.outbound.protection.outlook.com [40.107.94.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA6B27D762;
	Fri, 11 Apr 2025 08:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744358937; cv=fail; b=A1iwpqoMZTvLEysHvavSmtBefP/H8kuClRsO7krhOAu6WbLjBzccoMASHkwktXb3zt+uVKRn48iHkZZkw8lxb7U2dEiCM5Rw7xmrsv7yQhfPNxZeFmZ3E3avjktq0dou+mJh66zbUijr26NIPMrLrbB2WyAf9HVc/ya7J/I/Ii4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744358937; c=relaxed/simple;
	bh=MHlit6uVYXuh/xLFO2jgCee6PY9ySUZ/ShZHf32uRmo=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=uRDqEVFDY2TwquGCNXJ7VQkH6vd+XQWntPsoRJnJdqRXJoRxwj7PGA0jknml7Z1Bu4olYRbqGL6+GZtxp3Xh04LsF4isHH9AIC37XHVsrDChlAXYq0jvJ8ucmcacNTIKKIOaYtF74mX4t8PN92Z6VtYQQJfPR0NVcmU+KE44dmU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=zYpf7eoN; arc=fail smtp.client-ip=40.107.94.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y0+7ru82KkkKbdfb8vNbehhpnegCKn8l7DANpM7WSS150qcFRD2j9mlxDI5jlZw+D0o/rmLyaRlbZ8pOk7afaNd2VGB8a9rrp7bqvCthJlfn3weqKLWzbImvNSm6mBU1VfzpRy8nsjvRAc48NTxS2pxKq92WGKrgTEhRH5YAFHz5b21FtdRVIqJ7ypex56H79n55W000Qv6kmkJRdZYXoIVLBfmm1sNIIfvRYMSddyCbJV7KuFW2jTiGJ++W/wau7YGBO85lCcts0uB64iO4oa2AWcknC9Ul0UO5yCHzv7D8CwgRVvWKdjoMRYi8nQLdDUNUp+cZMllpdQbHaCi3HQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3T5MjzJg1ncnmHupWCyref0AgOeLhoUEoXH/cQ+QymQ=;
 b=EH1F9juyRgjVmscuQhpfRmjEwvLUic2iWMEXE1Kp9DsiEuPaF7tjc8jgiWXkKndH43CZjZCHNC0C1RiRuR5XCr/EtR7thiBXtaj01Jtrn08cr423IzcmdCxBkjO2R3Ze+gcANFOPygawNZPSljJObjVD6/zwgOWK3lOgdOPmG92OzPVRCu4jl9LNGZXoNezu4Kuc/B8muSA99siSau/lBdkiMWgixGAqtbBmxkBZIETA/6ay+DSDaS91SclwVz/TEO6VgT7HrNmHXb3ELg08AsELMeC+wZ3UkI/A3OhNoD5czKz1fNhrbO40Y6vB0adZ2W+PdHgZNyEPTff2dBQbyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3T5MjzJg1ncnmHupWCyref0AgOeLhoUEoXH/cQ+QymQ=;
 b=zYpf7eoNnmfRpLtlzEPMM3Il7r4i0VJuGn5kQlcwdusIk+2YU3zIMKhmCQpeCLU6G1S/HgJwR133kxM0jsuZxcuXc/w14RcX0fqjP4Q6gApnaHl83P1q8wN5IVDcBbp8oy04JscgLR2TbsvrLM99ui64WS5eKP3NeGDCaF05MLc=
Received: from BN9PR03CA0792.namprd03.prod.outlook.com (2603:10b6:408:13f::17)
 by CY8PR12MB7124.namprd12.prod.outlook.com (2603:10b6:930:5f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.31; Fri, 11 Apr
 2025 08:08:51 +0000
Received: from BN3PEPF0000B073.namprd04.prod.outlook.com
 (2603:10b6:408:13f:cafe::ad) by BN9PR03CA0792.outlook.office365.com
 (2603:10b6:408:13f::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8632.26 via Frontend Transport; Fri,
 11 Apr 2025 08:08:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B073.mail.protection.outlook.com (10.167.243.118) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8655.12 via Frontend Transport; Fri, 11 Apr 2025 08:08:50 +0000
Received: from [10.136.43.133] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 11 Apr
 2025 03:08:47 -0500
Message-ID: <ad53c9fe-a874-4554-bce5-a5bcfefe627a@amd.com>
Date: Fri, 11 Apr 2025 13:38:39 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/67] KVM: x86: Reset IRTE to host control if *new* route
 isn't postable
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>, David Woodhouse
	<dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>
CC: <kvm@vger.kernel.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Maxim Levitsky <mlevitsk@redhat.com>, "Joao
 Martins" <joao.m.martins@oracle.com>, David Matlack <dmatlack@google.com>,
	Vasant Hegde <vasant.hegde@amd.com>, Naveen N Rao <naveen.rao@amd.com>
References: <20250404193923.1413163-1-seanjc@google.com>
 <20250404193923.1413163-3-seanjc@google.com>
Content-Language: en-US
From: Sairaj Kodilkar <sarunkod@amd.com>
In-Reply-To: <20250404193923.1413163-3-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B073:EE_|CY8PR12MB7124:EE_
X-MS-Office365-Filtering-Correlation-Id: 792463d3-ee49-4e5d-12eb-08dd78d01828
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700013|1800799024|82310400026|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WjREajFpMmpJdmtzUlpQNEJseCtPcXVFV1k1VHNobWN4RmphampOYWtwYVg1?=
 =?utf-8?B?SkZHOGpCc3l1VVl2REozTkJwUmZZWjhqdFpqNlVjWHRRME93QU1BWDA0eUhW?=
 =?utf-8?B?OXpsYU9UWlNLLzJkOEZJQnFMVWxQMFhVS1JKRDE5b3YwR1BHWHJSVGhUUGNu?=
 =?utf-8?B?UHNzN2ZYakY4VXpzV1lLVitGdVl4ZTFBOEVJUFE1YTJpQUNvSGdOOUgxWWdh?=
 =?utf-8?B?ZFpjSGpwbC9QcGtVUXVSLzFQVjdUSGo3SjZ2RmVLRG53ZWZSWVRRMVBMTzY2?=
 =?utf-8?B?SFJrRTZNcXZJZkJqWkhMR1B3a2luYk4yNEpKRXNIUlB6bytCU1BIRkQ5bk4z?=
 =?utf-8?B?N1U4TmxwTmY2d01RS0dZOHZieUMvV0FhK2dTMW41emhITVplcm9iTlJWck9m?=
 =?utf-8?B?NHQweWFmYXdGODI4ZWdBK0sxUXFUdEw4ZmZHcng4Slo5Q2N1N2ZtUkM0SUZw?=
 =?utf-8?B?aThYUlhxNTQyMjJXVG5UV3JIM1hlTTJ2SitLb2I5eDNmU2Jmckx5emU1VDln?=
 =?utf-8?B?WjB2V0NPT25ucHJObkIwV2lTOE1FWUdlOGlIMk9zanYxR2FqR2tKVjRzQzZj?=
 =?utf-8?B?QzFBdWRjcFlnZ1dab3dUOWhqUUpwQWVGYUM3dFlNOSticGVjc2w0ci82ZDhP?=
 =?utf-8?B?d05Ib2NEOCtqY2YwWTBQN2lQbjhMME5VUlBJWlJHd2J0c1hhNk1MNkg3L0Nx?=
 =?utf-8?B?b0MyMmF1aHFCaisrTnorckVkSzByRnBEazhCSW82TFpuSisvQWJZRXo5Qld0?=
 =?utf-8?B?Zml6N2xKSHZFLzJicHQwSmZKK0NuYWFPaHFKNnhueFFETWpIWFU1QnVybWxK?=
 =?utf-8?B?QkRLbWZiekkrOEQ3cVNUSlRET0Q1N01jVncyd2ROOGhTcGFFRlVoR1BncWRa?=
 =?utf-8?B?SjVZd25IQXRtaW1OeUZOYUcvRGx1K2dya2hTSVdobDFyMzRuMDRwbEUzMVpR?=
 =?utf-8?B?MzNnMkFJRFpkN0hMR1hLMXFWYmtQaXZIdXByTnhnQ0JSVG1NWDlaVXdyYWhC?=
 =?utf-8?B?MnUrb1NRWHNOK0xzckkwZUZOTExGakVLWVNtVWJsR3NEd0g3VkIyODFKK2hX?=
 =?utf-8?B?d0RUMGF1MlV2cmxBV1lIYWJIbTNudFBwaVZ6R2ROTUxnUkNCK0Q2cTBQZkhY?=
 =?utf-8?B?MzhGaENPVkwwN21qNXNwV1A4b1dtWTVMbUwwb0gvdE16WnVtT1RvTHRQQTA4?=
 =?utf-8?B?bFpaSWpJdEt4cVZlc0dIM2tZelZZamFNMThQNVZ6UnladDZSWVlYOVFmR29t?=
 =?utf-8?B?Y25CckJvM2tkcTN0L0QyMURQMnZGaGdFLzVseTFBR3JWK0NCTGZQRWUyelE2?=
 =?utf-8?B?aHhZTndNS01XdTV5MUNJb1YyakdIL0ZuclFtcVNwMDNQM0ZzYzR4aGRiMW5H?=
 =?utf-8?B?UFpxWFJuMUZibUI2RVZwU2FNOHcxb2tKNGtoUGpoTHgzYUhWTUtIS01qaVdX?=
 =?utf-8?B?dFhFWjBmNDA1WFIxblZZbWZVdXd5QnFLd2swRFZWcWV1dWpSYUVTMHEyWGF3?=
 =?utf-8?B?c0dtUGg5M3dkS1Z6UHp6Q2xRM2ZUbVMzU2R3NjlnV2o5QUNMNWMrY01COEZx?=
 =?utf-8?B?eTFSam13aTYzbCsrWWp0QlVlU2dpeFBHdmE5bzVvU21VcXNseW03SzVUc1ds?=
 =?utf-8?B?eXJVU2k3MDR0VExPQ1RJbkNHK2haRFBYM3BIMTFqWVZ2T3FQUWIxUTRqRStC?=
 =?utf-8?B?SmpheVpmTG9SOUxoSkYvQWRJaXYrNUo3cnRENExHMU8veXJoOXpodnRVRGhx?=
 =?utf-8?B?UjBHYjl1RjN6TmZSdWRZK1JWeXI2bUdtemxpVGRzUkpXbGdyOWJ5dHdsRHY4?=
 =?utf-8?B?QUk4dU5kRnBQaURXeWdVL29veThGSUhGYjhMeUN2cVhtKzJDeHNKYnI2VjN5?=
 =?utf-8?B?anFiOVRKbTZTZkRvTGlqSzZOK2F6ME5GMnBweVBzOTRTdFpxNTExNmdPOHha?=
 =?utf-8?B?clFybDhBMXQxdTh5cGdFWDQxSXFTc1ZrdSt3ZXAzNEpXN1paU0p4R21WTGwr?=
 =?utf-8?B?NnlVaU1TTEVwTFpJbjhid1VPUHdNT2RsTzE1UE5XZ055bkw5aFpURTZIZENm?=
 =?utf-8?Q?ZVUjw2?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700013)(1800799024)(82310400026)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2025 08:08:50.9819
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 792463d3-ee49-4e5d-12eb-08dd78d01828
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B073.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7124

On 4/5/2025 1:08 AM, Sean Christopherson wrote:
> Restore an IRTE back to host control (remapped or posted MSI mode) if the
> *new* GSI route prevents posting the IRQ directly to a vCPU, regardless of
> the GSI routing type.  Updating the IRTE if and only if the new GSI is an
> MSI results in KVM leaving an IRTE posting to a vCPU.
> 
> The dangling IRTE can result in interrupts being incorrectly delivered to
> the guest, and in the worst case scenario can result in use-after-free,
> e.g. if the VM is torn down, but the underlying host IRQ isn't freed.
> 
> Fixes: efc644048ecd ("KVM: x86: Update IRTE for posted-interrupts")
> Fixes: 411b44ba80ab ("svm: Implements update_pi_irte hook to setup posted interrupt")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/svm/avic.c        | 61 ++++++++++++++++++----------------
>   arch/x86/kvm/vmx/posted_intr.c | 28 ++++++----------
>   2 files changed, 43 insertions(+), 46 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index a961e6e67050..ef08356fdb1c 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -896,6 +896,7 @@ int avic_pi_update_irte(struct kvm *kvm, unsigned int host_irq,
>   {
>   	struct kvm_kernel_irq_routing_entry *e;
>   	struct kvm_irq_routing_table *irq_rt;
> +	bool enable_remapped_mode = true;
>   	int idx, ret = 0;
>   
>   	if (!kvm_arch_has_assigned_device(kvm) || !kvm_arch_has_irq_bypass())
> @@ -932,6 +933,8 @@ int avic_pi_update_irte(struct kvm *kvm, unsigned int host_irq,
>   		    kvm_vcpu_apicv_active(&svm->vcpu)) {
>   			struct amd_iommu_pi_data pi;
>   
> +			enable_remapped_mode = false;
> +
>   			/* Try to enable guest_mode in IRTE */
>   			pi.base = __sme_set(page_to_phys(svm->avic_backing_page) &
>   					    AVIC_HPA_MASK);
> @@ -950,33 +953,6 @@ int avic_pi_update_irte(struct kvm *kvm, unsigned int host_irq,
>   			 */
>   			if (!ret && pi.is_guest_mode)
>   				svm_ir_list_add(svm, &pi);
> -		} else {
> -			/* Use legacy mode in IRTE */
> -			struct amd_iommu_pi_data pi;
> -
> -			/**
> -			 * Here, pi is used to:
> -			 * - Tell IOMMU to use legacy mode for this interrupt.
> -			 * - Retrieve ga_tag of prior interrupt remapping data.
> -			 */
> -			pi.prev_ga_tag = 0;
> -			pi.is_guest_mode = false;
> -			ret = irq_set_vcpu_affinity(host_irq, &pi);
> -
> -			/**
> -			 * Check if the posted interrupt was previously
> -			 * setup with the guest_mode by checking if the ga_tag
> -			 * was cached. If so, we need to clean up the per-vcpu
> -			 * ir_list.
> -			 */
> -			if (!ret && pi.prev_ga_tag) {
> -				int id = AVIC_GATAG_TO_VCPUID(pi.prev_ga_tag);
> -				struct kvm_vcpu *vcpu;
> -
> -				vcpu = kvm_get_vcpu_by_id(kvm, id);
> -				if (vcpu)
> -					svm_ir_list_del(to_svm(vcpu), &pi);
> -			}
>   		}
>   
>   		if (!ret && svm) {
> @@ -991,7 +967,36 @@ int avic_pi_update_irte(struct kvm *kvm, unsigned int host_irq,
>   		}
>   	}
>   
> -	ret = 0;
> +	if (enable_remapped_mode) {
> +		/* Use legacy mode in IRTE */
> +		struct amd_iommu_pi_data pi;
> +
> +		/**
> +		 * Here, pi is used to:
> +		 * - Tell IOMMU to use legacy mode for this interrupt.
> +		 * - Retrieve ga_tag of prior interrupt remapping data.
> +		 */
> +		pi.prev_ga_tag = 0;
> +		pi.is_guest_mode = false;
> +		ret = irq_set_vcpu_affinity(host_irq, &pi);
> +
> +		/**
> +		 * Check if the posted interrupt was previously
> +		 * setup with the guest_mode by checking if the ga_tag
> +		 * was cached. If so, we need to clean up the per-vcpu
> +		 * ir_list.
> +		 */
> +		if (!ret && pi.prev_ga_tag) {
> +			int id = AVIC_GATAG_TO_VCPUID(pi.prev_ga_tag);
> +			struct kvm_vcpu *vcpu;
> +
> +			vcpu = kvm_get_vcpu_by_id(kvm, id);
> +			if (vcpu)
> +				svm_ir_list_del(to_svm(vcpu), &pi);
> +		}
> +	} else {
> +		ret = 0;
> +	}

Hi Sean,
I think you can remove this else and "ret = 0". Because Code will come 
to this point when irq_set_vcpu_affinity() is successful, ensuring that 
ret is 0.

.../...

Regards
Sairaj Kodilkar

