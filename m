Return-Path: <kvm+bounces-45343-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 001ABAA8801
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 18:22:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 53F983B70C5
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 16:21:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 190CC1DED42;
	Sun,  4 May 2025 16:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hBsRtwXT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B23E1D63CF
	for <kvm@vger.kernel.org>; Sun,  4 May 2025 16:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746375728; cv=none; b=NSZcjtXmp7hD+v5h39UiQS+QsEqwtDZBtvkjEqFSHLLVlJ0gzjLNmzwueQvV/hZibvUFc+YplgiSgTMPawU5FQhIt3QlgWRCsZxRiHsuxelf2yN32qKx+8ieXNTlWrjGDiemV8lg/2mrLDRrt31Sfd9TkH4rQLQNX4v5CFpRJ7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746375728; c=relaxed/simple;
	bh=VG4JJ4KAWkCPjI5rcDChgcfockee1+od6LqkOF7bUsk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mdDt70XHDJ2SjzQj3uxiFFgkrSKx8ngHgG7K5MT0N4pr+ywGFvP9FEjmkDMLnADkk+21SUjt2Q7R0d1uXuQhEkiBSymALGCQAkD1JZ8Q0UMwsfkcejtNJFpCmkoZyS9vcXq3raQzjhEbv9fkYNUXwRC7HAO96XIFz4l2x7qIhZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=hBsRtwXT; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-736a72220edso4101228b3a.3
        for <kvm@vger.kernel.org>; Sun, 04 May 2025 09:22:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746375726; x=1746980526; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ndDhIW14pK8IkolQgEpyEOmdYP4fJJ6SOj1tajl/8JQ=;
        b=hBsRtwXT+d2XXh70BP5YJp+D2cQOScMAD4m+EZ5MMSL0bLb8ncQ+JpW8WqWmq2P6Yn
         lP9J8W60Dka/YiF6HZdjxtBj6VgjD9u+E5fjDmqXUYZtZU68q1HxWqSaHyVyzK1gssn0
         Rr0/oiz6w8dC5QlakccpSi2iaAue8WTppmd/lbdU+i8pux81tRPc2tgna2MyTotv4lbI
         xc8tT2RBVRcnQ12wakd1e+qCW7nbhuP4j7WXyT/wJYFzFiwb3yGgocKnAzUbZDejshKO
         9b3ZN8c8A06a9Nw4ieujDrU+RtArP0COgiS45vV22w/xIX6oecJVskWGpbv3zs1jF5yy
         y6Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746375726; x=1746980526;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ndDhIW14pK8IkolQgEpyEOmdYP4fJJ6SOj1tajl/8JQ=;
        b=YuklM2FTkg1ONCgUiddciEkJP9iHbbkaU5W6IkE6sOZmy8zQPAGqG5q+jLqv75ADNu
         vSg03eBjc/UM02GshfUMY8xoxOOLQahS7hU1aD4QueGEy/rbJUcYN6KJV4U4JHfkmztZ
         zK0RuZPAPEN5ZhoHd9fHolZFblJh1RZXoiTRLWwlSJQtF+44IBjFzHXl83IxTw9fRBlM
         rc01ixefT/FkmvwQK3BYxdLF6ZASJgwSlA+RwHrW/N0yj+lkNE7Nc2nv7AUmZ6NyLFRa
         V8j3DE4cn76U0vfmA6Wtku2xc4VU50x9+yh8yx0kd29WqsfCx+HOaPH3QHcWRpKOHhGB
         t9Aw==
X-Forwarded-Encrypted: i=1; AJvYcCXonKHR6MWkL6Kwarleq7wntsazifZViGamDxElyWkXfDqLFG+OFZW8oq1Wyt79mxKKFO4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyEc0EikVRMwumi+btWjMeVSeJu5vCBY1uu1yQG4SaPLq60kh2F
	Blx4c4q8peAxA1ijStK2zWPZCEWfcQRngVVvlXdSZ72/Cfuvw6QCE4yeVbpTdqI=
X-Gm-Gg: ASbGnctNi4c97Byno0JOyYGi/otcOJmX/TzCIYcUsZZ6CpSWUwxQWQaEv2pWHvO8uz/
	+Saa8EV/pQzLvOBjn/qYKF8mYxBMbGSJ9CCE3wXGTo+H3yBEhipn/SFOk+jv9wATTMyqTBHn8Pe
	+jhSWVtASVzpHhyjDgwDvdiBCtZVZKMlg9iniwW3CgnqxUCJCQ15las/VqjFnWoCv4M6GPz0759
	59NN+GOaF659uxNYys+3qrSKFFEiWBGwvM4SrCOd1SlEbSKEqrmsMFdg9pmxOxaLwDoQKPr/Po5
	dtcpD2fbjj0HY7aZPy9ORaWMLmiqjAzzpPsQoGvFFx3vtLv2/b6n+g3R67Sxyg5BACSHXXJV2Kb
	Dv5j/hu8=
