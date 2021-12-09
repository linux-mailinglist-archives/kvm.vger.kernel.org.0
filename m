Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E844646F373
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 19:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbhLIS51 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 13:57:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbhLIS50 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 13:57:26 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F38AAC061746
        for <kvm@vger.kernel.org>; Thu,  9 Dec 2021 10:53:52 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id n8so4586625plf.4
        for <kvm@vger.kernel.org>; Thu, 09 Dec 2021 10:53:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xc44ZklCg5UoNNLNLpFLy7GdML2BOUr1C3pTi32Bai4=;
        b=ozoUWgtEHYnTfUONr6Xqbyh26TH89vjBDDqiYRJAv0Z0jRXMvg6JNzxuTEmHkJtQlX
         yIQ/gd5vMAN+J9x23UiGMWNpQxxx3lEDuC7yk0D+FKB4bTT+iLsom6qM2Tu0c2W1eiwj
         wTuDP8KOcnPKfxc8el4yeXxnryehPGdzEkuOvyQePr29qNh5/6rk17x6F10Upg4AW641
         R4G6Oc+dBWJBHtouTKFAUqbNAJFBvUSrv8ROKKXLXgQtWTl5TcC+5y9pJK3YKJNNQcYb
         sz77ojQoXVpl/nzCfeT6FVC15j/0/4sHk9RnIr8fezwMZe1XffJwpR9UGROaKjUlJmzV
         mByA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xc44ZklCg5UoNNLNLpFLy7GdML2BOUr1C3pTi32Bai4=;
        b=tLrzJFqtEwsKgDFLxm4XTODeVJCt60E3f3pStVUqQTPG8e7UqToufvTtc6tes+E2EV
         6W3+YOTmsjLUbFhjb69WC/anSrMGYyiNeC5NhPGjN8yYwzg1Y66CPEhzTMBVMzQsw7iR
         Qe/FS3SZ+4lPgmTOVrv5pBTkhCYp4ZP7N1qB4FBB6ip52PpTIux8MFuofwOTW0Gyjc4E
         sWNW0UfMRPKDvuNHJfWzfUf8IqzSxLCS8jOFLPrZkcPbnJKakN8OykP6jLGNqkpovY9h
         SjH0wtLsqp0rA0EL2c8f7N6v+I/TkILxT1px5IGcCPZ8Hb2FjFbLNzuIRy6Y0QAMyOVJ
         TeDw==
X-Gm-Message-State: AOAM530pm9qpEQrnd3wVfT9Vdd/kotc49CzxXsR9576ikWy5DduYYtD5
        M6g0DcCfPxLgYXHKuM0hnLLr8T72cozZ/rElJvuifQ==
X-Google-Smtp-Source: ABdhPJxM6cDLdCyxLxONxkUDQXqA1xBozoXxY6VIhxiHEAvAHULmUaVCW3qxiXcZVRJlp3NmRd+5FaXNbu8bmZxF/KU=
X-Received: by 2002:a17:90a:d684:: with SMTP id x4mr18189669pju.244.1639076032229;
 Thu, 09 Dec 2021 10:53:52 -0800 (PST)
MIME-Version: 1.0
References: <20211130074221.93635-1-likexu@tencent.com> <20211130074221.93635-2-likexu@tencent.com>
 <CALMp9eT05nb56b16KkybvGSTYMhkRusQnNL4aWFU8tsets0O2w@mail.gmail.com> <8ca78cd6-12ad-56c4-ad73-e88757364ba9@redhat.com>
In-Reply-To: <8ca78cd6-12ad-56c4-ad73-e88757364ba9@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 9 Dec 2021 10:53:40 -0800
Message-ID: <CALMp9eR-eniyvu_zsqUHidoDX9V=eAA2zJXKPHdUT6SOY+EQrA@mail.gmail.com>
Subject: Re: [PATCH v2 1/6] KVM: x86/pmu: Setup pmc->eventsel for fixed PMCs
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Like Xu <like.xu.linux@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 9, 2021 at 10:49 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 12/6/21 20:57, Jim Mattson wrote:
> >> +
> >> +       for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
> >> +               pmc = &pmu->fixed_counters[i];
> >> +               event = fixed_pmc_events[array_index_nospec(i, size)];
> > How do we know that i < size? For example, Ice Lake supports 4 fixed
> > counters, but fixed_pmc_events only has three entries.
>
> We don't, and it's a preexisting bug in intel_pmu_refresh.  Either we hack around it like
>
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 1b7456b2177b..6f03c8bf1bc2 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -500,8 +500,9 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>                 pmu->nr_arch_fixed_counters = 0;
>         } else {
>                 pmu->nr_arch_fixed_counters =
> -                       min_t(int, edx.split.num_counters_fixed,
> -                             x86_pmu.num_counters_fixed);
> +                       min3(ARRAY_SIZE(fixed_pmc_events),
> +                            (size_t) edx.split.num_counters_fixed,
> +                            (size_t) x86_pmu.num_counters_fixed);
>                 edx.split.bit_width_fixed = min_t(int,
>                         edx.split.bit_width_fixed, x86_pmu.bit_width_fixed);
>                 pmu->counter_bitmask[KVM_PMC_FIXED] =
>
> or we modify find_fixed_event and its caller to support PERF_TYPE_RAW
> counters, and then add support for the IceLake TOPDOWN.SLOTS fixed
> counter.
>
> What's your preference?

As Like points out, KVM_GET_SUPPORTED_CPUID indicates that only three
fixed counters are supported. So, per the KVM contract, if userspace
configures four in the guest cpuid info, all bets are off. I don't
like that contract, but changing it means introducing KVM_SET_CPUID3.
:-)
