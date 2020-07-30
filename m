Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A064D2336DA
	for <lists+kvm@lfdr.de>; Thu, 30 Jul 2020 18:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730042AbgG3QdF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 12:33:05 -0400
Received: from mail-dm6nam11on2066.outbound.protection.outlook.com ([40.107.223.66]:17728
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726275AbgG3QdC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jul 2020 12:33:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V5QZW8SxPSr80Z0h7e4Kx25bkMCMMDoJAJ1QIi1sOrqVkN3BGCGYFC46Y6hbU0Q6L1ehFfvCG6ZmiclJsJou5ukd7jxIDEj0zJBVKTmGmOI1YE2IjUHmTAYhh6GnetsO2ruAc1YDHqJo+q7vtiYtiaLTT0O9jiblq2Har/RyDPz2k7IcfGCD7rcRC1gyyXJ1VOegWNP4Mb53GL3xFoKYPn8Jf1N01Ur98kyKvmO1U1aXKudSD3Hs/0FefVyJfqdD7E5vxlktzQnh92r5Xnd4NI/Jd/0UirHC7roaWRijg/I7a0n9fUneShBbG58GwW7ChYRE7sw4jnV+GsZ0EOmzhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SSDqhMpmRQSj81JGIqv0Xa0BaMRLpL7n/8TNkBbK1Gg=;
 b=KpeUR2Q+uXiT8j+oPCQ4QKXKH0V2Ghj3tZfl3Vdpbiz5Cr7pqx+wgehWGShzKwzqGKzuURMwG2ItAxFrUzpjMZgQj/lkn7HmoTVf1YnZ293K+jbVjq9P7K4J+jk5T/6XL0HdMpgPz5c4DNGcW1Iyccqwu8VrjXHLT355lY7z9OxsOizrlrewDq1EK6Fv843ZnwF8+F1cjL7so9pPB1w2cdNA4ogRHusd3birdANEzUkouxgAln/04ri2NGr3P1U18SKWTm0qHrrBKhnncHJFoSFzbanQa3LmFUe1+mjGUmnSgQrnypqUpBLL6glWTo/bfKGh5ATBQvz0k/O+eOYaNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SSDqhMpmRQSj81JGIqv0Xa0BaMRLpL7n/8TNkBbK1Gg=;
 b=EZ8vhGScWZW+sKbxtW/Jk5lFoRrotdZh0SfY/ZLln8YTOEd6u9ZgVrtQ5BxJiCLurakqjS8+dMYiyeII0ttSqLoCEa+zrvAZJKXshiwpHe4PgRM5JGkq1ekCCja2unGv3pN0IB7NoEfeHzHldiqKXb01gyYtr1BceaXcqIxmelg=
Authentication-Results: linutronix.de; dkim=none (message not signed)
 header.d=none;linutronix.de; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN6PR12MB2735.namprd12.prod.outlook.com (2603:10b6:805:69::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.19; Thu, 30 Jul
 2020 16:32:57 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c%6]) with mapi id 15.20.3216.033; Thu, 30 Jul 2020
 16:32:57 +0000
Subject: RE: [PATCH v3 11/11] KVM:SVM: Enable INVPCID feature on AMD
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm list <kvm@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
References: <159597929496.12744.14654593948763926416.stgit@bmoger-ubuntu>
 <159597953941.12744.13644431147694358715.stgit@bmoger-ubuntu>
 <CALMp9eT071cb37w1+i957EeZnXAUTZWm=0ZF-BEX4fpiBKo1dw@mail.gmail.com>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <2c40a09b-0ad9-9ca0-6efe-991b10913277@amd.com>
