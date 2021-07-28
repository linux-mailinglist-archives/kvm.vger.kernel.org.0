Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D85DF3D931B
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 18:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbhG1QYK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 12:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbhG1QYI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jul 2021 12:24:08 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94295C061764
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 09:24:06 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id m10-20020a17090a34cab0290176b52c60ddso4829331pjf.4
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 09:24:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fjhAztcxPbj6GCHCrhXV3HF94+0ZyiWrizPlj65G63M=;
        b=qiwppd0eMTb9QrwKCSnlMVBqBUBMjkk44DOkoShPQ5MmX+niLVhbP0D924t51BeEiX
         7i3RkVmGNBTFZvre/CkDvDUrbFxwF8DC1qLA4qFV0xirK0Tlnukm5FpYmvSt3Nd5AD9s
         tqD2slJO8B4KHduCH7SxiLcxZA5dm3q4UMvQj7NoZayfEGJTXnTMIF4glTocUK0EEEBN
         oyywY9Tx3N9fUmwetIk5kMnu0wq3wXoF06SJNu/7+Efvm7AAcwBM3p8nrkfKL7SeelhZ
         WE3/bgtD0nsULPRHZDrOv9HGdaxikxPhr1Jt6rJf4zn56KyRarkWvTJ5acwsaORpVyZA
         du3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fjhAztcxPbj6GCHCrhXV3HF94+0ZyiWrizPlj65G63M=;
        b=ZM+q28iADnKIwIhFsUHUKDzN2DhK8Ho0veez6KB2y1KWlGMjujKb4DMglVyd4c3dIt
         eU1Z5gdXPC132vEWY9aZ+RuyZWdyb7IzIYLMnS8BvrVw5YrTzzDMQt3WXxYu4K/M0fHU
         h0necCpYz20HTn4qgCipUAeDBJrNiIpecK1n2yrA2m0EBBqg3yW93bLNF+d716eRvjov
         5dU+nKyZGTFwX5/Z7ct9fCZejFQbU7Fd7zueetbRGvBomLKkWFBamn/ggzIDqvk1oCBT
         LnY3s/UZmu5KS1D6nturacu1MAuqUR2PE/6dxLbvPV52rl9XumYM1c60T7V2xzuSx/mg
         L+9A==
X-Gm-Message-State: AOAM5329L9F2LrCdxs5dfVI5sQGfcys7QPYAxBph8kMCdKRUTzJ9wAGa
        n66RK5uRwTwm9IOo8W5o0DlZoA==
X-Google-Smtp-Source: ABdhPJyeJel6WKLgZw3plxOQ8WoG2P48c5pdbVK988dtMXMbXt5tX8N2nWrE2BZZVjb3pINGnsDbsA==
X-Received: by 2002:a65:44c3:: with SMTP id g3mr555757pgs.233.1627489445900;
        Wed, 28 Jul 2021 09:24:05 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id q4sm472347pfn.23.2021.07.28.09.24.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 09:24:05 -0700 (PDT)
Date:   Wed, 28 Jul 2021 16:24:01 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH] KVM: x86: Exit to userspace when kvm_check_nested_events
 fails
Message-ID: <YQGEoRTfGhinO41u@google.com>
References: <20210728115317.1930332-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210728115317.1930332-1-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 28, 2021, Paolo Bonzini wrote:
> From: Jim Mattson <jmattson@google.com>

I don't think this is actually from Jim.

> If kvm_check_nested_events fails due to raising an
> EXIT_REASON_INTERNAL_ERROR, propagate it to userspace
> immediately, even if the vCPU would otherwise be sleeping.
> This happens for example when the posted interrupt descriptor
> points outside guest memory.
> 
> Reported-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 22 +++++++++++++++-------
>  1 file changed, 15 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 348452bb16bc..916c976e99ab 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9752,10 +9752,14 @@ static inline int vcpu_block(struct kvm *kvm, struct kvm_vcpu *vcpu)
>  	return 1;
>  }
>  
> -static inline bool kvm_vcpu_running(struct kvm_vcpu *vcpu)
> +static inline int kvm_vcpu_running(struct kvm_vcpu *vcpu)
>  {
> -	if (is_guest_mode(vcpu))
> -		kvm_check_nested_events(vcpu);
> +	int r;

newline

> +	if (is_guest_mode(vcpu)) {
> +		r = kvm_check_nested_events(vcpu);
> +		if (r < 0 && r != -EBUSY)
> +			return r;
> +	}
>  
>  	return (vcpu->arch.mp_state == KVM_MP_STATE_RUNNABLE &&
>  		!vcpu->arch.apf.halted);
> @@ -9770,12 +9774,16 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
>  	vcpu->arch.l1tf_flush_l1d = true;
>  
>  	for (;;) {
> -		if (kvm_vcpu_running(vcpu)) {
> -			r = vcpu_enter_guest(vcpu);
> -		} else {
> -			r = vcpu_block(kvm, vcpu);
> +		r = kvm_vcpu_running(vcpu);
> +		if (r < 0) {
> +			r = 0;
> +			break;
>  		}
>  
> +		if (r)
> +			r = vcpu_enter_guest(vcpu);
> +		else
> +			r = vcpu_block(kvm, vcpu);
>  		if (r <= 0)
>  			break;
>  
> -- 
> 2.27.0
> 
