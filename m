Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 652C129BE86
	for <lists+kvm@lfdr.de>; Tue, 27 Oct 2020 17:57:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1812244AbgJ0QuD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 12:50:03 -0400
Received: from mail-pl1-f201.google.com ([209.85.214.201]:46516 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1812177AbgJ0Qt6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Oct 2020 12:49:58 -0400
Received: by mail-pl1-f201.google.com with SMTP id r9so1251384plo.13
        for <kvm@vger.kernel.org>; Tue, 27 Oct 2020 09:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=9wWRec99gN9dBHws62nUYEcveG+Fv/NYOt3MJb2ccyQ=;
        b=aUMB149cvGGQuG2bVbNSUocZgWt1sioEvdQd1cZrZrEqyOKZ+Quzhm+vTh197m0dc5
         0Vh57Q3oISS9HGv+r2I9dZMDV770VJlHwU3svC8s+mIllf3iDoeX6oD2B7dV2aKqHzUp
         Q4tIdMUo47oLRLSRiXIgnpJsz0dOrget/Unwv/O9XWGXkSFdwArwcINKdj95dtMvsy04
         3czpJYElfSsGu4IpB8T5pMod3JxnvmtlnbSMsqvyJHUnT74eIqXKxdzzyCh2YoBeaGPm
         JMcqioxwFoyynkj9fgCt6MfJLBctSBh6bUW4R3xkleTBkKt0PqXAa/9dUl8iMA82QeYN
         jUYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=9wWRec99gN9dBHws62nUYEcveG+Fv/NYOt3MJb2ccyQ=;
        b=Qg4Da0IQAtmuyGz4/vs3bC2AFrLoh5CMev/Yn+doHKogkTf1fzTXKmOJufagIB6aGw
         ofr4bgIJmUdU8NuTJoMoYcq1hgXql6AM7IH32oDJh1AVsh+Wq2IyeFUlQz0yRwTQCzci
         fAyrRsPJ66inx3cBcH72IN3HkXaCVjxahPs3wEd8lSnD6vxBT6wmxkQthKQQVg6A57nF
         +dDyWA4h9J5IGjJwAsFPVOF5eXMZDMzM4+WHtXp+xinq21oPhacxgV6VZJKnRUMrq/8C
         F8R0fKYPychC6t2LG/IHUirwFd35UKLfTlnAr64GVDbzQWJz6+dPXrvZ3UjOjAPBFDGY
         NCCw==
X-Gm-Message-State: AOAM532rG0Bl0dP19bmLJ+CD7InafaOU/TCP2g3CE9xzp+mj6HTViIHz
        dI4c0GdksAU10ytVoAEp//WMJk6d75D9
X-Google-Smtp-Source: ABdhPJwcmANEN9+xA/xdNMbReOFXLVV5MCPIMd8gklhGJVpnaHvVILVlA/jnwXbAZHA9QeUOm94UHlN8lzAN
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:a17:90a:f198:: with SMTP id
 bv24mr2820492pjb.230.1603817397922; Tue, 27 Oct 2020 09:49:57 -0700 (PDT)
Date:   Tue, 27 Oct 2020 09:49:50 -0700
In-Reply-To: <20201027164950.1057601-1-bgardon@google.com>
Message-Id: <20201027164950.1057601-3-bgardon@google.com>
Mime-Version: 1.0
References: <20201027164950.1057601-1-bgardon@google.com>
X-Mailer: git-send-email 2.29.0.rc2.309.g374f81d7ae-goog
Subject: [PATCH 3/3] sched: Add cond_resched_rwlock
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Shier <pshier@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rescheduling while holding a spin lock is essential for keeping long
running kernel operations running smoothly. Add the facility to
cond_resched rwlocks.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 include/linux/sched.h | 12 ++++++++++++
 kernel/sched/core.c   | 40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 77179160ec3ab..2eb0c53fce115 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1841,12 +1841,24 @@ static inline int _cond_resched(void) { return 0; }
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
index d2003a7d5ab55..ac58e7829a063 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6152,6 +6152,46 @@ int __cond_resched_lock(spinlock_t *lock)
 }
 EXPORT_SYMBOL(__cond_resched_lock);
 
+int __cond_resched_rwlock_read(rwlock_t *lock)
+{
+	int resched = should_resched(PREEMPT_LOCK_OFFSET);
+	int ret = 0;
+
+	lockdep_assert_held(lock);
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
+	lockdep_assert_held(lock);
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
2.29.0.rc2.309.g374f81d7ae-goog

