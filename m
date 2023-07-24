Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 238E775E9D3
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 04:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbjGXCgb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 Jul 2023 22:36:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjGXCg3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 Jul 2023 22:36:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A00ADA6
        for <kvm@vger.kernel.org>; Sun, 23 Jul 2023 19:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690166134;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pQ0b33DEtx6Tu9jL5PjvjykbQH4RgVFr/7dqo17i/K8=;
        b=D6qyQsyUBH60E4/kfRWjoTHMQDigF85gHn4jnfYxTRqrFES21wuEKyo6+8NdpiQ57wl49l
        3XQSYf7J0uUcYpxJdCAwx/BVaLXEDieNfUuJKhN5pCaJicDnLogf3cG4gihz6BlANxWIri
        TB1fvlJwA85EyLKU+z8yyaTz3/g7sp8=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-82-dmvlpH8fOFSAK-b83r951Q-1; Sun, 23 Jul 2023 22:35:32 -0400
X-MC-Unique: dmvlpH8fOFSAK-b83r951Q-1
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-3a1e6022b60so8962501b6e.1
        for <kvm@vger.kernel.org>; Sun, 23 Jul 2023 19:35:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690166131; x=1690770931;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pQ0b33DEtx6Tu9jL5PjvjykbQH4RgVFr/7dqo17i/K8=;
        b=AUyTqAXgAx/q0NNV1XzTNd5Sp0eM5gFABdNIn1/YJK0aiHVjGc9819/7C/rQkr7Xzw
         hqFZl0fRicVz356D+0SCqzPoQ46qXOzOxTxwgVy+YQ6z29DAsiQczlytadfsaAUeq14y
         EbT027PVhvVYH1qf9VpuBwlaXEFmIx1vvz4nnEKALRDQNrlWO/SzI42ACHVJyjOjJ6+7
         IEca+DirByvifBZJf4fNNEi/29DUW5BOezRVFgFy0LBKQbOdhQEB20BJkwiXTJX226z+
         9D8E+yAU3mZQI+hDuQi98HufFNjHOchu5eCCZdZhtyDqswR+rlojabT9X1Q9BWhvejgI
         ycPg==
X-Gm-Message-State: ABy/qLY6tUBS1N+IwP3bDdGyL/4N4Nr+wcSqX+X6yoIIXefghf9WNZH0
        mxU6YBNz3r1NjDUAyHLhJdPWJbKNc2iUav1XtfLFaOwdFaZAGfhzYbLhX4KXghg+eIsb3l5cpK5
        qgMvhtDoqrkZX
X-Received: by 2002:a05:6808:1241:b0:3a4:2a13:71ca with SMTP id o1-20020a056808124100b003a42a1371camr9623738oiv.16.1690166131466;
        Sun, 23 Jul 2023 19:35:31 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHOI1EgNDQ5Zi1b9iT4riN9JqLaIcV79BwHa3KJM85qTw/JGCGGPkyAMnNESXnWE4Yxc+7HMA==
X-Received: by 2002:a05:6808:1241:b0:3a4:2a13:71ca with SMTP id o1-20020a056808124100b003a42a1371camr9623724oiv.16.1690166131106;
        Sun, 23 Jul 2023 19:35:31 -0700 (PDT)
Received: from ?IPV6:2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5? ([2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5])
        by smtp.gmail.com with ESMTPSA id i22-20020a633c56000000b005633311c70dsm7311250pgn.32.2023.07.23.19.35.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Jul 2023 19:35:30 -0700 (PDT)
Message-ID: <db578c20-22d9-3b76-63e7-d99b891f6d36@redhat.com>
Date:   Mon, 24 Jul 2023 12:35:25 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH for-8.2 2/2] arm/kvm: convert to kvm_get_one_reg
Content-Language: en-US
To:     Cornelia Huck <cohuck@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20230718111404.23479-1-cohuck@redhat.com>
 <20230718111404.23479-3-cohuck@redhat.com>
