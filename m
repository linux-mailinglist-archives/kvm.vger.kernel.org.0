Return-Path: <kvm+bounces-51598-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 63BD6AF94DE
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 16:02:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 076DE4A1313
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 14:01:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E19AD7D07D;
	Fri,  4 Jul 2025 14:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sgc9Dch2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 699CA360
	for <kvm@vger.kernel.org>; Fri,  4 Jul 2025 14:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751637717; cv=none; b=hlmRfZ6KaWE1XmkXYdckguiYRQoY9gnHEIcdGGThDvv5t4i6xt4NJ2H6dGE9trh0GIWvgeiBFYTdGIS5IMcHquRacG8frcjo5vijrJ5vilsjrD50IdHkCbF06Pk4ftuBJXYKZ2AdFmClhqSije1sy9ZcZjdO5Q0YDU+0iSRFzJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751637717; c=relaxed/simple;
	bh=/K0UC5gjAPlq/oh+hxGNZYbbi4brbaCN+v3bKxtIqJk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qv9BU4dseDPBHphfdwq9x6MnYlZjJjchF4/9a4QP/1YQ70cpn8OrNCZyqIzWaW6MqUCC2EZhKRN1cMve3Orrjk+tZG7rqSIUuE5XdvJnDoJ91ovK2yhE1TE8gJieRcDBl7fu9nSth8HnVXbCU/QArY4H3kbbEw+KdIaJ+eNGPC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=sgc9Dch2; arc=none smtp.client-ip=209.85.167.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-40b54ee16ddso660259b6e.1
        for <kvm@vger.kernel.org>; Fri, 04 Jul 2025 07:01:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751637714; x=1752242514; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gdQOyqpRwSgJgq1ODB3x5MH5gjNy7ViEFGXyEVIG+Y0=;
        b=sgc9Dch2EXiIAIb0tA2GOkilzEjhaW7dYIoyvcg0LiAkCQ4MQuVrGWBA7gAop6v4pt
         LqS/XT7ArWHCZsmQqg+To0GymFjjwqP9+Hh4yUX0anCvLcu65ygqWMh0RIKsf1a3qS+/
         ipkNjBnA28kiMaALpqaR5r/J1Rc5hJvcj+PHTIcyzVins63LygeZb2IyFW1zu1gJiZjP
         v3E+zkAll5xRv7SSSu9IWInYI3IvUp6Vu9hp+J7w6mq2kllC/3Q5NI7EhTdiSryNeAM0
         eKsbmsgYpA4d5qTZVgAPsJwaWWXJnyCsBXaXulDs2S4BKwkVGWV+HYJDydph/hUp0UXm
         GHAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751637714; x=1752242514;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gdQOyqpRwSgJgq1ODB3x5MH5gjNy7ViEFGXyEVIG+Y0=;
        b=OFACdtq3If3CHl6pB1S1ErNkQ6sIY+ouY9SlXZm7YNmgaEPkM8XTfFeZhfFelatn5G
         UZzHZ7lJBcooWpMfnhmoB9QA7WsXJhUYX6+/gyUlatkFJdtmXS0BcOBE/FJT9qPAfSEt
         jNjyqv7UJZN1NVhFo+UtQ9d4w5lsbyag6NIhtSwGunFsYXzflWFP10Ym1a6pAs5nj/v8
         GZCwLhAwXHvcQ2k8VTUTyS5BepKami2G9ntRcbD+DRz0H0b4zumEKjXETFBDW47Q11oO
         nssJcWOR0hCfhbqAKpYOpHwABU4Jzwvm7DTb4qa2tqLTXOeISMKITvN3RCH18KERj1Be
         d6OQ==
X-Forwarded-Encrypted: i=1; AJvYcCU+a8STTb8K+UOrvPGeUf/+laSdrDl0a3UJHqCvhhTwjxk0JoRhHPXhmUkwJky8PfWMg3c=@vger.kernel.org
X-Gm-Message-State: AOJu0YwnirMeztQQaVbJMVNJXkxG5uOS7O+ap7TL81ocBgQc8nI3rbMN
	q1uDaWia2G5BFGZVp6gEApK5ITeO8GgagvD35oaw2zaf4xnKeUx3RFki03MVArasW1U=
