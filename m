Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9522551B34D
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 01:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379529AbiEDW4M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 18:56:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379436AbiEDWyy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:54:54 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DCBA53B75
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:51:06 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id d64-20020a17090a6f4600b001da3937032fso3565195pjk.5
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=OWG5SLItV7LvwK0/+ikCwsRpvTwxCQso8sF2TQ8YEnM=;
        b=ZKmlmJzgZ4JzKhUTbhH/I23KY5Z5b9VMBKo2xMRFMz4DyZYFE1KeNik9OF9C1kIfOb
         C+wkpKW+2XJK1OpC6JaSAJO6mW3VZWzjjuyhBz/AmD6unr6E61RtFbMe0UI7Iz2QkXN+
         LmD8WqRwtRxB1GK4S1OFQhAmIpkUWwsUDf1s2xN3P5+68+CUeVVsfCmBjOozHroon29H
         1H+4vGaQn+fVH9X+1U/Niartr7vBgEcUKjLD8oy7Z/QSL0U3yTaLckillZxtgS4FukTD
         dJDGhsCJZzuwcX3CjlFQsca7aPq4I65JIb8V6lx7qdmNFC1XkrYlKQdmesliekVCi+tL
         iIGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=OWG5SLItV7LvwK0/+ikCwsRpvTwxCQso8sF2TQ8YEnM=;
        b=wkiM7dnPhY9F1KttzpuzqazqSQGFM77FMeYabyxvxE1GVC2bvzsucVCY8xzMzhD4YN
         myGQIfSJkGFEq9R77f2j/mWa2jG6CT3F6p/0mqi4Pp5jMSkDqvESS7OBpICyhCwSC1wq
         K3LRBSzLe6gshgrSi1BFRknLO//PXG953LmL48H7620FZSkQDuvyTqwzPMLlRkjfJ39D
         KFV4qODJSXc1yjF9Cc99EOsJrg3cpn1vfN524c2F6QsoxYmss2HfTeUxjhn3JmImBasO
         kJ0Sokp1KmzRDBWn4NllB5LM+x4a9FntgQQYAruC0WTNCvzgp2chzSeCChMpFKv26BBs
         EmGg==
X-Gm-Message-State: AOAM530Z5G0w3DymG6juAMSHPxi6t4HPwC8EkwtKvuJiEn7odyk+L1XF
        xfHM4dkCsxgoHw/tzqYx83CXXzSorsw=
X-Google-Smtp-Source: ABdhPJxQ8JxwciwXyutSnLiak0iPf/I4/7Pb7TMZbIng41hMdouKE1AZNzAS3U3i4cka2H01LwsrA/ZjdLs=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:aa7:8892:0:b0:50e:1463:3cd1 with SMTP id
 z18-20020aa78892000000b0050e14633cd1mr8550029pfe.13.1651704665764; Wed, 04
 May 2022 15:51:05 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:48:01 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-56-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 055/128] KVM: selftests: Convert sync_regs_test away from VCPU_ID
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

Convert sync_regs_test to use vm_create_with_one_vcpu() and pass around
a 'struct kvm_vcpu' object instead of using a global VCPU_ID.  Note, this
is a "functional" change in the sense that the test now creates a vCPU
with vcpu_id==0 instead of vcpu_id==5.  The non-zero VCPU_ID was 100%
arbitrary and added little to no validation coverage.  If testing
non-zero vCPU IDs is desirable for generic tests, that can be
done in the future by tweaking the VM creation helpers.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/sync_regs_test.c     | 52 +++++++++----------
 1 file changed, 25 insertions(+), 27 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/sync_regs_test.c b/tools/testing/selftests/kvm/x86_64/sync_regs_test.c
index fc03a150278d..c971706b49f5 100644
--- a/tools/testing/selftests/kvm/x86_64/sync_regs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/sync_regs_test.c
@@ -20,8 +20,6 @@
 #include "kvm_util.h"
 #include "processor.h"
 
