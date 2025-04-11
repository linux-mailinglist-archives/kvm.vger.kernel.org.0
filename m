Return-Path: <kvm+bounces-43142-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 94D06A85687
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 10:29:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A5B3C9A54A1
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 08:28:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D31EE296145;
	Fri, 11 Apr 2025 08:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="A/+4BFOy"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2058.outbound.protection.outlook.com [40.107.223.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF0AA290BBB;
	Fri, 11 Apr 2025 08:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744360124; cv=fail; b=t/kjCiFQMXZTRZP8XYH+AJ4vQ8zrKXIFsk1SuMjm6Hby4bSGW6eZcgu5ThOrJlY6WDKCfQnIKlCqSi52LPguBmmH4NOVQP23VKadLj5oi0miMRORMcJSjUZrvDtdsmtvbU17N85Un/zhFE5VueX2HioUNDb30/N/8e4hF72oXy4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744360124; c=relaxed/simple;
	bh=vMk0rH5pdm0F2DE+mrtz+WvyCY7rbhrJgqlzH1CiOts=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=ZkJBkFxJjYa749nHu4pavVuJsJBegcTdTo3m2WlOfOLvXAhJ6cFyzFXKE5eWa0wXqiUSlB5FDlX4q84wMviE/1mP5ZVF2Dflcz5yWUqF2+S5dYrINAYl111QEZCWZQjL2vTUB6T6wHlcDcoqia9Z0P9D9yB9M/QEONm27Qs0BnU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=A/+4BFOy; arc=fail smtp.client-ip=40.107.223.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ayfhUQcTs3XmzuMhdwfquhIhRArNLqFqUEpC19I06Mktbr4azZKTAQstWu9B/CFrZT/Ss+PrK73JHM8u2hKQvXoYLErwUUsYfQeDplHMRVHs7bFbCyRKMPJGb49Xf1FKM8ZAEJi3nnaU1j24ePhYqd+3sAl/j/h8IHXvNX26m9tdPDAyaGN1ScEKskes0tM3dE6gi4itzJpAXljLwVI/wuOHjCU8ngNtkNqegE+7ZQOZedGc68BFu97uCfZwVVdsW9M74h4Thi7oUXjKrDI9gg/XNZHmltG0Ax8Cno9JfkanhzfDmhvpsVaCiB9VYa3QeARBVK0S2tITQOuZElCvgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pFmMe8lfpNhesbYDlygIwkv6TaGb4SEdXiNa3rxex9k=;
 b=w9ETeDhj+ooWChGLp4/Sqbwn/8aLpdq9qcULK8c1XcWUniGfTjcukKg2uJtIujegnbyxnOIYMozwPI7Vc4XfcSRafHGJx+Is7jsMYslyh6x3sK1M8QTzFDBNoY/T1heXAfuFqHBSwAghqjBqGcGKmFPBUL7+WtKjbMbWSU1BDsNcopV8dmfWrk23cznMPioKAMFLSMkWL0HPTKUe/64r9UiG1CrNM9lQJoILdmtzEehGH5bl1hNI5PUSKqauWKJxHx3jT2ZxoJMvMfZgkBbZNF/A/UGYt53mwcxyMVXuE/Zn2phQ/UZ0w8iwbOdRaKPRcilJnZaiQwt5kl13heCcXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pFmMe8lfpNhesbYDlygIwkv6TaGb4SEdXiNa3rxex9k=;
 b=A/+4BFOymvQTE/oXR1s44kfjvbPholkufFJqe0ldgEG/4S9nqwY0a+dnJAmjuPPHiAV0NErX6klV+RKPBi763oNd6KJXTtRQoYbDcwln2gUeRjoTh9xCsHJlZd06U3CuB3l3BmxOxpR5HPXh+nfKA0lXmOY6K+WBtTIowj5H1Sc=
Received: from MW4PR03CA0138.namprd03.prod.outlook.com (2603:10b6:303:8c::23)
 by MN2PR12MB4256.namprd12.prod.outlook.com (2603:10b6:208:1d2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.27; Fri, 11 Apr
 2025 08:28:37 +0000
Received: from CO1PEPF000075EF.namprd03.prod.outlook.com
 (2603:10b6:303:8c:cafe::a4) by MW4PR03CA0138.outlook.office365.com
 (2603:10b6:303:8c::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8606.36 via Frontend Transport; Fri,
 11 Apr 2025 08:28:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000075EF.mail.protection.outlook.com (10.167.249.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8632.13 via Frontend Transport; Fri, 11 Apr 2025 08:28:37 +0000
Received: from [10.136.43.133] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 11 Apr
 2025 03:28:32 -0500
Message-ID: <0895007e-95d9-410e-8b24-d17172b0b908@amd.com>
Date: Fri, 11 Apr 2025 13:58:25 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/67] iommu/amd: WARN if KVM attempts to set vCPU
 affinity without posted intrrupts
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>, David Woodhouse
	<dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>
CC: <kvm@vger.kernel.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Maxim Levitsky <mlevitsk@redhat.com>, "Joao
 Martins" <joao.m.martins@oracle.com>, David Matlack <dmatlack@google.com>,
	Naveen N Rao <naveen.rao@amd.com>, Vasant Hegde <vasant.hegde@amd.com>
References: <20250404193923.1413163-1-seanjc@google.com>
 <20250404193923.1413163-7-seanjc@google.com>
Content-Language: en-US
From: Sairaj Kodilkar <sarunkod@amd.com>
In-Reply-To: <20250404193923.1413163-7-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000075EF:EE_|MN2PR12MB4256:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ef0c58a-314a-4c4c-4ade-08dd78d2db79
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|7416014|82310400026|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NGduZWZHY1pZcDBzU3NVdkF1b3R6bG9FcUVZalo4RjNYOGtWREdDOWRUMVY5?=
 =?utf-8?B?LzMzdmRlSzVaSEpHYmU0Rnl4eitQcFNFTjQrUkFNU1p3LzVDWXVLaWxFcS9X?=
 =?utf-8?B?K2JnZER6OGd0K0ZzWnBQSkhlSjhuRmxkZGg0Q05xcE8wN00zZi9Kb0cvYkZ4?=
 =?utf-8?B?U3Q1YkhJZG45US9rZ0Z3VkcwWXZuYlozcWxDb0d0QTFmZHdLRC9raEFyUzdL?=
 =?utf-8?B?K1BoTVVxRTc4QlpsREdBZkRQNlk4RW03c2VEais2aFBQQnZzODhaSldtYWJ6?=
 =?utf-8?B?RUUrZUVWcU5kSlk2eXptenF1L1FVdTV1a2VhNVk1dFZtQ21BV0hxMEZRTmQ1?=
 =?utf-8?B?TFhwRnV1TEk4cTVoY1l6cEFrOHBmR1dCT0hXNHNQa0RtT2NKOWpMV1h3a3Uz?=
 =?utf-8?B?K2hJM09NZ2VmK1M1ZWttbitwYXU5Z012QkExNG5HSlQzM0taUmZjMkxrSUFi?=
 =?utf-8?B?enJJUjZudzJRdEk0Nm81UWRlbFIzSVMwekJNa2hBK1pXMzh2dWJSY1VBUzNB?=
 =?utf-8?B?L0VsZ0JwQUEvYXhIckFUVklJOThrT1huRmU3YkhtaFJZTi8yTVYzaWRuTm0x?=
 =?utf-8?B?dnVpcHBmOE4zbjhxNTlyUzgySXl4d0Mzd3ExUWFiM3BmZE8vTkV5aTlsUFpH?=
 =?utf-8?B?bnZobTFrVHJZdks0MWVnNTVLT21WYUo0WWxBNkZWZWZuMmJwQUdmcytBcWFD?=
 =?utf-8?B?eHU0L0JRY3BEUEhTYzZXbDFpN3VITy9TMDgva3o3b29zbFZIdEpFbks2NzZ0?=
 =?utf-8?B?cXBCTERRTjVXcExtNlBnWTNJZTM0bWdiWWFyeS9wM1JnVEkrN1JMd29ITXVo?=
 =?utf-8?B?MlFuWHpyNG9Sa29Gc3ZldzdVcXdZREVrTVBpMXcxMWh6MmlKaWxPWDViYlFk?=
 =?utf-8?B?Q0MrOHZ4WGN2eGx1ZGtvbEhpTmMzOGMvUGFQVG9tS1FQUVRsYUkrbS85WC8x?=
 =?utf-8?B?VThrTXVpb1UwMFBISVJ4YzBIT3FsSnBJUk1GTk91aWtJNGhuK0VMOEtab29Q?=
 =?utf-8?B?OUNBSlJ5Q0paR0RwRlNyRU1QeTg3aHRhZWMrUExyNGhqc3ZhRWJhakJpY25P?=
 =?utf-8?B?aU5LbjRHWTRLZFNaU2E1Q3BxZ0s1OHBHWjdPUDBZalFHMU0rMmlyUzkwVHZl?=
 =?utf-8?B?YTB5QmtGT2gxRFB5bDBvTEJEUldGT0pVTUI5dFBDVGlSN0VQWVBVeVpESmVP?=
 =?utf-8?B?ckpzRUhudkFJNmtiWGVRdm9PM29yYmZhQmRFTlIvQ09tV2g5NVJoNjZHYUg1?=
 =?utf-8?B?WEtqZXIvL2RybHBrOW9vNWpLb2U3blYyUm1jNFFEZ2xPc242d2JvamJPSDlo?=
 =?utf-8?B?Um5tNHAwNW1FUG9LZUEwenlMSHJtN2dMQkttdVlUMTJDczZxQXJVdmc2WVMy?=
 =?utf-8?B?ZjRoaUgvQncvVXBYZUhjbm1FNDg0RGJpM0tqOXIxbXJmaTF3dEJBdFJvZDhN?=
 =?utf-8?B?RUlRais0cU9DS0ZCSjhieDdvME5waWdjUUNrM0lWN3lTdnp1UVZZeUtOK3JM?=
 =?utf-8?B?TW96UnI3VnFWQitKRVZFZWoyVGE0YmMyYWZJelZ6OWlYazAyZ2VXT3ZYZ3FI?=
 =?utf-8?B?cVEwL1hSVSs5Qm0wcmc5MUxma05yYmNsMFpMTkQ0WE9rblA4U3Fhc2RFUDQy?=
 =?utf-8?B?RG05dUIzUk1TcWdZbElNWFF2TjJNSFFZWUgvNVNnRVcwenV1S28wTE52NmFl?=
 =?utf-8?B?aUtSWnJJRjFJeTFiVVBEdGxxWjNQNVFGY3BTbzBuY21rd1Y2Vm52cFBtZW9m?=
 =?utf-8?B?c3cydzhLT0lKbWwrOU43LzQvTFcveFNDMmRFYVNXZ3lqY2pFelpGSThyYm9H?=
 =?utf-8?B?Zk1GZmF3VnorcUxVa2IveFV0YzU2RmlUaHdPMi9JZi9qZm9LWDQzODQ4QXp0?=
 =?utf-8?B?bFgza1c1UUZFcVYrUHUrcXNxRGdLME1XSGdLNVk0cnM4VlIrc004T1FLTHo4?=
 =?utf-8?B?RllEbzhUclNCS2RzNTdJRDNvazMzNy9EYzdiNEdkS3NkRXZjMWRXTW1jN2Ev?=
 =?utf-8?B?Y0hLL0x3NWJpWDhiUXRFaHA4RDFKckIwcmI5cTRscmhBcnk3WC9MVW54V05Z?=
 =?utf-8?Q?b37SUw?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(7416014)(82310400026)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2025 08:28:37.5696
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ef0c58a-314a-4c4c-4ade-08dd78d2db79
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075EF.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4256

On 4/5/2025 1:08 AM, Sean Christopherson wrote:
> WARN if KVM attempts to set vCPU affinity when posted interrupts aren't
> enabled, as KVM shouldn't try to enable posting when they're unsupported,
> and the IOMMU driver darn well should only advertise posting support when
> AMD_IOMMU_GUEST_IR_VAPIC() is true.
> 
> Note, KVM consumes is_guest_mode only on success.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   drivers/iommu/amd/iommu.c | 13 +++----------
>   1 file changed, 3 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
> index b3a01b7757ee..4f69a37cf143 100644
> --- a/drivers/iommu/amd/iommu.c
> +++ b/drivers/iommu/amd/iommu.c
> @@ -3852,19 +3852,12 @@ static int amd_ir_set_vcpu_affinity(struct irq_data *data, void *vcpu_info)
>   	if (!dev_data || !dev_data->use_vapic)
>   		return -EINVAL;
>   
> +	if (WARN_ON_ONCE(!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir)))
> +		return -EINVAL;
> +

Hi Sean,
'dev_data->use_vapic' is always zero when AMD IOMMU uses legacy
interrupts i.e. when AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir) is 0.
Hence you can remove this additional check.

Regards
Sairaj Kodilkar

>   	ir_data->cfg = irqd_cfg(data);
>   	pi_data->ir_data = ir_data;
>   
> -	/* Note:
> -	 * SVM tries to set up for VAPIC mode, but we are in
> -	 * legacy mode. So, we force legacy mode instead.
> -	 */
> -	if (!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir)) {
> -		pr_debug("%s: Fall back to using intr legacy remap\n",
> -			 __func__);
> -		pi_data->is_guest_mode = false;
> -	}
> -
>   	pi_data->prev_ga_tag = ir_data->cached_ga_tag;
>   	if (pi_data->is_guest_mode) {
>   		ir_data->ga_root_ptr = (pi_data->base >> 12);


