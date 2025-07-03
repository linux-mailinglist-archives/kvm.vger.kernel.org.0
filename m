Return-Path: <kvm+bounces-51474-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 66355AF7194
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 13:06:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9512B4E4FFA
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 11:03:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B87242D4B53;
	Thu,  3 Jul 2025 11:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="O4jjMGCo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A99B244667
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 11:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540553; cv=none; b=J8mKQGVMjCPZJOLvNlHpz1Wdg2l8BLJk3o+ys7gOYamgVq9ZTPXcTnYJ27xvSzj72vdVEwXCQvWP8BB2/WyVvY6YFRC5MnLAbWBp65CF4YHaLYxVyur+Couo7b6CcbI8C7j9GAtKa4ppV2pHEYt5jdXdJtZq0iurp1B6B7GPPC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540553; c=relaxed/simple;
	bh=Tpn3mMzalzsnjsHS8oQuDxx0AgctHiaZH25gJbw6XN8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WZga2+l25zDpRXVmtUA1e2wH0cSD8M3hB78936+z9qKTd8WCze5xszJJseDiqyNAKRLNQyN5myvk1O7+P5Nx+y7egf594+R7mlKgSe2uw0H3SQL69cpL/CsK2Ce4NgiX+zFKqqtBvz/620W2KNJ3mUS4JWwg2rYkC2Xg7QIMuVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=O4jjMGCo; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-450ce3a2dd5so43432885e9.3
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 04:02:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540550; x=1752145350; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=meZf1hVHaaxBu1fyzABE7Mgyq70ajpFE8FzWCylSOKM=;
        b=O4jjMGCo6mnhFvCaJntQjv/Ppl9npbuwNgDI1AYP0XZoynSJBNuBYJgH6RxH4tsFVV
         8w9cIao0fZ67A15vxmF9NnhGThMNyGu87E8fbg++RwRTLrTFo+hJIX/011OTZpXIUvqY
         PMhs5DW4Nw4FmP7D0kMT/8wzd8R1c3RqYMZd+mKf64zMuPSpvZrp17c3Augpt5QEZExy
         oFud46yVwDv2rxQ2C6RU3XX2YKLF8+vfm1WNJODNibUQ+tejnNKM4b2yOKv1kgbhByzn
         vBd3UPaX0Csbe2uY+IgB0AS5x6Sq9s5t3ejez98z3aYNLfIMVT2xERyk2DvoEMoNqKAh
         VfFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540550; x=1752145350;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=meZf1hVHaaxBu1fyzABE7Mgyq70ajpFE8FzWCylSOKM=;
        b=wyAXc0zDXYZl4Z3SUvlPerlWhnKi5nifTchBbY8s9ULhyVqpmy7PuoQKSL8UFRtwq9
         cS/ZI5fks88FCdTlXugFRXbHVebScSPFJAbYZjI/06LJAvwZyI/kE1fqUZd2JUa7PgpY
         vEoK3trB7WXMFV+XtJevr3t45ClSon2wOU/KPPtwDcGt0xeZPzYyE6ChMFltg5qV0fte
         ulgSDzG2yHLxAlSYWwgU5asokDgA6FYb/0kSU8CLCrBgonDjALwCnnAYyfCb/HfDAGgo
         j0XhBRvHXlGUs+OhdqowiD76bM7/aF9LpG5wIQvSpslWc/4mgUAuJ/ziMOYMjG4GLYzO
         ebkQ==
X-Forwarded-Encrypted: i=1; AJvYcCXrA0lQGtM7ic7fXtnvb1EVwKJQUYvqmSeRukAyAArEmQsRJfxy5m2cgQ/7hg96OBVX+ug=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzo7sXfH/zvhO3O7MSbzxVrlyTY6jexwU0vatNFfECKjR04+/XF
	2dZiSI9WoVWTDn72zuZZW1qDJr5NykPGevw12OP3Hm3xU/CEU2qZJ5D9T7K301sHtcQ=
X-Gm-Gg: ASbGnctZWQ0LmoFSy8yu8U+H0RMzb38EwoIsz4w1l2D35uGsfgHt3Ob0ta+fzdb2gD9
	aRIJkR244Bc3ngcetmvdIYoIrPqUymQCkqQl95m3TqY5MeRA3YPQXrY6juiaPdXCIO6KygVODa/
	DlLC47kEmdsJBcGJI21rHaj5pLrtd7rPYfRldoueW6gJhf5yJ8qQDZv0QrZFu/nWHJm2jqAWhET
	pcZx3Y/9igMNVP3DgClPVEgGpTyuSfkcyneRpMjMs+Qyh79GkrzcYIBoIZl97DttR4YW3ENxR80
	jls5DC5CBhcv4MOsaARhSCTbeURuoFpEZI8sv0zQ6a0EWtNuxL7dVW0/PvAb5vqGK/PLjV0FxJx
	T
