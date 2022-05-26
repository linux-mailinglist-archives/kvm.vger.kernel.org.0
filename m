Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDAB4534C74
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 11:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346854AbiEZJVI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 05:21:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346871AbiEZJVE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 05:21:04 -0400
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E2D4C8BC7;
        Thu, 26 May 2022 02:20:59 -0700 (PDT)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-300628e76f3so8825467b3.12;
        Thu, 26 May 2022 02:20:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zq7iRvU+DT19FAVzX4uniBliRdwBdGOqRl/faEG/ylI=;
        b=m2i8dTElJJQMlWTwrNgOkNd1e9rt1L4VVwccaswvo60HUG80C1sLCc51kflLd3gHWY
         md7wQrYOrPAFUXRhRlkw0DKOOyfWAA8Lzgytqs7+okZG2u4eO+mJTm8aQnVfxwhTWrJL
         lcUvCn/ogqv/eoW25GHSJLC1QO3m9297kbQWCXy8VGoQpPEkXwDjGK6ysKSUluCkYs6Y
         zT+pPm3fCGSdU3PrligH20OFKp5rsSrhRYQieM+GHQiKDcrjIT4KzPDb7Yac7vGRUCoW
         HdrvtLXh3k4Cgq4tJbIcP4L3ytpx95muZ7ZQZJ9Q5x8zjoIF+Z4z8o4aLliT+CSgWbyq
         YnHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zq7iRvU+DT19FAVzX4uniBliRdwBdGOqRl/faEG/ylI=;
        b=u8Ay328u9/4I2XRiHMBJE9+doDoyejtEOzGhWTTMk50LJedNNLK/UeIyY2/eb8jT+4
         pXoUCw3vCmuKAYR7KA7OfwOGgZ1Nf78qUYYYKHogfiFPhp8I5MCEfbHNBmOCPJwB5vk3
         p0EpGhRVfXoNAEIROb5OHAY17LRRmhSmzXrwoRcn1HDoZlpoDw8hW0Bq99MOYpekKYI/
         3xEYLMa06RfikSbMpMO0IwGoDqGJEMMKoe3B6I3CDwBDPyTNA4PifC8HaBFkTu+3I2Bq
         s4FAFQn0eLv/gfQxAwDBGuQQ5ubWwGhxmYd0nmwz6blZpGY8MUPN6Q4a2JORBSuojlMF
         geXA==
X-Gm-Message-State: AOAM533VsV04cI/t6ZXbqBVQ1/tqD8T/ynQLXSLhEbDphc6/LvhfNkav
        B2zix7IGlh2QU06qZ0qiBWXV2ERmatTr1YUGNU4=
X-Google-Smtp-Source: ABdhPJz2zB+V0gGBY5O1fQO89IFe56fLLqiBom2Biw/DYMzzuDOcXHEhsDUEPE4FG9QA7BE3YlWjcmRz94f/l3ucczk=
X-Received: by 2002:a81:250c:0:b0:2ff:ee04:282e with SMTP id
 l12-20020a81250c000000b002ffee04282emr19770445ywl.161.1653556858815; Thu, 26
 May 2022 02:20:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220503150735.32723-1-jiangshanlai@gmail.com>
 <20220503150735.32723-2-jiangshanlai@gmail.com> <Yn7hUe9nyey/CS3J@google.com>
In-Reply-To: <Yn7hUe9nyey/CS3J@google.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Thu, 26 May 2022 17:20:47 +0800
Message-ID: <CAJhGHyDkRnQ56AveqZ=s1YvtRgiOeHQpLhH6MKyyoYNgsgF=xw@mail.gmail.com>
Subject: Re: [PATCH V2 1/7] KVM: X86/MMU: Add using_special_root_page()
To:     David Matlack <dmatlack@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, May 14, 2022 at 6:53 AM David Matlack <dmatlack@google.com> wrote:
>
> On Tue, May 03, 2022 at 11:07:29PM +0800, Lai Jiangshan wrote:
> > From: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> >
> > In some case, special roots are used in mmu.  It is often using
> > to_shadow_page(mmu->root.hpa) to check if special roots are used.
> >
> > Add using_special_root_page() to directly check if special roots are
> > used or needed to be used even mmu->root.hpa is not set.
> >
> > Prepare for making to_shadow_page(mmu->root.hpa) return non-NULL via
> > using special shadow pages.
> >
> > Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 14 +++++++++++---
> >  1 file changed, 11 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 909372762363..7f20796af351 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -1711,6 +1711,14 @@ static void drop_parent_pte(struct kvm_mmu_page *sp,
> >       mmu_spte_clear_no_track(parent_pte);
> >  }
> >
> > +static bool using_special_root_page(struct kvm_mmu *mmu)
>
> Could you enumerate all the scenarios that use special roots and which
> roots are the special ones? I think that would help a lot with reviewing
> this series and would be useful to encode in a comment, probably above
> this function here, for future readers.

Thank you for the review.

All the scenarios are listed in v3.

And comments are added to prove the code matches the scenarios and
the scenarios match the code (the proof must be in bi-direction).

>
> Also the term "special" is really vague. Maybe once you enumerate all
> the scenarios a common theme will arise and we can pick a better name,
> unless you have any ideas off the top of your head.

"special" is renamed to "local"

thanks
Lai
