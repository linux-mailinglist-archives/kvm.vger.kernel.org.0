Return-Path: <kvm+bounces-55110-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1ADA6B2D82F
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 11:29:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 156A3162339
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 09:25:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97BA42DCF7D;
	Wed, 20 Aug 2025 09:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ChoT+5VP"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2084.outbound.protection.outlook.com [40.107.212.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 375AA220F20;
	Wed, 20 Aug 2025 09:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755681711; cv=fail; b=mqTNFfWOYF+Kp1TrZRPWTV8Cztvaksu8B5noZV4wqkpPoGB6kGI+NEhsD0SQXFodTRMmEMD29GB9RzTZX8h7zTAeVlXex71g6LNEY3x6LOb8W0J9K2WoDocbLIR9P+Sf8uU+4oOpZ8nskwYyrD7cdvvrMk1Y/dbHbwPmfKpV0XM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755681711; c=relaxed/simple;
	bh=iZvpvdhglWqdLW1a3mXMr5f0PGp3RG0MkCQsPvCLeuE=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=oJZZJUrsovDZMbggCbUGx0WBrf2+wnd6S5GVbZWxdu6a5UW70J6hJFllqjpyfhFipnP5aUa8QrtQK0qhVzOjlo2nGzz5tdE3axlgwwXYzn4EfY08CIag1lsU6p9qjGhLWFYgg2qnOR/a8WVRA5aZSPg4sFTf+ox+TUSl8LzQmgw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ChoT+5VP; arc=fail smtp.client-ip=40.107.212.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WSiF332vVOmfWWtFOtNbEqm51NMRbVYwV2royS+B3AtkHYdN0GUg7IjQfxfwr/TwXsoH6LL5JSnuhkUlLcX/Bmnp5eVIbQ/tZNTCAVt8QPjAqFewWKzcFouwRvErZ5fUFTTSljH5un33RaqFgr2NL8nexwgdkz9uZV9Ts6/D9yJmIRGk/OtZlh+qG/t62XV29OVxdInqwfSOflQPPYhsF/jC59lvWK4JaTRfskscgFF7raxi5jFUVi3bhWOeEJK+vaAcZP25vyLkGItepw2MWyipxIEkPJcLRsgGW7VjsUTB+AXWNVKow1BQCw3W9itc3R1JsFOA8BhC1IZIid/dog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7fs9GDn6ivgcuXBDvk01DuhoTb8yujbQkzzRxK4JQR4=;
 b=tsYo9dByt8F6aW55keiTG/PnvN0GZKJYhph393h2+L7t3WgO7eQdTpYnVB8o8RRKEN1xuN2OiQJQBxCOBfbwz4wbsP1iovKLTq3hOwqnD6fRiIuFTndIboH1Efcy+QR0sadTHKARRDVW5ffsDUWuQCbhzKzMCw0L4jPkKBnmY0VBg1qiGF4d0fdNjmT4Rj/92tmrU5x2NWfB91BzGZRrlNsjdlrocBieJMF3qIqyFb/wGiHkJHScaWcSLIYJ2hzlW/7M8KXxOg0Ma7WR3u7f2khC7VsQGmpS42xldJugqBY7V1YgkVeS/SqsSs3ExHbFCS3XqLePD3Vez0XV2n9hpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7fs9GDn6ivgcuXBDvk01DuhoTb8yujbQkzzRxK4JQR4=;
 b=ChoT+5VPJv5Ly9FA0hQ77j645LnVINLJnErVd0bJ4fhmdYRRCErTLcEaj8iJHUlgnPA1xpUtBdeS5C3XQ8jt2h28FZImkYmLW1kM4eFN3d2di92b0JJ0SYBcyv03rtX0IW3sxKpCwfHZuu5htpel3Kf6ghp3reA5856s6KB9ki8=
