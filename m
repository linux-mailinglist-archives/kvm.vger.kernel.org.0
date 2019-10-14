Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D7E6D5920
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2019 02:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729596AbfJNAt4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Oct 2019 20:49:56 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:43880 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729454AbfJNAt4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Oct 2019 20:49:56 -0400
Received: by mail-oi1-f194.google.com with SMTP id t84so12414132oih.10;
        Sun, 13 Oct 2019 17:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Dm90rt3X4Dj0eZ5nqIXjNthLIZg5on7T0CNMl+bnamI=;
        b=XE1UTlaI0ZlC+hBkpc7OA5fWSkOET5PEeVgIug60HyB8Ljy84wZqVh/RMQrjINYbty
         NdTqnyJSMZX1AFMLi4orjiH0xoP2Vigz663/RR5zx7mGQVm1R7qGnELhRrvGvRw09AwB
         U6tT8Es08EKQ3vSOaNMXymM4T/n5uC0fnkD48oCPd8EDWrncVEFg/sAA5tcLlJsG31H4
         Dh32BfSvfJpudqCpStZVVEkCGMNotSF1PS81/u0A5BiVBUpke8qMgtYZy+7E0aPk38jA
         T3w4LD0S4LoMdsQ8NjZxxxmeoGCt1kM2h2lkaHeYRGIcCpfRlwE8LBKkZslNQfyld7gO
         LM7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Dm90rt3X4Dj0eZ5nqIXjNthLIZg5on7T0CNMl+bnamI=;
        b=uhjTXTzTIaRYXfZ/PS/KgFTH/kXSAqAvTaz/fwqcQRc3cHkm+u+tzVJZdm4+pGJPjm
         MtrSdRY2q4v0LWMnyK9g8TovvSHK5I12TIahKl5HPOS3D0GYhAH3SlWF4/XWbdlTtu4d
         e7IhLTysuMO8bJw5cHpsOk10uslNby/I2eVLn0pd5nJQbwTBlc+4cbSZF2UIjvzk0qRS
         RpNl+MS2nse1361lqxI9cLflvT7Or5ZFmYCwla8No+4gXPGStIZRWevbx2pscv5HSCAv
         odTWApaUrVrfk+Lup2wgMyOVPli+0UlrsGioc9sI3Fvb8N11ysw+NFH73wUY9zH3M6Zp
         yBbw==
X-Gm-Message-State: APjAAAXUF+EaWV/qQLWPKDku5WXEODo3yojg6W7FtQmjPehWfI1a1jR3
        aHxY8GFW2ruU51a5szWo+6MB6zCiynPeBinqdOXhag==
X-Google-Smtp-Source: APXvYqxHyULL/aZ+orTB4oPYdU/SUdg/07ZS2C52JueTMCjbvM79SmxwlCVeROmuMrojVdXYg3qOO5lAxDrvtJtHKSw=
X-Received: by 2002:aca:da41:: with SMTP id r62mr21466808oig.47.1571014193872;
 Sun, 13 Oct 2019 17:49:53 -0700 (PDT)
MIME-Version: 1.0
References: <1568974038-13750-1-git-send-email-wanpengli@tencent.com>
In-Reply-To: <1568974038-13750-1-git-send-email-wanpengli@tencent.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Mon, 14 Oct 2019 08:49:42 +0800
Message-ID: <CANRm+Cy_eQ=m=bDfyw2yrAmDjJuc=f+siSQTrPpjCpBbYbfPeA@mail.gmail.com>
Subject: Re: [PATCH] KVM: LAPIC: micro-optimize fixed mode ipi delivery
To:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
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

ping,
On Fri, 20 Sep 2019 at 18:07, Wanpeng Li <kernellwp@gmail.com> wrote:
>
> From: Wanpeng Li <wanpengli@tencent.com>
>
> After disabling mwait/halt/pause vmexits, RESCHEDULE_VECTOR and
> CALL_FUNCTION_SINGLE_VECTOR etc IPI is one of the main remaining
> cause of vmexits observed in product environment which can't be
> optimized by PV IPIs. This patch is the follow-up on commit
> 0e6d242eccdb (KVM: LAPIC: Micro optimize IPI latency), to optimize
> redundancy logic before fixed mode ipi is delivered in the fast
> path.
>
> - broadcast handling needs to go slow path, so the delivery mode repair
>   can be delayed to before slow path.
> - self-IPI will not be intervened by hypervisor any more after APICv is
>   introduced and the boxes support APICv are popular now. In addition,
>   kvm_apic_map_get_dest_lapic() can handle the self-IPI, so there is no
>   need a shortcut for the non-APICv case.
>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/irq_comm.c | 6 +++---
>  arch/x86/kvm/lapic.c    | 5 -----
>  2 files changed, 3 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
> index 8ecd48d..aa88156 100644
> --- a/arch/x86/kvm/irq_comm.c
> +++ b/arch/x86/kvm/irq_comm.c
> @@ -52,15 +52,15 @@ int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
>         unsigned long dest_vcpu_bitmap[BITS_TO_LONGS(KVM_MAX_VCPUS)];
>         unsigned int dest_vcpus = 0;
>
> +       if (kvm_irq_delivery_to_apic_fast(kvm, src, irq, &r, dest_map))
> +               return r;
> +
>         if (irq->dest_mode == 0 && irq->dest_id == 0xff &&
>                         kvm_lowest_prio_delivery(irq)) {
>                 printk(KERN_INFO "kvm: apic: phys broadcast and lowest prio\n");
>                 irq->delivery_mode = APIC_DM_FIXED;
>         }
>
> -       if (kvm_irq_delivery_to_apic_fast(kvm, src, irq, &r, dest_map))
> -               return r;
> -
>         memset(dest_vcpu_bitmap, 0, sizeof(dest_vcpu_bitmap));
>
>         kvm_for_each_vcpu(i, vcpu, kvm) {
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 323bdca..d77fe29 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -955,11 +955,6 @@ bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
>
>         *r = -1;
>
> -       if (irq->shorthand == APIC_DEST_SELF) {
> -               *r = kvm_apic_set_irq(src->vcpu, irq, dest_map);
> -               return true;
> -       }
> -
>         rcu_read_lock();
>         map = rcu_dereference(kvm->arch.apic_map);
>
> --
> 2.7.4
>
