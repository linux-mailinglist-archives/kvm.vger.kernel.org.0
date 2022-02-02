Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 810D04A6B7C
	for <lists+kvm@lfdr.de>; Wed,  2 Feb 2022 06:27:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244486AbiBBF1w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 00:27:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232655AbiBBF1v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 00:27:51 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B77EFC06173B
        for <kvm@vger.kernel.org>; Tue,  1 Feb 2022 21:27:50 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id c19so28857236ybf.2
        for <kvm@vger.kernel.org>; Tue, 01 Feb 2022 21:27:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FpdlcATHwn/rfKFDtne5ENLKuwqb1eKCCdvZgvcQCcU=;
        b=Sqyh0E/5/s0IQlZvqN3bWN0cK9UIttG1WTXXCK60cKUgqo8BJALbr5NsV5GDPh06YM
         dJ5ebL/iJQ/0wJH++YsPk5tZigU6fURSpD0LSrgIm3P1LOa9MxKIROTsNAWUdQ0IHwvv
         yHCiAIaGdkVxoT844Tk1CtBGUMclR+7AGGvH//uQgJvgmUePXLY8RUjfb/S4W0BBIj7+
         nG6rHA6C7nyrJWamvGfF7cnAula5VTFf3+aqgPAkoaCWAunslrsTlS6DynJjdnBI/2sp
         9Zw5VRanaLzLx/hIpDCl+H8pmHPwh8ujUARegG9ugOI08EGk07UXl3Vh0hyJy1dx7s0m
         BNnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FpdlcATHwn/rfKFDtne5ENLKuwqb1eKCCdvZgvcQCcU=;
        b=smbxbcPtXj7RgnfZ/k7Ik1418mk4EzOQaROh059u7HVo7bFiVgdJrbKAO6Ruv8FrKs
         UDfDcBAkZX1xcQ3Lr13rLEd+7yexDnfcfdrRdEvwi2nLYooNPE6rdXK3luayVOCdqxlA
         FSSw9qr4WO44PEy+EwAPdY+0hh8gMaWDkXLalmXfrhYOGfD2NX9F0tuDRCB4IbU9v7ai
         VpaIjzfzdOpEG+moKzI8TTgva5FnRSC/jEoggthSJdOANXzKSuB5RTt7tw2WVnZ5sspY
         G4ht/5/ZKz6EDIZKtXYo/+o6iqYwYZpfsTxcaZq5iQh4HPEC/eDrsK6kfXRrwSB9MPYc
         4n8Q==
X-Gm-Message-State: AOAM53192hAin8iOjMmrrY5Q2jc2sedn+Rr3kIQ0xyx511J55l5aZqeS
        GE2k+HzSAuwpP+c/OuDNUlAFeFd2Zs9cO3wnA6q7ow==
X-Google-Smtp-Source: ABdhPJyPuD6BSJXHthWEh/ZtwATRbyUoshXAgjjeecMRyu6Z5ANBmQZALMCxZ3amXWh/62scng506zu3HUE9IotK3Qg=
X-Received: by 2002:a5b:b84:: with SMTP id l4mr40554508ybq.665.1643779669160;
 Tue, 01 Feb 2022 21:27:49 -0800 (PST)
MIME-Version: 1.0
References: <20220117055703.52020-1-likexu@tencent.com> <20220202042838.6532-1-ravi.bangoria@amd.com>
In-Reply-To: <20220202042838.6532-1-ravi.bangoria@amd.com>
From:   Stephane Eranian <eranian@google.com>
Date:   Tue, 1 Feb 2022 21:27:37 -0800
Message-ID: <CABPqkBQOSc=bwLdieBAX-sJ0Z+KwaxE=4PGXuuyzWyyZKf2ODg@mail.gmail.com>
Subject: Re: [PATCH] perf/amd: Implement errata #1292 workaround for F19h M00-0Fh
To:     Ravi Bangoria <ravi.bangoria@amd.com>
Cc:     like.xu.linux@gmail.com, jmattson@google.com,
        santosh.shukla@amd.com, pbonzini@redhat.com, seanjc@google.com,
        wanpengli@tencent.com, vkuznets@redhat.com, joro@8bytes.org,
        peterz@infradead.org, mingo@redhat.com,
        alexander.shishkin@linux.intel.com, tglx@linutronix.de,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        kvm@vger.kernel.org, x86@kernel.org,
        linux-perf-users@vger.kernel.org, ananth.narayan@amd.com,
        kim.phillips@amd.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 1, 2022 at 8:29 PM Ravi Bangoria <ravi.bangoria@amd.com> wrote:
