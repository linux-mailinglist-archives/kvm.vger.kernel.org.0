Return-Path: <kvm+bounces-4423-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B4E081257C
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 03:48:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 83802283227
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 02:48:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E2DA8833;
	Thu, 14 Dec 2023 02:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b="tTwcoFrp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D310E19A
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 18:47:45 -0800 (PST)
Received: by mail-qt1-x830.google.com with SMTP id d75a77b69052e-4258026a9fdso46759801cf.0
        for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 18:47:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bitbyteword.org; s=google; t=1702522064; x=1703126864; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MJ8V9wpZFRMaxTJ2Yr+JKkom97NUFELsE8HKkLVd89U=;
        b=tTwcoFrpm1z648NnqZPTYvJRG8qRAP6HhEhissBvfO3WICzlER+W4Tt/oI7kmMIP9f
         cuwJw6erApazvVuJOsmICilQm5tVsJlbPvoBAQY+jE8fhvJ9EEt+aZap7P6j2KrttjT8
         ajUUve1LCghnI3HfHmKzTePg0y6NqTof15pSkJUrVGJfAwkHMmKPcC0ans+73KGvpcm6
         +vIekWNczLtj8PFttljYj4NeVH0bB9j61SwGzwiZr3MnRn4KSJKHnf/9zLNnMWCea1H6
         W5PDTA315RGU9qFRrhFMJ2R7vZiE4BPt4hvi2DwRLOND3Pwhozz5zAjH0glcKaUO+CQn
         3JpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702522064; x=1703126864;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MJ8V9wpZFRMaxTJ2Yr+JKkom97NUFELsE8HKkLVd89U=;
        b=qZOLXE1J2cdHQFspWg5ttzBc2A/jb+l2wK1qJHMvXWL8wEHsKYL1FL08JOr4pOovol
         kuh1FnZZwVbveiRFJJkVtV+bMw5vw7TR6PIF1YIAgDDYd4TuwD0SxbgwwKMNGNrfNOai
         YKESeNx5795wlQgAyDaSYRbWEpxUueSnJ82jYmZsQMjRfYIfr2blN+fC4WRXBufORv9k
         zxqH3jf1vLsMP4CagXvetq8bCq2Yjqxnqg+kRwC48q6vVziHbkaS1P6XfEZXSjCpcZRm
         rNSUgXxk3AIpCCFzdR1MVmcgV8k8cKWGm2XQCjHBN/aOQVicv11p+/GNKUCQ3ZGe0Imv
         2awQ==
X-Gm-Message-State: AOJu0YwEBHEG5qaUVVGOGCRfDVdL6B6mNqkRbw76MLHog+CLh9Hf1r4h
	NC+ECKHVL8+HvH0In1Um/LzEEA==
X-Google-Smtp-Source: AGHT+IHCsSa54wlj5dnr98DogOBhKgfMGGbDmmsgR6hVaIJ/We5ltJAIKpR8uR1tHmUAsiuMmCDtIg==
X-Received: by 2002:a05:622a:251:b0:418:1088:7d69 with SMTP id c17-20020a05622a025100b0041810887d69mr12636997qtx.18.1702522064725;
        Wed, 13 Dec 2023 18:47:44 -0800 (PST)
Received: from vinp3lin.lan (c-73-143-21-186.hsd1.vt.comcast.net. [73.143.21.186])
        by smtp.gmail.com with ESMTPSA id fh3-20020a05622a588300b00425b356b919sm4240208qtb.55.2023.12.13.18.47.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Dec 2023 18:47:44 -0800 (PST)
From: "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>
To: Ben Segall <bsegall@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Daniel Bristot de Oliveira <bristot@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Mel Gorman <mgorman@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Wanpeng Li <wanpengli@tencent.com>
Cc: "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>,
	Suleiman Souhlal <suleiman@google.com>,
	Masami Hiramatsu <mhiramat@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Joel Fernandes <joel@joelfernandes.org>
Subject: [RFC PATCH 8/8] irq: boost/unboost in irq/nmi entry/exit and softirq
Date: Wed, 13 Dec 2023 21:47:25 -0500
Message-ID: <20231214024727.3503870-9-vineeth@bitbyteword.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231214024727.3503870-1-vineeth@bitbyteword.org>
References: <20231214024727.3503870-1-vineeth@bitbyteword.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The host proactively boosts the VCPU threads during irq/nmi injection.
However, the host is unaware of posted interrupts, and therefore, the
guest should request a boost if it has not already been boosted.

