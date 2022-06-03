Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA8EE53C301
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240495AbiFCAtH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:49:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240478AbiFCArQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:47:16 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B75CF37AAB
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:46:20 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id c4-20020a170902c2c400b0015f16fb4a54so3467225pla.22
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:46:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=CDG0Dqql0smjKxVHjhP7E2fId6LbaVT+ZKrP8G595LI=;
        b=lZPStq/q39E0gbEm18tiwJMx8Ded2JvdcBry6TyFOy/ryZJWOjTcZ2lgqop85bOQFG
         2bjaHoCMv5ZxSpxzhfzSNgR+J93R1NGrYT6IQB/IhZAJPQHNg1Cy++HoksT/Ii00LBVa
         Si7X+WafczJ1bsAQBm2P0NX0PTqsgnOS7OZ9I/UFTFPj2aFlScqj8zWRiFsAlQqazSGG
         dP0EfzSubjVDr9qewrAxxCV71e8fMHSMUJCVfPlH+cdDBFbc8e7x/PuUEgiQo8EvSC3l
         EIZPWvre1U1Y9Q97nQ/s2ZBak5bqPU5QBPB/K2+PlojkTn2uwUvuPTn9b7IqXx0oue/Q
         jF8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=CDG0Dqql0smjKxVHjhP7E2fId6LbaVT+ZKrP8G595LI=;
        b=Br6A2IJXoDrQyWUGdhRDVMDt6ks3MzmWtYB3DSKU9Fnet/RfmwDF6SRCd1JHLMMFKO
         6WhhoufawOzz1fLaJjYJ46mTJGGUgskEeFDfUKQwoEHYn67iOe43IQd48/9uwxPBh9F3
         kTOnyR93V7VOf0VipUXMjldZWZXH6uksNrouhXXMtToVWXCCKWAiFHFsrP7L4Sg+uFA6
         7f+PMCKwHM9e1ue0T5SRRSoibQVWeiEVQUEGQ3F0cKD/2HL9nhuHoPKzUupifvF4/vhy
         BOuLTRD/4tTotLBtQzX5ijeQR1kPhjTF+9uFibd5mjCvECdDe7UL6MHwaV6FBNST3NiD
         ppSw==
X-Gm-Message-State: AOAM533GhukE3aohgEimNO69Lv4Jv0+mEQRQj5iYZpg/TbSx6APRn8o7
        xifVK8qn+lXNorlIe+X8Q77rZhUpSTg=
X-Google-Smtp-Source: ABdhPJz8TTOWujrLx+6Z8bVI33qd+9KUF9zLVfnp6OsoxHnBG7R1MNHjorTJWj0IRZ6zhL8r0xnU+TLgs/0=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:178f:b0:1e3:3ba:c185 with SMTP id
 q15-20020a17090a178f00b001e303bac185mr305582pja.1.1654217179810; Thu, 02 Jun
 2022 17:46:19 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:42:37 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-91-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 090/144] KVM: selftests: Convert dirty_log_test away from VCPU_ID
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

Convert dirty_log_test to pass around a 'struct kvm_vcpu' object instead
of using a global VCPU_ID.  Note, this is a "functional" change in the
sense that the test now creates a vCPU with vcpu_id==0 instead of
vcpu_id==5.  The non-zero VCPU_ID was 100% arbitrary and added little to
no validation coverage.  If testing non-zero vCPU IDs is desirable for
generic tests, that can be done in the future by tweaking the VM creation
helpers.

The test still hardcodes usage of vcpu_id==0, but only for a few lines.
That wart will be removed in the not-too-distant future.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 59 ++++++++++----------
 1 file changed, 30 insertions(+), 29 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index cf426a8ae816..23e0c727e375 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -23,8 +23,6 @@
 #include "guest_modes.h"
 #include "processor.h"
 
-#define VCPU_ID				1
-
 /* The memory slot index to track dirty pages */
 #define TEST_MEM_SLOT_INDEX		1
 
@@ -226,17 +224,17 @@ static void clear_log_create_vm_done(struct kvm_vm *vm)
 	vm_enable_cap(vm, KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2, manual_caps);
 }
 
