Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCE7D4FC667
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 23:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350184AbiDKVN3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 17:13:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350079AbiDKVNQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 17:13:16 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B4B52B194
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 14:10:55 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id u10-20020a17090adb4a00b001cb7b5a79e8so253446pjx.5
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 14:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=xIMnek+At8iLPkwADBkZ7XrRr/vdRBqsK9zci+WHfIA=;
        b=C4dFQ0ocxToI8CY7sDWjXFzHFgdTdFWswyceRjb37yOLdjfoDBtbtvTmi5cGq1VEad
         7w8VZnkp/JJLp1koNV5oGegMEnys1FuotSD/VT2E99+gGSCbtJHDbEHlaIItSlSUO+tb
         eviNS42ugJl3zF5thORrX6+krLI00hAQmWFDh59sequdz26pxJLmn5eHdd2XQ8fEEaX1
         GQK8xmTzvsluF8s4Zp/5sBH4besgH876R3NeNfZ7AHjIfn/OfaxNPDHjyeNmoIJo+rXM
         h58xMxL76jasLP7j1ajCTOzysJml3k8TgVcV+noGb9bO3iSj+K1onUAcK60/t9nG3NuV
         9XPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=xIMnek+At8iLPkwADBkZ7XrRr/vdRBqsK9zci+WHfIA=;
        b=Fm2wy7lIDfWNLQ8JHogQ6lpvvSnvSSdJylFUZqcNxn+Zrnf4rVzjZV00xfQwlSbNqK
         RFFSQqoAVwGNpVU9fNTRNUDoKowc4sF6OtFcklLB7j5/RvCqylE/xnwAlc3XU24YWW9R
         a7TV6awUV6MG0xkKbjllgWqVT33JIqH6xAe1M4DnhBxfrRl9LMz5QUt1x82hSXiFsd2h
         NqxEjYE6wUWd+mNR10LLolFY2gC1b74qkXV2s8o/I+zSlbXT/6f9lJQTW4SVeN7xRPcP
         O4Z66k/1vfXZTQmUIwFpP9Ech9mgbt/vrJgqKHuSxALvZGF0dQXTW03Oprv/NYm/NGeC
         MI1Q==
X-Gm-Message-State: AOAM5335+7FRftIDiK4g+sE+QUFabB2h6BzoGyvQ4KVhOAm47ACto4Pj
        y2yWfnNsAKhj6LRtB8pSssjA/0fbUm9/
X-Google-Smtp-Source: ABdhPJy2WkMcnAC3gL8ghKY5MA9VSdRNJhjdAS3w/erZboLxL3Zrns0cwsriLs/zATnsIQVyFpAaL6sUNN0D
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:a2d0:faec:7d8b:2e0b])
 (user=bgardon job=sendgmr) by 2002:a17:902:728f:b0:156:24d3:ae1a with SMTP id
 d15-20020a170902728f00b0015624d3ae1amr34419549pll.9.1649711454954; Mon, 11
 Apr 2022 14:10:54 -0700 (PDT)
Date:   Mon, 11 Apr 2022 14:10:15 -0700
In-Reply-To: <20220411211015.3091615-1-bgardon@google.com>
Message-Id: <20220411211015.3091615-11-bgardon@google.com>
Mime-Version: 1.0
References: <20220411211015.3091615-1-bgardon@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v4 10/10] KVM: selftests: Test disabling NX hugepages on a VM
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        David Dunn <daviddunn@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add an argument to the NX huge pages test to test disabling the feature
on a VM using the new capability.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     |  2 +
 tools/testing/selftests/kvm/lib/kvm_util.c    | 19 ++++++-
 .../selftests/kvm/x86_64/nx_huge_pages_test.c | 53 +++++++++++++++----
 3 files changed, 64 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index f9c2ac0a5b97..15f24be6d93f 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -412,4 +412,6 @@ uint64_t vm_get_single_stat(struct kvm_vm *vm, const char *stat_name);
 
 uint32_t guest_get_vcpuid(void);
 
+int vm_disable_nx_huge_pages(struct kvm_vm *vm);
+
 #endif /* SELFTEST_KVM_UTIL_BASE_H */
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 833c7e63d62d..5fa5608eef03 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -112,6 +112,15 @@ int vm_check_cap(struct kvm_vm *vm, long cap)
 	return ret;
 }
 
