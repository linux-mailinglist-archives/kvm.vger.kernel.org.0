Return-Path: <kvm+bounces-51344-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 961D3AF6401
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 23:29:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 345B94E2D3A
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 21:29:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 898462D6411;
	Wed,  2 Jul 2025 21:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vEndUtTz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BE8223C4ED
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 21:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751491762; cv=none; b=TbylKrXLXV3uf24YZt5ZTSbRYx+zRnA3VtxemjfLxpeoVUUPByvLa9LwW5lx3XE5/WsaRp99lHR0mPaptFsAq5T+Z7p5MnpuPCyXHcZMZwYVB2gepDYyV3pwlZ0fu6q4aiFEAsvPOlHz0adXXZJKLncksqdshGCA2EfEnE8IXT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751491762; c=relaxed/simple;
	bh=U9F7hIoxd2LP83Qsii7yzLHdpd2Mq9UfSInTkViEjT0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HN1FoCllKyWkeiABSiGBuy6IPwb9L9v0INlBCe+lXAm1W1nyrcvQ/5SaUPssgXKuprnpH38hKmK5yO6oi5kTR/wCVNX9w+NHI9BpSNdEpdlGlewzvl7NGuBZP2ySO6aioRllfcwuMgpuw5/JuThqRw3g+9iwJQBziJfZEL3x6CA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=vEndUtTz; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-74264d1832eso5912096b3a.0
        for <kvm@vger.kernel.org>; Wed, 02 Jul 2025 14:29:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751491760; x=1752096560; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1JBN4VEHHJ5qhrPCRoUcNoq+v/jCXyf0QfQS+wS4gxU=;
        b=vEndUtTz+/X7mvbN8xmCc3WW3KtqRb3ED6u3NBBeX0BCT4IsoLeOWiPX0B6vvX8cux
         KVBjgCe1XVM9XKqif4HpvYZan4fmH6GQvEixXHX7FuGCbXG6UZMnVrgwU36gSR4/C235
         CY0Vu5KWIEG59P/pRLRwBt+YucNTJ3YMQOpEIfUOjyrqTGL+ZPUfLvZw8cz3W4j0QYoF
         c5yTfLUX7sQz4BpAWAl24V0fnj5gvePvFaNUAUOU3XmsfsL2z49bGiasZw6ESg0MgAIr
         kEQg7xkxlmS4W6AslVCaPfzK71tqlYXCmz1/sGcHv/6LO6X0frg7o/kVG4qGtS+VEd4a
         aJaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751491760; x=1752096560;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1JBN4VEHHJ5qhrPCRoUcNoq+v/jCXyf0QfQS+wS4gxU=;
        b=rmeD/XRE9bfn8t4nvxTLtoIWQpu1bhtHvkx4nS+13yefRqW+ZfBtb6ldlHmlCl+pN2
         PZB7ERF14u9DtNJ20tq0w6A1IRZ09k8+lB1CiTGRnuzmVNt7Nx80PtYvp9Nm9maAwgtI
         GwtJWUplkd+kVXemITNBIs6ynAsFShZU+kbzBIFkxkLuQ7NcA8ulSOzthu0LV8ink6nx
         95JyYlsdKdUo1G6XZOFwPfiH2fQ920xMQX81mXaGtQ2pMyhGb8oB6WUNdxCSCQYwUCxD
         1vzZBItKTkfNz7u3eTSHUm/PyVhRMbPFv4iSOKknbO1X2H9nswCWevDmcxp8LsJKjIue
         Tv+Q==
X-Forwarded-Encrypted: i=1; AJvYcCVxfNz2ZpYt2Gu6LR6JfdTt6tUO/Fj0DyCtnOPBJWj1qwLTNqdLxNDrGIt/YD+FBjKE9yE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4oGjIiRGt5eJLGN7wpJLW+FPk53a1/qNFAdkhPTwOudtXAlx4
	wN7dIYb4BX30B/istwx66QsmR5Yl1RnevtT1TuFYW8eC1tOjGNbiwFPOGZxlnyPyG8c=
X-Gm-Gg: ASbGncslaFsCWx9LjS8cMQNStvfo+ylTeS8T2pXKV/6wKBkjBhX8xnHSDzx5ZQ6uv9N
	xwxb+R1/9md/ymhHzLA1NLi4oSzZxoqU3SmPK70teJGqiCStxDnO+ZxzXLXwfb9Z9oLxlU/C0L6
	4D7o6eleaxfIJMWNT0048/VzTQpoarjrznee98s6d8ryA5YOX9GBe8HMxGtazgfMNgfW3ybKhKv
	xfpYigLf1JoxXPQWgqyTbv7s/dwbuGrHb4dU0mlsEwK2us4E+jDbxirXY8GiGKBt39xBELiZJVG
	QdotWImy2w+gomOe33Ygdxdiw7sb5hs/9SbhkmA1FyO9XMPkqx8rQRbKVEd36TPr1B+HxSzug2T
	qTwoU+x9hPQ==
X-Google-Smtp-Source: AGHT+IGRuBACXsDA843dAiaUWQFNi7ADzA2La0R7WmOEy5AendhMfLNglWDzA26LIY1kDqUHVWxHxg==
X-Received: by 2002:a05:6a20:c79a:b0:220:ab9a:953b with SMTP id adf61e73a8af0-222d7ee75d9mr7746925637.29.1751491760494;
        Wed, 02 Jul 2025 14:29:20 -0700 (PDT)
Received: from [192.168.1.87] ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b34f7a42d37sm10941044a12.8.2025.07.02.14.29.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Jul 2025 14:29:20 -0700 (PDT)
Message-ID: <137f258f-c481-4a5d-a7e6-0e290e081091@linaro.org>
Date: Wed, 2 Jul 2025 14:29:19 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 58/65] accel: Always register
 AccelOpsClass::get_elapsed_ticks() handler
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Cameron Esfahani <dirty@apple.com>, Roman Bolshakov <rbolshakov@ddn.com>,
 Phil Dennis-Jordan <phil@philjordan.eu>, Mads Ynddal <mads@ynddal.dk>,
 Fabiano Rosas <farosas@suse.de>, Laurent Vivier <lvivier@redhat.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Anthony PERARD <anthony@xenproject.org>, Paul Durrant <paul@xen.org>,
 "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 Reinoud Zandijk <reinoud@netbsd.org>,
 Sunil Muthuswamy <sunilmut@microsoft.com>, kvm@vger.kernel.org,
 xen-devel@lists.xenproject.org
References: <20250702185332.43650-1-philmd@linaro.org>
 <20250702185332.43650-59-philmd@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20250702185332.43650-59-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/2/25 11:53 AM, Philippe Mathieu-Daudé wrote:
> In order to dispatch over AccelOpsClass::get_elapsed_ticks(),
> we need it always defined, not calling a hidden handler under
> the hood. Make AccelOpsClass::get_elapsed_ticks() mandatory.
> Register the default cpus_kick_thread() for each accelerator.

Missing a replace when copied from previous description.

>
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   include/system/accel-ops.h        | 1 +
>   accel/hvf/hvf-accel-ops.c         | 2 ++
>   accel/kvm/kvm-accel-ops.c         | 3 +++
>   accel/qtest/qtest.c               | 2 ++
>   accel/tcg/tcg-accel-ops.c         | 3 +++
>   accel/xen/xen-all.c               | 2 ++
>   system/cpus.c                     | 6 ++----
>   target/i386/nvmm/nvmm-accel-ops.c | 3 +++
>   target/i386/whpx/whpx-accel-ops.c | 3 +++
>   9 files changed, 21 insertions(+), 4 deletions(-)

Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>


