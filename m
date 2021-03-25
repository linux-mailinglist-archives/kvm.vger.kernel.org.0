Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 997A7349A10
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 20:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbhCYTPz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 15:15:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbhCYTPf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Mar 2021 15:15:35 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52589C06174A
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 12:15:35 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id x126so3014701pfc.13
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 12:15:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Pps8ZS01M3z1xz1C0cNKowfwUf0UTmIQfYjXVnFmJ14=;
        b=KDN5PKPzJ+pYGa7kSdcdq9OqiudA1Ymdjo2z06MMOfUiE6cJt8TRmxv/67jaj24Wx+
         EbyQU7F8rj3JpC4/FhqSpggGHf+V8VWlmwsubhbIfBpBsXWzwZXxihOTEf0gIm3hH+Cx
         x1qbbHG7RKT3LBuoPG10JqdLB+t1q9RLPE9RrRxynaitx7OxG61eyyOEFWX9P6usMPsy
         fMKgJ9X/6vFbFLHlNqZRuiRgDfP5ObxDmutb/f1mQIKkjRdL/EYMCwwGVjeG0VMKMk42
         xTdPiQXZD0kuRs/u0pnL3PGf7vVG6/3Zpxdu3gN/BLBNxYQpg7kEtQ5HAgi7RyQdlDxo
         +V0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Pps8ZS01M3z1xz1C0cNKowfwUf0UTmIQfYjXVnFmJ14=;
        b=U/1HvZ3zBnHH7Nst5O7LtTr5hD+Uihc2hbTVLLYOXFVHFJoKkyGNE2ODafam1jGV8J
         I3Iz1O0MSjF4BcPXqWLQLSgm5fy7+btuyDNgIxLhQz6fjxiq5HB+jrdJy9zB4XQE2JzJ
         eKP5+HGU4aDEC9vndXxcPXHSglgwrDpZzwP1Arvqs4Jd+I03ZJ+Z/2CpXmrxLlk8FVbP
         wb3J1mKuVBl9kLxJTFbw0e1OrZPpnm0IyI+TP7YGgIghMq4NsfcIjOD9xNFlKZzECfvY
         Q8xWfYVQ86dAOP1IfEOU2u5I6Q7XtYPvuNZUZZ4pXuFSEwKn/J1LntINJyleeVAHmFPT
         b9rg==
X-Gm-Message-State: AOAM531xVoTo//wNwwGibSRpNNU1imrf5x8hnEO3R5+ozydOcYvQe8hy
        3Jzz5/typVUlWH4EFv+v82xBbw==
X-Google-Smtp-Source: ABdhPJzth6VurW7T55fgm24siBOTzI7x9W60MghvhahOjxjWVnDxiUhCx9tNMslxz9C1MsxdF7z+9A==
X-Received: by 2002:a63:2e87:: with SMTP id u129mr8955650pgu.107.1616699734550;
        Thu, 25 Mar 2021 12:15:34 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id o197sm7014687pfd.42.2021.03.25.12.15.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 12:15:33 -0700 (PDT)
Date:   Thu, 25 Mar 2021 19:15:30 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] KVM: x86/mmu: Ensure TLBs are flushed when yielding
 during NX zapping
Message-ID: <YFzhUjvs4eKiwHtA@google.com>
References: <20210319232006.3468382-1-seanjc@google.com>
 <20210319232006.3468382-3-seanjc@google.com>
 <CANgfPd_6d+SvJ-rQxP6k5nRmCsRFyUAJ93B0dE3NtpmdPR78wg@mail.gmail.com>
 <YFkzIAVOeWS32fdX@google.com>
 <CANgfPd8ti7Wa3YnPxgVsEiUzhOzraEcKoLyXUW9E=Wjz4L-oNA@mail.gmail.com>
 <YFo6XFmEob2pszSr@google.com>
 <CANgfPd-B8PqsCJF4m+x=ED7p_kUxkS9xwT+13A9SFTM4BwDCGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd-B8PqsCJF4m+x=ED7p_kUxkS9xwT+13A9SFTM4BwDCGg@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 23, 2021, Ben Gardon wrote:
> On Tue, Mar 23, 2021 at 11:58 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Tue, Mar 23, 2021, Ben Gardon wrote:
> > > On Mon, Mar 22, 2021 at 5:15 PM Sean Christopherson <seanjc@google.com> wrote:
> > > >
> > > > On Mon, Mar 22, 2021, Ben Gardon wrote:
> > > > > It could be fixed by forbidding kvm_tdp_mmu_zap_gfn_range from
> > > > > yielding. Since we should only need to zap one SPTE, the yield should
> > > > > not be needed within the kvm_tdp_mmu_zap_gfn_range call. To ensure
> > > > > that only one SPTE is zapped we would have to specify the root though.
> > > > > Otherwise we could end up zapping all the entries for the same GFN
> > > > > range under an unrelated root.
> > > >
> > > > Hmm, I originally did exactly that, but changed my mind because this zaps far
> > > > more than 1 SPTE.  This is zapping a SP that could be huge, but is not, which
> > > > means it's guaranteed to have a non-zero number of child SPTEs.  The worst case
> > > > scenario is that SP is a PUD (potential 1gb page) and the leafs are 4k SPTEs.
> > >
> > > It's true that there are potentially 512^2 child sptes, but the code
> > > to clear those after the single PUD spte is cleared doesn't yield
> > > anyway. If the TDP MMU is only  operating with one root (as we would
> > > expect in most cases), there should only be one chance for it to
> > > yield.
> >
> > Ah, right, I was thinking all the iterative flows yielded.  Disallowing
> > kvm_tdp_mmu_zap_gfn_range() from yielding in this case does seem like the best
> > fix.  Any objection to me sending v2 with that?
> 
> That sounds good to me.

Ewww.  This analysis isn't 100% accurate.  It's actually impossible for
zap_gfn_range() to yield in this case.  Even though it may walk multiple roots
and levels, "yielded_gfn == next_last_level_gfn" will hold true until the iter
attempts to step sideways.  When the iter attempts to step sideways, it will
always do so at the level that matches the zapping level, and so will always
step past "end".  Thus, tdp_root_for_each_pte() will break without ever
yielding.

That being said, I'm still going to send a patch to explicitly prevent this path
from yielding.  Relying on the above is waaaay too subtle and fragile.

> > > I've considered how we could allow the recursive changed spte handlers
> > > to yield, but it gets complicated quite fast because the caller needs
> > > to know if it yielded and reset the TDP iterator to the root, and
> > > there are some cases (mmu notifiers + vCPU path) where yielding is not
> > > desirable.
> >
> > Urgh, yeah, seems like we'd quickly end up with a mess resembling the legacy MMU
> > iterators.
> >
> > > >
> > > > But, I didn't consider the interplay between invalid_list and the TDP MMU
> > > > yielding.  Hrm.
