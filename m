Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7CD29F2AC
	for <lists+kvm@lfdr.de>; Thu, 29 Oct 2020 18:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727468AbgJ2RKf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Oct 2020 13:10:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725957AbgJ2RKe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Oct 2020 13:10:34 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21E5DC0613CF
        for <kvm@vger.kernel.org>; Thu, 29 Oct 2020 10:10:34 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id b7so3268447ybn.3
        for <kvm@vger.kernel.org>; Thu, 29 Oct 2020 10:10:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=Nu3N33BP5UwHRfyIOYQtPvew2pFcbwX2S1cOPNYDlBY=;
        b=X9H8n8JoVENHK4YSrSCWhQBf8clRY1gs0iuDOSWA8jdyxtZm9llfAthBRh+zuHGxJ8
         dwEuTu4i+ylLwlpgXS0sGfMjYpuGNOcl4kpdSktizLd7zs0ZemGlFUqQgmAGyKgKGQPq
         WseIgI7sL+FrC2uLum0+UAkEFZbdbFy3US6PDpj/kcgo9rCjywIzXn+GyuMrsy1ddba7
         9sPN8m9zuAwd3qJOCLUUypAgYbRCc1n1l9Hydt0vlJuws0ylWLoY+7B9jsVCprzNll5i
         9WsJRahWgwJZMQxVgiSw2yPl0P6847jF3XAmElxHdFLdDpUnT2AYouzT6g4CiatQlXnX
         uxUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Nu3N33BP5UwHRfyIOYQtPvew2pFcbwX2S1cOPNYDlBY=;
        b=q2iC0mjtIUKwD7wYnucOAlsGLQ55FX0pJ+d/UuV32DO5KuGySXr2n6CS/1dlqI3VSm
         Hf8mzcWZ3F3GlZUG1QYdlipy5fD6E1ovNIZ8gzt+/6PgcT7Q679RiTDtOvG67MVMU3JW
         Ray42wSPye8MwQDz0/CwCoVG3UfWua1YNOynq04TD4mTbu8l0NS94I3iv8YaY49ZNfzh
         59TTwVzpg11iEZ0awbo6/WJ0vgRQyOfEf5KV1Hctomk2Bk4yZCB5GYjvvY+DLhEBDjS/
         kDwyoZP4ySpXqcThILARvD5fBKVnFr1b5miHELiJ6ckROZJulWmFzfbnwvRfPcViVtKQ
         hqOg==
X-Gm-Message-State: AOAM530m3vK5IFy5fCBIVmkSDP+E6VOnbc2GvgTWEYWTYXx9Hb8txXQ2
        a1QJ6CC4zMAvG3blTCl3gzzV71h0xjOmMsFfvicdN8muVS34JnJP1y7oHTh7xwTkh0t81n/QK0F
        yx4Bn2n4PSnEfyNCTCriAGFvsCc2JDSNn4syJyWM3UECloJsaqc6WcQqNeCmWLnM=
X-Google-Smtp-Source: ABdhPJyCEfkc/lPnaZyIa/LjrJWxYS+tQuONWAujA4GaTTu37TerHuh1a1sM8oBhy3NfPGONtPoFKnfYBS4Ifw==
Sender: "jmattson via sendgmr" <jmattson@turtle.sea.corp.google.com>
X-Received: from turtle.sea.corp.google.com ([2620:15c:100:202:725a:fff:fe43:64b1])
 (user=jmattson job=sendgmr) by 2002:a5b:888:: with SMTP id
 e8mr7172137ybq.436.1603991433335; Thu, 29 Oct 2020 10:10:33 -0700 (PDT)
Date:   Thu, 29 Oct 2020 10:10:24 -0700
In-Reply-To: <20201029171024.486256-1-jmattson@google.com>
Message-Id: <20201029171024.486256-2-jmattson@google.com>
Mime-Version: 1.0
References: <20201029171024.486256-1-jmattson@google.com>
X-Mailer: git-send-email 2.29.1.341.ge80a0c044ae-goog
Subject: [kvm-unit-tests PATCH 2/2] x86: svm: Add test for L2 change of CR4.OSXSAVE
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If L1 allows L2 to modify CR4.OSXSAVE, then L0 kvm recalculates the
guest's CPUID.01H:ECX.OSXSAVE bit when the L2 guest changes
CR4.OSXSAVE via MOV-to-CR4. Verify that kvm also recalculates this
CPUID bit when loading L1's CR4 from the save.cr4 field of the
hsave area.

Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
---
 x86/svm_tests.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 3b0424a..e2455c8 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -1917,6 +1917,40 @@ static bool reg_corruption_check(struct svm_test *test)
  * v2 tests
  */
 
+/*
+ * Ensure that kvm recalculates the L1 guest's CPUID.01H:ECX.OSXSAVE
+ * after VM-exit from an L2 guest that sets CR4.OSXSAVE to a different
+ * value than in L1.
+ */
+
+static void svm_cr4_osxsave_test_guest(struct svm_test *test)
+{
+	write_cr4(read_cr4() & ~X86_CR4_OSXSAVE);
+}
+
+static void svm_cr4_osxsave_test(void)
+{
+	if (!this_cpu_has(X86_FEATURE_XSAVE)) {
+		report_skip("XSAVE not detected");
+		return;
+	}
+
+	if (!(read_cr4() & X86_CR4_OSXSAVE)) {
+		unsigned long cr4 = read_cr4() | X86_CR4_OSXSAVE;
+
+		write_cr4(cr4);
+		vmcb->save.cr4 = cr4;
+	}
+
+	report(cpuid_osxsave(), "CPUID.01H:ECX.XSAVE set before VMRUN");
+
+	test_set_guest(svm_cr4_osxsave_test_guest);
+	report(svm_vmrun() == SVM_EXIT_VMMCALL,
+	       "svm_cr4_osxsave_test_guest finished with VMMCALL");
+
+	report(cpuid_osxsave(), "CPUID.01H:ECX.XSAVE set after VMRUN");
+}
+
 static void basic_guest_main(struct svm_test *test)
 {
 }
@@ -2301,6 +2335,7 @@ struct svm_test svm_tests[] = {
     { "reg_corruption", default_supported, reg_corruption_prepare,
       default_prepare_gif_clear, reg_corruption_test,
       reg_corruption_finished, reg_corruption_check },
+    TEST(svm_cr4_osxsave_test),
     TEST(svm_guest_state_test),
     { NULL, NULL, NULL, NULL, NULL, NULL, NULL }
 };
-- 
2.29.1.341.ge80a0c044ae-goog