+static int __vm_enable_cap(struct kvm_vm *vm, struct kvm_enable_cap *cap)
+{
+	int ret;
+
+	ret = ioctl(vm->fd, KVM_ENABLE_CAP, cap);
+
+	return ret;
+}
+
 /* VM Enable Capability
  *
  * Input Args:
@@ -128,7 +137,7 @@ int vm_enable_cap(struct kvm_vm *vm, struct kvm_enable_cap *cap)
 {
 	int ret;
 
-	ret = ioctl(vm->fd, KVM_ENABLE_CAP, cap);
+	ret = __vm_enable_cap(vm, cap);
 	TEST_ASSERT(ret == 0, "KVM_ENABLE_CAP IOCTL failed,\n"
 		"  rc: %i errno: %i", ret, errno);
 
@@ -2662,3 +2671,11 @@ uint64_t vm_get_single_stat(struct kvm_vm *vm, const char *stat_name)
 		    stat_name, ret);
 	return data;
 }
+
+int vm_disable_nx_huge_pages(struct kvm_vm *vm)
+{
+	struct kvm_enable_cap cap = { 0 };
+
+	cap.cap = KVM_CAP_VM_DISABLE_NX_HUGE_PAGES;
+	return __vm_enable_cap(vm, &cap);
+}
diff --git a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
index 3f21726b22c7..f8edf7910950 100644
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
@@ -77,14 +79,41 @@ static void check_split_count(struct kvm_vm *vm, int expected_splits)
 		    expected_splits, actual_splits);
 }
 
-int main(int argc, char **argv)
+void run_test(bool disable_nx)
 {
 	struct kvm_vm *vm;
 	struct timespec ts;
 	void *hva;
+	int r;
 
 	vm = vm_create_default(0, 0, guest_code);
 
+	if (disable_nx) {
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
+		if (errno == EPERM) {
+			r = vm_disable_nx_huge_pages(vm);
+			TEST_ASSERT(r == EPERM,
+				    "This process should not have permission to disable NX huge pages");
+			return;
+		}
+
+		TEST_ASSERT(errno == EINVAL,
+			    "Reboot syscall should fail with -EINVAL");
+
+		r = vm_disable_nx_huge_pages(vm);
+		TEST_ASSERT(!r, "Disabling NX huge pages should not fail if process has reboot permissions");
+	}
+
 	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS_HUGETLB,
 				    HPAGE_GPA, HPAGE_SLOT,
 				    HPAGE_SLOT_NPAGES, 0);
@@ -118,21 +147,21 @@ int main(int argc, char **argv)
 	 * to be remapped at 4k.
 	 */
 	vcpu_run(vm, 0);
-	check_2m_page_count(vm, 1);
-	check_split_count(vm, 1);
+	check_2m_page_count(vm, disable_nx ? 2 : 1);
+	check_split_count(vm, disable_nx ? 0 : 1);
 
 	/*
 	 * Executing from the third huge page (previously unaccessed) will
 	 * cause part to be mapped at 4k.
 	 */
 	vcpu_run(vm, 0);
-	check_2m_page_count(vm, 1);
-	check_split_count(vm, 2);
+	check_2m_page_count(vm, disable_nx ? 3 : 1);
+	check_split_count(vm, disable_nx ? 0 : 2);
 
 	/* Reading from the first huge page again should have no effect. */
 	vcpu_run(vm, 0);
-	check_2m_page_count(vm, 1);
-	check_split_count(vm, 2);
+	check_2m_page_count(vm, disable_nx ? 3 : 1);
+	check_split_count(vm, disable_nx ? 0 : 2);
 
 	/*
 	 * Give recovery thread time to run. The wrapper script sets
@@ -145,7 +174,7 @@ int main(int argc, char **argv)
 	/*
 	 * Now that the reclaimer has run, all the split pages should be gone.
 	 */
-	check_2m_page_count(vm, 1);
+	check_2m_page_count(vm, disable_nx ? 3 : 1);
 	check_split_count(vm, 0);
 
 	/*
@@ -153,10 +182,16 @@ int main(int argc, char **argv)
 	 * reading from it causes a huge page mapping to be installed.
 	 */
 	vcpu_run(vm, 0);
-	check_2m_page_count(vm, 2);
+	check_2m_page_count(vm, disable_nx ? 3 : 2);
 	check_split_count(vm, 0);
 
 	kvm_vm_free(vm);
+}
+
+int main(int argc, char **argv)
+{
+	run_test(false);
+	run_test(true);
 
 	return 0;
 }
-- 
2.35.1.1178.g4f1659d476-goog

