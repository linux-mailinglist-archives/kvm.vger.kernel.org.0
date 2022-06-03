Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C63C753C293
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbiFCAyP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:54:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240457AbiFCArQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:47:16 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B308937A9B
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:46:11 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id b20-20020a62a114000000b0050a6280e374so3492499pff.13
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:46:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=WF5qzFDeqIEWa86v1LicyVxoQ5Cw0jH/nlR0HHTYVu8=;
        b=Om0SvO4L2MbNVuvMOTZWrGctVCApQTx9G5pDWZx8p8VDodHaYjS3Izy6Bm+VpoqD4J
         +6V2zd32Nqdd99j/FfnLnttlZ51vp+rcZBRw6CI4dizYTtGmRrFChuFiRpQnbWk2uF3S
         +beRu3DvAPwMhNIQfup3OjHYxXDJPLJkj/J7S6Fvuv3wNUQM4zkdjBEbQrDFqIf1fwmM
         pU+gZgxFoMzHIP0ypfUELZ2OjayiF+yJ58MdoY3fOsklKxW9dnNJb7g8X0Sy5U1ez5uo
         hynyhvv+O2DOnAJZqZq5eYDjNmgJvc4JnW0iRZKgT2zOcqp7VnLu27TFxEcyd9H4yHeC
         lPmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=WF5qzFDeqIEWa86v1LicyVxoQ5Cw0jH/nlR0HHTYVu8=;
        b=P/u0Nn1UrHVS9+lyuTYR+x6SC/kBR58B5bjos/PJmWorW1WuhiLvIuZIL5JuVQZPV8
         anSWYjVliFiEFnJ7X19vrP1nXmO03bsXqGtShz7H7I/rRKOmuopWy5PvsnJiiYlcGacq
         hMh18CSJoHDdgLYf4J6ofLPaHHA+TDdBTJq2WwHHqrqNEzS9nk1vf7YMUAXly/eVEQGh
         9pFKpqzykXOlgNOp9AoO9PqW9fZwEF6XnMfMtnO9imVIrILuvIKTq3G6ApL8IM58loze
         2tesIImdasNykMfcc/xllzJHYL6y11B16INwN5wyZou1ErOcH+DSXsyMSwrYsd804oR8
         qKjw==
X-Gm-Message-State: AOAM531HSnF2Z6N5UsukOMCsTidJBnbbBmRMa1YT/4UuPS1fn4TRAwo5
        FI7RXV5LcHJP0UNNcEyjiT8CeH3eFTI=
X-Google-Smtp-Source: ABdhPJztn1c9mfgPxl4oVU72UqypNLIv2LquW9Jz/fgKJ2OjLT8gPAPlh4dfITtGjBf/aWJNwy9pYCx9baA=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1a94:b0:518:b331:fbcf with SMTP id
 e20-20020a056a001a9400b00518b331fbcfmr7724539pfv.85.1654217171189; Thu, 02
 Jun 2022 17:46:11 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:42:32 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-86-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 085/144] KVM: selftests: Convert cpuid_test away from VCPU_ID
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

Convert cpuid_test to use vm_create_with_one_vcpu() and pass around a
'struct kvm_vcpu' object instead of using a global VCPU_ID.

Opportunistically use vcpu_run() instead of _vcpu_run(), the test expects
KVM_RUN to succeed.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/x86_64/cpuid_test.c | 29 +++++++++----------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/cpuid_test.c b/tools/testing/selftests/kvm/x86_64/cpuid_test.c
index 16d2465c5634..76cdd0d10757 100644
--- a/tools/testing/selftests/kvm/x86_64/cpuid_test.c
+++ b/tools/testing/selftests/kvm/x86_64/cpuid_test.c
@@ -12,8 +12,6 @@
 #include "kvm_util.h"
 #include "processor.h"
 
-#define VCPU_ID 0
-
 /* CPUIDs known to differ */
 struct {
 	u32 function;
@@ -118,13 +116,13 @@ static void compare_cpuids(struct kvm_cpuid2 *cpuid1, struct kvm_cpuid2 *cpuid2)
 		check_cpuid(cpuid1, &cpuid2->entries[i]);
 }
 
