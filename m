Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9434F35D89C
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 09:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237770AbhDMHQu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 03:16:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237674AbhDMHQm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Apr 2021 03:16:42 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9E68C061574;
        Tue, 13 Apr 2021 00:16:23 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id b17so11287185pgh.7;
        Tue, 13 Apr 2021 00:16:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=lEku+Nldal8skQz83jlsEXJCMsplj1mVF4FlMiQwdgc=;
        b=JAI3885dCP/Tr9ozd+eLPK7/87axdOXIeCxUAKh3AfMd6daXnaKe0cNkVKHEQu11Uz
         hx8MzT7UeMYkR94asHUkkvnMw3Y4OdF+xLQxo/2aZ8HZUrgu0rupDHzyPyQiVViBpV5T
         BuEEPJcrgtiprFqChHyqDFVeVWQwwF2P6naZEjL0842UM3BS2vmkmjh7Sh4rjkMZhLmj
         1XY94DeHhbcF0htJTL/MUdZHxIpsNuYXScrZDXPD5YYDFt7OL1uKLEQuIBB3+kM37cP1
         5Ql6TZZJ836ccOPOMtpat6jKnGZP1VEPnvVoe9D78HHsJY6SbWiF4JPb/oQjiXMAUV5A
         JJ+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=lEku+Nldal8skQz83jlsEXJCMsplj1mVF4FlMiQwdgc=;
        b=HGgldkf5vsThUGHqu9WciJ447EfLaRIJmmQBPJDXu1+wiVR0FKwibyCAI5TqiqYRde
         i3sZUDPaVCSz1/nQ/yQpMQRlTCfP0b7vQUznJ6dc6TQbKKtYW0VCE2RioQvPjzze5DHp
         uUjWnhvcI1yYaIjp+Nz3qBJydj77GqE90MZtDYqnrj0f+IvljVk1peGn5oRfQcgbDNuo
         XhQCsN2L1x5rLjutcoUJLoqdV4qIoipgVk9IwdVM+wgdOG7b24n/2d40Bz1IOCDaJUnG
         Ky8zGoaNtK1lnoatuSictRlLrqqmuhuWlgZvqHiXquGNcTbyurt4WS6KYirMxUfhqcMQ
         Aq/Q==
X-Gm-Message-State: AOAM532dhSjgr0ivn7HHQ/PSCUZQCH1zRvoi583c1lM6LUdUCA8sY6Jz
        Ce+cfo9/zxuJTNx0EDWzRhUTkzKG2uQ=
X-Google-Smtp-Source: ABdhPJzLnFgeSQ05yCVeGcUCwoof/Fv9TY2evQJq2Kz2CsYLpNdbJPgrJJNvWckMMEUM4AGyNrZcOw==
X-Received: by 2002:a65:640b:: with SMTP id a11mr30715660pgv.357.1618298183022;
        Tue, 13 Apr 2021 00:16:23 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id i10sm2031088pjm.1.2021.04.13.00.16.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Apr 2021 00:16:22 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Tokarev <mjt@tls.msk.ru>
Subject: [PATCH v2 1/3] context_tracking: Split guest_enter/exit_irqoff
Date:   Tue, 13 Apr 2021 15:16:07 +0800
Message-Id: <1618298169-3831-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1618298169-3831-1-git-send-email-wanpengli@tencent.com>
References: <1618298169-3831-1-git-send-email-wanpengli@tencent.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Split context_tracking part from guest_enter/exit_irqoff, it will be 
called separately in later patches.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 include/linux/context_tracking.h | 42 +++++++++++++++++++++++++++++-----------
 1 file changed, 31 insertions(+), 11 deletions(-)

diff --git a/include/linux/context_tracking.h b/include/linux/context_tracking.h
index bceb064..d8ad844 100644
--- a/include/linux/context_tracking.h
+++ b/include/linux/context_tracking.h
@@ -104,16 +104,8 @@ static inline void context_tracking_init(void) { }
 
 
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
-/* must be called with irqs disabled */
-static __always_inline void guest_enter_irqoff(void)
+static __always_inline void context_guest_enter_irqoff(void)
 {
-	instrumentation_begin();
-	if (vtime_accounting_enabled_this_cpu())
-		vtime_guest_enter(current);
-	else
-		current->flags |= PF_VCPU;
-	instrumentation_end();
-
 	if (context_tracking_enabled())
 		__context_tracking_enter(CONTEXT_GUEST);
 
@@ -131,10 +123,28 @@ static __always_inline void guest_enter_irqoff(void)
 	}
 }
 
-static __always_inline void guest_exit_irqoff(void)
+/* must be called with irqs disabled */
+static __always_inline void guest_enter_irqoff(void)
+{
+	instrumentation_begin();
+	if (vtime_accounting_enabled_this_cpu())
+		vtime_guest_enter(current);
+	else
+		current->flags |= PF_VCPU;
+	instrumentation_end();
+
+	context_guest_enter_irqoff();
+}
+
+static __always_inline void context_guest_exit_irqoff(void)
 {
 	if (context_tracking_enabled())
 		__context_tracking_exit(CONTEXT_GUEST);
+}
+
+static __always_inline void guest_exit_irqoff(void)
+{
+	context_guest_exit_irqoff();
 
 	instrumentation_begin();
 	if (vtime_accounting_enabled_this_cpu())
@@ -145,6 +155,13 @@ static __always_inline void guest_exit_irqoff(void)
 }
 
 #else
+static __always_inline void context_guest_enter_irqoff(void)
+{
+	instrumentation_begin();
+	rcu_virt_note_context_switch(smp_processor_id());
+	instrumentation_end();
+}
+
 static __always_inline void guest_enter_irqoff(void)
 {
 	/*
@@ -155,10 +172,13 @@ static __always_inline void guest_enter_irqoff(void)
 	instrumentation_begin();
 	vtime_account_kernel(current);
 	current->flags |= PF_VCPU;
-	rcu_virt_note_context_switch(smp_processor_id());
 	instrumentation_end();
+
+	context_guest_enter_irqoff();
 }
 
+static __always_inline void context_guest_exit_irqoff(void) { }
+
 static __always_inline void guest_exit_irqoff(void)
 {
 	instrumentation_begin();
-- 
2.7.4

