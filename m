Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A54D429920
	for <lists+kvm@lfdr.de>; Mon, 11 Oct 2021 23:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235382AbhJKVuX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 17:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231186AbhJKVuW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Oct 2021 17:50:22 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2296DC061570
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 14:48:22 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id q10-20020a17090a1b0a00b001a076a59640so668994pjq.0
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 14:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xY9ypAY0GaYEZdIjlQeTZSky62E6XMeTu9ABeyPmRhY=;
        b=TGD7jfbc8SEBZviedyVlmXY2TkI1iFJZSQ8XA0uRROgMC7kye1b3UgHwiaABkW+utO
         HEJBoQ/Hry1YTmDdtMVq4XmjbBagLATf8GTwxZ3I9D1Q1hGeFTrUcRHZjesO106Wglcc
         nRG9XfZH7op9msW1xdRNt4lD2tOzSBMcHubuWHf7v68IS0sEnCtyE/61KtZAke+Pb9SM
         hDLf6HGE+q/YAuDCAu/kOrZ9Jjt0zVH9DhXDGo8F/LiKROPz5KBrEfXvxvTYSVe9ybC9
         /UB9sD0lCmZG9OvM33wx8RifZr9XLDqnWrexGmL6Z9Ph05YLkciDrasObAM5I2hiITye
         +xSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xY9ypAY0GaYEZdIjlQeTZSky62E6XMeTu9ABeyPmRhY=;
        b=xexAfPykmGSeQOM0dUppgbTSrgO9NDcpklcr6i2o3tLzgt7HChuYaPIixPPO1xLp8w
         eg6nZ02ZNNBMkDVk+TcZo9XgQzoicHjWQVwRi5NZeyWU1OM7n3D02ym+piOnRdy7e+MH
         CKBLfK1ysUOvI3tBJdxdJA93xN8okD9oJYuDwsyppooD46Vhkx87+cEBYP7hCNsqTC5a
         mjZF+rMgLg5dojmyj7lbpWIA4AwyK4a0HkJ5yelN/egq/H7QcBFbdJ+zu6evDGJdZ95v
         ICjhcPAZucS/zsR1oWoE7D91so+8VYN3o5GsBX+FwzkMs1eujwI3yCIhruydTK8ZirCY
         ORbQ==
X-Gm-Message-State: AOAM532tsl/fe42fh0Aco9BPc78u1tugLregBsUu5lAdJhZBPDO9NUmN
        EzgIwYBDWoEOXsWKPt0/I3yK4g==
X-Google-Smtp-Source: ABdhPJyofUlnNTc1mWARZOzZez6LkqYwP4vw8pmBn6dHGmxNZZnFQ4lPRQkpS27ssGZx0yyK+UaoGw==
X-Received: by 2002:a17:90a:c081:: with SMTP id o1mr1758805pjs.24.1633988901369;
        Mon, 11 Oct 2021 14:48:21 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id s17sm8956975pge.50.2021.10.11.14.48.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Oct 2021 14:48:20 -0700 (PDT)
Date:   Mon, 11 Oct 2021 21:48:17 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Venkatesh Srinivas <venkateshs@chromium.org>
Cc:     kvm@vger.kernel.org, marcorr@google.com, pbonzini@redhat.com
Subject: Re: [PATCH] kvm: Inject #GP on invalid writes to x2APIC registers
Message-ID: <YWSxIbjY6j5x4dyP@google.com>
References: <20211011182853.978640-1-venkateshs@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211011182853.978640-1-venkateshs@chromium.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Be kind to case-sensitive greppers and capitalize the "KVM" in the shortlog ;-)

On Mon, Oct 11, 2021, Venkatesh Srinivas wrote:

Assuming Marc is the original author, this needs an explicit

  From: Marc Orr <marcorr@google.com>

so that he's accredited as the author by hit.  A few ways to do this are described
here: https://lkml.kernel.org/r/YUNu2npJv2LPBRop@google.com

> The upper 7 bytes pf the x2APIC self IPI register and the upper 4
> bytes of any 32-bit x2APIC register are reserved. Inject a #GP into the
> guest if any of these reserved bits are set.

Hmm, I'd split this into two patches.  It's a bit silly for such a small change,
but if for some reason _one_ of the checks turns out to be wrong or cause problems,
it's easy to pinpoint and fix/revert that individual change.

> Signed-off-by: Marc Orr <marcorr@google.com>
> Signed-off-by: Venkatesh Srinivas <venkateshs@chromium.org>
> ---
>  arch/x86/kvm/lapic.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 76fb00921203..96e300acf70a 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2126,13 +2126,15 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
>  			ret = 1;
>  		break;
>  
> -	case APIC_SELF_IPI:
> -		if (apic_x2apic_mode(apic)) {
> +	case APIC_SELF_IPI: {

Braces on the case statement are unnecessary (and confusing).

> +		/* Top 7 bytes of val are reserved in x2apic mode */

Comment says 7 bytes, code checks 3 :-)  It's arguably even technically wrong to
say 7 bytes are reserved, because the SDM defines Self-IPI as a 32-bit register.
Doesn't reaaaally matter, but maybe dodge the issue by using slightly less
specific language?  (sample below)

> +                if (apic_x2apic_mode(apic) && !(val & GENMASK(31, 8))) {

Hmm, rather than a custom GENMASK, what about ~APIC_VECTOR_MASK?  I think that
would fold in nicely with an updated comment? (again, see below)

Not your (Marc's?) code, but the braces here are technically unnecessary as well.
Some subsystems prefer braces if the code splits multiple lines, but KVM usually
omits the braces if there's a single statement, even if the statement spans more
than one line.

>  			kvm_lapic_reg_write(apic, APIC_ICR,
>  					    APIC_DEST_SELF | (val & APIC_VECTOR_MASK));
>  		} else

If you do keep the braces, please opportunistically add braces for the else path
as well.  That's a more rigid kernel style guideline :-)

Actually, to avoid a somewhat confusing comment since Self-IPI doesn't even exist
outside of x2APIC, what about:

		/*
		 * Self-IPI exists only when x2APIC is enabled.  Bits 7:0 hold
		 * the vector, everything else is reserved.
		 */
		if (!apic_x2apic_mode(apic) || (val & ~APIC_VECTOR_MASK))
			ret = 1;
			break;
		}
		kvm_lapic_reg_write(apic, APIC_ICR,
				    APIC_DEST_SELF | (val & APIC_VECTOR_MASK));
		break;

That avoids the braces debate, avoids a taken branch in the happy case, and
eliminates the >80 chars line.

>  			ret = 1;
>  		break;
> +	}
>  	default:
>  		ret = 1;
>  		break;
> @@ -2797,6 +2799,9 @@ int kvm_x2apic_msr_write(struct kvm_vcpu *vcpu, u32 msr, u64 data)
>  	/* if this is ICR write vector before command */
>  	if (reg == APIC_ICR)
>  		kvm_lapic_reg_write(apic, APIC_ICR2, (u32)(data >> 32));
> +	else if (data & GENMASK_ULL(63, 32))

I think we usually write this as

	else if (data >> 32)

in KVM?  Not sure if we have an official policy :-)

> +		return 1;
> +
>  	return kvm_lapic_reg_write(apic, reg, (u32)data);
>  }
>  
> -- 
> 2.33.0.882.g93a45727a2-goog
> 
