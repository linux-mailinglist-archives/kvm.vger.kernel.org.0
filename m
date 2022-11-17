Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CECB762D3A0
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 07:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233958AbiKQGvJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 01:51:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234760AbiKQGvH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 01:51:07 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 780F75E3D3
        for <kvm@vger.kernel.org>; Wed, 16 Nov 2022 22:51:04 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id s196so1191128pgs.3
        for <kvm@vger.kernel.org>; Wed, 16 Nov 2022 22:51:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0y7VdxwHLwhJHQkWTFwHzknojiHUon3RH8OwCo8MxdU=;
        b=COdBKeWciEUcxRjfv54pacO7y07o7BOLG2qNenQAwJZp0M8UcST5OLdENV5peqP150
         Lld+WqcJLCLA+svE//sI6HZ6boKGiC065GyL/C0UlhvdTHZ5Meyas0NOdL7b7ZTEU28Q
         QLyIkqxH2KQnHACOB7hgCx24pGu5v7lo6J9P8KPO1SdtyT1QdItekW+gmj2e75LB+Abb
         7Vz+f0D6/pT4wBL1tP/5/3ue0NtF0FKlpOScalgJvQq4lHJCJ3neX4zMR2gLkiQifGyx
         /CtxNEeSMt8duyrk6Q8s95bPhQFa4YdeIoinYBLMM+OR1Ywg6jMqEoVCkufjCJXEcqHY
         bHmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0y7VdxwHLwhJHQkWTFwHzknojiHUon3RH8OwCo8MxdU=;
        b=xTgR+syqHBAzT1V83BhzKXgUoGX4Eg1f0IUH6w8EknnvQOOggKIo26hnn3mdWyuu86
         gL3jt4vvi9rHXNarFZ4kXk29JxgCtC26T11YiCH68qxaqUKPDNJLB6xqLMvvmIvM/ML/
         6C8MTT153U+aQCggshzCNiP8XSGGAboT5TFsjoxrQjhqAvrXDt4/VQg70Zb1xD2COJYm
         TEG2F/szReQ84LjK0KhNmFL7I7P8vvkZf2wgObZNtE4ARcmkzKVX1lRnChKy+nXdp3Pr
         c2ys425ubRauvPMORGuqU10mcbagWX8SgjTAWWb6P96i8PwF3G5If8i2LlGwCmlUcbv5
         z7ZA==
X-Gm-Message-State: ANoB5pm7EJt+IID5GzxsLB4HnFu7mjJvqtQERcjOyooG+sAhLjQGoDhw
        0GeKLLhOJCZbJqtGdKUQfPtBwcVUvpuokZ6kYp0y2A==
X-Google-Smtp-Source: AA0mqf7ZAaFwtnsQ/o31Qma+1YQJIdWkjS6YTmda5EJO78rYJYD90n/VB3W/Ch7Q9Uxv6tcnOHnWL1HG6hz+RkFwHUk=
X-Received: by 2002:a62:1b0b:0:b0:56d:384:e13a with SMTP id
 b11-20020a621b0b000000b0056d0384e13amr1555432pfb.75.1668667863849; Wed, 16
 Nov 2022 22:51:03 -0800 (PST)
MIME-Version: 1.0
References: <20221113163832.3154370-1-maz@kernel.org> <20221113163832.3154370-6-maz@kernel.org>
In-Reply-To: <20221113163832.3154370-6-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Wed, 16 Nov 2022 22:50:47 -0800
Message-ID: <CAAeT=FzO4_bzOY3m6X=2a4VWxwfBPP8u0wQ0VTeK+64NVe+e3w@mail.gmail.com>
Subject: Re: [PATCH v4 05/16] KVM: arm64: PMU: Narrow the overflow checking
 when required
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Nov 13, 2022 at 8:38 AM Marc Zyngier <maz@kernel.org> wrote:
>
> For 64bit counters that overflow on a 32bit boundary, make
> sure we only check the bottom 32bit to generate a CHAIN event.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/pmu-emul.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index d050143326b5..9e6bc7edc4de 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -417,7 +417,8 @@ static void kvm_pmu_counter_increment(struct kvm_vcpu *vcpu,
>                 reg = lower_32_bits(reg);
>                 __vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i) = reg;
>
> -               if (reg) /* No overflow? move on */
> +               /* No overflow? move on */
> +               if (kvm_pmu_idx_has_64bit_overflow(vcpu, i) ? reg : lower_32_bits(reg))

A few lines up, the 'reg' is unconditionally updated with
"lower_32_bits(reg)". So, the change initially confused me
(until I checked the following patch).  IMHO it might be more
clear if this patch and the next patch are folded into one patch.

Anyway:
Reviewed-by: Reiji Watanabe <reijiw@google.com>

Thank you,
Reiji



>                         continue;
>
>                 /* Mark overflow */
> --
> 2.34.1
>
