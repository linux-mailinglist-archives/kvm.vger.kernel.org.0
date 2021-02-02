Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1FEC30C97C
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 19:19:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238327AbhBBSTt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 13:19:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238394AbhBBSSD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 13:18:03 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90684C0613D6
        for <kvm@vger.kernel.org>; Tue,  2 Feb 2021 10:17:23 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id q131so14877317pfq.10
        for <kvm@vger.kernel.org>; Tue, 02 Feb 2021 10:17:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=idF1iI/0Aj6wyNwjBCbePkMdBUwU00zdgCO6uffYaO4=;
        b=a5bo5poAdvk/+hy4E1MEtzCP2VsQFhJx4aO5sNGIaN1zZ7h9Y+6/uIZQwaVBATuj2r
         MADoYFRSufk2F29yng4H3CKlbm3nyCfasWUYEOOC7gLtlIp0H/avboXk21UkBqdn6TIR
         wq0cLyA/gzq4+i/S//xCYsxeBW1bpVe2+9j8s3ftT12l57B4HAmpq/2g1gvqYST8rtEw
         zkwFgthSmYiVAXKjw3/PkwiyPa+CmvXYcaMb+kdyGLh9d8V6wAk1p5lqtws/WRM5v9Qa
         Nw37HBym28ZOgyMfJxoaasRY/4Xv27aPQE+k1ki46T9Z+k2/kIVko7CX+7GbqcwkyQ1O
         VmMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=idF1iI/0Aj6wyNwjBCbePkMdBUwU00zdgCO6uffYaO4=;
        b=k+koCKLgzexXc1dMWCqcqBqrAvaMXV97o+tOm9K53uwhLQ2+mteBKcmf7zBTf+4xhe
         k+bH6SB/LD4UCK8IKsa4dpiQf3o3za87GajR0NPIGy9WxjW6hVpNbJhmtjXXg6vhgeIw
         XtwvEwtIX0JGWrOfGvQ0SDczYmxJJ7fsY50zz/OovdkK3nZ/AVwhhEKfyznKudUsM8aD
         07tJzFZJKFyqsefVt14wFI+xP7rYJuiA0JM4taa3Fg4fvddzrc1UXUXvsT6gk40lX69F
         ArtfQZ9MopEiUfhxVz/bS/IKLly7IzGLhEOwHV/n6slbBWN/Uhzt3WBloc7S/cDKlpGX
         W63w==
X-Gm-Message-State: AOAM5303/tQB8+FsiLLBThUilitjAe2ySkEupPmxZ85qxBIWE+mzkxry
        lsVNOJtVTUywK+HJ+MDXkTh9vQ==
X-Google-Smtp-Source: ABdhPJxtPn0HqiRfKB7bL+xLhoQuwpiERYdfJ/zhJK+lCWA9rL8WbHAJbZVYHye3ehl/3C1o2BR/eA==
X-Received: by 2002:aa7:92c6:0:b029:1cb:1c6f:c605 with SMTP id k6-20020aa792c60000b02901cb1c6fc605mr17478278pfa.4.1612289842810;
        Tue, 02 Feb 2021 10:17:22 -0800 (PST)
Received: from google.com ([2620:15c:f:10:e1bc:da69:2e4b:ce97])
        by smtp.gmail.com with ESMTPSA id e17sm3548821pjh.39.2021.02.02.10.17.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 10:17:22 -0800 (PST)
Date:   Tue, 2 Feb 2021 10:17:16 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 3/3] KVM: x86: move kvm_inject_gp up from kvm_set_dr to
 callers
Message-ID: <YBmXLJPPTS7yzClF@google.com>
References: <20210202165141.88275-1-pbonzini@redhat.com>
 <20210202165141.88275-4-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210202165141.88275-4-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 02, 2021, Paolo Bonzini wrote:
> Push the injection of #GP up to the callers, so that they can just use
> kvm_complete_insn_gp. __kvm_set_dr is pretty much what the callers can use
> together with kvm_complete_insn_gp, so rename it to kvm_set_dr and drop
> the old kvm_set_dr wrapper.
> 
> This allows nested VMX code, which really wanted to use __kvm_set_dr, to
> use the right function.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/svm/svm.c | 14 +++++++-------
>  arch/x86/kvm/vmx/vmx.c | 19 ++++++++++---------
>  arch/x86/kvm/x86.c     | 19 +++++--------------
>  3 files changed, 22 insertions(+), 30 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index c0d41a6920f0..818cf3babef2 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2599,6 +2599,7 @@ static int dr_interception(struct vcpu_svm *svm)
>  {
>  	int reg, dr;
>  	unsigned long val;
> +	int err;
>  
>  	if (svm->vcpu.guest_debug == 0) {
>  		/*
> @@ -2617,19 +2618,18 @@ static int dr_interception(struct vcpu_svm *svm)
>  	reg = svm->vmcb->control.exit_info_1 & SVM_EXITINFO_REG_MASK;
>  	dr = svm->vmcb->control.exit_code - SVM_EXIT_READ_DR0;
>  
> +	if (!kvm_require_dr(&svm->vcpu, dr & 15))

Purely because I suck at reading base-10 bitwise operations, can we do "dr & 0xf"?
This also creates separate logic for writes (AND versus SUB), can you also
convert the other 'dr - 16'?

Alternatively, grab the "mov to DR" flag early on, but that feels less
readable, e.g.

	mov_to_dr = dr & 0x10;
	dr &= 0xf;

> +		return 1;
> +
>  	if (dr >= 16) { /* mov to DRn */
> -		if (!kvm_require_dr(&svm->vcpu, dr - 16))
> -			return 1;
>  		val = kvm_register_read(&svm->vcpu, reg);
> -		kvm_set_dr(&svm->vcpu, dr - 16, val);
> +		err = kvm_set_dr(&svm->vcpu, dr - 16, val);
>  	} else {
> -		if (!kvm_require_dr(&svm->vcpu, dr))
> -			return 1;
> -		kvm_get_dr(&svm->vcpu, dr, &val);
> +		err = kvm_get_dr(&svm->vcpu, dr, &val);

Technically, 'err' needs to be checked, else 'reg' will theoretically be
clobbered with garbage.  I say "theoretically", because kvm_get_dr() always
returns '0'; the CR4.DE=1 behavior is handled by kvm_require_dr(), presumably
due to it being a #UD instead of #GP.  AFAICT, you can simply add a prep patch
to change the return type to void.

Side topic, is the kvm_require_dr() check needed on SVM interception?  The APM
states:

  All normal exception checks take precedence over the by implicit DR6/DR7 writes.)

I can't find anything that would suggest the CR4.DE=1 #UD isn't a "normal"
exception.

>  		kvm_register_write(&svm->vcpu, reg, val);
>  	}
>  
> -	return kvm_skip_emulated_instruction(&svm->vcpu);
> +	return kvm_complete_insn_gp(&svm->vcpu, err);
>  }
>  
>  static int cr8_write_interception(struct vcpu_svm *svm)
