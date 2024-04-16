Return-Path: <kvm+bounces-14740-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E9DA58A666B
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 10:49:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2BC7DB24D88
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 08:49:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84DCE84A41;
	Tue, 16 Apr 2024 08:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="jOhQeysN"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2083.outbound.protection.outlook.com [40.107.92.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 143811F19A;
	Tue, 16 Apr 2024 08:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713257325; cv=fail; b=VIIIhMX2U8PbPc7OA7+Wch49qC0iHXoxUz/mxJZUfAGJzWMI3RCoYpjSzU9gzhjQi9YcEiEHmKm8n/nf9WtO4FnZWQUYpGpfR8vDVnjsM6OJ7i7ez3HET9VWECqjoKG4sbsnUdTXTSlJjpnNNKRbee66KAjblS/yebdu5YvXmrA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713257325; c=relaxed/simple;
	bh=SrvTHfEwq1tWBL6aVsAbF5T0+TLhxxTlgPMCjFsjEqc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=EsYS4ErCMLfn1lzOd5QwNTm5GH7ifjH5z7YNwgJAkz0VwqoTGsE/SPBPPu8W6DQmJH8K1UHuq1K5Yja5ikNSj/OT0IHzf1Zkt0z3NXQhtrCxs+Xki/acoIMTbwHpQXEGaucnx1a0DtEg7dwKD1CcRuYuyWQ8D+mtelFqiMAVJMM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=jOhQeysN; arc=fail smtp.client-ip=40.107.92.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bPPxS8Q+SORokeAwhCnfhNNbtAIBVS8HXu2CTGdjJ3wPp9cO46ps5os02egcNZ+ubT/xRYKOz3WH7tb41hS8MBwB5GoH8l1nR3y3qHo1kt2+nccaVTfSzkLKXF5RZwDGiN7FBO6ZXG8HbuO4vmtlDWQh2wbUdikj5bpjUL/Hls/F3EizPeO5ZPNJUNmHspmaOgW+qXwus5CFkrAsMsM29GSPQ51iP8DRddqNz6i6dDsnYi4Kepo6bVCpwUnkODFCHbdE8vc9TuT3WiJHJS5Kpl60YsuRAd6AC1WE9fGGuXngj9MFMiY+ikwz7+osmqwTv4I7ywISLm35ymxDhfEZEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=50f+5SxmE99UHj2B74Yqeqc2bBJ3RG2edcgRzskxOLI=;
 b=NSBIO/AmBqwT41C2nZtok9LW4fvNrTrhI7kAxUhk26SoGgMHJF24dZ8OLv/dtG9wFtPFJjxStgKDYl4TOKSeZxAQRjdfnoW/qPwLIYCXfjwdd0SCYHK63rLZ6d1IPvB5T7Qi8G8MNfVMklu8BxA6SRIWj742pXGkl6PjZs9P3KEN1wSIb2nR6QLQkGgKoMPbMv5S4K8jCSqAJ87E6RXAVt5Kj4/NT0qmativpUFHBhp0TAr858Kwx97jhJnHXa30g4IXpajEgheDO2uRhiLZtmpOxtbxo/ycAPJ6d0sm4UQuJMLqsEONIDeqR+zwhlrp1BzchDWr3/YCa/mQPGqEJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=50f+5SxmE99UHj2B74Yqeqc2bBJ3RG2edcgRzskxOLI=;
 b=jOhQeysNkyF2VP7O8ilb7XajfakJoGteOSa2lQugEZiSwpWKEekRoC4B91vAcLDJpu5EIN1CTcyuojxvAilmj/AnQGUwYnBkeOEraBeFHtt8UA6yrM0JR6cnSCoVcn/G0/p2MjOXgPGwaOCdjrCBfDkgepBmfKhE/eyskc9OcGY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB2810.namprd12.prod.outlook.com (2603:10b6:5:41::21) by
 IA1PR12MB8588.namprd12.prod.outlook.com (2603:10b6:208:44f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.50; Tue, 16 Apr
 2024 08:48:41 +0000
Received: from DM6PR12MB2810.namprd12.prod.outlook.com
 ([fe80::8af6:1232:41ce:24a3]) by DM6PR12MB2810.namprd12.prod.outlook.com
 ([fe80::8af6:1232:41ce:24a3%7]) with mapi id 15.20.7409.053; Tue, 16 Apr 2024
 08:48:41 +0000
Message-ID: <fb36eeb4-c6a7-32eb-ccd3-ecc94324f62f@amd.com>
Date: Tue, 16 Apr 2024 10:48:28 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v2] KVM: SEV-ES: Don't intercept MSR_IA32_DEBUGCTLMSR for
 SEV-ES guests
Content-Language: en-US
To: Ravi Bangoria <ravi.bangoria@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, thomas.lendacky@amd.com
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 michael.roth@amd.com, nikunj.dadhania@amd.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, santosh.shukla@amd.com
References: <20240416050338.517-1-ravi.bangoria@amd.com>
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <20240416050338.517-1-ravi.bangoria@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0422.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:d1::16) To DM6PR12MB2810.namprd12.prod.outlook.com
 (2603:10b6:5:41::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2810:EE_|IA1PR12MB8588:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c3bfa8b-0758-4703-cf43-08dc5df203d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	iCjfN3yOu7yXbaxUyFdZmDLeBzk8k9rYWzNKxPt9/KwcLsi97USfBYUZgmsUp+rbKnz8n2/QrVEpksmJKqprV+7P8sH4gjE48KmCCoe6FA5h0xAi1gI5lw1K+/Q3SJgQkPsU3Edr07znxRyl9tjnzO2lr89EEOCCQVd/LCYg/phU2umyzmRgoHhAla40mreVGyApijbL/5/y4MAHTSr+dRsuwd96s4f08lnWD6kOX3TXoc53n3Mi8AWRzvHFzDToGvBUrI5eHKGAXa58SAxlGFQGVM0HSESjJocAbX7Fgp+EtJV9hC+3ELjZfMzLSPiv+kA62fGHIZJo01EXzlqNkCf0ylvGfR0RywlGIxJabDb2mLCDyEe2Ef1ieTXEIu51Y6dK4jTjO/qYumDwAWO7rJ4e8dbi3VTaEast78o8C5RxpNGOozifVdlba0ubAymeoPPuBFEN6VvEJwb9Ur6ZUhMcs3U9A6V2lUzVi5CWYX7vMPsWh7Q20IrspX3Qwad68vABXjQcabnJlW9RUmALK35VJOerm34eeZugdHo7LoIpEofMU3biYvXcO2deMzlxe2MSQlzV5GqwjkAe1H5FsRw9cAO7XJWNi0dRHOTE4GudiI1qYOXhoh93Pj6M/u2Y9Rorla0AgIjfMDQ7+Te3e9TedBoNBZ4EoHSARinPOWU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2810.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eC9xR1BqS1VPb2tuR3hzQVVwekQyYmptV0NLUkVRZ0tqOURsVU8ydGt0U1Nq?=
 =?utf-8?B?WE43aVhvOGZRWU1zVEwrZEs1amh3QTdrcjlZYzR3ZG5uK2ZaMUlJd29Vb0x3?=
 =?utf-8?B?MXlRUGpLdTlhS0F5OEMvNDFwNDlxYzNWb013VVAwK2UxZHNrQjEwK2E3cW5W?=
 =?utf-8?B?YkNNaitvNDNBL1BjZzFwTm1jcm4wRjZZRkl6WFdMeUZtY01jUWtTSStWUUpy?=
 =?utf-8?B?bFMyYjlWUjUyNnpBRFlVakhNR1VZZTg4Yi9CZ0FWUitvemtkeVYvSnhqeVp6?=
 =?utf-8?B?N25HS3VtWHlKWFVEVmNaWUFxdkdNYkhDaDdpRzA4RWtxeUhObmtoWjFSMkxQ?=
 =?utf-8?B?U20rUTg3UkVtcXM0UDJTYW9zcVo5SFBCaWdZMUcwN3czUnhUTVRXTEREcE1z?=
 =?utf-8?B?Sm1xOFVIb2pDNDFFRkJDbW9VcmlCMkFhcGZFTmtsNG9BMC80SVQyVmlITXJ6?=
 =?utf-8?B?M1FKVGJTMXduajJtaHhidG9VZEYrMzErM1BqbVZKZ2VPSi9zTU45U0k5WG1x?=
 =?utf-8?B?WWxQdEdNWUZpcjgzRjhzVHNrUGVUSzQ2YnVhczQrNmhJeGRoZkhHc3RFNXpS?=
 =?utf-8?B?c2V6Mkx6SGRYM0NFYlY5ZWRmekdDZ2laZ202Z1hWNW1ZVUlTNTJ3TmxNREtB?=
 =?utf-8?B?T3p1YkMxNHQ0Q0wrWnVZRDgyV2NVM3FvbDErTFBjV3I2cjJ6Rmt5dWl5bGI0?=
 =?utf-8?B?N3M4Q2tpSVBWSVNrWWlMdzdBYlJ1WXREZXlHKzVyNzlOalRySC8yYlZjdWpN?=
 =?utf-8?B?S1pFMmlvWmVwZU4ybXNGa1hvT0o5ejdCRWFkdmcrNElFKzVSM0JvNUF3Z1ZQ?=
 =?utf-8?B?ZEtESkIvWjFzRWNDUXBTR1lGcDhWWTFzMEN0dGdlVFVUMDkzTDFEOUlQOXVH?=
 =?utf-8?B?ODJRNGM3dXd1aU1xQ0d4MFJPdlptM3l1L2diUFlvcGhvaXFiVU1nOTlzNHl3?=
 =?utf-8?B?ci8vR29EVTNNa1hTVHNEQXBBeDNqbnFwd0xZTTFGV3hwaDY5TDM5b0F6S3Zo?=
 =?utf-8?B?ZFFBT2k0c1ZGZUswS3Q2SjVxZzlseW5Zd0xHK1Y5Qm14ak5BejJlaWs2MzNH?=
 =?utf-8?B?b2NTSmZlU05vaWhvM29iZXlMSFRzVE9xRUh3N1haa2RwU3N1L1hvaDhTOGw3?=
 =?utf-8?B?ZjRucDhOMTBrL3ZmVlE1Q0kwV3A1b2Uzc3E4TjErckdEQytUaEpaZk44Njkx?=
 =?utf-8?B?dXB5TTJtUEJZbDAyR09oeW9heExTUUptdnlEaUFFUmlCTTJmTkQvRDdmYnZz?=
 =?utf-8?B?dEN3ZVNCQjh2QXVvZzA4YkJCYU5SUEVVc3JQakV3NWpSL1RQbVFqdTlic09p?=
 =?utf-8?B?WnlBYVRBaTJyb2pxK2hLUVhFT2NzL0g2WnRGdjdGZThhT1IvK2J4NFR6UlZD?=
 =?utf-8?B?Q0lPVHVOOFk3Z0Z4bE1zQ2NwVDJ5QWRKaXJSdFFDQnBFS0ZhWnk3YndPcWVB?=
 =?utf-8?B?UzBWenYvZWh2b0ROZ21MYVpYQm8vNXVGM2ZJTm04WUo0WTRXeVhub2FKVnMr?=
 =?utf-8?B?NTN3aFgwcWdLb1c2R0lyVzg5WC9Ub3Uxa1ZBZkZidEMvZjdaS1lHQi9Vb0x2?=
 =?utf-8?B?U1d1OG80emJ1cUJuS2g2YW10N3g3SFhZcWtTWU9NOThWME9UQndIai9kYjR4?=
 =?utf-8?B?OWE5ZTdaUVFGVW9NaWdGMEYxOHplT0NSVjBmYXhVeERSV05iMkxHa0EvcjJG?=
 =?utf-8?B?NnlnSkZpWm1lOWhkNzRZblFqb0R6YUN4UDBZYW5nU3p3V1JmRitzd3VhR2d2?=
 =?utf-8?B?a05xM1k5OUZXakRWVm44dXorQUg3b0c0S0RNa21sWEIwTTZWY0phUVdQeXdu?=
 =?utf-8?B?N2xlWUpma3dGNHJtRHRSeVh5MWJLak12ZXhNc3BONFQxUXFzdis2OThZR2tR?=
 =?utf-8?B?YWc3cW5rbjhnL2VCVVlxQ1NKSFRpamxkQmI5UEJ2RGRFQnhTaWgwNkE3M3RT?=
 =?utf-8?B?K0ROcURNaDVKT3FSczd5WWpNcE9lZFJIZ0Jkc0lLWi9TNkJQU0Fva1c3OWty?=
 =?utf-8?B?cXVQdnFGSExNRFViNVhRU2FpdXNLTXZrb0dXWkx1Rm9ma0dpK0w4S2Z1OEhC?=
 =?utf-8?B?YTF1QktScC92R1B5b1QyMG5lQkdMR0dBTVBncXNqejFxYTErRTdLbFlhUnlv?=
 =?utf-8?Q?dMrJnIrswh1KJp1AUKxiDuasi?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c3bfa8b-0758-4703-cf43-08dc5df203d3
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2810.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2024 08:48:41.1003
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eoAPjr93MHo9VcelmWIUsIPOiqJuKfk2xQH0wuuISz7437ZG/FZrN8uVKIqcFSbhd5rL5/+vof0M2mWmuAjgRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8588

On 4/16/2024 7:03 AM, Ravi Bangoria wrote:
> Currently, LBR Virtualization is dynamically enabled and disabled for
> a vcpu by intercepting writes to MSR_IA32_DEBUGCTLMSR. This helps by
> avoiding unnecessary save/restore of LBR MSRs when nobody is using it
> in the guest. However, SEV-ES guest mandates LBR Virtualization to be
> _always_ ON[1] and thus this dynamic toggling doesn't work for SEV-ES
> guest, in fact it results into fatal error:
> 
> SEV-ES guest on Zen3, kvm-amd.ko loaded with lbrv=1
> 
>    [guest ~]# wrmsr 0x1d9 0x4
>    KVM: entry failed, hardware error 0xffffffff
>    EAX=00000004 EBX=00000000 ECX=000001d9 EDX=00000000
>    ...
> 
> Fix this by never intercepting MSR_IA32_DEBUGCTLMSR for SEV-ES guests.
> No additional save/restore logic is required since MSR_IA32_DEBUGCTLMSR
> is of swap type A.
> 
> [1]: AMD64 Architecture Programmer's Manual Pub. 40332, Rev. 4.07 - June
>       2023, Vol 2, 15.35.2 Enabling SEV-ES.
>       https://bugzilla.kernel.org/attachment.cgi?id=304653
> 
> Fixes: 376c6d285017 ("KVM: SVM: Provide support for SEV-ES vCPU creation/loading")
> Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
> Reviewed-by: Nikunj A Dadhania <nikunj@amd.com>
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>

> ---
> v1: https://lore.kernel.org/r/20240326081143.715-1-ravi.bangoria@amd.com
> v1->v2:
>    - Add MSR swap type detail in the patch description. No code changes.
> 
>   arch/x86/kvm/svm/sev.c | 1 +
>   arch/x86/kvm/svm/svm.c | 1 +
>   arch/x86/kvm/svm/svm.h | 2 +-
>   3 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index a8ce5226b3b5..ef932a7ff9bd 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3073,6 +3073,7 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
>   	/* Clear intercepts on selected MSRs */
>   	set_msr_interception(vcpu, svm->msrpm, MSR_EFER, 1, 1);
>   	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_CR_PAT, 1, 1);
> +	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_DEBUGCTLMSR, 1, 1);
>   	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHFROMIP, 1, 1);
>   	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHTOIP, 1, 1);
>   	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTFROMIP, 1, 1);
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index e90b429c84f1..5a82135ae84e 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -99,6 +99,7 @@ static const struct svm_direct_access_msrs {
>   	{ .index = MSR_IA32_SPEC_CTRL,			.always = false },
>   	{ .index = MSR_IA32_PRED_CMD,			.always = false },
>   	{ .index = MSR_IA32_FLUSH_CMD,			.always = false },
> +	{ .index = MSR_IA32_DEBUGCTLMSR,		.always = false },
>   	{ .index = MSR_IA32_LASTBRANCHFROMIP,		.always = false },
>   	{ .index = MSR_IA32_LASTBRANCHTOIP,		.always = false },
>   	{ .index = MSR_IA32_LASTINTFROMIP,		.always = false },
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 8ef95139cd24..7a1b60bcebff 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -30,7 +30,7 @@
>   #define	IOPM_SIZE PAGE_SIZE * 3
>   #define	MSRPM_SIZE PAGE_SIZE * 2
>   
> -#define MAX_DIRECT_ACCESS_MSRS	47
> +#define MAX_DIRECT_ACCESS_MSRS	48
>   #define MSRPM_OFFSETS	32
>   extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
>   extern bool npt_enabled;


