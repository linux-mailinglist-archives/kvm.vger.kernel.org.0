Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A98004E7E2A
	for <lists+kvm@lfdr.de>; Sat, 26 Mar 2022 01:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiCZAdf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Mar 2022 20:33:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiCZAdd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Mar 2022 20:33:33 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CA9721A8A7
        for <kvm@vger.kernel.org>; Fri, 25 Mar 2022 17:31:57 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id c15so12266219ljr.9
        for <kvm@vger.kernel.org>; Fri, 25 Mar 2022 17:31:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w7nzRz+ku1xVPbthIr1h39WQkWceMAxSsziZ479N8l8=;
        b=T9smYeqdyIJTv6bWc//YVfgGAAsxoJ1B2JntMbZoPtAgrdrB3YMq0Okkl/hpg7UGmf
         7GoNIAta8CxY6NI6vnKrTPhKXJaYYW3Xr93Irer2PFiQTfwxOwLggMk9dsT+jYHaDVDA
         R3wNPAnOAk/NIvNd9yDEtLQezX8xzKR7Q9qHDmDio9lLTYhhBFQhgHn6F19BEWgA6TJV
         wNzWudL98d9oXkJpcEIWpxjWwLkrMch8ZDbLx074TGiQB0o+M26pC9/fhAyHTQ8EYJTa
         t1kdAsEyS3A/LgDNfYXbXjuHgx7GH4ZDk9hAXGMSWbL/vkC8L4BmNoAAJLRXdQ7uVTpV
         rJ8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w7nzRz+ku1xVPbthIr1h39WQkWceMAxSsziZ479N8l8=;
        b=UzDGZs/7Z6G9K2L2WeEx+mDUje6oqP4M5TVCHwX0ikjGJ/bAmOtoEyMTtOo5wMZndN
         MTfuHEVCYQqJT2IBJmo/qd3X6vQT9CQY/PhVSv6hMAE3+ivnTaauleQxyLDyFsNIz4Bn
         P3pK4e0ItewOkFyNThYxTuUi9Ts7EljFNKr3iIJVZoAGl4fOnK1phG4r8ptOrtX30Eu6
         D5/4GvkOqpqnybdxaAnXybcxM3bu+wx9RPQpIaGGzmzTjrHE2AhDGpGnJ+EYkduq3ITT
         3hk6ZOE5/VzYhQL98RUjYclZWH/QhU3Bvvj8QG7cDkSNibJEZS8mDTPMuT7Eje7DbBqC
         iiHA==
X-Gm-Message-State: AOAM532AIyDMnCmlrTdRPMdj3iFBqxkrJaphBYOpJMCTJ3yI2f7+U5Ws
        +V9r7bW6AFqi2jZI+c1Qk2LL3zAUrxJADcppmHBoKw==
X-Google-Smtp-Source: ABdhPJxJX22CS6ZYAgZkVPhd+qpK+eO9wSNpPsFs7fZEtjWujgCv/T4rt0TjJSfvJsUAjbLFf6XXQYAic3y8VVgdfdg=
X-Received: by 2002:a2e:a881:0:b0:249:6f85:d4a4 with SMTP id
 m1-20020a2ea881000000b002496f85d4a4mr10145003ljq.231.1648254715708; Fri, 25
 Mar 2022 17:31:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220325233125.413634-1-vipinsh@google.com> <CALzav=e6W2VSp=btmqTpQJ=3bH+Bw3D8sLApkTTvMMKAnw_LAw@mail.gmail.com>
In-Reply-To: <CALzav=e6W2VSp=btmqTpQJ=3bH+Bw3D8sLApkTTvMMKAnw_LAw@mail.gmail.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Fri, 25 Mar 2022 17:31:19 -0700
Message-ID: <CAHVum0dOfJ5HuscNq0tA6BnUJK34v4CPCTkD4piHc7FObZOsng@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/mmu: Speed up slot_rmap_walk_next for sparsely
 populated rmaps
To:     David Matlack <dmatlack@google.com>
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

On Fri, Mar 25, 2022 at 4:53 PM David Matlack <dmatlack@google.com> wrote:
>
> On Fri, Mar 25, 2022 at 4:31 PM Vipin Sharma <vipinsh@google.com> wrote:
> >
> > Avoid calling handlers on empty rmap entries and skip to the next non
> > empty rmap entry.
> >
> > Empty rmap entries are noop in handlers.
> >
> > Signed-off-by: Vipin Sharma <vipinsh@google.com>
> > Suggested-by: Sean Christopherson <seanjc@google.com>
> > Change-Id: I8abf0f4d82a2aae4c5d58b80bcc17ffc30785ffc
>
> nit: Omit Change-Id tags from upstream commits.

Thanks for catching it.

>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 9 ++++++---
> >  1 file changed, 6 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 51671cb34fb6..f296340803ba 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -1499,11 +1499,14 @@ static bool slot_rmap_walk_okay(struct slot_rmap_walk_iterator *iterator)
> >         return !!iterator->rmap;
> >  }
> >
> > -static void slot_rmap_walk_next(struct slot_rmap_walk_iterator *iterator)
> > +static noinline void
>
> What is the reason to add noinline?

My understanding is that since this method is called from
__always_inline methods, noinline will avoid gcc inlining the
slot_rmap_walk_next in those functions and generate smaller code.
