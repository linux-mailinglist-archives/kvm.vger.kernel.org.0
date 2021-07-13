Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 900DB3C76FB
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 21:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234776AbhGMTgM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 15:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234172AbhGMTgM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 15:36:12 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F15B8C0613EE
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 12:33:21 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id 21so20558913pfp.3
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 12:33:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=N0sTfKKyE0+JAut7zXsvgnlkS/bdeOAiaAnE0HjBo3Q=;
        b=ZrqS9e5z8WA9MdXrss28wbIf+rlilE8R81QX10ZcTKLpeNys78DSMzebQTZX/DM7Xh
         lfiSWubTeELe9rZW8xKA2MrjfQ0x0wu7FfSgJ4BRj1Die1VytFGSJom20Za/69qEU0Fv
         EVWyK56AgIja8WE0ruQLKGjKZRgMAfNv1UOer6xr6lpqN6cpZ1qCZt//+EinVl0HHcUW
         dS7PiZOMZZa09FjJHbtss3N8QV09hDgMAoaOJotOax+wK4Fzu4muecJFhisRmfTLnbQN
         /+FiYlIbYf5Ev1TrLau5/uwy9UvDAP3PRSzOzj3prZSFenvGLZr61lylf1p0wcyLEY13
         Cr2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=N0sTfKKyE0+JAut7zXsvgnlkS/bdeOAiaAnE0HjBo3Q=;
        b=W7AvPzYla1iHchL1TJ16BUCyLZhPh9Ktl0rd2pJTs2NlJN9UK04RwGztSewaSTwZhQ
         XD3LT2+fw+fRyrYjnTE89k+RcLSnE/rnz/sYx1soAuRlbfrPkIwWcKMtDcHqW/pvNu47
         RQE61rLS3dye4NWpkTpgPfGHowQadMbBZzVetRZyH5ugWCJaSy9gKMs1Tb8xWHkZ0+OK
         R6kBOElVx4wmZ/aEAwTE/HR7PtLcbAgsvVM7ybIqDfPcWxMwFNItykpkFt5xwa6cg+e/
         gefSz9WWsYxf1G4QTUl+6zPZWX8GU4UA0+rxl/to36TGBs4xHX4bflVX5yxhtPOFPdvK
         4GKA==
X-Gm-Message-State: AOAM533CwKCpOY8yPlDDJlwa2ligWC7b1986kiJdIyGEu3lKr0frtlnC
        wzyA1OVqfaVPUeugMjpsZr6zJQ==
X-Google-Smtp-Source: ABdhPJxkR7/Z8wic9CB4fffLr4H+t5wMq+9SEeVm7uxYMaFaa6yDEqefL2/S8c56ikKQRnpi6H6kVg==
X-Received: by 2002:a63:5f11:: with SMTP id t17mr5807364pgb.37.1626204801148;
        Tue, 13 Jul 2021 12:33:21 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id r10sm20278553pff.7.2021.07.13.12.33.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jul 2021 12:33:20 -0700 (PDT)
Date:   Tue, 13 Jul 2021 19:33:16 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     isaku.yamahata@intel.com
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        isaku.yamahata@gmail.com
Subject: Re: [RFC PATCH v2 08/69] KVM: TDX: add trace point before/after TDX
 SEAMCALLs
Message-ID: <YO3qfA6AjrDP33x+@google.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <28a0ae6b767260fcb410c6ddff7de84f4e13062c.1625186503.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28a0ae6b767260fcb410c6ddff7de84f4e13062c.1625186503.git.isaku.yamahata@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 02, 2021, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/kvm/trace.h         | 80 ++++++++++++++++++++++++++++++
>  arch/x86/kvm/vmx/seamcall.h  | 22 ++++++++-
>  arch/x86/kvm/vmx/tdx_arch.h  | 47 ++++++++++++++++++
>  arch/x86/kvm/vmx/tdx_errno.h | 96 ++++++++++++++++++++++++++++++++++++
>  arch/x86/kvm/x86.c           |  2 +
>  5 files changed, 246 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> index 4f839148948b..c3398d0de9a7 100644
> --- a/arch/x86/kvm/trace.h
> +++ b/arch/x86/kvm/trace.h
> @@ -8,6 +8,9 @@
>  #include <asm/clocksource.h>
>  #include <asm/pvclock-abi.h>
>  
> +#include "vmx/tdx_arch.h"
> +#include "vmx/tdx_errno.h"
> +
>  #undef TRACE_SYSTEM
>  #define TRACE_SYSTEM kvm
>  
> @@ -659,6 +662,83 @@ TRACE_EVENT(kvm_nested_vmexit_inject,
>  		  __entry->exit_int_info, __entry->exit_int_info_err)
>  );
>  
> +/*
> + * Tracepoint for the start of TDX SEAMCALLs.
> + */
> +TRACE_EVENT(kvm_tdx_seamcall_enter,

To avoid confusion, I think it makes sense to avoid "enter" and "exit".  E.g.
my first reaction was that the tracepoint was specific to TDENTER.  And under
the hood, SEAMCALL is technically an exit :-)

