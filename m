Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4106A3A21F4
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 03:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbhFJBuk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 21:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbhFJBuj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 21:50:39 -0400
Received: from mail-oo1-xc2c.google.com (mail-oo1-xc2c.google.com [IPv6:2607:f8b0:4864:20::c2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41E64C061574
        for <kvm@vger.kernel.org>; Wed,  9 Jun 2021 18:48:33 -0700 (PDT)
Received: by mail-oo1-xc2c.google.com with SMTP id d27-20020a4a3c1b0000b029024983ef66dbso3613723ooa.3
        for <kvm@vger.kernel.org>; Wed, 09 Jun 2021 18:48:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qOgzX+vvff/WfwDfOUS6M3hW69U6U8fwCjsw9gDHFBk=;
        b=lASjid/vRKWJUu+KCmsmjN6e0QZ+PxtqUXHIKN5R5fzpGoafsmGAGKOHTvBds97MzJ
         d/hloKaMh30wOvk9fGdsVeMcDOcS6yTHcXtR/d3TFg8CqWefdfE1A4C64nRbFIVGzU7O
         v3SC9ngzO5eoQrm5tZJvUSIvH0BqbSkENvb7ZeTYPLrFFxI2+a17229VsTN0aPIxu2jP
         rtIFw455GK3+w8z1aG1W/FGdmx9X7nJKmXT0UilWJzogE1sWDVfaU5RHD+J3ncc0R0nL
         43fDteJFXAJVGiFppfDaSg69Q58sRpbRhEEly2cTFDGLJCiBsovONNDAaXNFq3iJ0jP3
         nPxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qOgzX+vvff/WfwDfOUS6M3hW69U6U8fwCjsw9gDHFBk=;
        b=TNlFOKgDJ0SCePz4eS/RXHiJ0yLe0wMC+8h0L52rg5guWPvTKlyzkKkeGc4vAeyL6J
         sgAk33+UinDyZWJZh8z5Su/0Rw8yUyLub1OhFLHdiG6ZXMrQD0w6zwAcYO9sCoir4I9S
         aGkB72lTcGObgy8tdCewGdvA7HYOs9flZNaLByeHNOZOpg5Kv1sKX10mWFV/VhpZvyqe
         zvInLCDta0Qk0nccQkzz4/Nkott0i9cl2T4pA5E57FqdvjzjybvMYGcRBhH8Tid8rBEV
         LqogTwnT+W6ijPpezY3rvaEekTfQ7sQ+PvGc/VRLJX2SIrCv/KR2kCr1b2vF6EkfN21T
         FN+g==
X-Gm-Message-State: AOAM530jWNLGSRM3/VWCuI5grFeR5jpw303AnFpShQ4tol+7pY2s3J/t
        3swyeUGdEljQ5mlGEiDUjJjLfXNaLlEXMvsz2+5gxA==
X-Google-Smtp-Source: ABdhPJz9DcEMgenZufoWS5PWYxRAghn7GT7oaKHskyQNYxWXbLE+jDW+NM05TmEr2vXpsay08UP76v5O5lhUd6qwkTo=
X-Received: by 2002:a4a:e4c1:: with SMTP id w1mr465761oov.81.1623289710436;
 Wed, 09 Jun 2021 18:48:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210609215111.4142972-1-jmattson@google.com> <8b4bbc8e-ee42-4577-39b1-44fb615c080a@oracle.com>
In-Reply-To: <8b4bbc8e-ee42-4577-39b1-44fb615c080a@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 9 Jun 2021 18:48:19 -0700
Message-ID: <CALMp9eRvOFAnSCmXR9DWdWv9hzpOFjMXoo6a2Sd-bRBO3wnd-Q@mail.gmail.com>
Subject: Re: [PATCH] kvm: LAPIC: Restore guard to prevent illegal APIC
 register access
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm list <kvm@vger.kernel.org>, syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 9, 2021 at 5:45 PM Krish Sadhukhan
<krish.sadhukhan@oracle.com> wrote:
>
>
> On 6/9/21 2:51 PM, Jim Mattson wrote:
> > Per the SDM, "any access that touches bytes 4 through 15 of an APIC
> > register may cause undefined behavior and must not be executed."
> > Worse, such an access in kvm_lapic_reg_read can result in a leak of
> > kernel stack contents. Prior to commit 01402cf81051 ("kvm: LAPIC:
> > write down valid APIC registers"), such an access was explicitly
> > disallowed. Restore the guard that was removed in that commit.
> >
> > Fixes: 01402cf81051 ("kvm: LAPIC: write down valid APIC registers")
> > Signed-off-by: Jim Mattson <jmattson@google.com>
> > Reported-by: syzbot <syzkaller@googlegroups.com>
> > ---
> >   arch/x86/kvm/lapic.c | 3 +++
> >   1 file changed, 3 insertions(+)
> >
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index c0ebef560bd1..32fb82bbd63f 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -1410,6 +1410,9 @@ int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
> >       if (!apic_x2apic_mode(apic))
> >               valid_reg_mask |= APIC_REG_MASK(APIC_ARBPRI);
> >
> > +     if (alignment + len > 4)
>
> It will be useful for debugging if the apic_debug() call is added back in.

Are you suggesting that I should revert commit 0d88800d5472 ("kvm:
x86: ioapic and apic debug macros cleanup")?

> > +             return 1;
> > +
> >       if (offset > 0x3f0 || !(valid_reg_mask & APIC_REG_MASK(offset)))
> >               return 1;
> >
>
> Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
