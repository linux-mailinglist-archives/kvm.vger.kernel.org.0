Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F61F4944A5
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 01:29:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357791AbiATA3n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 19:29:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357801AbiATA3d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 19:29:33 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 329A8C06161C
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 16:29:33 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id p16-20020a170902a41000b0014992c5d56bso708065plq.19
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 16:29:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=+D1IJPVTiPM5IAy2LlX0u6UtzX6XcjhBEHovl1KfP10=;
        b=g7B4ksjsMSGG3i+0Q7HMyVFCPik2oreH1J44wEVtbfUDQ3BWZFsLslPKSBkgfTB04A
         MSo+JnyN0jIdVjdHspMSgFbA4QWfDoq5YtDlP4Ns+S/mkNUY9zAGahwdfoWd2lciPmLw
         k9qLkJe859b55Lt1D74Kk86TFTowLZqrPxyxY2Za50mYG5f3VBEzTQuglTvu2h8cFKhd
         +ktsLVSWIzI+uB1lZPghDl6aVuQkOtynoZWcS8W9hDucXR9lLFZOIEkPpCxbG+WMcVby
         xn7Lndv0Mm07YXniyogtc2GE8xwVnwxNG/ry63MCu9LVqbHo+H2EH+NI+z/OAaWi6k3O
         G2mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=+D1IJPVTiPM5IAy2LlX0u6UtzX6XcjhBEHovl1KfP10=;
        b=etJIDg8ywsXORIOrz+/7rCHd3msjFVYUBJcH6Rs0J0uyCU+TBDUT1CaWkBvHSoSXpO
         AauzZGvsbeP0nyCt5W2hYiASQ/5siKiIDG9r50a1B7hhN3TJ47/ZDw0osX/fBdvafR48
         AuanFdgpeWtxdwik31aNTvZ3YWp+F5aKyJ0o+s1JNFBcPkdMm/u0zHZa31cONAN+H2ir
         jWEAenEHYiiKzLarSc6Nz5sGb5F+mfFv8lm6/EcPxEEWBVRfyrFdxIbcelzbV87EVtYN
         zLoMNN+MkuYAfqCzrcXOtA7EJ32m6J0j4SOqVqAqqdlXfIOig6hUbasBcdAzT1pdFuAv
         iCpw==
X-Gm-Message-State: AOAM530bwZd1SuwlqsewF56CTzXqDaHRVACNJfyho4CauWAtWdVHW8dW
        p3OKJPrdG1u4hwroCqzJ1mjOcDV4CZE=
X-Google-Smtp-Source: ABdhPJyNVr+4oDufMYBZNM9dl722s9zy1neW6szp7ki1BNcICRG/so3XiPdovcsCliUpJSmhRIp5mWqIXgo=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:588f:: with SMTP id
 j15mr7373394pji.242.1642638572670; Wed, 19 Jan 2022 16:29:32 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 20 Jan 2022 00:29:20 +0000
In-Reply-To: <20220120002923.668708-1-seanjc@google.com>
Message-Id: <20220120002923.668708-5-seanjc@google.com>
Mime-Version: 1.0
References: <20220120002923.668708-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [kvm-unit-tests PATCH 4/7] x86/debug: Run single-step #DB tests in
 usermode (and kernel mode)
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Alexander Graf <graf@amazon.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Run the single-step #DB tests in usermode in addition to running them in
kernel mode, i.e. run at CPL0 and CPL3.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/debug.c | 29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/x86/debug.c b/x86/debug.c
index 4b2fbe97..21f1da0b 100644
--- a/x86/debug.c
+++ b/x86/debug.c
@@ -12,6 +12,7 @@
 #include "libcflat.h"
 #include "processor.h"
 #include "desc.h"
+#include "usermode.h"
 
 static volatile unsigned long bp_addr;
 static volatile unsigned long db_addr[10], dr6[10];
@@ -75,28 +76,43 @@ static void handle_ud(struct ex_regs *regs)
 }
 
 typedef unsigned long (*db_test_fn)(void);
-typedef void (*db_report_fn)(unsigned long);
+typedef void (*db_report_fn)(unsigned long, const char *);
 
 static void __run_single_step_db_test(db_test_fn test, db_report_fn report_fn)
 {
 	unsigned long start;
+	bool ign;
 
 	n = 0;
 	write_dr6(0);
 
 	start = test();
-	report_fn(start);
+	report_fn(start, "");
+
+	n = 0;
+	write_dr6(0);
+	/*
+	 * Run the test in usermode.  Use the expected start RIP from the first
+	 * run, the usermode framework doesn't make it easy to get the expected
+	 * RIP out of the test, and it shouldn't change in any case.  Run the
+	 * test with IOPL=3 so that it can use OUT, CLI, STI, etc...
+	 */
+	set_iopl(3);
+	run_in_user((usermode_func)test, GP_VECTOR, 0, 0, 0, 0, &ign);
+	set_iopl(0);
+
+	report_fn(start, "Usermode ");
 }
 
 #define run_ss_db_test(name) __run_single_step_db_test(name, report_##name)
 
-static void report_singlestep_basic(unsigned long start)
+static void report_singlestep_basic(unsigned long start, const char *usermode)
 {
 	report(n == 3 &&
 	       is_single_step_db(dr6[0]) && db_addr[0] == start &&
 	       is_single_step_db(dr6[1]) && db_addr[1] == start + 1 &&
 	       is_single_step_db(dr6[2]) && db_addr[2] == start + 1 + 1,
-	       "Single-step #DB basic test");
+	       "%sSingle-step #DB basic test", usermode);
 }
 
 static unsigned long singlestep_basic(void)
@@ -122,7 +138,8 @@ static unsigned long singlestep_basic(void)
 	return start;
 }
 
-static void report_singlestep_emulated_instructions(unsigned long start)
+static void report_singlestep_emulated_instructions(unsigned long start,
+						    const char *usermode)
 {
 	report(n == 6 &&
 	       is_single_step_db(dr6[0]) && db_addr[0] == start &&
@@ -131,7 +148,7 @@ static void report_singlestep_emulated_instructions(unsigned long start)
 	       is_single_step_db(dr6[3]) && db_addr[3] == start + 1 + 3 + 2 &&
 	       is_single_step_db(dr6[4]) && db_addr[4] == start + 1 + 3 + 2 + 2 &&
 	       is_single_step_db(dr6[5]) && db_addr[5] == start + 1 + 3 + 2 + 2 + 1,
-	       "Single-step #DB on emulated instructions");
+	       "%sSingle-step #DB on emulated instructions", usermode);
 }
 
 static unsigned long singlestep_emulated_instructions(void)
-- 
2.34.1.703.g22d0c6ccf7-goog

