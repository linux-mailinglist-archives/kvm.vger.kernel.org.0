Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 631711F7DB0
	for <lists+kvm@lfdr.de>; Fri, 12 Jun 2020 21:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbgFLTgB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jun 2020 15:36:01 -0400
Received: from mail-dm6nam12on2057.outbound.protection.outlook.com ([40.107.243.57]:6196
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726268AbgFLTgB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jun 2020 15:36:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UUsGyEGbIrGmDkbpiqvp8In2yJqQ+pnrArZATfO7ZcWkK+kEoElwL8hvOSMut+DUggd8G7VOQh9VJiH8L23PNQEVdltX20afJVK1r/BLVGrojTm5uBJS+8MZzflAAzyJxRpCQ7U9LkP+qEtNzRHJUS7YBpiofLuhYwt4uIUO1w3YaMZjFk8XAejpM0BAZY5iyP+uDFvelaRadn8dR30EQte6H+c5Ky8Tgg+WLxtJbRBAlsu967wH5Vg3gyGs/nJ8DOIvihXgFym6WlbUEomrVBPjUEclQz1hISZ5OVpnM50Rf343fNfA4JQoY4nTvH8h3keMHRXTcyrrjEZ8Fu54ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xrF5/SgF2yGrOcQcjbSE0dGk8/OrJyTLprvA0PjDbcM=;
 b=ec4u+9FbWoN4ZRtsMdhGzJUeYtn8fvUaeORwZTcxn16jtHX3A3+ecXfRUo6sMMKdpxQ8nYGx1E4JfQeT8kB5lYFjoyuMUTKlJpOGfpPp+CxXjz0FcYR7UqCmPFZd/PDbPcAhPSCpzRll94D3KFK69ZwQAHgqA3HiitBOkMSvFGoO/97L4N20lBiJIVOsnTr/aBOH6hGhydv98DNMlmlN1kyzi9vVx6Uilx+Fqa+I+wG8RGL2nxdMRPWmzdVYeyQFppGJwvgGP5wtyzWsMnUwTKu0yY0OJI2AhuTZWPBoT7SuD1me05Z/2CL1qt9vXUOa748utFbVFfhx6DCSS5HBRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xrF5/SgF2yGrOcQcjbSE0dGk8/OrJyTLprvA0PjDbcM=;
 b=EfDVx8jgX/TQ4WL9OEkoBK2MIiUzxDSlwYKgJ7YLfMfs7NsMPUUSloWSxbsj0LmMDDVgVNQ5dMM7RPBeBIrv8kAXOWsjfPQovF90OMyy6HdRzapEi8ToOJQ04gA+ou+VBGk7bwtaikMGAD3SpeKQ/uiP/QssgI0tk9z9E72adWo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SA0PR12MB4526.namprd12.prod.outlook.com (2603:10b6:806:98::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.24; Fri, 12 Jun
 2020 19:35:57 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::2102:cc6b:b2db:4c2]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::2102:cc6b:b2db:4c2%3]) with mapi id 15.20.3088.021; Fri, 12 Jun 2020
 19:35:57 +0000
