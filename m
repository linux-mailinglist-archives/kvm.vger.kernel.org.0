Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD7059F25B
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 06:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234269AbiHXEHu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Aug 2022 00:07:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbiHXEHs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Aug 2022 00:07:48 -0400
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F8B17C1FE
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 21:07:45 -0700 (PDT)
Received: by mail-vs1-xe34.google.com with SMTP id o123so16411705vsc.3
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 21:07:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=ukyoAnmvcbI6w6tZqMe707q+h84BjnakUB+/IlncsVg=;
        b=SSG5i8AC1ReZYh3rnUzenRLWcEPdUNx/npUoFtyPwwtkmFmpL40T6PSy0hkrwhnqOF
         VdG2+QBhaOBGbtMndzxzhEIkPQUlAzVyQ21ZlglZZZbR7IOWuvoBmaBJtmmG0LnRA9Jr
         XxaWmYPZffIKu4OLGlc6d7V2FI4t/16l44JDIRiTo8y6CQX2J7EBDjF68guPUJg9lYNL
         ZWcwX5ZNjtq4VSCigFlO4P5ZD/qmw9h3kwLuXQpGt9hJWu7WUPIHxZbz2ymvl2DPxuhG
         FUnh3kgcYIjINJgXxUSKozrFMICssHcE1BdDiihZswDDXNBFUZdlvCG28zvR9gCJBYIh
         cc0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=ukyoAnmvcbI6w6tZqMe707q+h84BjnakUB+/IlncsVg=;
        b=tFHHGRwPrMN38ihzXyHDCRVD4Xs+Ai8xupBTS6r1jrwRbfKcnAg08/KkPiDlkwOEd0
         KC1ndlt02AYoAT8sJlG+b9ZSy/8ZQe+OzbNuY1cuOC7fVRHfmUIP7JSUBQzsFbMvrW38
         xZbxZ0DknsjQL0yxFRnmCMGhLsGTH9UcDa2eVMV+8O3/DYgX3wD5JvoeYSImh79mZNug
         VUgLpyTtucZnuAZJEAn0oIeoqJN8O6TXuiqbpe6hOaWknXyb1J9h+5tVUwXMJ4/gCgc+
         JIPAoN6Rfxp+93fr8ZAOn3TceBB1+1g/5e0KHyHOjbXp5mXBn5Sm0xAgGHqZbLbdfhLo
         VvqQ==
X-Gm-Message-State: ACgBeo0WfzUqJgpSfPeZYqMZEjQDyTCPnspSFDIRND5r3MUTnATY3HEP
        97X1otl9+S0J6P+K+ibYe3ZBSkShhuHavXK62Mx0zo3aqq/YGw==
X-Google-Smtp-Source: AA6agR7Hn+KTQGYk4s8vmWz0LPxNEZbob6PfcYLRNYN99xLFE+sJydh8vKX0sKa5n1oU4YTygTiQ20by9OJ5n2cU4TI=
X-Received: by 2002:a67:de11:0:b0:390:4ef6:6a5f with SMTP id
 q17-20020a67de11000000b003904ef66a5fmr5767252vsk.58.1661314064203; Tue, 23
 Aug 2022 21:07:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220805135813.2102034-1-maz@kernel.org> <20220805135813.2102034-4-maz@kernel.org>
In-Reply-To: <20220805135813.2102034-4-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Tue, 23 Aug 2022 21:07:28 -0700
Message-ID: <CAAeT=Fyjc-ce1ABKVeBKYdCjiPDZ9OdS0r6_6q9QCLu8XoCxhw@mail.gmail.com>
Subject: Re: [PATCH 3/9] KVM: arm64: PMU: Only narrow counters that are not
 64bit wide
To:     Marc Zyngier <maz@kernel.org>
Cc:     Linux ARM <linux-arm-kernel@lists.infradead.org>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-15.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,URI_DOTEDU,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Fri, Aug 5, 2022 at 6:58 AM Marc Zyngier <maz@kernel.org> wrote:
>
> The current PMU emulation sometimes narrows counters to 32bit
> if the counter isn't the cycle counter. As this is going to
> change with PMUv3p5 where the counters are all 64bit, only
> perform the narrowing on 32bit counters.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/pmu-emul.c | 17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
>
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index 9040d3c80096..0ab6f59f433c 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -149,22 +149,22 @@ static void kvm_pmu_release_perf_event(struct kvm_pmc *pmc)
>   */
>  static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc)
>  {
> -       u64 counter, reg, val;
> +       u64 counter, reg;
>
>         if (!pmc->perf_event)
>                 return;
>
>         counter = kvm_pmu_get_counter_value(vcpu, pmc->idx);
>
> -       if (pmc->idx == ARMV8_PMU_CYCLE_IDX) {
> +       if (pmc->idx == ARMV8_PMU_CYCLE_IDX)
>                 reg = PMCCNTR_EL0;
> -               val = counter;
> -       } else {
> +       else
>                 reg = PMEVCNTR0_EL0 + pmc->idx;
> -               val = lower_32_bits(counter);
> -       }
>
> -       __vcpu_sys_reg(vcpu, reg) = val;
> +       if (!kvm_pmu_idx_is_64bit(vcpu, pmc->idx))
> +               counter = lower_32_bits(counter);

It appears that narrowing the counter to 32bit here is unnecessary
because it is already done by kvm_pmu_get_counter_value().

Thank you,
Reiji

> +
> +       __vcpu_sys_reg(vcpu, reg) = counter;
>
>         kvm_pmu_release_perf_event(pmc);
>  }
> @@ -417,7 +417,8 @@ static void kvm_pmu_counter_increment(struct kvm_vcpu *vcpu,
>
>                 /* Increment this counter */
>                 reg = __vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i) + 1;
> -               reg = lower_32_bits(reg);
> +               if (!kvm_pmu_idx_is_64bit(vcpu, i))
> +                       reg = lower_32_bits(reg);
>                 __vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i) = reg;
>
>                 if (reg) /* No overflow? move on */
> --
> 2.34.1
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
