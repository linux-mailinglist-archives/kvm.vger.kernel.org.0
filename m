Return-Path: <kvm+bounces-51181-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A84A2AEF4DB
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 12:18:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6108A3B9B72
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 10:18:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E8FC26E6E4;
	Tue,  1 Jul 2025 10:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sshLCzYx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9822E201004
	for <kvm@vger.kernel.org>; Tue,  1 Jul 2025 10:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751365116; cv=none; b=EjCa3T4n9SgWvc53rCOYV0N9+1EOQFCcXaKb+GpBT/Iqs2t6qS8Qs2mVPOrC/nycan1qp+0F8Wpx8dSm13gN+evEjDOih2W+Pfwf401izPrchz5/5MZ8G6/0UkZHPuCJ69T8NaQ/PzcttODleCprUP8xHTfIW1ArX/FT81aUGpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751365116; c=relaxed/simple;
	bh=ht5ghszGIxOTraJxUFNbqoJJ4Lv/KatP8nCNAGSFdKc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mIEbLTDXDjZHg1h2h7gPwO2RFpvl1O+j1df954vWok+yorC2OVIE6bg0QCnsviMzd3F0+B+n24llJLGb0zhQOX+Zme1ntSVkkGXcVVkzkiS5iArlNCTz64D5wk6KOu9vgC5F2I9WTYLujhEtbK+r7ZXQK9iy5L3Vj1JJFjN0u/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=sshLCzYx; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-450cfb79177so32216565e9.0
        for <kvm@vger.kernel.org>; Tue, 01 Jul 2025 03:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751365113; x=1751969913; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LgnNOEMfhdY9VA8lAzP/UAe94NFoAHcMOH8/TPKyiSQ=;
        b=sshLCzYxCHf14TeLdnE2BivZQS59s+BstlREwidzv80179zYMDG0zlMYPBGcuIr+vh
         RfM5e9Nw1pAy2obCmCTkxyAdWOiKXjul6bK7yN0jNUOGnep9122rHzfDzhoVy6ZipSOt
         95xODUEQ05xBQTDY6YbXgW9hK56ztsNaa7DENUnw4ICW3cf3IJlr4wYcgI/zFlDYtQTn
         DXNCYUejnptb/Lmjr7YQOR2M5oAq858bXIkxg4ZG8/3x0nm5Qy2DRwNsN3IuLmEsSq2i
         1QXBcPbFo54CM41dxXuzEOZ4R3hV/0/L6QGj3Ogi4znZVDUFvXDVt1+YcNd+vWkjmInh
         YfCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751365113; x=1751969913;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LgnNOEMfhdY9VA8lAzP/UAe94NFoAHcMOH8/TPKyiSQ=;
        b=fPJO5j1RBm2T+MjQLe9Mg8Y/ilc/WJ2wydb1bsq+xZ+AbMJDU3tC0CoW0aAwqy2Gi/
         RLoNKK8oNNCNvo0ICGgWe1j2S9CwkFrHPPIUM6X+bp8mwq/Pv9Qwj9UivFfhYSiR6g3q
         6+8reB/YcCiIgh0Ax5IrpOjqiJZr29hnd+5dIjcd2JkIeCUUN3CqR7jLqiFEd0h0i7G8
         HqY3UN5S638+0+dh/JOCqRz3u2XPQsvVXwNPj9ky7AjyN3/aj0rFFKYDW5TJiPqfMAvg
         cPrOFwcCy+IkRTE0DE9pLFXBDzDEQnGLbs0Z46bg+lO/NV4OywD6wMiQ55GU6C+RmQYw
         oLuw==
X-Forwarded-Encrypted: i=1; AJvYcCVeC1rj79ShByy/bQ42sqVCuXktm2HIk4QMVWwBEXNVLEgSwQkPr8uH+GP1aon6PCvq2vY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9r0mNBa7dL/7/LIK99foDTOcZ+FpPkmKX1iLzAzJsX8nByAbi
	/dSL2loVCcXAV4XC6GlTRkJt3IwbOesuSHLx2GM7J6FZ7IGvpMdUk/F+rXtBLn4nuoo=
