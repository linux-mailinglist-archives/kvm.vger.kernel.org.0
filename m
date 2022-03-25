Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18CF24E7BFF
	for <lists+kvm@lfdr.de>; Sat, 26 Mar 2022 01:21:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbiCYXyu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Mar 2022 19:54:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbiCYXys (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Mar 2022 19:54:48 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D26049CA2
        for <kvm@vger.kernel.org>; Fri, 25 Mar 2022 16:53:13 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id g24so12196040lja.7
        for <kvm@vger.kernel.org>; Fri, 25 Mar 2022 16:53:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8qXoYUkt8E2evKFcvqOeWBKlnnitRNfoGnLZMz+10kE=;
        b=OQdleKS9jBYFLVrrzj4DPCHf4gaVpqu58/EC7lxApoPXr60nb+ziM2552oK9jW2c/B
         ivMOHtTRyaNpW+GG34OG94pTLknSvunFjCnhWMHxD8gtHegvxPSYW/YhHuoNyH70mfCv
         TBchSbI1uBUcfH/frw4Xb1ROxPqwy2a8vYWETNL9+9tviD1tVELp3+7ceCGRqtDWRCKW
         30mwS4Zfjo8suRFiY0SHvhTiNbKnjmF7AMUuDTMYhwcIpvgsmh76Mbkn6djR4TWVLXAt
         tQ+Z3py7JogTT/kJ9bWxb/epg1pqGhkFEIA2LhxON0krn941lj5JLcyI18LtZawHPxdB
         yFeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8qXoYUkt8E2evKFcvqOeWBKlnnitRNfoGnLZMz+10kE=;
        b=SW9D2B29ZFc5uKsIo38NyaRzH8AGIlHpByIpWWXCVQr32YPsx6AyL+WcYF1fP+XiFl
         gZW4sXrPJecqauESsuitnwxe5sypivtneNHNg+/JzMem0ubKDmsaL20QLJq1BTamWClh
         YeHDk7MAbF3PRISni8eMzmNnxe7FR0VPRQBLqnlMveVGeez9t3mjFnYuU8KnJ4DO378z
         qm5Vxtzfe09a07w7g/T8Z1Dw4ZDMpBwZpi+fk57ZZsCzSRHNDoDuflpsc80rjgKgccea
         HlfChcA47JuTmc1Qo/bSsy6JavleH8OCAyRPfcMTWdF4qRFSlHyx549T5GJVf2Me456l
         l2Vw==
X-Gm-Message-State: AOAM533nrMNhgvgZ1yzatdrozp196/WRl5cew4717RZp05pQNz3GAU/S
        iiOgsX3hvS21LEmgoOn1hlayWdh1VTy1cOOgYksHQg==
X-Google-Smtp-Source: ABdhPJwTe3Jp4SsjbZ7FweW8j9HWkbFTY486qkS/Kbpu0+fJ9ImPAalJ2s7OU1fGNaHABBqHEZ1wUH92EdTp4sQMfTc=
X-Received: by 2002:a05:651c:988:b0:24a:c21f:7057 with SMTP id
 b8-20020a05651c098800b0024ac21f7057mr1127843ljq.16.1648252391586; Fri, 25 Mar
 2022 16:53:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220325233125.413634-1-vipinsh@google.com>
In-Reply-To: <20220325233125.413634-1-vipinsh@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Fri, 25 Mar 2022 16:52:45 -0700
Message-ID: <CALzav=e6W2VSp=btmqTpQJ=3bH+Bw3D8sLApkTTvMMKAnw_LAw@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/mmu: Speed up slot_rmap_walk_next for sparsely
 populated rmaps
To:     Vipin Sharma <vipinsh@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 25, 2022 at 4:31 PM Vipin Sharma <vipinsh@google.com> wrote:
>
> Avoid calling handlers on empty rmap entries and skip to the next non
> empty rmap entry.
>
> Empty rmap entries are noop in handlers.
>
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Change-Id: I8abf0f4d82a2aae4c5d58b80bcc17ffc30785ffc

nit: Omit Change-Id tags from upstream commits.

> ---
>  arch/x86/kvm/mmu/mmu.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 51671cb34fb6..f296340803ba 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1499,11 +1499,14 @@ static bool slot_rmap_walk_okay(struct slot_rmap_walk_iterator *iterator)
>         return !!iterator->rmap;
>  }
>
> -static void slot_rmap_walk_next(struct slot_rmap_walk_iterator *iterator)
> +static noinline void

What is the reason to add noinline?


> +slot_rmap_walk_next(struct slot_rmap_walk_iterator *iterator)
>  {
> -       if (++iterator->rmap <= iterator->end_rmap) {
> +       while (++iterator->rmap <= iterator->end_rmap) {
>                 iterator->gfn += (1UL << KVM_HPAGE_GFN_SHIFT(iterator->level));
> -               return;
> +
> +               if (iterator->rmap->val)
> +                       return;
>         }
>
>         if (++iterator->level > iterator->end_level) {
>
> base-commit: c9b8fecddb5bb4b67e351bbaeaa648a6f7456912
> --
> 2.35.1.1021.g381101b075-goog
>
