Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 018EC226F68
	for <lists+kvm@lfdr.de>; Mon, 20 Jul 2020 22:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730916AbgGTT7k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jul 2020 15:59:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:42676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726619AbgGTT7k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jul 2020 15:59:40 -0400
Received: from paulmck-ThinkPad-P72.home (50-39-111-31.bvtn.or.frontiernet.net [50.39.111.31])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 465B82080D;
        Mon, 20 Jul 2020 19:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595275179;
        bh=Y/VFPcBEH/6RudEltXYK1AwhXD4qhdonOqY6rcbsqT4=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=AjfVpUKdd9D3Tlh6jf2Oh7w5t/vZRb/FbBoNC5C1EvViGdM0KTAAq3KmHFQD1rKG4
         xCrGkt7gmixykMQE1Gh9IXLeZz67DXvvsz37UW+BVCzsvAjY8QTySrzjMKGlpIGMkF
         RHri6t3NpS9IH9BBmz812DtpZEJWHHU/iSo+0VVQ=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 2B96435230B0; Mon, 20 Jul 2020 12:59:39 -0700 (PDT)
Date:   Mon, 20 Jul 2020 12:59:39 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Subject: Re: linux-next: Tree for Jul 20 (arch/x86/kvm/)
Message-ID: <20200720195939.GU9247@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20200720194225.17de9962@canb.auug.org.au>
 <1d2aa97d-4a94-673c-dc82-509da221c5d6@infradead.org>
 <20200721044307.6b263e5b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200721044307.6b263e5b@canb.auug.org.au>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 21, 2020 at 04:43:07AM +1000, Stephen Rothwell wrote:
