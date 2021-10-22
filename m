Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F19243703D
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 04:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232645AbhJVDAs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 23:00:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232606AbhJVDAp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Oct 2021 23:00:45 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9164AC061764;
        Thu, 21 Oct 2021 19:58:28 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id w10so2760092ilc.13;
        Thu, 21 Oct 2021 19:58:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JJZ2MAKVYdxAS+mpk10bxj7MmoBWIH5E++cOcaLba/c=;
        b=BzS+0q1/cG3XY4vAHNdFz55I6gcPQ3YYDOpvYI0jPSb/NwRfQw11pNDGoC+aKT21u6
         bxSD6SuSVVS4y4V32wlvITJUrL5ZT67wVYFydmUfZvZF41y1tRWaXG0dEu30wRNq1Ntc
         xOxZnNk19L7XQM3fiDbjve2D/Y5UimCxan+Twx4V595Zt2ACFI1vNaBCzdXq2sM6RoD+
         SCGwQmdcOkr7KI1YCAbIQU8lPFO4mD+5bfT2YOP3cDarjz46e8I8Wl8PaPoGfURMNo8t
         gH8GyDtzOg8Qb8ZFmRuNy1ngAhMT7/ui6/PVqCF8ZSF36HUQNGhfyT6ot5hrEq3mzHxF
         hX9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JJZ2MAKVYdxAS+mpk10bxj7MmoBWIH5E++cOcaLba/c=;
        b=MXPGye3pjIZsZXk5sEAx9k/Gvo5eX3GTdxYzu690YVfksWu7Nuocfkz6bPnGB2QNkN
         uSbhtjMTSanWWgpD9oG5bkA0laTO9kBpddRSqkrEQgViUdagMQx9Zzea2EBBtesbcK5s
         gut6pWulQU6uzY2jztdv2dR6Zwq6HfpMhnSUyc8V4oArsq1LVc2jTxlLywOgE4TCiQSY
         mc+M3SHtgK9AX7jY+4cAoJxD5BBWiIBrJw2slF4Rn2Wgcb6skPPb7dgP1J7jsLW3/AXu
         Zv4Sg+SJwoEbB+jBYHgxt4T1XpPj5bXb3xmb0LpxY1AlLzVCqx7O9pD2u6coo+Pl5V9f
         B7Qg==
X-Gm-Message-State: AOAM5331z5tAOQTZH1/Ath89HG0Ubw5duEOaayyAx21wvKM5DHQnwwsC
        Km2B/XFnjDfbgXqViBBOO7aGr7IZ2DtZjkAmSd4=
X-Google-Smtp-Source: ABdhPJxc2Czk357aHbZ/7WTuGXgvxVMuR0piDBWRjF+zKc18a/IrPk7TSLtT0ckawNhREG8WGZdT2XPAfhoiDXCKxe8=
X-Received: by 2002:a05:6e02:687:: with SMTP id o7mr779540ils.222.1634871507725;
 Thu, 21 Oct 2021 19:58:27 -0700 (PDT)
MIME-Version: 1.0
References: <20211022010005.1454978-1-seanjc@google.com> <20211022010005.1454978-2-seanjc@google.com>
In-Reply-To: <20211022010005.1454978-2-seanjc@google.com>
From:   Lai Jiangshan <jiangshanlai+lkml@gmail.com>
Date:   Fri, 22 Oct 2021 10:58:15 +0800
Message-ID: <CAJhGHyCA-nfoJPmQxVWRtu+iJk3aj9ZdNH630RjrQJ_vYnZ3Gg@mail.gmail.com>
Subject: Re: [PATCH 1/3] KVM: x86/mmu: Drop a redundant, broken remote TLB flush
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 22, 2021 at 9:01 AM Sean Christopherson <seanjc@google.com> wrote:
>
> A recent commit to fix the calls to kvm_flush_remote_tlbs_with_address()
> in kvm_zap_gfn_range() inadvertantly added yet another flush instead of
> fixing the existing flush.  Drop the redundant flush, and fix the params
> for the existing flush.
>
> Fixes: 2822da446640 ("KVM: x86/mmu: fix parameters to kvm_flush_remote_tlbs_with_address")
> Cc: Maxim Levitsky <mlevitsk@redhat.com>
> Cc: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index c6ddb042b281..f82b192bba0b 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5709,13 +5709,11 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
>                 for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
>                         flush = kvm_tdp_mmu_zap_gfn_range(kvm, i, gfn_start,
>                                                           gfn_end, flush);
> -               if (flush)
> -                       kvm_flush_remote_tlbs_with_address(kvm, gfn_start,
> -                                                          gfn_end - gfn_start);

In the recent queue branch of kvm tree, there is the same "if (flush)" in
the previous "if (kvm_memslots_have_rmaps(kvm))" branch.  The "if (flush)"
branch needs to be removed too.

Reviewed-by: Lai Jiangshan <jiangshanlai@gmail.com>

>         }
>
>         if (flush)
> -               kvm_flush_remote_tlbs_with_address(kvm, gfn_start, gfn_end);
> +               kvm_flush_remote_tlbs_with_address(kvm, gfn_start,
> +                                                  gfn_end - gfn_start);
>
>         kvm_dec_notifier_count(kvm, gfn_start, gfn_end);
>
> --
> 2.33.0.1079.g6e70778dc9-goog
>
