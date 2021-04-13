Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96F2535E663
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 20:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347780AbhDMSaK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 14:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347772AbhDMSaH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Apr 2021 14:30:07 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4B30C061574
        for <kvm@vger.kernel.org>; Tue, 13 Apr 2021 11:29:47 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id w9so17226821ybw.7
        for <kvm@vger.kernel.org>; Tue, 13 Apr 2021 11:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=lh12whvdVlWojKFGWoJVnOsvOAGi35z7h6pCvooT88w=;
        b=knvgUSepx0V9t4J0QTZdB70Jcq5D9d1SZitbQ2kN0EAg6qWs/WLC2lpZ42DkPGYslT
         MY8Gti4dV2x6eJMIdHVadk+quFUQnmAoAruxfsp6Bgde7qCfuEPoWFDqfaDZupsRBu72
         lQwX1NoDBW/+mXjIlULknL1Jj5SJJnQ9dwUUgWlH2Jqyr66osR27ecHkzGlas2lCbfWA
         r12b8l7uRzOu1c5b+NYB0x+sp0/lKfwlK5BW3pqftCtAjrh2q3wcdZ19ByV970ILfVos
         4ByrzSL+Ma1wXTwdjChN498/4O9XihMyNTc00i6Ov8Q1b3nszJEkGwXzP0uGHgm3gAgQ
         34cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=lh12whvdVlWojKFGWoJVnOsvOAGi35z7h6pCvooT88w=;
        b=rsdluXts/jU7iRxNjlrfsMj12D52DpSQFYk4snOiSfZJ/vXdyfO3MrYfYhopb+U2f9
         rND9riwsrBuVIJSInkYE+M5nVrueApxlL3H9qveY2gu/W4ibwiMExGjSqfHl2Kj1YvB/
         4aFp3xrogh85nyLZmiTEESgUOcdtFHSz/Tt54MQQtfaYXt3zcoUvVbUFMUtSrd6KifGI
         AWyx0WgbkQFH516psZHnSp4bA608puFPkRayHa3NA7plzp2R/THHpAvQV6DO//R5d73l
         h3WWRQhVGm0ZI3G5v2OqPugjfwtfcgFYcW0suBlmvYiVD/E2sLD8/6vwJR+sWxtwnqXR
         qR8g==
X-Gm-Message-State: AOAM533Nj2MFuNbjFGbi3A9M9THH2vcaQ8aZn7gtG/+uO1ikcf9CpnBD
        NIHEnbEtQ7HkmQS7MJbWdyYwktzxDgE=
X-Google-Smtp-Source: ABdhPJwVIzcNRZPsp7++1aMbdNm5bALHvjb8xd9BRghvIDyt/tLXtadRk5JUroV90kUJruVeoh96AZLWekY=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:f031:9c1c:56c7:c3bf])
 (user=seanjc job=sendgmr) by 2002:a25:7085:: with SMTP id l127mr3272390ybc.293.1618338587108;
 Tue, 13 Apr 2021 11:29:47 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 13 Apr 2021 11:29:29 -0700
In-Reply-To: <20210413182933.1046389-1-seanjc@google.com>
Message-Id: <20210413182933.1046389-4-seanjc@google.com>
Mime-Version: 1.0
References: <20210413182933.1046389-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.295.g9ea45b61b8-goog
Subject: [RFC PATCH 3/7] context_tracking: Consolidate guest enter/exit wrappers
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

Consolidate the guest enter/exit wrappers by providing stubs for the
context tracking helpers as necessary.  This will allow moving the
wrappers under KVM without having to bleed too many #ifdefs into the
soon-to-be KVM code.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/context_tracking.h | 65 ++++++++++++++------------------
 1 file changed, 29 insertions(+), 36 deletions(-)

diff --git a/include/linux/context_tracking.h b/include/linux/context_tracking.h
index 89a1a5ccb2ab..ded56aed539a 100644
--- a/include/linux/context_tracking.h
+++ b/include/linux/context_tracking.h
@@ -76,18 +76,7 @@ static __always_inline void context_tracking_guest_enter_irqoff(void)
 	if (context_tracking_enabled())
 		__context_tracking_enter(CONTEXT_GUEST);
 
-	/* KVM does not hold any references to rcu protected data when it
-	 * switches CPU into a guest mode. In fact switching to a guest mode
-	 * is very similar to exiting to userspace from rcu point of view. In
-	 * addition CPU may stay in a guest mode for quite a long time (up to
-	 * one time slice). Lets treat guest mode as quiescent state, just like
-	 * we do with user-mode execution.
-	 */
-	if (!context_tracking_enabled_this_cpu()) {
-		instrumentation_begin();
-		rcu_virt_note_context_switch(smp_processor_id());
-		instrumentation_end();
-	}
+	return context_tracking_enabled_this_cpu();
 }
 
 static __always_inline void context_tracking_guest_exit_irqoff(void)
@@ -116,6 +105,17 @@ static inline void user_exit_irqoff(void) { }
 static inline enum ctx_state exception_enter(void) { return 0; }
 static inline void exception_exit(enum ctx_state prev_ctx) { }
 static inline enum ctx_state ct_state(void) { return CONTEXT_DISABLED; }
+
+static __always_inline bool context_tracking_guest_enter_irqoff(void)
+{
+	return false;
+}
+
+static __always_inline void context_tracking_guest_exit_irqoff(void)
+{
+
+}
+
 #endif /* !CONFIG_CONTEXT_TRACKING */
 
 #define CT_WARN_ON(cond) WARN_ON(context_tracking_enabled() && (cond))
@@ -126,48 +126,41 @@ extern void context_tracking_init(void);
 static inline void context_tracking_init(void) { }
 #endif /* CONFIG_CONTEXT_TRACKING_FORCE */
 
-#ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
 /* must be called with irqs disabled */
 static __always_inline void guest_enter_irqoff(void)
 {
+	/*
+	 * This is running in ioctl context so its safe to assume that it's the
+	 * stime pending cputime to flush.
+	 */
 	instrumentation_begin();
 	vtime_account_guest_enter();
 	instrumentation_end();
 
-	context_tracking_guest_enter_irqoff();
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
 }
 
 static __always_inline void guest_exit_irqoff(void)
 {
 	context_tracking_guest_exit_irqoff();
 
-	instrumentation_begin();
-	vtime_account_guest_exit();
-	instrumentation_end();
-}
-
-#else
-static __always_inline void guest_enter_irqoff(void)
-{
-	/*
-	 * This is running in ioctl context so its safe
-	 * to assume that it's the stime pending cputime
-	 * to flush.
-	 */
-	instrumentation_begin();
-	vtime_account_guest_enter();
-	rcu_virt_note_context_switch(smp_processor_id());
-	instrumentation_end();
-}
-
-static __always_inline void guest_exit_irqoff(void)
-{
 	instrumentation_begin();
 	/* Flush the guest cputime we spent on the guest */
 	vtime_account_guest_exit();
 	instrumentation_end();
 }
-#endif /* CONFIG_VIRT_CPU_ACCOUNTING_GEN */
 
 static inline void guest_exit(void)
 {
-- 
2.31.1.295.g9ea45b61b8-goog