-static void run_vcpu(struct kvm_vm *vm, uint32_t vcpuid, int stage)
+static void run_vcpu(struct kvm_vcpu *vcpu, int stage)
 {
 	struct ucall uc;
 
-	_vcpu_run(vm, vcpuid);
+	vcpu_run(vcpu->vm, vcpu->id);
 
-	switch (get_ucall(vm, vcpuid, &uc)) {
+	switch (get_ucall(vcpu->vm, vcpu->id, &uc)) {
 	case UCALL_SYNC:
 		TEST_ASSERT(!strcmp((const char *)uc.args[0], "hello") &&
 			    uc.args[1] == stage + 1,
@@ -138,7 +136,7 @@ static void run_vcpu(struct kvm_vm *vm, uint32_t vcpuid, int stage)
 			    __FILE__, uc.args[1], uc.args[2], uc.args[3]);
 	default:
 		TEST_ASSERT(false, "Unexpected exit: %s",
-			    exit_reason_str(vcpu_state(vm, vcpuid)->exit_reason));
+			    exit_reason_str(vcpu->run->exit_reason));
 	}
 }
 
@@ -154,21 +152,21 @@ struct kvm_cpuid2 *vcpu_alloc_cpuid(struct kvm_vm *vm, vm_vaddr_t *p_gva, struct
 	return guest_cpuids;
 }
 
-static void set_cpuid_after_run(struct kvm_vm *vm, struct kvm_cpuid2 *cpuid)
+static void set_cpuid_after_run(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid)
 {
 	struct kvm_cpuid_entry2 *ent;
 	int rc;
 	u32 eax, ebx, x;
 
 	/* Setting unmodified CPUID is allowed */
-	rc = __vcpu_set_cpuid(vm, VCPU_ID, cpuid);
+	rc = __vcpu_set_cpuid(vcpu->vm, vcpu->id, cpuid);
 	TEST_ASSERT(!rc, "Setting unmodified CPUID after KVM_RUN failed: %d", rc);
 
 	/* Changing CPU features is forbidden */
 	ent = get_cpuid(cpuid, 0x7, 0);
 	ebx = ent->ebx;
 	ent->ebx--;
-	rc = __vcpu_set_cpuid(vm, VCPU_ID, cpuid);
+	rc = __vcpu_set_cpuid(vcpu->vm, vcpu->id, cpuid);
 	TEST_ASSERT(rc, "Changing CPU features should fail");
 	ent->ebx = ebx;
 
@@ -177,7 +175,7 @@ static void set_cpuid_after_run(struct kvm_vm *vm, struct kvm_cpuid2 *cpuid)
 	eax = ent->eax;
 	x = eax & 0xff;
 	ent->eax = (eax & ~0xffu) | (x - 1);
-	rc = __vcpu_set_cpuid(vm, VCPU_ID, cpuid);
+	rc = __vcpu_set_cpuid(vcpu->vm, vcpu->id, cpuid);
 	TEST_ASSERT(rc, "Changing MAXPHYADDR should fail");
 	ent->eax = eax;
 }
@@ -185,25 +183,26 @@ static void set_cpuid_after_run(struct kvm_vm *vm, struct kvm_cpuid2 *cpuid)
 int main(void)
 {
 	struct kvm_cpuid2 *supp_cpuid, *cpuid2;
+	struct kvm_vcpu *vcpu;
 	vm_vaddr_t cpuid_gva;
 	struct kvm_vm *vm;
 	int stage;
 
-	vm = vm_create_default(VCPU_ID, 0, guest_main);
+	vm = vm_create_with_one_vcpu(&vcpu, guest_main);
 
 	supp_cpuid = kvm_get_supported_cpuid();
-	cpuid2 = vcpu_get_cpuid(vm, VCPU_ID);
+	cpuid2 = vcpu_get_cpuid(vm, vcpu->id);
 
 	compare_cpuids(supp_cpuid, cpuid2);
 
 	vcpu_alloc_cpuid(vm, &cpuid_gva, cpuid2);
 
-	vcpu_args_set(vm, VCPU_ID, 1, cpuid_gva);
+	vcpu_args_set(vm, vcpu->id, 1, cpuid_gva);
 
 	for (stage = 0; stage < 3; stage++)
-		run_vcpu(vm, VCPU_ID, stage);
+		run_vcpu(vcpu, stage);
 
-	set_cpuid_after_run(vm, cpuid2);
+	set_cpuid_after_run(vcpu, cpuid2);
 
 	kvm_vm_free(vm);
 }
-- 
2.36.1.255.ge46751e96f-goog

