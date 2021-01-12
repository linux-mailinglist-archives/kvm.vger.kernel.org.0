Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5FB2F3848
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 19:17:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404123AbhALSMI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 13:12:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392249AbhALSMI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 13:12:08 -0500
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B19A2C0617A4
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 10:10:51 -0800 (PST)
Received: by mail-qt1-x849.google.com with SMTP id k12so2026078qth.23
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 10:10:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=YYAM0gMb6Ie9Zg4dMbGTd9zaeQV742VW9obZJ2+hcf4=;
        b=nO2U+u2ck2oNBTbMMWSRi1Z6lMdws7qKznPVKjOACNivSlgP/JqmcsBhbkJN/VI+7q
         3Dxpk+DPl0PSnTLG40wqP5cJXnsae1Rjs2enFeDQC2Rbwv1P5fBNlKzu2bNH9XK5823X
         ww49j2YxI6MU1HwUDpsM3rYFg9dxRZh+YHL8L1CUJHPdL8TGv/DmDmkx9HjM2PEOghCr
         o7xOltAIZOCa8Izd9ORw+PbNUeWNmtaCj2T5XjmQrX2i2v7T++TNK53TeG/zrGpS+BdR
         XaTV1xs5BJkUOW8abflpW0cMmrfxR+0raPzcUcjrzUWICoSxF8fmHS9SToxikBbP8kuz
         Td+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=YYAM0gMb6Ie9Zg4dMbGTd9zaeQV742VW9obZJ2+hcf4=;
        b=X7SmEJaviaFDNW0SMitIExNRDCuhqaKhpzEehavD94SP7oNPs6M74YCABttV83rkX7
         le5NEpL6ffVfzcTZK92xgBkETVzLCKOI/QEON8ExW07cCUL6LtXmCfUsM9wDJUHqjdOo
         gFc22/hJJEiDOkdZkm62vqQS0K9av0zTpQjgayFMiym+OlnJpFzcLG2oHMiGzdhB5F1Y
         8PY486hXvfGESHyx7fcFrfDQheg1DY0hVPa/j0wDtbuag9kArPIfZ9lg6kXFrREvjWbD
         ANbx5sV56B67jXRCQgl565N93TO4E4YsjKNBPDVOqBdD4IyTX5xB41e8l3JSX68UZ8lZ
         aenQ==
X-Gm-Message-State: AOAM530bbqMvQiR9NgdiP6llyN/ncs01jdAc7h1wxlan7T2wClOqnpVc
        gzVeKO81GS4bvDpLrWyiEmaTgCto4gtX
X-Google-Smtp-Source: ABdhPJxKTHCP58erF28clYSeOqXUy4oCp4yqO+ZJNW445VYt34LMMg+/+kDvNvmn0+BptrrkHx6RIw2xR+ox
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:ad4:442a:: with SMTP id
 e10mr348846qvt.12.1610475050840; Tue, 12 Jan 2021 10:10:50 -0800 (PST)
Date:   Tue, 12 Jan 2021 10:10:20 -0800
In-Reply-To: <20210112181041.356734-1-bgardon@google.com>
Message-Id: <20210112181041.356734-4-bgardon@google.com>
Mime-Version: 1.0
References: <20210112181041.356734-1-bgardon@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH 03/24] sched: Add cond_resched_rwlock
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
index 15d2562118d1..ade357642279 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6695,6 +6695,46 @@ int __cond_resched_lock(spinlock_t *lock)
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
2.30.0.284.gd98b1dd5eaa7-goog

