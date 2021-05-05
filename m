Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBBA6373319
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 02:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231652AbhEEA27 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 20:28:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231527AbhEEA24 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 May 2021 20:28:56 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85B00C061344
        for <kvm@vger.kernel.org>; Tue,  4 May 2021 17:27:59 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id h12-20020a0cf44c0000b02901c0e9c3e1d0so492111qvm.4
        for <kvm@vger.kernel.org>; Tue, 04 May 2021 17:27:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=mmTWozcWBi2FK+Q6OuZX/h80Hy/DwHBNP8NYlW2aHTE=;
        b=MzU5EwW03jdk8Xpe+TbMXoV1533AYBgiSYQLBdBhlT5LsKkddFKG2zpsv93CYTC6gr
         ArM42tV2t27zKHe6mV7SRH3Xb+KXiyrAhPjy/iQZTY4KhJH4k3+43ZoW8RY/7T0AKdHL
         XvmppOO8j4s+Ttx4OUFkQjGzXNCcAblC3XLrBLnBhY7UV5Sa9nhARs1voFWtDKOxc+pI
         I6YFXQrcV7nDiniYxJr5VmNThibJxMPk94xkIr80XS7Jk/+kEd/3G4M6J8LPHfj5MUfo
         Z3HC3+JFMXKBLWQs0Ys0z1Rv4I7bSY6UlOvlg7XEl9mkW/GDlUz+zNpmWKgM30+YtsAq
         tsGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=mmTWozcWBi2FK+Q6OuZX/h80Hy/DwHBNP8NYlW2aHTE=;
        b=iMEPormhf+WADriMGchqbwegoXazwce2+BCvxKlFRSUhe5Llol+/zGwbZEzJMZAvZz
         D5ZENTrPyCPK9gF3QqJLrpi+fuC6Qy2Nl2NrARcQrMC1g/zQeVlfEICig4nZ6KXC6TSv
         wOMbNBwKsefnFmVqY1C40t4/4lyZ+PCY1Ct27omU8Sv5tx6n0kW4/92DI1kfSLYduTnh
         L4sgiDU82ITqPJOqy+qDieshXlqVEz+/foCMtkxPx00Gt27pd/41EBlGqqMV6vLx4672
         Jkhj5V7xwtHVRW+3CKtrOaV3iNNmyWU9hrYlWzhgnKGdyHyJ3i0iEEUM64B7b26EyZR/
         FmAg==
X-Gm-Message-State: AOAM531iNhID4fObhXA0Zhvlwt46QGeL6dGtD6mBMR1VGSDxtGmGJ2bB
        +Q+40dr1mLB9ORtL9IQAb5fmhO8EFx0=
X-Google-Smtp-Source: ABdhPJxKrxVBSOcirvr5DelW0XcVIiPVciCWyl0uTeKsbX0YtRdhdp3eAjnPA0x+Q6N30GHS9biz1KdyuR8=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:df57:48cb:ea33:a156])
 (user=seanjc job=sendgmr) by 2002:a0c:bd96:: with SMTP id n22mr28039059qvg.44.1620174478767;
 Tue, 04 May 2021 17:27:58 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  4 May 2021 17:27:33 -0700
In-Reply-To: <20210505002735.1684165-1-seanjc@google.com>
Message-Id: <20210505002735.1684165-7-seanjc@google.com>
Mime-Version: 1.0
References: <20210505002735.1684165-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.527.g47e6f16901-goog
Subject: [PATCH v4 6/8] context_tracking: Consolidate guest enter/exit wrappers
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

Consolidate the guest enter/exit wrappers, providing and tweaking stubs
as needed.  This will allow moving the wrappers under KVM without having
to bleed #ifdefs into the soon-to-be KVM code.

No functional change intended.

Cc: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/context_tracking.h | 65 ++++++++++++--------------------
 1 file changed, 24 insertions(+), 41 deletions(-)

diff --git a/include/linux/context_tracking.h b/include/linux/context_tracking.h
index 56c648bdbde8..aa58c2ac67ca 100644
--- a/include/linux/context_tracking.h
+++ b/include/linux/context_tracking.h
@@ -71,6 +71,19 @@ static inline void exception_exit(enum ctx_state prev_ctx)
 	}
 }
 
+static __always_inline bool context_tracking_guest_enter(void)
+{
+	if (context_tracking_enabled())
+		__context_tracking_enter(CONTEXT_GUEST);
+
+	return context_tracking_enabled_this_cpu();
+}
+
+static __always_inline void context_tracking_guest_exit(void)
+{
+	if (context_tracking_enabled())
+		__context_tracking_exit(CONTEXT_GUEST);
+}
 
 /**
  * ct_state() - return the current context tracking state if known
@@ -92,6 +105,9 @@ static inline void user_exit_irqoff(void) { }
 static inline enum ctx_state exception_enter(void) { return 0; }
 static inline void exception_exit(enum ctx_state prev_ctx) { }
 static inline enum ctx_state ct_state(void) { return CONTEXT_DISABLED; }
+static inline bool context_tracking_guest_enter(void) { return false; }
+static inline void context_tracking_guest_exit(void) { }
+
 #endif /* !CONFIG_CONTEXT_TRACKING */
 
 #define CT_WARN_ON(cond) WARN_ON(context_tracking_enabled() && (cond))
@@ -102,74 +118,41 @@ extern void context_tracking_init(void);
 static inline void context_tracking_init(void) { }
 #endif /* CONFIG_CONTEXT_TRACKING_FORCE */
 
-
-#ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
 /* must be called with irqs disabled */
 static __always_inline void guest_enter_irqoff(void)
 {
+	/*
+	 * This is running in ioctl context so its safe to assume that it's the
+	 * stime pending cputime to flush.
+	 */
 	instrumentation_begin();
-	if (vtime_accounting_enabled_this_cpu())
-		vtime_guest_enter(current);
-	else
-		current->flags |= PF_VCPU;
+	vtime_account_guest_enter();
 	instrumentation_end();
 
-	if (context_tracking_enabled())
-		__context_tracking_enter(CONTEXT_GUEST);
-
-	/* KVM does not hold any references to rcu protected data when it
+	/*
+	 * KVM does not hold any references to rcu protected data when it
 	 * switches CPU into a guest mode. In fact switching to a guest mode
 	 * is very similar to exiting to userspace from rcu point of view. In
 	 * addition CPU may stay in a guest mode for quite a long time (up to
 	 * one time slice). Lets treat guest mode as quiescent state, just like
 	 * we do with user-mode execution.
 	 */
-	if (!context_tracking_enabled_this_cpu()) {
+	if (!context_tracking_guest_enter()) {
 		instrumentation_begin();
 		rcu_virt_note_context_switch(smp_processor_id());
 		instrumentation_end();
 	}
 }
 
-static __always_inline void context_tracking_guest_exit(void)
-{
-	if (context_tracking_enabled())
-		__context_tracking_exit(CONTEXT_GUEST);
-}
-
 static __always_inline void guest_exit_irqoff(void)
 {
 	context_tracking_guest_exit();
 
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
-static __always_inline void context_tracking_guest_exit(void) { }
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
2.31.1.527.g47e6f16901-goog

