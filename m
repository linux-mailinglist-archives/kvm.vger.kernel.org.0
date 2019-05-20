Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23C6123237
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 13:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732682AbfETLW4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 07:22:56 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:43684 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731487AbfETLW4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 07:22:56 -0400
Received: by mail-oi1-f195.google.com with SMTP id t187so9647689oie.10;
        Mon, 20 May 2019 04:22:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pqJsM3I7VCsCBoW08AaOqNI2KyFITesPxcJ79o2nhOY=;
        b=kzFA2iZkmhj+hMC7x3NQTmHLxTdFCMkKG72QKILHzE5vC2f2S4rkZsgL983zr8+8BZ
         wTiDF+EPQdFWOpqI/XujsRnREJMf+i2r30eP2gDEyN68vKiFzWUYAG+3b0U7n29EAxMF
         Us2X9NgwH8z9Igvtc7iLkRAZLiZipZXqs96CFG9V+cdQWL6fvBiEEgH5Ye6UUWevD5FZ
         iIAjHVG31ilVJd8yio/TXoRFakMTusuYv3+4MQTGzRD20WcsPgKjzw2CTvCUb1ruSI2p
         8Z87vggS/oxAneCCbsdv/rf3tJNm4UGq2Dy/RyPyq4USZfca50KZcfJNBxPhTtHsOcCC
         2KvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pqJsM3I7VCsCBoW08AaOqNI2KyFITesPxcJ79o2nhOY=;
        b=P/3YM0tR/XtC0P5iB/FGKSbM/cOocBxYhtKInW65WAZq4+UXpvaOLjfQT3eM63cCzX
         3VaDcS1P18EyRK/OmeuBNdY4i03ZledelYrFfgC/DAvqJB7fbD2hWaq+areklByoZnX5
         SOscHUwhte6Lo7cBhgZGQk6T2sAx2xg2Ts6oHC8CCfc6TJZUSfmR5duHh9pBntX7dDsB
         vfKsVUkU9XNZlA1953Nm7VvajmxAT8qAZKL8gxAxkOtabF2bAOnaGLXyCZMKSDntiltH
         7EWEoZJxQBddg5rYEi7I0pattAwuUxfipPxb/2tfUbnRNPpGgMR6dPcrXOV2rBDdIHLs
         YrRg==
X-Gm-Message-State: APjAAAXN4f1VOcVrrufn4iTft50fETyBSKZcUNbCEJUTBioBMuHL9nV0
        86aZMASwJ5LMwtNF1q9n+e4kDHk/LfWwEmHq5dsj0wws
X-Google-Smtp-Source: APXvYqzzzLEbFr/YCGl6P2GF59jY07tpiE2qxD8404B1NsnaV6x3z47aRMdPOBTHq8Sh9jE3FuwsMT4L1bi8SMBqPmM=
X-Received: by 2002:aca:c711:: with SMTP id x17mr48064oif.174.1558351375321;
 Mon, 20 May 2019 04:22:55 -0700 (PDT)
MIME-Version: 1.0
References: <1558340289-6857-1-git-send-email-wanpengli@tencent.com>
 <1558340289-6857-5-git-send-email-wanpengli@tencent.com> <b80a0c3b-c5b1-bfd1-83d7-ace3436b230e@redhat.com>
