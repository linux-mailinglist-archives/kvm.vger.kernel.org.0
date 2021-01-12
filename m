Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 231C92F380D
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 19:14:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392041AbhALSLm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 13:11:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729128AbhALSLl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 13:11:41 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8A43C0617A2
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 10:10:49 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id e137so3284283ybf.16
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 10:10:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=C9vIvaeT5TM0OnnRWqYO7mCFVABYsaJZT2qRGhHXbMM=;
        b=PV4b8+Nqu6dTrIei2IlEQ8qMMwyHUaAfdM4cHfMSVk7ceox8oaA9sz1MT7qsRERRrS
         s8Z1xt/1cXjtB5b+T3Wg5QS6mvjtRuMyNRTXQsMKQNuUpaFJCPc9UXyiQ+d5FQ1ZzZzW
         XCbpYb+Uu2IJ8br9EyU/EeuStUPvmfpuho743wszk5A3YfE1WpRE7SOEM0+wJGRgifgL
         Lbba2kvdlU5qJJFChaE3n0dH6cHGxdPL2kaEt9icaX7RW1AMH4TVILv3ScM3CciQy2tu
         MTpcErkxRpRsi2nBHRxBoqPKZkWbf1uKdVMP4V7LaPi2SKOYNr/jX6WREK39V2EHtVyZ
         kO1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=C9vIvaeT5TM0OnnRWqYO7mCFVABYsaJZT2qRGhHXbMM=;
        b=Qzr8Pab5V+ekSIjWUhZ0fn4kZheeY2qt/anEnQr+M3ygvv+2HhOY5eYowBZZ2CFf6R
         uT0gwon0v+pB0meZSbkl7ut6BOthzQ9sKLEJWd5xTU93ZNpJKwE0BWNtQWQ1ShIrR2mN
         R4ivmbF0DC6I+MPjEZzvVh4T/jS0aqSw5rtCQ2Alh8OAlsiuFbbrQihlVeFrvl9WrXb5
         5qjuH53j2gHo5M4m04X6RULDOipztZyjqVSmVDiyl1upszpkx15AGkd5KdwWkoLIzpN7
         nn2Qqlfwch6OXeaqVtbeum16U4UYniFnivyivgL6CYRbbrO/o5IDu4dH45Moxe43I46N
         qthw==
X-Gm-Message-State: AOAM533ih9BzXFTuqyGfrAp/k4odLRupzLP0qBDU1cNo2FZw1LhNpgXX
        VkHgLUkDylNEq5/YdDGF8YVH//plJbKB
X-Google-Smtp-Source: ABdhPJywC7dNSUcRIcAleDfsH3vsuteOm8Tk1648RI634RDVUCm7jUNUWjmo6tdiqtjCz24UnHzMPywAXz/m
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:a25:d1c4:: with SMTP id
 i187mr929762ybg.7.1610475049081; Tue, 12 Jan 2021 10:10:49 -0800 (PST)
Date:   Tue, 12 Jan 2021 10:10:19 -0800
In-Reply-To: <20210112181041.356734-1-bgardon@google.com>
Message-Id: <20210112181041.356734-3-bgardon@google.com>
Mime-Version: 1.0
References: <20210112181041.356734-1-bgardon@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH 02/24] sched: Add needbreak for rwlocks
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

Contention awareness while holding a spin lock is essential for reducing
latency when long running kernel operations can hold that lock. Add the
same contention detection interface for read/write spin locks.

CC: Ingo Molnar <mingo@redhat.com>
CC: Will Deacon <will@kernel.org>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Davidlohr Bueso <dbueso@suse.de>
Acked-by: Waiman Long <longman@redhat.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Ben Gardon <bgardon@google.com>
---
 include/linux/sched.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 6e3a5eeec509..5d1378e5a040 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1912,6 +1912,23 @@ static inline int spin_needbreak(spinlock_t *lock)
 #endif
 }
 
+/*
+ * Check if a rwlock is contended.
+ * Returns non-zero if there is another task waiting on the rwlock.
+ * Returns zero if the lock is not contended or the system / underlying
+ * rwlock implementation does not support contention detection.
+ * Technically does not depend on CONFIG_PREEMPTION, but a general need
+ * for low latency.
+ */
+static inline int rwlock_needbreak(rwlock_t *lock)
+{
+#ifdef CONFIG_PREEMPTION
+	return rwlock_is_contended(lock);
+#else
+	return 0;
+#endif
+}
+
 static __always_inline bool need_resched(void)
 {
 	return unlikely(tif_need_resched());
-- 
2.30.0.284.gd98b1dd5eaa7-goog

