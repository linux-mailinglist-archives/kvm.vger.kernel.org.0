Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 202E127F746
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 03:22:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731484AbgJABWs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 21:22:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30539 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731390AbgJABWo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 30 Sep 2020 21:22:44 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601515361;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tulzE+jYwDRofZW3LisyVs7di9bDy1rTMGk8Jy/MDLI=;
        b=O0FN7ZzXbLt/SkLPe7eaIYouobaQQe3NtRfb/XoGlZhUdNpCGxicsAAc8DNNkVTYl9uGJ+
        QJ+Dfrvm7kIMyF75KbjDJkeMrHYoVpT97tCqQGChE6qBNtOxlskWoHKMsch1yHvyQ8lJh0
        Jc/iTu8Pqv6+9yc/MVLD1N0YDqGxmyE=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-285-Dbn_oQgiM_2DqcpItHOOIg-1; Wed, 30 Sep 2020 21:22:40 -0400
X-MC-Unique: Dbn_oQgiM_2DqcpItHOOIg-1
Received: by mail-qt1-f200.google.com with SMTP id w92so2518883qte.19
        for <kvm@vger.kernel.org>; Wed, 30 Sep 2020 18:22:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tulzE+jYwDRofZW3LisyVs7di9bDy1rTMGk8Jy/MDLI=;
        b=ZareeKypTIFJsLCsIcCtv/xG/psvHPBFAY/QuNEgx7z88Dgaj4YU2FRQjp4Gf8Yt1a
         Zo2QAgZSjsi6D9/0YDy9cDJ57UPsWPRRCBKkXLEllL56WwUPzOQyXX/8vuXSzUrMuPI2
         MKtI5sV4xy1CRR2pX8CRIeAdPQjo+Hjc4WVKqLI+TM17+N0Ae+GcdowxogT5h7X1UK+4
         z18s5Tyxne0xlxN+a7EMSC8CK06+asflG70nPdRwG2KOshr71S4NNquZn4sK0Z6y1KEX
         Jf8gfiOKkVGGTOdAEXspzU+0MkyqFp8tBk2zhVExvc4imd9lfDgCOob5vMkWaPy2RvHy
         6j5Q==
X-Gm-Message-State: AOAM5300CIC/YIB6sMW9qn8J5ZRpXT4p00obsTcTyssqblscoL91jIp8
        +kw07AhGrKafwLds16XjcDk7avyA4+a4ZO+g3KU9LQguPGHjrpe/fROXUffdGPbJuunRkrNKFJv
        LMDCMzs6Wf0g2
X-Received: by 2002:a37:8883:: with SMTP id k125mr5303350qkd.387.1601515359018;
        Wed, 30 Sep 2020 18:22:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzjDSjK2J4P2C+hLtlBTLtuEqGgBcySwtMCJz8sF8Vw/zHbXRMYduhvIm+WshmWd4yjlbEcog==
X-Received: by 2002:a37:8883:: with SMTP id k125mr5303322qkd.387.1601515358629;
        Wed, 30 Sep 2020 18:22:38 -0700 (PDT)
Received: from localhost.localdomain (toroon474qw-lp130-09-184-147-14-204.dsl.bell.ca. [184.147.14.204])
        by smtp.gmail.com with ESMTPSA id 206sm4402956qkk.27.2020.09.30.18.22.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2020 18:22:37 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>, peterx@redhat.com,
        Andrew Jones <drjones@redhat.com>
Subject: [PATCH v13 13/14] KVM: selftests: Let dirty_log_test async for dirty ring test
Date:   Wed, 30 Sep 2020 21:22:39 -0400
Message-Id: <20201001012239.6159-1-peterx@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201001012044.5151-1-peterx@redhat.com>
References: <20201001012044.5151-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Previously the dirty ring test was working in synchronous way, because
only with a vmexit (with that it was the ring full event) we'll know
the hardware dirty bits will be flushed to the dirty ring.

With this patch we first introduced the vcpu kick mechanism by using
SIGUSR1, meanwhile we can have a guarantee of vmexit and also the
flushing of hardware dirty bits.  With all these, we can keep the vcpu
dirty work asynchronous of the whole collection procedure now.  Still,
we need to be very careful that we can only do it async if the vcpu is
not reaching soft limit (no KVM_EXIT_DIRTY_RING_FULL).  Otherwise we
must collect the dirty bits before continuing the vcpu.

