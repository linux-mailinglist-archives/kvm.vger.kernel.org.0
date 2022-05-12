Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ABD3525856
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 01:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359503AbiELXbI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 19:31:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359486AbiELXau (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 19:30:50 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7A39340EB
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 16:30:49 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id o7-20020a17090a0a0700b001d93c491131so5265467pjo.6
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 16:30:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=uXbXPEK1ZtYAwH7zbcJTbQ60Hla+wIYeTk6g5KOx6XE=;
        b=lDoRvAUFwknyXDQ6PqU5WlJLV9mkMtDZNWMXC0w/rCuGLpLkkHG/PVByvek7LE0qVP
         eqGgs0dpQyg5AnRdJvJY236R+cObzx9bHkRAJC1VJr3sZGc1nXVysaBYTDWEFfG+UZRS
         0Gyf/VAwEpY5Wb/KpGX+TRZgcAw6r029so7iMbiqJDBrtYNH+HFbSi1ebcS1fncL0Ddd
         Jrw1JoHpCvmWXUDjB72U7O/lcdHljVmln8eq3A2qOsaO+Dvnou3drFSsJ2PU+pQZtCcW
         MVTC6G76q0gnbHotRm2x/jxcVRqXseTeW779Qcyti0or+ntM9ibEXl6uA359D0jOGxeY
         jQrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=uXbXPEK1ZtYAwH7zbcJTbQ60Hla+wIYeTk6g5KOx6XE=;
        b=10XuRAUPmY1fqRbaQTXi8teIdghENiBSdLRfrVHByZOJIwqUo/a+p3v33a8QxWy6we
         YlZLq6dYYgqGX+Q6JOgIPEkzBbveZQJZvkIkuXUtjIEfaKwEqj+7bYdYyyaCXm4WsKkO
         YXzlWNanmoyuCJtPzJGYV+DH4rTzoouillHgP2tKP4/MxptGVrF3IhjL5NU1Abfz3G/l
         VxoNlAlYX+xx0R7HPl0rKu5ys9OzYWETyOBHBR7DNZdijliEg7wj5mpNz3oGEid+1g3x
         JIjmX/H2P6PwZxwWSDVtadg9TVjkSbuUlzf5WFKHYign8Ja45MagRQ+ZDHv/RSYxVgsu
         OHCA==
X-Gm-Message-State: AOAM5334HJmF2SeHv9eWdLUXo6m8S/2wFKcbT3pXUbvQzJUxVqOIyLF8
        Y3T0EVwUl21XhFy7h2ys4BbF07U+IZE=
X-Google-Smtp-Source: ABdhPJyi6BNUcybfM9hjlUQPJsIeoSdHTgh+cg3G3y4HnS3vsQKPxhrVO1CU0b/5Os7TyJCu9k10ZY62Z3A=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:e94e:b0:15b:22a7:f593 with SMTP id
 b14-20020a170902e94e00b0015b22a7f593mr1764108pll.148.1652398249156; Thu, 12
 May 2022 16:30:49 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 12 May 2022 23:30:44 +0000
In-Reply-To: <20220512233045.4125471-1-seanjc@google.com>
Message-Id: <20220512233045.4125471-2-seanjc@google.com>
Mime-Version: 1.0
References: <20220512233045.4125471-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [kvm-unit-tests PATCH 1/2] x86: msr: Take the MSR index and name
 separately in low level helpers
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Take the "raw" MSR index and name in the MSR helpers, not a struct that
is partially consumed.  Aside from the oddity of having two values for
the wrmsr helpers, taking the struct makes it unnecessarily annoying to
test MSRs that aren't a good fit for the common handling, e.g. for MCE
MSRs.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/msr.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/x86/msr.c b/x86/msr.c
index 44fbb3b2..3d48e396 100644
--- a/x86/msr.c
+++ b/x86/msr.c
@@ -47,50 +47,50 @@ struct msr_info msr_info[] =
 //	MSR_VM_HSAVE_PA only AMD host
 };
 
-static void test_msr_rw(struct msr_info *msr, unsigned long long val)
+static void test_msr_rw(u32 msr, const char *name, unsigned long long val)
 {
 	unsigned long long r, orig;
 
-	orig = rdmsr(msr->index);
+	orig = rdmsr(msr);
 	/*
 	 * Special case EFER since clearing LME/LMA is not allowed in 64-bit mode,
 	 * and conversely setting those bits on 32-bit CPUs is not allowed.  Treat
 	 * the desired value as extra bits to set.
 	 */
-	if (msr->index == MSR_EFER)
+	if (msr == MSR_EFER)
 		val |= orig;
-	wrmsr(msr->index, val);
-	r = rdmsr(msr->index);
-	wrmsr(msr->index, orig);
+	wrmsr(msr, val);
+	r = rdmsr(msr);
+	wrmsr(msr, orig);
 	if (r != val) {
 		printf("testing %s: output = %#" PRIx32 ":%#" PRIx32
-		       " expected = %#" PRIx32 ":%#" PRIx32 "\n", msr->name,
+		       " expected = %#" PRIx32 ":%#" PRIx32 "\n", name,
 		       (u32)(r >> 32), (u32)r, (u32)(val >> 32), (u32)val);
 	}
-	report(val == r, "%s", msr->name);
+	report(val == r, "%s", name);
 }
 
-static void test_wrmsr_fault(struct msr_info *msr, unsigned long long val)
+static void test_wrmsr_fault(u32 msr, const char *name, unsigned long long val)
 {
-	unsigned char vector = wrmsr_checking(msr->index, val);
+	unsigned char vector = wrmsr_checking(msr, val);
 
 	report(vector == GP_VECTOR,
 	       "Expected #GP on WRSMR(%s, 0x%llx), got vector %d",
-	       msr->name, val, vector);
+	       name, val, vector);
 }
 
-static void test_rdmsr_fault(struct msr_info *msr)
+static void test_rdmsr_fault(u32 msr, const char *name)
 {
-	unsigned char vector = rdmsr_checking(msr->index);
+	unsigned char vector = rdmsr_checking(msr);
 
 	report(vector == GP_VECTOR,
-	       "Expected #GP on RDSMR(%s), got vector %d", msr->name, vector);
+	       "Expected #GP on RDSMR(%s), got vector %d", name, vector);
 }
 
 static void test_msr(struct msr_info *msr, bool is_64bit_host)
 {
 	if (is_64bit_host || !msr->is_64bit_only) {
-		test_msr_rw(msr, msr->value);
+		test_msr_rw(msr->index, msr->name, msr->value);
 
 		/*
 		 * The 64-bit only MSRs that take an address always perform
@@ -98,10 +98,10 @@ static void test_msr(struct msr_info *msr, bool is_64bit_host)
 		 */
 		if (msr->is_64bit_only &&
 		    msr->value == addr_64)
-			test_wrmsr_fault(msr, NONCANONICAL);
+			test_wrmsr_fault(msr->index, msr->name, NONCANONICAL);
 	} else {
-		test_wrmsr_fault(msr, msr->value);
-		test_rdmsr_fault(msr);
+		test_wrmsr_fault(msr->index, msr->name, msr->value);
+		test_rdmsr_fault(msr->index, msr->name);
 	}
 }
 
-- 
2.36.0.550.gb090851708-goog

