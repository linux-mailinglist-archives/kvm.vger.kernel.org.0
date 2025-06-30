Return-Path: <kvm+bounces-51087-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C8C9AEDA05
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 12:39:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4B50D165430
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 10:39:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A3242512E6;
	Mon, 30 Jun 2025 10:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ntrS/M2i"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A66224EA8F
	for <kvm@vger.kernel.org>; Mon, 30 Jun 2025 10:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751279953; cv=none; b=I/zUzYjTrDkAJ8xnocF/JZRMJ5Z8N4Lg6rJ9o4QvSxcciN5dIQIeuEBoGHp+5mrX25bx2xXE/l9AeqCX/HTPjI7PqJkVM4Ihxh7UMAa4k+TTfp05BvbSdsFJ3aJBAUsqb0n34Dik/TU6mf5vxSAv698XRDEJt/bGMWzr/yRkn1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751279953; c=relaxed/simple;
	bh=tuKrmnZg0YTKUZDpbskzPrUk1D8/CsQH1+adOwRQ9eU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TSq6gFTdb8M2TDH/j/yLAILbNdQLIPs4oTbK0NwqFvVu1wVkA+crAcJi/qEs4UWJelwVSnQGRAKUuNDfxBTXu7pKas2vf4NP4CE85GFkGvxHg7cscsZDbKQApEjDEf9Ye8gLoVt//Ay/OS6tA+uff84gfl0LAehFDV/+c82z1vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ntrS/M2i; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-453398e90e9so14735535e9.1
        for <kvm@vger.kernel.org>; Mon, 30 Jun 2025 03:39:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751279950; x=1751884750; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aY2ljNQQ7s+olZYdhb6NcXGhl/GbIzPd8ZgET/oFbLk=;
        b=ntrS/M2ihu4iglEK0gMnH+YyIVSQVBd31+rgYO1wZkYV03Z7tCFhiuJSo0vIJ4vu/k
         eh1HDAsFChmd6a5WqIQ1LLkSumxxwGM0PBbNi3N5MDohLMEZsXQuxPys8XEQth7QSY7T
         Th7QEdSGMK8299smgQSigecMncYX4HN5d/eAH5RkGuFhMYGEsQwEUj7VG/2NVN90VogR
         sGHdqq6LILPCCb/vCHa97D8f6x8vKlpAr9GXymt1LSJsWJPN+4CuTSAu8RyWo1EfkEfl
         k4HQWyGxjrrZRknngjRNS7OER143nNCphxGli8ENniL4A7/QYb1DZHDoFH3W8X3tT2s6
         BNYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751279950; x=1751884750;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aY2ljNQQ7s+olZYdhb6NcXGhl/GbIzPd8ZgET/oFbLk=;
        b=Ss9gPPmUjM+4e4rUgCUjsvTlIz5IYf2JzLogdPB6+IG/xk37QsLKpj6/y/S141abBl
         KUMN6RkWw14ZVes+C1Kc8KHhmCeS3L0ERGw943CeAlemg32qXJX9fMbvsStZO5TQhrJw
         k4ttW4e+VU9EwC57ufnBJWkZUujWwUuocyIMCl7HOUGvMD60++IAZR23rs+7XvRZAygO
         htDFvwrbDN83m/7v9z8PGf/458t3CX1UWxEfCE9DzSx2XCJSjdYsSzooWKzXpWazjj4/
         zTB8Stb7CD5Gh53PgqnmtkAeTZq6IoKEJl7kK1UhstYcREDU4i04Bn03FDKNXmJfN1Ta
         T7Sg==
X-Forwarded-Encrypted: i=1; AJvYcCXChEA2VdstTli5TZdmZLMrlGq+dDE2fYZ77aBcndtcIhCWqV/qOOVLvjFiMlpottjN9bE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzqMZs6Q2taKfT8eSVD1PaJ/cdlrgJqjIxr5USTVyU5NcHaaB3P
	8kP+SGrNG0RM1J+RAEF59sAu7L2hVZfqkd32+U8CIH52O0cXGxFgc+8SotCYV6ADlr8=
