Return-Path: <kvm+bounces-45454-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 19B3DAA9C08
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 20:55:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 000AD3BF9C4
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 18:54:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 098DB26F45F;
	Mon,  5 May 2025 18:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="eMwYbGeX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27CD026F444
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 18:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746471304; cv=none; b=h79QwTXSQQPdTXTSDr53P9L5JwP2mZB6kWelKUfrePdjzJamM5QZTnpPj2jfEPIxON+Fm1tKhdU+PqPv4nNHQ+vVKP6H0UmPyt1IwO4rk44zric5MKVyR5Mp45MkH/boT5EwPAQHXxN/mGoT1CTVxgX1EAMYp7dRJVQbrXEMsOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746471304; c=relaxed/simple;
	bh=gN4R/+qQ2yiuEGJIC6T5D8yTSjYWQ+soW4x7m6dGyX8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lhnXxBcDUyLtN54Zy/xJq+kE7r68kaoJmmwXi6jCbZGZzRv0h20jbgG5FR6ZyegFGROrSZPGzwkbSBT98L4GDWbPBq9OnFOwHMrSuxuuXa8RyRJzGpQ6XiOltv5+sH12Z7rveVDux/yJTAemYcpVa2yR6WAG2LAttQG5bSEKK6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=eMwYbGeX; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2295d78b45cso62822975ad.0
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 11:55:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746471301; x=1747076101; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2tArViPRB1GJjy/q5BtW0DqhJ4z03XY+HqCT81/fRSs=;
        b=eMwYbGeXxeZP91NcbeWhI8lYLOb1oXLgyPvPI/tparVGY2BnZPq47ySJ/60BcQXEOj
         YCub+90Pc6ir2zVbmHajkSYzuc4Yj1/PLo5xexwE+4BmEIqbNuKXmrI/YQnuOe0mXd27
         DHWT78qk0taQKWYr3Uhwva2AhMlUALygQfX14FNA3xfF3sA0iHB3u9mm/H38vHyNeqrf
         9oRYeEDy8Iaez4Cphjf1DTemMpEJ55WNzla6rxuimjG5yjj93kbdz6HeWec52paWdgHs
         ZOuztPd5x1N8NWye/UDWMhNVyUJwc033BIopGR8MMoKPZSW9k9/DcI7b+d4VWeTC8qJ/
         Qldw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746471301; x=1747076101;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2tArViPRB1GJjy/q5BtW0DqhJ4z03XY+HqCT81/fRSs=;
        b=RuJw2qn4bc0sTOlxdeUxBhws5K7MpE2mVMyvvWAWeC1y0NRiFFoAiBJ8JKRtgZaN7R
         hXYpniaMg6+R37u5vKhS22W2mZZiT+oMum9SuZk40Rr65g7WG2mlEZqure7Uvrv8nzGJ
         +8j4jEa7D6a4RTuZYMi9M+y9DUiOsyp9BdhUNRdayjAI5yJ31XojBAPPAoanxCM9DYcz
         z56dwNvLwsR7NmBYsvZhWAe3B0zv5yz7OyUUTSYcm2Y129E3CkUhJ5gxN93h12sEET0S
         0qycSa9pleZwxIH+ox2TGe3r414n7dfV8ZRWOwcibr2eP5ZYj/vRz7xXKlhIs/y5KepO
         CRug==
X-Forwarded-Encrypted: i=1; AJvYcCUrHKZIh7IaUmibxFkGvYNaCA3R1tihvU0Ku6xfZ+vI/CnqzF3qVnDoopA9Wlx51ViTgg4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyIec2cwnUjVvhMZ/3/aNokVsayv79E5q4zMaN5K/UcDAmrdj9a
	ov4GIPyd9Ahnfcwbve4KoJBCsbTThNOdRXBm/AzPdC3wf+p+KpwKBsdwR/gzMio=
X-Gm-Gg: ASbGncviNOxuEr9lgkLp7dIbr9gOY25CeSA/I9fTTlm+N91BNmS5gjOOKy2bcKA91ZR
	tL7dALwA8wRPwlu4Yqtrp2K/h3MmOlPX7wiNDCZ8G95IEPX52oX1TZobn6QfZYLg1LaLSTu7mma
	HG1ZcSN5JK3CRYF5DVPFLxhXG2y6sN7a3IcnMni6ScsNoSiOFZV+VoPygrpjojAXklp47e/VSw1
	LcISlwpeCKNqpjxUx4Hij7unYdyGNJZVNmTaEVHg1lXJQlb/NPfAOy+syP86rOig9F8SYx/QMdE
	Lid4/13S75c7y/OhXCeH/PXsKqoAdbNp5RuQuFUHJHYg/IhYEkrwaCNKc6QpC8FpSDlDmqlBAHe
	+PxIUwng=
X-Google-Smtp-Source: AGHT+IG4lDQTWqhb76vcNURL+Gt2usSacxFfYEmKrIk9koaQo2PtFh9GptOwkZFky9BYmlZUsaJOCQ==
X-Received: by 2002:a17:902:f64c:b0:21f:f3d:d533 with SMTP id d9443c01a7336-22e328a0c59mr7282395ad.2.1746471301306;
        Mon, 05 May 2025 11:55:01 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e1522911bsm58473495ad.191.2025.05.05.11.55.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 May 2025 11:55:00 -0700 (PDT)
Message-ID: <e8eee40f-3785-4816-b96a-af022b3031b1@linaro.org>
Date: Mon, 5 May 2025 11:54:59 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 47/48] target/arm/tcg/arith_helper: compile file twice
 (system, user)
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 alex.bennee@linaro.org, kvm@vger.kernel.org,
 Peter Maydell <peter.maydell@linaro.org>, anjo@rev.ng,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
References: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
 <20250505015223.3895275-48-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250505015223.3895275-48-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/4/25 18:52, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   target/arm/tcg/arith_helper.c | 4 +++-
>   target/arm/tcg/meson.build    | 3 ++-
>   2 files changed, 5 insertions(+), 2 deletions(-)

This one doesn't use CPUARMState, so we can probably drop the cpu.h include, and thus 
always build once.

r~

