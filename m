Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E545A23222A
	for <lists+kvm@lfdr.de>; Wed, 29 Jul 2020 18:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbgG2QIc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jul 2020 12:08:32 -0400
Received: from mail-mw2nam10on2084.outbound.protection.outlook.com ([40.107.94.84]:23905
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726341AbgG2QIb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jul 2020 12:08:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rv9toNp/6on/iG1d5gwBaWLEiM0eJom/E2BdrtS4JBQXWvUYIbjikdPIGqJrjpkJSOusOw46LKfPvIIYrPUrs/bYglSUMta+5Mk8/x1dAFg5QYXwQazXDYp72SwSsanhIJD0HcmR5xFIX5fvMeplP7KF7XRya6+o2eeaogH+7sh0nrmiFDCyMGeqsP/zOEwoJItkIQQxR+iNfC+NQkh3wRpy/SBhAAZnmYWTEuZ8d1+KKBbtnz9r9UaWigzvPQtWbvqwrTg54OVpWYpLZpDmvhcJ3E0/AFqUvl2POFPf01OilmKoJRFEEG5aiA8uTy9j+yh5L+m9CmSa+I723oSg/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1KJsJq6CCO3c9rkF2GSCkCEvk/alN1aXuokE05I+c/4=;
 b=N7DHnZbsCOmuD4hGb/5s6i1H9yN4/6da1c4UeKfn7Oi4jVBHq3rwIWm8DcRQCno0T4QVyqEGgQnXkiGWX5IzOCz9BZSgAqRy0zsaFlKv0+Kx2hXfx+P99YF1q8emfFCSWvmWYjcHWbocWpquSSzhFt71Lnnn/g5QWsKPOXlSQ3gFjx+VbPIk3drrN7NR0c0XK5yxdOSxJvXjoBUwiVTcUKfqSjNseTCepZdPE5Tg+WTNIOlhNkFCJR+TVXgrlmvv4e2K+feuI+gWVpIieuW+H53ocpkGcA/u3yzKRB/4yINnxjIeQ9N3hElA3jphOu68Z+dDJ5jISGGmR1LQxolzIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1KJsJq6CCO3c9rkF2GSCkCEvk/alN1aXuokE05I+c/4=;
 b=CGv3VT/eO/u3RJLDnHPcHKh7W2RcmIk0blA27GPGy/1M6mtNk6n9IrXia4oo8zN7yJw3rJZbithOhJT1Y1auiahEW9Yeq+2UYe8x34W3EC5UjHCD7xnNlc/hk13CtyMF5vepsg65HoEQnTqdNie7Mt4+t3v7nfb6HC7nITugDrI=
Authentication-Results: linutronix.de; dkim=none (message not signed)
 header.d=none;linutronix.de; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN6PR12MB2733.namprd12.prod.outlook.com (2603:10b6:805:77::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.24; Wed, 29 Jul
 2020 16:08:27 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c%6]) with mapi id 15.20.3216.033; Wed, 29 Jul 2020
 16:08:27 +0000
Subject: RE: [PATCH v3 02/11] KVM: SVM: Change intercept_cr to generic
 intercepts
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
 <159597948045.12744.16141020747986494741.stgit@bmoger-ubuntu>
 <CALMp9eTDKX7L0ntOo-hsirk2dET1ZG4tofgvQ4SX9kdwEQoPtw@mail.gmail.com>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <d11694cd-7c75-9dbb-0ccd-9b1927fa2da1@amd.com>
