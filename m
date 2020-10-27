Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 598D429CA35
	for <lists+kvm@lfdr.de>; Tue, 27 Oct 2020 21:31:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S372927AbgJ0UbD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 16:31:03 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60486 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S372920AbgJ0UbD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Oct 2020 16:31:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=137mCpEB0hOOtQ/3RTr3rm5+WNlXz/CS75p2YxOAgxk=; b=Ej/5Tw0LddYjI33JHic/eybIFz
        OmNwO6zfN8JOnkap/hbC90EY8OjQxj5+EKTIv3VoUmKckhOyomQhehjNLaJBD4ELr5m8qDgtkvl69
        1ewQss6VuJw9UrgSIGjhx0ylL3rLrz2srK1cfdBsPa7lmOvI35mUl4w0XsXAWnsV2KkETw4RR6Veb
        NUWLvUAd7zZMM9pd65l5YbMaXGEKX4Iq5+bi5IlYV8SZ2z0eDwA45wHazAVyEfqW+1NFiwBaLk31r
        gsFdpe0+VlGm7O+9Gx2uYRvgKyiADxpJ6bNFRUqll1Nw+Mg/L8WcD92aznyPbKSJmYlYj94S/BY8R
        QfEKkuSg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kXVcC-0002kG-Mh; Tue, 27 Oct 2020 20:30:44 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 3A7C030411F;
        Tue, 27 Oct 2020 21:30:42 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id F36A1203D0A43; Tue, 27 Oct 2020 21:30:41 +0100 (CET)
Date:   Tue, 27 Oct 2020 21:30:41 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v2 1/2] sched/wait: Add add_wait_queue_priority()
Message-ID: <20201027203041.GS2628@hirez.programming.kicks-ass.net>
References: <20201026175325.585623-1-dwmw2@infradead.org>
 <20201027143944.648769-1-dwmw2@infradead.org>
 <20201027143944.648769-2-dwmw2@infradead.org>
 <20201027190919.GO2628@hirez.programming.kicks-ass.net>
 <220a7b090d27ffc8f3d00253c289ddd964a8462b.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <220a7b090d27ffc8f3d00253c289ddd964a8462b.camel@infradead.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 27, 2020 at 07:27:59PM +0000, David Woodhouse wrote:

> > While looking at this I found that weird __add_wait_queue_exclusive()
> > which is used by fs/eventpoll.c and does something similar, except it
> > doesn't keep the FIFO order.
>=20
> It does, doesn't it? Except those so-called "exclusive" entries end up
> in FIFO order amongst themselves at the *tail* of the queue, to be
> woken up only after all the other entries before them *haven't* been
> excluded.

__add_wait_queue_exclusive() uses __add_wait_queue() which does
list_add(). It does _not_ add at the tail like normal exclusive users,
and there is exactly _1_ user in tree that does this.

I'm not exactly sure how this happened, but:

  add_wait_queue_exclusive()

and

  __add_wait_queue_exclusive()

are not related :-(

> > The Changelog doesn't state how important this property is to you.
>=20
> Because it isn't :)
>=20
> The ordering is:
>=20
>  { PRIORITY }*  { NON-EXCLUSIVE }* { EXCLUSIVE(sic) }*
>=20
> I care that PRIORITY comes before the others, because I want to
> actually exclude the others. Especially the "non-exclusive" ones, which
> the 'exclusive' ones don't actually exclude.
>=20
> I absolutely don't care about ordering *within* the set of PRIORITY
> entries, since as I said I expect there to be only one.

Then you could arguably do something like:

	spin_lock_irqsave(&wq_head->lock, flags);
	__add_wait_queue_exclusive(wq_head, wq_entry);
	spin_unlock_irqrestore(&wq_head->lock, flags);

and leave it at that.

But now I'm itching to fix that horrible naming... tomorrow perhaps.

