Return-Path: <kvm+bounces-51489-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 086CEAF7609
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 15:46:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2A2327B9275
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 13:44:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E23F82E6D29;
	Thu,  3 Jul 2025 13:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hIqHQIm+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21B8012B17C
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 13:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751550349; cv=none; b=E+3riHcBhcDsmjMVP99htK1ZB9kh27w0UHzqRwMSfV8AK1cVc4Ps/C0zNsNOVkY+qKxKAB/gIzr4PZdwWRV7IygeJ0OIdnLW47Dpur03Wzs70u/ScN1UJAp6OJi3mxEGgaPoVhEnBd6a0Qdilegr0SjGKYphxLMDvUKIMMzlhL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751550349; c=relaxed/simple;
	bh=nREazmbwlDYG3j54zL79Ruv/R5rrYDgbd8ApPqgYqP8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tg6fhhg9hY0SSP7g4HdurZh+YL+YOfMMdYhErcirwonCtnSzQg9hoyl7eZfEnStju4iD15CIbWy7eEzUDvgJ0FRAQv9f3nzP7bGSHD05HZ+4z9AR8+k/19QKzqQesq2OttK+bmwPJGKEJPzOTnhT+dnuBCT45/2SzIIL+lJLRv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=hIqHQIm+; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4538bc1cffdso53520645e9.0
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 06:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751550345; x=1752155145; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bzgfIYKT0pu2euhC4Y01ktX+iPTZDzQ4TCdcNhT2AOU=;
        b=hIqHQIm+yQ0mXvSmUNyIlKCdH04yQNDs0mhjLyl9KyHOcalUFgACvkEQV461W6Sn+G
         EEU6rF1/3N3Zt3kz9m3VvlvmgQRMVNDLFnjbGdthrtXJa6zU/YeLogKcrW6NQ9jKtP8I
         NbwCC7BjQEhY8p1kt9OWDGSKm670icmXbrkrCquzHwSX765eDgmO0rPn9NslUXz8cfkC
         QszrCqNiTzUp+PdExskIUOKKaLrIAZ5h4In3vAFGsMhfMGqP0cCWOvT83WoQiFTOlEq5
         iHxVT9y0ngUYPwWNWcsq9RBxg3H8lgrAtIumcROzX/hVguvkKy9MNyY0H8qxr/REzDGh
         FvEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751550345; x=1752155145;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bzgfIYKT0pu2euhC4Y01ktX+iPTZDzQ4TCdcNhT2AOU=;
        b=YpvlgaT98PNIv0JKFGsUomccAWn6VGs5/NeQ+xvt8EhZjOjw26RlcyKF6bE3+YxFRU
         FyE/zFyI+zZC3n/4pE2wH3ffHTEF6Nk0m2D+aHpysabPnlJ4lCWJSuJeJaN5l/febn2y
         lWPA9r5wC4vMRKWpXCI7KGSJuy7eu5L/JqFt3T/u/YXlq5Pka9/dBHDq/BJ3tjxye+di
         bgS2hmVU08XTqfQZKFnpu1bw4SB4FWpNsHtf/jyVAMIhlYHM3vo+UhoPknskT3iji337
         eowEUg4cxKvyMtffzIjSvOIj1n4G1/9PgPGrMS28eDccNba3TcCi1ICK71/L4p3t2+BR
         m1Pg==
X-Forwarded-Encrypted: i=1; AJvYcCVxy9zQ3tCx+fHVNR0ZM2QZnULIHuSWca+Y1YSkl2wZy6LKSuSDBQbTxTRPAFcMRMKPdrc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6kT7bkzVZoJSBuahOEof+hslJlTtsDzOxycBXKnDluTBiIlyO
	Q3i0jx4p4qULYn3iVGNwtGYX6R0cKAHRJJfGN7tcFjkyS+zGqTdZWtrMIz6gAToGWvg=