Date:   Wed, 29 Jul 2020 11:08:25 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <CALMp9eTDKX7L0ntOo-hsirk2dET1ZG4tofgvQ4SX9kdwEQoPtw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0046.namprd05.prod.outlook.com
 (2603:10b6:803:41::23) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.79] (165.204.77.1) by SN4PR0501CA0046.namprd05.prod.outlook.com (2603:10b6:803:41::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.9 via Frontend Transport; Wed, 29 Jul 2020 16:08:26 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 13bbcfc3-a7b0-435b-99b7-08d833d9a08d
X-MS-TrafficTypeDiagnostic: SN6PR12MB2733:
X-Microsoft-Antispam-PRVS: <SN6PR12MB27335F711858C561FED07FA495700@SN6PR12MB2733.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ehWemGDtsXNxqyQe9KPxTaVY7jvpKxyh4mt+g8F2f3FOgkEIr23NbLe61fqqSWkozXOJiGUlnE8KxZPEqqNJCeav+5lq5uWG9iNUix63aRa6U/7HC0ktHNdDxAHyj9nn0PKDs1RTok3ID2TXzThrbgMs8P4pJp9vERQL9DtjwvEio/mQFba2Xb2WDE/Dh8kSETi3TMNFJ6YbAAuAhNPt7WYMQidi+v+mdLF+nKiVC6WVGoSMVkuKGuIgLR8jlvqD7F3O1m834uCZLBoNA3eaquMk7WHSkva8KOl7+l0IsZD1dJ/5iy7usIS1uNEzRQAI6AO/CA9ykzlYhjRemHI7HBlq8jTrw0eqrN1RS0ptAWcHvgAkSCedbt9FqPQrvADidGv1jxljJRK1K1Tuoy/1Ow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(376002)(39860400002)(346002)(366004)(2906002)(6916009)(8676002)(8936002)(478600001)(6486002)(4326008)(5660300002)(31686004)(16576012)(316002)(54906003)(66556008)(956004)(83380400001)(31696002)(66476007)(86362001)(36756003)(7416002)(52116002)(16526019)(186003)(53546011)(66946007)(44832011)(26005)(2616005)(41533002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: XFUzFGgATszlPC/SrIqAqSI69nPqKhR9OsolQFEDPNH4NvS/Jvb8KBb37sk0tpwEPaggH+obpuA+ljZprTNLXBTqbHUk/2E3+Lo5eJiiJGfbyBtGhlZf+aXZOqV1oHQDpSRC3J2RPJil2V9tSafhbupvrr3oDaxLoSJkDXnoENHSYDl7+bI+Tn4p0m1yPGgxENOQmnrwAoqqJGA3lRwNPLNzm4fs3j1UGpJGwQznr9Q1IoeHxj5Sq8pwGJrJrwKISKLlna2ZQg52hus0485h4QOD7Zx+ayjlIGIVDO4yGEF9tq5XKgLoSfs7NubqaCqGvN1h/4zezOUXyyIkpyihtidIwY2fq/mISzZHPRCvZpaFe8dLjFpM93r+Ttnncl8y/ohBnH3KWfmTFV99GuiIU57bZiKOsIctR9lK52BGk27vYnzgjJbnZXoHiPxy9YHxsIftHKsuhBQpkHrcUgMUHMff+yLUSzNIwbINGFY+bjo=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13bbcfc3-a7b0-435b-99b7-08d833d9a08d
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2020 16:08:27.1677
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3vUUh6cMF0PkURN2NgJcMES7JLEuoiu/wBjpRzZ4uSh0ngcChvnzIJ3yFql71hm0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2733
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Jim Mattson <jmattson@google.com>
> Sent: Tuesday, July 28, 2020 6:56 PM
> To: Moger, Babu <Babu.Moger@amd.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>; Vitaly Kuznetsov
> <vkuznets@redhat.com>; Wanpeng Li <wanpengli@tencent.com>; Sean
> Christopherson <sean.j.christopherson@intel.com>; kvm list
> <kvm@vger.kernel.org>; Joerg Roedel <joro@8bytes.org>; the arch/x86
> maintainers <x86@kernel.org>; LKML <linux-kernel@vger.kernel.org>; Ingo
> Molnar <mingo@redhat.com>; Borislav Petkov <bp@alien8.de>; H . Peter Anvin
> <hpa@zytor.com>; Thomas Gleixner <tglx@linutronix.de>
> Subject: Re: [PATCH v3 02/11] KVM: SVM: Change intercept_cr to generic
> intercepts
> 
> On Tue, Jul 28, 2020 at 4:38 PM Babu Moger <babu.moger@amd.com> wrote:
> >
> > Change intercept_cr to generic intercepts in vmcb_control_area.
> > Use the new __set_intercept, __clr_intercept and __is_intercept where
> > applicable.
> >
> > Signed-off-by: Babu Moger <babu.moger@amd.com>
> > ---
> >  arch/x86/include/asm/svm.h |   42 ++++++++++++++++++++++++++++++++----
> ------
> >  arch/x86/kvm/svm/nested.c  |   26 +++++++++++++++++---------
> >  arch/x86/kvm/svm/svm.c     |    4 ++--
> >  arch/x86/kvm/svm/svm.h     |    6 +++---
> >  4 files changed, 54 insertions(+), 24 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> > index 8a1f5382a4ea..d4739f4eae63 100644
> > --- a/arch/x86/include/asm/svm.h
> > +++ b/arch/x86/include/asm/svm.h
> > @@ -4,6 +4,37 @@
> >
> >  #include <uapi/asm/svm.h>
> >
> > +/*
> > + * VMCB Control Area intercept bits starting
> > + * at Byte offset 000h (Vector 0).
> > + */
> > +
> > +enum vector_offset {
> > +       CR_VECTOR = 0,
> > +       MAX_VECTORS,
> > +};
> > +
> > +enum {
> > +       /* Byte offset 000h (Vector 0) */
> > +       INTERCEPT_CR0_READ = 0,
> > +       INTERCEPT_CR1_READ,
> > +       INTERCEPT_CR2_READ,
> > +       INTERCEPT_CR3_READ,
> > +       INTERCEPT_CR4_READ,
> > +       INTERCEPT_CR5_READ,
> > +       INTERCEPT_CR6_READ,
> > +       INTERCEPT_CR7_READ,
> > +       INTERCEPT_CR8_READ,
> > +       INTERCEPT_CR0_WRITE = 16,
> > +       INTERCEPT_CR1_WRITE,
> > +       INTERCEPT_CR2_WRITE,
> > +       INTERCEPT_CR3_WRITE,
> > +       INTERCEPT_CR4_WRITE,
> > +       INTERCEPT_CR5_WRITE,
> > +       INTERCEPT_CR6_WRITE,
> > +       INTERCEPT_CR7_WRITE,
> > +       INTERCEPT_CR8_WRITE,
> > +};
> >
> >  enum {
> >         INTERCEPT_INTR,
> > @@ -57,7 +88,7 @@ enum {
> >
> >
> >  struct __attribute__ ((__packed__)) vmcb_control_area {
> > -       u32 intercept_cr;
> > +       u32 intercepts[MAX_VECTORS];
> >         u32 intercept_dr;
> >         u32 intercept_exceptions;
> >         u64 intercept;
> > @@ -240,15 +271,6 @@ struct __attribute__ ((__packed__)) vmcb {
> > #define SVM_SELECTOR_READ_MASK SVM_SELECTOR_WRITE_MASK  #define
> > SVM_SELECTOR_CODE_MASK (1 << 3)
> >
> > -#define INTERCEPT_CR0_READ     0
> > -#define INTERCEPT_CR3_READ     3
> > -#define INTERCEPT_CR4_READ     4
> > -#define INTERCEPT_CR8_READ     8
> > -#define INTERCEPT_CR0_WRITE    (16 + 0)
> > -#define INTERCEPT_CR3_WRITE    (16 + 3)
> > -#define INTERCEPT_CR4_WRITE    (16 + 4)
> > -#define INTERCEPT_CR8_WRITE    (16 + 8)
> > -
> >  #define INTERCEPT_DR0_READ     0
> >  #define INTERCEPT_DR1_READ     1
> >  #define INTERCEPT_DR2_READ     2
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index 6bceafb19108..46f5c82d9b45 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -105,6 +105,7 @@ static void nested_svm_uninit_mmu_context(struct
> > kvm_vcpu *vcpu)  void recalc_intercepts(struct vcpu_svm *svm)  {
> >         struct vmcb_control_area *c, *h, *g;
> > +       unsigned int i;
> >
> >         mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
> >
> > @@ -117,15 +118,17 @@ void recalc_intercepts(struct vcpu_svm *svm)
> >
> >         svm->nested.host_intercept_exceptions =
> > h->intercept_exceptions;
> >
> > -       c->intercept_cr = h->intercept_cr;
> > +       for (i = 0; i < MAX_VECTORS; i++)
> > +               c->intercepts[i] = h->intercepts[i];
> > +
> >         c->intercept_dr = h->intercept_dr;
> >         c->intercept_exceptions = h->intercept_exceptions;
> >         c->intercept = h->intercept;
> >
> >         if (g->int_ctl & V_INTR_MASKING_MASK) {
> >                 /* We only want the cr8 intercept bits of L1 */
> > -               c->intercept_cr &= ~(1U << INTERCEPT_CR8_READ);
> > -               c->intercept_cr &= ~(1U << INTERCEPT_CR8_WRITE);
> > +               __clr_intercept(&c->intercepts, INTERCEPT_CR8_READ);
> > +               __clr_intercept(&c->intercepts, INTERCEPT_CR8_WRITE);
> 
> Why the direct calls to the __clr_intercept worker function? Can't these be calls
> to clr_cr_intercept()?
> Likewise throughout.

This code uses the address to clear the bits.  So called __clr_intercept
directly. The call clr_cr_intercept() passes the structure vcpu_svm and
then uses get_host_vmcb to get the address.

