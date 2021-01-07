Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 645442ED394
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 16:34:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728411AbhAGPdd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 10:33:33 -0500
Received: from mail-co1nam11on2080.outbound.protection.outlook.com ([40.107.220.80]:57350
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728372AbhAGPdd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 10:33:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I9TYM9TTsg0gO4ZjQZdvwc7rtcOSBII1ZaFBnkHZFkZmdJowoAHhhRsRkg+cLRf3v+YKvd5qE0mAfi4FYO4XsDIwKohEdc3YlJpsatMcezsmBn2xD/cCzYzuO2AgZhBAglsZ8xhyXpQB+BiInXkfb1EOui+ENsfo6G2KHchQVr7dzHzoThtQhtxJtJ+7OYDbyApHSCx+0PIemcyisIjoLb3c4a+teLQxjDvx29GBHEv6wljXAEhiPpgR2ULagjdpRvauO0N5A4WCS3fmKpNtJNh/OhLBU3NhCunhO3LeNXLgnSCNOD/DdHQ/oO+h3gof2nA6vEPmxy3Coj4FLX06sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3rVcqZxhTgHEHullWV9dYj+DqkAaVl+QjPajRpUptmI=;
 b=eKd/1r5Nr5bTayI3njrecBCYAhkIPKLtn+WgDo70NAGxfRv31thTaOkzIgY5ME6R0g4IISC/4esX9jtYiyDhZ438reVbTEA57AFXOF0e1SZu4INm+zugo4eUpRW2i6SnOFzhGzjCXi695gzrGg+0ag7aVPwlQQOnNjG5q/8+bMI7Sp2wL3xovq2CjHGb4L9vTXq8KSov82ZWxjSAuIIMlfT0mWfElJ35oxjvHWDCOgAkVpqDsscPcwDJf82gY/FOq5yQKGz2U8Q7FLv41syqCej+DiJV40H87izf1OvXv+rWPoo97vWN6dXML09EZYE+Bzii+dwMIllTm4YaOx0Iog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3rVcqZxhTgHEHullWV9dYj+DqkAaVl+QjPajRpUptmI=;
 b=ftQDkLqMDZRhHziJvEb7D1q6xnAGoIkE2x96yDbiqnRdMsG2xS4ZlgMgK77GMuejMDyvrGd9ah7Ypv1EWk/XjEQuM32C7s6MoWmYQE9TX4On2g4L9h3f4R4d0FkvpGCgjWPiCfLfHUf0xEYqP+S7IjAftGjfm3pLOq2bca0cHBE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3721.23; Thu, 7 Jan 2021 15:32:39 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845%12]) with mapi id 15.20.3721.024; Thu, 7 Jan 2021
 15:32:39 +0000
Subject: Re: [PATCH v3 1/3] KVM: SVM: use vmsave/vmload for saving/restoring
 additional host state
To:     Sean Christopherson <seanjc@google.com>,
        Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
References: <20210105143749.557054-1-michael.roth@amd.com>
 <20210105143749.557054-2-michael.roth@amd.com> <X/Sfw15OWarseivB@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <b04bf56d-c6ef-3636-020f-ce107cffbe59@amd.com>
