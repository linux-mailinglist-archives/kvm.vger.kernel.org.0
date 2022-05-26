Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA7C5352F3
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 19:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343516AbiEZRzF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 13:55:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348450AbiEZRyh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 13:54:37 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3CD1B36DF
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 10:54:28 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id r14-20020a17090a1bce00b001df665a2f8bso1451584pjr.4
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 10:54:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=SXKeF9OqpGDpuoZVxsYVRtbB7K2x8FBA+P2quq827+Y=;
        b=nQo/6U11xPzxsdoihbiqFl4qSug+H3g3Qb7ocCUM0EGUDx+1gRyq8RPo8YXgvdyVMy
         Z1XDj1eysHJdfANHU0+Cn8tAQsjUhNIuM5a+0C982JyL4frVMd5XBhHq0AWED6DouJ9N
         eGwPRmd6l9dnqL0R+CyGOKYIidCD/mZEub53/pLOeSryTO92bRuPZWZUoprtCBvsmIKm
         ALwjBsCaiC/cZvspVuy4i/SFAaej7vjrSZH55yzFfmGPh0qPSHrASwKE5aO+j6w4zvwT
         42kSICns53DkkOkeb6unR/OhSg6ta3PTI160HerUDSXTHf2VWeVD8k533Q2egV+3XnHd
         gk6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=SXKeF9OqpGDpuoZVxsYVRtbB7K2x8FBA+P2quq827+Y=;
        b=q875h9+fyNWMoH81enaUqcLylEEgH/Q3qMkXz4PZ+bzTY0A0xyOuSTgdHhNqGvl7Bw
         LN+ZzE04i+iK/VZ9zuIXbhtdxBbZHQkfSxq0ymYpPnkflsI4WmwdC1fV5ySTKMBkKEoH
         F0/OnPWzW87FYvQX7dSUZoSHYJXnkyMEF9xpcKhcJwGXeB3h/RtmR/5aFzKF05gwW0E7
         cShhXl4JNC062hR3uRYUW9hteHGXyv++MkExmWWXBb7pIYaRWu9gzGU2Xj1ju2ig+nAu
         Fth/PH/WzFanKg/9rMolnGCAsVas+Zd+V3t3K3xibMMflGo8EO5qzUfDhh2a64dYlFAU
         u6Gg==
X-Gm-Message-State: AOAM532bA5G33FsijVO7+7A87+FMi3vsQLHfCHQbEH0KvAFo/SziSPHs
        GJscBtmtnFjw5pw72eFcSqP5DxxBxFeS4e8Tk8dogLKaAprZi4KyQSDWiKMFM+wRy/Ka9x+AfXH
        e3Z8N5da88NMzRXUqWB9jYjUQyZAuDEQOVjbhxw4XVliRqU+tnyDHEn6Ye9VX
X-Google-Smtp-Source: ABdhPJzQKWFwdJlvIOv1OxlOvp4R5BCgNe1G7CZ5JXEB0H+2A6fAwaYggU549C56tFWhaMBXwf4HLm4CmV4i
X-Received: from sweer.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:e45])
 (user=bgardon job=sendgmr) by 2002:a17:90a:778c:b0:1df:56a5:8474 with SMTP id
 v12-20020a17090a778c00b001df56a58474mr3839118pjk.63.1653587667713; Thu, 26
 May 2022 10:54:27 -0700 (PDT)
Date:   Thu, 26 May 2022 17:54:07 +0000
In-Reply-To: <20220526175408.399718-1-bgardon@google.com>
Message-Id: <20220526175408.399718-11-bgardon@google.com>
Mime-Version: 1.0
References: <20220526175408.399718-1-bgardon@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH v8 10/11] KVM: selftests: Test disabling NX hugepages on a VM
From:   Ben Gardon <bgardon@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Peter Xu <peterx@redhat.com>,
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

