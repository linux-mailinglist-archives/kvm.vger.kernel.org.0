Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 915EF17C089
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2020 15:42:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727469AbgCFOm5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Mar 2020 09:42:57 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20215 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727445AbgCFOmv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Mar 2020 09:42:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583505770;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HLLvybIkZToJWwG5l2PYUU2ex1kd112gNJFDc2w6TOA=;
        b=PGfVzxmbsvB4BwMooJIwJFZq44jWyw6U7/0yc5NeghPn40YC3yW4neo9dO3/UdEBeTEAXT
        ryJoIeYAS8e8h6YGH+EoxsbT8GsdluL3alrFj5vq3LudZn6zdUMotvrAVdDzMuOXzGxTKH
        OvZDZerP/sjivNQjI0iFxKBgOoajEQg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-130-1_dsYZOuP1GvYLq0ynKrjQ-1; Fri, 06 Mar 2020 09:42:49 -0500
X-MC-Unique: 1_dsYZOuP1GvYLq0ynKrjQ-1
Received: by mail-wr1-f71.google.com with SMTP id f10so1096459wrv.1
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2020 06:42:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=HLLvybIkZToJWwG5l2PYUU2ex1kd112gNJFDc2w6TOA=;
        b=IDZbbLjrc9I0ksPkbFMACXoqjq6SklwaqQ5nJhbXmC/zV3FEsPZmIEG3XAWLasWFGb
         ILYNRUpWpqLW5eLn9qcoWAKPvZkjVBTayy1yHn7ZLDB79JhmEFzFkTwaLx9WMMe3oiXP
         QOeCMwUNgbj3xNYxz3lZgAvprT6yay/YKcdxwAM9walqtlChm05jsPerAIGjeOHj82MM
         90MY69LK3Te7eJrdWyOA8MRBaLIjvWG1Itn8uY4QKLscADcSBO7J6Z9EPsZiK23J/Z6e
         uspa1rJ9W3nJCSkRmdCyEHWBj0C4XIy19fa39u21cblkSsZqHl1Uusfo0jPZfknZ5tEl
         lo3w==
X-Gm-Message-State: ANhLgQ0tS+W06vZ283docNnqZda92RrJqIr9E1SncJhtmOPDY3CbaFge
        gSeX+mB59+urBVO8Hk9MQef+9B7vzZUz3TYEU+x81VeVHf6zAseULnHup+DYuXX6BS5Bzaq+juu
        MyLgQmCz8jMLC
X-Received: by 2002:a7b:c450:: with SMTP id l16mr4490461wmi.31.1583505768161;
        Fri, 06 Mar 2020 06:42:48 -0800 (PST)
X-Google-Smtp-Source: ADFU+vv0GHdnQTlOXauLVuuvOdsabAO+MLHyVMgLpxz0U/9X9I4+XIIqfVkCeaqT93Lit7k+6eR7Hw==
X-Received: by 2002:a7b:c450:: with SMTP id l16mr4490429wmi.31.1583505767847;
        Fri, 06 Mar 2020 06:42:47 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id a70sm14012856wme.28.2020.03.06.06.42.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2020 06:42:47 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     cavery@redhat.com, jan.kiszka@siemens.com, wei.huang2@amd.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 1/4] KVM: nSVM: do not change host intercepts while nested VM is running
In-Reply-To: <1583403227-11432-2-git-send-email-pbonzini@redhat.com>
References: <1583403227-11432-1-git-send-email-pbonzini@redhat.com> <1583403227-11432-2-git-send-email-pbonzini@redhat.com>
Date:   Fri, 06 Mar 2020 15:42:46 +0100
Message-ID: <87a74tee8p.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> Instead of touching the host intercepts so that the bitwise OR in
> recalc_intercepts just works, mask away uninteresting intercepts
> directly in recalc_intercepts.
>
> This is cleaner and keeps the logic in one place even for intercepts
> that can change even while L2 is running.
>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/svm.c | 31 ++++++++++++++++++-------------
>  1 file changed, 18 insertions(+), 13 deletions(-)
>
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 247e31d21b96..14cb5c194008 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -519,10 +519,24 @@ static void recalc_intercepts(struct vcpu_svm *svm)
>  	h = &svm->nested.hsave->control;
>  	g = &svm->nested;
>  
> -	c->intercept_cr = h->intercept_cr | g->intercept_cr;
> -	c->intercept_dr = h->intercept_dr | g->intercept_dr;
> -	c->intercept_exceptions = h->intercept_exceptions | g->intercept_exceptions;
> -	c->intercept = h->intercept | g->intercept;
> +	c->intercept_cr = h->intercept_cr;
> +	c->intercept_dr = h->intercept_dr;
> +	c->intercept_exceptions = h->intercept_exceptions;
> +	c->intercept = h->intercept;
> +
> +	if (svm->vcpu.arch.hflags & HF_VINTR_MASK) {
> +		/* We only want the cr8 intercept bits of L1 */
> +		c->intercept_cr &= ~(1U << INTERCEPT_CR8_READ);
> +		c->intercept_cr &= ~(1U << INTERCEPT_CR8_WRITE);
> +	}
> +
> +	/* We don't want to see VMMCALLs from a nested guest */
> +	c->intercept &= ~(1ULL << INTERCEPT_VMMCALL);
> +
> +	c->intercept_cr |= g->intercept_cr;
> +	c->intercept_dr |= g->intercept_dr;
> +	c->intercept_exceptions |= g->intercept_exceptions;
> +	c->intercept |= g->intercept;
>  }
>  
>  static inline struct vmcb *get_host_vmcb(struct vcpu_svm *svm)
> @@ -3590,15 +3604,6 @@ static void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
>  	else
>  		svm->vcpu.arch.hflags &= ~HF_VINTR_MASK;
>  
> -	if (svm->vcpu.arch.hflags & HF_VINTR_MASK) {
> -		/* We only want the cr8 intercept bits of the guest */
> -		clr_cr_intercept(svm, INTERCEPT_CR8_READ);
> -		clr_cr_intercept(svm, INTERCEPT_CR8_WRITE);
> -	}
> -
> -	/* We don't want to see VMMCALLs from a nested guest */
> -	clr_intercept(svm, INTERCEPT_VMMCALL);
> -
>  	svm->vcpu.arch.tsc_offset += nested_vmcb->control.tsc_offset;
>  	svm->vmcb->control.tsc_offset = svm->vcpu.arch.tsc_offset;

FWIW,

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

