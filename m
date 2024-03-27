Return-Path: <kvm+bounces-12760-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C0B0D88D657
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 07:23:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3D2DE1F2A0D2
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 06:23:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BF141EB3D;
	Wed, 27 Mar 2024 06:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I4nJrXK2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9ACD17551
	for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 06:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711520609; cv=none; b=Z1esjjycqhrEMF/4Q3Qw8fXmZUNY5e+Hyy2Ox+HGEhVeUJOq07L+rn7eCswiEA0/jxrsAsckLvuQeq72dvIVl/AmavravrpHKObyKDaXt1mlOboTA6xkpzkfJlwzHZ55ricn8XvcRDZAHv6vwU9hUKj8D7WVXYCy7jn+6uMv6dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711520609; c=relaxed/simple;
	bh=0i2kC23zVuArs9RpNNp6dBE7+7F68jiyLEw1IczmYjQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dvRzDiGlDctmwwRhQNHNQZxiLmVLAxawWLLyMZbhQG9VI82Py3nKeUPWmoSMZorHp0N6roXw5q2Qdhyko0XcDo+rB/3pWS2N+lyGdfW/FjViHqLN7DHIsfyIMVOSE4z4gV04EzlmiyXvqQQ6EbDVjtbL/AAtSpLRZYwV+ZjU09Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=I4nJrXK2; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-6ea9a605ca7so420960b3a.0
        for <kvm@vger.kernel.org>; Tue, 26 Mar 2024 23:23:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711520607; x=1712125407; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=O66PNVnF+NAj9JzaNCaQDZNthEAigIUk1c4UjwhWiQI=;
        b=I4nJrXK2cI/PKcoqNc59u2DLbmEKQiRxVutvO8xrLDPGKtu+MejaQ2YLJDJeP3P4FD
         QCYMURO8FQ+mjctHHWsYBDoWb4oE4ze48jf2vAg3h0oOxYD0XIM2N1CaMfIjNnCqmo9L
         1RbFfJc9VIGrTsth+opIkMSu4rVxtsSfgLewtZFW6fGWcT79CiRHcqCJucNftY54NX7X
         2bqP9HXwxvELrPXBKHxC8dLCsB3hE3XDGcZ1MB2evyVx1ia1Uhn7Gqz60ztFGGBzbRAm
         W8Xo9Muu3YCGdriO0yiB/Ckgh2T5dGiiRHe/8trusn2VLbT/h+74Nkgh8CSkW17eA4vv
         GINg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711520607; x=1712125407;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O66PNVnF+NAj9JzaNCaQDZNthEAigIUk1c4UjwhWiQI=;
        b=YGqoAI28wFltOLCg/wAsFlmC1CNywTuE5HGb/8si7s02TC1VoTunfXuxzJSKJaxF8/
         hu8eshee78o8FQOJv6osufkFe6AAEtWE0feFcLWnQDBIkiPDkhe7lbbc2WCexjymf/ry
         QRHSDFCg2Z5JggRuU60lCu3/Gf03k6VxIz0mbzAXRjcTWg27N1qS3d1sBjSd/1rHcg0f
         YvQgK34KCykkXLxgBeVMjpvQR2+WM+Yr0jmk546/0+PCLMct7zl7tyYtzeNiL7YIeJno
         ImsQjnFcxix9Y1MkncXFETjbVM7faq+KCZ3iLJSVTRQSzAWWtYsScRzTkkA3eEls4hG/
         0IRw==
X-Forwarded-Encrypted: i=1; AJvYcCUUA1QQZ3xkAc6bzylGZkiKaKc+1iZyLZjVYxhozcCIffd1lw3YobCtVeIpHX+gsisJkHAzDl1/gJf0LsJe6lc26yB4
X-Gm-Message-State: AOJu0YzNqraXUPkz/dJR/nEA9FOES/Pt/JZ5mSV0vQyColkhdXLKTVgQ
	RFpCn1ccoPLraQ8kNuaNaSCSwGsNJJ/ag9q4utdXlbNneYWxQkEFm4UMX1qf6Q==
X-Google-Smtp-Source: AGHT+IFCckXKABUAWUGStYZCpEnS/af5chIzlaoQQySUuDkZ3MN4ob/4/Q5ohgOiBqFwo9wSZjXwQg==
X-Received: by 2002:a05:6a00:8917:b0:6ea:c767:4699 with SMTP id hw23-20020a056a00891700b006eac7674699mr1677491pfb.13.1711520606896;
        Tue, 26 Mar 2024 23:23:26 -0700 (PDT)
Received: from google.com (60.89.247.35.bc.googleusercontent.com. [35.247.89.60])
        by smtp.gmail.com with ESMTPSA id c17-20020aa781d1000000b006e6bfff6085sm7316210pfn.143.2024.03.26.23.23.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Mar 2024 23:23:26 -0700 (PDT)
Date: Wed, 27 Mar 2024 06:23:22 +0000
From: Mingwei Zhang <mizhang@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Zhenyu Wang <zhenyuw@linux.intel.com>,
	Zhang Xiong <xiong.y.zhang@intel.com>,
	Like Xu <like.xu.linux@gmail.com>,
	Jinrong Liang <cloudliang@tencent.com>,
	Dapeng Mi <dapeng1.mi@intel.com>
