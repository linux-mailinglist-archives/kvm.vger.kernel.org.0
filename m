Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD6C508E87
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 19:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381209AbiDTRid (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 13:38:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381185AbiDTRiW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 13:38:22 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B488120182
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 10:35:35 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id w3-20020a17090ac98300b001b8b914e91aso1252738pjt.0
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 10:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=t1qdKpsCnPq2yg+IbIgoIM3FH9J2c/2rFr+NjJBX138=;
        b=BzLL3VXYf4ndvrHhCti6YaW7JZJj5Xv+KCCU2qP47itKN60iWZzI8RSw4m00HDsxNQ
         gdguMcmVFq/ktoIGahb5zRZ/zN3VZSkPbNKlQmUkz4d0B14tMaNz/zFWgXBN14mWJ4Km
         Fg8REazcd4iTQv3+DfYRhntLs/GqnqCVHBXwfgzS4NtW7NB9WRlwtGij3TLSWtZr9KsL
         tVJZxrSslYjS30KCQl1Blzwuk7VHs4d6KJXBoWClwPpWBDfM8dGxTTI0y2AyTdktVKCn
         MR0sOE571B5LSNNErWqRA9K8eJrIDfXQvF3nU9b8tE3jVrhCvoeCH4VMiMLW0Gmtu4Sv
         9qbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=t1qdKpsCnPq2yg+IbIgoIM3FH9J2c/2rFr+NjJBX138=;
        b=YJpeMx0NBK4n1CZ24HIWCb1fXBJvdTvI5udEEZR9OqkHRL00dBiehUq9uGULSF4nZR
         CtmaSvnDfUFfRBmxcNau9NNDX9J20TR2wkE2/k6fPas8smPtJDG4rf4yBbrcuZKMtc7j
         blUhxMEPfkywW38GRqMxayAFEzdxmw5AlOfbwGFv850rw4AoEmcTQT1x7VJFWVhfChBv
         Zd/cZ8lodFq5N4x0BZ4QHTQ8kTmFAmIJBDIO2XW1tM16yNFAXNzHXKcSXlJtt0nf4/p6
         b8IS/Mmidveh2ZVjJlLpXRiez3fzihCoLujt4+cRUOCg9Ztu7noDtoLGrNWKckc1RVbU
         Ms3g==
X-Gm-Message-State: AOAM5335JbxpJ+3WzIxnkeLK/z2xu8746hvzl8gUln0hfXI5pat67TrG
        yzFevZAyu/HcCJOIDwa4/Z654Nbjdl35
X-Google-Smtp-Source: ABdhPJyIPe8Zwza+xW/aDTMdJP2bDzL1LCb4zN48ZpvL5g0mQxKhr/6n1V2w1tLSW7XWdrXysAKEchMVMTC2
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:6ea6:489a:aad6:761c])
 (user=bgardon job=sendgmr) by 2002:a05:6a00:ad0:b0:4e1:2d96:2ab0 with SMTP id
 c16-20020a056a000ad000b004e12d962ab0mr24396722pfl.3.1650476135250; Wed, 20
 Apr 2022 10:35:35 -0700 (PDT)
Date:   Wed, 20 Apr 2022 10:35:13 -0700
In-Reply-To: <20220420173513.1217360-1-bgardon@google.com>
Message-Id: <20220420173513.1217360-11-bgardon@google.com>
Mime-Version: 1.0
References: <20220420173513.1217360-1-bgardon@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v6 10/10] KVM: selftests: Test disabling NX hugepages on a VM
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add an argument to the NX huge pages test to test disabling the feature
on a VM using the new capability.

Reviewed-by: David Matlack <dmatlack@google.com>
Signed-off-by: Ben Gardon <bgardon@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     |  2 +
 tools/testing/selftests/kvm/lib/kvm_util.c    | 16 +++-
 .../selftests/kvm/x86_64/nx_huge_pages_test.c | 75 +++++++++++++++----
 .../kvm/x86_64/nx_huge_pages_test.sh          | 39 ++++++----
 4 files changed, 104 insertions(+), 28 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 1dac3c6607f1..8f6aad253392 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -414,4 +414,6 @@ uint64_t vm_get_stat(struct kvm_vm *vm, const char *stat_name);
 
 uint32_t guest_get_vcpuid(void);
 
+int vm_disable_nx_huge_pages(struct kvm_vm *vm);
+
 #endif /* SELFTEST_KVM_UTIL_BASE_H */
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 392abd3c323d..96faa14f4f32 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -112,6 +112,11 @@ int vm_check_cap(struct kvm_vm *vm, long cap)
 	return ret;
 }
 
