Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE225890C9
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 18:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232563AbiHCQuP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 12:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236561AbiHCQuO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 12:50:14 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F4B6BF8
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 09:50:12 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id s206so15630461pgs.3
        for <kvm@vger.kernel.org>; Wed, 03 Aug 2022 09:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=jkIYKsD9lrw3uE90N/4tV6//zCQKJHpCWp1vVAkBqpg=;
        b=O1bIaiehSPJ023eJzn0byVCJzUWKRdGefLRKyjRS46PMir40fV3t3+NLw/kDLxrwJ2
         VgQwIUD4kdVWxa6cUir+v3PqxA6hDA82wt8FrnII62+OY4JgP7JNdRygd/Isd7n9uOMd
         /fzhD6PYZrOiRfY2xKOcGm3qlOcgfOlFaMttgInqfaex7BnAsL0Ca4WXlQ8xVv/WM17O
         Az7cNW/eLHZr8eofqRNxCSlvJeszlPaF7NONwZVCN5JeVvkb4JnBLaoSBeHKK0Mng7yC
         OnN2Pvgq/UWvbwyE2I7bzWuKqP5eEs+ICIiWNvXUovvFun+GmqXK6hsmxu3AWSyWWQbL
         3+Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=jkIYKsD9lrw3uE90N/4tV6//zCQKJHpCWp1vVAkBqpg=;
        b=j7HYmFEesEnpHAp9ZZrwMLRZhj765smeLmup3DUe0UHI9fPDE6d0nhj0IGrt6cRsvq
         wXl9Awymt1MQvfUzQKivMXE4tp9JEvXxcmrY3SMR5bg+AePwmUlRTL7aJrFBj/L2WRE/
         6qL3bbcZFPJILAwFRwTK3sVpbKPicEFj6negMzaTHKSEagXBNBDQym5H0oi47KF6OeSR
         r0qOBocjmnUWMD5547Vg3GXdbBsH38VczIbpdrM+ARh4RKCpLB0llVXnbAqYMVpv6bOj
         VmqbppdbpeZwFq+bnMgQIYlqdjPQnofcjgKsWw0VG0aVqwxjAh6jq2l4Drws/rzOgOK+
         o7eg==
X-Gm-Message-State: ACgBeo01SSzAaUtK6MkNcc+I6lVfHFV3VPOHBpXrJ8bhOoTQhhTETaxe
        Sh6PrlywQGjYz31ryTJxkn+5Ug==
X-Google-Smtp-Source: AA6agR6Gpgcfh7KmFXDbxj8v9aK/yRABJ1gY0ELz/5l4842hvZCikwR38aHSAZfIt8ay5GOW0u59Xw==
X-Received: by 2002:aa7:8421:0:b0:52d:344f:8674 with SMTP id q1-20020aa78421000000b0052d344f8674mr19325405pfn.60.1659545411518;
        Wed, 03 Aug 2022 09:50:11 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id o11-20020a170903210b00b0016d2db82962sm2151834ple.16.2022.08.03.09.50.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Aug 2022 09:50:11 -0700 (PDT)
Date:   Wed, 3 Aug 2022 16:50:07 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v2 1/2] KVM: nested/x86: update trace_kvm_nested_vmrun()
 to suppot VMX
Message-ID: <YuqnP318U1Cwd6qX@google.com>
References: <20220718171333.1321831-1-mizhang@google.com>
 <20220718171333.1321831-2-mizhang@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220718171333.1321831-2-mizhang@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If we want to add a unique identifier for nested x86, use "KVM: x86/nested:" to
align with the MMU and to make `grep "KVM: x86"` viable.  Ideally, we'd align with
nVMX and nSVM, but nx86 is pretty gross and looks like a typo.

I have a slight preference for using a plain "KVM: x86:", as I suspect we'll never
have enough common nested to make it worth differentiating, but I've no objection
if you want to go with "KVM: x86/nested:".

On Mon, Jul 18, 2022, Mingwei Zhang wrote:
> Update trace_kvm_nested_vmrun() to support VMX by adding a new field 'isa';
> update the output to print out VMX/SVM related naming respectively,
> eg., vmcb vs. vmcs; npt vs. ept.
> 
> In addition, print nested EPT/NPT address instead of the 1bit of nested
> ept/npt on/off. This should convey more information in the trace. When
> nested ept/npt is not used, simply print "0x0" so that we don't lose any
> information.

Adding a new field that's not related to the VMX vs. SVM change belongs in a
separate patch.