Reviewed-by: David Matlack <dmatlack@google.com>
Signed-off-by: Ben Gardon <bgardon@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     |   2 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  27 +++-
 .../selftests/kvm/x86_64/nx_huge_pages_test.c | 140 ++++++++++++------
 .../kvm/x86_64/nx_huge_pages_test.sh          |  14 +-
 4 files changed, 133 insertions(+), 50 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 3c9898c59ea1..6aa06a312250 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -447,4 +447,6 @@ static inline uint64_t vm_get_stat(struct kvm_vm *vm, const char *stat_name)
 
 uint32_t guest_get_vcpuid(void);
 
+int __vm_disable_nx_huge_pages(struct kvm_vm *vm);
+
 #endif /* SELFTEST_KVM_UTIL_BASE_H */
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 385f249c2dc5..33d4d64c1391 100644
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
 
@@ -2718,3 +2723,23 @@ void __vm_get_stat(struct kvm_vm *vm, const char *stat_name, uint64_t *data,
 	free(stats_desc);
 	close(stats_fd);
 }
+
+/* VM disable NX huge pages
+ *
+ * Input Args:
+ *   vm - Virtual Machine
+ *
+ * Output Args: None
+ *
+ * Return: On success, 0. -ERRNO on failure.
+ *
+ * Disables NX huge pages for the VM.
+ */
+int __vm_disable_nx_huge_pages(struct kvm_vm *vm)
+{
+	struct kvm_enable_cap cap = { 0 };
+
+	cap.cap = KVM_CAP_VM_DISABLE_NX_HUGE_PAGES;
+	cap.args[0] = 0;
+	return __vm_enable_cap(vm, &cap);
+}
diff --git a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
index 09e05cda3dcd..9ff554a572c0 100644
--- a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
+++ b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
@@ -107,52 +107,37 @@ static void wait_for_reclaim(int reclaim_period_ms)
 	nanosleep(&ts, NULL);
 }
 
