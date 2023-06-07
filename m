Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F52A72704F
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 23:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235913AbjFGVKS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 17:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236406AbjFGVKM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 17:10:12 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC35BD1
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 14:10:10 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-258b62c7a6bso6936092a91.3
        for <kvm@vger.kernel.org>; Wed, 07 Jun 2023 14:10:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686172210; x=1688764210;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=eNOCB3m8LrJ1G15d0hCgxSqw0T+6CxI1B7aJnYeAUr4=;
        b=PumcfpG1Y1afr0mv4KghGnNmt4F9StFmYhuujPjzKZ3v5WHV2qfFuI+/mxLmbfi09A
         QoeIVWWbhXTHVWa7D5avneXVrdKUzGdfEgXTq7Ni7q7qTOCsedCU6At4yiVzHyC/ai2M
         TIS4sDMzQeErKl5D8JEX70wbw4NmM6z/WSfPRFAefAgzl+FgriJJayadf4cRWyD3elFW
         ZkUWzF6oWlg7Z3DtHB6BUZIM8tOCn/fkQumFQFYZgXJUDSCNqQO+AcVH9HW7FovtFK71
         5jQp6bVw8AM/8jGqEywV6MXS5YegJ9J2jiBKSsInON4jCUrDNiTas0866hUXnfo0TTho
         8jeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686172210; x=1688764210;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eNOCB3m8LrJ1G15d0hCgxSqw0T+6CxI1B7aJnYeAUr4=;
        b=EzN5rQ02gGmj9b5urpENiP7bPntrA/0Dcck5W8So86ymRpIzn0e4x6g2z/ZtxBm5rF
         jHjZ/IOZdKm1eIoluP798z4nU/28YAjgV7VP8XgqS6MyKebT4RlXncfFHdBAtSdsrUSL
         V1IQeyMFBAJp6ZY2R2b/Jh1fkdfNhMnuSp/TxOBqCHpLHMAjftgmQ5jwat5tz0w/IOvh
         ByYKwS0sv9Q8F0NJJluuuPd3W9va2cPWDyxm7NoLCeTbJCmels5ZJmldAFx5EDEol94q
         EWiuwzvlST+woIpiyJ+Sb/b7UH2PuHt1WTBcgLjigvWb8WSU8YW+8AFOnRTer+T7dL4f
         a6zg==
X-Gm-Message-State: AC+VfDyjsZMp+WFCIbNvheBO/4XWIAqt2I2Lke5bJuAWI7hmwzOXIabe
        He0vY0zaG9PRPNhR/vRBs4FTirAjkQA=
X-Google-Smtp-Source: ACHHUZ5VEfvJGkFwAKm9V1d6q+pXUeuYyTQaOL/vdOj60CyUY5vjt8PuNlyQSeSiqfYfMIdITGhAiNVd1LM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:ae16:b0:253:38f0:eff0 with SMTP id
 t22-20020a17090aae1600b0025338f0eff0mr1740572pjq.0.1686172210397; Wed, 07 Jun
 2023 14:10:10 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  7 Jun 2023 14:09:57 -0700
In-Reply-To: <20230607210959.1577847-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230607210959.1577847-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230607210959.1577847-5-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 4/6] x86: nSVM: Ignore mispredict bit in LBR records
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
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

Ignore the mispredict bit when comparing the expected versus actual LBR
records.  Unsurprisingly, relying on the whims of the CPU's branch
predictor results in false failures.

Fixes: 537d39df ("svm: add tests for LBR virtualization")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/svm_tests.c | 65 ++++++++++++++++++++++---------------------------
 1 file changed, 29 insertions(+), 36 deletions(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index e20f6697..9a89155a 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -10,6 +10,7 @@
 #include "isr.h"
 #include "apic.h"
 #include "delay.h"
+#include "util.h"
 #include "x86/usermode.h"
 
 #define SVM_EXIT_MAX_DR_INTERCEPT 0x3f
@@ -2767,26 +2768,29 @@ static void svm_no_nm_test(void)
 	       "fnop with CR0.TS and CR0.EM unset no #NM excpetion");
 }
 
-static bool check_lbr(u64 *from_excepted, u64 *to_expected)
+static u64 amd_get_lbr_rip(u32 msr)
 {
-	u64 from = rdmsr(MSR_IA32_LASTBRANCHFROMIP);
-	u64 to = rdmsr(MSR_IA32_LASTBRANCHTOIP);
-
-	if ((u64)from_excepted != from) {
-		report(false, "MSR_IA32_LASTBRANCHFROMIP, expected=0x%lx, actual=0x%lx",
-		       (u64)from_excepted, from);
-		return false;
-	}
-
-	if ((u64)to_expected != to) {
-		report(false, "MSR_IA32_LASTBRANCHFROMIP, expected=0x%lx, actual=0x%lx",
-		       (u64)from_excepted, from);
-		return false;
-	}
-
-	return true;
+	return rdmsr(msr) & ~AMD_LBR_RECORD_MISPREDICT;
 }
 
