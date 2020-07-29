Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE3A23226A
	for <lists+kvm@lfdr.de>; Wed, 29 Jul 2020 18:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbgG2QPy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jul 2020 12:15:54 -0400
Received: from mail-dm6nam10on2083.outbound.protection.outlook.com ([40.107.93.83]:52608
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726341AbgG2QPx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jul 2020 12:15:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RhlP11TU8RPdgkT2rXgcgB4Dbw7HFbqfhqwcrwddE774AbqJihkMnCjVaoDyJAwQgYuqqTubKVB8P6eHc5/kazViuoEcKreMSlbNwVOTOlYiyUTc/HY2rguBnMEu5fkIgg3N6Zd97a8U1RcBN5HqfG1kFQo/BxJPwWAGVXGnBZvl8Bklxrhs3ASG2x6unVsSBe3iGPssu7U+f+3BDVdm9hb61fvk+Gb3n9UAIJWFnOVty2+kDcwb0ixmFPg/wx7y6PgCdIJyko+qkT9ls8/X+sPlb5QQez9K2vReUIN8i2KNHEKOsibGlqWSgYQvKf8jnYEaEaPI7eGGx4Bm24EAxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+bEcukd6ZvQhbC3frjC0w6ARpe0Z7wK+k35PNVR296A=;
 b=TEa7hCZq3xcgP5SoTIIIff4oV3lgyLZ/9Z/5H43v2ya81wBEl98zqgXgcz9o68PrtfDaQm6KAu4VCZCb6QJeAn9gSezdVYCe5/WuoSB9YVlFq3QNBRHNsSuyLjPCe/iB8XyX+IwAeuoWgkCjRPi6AKADTeb/VgjslrkU3ruZAeM+GuqWj1bwzOe3lFxMlTwK5R/xe8QtL9pooDETaDvBi/+11G/xfG49+kl6aQiSaa9S5acQmvuG4fjtP8f6TP9eZ3lce4eOQTylSEzIi9SqWsuUyjjEc+FoGRmoU74t+cbfX9OH5QEiPk+xtV5N5cp52z3mn1hdDQmqNHKnHhNCJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+bEcukd6ZvQhbC3frjC0w6ARpe0Z7wK+k35PNVR296A=;
 b=ToXcPmPiT4Tj5reTaf02U1OfnEuVlVWhLxVBk2nRDH21l7CBSdZtLb//N/A+AngEuFpHTDmejcx2WSCDfD3NkKP5N3wRKZjJRHbYBu9s0PpEhhAz05SnpGmJuY8dylG3c8d7g/ehT9EP6UxYtQTxnRpIJxL/IA6IHgNHiNkJIIw=
Authentication-Results: linutronix.de; dkim=none (message not signed)
 header.d=none;linutronix.de; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN6PR12MB2733.namprd12.prod.outlook.com (2603:10b6:805:77::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.24; Wed, 29 Jul
 2020 16:15:49 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c%6]) with mapi id 15.20.3216.033; Wed, 29 Jul 2020
 16:15:49 +0000
Subject: RE: [PATCH v3 03/11] KVM: SVM: Change intercept_dr to generic
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
 <159597948692.12744.7037992839778140055.stgit@bmoger-ubuntu>
 <CALMp9eRF-ScqaWG7vn2mxKmR4jWo7LYZiiicHksiZR9hh+G=-A@mail.gmail.com>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <bdd85682-5294-7a6c-7385-8a02836bf20f@amd.com>