Date:   Thu, 7 Jan 2021 09:32:37 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <X/Sfw15OWarseivB@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SA9PR13CA0157.namprd13.prod.outlook.com
 (2603:10b6:806:28::12) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SA9PR13CA0157.namprd13.prod.outlook.com (2603:10b6:806:28::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.4 via Frontend Transport; Thu, 7 Jan 2021 15:32:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c5307474-34df-44e2-480b-08d8b32177b9
X-MS-TrafficTypeDiagnostic: DM5PR12MB1355:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB135550E8C6B3C3D288B50D64ECAF0@DM5PR12MB1355.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YTYJ2Jrfkw66iRShzMS/ez+KrVadx3TO99rAp+SWzduYkGLCJuANAii3Dzs9xMpMj+7MgENptKH82pAkBRcO6gNqUalgUykE014BmcWSgRMwfZRGheGpZHsOnjTIdG2WIiGU0Vd5Pgxlc+lba1YZqKZz3TCsGRHW4QwBSX8DLOnh3JKmcFzirBz+btzrFwdynDSgo7EDAiMht9pEUK5FWvQAaCOGeNcNOp/7svKVKo8QDZV6aJJm6+aJaMOTJdp4bGV0XQtbM1r3X+ttXZPEjiMvtX8cVy5p4D6rNfGRGN8fUMYascga4UiIib5FbzWKcI/6fQKGUfd8a4sVnf72WS3fSMKCtR+ALQSCze3N19lGugoxzV/JJmYJFKL7itvfFE0xtdHt9c9uW8Oo4OqzEW0PqYZpYyDH2ed9Guz0JLtBYyx7GHF/h6BkkNgpyZ3Few3/Q4kaep9/p9G4zQ6QqC6dyGUOMMHBT2TJFf5XtqEhRKZ0wYibVafWNITc74FY5H4dwVFdXSSv10RdwypZ80/7R6cvYimkR96EdjUr/Fw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(396003)(346002)(39860400002)(376002)(36756003)(86362001)(6506007)(186003)(66476007)(7416002)(16526019)(53546011)(31696002)(31686004)(83380400001)(2906002)(26005)(66556008)(66946007)(110136005)(966005)(54906003)(52116002)(8936002)(478600001)(5660300002)(6636002)(6486002)(956004)(2616005)(45080400002)(4326008)(8676002)(316002)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TjJ4VXpvS1F2V21JdTJkc3MwYnBNRDhtOUxjZFVTREh1Nkx3dW1lOHk5MjYx?=
 =?utf-8?B?Y1JEVGJiOTkzbk8xM2lrM3o1bnU3OWhwd0xEZ1cwUnpUbEpBZDNvUDFjVEZs?=
 =?utf-8?B?RHJNVkFnT2REb1YxNHJCTVZBRkVTallFYkxpeWE3NWtDOEVNUGpSN3h1Zjh0?=
 =?utf-8?B?OHJ2Y2dheExKeUdWaFE4cXVyekZxNWxBVjRoN1hnRnJjeWMzeXl2U0g4MTZI?=
 =?utf-8?B?Ry9TcVlnSjVKdWF1emdCMjZPWUxWNDVVMnNZdkhBZDNDRm96QTJrcmc1SCsw?=
 =?utf-8?B?aXZyWjZpYkZtNFBpMjc1QytubEdkYUNVeW5Cb0ZGLzJHdURRYWprQUh5UnFK?=
 =?utf-8?B?VzhEQ3FWL2tGTEx4emE4SVhPL2U1S0cwR1gyb0s5bFNJaXhtQzNVSHlOSGZS?=
 =?utf-8?B?MFJ1blF3S0QzRzg0d3lScUhHWG5PeGpuY1hLK1YvbkdHUGFiUjhocXo5V3ZV?=
 =?utf-8?B?UjhGM3U1M0Mwdlo1RmQ5RW95YVJTWmZsOTE5QmFPd05RaXVQYnJocVI1Rkxp?=
 =?utf-8?B?bWl3YnU2QkgxMVNzeC9KZ1RzbTlER2RWNlo5RDR1RzJZV2JwMXJXVmF2U2Mr?=
 =?utf-8?B?OTJuRFl5eTlPcEhJcnRVNENYY0w2cjQzNFc2YXRyMDFPaTZNTlczczVVdlJh?=
 =?utf-8?B?VzZKNVlsWFlFWkhFdlY0RkdEQmZnb0h3dnA2eHdFbWdoY050T3dFdm1QaEdS?=
 =?utf-8?B?djdvU0pBb0NzVDZpSFkxS21VM3lZN0lwT3lKOHg1OGxPN3NHcWU4Wk9ISlZG?=
 =?utf-8?B?MjNFTVp5UVRteGp5Ti9hKzAyeWpVajFlV284aktaWkFvczQwcUhLRzRDTVRz?=
 =?utf-8?B?NE5pdXVKOXFNMkpaSFgvU09CYk13SThLbTZGRzNhOTEvditNY3QwOW5iZHRl?=
 =?utf-8?B?TnBmRWl6Q1l3QlZzU1FCTU5SQ0JkZzRtTys3a2ZYTmVxYzZFVHdTenR5L0FN?=
 =?utf-8?B?bzNLOXV3a2kzOWw1K3g3SEthODJpY3JBSWViQVUySWc1TUFKaGRXZjdneEYr?=
 =?utf-8?B?UTdwWjFFTGpZQ3hFWUQvVWpCdkw3L3o3TCsvUjE1TTNRT2pidEZKSW52SlpE?=
 =?utf-8?B?ZEtTU05KcG9WQXVLOGt4VmZrWWlIYXlxNENJMzd1cWNEcnN0TXhSakNHdk96?=
 =?utf-8?B?cDNST1VSQUphQVQwb0xZZHFpdTgrSnFHY1dUd3A4ZmNDbE9NcEFBVElsb3V0?=
 =?utf-8?B?Tm1oNTkySTIrWjRqUkFWMmY3REtLN0Q5d3Z1blFZNVc5bXMwalgzU0xPeWFj?=
 =?utf-8?B?QmRVeGtBK3NPNU93N0Y4ZmNEYWg2UHQreHo0bzl6RkFtZHUyVVZLTFRCMURq?=
 =?utf-8?Q?biRVJg4Xt7avhzbojMHLGSmrZk3PJP/V4B?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2021 15:32:39.5239
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: c5307474-34df-44e2-480b-08d8b32177b9
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: owAVNzkKsj1p8S1P3xCAEBhQFrCg9xV0MJ+NS+VV7khVka/h9B2qwAS9ExnY3uUP34QMSHHIAe2oAE7OL3OqZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1355
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/5/21 11:20 AM, Sean Christopherson wrote:
> On Tue, Jan 05, 2021, Michael Roth wrote:
>> @@ -3703,16 +3688,9 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu,
>>   	if (sev_es_guest(svm->vcpu.kvm)) {
>>   		__svm_sev_es_vcpu_run(svm->vmcb_pa);
>>   	} else {
>> -		__svm_vcpu_run(svm->vmcb_pa, (unsigned long *)&svm->vcpu.arch.regs);
>> -
>> -#ifdef CONFIG_X86_64
>> -		native_wrmsrl(MSR_GS_BASE, svm->host.gs_base);
>> -#else
>> -		loadsegment(fs, svm->host.fs);
>> -#ifndef CONFIG_X86_32_LAZY_GS
>> -		loadsegment(gs, svm->host.gs);
>> -#endif
>> -#endif
>> +		__svm_vcpu_run(svm->vmcb_pa, (unsigned long *)&svm->vcpu.arch.regs,
>> +			       page_to_phys(per_cpu(svm_data,
>> +						    vcpu->cpu)->save_area));
> 
> Does this need to use __sme_page_pa()?

Yes, it should now. The SEV-ES support added the SME encryption bit to the 
MSR_VM_HSAVE_PA MSR, so we need to be consistent in how the data is read 
and written.

Thanks,
Tom

> 
>>   	}
>>   
>>   	/*
> 
> ...
> 
>> diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
>> index 6feb8c08f45a..89f4e8e7bf0e 100644
>> --- a/arch/x86/kvm/svm/vmenter.S
>> +++ b/arch/x86/kvm/svm/vmenter.S
>> @@ -33,6 +33,7 @@
>>    * __svm_vcpu_run - Run a vCPU via a transition to SVM guest mode
>>    * @vmcb_pa:	unsigned long
>>    * @regs:	unsigned long * (to guest registers)
>> + * @hostsa_pa:	unsigned long
>>    */
>>   SYM_FUNC_START(__svm_vcpu_run)
>>   	push %_ASM_BP
>> @@ -47,6 +48,9 @@ SYM_FUNC_START(__svm_vcpu_run)
>>   #endif
>>   	push %_ASM_BX
>>   
>> +	/* Save @hostsa_pa */
>> +	push %_ASM_ARG3
>> +
>>   	/* Save @regs. */
>>   	push %_ASM_ARG2
>>   
>> @@ -154,6 +158,12 @@ SYM_FUNC_START(__svm_vcpu_run)
>>   	xor %r15d, %r15d
>>   #endif
>>   
>> +	/* "POP" @hostsa_pa to RAX. */
>> +	pop %_ASM_AX
>> +
>> +	/* Restore host user state and FS/GS base */
>> +	vmload %_ASM_AX
> 
> This VMLOAD needs the "handle fault on reboot" goo.  Seeing the code, I think
> I'd prefer to handle this in C code, especially if Paolo takes the svm_ops.h
> patch[*].  Actually, I think with that patch it'd make sense to move the
> existing VMSAVE+VMLOAD for the guest into svm.c, too.  And completely unrelated,
> the fault handling in svm/vmenter.S can be cleaned up a smidge to eliminate the
> JMPs.
> 
> Paolo, what do you think about me folding these patches into my series to do the
> above cleanups?  And maybe sending a pull request for the end result?  (I'd also
> like to add on a patch to use the user return MSR mechanism for MSR_TSC_AUX).
> 
> [*] https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flkml.kernel.org%2Fr%2F20201231002702.2223707-8-seanjc%40google.com&amp;data=04%7C01%7Cthomas.lendacky%40amd.com%7C5125acb3a3384ee75a5c08d8b19e2888%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637454640159484993%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=Q%2F%2B7kxE9pcV%2BelzHbeRpvs8wlQGQkirKUPg7fBP3QbU%3D&amp;reserved=0
> 
>> +
>>   	pop %_ASM_BX
>>   
>>   #ifdef CONFIG_X86_64
>> -- 
>> 2.25.1
>>
