Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E56F398983
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2019 04:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729610AbfHVCi0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Aug 2019 22:38:26 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:40124 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729253AbfHVCi0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Aug 2019 22:38:26 -0400
Received: by mail-ot1-f68.google.com with SMTP id c34so4061559otb.7;
        Wed, 21 Aug 2019 19:38:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=XoRcSwd9u1dvFquimROqhIpVJNTmoeWa7AHYkdDfXy8=;
        b=JT7F6QMxVN4B3wtJqxMSO5zxKG4hr3gpdGpQPuelpj4Tfy2rbnznaohv1N2plicN2F
         kQvp/q21vBlXRr9iMKiFRSdk2quEmy0kDA/51vNu6xcyt+zvn7sLdbiZP5rfcuPhJzQB
         TRb5hevivFa+GDuWRJNguiMZn/bnwD1EkhMk3LHzsPV941XhuXsIgDz7Rn4l9+ZYWxer
         3cQ/1Mcx5fE+s58uUuvl3rA0dov7v4ymQ629cDOlMq1IXJlp9fDeV9k07PjGY42zm6a0
         /M7xMmpWHHhci+8jNgpxxFdbKiP8607OrdkHGG4QDmLbZEJbCgU+nS+e07+YCaE6GWl0
         nEwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XoRcSwd9u1dvFquimROqhIpVJNTmoeWa7AHYkdDfXy8=;
        b=m5acmdQpd2+OeCb9ZvbmlhRiOsc5T8Db96sIZjBMQL7A4GE+DkoyFIqUessFHVZvk3
         bED7GZs+ptLT7suqQksOZTi5AOh7fmaArjGat+Z5iK2F95kUNGK4gNnAeWSd4NlVk9B8
         WpuOJpPPWGKD1dJ1SFG55nYPubqZdtOIlk/ULax8AeSClcAB8I0qCDI9+7sGBOVn4Y/y
         7jgXi92tEBseKL9+/A60zLN7DUfDL9+/8FfceNfFdzKBMTjgpSGwzf9xJJnWj0qZ/Lvj
         zeboQSmc32ZzbuzyC75AVU3YADqCq/H+1OL6BkLFsuVcRPQ+JjcKAhOGXn/684bRQER7
         UPJw==
X-Gm-Message-State: APjAAAW7/YdGpi23CQpbdAo+xzOx62O9RirxcC12h/iMdvi/w2Vgv0fH
        ozUX2a3rKH8Ymfp40PTGQg5yKICm/9AEreBIbZ01cw==
X-Google-Smtp-Source: APXvYqxDQSUlQ52MVbQ8uykZaNN2BmBN9SLuEeFvIjqAZXBe0MUJdoP4ZeBSj8C5v6TeF0g0L/+zkj4eEbFWcP6TgbI=
X-Received: by 2002:a05:6830:144b:: with SMTP id w11mr29690192otp.185.1566441504963;
 Wed, 21 Aug 2019 19:38:24 -0700 (PDT)
MIME-Version: 1.0
References: <1565841817-25982-1-git-send-email-wanpengli@tencent.com>
In-Reply-To: <1565841817-25982-1-git-send-email-wanpengli@tencent.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 22 Aug 2019 10:37:51 +0800
Message-ID: <CANRm+Cy1kUz_pMGGhvBYmk4EZ07nk5ocBVqigUKoU8-W=tM0RA@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: LAPIC: Periodically revaluate to get conservative lapic_timer_advance_ns
To:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

