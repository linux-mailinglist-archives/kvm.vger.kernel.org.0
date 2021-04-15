Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 808C436155D
	for <lists+kvm@lfdr.de>; Fri, 16 Apr 2021 00:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237429AbhDOWWA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 18:22:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237344AbhDOWVx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Apr 2021 18:21:53 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A80FFC06138C
        for <kvm@vger.kernel.org>; Thu, 15 Apr 2021 15:21:25 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id c129so2502201qkd.6
        for <kvm@vger.kernel.org>; Thu, 15 Apr 2021 15:21:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=NoxzXKy25RgDTK+Npf4Da6Ion6Bw41f/CgEilQohoV8=;
        b=ll1uAXpdlaV5cnuGtI1njjjBfpvjpK1FIrl1mcXZ1H8XGuPHtg54vXM+qgJMX8P1Aj
         jwUrwlz8ahLHRGKNCVY7XjKoSsRrIw6QGWlawj3LwAxzApEwedpflNktBtFSkE1JSQH3
         AzrtTK51T6VDg6d3DHQY8PvFUt83f+AgHKkgau8a4oceLdqJrVyCo5CyLaRhPVcr0l/2
         ebF/GiwocYNSo2EIVlzcTogFFS1Dh52D2z6JE80JdHvBvO0T+ysc/jypfzdCePJ1Jc9s
         MWsXLmJ0oXSrZazyF2M4XEDdjxSqMlDXVjUvZ6U602pCgB5jygCa8BoI1q4FcDKYU/Bp
         +RoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=NoxzXKy25RgDTK+Npf4Da6Ion6Bw41f/CgEilQohoV8=;
        b=d9yiZrqlH3UyndPkS5lRnr6ExS3eMeFnIF5pK2XSYvRl2UeWX3A3ZrmKeKqa3cQtuZ
         jreTfgVFLotWQDZJ2+P75FyAxpgo1lkCYkR37sNwdcFCbBZVXexCJrprZy5CItulv9Yp
         Ct8uGxcsa8E1hpBDAmHe6hgI6gfPyzGk0ecVUY54ytPMxulDjSkrRzLzCyIqUeIOngtL
         oo9D5YlNIwNCxDxCyqK6I6a5Ls/BWV5QCPQys7bwKC4N8sUVARySRJRzlK08NbY7E28h
         5MnrnXAMe5X7G2stNfLIc8xpIYtRw/tmEVgFjKhZv66Yg7wWWwEBcxQWvsSFkz0PbPSQ
         8VwQ==
X-Gm-Message-State: AOAM533P7Zie2DMAV5GYd0bJMvGdfdu0+CKi1myfctSyUF+/aVFSZ2nK
        EKD2EDeRfM0L/G9FvAbkokJetcgKMKY=
X-Google-Smtp-Source: ABdhPJyvJhqvaVHDZY4RvEdltK5JFGbOu/AGcbMBQJyXWeAzdbLMT9fvmebhPqJ2/ofqK6F2n8nBxpCaMN0=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:6c93:ada0:6bbf:e7db])
 (user=seanjc job=sendgmr) by 2002:a05:6214:176a:: with SMTP id
 et10mr5598011qvb.23.1618525284837; Thu, 15 Apr 2021 15:21:24 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 15 Apr 2021 15:21:02 -0700
In-Reply-To: <20210415222106.1643837-1-seanjc@google.com>
Message-Id: <20210415222106.1643837-6-seanjc@google.com>
Mime-Version: 1.0
References: <20210415222106.1643837-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.368.gbe11c130af-goog
Subject: [PATCH v3 5/9] sched/vtime: Move guest enter/exit vtime accounting to vtime.h
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Christian Borntraeger <borntraeger@de.ibm.com>
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
index 7cf03a8e5708..1c05035396ad 100644
--- a/include/linux/context_tracking.h
+++ b/include/linux/context_tracking.h
@@ -137,14 +137,6 @@ static __always_inline void context_tracking_guest_exit_irqoff(void)
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
 	context_tracking_guest_exit_irqoff();
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
 
 static __always_inline void context_tracking_guest_exit_irqoff(void) { }
 
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
2.31.1.368.gbe11c130af-goog