X-Gm-Gg: ASbGncvKHXAvKf1jRWvNS6MngJ3S2MRMNvU8HOAurktj24X47gBhvEmm3IpF2RW+fHj
	B3tCSTPyAgzpZ3j0zELitsyEikYt9HGuXApUNIQ6kMlpYrpX2jqW4EwOzZX2foXAlIkntLYnQWs
	38y/MyQ+vr6NCJBC7L3mzQJ+Ahym5Mjyl6NkT/0uBmoZCHvpGU/neJSBGAWIBoru4zQc+z+OD0T
	C725HVtuYGsdAn4h3i2g5YwnLLm/3ej+nYawjSgbrIlX5ZVGFMs+WVk72EbmCn+CXOC+rRVKz2/
	1P9WdogVJw7z37v0YZf/nkKXQ6TDfQxv+YG+/9Qb7LWb4TzFslUffGZDjEqWWlcMpSo0o+JRZSO
	4QGpwAQiveTNu3wpk9CAJKQqAjMzA5Q==
X-Google-Smtp-Source: AGHT+IHIBfzPNtmnIof400Agn8RwX1HvW/bLZV3KILkNnKHgCIfoputch4xZsSGQwe362Ldh+mT2Sg==
X-Received: by 2002:a05:600c:8b10:b0:453:745:8534 with SMTP id 5b1f17b1804b1-454aa80da70mr34354995e9.12.1751550345370;
        Thu, 03 Jul 2025 06:45:45 -0700 (PDT)
Received: from [192.168.69.218] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a892e5f34csm18323235f8f.85.2025.07.03.06.45.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Jul 2025 06:45:44 -0700 (PDT)
Message-ID: <364dc354-ba78-47c6-ac65-2c0282e28733@linaro.org>
Date: Thu, 3 Jul 2025 15:45:43 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 47/69] target/arm: Use generic hwaccel_enabled() to
 check 'host' cpu type
To: qemu-devel@nongnu.org
Cc: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>, kvm@vger.kernel.org,
 Richard Henderson <richard.henderson@linaro.org>,
 Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org
References: <20250703105540.67664-1-philmd@linaro.org>
 <20250703105540.67664-48-philmd@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250703105540.67664-48-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/7/25 12:55, Philippe Mathieu-Daudé wrote:
> We should be able to use the 'host' CPU with any hardware accelerator.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> ---
>   target/arm/arm-qmp-cmds.c | 5 +++--
>   target/arm/cpu.c          | 5 +++--
>   2 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/target/arm/arm-qmp-cmds.c b/target/arm/arm-qmp-cmds.c
> index cefd2352638..ee5eb1bac9f 100644
> --- a/target/arm/arm-qmp-cmds.c
> +++ b/target/arm/arm-qmp-cmds.c
> @@ -30,6 +30,7 @@
>   #include "qapi/qapi-commands-misc-arm.h"
>   #include "qobject/qdict.h"
>   #include "qom/qom-qobject.h"
> +#include "system/hw_accel.h"
>   #include "cpu.h"
>   
>   static GICCapability *gic_cap_new(int version)
> @@ -116,8 +117,8 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
>           return NULL;
>       }
>   
> -    if (!kvm_enabled() && !strcmp(model->name, "host")) {
> -        error_setg(errp, "The CPU type '%s' requires KVM", model->name);
> +    if (!hwaccel_enabled() && !strcmp(model->name, "host")) {
> +        error_setg(errp, "The CPU type 'host' requires hardware accelerator");
>           return NULL;
>       }

Consider the following hunk squashed:

-- >8 --
diff --git a/tests/qtest/arm-cpu-features.c b/tests/qtest/arm-cpu-features.c
index eb8ddebffbf..bdd37cafecd 100644
--- a/tests/qtest/arm-cpu-features.c
+++ b/tests/qtest/arm-cpu-features.c
@@ -456,7 +456,8 @@ static void test_query_cpu_model_expansion(const 
void *data)
                   "ARM CPU type", NULL);
      assert_error(qts, "max", "Parameter 'model.props.not-a-prop' is 
unexpected",
                   "{ 'not-a-prop': false }");
-    assert_error(qts, "host", "The CPU type 'host' requires KVM", NULL);
+    assert_error(qts, "host",
+                 "The CPU type 'host' requires hardware accelerator", 
NULL);

      /* Test expected feature presence/absence for some cpu types */
      assert_has_feature_enabled(qts, "cortex-a15", "pmu");
---

