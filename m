Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91F2B1BBAB0
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 12:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727909AbgD1KFs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 06:05:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727820AbgD1KFs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Apr 2020 06:05:48 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 511E5C03C1AC;
        Tue, 28 Apr 2020 03:05:48 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id 72so31654171otu.1;
        Tue, 28 Apr 2020 03:05:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=c+huRrl4EMmwLtCydWHPHBwimIQQrSdcPSmlbyOi6ak=;
        b=ZXQcasNbkucSaQmXTrTSqX7pZUJO2euHRVM05NZzm5TApUC2RLi8uiPoeIXyaeakg8
         L6s31m697YGtYuo/2tuzhQkt/Hsy+AUjb3rLu2rA2YL9iaQdgRGY1ARTmpQzgheJxVnE
         HQNWIkhgPajVwvSY9z8CelokxtaWqOuE1qSh8YZJPRyZpIMxiZBOATTvk3UAbwlSuS5W
         ZlyX+NpB4hN6Y/BZE5qqAAFDLA4OdVFtwAC+PUqFzLBItCIEvDcdfjXhJI/iNXjDuNXE
         qdnmr8vMnZbJWcm17PQsuhSwhQK9dGIFV696cp8pZJhMh/ImQAJlIebRToOXiZaAa84c
         DbIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=c+huRrl4EMmwLtCydWHPHBwimIQQrSdcPSmlbyOi6ak=;
        b=Cr2xU40lhFKrmfJD0zLp60qiCoJsq2ZquVSVnmOdvf8BA2ZIYQB9YqUcjm473D5KYP
         5IiUjz58cJnqXc56OlRuANwX7SuR6SBPwMyongl/9gTCEGlKVCyK8Vbfkxbld6uD06No
         5sMy8Y6CMhZwMoypdASyWzSfzR/5/V6KA0RohSEIZCuExBP1dyeLCEeBo5xEk3LBSsRz
         KvgjaASVK/pDShfdQnhpHTk8EqJqL11si95STgwHd3vXjr9LX0UF0xMQMEDUVEJsTIyV
         FD4kjyKvZ/MgtDStosAs5AjVIBPqBbvn3uSdhNMxqTUFpDW6iCsm66+24U8k4keJ1S4p
         yacA==
X-Gm-Message-State: AGi0PuaN3pDhZZbHChzbKbbkFiTKUgJmdoN8QvaIIRVXX4uI0NpKff1D
        QGdU2hEkPvKJBQ2KAj4cK0B/iRf2SHvCSc9fGzg=
X-Google-Smtp-Source: APiQypKYwyvKoAhMChnqsyAy72r1GF1221YvLClrEKSSr7ORzSXuco0AdOhukG42X8AkRT3b27d0+Yk1YWS/WZFqPdw=
X-Received: by 2002:a9d:810:: with SMTP id 16mr21332951oty.56.1588068347645;
 Tue, 28 Apr 2020 03:05:47 -0700 (PDT)
MIME-Version: 1.0
References: <1588055009-12677-1-git-send-email-wanpengli@tencent.com>
 <1588055009-12677-7-git-send-email-wanpengli@tencent.com> <15150824.2a36.171c0394538.Coremail.linxl3@wangsu.com>
