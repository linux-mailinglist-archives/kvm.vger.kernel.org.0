Return-Path: <kvm+bounces-55484-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F12A1B3100A
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 09:14:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 21F926836BB
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 07:12:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E75402E2F17;
	Fri, 22 Aug 2025 07:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pj4f5rU5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17FE4393DE4
	for <kvm@vger.kernel.org>; Fri, 22 Aug 2025 07:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755846758; cv=none; b=D0VYw73xZVT+G4f6SqeFQ94Fdro0Md6xptl0MYUf/mgTVluzfF1r4Z+2sY4xG/NjMjnISI+3OKIyZh+IsYgNH3Vd7agfzfKMdfrzCHJcGy7j2csh7t6NZlRWSToiExwFr9Vv4/SPXhDTknaTMjUQuzRmQu4z4wN/FowszbcmhM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755846758; c=relaxed/simple;
	bh=8MMiUnQsfAIsdyBr34+hV3l81kdZ9Gzd7ahMijFr8nA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZyYqf9dS3R1XqA/eqCBShPR7+23f7ixoukQAFGXExMS+3ExlBw5BYxNhbHa09brEV/9G+zmyGexTB76+I0vkMsob2z5CrVKKa7BRLknL9FCyUpaS6UJpKswNP0nbwr9K2jNUNE//r36NZBb/SiAzhV6umMGkLfph1LS6NW8klKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=pj4f5rU5; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-45a15fd04d9so18968075e9.1
        for <kvm@vger.kernel.org>; Fri, 22 Aug 2025 00:12:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1755846754; x=1756451554; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gq5QaCBH3PfELDbEFJWuDYYvIi201XrAw2c4ht2gWNQ=;
        b=pj4f5rU5K2he3739nZakNJm1cywSLEZRPF9CkUDc/3yTqeoA4mxjmeF5uthSTyjsXJ
         MIZrsWR3MWb//buu9gSJjbNTQgv0gCBmPC8bZi9i1tT4h/xrryp48IPVjlDoAsu+LzE0
         yQtDYfJ/i2HoPh+MUROhMvsPL8/oejCChs0UgfkTOfVY5NZTp0bY8ecn6WonGYVLIk5W
         PT3ngx1XFHTa5dD1FzMZdtIEGWUDeBOXLUN2Am6KPg6RDvilNv9r4tUtQzO6NiBBCH/D
         H4AVUuweS2QIA5vEPW05aUsPDob/J/bTMFdE01yzy7vot/oRC7KXnAHS6B9E2V4fQYwZ
         0o6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755846754; x=1756451554;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gq5QaCBH3PfELDbEFJWuDYYvIi201XrAw2c4ht2gWNQ=;
        b=jPYYV1FpSjlduNwQTVwOTD4fNho4yCHSfY70+QL+CmR2rLcKJ86psThKMDJtsDH1hb
         IAY5vLIlc/O9gZKIwnoIu1bQSpoiEktA+OzJVqB9bOcXX2dqvtNIyIZzpeSYzbnzy1J9
         kf+xYRVkPprSLIqXklhvHNgUesNTZ2jQCk281pa0P54f4qoSoywYew9qt/PIxAky0TZ4
         1l9EPwq1IfS3sf3htsZgdyM8U23XB8lehHZx92c9MYtdyyvfFP+FST+gOGpACl8OTZ8N
         yTTNzwL8z6RViAtQ1WhTnSYSN7KhjqSmcOswWlPQgmWbEfQB0yBeZMXkthnrAwzHSiiT
         p+cA==
X-Forwarded-Encrypted: i=1; AJvYcCVS9GLRCTBafm1fqli/L0fLBDkuD14+rVOw5gYXi1hQdOmg6Iw45OdWXrGlUr1iNxpiFOI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8hUYAkFwDbvhG00PV/PDTXArLyNpHj+hgWL3YoEkZnyzqkPiD
	W0d2FuQ0b3JWwcRWbpS+5ewoEj/siyfT63Gfily73p4lumTCm7eqbzlTlkbWlaNPnAQ=
