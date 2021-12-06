Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77E8446A669
	for <lists+kvm@lfdr.de>; Mon,  6 Dec 2021 20:58:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349407AbhLFUBh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Dec 2021 15:01:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349384AbhLFUBQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Dec 2021 15:01:16 -0500
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16B14C061359
        for <kvm@vger.kernel.org>; Mon,  6 Dec 2021 11:57:47 -0800 (PST)
Received: by mail-oi1-x236.google.com with SMTP id o4so23456312oia.10
        for <kvm@vger.kernel.org>; Mon, 06 Dec 2021 11:57:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jbBHUPqR54Dy0DlOS9ggORrsNroBBSSX6XeVYdFB7a0=;
        b=fSD6VHl4PkrWQARoVINFJCrESQI7f2ChelqE+dR7lDz7s+vehOy0Ovc5gM8TTsvilT
         b3rYGylzUkCYWqpLuCyLhY/suprvJEoincOg5DQ0YwGDDc4ABZVxTXUP8Kz+i5zvchEX
         y9JxZsZfWeXBwNbJRLMYVIEmUy8inu8rkRMZDtT95ahC1wWEJvW37JznerGBsxa9en4z
         dt6+c//Yx8zs1FfllB+SRvOkClsGGDGXypPxKURoD2qcIyPEgyGJ5DIhfTcWN+CYxhcV
         DpJdqm8No+una2xSvsUR+0jezq+yGeBZc0fr8Di3krn63q7+wdNQRqaLUbXrmGmFFvgz
         HlDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jbBHUPqR54Dy0DlOS9ggORrsNroBBSSX6XeVYdFB7a0=;
        b=pIKhb7bjy+U8Y2ZSxtREyB/VW74fVvLsA+L4531ApExR8pSH9uCQght0Yot9zMMdZS
         ark9KVQT/iJuhyFyV9cB4VNDHj4zeGhHzY0W7vr/UrY8nOEzhh/PpC6bljV+oWcptpBo
         tE1+Etx3XP91vD4qaTXqxOWgYeSAwwW08xzEIR4rnMqxv1sEipJyiFvNBgVuGnyT6fy0
         fHCnssoiHGfxa8JJ1QooCnCsr8vAiJgTOxASMI/ZVOha1ERKz2q0nNPkVNApFkxFnlb/
         PDipgIlxOpYegbVvKFg4p4aV4mK+EhXx5/O1YQizfGRdB7SuZWrIfXSZSuShKbT5c7F7
         9f0Q==
X-Gm-Message-State: AOAM5305udYP3UQ3mhZPC7OUKZiWCtGkf67be1Nj6Qz7UVS1W+GdDeZc
        YFCK38ShmoYjn+u3ep2DFqtYGLvgGVbcE2z/l+dv9g==
X-Google-Smtp-Source: ABdhPJz10lhnUuItfX5WFfe/4TnkUHNSTr34xSYiQFwsN/YOhae9r2KyJxNXolvl/4UqKUSg6Z03kuUSIHG0hrVbf8M=
X-Received: by 2002:a05:6808:1aa8:: with SMTP id bm40mr762330oib.38.1638820666161;
 Mon, 06 Dec 2021 11:57:46 -0800 (PST)
MIME-Version: 1.0
References: <20211130074221.93635-1-likexu@tencent.com> <20211130074221.93635-2-likexu@tencent.com>
In-Reply-To: <20211130074221.93635-2-likexu@tencent.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 6 Dec 2021 11:57:35 -0800
Message-ID: <CALMp9eT05nb56b16KkybvGSTYMhkRusQnNL4aWFU8tsets0O2w@mail.gmail.com>
Subject: Re: [PATCH v2 1/6] KVM: x86/pmu: Setup pmc->eventsel for fixed PMCs
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
> The current pmc->eventsel for fixed counter is underutilised. The
> pmc->eventsel can be setup for all known available fixed counters
> since we have mapping between fixed pmc index and
> the intel_arch_events array.
>
> Either gp or fixed counter, it will simplify the later checks for
> consistency between eventsel and perf_hw_id.
>
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>  arch/x86/kvm/vmx/pmu_intel.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 1b7456b2177b..b7ab5fd03681 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -459,6 +459,21 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>         return 1;
>  }
>
> +static void setup_fixed_pmc_eventsel(struct kvm_pmu *pmu)
> +{
> +       size_t size = ARRAY_SIZE(fixed_pmc_events);
> +       struct kvm_pmc *pmc;
> +       u32 event;
> +       int i;
> +
> +       for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
> +               pmc = &pmu->fixed_counters[i];
> +               event = fixed_pmc_events[array_index_nospec(i, size)];
How do we know that i < size? For example, Ice Lake supports 4 fixed
counters, but fixed_pmc_events only has three entries.
> +               pmc->eventsel = (intel_arch_events[event].unit_mask << 8) |
> +                       intel_arch_events[event].eventsel;
> +       }
> +}
> +
[Every now and then, gmail likes to revert your plain text setting,
just to keep you on your toes!]
