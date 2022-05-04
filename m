Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 076F651B334
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 01:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379728AbiEDW6f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 18:58:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379718AbiEDW5k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:57:40 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36E9E55218
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:51:54 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id t70-20020a638149000000b0039daafb0a84so1347975pgd.7
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:51:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=IBWGYxUey2I8ldSFhy55LOM29O+VOqL8t4FobkLYAfU=;
        b=BJ9i0xp/gN+o5CwY9um1yS6QOAHftIitP2QmGb41hkxADGJq/wc3kNJgo/RDBQoQxc
         JXC/DEdzKwghsKqKCDfnPj0SFKJRuNqIgGLzEZrrqgAAq9vtsT3Ng7TYcxZ7RcsXkunW
         cgq5dbF9oiLpceNItgH34aLKb/WK4AAItonXdx4t28SbZo5jKxcgYQlbjhIxNb9wF0/o
         ZCmsy0D8c7+JoDdltUcT/VwN/t2Ok2YUgcdHHSk+Bxp1tNH+SmQhHat+o4eTqQoBVyTU
         Hed/iE6ovddK7+96ux5uM23ybxs8TdxdwvfxlNlHX294F1iqvyOBsPnTZylhhSW1LSTT
         LwHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=IBWGYxUey2I8ldSFhy55LOM29O+VOqL8t4FobkLYAfU=;
        b=F/H1IWwhOmK9y4bZzzPYGxxVkkWfTdj+pmzEneLp0OYE2mItyz95/SQ6I31t1Vd5XZ
         59bX4JWEWBMrUFJ7JOTuqKILQYKwLWbGvDO2dZlJXXX4zrRx0BB1f9nsclubtwN21ANL
         EM+MyYp8ePIUiNzOg89BuTrUc+i1Cn3KjPZ0veLmV2nlW7YAM12W5NymIbK+j2jN6Tkc
         wZutwM2ffrjDfNBYc45RY1j9DvnJU0+/Bkxjh34Wl8WgUgeVxDTzttCgIiqzhZgX9UP4
         1YguOOw38ilfqi4hM2mmSi7CgX4tbjWo1BZ2YWc0WYBlYfPIhzHQuvVVsr5jhfnzrJMu
         8EVw==
X-Gm-Message-State: AOAM531zK20/uk6g2A27WPLGJmrudffivC/AlPHu6h3rSH1jw7D3IKWM
        wZ+it+Qms8zu7uBYFyWiu8Vw4fbDmO0=
X-Google-Smtp-Source: ABdhPJxKB5wP//IZe9NAXgdFqndTUEsQ1r4qVUX+woXv7sHIPatDlhGVsejODlWbsfSSyGtJG1oEKZ3a+7o=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:3b42:b0:1dc:5cdf:5649 with SMTP id
 ot2-20020a17090b3b4200b001dc5cdf5649mr2164707pjb.239.1651704712346; Wed, 04
 May 2022 15:51:52 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:48:28 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-83-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 082/128] KVM: selftests: Convert dirty_log_test away from VCPU_ID
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
        autolearn=unavailable autolearn_force=no version=3.4.6
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
index 66ee00b45847..ff3bd4c941a4 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -23,8 +23,6 @@
 #include "guest_modes.h"
 #include "processor.h"
 
-#define VCPU_ID				1
-
 /* The memory slot index to track dirty pages */
 #define TEST_MEM_SLOT_INDEX		1
 
@@ -229,17 +227,17 @@ static void clear_log_create_vm_done(struct kvm_vm *vm)
 	vm_enable_cap(vm, &cap);
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
@@ -253,14 +251,14 @@ static void vcpu_handle_sync_stop(void)
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
 
@@ -331,7 +329,7 @@ static void dirty_ring_continue_vcpu(void)
 	sem_post(&sem_vcpu_cont);
 }
 
-static void dirty_ring_collect_dirty_pages(struct kvm_vm *vm, int slot,
+static void dirty_ring_collect_dirty_pages(struct kvm_vcpu *vcpu, int slot,
 					   void *bitmap, uint32_t num_pages)
 {
 	/* We only have one vcpu */
@@ -351,10 +349,10 @@ static void dirty_ring_collect_dirty_pages(struct kvm_vm *vm, int slot,
 	}
 
 	/* Only have one vcpu */
-	count = dirty_ring_collect_one(vcpu_map_dirty_ring(vm, VCPU_ID),
+	count = dirty_ring_collect_one(vcpu_map_dirty_ring(vcpu->vm, vcpu->id),
 				       slot, bitmap, num_pages, &fetch_index);
 
-	cleared = kvm_vm_reset_dirty_ring(vm);
+	cleared = kvm_vm_reset_dirty_ring(vcpu->vm);
 
 	/* Cleared pages should be the same as collected */
 	TEST_ASSERT(cleared == count, "Reset dirty pages (%u) mismatch "
@@ -369,12 +367,12 @@ static void dirty_ring_collect_dirty_pages(struct kvm_vm *vm, int slot,
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
@@ -408,10 +406,10 @@ struct log_mode {
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
@@ -473,22 +471,22 @@ static void log_mode_create_vm_done(struct kvm_vm *vm)
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
@@ -510,7 +508,8 @@ static void generate_random_array(uint64_t *guest_array, uint64_t size)
 static void *vcpu_worker(void *data)
 {
 	int ret;
-	struct kvm_vm *vm = data;
+	struct kvm_vcpu *vcpu = data;
+	struct kvm_vm *vm = vcpu->vm;
 	uint64_t *guest_array;
 	uint64_t pages_count = 0;
 	struct kvm_signal_mask *sigmask = alloca(offsetof(struct kvm_signal_mask, sigset)
@@ -525,7 +524,7 @@ static void *vcpu_worker(void *data)
 	sigmask->len = 8;
 	pthread_sigmask(0, NULL, sigset);
 	sigdelset(sigset, SIG_IPI);
-	vcpu_ioctl(vm, VCPU_ID, KVM_SET_SIGNAL_MASK, sigmask);
+	vcpu_ioctl(vm, vcpu->id, KVM_SET_SIGNAL_MASK, sigmask);
 
 	sigemptyset(sigset);
 	sigaddset(sigset, SIG_IPI);
@@ -537,13 +536,13 @@ static void *vcpu_worker(void *data)
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
@@ -696,6 +695,7 @@ struct test_params {
 static void run_test(enum vm_guest_mode mode, void *arg)
 {
 	struct test_params *p = arg;
+	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	unsigned long *bmap;
 
@@ -713,9 +713,10 @@ static void run_test(enum vm_guest_mode mode, void *arg)
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
@@ -776,12 +777,12 @@ static void run_test(enum vm_guest_mode mode, void *arg)
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
2.36.0.464.gb9c8b46e94-goog

