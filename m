Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF8635D89F
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 09:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237902AbhDMHQ4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 03:16:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237711AbhDMHQr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Apr 2021 03:16:47 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6496FC06175F;
        Tue, 13 Apr 2021 00:16:26 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id y2so7717480plg.5;
        Tue, 13 Apr 2021 00:16:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=7Jftw9d1UNN2cAlTTeBC6cyl7AFTXXsjQPeVpHE1tC4=;
        b=LJWiE4dGQiKGJ5R43HEmLDipvwSYLViFRDYpFXrikdEcECXXNq6drU06/7utuzaK4b
         SUcxn4YyI1+N8Zg6EqIm2le6XAyXoWwDwwRmjPkQxUJnf95Noyfe1Gvp5RXqMlLfa26G
         epIDwSSKUET1XbTOt9BHCxQCKzsCCEDt0sG4Xy99bxRLs0jUm2JPvyoHYpcBBso/xXnl
         1JDVyBHIVskqXmKIs5kXVq9VkJ/Qw66siCpicrEmRrEmQLL43EOkbwD4wZLvRmj4fL+s
         UMqTMHVymdRbdkAa8HVjlhHobFxE/JWQP2oN6s79hUvA23zeqleOkcV4epOaZBEhrIhl
         bzQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=7Jftw9d1UNN2cAlTTeBC6cyl7AFTXXsjQPeVpHE1tC4=;
        b=Tf7XP4y2ii8ynpph/DqWZWenGytc+pBjm1QM8bpfFrkS2ghbyHLF/y93VZEKgklxls
         MCEeRHumS8dJ7FmyW6mKiAy+DqAvGhFIRXB5or+N9HM+j2VOXliwHBq4vncsLJUuCLyg
         OVQqCUvwqtEiBbcWEG5FPLZlJH0SqrhyxR8ZBrMVA+EPo51YyDzODYl4734sJ0eHwrks
         gm5F5XRXG0Wr376wTnUtMxY+YKAum0HepGByCCE+opEwFIaILiHltSMmVgtARIr+fC3u
         xWJt9brd42VaKyQN7kt79FYZaetZUbLjMMnv7aMccYemNehHsFTpR1KfCVTTA27Pjnmu
         CC1w==
X-Gm-Message-State: AOAM530gh+j+aSFZ+WtZjMv6YS0nuKbM9lz2aCUwCK8BSlRakv2fgijn
        5t0ApsVBtuHCb3qoE4/AdF+yk7/1GCU=
X-Google-Smtp-Source: ABdhPJxfPdubRYlLaWbv+Oa1GiQv+QCzV5oxm8hBz68c8n4g2uhMuVTWhXYEiBUkLt/UYVy4hPE+kQ==
X-Received: by 2002:a17:90a:c81:: with SMTP id v1mr3257153pja.23.1618298185789;
        Tue, 13 Apr 2021 00:16:25 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id i10sm2031088pjm.1.2021.04.13.00.16.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Apr 2021 00:16:25 -0700 (PDT)
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
Subject: [PATCH v2 2/3] context_tracking: Provide separate vtime accounting functions
Date:   Tue, 13 Apr 2021 15:16:08 +0800
Message-Id: <1618298169-3831-3-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1618298169-3831-1-git-send-email-wanpengli@tencent.com>
References: <1618298169-3831-1-git-send-email-wanpengli@tencent.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Provide separate vtime accounting functions, because having proper 
wrappers for that case would be too consistent and less confusing.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 include/linux/context_tracking.h | 50 ++++++++++++++++++++++++++++++----------
 1 file changed, 38 insertions(+), 12 deletions(-)

diff --git a/include/linux/context_tracking.h b/include/linux/context_tracking.h
index d8ad844..491f889 100644
--- a/include/linux/context_tracking.h
+++ b/include/linux/context_tracking.h
@@ -102,6 +102,40 @@ extern void context_tracking_init(void);
 static inline void context_tracking_init(void) { }
 #endif /* CONFIG_CONTEXT_TRACKING_FORCE */
 
+static __always_inline void vtime_account_guest_enter(void)
+{
+	if (IS_ENABLED(CONFIG_VIRT_CPU_ACCOUNTING_GEN)) {
+		if (vtime_accounting_enabled_this_cpu())
+			vtime_guest_enter(current);
+		else
+			current->flags |= PF_VCPU;
+	} else {
+		vtime_account_kernel(current);
+		current->flags |= PF_VCPU;
+	}
+}
+
+static __always_inline void __vtime_account_guest_exit(void)
+{
+	if (IS_ENABLED(CONFIG_VIRT_CPU_ACCOUNTING_GEN)) {
+		if (vtime_accounting_enabled_this_cpu())
+			vtime_guest_exit(current);
+	} else {
+		vtime_account_kernel(current);
+	}
+}
+
+static __always_inline void vtime_account_guest_exit(void)
+{
+	__vtime_account_guest_exit();
+	current->flags &= ~PF_VCPU;
+}
+
+static __always_inline void vcpu_account_guest_exit(void)
+{
+	if (!vtime_accounting_enabled_this_cpu())
+		current->flags &= ~PF_VCPU;
+}
 
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
 static __always_inline void context_guest_enter_irqoff(void)
@@ -127,10 +161,7 @@ static __always_inline void context_guest_enter_irqoff(void)
 static __always_inline void guest_enter_irqoff(void)
 {
 	instrumentation_begin();
-	if (vtime_accounting_enabled_this_cpu())
-		vtime_guest_enter(current);
-	else
-		current->flags |= PF_VCPU;
+	vtime_account_guest_enter();
 	instrumentation_end();
 
 	context_guest_enter_irqoff();
@@ -147,10 +178,7 @@ static __always_inline void guest_exit_irqoff(void)
 	context_guest_exit_irqoff();
 
 	instrumentation_begin();
-	if (vtime_accounting_enabled_this_cpu())
-		vtime_guest_exit(current);
-	else
-		current->flags &= ~PF_VCPU;
+	vtime_account_guest_exit();
 	instrumentation_end();
 }
 
@@ -170,8 +198,7 @@ static __always_inline void guest_enter_irqoff(void)
 	 * to flush.
 	 */
 	instrumentation_begin();
-	vtime_account_kernel(current);
-	current->flags |= PF_VCPU;
+	vtime_account_guest_enter();
 	instrumentation_end();
 
 	context_guest_enter_irqoff();
@@ -183,8 +210,7 @@ static __always_inline void guest_exit_irqoff(void)
 {
 	instrumentation_begin();
 	/* Flush the guest cputime we spent on the guest */
-	vtime_account_kernel(current);
-	current->flags &= ~PF_VCPU;
+	vtime_account_guest_exit();
 	instrumentation_end();
 }
 #endif /* CONFIG_VIRT_CPU_ACCOUNTING_GEN */
-- 
2.7.4

