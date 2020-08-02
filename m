Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57212235683
	for <lists+kvm@lfdr.de>; Sun,  2 Aug 2020 13:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728057AbgHBLHw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 2 Aug 2020 07:07:52 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:34241 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726416AbgHBLHv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 2 Aug 2020 07:07:51 -0400
X-Originating-IP: 180.110.142.179
Received: from localhost (unknown [180.110.142.179])
        (Authenticated sender: fly@kernel.page)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 5F47260002;
        Sun,  2 Aug 2020 11:07:34 +0000 (UTC)
Date:   Sun, 2 Aug 2020 19:07:24 +0800
From:   Pengfei Li <fly@kernel.page>
To:     Hugh Dickins <hughd@google.com>
Cc:     akpm@linux-foundation.org, bmt@zurich.ibm.com, dledford@redhat.com,
        willy@infradead.org, vbabka@suse.cz,
        kirill.shutemov@linux.intel.com, jgg@ziepe.ca,
        alex.williamson@redhat.com, cohuck@redhat.com,
        daniel.m.jordan@oracle.com, dbueso@suse.de, jglisse@redhat.com,
        jhubbard@nvidia.com, ldufour@linux.ibm.com,
        Liam.Howlett@oracle.com, peterz@infradead.org, cl@linux.com,
        jack@suse.cz, rientjes@google.com, walken@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, fly@kernel.page
Subject: Re: [PATCH 2/2] mm, util: account_locked_vm() does not hold
 mmap_lock
Message-ID: <20200802190724.493304b6.fly@kernel.page>
In-Reply-To: <alpine.LSU.2.11.2007291121280.4649@eggly.anvils>
References: <20200726080224.205470-1-fly@kernel.page>
        <20200726080224.205470-2-fly@kernel.page>
        <alpine.LSU.2.11.2007291121280.4649@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 29 Jul 2020 12:21:11 -0700 (PDT)
Hugh Dickins <hughd@google.com> wrote:

Sorry for the late reply.

> On Sun, 26 Jul 2020, Pengfei Li wrote:
> 
> > Since mm->locked_vm is already an atomic counter,
> > account_locked_vm() does not need to hold mmap_lock.  
> 
> I am worried that this patch, already added to mmotm, along with its
> 1/2 making locked_vm an atomic64, might be rushed into v5.9 with just
> that two-line commit description, and no discussion at all.
> 
> locked_vm belongs fundamentally to mm/mlock.c, and the lock to guard
> it is mmap_lock; and mlock() has some complicated stuff to do under
> that lock while it decides how to adjust locked_vm.
> 
> It is very easy to convert an unsigned long to an atomic64_t, but
> "atomic read, check limit and do stuff, atomic add" does not give
> the same guarantee as holding the right lock around it all.
> 
> (At the very least, __account_locked_vm() in 1/2 should be changed to
> replace its atomic64_add by an atomic64_cmpxchg, to enforce the limit
> that it just checked.  But that will be no more than lipstick on a
> pig, when the right lock that everyone else agrees upon is not being
> held.)
> 

Thank you for your detailed comment.

You are right, I should use atomic64_cmpxchg to guarantee the limit of
RLIMIT_MEMLOCK.

> Now, it can be argued that our locked_vm and pinned_vm maintenance
> is so random and deficient, and too difficult to keep right across
> a sprawl of drivers, that we should just be grateful for those that
> do volunteer to subject themselves to RLIMIT_MEMLOCK limitation,
> and never mind if it's a little racy.
> 
> And it may well be that all those who have made considerable efforts
> in the past to improve the situation, have more interesting things to
> devote their time to, and would prefer not to get dragged back here.
> 
> But let's at least give this a little more visibility, and hope
> to hear opinions one way or the other from those who care.


Thank you. My patch should be more thoughtful.

I will send an email to Stephen soon asking to remove these two patches
from -mm tree.

-- 
Pengfei
