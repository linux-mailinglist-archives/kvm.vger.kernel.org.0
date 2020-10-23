Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EBF42976FC
	for <lists+kvm@lfdr.de>; Fri, 23 Oct 2020 20:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1754942AbgJWSee (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Oct 2020 14:34:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50917 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754925AbgJWSeb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Oct 2020 14:34:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603478069;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uv2c/TR/fmJXSUaX+2BC7rQA6mCtzvLrsJeSDoaQmNs=;
        b=PSZzgmCfKYRH4lT/zuDuO8IY9WMPzq7mLkMM/NurAeZ98BcCojI237KrGf3oDwOUAQ7VYk
        4qUpsXtD+iXOyvjwcStkAawbtsfY0dih/42YiwUE0XewRKt0a5MZvEuZT8jHqsqYhPRs6y
        77hWULSLO+MKfRHuEAf7sl8CW2BCBek=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-451-FzDuEBtDNYC4yh-2MCAsTQ-1; Fri, 23 Oct 2020 14:34:27 -0400
X-MC-Unique: FzDuEBtDNYC4yh-2MCAsTQ-1
Received: by mail-qk1-f197.google.com with SMTP id k12so1608771qkj.18
        for <kvm@vger.kernel.org>; Fri, 23 Oct 2020 11:34:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uv2c/TR/fmJXSUaX+2BC7rQA6mCtzvLrsJeSDoaQmNs=;
        b=ZqwsaRXPg/oth5qATtqXiq8OzDmOxex133CFVoW3PpfwrYwBbpZy+5XQmQtpfvaQcc
         Qux0nxDWGK+/2u3GH+mTCxGhEO4sIpV58tr0QtOGPl5hSfNHc+VGP8Z6jXKKjDiUVvaN
         hB8+DUUlttH2SSKkLoZMIlC6YXiFLcrdRpsXyhNdlQbHgEORkVF3l85ax7HUOaTaMthM
         rVhOnC19BOLsAdGhjMUoY/3lNme3DZ1zLfvGmcspfUCDs+pFzAnJwotmV5QEzFRy2y9J
         uYGmb8knjwACC0ELKXck4nMuLv1pPrUC3KKLVw+D9Rd8NzgyIZ8V0+oGW7Qab2PvNsxZ
         xidg==
X-Gm-Message-State: AOAM533QrPAUb7NIHsqxx/d4XddmgBMJLHNpaSTv0RPVUGym+rnoKzgm
        V26blahpmPbUCNt8YErxn/C0K0y+wuc8mUBi1+xp7viajiByuo2BppgTcisSrnzomYARfvDR3Zx
        rcJ6uBaYjrSEU
X-Received: by 2002:ac8:160f:: with SMTP id p15mr3447897qtj.57.1603478066326;
        Fri, 23 Oct 2020 11:34:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxpsfX9btSjkssYIs1bGhqyIW56bwditiTMbsOtrjnD+a+O5uE/i6va/CmKRqwkLO8B3m4FiA==
X-Received: by 2002:ac8:160f:: with SMTP id p15mr3447863qtj.57.1603478065976;
        Fri, 23 Oct 2020 11:34:25 -0700 (PDT)
Received: from xz-x1.redhat.com (toroon474qw-lp140-04-174-95-215-133.dsl.bell.ca. [174.95.215.133])
        by smtp.gmail.com with ESMTPSA id u11sm1490407qtk.61.2020.10.23.11.34.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2020 11:34:25 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        peterx@redhat.com, Andrew Jones <drjones@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v15 13/14] KVM: selftests: Let dirty_log_test async for dirty ring test
Date:   Fri, 23 Oct 2020 14:33:57 -0400
Message-Id: <20201023183358.50607-14-peterx@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201023183358.50607-1-peterx@redhat.com>
References: <20201023183358.50607-1-peterx@redhat.com>
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
index 9fcd15b8e999..913583cb22b8 100644
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
@@ -149,6 +154,12 @@ static sem_t dirty_ring_vcpu_cont;
  * verifying process, we let it pass.
  */
 static uint64_t dirty_ring_last_page;
+/*
+ * This is updated by the vcpu thread to tell the host whether it's a
+ * ring-full event.  It should only be read until a sem_wait() of
+ * dirty_ring_vcpu_stop and before vcpu continues to run.
+ */
+static bool dirty_ring_vcpu_ring_full;
 
 enum log_mode_t {
 	/* Only use KVM_GET_DIRTY_LOG for logging */
@@ -170,6 +181,33 @@ enum log_mode_t {
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
@@ -203,10 +241,13 @@ static void clear_log_collect_dirty_pages(struct kvm_vm *vm, int slot,
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
@@ -263,27 +304,37 @@ static uint32_t dirty_ring_collect_one(struct kvm_dirty_gfn *dirty_gfns,
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
@@ -295,13 +346,16 @@ static void dirty_ring_collect_dirty_pages(struct kvm_vm *vm, int slot,
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
 
@@ -309,10 +363,16 @@ static void dirty_ring_after_vcpu_run(struct kvm_vm *vm)
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
@@ -337,7 +397,7 @@ struct log_mode {
 	void (*collect_dirty_pages) (struct kvm_vm *vm, int slot,
 				     void *bitmap, uint32_t num_pages);
 	/* Hook to call when after each vcpu run */
-	void (*after_vcpu_run)(struct kvm_vm *vm);
+	void (*after_vcpu_run)(struct kvm_vm *vm, int ret, int err);
 	void (*before_vcpu_join) (void);
 } log_modes[LOG_MODE_NUM] = {
 	{
@@ -409,12 +469,12 @@ static void log_mode_collect_dirty_pages(struct kvm_vm *vm, int slot,
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
@@ -435,20 +495,27 @@ static void generate_random_array(uint64_t *guest_array, uint64_t size)
 
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
@@ -594,7 +661,6 @@ static struct kvm_vm *create_vm(enum vm_guest_mode mode, uint32_t vcpuid,
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