X-Gm-Gg: ASbGncsA8JPLmtEXNNwh0Zf+6FdBbrlve6uyYPqH9OS2jEegHLVCEpioSkEkYrA30Fv
	zsixlN29LqydhyvKgamqgl/y4AcTLff5zhziVjFoSUmzKan/fGgsHVLcVJM4vtAnY+fFol4kVtz
	txQBIgqsHrbUWK+RtZ/Voi01BGqKQNLsTBkg4cBKlga0by2tbMans0oi4PebtIx2k7YdORZwQZy
	gVmZ48DCwWBX/hWQZhiHI37eeiD4rI7fL8sQ+KLn91s92cO8Px/3WxjxAkjOaSIngXICyXHzhS6
	dMt/3tKbRzEoyzq6FFxQks+2SCXiDo9TVysUcULw9fimPI917B1AAszIYDaxP2zP6/i/vj+af+s
	RECNHwf+0j1fl2/eQLhK9fpU9mN4yqA==
X-Google-Smtp-Source: AGHT+IFNhBcdHyj20tEsizIFcK97MLoriVP6w1Dr62XMrnK4u6j3KiXisn9MgQ0GTm/kkt4YtpK0UA==
X-Received: by 2002:a05:600c:138b:b0:450:d4a6:79ad with SMTP id 5b1f17b1804b1-4538ee6e564mr117965735e9.23.1751279949555;
        Mon, 30 Jun 2025 03:39:09 -0700 (PDT)
Received: from [192.168.69.218] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a892e59628sm9858422f8f.81.2025.06.30.03.39.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jun 2025 03:39:08 -0700 (PDT)
Message-ID: <14f8aa18-1aab-4e40-9ee4-987793f08a33@linaro.org>
Date: Mon, 30 Jun 2025 12:39:06 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/26] arm: Fixes and preparatory cleanups for
 split-accel
To: qemu-devel@nongnu.org
Cc: Leif Lindholm <leif.lindholm@oss.qualcomm.com>, qemu-arm@nongnu.org,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Roman Bolshakov <rbolshakov@ddn.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Alexander Graf <agraf@csgraf.de>, Bernhard Beschow <shentey@gmail.com>,
 John Snow <jsnow@redhat.com>, Thomas Huth <thuth@redhat.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 kvm@vger.kernel.org, Eric Auger <eric.auger@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>, Cameron Esfahani
 <dirty@apple.com>, Cleber Rosa <crosa@redhat.com>,
 Radoslaw Biernacki <rad@semihalf.com>,
 Phil Dennis-Jordan <phil@philjordan.eu>,
 Richard Henderson <richard.henderson@linaro.org>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
References: <20250623121845.7214-1-philmd@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250623121845.7214-1-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Ping? (series fully reviewed)

On 23/6/25 14:18, Philippe Mathieu-Daudé wrote:

> Philippe Mathieu-Daudé (26):
>    target/arm: Remove arm_handle_psci_call() stub
>    target/arm: Reduce arm_cpu_post_init() declaration scope
>    target/arm: Unify gen_exception_internal()
>    target/arm/hvf: Simplify GIC hvf_arch_init_vcpu()
>    target/arm/hvf: Directly re-lock BQL after hv_vcpu_run()
>    target/arm/hvf: Trace hv_vcpu_run() failures
>    accel/hvf: Trace VM memory mapping
>    target/arm/hvf: Log $pc in hvf_unknown_hvc() trace event
>    target/arm: Correct KVM & HVF dtb_compatible value
>    accel/hvf: Model PhysTimer register
>    target/arm/hvf: Pass @target_el argument to hvf_raise_exception()
>    target/arm: Restrict system register properties to system binary
>    target/arm: Create GTimers *after* features finalized / accel realized
>    accel: Keep reference to AccelOpsClass in AccelClass
>    accel: Introduce AccelOpsClass::cpu_target_realize() hook
>    accel/hvf: Add hvf_arch_cpu_realize() stubs
>    target/arm/hvf: Really set Generic Timer counter frequency
>    hw/arm/virt: Only require TCG || QTest to use TrustZone
>    hw/arm/virt: Only require TCG || QTest to use virtualization extension
>    hw/arm/virt: Rename cpu_post_init() -> post_cpus_gic_realized()
>    hw/arm/sbsa-ref: Tidy up use of RAMLIMIT_GB definition
>    tests/functional: Set sbsa-ref machine type in each test function
>    tests/functional: Restrict nested Aarch64 Xen test to TCG
>    tests/functional: Require TCG to run Aarch64 imx8mp-evk test
>    tests/functional: Add hvf_available() helper
>    tests/functional: Expand Aarch64 SMMU tests to run on HVF accelerator

