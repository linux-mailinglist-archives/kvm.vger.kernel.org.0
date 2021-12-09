Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11D4E46E173
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 05:26:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231847AbhLIE3k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 23:29:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbhLIE3k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Dec 2021 23:29:40 -0500
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AA62C061746
        for <kvm@vger.kernel.org>; Wed,  8 Dec 2021 20:26:07 -0800 (PST)
Received: by mail-ot1-x330.google.com with SMTP id n104-20020a9d2071000000b005799790cf0bso4978801ota.5
        for <kvm@vger.kernel.org>; Wed, 08 Dec 2021 20:26:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bWjs2GPrjXT4tOxc1yOPDRDEYs2nDs5MMgwRE7nN0ak=;
        b=MjLkFo+9Fbjy6soRwifNFNeU2H2JvvrqIgc3JZJ3HU18iJ7SPZYHn7Fniwiha+GaAo
         LFFZcKMNTm/bNRVXMKqjJcjQiV2knRXjHqv6Vq9s2UO48vD4QKstlXeav3WLIihDXBc+
         JJJVRG0IzF3CXS2m9JP5ArIBKyAwxjFfVeDcbIAIwj95Mhv0GZg9d9manz0ctVFfbb1D
         VTl86/Lemdjm7XnEggzgn7SMdZbDUj10uM/bu666Cqs3gjbH4Y3Y4ShNsb3sXFVo7ug7
         L0UXeJGIh7qObfPCj5UkqGatjGzm7hKjjKrOLPstVAPwEscR+8Ubm5zjqy/aSwSFUzhp
         AfKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bWjs2GPrjXT4tOxc1yOPDRDEYs2nDs5MMgwRE7nN0ak=;
        b=mJCFXdVSJncxQ4zVkJPzeOvgEMX6fWhzGk06fERDTzpJmOOZvSHKhwa3dLhvZYGNwp
         E0vbbSRdb4S814Fxr5N57pzk/HxpO3MDraxJvuJDBRcDz913OFmWc6hYlo/WfxgaoraU
         2OF12cGKveifkHV+8Wcgja7DPeQqB0Abqr7o81+a+Pr42zqhrY/X8miVRLJMM5NNKk+L
         6l8v78/w7jID0MTVX+1cKFNkzzWPFBcuDAEOJGJqcQowAVdnfHsMbtoGuYb+jABxMVkC
         7vD4XPwB4F68D4M5gv2XuMzXxARwFreO5GAsj/RfJ2RdDmBrP0tZbTevwYsz4LjxtAl7
         3Z6w==
X-Gm-Message-State: AOAM532u+/Zuzw7qUKukGHcJxwPONMZa0Ae1pVeXmLb97rgvbDe3CGCn
        STztYRBVRglBRje2BG176AcSvsMkuc4Vn/vyvZCCuw==
X-Google-Smtp-Source: ABdhPJwqQf3MC7OTvxBrKjslpbB7zEcEkngUeRK0z+YIVKW3qu1HCnfiWvW/0n9DomOHqFQgkS/zvJrESG6wKVo5ZEw=
X-Received: by 2002:a05:6830:601:: with SMTP id w1mr3322717oti.267.1639023966439;
 Wed, 08 Dec 2021 20:26:06 -0800 (PST)
