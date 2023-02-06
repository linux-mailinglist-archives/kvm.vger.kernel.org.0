Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2335768C923
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 23:10:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbjBFWJ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 17:09:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjBFWJ4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 17:09:56 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 580ED193CE
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 14:09:55 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id hx15so38329960ejc.11
        for <kvm@vger.kernel.org>; Mon, 06 Feb 2023 14:09:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=G1LkYBMzUnvZPpg21hf3csIzduke25xDGua4iz/SngY=;
        b=dOLW5p2bxLWJPrRsAxaXzgIn6sALsqt5/sB2/iavoay3YFB+jS5Y6K9iVqnkw0z10O
         bEU1ZttW3EcW/uXkwZRfp9/BqkwxIg/k3+AaC401XVcLYc4JyVA7B1igCH+xX0ZifjaT
         QI0OSI2LLTwkmgIL7vDpfX2tfZvzSJ1SosJSlGYwRyCdnqRRK1HRv+ARTP1JGgKIY/j1
         M5HSzluIOMkynnmroJMPLl+CLhZ+2mzzUxGRQaS8kFfeM/6vDaYVZOBawXD6zgxHQt4H
         PchBc4lSGfNBTrT/vEJo88iubU9CL2yRP9064FHZocCs2Or3bh7OpHwJ74/netJBLbn0
         WRgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G1LkYBMzUnvZPpg21hf3csIzduke25xDGua4iz/SngY=;
        b=XdEYzyY7Dy2l3Oz5MdrL4ynHqI4EoOV5tsJUV0dNNtNcrH3FhMhbTwHNSPtjWmbpfv
         CerngYY8YgYOfpXTk+Hp50wFpu2SJ0k0Pyaf8tRQtDs+O6XcGjJvhBoF3d/PZKDDllon
         UKnbxkqC0ZN2hnk4LagSoajet/Z0Gxm7B9c7lxFK2+XNj5p34HOlVYdT240Uja/FplEV
         LJIuuk0tkXhunM+ISGOkaJCGrvZ/MgMqGFVGNHszTdBd1x21z277ucZDZFHEnkj1DN/D
         MZ9ocR0BAtUTXHwpMcN0EvuJzJ6/plFYzwUJJbOu+yRteL+XcQoGUXBjgxbtdf45cZMW
         WLbw==
X-Gm-Message-State: AO0yUKXIMl8rRhX6HRrTJKga1WSUwath2O0s5ia8SAxLkeABF3oqmPS7
        6nf2V4f4p8FW9feJ/0mgsD41oxEd8QBUdN5TECpEqA==
X-Google-Smtp-Source: AK7set/c+UHD7xkKe6lZOTS37E3fyy3cDZMT9ZpEpAZGrTWHeVKdFIg0YdFToJePztzN5ReERwKKgqx4cLo1HeI1xWY=
X-Received: by 2002:a17:906:3008:b0:878:8bd5:4bdf with SMTP id
 8-20020a170906300800b008788bd54bdfmr260121ejz.270.1675721393843; Mon, 06 Feb
 2023 14:09:53 -0800 (PST)
MIME-Version: 1.0
References: <20230203192822.106773-1-vipinsh@google.com> <20230203192822.106773-2-vipinsh@google.com>
In-Reply-To: <20230203192822.106773-2-vipinsh@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 6 Feb 2023 14:09:42 -0800
Message-ID: <CANgfPd-spmT1m9kGacpon9jmz-4YA_pwgp93xJGHrrS-2+F99g@mail.gmail.com>
Subject: Re: [Patch v2 1/5] KVM: x86/mmu: Make separate function to check for
 SPTEs atomic write conditions
To:     Vipin Sharma <vipinsh@google.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, dmatlack@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 3, 2023 at 11:28 AM Vipin Sharma <vipinsh@google.com> wrote:
>
> Move condition checks in kvm_tdp_mmu_write_spte() for writing spte
> atomically in a separate function.
>
> New function will be used in future commits to clear bits in SPTE.
>
> Signed-off-by: Vipin Sharma <vipinsh@google.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

> ---
>  arch/x86/kvm/mmu/tdp_iter.h | 16 +++++++++++-----
>  1 file changed, 11 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
> index f0af385c56e0..30a52e5e68de 100644
> --- a/arch/x86/kvm/mmu/tdp_iter.h
> +++ b/arch/x86/kvm/mmu/tdp_iter.h
> @@ -29,11 +29,10 @@ static inline void __kvm_tdp_mmu_write_spte(tdp_ptep_t sptep, u64 new_spte)
>         WRITE_ONCE(*rcu_dereference(sptep), new_spte);
>  }
>
> -static inline u64 kvm_tdp_mmu_write_spte(tdp_ptep_t sptep, u64 old_spte,
> -                                        u64 new_spte, int level)
> +static inline bool kvm_tdp_mmu_spte_has_volatile_bits(u64 old_spte, int level)
>  {
>         /*
> -        * Atomically write the SPTE if it is a shadow-present, leaf SPTE with
> +        * Atomically write SPTEs if it is a shadow-present, leaf SPTE with

Nit: SPTEs must be modified atomically if they are shadow-present,
leaf SPTEs with

>          * volatile bits, i.e. has bits that can be set outside of mmu_lock.
>          * The Writable bit can be set by KVM's fast page fault handler, and
>          * Accessed and Dirty bits can be set by the CPU.
> @@ -44,8 +43,15 @@ static inline u64 kvm_tdp_mmu_write_spte(tdp_ptep_t sptep, u64 old_spte,
>          * logic needs to be reassessed if KVM were to use non-leaf Accessed
>          * bits, e.g. to skip stepping down into child SPTEs when aging SPTEs.
>          */
> -       if (is_shadow_present_pte(old_spte) && is_last_spte(old_spte, level) &&
> -           spte_has_volatile_bits(old_spte))
> +       return is_shadow_present_pte(old_spte) &&
> +              is_last_spte(old_spte, level) &&
> +              spte_has_volatile_bits(old_spte);
> +}
> +
> +static inline u64 kvm_tdp_mmu_write_spte(tdp_ptep_t sptep, u64 old_spte,
> +                                        u64 new_spte, int level)
> +{
> +       if (kvm_tdp_mmu_spte_has_volatile_bits(old_spte, level))
>                 return kvm_tdp_mmu_write_spte_atomic(sptep, new_spte);
>
>         __kvm_tdp_mmu_write_spte(sptep, new_spte);
> --
> 2.39.1.519.gcb327c4b5f-goog
>
