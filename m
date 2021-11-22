Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5C27459878
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 00:38:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbhKVXl2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 18:41:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230325AbhKVXl0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Nov 2021 18:41:26 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93654C061574
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 15:38:12 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id 14so25466214ioe.2
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 15:38:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8Mediy++Pwci7FlplIKqkY8iyn8RqJ40rXXDyVI2F10=;
        b=Fu0onG/wGbMzEPgBe9dPX7I+cAcXB7+FPioLaNGBX5R6rcnU7KOBW9APFNlU90OBoP
         2SddqWtSy2+G7jgFInuyIUcbIyt8qWu96KjFDnzMc6bJGRsKPIneOdLZ9gHatxzYfOEK
         /1GYkIdFdPIJPrGB6gsi1tvidSvIkGMVBHAYOnc5Tgr75fYdH15zWE8TpD4BkuRi1Qmx
         AbInBQD5t8MML6CcXG8dfaIKrCb//YAFH9ZGCglV+4njlkCT8zyyzuzJTvhBHy5KzPeF
         HQtV6OS5xyyux7867Ht5ubaqcS8WXTtkGvspcKZkhAVLkR51LCh2muLbmE6yOBAoZ5T+
         ALFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8Mediy++Pwci7FlplIKqkY8iyn8RqJ40rXXDyVI2F10=;
        b=54b/oBcPmb99SyB8qEY26ZXsP/kCfubtcxnXYv/B5Eg/ZR+HRF6b0Tl8sQPpbhUWNU
         q6Gbc8dqeidJhrdW7eEfZydU5KphWy2CuA1BDtEKNr6kCV/MLI9fnQ2I0GN6X3QHHsW8
         GOvjqslozzzGFqsc9qmh4uiiFv6GPxjPR87W7DEgzuWm6YOa7yyQjBsBZiAMZgv9UWvz
         wZgt/x/EV5vAcmKWocA1DfDr5wiMBLJ0GgU5ddzCAaJKP8D2HSR7yST29PG+8qeGu+JO
         ptDMkRGAJgz7GxAAFN5PoBhz9Vgbuu+aeC1TX6RhkRe/CsEV3rKMpHbVvoHvjjqEQfcD
         qAwQ==
X-Gm-Message-State: AOAM532UChXsJ8euGUn5tQLKcij2LkC7umoxkzX4MXgkSz3hN0uYVxjg
        /Gg4oEyhmh2Y8DL25rWSb9N3aAwerrKsMSSlewpzXg==
X-Google-Smtp-Source: ABdhPJwJCufmVr+lskSZ5G8izf358/oNRuQqckbeZry84Q/7PZm3RqXXXkXcd3FBiDm8wJZGjnz1jfZzAnPkwrqoT7M=
X-Received: by 2002:a6b:5c05:: with SMTP id z5mr838542ioh.181.1637624291869;
 Mon, 22 Nov 2021 15:38:11 -0800 (PST)
MIME-Version: 1.0
References: <20211120045046.3940942-1-seanjc@google.com> <20211120045046.3940942-22-seanjc@google.com>
 <CANgfPd83-1yT=p1bMTRiOqCBq_m5AZuuhzmmyKKau9ODML39oA@mail.gmail.com> <YZwkpcmAi07fOgbz@google.com>
In-Reply-To: <YZwkpcmAi07fOgbz@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 22 Nov 2021 15:38:01 -0800
Message-ID: <CANgfPd8vpeanp1fTSTLn7oi0NudS52SAJGZoc6CXfbxcnGQRnw@mail.gmail.com>
Subject: Re: [PATCH 21/28] KVM: x86/mmu: Add TDP MMU helper to zap a root
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Hou Wenlong <houwenlong93@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 22, 2021 at 3:15 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Nov 22, 2021, Ben Gardon wrote:
> > On Fri, Nov 19, 2021 at 8:51 PM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > Add a small wrapper to handle zapping a specific root.  For now, it's
> > > little more than syntactic sugar, but in the future it will become a
> > > unique flow with rules specific to zapping an unreachable root.
> > >
> > > No functional change intended.
> > >
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > ---
> > >  arch/x86/kvm/mmu/tdp_mmu.c | 11 +++++++++--
> > >  1 file changed, 9 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > > index 9449cb5baf0b..31fb622249e5 100644
> > > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > > @@ -79,11 +79,18 @@ static void tdp_mmu_free_sp_rcu_callback(struct rcu_head *head)
> > >         tdp_mmu_free_sp(sp);
> > >  }
> > >
> > > +static bool tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
> > > +                            bool shared)
> > > +{
> > > +       return zap_gfn_range(kvm, root, 0, -1ull, true, false, shared);
> >
> > Total aside:
> > Remembering the order of these three boolean parameters through all
> > these functions drives me nuts.
> > It'd be really nice to put them into a neat, reusable struct that tracks:
> > MMU lock mode (read / write / none)
> > If yielding is okay
> > If the TLBs are dirty and need to be flushed
> >
> > I don't know when I'll have time to do that refactor, but it would
> > make this code so much more sensible.
>
> Heh, I did exactly that, then threw away the code when I realized that I could
> break up zap_gfn_range() into three separate helpers and avoid control knob hell
> (spoiler alert for later patches in this series).
>
> There are still two booleans (to what ends up being tdp_mmu_zap_leafs()), but none
> none of the call sites pass true/false for _both_ params, so the call sites end up
> being quite readable.  At that point, using a struct ended up being a net negative,
> e.g. kvm_tdp_mmu_unmap_gfn_range() had to marshall from one struct to another.

Awesome! Disregard then! I'll review the remaining few tomorrow.
