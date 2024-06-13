Return-Path: <kvm+bounces-19567-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DEAC69067E0
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 10:57:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B4B59B24DA5
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 08:56:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88CF113DDDD;
	Thu, 13 Jun 2024 08:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DTMTNpPd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBCB313D628
	for <kvm@vger.kernel.org>; Thu, 13 Jun 2024 08:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718268883; cv=none; b=Z8EhkxzEEAE42stNwuUXXnXxtHTgmq0FY6/Q/u1YFYhXRdQweGDwC619hw/OG3DeLjflHgeNyntjy4/CowyvjZIi9IRMYJ0wymeTPgLfCeaijdHfL7Hg9w0k0RWLp3SHtI5jWjm8a0clWMu51XNVuSeKqJsgyVEAm2BmbVBM+ZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718268883; c=relaxed/simple;
	bh=8IpmT6gSMCi5SqpAaalYKEec6jbByuMR5uslPkrV8XU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pYPLPeNOXcWiLTSk9V8/ymfQBYBT5QVOPufA1xC9djgJPtzyiaSE56D/bVOK73d1BC3qY3R/PJupaNmNApnnKCf/53nDpQbP+hg4CTdPJhcvQ0DadeiBv6qQBoM6iFsF/Ho1StUj2P26WcA9gVh5TmDU0qnFNMhcHxBg9ZXJJEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=DTMTNpPd; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a6265d48ec3so103525466b.0
        for <kvm@vger.kernel.org>; Thu, 13 Jun 2024 01:54:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718268879; x=1718873679; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OSosgpSQsH3wF5+acrPONfzVPkjEd+Wi3xrEgOavQvA=;
        b=DTMTNpPd721a/FNrn+nQdLY0Wu2bmiRNUo9zwrkE6JEyrt3J5h1x5y0Nc11cvEKqHq
         7oSEJXXmnrLQq9u6dzNgnLcZ8FC6nayTOvegBE0gicX69mh6dC45GxJVSxruNA4IXJbg
         EZi5o/raybOvR1xzwTl+WgEq7eG3tYPopiJWtO89jOcgnoWDi/bi1SzCJ5AAoPD9zXDw
         2HJ5b1gxVGzXm2j79cTgd+jK7U3QjjfdDkb1oPLybmf1DkDKP5lB2y62dET7sunF/v+q
         RqCtFa9b+HbXIbEilTP9K7yjrZ2LdMDbAf4cKVyZ8stTdj9Ic9JECdLXwr1SdoWus7hZ
         kWCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718268879; x=1718873679;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OSosgpSQsH3wF5+acrPONfzVPkjEd+Wi3xrEgOavQvA=;
        b=eLqQ1HeuE9W+ynbmRY0LznpsFYQPaYBaflsnTi4PTnRp/lVu2Tb05BJ3bBUJcOf/wX
         uGeO7hhkh9wvAwKAIXPQ3/D2WuDGri37ljtBi3f4cF8v8gVh/2msLGbTraUZcAGhLVuQ
         dAexhx/h98qLEhSpS7//cgBjkn0OBy6bBDzLSun9kRG55gL9ayFCEpXWXuxB/ZOlbeXo
         fxu4YR3ekg67nWEIdlfBUpQ8B6QIsEXok0XDgWngcZLzkXTEzZiyx8QKkJ1chFNup9H7
         I2TesHWGBeKJS2FtnBDLOJMVGoTc9mV3Km6ZJto1z/aKNj+WWp3o+UVb+YBnwjFdNDvh
         p/mQ==
X-Forwarded-Encrypted: i=1; AJvYcCXTt4BykzRnD4D1YLTA88Nmtlnu67kYEaLRBovorib2nkDXJHfkK6t+U1UUonCyuwQAIVKPX8Ku16RYjM07ckgQ0tGB
X-Gm-Message-State: AOJu0YyouP9tMcHMA5duftWV/AQmYUQjz2EUwM7aKnYFKTnnkYefE3PA
	IA62wUXkqrnEEK8DlPbcsC79DmdCOhbgZ8inkfoSJ8hzhy0trVz8HcR2/fk8KF0=
X-Google-Smtp-Source: AGHT+IFSKrJ8w4FyvGIuF2YLGd5N2judWSHl/BPRtdMcekWFGCtPgkKSJ0KoLlp2so+7sZANrQJZ3g==
X-Received: by 2002:a17:906:6bc1:b0:a6f:3155:bb89 with SMTP id a640c23a62f3a-a6f47d5f3c8mr229050366b.70.1718268878803;
        Thu, 13 Jun 2024 01:54:38 -0700 (PDT)
