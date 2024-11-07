Return-Path: <kvm+bounces-31085-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A8709C01D2
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 11:03:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EF2F71F23B58
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 10:03:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE3B71E7C02;
	Thu,  7 Nov 2024 10:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jHEgahw8"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 292F11922C4
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 10:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730973784; cv=none; b=rixh/nVzljpOxAgKspJb/uEUjC1Q0XvdpNSPWtm2Ut3vX5yEth1r4lvnGmxZg2FRYzX9GJL2EgFaZ8oFEVNPxwtP69r4Ut4EbQV/YkOQmRqVYZrxg2qA2Z3RBrWjPEG2jvW6aqtAtIQs6HWmUzyaKqKQsBYtw9I2N4FlOyBOeSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730973784; c=relaxed/simple;
	bh=cSxBkM/VvswSeAOwadsuJ4JSlJplKr5PUBsSc0t2I6o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J74NkYHJtamnc3To7fsJEp5pU3SOAJVe8Yy+byKsrfP3NnR5YPHKrcwooQIqwa8IH9F0lPeWONohTyeNpYYFBvmdVQnA5/y2cUaLrXna4nveTnKy4Gg1zM1Twzl9KbwRWtV/fQjyUrg/qVoGCx5q7TXdZ+uSLmUzDMZ8Bx6f+ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jHEgahw8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730973782;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RURwccUCrNdi9KBps0wRmpb2Gas3Fr3k2vFNwM24X7o=;
	b=jHEgahw8bNXrn7elyoZhJ/BnMdn24ATN40tmHPcP9vXBO0LKh+xGIUx7wI7r1jiESIpg1e
	4oxg0G9JnusBg4Y4ua/uz64MnltOMdac2t/PQpJ3wrmOBnvljYuqTtfinterm5GuxO/TnJ
	A9Br64hG2kwnH2oIYwrJf+Kklg7ly4E=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-517-eAxZAmcbO5eFu6TM8TeyRQ-1; Thu, 07 Nov 2024 05:03:00 -0500
X-MC-Unique: eAxZAmcbO5eFu6TM8TeyRQ-1
X-Mimecast-MFC-AGG-ID: eAxZAmcbO5eFu6TM8TeyRQ
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-2ff13df3759so7609561fa.0
        for <kvm@vger.kernel.org>; Thu, 07 Nov 2024 02:03:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730973778; x=1731578578;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RURwccUCrNdi9KBps0wRmpb2Gas3Fr3k2vFNwM24X7o=;
        b=vSXTfyv/9jgvslLKE7t70gktMprM/K05qyy4yQ8cHOsfo+kuZOtBx7vOtHtphoKgXW
         lqH11aVf68MnCF/lqnlgx+uIJHw9Q/LdMVNBLQY5VpUmMHMwj8J9X5TdC/yt9oZnheLm
         s5zvacTRqTe3R+CR+q4azb77LjjyHiuBAsp1MtEVC/WL6iam9tuhS74/T++6kR0KPuxE
         8NdsHuY8Fl1duZ3KRfLxKJbw6pdk3tHgkyPRiV8Di1iELdiOnh3j7fPbBSmeekIMCm1y
         NHmEVRMCHnnjUIJpMXvs+2Ezj9fV53YuOrHmbQTcRSZSn8FK9rr7g1OQG/3dGJG7tGNn
         Jd0g==
X-Forwarded-Encrypted: i=1; AJvYcCVKoSIsG0zvmN4aDZ6PxDMkyTL1dL0+sQmC+RdJ9tEUEcEMdEYuww9n2gTsXyXWmLOKjqg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzhiIuqrPhnQPD1WLJ9GG7oHJIvS4JZKNbIEkDzq6w5Pu3xDYdg
	ReRw26b+ww/0Tz3sRh5OKHP5vv7vv42jXJ/R0tVgeRDqA3gHbZNl08rbpBVJiDr1Ap0RhrIez7X
	37Kwe4ezvO3QwLzZ554srFO5jyykAqOuas5mZq/hiOOZC7KAxChADo8lYTw==
X-Received: by 2002:a05:651c:b2b:b0:2fb:3960:9667 with SMTP id 38308e7fff4ca-2fedb7a2aa3mr164722401fa.14.1730973778268;
        Thu, 07 Nov 2024 02:02:58 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH0Ut1MJXLUB/mEk4xEIuR+xgwHSESlbS4qEeQM6UCMiizmJPXbkINe4oE0BVm87ZHXWpCwEg==
X-Received: by 2002:a05:651c:b2b:b0:2fb:3960:9667 with SMTP id 38308e7fff4ca-2fedb7a2aa3mr164722081fa.14.1730973777872;
        Thu, 07 Nov 2024 02:02:57 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432aa6b3069sm53583895e9.14.2024.11.07.02.02.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Nov 2024 02:02:56 -0800 (PST)
Message-ID: <185b1a15-7e94-466d-a870-d7a2cc3bb890@redhat.com>
Date: Thu, 7 Nov 2024 11:02:55 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 2/3] lib/on-cpus: Add barrier after func
 call
Content-Language: en-US
To: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, kvmarm@lists.linux.dev
Cc: atishp@rivosinc.com, jamestiotio@gmail.com, alexandru.elisei@arm.com
References: <20241031123948.320652-5-andrew.jones@linux.dev>
 <20241031123948.320652-7-andrew.jones@linux.dev>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20241031123948.320652-7-andrew.jones@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/31/24 13:39, Andrew Jones wrote:
> It's reasonable for users of on_cpu() and on_cpumask() to assume
> they can read data that 'func' has written when the call completes.
> Ensure the caller doesn't observe a completion (target cpus are again
> idle) without also being able to observe any writes which were made
> by func(). Do so by adding barriers to implement the following
>
>  target-cpu                                   calling-cpu
>  ----------                                   -----------
>  func() /* store something */                 /* wait for target to be idle */
>  smp_wmb();                                   smp_rmb();
>  set_cpu_idle(smp_processor_id(), true);      /* load what func() stored */
>
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  lib/on-cpus.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/lib/on-cpus.c b/lib/on-cpus.c
> index f6072117fa1b..356f284be61b 100644
> --- a/lib/on-cpus.c
> +++ b/lib/on-cpus.c
> @@ -79,6 +79,7 @@ void do_idle(void)
>  			smp_wait_for_event();
>  		smp_rmb();
>  		on_cpu_info[cpu].func(on_cpu_info[cpu].data);
> +		smp_wmb(); /* pairs with the smp_rmb() in on_cpu() and on_cpumask() */
>  	}
>  }
>  
> @@ -145,12 +146,14 @@ void on_cpumask(const cpumask_t *mask, void (*func)(void *data), void *data)
>  		smp_wait_for_event();
>  	for_each_cpu(cpu, mask)
>  		cpumask_clear_cpu(me, &on_cpu_info[cpu].waiters);
> +	smp_rmb(); /* pairs with the smp_wmb() in do_idle() */
>  }
>  
>  void on_cpu(int cpu, void (*func)(void *data), void *data)
>  {
>  	on_cpu_async(cpu, func, data);
>  	cpu_wait(cpu);
> +	smp_rmb(); /* pairs with the smp_wmb() in do_idle() */
>  }
>  
>  void on_cpus(void (*func)(void *data), void *data)


