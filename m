Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3519E379658
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 19:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231610AbhEJRrw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 13:47:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231187AbhEJRrv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 13:47:51 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB2A6C061761
        for <kvm@vger.kernel.org>; Mon, 10 May 2021 10:46:42 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id mw15-20020a17090b4d0fb0290157199aadbaso11815974pjb.7
        for <kvm@vger.kernel.org>; Mon, 10 May 2021 10:46:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=BFlO1gMJbRT63RTuthNx6rSz00kF87hnvs4FWUfg+4s=;
        b=gYeYufRarPQNxGNRz1sL+Qb2a0BPFSa4I/QL6G0s5UPbd1rUxl+/cXino3Koe4VK5C
         jxtYztGdGUW2eauhxOQhAb2Sk37B9dP9IPeL90uspcZ+oV/aa+6SFkKXVaqsuS/5yrIZ
         Yvaw36IwZBcFA8tcI+uVW0k2imxno51IMrg9tdcM/wJslyO+/x/pY6Ds5yyEAew6IpaN
         h9mOuSiOWwCOSXRPNumM2NhH7Nro3KcwH31jZpr3nSSzBNZAfa/SNtknP/7l4ysouKSZ
         IeDEqirYVB2OwG5p4AL3avotV3O7jVXpeO7G+4aPqOI3IIKiYYlUPWDLvNlBVa4TnCJQ
         gKFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=BFlO1gMJbRT63RTuthNx6rSz00kF87hnvs4FWUfg+4s=;
        b=R9R5ew+xDk/dLLMTnf3rkNyafC3m1887IA9MhpmLBCDQAHFWS5Ieei6xxVUKab6Eia
         ovR5580aeug+0YDsE/PmTVMZF0S+IoECUW6uVZXUdYyz+gaHzWZoXerS+qb5BSkxZ6UD
         iSHqTkoUQO5EaorIAKJKZx4Oc4RU9isN4tywD+vpwr/m0xrPIf4kjmCw9rRtKOqYtjfQ
         kFk3MFHTolXorUl15CI/Hl6XLpcYWCKvuQrCRHMZ5JZvKA5tSHM5dvHBMcQ1s5Rl1Vjw
         1CVgIAW3O0TiXfweC0Y/UW64DEZ7uqcS0ZoeZ1+uvQ+DRlEidIC4fRl9SIzf47nHd8o7
         wSfw==
X-Gm-Message-State: AOAM533HE+HRt0dWUY6FyZdghKWQ4KB56Qe6cwhOuEFSbsPygUeAqxuK
        o3ZcZL6C5gCTuaMq1nslNsLEEcN8xURwqq8oS/t7PtICPlckC+/ePdb2wh+et+Ben7OLgmT4C0L
        KQMdXBtzVVjzfuXwQsWgV8pTHPsWJKz7q8po4uWHmwYiGxE3aoKU142nyE+AiAQw=
X-Google-Smtp-Source: ABdhPJx7KA+U/Cn5I6doSCk+a0suPvjTs5rgYa3oxEoctKrDzh0Qv7OSpOXOunz9ifQyiBQe1gb4zfLmIHbg+A==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a62:8c45:0:b029:272:e091:cda5 with SMTP
 id m66-20020a628c450000b0290272e091cda5mr25875205pfd.59.1620668802302; Mon,
 10 May 2021 10:46:42 -0700 (PDT)
Date:   Mon, 10 May 2021 17:46:39 +0000
Message-Id: <20210510174639.1130344-1-dmatlack@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.607.g51e8a6a459-goog
Subject: [PATCH v3] KVM: selftests: Print a message if /dev/kvm is missing
From:   David Matlack <dmatlack@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If a KVM selftest is run on a machine without /dev/kvm, it will exit
silently. Make it easy to tell what's happening by printing an error
message.

Opportunistically consolidate all codepaths that open /dev/kvm into a
single function so they all print the same message.

This slightly changes the semantics of vm_is_unrestricted_guest() by
changing a TEST_ASSERT() to exit(KSFT_SKIP). However
vm_is_unrestricted_guest() is only called in one place
(x86_64/mmio_warning_test.c) and that is to determine if the test should
be skipped or not.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../testing/selftests/kvm/include/kvm_util.h  |  1 +
 tools/testing/selftests/kvm/lib/kvm_util.c    | 45 +++++++++++++------
 .../selftests/kvm/lib/x86_64/processor.c      | 16 ++-----
 .../kvm/x86_64/get_msr_index_features.c       |  8 +---
 4 files changed, 38 insertions(+), 32 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index a8f022794ce3..84982eb02b29 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -77,6 +77,7 @@ struct vm_guest_mode_params {
 };
 extern const struct vm_guest_mode_params vm_guest_mode_params[];
 
+int open_kvm_dev_path_or_exit(void);
 int kvm_check_cap(long cap);
 int vm_enable_cap(struct kvm_vm *vm, struct kvm_enable_cap *cap);
 int vcpu_enable_cap(struct kvm_vm *vm, uint32_t vcpu_id,
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index fc83f6c5902d..e53f4c0953dc 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -31,6 +31,33 @@ static void *align(void *x, size_t size)
 	return (void *) (((size_t) x + mask) & ~mask);
 }
 
+/*
+ * Open KVM_DEV_PATH if available, otherwise exit the entire program.
+ *
+ * Input Args:
+ *   flags - The flags to pass when opening KVM_DEV_PATH.
+ *
+ * Return:
+ *   The opened file descriptor of /dev/kvm.
+ */
+int _open_kvm_dev_path_or_exit(int flags)
+{
+	int fd;
+
+	fd = open(KVM_DEV_PATH, flags);
+	if (fd < 0) {
+		print_skip("%s not available", KVM_DEV_PATH);
+		exit(KSFT_SKIP);
+	}
+
+	return fd;
+}
+
+int open_kvm_dev_path_or_exit(void)
+{
+	return _open_kvm_dev_path_or_exit(O_RDONLY);
+}
+
 /*
  * Capability
  *
@@ -52,10 +79,7 @@ int kvm_check_cap(long cap)
 	int ret;
 	int kvm_fd;
 
-	kvm_fd = open(KVM_DEV_PATH, O_RDONLY);
-	if (kvm_fd < 0)
-		exit(KSFT_SKIP);
-
+	kvm_fd = open_kvm_dev_path_or_exit();
 	ret = ioctl(kvm_fd, KVM_CHECK_EXTENSION, cap);
 	TEST_ASSERT(ret != -1, "KVM_CHECK_EXTENSION IOCTL failed,\n"
 		"  rc: %i errno: %i", ret, errno);
@@ -128,9 +152,7 @@ void vm_enable_dirty_ring(struct kvm_vm *vm, uint32_t ring_size)
 
 static void vm_open(struct kvm_vm *vm, int perm)
 {
-	vm->kvm_fd = open(KVM_DEV_PATH, perm);
-	if (vm->kvm_fd < 0)
-		exit(KSFT_SKIP);
+	vm->kvm_fd = _open_kvm_dev_path_or_exit(perm);
 
 	if (!kvm_check_cap(KVM_CAP_IMMEDIATE_EXIT)) {
 		print_skip("immediate_exit not available");
@@ -925,9 +947,7 @@ static int vcpu_mmap_sz(void)
 {
 	int dev_fd, ret;
 
-	dev_fd = open(KVM_DEV_PATH, O_RDONLY);
-	if (dev_fd < 0)
-		exit(KSFT_SKIP);
+	dev_fd = open_kvm_dev_path_or_exit();
 
 	ret = ioctl(dev_fd, KVM_GET_VCPU_MMAP_SIZE, NULL);
 	TEST_ASSERT(ret >= sizeof(struct kvm_run),
@@ -2015,10 +2035,7 @@ bool vm_is_unrestricted_guest(struct kvm_vm *vm)
 
 	if (vm == NULL) {
 		/* Ensure that the KVM vendor-specific module is loaded. */
-		f = fopen(KVM_DEV_PATH, "r");
-		TEST_ASSERT(f != NULL, "Error in opening KVM dev file: %d",
-			    errno);
-		fclose(f);
+		close(open_kvm_dev_path_or_exit());
 	}
 
 	f = fopen("/sys/module/kvm_intel/parameters/unrestricted_guest", "r");
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index a8906e60a108..efe235044421 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -657,9 +657,7 @@ struct kvm_cpuid2 *kvm_get_supported_cpuid(void)
 		return cpuid;
 
 	cpuid = allocate_kvm_cpuid2();
-	kvm_fd = open(KVM_DEV_PATH, O_RDONLY);
-	if (kvm_fd < 0)
-		exit(KSFT_SKIP);
+	kvm_fd = open_kvm_dev_path_or_exit();
 
 	ret = ioctl(kvm_fd, KVM_GET_SUPPORTED_CPUID, cpuid);
 	TEST_ASSERT(ret == 0, "KVM_GET_SUPPORTED_CPUID failed %d %d\n",
@@ -691,9 +689,7 @@ uint64_t kvm_get_feature_msr(uint64_t msr_index)
 
 	buffer.header.nmsrs = 1;
 	buffer.entry.index = msr_index;
-	kvm_fd = open(KVM_DEV_PATH, O_RDONLY);
-	if (kvm_fd < 0)
-		exit(KSFT_SKIP);
+	kvm_fd = open_kvm_dev_path_or_exit();
 
 	r = ioctl(kvm_fd, KVM_GET_MSRS, &buffer.header);
 	TEST_ASSERT(r == 1, "KVM_GET_MSRS IOCTL failed,\n"
@@ -986,9 +982,7 @@ struct kvm_msr_list *kvm_get_msr_index_list(void)
 	struct kvm_msr_list *list;
 	int nmsrs, r, kvm_fd;
 
-	kvm_fd = open(KVM_DEV_PATH, O_RDONLY);
-	if (kvm_fd < 0)
-		exit(KSFT_SKIP);
+	kvm_fd = open_kvm_dev_path_or_exit();
 
 	nmsrs = kvm_get_num_msrs_fd(kvm_fd);
 	list = malloc(sizeof(*list) + nmsrs * sizeof(list->indices[0]));
@@ -1312,9 +1306,7 @@ struct kvm_cpuid2 *kvm_get_supported_hv_cpuid(void)
 		return cpuid;
 
 	cpuid = allocate_kvm_cpuid2();
-	kvm_fd = open(KVM_DEV_PATH, O_RDONLY);
-	if (kvm_fd < 0)
-		exit(KSFT_SKIP);
+	kvm_fd = open_kvm_dev_path_or_exit();
 
 	ret = ioctl(kvm_fd, KVM_GET_SUPPORTED_HV_CPUID, cpuid);
 	TEST_ASSERT(ret == 0, "KVM_GET_SUPPORTED_HV_CPUID failed %d %d\n",
diff --git a/tools/testing/selftests/kvm/x86_64/get_msr_index_features.c b/tools/testing/selftests/kvm/x86_64/get_msr_index_features.c
index cb953df4d7d0..8aed0db1331d 100644
--- a/tools/testing/selftests/kvm/x86_64/get_msr_index_features.c
+++ b/tools/testing/selftests/kvm/x86_64/get_msr_index_features.c
@@ -37,9 +37,7 @@ static void test_get_msr_index(void)
 	int old_res, res, kvm_fd, r;
 	struct kvm_msr_list *list;
 
-	kvm_fd = open(KVM_DEV_PATH, O_RDONLY);
-	if (kvm_fd < 0)
-		exit(KSFT_SKIP);
+	kvm_fd = open_kvm_dev_path_or_exit();
 
 	old_res = kvm_num_index_msrs(kvm_fd, 0);
 	TEST_ASSERT(old_res != 0, "Expecting nmsrs to be > 0");
@@ -101,9 +99,7 @@ static void test_get_msr_feature(void)
 	int res, old_res, i, kvm_fd;
 	struct kvm_msr_list *feature_list;
 
-	kvm_fd = open(KVM_DEV_PATH, O_RDONLY);
-	if (kvm_fd < 0)
-		exit(KSFT_SKIP);
+	kvm_fd = open_kvm_dev_path_or_exit();
 
 	old_res = kvm_num_feature_msrs(kvm_fd, 0);
 	TEST_ASSERT(old_res != 0, "Expecting nmsrs to be > 0");
-- 
2.31.1.607.g51e8a6a459-goog

