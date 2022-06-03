Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66FEE53C1D1
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240595AbiFCAtV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:49:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240486AbiFCArQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:47:16 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F2482251B
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:46:22 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d13-20020a170902728d00b001635c985770so3491305pll.2
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:46:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=j2oRGZTZJq9/J8cOVK5ZR5Y8duHKABzHS/no78jTUu0=;
        b=ezwTq0nlReZAbiIYygUSO9uf0DSEi1ZJ0NgO1SXT0H6ckrO/8DVUvYYZjAaakpdNni
         IE1oLCWcRpz/Zo3kf1SFSUwJBV6uftU2sKD0KVi/RTRszlYp/xFkgOSnvQP7fKLHAnMa
         +VWiyL47udXyHpUvWqRIa0RYQvnEkFoGNpQXaeZ56eaT5PzAxD69gu1TEPvJoYft9Xkd
         li6uZle95f4rwG1Xi0uSFygIu0dp8xaXdXGO2rYUZR5VEEkHxXa9McYvjuQ8cuEN+ku1
         Rr74BQoe+iDk/N52mFW3PACgv5ZUWPkFgDiJTCrsYWEz5nEfxf92bmzcMVgc2JotRxVa
         vIcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=j2oRGZTZJq9/J8cOVK5ZR5Y8duHKABzHS/no78jTUu0=;
        b=GEwVDuw3C5WpFQOfB7PKv22/q4ZmslmnPlTEt2X5S0oIemy/ljCzK5bwUwFiG/27PO
         UF/NeUky1PF0auoMFeqfs/WTRtbPN6aDtxqWJRnkjIHRF3NatozqGjZz3ESVXFhEUvbX
         CJGfOB6mTHRi7ogGk2IWMR8G5pJBxqC0pavJZf8HYHvN8wO6j6zLgsEKnA0DdxiDLMxt
         W2a0+xQ7OONH7Q1lb7z260Y7CxdG9Lh91XxE1Cb22mUcvv17jperXZ/OC4xbZt/veR8l
         Ziam4F+ywnM/LE10zm+IauKuri5Gwiv3yrQ7+cZGV9I7xgYg7LKnlihV/zMQsxzZK627
         MDMQ==
X-Gm-Message-State: AOAM533mHehyXEUKaqQDHLCtuNBYcMQSXcnD6gWrarsiCRfXtojXsq+L
        VwWpOuGFzQPbvX2qYSFjMMsmiHqGaTE=
X-Google-Smtp-Source: ABdhPJwL26iVzrX6K8Czn7FwNdZsPBShNdT2UcrtkNSyJxJuba62sr4QiXtrSVWZds8XjIjq+ZOVJu9OqAc=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2353:b0:518:96b7:ceb8 with SMTP id
 j19-20020a056a00235300b0051896b7ceb8mr7891151pfj.5.1654217181928; Thu, 02 Jun
 2022 17:46:21 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:42:38 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-92-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 091/144] KVM: selftests: Convert set_memory_region_test
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

Convert set_memory_region_test to use vm_create_with_one_vcpu() and pass
around a 'struct kvm_vcpu' object instead of using a global VCPU_ID.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/set_memory_region_test.c    | 36 +++++++++----------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
index c33402ba7587..1274bbb0e30b 100644
--- a/tools/testing/selftests/kvm/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c
@@ -17,8 +17,6 @@
 #include <kvm_util.h>
 #include <processor.h>
 
-#define VCPU_ID 0
-
 /*
  * s390x needs at least 1MB alignment, and the x86_64 MOVE/DELETE tests need a
  * 2MB sized and aligned region so that the initial region corresponds to
@@ -54,8 +52,8 @@ static inline uint64_t guest_spin_on_val(uint64_t spin_val)
 
 static void *vcpu_worker(void *data)
 {
-	struct kvm_vm *vm = data;
-	struct kvm_run *run;
+	struct kvm_vcpu *vcpu = data;
+	struct kvm_run *run = vcpu->run;
 	struct ucall uc;
 	uint64_t cmd;
 
@@ -64,13 +62,11 @@ static void *vcpu_worker(void *data)
 	 * which will occur if the guest attempts to access a memslot after it
 	 * has been deleted or while it is being moved .
 	 */
