Return-Path: <kvm+bounces-3320-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F572802F55
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 10:53:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BB438B20A08
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 09:53:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A47C1EB35;
	Mon,  4 Dec 2023 09:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IDpJq5FO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95C67D2
	for <kvm@vger.kernel.org>; Mon,  4 Dec 2023 01:53:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701683590;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WqARk7fzedhZASB+ixpYpvasPr2FrtXK3g7WtNb8hEQ=;
	b=IDpJq5FOVC0/vyeVzce8UWX1xe4SEJSGqSFidv5bSluObN+aAiHCa8kwkfRrJQXOOMSWZO
	PmAMpqrigdkkqeuYMv1MxQB7n1KOkYe/m+msmYAw8gtFfi+Ymg53ZdaM9xtnBIFNBvpBvN
	Ku5R4QZ9DdkD+AS1FMio0Ptn5oP7l/M=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-82-rLooZpicNtiTykTC7Kn4KA-1; Mon, 04 Dec 2023 04:53:08 -0500
X-MC-Unique: rLooZpicNtiTykTC7Kn4KA-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-54c56bfb960so2026318a12.3
        for <kvm@vger.kernel.org>; Mon, 04 Dec 2023 01:53:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701683587; x=1702288387;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WqARk7fzedhZASB+ixpYpvasPr2FrtXK3g7WtNb8hEQ=;
        b=pmyvLA/jxyqmYoUPdq2ppziyHFHgwPOA9rJQa0V7QegbLDy4FVLERjwxNTQ2Qnw/tP
         UF1u5MTFvKCTjx9DmJCITEhybFaa3kWd9fla7n+B29SnOWvTWmuhRHtWE4ULEOY/awdP
         lveE2NRL89ElS2A8KMYneu/7GFL99cMfotKFrY3SAiYHCWlCEVtkRej5M9K5hb+D/xUN
         ZxodpXB+yu/W++t5ahI1HRwLKoJ0SLrGXZHZxNXVn5hUehFoHXWilxqLYAjmQLLG471z
         gcuyZ5qShDfqAoP5WTI/KUKVXox7uY4NkY7ZrINKBZT+ICdck27nUwVAhqARMRT+Qxeh
         wr5g==
X-Gm-Message-State: AOJu0YzREsbhnUWrUa+6wIJc5F0IgCFO6Y0SjwZmeO8+aaFNyAfxtkoW
	rsj04o5RurKG5f59lYZCP/VAmc51qTutqWEv7Shg4Eyv9S7xRCD93L0SrEMOtscASRpjPsQ/Aa+
	xooX1zrcVoj38
X-Received: by 2002:a50:f60d:0:b0:54c:f3fe:b724 with SMTP id c13-20020a50f60d000000b0054cf3feb724mr153230edn.34.1701683587628;
        Mon, 04 Dec 2023 01:53:07 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF04QieaiEA7DXjahNmUbcVj8SS98n8SEAEc72dIfo2YTSyeHeRT8v2xB10JSGbm972QJhB8g==
X-Received: by 2002:a50:f60d:0:b0:54c:f3fe:b724 with SMTP id c13-20020a50f60d000000b0054cf3feb724mr153211edn.34.1701683587289;
        Mon, 04 Dec 2023 01:53:07 -0800 (PST)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id a94-20020a509ee7000000b0054c9df4317dsm2169119edf.7.2023.12.04.01.53.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Dec 2023 01:53:06 -0800 (PST)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Yury Norov <yury.norov@gmail.com>, linux-kernel@vger.kernel.org, Sean
 Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Cc: Yury Norov <yury.norov@gmail.com>, Jan Kara <jack@suse.cz>, Mirsad
 Todorovac <mirsad.todorovac@alu.unizg.hr>, Matthew Wilcox
 <willy@infradead.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Andy
 Shevchenko <andriy.shevchenko@linux.intel.com>, Maxim Kuvyrkov
 <maxim.kuvyrkov@linaro.org>, Alexey Klimov <klimov.linux@gmail.com>, Bart
 Van Assche <bvanassche@acm.org>, Sergey Shtylyov <s.shtylyov@omp.ru>
Subject: Re: [PATCH v2 13/35] KVM: x86: hyper-v: optimize and cleanup
 kvm_hv_process_stimers()
In-Reply-To: <20231203193307.542794-12-yury.norov@gmail.com>
References: <20231203192422.539300-1-yury.norov@gmail.com>
 <20231203193307.542794-1-yury.norov@gmail.com>
 <20231203193307.542794-12-yury.norov@gmail.com>
Date: Mon, 04 Dec 2023 10:53:05 +0100
Message-ID: <87h6kymgzi.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Yury Norov <yury.norov@gmail.com> writes:

> The function traverses stimer_pending_bitmap in a for-loop bit by bit.
> We can do it faster by using atomic find_and_set_bit().
>
> While here, refactor the logic by decreasing indentation level.
>
> CC: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: Yury Norov <yury.norov@gmail.com>
> ---
>  arch/x86/kvm/hyperv.c | 39 +++++++++++++++++++--------------------
>  1 file changed, 19 insertions(+), 20 deletions(-)
>
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 238afd7335e4..a0e45d20d451 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -870,27 +870,26 @@ void kvm_hv_process_stimers(struct kvm_vcpu *vcpu)
>  	if (!hv_vcpu)
>  		return;
>  
> -	for (i = 0; i < ARRAY_SIZE(hv_vcpu->stimer); i++)
> -		if (test_and_clear_bit(i, hv_vcpu->stimer_pending_bitmap)) {
> -			stimer = &hv_vcpu->stimer[i];
> -			if (stimer->config.enable) {
> -				exp_time = stimer->exp_time;
> -
> -				if (exp_time) {
> -					time_now =
> -						get_time_ref_counter(vcpu->kvm);
> -					if (time_now >= exp_time)
> -						stimer_expiration(stimer);
> -				}
> -
> -				if ((stimer->config.enable) &&
> -				    stimer->count) {
> -					if (!stimer->msg_pending)
> -						stimer_start(stimer);
> -				} else
> -					stimer_cleanup(stimer);
> -			}
> +	for_each_test_and_clear_bit(i, hv_vcpu->stimer_pending_bitmap,
> +					ARRAY_SIZE(hv_vcpu->stimer)) {
> +		stimer = &hv_vcpu->stimer[i];
> +		if (!stimer->config.enable)
> +			continue;
> +
> +		exp_time = stimer->exp_time;
> +
> +		if (exp_time) {
> +			time_now = get_time_ref_counter(vcpu->kvm);
> +			if (time_now >= exp_time)
> +				stimer_expiration(stimer);
>  		}
> +
> +		if (stimer->config.enable && stimer->count) {
> +			if (!stimer->msg_pending)
> +				stimer_start(stimer);
> +		} else
> +			stimer_cleanup(stimer);

Minor nitpick: it's better (and afair required by coding style) to use
'{}' for both branches here:

	if (stimer->config.enable && stimer->count) {
		if (!stimer->msg_pending)
			stimer_start(stimer);
	} else {
		stimer_cleanup(stimer);
	}

> +	}
>  }
>  
>  void kvm_hv_vcpu_uninit(struct kvm_vcpu *vcpu)

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly


