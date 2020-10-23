Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51B4C29771A
	for <lists+kvm@lfdr.de>; Fri, 23 Oct 2020 20:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1755030AbgJWSfQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Oct 2020 14:35:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49066 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754908AbgJWSeZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Oct 2020 14:34:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603478064;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KiD3PSm1HruAcyGWQFTaD4JNh5HqjFztRdyDy4Rmc8s=;
        b=a1mFPz/K9F5Gay7Z9kiJooDU4kqGRU3BaxnVjUgI+RrxPdPPtz15ekOiBcEwIcMys2sIXn
        MoC/ceSRxpOLXnhLd5exbdVCVA0NiekArQpT0qz5JTr65Y5rGGS0v+4/Qd7F0MkgZcKDsf
        OVJniidyyfV5m5lU5n8QXYMjmLx6QX4=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-596-_9d0sJ17OuyrmgAvg3sxQw-1; Fri, 23 Oct 2020 14:34:22 -0400
X-MC-Unique: _9d0sJ17OuyrmgAvg3sxQw-1
Received: by mail-qk1-f198.google.com with SMTP id a81so1620744qkg.10
        for <kvm@vger.kernel.org>; Fri, 23 Oct 2020 11:34:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KiD3PSm1HruAcyGWQFTaD4JNh5HqjFztRdyDy4Rmc8s=;
        b=Eu1SS3ReSU0dGO4IQbuxemQpNeu+hFeJUJviOndm8glYmiZVSu2gQRqXcksPx94uxu
         i9K0QRSX9nIGA/Mo6lrHvz2jZAR2CuGgvP4ulwsO7Zh7cdHx5Jwj+Mu0zjAmVJU6hHwk
         xbY2EOsJzT+HS9HFJqIn7/iux2M2fyq3td+4RVX46Fi9DNGX0m6zabnLLsV6IOZVAf6j
         uBNOl+2CYgZMgt4oCkLfwthl4+Y+DxRhuYXoaEVYW3KIkSt/2QsNrba6jSZpSUbiANbP
         W79iUMl18dUIZKJQ7YT4yv4prNkC+NVxsiswMCGif2r967Y5y7zoH4M4WZMuePfqZIA+
         7HUA==
X-Gm-Message-State: AOAM5305DxWPIvUi67Z2iWTryAlIpUFQlllHGKfk4pXTrqwy/GDxqkOe
        0lCT4yqcz8fL4jzm1xWF80NQuMwQivem3OJYuVPLboIu9Q6xaGoDgaNyDMMagbt+ldhuDlW9xgS
        veYs4KgjbvxWH
X-Received: by 2002:a37:a304:: with SMTP id m4mr3483133qke.287.1603478061785;
        Fri, 23 Oct 2020 11:34:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwbpQ/SHS0znI/WhM/AqDQ7dMUnKRKh7xLa9Xn567EdPeAq6V4vzO0vevfhdQcdFpbe4GnWeQ==
X-Received: by 2002:a37:a304:: with SMTP id m4mr3483109qke.287.1603478061480;
        Fri, 23 Oct 2020 11:34:21 -0700 (PDT)
Received: from xz-x1.redhat.com (toroon474qw-lp140-04-174-95-215-133.dsl.bell.ca. [174.95.215.133])
        by smtp.gmail.com with ESMTPSA id u11sm1490407qtk.61.2020.10.23.11.34.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2020 11:34:20 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        peterx@redhat.com, Andrew Jones <drjones@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v15 10/14] KVM: selftests: Use a single binary for dirty/clear log test
Date:   Fri, 23 Oct 2020 14:33:54 -0400
Message-Id: <20201023183358.50607-11-peterx@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201023183358.50607-1-peterx@redhat.com>
References: <20201023183358.50607-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove the clear_dirty_log test, instead merge it into the existing
dirty_log_test.  It should be cleaner to use this single binary to do
both tests, also it's a preparation for the upcoming dirty ring test.