+static int __vm_enable_cap(struct kvm_vm *vm, struct kvm_enable_cap *cap)
+{
+	return ioctl(vm->fd, KVM_ENABLE_CAP, cap);
+}
+
 /* VM Enable Capability
  *
  * Input Args:
@@ -128,7 +133,7 @@ int vm_enable_cap(struct kvm_vm *vm, struct kvm_enable_cap *cap)
 {
 	int ret;
 
-	ret = ioctl(vm->fd, KVM_ENABLE_CAP, cap);
+	ret = __vm_enable_cap(vm, cap);
 	TEST_ASSERT(ret == 0, "KVM_ENABLE_CAP IOCTL failed,\n"
 		"  rc: %i errno: %i", ret, errno);
 
@@ -2756,3 +2761,12 @@ uint64_t vm_get_stat(struct kvm_vm *vm, const char *stat_name)
 		    stat_name, ret);
 	return data;
 }
+
+int vm_disable_nx_huge_pages(struct kvm_vm *vm)
+{
+	struct kvm_enable_cap cap = { 0 };
+
+	cap.cap = KVM_CAP_VM_DISABLE_NX_HUGE_PAGES;
+	cap.args[0] = 0;
+	return __vm_enable_cap(vm, &cap);
+}
diff --git a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
index 1c14368500b7..41b228b8cac3 100644
--- a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
+++ b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
@@ -13,6 +13,8 @@
 #include <fcntl.h>
 #include <stdint.h>
 #include <time.h>
+#include <linux/reboot.h>
+#include <sys/syscall.h>
 
 #include <test_util.h>
 #include "kvm_util.h"
@@ -86,18 +88,45 @@ static void check_split_count(struct kvm_vm *vm, int expected_splits)
 		    expected_splits, actual_splits);
 }
 
-int main(int argc, char **argv)
+void run_test(bool disable_nx_huge_pages)
 {
 	struct kvm_vm *vm;
 	struct timespec ts;
+	uint64_t pages;
 	void *hva;
-
-	if (argc != 2 || strtol(argv[1], NULL, 0) != MAGIC_TOKEN) {
-		printf("This test must be run through nx_huge_pages_test.sh");
-		return KSFT_SKIP;
+	int r;
+
+	pages = vm_pages_needed(VM_MODE_DEFAULT, 1, DEFAULT_GUEST_PHY_PAGES,
+				0, 0);
+	vm = vm_create_without_vcpus(VM_MODE_DEFAULT, pages);
+
+	if (disable_nx_huge_pages) {
+		kvm_check_cap(KVM_CAP_VM_DISABLE_NX_HUGE_PAGES);
+
+		/*
+		 * Check if this process has the reboot permissions needed to
+		 * disable NX huge pages on a VM.
+		 *
+		 * The reboot call below will never have any effect because
+		 * the magic values are not set correctly, however the
+		 * permission check is done before the magic value check.
+		 */
+		r = syscall(SYS_reboot, 0, 0, 0, NULL);
+		if (r && errno == EPERM) {
+			r = vm_disable_nx_huge_pages(vm);
+			TEST_ASSERT(errno == EPERM,
+				    "This process should not have permission to disable NX huge pages");
+			return;
+		}
+
+		TEST_ASSERT(r && errno == EINVAL,
+			    "Reboot syscall should fail with -EINVAL");
+
+		r = vm_disable_nx_huge_pages(vm);
+		TEST_ASSERT(!r, "Disabling NX huge pages should succeed if process has reboot permissions");
 	}
 
-	vm = vm_create_default(0, 0, guest_code);
+	vm_vcpu_add_default(vm, 0, guest_code);
 
 	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS_HUGETLB,
 				    HPAGE_GPA, HPAGE_SLOT,
@@ -130,23 +159,27 @@ int main(int argc, char **argv)
 	/*
 	 * Next, the guest will execute from the first huge page, causing it
 	 * to be remapped at 4k.
+	 *
+	 * If NX huge pages are disabled, this should have no effect.
 	 */
 	vcpu_run(vm, 0);
-	check_2m_page_count(vm, 1);
-	check_split_count(vm, 1);
+	check_2m_page_count(vm, disable_nx_huge_pages ? 2 : 1);
+	check_split_count(vm, disable_nx_huge_pages ? 0 : 1);
 
 	/*
 	 * Executing from the third huge page (previously unaccessed) will
 	 * cause part to be mapped at 4k.
+	 *
+	 * If NX huge pages are disabled, it should be mapped at 2M.
 	 */
 	vcpu_run(vm, 0);
-	check_2m_page_count(vm, 1);
-	check_split_count(vm, 2);
+	check_2m_page_count(vm, disable_nx_huge_pages ? 3 : 1);
+	check_split_count(vm, disable_nx_huge_pages ? 0 : 2);
 
 	/* Reading from the first huge page again should have no effect. */
 	vcpu_run(vm, 0);
