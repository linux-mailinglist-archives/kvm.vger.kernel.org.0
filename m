Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C02D4668EE7
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 08:14:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241152AbjAMHOL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 02:14:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241343AbjAMHNn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 02:13:43 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F16EF84627;
        Thu, 12 Jan 2023 23:00:12 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id e22so5956659qts.1;
        Thu, 12 Jan 2023 23:00:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:feedback-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2GOoHiIdRP/VZku0DE2s2VczcvqEvOMP5ZvCql8uGXE=;
        b=e0ZbKUzaOYfph1jc5vF+2cI41YxAf+sVd9V76ESM1ebXGgABcE8VYHcTuHr/u/9+as
         jMmy01s957P6HNIM9r4ZxUTS/WDPrCjnaDsTYMGjMNlxiAMgGCqTCEGAjnMalsS6y64l
         1dSAqR8j537LdKOmPMU0POUOyI5dtGmhLCrCtIm8XzbQKW02lEW1Ean3M8BjOp8YcFK9
         0MuoCr/VtP76CulD3uDqY4vkrSUn9GzZlXhWVrvj3bBszkckpzt7Q2Pgi2215T41vTL1
         zJhFsDxFXtscHCXWmQmSJCs9XUrvU5m1xLKyhQJxueYglaIrbhE486C/9W/vzsMDi79U
         V3iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:feedback-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2GOoHiIdRP/VZku0DE2s2VczcvqEvOMP5ZvCql8uGXE=;
        b=nUWYCQ1+MM2P3ADBgZ271keVokuCKhhQwWroOFuPZNGsDU+YuJit2r7+LLCU5AUTzO
         O4z0/QV8tfYOya58bx0uuzWuH3HVkMTCEMSIdb0d9IIUlDjrIR0CeVBdtaO0scrzWMMs
         ekmnsuvWlg5MWQTVGbJqfNtawYuoSN93Kxqojb2Gk5akMliPpqMxdsEXjquifrxwLSFB
         mn1zbW0Q/1JCDHIq7hSnGwtugzEWVeqOaNMTSa/2BXVUSrut0HrfoNoUqdTHB+YxmLcv
         LbObavB6635sDjctZcbunNHma4q7MDK3/YcBXZHfcQTjU3JbeSpV7J9/oy7Jw4Dx8aj/
         yfRg==
X-Gm-Message-State: AFqh2kryw0GG+3XGz+lEmJwOOaClXrOx/ESEfdWzJcUrf3/L+vSNQCpu
        w9HrPvaizAi+OUcnE72dnP8=
X-Google-Smtp-Source: AMrXdXtPfxkfND2dGcUigazu67XkeuCJXxDLfP3Lyb1l4igX4UlZ5mawB/Ycf4dtvGBT56khRR+O3Q==
X-Received: by 2002:a05:622a:488b:b0:3a9:9cbb:7cdf with SMTP id fc11-20020a05622a488b00b003a99cbb7cdfmr123259788qtb.40.1673593208014;
        Thu, 12 Jan 2023 23:00:08 -0800 (PST)
Received: from auth2-smtp.messagingengine.com (auth2-smtp.messagingengine.com. [66.111.4.228])
        by smtp.gmail.com with ESMTPSA id bm16-20020a05620a199000b006e16dcf99c8sm12240502qkb.71.2023.01.12.23.00.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 23:00:07 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailauth.nyi.internal (Postfix) with ESMTP id 0A32E27C005B;
        Fri, 13 Jan 2023 02:00:07 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Fri, 13 Jan 2023 02:00:07 -0500
X-ME-Sender: <xms:dgHBYydWilIuiGwpM5YvSV9FsH9eRE86npJPmfJbWOP5MTNfvFSIYA>
    <xme:dgHBY8PUN_QrVVP_SCR2TMBXpmHOylop0X4asc9FZ4q-5OlUv5TuidWuSLZADfVRL
    KU9B2ReXK5KNWyY7A>
X-ME-Received: <xmr:dgHBYzghEVoHeW81hJO4Jba4vbOHdpLcQucrykTSfub39iIAr6sj9vjJK9I>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrleejgddutdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepuehoqhhu
    nhcuhfgvnhhguceosghoqhhunhdrfhgvnhhgsehgmhgrihhlrdgtohhmqeenucggtffrrg
    htthgvrhhnpeegleejiedthedvheeggfejveefjeejkefgveffieeujefhueeigfegueeh
    geeggfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    gsohhquhhnodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdeiledvgeehtdei
    gedqudejjeekheehhedvqdgsohhquhhnrdhfvghngheppehgmhgrihhlrdgtohhmsehfih
    igmhgvrdhnrghmvg
X-ME-Proxy: <xmx:dgHBY__gpjHlMJjStdb84LaxjeOq7-nN34r82WchseSmZF6jBrTkKQ>
    <xmx:dgHBY-uqitvPUn6Em-IIx2HoyPX0peJD6RuQkCp4E5daasSbv7BhOA>
    <xmx:dgHBY2GEJOuxF6i20yj4Xth_QVuq3aIkPCzSfYL6v87Rl3OybMSgLA>
    <xmx:dwHBY2RJWH9dd03Om0ilr4Q-SgZ9kzt3MS0886WllKx8JFfPfC0KZA>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 13 Jan 2023 02:00:06 -0500 (EST)
