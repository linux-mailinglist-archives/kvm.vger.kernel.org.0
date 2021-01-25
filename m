Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B407F303256
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 04:02:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728772AbhAYNYX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jan 2021 08:24:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30765 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728777AbhAYNXi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 25 Jan 2021 08:23:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611580931;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Pe96sTcVv1iQlwn39Q1EDK7ZILjYkl1+OID9WuUjkZw=;
        b=Y2Bzd3O2IzIa/88uD20x3jgs3mCljLI/jX+PBKxPx3yfc+NbxCGEO51yKR9YTlSQDDgD5g
        vBvN0TjPbcHn8Xfo0k7DF23XXtSqkzgUjLHzokuSaVu/XhZI1v0iG22suaBmKHJjRNAylN
        A1VgOfZ4Wbew4qvmEJss7uEZXS5K62c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-549-1enst45LMzyoDS5FwPtgkw-1; Mon, 25 Jan 2021 08:22:08 -0500
X-MC-Unique: 1enst45LMzyoDS5FwPtgkw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 792AD107ACE3;
        Mon, 25 Jan 2021 13:22:06 +0000 (UTC)
Received: from starship (unknown [10.35.206.204])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 29F3E5C1C5;
        Mon, 25 Jan 2021 13:22:02 +0000 (UTC)
Message-ID: <f1c90d8a44795bbdef549a5fcf375bcf1d52af93.camel@redhat.com>
Subject: Thoughts on sharing KVM tracepoints [was:Re: [PATCH 2/2] KVM: nVMX:
 trace nested vm entry]
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>
Date:   Mon, 25 Jan 2021 15:22:01 +0200
In-Reply-To: <YAn/t7TWP0xmVEHs@google.com>
References: <20210121171043.946761-1-mlevitsk@redhat.com>
         <20210121171043.946761-3-mlevitsk@redhat.com> <YAn/t7TWP0xmVEHs@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-01-21 at 14:27 -0800, Sean Christopherson wrote:
> On Thu, Jan 21, 2021, Maxim Levitsky wrote:
> > This is very helpful to debug nested VMX issues.
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  arch/x86/kvm/trace.h      | 30 ++++++++++++++++++++++++++++++
> >  arch/x86/kvm/vmx/nested.c |  5 +++++
> >  arch/x86/kvm/x86.c        |  3 ++-
> >  3 files changed, 37 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> > index 2de30c20bc264..ec75efdac3560 100644
> > --- a/arch/x86/kvm/trace.h
> > +++ b/arch/x86/kvm/trace.h
> > @@ -554,6 +554,36 @@ TRACE_EVENT(kvm_nested_vmrun,
> >  		__entry->npt ? "on" : "off")
> >  );
> >  
> > +
> > +/*
> > + * Tracepoint for nested VMLAUNCH/VMRESUME
> > + */
> > +TRACE_EVENT(kvm_nested_vmenter,
> > +	    TP_PROTO(__u64 rip, __u64 vmcs, __u64 nested_rip,
> > +		     __u32 entry_intr_info),
> > +	    TP_ARGS(rip, vmcs, nested_rip, entry_intr_info),
> > +
> > +	TP_STRUCT__entry(
> > +		__field(	__u64,		rip		)
> > +		__field(	__u64,		vmcs		)
> > +		__field(	__u64,		nested_rip	)
> > +		__field(	__u32,		entry_intr_info	)
> > +	),
> > +
> > +	TP_fast_assign(
> > +		__entry->rip			= rip;
> > +		__entry->vmcs			= vmcs;
> > +		__entry->nested_rip		= nested_rip;
> > +		__entry->entry_intr_info	= entry_intr_info;
> > +	),
> > +
> > +	TP_printk("rip: 0x%016llx vmcs: 0x%016llx nrip: 0x%016llx "
> > +		  "entry_intr_info: 0x%08x",
> > +		__entry->rip, __entry->vmcs, __entry->nested_rip,
> > +		__entry->entry_intr_info)
> 
> I still don't see why VMX can't share this with SVM.  "npt' can easily be "tdp",
> differentiating between VMCB and VMCS can be down with ISA, and VMX can give 0
> for int_ctl (or throw in something else interesting/relevant).

I understand very well your point, and I don't strongly disagree with you.
However let me voice my own thoughts on this:
 
I think that sharing tracepoints between SVM and VMX isn't necessarily a good idea.
It does make sense in some cases but not in all of them.
 
The trace points are primarily intended for developers, thus they should capture as
much as possible relevant info but not everything because traces can get huge.
 
Also despite the fact that a developer will look at the traces, some usability is welcome
as well (e.g for new developers), and looking at things like info1/info2/intr_info/error_code
isn't very usable (btw the error_code should at least be called intr_info_error_code, and
of course both it and intr_info are VMX specific).
 
