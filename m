Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18C244ECB06
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 19:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349522AbiC3Rsu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Mar 2022 13:48:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349454AbiC3Rsd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Mar 2022 13:48:33 -0400
Received: from mail-ot1-x349.google.com (mail-ot1-x349.google.com [IPv6:2607:f8b0:4864:20::349])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06F4410AF
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 10:46:47 -0700 (PDT)
Received: by mail-ot1-x349.google.com with SMTP id v12-20020a05683018cc00b005cb5db35adaso11991144ote.22
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 10:46:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=zkLPtLgP4f8lahneFPhxB49cwHOmpmWMwYFdRQOyspU=;
        b=IPcnIrbSKblWsCyaVezhk5I+TW9O75I+DEC5RZc24jMakgquDmyiFouMKjDX0apCIq
         8hPKImUPj5o1A31sI29jgiJ+8dIJe2GkG5HulJFj4SJv3eoXgBgG/dKaFol8hmfP64em
         giAiEgH5DeY3R3YsCczc2x3bxDlRakQ1UwffoiSvZE8dfrdIIoS+Hf60fvqRHdQ+4PPb
         yMwb6iWf/f9EFWLMcfXXfJezyBJF3bkaW9NVzE8o8gKWuNUWgTiZwduhh4spbYU3Gnp3
         EFlU/2YLBWVbswX+BZCbiBotBeUgsTPlcug/QsbnfXvAub5gdcpuE7U+GNQpsWUpk/tL
         PuHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=zkLPtLgP4f8lahneFPhxB49cwHOmpmWMwYFdRQOyspU=;
        b=XQTEgSoj9qbc4lh0Y3qqX7IyjkB2leYI2P4kVp3I/mzVmJWZgIA94ul/Lvow1ffa6I
         cujpYx0CD7RZ4nDYX0cHECMor/zlNqEXjUc4pe/TF6sRl4m5h4srJSFBbe8lYnLIElwR
         DkTFADLq1OrzkxRBOBLP4Ul0tpZoQpLjKo2SL7pZmv2TEhm1PsqULRbis2fs/sAcP6ax
         N0jpqMFeDT+9DdejDQb0GYmZ3RUSwjOpsVEaYfIwwKhhAhTtgQ8tSJjQudVo+FkHCqlD
         SDWC78A6g+tzTTzaDPGi31CDVTKs25TpOQXyxy+hfbodrw+eheNMoMChE2SWOzhBF/hH
         DfTg==
X-Gm-Message-State: AOAM531nNZkAWFy2y15mp0nJw9Q0PqVJt5oeQXnvffU4lYzRWPQW8dIk
        zn1pi+BppT1NiGzjEOsAuov6zLdM0fNU
X-Google-Smtp-Source: ABdhPJxtJpJ4jFm3lSuaP+2ohkBJNFPXeQidsiS1RT6z36hgKXeJ/VLQtRDxmvvtUH3OKGzhG8SLipTurDdx
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:7c53:ec2f:bd26:b69c])
 (user=bgardon job=sendgmr) by 2002:aca:f288:0:b0:2f4:6cb:4c84 with SMTP id
 q130-20020acaf288000000b002f406cb4c84mr456922oih.185.1648662406810; Wed, 30
 Mar 2022 10:46:46 -0700 (PDT)
Date:   Wed, 30 Mar 2022 10:46:21 -0700
In-Reply-To: <20220330174621.1567317-1-bgardon@google.com>
Message-Id: <20220330174621.1567317-12-bgardon@google.com>
Mime-Version: 1.0
References: <20220330174621.1567317-1-bgardon@google.com>
X-Mailer: git-send-email 2.35.1.1021.g381101b075-goog
Subject: [PATCH v3 11/11] selftests: KVM: Test disabling NX hugepages on a VM
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
        autolearn=unavailable autolearn_force=no version=3.4.6
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
 tools/testing/selftests/kvm/lib/kvm_util.c    |  7 ++
 .../selftests/kvm/x86_64/nx_huge_pages_test.c | 67 ++++++++++++++++---
 .../kvm/x86_64/nx_huge_pages_test.sh          |  2 +-
 4 files changed, 66 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 72163ba2f878..4db8251c3ce5 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -411,4 +411,6 @@ uint64_t vm_get_single_stat(struct kvm_vm *vm, const char *stat_name);
 
 uint32_t guest_get_vcpuid(void);
 
+void vm_disable_nx_huge_pages(struct kvm_vm *vm);
+
 #endif /* SELFTEST_KVM_UTIL_BASE_H */
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 9d72d1bb34fa..46a7fa08d3e0 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2765,3 +2765,10 @@ uint64_t vm_get_single_stat(struct kvm_vm *vm, const char *stat_name)
 	return value;
 }
 