Similarly, guest should request an unboost on irq/nmi/softirq exit if
the vcpu doesn't need the boost any more.

Co-developed-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Signed-off-by: Vineeth Pillai (Google) <vineeth@bitbyteword.org>
---
 kernel/entry/common.c | 30 ++++++++++++++++++++++++++++++
 kernel/softirq.c      | 11 +++++++++++
 2 files changed, 41 insertions(+)

diff --git a/kernel/entry/common.c b/kernel/entry/common.c
index fae56faac0b0..c69912b71725 100644
--- a/kernel/entry/common.c
+++ b/kernel/entry/common.c
@@ -327,6 +327,13 @@ noinstr irqentry_state_t irqentry_enter(struct pt_regs *regs)
 		.exit_rcu = false,
 	};
 
+#ifdef CONFIG_PARAVIRT_SCHED
+	instrumentation_begin();
+	if (pv_sched_enabled())
+		pv_sched_boost_vcpu_lazy();
+	instrumentation_end();
+#endif
+
 	if (user_mode(regs)) {
 		irqentry_enter_from_user_mode(regs);
 		return ret;
@@ -452,6 +459,18 @@ noinstr void irqentry_exit(struct pt_regs *regs, irqentry_state_t state)
 		if (state.exit_rcu)
 			ct_irq_exit();
 	}
+
+#ifdef CONFIG_PARAVIRT_SCHED
+	instrumentation_begin();
+	/*
+	 * On irq exit, request a deboost from hypervisor if no softirq pending
+	 * and current task is not RT and !need_resched.
+	 */
+	if (pv_sched_enabled() && !local_softirq_pending() &&
+			!need_resched() && !task_is_realtime(current))
+		pv_sched_unboost_vcpu();
+	instrumentation_end();
+#endif
 }
 
 irqentry_state_t noinstr irqentry_nmi_enter(struct pt_regs *regs)
@@ -469,6 +488,11 @@ irqentry_state_t noinstr irqentry_nmi_enter(struct pt_regs *regs)
 	kmsan_unpoison_entry_regs(regs);
 	trace_hardirqs_off_finish();
 	ftrace_nmi_enter();
+
+#ifdef CONFIG_PARAVIRT_SCHED
+	if (pv_sched_enabled())
+		pv_sched_boost_vcpu_lazy();
+#endif
 	instrumentation_end();
 
 	return irq_state;
@@ -482,6 +506,12 @@ void noinstr irqentry_nmi_exit(struct pt_regs *regs, irqentry_state_t irq_state)
 		trace_hardirqs_on_prepare();
 		lockdep_hardirqs_on_prepare();
 	}
+
+#ifdef CONFIG_PARAVIRT_SCHED
+	if (pv_sched_enabled() && !in_hardirq() && !local_softirq_pending() &&
+			!need_resched() && !task_is_realtime(current))
+		pv_sched_unboost_vcpu();
+#endif
 	instrumentation_end();
 
 	ct_nmi_exit();
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 807b34ccd797..90a127615e16 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -530,6 +530,11 @@ asmlinkage __visible void __softirq_entry __do_softirq(void)
 	in_hardirq = lockdep_softirq_start();
 	account_softirq_enter(current);
 
+#ifdef CONFIG_PARAVIRT_SCHED
+	if (pv_sched_enabled())
+		pv_sched_boost_vcpu_lazy();
+#endif
+
 restart:
 	/* Reset the pending bitmask before enabling irqs */
 	set_softirq_pending(0);
@@ -577,6 +582,12 @@ asmlinkage __visible void __softirq_entry __do_softirq(void)
 		wakeup_softirqd();
 	}
 
+#ifdef CONFIG_PARAVIRT_SCHED
+	if (pv_sched_enabled() && !need_resched() &&
+			!task_is_realtime(current))
+		pv_sched_unboost_vcpu();
+#endif
+
 	account_softirq_exit(current);
 	lockdep_softirq_end(in_hardirq);
 	softirq_handle_end();
-- 
2.43.0


