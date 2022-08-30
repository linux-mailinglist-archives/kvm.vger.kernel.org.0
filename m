Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 345375A6E78
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 22:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbiH3Ubd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 16:31:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiH3Ubb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 16:31:31 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEB0685FAF
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 13:31:24 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id y141so12473374pfb.7
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 13:31:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=VhQjP7vAYE+SlD5yTLJPVb2a2QXgO+i5i5rQOlbyqVs=;
        b=oHG83udHI7eDbQ7ovNoh62uso4MlGXGW3ST5K3qj5aVf8jdUVrL82V1xSVRo4RxGF4
         HKmOyxxHWFcXgEZ9n1inL/AFlOUGRsPAea7x2OrWjRmXcvC8LhyP5xuLeyI7v+SrAwoi
         G0f5cvK77y9i7of4+HUlCHMvHl75QqtVXLoHc4Tnp3g6N3j9TNSbqt+K2RoGg+uippDZ
         5uNv84C8swb4S+kDJ3iHTgjEx4viZOIaDP4OPsdSIcMMsniMwzwVOpE46hSCq8DibwNc
         7WIV0SJlrvD7o23Xk0ehNJShVTrkX//NoNM3scQe+zt1JnzKb75PVOd5LgcBdoSwRD+/
         a4DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=VhQjP7vAYE+SlD5yTLJPVb2a2QXgO+i5i5rQOlbyqVs=;
        b=JT4SSqwg+xDUktYkpukEPwtBBvgsoQwUs8o97B5Yf0OyvhpAg/vJVqmvbF3/fjaNhx
         GgKnCyz91th25+IDwejjFrNYlSaR9n+4veLhBNT23Au2y0bLfeago2GcegYwObJeplz+
         BZCyM+7mLIk7zXuwfO8pdulD4+souEi6bIA3id8kaUCP+g/MjPkeMhFlJQi90+v7AEDC
         Iv+wZ9KlJXTb+Kw6VnyTH7RIce36ZPzSUzPrMgMKNX4Ecui4AbHbB9wvE9yK8Lwk88AV
         Pmi7WthgQL+M6ajQQ7crTyl/GGuiCp8iW2PtKAl4duRoADKAOn8+RvW44k3SHfgiOJWM
         swSQ==
X-Gm-Message-State: ACgBeo38/ErumHtzNhP1QHf0xM1fc8hrscj6MflZXbHDt5Bp9sXCoIoV
        cUoT3dMiuDt82Ch98dvn+Nw+7w==
X-Google-Smtp-Source: AA6agR79SICm6XYVf2AnNWrs6lG/SRQDnoGalyORXXW/0+eak3TigV619GMNLL8yaphShcmSMl/pZw==
X-Received: by 2002:a65:588d:0:b0:42a:2778:164f with SMTP id d13-20020a65588d000000b0042a2778164fmr20096338pgu.616.1661891484242;
        Tue, 30 Aug 2022 13:31:24 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id ik30-20020a170902ab1e00b0016bdc98730bsm10065152plb.151.2022.08.30.13.31.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 13:31:23 -0700 (PDT)
Date:   Tue, 30 Aug 2022 20:31:20 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v4 1/3] KVM: x86: Update trace function for nested VM
 entry to support VMX
Message-ID: <Yw5zmL1MVyAvjeCf@google.com>
References: <20220825225755.907001-1-mizhang@google.com>
 <20220825225755.907001-2-mizhang@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220825225755.907001-2-mizhang@google.com>
