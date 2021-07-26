Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18BB93D681B
	for <lists+kvm@lfdr.de>; Mon, 26 Jul 2021 22:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232117AbhGZTnR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jul 2021 15:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbhGZTnR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jul 2021 15:43:17 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2133C061760
        for <kvm@vger.kernel.org>; Mon, 26 Jul 2021 13:23:45 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id l18so13437184ioh.11
        for <kvm@vger.kernel.org>; Mon, 26 Jul 2021 13:23:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DkoqzghGXkp4JTswxtHKmjuCRqg+mzIS/snExybiSds=;
        b=t91gofmau6rt/+T6FpafvvaxtDSRVb+jfJovRyDuaj9pHLjbE/Tn8gcKSf0oaOebtA
         W/tHTQQzX6nKQQ2S7JVijuZtmfQFewf4QQ2qarA3P+UU9l61Te5Vw1bhZOkoeiYE0KAw
         b7ukqOb8SwJ22Cci0PyvTQnqzO7Neak85q4y/kAc6yXz75ea2qqNHjzCXIqNUhk5xWZU
         lWxhZG33JXMKvovCf6tkoG74jvRC3CzISSPci2CstAbt7DPGEoLGazCqY4Q03IWIKia8
         1DxsDnvmK789LzUHZMSh5X2qUVkR38ZdgUJJbMbjydSK4EXU9E5QhE70W0Yh9SRGkA+o
         agSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DkoqzghGXkp4JTswxtHKmjuCRqg+mzIS/snExybiSds=;
        b=KxsrGO6wah6FN21XbvQ4me/D6udXTn8NjvZV1ES9VF61/d9l2oCdCqcMbdoNVs9FoS
         oV/7Rz/tIjeiFg+XXjUXyBXCr9OUUdWYdHSxg3GVEjVt+5gzKRgZ/dPfOZ62amETLFCe
         y/87khC7xmAXili0kgKJdqNC1P5wjka3ZgqcJeVYxA4FyXtp3EgwWhv7xhtaWfNi3PkR
         4Wh4aSfWYbPzWdR7iBN5crxb/PJApxEVTGUcy/Udm0X1lLRIwqYUHjTCjU95eH/wtr9n
         PjXueBle7R3n7d6zwLACzoOTokh0Lhb2f10bjI9cJ0SnjlJ0IbYRZz+GcBjLlNIYEouO
         QbwQ==
X-Gm-Message-State: AOAM531RzmEN4yDIe7SCqXTGRGFD0EUg2+GeA0aBq7V2uWeuYKPLhX+v
        IOQU+fGYA77OdIybdeQny8PJn1B0ndj3o6AvRQSCDA==
X-Google-Smtp-Source: ABdhPJwVZJ2nWBQp3UnRp9rETNq+3gaocT9GC6cbYNfkUE5vuLPdR9MQ6f4zr4kP2b4NydwDOZe5x3ndV51OWSmfodg=
X-Received: by 2002:a02:cab9:: with SMTP id e25mr17930118jap.25.1627331025078;
 Mon, 26 Jul 2021 13:23:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210726175357.1572951-1-mizhang@google.com> <20210726175357.1572951-2-mizhang@google.com>
In-Reply-To: <20210726175357.1572951-2-mizhang@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 26 Jul 2021 13:23:34 -0700
Message-ID: <CANgfPd9NG=2fCv2r9uWAoyNCKvCRnZZDizOmvY8Kx_Bt3J0vRA@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] KVM: x86/mmu: Remove redundant spte present check
 in mmu_set_spte
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 26, 2021 at 10:54 AM Mingwei Zhang <mizhang@google.com> wrote:
>
> Drop an unnecessary is_shadow_present_pte() check when updating the rmaps
> after installing a non-MMIO SPTE.  set_spte() is used only to create
> shadow-present SPTEs, e.g. MMIO SPTEs are handled early on, mmu_set_spte()
> runs with mmu_lock held for write, i.e. the SPTE can't be zapped between
> writing the SPTE and updating the rmaps.
>
> Opportunistically combine the "new SPTE" logic for large pages and rmaps.
>
> No functional change intended.
>
> Suggested-by: Ben Gardon <bgardon@google.com>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

> ---
>  arch/x86/kvm/mmu/mmu.c | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index b888385d1933..442cc554ebd6 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2690,15 +2690,13 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>
>         pgprintk("%s: setting spte %llx\n", __func__, *sptep);
>         trace_kvm_mmu_set_spte(level, gfn, sptep);
> -       if (!was_rmapped && is_large_pte(*sptep))
> -               ++vcpu->kvm->stat.lpages;
>
> -       if (is_shadow_present_pte(*sptep)) {
> -               if (!was_rmapped) {
> -                       rmap_count = rmap_add(vcpu, sptep, gfn);
> -                       if (rmap_count > RMAP_RECYCLE_THRESHOLD)
> -                               rmap_recycle(vcpu, sptep, gfn);
> -               }
> +       if (!was_rmapped) {
> +               if (is_large_pte(*sptep))
> +                       ++vcpu->kvm->stat.lpages;
> +               rmap_count = rmap_add(vcpu, sptep, gfn);
> +               if (rmap_count > RMAP_RECYCLE_THRESHOLD)
> +                       rmap_recycle(vcpu, sptep, gfn);
>         }
>
>         return ret;
> --
> 2.32.0.432.gabb21c7263-goog
>
