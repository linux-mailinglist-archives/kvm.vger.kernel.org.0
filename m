Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4B81FD427
	for <lists+kvm@lfdr.de>; Wed, 17 Jun 2020 20:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbgFQSL7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jun 2020 14:11:59 -0400
Received: from mail-mw2nam12on2061.outbound.protection.outlook.com ([40.107.244.61]:7259
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726995AbgFQSL7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Jun 2020 14:11:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YnJ6Yo6DS7Iqay4V3N6fxaE2GyPLBiDeGNVdpjcKR6hXk73Y70kNfa1boqT4pmpmmVqEq8bBlViL9d23i8yxmCk6frMho3Hio5wwrnFPSTMK7Myx6aISoDPFQkeAVwmw9m03KFGw//Ud250n8ZhVdNxfuqxeSjMZxgVWDfmxyJylRZAHiJt8PPZhaLHBXIkUebLDBoTN3VNgIIlV2oDeYp9NPp0ogH3ik06NrjuQLHv6Hw+t9SIB5s28w/3oeoGCEKQHlRPtDKXP3eRKGQTzA8P1W95Lx62SWVQ4HT4aipbj/vCcxqHoFjt7Lj/Z73pEwsuWhX/KERzJB5wOFaZ58g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y51ebAxWFQQtKRTi90V/DoXa8WXrxpjafY8IEVhLcyU=;
 b=CTWGRvd8uxmBknNnune91n/X6L5IPYaEuyxw1m/StgDSXXI/M8hpe5vsFNZ4spcsJUZ+unCluVQxyD/uXVuLUNZY+WrQ/6AmQhjOU1d5P1pRoierRHlxjNXfZEtNb8UB4wdjqC+uo6BfyHE7CsxEo38LkULrLthFKUxcBjxHRSguqaciWIpj9OLzkdBZbVtdkAUF15GYrBZu8UMMbSNMt15gM/gv7k0QgKqq1eDpJT4jBwjV/FH6bcwev1AmsRmO9Z1dKYCVMBx0UO5h+q+X5ufxJqGQfgIelfgR3koieZluh20YOLifu0y/DzyE0moAAFCqXMjpy4Q0ctOtGhKWXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y51ebAxWFQQtKRTi90V/DoXa8WXrxpjafY8IEVhLcyU=;
 b=SjjnjzL+TFuYto9tVfmzp/STG/aon0STzWovuSG+6C0IiU54yBWCVsV7sr5IL1wslyBv//TeveD79MvficKoR0zPk6yK1vav4ts0TrqFsjvDHm9DaytMXVVG+cAh115gABnmGTesE6iciF95KNIi/OlApTRylZyGbZirzSw/Z7k=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2527.namprd12.prod.outlook.com (2603:10b6:802:23::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.24; Wed, 17 Jun
 2020 18:11:54 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::2102:cc6b:b2db:4c2]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::2102:cc6b:b2db:4c2%3]) with mapi id 15.20.3088.029; Wed, 17 Jun 2020
 18:11:54 +0000
Subject: RE: [PATCH v2 2/3] KVM:SVM: Add extended intercept support
To:     Babu Moger <babu.moger@amd.com>, Jim Mattson <jmattson@google.com>
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
 <0b271987-3168-969d-5f96-ad99e31978fb@amd.com>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <9063259c-d87e-4c6e-11d0-d561a1a88989@amd.com>
