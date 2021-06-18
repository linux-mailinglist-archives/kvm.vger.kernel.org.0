Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 905E33AC682
	for <lists+kvm@lfdr.de>; Fri, 18 Jun 2021 10:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231617AbhFRIwy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Jun 2021 04:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231452AbhFRIwx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Jun 2021 04:52:53 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03271C06175F
        for <kvm@vger.kernel.org>; Fri, 18 Jun 2021 01:50:44 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id h9so9805699oih.4
        for <kvm@vger.kernel.org>; Fri, 18 Jun 2021 01:50:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jdFKobz0v5eVip0thXQlonp2mF35EnH4oN1hYfZc5Y8=;
        b=eaI1qif8hWH4BDUPA4zAfU/JyLPIPsuOqFjMGM8Bena5fakXJe42h1NsUQcLTvKdJ1
         LOcf3Qw8GQpYgpe1f/t5BZwAua9NJK/G8Q5YA0x3gEUix6SK0puD0UuAtx+522RhyFpH
         v4eUaoWuflGssbIsWGhZ4Q0auBg7DdWZVHDrnnwfk2+9LefFaGFSuIuQ9zld9KS8IFv6
         Sd0rdtaCXNVsby6BzdgBjLciQorxLwS2MxQSfyQVweBhblWYkBi4L+gKasclg9l19zHq
         1GMpCGCj40H2EsIOBz8dw37C0Qe0+/jP52+2bQikzN3ft8mTNr0GKkink3eqiPd9DNE/
         sy/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jdFKobz0v5eVip0thXQlonp2mF35EnH4oN1hYfZc5Y8=;
        b=bbvADSoD7OeFC86GOaFd9L2mZsW2f1hZdD8xr9gZ6MCStqJ7P+bvTEcCF98pe1g2rm
         kA0bAbJGP7+1EgEW7cafOUqN4NURnlfsubDCm5XEe44SLKluFeKYUZZfAZAqtc33TrYK
         YoAUXsIRxmkQD34bhhKuikQlouAecn3j9F/RF8agDVAru0k9kixSdriexoSEmT2tTsAT
         P645ywlYTvE79bLJXZv3Bez5H3H/fJ42jVfDJ65Y9D5qNUMNW2rS6j4dibywX9krUw2p
         vX1DQwbdnC7BH77JT38+JrzucTZWfPZRDC2AjqvEL4rCrfy2wBj251gvZQY3rjOf9WYN
         maDg==
X-Gm-Message-State: AOAM533tOEKtuXJGiogZtSwpeqzZv7ec3pHcsc1tcvjkxS+q9zD1fizE
        FjheYdtXmznVaFt+OiGyXyX4hPagalq7gCbGnXqGbA==
X-Google-Smtp-Source: ABdhPJypyxrsFJT695FL1xens+cccnkIs+C967czc330C77nK9BPZwBZ32eYzwZk3n/kX5cAq1Thkw1gKRvl10izUa0=
X-Received: by 2002:aca:de07:: with SMTP id v7mr13635036oig.8.1624006243106;
 Fri, 18 Jun 2021 01:50:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210616095200.38008-1-wangyanan55@huawei.com> <20210616095200.38008-2-wangyanan55@huawei.com>
In-Reply-To: <20210616095200.38008-2-wangyanan55@huawei.com>
From:   Fuad Tabba <tabba@google.com>
Date:   Fri, 18 Jun 2021 09:50:06 +0100
Message-ID: <CA+EHjTyVnHkk5rYb=W6msqoT5E_bVTBdhLtpeRR_b2wsib4Vgw@mail.gmail.com>
Subject: Re: [PATCH v6 1/4] KVM: arm64: Introduce cache maintenance callbacks
 for guest stage-2
To:     Yanan Wang <wangyanan55@huawei.com>
Cc:     Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Yanan,

On Wed, Jun 16, 2021 at 10:52 AM Yanan Wang <wangyanan55@huawei.com> wrote:
>
> To prepare for performing guest CMOs in the fault handlers in pgtable.c,
> introduce two cache maintenance callbacks in struct kvm_pgtable_mm_ops.
>
> The new callbacks are specific for guest stage-2, so they will only be
> initialized in 'struct kvm_pgtable_mm_ops kvm_s2_mm_ops'.
>
> Signed-off-by: Yanan Wang <wangyanan55@huawei.com>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index c3674c47d48c..302eca32e0af 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -44,6 +44,11 @@ typedef u64 kvm_pte_t;
>   *                     in the current context.
>   * @virt_to_phys:      Convert a virtual address mapped in the current context
>   *                     into a physical address.
> + * @flush_dcache:      Clean data cache for a guest page address range before
> + *                     creating the corresponding stage-2 mapping.
> + * @flush_icache:      Invalidate instruction cache for a guest page address
> + *                     range before creating or updating the corresponding
> + *                     stage-2 mapping.
>   */
>  struct kvm_pgtable_mm_ops {
>         void*           (*zalloc_page)(void *arg);
> @@ -54,6 +59,8 @@ struct kvm_pgtable_mm_ops {
>         int             (*page_count)(void *addr);
>         void*           (*phys_to_virt)(phys_addr_t phys);
>         phys_addr_t     (*virt_to_phys)(void *addr);
> +       void            (*flush_dcache)(void *addr, size_t size);
> +       void            (*flush_icache)(void *addr, size_t size);
>  };
>

Just to add to Marc's comment on naming, flush_dcache is in this case
a clean and invalidate: I see that in patch 4 it eventually does a
civac. So, yes, although it is a mouthful, I think it should be
dcache_clean_inval and not just dcache_clean. An alternative, if it's
acceptable by Marc and the others, is to name the parameters dcmo/icmo
or something like that, where the nature of the maintenance operation
is not necessarily tied to the name.

For reference, this is the patch Marc mentioned, where we're trying to
fix the naming to make it consistent with Arm terminology (Arm doesn't
define what a flush is):
https://lore.kernel.org/linux-arm-kernel/20210524083001.2586635-19-tabba@google.com/

Otherwise:
Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


>  /**
> --
> 2.23.0
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