In-Reply-To: <15150824.2a36.171c0394538.Coremail.linxl3@wangsu.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 28 Apr 2020 18:05:37 +0800
Message-ID: <CANRm+Cw0=JU5eJayQ0XM7n2e+q8a8dzHusqtsfNjmWTNai9phg@mail.gmail.com>
Subject: Re: [PATCH v4 6/7] KVM: X86: TSCDEADLINE MSR emulation fastpath
To:     =?UTF-8?B?5p6X6ZGr6b6Z?= <linxl3@wangsu.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Haiwei Li <lihaiwei@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 28 Apr 2020 at 17:59, =E6=9E=97=E9=91=AB=E9=BE=99 <linxl3@wangsu.co=
m> wrote:
>
> On Tuesday, 28 Apr 2020 at 14:23, Wanpeng Li <kernellwp@gmail.com> wrote:
> &gt;
> &gt; From: Wanpeng Li <wanpengli@tencent.com>
> &gt;
> &gt; This patch implements tscdealine msr emulation fastpath, after wrmsr
> &gt; tscdeadline vmexit, handle it as soon as possible and vmentry immedi=
ately
> &gt; without checking various kvm stuff when possible.
> &gt;
> &gt; Tested-by: Haiwei Li <lihaiwei@tencent.com>
> &gt; Cc: Haiwei Li <lihaiwei@tencent.com>
> &gt; Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> &gt; ---
> &gt;  arch/x86/kvm/lapic.c   | 18 ++++++++++++------
> &gt;  arch/x86/kvm/vmx/vmx.c | 12 ++++++++----
> &gt;  arch/x86/kvm/x86.c     | 30 ++++++++++++++++++++++++------
> &gt;  3 files changed, 44 insertions(+), 16 deletions(-)
> &gt;
> &gt; diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> &gt; index 38f7dc9..3589237 100644
> &gt; --- a/arch/x86/kvm/lapic.c
> &gt; +++ b/arch/x86/kvm/lapic.c
> &gt; @@ -1593,7 +1593,7 @@ static void kvm_apic_inject_pending_timer_irqs=
(struct kvm_lapic *apic)
> &gt;    }
> &gt;  }
> &gt;
> &gt; -static void apic_timer_expired(struct kvm_lapic *apic)
> &gt; +static void apic_timer_expired(struct kvm_lapic *apic, bool from_ti=
mer_fn)
> &gt;  {
> &gt;    struct kvm_vcpu *vcpu =3D apic-&gt;vcpu;
> &gt;    struct kvm_timer *ktimer =3D &amp;apic-&gt;lapic_timer;
> &gt; @@ -1604,6 +1604,12 @@ static void apic_timer_expired(struct kvm_lap=
ic *apic)
> &gt;    if (apic_lvtt_tscdeadline(apic) || ktimer-&gt;hv_timer_in_use)
> &gt;            ktimer-&gt;expired_tscdeadline =3D ktimer-&gt;tscdeadline=
;
> &gt;
> &gt; +  if (!from_timer_fn &amp;&amp; vcpu-&gt;arch.apicv_active) {
> &gt; +          WARN_ON(kvm_get_running_vcpu() !=3D vcpu);
> &gt; +          kvm_apic_inject_pending_timer_irqs(apic);
> &gt; +          return;
> &gt; +  }
> &gt; +
> &gt;    if (kvm_use_posted_timer_interrupt(apic-&gt;vcpu)) {
> &gt;            if (apic-&gt;lapic_timer.timer_advance_ns)
> &gt;                    __kvm_wait_lapic_expire(vcpu);
> &gt; @@ -1643,7 +1649,7 @@ static void start_sw_tscdeadline(struct kvm_la=
pic *apic)
> &gt;            expire =3D ktime_sub_ns(expire, ktimer-&gt;timer_advance_=
ns);
> &gt;            hrtimer_start(&amp;ktimer-&gt;timer, expire, HRTIMER_MODE=
_ABS_HARD);
> &gt;    } else
> &gt; -          apic_timer_expired(apic);
> &gt; +          apic_timer_expired(apic, false);
> &gt;
> &gt;    local_irq_restore(flags);
> &gt;  }
> &gt; @@ -1751,7 +1757,7 @@ static void start_sw_period(struct kvm_lapic *=
apic)
> &gt;
> &gt;    if (ktime_after(ktime_get(),
> &gt;                    apic-&gt;lapic_timer.target_expiration)) {
> &gt; -          apic_timer_expired(apic);
> &gt; +          apic_timer_expired(apic, false);
> &gt;
> &gt;            if (apic_lvtt_oneshot(apic))
> &gt;                    return;
> &gt; @@ -1813,7 +1819,7 @@ static bool start_hv_timer(struct kvm_lapic *a=
pic)
> &gt;            if (atomic_read(&amp;ktimer-&gt;pending)) {
> &gt;                    cancel_hv_timer(apic);
> &gt;            } else if (expired) {
> &gt; -                  apic_timer_expired(apic);
> &gt; +                  apic_timer_expired(apic, false);
> &gt;                    cancel_hv_timer(apic);
> &gt;            }
> &gt;    }
> &gt; @@ -1863,7 +1869,7 @@ void kvm_lapic_expired_hv_timer(struct kvm_vcp=
u *vcpu)
> &gt;            goto out;
> &gt;    WARN_ON(swait_active(&amp;vcpu-&gt;wq));
> &gt;    cancel_hv_timer(apic);
> &gt; -  apic_timer_expired(apic);
> &gt; +  apic_timer_expired(apic, false);
> &gt;
> &gt;    if (apic_lvtt_period(apic) &amp;&amp; apic-&gt;lapic_timer.period=
) {
> &gt;            advance_periodic_target_expiration(apic);
> &gt; @@ -2369,7 +2375,7 @@ static enum hrtimer_restart apic_timer_fn(stru=
ct hrtimer *data)
> &gt;    struct kvm_timer *ktimer =3D container_of(data, struct kvm_timer,=
 timer);
> &gt;    struct kvm_lapic *apic =3D container_of(ktimer, struct kvm_lapic,=
 lapic_timer);
> &gt;
> &gt; -  apic_timer_expired(apic);
> &gt; +  apic_timer_expired(apic, true);
> &gt;
> &gt;    if (lapic_is_periodic(apic)) {
> &gt;            advance_periodic_target_expiration(apic);
> &gt; diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> &gt; index ce19b0e..bb5c4f1 100644
> &gt; --- a/arch/x86/kvm/vmx/vmx.c
> &gt; +++ b/arch/x86/kvm/vmx/vmx.c
> &gt; @@ -5994,7 +5994,8 @@ static int vmx_handle_exit(struct kvm_vcpu *vc=
pu, fastpath_t exit_fastpath)
> &gt;    if (exit_fastpath =3D=3D EXIT_FASTPATH_SKIP_EMUL_INS) {
> &gt;            kvm_skip_emulated_instruction(vcpu);
> Can we move this kvm_skip_emulated_instruction to handle_fastpath_set_msr=
_irqoff? This will keep the style consistent.

It can have other users sooner or later.

    Wanpeng