ping,
On Thu, 15 Aug 2019 at 12:03, Wanpeng Li <kernellwp@gmail.com> wrote:
>
> From: Wanpeng Li <wanpengli@tencent.com>
>
> Even if for realtime CPUs, cache line bounces, frequency scaling, presenc=
e
> of higher-priority RT tasks, etc can still cause different response. Thes=
e
> interferences should be considered and periodically revaluate whether
> or not the lapic_timer_advance_ns value is the best, do nothing if it is,
> otherwise recaluate again. Set lapic_timer_advance_ns to the minimal
> conservative value from all the estimated values.
>
> Testing on Skylake server, cat vcpu*/lapic_timer_advance_ns, before patch=
:
> 1628
> 4161
> 4321
> 3236
> ...
>
> Testing on Skylake server, cat vcpu*/lapic_timer_advance_ns, after patch:
> 1553
> 1499
> 1509
> 1489
> ...
>
> Testing on Haswell desktop, cat vcpu*/lapic_timer_advance_ns, before patc=
h:
> 4617
> 3641
> 4102
> 4577
> ...
> Testing on Haswell desktop, cat vcpu*/lapic_timer_advance_ns, after patch=
:
> 2775
> 2892
> 2764
> 2775
> ...
>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/lapic.c | 34 ++++++++++++++++++++++++++++------
>  arch/x86/kvm/lapic.h |  2 ++
>  2 files changed, 30 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index df5cd07..8487d9c 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -69,6 +69,7 @@
>  #define LAPIC_TIMER_ADVANCE_ADJUST_INIT 1000
>  /* step-by-step approximation to mitigate fluctuation */
>  #define LAPIC_TIMER_ADVANCE_ADJUST_STEP 8
> +#define LAPIC_TIMER_ADVANCE_RECALC_PERIOD (600 * HZ)
>
>  static inline int apic_test_vector(int vec, void *bitmap)
>  {
> @@ -1480,10 +1481,21 @@ static inline void __wait_lapic_expire(struct kvm=
_vcpu *vcpu, u64 guest_cycles)
>  static inline void adjust_lapic_timer_advance(struct kvm_vcpu *vcpu,
>                                               s64 advance_expire_delta)
>  {
> -       struct kvm_lapic *apic =3D vcpu->arch.apic;
> -       u32 timer_advance_ns =3D apic->lapic_timer.timer_advance_ns;
> +       struct kvm_timer *ktimer =3D &vcpu->arch.apic->lapic_timer;
> +       u32 timer_advance_ns =3D ktimer->timer_advance_ns;
>         u64 ns;
>
> +       /* periodic revaluate */
> +       if (unlikely(ktimer->timer_advance_adjust_done)) {
> +               ktimer->recalc_timer_advance_ns =3D jiffies +
> +                       LAPIC_TIMER_ADVANCE_RECALC_PERIOD;
> +               if (abs(advance_expire_delta) > LAPIC_TIMER_ADVANCE_ADJUS=
T_DONE) {
> +                       timer_advance_ns =3D LAPIC_TIMER_ADVANCE_ADJUST_I=
NIT;
> +                       ktimer->timer_advance_adjust_done =3D false;
> +               } else
> +                       return;
> +       }
> +
>         /* too early */
>         if (advance_expire_delta < 0) {
>                 ns =3D -advance_expire_delta * 1000000ULL;
> @@ -1499,12 +1511,18 @@ static inline void adjust_lapic_timer_advance(str=
uct kvm_vcpu *vcpu,
>         }
>
>         if (abs(advance_expire_delta) < LAPIC_TIMER_ADVANCE_ADJUST_DONE)
> -               apic->lapic_timer.timer_advance_adjust_done =3D true;
> +               ktimer->timer_advance_adjust_done =3D true;
>         if (unlikely(timer_advance_ns > 5000)) {
>                 timer_advance_ns =3D LAPIC_TIMER_ADVANCE_ADJUST_INIT;
> -               apic->lapic_timer.timer_advance_adjust_done =3D false;
> +               ktimer->timer_advance_adjust_done =3D false;
> +       }
> +       ktimer->timer_advance_ns =3D timer_advance_ns;
> +
> +       if (ktimer->timer_advance_adjust_done) {
> +               if (ktimer->min_timer_advance_ns > timer_advance_ns)
> +                       ktimer->min_timer_advance_ns =3D timer_advance_ns=
;
> +               ktimer->timer_advance_ns =3D ktimer->min_timer_advance_ns=
;
>         }
> -       apic->lapic_timer.timer_advance_ns =3D timer_advance_ns;
>  }
>
>  static void __kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
> @@ -1523,7 +1541,8 @@ static void __kvm_wait_lapic_expire(struct kvm_vcpu=
 *vcpu)
>         if (guest_tsc < tsc_deadline)
>                 __wait_lapic_expire(vcpu, tsc_deadline - guest_tsc);
>
> -       if (unlikely(!apic->lapic_timer.timer_advance_adjust_done))
> +       if (unlikely(!apic->lapic_timer.timer_advance_adjust_done) ||
> +               time_before(apic->lapic_timer.recalc_timer_advance_ns, ji=
ffies))
>                 adjust_lapic_timer_advance(vcpu, apic->lapic_timer.advanc=
e_expire_delta);
>  }
>
> @@ -2301,9 +2320,12 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int ti=
mer_advance_ns)
>         if (timer_advance_ns =3D=3D -1) {
>                 apic->lapic_timer.timer_advance_ns =3D LAPIC_TIMER_ADVANC=
E_ADJUST_INIT;
>                 apic->lapic_timer.timer_advance_adjust_done =3D false;
> +               apic->lapic_timer.recalc_timer_advance_ns =3D jiffies;
> +               apic->lapic_timer.min_timer_advance_ns =3D UINT_MAX;
>         } else {
>                 apic->lapic_timer.timer_advance_ns =3D timer_advance_ns;
>                 apic->lapic_timer.timer_advance_adjust_done =3D true;
> +               apic->lapic_timer.recalc_timer_advance_ns =3D MAX_JIFFY_O=
FFSET;
>         }
>
>
> diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> index 50053d2..56a05eb 100644
> --- a/arch/x86/kvm/lapic.h
> +++ b/arch/x86/kvm/lapic.h
> @@ -31,6 +31,8 @@ struct kvm_timer {
>         u32 timer_mode_mask;
>         u64 tscdeadline;
>         u64 expired_tscdeadline;
> +       unsigned long recalc_timer_advance_ns;
> +       u32 min_timer_advance_ns;
>         u32 timer_advance_ns;
>         s64 advance_expire_delta;
>         atomic_t pending;                       /* accumulated triggered =
timers */
> --
> 2.7.4
>
