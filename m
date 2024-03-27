Return-Path: <kvm+bounces-12757-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B314A88D623
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 06:57:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6B3911F2A0BC
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 05:57:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EF7E1DA21;
	Wed, 27 Mar 2024 05:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YQ7unryc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4908E572
	for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 05:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711519056; cv=none; b=iudHCY1CPcL9vsjlsiANha3CsOtwv2/56PONWV5WCHApVvKxqpx/OmthN5e3rBmaKZ3zyVltbtsUrHXo5YSn8MrqyY9mb8MJ8d6J2N5wssJG3yABOnfEk5OXpASNoA5OQwcu+6JprcTlnYZttEBNU+KSEyNxGrd85dfiCWS9jZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711519056; c=relaxed/simple;
	bh=A+E6Q8O/+odDiW3CmDioCMgwZfI7X8h9ZMP4WmUHwBE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g+kgy3J5ktk2iZWdZv74IsRbgLT2UuMZRqtEjKNN5hIZpYLlW6wlkaX4hXnbzaWjjtfD+2rFssQscQydg532ZM4YQR5uH+HcfAYpc17AEyJ7LCh2j2xUjNkTqRZinpvgJUlz2Bdz7pvr0O6AhHWtDPA+ZiH2r9m/qfHNH43s7Dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=YQ7unryc; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a466fc8fcccso805009966b.1
        for <kvm@vger.kernel.org>; Tue, 26 Mar 2024 22:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1711519053; x=1712123853; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=vauhzS1zFrSoAno2ebrQWSRp6RiLw20nALTCk+DSh4A=;
        b=YQ7unrycEQzcL0CpfY7iaq8l+p0vR5BmeT1rDhDj4xbxg2DhKiY1Kf1CgvA1o4geDC
         zb9ZsQsBKmIrmKceYOpf6HSVIGcPhIQsCbsIdKnovz4uZnJiuMZRzFTwr7TacgYlP9zr
         FPi1hmr7ifb1dhK5hP4NWXNpr8NL0Pa3ETyumrif0HRQuABgeUoqE7RqpqFI1hn3sm8v
         BuwQyJCArIgpNbx/fqzwaAINx9dRolmNZovSG+3A5PyoErSPVbP3q2pC2ngr1VL1Fqb4
         Yk5xBBygI+nz87qnXovPxXIijSJRrS3pvhZr2u6Ouwl/sXzsYjxQto9H9xkXk+6+ZOUi
         sH8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711519053; x=1712123853;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vauhzS1zFrSoAno2ebrQWSRp6RiLw20nALTCk+DSh4A=;
        b=PkWG+feGKsAAtTlMcWRwCdV8ZQpBOo9nlPdMq5ycp3OsAQ6Wun0ieaZNvw9wZMkFfg
         7UQCd5QvqhJ2fnbyk4olWbIxk4reF600Dev/QnN0S4aaoi6JRW/744LjapmE9Stuhq32
         SIuVm1/WRi7Csz1tDYs9bsJ121I7kU9tacR2RAq9bXC+wogYX5TuUI3mBJksxnikxuHx
         4eG6vh7/CipLhr0QeZErY8l5i51rB3W0Fw1Szij+KeXGwPzzAFlgddFlj4djnL9V55X0
         xPy4SrJcKcbGd7UlvvOHXSHpV7FNp7JyzVtvS6/GKNz9sfgjNVfRz3tW/RnFkcu6d88e
         GsiQ==
X-Forwarded-Encrypted: i=1; AJvYcCUHT340lHElGx9IGjHOhevTo587/kRWqvRsYmOQpNI8VF9VVPGBCV8KPnwgNkO5/qPpyd1/cmHExyWi79439EGOa0ZK
X-Gm-Message-State: AOJu0YyfygbcU7RstRteEfLOIQamNHRrA//xPTgdCcWzeEX0RD6hNVBI
	173XsQUyuI8J04sPtrE56PTuXQ1y6g9VTwzeuxdY9AfUJNTeGltMNskdDT/6NxY=
X-Google-Smtp-Source: AGHT+IHgkILYmFrhP+1BUm5J8vIOXx7XAe6AnD/e+QIq7e6Sav87TDQXgMfr4F3e8r5OX6uegtkhNg==
X-Received: by 2002:a17:906:c35a:b0:a47:223f:2285 with SMTP id ci26-20020a170906c35a00b00a47223f2285mr2239743ejb.7.1711519053181;
        Tue, 26 Mar 2024 22:57:33 -0700 (PDT)
Received: from [192.168.1.20] ([178.197.199.128])
        by smtp.gmail.com with ESMTPSA id s10-20020a170906354a00b00a47a33b3aa2sm3466993eja.157.2024.03.26.22.57.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Mar 2024 22:57:32 -0700 (PDT)
Message-ID: <f23f2e60-e5c0-4c3c-9722-dba63a6e7ef6@linaro.org>
Date: Wed, 27 Mar 2024 06:57:30 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/19] amba: store owner from modules with
 amba_driver_register()
