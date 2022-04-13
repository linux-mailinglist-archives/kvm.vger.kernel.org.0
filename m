Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B185A4FFD6B
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 20:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237722AbiDMSE2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Apr 2022 14:04:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237608AbiDMSC3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Apr 2022 14:02:29 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95A8941F8A
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 11:00:06 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id mm2-20020a17090b358200b001bf529127dfso1674353pjb.6
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 11:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Gy/3X4u6MXYQtgeHNH5kjdgpJgGkBIMGxlSxtIk71CY=;
        b=jeGlCKN9OtluiB/5f/mJ9LQLzPoIDA1Wo+ibNZbKfTzUBIfygIxTfP4/+r2jKj+CP8
         sHxurmH0mY3yJKOKlNTH+0RoAMkUitaxWjrqDItdQ8HCkNO9wFU5kl944VOmC4Lvlo3X
         r2HpwlzwF6RnQ/Tfv7u6VF/GTdN8H4GGtWRExbNtz2clbV3GLugVjcADcv+pCUVZdkrw
         K+0yVf6TK7pTD7kbO+s+2ZV8D1h6oEb3bGTwVwYKdD4l2A9xUSoTnCF3pbXMxpy0gILc
         hKKFOAP4IeC7EJtvsikgfNdxnSetjqRxOfjbQ1nQyYifBugi0k5an28llAE9HQUgS2Ws
         eDZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Gy/3X4u6MXYQtgeHNH5kjdgpJgGkBIMGxlSxtIk71CY=;
        b=qq+TZ9sVP8+B5u2EC0YHHHmcWcgUtrJcNeQ6ao8/U/IGTltbGbbcopdD9lmJjldIkY
         6Ps+Udo1cKSDMbAHWR1oDlsCCP0XRrSRVJN4DkNmEiOQ416F5AJPXe+OUiYFOEMVvRD6
         FStynH0kPN5u8PzVGiQiVN++9qCe/WOZ13q/Fta5XWQML2XJ8Ozdardebacrb9jcRYji
         5zF5oE2TM1y0g0m7hu8m2BvLJeTxtuOY6e6PU2Q9x+6aPo4bEUdlMcLU3FyqsoAznUxs
         HHGWwwuWtzAGfFFNHnir4GgQpSrQQjSp8qvmezk7heLnQ7YszK01He20xHs1E1zlQjtW
         AJEQ==
X-Gm-Message-State: AOAM531wOIXc8snXp0+U0epn+Z7WsgWoUna5yT3JXb72xCJBTxFOTG6i
        ng0LdcQl0xT82tZeuI8YqLuciwXdGfkv
X-Google-Smtp-Source: ABdhPJwdQGF6KfkCW4KBWs4LWsNAoyhQDkcsu5V93bneH+RboPTeqdazql3ja8rt6ulHljKweQjRBB7F9n2e
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:c087:f2f2:f5f0:f73])
 (user=bgardon job=sendgmr) by 2002:a05:6a00:3406:b0:505:7a1c:c553 with SMTP
 id cn6-20020a056a00340600b005057a1cc553mr30393pfb.2.1649872806122; Wed, 13
 Apr 2022 11:00:06 -0700 (PDT)
Date:   Wed, 13 Apr 2022 10:59:44 -0700
In-Reply-To: <20220413175944.71705-1-bgardon@google.com>
Message-Id: <20220413175944.71705-11-bgardon@google.com>
Mime-Version: 1.0
References: <20220413175944.71705-1-bgardon@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v5 10/10] KVM: selftests: Test disabling NX hugepages on a VM
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
 tools/testing/selftests/kvm/lib/kvm_util.c    | 16 ++++-
 .../selftests/kvm/x86_64/nx_huge_pages_test.c | 62 +++++++++++++++----
 3 files changed, 68 insertions(+), 12 deletions(-)

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
index 5ffed44ab328..ef01858745e9 100644
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
 
@@ -2740,3 +2745,12 @@ uint64_t vm_get_stat(struct kvm_vm *vm, const char *stat_name)
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
index 7f80e48781fd..21c31e1d567e 100644
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
@@ -80,13 +82,45 @@ static void check_split_count(struct kvm_vm *vm, int expected_splits)
 		    expected_splits, actual_splits);
 }
 
-int main(int argc, char **argv)
+void run_test(bool disable_nx)
 {
 	struct kvm_vm *vm;
 	struct timespec ts;
+	uint64_t pages;
 	void *hva;
-
-	vm = vm_create_default(0, 0, guest_code);
+	int r;
+
+	pages = vm_pages_needed(VM_MODE_DEFAULT, 1, DEFAULT_GUEST_PHY_PAGES,
+				0, 0);
+	vm = vm_create_without_vcpus(VM_MODE_DEFAULT, pages);
+
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
+		if (r && errno == EPERM) {
+			r = vm_disable_nx_huge_pages(vm);
+			TEST_ASSERT(r == EPERM,
+				    "This process should not have permission to disable NX huge pages");
+			return;
+		}
+
+		TEST_ASSERT(r && errno == EINVAL,
+			    "Reboot syscall should fail with -EINVAL");
+
+		r = vm_disable_nx_huge_pages(vm);
+		TEST_ASSERT(!r, "Disabling NX huge pages should succeed if process has reboot permissions");
+	}
+
+	vm_vcpu_add_default(vm, 0, guest_code);
 
 	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS_HUGETLB,
 				    HPAGE_GPA, HPAGE_SLOT,
@@ -121,21 +155,21 @@ int main(int argc, char **argv)
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
@@ -148,7 +182,7 @@ int main(int argc, char **argv)
 	/*
 	 * Now that the reclaimer has run, all the split pages should be gone.
 	 */
-	check_2m_page_count(vm, 1);
+	check_2m_page_count(vm, disable_nx ? 3 : 1);
 	check_split_count(vm, 0);
 
 	/*
@@ -156,10 +190,16 @@ int main(int argc, char **argv)
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

