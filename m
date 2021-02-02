Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26E9B30CAD3
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 20:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239180AbhBBTBd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 14:01:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239266AbhBBS7k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 13:59:40 -0500
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00FC9C061351
        for <kvm@vger.kernel.org>; Tue,  2 Feb 2021 10:57:52 -0800 (PST)
Received: by mail-qk1-x749.google.com with SMTP id o16so5772569qkj.15
        for <kvm@vger.kernel.org>; Tue, 02 Feb 2021 10:57:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=vKyAzxjQBGxCc4s66Xnux4uLB1j6dF1t9W4yNEtDreQ=;
        b=HVr+0foHl89omFgYiz6hKgzbk/r1SQJ88Zs8DPDXsjmZAaq31A2cgqBUK1kliB2dLq
         sG7UO19OmzTl/YBi3LSFmr7pBXcvljQgn0wOS66SpuMBB7pmSijONEULiDLwfKRw++U8
         UnvmKLWm/nh3u843jmu/z6PA6b9kBAR+2n9J/0CEs9rFiWetr2BijHsoDbVquego91zW
         2zvCpwmtaPy/1UQyrXnbWOBwdho2TC8abniH8zMXYDH/L7+g0wOfGAm5YO+Ji83QReZL
         o3Bkd4l88MRsgyUSIXXqyfthEZuwthav/QQb0nWVw6aA+8wv8eJdiCeZeRjfKHYGoNMi
         5vtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=vKyAzxjQBGxCc4s66Xnux4uLB1j6dF1t9W4yNEtDreQ=;
        b=REYxGfOZbdasseddwSCgt+uss6NdAIiap6+26aSykH2/isLM/qnwsDxzXKK1xHISlq
         YoQzVrRnK2J9jCYtPS5vWlhiHOKfXji0CoiHZgnES0gHxak5QErCm6Fl6qf8eqtWUCil
         bwpeknjC2r1B0+0JuHcZhWFpxHIE6cz/v34jFlVf6D4FjHAsMOOfY/wp3npoRJ+QOnuw
         Ep+bg9lYms2BUC/qoPfsoub7C5O19O5Vx3PSX6JEeZgqiH5C3TwWNfuBG2Hgt76wauaF
         IEqu1VHQlAHs+TpTpHZmXcYSV3yT1eFrjCTg+CK+wGbRT6iuP2Y2/06WdgZgKh8wu4Qt
         XUBQ==
X-Gm-Message-State: AOAM530t8ek/jHBzjp0Nw+ZlHVf0jEYn8nascOptjguyYf+pHi6PD/qB
        levgVsXdO9GEmdOsSckAybTN9d1fuQnm
X-Google-Smtp-Source: ABdhPJyrU5qslteX5GpFz1sPXhfk9MRXnYKDBd+2HCN7lm6NRE5mDx0gL9uFCFJ8m+IP2rUuQOxyS3rObJ25
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:9090:561:5a98:6d47])
 (user=bgardon job=sendgmr) by 2002:a05:6214:446:: with SMTP id
 cc6mr11232321qvb.31.1612292271200; Tue, 02 Feb 2021 10:57:51 -0800 (PST)
Date:   Tue,  2 Feb 2021 10:57:13 -0800
In-Reply-To: <20210202185734.1680553-1-bgardon@google.com>
Message-Id: <20210202185734.1680553-8-bgardon@google.com>
Mime-Version: 1.0
References: <20210202185734.1680553-1-bgardon@google.com>
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH v2 07/28] sched: Add needbreak for rwlocks
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
2.30.0.365.g02bc693789-goog

