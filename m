Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FED0376A75
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 21:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbhEGTHD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 May 2021 15:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbhEGTHD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 May 2021 15:07:03 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14A4EC061574
        for <kvm@vger.kernel.org>; Fri,  7 May 2021 12:06:02 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id l35-20020a635b630000b029020f1edbc5dfso5997549pgm.22
        for <kvm@vger.kernel.org>; Fri, 07 May 2021 12:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=ZU5o8YBMuCGWkq6Z2zz819KL/+PmcDt40fIKeJxGjYo=;
        b=mNIW3Ba3qaS/89b/hgFwdshzU3o7/8/quvZ/pP+WrBYaIYEVJFc4fpd1Y/2YUPvc0L
         IZkg0PqAUpbAy7bMF1DxpYV1SrfoAUj64PFtAU7DC+/sDZH7KadVjzO4r84CIarfA3gI
         pisNVGWQdIidxi+DdhqGbEiGbYCsPP0A/X41WTiarpx+M28nKSmiGgnosAxwlZkuIQ2R
         Y+Jxu9QvxxDE1pkSDOaY0US3DanOyK98uryPkZrNQBL7b4ZXkl4PcuDtV7+IOGW09tHD
         Eu84Rg8pPPeiDB0h6A9m2HWoUp/EnlKhOVj10YdiQ6PfrLaSj3w98uwtVr02kooZARQo
         KRHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=ZU5o8YBMuCGWkq6Z2zz819KL/+PmcDt40fIKeJxGjYo=;
        b=qkpIKNKlQoD17dL5CHUS1JfsJkTw9Gi9TNYgJrh9zWlX+oSqmVEqvATkGMUcVDBK5G
         yILPSS1r2O73MrYD2U4ZKqfNXcsAtO5/SCeyCqAJMxJpfCOFPERzfk2uoalgZQZkSj4M
         D5Hs2v7ohAo5LZaG01ITYCe7o1rwyAl1+YGa04jXpl1SqdwvtOyXzIqP9OohoHx19/+h
         nTjirGys9/hdp38OnRDCKJbwf46GgIRtaIfGUVGv2tpYyBte9ISWPGwZlu8itlmwP52p
         7zlflLr6PQ9kCxT7gLdVSS3pkWL8NSLW4Mv/wv5z0iNOxpD1XMmGgnpNf1AaQg7+HGdN
         WQ+A==
X-Gm-Message-State: AOAM530Yt10myRPQ2g2dh00ZKs5Qpz89cBrReWIJbbWz4U8mJDVm78ib
        xNIGQrNrY8pHjTb6gdyTj74VquM2O/A7v5Z3tv6hl8hDodpwkdgXo21U9riiAMUWv4ffOOWTFeM
        rtEtB7/ydTTSa6OChxXQn5qaYBUsSWR0kRiZ0hPpeUaNIB+8fwKm3+pYLSO7uL8o=
X-Google-Smtp-Source: ABdhPJzAPMcK3bt+MrIm0zgWis1JF5rwpp/dhzo84blc54eWoxqs2R0wbfUD/wz6Xp2RvQVF9C+PQq3zLGXluw==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:aa7:904e:0:b029:28f:da01:1a5f with SMTP
 id n14-20020aa7904e0000b029028fda011a5fmr11556437pfo.67.1620414361458; Fri,
 07 May 2021 12:06:01 -0700 (PDT)
Date:   Fri,  7 May 2021 19:05:59 +0000
Message-Id: <20210507190559.425518-1-dmatlack@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.607.g51e8a6a459-goog
Subject: [PATCH] KVM: selftests: Print a message if /dev/kvm is missing
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
 tools/testing/selftests/kvm/lib/kvm_util.c    | 35 +++++++++++--------
 .../selftests/kvm/lib/x86_64/processor.c      | 16 +++------
 .../kvm/x86_64/get_msr_index_features.c       |  8 ++---
 4 files changed, 28 insertions(+), 32 deletions(-)

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
index fc83f6c5902d..bb7dc65d7fb5 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -31,6 +31,23 @@ static void *align(void *x, size_t size)
 	return (void *) (((size_t) x + mask) & ~mask);
 }
 
+/* Open KVM_DEV_PATH if available, otherwise exit the entire program.
+ *
+ * Return:
+ *   The opened file descriptor of /dev/kvm.
+ */
+int open_kvm_dev_path_or_exit(void) {
+  int fd;
+
+  fd = open(KVM_DEV_PATH, O_RDONLY);
+  if (fd < 0) {
+    print_skip("%s not available", KVM_DEV_PATH);
+    exit(KSFT_SKIP);
+  }
+
+  return fd;
+}
+
 /*
  * Capability
  *
@@ -52,10 +69,7 @@ int kvm_check_cap(long cap)
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
@@ -128,9 +142,7 @@ void vm_enable_dirty_ring(struct kvm_vm *vm, uint32_t ring_size)
 
 static void vm_open(struct kvm_vm *vm, int perm)
 {
-	vm->kvm_fd = open(KVM_DEV_PATH, perm);
-	if (vm->kvm_fd < 0)
-		exit(KSFT_SKIP);
+	vm->kvm_fd = open_kvm_dev_path_or_exit();
 
 	if (!kvm_check_cap(KVM_CAP_IMMEDIATE_EXIT)) {
 		print_skip("immediate_exit not available");
@@ -925,9 +937,7 @@ static int vcpu_mmap_sz(void)
 {
 	int dev_fd, ret;
 
-	dev_fd = open(KVM_DEV_PATH, O_RDONLY);
-	if (dev_fd < 0)
-		exit(KSFT_SKIP);
+        dev_fd = open_kvm_dev_path_or_exit();
 
 	ret = ioctl(dev_fd, KVM_GET_VCPU_MMAP_SIZE, NULL);
 	TEST_ASSERT(ret >= sizeof(struct kvm_run),
@@ -2015,10 +2025,7 @@ bool vm_is_unrestricted_guest(struct kvm_vm *vm)
 
 	if (vm == NULL) {
 		/* Ensure that the KVM vendor-specific module is loaded. */
-		f = fopen(KVM_DEV_PATH, "r");
-		TEST_ASSERT(f != NULL, "Error in opening KVM dev file: %d",
-			    errno);
-		fclose(f);
+                close(open_kvm_dev_path_or_exit());
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

