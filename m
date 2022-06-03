Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E49AC53C314
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240386AbiFCAqi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240128AbiFCApP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:45:15 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 067F3344DC
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:45:14 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id i9-20020a632209000000b003facc62e253so3049492pgi.11
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:45:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=+oPASWeuU3hUXSHHGwTAX+AwNGMqvMpQnDYcauVC88g=;
        b=aj/VS9rYLAELO9VzDinP5b6wMBn+rIvp+yXI/U7HeJ0fNjcRXaG7lyXigFssnwyU7K
         h9QIczE6M9HxUVoUvuhT+T9Ie66vMaTJ60b86OedMv3ET7XKRUWh3GUmFVDkmWlR8L2v
         9Yr6MTtm6fzUrVH4Ry8wxPzmGlFWPJVmN6mkUQKEkty1zLYctJnj1wLjxuDCVkDdwlKI
         NjqEANCLc4o9c6yzpIRPXxEjcAtdMviHfBymR71whgVQdjeN1OCPe8mNFc2b1+NbxY5l
         H9qINqgMjzP5AVoCbKDARGxUWznxe6p4c8Lj7ynz01q+WNRFt8qQ2TF+uEyQ2aHgrdUN
         s4CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=+oPASWeuU3hUXSHHGwTAX+AwNGMqvMpQnDYcauVC88g=;
        b=28/2mH0njSrs+Xv5QXgMN9nkONdZgtH6Irwwhy0sjTv08TtBQ6P1SNFloJ/41leotS
         oD1WCkvCV4N87U4dnTKOLO6LPikaRxS+0b5CO3/mUuVwNjWaU/RkCd3YQvapDRJOfjlA
         c3dZFefg9RO+sKBYMaDYBv+c6xZPodOLrKgQynOT+5M7ypv5fVfPjuoACXbV8MF58Uyp
         I6df+2Uqih36xnAODREU4XmsGDOMnfcbgZmXsFktZeULakCtqVXzrm7QYKR2QozU7Ws6
         d2ex6ETYwcVfWTyWnLJD37J5GiQ5xSYoeKHZPxwPpEuEhk3WPHUni8Qqj6nH+oeid0+R
         eqYw==
X-Gm-Message-State: AOAM530U4IIeAjvKBzZFcQ3VieUwgWU8s1NeRU1WcDCBC75XPkfHwrTq
        p785N6KlN32MfbaQYWg15qFGq1W6oCw=
X-Google-Smtp-Source: ABdhPJy5wc0NNleg/ScIV/2JjbKLzyv1ivroioi4hwAipX9/EXBVV4qRjFNi+lysqMQ25q6GcJW9KJeJDh0=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1249:b0:518:c338:d4de with SMTP id
 u9-20020a056a00124900b00518c338d4demr7846952pfi.14.1654217113696; Thu, 02 Jun
 2022 17:45:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:42:00 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-54-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 053/144] KVM: selftests: Convert vmx_preemption_timer_test
 away from VCPU_ID
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

Convert vmx_preemption_timer_test to use vm_create_with_one_vcpu() and
pass around a 'struct kvm_vcpu' object instead of using a global VCPU_ID.
Note, this is a "functional" change in the sense that the test now
creates a vCPU with vcpu_id==0 instead of vcpu_id==5.  The non-zero
VCPU_ID was 100% arbitrary and added little to no validation coverage.
If testing non-zero vCPU IDs is desirable for generic tests, that can be
done in the future by tweaking the VM creation helpers.

Opportunistically use vcpu_run() instead of _vcpu_run(), the test expects
KVM_RUN to succeed.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../kvm/x86_64/vmx_preemption_timer_test.c    | 30 +++++++++----------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c b/tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c
index f5b4ae914131..168adc5b2272 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c
@@ -22,7 +22,6 @@
 #include "processor.h"
 #include "vmx.h"
 
-#define VCPU_ID		5
 #define PREEMPTION_TIMER_VALUE			100000000ull
 #define PREEMPTION_TIMER_VALUE_THRESHOLD1	 80000000ull
 
@@ -159,6 +158,7 @@ int main(int argc, char *argv[])
 	struct kvm_regs regs1, regs2;
 	struct kvm_vm *vm;
 	struct kvm_run *run;
+	struct kvm_vcpu *vcpu;
 	struct kvm_x86_state *state;
 	struct ucall uc;
 	int stage;
@@ -175,22 +175,22 @@ int main(int argc, char *argv[])
 	}
 
 	/* Create VM */
-	vm = vm_create_default(VCPU_ID, 0, guest_code);
-	run = vcpu_state(vm, VCPU_ID);
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+	run = vcpu->run;
 
-	vcpu_regs_get(vm, VCPU_ID, &regs1);
+	vcpu_regs_get(vm, vcpu->id, &regs1);
 
 	vcpu_alloc_vmx(vm, &vmx_pages_gva);
-	vcpu_args_set(vm, VCPU_ID, 1, vmx_pages_gva);
+	vcpu_args_set(vm, vcpu->id, 1, vmx_pages_gva);
 
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
@@ -232,22 +232,22 @@ int main(int argc, char *argv[])
 				stage, uc.args[4], uc.args[5]);
 		}
 
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
+
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

