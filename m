Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9907B199E98
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 21:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731302AbgCaTBe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 15:01:34 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:44385 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727768AbgCaTBd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Mar 2020 15:01:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585681292;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pvn8rulfwWl/vBfwgfPRKDDuo5rVv+xe9BS1KlCAb2o=;
        b=VZbmAmTxlzUZhLe8mdugHUtUMHjKySGc+1D+Dj35ytLzg2/FdJdJ9u21oNSpqGzciZ271S
        w7CeZpkhVRrI2SjjIwQUQE22/8Sejwpqn8xO7sNbfDab4m/qIi3tiIabnsqqtNBdfi+LRQ
        gCWAql+LTOcWev3WgUTAYDDqF5sPdgw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-1-QlC1ZReVOACc2Tmr52VLvQ-1; Tue, 31 Mar 2020 15:01:28 -0400
X-MC-Unique: QlC1ZReVOACc2Tmr52VLvQ-1
Received: by mail-wm1-f72.google.com with SMTP id c21so1062638wmb.3
        for <kvm@vger.kernel.org>; Tue, 31 Mar 2020 12:01:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pvn8rulfwWl/vBfwgfPRKDDuo5rVv+xe9BS1KlCAb2o=;
        b=BI3r5i/SrRq68CLvmq4zIcE8H/xUYiOoX1p6ddDwrn+uFoeLGBgMPkm6Yvfrgv5lYc
         cGaijCmgWjEkETNEBKvWaoVXMOkqxyYN+L8VKKARYhBt+e+/vad6ebN6hlRK59w+/t62
         glp8bMY+kK45hdiNlze3bB+K/uQTLjXD68c/REJhie+3XzIoQBEiBQQh37uiUmTwGcdQ
         GjITYYtseWdYbTmh7rOS6s5scEDODQHzxnNaApkhARnaWLR6jiL+eA1FkgtBl2Ya3rLh
         oz0i98MEPdRKF7NB7sv31HIzaesHu/JAHih8zjRubPAINp7wabRxTCVE3rmVPPy8sxHA
         6bUA==
X-Gm-Message-State: AGi0PuannIL7/znT7ZDE10y1kw7pkFlvlC7YHAncoRh2621i8mLn5L3F
        3XMD8g6hxacqjj3wLMmI77C3FuNYYwiZVlZy5RlLsrhE34rUrBofKBuqIRKl4sJP4PA92bjlYNV
        qrClQNwo9Vo5C
X-Received: by 2002:a1c:197:: with SMTP id 145mr325818wmb.42.1585681285275;
        Tue, 31 Mar 2020 12:01:25 -0700 (PDT)
X-Google-Smtp-Source: APiQypKJ/Xw0n9e2iLLun1jE+OYTGFSdJDoEp3FmyV8lpTtDEhz1iOY9vmPITxRiiLBw4GCzCJqtEw==
X-Received: by 2002:a1c:197:: with SMTP id 145mr325787wmb.42.1585681284907;
        Tue, 31 Mar 2020 12:01:24 -0700 (PDT)
Received: from xz-x1.redhat.com ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id n11sm4847831wmi.10.2020.03.31.12.01.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2020 12:01:24 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Kevin Tian <kevin.tian@intel.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>, peterx@redhat.com
Subject: [PATCH v8 13/14] KVM: selftests: Let dirty_log_test async for dirty ring test
Date:   Tue, 31 Mar 2020 14:59:59 -0400
Message-Id: <20200331190000.659614-14-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200331190000.659614-1-peterx@redhat.com>
References: <20200331190000.659614-1-peterx@redhat.com>
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
index 554fdb294bef..62254375ec50 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -144,6 +144,7 @@ vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva);
 struct kvm_run *vcpu_state(struct kvm_vm *vm, uint32_t vcpuid);
 void vcpu_run(struct kvm_vm *vm, uint32_t vcpuid);
 int _vcpu_run(struct kvm_vm *vm, uint32_t vcpuid);
+int vcpu_get_fd(struct kvm_vm *vm, uint32_t vcpuid);
 void vcpu_run_complete_io(struct kvm_vm *vm, uint32_t vcpuid);
 void vcpu_set_mp_state(struct kvm_vm *vm, uint32_t vcpuid,
 		       struct kvm_mp_state *mp_state);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index e632d1f4a112..0e79bde7a2a8 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1207,6 +1207,15 @@ int _vcpu_run(struct kvm_vm *vm, uint32_t vcpuid)
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
2.24.1