>
> Perf counter may overcount for a list of Retire Based Events. Implement
> workaround for Zen3 Family 19 Model 00-0F processors as suggested in
> Revision Guide[1]:
>
>   To count the non-FP affected PMC events correctly:
>     o Use Core::X86::Msr::PERF_CTL2 to count the events, and
>     o Program Core::X86::Msr::PERF_CTL2[43] to 1b, and
>     o Program Core::X86::Msr::PERF_CTL2[20] to 0b.
>
> Above workaround suggests to clear PERF_CTL2[20], but that will disable
> sampling mode. Given the fact that, there is already a skew between
> actual counter overflow vs PMI hit, we are anyway not getting accurate
> count for sampling events. Also, using PMC2 with both bit43 and bit20
> set can result in additional issues. Hence Linux implementation of
> workaround uses non-PMC2 counter for sampling events.
>
Something is missing from your description here. If you are not
clearing bit[20] and
not setting bit[43], then how does running on CTL2 by itself improve
the count. Is that
enough to make the counter count correctly?

For sampling events, your patch makes CTL2 not available. That seems
to contradict the
workaround. Are you doing this to free CTL2 for counting mode events
instead? If you are
not using CTL2, then you are not correcting the count. Are you saying
this is okay in sampling mode
because of the skid, anyway?

