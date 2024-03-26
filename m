Return-Path: <kvm+bounces-12675-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DFD988BD56
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 10:12:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2B6271F3CBFF
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 09:12:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96AFC481BA;
	Tue, 26 Mar 2024 09:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="NBVdYb7D"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2100.outbound.protection.outlook.com [40.107.96.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE2617722;
	Tue, 26 Mar 2024 09:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.100
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711444323; cv=fail; b=OUsyHDWjkJ1LFMV53MFBM4WMZGHLB7R8Oj5/HMeOiQepVxykz/USyJ8OqzRhg4xIQXmI6kU6u2wqldI02akelKAMaSQPAotVSc571O3WhuIevtAQnvh8S6vwl25MQEtjwBOX17QbCDPUV6MqXxxKed1g8Xf+dwzXArD4TXuaYl0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711444323; c=relaxed/simple;
	bh=9qw17PwI1LahV9RFxMn1XjmF0oSg/q7JmfQe87gBVsc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Zixgskb/oNF8FyofDdRxbpUyA9wr6k8NsTuALPr5bq1uDU5JqQD7uvzGdhpFVYQv+0HmpDgf3SiBe6Cza5NF8mVNyMvqQ0tN+2N0PKGpJH+sHeTRRuzlos5Z4QQeVIvOwi/z7uoU2qt0tk1okBkVDeyikJsBNAceM+6/7VUfA5Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=NBVdYb7D; arc=fail smtp.client-ip=40.107.96.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E1tsVGBqbAjmDTpMQfkBGsq9CSfflYmX0vQfVmgkkrQNwjUzTR+1Hx2Uj2cbFztPm0tqWSDKCQ9qO/i6B7M3hfZeqPT3wetvFYkTKg4Cu+sZQxavl+IoHeI4COIZ7pjNBxHSZx8canOr2pdc2eg9Pf6wfHukiOJIGKH+CC3/MOQphYCEEbz+FqwZk8wI1oD9NYWoNrZsZ8/F7UQ/YRX0qGZ1u02kwQMEC/uILew3MZzKPbqAy/jo4q7sRdWsCFrhKteC4JhR4LlrekKlKYpZQzDYTqCYiHlNTyT7/N7yHYk+ZDfZRwHgiVYBELZjynuYUx9ad8tVVuOVQSrEC2Wh2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yN7Bxl8EONu9iK754uYMWPhnDsfsds6wG1bqGn8qOzw=;
 b=HNF5k24/If4ei2TJDx9djBpXQ1Y46kbs5TeYtuFQSIYAeSunJeyB74DdW4z3L4NxlTDMFPEjPbElQ9Ok83U9EJgoMq4oFVG3w5hBiXF0z5apNhz7MYYtm0WwvxUvpdN4sA1caEVL7TL/0ARwoiYDVn2v4rqz/XQNddzCfchC6eHX8VxDZLkEpMl7q9gOjwJEFVNfvWfNvEXNTv+LWmmekPZHi9niCrszqUG9dYAIOLtRD64JCzBUAq2JTEiPDwMXUP8o9Scflhze0mQTDAPoj9fwO+s+aCRFCuDhPa6iKIy/zwnHSO2UziH8nQ+/d3WCAQzGKRYVy6Tn2RdlZrh/aA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yN7Bxl8EONu9iK754uYMWPhnDsfsds6wG1bqGn8qOzw=;
 b=NBVdYb7Dv5iF/7GHkgQ4qu6eBeUMW/Ic0oWXZdcRR3dyfvVJqgeIdJiPRjf+SY3yoMDtV3yvArVLs9Q4wLs3JBT11UjrKZYXKbnyecbAe/XrMq+zlOqMwr3SkhU8MkeLvfagP2YfgAbtt2SRJHNYPRdqrdEMxspWYkSAw1YbYu8=
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 DM4PR12MB6565.namprd12.prod.outlook.com (2603:10b6:8:8c::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7409.31; Tue, 26 Mar 2024 09:11:59 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::f137:cce2:f2ee:430e]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::f137:cce2:f2ee:430e%3]) with mapi id 15.20.7409.028; Tue, 26 Mar 2024
 09:11:59 +0000
