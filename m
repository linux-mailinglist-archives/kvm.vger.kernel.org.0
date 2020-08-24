Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBCCA24F0E5
	for <lists+kvm@lfdr.de>; Mon, 24 Aug 2020 03:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727805AbgHXBZR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 Aug 2020 21:25:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725648AbgHXBZO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 Aug 2020 21:25:14 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9E0CC061573;
        Sun, 23 Aug 2020 18:25:12 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id v13so6853792oiv.13;
        Sun, 23 Aug 2020 18:25:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=788AuSD6gYxgp3PSjUlFHERXLi4yTjFMzx3S3/9M/l0=;
        b=LwRUo99ox3g3Ff3QgMVOlvu6yrh6AzLggfLo0C1JLdq2C9EHuCtJILQy/VW0CQ4yiA
         Psyz97BcHz1teFxt8KiNrm699yYgDtajl2cNiFDtbZuzRQ6JCwLaOELGrjQH9EQW6r26
         JI8/EMVXn9tfs6wp6hPxq4jwmkyFog+lfzaV00RcOQPuZzCwKyfuTTT9L1e67RMr93YI
         c8u+1zPmhLyZSpxa/vJSae4ZEaUNpwcf4u9ItFNTKUl/tkyt3NRuNvCpxksIl2hwUZ22
         XCRaIBpP4NK0/sQGdZYhNVuDkl1p9SFmhjUR+44tNfk3nTmI7vPmCgCG9Ro6NGZvFzru
         eNjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=788AuSD6gYxgp3PSjUlFHERXLi4yTjFMzx3S3/9M/l0=;
        b=gJKT7/F+n481op0baSoqEi1MjAPZ8VLrDhREaa6or7hEyDErPgBouMppStTw7gF7fV
         HrhH0HvcPOKCOlhQT/SeBqMD1L2GZ2tslGrwMaTk8KDLhXWzKxPnXE/ojfS9dSs2Ckq8
         mKNmr6rN1KZpNBgJ3nqsT+2yaqg88Pe4o8QSQX4/bgEnpNPukFeZX8LH+luC8eRaDw5F
         CAiAzQ+i5KkwGBFtm9NMFCpfXvOZUqUhPnslx1l/UljHr1RlyseSNE6Tml74lu/OmHFa
         sKZsLv/zWO/7zEK2jWCYXQGiW5MCkscJwqYA8gK3gqxkSR+Ip6A9juvI9Ram/KlvCJt+
         2lyg==
X-Gm-Message-State: AOAM533JK0RItI6TqSm07gZuIQ7PrxoY4K39XsSPD9BBQ+5wWXwEk+ZD
        EbbVM+EUEbuT2zXe40yFhHpJG8cEHLSieFw3BhUIT9Ft
X-Google-Smtp-Source: ABdhPJwGBPIXDyuyd4al8V7bERkQ5b+wxBcV6xY5xzTRvxpSNN6ouePY4tpAxjPAGdsbbnElclpUx9oCO91ClwZRyn0=
X-Received: by 2002:a05:6808:b:: with SMTP id u11mr1900633oic.33.1598232311974;
 Sun, 23 Aug 2020 18:25:11 -0700 (PDT)
MIME-Version: 1.0
References: <1597827327-25055-1-git-send-email-wanpengli@tencent.com>
In-Reply-To: <1597827327-25055-1-git-send-email-wanpengli@tencent.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Mon, 24 Aug 2020 09:25:01 +0800
Message-ID: <CANRm+Cx57G2mRLQ4=Kt+0f0K9Ls+vbfHdMb1No8hfyAb9xEpZQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: LAPIC: Fix updating DFR missing apic map recalculation
To:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

ping, :)
On Wed, 19 Aug 2020 at 16:55, Wanpeng Li <kernellwp@gmail.com> wrote:
>
> From: Wanpeng Li <wanpengli@tencent.com>
>
> There is missing apic map recalculation after updating DFR, if it is
> INIT RESET, in x2apic mode, local apic is software enabled before.
> This patch fix it by introducing the function kvm_apic_set_dfr() to
> be called in INIT RESET handling path.
>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/lapic.c | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 5ccbee7..248095a 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -310,6 +310,12 @@ static inline void kvm_apic_set_ldr(struct kvm_lapic *apic, u32 id)
>         atomic_set_release(&apic->vcpu->kvm->arch.apic_map_dirty, DIRTY);
>  }
>
> +static inline void kvm_apic_set_dfr(struct kvm_lapic *apic, u32 val)
> +{
> +       kvm_lapic_set_reg(apic, APIC_DFR, val);
> +       atomic_set_release(&apic->vcpu->kvm->arch.apic_map_dirty, DIRTY);
> +}
> +
>  static inline u32 kvm_apic_calc_x2apic_ldr(u32 id)
>  {
>         return ((id >> 4) << 16) | (1 << (id & 0xf));
> @@ -1984,10 +1990,9 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
>                 break;
>
>         case APIC_DFR:
> -               if (!apic_x2apic_mode(apic)) {
> -                       kvm_lapic_set_reg(apic, APIC_DFR, val | 0x0FFFFFFF);
> -                       atomic_set_release(&apic->vcpu->kvm->arch.apic_map_dirty, DIRTY);
> -               } else
> +               if (!apic_x2apic_mode(apic))
> +                       kvm_apic_set_dfr(apic, val | 0x0FFFFFFF);
> +               else
>                         ret = 1;
>                 break;
>
> @@ -2303,7 +2308,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
>                              SET_APIC_DELIVERY_MODE(0, APIC_MODE_EXTINT));
>         apic_manage_nmi_watchdog(apic, kvm_lapic_get_reg(apic, APIC_LVT0));
>
> -       kvm_lapic_set_reg(apic, APIC_DFR, 0xffffffffU);
> +       kvm_apic_set_dfr(apic, 0xffffffffU);
>         apic_set_spiv(apic, 0xff);
>         kvm_lapic_set_reg(apic, APIC_TASKPRI, 0);
>         if (!apic_x2apic_mode(apic))
> --
> 2.7.4
>
