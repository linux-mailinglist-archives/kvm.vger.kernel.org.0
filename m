Return-Path: <kvm+bounces-41455-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A9493A67FA4
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 23:20:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CE27019C7042
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 22:20:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FDF3202971;
	Tue, 18 Mar 2025 22:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tqSpIyRR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F6ADDC5
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 22:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742336389; cv=none; b=Hd3wTebx1bINpwJEB73PBY1gcsOiITnV7MiSRSYoICfKEw5WE/RZDy1sFFIOGmEA3JUJZhwiLiGEBp3vcGhKtAOXawpHgNOZuBcMjg3BqXAb1e7CajVeQfCra+0xRNeGRpGhp4T7iq+wSPMMY9rzzthdvtieOcIX2+OzO16NknQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742336389; c=relaxed/simple;
	bh=ZrWK6UbSGG/VakvYF3MMBArOrBiVPNYP8p7Ws4YeDIY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jy9L1P/ixgqeD2vsXRb8N+nafAJ0/B9TOHPoJTRK4Sjv3w7TBt6ALtwK+B/nF3gYXPhxLjRN9Svmp6r2sphcbA7dzC8uC2RbBh35CVlXa8za1uMZk/EdlIJhLMIB31AGq5lDwqhTRW4NupyMYzK50qAlY+Xot1ue1E2Pntj+hn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=tqSpIyRR; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-224019ad9edso5347515ad.1
        for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 15:19:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742336387; x=1742941187; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VTGGUtCqvaeyCv5ha1EwY7WPOyRwsuePzUbQ67x00IU=;
        b=tqSpIyRRVFhU6WE/P2edj+F4fNGOUqM7nVgsyJ7s0QXQ0MgOufEtfhGxoHAYMmoy62
         ybu/5sbNno5g99CYaZkc9HomGoMsUKUnKfXJ4xlYc6ucIPCz/cHcsHcoewtS+hfNlnom
         2nI9YyUsstMR4+GaE4POqmU/K2ftuXGawzU1Ro6s6MYCtTD2JsJb00NKcL06su0cId9J
         4vveo6vHQZm519sI8zlnJkrizOpfBAdTqYCHAbnl7bz+eGGN+Z9crb4H8GYRG4JsMihw
         vflNWLbF6L/9F2tOfIDwWKJ0BKV04Kf/R/pdkf9/4PGM98GUksQ1nFaxbC688V/JJCoK
         /xZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742336387; x=1742941187;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VTGGUtCqvaeyCv5ha1EwY7WPOyRwsuePzUbQ67x00IU=;
        b=ktWi3qdmQqQBIQsMsnyhjy7UkFR9enxqDYxqNs8PBDLE+ZiEyjYAxF2MQBotTXACVD
         jaE4t1ScSSIdLNUEJvDX3zTik76CZc/c+mApbL1PqbqWNx6qtP/+VU+mRU5xLQ7UIs9c
         Uj6iIB6dsdFYgKF5fPaAlBx6QO5UJ7+otgmx9IVx4GVlwA6wgi5HacwJK5MOTEa7zX5R
         5hzzWKqgyqR6LBLGubFNlxAbJHsQJkU7zNxiyHVr2RkE0B/KsEfdZ/Ip5BLeqFoCw7tb
         YRdFK6oqbyZiDQqDViGT9K02Acm4lDIttCV3K5yRI9oSXFUo+MLtSrSUggHIlDKSky11
         crBA==
X-Forwarded-Encrypted: i=1; AJvYcCW++J2nTlz4x+HfKibCHUeSUkMjnlabIoOZT+TyJWJcMe71PA5vmEH3liTj02p6nYlf5ps=@vger.kernel.org
X-Gm-Message-State: AOJu0YxmQdxx3Wv87FA3a9XVPQ8YYE4Uc0hJY77QWNQeyPBCiwemqpCD
	bsL3IoWeYxDl5SGatqJtvF4hFz3JX1o394+n/Z8NXvzSKdpLO8ZlAcobtXUnxIY=
X-Gm-Gg: ASbGncvVUXCc7wSMl9/ikub7H5TIE3UsjEbAEFogqJq9NVXfG6GrMm7gD0sHcQcF8zP
	4RcQYc/takH6MEWSGTb/3hT1ZM+zDOt51vbsekl/Tn6TsirX68Mh72t9az7goWv40sTueCYNzGQ
	MzSLyVb8qCoPt0NT2zRhLg6aqpM+YxUheyimBn+EG6x70Tor+7w7dYj5ZEXz/sCSXXEGSzC9GRu
	4L9Z6d9fY7VtvU1GI/0jloDKwwPrULOt12KNfEJ+D8BQUk/zWHhafakxvP7LKQtO2KBmtN62/m7
	GQ+P51tQkm/n8CHYsjqGqAZveFWLQ8a+rGvJFWUjG3ZHO5RjVCXlr6+vbt9880uIEP9OL0oFy5W
	NF0hkdhNN
X-Google-Smtp-Source: AGHT+IG3WL2UZjLRcBSxDIrHyiZ799+Zj+pvjdJn5gm7VGBFlAyVOVO0vmRFXWt9lA78bwybkCPvEw==
X-Received: by 2002:a05:6a21:168b:b0:1f5:9cb2:28a2 with SMTP id adf61e73a8af0-1fbebc846e5mr518960637.19.1742336387525;
        Tue, 18 Mar 2025 15:19:47 -0700 (PDT)
Received: from [192.168.0.4] (174-21-74-48.tukw.qwest.net. [174.21.74.48])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af56e9ca494sm8061555a12.5.2025.03.18.15.19.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Mar 2025 15:19:47 -0700 (PDT)
Message-ID: <f1ce73a6-717b-4230-95cd-45505fecf039@linaro.org>
Date: Tue, 18 Mar 2025 15:19:45 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/13] target/arm/cpu: move KVM_HAVE_MCE_INJECTION to
 kvm-all.c file directly
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 qemu-arm@nongnu.org, alex.bennee@linaro.org,
 Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
References: <20250318045125.759259-1-pierrick.bouvier@linaro.org>
 <20250318045125.759259-6-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250318045125.759259-6-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/17/25 21:51, Pierrick Bouvier wrote:
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index f89568bfa39..28de3990699 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -13,6 +13,10 @@
>    *
>    */
>   
> +#ifdef TARGET_AARCH64
> +#define KVM_HAVE_MCE_INJECTION 1
> +#endif
> +
>   #include "qemu/osdep.h"
>   #include <sys/ioctl.h>
>   #include <poll.h>

I think this define should go after all #includes, emphasizing that it only affects this file.

I think the #ifdef should use __aarch64__.  KVM is explicitly only for the host, so 
TARGET_AARCH64 really means the host is also AArch64.

I think you should go ahead and adjust x86_64 either with the same patch or immediately 
afterward.  There are only two users after all.


r~

