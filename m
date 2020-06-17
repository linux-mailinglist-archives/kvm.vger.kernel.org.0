Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48BDC1FD7BB
	for <lists+kvm@lfdr.de>; Wed, 17 Jun 2020 23:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbgFQVmp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jun 2020 17:42:45 -0400
Received: from mail-dm6nam10on2083.outbound.protection.outlook.com ([40.107.93.83]:46368
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726763AbgFQVmm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Jun 2020 17:42:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YCugnLUXFinkg4BqnHEOtWfXEUDGmCKiDpOuGepU38h/7eezbA9BD9n4DV3pzYO81l6B58GuQp31h8PZ0SZk0hIRkjcK97YYz2hcC9hiHGIqIANQYW/Y59D6F2PGvRhSt2R66rHPoj3LXL9o302AcOGPNOcYF01i/0f1fmkLQXfDTxbSeDS7s7Gi3ot0MjLIRr1i0xYoOPWjtJxUVI1tztzwHj+vZNNnSKpE7RlLUzrEnKjvGkEk+/KPqYp9i9Smc/U14Df+Agzq9vr40dZJluQhiXUa//My2cEXrsIBDtKqbMfe0UfgEz9OFBCj2HM5jivlmmEeGMKfK1s0snJdAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=53Gi+qMw6r4jVnHC9iPBGRgrce9/uykMf5cppnf7lkk=;
 b=BR/Q1TAPhxg85euwdgS/rMYf+u4UFV0poN6lYtAI+xDaViP/l4noo4Jd1NS06KxO57J6fMz06SxEAsZPa3EUB2NZFuKG57PtiiW3SqD+rfk3xQYZoUzhsgSgy8smX0oYtd1FK2KsUVWf26AaTJVDcVVYhMwRiBLp3E+Z1Ra7xn0mgHEPIje5Qx9n/j0QWVlFXyyI+VhbcyCJQ3km31dKa8LqumWCFcJI0XckkxcAU4wfZdFlVBaB1pRZ8ewCatmEgkE0qfJyIVzOJG9B8lrJeOhz4NE/RBPy0F5RVdbDLCTll0NR3WgN0uLy2HrSmojzqxtPqEakfS58ai1z6aaXBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=53Gi+qMw6r4jVnHC9iPBGRgrce9/uykMf5cppnf7lkk=;
 b=LvheStAlAxSy0wwvKFFRx9u4MlWCTSkPoSodQ/g8LSL8ngbyqeas7/VDcyVFL5twC8rNS7mGba8tEo3ahvxmN/hu53IS70uH0nuGSSsbBhTT2qDT0qKXvpoQUZbz/ChQ1kNQTHz2MBbyrDdAqCFJvpeK5fnUuwO5rb0A6ohcE2w=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2384.namprd12.prod.outlook.com (2603:10b6:802:25::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.23; Wed, 17 Jun
 2020 21:42:38 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::2102:cc6b:b2db:4c2]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::2102:cc6b:b2db:4c2%3]) with mapi id 15.20.3088.029; Wed, 17 Jun 2020
 21:42:38 +0000
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
 <0b271987-3168-969d-5f96-ad99e31978fb@amd.com>
 <9063259c-d87e-4c6e-11d0-d561a1a88989@amd.com>
 <CALMp9eRdHNKnXh3h6+GzYKaS1gOoZ0DeZxB75foo+Oz_hDw=qg@mail.gmail.com>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <81351099-b1f2-0ad5-1a0c-3d7b18bbb115@amd.com>
