Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32AB41F9944
	for <lists+kvm@lfdr.de>; Mon, 15 Jun 2020 15:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730117AbgFONrP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jun 2020 09:47:15 -0400
Received: from mail-mw2nam12on2058.outbound.protection.outlook.com ([40.107.244.58]:25775
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730109AbgFONrN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jun 2020 09:47:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cScdHKUuSkCoRQaEOlR6HmkemLa00ycS29Hs11Bh3oXM2u5+hSac+5cJ1AX9oW3XMvlntGeARpLrb7Z3QA7SdP5Cqsn73sdunl7GZojRFdS3m9SMiCXV5eEmVSbmYlS5sgyNCNXVhcsCA2zPE09zsba6HNnvWUX3uMbE3c/bQbS2e1TzqTr+7e4nirOS7Jibynsvs00K83fxuGxOCDgY2ncj3z0xQ00kGWNpcikStixVJIp4y8BWS62ysP/4wGtM5TdTXL7b9+fB6dE0ZyLvKJFCkI0zXQRgXSh1CpNLGIw/yAOBKdUVU1aPQjNt9a9yVjJ34OxfXnxjrgbBGdv5ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9UqugMh9TSpvU6TnbI+tMlblSdc0z99jZQ2sATc0Id4=;
 b=b5ElQAJARQFC+ouLKwBAFBangu1DuV031ta6ScqOr/ETsnr2tf15ot1LiyaPQm5sGzkSBUqpNXJEGyWMGjK9QZIG6KBXzS/bXK6qpNXHA+ZIVBCxUzD2VKrPZ4bqXEBvkXrbD1u3lXte98gp7jWvncPvoEZ+eUyna4PhJ8B4+LzYD8jt8Xz5ivAgsOgs6oZNhvKPFTAdHXFO3ndJmOC+DjtxTk01lF7SOAWPb/HQa9zBf0BteZGihS2kVqVPWQrUyhLzHo2qZKL8xeSCBfojIdxVftaBQoB5nRK+nfZxqgr9avfDFC17/WN2uO1Hzs+Q/UrCTgp2gWOhM5Mp3BMjOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9UqugMh9TSpvU6TnbI+tMlblSdc0z99jZQ2sATc0Id4=;
 b=noTANUFR2LGEezf5caaxkn0mdRs1CST7ypFF5i2Wc9JfpwCXK+wJTHrTqPTSpWecDGdi3pqZNuMXETraTb0qDZWI7cxXZx+1ZJpGgIxjVv84x42kgrYPMhd2NhgJTxu31XbnZKePIOcsmzPayqmIEIqVnrd3XcdGBHgTd4wujVY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SA0PR12MB4479.namprd12.prod.outlook.com (2603:10b6:806:95::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.21; Mon, 15 Jun
 2020 13:47:09 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::2102:cc6b:b2db:4c2]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::2102:cc6b:b2db:4c2%3]) with mapi id 15.20.3088.029; Mon, 15 Jun 2020
 13:47:09 +0000
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
 <d0b09992-eb87-651a-3b97-0787e07cc46d@amd.com>
 <CALMp9eRZQXgJvt3MGreq47ApM5ObTU7YFQV_GcY5N+jozGK1Uw@mail.gmail.com>
 <d0c38022-2d82-aacc-4829-02c557edddc0@amd.com>
 <CALMp9eSn36W=YK5XtaVATJis-J--udGK4ZOESDhYyT0zJ4YZ9A@mail.gmail.com>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <10f3c3bd-700b-c2c7-0aba-a213941b6416@amd.com>
