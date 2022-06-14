Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55F2D54BB91
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 22:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358050AbiFNUKh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 16:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357760AbiFNUJT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 16:09:19 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B78AF4F9D4
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:08:21 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id y8-20020a17090322c800b0016777c34c83so5335109plg.19
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:08:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=VAWi7Bdww9IG9P9iwSIPXN8TXA1x0JQZXp9kmqWl1Y4=;
        b=L6HRWDOfXbPW+DDR3STq/bmXiXYmh0xgwyIlyEUU9EPaQg6uVNUUlXOfqp2XRgOUKi
         g4ZxjUFuxYkw36mZXH/nwbe+BiCZecowWl83RhmTvocYTPSFH+xFXGeW7daq8LBbI6hK
         j/GYyhXNAboO1pn3/7/DoRSrqs95VhLSmVL6JaWbuvZeq7Hjp3kHb3EZ1JMnH1zskAw0
         Z2RTjO2UsXinXae3KqXFrtsSBMlFH6F1LIAZy0/IN6FsKMJ0O0pGnPBOY39iFnrF4eo0
         6YoTqOC4SdlkdY85+fBbuEeXD/rfz8SwOOJ/OobIwxQRwqoqN+4RTgxdpmUTZ/E4EiP3
         +5Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=VAWi7Bdww9IG9P9iwSIPXN8TXA1x0JQZXp9kmqWl1Y4=;
        b=ggrQsez9e2SD5M0GOkPLARuu95Gkzvu0pf0yu+sBnd96rXjaN+L5p3B1fPALEX+8R/
         ELKcYCrtbPHlbbjhaTKkqr+aNEgw/bVxyh8RxxbkTMNyWLNYpazdRR8eoDBAZbf2/d1K
         nmZ80An2fDOMn2+KJG4AyyIWm16QXvf/qNkOG8RGJ8pIN2YOy9Yl9j40jtHtz9WD/HOG
         +KUbxy2pLPZNHST6u0nOwM6DTyo8zz66vsFXdj5an1HY0+EDBp2DzAXhxckeFh3QZ/Mz
         g1+/69WA5hHsoARw4qgOn0C9VEzIliq2J/Wsz7jN4oMfs1lPoZieUAGqy6wtf/FFTbqC
         eCvA==
X-Gm-Message-State: AJIora8g8XuG9UVDL9l+w+kzqsVKx26YkAJb9TcPYz8NWPRblt/9laxN
        xzctbxCQ15e1vEj6cc3QuqyIujZ8EZM=
X-Google-Smtp-Source: AGRyM1s4nEeW+5kwThDu7KkeacO/t1l1CoHigrin+2yNEeHYbfc2GanaMhB00e8aRt8zt11kSjJ5CIi7Efo=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:3b86:b0:1e8:6b89:2bb2 with SMTP id
 pc6-20020a17090b3b8600b001e86b892bb2mr6335631pjb.15.1655237293659; Tue, 14
 Jun 2022 13:08:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 20:06:59 +0000
In-Reply-To: <20220614200707.3315957-1-seanjc@google.com>
Message-Id: <20220614200707.3315957-35-seanjc@google.com>
Mime-Version: 1.0
References: <20220614200707.3315957-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v2 34/42] KVM: selftests: Use this_cpu_has() to detect SVM
 support in L1
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
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

Replace an evil open coded instance of querying CPUID from L1 with
this_cpu_has(X86_FEATURE_SVM).

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/include/x86_64/svm_util.h | 13 -------------
 tools/testing/selftests/kvm/x86_64/smm_test.c       |  4 ++--
 tools/testing/selftests/kvm/x86_64/state_test.c     |  2 +-
 3 files changed, 3 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/svm_util.h b/tools/testing/selftests/kvm/include/x86_64/svm_util.h
index f48806d26989..a339b537a575 100644
--- a/tools/testing/selftests/kvm/include/x86_64/svm_util.h
+++ b/tools/testing/selftests/kvm/include/x86_64/svm_util.h
@@ -13,9 +13,6 @@
 #include "svm.h"
 #include "processor.h"
 
-#define CPUID_SVM_BIT		2
-#define CPUID_SVM		BIT_ULL(CPUID_SVM_BIT)
-
 #define SVM_EXIT_EXCP_BASE	0x040
 #define SVM_EXIT_HLT		0x078
 #define SVM_EXIT_MSR		0x07c
@@ -52,16 +49,6 @@ struct svm_test_data *vcpu_alloc_svm(struct kvm_vm *vm, vm_vaddr_t *p_svm_gva);
 void generic_svm_setup(struct svm_test_data *svm, void *guest_rip, void *guest_rsp);
 void run_guest(struct vmcb *vmcb, uint64_t vmcb_gpa);
 
-static inline bool cpu_has_svm(void)
-{
-	u32 eax = 0x80000001, ecx;
-
-	asm("cpuid" :
-	    "=a" (eax), "=c" (ecx) : "0" (eax) : "ebx", "edx");
-
-	return ecx & CPUID_SVM;
-}
-
 int open_sev_dev_path_or_exit(void);
 
 #endif /* SELFTEST_KVM_SVM_UTILS_H */
diff --git a/tools/testing/selftests/kvm/x86_64/smm_test.c b/tools/testing/selftests/kvm/x86_64/smm_test.c
index 40581704f129..7937db5b1037 100644
--- a/tools/testing/selftests/kvm/x86_64/smm_test.c
+++ b/tools/testing/selftests/kvm/x86_64/smm_test.c
@@ -83,7 +83,7 @@ static void guest_code(void *arg)
 	sync_with_host(4);
 
 	if (arg) {
-		if (cpu_has_svm()) {
+		if (this_cpu_has(X86_FEATURE_SVM)) {
 			generic_svm_setup(svm, l2_guest_code,
 					  &l2_guest_stack[L2_GUEST_STACK_SIZE]);
 		} else {
@@ -99,7 +99,7 @@ static void guest_code(void *arg)
 
 		sync_with_host(7);
 
-		if (cpu_has_svm()) {
+		if (this_cpu_has(X86_FEATURE_SVM)) {
 			run_guest(svm->vmcb, svm->vmcb_gpa);
 			run_guest(svm->vmcb, svm->vmcb_gpa);
 		} else {
diff --git a/tools/testing/selftests/kvm/x86_64/state_test.c b/tools/testing/selftests/kvm/x86_64/state_test.c
index 35e96d7a6ba1..d37e25229fe5 100644
--- a/tools/testing/selftests/kvm/x86_64/state_test.c
+++ b/tools/testing/selftests/kvm/x86_64/state_test.c
@@ -142,7 +142,7 @@ static void __attribute__((__flatten__)) guest_code(void *arg)
 	GUEST_SYNC(2);
 
 	if (arg) {
-		if (cpu_has_svm())
+		if (this_cpu_has(X86_FEATURE_SVM))
 			svm_l1_guest_code(arg);
 		else
 			vmx_l1_guest_code(arg);
-- 
2.36.1.476.g0c4daa206d-goog

