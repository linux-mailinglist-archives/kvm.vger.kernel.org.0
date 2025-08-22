Return-Path: <kvm+bounces-55485-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B079AB31011
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 09:16:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E20015E1E45
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 07:16:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B1292E764E;
	Fri, 22 Aug 2025 07:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="EKjQvUJD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8331D19539F
	for <kvm@vger.kernel.org>; Fri, 22 Aug 2025 07:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755846961; cv=none; b=GlQI3NT3Vjg4fOXA9fiwVnHq5gb/WSGqw33UOloLACyvfUYGVaQ73vSh/m7uoQy3K7Vlxs66q2ZdKiFkWMjG2dvQTopt3kA2TwDq3E2hzVvEfUzCogkzOaALKkY0NNTjAdqvnGrz6Rax2G3eLxPDVYYob3Jkqaa4QLW99+QkMUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755846961; c=relaxed/simple;
	bh=2FbrEiK45pg45ApumRSC7gxs3sgv553didlkxUUBer8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GPiYYHPVLyadX59Zrlpu4TEKR9a7dq0QejcMm28f2CDiAseEuukAqL6Pibktr2pprxiYjizP0m4jnbqYZWFlGAxBqVstj/yBl5dUSGVN/cYAdzOKf76Z2oZTZj5HxNQZNkQZKQ8WCcYhLad2MM0xIH8/rMrURKG/6LkmUXaT7Ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=EKjQvUJD; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-45a1b05a49cso13374845e9.1
        for <kvm@vger.kernel.org>; Fri, 22 Aug 2025 00:15:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1755846958; x=1756451758; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=d0zjTXNvMKZa3PrypLWbSgRjtAvE5yRX+kTuX5XJuVQ=;
        b=EKjQvUJDwYhacOQe5seC3ls3HDKW0arEihc57DjtcmsOt5mKvp3Qp14XaUe4erqOuJ
         CkIhitCemW8wSaq8fouVvV8ZcWzxDFfhbV54dnMFTa3NqQuki4lcYcVreTqWQSwZo7go
         /ipWE6X/C0eVlxpqCenRRwKMJF0VhsYrhIwSL4UWSdAryQaQZgcp+1229MwjwYKxE3R0
         WNtvwfSI6Je/kSykJHVLfk0vceFiGG2CI8swD8L/x16BTsNuntABlfjarbLDqzirx+7P
         VvTKM2VffT3x4tNVV9ptMyDYZef7hlx9UbUDVO2gcmNMV3nshdCiD3LGCb6B3YRr2qTs
         YTzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755846958; x=1756451758;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d0zjTXNvMKZa3PrypLWbSgRjtAvE5yRX+kTuX5XJuVQ=;
        b=KJGoLE5lXCf/ptSfFrrd/zXZ4hDf1zwDbaXMsiOWLcbF7jp+3psu1IGd7RRDGpFZv7
         b424osxBVjfABCTXqBsnEXkvhiABmbBp2+2qgp9GQJY9Or3HJNcooavbATgrJNN6YI7Y
         f0v9ECaUcNfpU+jfv4BuojTR47ZwBjeNnvITVUbDUxKRzd5u6W459wQGa/70cRGbunNY
         bqtPM9ZhN5V88AxtOQvueK7wsHySiUtkAnNk6AzgRNs21f3mECAJHWUNjotDDKPqhsMh
         ne3n9Nk6Gnjs5zovE0Qt/f4gkr7cuUFQr7qAchUFdFk9uTkZyzv3Atot5ktMsrG93mE/
         dsKQ==
X-Forwarded-Encrypted: i=1; AJvYcCVDxiuR8ZPbTZLjKdJEQcNX8khjyiZi1XISJI6ATIeG+peaIbFA0xN8R60zqjrG/udD1oc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyGyD+dYxjcd8sj3472hCr6aw66IBn9sUv9gOUhW+3y4ciFhxYF
	vmD1pnVQTuJ6WyPjeT6tXm56L/GWje8hek+VVg3SiYYee12YXc5zmBxlHFQiQGhFzttvCG1xHQZ
	eHefA
