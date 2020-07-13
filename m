Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D98921C959
	for <lists+kvm@lfdr.de>; Sun, 12 Jul 2020 15:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728847AbgGLNKX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Jul 2020 09:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728686AbgGLNKV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Jul 2020 09:10:21 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32A2AC061794;
        Sun, 12 Jul 2020 06:10:21 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id z3so4763833pfn.12;
        Sun, 12 Jul 2020 06:10:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=NRP39QoMA7cboQj2MMbTyFFjYJ67xWA6XbsSY/jB4dA=;
        b=JhlgiLXkD5O4zUGxXccVQPXMT+O9o31DADprV5OMtKmgXgwlyQDyU6AHHqfQhE5WDR
         gh5b7kg1tMcyp7AboKcI3mVUn5/qm89WJOEiNibftq/jOQEKkxQzTk37RfP+SpFJJd9L
         4TjLUq1DlQ19yLYAdhUXnAvimn3qmIX7ObMY5J2FOxASotv4BtIullWP63iJy4HsroOj
         U65y23wASAoSP20WQ6BwLVSu8J3+lE8szV/mSTbI3FCCUX9/L/nBKqwJsdlrs8NbFA1A
         ugtQV82lcIzXRaUNqb/D4kPjsUKXNmCZ5CTHMUXJ7R74r0HW9eEvKuqZUawq1z60LL84
         IqZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=NRP39QoMA7cboQj2MMbTyFFjYJ67xWA6XbsSY/jB4dA=;
        b=d7PiObanZmbBIQ961R1LOM/mBvtnhEwtoK3Dj+wlkwr6Qu4ZXXF/oXspO8ao3k2R4e
         bSEMrAzIz2DRCxk7lTbbWi39jqVV02VnfFZzGX7J9r41OzCXG6+wWxobOFGIf4AQX9Yj
         ir59KuwdP39gJKanSAvM5J137RiwAqx5uxOyor6Bi3BWrtD9oHxMne3qHdydnCaINyGY
         HzOICjSu1i8zLFBpqTCmdedXNJDBnoBiefOc9qxFIy6Yv9MtQugpj/WDs2jyEVN9aHuO
         sVEYZqUqsOlNGU42kZkE9twbrcF7vxCuuam3F/igfc0ZaoLm+kzu599ICi8n1RF9/goq
         BUPQ==
X-Gm-Message-State: AOAM530JUACt+jbcqxdsK/NZvlJgGxcRY76OVkEl4vuezjjuTTvBgo1b
        uuELXNo0tZVeQu+p4w386A==
X-Google-Smtp-Source: ABdhPJyrr3l21D86j8HF4DyLsuHvOdUtkQkflxGYyEfr832mw/NrHe0iwr46Z+tErL/jQPKe027rGQ==
X-Received: by 2002:a05:6a00:2286:: with SMTP id f6mr68025222pfe.303.1594559420452;
        Sun, 12 Jul 2020 06:10:20 -0700 (PDT)
Received: from localhost.localdomain ([2409:4071:200a:9520:4919:edd3:5dbd:ffec])
        by smtp.gmail.com with ESMTPSA id q24sm12093014pfg.95.2020.07.12.06.10.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2020 06:10:19 -0700 (PDT)
From:   madhuparnabhowmik10@gmail.com
To:     paulmck@kernel.org, josh@joshtriplett.org, joel@joelfernandes.org,
        pbonzini@redhat.com
Cc:     rcu@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        kvm@vger.kernel.org, frextrite@gmail.com,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Subject: [PATCH 1/2] rculist : Introduce list/hlist_for_each_entry_srcu() macros
Date:   Sun, 12 Jul 2020 18:40:02 +0530
Message-Id: <20200712131003.23271-1-madhuparnabhowmik10@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>

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
Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
---
 include/linux/rculist.h | 48 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index df587d181844..516b4feb2682 100644
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
+#define __list_check_srcu(cond)
 #endif
 
 /*
@@ -383,6 +391,25 @@ static inline void list_splice_tail_init_rcu(struct list_head *list,
 		&pos->member != (head);					\
 		pos = list_entry_rcu(pos->member.next, typeof(*pos), member))
 
+/**
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
 /**
  * list_entry_lockless - get the struct for this entry
  * @ptr:        the &struct list_head pointer.
@@ -681,6 +708,27 @@ static inline void hlist_add_behind_rcu(struct hlist_node *n,
 		pos = hlist_entry_safe(rcu_dereference_raw(hlist_next_rcu(\
 			&(pos)->member)), typeof(*(pos)), member))
 
+/**
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
 /**
  * hlist_for_each_entry_rcu_notrace - iterate over rcu list of given type (for tracing)
  * @pos:	the type * to use as a loop cursor.
-- 
2.17.1