To: Suzuki K Poulose <suzuki.poulose@arm.com>,
 Russell King <linux@armlinux.org.uk>, Mike Leach <mike.leach@linaro.org>,
 James Clark <james.clark@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Alexandre Torgue <alexandre.torgue@foss.st.com>,
 Linus Walleij <linus.walleij@linaro.org>, Andi Shyti
 <andi.shyti@kernel.org>, Olivia Mackall <olivia@selenic.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, Vinod Koul <vkoul@kernel.org>,
 Dmitry Torokhov <dmitry.torokhov@gmail.com>,
 Miquel Raynal <miquel.raynal@bootlin.com>,
 Michal Simek <michal.simek@amd.com>, Eric Auger <eric.auger@redhat.com>,
 Alex Williamson <alex.williamson@redhat.com>
Cc: linux-kernel@vger.kernel.org, coresight@lists.linaro.org,
 linux-arm-kernel@lists.infradead.org,
 linux-stm32@st-md-mailman.stormreply.com, linux-i2c@vger.kernel.org,
 linux-crypto@vger.kernel.org, dmaengine@vger.kernel.org,
 linux-input@vger.kernel.org, kvm@vger.kernel.org
References: <20240326-module-owner-amba-v1-0-4517b091385b@linaro.org>
 <3f61d6d3-a0d6-4c49-b094-6ba62d09ab14@arm.com>
