Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAA3539062E
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 18:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234327AbhEYQHi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 May 2021 12:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230422AbhEYQHh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 May 2021 12:07:37 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D947FC061756
        for <kvm@vger.kernel.org>; Tue, 25 May 2021 09:06:04 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id r1so8254673pgk.8
        for <kvm@vger.kernel.org>; Tue, 25 May 2021 09:06:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LgVOVY2ibuyGuU/9wT6gXOqlRQyyb5+usGB0r4sYDWo=;
        b=RrfJyelQGFQ10gxDLNjm7SXx+DIwmxk6NevLQkNWMmrut40zA/RdZf1xzB54H3BJHE
         a5D4wR4VEGUIskrKVZnNE2MEhXYj9e4f21/b6gRkrt5iZH5pL+LSSQeLtMZO7XmuoRDN
         +ckoRMemeP1aW8Ui5BNNxJEbtU+E9t1llc67qUjWPQPoEOjbkcxxfu37ofHkYE4NDmMF
         7JKkDcHcM0f12uyw353MJuc1hT0HjBkVKCM5Hojk/VcAMjo14S83lopi0DLq512ou6e2
         320XDjwIb0y+zwKIrHVYwnAla8iSi5IMOOk6Se8HvqUIQN8IzxMZ2tmZuZr2tkQ5f5lA
         DK2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LgVOVY2ibuyGuU/9wT6gXOqlRQyyb5+usGB0r4sYDWo=;
        b=lo4V3HvbmsXv2qCLRye2+w/vY/mdOLRZ/ZQA5O9rWTR7uRJs4XBizdaPHK0wcIOvsO
         eSWr8kBuZhE+K7P8MkJ0KWxVcyzIz3D0HGGHYoPpWVIbkgUtRGfZ/VPxALBdLCma7SpV
         kOjakCpd7cKkgVUT310qiEkNK2W7ToszlssFXo0WIkuYmBFwsX0jBGrvh6Fz105KBquD
         IP+7yEZ2c2BlkEOcZq6YAoLkEIjw44S76WxXNRSBJ8jP0a5cYyKiOZK1HdoidGWm3V8o
         ca5Vq67mxTTWWBlhQdoP5UrdQpQIzdmcT2j7D4rnFNDjsKF7aXVwsKgG+svsU1oKSsdb
         uIaw==
X-Gm-Message-State: AOAM530LiYOE2uTHNJ3i10QyXGMXxo/fr+v8JmG0attW/c0268QMXr+p
        azQmwAuk1yLsaa/HP3Du5X3jzw==
X-Google-Smtp-Source: ABdhPJxPfpL1r4PSy4t6tPOfWDdctGgiCOwK/xTk1FvajZnTSCfgq3VdUH4BkHF6Zh2BZ4YSVR23dw==
X-Received: by 2002:aa7:8b44:0:b029:2dd:4cfc:7666 with SMTP id i4-20020aa78b440000b02902dd4cfc7666mr31201526pfd.73.1621958764164;
        Tue, 25 May 2021 09:06:04 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id h9sm12938162pja.42.2021.05.25.09.06.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 09:06:03 -0700 (PDT)
Date:   Tue, 25 May 2021 16:05:59 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ilias Stamatis <ilstam@amazon.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, mlevitsk@redhat.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        zamsden@gmail.com, mtosatti@redhat.com, dwmw@amazon.co.uk
Subject: Re: [PATCH v3 10/12] KVM: VMX: Set the TSC offset and multiplier on
 nested entry and exit
Message-ID: <YK0gZ7ugquQxm2ce@google.com>
References: <20210521102449.21505-1-ilstam@amazon.com>
 <20210521102449.21505-11-ilstam@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210521102449.21505-11-ilstam@amazon.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

"KVM: nVMX:" for the scope.

The shortlog is also a bit confusing.  I usually think of "set == write", i.e.
I expected VMWRITEs in the diff.  The nested_vmx_vmexit() case in particular is
gnarly because the actual VMWRITEs aren't captured in the diff's context.

What about combining this with the next patch that exposes the feature to L1?
E.g. "KVM: nVMX: Enable nested TSC scaling" or so.

That would avoid bikeshedding the meaning of "set", fix the goof in the next patch's
shortlog (KVM exposes the feature to L1, not L2), and eliminate an unnecessary
patch for bisection purposes.  Bisecting to a patch that exposes the feature but
doesn't introduce any actual functionality isn't all that helpful, e.g. if there
is a bug in _this_ patch then bisection will arguably point at the wrong patch.

On Fri, May 21, 2021, Ilias Stamatis wrote:
> Calculate the nested TSC offset and multiplier on entering L2 using the
> corresponding functions. Restore the L1 values on L2's exit.
> 
> Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 18 ++++++++++++++----
>  1 file changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 239154d3e4e7..f75c4174cbcf 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2532,6 +2532,15 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
>  		vmcs_write64(GUEST_IA32_PAT, vmx->vcpu.arch.pat);
>  	}
>  
> +	vcpu->arch.tsc_offset = kvm_calc_nested_tsc_offset(
> +			vcpu->arch.l1_tsc_offset,
> +			vmx_get_l2_tsc_offset(vcpu),
> +			vmx_get_l2_tsc_multiplier(vcpu));
> +
> +	vcpu->arch.tsc_scaling_ratio = kvm_calc_nested_tsc_multiplier(
> +			vcpu->arch.l1_tsc_scaling_ratio,
> +			vmx_get_l2_tsc_multiplier(vcpu));
> +
>  	vmcs_write64(TSC_OFFSET, vcpu->arch.tsc_offset);
>  	if (kvm_has_tsc_control)
>  		vmcs_write64(TSC_MULTIPLIER, vcpu->arch.tsc_scaling_ratio);
> @@ -3353,8 +3362,6 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
>  	}
>  
>  	enter_guest_mode(vcpu);
> -	if (vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_TSC_OFFSETTING)
> -		vcpu->arch.tsc_offset += vmcs12->tsc_offset;
>  
>  	if (prepare_vmcs02(vcpu, vmcs12, &entry_failure_code)) {
>  		exit_reason.basic = EXIT_REASON_INVALID_STATE;
> @@ -4462,8 +4469,11 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
>  	if (nested_cpu_has_preemption_timer(vmcs12))
>  		hrtimer_cancel(&to_vmx(vcpu)->nested.preemption_timer);
>  
> -	if (vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_TSC_OFFSETTING)
> -		vcpu->arch.tsc_offset -= vmcs12->tsc_offset;
> +	if (nested_cpu_has(vmcs12, CPU_BASED_USE_TSC_OFFSETTING)) {
> +		vcpu->arch.tsc_offset = vcpu->arch.l1_tsc_offset;
> +		if (nested_cpu_has2(vmcs12, SECONDARY_EXEC_TSC_SCALING))
> +			vcpu->arch.tsc_scaling_ratio = vcpu->arch.l1_tsc_scaling_ratio;
> +	}
>  
>  	if (likely(!vmx->fail)) {
>  		sync_vmcs02_to_vmcs12(vcpu, vmcs12);
> -- 
> 2.17.1
> 
