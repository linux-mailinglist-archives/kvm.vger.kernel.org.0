Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79F972272EB
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 01:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726764AbgGTXbO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jul 2020 19:31:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:57452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726021AbgGTXbN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jul 2020 19:31:13 -0400
Received: from paulmck-ThinkPad-P72.home (50-39-111-31.bvtn.or.frontiernet.net [50.39.111.31])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B0E22080D;
        Mon, 20 Jul 2020 23:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595287873;
        bh=sAPZKVWX3Z8asrnYoZ23NOhUHIa2gorGKKngOC75NsM=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=upDieZqHbOoq/fK1dHSW9gTNGzedB0zxg6JJqHBt9ph+uNVg5Nkkrr8yM/xOq2uDz
         0aK7TDrhL4X+b4paWaWnJ6CONxXoHDFWLRabSdXdxN7KyCdp1zwDJ1436/gf7dnVnP
         la9is/HX+QJ+cplZJ+7+PonYNwZADJTZvdomY62Q=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 0E3DA3522C1A; Mon, 20 Jul 2020 16:31:13 -0700 (PDT)
Date:   Mon, 20 Jul 2020 16:31:13 -0700
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
Message-ID: <20200720233113.GZ9247@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20200712131003.23271-2-madhuparnabhowmik10@gmail.com>
 <20200712160856.GW9247@paulmck-ThinkPad-P72>
 <CA+G9fYuVmTcttBpVtegwPbKxufupPOtk_WqEtOdS+HDQi7WS9Q@mail.gmail.com>
 <CAA42JLY2L6xFju_qZsVguGtXvDMqfCKbO_h1K9NJPjmqJEav=Q@mail.gmail.com>
 <20200717170747.GW9247@paulmck-ThinkPad-P72>
 <CA+G9fYvtYr0ri6j-auNOTs98xVj-a1AoZtUfwokwnvuFFWtFdQ@mail.gmail.com>
 <20200718001259.GY9247@paulmck-ThinkPad-P72>
 <CA+G9fYs7s34mmtard-ETjH2r94psgQFLDJWayznvN6UTvMYh5g@mail.gmail.com>
 <20200719160824.GF9247@paulmck-ThinkPad-P72>
 <CA+G9fYueEA0g4arZYQpZo803FHsYvh3WCq=PhYGULHEDa86pSg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYueEA0g4arZYQpZo803FHsYvh3WCq=PhYGULHEDa86pSg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 20, 2020 at 07:43:50PM +0530, Naresh Kamboju wrote:
> On Sun, 19 Jul 2020 at 21:38, Paul E. McKenney <paulmck@kernel.org> wrote:
> >
> > On Sun, Jul 19, 2020 at 05:52:44PM +0530, Naresh Kamboju wrote:
> > > On Sat, 18 Jul 2020 at 05:43, Paul E. McKenney <paulmck@kernel.org> wrote:
> > > >
> > > > On Sat, Jul 18, 2020 at 12:35:12AM +0530, Naresh Kamboju wrote:
> > > > > Hi Paul,
> > > > >
> > > > > > I am not seeing this here.
> > > > >
> > > > > Do you notice any warnings while building linux next master
> > > > > for x86_64 architecture ?
> > > >
> > > > Idiot here was failing to enable building of KVM.  With that, I do see
> > > > the error.  The patch resolves it for me.  Does it help for you?
> > >
> > > yes.
> > > The below patch applied on top of linux -next 20200717 tag
> > > and build pass.
> >
> > Thank you!  May I add your Tested-by?
> 
> That would be great please add
> Tested-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> 
> Thank you !

Done, and thank you for spotting this!

							Thanx, Paul
