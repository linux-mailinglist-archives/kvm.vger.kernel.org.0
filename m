Return-Path: <kvm+bounces-36637-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 300EAA1CECF
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 22:37:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6CB991886403
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 21:37:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FD3817C20F;
	Sun, 26 Jan 2025 21:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YvSqbRtd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF195672
	for <kvm@vger.kernel.org>; Sun, 26 Jan 2025 21:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737927449; cv=none; b=kchoTygzsBknDZtfX7MuDUhf2jk6SPyTgNYUzunXRN2gfow5TuHwMAUV4gHn/JhNaSw30ResEluDNCTvgDaXpAcpdGo4xGuQ81bv4Ub7qbI8tbQ75RGqKdcJBMrQB3d864Z45J+I1pNut2oxYrXfqbnGYhqhw2WKX2ec3HXM/j4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737927449; c=relaxed/simple;
	bh=celf/P4+3hYsVhp1iEuA0bTy8bjHL6rcLVmiKLQ3kjk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mLgWrsN2NlafRaUvCnWDFhIrspHVD27TkVyFpCqgR2J8KPCSOJv/CUXXulwY8Zv2s0erFUda6k9U8O9ehxYeIiW665MgBOLNtX7sNjZ2/PqpTIr+mKE2qm4xyF5yk/hEuGHr2Sy1insekVNBvtOrDGwlfxndrCbOF86JFjK5VMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=YvSqbRtd; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2ee46851b5eso4989869a91.1
        for <kvm@vger.kernel.org>; Sun, 26 Jan 2025 13:37:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737927447; x=1738532247; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MbN5ftkFW90qPVFMQN7kThRB1jW5R9e9lwVcXv22rrA=;
        b=YvSqbRtd4bMU55zFKJCIB4ws+hgEPxG0j8oFdW1IqjGYo9NFzO8W7uEOKLZDnGn9te
         Fgb7bUdvgXTYe4hRJ1VkJ/FyNtCgCT78maSDzLrXsmpJoefUN4IdGAaixsj+Wjs6Nua1
         4rQPDGo9qI55BCDxdCRlLnltH2+2qEd/xOnGrKq7HhWoyp6mGDfCBxJWkqrTQrioO0GT
         uC1A1dAQn0nC+1SuYEPWEKfc7Vv3l7OxsS6N5K0mB1NdoT87GzZGupTOwmgUXBH4sgiY
         PofpflYZ1m4G+FY4syjJ+lxF/NMLcDRtT5CeYQT9RjCoFVuSsyBJt/zAlrAgdN0U8baV
         MEpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737927447; x=1738532247;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MbN5ftkFW90qPVFMQN7kThRB1jW5R9e9lwVcXv22rrA=;
        b=Ui5rKOwWJIzdpBpHMqd1aDGoOFYPlrHohYEcvWDjZAaRmep6RVA0p0k2UJwiZSK6mk
         nrNzxpbled557DTLrOdJ32cLOKlaQUGEtWf5Sd1zpROitU1Xf+a7uMOX1XblvlWAQnyk
         LPHFYcR7cbxQpFsgD8V398N8RCvnr0F1WjnGWAd9tAADEJkjOkBbpo259Ly9+/APo/Dk
         UWZxsmOOPUm78FSGtB6/MohlSixKnl6gcA+8+eAzd1dD38AqcftAajvmyEt4QuSCypfU
         OY6Ih+YkHOIU7q5uqPxX/7/RIhZBpPNpVkOZBTd2Ckyfa+AWhMz4ioK8uP25Bmfb6PBm
         sOdQ==
X-Forwarded-Encrypted: i=1; AJvYcCX6z9yC/K0qTHQEfLLoPYdZKsPOqQ6wvFon/SvV1eRs2inC/qC9XTK+4MpfLp2EhGIBthU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxWyD+vbhwEO3NPqQUzeqeBzl2cjE825hSrcQYWMT0u76wxisct
	JZwbhzVT2PSaJGwwtSFWmGZAS/ci1zvDqeHpV63QMC+YwCMDcgtygeDoBmnCjEA=
X-Gm-Gg: ASbGncuVDYK49Vgccjw7I+Y0yB52NowAB3rtBwOzAL3Fz6+bvnS7+USHRKgRkjFam62
	lXpMDaP3mLlUSIVOGa547BmCyqEYNDe4u7kq0kBAmj3GzxF0QDlF1jeDox34MQstohYi4sG1+6H
	magZfL+jWAnNvgwc44PTO0+LoE8c//lfngQZZ1ez5oawWVswy9dCUdQkNk/eBjWUBzgvo9SOFyx
	K+KnatxynirqnNTuhU8iPy/9eBHX+3yMt3C0oCgSWCpC7a7xIa2V3cYNQT9l8ne6zOfMW25PCV2
	ijN2+qiO337xrA/5i0AOAHAbBb/WsbTmeKMVawB7TsXhZJk=
X-Google-Smtp-Source: AGHT+IFiuSNxM6E2NLFZz0UKT8aL9HnJkIEUZ+PxBPmebPJCN8+PDu1ajnV9q5XziLSw+N+w1RiQzQ==
X-Received: by 2002:a17:90a:c888:b0:2ee:f687:6ad5 with SMTP id 98e67ed59e1d1-2f782c5174emr59291165a91.2.1737927447421;
        Sun, 26 Jan 2025 13:37:27 -0800 (PST)
Received: from [192.168.0.4] (174-21-71-127.tukw.qwest.net. [174.21.71.127])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f7ffaf896csm5651556a91.34.2025.01.26.13.37.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jan 2025 13:37:26 -0800 (PST)
Message-ID: <46ab28c5-d417-4b83-97d2-b2ba49f7abfa@linaro.org>
Date: Sun, 26 Jan 2025 13:37:24 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 20/20] cpus: Build cpu_exec_[un]realizefn() methods once
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 Igor Mammedov <imammedo@redhat.com>, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>, kvm@vger.kernel.org, qemu-ppc@nongnu.org,
 qemu-riscv@nongnu.org, David Hildenbrand <david@redhat.com>,
 qemu-s390x@nongnu.org, xen-devel@lists.xenproject.org
References: <20250123234415.59850-1-philmd@linaro.org>
 <20250123234415.59850-21-philmd@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250123234415.59850-21-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/23/25 15:44, Philippe Mathieu-Daudé wrote:
> Now that cpu_exec_realizefn() and cpu_exec_unrealizefn()
> methods don't use any target specific definition anymore,
> we can move them to cpu-common.c to be able to build them
> once.
> 
> Signed-off-by: Philippe Mathieu-Daudé<philmd@linaro.org>
> ---
> Eventually they'll be absorbed within cpu_common_[un]realizefn().
> ---
>   cpu-target.c         | 30 ------------------------------
>   hw/core/cpu-common.c | 26 ++++++++++++++++++++++++++
>   2 files changed, 26 insertions(+), 30 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

