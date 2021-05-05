Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5995D373318
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 02:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbhEEA26 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 20:28:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231469AbhEEA2y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 May 2021 20:28:54 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2146C06138F
        for <kvm@vger.kernel.org>; Tue,  4 May 2021 17:27:56 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id a3-20020a2580430000b02904f7a1a09012so485276ybn.3
        for <kvm@vger.kernel.org>; Tue, 04 May 2021 17:27:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=sMUAW+2oDIJX5Jnf0vr40VExAiGP3BZMmhSDsatQxbM=;
        b=g+axrA7sDvFIFjAwZ8Cb9FUfBNhQc+xgHh4KbfZ1huGgQJ/Jbv0dZhBLpQA1jVsleN
         yndgvoaez8lOUUhZxamtRPHWUkYMY3qzdEjALIGDXD6JM4RMaV3Z/UaqvwQ0BqOBeGPo
         X6ttGtLybbnHV++w0JITVQwMSjxiDPPdZsGH4L8Dg7xAPODA/wgwy7F42FO25oF3gKho
         Ne10Ipe0+qSIMtcFdUOpdZbNz+VJElOcGkRoywT3k7nIjTn6lWv5hd7hDGnErhJ8yoA3
         KF4KRl1rOio9p3beR+n/HIoKMLV+mxMyvqY8qmOJ11qOHs7G5rXdOASXea1/OxirKp+s
         sftA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=sMUAW+2oDIJX5Jnf0vr40VExAiGP3BZMmhSDsatQxbM=;
        b=G22SaB42NoMp8Yq7evuHX4Was1IHIY9WxtP/aXBNxh86RMniGDpfw7CNQ9vDDDPrNX
         2n8wpFU9fgMX8pldASFKVK8ov0PtZdU/aPywm6WUy4Ay4e7FdyaIXyOY6q2Ooc7fqfiW
         XRWdY0513Y4MWt3I0X9qDnK/pktzKMFE+UK53esKnz9OrOaNQeQYTbEyB1VuXbRQkHMa
         BnDqjZhhmGueADqi5OzyRVicyAkGmERKlkjrXFKYNlG+q61PdN2qGuF/YS86NGA702Mj
         YLoh9yvnNDro3aoMU8M/1v+SSqm7aDrXL0S7GPgQl+f0ZcwtsGCsy/uuCX/1X8KxONBj
         iPzg==
X-Gm-Message-State: AOAM533/X89L4cbAkFGFNL8SPbAKERPn+yjr/CBUsKrh99EPfHx/ZWwR
        znA10RAVqkaC3m+vTspimttKnRPkCr4=
X-Google-Smtp-Source: ABdhPJxgdkGZJw5axvxD5GAiyCjdNCsjZTk+gafyFs3RlVUO9U34ZyQliDlcWgMqyeZY0IrBmhxFlH8T444=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:df57:48cb:ea33:a156])
 (user=seanjc job=sendgmr) by 2002:a25:2693:: with SMTP id m141mr38110043ybm.212.1620174476249;
 Tue, 04 May 2021 17:27:56 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  4 May 2021 17:27:32 -0700
In-Reply-To: <20210505002735.1684165-1-seanjc@google.com>
Message-Id: <20210505002735.1684165-6-seanjc@google.com>
Mime-Version: 1.0
References: <20210505002735.1684165-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.527.g47e6f16901-goog
Subject: [PATCH v4 5/8] sched/vtime: Move guest enter/exit vtime accounting to vtime.h
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Frederic Weisbecker <frederic@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Provide separate helpers for guest enter vtime accounting (in addition to
the existing guest exit helpers), and move all vtime accounting helpers
to vtime.h where the existing #ifdef infrastructure can be leveraged to
better delineate the different types of accounting.  This will also allow
future cleanups via deduplication of context tracking code.

Opportunstically delete the vtime_account_kernel() stub now that all
callers are wrapped with CONFIG_VIRT_CPU_ACCOUNTING_NATIVE=y.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/context_tracking.h | 17 +-----------
 include/linux/vtime.h            | 46 +++++++++++++++++++++++++++-----
 2 files changed, 41 insertions(+), 22 deletions(-)

diff --git a/include/linux/context_tracking.h b/include/linux/context_tracking.h
index 4f4556232dcf..56c648bdbde8 100644
--- a/include/linux/context_tracking.h
+++ b/include/linux/context_tracking.h
@@ -137,14 +137,6 @@ static __always_inline void context_tracking_guest_exit(void)
 		__context_tracking_exit(CONTEXT_GUEST);
 }
 
-static __always_inline void vtime_account_guest_exit(void)
-{
-	if (vtime_accounting_enabled_this_cpu())
-		vtime_guest_exit(current);
-	else
-		current->flags &= ~PF_VCPU;
-}
-
 static __always_inline void guest_exit_irqoff(void)
 {
 	context_tracking_guest_exit();
@@ -163,20 +155,13 @@ static __always_inline void guest_enter_irqoff(void)
 	 * to flush.
 	 */
 	instrumentation_begin();
-	vtime_account_kernel(current);
-	current->flags |= PF_VCPU;
+	vtime_account_guest_enter();
 	rcu_virt_note_context_switch(smp_processor_id());
 	instrumentation_end();
 }
 
 static __always_inline void context_tracking_guest_exit(void) { }
 
-static __always_inline void vtime_account_guest_exit(void)
-{
-	vtime_account_kernel(current);
-	current->flags &= ~PF_VCPU;
-}
-
 static __always_inline void guest_exit_irqoff(void)
 {
 	instrumentation_begin();
diff --git a/include/linux/vtime.h b/include/linux/vtime.h
index 6a4317560539..3684487d01e1 100644
--- a/include/linux/vtime.h
+++ b/include/linux/vtime.h
@@ -3,21 +3,18 @@
 #define _LINUX_KERNEL_VTIME_H
 
 #include <linux/context_tracking_state.h>
+#include <linux/sched.h>
+
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
 #include <asm/vtime.h>
 #endif
 
-
-struct task_struct;
-
 /*
  * Common vtime APIs
  */
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING
 extern void vtime_account_kernel(struct task_struct *tsk);
 extern void vtime_account_idle(struct task_struct *tsk);
-#else /* !CONFIG_VIRT_CPU_ACCOUNTING */
-static inline void vtime_account_kernel(struct task_struct *tsk) { }
 #endif /* !CONFIG_VIRT_CPU_ACCOUNTING */
 
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
@@ -55,6 +52,18 @@ static inline void vtime_flush(struct task_struct *tsk) { }
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
+	vtime_account_kernel(current);
+	current->flags &= ~PF_VCPU;
+}
+
 #elif defined(CONFIG_VIRT_CPU_ACCOUNTING_GEN)
 
 /*
@@ -86,12 +95,37 @@ static inline void vtime_task_switch(struct task_struct *prev)
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
 
 
-- 
2.31.1.527.g47e6f16901-goog