Date:   Wed, 29 Jul 2020 11:15:48 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <CALMp9eRF-ScqaWG7vn2mxKmR4jWo7LYZiiicHksiZR9hh+G=-A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR03CA0013.namprd03.prod.outlook.com
 (2603:10b6:806:20::18) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.79] (165.204.77.1) by SA9PR03CA0013.namprd03.prod.outlook.com (2603:10b6:806:20::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23 via Frontend Transport; Wed, 29 Jul 2020 16:15:48 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 42a1ca1d-2133-43f9-a5ba-08d833daa850
X-MS-TrafficTypeDiagnostic: SN6PR12MB2733:
X-Microsoft-Antispam-PRVS: <SN6PR12MB2733C53060558E173DC6FC5695700@SN6PR12MB2733.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0RUTpcTKdSON2RztIrAyQrjaL8469LFPC02ggR3r3vcpG/xWhhB+mDujU3tRU6l/Ctj9Au/Z4GsclT7t5a7bnep81xmh/rTR3aTt6cudbBT6PazuN0H13e4GxBfukQcuV1OzcP/URBvhiqObB61ImgUAqAbHpDem4udt3uIBMmXis2+bbHlO+iiX0Y2DCWGCpylxffYDpdAyu/86Fx8/jcvofPpm6IbCquwwnPAz/GUKNSYl5iTHOYAvyIV/WCjG773SdcsBdiu6+od+yoaaE6y36viW+FaTnhiE90H2DLzEBQ1H1j5SfMVTBSHXdTFaowR1WmhjGlF9tmBFi7P4CmAwW+ehUZJYtFK+W1TyBkJy6+O68R8otuJo6bWc5/+pjzsvLw6TeLaX6186hejx8Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(376002)(39860400002)(346002)(366004)(2906002)(6916009)(8676002)(8936002)(478600001)(6486002)(4326008)(5660300002)(31686004)(16576012)(316002)(54906003)(66556008)(956004)(83380400001)(31696002)(66476007)(86362001)(36756003)(7416002)(52116002)(16526019)(186003)(53546011)(66946007)(44832011)(26005)(2616005)(41533002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 4RwiraPDTOJadks7vwDIqzAHr78A5JCMunqabfUFN9e1+PTDuj7Y9tia1w4U1JsfKxsRYWHWxBDSYqmULRNet9STYoftR0ZVP9JE2XvlAwa77by3YzJtXlgyIyae4c7OwJYd589Npd7nqpcycnHCLdTMyOSFZVUjlaWSgxgBM0vPnFzqELkDd7HYEA78t6wEqSG5JgnUl/SvMJ6II07glYIkdtENiVjTe8OR8jORje5WvkcPs3umw0E6IKcD+Tc1Lxx14G7+GckMPdub7s2ZZWxXTUdQo2H4of3cXI2saYP2ZIoLBcxnocbLG62woruIdeVu7Grn91tIEmWpca8APoV3LgAcWcC5yTHsABDOmtz5alTha8rBLwfbzlfptMdDwDufr6++vUc4cSOMZgfDlPjkU13DLATt9IdjHnohPblnKbQIZEidrxpQPjKBUVPYsc7neg9/nW95gRyQ+YUttBUAPTLLqHyGuK/7fUuwPlM=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42a1ca1d-2133-43f9-a5ba-08d833daa850
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2020 16:15:49.4698
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8jLRngBUxcr3e0013x7nhv3Wl1fbXB/pKhLv5N4fwgZuj24FjvH06w7wCA0b6+f6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2733
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Jim Mattson <jmattson@google.com>
> Sent: Tuesday, July 28, 2020 6:59 PM
> To: Moger, Babu <Babu.Moger@amd.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>; Vitaly Kuznetsov
> <vkuznets@redhat.com>; Wanpeng Li <wanpengli@tencent.com>; Sean
> Christopherson <sean.j.christopherson@intel.com>; kvm list
> <kvm@vger.kernel.org>; Joerg Roedel <joro@8bytes.org>; the arch/x86
> maintainers <x86@kernel.org>; LKML <linux-kernel@vger.kernel.org>; Ingo
> Molnar <mingo@redhat.com>; Borislav Petkov <bp@alien8.de>; H . Peter Anvin
> <hpa@zytor.com>; Thomas Gleixner <tglx@linutronix.de>
> Subject: Re: [PATCH v3 03/11] KVM: SVM: Change intercept_dr to generic
> intercepts
> 
> On Tue, Jul 28, 2020 at 4:38 PM Babu Moger <babu.moger@amd.com> wrote:
> >
> > Modify intercept_dr to generic intercepts in vmcb_control_area.
> > Use generic __set_intercept, __clr_intercept and __is_intercept to
> > set/clear/test the intercept_dr bits.
> >
> > Signed-off-by: Babu Moger <babu.moger@amd.com>
> > ---
> >  arch/x86/include/asm/svm.h |   36 ++++++++++++++++++------------------
> >  arch/x86/kvm/svm/nested.c  |    6 +-----
> >  arch/x86/kvm/svm/svm.c     |    4 ++--
> >  arch/x86/kvm/svm/svm.h     |   34 +++++++++++++++++-----------------
> >  4 files changed, 38 insertions(+), 42 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> > index d4739f4eae63..ffc89d8e4fcb 100644
> > --- a/arch/x86/include/asm/svm.h
> > +++ b/arch/x86/include/asm/svm.h
> > @@ -11,6 +11,7 @@
> >
> >  enum vector_offset {
> >         CR_VECTOR = 0,
> > +       DR_VECTOR,
> >         MAX_VECTORS,
> >  };
> >
> > @@ -34,6 +35,23 @@ enum {
> >         INTERCEPT_CR6_WRITE,
> >         INTERCEPT_CR7_WRITE,
> >         INTERCEPT_CR8_WRITE,
> > +       /* Byte offset 004h (Vector 1) */
> > +       INTERCEPT_DR0_READ = 32,
> > +       INTERCEPT_DR1_READ,
> > +       INTERCEPT_DR2_READ,
> > +       INTERCEPT_DR3_READ,
> > +       INTERCEPT_DR4_READ,
> > +       INTERCEPT_DR5_READ,
> > +       INTERCEPT_DR6_READ,
> > +       INTERCEPT_DR7_READ,
> > +       INTERCEPT_DR0_WRITE = 48,
> > +       INTERCEPT_DR1_WRITE,
> > +       INTERCEPT_DR2_WRITE,
> > +       INTERCEPT_DR3_WRITE,
> > +       INTERCEPT_DR4_WRITE,
> > +       INTERCEPT_DR5_WRITE,
> > +       INTERCEPT_DR6_WRITE,
> > +       INTERCEPT_DR7_WRITE,
> >  };
> >
> >  enum {
> > @@ -89,7 +107,6 @@ enum {
> >
> >  struct __attribute__ ((__packed__)) vmcb_control_area {
> >         u32 intercepts[MAX_VECTORS];
> > -       u32 intercept_dr;
> >         u32 intercept_exceptions;
> >         u64 intercept;
> >         u8 reserved_1[40];
> > @@ -271,23 +288,6 @@ struct __attribute__ ((__packed__)) vmcb {
> > #define SVM_SELECTOR_READ_MASK SVM_SELECTOR_WRITE_MASK  #define
> > SVM_SELECTOR_CODE_MASK (1 << 3)
> >
> > -#define INTERCEPT_DR0_READ     0
> > -#define INTERCEPT_DR1_READ     1
> > -#define INTERCEPT_DR2_READ     2
> > -#define INTERCEPT_DR3_READ     3
> > -#define INTERCEPT_DR4_READ     4
> > -#define INTERCEPT_DR5_READ     5
> > -#define INTERCEPT_DR6_READ     6
> > -#define INTERCEPT_DR7_READ     7
> > -#define INTERCEPT_DR0_WRITE    (16 + 0)
> > -#define INTERCEPT_DR1_WRITE    (16 + 1)
> > -#define INTERCEPT_DR2_WRITE    (16 + 2)
> > -#define INTERCEPT_DR3_WRITE    (16 + 3)
> > -#define INTERCEPT_DR4_WRITE    (16 + 4)
> > -#define INTERCEPT_DR5_WRITE    (16 + 5)
> > -#define INTERCEPT_DR6_WRITE    (16 + 6)
> > -#define INTERCEPT_DR7_WRITE    (16 + 7)
> > -
> >  #define SVM_EVTINJ_VEC_MASK 0xff
> >
> >  #define SVM_EVTINJ_TYPE_SHIFT 8
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index 46f5c82d9b45..71ca89afb2a3 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -121,7 +121,6 @@ void recalc_intercepts(struct vcpu_svm *svm)
> >         for (i = 0; i < MAX_VECTORS; i++)
> >                 c->intercepts[i] = h->intercepts[i];
> >
> > -       c->intercept_dr = h->intercept_dr;
> >         c->intercept_exceptions = h->intercept_exceptions;
> >         c->intercept = h->intercept;
> >
> > @@ -144,7 +143,6 @@ void recalc_intercepts(struct vcpu_svm *svm)
> >         for (i = 0; i < MAX_VECTORS; i++)
> >                 c->intercepts[i] |= g->intercepts[i];
> >
> > -       c->intercept_dr |= g->intercept_dr;
> >         c->intercept_exceptions |= g->intercept_exceptions;
> >         c->intercept |= g->intercept;
> >  }
> > @@ -157,7 +155,6 @@ static void copy_vmcb_control_area(struct
> vmcb_control_area *dst,
> >         for (i = 0; i < MAX_VECTORS; i++)
> >                 dst->intercepts[i] = from->intercepts[i];
> >
> > -       dst->intercept_dr         = from->intercept_dr;
> >         dst->intercept_exceptions = from->intercept_exceptions;
> >         dst->intercept            = from->intercept;
> >         dst->iopm_base_pa         = from->iopm_base_pa;
> > @@ -717,8 +714,7 @@ static int nested_svm_intercept(struct vcpu_svm
> *svm)
> >                 break;
> >         }
> >         case SVM_EXIT_READ_DR0 ... SVM_EXIT_WRITE_DR7: {
> > -               u32 bit = 1U << (exit_code - SVM_EXIT_READ_DR0);
> > -               if (svm->nested.ctl.intercept_dr & bit)
> > +               if (__is_intercept(&svm->nested.ctl.intercepts,
> > + exit_code))
> 
> Can I assume that all of these __<function> calls will become <function> calls
> when the grand unification is done? (Maybe I should just look ahead.)

There are two types of calls here.

1. Calls like set_cr_intercept, clr_cr_intercept, set_dr_intercept,
clr_dr_intercept, set_exception_intercept, clr_exception_intercept.
These calls pass svm data structure. I replaced these calls with either
set_intercept or clr_intercept because we have combined all the intercept
vectors into one 32 bit array.

2. Some calls sets or clears the bit directly like
  c->intercept_cr &= ~(1U << INTERCEPT_CR8_READ);
  Replaced these with __clr_intercept or __set_intercepts.

There is a scope to make all these calls set_intercept or clr_intercept.
These calls use another call get_host_vmcb to get the address. We can take
that up as next cleanup.


