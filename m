Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83E361FCF99
	for <lists+kvm@lfdr.de>; Wed, 17 Jun 2020 16:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbgFQOb4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jun 2020 10:31:56 -0400
Received: from mail-co1nam11on2069.outbound.protection.outlook.com ([40.107.220.69]:64864
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725901AbgFQObz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Jun 2020 10:31:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WqgggNHiEXumx3dH/7wV/7xPWUyB3ftisSfos+NJMwFxiIP6jpz/Hx+0Ig7wCk1iwnk6GnJQIS/OB8Crd/mD67ufSu+eyhI8SheGqF5Nu7laH/WwGyyeGlPmh9hD0uhFQrlz/UhUE6ooeSPs3zmV9xRcydltdG0nnXOgou3tr817LAI4KC6zMOHwiIooiyE/0SziqGvwy5+KCvZiyXmsDyKSxmFpK3lo6shofAR6X/OlS2gFiDh3WUoGEwScFIKxlePYYKL16Qle6cxgL8YwuewUtL1fk760ZljQdpYxeditBN27ccnHZdA2O/GaZigLMq4aAJYC8pWH43cR+l5QvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tfWz3PIqrkamLlmlOCr+AV/rcamarW7jRGTriFTBqFE=;
 b=ezSHaJ9c3n1vf5DX9FzkuqvdgAidQTgTCMdeawS47So/KRvToO3dWno2gzshj02BD0/IdOHM4wHsKQn8MbJ6TknnOtzhU2h/8nA6oKXDRbJqrpChBOU3BpCbaBMpA1VR5fX3hZYEJBLShuUJzV2xBtKf3JFGWpi1JYbB9x71Ri7fzTB0xzkClqpWAfvxut7wSco+es9OXCspMqfaE7qfKq5IaZBiadifJ+ESUWZJmSB02eUTEpSRJM0RS0oWqsUDSSj15zuqXYgMzLWhfCybc3Ii9hHanRwsP1VL3f1oYwPwUq6Z87ZT6MCPJOEHNr0K3JVjJNLEPS1AAIygpGOj4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tfWz3PIqrkamLlmlOCr+AV/rcamarW7jRGTriFTBqFE=;
 b=19BCn1wkc86HUt0aur9FNMBQfgYymqidOsOWUIHCIiE1t7KA2RYaNK2OscF3WAH0SWh9DrVjORq45TXGJvw4DFj50kFoTUvZnQkJBci6fft7G4aRh5SrSbhjhha1+AIsWB0bROZpVqiAoqdapzCaRxpZIpPiSN3x5wHrX50gERk=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SA0PR12MB4350.namprd12.prod.outlook.com (2603:10b6:806:92::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.22; Wed, 17 Jun
 2020 14:31:52 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::2102:cc6b:b2db:4c2]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::2102:cc6b:b2db:4c2%3]) with mapi id 15.20.3088.029; Wed, 17 Jun 2020
 14:31:52 +0000
Subject: RE: [PATCH v2 2/3] KVM:SVM: Add extended intercept support
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "jmattson@google.com" <jmattson@google.com>
References: <159234483706.6230.13753828995249423191.stgit@bmoger-ubuntu>
 <159234502394.6230.5169466123693241678.stgit@bmoger-ubuntu>
 <87r1udhpeh.fsf@vitty.brq.redhat.com>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <9f6d7fde-590e-b5c8-33b3-15b9de40dab2@amd.com>
