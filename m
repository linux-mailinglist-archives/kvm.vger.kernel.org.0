Return-Path: <kvm+bounces-73339-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iIUaN0wIr2loMAIAu9opvQ
	(envelope-from <kvm+bounces-73339-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 18:50:04 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 7061423DEDC
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 18:50:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E59163018757
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 17:48:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79F0A2DA765;
	Mon,  9 Mar 2026 17:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Yam9R0K1"
X-Original-To: kvm@vger.kernel.org
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012037.outbound.protection.outlook.com [52.101.43.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B9382D949C;
	Mon,  9 Mar 2026 17:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773078491; cv=fail; b=bEeEqUpDfkwaBOjF18BnKUKv0JPNHO+Ao8wd7lV12pWqDJ+0oxoIxVe/mIGFjDQFXnDWVg6fg0X5/jw3EkYBxBp2lcOFlMXMUlJTKvE1DGRl9/dRHM2GrSJpt2NZu2i219MWASCP3gG7b7wT24z2Ca9ZSs6FJhYsv2IRAuad8As=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773078491; c=relaxed/simple;
	bh=cknDPrHnIifpN16ZNmi87wwbeY0P0d4GIX4YfhEoxCk=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=tL5H6nRZHLOJHmVyDoCIKL7WF+T1CNeXlA5uR5MM2HI0JJ45FGh529ZugcyK33DjDrrcUFpkiGikPgec3gXewmapNnBHNtBBT0+77/M/s7/u6UExZywZYyRMk0szG9kWzxu4raNZ9Duu3kQYEqGgLXdKcmWpxTTLT2xR3WCPf50=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Yam9R0K1; arc=fail smtp.client-ip=52.101.43.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZMcEEfCj0MyPaBCBko0ckEbl4wZA1OWq8ihPPlL5NKyoE9AGe2Zo9VeQNcQwdSsR2Y+7XR844syunj/pYV1tdMP3CaUVBmGH9Z5v5riFy8UIOMMRgrtldjSK/dM8i8BonsrNtmC94mBI4ZuQLcjKF2w3rRJIZFrHz+WWP4VZb5HaRRvOPcmlj2bNORDnj4W8rkQnpvVaiOkW/gSNX0j6Vrs4HqwQyQ82fC08ib0Cn1Qe89e5VEaYCF91qrytLdVPjxTHgDSLt8RlQDI9J7VRZlwCQhn7i03JDEbJthKQ2TozOunKYNnxwto/dyTJ+2AQ0e6w7MovJsf8ID3M9dldwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=US0VpZIQ4ZIwa8zWf8rGXCMWrVxF6uU2X19Iiuj1MIE=;
 b=MqvyyUCjly5IbF5iCVKvDrSl+kP4m7wriClWF89gmDUQGhPHIWozV9aBe3On57gZXIyCqLTVg4Z3RXSk1Gj3FxxHkyuqLGKhWCpZiuCQ4l775/CwdyuMn18F85J0EwJ4etGhBtONElygE5hU8yL1SpSuz6TrgX4oTWnyY8XwzgiQ5KtpkkK9NWDllqcCiuR0xhWy+xQQ4c2sUMKVAdDVFvAc7DQmSgAKUnm9jBPCzobZ0aol/RIe4Ihe0Bw8D9DCwDxeIlSNoorPo20FyOj4nWcz30Vk7HxTVky9T0HLQlZCMFaNHifngXtBBuiR0SbPJR7otpjSQwiqxMQLaJgaVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=US0VpZIQ4ZIwa8zWf8rGXCMWrVxF6uU2X19Iiuj1MIE=;
 b=Yam9R0K1I/Ajbvo95eDnxktU2HXnMQSKMrlg+8OsGJ2E7V/SNq2RouunVCbzzWdgIBUBgbJipX7XNpPez9e1GlqC+cpVm5EPOLuqdoCdf3SYz05iv3sguI0wBH70lG8Jg474tea+tgEEFGd799nyE31zeDiHVPPlIG/1q4dlDwM=
Received: from PH7P220CA0163.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:33b::24)
 by IA1PR12MB6579.namprd12.prod.outlook.com (2603:10b6:208:3a1::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.11; Mon, 9 Mar
 2026 17:47:59 +0000
Received: from SN1PEPF000397B0.namprd05.prod.outlook.com
 (2603:10b6:510:33b:cafe::d5) by PH7P220CA0163.outlook.office365.com
 (2603:10b6:510:33b::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9678.25 via Frontend Transport; Mon,
 9 Mar 2026 17:47:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 SN1PEPF000397B0.mail.protection.outlook.com (10.167.248.54) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9678.18 via Frontend Transport; Mon, 9 Mar 2026 17:47:58 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.17; Mon, 9 Mar
 2026 12:47:58 -0500
Received: from satlexmb07.amd.com (10.181.42.216) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 9 Mar
 2026 12:47:57 -0500
Received: from [10.143.203.87] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Mon, 9 Mar 2026 12:47:53 -0500
Message-ID: <f862854f-feaa-4393-802b-53e1a4c1a1a5@amd.com>
Date: Mon, 9 Mar 2026 23:17:52 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] KVM: SVM: Disable interception of FRED MSRs for FRED
 supported guests
To: Sean Christopherson <seanjc@google.com>, Shivansh Dhiman
	<shivansh.dhiman@amd.com>
CC: <pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <xin@zytor.com>, <nikunj.dadhania@amd.com>,
	<santosh.shukla@amd.com>
References: <20260129063653.3553076-1-shivansh.dhiman@amd.com>
 <20260129063653.3553076-3-shivansh.dhiman@amd.com>
 <aauJBkfODjTSnSD6@google.com>
Content-Language: en-US
From: Shivansh Dhiman <shivansh.dhiman@amd.com>
In-Reply-To: <aauJBkfODjTSnSD6@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Received-SPF: None (SATLEXMB04.amd.com: shivansh.dhiman@amd.com does not
 designate permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000397B0:EE_|IA1PR12MB6579:EE_
X-MS-Office365-Filtering-Correlation-Id: ad3b1cf7-dcad-4a0f-a874-08de7e0400a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|36860700016|1800799024;
X-Microsoft-Antispam-Message-Info:
	4QIFCysz2jEle6NoGhriSN22lruuUXCY9/U9QvJ3RBw30mWoYb0DlvsuSfPgNfNeplZ/fUClB1+DagyVO4kIlzvDljutJlOZVx5X/hI7ZxX+R+Szb5/KU1VWzmgA2IQR0Ga21ISMyQr6c9uAJBngve43MwzqD1xyvmeAEWatJmKYaYxTARfoc/PT6k/BNRfnHykF5vQQvFiotzzQZ1vPsJ4NECyjTPALBXIX2oUsmB5T+2B0pXzV9jlphB/Olz3OpcAVNncPzDnWFCT847qf15QUdbZUvih2U/HndU5ItXgO/Muu83yvMaPv1/gULnj5XIP5PBjXHXpoKKvV6dUsngwKRHOft9iIDfbPd/PKWFmXSOf2oLBp0ZvTlr0HZiv3J3xntTgs0uVcpgv7D2rPgZNST+elg36Toy8jITTiNE+uktDJknIOU+fgr40HI8jzMT1O2lfGbXyfLRNq86jChMUGs3xzBybwF8ldnRl4G/UT1wGSxule0sNbsVNl4P6cdpnTaeNL4antmhSscaE5HZQd0hGwIYcsM7sfeWUiDWFyUIb1FHt0CLQsQ02JhuM0kf3xP9r+4wPm256qbwV5zI21JSbUGI7UEgQlWvHef3N9bjeNKYO+vcyAdrVTJjQ/znEeIT2qiEjRsLN35hYW6VT3LqP0A2ESjvntybl1yFEq+YdMkTLAEzqmk7Yir36BBtKioI79/7VLe2k1pXACxirmfZLmcX023MRJ3XqDwbHRtETs6PZC8ROjX9zhICFgQ+w3Mfnfbhy0OOsVaKkNSw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(36860700016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Y0j8Bunzcuo+eh2PJuueRIv51oney+r94WPAzf3XlZcgNd8aiUoVy66yU3KWrWjl+bgUgYWc4jt93F9lGtDNWnTbNAyyv83pvTA3flp6LLzbsouaRIN7SIhL5Wek2OItCqn7ieyjM5q6kfEVicBjuvFJP4axs0osHa6kY72/6C0Rcj4uSGIKUId7b2FJAgGiBy9a5ZGhHyOaohyhyJ4hqGeS6wAonlryJPbJ14jSPLI6QvW8Kz1jCrDaxTmiZAiZ9aUu0MyMZfORBW+MOwfIo0QPdsyzjq6NLujOiNLSi6nG1QOySDd/JbMxSxJQX3L/N0A0Ws9tnLtzMQ79GprX0nxCs+9SAW9JZrZOFMQxiEIT1I0oHUPMkYtVSJsCOLyI7Sa9GIy76P2lJ6l0AwzD7/KJxwME0YecI7ngPctnbOcdPXAKwj+0PrYBjY001eyF
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2026 17:47:58.8197
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ad3b1cf7-dcad-4a0f-a874-08de7e0400a2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397B0.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6579
X-Rspamd-Queue-Id: 7061423DEDC
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73339-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:dkim,amd.com:mid,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[shivansh.dhiman@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[9]
X-Rspamd-Action: no action



On 07-03-2026 07:40, Sean Christopherson wrote:
> On Thu, Jan 29, 2026, Shivansh Dhiman wrote:
>> +static void svm_recalc_fred_msr_intercepts(struct kvm_vcpu *vcpu)
>> +{
>> +	struct vcpu_svm *svm = to_svm(vcpu);
>> +	bool fred_enabled = svm->vmcb->control.virt_ext & FRED_VIRT_ENABLE_MASK;
> 
> Please use guest_cpu_cap_has().  The VMCB enable bit is a reflection of the
> guest's capabilities, not the other way around.

That makes sense. Will do.

> 
> And s/fred_enabled/intercept.

Ack.

- Shivansh

> 
>> +
>> +	svm_set_intercept_for_msr(vcpu, MSR_IA32_FRED_RSP0, MSR_TYPE_RW, !fred_enabled);
>> +	svm_set_intercept_for_msr(vcpu, MSR_IA32_FRED_RSP1, MSR_TYPE_RW, !fred_enabled);
>> +	svm_set_intercept_for_msr(vcpu, MSR_IA32_FRED_RSP2, MSR_TYPE_RW, !fred_enabled);
>> +	svm_set_intercept_for_msr(vcpu, MSR_IA32_FRED_RSP3, MSR_TYPE_RW, !fred_enabled);
>> +	svm_set_intercept_for_msr(vcpu, MSR_IA32_FRED_STKLVLS, MSR_TYPE_RW, !fred_enabled);
>> +	svm_set_intercept_for_msr(vcpu, MSR_IA32_FRED_SSP1, MSR_TYPE_RW, !fred_enabled);
>> +	svm_set_intercept_for_msr(vcpu, MSR_IA32_FRED_SSP2, MSR_TYPE_RW, !fred_enabled);
>> +	svm_set_intercept_for_msr(vcpu, MSR_IA32_FRED_SSP3, MSR_TYPE_RW, !fred_enabled);
>> +	svm_set_intercept_for_msr(vcpu, MSR_IA32_FRED_CONFIG, MSR_TYPE_RW, !fred_enabled);
>> +}
>> +
>>  static void svm_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
>>  {
>>  	struct vcpu_svm *svm = to_svm(vcpu);
>> @@ -795,6 +811,8 @@ static void svm_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
>>  	if (sev_es_guest(vcpu->kvm))
>>  		sev_es_recalc_msr_intercepts(vcpu);
>>  
>> +	svm_recalc_fred_msr_intercepts(vcpu);
>> +
>>  	/*
>>  	 * x2APIC intercepts are modified on-demand and cannot be filtered by
>>  	 * userspace.
>> -- 
>> 2.43.0
>>


