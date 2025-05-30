Return-Path: <kvm+bounces-48094-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C32F7AC8BE3
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 12:07:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B07961885184
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 10:07:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E0EC21CFF6;
	Fri, 30 May 2025 10:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="OMo6e1BI"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2073.outbound.protection.outlook.com [40.107.223.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D750D21D5AA;
	Fri, 30 May 2025 10:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748599594; cv=fail; b=dmLe1KCQsPYLcf7ThlFdrxyAWW67gktJrVB5fgpTL+0hdU3/yLqwCUWjNjDh6PD6zAl+Bvna88xr7TyeFE8qYEh4vCooaX5785CrXlmwLkbFCzt6nE/Rn7Jw+Wgs37cYw87Pr682ffzg4Msi37MpL4XE9i0nRtneFYasv0zYIH0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748599594; c=relaxed/simple;
	bh=JxtOiWk2v8nlTRxICT7eikapiYSH58jSZh9QEHzD3Oo=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=bLfVibxMMVr+627QIxod8sFB0SehuMotH0hGoa/7Fuk7U4QciSzQ+IFRw4UNaA/ofDBjuORjnD+TF9og/bS3f0evv2wdkywcjbkcotLAy7lupmkH6oiCNV10R9JDzQWphUZR6BjSaaxAimSwnpO+vV1u8D7PzVCnzv6KAzSTZ24=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=OMo6e1BI; arc=fail smtp.client-ip=40.107.223.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K+YBaaDjbqnxSwLFjcL0RL+qmyl6jcTTdX8TNtUYU8xLcYpSDzxDA9AqUQxI4zjEHOtSFbJuuE2IuzpbWakNfCWAdkUQVok+yPno6KuBXeHmZeh2wucsVxm7B3v9vrWGzsIWxC2DuECkliIKZaNRgrVF47D94bUnIt41KScWQHJzP987p2kq0TMsQyN81PDvONVKlj32F5idMlSqJ5jcb2C59e9hi3adCJ9qAom53DenXUaQkEh+w82M0CT1lf2xpblw7J809+aSABjd1FldmuSoH8DSGZAmUfk9Y5NZ4VPKcveScau+pkfUcJnlpYGn+sOKb63kJ8Doag5VNKktwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6TNWte9CF1MX5PuBSBbQltvpicdc4+rJ2f14vXPSTKA=;
 b=CxJ/savkzblVJi9VBfZIxbtE+gA8GwUP7ip8xvhUbz1ABaDfIGWyegWLLwdpH0GM7i73pDuONkIXEtJGv9DU40Jw17cNbxDOaRK1Qo+b5X/KG0FvvAjYbJB5itzJlVDSoY1O3zypEjCNo4Etw7OzIiOApTT5SqiUkt7CleCf3Kt3/5A3O98gl8onutz2wQedsYvoYaP9Z9whXBwXFt7SpXFd0khK9Z1w9Ko1iu+xIvbhoxZbdaaxuQdQuezafYPsea9egelv2tLCxBMNJoFFmXHSUoW32pceglmKMYdp3XTHpzlsUN8MVL/6r5qYq616G+9yxEQob+YmFYdwfrQJCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6TNWte9CF1MX5PuBSBbQltvpicdc4+rJ2f14vXPSTKA=;
 b=OMo6e1BIGfQvwOOlw7DmEYtC+U/Ho9CZy/nIuDAaASEYNFIxbKxO5mMiIN4/Drm2pEt8J8tgh9y1yrIMKzVjh+zPG/vHQoKm1n9Vf8R0o9ZJAM2o0qdXyY9N5WRQLccUiPXjY1lIxqyXX1xjOfUdzB3M+IaoIp9XTDUzr3H73k4=
Received: from SN1PR12CA0100.namprd12.prod.outlook.com (2603:10b6:802:21::35)
 by DS7PR12MB8276.namprd12.prod.outlook.com (2603:10b6:8:da::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.27; Fri, 30 May
 2025 10:06:30 +0000
Received: from SN1PEPF0002BA4D.namprd03.prod.outlook.com
 (2603:10b6:802:21:cafe::3a) by SN1PR12CA0100.outlook.office365.com
 (2603:10b6:802:21::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8769.19 via Frontend Transport; Fri,
 30 May 2025 10:06:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002BA4D.mail.protection.outlook.com (10.167.242.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8769.18 via Frontend Transport; Fri, 30 May 2025 10:06:29 +0000
Received: from [10.136.33.30] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 30 May
 2025 05:06:25 -0500
Message-ID: <a30dd520-b6d2-4ae8-86f8-d4f71ef3e0e0@amd.com>
Date: Fri, 30 May 2025 15:36:23 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 41/59] iommu/amd: KVM: SVM: Add IRTE metadata to
 affined vCPU's list if AVIC is inhibited
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>, David Woodhouse
	<dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>
CC: <kvm@vger.kernel.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Vasant Hegde <vasant.hegde@amd.com>, "Maxim
 Levitsky" <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>, David Matlack
	<dmatlack@google.com>
References: <20250523010004.3240643-1-seanjc@google.com>
 <20250523010004.3240643-42-seanjc@google.com>
Content-Language: en-US
From: Sairaj Kodilkar <sarunkod@amd.com>
In-Reply-To: <20250523010004.3240643-42-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA4D:EE_|DS7PR12MB8276:EE_
X-MS-Office365-Filtering-Correlation-Id: a68657bb-b0be-4962-e1e7-08dd9f61a5ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|7416014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TmNnOWRKcm9VM2diSXUzUHFibGtyZjc4WFFrV2ZObzZpVXVOTGE0Zzh5YWxu?=
 =?utf-8?B?RW02R3RhaWtNbXl4UU9hWDZ4TzgzL1k2RmtVK1BrZllDYkpYUDBPZWgySXds?=
 =?utf-8?B?UEhLNjNLLytJSlc4VExWK2UxcE1vS3MzUmd6elZWT0RHeng0bE8yS1A0ajlG?=
 =?utf-8?B?MVlucDFsVnNrdWl2TDlDOGJ4ZkVBc2cyR010dHVTMnpBYzQ2T3RKSjZDN25w?=
 =?utf-8?B?cUNTbHZVb1JLZ1pjeUVCZ3o2elRrS2J0S015L0NIQWhZeGRxVWVxSDhvVHJ1?=
 =?utf-8?B?a0EyZ0dTZjYxVHlydFlUdG4xVGpYdmtLK3ZqY29sYlI4MU9ZYks5OFUvZmVO?=
 =?utf-8?B?dE83bWFxN0FTU0tNVVJIeHZMRTNlaGpVamNwR0JJRVF4b0h3Sy9pQXlRTnNk?=
 =?utf-8?B?M0Z4WTFZY3g1S0tZejlsMFZhVTJLYWJBTjhrMkR1djI3VkNicnhNbXZndXpt?=
 =?utf-8?B?YWJWV3JOOTN0Z3FrMUZGV2JMUTE1dURmRmNSVUczZmkyeDVPdVBzSDI1bkVW?=
 =?utf-8?B?c2FTRkQwb2ptdGdKVGhwZnVYUFYwdzVZWk5RZTVZblIvbWJLWkpHSCtidjRG?=
 =?utf-8?B?ZVRFZDgrNnNucEV6NkVmalFqcGdaVGsxMVU5MXV0aWpyZGphdGV6cEoxakxm?=
 =?utf-8?B?SGNWcDFUeWxaeldKMzRBMkMrcnF5YXN2ZXNkN3ZrUlU4NUt2dHpKSWJYaHlY?=
 =?utf-8?B?UnNhazVZK3d0NlV5SEZBVFJoYWdjaGl0Nm9hN1V2dituODlqRjhvOUJBNG1h?=
 =?utf-8?B?YUg2VE5UZFJ5UURpYXpvc2RWL0daYkVnaURjZ1Q1T1lFR3NJNndkN2E2MmJR?=
 =?utf-8?B?ZUIwb2lWZUNJalV0LzZFMEdRNVcvd3VISW9NQjh2VnFOTWNCN2lwR0YyUG13?=
 =?utf-8?B?NUxrVG8rYlhuK3BsQm5UNlVNRmJBRFlBWER1UEpBR05MdU5ETUpBSHpzNDN3?=
 =?utf-8?B?QUs2RnIzSTg4K0JYUlZLY0UzUHp0bGx1ajVqYWpTV1ZjejdpVjdxT2l5RmxH?=
 =?utf-8?B?NHhMZW50YzNTUlVIZnFLTUlRT2pqSHlBSDFsbXFSeEVnaGlvUXdKYWs4ZzNM?=
 =?utf-8?B?U1FWV2hhVGFkTHVEUEhCSG80bU1yaDQrUnRPRjVwaGw1aWRzdXJPU0piR0Vs?=
 =?utf-8?B?ZTVEeDA0NFdGVFI4MnpHdVZNZjBmUmY2Mk5WUGlCL2YxKzgwRkJ6T0c1bHZP?=
 =?utf-8?B?MThqRVVWeWpJL281Ujc4VlJEWmdyWDRobmlBbHV6cnMxa3d0M1lkSmNNQm9L?=
 =?utf-8?B?N2p2M3gxQXNhL1pPazJHOXdDYlhvVkhWYTMrKy9kWmYvSGpSc2ZRYU9XRUUy?=
 =?utf-8?B?bWZxcmdjaU1VZXBzN3haRm1IQkNXTDNuSDdycGJsV0orY3ZweVlGaUVsajV6?=
 =?utf-8?B?eGxRMWRpUFRhRmpHZDFKMnlRT05IdVdjK2ZCTlRzd0RsZXRvejdEWkJSU2Fw?=
 =?utf-8?B?WFRISnNOakpMeXArbGNNYytXOGFjc01WQm5MNXZSOFVLK2JHN05pVm5VRjNr?=
 =?utf-8?B?WUYxdEZGQU54THpKcUsxMDJTdTJ4bS9zRnlzRkdBdmUrUS9IMkJCVE9pYVIy?=
 =?utf-8?B?M3hVcC85UG56bGNaWm9rSlhUY1ZFbDFsMTh3bzhTRWVXYnQzVmkwd1ptbkZC?=
 =?utf-8?B?WGlxYUN2MUZJN2dTaWloaSs5YjJTbWQwdkhWMDVVQk1lOGJHZXYyUHYzY2N6?=
 =?utf-8?B?bDB4K1FubUoxWmZMVkR1blcxVFA1S1NNa1FxbUZkS2wzbDB1KzFTTzNHRnla?=
 =?utf-8?B?ZDFRbjBzTHliUHVXbm1ubVpPc0pmT2hsV1Q3eU5SeGpSb21XbG9qOFBkUXo0?=
 =?utf-8?B?WTcrMHVtWWZlWERYdjh6R3VkdjJCRmcweGJNdjZ3ZDRUditTMHJPR3NDejFO?=
 =?utf-8?B?TFVHeVRNVjNuNFVmUkIwSVIzNldTTHJ4Q3p3aC9waGZWejlFZitxeDgzNUNh?=
 =?utf-8?B?QTdwMlczNFVFZDVIdUdPVFFMbzUxUDY5QmsrdFpUT1hpUkNwdmRhYU03Rkp5?=
 =?utf-8?B?cGwrZ0V3SXdZRWxPS2lsN20zcWFuMXNIdk9TaGZvRWhQeWZ4Y2pkQ1NXS3ZG?=
 =?utf-8?Q?jpRfPY?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(7416014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2025 10:06:29.7580
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a68657bb-b0be-4962-e1e7-08dd9f61a5ca
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA4D.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8276



On 5/23/2025 6:29 AM, Sean Christopherson wrote:

> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
> index 718bd9604f71..becef69a306d 100644
> --- a/drivers/iommu/amd/iommu.c
> +++ b/drivers/iommu/amd/iommu.c
> @@ -3939,7 +3939,10 @@ static int amd_ir_set_vcpu_affinity(struct irq_data *data, void *info)
>   		ir_data->ga_root_ptr = (pi_data->vapic_addr >> 12);
>   		ir_data->ga_vector = pi_data->vector;
>   		ir_data->ga_tag = pi_data->ga_tag;
> -		ret = amd_iommu_activate_guest_mode(ir_data, pi_data->cpu);
> +		if (pi_data->is_guest_mode)
> +			ret = amd_iommu_activate_guest_mode(ir_data, pi_data->cpu);
> +		else
> +			ret = amd_iommu_deactivate_guest_mode(ir_data);

Hi Sean,
Why the extra nesting here ?
Its much more cleaner to do..

if (pi_data && pi_data->is_guest_mode) {
	ir_data->ga_root_ptr = (pi_data->vapic_addr >> 12);
    	ir_data->ga_vector = pi_data->vector;
    	ir_data->ga_tag = pi_data->ga_tag;
	ret = amd_iommu_activate_guest_mode(ir_data, pi_data->cpu);
} else {
	ret = amd_iommu_deactivate_guest_mode(ir_data);
}

Thanks
Sairaj Kodilkar

>   	} else {
>   		ret = amd_iommu_deactivate_guest_mode(ir_data);
>   	}