So I don't even like the fact that kvm_entry/kvm_exit are shared, and neither I want
to add even more shared trace points.
 
I understand that there are some benefits of sharing, namely a userspace tool can use
the same event to *profile* kvm, but I am not sure that this is worth it.
 
What we could have done is to have ISA (and maybe even x86) agnostic kvm_exit/kvm_entry
tracepoints that would have no data attached to them, or have very little (like maybe RIP),
and then have ISA specific tracepoints with the reset of the info.
 
Same could be applied to kvm_nested_vmenter, although for this one I don't think that we
need an ISA agnostic tracepoint.
 
Having said all that, I am not hell bent on this. If you really want it to be this way,
I won't argue that much.
 
Thoughts?


Best regards,
	Maxim Levitsky


> 
> 	trace_kvm_nested_vmenter(kvm_rip_read(vcpu),
> 				 vmx->nested.current_vmptr,
> 				 vmcs12->guest_rip,
> 				 0,
> 				 vmcs12->vm_entry_intr_info_field,
> 			 	 nested_cpu_has_ept(vmcs12),
> 				 KVM_ISA_VMX);
> 
> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> index 2de30c20bc26..90f7cdb31fc1 100644
> --- a/arch/x86/kvm/trace.h
> +++ b/arch/x86/kvm/trace.h
> @@ -522,12 +522,12 @@ TRACE_EVENT(kvm_pv_eoi,
>  );
> 
>  /*
> - * Tracepoint for nested VMRUN
> + * Tracepoint for nested VM-Enter.  Note, vmcb==vmcs on VMX.
>   */
> -TRACE_EVENT(kvm_nested_vmrun,
> +TRACE_EVENT(kvm_nested_vmenter,
>             TP_PROTO(__u64 rip, __u64 vmcb, __u64 nested_rip, __u32 int_ctl,
> -                    __u32 event_inj, bool npt),
> -           TP_ARGS(rip, vmcb, nested_rip, int_ctl, event_inj, npt),
> +                    __u32 event_inj, bool tdp, __u32 isa),
> +           TP_ARGS(rip, vmcb, nested_rip, int_ctl, event_inj, tdp, isa),
> 
>         TP_STRUCT__entry(
>                 __field(        __u64,          rip             )
> @@ -535,7 +535,8 @@ TRACE_EVENT(kvm_nested_vmrun,
>                 __field(        __u64,          nested_rip      )
>                 __field(        __u32,          int_ctl         )
>                 __field(        __u32,          event_inj       )
> -               __field(        bool,           npt             )
> +               __field(        bool,           tdp             )
> +               __field(        __u32,          isa             )
>         ),
> 
>         TP_fast_assign(
> @@ -544,14 +545,16 @@ TRACE_EVENT(kvm_nested_vmrun,
>                 __entry->nested_rip     = nested_rip;
>                 __entry->int_ctl        = int_ctl;
>                 __entry->event_inj      = event_inj;
> -               __entry->npt            = npt;
> +               __entry->tdp            = tdp;
> +               __entry->isa            = isa;
>         ),
> 
> -       TP_printk("rip: 0x%016llx vmcb: 0x%016llx nrip: 0x%016llx int_ctl: 0x%08x "
> -                 "event_inj: 0x%08x npt: %s",
> -               __entry->rip, __entry->vmcb, __entry->nested_rip,
> +       TP_printk("rip: 0x%016llx %s: 0x%016llx nrip: 0x%016llx int_ctl: 0x%08x "
> +                 "event_inj: 0x%08x tdp: %s",
> +               __entry->rip, __entry->isa == KVM_ISA_VMX ? "vmcs" : "vmcb",
> +               __entry->vmcb, __entry->nested_rip,
>                 __entry->int_ctl, __entry->event_inj,
> -               __entry->npt ? "on" : "off")
> +               __entry->tdp ? "on" : "off")
>  );
> 
>  TRACE_EVENT(kvm_nested_intercepts,
> 
> 


