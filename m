Return-Path: <kvm+bounces-60477-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 74655BEF68B
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 08:08:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 99FFA3E451D
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 06:07:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB7312D12EC;
	Mon, 20 Oct 2025 06:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="CFh4GmIL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9B0329A9C3
	for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 06:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760940418; cv=none; b=cIT1EnN6KktRsJ8bxxknRLnUsEs12xSV7FNramyqlZ2EHdNZ6hIhVzKVcAOLXVPngLimPRgNOARkKYVbNOS+JN88HPBogtLCWcCEsTzSH9gouRCPOBCV6VnWOFyZZ+WlzX5jNu7sC0GACcTBo+n5i50V9i+sBoKPc9fNShD0SnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760940418; c=relaxed/simple;
	bh=8A1JCtKh5ee8dnGWjYA1BCmBL6EEPa+3Jm4SwngdyoE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qQR/fsKR15TG186NQ1c1/tHel6uRv3eT4NZSGjtnmkBrCXdiVUh+ISDMuGuVBZZD9zUp0Mi/AT7OOP25h5hSlFg+l3zeBG9sOekRJ2YJ1dErcz8V+IamaG1Oxjm58FessSM86qmFjd6qau6fks0yE8UZS/stEgBPIWzpbf6YZI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=CFh4GmIL; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4711f3c386eso15700605e9.0
        for <kvm@vger.kernel.org>; Sun, 19 Oct 2025 23:06:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1760940415; x=1761545215; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qlUtH9IPp3sHC1doAZ3214Uh+yQkI1bpAbLemOW71rw=;
        b=CFh4GmILiZ+NHp4mt7SvCrYuzmBVOJ6rYeVxcr4ghInhJx07iqyEohGa/mLmQoFzDW
         mleC3WOEphHvzlQp8Zw5vp486q979kdyb6LEfaARnjpYyr7ckMYCBvnnTPrziqUvDLws
         FIS/Bg3mxqHcdsD8DD+QTfLU9Qv71DMiU0HrD2g80zehZZyeUQyEq/kDtXUG2kxChOAZ
         ZfcIreTgHAg1KCinHwyRJTxrlW2bcg6+yV5hv5wsVQXQjBs5MSnH4m5ZvoglgZHZFrxe
         b85im2dutaG8YSSWUpQiLlUlcY+frnR/Gfo38zxhhG/TgepHabSeALrnNlyqOi73Nb/v
         Ygjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760940415; x=1761545215;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qlUtH9IPp3sHC1doAZ3214Uh+yQkI1bpAbLemOW71rw=;
        b=KMaC1z36UbErIsldsEmrnOeB2DHaUCDWn6pRhR7EGoHWQ/s21rb5udccsUKuKaliIS
         YYVZtPXELtaZ0LHZZ1fdWNVMNarPqsm9yNF4KZXFoIR+0Eecpr1gyZu5dE5tLUriX7Zh
         16kd7QvP+S0YZyvKghANmDWDcM/jP2koLsB0DsUxi4IeYxFYxL57/d1bsgMVxeuKHuLe
         nHjw/+jnCtn+EZZB3tSp8HfdML1KltkvUf0DFzpYDQl6t1NhrZhY3Job2igWiKeLS+ic
         k+ANh9Sw8aBAIXSFPhA98S+pMTWO/jvi8OaR18kYTNGUvintoRo1E25QeInOdCqex46G
         kS3A==
X-Forwarded-Encrypted: i=1; AJvYcCUFjrh21peLehNZUTftnKHPTA1L6sbYnQoSSQE9uYBDkEAHVhIHLqXpFy46Kn9G1iV9B6s=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/7j5sjEgZjeuScNwpsaQQVvxRPa53KITLS7teXXiEaz5VtTCo
	z8WFQp3By559Mo0PhEPVM6QHZu60rzcFMLbfNpI0ppHJ4nATyxuLkMZJw6emm0nuGfM=
X-Gm-Gg: ASbGncvMHuxGbwD8V78bOh6yHBfke3S7WopiQdnE4K+4S7EXRZ6SHqLvkFU4zeFK+fR
	Gs7ufzor5pqrguPkwtH9LsU8gx57tOHQCTXVrfhUgdi1zu499e3PwkGfoLJtbKxcS2d9OkX4sbX
	taYSFHLVq2H6gVeRblser8ZKCjIVl+9NIPQjNm3hoRFGjXJFYmxchbOXQ8bEoHU3D9UGna4LnRz
	cmIdgbpXbGmF2qgUxaSR0lpcjtXInuGAfRawczXieiaLa9zB/Fvo732ghpS/DoucWEJM1m3A7Xu
	pbNduKw5x+9QUHgxPw0mVmkjc44Eb17AUzL/qyH7q24BR2DOS/GYmyEuEhu0N0DYKa9B97OLyzt
	KgVajiD1RsW/tLoyPHAifywrmha2x4oEpC9/QhkbGXcfVvg3547QcrEQOXH1QHA7odYpZu+JPJz
	Ijllp0UjDOeG9i+Ob/sChLbDaq18xfU7AlaBPgvPQo200=
X-Google-Smtp-Source: AGHT+IGIzaGVQ+2Sqqly0gl7oT9KK5YNtQmqRqHgen6/+1ZKol+zTGnyfJtb+/jrTxyd7S4zLal29Q==
X-Received: by 2002:a05:600c:470d:b0:471:7c8:ddf7 with SMTP id 5b1f17b1804b1-471178a7447mr74887475e9.14.1760940414968;
        Sun, 19 Oct 2025 23:06:54 -0700 (PDT)
Received: from [192.168.69.221] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-471144b5c34sm224569535e9.10.2025.10.19.23.06.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Oct 2025 23:06:54 -0700 (PDT)
Message-ID: <0ed67f0b-60ef-4ed6-82a8-2a56c7966dea@linaro.org>
Date: Mon, 20 Oct 2025 08:06:52 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/10] hw/rtc/mc146818rtc: Use ARRAY_SIZE macro
To: Bernhard Beschow <shentey@gmail.com>, qemu-devel@nongnu.org
Cc: Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Laurent Vivier <laurent@vivier.eu>, "Michael S. Tsirkin" <mst@redhat.com>,
 Eduardo Habkost <eduardo@habkost.net>, Zhao Liu <zhao1.liu@intel.com>,
 kvm@vger.kernel.org, Michael Tokarev <mjt@tls.msk.ru>,
 Cameron Esfahani <dirty@apple.com>, qemu-block@nongnu.org,
 Paolo Bonzini <pbonzini@redhat.com>, qemu-trivial@nongnu.org,
 Laurent Vivier <lvivier@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Roman Bolshakov <rbolshakov@ddn.com>, Phil Dennis-Jordan
 <phil@philjordan.eu>, John Snow <jsnow@redhat.com>,
 Fabiano Rosas <farosas@suse.de>, Gerd Hoffmann <kraxel@redhat.com>,
 Sunil Muthuswamy <sunilmut@microsoft.com>,
 Marcelo Tosatti <mtosatti@redhat.com>
References: <20251019210303.104718-1-shentey@gmail.com>
 <20251019210303.104718-5-shentey@gmail.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20251019210303.104718-5-shentey@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 19/10/25 23:02, Bernhard Beschow wrote:
> Avoids the error-prone repetition of the array size.
> 
> Signed-off-by: Bernhard Beschow <shentey@gmail.com>
> ---
>   hw/rtc/mc146818rtc.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