Received: from BYAPR05CA0066.namprd05.prod.outlook.com (2603:10b6:a03:74::43)
 by BY5PR12MB4097.namprd12.prod.outlook.com (2603:10b6:a03:213::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Wed, 20 Aug
 2025 09:21:43 +0000
Received: from MWH0EPF000A6733.namprd04.prod.outlook.com
 (2603:10b6:a03:74:cafe::c6) by BYAPR05CA0066.outlook.office365.com
 (2603:10b6:a03:74::43) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.13 via Frontend Transport; Wed,
 20 Aug 2025 09:21:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 MWH0EPF000A6733.mail.protection.outlook.com (10.167.249.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Wed, 20 Aug 2025 09:21:43 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 20 Aug
 2025 04:21:43 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Wed, 20 Aug
 2025 02:22:10 -0700
Received: from [10.252.207.152] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.39 via Frontend
 Transport; Wed, 20 Aug 2025 04:21:39 -0500
Message-ID: <aca901e8-958c-46f0-9808-001a2afd8bae@amd.com>
Date: Wed, 20 Aug 2025 14:51:34 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 5/8] KVM: SEV: Move init of SNP guest state into
 sev_init_vmcb()
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Thomas Lendacky
	<thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, "Borislav
 Petkov" <bp@alien8.de>, Vaishali Thakkar <vaishali.thakkar@suse.com>, "Kai
 Huang" <kai.huang@intel.com>
References: <20250819234833.3080255-1-seanjc@google.com>
 <20250819234833.3080255-6-seanjc@google.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20250819234833.3080255-6-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6733:EE_|BY5PR12MB4097:EE_
X-MS-Office365-Filtering-Correlation-Id: 900360a4-3d7f-4c0a-ff68-08dddfcafaab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QVdEei84TDJibTlROGhBYVplbVFNQnpqRlVIWTYvb25JOFkyTnF6aUhBUEpi?=
 =?utf-8?B?LzY2dkNqdExOdlRJOUprejMvZldhaUJ4NGdxNFZqMGIzSnozcU5OYTB4Mzl6?=
 =?utf-8?B?ZWo3VnMvS01heTlGbDRTSkNGTnJZak8rNVRFNkRHL2pzVEd0NXh4bEhEZHBC?=
 =?utf-8?B?SEV1VDg2RlB3bFQyOVAwOTlqcDhPOEk2V1pmVUtsOWVxZHFmUXBjTW12Lys4?=
 =?utf-8?B?WjEzMEpTWjBacnN5dG40cG9yVzhxZ3BQSzJESWc5SUVwWWE2UlU0WG5FUXU5?=
 =?utf-8?B?TXZQRVBtOEtqODM5S0pVSWNpSTQ2a0E1ZzlBYmo3RElJOEZFdTJkeG5mNVhR?=
 =?utf-8?B?bFg0Z2pjVmdOOFV2VWh6U1I2eDdVVXZ6N1Z1c1p6RzdNUDVtQnZ5elM3b3lE?=
 =?utf-8?B?K2xTUEp5OFdBSngzL0EvcnpYWkVlVFdsbGdJSlpwWlBLMjdHZ0kwbVg2SWVl?=
 =?utf-8?B?Y0dkeUdLellOTUowWUtnVVlQc2UvKzZ5aytiankwT3hBTWVRekNtbGJUT1M4?=
 =?utf-8?B?NDd0eG84RDlvUkVqV0owZzBSbkpKcFpnWlkwWnNnckVWQSt6eHJveGcveTRY?=
 =?utf-8?B?R3BpTXNaazhWYndhbFhVMHFhUU5rd1ZmWkZac1VRQU1QaTZObXc2SStEU1Zn?=
 =?utf-8?B?eXlsMFhPMUtGVDllYjFsWnhhNFE1MzhvZ2lNaEpyeldLMVZveEFid29Ea3Vl?=
 =?utf-8?B?YkxxeEFjWjRJZlpuVDNHMUYyeGpKQkFCK0ZRR2pSRWVzVm5UUkZKUjhKVFhM?=
 =?utf-8?B?MWUwL2k3U0RBYjdZT2pmaEQxMVFKTjcwR0dqN1YwbCt6OWRwVGZBTHp2TTRy?=
 =?utf-8?B?bCtRQWtRV3MzUHJLVWRBMXZvVlh3eEF5KzV2VGxGOWk2ZWU0TmFJa0xFNVRq?=
 =?utf-8?B?cm8veVVkbUM4NUFTelMxL282REYwQ1hRM2cwdGdkMGxldFIxc3QwYklxaWdM?=
 =?utf-8?B?L0V2NEpwTHpvRDJlTFFObWxXZGFqOGtpR0ZUL013WEltbmg4SFl2K1h5VTJ2?=
 =?utf-8?B?SUUra2VPL1VBZ2Z3aGQwVDNqNXVjUjdWZ2RjTU84ZmtIOG1jVk9ZTGh0bFNn?=
 =?utf-8?B?Q29DTFRHYzRTWmFBN05wRCswODZ3b1lyNGdDL0E0a2lBTGswQmV6RTdtZmxh?=
 =?utf-8?B?THVUampSb2I3K3NSZk85OE0waHBmS0ZUMkJpT044NW84SGxTcWpxNVAzem9i?=
 =?utf-8?B?RDF5aVpaVjc4Q3B5SiswUVRMdVg2dW9KUlVkbHVneFUxWk9BcVEwOVprbHV2?=
 =?utf-8?B?Nk81b1FOcHprZVpOZ0R2WTcxSDNPRGwwV0ZtRzVXRTNmSTB2UHVpQXZEbWpy?=
 =?utf-8?B?Q3dyOTZ6Vkpkdml5bjFiRDc0Q29TbVFYOWFpNnRxL01BMlljUmtZVVNZV2lD?=
 =?utf-8?B?Z0NDYVNoVHBUNTcrVGxLMkpickp5dVhSWG5oR25tVFNhQzdhV25TMGdHc3hH?=
 =?utf-8?B?RDY2citMTFVkTU1laG9Cc2IyUk4yMFlqcXY4Y0tQamVVa25CN3RDUVhla2N1?=
 =?utf-8?B?WGNua0hRUDl3VVhpaE12eXRlWDFnVVpQaUhicTA0cVZ2aHhlVGFobEVieHgv?=
 =?utf-8?B?UFJwYlQ5a3BGdHR4YVllYVE4QVNFRFdxVllMa1BzU2VwUEFnSVJ1WnZBTGsr?=
 =?utf-8?B?TjhNbjlva0dhVFdnd3k5VlBTN2hQbzYzTUROMlhCZGFjMGxjQVJwV1Izd2J2?=
 =?utf-8?B?RVJCRWtyMTMrWGZreUNaZGdtQ1MwS0FDRnJJZCtiWXBzMDYxVDc5eFJQL2Zt?=
 =?utf-8?B?K1BTS1p2UXl2bHIzRitrQ284cUg0Z01BVDdtOUZ5S2VBQnRqbTNLemFHS3Jr?=
 =?utf-8?B?MzBJQnVmdEtxQ3MvWHZEVDdWNmZpaTNKNWxLYnNnd0c3T1htdDQ3eWorOWVi?=
 =?utf-8?B?eVFlWis1Y3N4Y00vY1pkeDBvTXNuYU1YQkxTODc5U09rQitmSkE5TlJ0cW1Y?=
 =?utf-8?B?TFVZV1dTemdTUVRIMGJjY1ZkQjJKT1BxTzVJa2g3Q0Z6alRwdlpLUFg5dHNx?=
 =?utf-8?B?QUZuZG85R05EQnlsL3JEWmY3dnhvMWh5aTFsbms0dW5wMERwMjFRMlBLck14?=
 =?utf-8?Q?k6+KQN?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2025 09:21:43.7090
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 900360a4-3d7f-4c0a-ff68-08dddfcafaab
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6733.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4097



On 8/20/2025 5:18 AM, Sean Christopherson wrote:
> Move the initialization of SNP guest state from svm_vcpu_reset() into
> sev_init_vmcb() to reduce the number of paths that deal with INIT/RESET
> for SEV+ vCPUs from 4+ to 1.  Plumb in @init_event as necessary.
> 
> Opportunistically check for an SNP guest outside of
> sev_snp_init_protected_guest_state() so that sev_init_vmcb() is consistent
> with respect to checking for SEV-ES+ and SNP+ guests.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Nikunj A Dadhania <nikunj@amd.com>

> ---
>  arch/x86/kvm/svm/sev.c | 16 +++++++++-------
>  arch/x86/kvm/svm/svm.c |  9 +++------
>  arch/x86/kvm/svm/svm.h |  4 +---
>  3 files changed, 13 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index c17cc4eb0fe1..c5726b091680 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1975,7 +1975,7 @@ static void sev_migrate_from(struct kvm *dst_kvm, struct kvm *src_kvm)
>  	kvm_for_each_vcpu(i, dst_vcpu, dst_kvm) {
>  		dst_svm = to_svm(dst_vcpu);
>  
> -		sev_init_vmcb(dst_svm);
> +		sev_init_vmcb(dst_svm, false);
>  
>  		if (!dst->es_active)
>  			continue;
> @@ -3887,7 +3887,7 @@ static int snp_begin_psc(struct vcpu_svm *svm, struct psc_buffer *psc)
>  /*
>   * Invoked as part of svm_vcpu_reset() processing of an init event.
>   */
> -void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu)
> +static void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  	struct kvm_memory_slot *slot;
> @@ -3895,9 +3895,6 @@ void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu)
>  	kvm_pfn_t pfn;
>  	gfn_t gfn;
>  
> -	if (!sev_snp_guest(vcpu->kvm))
> -		return;
> -
>  	guard(mutex)(&svm->sev_es.snp_vmsa_mutex);
>  
>  	if (!svm->sev_es.snp_ap_waiting_for_reset)
> @@ -4546,8 +4543,10 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
>  	svm_clr_intercept(svm, INTERCEPT_XSETBV);
>  }
>  
> -void sev_init_vmcb(struct vcpu_svm *svm)
> +void sev_init_vmcb(struct vcpu_svm *svm, bool init_event)
>  {
> +	struct kvm_vcpu *vcpu = &svm->vcpu;
> +
>  	svm->vmcb->control.nested_ctl |= SVM_NESTED_CTL_SEV_ENABLE;
>  	clr_exception_intercept(svm, UD_VECTOR);
>  
> @@ -4557,7 +4556,10 @@ void sev_init_vmcb(struct vcpu_svm *svm)
>  	 */
>  	clr_exception_intercept(svm, GP_VECTOR);
>  
> -	if (sev_es_guest(svm->vcpu.kvm))
> +	if (init_event && sev_snp_guest(vcpu->kvm))
> +		sev_snp_init_protected_guest_state(vcpu);
> +
> +	if (sev_es_guest(vcpu->kvm))
>  		sev_es_init_vmcb(svm);
>  }
>  
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 3d4c14e0244f..8ed135dbd649 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1083,7 +1083,7 @@ static void svm_recalc_intercepts_after_set_cpuid(struct kvm_vcpu *vcpu)
>  	svm_recalc_msr_intercepts(vcpu);
>  }
>  
> -static void init_vmcb(struct kvm_vcpu *vcpu)
> +static void init_vmcb(struct kvm_vcpu *vcpu, bool init_event)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  	struct vmcb *vmcb = svm->vmcb01.ptr;
> @@ -1221,7 +1221,7 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
>  		svm_set_intercept(svm, INTERCEPT_BUSLOCK);
>  
>  	if (sev_guest(vcpu->kvm))
> -		sev_init_vmcb(svm);
> +		sev_init_vmcb(svm, init_event);
>  
>  	svm_hv_init_vmcb(vmcb);
>  
> @@ -1256,10 +1256,7 @@ static void svm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>  	svm->spec_ctrl = 0;
>  	svm->virt_spec_ctrl = 0;
>  
> -	if (init_event)
> -		sev_snp_init_protected_guest_state(vcpu);
> -
> -	init_vmcb(vcpu);
> +	init_vmcb(vcpu, init_event);
>  
>  	if (!init_event)
>  		__svm_vcpu_reset(vcpu);
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index cf2569b5451a..321480ebe62f 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -826,7 +826,7 @@ void avic_refresh_virtual_apic_mode(struct kvm_vcpu *vcpu);
>  /* sev.c */
>  
>  int pre_sev_run(struct vcpu_svm *svm, int cpu);
> -void sev_init_vmcb(struct vcpu_svm *svm);
> +void sev_init_vmcb(struct vcpu_svm *svm, bool init_event);
>  void sev_vcpu_after_set_cpuid(struct vcpu_svm *svm);
>  int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);
>  void sev_es_vcpu_reset(struct vcpu_svm *svm);
> @@ -864,7 +864,6 @@ int sev_cpu_init(struct svm_cpu_data *sd);
>  int sev_dev_get_attr(u32 group, u64 attr, u64 *val);
>  extern unsigned int max_sev_asid;
>  void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code);
> -void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
>  int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
>  void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
>  int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
> @@ -891,7 +890,6 @@ static inline int sev_cpu_init(struct svm_cpu_data *sd) { return 0; }
>  static inline int sev_dev_get_attr(u32 group, u64 attr, u64 *val) { return -ENXIO; }
>  #define max_sev_asid 0
>  static inline void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code) {}
> -static inline void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu) {}
>  static inline int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order)
>  {
>  	return 0;


