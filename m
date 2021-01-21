Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C22472FF7E7
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 23:28:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726601AbhAUW2E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 17:28:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725831AbhAUW1v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jan 2021 17:27:51 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B6A1C06174A
        for <kvm@vger.kernel.org>; Thu, 21 Jan 2021 14:27:11 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id m5so2583634pjv.5
        for <kvm@vger.kernel.org>; Thu, 21 Jan 2021 14:27:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4ppc5Md8BvebB+MZtUMRBPmAmSwoEORTvPTLdx/g6M4=;
        b=iKmLiJn3ePmZ7GFHXaZYAc2PLwIYXXAMMjTLIshUuLDdK7zvgz5h9JOjMcLWk6fylu
         Pd0oAum02+cT/8vZhebXFQ1PXB80xxEiY6N9UdkJGRiLGN/lz5Bu6HNjKB+56lzrLEOb
         q3Z3GNhRAUCoaFvMv6FyxEckVExzofEGzpL13WDWy6+m3oa4NUpk/gss9Ekkfh+m7IVs
         rqHYhSLPjfNH48v2APc/tAv+tTBdMao33tugri25Bd/akwW1zLdRvf0FAD6IijLUiBZZ
         EuhbhJWR9wplmCHQ0M9mgXyX7VLek7LGI3RVgICx0G6oFsm6BvXoNfY4pTSCdj2kVqtP
         y+vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4ppc5Md8BvebB+MZtUMRBPmAmSwoEORTvPTLdx/g6M4=;
        b=VydZSafK1CWAXfRRrxi/WEcFezTGOkacI0hSYKnAJ+0LewZX5aMwXP85fJTfbtqbz+
         plaYwcRaLcwutQhNu0F/QCAmoYX/p5zqZ/GUCkrAfV1zCQvDxSxFy3cuRHT9K2I6m+M7
         vE9gOksxIwXCIo5+CmUVfjgFyK0i6cZX5VXMNPKq1QDZmyz/hp6eUIN7snim8T96jsSY
         UtlGmqNLb/B/a/N97GjU8SYEwor9aEiGYEwfJyPFx5S8+dKAYz1WSb+AJR9dG54vrYQN
         0g1mUnK7NmfuehO9GRkGXe0Y2H9sGWHxwXM+WqorhL7ZXv3t8ztQujx67yqeo0RZfeMU
         7bIQ==
X-Gm-Message-State: AOAM531tLuUhgndP+dp1Ry9UN76dp05pFj83lclA/AJMIoG9ph/8NTPH
        CeuO54co8dEGFQWeNvLsDsBXlw==
X-Google-Smtp-Source: ABdhPJwvyNaz1zOS5my9zs8R0FbVHaJZQV2odoqWq92yGoe1JWplk5V+H3ou5bp3Ivu+6ExZVoSDPg==
X-Received: by 2002:a17:90a:9602:: with SMTP id v2mr1777159pjo.28.1611268030472;
        Thu, 21 Jan 2021 14:27:10 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id m77sm6028461pfd.82.2021.01.21.14.27.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 14:27:09 -0800 (PST)
Date:   Thu, 21 Jan 2021 14:27:03 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH 2/2] KVM: nVMX: trace nested vm entry
Message-ID: <YAn/t7TWP0xmVEHs@google.com>
References: <20210121171043.946761-1-mlevitsk@redhat.com>
 <20210121171043.946761-3-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210121171043.946761-3-mlevitsk@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 21, 2021, Maxim Levitsky wrote:
> This is very helpful to debug nested VMX issues.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/trace.h      | 30 ++++++++++++++++++++++++++++++
>  arch/x86/kvm/vmx/nested.c |  5 +++++
>  arch/x86/kvm/x86.c        |  3 ++-
>  3 files changed, 37 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> index 2de30c20bc264..ec75efdac3560 100644
> --- a/arch/x86/kvm/trace.h
> +++ b/arch/x86/kvm/trace.h
> @@ -554,6 +554,36 @@ TRACE_EVENT(kvm_nested_vmrun,
>  		__entry->npt ? "on" : "off")
>  );
>  
> +
> +/*
> + * Tracepoint for nested VMLAUNCH/VMRESUME
> + */
> +TRACE_EVENT(kvm_nested_vmenter,
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

I still don't see why VMX can't share this with SVM.  "npt' can easily be "tdp",
differentiating between VMCB and VMCS can be down with ISA, and VMX can give 0
for int_ctl (or throw in something else interesting/relevant).

	trace_kvm_nested_vmenter(kvm_rip_read(vcpu),
				 vmx->nested.current_vmptr,
				 vmcs12->guest_rip,
				 0,
				 vmcs12->vm_entry_intr_info_field,
			 	 nested_cpu_has_ept(vmcs12),
				 KVM_ISA_VMX);

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 2de30c20bc26..90f7cdb31fc1 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -522,12 +522,12 @@ TRACE_EVENT(kvm_pv_eoi,
 );

 /*
- * Tracepoint for nested VMRUN
+ * Tracepoint for nested VM-Enter.  Note, vmcb==vmcs on VMX.
  */
-TRACE_EVENT(kvm_nested_vmrun,
+TRACE_EVENT(kvm_nested_vmenter,
            TP_PROTO(__u64 rip, __u64 vmcb, __u64 nested_rip, __u32 int_ctl,
-                    __u32 event_inj, bool npt),
-           TP_ARGS(rip, vmcb, nested_rip, int_ctl, event_inj, npt),
+                    __u32 event_inj, bool tdp, __u32 isa),
+           TP_ARGS(rip, vmcb, nested_rip, int_ctl, event_inj, tdp, isa),

        TP_STRUCT__entry(
                __field(        __u64,          rip             )
@@ -535,7 +535,8 @@ TRACE_EVENT(kvm_nested_vmrun,
                __field(        __u64,          nested_rip      )
                __field(        __u32,          int_ctl         )
                __field(        __u32,          event_inj       )
-               __field(        bool,           npt             )
+               __field(        bool,           tdp             )
+               __field(        __u32,          isa             )
        ),

        TP_fast_assign(
@@ -544,14 +545,16 @@ TRACE_EVENT(kvm_nested_vmrun,
                __entry->nested_rip     = nested_rip;
                __entry->int_ctl        = int_ctl;
                __entry->event_inj      = event_inj;
-               __entry->npt            = npt;
+               __entry->tdp            = tdp;
+               __entry->isa            = isa;
        ),

-       TP_printk("rip: 0x%016llx vmcb: 0x%016llx nrip: 0x%016llx int_ctl: 0x%08x "
-                 "event_inj: 0x%08x npt: %s",
-               __entry->rip, __entry->vmcb, __entry->nested_rip,
+       TP_printk("rip: 0x%016llx %s: 0x%016llx nrip: 0x%016llx int_ctl: 0x%08x "
+                 "event_inj: 0x%08x tdp: %s",
+               __entry->rip, __entry->isa == KVM_ISA_VMX ? "vmcs" : "vmcb",
+               __entry->vmcb, __entry->nested_rip,
                __entry->int_ctl, __entry->event_inj,
-               __entry->npt ? "on" : "off")
+               __entry->tdp ? "on" : "off")
 );

 TRACE_EVENT(kvm_nested_intercepts,


