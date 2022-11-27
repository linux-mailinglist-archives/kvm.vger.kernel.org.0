Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 888FD639A8C
	for <lists+kvm@lfdr.de>; Sun, 27 Nov 2022 13:37:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbiK0Mhh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Nov 2022 07:37:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiK0Mhg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Nov 2022 07:37:36 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFEDEE43
        for <kvm@vger.kernel.org>; Sun, 27 Nov 2022 04:37:30 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id gu23so1582846ejb.10
        for <kvm@vger.kernel.org>; Sun, 27 Nov 2022 04:37:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4/jGKMCRGMK21dJ1aCsortAFYXlCDfIKm1QYzbvgS2c=;
        b=NXW07i+fE98DmbrjPPH7Em35P9hSzgrdqGIspcOhXrHkH45LeFM4Ma9uzZyAwqM4nf
         kyHZcHVZQ1ODY5HvfgpH4tf0q9xmXaYsadXiJ2GiCNZJc6afvbPIBI2MpVA3erqHSLHh
         avQgmwPVPhy4KbRq8MyOqZgeDlD0go2IT9WzVsg6H0KLZvi28SmzjLXYSgGXQc56bPxf
         QbY9ctnOfmjk+u3nn0U62MaQYdOCmmXRjY8Ry+Wt6D7WJgvoS+AnDPIUF72yvcNaWI9v
         4rMQrMMoaClwCzyhv/QQ/ZRUTma6IYKY06rC0CLInBNvwAxwASr84tfas+Z+J1NvjEQZ
         PCUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4/jGKMCRGMK21dJ1aCsortAFYXlCDfIKm1QYzbvgS2c=;
        b=cNzC4h2dbOss7GXWxy5TEOOmKJf+ZqudyA54C7b8uqfEKmggcgXT1m3FVbrf0dkVLF
         3x8eMOPUf95lK0lNhEXLQ8lC88/dyfXupMpg6mntKdZUEwOMCUZfCxAuY0nMfmhbpLcA
         WxtKBp0CAofna7C+eyNalQbdEGHPDrbmKNesEgj5aVFCWrmEPiMD+Wjvt6O7AbNJPhLQ
         o3xG4moEwg1FvaIghFM7TjVzStf2Hj4XLpkTfKsFkQaMJvHT2qaNsPQXrlKyiM/JLG/z
         /POZW+YuNUoDQw6O0bbbkLojxhNvkj4p3PQecVZy290qOpzUhz955N797CX5XaSNKqyu
         EZog==
X-Gm-Message-State: ANoB5pnrHqYd1SDMrHzYoqQ+VgQbM4BkL5mtH1voYNAKM8NGKTcDt21Z
        wm1rw5yr1bsK1iH3QxgEfZbq0049MXHlQQigXk/pPg==
X-Google-Smtp-Source: AA0mqf5TLdtOn1SM7fZHuK8d3xbApVAEEoYMbYRU6OCiFSk08wOADH6h3JlS7ZP3Y0sl9LqAOTiR03Ho+7xq3BMoelQ=
X-Received: by 2002:a17:906:6dd5:b0:78d:a633:b55 with SMTP id
 j21-20020a1709066dd500b0078da6330b55mr41141442ejt.106.1669552649306; Sun, 27
 Nov 2022 04:37:29 -0800 (PST)
MIME-Version: 1.0
References: <c5e918630ba37273d7b0f4e4dbb6f90d4c2f321d.1668347565.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <c5e918630ba37273d7b0f4e4dbb6f90d4c2f321d.1668347565.git.christophe.jaillet@wanadoo.fr>
From:   Anup Patel <anup@brainfault.org>
Date:   Sun, 27 Nov 2022 18:07:17 +0530
Message-ID: <CAAhSdy1JPKwknR7HrNXkcBxL3QoVDAAzFthDS6nCocnzJor0XA@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: KVM: Simplify kvm_arch_prepare_memory_region()
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Nov 13, 2022 at 7:22 PM Christophe JAILLET
<christophe.jaillet@wanadoo.fr> wrote:
>
> In kvm_arch_prepare_memory_region(), if no error occurs, a spin_lock()/
> spin_unlock() call can be avoided.
>
> Switch to kvm_riscv_gstage_iounmap() that is the same as the current code,
> but with a better semantic.
> It also embeds the locking logic. So it is avoided if ret == 0.
>
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Looks good to me.

Reviewed-by: Anup Patel <anup@brainfault.org>

I have tested this on QEMU virt machine for RV64.

Queued this patch for Linux-6.2

Thanks,
Anup

> ---
> I don't use cross-compiler, so this patch is NOT even compile tested.
> ---
>  arch/riscv/kvm/mmu.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> index 3620ecac2fa1..c8834e463763 100644
> --- a/arch/riscv/kvm/mmu.c
> +++ b/arch/riscv/kvm/mmu.c
> @@ -537,10 +537,8 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>         if (change == KVM_MR_FLAGS_ONLY)
>                 goto out;
>
> -       spin_lock(&kvm->mmu_lock);
>         if (ret)
> -               gstage_unmap_range(kvm, base_gpa, size, false);
> -       spin_unlock(&kvm->mmu_lock);
> +               kvm_riscv_gstage_iounmap(kvm, base_gpa, size);
>
>  out:
>         mmap_read_unlock(current->mm);
> --
> 2.34.1
>
