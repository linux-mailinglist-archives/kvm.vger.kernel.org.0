Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC4A70126B
	for <lists+kvm@lfdr.de>; Sat, 13 May 2023 01:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238974AbjELXZU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 19:25:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239441AbjELXZT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 19:25:19 -0400
Received: from mail-vs1-xe2f.google.com (mail-vs1-xe2f.google.com [IPv6:2607:f8b0:4864:20::e2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 957546A7C
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 16:25:17 -0700 (PDT)
Received: by mail-vs1-xe2f.google.com with SMTP id ada2fe7eead31-4360e117b7cso2164329137.3
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 16:25:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683933916; x=1686525916;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gJhegFzJphPXuJITxSnVpK02wrtyZSwmP9rCGNGMF8o=;
        b=gAzw+yJupAesTu0HewVLV1YbHJX9NBfOqEeijURe8cVugA4snUj1PNwp7ZxEnuGdHP
         6vU7BUDbP5oUUx1Q3AVyulYIJRp5vv6ldouDsrfo8tpZXrUp2BEhvHvJR5YJBqAtJXUF
         HbEXnzSbZer5Xr4HIOUQAXiwtTF+vSbC8IoveB6vuoi/hTF4oTq+eRO+d3IOsmYiMjbH
         K4qgqaixEJuPWXDR7K0IiPsLWKEfFyjHAiv2FjU1CTiBP3crKNdPC8WWN9iJjqWWMg9G
         xbXciRYDbFoA+ey6rFP6lrOE3Q42miptiTMYDnqzBWOgNubmlklWCIjWRQPnIJtbIW9R
         nWTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683933916; x=1686525916;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gJhegFzJphPXuJITxSnVpK02wrtyZSwmP9rCGNGMF8o=;
        b=Yjk9GuvrmEC+s4T6r586gSfQqAQEaDBf6EacaQRtGEAXMiEiKPciRba1E5ToyuiQCX
         HZZGF2GVUHG77rrwq/yxO9V9Q1TX4Ehb6pcqZt77g7jWpxQDceTgsDcnmmkS+Dn4Mpa4
         l4ICOPdioRcplxGDEx6G/HyvvhcMaTffksDRIBgtL+j0kWgi6hJZKo5qgJE5K+c+1IfF
         GP+QW+2yviHS4T7qKU+JEs4rQ0twzQrOnTc6789mhR8JUgMy8JpvtKRSqFGwb5WH0kvd
         4bJwyyhuJ7W7661UqFAjnXxNeVqxJVUsIdCuGoghASlNJfMLiGg390o4UhQj2ZUx16E4
         50sw==
X-Gm-Message-State: AC+VfDxOHShrWbXz67ZyNcwCVluXSefmwuzmF1NtgkPzwoN7EMffa9OK
        II7pN1AE98w8pYxMTFtZtMziD538H6pnhYpFGU/kug==
X-Google-Smtp-Source: ACHHUZ5ZDdv4p+7cTcqWMTSYES8JytA1qvyi+Wjl6gI0PzEXuleOzYI8oMVCABD/ksQy4+pLN17HEcJ1VdfNkv/ZeTY=
X-Received: by 2002:a67:bb06:0:b0:42e:6748:13d1 with SMTP id
 m6-20020a67bb06000000b0042e674813d1mr10281491vsn.24.1683933916629; Fri, 12
 May 2023 16:25:16 -0700 (PDT)
MIME-Version: 1.0
References: <20230511235917.639770-1-seanjc@google.com> <20230511235917.639770-6-seanjc@google.com>
 <ZF7IRQZo8g7Lg46V@google.com> <ZF7JW2huc2MjXZFA@google.com>
In-Reply-To: <ZF7JW2huc2MjXZFA@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Fri, 12 May 2023 16:24:49 -0700
Message-ID: <CALzav=dRtju+-NaGiy7ok3chB=535bxNOqm8c+vOMCa9QKWHsQ@mail.gmail.com>
Subject: Re: [PATCH 5/9] KVM: x86/mmu: Convert "runtime" WARN_ON() assertions
 to WARN_ON_ONCE()
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mingwei Zhang <mizhang@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 12, 2023 at 4:18=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Fri, May 12, 2023, David Matlack wrote:
> > On Thu, May 11, 2023 at 04:59:13PM -0700, Sean Christopherson wrote:
> > > Convert all "runtime" assertions, i.e. assertions that can be trigger=
ed
> > > while running vCPUs, from WARN_ON() to WARN_ON_ONCE().  Every WARN in=
 the
> > > MMU that is tied to running vCPUs, i.e. not contained to loading and
> > > initializing KVM, is likely to fire _a lot_ when it does trigger.  E.=
g. if
> > > KVM ends up with a bug that causes a root to be invalidated before th=
e
> > > page fault handler is invoked, pretty much _every_ page fault VM-Exit
> > > triggers the WARN.
> > >
> > > If a WARN is triggered frequently, the resulting spam usually causes =
a lot
> > > of damage of its own, e.g. consumes resources to log the WARN and pol=
lutes
> > > the kernel log, often to the point where other useful information can=
 be
> > > lost.  In many case, the damage caused by the spam is actually worse =
than
> > > the bug itself, e.g. KVM can almost always recover from an unexpected=
ly
> > > invalid root.
> > >
> > > On the flip side, warning every time is rarely helpful for debug and
> > > triage, i.e. a single splat is usually sufficient to point a debugger=
 in
> > > the right direction, and automated testing, e.g. syzkaller, typically=
 runs
> > > with warn_on_panic=3D1, i.e. will never get past the first WARN anywa=
ys.
> >
> > On the topic of syzkaller, we should get them to test with
> > CONFIG_KVM_PROVE_MMU once it's available.
>
> +1
>
> > > Lastly, when an assertions fails multiple times, the stack traces in =
KVM
> > > are almost always identical, i.e. the full splat only needs to be cap=
tured
> > > once.  And _if_ there is value in captruing information about the fai=
led
> > > assert, a ratelimited printk() is sufficient and less likely to rack =
up a
> > > large amount of collateral damage.
> >
> > These are all good arguments and I think they apply to KVM_MMU_WARN_ON(=
)
> > as well. Should we convert that to _ONCE() too?
>
> Already done in this patch :-)  I didn't call it out because that warn al=
so falls
> under the "runtime assertions" umbrella.

Doh! Indeed. I was expecting to see KVM_MMU_WARN_ON() change to
KVM_MMU_WARN_ON_ONCE().