> Opportunistically update the call site of trace_kvm_nested_vmrun() to make
> one line per parameter.
> 
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> ---
>  arch/x86/kvm/svm/nested.c |  7 +++++--
>  arch/x86/kvm/trace.h      | 29 ++++++++++++++++++++---------
>  2 files changed, 25 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index ba7cd26f438f..8581164b6808 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -724,11 +724,14 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  	int ret;
>  
> -	trace_kvm_nested_vmrun(svm->vmcb->save.rip, vmcb12_gpa,
> +	trace_kvm_nested_vmrun(svm->vmcb->save.rip,
> +			       vmcb12_gpa,
>  			       vmcb12->save.rip,
>  			       vmcb12->control.int_ctl,
>  			       vmcb12->control.event_inj,
> -			       vmcb12->control.nested_ctl);
> +			       vmcb12->control.nested_ctl,
> +			       vmcb12->control.nested_cr3,
> +			       KVM_ISA_SVM);
>  
>  	trace_kvm_nested_intercepts(vmcb12->control.intercepts[INTERCEPT_CR] & 0xffff,
>  				    vmcb12->control.intercepts[INTERCEPT_CR] >> 16,
> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> index de4762517569..aac4c8bd2c3a 100644
> --- a/arch/x86/kvm/trace.h
> +++ b/arch/x86/kvm/trace.h
> @@ -580,8 +580,10 @@ TRACE_EVENT(kvm_pv_eoi,
>   */
>  TRACE_EVENT(kvm_nested_vmrun,

I think it makes sense to rename this to kvm_nested_vmenter.  VMRUN is SVM-only,
and tracepoints aren't ABI.

>  	    TP_PROTO(__u64 rip, __u64 vmcb, __u64 nested_rip, __u32 int_ctl,
> -		     __u32 event_inj, bool npt),
> -	    TP_ARGS(rip, vmcb, nested_rip, int_ctl, event_inj, npt),
> +		     __u32 event_inj, bool npt_enabled, __u64 npt_addr,
> +		     __u32 isa),
> +	    TP_ARGS(rip, vmcb, nested_rip, int_ctl, event_inj, npt_enabled,
> +		    npt_addr, isa),
>  
>  	TP_STRUCT__entry(
>  		__field(	__u64,		rip		)
> @@ -589,7 +591,9 @@ TRACE_EVENT(kvm_nested_vmrun,
>  		__field(	__u64,		nested_rip	)
>  		__field(	__u32,		int_ctl		)
>  		__field(	__u32,		event_inj	)
> -		__field(	bool,		npt		)
> +		__field(	bool,		npt_enabled	)

s/npt_enabled/tdp_enabled, or maybe ntdp_enabled?

> +		__field(	__u64,		npt_addr	)

Hmm, either

  s/npt_addr/nested_pgd

or 

  s/npt_addr/guest_pgd

"npt_addr" or "tdp_addr" is too ambiguous, e.g. it can be interpreted as the address
of a TDP page fault.

My vote would be for "guest_pgd" and then pass in the non-nested CR3 when L1 isn't
using nTDP.

> +		__field(	__u32,		isa		)
>  	),
>  
>  	TP_fast_assign(
> @@ -598,14 +602,21 @@ TRACE_EVENT(kvm_nested_vmrun,
>  		__entry->nested_rip	= nested_rip;
>  		__entry->int_ctl	= int_ctl;
>  		__entry->event_inj	= event_inj;
> -		__entry->npt		= npt;
> +		__entry->npt_enabled	= npt_enabled;
> +		__entry->npt_addr	= npt_addr;
> +		__entry->isa		= isa;
>  	),
>  
> -	TP_printk("rip: 0x%016llx vmcb: 0x%016llx nrip: 0x%016llx int_ctl: 0x%08x "
> -		  "event_inj: 0x%08x npt: %s",
> -		__entry->rip, __entry->vmcb, __entry->nested_rip,
> -		__entry->int_ctl, __entry->event_inj,
> -		__entry->npt ? "on" : "off")
> +	TP_printk("rip: 0x%016llx %s: 0x%016llx nested rip: 0x%016llx "
> +		  "int_ctl: 0x%08x event_inj: 0x%08x nested %s: 0x%016llx",

This needs to explicitly print "nTDP on/off".  As proposed, "nested ept/npt: %addr"
doesn't capture that.  (a) addr=0 is perfectly legal, and (b) addr!=0 is also legal
if nTDP isn't enabled, i.e. a non-zero nested_cr3/eptp is ignore by hardware

> +		__entry->rip,
> +		__entry->isa == KVM_ISA_VMX ? "vmcs" : "vmcb",
> +		__entry->vmcb,
> +		__entry->nested_rip,
> +		__entry->int_ctl,
> +		__entry->event_inj,
> +		__entry->isa == KVM_ISA_VMX ? "ept" : "npt",
> +		__entry->npt_enabled ? __entry->npt_addr : 0x0)
>  );
>  
>  TRACE_EVENT(kvm_nested_intercepts,
> -- 
> 2.37.0.170.g444d1eabd0-goog
> 
