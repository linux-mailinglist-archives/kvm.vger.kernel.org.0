Return-Path: <kvm+bounces-2117-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A2F2E7F15A1
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 15:26:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BBCA01C217E1
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 14:26:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06F151C6A7;
	Mon, 20 Nov 2023 14:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZQ0tT6ns"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B489BED
	for <kvm@vger.kernel.org>; Mon, 20 Nov 2023 06:26:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700490372;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WCml1wygp+3G4XDBK3ZMkKvMovt52E8+5uR4Ab+tFvk=;
	b=ZQ0tT6nsaUsn7upfBUcHRCFkSHwVUzr3YHMyurBaDZo5ULExRuA5bKGHIcwnLYVn6FG/zD
	FTpT3v/AW9840ZBgYSPgo7iUeTDYunciFSGgKG69cv6eesQKzR0agvRlL2Gj1jOy1xra9B
	wFOl1weGBY3lDi1tpgE8NayolxoMW7A=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-175-0l1gvOExNcS6et4CepbadQ-1; Mon, 20 Nov 2023 09:26:11 -0500
X-MC-Unique: 0l1gvOExNcS6et4CepbadQ-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-a00d0011a3bso10285666b.2
        for <kvm@vger.kernel.org>; Mon, 20 Nov 2023 06:26:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700490370; x=1701095170;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WCml1wygp+3G4XDBK3ZMkKvMovt52E8+5uR4Ab+tFvk=;
        b=BStLj58eoXdRmgB4yBYR4gSCDkFTiIsZuDlfrMfW5vJPp1UIX+TqcIOjwR5wyHKwby
         b2h14n2sYByJuoiHhM/frgv2CJmVPk1TeFItSRIv4JTJgTeITkH09RvHoHkhqGvTXOM5
         nZ20+H6SIxMJrpSmyV6i6dCtENNMBMR5tQHwxkL714+YiffswNw2LgEmmH5wqcO+t7ch
         SKt9LBPxMho4x51ekDsB+8TnXOpreHEkD77BWgUGbzhkc7M/k11aprmMPEVC7Zo2GIOT
         ub1583lhXLcwOXcUY5YJJ/K6e/h7MEmiJmgzTz8YGrbBQf/oEeG4+qZqK1wep3iWifV7
         pimw==
X-Gm-Message-State: AOJu0Yx8kvDz2fag29R5W7AJqAUpjfG++VD8auXxIF1+0+K6lBqJAa0s
	muoYetf06HEnrvioUWiawl4pxeMWbHjzFNQW7WsdZv/jRxppGPG/bS8W+tS4tbJUYkWy9pdf8T4
	RV7vywzMeavM9
X-Received: by 2002:a05:6402:40c4:b0:548:7ccc:6428 with SMTP id z4-20020a05640240c400b005487ccc6428mr6128849edb.11.1700490370403;
        Mon, 20 Nov 2023 06:26:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFHMHHyfevTZBOGA7OAoxC98zM3OcTilr92FcoZ3cNuGbvLzmUH9ulWS5dMWytx0YgPl0WvMQ==
X-Received: by 2002:a05:6402:40c4:b0:548:7ccc:6428 with SMTP id z4-20020a05640240c400b005487ccc6428mr6128827edb.11.1700490370127;
        Mon, 20 Nov 2023 06:26:10 -0800 (PST)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id r5-20020a056402018500b0053dec545c8fsm3622562edv.3.2023.11.20.06.26.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Nov 2023 06:26:09 -0800 (PST)
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
 <maxim.kuvyrkov@linaro.org>, Alexey Klimov <klimov.linux@gmail.com>
Subject: Re: [PATCH 13/34] KVM: x86: hyper-v: optimize and cleanup
 kvm_hv_process_stimers()
In-Reply-To: <20231118155105.25678-14-yury.norov@gmail.com>
References: <20231118155105.25678-1-yury.norov@gmail.com>
 <20231118155105.25678-14-yury.norov@gmail.com>
Date: Mon, 20 Nov 2023 15:26:08 +0100
Message-ID: <877cmcqz5r.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Yury Norov <yury.norov@gmail.com> writes:

> The function traverses stimer_pending_bitmap n a for-loop bit by bit.
> We can do it faster by using atomic find_and_set_bit().
>
> While here, refactor the logic by decreasing indentation level
> and dropping 2nd check for stimer->config.enable.
>
> Signed-off-by: Yury Norov <yury.norov@gmail.com>
> ---
>  arch/x86/kvm/hyperv.c | 39 +++++++++++++++++++--------------------
>  1 file changed, 19 insertions(+), 20 deletions(-)
>
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 238afd7335e4..460e300b558b 100644
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
> +		if (stimer->count) {

You can't drop 'stimer->config.enable' check here as stimer_expiration()
call above actually changes it. This is done on purpose: oneshot timers
fire only once so 'config.enable' is reset to 0.

> +			if (!stimer->msg_pending)
> +				stimer_start(stimer);
> +		} else
> +			stimer_cleanup(stimer);
> +	}
>  }
>  
>  void kvm_hv_vcpu_uninit(struct kvm_vcpu *vcpu)

-- 
Vitaly


