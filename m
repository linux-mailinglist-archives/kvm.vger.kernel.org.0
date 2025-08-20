Return-Path: <kvm+bounces-55108-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D307DB2D770
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 11:03:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 70BDE3B4E13
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 09:01:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1FE4296BA8;
	Wed, 20 Aug 2025 09:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="l1ceEV87"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2083.outbound.protection.outlook.com [40.107.94.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65413227563;
	Wed, 20 Aug 2025 09:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755680469; cv=fail; b=AA1ZrckgLXb965T0ZgrNfnng7UHhHJ2knB0Tl+PjgV/r1ppaVfguJm3psACeUyvu4tHrH4pIJUWKQ8fYqkBSaOpgHlgGzdGjXEQCep1VO77ccMVZGi0+mml/Df4UkZhUKEi8rrDTiYwkBZrZT6ObhaTRewOQVOfix0l0Aqbv+ZQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755680469; c=relaxed/simple;
	bh=Gim44vDGdVJ8pLZx42eZYAJVmVNTLd42vBtZJTITOpw=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=gn4YhZ4MWYrMA8ohq/jIkoXc9zdD4moecMINZNEJlNnMnQcMBhZc2nrC1pf5Emqal9b5LYm7RgfnBG8yrTDx+0QkyY9uXdkwf+9Q1SFqNrn3j9dZPTWBg4HTPt0fP4+ApS6vMwWfOR2tqje/ZxXFYLTA4QcLwgD1d8yAOYNTl+g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=l1ceEV87; arc=fail smtp.client-ip=40.107.94.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VQRIO2B9wOwN5KTSdlGM3Z3F9gz3A1SHWt/HlVNbY8OfDpn/eAaZ+vF5rTnQty8XmyhLRR86ZpvM+obbRKamHMCFc/u+fFZDjkJeyCT0ZIxgLPLzjqo70Rj/Cki7TXFEHYAikjBbigbY3NOISttCt+Jy13UNFv/M355OOMKqN/L7xj/E3yTskJaZTcGNRZefO4jvoBJTZ1sHjj+zfT2ocDaO2aroZszfK0x+t1aOzpZsn+H/Jx5CTRymLmFFURZT79q1mox4lAOMxIT7ucLKIOd/8emLmQAMP8fdz5DHnzFtpkG/jkTdww8nyfioKbBgIGUEFlyY8C1ELWNhnXx+IQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p9PniNIsBFPI9uyFkByCKrFbl4ZIy0NNAq6yXea4cik=;
 b=udJaqFVg73qaSnU38rjcIG33I9SLM+3eajjU0cOEVqXLqdIIe7auglDwzMgeEtsdIhwbRsnGLBnHuMCWrWnPifKNox/g7lHirObeOVXzP91Mlies8MfxuiHPOsb+XDCpMBtxty+TyDpOX+9aOyiIU+/8rwDEboGFhrjtdHrTUQQ/V+0FpP/MYTztft5e3OGwVapx0erfPJHYw+keKLepnQtoBwcHBb8euyAcywBns7bHph02W1e2Od8qH0jxMuCFZTEDOt02+zA7hbLVABWhopWWXB+TifHGtIIoVXSRrVWAMyvcgQVZ/LnY8F2gQsXrgiNcFf/U/wzLhzGvuJoNwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p9PniNIsBFPI9uyFkByCKrFbl4ZIy0NNAq6yXea4cik=;
 b=l1ceEV87JEksPmhMf980dsJoik23vJc4TlP20K5h1zOULu8n5+cmcHUQi3VWcO1ndw587R/i+ARBMlnWinGnYEkTikrxYGMD4pBHevw4hveQaTOUTMkVZ0HKUNUCP8QHj+BqXbnootjTRqE7isWJIEvlINvK0VinON6V19e53W4=
Received: from SJ2PR07CA0006.namprd07.prod.outlook.com (2603:10b6:a03:505::18)
 by DS7PR12MB9501.namprd12.prod.outlook.com (2603:10b6:8:250::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.14; Wed, 20 Aug
 2025 09:01:01 +0000
Received: from SJ5PEPF000001EC.namprd05.prod.outlook.com
 (2603:10b6:a03:505:cafe::e2) by SJ2PR07CA0006.outlook.office365.com
 (2603:10b6:a03:505::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.14 via Frontend Transport; Wed,
 20 Aug 2025 09:01:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001EC.mail.protection.outlook.com (10.167.242.200) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Wed, 20 Aug 2025 09:01:01 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 20 Aug
 2025 04:01:00 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 20 Aug
 2025 04:01:00 -0500
Received: from [10.252.207.152] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.39 via Frontend
 Transport; Wed, 20 Aug 2025 04:00:57 -0500
Message-ID: <25b39485-4c3e-4bd2-8cbc-f4ae67fcd82b@amd.com>
Date: Wed, 20 Aug 2025 14:30:56 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 4/8] KVM: SVM: Move SEV-ES VMSA allocation to a
 dedicated sev_vcpu_create() helper
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Thomas Lendacky
	<thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, "Borislav
 Petkov" <bp@alien8.de>, Vaishali Thakkar <vaishali.thakkar@suse.com>, "Ketan
 Chaturvedi" <Ketan.Chaturvedi@amd.com>, Kai Huang <kai.huang@intel.com>
References: <20250819234833.3080255-1-seanjc@google.com>
 <20250819234833.3080255-5-seanjc@google.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20250819234833.3080255-5-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001EC:EE_|DS7PR12MB9501:EE_
X-MS-Office365-Filtering-Correlation-Id: 3477bf2d-eb27-472e-3f9d-08dddfc8164b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?R2NLek0yMHVvQ1QzTW1kTjFxYzY5SlplOEVZVkhxaTJmYkZhYzRDbFhvcy85?=
 =?utf-8?B?SWdaVUc1dTZaTE5USkh2eE53OTltUnR4U3l4bDV2VU5rcCtwUVlSdWhwcUlk?=
 =?utf-8?B?RzhhU1RUbTRvTkcyajZFTXo5emtLTEViZUNYbndEWWJYeG9ZbVJpREhsOExp?=
 =?utf-8?B?Q3hRZ3R2UE1oelM2RkR6eS9HLytRd0tlVWovcUw5bFpPZm12WDBBNjBUdzVP?=
 =?utf-8?B?bnhObXBnTlVPU2FHYWVxODV6TVUyUjRsV1JzTWVqR0RFWFFXNHF0SnBtdjFJ?=
 =?utf-8?B?NjNpcjJmNnlzZFRRbzhLcXlpZnMyVUVEYnZFZmRjSHM1WEJJS0F0SDFUM1dW?=
 =?utf-8?B?U203enlWRXB1Q1I3M2J6dk1wTkYxM0F6UmtEMGt2VHl1dlpNeHRWVTZwYnZY?=
 =?utf-8?B?d01UVFRuZE9zVEd3MGZ5NHprZmw5U0hFQ2tOOW15MTRodkJ0TmJXUWNIcVhT?=
 =?utf-8?B?dnZ1RVdtT3Q1M2xCenhwMmlzajNDY290Tm1zdUp0amRxTFZQWUwvMEVUeXJG?=
 =?utf-8?B?Z3VYQWNGaURrUFVIWUdhcC9XWmJSeE1CMTFCRk1tOG5ESVZySGp5QmhMWnN2?=
 =?utf-8?B?NFRnQm1GTmFubkVheE01bUN1RnFNTVFZZkltcEVLRlA1aGpWaTZVTHJrZ05U?=
 =?utf-8?B?TitJR2EvRkQ5ZHBKaFlmRUZvNFRUc1dTaTJxU1VqS1NNQlpVYk1zVy9KbHdW?=
 =?utf-8?B?Tlo1RW1RY2wxaXdEZXdJSklyckFCaWw4RDh3aXpTYld1U2laVE9qVThvK1hQ?=
 =?utf-8?B?NVZQYURkVzEwaHI4Sk8wU0NJalVWejRRN0swSVJ1QlNUT1BxVUt1clhPbnp1?=
 =?utf-8?B?WmpQTXpYSDdCQUt6bjJQWU9LUVhCbkdLdGlIUCtJa0lWbC9wUHpUTEs3KzZq?=
 =?utf-8?B?NEZud1pFcG1IWWVGK3NKNUZEcUNRRzYvSkFVTjBuMVl5ZHM1V3B3RG55Rk9D?=
 =?utf-8?B?cVRDZkxxYVlTVmdacVVZTXI3ZU9Kam9VNnlLdk9zZGdTdHJDQ0pad3dqRXFj?=
 =?utf-8?B?TXRhSiszdHRHUDFOeFlXYVYvZU1mTkg3ZFdqRkFENXBXVVVKTUZ4Y3lGVmE4?=
 =?utf-8?B?RjdqNDFwNHFYaGtGeTZVbDk4ejdhTWRuMmkzSUFveUx2MXZYQjZUWHBxMVVr?=
 =?utf-8?B?V29RVUZORWZQeU1FS200c1MzUzBQQWRTME5FeDhDVnVoaXJzaE9FZSs0SEp0?=
 =?utf-8?B?VTdYVmZKbFFzUFhIeFFydDRURTFTSy8yNVhBZk9hdWNGQ3FWNTVUNytQOEIy?=
 =?utf-8?B?Zjg4MkhwMVN1eklqUnJvVmNkSHg3d0ZUZ20yc0NNd1F6ejVEMUl5UHZ2YjFJ?=
 =?utf-8?B?djFUeTlxdE9PMTJWamNmWUNzQW05cnl3TFV5SzJnSGhzcGFwQm12ejNqeDRx?=
 =?utf-8?B?TXVJandpSEt1MElhUzlLdVhkVHFlUjlTMFM0R29RMm5xdzFmWUxmaVpHZHUy?=
 =?utf-8?B?aFBGMElIVkFBN1BGRW1Bd2hQb0tqMXMvV2J3YWJTSEpuWmErL3dYMVVWV2Vu?=
 =?utf-8?B?OWJ2RGVWRlpjaVZJSTdrZ1lMc0xFM1VnWWFTeEFXaUlvK21FUEIyVHM3Yk43?=
 =?utf-8?B?NnhwbjVKODg2TXBUNG4xQXdvZFJmN01QU3I3K0JRV052ZEpMaTBQM2xuSnh0?=
 =?utf-8?B?ZjlkanRaSFpJcUo4dGxjb1hHdUlnM2lxZGRKS2UxMGRiMDJYQWQyeWxxN21m?=
 =?utf-8?B?eEF6bytNUDkxK3MrZkF3M25COFk5VXlnUFRHMEFXYVFaR0tMb1NmbE16MDha?=
 =?utf-8?B?VUwxZW81am94VUZjT1huVTBaRTkrU2JpZ1J1Q3BmYlhEUzY3ZmJnZG4yZDl5?=
 =?utf-8?B?dGo2SkI1bzk5RExxYjd2ZEE2TnBiSCtHZEJCbTdua0Q1TWU2L1BKUTBjUFJW?=
 =?utf-8?B?Q2RrSTRmUXJYRnpvckdSeW9XUzRqdVVqUE5mVVFYcWxra09WNFNSaThpNS9B?=
 =?utf-8?B?QmtrSnJVM2NHRTFMeXZtRVJoMHE0UUxPQ2J0VnpsZWNPSzVLZUZ1eWQvQUhE?=
 =?utf-8?B?ZVNwVXhSVFk5ZjVIQmdTSDVSTWtpMXFMREZleE5RUDlQTzlXeEIvTFRYT3ll?=
 =?utf-8?Q?Wm7P1g?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(376014)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2025 09:01:01.5625
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3477bf2d-eb27-472e-3f9d-08dddfc8164b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001EC.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB9501



On 8/20/2025 5:18 AM, Sean Christopherson wrote:
> Add a dedicated sev_vcpu_create() helper to allocate the VMSA page for
> SEV-ES+ vCPUs, and to allow for consolidating a variety of related SEV+
> code in the near future.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Nikunj A Dadhania <nikunj@amd.com>

> ---
>  arch/x86/kvm/svm/sev.c | 20 ++++++++++++++++++++
>  arch/x86/kvm/svm/svm.c | 25 +++++++------------------
>  arch/x86/kvm/svm/svm.h |  2 ++
>  3 files changed, 29 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index e88dce598785..c17cc4eb0fe1 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -4561,6 +4561,26 @@ void sev_init_vmcb(struct vcpu_svm *svm)
>  		sev_es_init_vmcb(svm);
>  }
>  
> +int sev_vcpu_create(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +	struct page *vmsa_page;
> +
> +	if (!sev_es_guest(vcpu->kvm))
> +		return 0;
> +
> +	/*
> +	 * SEV-ES guests require a separate (from the VMCB) VMSA page used to
> +	 * contain the encrypted register state of the guest.
> +	 */
> +	vmsa_page = snp_safe_alloc_page();
> +	if (!vmsa_page)
> +		return -ENOMEM;
> +
> +	svm->sev_es.vmsa = page_address(vmsa_page);
> +	return 0;
> +}
> +
>  void sev_es_vcpu_reset(struct vcpu_svm *svm)
>  {
>  	struct kvm_vcpu *vcpu = &svm->vcpu;
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index d9931c6c4bc6..3d4c14e0244f 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1275,7 +1275,6 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm;
>  	struct page *vmcb01_page;
> -	struct page *vmsa_page = NULL;
>  	int err;
>  
>  	BUILD_BUG_ON(offsetof(struct vcpu_svm, vcpu) != 0);
> @@ -1286,24 +1285,18 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)
>  	if (!vmcb01_page)
>  		goto out;
>  
> -	if (sev_es_guest(vcpu->kvm)) {
> -		/*
> -		 * SEV-ES guests require a separate VMSA page used to contain
> -		 * the encrypted register state of the guest.
> -		 */
> -		vmsa_page = snp_safe_alloc_page();
> -		if (!vmsa_page)
> -			goto error_free_vmcb_page;
> -	}
> +	err = sev_vcpu_create(vcpu);
> +	if (err)
> +		goto error_free_vmcb_page;
>  
>  	err = avic_init_vcpu(svm);
>  	if (err)
> -		goto error_free_vmsa_page;
> +		goto error_free_sev;
>  
>  	svm->msrpm = svm_vcpu_alloc_msrpm();
>  	if (!svm->msrpm) {
>  		err = -ENOMEM;
> -		goto error_free_vmsa_page;
> +		goto error_free_sev;
>  	}
>  
>  	svm->x2avic_msrs_intercepted = true;
> @@ -1312,16 +1305,12 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)
>  	svm->vmcb01.pa = __sme_set(page_to_pfn(vmcb01_page) << PAGE_SHIFT);
>  	svm_switch_vmcb(svm, &svm->vmcb01);
>  
> -	if (vmsa_page)
> -		svm->sev_es.vmsa = page_address(vmsa_page);
> -
>  	svm->guest_state_loaded = false;
>  
>  	return 0;
>  
> -error_free_vmsa_page:
> -	if (vmsa_page)
> -		__free_page(vmsa_page);
> +error_free_sev:
> +	sev_free_vcpu(vcpu);
>  error_free_vmcb_page:
>  	__free_page(vmcb01_page);
>  out:
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 58b9d168e0c8..cf2569b5451a 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -854,6 +854,7 @@ static inline struct page *snp_safe_alloc_page(void)
>  	return snp_safe_alloc_page_node(numa_node_id(), GFP_KERNEL_ACCOUNT);
>  }
>  
> +int sev_vcpu_create(struct kvm_vcpu *vcpu);
>  void sev_free_vcpu(struct kvm_vcpu *vcpu);
>  void sev_vm_destroy(struct kvm *kvm);
>  void __init sev_set_cpu_caps(void);
> @@ -880,6 +881,7 @@ static inline struct page *snp_safe_alloc_page(void)
>  	return snp_safe_alloc_page_node(numa_node_id(), GFP_KERNEL_ACCOUNT);
>  }
>  
> +static inline int sev_vcpu_create(struct kvm_vcpu *vcpu) { return 0; }
>  static inline void sev_free_vcpu(struct kvm_vcpu *vcpu) {}
>  static inline void sev_vm_destroy(struct kvm *kvm) {}
>  static inline void __init sev_set_cpu_caps(void) {}


