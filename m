Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4B6F35E11B
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 16:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346395AbhDMOL7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 10:11:59 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:59883 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346388AbhDMOL6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Apr 2021 10:11:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1618323098; x=1649859098;
  h=date:from:to:cc:message-id:references:mime-version:
   in-reply-to:subject;
  bh=IAUGQ4TQXj2AlWjeWSR488mKslVwCJVtzyjays9HN1I=;
  b=kezeCRBwTnfHnE9VEP2BgZoZjwMvZrvufzS4h5QLrfR3qKx1HNJWmy4c
   NQ0NivyiDRI07XPvDKsPMxefJT5et6vgyjoDKgLuuUDgtSmVu8mGBAViV
   kWhyaNe3mck0epw4eHhME7YNc2jqlqowYeTfwjSdAWT8d608jZrkudXvk
   s=;
X-IronPort-AV: E=Sophos;i="5.82,219,1613433600"; 
   d="scan'208";a="127265714"
Subject: Re: [PATCH v2 2/4] KVM: hyper-v: Collect hypercall params into struct
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-2a-53356bf6.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 13 Apr 2021 14:11:31 +0000
Received: from EX13D28EUC003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2a-53356bf6.us-west-2.amazon.com (Postfix) with ESMTPS id 5174AA17A6;
        Tue, 13 Apr 2021 14:11:30 +0000 (UTC)
Received: from uc8bbc9586ea454.ant.amazon.com (10.43.160.81) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 13 Apr 2021 14:11:21 +0000
Date:   Tue, 13 Apr 2021 16:11:17 +0200
From:   Siddharth Chandrasekaran <sidcha@amazon.de>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
CC:     Alexander Graf <graf@amazon.com>,
        Evgeny Iakovlev <eyakovl@amazon.de>,
        Liran Alon <liran@amazon.com>,
        Ioannis Aslanidis <iaslan@amazon.de>,
        <linux-hyperv@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Sean Christopherson" <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        "Jim Mattson" <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>
Message-ID: <20210413141117.GA29970@uc8bbc9586ea454.ant.amazon.com>
References: <cover.1618244920.git.sidcha@amazon.de>
 <2ca35d1660401780a530e4dbdf3dcd49b8390e61.1618244920.git.sidcha@amazon.de>
 <87v98q5m0y.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <87v98q5m0y.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [10.43.160.81]
X-ClientProxiedBy: EX13D39UWA001.ant.amazon.com (10.43.160.54) To
 EX13D28EUC003.ant.amazon.com (10.43.164.43)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 13, 2021 at 03:53:01PM +0200, Vitaly Kuznetsov wrote:
> Siddharth Chandrasekaran <sidcha@amazon.de> writes:
> > As of now there are 7 parameters (and flags) that are used in various
> > hyper-v hypercall handlers. There are 6 more input/output parameters
> > passed from XMM registers which are to be added in an upcoming patch.
> >
> > To make passing arguments to the handlers more readable, capture all
> > these parameters into a single structure.
> >
> > Cc: Alexander Graf <graf@amazon.com>
> > Cc: Evgeny Iakovlev <eyakovl@amazon.de>
> > Signed-off-by: Siddharth Chandrasekaran <sidcha@amazon.de>
> > ---
> >  arch/x86/kvm/hyperv.c | 147 +++++++++++++++++++++++-------------------
> >  1 file changed, 79 insertions(+), 68 deletions(-)
> >
> > diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> > index f98370a39936..8f6babd1ea0d 100644
> > --- a/arch/x86/kvm/hyperv.c
> > +++ b/arch/x86/kvm/hyperv.c
> > @@ -1623,7 +1623,18 @@ static __always_inline unsigned long *sparse_set_to_vcpu_mask(
> >       return vcpu_bitmap;
> >  }
> >
> > -static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, u64 ingpa, u16 rep_cnt, bool ex)
> > +struct kvm_hv_hcall {
> > +     u64 param;
> > +     u64 ingpa;
> > +     u64 outgpa;
> > +     u16 code;
> > +     u16 rep_cnt;
> > +     u16 rep_idx;
> > +     bool fast;
> > +     bool rep;
> > +};
> > +
> > +static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool ex)
> 
> Nitpick: Would it make sense to also pack the fact that we're dealing
> with a hypercall using ExProcessorMasks into 'struct kvm_hv_hcall' and
> get rid of 'bool ex' parameter for both kvm_hv_flush_tlb() and
> kvm_hv_send_ipi()? 'struct kvm_hv_hcall' is already a synthetic
> aggregator for input and output so adding some other information there
> may not be that big of a stretch...

The other members of the struct are all hypercall parameters (or flags)
while the 'bool ex' is our way of handling ExProcessorMasks within the
same method.

Besides, in kvm_hv_hypercall() passing it as a 3rd argument looks
better than setting 'hc.ex = true' and than immediately calling the
method :-).

> >  {
> >       struct kvm *kvm = vcpu->kvm;
> >       struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
> > @@ -1638,7 +1649,7 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, u64 ingpa, u16 rep_cnt, bool
> >       bool all_cpus;
> >
> >       if (!ex) {
> > -             if (unlikely(kvm_read_guest(kvm, ingpa, &flush, sizeof(flush))))
> > +             if (unlikely(kvm_read_guest(kvm, hc->ingpa, &flush, sizeof(flush))))
> >                       return HV_STATUS_INVALID_HYPERCALL_INPUT;
> >
> >               trace_kvm_hv_flush_tlb(flush.processor_mask,
> > @@ -1657,7 +1668,7 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, u64 ingpa, u16 rep_cnt, bool
> >               all_cpus = (flush.flags & HV_FLUSH_ALL_PROCESSORS) ||
> >                       flush.processor_mask == 0;
> >       } else {
> > -             if (unlikely(kvm_read_guest(kvm, ingpa, &flush_ex,
> > +             if (unlikely(kvm_read_guest(kvm, hc->ingpa, &flush_ex,
> >                                           sizeof(flush_ex))))
> >                       return HV_STATUS_INVALID_HYPERCALL_INPUT;
> >
> > @@ -1679,8 +1690,8 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, u64 ingpa, u16 rep_cnt, bool
> >
> >               if (!all_cpus &&
> >                   kvm_read_guest(kvm,
> > -                                ingpa + offsetof(struct hv_tlb_flush_ex,
> > -                                                 hv_vp_set.bank_contents),
> > +                                hc->ingpa + offsetof(struct hv_tlb_flush_ex,
> > +                                                     hv_vp_set.bank_contents),
> >                                  sparse_banks,
> >                                  sparse_banks_len))
> >                       return HV_STATUS_INVALID_HYPERCALL_INPUT;
> > @@ -1700,9 +1711,9 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, u64 ingpa, u16 rep_cnt, bool
> >                                   NULL, vcpu_mask, &hv_vcpu->tlb_flush);
> >
> >  ret_success:
> > -     /* We always do full TLB flush, set rep_done = rep_cnt. */
> > +     /* We always do full TLB flush, set rep_done = hc->rep_cnt. */
> 
> Nitpicking: I'd suggest we word it a bit differently:
> 
> "We always do full TLB flush, set 'Reps completed' = 'Rep Count'."
> 
> so it matches TLFS rather than KVM internals.

Makes sense. Changed.

Thanks for your reviews.

~ Sid.



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



