Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66FB7379706
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 20:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232942AbhEJS3t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 14:29:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231577AbhEJS3t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 14:29:49 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57BDFC06175F
        for <kvm@vger.kernel.org>; Mon, 10 May 2021 11:28:44 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id q15so9685472pgg.12
        for <kvm@vger.kernel.org>; Mon, 10 May 2021 11:28:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZgpaffSujtHNJ5LjhNfC/DukRnISOwF7Vy02GDD16AE=;
        b=DkmtsBN56yN77odOMd87wgYicJgsfSNRc43qNKbvBXiTxDYogtZWKgoqkKBAmKb11h
         cJvETHV9SgeuA5i/WetBSFWnA6oYJdEt2A+aN39XN7vLo7t4iljLWe2hG0I/M7OEL9zF
         s4kYpiMY0lNlR1xuuLzijdaYHsAFZkVVq7eMQzbBDzjniG1ZITWP2NglttnSmlkU6fBy
         BRVUm0qG+cBc6BnWyZAn44uwz9Zv+z5PSvOUARXZyNNNUpOgmTZ6diSpmwvvpPctmyTU
         3kNYIOimswz8DS0CsyKEGlZwNM138LYvA3iSMmEGHccV07iExYBKi5mcuieNfg3RI9e1
         m50Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZgpaffSujtHNJ5LjhNfC/DukRnISOwF7Vy02GDD16AE=;
        b=h/lsxllXEzSpKjYiHfVdLVWVFfFvteJYu7fGhzMakXd4t7x+jKU04+CWCHgz5HCUfI
         SNCJPcUA12ERfXDZpZIoOw1D+tdzrUAQ5Y+ZCjfUCjKLHJMe1h6h3R42sB0dE8hwUbbL
         e+TM4A815CQzxr16Cp2madH9M/qXKP+knZRyuqnyE3X7NzmAy7Z6qjtEktK7MOoG4jAD
         8zR1R6ucCOb3aMD2if7tRS6ZjL+Ol8a8Ddw+CanU+JW1bVYzQh+buUHbYiajB945vqWk
         Luy92WTA0uhLaleIklVzR2llEIbsrD85IF5JzakJiSpRsk87m3Ss93SjuMwPNjiug9gn
         IBDg==
X-Gm-Message-State: AOAM531GoVcpZUj0OjODid67gY7CyuxaXINrimX9c2C1DiM/K3hpx+5G
        LgbTFoOrk6IF7kWJCh+RuVbSBQ==
X-Google-Smtp-Source: ABdhPJzFJKSisbHtuHDKnc5ct9si1UeYWj1pjvyX0xQnyV/dKSb/XbcoDPHhZwfDVBze7d2oUkmqRQ==
X-Received: by 2002:a63:cc57:: with SMTP id q23mr26359576pgi.357.1620671323614;
        Mon, 10 May 2021 11:28:43 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id i3sm149187pjv.30.2021.05.10.11.28.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 11:28:42 -0700 (PDT)
Date:   Mon, 10 May 2021 18:28:39 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Peter Shier <pshier@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH v3 7/8] KVM: x86/mmu: Protect rmaps independently with
 SRCU
Message-ID: <YJl7V1arDXyC6i5P@google.com>
References: <20210506184241.618958-1-bgardon@google.com>
 <20210506184241.618958-8-bgardon@google.com>
 <e2e73709-f247-1a60-4835-f3fad37ab736@redhat.com>
 <YJlxQe1AXljq5yhQ@google.com>
 <a13b6960-3628-2899-5fbf-0765f97aa9eb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a13b6960-3628-2899-5fbf-0765f97aa9eb@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 10, 2021, Paolo Bonzini wrote:
> On 10/05/21 19:45, Sean Christopherson wrote:
> > > 
> > > ---------
> > > Currently, rmaps are always allocated and published together with a new
> > > memslot, so the srcu_dereference for the memslots array already ensures that
> > > the memory pointed to by slots->arch.rmap is zero at the time
> > > slots->arch.rmap.  However, they still need to be accessed in an SRCU
> > > read-side critical section, as the whole memslot can be deleted outside
> > > SRCU.
> > > --------
> > I disagree, sprinkling random and unnecessary __rcu/SRCU annotations does more
> > harm than good.  Adding the unnecessary tag could be quite misleading as it
> > would imply the rmap pointers can_change_  independent of the memslots.
> > 
> > Similary, adding rcu_assign_pointer() in alloc_memslot_rmap() implies that its
> > safe to access the rmap after its pointer is assigned, and that's simply not
> > true since an rmap array can be freed if rmap allocation for a different memslot
> > fails.  Accessing the rmap is safe if and only if all rmaps are allocated, i.e.
> > if arch.memslots_have_rmaps is true, as you pointed out.
> 
> This about freeing is a very good point.
> 
> > Furthermore, to actually gain any protection from SRCU, there would have to be
> > an synchronize_srcu() call after assigning the pointers, and that _does_  have an
> > associated.
> 
> ... but this is incorrect (I was almost going to point out the below in my
> reply to Ben, then decided I was pointing out the obvious; lesson learned).
> 
> synchronize_srcu() is only needed after *deleting* something, which in this

No, synchronization is required any time the writer needs to ensure readers have
recognized the change.  E.g. making a memslot RO, moving a memslot's gfn base,
adding an MSR to the filter list.  I suppose you could frame any modification as
"deleting" something, but IMO that's cheating :-)

> case is done as part of deleting the memslots---it's perfectly fine to batch
> multiple synchronize_*() calls given how expensive some of them are.

Yes, but the shortlog says "Protect rmaps _independently_ with SRCU", emphasis
mine.  If the rmaps are truly protected independently, then they need to have
their own synchronization.  Setting all rmaps could be batched under a single
synchronize_srcu(), but IMO batching the rmaps with the memslot itself would be
in direct contradiction with the shortlog.

> (BTW an associated what?)

Doh.  "associated memslot."

> So they still count as RCU-protected in my opinion, just because reading
> them outside SRCU is a big no and ought to warn (it's unlikely that it
> happens with rmaps, but then we just had 2-3 bugs like this being reported
> in a short time for memslots so never say never).

Yes, but that interpretation holds true for literally everything that is hidden
behind an SRCU-protected pointer.  E.g. this would also be wrong, it's just much
more obviously broken:

bool kvm_is_gfn_writable(struct kvm* kvm, gfn_t gfn)
{
	struct kvm_memory_slot *slot;
	int idx;

	idx = srcu_read_lock(&kvm->srcu);
	slot = gfn_to_memslot(kvm, gfn);
	srcu_read_unlock(&kvm->srcu);

	return slot && !(slot->flags & KVM_MEMSLOT_INVALID) &&
	       !(slot->flags & KVM_MEM_READONLY);
}


> However, rcu_assign_pointer is not needed because the visibility of the rmaps
> is further protected by the have-rmaps flag (to be accessed with
> load-acquire/store-release) and not just by the pointer being there and
> non-NULL.

Yes, and I'm arguing that annotating the rmaps as __rcu is wrong because they
themselves are not protected by SRCU.  The memslot that contains the rmaps is
protected by SRCU, and because of that asserting SRCU is held for read will hold
true.  But, if the memslot code were changed to use a different protection scheme,
e.g. a rwlock for argument's sake, then the SRCU assertion would fail even though
the rmap logic itself didn't change.
