Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1596E2D6B62
	for <lists+kvm@lfdr.de>; Fri, 11 Dec 2020 00:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732895AbgLJXAI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 18:00:08 -0500
Received: from mail-co1nam11on2042.outbound.protection.outlook.com ([40.107.220.42]:51393
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388643AbgLJW6x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 17:58:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aZKurXd+E6Lugk2dV5IOgLy/JVbGlgxjOmRgNx8MUMasOv9dZAsImEWfUulrGHDkNvrgVySCHHCtqMxWV+IH4Xi8qQmvttc+lnkOJcwx4UmEZQRW16oe0HexjK1vQOuZKWOJuzlXRClA+d0wTqZnAqrSe66nLOmezz1x8lXJUEH2r1lYTXxA8ESmq3ReEtSn4NBLP8dPHWyoS6pcZpb0grActabrVxjmU0LFLPKzWn3g1oDh3lgqVaPTOzrG/YoGoG4spLh1CHj0JlVxuHlB/PtxAmP721l7W4laYYuPMzWDnMGZsf2JixYto6sx0kcIz5RzT+5wnh/zaHVrnR0Xyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WYidpHP/aKNuFDfShpyPGQ0B7PG3um16aEgQC0lUWZI=;
 b=NUlQf15eZOL2HTlqyANyfvgjCl1LlKLJH6omN/ftcoXajuGoM7m9MhqRVfJQQheZj5jfy7bNmgwbuaql8D88qmNVoRBieGtzEmHbLKAsFwhq7E4k06WMjntbsv6oGo0EaeNqm+7bGLSc40Ylrrq9vB68LSXMWoeOLWa0+CFfTRv3l4ZsXb52GHAj1GfnFJifh3tYw8FI11N2aejc5Nwtp4Nls/uqTMxS0mu7284qnpKgKOiSUqM95SEDfPOubdEntim6H8J7NMt9XF/jDEqMAAfSjpc3rQdbOcjQ2l4zu2aAwhGKrghJ7qdS62IjbX+t1YZhIxXGsxSZwbyDCG0o3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WYidpHP/aKNuFDfShpyPGQ0B7PG3um16aEgQC0lUWZI=;
 b=Asvgoq28GWG5PtARTbS6+TMFn0QpZIezn05+ek/twiCzKAS3CUv3033vxV+bEeQBXzHgP99+hqagkq+hjbHfO8xUe/+Abm/Q1MfCLbOCxJhtRrBJFpBA/0g+mRThyYO3TbIMm9YjGyJCk4icsS9i45IbknKsGRCeaRv1P+F7jes=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2429.namprd12.prod.outlook.com (2603:10b6:802:26::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.13; Thu, 10 Dec
 2020 22:57:59 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::d877:baf6:9425:ece]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::d877:baf6:9425:ece%3]) with mapi id 15.20.3654.017; Thu, 10 Dec 2020
 22:57:59 +0000
Subject: Re: [PATCH 2/2] KVM: SVM: Add support for Virtual SPEC_CTRL
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        kvm list <kvm@vger.kernel.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        "kyung.min.park@intel.com" <kyung.min.park@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        "H . Peter Anvin" <hpa@zytor.com>,
        "mgross@linux.intel.com" <mgross@linux.intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Phillips, Kim" <kim.phillips@amd.com>,
        "Huang2, Wei" <Wei.Huang2@amd.com>
References: <160738054169.28590.5171339079028237631.stgit@bmoger-ubuntu>
 <160738067970.28590.1275116532320186155.stgit@bmoger-ubuntu>
 <CALMp9eRSvWemdiBygMJ18yP9T0UzL0nNbpD__bRis7M5LqOK+g@mail.gmail.com>
 <737ec565-ec4f-1d9e-a7f8-dfa7976e64e6@amd.com>
 <CALMp9eS2YSX_Tjaji3sZjWAKdS=orJVH1H6NbXMoi23ZFbcURQ@mail.gmail.com>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <de0b5d53-095a-1f85-1ebf-a22be30f7d3b@amd.com>
