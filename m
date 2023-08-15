Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFD7177C8BE
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 09:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235344AbjHOHnE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 03:43:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235391AbjHOHm4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 03:42:56 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96EA11737
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 00:42:54 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id 3f1490d57ef6-d659ad4af70so4456897276.1
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 00:42:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1692085374; x=1692690174;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bAQfC8Fk99VKXGvykRcnXCDXuQl6wZXlhTPZ78iPS24=;
        b=pAgTYUwGaIFdx5eLvLdZU3jJRUWKNxuF5n/OPgySmUjGdU8SXpEE6AtbXT2gdwCQP9
         gMe/DNfv/rj1WjMNqp6MkdJmCcdjutwIM/lQMM2c9nEdXHKY9rho8a1CE7L2a9Ky+M7Q
         l37zR8KQ2A9KromftjpezDMFdIBE/9m9flyL+fwp1/+pXK9/gT+AOqAtzu1jN0vULDcU
         t/d7H0rMQOGD/Ex6u9EKrN84uEGcO3aH3i+ZB0rOlgMjRz+YKrb5GDQgdN3etgG9miZd
         x7c/MVPyjI7zikIJ6DBZBaImviz2DEk5gz94lDyXTRHFfZPL1Jra3lj6s99Lb6G4uRhd
         jPtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692085374; x=1692690174;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bAQfC8Fk99VKXGvykRcnXCDXuQl6wZXlhTPZ78iPS24=;
        b=KS03eHNRJuP+Z8/AmY8e7HcMoZWHj3zSmbP1+BULSNbBsHfaXyzcY0oZPeLY0D5HY1
         rRfB8agslNvv6xq1VASgcu6cq0pid+wrsIf8NwD1Bo7KIKj1Jlc0m7+94tQY+LZxVfYY
         N4r/4kWLpcUNFiJxyLWLDmTW6d56fpQrC+lesQiIdUkzqjbIaftqX/oAgC9Vz6sCqlUf
         xV7jAoilKw17sKQPaVR8PF7B1Gdtb9Q4IRjRVkig/mPQqxIqb4gm/WjLe6xMKv9LPzmo
         bFPRvtzUe/dGej5v8O2ynQ72p92t3GNzOOMDIkGpsKA3UQRevxMKB8rNM85qTJoteKEC
         C6tg==
X-Gm-Message-State: AOJu0YxhCaD1E9aYOzMxpTAqymDGTV47fJUBiFBSfodEIFG5CN+oJLQ3
        88DeIfpyhLB+6sZrDKpkNKnQh7YliaH57xkYwIk4oQ==
X-Google-Smtp-Source: AGHT+IFDQ5yjy3RJRehLsSgIxf5pspuHEFGdUfMHD78IpF/c7/o8oIdh4kFoyKOFD7wT8BGLpm7/zzaiE8Xh7Iy0tOI=
X-Received: by 2002:a25:ae52:0:b0:d67:5d71:d817 with SMTP id
 g18-20020a25ae52000000b00d675d71d817mr13014469ybe.61.1692085373841; Tue, 15
 Aug 2023 00:42:53 -0700 (PDT)
MIME-Version: 1.0
References: <20230809-virt-to-phys-powerpc-v1-1-12e912a7d439@linaro.org> <87y1icdaoq.fsf@mail.lhotse>
In-Reply-To: <87y1icdaoq.fsf@mail.lhotse>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 15 Aug 2023 09:42:42 +0200
Message-ID: <CACRpkdZuLeMKg1vG9+8tcUtWUNN-EowhpPmt6VnGuS+f9ok81g@mail.gmail.com>
Subject: Re: [PATCH] powerpc: Make virt_to_pfn() a static inline
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 15, 2023 at 9:30=E2=80=AFAM Michael Ellerman <mpe@ellerman.id.a=
u> wrote:
> Linus Walleij <linus.walleij@linaro.org> writes:

> > -     return ((unsigned long)__va(pmd_val(pmd) & ~PMD_MASKED_BITS));
> > +     return (const void *)((unsigned long)__va(pmd_val(pmd) & ~PMD_MAS=
KED_BITS));
>
> This can also just be:
>
>         return __va(pmd_val(pmd) & ~PMD_MASKED_BITS);
>
> I've squashed that in.

Oh you applied it, then I don't need to send revised versions, thanks Micha=
el!

Yours,
Linus Walleij
