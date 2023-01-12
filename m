Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0AAD66793C
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 16:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233557AbjALP3k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 10:29:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240425AbjALP2d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 10:28:33 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FCAFC78;
        Thu, 12 Jan 2023 07:20:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E5A8ACE1E5E;
        Thu, 12 Jan 2023 15:20:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0AD5C433EF;
        Thu, 12 Jan 2023 15:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673536849;
        bh=BCtqMXLEe/UrckfTQBcikiufFT6uV7gISnRdD1HnshI=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=rLIAB4+YH0UkEjySHkRENtPC/rBWbpv589rl+z7ZX09HHf3UqIEsEYEaOSAFTkLhH
         Xp8o8rGAg+HFhCmfPublTEgYRnW3MkEvPuprCQm7z5gyJG2R0ZlkTkv+llEUd/qhT9
         9hX143H78hyJzyub1ma/iIkrxUozsRG2th0G0+TgBBkdhWsbrmO4307R55MVVFoJ9U
         d+KyF3qo+ozgNPR2vuugPofojy6gHDiU0BSiW4laDRPOoqnnWv59bmyORkJzRajufJ
         t8v6oABnPEVmBdBJMjusHsRGRai3V4AbFqK75vsPhb8fHZo4sEMLIDoenZ/lTMrAjQ
         ZaZGtbbqXRi7A==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 933835C0AF8; Thu, 12 Jan 2023 07:20:48 -0800 (PST)
Date:   Thu, 12 Jan 2023 07:20:48 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, seanjc@google.com,
        Joel Fernandes <joel@joelfernandes.org>,
        Matthew Wilcox <willy@infradead.org>,
        Josh Triplett <josh@joshtriplett.org>, rcu@vger.kernel.org,
        Michal Luczaj <mhal@rbox.co>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] Documentation: kvm: fix SRCU locking order docs
Message-ID: <20230112152048.GJ4028633@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20230111183031.2449668-1-pbonzini@redhat.com>
 <a14a13a690277d4cc95a4b26aa2d9a4d9b392a74.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a14a13a690277d4cc95a4b26aa2d9a4d9b392a74.camel@infradead.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 12, 2023 at 08:24:16AM +0000, David Woodhouse wrote:
> On Wed, 2023-01-11 at 13:30 -0500, Paolo Bonzini wrote:
> > 
> > +- ``synchronize_srcu(&kvm->srcu)`` is called inside critical sections
> > +  for kvm->lock, vcpu->mutex and kvm->slots_lock.  These locks _cannot_
> > +  be taken inside a kvm->srcu read-side critical section; that is, the
> > +  following is broken::
> > +
> > +      srcu_read_lock(&kvm->srcu);
> > +      mutex_lock(&kvm->slots_lock);
> > +
> 
> "Don't tell me. Tell lockdep!"
> 
> Did we conclude in
> https://lore.kernel.org/kvm/122f38e724aae9ae8ab474233da1ba19760c20d2.camel@infradead.org/
> that lockdep *could* be clever enough to catch a violation of this rule
> by itself?
> 
> The general case of the rule would be that 'if mutex A is taken in a
> read-section for SCRU B, then any synchronize_srcu(B) while mutex A is
> held shall be verboten'. And vice versa.
> 
> If we can make lockdep catch it automatically, yay!

Unfortunately, lockdep needs to see a writer to complain, and that patch
just adds a reader.  And adding that writer would make lockdep complain
about things that are perfectly fine.  It should be possible to make
lockdep catch this sort of thing, but from what I can see, doing so
requires modifications to lockdep itself.

> If not, I'm inclined to suggest that we have explicit wrappers of our
> own for kvm_mutex_lock() which will do the check directly.

This does allow much more wiggle room.  For example, you guys could decide
to let lockdep complain about things that other SRCU users want to do.
For completeness, here is one such scenario:

CPU 0:  read_lock(&rla); srcu_read_lock(&srcua); ...

CPU 1:  srcu_read_lock(&srcua); read_lock(&rla); ...

CPU 2:  synchronize_srcu(&srcua);

CPU 3: 	write_lock(&rla); ...

If you guys are OK with lockdep complaining about this, then doing a
currently mythical rcu_write_acquire()/rcu_write_release() pair around
your calls to synchronize_srcu() should catch the other issue.

And probably break something else, but you have to start somewhere!  ;-)

							Thanx, Paul