What about kvm_tdx_seamcall and kvm_tdx_seamret?  If the seamret usage is too
much of a stretch, kvm_tdx_seamcall_begin/end?

> +	TP_PROTO(int cpuid, __u64 op, __u64 rcx, __u64 rdx, __u64 r8,
> +		 __u64 r9, __u64 r10),
> +	TP_ARGS(cpuid, op, rcx, rdx, r8, r9, r10),

"cpuid" is potentially confusing without looking at the caller.  pcpu or pcpu_id
would be preferable.

> diff --git a/arch/x86/kvm/vmx/seamcall.h b/arch/x86/kvm/vmx/seamcall.h
> index a318940f62ed..2c83ab46eeac 100644
> --- a/arch/x86/kvm/vmx/seamcall.h
> +++ b/arch/x86/kvm/vmx/seamcall.h
> @@ -9,12 +9,32 @@
>  #else
>  
>  #ifndef seamcall
> +#include "trace.h"
> +
>  struct tdx_ex_ret;
>  asmlinkage u64 __seamcall(u64 op, u64 rcx, u64 rdx, u64 r8, u64 r9, u64 r10,
>  			  struct tdx_ex_ret *ex);
>  
> +static inline u64 _seamcall(u64 op, u64 rcx, u64 rdx, u64 r8, u64 r9, u64 r10,
> +			    struct tdx_ex_ret *ex)
> +{
> +	u64 err;
> +
> +	trace_kvm_tdx_seamcall_enter(smp_processor_id(), op,
> +				     rcx, rdx, r8, r9, r10);
> +	err = __seamcall(op, rcx, rdx, r8, r9, r10, ex);

What was the motivation behind switching from the macro magic[*] to a dedicated
asm subroutine?  The macros are gross, but IMO they yielded much more readable
code for the upper level helpers, which is what people will look at the vast
majority of time.  E.g.

  static inline u64 tdh_sys_lp_shutdown(void)
  {
  	return seamcall(TDH_SYS_LP_SHUTDOWN, 0, 0, 0, 0, 0, NULL);
  }

  static inline u64 tdh_mem_track(hpa_t tdr)
  {
  	return seamcall(TDH_MEM_TRACK, tdr, 0, 0, 0, 0, NULL);
  }

versus

  static inline u64 tdsysshutdownlp(void)
  {
  	seamcall_0(TDSYSSHUTDOWNLP);
  }

  static inline u64 tdtrack(hpa_t tdr)
  {
  	seamcall_1(TDTRACK, tdr);
  }


The new approach also generates very suboptimal code due to the need to shuffle
registers everywhere, e.g. gcc doesn't inline _seamcall because it's a whopping
200+ bytes.

[*] https://patchwork.kernel.org/project/kvm/patch/25f0d2c2f73c20309a1b578cc5fc15f4fd6b9a13.1605232743.git.isaku.yamahata@intel.com/

> +	if (ex)
> +		trace_kvm_tdx_seamcall_exit(smp_processor_id(), op, err, ex->rcx,

smp_processor_id() is not stable since this code runs with IRQs and preemption
enabled, e.g. if the task is preempted between the tracepoint and the actual
SEAMCALL then the tracepoint may be wrong.  There could also be weirdly "nested"
tracepoints since migrating the task will generate TDH_VP_FLUSH.

> +					    ex->rdx, ex->r8, ex->r9, ex->r10,
> +					    ex->r11);
> +	else
> +		trace_kvm_tdx_seamcall_exit(smp_processor_id(), op, err,
> +					    0, 0, 0, 0, 0, 0);
> +	return err;
> +}
> +
>  #define seamcall(op, rcx, rdx, r8, r9, r10, ex)				\
> -	__seamcall(SEAMCALL_##op, (rcx), (rdx), (r8), (r9), (r10), (ex))
> +	_seamcall(SEAMCALL_##op, (rcx), (rdx), (r8), (r9), (r10), (ex))
>  #endif
