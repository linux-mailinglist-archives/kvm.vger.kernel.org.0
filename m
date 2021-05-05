Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 591C237331C
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 02:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231747AbhEEA3E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 20:29:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231520AbhEEA26 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 May 2021 20:28:58 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A73E7C06174A
        for <kvm@vger.kernel.org>; Tue,  4 May 2021 17:28:01 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id p64-20020a2529430000b02904f838e5bd13so406956ybp.20
        for <kvm@vger.kernel.org>; Tue, 04 May 2021 17:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=0QN4jbC2XDzCTKqJKIwYMySbYznFpDOgKP/XluafWZU=;
        b=Nn5hOoGm2H6xOXcTSFjsep8QNT9Tc5IjJJmH804MxiNQCAgI2DZ3pZvPd4Emefmitr
         Jf9LHMQbGI3U1TKY2yyQlJchNfLBiPU5M6q52rR9MVFGI30qsqJ4+ZBB1NFtjswlTaLb
         rY3jSU50FmWaybg6D6tCz6G/Dzt9KO699Br/uH1GKUpFD6FA7OEVxJs2eMtc+ta0Pqvq
         toHrgPd2xLUmJbziwFCKCijmheBInbJs/MIaw7tbvJoK7WSUaKemR1op1QewfhcDMObV
         JgF/L258QTN/x8R/1KNe3SwrvJQSKOtoWv4XJCnKu+rjHyb+5IvtT7qoQzIhnFsQpUtb
         82Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=0QN4jbC2XDzCTKqJKIwYMySbYznFpDOgKP/XluafWZU=;
        b=V9l9FlnSVFlLwwQ8gnkWqy4wM0MQwqSIHOuCgOPIx6K/QftigG0ROoT8KSO6q932t1
         pCCKenB64HU68Zk7ICFBWV7LQ5RXwhD6G0/7A6olVNrpXVTHgq054zUyX90v15sduvyD
         RpN282wMKGviDJpAo6vwaR+6cAc+8hfS6Yf5cTYO8WczG5Tp4szbH9OFXI9BgGJC0fIp
         9AfBEOyRcDfFLrE8EZhZiSL36JG3TheOI1xZYy2gHgEWS7zqJxUIY/zimmmvoZ7zUR8k
         zu7YZ23TNdVjmTG41qG+j2TsBT0jdRyWM6Nq+xDw7tz0ftQ1MQNTzIheu+bfgCgNTmSM
         EFAg==
X-Gm-Message-State: AOAM530KF04DLcTb+Lbe0Ls/2MDj9FoKgZy2VPd+gVtMIahewvYn15In
        F4siGQbJRHHgO1cmr5dT02Qwwi1woGk=
X-Google-Smtp-Source: ABdhPJz5TfEdlSWflZFAEHRuNF4nGfOsMzGnwFsL/UMOzghY5B0gs8O+/v84yPqognVJyLV9Z+vgSFXjPZ0=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:df57:48cb:ea33:a156])
 (user=seanjc job=sendgmr) by 2002:a25:9982:: with SMTP id p2mr38767733ybo.457.1620174480927;
 Tue, 04 May 2021 17:28:00 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  4 May 2021 17:27:34 -0700
In-Reply-To: <20210505002735.1684165-1-seanjc@google.com>
Message-Id: <20210505002735.1684165-8-seanjc@google.com>
Mime-Version: 1.0
References: <20210505002735.1684165-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.527.g47e6f16901-goog
Subject: [PATCH v4 7/8] context_tracking: KVM: Move guest enter/exit wrappers
 to KVM's domain
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

Move the guest enter/exit wrappers to kvm_host.h so that KVM can manage
its context tracking vs. vtime accounting without bleeding too many KVM
details into the context tracking code.

No functional change intended.

Cc: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/context_tracking.h | 45 --------------------------------
 include/linux/kvm_host.h         | 45 ++++++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+), 45 deletions(-)

diff --git a/include/linux/context_tracking.h b/include/linux/context_tracking.h
index aa58c2ac67ca..4d7fced3a39f 100644
--- a/include/linux/context_tracking.h
+++ b/include/linux/context_tracking.h
@@ -118,49 +118,4 @@ extern void context_tracking_init(void);
 static inline void context_tracking_init(void) { }
 #endif /* CONFIG_CONTEXT_TRACKING_FORCE */
 
-/* must be called with irqs disabled */
-static __always_inline void guest_enter_irqoff(void)
-{
-	/*
-	 * This is running in ioctl context so its safe to assume that it's the
-	 * stime pending cputime to flush.
-	 */
-	instrumentation_begin();
-	vtime_account_guest_enter();
-	instrumentation_end();
-
-	/*
-	 * KVM does not hold any references to rcu protected data when it
-	 * switches CPU into a guest mode. In fact switching to a guest mode
-	 * is very similar to exiting to userspace from rcu point of view. In
-	 * addition CPU may stay in a guest mode for quite a long time (up to
-	 * one time slice). Lets treat guest mode as quiescent state, just like
-	 * we do with user-mode execution.
-	 */
-	if (!context_tracking_guest_enter()) {
-		instrumentation_begin();
-		rcu_virt_note_context_switch(smp_processor_id());
-		instrumentation_end();
-	}
-}
-
-static __always_inline void guest_exit_irqoff(void)
-{
-	context_tracking_guest_exit();
-
-	instrumentation_begin();
-	/* Flush the guest cputime we spent on the guest */
-	vtime_account_guest_exit();
-	instrumentation_end();
-}
-
-static inline void guest_exit(void)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-	guest_exit_irqoff();
-	local_irq_restore(flags);
-}
-
 #endif
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index a9a7bcf6ebee..a6f47ed8b1e6 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -338,6 +338,51 @@ struct kvm_vcpu {
 	struct kvm_dirty_ring dirty_ring;
 };
 
+/* must be called with irqs disabled */
+static __always_inline void guest_enter_irqoff(void)
+{
+	/*
+	 * This is running in ioctl context so its safe to assume that it's the
+	 * stime pending cputime to flush.
+	 */
+	instrumentation_begin();
+	vtime_account_guest_enter();
+	instrumentation_end();
+
+	/*
+	 * KVM does not hold any references to rcu protected data when it
+	 * switches CPU into a guest mode. In fact switching to a guest mode
+	 * is very similar to exiting to userspace from rcu point of view. In
+	 * addition CPU may stay in a guest mode for quite a long time (up to
+	 * one time slice). Lets treat guest mode as quiescent state, just like
+	 * we do with user-mode execution.
+	 */
+	if (!context_tracking_guest_enter()) {
+		instrumentation_begin();
+		rcu_virt_note_context_switch(smp_processor_id());
+		instrumentation_end();
+	}
+}
+
+static __always_inline void guest_exit_irqoff(void)
+{
+	context_tracking_guest_exit();
+
+	instrumentation_begin();
+	/* Flush the guest cputime we spent on the guest */
+	vtime_account_guest_exit();
+	instrumentation_end();
+}
+
+static inline void guest_exit(void)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	guest_exit_irqoff();
+	local_irq_restore(flags);
+}
+
 static inline int kvm_vcpu_exiting_guest_mode(struct kvm_vcpu *vcpu)
 {
 	/*
-- 
2.31.1.527.g47e6f16901-goog

