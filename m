Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8977E3DBF1B
	for <lists+kvm@lfdr.de>; Fri, 30 Jul 2021 21:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbhG3ThP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jul 2021 15:37:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230429AbhG3ThO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jul 2021 15:37:14 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6266EC06175F
        for <kvm@vger.kernel.org>; Fri, 30 Jul 2021 12:37:09 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id ds11-20020a17090b08cbb0290172f971883bso22335114pjb.1
        for <kvm@vger.kernel.org>; Fri, 30 Jul 2021 12:37:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bQB6K/n3XiCpJW86J/9w4ziNmd4UkR5tlZtQYyfzmbI=;
        b=cUd/O4JrGDDli4mE7ajjQFJJBjTxS9oXQLBoLp5D/EmUdflgzkLRwnhhMFQDTYlO3X
         hkZUilcZh4EjSz2jcaGR26P9ljC2IH/JMIacbztgRExcAJn6FfH4z1Q2jImv0WVPp/qo
         wbz3nR346ColwndBJ2DHUt3TC8ecoab/UGDH8+o/G5vjqWsjQXA9qhSb6p/9ex0jlPCD
         OzYW9hhDUMVLOEygTqlEV+L//N6QxsI4o9Xy0Pp6f0h8bE8Xu1ErcKk4HYOAsuso4+tg
         BRMHtBWRvHien173s1oi7OOtrfxm0nQU0LdP0gwV4Q5wI4MZRAeZum7fTLT5g455sZZV
         bU1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bQB6K/n3XiCpJW86J/9w4ziNmd4UkR5tlZtQYyfzmbI=;
        b=CjQanZtaI2rdMZT3rrQNdND1cTg+mjGXzNRbgGfNOHwMB556tjt542HZF8aNnFEsaB
         kNivIJwM1P8omHzc+urAuXSb8Al7V+3grjQnLTOVeXpUrhbd2w/OXRaXgO9/4hZpC1dx
         8YY5gG4sLgTnKfhWUUQtwKwwJCXRw1/IIfoBWY4Q4pzPT1cAjZoFVk5ieerbQ50loq7q
         fnr8w7uFZlFrXRq/TY7smc+d4S3ZDttJcGuDWYl2SW1J7zHo5vfr1UZB6Iy1E7ERZWb6
         GF8QzRmC2DRQ5I5I+p+5nN61lVbTbvN4/wMqNXmoUPcPyBfP7Lj2T/okIDkyPjjNmKe7
         mjug==
X-Gm-Message-State: AOAM530J4Ujf95SChThjz2TyCQETNTzUPAx37O8mwiIuwily0PGKouaA
        svSkTX9IIGxrhz7WSgvuze9n6A==
X-Google-Smtp-Source: ABdhPJycaXIMTamp/Pt0Jbbuid8lcB32oy1om/hhmQifLdafX/D1j3g1Kj6iWH+1RWHZ8l3Wi1b57w==
X-Received: by 2002:a17:902:d4c5:b029:12c:6a3e:fabb with SMTP id o5-20020a170902d4c5b029012c6a3efabbmr3847226plg.11.1627673828693;
        Fri, 30 Jul 2021 12:37:08 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id b128sm3404149pfb.144.2021.07.30.12.37.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 12:37:08 -0700 (PDT)
Date:   Fri, 30 Jul 2021 19:37:04 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org
Subject: Re: [PATCH] KVM: nVMX: nSVM: Show guest mode in kvm_{entry,exit}
 tracepoints
Message-ID: <YQRU4Es38nR6vo63@google.com>
References: <20210621204345.124480-1-krish.sadhukhan@oracle.com>
 <20210621204345.124480-2-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210621204345.124480-2-krish.sadhukhan@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 21, 2021, Krish Sadhukhan wrote:
> From debugging point of view, KVM entry and exit tracepoints are important
> in that they indicate when a guest starts and exits. When L1 runs L2, there
> is no way we can determine from KVM tracing when L1 starts/exits and when
> L2 starts/exits as there is no marker in place today in those tracepoints.
> Debugging becomes even more difficult when more than one L2 run in an L1 and
> there is no way of determining which L2 from which L1 made the entries/exits.
> Therefore, showing guest mode in the entry and exit tracepoints
> will make debugging much easier.

> If an L1 runs multiple L2s, though we can not identify the specific L2 from
> the entry and exit tracepoints, we still will be able to determine whether it
> was L1 or an L2 that made the entries and the exits.

Hmm, this is a solvable problem, and might even be worth solving immediately,
e.g. kvm_x86_ops.get_vmcx12 to retrieve the L1 GPA of the vmcs12/vmcb12.
More below.

> With this patch KVM entry and exit tracepoints will show "guest_mode = 0" if
> it is a guest and "guest_mode = 1" if it is a nested guest.

Uber pedantry, but technically not true, as trace_kvm_entry() doesn't have the
'=', and in the exit tracepoint, the '=' should be dropped to be consistent with
the existing format.  Might be a moot point though.