> Although the issue exists on all previous Zen revisions, the workaround
> is different and thus not included in this patch.
>
> This patch needs Like's patch[2] to make it work on kvm guest.
>
> [1] https://bugzilla.kernel.org/attachment.cgi?id=298241
> [2] https://lore.kernel.org/lkml/20220117055703.52020-1-likexu@tencent.com
>
> Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
> ---
>  arch/x86/events/amd/core.c | 75 +++++++++++++++++++++++++++++++++++++-
>  1 file changed, 74 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/events/amd/core.c b/arch/x86/events/amd/core.c
> index 9687a8aef01c..e2f172e75ce8 100644
> --- a/arch/x86/events/amd/core.c
> +++ b/arch/x86/events/amd/core.c
> @@ -874,8 +874,78 @@ amd_get_event_constraints_f15h(struct cpu_hw_events *cpuc, int idx,
>         }
>  }
>
> +/* Errata 1292: Overcounting of Retire Based Events */
> +static struct event_constraint retire_event_count_constraints[] __read_mostly = {
> +       EVENT_CONSTRAINT(0xC0, 0x4, AMD64_EVENTSEL_EVENT),
> +       EVENT_CONSTRAINT(0xC1, 0x4, AMD64_EVENTSEL_EVENT),
> +       EVENT_CONSTRAINT(0xC2, 0x4, AMD64_EVENTSEL_EVENT),
> +       EVENT_CONSTRAINT(0xC3, 0x4, AMD64_EVENTSEL_EVENT),
> +       EVENT_CONSTRAINT(0xC4, 0x4, AMD64_EVENTSEL_EVENT),
> +       EVENT_CONSTRAINT(0xC5, 0x4, AMD64_EVENTSEL_EVENT),
> +       EVENT_CONSTRAINT(0xC8, 0x4, AMD64_EVENTSEL_EVENT),
> +       EVENT_CONSTRAINT(0xC9, 0x4, AMD64_EVENTSEL_EVENT),
> +       EVENT_CONSTRAINT(0xCA, 0x4, AMD64_EVENTSEL_EVENT),
> +       EVENT_CONSTRAINT(0xCC, 0x4, AMD64_EVENTSEL_EVENT),
> +       EVENT_CONSTRAINT(0xD1, 0x4, AMD64_EVENTSEL_EVENT),
> +       EVENT_CONSTRAINT(0x1000000C7, 0x4, AMD64_EVENTSEL_EVENT),
> +       EVENT_CONSTRAINT(0x1000000D0, 0x4, AMD64_EVENTSEL_EVENT),
> +       EVENT_CONSTRAINT_END
> +};
> +
> +#define SAMPLE_IDX_MASK        (((1ULL << AMD64_NUM_COUNTERS_CORE) - 1) & ~0x4ULL)
> +
> +static struct event_constraint retire_event_sample_constraints[] __read_mostly = {
> +       EVENT_CONSTRAINT(0xC0, SAMPLE_IDX_MASK, AMD64_EVENTSEL_EVENT),
> +       EVENT_CONSTRAINT(0xC0, SAMPLE_IDX_MASK, AMD64_EVENTSEL_EVENT),
> +       EVENT_CONSTRAINT(0xC1, SAMPLE_IDX_MASK, AMD64_EVENTSEL_EVENT),
> +       EVENT_CONSTRAINT(0xC2, SAMPLE_IDX_MASK, AMD64_EVENTSEL_EVENT),
> +       EVENT_CONSTRAINT(0xC3, SAMPLE_IDX_MASK, AMD64_EVENTSEL_EVENT),
> +       EVENT_CONSTRAINT(0xC4, SAMPLE_IDX_MASK, AMD64_EVENTSEL_EVENT),
> +       EVENT_CONSTRAINT(0xC5, SAMPLE_IDX_MASK, AMD64_EVENTSEL_EVENT),
> +       EVENT_CONSTRAINT(0xC8, SAMPLE_IDX_MASK, AMD64_EVENTSEL_EVENT),
> +       EVENT_CONSTRAINT(0xC9, SAMPLE_IDX_MASK, AMD64_EVENTSEL_EVENT),
> +       EVENT_CONSTRAINT(0xCA, SAMPLE_IDX_MASK, AMD64_EVENTSEL_EVENT),
> +       EVENT_CONSTRAINT(0xCC, SAMPLE_IDX_MASK, AMD64_EVENTSEL_EVENT),
> +       EVENT_CONSTRAINT(0xD1, SAMPLE_IDX_MASK, AMD64_EVENTSEL_EVENT),
> +       EVENT_CONSTRAINT(0x1000000C7, SAMPLE_IDX_MASK, AMD64_EVENTSEL_EVENT),
> +       EVENT_CONSTRAINT(0x1000000D0, SAMPLE_IDX_MASK, AMD64_EVENTSEL_EVENT),
> +       EVENT_CONSTRAINT_END
> +};
> +
>  static struct event_constraint pair_constraint;
>
> +/*
> + * Although 'Overcounting of Retire Based Events' errata exists
> + * for older generation cpus, workaround to set bit 43 works only
> + * for Family 19h Model 00-0Fh as per the Revision Guide.
> + */
> +static struct event_constraint *
> +amd_get_event_constraints_f19h_m00_0fh(struct cpu_hw_events *cpuc, int idx,
> +                                      struct perf_event *event)
> +{
> +       struct event_constraint *c;
> +
> +       if (amd_is_pair_event_code(&event->hw))
> +               return &pair_constraint;
> +
> +       if (is_sampling_event(event)) {
> +               for_each_event_constraint(c, retire_event_sample_constraints) {
> +                       if (constraint_match(c, event->hw.config))
> +                               return c;
> +               }
> +       } else {
> +               for_each_event_constraint(c, retire_event_count_constraints) {
> +                       if (constraint_match(c, event->hw.config)) {
> +                               event->hw.config |= (1ULL << 43);
> +                               event->hw.config &= ~(1ULL << 20);
> +                               return c;
> +                       }
> +               }
> +       }
> +
> +       return &unconstrained;
> +}
> +
>  static struct event_constraint *
>  amd_get_event_constraints_f17h(struct cpu_hw_events *cpuc, int idx,
>                                struct perf_event *event)
> @@ -983,7 +1053,10 @@ static int __init amd_core_pmu_init(void)
>                                     x86_pmu.num_counters / 2, 0,
>                                     PERF_X86_EVENT_PAIR);
>
> -               x86_pmu.get_event_constraints = amd_get_event_constraints_f17h;
> +               if (boot_cpu_data.x86 == 0x19 && boot_cpu_data.x86_model <= 0xf)
> +                       x86_pmu.get_event_constraints = amd_get_event_constraints_f19h_m00_0fh;
> +               else
> +                       x86_pmu.get_event_constraints = amd_get_event_constraints_f17h;
>                 x86_pmu.put_event_constraints = amd_put_event_constraints_f17h;
>                 x86_pmu.perf_ctr_pair_en = AMD_MERGE_EVENT_ENABLE;
>                 x86_pmu.flags |= PMU_FL_PAIR;
> --
> 2.27.0
>