The default behavior will run all the modes in sequence.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 tools/testing/selftests/kvm/Makefile          |   2 -
 .../selftests/kvm/clear_dirty_log_test.c      |   6 -
 tools/testing/selftests/kvm/dirty_log_test.c  | 187 +++++++++++++++---
 3 files changed, 156 insertions(+), 39 deletions(-)
 delete mode 100644 tools/testing/selftests/kvm/clear_dirty_log_test.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 7ebe71fbca53..47b998f090ef 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -57,14 +57,12 @@ TEST_GEN_PROGS_x86_64 += x86_64/xss_msr_test
 TEST_GEN_PROGS_x86_64 += x86_64/debug_regs
 TEST_GEN_PROGS_x86_64 += x86_64/tsc_msrs_test
 TEST_GEN_PROGS_x86_64 += x86_64/user_msr_test
-TEST_GEN_PROGS_x86_64 += clear_dirty_log_test
 TEST_GEN_PROGS_x86_64 += demand_paging_test
 TEST_GEN_PROGS_x86_64 += dirty_log_test
 TEST_GEN_PROGS_x86_64 += kvm_create_max_vcpus
 TEST_GEN_PROGS_x86_64 += set_memory_region_test
 TEST_GEN_PROGS_x86_64 += steal_time
 
-TEST_GEN_PROGS_aarch64 += clear_dirty_log_test
 TEST_GEN_PROGS_aarch64 += demand_paging_test
 TEST_GEN_PROGS_aarch64 += dirty_log_test
 TEST_GEN_PROGS_aarch64 += kvm_create_max_vcpus
diff --git a/tools/testing/selftests/kvm/clear_dirty_log_test.c b/tools/testing/selftests/kvm/clear_dirty_log_test.c
deleted file mode 100644
index 11672ec6f74e..000000000000
--- a/tools/testing/selftests/kvm/clear_dirty_log_test.c
+++ /dev/null
@@ -1,6 +0,0 @@
-#define USE_CLEAR_DIRTY_LOG
-#define KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE (1 << 0)
-#define KVM_DIRTY_LOG_INITIALLY_SET         (1 << 1)
-#define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
-		KVM_DIRTY_LOG_INITIALLY_SET)
-#include "dirty_log_test.c"
diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 6a8275a22861..139ccb550618 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -128,6 +128,78 @@ static uint64_t host_dirty_count;
 static uint64_t host_clear_count;
 static uint64_t host_track_next_count;
 
+enum log_mode_t {
+	/* Only use KVM_GET_DIRTY_LOG for logging */
+	LOG_MODE_DIRTY_LOG = 0,
+
+	/* Use both KVM_[GET|CLEAR]_DIRTY_LOG for logging */
+	LOG_MODE_CLEAR_LOG = 1,
+
+	LOG_MODE_NUM,
+
+	/* Run all supported modes */
+	LOG_MODE_ALL = LOG_MODE_NUM,
+};
+
+/* Mode of logging to test.  Default is to run all supported modes */
+static enum log_mode_t host_log_mode_option = LOG_MODE_ALL;
+/* Logging mode for current run */
+static enum log_mode_t host_log_mode;
+
+static bool clear_log_supported(void)
+{
+	return kvm_check_cap(KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2);
+}
+
+static void clear_log_create_vm_done(struct kvm_vm *vm)
+{
+	struct kvm_enable_cap cap = {};
+	u64 manual_caps;
+
+	manual_caps = kvm_check_cap(KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2);
+	TEST_ASSERT(manual_caps, "MANUAL_CAPS is zero!");
+	manual_caps &= (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE |
+			KVM_DIRTY_LOG_INITIALLY_SET);
+	cap.cap = KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2;
+	cap.args[0] = manual_caps;
+	vm_enable_cap(vm, &cap);
+}
+
+static void dirty_log_collect_dirty_pages(struct kvm_vm *vm, int slot,
+					  void *bitmap, uint32_t num_pages)
+{
+	kvm_vm_get_dirty_log(vm, slot, bitmap);
+}
+
+static void clear_log_collect_dirty_pages(struct kvm_vm *vm, int slot,
+					  void *bitmap, uint32_t num_pages)
+{
+	kvm_vm_get_dirty_log(vm, slot, bitmap);
+	kvm_vm_clear_dirty_log(vm, slot, bitmap, 0, num_pages);
+}
+
+struct log_mode {
+	const char *name;
+	/* Return true if this mode is supported, otherwise false */
+	bool (*supported)(void);
+	/* Hook when the vm creation is done (before vcpu creation) */
+	void (*create_vm_done)(struct kvm_vm *vm);
+	/* Hook to collect the dirty pages into the bitmap provided */
+	void (*collect_dirty_pages) (struct kvm_vm *vm, int slot,
+				     void *bitmap, uint32_t num_pages);
+} log_modes[LOG_MODE_NUM] = {
+	{
+		.name = "dirty-log",
+		.collect_dirty_pages = dirty_log_collect_dirty_pages,
+	},
+	{
+		.name = "clear-log",
+		.supported = clear_log_supported,
+		.create_vm_done = clear_log_create_vm_done,
+		.collect_dirty_pages = clear_log_collect_dirty_pages,
+	},
+};
+
 /*
  * We use this bitmap to track some pages that should have its dirty
  * bit set in the _next_ iteration.  For example, if we detected the
@@ -137,6 +209,44 @@ static uint64_t host_track_next_count;
  */
 static unsigned long *host_bmap_track;
 
