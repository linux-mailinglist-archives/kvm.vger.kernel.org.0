Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41CB62F6F55
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 01:15:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731244AbhAOAO5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 19:14:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731234AbhAOAO4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 19:14:56 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9CC2C061757
        for <kvm@vger.kernel.org>; Thu, 14 Jan 2021 16:14:15 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id ce17so1892515pjb.5
        for <kvm@vger.kernel.org>; Thu, 14 Jan 2021 16:14:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KjTgwkzBYZCLbovtrDF6F+LwwNKyLuyTRzFitWMOVgM=;
        b=kmz19A6Q2anZ421GIf4Df+T/bqdUhKy2kjKUBzGJgsH/+MwUHlWSioY0qSBDOFC8kW
         cGgZ6VFOxZsKIndEO8y6JS4njUbbMVw6OpOPW9F2jsWhaewrJXKRN9UYEzFJutIcR+eK
         BT4dKftc63ByI3bqYcHWHnAjdXGgxOQmyCVme7rMFbdz0R/CV0HL4/9n2Vvwg0b03sSO
         Ndk4+pkWd5OvfdZrbIY6PERF2+kVQCzBWcxBFf5Ia+W5fXi160lAfwLZIlJm4oTQuwvV
         CvkuBAOo8cNTzZ0VfBKeFwbS12RzRhEdDByQot0xLrOslbA7QjPmfwddHwuDGcppiOWi
         /XmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KjTgwkzBYZCLbovtrDF6F+LwwNKyLuyTRzFitWMOVgM=;
        b=FZX/II0TAFIrLys8Kia8G94JkYhhP3e85KX5U2cLHTT4axQzRqDaVxflfQDzz/R3Nl
         t9G4FoaWFtMVRdp0WZwOFoseoXBjS4VV3Nb8u2Vzm6HQT+dok81RR+Fy86qNaLUTjiNJ
         So3j66PfrOu+x5vLIM6KN78N68iGPDEqMfURwOaRDXevatt8KIOwW7X4pU1z9W3pqP6Q
         76ukT2dnVPBpsgeQCA8DskZagkRUN01HFil0zuJgMgSZmRvR6pR4g7XZTpMjHVdvO3jL
         f2CAtVJD9L/vfosN/OH6hN98p9hdj3SsTMF3ukN57srNQUfe3vA0XGO7szvP1Ex7F8Ae
         LuXg==
X-Gm-Message-State: AOAM531UPxjrO6jJaq5fg85eilwudUoI/9WTmn9qMCG3otINy72vMohH
        mAbFJIuK1+mqiN3jncHiYyrzTQ==
X-Google-Smtp-Source: ABdhPJyXekExfB/xC+XO2x4zmoeOIqZGeJ7KQJUOGmd5mznVwinXbQxKa+BjzmbikCYFWIWU1uoJ7g==
X-Received: by 2002:a17:902:eb53:b029:da:da92:c187 with SMTP id i19-20020a170902eb53b02900dada92c187mr9862639pli.34.1610669655265;
        Thu, 14 Jan 2021 16:14:15 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id n7sm6299616pfn.141.2021.01.14.16.14.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 16:14:14 -0800 (PST)
Date:   Thu, 14 Jan 2021 16:14:07 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v2 2/3] KVM: nVMX: add kvm_nested_vmlaunch_resume
 tracepoint
Message-ID: <YADeT8+fssKw3SSi@google.com>
References: <20210114205449.8715-1-mlevitsk@redhat.com>
 <20210114205449.8715-3-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210114205449.8715-3-mlevitsk@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 14, 2021, Maxim Levitsky wrote:
> This is very helpful for debugging nested VMX issues.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/trace.h      | 30 ++++++++++++++++++++++++++++++
>  arch/x86/kvm/vmx/nested.c |  6 ++++++
>  arch/x86/kvm/x86.c        |  1 +
>  3 files changed, 37 insertions(+)
> 
> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> index 2de30c20bc264..663d1b1d8bf64 100644
> --- a/arch/x86/kvm/trace.h
> +++ b/arch/x86/kvm/trace.h
> @@ -554,6 +554,36 @@ TRACE_EVENT(kvm_nested_vmrun,
>  		__entry->npt ? "on" : "off")
>  );
>  
> +
> +/*
> + * Tracepoint for nested VMLAUNCH/VMRESUME

VM-Enter, as below.

> + */
> +TRACE_EVENT(kvm_nested_vmlaunch_resume,

s/vmlaunc_resume/vmenter, both for consistency with other code and so that it
can sanely be reused by SVM.  IMO, trace_kvm_entry is wrong :-).

> +	    TP_PROTO(__u64 rip, __u64 vmcs, __u64 nested_rip,
> +		     __u32 entry_intr_info),
> +	    TP_ARGS(rip, vmcs, nested_rip, entry_intr_info),
> +
> +	TP_STRUCT__entry(
> +		__field(	__u64,		rip		)
> +		__field(	__u64,		vmcs		)
> +		__field(	__u64,		nested_rip	)
> +		__field(	__u32,		entry_intr_info	)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->rip			= rip;
> +		__entry->vmcs			= vmcs;
> +		__entry->nested_rip		= nested_rip;
> +		__entry->entry_intr_info	= entry_intr_info;
> +	),
> +
> +	TP_printk("rip: 0x%016llx vmcs: 0x%016llx nrip: 0x%016llx "
> +		  "entry_intr_info: 0x%08x",
> +		__entry->rip, __entry->vmcs, __entry->nested_rip,
> +		__entry->entry_intr_info)
> +);
> +
> +
>  TRACE_EVENT(kvm_nested_intercepts,
>  	    TP_PROTO(__u16 cr_read, __u16 cr_write, __u32 exceptions,
>  		     __u32 intercept1, __u32 intercept2, __u32 intercept3),
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 776688f9d1017..cd51b66480d52 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -3327,6 +3327,12 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
>  		!(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
>  		vmx->nested.vmcs01_guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
>  
> +	trace_kvm_nested_vmlaunch_resume(kvm_rip_read(vcpu),

Hmm, won't this RIP be wrong for the migration case?  I.e. it'll be L2, not L1
as is the case for the "true" nested VM-Enter path.

> +					 vmx->nested.current_vmptr,
> +					 vmcs12->guest_rip,
> +					 vmcs12->vm_entry_intr_info_field);

The placement is a bit funky.  I assume you put it here so that calls from
vmx_set_nested_state() also get traced.  But, that also means
vmx_pre_leave_smm() will get traced, and it also creates some weirdness where
some nested VM-Enters that VM-Fail will get traced, but others will not.

Tracing vmx_pre_leave_smm() isn't necessarily bad, but it could be confusing,
especially if the debugger looks up the RIP and sees RSM.  Ditto for the
migration case.

Not sure what would be a good answer.

> +
> +
>  	/*
>  	 * Overwrite vmcs01.GUEST_CR3 with L1's CR3 if EPT is disabled *and*
>  	 * nested early checks are disabled.  In the event of a "late" VM-Fail,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a480804ae27a3..7c6e94e32100e 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11562,6 +11562,7 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_inj_virq);
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_page_fault);
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_msr);
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_cr);
> +EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmlaunch_resume);
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmrun);
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmexit);
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmexit_inject);
> -- 
> 2.26.2
> 
