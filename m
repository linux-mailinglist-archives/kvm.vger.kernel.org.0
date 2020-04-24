Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 617F61B6D89
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 07:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbgDXFwa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 01:52:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:37084 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726598AbgDXFw3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 01:52:29 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 50F4EAEBD;
        Fri, 24 Apr 2020 05:52:26 +0000 (UTC)
From:   Davidlohr Bueso <dave@stgolabs.net>
To:     tglx@linutronix.de, pbonzini@redhat.com
Cc:     peterz@infradead.org, maz@kernel.org, bigeasy@linutronix.de,
        rostedt@goodmis.org, torvalds@linux-foundation.org,
        will@kernel.org, joel@joelfernandes.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dave@stgolabs.net, Davidlohr Bueso <dbueso@suse.de>
Subject: [PATCH 4/5] rcuwait: Introduce rcuwait_active()
Date:   Thu, 23 Apr 2020 22:48:36 -0700
Message-Id: <20200424054837.5138-5-dave@stgolabs.net>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200424054837.5138-1-dave@stgolabs.net>
References: <20200424054837.5138-1-dave@stgolabs.net>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This call is lockless and thus should not be trustedblindly,
ie: for wakeup purposes, which is already provided correctly
by rcuwait_wakeup().

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 include/linux/rcuwait.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/rcuwait.h b/include/linux/rcuwait.h
index 45bc6604e9b1..c1414ce44abc 100644
--- a/include/linux/rcuwait.h
+++ b/include/linux/rcuwait.h
@@ -25,6 +25,15 @@ static inline void rcuwait_init(struct rcuwait *w)
 	w->task = NULL;
 }
 
+/*
+ * Note: this provides no serialization and, just as with waitqueues,
+ * requires care to estimate as to whether or not the wait is active.
+ */
+static inline int rcuwait_active(struct rcuwait *w)
+{
+	return !!rcu_dereference(w->task);
+}
+
 extern int rcuwait_wake_up(struct rcuwait *w);
 
 /*
-- 
2.16.4

