Return-Path: <kvm+bounces-3384-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CF7280395E
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 17:00:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8DE151C20ABA
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 16:00:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70B7F2D05A;
	Mon,  4 Dec 2023 16:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="B0IGHm62"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33340113
	for <kvm@vger.kernel.org>; Mon,  4 Dec 2023 08:00:28 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1d0544c07c3so19422615ad.3
        for <kvm@vger.kernel.org>; Mon, 04 Dec 2023 08:00:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701705628; x=1702310428; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vu5tKdLWsp9uh1IlEpXyg0ZTTjJv3rNUrs1mjxuE+II=;
        b=B0IGHm62IWoUTyGNnCFcK4MHHOp0E1uaM48di7b3KqoP+rLKMb9+XMrbpVOpALLmuK
         4ryK02RmWaM6zB2mhpLE7vLCuQFjbiNVBV0z3xjwWJd4+MVP8PWenjIP5YJpIRteO6Kg
         IlE8Vi+ftUpsmyBxoVDYC5W6HhmitsnCo2+AB1TIiB5xh3cs/i/dPwL2pR8mu4Uw7iv2
         XTPrruOOGTotlrNTPfyYHJb1ACiwdjLQXiVLkidPUpdKflxBhUcz7rJ7DHYcH4KWwAF1
         2LNyn33cNYNO2QUdheKNL8iRVFRfLWJHDYJ1t0ow9pRuqPXczbaWMHz4C6sDTaJrOw31
         Dqzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701705628; x=1702310428;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vu5tKdLWsp9uh1IlEpXyg0ZTTjJv3rNUrs1mjxuE+II=;
        b=Sxpa6ZpT/JzC4Mca1HCxE4MdcMYNfwWEoCFD8Q8m2kDJtPlOKydN+IWxeYtw+ZOU5g
         PIzHgEbEXjuCBUCFqvyfPqBJrdmnMrluHrixvQenZBn2NckNVMDZ31jMaiASvJtPoAsO
         YRBiyhoNdnFmBmC12PwjUrqDeln16Je6IQwLwzI+E7z9As13JQxh9VbmwobbcPwoJQ3w
         2DHL0Yw3dmd/XxOXl6pr7lqPTYDY3yinnIwLKj7vNEf9MmtbvYrlG7pXyjjpxt1ydiVv
         AvRyK5bdZUJhgDp9lKYY0Vufezn1ISVYAr1WiBRO6O9zzxxGmv/9ZdG1KTHS3jdssr5j
         VErQ==
X-Gm-Message-State: AOJu0YwhWy1lnb+YAinCnvY8OoaVeuVIYLktM0ZTSk/bnmb0nIr5TnQ5
	Vels1fePvB88Ku5VEAjpb7QKdiLD7vY=
X-Google-Smtp-Source: AGHT+IEq6m7bLLC6JEwzPGChct1XfwSRHBPSjG7LGs7N2YZblTkyK07gu6RLABzHeBmKxH54ytMP9y8SuQI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e88b:b0:1d0:83bc:5661 with SMTP id
 w11-20020a170902e88b00b001d083bc5661mr110010plg.5.1701705628175; Mon, 04 Dec
 2023 08:00:28 -0800 (PST)
Date: Mon, 4 Dec 2023 08:00:26 -0800
In-Reply-To: <87h6kymgzi.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231203192422.539300-1-yury.norov@gmail.com> <20231203193307.542794-1-yury.norov@gmail.com>
 <20231203193307.542794-12-yury.norov@gmail.com> <87h6kymgzi.fsf@redhat.com>
Message-ID: <ZW33mlO7DIh2k5Gs@google.com>
Subject: Re: [PATCH v2 13/35] KVM: x86: hyper-v: optimize and cleanup kvm_hv_process_stimers()
From: Sean Christopherson <seanjc@google.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Yury Norov <yury.norov@gmail.com>, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, Jan Kara <jack@suse.cz>, 
	Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>, Matthew Wilcox <willy@infradead.org>, 
	Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>, 
	Maxim Kuvyrkov <maxim.kuvyrkov@linaro.org>, Alexey Klimov <klimov.linux@gmail.com>, 
	Bart Van Assche <bvanassche@acm.org>, Sergey Shtylyov <s.shtylyov@omp.ru>
Content-Type: text/plain; charset="us-ascii"

On Mon, Dec 04, 2023, Vitaly Kuznetsov wrote:
> > -	for (i = 0; i < ARRAY_SIZE(hv_vcpu->stimer); i++)
> > -		if (test_and_clear_bit(i, hv_vcpu->stimer_pending_bitmap)) {
> > -			stimer = &hv_vcpu->stimer[i];
> > -			if (stimer->config.enable) {
> > -				exp_time = stimer->exp_time;
> > -
> > -				if (exp_time) {
> > -					time_now =
> > -						get_time_ref_counter(vcpu->kvm);
> > -					if (time_now >= exp_time)
> > -						stimer_expiration(stimer);
> > -				}
> > -
> > -				if ((stimer->config.enable) &&
> > -				    stimer->count) {
> > -					if (!stimer->msg_pending)
> > -						stimer_start(stimer);
> > -				} else
> > -					stimer_cleanup(stimer);
> > -			}
> > +	for_each_test_and_clear_bit(i, hv_vcpu->stimer_pending_bitmap,
> > +					ARRAY_SIZE(hv_vcpu->stimer)) {

Another nit, please align the indendation:

	for_each_test_and_clear_bit(i, hv_vcpu->stimer_pending_bitmap,
				    ARRAY_SIZE(hv_vcpu->stimer)) {

> > +		stimer = &hv_vcpu->stimer[i];
> > +		if (!stimer->config.enable)
> > +			continue;
> > +
> > +		exp_time = stimer->exp_time;
> > +
> > +		if (exp_time) {
> > +			time_now = get_time_ref_counter(vcpu->kvm);
> > +			if (time_now >= exp_time)
> > +				stimer_expiration(stimer);
> >  		}
> > +
> > +		if (stimer->config.enable && stimer->count) {
> > +			if (!stimer->msg_pending)
> > +				stimer_start(stimer);
> > +		} else
> > +			stimer_cleanup(stimer);
> 
> Minor nitpick: it's better (and afair required by coding style) to use
> '{}' for both branches here:

Yeah, it's a hard requirement in KVM x86.

> 
> 	if (stimer->config.enable && stimer->count) {
> 		if (!stimer->msg_pending)
> 			stimer_start(stimer);
> 	} else {
> 		stimer_cleanup(stimer);
> 	}
> 
> > +	}
> >  }
> >  
> >  void kvm_hv_vcpu_uninit(struct kvm_vcpu *vcpu)
> 
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> -- 
> Vitaly
> 