-#define VCPU_ID 5
-
 #define UCALL_PIO_PORT ((uint16_t)0x1000)
 
 struct ucall uc_none = {
@@ -84,6 +82,7 @@ static void compare_vcpu_events(struct kvm_vcpu_events *left,
 
 int main(int argc, char *argv[])
 {
+	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	struct kvm_run *run;
 	struct kvm_regs regs;
@@ -104,57 +103,56 @@ int main(int argc, char *argv[])
 		exit(KSFT_SKIP);
 	}
 
-	/* Create VM */
-	vm = vm_create_default(VCPU_ID, 0, guest_code);
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 
-	run = vcpu_state(vm, VCPU_ID);
+	run = vcpu->run;
 
 	/* Request reading invalid register set from VCPU. */
 	run->kvm_valid_regs = INVALID_SYNC_FIELD;
-	rv = _vcpu_run(vm, VCPU_ID);
+	rv = _vcpu_run(vm, vcpu->id);
 	TEST_ASSERT(rv < 0 && errno == EINVAL,
 		    "Invalid kvm_valid_regs did not cause expected KVM_RUN error: %d\n",
 		    rv);
-	vcpu_state(vm, VCPU_ID)->kvm_valid_regs = 0;
+	run->kvm_valid_regs = 0;
 
 	run->kvm_valid_regs = INVALID_SYNC_FIELD | TEST_SYNC_FIELDS;
-	rv = _vcpu_run(vm, VCPU_ID);
+	rv = _vcpu_run(vm, vcpu->id);
 	TEST_ASSERT(rv < 0 && errno == EINVAL,
 		    "Invalid kvm_valid_regs did not cause expected KVM_RUN error: %d\n",
 		    rv);
-	vcpu_state(vm, VCPU_ID)->kvm_valid_regs = 0;
+	run->kvm_valid_regs = 0;
 
 	/* Request setting invalid register set into VCPU. */
 	run->kvm_dirty_regs = INVALID_SYNC_FIELD;
-	rv = _vcpu_run(vm, VCPU_ID);
+	rv = _vcpu_run(vm, vcpu->id);
 	TEST_ASSERT(rv < 0 && errno == EINVAL,
 		    "Invalid kvm_dirty_regs did not cause expected KVM_RUN error: %d\n",
 		    rv);
-	vcpu_state(vm, VCPU_ID)->kvm_dirty_regs = 0;
+	run->kvm_dirty_regs = 0;
 
 	run->kvm_dirty_regs = INVALID_SYNC_FIELD | TEST_SYNC_FIELDS;
-	rv = _vcpu_run(vm, VCPU_ID);
+	rv = _vcpu_run(vm, vcpu->id);
 	TEST_ASSERT(rv < 0 && errno == EINVAL,
 		    "Invalid kvm_dirty_regs did not cause expected KVM_RUN error: %d\n",
 		    rv);
-	vcpu_state(vm, VCPU_ID)->kvm_dirty_regs = 0;
+	run->kvm_dirty_regs = 0;
 
 	/* Request and verify all valid register sets. */
 	/* TODO: BUILD TIME CHECK: TEST_ASSERT(KVM_SYNC_X86_NUM_FIELDS != 3); */
 	run->kvm_valid_regs = TEST_SYNC_FIELDS;
-	rv = _vcpu_run(vm, VCPU_ID);
+	rv = _vcpu_run(vm, vcpu->id);
 	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
 		    "Unexpected exit reason: %u (%s),\n",
 		    run->exit_reason,
 		    exit_reason_str(run->exit_reason));
 
-	vcpu_regs_get(vm, VCPU_ID, &regs);
+	vcpu_regs_get(vm, vcpu->id, &regs);
 	compare_regs(&regs, &run->s.regs.regs);
 
-	vcpu_sregs_get(vm, VCPU_ID, &sregs);
+	vcpu_sregs_get(vm, vcpu->id, &sregs);
 	compare_sregs(&sregs, &run->s.regs.sregs);
 
-	vcpu_events_get(vm, VCPU_ID, &events);
+	vcpu_events_get(vm, vcpu->id, &events);
 	compare_vcpu_events(&events, &run->s.regs.events);
 
 	/* Set and verify various register values. */
@@ -164,7 +162,7 @@ int main(int argc, char *argv[])
 
 	run->kvm_valid_regs = TEST_SYNC_FIELDS;
 	run->kvm_dirty_regs = KVM_SYNC_X86_REGS | KVM_SYNC_X86_SREGS;
-	rv = _vcpu_run(vm, VCPU_ID);
+	rv = _vcpu_run(vm, vcpu->id);
 	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
 		    "Unexpected exit reason: %u (%s),\n",
 		    run->exit_reason,
@@ -176,13 +174,13 @@ int main(int argc, char *argv[])
 		    "apic_base sync regs value incorrect 0x%llx.",
 		    run->s.regs.sregs.apic_base);
 
