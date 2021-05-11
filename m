Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E00D37ABC6
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 18:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231777AbhEKQXj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 12:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231177AbhEKQXg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 May 2021 12:23:36 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 485E5C06174A
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 09:22:28 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id i7so11249333ioa.12
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 09:22:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4jXZs11HGH/EBNKvji1vJOWsgckIXclQ4pDhYDnWyh8=;
        b=K2ME3kMtsLEUOJHmWigd7iBeW3kUpwwkNwrk+bKCUi/GAasFcn1ZjPJxEIfRUxKkzo
         XRE8SZWXoPSy5xuqDorvmCuof0ODWKu/NdabOTyAcWb7p+aUwc1tjXljnZdNnx1AYUMi
         K9Hwu53wrQporys+PQgWjJpUROgDva5Yr49pRar93gWXGvHUd0CtDGbRZMXD2mGzHyoE
         XVElnc5EEp9MpIkPo0gJ1x0jdQv3K7wXFDJgZr57Xw/TPT/I7yCAVa4dJ2dYoS3pX4PA
         uxp/UYSQYsNgvutVCPQZ1nAA+4UVrXiUaeQ4grJfNjcnce9ZoYU+C+vE6bJ8WENSY3Og
         83aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4jXZs11HGH/EBNKvji1vJOWsgckIXclQ4pDhYDnWyh8=;
        b=jUCPTXGFZrIYq3weNinkUlnvwnqDVYoJuT3RM+pF6GcfK5LelaPq7Zo9NTZwure5zU
         rYCyWgmqc9vFSxyJQ0Pw3RpvkYmNhYmDUQtOo44iimopj5aX3xmly1s3/E/H0jxkLpNM
         KQuz87w3qsWOtxpbZqtedzjrtklCb0dUDmhsp3tW2pVgOOx9UyQPJV8BBll6vsctziez
         kQrpZ0NsTBLl9mkAx9wU1D0fTN9/9BXYHnSrRRGO3uYpoPBmybcft29mKMw/Zfl06wTf
         gObz4KbFL+jK5pQ+ognc8tNl6+96kdbx6SkhIp/mUoSJjTGQVOUF5N2WLCJOyauma6Sn
         nNgw==
X-Gm-Message-State: AOAM531v3DgTrG4zVgIY4AEgnqCxL/6NoHjIwFNRlPwAtMrGwaFnLMHM
        DfiX5gAJgtfxx+F6Htboo5sUVT6D6zuI/o5FeEWM9Q==
X-Google-Smtp-Source: ABdhPJwPBgeUZszq6WtkQ7MowJX6W0BoxxcJ1gkJMdfAryvl2OZHfqw9y2B4Otj8D1fRSZddbjMa83cW8UiK+o7WKZM=
X-Received: by 2002:a5d:850c:: with SMTP id q12mr23352649ion.189.1620750147514;
 Tue, 11 May 2021 09:22:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210506184241.618958-1-bgardon@google.com> <20210506184241.618958-8-bgardon@google.com>
 <e2e73709-f247-1a60-4835-f3fad37ab736@redhat.com> <YJlxQe1AXljq5yhQ@google.com>
 <a13b6960-3628-2899-5fbf-0765f97aa9eb@redhat.com> <YJl7V1arDXyC6i5P@google.com>
