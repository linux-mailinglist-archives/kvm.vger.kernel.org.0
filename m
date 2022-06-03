Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98EAA53C313
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240608AbiFCAra (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:47:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240104AbiFCApl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:45:41 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D306344F6
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:45:27 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id j15-20020a17090a738f00b001e345e429d2so3540461pjg.0
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:45:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=3+V17MeEPjvQg09WlN2EBYPY536bBdHzqlWlFeq99WM=;
        b=kVfh+vPHcGM1lNaIV0EGYJvz0D25wwuiua+OEiHcKV3KObeTffpxHa8OBQO/Bfvkvc
         YzziWeYKgfK6ltmIYp74F81H6q+y0Mj4nSOk8D67J70bx/dFA9aEHAmsFfbYJaK+ylpq
         sABxIuIK6LMLTAg8XylgHeurvSZwZQ9+X08FFv8lWsrxpiv6E+pL8xn7V3lqTRqbXpZ2
         Wm7lpWHOSVpbKUTm8SIMutG98dLlUMD1nhqaQG81c7ymhxTH8yWA2h4nxyagj1dLZXic
         9FYCO2gPgzqkg94EXDVvKvM7gHFGoADItYh1HTd6tP7qLb0d4ekTlxN/AGf2OEYOz2MM
         AnhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=3+V17MeEPjvQg09WlN2EBYPY536bBdHzqlWlFeq99WM=;
        b=AY18rLCez8jYwJruiBHvGV4FSO2Of1wtPMOlQxV+dH9k09zk1QHfDAzCA2cD4KhimO
         16/k2Wjkq3nGJKHHkMDYD/yzcL6Fl3v6Jk4/p1AT4/hKyrfZwyXY+aAxiC+0mjCYg0Il
         +QDNblMeCQ8LJ1lMTZJeDC+GBtbYdiLU3jBf+fJ96zCi2ZpxF9bS+hbpAR6NQxGsE+/m
         DrmEZC0nxLlHD47lRg7l+7r2lrcM9RCfAF7uLsUNIz4Y29luBMJRGjjMWShL/Ky7EWUq
         fKVFgYRj+nh6yIXgjz1Nkt5W/Bh4QdHkN/qbZ3Yq/eUtUMXmyErEEFh3GjN/wKxJddO/
         1RmQ==
X-Gm-Message-State: AOAM530ibjlShpLG5EqkXOIqrzBC5gATKpoxcrz9kjszSfUKPmINPYjh
        po6btx5PyxiVOjcmgq+5KX60y1DMC28=
X-Google-Smtp-Source: ABdhPJw4kln2CObNdfF++iT6Gp4BzDVa0eaG40S1Zj/G7HIetNH3tHqf3rRmZXs3DQz04oj6BdR5MG+fZr4=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1ad2:b0:51b:c63b:95f0 with SMTP id
 f18-20020a056a001ad200b0051bc63b95f0mr6460313pfv.16.1654217126547; Thu, 02
 Jun 2022 17:45:26 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:42:07 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-61-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 060/144] KVM: selftests: Convert state_test away from VCPU_ID
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
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
2.36.1.255.ge46751e96f-goog

