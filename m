Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A57DC135BFA
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 15:58:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732119AbgAIO62 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 09:58:28 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23147 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732092AbgAIO6Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jan 2020 09:58:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578581904;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fC+6Sh3GEblv8QYQZxVb8yxgjLMEdKyQTn5LrgCGUhc=;
        b=Y5m74uRm31TR/GdhSb6VsLikeTt5i21tDkGTI9m7G8YHDgFEfw1/i5xdWx7Lsx+bGp1Yqs
        iXjzScSSJ+GhVDLzzvc7mcm4j/IAYL17lDIB+n+pMLxhcTLTbIZOiTNehqHu2WH1M+JqDc
        R0GGUltYTpRAbRE24Y3MOpJ7/u8MmWQ=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-274-UKpgyCvLOQ-NWAWe7GRyQQ-1; Thu, 09 Jan 2020 09:58:23 -0500
X-MC-Unique: UKpgyCvLOQ-NWAWe7GRyQQ-1
Received: by mail-qv1-f72.google.com with SMTP id g6so4276881qvp.0
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2020 06:58:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fC+6Sh3GEblv8QYQZxVb8yxgjLMEdKyQTn5LrgCGUhc=;
        b=clc2YhTMGF954oT85jAcOLQNWT6ch8nJmRgRqCF4M/QRhpeVYpURGdRSkdD/7CNLYu
         GR5hPgYH3bVloLvJT5+KhqhCk/GUnYGdMZ18o/pmwyS/BZqpZ0iJxX81UVfx3iP0WKH+
         AlrLM+IgGOu5yNLiXpTXK02+yeuiWI6KbJFBRONTmBJRSDtRhXQJSt0TheUIkoAhcPiQ
         7J8qdKAVv+DrC1vt36m984q2YxMr9I+oYEFHTR+uS0W3pn9nHD0VD82w+xVjtX+NyTOA
         LURVOTITfcZcsjn7CgyaeAQbwH6TiWd0zfgCzqXQn9tZv/NMLEbY0jDud4mlgt9AqkjH
         fDHA==
X-Gm-Message-State: APjAAAV81sHtQ+oHDoYatxzZHW8DO/fcYW5v9tC6OMiH6x4v78lILTI1
        Afd1eW17x6qW2Kxff4Dq1ICwrR+uKjB2ygmn+h6vfXzp6Q9umnHCR6Sx4kSNQS1OI1V8XqzMlg9
        ypS7XuGfQy2j3
X-Received: by 2002:ac8:5448:: with SMTP id d8mr8213437qtq.205.1578581902194;
        Thu, 09 Jan 2020 06:58:22 -0800 (PST)
X-Google-Smtp-Source: APXvYqyBQ589tcotZZtyB5tl1TvvysAeZEulRzXpyDWvFo9GTBU0Q9N0vpOgeIiNmNIf5Cz0DRzb1Q==
X-Received: by 2002:ac8:5448:: with SMTP id d8mr8213408qtq.205.1578581901835;
        Thu, 09 Jan 2020 06:58:21 -0800 (PST)
