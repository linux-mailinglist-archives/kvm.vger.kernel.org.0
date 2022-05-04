Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5119251B2AA
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 01:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233403AbiEDW4S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 18:56:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379383AbiEDWyy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:54:54 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56B40532FF
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:51:01 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id bj12-20020a056a02018c00b003a9eebaad34so1340284pgb.10
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:51:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=dCR7WcCtZnymTpZN40GNLyRhTKxieftGqfQaPMOMqE4=;
        b=C5KjEyEph7kGwQRtVcQNRkloCpNFqAL+EmDQS9Ts4wLm9bdGueEg2eiM3ik3uUdx2N
         641BkOnEH4qYNuMXWxBZ8/EjC6XDb366hNBbvG80yMZL+fHNjN5SgFR4ynHfrN9+shgf
         iEtyO+DGoEMyRx+4b+4uKbSTDtH2qFBsdrVe9Ew+V7lkQQJ2c4+WkFRPGXDwlp8+xzHC
         zs4++l3oRIKYKnCvxD9geyJ/sTtWFtmo1qXcT1LLs6DUETSSDhgqs3uqjO6JYomxK533
         0dkJ9S9gC4OmstnZfa7xsaSrD5ta4WVGjqMXDb1fiees0YSkiSDnHj8RoValXZOyd4pm
         9jeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=dCR7WcCtZnymTpZN40GNLyRhTKxieftGqfQaPMOMqE4=;
        b=uJZ2jg8sjWuUgqinr7Z0WVMOfyUm8hw0dZLokziJ1t20Ue/VaoBelDkuokrXBOmnJm
         Oqy4XrA06Qjx0rnLdi20kHuBcMx+VspdF5U1vn3KAZtdV55hKykXB+GLi5vA236pp6aE
         pCHeW9AnLJ3xpjL6TSIN7Saq69w3ZVio1jU41LpqeRBHEvzyFuv2HIhTSki7Kuehod4i
         9jvsoZECkAudA8cZy2KjCJCJLy8Kbu8+p4xfEepDH6XTnYIiI528fc4PPxc90yos+mVs
         sVZQ2CD2J51sW0RCjhw7oNZwzcD9aCM32i+oK9KgRjJKO4bgiInjHb7Z6dLOW2VXTUcN
         Zvsg==
X-Gm-Message-State: AOAM531/Y3krrNKQcPYC50lB4IYpYcd59VCRL9PCYE3fKgt4EcdQ8/qW
        /nO8wy69ReSXKdlmXwmb176UtG6r8kw=
X-Google-Smtp-Source: ABdhPJyO2XObGNQTqa1uA3YNLj++17/7eq8A1YBkCP/0wIHbRHj9VlptaOR0LTN2K52MZhyT7DFFzEvncas=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1d90:b0:1dc:2e4b:37c3 with SMTP id
 pf16-20020a17090b1d9000b001dc2e4b37c3mr2197849pjb.117.1651704660852; Wed, 04
 May 2022 15:51:00 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:47:58 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-53-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 052/128] KVM: selftests: Convert state_test away from VCPU_ID
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>,
        Sean Christopherson <seanjc@google.com>
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

Convert state_test to use vm_create_with_one_vcpu() and
vm_recreate_with_one_vcpu(), and pass around a 'struct kvm_vcpu' object
instead of using a global VCPU_ID.  Note, this is a "functional" change
in the sense that the test now creates a vCPU with vcpu_id==0 instead of
vcpu_id==5.  The non-zero VCPU_ID was 100% arbitrary and added little to
no validation coverage.  If testing non-zero vCPU IDs is desirable for
generic tests, that can be done in the future by tweaking the VM creation
helpers.

