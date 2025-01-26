Return-Path: <kvm+bounces-36636-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F6B5A1CECB
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 22:35:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D3E463A496E
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 21:35:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D19F016FF37;
	Sun, 26 Jan 2025 21:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LacXhmIh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61D9B146A6F
	for <kvm@vger.kernel.org>; Sun, 26 Jan 2025 21:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737927335; cv=none; b=TjBBORGuKZibD2yxP1RIY/ka2LU8COcIesSO6cfseEcrJJtzVHkEOJ1eX3nzTe/ZplkyNkKkDRIRKCfTMkyhGKyfMXMm0zlHXZcdJjB70GlfvN8zx0JHADKjAnTGJ97JkkAImfJmIjYHJ6IHTw9UwGqIzCkTbz29MSuAPjDErj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737927335; c=relaxed/simple;
	bh=ek6xIKg/QmiL9JwQU2sJ1FZIzSbfG17yHxhqBOC6tFk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YqqQR7qA+KiKGMH2Mihcz5fJSUduGlMBWE7GgtGfOl6MsdBaUvvW9YelZOogmR7rNNBCKJ90km2sVFvaC/gaiin3nYshwNdnX93UltSZAR8oKJjw5JPRJQ22LE5Vt4D0uhyr5pJEH7Fbbsvg6SJ9ODrVEITa9k0/NRBnrZMI06s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=LacXhmIh; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2161eb94cceso44593925ad.2
        for <kvm@vger.kernel.org>; Sun, 26 Jan 2025 13:35:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737927332; x=1738532132; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u0m5yL8s0TWSEEfxviVLYoEbDIw5bajMGnLn0okjgqc=;
        b=LacXhmIhfSIKrHqItBl2P11E1zEb14IhuI4WwD5hCDJR/jXoFax+G7PldGRiusmeH2
         a1SueLlvTa2+SW1OtbAHzzlovuRMkjUBhHZJOmSHcZZgVuRIP05meRE7TFmiN2l8QUTk
         YxrluQrr8DBBSGdfDYNr79LCIF7ZWgD/gAmY/1IVoPA6zkXPYSqN5j8T9oN1vnnwJLpH
         ZkMg99//NzXfuWvJOquRXiEVFtuLvRT3rWceHDjtb4GG7JqxOH1DEdsSwPgKH6Yl/wHm
         /0ExlcFWijepfd5PCExfY6E4BBwAmokGKnktCLy2kpMKqUJZ6Q+4U2QxPiufQpZzza9K
         mKQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737927332; x=1738532132;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u0m5yL8s0TWSEEfxviVLYoEbDIw5bajMGnLn0okjgqc=;
        b=bthVH5VoslbvUB9rbc14fQx04O9ptKx8CThtgziY5cqkr+dvvtIjyTMzxb+fTAVxT0
         Bcru2apHHia5yMUzxGR1jSlov7hAfyciDs/qHWgpdy4/Gs+8LzxxxZPxrjGUQCTQetF8
         j/Bn559OpZGrIjsUrp1Bg7kJ7yXOLh9KVYtYBaa9btscxnIuPDHMRbo0IYe9cf4cwBMq
         oDnfqiHbvIzdf2cBVXGOtgqmUHao7wzBpm/eYAwh++J0QR2wc2wmutAnPhILMkCFXQxZ
         LDFgd+d7C1WPCyZwtDNe3FYStMqccXr4O9ZlIMRSyrNdkn3O/MGmuQrTe5OZT0YkAlbB
         2Jlw==
X-Forwarded-Encrypted: i=1; AJvYcCWgB2VLtjWAQyWWebeVafNss18HtYjoDlNfn496wJcKvE0TJR+f1T5oZdgQ0ISLwXy1HYA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwILOT8I7LhI+WSGwWfmg15PDX5fRBLRzHZtvQz+abYCzDAzimw
	k8h+Om1bBK/4d/q3FhaRAecDVUdTYqw1CoXomqC46w9N6gEWPRsxBbkHrp9eN28=
X-Gm-Gg: ASbGncv2oXTWfSSG+VourN4P1oajE8J3vwrRUya+9mah6ZB1gLlzLOr3wTyW3/4DVS9
	hNT5AcsIUlks6rssSbuD/kTCuKyqoQ0VA9a81qEpDqFOjbHvHP7xOGZDmMS/7kvrv2KI/2/vbFY
	j8QJgY86sKEPDTJKM8I2ndh12Mt9RC2uYq9FGI2vcgluFD3U33UrCb0iY2bqdq6O4rhTCh66Qy0
	VbEdqiMSxYTb3P8lqRkAmtk5zypcrskPpIGDOGRJA7tb8FCr106yEWneNJI8EHpPX/kIzYcV7kS
	T5l9QtdBKHoekRz0t4Ml0PH52bcZ3FFabwe8/KPUlxgRk3s=
X-Google-Smtp-Source: AGHT+IF/uxXXMxK7HfifMI4lK/bjNl3NXv2LfDusZSj5Oq6BRtJb3xCpVAH5ppeGMpTK7NLB5Z4iRQ==
X-Received: by 2002:a17:903:191:b0:216:3466:7414 with SMTP id d9443c01a7336-21c355f6a9cmr669165345ad.44.1737927327477;
        Sun, 26 Jan 2025 13:35:27 -0800 (PST)
Received: from [192.168.0.4] (174-21-71-127.tukw.qwest.net. [174.21.71.127])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21da3d9c552sm50455215ad.18.2025.01.26.13.35.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jan 2025 13:35:27 -0800 (PST)
Message-ID: <4de30644-618d-4914-a1c6-008992c7edff@linaro.org>
Date: Sun, 26 Jan 2025 13:35:25 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 19/20] cpus: Register VMState per user / system emulation
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 Igor Mammedov <imammedo@redhat.com>, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>, kvm@vger.kernel.org, qemu-ppc@nongnu.org,
 qemu-riscv@nongnu.org, David Hildenbrand <david@redhat.com>,
 qemu-s390x@nongnu.org, xen-devel@lists.xenproject.org
References: <20250123234415.59850-1-philmd@linaro.org>
 <20250123234415.59850-20-philmd@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250123234415.59850-20-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/23/25 15:44, Philippe Mathieu-Daudé wrote:
> Simplify cpu-target.c by extracting mixed vmstate code
> into the cpu_vmstate_register() / cpu_vmstate_unregister()
> helpers, implemented in cpu-user.c and cpu-system.c.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
> XXX: tlb_flush() temporary declared manually.
> 
> Only 2 more CONFIG_USER_ONLY to go.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

> --- a/hw/core/cpu-system.c
> +++ b/hw/core/cpu-system.c
> @@ -22,10 +22,21 @@
>   #include "qapi/error.h"
>   #include "exec/address-spaces.h"
>   #include "exec/memory.h"
> +#include "exec/tb-flush.h"
>   #include "exec/tswap.h"
>   #include "hw/qdev-core.h"
>   #include "hw/qdev-properties.h"
>   #include "hw/core/sysemu-cpu-ops.h"
> +#include "migration/vmstate.h"
> +#include "system/tcg.h"
> +
> +/*
> + * XXX this series plan is to be applied on top on my exec/cputlb rework series,
> + * then tlb_flush() won't be declared target-specific in exec-all.h.
> + * Meanwhile, declare locally.
> + * XXX
> + */
> +void tlb_flush(CPUState *cs);

Ack.


r~