> Signed-off-by: Krish Sdhukhan <krish.sadhukhan@oracle.com>
> ---
>  arch/x86/kvm/trace.h | 16 +++++++++++-----
>  1 file changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> index b484141ea15b..44dba26c6be2 100644
> --- a/arch/x86/kvm/trace.h
> +++ b/arch/x86/kvm/trace.h
> @@ -21,14 +21,17 @@ TRACE_EVENT(kvm_entry,
>  	TP_STRUCT__entry(
>  		__field(	unsigned int,	vcpu_id		)
>  		__field(	unsigned long,	rip		)
> +		__field(        bool,           guest_mode      )
>  	),
>  
>  	TP_fast_assign(
>  		__entry->vcpu_id        = vcpu->vcpu_id;
>  		__entry->rip		= kvm_rip_read(vcpu);
> +		__entry->guest_mode     = is_guest_mode(vcpu);
>  	),
>  
> -	TP_printk("vcpu %u, rip 0x%lx", __entry->vcpu_id, __entry->rip)
> +	TP_printk("vcpu %u, rip 0x%lx, guest_mode %d", __entry->vcpu_id,
> +		  __entry->rip, __entry->guest_mode)
>  );
>  
>  /*
> @@ -285,6 +288,7 @@ TRACE_EVENT(name,							     \
>  		__field(	u32,	        intr_info	)	     \
>  		__field(	u32,	        error_code	)	     \
>  		__field(	unsigned int,	vcpu_id         )	     \
> +		__field(        bool,           guest_mode      )            \
>  	),								     \
>  									     \
>  	TP_fast_assign(							     \
> @@ -295,15 +299,17 @@ TRACE_EVENT(name,							     \
>  		static_call(kvm_x86_get_exit_info)(vcpu, &__entry->info1,    \
>  					  &__entry->info2,		     \
>  					  &__entry->intr_info,		     \
> -					  &__entry->error_code);	     \
> +					  &__entry->error_code);     	     \
> +		__entry->guest_mode      = is_guest_mode(vcpu);		     \
>  	),								     \
>  									     \
>  	TP_printk("vcpu %u reason %s%s%s rip 0x%lx info1 0x%016llx "	     \
> -		  "info2 0x%016llx intr_info 0x%08x error_code 0x%08x",	     \
> -		  __entry->vcpu_id,					     \
> +		  "info2 0x%016llx intr_info 0x%08x error_code 0x%08x "	     \
> +		  "guest_mode = %d", __entry->vcpu_id,          	     \

I'm biased because I've never really liked is_guest_mode(), but I think guest_mode
will be confusing to users.  KVM developers are familiar with guest_mode() == L2,
but random debuggers/users are unlikely to make that connection.

A clever/heinous way to "solve" this issue and display vmcx12 iff L2 is active
would be to bastardize the L1/L2 strings and vmcx12 value formatting to yield:

  vcpu 0 reason <reason> guest L1 rip 0xfffff ...

and

  vcpu 0 reason <reason> guest L2 vmcx12 0xaaaaa rip 0xfffff ...

 
#define TRACE_EVENT_KVM_EXIT(name)					     \
TRACE_EVENT(name,							     \
	TP_PROTO(unsigned int exit_reason, struct kvm_vcpu *vcpu, u32 isa),  \
	TP_ARGS(exit_reason, vcpu, isa),				     \
									     \
	TP_STRUCT__entry(						     \
		__field(	unsigned int,	exit_reason	)	     \
		__field(	unsigned long,	guest_rip	)	     \
		__field(	u32,	        isa             )	     \
		__field(	u64,	        info1           )	     \
		__field(	u64,	        info2           )	     \
		__field(	u32,	        intr_info	)	     \
		__field(	u32,	        error_code	)	     \
		__field(	unsigned int,	vcpu_id         )	     \
		__field(	u64,	        vmcx12          )	     \
	),								     \
									     \
	TP_fast_assign(							     \
		__entry->exit_reason	= exit_reason;			     \
		__entry->guest_rip	= kvm_rip_read(vcpu);		     \
		__entry->isa            = isa;				     \
		__entry->vcpu_id        = vcpu->vcpu_id;		     \
		static_call(kvm_x86_get_exit_info)(vcpu, &__entry->info1,    \
					  &__entry->info2,		     \
					  &__entry->intr_info,		     \
					  &__entry->error_code);	     \
		__entry->vmcx12		= is_guest_mode(vcpu) ?		     \
					  static_call(kvm_x86_get_vmcx12) :  \
					  INVALID_PAGE;			     \
	),								     \
									     \
	TP_printk("vcpu %u reason %s%s%s guest %s%llx rip 0x%lx "	     \
		  "info1 0x%016llx info2 0x%016llx "			     \
		  "intr_info 0x%08x error_code 0x%08x",			     \
		  __entry->vcpu_id,					     \
		  kvm_print_exit_reason(__entry->exit_reason, __entry->isa), \
		  __entry->vmcx12 == INVALID_PAGE ? "L" : "L2 vmcx12 0x",    \
		  __entry->vmcx12 == INVALID_PAGE ? 1 : __entry->vmcx12,     \
		  __entry->guest_rip, __entry->info1, __entry->info2,	     \
		  __entry->intr_info, __entry->error_code)		     \
)
