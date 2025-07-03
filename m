Return-Path: <kvm+bounces-51507-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C9998AF7E6D
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 19:12:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 22DCD4A4B5E
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 17:12:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E08425A328;
	Thu,  3 Jul 2025 17:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xWJr2x2L"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF96B134CB
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 17:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751562765; cv=none; b=WshsYIzuPHSKL8bg+tgrK4wW/ed0ZyF0v71+CETKDK3KWwIsf9Xx+A6akySpUMXH0tf3FVQdU2L3oXnTtvtHRh3d5Jwna8koKn3CTWZKk7+61BTfHVM+K7cQqYlWBF6TAumRP5Noy5q5829KgUShNyBnSpKdjJ+07ATO6lwJYq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751562765; c=relaxed/simple;
	bh=scBEEyodh+8gG0qYtwtgbnPkSXt9t4rGlf/ai3Lq0xo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iI9GPu8MmwtehRq0+3N+EwNfyUdRJaAPfUyrz6h4pbUP8duprYMQwTH1ulzTbC3cALR8g6Rodl5615bNkur9q7TS4vpeTqx921mnxdd3jbMpfQj8/GOeS/e/KbdR8oL3XUCRtaFyjqx9TV6Dz8uvG86XeZxx3z/LVruvwXcRHBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=xWJr2x2L; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7387f21daadso716548a34.0
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 10:12:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751562763; x=1752167563; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=o2YgT6Ve08VSJ9Xm7zuhLRjJnhUbfcigwOq/fj4ARCw=;
        b=xWJr2x2LtfeZ+yaGWN0qzfVQMyh2JtPpXu0Wv52q/ijf0NDwKtNd91l1dkyRDAC9+v
         kjZqbhmmqwC7eeOVdJjowd5yBcJJhsc2hDRwip6A6ljVndsLTbTjRd7iE5egMMjR/mVN
         AgxsYfZ69DPGJHS+39Gjm6D9CCIHPI83Bjek01a6CZ209JUsQWqV03xTwo+GzTxnVsMe
         NwF4KUCpMi6ZiW/efumbSiKsc6HI7hTKoSn3nPrCzD66/1xWwygwU25rgBFBM8ffyAOU
         vjlSjadztT53YWLqtF7v7CKhQkOgvueTLU12yZblxCa05dwSrqUGh0klO/d2nqWlhBld
         6Stw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751562763; x=1752167563;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o2YgT6Ve08VSJ9Xm7zuhLRjJnhUbfcigwOq/fj4ARCw=;
        b=QjSnpJyoLBr9UNP2NII07rMTy2Id7DdeIdvx5NU5dpbk5f8M/JiOalk7/f6B9xFug2
         IvaC6Th6l4wAFzaEPV2SE4jdlzOLIDDWtzXmMQZTu/6S+6CpE1v2CVMF59QHfi5ojzvL
         9Kb/xvUbGoTDq8fqUlJQCH2XaVTTAPflaGh7d3cgwZQyhgUmlzpm/0fmPiFGsnD1sFds
         g4r+xPNFL64zfg9O0ASEOe793nbVskjsllUv65J7ebYcXVf8KXzOUOAFeChiFvFbXQUN
         4IAwpZ44OFLHg2Q1gNW6Ghf3lpdYZAYiQkK7ZnBFXZKRUi2pkhgftRZtamBLFoSjnSX1
         X0xQ==
X-Forwarded-Encrypted: i=1; AJvYcCVoc1creOXWadbpdZwplW8kxFL2ePhQoi2s0J9ecyGvh/K2iZMznQVKCEi4dUbhmYgT0Og=@vger.kernel.org
X-Gm-Message-State: AOJu0YxioDJ1p9AEfnuQDGyczZi6IlvgZaujXQNNl+g/9rIBS9NS4ebm
	u0hdr6phzdaLgYNTh3XytEEn9Ac9DZKL1/9RKotTWzWKqDBJhIKAcxtb/76BzaRx+Bs=
X-Gm-Gg: ASbGncutlEmSsu8WgcmXAl6ARhO/WQnhXR+fhrhAXxl7TPeo/SVTIwQvj1I5NWCX1qN
	ANpPKs10OaByu6/jxqbx29yEB6lnJ/x7Nyd4aZyoaZ19cbmw8GKasfAPqq5gc9DHWAzpMK+rCHW
	8PuJ2xsiHO+Azt//GX0kaPNdRTuH1TgbwU+S07PjXPH7C0zpedz1frji3MqKR1eXEAW/pcQ/YeV
	ji6NtiBoDQNGTKeY5xG7jru3aMs8KGlHwrRGB9ZXr/gzMtWvnRHTuV/ybXoooCSWVptC1w5gxQX
	6hiLznfLtyxsix+jCZe6+6HHmzZSHH6f2tIrlhopq/+sUGDxGgp2xDFlcK8mF418EnUCP3psuzP
	r
X-Google-Smtp-Source: AGHT+IF5l9apRRehOl6m5fQfC7kxHzdRpKufN4Z2O8WUBM7+FA5gQoKNugd8V4FGWEYtQvwAJLiaOw==
X-Received: by 2002:a9d:694e:0:b0:72b:7dbb:e39d with SMTP id 46e09a7af769-73ca0458421mr3637a34.1.1751562762941;
        Thu, 03 Jul 2025 10:12:42 -0700 (PDT)
Received: from [10.25.6.71] ([187.210.107.185])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-73c9f751e3csm33618a34.17.2025.07.03.10.12.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Jul 2025 10:12:42 -0700 (PDT)
Message-ID: <0243f1ab-9b75-43eb-8bd4-57a3bd9ca579@linaro.org>
Date: Thu, 3 Jul 2025 11:12:39 -0600
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 24/69] accel/tcg: Remove profiler leftover
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>, kvm@vger.kernel.org
References: <20250703105540.67664-1-philmd@linaro.org>
 <20250703105540.67664-25-philmd@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250703105540.67664-25-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/3/25 04:54, Philippe Mathieu-Daudé wrote:
> TCG profiler was removed in commit 1b65b4f54c7.
> 
> Fixes: 1b65b4f54c7 ("accel/tcg: remove CONFIG_PROFILER")
> Signed-off-by: Philippe Mathieu-Daudé<philmd@linaro.org>
> ---
>   accel/tcg/monitor.c | 6 ------
>   1 file changed, 6 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

