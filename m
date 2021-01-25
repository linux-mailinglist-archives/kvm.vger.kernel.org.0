Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 673D2302B62
	for <lists+kvm@lfdr.de>; Mon, 25 Jan 2021 20:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731669AbhAYTR5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jan 2021 14:17:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731627AbhAYTRm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jan 2021 14:17:42 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D1AFC0613D6
        for <kvm@vger.kernel.org>; Mon, 25 Jan 2021 11:16:53 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id w18so8968598pfu.9
        for <kvm@vger.kernel.org>; Mon, 25 Jan 2021 11:16:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GPFF4+ApYJKd0sMeuaVpzSX6I9LVOuoxJIOOVLp+B2I=;
        b=T1hEdRoF5G4CbNCl5SBggNOkaExboB7G5Tfhsqv3f+EMcGMGYzvW+O8YhkmrcXQWia
         Z+vkGrxt2UM4FPZTKZ51elaw5NLe1brolBtY3aS80aLzYIcE77LblfYAUNCn90sJO0Lb
         bDEIFEYN5sBrE0edfcjkVhmnpguRdz9CMDnLs38WCN5krAEbBxbe0lj4s5+fKBGssRdt
         Q5oCJX//trU0M1tXzp1Q5zlkZyikOqiQGTJtlWNxIzK7sU7nqljxu6K5D1HPVW/CM6C9
         X2w1NI0Sm8yEuLqGfC2Qn0IhH+5sOHiq2EPcAabxl9+Yjf1vZOzUwpgA1N2qzhR/koG6
         aUTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GPFF4+ApYJKd0sMeuaVpzSX6I9LVOuoxJIOOVLp+B2I=;
        b=N3gexusuaKt4lluziI539hyDPv/CwJ0ZO7zMLqf83RtacdjIhkrddiHq+qISLValel
         ds2LQRC2x0NVjLVNwkUokVQQQFI2JeLxC+a/JDyKEcuVNEV+P5cmqq+FerOLK0Bo/u7s
         RaqatDUxq85VvLzfe3uBE/Jx52guuNPVUtAfQLZyvlI/oCCYvjFSQk0Fy/13/Usj/MGU
         Eyhn6MRPY1V9ZdN+pFmrLI9OwDl3RSGxrZAiw6FfNj7yJzScB0Fuo0sDZil1xVtWxvze
         4zMmrQ0FSaqIobVDGXZDz2tZAdcF5rN1Kk/Q6rMZ+hGjH8fEh6ENGCjWaAE8XS5ZsrNq
         umXw==
X-Gm-Message-State: AOAM530KSzAgMwFn/+K/HNO6Oz0o1C49XqpMEaijaHLPuRryddGpR7k7
        Ni3ADrYr39Dxb62EX69BpK7tWg==
X-Google-Smtp-Source: ABdhPJxXhCE2gVrKO5qd2dSwHXSulAcAqTDs7vXvwWnKhHNYlsMnp3/9FNoVoHBRl7C++dwg3jz5qw==
X-Received: by 2002:a62:f243:0:b029:1c2:8424:2495 with SMTP id y3-20020a62f2430000b02901c284242495mr1402663pfl.32.1611602212971;
        Mon, 25 Jan 2021 11:16:52 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id c5sm144104pjo.4.2021.01.25.11.16.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 11:16:52 -0800 (PST)
Date:   Mon, 25 Jan 2021 11:16:46 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: allow KVM_REQ_GET_NESTED_STATE_PAGES outside
 guest mode for VMX
Message-ID: <YA8ZHrh9ca0lPJgk@google.com>
References: <20210125172044.1360661-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210125172044.1360661-1-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 25, 2021, Paolo Bonzini wrote:
> +static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
> +{
> +	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
> +	struct vcpu_vmx *vmx = to_vmx(vcpu);
> +	struct kvm_host_map *map;
> +	struct page *page;
> +	u64 hpa;
> +
> +	if (!nested_get_evmcs_page(vcpu))
> +		return false;
>  
>  	if (nested_cpu_has2(vmcs12, SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES)) {
>  		/*
> @@ -3224,6 +3233,17 @@ static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
>  	return true;
>  }
>  
> +static bool vmx_get_nested_state_pages(struct kvm_vcpu *vcpu)
> +{
> +	if (!nested_get_evmcs_page(vcpu))
> +		return false;
> +
> +	if (is_guest_mode(vcpu) && !nested_get_vmcs12_pages(vcpu))
> +		return false;

nested_get_evmcs_page() will get called twice in the common case of
is_guest_mode() == true.  I can't tell if that will ever be fatal, but it's
definitely weird.  Maybe this?

	if (!is_guest_mode(vcpu))
		return nested_get_evmcs_page(vcpu);

	return nested_get_vmcs12_pages(vcpu);

> +
> +	return true;
> +}
> +
>  static int nested_vmx_write_pml_buffer(struct kvm_vcpu *vcpu, gpa_t gpa)
>  {
>  	struct vmcs12 *vmcs12;
> @@ -6602,7 +6622,7 @@ struct kvm_x86_nested_ops vmx_nested_ops = {
>  	.hv_timer_pending = nested_vmx_preemption_timer_pending,
>  	.get_state = vmx_get_nested_state,
>  	.set_state = vmx_set_nested_state,
> -	.get_nested_state_pages = nested_get_vmcs12_pages,
> +	.get_nested_state_pages = vmx_get_nested_state_pages,
>  	.write_log_dirty = nested_vmx_write_pml_buffer,
>  	.enable_evmcs = nested_enable_evmcs,
>  	.get_evmcs_version = nested_get_evmcs_version,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 9a8969a6dd06..b910aa74ee05 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8802,9 +8802,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  
>  	if (kvm_request_pending(vcpu)) {
>  		if (kvm_check_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu)) {
> -			if (WARN_ON_ONCE(!is_guest_mode(vcpu)))
> -				;
> -			else if (unlikely(!kvm_x86_ops.nested_ops->get_nested_state_pages(vcpu))) {
> +			if (unlikely(!kvm_x86_ops.nested_ops->get_nested_state_pages(vcpu))) {
>  				r = 0;
>  				goto out;
>  			}
> -- 
> 2.26.2
> 