Opportunistically use vcpu_run() instead of _vcpu_run(), the test expects
KVM_RUN to succeed.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/x86_64/state_test.c | 29 +++++++++----------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/state_test.c b/tools/testing/selftests/kvm/x86_64/state_test.c
index 41f7faaef2ac..b7869efad22a 100644
--- a/tools/testing/selftests/kvm/x86_64/state_test.c
+++ b/tools/testing/selftests/kvm/x86_64/state_test.c
@@ -20,7 +20,6 @@
 #include "vmx.h"
 #include "svm_util.h"
 
-#define VCPU_ID		5
 #define L2_GUEST_STACK_SIZE 256
 
 void svm_l2_guest_code(void)
@@ -157,6 +156,7 @@ int main(int argc, char *argv[])
 	vm_vaddr_t nested_gva = 0;
 
 	struct kvm_regs regs1, regs2;
+	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	struct kvm_run *run;
 	struct kvm_x86_state *state;
@@ -164,10 +164,10 @@ int main(int argc, char *argv[])
 	int stage;
 
 	/* Create VM */
-	vm = vm_create_default(VCPU_ID, 0, guest_code);
-	run = vcpu_state(vm, VCPU_ID);
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+	run = vcpu->run;
 
-	vcpu_regs_get(vm, VCPU_ID, &regs1);
+	vcpu_regs_get(vm, vcpu->id, &regs1);
 
 	if (kvm_check_cap(KVM_CAP_NESTED_STATE)) {
 		if (nested_svm_supported())
@@ -179,16 +179,16 @@ int main(int argc, char *argv[])
 	if (!nested_gva)
 		pr_info("will skip nested state checks\n");
 
-	vcpu_args_set(vm, VCPU_ID, 1, nested_gva);
+	vcpu_args_set(vm, vcpu->id, 1, nested_gva);
 
 	for (stage = 1;; stage++) {
-		_vcpu_run(vm, VCPU_ID);
+		vcpu_run(vm, vcpu->id);
 		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
 			    "Stage %d: unexpected exit reason: %u (%s),\n",
 			    stage, run->exit_reason,
 			    exit_reason_str(run->exit_reason));
 
-		switch (get_ucall(vm, VCPU_ID, &uc)) {
+		switch (get_ucall(vm, vcpu->id, &uc)) {
 		case UCALL_ABORT:
 			TEST_FAIL("%s at %s:%ld", (const char *)uc.args[0],
 			       	  __FILE__, uc.args[1]);
@@ -206,22 +206,21 @@ int main(int argc, char *argv[])
 			    uc.args[1] == stage, "Stage %d: Unexpected register values vmexit, got %lx",
 			    stage, (ulong)uc.args[1]);
 
-		state = vcpu_save_state(vm, VCPU_ID);
+		state = vcpu_save_state(vm, vcpu->id);
 		memset(&regs1, 0, sizeof(regs1));
-		vcpu_regs_get(vm, VCPU_ID, &regs1);
+		vcpu_regs_get(vm, vcpu->id, &regs1);
 
 		kvm_vm_release(vm);
 
 		/* Restore state in a new VM.  */
-		kvm_vm_restart(vm);
-		vm_vcpu_add(vm, VCPU_ID);
-		vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
-		vcpu_load_state(vm, VCPU_ID, state);
-		run = vcpu_state(vm, VCPU_ID);
+		vcpu = vm_recreate_with_one_vcpu(vm);
+		vcpu_set_cpuid(vm, vcpu->id, kvm_get_supported_cpuid());
+		vcpu_load_state(vm, vcpu->id, state);
+		run = vcpu->run;
 		kvm_x86_state_cleanup(state);
 
 		memset(&regs2, 0, sizeof(regs2));
-		vcpu_regs_get(vm, VCPU_ID, &regs2);
+		vcpu_regs_get(vm, vcpu->id, &regs2);
 		TEST_ASSERT(!memcmp(&regs1, &regs2, sizeof(regs2)),
 			    "Unexpected register values after vcpu_load_state; rdi: %lx rsi: %lx",
 			    (ulong) regs2.rdi, (ulong) regs2.rsi);
-- 
2.36.0.464.gb9c8b46e94-goog

