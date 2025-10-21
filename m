Return-Path: <kvm+bounces-60683-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 62B96BF7840
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 17:55:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8D22B561AEA
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 15:53:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F615339B5C;
	Tue, 21 Oct 2025 15:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ecN83JP5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFFDE355057
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 15:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761062009; cv=none; b=q3KUhOQdFPVROZGCt2fRhKe5DLQFJoO6PXVmDPkeS8JQv9+u2pj4u6u3ak9MntejZwAdMdvJ4YNQmb8NPZDcpfzSZ7ksogyhZbo8QxDPClzV/7aFeWc75OuFSe6CjqCgfwOIZohmC8UDbPUhALD2U16DpEAKQcKBDNl6S7lXef8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761062009; c=relaxed/simple;
	bh=uZbnCPctxCZxMksE1M3vyHoql/5XnsNEIxkZ/dzjW3Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=coYLzX0/K62YbgDitrQB/NXZlclrcRfgBwsBvFyymGQf+eQWKv8P2h7ipNh+OWRohkhw0a4W5mC0XMhLs+lKBt0FGBubSQWN2mwkgmPMB/Cmm3qgciLdFNhEs/KYKnNozY04g5Ym0FnL80aM0jxMFhtCtAnicLX2ccheM69FOsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ecN83JP5; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-426fd62bfeaso2658352f8f.2
        for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 08:53:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761062006; x=1761666806; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KZ69YW3o/ePIBmzVDZBdMJkANEHjJp/sF786gwRA3Mw=;
        b=ecN83JP5FBUGsQzLdTsmMJ0E3Cb+8AsuvAk9QegWeFOIT5e/tLf4GXw1MStjWvM73f
         pnTTDVHg/nfq10HmntsV6MYVcHNCpsXHZiInhR5W1ncfM/+ahtza0lcFNYV+V+5Ja7qi
         42tV7BngcIMV2QVDb18g+xw9Mr0OhynDUZwZX840TAsBzR+7yu6JFtCNCwttjgDpnYh3
         CP19hJc0V/nPPV0cXnmTTopv//fxpPYFomgNIn7Weib3CqQyesR0u77O/MWYqhQpFllG
         Cye7HY+xS+WE9IG5yWtJN+tY/oTz2SCOufGJiTYZz5Azj/MpGR6jfu9O/NEXDIKECMEj
         742A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761062006; x=1761666806;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KZ69YW3o/ePIBmzVDZBdMJkANEHjJp/sF786gwRA3Mw=;
        b=u4dfTkMhrlN6P6+KOmxE0brrX47Ba4Son1eE5dAlCVhmUXMjCR+2neZKj5WNNPskCX
         z3euvsXYK4ptSBfxEaxUCbD6aweDTetJs1xNcyuLjkJLu7E0+l2fzlUtNi2tzXI3t+U9
         NYAHd4g3uQqcr5TdcjZQKrW0MKxV57iA5krdyH9ytj8buLLN62NmCg8joBQm2drPI2BW
         XEd6UfIqUT70qg5SVgOFRiF5uQ9lM/YI3qs1iOzLeMr7E144wdqCtv4kz1MTtk6DC8eX
         V58zERpNr9quOXWJlq88mzDO+mwxk3NmGuDZyv77pX2MCOFuzp2e0HtAnsAxNTKGgMws
         Qbig==
X-Forwarded-Encrypted: i=1; AJvYcCWn1uKhCItoM2T6/2auN/kavTP//MdqIPnrk5bYM1aJq9lz1S3gN9rF0hINBU2q2LL/HEM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwfTm9PV870oGYk/LGdzdeGSvRpnh0T5cMsvy4hgG+j605R7UnM
	r45OoUncUbgpiN8WSxW6X0E8JNH5OkegOb6ZyZZM+MaR7yyLJJp6qa0B3WdebSXbfmg=
X-Gm-Gg: ASbGnct4GXafB/vYHXhW99H03mz9d/QOThloKo7Wn65j5CgV//Fm61hkHSS9OOfQoP6
	EYpZwTeYZHnft/rm8JMjTaY+u9wGy7gngKwiI97lG3f/0fBGfvcDRdZCPqAE2V/POwNuNDXWnfX
	t7Xge8VZ2GJjL8AwFqG+1qY0g+wpyz8Ew6P3J5H/S6VUuW7YkdAALi3yHCrV0ze0K1CvqohdcBu
	v8iM6fAMCtz7bxPJ+mxrXIQZ/S8Y27QdpaTGpKeVYcwUX92raeu8zSC88uexlPNO7td07aiypnY
	LhbHyCa8gaJe70bE6qzFPX/UU31dHmlv5HctPbYAMLaa8CpZyOFOdOncXYtd0u//J7l43KHYAHS
	4r283amf43CDhryoRWdcaRri/8Tb9irsk+2yu6C563ILiIz3OD4vk75eNOlcA6qS+/NllEwZ/oz
	C8sc34Kfxy18YQG7rV7H65kNZXuSHk+es9Dyvey0uovBU=
X-Google-Smtp-Source: AGHT+IHL2e+xkqrY2z45o8okqwvYRzoRFUyKTPAOhBYDif7RCGI5WWGGcqLjIX5xt/og3eQoETXiqw==
X-Received: by 2002:a05:6000:290f:b0:428:436d:7d7e with SMTP id ffacd0b85a97d-428436d8072mr7663928f8f.60.1761062005961;
        Tue, 21 Oct 2025 08:53:25 -0700 (PDT)
Received: from [192.168.69.221] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427ea5b3c56sm21201225f8f.18.2025.10.21.08.53.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 08:53:25 -0700 (PDT)
Message-ID: <af8debe8-8bde-4e16-840e-9d1c760e23d0@linaro.org>
Date: Tue, 21 Oct 2025 17:53:24 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 05/10] hw/rtc/mc146818rtc: Assert correct usage of
 mc146818rtc_set_cmos_data()
Content-Language: en-US
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
 <20251019210303.104718-6-shentey@gmail.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20251019210303.104718-6-shentey@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 19/10/25 23:02, Bernhard Beschow wrote:
> The offset is never controlled by the guest, so any misuse constitutes a
> programming error and shouldn't be silently ignored. Fix this by using assert().

Would be nice to document the prototype.

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

> 
> Signed-off-by: Bernhard Beschow <shentey@gmail.com>
> ---
>   hw/rtc/mc146818rtc.c | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)

