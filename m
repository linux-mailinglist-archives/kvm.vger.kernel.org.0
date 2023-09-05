Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6857931FD
	for <lists+kvm@lfdr.de>; Wed,  6 Sep 2023 00:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240449AbjIEWcF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Sep 2023 18:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233077AbjIEWcF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Sep 2023 18:32:05 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 553DDDA
        for <kvm@vger.kernel.org>; Tue,  5 Sep 2023 15:32:01 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-565ece76be4so3345661a12.2
        for <kvm@vger.kernel.org>; Tue, 05 Sep 2023 15:32:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693953121; x=1694557921; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6K862BSBqqIAmRQmrzKkyydyLip85Zk0D+j3zzIdJ9A=;
        b=AcL2fVv5AGY/TTHFMQ2K1cTiBsqmglnW/9nxEonpzawO1qiKtU6AkjPuhozIuMl9xk
         WAIQv1EWeKebfIpINgvknLirEnxmZZ1mutVg4qsFvWnI+fQwQ3XEz1qvdO6NLnQMnXco
         DFuqh7GlNbadQgfwV1M3yjqnUyOXEMoetRk5m6uhrt6DgDG8aipYszQMa135gSZ6brn0
         aAn0glJxR5YVzoTZol42ZvpLDOFsMq4as8D5Jryg4ovXdcRyT51MZNPL2oHgxdA8LWeh
         flMq/lwdcN514kda6FheAsxfp+xQQdfRSYY4fnmPb/oGwkorso98RWEADk8IZ+k8ohjB
         MS2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693953121; x=1694557921;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6K862BSBqqIAmRQmrzKkyydyLip85Zk0D+j3zzIdJ9A=;
        b=UqEHkBc1TCx4H4qkfYRVaV0VqQ0raNw+jBhfjGwqIXskB+6LtI9HYVdswiUOH81/Xs
         HDglB2QRfs+0b5gDv2yIksGTR2+9XbUUZj1JYMKwlaMtJ7n+wKep96VX5pnzccr4cFcZ
         NAbsNlrOsy+SPYrMYo7eONZBTco95TQFZ641jkcmDfzzOpOoRstR+rS9TRxY9tzD5FoU
         kLLVoebtimesdAqzuWSLdQ+zWRf9J5RGJXJ2DEciv4px3tPAdJRamSa2c7c99Yuao4KY
         ZVwwGOpGE1g3mbUcQVSp9+3tcRKA2A7TqpkzvQPwXcmr29KunYBw4ArJBZbpEpzjgB/6
         zSUQ==
X-Gm-Message-State: AOJu0YwBjTC5lykcZXMuF19toxn8TlzQ+0w92nTsms8T+sPP7+4+FfTG
        Fmka7c/ruTvJTWVYqpfe+WBJePGCkzA=
X-Google-Smtp-Source: AGHT+IGSXDkHmoPaGYMFJnlAS2cINxHXbqIReujJOyjiGjn8aSTJoO5naTAUWcCdS0qyyvcGSlBmcq4mguk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:7410:0:b0:564:2c32:360a with SMTP id
 p16-20020a637410000000b005642c32360amr2850602pgc.12.1693953120727; Tue, 05
 Sep 2023 15:32:00 -0700 (PDT)
Date:   Tue, 5 Sep 2023 15:31:59 -0700
In-Reply-To: <ZPWHtUh9SZDc4EoN@yzhao56-desk.sh.intel.com>
Mime-Version: 1.0
References: <20230714064656.20147-1-yan.y.zhao@intel.com> <20230714065631.20869-1-yan.y.zhao@intel.com>
 <ZOkeZi/Xx+1inver@google.com> <ZPWHtUh9SZDc4EoN@yzhao56-desk.sh.intel.com>
Message-ID: <ZPesX2xp6rGZsxlE@google.com>
Subject: Re: [PATCH v4 12/12] KVM: x86/mmu: convert kvm_zap_gfn_range() to use
 shared mmu_lock in TDP MMU
