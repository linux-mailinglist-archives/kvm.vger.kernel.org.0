Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFE82376DA7
	for <lists+kvm@lfdr.de>; Sat,  8 May 2021 02:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbhEHA3h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 May 2021 20:29:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbhEHA3g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 May 2021 20:29:36 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12AB1C061574
        for <kvm@vger.kernel.org>; Fri,  7 May 2021 17:28:36 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id w33-20020a6349210000b029020ed5af91a4so6359114pga.14
        for <kvm@vger.kernel.org>; Fri, 07 May 2021 17:28:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=SphSvC26ZGxlBkm3BeBKNoj34ApiaYqthl3dh1p5JaA=;
        b=dwdozba0Kg9U9NaGXkRlf8+ZmY43QVsYlEd56RN0AIt9O2vMLU+P3s8uN4ZpKsY9Pu
         uN0FN9xGRXdou1j9Zo3xt/9Werr3j3DumVKd46f01vVRXofLMw7Uxk65HxKrUmCMDXzD
         VCzsoOjIT4pc3XHrw/147XtCmb6j7miL9im6CU2jUMbpyr6lxyMhV/xJLt6nqvcAsVBy
         R3UJHuDfTK/xKeu8hUtNvUWYEol84IdINKnY6wU6NsrOhxmVxN60lu13gZvWyUSXzUnM
         +umuD8BhUoBgnwj4aRgI4+7mUJL5NLJMtwbKlXBU/pG41oK9E6aEI7Zw1LsoPi65ygPB
         xQ7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=SphSvC26ZGxlBkm3BeBKNoj34ApiaYqthl3dh1p5JaA=;
        b=s5Nuomacg6eJzYrABx0EcZAOlieg/bcO8UPo5pTR/JDQ1wYw5Z31alCMpixcNbmkNo
         o437HBosVX1HAmV9Wf6O9pbb7TWYddayU4u7H41V5vWXKOg4UamaDESolZqiaDH7kkyw
         rI0Ipd5lgMZsDNrTdtQnXXKNq5NB+sVX4COsK3iXh2TFQZNqTxBQQAVOwP7VC6LGxWaM
         u7r8urVD2ppGR9PrKXaL+UNUtW3v5LlDJux3CXwDKt9CyfvIzTdi0WYyaTeALADUCYM9
         /jDAgA1e7+3nsEM+XTzo1fYIhMn6bz3xSdu398ttJpw2Z8NIIv7ESR9c7jwxgu4Ab4aF
         ohSQ==
X-Gm-Message-State: AOAM531Qf1yx/nIfnVkjLrfAlCucdpYE1PXZTqAiXL/w9AKlXT1cjp20
        Pp4Szq+MBeyHbjrdZFNtclfe9MlTh8r1gk2bMCA9leAf/+Vo6BZVM27qmIBXHeFxx70Rq+r4Nzl
        nBIRqbCeMbnTUov0Lk1eykkraMiVGThLZSgLdjpVygj+mTYMdlkCN4T5WlAOeXGM=
X-Google-Smtp-Source: ABdhPJxFiRAmqpeiaRlsjVw4wHe7AzBIJxMZn2UglcIKWAkWX9bsq06z4g2PNqxFAn/Ucifil5gPLKIe9g9GcA==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a62:25c4:0:b029:276:a40:5729 with SMTP id
 l187-20020a6225c40000b02902760a405729mr13092313pfl.80.1620433715222; Fri, 07
 May 2021 17:28:35 -0700 (PDT)
Date:   Sat,  8 May 2021 00:28:32 +0000
Message-Id: <20210508002832.759818-1-dmatlack@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.607.g51e8a6a459-goog
Subject: [PATCH v2] KVM: selftests: Print a message if /dev/kvm is missing
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
 tools/testing/selftests/kvm/lib/kvm_util.c    | 39 ++++++++++++-------
 .../selftests/kvm/lib/x86_64/processor.c      | 16 ++------
 .../kvm/x86_64/get_msr_index_features.c       |  8 +---
 4 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index a8f022794ce3..401393a8c2b7 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -77,6 +77,7 @@ struct vm_guest_mode_params {
 };
 extern const struct vm_guest_mode_params vm_guest_mode_params[];
 
