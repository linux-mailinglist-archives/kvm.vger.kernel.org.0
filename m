Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2957A205622
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 17:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733013AbgFWPjE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 11:39:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:59410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732521AbgFWPjC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 11:39:02 -0400
Received: from paulmck-ThinkPad-P72.home (50-39-105-78.bvtn.or.frontiernet.net [50.39.105.78])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73A4E20723;
        Tue, 23 Jun 2020 15:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592926741;
        bh=+x1igQ+cwGJahoOJANLkVvcfFKTZ4z3VP4CCyxbX6vg=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=1TBY+NtHCatXMh0x3ApkXXBFe0f14Wt+7fwqLHvSh2/22tPRahTYUPd0jbTy++osU
         JSLNRJIaQnKZVNQMh6ggqiDcvvlq7D9makuUG4Yjlldmc3wbK9x6M8DH7UOExsZR4q
         s4OdTFfEb6fy23ojr1kND05pFsPLYxV26Fk8ia48=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 5A3873522657; Tue, 23 Jun 2020 08:39:01 -0700 (PDT)
Date:   Tue, 23 Jun 2020 08:39:01 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Cc:     Joel Fernandes <joel@joelfernandes.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, tglx@linutronix.de,
        bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, frextrite@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH v2] kvm: Fix false positive RCU usage warning
Message-ID: <20200623153901.GG9247@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20200516082227.22194-1-madhuparnabhowmik10@gmail.com>
 <9fff3c6b-1978-c647-16f7-563a1cdf62ff@redhat.com>
 <20200623150236.GD9005@google.com>
 <20200623153036.GB9914@madhuparna-HP-Notebook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623153036.GB9914@madhuparna-HP-Notebook>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 23, 2020 at 09:00:36PM +0530, Madhuparna Bhowmik wrote:
> On Tue, Jun 23, 2020 at 11:02:36AM -0400, Joel Fernandes wrote:
> > On Tue, Jun 23, 2020 at 09:39:53AM +0200, Paolo Bonzini wrote:
> > > On 16/05/20 10:22, madhuparnabhowmik10@gmail.com wrote:
> > > > From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> > > > 
> > > > Fix the following false positive warnings:
> > > > 
> > > > [ 9403.765413][T61744] =============================
> > > > [ 9403.786541][T61744] WARNING: suspicious RCU usage
> > > > [ 9403.807865][T61744] 5.7.0-rc1-next-20200417 #4 Tainted: G             L
> > > > [ 9403.838945][T61744] -----------------------------
> > > > [ 9403.860099][T61744] arch/x86/kvm/mmu/page_track.c:257 RCU-list traversed in non-reader section!!
> > > > 
> > > > and
> > > > 
> > > > [ 9405.859252][T61751] =============================
> > > > [ 9405.859258][T61751] WARNING: suspicious RCU usage
> > > > [ 9405.880867][T61755] -----------------------------
> > > > [ 9405.911936][T61751] 5.7.0-rc1-next-20200417 #4 Tainted: G             L
> > > > [ 9405.911942][T61751] -----------------------------
> > > > [ 9405.911950][T61751] arch/x86/kvm/mmu/page_track.c:232 RCU-list traversed in non-reader section!!
> > > > 
> > > > Since srcu read lock is held, these are false positive warnings.
> > > > Therefore, pass condition srcu_read_lock_held() to
> > > > list_for_each_entry_rcu().
> > > > 
> > > > Reported-by: kernel test robot <lkp@intel.com>
> > > > Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> > > > ---
> > > > v2:
> > > > -Rebase v5.7-rc5
> > > > 
> > > >  arch/x86/kvm/mmu/page_track.c | 6 ++++--
> > > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
> > > > index ddc1ec3bdacd..1ad79c7aa05b 100644
> > > > --- a/arch/x86/kvm/mmu/page_track.c
> > > > +++ b/arch/x86/kvm/mmu/page_track.c
> > > > @@ -229,7 +229,8 @@ void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
> > > >  		return;
> > > >  
> > > >  	idx = srcu_read_lock(&head->track_srcu);
> > > > -	hlist_for_each_entry_rcu(n, &head->track_notifier_list, node)
> > > > +	hlist_for_each_entry_rcu(n, &head->track_notifier_list, node,
> > > > +				srcu_read_lock_held(&head->track_srcu))
> > > >  		if (n->track_write)
> > > >  			n->track_write(vcpu, gpa, new, bytes, n);
> > > >  	srcu_read_unlock(&head->track_srcu, idx);
> > > > @@ -254,7 +255,8 @@ void kvm_page_track_flush_slot(struct kvm *kvm, struct kvm_memory_slot *slot)
> > > >  		return;
> > > >  
> > > >  	idx = srcu_read_lock(&head->track_srcu);
> > > > -	hlist_for_each_entry_rcu(n, &head->track_notifier_list, node)
> > > > +	hlist_for_each_entry_rcu(n, &head->track_notifier_list, node,
> > > > +				srcu_read_lock_held(&head->track_srcu))
> > > >  		if (n->track_flush_slot)
> > > >  			n->track_flush_slot(kvm, slot, n);
> > > >  	srcu_read_unlock(&head->track_srcu, idx);
> > > > 
> > > 
> > > Hi, sorry for the delay in reviewing this patch.  I would like to ask
> > > Paul about it.
> > > 
> > > While you're correctly fixing a false positive, hlist_for_each_entry_rcu
> > > would have a false _negative_ if you called it under
> > > rcu_read_lock/unlock and the data structure was protected by SRCU.  This
> > > is why for example srcu_dereference is used instead of
> > > rcu_dereference_check, and why srcu_dereference uses
> > > __rcu_dereference_check (with the two underscores) instead of
> > > rcu_dereference_check.  Using rcu_dereference_check would add an "||
> > > rcu_read_lock_held()" to the condition which is wrong.
> > > 
> > > I think instead you should add hlist_for_each_srcu and
> > > hlist_for_each_entry_srcu macro to include/linux/rculist.h.
> > > 
> > > There is no need for equivalents of hlist_for_each_entry_continue_rcu
> > > and hlist_for_each_entry_from_rcu, because they use rcu_dereference_raw.
> > >  However, it's not documented why they do so.
> > 
> > You are right, this patch is wrong, we need a new SRCU list macro to do the
> > right thing which would also get rid of the last list argument.
> >
> Can we really get rid of the last argument? We would need the
> srcu_struct right for checking?

Agreed!  However, the API could be simplified by passing in a pointer to
the srcu_struct instead of a lockdep expression.  An optional lockdep
expression might still be helpful for calls from the update side,
of course.

							Thanx, Paul