-	run = vcpu_state(vm, VCPU_ID);
-
 	while (1) {
-		vcpu_run(vm, VCPU_ID);
+		vcpu_run(vcpu->vm, vcpu->id);
 
 		if (run->exit_reason == KVM_EXIT_IO) {
-			cmd = get_ucall(vm, VCPU_ID, &uc);
+			cmd = get_ucall(vcpu->vm, vcpu->id, &uc);
 			if (cmd != UCALL_SYNC)
 				break;
 
@@ -113,13 +109,14 @@ static void wait_for_vcpu(void)
 	usleep(100000);
 }
 
-static struct kvm_vm *spawn_vm(pthread_t *vcpu_thread, void *guest_code)
+static struct kvm_vm *spawn_vm(struct kvm_vcpu **vcpu, pthread_t *vcpu_thread,
+			       void *guest_code)
 {
 	struct kvm_vm *vm;
 	uint64_t *hva;
 	uint64_t gpa;
 
-	vm = vm_create_default(VCPU_ID, 0, guest_code);
+	vm = vm_create_with_one_vcpu(vcpu, guest_code);
 
 	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS_THP,
 				    MEM_REGION_GPA, MEM_REGION_SLOT,
@@ -138,7 +135,7 @@ static struct kvm_vm *spawn_vm(pthread_t *vcpu_thread, void *guest_code)
 	hva = addr_gpa2hva(vm, MEM_REGION_GPA);
 	memset(hva, 0, 2 * 4096);
 
-	pthread_create(vcpu_thread, NULL, vcpu_worker, vm);
+	pthread_create(vcpu_thread, NULL, vcpu_worker, *vcpu);
 
 	/* Ensure the guest thread is spun up. */
 	wait_for_vcpu();
@@ -180,10 +177,11 @@ static void guest_code_move_memory_region(void)
 static void test_move_memory_region(void)
 {
 	pthread_t vcpu_thread;
+	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	uint64_t *hva;
 
-	vm = spawn_vm(&vcpu_thread, guest_code_move_memory_region);
+	vm = spawn_vm(&vcpu, &vcpu_thread, guest_code_move_memory_region);
 
 	hva = addr_gpa2hva(vm, MEM_REGION_GPA);
 
@@ -258,11 +256,12 @@ static void guest_code_delete_memory_region(void)
 static void test_delete_memory_region(void)
 {
 	pthread_t vcpu_thread;
+	struct kvm_vcpu *vcpu;
 	struct kvm_regs regs;
 	struct kvm_run *run;
 	struct kvm_vm *vm;
 
-	vm = spawn_vm(&vcpu_thread, guest_code_delete_memory_region);
+	vm = spawn_vm(&vcpu, &vcpu_thread, guest_code_delete_memory_region);
 
 	/* Delete the memory region, the guest should not die. */
 	vm_mem_region_delete(vm, MEM_REGION_SLOT);
@@ -286,13 +285,13 @@ static void test_delete_memory_region(void)
 
 	pthread_join(vcpu_thread, NULL);
 
-	run = vcpu_state(vm, VCPU_ID);
+	run = vcpu->run;
 
 	TEST_ASSERT(run->exit_reason == KVM_EXIT_SHUTDOWN ||
 		    run->exit_reason == KVM_EXIT_INTERNAL_ERROR,
 		    "Unexpected exit reason = %d", run->exit_reason);
 
-	vcpu_regs_get(vm, VCPU_ID, &regs);
+	vcpu_regs_get(vm, vcpu->id, &regs);
 
 	/*
 	 * On AMD, after KVM_EXIT_SHUTDOWN the VMCB has been reinitialized already,
@@ -309,18 +308,19 @@ static void test_delete_memory_region(void)
 
 static void test_zero_memory_regions(void)
 {
+	struct kvm_vcpu *vcpu;
 	struct kvm_run *run;
 	struct kvm_vm *vm;
 
 	pr_info("Testing KVM_RUN with zero added memory regions\n");
 
 	vm = vm_create_barebones();
-	vm_vcpu_add(vm, VCPU_ID);
+	vcpu = vm_vcpu_add(vm, 0);
 
 	vm_ioctl(vm, KVM_SET_NR_MMU_PAGES, (void *)64ul);
-	vcpu_run(vm, VCPU_ID);
+	vcpu_run(vm, vcpu->id);
 
-	run = vcpu_state(vm, VCPU_ID);
+	run = vcpu->run;
 	TEST_ASSERT(run->exit_reason == KVM_EXIT_INTERNAL_ERROR,
 		    "Unexpected exit_reason = %u\n", run->exit_reason);
 
-- 
2.36.1.255.ge46751e96f-goog

