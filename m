Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2DF46F30C
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 19:26:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243300AbhLISaU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 13:30:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243301AbhLISaT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 13:30:19 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3C23C0617A1
        for <kvm@vger.kernel.org>; Thu,  9 Dec 2021 10:26:45 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id e4-20020a170902b78400b00143c2e300ddso2774043pls.17
        for <kvm@vger.kernel.org>; Thu, 09 Dec 2021 10:26:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=PBmq2z3yMVBERX0BReN+bP805W6PwgtvTZirgUjIQog=;
        b=b7tO+wdcZNCbT/NeJMs4ztrGYjOGy2QujPLAfGwGgJuZAJlY60fSg59Dolh4WEjrRI
         wXkcptLx8lYcCPEN9XtCFB9Ae6oKN9B6WCBUjpnkLcJ2qjDDIIGx1Ae4l+mFipRONtvw
         dqoG7MjLSmmdWlV2gSTNkm8q8U2WwziMVkTVrH44u8P9FFk7adcJnR9DbytswkM2/nFx
         w+bv6JinNXVVjj2g9d4haUs6cPaVuvI2rIBVKZE5QNcG77tQTpdHV+z6OgQweSeCN51i
         tjrnlnuoi9vdrKV3LUrtU6A4zpeGnoWWkJbG+59ZKN+UBYC1lVWT8+ryDQg+I1u5dE0w
         HuoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=PBmq2z3yMVBERX0BReN+bP805W6PwgtvTZirgUjIQog=;
        b=qkVdTD0n8Sk3j0OpQrsdlkVQiTxX0poOqeWaVzbTlUhSVNKNWEPXFPMHkJjUZWMpAE
         u3bLAi+7i16bFoVnYuATX4HPrjHe2/iqJZGpk5E6l9OFwNXhh7uNbS8zsmX0F9RzFR9c
         8crrOJwWwW2Viuwt4w5jZyO9t6eVIu1xY5SHi7W/0AyWXPyxXTcx8U42bFYcgfxILskn
         hfaNn2UcwUkSAGRwdV4HpYrs82agvXu7ZGihyJDizhcZmHQQE/5GUHjuLt2kLNoZKOim
         H94joyZggPWwjVvkt40Ktfu83eAKF3UonuKNrzHcGBqXyHKWD7g1aduyKCesn+e2GfnM
         de4Q==
X-Gm-Message-State: AOAM533f/jVnAk4JMsDU5sbOEsHx1ANp4WgI3/Nv5rAqpEc8Ij1+UmG8
        PrJEDMN7fSC7toluKuPkCP1Zu5u/xuBiNxd/GE/9t0GQ1lrjI+TzXAZK/gc7Vg/y+grz8XiEIg6
        hmYNYd2ODgVChR7Dfy3rXuvZw5YHD0iAqE5xYHKdF3z1nB5vU/MzDJnv4MwhKMMvqX40L
X-Google-Smtp-Source: ABdhPJyaQBFLV7UCTs3BQ8RkwkzdO+k4k7xJuXDNObHzOU9VR+14jr46W16Tn5Ez4DUDp7JoAQkh5QcSnyY/SYkS
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:90b:380d:: with SMTP id
 mq13mr17682899pjb.110.1639074405201; Thu, 09 Dec 2021 10:26:45 -0800 (PST)
Date:   Thu,  9 Dec 2021 18:26:22 +0000
In-Reply-To: <20211209182624.2316453-1-aaronlewis@google.com>
Message-Id: <20211209182624.2316453-2-aaronlewis@google.com>
Mime-Version: 1.0
References: <20211209182624.2316453-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [kvm-unit-tests PATCH 1/3] x86: Fix a #GP from occurring in
 usermode's exception handlers
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When handling an exception in usermode.c the exception handler #GPs when
executing 'iret' to return from the exception handler.  This happens
because the stack segment selector does not have the same privilege
level as the return code segment selector.  Set the stack segment
selector to match the code segment selector's privilege level to fix the
issue.

This problem has been disguised in kvm-unit-tests because a #GP
exception handler has been registered with run_in_user() for the tests
that are currently using this feature.  With a #GP exception handler
registered, the first exception will be processed then #GP on the
return.  Then, because the exception handlers run at CPL0, SS:RSP for
CPL0 will be pushed onto the stack matching KERNEL_CS, which is set in
ex_regs.cs in the exception handler.

This is only a problem in 64-bit mode because 64-bit mode
unconditionally pops SS:RSP  (SDM vol 3, 6.14.3 "IRET in IA-32e Mode").
In 32-bit mode SS:RSP is not popped because there is no privilege level
change when returning from the #GP.

Signed-off-by:  Aaron Lewis <aaronlewis@google.com>
---
 lib/x86/desc.h     | 4 ++++
 lib/x86/usermode.c | 3 +++
 2 files changed, 7 insertions(+)

diff --git a/lib/x86/desc.h b/lib/x86/desc.h
index b65539e..9b81da0 100644
--- a/lib/x86/desc.h
+++ b/lib/x86/desc.h
@@ -18,6 +18,10 @@ struct ex_regs {
     unsigned long rip;
     unsigned long cs;
     unsigned long rflags;
+#ifdef __x86_64__
+    unsigned long rsp;
+    unsigned long ss;
+#endif
 };
 
 typedef void (*handler)(struct ex_regs *regs);
diff --git a/lib/x86/usermode.c b/lib/x86/usermode.c
index 2e77831..57a017d 100644
--- a/lib/x86/usermode.c
+++ b/lib/x86/usermode.c
@@ -26,6 +26,9 @@ static void restore_exec_to_jmpbuf_exception_handler(struct ex_regs *regs)
 	/* longjmp must happen after iret, so do not do it now.  */
 	regs->rip = (unsigned long)&restore_exec_to_jmpbuf;
 	regs->cs = KERNEL_CS;
+#ifdef __x86_64__
+	regs->ss = KERNEL_DS;
+#endif
 }
 
 uint64_t run_in_user(usermode_func func, unsigned int fault_vector,
-- 
2.34.1.173.g76aa8bc2d0-goog