Date:   Wed, 17 Jun 2020 16:42:36 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <CALMp9eRdHNKnXh3h6+GzYKaS1gOoZ0DeZxB75foo+Oz_hDw=qg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0501CA0072.namprd05.prod.outlook.com
 (2603:10b6:803:41::49) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.79] (165.204.77.1) by SN4PR0501CA0072.namprd05.prod.outlook.com (2603:10b6:803:41::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.10 via Frontend Transport; Wed, 17 Jun 2020 21:42:37 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 39f5c7ab-833e-433b-d53d-08d813075ab1
X-MS-TrafficTypeDiagnostic: SN1PR12MB2384:
X-Microsoft-Antispam-PRVS: <SN1PR12MB2384813B75B7A86BB49819F0959A0@SN1PR12MB2384.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-Forefront-PRVS: 04371797A5
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8HDEME3e0XOLJPyD1RDzRV/K8viLv1f6mr7CMGbNgRW4vDuf5S3qMhzjtVItmBvMm12IfPhijBDDAsUfyHk/mI0rbszLQ1qA0LqbAXah9m3n5tN78mHyA0iGmi/oi/nLRjnhCqVx+7iJTXdZIh8b07EAsAI4KdgCSAgePavIHMBuuCUUejEgGkSj4+vX0/PqbvbEfPpjtBvqmmBN7pZX4T+d2G4x+L/WPhspcQ4RHXkL5V1bP10OhcUP5UhgDGFtpthW9S9Fu75EpFPw3ScbeL8ZjAm08xodY8TJvMH3Cy7QO8UKOhq1JzchuuYJv6BjNOihuJWKkLGNJWmJo/M3tBAsX3NQ9tcbgb24SkDf3VfpmGnfZwBnQ3+H/mQj0TLn04eZDtDhmaVEox4a/Bvalx/7s1jjfI7uMyaGBN8Ns7nVe4BnNKQ9nPmzedF8U4HEt062xhunHvfec0yAc6IQ0Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(366004)(39860400002)(136003)(396003)(83380400001)(5660300002)(478600001)(45080400002)(186003)(2906002)(16526019)(966005)(83080400001)(4326008)(26005)(6486002)(66946007)(52116002)(31686004)(53546011)(44832011)(8676002)(36756003)(956004)(7416002)(6916009)(54906003)(86362001)(2616005)(66556008)(66476007)(8936002)(31696002)(16576012)(316002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: mjfR1971nLK1fMG43RUAdYsGlukoEEKB/oyz1yE6zje+NliaHqxZSE0WdTy705L2u96ICfIhkGbHIYuV+HWq3oAKkELLkg4gZd/xKM9yN4xZDBMKIyrGfglXTn+o2pgLa3p0skrS0yZMpXrdJq+lIgUlQI02wOzkGN/tFEeQ1/uxSOrGvUIuVybMvIbJZzk/cwRNrARQQtfHl1wwiHkCPmUWFREIkbf3S+pEjQrq7mCtL6wLI/u5SyA2RcaQrZUlw0evw7Z7Q9sZZ3TmPM0k0x3VktL6NjIDq98mwH8ZUYePVi5DO9m0lyypRFY7xuGyfD033I4paoEg/UvB330AyK0tgX86RF/8oKbMF6+T6QH7IxTCLJ/6JHKxIOCxPIa9hxAdDln7dXLG+xZXNZTJ1k7mgG9UPF1rffLOswi0iFVjNm5ByzOhDl4Gyl0oLZxpj9+T2G+D+xpJ5fgga6gqt7+UyhE3y22jPdnkUM0/fSo=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39f5c7ab-833e-433b-d53d-08d813075ab1
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2020 21:42:38.1547
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HjbKCuY0VfWAvgULXJQua/9B4nHaPNFNsqtmNUnc7lLda01YA/jgFyXsIyhMMTvc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2384
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Jim Mattson <jmattson@google.com>
> Sent: Wednesday, June 17, 2020 3:45 PM
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
> On Wed, Jun 17, 2020 at 11:11 AM Babu Moger <babu.moger@amd.com>
> wrote:
> >
> > Jim,
> >
> > > -----Original Message-----
> > > From: kvm-owner@vger.kernel.org <kvm-owner@vger.kernel.org> On
> Behalf
> > > Of Babu Moger
> > > Sent: Wednesday, June 17, 2020 9:31 AM
> > > To: Jim Mattson <jmattson@google.com>
> > > Cc: Wanpeng Li <wanpengli@tencent.com>; Joerg Roedel
> <joro@8bytes.org>;
> > > the arch/x86 maintainers <x86@kernel.org>; Sean Christopherson
> > > <sean.j.christopherson@intel.com>; Ingo Molnar <mingo@redhat.com>;
> > > Borislav Petkov <bp@alien8.de>; H . Peter Anvin <hpa@zytor.com>; Paolo
> > > Bonzini <pbonzini@redhat.com>; Vitaly Kuznetsov <vkuznets@redhat.com>;
> > > Thomas Gleixner <tglx@linutronix.de>; LKML <linux-
> kernel@vger.kernel.org>;
> > > kvm list <kvm@vger.kernel.org>
> > > Subject: RE: [PATCH v2 2/3] KVM:SVM: Add extended intercept support
> > >
> > >
> > >
> > > > -----Original Message-----
> > > > From: Jim Mattson <jmattson@google.com>
> > > > Sent: Tuesday, June 16, 2020 6:17 PM
> > > > To: Moger, Babu <Babu.Moger@amd.com>
> > > > Cc: Wanpeng Li <wanpengli@tencent.com>; Joerg Roedel
> <joro@8bytes.org>;
> > > > the arch/x86 maintainers <x86@kernel.org>; Sean Christopherson
> > > > <sean.j.christopherson@intel.com>; Ingo Molnar <mingo@redhat.com>;
> > > > Borislav Petkov <bp@alien8.de>; H . Peter Anvin <hpa@zytor.com>; Paolo
> > > > Bonzini <pbonzini@redhat.com>; Vitaly Kuznetsov
> <vkuznets@redhat.com>;
> > > > Thomas Gleixner <tglx@linutronix.de>; LKML <linux-
> kernel@vger.kernel.org>;
> > > > kvm list <kvm@vger.kernel.org>
> > > > Subject: Re: [PATCH v2 2/3] KVM:SVM: Add extended intercept support
> > > >
> > > > On Tue, Jun 16, 2020 at 3:03 PM Babu Moger <babu.moger@amd.com>
> > > wrote:
> > > > >
> > > > > The new intercept bits have been added in vmcb control
> > > > > area to support the interception of INVPCID instruction.
> > > > >
> > > > > The following bit is added to the VMCB layout control area
> > > > > to control intercept of INVPCID:
> > > > >
> > > > > Byte Offset     Bit(s)          Function
> > > > > 14h             2               intercept INVPCID
> > > > >
> > > > > Add the interfaces to support these extended interception.
> > > > > Also update the tracing for extended intercepts.
> > > > >
> > > > > AMD documentation for INVPCID feature is available at "AMD64
> > > > > Architecture Programmer’s Manual Volume 2: System Programming,
> > > > > Pub. 24593 Rev. 3.34(or later)"
> > > > >
> > > > > The documentation can be obtained at the links below:
> > > > > Link:
> > > >
> > >
> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fwww.a
> > > >
> > >
> md.com%2Fsystem%2Ffiles%2FTechDocs%2F24593.pdf&amp;data=02%7C01%7
> > > >
> > >
> Cbabu.moger%40amd.com%7C4cedcb3567194883601e08d8124b6be7%7C3dd8
> > > >
> > >
> 961fe4884e608e11a82d994e183d%7C0%7C0%7C637279463210520563&amp;s
> > > >
> > >
> data=oRQq0hj0O43A4lnl8JEb%2BHt8oCFHWxcqvLaA1%2BacTJc%3D&amp;reser
> > > > ved=0
> > > > > Link:
> > > >
> > >
> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fbugzilla.
> > > >
> > >
> kernel.org%2Fshow_bug.cgi%3Fid%3D206537&amp;data=02%7C01%7Cbabu.m
> > > >
> > >
> oger%40amd.com%7C4cedcb3567194883601e08d8124b6be7%7C3dd8961fe48
> > > >
> > >
> 84e608e11a82d994e183d%7C0%7C0%7C637279463210520563&amp;sdata=EtA
> > > >
> rCUBB8etloN%2B%2Blx42RZqai12QFvtJefnxBn1ryMQ%3D&amp;reserved=0
> > > >
> > > > Not your change, but this documentation is terrible. There is no
> > > > INVLPCID instruction, nor is there a PCID instruction.
> > >
> > > Sorry about that. I will bring this to their notice.
> > >
> > > >
> > > > > Signed-off-by: Babu Moger <babu.moger@amd.com>
> > > > > ---
> > > > >  arch/x86/include/asm/svm.h |    3 ++-
> > > > >  arch/x86/kvm/svm/nested.c  |    6 +++++-
> > > > >  arch/x86/kvm/svm/svm.c     |    1 +
> > > > >  arch/x86/kvm/svm/svm.h     |   18 ++++++++++++++++++
> > > > >  arch/x86/kvm/trace.h       |   12 ++++++++----
> > > > >  5 files changed, 34 insertions(+), 6 deletions(-)
> > > > >
> > > > > diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> > > > > index 8a1f5382a4ea..62649fba8908 100644
> > > > > --- a/arch/x86/include/asm/svm.h
> > > > > +++ b/arch/x86/include/asm/svm.h
> > > > > @@ -61,7 +61,8 @@ struct __attribute__ ((__packed__))
> > > vmcb_control_area {
> > > > >         u32 intercept_dr;
> > > > >         u32 intercept_exceptions;
> > > > >         u64 intercept;
> > > > > -       u8 reserved_1[40];
> > > > > +       u32 intercept_extended;
> > > > > +       u8 reserved_1[36];
> > > >
> > > > It seems like a more straightforward implementation would simply
> > > > change 'u64 intercept' to 'u32 intercept[3].'
> > >
> > > Sure. Will change it.
> >
> > This involves much more changes than I originally thought.  All these
> > following code needs to be modified. Here is my cscope output for the C
> > symbol intercept.
> >
> > 0 nested.c recalc_intercepts                123 c->intercept = h->intercept;
> > 1 nested.c recalc_intercepts                135 c->intercept &= ~(1ULL <<
> > INTERCEPT_VINTR);
> > 2 nested.c recalc_intercepts                139 c->intercept &= ~(1ULL <<
> > INTERCEPT_VMMCALL);
> > 3 nested.c recalc_intercepts                144 c->intercept |= g->intercept;
> > 4 nested.c copy_vmcb_control_area           153 dst->intercept =
> > from->intercept;
> > 5 nested.c nested_svm_vmrun_msrpm           186 if
> > (!(svm->nested.ctl.intercept & (1ULL << INTERCEPT_MSR_PROT)))
> > 6 nested.c nested_vmcb_check_controls 212 if ((control->intercept & (1ULL
> > << INTERCEPT_VMRUN)) == 0)NIT));
> > 7 nested.c nested_svm_vmrun                 436
> > nested_vmcb->control.intercept);
> > 8 nested.c nested_svm_exit_handled_msr      648 if
> > (!(svm->nested.ctl.intercept & (1ULL << INTERCEPT_MSR_PROT)))
> > 9 nested.c nested_svm_intercept_ioio        675 if
> > (!(svm->nested.ctl.intercept & (1ULL << INTERCEPT_IOIO_PROT)))
> > a nested.c nested_svm_intercept             732 if
> > (svm->nested.ctl.intercept & exit_bits)
> > b nested.c nested_exit_on_init              840 return
> > (svm->nested.ctl.intercept & (1ULL << INTERCEPT_INIT));
> > c svm.c    check_selective_cr0_intercepted 2205 u64 intercept;
> > d svm.c    check_selective_cr0_intercepted 2207 intercept =
> > svm->nested.ctl.intercept;
> > e svm.c    check_selective_cr0_intercepted 2210 (!(intercept & (1ULL <<
> > INTERCEPT_SELECTIVE_CR0))))
> > f svm.c    dump_vmcb                       2803 pr_err("%-20s%016llx\n",
> > "intercepts:", control->intercept);
> > m svm.c    svm_check_intercept             3687 intercept =
> > svm->nested.ctl.intercept;
> > n svm.c    svm_check_intercept             3689 if (!(intercept & (1ULL <<
> > INTERCEPT_SELECTIVE_CR0)))
> > 6 svm.c    svm_apic_init_signal_blocked    3948
> > (svm->vmcb->control.intercept & (1ULL << INTERCEPT_INIT));
> > 7 svm.h    set_intercept                    300 vmcb->control.intercept |=
> > (1ULL << bit);
> > 8 svm.h    clr_intercept                    309 vmcb->control.intercept &=
> > ~(1ULL << bit);
> > 9 svm.h    is_intercept tercept_ioio        316 return
> > (svm->vmcb->control.intercept & (1ULL << bit)) != 0;
> > a svm.h    nested_exit_on_smi               377 return
> > (svm->nested.ctl.intercept & (1ULL << INTERCEPT_SMI));
> > b svm.h    nested_exit_on_intr              382 return
> > (svm->nested.ctl.intercept & (1ULL << INTERCEPT_INTR));
> > c svm.h    nested_exit_on_nmi               387 return
> > (svm->nested.ctl.intercept & (1ULL << INTERCEPT_NMI));
> >
> > I will have to test extensively if I go ahead with these changes.  What do
> > you think?
> 
> I see a lot of open-coding of the nested version of is_intercept(),
> which would be a good preparatory cleanup.  It also looks like it
> might be useful to introduce __set_intercept() and __clr_intercept()
> which do the same thing as set_intercept() and clr_intercept(),
> without calling recalc_intercepts(), for use *in* recalc_intercepts.
> This code needs a little love. While your original proposal is more
> expedient, taking the time to fix up the existing mess will be more
> beneficial in the long run.

Ok. Sounds good. Will start working on it.Thanks

