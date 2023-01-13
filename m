Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBF6A668EEA
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 08:14:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238192AbjAMHOQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 02:14:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241348AbjAMHNn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 02:13:43 -0500
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A41284624;
        Thu, 12 Jan 2023 23:00:12 -0800 (PST)
Received: by mail-qt1-x82c.google.com with SMTP id bp44so18540402qtb.0;
        Thu, 12 Jan 2023 23:00:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:feedback-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=GznmxbzHt1/GkzV/aY6yL5SYQJ4MxLBeLk7lBqyQtV8=;
        b=AjYOLvLPeYgnNAMxgu4AnGcdFdltLFw3PYtlit21JmKTN/NkoLycOtUcajLDt9jrwb
         /2lbI1/WlVHu4CiINMh+cMNw6/QzqeJ3UBU1wEgPaN9IU69ZziKpxTi3agj3spNk5XAt
         QbT1r9BMlOV32nkC1rrfeNISmwHHca5BcPF0/CDJ10qEHs1dk7jtblFw5SQD8lX3t3FX
         mREiqQWU/aaWqyWrLAmTKnNGg02UP2oLgtVbcaohR5/JKRzKi3NEUpfT5L1uDYHUj5zy
         w1RTKAFGVKVSzrPxF/foBodHuHpsOQsBIFr+H95o8Qtn2+a99tuhH4VJS1Rv8n+ygQE6
         MFTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:feedback-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GznmxbzHt1/GkzV/aY6yL5SYQJ4MxLBeLk7lBqyQtV8=;
        b=ouMEH1WvoXn/ff1Ilde2efMKsjMoNYYBpyCrnij1iuwBgWg622635uaGuUEyCDXnVd
         zOKlpctwjpocVOpsyBZ1r2GLjLGrX6NKfe+5HgJTADurHlE8/VJyHhJLuBl9p2qzZ+j3
         s7Gpbt+yze1UC1sqTC9uWYQzSzRbkyTF3g9e/eU59h2UVBPi6N3FuwPtLnY19t+OHrug
         htosmO/fiOI7lHBQvPUV9GQMTcxaUsfFWdE+OGhxVSgfE92AcyC3mt6HG2BeOYhyGbXt
         k88ooNLYaGs582eCU07A9/zJ2qpe+OslGMXdLaFtfBFXl31Xd5Nzza/zhjrLTx0J1LTQ
         PEEA==
X-Gm-Message-State: AFqh2kqHFBQ1DXklU2eZIxKiJa6lbEAgoAu0gfzZOMoJrOEBvlCH+zFq
        4Hjt1pOdorsu62O2xIDeixo=
X-Google-Smtp-Source: AMrXdXvlz8Rvoa+zb4zc48toarnc9xMtC2GjJbt47HhSSEGXqXDKE044muBvxEdeKAmobjaAEu8qZw==
X-Received: by 2002:ac8:6882:0:b0:3ab:a3d9:c5c8 with SMTP id m2-20020ac86882000000b003aba3d9c5c8mr72310867qtq.3.1673593206887;
        Thu, 12 Jan 2023 23:00:06 -0800 (PST)
Received: from auth2-smtp.messagingengine.com (auth2-smtp.messagingengine.com. [66.111.4.228])
        by smtp.gmail.com with ESMTPSA id o7-20020ac841c7000000b003a82562c90fsm10107533qtm.62.2023.01.12.23.00.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 23:00:06 -0800 (PST)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailauth.nyi.internal (Postfix) with ESMTP id 9E56927C005B;
        Fri, 13 Jan 2023 02:00:05 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 13 Jan 2023 02:00:05 -0500
X-ME-Sender: <xms:dQHBY8XbD31PhIJE8cokl0G6LUBsmSnPSBSM1NLr4tUEU30WjI162w>
    <xme:dQHBYwmtxTbhaEh7E8xsrAhoKZ1BbCIQ1r2Gtzx8ImfiB16VkY69Hxl7LzVIP1TTg
    12NPGyEbes4AL8Qww>
X-ME-Received: <xmr:dQHBYwYbTTVxAj6GLvBJwseBBmn5-njd52Wlr07el_L3TdzWgGfjfXUBShY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrleejgddutdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepuehoqhhu
    nhcuhfgvnhhguceosghoqhhunhdrfhgvnhhgsehgmhgrihhlrdgtohhmqeenucggtffrrg
    htthgvrhhnpefghfffvefhhfdvgfejgfekvdelgfekgeevueehlefhiedvgeffjefgteeu
    gfehieenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomhepsghoqhhunhdomhgvshhmthhprghuthhh
    phgvrhhsohhnrghlihhthidqieelvdeghedtieegqddujeejkeehheehvddqsghoqhhunh
    drfhgvnhhgpeepghhmrghilhdrtghomhesfhhigihmvgdrnhgrmhgv
