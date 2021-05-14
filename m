Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2C8E3812DF
	for <lists+kvm@lfdr.de>; Fri, 14 May 2021 23:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232810AbhENVeX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 May 2021 17:34:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230309AbhENVeW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 May 2021 17:34:22 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9032EC06174A
        for <kvm@vger.kernel.org>; Fri, 14 May 2021 14:33:10 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id x19so360211lfa.2
        for <kvm@vger.kernel.org>; Fri, 14 May 2021 14:33:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DgAKwIM9zch8xYFNPJtzcIGRCfmQye33dMFzHuDOjA8=;
        b=Ma9YTpFKv2FKqspm+/+nOYKxqwaYNdETxuDqxtZyA7ZnVB17mpdfo0ZQZ1QAMyP7bQ
         2NoTwneXD9c+6ebVHoiqc6oePXLumrECPiQv+8vOzySGekm4yv4qyr/1A5OQgNBWIdOc
         GC91s86KWPnv8OcKzcAtpmA6LtDhi2dV4QHzddOOZPk3XWb4BwhtopFJddjuMGi0t41q
         Jt0ib/JJrlJ/eTK/VFDyP2XjLu/w++ESDctvgTGDtx+T4x5lrWiNYYxvwr1aWxUfB5gb
         DYjv0/UJb4ygI1UCeFfyaQGMxfketFlRyTTSsDTQ0S3dPSWKpNzYhoYbxy3ooFhgS+3n
         2mNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DgAKwIM9zch8xYFNPJtzcIGRCfmQye33dMFzHuDOjA8=;
        b=MlrOcARiK93R+Ak+PpzTwEvOY2nuH1V4ANSe9ISeaYenQMM5M1CDlskhSUQsqimLCu
         pU6o1ZFOIoWRf4RG7bM/v8K3tphPhYSsstIqJ8e3ncbNAT2u2GsaoqA5IB/nPDaEQsfc
         fBujO0zSv91Iy4iLFhqZ+kekOVEaTvOxmSnawvy/hof3HSatlYkFnoiEr/TTZY4VKyJT
         /ojWinWmC6tcloIQ71iT5Xrbfhhqoi0bcGcdcPG52yOro92hkQ/K4S6UhZzg+Js/FQl2
         imFUDRM9X+Uo2u+vZXD3mkpL1E8vK3QtjedUIZm2Y1ncdEuMQimLxPR5gA0Txj1xJ2kY
         Na6g==
X-Gm-Message-State: AOAM530JEiFdo58XNYBAOIu1xxkRNgxqMrTcJaiJeLe8Ny7mFhf2gx33
        qofg0q3NAhnlPtLA8zLq8b2ilhkHSsLgbwCtI90A3w==
X-Google-Smtp-Source: ABdhPJwaWVyRTYrod/pJttPl6eOfPN7YN4oV2Ff7Rx7cDDSMWwaxFsTSlvdmGRhuFsgKwiPdwp1Wmw5xH9pEHIajUKQ=
X-Received: by 2002:a05:6512:2243:: with SMTP id i3mr33685984lfu.46.1621027988910;
 Fri, 14 May 2021 14:33:08 -0700 (PDT)
MIME-Version: 1.0
References: <1620871189-4763-1-git-send-email-wanpengli@tencent.com>
In-Reply-To: <1620871189-4763-1-git-send-email-wanpengli@tencent.com>
From:   David Matlack <dmatlack@google.com>
Date:   Fri, 14 May 2021 14:32:42 -0700
Message-ID: <CALzav=e98KRgG+z5oezPmENKDt+NqtEA57ijYh3kMBZyduQUZg@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] KVM: X86: Bail out of direct yield in case of
 under-comitted scenarios
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 12, 2021 at 7:01 PM Wanpeng Li <kernellwp@gmail.com> wrote:
>
> From: Wanpeng Li <wanpengli@tencent.com>
>
> In case of under-comitted scenarios, vCPU can get scheduling easily,
> kvm_vcpu_yield_to adds extra overhead, we can observe a lot of race
> between vcpu->ready is true and yield fails due to p->state is
> TASK_RUNNING. Let's bail out in such scenarios by checking the length
> of current cpu runqueue, it can be treated as a hint of under-committed
> instead of guarantee of accuracy.
>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
> v1 -> v2:
>  * move the check after attempted counting
>  * update patch description
>
>  arch/x86/kvm/x86.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 9b6bca6..dfb7c32 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8360,6 +8360,9 @@ static void kvm_sched_yield(struct kvm_vcpu *vcpu, unsigned long dest_id)
>
>         vcpu->stat.directed_yield_attempted++;
>
> +       if (single_task_running())
> +               goto no_yield;

Since this is a heuristic, do you have any experimental or real world
results that show the benefit?

> +
>         rcu_read_lock();
>         map = rcu_dereference(vcpu->kvm->arch.apic_map);
>
> --
> 2.7.4
>
