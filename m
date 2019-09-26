Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE5DBFBC8
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 01:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728929AbfIZXSl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 19:18:41 -0400
Received: from mail-ua1-f73.google.com ([209.85.222.73]:40396 "EHLO
        mail-ua1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728911AbfIZXSk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 19:18:40 -0400
Received: by mail-ua1-f73.google.com with SMTP id i7so440589uak.7
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2019 16:18:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=h1eRr/18Kk3DwWOhz7ufs1Dfy78b771ZeplWcQlEuy0=;
        b=pw5S9DMrlL3FxkxmKKXdeSlEbtW4+3d8ad9H3DRIteICUVHF+DH9uuOuzI6kkd1YdN
         LQ8d9olQUNKNHHuImEDck6FIrBJm2B9NK2CDaS4hFlVKiMXVSSYBhwyMgOMNQShI9FAD
         E3VepwWTQiT7zTWd1uwXSvfefKHyTECdZv9ww0NE3xQaHAHPRAiLEsfpORHyvGmDAWHR
         S5aGmko5heJ06u0EXYsUNzxC/Ei4n6lpGtbTxRh1k5z2dj4QgF4HyMuYwp7LcPCYisz8
         k8jd5h3Hh6gb+zPB9RBiPVPM3RdNdTyl2xntIcrBvl967LbCIAo9JIUapQqlz+nk5i4R
         T7cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=h1eRr/18Kk3DwWOhz7ufs1Dfy78b771ZeplWcQlEuy0=;
        b=q0SoCFeh+ONFVIT8RIulUxO6OVYxHzCj0xQfJ+oGiIfA67xUks1Tc0kc6WPELHs1Sv
         4PrjhZfZm1MoRcWi3Aytq6xRXmfKBsY1NoK2mwcbEVlVNJSRBXC++3pQnQxcLzdLQX5k
         WNHm17EnDeAzypne18+mdFYE+yASkIIn9T/0qqJ69eMrPfNEKRjXYzL8CpES5016wnVd
         3U2ObZDB+sPEl5ZkxN+Rx+lj+xInIRMvgp8zHaInOHgYYjoG8+GvFwMirDNw/ucZOBeT
         2LPcw1NPWwqMWKQypSq1QCTO6ZaPtiOm0Cwu6nEES82S04Jf1VL8MIHK5T8135Z6Qm86
         4RMA==
X-Gm-Message-State: APjAAAUqZSJNHAzrBUNl94gj763WZif5wFTwlgaf1CtSIArGsiKjCwS6
        tXNQliiypU5yUnlMOxSgcCYYJV7mN/v55QBy19ZX4S6jkqHhFjoPwxQzBz0UaDAW4mHYbeGxSap
        ni3lkwKFy8c7tLS22X4VYaSI4r7SAg1CIpNzCT6S5GxYVRjwsd+2vRznpC425
X-Google-Smtp-Source: APXvYqye69RKA0oX4duAzprh6uQ/W780TnSiSOD7EaE7bJJFuaj5qi4FSLICr4SLFWg9uVkhhwZsjG8dT/7z
X-Received: by 2002:a05:6102:224b:: with SMTP id e11mr858013vsb.232.1569539919449;
 Thu, 26 Sep 2019 16:18:39 -0700 (PDT)
Date:   Thu, 26 Sep 2019 16:18:01 -0700
In-Reply-To: <20190926231824.149014-1-bgardon@google.com>
Message-Id: <20190926231824.149014-6-bgardon@google.com>
Mime-Version: 1.0
References: <20190926231824.149014-1-bgardon@google.com>
X-Mailer: git-send-email 2.23.0.444.g18eeb5a265-goog
Subject: [RFC PATCH 05/28] sched: Add cond_resched_rwlock
From:   Ben Gardon <bgardon@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rescheduling while holding a spin lock is essential for keeping long
running kernel operations running smoothly. Add the facility to
cond_resched read/write spin locks.

RFC_NOTE: The current implementation of this patch set uses a read/write
lock to replace the existing MMU spin lock. See the next patch in this
series for more on why a read/write lock was chosen, and possible
alternatives.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 include/linux/sched.h | 11 +++++++++++
 kernel/sched/core.c   | 23 +++++++++++++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 70db597d6fd4f..4d1fd96693d9b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1767,12 +1767,23 @@ static inline int _cond_resched(void) { return 0; }
 })
 
 extern int __cond_resched_lock(spinlock_t *lock);
+extern int __cond_resched_rwlock(rwlock_t *lock, bool write_lock);
 
 #define cond_resched_lock(lock) ({				\
 	___might_sleep(__FILE__, __LINE__, PREEMPT_LOCK_OFFSET);\
 	__cond_resched_lock(lock);				\
 })
 
+#define cond_resched_rwlock_read(lock) ({			\
+	__might_sleep(__FILE__, __LINE__, PREEMPT_LOCK_OFFSET);	\
+	__cond_resched_rwlock(lock, false);			\
+})
+
+#define cond_resched_rwlock_write(lock) ({			\
+	__might_sleep(__FILE__, __LINE__, PREEMPT_LOCK_OFFSET);	\
+	__cond_resched_rwlock(lock, true);			\
+})
+
 static inline void cond_resched_rcu(void)
 {
 #if defined(CONFIG_DEBUG_ATOMIC_SLEEP) || !defined(CONFIG_PREEMPT_RCU)
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index f9a1346a5fa95..ba7ed4bed5036 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5663,6 +5663,29 @@ int __cond_resched_lock(spinlock_t *lock)
 }
 EXPORT_SYMBOL(__cond_resched_lock);
 
+int __cond_resched_rwlock(rwlock_t *lock, bool write_lock)
+{
+	int ret = 0;
+
+	lockdep_assert_held(lock);
+	if (should_resched(PREEMPT_LOCK_OFFSET)) {
+		if (write_lock) {
+			write_unlock(lock);
+			preempt_schedule_common();
+			write_lock(lock);
+		} else {
+			read_unlock(lock);
+			preempt_schedule_common();
+			read_lock(lock);
+		}
+
+		ret = 1;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(__cond_resched_rwlock);
+
 /**
  * yield - yield the current processor to other threads.
  *
-- 
2.23.0.444.g18eeb5a265-goog

