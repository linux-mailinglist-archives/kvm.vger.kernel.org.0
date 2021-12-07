Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC1A46C025
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 17:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239347AbhLGQD4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 11:03:56 -0500
Received: from mail-co1nam11on2072.outbound.protection.outlook.com ([40.107.220.72]:19905
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238825AbhLGQD4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 11:03:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m/looH7RnAHWl2ByKCxRzIgHrKYFFqNrRn47DykvKAfMkLuygGInC0tN8Ic1ISKUl9M1xo8y9rehZxJVCSk/ZLxMTVUz1pj2GSrIHPSjyoJDE3g+UEOm3g10SM3Wg/hTVRxsY388L9GCB4RJr05rbE29Fq2wtBVaZQYvvFb5dMTT9UPvcgT6HVSgKPqW+7HBNt4mj5dtuDhKJaQQM8OCw+6rjOlrWAylXoFlYfGKZTQA5c83GD87rd81QDIi/fxbMGGJrm22YIXX6oPI3rLJ1gHacODCHZAcdsZseHO7hn+WEvOQNEloem41UQbznkCptydXCq2drLbEhTCvdU7TNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lqf/EFe4zGKgO+FNd52fSB2p7H/kRZ9vVShOgCOedoc=;
 b=oH3YevT87k3kkpBw7UpnrEOmi50hBUC+Z2UClO3qdAG+2JxJkPhPQyHkxrUY8PqxIukYCKVmK0pGhnsJisdotmbX3jxDQYDbfNxrc1jFTW0iPPptgM1xeMmOj82eVTfZ7RidsMN9ObgVtF/glb8anv7POBPVljBZV9ltjmecEaT820RQuBxiJeILJxsmWaEZtic6jOH2G4g0Lao6EDt99vG3WwDCCMo36W489r2qjN2E80IJ+/bPK4ZOPj7jKYRxv9K/tb9PKWiBcfwoOVDA/POR4O00EnmRI/kCf0OcVi53bvATk1XAmMN9G3hGSPQSSp6Ox0PkOKCjujOXnjl2Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lqf/EFe4zGKgO+FNd52fSB2p7H/kRZ9vVShOgCOedoc=;
 b=q+Cxrh6ofyHsUQFQbUf5axAR5hSsRJxtt8q/iiPBfhGYisCpSmkKV4nu0CwXm/4Xo3wlGjmqhBa3ojp8q0uvO3lJsBL830hkZeM0FlrsChT12zuQu7MxnP2oG1jAOQvw81XlYkaWR56+XHw6Dh6D+Ury+LwKCAwBs5YCKBPmWA8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM4PR12MB5087.namprd12.prod.outlook.com (2603:10b6:5:38a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.11; Tue, 7 Dec
 2021 16:00:24 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1ddd:71e4:5803:e44a]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1ddd:71e4:5803:e44a%3]) with mapi id 15.20.4734.028; Tue, 7 Dec 2021
 16:00:24 +0000
Subject: Re: [PATCH] KVM: x86: Always set kvm_run->if_flag
To:     Marc Orr <marcorr@google.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211207043100.3357474-1-marcorr@google.com>
 <c8889028-9c4e-cade-31b6-ea92a32e4f66@amd.com>
 <CAA03e5E7-ns7w9B9Tu7pSWzCo0Nh7Ba5jwQXcn_XYPf_reRq9Q@mail.gmail.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <5e69c0ca-389c-3ace-7559-edd901a0ab3c@amd.com>
