Return-Path: <kvm+bounces-9103-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 997B985AA75
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 18:58:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0C3621F25238
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 17:58:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1D4347F53;
	Mon, 19 Feb 2024 17:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="XhSBA8GJ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C5A40BE5;
	Mon, 19 Feb 2024 17:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.171.184.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708365495; cv=none; b=Pw03ogk5rfcpHOQk/mPzSvpwmMLIS72wFyaPNhXCQ5YUVujqMxz77CU3HPitJwLYZOF7EeKhrTCy3VV8Udxewea4ILMQ34yhd1RCUdxqqsVMGJHP+msra6qbmYZoMVxzknpeGwT/B3QEBdVSnTM9owEW5IrST4YhwgHc6L88774=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708365495; c=relaxed/simple;
	bh=yfKQL+noONKk0jucCD3ndMFCGO1JDsIJUpJKdcmpIaI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=EpD1sMolNm7YKMAXOXUHlzCtBkTe14bCsmi5cHdFxMzshptp8NlfH5x/fmmMBBDgCw2DTsDqR7PrQ2J7/FmDWyR/DFzfkpIQfNkT2iNf/39GWeY7UksS+Hbsb7BfbqSpkjKKFiAqL3nXQRDb+5VSovQPCvtHpNWpnXKj79VL4CA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.es; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=XhSBA8GJ; arc=none smtp.client-ip=207.171.184.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.es
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1708365493; x=1739901493;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=hB0ru/jc5Gxx1/HsA7ZYiMQqHu0iOa1WKSLucvQiEoM=;
  b=XhSBA8GJ1n06X93OuI7j+3IAzjOifrjh/pVq3WsFGuEWpTna34JlYzHm
   a1PHWoE9TBQTfaw5mQUGKSLMMnwRthF5Ypgdju73nk75Pj84oCibRqcun
   I9WUhZn78ctcwbcDgg5ZyI5D1oV5Zhzp1kWGgY9wJcqF3qw+wAwm6K9J8
   g=;
X-IronPort-AV: E=Sophos;i="6.06,170,1705363200"; 
   d="scan'208";a="398070645"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.214])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2024 17:58:08 +0000
Received: from EX19MTAEUB001.ant.amazon.com [10.0.10.100:54831]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.34.81:2525] with esmtp (Farcaster)
 id d6b42f38-a9dc-46e3-8fa2-1206ce868cf5; Mon, 19 Feb 2024 17:58:06 +0000 (UTC)
X-Farcaster-Flow-ID: d6b42f38-a9dc-46e3-8fa2-1206ce868cf5
Received: from EX19D004EUC001.ant.amazon.com (10.252.51.190) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Mon, 19 Feb 2024 17:58:05 +0000
Received: from dev-dsk-nsaenz-1b-189b39ae.eu-west-1.amazon.com (10.13.235.138)
 by EX19D004EUC001.ant.amazon.com (10.252.51.190) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Mon, 19 Feb 2024 17:58:01 +0000
From: Nicolas Saenz Julienne <nsaenz@amazon.com>
To: <frederic@kernel.org>, <paulmck@kernel.org>
CC: <jalliste@amazon.co.uk>, <nsaenz@amazon.com>, <mhiramat@kernel.org>,
	<akpm@linux-foundation.org>, <pmladek@suse.com>, <rdunlap@infradead.org>,
	<tsi@tuyoix.net>, <nphamcs@gmail.com>, <gregkh@linuxfoundation.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <pbonzini@redhat.com>,
	<seanjc@google.com>
Subject: [RFC] cputime: Introduce option to force full dynticks accounting on NOHZ & NOHZ_IDLE CPUs
Date: Mon, 19 Feb 2024 17:57:35 +0000
Message-ID: <20240219175735.33171-1-nsaenz@amazon.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D038UWC002.ant.amazon.com (10.13.139.238) To
 EX19D004EUC001.ant.amazon.com (10.252.51.190)