Date:   Mon, 15 Jun 2020 08:47:07 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <CALMp9eSn36W=YK5XtaVATJis-J--udGK4ZOESDhYyT0zJ4YZ9A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM5PR06CA0067.namprd06.prod.outlook.com
 (2603:10b6:3:37::29) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.79] (165.204.77.1) by DM5PR06CA0067.namprd06.prod.outlook.com (2603:10b6:3:37::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.18 via Frontend Transport; Mon, 15 Jun 2020 13:47:08 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4ae30431-1895-453d-1a7e-08d811329941
X-MS-TrafficTypeDiagnostic: SA0PR12MB4479:
X-Microsoft-Antispam-PRVS: <SA0PR12MB44790D2D24612AB2BFEC8171959C0@SA0PR12MB4479.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-Forefront-PRVS: 04359FAD81
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 57W6BC9kxmkRlH1srxk+R1aUwrFqOJ30E3eAoQC0F/GoomXL6chUN4IBPLb1DD2gMigesoEN94r40bzjK/TIzEh0A09/Z2Qf76GTfekqBW6g68omRSNdeMTPtJt7q8DkEGj7DAA3NK+q0VjLWoHHnjLnv0mCBoh7X43bW+DAEdJ4D/QEP+MgPt28yjm8feAZeHbIdboXbXGvas/bpCN9h3A46DIkC3EtyQV0n9OswT8TIwAl9nZqO3uF6cwFmtyxKZfMCa/o+BCVf4B/KUWMomFuh5P6Hgg2AZUBVQdP/5/J6agL0Msqr3YbGX0r9f9UBa9dX9tS0I4Uf1vgiIrx4FlwvOBuwk4IKyClPeXl5GoEax9ymn/JvCFYfOczq9VyHEB1dZsSr4BcWokhjnVzymuu9SLpdBzbgLeugVie2hdnHzCZGUmHV36QuDkNdVXA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(136003)(39860400002)(346002)(396003)(2616005)(4326008)(956004)(7416002)(478600001)(83380400001)(44832011)(31686004)(83080400001)(45080400002)(6916009)(5660300002)(30864003)(31696002)(16576012)(316002)(66946007)(66476007)(66556008)(86362001)(54906003)(966005)(36756003)(16526019)(53546011)(6486002)(26005)(2906002)(186003)(52116002)(8676002)(8936002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: N+fiLHnCUoVfowAq0h17G+R5EPEJRArtCs7n9GE1IjlXm6+DomCO9E9COU7grqrGIr9gI/sH9bSX6vCr6AoBeqgBR3vs9uFXYgF8ZuzBRxPblCQOZIwbjCZbWNTChNuGyFMTwp1IMmmz/MJB1Vud2VzwH3dJQh3XeejKKoSOmBLBF0rBjx1X9a7I9K1Dp04H9ugRb/tEAZoxfUB4r3RnLdN6CWoj1mHwDlFqGeWed2XS1TO1IfMImNCbAY0rmfxdfucNHzsNhd7q8X3kAo7d3fDgEytkO0KwE8aV8DLUrWXPC0rKYXQxP4iTLXGqVwEk0zZsKzkIIV94k9RVyF74aaPGEg+PlliIiYWPDJePD8ZzflGviPo4X/VZ/lt2lFUi13NvCXjSDXgcv1Ndx3yXGMgkO4s6oC8EDzS7a1+F/zO1IClEpEfafwo6eaawcYQzupHqOCN3Qw8PYnhQMWBru4w/PpY+NpNkx5ruKQe3F4Y=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ae30431-1895-453d-1a7e-08d811329941
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2020 13:47:09.3261
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mcz2s7y4IwgomgKOBwk21A6fPBjtq7g6xM1Et1sGSB5zbTRIXMX4Pz0mBtYRCoV3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4479
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Jim Mattson <jmattson@google.com>
> Sent: Friday, June 12, 2020 7:04 PM
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
> On Fri, Jun 12, 2020 at 2:47 PM Babu Moger <babu.moger@amd.com> wrote:
> >
> >
> >
> > On 6/12/20 3:10 PM, Jim Mattson wrote:
> > > On Fri, Jun 12, 2020 at 12:35 PM Babu Moger <babu.moger@amd.com>
> wrote:
> > >>
> > >>
> > >>
> > >>> -----Original Message-----
> > >>> From: Jim Mattson <jmattson@google.com>
> > >>> Sent: Thursday, June 11, 2020 6:51 PM
> > >>> To: Moger, Babu <Babu.Moger@amd.com>
> > >>> Cc: Wanpeng Li <wanpengli@tencent.com>; Joerg Roedel
> <joro@8bytes.org>;
> > >>> the arch/x86 maintainers <x86@kernel.org>; Sean Christopherson
> > >>> <sean.j.christopherson@intel.com>; Ingo Molnar <mingo@redhat.com>;
> > >>> Borislav Petkov <bp@alien8.de>; H . Peter Anvin <hpa@zytor.com>; Paolo
> > >>> Bonzini <pbonzini@redhat.com>; Vitaly Kuznetsov
> <vkuznets@redhat.com>;
> > >>> Thomas Gleixner <tglx@linutronix.de>; LKML <linux-
> kernel@vger.kernel.org>;
> > >>> kvm list <kvm@vger.kernel.org>
> > >>> Subject: Re: [PATCH 3/3] KVM:SVM: Enable INVPCID feature on AMD
> > >>>
> > >>> On Thu, Jun 11, 2020 at 2:48 PM Babu Moger <babu.moger@amd.com>
> wrote:
> > >>>>
> > >>>> The following intercept is added for INVPCID instruction:
> > >>>> Code    Name            Cause
> > >>>> A2h     VMEXIT_INVPCID  INVPCID instruction
> > >>>>
> > >>>> The following bit is added to the VMCB layout control area
> > >>>> to control intercept of INVPCID:
> > >>>> Byte Offset     Bit(s)    Function
> > >>>> 14h             2         intercept INVPCID
> > >>>>
> > >>>> For the guests with nested page table (NPT) support, the INVPCID
> > >>>> feature works as running it natively. KVM does not need to do any
> > >>>> special handling in this case.
> > >>>>
> > >>>> Interceptions are required in the following cases.
> > >>>> 1. If the guest tries to disable the feature when the underlying
> > >>>> hardware supports it. In this case hypervisor needs to report #UD.
> > >>>
> > >>> Per the AMD documentation, attempts to use INVPCID at CPL>0 will
> > >>> result in a #GP, regardless of the intercept bit. If the guest CPUID
> > >>> doesn't enumerate the feature, shouldn't the instruction raise #UD
> > >>> regardless of CPL? This seems to imply that we should intercept #GP
> > >>> and decode the instruction to see if we should synthesize #UD instead.
> > >>
> > >> Purpose here is to report UD when the guest CPUID doesn't enumerate the
> > >> INVPCID feature When Bare-metal supports it. It seems to work fine for
> > >> that purpose. You are right. The #GP for CPL>0 takes precedence over
> > >> interception. No. I am not planning to intercept GP.
> > >
> > > WIthout intercepting #GP, you fail to achieve your stated purpose.
> >
> > I think I have misunderstood this part. I was not inteding to change the
> > #GP behaviour. I will remove this part. My intension of these series is to
> > handle invpcid in shadow page mode. I have verified that part. Hope I did
> > not miss anything else.
> 
> You don't really have to intercept INVPCID when tdp is in use, right?

That is correct.  Adding the intercept only when tdp is off.

> There are certainly plenty of operations for which kvm does not
> properly raise #UD when they aren't enumerated in the guest CPUID.
> 
> > >> I will change the text. How about this?
> > >>
> > >> Interceptions are required in the following cases.
> > >> 1. If the guest CPUID doesn't enumerate the INVPCID feature when the
> > >> underlying hardware supports it,  hypervisor needs to report UD. However,
> > >> #GP for CPL>0 takes precedence over interception.
> > >
> > > This text is not internally consistent. In one sentence, you say that
> > > "hypervisor needs to report #UD." In the next sentence, you are
> > > essentially saying that the hypervisor doesn't need to report #UD.
> > > Which is it?
> > >
> > >>>> 2. When the guest is running with shadow page table enabled, in
> > >>>> this case the hypervisor needs to handle the tlbflush based on the
> > >>>> type of invpcid instruction type.
> > >>>>
> > >>>> AMD documentation for INVPCID feature is available at "AMD64
> > >>>> Architecture Programmer’s Manual Volume 2: System Programming,
> > >>>> Pub. 24593 Rev. 3.34(or later)"
> > >>>>
> > >>>> The documentation can be obtained at the links below:
> > >>>> Link:
> > >>>
> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fwww.a
> > >>>
> md.com%2Fsystem%2Ffiles%2FTechDocs%2F24593.pdf&amp;data=02%7C01%7
> > >>>
> Cbabu.moger%40amd.com%7C36861b25f6d143e3b38e08d80e624472%7C3dd8
> > >>>
> 961fe4884e608e11a82d994e183d%7C0%7C0%7C637275163374103811&amp;s
> > >>>
> data=E%2Fdb6T%2BdO4nrtUoqhKidF6XyorsWrphj6O4WwNZpmYA%3D&amp;res
> > >>> erved=0
> > >>>> Link:
> > >>>
> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fbugzilla.
> > >>>
> kernel.org%2Fshow_bug.cgi%3Fid%3D206537&amp;data=02%7C01%7Cbabu.m
> > >>>
> oger%40amd.com%7C36861b25f6d143e3b38e08d80e624472%7C3dd8961fe488
> > >>>
> 4e608e11a82d994e183d%7C0%7C0%7C637275163374103811&amp;sdata=b81
> > >>>
> 9W%2FhKS93%2BAp3QvcsR0BwTQpUVUFMbIaNaisgWHRY%3D&amp;reserved=
> > >>> 0
> > >>>>
> > >>>> Signed-off-by: Babu Moger <babu.moger@amd.com>
> > >>>> ---
> > >>>>  arch/x86/include/asm/svm.h      |    4 ++++
> > >>>>  arch/x86/include/uapi/asm/svm.h |    2 ++
> > >>>>  arch/x86/kvm/svm/svm.c          |   42
> > >>> +++++++++++++++++++++++++++++++++++++++
> > >>>>  3 files changed, 48 insertions(+)
> > >>>>
> > >>>> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> > >>>> index 62649fba8908..6488094f67fa 100644
> > >>>> --- a/arch/x86/include/asm/svm.h
> > >>>> +++ b/arch/x86/include/asm/svm.h
> > >>>> @@ -55,6 +55,10 @@ enum {
> > >>>>         INTERCEPT_RDPRU,
> > >>>>  };
> > >>>>
> > >>>> +/* Extended Intercept bits */
> > >>>> +enum {
> > >>>> +       INTERCEPT_INVPCID = 2,
> > >>>> +};
> > >>>>
> > >>>>  struct __attribute__ ((__packed__)) vmcb_control_area {
> > >>>>         u32 intercept_cr;
> > >>>> diff --git a/arch/x86/include/uapi/asm/svm.h
> > >>> b/arch/x86/include/uapi/asm/svm.h
> > >>>> index 2e8a30f06c74..522d42dfc28c 100644
> > >>>> --- a/arch/x86/include/uapi/asm/svm.h
> > >>>> +++ b/arch/x86/include/uapi/asm/svm.h
> > >>>> @@ -76,6 +76,7 @@
> > >>>>  #define SVM_EXIT_MWAIT_COND    0x08c
> > >>>>  #define SVM_EXIT_XSETBV        0x08d
> > >>>>  #define SVM_EXIT_RDPRU         0x08e
> > >>>> +#define SVM_EXIT_INVPCID       0x0a2
> > >>>>  #define SVM_EXIT_NPF           0x400
> > >>>>  #define SVM_EXIT_AVIC_INCOMPLETE_IPI           0x401
> > >>>>  #define SVM_EXIT_AVIC_UNACCELERATED_ACCESS     0x402
> > >>>> @@ -171,6 +172,7 @@
> > >>>>         { SVM_EXIT_MONITOR,     "monitor" }, \
> > >>>>         { SVM_EXIT_MWAIT,       "mwait" }, \
> > >>>>         { SVM_EXIT_XSETBV,      "xsetbv" }, \
> > >>>> +       { SVM_EXIT_INVPCID,     "invpcid" }, \
> > >>>>         { SVM_EXIT_NPF,         "npf" }, \
> > >>>>         { SVM_EXIT_AVIC_INCOMPLETE_IPI,         "avic_incomplete_ipi" }, \
> > >>>>         { SVM_EXIT_AVIC_UNACCELERATED_ACCESS,
> > >>> "avic_unaccelerated_access" }, \
> > >>>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > >>>> index 285e5e1ff518..82d974338f68 100644
> > >>>> --- a/arch/x86/kvm/svm/svm.c
> > >>>> +++ b/arch/x86/kvm/svm/svm.c
> > >>>> @@ -813,6 +813,11 @@ static __init void svm_set_cpu_caps(void)
> > >>>>         if (boot_cpu_has(X86_FEATURE_LS_CFG_SSBD) ||
> > >>>>             boot_cpu_has(X86_FEATURE_AMD_SSBD))
> > >>>>                 kvm_cpu_cap_set(X86_FEATURE_VIRT_SSBD);
> > >>>> +
> > >>>> +       /* Enable INVPCID if both PCID and INVPCID enabled */
> > >>>> +       if (boot_cpu_has(X86_FEATURE_PCID) &&
> > >>>> +           boot_cpu_has(X86_FEATURE_INVPCID))
> > >>>> +               kvm_cpu_cap_set(X86_FEATURE_INVPCID);
> > >>>>  }
> > >>>>
> > >>>>  static __init int svm_hardware_setup(void)
> > >>>> @@ -1099,6 +1104,17 @@ static void init_vmcb(struct vcpu_svm *svm)
> > >>>>                 clr_intercept(svm, INTERCEPT_PAUSE);
> > >>>>         }
> > >>>>
> > >>>> +       /*
> > >>>> +        * Intercept INVPCID instruction only if shadow page table is
> > >>>> +        * enabled. Interception is not required with nested page table.
> > >>>> +        */
> > >>>> +       if (boot_cpu_has(X86_FEATURE_INVPCID)) {
> > >>>> +               if (!npt_enabled)
> > >>>> +                       set_extended_intercept(svm, INTERCEPT_INVPCID);
> > >>>> +               else
> > >>>> +                       clr_extended_intercept(svm, INTERCEPT_INVPCID);
> > >>>> +       }
> > >>>> +
> > >>>>         if (kvm_vcpu_apicv_active(&svm->vcpu))
> > >>>>                 avic_init_vmcb(svm);
> > >>>>
> > >>>> @@ -2715,6 +2731,23 @@ static int mwait_interception(struct
> vcpu_svm
> > >>> *svm)
> > >>>>         return nop_interception(svm);
> > >>>>  }
> > >>>>
> > >>>> +static int invpcid_interception(struct vcpu_svm *svm)
> > >>>> +{
> > >>>> +       struct kvm_vcpu *vcpu = &svm->vcpu;
> > >>>> +       unsigned long type;
> > >>>> +       gva_t gva;
> > >>>> +
> > >>>> +       /*
> > >>>> +        * For an INVPCID intercept:
> > >>>> +        * EXITINFO1 provides the linear address of the memory operand.
> > >>>> +        * EXITINFO2 provides the contents of the register operand.
> > >>>> +        */
> > >>>> +       type = svm->vmcb->control.exit_info_2;
> > >>>> +       gva = svm->vmcb->control.exit_info_1;
> > >>>> +
> > >>>> +       return kvm_handle_invpcid_types(vcpu,  gva, type);
> > >>>> +}
> > >>>> +
> > >>>>  static int (*const svm_exit_handlers[])(struct vcpu_svm *svm) = {
> > >>>>         [SVM_EXIT_READ_CR0]                     = cr_interception,
> > >>>>         [SVM_EXIT_READ_CR3]                     = cr_interception,
> > >>>> @@ -2777,6 +2810,7 @@ static int (*const svm_exit_handlers[])(struct
> > >>> vcpu_svm *svm) = {
> > >>>>         [SVM_EXIT_MWAIT]                        = mwait_interception,
> > >>>>         [SVM_EXIT_XSETBV]                       = xsetbv_interception,
> > >>>>         [SVM_EXIT_RDPRU]                        = rdpru_interception,
> > >>>> +       [SVM_EXIT_INVPCID]                      = invpcid_interception,
> > >>>>         [SVM_EXIT_NPF]                          = npf_interception,
> > >>>>         [SVM_EXIT_RSM]                          = rsm_interception,
> > >>>>         [SVM_EXIT_AVIC_INCOMPLETE_IPI]          =
> > >>> avic_incomplete_ipi_interception,
> > >>>> @@ -3562,6 +3596,14 @@ static void svm_cpuid_update(struct
> kvm_vcpu
> > >>> *vcpu)
> > >>>>         svm->nrips_enabled = kvm_cpu_cap_has(X86_FEATURE_NRIPS) &&
> > >>>>                              guest_cpuid_has(&svm->vcpu, X86_FEATURE_NRIPS);
> > >>>>
> > >>>> +       /*
> > >>>> +        * Intercept INVPCID instruction if the baremetal has the support
> > >>>> +        * but the guest doesn't claim the feature.
> > >>>> +        */
> > >>>> +       if (boot_cpu_has(X86_FEATURE_INVPCID) &&
> > >>>> +           !guest_cpuid_has(vcpu, X86_FEATURE_INVPCID))
> > >>>> +               set_extended_intercept(svm, INTERCEPT_INVPCID);
> > >>>> +
> > >>>
> > >>> What if INVPCID is enabled in the guest CPUID later? Shouldn't we then
> > >>> clear this intercept bit?
> > >>
> > >> I assume the feature enable comes in the same code path as this. I can add
> > >> "if else" check here if that is what you are suggesting.
> > >
> > > Yes, that's what I'm suggesting.
> > >
> > >>>
> > >>>>         if (!kvm_vcpu_apicv_active(vcpu))
> > >>>>                 return;
> > >>>>
> > >>>>
