Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41E6D39EAB5
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 02:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbhFHAdU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 20:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbhFHAdU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Jun 2021 20:33:20 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B38BC061574;
        Mon,  7 Jun 2021 17:31:15 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id z3so19897115oib.5;
        Mon, 07 Jun 2021 17:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CiokwtvRl2HBPdNl53NI3K1ZgCp8ltKDAJs4OYeIhlU=;
        b=emPOWu/4e/j9lQEtlNMQipiXjQWsGZLaQZe8+oS8bKJQ0DQs7kZ96iC4FiYNPym+hf
         poMEvWZZEu3Yrj1alNKYIwIhpKVwjb8vul5c9Hck/XTASiwUUZbDpDmnmsAoX8nWvWEj
         neO/RYdZnysRkQf+naq8htn99mY1vUkqFmxN7TgyDowencfEV1h8/KZ/kmB/lfWHMlkU
         uohtPJs7DBBco7XkZ5CHvM494sQdb4mUdDx2n/NfRHEyKZwPl18ATkhmWAs/NtQFefp9
         zn/jrILP6U+S3GFkek1YKl/rMxznTDl7Je0HIqnUpHCrdPMe2+zB15sm4dz1IZjlpKzP
         mBbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CiokwtvRl2HBPdNl53NI3K1ZgCp8ltKDAJs4OYeIhlU=;
        b=PBWpq41bwA2QxE/v50gz1H6KP6SdM1zWnS8zv/btJ+bbe2NZaAgCdSTjeXL8WuQ8zH
         aif0H0J71beGxwunE+QWK3PSownNbUTMcktSeuW4YzSV8HfAaNs3DaX8JcQ7sjTi6eOS
         mZCmkuaRGA8SI+pPMmd5t850jei8fUztdljQI9xFNoHwM3kNT+efBRG5O13togb4O8ar
         G5M9M4V0p3RaOJv2HKHyhOQ0GGyyHnjKHrOTFqdq71nq+yYblHiq/RMvtqO3Xq/MgsHW
         RCSZ5os6EvufikeNQxR94eUAv8UJOVrcLwXKQ0wgkeNdNIaEL9YVmbdMGVokkEooB1fh
         wqFg==
X-Gm-Message-State: AOAM532Ajl6nrZpD8pUcr0eDIWTKK3NsZ4KUNu8VLWpPTLa7Im1htlIx
        GknTW/tuaJnS1V6GRYo9WKz1uIVO0alF8o6BNHJcGcSE
X-Google-Smtp-Source: ABdhPJzKcRi6ZVfDPEFp7dypwoMSgGajiC5slspj1cMe2AzLuL5IJf15onIow9Jch5OT36BeKzAeHnsYij6CVmHcyYE=
X-Received: by 2002:a05:6808:c3:: with SMTP id t3mr1025182oic.5.1623112273961;
 Mon, 07 Jun 2021 17:31:13 -0700 (PDT)
MIME-Version: 1.0
References: <1622710841-76604-1-git-send-email-wanpengli@tencent.com>
 <1622710841-76604-2-git-send-email-wanpengli@tencent.com> <CALMp9eSK-_xOp=WdRbOOHaHHMHuJkPhG+7h4M+_+=4d-GCNzwA@mail.gmail.com>
 <YLj2jDKMYZatdl3a@google.com>
In-Reply-To: <YLj2jDKMYZatdl3a@google.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 8 Jun 2021 08:31:02 +0800
Message-ID: <CANRm+CxQc+fiO5jBDif9M5jUKRCU-mHtb5yMaPsbRpWR+v2hYQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: LAPIC: reset TMCCT during vCPU reset
To:     Sean Christopherson <seanjc@google.com>
Cc:     Jim Mattson <jmattson@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 3 Jun 2021 at 23:34, Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Jun 03, 2021, Jim Mattson wrote:
> > On Thu, Jun 3, 2021 at 2:01 AM Wanpeng Li <kernellwp@gmail.com> wrote:
> > >
> > > From: Wanpeng Li <wanpengli@tencent.com>
> > >
> > > The value of current counter register after reset is 0 for both Intel
> > > and AMD, let's do it in kvm.
> > >
> > > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> >
> > How did we miss that?
>
> I suspect it's not actually a functional issue, and that writing '0' at reset is
> a glorified nop.  The TMCCT is always computed on-demand and never directly
> readable.

Update the patch description in v2, thanks.

    Wanpeng

>
> Is there an observable bug being fixed?  If not, the changelog should state that
> this is a cosmetic change of sorts.
>
> static u32 __apic_read(struct kvm_lapic *apic, unsigned int offset)
> {
>         u32 val = 0;
>
>         if (offset >= LAPIC_MMIO_LENGTH)
>                 return 0;
>
>         switch (offset) {
>         case APIC_ARBPRI:
>                 break;
>
>         case APIC_TMCCT:        /* Timer CCR */
>                 if (apic_lvtt_tscdeadline(apic))
>                         return 0;
>
>                 val = apic_get_tmcct(apic);
>                 break;
>         ...
> }
>
>
> static u32 apic_get_tmcct(struct kvm_lapic *apic)
> {
>         ktime_t remaining, now;
>         s64 ns;
>         u32 tmcct;
>
>         ASSERT(apic != NULL);
>
>         /* if initial count is 0, current count should also be 0 */
>         if (kvm_lapic_get_reg(apic, APIC_TMICT) == 0 ||  <------------
>                 apic->lapic_timer.period == 0)
>                 return 0;
>
>         now = ktime_get();
>         remaining = ktime_sub(apic->lapic_timer.target_expiration, now);
>         if (ktime_to_ns(remaining) < 0)
>                 remaining = 0;
>
>         ns = mod_64(ktime_to_ns(remaining), apic->lapic_timer.period);
>         tmcct = div64_u64(ns,
>                          (APIC_BUS_CYCLE_NS * apic->divide_count));
>
>         return tmcct;
> }
>
> int kvm_apic_get_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
> {
>         memcpy(s->regs, vcpu->arch.apic->regs, sizeof(*s));
>
>         /*
>          * Get calculated timer current count for remaining timer period (if
>          * any) and store it in the returned register set.
>          */
>         __kvm_lapic_set_reg(s->regs, APIC_TMCCT,
>                             __apic_read(vcpu->arch.apic, APIC_TMCCT));  <----
>
>         return kvm_apic_state_fixup(vcpu, s, false);
> }
>
>
>
