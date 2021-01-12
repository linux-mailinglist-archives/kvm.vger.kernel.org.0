Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E43642F37FC
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 19:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390897AbhALSL3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 13:11:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728965AbhALSL2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 13:11:28 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 301E7C061795
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 10:10:48 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id a206so3309450ybg.0
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 10:10:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=AT/HhadsSLkfqA9qLz1yJR5FuwQcmEn0C1RS62FkcL4=;
        b=J6taq1Sz6FYVlN36xTqjFZYm8ABILYWAdx6QW+/38pCGCrYz20tUALul8pbOd9n36p
         LAOV3mpAkpmjGyhiZig7aW8hNRawkHmK78ZQxEatXnkFkA59sK1ah8WRiI+dJ3P8va9y
         LqRm6XmejkwIBKKJGlgFOAmnk1DqT/Dj73QmwBhl+XP0LiVRNBMs2pIX1hkhhi0Dxrpi
         pY2hscWTsqiGjTw41xoT9pvLdA1r5hw8EgvHsr+CMiwA6qo1Z4hUivfPMtFF0qHyoUp3
         tg+bdoqELmVaGx5N3TAgK7yTtBpTAd1SR1NMYn4jglYeSZtGRZ3ZkPTSMsGIzYdEUYK1
         PnuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=AT/HhadsSLkfqA9qLz1yJR5FuwQcmEn0C1RS62FkcL4=;
        b=O2bx6RLNsuX6AwavRozUc4bycSqUUmLTXkFpq8NgBRB01Exqp6YLMlqGDpSXS53TDw
         DWRA/wH8Y0PTqYzIsdMt47xpV7uM4LC2G2+3glmHcc9108pR+FoLRuyOZGpRA58Kp4jo
         rdhIB/C2E/Fcow4c1XAeCXZ85lR7CDjdpQc1NGSWb8C2PJgcE6Eb5hCOZeLGkPW1slpe
         +QcGm3fRhTGqw5npVSU+sqKGUQ6Ylcxm4kXw7HehZxe0ALv/J6l+g8K7hcXNAwyRFeLI
         j3xqV55jf8KWwterHjaGy4z7bHCyTrZKHEXQjNqzzKiHlXX7OhuJsC3GNe+RR9hRF+Mg
         nbFg==
X-Gm-Message-State: AOAM532I2ZGm5MRpuIPmFheyNCSlMNt/wRdWZ8fLChuegUAYRkan6mde
        L3BB1GiWRKbX2uLwN427B1FxTVzIbc4W
X-Google-Smtp-Source: ABdhPJwMFpkINzZX1JNlNkc/5A26Ivvmi4jtVWoQuEvFqtIF5atE7j6vpif9VmeLtHE+4jKwza0j7nuxl9ua
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:a25:b28f:: with SMTP id
 k15mr996789ybj.67.1610475047360; Tue, 12 Jan 2021 10:10:47 -0800 (PST)
Date:   Tue, 12 Jan 2021 10:10:18 -0800
In-Reply-To: <20210112181041.356734-1-bgardon@google.com>
Message-Id: <20210112181041.356734-2-bgardon@google.com>
Mime-Version: 1.0
References: <20210112181041.356734-1-bgardon@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH 01/24] locking/rwlocks: Add contention detection for rwlocks
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

rwlocks do not currently have any facility to detect contention
like spinlocks do. In order to allow users of rwlocks to better manage
latency, add contention detection for queued rwlocks.

CC: Ingo Molnar <mingo@redhat.com>
CC: Will Deacon <will@kernel.org>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Davidlohr Bueso <dbueso@suse.de>
Acked-by: Waiman Long <longman@redhat.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 include/asm-generic/qrwlock.h | 24 ++++++++++++++++++------
 include/linux/rwlock.h        |  7 +++++++
 2 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/include/asm-generic/qrwlock.h b/include/asm-generic/qrwlock.h
index 84ce841ce735..0020d3b820a7 100644
--- a/include/asm-generic/qrwlock.h
+++ b/include/asm-generic/qrwlock.h
@@ -14,6 +14,7 @@
 #include <asm/processor.h>
 
 #include <asm-generic/qrwlock_types.h>
+#include <asm-generic/qspinlock.h>
 
 /*
  * Writer states & reader shift and bias.
@@ -116,15 +117,26 @@ static inline void queued_write_unlock(struct qrwlock *lock)
 	smp_store_release(&lock->wlocked, 0);
 }
 
+/**
+ * queued_rwlock_is_contended - check if the lock is contended
+ * @lock : Pointer to queue rwlock structure
+ * Return: 1 if lock contended, 0 otherwise
+ */
+static inline int queued_rwlock_is_contended(struct qrwlock *lock)
+{
+	return arch_spin_is_locked(&lock->wait_lock);
+}
+
 /*
  * Remapping rwlock architecture specific functions to the corresponding
  * queue rwlock functions.
  */
-#define arch_read_lock(l)	queued_read_lock(l)
-#define arch_write_lock(l)	queued_write_lock(l)
-#define arch_read_trylock(l)	queued_read_trylock(l)
-#define arch_write_trylock(l)	queued_write_trylock(l)
-#define arch_read_unlock(l)	queued_read_unlock(l)
-#define arch_write_unlock(l)	queued_write_unlock(l)
+#define arch_read_lock(l)		queued_read_lock(l)
+#define arch_write_lock(l)		queued_write_lock(l)
+#define arch_read_trylock(l)		queued_read_trylock(l)
+#define arch_write_trylock(l)		queued_write_trylock(l)
+#define arch_read_unlock(l)		queued_read_unlock(l)
+#define arch_write_unlock(l)		queued_write_unlock(l)
+#define arch_rwlock_is_contended(l)	queued_rwlock_is_contended(l)
 
 #endif /* __ASM_GENERIC_QRWLOCK_H */
diff --git a/include/linux/rwlock.h b/include/linux/rwlock.h
index 3dcd617e65ae..7ce9a51ae5c0 100644
--- a/include/linux/rwlock.h
+++ b/include/linux/rwlock.h
@@ -128,4 +128,11 @@ do {								\
 	1 : ({ local_irq_restore(flags); 0; }); \
 })
 
+#ifdef arch_rwlock_is_contended
+#define rwlock_is_contended(lock) \
+	 arch_rwlock_is_contended(&(lock)->raw_lock)
+#else
+#define rwlock_is_contended(lock)	((void)(lock), 0)
+#endif /* arch_rwlock_is_contended */
+
 #endif /* __LINUX_RWLOCK_H */
-- 
2.30.0.284.gd98b1dd5eaa7-goog

