Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC8C2FF187
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 18:14:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732160AbhAURMz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 12:12:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55861 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388314AbhAUREz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Jan 2021 12:04:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611248568;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8NT6+xrjQfFr3jwRYOCl8GsepKO+QFSiztDs2tq4R78=;
        b=ObX/kSC1brVInAc6SnhW8XRei9/3dl713lwmTfsxpem1r+hDH3C3/j3xELvNkmwPsvyZdE
        n7TJ0Q+pe4y/wKYpban2rN5C688qu6ZZBXX27TdPA8jaGPo9hGsRnZsoJaSLFp4mOs/g+W
        rJnyl3vemC0zpjs5BlVLoam+R60SjX8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-411-kUcxiQV-PyWnHhbAdi0WGA-1; Thu, 21 Jan 2021 12:02:42 -0500
X-MC-Unique: kUcxiQV-PyWnHhbAdi0WGA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 13F44193410D;
        Thu, 21 Jan 2021 17:02:41 +0000 (UTC)
Received: from starship (unknown [10.35.206.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D7A436E51D;
        Thu, 21 Jan 2021 17:02:37 +0000 (UTC)
Message-ID: <a0700f17c9e0047474cf48f2c00723095fbdf42a.camel@redhat.com>
Subject: Re: [PATCH v2 2/3] KVM: nVMX: add kvm_nested_vmlaunch_resume
 tracepoint
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>
Date:   Thu, 21 Jan 2021 19:02:36 +0200
In-Reply-To: <YADeT8+fssKw3SSi@google.com>
References: <20210114205449.8715-1-mlevitsk@redhat.com>
         <20210114205449.8715-3-mlevitsk@redhat.com> <YADeT8+fssKw3SSi@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-01-14 at 16:14 -0800, Sean Christopherson wrote:
> On Thu, Jan 14, 2021, Maxim Levitsky wrote:
> > This is very helpful for debugging nested VMX issues.
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  arch/x86/kvm/trace.h      | 30 ++++++++++++++++++++++++++++++
> >  arch/x86/kvm/vmx/nested.c |  6 ++++++
> >  arch/x86/kvm/x86.c        |  1 +
> >  3 files changed, 37 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> > index 2de30c20bc264..663d1b1d8bf64 100644
> > --- a/arch/x86/kvm/trace.h
> > +++ b/arch/x86/kvm/trace.h
> > @@ -554,6 +554,36 @@ TRACE_EVENT(kvm_nested_vmrun,
> >  		__entry->npt ? "on" : "off")
> >  );
> >  
> > +
> > +/*
> > + * Tracepoint for nested VMLAUNCH/VMRESUME
> 
> VM-Enter, as below.

Will do

> 
> > + */
> > +TRACE_EVENT(kvm_nested_vmlaunch_resume,
> 
> s/vmlaunc_resume/vmenter, both for consistency with other code and so that it
> can sanely be reused by SVM.  IMO, trace_kvm_entry is wrong :-).
SVM already has trace_kvm_nested_vmrun and it contains some SVM specific
stuff that doesn't exist on VMX and vise versa.
So I do want to keep these trace points separate.


> 
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
> > +);
> > +
> > +
> >  TRACE_EVENT(kvm_nested_intercepts,
> >  	    TP_PROTO(__u16 cr_read, __u16 cr_write, __u32 exceptions,
> >  		     __u32 intercept1, __u32 intercept2, __u32 intercept3),
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index 776688f9d1017..cd51b66480d52 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -3327,6 +3327,12 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
> >  		!(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
> >  		vmx->nested.vmcs01_guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
> >  
> > +	trace_kvm_nested_vmlaunch_resume(kvm_rip_read(vcpu),
> 
> Hmm, won't this RIP be wrong for the migration case?  I.e. it'll be L2, not L1
> as is the case for the "true" nested VM-Enter path.

> 
> > +					 vmx->nested.current_vmptr,
> > +					 vmcs12->guest_rip,
> > +					 vmcs12->vm_entry_intr_info_field);
> 
> The placement is a bit funky.  I assume you put it here so that calls from
> vmx_set_nested_state() also get traced.  But, that also means
> vmx_pre_leave_smm() will get traced, and it also creates some weirdness where
> some nested VM-Enters that VM-Fail will get traced, but others will not.
> 
> Tracing vmx_pre_leave_smm() isn't necessarily bad, but it could be confusing,
> especially if the debugger looks up the RIP and sees RSM.  Ditto for the
> migration case.
> 
> Not sure what would be a good answer.
> 
> > +
> > +
> >  	/*
> >  	 * Overwrite vmcs01.GUEST_CR3 with L1's CR3 if EPT is disabled *and*
> >  	 * nested early checks are disabled.  In the event of a "late" VM-Fail,
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index a480804ae27a3..7c6e94e32100e 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -11562,6 +11562,7 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_inj_virq);
> >  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_page_fault);
> >  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_msr);
> >  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_cr);
> > +EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmlaunch_resume);
> >  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmrun);
> >  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmexit);
> >  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmexit_inject);
> > -- 
> > 2.26.2
> > 


