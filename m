Return-Path: <kvm+bounces-18629-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D19B8D8136
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 13:28:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 87CF61F25D0F
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 11:28:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AE9484A41;
	Mon,  3 Jun 2024 11:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OnVgnRZ7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vk1-f171.google.com (mail-vk1-f171.google.com [209.85.221.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3B5F84A35
	for <kvm@vger.kernel.org>; Mon,  3 Jun 2024 11:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717414105; cv=none; b=rAFROrqkbzLSf5aot7hzP5R5IvD8qB2pJPZ17d1CHgjsWVrsZbSV1m6gP+inPTR8jMMn5qJ3fAeb81hDw1PjwGt8Thqx4PIGw61RIit3vWS4CcY2iD4EW36HB8zLGmEDZv4cfGbxd+rnY4GOAk1svdH1R9eddznWy2dS1ZC86C8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717414105; c=relaxed/simple;
	bh=/lZp6cbdqazTOI7WwPb91MawHQrqeY/GM5UaDsGasBA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QeVTMwVNBdgK2+gZNi2QxRBCV6ucP3XxCpd4xXUPW3W8QclCtXd2cQ+i4gLQXfV8Rrkvv3h3ZMCpJH918yCRVh2jMu4QoGpujlP4Dea27e5gqtoUCEY9Z1McEkTPrsYbUeVtfi9JLyYMwPs1bV1bZIPI1jhzDr+jTnCkly7Pxfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=OnVgnRZ7; arc=none smtp.client-ip=209.85.221.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-vk1-f171.google.com with SMTP id 71dfb90a1353d-4eb0f04c138so555025e0c.2
        for <kvm@vger.kernel.org>; Mon, 03 Jun 2024 04:28:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1717414103; x=1718018903; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PV0NIx7Msfph2Sw7+O4LVA2pjGlK/npIVQHcru0BTpM=;
        b=OnVgnRZ7Fkc5HhLi0Qm/R0dzdECiSdt1ITb/Z3Ixc8I14xTv/Rrmm9ykxg9YYl0J+n
         Nzxqe6cG+gtLUzA4oYJfkvuIldEfKX4XdPsHGR69M3KBLtq6YHAGPg26a4+Q+cHSLMYj
         KqF9F7M9s2M4InT53fEEYso4fINShPwU8rMp2u4U4S/nRBzOd5L72ehcOFY0TVJsCdpJ
         zWFUR9iJWaU+U/i8IQQhBM3H2EWmGVx70D52QXB8UA9gczENs9jwqUqew+irXH7rPgq7
         xmNcKlpH1X0ANzgRfBEO6/LS4i1RHf3SjF8zbZjiwEc2eLvkxK41gGMJhD1KvW77T3to
         /qnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717414103; x=1718018903;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PV0NIx7Msfph2Sw7+O4LVA2pjGlK/npIVQHcru0BTpM=;
        b=wZoURdl+dYfG3thWWDrcdAiifsw/zKY3JUZVYD0npG2f9qlyx4zgikHmOLvwk22edX
         J5Zl4IHsUm/KdrRgFEyeuYzZGmrgRl8c7tEiXYGpJmIkl2Yt/brlQXjgseHnrV9fKf93
         mt7t31uE4Y+gcdc8gya4eDEwzaTAwTziWO4j1pxqDqzvS1055eko8KPwaEQH9fSYxKBH
         a3cIFREhqr6p7BqkyT2Xg4FBy4BtpG031OfVo7iLprkuc5ssXhT8bgCtCJk+FBAJgNAE
         YPcvAH3OhU9GcHDG2jWvo+4GwrHD/DShEPpEsnMZ35nar8U7f0dH8N+H8aRiIu2h25NG
         IodA==
X-Forwarded-Encrypted: i=1; AJvYcCWr4Ay6DwZWGLlKWU2kMU9rYcSvzPoenUA8FgQfvfRkkkoI1P527Qfz7aUhE+QXRVcIeuGMvWBpGIJfdH62vsMcdnZP
X-Gm-Message-State: AOJu0YxZPvon0AawwUOLAwyJ9h2HTX35DaJ0XaDQyvbEs/e1c6H3Mm2G
	KElvU1w7eTT58Plc6cnsx+a6O7zLaYxMH75eM3DPXLKMUZL+eDDIsVHwfdYNEnk=
X-Google-Smtp-Source: AGHT+IH3UzMfTEg5uALlw06eeywZZ8pnfUgmvRVvZ7WisLDIs1Ne/ayWwQ/nY/MTIqQlgI+qTALHjw==
X-Received: by 2002:a1f:f8ce:0:b0:4df:1d06:eeb7 with SMTP id 71dfb90a1353d-4eb02d9aef7mr8189394e0c.1.1717414102707;
        Mon, 03 Jun 2024 04:28:22 -0700 (PDT)
Received: from [192.168.69.100] ([176.176.177.241])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-794f901a818sm235096785a.80.2024.06.03.04.28.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Jun 2024 04:28:21 -0700 (PDT)
Message-ID: <a13883da-fa6a-4ada-b75d-42ffa0bcb20b@linaro.org>
Date: Mon, 3 Jun 2024 13:28:16 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] cpu: move Qemu[Thread|Cond] setup into common code
To: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 qemu-devel@nongnu.org
Cc: Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Cameron Esfahani <dirty@apple.com>, Alexandre Iooss <erdnaxe@crans.org>,
 Yanan Wang <wangyanan55@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Eduardo Habkost <eduardo@habkost.net>,
 Sunil Muthuswamy <sunilmut@microsoft.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 Mahmoud Mandour <ma.mandourr@gmail.com>, Reinoud Zandijk
 <reinoud@netbsd.org>, kvm@vger.kernel.org,
 Roman Bolshakov <rbolshakov@ddn.com>
References: <20240530194250.1801701-1-alex.bennee@linaro.org>
 <20240530194250.1801701-3-alex.bennee@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20240530194250.1801701-3-alex.bennee@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 30/5/24 21:42, Alex Bennée wrote:
> Aside from the round robin threads this is all common code. By
> moving the halt_cond setup we also no longer need hacks to work around
> the race between QOM object creation and thread creation.
> 
> It is a little ugly to free stuff up for the round robin thread but
> better it deal with its own specialises than making the other
> accelerators jump through hoops.
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> ---
>   include/hw/core/cpu.h             |  4 ++++
>   accel/dummy-cpus.c                |  3 ---
>   accel/hvf/hvf-accel-ops.c         |  4 ----
>   accel/kvm/kvm-accel-ops.c         |  3 ---
>   accel/tcg/tcg-accel-ops-mttcg.c   |  4 ----
>   accel/tcg/tcg-accel-ops-rr.c      | 14 +++++++-------
>   hw/core/cpu-common.c              |  5 +++++
>   target/i386/nvmm/nvmm-accel-ops.c |  3 ---
>   target/i386/whpx/whpx-accel-ops.c |  3 ---
>   9 files changed, 16 insertions(+), 27 deletions(-)


> diff --git a/accel/tcg/tcg-accel-ops-rr.c b/accel/tcg/tcg-accel-ops-rr.c
> index 894e73e52c..84c36c1450 100644
> --- a/accel/tcg/tcg-accel-ops-rr.c
> +++ b/accel/tcg/tcg-accel-ops-rr.c
> @@ -317,22 +317,22 @@ void rr_start_vcpu_thread(CPUState *cpu)
>       tcg_cpu_init_cflags(cpu, false);
>   
>       if (!single_tcg_cpu_thread) {
> -        cpu->thread = g_new0(QemuThread, 1);
> -        cpu->halt_cond = g_new0(QemuCond, 1);
> -        qemu_cond_init(cpu->halt_cond);
> +        single_tcg_halt_cond = cpu->halt_cond;
> +        single_tcg_cpu_thread = cpu->thread;
>   
>           /* share a single thread for all cpus with TCG */
>           snprintf(thread_name, VCPU_THREAD_NAME_SIZE, "ALL CPUs/TCG");
>           qemu_thread_create(cpu->thread, thread_name,
>                              rr_cpu_thread_fn,
>                              cpu, QEMU_THREAD_JOINABLE);
> -
> -        single_tcg_halt_cond = cpu->halt_cond;
> -        single_tcg_cpu_thread = cpu->thread;
>       } else {
> -        /* we share the thread */
> +        /* we share the thread, dump spare data */

/* we share the thread, release allocations from cpu_common_initfn() */

> +        g_free(cpu->thread);
> +        qemu_cond_destroy(cpu->halt_cond);
>           cpu->thread = single_tcg_cpu_thread;
>           cpu->halt_cond = single_tcg_halt_cond;
> +
> +        /* copy the stuff done at start of rr_cpu_thread_fn */
>           cpu->thread_id = first_cpu->thread_id;
>           cpu->neg.can_do_io = 1;
>           cpu->created = true;

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


