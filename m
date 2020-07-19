Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C9C02252BD
	for <lists+kvm@lfdr.de>; Sun, 19 Jul 2020 18:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726677AbgGSQIZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Jul 2020 12:08:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:37892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726024AbgGSQIY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Jul 2020 12:08:24 -0400
Received: from paulmck-ThinkPad-P72.home (50-39-111-31.bvtn.or.frontiernet.net [50.39.111.31])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4232820B1F;
        Sun, 19 Jul 2020 16:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595174904;
        bh=0wFOBIblcTxzXV3S2TYEYAJuKoT8vFEuWNcwPnEYwX0=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=JfjG0CXqcBd5lRY4vnMvSNkcYTTZ1+XvSXk6aDp4K/jt4GLqqUcIE9i+GwUoqQhwm
         of0zMIrqPa6vnK50BNr1IZD1u7ERa8G94lzMAMjjdgE19bJMu+B3yxxBEXH7g4+1HL
         BTe0lbHn0WmJRhPPPeJQUfbLSOHcVR2d1FeNr2/k=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 312873522960; Sun, 19 Jul 2020 09:08:24 -0700 (PDT)
Date:   Sun, 19 Jul 2020 09:08:24 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     madhuparnabhowmik10@gmail.com,
        Dexuan-Linux Cui <dexuan.linux@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Paolo Bonzini <pbonzini@redhat.com>, rcu@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, kvm list <kvm@vger.kernel.org>,
        frextrite@gmail.com, lkft-triage@lists.linaro.org,
        Dexuan Cui <decui@microsoft.com>, juhlee@microsoft.com,
        Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Subject: Re: [PATCH 2/2] kvm: mmu: page_track: Fix RCU list API usage
Message-ID: <20200719160824.GF9247@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20200712131003.23271-1-madhuparnabhowmik10@gmail.com>
 <20200712131003.23271-2-madhuparnabhowmik10@gmail.com>
 <20200712160856.GW9247@paulmck-ThinkPad-P72>
 <CA+G9fYuVmTcttBpVtegwPbKxufupPOtk_WqEtOdS+HDQi7WS9Q@mail.gmail.com>
 <CAA42JLY2L6xFju_qZsVguGtXvDMqfCKbO_h1K9NJPjmqJEav=Q@mail.gmail.com>
 <20200717170747.GW9247@paulmck-ThinkPad-P72>
 <CA+G9fYvtYr0ri6j-auNOTs98xVj-a1AoZtUfwokwnvuFFWtFdQ@mail.gmail.com>
 <20200718001259.GY9247@paulmck-ThinkPad-P72>
 <CA+G9fYs7s34mmtard-ETjH2r94psgQFLDJWayznvN6UTvMYh5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYs7s34mmtard-ETjH2r94psgQFLDJWayznvN6UTvMYh5g@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jul 19, 2020 at 05:52:44PM +0530, Naresh Kamboju wrote:
> On Sat, 18 Jul 2020 at 05:43, Paul E. McKenney <paulmck@kernel.org> wrote:
> >
> > On Sat, Jul 18, 2020 at 12:35:12AM +0530, Naresh Kamboju wrote:
> > > Hi Paul,
> > >
> > > > I am not seeing this here.
> > >
> > > Do you notice any warnings while building linux next master
> > > for x86_64 architecture ?
> >
> > Idiot here was failing to enable building of KVM.  With that, I do see
> > the error.  The patch resolves it for me.  Does it help for you?
> 
> yes.
> The below patch applied on top of linux -next 20200717 tag
> and build pass.

Thank you!  May I add your Tested-by?

                                                        Thanx, Paul

> > ------------------------------------------------------------------------
> >
> > diff --git a/include/linux/rculist.h b/include/linux/rculist.h
> > index de9385b..f8633d3 100644
> > --- a/include/linux/rculist.h
> > +++ b/include/linux/rculist.h
> > @@ -73,7 +73,7 @@ static inline void INIT_LIST_HEAD_RCU(struct list_head *list)
> >  #define __list_check_rcu(dummy, cond, extra...)                                \
> >         ({ check_arg_count_one(extra); })
> >
> > -#define __list_check_srcu(cond) true
> > +#define __list_check_srcu(cond) ({ })
> >  #endif
> >
> >  /*
> 
> - Naresh