+int open_kvm_dev_path_or_exit(int flags);
 int kvm_check_cap(long cap);
 int vm_enable_cap(struct kvm_vm *vm, struct kvm_enable_cap *cap);
 int vcpu_enable_cap(struct kvm_vm *vm, uint32_t vcpu_id,
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index fc83f6c5902d..10d488f83e3a 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -31,6 +31,27 @@ static void *align(void *x, size_t size)
 	return (void *) (((size_t) x + mask) & ~mask);
 }
 
+/* Open KVM_DEV_PATH if available, otherwise exit the entire program.
+ *
+ * Input Args:
+ *   flags - The flags to pass when opening KVM_DEV_PATH.
+ *
+ * Return:
+ *   The opened file descriptor of /dev/kvm.
+ */
+int open_kvm_dev_path_or_exit(int flags)
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
 /*
  * Capability
  *
@@ -52,10 +73,7 @@ int kvm_check_cap(long cap)
 	int ret;
 	int kvm_fd;
 
-	kvm_fd = open(KVM_DEV_PATH, O_RDONLY);
-	if (kvm_fd < 0)
-		exit(KSFT_SKIP);
-
+	kvm_fd = open_kvm_dev_path_or_exit(O_RDONLY);
 	ret = ioctl(kvm_fd, KVM_CHECK_EXTENSION, cap);
 	TEST_ASSERT(ret != -1, "KVM_CHECK_EXTENSION IOCTL failed,\n"
 		"  rc: %i errno: %i", ret, errno);
@@ -128,9 +146,7 @@ void vm_enable_dirty_ring(struct kvm_vm *vm, uint32_t ring_size)
 
 static void vm_open(struct kvm_vm *vm, int perm)
 {
-	vm->kvm_fd = open(KVM_DEV_PATH, perm);
-	if (vm->kvm_fd < 0)
-		exit(KSFT_SKIP);
+	vm->kvm_fd = open_kvm_dev_path_or_exit(perm);
 
 	if (!kvm_check_cap(KVM_CAP_IMMEDIATE_EXIT)) {
 		print_skip("immediate_exit not available");
@@ -925,9 +941,7 @@ static int vcpu_mmap_sz(void)
 {
 	int dev_fd, ret;
 
-	dev_fd = open(KVM_DEV_PATH, O_RDONLY);
-	if (dev_fd < 0)
-		exit(KSFT_SKIP);
+	dev_fd = open_kvm_dev_path_or_exit(O_RDONLY);
 
 	ret = ioctl(dev_fd, KVM_GET_VCPU_MMAP_SIZE, NULL);
 	TEST_ASSERT(ret >= sizeof(struct kvm_run),
@@ -2015,10 +2029,7 @@ bool vm_is_unrestricted_guest(struct kvm_vm *vm)
 
 	if (vm == NULL) {
 		/* Ensure that the KVM vendor-specific module is loaded. */
-		f = fopen(KVM_DEV_PATH, "r");
-		TEST_ASSERT(f != NULL, "Error in opening KVM dev file: %d",
-			    errno);
-		fclose(f);
+		close(open_kvm_dev_path_or_exit(O_RDONLY));
 	}
 
 	f = fopen("/sys/module/kvm_intel/parameters/unrestricted_guest", "r");
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index a8906e60a108..1ce0a37d8a89 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -657,9 +657,7 @@ struct kvm_cpuid2 *kvm_get_supported_cpuid(void)
 		return cpuid;
 
 	cpuid = allocate_kvm_cpuid2();