X-Gm-Gg: ASbGncs9NMzN9uobki/xNA3+8ywBEzPyn6Bs/6Laods1aL0mpNNLJCv65YnLHV0KNVQ
	/7rhLI08/BtZAdVOT8tNH1MwGVpQ5tOrc+0nzx8AVYj5iScVO9U+qXyGJn2Uz/cq+QhgVJHggH1
	SJsOSom9TWfBqtkiCcackDc8vXp+NRo/Xlhz5WXn2OPt+VmLhZ4FrlzcRJywBlmoEzNXOdpeFY7
	HjERHGpX1Ud9ynoBSypA770JVEqO+r28T31NWT54/YmLTgD6ZIPDEJiEpvBP0QR4pmRdNSDhhpv
	WwhZ77An8oF8/onUpLLKL4djtgOvCU4i0GXodxeny/V8ojbJv+fMZk65Bmji1hZ/zhVNiBu8oMo
	9u4lMcdN5ZgY5WZ5YNKH3D0RrlF5o4eDC29SDeAr9
X-Google-Smtp-Source: AGHT+IHxIVOO+gNuc/LC25XI0U1uFEyxSWF05BGWni1kCzTzcdJfCOeeBeDR0keZpUpg1vyhdOOQdg==
X-Received: by 2002:a05:6808:3028:b0:40a:525d:6220 with SMTP id 5614622812f47-40d043e6d65mr2043241b6e.22.1751637714178;
        Fri, 04 Jul 2025 07:01:54 -0700 (PDT)
Received: from [192.168.4.112] (fixed-187-189-51-143.totalplay.net. [187.189.51.143])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-40d02a44bc5sm315193b6e.18.2025.07.04.07.01.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Jul 2025 07:01:53 -0700 (PDT)
Message-ID: <c6eb1d9f-b3eb-4418-8bf1-6edd47ddc2e0@linaro.org>
Date: Fri, 4 Jul 2025 08:01:50 -0600
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 37/39] accel: Rename 'system/accel-ops.h' ->
 'accel/accel-cpu-ops.h'
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Zhao Liu <zhao1.liu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Cameron Esfahani <dirty@apple.com>, Roman Bolshakov <rbolshakov@ddn.com>,
 Phil Dennis-Jordan <phil@philjordan.eu>, Mads Ynddal <mads@ynddal.dk>,
 Fabiano Rosas <farosas@suse.de>, Laurent Vivier <lvivier@redhat.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Anthony PERARD <anthony@xenproject.org>, Paul Durrant <paul@xen.org>,
 "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 Reinoud Zandijk <reinoud@netbsd.org>,
 Sunil Muthuswamy <sunilmut@microsoft.com>, kvm@vger.kernel.org,
 xen-devel@lists.xenproject.org
References: <20250703173248.44995-1-philmd@linaro.org>
 <20250703173248.44995-38-philmd@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250703173248.44995-38-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/3/25 11:32, Philippe Mathieu-Daudé wrote:
> Unfortunately "system/accel-ops.h" handlers are not only
> system-specific. For example, the cpu_reset_hold() hook
> is part of the vCPU creation, after it is realized.
> 
> Mechanical rename to drop 'system' using:
> 
>    $ sed -i -e s_system/accel-ops.h_accel/accel-cpu-ops.h_g \
>                $(git grep -l system/accel-ops.h)
> 
> Signed-off-by: Philippe Mathieu-Daudé<philmd@linaro.org>
> ---
>   include/{system/accel-ops.h => accel/accel-cpu-ops.h} | 8 ++++----
>   accel/accel-common.c                                  | 2 +-
>   accel/accel-system.c                                  | 2 +-
>   accel/hvf/hvf-accel-ops.c                             | 2 +-
>   accel/kvm/kvm-accel-ops.c                             | 2 +-
>   accel/qtest/qtest.c                                   | 2 +-
>   accel/tcg/tcg-accel-ops.c                             | 2 +-
>   accel/xen/xen-all.c                                   | 2 +-
>   cpu-target.c                                          | 2 +-
>   gdbstub/system.c                                      | 2 +-
>   system/cpus.c                                         | 2 +-
>   target/i386/nvmm/nvmm-accel-ops.c                     | 2 +-
>   target/i386/whpx/whpx-accel-ops.c                     | 2 +-
>   13 files changed, 16 insertions(+), 16 deletions(-)
>   rename include/{system/accel-ops.h => accel/accel-cpu-ops.h} (96%)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~