+#define HOST_CHECK_LBR(from_expected, to_expected)					\
+do {											\
+	TEST_EXPECT_EQ((u64)from_expected, amd_get_lbr_rip(MSR_IA32_LASTBRANCHFROMIP));	\
+	TEST_EXPECT_EQ((u64)to_expected, amd_get_lbr_rip(MSR_IA32_LASTBRANCHTOIP));	\
+} while (0)
+
+/*
+ * FIXME: Do something other than generate an exception to communicate failure.
+ * Debugging without expected vs. actual is an absolute nightmare.
+ */
+#define GUEST_CHECK_LBR(from_expected, to_expected)				\
+do {										\
+	if ((u64)(from_expected) != amd_get_lbr_rip(MSR_IA32_LASTBRANCHFROMIP))	\
+		asm volatile("ud2");						\
+	if ((u64)(to_expected) != amd_get_lbr_rip(MSR_IA32_LASTBRANCHTOIP))	\
+		asm volatile("ud2");						\
+} while (0)
+
 static bool check_dbgctl(u64 dbgctl, u64 dbgctl_expected)
 {
 	if (dbgctl != dbgctl_expected) {
@@ -2796,7 +2800,6 @@ static bool check_dbgctl(u64 dbgctl, u64 dbgctl_expected)
 	return true;
 }
 
-
 #define DO_BRANCH(branch_name)				\
 	asm volatile (					\
 		      # branch_name "_from:"		\
@@ -2834,11 +2837,8 @@ static void svm_lbrv_test_guest1(void)
 		asm volatile("ud2\n");
 	if (rdmsr(MSR_IA32_DEBUGCTLMSR) != 0)
 		asm volatile("ud2\n");
-	if (rdmsr(MSR_IA32_LASTBRANCHFROMIP) != (u64)&guest_branch0_from)
-		asm volatile("ud2\n");
-	if (rdmsr(MSR_IA32_LASTBRANCHTOIP) != (u64)&guest_branch0_to)
-		asm volatile("ud2\n");
 
+	GUEST_CHECK_LBR(&guest_branch0_from, &guest_branch0_to);
 	asm volatile ("vmmcall\n");
 }
 
@@ -2855,11 +2855,7 @@ static void svm_lbrv_test_guest2(void)
 	if (dbgctl != 0)
 		asm volatile("ud2\n");
 
-	if (rdmsr(MSR_IA32_LASTBRANCHFROMIP) != (u64)&host_branch2_from)
-		asm volatile("ud2\n");
-	if (rdmsr(MSR_IA32_LASTBRANCHTOIP) != (u64)&host_branch2_to)
-		asm volatile("ud2\n");
-
+	GUEST_CHECK_LBR(&host_branch2_from, &host_branch2_to);
 
 	wrmsr(MSR_IA32_DEBUGCTLMSR, DEBUGCTLMSR_LBR);
 	dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
@@ -2868,10 +2864,7 @@ static void svm_lbrv_test_guest2(void)
 
 	if (dbgctl != DEBUGCTLMSR_LBR)
 		asm volatile("ud2\n");
-	if (rdmsr(MSR_IA32_LASTBRANCHFROMIP) != (u64)&guest_branch2_from)
-		asm volatile("ud2\n");
-	if (rdmsr(MSR_IA32_LASTBRANCHTOIP) != (u64)&guest_branch2_to)
-		asm volatile("ud2\n");
+	GUEST_CHECK_LBR(&guest_branch2_from, &guest_branch2_to);
 
 	asm volatile ("vmmcall\n");
 }
@@ -2888,7 +2881,7 @@ static void svm_lbrv_test0(void)
 	dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
 	check_dbgctl(dbgctl, 0);
 
-	check_lbr(&host_branch0_from, &host_branch0_to);
+	HOST_CHECK_LBR(&host_branch0_from, &host_branch0_to);
 }
 
 static void svm_lbrv_test1(void)
@@ -2910,7 +2903,7 @@ static void svm_lbrv_test1(void)
 	}
 
 	check_dbgctl(dbgctl, 0);
-	check_lbr(&guest_branch0_from, &guest_branch0_to);
+	HOST_CHECK_LBR(&guest_branch0_from, &guest_branch0_to);
 }
 
 static void svm_lbrv_test2(void)
@@ -2934,7 +2927,7 @@ static void svm_lbrv_test2(void)
 	}
 
 	check_dbgctl(dbgctl, 0);
-	check_lbr(&guest_branch2_from, &guest_branch2_to);
+	HOST_CHECK_LBR(&guest_branch2_from, &guest_branch2_to);
 }
 
 static void svm_lbrv_nested_test1(void)
@@ -2967,7 +2960,7 @@ static void svm_lbrv_nested_test1(void)
 	}
 
 	check_dbgctl(dbgctl, DEBUGCTLMSR_LBR);
-	check_lbr(&host_branch3_from, &host_branch3_to);
+	HOST_CHECK_LBR(&host_branch3_from, &host_branch3_to);
 }
 
 static void svm_lbrv_nested_test2(void)
@@ -2998,7 +2991,7 @@ static void svm_lbrv_nested_test2(void)
 	}
 
 	check_dbgctl(dbgctl, DEBUGCTLMSR_LBR);
-	check_lbr(&host_branch4_from, &host_branch4_to);
+	HOST_CHECK_LBR(&host_branch4_from, &host_branch4_to);
 }
 
 
-- 
2.41.0.162.gfafddb0af9-goog

