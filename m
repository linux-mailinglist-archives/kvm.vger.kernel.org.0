Return-Path: <kvm+bounces-2920-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D58F37FF0B9
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 14:51:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 43E11B20ED3
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 13:51:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67587482FC;
	Thu, 30 Nov 2023 13:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FFPxqjTR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18F501AD
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 05:51:18 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id 5614622812f47-3b894f5a7f3so503915b6e.2
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 05:51:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1701352277; x=1701957077; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Cf/2Zvu4Hq15RJi1vO3BfKYdCYK7/8i9PcDCPQknr+A=;
        b=FFPxqjTRvpANLWH8QAB66e1aFnaa41EAI/03Xj8lnEyNP3lINZGA/LAun/YCi5ApCj
         ZyBHovLLxLtxbj/aNr2sb/lqoodPvXZpdWAiMa4fokYTBzaXWCgdP9Jqk4QXRdnjQUK3
         R8A+sQtapNvs8ac1VjH9sic/mlTRgnR7U5c5ehqw4hUd0qzD/1oBsq2Ic4Hcny4ZGA76
         1mgGFhftL+geo3xls4Jpq5PD7V4M5RO+1FXyjzogrimvsBNZMtpzCBR7DN95chYDl2QR
         BhhnjpQBMY8M0Vy+imlt41oi0sJs/U5JpAKFe8VyiDqbKuMlEdo9LIpbYclmO3IKClCB
         1j4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701352277; x=1701957077;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Cf/2Zvu4Hq15RJi1vO3BfKYdCYK7/8i9PcDCPQknr+A=;
        b=PIplSM/FczthzZn2kywYdVo5SmUdE4H01ZvI4bP00swOaocqXnKrIl5I4wRbEoUcAq
         7QfwAh3JwynOSPrCJmOCb/CJIGobZKuzN9v1rbtTkDgNIXsaoqT/1Rx3JYgQyGukLvw+
         o3GU67F3CQoIxa63ESMx5ECYQK/n2wNND0gLMLI0ICMIJsZvV0QtSO3eiP+eDoHBjlKy
         +AGQERaMoecARgKgUMhyVpkdMEIbcVwGmzC34kzFjZNZRyT4nfFkuS0+KNb2XU7lRoXc
         zY+fdP79ANErma4LIkut86ZNXUPh6RvPu0q70/ppvT3SYJRr7bXeqqO36zSgbhcakcUw
         z4WQ==
X-Gm-Message-State: AOJu0YzEDHqQdjf2E1iB9jbZWxuamM8Ed80GOqQvbgp3sKiyDN2emMS6
	ZXcZ9hfZTntvFOIwkmK/B2dBYw==
X-Google-Smtp-Source: AGHT+IGPNIg+tSohi3PYkGeKLnn9cq6kdFZFM9ZqqPoeCFL1n0LzgznAg9EZZ11xFuByv9gBUY5ung==
X-Received: by 2002:a05:6808:14c6:b0:3b8:5c84:291a with SMTP id f6-20020a05680814c600b003b85c84291amr22001667oiw.46.1701352277293;
        Thu, 30 Nov 2023 05:51:17 -0800 (PST)
Received: from [172.20.102.4] (rrcs-71-42-197-3.sw.biz.rr.com. [71.42.197.3])
        by smtp.gmail.com with ESMTPSA id ev25-20020a056808291900b003b2f2724c48sm174558oib.11.2023.11.30.05.51.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Nov 2023 05:51:16 -0800 (PST)
Message-ID: <768e7409-62a7-441c-960d-dc99ab89c7d0@linaro.org>
Date: Thu, 30 Nov 2023 07:51:14 -0600
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] accel: Do not set CPUState::can_do_io in non-TCG accels
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Cameron Esfahani <dirty@apple.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Roman Bolshakov <rbolshakov@ddn.com>, kvm@vger.kernel.org
References: <20231129205037.16849-1-philmd@linaro.org>
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20231129205037.16849-1-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/29/23 14:50, Philippe Mathieu-Daudé wrote:
> 'can_do_io' is specific to TCG. Having it set in non-TCG
> code is confusing, so remove it from QTest / HVF / KVM.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   accel/dummy-cpus.c        | 1 -
>   accel/hvf/hvf-accel-ops.c | 1 -
>   accel/kvm/kvm-accel-ops.c | 1 -
>   3 files changed, 3 deletions(-)
> 
> diff --git a/accel/dummy-cpus.c b/accel/dummy-cpus.c
> index b75c919ac3..1005ec6f56 100644
> --- a/accel/dummy-cpus.c
> +++ b/accel/dummy-cpus.c
> @@ -27,7 +27,6 @@ static void *dummy_cpu_thread_fn(void *arg)
>       qemu_mutex_lock_iothread();
>       qemu_thread_get_self(cpu->thread);
>       cpu->thread_id = qemu_get_thread_id();
> -    cpu->neg.can_do_io = true;
>       current_cpu = cpu;

I expect this is ok...

When I was moving this variable around just recently, 464dacf6, I wondered about these 
other settings, and I wondered if they used to be required for implementing some i/o on 
behalf of hw accel.  Something that has now been factored out to e.g. kvm_handle_io, which 
now uses address_space_rw directly.

I see 3 reads of can_do_io: accel/tcg/{cputlb.c, icount-common.c} and system/watchpoint.c. 
  The final one is nested within replay_running_debug(), which implies icount and tcg.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>


r~

>   
>   #ifndef _WIN32
> diff --git a/accel/hvf/hvf-accel-ops.c b/accel/hvf/hvf-accel-ops.c
> index abe7adf7ee..2bba54cf70 100644
> --- a/accel/hvf/hvf-accel-ops.c
> +++ b/accel/hvf/hvf-accel-ops.c
> @@ -428,7 +428,6 @@ static void *hvf_cpu_thread_fn(void *arg)
>       qemu_thread_get_self(cpu->thread);
>   
>       cpu->thread_id = qemu_get_thread_id();
> -    cpu->neg.can_do_io = true;
>       current_cpu = cpu;
>   
>       hvf_init_vcpu(cpu);
> diff --git a/accel/kvm/kvm-accel-ops.c b/accel/kvm/kvm-accel-ops.c
> index 6195150a0b..f273f415db 100644
> --- a/accel/kvm/kvm-accel-ops.c
> +++ b/accel/kvm/kvm-accel-ops.c
> @@ -36,7 +36,6 @@ static void *kvm_vcpu_thread_fn(void *arg)
>       qemu_mutex_lock_iothread();
>       qemu_thread_get_self(cpu->thread);
>       cpu->thread_id = qemu_get_thread_id();
> -    cpu->neg.can_do_io = true;
>       current_cpu = cpu;
>   
>       r = kvm_init_vcpu(cpu, &error_fatal);


