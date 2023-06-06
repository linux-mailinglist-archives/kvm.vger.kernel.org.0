Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E3C4725080
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 01:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240174AbjFFXHJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 19:07:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240178AbjFFXHI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 19:07:08 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CB77171B
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 16:07:07 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-256a43693e7so2169290a91.2
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 16:07:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686092827; x=1688684827;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KDNeipcrG/FC01ibfxC2YJ7aaXE1cUL268eOBCkQVsw=;
        b=M4fVxmszIMy2OeC29oPt4CNRr6vvBhxdssqEX54sx7F5yZY9AlT8PM6trIsIsNYh2m
         zhS0OIGFWvNZ7CDdZM/l1mWk4Q3ogJHa5KGU77Mz+rkZxTuc9UNuOLvgPFry3K7rNfNL
         CpT27bjhgzhhXRkfEw3hSK0DduoB8srC5cm4VK1POAZa/PSqcymJP3g72A1d5Ko0Hu5S
         cgoEu4DfN5hLVcrJtsFfVQ/ehgnk68jH83wCB9j0FHjwIbLyY/E8bOBqRO4Mrey37mEJ
         fXiDnGGij+Yg1ep/nBUwUuH38iLQJ7bOG7Ir77Li/WlIc+xIeQjXiLaTUhzRyo915FkG
         /9hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686092827; x=1688684827;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KDNeipcrG/FC01ibfxC2YJ7aaXE1cUL268eOBCkQVsw=;
        b=W5Cq1CR5H0z0oZhNYcJTpQQTNegdjzn7GX/5lDZCq3fFOxe9BGe/uYdM/zNUe7mRAX
         MHZ8QbbZJL8AjeGdkUtB+LajQrXVxf8aT2eO+4YayryIaXCQ24upZzRBKGbyPgfBcj1e
         6a+QOFMHD9I3OPH/suZr837PrLUMb5x4THc0O1CP50zYhXFjEdmpN7XIqcdDtxKqLkON
         xRi27nBZ8RRBM/260VSremCnaizeU30/71k+OGA2gN5307GJqf6BNWLTn+xqFqd4Zs7u
         uG1/wA+48Auokn3+EY8IkTMvcpWuNW9WjsBHdS/iqe2S0m9twgjrq0t21s/zg+BToCp7
         vZzw==
X-Gm-Message-State: AC+VfDyBkhiGmMeP8DceUp7ekFksHjg+qPlS+L/41zyqIbXJlW+e4rns
        QyKtli2mIHTD9yWMMSvbZ+Vae/HFMr4=
X-Google-Smtp-Source: ACHHUZ6MyZvh3yS8bT2DIMPSGFFuwQhSZQC19UmcZQYInC+ifOijVU3WZcP67LvKoo0B6Wr5MfPwihQIhg0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:bb18:b0:253:3eb4:c1f2 with SMTP id
 u24-20020a17090abb1800b002533eb4c1f2mr945446pjr.5.1686092826879; Tue, 06 Jun
 2023 16:07:06 -0700 (PDT)
Date:   Tue, 6 Jun 2023 16:07:05 -0700
In-Reply-To: <CAL715WKtsC=93Nqr7QJZxspWzF04_CLqN3FUxUaqTHWFRUrwBA@mail.gmail.com>
Mime-Version: 1.0
References: <20230605004334.1930091-1-mizhang@google.com> <CALMp9eSQgcKd=SN4q2QRYbveKoayKzuYEQPM0Xu+FgQ_Mja8-g@mail.gmail.com>
 <CAL715WJowYL=W40SWmtPoz1F9WVBFDG7TQwbsV2Bwf9-cS77=Q@mail.gmail.com>
 <ZH4ofuj0qvKNO9Bz@google.com> <CAL715WKtsC=93Nqr7QJZxspWzF04_CLqN3FUxUaqTHWFRUrwBA@mail.gmail.com>
Message-ID: <ZH+8GafaNLYPvTJI@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Remove KVM MMU write lock when accessing indirect_shadow_pages
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 06, 2023, Mingwei Zhang wrote:
> > > >
> > > > I don't understand the need for READ_ONCE() here. That implies that
> > > > there is something tricky going on, and I don't think that's the case.
> > >
> > > READ_ONCE() is just telling the compiler not to remove the read. Since
> > > this is reading a global variable,  the compiler might just read a
> > > previous copy if the value has already been read into a local
> > > variable. But that is not the case here...
> > >
> > > Note I see there is another READ_ONCE for
> > > kvm->arch.indirect_shadow_pages, so I am reusing the same thing.
> >
> > I agree with Jim, using READ_ONCE() doesn't make any sense.  I suspect it may have
> > been a misguided attempt to force the memory read to be as close to the write_lock()
> > as possible, e.g. to minimize the chance of a false negative.
> 
> Sean :) Your suggestion is the opposite with Jim. He is suggesting
> doing nothing, but your suggestion is doing way more than READ_ONCE().

Not really.  Jim is asserting that the READ_ONCE() is pointless, and I completely
agree.  I am also saying that I think there is a real memory ordering issue here,
and that it was being papered over by the READ_ONCE() in kvm_mmu_pte_write().

> > So I think this?
> 
> Hmm. I agree with both points above, but below, the change seems too
> heavyweight. smp_wb() is a mfence(), i.e., serializing all
> loads/stores before the instruction. Doing that for every shadow page
> creation and destruction seems a lot.

No, the smp_*b() variants are just compiler barriers on x86.

> In fact, the case that only matters is '0->1' which may potentially
> confuse kvm_mmu_pte_write() when it reads 'indirect_shadow_count', but
> the majority of the cases are 'X => X + 1' where X != 0. So, those
> cases do not matter. So, if we want to add barriers, we only need it
> for 0->1. Maybe creating a new variable and not blocking
> account_shadow() and unaccount_shadow() is a better idea?
> 
> Regardless, the above problem is related to interactions among
> account_shadow(), unaccount_shadow() and kvm_mmu_pte_write(). It has
> nothing to do with the 'reexecute_instruction()', which is what this
> patch is about. So, I think having a READ_ONCE() for
> reexecute_instruction() should be good enough. What do you think.

The reexecute_instruction() case should be fine without any fanciness, it's
nothing more than a heuristic, i.e. neither a false positive nor a false negative
will impact functional correctness, and nothing changes regardless of how many
times the compiler reads the variable outside of mmu_lock.

I was thinking that it would be better to have a single helper to locklessly
access indirect_shadow_pages, but I agree that applying the barriers to
reexecute_instruction() introduces a different kind of confusion.

Want to post a v2 of yours without a READ_ONCE(), and I'll post a separate fix
for the theoretical kvm_mmu_pte_write() race?  And then Paolo can tell me that
there's no race and school me on lockless programming once more ;-)