X-Google-Smtp-Source: AGHT+IGOA9Ob4y6TwQ5oCy+TIN5OtIeanArU9CkD0fKkQN/9Okrbch/1y9NMbm9E19Sa1W0uY1YE2g==
X-Received: by 2002:a05:600c:4688:b0:453:81a:2f3f with SMTP id 5b1f17b1804b1-454a372df70mr75702425e9.30.1751540550215;
        Thu, 03 Jul 2025 04:02:30 -0700 (PDT)
Received: from [10.79.43.25] ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454a99a35f9sm23430675e9.27.2025.07.03.04.02.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Jul 2025 04:02:29 -0700 (PDT)
Message-ID: <1ede3bf9-4afe-4616-8a2b-ec3a4087f941@linaro.org>
Date: Thu, 3 Jul 2025 13:02:28 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 45/69] accel/whpx: Expose whpx_enabled() to common code
To: qemu-devel@nongnu.org
Cc: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>, kvm@vger.kernel.org,
 Richard Henderson <richard.henderson@linaro.org>,
 Sunil Muthuswamy <sunilmut@microsoft.com>
References: <20250703105540.67664-1-philmd@linaro.org>
 <20250703105540.67664-46-philmd@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250703105540.67664-46-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/7/25 12:55, Philippe Mathieu-Daudé wrote:
> Currently whpx_enabled() is restricted to target-specific code.
> By defining CONFIG_WHPX_IS_POSSIBLE we allow its use anywhere.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> ---
>   include/system/whpx.h       | 27 ++++++++++++++-------------
>   accel/stubs/whpx-stub.c     | 12 ++++++++++++
>   target/i386/whpx/whpx-all.c |  5 -----
>   accel/stubs/meson.build     |  1 +
>   4 files changed, 27 insertions(+), 18 deletions(-)
>   create mode 100644 accel/stubs/whpx-stub.c
> 
> diff --git a/include/system/whpx.h b/include/system/whpx.h
> index 00ff409b682..00f6a3e5236 100644
> --- a/include/system/whpx.h
> +++ b/include/system/whpx.h
> @@ -16,19 +16,20 @@
>   #define QEMU_WHPX_H
>   
>   #ifdef COMPILING_PER_TARGET
> -
> -#ifdef CONFIG_WHPX
> -
> -int whpx_enabled(void);
> -bool whpx_apic_in_platform(void);
> -
> -#else /* CONFIG_WHPX */
> -
> -#define whpx_enabled() (0)
> -#define whpx_apic_in_platform() (0)
> -
> -#endif /* CONFIG_WHPX */
> -
> +# ifdef CONFIG_WHPX
> +#  define CONFIG_WHPX_IS_POSSIBLE
> +# endif /* !CONFIG_WHPX */
> +#else
> +# define CONFIG_WHPX_IS_POSSIBLE
>   #endif /* COMPILING_PER_TARGET */
>   
> +#ifdef CONFIG_WHPX_IS_POSSIBLE
> +extern bool whpx_allowed;
> +#define whpx_enabled() (whpx_allowed)
> +bool whpx_apic_in_platform(void);
> +#else /* !CONFIG_WHPX_IS_POSSIBLE */
> +#define whpx_enabled() 0
> +#define whpx_apic_in_platform() (0)
> +#endif /* !CONFIG_WHPX_IS_POSSIBLE */
> +
>   #endif /* QEMU_WHPX_H */
> diff --git a/accel/stubs/whpx-stub.c b/accel/stubs/whpx-stub.c
> new file mode 100644
> index 00000000000..c564c89fd0b
> --- /dev/null
> +++ b/accel/stubs/whpx-stub.c
> @@ -0,0 +1,12 @@
> +/*
> + * WHPX stubs for QEMU
> + *
> + *  Copyright (c) Linaro
> + *
> + * SPDX-License-Identifier: GPL-2.0-or-later
> + */
> +
> +#include "qemu/osdep.h"
> +#include "system/whpx.h"
> +
> +bool whpx_allowed;

Consider this missing hunk squashed:

-- >8 --
diff --git a/target/i386/whpx/whpx-all.c b/target/i386/whpx/whpx-all.c
index 1732d108105..faf56e19722 100644
--- a/target/i386/whpx/whpx-all.c
+++ b/target/i386/whpx/whpx-all.c
@@ -245 +245 @@ struct AccelCPUState {
-static bool whpx_allowed;
+bool whpx_allowed;
---