+static void log_modes_dump(void)
+{
+	int i;
+
+	printf("all");
+	for (i = 0; i < LOG_MODE_NUM; i++)
+		printf(", %s", log_modes[i].name);
+	printf("\n");
+}
+
+static bool log_mode_supported(void)
+{
+	struct log_mode *mode = &log_modes[host_log_mode];
+
+	if (mode->supported)
+		return mode->supported();
+
+	return true;
+}
+
+static void log_mode_create_vm_done(struct kvm_vm *vm)
+{
+	struct log_mode *mode = &log_modes[host_log_mode];
+
+	if (mode->create_vm_done)
+		mode->create_vm_done(vm);
+}
+
+static void log_mode_collect_dirty_pages(struct kvm_vm *vm, int slot,
+					 void *bitmap, uint32_t num_pages)
+{
+	struct log_mode *mode = &log_modes[host_log_mode];
+
+	TEST_ASSERT(mode->collect_dirty_pages != NULL,
+		    "collect_dirty_pages() is required for any log mode!");
+	mode->collect_dirty_pages(vm, slot, bitmap, num_pages);
+}
+
 static void generate_random_array(uint64_t *guest_array, uint64_t size)
 {
 	uint64_t i;
@@ -257,6 +367,7 @@ static struct kvm_vm *create_vm(enum vm_guest_mode mode, uint32_t vcpuid,
 #ifdef __x86_64__
 	vm_create_irqchip(vm);
 #endif
+	log_mode_create_vm_done(vm);
 	vm_vcpu_add_default(vm, vcpuid, guest_code);
 	return vm;
 }
@@ -264,10 +375,6 @@ static struct kvm_vm *create_vm(enum vm_guest_mode mode, uint32_t vcpuid,
 #define DIRTY_MEM_BITS 30 /* 1G */
 #define PAGE_SHIFT_4K  12
 
-#ifdef USE_CLEAR_DIRTY_LOG
-static u64 dirty_log_manual_caps;
-#endif
-
 static void run_test(enum vm_guest_mode mode, unsigned long iterations,
 		     unsigned long interval, uint64_t phys_offset)
 {
@@ -275,6 +382,12 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
 	struct kvm_vm *vm;
 	unsigned long *bmap;
 
+	if (!log_mode_supported()) {
+		print_skip("Log mode '%s' not supported",
+			   log_modes[host_log_mode].name);
+		return;
+	}
+
 	/*
 	 * We reserve page table for 2 times of extra dirty mem which
 	 * will definitely cover the original (1G+) test range.  Here
@@ -317,14 +430,6 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
 	bmap = bitmap_alloc(host_num_pages);
 	host_bmap_track = bitmap_alloc(host_num_pages);
 
-#ifdef USE_CLEAR_DIRTY_LOG
-	struct kvm_enable_cap cap = {};
-
-	cap.cap = KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2;
-	cap.args[0] = dirty_log_manual_caps;
-	vm_enable_cap(vm, &cap);
-#endif
-
 	/* Add an extra memory slot for testing dirty logging */
 	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
 				    guest_test_phys_mem,
@@ -362,11 +467,8 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
 	while (iteration < iterations) {
 		/* Give the vcpu thread some time to dirty some pages */
 		usleep(interval * 1000);
-		kvm_vm_get_dirty_log(vm, TEST_MEM_SLOT_INDEX, bmap);
-#ifdef USE_CLEAR_DIRTY_LOG
-		kvm_vm_clear_dirty_log(vm, TEST_MEM_SLOT_INDEX, bmap, 0,
-				       host_num_pages);
-#endif
+		log_mode_collect_dirty_pages(vm, TEST_MEM_SLOT_INDEX,
+					     bmap, host_num_pages);
 		vm_dirty_log_verify(mode, bmap);
 		iteration++;
 		sync_global_to_guest(vm, iteration);
@@ -410,6 +512,9 @@ static void help(char *name)
 	       TEST_HOST_LOOP_INTERVAL);
 	printf(" -p: specify guest physical test memory offset\n"
 	       "     Warning: a low offset can conflict with the loaded test code.\n");
+	printf(" -M: specify the host logging mode "
+	       "(default: run all log modes).  Supported modes: \n\t");
+	log_modes_dump();
 	printf(" -m: specify the guest mode ID to test "
 	       "(default: test all supported modes)\n"
 	       "     This option may be used multiple times.\n"
@@ -429,18 +534,7 @@ int main(int argc, char *argv[])
 	bool mode_selected = false;
 	uint64_t phys_offset = 0;
 	unsigned int mode;
-	int opt, i;
-
-#ifdef USE_CLEAR_DIRTY_LOG
-	dirty_log_manual_caps =
-		kvm_check_cap(KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2);
-	if (!dirty_log_manual_caps) {
-		print_skip("KVM_CLEAR_DIRTY_LOG not available");
-		exit(KSFT_SKIP);
-	}
-	dirty_log_manual_caps &= (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE |
-				  KVM_DIRTY_LOG_INITIALLY_SET);
-#endif
+	int opt, i, j;
 
 #ifdef __x86_64__
 	guest_mode_init(VM_MODE_PXXV48_4K, true, true);
@@ -464,7 +558,7 @@ int main(int argc, char *argv[])
 	guest_mode_init(VM_MODE_P40V48_4K, true, true);
 #endif
 
-	while ((opt = getopt(argc, argv, "hi:I:p:m:")) != -1) {
+	while ((opt = getopt(argc, argv, "hi:I:p:m:M:")) != -1) {
 		switch (opt) {
 		case 'i':
 			iterations = strtol(optarg, NULL, 10);
@@ -486,6 +580,26 @@ int main(int argc, char *argv[])
 				    "Guest mode ID %d too big", mode);
 			guest_modes[mode].enabled = true;
 			break;
+		case 'M':
+			if (!strcmp(optarg, "all")) {
+				host_log_mode_option = LOG_MODE_ALL;
+				break;
+			}
+			for (i = 0; i < LOG_MODE_NUM; i++) {
+				if (!strcmp(optarg, log_modes[i].name)) {
+					pr_info("Setting log mode to: '%s'\n",
+						optarg);
+					host_log_mode_option = i;
+					break;
+				}
+			}
+			if (i == LOG_MODE_NUM) {
+				printf("Log mode '%s' invalid. Please choose "
+				       "from: ", optarg);
+				log_modes_dump();
+				exit(1);
+			}
+			break;
 		case 'h':
 		default:
 			help(argv[0]);
@@ -507,7 +621,18 @@ int main(int argc, char *argv[])
 		TEST_ASSERT(guest_modes[i].supported,
 			    "Guest mode ID %d (%s) not supported.",
 			    i, vm_guest_mode_string(i));
-		run_test(i, iterations, interval, phys_offset);
+		if (host_log_mode_option == LOG_MODE_ALL) {
+			/* Run each log mode */
+			for (j = 0; j < LOG_MODE_NUM; j++) {
+				pr_info("Testing Log Mode '%s'\n",
+					log_modes[j].name);
+				host_log_mode = j;
+				run_test(i, iterations, interval, phys_offset);
+			}
+		} else {
+			host_log_mode = host_log_mode_option;
+			run_test(i, iterations, interval, phys_offset);
+		}
 	}
 
 	return 0;
-- 
2.26.2

