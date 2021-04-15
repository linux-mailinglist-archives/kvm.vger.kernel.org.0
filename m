Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70F2C361560
	for <lists+kvm@lfdr.de>; Fri, 16 Apr 2021 00:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237521AbhDOWWD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 18:22:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237081AbhDOWVx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Apr 2021 18:21:53 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FDDFC061756
        for <kvm@vger.kernel.org>; Thu, 15 Apr 2021 15:21:30 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id c4so3972755ybp.6
        for <kvm@vger.kernel.org>; Thu, 15 Apr 2021 15:21:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=+Q7N2cYAdSmHRUValmwElnJxz6XY8f0FCfRpSDgKNLE=;
        b=eKlmba/fklhyQO8ifozDbg41fKwUqk0wTnP7HmwHaFZzjpnne81CqI7rWXtb0p2jwi
         ql36e6v8p+NondHs3HGfguWrWObcA/hD6fjQwYn8ZAxfo1hZsfBf9BKnKuCHLpse16sz
         Q4oyko9ZUBY1CLMZscwAYlzHF/LOKGQapa1rNireRLUpK653l3cPbr8U4HP6U3ne62Mm
         hj82i08I88bJ7c3p2+IvFpL5fEqVNw9ya34NY2XwdBc7vz4Fiu0K0c2LXJ5dDHZCFCup
         3w6g3ejgsaKCvyEuvKmJFk05p2DQBNEQkK3GPdT/+gGkrkuOxNVRksT8I8CVkp2Qc8Hb
         qRZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=+Q7N2cYAdSmHRUValmwElnJxz6XY8f0FCfRpSDgKNLE=;
        b=roPlqnJlVMQEugRHQZmF92ciJ9xOpKOfOxxI5uqqtLvQ3y3On+SCGHqZyKLhhgVa9W
         2VORccOq26l8M5gvO1bX/2Ct/nU2M7HklYPm/5fKPy6HDGFxkfh3QKgJN/Is5Gv5aLzn
         C3pLapeOMCWu3LdlDTrZVoyyqlGx+hqe6fqzCb1er7g5awTkOiKIagSxaHFt1kBu0INN
         oIsyXW6iG0sRwBsQYqd81Ja2OsGs8Oxj3GkvLxjVPSmX1wGBySF3RE/zXaRVPwe/vi1t
         RVP3VWUxq1ku6y6fsHeRbjUPGqZu6+8r0jDpcqaicUOb05M/2us+mGy/JvNnuIDJ3Kj9
         JTGA==
X-Gm-Message-State: AOAM532QkSThHJaqi2tJEX//XK6RwFguiMpVwE1/ufHRHeSxa6ocRBro
        wRFVqMJtDK1NwSCKqn3lNNQXL571q0Y=
X-Google-Smtp-Source: ABdhPJwdfxfknW8XueOKXwvg9xz3GccSdgvEBXBAfRtjv22Xy2oZZAR+QwtxE1rJgrN0vgqKUuB5WFcHiC4=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:6c93:ada0:6bbf:e7db])
 (user=seanjc job=sendgmr) by 2002:a25:1905:: with SMTP id 5mr7510706ybz.302.1618525289526;
 Thu, 15 Apr 2021 15:21:29 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 15 Apr 2021 15:21:04 -0700
In-Reply-To: <20210415222106.1643837-1-seanjc@google.com>
Message-Id: <20210415222106.1643837-8-seanjc@google.com>
Mime-Version: 1.0
References: <20210415222106.1643837-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.368.gbe11c130af-goog
Subject: [PATCH v3 7/9] context_tracking: KVM: Move guest enter/exit wrappers
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
        Christian Borntraeger <borntraeger@de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the guest enter/exit wrappers to kvm_host.h so that KVM can manage
its context tracking vs. vtime accounting without bleeding too many KVM
details into the context tracking code.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/context_tracking.h | 45 --------------------------------
 include/linux/kvm_host.h         | 45 ++++++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+), 45 deletions(-)

diff --git a/include/linux/context_tracking.h b/include/linux/context_tracking.h
index e172a547b2d0..d4dc9c4d79aa 100644
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
-	if (!context_tracking_guest_enter_irqoff()) {
-		instrumentation_begin();
-		rcu_virt_note_context_switch(smp_processor_id());
-		instrumentation_end();
-	}
-}
-
-static __always_inline void guest_exit_irqoff(void)
-{
-	context_tracking_guest_exit_irqoff();
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
index 3b06d12ec37e..444d5f0225cb 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -332,6 +332,51 @@ struct kvm_vcpu {
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
+	if (!context_tracking_guest_enter_irqoff()) {
+		instrumentation_begin();
+		rcu_virt_note_context_switch(smp_processor_id());
+		instrumentation_end();
+	}
+}
+
+static __always_inline void guest_exit_irqoff(void)
+{
+	context_tracking_guest_exit_irqoff();
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
2.31.1.368.gbe11c130af-goog

