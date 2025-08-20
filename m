Return-Path: <kvm+bounces-55112-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A399FB2D8A5
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 11:40:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 42D9F3A8C9D
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 09:35:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF94A2E2668;
	Wed, 20 Aug 2025 09:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="KY0PDzcY"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2067.outbound.protection.outlook.com [40.107.101.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A9C92E22B8;
	Wed, 20 Aug 2025 09:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755682348; cv=fail; b=NUyAzX1nryMARwuIs8j7lp4CEnk4KZoq5dIkNu4Y10BH30IbveLPgTKilWALTdYRW4hondbefoUG/UQ6XCgie18414k4M2wSCtGJEeQKoADjLtlo8Wi8zV2R1TnCarPAIImqGCufPWFMEfh2NqcYlHAlExKTXLXrW0TlwL3gezk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755682348; c=relaxed/simple;
	bh=1kf2m8UmATqmTqTIYL6MfgIA21AeAwLSXPx/Lh4m5yY=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=p+mTgq8iMv/ewiFqteMOsIu0huUyUG9ug8MfEbglaSHdq5wOIW1ArPWCibYWl3IREhTw69HBi651zFmxh/GV4BYwNcSYywgrWlPV6JF0g0Dhp6TTnYukvjARPLwzFXsK+JOiaADyOJ8DELX02ePbvnDA9JWRIRQruoWy4f/g/YE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=KY0PDzcY; arc=fail smtp.client-ip=40.107.101.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fK8I6k8SWWEDs2Tdt+/4fvQLEgF0gDQZ16b11QM0qADWH7K/tkrHzTUZn2WW3j9t34uUGmblxhFtETOwo36+ZOOXH85BlttmgyE15q3UCBKiyitRQo2CNqEBvUGmf2ql94MzsohqPhZfhIxu9IouvaswvUIFGm1BSnIs/MWQMKbohsqH+XHXQ6Z4PeqFcPxRNaFhX+1AZLHBoh0Y1+eY2nyKXb3qIoSdrcAaNPb9doVODa90Y4CdOGOBr1qO8UO4qRwsfo7xOFO/4xOoIUuo24cAIfWBLlkd0MvNEspOXsoxTcdMXbcog3CrU03uvJzDzFc0SCSft+vyQ3e8zsaJPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5jHBhAYGmbKSzRiiVmxjffbnMzX4xXR7vTWsVfwA7Yg=;
 b=xQO7twQZ72tFASypkGUpTy4GE0D7M8L3LmIb2rhupeS3ffTTVvhpizE5ctcY1KFOWPJlvZzHHUqC8sAPN3h1mUVjqFV0F/hBcd1NRZn8ocmqwkTJLLrvFS3/SyYKd/RTiEZplSTT3OQmdkCOjb1A3/0g/M4l9WNnzHJNi53BqT5e0lzTT0AmKXnYsAigtvwo577CXuQ0wRQKs78OzejwQ3ors5ELmhw9nFPOmMq+izNOUzysoZIvrJIwhWYuDJI+2OzY+4dMxkQccXNaYT2j4dDK4BoBDR31eICNMeBIG7h5QVZl78PxlkYkOZKGk7QCUpDnO/L4ZpdGWpa237NV3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5jHBhAYGmbKSzRiiVmxjffbnMzX4xXR7vTWsVfwA7Yg=;
 b=KY0PDzcYJmgybXkr5KJx/IL8b5YsJBi3kse2UB7WxkP3vhMKq4PverPQZicplpyl3pVMSoYUlGwAOjNjHnOYd2A35PMkJVsTo2y+U8VSc8tjTzbAHNHYb58Wx9FffwYn6v2+et4n8QYHaGSw81LZJRMZy8h7omrXvZUTKQbdWSs=
Received: from SN6PR01CA0021.prod.exchangelabs.com (2603:10b6:805:b6::34) by
 SA1PR12MB7411.namprd12.prod.outlook.com (2603:10b6:806:2b1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Wed, 20 Aug
 2025 09:32:23 +0000
Received: from SN1PEPF0002BA4B.namprd03.prod.outlook.com
 (2603:10b6:805:b6:cafe::c0) by SN6PR01CA0021.outlook.office365.com
 (2603:10b6:805:b6::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.14 via Frontend Transport; Wed,
 20 Aug 2025 09:31:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 SN1PEPF0002BA4B.mail.protection.outlook.com (10.167.242.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Wed, 20 Aug 2025 09:32:23 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 20 Aug
 2025 04:32:22 -0500
Received: from [10.252.207.152] (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2507.39 via Frontend
 Transport; Wed, 20 Aug 2025 04:32:19 -0500
Message-ID: <0f29c54c-e471-4323-ba75-2df19d67479c@amd.com>
Date: Wed, 20 Aug 2025 15:02:18 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 6/8] KVM: SEV: Set RESET GHCB MSR value during
 sev_es_init_vmcb()
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Thomas Lendacky
	<thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, "Borislav
 Petkov" <bp@alien8.de>, Vaishali Thakkar <vaishali.thakkar@suse.com>, "Ketan
 Chaturvedi" <Ketan.Chaturvedi@amd.com>, Kai Huang <kai.huang@intel.com>
References: <20250819234833.3080255-1-seanjc@google.com>
 <20250819234833.3080255-7-seanjc@google.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20250819234833.3080255-7-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Received-SPF: None (SATLEXMB03.amd.com: nikunj@amd.com does not designate
 permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA4B:EE_|SA1PR12MB7411:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e5904a4-828e-4acb-b205-08dddfcc77c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RTdiZEE1ZWIvMkwyUkQ4VXl1S3UyWlBhZGkxQjFGejJlbkc3NWJUMjZNZ2NO?=
 =?utf-8?B?WnF0OEhlSEpSWHp4dzNHbnYyamxqMmptc1M2dWJkblRNeUlBVXBOMHNZNWlO?=
 =?utf-8?B?ZVh3WlpNSXllMVQzUm90aWdGcm5qKythbnFDN2luUnRlY21ML2hrZkNmV042?=
 =?utf-8?B?UUZNVWJWVGNaR3pkejFZMXoxSld2dlR2VWFtRzVpTTljM0xmcVhGdk0yZTJV?=
 =?utf-8?B?bFZ6YjdlSFZjTmxQWHlSclJHcWxZZE12cW1ZZnN6TmJwMVlhNWplSk9WNlBB?=
 =?utf-8?B?WnZXR3Q5bFJWQVBGejgydU50RVhnQWJqTDRpdTJ5NmxpdEVQU3FtWFlCNk5H?=
 =?utf-8?B?OW82RGZuVUJlckVmblRVakRJdUt1ck1ib3dwcWFEd3M5TlVRWXRhcWVsYkI0?=
 =?utf-8?B?bmxZWlFNejVUQ0RXdW1wOFZBeEhNQU4xUmQ1TEdtRFd6NytyUkd1N2FKMlMy?=
 =?utf-8?B?T0RtSVVwUTlpRGtZUWxHYkszTVk2NmV6ZXBBZURKVUdSTW9LaEpkdnVTOHk0?=
 =?utf-8?B?Wm1KRTBpUUZjc3pLQUpOMXZNQy9YZjJ5Q3VFUmlnSmFzdXJpWTVJSDFGekZ6?=
 =?utf-8?B?QVFyM2lKZ2xPUnhKVDlMeEFQWmU2N2N6RHVqNm14dlp2cWtWNHZ4aUZqUFgr?=
 =?utf-8?B?cUM2OWRQT0QyR05aUkVPWk0wZmlHRWtxVElhSzd4MHpScTA5cE5aVlA1dXZW?=
 =?utf-8?B?ZUdYS2duRGF2cFRBK1FzdDZiVUROWG1oWXZoT284eXBSMFE5K010ZlFmaE8w?=
 =?utf-8?B?Tlp4Q3I0K0NJTjVQdGs3dmpUeU9nM1Fzd3VQaVFTbkxWVzNPeDRDUHVzaUtj?=
 =?utf-8?B?UU1EcHBaVllTMFdFV3hzNTl5YjFnWDR5MWVFVUxNTG1ubkpadVp3eWF0WVpT?=
 =?utf-8?B?ZkhXMUlHWHBwSGdiTlZITHY3ZWMyc0krRVpFVS9OVG00WUVPTytOWi92YzFK?=
 =?utf-8?B?QjZPL1NKMmxRTmIrVWJBazU1TGtZdlpkTk1JYXUvTDhGSEpiVGoxUkRla1h2?=
 =?utf-8?B?SkxKYno0SDZ2bC9GQ3lUbjJRY08xRllHZDRPUmtzZ1ZpZ0VJQlVIOTc3QVNZ?=
 =?utf-8?B?dUtYZkxBRnpYd3g1OExjTmQzc2hmWWFEbCs2TGFXanNkKzdCbWQzWDVqRUNY?=
 =?utf-8?B?MFZGS0hYVS9JRFZJamlvOEJVOUEva0RjKytBeEtJaHNBek5Uc2diTVlVL0Ez?=
 =?utf-8?B?YlBJNDF2cGZjaEhEZmxKQWJkNlBKQUZ5bVJqNGZacWRUTzdQSTJJVjhjaUg3?=
 =?utf-8?B?U1M2VWZJYTBMeXVyVk5Qdnd5TlJyUTg2eHhON1pQZVpGc3ZiMldtc3hjNHRj?=
 =?utf-8?B?clVrTEJidTgydWUvY0hiU0t4T1U2UXA2aGEvV3d3Yk9oaHRya3QwZ0ZkaXNu?=
 =?utf-8?B?K3ZwUUUxMUpPUm5XY0NsSHhBMXpKeEhGVDNlQ3AzamNTZEhEWGxzQ1A3ejIx?=
 =?utf-8?B?RlpINW0yMVRnSFovck9CTUk2dG1IK1l5UTM3T0FpS3VRblhva0VsQkRYSDc2?=
 =?utf-8?B?azc1bEt1K2FvRHRPM0V0Tll0SUptYjd1T2FWQXlrRnlTK2JOemJwVzNNU2tn?=
 =?utf-8?B?UDhwQXR5TjYvTDVkOFFUMGpYVEh1aVJjem4rZWkvUkQxa0Jrd0dmOUMyaGVs?=
 =?utf-8?B?TTYrRG16cE5NeGpCR1FQTVppRG15NkV3MCtzOTduZ1FaSXoxQnFZT2dDY0E4?=
 =?utf-8?B?WEMyZHF6ZExOT0QyUVVRNkJMUzdnOTR3QnNYck51YUNjU1ZrRDZsS1ViNVFP?=
 =?utf-8?B?S2VTck9tMUZnSXFZdGRsK2ZXVlRKMkI3aHNTWjNmMXZNOGx0Q3ZyL1l6L1Y1?=
 =?utf-8?B?MkFPSUtpNWhOd2ZPaWU4UnVjUXBJMXhhVnREeTd6ZU5zVFVjNWJqeWg3eUl6?=
 =?utf-8?B?U1MrdVhaVEJ4QTl0MXRUOUN4ZUxYSjhiSHlUcGI4emJHaDZmeWovd21KeXBk?=
 =?utf-8?B?OUNVOTVOaHppZ3BMamlBTjdvVitDY2FtTWlWbEo3N1QwMmNtZlgzdmV5bmx0?=
 =?utf-8?B?b2UrSTdlTDQ5bDRlRWlTb2RLYVI5UUNIVDlyZjRySlIxWW1SVTk1OEJZQUJl?=
 =?utf-8?Q?/54xQn?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2025 09:32:23.1263
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e5904a4-828e-4acb-b205-08dddfcc77c0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA4B.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7411



On 8/20/2025 5:18 AM, Sean Christopherson wrote:
> Set the RESET value for the GHCB "MSR" during sev_es_init_vmcb() instead
> of sev_es_vcpu_reset() to allow for dropping sev_es_vcpu_reset() entirely.
> 
> Note, the call to sev_init_vmcb() from sev_migrate_from() also kinda sorta
> emulates a RESET, but sev_migrate_from() immediate overwrites ghcb_gpa

s/immediate/immediately/

> with the source's current value, so whether or not stuffing the GHCB
> version is correct/desirable is moot.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Nikunj A Dadhania <nikunj@amd.com>

> ---
>  arch/x86/kvm/svm/sev.c | 24 +++++++++++-------------
>  1 file changed, 11 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index c5726b091680..ee7a05843548 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -4480,7 +4480,7 @@ void sev_vcpu_after_set_cpuid(struct vcpu_svm *svm)
>  		vcpu->arch.reserved_gpa_bits &= ~(1UL << (best->ebx & 0x3f));
>  }
>  
> -static void sev_es_init_vmcb(struct vcpu_svm *svm)
> +static void sev_es_init_vmcb(struct vcpu_svm *svm, bool init_event)
>  {
>  	struct kvm_sev_info *sev = to_kvm_sev_info(svm->vcpu.kvm);
>  	struct vmcb *vmcb = svm->vmcb01.ptr;
> @@ -4541,6 +4541,15 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
>  
>  	/* Can't intercept XSETBV, HV can't modify XCR0 directly */
>  	svm_clr_intercept(svm, INTERCEPT_XSETBV);
> +
> +	/*
> +	 * Set the GHCB MSR value as per the GHCB specification when emulating
> +	 * vCPU RESET for an SEV-ES guest.
> +	 */
> +	if (!init_event)
> +		set_ghcb_msr(svm, GHCB_MSR_SEV_INFO((__u64)sev->ghcb_version,
> +						    GHCB_VERSION_MIN,
> +						    sev_enc_bit));
>  }
>  
>  void sev_init_vmcb(struct vcpu_svm *svm, bool init_event)
> @@ -4560,7 +4569,7 @@ void sev_init_vmcb(struct vcpu_svm *svm, bool init_event)
>  		sev_snp_init_protected_guest_state(vcpu);
>  
>  	if (sev_es_guest(vcpu->kvm))
> -		sev_es_init_vmcb(svm);
> +		sev_es_init_vmcb(svm, init_event);
>  }
>  
>  int sev_vcpu_create(struct kvm_vcpu *vcpu)
> @@ -4585,17 +4594,6 @@ int sev_vcpu_create(struct kvm_vcpu *vcpu)
>  
>  void sev_es_vcpu_reset(struct vcpu_svm *svm)
>  {
> -	struct kvm_vcpu *vcpu = &svm->vcpu;
> -	struct kvm_sev_info *sev = to_kvm_sev_info(vcpu->kvm);
> -
> -	/*
> -	 * Set the GHCB MSR value as per the GHCB specification when emulating
> -	 * vCPU RESET for an SEV-ES guest.
> -	 */
> -	set_ghcb_msr(svm, GHCB_MSR_SEV_INFO((__u64)sev->ghcb_version,
> -					    GHCB_VERSION_MIN,
> -					    sev_enc_bit));
> -
>  	mutex_init(&svm->sev_es.snp_vmsa_mutex);
>  }
>  


