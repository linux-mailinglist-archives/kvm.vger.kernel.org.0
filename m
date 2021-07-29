Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4293DAC78
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 22:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbhG2UIJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 16:08:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232786AbhG2UIC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jul 2021 16:08:02 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9CB3C0613C1
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 13:07:58 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id f18so13182608lfu.10
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 13:07:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jTmFh8dBUxxfIA7MnCPlfr2/MF7WnSFwZKcouyPXsrI=;
        b=j3mDa6/bGguSlBEB/5YxoKvbffgwh8rRFdcJJYMuubkjWC7CzKoNOZD3yPNxJ5HXdP
         hr+DzfA66ATd4M7E2M+M9zIPjJABeU+0Z61nfoY9yQ7zilP+BKfpzFqjtu00y0DbImoJ
         FTcarWb2JwjnWDYZCTMQ30Lw2y2/cEPmgU5RxAZDbsvJT9r52Z8AErywhCQ5AHiYBGnj
         LQrDuL/pl8MB2hzSyUiTTaSfvn+bLP1LwIqLrY+bKAdNRfLwWBAQXSPX5vOgARcuEjHW
         8gM3Rf16RdRVskU9QL4fMLoKQ1RhQ6RpT/7d83kUJ4+MU9JieNSqBmgPZyqNihnU1eaq
         XeCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jTmFh8dBUxxfIA7MnCPlfr2/MF7WnSFwZKcouyPXsrI=;
        b=LnNahrSaD9KG4kccOMQalDr1I1zvKyhuBxDy3kloKhMcXY90E+EnBHR9JOFd88DnbB
         MrqDeCJSb8JZ5jZK33/JseFvNswoUOLzLWULXxXwOie/G2UebCoAn5EQloOSvOWr0KJ2
         lITBhxZjpJcLUGxAwFE+nZrU6ntEIsZAT8fiTm6xQh2haS0QWwcn9RDvYv/FnKWFIsaq
         cRdaL3ztcAIk1OFZTIawAp1FOBTJ5ujnOFA+AYFUh8P7gw3lt9iO5H0POrduVJoWgItr
         mhx2n3ettIw/W8CSu6u6poFC9LIsTmLWkAdZOIGh6WdW7CXKKlX4dJQ9NH6ZJnKZd69y
         rNaw==
X-Gm-Message-State: AOAM530KAShFmMQaq72nHNpUzxT0ogFR0NyjtlekxY1d761ww7F7xflt
        UJhVqrDDs86/iw2gOUImzj63fAV0WrXN178iLGkOkg==
X-Google-Smtp-Source: ABdhPJyCK1cfhDjBCUWkIafk33w1RKfYfFOKKupy9ZzcP8PGybq89vd6BezAvcQkfzUv0BhjixrwfA9GUnzLCWOGh0E=
X-Received: by 2002:a19:6b14:: with SMTP id d20mr5099285lfa.359.1627589276715;
 Thu, 29 Jul 2021 13:07:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210729195632.489978-1-oupton@google.com> <20210729195632.489978-2-oupton@google.com>
In-Reply-To: <20210729195632.489978-2-oupton@google.com>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Thu, 29 Jul 2021 13:07:45 -0700
Message-ID: <CAAdAUtge_wRL-Ri-TngototL5jixSfDyJm7nTaYBXJqXU0jfmw@mail.gmail.com>
Subject: Re: [PATCH 1/3] KVM: arm64: Record number of signal exits as a vCPU stat
To:     Oliver Upton <oupton@google.com>
Cc:     KVM ARM <kvmarm@lists.cs.columbia.edu>, KVM <kvm@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Guangyu Shi <guangyus@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 29, 2021 at 12:56 PM Oliver Upton <oupton@google.com> wrote:
>
> Most other architectures that implement KVM record a statistic
> indicating the number of times a vCPU has exited due to a pending
> signal. Add support for that stat to arm64.
>
> Cc: Jing Zhang <jingzhangos@google.com>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h | 1 +
>  arch/arm64/kvm/arm.c              | 1 +
>  arch/arm64/kvm/guest.c            | 3 ++-
>  3 files changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 41911585ae0c..70e129f2b574 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -576,6 +576,7 @@ struct kvm_vcpu_stat {
>         u64 wfi_exit_stat;
>         u64 mmio_exit_user;
>         u64 mmio_exit_kernel;
> +       u64 signal_exits;
>         u64 exits;
>  };
>
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index e9a2b8f27792..60d0a546d7fd 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -783,6 +783,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>                 if (signal_pending(current)) {
>                         ret = -EINTR;
>                         run->exit_reason = KVM_EXIT_INTR;
> +                       ++vcpu->stat.signal_exits;
>                 }
>
>                 /*
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index 1dfb83578277..50fc16ad872f 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -50,7 +50,8 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
>         STATS_DESC_COUNTER(VCPU, wfi_exit_stat),
>         STATS_DESC_COUNTER(VCPU, mmio_exit_user),
>         STATS_DESC_COUNTER(VCPU, mmio_exit_kernel),
> -       STATS_DESC_COUNTER(VCPU, exits)
> +       STATS_DESC_COUNTER(VCPU, exits),
> +       STATS_DESC_COUNTER(VCPU, signal_exits),
How about put signal_exits before exits as the same order in
kvm_vcpu_stat just for readability?
>  };
>  static_assert(ARRAY_SIZE(kvm_vcpu_stats_desc) ==
>                 sizeof(struct kvm_vcpu_stat) / sizeof(u64));
> --
> 2.32.0.554.ge1b32706d8-goog
>
Reviewed-by: Jing Zhang <jingzhangos@google.com>

Thanks,
Jing
