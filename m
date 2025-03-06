Return-Path: <kvm+bounces-40289-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B7B34A55A97
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 00:05:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 887BF3B2D97
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 23:05:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C2872803F5;
	Thu,  6 Mar 2025 23:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="mApFoaAR"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2048.outbound.protection.outlook.com [40.107.220.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E745127FE72;
	Thu,  6 Mar 2025 23:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741302257; cv=fail; b=BZhDA0/w9MAODzI2ADD3rMDHGQmQalvABAHav5t9hNTvEaHbGebWf/GsKIYrG+WvDluv6DuJzHRQtSTMFZ7c/Uc4NM/VlscVm/QkY5rhgXF4LMyZ7VnKwaCx61arQALxdzYBXVer/RhYEhLOs+VoJSF86PCFQTFXUUvLOXX8YDg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741302257; c=relaxed/simple;
	bh=KhUVWBRUgpWw0G4c6KYfnbmuH6EtQqLurd7JPMccKp4=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=F/jHjfd5lsmU0/kr6ZffFeW/zLGJSzP64D9Svrp3yHlu/DVPEF8JSTtKLsjihvsqFEJkdHVvVHXWszvgmXUvcPGySjLc2ZR+To6WYaQebhyLIius0FwNuCRND6S2WS+DJOByov4TayF6bECMynpEtjQ4aOOWAJVJgBQCBa31ppw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=mApFoaAR; arc=fail smtp.client-ip=40.107.220.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pehxQ2aAQ6BW424vLpz4g2fDu0CLTVLh4KkFHDvWBqpYHUfGBvbcroBe0gsgElzzVeOw78YelAQV5aX61NiKOlCc/GtR0lcog1uJ+UmER6OPMrydRD/Qy0RE64KpSJtKeGKAYODnlmxRxEDnG3tFskp7zwL/moFSHVRyV72sG9QsWq2aHONoKgt2ISHic2rnYUqUf/WaGGCU5gAcV/KWYq8FfZ5laPFzYi5vVlI1W0TqjCSNZSwWhzqbEBMbHcx65lDF24MoESvalwrK8gExWUIvdcK62SNiKsbhity+osn5AlLkFxNINYCgAWA+70vXVdtuJuZ30u/ZYxug64gzrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oIFQHnr0AEI5gWh0rH+hIzTYrxtar9/Rry+oxbnjfPU=;
 b=fPvQ2gfkefJXDsxY0g/0FEbDM4+VsaKQDwx7d/3xmhP4sx8gXOw8VYnsHzVkEbSCOn8lAIT0+WVKpHWzrqhdLAT4vo7tS6kxSQmPLs1SMHmwb3KfPr9xv9eez5ThuPX7G07m3Nyqv+kZ7IYc9Wbrasj6NI8Gd6qwyht7lkDDjcGjeJl9DOYiSD+RiF/MhdU2g3hub0uJiZuAJmSXWABeDTd1D/Xvx5b4+cm+0NoTeG5tCm4FV/MkCR7bzav2HqZdJf0dnM2DkpAB0tWOiJfMwkiwkGVUvcndC4ZVI3XowxyYG9A4DJvF+VCWkTT13Ri4e/LuLGJXPoBubs+YXeSIDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oIFQHnr0AEI5gWh0rH+hIzTYrxtar9/Rry+oxbnjfPU=;
 b=mApFoaARe+NJExpo7BftZ37MbQdXE5p9SGrJL2eQCPP+YW4aryxCKr04vhGH2cE/AHr93uirjAhph3MlJjQLSmIgD+VbsPR8xa3adB54YxOKFc1ugd3qswBMvf0c/myfH9ycWC3JTKAzpkkF+H7ErL0M1LA+NEjrt+2mgD06PIA=
Received: from SJ0PR03CA0052.namprd03.prod.outlook.com (2603:10b6:a03:33e::27)
 by DS7PR12MB5934.namprd12.prod.outlook.com (2603:10b6:8:7d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.19; Thu, 6 Mar
 2025 23:04:11 +0000
Received: from SJ5PEPF000001EE.namprd05.prod.outlook.com
 (2603:10b6:a03:33e:cafe::ff) by SJ0PR03CA0052.outlook.office365.com
 (2603:10b6:a03:33e::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8511.19 via Frontend Transport; Thu,
 6 Mar 2025 23:04:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001EE.mail.protection.outlook.com (10.167.242.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8511.15 via Frontend Transport; Thu, 6 Mar 2025 23:04:10 +0000
Received: from [10.236.30.53] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 6 Mar
 2025 17:04:07 -0600
Message-ID: <fd3c11f3-42b5-45e9-b827-d9047a246e59@amd.com>
Date: Thu, 6 Mar 2025 17:04:07 -0600
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/2] KVM: SEV: Configure "ALLOWED_SEV_FEATURES" VMCB
 Field
To: Tom Lendacky <thomas.lendacky@amd.com>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>
CC: Michael Roth <michael.roth@amd.com>, Ashish Kalra <ashish.kalra@amd.com>,
	"Nikunj A . Dadhania" <nikunj@amd.com>, Borislav Petkov <bp@alien8.de>, "Dave
 Hansen" <dave.hansen@linux.intel.com>, Sean Christopherson
	<seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Ingo Molnar
	<mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner
	<tglx@linutronix.de>, Kishon Vijay Abraham I <kvijayab@amd.com>
References: <20250306003806.1048517-1-kim.phillips@amd.com>
 <20250306003806.1048517-3-kim.phillips@amd.com>
 <977385c2-f885-4c5a-ae79-3dee863900c2@amd.com>
From: Kim Phillips <kim.phillips@amd.com>
Content-Language: en-US
In-Reply-To: <977385c2-f885-4c5a-ae79-3dee863900c2@amd.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001EE:EE_|DS7PR12MB5934:EE_
X-MS-Office365-Filtering-Correlation-Id: d0e92086-c6f6-4bb9-729e-08dd5d0334c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VThtV2ljVS84UElIY0JxdE52Z1VVZlJBRnRvdjFvMGF4TEJ4bjFuMlNnR2kx?=
 =?utf-8?B?TUN1NWNrZFV6YWN0R3J0Q1ZUVnh1RCtsVmpCaXl6VEh6eWxqeTBsWDR6UjIx?=
 =?utf-8?B?VmxVMnhBM3ltRWxTcytWSEMrUlRkeDZGSXpwOC82akFldWZEVC8xelVkQVlV?=
 =?utf-8?B?Nmw2ZUFSLyszalNQNEFyZVdyVm84cWtsbEVSNzh5S2d1NlptY0xaL241eDhF?=
 =?utf-8?B?OHV6TEh5QTFBekZVeFBxWFVKMWxCUmhPaDFPZmRkelFrcjJ1MUxBL2RIWm9R?=
 =?utf-8?B?dkZlWkkrdDluY3BFdUZwR2J5ZjVkbXAxV2NTY24vWmUvQW5hS3dhUUdma0tW?=
 =?utf-8?B?WXhkL1R0OTVaeHd5cVNkcFZCRGRDSEd4eXAxMmhHNlUzSGs0aDVZLzkyb2Rh?=
 =?utf-8?B?R05LZ2pVaEF3SmVUcmNoYUh2MGVKamhHdWVRcTc0cGNYMTFtd0ZFME1aeHpq?=
 =?utf-8?B?Z2QxeTFDd09hcW9lNFB6c1p0SWFib3NtTXd0UGI2WE1ra0dzbHhWUVRmMUJG?=
 =?utf-8?B?b2tTbDEvL1R6dTg0Y25Bbks0cHVjNzU0cjJkREUxRUFKQTlCSlF0Z05HMk5q?=
 =?utf-8?B?L1hJYWM2c05rMkRjMG5oV2o4VWF2UnV6T2R2ZitnZlRreGxvdFYvdXVsN0hw?=
 =?utf-8?B?OWZYTEZleVpWN0JnMEpieG1WWmd4WENPcm9WWWZFRElwdDRxeGkzT1RUUEEz?=
 =?utf-8?B?N0hKbXVmNnlSN1ROVVZyUFg3MHlOZjBqUTFEN2hIV0N0U2NxTjhGTDF6RHQ2?=
 =?utf-8?B?WkZCM2JGZHg3WVBBQWxyU2pRaXhIRldwNCtZUXZ6aDVjMXJKVjFGOFJWRlZ5?=
 =?utf-8?B?THRnU0Znc0hmL2tQT1NvUW5DL0hBOTJzNTRqYVVnNTJRbVo1N1dQeWtRMzBI?=
 =?utf-8?B?SEVlN2hzTC9NYzFBbXdSZ0RxVVNIc0gvMHlvMTAxRjlwY1pEbjRvUCtGYlZN?=
 =?utf-8?B?dVVQcHBkTkdtRm9zS24zdUl1aHIzNGRQblBYWkN3UFhNRjVwVUNLY3Y4Y2Na?=
 =?utf-8?B?SW1ZeEhidGZFRGVKOFJ6TGR2amZmRXQ3Ymdobkd1M2tvZVpnbDhmVlJ0M2lp?=
 =?utf-8?B?K0I3VzJ2YlJmYlVWMklKY2dnNUpnbzZxeDhJbFpHUVZrbFNmbjZqY0lYN3dq?=
 =?utf-8?B?MkJndHV5K1A4WkcrUXVUV1N3bE93cUpIR1djTzEwRUV0Y0ZhclRROW9PUDJO?=
 =?utf-8?B?d1lxK2JJdTNTSGFmSnF6bG0vMTZjT08xN2JoenZiUUVScE9LbU4yZUdhbjQz?=
 =?utf-8?B?MmQxdGdkelpTYXNMQnlQQTgyTUE1TjFXWmdqSFkrUnBPcS9WK2VwZitwbUNm?=
 =?utf-8?B?RERFTVJpU1FzOGZkQXZ5VENpVmQyYlVUUHJMV1NCUGJ2WnJ1SXJRL0VoS1Nk?=
 =?utf-8?B?alV2OFNtSzVuUGhuTTh4WmZIbS9zQlRuWVprN0tIVzhIZEhJdzg0bmpUOHBa?=
 =?utf-8?B?Y29hSWxUZmhKZlI3VVJ6QnJ0bjJVOVRuYnY2ampoYXEzODdEbUFuK25VY1lP?=
 =?utf-8?B?Yk9HaS9uTG1vT1BnQVlYL1JqQ2k1YnZmZ0w4V2w4RzRaU1lqVk9hL0pwenRh?=
 =?utf-8?B?dS9naUNBZDZuTXhLdk9NMGtKTDBVQXFZZnZZSm1vM2xXYVJzdi8yUEZYYnpS?=
 =?utf-8?B?cktOblNzUVVVZnR0ZnRDSGFyY29rblpUQm16UERncUtlTTUyZld3WU5QMER1?=
 =?utf-8?B?Uld6YTVicS9FNkI5RFBROHhlbTAybXRoL1RjUmdDVXBhR2pnQ1hIUkoyQ0Jl?=
 =?utf-8?B?R3pvdnQ4MEJXVHJFNW5aY0ZFS0Rhc1ZVTEp1M29US2xoUE5TaWp5aGhTWUx5?=
 =?utf-8?B?ZFV4SG8zOVl3ZDgzeHg5UnRJNlFtYkR4RW8xdGFFOWRFSWdjYWZMeEJuT1BF?=
 =?utf-8?B?MnF0OUMrK1FNbHVYVnY2ZkN3bCtTYzdVYkpWUTRIWDZad2ZLU1BkS2UyNU5Z?=
 =?utf-8?B?ZEFTOXE0Sk1zUkNIVmpLaWJ5c1hJNkhFYnZ3VTF1N1VDNmhIVXZGemF4QVh3?=
 =?utf-8?Q?4tZOCwXXNM5b23Yzn9Slvtn2jmYdls=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2025 23:04:10.6621
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d0e92086-c6f6-4bb9-729e-08dd5d0334c6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001EE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5934

On 3/6/25 1:27 PM, Tom Lendacky wrote:
> On 3/5/25 18:38, Kim Phillips wrote:
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index 0bc708ee2788..7f6cb950edcf 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -793,6 +793,14 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>   	return ret;
>>   }
>>   
>> +static u64 allowed_sev_features(struct kvm_sev_info *sev)
>> +{
>> +	if (cpu_feature_enabled(X86_FEATURE_ALLOWED_SEV_FEATURES))
>> +		return sev->vmsa_features | VMCB_ALLOWED_SEV_FEATURES_VALID;
>> +
>> +	return 0;
>> +}
>> +
>>   static int sev_es_sync_vmsa(struct vcpu_svm *svm)
>>   {
>>   	struct kvm_vcpu *vcpu = &svm->vcpu;
>> @@ -891,6 +899,7 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
>>   static int __sev_launch_update_vmsa(struct kvm *kvm, struct kvm_vcpu *vcpu,
>>   				    int *error)
>>   {
>> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>>   	struct sev_data_launch_update_vmsa vmsa;
>>   	struct vcpu_svm *svm = to_svm(vcpu);
>>   	int ret;
>> @@ -900,6 +909,8 @@ static int __sev_launch_update_vmsa(struct kvm *kvm, struct kvm_vcpu *vcpu,
>>   		return -EINVAL;
>>   	}
>>   
>> +	svm->vmcb->control.allowed_sev_features = allowed_sev_features(sev);
> 
> I think you can move this to sev_es_init_vmcb() and have it just in that
> one place instead of each launch update routine.

Agreed.  I'll remove the above and add the following in the next version:

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 0bc708ee2788..f9ec139901ef 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4449,6 +4449,7 @@ void sev_vcpu_after_set_cpuid(struct vcpu_svm *svm)
  
  static void sev_es_init_vmcb(struct vcpu_svm *svm)
  {
+       struct kvm_sev_info *sev = to_kvm_sev_info(svm->vcpu.kvm);
         struct vmcb *vmcb = svm->vmcb01.ptr;
         struct kvm_vcpu *vcpu = &svm->vcpu;
  
@@ -4464,6 +4465,10 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
         if (svm->sev_es.vmsa && !svm->sev_es.snp_has_guest_vmsa)
                 svm->vmcb->control.vmsa_pa = __pa(svm->sev_es.vmsa);
  
+       if (cpu_feature_enabled(X86_FEATURE_ALLOWED_SEV_FEATURES))
+               svm->vmcb->control.allowed_sev_features = sev->vmsa_features |
+                                                         VMCB_ALLOWED_SEV_FEATURES_VALID;
+
         /* Can't intercept CR register access, HV can't modify CR registers */
         svm_clr_intercept(svm, INTERCEPT_CR0_READ);
         svm_clr_intercept(svm, INTERCEPT_CR4_READ);

Thanks for your review!

Kim

