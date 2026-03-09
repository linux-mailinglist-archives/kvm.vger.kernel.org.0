Return-Path: <kvm+bounces-73361-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 5mhYMFQkr2mzOgIAu9opvQ
	(envelope-from <kvm+bounces-73361-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 20:49:40 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 12CD424052F
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 20:49:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4E1C130A62CA
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 19:47:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38A07410D2E;
	Mon,  9 Mar 2026 19:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="gEectTNJ"
X-Original-To: kvm@vger.kernel.org
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010055.outbound.protection.outlook.com [52.101.85.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F5F325495;
	Mon,  9 Mar 2026 19:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773085639; cv=fail; b=Lfgjlz9+L9CmWvcmduhDuPGUNU8VC1yQwVE25+G5Y0+3Y0HAVPiDWtceqEdRNcBKV7zsVzhTQQ9N1+OcCSckKcSFp4s3tFHcTMsFwExHZjYSR5xr0TxrMMp6ytRUS0S2+6OgrqC7A+jxz4VRKOG0WmotqJp6LtRrp46/YcTQXHk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773085639; c=relaxed/simple;
	bh=06fjXcy2Ob8XQ1Kd697lD57NtRARmOB2nNe2N3XSjm8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=uVmMANxTbziSialx5dBzr/utQrCE5CZk6DJcw1K4uZWM0vBahjqrHGsaK+mVxuqzGrh+w+XfBEmC4a57N4b/4dV7stKOXonE4U6jI4ybVdCBgWKD1e20ZRo+s44aX8s8ug78Sz+MYcFeB2/hAdUJlKDVIssOjKeXW4orsJ+as3A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=gEectTNJ; arc=fail smtp.client-ip=52.101.85.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qHx0YqsVvQD82tkvjeZee6hNka3UVj9Jf8yIb7amEq7IUHH/Q7B2uCHy1WV1Nbjl3pV3rNg7MoBFuscsjNqUzW12BOX+XgCXVQYAP6snzZZBxlCfwDjhpYwgZOYA8QGhbn9GyC8ktOnp/tuYurQGrtGYE7ZjdUqlig9z/KRZhvuAtd/tRtucNu7ehn2a6ZaFS+223WFmOhocR3ZNedAY2Q/xOxvzS0eqV9QFGgPhO86fYFfWkxhSXrNJpac4Gj6ve1aMgbfG+gCXO/3wlnwdb4NMIlCrdrcFjJTxFSWbRxzNoPllJL6C3Vfl9ZJWOIfqvISYiUN394CFUvtL+eE20A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7BQhZP5pt/JEMHWlmzhJUnoC67q2o93K/vOdjE4kopk=;
 b=KgSC0KOjYbuRxrzEFZzgVyfGTeSpGAgkroEd32F8y2lB9RqnF3wxSowoaFrtyGUC1Dg/XVEQJ0UTttBmmgZZQ/qUM8zMGK4WfCvNJvfOJ/OaRHMCyK7lvUYdYgK2McW7jbxLACfT6g4mvfapwpe4RHNxDMH3976ZpfG/Riz4nRxOPxLkBIXKxik5ti08d3zEUc5aJ/jzKY6Tv8XZsuc9m0Uv5SImjkwR3xTTJKzgc36nUtGA+cjFxgkTWhMmEmyt0RRzdhV3pyhRo+fMzXvJDTMlHlgWyW0bToiPgwN+Neh6yDBMpWGs0+yYYNPJKxR3CTZdq0NxKjGu5DLkUOPVIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7BQhZP5pt/JEMHWlmzhJUnoC67q2o93K/vOdjE4kopk=;
 b=gEectTNJ0NUvZEr9gLljJfsAhU5st7Wwi1O1Pg57FrZumIHLpgRj1ml4BOKkubJq39/Mvg3CEievhmJV5zRDcOlJNdr9BLAJNeJu1lfJbK0lDRTHuRONyag00+XXhUcgLSoq1fIlXtjhcGj+ETFTA9ut9A0iDkUqq/nKNtTaBU4=
Received: from SA1P222CA0043.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:2d0::17)
 by DM6PR12MB4418.namprd12.prod.outlook.com (2603:10b6:5:28e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.11; Mon, 9 Mar
 2026 19:47:15 +0000
Received: from SN1PEPF000397AE.namprd05.prod.outlook.com
 (2603:10b6:806:2d0:cafe::16) by SA1P222CA0043.outlook.office365.com
 (2603:10b6:806:2d0::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9678.25 via Frontend Transport; Mon,
 9 Mar 2026 19:47:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 SN1PEPF000397AE.mail.protection.outlook.com (10.167.248.52) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9678.18 via Frontend Transport; Mon, 9 Mar 2026 19:47:14 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 9 Mar
 2026 14:47:14 -0500
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 9 Mar
 2026 14:47:14 -0500
Received: from [10.143.203.87] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Mon, 9 Mar 2026 14:47:09 -0500
Message-ID: <e84cba12-5b69-44fc-b789-01daf03ae269@amd.com>
Date: Tue, 10 Mar 2026 01:17:08 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/7] KVM: SVM: Populate FRED event data on event injection
To: Paolo Bonzini <pbonzini@redhat.com>, Shivansh Dhiman
	<shivansh.dhiman@amd.com>, <seanjc@google.com>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<xin@zytor.com>, <nikunj.dadhania@amd.com>, <santosh.shukla@amd.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20260129063653.3553076-1-shivansh.dhiman@amd.com>
 <20260129063653.3553076-5-shivansh.dhiman@amd.com>
 <d9741f70-4af5-448b-a63d-5fdeb7e03ace@redhat.com>
Content-Language: en-US
From: Shivansh Dhiman <shivansh.dhiman@amd.com>
In-Reply-To: <d9741f70-4af5-448b-a63d-5fdeb7e03ace@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000397AE:EE_|DM6PR12MB4418:EE_
X-MS-Office365-Filtering-Correlation-Id: d4ac4ec9-4983-4ad5-ee42-08de7e14a9da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|1800799024|36860700016;
X-Microsoft-Antispam-Message-Info:
	vL2+ydND2ytQg97hI3kaWEdVbYTGKcHGhek834bFTiST52u0lGPQdXR6gzZZ0fMeu377wGrROFRYNLwvRxLpjKIFRTwQkWnYVFzuKVvilCLPDcW5NcnqNHADeDVwxPalW5f1g9kfI7qCvMW9u31Y2gWXGs1P6b93QZzRvrOTx8CQpSjLZCebqXV+uKdTufcoabtdkr2YymLkfA8Px74jQEg4TXtObuHxlLQ0VvClV7SZDqRROFoeywxTHrQDU0Wvizp+RK4NY6/mnsMSqgVBXGaY/ik8UW7vcqBpjaGeebv5weLeP2fkCgkfxDCD6hmbEef8SHeDOh9JCBWOCcvQWNMq5mD4IHaAqffbJ068PwAMCrx5rbR3QFKrv1BkpkTFSjmYwio04bLlX7wHutKVQ0lrRRA6H1p2vzzP7KfGXPbbM5o/MYoko8onE+mFMIhyI8G+jLniyV2c8U7IrA0n/CskVYLFyqDjOXZgQC0OMkKEdEEUTyLCl/HfKm2pd7sy6X715QZmFdb3aSTZr+bo80u7LWo754XIxTrlAHui4FjSNjMhR4OM+rH3vlE0nAMoZ0jG22RncuHVZ3RMkRW05VRA1OZQdQXyg1Q8ZcH6YVSLSGGjmWz0zuXnYTZOdnVqUIXQrIdhUz1IKvQNNU54bc2hlb35FnCVziDSW21eOhIyYLcGhPI4TWgRO9yZj2yCAo7gfK74uRaEQggN5fH2fFxjAvDsQH2vOmuiKzhDyWSJXgyfuhCdL1b4PfVUILeDkU/BIdJ94FmGctyoKsSeJw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(1800799024)(36860700016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	AAeGGiu/vMqzmhOaGe+r2fvmbCCQM/H4YVEPHPyaNzgc4+aYRSFhiRPgZNf9LbNRV02AnoIwykjXwNuLmiiPwPXJOXay7fRmtFWJXCfJWzaBcZJYPPgDIcJYY8BNnabQYNvLnbRxN/gomd2z1yR2PndxfvdTKLNArXXaVBveJenrMbDfdO0gsZ7GUi+ZD6yker30EZk1aKLqf7mMxROx7gyyt1+1fdp3isC52jXbdH29yV2inkNhUEH027yKNsoQulC2XAf/mjLEHLOWOSio4a4D+huFaNHXN2/6LTkAf/MSr8l0feuISf8ouNqA2o7zG0JWDs0k56zy2VmQl1NhP5B1SR0rzpOKM2dAOoL5HEeaQ17UnUNdkKncznSjmePZ0DYSuJnqat+i4LyP1M1VFueQdmlO4HSbrua+BBMZZaq9fdq1B+PE9UTMJ0O44w/o
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2026 19:47:14.6674
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d4ac4ec9-4983-4ad5-ee42-08de7e14a9da
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397AE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4418
X-Rspamd-Queue-Id: 12CD424052F
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73361-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,amd.com:dkim,amd.com:email,amd.com:mid];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[shivansh.dhiman@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[9]
X-Rspamd-Action: no action

Hey Paolo,

On 06-03-2026 17:01, Paolo Bonzini wrote:
> On 1/29/26 07:36, Shivansh Dhiman wrote:
>> From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
>>
>> Set injected-event data (in EVENTINJDATA) when injecting an event,
>> use EXITINTDATA for populating the injected-event data during
>> reinjection.
>>
>> Unlike IDT using some extra CPU register as part of an event
>> context, e.g., %cr2 for #PF, FRED saves a complete event context
>> in its stack frame, e.g., FRED saves the faulting linear address
>> of a #PF into the event data field defined in its stack frame.
>>
>> Populate the EVENTINJDATA during event injection. The event data
>> will be pushed into a FRED stack frame for VM entries that inject
>> an event using FRED event delivery.
>>
>> Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
>> Co-developed-by: Shivansh Dhiman <shivansh.dhiman@amd.com>
>> Signed-off-by: Shivansh Dhiman <shivansh.dhiman@amd.com>
>> ---
>>   arch/x86/kvm/svm/svm.c | 22 ++++++++++++++++++----
>>   1 file changed, 18 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index ddd8941af6f0..693b46d715b4 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -374,6 +374,10 @@ static void svm_inject_exception(struct kvm_vcpu *vcpu)
>>               | SVM_EVTINJ_VALID
>>               | (ex->has_error_code ? SVM_EVTINJ_VALID_ERR : 0)
>>               | SVM_EVTINJ_TYPE_EXEPT;
>> +
>> +     if (is_fred_enabled(vcpu))
>> +             svm->vmcb->control.event_inj_data = ex->event_data;
>> +
>>       svm->vmcb->control.event_inj_err = ex->error_code;
>>   }
>>
>> @@ -4066,7 +4070,7 @@ static void svm_complete_soft_interrupt(struct kvm_vcpu *vcpu, u8 vector,
>>               kvm_rip_write(vcpu, svm->soft_int_old_rip);
>>   }
>>
>> -static void svm_complete_interrupts(struct kvm_vcpu *vcpu)
>> +static void svm_complete_interrupts(struct kvm_vcpu *vcpu, bool reinject_on_vmexit)
>>   {
>>       struct vcpu_svm *svm = to_svm(vcpu);
>>       u8 vector;
>> @@ -4111,6 +4115,7 @@ static void svm_complete_interrupts(struct kvm_vcpu *vcpu)
>>               break;
>>       case SVM_EXITINTINFO_TYPE_EXEPT: {
>>               u32 error_code = 0;
>> +             u64 event_data = 0;
>>
>>               /*
>>                * Never re-inject a #VC exception.
>> @@ -4121,9 +4126,18 @@ static void svm_complete_interrupts(struct kvm_vcpu *vcpu)
>>               if (exitintinfo & SVM_EXITINTINFO_VALID_ERR)
>>                       error_code = svm->vmcb->control.exit_int_info_err;
>>
>> +             /*
>> +              * FRED requires an additional field to pass injected-event
>> +              * data to the guest.
>> +              */
>> +             if (is_fred_enabled(vcpu) && (vector == PF_VECTOR || vector == DB_VECTOR))
>> +                     event_data = reinject_on_vmexit ?
>> +                                     svm->vmcb->control.exit_int_data :
>> +                                     svm->vmcb->control.event_inj_data;
> 
> The new argument is not needed, just...

Agreed. That'll simplify this to:

        if (is_fred_enabled(vcpu) && (vector == PF_VECTOR || vector == DB_VECTOR))
                event_data = svm->vmcb->control.exit_int_data;

> 
>> @@ -4146,7 +4160,7 @@ static void svm_cancel_injection(struct kvm_vcpu *vcpu)
>>       control->exit_int_info = control->event_inj;
>>       control->exit_int_info_err = control->event_inj_err;
> 
> ... move event_inj into exit_int here, similar to the other fields:
> 
>        control->exit_int_data = control->event_inj_data;

Ack.

- Shivansh

> 
> Paolo
> 
>>       control->event_inj = 0;
>> -     svm_complete_interrupts(vcpu);
>> +     svm_complete_interrupts(vcpu, false);
>>   }
>>
>>   static int svm_vcpu_pre_run(struct kvm_vcpu *vcpu)
>> @@ -4382,7 +4396,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
>>
>>       trace_kvm_exit(vcpu, KVM_ISA_SVM);
>>
>> -     svm_complete_interrupts(vcpu);
>> +     svm_complete_interrupts(vcpu, true);
>>
>>       return svm_exit_handlers_fastpath(vcpu);
>>   }
> 