Date:   Thu, 10 Dec 2020 16:57:56 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <CALMp9eS2YSX_Tjaji3sZjWAKdS=orJVH1H6NbXMoi23ZFbcURQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM3PR12CA0102.namprd12.prod.outlook.com
 (2603:10b6:0:55::22) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.136] (165.204.77.1) by DM3PR12CA0102.namprd12.prod.outlook.com (2603:10b6:0:55::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 10 Dec 2020 22:57:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fdaad800-9789-45ef-63fe-08d89d5f0a42
X-MS-TrafficTypeDiagnostic: SN1PR12MB2429:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB242985A5046497BB9635846F95CB0@SN1PR12MB2429.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: arOgbXz7VIxRtlJbOV1VDqkG6BgnjEwClAj6RWAFh6a1XiJeZfQy0hvcPnifWl1HnoOtcsJf8ZYcSzJVpivIAu7/ArnEEseAzobRU0+TBniePCQ05dZx18g/h8b3TSflx+m97TvVmA4nUV4FOMHp5KpNrskVOaljliAVIhxZPDHOHASiwwp2JJpP2vdSqNg4bmdiUIzBJ9xslMjz1l2yp378oC711/Z4NV1/BDfwkCQ5yeiVRAjsuKpiAG6hCGkiIAQDXV7szeH7XgKGzvrqdSb7XR7ZjR/8MxOOYsOJZazE1sYeHxNI/UoYdVJ4GCmY3AfuPKxfkpth92KA/zPRMAfI5RjnOUvZmQ4iffLh2jVFXmFyw6jSrbCGEiBV9iw018QJ7CJs4+NI51fHdJUT9QH6GAOs1QKw+QOIf+WUWUfOFC+lyuA6KTKZ4QiAdCfp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(366004)(66476007)(4326008)(2906002)(66946007)(8676002)(508600001)(66556008)(86362001)(36756003)(6486002)(53546011)(16576012)(186003)(31696002)(5660300002)(31686004)(8936002)(26005)(52116002)(6916009)(956004)(44832011)(34490700003)(54906003)(7416002)(2616005)(16526019)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?S1hKT1h4dUYxVksvUFFsT1Rmd2M1NktCNWlSei90MkNteWVkM3hmMFlMUXM4?=
 =?utf-8?B?MlFCQ3VJT0VsMnpBdldMUVdYaHR3U2FFcy82MGhmbTVaZzRwaFgvQmJvOTMv?=
 =?utf-8?B?KyttTzJjZHpTMmluUVpXQllXMkN4NWFyekZrQ3JaRlIwbXpzR2hFeGFGUGhG?=
 =?utf-8?B?RU1LOThVZ08wZGJWL1lEWDVDM3RqTzFPUEQveHBjbWZDRmJOMFJFWXgvbit1?=
 =?utf-8?B?cnhuM0ZDTFNEblZxV0FPaFZrM3VjNTdLb2Q5V2lTQ2xMbDNSMEFLMHlualFQ?=
 =?utf-8?B?VzE1UUtVclhjYjRuN2dMUWNRSnhxOTllV1N4N1hLV0JGK0kvbDNRL1lDN25O?=
 =?utf-8?B?akFHUlBTd3czZUd0eDQ3RHozQkVnTzBNK2NBOUhQMmlVS1A4c0JaVmYrSUpI?=
 =?utf-8?B?amNMeTRHaG8yQUF6dXlPUUl0QzFkaUxQV1ZPanJNQzNqdXNOYlovOE1Qb25r?=
 =?utf-8?B?djRIeEUvTHZiL1ZKMnpVWGdPYUFYeXExV3BjQ01hc0FSTHQ0Qk1hZitJT1Bx?=
 =?utf-8?B?REd2emJ1c3hsTlNBd1REVktQNEkvN2t5bFFYUENabjFXOFRmcFRxemNRVEZG?=
 =?utf-8?B?K0JjUmVtREE3emkzdUZ5R2Rsc1ZTVThsOE0yUkdHWTdHNUFaaUNFMGVJVUtQ?=
 =?utf-8?B?SWFTelJVSDErYlJXV3EwKy9XdWlxY01rMnF2cTEwMUtnSzhJVGE3eE15LzlT?=
 =?utf-8?B?RnpOUUdaZGg5NWVGR3pmdGRhYVBCaUF2SWVGeG5jbE1PVkZsemVLcTJRT25J?=
 =?utf-8?B?N1pQd21HSDJmVjNQNCtOVzczQmtkWk9IbktxSVNlVjR1QU90NTUwblRUaFhU?=
 =?utf-8?B?MGJqNjk4OTBIYkI5RjNwNnBPaHkzaDNYSkROc2MyelNOMDVOSXBjM1NrUUk3?=
 =?utf-8?B?L2gvRUxSNXpDeHVSVnluRExzNDBTTGhBZ1RZZC91UU1mR0EraklFdThvbGFJ?=
 =?utf-8?B?WENNdjRFM3E4VWVWVEJiVkNvWUJ1ZnRiUjJqQ3cwOVpRYy9hYm9VWU9KdGRl?=
 =?utf-8?B?QjNacjFub0lpeWE4TVlpOVc1YlNmK2JrM0FhaG0yT3FuS0M2Zi9Ed3IxckUy?=
 =?utf-8?B?UVgzbmJ2ck1PQ3hpV1lrcld0WGlncnZKSEFrd0w2V1pTbjI1MndHSDQwSHE0?=
 =?utf-8?B?RUs3TjBvS3pYY0p4eEF6dDIvRmpZQTFtMDB5Yy83K2VxZ3VTVlZOK2tIVzhR?=
 =?utf-8?B?Qkh2dHVMOU5NMHdSSVFSSityalZ3VGNCOGl4bFlUNVoxVG1rYWZtbGsxTFZ6?=
 =?utf-8?B?d0tKdWJ3RDEwbWRLT3M3QUlmc0pSWnhtcVhtYWlqSVVjbUJuNEIza0RzQ0tE?=
 =?utf-8?Q?eLUvKJQJEsBS7w/vG8DFs0Pv/tmiQ9Prwa?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2020 22:57:59.1382
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: fdaad800-9789-45ef-63fe-08d89d5f0a42
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KOJvY3maoN4m48MZn7MlygeU1g5Hb1dhdlwKkQIC3YcxJH07I5iOxWux5jI6f4hT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2429
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/10/20 3:36 PM, Jim Mattson wrote:
> On Thu, Dec 10, 2020 at 1:26 PM Babu Moger <babu.moger@amd.com> wrote:
>>
>> Hi Jim,
>>
>>> -----Original Message-----
>>> From: Jim Mattson <jmattson@google.com>
>>> Sent: Monday, December 7, 2020 5:06 PM
>>> To: Moger, Babu <Babu.Moger@amd.com>
>>> Cc: Paolo Bonzini <pbonzini@redhat.com>; Thomas Gleixner
>>> <tglx@linutronix.de>; Ingo Molnar <mingo@redhat.com>; Borislav Petkov
>>> <bp@alien8.de>; Yu, Fenghua <fenghua.yu@intel.com>; Tony Luck
>>> <tony.luck@intel.com>; Wanpeng Li <wanpengli@tencent.com>; kvm list
>>> <kvm@vger.kernel.org>; Lendacky, Thomas <Thomas.Lendacky@amd.com>;
>>> Peter Zijlstra <peterz@infradead.org>; Sean Christopherson
>>> <seanjc@google.com>; Joerg Roedel <joro@8bytes.org>; the arch/x86
>>> maintainers <x86@kernel.org>; kyung.min.park@intel.com; LKML <linux-
>>> kernel@vger.kernel.org>; Krish Sadhukhan <krish.sadhukhan@oracle.com>; H .
>>> Peter Anvin <hpa@zytor.com>; mgross@linux.intel.com; Vitaly Kuznetsov
>>> <vkuznets@redhat.com>; Phillips, Kim <kim.phillips@amd.com>; Huang2, Wei
>>> <Wei.Huang2@amd.com>
>>> Subject: Re: [PATCH 2/2] KVM: SVM: Add support for Virtual SPEC_CTRL
>>>
>>> On Mon, Dec 7, 2020 at 2:38 PM Babu Moger <babu.moger@amd.com> wrote:
>>>>
>>>> Newer AMD processors have a feature to virtualize the use of the
>>>> SPEC_CTRL MSR. When supported, the SPEC_CTRL MSR is automatically
>>>> virtualized and no longer requires hypervisor intervention.
>>>>
>>>> This feature is detected via CPUID function 0x8000000A_EDX[20]:
>>>> GuestSpecCtrl.
>>>>
>>>> Hypervisors are not required to enable this feature since it is
>>>> automatically enabled on processors that support it.
>>>>
>>>> When this feature is enabled, the hypervisor no longer has to
>>>> intercept the usage of the SPEC_CTRL MSR and no longer is required to
>>>> save and restore the guest SPEC_CTRL setting when switching
>>>> hypervisor/guest modes.  The effective SPEC_CTRL setting is the guest
>>>> SPEC_CTRL setting or'ed with the hypervisor SPEC_CTRL setting. This
>>>> allows the hypervisor to ensure a minimum SPEC_CTRL if desired.
>>>>
>>>> This support also fixes an issue where a guest may sometimes see an
>>>> inconsistent value for the SPEC_CTRL MSR on processors that support
>>>> this feature. With the current SPEC_CTRL support, the first write to
>>>> SPEC_CTRL is intercepted and the virtualized version of the SPEC_CTRL
>>>> MSR is not updated. When the guest reads back the SPEC_CTRL MSR, it
>>>> will be 0x0, instead of the actual expected value. There isn’t a
>>>> security concern here, because the host SPEC_CTRL value is or’ed with
>>>> the Guest SPEC_CTRL value to generate the effective SPEC_CTRL value.
>>>> KVM writes with the guest's virtualized SPEC_CTRL value to SPEC_CTRL
>>>> MSR just before the VMRUN, so it will always have the actual value
>>>> even though it doesn’t appear that way in the guest. The guest will
>>>> only see the proper value for the SPEC_CTRL register if the guest was
>>>> to write to the SPEC_CTRL register again. With Virtual SPEC_CTRL
>>>> support, the MSR interception of SPEC_CTRL is disabled during
>>>> vmcb_init, so this will no longer be an issue.
>>>>
>>>> Signed-off-by: Babu Moger <babu.moger@amd.com>
>>>> ---
>>>
>>> Shouldn't there be some code to initialize a new "guest SPEC_CTRL"
>>> value in the VMCB, both at vCPU creation, and at virtual processor reset?
>>
>> Yes, I think so. I will check on this.
>>
>>>
>>>>  arch/x86/kvm/svm/svm.c |   17 ++++++++++++++---
>>>>  1 file changed, 14 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c index
>>>> 79b3a564f1c9..3d73ec0cdb87 100644
>>>> --- a/arch/x86/kvm/svm/svm.c
>>>> +++ b/arch/x86/kvm/svm/svm.c
>>>> @@ -1230,6 +1230,14 @@ static void init_vmcb(struct vcpu_svm *svm)
>>>>
>>>>         svm_check_invpcid(svm);
>>>>
>>>> +       /*
>>>> +        * If the host supports V_SPEC_CTRL then disable the interception
>>>> +        * of MSR_IA32_SPEC_CTRL.
>>>> +        */
>>>> +       if (boot_cpu_has(X86_FEATURE_V_SPEC_CTRL))
>>>> +               set_msr_interception(&svm->vcpu, svm->msrpm,
>>> MSR_IA32_SPEC_CTRL,
>>>> +                                    1, 1);
>>>> +
>>>>         if (kvm_vcpu_apicv_active(&svm->vcpu))
>>>>                 avic_init_vmcb(svm);
>>>>
>>>> @@ -3590,7 +3598,8 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct
>>> kvm_vcpu *vcpu)
>>>>          * is no need to worry about the conditional branch over the wrmsr
>>>>          * being speculatively taken.
>>>>          */
>>>> -       x86_spec_ctrl_set_guest(svm->spec_ctrl, svm->virt_spec_ctrl);
>>>> +       if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
>>>> +               x86_spec_ctrl_set_guest(svm->spec_ctrl,
>>>> + svm->virt_spec_ctrl);
>>>
>>> Is this correct for the nested case? Presumably, there is now a "guest
>>> SPEC_CTRL" value somewhere in the VMCB. If L1 does not intercept this MSR,
>>> then we need to transfer the "guest SPEC_CTRL" value from the
>>> vmcb01 to the vmcb02, don't we?
>>
>> Here is the text from to be published documentation.
>> "When in host mode, the host SPEC_CTRL value is in effect and writes
>> update only the host version of SPEC_CTRL. On a VMRUN, the processor loads
>> the guest version of SPEC_CTRL from the VMCB. For non- SNP enabled guests,
>> processor behavior is controlled by the logical OR of the two registers.
>> When the guest writes SPEC_CTRL, only the guest version is updated. On a
>> VMEXIT, the guest version is saved into the VMCB and the processor returns
>> to only using the host SPEC_CTRL for speculation control. The guest
>> SPEC_CTRL is located at offset 0x2E0 in the VMCB."  This offset is into
>> the save area of the VMCB (i.e. 0x400 + 0x2E0).
>>
>> The feature X86_FEATURE_V_SPEC_CTRL will not be advertised to guests.
>> So, the guest will use the same mechanism as today where it will save and
>> restore the value into/from svm->spec_ctrl. If the value saved in the VMSA
>> is left untouched, both an L1 and L2 guest will get the proper value.
>> Thing that matters is the initial setup of vmcb01 and vmcb02 when this
>> feature is available in host(bare metal). I am going to investigate that
>> part. Do you still think I am missing something here?
> 
> It doesn't matter whether X86_FEATURE_V_SPEC_CTRL is advertised to L1
> or not. If L1 doesn't virtualize MSR_SPEC_CTRL for L2, then L1 and L2
> share the same value for that MSR. With this change, the current value
> in vmcb01 is only in vmcb01, and doesn't get propagated anywhere else.
> Hence, if L1 changes the value of MSR_SPEC_CTRL, that change is not
> visible to L2.
> 
> Thinking about what Sean said about live migration, I think the
> correct solution here is that the authoritative value for this MSR
> should continue to live in svm->spec_ctrl. When the CPU supports
> X86_FEATURE_V_SPEC_CTRL, we should just transfer the value into the
> VMCB prior to VMRUN and out of the VMCB after #VMEXIT.