Date:   Tue, 7 Dec 2021 10:00:20 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <CAA03e5E7-ns7w9B9Tu7pSWzCo0Nh7Ba5jwQXcn_XYPf_reRq9Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0312.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::17) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
Received: from [10.236.30.241] (165.204.77.1) by BL1PR13CA0312.namprd13.prod.outlook.com (2603:10b6:208:2c1::17) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Tue, 7 Dec 2021 16:00:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: be33c2eb-690c-4276-6fb3-08d9b99aad89
X-MS-TrafficTypeDiagnostic: DM4PR12MB5087:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB50871E8A95B43D61B74111DDEC6E9@DM4PR12MB5087.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 53EuXmSZFKxEquEKTdFYEkRCcEIv8/4+Dbz1OwFdoB8WYU938NTztM4mBOOe6uU0C9Onx0rWQDk7ZDX96cUh3dTVU7yNIIRl6PYgixZn5gQ571P3tT9eket93Ij6w4UTDi4Ga2oB8nHSLxLeCohRwiDysnEX3ZLa1ImFTnk2anfg6wzQ2p7FFQJoYDpMBTYpTxjw0oS+Ty2cct+z7JOJYCfPH8ShyiMPsYrnKWEecbYGbB6RP71dGI1GKI7FJmWP1MxDP0/PokBuRey7lbBNQ192vWkip/dLiUSMTOWEhr4HzFvLqtjXMlHZH1Z8zgfA1babm4eb/6NyZb6TfpoRFRFLtuZz83d/D8moMLBcNitgxhKc+HtcaaLD/uUHeo2tqkyvmDpPM68tYsbTg2adLERYsjYxSc96jPuctFyAU+SCtcuOB0D3rPOVpCUS1iE1b4ANd0K5hXxdG7ned/sFTPpFjHRNoP5gozbQJ6AzsYO2QthIbe5CgpBJ1UW4X1XGNeYz9FxYJXb8E8ctcAAEOh644P1iu1JVgtOZjhJ5pQI21eWtVQFwkenRoy1G/L1PgrXoiHpa4nB5gRw+21q6nhCpT+EiNBGejd/Cs8ApJZP6ZMaC9bNcqC/l3m+jk1xIxHQNTY80ZvukWufciz/LjpwgZxRnv8Pg3a3buImzeR42lx7TuovloM3iraYyNpkbQXRUHThZ0AZwwGdy7+czdilJ4AwSjInGofVBSaQ1XEU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(66946007)(31696002)(36756003)(66556008)(316002)(16576012)(6486002)(8676002)(8936002)(6916009)(31686004)(2906002)(7416002)(38100700002)(4326008)(508600001)(956004)(2616005)(53546011)(83380400001)(5660300002)(186003)(26005)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V3lTV1hQLzZyTkVMV0lXN2VxcVQ5T2VSeHJrQ2djVk1RSytyK1lBNjZuSVlG?=
 =?utf-8?B?c205VDVROWtaSXVuMktQVVMxWGdLbVV2V29pMUt5ek1iV0w0ZnZPdzVENG5P?=
 =?utf-8?B?cEhFN21yN2lieGVsOFBEblA4QkZZQmJneWprRkxrYUE1QTZhaUcycnhjQkRI?=
 =?utf-8?B?WUhIaWI3Zzh2RHl1SW02QlgzTUV5ajZXUkp3NkI4Nm5LZGdrd3FYeFhOektl?=
 =?utf-8?B?ZkZHQmVza2NNb1FhdnBnMEdYUVdWR1ZuYnpocjlwOS9DNXJzRW1la3BNZzFx?=
 =?utf-8?B?Q1pEUk5ZeUJ4b3pab1lLb2dDdHlVK0ZWb1FYSmpicENMM3pLUW1yd3dEVEFi?=
 =?utf-8?B?UnlqUXVZM3dhLzlhOTNCVktoV0FNeTRCaUxyMlExYnoxQnNnSi84a1dwbzlq?=
 =?utf-8?B?dEFSamZnbklDRGtoN0JyN0FmRkZkanRKejVzZldxelFjc0hXNkd2S21KMG9l?=
 =?utf-8?B?TTl5NVFQZGRqS3Fvak1YT3F3VmlRUEw5YmxHT1kvemJtd3RwU2N3WlV4Z2lD?=
 =?utf-8?B?b2FRWXZrMmNBdTZaVzVDblJ2RVZQR2hVelNDWkRIK0dFQjAvU2tBVlFvcENM?=
 =?utf-8?B?RWlaMzRTeFkvWlNzc2c0MXc4VkpkSTgyWWVQVjhSWlY5cFpQcVhBSnYxSU12?=
 =?utf-8?B?YlZlYlNEQ1g1NGZPcFZZcCtNV2w3ZDNkSUlwWCtDaWR3TWdwSDNhd2ZBMUx1?=
 =?utf-8?B?RjV3b1ZwYVNaQUNYbnNFYnRzbXR5WnNoQVQ5MzZDVHVwYzFXS1NNYXhmUFky?=
 =?utf-8?B?NC9ROGpBbGlqWkoyUEFSbGhOc3FFODI1cG9pVEN5MnpjSkpncWsvTWR4K29G?=
 =?utf-8?B?OWllb1ZpOU90Y0xkd21PVW9lcmMyVFl3dmFQYXY3dUdLdTk5TEhDM2tvMjFO?=
 =?utf-8?B?S1UrbFM3MC95UndRT3EzQnd6YXdpRURVNkxyMVE4SE9sZzNCbEdnUVE0K05y?=
 =?utf-8?B?MFdBK3dJNzJWVTY2SWVjUyswUzd0VzZDcnd5MmxXL2VqUGxFS3p5R3pvMGVj?=
 =?utf-8?B?TnVacGprc1dGOGpJTHdmT29xS1RwSjN6ME9IUExzMVZxb0NUdXFQREsraEJP?=
 =?utf-8?B?RDVxRnZjYXJTMVJLSjFVS1pWeldaUXU0OXBZc1EwUWJob29PbXUzMWZOUjB1?=
 =?utf-8?B?VVEyU29IQjhNSTZZSVZqR09ycU5UYVFIRllXejlxM2ZwMTRqRE85cS9Od2FJ?=
 =?utf-8?B?MGJ2WTV2QXh5MFhSODcwUkdVSTVZSTl5elNJcktXNk9UYlB1TEViWWhJRUtF?=
 =?utf-8?B?MnFlWGZlOTZNTDhoQktFV0lwVis2anFKT0pjMHN6Zm10ZkFFR20ySSszMXJ5?=
 =?utf-8?B?MUcyT1RrbUJTa1VML1FTOXVxN3l0Mm1kMXljakpoQUlUaG9mRjRGYVFkRlBH?=
 =?utf-8?B?dm0xbGhLZklPb0V6YTBLMnUxOEhZUTJPZGhzZThUZndQVEtxZ3gzbVk1Z2t6?=
 =?utf-8?B?RDVnanhkcUdLYUZCdStmRVlOUEtzTy94Zkx0L2dEUnduN0cvUm8wZlJLQU5V?=
 =?utf-8?B?RGdFTHN0dU04V00wYy9ERU1SdDhaYU16VndQUC9wcVVTV2F1c0svVm1rb1hQ?=
 =?utf-8?B?WEEwalBwMkluK1NNY3ZSRnhEeUhvM1B3VC9yMjFIVlNIYUpvRkhUOTBnc1dS?=
 =?utf-8?B?Qjl2YWZQS2xGcTVCaCs1M25pME1RRGFGK0NLb2trc01uSng2NUprTUNwYWZr?=
 =?utf-8?B?LzlpVlRqeHBzVEhPbjJENW4zYW56bXFGQWw2RFdvVWVGOFBla3pkbU5YdVJG?=
 =?utf-8?B?SHJDbk9pNVlvbVU2MXhwSDhuQVRkalI5ZlZoaTNxQ1V6ZWdYeXJheXE3QWxz?=
 =?utf-8?B?Q2FtNTlkVmVRbmpKdlBlWlBoOWoxTlJqSjFPeHFxY0c2eVhaVzBjOE5HcGZo?=
 =?utf-8?B?emg0dXN3bThXeWVOcUI0M0I0emdneUgzUmVUVUZEdHQrMDZmUnhmYkRuenhD?=
 =?utf-8?B?eEhTZjdtUlI1WHBmbHpBVk1MUFZMTS9udDNaQWJWUjh4V1RtNWZhTUpxOWNx?=
 =?utf-8?B?QkhzZksrWUdZMWdlSVZiYzNuYldTZUlFQjdCUVNJVHFia2IyTThTMXg0RTg0?=
 =?utf-8?B?TUtEN0IvOUlQS0h1c0ZRNUc1R2tSZkcrc0VvWFBFUHV6MkZNQWp1aWJXejRY?=
 =?utf-8?B?TVlJeWM4akVDcUl5VUVmdlFkRVpLdnlwaHVXcVJ3ZzRFNXpaU2h1ZGFONXlX?=
 =?utf-8?Q?IB8kiVOAd5CpNcvE3/4c65I=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be33c2eb-690c-4276-6fb3-08d9b99aad89
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 16:00:23.8487
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jA3m3C8ZTPvjTLd3LcquLX63Z7iQJ9VFZuNpcDTYKUN1siHRQsSsbARQCd6u8Y3l8R/OpUsDlaGZOwZSNJg9Rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5087
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/7/21 9:14 AM, Marc Orr wrote:
> On Tue, Dec 7, 2021 at 6:43 AM Tom Lendacky <thomas.lendacky@amd.com> wrote:
>>
>> On 12/6/21 10:31 PM, Marc Orr wrote:
>>> The kvm_run struct's if_flag is apart of the userspace/kernel API. The
>>> SEV-ES patches failed to set this flag because it's no longer needed by
>>> QEMU (according to the comment in the source code). However, other
>>> hypervisors may make use of this flag. Therefore, set the flag for
>>> guests with encrypted regiesters (i.e., with guest_state_protected set).
>>>
>>> Fixes: f1c6366e3043 ("KVM: SVM: Add required changes to support intercepts under SEV-ES")
>>> Signed-off-by: Marc Orr <marcorr@google.com>
>>> ---
>>>    arch/x86/include/asm/kvm-x86-ops.h | 1 +
>>>    arch/x86/include/asm/kvm_host.h    | 1 +
>>>    arch/x86/kvm/svm/svm.c             | 8 ++++++++
>>>    arch/x86/kvm/vmx/vmx.c             | 6 ++++++
>>>    arch/x86/kvm/x86.c                 | 9 +--------
>>>    5 files changed, 17 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
>>> index cefe1d81e2e8..9e50da3ed01a 100644
>>> --- a/arch/x86/include/asm/kvm-x86-ops.h
>>> +++ b/arch/x86/include/asm/kvm-x86-ops.h
>>> @@ -47,6 +47,7 @@ KVM_X86_OP(set_dr7)
>>>    KVM_X86_OP(cache_reg)
>>>    KVM_X86_OP(get_rflags)
>>>    KVM_X86_OP(set_rflags)
>>> +KVM_X86_OP(get_if_flag)
>>>    KVM_X86_OP(tlb_flush_all)
>>>    KVM_X86_OP(tlb_flush_current)
>>>    KVM_X86_OP_NULL(tlb_remote_flush)
>>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>>> index 860ed500580c..a7f868ff23e7 100644
>>> --- a/arch/x86/include/asm/kvm_host.h
>>> +++ b/arch/x86/include/asm/kvm_host.h
>>> @@ -1349,6 +1349,7 @@ struct kvm_x86_ops {
>>>        void (*cache_reg)(struct kvm_vcpu *vcpu, enum kvm_reg reg);
>>>        unsigned long (*get_rflags)(struct kvm_vcpu *vcpu);
>>>        void (*set_rflags)(struct kvm_vcpu *vcpu, unsigned long rflags);
>>> +     bool (*get_if_flag)(struct kvm_vcpu *vcpu);
>>>
>>>        void (*tlb_flush_all)(struct kvm_vcpu *vcpu);
>>>        void (*tlb_flush_current)(struct kvm_vcpu *vcpu);
>>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>>> index d0f68d11ec70..91608f8c0cde 100644
>>> --- a/arch/x86/kvm/svm/svm.c
>>> +++ b/arch/x86/kvm/svm/svm.c
>>> @@ -1585,6 +1585,13 @@ static void svm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
>>>        to_svm(vcpu)->vmcb->save.rflags = rflags;
>>>    }
>>>
>>> +static bool svm_get_if_flag(struct kvm_vcpu *vcpu)
>>> +{
>>> +     struct vmcb *vmcb = to_svm(vcpu)->vmcb;
>>> +
>>> +     return !!(vmcb->control.int_state & SVM_GUEST_INTERRUPT_MASK);
>>
>> I'm not sure if this is always valid to use for non SEV-ES guests. Maybe
>> the better thing would be:
>>
>>          return sev_es_guest(vcpu->kvm) ? vmcb->control.int_state & SVM_GUEST_INTERRUPT_MASK
>>                                         : kvm_get_rflags(vcpu) & X86_EFLAGS_IF;
>>
>> (Since this function returns a bool, I don't think you need the !!)
> 
> I had the same reservations when writing the patch. (Why fix what's
> not broken.) The reason I wrote the patch this way is based on what I
> read in APM vol2: Appendix B Layout of VMCB: "GUEST_INTERRUPT_MASK -
> Value of the RFLAGS.IF bit for the guest."

I just verified with the hardware team that this flag is indeed only set 
for a guest with protected state (SEV-ES / SEV-SNP). An update to the APM 
will be made.

Thanks,
Tom

> 
> Also, I had _thought_ that `svm_interrupt_allowed()` -- the
> AMD-specific function used to populate `ready_for_interrupt_injection`
> -- was relying on `GUEST_INTERRUPT_MASK`. But now I'm reading the code
> again, and I realized I was overly focused on the SEV-ES handling.
> That code is actually extracting the IF bit from the RFLAGS register
> in the same way you've proposed here.
> 
> Changing the patch as you've suggested SGTM. I can send out a v2. I'll
> wait a day or two to see if there are any other comments first. I
> guess the alternative would be to change `svm_interrupt_blocked()` to
> solely use the `SVM_GUEST_INTERRUPT_MASK`. If we were confident that
> it was sufficient, it would be a nice little cleanup. But regardless,
> I think we should keep the code introduced by this patch consistent
> with `svm_interrupt_blocked()`.
> 
> Also, noted on the `!!` not being needed when returning from a bool
> function. I'll keep this in mind in the future. Thanks!
> 
