Return-Path: <kvm+bounces-55113-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 966CEB2D86B
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 11:36:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C3D4F7B6AEA
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 09:34:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD6BA2DC359;
	Wed, 20 Aug 2025 09:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="qg9NagZb"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2047.outbound.protection.outlook.com [40.107.223.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A74B02D130B;
	Wed, 20 Aug 2025 09:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755682418; cv=fail; b=tly4i7+XXbIZCya3YH+Xu5a/PuRgQelPPH1hDi0qTuS9P7CIWFojUtlvTdxr+Zb3RZrl/Y1rpVYbcGYsY03dob70oWN0XdO1Xgwdy/lTBkm9gYnM/Ko7zTFTN7kLkQ03Z4+IZpvcoovGNqDLJ7wtDjGfTUOxE2CaYGFGw4CRq44=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755682418; c=relaxed/simple;
	bh=Ivm/j/MZ4CwZs7uGXb15my8wOY1JljBt7PYhiffoKkM=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=g11ljmQn4cQHpnXlCt3dZ8EyGI9S+JOUCcsHPWL4QhYLAb4CvLBsdbpPgq/UQC9RHXCV3R4kJsEzhvgLQ9Le4PILbE2nw5AQ5YS31SIx8k8vWwMBh+ZPG1KqKyBhGkpiHrL2zDjdONpPFDpTVw20l748ogKUeiazoHZ36y91KzY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=qg9NagZb; arc=fail smtp.client-ip=40.107.223.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b4tx9rXZzQOnHzrB9xZylrVkMRxOmHEBtZa6y1AtgXy32NIsVcSK2EKt1yn4HAqrGgQemouL89nG0MsVki10jvFsMNxtNvMwtOdz8wV6b+ft5yZq3cBgdlpirgO0dMli0cGIzOtucQdKquV/8xSxW7W710TDDckSRhZ6S6dgV8A+OZ+pDGjBeoii8shWh0O1Xqzcfi5LWFsdFDXL/lhhiGYwhda4uLBe2Z0+K0/vIa1/hNI774VzOk+QyzPXH6AgwpAlgjbrZLLj+jQj2MR15Nh788iTjG0gQqPXCON0mPBYGKJADb3c5OD9h7rm3QXWSGxNQA1xxcY/6j0+q1jpBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kuBH8iftYcLJYJ6/Y6nat00aiKhy5eFvEzM9HE8+FDU=;
 b=OtiLL1LA/EHQVJbshciOBNxWn82yloMG/+zYeFgshsLKeFnjX3idK5yT0zkfB301/efRsT5nG1hBvyzUHC+EOjs5tikodkdd4+uHb+ihmTInlDvyTHTHZQK1QyH9NqLb006wp/aqy6/m/Op6xbdGlNBa1YgzuwezkG8Mz0OWAcMyJT3+gTPspqb0XKYoLCf0fIOKRBVmZBHbAqyXJTrM5LWKMpwf1ch0VJulFsnSgbtgM3XPOd2CC20R0ZIInMht/e8My+/KAWOZ87w43QB4JjCcRBzadKUY7+USGKftd9Mb8zNzepYEoUfxGPiWIU8FJWwjoDkzr6XtoUPFkioieA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kuBH8iftYcLJYJ6/Y6nat00aiKhy5eFvEzM9HE8+FDU=;
 b=qg9NagZbTDSmQa7C9oA7z/1QOtJEazmo4UFq5MrtGdP84W8/XZ0G8VbX/bVCYFvMsb/+BcNoTC9Ob1M0O4lrLsuanuoi297mCuGwzPxhIKbi79HJ2xtwvxGQ/U3xkqDBt5zQGn39zwNKa/6fa5NcxsyR6hhm5T/O9N/N3k7LkaI=
Received: from SJ0PR03CA0360.namprd03.prod.outlook.com (2603:10b6:a03:39c::35)
 by DS0PR12MB7971.namprd12.prod.outlook.com (2603:10b6:8:14e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.25; Wed, 20 Aug
 2025 09:33:33 +0000
Received: from SN1PEPF0002BA4D.namprd03.prod.outlook.com
 (2603:10b6:a03:39c:cafe::ed) by SJ0PR03CA0360.outlook.office365.com
 (2603:10b6:a03:39c::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.14 via Frontend Transport; Wed,
 20 Aug 2025 09:33:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 SN1PEPF0002BA4D.mail.protection.outlook.com (10.167.242.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Wed, 20 Aug 2025 09:33:32 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 20 Aug
 2025 04:33:31 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 20 Aug
 2025 04:33:31 -0500
Received: from [10.252.207.152] (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2507.39 via Frontend
 Transport; Wed, 20 Aug 2025 04:33:28 -0500
Message-ID: <96880975-a74d-4206-839d-55b6943af71c@amd.com>
Date: Wed, 20 Aug 2025 15:03:27 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 7/8] KVM: SEV: Fold sev_es_vcpu_reset() into
 sev_vcpu_create()
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Thomas Lendacky
	<thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, "Borislav
 Petkov" <bp@alien8.de>, Vaishali Thakkar <vaishali.thakkar@suse.com>, "Kai
 Huang" <kai.huang@intel.com>
References: <20250819234833.3080255-1-seanjc@google.com>
 <20250819234833.3080255-8-seanjc@google.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20250819234833.3080255-8-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA4D:EE_|DS0PR12MB7971:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e899038-2151-444e-e523-08dddfcca10b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dmFlVWtyVnNMR2U0ZUNHblVhbCtOZVlZYWcyaGdYYWhuOXVXNmxUMGJGeXNx?=
 =?utf-8?B?dkZnMkZLUHNodEV2WFJxR21Hd2hMVlk0Vlh3ckxLODJobHpvRTk4SEdiS0Jm?=
 =?utf-8?B?UmZYK1pwb2dqSWZGMzFZS2s4TTFGZHZiSjV1eXUwSWR1cXpsZXIwOGMvZXZT?=
 =?utf-8?B?UmFGT08vZFIzQS9mMUpLcENpS08yMGJUc1FLc1RSeUJpNXZ0cDliSmlWTTIw?=
 =?utf-8?B?THhBWU1BOEFBUkNQbGpHSFJIY0Y5OG40d3RSSmxwQmR5QkRwbDNwZTliMW8r?=
 =?utf-8?B?ZGhwcEdJNUt6em5CQUUreHBlN0FJdk9scXJqekNVUEc1Qm5uTGxiSVNQZzQ2?=
 =?utf-8?B?RzVyTGtlOHNtSmZZQnFNd0kzdmc0bmQ2UTZDZ2g0cUpYL2ozUkR5THZKZjU0?=
 =?utf-8?B?ckxEVzBnbmErVWozZkx4YlRGYVpyTUtVVlV5czZHQXliZFYyWm9YNEFCM2lu?=
 =?utf-8?B?K0w4dEdvZTBKU3RoMUJqdmdSYWNPMlZhZ2I3eU0wbzdWZ1g3dXh0dk9YSFp3?=
 =?utf-8?B?OEdPcG90blpDNENQVStkdVJ3UFZtUk51V2FNYTFDZFA5NGFjckVKUjNUYmpS?=
 =?utf-8?B?L3ZoZndEU1YvYUo0K3lyVkdjdmp4WUJMTVFweEV1Vm1Tb2lLUHQ0YTVKRUZ2?=
 =?utf-8?B?dFM0WnE2MUF2Q3dQUDZIMzNYZGtrRjhuMk45TTJMS1BGQm1XUVltcEtuYmVi?=
 =?utf-8?B?aVlDOXFBa0lDMkhKYnZXM0hKQ2tFYlhkQmxBZmFvdVBUSHN4VzNta1EwSko0?=
 =?utf-8?B?RlBJcDN4VFcvZnVFeTBsUjcwWitRNno0cjBObDc4bVMxQ0dWUDRwWG9JemND?=
 =?utf-8?B?ZWZYWEEva0VGeWNKbjRrMHRmREVsMUhreU5xM2hYQkVHRHJ2QlcvamtLODEy?=
 =?utf-8?B?QTVyc1hoOEt3TUZ1OWRocFIrdWNsLzk5M3RKU0VBZ1JraU9kMHBka3dYQ1g4?=
 =?utf-8?B?d0VyYjV0VzdOUVpsWThrYjhvY2dGVVpNUm9tUENVaExHcnA3VVpncDczV0l2?=
 =?utf-8?B?aVhZeWk5MzM2REdJekdodFkwOGYyL3VmQ3grMzMvM0MxVm54RTRHZUdEbWcr?=
 =?utf-8?B?M3RmeFNicEhOeStBVlFJYVRRODlkZDhtclMrdUZOZmNsUTdFREJ5eE5oUlBK?=
 =?utf-8?B?THgzWUF2L2ZIVjlTTUxDU2Mvdm1aRGhlT01NM0lsdkMxMkRpYlJvSlg4NVFX?=
 =?utf-8?B?cVQrOTBuem1SVDFleS9pT3hzMjhkYUVFcCtwYkZGajRONDhPUmliVUk1cjR0?=
 =?utf-8?B?N1dpaVFQZnBESlQ4aGFLS1A2cHlsSGd6d0k0bzExdnRLZUNsODNQWmpYdkM4?=
 =?utf-8?B?YVVwS2huSFlOR01vdEhpa3FUa3gyU2RkbEpaMDVyRG0xcGlRWkZHdXUwMDFL?=
 =?utf-8?B?b2hvMDJqUDQ1VDl4TGdjWWxhRnhvTkMzOWNiQk5OdWxSNkl5b3J0SUVMZ1Vm?=
 =?utf-8?B?bWN5eDQzZDgrVVF0NWo1OFFXOEFYbG1zOWlhQkVhS0xSR0hNYi9DZEI5aXJV?=
 =?utf-8?B?Q2M5VXNWb3E5UkFvL2N1TnAvcHR3ZllFWjJOMk0vdi9hTkJyb3hUV2JNbTVC?=
 =?utf-8?B?UFZsSTJkUmFmUzQ5S0R0MGR1WW1xcExzZXRGMS9RRGxIM0t2U1ByTDZMbVY2?=
 =?utf-8?B?a09mWktPZzlnelVOcHIyMGJOSEJwVnU2cW12TXpDdTZaTzZPem8vMEsxZkJC?=
 =?utf-8?B?T3VQK2E3bXRRTXV1QjRlejFhMFFnVUc0QXhHZkdtWklxNGxQaUtlWHNJUjc1?=
 =?utf-8?B?VkRGSnRFY0NMeStESExTS0pBRElPRHhOQVU2cVBEOTZXV1I1dVYyYytsdmtz?=
 =?utf-8?B?N1ZvanVyU1hyeWlOeExOY2Z5aWlOeU5qU2VrK210MEc2ZnJ0VTZEMzRtc1VU?=
 =?utf-8?B?emhET2d2QmNzeXNHbGlNWlhmZHIxemw3ZFQxN0FFVFREcFg1WDlXNms4Wmcx?=
 =?utf-8?B?NlEybHhPQ2IrUGlNWkhhbmtNd3FaNDg4K2dGRVphYS9XVUROTkp0MXRuUTIz?=
 =?utf-8?B?MG14elVxL3NWdURzc0VqL1htQWM1T1VrVW81ek9RUWdWN091c0VSWU55cHZ2?=
 =?utf-8?Q?ZE7cuA?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2025 09:33:32.4052
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e899038-2151-444e-e523-08dddfcca10b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA4D.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7971



On 8/20/2025 5:18 AM, Sean Christopherson wrote:
> Fold the remaining line of sev_es_vcpu_reset() into sev_vcpu_create() as
> there's no need for a dedicated RESET hook just to init a mutex, and the
> mutex should be initialized as early as possible anyways.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Nikunj A Dadhania <nikunj@amd.com>

> ---
>  arch/x86/kvm/svm/sev.c | 7 ++-----
>  arch/x86/kvm/svm/svm.c | 3 ---
>  arch/x86/kvm/svm/svm.h | 1 -
>  3 files changed, 2 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index ee7a05843548..7d1d34e45310 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -4577,6 +4577,8 @@ int sev_vcpu_create(struct kvm_vcpu *vcpu)
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  	struct page *vmsa_page;
>  
> +	mutex_init(&svm->sev_es.snp_vmsa_mutex);
> +
>  	if (!sev_es_guest(vcpu->kvm))
>  		return 0;
>  
> @@ -4592,11 +4594,6 @@ int sev_vcpu_create(struct kvm_vcpu *vcpu)
>  	return 0;
>  }
>  
> -void sev_es_vcpu_reset(struct vcpu_svm *svm)
> -{
> -	mutex_init(&svm->sev_es.snp_vmsa_mutex);
> -}
> -
>  void sev_es_prepare_switch_to_guest(struct vcpu_svm *svm, struct sev_es_save_area *hostsa)
>  {
>  	struct kvm *kvm = svm->vcpu.kvm;
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 8ed135dbd649..b237b4081c91 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1244,9 +1244,6 @@ static void __svm_vcpu_reset(struct kvm_vcpu *vcpu)
>  
>  	svm->nmi_masked = false;
>  	svm->awaiting_iret_completion = false;
> -
> -	if (sev_es_guest(vcpu->kvm))
> -		sev_es_vcpu_reset(svm);
>  }
>  
>  static void svm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 321480ebe62f..3c7f208b7935 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -829,7 +829,6 @@ int pre_sev_run(struct vcpu_svm *svm, int cpu);
>  void sev_init_vmcb(struct vcpu_svm *svm, bool init_event);
>  void sev_vcpu_after_set_cpuid(struct vcpu_svm *svm);
>  int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);
> -void sev_es_vcpu_reset(struct vcpu_svm *svm);
>  void sev_es_recalc_msr_intercepts(struct kvm_vcpu *vcpu);
>  void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
>  void sev_es_prepare_switch_to_guest(struct vcpu_svm *svm, struct sev_es_save_area *hostsa);


