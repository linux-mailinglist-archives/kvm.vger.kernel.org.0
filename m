Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0875B1FCF90
	for <lists+kvm@lfdr.de>; Wed, 17 Jun 2020 16:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbgFQOas (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jun 2020 10:30:48 -0400
Received: from mail-dm6nam10on2056.outbound.protection.outlook.com ([40.107.93.56]:40737
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725901AbgFQOar (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Jun 2020 10:30:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cYtxc9f0NKattnVU3jUil85gA980iTzm0ghDCPERajRbDSXRzIhNVSyPOPBJmQGOFXnly2vfz60qVNIxZWXCwtbCLDP+GVjriynirZfo4M10NCXcCTfPaDtXx+nohlpsFccQ8QqWI5F6lkaXzwJ2yjY5f3Gfb1WGVOv7pvhh72aE6vKQMefKnRgTG6fV42cnUdBJz34OHV1PXrSXg20TANXdzE9F6uXKHS0k7TxVTePLyMzZ886wPme/sPNXg5Mi3n+yJVAP8xdfB/E6aHb4qkeNG7cnFolBxgOANyxvvO36qR5kE10rcO9qe5dMzbn4C/bdLjNE2/hZwnaocWVnVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PgLDw7KzRCOeZOYodbQS+4Ew1/MNQZnLHzidH9nSUpg=;
 b=IEatGP+71nWsEVvTciDl5WbrR5X1HrE4oq/voj9oojCfQV6Hap23eA0cYx7y49Xk/i7g2ggN8YLjx82C3So2f7ivOrNqTIdsTVxeTyQSxhGT+QCKvfaPUzBBUY+QWDEP6J9Huzp9J21pCEo0VIbH54VKvs1IFOWhv3ynrIkYXvWJLgrbl6ZJUPG/CC9ohcuetlaDiHioo+OyFLyVxz6DsyiMtlrnAU99LDJ7vi3AbVc323dXyAJEXE2XSlIbk9uBLa/p8VcseWp8ZiSeBJDBMZyydTkogHIhnL7bIJJX0jpGndfuYsFBJOMwwTBhIU6msoeW1mja5oN3X4pdu+t7YQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PgLDw7KzRCOeZOYodbQS+4Ew1/MNQZnLHzidH9nSUpg=;
 b=Xzl3ZnpsmRlr+qdceI9szvRvYNWObXWDw3IN8+uPYzoCRDy3WwhBOPtFy7WwmDKrVGa5WupnVseBQIPUn0/+pY7fgYM285imJs5aUyc6S6DSUxOTVl5loE7RJNSo1hpsc1wk3kxeLPa5YgG0o6EnwVH1L2hHS7A4F20lT9++cGM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SA0PR12MB4543.namprd12.prod.outlook.com (2603:10b6:806:9d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Wed, 17 Jun
 2020 14:30:43 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::2102:cc6b:b2db:4c2]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::2102:cc6b:b2db:4c2%3]) with mapi id 15.20.3088.029; Wed, 17 Jun 2020
 14:30:43 +0000
Subject: RE: [PATCH v2 2/3] KVM:SVM: Add extended intercept support
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
References: <159234483706.6230.13753828995249423191.stgit@bmoger-ubuntu>
 <159234502394.6230.5169466123693241678.stgit@bmoger-ubuntu>
 <CALMp9eTxs5nb9Ay0ELVa71cmA9VPzaMSuGgW_iM2tmAVvXs4Pg@mail.gmail.com>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <0b271987-3168-969d-5f96-ad99e31978fb@amd.com>
Date:   Wed, 17 Jun 2020 09:30:40 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <CALMp9eTxs5nb9Ay0ELVa71cmA9VPzaMSuGgW_iM2tmAVvXs4Pg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM5PR15CA0031.namprd15.prod.outlook.com
 (2603:10b6:4:4b::17) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.79] (165.204.77.1) by DM5PR15CA0031.namprd15.prod.outlook.com (2603:10b6:4:4b::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Wed, 17 Jun 2020 14:30:42 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2b4db9cc-3463-4cb4-1d74-08d812cb0415
X-MS-TrafficTypeDiagnostic: SA0PR12MB4543:
X-Microsoft-Antispam-PRVS: <SA0PR12MB4543224677E467ABCA77C7A5959A0@SA0PR12MB4543.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 04371797A5
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FBRawP/d7j5Igvvf1ZA0y3/40dqE8XYmbfypdFQKIuaFylrJECYrfxGZFy4wAwUTakpM11Qe+eUEojqDzLv/7ciMsQBuPjlhTC606KrZy3RNfvBXB6q7Ylzy/AggUAv9Ke4GIW0Ltg7wKWDAkfayamX823TvcF9XikVW5XkkqjnXpjoRj/D5/8uEh2gZHxfgdzxXauQPKVcSqapsdS7FwR/nB4lDZVutDoIMyr2zIghh3QnJDKNVSzbqDDlKK6ZTE/VLv/sVEckIbOgr2qTsyTiQLAckz5TiaWM9Cb7wustSoDu2mG5b8zWKu1Nm2FLhFwS/CYhnoQlKw0M8Zf9l01eSKkF3nEbZM1Q2oDzOENhHSIamc6bWwPoOad6VonI8ECn6LOBVZVPiWVhTlLGPu/FN8dDEbN0KfKN2G9pgOy4yhqEgfNoc8sAegorWpYir
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(366004)(39860400002)(376002)(136003)(5660300002)(53546011)(316002)(16576012)(7416002)(26005)(83380400001)(2906002)(478600001)(86362001)(2616005)(8936002)(36756003)(44832011)(31696002)(6486002)(8676002)(66946007)(45080400002)(52116002)(186003)(16526019)(4326008)(956004)(54906003)(66476007)(31686004)(966005)(6916009)(66556008)(83080400001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: U/WuMz1xKr17ceWMlczoqspnoAosZFJshUiS0dqeumZrSaXD1rhgGDOkHBZa4bfzTLmfv8jGmVhSdhQAgnUglG2LWluPMTqhMXRZ+biU8ypfqi/R9jCgaNpSrDCsIvESihhNldxWoiL8yz8wCjzxt/RW5z8Q2tNTv56WBCLfscOEGw3UcZDdMFLvDaYUgFQmLNpys9MB4be/nhptasKwBEuRzpiSU6las9X1UtnZ4YZigO+4d38RgCXyDKYaiidMqps5Q3+53Egtnqx7g6qZcYY9WD9TWmlSFWbfAKRnGAzI77DC/9lAftJKHWBv3N2MEetoTXM6CnnMzKCV/VI0UFMPfL7iRTxd+g4lVNPXtDzYxkwg0mY1iU9ucLNaYorUh30GeTWSEntDfPqPHlSL95SkHwtLogH+0njKWTkqGDtrIZzNrKUXXcdKRIL2K7EuuNn/vHnNtOK92X04ziqu9PY5ppGmnU1uT93/r/8DMFQ=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b4db9cc-3463-4cb4-1d74-08d812cb0415
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2020 14:30:43.7264
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cp2znEcXJlJWraZWagtcrIr7XvmJqkv2G05vyVqNLSaA7ojttj0Tqi50DXWUxwK6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4543
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Jim Mattson <jmattson@google.com>
> Sent: Tuesday, June 16, 2020 6:17 PM
> To: Moger, Babu <Babu.Moger@amd.com>
> Cc: Wanpeng Li <wanpengli@tencent.com>; Joerg Roedel <joro@8bytes.org>;
> the arch/x86 maintainers <x86@kernel.org>; Sean Christopherson
> <sean.j.christopherson@intel.com>; Ingo Molnar <mingo@redhat.com>;
> Borislav Petkov <bp@alien8.de>; H . Peter Anvin <hpa@zytor.com>; Paolo
> Bonzini <pbonzini@redhat.com>; Vitaly Kuznetsov <vkuznets@redhat.com>;
> Thomas Gleixner <tglx@linutronix.de>; LKML <linux-kernel@vger.kernel.org>;
> kvm list <kvm@vger.kernel.org>
> Subject: Re: [PATCH v2 2/3] KVM:SVM: Add extended intercept support
> 
> On Tue, Jun 16, 2020 at 3:03 PM Babu Moger <babu.moger@amd.com> wrote:
> >
> > The new intercept bits have been added in vmcb control
> > area to support the interception of INVPCID instruction.
> >
> > The following bit is added to the VMCB layout control area
> > to control intercept of INVPCID:
> >
> > Byte Offset     Bit(s)          Function
> > 14h             2               intercept INVPCID
> >
> > Add the interfaces to support these extended interception.
> > Also update the tracing for extended intercepts.
> >
> > AMD documentation for INVPCID feature is available at "AMD64
> > Architecture Programmer’s Manual Volume 2: System Programming,
> > Pub. 24593 Rev. 3.34(or later)"
> >
> > The documentation can be obtained at the links below:
> > Link:
> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fwww.a
> md.com%2Fsystem%2Ffiles%2FTechDocs%2F24593.pdf&amp;data=02%7C01%7
> Cbabu.moger%40amd.com%7C4cedcb3567194883601e08d8124b6be7%7C3dd8
> 961fe4884e608e11a82d994e183d%7C0%7C0%7C637279463210520563&amp;s
> data=oRQq0hj0O43A4lnl8JEb%2BHt8oCFHWxcqvLaA1%2BacTJc%3D&amp;reser
> ved=0
> > Link:
> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fbugzilla.
> kernel.org%2Fshow_bug.cgi%3Fid%3D206537&amp;data=02%7C01%7Cbabu.m
> oger%40amd.com%7C4cedcb3567194883601e08d8124b6be7%7C3dd8961fe48
> 84e608e11a82d994e183d%7C0%7C0%7C637279463210520563&amp;sdata=EtA
> rCUBB8etloN%2B%2Blx42RZqai12QFvtJefnxBn1ryMQ%3D&amp;reserved=0
> 
> Not your change, but this documentation is terrible. There is no
> INVLPCID instruction, nor is there a PCID instruction.

Sorry about that. I will bring this to their notice.

> 
> > Signed-off-by: Babu Moger <babu.moger@amd.com>
> > ---
> >  arch/x86/include/asm/svm.h |    3 ++-
> >  arch/x86/kvm/svm/nested.c  |    6 +++++-
> >  arch/x86/kvm/svm/svm.c     |    1 +
> >  arch/x86/kvm/svm/svm.h     |   18 ++++++++++++++++++
> >  arch/x86/kvm/trace.h       |   12 ++++++++----
> >  5 files changed, 34 insertions(+), 6 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> > index 8a1f5382a4ea..62649fba8908 100644
> > --- a/arch/x86/include/asm/svm.h
> > +++ b/arch/x86/include/asm/svm.h
> > @@ -61,7 +61,8 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
> >         u32 intercept_dr;
> >         u32 intercept_exceptions;
> >         u64 intercept;
> > -       u8 reserved_1[40];
> > +       u32 intercept_extended;
> > +       u8 reserved_1[36];
> 
> It seems like a more straightforward implementation would simply
> change 'u64 intercept' to 'u32 intercept[3].'

Sure. Will change it.

> 
> >         u16 pause_filter_thresh;
> >         u16 pause_filter_count;
> >         u64 iopm_base_pa;
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index 8a6db11dcb43..7f6d0f2533e2 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -121,6 +121,7 @@ void recalc_intercepts(struct vcpu_svm *svm)
> >         c->intercept_dr = h->intercept_dr;
> >         c->intercept_exceptions = h->intercept_exceptions;
> >         c->intercept = h->intercept;
> > +       c->intercept_extended = h->intercept_extended;
> >
> >         if (g->int_ctl & V_INTR_MASKING_MASK) {
> >                 /* We only want the cr8 intercept bits of L1 */
> > @@ -142,6 +143,7 @@ void recalc_intercepts(struct vcpu_svm *svm)
> >         c->intercept_dr |= g->intercept_dr;
> >         c->intercept_exceptions |= g->intercept_exceptions;
> >         c->intercept |= g->intercept;
> > +       c->intercept_extended |= g->intercept_extended;
> >  }
> >
> >  static void copy_vmcb_control_area(struct vmcb_control_area *dst,
> > @@ -151,6 +153,7 @@ static void copy_vmcb_control_area(struct
> vmcb_control_area *dst,
> >         dst->intercept_dr         = from->intercept_dr;
> >         dst->intercept_exceptions = from->intercept_exceptions;
> >         dst->intercept            = from->intercept;
> > +       dst->intercept_extended   = from->intercept_extended;
> >         dst->iopm_base_pa         = from->iopm_base_pa;
> >         dst->msrpm_base_pa        = from->msrpm_base_pa;
> >         dst->tsc_offset           = from->tsc_offset;
> > @@ -433,7 +436,8 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
> >         trace_kvm_nested_intercepts(nested_vmcb->control.intercept_cr &
> 0xffff,
> >                                     nested_vmcb->control.intercept_cr >> 16,
> >                                     nested_vmcb->control.intercept_exceptions,
> > -                                   nested_vmcb->control.intercept);
> > +                                   nested_vmcb->control.intercept,
> > +                                   nested_vmcb->control.intercept_extended);
> >
> >         /* Clear internal status */
> >         kvm_clear_exception_queue(&svm->vcpu);
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 9e333b91ff78..285e5e1ff518 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -2801,6 +2801,7 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
> >         pr_err("%-20s%04x\n", "dr_write:", control->intercept_dr >> 16);
> >         pr_err("%-20s%08x\n", "exceptions:", control->intercept_exceptions);
> >         pr_err("%-20s%016llx\n", "intercepts:", control->intercept);
> > +       pr_err("%-20s%08x\n", "intercepts (extended):", control-
> >intercept_extended);
> >         pr_err("%-20s%d\n", "pause filter count:", control->pause_filter_count);
> >         pr_err("%-20s%d\n", "pause filter threshold:",
> >                control->pause_filter_thresh);
> > diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> > index 6ac4c00a5d82..935d08fac03d 100644
> > --- a/arch/x86/kvm/svm/svm.h
> > +++ b/arch/x86/kvm/svm/svm.h
> > @@ -311,6 +311,24 @@ static inline void clr_intercept(struct vcpu_svm *svm,
> int bit)
> >         recalc_intercepts(svm);
> >  }
> >
> > +static inline void set_extended_intercept(struct vcpu_svm *svm, int bit)
> > +{
> > +       struct vmcb *vmcb = get_host_vmcb(svm);
> > +
> > +       vmcb->control.intercept_extended |= (1U << bit);
> > +
> > +       recalc_intercepts(svm);
> > +}
> > +
> > +static inline void clr_extended_intercept(struct vcpu_svm *svm, int bit)
> > +{
> > +       struct vmcb *vmcb = get_host_vmcb(svm);
> > +
> > +       vmcb->control.intercept_extended &= ~(1U << bit);
> > +
> > +       recalc_intercepts(svm);
> > +}
> 
> You wouldn't need these new functions if you defined 'u32
> intercept[3],' as I suggested above. Just change set_intercept and
> clr_intercept to use __set_bit and __clear_bit.

Yes. Will change it. Thanks

> 
> >  static inline bool is_intercept(struct vcpu_svm *svm, int bit)
> >  {
> >         return (svm->vmcb->control.intercept & (1ULL << bit)) != 0;
> > diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> > index b66432b015d2..5c841c42b33d 100644
> > --- a/arch/x86/kvm/trace.h
> > +++ b/arch/x86/kvm/trace.h
> > @@ -544,14 +544,16 @@ TRACE_EVENT(kvm_nested_vmrun,
> >  );
> >
> >  TRACE_EVENT(kvm_nested_intercepts,
> > -           TP_PROTO(__u16 cr_read, __u16 cr_write, __u32 exceptions, __u64
> intercept),
> > -           TP_ARGS(cr_read, cr_write, exceptions, intercept),
> > +           TP_PROTO(__u16 cr_read, __u16 cr_write, __u32 exceptions, __u64
> intercept,
> > +                    __u32 extended),
> > +           TP_ARGS(cr_read, cr_write, exceptions, intercept, extended),
> >
> >         TP_STRUCT__entry(
> >                 __field(        __u16,          cr_read         )
> >                 __field(        __u16,          cr_write        )
> >                 __field(        __u32,          exceptions      )
> >                 __field(        __u64,          intercept       )
> > +               __field(        __u32,          extended        )
> >         ),
> >
> >         TP_fast_assign(
> > @@ -559,11 +561,13 @@ TRACE_EVENT(kvm_nested_intercepts,
> >                 __entry->cr_write       = cr_write;
> >                 __entry->exceptions     = exceptions;
> >                 __entry->intercept      = intercept;
> > +               __entry->extended       = extended;
> >         ),
> >
> > -       TP_printk("cr_read: %04x cr_write: %04x excp: %08x intercept: %016llx",
> > +       TP_printk("cr_read: %04x cr_write: %04x excp: %08x intercept: %016llx"
> > +                 "intercept (extended): %08x",
> >                 __entry->cr_read, __entry->cr_write, __entry->exceptions,
> > -               __entry->intercept)
> > +               __entry->intercept, __entry->extended)
> >  );
> >  /*
> >   * Tracepoint for #VMEXIT while nested
> >
