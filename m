Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6999FC9E
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2019 10:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbfH1IJX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 04:09:23 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:35089 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726273AbfH1IJW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 04:09:22 -0400
Received: by mail-ot1-f65.google.com with SMTP id 100so1925946otn.2;
        Wed, 28 Aug 2019 01:09:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3IBZx4mGOlN1FcM7wUQT1/lDwwQM1SgASfqzyxkV/zg=;
        b=Xwk3COLlX7RcEpVTG5XSZocKEbubrLq+N6qZ8/KmmB1etad6detY97GZPfyMPobIz+
         oxeBH72dKvOz84pU+b/o7bl2vXNi5IqlF9/H7d3hWBRENYS74BJWSNSuTS8BkP/ZAhtc
         8fg90rYz5cCi8GRcDlzvvGw2XjsQnGh+UdG4b+rBLEeB/ATuXP0h7cjRaVd1UjHQX6Bw
         gbyLrpuNXD3vb1BdV3nWdeyvMq9+IJnvBh/lIFAFhS0PyZE31iSiILWD53ZZ9V8FaG9F
         +jxf1fWEYAFp2RF7zSdilpViBIZ+3S6nI0JeoJSJwc/KR4ckKsj9vfwUjOEqIv8RIpn5
         78lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3IBZx4mGOlN1FcM7wUQT1/lDwwQM1SgASfqzyxkV/zg=;
        b=AP94b1yL/BbtjNsQCFr6yR/sz6nsOeK77mOA9zK6QWDqpDkdCXmHrcuyG+eND/4v2K
         Hx0Ba3I8JKOBtdll1nxVgBJehXdgXQJvnZSQjp0Uc3Ps82AGtQ/EL5Cpo69EmgeTOTUy
         nrpkBjfkUbsIZR9vyLd2Jl6Ko7SE522g1O3UOnND6Tm4c6NgTVV8nVKtmxWOHwinryHR
         XswaJ+hTRkwbtJHk5yTd+ATT51cHEnM8nqHbWtAnbmahcmk5AO57Ou7QhxPIgWKXyXbK
         hLoO3CRVurHOB7bsHMkBKkBChBBHhrJ4hSs2x9H+zDMPXNd5TSqBbrNiVbGscM1Zk6Of
         NhyA==
X-Gm-Message-State: APjAAAXfVV9pRlZBmsZ/2tkO+qb+Za27LgKbMvFzGYfdgg+46n0sKDX2
        r3M426fAXHWUHuJ2/KyV8gRtHUgZVVH170m3+Tc=
X-Google-Smtp-Source: APXvYqzwae2GgrfGJlv2VRaP63sFgjWDxePv13XYHlVO3K4T5KyB24C02CVMCA/Ll4etXYDvjMLBgB6YWT8Oe6XPgf4=
X-Received: by 2002:a9d:6c53:: with SMTP id g19mr2054804otq.254.1566979761301;
 Wed, 28 Aug 2019 01:09:21 -0700 (PDT)
