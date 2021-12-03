Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2A4A466E62
	for <lists+kvm@lfdr.de>; Fri,  3 Dec 2021 01:17:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234586AbhLCAU0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Dec 2021 19:20:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbhLCAU0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Dec 2021 19:20:26 -0500
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99466C06174A
        for <kvm@vger.kernel.org>; Thu,  2 Dec 2021 16:17:02 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id i63so2895068lji.3
        for <kvm@vger.kernel.org>; Thu, 02 Dec 2021 16:17:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SkSTdG5o1/wprlHHr7CRgP6LJcFfuVQK8ztqVVXG3LA=;
        b=RBe3Rc7J+8GNRdI9Ci1VMPy5bxbWc+MJRdWRpkm/hfUekPgDn3NkKrsXWFokbD8m0D
         XOMH11CkawFmh+6FyaR6UPHhxL8hNRDLcnF2W3xF52efbD0Td+O55qfMVpVAmDjQcOxF
         hdbDu40h2UdxKLhIXBRpSVS5pRmfbAYpw1QRd7ThXywHFUDJPeMZw+8YhE8NNPh2dQrU
         3gZCVL/FGCAofIZAoLISpLuFHbxD680TL2p1gWMg0niRI+O0nGNSOf+LOyutQKdzoTNe
         KgZJuE74dgh9ZEkjwMT9+c7m7du0C24kNm23XW2NryYyYnkluY4JoHUN81HneqnwdlP/
         G08w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SkSTdG5o1/wprlHHr7CRgP6LJcFfuVQK8ztqVVXG3LA=;
        b=pisX16rsqT6Kc1nJFNLxu6b0q40tSIiR0IAeGWPrV+mFBF3Zt3zGvHoaYgc9m+9beV
         hfLHuEGA2YToIRXoO+Ja1ZNpGStX8VPj992bwmjks71T19rnJ6KeQqJjExjEi+svuldM
         hhTY1UKkfa20u3y7Z9sENQsToUMP86rbGNY8ot5raunsumDsR+m5xtbGXhODlItDTC+l
         os5nKRkcPAIFmCrGENor17sTja6j3wMwJRqJSqYtRzW+9hR9VPNw17uK1rBY4rx8oZzi
         qiZkMB4O/5qok3fD+xWn9Pb4EJ3Gk4PIwu1yRX5aptXa07M+2OFtqM5Sod26LqZ97wSZ
         6CAg==
X-Gm-Message-State: AOAM530n4PNXtGsnqtH/afl9HLZ4N43Ymw5Qn8kdsT1LXXOeKVe7kSWm
        0hrmWjrYZN/QxSy9uDOgnXPNGAiywNL1rQaqDLo8HA==
X-Google-Smtp-Source: ABdhPJy38ilEf0lQUBhF6jRRl1vjdxL/TBmfWEGTBQT2XyasOKxdAARo/XxiTyPeAUK9M5P8p0bPx+6TPDINXL48v2o=
X-Received: by 2002:a2e:8895:: with SMTP id k21mr15224930lji.331.1638490620707;
 Thu, 02 Dec 2021 16:17:00 -0800 (PST)
MIME-Version: 1.0
References: <20211120045046.3940942-1-seanjc@google.com> <CALzav=cRRW2ZdotseqV+eKcu2oxehkkzKjYYDc3PA=Lw16JrGQ@mail.gmail.com>
 <YagpeekJ6I52f4U1@google.com>
In-Reply-To: <YagpeekJ6I52f4U1@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Thu, 2 Dec 2021 16:16:34 -0800
Message-ID: <CALzav=e7m0BS-iPd=_zW6V=uf4dCuDhmPLZ5AWpg5vRx9M7uuQ@mail.gmail.com>
Subject: Re: [PATCH 00/28] KVM: x86/mmu: Overhaul TDP MMU zapping and flushing
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Hou Wenlong <houwenlong93@linux.alibaba.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 1, 2021 at 6:03 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Dec 01, 2021, David Matlack wrote:
> > On Fri, Nov 19, 2021 at 8:51 PM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > Overhaul TDP MMU's handling of zapping and TLB flushing to reduce the
> > > number of TLB flushes, and to clean up the zapping code.  The final patch
> > > realizes the biggest change, which is to use RCU to defer any TLB flush
> > > due to zapping a SP to the caller.  The largest cleanup is to separate the
> > > flows for zapping roots (zap _everything_), zapping leaf SPTEs (zap guest
> > > mappings for whatever reason), and zapping a specific SP (NX recovery).
> > > They're currently smushed into a single zap_gfn_range(), which was a good
> > > idea at the time, but became a mess when trying to handle the different
> > > rules, e.g. TLB flushes aren't needed when zapping a root because KVM can
> > > safely zap a root if and only if it's unreachable.
> > >
> > > For booting an 8 vCPU, remote_tlb_flush (requests) goes from roughly
> > > 180 (600) to 130 (215).
> > >
> > > Please don't apply patches 02 and 03, they've been posted elsehwere and by
> > > other people.  I included them here because some of the patches have
> > > pseudo-dependencies on their changes.  Patch 01 is also posted separately.
> > > I had a brain fart and sent it out realizing that doing so would lead to
> > > oddities.
> >
> > What's the base commit for this series?
>
> Pretty sure it's based on a stale kvm/queue, commit 81d7c6659da0 ("KVM: VMX: Remove
> vCPU from PI wakeup list before updating PID.NV").  Time to add useAutoBase=true...

That applied cleanly. Thanks!