-	kvm_fd = open(KVM_DEV_PATH, O_RDONLY);
-	if (kvm_fd < 0)
-		exit(KSFT_SKIP);
+	kvm_fd = open_kvm_dev_path_or_exit(O_RDONLY);
 
 	ret = ioctl(kvm_fd, KVM_GET_SUPPORTED_CPUID, cpuid);
 	TEST_ASSERT(ret == 0, "KVM_GET_SUPPORTED_CPUID failed %d %d\n",
@@ -691,9 +689,7 @@ uint64_t kvm_get_feature_msr(uint64_t msr_index)
 
 	buffer.header.nmsrs = 1;
 	buffer.entry.index = msr_index;
-	kvm_fd = open(KVM_DEV_PATH, O_RDONLY);
-	if (kvm_fd < 0)
-		exit(KSFT_SKIP);
+	kvm_fd = open_kvm_dev_path_or_exit(O_RDONLY);
 
 	r = ioctl(kvm_fd, KVM_GET_MSRS, &buffer.header);
 	TEST_ASSERT(r == 1, "KVM_GET_MSRS IOCTL failed,\n"
@@ -986,9 +982,7 @@ struct kvm_msr_list *kvm_get_msr_index_list(void)
 	struct kvm_msr_list *list;
 	int nmsrs, r, kvm_fd;
 
-	kvm_fd = open(KVM_DEV_PATH, O_RDONLY);
-	if (kvm_fd < 0)
-		exit(KSFT_SKIP);
+	kvm_fd = open_kvm_dev_path_or_exit(O_RDONLY);
 
 	nmsrs = kvm_get_num_msrs_fd(kvm_fd);
 	list = malloc(sizeof(*list) + nmsrs * sizeof(list->indices[0]));
@@ -1312,9 +1306,7 @@ struct kvm_cpuid2 *kvm_get_supported_hv_cpuid(void)
 		return cpuid;
 
 	cpuid = allocate_kvm_cpuid2();
-	kvm_fd = open(KVM_DEV_PATH, O_RDONLY);
-	if (kvm_fd < 0)
-		exit(KSFT_SKIP);
+	kvm_fd = open_kvm_dev_path_or_exit(O_RDONLY);
 
 	ret = ioctl(kvm_fd, KVM_GET_SUPPORTED_HV_CPUID, cpuid);
 	TEST_ASSERT(ret == 0, "KVM_GET_SUPPORTED_HV_CPUID failed %d %d\n",
diff --git a/tools/testing/selftests/kvm/x86_64/get_msr_index_features.c b/tools/testing/selftests/kvm/x86_64/get_msr_index_features.c
index cb953df4d7d0..91373935bff6 100644
--- a/tools/testing/selftests/kvm/x86_64/get_msr_index_features.c
+++ b/tools/testing/selftests/kvm/x86_64/get_msr_index_features.c
@@ -37,9 +37,7 @@ static void test_get_msr_index(void)
 	int old_res, res, kvm_fd, r;
 	struct kvm_msr_list *list;
 
-	kvm_fd = open(KVM_DEV_PATH, O_RDONLY);
-	if (kvm_fd < 0)
-		exit(KSFT_SKIP);
+	kvm_fd = open_kvm_dev_path_or_exit(O_RDONLY);
 
 	old_res = kvm_num_index_msrs(kvm_fd, 0);
 	TEST_ASSERT(old_res != 0, "Expecting nmsrs to be > 0");
@@ -101,9 +99,7 @@ static void test_get_msr_feature(void)
 	int res, old_res, i, kvm_fd;
 	struct kvm_msr_list *feature_list;
 
-	kvm_fd = open(KVM_DEV_PATH, O_RDONLY);
-	if (kvm_fd < 0)
-		exit(KSFT_SKIP);
+	kvm_fd = open_kvm_dev_path_or_exit(O_RDONLY);
 
 	old_res = kvm_num_feature_msrs(kvm_fd, 0);
 	TEST_ASSERT(old_res != 0, "Expecting nmsrs to be > 0");
-- 
2.31.1.607.g51e8a6a459-goog