MIME-Version: 1.0
References: <1565841817-25982-1-git-send-email-wanpengli@tencent.com> <20190827174717.GB65641@flask>
In-Reply-To: <20190827174717.GB65641@flask>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 28 Aug 2019 16:09:58 +0800
Message-ID: <CANRm+Cy++Gt-kag+k0EydbFdzfDPT7-CwJOj95kM5UTnipr0qA@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: LAPIC: Periodically revaluate to get conservative lapic_timer_advance_ns
To:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 28 Aug 2019 at 01:47, Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.c=
om> wrote:
>
> 2019-08-15 12:03+0800, Wanpeng Li:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > Even if for realtime CPUs, cache line bounces, frequency scaling, prese=
nce
> > of higher-priority RT tasks, etc can still cause different response. Th=
ese
> > interferences should be considered and periodically revaluate whether
> > or not the lapic_timer_advance_ns value is the best, do nothing if it i=
s,
> > otherwise recaluate again. Set lapic_timer_advance_ns to the minimal
> > conservative value from all the estimated values.
>
> IIUC, this patch is looking for the minimal timer_advance_ns because it
> provides the best throughput:
> When every code path ran as fast as possible and we don't have to wait
> for the timer to expire, but still arrive exactly at the point when it
> would have expired.
> We always arrive late late if something delayed the execution, which
> means higher latencies, but RT shouldn't be using an adaptive algorithm
> anyway, so that is not an issue.
>
> The computed conservative timer_advance_ns will converge to the minimal
> measured timer_advance_ns as time progresses, because it can only go
> down and will do so repeatedly by small steps as even one smaller
> measurement sufficiently close is enough to decrease it.
>
> With that in mind, wouldn't the following patch (completely untested)
> give you about the same numbers?
>
> The idea is that if we have to wait, we are wasting time and therefore
> decrease timer_advance_ns to eliminate the time spent waiting.
>
> The first run is special and just sets timer_advance_ns to the latency
> we measured, regardless of what it is -- it deals with the possibility
> that the default was too low.
>
> This algorithm is also likely prone to turbo boost making few runs
> faster than what is then achieved during a more common workload, but
> we'd need to have a sliding window or some other more sophisticated
> algorithm in order to deal with that.
>
> I also like Paolo's idea of a smoothing -- if we use a moving average
> based on advance_expire_delta, we wouldn't even have to convert it into
> ns unless it reached a given threshold, which could make decently fast
> to be run every time.
>
> Something like
>
>    moving_average =3D (apic->lapic_timer.moving_average * (weight - 1) + =
advance_expire_delta) / weight
>
>    if (moving_average > threshold)
>       recompute timer_advance_ns
>
>    apic->lapic_timer.moving_average =3D moving_average
>
> where weight would be a of 2 to make the operation fast.
>
> This kind of moving average gives less value to old inputs and the
> weight allows us to control the reaction speed of the approximation.
> (A small number like 4 or 8 seems about right.)
>
> I don't have any information on the latency, though.
> Do you think that the added overhead isn't worth the smoothing?
>
> Thanks.
>
> ---8<---
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index e904ff06a83d..d7f2af2eb3ce 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1491,23 +1491,20 @@ static inline void adjust_lapic_timer_advance(str=
uct kvm_vcpu *vcpu,
>         if (advance_expire_delta < 0) {
>                 ns =3D -advance_expire_delta * 1000000ULL;
>                 do_div(ns, vcpu->arch.virtual_tsc_khz);
> -               timer_advance_ns -=3D min((u32)ns,
> -                       timer_advance_ns / LAPIC_TIMER_ADVANCE_ADJUST_STE=
P);
> +               timer_advance_ns -=3D (u32)ns;
>         } else {
>         /* too late */
> +               /* This branch can only be taken on the initial calibrati=
on. */
> +               if (apic->lapic_timer.timer_advance_adjust_done)
> +                       pr_err_once("kvm: broken expectation in lapic tim=
er_advance_ns");
> +
>                 ns =3D advance_expire_delta * 1000000ULL;
>                 do_div(ns, vcpu->arch.virtual_tsc_khz);
> -               timer_advance_ns +=3D min((u32)ns,
> -                       timer_advance_ns / LAPIC_TIMER_ADVANCE_ADJUST_STE=
P);
> +               timer_advance_ns +=3D (u32)ns;
>         }
>
> -       if (abs(advance_expire_delta) < LAPIC_TIMER_ADVANCE_ADJUST_DONE)
> -               apic->lapic_timer.timer_advance_adjust_done =3D true;
> -       if (unlikely(timer_advance_ns > 5000)) {
> -               timer_advance_ns =3D LAPIC_TIMER_ADVANCE_ADJUST_INIT;
> -               apic->lapic_timer.timer_advance_adjust_done =3D false;
> -       }
>         apic->lapic_timer.timer_advance_ns =3D timer_advance_ns;
> +       apic->lapic_timer.timer_advance_adjust_done =3D true;
>  }
>
>  static void __kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
> @@ -1526,7 +1523,7 @@ static void __kvm_wait_lapic_expire(struct kvm_vcpu=
 *vcpu)
>         if (guest_tsc < tsc_deadline)
>                 __wait_lapic_expire(vcpu, tsc_deadline - guest_tsc);
>
> -       if (unlikely(!apic->lapic_timer.timer_advance_adjust_done))
> +       if (unlikely(!apic->lapic_timer.timer_advance_adjust_done) || gue=
st_tsc < tsc_deadline)
>                 adjust_lapic_timer_advance(vcpu, apic->lapic_timer.advanc=
e_expire_delta);
>  }
>