From:   Boqun Feng <boqun.feng@gmail.com>
To:     linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>, seanjc@google.com,
        Joel Fernandes <joel@joelfernandes.org>,
        Matthew Wilcox <willy@infradead.org>,
        Michal Luczaj <mhal@rbox.co>
Subject: [PATCH 2/3] rcu: Equip sleepable RCU with lockdep dependency graph checks
Date:   Thu, 12 Jan 2023 22:59:54 -0800
Message-Id: <20230113065955.815667-3-boqun.feng@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230113065955.815667-1-boqun.feng@gmail.com>
References: <20230113065955.815667-1-boqun.feng@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Although all flavors of RCU are annotated correctly with lockdep as
recursive read locks, their 'check' parameter of lock_acquire() is
unset. It means that RCU read locks are not added into the lockdep
dependency graph therefore deadlock detection based on dependency graph
won't catch deadlock caused by RCU. This is fine for "non-sleepable" RCU
flavors since wait-context detection and other context based detection
can catch these deadlocks. However for sleepable RCU, this is limited.

Actually we can detect the deadlocks caused by SRCU by 1) making
srcu_read_lock() a 'check'ed recursive read lock and 2) making
synchronize_srcu() a empty write lock critical section. Even better,
with the newly introduced lock_sync(), we can avoid false positives
about irq-unsafe/safe. So do it.

Note that NMI safe SRCU read side critical sections are currently not
annonated, since step-by-step approach can help us deal with
false-positives. These may be annotated in the future.

Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
---
 include/linux/srcu.h  | 23 +++++++++++++++++++++--
 kernel/rcu/srcutiny.c |  2 ++
 kernel/rcu/srcutree.c |  2 ++
 3 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index 9b9d0bbf1d3c..a1595f8c5155 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -102,6 +102,21 @@ static inline int srcu_read_lock_held(const struct srcu_struct *ssp)
 	return lock_is_held(&ssp->dep_map);
 }
 
+static inline void srcu_lock_acquire(struct lockdep_map *map)
+{
+	lock_map_acquire_read(map);
+}
+
+static inline void srcu_lock_release(struct lockdep_map *map)
+{
+	lock_map_release(map);
+}
+
+static inline void srcu_lock_sync(struct lockdep_map *map)
+{
+	lock_map_sync(map);
+}
+
 #else /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
 static inline int srcu_read_lock_held(const struct srcu_struct *ssp)
@@ -109,6 +124,10 @@ static inline int srcu_read_lock_held(const struct srcu_struct *ssp)
 	return 1;
 }
 
+#define srcu_lock_acquire(m) do { } while (0)
+#define srcu_lock_release(m) do { } while (0)
+#define srcu_lock_sync(m) do { } while (0)
+
 #endif /* #else #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
 #define SRCU_NMI_UNKNOWN	0x0
@@ -182,7 +201,7 @@ static inline int srcu_read_lock(struct srcu_struct *ssp) __acquires(ssp)
 
 	srcu_check_nmi_safety(ssp, false);
 	retval = __srcu_read_lock(ssp);
-	rcu_lock_acquire(&(ssp)->dep_map);
+	srcu_lock_acquire(&(ssp)->dep_map);
 	return retval;
 }
 
@@ -226,7 +245,7 @@ static inline void srcu_read_unlock(struct srcu_struct *ssp, int idx)
 {
 	WARN_ON_ONCE(idx & ~0x1);
 	srcu_check_nmi_safety(ssp, false);
-	rcu_lock_release(&(ssp)->dep_map);
+	srcu_lock_release(&(ssp)->dep_map);
 	__srcu_read_unlock(ssp, idx);
 }
 
diff --git a/kernel/rcu/srcutiny.c b/kernel/rcu/srcutiny.c
index b12fb0cec44d..336af24e0fe3 100644
--- a/kernel/rcu/srcutiny.c
+++ b/kernel/rcu/srcutiny.c
@@ -197,6 +197,8 @@ void synchronize_srcu(struct srcu_struct *ssp)
 {
 	struct rcu_synchronize rs;
 
+	srcu_lock_sync(&ssp->dep_map);
+
 	RCU_LOCKDEP_WARN(lockdep_is_held(ssp) ||
 			lock_is_held(&rcu_bh_lock_map) ||
 			lock_is_held(&rcu_lock_map) ||
diff --git a/kernel/rcu/srcutree.c b/kernel/rcu/srcutree.c
index ca4b5dcec675..408088c73e0e 100644
--- a/kernel/rcu/srcutree.c
+++ b/kernel/rcu/srcutree.c
@@ -1267,6 +1267,8 @@ static void __synchronize_srcu(struct srcu_struct *ssp, bool do_norm)
 {
 	struct rcu_synchronize rcu;
 
+	srcu_lock_sync(&ssp->dep_map);
+
 	RCU_LOCKDEP_WARN(lockdep_is_held(ssp) ||
 			 lock_is_held(&rcu_bh_lock_map) ||
 			 lock_is_held(&rcu_lock_map) ||
-- 
2.38.1

