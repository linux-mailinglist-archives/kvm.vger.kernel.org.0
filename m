Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC5335E660
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 20:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347764AbhDMSaF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 14:30:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347757AbhDMSaD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Apr 2021 14:30:03 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67938C06175F
        for <kvm@vger.kernel.org>; Tue, 13 Apr 2021 11:29:43 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id v2so14919059ybc.17
        for <kvm@vger.kernel.org>; Tue, 13 Apr 2021 11:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=DBgKpsy5j/P3hgAEc9fw7Y1G0+qqP32d1bF863cdlm4=;
        b=TMO4lZk/DQbX58V5PUc5wkHjNyjUGqKC+eUZ1OM7WF9rm8l+FfiCAEkg3MCT9Zb6D0
         LeRqBSimMGn7bZpyvLInauMaoq8e1Y+aT9xC9RAGn4INHwTzqrhLmO9ddRJ2SrUku42I
         gqKIBM7ycs/kOaMy9YRNA3fM/OZkGENEIl/vUManqirXHGPWtcDqCQOdO2DDxFC3wxpW
         5unGle02ljfxlxLq4PmG4kaYsWUUHGf41jnlz3dNiA4mDb7M/9siWZ4vHWpNraCEMqZG
         G3XJT646bH/U7BhLzNKJleVm9lm54fCaw4LQmaRd7ntZd9K+k7lmd+QwSjGTCxv+P9NS
         BWWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=DBgKpsy5j/P3hgAEc9fw7Y1G0+qqP32d1bF863cdlm4=;
        b=WkS1tFmacZIhaJQY/bvoYqPciiseup/SCNgpflkHUr+30ozKZIr1v2N8I9foJQdtaz
         iOa+4NHoqzXvDkuw4ovfqwHyIkbuMCkOf/e3DYuVaxeI9fnWr5BQZ4JYfIIOzrDwX6TV
         o78RT6epdqf0wWfuzqHf3/IBZlPJq5o5FkSAMgxugzc6w82TKiWzE1qUy+1j8s6tHrNJ
         UHTqgJpkPD3fjNGlBVQ25Za9+PiDtp+35C/N+y69JP3iZOBuRA0OPmqyYsLFVQXsBkOL
         DeGnlGbA7PS/ybk3gYca6yVnS/WbGPHrsiyvshfv8U4dJQb4rqUV8ygEGYDMFOtssfXt
         KYJw==
X-Gm-Message-State: AOAM530baLja9CS5xuuMqfBR3Q3A2Fa0gvJ7+DpsMrWQUFGab9xEUb5c
        LQ/ViQt/J5CIR279u5ZfJ6akBRVu8S8=
X-Google-Smtp-Source: ABdhPJxyESESndmX5ChjYM7X/7wj39TKAIr9yH8AoLODme0G1B9J1nf+VUlLvnk+RaSnnO2UKE3J/uXgd9I=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:f031:9c1c:56c7:c3bf])
 (user=seanjc job=sendgmr) by 2002:a25:ce81:: with SMTP id x123mr17691277ybe.283.1618338582701;
 Tue, 13 Apr 2021 11:29:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 13 Apr 2021 11:29:27 -0700
In-Reply-To: <20210413182933.1046389-1-seanjc@google.com>
Message-Id: <20210413182933.1046389-2-seanjc@google.com>
Mime-Version: 1.0
References: <20210413182933.1046389-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.295.g9ea45b61b8-goog
Subject: [RFC PATCH 1/7] sched/vtime: Move guest enter/exit vtime accounting
 to separate helpers
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Michael Tokarev <mjt@tls.msk.ru>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Provide separate helpers for guest enter/exit vtime accounting instead of
open coding the logic within the context tracking code.  This will allow
KVM x86 to handle vtime accounting slightly differently when using tick-
based accounting.

Opportunstically delete the vtime_account_kernel() stub now that all
callers are wrapped with CONFIG_VIRT_CPU_ACCOUNTING_NATIVE=y.

No functional change intended.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/context_tracking.h | 17 +++---------
 include/linux/vtime.h            | 45 +++++++++++++++++++++++++++++---
 2 files changed, 45 insertions(+), 17 deletions(-)

diff --git a/include/linux/context_tracking.h b/include/linux/context_tracking.h
index bceb06498521..58f9a7251d3b 100644
--- a/include/linux/context_tracking.h
+++ b/include/linux/context_tracking.h
@@ -102,16 +102,12 @@ extern void context_tracking_init(void);
 static inline void context_tracking_init(void) { }
 #endif /* CONFIG_CONTEXT_TRACKING_FORCE */
 
