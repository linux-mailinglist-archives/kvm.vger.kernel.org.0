Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCF29473A1B
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 02:18:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238334AbhLNBSh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 20:18:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237215AbhLNBSh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 20:18:37 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D49EAC06173F
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 17:18:36 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id d3-20020a17090a6a4300b001a70e45f34cso10957415pjm.0
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 17:18:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=3bR/XVyullSaRp804j//01DHZhjN7sckcjTz4TDq2B0=;
        b=pzvIL11ZwH70VjT50fN34lrEeF79ocMU6M3HR5Dx59HtmKPREVnVRwks3Ux0XIeUJq
         lS2yiQahnRKOi9JxyzNDb5FbDGi0hTFduAnCqr/Oq5ywrSSm5WkpYcB7NR/rlDX48FNU
         iu0g+IhNWNUknlFY5GnjGM8TMHgnfnGlrrU7WYcsWVbLapLu6LCAlKrST9rWIsqD3YKa
         OEGa1BA73tMKugNUwR49g8YQRMpMKIzrx7bYDc/2OAi+n1w3iivR7Vf8rT87Ppm6Ksfr
         XhdXG2c0AqVfTyWcw2qtExux5AgwtMrDtQRiEvybJCMtassJWhqLsuoC4DQ33Z++Xni4
         zg+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=3bR/XVyullSaRp804j//01DHZhjN7sckcjTz4TDq2B0=;
        b=Hivitvg6uRZ8P5P04eQAnWg+cCFoSCSBxwHRxCtfh2iE7NovbRELS+5rsBEql8zrGo
         HNPPJcHYjpjUxhjV+vXYENF2iy4JIUnc50kB1bGiB0+JYarBkCOGxSya+fzrPyiUCPbm
         EHFkindsTcTRlynFbCZHv2TCw6Kh33x0gYhsLaU4d8GIAW1/azkyku0B03g2yaG4VQbM
         sbSEHIRWTsso4Jk8t398BJhF53FFGkEG6sY6cIwevNbKIJoVHWrM6EeWA8EAipu9sp/G
         oCaPkaBJRvJ0oHj1IHUXsZCHCvXW9COhKzQETgU3S0qpoiLdswZEM7hgXPwznLDCsxll
         npCw==
X-Gm-Message-State: AOAM531t+06+X1AKuGtCIxWLVW8642zS5jOpP1lujcj4nOKf/DBAE3Sy
        Z4EODucS+Ie7ovcvjMiQBto0xNRA9nOfiZY0sJDpcK55oZ0ISSH9YH+uC2dX4MD/gZRU1TCcyL8
        K+SmOpYbupMNTeZsuiMD+AuYlM6UbqqySZScWvINQb/u5jYKEabL6uNhX9LDFJotMKgJ0
X-Google-Smtp-Source: ABdhPJxwO3h0GU6uEJkYLTullNrT+xMMAoO93pxkNcp+IScEv7lnpEYhkZ+c8+PqPFsnDME3mi3pBYmb38lo6mBf
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:90a:f00e:: with SMTP id
 bt14mr2036817pjb.219.1639444716073; Mon, 13 Dec 2021 17:18:36 -0800 (PST)
Date:   Tue, 14 Dec 2021 01:18:20 +0000
In-Reply-To: <20211214011823.3277011-1-aaronlewis@google.com>
Message-Id: <20211214011823.3277011-2-aaronlewis@google.com>
Mime-Version: 1.0
References: <20211214011823.3277011-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [kvm-unit-tests PATCH v2 1/4] x86: Fix a #GP from occurring in
 usermode library's exception handlers
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When handling an exception in usermode.c the exception handler #GPs when
executing IRET to return from the exception handler.  This happens
because the stack segment selector does not have the same privilege
level as the return code segment selector.  Set the stack segment
selector to match the code segment selector's privilege level to fix the
issue.

This problem has been disguised in kvm-unit-tests because a #GP
exception handler has been registered with run_in_user() for the tests
that are currently using this feature.  With a #GP exception handler
registered, the first exception will be processed then #GP on the
IRET. The IRET from the second #GP will then succeed, and the subsequent
lngjmp() will restore RSP to a sane value.  But if no #GP handler is
installed, e.g. if a test wants to handle only #ACs, the #GP on the
initial IRET will be fatal.

This is only a problem in 64-bit mode because 64-bit mode
unconditionally pops SS:RSP  (SDM vol 3, 6.14.3 "IRET in IA-32e Mode").
In 32-bit mode SS:RSP is not popped because there is no privilege level
change when executing IRET at the end of the #GP handler.

Signed-off-by:  Aaron Lewis <aaronlewis@google.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
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