From:   Sean Christopherson <seanjc@google.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, chao.gao@intel.com, kai.huang@intel.com,
        robert.hoo.linux@gmail.com, yuan.yao@linux.intel.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 04, 2023, Yan Zhao wrote:
> On Fri, Aug 25, 2023 at 02:34:30PM -0700, Sean Christopherson wrote:
> > On Fri, Jul 14, 2023, Yan Zhao wrote:
> > > Convert kvm_zap_gfn_range() from holding mmu_lock for write to holding for
> > > read in TDP MMU and allow zapping of non-leaf SPTEs of level <= 1G.
> > > TLB flushes are executed/requested within tdp_mmu_zap_spte_atomic() guarded
> > > by RCU lock.
> > > 
> > > GFN zap can be super slow if mmu_lock is held for write when there are
> > > contentions. In worst cases, huge cpu cycles are spent on yielding GFN by
> > > GFN, i.e. the loop of "check and flush tlb -> drop rcu lock ->
> > > drop mmu_lock -> cpu_relax() -> take mmu_lock -> take rcu lock" are entered
> > > for every GFN.
> > > Contentions can either from concurrent zaps holding mmu_lock for write or
> > > from tdp_mmu_map() holding mmu_lock for read.
> > 
> > The lock contention should go away with a pre-check[*], correct?  That's a more
> Yes, I think so, though I don't have time to verify it yet.
> 
> > complete solution too, in that it also avoids lock contention for the shadow MMU,
> > which presumably suffers the same problem (I don't see anything that would prevent
> > it from yielding).
> > 
> > If we do want to zap with mmu_lock held for read, I think we should convert
> > kvm_tdp_mmu_zap_leafs() and all its callers to run under read, because unless I'm
> > missing something, the rules are the same regardless of _why_ KVM is zapping, e.g.
> > the zap needs to be protected by mmu_invalidate_in_progress, which ensures no other
> > tasks will race to install SPTEs that are supposed to be zapped.
> Yes. I did't do that to the unmap path was only because I don't want to make a
> big code change.
> The write lock in kvm_unmap_gfn_range() path is taken in arch-agnostic code,
> which is not easy to change, right?

Yeah.  The lock itself isn't bad, especially if we can convert all mmu_nofitier
hooks, e.g. we already have KVM_MMU_LOCK(), adding a variant for mmu_notifiers
would be quite easy.

The bigger problem would be kvm_mmu_invalidate_{begin,end}() and getting the
memory ordering right, especially if there are multiple mmu_notifier events in
flight.

But I was actually thinking of a cheesier approach: drop and reacquire mmu_lock
when zapping, e.g. without the necessary changes in tdp_mmu_zap_leafs():

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 735c976913c2..c89a2511789b 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -882,9 +882,15 @@ bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, int as_id, gfn_t start, gfn_t end,
 {
        struct kvm_mmu_page *root;
 
+       write_unlock(&kvm->mmu_lock);
+       read_lock(&kvm->mmu_lock);
+
        for_each_tdp_mmu_root_yield_safe(kvm, root, as_id)
                flush = tdp_mmu_zap_leafs(kvm, root, start, end, can_yield, flush);
 
+       read_unlock(&kvm->mmu_lock);
+       write_lock(&kvm->mmu_lock);
+
        return flush;
 }

vCPUs would still get blocked, but for a smaller duration, and the lock contention
between vCPUs and the zapping task would mostly go away.

> > If you post a version of this patch that converts kvm_tdp_mmu_zap_leafs(), please
> > post it as a standalone patch.  At a glance it doesn't have any dependencies on the
> > MTRR changes, and I don't want this type of changed buried at the end of a series
> > that is for a fairly niche setup.  This needs a lot of scrutiny to make sure zapping
> > under read really is safe
> Given the pre-check patch should work, do you think it's still worthwhile to do
> this convertion?

I do think it would be a net positive, though I don't know that it's worth your
time without a concrete use cases.  My gut instinct could be wrong, so I wouldn't
want to take on the risk of running with mmu_lock held for read without hard
performance numbers to justify the change.
