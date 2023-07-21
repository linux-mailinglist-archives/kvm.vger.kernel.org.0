Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD1BB75D58F
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 22:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231436AbjGUUU3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 16:20:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231431AbjGUUUF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 16:20:05 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1895F35A7
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 13:19:31 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-57a3620f8c0so24104737b3.3
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 13:19:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689970770; x=1690575570;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=mHJaGcmVZZrx5eJzID4aSbivNsbcbnHCRBUFTHr46UU=;
        b=xFjEUGb0YeU1GuqO6TMYTw4S8pE3wSKHfAnKkjt80FS5sXpKILObv/a3O3ewHWsGTO
         /uzvI4F2rqO1kbuzWSa4MliHY9cF1H/Ac9QzYVtv+NpjhbtyPfoNrV+E8v7WZNB/bFw6
         ZQ7omF8dzvvNGZgQWyEPIyPC2w4JP9kZNJKLQfZrbxFODjZi5nLgku8ikRETSpBGVBoX
         oTGOuajDeuXcYaiGo4yFKLgo/FiyRHoPoBqYGCiHsyTHKlkUVEYlJTNm2xlmLZ2ST0En
         IL9sBALfri08BXauA1hERqbg4OfcffWRTJh4RjhdbbAEe8+cFgFJdJ8ifVoxgauGAZCM
         iuuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689970770; x=1690575570;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mHJaGcmVZZrx5eJzID4aSbivNsbcbnHCRBUFTHr46UU=;
        b=JUU9KloPzRUhp5tktFqgqlZn3Ee1MkVn+A2bdhU5rhHnS2nhuifeolOpaydcrM3qGn
         /dkdNbHx0WsDs2q3ntnO7QC0bHDyNHn+8iUF9s9uF8aCac7CkF+EJlSjS0YKO6y2FTAe
         kglmL0Rgtf271h3uCKF6KyeMDmcju6lYtBgt2w2ut0lYht8vcftlyakkNS5eKaWWukcC
         dPjYv1wbQevdSd+yLpX07Xka13Y60gkbMdxMv4Q2h9ETc7J3INFYwNVsHq7S9rH6o6dS
         QcwXiL4tb9qGCzLhA4UsYkfuotx5jXWq/EK7+D1tFQfhf+E6khF5uGP7ycemVdOBTlBc
         2+iw==
X-Gm-Message-State: ABy/qLaKdUGlEQMlId16n6OmbBtN3bhcK3HBhhqp1T0cVnwHUk2fDduT
        FajFn4kHJkTSXMJsp9dG1IAD7493Tg8=
X-Google-Smtp-Source: APBJJlGF70SDbq3ZEJP5RArk6dyLbOvKEAdAx8uwY/2QO3SFNPIUp6BScgv9kfKmHPsrEaR+kwKTcLne1bo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ac15:0:b0:55d:d5b1:c2bd with SMTP id
 k21-20020a81ac15000000b0055dd5b1c2bdmr9808ywh.8.1689970770756; Fri, 21 Jul
 2023 13:19:30 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 21 Jul 2023 13:18:53 -0700
In-Reply-To: <20230721201859.2307736-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230721201859.2307736-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230721201859.2307736-14-seanjc@google.com>
Subject: [PATCH v4 13/19] x86/virt: KVM: Open code cpu_has_svm() into kvm_is_svm_supported()
From:   Sean Christopherson <seanjc@google.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Andrew Cooper <Andrew.Cooper3@citrix.com>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>
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

Fold the guts of cpu_has_svm() into kvm_is_svm_supported(), its sole
remaining user.

No functional change intended.

Reviewed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/virtext.h | 28 ----------------------------
 arch/x86/kvm/svm/svm.c         | 11 ++++++++---
 2 files changed, 8 insertions(+), 31 deletions(-)

diff --git a/arch/x86/include/asm/virtext.h b/arch/x86/include/asm/virtext.h
index be50c414efe4..632575e257d8 100644
--- a/arch/x86/include/asm/virtext.h
+++ b/arch/x86/include/asm/virtext.h
@@ -22,35 +22,7 @@
 /*
  * SVM functions:
  */
-
-/** Check if the CPU has SVM support
- *
- * You can use the 'msg' arg to get a message describing the problem,
- * if the function returns zero. Simply pass NULL if you are not interested
- * on the messages; gcc should take care of not generating code for
- * the messages on this case.
- */
-static inline int cpu_has_svm(const char **msg)
-{
-	if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD &&
-	    boot_cpu_data.x86_vendor != X86_VENDOR_HYGON) {
-		if (msg)
-			*msg = "not amd or hygon";
-		return 0;
-	}
-
-	if (!boot_cpu_has(X86_FEATURE_SVM)) {
-		if (msg)
-			*msg = "svm not available";
-		return 0;
-	}
-	return 1;
-}
-
-
 /** Disable SVM on the current CPU
- *
- * You should call this only if cpu_has_svm() returned true.
  */
 static inline void cpu_svm_disable(void)
 {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 1ae9c2c7eacb..ff6c769aafb2 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -521,11 +521,16 @@ static void svm_init_osvw(struct kvm_vcpu *vcpu)
 static bool kvm_is_svm_supported(void)
 {
 	int cpu = raw_smp_processor_id();
-	const char *msg;
 	u64 vm_cr;
 
-	if (!cpu_has_svm(&msg)) {
-		pr_err("SVM not supported by CPU %d, %s\n", cpu, msg);
+	if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD &&
+	    boot_cpu_data.x86_vendor != X86_VENDOR_HYGON) {
+		pr_err("CPU %d isn't AMD or Hygon\n", cpu);
+		return false;
+	}
+
+	if (!boot_cpu_has(X86_FEATURE_SVM)) {
+		pr_err("SVM not supported by CPU %d\n", cpu);
 		return false;
 	}
 
-- 
2.41.0.487.g6d72f3e995-goog

