Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBC4F572ACE
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 03:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233574AbiGMB1Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 21:27:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232959AbiGMB1V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 21:27:21 -0400
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A99F7C0538
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 18:27:19 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-31c89653790so98386327b3.13
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 18:27:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O6Fb5kdDCzIcZYHFeEW4xnlDCtrbfEUSZ89mCxSxM4U=;
        b=U7GU/80S5PF/Y/UFmAd5On+6dzTOUoAJ+UPgxPkS2vWeSk+UJ8PEesF+HiLc02npVF
         jXmyfWerXMCr8I6rUSP8X1NPzqubVYyA8R7YkPPabltR4+u0u5ufT1RBOqROeGeslukO
         s2PLDi38lkq8jacaFoFoLKljF4Ml72MUo3us8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O6Fb5kdDCzIcZYHFeEW4xnlDCtrbfEUSZ89mCxSxM4U=;
        b=xu419uxl/Nj62FTC68ZXOSSSr0uGTEru7JHEcOesHEsUv8FR87zRu9GNfeqSxA6UIN
         ki2tCj91z0opjPlRXnEB2xl+NzlPg6Bgka3kfKLmWZttJiwh40uSxU5RSkMPUfEUR9wh
         FJj6khJdKNBPqmhMuxHXScrzNLjXAZo7w6w24VTlzQFiRajBp0apw1zxxP32f2pQAEED
         H42vSJFfiRukUBMzN5nVYFHDXw7kmS7fDUPC48dZ/EzprA7dxl2F6LIIgwEomqYcbVeg
         YT4cCqcoxIalTXsBURJKY9kLGR2r7ZZpfiBkmXZiIjTz4dUdYByigMFepxrp1zzCwPcS
         OqaQ==
X-Gm-Message-State: AJIora9CZP1SFMTChk4MzUh5q9iirhYBiU6sBoRsFr+blQzXIJfZ54jl
        NHWTvnlITDG6+7RehvfLKk+d+6uKQthtm5q3tU+y
X-Google-Smtp-Source: AGRyM1uY97y6sOBUOBIPOpMq1dZTliITUmcqgV6XmN+IV0YaY1ZeSiYUFRGg10w5SJ7xtz9TGki4LlEsS+A0cypUS6Q=
X-Received: by 2002:a81:134c:0:b0:31c:bd8c:eeb1 with SMTP id
 73-20020a81134c000000b0031cbd8ceeb1mr1471755ywt.274.1657675638935; Tue, 12
 Jul 2022 18:27:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220707145248.458771-1-apatel@ventanamicro.com> <20220707145248.458771-2-apatel@ventanamicro.com>
In-Reply-To: <20220707145248.458771-2-apatel@ventanamicro.com>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Tue, 12 Jul 2022 18:27:08 -0700
Message-ID: <CAOnJCUKNaNz0iF5dfS9quRyDS_ZD1adWWAFjOnBPwqKEefpS8Q@mail.gmail.com>
Subject: Re: [PATCH 1/5] KVM: Add gfp_custom flag in struct kvm_mmu_memory_cache
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>,
        KVM General <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 7, 2022 at 7:53 AM Anup Patel <apatel@ventanamicro.com> wrote:
>
> The kvm_mmu_topup_memory_cache() always uses GFP_KERNEL_ACCOUNT for
> memory allocation which prevents it's use in atomic context. To address
> this limitation of kvm_mmu_topup_memory_cache(), we add gfp_custom flag
> in struct kvm_mmu_memory_cache. When the gfp_custom flag is set to some
> GFP_xyz flags, the kvm_mmu_topup_memory_cache() will use that instead of
> GFP_KERNEL_ACCOUNT.
>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  include/linux/kvm_types.h | 1 +
>  virt/kvm/kvm_main.c       | 4 +++-
>  2 files changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
> index ac1ebb37a0ff..1dcfba68076a 100644
> --- a/include/linux/kvm_types.h
> +++ b/include/linux/kvm_types.h
> @@ -87,6 +87,7 @@ struct gfn_to_pfn_cache {
>  struct kvm_mmu_memory_cache {
>         int nobjs;
>         gfp_t gfp_zero;
> +       gfp_t gfp_custom;
>         struct kmem_cache *kmem_cache;
>         void *objects[KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE];
>  };
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index a49df8988cd6..e3a6f7647474 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -386,7 +386,9 @@ int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
>         if (mc->nobjs >= min)
>                 return 0;
>         while (mc->nobjs < ARRAY_SIZE(mc->objects)) {
> -               obj = mmu_memory_cache_alloc_obj(mc, GFP_KERNEL_ACCOUNT);
> +               obj = mmu_memory_cache_alloc_obj(mc, (mc->gfp_custom) ?
> +                                                mc->gfp_custom :
> +                                                GFP_KERNEL_ACCOUNT);
>                 if (!obj)
>                         return mc->nobjs >= min ? 0 : -ENOMEM;
>                 mc->objects[mc->nobjs++] = obj;
> --
> 2.34.1
>

Acked-by: Atish Patra <atishp@rivosinc.com>

-- 
Regards,
Atish