Date:   Wed, 17 Jun 2020 09:31:49 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <87r1udhpeh.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM5PR15CA0026.namprd15.prod.outlook.com
 (2603:10b6:4:4b::12) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.79] (165.204.77.1) by DM5PR15CA0026.namprd15.prod.outlook.com (2603:10b6:4:4b::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Wed, 17 Jun 2020 14:31:50 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2b6d00ca-b6a2-4b08-009d-08d812cb2d27
X-MS-TrafficTypeDiagnostic: SA0PR12MB4350:
X-Microsoft-Antispam-PRVS: <SA0PR12MB43503AD5B5FE14CFC44268E2959A0@SA0PR12MB4350.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1824;
X-Forefront-PRVS: 04371797A5
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wjjAn20gs2uPjRYCqig8VDSLVGLbL2HP3INYZTintMY/7RXQCGz7G/fHicyD19GLt5aDw/C+0F9IlUC5lnOfNuMaSAwwIIdZgFlNGfsF/V5mkKPEYVddj+QPoe/20Z6II3o9JAbqV1wshDHCLSdqfnvMIxrrSnSZVT0PPrsROztDqXe+QS3EKGAeQzczLXnCSObteW0gZCYzPYmCzUzr5ZthO1uZ5S6NUDxrW4hYc6vvnR+MNOLir9lxj/G3rjOKmOTIQsG7+PdzVzWueXOmi/CcPD5rgpcf+FtA1H67MoyR98TrahRaRhiEIErOZ43LtMuLqfC8IhHOU6cpazuQBeV1x0/iNBsebB2Z5dYZzIxfzoDWi6lkACEq3zalQlA8upX5P46mXwTEG6kJbmzbQlN+S6Mmf2MvlThkQxTANdEbkvuzm+LJhx2M0uj+/w+FekeOvoIt7MSALwm4BYMycA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(376002)(346002)(396003)(136003)(36756003)(83380400001)(83080400001)(16526019)(186003)(52116002)(53546011)(6916009)(26005)(478600001)(66556008)(86362001)(45080400002)(6486002)(2906002)(66476007)(66946007)(31696002)(7416002)(31686004)(8936002)(16576012)(316002)(8676002)(44832011)(956004)(54906003)(2616005)(4326008)(966005)(5660300002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: yy/4iu6XhfSy7ZqsCktnr9eaDTzzhRdBss7cWpBKfhXEFeouL50eL92pN8h2aiYZrsKYqtNAAkraJ8MHa/lUe73jt2cgOQOS80H6Jh8EXVl0GiQrj+Xv/UXr+jmt5n1g4MfZarkMbKiofDlPETlsaVZejWksN4IafL1qVqn5M0expv+Ww/KnM8iS0DtbKQimMaGRTzRfo0ubAqUTe3UIkaajC+IwYIQMhWPj+WqP/69JAfNVy/keGd4nABGPgNl2Cz1Hl4GDtLdeLnoHI/xxlkWUEstI5EvNBBRIB2ZIwFI20v4UEW+HryH55NdxJCZSuyIjexutCZze2aqSq8dCIEnR5FtFjackdoWKDJDS0+TdRc93LNGxPEtjicOQLMHkagj4vzd58/0XldSui2x30iksXCeVMQm3SAr04jbUD3r7eHNMzTpGXjZ/+vNay9iPLNTK9R4sTc71SPYp719dPdhHL8/dAHS5tkQHr7a1DbM=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b6d00ca-b6a2-4b08-009d-08d812cb2d27
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2020 14:31:51.9356
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dfwordu19J+sI7mqGyZdQvYCsOsA74TIa47ePjVkbZmjeWLktnuSnLhnejirFdi+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4350
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Vitaly Kuznetsov <vkuznets@redhat.com>
> Sent: Wednesday, June 17, 2020 7:02 AM
> To: Moger, Babu <Babu.Moger@amd.com>
> Cc: linux-kernel@vger.kernel.org; kvm@vger.kernel.org;
> wanpengli@tencent.com; joro@8bytes.org; x86@kernel.org;
> sean.j.christopherson@intel.com; mingo@redhat.com; bp@alien8.de;
> hpa@zytor.com; pbonzini@redhat.com; tglx@linutronix.de;
> jmattson@google.com
> Subject: Re: [PATCH v2 2/3] KVM:SVM: Add extended intercept support
> 
> Babu Moger <babu.moger@amd.com> writes:
> 
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
> Cbabu.moger%40amd.com%7Cbacf7250d8b644d984e308d812b63d74%7C3dd8
> 961fe4884e608e11a82d994e183d%7C0%7C0%7C637279922105581873&amp;s
> data=%2BGi374uikkiw2c35jk6w%2FYjMnh49R9%2FCw9twf%2BG6i%2FQ%3D&a
> mp;reserved=0
> > Link:
> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fbugzilla.
> kernel.org%2Fshow_bug.cgi%3Fid%3D206537&amp;data=02%7C01%7Cbabu.m
> oger%40amd.com%7Cbacf7250d8b644d984e308d812b63d74%7C3dd8961fe488
> 4e608e11a82d994e183d%7C0%7C0%7C637279922105581873&amp;sdata=dMz
> wBL9AfZAGYdqLFN9hHtC3BTTkuJLixFHNBl%2FnJbM%3D&amp;reserved=0
> >
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
> >  	u32 intercept_dr;
> >  	u32 intercept_exceptions;
> >  	u64 intercept;
> > -	u8 reserved_1[40];
> > +	u32 intercept_extended;
> > +	u8 reserved_1[36];
> >  	u16 pause_filter_thresh;
> >  	u16 pause_filter_count;
> >  	u64 iopm_base_pa;
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index 8a6db11dcb43..7f6d0f2533e2 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -121,6 +121,7 @@ void recalc_intercepts(struct vcpu_svm *svm)
> >  	c->intercept_dr = h->intercept_dr;
> >  	c->intercept_exceptions = h->intercept_exceptions;
> >  	c->intercept = h->intercept;
> > +	c->intercept_extended = h->intercept_extended;
> >
> >  	if (g->int_ctl & V_INTR_MASKING_MASK) {
> >  		/* We only want the cr8 intercept bits of L1 */
> > @@ -142,6 +143,7 @@ void recalc_intercepts(struct vcpu_svm *svm)
> >  	c->intercept_dr |= g->intercept_dr;
> >  	c->intercept_exceptions |= g->intercept_exceptions;
> >  	c->intercept |= g->intercept;
> > +	c->intercept_extended |= g->intercept_extended;
> >  }
> >
> >  static void copy_vmcb_control_area(struct vmcb_control_area *dst,
> > @@ -151,6 +153,7 @@ static void copy_vmcb_control_area(struct
> vmcb_control_area *dst,
> >  	dst->intercept_dr         = from->intercept_dr;
> >  	dst->intercept_exceptions = from->intercept_exceptions;
> >  	dst->intercept            = from->intercept;
> > +	dst->intercept_extended   = from->intercept_extended;
> >  	dst->iopm_base_pa         = from->iopm_base_pa;
> >  	dst->msrpm_base_pa        = from->msrpm_base_pa;
> >  	dst->tsc_offset           = from->tsc_offset;
> > @@ -433,7 +436,8 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
> >  	trace_kvm_nested_intercepts(nested_vmcb->control.intercept_cr &
> 0xffff,
> >  				    nested_vmcb->control.intercept_cr >> 16,
> >  				    nested_vmcb->control.intercept_exceptions,
> > -				    nested_vmcb->control.intercept);
> > +				    nested_vmcb->control.intercept,
> > +				    nested_vmcb->control.intercept_extended);
> >
> >  	/* Clear internal status */
> >  	kvm_clear_exception_queue(&svm->vcpu);
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 9e333b91ff78..285e5e1ff518 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -2801,6 +2801,7 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
> >  	pr_err("%-20s%04x\n", "dr_write:", control->intercept_dr >> 16);
> >  	pr_err("%-20s%08x\n", "exceptions:", control->intercept_exceptions);
> >  	pr_err("%-20s%016llx\n", "intercepts:", control->intercept);
> > +	pr_err("%-20s%08x\n", "intercepts (extended):", control-
> >intercept_extended);
> >  	pr_err("%-20s%d\n", "pause filter count:", control->pause_filter_count);
> >  	pr_err("%-20s%d\n", "pause filter threshold:",
> >  	       control->pause_filter_thresh);
> > diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> > index 6ac4c00a5d82..935d08fac03d 100644
> > --- a/arch/x86/kvm/svm/svm.h
> > +++ b/arch/x86/kvm/svm/svm.h
> > @@ -311,6 +311,24 @@ static inline void clr_intercept(struct vcpu_svm *svm,
> int bit)
> >  	recalc_intercepts(svm);
> >  }
> >
> > +static inline void set_extended_intercept(struct vcpu_svm *svm, int bit)
> > +{
> > +	struct vmcb *vmcb = get_host_vmcb(svm);
> > +
> > +	vmcb->control.intercept_extended |= (1U << bit);
> > +
> > +	recalc_intercepts(svm);
> > +}
> > +
> > +static inline void clr_extended_intercept(struct vcpu_svm *svm, int bit)
> > +{
> > +	struct vmcb *vmcb = get_host_vmcb(svm);
> > +
> > +	vmcb->control.intercept_extended &= ~(1U << bit);
> > +
> > +	recalc_intercepts(svm);
> > +}
> > +
> >  static inline bool is_intercept(struct vcpu_svm *svm, int bit)
> >  {
> >  	return (svm->vmcb->control.intercept & (1ULL << bit)) != 0;
> > diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> > index b66432b015d2..5c841c42b33d 100644
> > --- a/arch/x86/kvm/trace.h
> > +++ b/arch/x86/kvm/trace.h
> > @@ -544,14 +544,16 @@ TRACE_EVENT(kvm_nested_vmrun,
> >  );
> >
> >  TRACE_EVENT(kvm_nested_intercepts,
> > -	    TP_PROTO(__u16 cr_read, __u16 cr_write, __u32 exceptions, __u64
> intercept),
> > -	    TP_ARGS(cr_read, cr_write, exceptions, intercept),
> > +	    TP_PROTO(__u16 cr_read, __u16 cr_write, __u32 exceptions, __u64
> intercept,
> > +		     __u32 extended),
> > +	    TP_ARGS(cr_read, cr_write, exceptions, intercept, extended),
> >
> >  	TP_STRUCT__entry(
> >  		__field(	__u16,		cr_read		)
> >  		__field(	__u16,		cr_write	)
> >  		__field(	__u32,		exceptions	)
> >  		__field(	__u64,		intercept	)
> > +		__field(	__u32,		extended	)
> >  	),
> >
> >  	TP_fast_assign(
> > @@ -559,11 +561,13 @@ TRACE_EVENT(kvm_nested_intercepts,
> >  		__entry->cr_write	= cr_write;
> >  		__entry->exceptions	= exceptions;
> >  		__entry->intercept	= intercept;
> > +		__entry->extended	= extended;
> >  	),
> >
> > -	TP_printk("cr_read: %04x cr_write: %04x excp: %08x intercept:
> %016llx",
> > +	TP_printk("cr_read: %04x cr_write: %04x excp: %08x intercept: %016llx"
> > +		  "intercept (extended): %08x",
> >  		__entry->cr_read, __entry->cr_write, __entry->exceptions,
> > -		__entry->intercept)
> > +		__entry->intercept, __entry->extended)
> 
> Nit: I would've renamed 'extended' to something like 'intercept_ext' as
> it is not clear what it is about otherwise. Also, if you decide to do
> so, you may as well shorten 'intercept_extended' to 'intercept_ext'
> everywhere else to be consistent. Or just use 'intercept_extended', with
> no 80-character-per-line limitation we no longer need to be concise.

With new suggestion from Jim, we probably don’t need this change. Thanks

> 
> >  );
> >  /*
> >   * Tracepoint for #VMEXIT while nested
> >
> 
> --
> Vitaly

