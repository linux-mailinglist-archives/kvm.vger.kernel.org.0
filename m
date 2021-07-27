Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 906393D6AEA
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 02:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233959AbhGZXgE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jul 2021 19:36:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233770AbhGZXgD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jul 2021 19:36:03 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 657A0C061757
        for <kvm@vger.kernel.org>; Mon, 26 Jul 2021 17:16:30 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id b1-20020a17090a8001b029017700de3903so1378396pjn.1
        for <kvm@vger.kernel.org>; Mon, 26 Jul 2021 17:16:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zk0iqSB1ekVxBFavbcS07BJzicHkln1Ubagf95g9lFU=;
        b=iQ4uKjQkBkcg9NXmmtkJdbG3r/aSubgEoxmw1PqKWpxvYMQsiQn9tfM/N1E7SXI+W9
         ik+NjCORivZkSwcnT2+NjsPCWAOFjdxoEUQxE214+juzuQiODHr9613qAkMExKR8Cmu2
         n4sO2DpgEFwzb8lfxsrvKI/fkEIPm4XozkewFkRLq/fLeRiG77tRBQr89SZoaIvEvYE2
         BfJ8HCj7cTa+0oCJk2DGP288W3BgtuBYortNx5pxBxDJv71behiTVksKUmEC5zBW3jP+
         ooNbtg93i7YzR4dExLnFjSJFzBXuewhHJHf2qDTyXGc00q921ABACnTXOtkgDl6wuoLy
         r2cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zk0iqSB1ekVxBFavbcS07BJzicHkln1Ubagf95g9lFU=;
        b=OvIUDLb+QgF7ZC+pTxmLAD6M5e7qPj+5c2vraStjJ3wj2zmMKN9hYIO8amate0XWB6
         tTSp+d6mkXia8oAC/2xFGZgxfkEcbBB99WD0NU8BDDxZfkyxzs6pJNcjIdjqMM8khDSd
         4o7FeKhg3QhmktWxzt3+WaN4CoWkGqGq1dPS0frEKYr8g7w7HhUCugH6IGiHzEjm36qJ
         4fmo4OmU5K+p9ldmWRcP1LGbCq2kwTO6DCz8bEivYMuEZZe+nCflXe8qIzR3PTiXpqfa
         ceJRomzrVGjOXRnz3VegbC6aSewXzlzS+ZdPqxxQFALPVepKar05YTYHnw0AOJ63RKxJ
         MyLg==
X-Gm-Message-State: AOAM5309MR9afaQXahw957bcmmCVODIlMVlGEcJwRgbnRYL/zmGKBztQ
        yI3Upliy+m6fbvkdioQKriERnQIrrma2eg==
X-Google-Smtp-Source: ABdhPJyfMOB4JTwlhNWlydYZuJSgZEQFvo61R8gohiRiFLXl21VY+hUhmj3GrF59rYb8HSyiwxsJrw==
X-Received: by 2002:a17:903:31d1:b029:120:2863:cba2 with SMTP id v17-20020a17090331d1b02901202863cba2mr16606268ple.28.1627344989656;
        Mon, 26 Jul 2021 17:16:29 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id p17sm643377pjz.16.2021.07.26.17.16.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 17:16:28 -0700 (PDT)
Date:   Tue, 27 Jul 2021 00:16:25 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>, kvm <kvm@vger.kernel.org>
Subject: Re: [bug report] KVM: x86/mmu: Use an rwlock for the x86 MMU
Message-ID: <YP9QWT4FXYxOg2s8@google.com>
References: <20210726075238.GA10030@kili>
 <CANgfPd-H3a7zdEeV2rtyCTcHinYOwTB=KFFRXYSnYCG8e+tq6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd-H3a7zdEeV2rtyCTcHinYOwTB=KFFRXYSnYCG8e+tq6w@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 26, 2021, Ben Gardon wrote:
> On Mon, Jul 26, 2021 at 12:52 AM Dan Carpenter <dan.carpenter@oracle.com> wrote:
> >
> > [ This is not the correct patch to blame, but there is something going
> >   on here which I don't understand so this email is more about me
> >   learning rather than reporting bugs. - dan ]
> >
> > Hello Ben Gardon,
> >
> > The patch 531810caa9f4: "KVM: x86/mmu: Use an rwlock for the x86 MMU"
> > from Feb 2, 2021, leads to the following static checker warning:
> >
> >         arch/x86/kvm/mmu/mmu.c:5769 kvm_mmu_zap_all()
> >         warn: sleeping in atomic context
> >
> > arch/x86/kvm/mmu/mmu.c
> >     5756 void kvm_mmu_zap_all(struct kvm *kvm)
> >     5757 {
> >     5758        struct kvm_mmu_page *sp, *node;
> >     5759        LIST_HEAD(invalid_list);
> >     5760        int ign;
> >     5761
> >     5762        write_lock(&kvm->mmu_lock);
> >                 ^^^^^^^^^^^^^^^^^^^^^^^^^^
> > This line bumps the preempt count.
> >
> >     5763 restart:
> >     5764        list_for_each_entry_safe(sp, node, &kvm->arch.active_mmu_pages, link) {
> >     5765                if (WARN_ON(sp->role.invalid))
> >     5766                        continue;
> >     5767                if (__kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list, &ign))
> >     5768                        goto restart;
> > --> 5769                if (cond_resched_rwlock_write(&kvm->mmu_lock))
> >                             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > This line triggers a sleeping in atomic warning.  What's going on here
> > that I'm not understanding?
> 
> 
> Hi Dan,
> 
> Thanks for sending this. I'm confused by this sequence too. I'm not
> sure how this could sleep in an atomic context.
> My first thought was that there might be something going on with the
> qrwlock's wait_lock, but since this thread already acquired the
> rwlock, it can't be holding / waiting on the wait_lock.
> 
> Then I thought the __might_sleep could be in the wrong place, but it's
> in the same place for a regular spinlock, so I think that's fine.

The PREEMPT_LOCK_OFFSET parameter to __might_sleep()

  __might_sleep(__FILE__, __LINE__, PREEMPT_LOCK_OFFSET);	\

effectively tells it to exempt a single preemption count via preempt_count_equals()

  void ___might_sleep(const char *file, int line, int preempt_offset)
  {
	...

	if ((preempt_count_equals(preempt_offset) && !irqs_disabled() &&
	     !is_idle_task(current) && !current->non_block_count) ||
	    system_state == SYSTEM_BOOTING || system_state > SYSTEM_RUNNING ||
	    oops_in_progress)
		return;

	...
  }

which returns true if the preempt count equals the passed in offset.
PREEMPT_LOCK_OFFSET is just the vanilla preempt_disable() offset, which is why
there's no special preemption call in the lock/unlock paths.

  #define PREEMPT_LOCK_OFFSET	PREEMPT_DISABLE_OFFSET


Dan, is this coming from Smatch?  If so, is this by chance a new, in-progress
warning that has special code to handle cond_resched_lock()?  I couldn't find
any matches on "sleeping in atomic context" in Smatch.  The rwlock variants,
cond_resched_rwlock_{read,write}() were added specifically for KVM's TDP MMU,
maybe they snuck in after a waiver for cond_resched_lock() was added?
