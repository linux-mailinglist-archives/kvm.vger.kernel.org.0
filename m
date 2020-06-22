Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B884F2040F8
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 22:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728664AbgFVUFx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 16:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730171AbgFVUFv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 16:05:51 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39CCFC061573
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 13:05:51 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id o5so20966488iow.8
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 13:05:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=myegs1cvQAwzoWob6wl1gcWYjFT2LLk+X2d0y3lld9s=;
        b=nWVa1eCk5Rb2WLUY2DCBT17TsVK7YxcpyeOcImgaG2Wzy+xTPoGEIeECHdRi+OLgO/
         F34ND5XO4hMaBcCTdD7ci0TDcdz+BH7zgdCTNrltSM6ev7RKkpy/FGyu5ndSLCF1E6iT
         P2F6jRfoMJhW5CgFmME+KEeWCYX6gni8qhxvZrH4bRjhlht8cqAW6pPmhc6i1jhY9bMN
         9YfBCUZsO9y6eK9jsgvH1Bh3fNFoslP9JwyubaCPVceEjcbVwXfgM/wQtiVHYVLj0FFZ
         rDcJ4vgNMseuPKfYMOVLsrx1NAPlpWLxR38fWjumzbD5z8Ib0fdC430fbqbASs3GBhOu
         rKhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=myegs1cvQAwzoWob6wl1gcWYjFT2LLk+X2d0y3lld9s=;
        b=NsouNuLia1dTs83ZbSArH4VLBHAE6myaISFSwJlh27JcEwoJCJJlufaCNYAjbaN9fW
         SEvFwpjYgufd5SBMzgiOSuYu9BETcn6fmGBNyqJwqq6+EISgomgumNb/pL2dC2Dpdklm
         /Yz9abPrLiwfBNF2DopYImUu4xwLrk3Kw3KpEDc6CSNsvowudBNZsCXy0K0Yp77qZS16
         TQlNIT/05bk6WRdwPdSRpj0/n1OH1erEAZp4wvftuFPaIzjwaFEqgLgUz0MrTift14HN
         4ZcfG4l+HlwLGyx42WpalbgWy0F9DSAc8GtoWiBWO5W08DVQ0M0b6uMPlqu86mu/KcHx
         IfeQ==
X-Gm-Message-State: AOAM530JiU329++0FOP7TTgQbYGKyWuR0yWxm1aq6X4RaDeQz9j0K+6y
        IpZXSc3+2tWgadSl+10WOG2vcUc570I4zTK9zwtoO+zT
X-Google-Smtp-Source: ABdhPJwpDHlstDGtro2UQ1jF5zAxCUwKG8PMSmmQH0wxiQFs2/dGVjB97ZH4l8HI6G7oAeu5XKrR8p12TRjLzF/pcvU=
X-Received: by 2002:a6b:7210:: with SMTP id n16mr687222ioc.177.1592856350031;
 Mon, 22 Jun 2020 13:05:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200615230750.105008-1-jmattson@google.com>
In-Reply-To: <20200615230750.105008-1-jmattson@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 22 Jun 2020 13:05:38 -0700
Message-ID: <CALMp9eTmbh265VDP0EZMxzakLjtvOt=zD0+4dVMmdxwsZ7MBGw@mail.gmail.com>
Subject: Re: [PATCH 1/2] kvm: x86: Refine kvm_write_tsc synchronization generations
To:     kvm list <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Peter Shier <pshier@google.com>, Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 15, 2020 at 4:07 PM Jim Mattson <jmattson@google.com> wrote:
>
> Start a new TSC synchronization generation whenever the
> IA32_TIME_STAMP_COUNTER MSR is written on a vCPU that has already
> participated in the current TSC synchronization generation.
>
> Previously, it was not possible to restore the IA32_TIME_STAMP_COUNTER
> MSR to a value less than the TSC frequency. Since vCPU initialization
> sets the IA32_TIME_STAMP_COUNTER MSR to zero, a subsequent
> KVM_SET_MSRS ioctl that attempted to write a small value to the
> IA32_TIME_STAMP_COUNTER MSR was viewed as an attempt at TSC
> synchronization. Notably, this was the case even for single vCPU VMs,
> which were always synchronized.
>
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> Reviewed-by: Oliver Upton <oupton@google.com>
> ---
>  arch/x86/kvm/x86.c | 13 +++++--------
>  1 file changed, 5 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 9e41b5135340..2555ea2cd91e 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2015,7 +2015,6 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu, struct msr_data *msr)
>         u64 offset, ns, elapsed;
>         unsigned long flags;
>         bool matched;
> -       bool already_matched;
>         u64 data = msr->data;
>         bool synchronizing = false;
>
> @@ -2032,7 +2031,8 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu, struct msr_data *msr)
>                          * kvm_clock stable after CPU hotplug
>                          */
>                         synchronizing = true;
> -               } else {
> +               } else if (vcpu->arch.this_tsc_generation !=
> +                          kvm->arch.cur_tsc_generation) {
>                         u64 tsc_exp = kvm->arch.last_tsc_write +
>                                                 nsec_to_cycles(vcpu, elapsed);
>                         u64 tsc_hz = vcpu->arch.virtual_tsc_khz * 1000LL;
> @@ -2062,7 +2062,6 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu, struct msr_data *msr)
>                         offset = kvm_compute_tsc_offset(vcpu, data);
>                 }
>                 matched = true;
> -               already_matched = (vcpu->arch.this_tsc_generation == kvm->arch.cur_tsc_generation);
>         } else {
>                 /*
>                  * We split periods of matched TSC writes into generations.
> @@ -2102,12 +2101,10 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu, struct msr_data *msr)
>         raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
>
>         spin_lock(&kvm->arch.pvclock_gtod_sync_lock);
> -       if (!matched) {
> -               kvm->arch.nr_vcpus_matched_tsc = 0;
> -       } else if (!already_matched) {
> +       if (matched)
>                 kvm->arch.nr_vcpus_matched_tsc++;
> -       }
> -
> +       else
> +               kvm->arch.nr_vcpus_matched_tsc = 0;
>         kvm_track_tsc_matching(vcpu);
>         spin_unlock(&kvm->arch.pvclock_gtod_sync_lock);
>  }
> --
> 2.27.0.290.gba653c62da-goog
>
Ping.