Under certain extreme conditions, the tick-based cputime accounting may
produce inaccurate data. For instance, guest CPU usage is sensitive to
interrupts firing right before the tick's expiration. This forces the
guest into kernel context, and has that time slice wrongly accounted as
system time. This issue is exacerbated if the interrupt source is in
sync with the tick, significantly skewing usage metrics towards system
time.

On CPUs with full dynticks enabled, cputime accounting leverages the
context tracking subsystem to measure usage, and isn't susceptible to
this sort of race conditions. However, this imposes a bigger overhead,
including additional accounting and the extra dyntick tracking during
user<->kernel<->guest transitions (RmW + mb).

So, in order to get the best of both worlds, introduce a cputime
configuration option that allows using the full dynticks accounting
scheme on NOHZ & NOHZ_IDLE CPUs, while avoiding the expensive
user<->kernel<->guest dyntick transitions.

Signed-off-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
Signed-off-by: Jack Allister <jalliste@amazon.co.uk>
---

NOTE: This wasn't tested in depth, and it's mostly intended to highlight
the issue we're trying to solve. Also ccing KVM folks, since it's
relevant to guest CPU usage accounting.

 include/linux/context_tracking.h |  4 ++--
 include/linux/vtime.h            |  6 ++++--
 init/Kconfig                     | 24 +++++++++++++++++++++++-
 kernel/context_tracking.c        | 25 ++++++++++++++++++++++---
 4 files changed, 51 insertions(+), 8 deletions(-)

diff --git a/include/linux/context_tracking.h b/include/linux/context_tracking.h
index 6e76b9dba00e7..dd9b500359aa6 100644
--- a/include/linux/context_tracking.h
+++ b/include/linux/context_tracking.h
@@ -102,11 +102,11 @@ static __always_inline void context_tracking_guest_exit(void) { }
 #define CT_WARN_ON(cond) do { } while (0)
 #endif /* !CONFIG_CONTEXT_TRACKING_USER */
 
-#ifdef CONFIG_CONTEXT_TRACKING_USER_FORCE
+#if defined(CONFIG_CONTEXT_TRACKING_USER_FORCE) || defined(CONFIG_VIRT_CPU_ACCOUNTING_GEN_FORCE)
 extern void context_tracking_init(void);
 #else
 static inline void context_tracking_init(void) { }
-#endif /* CONFIG_CONTEXT_TRACKING_USER_FORCE */
+#endif /* CONFIG_CONTEXT_TRACKING_USER_FORCE || CONFIG_VIRT_CPU_ACCOUNTING_GEN_FORCE */
 
 #ifdef CONFIG_CONTEXT_TRACKING_IDLE
 extern void ct_idle_enter(void);
diff --git a/include/linux/vtime.h b/include/linux/vtime.h
index 3684487d01e1c..d78d01eead6e9 100644
--- a/include/linux/vtime.h
+++ b/include/linux/vtime.h
@@ -79,12 +79,14 @@ static inline bool vtime_accounting_enabled(void)
 
 static inline bool vtime_accounting_enabled_cpu(int cpu)
 {
-	return context_tracking_enabled_cpu(cpu);
+	return IS_ENABLED(CONFIG_VIRT_CPU_ACCOUNTING_GEN_FORCE) ||
+	       context_tracking_enabled_cpu(cpu);
 }
 
 static inline bool vtime_accounting_enabled_this_cpu(void)
 {
-	return context_tracking_enabled_this_cpu();
+	return IS_ENABLED(CONFIG_VIRT_CPU_ACCOUNTING_GEN_FORCE) ||
+	       context_tracking_enabled_this_cpu();
 }
 
 extern void vtime_task_switch_generic(struct task_struct *prev);
diff --git a/init/Kconfig b/init/Kconfig
index 9ffb103fc927b..86877e1f416fc 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -473,6 +473,9 @@ menu "CPU/Task time and stats accounting"
 config VIRT_CPU_ACCOUNTING
 	bool
 
+config VIRT_CPU_ACCOUNTING_GEN
+	bool
+
 choice
 	prompt "Cputime accounting"
 	default TICK_CPU_ACCOUNTING
@@ -501,12 +504,13 @@ config VIRT_CPU_ACCOUNTING_NATIVE
 	  this also enables accounting of stolen time on logically-partitioned
 	  systems.
 