-static void dirty_log_collect_dirty_pages(struct kvm_vm *vm, int slot,
+static void dirty_log_collect_dirty_pages(struct kvm_vcpu *vcpu, int slot,
 					  void *bitmap, uint32_t num_pages)
 {
-	kvm_vm_get_dirty_log(vm, slot, bitmap);
+	kvm_vm_get_dirty_log(vcpu->vm, slot, bitmap);
 }
 
-static void clear_log_collect_dirty_pages(struct kvm_vm *vm, int slot,
+static void clear_log_collect_dirty_pages(struct kvm_vcpu *vcpu, int slot,
 					  void *bitmap, uint32_t num_pages)
 {
-	kvm_vm_get_dirty_log(vm, slot, bitmap);
-	kvm_vm_clear_dirty_log(vm, slot, bitmap, 0, num_pages);
+	kvm_vm_get_dirty_log(vcpu->vm, slot, bitmap);
+	kvm_vm_clear_dirty_log(vcpu->vm, slot, bitmap, 0, num_pages);
 }
 
 /* Should only be called after a GUEST_SYNC */
@@ -250,14 +248,14 @@ static void vcpu_handle_sync_stop(void)
 	}
 }
 
-static void default_after_vcpu_run(struct kvm_vm *vm, int ret, int err)
+static void default_after_vcpu_run(struct kvm_vcpu *vcpu, int ret, int err)
 {
-	struct kvm_run *run = vcpu_state(vm, VCPU_ID);
+	struct kvm_run *run = vcpu->run;
 
 	TEST_ASSERT(ret == 0 || (ret == -1 && err == EINTR),
 		    "vcpu run failed: errno=%d", err);
 
-	TEST_ASSERT(get_ucall(vm, VCPU_ID, NULL) == UCALL_SYNC,
+	TEST_ASSERT(get_ucall(vcpu->vm, vcpu->id, NULL) == UCALL_SYNC,
 		    "Invalid guest sync status: exit_reason=%s\n",
 		    exit_reason_str(run->exit_reason));
 
@@ -328,7 +326,7 @@ static void dirty_ring_continue_vcpu(void)
 	sem_post(&sem_vcpu_cont);
 }
 
-static void dirty_ring_collect_dirty_pages(struct kvm_vm *vm, int slot,
+static void dirty_ring_collect_dirty_pages(struct kvm_vcpu *vcpu, int slot,
 					   void *bitmap, uint32_t num_pages)
 {
 	/* We only have one vcpu */
@@ -348,10 +346,10 @@ static void dirty_ring_collect_dirty_pages(struct kvm_vm *vm, int slot,
 	}
 
 	/* Only have one vcpu */
-	count = dirty_ring_collect_one(vcpu_map_dirty_ring(vm, VCPU_ID),
+	count = dirty_ring_collect_one(vcpu_map_dirty_ring(vcpu->vm, vcpu->id),
 				       slot, bitmap, num_pages, &fetch_index);
 
-	cleared = kvm_vm_reset_dirty_ring(vm);
+	cleared = kvm_vm_reset_dirty_ring(vcpu->vm);
 
 	/* Cleared pages should be the same as collected */
 	TEST_ASSERT(cleared == count, "Reset dirty pages (%u) mismatch "
@@ -366,12 +364,12 @@ static void dirty_ring_collect_dirty_pages(struct kvm_vm *vm, int slot,
 	pr_info("Iteration %ld collected %u pages\n", iteration, count);
 }
 
-static void dirty_ring_after_vcpu_run(struct kvm_vm *vm, int ret, int err)
+static void dirty_ring_after_vcpu_run(struct kvm_vcpu *vcpu, int ret, int err)
 {
-	struct kvm_run *run = vcpu_state(vm, VCPU_ID);
+	struct kvm_run *run = vcpu->run;
 
 	/* A ucall-sync or ring-full event is allowed */
-	if (get_ucall(vm, VCPU_ID, NULL) == UCALL_SYNC) {
+	if (get_ucall(vcpu->vm, vcpu->id, NULL) == UCALL_SYNC) {
 		/* We should allow this to continue */
 		;
 	} else if (run->exit_reason == KVM_EXIT_DIRTY_RING_FULL ||
@@ -405,10 +403,10 @@ struct log_mode {
 	/* Hook when the vm creation is done (before vcpu creation) */
 	void (*create_vm_done)(struct kvm_vm *vm);
 	/* Hook to collect the dirty pages into the bitmap provided */
-	void (*collect_dirty_pages) (struct kvm_vm *vm, int slot,
+	void (*collect_dirty_pages) (struct kvm_vcpu *vcpu, int slot,
 				     void *bitmap, uint32_t num_pages);
 	/* Hook to call when after each vcpu run */
-	void (*after_vcpu_run)(struct kvm_vm *vm, int ret, int err);
+	void (*after_vcpu_run)(struct kvm_vcpu *vcpu, int ret, int err);
 	void (*before_vcpu_join) (void);
 } log_modes[LOG_MODE_NUM] = {
 	{
@@ -470,22 +468,22 @@ static void log_mode_create_vm_done(struct kvm_vm *vm)
 		mode->create_vm_done(vm);
 }
 
-static void log_mode_collect_dirty_pages(struct kvm_vm *vm, int slot,
+static void log_mode_collect_dirty_pages(struct kvm_vcpu *vcpu, int slot,
 					 void *bitmap, uint32_t num_pages)
 {
 	struct log_mode *mode = &log_modes[host_log_mode];
 
 	TEST_ASSERT(mode->collect_dirty_pages != NULL,
 		    "collect_dirty_pages() is required for any log mode!");
-	mode->collect_dirty_pages(vm, slot, bitmap, num_pages);
+	mode->collect_dirty_pages(vcpu, slot, bitmap, num_pages);
 }
 
-static void log_mode_after_vcpu_run(struct kvm_vm *vm, int ret, int err)
+static void log_mode_after_vcpu_run(struct kvm_vcpu *vcpu, int ret, int err)
 {
 	struct log_mode *mode = &log_modes[host_log_mode];
 
 	if (mode->after_vcpu_run)
-		mode->after_vcpu_run(vm, ret, err);
+		mode->after_vcpu_run(vcpu, ret, err);
 }
 
 static void log_mode_before_vcpu_join(void)
@@ -507,7 +505,8 @@ static void generate_random_array(uint64_t *guest_array, uint64_t size)
 static void *vcpu_worker(void *data)
 {
 	int ret;
-	struct kvm_vm *vm = data;
+	struct kvm_vcpu *vcpu = data;
+	struct kvm_vm *vm = vcpu->vm;
 	uint64_t *guest_array;
 	uint64_t pages_count = 0;
 	struct kvm_signal_mask *sigmask = alloca(offsetof(struct kvm_signal_mask, sigset)
@@ -522,7 +521,7 @@ static void *vcpu_worker(void *data)
 	sigmask->len = 8;
 	pthread_sigmask(0, NULL, sigset);
 	sigdelset(sigset, SIG_IPI);
-	vcpu_ioctl(vm, VCPU_ID, KVM_SET_SIGNAL_MASK, sigmask);
+	vcpu_ioctl(vm, vcpu->id, KVM_SET_SIGNAL_MASK, sigmask);
 
 	sigemptyset(sigset);
 	sigaddset(sigset, SIG_IPI);
@@ -534,13 +533,13 @@ static void *vcpu_worker(void *data)
 		generate_random_array(guest_array, TEST_PAGES_PER_LOOP);
 		pages_count += TEST_PAGES_PER_LOOP;
 		/* Let the guest dirty the random pages */
-		ret = __vcpu_run(vm, VCPU_ID);
+		ret = __vcpu_run(vm, vcpu->id);
 		if (ret == -1 && errno == EINTR) {
 			int sig = -1;
 			sigwait(sigset, &sig);
 			assert(sig == SIG_IPI);
 		}
-		log_mode_after_vcpu_run(vm, ret, errno);
+		log_mode_after_vcpu_run(vcpu, ret, errno);
 	}
 
 	pr_info("Dirtied %"PRIu64" pages\n", pages_count);
@@ -693,6 +692,7 @@ struct test_params {
 static void run_test(enum vm_guest_mode mode, void *arg)
 {
 	struct test_params *p = arg;
+	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	unsigned long *bmap;
 
@@ -710,9 +710,10 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	 * (e.g., 64K page size guest will need even less memory for
 	 * page tables).
 	 */
-	vm = create_vm(mode, VCPU_ID,
+	vm = create_vm(mode, 0,
 		       2ul << (DIRTY_MEM_BITS - PAGE_SHIFT_4K),
 		       guest_code);
+	vcpu = vcpu_get(vm, 0);
 
 	guest_page_size = vm_get_page_size(vm);
 	/*
@@ -773,12 +774,12 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	host_clear_count = 0;
 	host_track_next_count = 0;
 
-	pthread_create(&vcpu_thread, NULL, vcpu_worker, vm);
+	pthread_create(&vcpu_thread, NULL, vcpu_worker, vcpu);
 
 	while (iteration < p->iterations) {
 		/* Give the vcpu thread some time to dirty some pages */
 		usleep(p->interval * 1000);
-		log_mode_collect_dirty_pages(vm, TEST_MEM_SLOT_INDEX,
+		log_mode_collect_dirty_pages(vcpu, TEST_MEM_SLOT_INDEX,
 					     bmap, host_num_pages);
 
 		/*
-- 
2.36.1.255.ge46751e96f-goog