In-Reply-To: <b80a0c3b-c5b1-bfd1-83d7-ace3436b230e@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Mon, 20 May 2019 19:22:46 +0800
Message-ID: <CANRm+CyDpA-2j28soX9si5CX3vFadd4_BASFzt1f4FbNNNDzyw@mail.gmail.com>
Subject: Re: [PATCH v4 4/5] KVM: LAPIC: Delay trace advance expire delta
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Liran Alon <liran.alon@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 20 May 2019 at 19:14, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 20/05/19 10:18, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > wait_lapic_expire() call was moved above guest_enter_irqoff() because of
> > its tracepoint, which violated the RCU extended quiescent state invoked
> > by guest_enter_irqoff()[1][2]. This patch simply moves the tracepoint
> > below guest_exit_irqoff() in vcpu_enter_guest(). Snapshot the delta before
> > VM-Enter, but trace it after VM-Exit. This can help us to move
> > wait_lapic_expire() just before vmentry in the later patch.
> >
> > [1] Commit 8b89fe1f6c43 ("kvm: x86: move tracepoints outside extended quiescent state")
> > [2] https://patchwork.kernel.org/patch/7821111/
>
> This is a bit confusing, since the delta is printed after the
> corresponding vmexit but the wait is done before the vmentry.  I think
> we can drop the tracepoint:
>
> ------------- 8< ----------------
> From ae148d98d49b96b5222e2c78ac1b1e13cc526d71 Mon Sep 17 00:00:00 2001
> From: Paolo Bonzini <pbonzini@redhat.com>
> Date: Mon, 20 May 2019 13:10:01 +0200
> Subject: [PATCH] KVM: lapic: replace wait_lapic_expire tracepoint with
>  restart_apic_timer
>
> wait_lapic_expire() call was moved above guest_enter_irqoff() because of
> its tracepoint, which violated the RCU extended quiescent state invoked
> by guest_enter_irqoff()[1][2].
>
> We would like to move wait_lapic_expire() just before vmentry, which would
> place wait_lapic_expire() again inside the extended quiescent state.  Drop
> the tracepoint, but add instead another one that can be useful and where
> we can check the status of the adaptive tuning procedure.

https://lkml.org/lkml/2019/5/15/1435

Maybe Sean's comment is reasonable, per-vCPU debugfs entry for
adaptive tuning and wait_lapic_expire() tracepoint for hand tuning.

Regards,
Wanpeng Li

>
> [1] Commit 8b89fe1f6c43 ("kvm: x86: move tracepoints outside extended quiescent state")
> [2] https://patchwork.kernel.org/patch/7821111/
>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>
> ---
>  arch/x86/kvm/lapic.c |  4 +++-
>  arch/x86/kvm/trace.h | 15 +++++++--------
>  2 files changed, 10 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index c12b090f4fad..8f05c1d0b486 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1545,7 +1545,6 @@ void wait_lapic_expire(struct kvm_vcpu *vcpu)
>         tsc_deadline = apic->lapic_timer.expired_tscdeadline;
>         apic->lapic_timer.expired_tscdeadline = 0;
>         guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
> -       trace_kvm_wait_lapic_expire(vcpu->vcpu_id, guest_tsc - tsc_deadline);
>
>         if (guest_tsc < tsc_deadline)
>                 __wait_lapic_expire(vcpu, tsc_deadline - guest_tsc);
> @@ -1763,6 +1762,9 @@ static void start_sw_timer(struct kvm_lapic *apic)
>
>  static void restart_apic_timer(struct kvm_lapic *apic)
>  {
> +       trace_kvm_restart_apic_timer(apic->vcpu->vcpu_id,
> +                                    apic->lapic_timer.timer_advance_ns);
> +
>         preempt_disable();
>
>         if (!apic_lvtt_period(apic) && atomic_read(&apic->lapic_timer.pending))
> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> index 4d47a2631d1f..f6e000038f3f 100644
> --- a/arch/x86/kvm/trace.h
> +++ b/arch/x86/kvm/trace.h
> @@ -953,24 +953,23 @@
>                   __entry->flags)
>  );
>
> -TRACE_EVENT(kvm_wait_lapic_expire,
> -       TP_PROTO(unsigned int vcpu_id, s64 delta),
> -       TP_ARGS(vcpu_id, delta),
> +TRACE_EVENT(kvm_restart_apic_timer,
> +       TP_PROTO(unsigned int vcpu_id, u32 advance),
> +       TP_ARGS(vcpu_id, advance),
>
>         TP_STRUCT__entry(
>                 __field(        unsigned int,   vcpu_id         )
> -               __field(        s64,            delta           )
> +               __field(        u32,            advance         )
>         ),
>
>         TP_fast_assign(
>                 __entry->vcpu_id           = vcpu_id;
> -               __entry->delta             = delta;
> +               __entry->advance           = advance;
>         ),
>
> -       TP_printk("vcpu %u: delta %lld (%s)",
> +       TP_printk("vcpu %u: advance %u",
>                   __entry->vcpu_id,
> -                 __entry->delta,
> -                 __entry->delta < 0 ? "early" : "late")
> +                 __entry->advance)
>  );
>
>  TRACE_EVENT(kvm_enter_smm,