From:   Babu Moger <babu.moger@amd.com>
Subject: RE: [PATCH 3/3] KVM:SVM: Enable INVPCID feature on AMD
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
Message-ID: <d0b09992-eb87-651a-3b97-0787e07cc46d@amd.com>
Date:   Fri, 12 Jun 2020 14:35:55 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <CALMp9eSC-wwP50gtprpakKjPYeZ5LdDSFS6i__csVCJwUKmqjA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN1PR12CA0080.namprd12.prod.outlook.com
 (2603:10b6:802:21::15) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.79] (165.204.77.1) by SN1PR12CA0080.namprd12.prod.outlook.com (2603:10b6:802:21::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.18 via Frontend Transport; Fri, 12 Jun 2020 19:35:56 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7f2ab801-4326-418f-952f-08d80f07d3d7
X-MS-TrafficTypeDiagnostic: SA0PR12MB4526:
X-Microsoft-Antispam-PRVS: <SA0PR12MB45266CE15D25D6DFD7805A7995810@SA0PR12MB4526.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 0432A04947
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i9bQEDk6euYzAt/s4IpdAFHPVlRVmqng8FVXlzM80jVT3A6m0rIjavOF1D1xtaX+K8LzfFBgTBpMZiJ3eD2seyPtNVDcD92VR3Jqr/9soE1j/wgUedAlMKcRn1yFIrC2Reb02FtXfb8K+3E0ZMS8vkYdsFgx6SXB5PM9Jd2W9J5+8gyxMovtCGdrgAyNtUq3yLp7q46vI18L7XgUzyaLZCP3WdNGROv/WU48WS3zxtAYHkOahztDB6NN59i6w8MdbgdsbO0TSMmysmseqydikSnn5eV5I53rT9160XACywF5vSAHYdl+c609/2BYWIF0VCBHdYWqsY4JykHrA6r5HKXva49CgW2biIGBM7OYNE5g0eXx9KI+YDq3mi+jYsr89wToZXwe6YykQN3f0Lq9J2+3Yygkj+rxwfnnTQ5sLG45QsbhO4yXVZJ0UQPVMG5f
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(396003)(376002)(136003)(366004)(39860400002)(36756003)(83080400001)(31696002)(8676002)(66556008)(8936002)(66476007)(2906002)(66946007)(53546011)(16526019)(956004)(966005)(86362001)(2616005)(83380400001)(6486002)(186003)(44832011)(26005)(31686004)(316002)(4326008)(6916009)(52116002)(16576012)(478600001)(54906003)(45080400002)(5660300002)(7416002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: QRrkj95FOy9McmMzckeZjB9mu+kNevaNs3PLBZd2KZrZYz73U+zIWHhu/32Hhg5AY183ea6xov+neT3hRLwqId+AqhTMlPDTTklx2YipNmDdIN375RWVuGBespySNfdSM3+rbiwjQZ2F9B2FsWFrkiz8Zfhtrxp9TrJ3m3Dihk4suNE4K701tDw86MWimRehStW+6WhbzuPP2yiMS867Sju0VHJJeCyU5/bQpKEDjmXKde66IteCM0Jn9paYck/eQh3gVMXJtaQD1oQZxN5WAK9kY8W6C2+aRriz7JuORWCgHYLz+D3wJujTGtOujDLwNasMFa3WRYTIheDxbY/Kcyme9S6SmWcUAjpYKBQYJiX/c+V9kmmzyq1anEg+qZ7ZX5Ok8oy93ZXwKvMkjR8yGRZTMY2EYNNLPfh/9Uzotfv7iLDFM6NjK29Igu+uNYx/BDnYYPsn8hINfxyUN/QLkWHTiwmeFw1/OvVnrJhaVpY=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f2ab801-4326-418f-952f-08d80f07d3d7
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2020 19:35:57.1061
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YBR+DxRw9iC8+9Pg93mu68eU39EGeweEtnp/ge4cZmx9IZ7NH1kMkNv2BWXIR2ni
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4526
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Jim Mattson <jmattson@google.com>
> Sent: Thursday, June 11, 2020 6:51 PM
> To: Moger, Babu <Babu.Moger@amd.com>
> Cc: Wanpeng Li <wanpengli@tencent.com>; Joerg Roedel <joro@8bytes.org>;
> the arch/x86 maintainers <x86@kernel.org>; Sean Christopherson
> <sean.j.christopherson@intel.com>; Ingo Molnar <mingo@redhat.com>;
> Borislav Petkov <bp@alien8.de>; H . Peter Anvin <hpa@zytor.com>; Paolo
> Bonzini <pbonzini@redhat.com>; Vitaly Kuznetsov <vkuznets@redhat.com>;
> Thomas Gleixner <tglx@linutronix.de>; LKML <linux-kernel@vger.kernel.org>;
> kvm list <kvm@vger.kernel.org>
> Subject: Re: [PATCH 3/3] KVM:SVM: Enable INVPCID feature on AMD
> 
> On Thu, Jun 11, 2020 at 2:48 PM Babu Moger <babu.moger@amd.com> wrote:
> >
> > The following intercept is added for INVPCID instruction:
> > Code    Name            Cause
> > A2h     VMEXIT_INVPCID  INVPCID instruction
> >
> > The following bit is added to the VMCB layout control area
> > to control intercept of INVPCID:
> > Byte Offset     Bit(s)    Function
> > 14h             2         intercept INVPCID
> >
> > For the guests with nested page table (NPT) support, the INVPCID
> > feature works as running it natively. KVM does not need to do any
> > special handling in this case.
> >
> > Interceptions are required in the following cases.
> > 1. If the guest tries to disable the feature when the underlying
> > hardware supports it. In this case hypervisor needs to report #UD.
> 
> Per the AMD documentation, attempts to use INVPCID at CPL>0 will
> result in a #GP, regardless of the intercept bit. If the guest CPUID
> doesn't enumerate the feature, shouldn't the instruction raise #UD
> regardless of CPL? This seems to imply that we should intercept #GP
> and decode the instruction to see if we should synthesize #UD instead.

Purpose here is to report UD when the guest CPUID doesn't enumerate the
INVPCID feature When Bare-metal supports it. It seems to work fine for
that purpose. You are right. The #GP for CPL>0 takes precedence over
interception. No. I am not planning to intercept GP.

I will change the text. How about this?

Interceptions are required in the following cases.
1. If the guest CPUID doesn't enumerate the INVPCID feature when the
underlying hardware supports it,  hypervisor needs to report UD. However,
#GP for CPL>0 takes precedence over interception.

> > 2. When the guest is running with shadow page table enabled, in
> > this case the hypervisor needs to handle the tlbflush based on the
> > type of invpcid instruction type.
> >
> > AMD documentation for INVPCID feature is available at "AMD64
> > Architecture Programmer’s Manual Volume 2: System Programming,
> > Pub. 24593 Rev. 3.34(or later)"
> >
> > The documentation can be obtained at the links below:
> > Link:
> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fwww.a
> md.com%2Fsystem%2Ffiles%2FTechDocs%2F24593.pdf&amp;data=02%7C01%7
> Cbabu.moger%40amd.com%7C36861b25f6d143e3b38e08d80e624472%7C3dd8
> 961fe4884e608e11a82d994e183d%7C0%7C0%7C637275163374103811&amp;s
> data=E%2Fdb6T%2BdO4nrtUoqhKidF6XyorsWrphj6O4WwNZpmYA%3D&amp;res
> erved=0
> > Link:
> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fbugzilla.
> kernel.org%2Fshow_bug.cgi%3Fid%3D206537&amp;data=02%7C01%7Cbabu.m
> oger%40amd.com%7C36861b25f6d143e3b38e08d80e624472%7C3dd8961fe488
> 4e608e11a82d994e183d%7C0%7C0%7C637275163374103811&amp;sdata=b81
> 9W%2FhKS93%2BAp3QvcsR0BwTQpUVUFMbIaNaisgWHRY%3D&amp;reserved=
> 0
> >
> > Signed-off-by: Babu Moger <babu.moger@amd.com>
> > ---
> >  arch/x86/include/asm/svm.h      |    4 ++++
> >  arch/x86/include/uapi/asm/svm.h |    2 ++
> >  arch/x86/kvm/svm/svm.c          |   42
> +++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 48 insertions(+)
> >
> > diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> > index 62649fba8908..6488094f67fa 100644
> > --- a/arch/x86/include/asm/svm.h
> > +++ b/arch/x86/include/asm/svm.h
> > @@ -55,6 +55,10 @@ enum {
> >         INTERCEPT_RDPRU,
> >  };
> >
> > +/* Extended Intercept bits */
> > +enum {
> > +       INTERCEPT_INVPCID = 2,
> > +};
> >
> >  struct __attribute__ ((__packed__)) vmcb_control_area {
> >         u32 intercept_cr;
> > diff --git a/arch/x86/include/uapi/asm/svm.h
> b/arch/x86/include/uapi/asm/svm.h
> > index 2e8a30f06c74..522d42dfc28c 100644
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
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 285e5e1ff518..82d974338f68 100644
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
> >
> >  static __init int svm_hardware_setup(void)
> > @@ -1099,6 +1104,17 @@ static void init_vmcb(struct vcpu_svm *svm)
> >                 clr_intercept(svm, INTERCEPT_PAUSE);
> >         }
> >
> > +       /*
> > +        * Intercept INVPCID instruction only if shadow page table is
> > +        * enabled. Interception is not required with nested page table.
> > +        */
> > +       if (boot_cpu_has(X86_FEATURE_INVPCID)) {
> > +               if (!npt_enabled)
> > +                       set_extended_intercept(svm, INTERCEPT_INVPCID);
> > +               else
> > +                       clr_extended_intercept(svm, INTERCEPT_INVPCID);
> > +       }
> > +
> >         if (kvm_vcpu_apicv_active(&svm->vcpu))
> >                 avic_init_vmcb(svm);
> >
> > @@ -2715,6 +2731,23 @@ static int mwait_interception(struct vcpu_svm
> *svm)
> >         return nop_interception(svm);
> >  }
> >
> > +static int invpcid_interception(struct vcpu_svm *svm)
> > +{
> > +       struct kvm_vcpu *vcpu = &svm->vcpu;
> > +       unsigned long type;
> > +       gva_t gva;
> > +
> > +       /*
> > +        * For an INVPCID intercept:
> > +        * EXITINFO1 provides the linear address of the memory operand.
> > +        * EXITINFO2 provides the contents of the register operand.
> > +        */
> > +       type = svm->vmcb->control.exit_info_2;
> > +       gva = svm->vmcb->control.exit_info_1;
> > +
> > +       return kvm_handle_invpcid_types(vcpu,  gva, type);
> > +}
> > +
> >  static int (*const svm_exit_handlers[])(struct vcpu_svm *svm) = {
> >         [SVM_EXIT_READ_CR0]                     = cr_interception,
> >         [SVM_EXIT_READ_CR3]                     = cr_interception,
> > @@ -2777,6 +2810,7 @@ static int (*const svm_exit_handlers[])(struct
> vcpu_svm *svm) = {
> >         [SVM_EXIT_MWAIT]                        = mwait_interception,
> >         [SVM_EXIT_XSETBV]                       = xsetbv_interception,
> >         [SVM_EXIT_RDPRU]                        = rdpru_interception,
> > +       [SVM_EXIT_INVPCID]                      = invpcid_interception,
> >         [SVM_EXIT_NPF]                          = npf_interception,
> >         [SVM_EXIT_RSM]                          = rsm_interception,
> >         [SVM_EXIT_AVIC_INCOMPLETE_IPI]          =
> avic_incomplete_ipi_interception,
> > @@ -3562,6 +3596,14 @@ static void svm_cpuid_update(struct kvm_vcpu
> *vcpu)
> >         svm->nrips_enabled = kvm_cpu_cap_has(X86_FEATURE_NRIPS) &&
> >                              guest_cpuid_has(&svm->vcpu, X86_FEATURE_NRIPS);
> >
> > +       /*
> > +        * Intercept INVPCID instruction if the baremetal has the support
> > +        * but the guest doesn't claim the feature.
> > +        */
> > +       if (boot_cpu_has(X86_FEATURE_INVPCID) &&
> > +           !guest_cpuid_has(vcpu, X86_FEATURE_INVPCID))
> > +               set_extended_intercept(svm, INTERCEPT_INVPCID);
> > +
> 
> What if INVPCID is enabled in the guest CPUID later? Shouldn't we then
> clear this intercept bit?

I assume the feature enable comes in the same code path as this. I can add
"if else" check here if that is what you are suggesting.

> 
> >         if (!kvm_vcpu_apicv_active(vcpu))
> >                 return;
> >
> >
