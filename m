Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28B71262A9B
	for <lists+kvm@lfdr.de>; Wed,  9 Sep 2020 10:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbgIIIl4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Sep 2020 04:41:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725984AbgIIIlz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Sep 2020 04:41:55 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62399C061573;
        Wed,  9 Sep 2020 01:41:55 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id g10so1614074otq.9;
        Wed, 09 Sep 2020 01:41:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VXHXXV715sJGvUd4gjnShEaVrmyYwXRLuNaJb8O8w9Y=;
        b=GCxfoG85fPs+aC2goM6GRmpl9a0HZJlzmp22qMa6XqflGM2Y6etiGlEODS++mRNXtX
         mrPSot5h/upKBw5pz6rsf59r90lS9QdsqGEwcdY7s0tZ3UPQ/BIJzwGOivmFhnn2ZG6e
         RLLczMN++oMR0rlKZD+T4FdM6dU90Cb/DSpdo+JaBk0pp35KSvse1gBwYbYzZ/0pywPv
         zaGEvnTlAOXirNCtQPgEmxyX52UMGpHtnb+0S1AMBhyZuvl5U7f6Jzf/LLJvfyH4ghFv
         XNeSo23ecZWs5cHeGLj1JsLt5udTJyCZZWTfkQGrNLjpSzSVGqHOHWBW7l76yKOeRIWy
         M9iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VXHXXV715sJGvUd4gjnShEaVrmyYwXRLuNaJb8O8w9Y=;
        b=hO0l4HRYWMuQZ5Wyw2Isig8vVmyXtIk3CWaXheF4k+KIhO7FKqrEAm8NdydQwUBS9R
         iQPYLIX1Cik/M3GHARLFcEngkAjsX8CL2oXAbWHweUyRg+YgrKrDeajLJQyQ+x5Xt36V
         dqRrh2UhskWvZmRaLxkm1eKHtgj2sB0H8sHiAIX89IknQrT0HoPeWrqyCiPLeoA7CEq1
         lIhwEvfPsiVSWMYNyThdb3uPJapq3rt2N7X8/vRCleJe2qVXGy6wEh5VZ4Dakfn3ngb4
         8um3LDI4S0falFDP7C59Yn5glxSIQca1oxIETiWUzadWc00bvF1YS3ZyHe03ggtWurq4
         0ebA==
X-Gm-Message-State: AOAM530JHoa/VkkaBNIeK+O9J6eNdRYeqG8UngwuvbtybWWbbn4oA3cP
        ie2RHszo1rNX6Yx/P3lmkFIHeUBOeng7wASXAhkSQYig
X-Google-Smtp-Source: ABdhPJy+c9dSxfXe7HdL/2aH0Yvc1jgsVB8kwjUUGri9OvrCGDI+rlRiV1IaX+2rd2CJOx7w/41RZCCN4RzNf8iy06U=
X-Received: by 2002:a9d:c44:: with SMTP id 62mr2273269otr.185.1599640914398;
 Wed, 09 Sep 2020 01:41:54 -0700 (PDT)
MIME-Version: 1.0
References: <1597827327-25055-1-git-send-email-wanpengli@tencent.com>
In-Reply-To: <1597827327-25055-1-git-send-email-wanpengli@tencent.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 9 Sep 2020 16:41:43 +0800
Message-ID: <CANRm+Cx=6zc=KTw5XwMQTdOG3m67MCcmthRuFR-VTnOTB06kow@mail.gmail.com>
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

Any Reviewed-by for these two patches? :)
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