Received: from [192.168.69.100] ([176.176.148.226])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6f56da40a0sm50331866b.10.2024.06.13.01.54.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Jun 2024 01:54:38 -0700 (PDT)
Message-ID: <31ba8570-9009-4530-934d-3b73b07520d0@linaro.org>
Date: Thu, 13 Jun 2024 10:54:34 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 9/9] contrib/plugins: add ips plugin example for cost
 modeling
To: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 qemu-devel@nongnu.org
Cc: David Hildenbrand <david@redhat.com>, Ilya Leoshkevich
 <iii@linux.ibm.com>, Daniel Henrique Barboza <danielhb413@gmail.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 Mark Burton <mburton@qti.qualcomm.com>, qemu-s390x@nongnu.org,
 Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
 Laurent Vivier <lvivier@redhat.com>, Halil Pasic <pasic@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Alexandre Iooss <erdnaxe@crans.org>, qemu-arm@nongnu.org,
 Alexander Graf <agraf@csgraf.de>, Nicholas Piggin <npiggin@gmail.com>,
 Marco Liebel <mliebel@qti.qualcomm.com>, Thomas Huth <thuth@redhat.com>,
 Roman Bolshakov <rbolshakov@ddn.com>, qemu-ppc@nongnu.org,
 Mahmoud Mandour <ma.mandourr@gmail.com>, Cameron Esfahani <dirty@apple.com>,
 Jamie Iles <quic_jiles@quicinc.com>,
 "Dr. David Alan Gilbert" <dave@treblig.org>,
 Richard Henderson <richard.henderson@linaro.org>
References: <20240612153508.1532940-1-alex.bennee@linaro.org>
 <20240612153508.1532940-10-alex.bennee@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20240612153508.1532940-10-alex.bennee@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/6/24 17:35, Alex Bennée wrote:
> From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> 
> This plugin uses the new time control interface to make decisions
> about the state of time during the emulation. The algorithm is
> currently very simple. The user specifies an ips rate which applies

... IPS rate (Instructions Per Second) which ...

> per core. If the core runs ahead of its allocated execution time the
> plugin sleeps for a bit to let real time catch up. Either way time is
> updated for the emulation as a function of total executed instructions
> with some adjustments for cores that idle.
> 
> Examples
> --------
> 
> Slow down execution of /bin/true:
> $ num_insn=$(./build/qemu-x86_64 -plugin ./build/tests/plugin/libinsn.so -d plugin /bin/true |& grep total | sed -e 's/.*: //')
> $ time ./build/qemu-x86_64 -plugin ./build/contrib/plugins/libips.so,ips=$(($num_insn/4)) /bin/true
> real 4.000s
> 
> Boot a Linux kernel simulating a 250MHz cpu:
> $ /build/qemu-system-x86_64 -kernel /boot/vmlinuz-6.1.0-21-amd64 -append "console=ttyS0" -plugin ./build/contrib/plugins/libips.so,ips=$((250*1000*1000)) -smp 1 -m 512
> check time until kernel panic on serial0
> 
> Tested in system mode by booting a full debian system, and using:
> $ sysbench cpu run
> Performance decrease linearly with the given number of ips.
> 
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> Message-Id: <20240530220610.1245424-7-pierrick.bouvier@linaro.org>
> ---
>   contrib/plugins/ips.c    | 164 +++++++++++++++++++++++++++++++++++++++
>   contrib/plugins/Makefile |   1 +
>   2 files changed, 165 insertions(+)
>   create mode 100644 contrib/plugins/ips.c
> 
> diff --git a/contrib/plugins/ips.c b/contrib/plugins/ips.c
> new file mode 100644
> index 0000000000..db77729264
> --- /dev/null
> +++ b/contrib/plugins/ips.c
> @@ -0,0 +1,164 @@
> +/*
> + * ips rate limiting plugin.

The plugin names are really to packed to my taste (each time I look for
one I have to open most source files to figure out the correct one); so
please ease my life by using a more descriptive header at least:

      Instructions Per Second (IPS) rate limiting plugin.

Thanks.

> + * This plugin can be used to restrict the execution of a system to a
> + * particular number of Instructions Per Second (ips). This controls
> + * time as seen by the guest so while wall-clock time may be longer
> + * from the guests point of view time will pass at the normal rate.
> + *
> + * This uses the new plugin API which allows the plugin to control
> + * system time.
> + *
> + * Copyright (c) 2023 Linaro Ltd
> + *
> + * SPDX-License-Identifier: GPL-2.0-or-later
> + */


