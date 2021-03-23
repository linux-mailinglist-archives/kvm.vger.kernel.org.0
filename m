Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 684323469E5
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 21:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233395AbhCWUfE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 16:35:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233405AbhCWUes (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 16:34:48 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B20DC061763
        for <kvm@vger.kernel.org>; Tue, 23 Mar 2021 13:34:48 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id r8so19371222ilo.8
        for <kvm@vger.kernel.org>; Tue, 23 Mar 2021 13:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wUMp0W9kabSy5l7qaQdSX2dr3RHjFUmM+OEc1NDtt4o=;
        b=caLRM18sQNpkH9K2TfaLnahEzbuusJhrN+mnMEXfvw0DVIuwMdW85eeEVdy5e3CryF
         JivasS9U9e65AdKcEP33o5C2vjnTvps3d1KtXLKyNsjiuyGJ2+I6onoxJaKaa2MDLv4Z
         SnSlbA1xLHZTjV62ZDriWKSH/Q7pJBUaPChc6LcDXrzJCt5WtBFNHJTSxpYKzaufpigY
         EkxsYV+4s65cLcGUvluZhJHBUlERjw4rn+aTo2/26poEDemklSN9gxxJ12AsrZU9JK1W
         2pA6z4YfL57nlbyAUi6kS533bja3KwQdvxUBUquchRwRpKqSNarnspkuPxXbna4+Oq65
         jdNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wUMp0W9kabSy5l7qaQdSX2dr3RHjFUmM+OEc1NDtt4o=;
        b=o5t7jCOA0s7aZsMInnfdGv50v1Uk8iNN44gt7K0HqIk42EpzoKv1ylWuTjmnZkI6YU
         HiSAdl4FjrhYDeh85MTa5CLmZqm4lyqqffIczWX8fwBsneqyRMz3TN5MGSAZPXLty89J
         xvHe3sOJZwJcIx+RawAU1qt8LaOxvGHuXVw1MvZ2yuZFY7m+FqYaJTgXM/p1dO063nUS
         U5apklblBFR6/jkP5exCBf3PcMFbRuXXKH3SnXZcW7AKy41EPV36+5ajC12gOoxk6nDb
         NGqlloBOAncu0AUrydQ5z3eH9S9oXWy+fIHJ3tJ96nwNQUAmuWY1Sn5aclYe7s9emb5F
         EOZA==
X-Gm-Message-State: AOAM530yVe3R0DtlZ1eRc/bqoNWEyfxUp9zxUT8AQn66yIOkuLbMbGPJ
        h3djyd1o9hY2jqxjrUhPbA6K4Q0l2Yak8p580Xggzw==
X-Google-Smtp-Source: ABdhPJydMeK6tzaC/zRa2b5Bj34fmqC1jQrn9aZ0edCiovHB2Wazofnxg8N5xr+8aK1NJcchSUh3K1Yai4cb8KLN1Ns=
X-Received: by 2002:a92:8752:: with SMTP id d18mr7607ilm.283.1616531687048;
 Tue, 23 Mar 2021 13:34:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210319232006.3468382-1-seanjc@google.com> <20210319232006.3468382-3-seanjc@google.com>
 <CANgfPd_6d+SvJ-rQxP6k5nRmCsRFyUAJ93B0dE3NtpmdPR78wg@mail.gmail.com>
 <YFkzIAVOeWS32fdX@google.com> <CANgfPd8ti7Wa3YnPxgVsEiUzhOzraEcKoLyXUW9E=Wjz4L-oNA@mail.gmail.com>
 <YFo6XFmEob2pszSr@google.com>
In-Reply-To: <YFo6XFmEob2pszSr@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Tue, 23 Mar 2021 13:34:36 -0700
Message-ID: <CANgfPd-B8PqsCJF4m+x=ED7p_kUxkS9xwT+13A9SFTM4BwDCGg@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: x86/mmu: Ensure TLBs are flushed when yielding
 during NX zapping
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 23, 2021 at 11:58 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Mar 23, 2021, Ben Gardon wrote:
> > On Mon, Mar 22, 2021 at 5:15 PM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Mon, Mar 22, 2021, Ben Gardon wrote:
> > > > It could be fixed by forbidding kvm_tdp_mmu_zap_gfn_range from
> > > > yielding. Since we should only need to zap one SPTE, the yield should
> > > > not be needed within the kvm_tdp_mmu_zap_gfn_range call. To ensure
> > > > that only one SPTE is zapped we would have to specify the root though.
> > > > Otherwise we could end up zapping all the entries for the same GFN
> > > > range under an unrelated root.
> > >
> > > Hmm, I originally did exactly that, but changed my mind because this zaps far
> > > more than 1 SPTE.  This is zapping a SP that could be huge, but is not, which
> > > means it's guaranteed to have a non-zero number of child SPTEs.  The worst case
> > > scenario is that SP is a PUD (potential 1gb page) and the leafs are 4k SPTEs.
> >
> > It's true that there are potentially 512^2 child sptes, but the code
> > to clear those after the single PUD spte is cleared doesn't yield
> > anyway. If the TDP MMU is only  operating with one root (as we would
> > expect in most cases), there should only be one chance for it to
> > yield.
>
> Ah, right, I was thinking all the iterative flows yielded.  Disallowing
> kvm_tdp_mmu_zap_gfn_range() from yielding in this case does seem like the best
> fix.  Any objection to me sending v2 with that?

That sounds good to me.

>
> > I've considered how we could allow the recursive changed spte handlers
> > to yield, but it gets complicated quite fast because the caller needs
> > to know if it yielded and reset the TDP iterator to the root, and
> > there are some cases (mmu notifiers + vCPU path) where yielding is not
> > desirable.
>
> Urgh, yeah, seems like we'd quickly end up with a mess resembling the legacy MMU
> iterators.
>
> > >
> > > But, I didn't consider the interplay between invalid_list and the TDP MMU
> > > yielding.  Hrm.
