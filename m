Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC1929BE90
	for <lists+kvm@lfdr.de>; Tue, 27 Oct 2020 17:57:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1813379AbgJ0Qvb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 12:51:31 -0400
Received: from mail-qv1-f74.google.com ([209.85.219.74]:45665 "EHLO
        mail-qv1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1813381AbgJ0Qtz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Oct 2020 12:49:55 -0400
Received: by mail-qv1-f74.google.com with SMTP id eh4so1152267qvb.12
        for <kvm@vger.kernel.org>; Tue, 27 Oct 2020 09:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=U+Sl1viisZnw2P5KbSyNcmWeiRs170Jsspt/5pdErgI=;
        b=DubVR4RdHZixj/MazoAiQa7LsELMe7q1j1wcRQtxAhIt8M0+qeroeNmHD6iw8d0SoT
         Vn9FoAs+W07E50WA9CmV1mSfGy6K9ZbVSsWhc83TFGc3jV6w53F2n366neyttweh3dMC
         mFbA15X775tTR+yX4VtaX4HIjQy7TPDPbadAdDGwC3hLD7enHNYSVpcF2PTrNXgWk2lm
         YRXwQNnH9+wgtv0BUvufXORocXPacbXMEaWP8I8UYasrW2d4p/OMRlKVZ+owH6CUStUz
         C3PQ+xNz7nbT91DarInhuvcueeYKu2UhcJtdSRJdvblc8c8upj4QCiB3TNx3oHKD7atD
         DakA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=U+Sl1viisZnw2P5KbSyNcmWeiRs170Jsspt/5pdErgI=;
        b=C+Itt6qiaXulR5+NOD9oCOFbyh/pxBcrsTO7BOscY/WhgIznnMHlYP8/DaA/b7KLGj
         BQCNmt4+msmHXSh5hZz3jKFJDE/N2F4AU7tBUvf8jWqBMyl4gRtn64METwkJeHEVhcFy
         y7SB61tGT0a13zu8VJg+cnVpoB3dmahhOOULRNIXUku0TsTXNtErPlHYiKH+r/sTi/E0
         St13ehhTCQDkHfB1Oxa2E2I1bkqlJPhCQrF9/8DAufAymSHzTIpy1K1O0h5lvAk+D89b
         ZhwJBaAtfAh9QCFJx3m1IM+znM/IImHyz4X9DV4aT3+nkR2JYpSjNaMtOD3LxNm4LFLr
         LQqA==
X-Gm-Message-State: AOAM532HtOC3ArlFBgB7WUeDaQM/cESpm3tZy1l7nxoqMD1vADPNC6s7
        8MgocIOR3wS3jezI72BNThjXysGD23oC
X-Google-Smtp-Source: ABdhPJy7jmfOQfx/bywu9bX0ELil5fzyHmKvy6d8QjRjocYnZAR09IfqYu76mv2cNBj5hnzjZWSZp9IUjefG
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:a0c:aa98:: with SMTP id
 f24mr3241618qvb.62.1603817394270; Tue, 27 Oct 2020 09:49:54 -0700 (PDT)
Date:   Tue, 27 Oct 2020 09:49:48 -0700
Message-Id: <20201027164950.1057601-1-bgardon@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.0.rc2.309.g374f81d7ae-goog
Subject: [PATCH 1/3] locking/rwlocks: Add contention detection for rwlocks
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

rwlocks do not currently have any facility to detect contention
like spinlocks do. In order to allow users of rwlocks to better manage
latency, add contention detection for queued rwlocks.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 include/asm-generic/qrwlock.h | 23 +++++++++++++++++------
 include/linux/rwlock.h        |  7 +++++++
 2 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/include/asm-generic/qrwlock.h b/include/asm-generic/qrwlock.h
index 3aefde23dceab..c4be4673a6ab2 100644
--- a/include/asm-generic/qrwlock.h
+++ b/include/asm-generic/qrwlock.h
@@ -116,15 +116,26 @@ static inline void queued_write_unlock(struct qrwlock *lock)
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
index 3dcd617e65ae9..7ce9a51ae5c04 100644
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
2.29.0.rc2.309.g374f81d7ae-goog

