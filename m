Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E27220454B
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 02:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731568AbgFWA1L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 20:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731260AbgFWA1L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 20:27:11 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20C23C061573;
        Mon, 22 Jun 2020 17:27:10 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id a3so17376399oid.4;
        Mon, 22 Jun 2020 17:27:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fWf5NkTENMUpC6O7J3lNfTxHfRDt4jLtoXQpvqrBTOY=;
        b=pFf7M/f58ncrECYTkyPx3dYKwvWKkZ4WIjMzLLbRJICkmQ/Xf/tJGa1boVcCzgIPtm
         oT2+gIxCqbBbpHQDrmF4ROzNpN/VgKXh3fPA9oDIYXv93qACbNqdMTIzoP72wFoFRlY2
         RuvRKEvtPM21n0wZXuXzuox1cnBjmU46C3qne4lrlirUKbU8FmN8erboc0GVKtM6B7K6
         Rwgqye5s8oNUsZni7OYlU3cgosNaPb7meZSJt2htccGr6v1yfeSILBciGpAXFyFzojkd
         mgxFJOGq9fa8RC9U7gfVY/ZMpIzonT01Qj78cblJbnpHFQ0jGObXtqjoP8HBKb3+4YPG
         rn7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fWf5NkTENMUpC6O7J3lNfTxHfRDt4jLtoXQpvqrBTOY=;
        b=KUtWPzH1u9Te6ag3h16skVO7UkcdMFb4ueP2cxFDapSgILdZ0NmcbEOkCLvdbVqcCR
         KrTaujGNVgXmEHAInaXtS0Ju0ie74s+q8RnI9iIb0icVoUeVilkI4kCo7cjfpA2tdMD6
         psA7fAMEe56RPsM6SOGMWqQ1nDTqXcQkBY4K0PcXVN/5Y8bj8gyBUTvVDxw/EiMHAv4K
         kixI+rYnLbk2tHEivMcDVpF8SL8Y6eCX2Ypu15hVdzuBSOkfLtVySxvvwT6DjuX7htwu
         mW15m7QK4KWub+60SRXUah4dpEGgpPh36F7TWK8W5g4ABI8piOHcFpXJatPHNBO2jRYo
         gAhw==
X-Gm-Message-State: AOAM532ZSb1ojllD60hvTmyALLOCvx3pBjdpeKyHOzsGqrZ2WkkXRNQZ
        yKX9keeY8WkN5/r29V295jx4f8XnXu+0z2Zf+M4=
X-Google-Smtp-Source: ABdhPJxbximI8yO3Ccy4jm1VK5GgFD3Qhrn8p/t7ScmpCFBOc5vwAMc+JrBhgmqspRlstnBk2vY411WTzWA3pMblbvg=
X-Received: by 2002:aca:58c3:: with SMTP id m186mr14874684oib.5.1592872029524;
 Mon, 22 Jun 2020 17:27:09 -0700 (PDT)
MIME-Version: 1.0
References: <20200622145953.41931-1-pbonzini@redhat.com>
In-Reply-To: <20200622145953.41931-1-pbonzini@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 23 Jun 2020 08:26:59 +0800
Message-ID: <CANRm+CyvtURKCMmpPvm-LPL6aqR5Qp2teL9pD7L8ufGWOM0LeQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: LAPIC: ensure APIC map is up to date on concurrent
 update requests
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Igor Mammedov <imammedo@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 22 Jun 2020 at 23:01, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> The following race can cause lost map update events:
>
>          cpu1                            cpu2
>
>                                 apic_map_dirty = true
>   ------------------------------------------------------------
>                                 kvm_recalculate_apic_map:
>                                      pass check
>                                          mutex_lock(&kvm->arch.apic_map_lock);
>                                          if (!kvm->arch.apic_map_dirty)
>                                      and in process of updating map
>   -------------------------------------------------------------
>     other calls to
>        apic_map_dirty = true         might be too late for affected cpu
>   -------------------------------------------------------------
>                                      apic_map_dirty = false
>   -------------------------------------------------------------
>     kvm_recalculate_apic_map:
>     bail out on
>       if (!kvm->arch.apic_map_dirty)
>
> To fix it, record the beginning of an update of the APIC map in
> apic_map_dirty.  If another APIC map change switches apic_map_dirty
> back to DIRTY, kvm_recalculate_apic_map should not make it CLEAN and
> let the other caller go through the slow path.
>
> Reported-by: Igor Mammedov <imammedo@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 +-
>  arch/x86/kvm/lapic.c            | 45 +++++++++++++++++++--------------
>  2 files changed, 27 insertions(+), 20 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 1da5858501ca..d814032a81e7 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -943,7 +943,7 @@ struct kvm_arch {
>         atomic_t vapics_in_nmi_mode;
>         struct mutex apic_map_lock;
>         struct kvm_apic_map *apic_map;
> -       bool apic_map_dirty;
> +       atomic_t apic_map_dirty;
>
>         bool apic_access_page_done;
>         unsigned long apicv_inhibit_reasons;
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 34a7e0533dad..ef98f2fd3bbd 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -169,6 +169,18 @@ static void kvm_apic_map_free(struct rcu_head *rcu)
>         kvfree(map);
>  }
>
> +/*
> + * CLEAN -> DIRTY and UPDATE_IN_PROGRESS -> DIRTY changes happen without a lock.
> + *
> + * DIRTY -> UPDATE_IN_PROGRESS and UPDATE_IN_PROGRESS -> CLEAN happen with
> + * apic_map_lock_held.
> + */
> +enum {
> +       CLEAN,
> +       UPDATE_IN_PROGRESS,
> +       DIRTY
> +};

Great! Thanks for the fix.

    Wanpeng
