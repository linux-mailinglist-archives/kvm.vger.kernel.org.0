Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF4B22416F
	for <lists+kvm@lfdr.de>; Fri, 17 Jul 2020 19:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgGQRHt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jul 2020 13:07:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:45446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726393AbgGQRHt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jul 2020 13:07:49 -0400
Received: from paulmck-ThinkPad-P72.home (50-39-111-31.bvtn.or.frontiernet.net [50.39.111.31])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22F75206BE;
        Fri, 17 Jul 2020 17:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595005668;
        bh=8PErY4JkFNuN6RgbERPf8C06JEM1pVGlvQgrF7hhL1M=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=Gqq7HL+G2FvbH3ADu/8GPBvGA4N+llpoPcdYHkEKhCnuPqMGw8kkZTUpGZt5Mq7cI
         KWzaUNS1oAuwCzbXFpL7QhWOtItqcP+ouWYgg59U9/QIksxs5xp7AZzO87RTs5mWpO
         tNCpi6PzsDHXKjSTUT0sKCnK4Z3ZF0DpDvim5+64=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id EDA2335230B9; Fri, 17 Jul 2020 10:07:47 -0700 (PDT)
Date:   Fri, 17 Jul 2020 10:07:47 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Dexuan-Linux Cui <dexuan.linux@gmail.com>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        madhuparnabhowmik10@gmail.com,
        Josh Triplett <josh@joshtriplett.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Paolo Bonzini <pbonzini@redhat.com>, rcu@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, kvm list <kvm@vger.kernel.org>,
        frextrite@gmail.com, lkft-triage@lists.linaro.org,
        Dexuan Cui <decui@microsoft.com>, juhlee@microsoft.com
Subject: Re: [PATCH 2/2] kvm: mmu: page_track: Fix RCU list API usage
Message-ID: <20200717170747.GW9247@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20200712131003.23271-1-madhuparnabhowmik10@gmail.com>
 <20200712131003.23271-2-madhuparnabhowmik10@gmail.com>
 <20200712160856.GW9247@paulmck-ThinkPad-P72>
 <CA+G9fYuVmTcttBpVtegwPbKxufupPOtk_WqEtOdS+HDQi7WS9Q@mail.gmail.com>
 <CAA42JLY2L6xFju_qZsVguGtXvDMqfCKbO_h1K9NJPjmqJEav=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA42JLY2L6xFju_qZsVguGtXvDMqfCKbO_h1K9NJPjmqJEav=Q@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 16, 2020 at 05:19:52PM -0700, Dexuan-Linux Cui wrote:
> On Thu, Jul 16, 2020 at 7:47 AM Naresh Kamboju
> <naresh.kamboju@linaro.org> wrote:
> >
> > On Sun, 12 Jul 2020 at 21:39, Paul E. McKenney <paulmck@kernel.org> wrote:
> > >
> > > On Sun, Jul 12, 2020 at 06:40:03PM +0530, madhuparnabhowmik10@gmail.com wrote:
> > > > From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> > > >
> > > > Use hlist_for_each_entry_srcu() instead of hlist_for_each_entry_rcu()
> > > > as it also checkes if the right lock is held.
> > > > Using hlist_for_each_entry_rcu() with a condition argument will not
> > > > report the cases where a SRCU protected list is traversed using
> > > > rcu_read_lock(). Hence, use hlist_for_each_entry_srcu().
> > > >
> > > > Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> > >
> > > I queued both for testing and review, thank you!
> > >
> > > In particular, this one needs an ack by the maintainer.
> > >
> > >                                                         Thanx, Paul
> > >
> > > >  arch/x86/kvm/mmu/page_track.c | 6 ++++--
> > > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
> > > > index a7bcde34d1f2..a9cd17625950 100644
> > > > --- a/arch/x86/kvm/mmu/page_track.c
> > > > +++ b/arch/x86/kvm/mmu/page_track.c
> > > > @@ -229,7 +229,8 @@ void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
> > > >               return;
> > > >
> > > >       idx = srcu_read_lock(&head->track_srcu);
> > > > -     hlist_for_each_entry_rcu(n, &head->track_notifier_list, node)
> > > > +     hlist_for_each_entry_srcu(n, &head->track_notifier_list, node,
> > > > +                             srcu_read_lock_held(&head->track_srcu))
> >
> > x86 build failed on linux -next 20200716.
> >
> > arch/x86/kvm/mmu/page_track.c: In function 'kvm_page_track_write':
> > include/linux/rculist.h:727:30: error: left-hand operand of comma
> > expression has no effect [-Werror=unused-value]
> >   for (__list_check_srcu(cond),     \
> >                               ^
> > arch/x86/kvm/mmu/page_track.c:232:2: note: in expansion of macro
> > 'hlist_for_each_entry_srcu'
> >   hlist_for_each_entry_srcu(n, &head->track_notifier_list, node,
> >   ^~~~~~~~~~~~~~~~~~~~~~~~~
> > arch/x86/kvm/mmu/page_track.c: In function 'kvm_page_track_flush_slot':
> > include/linux/rculist.h:727:30: error: left-hand operand of comma
> > expression has no effect [-Werror=unused-value]
> >   for (__list_check_srcu(cond),     \
> >                               ^
> > arch/x86/kvm/mmu/page_track.c:258:2: note: in expansion of macro
> > 'hlist_for_each_entry_srcu'
> >   hlist_for_each_entry_srcu(n, &head->track_notifier_list, node,
> >   ^~~~~~~~~~~~~~~~~~~~~~~~~
> > cc1: all warnings being treated as errors
> > make[3]: *** [arch/x86/kvm/mmu/page_track.o] Error 1
> >
> > build link,
> > https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-next/DISTRO=lkft,MACHINE=intel-corei7-64,label=docker-lkft/815/consoleText
> >
> > --
> > Linaro LKFT
> > https://lkft.linaro.org
> 
> Hi, we're seeing the same building failure with the latest linux-next tree.

I am not seeing this here.  Could you please let us know what compiler
and command-line options you are using to generate this?

							Thanx, Paul