Subject: Re: [kvm-unit-tests Patch v3 09/11] x86: pmu: Improve LLC misses
 event verification
Message-ID: <ZgO7Wr0URLc_ru1S@google.com>
References: <20240103031409.2504051-1-dapeng1.mi@linux.intel.com>
 <20240103031409.2504051-10-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240103031409.2504051-10-dapeng1.mi@linux.intel.com>

On Wed, Jan 03, 2024, Dapeng Mi wrote:
> When running pmu test on SPR, sometimes the following failure is
> reported.
> 
> 1 <= 0 <= 1000000
> FAIL: Intel: llc misses-4
> 
> Currently The LLC misses occurring only depends on probability. It's
> possible that there is no LLC misses happened in the whole loop(),
> especially along with processors have larger and larger cache size just
> like what we observed on SPR.
> 
> Thus, add clflush instruction into the loop() asm blob and ensure once
> LLC miss is triggered at least.
> 
> Suggested-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>

I wonder if we can skip all LLC tests if CPU does not have
clflush/clflushopt properties?
> ---
>  x86/pmu.c | 43 ++++++++++++++++++++++++++++++-------------
>  1 file changed, 30 insertions(+), 13 deletions(-)
> 
> diff --git a/x86/pmu.c b/x86/pmu.c
> index b764827c1c3d..8fd3db0fbf81 100644
> --- a/x86/pmu.c
> +++ b/x86/pmu.c
> @@ -20,19 +20,21 @@
>  
>  // Instrustion number of LOOP_ASM code
>  #define LOOP_INSTRNS	10
> -#define LOOP_ASM					\
> +#define LOOP_ASM(_clflush)				\
> +	_clflush "\n\t"                                 \
> +	"mfence;\n\t"                                   \
>  	"1: mov (%1), %2; add $64, %1;\n\t"		\
>  	"nop; nop; nop; nop; nop; nop; nop;\n\t"	\
>  	"loop 1b;\n\t"
>  
> -/*Enable GLOBAL_CTRL + disable GLOBAL_CTRL instructions */
> -#define PRECISE_EXTRA_INSTRNS  (2 + 4)
> +/*Enable GLOBAL_CTRL + disable GLOBAL_CTRL + clflush/mfence instructions */
> +#define PRECISE_EXTRA_INSTRNS  (2 + 4 + 2)
>  #define PRECISE_LOOP_INSTRNS   (N * LOOP_INSTRNS + PRECISE_EXTRA_INSTRNS)
>  #define PRECISE_LOOP_BRANCHES  (N)
> -#define PRECISE_LOOP_ASM						\
> +#define PRECISE_LOOP_ASM(_clflush)					\
>  	"wrmsr;\n\t"							\
>  	"mov %%ecx, %%edi; mov %%ebx, %%ecx;\n\t"			\
> -	LOOP_ASM							\
> +	LOOP_ASM(_clflush)						\
>  	"mov %%edi, %%ecx; xor %%eax, %%eax; xor %%edx, %%edx;\n\t"	\
>  	"wrmsr;\n\t"
>  
> @@ -72,14 +74,30 @@ char *buf;
>  static struct pmu_event *gp_events;
>  static unsigned int gp_events_size;
>  
> +#define _loop_asm(_clflush)					\
> +do {								\
> +	asm volatile(LOOP_ASM(_clflush)				\
> +		     : "=c"(tmp), "=r"(tmp2), "=r"(tmp3)	\
> +		     : "0"(N), "1"(buf));			\
> +} while (0)
> +
> +#define _precise_loop_asm(_clflush)				\
> +do {								\
> +	asm volatile(PRECISE_LOOP_ASM(_clflush)			\
> +		     : "=b"(tmp), "=r"(tmp2), "=r"(tmp3)	\
> +		     : "a"(eax), "d"(edx), "c"(global_ctl),	\
> +		       "0"(N), "1"(buf)				\
> +		     : "edi");					\
> +} while (0)
>  
>  static inline void __loop(void)
>  {
>  	unsigned long tmp, tmp2, tmp3;
>  
> -	asm volatile(LOOP_ASM
> -		     : "=c"(tmp), "=r"(tmp2), "=r"(tmp3)
> -		     : "0"(N), "1"(buf));
> +	if (this_cpu_has(X86_FEATURE_CLFLUSH))
> +		_loop_asm("clflush (%1)");
> +	else
> +		_loop_asm("nop");
>  }
>  
>  /*
> @@ -96,11 +114,10 @@ static inline void __precise_count_loop(u64 cntrs)
>  	u32 eax = cntrs & (BIT_ULL(32) - 1);
>  	u32 edx = cntrs >> 32;
>  
> -	asm volatile(PRECISE_LOOP_ASM
> -		     : "=b"(tmp), "=r"(tmp2), "=r"(tmp3)
> -		     : "a"(eax), "d"(edx), "c"(global_ctl),
> -		       "0"(N), "1"(buf)
> -		     : "edi");
> +	if (this_cpu_has(X86_FEATURE_CLFLUSH))
> +		_precise_loop_asm("clflush (%1)");
> +	else
> +		_precise_loop_asm("nop");
>  }
>  
>  static inline void loop(u64 cntrs)
> -- 
> 2.34.1
> 

