Return-Path: <kvm+bounces-55095-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7ED5BB2D37C
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 07:32:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3BD7B17E395
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 05:32:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A418F2853FD;
	Wed, 20 Aug 2025 05:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="elvP4cR8"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2045.outbound.protection.outlook.com [40.107.223.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41ACB1400E
	for <kvm@vger.kernel.org>; Wed, 20 Aug 2025 05:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755667919; cv=fail; b=X8+cxCiIiEL4R5mKax/PXjlLtF7I3ZnrgIlLj6lc4wIUDcJLzHoKbkGfyRJbAAQwnnPzEx7Cp+FuTEn6gy7Hjam3MAfzTpbgDBYu92rtQUxx9RAiV2SIq45HKF5ciNFLBrK3rp0huSqa43H28bDZb7oJphE0NIp4mwFCLlIk5zc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755667919; c=relaxed/simple;
	bh=OV8PfJUeNDNtkzSPCOhnIEczeIVZde1QS/Tal0r6uhU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=pUDdN/JN4DxqkHvitXRukm1ne6VdPXk/O1nupgCOBJiEGfPe5L/+6ynbuza40QHiD/OVzbxuj/tMW5XCCTJkon/H/mgbNxnhj/izXN7U6Tz/4q68JrI2dEmU59sT7yxPv/wLrz/QBeyHDvC6giv/yrctU7zQJWUzsYqbXoLq7/U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=elvP4cR8; arc=fail smtp.client-ip=40.107.223.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qO4fcAauOIAfVx3Uj1U1PKZYE9F4+Os8bA8bvo9+Ejjo0XbUmLB0sFSnQ51UijMvsJ7vxQkmnB9uJa2V8ogIdNpIInsDOO4hnGuCxqL+AnJpCStuHy9Q0p6WLKk+Bl58KIUheU/5YLsmnifq+Yqq7+/DKaGTMGb3LzvqcdNVwj1gbDoWX5a2GUKkZ5ePtj+jM2V07enymCJ8lmUMOHQ8dpNB0Uv6ajG9e3SHnPWzp+OWLCnj5Mjh4c/RwWx+Pg0KCaTjYaloOgZ2m76HVgbjGdbeDi9CGZ9gMlKUbRi4CtP2PBnVWlOmFANix8WxFujKx3ubI5r9FgHBDOWrZoxcUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=24e6C9VDZnF3paZ2WIazW4ow0RjEtUK8lcn3KM1LUqQ=;
 b=bkboJObc3OCv6ZjaWKwQB7i6SALORCoAwnrkEafM6y2bMnAN+PcrHE/OIwPBrrdZ12gIh6I2wpiFjh2o6q25JKq27CIw++5HGVW+TlwDwVIvWH/AM/YTZvjXTLqRatd6GeEGXdd8byxoM2yXUxXoSEwBBzKZ0raIYmq+TW5QO8WOyLozMZYuZshjZ4igN9gFCup4ZiZ9NvN6iZ2AKaOvgXrLi44QFiPZz98CTDigaRabyOA1eRO7PCpL6zSH+Rh7rzMfBSoz+eghdjEQiBffIHdBHGC7cR+z8dqOgsJiSgu/4giQRNqXgFpCdcT02VvKcssUjoykrjcvdRDk/wxUeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=24e6C9VDZnF3paZ2WIazW4ow0RjEtUK8lcn3KM1LUqQ=;
 b=elvP4cR8G7xxApUuuRuLvYFauCXa9Ep9zUnwRbUzMwLjGepEQjOoOXo+EXMEymgNbbLHhoDMMJqSmFqVegRzaVmNqyAiCA9Uq0Lc3bQcv2K4XV+tDV0OEtLCcSTY8Y+1VfVFfNE+OQTFHYq2aIVm2GACLRpsqIJLON7VkbfmhuI=
Received: from BY3PR05CA0035.namprd05.prod.outlook.com (2603:10b6:a03:39b::10)
 by DS0PR12MB8246.namprd12.prod.outlook.com (2603:10b6:8:de::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.14; Wed, 20 Aug
 2025 05:31:52 +0000
Received: from CO1PEPF000044F8.namprd21.prod.outlook.com
 (2603:10b6:a03:39b:cafe::1a) by BY3PR05CA0035.outlook.office365.com
 (2603:10b6:a03:39b::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.13 via Frontend Transport; Wed,
 20 Aug 2025 05:31:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1PEPF000044F8.mail.protection.outlook.com (10.167.241.198) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9073.0 via Frontend Transport; Wed, 20 Aug 2025 05:31:51 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 20 Aug
 2025 00:31:50 -0500
Received: from [10.252.207.152] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.39 via Frontend
 Transport; Wed, 20 Aug 2025 00:31:47 -0500
Message-ID: <7b7de6f5-38ea-4b78-bf83-4f5c9138409f@amd.com>
Date: Wed, 20 Aug 2025 11:01:41 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 2/2] KVM: SVM: Enable Secure TSC for SNP guests
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <kvm@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<santosh.shukla@amd.com>, <bp@alien8.de>, <isaku.yamahata@intel.com>,
	<vaishali.thakkar@suse.com>, <kai.huang@intel.com>
References: <20250804103751.7760-1-nikunj@amd.com>
 <20250804103751.7760-3-nikunj@amd.com> <aKTDBMCPxOXQhzDq@google.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <aKTDBMCPxOXQhzDq@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Received-SPF: None (SATLEXMB03.amd.com: nikunj@amd.com does not designate
 permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F8:EE_|DS0PR12MB8246:EE_
X-MS-Office365-Filtering-Correlation-Id: a55b09f3-27ec-491c-fe81-08dddfaadde0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QlEwVTZJSTFEVk11S21zaUVsaXUwdWtMakU1QjRYOXFOM28vbHRLSGxVeWhi?=
 =?utf-8?B?b0xwcVhjbjdpVHFyRElxdmszdUNiSmFtdE9NQXlRVTZFQWFxWEdOZzFNZjls?=
 =?utf-8?B?MDdkbXkzZWpVcjQrSjV6bzZhUzZ2c1BscWVPMEVWa3Rhc1NUODd6dDM4d0RU?=
 =?utf-8?B?NmQvNktnVEx6cHBhNVZGTS83c3pacWpVdUxONW1rK213T0dISW1Cc1ArRU40?=
 =?utf-8?B?V2ZuNTFNeDRyVGczOEQrSUlyelo3RkNTaGVPaGxRNzJPczM3clBxTlk0MElF?=
 =?utf-8?B?d3dlNERPVnVBTjVHQVN4b2s1ZjU5cGEvdVpvWmF3VDQyVXZnc0R4WFpkZ09U?=
 =?utf-8?B?ajFwbG9nUm96YUhnQlExdnJ2Y082LzdMTkFlZzlNbGNIQlpNeW9BYjZnSGJH?=
 =?utf-8?B?RlFJQStnM3RVMVo4N0owd2l2SEV5azNBT282QmRoV1ZVTDkyQ21vQU1pSmU2?=
 =?utf-8?B?eVd2c2dKSXp1YWVlSU41Y0lLK0liQWY1U2dGaGtpeWRBTUdXWlJDQUlILzUy?=
 =?utf-8?B?T21MbGdpT3QyeTJKaWs4WTV2eUNNeWFnZUxXZW9wRkt2RU1sdVVWS3ZhdXc1?=
 =?utf-8?B?eU03VlExYm42MzNkZzVvZ1RHRlUvMGRxbXplSGFReGl5ejFDdXU0UWNtVWkw?=
 =?utf-8?B?dW1Ed2R3UEpObWpMSllIZ2dRU1orNG5EcElYMTJqbzFkNVVGek1DaVhhcmQv?=
 =?utf-8?B?eXAvK0szS2ZCTE9CcE5OdmlwdW1mdEw4NWtBbTNGdGVUbXcvZllzV3hMS2Zv?=
 =?utf-8?B?UGlrTm11MjJUU1NGYXc1ZHlCQ20vNXZkelRwSDZWaDNDbDFZRHFZZk1vK1d4?=
 =?utf-8?B?bTVkeDhzNVJxSXZLQm9nWGIxY2l0U0lrTG4yVC9lWkVqZk41YWxYNWtXYkZl?=
 =?utf-8?B?SUgxTXZYWFN5VmF3ci9rVENsNjVIR3diU2lmOG82d0J1alJMcHZBSzYrU1pN?=
 =?utf-8?B?Y1lZZVo5RDZXY1hhVTZJNkVjSXVSYWFzNkhOei90ZTVBOGRacC8zaWo2aElP?=
 =?utf-8?B?cTF2SmlVb3ZMWEQrK2JmYVo1YW9BcHhmWGM4eDQ0V0xMVmFGZGJ5UkJkcFZo?=
 =?utf-8?B?WXdHcVA1TG5nY3JzamhjellXR1lMV0lERjJxY01oS1plVzc4MU1PMFE2SFdD?=
 =?utf-8?B?OVhWb05keHh5NGJ2dzdRVmlIUm1NRXBOeWpIVHd5MXhQc2hEU1RzaEVzQVV2?=
 =?utf-8?B?TlMyYlhyVStLbHMzSDZUS0d4cktBelF6a21zdDlxZkpGd3ZNTVFudDc4Qkdp?=
 =?utf-8?B?L1daYjk2N3h3Nk14MHdZSG1xVmYxeTM0YlorTlJHKzd6T0tnUUlNYll0OHR4?=
 =?utf-8?B?RktZSUM3M2lTN21NN0NOdk9RMzZhZ0t5Y2JCZG9YRkpmMG9hUzJmazhCS2ZS?=
 =?utf-8?B?bGtib0o3SElTeTFhMy9TR1NxZE5CKzY2VlFNakozRkJFS0xxTDZSa0FmQ3Jj?=
 =?utf-8?B?UjR3K0RNb29mcmNsMHlybzdRcitMYVRqaVFLWFBjeWpHejErcCsrWEc3ZVBH?=
 =?utf-8?B?cWNEbEdwUjcweFhpaFZ6NEkrNm1Wb0JsY000dWJ5dUJZa2ZOM0h5Y29hUStD?=
 =?utf-8?B?Zm5BYWxEcm1JWm9XMXkxaExjaVBBaCtZVTZiQUkrOU9PZ1Y4VzNuTTJvWWNa?=
 =?utf-8?B?ekJjb0hjY0hQTUpuTlMrd0M4ZXVZdFFsamdOQ3c2NDdENHhubkNkTVVqV01X?=
 =?utf-8?B?M3pJZ1dTRFYrUnRrSXh1YkN5MXR5SW9EazVsV3hCdUNobXg0bkFENlU1NHdj?=
 =?utf-8?B?NUxYdkdVWk1MY3dGN1R0ZXBRdDBJMllIdVFYa2RhYzc4UGo5UlovYWs0dWxT?=
 =?utf-8?B?THVmUkw2amZJMGFST2c1Ujl1WUtJYVZHcEh3MlE2cXFUTlhaV0kyY0FDdlR1?=
 =?utf-8?B?clJjUEFrSXFaU1U5M0d4WWpmblFqVHRGWjFmQ0dXckhIY3J0R1pRL3NQSmNW?=
 =?utf-8?B?OXlBUVh0N2RzZWlrdzVZVDljRklkeDB3aHZEZnN4YytocVNkTFlqellmeWZl?=
 =?utf-8?B?U09KQTZTTHQ1K285UFFNbExkbFozSUIxeTZjUE8yM1lvSnh0M0xHUHJPTDNI?=
 =?utf-8?Q?uYKETQ?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2025 05:31:51.5076
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a55b09f3-27ec-491c-fe81-08dddfaadde0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F8.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8246



On 8/20/2025 12:01 AM, Sean Christopherson wrote:
> On Mon, Aug 04, 2025, Nikunj A Dadhania wrote:
>> Add support for Secure TSC, allowing userspace to configure the Secure TSC
>> feature for SNP guests. Use the SNP specification's desired TSC frequency
>> parameter during the SNP_LAUNCH_START command to set the mean TSC
>> frequency in KHz for Secure TSC enabled guests.
>>
>> Always use kvm->arch.arch.default_tsc_khz as the TSC frequency that is
>> passed to SNP guests in the SNP_LAUNCH_START command.  The default value
>> is the host TSC frequency.  The userspace can optionally change the TSC
>> frequency via the KVM_SET_TSC_KHZ ioctl before calling the
>> SNP_LAUNCH_START ioctl.
>>
>> Introduce the read-only MSR GUEST_TSC_FREQ (0xc0010134) that returns
>> guest's effective frequency in MHZ when Secure TSC is enabled for SNP
>> guests. Disable interception of this MSR when Secure TSC is enabled. Note
>> that GUEST_TSC_FREQ MSR is accessible only to the guest and not from the
>> hypervisor context.
>>
>> Co-developed-by: Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>
>> Signed-off-by: Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>
>> Reviewed-by: Kai Huang <kai.huang@intel.com>
>> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>> ---
>>  arch/x86/include/asm/svm.h |  1 +
>>  arch/x86/kvm/svm/sev.c     | 27 +++++++++++++++++++++++++++
>>  arch/x86/kvm/svm/svm.c     |  2 ++
>>  arch/x86/kvm/svm/svm.h     |  2 ++
>>  4 files changed, 32 insertions(+)
>>
>> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
>> index ffc27f676243..17f6c3fedeee 100644
>> --- a/arch/x86/include/asm/svm.h
>> +++ b/arch/x86/include/asm/svm.h
>> @@ -299,6 +299,7 @@ static_assert((X2AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == X2AVIC_
>>  #define SVM_SEV_FEAT_RESTRICTED_INJECTION		BIT(3)
>>  #define SVM_SEV_FEAT_ALTERNATE_INJECTION		BIT(4)
>>  #define SVM_SEV_FEAT_DEBUG_SWAP				BIT(5)
>> +#define SVM_SEV_FEAT_SECURE_TSC				BIT(9)
>>  
>>  #define VMCB_ALLOWED_SEV_FEATURES_VALID			BIT_ULL(63)
>>  
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index e88dce598785..f9ab9ecc213f 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -146,6 +146,14 @@ static bool sev_vcpu_has_debug_swap(struct vcpu_svm *svm)
>>  	return sev->vmsa_features & SVM_SEV_FEAT_DEBUG_SWAP;
>>  }
>>  
>> +bool snp_secure_tsc_enabled(struct kvm *kvm)
> 
> snp_is_secure_tsc_enabled() to make it super obvious this is a predicate.

Ack.

> 
>> +{
>> +	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
>> +
>> +	return (sev->vmsa_features & SVM_SEV_FEAT_SECURE_TSC) &&
>> +		!WARN_ON_ONCE(!sev_snp_guest(kvm));
> 
> Align indentation.
> 
>> +}
>> @@ -4455,6 +4479,9 @@ void sev_es_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
>>  					  !guest_cpu_cap_has(vcpu, X86_FEATURE_RDTSCP) &&
>>  					  !guest_cpu_cap_has(vcpu, X86_FEATURE_RDPID));
>>  
>> +	if (snp_secure_tsc_enabled(vcpu->kvm))
>> +		svm_disable_intercept_for_msr(vcpu, MSR_AMD64_GUEST_TSC_FREQ, MSR_TYPE_R);
> 
> I'm leaning towards:
> 
> 	svm_set_intercept_for_msr(vcpu, MSR_AMD64_GUEST_TSC_FREQ, MSR_TYPE_R,
> 				  !snp_is_secure_tsc_enabled(vcpu->kvm));
> 
> because the cost of setting a bit is negligible.
> 

Ack.

>> +
>>  	/*
>>  	 * For SEV-ES, accesses to MSR_IA32_XSS should not be intercepted if
>>  	 * the host/guest supports its use.
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index d9931c6c4bc6..a81bf83ccb52 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -1317,6 +1317,8 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)
>>  
>>  	svm->guest_state_loaded = false;
>>  
>> +	vcpu->arch.guest_tsc_protected = snp_secure_tsc_enabled(vcpu->kvm);
> 
> Hmm, we can and should handle this in sev.c.  If we add sev_vcpu_create(), then
> we don't need to expose snp_is_secure_tsc_enabled(), and we can move more code
> into that helper.
> 
> I'll post a combined series of this and the GHCB version patches.

Thanks, I will test and get back on v11.

Regards
Nikunj


