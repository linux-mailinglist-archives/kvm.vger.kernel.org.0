Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 021DB46E179
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 05:33:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231874AbhLIEgq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 23:36:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231753AbhLIEgp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Dec 2021 23:36:45 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74AD4C061746
        for <kvm@vger.kernel.org>; Wed,  8 Dec 2021 20:33:12 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id n104-20020a9d2071000000b005799790cf0bso4989780ota.5
        for <kvm@vger.kernel.org>; Wed, 08 Dec 2021 20:33:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QHuibgPSAspfNqssmkGKxfN9WyawKIpAxuzH4TjAp4c=;
        b=ftb1NLxmYizOc7C+dFz80X6ZjSx5PuoitZxHX+rTxeXtZRIWJiGMrsV2gLapjaDvNu
         JtDdCv7xYWqdmQjnhaRo4Yofp0yLN3IZlE3NMRGpxIIaowfNLNm7YP7H554nuiLzghEd
         PF7+IKZu/I7eMSb5fuKoVNLUJDZmYz+zABFIeCMwjNdFOpEbrRNdjfGOBmfdm/xPkww6
         oLpEpA8G+OCI1HeCRaixk8fF6FVNRhub2qsmC+BE4AvDMmWY58OYFk0vgDvxzBfINpGs
         m1y/g9HJSSlvx/Z/09yHYf9+15KoyGtfCzB1ymTndVdkynsS36MRRJ3nmcWhivshbcxF
         Ghvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QHuibgPSAspfNqssmkGKxfN9WyawKIpAxuzH4TjAp4c=;
        b=D4gNWO8Clvo4I9Pd02FIaZK41evwU4dGx7GZpxHQeF45APsjlpe2whXdAkP4Uq908w
         E1hLzWPVb83dn74UYZU9QpPvKs2jsnNrnNd2yXlvfsDgipVVPHtXZvsmLWmyIKBrSCxz
         N44S3eVaP2dNb7FvUIHL3/JyxvBwvpKupUIp39Bk0Z73xvrVnaUlViuQ+36H1t2mXzmf
         d6PyStO2S+8+Kfq8UHB2E5Irlq29XaNb/hDma33GbNoXbbZTOBALqXv7ELMzss2RFxSp
         WXCyZB86Cznu0DVO3xXjTa5hQcMC3S1IhEdWgChj7Lv6phrPBJDAC95hhXq2aLfpNp50
         YnZA==
X-Gm-Message-State: AOAM533YWfB7dtOfewhzPm7hFRCeqS7l8qSc23ha4Aw9y7+cCtUTtjKS
        UrLqJHHwseOWElZYckjQkBl8NKLQZEuYkoA4QReuRw==
X-Google-Smtp-Source: ABdhPJygm6XWr1fUVKwahGV+aHqAEbw3Vz4gXvO8CaJATTJMPgTxkI3rSjQXMl3mYqxD70mqneH2r9jgmaT2h98gPy0=
X-Received: by 2002:a9d:68ca:: with SMTP id i10mr3402796oto.286.1639024391535;
 Wed, 08 Dec 2021 20:33:11 -0800 (PST)
MIME-Version: 1.0
References: <20211130074221.93635-1-likexu@tencent.com> <20211130074221.93635-6-likexu@tencent.com>
In-Reply-To: <20211130074221.93635-6-likexu@tencent.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 8 Dec 2021 20:33:00 -0800
Message-ID: <CALMp9eQxW_0JBe_6doNTGLXHsXM_Y0YSfnrM1yqTumUQqg7A2A@mail.gmail.com>
Subject: Re: [PATCH v2 5/6] KVM: x86: Update vPMCs when retiring instructions
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 29, 2021 at 11:42 PM Like Xu <like.xu.linux@gmail.com> wrote:
>
> From: Like Xu <likexu@tencent.com>
>
> When KVM retires a guest instruction through emulation, increment any
> vPMCs that are configured to monitor "instructions retired," and
> update the sample period of those counters so that they will overflow
> at the right time.
>
> Signed-off-by: Eric Hankland <ehankland@google.com>
> [jmattson:
>   - Split the code to increment "branch instructions retired" into a
>     separate commit.
>   - Added 'static' to kvm_pmu_incr_counter() definition.
>   - Modified kvm_pmu_incr_counter() to check pmc->perf_event->state ==
>     PERF_EVENT_STATE_ACTIVE.
> ]
> Fixes: f5132b01386b ("KVM: Expose a version 2 architectural PMU to a guests")
> Signed-off-by: Jim Mattson <jmattson@google.com>
> [likexu:
>   - Drop checks for pmc->perf_event or event state or event type
>   - Increase a counter once its umask bits and the first 8 select bits are matched
>   - Rewrite kvm_pmu_incr_counter() with a less invasive approach to the host perf;
>   - Rename kvm_pmu_record_event to kvm_pmu_trigger_event;
>   - Add counter enable and CPL check for kvm_pmu_trigger_event();
> ]
> Cc: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---

> +void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 perf_hw_id)
> +{
> +       struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> +       struct kvm_pmc *pmc;
> +       int i;
> +
> +       for_each_set_bit(i, pmu->all_valid_pmc_idx, X86_PMC_IDX_MAX) {
> +               pmc = kvm_x86_ops.pmu_ops->pmc_idx_to_pmc(pmu, i);
> +
> +               if (!pmc || !pmc_is_enabled(pmc) || !pmc_speculative_in_use(pmc))
> +                       continue;
> +
> +               /* Ignore checks for edge detect, pin control, invert and CMASK bits */

I don't understand how we can ignore these checks. Doesn't that
violate the architectural specification?

> +               if (eventsel_match_perf_hw_id(pmc, perf_hw_id) && cpl_is_matched(pmc))
> +                       kvm_pmu_incr_counter(pmc);
> +       }
> +}
> +EXPORT_SYMBOL_GPL(kvm_pmu_trigger_event);
> +
