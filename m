Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC0434683F
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 19:59:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232729AbhCWS6m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 14:58:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232117AbhCWS6l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 14:58:41 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90585C061574
        for <kvm@vger.kernel.org>; Tue, 23 Mar 2021 11:58:41 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id gb6so10517882pjb.0
        for <kvm@vger.kernel.org>; Tue, 23 Mar 2021 11:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sZPnokhwrLELvYiKvr0IXzHRf2ZL9JIzsfn9eBfejP0=;
        b=AbWSFTjb8YbVpKSkOWWpPRmmcqA16ekARGUz0wF6fzFfNAy7kKYTcuXqU4SFTPVa2o
         veThEiDu4DwYuZvNp1bPCSMsJGAjBclA7fOV3rTu2RlVTubtfuD80nC+82ZnWmwKuvEM
         26As6j4KpnQG0N5JqaOYKlZbaeaUKDE9oJXgScFO4T9YzZVRvNZtUQuYEFrP6FQJuSRd
         YH7D1h6D9qqZu1/tDM6qulKPK5kJOa8FrWiqVMUw/TIk6YZE5FyiJ2Vd1Pz95JFM0KKn
         RKo89vwVn/dux8VqDahEOkhZsWVyv/QpvhgSvH5QSqEv/f+kP9BmKnq0f31wSw5aRED4
         npLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sZPnokhwrLELvYiKvr0IXzHRf2ZL9JIzsfn9eBfejP0=;
        b=bQDBVWvGhehIcmJ5IeoFtRqaYEJfPr2gZFxRo7KMRMUUGn34u/8xbrB3nn+bIvC3bg
         4Sk6/Z0Q1+Gbs8H1Ly4y+cgJjGSL6iobU1a+wiCP15HQB7KyidJ4VfjDMdtUK3odBXZQ
         y4AK/7E9dY8Y9m4FswWs4GcxUa4KoGaMrQ6Lx99stvG2hzpRIja6WHnZjjwzl4fOKddx
         kuLu4XmLWoQEwwiZG2opkEFapAA0Qs/Eepc8weYHdHwEm/LSAIMV8VamBvphnji/TzoE
         uvoPO4eUUmXPKnGpuGeWJ39TPGFDtkbRBuQTwN9eUEcZG97TdGONM3LEEgXM6yK1/DSm
         mzLA==
X-Gm-Message-State: AOAM5318D5hsG0boFZJJll2A0cylUOyUg/JoWAUQn8ba5LpbR+7ff6Mc
        M71B0yLjTb/4Iw7vP+RdixxjSA==
X-Google-Smtp-Source: ABdhPJwwoJKG05xyj+e7XoIlCIM42m6SrEUZ2ssxALYnsYY5oAN3Xg85NuzmORtAqiuJ9DzXU5l35g==
X-Received: by 2002:a17:90a:f28e:: with SMTP id fs14mr5792402pjb.100.1616525920994;
        Tue, 23 Mar 2021 11:58:40 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id h2sm17262472pfq.139.2021.03.23.11.58.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 11:58:40 -0700 (PDT)
Date:   Tue, 23 Mar 2021 18:58:36 +0000
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
Message-ID: <YFo6XFmEob2pszSr@google.com>
References: <20210319232006.3468382-1-seanjc@google.com>
 <20210319232006.3468382-3-seanjc@google.com>
 <CANgfPd_6d+SvJ-rQxP6k5nRmCsRFyUAJ93B0dE3NtpmdPR78wg@mail.gmail.com>
 <YFkzIAVOeWS32fdX@google.com>
 <CANgfPd8ti7Wa3YnPxgVsEiUzhOzraEcKoLyXUW9E=Wjz4L-oNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd8ti7Wa3YnPxgVsEiUzhOzraEcKoLyXUW9E=Wjz4L-oNA@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 23, 2021, Ben Gardon wrote:
> On Mon, Mar 22, 2021 at 5:15 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Mon, Mar 22, 2021, Ben Gardon wrote:
> > > It could be fixed by forbidding kvm_tdp_mmu_zap_gfn_range from
> > > yielding. Since we should only need to zap one SPTE, the yield should
> > > not be needed within the kvm_tdp_mmu_zap_gfn_range call. To ensure
> > > that only one SPTE is zapped we would have to specify the root though.
> > > Otherwise we could end up zapping all the entries for the same GFN
> > > range under an unrelated root.
> >
> > Hmm, I originally did exactly that, but changed my mind because this zaps far
> > more than 1 SPTE.  This is zapping a SP that could be huge, but is not, which
> > means it's guaranteed to have a non-zero number of child SPTEs.  The worst case
> > scenario is that SP is a PUD (potential 1gb page) and the leafs are 4k SPTEs.
> 
> It's true that there are potentially 512^2 child sptes, but the code
> to clear those after the single PUD spte is cleared doesn't yield
> anyway. If the TDP MMU is only  operating with one root (as we would
> expect in most cases), there should only be one chance for it to
> yield.

Ah, right, I was thinking all the iterative flows yielded.  Disallowing
kvm_tdp_mmu_zap_gfn_range() from yielding in this case does seem like the best
fix.  Any objection to me sending v2 with that?

> I've considered how we could allow the recursive changed spte handlers
> to yield, but it gets complicated quite fast because the caller needs
> to know if it yielded and reset the TDP iterator to the root, and
> there are some cases (mmu notifiers + vCPU path) where yielding is not
> desirable.

Urgh, yeah, seems like we'd quickly end up with a mess resembling the legacy MMU
iterators.

> >
> > But, I didn't consider the interplay between invalid_list and the TDP MMU
> > yielding.  Hrm.
