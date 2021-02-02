Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FFE030CAD5
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 20:03:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239259AbhBBTBs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 14:01:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239270AbhBBS7l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 13:59:41 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43F62C061353
        for <kvm@vger.kernel.org>; Tue,  2 Feb 2021 10:57:53 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id e2so14797498pgg.10
        for <kvm@vger.kernel.org>; Tue, 02 Feb 2021 10:57:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=YXSGE321Hb1spvDtzkP5gbN2dNsISQr8m2Sxt2hfEQw=;
        b=Uce/HAumEGErTei5sAOxj/z26CYF6m1y5IaCuTDbahOpmbAfKeJwIsZ5/C9Nce4Y32
         HqvUsSlvypprHj8Y0NYn7Ja5rjDiPQc9yBViVpS6NuVm3tM3DobmSbuSKMc1pk11vKDL
         j0huOX5yXeEkRbrZ/2doRnG8aB9CgoIiSaAHV4+n4sylBtmzYrD2ikUF08UgicRMNXHu
         pVWFBcLzueg/GlszziuntcVgpptkJhEnhpFB2wqeBVa9zDnTa5VSqDB0ClwfvxIUlZht
         fU3+gyQGHX1EcXTK0KGQRCAIV58t0eMe6M84n7/jkdv0+t1lkz8m3y45zTaXZbgkh5qZ
         +LEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=YXSGE321Hb1spvDtzkP5gbN2dNsISQr8m2Sxt2hfEQw=;
        b=ShD3JoEUEs3uNC3STfE3EZ+vTtnODLVz1vzYivl6G8aQUgoP3UAax1kiI97uN6WFV8
         Cm/C1X7xjjya3zc3Cj7cYDekmu476IMMPi+PAVqoJEJDsv3dI0+VAXzwWwiSeqfW9bFq
         QR4TkxoIJa6uWw/sXjcwpUcxDypy5A8kjWeHDwB8HEmmPLGedcGsU3y3iLCcJ05r+Qfb
         KZOcjTkz2V+5kufIPG0upBwaOC8QY+67dGZz4IaEgfQ/RS5Ntg6mn/FAZ6lDyAqUobsB
         aS/hmlpqgoLb4oWmFCgQqBxcaOWYeP6VwkG/fA8Xqm4Q270GWYWtmvpILZR+WvjeSKv6
         +lbQ==
X-Gm-Message-State: AOAM530iX1N0OKvSk0c4/6xiE28d2M6pi5V2TdaqeO1FwCqlk1o5g/Mk
        RjjxNJ/KC4w5dHNedQ3xw8VjB8XDX2s5
X-Google-Smtp-Source: ABdhPJwGrxjV6sQ+79aRBFvtmuGCi22q1OfdwPYkSNZ1JHZ4zNkLjV9kBH8bIzdmXik79XvPQNVs1fxLRmzv
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:9090:561:5a98:6d47])
 (user=bgardon job=sendgmr) by 2002:aa7:9a48:0:b029:1b7:bb17:38c9 with SMTP id
 x8-20020aa79a480000b02901b7bb1738c9mr23164029pfj.51.1612292272799; Tue, 02
 Feb 2021 10:57:52 -0800 (PST)
Date:   Tue,  2 Feb 2021 10:57:14 -0800
In-Reply-To: <20210202185734.1680553-1-bgardon@google.com>
Message-Id: <20210202185734.1680553-9-bgardon@google.com>
Mime-Version: 1.0
References: <20210202185734.1680553-1-bgardon@google.com>
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH v2 08/28] sched: Add cond_resched_rwlock
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Ben Gardon <bgardon@google.com>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Davidlohr Bueso <dbueso@suse.de>,
        Waiman Long <longman@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Safely rescheduling while holding a spin lock is essential for keeping
long running kernel operations running smoothly. Add the facility to
cond_resched rwlocks.

CC: Ingo Molnar <mingo@redhat.com>
CC: Will Deacon <will@kernel.org>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Davidlohr Bueso <dbueso@suse.de>
Acked-by: Waiman Long <longman@redhat.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Ben Gardon <bgardon@google.com>
---
 include/linux/sched.h | 12 ++++++++++++
 kernel/sched/core.c   | 40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5d1378e5a040..3052d16da3cf 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1883,12 +1883,24 @@ static inline int _cond_resched(void) { return 0; }
 })
 
 extern int __cond_resched_lock(spinlock_t *lock);
+extern int __cond_resched_rwlock_read(rwlock_t *lock);
+extern int __cond_resched_rwlock_write(rwlock_t *lock);
 
 #define cond_resched_lock(lock) ({				\
 	___might_sleep(__FILE__, __LINE__, PREEMPT_LOCK_OFFSET);\
 	__cond_resched_lock(lock);				\
 })
 
+#define cond_resched_rwlock_read(lock) ({			\
+	__might_sleep(__FILE__, __LINE__, PREEMPT_LOCK_OFFSET);	\
+	__cond_resched_rwlock_read(lock);			\
+})
+
+#define cond_resched_rwlock_write(lock) ({			\
+	__might_sleep(__FILE__, __LINE__, PREEMPT_LOCK_OFFSET);	\
+	__cond_resched_rwlock_write(lock);			\
+})
+
 static inline void cond_resched_rcu(void)
 {
 #if defined(CONFIG_DEBUG_ATOMIC_SLEEP) || !defined(CONFIG_PREEMPT_RCU)
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index ff74fca39ed2..efed1bf202d1 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6709,6 +6709,46 @@ int __cond_resched_lock(spinlock_t *lock)
 }
 EXPORT_SYMBOL(__cond_resched_lock);
 
+int __cond_resched_rwlock_read(rwlock_t *lock)
+{
+	int resched = should_resched(PREEMPT_LOCK_OFFSET);
+	int ret = 0;
+
+	lockdep_assert_held_read(lock);
+
+	if (rwlock_needbreak(lock) || resched) {
+		read_unlock(lock);
+		if (resched)
+			preempt_schedule_common();
+		else
+			cpu_relax();
+		ret = 1;
+		read_lock(lock);
+	}
+	return ret;
+}
+EXPORT_SYMBOL(__cond_resched_rwlock_read);
+
+int __cond_resched_rwlock_write(rwlock_t *lock)
+{
+	int resched = should_resched(PREEMPT_LOCK_OFFSET);
+	int ret = 0;
+
+	lockdep_assert_held_write(lock);
+
+	if (rwlock_needbreak(lock) || resched) {
+		write_unlock(lock);
+		if (resched)
+			preempt_schedule_common();
+		else
+			cpu_relax();
+		ret = 1;
+		write_lock(lock);
+	}
+	return ret;
+}
+EXPORT_SYMBOL(__cond_resched_rwlock_write);
+
 /**
  * yield - yield the current processor to other threads.
  *
-- 
2.30.0.365.g02bc693789-goog