> Hi Randy,
> 
> On Mon, 20 Jul 2020 09:56:08 -0700 Randy Dunlap <rdunlap@infradead.org> wrote:
> >
> > on x86_64:
> > 
> >   CC [M]  arch/x86/kvm/mmu/page_track.o
> > In file included from ../include/linux/pid.h:5:0,
> >                  from ../include/linux/sched.h:14,
> >                  from ../include/linux/kvm_host.h:12,
> >                  from ../arch/x86/kvm/mmu/page_track.c:14:
> > ../arch/x86/kvm/mmu/page_track.c: In function ‘kvm_page_track_write’:
> > ../include/linux/rculist.h:727:30: error: left-hand operand of comma expression has no effect [-Werror=unused-value]
> >   for (__list_check_srcu(cond),     \
> >                               ^
> > ../arch/x86/kvm/mmu/page_track.c:232:2: note: in expansion of macro ‘hlist_for_each_entry_srcu’
> >   hlist_for_each_entry_srcu(n, &head->track_notifier_list, node,
> >   ^~~~~~~~~~~~~~~~~~~~~~~~~
> > ../arch/x86/kvm/mmu/page_track.c: In function ‘kvm_page_track_flush_slot’:
> > ../include/linux/rculist.h:727:30: error: left-hand operand of comma expression has no effect [-Werror=unused-value]
> >   for (__list_check_srcu(cond),     \
> >                               ^
> > ../arch/x86/kvm/mmu/page_track.c:258:2: note: in expansion of macro ‘hlist_for_each_entry_srcu’
> >   hlist_for_each_entry_srcu(n, &head->track_notifier_list, node,
> >   ^~~~~~~~~~~~~~~~~~~~~~~~~
> > cc1: all warnings being treated as errors
> 
> Caused by commit
> 
>   bd4444c47de9 ("rculist : Introduce list/hlist_for_each_entry_srcu() macros")
> 
> presumably with CONFIG_PROVE_RCU_LIST not set.

This commit has been obsoleted by the commit shown below, which should
be included in -rcu branch "rcu/next" as of a few hours ago.  The commit
below eliminates this error in my local builds.

So as far as I know, this one is not Randy's fault, fun though it might
be to blame him.  ;-)

							Thanx, Paul

------------------------------------------------------------------------

commit ddd3f0494784e63546816888ba3fbc5aac9d9a54
Author: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Date:   Sun Jul 12 18:40:02 2020 +0530

    rculist : Introduce list/hlist_for_each_entry_srcu() macros
    
    list/hlist_for_each_entry_rcu() provides an optional cond argument
    to specify the lock held in the updater side.
    However for SRCU read side, not providing the cond argument results
    into false positive as whether srcu_read_lock is held or not is not
    checked implicitly. Therefore, on read side the lockdep expression
    srcu_read_lock_held(srcu struct) can solve this issue.
    
    However, the function still fails to check the cases where srcu
    protected list is traversed with rcu_read_lock() instead of
    srcu_read_lock(). Therefore, to remove the false negative,
    this patch introduces two new list traversal primitives :
    list_for_each_entry_srcu() and hlist_for_each_entry_srcu().
    
    Both of the functions have non-optional cond argument
    as it is required for both read and update side, and simply checks
    if the cond is true. For regular read side the lockdep expression
    srcu_read_lock_head() can be passed as the cond argument to
    list/hlist_for_each_entry_srcu().
    
    Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
    Tested-by: Suraj Upadhyay <usuraj35@gmail.com>
    Tested-by: Naresh Kamboju <naresh.kamboju@linaro.org>
    [ paulmck: Add "true" per kbuild test robot feedback. ]
    Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
    Signed-off-by: Paul E. McKenney <paulmck@kernel.org>

diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index 7a6fc99..f8633d3 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -63,9 +63,17 @@ static inline void INIT_LIST_HEAD_RCU(struct list_head *list)
 	RCU_LOCKDEP_WARN(!(cond) && !rcu_read_lock_any_held(),		\
 			 "RCU-list traversed in non-reader section!");	\
 	})
+
+#define __list_check_srcu(cond)					 \
+	({								 \
+	RCU_LOCKDEP_WARN(!(cond),					 \
+		"RCU-list traversed without holding the required lock!");\
+	})
 #else
 #define __list_check_rcu(dummy, cond, extra...)				\
 	({ check_arg_count_one(extra); })
+
+#define __list_check_srcu(cond) ({ })
 #endif
 
 /*
@@ -386,6 +394,25 @@ static inline void list_splice_tail_init_rcu(struct list_head *list,
 		pos = list_entry_rcu(pos->member.next, typeof(*pos), member))
 
 /**
+ * list_for_each_entry_srcu	-	iterate over rcu list of given type
+ * @pos:	the type * to use as a loop cursor.
+ * @head:	the head for your list.
+ * @member:	the name of the list_head within the struct.
+ * @cond:	lockdep expression for the lock required to traverse the list.
+ *
+ * This list-traversal primitive may safely run concurrently with
+ * the _rcu list-mutation primitives such as list_add_rcu()
+ * as long as the traversal is guarded by srcu_read_lock().
+ * The lockdep expression srcu_read_lock_held() can be passed as the
+ * cond argument from read side.
+ */
+#define list_for_each_entry_srcu(pos, head, member, cond)		\
+	for (__list_check_srcu(cond),					\
+	     pos = list_entry_rcu((head)->next, typeof(*pos), member);	\
+		&pos->member != (head);					\
+		pos = list_entry_rcu(pos->member.next, typeof(*pos), member))
+
+/**
  * list_entry_lockless - get the struct for this entry
  * @ptr:        the &struct list_head pointer.
  * @type:       the type of the struct this is embedded in.
@@ -684,6 +711,27 @@ static inline void hlist_add_behind_rcu(struct hlist_node *n,
 			&(pos)->member)), typeof(*(pos)), member))
 
 /**
+ * hlist_for_each_entry_srcu - iterate over rcu list of given type
+ * @pos:	the type * to use as a loop cursor.
+ * @head:	the head for your list.
+ * @member:	the name of the hlist_node within the struct.
+ * @cond:	lockdep expression for the lock required to traverse the list.
+ *
+ * This list-traversal primitive may safely run concurrently with
+ * the _rcu list-mutation primitives such as hlist_add_head_rcu()
+ * as long as the traversal is guarded by srcu_read_lock().
+ * The lockdep expression srcu_read_lock_held() can be passed as the
+ * cond argument from read side.
+ */
+#define hlist_for_each_entry_srcu(pos, head, member, cond)		\
+	for (__list_check_srcu(cond),					\
+	     pos = hlist_entry_safe(rcu_dereference_raw(hlist_first_rcu(head)),\
+			typeof(*(pos)), member);			\
+		pos;							\
+		pos = hlist_entry_safe(rcu_dereference_raw(hlist_next_rcu(\
+			&(pos)->member)), typeof(*(pos)), member))
+
+/**
  * hlist_for_each_entry_rcu_notrace - iterate over rcu list of given type (for tracing)
  * @pos:	the type * to use as a loop cursor.
  * @head:	the head for your list.