X-Spam-Status: No, score=-14.9 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 25, 2022, Mingwei Zhang wrote:
> Update trace function for nested VM entry to support VMX. Existing trace
> function only supports nested VMX and the information printed out is AMD
> specific.
> 
> So, update trace_kvm_nested_vmrun() to trace_kvm_nested_vmenter(), since
> 'vmenter' is generic. Add a new field 'isa' to recognize Intel and AMD;
> Update the output to print out VMX/SVM related naming respectively, eg.,
> vmcb vs. vmcs; npt vs. ept.
> 
> Opportunistically update the call site of trace_kvm_nested_vmenter() to make
> one line per parameter.
> 
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> ---
>  arch/x86/kvm/svm/nested.c |  6 ++++--
>  arch/x86/kvm/trace.h      | 28 ++++++++++++++++++----------
>  arch/x86/kvm/x86.c        |  2 +-
>  3 files changed, 23 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 76dcc8a3e849..835c508eed8e 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -781,11 +781,13 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  	int ret;
>  
> -	trace_kvm_nested_vmrun(svm->vmcb->save.rip, vmcb12_gpa,
> +	trace_kvm_nested_vmenter(svm->vmcb->save.rip,
> +			       vmcb12_gpa,
>  			       vmcb12->save.rip,
>  			       vmcb12->control.int_ctl,
>  			       vmcb12->control.event_inj,
> -			       vmcb12->control.nested_ctl);
> +			       vmcb12->control.nested_ctl,
> +			       KVM_ISA_SVM);

Align indentation.

>  
>  	trace_kvm_nested_intercepts(vmcb12->control.intercepts[INTERCEPT_CR] & 0xffff,
>  				    vmcb12->control.intercepts[INTERCEPT_CR] >> 16,
> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> index 2120d7c060a9..e7f0da9474f0 100644
> --- a/arch/x86/kvm/trace.h
> +++ b/arch/x86/kvm/trace.h
> @@ -589,10 +589,11 @@ TRACE_EVENT(kvm_pv_eoi,
>  /*
>   * Tracepoint for nested VMRUN
>   */
> -TRACE_EVENT(kvm_nested_vmrun,
> +TRACE_EVENT(kvm_nested_vmenter,
>  	    TP_PROTO(__u64 rip, __u64 vmcb, __u64 nested_rip, __u32 int_ctl,
> -		     __u32 event_inj, bool npt),
> -	    TP_ARGS(rip, vmcb, nested_rip, int_ctl, event_inj, npt),
> +		     __u32 event_inj, bool tdp_enabled, __u32 isa),
> +	    TP_ARGS(rip, vmcb, nested_rip, int_ctl, event_inj, tdp_enabled,
> +		    isa),

Let this poke out, "isa" feels quite lonely here.  It's a moot point when patch 3
comes along, mostly a "for future reference" thing.
 
>  	TP_STRUCT__entry(
>  		__field(	__u64,		rip		)
> @@ -600,7 +601,8 @@ TRACE_EVENT(kvm_nested_vmrun,
>  		__field(	__u64,		nested_rip	)
>  		__field(	__u32,		int_ctl		)
>  		__field(	__u32,		event_inj	)
> -		__field(	bool,		npt		)
> +		__field(	bool,		tdp_enabled	)
> +		__field(	__u32,		isa		)
>  	),
>  
>  	TP_fast_assign(
> @@ -609,14 +611,20 @@ TRACE_EVENT(kvm_nested_vmrun,
>  		__entry->nested_rip	= nested_rip;
>  		__entry->int_ctl	= int_ctl;
>  		__entry->event_inj	= event_inj;
> -		__entry->npt		= npt;
> +		__entry->tdp_enabled	= tdp_enabled;
> +		__entry->isa		= isa;
>  	),
>  
> -	TP_printk("rip: 0x%016llx vmcb: 0x%016llx nrip: 0x%016llx int_ctl: 0x%08x "
> -		  "event_inj: 0x%08x npt: %s",
> -		__entry->rip, __entry->vmcb, __entry->nested_rip,
> -		__entry->int_ctl, __entry->event_inj,
> -		__entry->npt ? "on" : "off")
> +	TP_printk("rip: 0x%016llx %s: 0x%016llx nested_rip: 0x%016llx "
> +		  "int_ctl: 0x%08x event_inj: 0x%08x nested_%s: %s",
> +		__entry->rip,
> +		__entry->isa == KVM_ISA_VMX ? "vmcs" : "vmcb",
> +		__entry->vmcb,
> +		__entry->nested_rip,
> +		__entry->int_ctl,
> +		__entry->event_inj,
> +		__entry->isa == KVM_ISA_VMX ? "ept" : "npt",
> +		__entry->tdp_enabled ? "on" : "off")

Align indentation.