Further increase the dirty ring size to current maximum to make sure
we torture more on the no-ring-full case, which should be the major
scenario when the hypervisors like QEMU would like to use this feature.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c  | 126 +++++++++++++-----
 .../testing/selftests/kvm/include/kvm_util.h  |   1 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |   9 ++
 3 files changed, 106 insertions(+), 30 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 531431cff4fc..4b404dfdc2f9 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -13,6 +13,9 @@
 #include <time.h>
 #include <pthread.h>
 #include <semaphore.h>
+#include <sys/types.h>
+#include <signal.h>
+#include <errno.h>
 #include <linux/bitmap.h>
 #include <linux/bitops.h>
 #include <asm/barrier.h>
@@ -59,7 +62,9 @@
 # define test_and_clear_bit_le	test_and_clear_bit
 #endif
 
-#define TEST_DIRTY_RING_COUNT		1024
+#define TEST_DIRTY_RING_COUNT		65536
+
+#define SIG_IPI SIGUSR1
 
 /*
  * Guest/Host shared variables. Ensure addr_gva2hva() and/or
@@ -135,6 +140,12 @@ static uint64_t host_track_next_count;
 /* Whether dirty ring reset is requested, or finished */
 static sem_t dirty_ring_vcpu_stop;
 static sem_t dirty_ring_vcpu_cont;
