Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC39553C28A
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240696AbiFCA5l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:57:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240666AbiFCAtk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:49:40 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A406524084
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:47:06 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id o18-20020a63fb12000000b003fb22d1c6a0so3044191pgh.12
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:47:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=w2AyEzcBMjLc5ThroQYSL3RWFCTuJPRZmNCz6Ggfxlg=;
        b=HqnRzKbGGG9eUVwub+6PED0m2IoSC2+3mfKWuV9qbGnSH0hIUBxP9deaNhjBEPPhmy
         oCtMva5q5zFtPOCF64UsfhL1lxBeLIgGVacu4/52gOB17T78DdjIm1GNazyAV7jmRLCl
         kixoBXegQJngkk+LvHBD0NPKkEdMz5qVlmi0U3roM4qvut8U7ROD2nspgRM0LoD0DL01
         dFCkBR2unrvTd28Bk47rgREatKe5I47CoyFrVmV9anVl5sg0FRp2F3TvY+cUIFvFBS4t
         mi19owyQCrsMKJbLzz0pDgAi3lDony9YhMIxs0FbmNNODQxMazP0UG9qvtz6Alg8Nv3/
         pxlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=w2AyEzcBMjLc5ThroQYSL3RWFCTuJPRZmNCz6Ggfxlg=;
        b=QOBgQkJ5q/94yBaSpDqb329wgCsAf0kh9/ir0Nf5glr3qUuYz1g4M+FW1sT9FeZ+Vc
         n0y9SmwLvckynV2B8gZp+0ya+/2/SbN8iI+z42bSeNrZGv7zbDrVV7j04f5skPQP67Y/
         cfJfvkpTjTjb7Hw/HY6GK3zuUc9NtuG8dEUsPri3+8QnaX7i4zqjZV1D5spg+RQGO8N2
         Q4HaLNJtdhHMU2iZtH9lPnMeYmRsKFMlH1/8tCdkqSyqT8pfoWNGKSUZHQYTbwc2wksg
         S4A0j82Mddp9oweESj9Lr4oW3emXGMseKx7piS3Q5a0OlK2b8vHdy9oWoS7zmuIZ9oJR
         xk2g==
X-Gm-Message-State: AOAM530BYOlTaWUqZbWQeydayo6EXacsubrfSxsXiBcDQhdluXP1mLrv
        QU5Ruqd0z+/DD/12m5QRTUOy6grdG4E=
X-Google-Smtp-Source: ABdhPJwGf2IjFqoBYzy72CXSw8pZO8BluH9ukSAArTU8S6IZuIRc6c82IiI8qCRqMhwINDeJm1fEWUtHaQY=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:903:130d:b0:164:17f5:9de5 with SMTP id
 iy13-20020a170903130d00b0016417f59de5mr7870605plb.132.1654217225617; Thu, 02
 Jun 2022 17:47:05 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:43:03 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-117-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 116/144] KVM: selftests: Convert sync_regs_test away from VCPU_ID
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Convert sync_regs_test to use vm_create_with_vcpus() and pass around a
'struct kvm_vcpu' object instead of passing around vCPU IDs.  Note, this
is a "functional" change in the sense that the test now creates a vCPU
with vcpu_id==0 instead of vcpu_id==5.  The non-zero VCPU_ID was 100%
arbitrary and added little to no validation coverage.  If testing
non-zero vCPU IDs is desirable for generic tests, that can be done in the
future by tweaking the VM creation helpers.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/s390x/sync_regs_test.c      | 37 +++++++++----------
 1 file changed, 18 insertions(+), 19 deletions(-)

diff --git a/tools/testing/selftests/kvm/s390x/sync_regs_test.c b/tools/testing/selftests/kvm/s390x/sync_regs_test.c
index caf7b8859a94..bf52cabeaed6 100644
--- a/tools/testing/selftests/kvm/s390x/sync_regs_test.c
+++ b/tools/testing/selftests/kvm/s390x/sync_regs_test.c
@@ -22,8 +22,6 @@
 #include "kvm_util.h"
 #include "diag318_test_handler.h"
 
-#define VCPU_ID 5
-
 static void guest_code(void)
 {
 	/*
@@ -76,6 +74,7 @@ static void compare_sregs(struct kvm_sregs *left, struct kvm_sync_regs *right)
 
 int main(int argc, char *argv[])
 {
+	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	struct kvm_run *run;
 	struct kvm_regs regs;
@@ -92,43 +91,43 @@ int main(int argc, char *argv[])
 	}
 
 	/* Create VM */
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
 	run->kvm_valid_regs = TEST_SYNC_FIELDS;
-	rv = _vcpu_run(vm, VCPU_ID);
+	rv = _vcpu_run(vm, vcpu->id);
 	TEST_ASSERT(rv == 0, "vcpu_run failed: %d\n", rv);
 	TEST_ASSERT(run->exit_reason == KVM_EXIT_S390_SIEIC,
 		    "Unexpected exit reason: %u (%s)\n",
@@ -141,10 +140,10 @@ int main(int argc, char *argv[])
 		    run->s390_sieic.icptcode, run->s390_sieic.ipa,
 		    run->s390_sieic.ipb);
 
-	vcpu_regs_get(vm, VCPU_ID, &regs);
+	vcpu_regs_get(vm, vcpu->id, &regs);
 	compare_regs(&regs, &run->s.regs);
 
-	vcpu_sregs_get(vm, VCPU_ID, &sregs);
+	vcpu_sregs_get(vm, vcpu->id, &sregs);
 	compare_sregs(&sregs, &run->s.regs);
 
 	/* Set and verify various register values */
@@ -159,7 +158,7 @@ int main(int argc, char *argv[])
 		run->kvm_dirty_regs |= KVM_SYNC_DIAG318;
 	}
 
-	rv = _vcpu_run(vm, VCPU_ID);
+	rv = _vcpu_run(vm, vcpu->id);
 	TEST_ASSERT(rv == 0, "vcpu_run failed: %d\n", rv);
 	TEST_ASSERT(run->exit_reason == KVM_EXIT_S390_SIEIC,
 		    "Unexpected exit reason: %u (%s)\n",
@@ -175,10 +174,10 @@ int main(int argc, char *argv[])
 		    "diag318 sync regs value incorrect 0x%llx.",
 		    run->s.regs.diag318);
 
-	vcpu_regs_get(vm, VCPU_ID, &regs);
+	vcpu_regs_get(vm, vcpu->id, &regs);
 	compare_regs(&regs, &run->s.regs);
 
-	vcpu_sregs_get(vm, VCPU_ID, &sregs);
+	vcpu_sregs_get(vm, vcpu->id, &sregs);
 	compare_sregs(&sregs, &run->s.regs);
 
 	/* Clear kvm_dirty_regs bits, verify new s.regs values are
@@ -188,7 +187,7 @@ int main(int argc, char *argv[])
 	run->kvm_dirty_regs = 0;
 	run->s.regs.gprs[11] = 0xDEADBEEF;
 	run->s.regs.diag318 = 0x4B1D;
-	rv = _vcpu_run(vm, VCPU_ID);
+	rv = _vcpu_run(vm, vcpu->id);
 	TEST_ASSERT(rv == 0, "vcpu_run failed: %d\n", rv);
 	TEST_ASSERT(run->exit_reason == KVM_EXIT_S390_SIEIC,
 		    "Unexpected exit reason: %u (%s)\n",
-- 
2.36.1.255.ge46751e96f-goog