X-Gm-Gg: ASbGncuVaZtFHljEP/ohwDOgZr4qwc+hiTYXDiIy0+x4yjaQfc+hn7Iue7ZFeaZ1JXr
	T4cv/pIUQBOftAD5tEtahjlWTtBWSv3kQ5i6z2O5ZUcl8dSegR0700S4rnzqSXTFDp/fYpN7Prs
	t59lN/IlEGnn8mrTUfauzWOaRdFT/MgsKZ8zllxLxQgebNgcaIfNIAgSkYnMQ3EFfk/uTf4WY4w
	ysGyITAs99ttYlSwEoCu4pipEm0C9wKm3tS9jWr8yauVGK4Aa5giy0zHEINN3B2mEwYfB+mpvwC
	8rUILythZH8ae8v82WVetasKAprv7tYhIRy8pDp9IFja+Ggu59VTY6IA5mbAKHoCma8RE6WYYWM
	unevnfaDKp9U8ice/i0JYloCVyTmA2g==
X-Google-Smtp-Source: AGHT+IFb4W5g6wm6z7FzwAQ+UJUscW9Hb060Jxtit8cVodZVpioggdRu95VsxZAIY/qAELeUorDJxg==
X-Received: by 2002:a05:600c:4f06:b0:442:e9eb:1b48 with SMTP id 5b1f17b1804b1-4539002c9f6mr160576405e9.24.1751365112886;
        Tue, 01 Jul 2025 03:18:32 -0700 (PDT)
Received: from [192.168.69.166] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-453823c3c7csm190478975e9.36.2025.07.01.03.18.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Jul 2025 03:18:32 -0700 (PDT)
Message-ID: <8d09d6bc-0fb9-4717-866e-7b557a4de3a0@linaro.org>
Date: Tue, 1 Jul 2025 12:18:31 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/26] arm: Fixes and preparatory cleanups for
 split-accel
To: Peter Maydell <peter.maydell@linaro.org>
Cc: qemu-devel@nongnu.org, Leif Lindholm <leif.lindholm@oss.qualcomm.com>,
 qemu-arm@nongnu.org, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Roman Bolshakov <rbolshakov@ddn.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Alexander Graf <agraf@csgraf.de>,
 Bernhard Beschow <shentey@gmail.com>, John Snow <jsnow@redhat.com>,
 Thomas Huth <thuth@redhat.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 kvm@vger.kernel.org, Eric Auger <eric.auger@redhat.com>,
 Cameron Esfahani <dirty@apple.com>, Cleber Rosa <crosa@redhat.com>,
 Radoslaw Biernacki <rad@semihalf.com>,
 Phil Dennis-Jordan <phil@philjordan.eu>,
 Richard Henderson <richard.henderson@linaro.org>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
References: <20250623121845.7214-1-philmd@linaro.org>
 <CAFEAcA_hD_8XjMU+xdXM6ez-O8xmQtSddFLUA1j4JhstmJTFFQ@mail.gmail.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <CAFEAcA_hD_8XjMU+xdXM6ez-O8xmQtSddFLUA1j4JhstmJTFFQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/7/25 12:16, Peter Maydell wrote:

> Hi; I've applied these to target-arm.next:
> 
>> Philippe Mathieu-Daudé (26):
>>    target/arm: Remove arm_handle_psci_call() stub
>>    target/arm: Reduce arm_cpu_post_init() declaration scope
>>    target/arm: Unify gen_exception_internal()
>>    target/arm/hvf: Directly re-lock BQL after hv_vcpu_run()
>>    target/arm/hvf: Trace hv_vcpu_run() failures
>>    accel/hvf: Trace VM memory mapping
>>    target/arm/hvf: Log $pc in hvf_unknown_hvc() trace event
>>    target/arm: Correct KVM & HVF dtb_compatible value
>>    target/arm/hvf: Pass @target_el argument to hvf_raise_exception()
>>    target/arm: Restrict system register properties to system binary
>>    hw/arm/virt: Only require TCG || QTest to use TrustZone
>>    hw/arm/virt: Only require TCG || QTest to use virtualization extension
>>    hw/arm/virt: Rename cpu_post_init() -> post_cpus_gic_realized()
>>    hw/arm/sbsa-ref: Tidy up use of RAMLIMIT_GB definition
>>    tests/functional: Set sbsa-ref machine type in each test function
>>    tests/functional: Restrict nested Aarch64 Xen test to TCG
>>    tests/functional: Require TCG to run Aarch64 imx8mp-evk test
>>    tests/functional: Add hvf_available() helper
>>    tests/functional: Expand Aarch64 SMMU tests to run on HVF accelerator
> 
> Where I haven't picked up a patch it doesn't mean I'm
> rejecting it, just that I don't have time to think through
> the more complicated ones this week, and I wanted to at least
> take the easy patches to reduce the size of your patchset.

Thank you, appreciated!