-	vcpu_regs_get(vm, VCPU_ID, &regs);
+	vcpu_regs_get(vm, vcpu->id, &regs);
 	compare_regs(&regs, &run->s.regs.regs);
 
-	vcpu_sregs_get(vm, VCPU_ID, &sregs);
+	vcpu_sregs_get(vm, vcpu->id, &sregs);
 	compare_sregs(&sregs, &run->s.regs.sregs);
 
-	vcpu_events_get(vm, VCPU_ID, &events);
+	vcpu_events_get(vm, vcpu->id, &events);
 	compare_vcpu_events(&events, &run->s.regs.events);
 
 	/* Clear kvm_dirty_regs bits, verify new s.regs values are
@@ -191,7 +189,7 @@ int main(int argc, char *argv[])
 	run->kvm_valid_regs = TEST_SYNC_FIELDS;
 	run->kvm_dirty_regs = 0;
 	run->s.regs.regs.rbx = 0xDEADBEEF;
-	rv = _vcpu_run(vm, VCPU_ID);
+	rv = _vcpu_run(vm, vcpu->id);
 	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
 		    "Unexpected exit reason: %u (%s),\n",
 		    run->exit_reason,
@@ -208,8 +206,8 @@ int main(int argc, char *argv[])
 	run->kvm_dirty_regs = 0;
 	run->s.regs.regs.rbx = 0xAAAA;
 	regs.rbx = 0xBAC0;
-	vcpu_regs_set(vm, VCPU_ID, &regs);
-	rv = _vcpu_run(vm, VCPU_ID);
+	vcpu_regs_set(vm, vcpu->id, &regs);
+	rv = _vcpu_run(vm, vcpu->id);
 	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
 		    "Unexpected exit reason: %u (%s),\n",
 		    run->exit_reason,
@@ -217,7 +215,7 @@ int main(int argc, char *argv[])
 	TEST_ASSERT(run->s.regs.regs.rbx == 0xAAAA,
 		    "rbx sync regs value incorrect 0x%llx.",
 		    run->s.regs.regs.rbx);
-	vcpu_regs_get(vm, VCPU_ID, &regs);
+	vcpu_regs_get(vm, vcpu->id, &regs);
 	TEST_ASSERT(regs.rbx == 0xBAC0 + 1,
 		    "rbx guest value incorrect 0x%llx.",
 		    regs.rbx);
@@ -229,7 +227,7 @@ int main(int argc, char *argv[])
 	run->kvm_valid_regs = 0;
 	run->kvm_dirty_regs = TEST_SYNC_FIELDS;
 	run->s.regs.regs.rbx = 0xBBBB;
-	rv = _vcpu_run(vm, VCPU_ID);
+	rv = _vcpu_run(vm, vcpu->id);
 	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
 		    "Unexpected exit reason: %u (%s),\n",
 		    run->exit_reason,
@@ -237,7 +235,7 @@ int main(int argc, char *argv[])
 	TEST_ASSERT(run->s.regs.regs.rbx == 0xBBBB,
 		    "rbx sync regs value incorrect 0x%llx.",
 		    run->s.regs.regs.rbx);
-	vcpu_regs_get(vm, VCPU_ID, &regs);
+	vcpu_regs_get(vm, vcpu->id, &regs);
 	TEST_ASSERT(regs.rbx == 0xBBBB + 1,
 		    "rbx guest value incorrect 0x%llx.",
 		    regs.rbx);
-- 
2.36.0.464.gb9c8b46e94-goog