Date:   Wed, 17 Jun 2020 13:11:52 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <0b271987-3168-969d-5f96-ad99e31978fb@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0501CA0056.namprd05.prod.outlook.com
 (2603:10b6:803:41::33) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.79] (165.204.77.1) by SN4PR0501CA0056.namprd05.prod.outlook.com (2603:10b6:803:41::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.10 via Frontend Transport; Wed, 17 Jun 2020 18:11:53 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c0aea5f1-95fc-49d4-2dd8-08d812e9ea59
X-MS-TrafficTypeDiagnostic: SN1PR12MB2527:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2527924299DAA9697CAE6038959A0@SN1PR12MB2527.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-Forefront-PRVS: 04371797A5
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 33c5SlLNsPiUm8IzLgd9a8XCuZo8H/NoHVY3IvDCNW+w3FGXq0G7NPdwPnQdXeg1/87FE4tCWTLGhwhw1kyFnv958vFdFajjl6uCit+Utv62kDmmOWi0xEjZciqHJE01kaFM6iWqhbaxt/EjE2SH9/XTwPWq8vqxPKRR5uD2Vxx65ciZQdgg+ugKBZT87tTMDuAEYVs019nSsYnqxTOr6Ew+VtDuJlAI/pJGcSVMBrtQ74apciV5/wPYKb8s6EPuMo0YncvqsCO5ymMOgVjrUL6mWUyJ7EnHanHOlb/QzeWR/13k+7jbEX5kIH2eFW4pwkdksgdyzwvVdRMTMNblazak/IFr2AYnX1wu8PCrCBsd4KuVWSuQSt2Ast/ZBoVb8BRg3PHyW7yF34VWvdc/Y9cbwGPDO3j9JvQXvrjrar1TBnDtWoJaDxBYS+QHucBK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(39860400002)(346002)(376002)(396003)(26005)(186003)(16526019)(956004)(4326008)(8936002)(6486002)(8676002)(2616005)(30864003)(52116002)(2906002)(53546011)(44832011)(31696002)(83380400001)(316002)(66946007)(7416002)(66556008)(31686004)(45080400002)(83080400001)(54906003)(110136005)(966005)(86362001)(16576012)(478600001)(5660300002)(36756003)(66476007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ztSVA1K1XFyscN3ViYHbn0ngflhonJafHu7H7UE8yzVmN3JSkRXvw0ryV8pH5Q3U9W6WXkpVQADdLrNK1yGxzbBNezHx+GjuJJSWQ8bGcy0zbHww5F/lWpyL50M9/cSPW+Ig+cxpj4YMoT8/X1ASYY9PBdczilNoD+OdutdgAI/Zl8NmBN09G666PzE5awR8Hma5abhw/gDMY8p3tc3v6jDBn5wyKhHTKwjrfZxko4d4DmmCAkedpqJbdYUh3U/zBx/YMUazVCC8AIV28EysNaPLsyJbTBzm89XTOoOBN3FNxCiRnEsgNUaiAa90K2ebPq5FpMAQdlB+v9c6f9bjFLTwOW7EBYuIwybhqOlHy1ERTlAWIpdYqt4bZ2lq/Yzi0/T4e9gZKSx4msT0vyWSwxZ04p4hvreDbezE6bhK1NOFQJHIN3gzJuZVpu6H42aW2feIcQg//yNn0HixBEyeYQq9jV7hl+M7PGA7Gk1UjOs=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0aea5f1-95fc-49d4-2dd8-08d812e9ea59
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2020 18:11:54.6994
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qod5SlmRe34kiiG65zcOMHmghApcU7BnmU/y8wfcdUntx+QQdf3T48ZRkdDyqs4i
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2527
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jim,

> -----Original Message-----
> From: kvm-owner@vger.kernel.org <kvm-owner@vger.kernel.org> On Behalf
> Of Babu Moger
> Sent: Wednesday, June 17, 2020 9:31 AM
> To: Jim Mattson <jmattson@google.com>
> Cc: Wanpeng Li <wanpengli@tencent.com>; Joerg Roedel <joro@8bytes.org>;
> the arch/x86 maintainers <x86@kernel.org>; Sean Christopherson
> <sean.j.christopherson@intel.com>; Ingo Molnar <mingo@redhat.com>;
> Borislav Petkov <bp@alien8.de>; H . Peter Anvin <hpa@zytor.com>; Paolo
> Bonzini <pbonzini@redhat.com>; Vitaly Kuznetsov <vkuznets@redhat.com>;
> Thomas Gleixner <tglx@linutronix.de>; LKML <linux-kernel@vger.kernel.org>;
> kvm list <kvm@vger.kernel.org>
> Subject: RE: [PATCH v2 2/3] KVM:SVM: Add extended intercept support
> 
> 
> 
> > -----Original Message-----
> > From: Jim Mattson <jmattson@google.com>
> > Sent: Tuesday, June 16, 2020 6:17 PM
> > To: Moger, Babu <Babu.Moger@amd.com>
> > Cc: Wanpeng Li <wanpengli@tencent.com>; Joerg Roedel <joro@8bytes.org>;
> > the arch/x86 maintainers <x86@kernel.org>; Sean Christopherson
> > <sean.j.christopherson@intel.com>; Ingo Molnar <mingo@redhat.com>;
> > Borislav Petkov <bp@alien8.de>; H . Peter Anvin <hpa@zytor.com>; Paolo
> > Bonzini <pbonzini@redhat.com>; Vitaly Kuznetsov <vkuznets@redhat.com>;
> > Thomas Gleixner <tglx@linutronix.de>; LKML <linux-kernel@vger.kernel.org>;
> > kvm list <kvm@vger.kernel.org>
> > Subject: Re: [PATCH v2 2/3] KVM:SVM: Add extended intercept support
> >
> > On Tue, Jun 16, 2020 at 3:03 PM Babu Moger <babu.moger@amd.com>
> wrote:
> > >
> > > The new intercept bits have been added in vmcb control
> > > area to support the interception of INVPCID instruction.
> > >
> > > The following bit is added to the VMCB layout control area
> > > to control intercept of INVPCID:
> > >
> > > Byte Offset     Bit(s)          Function
> > > 14h             2               intercept INVPCID
> > >
> > > Add the interfaces to support these extended interception.
> > > Also update the tracing for extended intercepts.
> > >
> > > AMD documentation for INVPCID feature is available at "AMD64
> > > Architecture Programmer’s Manual Volume 2: System Programming,
> > > Pub. 24593 Rev. 3.34(or later)"
> > >
> > > The documentation can be obtained at the links below:
> > > Link:
> >
> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fwww.a
> >
> md.com%2Fsystem%2Ffiles%2FTechDocs%2F24593.pdf&amp;data=02%7C01%7
> >
> Cbabu.moger%40amd.com%7C4cedcb3567194883601e08d8124b6be7%7C3dd8
> >
> 961fe4884e608e11a82d994e183d%7C0%7C0%7C637279463210520563&amp;s
> >
> data=oRQq0hj0O43A4lnl8JEb%2BHt8oCFHWxcqvLaA1%2BacTJc%3D&amp;reser
> > ved=0
> > > Link:
> >
> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fbugzilla.
> >
> kernel.org%2Fshow_bug.cgi%3Fid%3D206537&amp;data=02%7C01%7Cbabu.m
> >
> oger%40amd.com%7C4cedcb3567194883601e08d8124b6be7%7C3dd8961fe48
> >
> 84e608e11a82d994e183d%7C0%7C0%7C637279463210520563&amp;sdata=EtA
> > rCUBB8etloN%2B%2Blx42RZqai12QFvtJefnxBn1ryMQ%3D&amp;reserved=0
> >
> > Not your change, but this documentation is terrible. There is no
> > INVLPCID instruction, nor is there a PCID instruction.
> 
> Sorry about that. I will bring this to their notice.
> 
> >
> > > Signed-off-by: Babu Moger <babu.moger@amd.com>
> > > ---
> > >  arch/x86/include/asm/svm.h |    3 ++-
> > >  arch/x86/kvm/svm/nested.c  |    6 +++++-
> > >  arch/x86/kvm/svm/svm.c     |    1 +
> > >  arch/x86/kvm/svm/svm.h     |   18 ++++++++++++++++++
> > >  arch/x86/kvm/trace.h       |   12 ++++++++----
> > >  5 files changed, 34 insertions(+), 6 deletions(-)
> > >
> > > diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> > > index 8a1f5382a4ea..62649fba8908 100644
> > > --- a/arch/x86/include/asm/svm.h
> > > +++ b/arch/x86/include/asm/svm.h
> > > @@ -61,7 +61,8 @@ struct __attribute__ ((__packed__))
> vmcb_control_area {
> > >         u32 intercept_dr;
> > >         u32 intercept_exceptions;
> > >         u64 intercept;
> > > -       u8 reserved_1[40];
> > > +       u32 intercept_extended;
> > > +       u8 reserved_1[36];
> >
> > It seems like a more straightforward implementation would simply
> > change 'u64 intercept' to 'u32 intercept[3].'
> 
> Sure. Will change it.

This involves much more changes than I originally thought.  All these
following code needs to be modified. Here is my cscope output for the C
symbol intercept.

0 nested.c recalc_intercepts                123 c->intercept = h->intercept;
1 nested.c recalc_intercepts                135 c->intercept &= ~(1ULL <<
INTERCEPT_VINTR);
2 nested.c recalc_intercepts                139 c->intercept &= ~(1ULL <<
INTERCEPT_VMMCALL);
3 nested.c recalc_intercepts                144 c->intercept |= g->intercept;
4 nested.c copy_vmcb_control_area           153 dst->intercept =
from->intercept;
5 nested.c nested_svm_vmrun_msrpm           186 if
(!(svm->nested.ctl.intercept & (1ULL << INTERCEPT_MSR_PROT)))
6 nested.c nested_vmcb_check_controls 212 if ((control->intercept & (1ULL
<< INTERCEPT_VMRUN)) == 0)NIT));
7 nested.c nested_svm_vmrun                 436
nested_vmcb->control.intercept);
8 nested.c nested_svm_exit_handled_msr      648 if
(!(svm->nested.ctl.intercept & (1ULL << INTERCEPT_MSR_PROT)))
9 nested.c nested_svm_intercept_ioio        675 if
(!(svm->nested.ctl.intercept & (1ULL << INTERCEPT_IOIO_PROT)))
a nested.c nested_svm_intercept             732 if
(svm->nested.ctl.intercept & exit_bits)
b nested.c nested_exit_on_init              840 return
(svm->nested.ctl.intercept & (1ULL << INTERCEPT_INIT));
c svm.c    check_selective_cr0_intercepted 2205 u64 intercept;
d svm.c    check_selective_cr0_intercepted 2207 intercept =
svm->nested.ctl.intercept;
e svm.c    check_selective_cr0_intercepted 2210 (!(intercept & (1ULL <<
INTERCEPT_SELECTIVE_CR0))))
f svm.c    dump_vmcb                       2803 pr_err("%-20s%016llx\n",
"intercepts:", control->intercept);
m svm.c    svm_check_intercept             3687 intercept =
svm->nested.ctl.intercept;
n svm.c    svm_check_intercept             3689 if (!(intercept & (1ULL <<
INTERCEPT_SELECTIVE_CR0)))
6 svm.c    svm_apic_init_signal_blocked    3948
(svm->vmcb->control.intercept & (1ULL << INTERCEPT_INIT));
7 svm.h    set_intercept                    300 vmcb->control.intercept |=
(1ULL << bit);
8 svm.h    clr_intercept                    309 vmcb->control.intercept &=
~(1ULL << bit);
9 svm.h    is_intercept tercept_ioio        316 return
(svm->vmcb->control.intercept & (1ULL << bit)) != 0;
a svm.h    nested_exit_on_smi               377 return
(svm->nested.ctl.intercept & (1ULL << INTERCEPT_SMI));
b svm.h    nested_exit_on_intr              382 return
(svm->nested.ctl.intercept & (1ULL << INTERCEPT_INTR));
c svm.h    nested_exit_on_nmi               387 return
(svm->nested.ctl.intercept & (1ULL << INTERCEPT_NMI));