X-ME-Proxy: <xmx:dQHBY7VRh1pS3eckNFSKj46MvkCyEMp63KpiTrFTFxWDsvpeNBk-5A>
    <xmx:dQHBY2ksJqTZqIV57DMLPSE-B4E5m8Uk4fXVCU8nGEbCy7yazRidYA>
    <xmx:dQHBYwfb2a_CmFzPR9dmw-84O-SPViqczDKD9fNXQj374b-0-7pYNQ>
    <xmx:dQHBY1oklfIESQidQ2lDz6TZx2zzP33u3sAYvTRByIOB1_FeajR1sw>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 13 Jan 2023 02:00:04 -0500 (EST)
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
Subject: [PATCH 1/3] locking/lockdep: Introduce lock_sync()
Date:   Thu, 12 Jan 2023 22:59:53 -0800
Message-Id: <20230113065955.815667-2-boqun.feng@gmail.com>
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

Currently, in order to annonate functions like synchronize_srcu() for
lockdep, a trick as follow can be used:

	lock_acquire();
	lock_release();

, which indicates synchronize_srcu() acts like an empty critical section
that waits for other (read-side) critical sections to finish. This
surely can catch some deadlock, but as discussion brought up by Paul
Mckenney [1], this could introduce false positives because of
irq-safe/unsafe detection. Extra tricks might help this:

	local_irq_disable(..);
	lock_acquire();
	lock_release();
	local_irq_enable(...);

But it's better that lockdep could provide an annonation for
synchronize_srcu() like functions, so that people won't need to repeat
the ugly tricks above. Therefore introduce lock_sync(). It's simply an
lock+unlock pair with no irq safe/unsafe deadlock check, since the
to-be-annontated functions don't create real critical sections therefore
there is no way that irq can create extra dependencies.

[1]: https://lore.kernel.org/lkml/20180412021233.ewncg5jjuzjw3x62@tardis/

Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
---
 include/linux/lockdep.h  |  5 +++++
 kernel/locking/lockdep.c | 34 ++++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 1f1099dac3f0..ba09df6a0872 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -268,6 +268,10 @@ extern void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 
 extern void lock_release(struct lockdep_map *lock, unsigned long ip);
 
+extern void lock_sync(struct lockdep_map *lock, unsigned int subclass,
+		      int read, int check, struct lockdep_map *nest_lock,
+		      unsigned long ip);
+
 /* lock_is_held_type() returns */
 #define LOCK_STATE_UNKNOWN	-1
 #define LOCK_STATE_NOT_HELD	0
@@ -555,6 +559,7 @@ do {									\
 #define lock_map_acquire_read(l)		lock_acquire_shared_recursive(l, 0, 0, NULL, _THIS_IP_)
 #define lock_map_acquire_tryread(l)		lock_acquire_shared_recursive(l, 0, 1, NULL, _THIS_IP_)
 #define lock_map_release(l)			lock_release(l, _THIS_IP_)
+#define lock_map_sync(l)			lock_sync(l, 0, 0, 1, NULL, _THIS_IP_)
 
 #ifdef CONFIG_PROVE_LOCKING
 # define might_lock(lock)						\
diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index e3375bc40dad..cffa026a765f 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -5692,6 +5692,40 @@ void lock_release(struct lockdep_map *lock, unsigned long ip)
 }
 EXPORT_SYMBOL_GPL(lock_release);
 
+/*
+ * lock_sync() - A special annotation for synchronize_{s,}rcu()-like API.
+ *
+ * No actual critical section is created by the APIs annotated with this: these
+ * APIs are used to wait for one or multiple critical sections (on other CPUs
+ * or threads), and it means that calling these APIs inside these critical
+ * sections is potential deadlock.
+ *
+ * This annotation acts as an acqurie+release anontation pair with hardirqoff
+ * being 1. Since there's no critical section, no interrupt can create extra
+ * dependencies "inside" the annotation, hardirqoff == 1 allows us to avoid
+ * false positives.
+ */
+void lock_sync(struct lockdep_map *lock, unsigned subclass, int read,
+	       int check, struct lockdep_map *nest_lock, unsigned long ip)
+{
+	unsigned long flags;
+
+	if (unlikely(!lockdep_enabled()))
+		return;
+
+	raw_local_irq_save(flags);
+	check_flags(flags);
+
+	lockdep_recursion_inc();
+	__lock_acquire(lock, subclass, 0, read, check, 1, nest_lock, ip, 0, 0);
+
+	if (__lock_release(lock, ip))
+		check_chain_key(current);
+	lockdep_recursion_finish();
+	raw_local_irq_restore(flags);
+}
+EXPORT_SYMBOL_GPL(lock_sync);
+
 noinstr int lock_is_held_type(const struct lockdep_map *lock, int read)
 {
 	unsigned long flags;
-- 
2.38.1

