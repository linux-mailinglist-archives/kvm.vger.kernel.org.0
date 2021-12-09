Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE6D846E15D
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 04:52:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231641AbhLID4F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 22:56:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231622AbhLID4F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Dec 2021 22:56:05 -0500
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75B69C0617A1
        for <kvm@vger.kernel.org>; Wed,  8 Dec 2021 19:52:32 -0800 (PST)
Received: by mail-ot1-x32b.google.com with SMTP id n17-20020a9d64d1000000b00579cf677301so4910868otl.8
        for <kvm@vger.kernel.org>; Wed, 08 Dec 2021 19:52:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Z8cA1QeqQc7EfuUC545t2sn7dL7R+spTbdugX4U+UAQ=;
        b=qam1aVBBSI0qxZImLufyNs8xB/xY5xdA1/OIuFLrhv2i4hf+i84hXOlYg998AxVM0Y
         4kr/WfPfxG+fHJsmdaNxnaOeZjZdtuWNeltfRK9/PmT5HTCW3z+9iNRzQ7i4CSHrFDK/
         1UoU7Y6tO3ltx27BcHvm1iKTxI6Z+wv2CMcUyJ6uiFDitEMjfdDGgC+AHXyvo05pSnbH
         seqIASNz4YszfwOGbKr26Sbhpw8j6tig4ktmJhh0sPfU6DfjXEM1XgRoGZ5L7WUItA3C
         5GCQd0d/AFCWXlFhLcZuBX+OkpE6OUYHoJncT8Fc4+RZU61RMTuShCZ0i5hi4KFpTeTm
         w8/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z8cA1QeqQc7EfuUC545t2sn7dL7R+spTbdugX4U+UAQ=;
        b=HwLgfERqA8YD+9LPkxgL+R1rNQUqZATk6YuBS+FawZ/ANP0gN4YNEt93ipFinsZ9Lm
         nyFKkHBpcZWM82EgDe/MkOpxoXsEYPqn3nPG8PDrs6JwFg+g+NCnNj0/S5rw/qo0vkMu
         SK+M8RgHMvm8fsn4Mcc4A/RWNyjW4Md6Mcak9DbYeMi9m8BxL4Y/VozQ9RBse8Ip87Xa
         BqN4eCxkWAuLAtWHZrfKb+X67f36FUxYT4glBclzmu8tL2sW4NOAvY+usvBHOgEYo7JX
         Omo3W3UYdSPRdOVKFzCIRVzvKYxJZxLmyy55rjy2gTUuJAcPRXaWsMKawnlUUELjRsKh
         L8rg==
X-Gm-Message-State: AOAM530uYoHAxiKvc2uOYVoEAliPrfGxOd1njten1Ar37R7nekU5hyVL
        EMe+otqaFxZgvhEem7x1DrjCgZdkQJuz+v9S3evYSw==
X-Google-Smtp-Source: ABdhPJyPp+/EIeqUceUL4FRahMG/SspUq7Z5DH68P5bB7G5jpEFrB+0AWYsznSK5t6C59UKGO6R7MD8BxuJBsbk6/0E=
X-Received: by 2002:a05:6830:1417:: with SMTP id v23mr3302610otp.367.1639021951362;
 Wed, 08 Dec 2021 19:52:31 -0800 (PST)
MIME-Version: 1.0
References: <20211130074221.93635-1-likexu@tencent.com> <20211130074221.93635-3-likexu@tencent.com>
In-Reply-To: <20211130074221.93635-3-likexu@tencent.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 8 Dec 2021 19:52:20 -0800
Message-ID: <CALMp9eRaZBftkaFsmfH8V519QdSGKTORp0OAZ2WaNi3f9X=tng@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] KVM: x86/pmu: Refactoring find_arch_event() to pmc_perf_hw_id()
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
> The find_arch_event() returns a "unsigned int" value,
> which is used by the pmc_reprogram_counter() to
> program a PERF_TYPE_HARDWARE type perf_event.
>
> The returned value is actually the kernel defined generic

Typo: generic.

> perf_hw_id, let's rename it to pmc_perf_hw_id() with simpler
> incoming parameters for better self-explanation.
>
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>  arch/x86/kvm/pmu.c           | 8 +-------
>  arch/x86/kvm/pmu.h           | 3 +--
>  arch/x86/kvm/svm/pmu.c       | 8 ++++----
>  arch/x86/kvm/vmx/pmu_intel.c | 9 +++++----
>  4 files changed, 11 insertions(+), 17 deletions(-)
>
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 09873f6488f7..3b3ccf5b1106 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -174,7 +174,6 @@ static bool pmc_resume_counter(struct kvm_pmc *pmc)
>  void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
>  {
>         unsigned config, type = PERF_TYPE_RAW;
> -       u8 event_select, unit_mask;
>         struct kvm *kvm = pmc->vcpu->kvm;
>         struct kvm_pmu_event_filter *filter;
>         int i;
> @@ -206,17 +205,12 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
>         if (!allow_event)
>                 return;
>
> -       event_select = eventsel & ARCH_PERFMON_EVENTSEL_EVENT;
> -       unit_mask = (eventsel & ARCH_PERFMON_EVENTSEL_UMASK) >> 8;
> -
>         if (!(eventsel & (ARCH_PERFMON_EVENTSEL_EDGE |
>                           ARCH_PERFMON_EVENTSEL_INV |
>                           ARCH_PERFMON_EVENTSEL_CMASK |
>                           HSW_IN_TX |
>                           HSW_IN_TX_CHECKPOINTED))) {

The mechanics of the change look fine, but I do have some questions,
for my own understanding.

Why don't we just use PERF_TYPE_RAW for guest counters all of the
time? What is the advantage of matching entries in a table so that we
can use PERF_TYPE_HARDWARE?

Why do the HSW_IN_TX* bits result in bypassing this clause, when these
bits are extracted as arguments to pmc_reprogram_counter below?

Reviewed-by: Jim Mattson <jmattson@google.com>
