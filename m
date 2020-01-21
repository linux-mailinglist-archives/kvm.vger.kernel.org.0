Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22711144321
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2020 18:24:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729238AbgAURYU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jan 2020 12:24:20 -0500
Received: from mail-vk1-f195.google.com ([209.85.221.195]:36687 "EHLO
        mail-vk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729108AbgAURYU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jan 2020 12:24:20 -0500
Received: by mail-vk1-f195.google.com with SMTP id i4so1124221vkc.3
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2020 09:24:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tmdQR2X4duHrdLuoSZ/99xX/Rb3XYACDrTpOQDSPPpk=;
        b=N8TlBVJ+RMFuLiUDyVPR+fK0vFsRsKWj9y3/4PyfmN2wTHga8WAUwT9hKbEJx1on9V
         SvRUI52PCTIHdKxIRNdClQosLyJJ0UQhkhEk+eGrvXKyPRyz4AX6C9V1970RYoJZE16A
         /zkjiXW+SuelLVZtQYh02zwAJ3SQgPGM2oRZ//PkRpTb3o4/RVE/db1Su7P86+zKbtz1
         4PLuBDedh50fkg8wg9Bz3P1P2iiaVq9izsWYAiSArq56jDESMXHk1lww89VpYQVCmOlp
         /DfUlTujPrkMTB2NI1lqqZbnlCDYdMT3LLuS+FOOgjTREIfesBjVL24O1CLnZyHTpR/W
         fD0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tmdQR2X4duHrdLuoSZ/99xX/Rb3XYACDrTpOQDSPPpk=;
        b=B5m11858tUVCiTr7CBaPU8dco+GPkan7MDLJTtX1mxYMQQQ6W1x1E2KHbrZ7SDke7+
         cjzEcxvstzMcgzMmjs65bdOMeo8HWLhNHoE7UExZXjYiWg9pqTTqgvPwCoHh+97gEwOC
         jYnaWQaX7g8dUMOSWnsrLByLaPr0OybiQvVxTryeQq2zHLE0uWMxPGXIxOQB1MkViV+I
         WMM4GqUJPE39lWTNpE6IGhCYa9hh2JombZCgKfnJew8LaaNieemLba/mrs/OM02jdJiz
         ARvWDQcfbGWuUe/tEFfD+evI7uql/y5t0olMxtz+dU4vH8kHcJ0qJQS1KOQHOUlGPzGA
         FJ5w==
X-Gm-Message-State: APjAAAUrQFna5MsBzUjQWT6sGRaZfqa2F1VuMeZIOhBuE08n8mRz/hiJ
        e3ExDJuaJp8CLbRGmsg9OXFkuk/9tWQQ3zM+a+Lvaw==
X-Google-Smtp-Source: APXvYqx2UBGD7SVo9IfIYzSF7rmUWtk38deKTni6PIDPPto8tFZLFhFMv7Tcu6XYMHG0ayL8XaGVVbosi7qBmrDNogo=
X-Received: by 2002:a1f:434b:: with SMTP id q72mr3398984vka.53.1579627458543;
 Tue, 21 Jan 2020 09:24:18 -0800 (PST)
MIME-Version: 1.0
References: <1579623061-47141-1-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1579623061-47141-1-git-send-email-pbonzini@redhat.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Tue, 21 Jan 2020 09:24:07 -0800
Message-ID: <CANgfPd8fq7pWe00fKm7QEiOAVFuubSQ-jJxEM1sCKzqJk9rSzw@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: fix overlap between SPTE_MMIO_MASK and generation
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 21, 2020 at 8:11 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> The SPTE_MMIO_MASK overlaps with the bits used to track MMIO
> generation number.  A high enough generation number would overwrite the
> SPTE_SPECIAL_MASK region and cause the MMIO SPTE to be misinterpreted;
> likewise, setting bits 52 and 53 would also cause an incorrect generation
> number to be read from the PTE.
>
> Fixes: 6eeb4ef049e7 ("KVM: x86: assign two bits to track SPTE kinds")
> Reported-by: Ben Gardon <bgardon@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 57e4dbddba72..e34ca43d9166 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -418,22 +418,25 @@ static inline bool is_access_track_spte(u64 spte)
>   * requires a full MMU zap).  The flag is instead explicitly queried when
>   * checking for MMIO spte cache hits.
>   */
> -#define MMIO_SPTE_GEN_MASK             GENMASK_ULL(18, 0)
> +#define MMIO_SPTE_GEN_MASK             GENMASK_ULL(17, 0)

I see you're shifting the MMIO high gen mask region to avoid having to
shift it by 2. Looking at the SDM, I believe using bit 62 for the
generation number is safe, but I don't recall why it wasn't used
before.

>
>  #define MMIO_SPTE_GEN_LOW_START                3
>  #define MMIO_SPTE_GEN_LOW_END          11
>  #define MMIO_SPTE_GEN_LOW_MASK         GENMASK_ULL(MMIO_SPTE_GEN_LOW_END, \
>                                                     MMIO_SPTE_GEN_LOW_START)
>
> -#define MMIO_SPTE_GEN_HIGH_START       52
> -#define MMIO_SPTE_GEN_HIGH_END         61
> +/* Leave room for SPTE_SPECIAL_MASK.  */
> +#define MMIO_SPTE_GEN_HIGH_START       54
> +#define MMIO_SPTE_GEN_HIGH_END         62
>  #define MMIO_SPTE_GEN_HIGH_MASK                GENMASK_ULL(MMIO_SPTE_GEN_HIGH_END, \
>                                                     MMIO_SPTE_GEN_HIGH_START)
> +
>  static u64 generation_mmio_spte_mask(u64 gen)
>  {
>         u64 mask;
>
>         WARN_ON(gen & ~MMIO_SPTE_GEN_MASK);
> +       BUILD_BUG_ON(MMIO_SPTE_GEN_HIGH_START < PT64_SECOND_AVAIL_BITS_SHIFT);

Would it be worth defining the MMIO_SPTE_GEN masks, SPTE_SPECIAL_MASK,
SPTE_AD masks, and SPTE_MMIO_MASK in terms of
PT64_SECOND_AVAIL_BITS_SHIFT? It seems like that might be a more
robust assertion here.

Alternatively, BUILD_BUG_ON((MMIO_SPTE_GEN_HIGH_MASK |
MMIO_SPTE_GEN_LOW_MASK) & SPTE_(MMIO and/or SPECIAL)_MASK)

>
>         mask = (gen << MMIO_SPTE_GEN_LOW_START) & MMIO_SPTE_GEN_LOW_MASK;
>         mask |= (gen << MMIO_SPTE_GEN_HIGH_START) & MMIO_SPTE_GEN_HIGH_MASK;
> --
> 1.8.3.1
>