X-Gm-Gg: ASbGncslwDKIdGD9Io8gDQmWhOxs4LV3pauwO8Fa30Jct+R36FTDv5GsJ2fHMze88B0
	6elFUo204KHf9fVyoZwyj+g5qd9Qm9024EkBCvzJr15WzQAGLLR4Wn2vo6dK5xudIwE6pKEHXRQ
	jWNY3hV6FnMl13LnUXD7USCqd0FIK7lzUEJKt4piGN/n1naPyczfZcGlEv60YQ9srf8PsQGZdkr
	4mW29HW5mzOWgDSfs7XF5ir2aexVeC1Gm6CcuQvCdIeOSR9m5LNwKpIsrzUn2+tltj6Yhx1Eokm
	u11/DvbY2OpUkChfxTzwomX901XD2EI6gUCq6si+jdkOlq2Cwr4HmSNbSvVv5lpkZGIShgnm5d1
	1kW2GxFraww6dJLPnmsbAxfSA0NKkPD3fc98l68MNnFCj/lvKXdZQ7j/sqA5n4i71+gkMWnw=
X-Google-Smtp-Source: AGHT+IGVzjuhpaG5yMsdrzuR+WXPPp7DLAK+ZnK6fOJf7EKeoavE+Pjmc0KY0Q0GNJZxIvzLBzIwBQ==
X-Received: by 2002:a05:600c:45d4:b0:45b:47e1:ef7b with SMTP id 5b1f17b1804b1-45b5179e933mr15306545e9.17.1755846754346;
        Fri, 22 Aug 2025 00:12:34 -0700 (PDT)
Received: from [192.168.69.208] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b4e8ae6aasm26713045e9.5.2025.08.22.00.12.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Aug 2025 00:12:33 -0700 (PDT)
Message-ID: <19837997-57c3-47b7-ab25-f8bad6bd3d4f@linaro.org>
Date: Fri, 22 Aug 2025 09:12:31 +0200
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
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, Pierrick Bouvier <pierrick.bouvier@linaro.org>
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
> 
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index 0a852af126..1280e2c1e8 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -1507,6 +1507,43 @@ static int kvm_arm_handle_sysreg_trap(ARMCPU *cpu,
>       return -1;
>   }
>   
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
> +
>   /**
>    * kvm_arm_handle_hard_trap:
>    * @cpu: ARMCPU
> @@ -1538,6 +1575,13 @@ static int kvm_arm_handle_hard_trap(ARMCPU *cpu,
>       switch (esr_ec) {
>       case EC_SYSTEMREGISTERTRAP:
>           return kvm_arm_handle_sysreg_trap(cpu, esr_iss, elr);
> +    case EC_AA32_SVC:
> +    case EC_AA32_HVC:
> +    case EC_AA32_SMC:
> +    case EC_AA64_SVC:
> +    case EC_AA64_HVC:
> +    case EC_AA64_SMC:

Should we increment $pc for SVC/SMC?
The instruction operation pseudocode [*] is:

   preferred_exception_return = ThisInstrAddr(64);

[*] 
https://developer.arm.com/documentation/ddi0602/2022-06/Shared-Pseudocode/AArch64-Exceptions?lang=en

> +        return kvm_arm_handle_hypercall(cpu, esr_ec);
>       default:
>           qemu_log_mask(LOG_UNIMP, "%s: unhandled EC: %x/%x/%x/%d\n",
>                   __func__, esr_ec, esr_iss, esr_iss2, esr_il);
> diff --git a/target/arm/trace-events b/target/arm/trace-events
> index 69bb4d370d..10cdba92a3 100644
> --- a/target/arm/trace-events
> +++ b/target/arm/trace-events
> @@ -15,3 +15,4 @@ arm_gt_update_irq(int timer, int irqstate) "gt_update_irq: timer %d irqstate %d"
>   kvm_arm_fixup_msi_route(uint64_t iova, uint64_t gpa) "MSI iova = 0x%"PRIx64" is translated into 0x%"PRIx64
>   kvm_sysreg_read(const char *name, uint64_t val) "%s => 0x%" PRIx64
>   kvm_sysreg_write(const char *name, uint64_t val) "%s <=  0x%" PRIx64
> +kvm_hypercall(int ec, uint64_t arg0) "%d: %"PRIx64