-
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
 /* must be called with irqs disabled */
 static __always_inline void guest_enter_irqoff(void)
 {
 	instrumentation_begin();
-	if (vtime_accounting_enabled_this_cpu())
-		vtime_guest_enter(current);
-	else
-		current->flags |= PF_VCPU;
+	vtime_account_guest_enter();
 	instrumentation_end();
 
 	if (context_tracking_enabled())
@@ -137,10 +133,7 @@ static __always_inline void guest_exit_irqoff(void)
 		__context_tracking_exit(CONTEXT_GUEST);
 
 	instrumentation_begin();
-	if (vtime_accounting_enabled_this_cpu())
-		vtime_guest_exit(current);
-	else
-		current->flags &= ~PF_VCPU;
+	vtime_account_guest_exit();
 	instrumentation_end();
 }
 
@@ -153,8 +146,7 @@ static __always_inline void guest_enter_irqoff(void)
 	 * to flush.
 	 */
 	instrumentation_begin();
-	vtime_account_kernel(current);
-	current->flags |= PF_VCPU;
+	vtime_account_guest_enter();
 	rcu_virt_note_context_switch(smp_processor_id());
 	instrumentation_end();
 }
@@ -163,8 +155,7 @@ static __always_inline void guest_exit_irqoff(void)
 {
 	instrumentation_begin();
 	/* Flush the guest cputime we spent on the guest */
-	vtime_account_kernel(current);
-	current->flags &= ~PF_VCPU;
+	vtime_account_guest_exit();
 	instrumentation_end();
 }
 #endif /* CONFIG_VIRT_CPU_ACCOUNTING_GEN */
diff --git a/include/linux/vtime.h b/include/linux/vtime.h
index 041d6524d144..f30b472a2201 100644
--- a/include/linux/vtime.h
+++ b/include/linux/vtime.h
@@ -3,6 +3,8 @@
 #define _LINUX_KERNEL_VTIME_H
 
 #include <linux/context_tracking_state.h>
+#include <linux/sched.h>
+
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
 #include <asm/vtime.h>
 #endif
@@ -18,6 +20,17 @@ struct task_struct;
 static inline bool vtime_accounting_enabled_this_cpu(void) { return true; }
 extern void vtime_task_switch(struct task_struct *prev);
 
+static __always_inline void vtime_account_guest_enter(void)
+{
+	vtime_account_kernel(current);
+	current->flags |= PF_VCPU;
+}
+
+static __always_inline void vtime_account_guest_exit(void)
+{
+
+}
+
 #elif defined(CONFIG_VIRT_CPU_ACCOUNTING_GEN)
 
 /*
@@ -49,12 +62,38 @@ static inline void vtime_task_switch(struct task_struct *prev)
 		vtime_task_switch_generic(prev);
 }
 
+static __always_inline void vtime_account_guest_enter(void)
+{
+	if (vtime_accounting_enabled_this_cpu())
+		vtime_guest_enter(current);
+	else
+		current->flags |= PF_VCPU;
+}
+
+static __always_inline void vtime_account_guest_exit(void)
+{
+	if (vtime_accounting_enabled_this_cpu())
+		vtime_guest_exit(current);
+	else
+		current->flags &= ~PF_VCPU;
+}
+
+
 #else /* !CONFIG_VIRT_CPU_ACCOUNTING */
 
-static inline bool vtime_accounting_enabled_cpu(int cpu) {return false; }
 static inline bool vtime_accounting_enabled_this_cpu(void) { return false; }
 static inline void vtime_task_switch(struct task_struct *prev) { }
 
+static __always_inline void vtime_account_guest_enter(void)
+{
+	current->flags |= PF_VCPU;
+}
+
+static __always_inline void vtime_account_guest_exit(void)
+{
+	current->flags &= ~PF_VCPU;
+}
+
 #endif
 
 /*
@@ -63,9 +102,7 @@ static inline void vtime_task_switch(struct task_struct *prev) { }
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING
 extern void vtime_account_kernel(struct task_struct *tsk);
 extern void vtime_account_idle(struct task_struct *tsk);
-#else /* !CONFIG_VIRT_CPU_ACCOUNTING */
-static inline void vtime_account_kernel(struct task_struct *tsk) { }
-#endif /* !CONFIG_VIRT_CPU_ACCOUNTING */
+#endif /* CONFIG_VIRT_CPU_ACCOUNTING */
 
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
 extern void arch_vtime_task_switch(struct task_struct *tsk);
-- 
2.31.1.295.g9ea45b61b8-goog

