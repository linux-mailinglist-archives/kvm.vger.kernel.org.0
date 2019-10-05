Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3BC7CCB00
	for <lists+kvm@lfdr.de>; Sat,  5 Oct 2019 18:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729276AbfJEQLm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Oct 2019 12:11:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:37502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726069AbfJEQLm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 5 Oct 2019 12:11:42 -0400
Received: from paulmck-ThinkPad-P72 (50-39-105-78.bvtn.or.frontiernet.net [50.39.105.78])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24CA7222C8;
        Sat,  5 Oct 2019 16:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570291901;
        bh=2CMzIaR11Kg9OxlJablRvzbt0vt48j7Jf7oHeyy/j6o=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=tyjDMtSMnJjosZMCLOf2j36jsGyBJyB4qN7nJZvXnlKBa1UFGMRSisD0wxntGYrpb
         MXmoN383cxXCzvpAdTagMRf7DjkfFN3+lI5Zt0TLAh5n0IUW4bd64xLh7lH0uyMQsS
         5LoBYF6j80tY6Q6ZK2+ccxj608SQRYGEjorv0eSs=
Date:   Sat, 5 Oct 2019 09:11:39 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     rcu@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@kernel.org, jiangshanlai@gmail.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        fweisbec@gmail.com, oleg@redhat.com, joel@joelfernandes.org,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH tip/core/rcu 2/9] x86/kvm/pmu: Replace
 rcu_swap_protected() with rcu_replace()
Message-ID: <20191005161139.GF2689@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20191003014153.GA13156@paulmck-ThinkPad-P72>
 <20191003014310.13262-2-paulmck@kernel.org>
 <dd735e5f-c326-4b53-1126-98c5e38961d3@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dd735e5f-c326-4b53-1126-98c5e38961d3@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 03, 2019 at 12:14:32PM +0200, Paolo Bonzini wrote:
> On 03/10/19 03:43, paulmck@kernel.org wrote:
> > From: "Paul E. McKenney" <paulmck@kernel.org>
> > 
> > This commit replaces the use of rcu_swap_protected() with the more
> > intuitively appealing rcu_replace() as a step towards removing
> > rcu_swap_protected().
> > 
> > Link: https://lore.kernel.org/lkml/CAHk-=wiAsJLw1egFEE=Z7-GGtM6wcvtyytXZA1+BHqta4gg6Hw@mail.gmail.com/
> > Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
> > Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: "Radim Krčmář" <rkrcmar@redhat.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: Borislav Petkov <bp@alien8.de>
> > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > Cc: <x86@kernel.org>
> > Cc: <kvm@vger.kernel.org>
> > ---
> >  arch/x86/kvm/pmu.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> > index 46875bb..4c37266 100644
> > --- a/arch/x86/kvm/pmu.c
> > +++ b/arch/x86/kvm/pmu.c
> > @@ -416,8 +416,8 @@ int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
> >  	*filter = tmp;
> >  
> >  	mutex_lock(&kvm->lock);
> > -	rcu_swap_protected(kvm->arch.pmu_event_filter, filter,
> > -			   mutex_is_locked(&kvm->lock));
> > +	filter = rcu_replace(kvm->arch.pmu_event_filter, filter,
> > +			     mutex_is_locked(&kvm->lock));
> >  	mutex_unlock(&kvm->lock);
> >  
> >  	synchronize_srcu_expedited(&kvm->srcu);
> > 
> 
> Should go without saying, but
> 
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>

It never goes without saying!  ;-)

Applied, thank you!

							Thanx, Paul