Ok. Got it. I will try this approach. Thanks for the suggestion.

> 
>>
>>>
>>>>         svm_vcpu_enter_exit(vcpu, svm);
>>>>
>>>> @@ -3609,12 +3618,14 @@ static __no_kcsan fastpath_t
>>> svm_vcpu_run(struct kvm_vcpu *vcpu)
>>>>          * If the L02 MSR bitmap does not intercept the MSR, then we need to
>>>>          * save it.
>>>>          */
>>>> -       if (unlikely(!msr_write_intercepted(vcpu, MSR_IA32_SPEC_CTRL)))
>>>> +       if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL) &&
>>>> +           unlikely(!msr_write_intercepted(vcpu,
>>>> + MSR_IA32_SPEC_CTRL)))
>>>>                 svm->spec_ctrl = native_read_msr(MSR_IA32_SPEC_CTRL);
>>>
>>> Is this correct for the nested case? If L1 does not intercept this MSR, then it
>>> might have changed while L2 is running. Presumably, the hardware has stored
>>> the new value somewhere in the vmcb02 at #VMEXIT, but now we need to move
>>> that value into the vmcb01, don't we?
>>>
>>>>         reload_tss(vcpu);
>>>>
>>>> -       x86_spec_ctrl_restore_host(svm->spec_ctrl, svm->virt_spec_ctrl);
>>>> +       if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
>>>> +               x86_spec_ctrl_restore_host(svm->spec_ctrl,
>>>> + svm->virt_spec_ctrl);
>>>>
>>>>         vcpu->arch.cr2 = svm->vmcb->save.cr2;
>>>>         vcpu->arch.regs[VCPU_REGS_RAX] = svm->vmcb->save.rax;
>>>>
>>>
>>> It would be great if you could add some tests to kvm-unit-tests.
>>
>> Yes. I will check on this part.
>>
>> Thanks
>> Babu
