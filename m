Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 937E42865E4
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 19:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbgJGR2l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 13:28:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726434AbgJGR2l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Oct 2020 13:28:41 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F240C061755
        for <kvm@vger.kernel.org>; Wed,  7 Oct 2020 10:28:41 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id k6so3233030ior.2
        for <kvm@vger.kernel.org>; Wed, 07 Oct 2020 10:28:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Gzog+3s7evIu2Oc1rtwTUl+9x6mD7V8+jB/FerDJf6g=;
        b=nX/4Q/YGjmebBLp4gLg8J2yprcJQilHAS6qA1FHs5eLbDhe6iwzEYvpmsJs/PP94Kp
         GCzwHPrwqADg8+WqzbUbeFeB4eX4KHZvo0buxluUokPbtybLhx8dhFMWlcQAd4CKe10t
         26nG5444aSaobp5nO22ausRmcHQy//aglJ0fRKo9ARJvEW1Yrw8Ky7WccdZpsJuYm3e/
         xQS3dc0ny8dD/YDLaIBmKmsuC02TSE/s94jTazNbKJ4VAxjuvrFEJSzCQ/Eg9TGtG3ES
         0m7EI+PaTupmbB5L+0UtEw9R9srPbyfyOmGMXNBfZhOTPadOU/ZYwAIGwrkLzEgvL1mu
         hmWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Gzog+3s7evIu2Oc1rtwTUl+9x6mD7V8+jB/FerDJf6g=;
        b=cftnXQsbuzO3D0x6e9R10zUMsQ/96G1Gp9qIhqVpNG7+Syyyzdy8s4pzS89+N/idzv
         wLyy6UiFDiCUvqKZcF4+VFokkBO17JjEB5hD9dpxs5XtF71BeD29szJtgKMWL2zRwTnZ
         qOot/rSwlJOK7kcEJEJbsL8LL7NNKryBkJCAO0OplIHpFg2CKk5DLHULYZyHlohodYtQ
         mtrkGbewqTjGUKua4MMmKn9sYQk90G8EB9RkgWsH/CpuQVwo6HLFnwscK1NBvI7/ekMg
         yyIc3eOa40T74rl2Z1w/0o9TQgi/BphLvh2JursiZwuxJPMBVhkxsJnLDlqXqwLO9pXj
         jJYA==
X-Gm-Message-State: AOAM532RQb3+Q1yc/FzDc9ZPmqe+GZ2Vcv+g05RKl4mLZyJkFOgQsYJt
        U1R8ldnG+EUmxUP3nzlnjA6T9mdNJgXhbUri9KPQQw==
X-Google-Smtp-Source: ABdhPJx+5QZ/4AZZSBIqs4Xz/+pawpkCt8kkhCfoEeqQkigGdJRmMdYgOotYq/Tj/ADhEivC6xDJq+FADqbvmAySDHU=
X-Received: by 2002:a02:2ac1:: with SMTP id w184mr3827019jaw.44.1602091720153;
 Wed, 07 Oct 2020 10:28:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200925212302.3979661-1-bgardon@google.com> <20200925212302.3979661-19-bgardon@google.com>
 <44822999-f5dc-6116-db12-a41f5bd80dd8@redhat.com> <CANgfPd_dQ19sZz2wzSfz7-RzdbQrfP6cYJLpSYbyNyQW6Uf09Q@mail.gmail.com>
 <5dc72eec-a4bd-f31a-f439-cdf8c5b48c05@redhat.com>
In-Reply-To: <5dc72eec-a4bd-f31a-f439-cdf8c5b48c05@redhat.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 7 Oct 2020 10:28:29 -0700
Message-ID: <CANgfPd8Nzi2Cb3cvh5nFoaXTPbfm7Y77e4iM6-zOp5Qa3wNJBw@mail.gmail.com>
Subject: Re: [PATCH 18/22] kvm: mmu: Support disabling dirty logging for the
 tdp MMU
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Cannon Matthews <cannonmatthews@google.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 7, 2020 at 10:21 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 07/10/20 18:30, Ben Gardon wrote:
> >> I'm starting to wonder if another iterator like
> >> for_each_tdp_leaf_pte_root would be clearer, since this idiom repeats
> >> itself quite often.  The tdp_iter_next_leaf function would be easily
> >> implemented as
> >>
> >>         while (likely(iter->valid) &&
> >>                (!is_shadow_present_pte(iter.old_spte) ||
> >>                 is_last_spte(iter.old_spte, iter.level))
> >>                 tdp_iter_next(iter);
> > Do you see a substantial efficiency difference between adding a
> > tdp_iter_next_leaf and building on for_each_tdp_pte_using_root with
> > something like:
> >
> > #define for_each_tdp_leaf_pte_using_root(_iter, _root, _start, _end)    \
> >         for_each_tdp_pte_using_root(_iter, _root, _start, _end)         \
> >                 if (!is_shadow_present_pte(_iter.old_spte) ||           \
> >                     !is_last_spte(_iter.old_spte, _iter.level))         \
> >                         continue;                                       \
> >                 else
> >
> > I agree that putting those checks in a wrapper makes the code more concise.
> >
>
> No, that would be just another way to write the same thing.  That said,
> making the iteration API more complicated also has disadvantages because
> if get a Cartesian explosion of changes.

I wouldn't be too worried about that. The only things I ever found
worth making an iterator case for were:
Every SPTE
Every present SPTE
Every present leaf SPTE

And really there aren't many cases that use the middle one.

>
> Regarding the naming, I'm leaning towards
>
>     tdp_root_for_each_pte
>     tdp_vcpu_for_each_pte
>
> which is shorter than the version with "using" and still clarifies that
> "root" and "vcpu" are the thing that the iteration works on.

That sounds good to me. I agree it's similarly clear.

>
> Paolo
>