X-Google-Smtp-Source: AGHT+IHVJPSMpIDvkRNVyiQSjsJkxQ58q8D2M+vHLwC2ekg+35/hzKUAXwGeniC9hDYK89dJmepvyQ==
X-Received: by 2002:a05:6a00:4409:b0:73b:71a9:a5ad with SMTP id d2e1a72fcca58-740673faa0bmr8590456b3a.16.1746375725859;
        Sun, 04 May 2025 09:22:05 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74059021090sm5039609b3a.116.2025.05.04.09.22.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 May 2025 09:22:05 -0700 (PDT)
Message-ID: <2d9560be-1120-42f9-85db-69b8407c49b8@linaro.org>
Date: Sun, 4 May 2025 09:22:04 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 38/40] target/arm/machine: move cpu_post_load kvm bits
 to kvm_arm_cpu_post_load function
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org, anjo@rev.ng,
 kvm@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 alex.bennee@linaro.org
References: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
 <20250504052914.3525365-39-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250504052914.3525365-39-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/3/25 22:29, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   target/arm/kvm_arm.h |  4 +++-
>   target/arm/kvm.c     | 13 ++++++++++++-
>   target/arm/machine.c |  8 +-------
>   3 files changed, 16 insertions(+), 9 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>


r~

> 
> diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
> index d156c790b66..00fc82db711 100644
> --- a/target/arm/kvm_arm.h
> +++ b/target/arm/kvm_arm.h
> @@ -83,8 +83,10 @@ void kvm_arm_cpu_pre_save(ARMCPU *cpu);
>    * @cpu: ARMCPU
>    *
>    * Called from cpu_post_load() to update KVM CPU state from the cpreg list.
> + *
> + * Returns: true on success, or false if write_list_to_kvmstate failed.
>    */
> -void kvm_arm_cpu_post_load(ARMCPU *cpu);
> +bool kvm_arm_cpu_post_load(ARMCPU *cpu);
>   
>   /**
>    * kvm_arm_reset_vcpu:
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index 8f68aa10298..8132f2345c5 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -977,13 +977,24 @@ void kvm_arm_cpu_pre_save(ARMCPU *cpu)
>       }
>   }
>   
> -void kvm_arm_cpu_post_load(ARMCPU *cpu)
> +bool kvm_arm_cpu_post_load(ARMCPU *cpu)
>   {
> +    if (!write_list_to_kvmstate(cpu, KVM_PUT_FULL_STATE)) {
> +        return false;
> +    }
> +    /* Note that it's OK for the TCG side not to know about
> +     * every register in the list; KVM is authoritative if
> +     * we're using it.
> +     */
> +    write_list_to_cpustate(cpu);
> +
>       /* KVM virtual time adjustment */
>       if (cpu->kvm_adjvtime) {
>           cpu->kvm_vtime = *kvm_arm_get_cpreg_ptr(cpu, KVM_REG_ARM_TIMER_CNT);
>           cpu->kvm_vtime_dirty = true;
>       }
> +
> +    return true;
>   }
>   
>   void kvm_arm_reset_vcpu(ARMCPU *cpu)
> diff --git a/target/arm/machine.c b/target/arm/machine.c
> index 868246a98c0..e442d485241 100644
> --- a/target/arm/machine.c
> +++ b/target/arm/machine.c
> @@ -976,15 +976,9 @@ static int cpu_post_load(void *opaque, int version_id)
>       }
>   
>       if (kvm_enabled()) {
> -        if (!write_list_to_kvmstate(cpu, KVM_PUT_FULL_STATE)) {
> +        if (!kvm_arm_cpu_post_load(cpu)) {
>               return -1;
>           }
> -        /* Note that it's OK for the TCG side not to know about
> -         * every register in the list; KVM is authoritative if
> -         * we're using it.
> -         */
> -        write_list_to_cpustate(cpu);
> -        kvm_arm_cpu_post_load(cpu);
>       } else {
>           if (!write_list_to_cpustate(cpu)) {
>               return -1;