Content-Language: en-US
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Autocrypt: addr=krzysztof.kozlowski@linaro.org; keydata=
 xsFNBFVDQq4BEAC6KeLOfFsAvFMBsrCrJ2bCalhPv5+KQF2PS2+iwZI8BpRZoV+Bd5kWvN79
 cFgcqTTuNHjAvxtUG8pQgGTHAObYs6xeYJtjUH0ZX6ndJ33FJYf5V3yXqqjcZ30FgHzJCFUu
 JMp7PSyMPzpUXfU12yfcRYVEMQrmplNZssmYhiTeVicuOOypWugZKVLGNm0IweVCaZ/DJDIH
 gNbpvVwjcKYrx85m9cBVEBUGaQP6AT7qlVCkrf50v8bofSIyVa2xmubbAwwFA1oxoOusjPIE
 J3iadrwpFvsZjF5uHAKS+7wHLoW9hVzOnLbX6ajk5Hf8Pb1m+VH/E8bPBNNYKkfTtypTDUCj
 NYcd27tjnXfG+SDs/EXNUAIRefCyvaRG7oRYF3Ec+2RgQDRnmmjCjoQNbFrJvJkFHlPeHaeS
 BosGY+XWKydnmsfY7SSnjAzLUGAFhLd/XDVpb1Een2XucPpKvt9ORF+48gy12FA5GduRLhQU
 vK4tU7ojoem/G23PcowM1CwPurC8sAVsQb9KmwTGh7rVz3ks3w/zfGBy3+WmLg++C2Wct6nM
 Pd8/6CBVjEWqD06/RjI2AnjIq5fSEH/BIfXXfC68nMp9BZoy3So4ZsbOlBmtAPvMYX6U8VwD
 TNeBxJu5Ex0Izf1NV9CzC3nNaFUYOY8KfN01X5SExAoVTr09ewARAQABzTRLcnp5c3p0b2Yg
 S296bG93c2tpIDxrcnp5c3p0b2Yua296bG93c2tpQGxpbmFyby5vcmc+wsGUBBMBCgA+FiEE
 m9B+DgxR+NWWd7dUG5NDfTtBYpsFAmI+BxMCGwMFCRRfreEFCwkIBwIGFQoJCAsCBBYCAwEC
 HgECF4AACgkQG5NDfTtBYptgbhAAjAGunRoOTduBeC7V6GGOQMYIT5n3OuDSzG1oZyM4kyvO
 XeodvvYv49/ng473E8ZFhXfrre+c1olbr1A8pnz9vKVQs9JGVa6wwr/6ddH7/yvcaCQnHRPK
 mnXyP2BViBlyDWQ71UC3N12YCoHE2cVmfrn4JeyK/gHCvcW3hUW4i5rMd5M5WZAeiJj3rvYh
 v8WMKDJOtZFXxwaYGbvFJNDdvdTHc2x2fGaWwmXMJn2xs1ZyFAeHQvrp49mS6PBQZzcx0XL5
 cU9ZjhzOZDn6Apv45/C/lUJvPc3lo/pr5cmlOvPq1AsP6/xRXsEFX/SdvdxJ8w9KtGaxdJuf
 rpzLQ8Ht+H0lY2On1duYhmro8WglOypHy+TusYrDEry2qDNlc/bApQKtd9uqyDZ+rx8bGxyY
 qBP6bvsQx5YACI4p8R0J43tSqWwJTP/R5oPRQW2O1Ye1DEcdeyzZfifrQz58aoZrVQq+innR
 aDwu8qDB5UgmMQ7cjDSeAQABdghq7pqrA4P8lkA7qTG+aw8Z21OoAyZdUNm8NWJoQy8m4nUP
 gmeeQPRc0vjp5JkYPgTqwf08cluqO6vQuYL2YmwVBIbO7cE7LNGkPDA3RYMu+zPY9UUi/ln5
 dcKuEStFZ5eqVyqVoZ9eu3RTCGIXAHe1NcfcMT9HT0DPp3+ieTxFx6RjY3kYTGLOwU0EVUNc
 NAEQAM2StBhJERQvgPcbCzjokShn0cRA4q2SvCOvOXD+0KapXMRFE+/PZeDyfv4dEKuCqeh0
 hihSHlaxTzg3TcqUu54w2xYskG8Fq5tg3gm4kh1Gvh1LijIXX99ABA8eHxOGmLPRIBkXHqJY
 oHtCvPc6sYKNM9xbp6I4yF56xVLmHGJ61KaWKf5KKWYgA9kfHufbja7qR0c6H79LIsiYqf92
 H1HNq1WlQpu/fh4/XAAaV1axHFt/dY/2kU05tLMj8GjeQDz1fHas7augL4argt4e+jum3Nwt
 yupodQBxncKAUbzwKcDrPqUFmfRbJ7ARw8491xQHZDsP82JRj4cOJX32sBg8nO2N5OsFJOcd
 5IE9v6qfllkZDAh1Rb1h6DFYq9dcdPAHl4zOj9EHq99/CpyccOh7SrtWDNFFknCmLpowhct9
 5ZnlavBrDbOV0W47gO33WkXMFI4il4y1+Bv89979rVYn8aBohEgET41SpyQz7fMkcaZU+ok/
 +HYjC/qfDxT7tjKXqBQEscVODaFicsUkjheOD4BfWEcVUqa+XdUEciwG/SgNyxBZepj41oVq
 FPSVE+Ni2tNrW/e16b8mgXNngHSnbsr6pAIXZH3qFW+4TKPMGZ2rZ6zITrMip+12jgw4mGjy
 5y06JZvA02rZT2k9aa7i9dUUFggaanI09jNGbRA/ABEBAAHCwXwEGAEKACYCGwwWIQSb0H4O
 DFH41ZZ3t1Qbk0N9O0FimwUCYDzvagUJFF+UtgAKCRAbk0N9O0Fim9JzD/0auoGtUu4mgnna
 oEEpQEOjgT7l9TVuO3Qa/SeH+E0m55y5Fjpp6ZToc481za3xAcxK/BtIX5Wn1mQ6+szfrJQ6
 59y2io437BeuWIRjQniSxHz1kgtFECiV30yHRgOoQlzUea7FgsnuWdstgfWi6LxstswEzxLZ
 Sj1EqpXYZE4uLjh6dW292sO+j4LEqPYr53hyV4I2LPmptPE9Rb9yCTAbSUlzgjiyyjuXhcwM
 qf3lzsm02y7Ooq+ERVKiJzlvLd9tSe4jRx6Z6LMXhB21fa5DGs/tHAcUF35hSJrvMJzPT/+u
 /oVmYDFZkbLlqs2XpWaVCo2jv8+iHxZZ9FL7F6AHFzqEFdqGnJQqmEApiRqH6b4jRBOgJ+cY
 qc+rJggwMQcJL9F+oDm3wX47nr6jIsEB5ZftdybIzpMZ5V9v45lUwmdnMrSzZVgC4jRGXzsU
 EViBQt2CopXtHtYfPAO5nAkIvKSNp3jmGxZw4aTc5xoAZBLo0OV+Ezo71pg3AYvq0a3/oGRG
 KQ06ztUMRrj8eVtpImjsWCd0bDWRaaR4vqhCHvAG9iWXZu4qh3ipie2Y0oSJygcZT7H3UZxq
 fyYKiqEmRuqsvv6dcbblD8ZLkz1EVZL6djImH5zc5x8qpVxlA0A0i23v5QvN00m6G9NFF0Le
 D2GYIS41Kv4Isx2dEFh+/Q==
In-Reply-To: <3f61d6d3-a0d6-4c49-b094-6ba62d09ab14@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 27/03/2024 00:24, Suzuki K Poulose wrote:
> Hi Krzysztof
> 
> On 26/03/2024 20:23, Krzysztof Kozlowski wrote:
>> Merging
>> =======
>> All further patches depend on the first amba patch, therefore please ack
>> and this should go via one tree.
> 
> Are you able to provide a stable branch with these patches once you pull

I doubt I will be merging this. I think amba code goes through Russell.

> them in to "one tree" here ? We have changes coming up in the coresight
> tree, which would conflict with the changes here (horribly).
> 

You mean conflict with  coresight conversion to platform driver? Worst
case it is solveable: just drop .owner.

Best regards,
Krzysztof


