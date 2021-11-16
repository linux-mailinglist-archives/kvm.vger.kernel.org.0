Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1069F4538B6
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 18:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239012AbhKPRpc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 12:45:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239003AbhKPRpc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 12:45:32 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49514C061764
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 09:42:35 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id t21so18053770plr.6
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 09:42:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sRP9ret+j9GM8SwkphIfdmLvAPXmHIsrlNLspioLslY=;
        b=aakaVBEdAVGwvD4uT2VFp1F3GnlWegHkSrNhZkvdNQhw/0KFS56fK/FXKpoZpoqaW/
         ks57SnnQqDIAhkNzgg/3/qm+2QtEnDzihtZg64upedmBE0N8bG3Wz3aMZ6IcPPkfbWJ7
         Odr8FTytQNLXbll9XzJf0Djin5Tfz8TLNhJ6bh4FXKVr2e8uG4++PS+DTJSSbVRsWfz+
         t5LgfPUnmjjk1OKazSXWK00JYV0wqzhGzMfljui9t6eIKeJvmyS6IubMHslN8NFkXm6u
         cO/p1ZreH9LaBW4GjnnliGC5qXJGZRFztrhsY5O6+uwQPTVgmqu7CenrvqWeWmsKj2O8
         Ru+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sRP9ret+j9GM8SwkphIfdmLvAPXmHIsrlNLspioLslY=;
        b=OXQmUgGy927dh4CA3zjNfmQnWE/Lok+aF4qHPysyrkq8SZqWYXWXzoGiZCQc7n6ccI
         OzTOmdhQQBXOewVsc5lWE8Q/jqBeFqJ7GTyEKd1hZGAPA/cf/cSZEc/sgaamwK3osNE9
         4l/WtMre09+xnHppgQzxlfdE4g9szCr3GzbtPhpTDdH6g/C8iTVA7+zsowOtQklWSMGz
         9V/OBAERjm/hrKPuzuwHFz+hHoONSiSUJUYJpq5hNtyQV/R6zqylVBezRd7V+h6nlPNG
         iB/ilOr5TsJ3dNHeO+lHfRvOSMMEXyMcL++DLAMkoC949vwIGOwGXy/W3TZLCiIRYR1i
         oD2w==
X-Gm-Message-State: AOAM533ws5U/WB5V477nsOMHBafHQ7tOBi53ubzWc5bON3XL9eYoteSO
        pZXqEVgK1TBFdvta5qOfHQWBPu5sq+e/yg==
X-Google-Smtp-Source: ABdhPJyyXIcTrfZEJwR/YjR6Bdl41yqSXG5bJwrpZnpwuDRmhl/B4sdaeksWzjqfOJyaFKACyqUAxg==
X-Received: by 2002:a17:90b:1812:: with SMTP id lw18mr938276pjb.196.1637084554564;
        Tue, 16 Nov 2021 09:42:34 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id f4sm18773282pfg.34.2021.11.16.09.42.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 09:42:33 -0800 (PST)
Date:   Tue, 16 Nov 2021 17:42:29 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, jgross@suse.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Use a stable condition around all VT-d PI paths
Message-ID: <YZPtheR+pShP+CX6@google.com>
References: <20211116142205.719375-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211116142205.719375-1-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 16, 2021, Paolo Bonzini wrote:
> Currently, checks for whether VT-d PI can be used refer to the current
> status of the feature in the current vCPU; or they more or less pick
> vCPU 0 in case a specific vCPU is not available.
> 
> However, these checks do not attempt to synchronize with changes to
> the IRTE.  In particular, there is no path that updates the IRTE when
> APICv is re-activated on vCPU 0; and there is no path to wakeup a CPU
> that has APICv disabled, if the wakeup occurs because of an IRTE
> that points to a posted interrupt.

Ooooh, I think I get it now.  You're saying that if pi_update_irte() configured
the IRQ to post the IRQ to a vCPU, and then that vCPU disables APICv, because KVM
doesn't go back and fixup the IRTE, the device will send the IRQ to the current
posted interrupt vector, not to the non-posted vector.  That makes sense.

> To fix this, always go through the VT-d PI path as long as there are
> assigned devices and APICv is available on both the host and the VM side.
> Since the relevant condition was copied over three times, take the hint
> and factor it into a separate function.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/vmx/posted_intr.c | 20 +++++++++++---------
>  1 file changed, 11 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
> index 5f81ef092bd4..b64dd1374ed9 100644
> --- a/arch/x86/kvm/vmx/posted_intr.c
> +++ b/arch/x86/kvm/vmx/posted_intr.c
> @@ -5,6 +5,7 @@
>  #include <asm/cpu.h>
>  
>  #include "lapic.h"
> +#include "irq.h"
>  #include "posted_intr.h"
>  #include "trace.h"
>  #include "vmx.h"
> @@ -77,13 +78,18 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
>  		pi_set_on(pi_desc);
>  }
>  
> +static bool vmx_can_use_vtd_pi(struct kvm *kvm)
> +{
> +	return kvm_arch_has_assigned_device(kvm) &&
> +		irq_remapping_cap(IRQ_POSTING_CAP) &&
> +		irqchip_in_kernel(kvm) && enable_apicv;

Bad indentation/alignment.

Not that it's likely to matter, but would it make sense to invert the checks so
that they're short-circuited on the faster KVM checks?  E.g. fastest to slowest:

	return irqchip_in_kernel(kvm) && enable_apic &&
	       kvm_arch_has_assigned_device(kvm) &&
	       irq_remapping_cap(IRQ_POSTING_CAP);

Nits aside,

Reviewed-by: Sean Christopherson <seanjc@google.com>