I will have to test extensively if I go ahead with these changes.  What do
you think?

> 
> >
> > >         u16 pause_filter_thresh;
> > >         u16 pause_filter_count;
> > >         u64 iopm_base_pa;
> > > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > > index 8a6db11dcb43..7f6d0f2533e2 100644
> > > --- a/arch/x86/kvm/svm/nested.c
> > > +++ b/arch/x86/kvm/svm/nested.c
> > > @@ -121,6 +121,7 @@ void recalc_intercepts(struct vcpu_svm *svm)
> > >         c->intercept_dr = h->intercept_dr;
> > >         c->intercept_exceptions = h->intercept_exceptions;
> > >         c->intercept = h->intercept;
> > > +       c->intercept_extended = h->intercept_extended;
> > >
> > >         if (g->int_ctl & V_INTR_MASKING_MASK) {
> > >                 /* We only want the cr8 intercept bits of L1 */
> > > @@ -142,6 +143,7 @@ void recalc_intercepts(struct vcpu_svm *svm)
> > >         c->intercept_dr |= g->intercept_dr;
> > >         c->intercept_exceptions |= g->intercept_exceptions;
> > >         c->intercept |= g->intercept;
> > > +       c->intercept_extended |= g->intercept_extended;
> > >  }
> > >
> > >  static void copy_vmcb_control_area(struct vmcb_control_area *dst,
> > > @@ -151,6 +153,7 @@ static void copy_vmcb_control_area(struct
> > vmcb_control_area *dst,
> > >         dst->intercept_dr         = from->intercept_dr;
> > >         dst->intercept_exceptions = from->intercept_exceptions;
> > >         dst->intercept            = from->intercept;
> > > +       dst->intercept_extended   = from->intercept_extended;
> > >         dst->iopm_base_pa         = from->iopm_base_pa;
> > >         dst->msrpm_base_pa        = from->msrpm_base_pa;
> > >         dst->tsc_offset           = from->tsc_offset;
> > > @@ -433,7 +436,8 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
> > >         trace_kvm_nested_intercepts(nested_vmcb->control.intercept_cr &
> > 0xffff,
> > >                                     nested_vmcb->control.intercept_cr >> 16,
> > >                                     nested_vmcb->control.intercept_exceptions,
> > > -                                   nested_vmcb->control.intercept);
> > > +                                   nested_vmcb->control.intercept,
> > > +                                   nested_vmcb->control.intercept_extended);
> > >
> > >         /* Clear internal status */
> > >         kvm_clear_exception_queue(&svm->vcpu);
> > > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > > index 9e333b91ff78..285e5e1ff518 100644
> > > --- a/arch/x86/kvm/svm/svm.c
> > > +++ b/arch/x86/kvm/svm/svm.c
> > > @@ -2801,6 +2801,7 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
> > >         pr_err("%-20s%04x\n", "dr_write:", control->intercept_dr >> 16);
> > >         pr_err("%-20s%08x\n", "exceptions:", control->intercept_exceptions);
> > >         pr_err("%-20s%016llx\n", "intercepts:", control->intercept);
> > > +       pr_err("%-20s%08x\n", "intercepts (extended):", control-
> > >intercept_extended);
> > >         pr_err("%-20s%d\n", "pause filter count:", control->pause_filter_count);
> > >         pr_err("%-20s%d\n", "pause filter threshold:",
> > >                control->pause_filter_thresh);
> > > diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> > > index 6ac4c00a5d82..935d08fac03d 100644
> > > --- a/arch/x86/kvm/svm/svm.h
> > > +++ b/arch/x86/kvm/svm/svm.h
> > > @@ -311,6 +311,24 @@ static inline void clr_intercept(struct vcpu_svm
> *svm,
> > int bit)
> > >         recalc_intercepts(svm);
> > >  }
> > >
> > > +static inline void set_extended_intercept(struct vcpu_svm *svm, int bit)
> > > +{
> > > +       struct vmcb *vmcb = get_host_vmcb(svm);
> > > +
> > > +       vmcb->control.intercept_extended |= (1U << bit);
> > > +
> > > +       recalc_intercepts(svm);
> > > +}
> > > +
> > > +static inline void clr_extended_intercept(struct vcpu_svm *svm, int bit)
> > > +{
> > > +       struct vmcb *vmcb = get_host_vmcb(svm);
> > > +
> > > +       vmcb->control.intercept_extended &= ~(1U << bit);
> > > +
> > > +       recalc_intercepts(svm);
> > > +}
> >
> > You wouldn't need these new functions if you defined 'u32
> > intercept[3],' as I suggested above. Just change set_intercept and
> > clr_intercept to use __set_bit and __clear_bit.
> 
> Yes. Will change it. Thanks
> 
> >
> > >  static inline bool is_intercept(struct vcpu_svm *svm, int bit)
> > >  {
> > >         return (svm->vmcb->control.intercept & (1ULL << bit)) != 0;
> > > diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> > > index b66432b015d2..5c841c42b33d 100644
> > > --- a/arch/x86/kvm/trace.h
> > > +++ b/arch/x86/kvm/trace.h
> > > @@ -544,14 +544,16 @@ TRACE_EVENT(kvm_nested_vmrun,
> > >  );
> > >
> > >  TRACE_EVENT(kvm_nested_intercepts,
> > > -           TP_PROTO(__u16 cr_read, __u16 cr_write, __u32 exceptions, __u64
> > intercept),
> > > -           TP_ARGS(cr_read, cr_write, exceptions, intercept),
> > > +           TP_PROTO(__u16 cr_read, __u16 cr_write, __u32 exceptions, __u64
> > intercept,
> > > +                    __u32 extended),
> > > +           TP_ARGS(cr_read, cr_write, exceptions, intercept, extended),
> > >
> > >         TP_STRUCT__entry(
> > >                 __field(        __u16,          cr_read         )
> > >                 __field(        __u16,          cr_write        )
> > >                 __field(        __u32,          exceptions      )
> > >                 __field(        __u64,          intercept       )
> > > +               __field(        __u32,          extended        )
> > >         ),
> > >
> > >         TP_fast_assign(
> > > @@ -559,11 +561,13 @@ TRACE_EVENT(kvm_nested_intercepts,
> > >                 __entry->cr_write       = cr_write;
> > >                 __entry->exceptions     = exceptions;
> > >                 __entry->intercept      = intercept;
> > > +               __entry->extended       = extended;
> > >         ),
> > >
> > > -       TP_printk("cr_read: %04x cr_write: %04x excp: %08x intercept:
> %016llx",
> > > +       TP_printk("cr_read: %04x cr_write: %04x excp: %08x intercept:
> %016llx"
> > > +                 "intercept (extended): %08x",
> > >                 __entry->cr_read, __entry->cr_write, __entry->exceptions,
> > > -               __entry->intercept)
> > > +               __entry->intercept, __entry->extended)
> > >  );
> > >  /*
> > >   * Tracepoint for #VMEXIT while nested
> > >
