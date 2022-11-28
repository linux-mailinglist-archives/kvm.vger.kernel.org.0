Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6F5063B237
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 20:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232905AbiK1T1C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 14:27:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232682AbiK1T1A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 14:27:00 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 999106350
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 11:26:59 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id 11so8433050iou.0
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 11:26:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pkEMmy7WYFduFv2WCDKHcNR8tRC94HePV2GIWhSr+gA=;
        b=mo/SzO6LAu/rQzyhocBtXJFJuAg1G1w2X0JLZ/h1H+ATZiWLqo74WjDL+uUL5iQq6u
         RpUHmLGi+UcqUWjPVP977ugUFtDFl2h5Q7xzEI/JU23t817hNnezl5QmiNW36QCJ28XV
         0Jxr2bP6vmgqeiYS4Bs+xJ3eJGazfeFedeZLuJdBn0rLOK7T1eZdUqnXZy0WiiW0QtKp
         pP1Qqu6ct8MML+6mS49VQYvsFglKCgY+CBTum3/fz9Ix1ElMsFV2Ka+PNnLLvEiET5uo
         I8GFCI6J5QvBWAaPpj71gsjii4GGbWZM21wyosZG4Bvw2WVXZEF7emySzye8sgguUa4G
         hcgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pkEMmy7WYFduFv2WCDKHcNR8tRC94HePV2GIWhSr+gA=;
        b=KiHc4lvHx7aaDBkaWp2czIAxKlPz3o+c3gjWYh9b/DrhdKBd7V+UrWbx0Fny+4aBV9
         6y7Oxzl2jQbXQPN3faPCVkAaxqZ5vT/kLoZeXEktrLix7rwAe4UfGaWq+frciTZkbF1h
         29ipwlFto9S2hMGRBGtOZzIPGlA9M+UwMXWPeA/W8bNdCUjuQZlbLShURRsx3qqTc3EI
         EHuSIoszg2+XRSaLb4OZSLPd8Zhs2TaOYJFgjnogeUZ3sLuuBa83GCe7j+u2TXyMEsaD
         mybtPZAs6WH9yetnOmXa0Uff1FC3KeoBWqdfL1kEdrWRqQcByVrQNndEvqGbgV8M/S2K
         AgMw==
X-Gm-Message-State: ANoB5pnM7tZns/HXzzlhsQo7mFQG/iro/2T4vxIMxWU+AvaKFrbYnjW6
        wmgjfwLLNIVjustTwqhhtWMoXJTCwat/cbkyqMZoYQ==
X-Google-Smtp-Source: AA0mqf76sdY4Br4QKGjH6D+VOPLEHbv3zYSTjP/FtEnSqOeDX/mQffmJNHyzKYBnxrpfBEDN11gy6ARApO+L0AgEKdg=
X-Received: by 2002:a6b:fd0e:0:b0:6df:5e6c:f5c7 with SMTP id
 c14-20020a6bfd0e000000b006df5e6cf5c7mr6129780ioi.207.1669663618846; Mon, 28
 Nov 2022 11:26:58 -0800 (PST)
MIME-Version: 1.0
References: <20221128002043.1555543-1-mizhang@google.com> <20221128002043.1555543-3-mizhang@google.com>
 <Y4Tz5zd9qXBiR0Pr@google.com>
In-Reply-To: <Y4Tz5zd9qXBiR0Pr@google.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Mon, 28 Nov 2022 11:26:47 -0800
Message-ID: <CAL715WKyx2irL4CqA8WqETpuQLJMQCzw+GN8NVAN1=p7pVTkYQ@mail.gmail.com>
Subject: Re: [RFC PATCH v3 2/2] KVM: x86/mmu: replace BUG() with KVM_BUG() in
 shadow mmu
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Nagareddy Reddy <nspreddy@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>
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

> Something like this?
>
> ---
>  arch/x86/kvm/mmu/mmu.c | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index b5a44b8f5f7b..12790ccb8731 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -954,15 +954,16 @@ static void pte_list_remove(struct kvm *kvm, u64 *spte,
>         struct pte_list_desc *prev_desc;
>         int i;
>
> -       if (!rmap_head->val) {
> -               pr_err("%s: %p 0->BUG\n", __func__, spte);
> -               BUG();
> -       } else if (!(rmap_head->val & 1)) {
> +       if (KVM_BUG(!rmap_head->val, kvm, "rmap for %p is empty", spte))
> +               return;
> +
> +       if (!(rmap_head->val & 1)) {
>                 rmap_printk("%p 1->0\n", spte);
> -               if ((u64 *)rmap_head->val != spte) {
> -                       pr_err("%s:  %p 1->BUG\n", __func__, spte);
> -                       BUG();
> -               }
> +
> +               if (KVM_BUG((u64 *)rmap_head->val != spte, kvm,
> +                           "single rmap for %p doesn't match", spte))
> +                       return;
> +
>                 rmap_head->val = 0;
>         } else {
>                 rmap_printk("%p many->many\n", spte);
> @@ -979,8 +980,7 @@ static void pte_list_remove(struct kvm *kvm, u64 *spte,
>                         prev_desc = desc;
>                         desc = desc->more;
>                 }
> -               pr_err("%s: %p many->many\n", __func__, spte);
> -               BUG();
> +               KVM_BUG(true, kvm, "no rmap for %p (many->many)", spte);
>         }
>  }
>
>
> base-commit: d74237e747db7f9f27e821e6683d58185e846378
> --
>

make sense, will update that in the next version.