-	check_2m_page_count(vm, 1);
-	check_split_count(vm, 2);
+	check_2m_page_count(vm, disable_nx_huge_pages ? 3 : 1);
+	check_split_count(vm, disable_nx_huge_pages ? 0 : 2);
 
 	/*
 	 * Give recovery thread time to run. The wrapper script sets
@@ -158,8 +191,11 @@ int main(int argc, char **argv)
 
 	/*
 	 * Now that the reclaimer has run, all the split pages should be gone.
+	 *
+	 * If NX huge pages are disabled, the relaimer will not run, so
+	 * nothing should change from here on.
 	 */
-	check_2m_page_count(vm, 1);
+	check_2m_page_count(vm, disable_nx_huge_pages ? 3 : 1);
 	check_split_count(vm, 0);
 
 	/*
@@ -167,10 +203,21 @@ int main(int argc, char **argv)
 	 * reading from it causes a huge page mapping to be installed.
 	 */
 	vcpu_run(vm, 0);
-	check_2m_page_count(vm, 2);
+	check_2m_page_count(vm, disable_nx_huge_pages ? 3 : 2);
 	check_split_count(vm, 0);
 
 	kvm_vm_free(vm);
+}
+
+int main(int argc, char **argv)
+{
+	if (argc != 2 || strtol(argv[1], NULL, 0) != MAGIC_TOKEN) {
+		printf("This test must be run through nx_huge_pages_test.sh");
+		return KSFT_SKIP;
+	}
+
+	run_test(false);
+	run_test(true);
 
 	return 0;
 }
diff --git a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh
index c2429ad8066a..b23993f3aab1 100755
--- a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh
+++ b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh
@@ -4,22 +4,35 @@
 # tools/testing/selftests/kvm/nx_huge_page_test.sh
 # Copyright (C) 2022, Google LLC.
 
-NX_HUGE_PAGES=$(cat /sys/module/kvm/parameters/nx_huge_pages)
-NX_HUGE_PAGES_RECOVERY_RATIO=$(cat /sys/module/kvm/parameters/nx_huge_pages_recovery_ratio)
-NX_HUGE_PAGES_RECOVERY_PERIOD=$(cat /sys/module/kvm/parameters/nx_huge_pages_recovery_period_ms)
-HUGE_PAGES=$(cat /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages)
+NX_HUGE_PAGES=$(sudo cat /sys/module/kvm/parameters/nx_huge_pages)
+NX_HUGE_PAGES_RECOVERY_RATIO=$(sudo cat /sys/module/kvm/parameters/nx_huge_pages_recovery_ratio)
+NX_HUGE_PAGES_RECOVERY_PERIOD=$(sudo cat /sys/module/kvm/parameters/nx_huge_pages_recovery_period_ms)
+HUGE_PAGES=$(sudo cat /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages)
 
-echo 1 > /sys/module/kvm/parameters/nx_huge_pages
-echo 1 > /sys/module/kvm/parameters/nx_huge_pages_recovery_ratio
-echo 100 > /sys/module/kvm/parameters/nx_huge_pages_recovery_period_ms
-echo 200 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
+sudo echo 1 > /sys/module/kvm/parameters/nx_huge_pages
+sudo echo 1 > /sys/module/kvm/parameters/nx_huge_pages_recovery_ratio
+sudo echo 100 > /sys/module/kvm/parameters/nx_huge_pages_recovery_period_ms
+sudo echo 200 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
+
+NXECUTABLE="$(dirname $0)/nx_huge_pages_test"
+
+# Test with reboot permissions
+sudo setcap cap_sys_boot+ep $NXECUTABLE
+$NXECUTABLE 887563923
 
-"$(dirname $0)"/nx_huge_pages_test 887563923
 RET=$?
 
-echo $NX_HUGE_PAGES > /sys/module/kvm/parameters/nx_huge_pages
-echo $NX_HUGE_PAGES_RECOVERY_RATIO > /sys/module/kvm/parameters/nx_huge_pages_recovery_ratio
-echo $NX_HUGE_PAGES_RECOVERY_PERIOD > /sys/module/kvm/parameters/nx_huge_pages_recovery_period_ms
-echo $HUGE_PAGES > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
+if [ $RET -eq 0 ]; then
+	# Test without reboot permissions
+	sudo setcap cap_sys_boot-ep $NXECUTABLE
+	$NXECUTABLE 887563923
+
+	RET=$?
+fi
+
+sudo echo $NX_HUGE_PAGES > /sys/module/kvm/parameters/nx_huge_pages
+sudo echo $NX_HUGE_PAGES_RECOVERY_RATIO > /sys/module/kvm/parameters/nx_huge_pages_recovery_ratio
+sudo echo $NX_HUGE_PAGES_RECOVERY_PERIOD > /sys/module/kvm/parameters/nx_huge_pages_recovery_period_ms
+sudo echo $HUGE_PAGES > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
 
 exit $RET
-- 
2.36.0.rc0.470.gd361397f0d-goog

