Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90A07351971
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 20:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235998AbhDARxj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 13:53:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236737AbhDARrT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 13:47:19 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D4E7C03115F
        for <kvm@vger.kernel.org>; Thu,  1 Apr 2021 09:50:21 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id u2so2617359ilk.1
        for <kvm@vger.kernel.org>; Thu, 01 Apr 2021 09:50:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0w+zGLeMzdcB8Xl8lhep34DyBJozrhHS5e3zByXXsOs=;
        b=kDL/vWg/Yf17Di0EMzIUc6FTgS3eEoyakAdcYbqSWhng1EWqEv0beBVyXtY4oMNxaT
         N/Pybyl9KFbE5JHW15B9s2JAfmLpaETxhpwtABnrRLesdkJB2k/93y6hre3CvjPCLfUt
         Tdkll+aURgcxmO+zKx5lfF1YibCZ/hWW/H1MVFume13yOjQqD3JfrTrsyDpw5S+z417O
         B866pKBWyfTSwcB6LBN6YRPRzxQRne1JjhFvH372zxhUSmvNg4Vk4dPUgVGlyDIOvtP1
         fMilIuY0gUCwtkcqWF2QTzpaF1YtaaJwLCxzN9lEB4gbAnjTIcmnWfWb5r/XL4GjXdPW
         CxBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0w+zGLeMzdcB8Xl8lhep34DyBJozrhHS5e3zByXXsOs=;
        b=WL0sf6XYCwDNTTvq32zT8p0SqQdceAO+1gXnj0iXhrdjX0B4hnST1cZtiJjgc4W9Vr
         El339nA6Eyhph/tmSS4lGmk+v09uK990kQIe8s9ZuKBBhPdEztJsCh1IB7cTcPUurdvx
         GxEZQ5PLkEfAHjWluZx4NmW5sOEzNBBHj5PsLleGgCjoTI6wLiuZgYGitr+y3eRGrolM
         R9Hji0jYRgXmdL7nUrKfyIsPyuUPFRR4LdzJc+rpxl7sVUsXg9rtMnlThE32lePnO4rp
         tgXt2wUBMhb4CcLmNSTkZlOGhEngVwoC7fgg/8SYla9a5wiongagXoo3rKTcAj4Nqk5I
         +DYg==
X-Gm-Message-State: AOAM5311imy5ut/ztRXzStP2f+MSB/XtUoy1dMvIUq1zvgkE0+U4j7hX
        ovFi0b5vybYaCy9o7qefcV5BbOWRUgM+wy2IIM/QTQ==
X-Google-Smtp-Source: ABdhPJzR7BDh9Ca3MkXwQf+bgt+Bza0FQYsPhBc+iMKM1VlGXSeWit3IupkcyE1arRrDDCtAOdPSXDonDgYOAeXAcKU=
X-Received: by 2002:a92:8752:: with SMTP id d18mr7088426ilm.283.1617295820655;
 Thu, 01 Apr 2021 09:50:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210331210841.3996155-1-bgardon@google.com> <20210331210841.3996155-13-bgardon@google.com>
 <YGT3UmSKVQFaY1Fd@google.com>
In-Reply-To: <YGT3UmSKVQFaY1Fd@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Thu, 1 Apr 2021 09:50:09 -0700
Message-ID: <CANgfPd8=2tcsgoBkMztMjhztGUN-ZMV_mbSb7JHe-sT1i3g+7Q@mail.gmail.com>
Subject: Re: [PATCH 12/13] KVM: x86/mmu: Fast invalidation for TDP MMU
To:     Sean Christopherson <seanjc@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
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

On Wed, Mar 31, 2021 at 3:27 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Mar 31, 2021, Ben Gardon wrote:
> > Provide a real mechanism for fast invalidation by marking roots as
> > invalid so that their reference count will quickly fall to zero
> > and they will be torn down.
> >
> > One negative side affect of this approach is that a vCPU thread will
> > likely drop the last reference to a root and be saddled with the work of
> > tearing down an entire paging structure. This issue will be resolved in
> > a later commit.
> >
> > Signed-off-by: Ben Gardon <bgardon@google.com>
> > ---
>
> ...
>
> > +/*
> > + * This function depends on running in the same MMU lock cirical section as
> > + * kvm_reload_remote_mmus. Since this is in the same critical section, no new
> > + * roots will be created between this function and the MMU reload signals
> > + * being sent.
>
> Eww.  That goes beyond just adding a lockdep assertion here.  I know you want to
> isolate the TDP MMU as much as possible, but this really feels like it should be
> open coded in kvm_mmu_zap_all_fast().  And assuming this lands after as_id is
> added to for_each_tdp_mmu_root(), it's probably easier to open code anyways, e.g.
> use list_for_each_entry() directly instead of bouncing through an iterator.

Yeah, that's fair. I'll open-code it here. I agree that it will remove
confusion from the function, though it would be nice to be able to use
for_each_tdp_mmu_root for the lockdep and rcu annotations.


>
> > + */
> > +void kvm_tdp_mmu_invalidate_roots(struct kvm *kvm)
> > +{
> > +     struct kvm_mmu_page *root;
> > +
> > +     for_each_tdp_mmu_root(kvm, root)
> > +             root->role.invalid = true;
> > +}