Received: from xz-x1.yyz.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id q2sm3124179qkm.5.2020.01.09.06.58.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2020 06:58:21 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Christophe de Dinechin <dinechin@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Kevin <kevin.tian@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, peterx@redhat.com,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Subject: [PATCH v3 20/21] KVM: selftests: Let dirty_log_test async for dirty ring test
Date:   Thu,  9 Jan 2020 09:57:28 -0500
Message-Id: <20200109145729.32898-21-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200109145729.32898-1-peterx@redhat.com>
References: <20200109145729.32898-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
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

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c  | 123 +++++++++++++-----
 .../testing/selftests/kvm/include/kvm_util.h  |   1 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |   8 ++
 3 files changed, 103 insertions(+), 29 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 6a551f285dea..6da97e4a9408 100644
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
@@ -151,6 +162,33 @@ enum log_mode_t {
 
 /* Mode of logging.  Default is LOG_MODE_DIRTY_LOG */
 static enum log_mode_t host_log_mode;
+pthread_t vcpu_thread;
+
+/* Only way to pass this to the signal handler */
+struct kvm_vm *current_vm;
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
 
 static void clear_log_create_vm_done(struct kvm_vm *vm)
 {
@@ -179,10 +217,13 @@ static void clear_log_collect_dirty_pages(struct kvm_vm *vm, int slot,
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
@@ -235,27 +276,37 @@ static uint32_t dirty_ring_collect_one(struct kvm_dirty_gfn *dirty_gfns,
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
+	DEBUG("Notifying vcpu to continue\n");
+	sem_post(&dirty_ring_vcpu_cont);
+}
+
 static void dirty_ring_collect_dirty_pages(struct kvm_vm *vm, int slot,
 					   void *bitmap, uint32_t num_pages)
 {
 	/* We only have one vcpu */
 	struct kvm_run *state = vcpu_state(vm, VCPU_ID);
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
@@ -268,13 +319,16 @@ static void dirty_ring_collect_dirty_pages(struct kvm_vm *vm, int slot,
 	TEST_ASSERT(cleared == count, "Reset dirty pages (%u) mismatch "
 		    "with collected (%u)", cleared, count);
 
-	DEBUG("Notifying vcpu to continue\n");
-	sem_post(&dirty_ring_vcpu_cont);
+	if (!continued_vcpu) {
+		TEST_ASSERT(dirty_ring_vcpu_ring_full,
+			    "Didn't continue vcpu even without ring full");
+		dirty_ring_continue_vcpu();
+	}
 
 	DEBUG("Iteration %ld collected %u pages\n", iteration, count);
 }
 
-static void dirty_ring_after_vcpu_run(struct kvm_vm *vm)
+static void dirty_ring_after_vcpu_run(struct kvm_vm *vm, int ret, int err)
 {
 	struct kvm_run *run = vcpu_state(vm, VCPU_ID);
 
@@ -282,10 +336,16 @@ static void dirty_ring_after_vcpu_run(struct kvm_vm *vm)
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
-		DEBUG("vcpu stops because dirty ring full...\n");
-		sem_wait(&dirty_ring_vcpu_cont);
+		DEBUG("vcpu stops because %s...\n",
+		      dirty_ring_vcpu_ring_full ?
+		      "dirty ring is full" : "vcpu is kicked out");
+		sem_wait_until(&dirty_ring_vcpu_cont);
 		DEBUG("vcpu continues now.\n");
 	} else {
 		TEST_ASSERT(false, "Invalid guest sync status: "
@@ -308,7 +368,7 @@ struct log_mode {
 	void (*collect_dirty_pages) (struct kvm_vm *vm, int slot,
 				     void *bitmap, uint32_t num_pages);
 	/* Hook to call when after each vcpu run */
-	void (*after_vcpu_run)(struct kvm_vm *vm);
+	void (*after_vcpu_run)(struct kvm_vm *vm, int ret, int err);
 	void (*before_vcpu_join) (void);
 } log_modes[LOG_MODE_NUM] = {
 	{
@@ -368,12 +428,12 @@ static void log_mode_collect_dirty_pages(struct kvm_vm *vm, int slot,
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
@@ -397,15 +457,21 @@ static void *vcpu_worker(void *data)
 	int ret;
 	struct kvm_vm *vm = data;
 	uint64_t *guest_array;
+	struct sigaction sigact;
+
+	current_vm = vm;
+	memset(&sigact, 0, sizeof(sigact));
+	sigact.sa_handler = vcpu_sig_handler;
+	sigaction(SIG_IPI, &sigact, NULL);
 
 	guest_array = addr_gva2hva(vm, (vm_vaddr_t)random_array);
 
 	while (!READ_ONCE(host_quit)) {
+		/* Clear any existing kick signals */
 		generate_random_array(guest_array, TEST_PAGES_PER_LOOP);
 		/* Let the guest dirty the random pages */
-		ret = _vcpu_run(vm, VCPU_ID);
-		TEST_ASSERT(ret == 0, "vcpu_run failed: %d\n", ret);
-		log_mode_after_vcpu_run(vm);
+		ret = __vcpu_run(vm, VCPU_ID);
+		log_mode_after_vcpu_run(vm, ret, errno);
 	}
 
 	return NULL;
@@ -528,7 +594,6 @@ static struct kvm_vm *create_vm(enum vm_guest_mode mode, uint32_t vcpuid,
 static void run_test(enum vm_guest_mode mode, unsigned long iterations,
 		     unsigned long interval, uint64_t phys_offset)
 {
-	pthread_t vcpu_thread;
 	struct kvm_vm *vm;
 	unsigned long *bmap;
 
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 4b78a8d3e773..e64fbfe6bbd5 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -115,6 +115,7 @@ vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva);
 struct kvm_run *vcpu_state(struct kvm_vm *vm, uint32_t vcpuid);
 void vcpu_run(struct kvm_vm *vm, uint32_t vcpuid);
 int _vcpu_run(struct kvm_vm *vm, uint32_t vcpuid);
+int __vcpu_run(struct kvm_vm *vm, uint32_t vcpuid);
 void vcpu_run_complete_io(struct kvm_vm *vm, uint32_t vcpuid);
 void vcpu_set_mp_state(struct kvm_vm *vm, uint32_t vcpuid,
 		       struct kvm_mp_state *mp_state);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 81222e2f841e..12c83e2f3300 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1187,6 +1187,14 @@ int _vcpu_run(struct kvm_vm *vm, uint32_t vcpuid)
 	return rc;
 }
 
+int __vcpu_run(struct kvm_vm *vm, uint32_t vcpuid)
+{
+	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
+
+	TEST_ASSERT(vcpu != NULL, "vcpu not found, vcpuid: %u", vcpuid);
+	return ioctl(vcpu->fd, KVM_RUN, NULL);
+}
+
 void vcpu_run_complete_io(struct kvm_vm *vm, uint32_t vcpuid)
 {
 	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
-- 
2.24.1

