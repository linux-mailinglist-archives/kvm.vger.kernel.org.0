Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 513BB53C27C
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240514AbiFCArg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:47:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240245AbiFCApm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:45:42 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 790613465F
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:45:32 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id q62-20020a17090a17c400b001e31a482241so3402230pja.5
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=n0X75eN6DrszINCse0yRpHllYbTU2FY/yc+Q7Pdy2AA=;
        b=Zcjf3Gf6se82i0HNPT6XV862ahrRriGS0XMbUwJLTbHpXIabKr5x0gV4uBKj/sIVEa
         diYsYzTrigWMDLyWewxIJoKexRjsrC2trZTxU5L4VSAzdU2bXh3iPyC2+MoaX8E2lhh4
         YEOIXovmeypY7X8NKWwC9cy1t0uB2uY25Dc4Byl2Yfebr9/81MkUQ8rXFogC3U59XlyD
         xu67nfycFOkeytGqy1PiY2Hy+sH65Rsar7p2MvWWlBXNr+3HTdjht/q77uu2ZPll4tM+
         RQ54S3TTTCIHtmUJcG5uSiVC0azvAPBQ3QBsUpVZbtQbw3VgTEXWJCqNJa/C1HGdwiRD
         xCDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=n0X75eN6DrszINCse0yRpHllYbTU2FY/yc+Q7Pdy2AA=;
        b=V8qDnNCeZ2FJ/0eIMkm5x65wFNP3hsW02Di0CE+msS6lXjevRG3DSbV1JcDODXJI9s
         obWsIvOer5wK4d0LrDUKSXTGoOUawiBApA/D9kkNS8kdpjLFIYeXvEZosWPKPuVdIiEA
         ev/FVrV5hiqmN8DVMsXXnHbZwRFOcdFuyk46e+9Ld/g/4lEywpo0lZUdAwnxVezFyP5+
         COPw9GV20NAI1fUwPkvhZn1/URHXWzahhqfaJzPIbYaIoz0CaQ/wway4bYAV92r2GSuL
         6iaxEWTlRw5eKFknrd1C8mDrvbRI8EyC+uh5Nuvv/kollMps/EjhABZr38gB/Rj9DUTS
         7wDQ==
X-Gm-Message-State: AOAM532T7fMEtMZ3kYICDYjANKzaqCL+Ukdl0Ru9ro5DOU9HSz3Xcx+K
        ac9D6E73OhtFqzbVnsSbuWHO7dd6EGc=
X-Google-Smtp-Source: ABdhPJzDDoou7C7GmLhv9avEpVVptrn0ArPsUPQ4koiw9o9GCyKVQTPfkF2Sw8oWegE9VgRcVDszwEZyAns=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:7282:b0:164:17f6:e36a with SMTP id
 d2-20020a170902728200b0016417f6e36amr7420631pll.139.1654217132000; Thu, 02
 Jun 2022 17:45:32 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:42:10 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-64-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 063/144] KVM: selftests: Convert sync_regs_test away from VCPU_ID
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
2.36.1.255.ge46751e96f-goog

