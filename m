Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84D372356B1
	for <lists+kvm@lfdr.de>; Sun,  2 Aug 2020 13:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbgHBLZc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 2 Aug 2020 07:25:32 -0400
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:58157 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726578AbgHBLZb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 2 Aug 2020 07:25:31 -0400
X-Originating-IP: 180.110.142.179
Received: from localhost (unknown [180.110.142.179])
        (Authenticated sender: fly@kernel.page)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id 64DFD20007;
        Sun,  2 Aug 2020 11:24:54 +0000 (UTC)
Date:   Sun, 2 Aug 2020 19:23:47 +0800
From:   Pengfei Li <fly@kernel.page>
To:     Daniel Jordan <daniel.m.jordan@oracle.com>
Cc:     Hugh Dickins <hughd@google.com>, akpm@linux-foundation.org,
        bmt@zurich.ibm.com, dledford@redhat.com, willy@infradead.org,
        vbabka@suse.cz, kirill.shutemov@linux.intel.com, jgg@ziepe.ca,
        alex.williamson@redhat.com, cohuck@redhat.com, dbueso@suse.de,
        jglisse@redhat.com, jhubbard@nvidia.com, ldufour@linux.ibm.com,
        Liam.Howlett@oracle.com, peterz@infradead.org, cl@linux.com,
        jack@suse.cz, rientjes@google.com, walken@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, fly@kernel.page
Subject: Re: [PATCH 2/2] mm, util: account_locked_vm() does not hold
 mmap_lock
Message-ID: <20200802192347.534ece64.fly@kernel.page>
In-Reply-To: <20200730205705.ityqlyeswzo5dkow@ca-dmjordan1.us.oracle.com>
References: <20200726080224.205470-1-fly@kernel.page>
        <20200726080224.205470-2-fly@kernel.page>
        <alpine.LSU.2.11.2007291121280.4649@eggly.anvils>
        <20200730205705.ityqlyeswzo5dkow@ca-dmjordan1.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 30 Jul 2020 16:57:05 -0400
Daniel Jordan <daniel.m.jordan@oracle.com> wrote:

> On Wed, Jul 29, 2020 at 12:21:11PM -0700, Hugh Dickins wrote:
> > On Sun, 26 Jul 2020, Pengfei Li wrote:
> > 
> > > Since mm->locked_vm is already an atomic counter,
> > > account_locked_vm() does not need to hold mmap_lock.
> > 
> > I am worried that this patch, already added to mmotm, along with its
> > 1/2 making locked_vm an atomic64, might be rushed into v5.9 with
> > just that two-line commit description, and no discussion at all.
> > 
> > locked_vm belongs fundamentally to mm/mlock.c, and the lock to guard
> > it is mmap_lock; and mlock() has some complicated stuff to do under
> > that lock while it decides how to adjust locked_vm.
> >
> > It is very easy to convert an unsigned long to an atomic64_t, but
> > "atomic read, check limit and do stuff, atomic add" does not give
> > the same guarantee as holding the right lock around it all.
> 
> Yes, this is why I withdrew my attempt to do something similar last
> year, I didn't want to make the accounting racy. Stack and heap
> growing and mremap would be affected in addition to mlock.
>
> It'd help to hear more about the motivation for this.
> 

Thanks for your comments.

My motivation is to allow mm related counters to be safely read and
written without holding mmap_lock. But sorry i didn't do well.

-- 
Pengfei