Message-ID: <51b4e33c-c9b3-46c9-8a95-c0450b0e6826@amd.com>
Date: Tue, 26 Mar 2024 14:41:15 +0530
User-Agent: Mozilla Thunderbird
Reply-To: nikunj@amd.com
Subject: Re: [PATCH] KVM: SEV-ES: Don't intercept MSR_IA32_DEBUGCTLMSR for
 SEV-ES guests
To: Ravi Bangoria <ravi.bangoria@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, thomas.lendacky@amd.com
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 michael.roth@amd.com, nikunj.dadhania@amd.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, santosh.shukla@amd.com
References: <20240326081143.715-1-ravi.bangoria@amd.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20240326081143.715-1-ravi.bangoria@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0187.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:be::10) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|DM4PR12MB6565:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	nAOI5Ggsp5m7INwM72uano4hEUTkRrdtjo7Mex3v/k2SsnyrneHHUnF13nbRs8/lH6dCjGuMjA2zdUS10xj3ppAqN17DDktn24EiXPwCRu4Ei/5OJWzZAyV2Nh+aqyNHFCqWDPsnxWiqTq/VcxlAyVHXNoUJSeEyFpbAV/uOIp41CBIXsat/jaQowBooUkJ7bm1uEHKckytdg/x14tV5ZRpcrvWUFCkUHgFusVeVBeTO5TjqFWMzzMUEpgCwav/bb8QhroLHg2hLIrR/sjdfHYbUi36mKj2W4Obh+Yx+NdiaZFEWXpWImZ+RL3ylLqxBrY3pA4SznQ4vHtR+EzW38eXVDf85B27LZiSDSo3HUH4um4+/RueZTU9FH2p3OFKQQLy14oryem4YVfS74ULIawZm6hsqRhkWl9GAgQ5XwH4yXFYGP3ExPmYNSYJXVuZtUAsSJVCqRKZJT7LSiRcmxgM2ReHopAXZA9kaJ8tm86yrGFwLJY9gJKCYksVJJ6vdZ9nXL2GPMRQVjoYB7ELygZmcdSEtyV/WOWqR9lNPQK2Nfg3q4cMZuRAC5ORqTa5IYfORt0gEh6S0Qej7qGIRvlHOt5f/Pqemy87IinfVEI4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(7416005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d2hTblQwTlJ1Q1RDTjFtZXpKL0dHK1RTNFgxaXBRL0tlUHdPcUlGaVJ1Qmhn?=
 =?utf-8?B?T2hBQlYrZVU1NmpDczk2MnlzdDVPcVJoODF6MUx3WTU5TERnY3NpWnRXbGtU?=
 =?utf-8?B?aE1zeVJMT3NwSmJiVWFRUjB0Wm9YbDd2SnRqd05Ud2ZWWHhHN1Yzb3c5Mm1v?=
 =?utf-8?B?bWZOVkExSGE3WlZhbmIyeFRocGFsWTVuaDRPT3F6aGViVGFJTjdIR2xyM0Rt?=
 =?utf-8?B?T2M1dVJtbUF3K0wxbG1MZWQzdFR6RUxOK0h0bXUyelZwR1ZjaC9INHlFV2Vu?=
 =?utf-8?B?dGI4U0M2ZUlEY0VQckJTV1VKcWpxZ2V4Q0VrSUl5MWRZK2dDREFPcEIyTFRy?=
 =?utf-8?B?THZsVTl4VG04VWgxOFlhbkIrQ041Lzg0NGo2Y1BpV1NTZXRvNGlGb1pIMmJX?=
 =?utf-8?B?eWFFRW96aTZjc05TQVV4R1QwUDBjdERqclR3eTlBdFBBVkVrZzdJeUhzRDZ3?=
 =?utf-8?B?TnBVblMvdmE5NnZ5N1lFdVY2RkdLRElpNkEzeTJxMGlWZFpxNmp0TTFlOXBo?=
 =?utf-8?B?U3hRUDIyVWNpUDk0YzlETERBd2c1YXZ4U2FTSW40eWJQcUVWbXk5Nk52WU5t?=
 =?utf-8?B?QkdibGFFbzY0MjlvY0JKZzBiTGpTa1VVWFFYTjY3VlVoeDc5cnkzQXp3VTl3?=
 =?utf-8?B?ZEZ0VmQ0UlVCa1Y0eWMxZG5ZeUZGck5pOUszNFJtWXY0Nk1JUk1CdEU2UlJY?=
 =?utf-8?B?cTY1amxMNTcxaGVjOU01QnZpVnpuaFlPVUIvcTN1cjN5M1pISm9oK05XUDUz?=
 =?utf-8?B?UnE4Rjd4Ui83S3hKNk1zNGpsWkI5Uk8vQnhoV1JBeEFzT2czamYvWEFRS21H?=
 =?utf-8?B?Wm0xQk0xczl2VHhBbEY1Tk81RU1ZVHcrUDd5WGJzUWk2V0NVU1ViK2JiS2lY?=
 =?utf-8?B?cXNwQkNIK05GM2QwdEpERmFhT0tnM0RNOW1GQVBOVCtOZXQzN3EwYmVmRThS?=
 =?utf-8?B?LzBYQlAyQkxDYzFUQXdJcXY4REJ3UVUxaWhtODhHUDduWm5ZTFJ2WnE2Y2kz?=
 =?utf-8?B?WXc5Ui9RSEpKR1ZrczVjU0ZTTXdmVStLNEZvbW5LZWZXYzFQTVQyNnpQeGo0?=
 =?utf-8?B?RFFrL1hwWTdxM1k0eXFqcWZWYjl0THJpM000RkpuUk1SYTM0M09mUkZoampF?=
 =?utf-8?B?K1dpWi9LQ3BWUjNTN2NKSWRPaW9IZ3pSdWtialNHWklzaEVGSThzTVkvRmpr?=
 =?utf-8?B?NWxKTXVKSjkrN1hQd1dSc1E2SnZBV25tQUVyQ1hzTmVsOFpCVDhnTllaRkZl?=
 =?utf-8?B?TkxHYVNGQU1EanpIQllaenZtK0M0U3JNVzZ3VEYxYnNDTlhGT2crMk5lUm41?=
 =?utf-8?B?Z3FnWVQwamt2QngzbTRkRlB0Wldid0dPNEg4SUg4TlcyNzB2elZ5b2wwSGp4?=
 =?utf-8?B?V2NhZU5XTU5ha2IvNnJKejFCSDlqZmRPM0d4S1FDZFdSeEhQQmtrb3ZtdmFU?=
 =?utf-8?B?NlB1cG1Qd2xZak1vaE1xSzBBS0x1Rm1nREVkcWNBWkF3VVVWSG9SOGhJWTZs?=
 =?utf-8?B?UDNybW91Z2EwUlBmZjdRQkZwZDhJY0VnZkQ4MUZBNjJnbDUwSGQ4MlpCUWEy?=
 =?utf-8?B?d2luRm01Qmd0RDN6aFJ3TWc2SWVUTTgva01NRDZqR1hpaldyTWc0V1ZLcFJk?=
 =?utf-8?B?WHZSVVNrbnpXdmdCcDQ5RzJiYjFNY3lkMnZaWGdOV3RvVFRQYmVLdnphNFJH?=
 =?utf-8?B?dzNMV3NGUmdpUnluLzVpRmQ5eVRZbngyQzd5cVkydDZKWGRxd0F5YStROFdi?=
 =?utf-8?B?dWdZa0FRM2VSY2phME8rVlIrTUdUNXBMMnMyRTdnd1g3NEpJNWxrWlBYNkpv?=
 =?utf-8?B?bXB0NGY0RzFMV3ZSM0NiV1BDZ3YwbDBYUk1Kc3NTNThuMGN5dUlhQzhONTM2?=
 =?utf-8?B?TDV2UEttM0dGbUFWZEQ5cDlIalBpcHZWZnFsOWRwZFFxRUJoUnc1Q09QQ3Jq?=
 =?utf-8?B?ZmRvbXI0bkpWMTNnWlZhaG9UUG4wOTkxVFlzTjZ3MjJ4UkpxUHBrdHN1WUdN?=
 =?utf-8?B?NDN4YXVOQisxdzdtM2VMRUVwcU80QWR0aHVkNmk1aDYrczVoUTMyYkI1WllJ?=
 =?utf-8?B?dndIOHJUU01PU2ZGSGNpREVoRkRaNHZWQ2lza0ZUTkduL3BLUEVnSUZhdXVV?=
 =?utf-8?Q?Shbf/yumNO7D88e8jR6qwazTl?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19f609b3-768e-40af-e63d-08dc4d74cab0
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2024 09:11:59.5733
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J6T39t4AvyPqCfAsdzs4wGX+tM5NZE3Ms3DVjQfNODeYn/jvuPwFMOvXhubBxmALZMuDbVsktAAJcwIGmsimTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6565

On 3/26/2024 1:41 PM, Ravi Bangoria wrote:
> Currently, LBR Virtualization is dynamically enabled and disabled for
> a vcpu by intercepting writes to MSR_IA32_DEBUGCTLMSR. This helps by
> avoiding unnecessary save/restore of LBR MSRs when nobody is using it
> in the guest. However, SEV-ES guest mandates LBR Virtualization to be
> _always_ ON[1] and thus this dynamic toggling doesn't work for SEV-ES
> guest, in fact it results into fatal error:
> 
> SEV-ES guest on Zen3, kvm-amd.ko loaded with lbrv=1
> 
>   [guest ~]# wrmsr 0x1d9 0x4
>   KVM: entry failed, hardware error 0xffffffff
>   EAX=00000004 EBX=00000000 ECX=000001d9 EDX=00000000
>   ...
> 
> Fix this by never intercepting MSR_IA32_DEBUGCTLMSR for SEV-ES guests.
> 
> [1]: AMD64 Architecture Programmer's Manual Pub. 40332, Rev. 4.07 - June
>      2023, Vol 2, 15.35.2 Enabling SEV-ES.
>      https://bugzilla.kernel.org/attachment.cgi?id=304653
> 
> Fixes: 376c6d285017 ("KVM: SVM: Provide support for SEV-ES vCPU creation/loading")
> Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>

Reviewed-by: Nikunj A Dadhania <nikunj@amd.com>

> ---
>  arch/x86/kvm/svm/sev.c | 1 +
>  arch/x86/kvm/svm/svm.c | 1 +
>  arch/x86/kvm/svm/svm.h | 2 +-
>  3 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index a8ce5226b3b5..ef932a7ff9bd 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3073,6 +3073,7 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
>  	/* Clear intercepts on selected MSRs */
>  	set_msr_interception(vcpu, svm->msrpm, MSR_EFER, 1, 1);
>  	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_CR_PAT, 1, 1);
> +	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_DEBUGCTLMSR, 1, 1);
>  	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHFROMIP, 1, 1);
>  	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHTOIP, 1, 1);
>  	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTFROMIP, 1, 1);
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index e90b429c84f1..5a82135ae84e 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -99,6 +99,7 @@ static const struct svm_direct_access_msrs {
>  	{ .index = MSR_IA32_SPEC_CTRL,			.always = false },
>  	{ .index = MSR_IA32_PRED_CMD,			.always = false },
>  	{ .index = MSR_IA32_FLUSH_CMD,			.always = false },
> +	{ .index = MSR_IA32_DEBUGCTLMSR,		.always = false },
>  	{ .index = MSR_IA32_LASTBRANCHFROMIP,		.always = false },
>  	{ .index = MSR_IA32_LASTBRANCHTOIP,		.always = false },
>  	{ .index = MSR_IA32_LASTINTFROMIP,		.always = false },
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 8ef95139cd24..7a1b60bcebff 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -30,7 +30,7 @@
>  #define	IOPM_SIZE PAGE_SIZE * 3
>  #define	MSRPM_SIZE PAGE_SIZE * 2
>  
> -#define MAX_DIRECT_ACCESS_MSRS	47
> +#define MAX_DIRECT_ACCESS_MSRS	48
>  #define MSRPM_OFFSETS	32
>  extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
>  extern bool npt_enabled;


