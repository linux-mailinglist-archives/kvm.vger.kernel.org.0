Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC8E235E661
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 20:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347770AbhDMSaH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 14:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347763AbhDMSaF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Apr 2021 14:30:05 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83FFBC06175F
        for <kvm@vger.kernel.org>; Tue, 13 Apr 2021 11:29:45 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id p68so10354843ybg.20
        for <kvm@vger.kernel.org>; Tue, 13 Apr 2021 11:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=3pnXNHyPtgGcg37a0kVWxRztf39QNHtD0Ft3zXb2qAc=;
        b=lhG/UfcHROVd7145tjdD3BwEBuqi+DUF9UbliOiMwye9gVed6mLHJO2wx//Xr/G++W
         5wGxFA6bEExFF6iD59g/Ry0/dLm2bxLqGjt+zvz3jnczKvxYQUhqUJsaAK7ah3PtQz16
         LWK+pzC8efhXYd0kQGJQzTTRNcj8AClyrDM0OGsB25R/8c3/lAAunUecBkozode5ZuT8
         sN6zeNZrE0BllHAwx1VURW5YbckNh8ovpfh9VLvL9EUFuaHHw8v3zv20iHTprVg0oKGl
         h2jjSfSNfEnH10NoWbGbzNqXLZvm8LPMZ9UKaQSB+MTQz0qo6nH1xqgRgZHdgXQk3Lac
         BEcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=3pnXNHyPtgGcg37a0kVWxRztf39QNHtD0Ft3zXb2qAc=;
        b=ndwLyiPgFxj5reqq9aBv/dDJwgH3j7miZcNmlI85bTHkE3EfYT7v7NTQRj7rC8qj2l
         WYAGa5R++5/Wl3fuREqBJfsRM9SZlFXaz5usPTqtB7Rcb+F1FJC5nGDueUK+uNbQiK9s
         m+n9GpGKkrNDMkjMcemCdBWayddY9xviqUX4cSYWB5Ts0xvR6kzsJj54tiNf1SS3B69y
         XcjlWLlBAurIKsW3yMHpNpwvCeRiyeIa/nfuNE/6WNG9HJEbggydmtRlOEtRI1MJnanH
         YTR3zc+ESk4U2s5g/kRv0E53m0K27Zk2hs1q0LABUCEPGK9FhCfD9L3LzykEnAT7706s
         hjvA==
X-Gm-Message-State: AOAM530HsGHpp5kURi2CG6lTCOh+Cd1wWuJxpv4IksYoqkwcwr3TN2ko
        D+zlLWZEkhniflokTQNj8ucN7KiwrN8=
X-Google-Smtp-Source: ABdhPJx7JC3LIVuSvYqMH4v9P52mqXsTq132vjyl53+XXdyUDNA/ptFo3YlhSAEZQyBkRDGL4tjVVk7sGAE=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:f031:9c1c:56c7:c3bf])
 (user=seanjc job=sendgmr) by 2002:a25:dfd0:: with SMTP id w199mr13235033ybg.92.1618338584829;
 Tue, 13 Apr 2021 11:29:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 13 Apr 2021 11:29:28 -0700
In-Reply-To: <20210413182933.1046389-1-seanjc@google.com>
Message-Id: <20210413182933.1046389-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210413182933.1046389-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.295.g9ea45b61b8-goog
Subject: [RFC PATCH 2/7] context_tracking: Move guest enter/exit logic to
 standalone helpers
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

Move guest enter/exit context tracking to standalone helpers, so that the
existing wrappers can be moved under KVM.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/context_tracking.h | 43 +++++++++++++++++++-------------
 1 file changed, 26 insertions(+), 17 deletions(-)

diff --git a/include/linux/context_tracking.h b/include/linux/context_tracking.h
index 58f9a7251d3b..89a1a5ccb2ab 100644
--- a/include/linux/context_tracking.h
+++ b/include/linux/context_tracking.h
@@ -71,6 +71,30 @@ static inline void exception_exit(enum ctx_state prev_ctx)
 	}
 }
 
+static __always_inline void context_tracking_guest_enter_irqoff(void)
+{
+	if (context_tracking_enabled())
+		__context_tracking_enter(CONTEXT_GUEST);
+
+	/* KVM does not hold any references to rcu protected data when it
+	 * switches CPU into a guest mode. In fact switching to a guest mode
+	 * is very similar to exiting to userspace from rcu point of view. In
+	 * addition CPU may stay in a guest mode for quite a long time (up to
+	 * one time slice). Lets treat guest mode as quiescent state, just like
+	 * we do with user-mode execution.
+	 */
+	if (!context_tracking_enabled_this_cpu()) {
+		instrumentation_begin();
+		rcu_virt_note_context_switch(smp_processor_id());
+		instrumentation_end();
+	}
+}
+
+static __always_inline void context_tracking_guest_exit_irqoff(void)
+{
+	if (context_tracking_enabled())
+		__context_tracking_exit(CONTEXT_GUEST);
+}
 
 /**
  * ct_state() - return the current context tracking state if known
@@ -110,27 +134,12 @@ static __always_inline void guest_enter_irqoff(void)
 	vtime_account_guest_enter();
 	instrumentation_end();
 
-	if (context_tracking_enabled())
-		__context_tracking_enter(CONTEXT_GUEST);
-
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
+	context_tracking_guest_enter_irqoff();
 }
 
 static __always_inline void guest_exit_irqoff(void)
 {
-	if (context_tracking_enabled())
-		__context_tracking_exit(CONTEXT_GUEST);
+	context_tracking_guest_exit_irqoff();
 
 	instrumentation_begin();
 	vtime_account_guest_exit();
-- 
2.31.1.295.g9ea45b61b8-goog