Date:   Thu, 30 Jul 2020 11:32:56 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <CALMp9eT071cb37w1+i957EeZnXAUTZWm=0ZF-BEX4fpiBKo1dw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN6PR08CA0031.namprd08.prod.outlook.com
 (2603:10b6:805:66::44) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.79] (165.204.77.1) by SN6PR08CA0031.namprd08.prod.outlook.com (2603:10b6:805:66::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16 via Frontend Transport; Thu, 30 Jul 2020 16:32:56 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ca66c6f0-1bdb-4a94-4a36-08d834a63763
X-MS-TrafficTypeDiagnostic: SN6PR12MB2735:
X-Microsoft-Antispam-PRVS: <SN6PR12MB2735B81D067EF4ACAD584EDB95710@SN6PR12MB2735.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TyK9JmDinEedyipAjAGKQV/WMONInasZru7xB7MEOYa48wv5KJUlSZMbkRb5UJ7hZoOcVaWTeN6LN3KEJPky+DYtLiHibF12uaqr4luI9oqIBg0jgaTF4LwlgSMtGlPQw1SFJTuiO94607gSQqI7j3xRWA3+9onY/5j+wVsJ6ncbIKGhRuzM1yxEZAi8MfCquKpk5v3fAQWb1wi6PKzv80u11Hkt/rVOKLptgCXzX7ByPA+2Z8+24JQLSiGTmpSz1d1E94IlZRB++DzGaH/9hYZ/NHblz+KVFBbVetpqFX2oDZeNLYWtfr762KViCkoNDNXafO1S8BrnC2Cx8+rWmJG0RYs8ppFamRAYc2IAD71hJ0HUG40NtUNeKA38pUgkOs+3u+wqMPWyOK9HiZhj8ZKbgI90Z64aJ0XCu4Hh8siaJ8HveGEtHscPRDbCN/8vs1e/M2GnCuom/aQh8Dus4Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(376002)(346002)(39860400002)(366004)(966005)(54906003)(478600001)(316002)(36756003)(16576012)(5660300002)(6916009)(7416002)(31686004)(956004)(2616005)(44832011)(83080400001)(52116002)(6486002)(53546011)(86362001)(2906002)(31696002)(83380400001)(8676002)(4326008)(45080400002)(66946007)(186003)(66556008)(26005)(8936002)(16526019)(66476007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 8dFH9Y1NjVjgex7II4UfhNfqy2InzsZMS+HLnhaRoLh5UPMGDU5fDPyz4aaqwbr9FAxU9bSkXNx5A2Pg/qVT7gPujjYB+9Hh4MZ/DD+hydrQI+m2NXosgR6S2ft1m14yi9Hm4yC+4CsbSh7CLmWUOZw2LjRJvlZAcpfMOMhOxinpt7vfDJVZ+YTS+5QgqS1E0PCILe1L/5hro/Jyc5CJsjVeesDK7xFoxMH1OAcCNXN1i7hvEMaVkF/6DUYJwVr8/oxeUjuHpv1mCyAV+ezad1B26weyc+8XDFXqfpucFZWVp25Mz0olBt2lfDSayyBXWmXPESqGfetrFOR34jP1TaNJgk3xtHeJ+hODVcK4Tb+5UmRqOEtnQrfYf2corWUJLU0PeHQ8Hpj0W9dhN409/FHTmIcMHOstYlqtd6kdeUnCOkOinQ/obJCERf1X6BjZeFnS3E0okd9+8Hz1Ylw9ve43IFCdAiEd1yQITOW5AHEQ2Cm1gFYnSEtrCTSKiER9vf+cojZMl4J6TGmDYWi+0va3NHUHaPwnwDtIeeMSE2bLf3fZBjysQa4ZrWiR3v2c4CQjsMjBMj+cs/H3bX1IA97B0XXipIUVKtRT3kSFkJ736piQPSlTRZjTuM693libL6T+OHUx/rzg99uySwlFUQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca66c6f0-1bdb-4a94-4a36-08d834a63763
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2020 16:32:57.3553
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nWK4qv14NYgO/+sFoMpBa8xTvw3hxVGw2epaFMHHwlT/DnNjTftljgj+6zJIpCW9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2735
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: kvm-owner@vger.kernel.org <kvm-owner@vger.kernel.org> On Behalf
> Of Jim Mattson
> Sent: Wednesday, July 29, 2020 6:01 PM
> To: Moger, Babu <Babu.Moger@amd.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>; Vitaly Kuznetsov
> <vkuznets@redhat.com>; Wanpeng Li <wanpengli@tencent.com>; Sean
> Christopherson <sean.j.christopherson@intel.com>; kvm list
> <kvm@vger.kernel.org>; Joerg Roedel <joro@8bytes.org>; the arch/x86
> maintainers <x86@kernel.org>; LKML <linux-kernel@vger.kernel.org>; Ingo
> Molnar <mingo@redhat.com>; Borislav Petkov <bp@alien8.de>; H . Peter Anvin
> <hpa@zytor.com>; Thomas Gleixner <tglx@linutronix.de>
> Subject: Re: [PATCH v3 11/11] KVM:SVM: Enable INVPCID feature on AMD
> 
> On Tue, Jul 28, 2020 at 4:39 PM Babu Moger <babu.moger@amd.com> wrote:
> >
> > The following intercept bit has been added to support VMEXIT for
> > INVPCID instruction:
> > Code    Name            Cause
> > A2h     VMEXIT_INVPCID  INVPCID instruction
> >
> > The following bit has been added to the VMCB layout control area to
> > control intercept of INVPCID:
> > Byte Offset     Bit(s)    Function
> > 14h             2         intercept INVPCID
> >
> > Enable the interceptions when the the guest is running with shadow
> > page table enabled and handle the tlbflush based on the invpcid
> > instruction type.
> >
> > For the guests with nested page table (NPT) support, the INVPCID
> > feature works as running it natively. KVM does not need to do any
> > special handling in this case.
> >
> > AMD documentation for INVPCID feature is available at "AMD64
> > Architecture Programmer’s Manual Volume 2: System Programming, Pub.
> > 24593 Rev. 3.34(or later)"
> >
> > The documentation can be obtained at the links below:
> > Link:
> > https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fwww.
> >
> amd.com%2Fsystem%2Ffiles%2FTechDocs%2F24593.pdf&amp;data=02%7C01%
> 7CBab
> >
> u.Moger%40amd.com%7C68f9bafe44704700ac3b08d834135678%7C3dd8961fe
> 4884e6
> >
> 08e11a82d994e183d%7C0%7C0%7C637316605732430961&amp;sdata=c%2Fss1
> 2Y5Hcy
> > pwDfEIv8kHiI33XI6jtLAb5wUm96%2BY8I%3D&amp;reserved=0
> > Link:
> > https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fbugz
> >
> illa.kernel.org%2Fshow_bug.cgi%3Fid%3D206537&amp;data=02%7C01%7CBab
> u.M
> >
> oger%40amd.com%7C68f9bafe44704700ac3b08d834135678%7C3dd8961fe488
> 4e608e
> >
> 11a82d994e183d%7C0%7C0%7C637316605732430961&amp;sdata=wv5px6rzaT
> R8DcZl
> > CWpAkAFMkAv61XkdRv3274BJD6A%3D&amp;reserved=0
> >
> > Signed-off-by: Babu Moger <babu.moger@amd.com>
> > ---
> >  arch/x86/include/uapi/asm/svm.h |    2 +
> >  arch/x86/kvm/svm/svm.c          |   64
> +++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 66 insertions(+)
> >
> > diff --git a/arch/x86/include/uapi/asm/svm.h
> > b/arch/x86/include/uapi/asm/svm.h index 2e8a30f06c74..522d42dfc28c
> > 100644
> > --- a/arch/x86/include/uapi/asm/svm.h
> > +++ b/arch/x86/include/uapi/asm/svm.h
> > @@ -76,6 +76,7 @@
> >  #define SVM_EXIT_MWAIT_COND    0x08c
> >  #define SVM_EXIT_XSETBV        0x08d
> >  #define SVM_EXIT_RDPRU         0x08e
> > +#define SVM_EXIT_INVPCID       0x0a2
> >  #define SVM_EXIT_NPF           0x400
> >  #define SVM_EXIT_AVIC_INCOMPLETE_IPI           0x401
> >  #define SVM_EXIT_AVIC_UNACCELERATED_ACCESS     0x402
> > @@ -171,6 +172,7 @@
> >         { SVM_EXIT_MONITOR,     "monitor" }, \
> >         { SVM_EXIT_MWAIT,       "mwait" }, \
> >         { SVM_EXIT_XSETBV,      "xsetbv" }, \
> > +       { SVM_EXIT_INVPCID,     "invpcid" }, \
> >         { SVM_EXIT_NPF,         "npf" }, \
> >         { SVM_EXIT_AVIC_INCOMPLETE_IPI,         "avic_incomplete_ipi" }, \
> >         { SVM_EXIT_AVIC_UNACCELERATED_ACCESS,
> "avic_unaccelerated_access" }, \
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c index
> > 99cc9c285fe6..6b099e0b28c0 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -813,6 +813,11 @@ static __init void svm_set_cpu_caps(void)
> >         if (boot_cpu_has(X86_FEATURE_LS_CFG_SSBD) ||
> >             boot_cpu_has(X86_FEATURE_AMD_SSBD))
> >                 kvm_cpu_cap_set(X86_FEATURE_VIRT_SSBD);
> > +
> > +       /* Enable INVPCID if both PCID and INVPCID enabled */
> > +       if (boot_cpu_has(X86_FEATURE_PCID) &&
> > +           boot_cpu_has(X86_FEATURE_INVPCID))
> > +               kvm_cpu_cap_set(X86_FEATURE_INVPCID);
> >  }
> 
> Why is PCID required? Can't this just be
> 'kvm_cpu_cap_check_and_set(X86_FEATURE_INVPCID);'?

Ok.  Let me check.
> 
> >  static __init int svm_hardware_setup(void) @@ -1099,6 +1104,18 @@
> > static void init_vmcb(struct vcpu_svm *svm)
> >                 clr_intercept(svm, INTERCEPT_PAUSE);
> >         }
> >
> > +       /*
> > +        * Intercept INVPCID instruction only if shadow page table is
> > +        * enabled. Interception is not required with nested page table
> > +        * enabled.
> > +        */
> > +       if (boot_cpu_has(X86_FEATURE_INVPCID)) {
> 
> Shouldn't this be 'kvm_cpu_cap_has(X86_FEATURE_INVPCID),' so that it is
> consistent with the code above?

Sure. Will check on it.

> 
> > +               if (!npt_enabled)
> > +                       set_intercept(svm, INTERCEPT_INVPCID);
> > +               else
> > +                       clr_intercept(svm, INTERCEPT_INVPCID);
> > +       }
> > +
> >         if (kvm_vcpu_apicv_active(&svm->vcpu))
> >                 avic_init_vmcb(svm);
> >
> > @@ -2715,6 +2732,43 @@ static int mwait_interception(struct vcpu_svm
> *svm)
> >         return nop_interception(svm);
> >  }
> >
> > +static int invpcid_interception(struct vcpu_svm *svm) {
> > +       struct kvm_vcpu *vcpu = &svm->vcpu;
> > +       struct x86_exception e;
> > +       unsigned long type;
> > +       gva_t gva;
> > +       struct {
> > +               u64 pcid;
> > +               u64 gla;
> > +       } operand;
> > +
> > +       if (!guest_cpuid_has(vcpu, X86_FEATURE_INVPCID)) {
> > +               kvm_queue_exception(vcpu, UD_VECTOR);
> > +               return 1;
> > +       }
> > +
> > +       /*
> > +        * For an INVPCID intercept:
> > +        * EXITINFO1 provides the linear address of the memory operand.
> > +        * EXITINFO2 provides the contents of the register operand.
> > +        */
> > +       type = svm->vmcb->control.exit_info_2;
> > +       gva = svm->vmcb->control.exit_info_1;
> > +
> > +       if (type > 3) {
> > +               kvm_inject_gp(vcpu, 0);
> > +               return 1;
> > +       }
> > +
> > +       if (kvm_read_guest_virt(vcpu, gva, &operand, sizeof(operand), &e)) {
> > +               kvm_inject_emulated_page_fault(vcpu, &e);
> > +               return 1;
> > +       }
> 
> The emulated page fault is not always correct. See commit
> 7a35e515a7055 ("KVM: VMX: Properly handle kvm_read/write_guest_virt*()
> result"). I don't think the problems are only on the VMX side.

Ok. Sure. Will take a look.

> 
> > +
> > +       return kvm_handle_invpcid(vcpu, type, operand.pcid,
> > +operand.gla); }
> > +
> >  static int (*const svm_exit_handlers[])(struct vcpu_svm *svm) = {
> >         [SVM_EXIT_READ_CR0]                     = cr_interception,
> >         [SVM_EXIT_READ_CR3]                     = cr_interception,
> > @@ -2777,6 +2831,7 @@ static int (*const svm_exit_handlers[])(struct
> vcpu_svm *svm) = {
> >         [SVM_EXIT_MWAIT]                        = mwait_interception,
> >         [SVM_EXIT_XSETBV]                       = xsetbv_interception,
> >         [SVM_EXIT_RDPRU]                        = rdpru_interception,
> > +       [SVM_EXIT_INVPCID]                      = invpcid_interception,
> >         [SVM_EXIT_NPF]                          = npf_interception,
> >         [SVM_EXIT_RSM]                          = rsm_interception,
> >         [SVM_EXIT_AVIC_INCOMPLETE_IPI]          =
> avic_incomplete_ipi_interception,
> > @@ -3562,6 +3617,15 @@ static void svm_cpuid_update(struct kvm_vcpu
> *vcpu)
> >         svm->nrips_enabled = kvm_cpu_cap_has(X86_FEATURE_NRIPS) &&
> >                              guest_cpuid_has(&svm->vcpu,
> > X86_FEATURE_NRIPS);
> >
> > +       /* Check again if INVPCID interception if required */
> > +       if (boot_cpu_has(X86_FEATURE_INVPCID) &&
> 
> Again, shouldn't this be 'kvm_cpu_cap_has(X86_FEATURE_INVPCID)'?
> (Better, perhaps, would be to extract this common block of code into a separate
> function to be called from both places.)

Sure. Will work on it.
Thanks
> 
> > +           guest_cpuid_has(vcpu, X86_FEATURE_INVPCID)) {
> > +               if (!npt_enabled)
> > +                       set_intercept(svm, INTERCEPT_INVPCID);
> > +               else
> > +                       clr_intercept(svm, INTERCEPT_INVPCID);
> > +       }
> > +
> >         if (!kvm_vcpu_apicv_active(vcpu))
> >                 return;
> >
> >