+/*
+ * This is updated by the vcpu thread to tell the host whether it's a
+ * ring-full event.  It should only be read until a sem_wait() of
+ * dirty_ring_vcpu_stop and before vcpu continues to run.
+ */
+static bool dirty_ring_vcpu_ring_full;
 
 enum log_mode_t {
 	/* Only use KVM_GET_DIRTY_LOG for logging */
@@ -156,6 +167,33 @@ enum log_mode_t {
 static enum log_mode_t host_log_mode_option = LOG_MODE_ALL;
 /* Logging mode for current run */
 static enum log_mode_t host_log_mode;
+static pthread_t vcpu_thread;
+
+/* Only way to pass this to the signal handler */
+static struct kvm_vm *current_vm;
+
+static void vcpu_sig_handler(int sig)
+{
+	TEST_ASSERT(sig == SIG_IPI, "unknown signal: %d", sig);
+}
+
+static void vcpu_kick(void)
+{
+	pthread_kill(vcpu_thread, SIG_IPI);
+}
+
+/*
+ * In our test we do signal tricks, let's use a better version of
+ * sem_wait to avoid signal interrupts
+ */
+static void sem_wait_until(sem_t *sem)
+{
+	int ret;
+
+	do
+		ret = sem_wait(sem);
+	while (ret == -1 && errno == EINTR);
+}
 
 static bool clear_log_supported(void)
 {
@@ -189,10 +227,13 @@ static void clear_log_collect_dirty_pages(struct kvm_vm *vm, int slot,
 	kvm_vm_clear_dirty_log(vm, slot, bitmap, 0, num_pages);
 }
 
-static void default_after_vcpu_run(struct kvm_vm *vm)
+static void default_after_vcpu_run(struct kvm_vm *vm, int ret, int err)
 {
 	struct kvm_run *run = vcpu_state(vm, VCPU_ID);
 
+	TEST_ASSERT(ret == 0 || (ret == -1 && err == EINTR),
+		    "vcpu run failed: errno=%d", err);
+
 	TEST_ASSERT(get_ucall(vm, VCPU_ID, NULL) == UCALL_SYNC,
 		    "Invalid guest sync status: exit_reason=%s\n",
 		    exit_reason_str(run->exit_reason));
@@ -248,27 +289,37 @@ static uint32_t dirty_ring_collect_one(struct kvm_dirty_gfn *dirty_gfns,
 	return count;
 }
 
+static void dirty_ring_wait_vcpu(void)
+{
+	/* This makes sure that hardware PML cache flushed */
+	vcpu_kick();
+	sem_wait_until(&dirty_ring_vcpu_stop);
+}
+
+static void dirty_ring_continue_vcpu(void)
+{
+	pr_info("Notifying vcpu to continue\n");
+	sem_post(&dirty_ring_vcpu_cont);
+}
+
 static void dirty_ring_collect_dirty_pages(struct kvm_vm *vm, int slot,
 					   void *bitmap, uint32_t num_pages)
 {
 	/* We only have one vcpu */
 	static uint32_t fetch_index = 0;
 	uint32_t count = 0, cleared;
+	bool continued_vcpu = false;
 
-	/*
-	 * Before fetching the dirty pages, we need a vmexit of the
-	 * worker vcpu to make sure the hardware dirty buffers were
-	 * flushed.  This is not needed for dirty-log/clear-log tests
-	 * because get dirty log will natually do so.
-	 *
-	 * For now we do it in the simple way - we simply wait until
-	 * the vcpu uses up the soft dirty ring, then it'll always
-	 * do a vmexit to make sure that PML buffers will be flushed.
-	 * In real hypervisors, we probably need a vcpu kick or to
-	 * stop the vcpus (before the final sync) to make sure we'll
-	 * get all the existing dirty PFNs even cached in hardware.
-	 */
-	sem_wait(&dirty_ring_vcpu_stop);
+	dirty_ring_wait_vcpu();
+
+	if (!dirty_ring_vcpu_ring_full) {
+		/*
+		 * This is not a ring-full event, it's safe to allow
+		 * vcpu to continue
+		 */
+		dirty_ring_continue_vcpu();
+		continued_vcpu = true;
+	}
 
 	/* Only have one vcpu */
 	count = dirty_ring_collect_one(vcpu_map_dirty_ring(vm, VCPU_ID),
@@ -280,13 +331,16 @@ static void dirty_ring_collect_dirty_pages(struct kvm_vm *vm, int slot,
 	TEST_ASSERT(cleared == count, "Reset dirty pages (%u) mismatch "
 		    "with collected (%u)", cleared, count);
 
-	pr_info("Notifying vcpu to continue\n");
-	sem_post(&dirty_ring_vcpu_cont);
+	if (!continued_vcpu) {
+		TEST_ASSERT(dirty_ring_vcpu_ring_full,
+			    "Didn't continue vcpu even without ring full");
+		dirty_ring_continue_vcpu();
+	}
 
 	pr_info("Iteration %ld collected %u pages\n", iteration, count);
 }
 
-static void dirty_ring_after_vcpu_run(struct kvm_vm *vm)
+static void dirty_ring_after_vcpu_run(struct kvm_vm *vm, int ret, int err)
 {
 	struct kvm_run *run = vcpu_state(vm, VCPU_ID);
 
@@ -294,10 +348,16 @@ static void dirty_ring_after_vcpu_run(struct kvm_vm *vm)
 	if (get_ucall(vm, VCPU_ID, NULL) == UCALL_SYNC) {
 		/* We should allow this to continue */
 		;
-	} else if (run->exit_reason == KVM_EXIT_DIRTY_RING_FULL) {
+	} else if (run->exit_reason == KVM_EXIT_DIRTY_RING_FULL ||
+		   (ret == -1 && err == EINTR)) {
+		/* Update the flag first before pause */
+		WRITE_ONCE(dirty_ring_vcpu_ring_full,
+			   run->exit_reason == KVM_EXIT_DIRTY_RING_FULL);
 		sem_post(&dirty_ring_vcpu_stop);
-		pr_info("vcpu stops because dirty ring full...\n");
-		sem_wait(&dirty_ring_vcpu_cont);
+		pr_info("vcpu stops because %s...\n",
+			dirty_ring_vcpu_ring_full ?
+			"dirty ring is full" : "vcpu is kicked out");
+		sem_wait_until(&dirty_ring_vcpu_cont);
 		pr_info("vcpu continues now.\n");
 	} else {
 		TEST_ASSERT(false, "Invalid guest sync status: "
@@ -322,7 +382,7 @@ struct log_mode {
 	void (*collect_dirty_pages) (struct kvm_vm *vm, int slot,
 				     void *bitmap, uint32_t num_pages);
 	/* Hook to call when after each vcpu run */
-	void (*after_vcpu_run)(struct kvm_vm *vm);
+	void (*after_vcpu_run)(struct kvm_vm *vm, int ret, int err);
 	void (*before_vcpu_join) (void);
 } log_modes[LOG_MODE_NUM] = {
 	{
@@ -394,12 +454,12 @@ static void log_mode_collect_dirty_pages(struct kvm_vm *vm, int slot,
 	mode->collect_dirty_pages(vm, slot, bitmap, num_pages);
 }
 
-static void log_mode_after_vcpu_run(struct kvm_vm *vm)
+static void log_mode_after_vcpu_run(struct kvm_vm *vm, int ret, int err)
 {
 	struct log_mode *mode = &log_modes[host_log_mode];
 
 	if (mode->after_vcpu_run)
-		mode->after_vcpu_run(vm);
+		mode->after_vcpu_run(vm, ret, err);
 }
 
 static void log_mode_before_vcpu_join(void)
@@ -420,20 +480,27 @@ static void generate_random_array(uint64_t *guest_array, uint64_t size)
 
 static void *vcpu_worker(void *data)
 {
-	int ret;
+	int ret, vcpu_fd;
 	struct kvm_vm *vm = data;
 	uint64_t *guest_array;
 	uint64_t pages_count = 0;
+	struct sigaction sigact;
+
+	current_vm = vm;
+	vcpu_fd = vcpu_get_fd(vm, VCPU_ID);
+	memset(&sigact, 0, sizeof(sigact));
+	sigact.sa_handler = vcpu_sig_handler;
+	sigaction(SIG_IPI, &sigact, NULL);
 
 	guest_array = addr_gva2hva(vm, (vm_vaddr_t)random_array);
 
 	while (!READ_ONCE(host_quit)) {
+		/* Clear any existing kick signals */
 		generate_random_array(guest_array, TEST_PAGES_PER_LOOP);
 		pages_count += TEST_PAGES_PER_LOOP;
 		/* Let the guest dirty the random pages */
-		ret = _vcpu_run(vm, VCPU_ID);
-		TEST_ASSERT(ret == 0, "vcpu_run failed: %d\n", ret);
-		log_mode_after_vcpu_run(vm);
+		ret = ioctl(vcpu_fd, KVM_RUN, NULL);
+		log_mode_after_vcpu_run(vm, ret, errno);
 	}
 
 	pr_info("Dirtied %"PRIu64" pages\n", pages_count);
@@ -583,7 +650,6 @@ static struct kvm_vm *create_vm(enum vm_guest_mode mode, uint32_t vcpuid,
 static void run_test(enum vm_guest_mode mode, unsigned long iterations,
 		     unsigned long interval, uint64_t phys_offset)
 {
-	pthread_t vcpu_thread;
 	struct kvm_vm *vm;
 	unsigned long *bmap;
 
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index dce07d354a70..f3b5da383bb5 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -146,6 +146,7 @@ vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva);
 struct kvm_run *vcpu_state(struct kvm_vm *vm, uint32_t vcpuid);
 void vcpu_run(struct kvm_vm *vm, uint32_t vcpuid);
 int _vcpu_run(struct kvm_vm *vm, uint32_t vcpuid);
+int vcpu_get_fd(struct kvm_vm *vm, uint32_t vcpuid);
 void vcpu_run_complete_io(struct kvm_vm *vm, uint32_t vcpuid);
 void vcpu_set_guest_debug(struct kvm_vm *vm, uint32_t vcpuid,
 			  struct kvm_guest_debug *debug);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 831f986674ca..4625e193074e 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1220,6 +1220,15 @@ int _vcpu_run(struct kvm_vm *vm, uint32_t vcpuid)
 	return rc;
 }
 
+int vcpu_get_fd(struct kvm_vm *vm, uint32_t vcpuid)
+{
+	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
+
+	TEST_ASSERT(vcpu != NULL, "vcpu not found, vcpuid: %u", vcpuid);
+
+	return vcpu->fd;
+}
+
 void vcpu_run_complete_io(struct kvm_vm *vm, uint32_t vcpuid)
 {
 	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
-- 
2.26.2

