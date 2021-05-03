Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F132537193A
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 18:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231262AbhECQ0t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 12:26:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231182AbhECQ0s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 May 2021 12:26:48 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DABEEC06174A
        for <kvm@vger.kernel.org>; Mon,  3 May 2021 09:25:54 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id gx5so8748322ejb.11
        for <kvm@vger.kernel.org>; Mon, 03 May 2021 09:25:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tS3zkcoQ1S7TVf3vCCwHAdoFgmASO5SUJDaez9EkAJE=;
        b=GzG56i4j4rO0Ny+1Ix7JKBON9j4ywE+7MxN+QdKuzdmGGZJce07wRmJlpJGaESiwBx
         Qq9j+JnRsFFfC8usK1e4t1AnDWCs5Duwl6QapbvYepXuQiSntxzqdE5rw4hQvMhdol2j
         31QqpaZdBYv5PrMtjntm+WJZgIwCDvycRUpHVjYRE852CCGo5SdUizSoRGUi8U7GYASS
         b0T0ZcPBGNSyUag8+hFZ8rRw9MiFSBKTXpt9KWzg2fRdDlm08qtoaW4aW5LuuzE2w8Ue
         kG63LIWSDf35Qxi7tyj+SpKxNccITZfes4svtUK6LDqpHya6pct0B0hOoVmeDYb3P7h6
         Q2wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tS3zkcoQ1S7TVf3vCCwHAdoFgmASO5SUJDaez9EkAJE=;
        b=Z1vyBEcZRmhxWASHsGsskVDhPeUZJn/r9qzbnJi1fustK7eSlXfT59kd4eosbR8RLD
         X091el57TtZCfZvciLRKo5x4SFLEeFxiKkUekwRsPM2yNctY7P1jy61O2Oe94NUccbfC
         JVzxxVhmF04PnNOpr1gUu4wBqhDWlMzy7oOFiQpTYzUeLb12Jf9DgYH9fTqn0f1QleU4
         e/12gpOtVxfjUWa246GrwpkNxIC4Fl4YXBVu032tLWcIWW/c6qYTTFojvJOrksHBsVKN
         Y1Y2xSzNFSGb2YGnDPEIhMGXlHnt7LTUzvTCL/3pmHFIVhlPYZB8toiL511whwUhehbI
         wuRg==
X-Gm-Message-State: AOAM531QjZ6rAK32jWx1BA/8AWUr+IR5QXiIAy9EPPWkfqUrEXE3MTMX
        QM5hWvZCoo1KFKKugM4BeNNINF7QWeEmNtW5YaLBIA==
X-Google-Smtp-Source: ABdhPJwxua3r05XDk/4QTb1DMRMi5tssfNp8ug2Gh1pYATvHxBHKFpxh2rwplP3Q2ryHhIIbujDGBYAjg5fgRYdLies=
X-Received: by 2002:a17:906:b191:: with SMTP id w17mr17713166ejy.200.1620059153423;
 Mon, 03 May 2021 09:25:53 -0700 (PDT)
MIME-Version: 1.0
References: <1619783551459.35424@amazon.de>
In-Reply-To: <1619783551459.35424@amazon.de>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 3 May 2021 09:25:42 -0700
Message-ID: <CANgfPd8vD2LgnPd6JyA-E3htrbKcne80Xf5x232wgtpcT_ymjw@mail.gmail.com>
Subject: Re: [PATCH v2] kvm/x86: Fix 'lpages' kvm stat for TDM MMU
To:     "Shahin, Md Shahadat Hossain" <shahinmd@amazon.de>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Szczepanek, Bartosz" <bsz@amazon.de>,
        "seanjc@google.com" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 30, 2021 at 4:52 AM Shahin, Md Shahadat Hossain
<shahinmd@amazon.de> wrote:
>
> Large pages not being created properly may result in increased memory
> access time. The 'lpages' kvm stat used to keep track of the current
> number of large pages in the system, but with TDP MMU enabled the stat
> is not showing the correct number.
>
> This patch extends the lpages counter to cover the TDP case.
>
> Signed-off-by: Md Shahadat Hossain Shahin <shahinmd@amazon.de>
> Cc: Bartosz Szczepanek <bsz@amazon.de>

Reviewed-by: Ben Gardon <bgardon@google.com>

Thanks for fixing this!

> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index bc1283ed4db6..f89a140b8dea 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -240,6 +240,13 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
>         if (old_spte == new_spte)
>                 return;
>
> +       if (is_large_pte(old_spte) != is_large_pte(new_spte)) {
> +               if (is_large_pte(old_spte))
> +                       atomic64_sub(1, (atomic64_t*)&kvm->stat.lpages);
> +               else
> +                       atomic64_add(1, (atomic64_t*)&kvm->stat.lpages);
> +       }
> +
>         /*
>          * The only times a SPTE should be changed from a non-present to
>          * non-present state is when an MMIO entry is installed/modified/
> --
> 2.17.1
>
>
>
> Amazon Development Center Germany GmbH
> Krausenstr. 38
> 10117 Berlin
> Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
> Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
> Sitz: Berlin
> Ust-ID: DE 289 237 879
>
>
>