Something like below, the result is not as good as we expected. How
about v3? I use moving average to be smooth and filter out drastic
fluctuation which prevents it before.

(testing on Skylake server, the lapic_timer_advance_ns is around
1500ns for my v2 patch)
# cat vcpu*/lapic_timer_advance_ns
483
263
211
15

---8<---
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index e904ff0..bdc0702 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1485,29 +1485,50 @@ static inline void
adjust_lapic_timer_advance(struct kvm_vcpu *vcpu,
 {
     struct kvm_lapic *apic =3D vcpu->arch.apic;
     u32 timer_advance_ns =3D apic->lapic_timer.timer_advance_ns;
+    s64 moving_average;
     u64 ns;

+    if (abs(advance_expire_delta) > 10000)
+        /* filter out drastic flunctuations */
+        return;
+
+    if (apic->lapic_timer.timer_advance_adjust_done) {
+        moving_average =3D (apic->lapic_timer.moving_average *
+            (LAPIC_TIMER_ADVANCE_ADJUST_STEP - 1) +
+            advance_expire_delta) / LAPIC_TIMER_ADVANCE_ADJUST_STEP;
+
+        if (abs(moving_average) < LAPIC_TIMER_ADVANCE_ADJUST_DONE)
+            /* no update for random fluctuations */
+            return;
+
+        apic->lapic_timer.moving_average =3D moving_average;
+        advance_expire_delta =3D moving_average;
+    } else
+        apic->lapic_timer.moving_average =3D advance_expire_delta;
+
     /* too early */
     if (advance_expire_delta < 0) {
         ns =3D -advance_expire_delta * 1000000ULL;
         do_div(ns, vcpu->arch.virtual_tsc_khz);
-        timer_advance_ns -=3D min((u32)ns,
-            timer_advance_ns / LAPIC_TIMER_ADVANCE_ADJUST_STEP);
+        timer_advance_ns -=3D (u32)ns;
     } else {
     /* too late */
+        /* This branch can only be taken on the initial calibration. */
+        if (apic->lapic_timer.timer_advance_adjust_done)
+            pr_err_once("kvm: broken expectation in lapic timer_advance_ns=
");
+
         ns =3D advance_expire_delta * 1000000ULL;
         do_div(ns, vcpu->arch.virtual_tsc_khz);
-        timer_advance_ns +=3D min((u32)ns,
-            timer_advance_ns / LAPIC_TIMER_ADVANCE_ADJUST_STEP);
+        timer_advance_ns +=3D (u32)ns;
     }

-    if (abs(advance_expire_delta) < LAPIC_TIMER_ADVANCE_ADJUST_DONE)
-        apic->lapic_timer.timer_advance_adjust_done =3D true;
     if (unlikely(timer_advance_ns > 5000)) {
         timer_advance_ns =3D LAPIC_TIMER_ADVANCE_ADJUST_INIT;
         apic->lapic_timer.timer_advance_adjust_done =3D false;
     }
+
     apic->lapic_timer.timer_advance_ns =3D timer_advance_ns;
+    apic->lapic_timer.timer_advance_adjust_done =3D true;
 }

 static void __kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
@@ -1526,7 +1547,8 @@ static void __kvm_wait_lapic_expire(struct kvm_vcpu *=
vcpu)
     if (guest_tsc < tsc_deadline)
         __wait_lapic_expire(vcpu, tsc_deadline - guest_tsc);

-    if (unlikely(!apic->lapic_timer.timer_advance_adjust_done))
+    if (unlikely(!apic->lapic_timer.timer_advance_adjust_done) ||
+        guest_tsc < tsc_deadline)
         adjust_lapic_timer_advance(vcpu,
apic->lapic_timer.advance_expire_delta);
 }

diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 50053d2..2e6e499 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -33,6 +33,7 @@ struct kvm_timer {
     u64 expired_tscdeadline;
     u32 timer_advance_ns;
     s64 advance_expire_delta;
+    s64 moving_average;
     atomic_t pending;            /* accumulated triggered timers */
     bool hv_timer_in_use;
     bool timer_advance_adjust_done;
