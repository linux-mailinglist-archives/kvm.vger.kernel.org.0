Return-Path: <kvm+bounces-2556-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BBE5C7FB209
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 07:42:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4C762B2128B
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 06:42:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28987D311;
	Tue, 28 Nov 2023 06:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SDcb+P8o"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7797E198
	for <kvm@vger.kernel.org>; Mon, 27 Nov 2023 22:41:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701153716;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tydD1PGh+E5hAuRyYlrDeaXgeRVouiHNeF9BuT+pj4c=;
	b=SDcb+P8olfin8yPk8L/SLSvv2l7G122LrGzQGwYp3mj21rbzyg3ecwHxx4fwAlbOVGYqyj
	Tbw72J2/HSYdFuQ3y0KRNCIrXi3GfJCXTFD1hT1cBQrQflaRFmH6O1ouwTjRN8cwsKqXFw
	RzBVJ9lYjj55a6XYW2z5JS5D4HmxQhc=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-350-7D6EJDdwNDCwVlLSANiW_g-1; Tue, 28 Nov 2023 01:41:54 -0500
X-MC-Unique: 7D6EJDdwNDCwVlLSANiW_g-1
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2c737d1ba09so38542481fa.1
        for <kvm@vger.kernel.org>; Mon, 27 Nov 2023 22:41:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701153713; x=1701758513;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tydD1PGh+E5hAuRyYlrDeaXgeRVouiHNeF9BuT+pj4c=;
        b=scishNCvnP3SherVgfhV97Ws6PA6xl/LhoZm1CBxJJTUqmpxFuPG+NWXpoYih0fVkZ
         cvuuiEyWuMADUavnD7LFw9gu2t8BV8NO6qzEdN4/iG/PTja6ufopzGqT0g8Z4VR0q/wU
         VE3q2G8nCfxST0wLFKyIJWJ8ub/YXYkDDZkOtpbs4DvTQlQ9SOVf0zGXdGDnBkPE5hAA
         frFCBC/GYqtqpT4kJF5XwidDQQWidck9JJ4YG3zsPbdEoJAZWpoWbA2wEzDsqT+wQhnW
         k99K1HIijUAvUyTKHw3hT/OM8LAA+9BDbIbm9P5dDBaFz1Kr66K+zNuNJL+uGkW8JkSP
         zJRA==
X-Gm-Message-State: AOJu0YySTEfEaJjrPH5q67FrNRtWyUVShabcf/WRs2c5ahlIRYD3CurW
	jBljj7BytCO1duPmJVRU4Boz+nSEb9VsDvnOEDZHrPeAS2PYJeiMJkCC8dOVQGnZ/TeDNLnEJFz
	hSwaMUfrWibxV
X-Received: by 2002:a2e:84c5:0:b0:2bd:d34:d98a with SMTP id q5-20020a2e84c5000000b002bd0d34d98amr9103358ljh.44.1701153713549;
        Mon, 27 Nov 2023 22:41:53 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHSEC1/LOlCzfV+X5BIOIuHkx7l3BbF0evIz91WysQ9tGH4L/0H/wihYM/h3gg8RlKH7rFc9g==
X-Received: by 2002:a2e:84c5:0:b0:2bd:d34:d98a with SMTP id q5-20020a2e84c5000000b002bd0d34d98amr9103351ljh.44.1701153713246;
        Mon, 27 Nov 2023 22:41:53 -0800 (PST)
Received: from starship ([77.137.131.4])
        by smtp.gmail.com with ESMTPSA id f11-20020a05600c154b00b0040b48690c49sm4217821wmg.6.2023.11.27.22.41.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Nov 2023 22:41:52 -0800 (PST)
Message-ID: <4ca6dc2cf030f15193efbe2b364bf196692cd167.camel@redhat.com>
Subject: Re: [PATCH v3 1/4] KVM: x86: refactor req_immediate_exit logic
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, 
	Sean Christopherson
	 <seanjc@google.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	 <bp@alien8.de>, linux-kernel@vger.kernel.org, x86@kernel.org, Dave Hansen
	 <dave.hansen@linux.intel.com>
Date: Tue, 28 Nov 2023 08:41:51 +0200
In-Reply-To: <0c626505-a358-4d13-99e3-144356d136b3@redhat.com>
References: <20230928103640.78453-1-mlevitsk@redhat.com>
	 <20230928103640.78453-2-mlevitsk@redhat.com>
	 <0c626505-a358-4d13-99e3-144356d136b3@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2023-11-24 at 17:07 +0100, Paolo Bonzini wrote:
> On 9/28/23 12:36, Maxim Levitsky wrote:
> > @@ -4176,6 +4176,9 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
> >   	clgi();
> >   	kvm_load_guest_xsave_state(vcpu);
> >   
> > +	if (vcpu->arch.req_immediate_exit)
> > +		smp_send_reschedule(vcpu->cpu);
> > +
> 
> This code is in a non-standard situation where IF=1 but interrupts are
> effectively disabled.  Better something like:
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index beea99c8e8e0..3b945de2d880 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4148,8 +4148,11 @@ static __no_kcsan fastpath_t svm_vcpu_run(
>   		 * is enough to force an immediate vmexit.
>   		 */
>   		disable_nmi_singlestep(svm);
> +		vcpu->arch.req_immediate_exit = true;
> +	}
> +
> +	if (vcpu->arch.req_immediate_exit)
>   		smp_send_reschedule(vcpu->cpu);
> -	}
> 
>   	pre_svm_run(vcpu);
> 
> 
> Paolo
> 


Actually IF=0 at that point. We disable IF before we call svm_vcpu_run, at
vcpu_enter_guest().

Then we disable GIF, and we re-enable IF only right before VMRUN, in fact vmrun is
in the interrupt shadow although that doesn't really matter since GIF=0.

However I don't mind implementing the change you suggested, I don't think it will
affect anything.

Best regards,
	Maxim Levitsky


