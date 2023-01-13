Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 173B0668EE8
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 08:14:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241184AbjAMHON (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 02:14:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241346AbjAMHNn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 02:13:43 -0500
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C3DF84629;
        Thu, 12 Jan 2023 23:00:13 -0800 (PST)
Received: by mail-qt1-x82a.google.com with SMTP id jr10so11152939qtb.7;
        Thu, 12 Jan 2023 23:00:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:feedback-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bL7FAKnljET09Lz5o8O5NOQXfeYUZOAStn+hSKBeOpU=;
        b=mLKdcXQfYIaVPGU/nFUcKanZjagSZZU1Zzk/zDGg8fyKkBdBUeD+aiZqGf4B15lcFD
         XvLY6GMcL3ok/8LM6egXBh+JwQ3GpOSVTaGKk5iulFhBD8m9rlrXHCuI1vnALThnvgqJ
         v4ItVyJtHmiBqkNzcFz3UFZyJPPEdfNxbk4cpw9aYJTT2WB9Gv9cW2Z/f+olVaRzztab
         5+Syy19z6Gh5wnN48AzLIChROYG60r2xu3kc+YOAAvCFMnLRhaRirwxjqPRKExksHLlC
         VF80TrC3GM+c5deULwcIDqZrB7ySmhHAE8S+VVd6OUf/K1SGAzJ6/ika3jnosRIFQI1y
         KVLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:feedback-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bL7FAKnljET09Lz5o8O5NOQXfeYUZOAStn+hSKBeOpU=;
        b=Dpg5lvBqrdPF9STDISpT/AP7Bui9zYJMmO98zeh0unOZgBVArzClwgHWg5M6MUUlT4
         uLYOrtl/UNLrzYnua5S5frrkdj7frukBJ7jMtMXP2IfakLbT5TtD4zMD45xfXl/o5WXu
         MejvtyZ6ak5+TCWlSVoSUFBu/5VrBBo2+qBLQfYUvG/ej13Fs8W1Ho2UBb4gRU7DGGgl
         bm2J+15rpQUPLNWJGt3HPdkSPBMdJ9zjJDn55HQbVxeK8JIkaAt3qOYV/4uN0ArESBUb
         7Dc5QzS7x6Zw0ahkuOvurrkN3gsInuoTFHFcq+gJi7v9X17zBC4+/WNl9dlVbBRNN/Vn
         i+SA==
X-Gm-Message-State: AFqh2krakvt82rw+q2UC+lrt+cQaTtyqbs1Xvf2UnCXQxxGxtlo/5xNE
        wiVr26f4JV2Njc3eeCXdl/c=
X-Google-Smtp-Source: AMrXdXuIMNulWdH7ixWS7z9Lx70JG51NniRsnsm25d0tH8PwKh7R7JqGS38UxepwK9Kan+JJ+wcEuA==
X-Received: by 2002:a05:622a:206:b0:3a7:eb36:5cb3 with SMTP id b6-20020a05622a020600b003a7eb365cb3mr141815642qtx.41.1673593209390;
        Thu, 12 Jan 2023 23:00:09 -0800 (PST)
Received: from auth2-smtp.messagingengine.com (auth2-smtp.messagingengine.com. [66.111.4.228])
        by smtp.gmail.com with ESMTPSA id z26-20020ac8101a000000b003a70a675066sm10121892qti.79.2023.01.12.23.00.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 23:00:08 -0800 (PST)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailauth.nyi.internal (Postfix) with ESMTP id 6892327C005B;
        Fri, 13 Jan 2023 02:00:08 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 13 Jan 2023 02:00:08 -0500
X-ME-Sender: <xms:eAHBY1TXdxnY8Wk6_9nksFMgDH01vISVXi1gLxxE9-AGYM1TIpXctg>
    <xme:eAHBY-xC4iTvmNWN21odyaOvWyl9uXcdU-sp-mg7p8KZYmOi8JALIK-qvBU2w_9PL
    Un1LAVnoHex8InYpA>
X-ME-Received: <xmr:eAHBY63eZk2uhPUj-t58Iv9QTNxPyA64bvS4YtrRByQZg2N8R1IDSPaapTY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrleejgddutdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepuehoqhhu
    nhcuhfgvnhhguceosghoqhhunhdrfhgvnhhgsehgmhgrihhlrdgtohhmqeenucggtffrrg
    htthgvrhhnpeegleejiedthedvheeggfejveefjeejkefgveffieeujefhueeigfegueeh
    geeggfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    gsohhquhhnodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdeiledvgeehtdei
    gedqudejjeekheehhedvqdgsohhquhhnrdhfvghngheppehgmhgrihhlrdgtohhmsehfih
    igmhgvrdhnrghmvg
X-ME-Proxy: <xmx:eAHBY9CpO_Mh_Q1ARxN3EWQR0tcpbu4F8EU9BWZeMq_-57SqAPf8Vw>
    <xmx:eAHBY-jx-1LPBoHbT3VnWFuwpRP7jSvj0xQg9DwneQ1RaUh80RyQHg>
    <xmx:eAHBYxoMY2PmPSY3OuIaS5JWWVwnlYAbHihGYQTvPgUt6a_6CQxgVw>
    <xmx:eAHBY5VZOXMzb-CfPVOyudDWqynl4COZqopplNjBof8LObgSa4iCWw>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 13 Jan 2023 02:00:07 -0500 (EST)
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
Subject: [PATCH 3/3] WIP: locking/lockdep: selftests: Add selftests for SRCU
Date:   Thu, 12 Jan 2023 22:59:55 -0800
Message-Id: <20230113065955.815667-4-boqun.feng@gmail.com>
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

Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
---
 lib/locking-selftest.c | 71 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 71 insertions(+)

diff --git a/lib/locking-selftest.c b/lib/locking-selftest.c
index 8d24279fad05..5fc206a2f9f1 100644
--- a/lib/locking-selftest.c
+++ b/lib/locking-selftest.c
@@ -60,6 +60,7 @@ __setup("debug_locks_verbose=", setup_debug_locks_verbose);
 #define LOCKTYPE_RTMUTEX 0x20
 #define LOCKTYPE_LL	0x40
 #define LOCKTYPE_SPECIAL 0x80
+#define LOCKTYPE_SRCU	0x100
 
 static struct ww_acquire_ctx t, t2;
 static struct ww_mutex o, o2, o3;
@@ -100,6 +101,13 @@ static DEFINE_RT_MUTEX(rtmutex_D);
 
 #endif
 
+#ifdef CONFIG_SRCU
+static struct lock_class_key srcu_A_key;
+static struct lock_class_key srcu_B_key;
+static struct srcu_struct srcu_A;
+static struct srcu_struct srcu_B;
+#endif
+
 /*
  * Locks that we initialize dynamically as well so that
  * e.g. X1 and X2 becomes two instances of the same class,
@@ -1418,6 +1426,12 @@ static void reset_locks(void)
 	memset(&ww_lockdep.acquire_key, 0, sizeof(ww_lockdep.acquire_key));
 	memset(&ww_lockdep.mutex_key, 0, sizeof(ww_lockdep.mutex_key));
 	local_irq_enable();
+
+#ifdef CONFIG_SRCU
+	__init_srcu_struct(&srcu_A, "srcuA", &srcu_A_key);
+	__init_srcu_struct(&srcu_B, "srcuB", &srcu_B_key);
+#endif
+
 }
 
 #undef I
@@ -2360,6 +2374,58 @@ static void ww_tests(void)
 	pr_cont("\n");
 }
 
+static void srcu_ABBA(void)
+{
+	int ia, ib;
+
+	ia = srcu_read_lock(&srcu_A);
+	synchronize_srcu(&srcu_B);
+	srcu_read_unlock(&srcu_A, ia);
+
+	ib = srcu_read_lock(&srcu_B);
+	synchronize_srcu(&srcu_A);
+	srcu_read_unlock(&srcu_B, ib); // should fail
+}
+
+static void srcu_mutex_ABBA(void)
+{
+	int ia;
+
+	mutex_lock(&mutex_A);
+	synchronize_srcu(&srcu_A);
+	mutex_unlock(&mutex_A);
+
+	ia = srcu_read_lock(&srcu_A);
+	mutex_lock(&mutex_A);
+	mutex_unlock(&mutex_A);
+	srcu_read_unlock(&srcu_A, ia); // should fail
+}
+
+static void srcu_irqsafe(void)
+{
+	int ia;
+
+	HARDIRQ_ENTER();
+	ia = srcu_read_lock(&srcu_A);
+	srcu_read_unlock(&srcu_A, ia);
+	HARDIRQ_EXIT();
+
+	synchronize_srcu(&srcu_A); // should NOT fail
+}
+
+static void srcu_tests(void)
+{
+	printk("  --------------------------------------------------------------------------\n");
+	printk("  | SRCU tests |\n");
+	printk("  ---------------\n");
+	print_testname("ABBA read-sync/read-sync");
+	dotest(srcu_ABBA, FAILURE, LOCKTYPE_SRCU);
+	print_testname("ABBA mutex-sync/read-mutex");
+	dotest(srcu_mutex_ABBA, FAILURE, LOCKTYPE_SRCU);
+	print_testname("Irqsafe synchronize_srcu");
+	dotest(srcu_irqsafe, SUCCESS, LOCKTYPE_SRCU);
+	pr_cont("\n");
+}
 
 /*
  * <in hardirq handler>
@@ -2881,6 +2947,10 @@ void locking_selftest(void)
 	printk("  --------------------------------------------------------------------------\n");
 
 	init_shared_classes();
+#ifdef CONFIG_SRCU
+	__init_srcu_struct(&srcu_A, "srcuA", &srcu_A_key);
+	__init_srcu_struct(&srcu_B, "srcuB", &srcu_B_key);
+#endif
 	lockdep_set_selftest_task(current);
 
 	DO_TESTCASE_6R("A-A deadlock", AA);
@@ -2965,6 +3035,7 @@ void locking_selftest(void)
 	DO_TESTCASE_6x2x2RW("irq read-recursion #3", irq_read_recursion3);
 
 	ww_tests();
+	srcu_tests();
 
 	force_read_lock_recursive = 0;
 	/*
-- 
2.38.1