+void vm_disable_nx_huge_pages(struct kvm_vm *vm)
+{
+	struct kvm_enable_cap cap = { 0 };
+
+	cap.cap = KVM_CAP_VM_DISABLE_NX_HUGE_PAGES;
+	vm_enable_cap(vm, &cap);
+}
diff --git a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
index 2bcbe4efdc6a..a0c79f6ddc08 100644
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
@@ -57,13 +59,56 @@ static void check_split_count(struct kvm_vm *vm, int expected_splits)
 		    expected_splits, actual_splits);
 }
 
+static void help(void)
+{
+	puts("");
+	printf("usage: nx_huge_pages_test.sh [-x]\n");
+	puts("");
+	printf(" -x: Allow executable huge pages on the VM.\n");
+	puts("");
+	exit(0);
+}
+
 int main(int argc, char **argv)
 {
 	struct kvm_vm *vm;
 	struct timespec ts;
+	bool disable_nx = false;
+	int opt;
+	int r;
+
+	while ((opt = getopt(argc, argv, "x")) != -1) {
+		switch (opt) {
+		case 'x':
+			disable_nx = true;
+			break;
+		case 'h':
+		default:
+			help();
+			break;
+		}
+	}
 
 	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES, O_RDWR);
 
+	if (disable_nx) {
+		/*
+		 * Check if this process has the reboot permissions needed to
+		 * disable NX huge pages on a VM.
+		 *
+		 * The reboot call below will never have any effect because
+		 * the magic values are not set correctly, however the
+		 * permission check is done before the magic value check.
+		 */
+		r = syscall(SYS_reboot, 0, 0, 0, NULL);
+		if (r == -EPERM)
+			return KSFT_SKIP;
+		TEST_ASSERT(r == -EINVAL,
+			    "Reboot syscall should fail with -EINVAL");
+
+		vm_disable_nx_huge_pages(vm);
+	}
+
 	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS_HUGETLB,
 				    HPAGE_PADDR_START, HPAGE_SLOT,
 				    HPAGE_SLOT_NPAGES, 0);
@@ -83,21 +128,21 @@ int main(int argc, char **argv)
 	 * at 2M.
 	 */
 	run_guest_code(vm, guest_code0);
-	check_2m_page_count(vm, 2);
-	check_split_count(vm, 2);
+	check_2m_page_count(vm, disable_nx ? 4 : 2);
+	check_split_count(vm, disable_nx ? 0 : 2);
 
 	/*
 	 * guest_code1 is in the same huge page as data1, so it will cause
 	 * that huge page to be remapped at 4k.
 	 */
 	run_guest_code(vm, guest_code1);
-	check_2m_page_count(vm, 1);
-	check_split_count(vm, 3);
+	check_2m_page_count(vm, disable_nx ? 4 : 1);
+	check_split_count(vm, disable_nx ? 0 : 3);
 
 	/* Run guest_code0 again to check that is has no effect. */
 	run_guest_code(vm, guest_code0);
-	check_2m_page_count(vm, 1);
-	check_split_count(vm, 3);
+	check_2m_page_count(vm, disable_nx ? 4 : 1);
+	check_split_count(vm, disable_nx ? 0 : 3);
 
 	/*
 	 * Give recovery thread time to run. The wrapper script sets
@@ -110,7 +155,7 @@ int main(int argc, char **argv)
 	/*
 	 * Now that the reclaimer has run, all the split pages should be gone.
 	 */
-	check_2m_page_count(vm, 1);
+	check_2m_page_count(vm, disable_nx ? 4 : 1);
 	check_split_count(vm, 0);
 
 	/*
@@ -118,13 +163,13 @@ int main(int argc, char **argv)
 	 * again to check that pages are mapped at 2M again.
 	 */
 	run_guest_code(vm, guest_code0);
-	check_2m_page_count(vm, 2);
-	check_split_count(vm, 2);
+	check_2m_page_count(vm, disable_nx ? 4 : 2);
+	check_split_count(vm, disable_nx ? 0 : 2);
 
 	/* Pages are once again split from running guest_code1. */
 	run_guest_code(vm, guest_code1);
-	check_2m_page_count(vm, 1);
-	check_split_count(vm, 3);
+	check_2m_page_count(vm, disable_nx ? 4 : 1);
+	check_split_count(vm, disable_nx ? 0 : 3);
 
 	kvm_vm_free(vm);
 
diff --git a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh
index 19fc95723fcb..29f999f48848 100755
--- a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh
+++ b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh
@@ -14,7 +14,7 @@ echo 1 > /sys/module/kvm/parameters/nx_huge_pages_recovery_ratio
 echo 100 > /sys/module/kvm/parameters/nx_huge_pages_recovery_period_ms
 echo 200 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
 
-./nx_huge_pages_test
+./nx_huge_pages_test "${@}"
 RET=$?
 
 echo $NX_HUGE_PAGES > /sys/module/kvm/parameters/nx_huge_pages
-- 
2.35.1.1021.g381101b075-goog