In-Reply-To: <YJl7V1arDXyC6i5P@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Tue, 11 May 2021 09:22:16 -0700
Message-ID: <CANgfPd9LDnEs1EoEu2tXZVvLGkFhNSByJ-oLCkqb02xxmgkifQ@mail.gmail.com>
Subject: Re: [PATCH v3 7/8] KVM: x86/mmu: Protect rmaps independently with SRCU
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 10, 2021 at 11:28 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, May 10, 2021, Paolo Bonzini wrote:
> > On 10/05/21 19:45, Sean Christopherson wrote:
> > > >
> > > > ---------
> > > > Currently, rmaps are always allocated and published together with a new
> > > > memslot, so the srcu_dereference for the memslots array already ensures that
> > > > the memory pointed to by slots->arch.rmap is zero at the time
> > > > slots->arch.rmap.  However, they still need to be accessed in an SRCU
> > > > read-side critical section, as the whole memslot can be deleted outside
> > > > SRCU.
> > > > --------
> > > I disagree, sprinkling random and unnecessary __rcu/SRCU annotations does more
> > > harm than good.  Adding the unnecessary tag could be quite misleading as it
> > > would imply the rmap pointers can_change_  independent of the memslots.
> > >
> > > Similary, adding rcu_assign_pointer() in alloc_memslot_rmap() implies that its
> > > safe to access the rmap after its pointer is assigned, and that's simply not
> > > true since an rmap array can be freed if rmap allocation for a different memslot
> > > fails.  Accessing the rmap is safe if and only if all rmaps are allocated, i.e.
> > > if arch.memslots_have_rmaps is true, as you pointed out.
> >
> > This about freeing is a very good point.
> >
> > > Furthermore, to actually gain any protection from SRCU, there would have to be
> > > an synchronize_srcu() call after assigning the pointers, and that _does_  have an
> > > associated.
> >
> > ... but this is incorrect (I was almost going to point out the below in my
> > reply to Ben, then decided I was pointing out the obvious; lesson learned).
> >
> > synchronize_srcu() is only needed after *deleting* something, which in this
>
> No, synchronization is required any time the writer needs to ensure readers have
> recognized the change.  E.g. making a memslot RO, moving a memslot's gfn base,
> adding an MSR to the filter list.  I suppose you could frame any modification as
> "deleting" something, but IMO that's cheating :-)
>
> > case is done as part of deleting the memslots---it's perfectly fine to batch
> > multiple synchronize_*() calls given how expensive some of them are.
>
> Yes, but the shortlog says "Protect rmaps _independently_ with SRCU", emphasis
> mine.  If the rmaps are truly protected independently, then they need to have
> their own synchronization.  Setting all rmaps could be batched under a single
> synchronize_srcu(), but IMO batching the rmaps with the memslot itself would be
> in direct contradiction with the shortlog.
>
> > (BTW an associated what?)
>
> Doh.  "associated memslot."
>
> > So they still count as RCU-protected in my opinion, just because reading
> > them outside SRCU is a big no and ought to warn (it's unlikely that it
> > happens with rmaps, but then we just had 2-3 bugs like this being reported
> > in a short time for memslots so never say never).
>
> Yes, but that interpretation holds true for literally everything that is hidden
> behind an SRCU-protected pointer.  E.g. this would also be wrong, it's just much
> more obviously broken:
>
> bool kvm_is_gfn_writable(struct kvm* kvm, gfn_t gfn)
> {
>         struct kvm_memory_slot *slot;
>         int idx;
>
>         idx = srcu_read_lock(&kvm->srcu);
>         slot = gfn_to_memslot(kvm, gfn);
>         srcu_read_unlock(&kvm->srcu);
>
>         return slot && !(slot->flags & KVM_MEMSLOT_INVALID) &&
>                !(slot->flags & KVM_MEM_READONLY);
> }
>
>
> > However, rcu_assign_pointer is not needed because the visibility of the rmaps
> > is further protected by the have-rmaps flag (to be accessed with
> > load-acquire/store-release) and not just by the pointer being there and
> > non-NULL.
>
> Yes, and I'm arguing that annotating the rmaps as __rcu is wrong because they
> themselves are not protected by SRCU.  The memslot that contains the rmaps is
> protected by SRCU, and because of that asserting SRCU is held for read will hold
> true.  But, if the memslot code were changed to use a different protection scheme,
> e.g. a rwlock for argument's sake, then the SRCU assertion would fail even though
> the rmap logic itself didn't change.

I'm inclined to agree with Sean that the extra RCU annotations are
probably unnecessary since we're already doing the srcu dereference
for all the slots. I'll move all these RCU annotations to their own
patch and put it at the end of the series when I send v4.