X-Gm-Gg: ASbGncsnThptq8c6CErjoIi6w/+QY+LjqB+RaLmIJJiOKjCd5L/Twj5OG1yxB6NYE0s
	SOEJzx9xRopHOIpgXRKga4F0YysvLWFDYp0ZYyyMeJA+6jPCkKZtTLD3Kd0Rn6eVFYsxqwO7VGw
	UK/ibNZnt0XqAx1vWfG5vHdMGRldNqxIq9xECpM+qITmcmu6hYLCAI1PgJGGZE8qNYpHP2Mc4zZ
	Bn+V7L7bUx72ZpPr259c8UcFNqGyBdzDXU8tWd80b7mnsY1y1RaakMppaH3XROjcvohMcilPujp
	Cu+CGOEAo9sp6TlXRJaB5r1UsOgzf7LsOKQyI2Jrmrh7zLBPr6EfQbWQ+/hZHotzrdMl5E9Jfg1
	ktrSZ836jzaw/H88qjzxcuCfR/fyPhr0q5hCYYYeAGnCoZ2o8p7p/djz+R+uNsKk1CUoUiDFkzS
	/vvLNJXA==
X-Google-Smtp-Source: AGHT+IFIOP3otK7owgq13qLvGMs4XwNpEe6T3NRgGNeHqeuHZPVXY6zwVczUzXfFCKKbVkFrXyetpg==
X-Received: by 2002:a05:6000:24c3:b0:3b2:fe46:9812 with SMTP id ffacd0b85a97d-3c5db0ef2c5mr1153045f8f.19.1755846957712;
        Fri, 22 Aug 2025 00:15:57 -0700 (PDT)
Received: from [192.168.69.208] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b50dde038sm25338875e9.10.2025.08.22.00.15.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Aug 2025 00:15:57 -0700 (PDT)
Message-ID: <01997d1f-178a-4113-873e-bf9ab7977e2f@linaro.org>
Date: Fri, 22 Aug 2025 09:15:55 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 10/11] kvm/arm: implement a basic hypercall handler
To: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 qemu-devel@nongnu.org
Cc: Cornelia Huck <cohuck@redhat.com>, qemu-arm@nongnu.org,
 Mark Burton <mburton@qti.qualcomm.com>, "Michael S. Tsirkin"
 <mst@redhat.com>, Alexander Graf <graf@amazon.com>, kvm@vger.kernel.org,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>
References: <20250617163351.2640572-1-alex.bennee@linaro.org>
 <20250617163351.2640572-11-alex.bennee@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250617163351.2640572-11-alex.bennee@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 17/6/25 18:33, Alex Bennée wrote:
> For now just deal with the basic version probe we see during startup.
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> ---
>   target/arm/kvm.c        | 44 +++++++++++++++++++++++++++++++++++++++++
>   target/arm/trace-events |  1 +
>   2 files changed, 45 insertions(+)


> +/*
> + * The guest is making a hypercall or firmware call. We can handle a
> + * limited number of them (e.g. PSCI) but we can't emulate a true
> + * firmware. This is an abbreviated version of
> + * kvm_smccc_call_handler() in the kernel and the TCG only arm_handle_psci_call().
> + *
> + * In the SplitAccel case we would be transitioning to execute EL2+
> + * under TCG.
> + */
> +static int kvm_arm_handle_hypercall(ARMCPU *cpu,
> +                                    int esr_ec)
> +{
> +    CPUARMState *env = &cpu->env;
> +    int32_t ret = 0;
> +
> +    trace_kvm_hypercall(esr_ec, env->xregs[0]);
> +

Should we make arm_is_psci_call() generic to be able to use it here?

> +    switch (env->xregs[0]) {
> +    case QEMU_PSCI_0_2_FN_PSCI_VERSION:
> +        ret = QEMU_PSCI_VERSION_1_1;
> +        break;
> +    case QEMU_PSCI_0_2_FN_MIGRATE_INFO_TYPE:
> +        ret = QEMU_PSCI_0_2_RET_TOS_MIGRATION_NOT_REQUIRED; /* No trusted OS */
> +        break;
> +    case QEMU_PSCI_1_0_FN_PSCI_FEATURES:
> +        ret = QEMU_PSCI_RET_NOT_SUPPORTED;
> +        break;
> +    default:
> +        qemu_log_mask(LOG_UNIMP, "%s: unhandled hypercall %"PRIx64"\n",
> +                      __func__, env->xregs[0]);
> +        return -1;
> +    }
> +
> +    env->xregs[0] = ret;
> +    return 0;
> +}