-config VIRT_CPU_ACCOUNTING_GEN
+config VIRT_CPU_ACCOUNTING_DYNTICKS
 	bool "Full dynticks CPU time accounting"
 	depends on HAVE_CONTEXT_TRACKING_USER
 	depends on HAVE_VIRT_CPU_ACCOUNTING_GEN
 	depends on GENERIC_CLOCKEVENTS
 	select VIRT_CPU_ACCOUNTING
+	select VIRT_CPU_ACCOUNTING_GEN
 	select CONTEXT_TRACKING_USER
 	help
 	  Select this option to enable task and CPU time accounting on full
@@ -520,8 +524,26 @@ config VIRT_CPU_ACCOUNTING_GEN
 
 	  If unsure, say N.
 
+config VIRT_CPU_ACCOUNTING_GEN_FORCE
+	bool "Force full dynticks CPU time accounting"
+	depends on HAVE_CONTEXT_TRACKING_USER
+	depends on HAVE_VIRT_CPU_ACCOUNTING_GEN
+	depends on GENERIC_CLOCKEVENTS
+	select VIRT_CPU_ACCOUNTING
+	select VIRT_CPU_ACCOUNTING_GEN
+	select CONTEXT_TRACKING_USER
+	help
+	  Select this option to forcibly enable the full dynticks CPU time
+	  accounting. This accounting is implemented by watching every
+	  kernel-user boundaries using the context tracking subsystem. The
+	  accounting is thus performed at the expense of some overhead, but is
+	  more precise than tick based CPU accounting.
+
+	  If unsure, say N.
+
 endchoice
 
+
 config IRQ_TIME_ACCOUNTING
 	bool "Fine granularity task level IRQ time accounting"
 	depends on HAVE_IRQ_TIME_ACCOUNTING && !VIRT_CPU_ACCOUNTING_NATIVE
diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
index 6ef0b35fc28c5..f70949430cf11 100644
--- a/kernel/context_tracking.c
+++ b/kernel/context_tracking.c
@@ -537,6 +537,13 @@ void noinstr __ct_user_enter(enum ctx_state state)
 				 */
 				raw_atomic_add(state, &ct->state);
 			}
+
+			if (IS_ENABLED(CONFIG_VIRT_CPU_ACCOUNTING_GEN_FORCE) &&
+			    state == CONTEXT_USER) {
+				instrumentation_begin();
+				vtime_user_enter(current);
+				instrumentation_end();
+			}
 		}
 	}
 	context_tracking_recursion_exit();
@@ -645,6 +652,13 @@ void noinstr __ct_user_exit(enum ctx_state state)
 				 */
 				raw_atomic_sub(state, &ct->state);
 			}
+
+			if (IS_ENABLED(CONFIG_VIRT_CPU_ACCOUNTING_GEN_FORCE) &&
+			    state == CONTEXT_USER) {
+				instrumentation_begin();
+				vtime_user_exit(current);
+				instrumentation_end();
+			}
 		}
 	}
 	context_tracking_recursion_exit();
@@ -715,13 +729,18 @@ void __init ct_cpu_track_user(int cpu)
 	initialized = true;
 }
 
-#ifdef CONFIG_CONTEXT_TRACKING_USER_FORCE
+#if defined(CONFIG_CONTEXT_TRACKING_USER_FORCE) || defined(CONFIG_VIRT_CPU_ACCOUNTING_GEN_FORCE)
 void __init context_tracking_init(void)
 {
 	int cpu;
 
-	for_each_possible_cpu(cpu)
-		ct_cpu_track_user(cpu);
+	if (IS_ENABLED(CONFIG_CONTEXT_TRACKING_USER_FORCE)) {
+		for_each_possible_cpu(cpu)
+			ct_cpu_track_user(cpu);
+	}
+
+	if (IS_ENABLED(CONFIG_VIRT_CPU_ACCOUNTING_GEN_FORCE))
+		static_branch_inc(&context_tracking_key);
 }
 #endif
 
-- 
2.40.1


