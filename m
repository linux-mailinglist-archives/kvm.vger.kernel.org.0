Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1265224F21A
	for <lists+kvm@lfdr.de>; Mon, 24 Aug 2020 07:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbgHXFPT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Aug 2020 01:15:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725998AbgHXFPQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Aug 2020 01:15:16 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 413FBC061573;
        Sun, 23 Aug 2020 22:15:16 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id h16so6318664oti.7;
        Sun, 23 Aug 2020 22:15:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yx7Nja45rwc9KndWWKuV55iUZandynQREVAn0nYKVuk=;
        b=cSomIGIf8KOoETBTP6JIIJa/eD+yEKn3iUZtr+LbI5lUEyxPqzTw4jF+RERLSwaKzW
         OxRAsveJueQVlAqb8pHbOFEdGrpF4H87u1Grr/1ZLeq+A59/HX5JwfBe+TqMnd8WJjCh
         5z6W6RvA2XGnPIItpcdANYRUZxKMBqnpzSZC4fZlPkvpsIIGf53P6Xt7xsZfjTeOb8TF
         26iQQ/pCUdkau90cYFtlxBOxCYRT5dmiex/XPCdnpSZmz+XtfRGd22araX3zKVAmcPCQ
         HduwMR7051yldSeel6EtqyuZU9f8OnvTXjDwzx3dS1ZKm2NV8zZXfDY1HYzJd3tM9QK5
         1tdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yx7Nja45rwc9KndWWKuV55iUZandynQREVAn0nYKVuk=;
        b=aihT5ivXnUmc7EMxmwv6BQKTVdtgcicK//le9wQnBTjvURzdgdqpMOCXpGILTdligY
         x8ZYifYuEiLOUdNOwXbGlBKYFUxoQaSxFJFAqWi+14jiIufWJ6BicK9CMN3Z0L+n58zZ
         EKyLgwq3aU5RvZCESJHdo1dGx8cLy5adT1tPIaSgjufCuamVdGXGQuZwf0gV8/w9tr/u
         S5jlXgGdwYjzIpweOhsMNaGN4EBfa5Z/J93V7C7iKANOj+8oqEzk7e1n28S2fgPJE4vC
         cIaDLfyW6viq6pdkSuvs7cxTJI266nwc02G3sYyzkMKMQJTH0PWQqpX4odmAdDhJWsN0
         xGZA==
X-Gm-Message-State: AOAM531Mx5liVgsA+O5klNjUkjoECp1/Jf46D3Q6ID20zV7aeISFrgBH
        PYQjn1rzdhuGOJkfBE4wr93KRi6nqA+Bc3cVcpaAqU/QTEM=
X-Google-Smtp-Source: ABdhPJxcqEeDQEdj+hF2nYVhxLQiUEoqEB5DeXrTNaZDVtGYohpjkaMJckJhFpK6zABo4imVtff0XKPQOAMKz19uMcE=
X-Received: by 2002:a9d:51c7:: with SMTP id d7mr563835oth.56.1598246114010;
 Sun, 23 Aug 2020 22:15:14 -0700 (PDT)
MIME-Version: 1.0
References: <1598230996-17097-1-git-send-email-wanpengli@tencent.com>
In-Reply-To: <1598230996-17097-1-git-send-email-wanpengli@tencent.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Mon, 24 Aug 2020 13:15:03 +0800
Message-ID: <CANRm+CyhkOAFUczm4vr0J9KubKGSTz84rsWHOBFujZM05gQWVw@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: LAPIC: Narrow down the kick target vCPU
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

On Mon, 24 Aug 2020 at 09:03, Wanpeng Li <kernellwp@gmail.com> wrote:
>
> From: Wanpeng Li <wanpengli@tencent.com>
>
> The kick after setting KVM_REQ_PENDING_TIMER is used to handle the timer
> fires on a different pCPU which vCPU is running on, this kick is expensive
> since memory barrier, rcu, preemption disable/enable operations. We don't
> need this kick when injecting already-expired timer, we also should call
> out the VMX preemption timer case, which also passes from_timer_fn=false
> but doesn't need a kick because kvm_lapic_expired_hv_timer() is called
> from the target vCPU.
>

I miss Sean's reviewed-by tag.

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>

> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
> v1 -> v2:
>  * update patch subject and changelog
>  * open code kvm_set_pending_timer()
>
>  arch/x86/kvm/lapic.c | 4 +++-
>  arch/x86/kvm/x86.c   | 6 ------
>  arch/x86/kvm/x86.h   | 1 -
>  3 files changed, 3 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 248095a..97f1dbf 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1642,7 +1642,9 @@ static void apic_timer_expired(struct kvm_lapic *apic, bool from_timer_fn)
>         }
>
>         atomic_inc(&apic->lapic_timer.pending);
> -       kvm_set_pending_timer(vcpu);
> +       kvm_make_request(KVM_REQ_PENDING_TIMER, vcpu);
> +       if (from_timer_fn)
> +               kvm_vcpu_kick(vcpu);
>  }
>
>  static void start_sw_tscdeadline(struct kvm_lapic *apic)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 599d732..51b74d0 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1778,12 +1778,6 @@ static s64 get_kvmclock_base_ns(void)
>  }
>  #endif
>
> -void kvm_set_pending_timer(struct kvm_vcpu *vcpu)
> -{
> -       kvm_make_request(KVM_REQ_PENDING_TIMER, vcpu);
> -       kvm_vcpu_kick(vcpu);
> -}
> -
>  static void kvm_write_wall_clock(struct kvm *kvm, gpa_t wall_clock)
>  {
>         int version;
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 995ab69..ea20b8b 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -246,7 +246,6 @@ static inline bool kvm_vcpu_latch_init(struct kvm_vcpu *vcpu)
>         return is_smm(vcpu) || kvm_x86_ops.apic_init_signal_blocked(vcpu);
>  }
>
> -void kvm_set_pending_timer(struct kvm_vcpu *vcpu);
>  void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip);
>
>  void kvm_write_tsc(struct kvm_vcpu *vcpu, struct msr_data *msr);
> --
> 2.7.4
>
