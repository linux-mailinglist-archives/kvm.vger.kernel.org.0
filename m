Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 770D91F7E7B
	for <lists+kvm@lfdr.de>; Fri, 12 Jun 2020 23:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726319AbgFLVry (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jun 2020 17:47:54 -0400
Received: from mail-bn7nam10on2056.outbound.protection.outlook.com ([40.107.92.56]:6044
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726302AbgFLVry (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jun 2020 17:47:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jRmyRFzvzAhFGM3JfdRDanmwyY07ROrXdRiPOreLqEd8DYz4YZshCLglXckBVsg55VXfiA8O30D4kPhqnmwwkUbTAR0iTPwxrV3TEj2dGxsDP1DZZI5vzcqnV2fViBMr3aJzYL13I35Y+m6j3VEZa8w8FWfu+7vT5mo9J/OeSCih+V8WEWvcOamgWPXbvKib27H9tEpbmNz1vMXMPv6+eUPLMoA8fDfTILXG1FZO2f1WGgAVy5GLFHgh56uCUL5pbBFuh+nCtjQVc5Ed8u/rBkSud/732fuVxkskQkFNOskHncjWhLELakHHjcTA63aZaQrqOzRTpejYZFnn3tI1Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aXf8puD4Y4xYQOec5F1Rp85j+myLquCU3JWoB1fl++s=;
 b=hnTMhVCWoWjBzYXfY0VjqkIWeK6uTQwVbINx8oRebHKHrFSxUXzrm6ijyOtf7MQs4tved2sPHTzCv5P9KbNzLbo6t8eBQyYYO2BeKVxitO1pDW5Bu491PIMuytRLCEs430K2xFLlYweOEokESQ7Q+qV3IVzFQyMSOKdfuFwCJnoZYoTd6GLIaaFBLlYYlmrzdtsgMV+HbWCmjfVOhPVQpjJt4Do4h/J54DfyfU69tHMSNfyeVpsKIH2QQBtxneeMIMTZ9KpJhgLTJ/Ar0wNxEsPhjJKIZf8xJI5evyt0f6zpig76/lYt7VnC1Im+ZXSnDnO8ZHLetmnZ+K5j7l87EQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aXf8puD4Y4xYQOec5F1Rp85j+myLquCU3JWoB1fl++s=;
 b=U2tbyQGNgWzlyYohS14xC2vHrURtQWCvCh7qpwFlQ7q9LSgijfSfAmrZkpS64lF9mwFACXqczenc887nSy7VD2A4uAthHEOT0426CsEWQbteZEi3l6pyan6QkZA8WU+O6+tlqK6hS5/ogPzGQgKNw4RweorTpC2fjzroaMII7aI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2384.namprd12.prod.outlook.com (2603:10b6:802:25::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.23; Fri, 12 Jun
 2020 21:47:49 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::2102:cc6b:b2db:4c2]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::2102:cc6b:b2db:4c2%3]) with mapi id 15.20.3088.021; Fri, 12 Jun 2020
 21:47:49 +0000
Subject: Re: [PATCH 3/3] KVM:SVM: Enable INVPCID feature on AMD
To:     Jim Mattson <jmattson@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>, Joerg Roedel <joro@8bytes.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>
References: <159191202523.31436.11959784252237488867.stgit@bmoger-ubuntu>
 <159191213022.31436.11150808867377936241.stgit@bmoger-ubuntu>
 <CALMp9eSC-wwP50gtprpakKjPYeZ5LdDSFS6i__csVCJwUKmqjA@mail.gmail.com>
 <d0b09992-eb87-651a-3b97-0787e07cc46d@amd.com>
 <CALMp9eRZQXgJvt3MGreq47ApM5ObTU7YFQV_GcY5N+jozGK1Uw@mail.gmail.com>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <d0c38022-2d82-aacc-4829-02c557edddc0@amd.com>
Date:   Fri, 12 Jun 2020 16:47:46 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <CALMp9eRZQXgJvt3MGreq47ApM5ObTU7YFQV_GcY5N+jozGK1Uw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM3PR12CA0120.namprd12.prod.outlook.com
 (2603:10b6:0:51::16) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.79] (165.204.77.1) by DM3PR12CA0120.namprd12.prod.outlook.com (2603:10b6:0:51::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.18 via Frontend Transport; Fri, 12 Jun 2020 21:47:48 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 18ed1d97-728b-46ac-c201-08d80f1a3ffe
X-MS-TrafficTypeDiagnostic: SN1PR12MB2384:
X-Microsoft-Antispam-PRVS: <SN1PR12MB238435E745233EC9D6721B0195810@SN1PR12MB2384.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 0432A04947
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dbpZoNc20TPLOI637qVojy1RhoozeMrB5T/620sUz40CtctatLxeDsEQCT5jQtA/K1LcQPBIRmlga1hJRhA7TBL8TyBQhWr4GU/X+ppIclN5ZYcmVvsorEkrRJqnnyKDRwDFnhqeUCbQgutK/q4P89Ll3Ubj3gCdQOEHEszkpf55YQQI9W1UQYB8iodwyF/J3mVT5ZoVMY2FrmQdWo2/U9IPxhRO4+cSBaCcTIZkikzftPBKRhGYnjC/K3SFkJE8xPUsFaJYWklp88hxYfhS7WEPb6r3ssoIhGEpg83xnpZZNNw6+/mFY/KZXNApMs/pLS1xahTbIVuxP20h/spUjv3paXfMnoURNcEDdnW4bSKE3fNEtIQ5TMogs46N8Q/350L7mpkedSEmcBPOZvOW32s+Jd92bF643CATcqvhdwT0Dy67lrQh8jf2TdvWXVtL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(376002)(346002)(366004)(39860400002)(396003)(86362001)(54906003)(2616005)(6486002)(956004)(83080400001)(45080400002)(478600001)(316002)(6916009)(966005)(7416002)(44832011)(83380400001)(31696002)(16576012)(16526019)(66476007)(2906002)(66946007)(66556008)(53546011)(8676002)(4326008)(26005)(8936002)(52116002)(5660300002)(186003)(36756003)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: a/2EGdRWRnJWhc/+BCDL0nm9QhFyc81gfUGc1TnlQzXYL71x9np+LTuQSgDXjHnSsOLDXFey0jYL5XNIYuaEieHuU5muKrD5qQRnQbWffnViFOhigih96MnYPmLRhlOPPw6WE9EFxcWuep738c3WnMIpkmN0AkHbl+0ZB+PZyTaUFo8fRujR2qhtj4bYzSvDcv/QOmJ/Hw2SgjW/ceVVoVX4pBvRwHfNiwozO4GBvBFmhOcG7Sw9rkchC3X9/Co+IddbHE57wkJ5Hgq7pcstuA0G2gGvogur2WB1OCxwXx9zZqCbwDpZx5UZg+ewdOl8jfmMzRvVgmDnHfOZuv57jV5e3nfc9ol3GZESlT4TxLzSQxu8QCElO1wxStqxzukzt6uT9FeMypEBvv9CSgbLtk7UjWTb9fLwB9r/Kx5nm3TGWB2QeByuSUBqk8oGEshDJiYIsmzkLc7scICVMFgjpaf91zUzMzHKdqvv0jbx2FU=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18ed1d97-728b-46ac-c201-08d80f1a3ffe
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2020 21:47:49.2260
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z5iSt2C3zWsDtxHFGON6d+jxkmKPxRBc8cWk1czdwpiPiyUYbCY7OpO/KZqtWcsW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2384
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/12/20 3:10 PM, Jim Mattson wrote:
> On Fri, Jun 12, 2020 at 12:35 PM Babu Moger <babu.moger@amd.com> wrote:
>>
>>
>>
>>> -----Original Message-----
>>> From: Jim Mattson <jmattson@google.com>
>>> Sent: Thursday, June 11, 2020 6:51 PM
>>> To: Moger, Babu <Babu.Moger@amd.com>
>>> Cc: Wanpeng Li <wanpengli@tencent.com>; Joerg Roedel <joro@8bytes.org>;
>>> the arch/x86 maintainers <x86@kernel.org>; Sean Christopherson
>>> <sean.j.christopherson@intel.com>; Ingo Molnar <mingo@redhat.com>;
>>> Borislav Petkov <bp@alien8.de>; H . Peter Anvin <hpa@zytor.com>; Paolo
>>> Bonzini <pbonzini@redhat.com>; Vitaly Kuznetsov <vkuznets@redhat.com>;
>>> Thomas Gleixner <tglx@linutronix.de>; LKML <linux-kernel@vger.kernel.org>;
>>> kvm list <kvm@vger.kernel.org>
>>> Subject: Re: [PATCH 3/3] KVM:SVM: Enable INVPCID feature on AMD
>>>
>>> On Thu, Jun 11, 2020 at 2:48 PM Babu Moger <babu.moger@amd.com> wrote:
>>>>
>>>> The following intercept is added for INVPCID instruction:
>>>> Code    Name            Cause
>>>> A2h     VMEXIT_INVPCID  INVPCID instruction
>>>>
>>>> The following bit is added to the VMCB layout control area
>>>> to control intercept of INVPCID:
>>>> Byte Offset     Bit(s)    Function
>>>> 14h             2         intercept INVPCID
>>>>
>>>> For the guests with nested page table (NPT) support, the INVPCID
>>>> feature works as running it natively. KVM does not need to do any
>>>> special handling in this case.
>>>>
>>>> Interceptions are required in the following cases.
>>>> 1. If the guest tries to disable the feature when the underlying
>>>> hardware supports it. In this case hypervisor needs to report #UD.
>>>
>>> Per the AMD documentation, attempts to use INVPCID at CPL>0 will
>>> result in a #GP, regardless of the intercept bit. If the guest CPUID
>>> doesn't enumerate the feature, shouldn't the instruction raise #UD
>>> regardless of CPL? This seems to imply that we should intercept #GP
>>> and decode the instruction to see if we should synthesize #UD instead.
>>
>> Purpose here is to report UD when the guest CPUID doesn't enumerate the
>> INVPCID feature When Bare-metal supports it. It seems to work fine for
>> that purpose. You are right. The #GP for CPL>0 takes precedence over
>> interception. No. I am not planning to intercept GP.
> 
> WIthout intercepting #GP, you fail to achieve your stated purpose.

I think I have misunderstood this part. I was not inteding to change the
#GP behaviour. I will remove this part. My intension of these series is to
handle invpcid in shadow page mode. I have verified that part. Hope I did
not miss anything else.

> 
>> I will change the text. How about this?
>>
>> Interceptions are required in the following cases.
>> 1. If the guest CPUID doesn't enumerate the INVPCID feature when the
>> underlying hardware supports it,  hypervisor needs to report UD. However,
>> #GP for CPL>0 takes precedence over interception.
> 
> This text is not internally consistent. In one sentence, you say that
> "hypervisor needs to report #UD." In the next sentence, you are
> essentially saying that the hypervisor doesn't need to report #UD.
> Which is it?
> 
>>>> 2. When the guest is running with shadow page table enabled, in
>>>> this case the hypervisor needs to handle the tlbflush based on the
>>>> type of invpcid instruction type.
>>>>
>>>> AMD documentation for INVPCID feature is available at "AMD64
>>>> Architecture Programmer’s Manual Volume 2: System Programming,
>>>> Pub. 24593 Rev. 3.34(or later)"
>>>>
>>>> The documentation can be obtained at the links below:
>>>> Link:
>>> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fwww.a
>>> md.com%2Fsystem%2Ffiles%2FTechDocs%2F24593.pdf&amp;data=02%7C01%7
>>> Cbabu.moger%40amd.com%7C36861b25f6d143e3b38e08d80e624472%7C3dd8
>>> 961fe4884e608e11a82d994e183d%7C0%7C0%7C637275163374103811&amp;s
>>> data=E%2Fdb6T%2BdO4nrtUoqhKidF6XyorsWrphj6O4WwNZpmYA%3D&amp;res
>>> erved=0
>>>> Link:
>>> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fbugzilla.
>>> kernel.org%2Fshow_bug.cgi%3Fid%3D206537&amp;data=02%7C01%7Cbabu.m
>>> oger%40amd.com%7C36861b25f6d143e3b38e08d80e624472%7C3dd8961fe488
>>> 4e608e11a82d994e183d%7C0%7C0%7C637275163374103811&amp;sdata=b81
>>> 9W%2FhKS93%2BAp3QvcsR0BwTQpUVUFMbIaNaisgWHRY%3D&amp;reserved=
>>> 0
>>>>
>>>> Signed-off-by: Babu Moger <babu.moger@amd.com>
>>>> ---
>>>>  arch/x86/include/asm/svm.h      |    4 ++++
>>>>  arch/x86/include/uapi/asm/svm.h |    2 ++
>>>>  arch/x86/kvm/svm/svm.c          |   42
>>> +++++++++++++++++++++++++++++++++++++++
>>>>  3 files changed, 48 insertions(+)
>>>>
>>>> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
>>>> index 62649fba8908..6488094f67fa 100644
>>>> --- a/arch/x86/include/asm/svm.h
>>>> +++ b/arch/x86/include/asm/svm.h
>>>> @@ -55,6 +55,10 @@ enum {
>>>>         INTERCEPT_RDPRU,
>>>>  };
>>>>
>>>> +/* Extended Intercept bits */
>>>> +enum {
>>>> +       INTERCEPT_INVPCID = 2,
>>>> +};
>>>>
>>>>  struct __attribute__ ((__packed__)) vmcb_control_area {
>>>>         u32 intercept_cr;
>>>> diff --git a/arch/x86/include/uapi/asm/svm.h
>>> b/arch/x86/include/uapi/asm/svm.h
>>>> index 2e8a30f06c74..522d42dfc28c 100644
>>>> --- a/arch/x86/include/uapi/asm/svm.h
>>>> +++ b/arch/x86/include/uapi/asm/svm.h
>>>> @@ -76,6 +76,7 @@
>>>>  #define SVM_EXIT_MWAIT_COND    0x08c
>>>>  #define SVM_EXIT_XSETBV        0x08d
>>>>  #define SVM_EXIT_RDPRU         0x08e
>>>> +#define SVM_EXIT_INVPCID       0x0a2
>>>>  #define SVM_EXIT_NPF           0x400
>>>>  #define SVM_EXIT_AVIC_INCOMPLETE_IPI           0x401
>>>>  #define SVM_EXIT_AVIC_UNACCELERATED_ACCESS     0x402
>>>> @@ -171,6 +172,7 @@
>>>>         { SVM_EXIT_MONITOR,     "monitor" }, \
>>>>         { SVM_EXIT_MWAIT,       "mwait" }, \
>>>>         { SVM_EXIT_XSETBV,      "xsetbv" }, \
>>>> +       { SVM_EXIT_INVPCID,     "invpcid" }, \
>>>>         { SVM_EXIT_NPF,         "npf" }, \
>>>>         { SVM_EXIT_AVIC_INCOMPLETE_IPI,         "avic_incomplete_ipi" }, \
>>>>         { SVM_EXIT_AVIC_UNACCELERATED_ACCESS,
>>> "avic_unaccelerated_access" }, \
>>>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>>>> index 285e5e1ff518..82d974338f68 100644
>>>> --- a/arch/x86/kvm/svm/svm.c
>>>> +++ b/arch/x86/kvm/svm/svm.c
>>>> @@ -813,6 +813,11 @@ static __init void svm_set_cpu_caps(void)
>>>>         if (boot_cpu_has(X86_FEATURE_LS_CFG_SSBD) ||
>>>>             boot_cpu_has(X86_FEATURE_AMD_SSBD))
>>>>                 kvm_cpu_cap_set(X86_FEATURE_VIRT_SSBD);
>>>> +
>>>> +       /* Enable INVPCID if both PCID and INVPCID enabled */
>>>> +       if (boot_cpu_has(X86_FEATURE_PCID) &&
>>>> +           boot_cpu_has(X86_FEATURE_INVPCID))
>>>> +               kvm_cpu_cap_set(X86_FEATURE_INVPCID);
>>>>  }
>>>>
>>>>  static __init int svm_hardware_setup(void)
>>>> @@ -1099,6 +1104,17 @@ static void init_vmcb(struct vcpu_svm *svm)
>>>>                 clr_intercept(svm, INTERCEPT_PAUSE);
>>>>         }
>>>>
>>>> +       /*
>>>> +        * Intercept INVPCID instruction only if shadow page table is
>>>> +        * enabled. Interception is not required with nested page table.
>>>> +        */
>>>> +       if (boot_cpu_has(X86_FEATURE_INVPCID)) {
>>>> +               if (!npt_enabled)
>>>> +                       set_extended_intercept(svm, INTERCEPT_INVPCID);
>>>> +               else
>>>> +                       clr_extended_intercept(svm, INTERCEPT_INVPCID);
>>>> +       }
>>>> +
>>>>         if (kvm_vcpu_apicv_active(&svm->vcpu))
>>>>                 avic_init_vmcb(svm);
>>>>
>>>> @@ -2715,6 +2731,23 @@ static int mwait_interception(struct vcpu_svm
>>> *svm)
>>>>         return nop_interception(svm);
>>>>  }
>>>>
>>>> +static int invpcid_interception(struct vcpu_svm *svm)
>>>> +{
>>>> +       struct kvm_vcpu *vcpu = &svm->vcpu;
>>>> +       unsigned long type;
>>>> +       gva_t gva;
>>>> +
>>>> +       /*
>>>> +        * For an INVPCID intercept:
>>>> +        * EXITINFO1 provides the linear address of the memory operand.
>>>> +        * EXITINFO2 provides the contents of the register operand.
>>>> +        */
>>>> +       type = svm->vmcb->control.exit_info_2;
>>>> +       gva = svm->vmcb->control.exit_info_1;
>>>> +
>>>> +       return kvm_handle_invpcid_types(vcpu,  gva, type);
>>>> +}
>>>> +
>>>>  static int (*const svm_exit_handlers[])(struct vcpu_svm *svm) = {
>>>>         [SVM_EXIT_READ_CR0]                     = cr_interception,
>>>>         [SVM_EXIT_READ_CR3]                     = cr_interception,
>>>> @@ -2777,6 +2810,7 @@ static int (*const svm_exit_handlers[])(struct
>>> vcpu_svm *svm) = {
>>>>         [SVM_EXIT_MWAIT]                        = mwait_interception,
>>>>         [SVM_EXIT_XSETBV]                       = xsetbv_interception,
>>>>         [SVM_EXIT_RDPRU]                        = rdpru_interception,
>>>> +       [SVM_EXIT_INVPCID]                      = invpcid_interception,
>>>>         [SVM_EXIT_NPF]                          = npf_interception,
>>>>         [SVM_EXIT_RSM]                          = rsm_interception,
>>>>         [SVM_EXIT_AVIC_INCOMPLETE_IPI]          =
>>> avic_incomplete_ipi_interception,
>>>> @@ -3562,6 +3596,14 @@ static void svm_cpuid_update(struct kvm_vcpu
>>> *vcpu)
>>>>         svm->nrips_enabled = kvm_cpu_cap_has(X86_FEATURE_NRIPS) &&
>>>>                              guest_cpuid_has(&svm->vcpu, X86_FEATURE_NRIPS);
>>>>
>>>> +       /*
>>>> +        * Intercept INVPCID instruction if the baremetal has the support
>>>> +        * but the guest doesn't claim the feature.
>>>> +        */
>>>> +       if (boot_cpu_has(X86_FEATURE_INVPCID) &&
>>>> +           !guest_cpuid_has(vcpu, X86_FEATURE_INVPCID))
>>>> +               set_extended_intercept(svm, INTERCEPT_INVPCID);
>>>> +
>>>
>>> What if INVPCID is enabled in the guest CPUID later? Shouldn't we then
>>> clear this intercept bit?
>>
>> I assume the feature enable comes in the same code path as this. I can add
>> "if else" check here if that is what you are suggesting.
> 
> Yes, that's what I'm suggesting.
> 
>>>
>>>>         if (!kvm_vcpu_apicv_active(vcpu))
>>>>                 return;
>>>>
>>>>