MIME-Version: 1.0
References: <20211130074221.93635-1-likexu@tencent.com> <20211130074221.93635-5-likexu@tencent.com>
In-Reply-To: <20211130074221.93635-5-likexu@tencent.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 8 Dec 2021 20:25:55 -0800
Message-ID: <CALMp9eRAxBFE5mYw=isUSsMTWZS2VOjqZfgh0r3hFuF+5npCAQ@mail.gmail.com>
Subject: Re: [PATCH v2 4/6] KVM: x86/pmu: Add pmc->intr to refactor kvm_perf_overflow{_intr}()
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 29, 2021 at 11:42 PM Like Xu <like.xu.linux@gmail.com> wrote:
>
> From: Like Xu <likexu@tencent.com>
>
> Depending on whether intr should be triggered or not, KVM registers
> two different event overflow callbacks in the perf_event context.
>
> The code skeleton of these two functions is very similar, so
> the pmc->intr can be stored into pmc from pmc_reprogram_counter()
> which provides smaller instructions footprint against the
> u-architecture branch predictor.
>
> The __kvm_perf_overflow() can be called in non-nmi contexts
> and a flag is needed to distinguish the caller context and thus
> avoid a check on kvm_is_in_guest(), otherwise we might get
> warnings from suspicious RCU or check_preemption_disabled().
>
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/pmu.c              | 58 ++++++++++++++++-----------------
>  2 files changed, 29 insertions(+), 30 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index e41ad1ead721..6c2b2331ffeb 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -495,6 +495,7 @@ struct kvm_pmc {
>          */
>         u64 current_config;
>         bool is_paused;
> +       bool intr;
>  };
>
>  struct kvm_pmu {
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index b7a1ae28ab87..a20207ee4014 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -55,43 +55,41 @@ static void kvm_pmi_trigger_fn(struct irq_work *irq_work)
>         kvm_pmu_deliver_pmi(vcpu);
>  }
>
> -static void kvm_perf_overflow(struct perf_event *perf_event,
> -                             struct perf_sample_data *data,
> -                             struct pt_regs *regs)
> +static inline void __kvm_perf_overflow(struct kvm_pmc *pmc, bool in_pmi)
>  {
> -       struct kvm_pmc *pmc = perf_event->overflow_handler_context;
>         struct kvm_pmu *pmu = pmc_to_pmu(pmc);
>
> -       if (!test_and_set_bit(pmc->idx, pmu->reprogram_pmi)) {
> -               __set_bit(pmc->idx, (unsigned long *)&pmu->global_status);
> -               kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
> -       }
> +       /* Ignore counters that have been reprogrammed already. */
> +       if (test_and_set_bit(pmc->idx, pmu->reprogram_pmi))
> +               return;
> +
> +       __set_bit(pmc->idx, (unsigned long *)&pmu->global_status);
> +       kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
> +
> +       if (!pmc->intr)
> +               return;
> +
> +       /*
> +        * Inject PMI. If vcpu was in a guest mode during NMI PMI
> +        * can be ejected on a guest mode re-entry. Otherwise we can't
> +        * be sure that vcpu wasn't executing hlt instruction at the
> +        * time of vmexit and is not going to re-enter guest mode until
> +        * woken up. So we should wake it, but this is impossible from
> +        * NMI context. Do it from irq work instead.
> +        */
> +       if (in_pmi && !kvm_is_in_guest())
> +               irq_work_queue(&pmc_to_pmu(pmc)->irq_work);
> +       else
> +               kvm_make_request(KVM_REQ_PMI, pmc->vcpu);
>  }
>
> -static void kvm_perf_overflow_intr(struct perf_event *perf_event,
> -                                  struct perf_sample_data *data,
> -                                  struct pt_regs *regs)
> +static void kvm_perf_overflow(struct perf_event *perf_event,
> +                             struct perf_sample_data *data,
> +                             struct pt_regs *regs)
>  {
>         struct kvm_pmc *pmc = perf_event->overflow_handler_context;
> -       struct kvm_pmu *pmu = pmc_to_pmu(pmc);
> -
> -       if (!test_and_set_bit(pmc->idx, pmu->reprogram_pmi)) {
> -               __set_bit(pmc->idx, (unsigned long *)&pmu->global_status);
> -               kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
>
> -               /*
> -                * Inject PMI. If vcpu was in a guest mode during NMI PMI
> -                * can be ejected on a guest mode re-entry. Otherwise we can't
> -                * be sure that vcpu wasn't executing hlt instruction at the
> -                * time of vmexit and is not going to re-enter guest mode until
> -                * woken up. So we should wake it, but this is impossible from
> -                * NMI context. Do it from irq work instead.
> -                */
> -               if (!kvm_is_in_guest())
> -                       irq_work_queue(&pmc_to_pmu(pmc)->irq_work);
> -               else
> -                       kvm_make_request(KVM_REQ_PMI, pmc->vcpu);
> -       }
> +       __kvm_perf_overflow(pmc, true);
>  }
>
>  static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
> @@ -126,7 +124,6 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
>         }
>
>         event = perf_event_create_kernel_counter(&attr, -1, current,
> -                                                intr ? kvm_perf_overflow_intr :
>                                                  kvm_perf_overflow, pmc);

Not your change, but if the event is counting anything based on
cycles, and the guest TSC is scaled to run at a different rate from
the host TSC, doesn't the initial value of the underlying hardware
counter have to be adjusted as well, so that the interrupt arrives
when the guest's counter overflows rather than when the host's counter
overflows?

Reviewed-by: Jim Mattson <jmattson@google.com>
