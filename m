Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86F7C3B393F
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 00:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232869AbhFXWgO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 18:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbhFXWgN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Jun 2021 18:36:13 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F17B9C061756
        for <kvm@vger.kernel.org>; Thu, 24 Jun 2021 15:33:53 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id bb20so4337360pjb.3
        for <kvm@vger.kernel.org>; Thu, 24 Jun 2021 15:33:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PHR4j2h2rOVtlrAiNcYi9OQO+yd/4fA9sq0SL3O5RKQ=;
        b=iu8gCBRuL6cV7l7ZrtAdMuWYVJ92vky7nyiGSX48wVr5Ec5e+8hcrFzCzXJQWfnh1P
         QZlfYzkXDmAU6fmWcMEpY6Bt6T+fBl+Vd11LAdDI0btDxgSfLCRndKuWWdMY4ayTyoBt
         xbjSMLPC9I3csBXIoDN9Utuqxb6mcd9lFhzL54XtDH/g+tTgag2xzYcIof82gTur1RRX
         37W21PH6vpi3G1L5rZffK5HCAksBK14sZd2QUrJxJpYAqDYYdrDdBWZuEtpWbWovUhAu
         mkFXN59LHVWORovr80eYj9120eo1L04z1dDawqg/v1fxJDcaFUogpe0SBROhHPtJz2iX
         O26g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PHR4j2h2rOVtlrAiNcYi9OQO+yd/4fA9sq0SL3O5RKQ=;
        b=qHMeRhAcYvkLXuvc0KSVMpienirGBIrTsKxeXljbEO75b672SVnAQPj2H8CtykJmLi
         9N2f60NGu14JZExBcfE8W8AgZK0lscGAZhr7xYn+W1Gw+/BWZJkEgzhXfyTpYNh5xOiB
         UMxOYmWIN1CIXblD7pjSlLehMq9cmLEk2YkFFw5VBikD4ZVS1OUE9xVWTQTxHC9pqFJA
         FApMTorbTe8lMa7+2sbklJY908K1SnGR5i4lCjCZEw0LSPFYwwbnhit6VlUhQuPvnqqa
         e5aJZhXacfTDxvFmqEeJc+kmKRIVBWjeKA4OoX/l/OoIlDy2auXJdu3zDY00rzNbygdu
         mn5w==
X-Gm-Message-State: AOAM5327l64rfokc5EfoVGrHKU/8FPQyeqxzr7+bLLLKfn0ryWufbGwm
        hx/LPhj7riWQ5pmOPaENh/hn9Q==
X-Google-Smtp-Source: ABdhPJzbPpNFsgn7eKZFndlwq1QREGtEsWkKYJrDYzmLY4T/ngRcz014t6Au6rVpVGJ/wrI9Ztcj0g==
X-Received: by 2002:a17:90b:1191:: with SMTP id gk17mr7609490pjb.95.1624574033291;
        Thu, 24 Jun 2021 15:33:53 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id h22sm3397732pju.22.2021.06.24.15.33.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 15:33:52 -0700 (PDT)
Date:   Thu, 24 Jun 2021 22:33:49 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] KVM: x86: WARN and reject loading KVM if NX is
 supported but not enabled
Message-ID: <YNUITW5fsaQe4JSo@google.com>
References: <20210615164535.2146172-1-seanjc@google.com>
 <20210615164535.2146172-4-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210615164535.2146172-4-seanjc@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 15, 2021, Sean Christopherson wrote:
> WARN if NX is reported as supported but not enabled in EFER.  All flavors
> of the kernel, including non-PAE 32-bit kernels, set EFER.NX=1 if NX is
> supported, even if NX usage is disable via kernel command line.

Ugh, I misread .Ldefault_entry in head_32.S, it skips over the entire EFER code
if PAE=0.  Apparently I didn't test this with non-PAE paging and EPT?

Paolo, I'll send a revert since it's in kvm/next, but even better would be if
you can drop the patch :-)  Lucky for me you didn't pick up patch 4/4 that
depends on this...

I'll revisit this mess in a few weeks.

> on NX being enabled if it's supported, e.g. KVM will generate illegal NPT
> entries if nx_huge_pages is enabled and NX is supported but not enabled.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/x86.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index acc28473dec7..1f6595df45de 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10981,6 +10981,9 @@ int kvm_arch_hardware_setup(void *opaque)
>  	int r;
>  
>  	rdmsrl_safe(MSR_EFER, &host_efer);
> +	if (WARN_ON_ONCE(boot_cpu_has(X86_FEATURE_NX) &&
> +			 !(host_efer & EFER_NX)))
> +		return -EIO;
>  
>  	if (boot_cpu_has(X86_FEATURE_XSAVES))
>  		rdmsrl(MSR_IA32_XSS, host_xss);
> -- 
> 2.32.0.272.g935e593368-goog
> 