From:   Gavin Shan <gshan@redhat.com>
In-Reply-To: <20230718111404.23479-3-cohuck@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Connie,

On 7/18/23 21:14, Cornelia Huck wrote:
> We can neaten the code by switching the callers that work on a
> CPUstate to the kvm_get_one_reg function.
> 
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>   target/arm/kvm.c   | 15 +++---------
>   target/arm/kvm64.c | 57 ++++++++++++----------------------------------
>   2 files changed, 18 insertions(+), 54 deletions(-)
> 

The replacements look good to me. However, I guess it's worty to apply
the same replacements for target/arm/kvm64.c since we're here?

[gshan@gshan arm]$ pwd
/home/gshan/sandbox/q/target/arm
[gshan@gshan arm]$ git grep KVM_GET_ONE_REG
kvm64.c:    err = ioctl(fd, KVM_GET_ONE_REG, &idreg);
kvm64.c:    return ioctl(fd, KVM_GET_ONE_REG, &idreg);
kvm64.c:        ret = ioctl(fdarray[2], KVM_GET_ONE_REG, &reg);

Thanks,
Gavin

> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index cdbffc3c6e0d..4123f6dc9d72 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -525,24 +525,19 @@ bool write_kvmstate_to_list(ARMCPU *cpu)
>       bool ok = true;
>   
>       for (i = 0; i < cpu->cpreg_array_len; i++) {
> -        struct kvm_one_reg r;
>           uint64_t regidx = cpu->cpreg_indexes[i];
>           uint32_t v32;
>           int ret;
>   
> -        r.id = regidx;
> -
>           switch (regidx & KVM_REG_SIZE_MASK) {
>           case KVM_REG_SIZE_U32:
> -            r.addr = (uintptr_t)&v32;
> -            ret = kvm_vcpu_ioctl(cs, KVM_GET_ONE_REG, &r);
> +            ret = kvm_get_one_reg(cs, regidx, &v32);
>               if (!ret) {
>                   cpu->cpreg_values[i] = v32;
>               }
>               break;
>           case KVM_REG_SIZE_U64:
> -            r.addr = (uintptr_t)(cpu->cpreg_values + i);
> -            ret = kvm_vcpu_ioctl(cs, KVM_GET_ONE_REG, &r);
> +            ret = kvm_get_one_reg(cs, regidx, cpu->cpreg_values + i);
>               break;
>           default:
>               g_assert_not_reached();
> @@ -678,17 +673,13 @@ int kvm_arm_sync_mpstate_to_qemu(ARMCPU *cpu)
>   void kvm_arm_get_virtual_time(CPUState *cs)
>   {
>       ARMCPU *cpu = ARM_CPU(cs);
> -    struct kvm_one_reg reg = {
> -        .id = KVM_REG_ARM_TIMER_CNT,
> -        .addr = (uintptr_t)&cpu->kvm_vtime,
> -    };
>       int ret;
>   
>       if (cpu->kvm_vtime_dirty) {
>           return;
>       }
>   
> -    ret = kvm_vcpu_ioctl(cs, KVM_GET_ONE_REG, &reg);
> +    ret = kvm_get_one_reg(cs, KVM_REG_ARM_TIMER_CNT, &cpu->kvm_vtime);
>       if (ret) {
>           error_report("Failed to get KVM_REG_ARM_TIMER_CNT");
>           abort();
> diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
> index b4d02dff5381..66b52d6f8d23 100644
> --- a/target/arm/kvm64.c
> +++ b/target/arm/kvm64.c
> @@ -908,14 +908,11 @@ int kvm_arch_put_registers(CPUState *cs, int level)
>   static int kvm_arch_get_fpsimd(CPUState *cs)
>   {
>       CPUARMState *env = &ARM_CPU(cs)->env;
> -    struct kvm_one_reg reg;
>       int i, ret;
>   
>       for (i = 0; i < 32; i++) {
>           uint64_t *q = aa64_vfp_qreg(env, i);
> -        reg.id = AARCH64_SIMD_CORE_REG(fp_regs.vregs[i]);
> -        reg.addr = (uintptr_t)q;
> -        ret = kvm_vcpu_ioctl(cs, KVM_GET_ONE_REG, &reg);
> +        ret = kvm_get_one_reg(cs, AARCH64_SIMD_CORE_REG(fp_regs.vregs[i]), q);
>           if (ret) {
>               return ret;
>           } else {
> @@ -939,15 +936,12 @@ static int kvm_arch_get_sve(CPUState *cs)
>   {
>       ARMCPU *cpu = ARM_CPU(cs);
>       CPUARMState *env = &cpu->env;
> -    struct kvm_one_reg reg;
>       uint64_t *r;
>       int n, ret;
>   
>       for (n = 0; n < KVM_ARM64_SVE_NUM_ZREGS; ++n) {
>           r = &env->vfp.zregs[n].d[0];
> -        reg.addr = (uintptr_t)r;
> -        reg.id = KVM_REG_ARM64_SVE_ZREG(n, 0);
> -        ret = kvm_vcpu_ioctl(cs, KVM_GET_ONE_REG, &reg);
> +        ret = kvm_get_one_reg(cs, KVM_REG_ARM64_SVE_ZREG(n, 0), r);
>           if (ret) {
>               return ret;
>           }
> @@ -956,9 +950,7 @@ static int kvm_arch_get_sve(CPUState *cs)
>   
>       for (n = 0; n < KVM_ARM64_SVE_NUM_PREGS; ++n) {
>           r = &env->vfp.pregs[n].p[0];
> -        reg.addr = (uintptr_t)r;
> -        reg.id = KVM_REG_ARM64_SVE_PREG(n, 0);
> -        ret = kvm_vcpu_ioctl(cs, KVM_GET_ONE_REG, &reg);
> +        ret = kvm_get_one_reg(cs, KVM_REG_ARM64_SVE_PREG(n, 0), r);
>           if (ret) {
>               return ret;
>           }
> @@ -966,9 +958,7 @@ static int kvm_arch_get_sve(CPUState *cs)
>       }
>   
>       r = &env->vfp.pregs[FFR_PRED_NUM].p[0];
> -    reg.addr = (uintptr_t)r;
> -    reg.id = KVM_REG_ARM64_SVE_FFR(0);
> -    ret = kvm_vcpu_ioctl(cs, KVM_GET_ONE_REG, &reg);
> +    ret = kvm_get_one_reg(cs, KVM_REG_ARM64_SVE_FFR(0), r);
>       if (ret) {
>           return ret;
>       }
> @@ -979,7 +969,6 @@ static int kvm_arch_get_sve(CPUState *cs)
>   
>   int kvm_arch_get_registers(CPUState *cs)
>   {
> -    struct kvm_one_reg reg;
>       uint64_t val;
>       unsigned int el;
>       uint32_t fpr;
> @@ -989,31 +978,24 @@ int kvm_arch_get_registers(CPUState *cs)
>       CPUARMState *env = &cpu->env;
>   
>       for (i = 0; i < 31; i++) {
> -        reg.id = AARCH64_CORE_REG(regs.regs[i]);
> -        reg.addr = (uintptr_t) &env->xregs[i];
> -        ret = kvm_vcpu_ioctl(cs, KVM_GET_ONE_REG, &reg);
> +        ret = kvm_get_one_reg(cs, AARCH64_CORE_REG(regs.regs[i]),
> +                              &env->xregs[i]);
>           if (ret) {
>               return ret;
>           }
>       }
>   
> -    reg.id = AARCH64_CORE_REG(regs.sp);
> -    reg.addr = (uintptr_t) &env->sp_el[0];
> -    ret = kvm_vcpu_ioctl(cs, KVM_GET_ONE_REG, &reg);
> +    ret = kvm_get_one_reg(cs, AARCH64_CORE_REG(regs.sp), &env->sp_el[0]);
>       if (ret) {
>           return ret;
>       }
>   
> -    reg.id = AARCH64_CORE_REG(sp_el1);
> -    reg.addr = (uintptr_t) &env->sp_el[1];
> -    ret = kvm_vcpu_ioctl(cs, KVM_GET_ONE_REG, &reg);
> +    ret = kvm_get_one_reg(cs, AARCH64_CORE_REG(sp_el1), &env->sp_el[1]);
>       if (ret) {
>           return ret;
>       }
>   
> -    reg.id = AARCH64_CORE_REG(regs.pstate);
> -    reg.addr = (uintptr_t) &val;
> -    ret = kvm_vcpu_ioctl(cs, KVM_GET_ONE_REG, &reg);
> +    ret = kvm_get_one_reg(cs, AARCH64_CORE_REG(regs.pstate), &val);
>       if (ret) {
>           return ret;
>       }
> @@ -1030,9 +1012,7 @@ int kvm_arch_get_registers(CPUState *cs)
>        */
>       aarch64_restore_sp(env, 1);
>   
> -    reg.id = AARCH64_CORE_REG(regs.pc);
> -    reg.addr = (uintptr_t) &env->pc;
> -    ret = kvm_vcpu_ioctl(cs, KVM_GET_ONE_REG, &reg);
> +    ret = kvm_get_one_reg(cs, AARCH64_CORE_REG(regs.pc), &env->pc);
>       if (ret) {
>           return ret;
>       }
> @@ -1046,9 +1026,7 @@ int kvm_arch_get_registers(CPUState *cs)
>           aarch64_sync_64_to_32(env);
>       }
>   
> -    reg.id = AARCH64_CORE_REG(elr_el1);
> -    reg.addr = (uintptr_t) &env->elr_el[1];
> -    ret = kvm_vcpu_ioctl(cs, KVM_GET_ONE_REG, &reg);
> +    ret = kvm_get_one_reg(cs, AARCH64_CORE_REG(elr_el1), &env->elr_el[1]);
>       if (ret) {
>           return ret;
>       }
> @@ -1058,9 +1036,8 @@ int kvm_arch_get_registers(CPUState *cs)
>        * KVM SPSRs 0-4 map to QEMU banks 1-5
>        */
>       for (i = 0; i < KVM_NR_SPSR; i++) {
> -        reg.id = AARCH64_CORE_REG(spsr[i]);
> -        reg.addr = (uintptr_t) &env->banked_spsr[i + 1];
> -        ret = kvm_vcpu_ioctl(cs, KVM_GET_ONE_REG, &reg);
> +        ret = kvm_get_one_reg(cs, AARCH64_CORE_REG(spsr[i]),
> +                              &env->banked_spsr[i + 1]);
>           if (ret) {
>               return ret;
>           }
> @@ -1081,17 +1058,13 @@ int kvm_arch_get_registers(CPUState *cs)
>           return ret;
>       }
>   
> -    reg.addr = (uintptr_t)(&fpr);
> -    reg.id = AARCH64_SIMD_CTRL_REG(fp_regs.fpsr);
> -    ret = kvm_vcpu_ioctl(cs, KVM_GET_ONE_REG, &reg);
> +    ret = kvm_get_one_reg(cs, AARCH64_SIMD_CTRL_REG(fp_regs.fpsr), &fpr);
>       if (ret) {
>           return ret;
>       }
>       vfp_set_fpsr(env, fpr);
>   
> -    reg.addr = (uintptr_t)(&fpr);
> -    reg.id = AARCH64_SIMD_CTRL_REG(fp_regs.fpcr);
> -    ret = kvm_vcpu_ioctl(cs, KVM_GET_ONE_REG, &reg);
> +    ret = kvm_get_one_reg(cs, AARCH64_SIMD_CTRL_REG(fp_regs.fpcr), &fpr);
>       if (ret) {
>           return ret;
>       }

