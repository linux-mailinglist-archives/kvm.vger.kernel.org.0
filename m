Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B117C12B70
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 12:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbfECKZq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 06:25:46 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35670 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbfECKZp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 06:25:45 -0400
Received: by mail-wm1-f68.google.com with SMTP id y197so6100555wmd.0
        for <kvm@vger.kernel.org>; Fri, 03 May 2019 03:25:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=PYmUxmJ+80oKyLaivQ7A3dZXXuA+/rwnBXfp+JMX0SQ=;
        b=jwVYvpstLVzU4rVEW82rPi6f2L24SaPJuU7xYIWjqPRpV1B7oQbTPrT5uYV1UkRSM2
         omfs+oDDpLbxJSIYClE4ZbnvgkdxClzgdyZ4QCreu2kDpLd8oATaVhYbBO+O7hCrxlcK
         neHVmypnLqjkQ4xY56+SzQ5tN+dlJ+ziMHVJopzdPeja9MsTU6hFn7uKzBECi3ZrfBby
         vc/KNsxmBF+fNLho6ReOSy/X2+owfaPDcjLLmaJNJ7hw9aDzUYN39kk+mgdwLtzezMzA
         aWf0bWcGoJ7mQ8JZNQevHhFXMCGi//dbsQjbjMRB+4yAqbbvySpFOS6I8Z2XCJvcFYNl
         YMAA==
X-Gm-Message-State: APjAAAXqGyUX8DpbOKJhcCqWu+mRsuiVblcv/1XQhnfpFc/Gy9yubaxo
        MBh7WH+jSeQOPaLmdC2Jrz8x8ALMdbE=
X-Google-Smtp-Source: APXvYqx2xXnyn5HItPUHQowuJUt+Sz/NkBGW+6X3jy/2ffbxbcVqGHT7F/2xrTsxABnpL8EwEMg7PQ==
X-Received: by 2002:a1c:f311:: with SMTP id q17mr5807042wmq.144.1556879144013;
        Fri, 03 May 2019 03:25:44 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id k67sm2740806wmb.34.2019.05.03.03.25.42
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 03 May 2019 03:25:42 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     Peter Shier <pshier@google.com>, pbonzini@redhat.com,
        rkrcmar@redhat.com, jmattson@google.com, marcorr@google.com,
        kvm@vger.kernel.org
Subject: Re: [PATCH 2/3] KVM: nVMX: KVM_SET_NESTED_STATE - Tear down old EVMCS state before setting new state
In-Reply-To: <20190502183133.258026-1-aaronlewis@google.com>
References: <20190502183133.258026-1-aaronlewis@google.com>
Date:   Fri, 03 May 2019 12:25:42 +0200
Message-ID: <87zho37s2h.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Aaron Lewis <aaronlewis@google.com> writes:

> Move call to nested_enable_evmcs until after free_nested() is complete.
>
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> Reviewed-by: Marc Orr <marcorr@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 081dea6e211a..3b39c60951ac 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -5373,9 +5373,6 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
>  	if (kvm_state->format != 0)
>  		return -EINVAL;
>  
> -	if (kvm_state->flags & KVM_STATE_NESTED_EVMCS)
> -		nested_enable_evmcs(vcpu, NULL);
> -
>  	if (!nested_vmx_allowed(vcpu))
>  		return kvm_state->vmx.vmxon_pa == -1ull ? 0 : -EINVAL;
>  
> @@ -5417,6 +5414,9 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
>  	if (kvm_state->vmx.vmxon_pa == -1ull)
>  		return 0;
>  
> +	if (kvm_state->flags & KVM_STATE_NESTED_EVMCS)
> +		nested_enable_evmcs(vcpu, NULL);
> +
>  	vmx->nested.vmxon_ptr = kvm_state->vmx.vmxon_pa;
>  	ret = enter_vmx_operation(vcpu);
>  	if (ret)

nested_enable_evmcs() doesn't do much, actually, in case it was
previously enabled it doesn't do anything and in case it wasn't ordering
with free_nested() (where you're aiming at nested_release_evmcs() I
would guess) shouldn't matter. So could you please elaborate (better in
the commit message) why do we need this re-ordered? My guess is that
you'd like to perform checks for e.g. 'vmx.vmxon_pa == -1ull' before
we actually start doing any changes but let's clarify that.

Thanks!

-- 
Vitaly