-static void help(char *name)
-{
-	puts("");
-	printf("usage: %s [-h] [-p period_ms] [-t token]\n", name);
-	puts("");
-	printf(" -p: The NX reclaim period in miliseconds.\n");
-	printf(" -t: The magic token to indicate environment setup is done.\n");
-	puts("");
-	exit(0);
-}
-
-int main(int argc, char **argv)
+void run_test(int reclaim_period_ms, bool disable_nx_huge_pages,
+	      bool reboot_permissions)
 {
-	int reclaim_period_ms = 0, token = 0, opt;
 	struct kvm_vm *vm;
+	uint64_t pages;
 	void *hva;
-
-	while ((opt = getopt(argc, argv, "hp:t:")) != -1) {
-		switch (opt) {
-		case 'p':
-			reclaim_period_ms = atoi(optarg);
-			break;
-		case 't':
-			token = atoi(optarg);
-			break;
-		case 'h':
-		default:
-			help(argv[0]);
-			break;
+	int r;
+
+	pages = vm_pages_needed(VM_MODE_DEFAULT, 1, DEFAULT_GUEST_PHY_PAGES,
+				0, 0);
+	vm = vm_create_without_vcpus(VM_MODE_DEFAULT, pages);
+
+	if (disable_nx_huge_pages) {
+		/*
+		 * Cannot run the test without NX huge pages if the kernel
+		 * does not support it.
+		 */
+		if (!kvm_check_cap(KVM_CAP_VM_DISABLE_NX_HUGE_PAGES))
+			return;
+
+		r = __vm_disable_nx_huge_pages(vm);
+		if (reboot_permissions) {
+			TEST_ASSERT(!r, "Disabling NX huge pages should succeed if process has reboot permissions");
+		} else {
+			TEST_ASSERT(r == -1 && errno == EPERM,
+				    "This process should not have permission to disable NX huge pages");
+			return;
 		}
 	}
 
-	if (token != MAGIC_TOKEN) {
-		print_skip("This test must be run with the magic token %d.\n"
-			   "This is done by nx_huge_pages_test.sh, which\n"
-			   "also handles environment setup for the test.",
-			   MAGIC_TOKEN);
-		exit(KSFT_SKIP);
-	}
-
-	if (!reclaim_period_ms) {
-		print_skip("The NX reclaim period must be specified and non-zero");
-		exit(KSFT_SKIP);
-	}
-
-	vm = vm_create_default(0, 0, guest_code);
+	vm_vcpu_add_default(vm, 0, guest_code);
 
 	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS_HUGETLB,
 				    HPAGE_GPA, HPAGE_SLOT,
@@ -185,31 +170,38 @@ int main(int argc, char **argv)
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
 
 	/* Give recovery thread time to run. */
 	wait_for_reclaim(reclaim_period_ms);
 
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
@@ -217,10 +209,62 @@ int main(int argc, char **argv)
 	 * reading from it causes a huge page mapping to be installed.
 	 */
 	vcpu_run(vm, 0);
-	check_2m_page_count(vm, 2);
+	check_2m_page_count(vm, disable_nx_huge_pages ? 3 : 2);
 	check_split_count(vm, 0);
 
 	kvm_vm_free(vm);
+}
+
+static void help(char *name)
+{
+	puts("");
+	printf("usage: %s [-h] [-p period_ms] [-t token]\n", name);
+	puts("");
+	printf(" -p: The NX reclaim period in miliseconds.\n");
+	printf(" -t: The magic token to indicate environment setup is done.\n");
+	printf(" -r: The test has reboot permissions and can disable NX huge pages.\n");
+	puts("");
+	exit(0);
+}
+
+int main(int argc, char **argv)
+{
+	int reclaim_period_ms = 0, token = 0, opt;
+	bool reboot_permissions = false;
+
+	while ((opt = getopt(argc, argv, "hp:t:r")) != -1) {
+		switch (opt) {
+		case 'p':
+			reclaim_period_ms = atoi(optarg);
+			break;
+		case 't':
+			token = atoi(optarg);
+			break;
+		case 'r':
+			reboot_permissions = true;
+			break;
+		case 'h':
+		default:
+			help(argv[0]);
+			break;
+		}
+	}
+
+	if (token != MAGIC_TOKEN) {
+		print_skip("This test must be run with the magic token %d.\n"
+			   "This is done by nx_huge_pages_test.sh, which\n"
+			   "also handles environment setup for the test.",
+			   MAGIC_TOKEN);
+		exit(KSFT_SKIP);
+	}
+
+	if (!reclaim_period_ms) {
+		print_skip("The NX reclaim period must be specified and non-zero");
+		exit(KSFT_SKIP);
+	}
+
+	run_test(reclaim_period_ms, false, reboot_permissions);
+	run_test(reclaim_period_ms, true, reboot_permissions);
 
 	return 0;
 }
diff --git a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh
index 4e090a84f5f3..6bd8e026ee61 100755
--- a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh
+++ b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh
@@ -20,6 +20,8 @@ function sudo_echo () {
 	echo "$1" | sudo tee -a "$2" > /dev/null
 }
 
+NXECUTABLE="$(dirname $0)/nx_huge_pages_test"
+
 (
 	set -e
 
@@ -28,7 +30,17 @@ function sudo_echo () {
 	sudo_echo 100 /sys/module/kvm/parameters/nx_huge_pages_recovery_period_ms
 	sudo_echo "$(( $HUGE_PAGES + 3 ))" /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
 
-	"$(dirname $0)"/nx_huge_pages_test -t 887563923 -p 100
+	# Test with reboot permissions
+	if [ $(whoami) != "root" ] ; then
+		sudo setcap cap_sys_boot+ep $NXECUTABLE
+	fi
+	$NXECUTABLE -t 887563923 -p 100 -r
+
+	# Test without reboot permissions
+	if [ $(whoami) != "root" ] ; then
+		sudo setcap cap_sys_boot-ep $NXECUTABLE
+		$NXECUTABLE -t 887563923 -p 100
+	fi
 )
 RET=$?
 
-- 
2.36.1.124.g0e6072fb45-goog

