Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C205654A15F
	for <lists+kvm@lfdr.de>; Mon, 13 Jun 2022 23:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352126AbiFMVaJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 17:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353193AbiFMV3Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 17:29:25 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3366B8A
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 14:25:41 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id t1-20020a170902e84100b001689cab0be3so3656452plg.11
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 14:25:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ff4fVSapUxUvxB9n2Zl0T+CskRaCkgl+6PL+fmMltA8=;
        b=ViU1g4IXRwdIhNofi8BH7fqSlsEv32y03c03Y02Vk+QIDq1vArSJfsn201yYUkUbKU
         W3wDGy7regdl6SSjmTlUtL/0MFrnZ2IRaUNkIhYCgtkhWjpK8MrVkbXRM4Eb8MDkWugK
         0lI0IiD+26eyChVxDUVkVRAkcq2Vl4RoWM2d3NAH12Ghc5c6J2AmU1t2rl0vEEMQ5AZe
         6zdP/Q8wKiY4QjpSFP+4ff37r2dHTqSe/FrRLG7AWzOfhzcMX+pTN749wHNbdLSveyk6
         My1v8Hy/fMfpucWLbFm1eX5AVIOvif7SuHa5wVg0G1IWQDTWfruof1pjyqRjVfu3Ni+7
         rQ8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ff4fVSapUxUvxB9n2Zl0T+CskRaCkgl+6PL+fmMltA8=;
        b=GtPmjxAm4kmmvB/yiEmCX15nB90Rq3f2DYSTWxSpjA8F/y2muPwTXyO+FS424Bu785
         M9MvhCGqzUP7fedKtXiuLY32TBTnrwCUcPhR5WqHxjufWPEPsH97VV7HrAFgq2f7PLkb
         UDNY0lEQwmEUgXi5Zf5btDw3J6oHYpDC0auBurtcqprfv9cYRxQVjt8EYXRcdXAFZuT2
         WUSBhXKwviLiumwjvpIcRnTiplgMy2drLzWxuCCRStHFekWvMDqemo1JdLytQ8QX2ogu
         4nczzi5BOJ4hkUWD6RqKVPrr1vco/zZBHMRV5pVeiOaP7fkVzRiqjeWHW7u7P28Pm16Y
         f4Eg==
X-Gm-Message-State: AOAM530o69BPQJgFVsct8jAK8WIjzNy19290bddEXuNsb0HkwcDfFPhQ
        3SYJm8KiIAhsWIhPD+PVw+DXpuhxNvZqzmFmjDBBKrcF6VFmpF0Qh6ToE/xLx1Voss5LSHzzIUM
        68YII9xo7URpYlk2OlygO3PAecmAs23TtEObHheApP0960NmpFUiMvQsG/+wD
X-Google-Smtp-Source: AGRyM1ujH/8wJgnWLOU39KDbFOQcd+ADIaJJ+FNow/hKmegWIyz+ttFnHcvrApS9oLsLGz/ShD1JOxE+KHhq
X-Received: from sweer.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:e45])
 (user=bgardon job=sendgmr) by 2002:aa7:92d2:0:b0:51b:4d60:6475 with SMTP id
 k18-20020aa792d2000000b0051b4d606475mr1251862pfa.73.1655155541209; Mon, 13
 Jun 2022 14:25:41 -0700 (PDT)
Date:   Mon, 13 Jun 2022 21:25:22 +0000
In-Reply-To: <20220613212523.3436117-1-bgardon@google.com>
Message-Id: <20220613212523.3436117-10-bgardon@google.com>
Mime-Version: 1.0
References: <20220613212523.3436117-1-bgardon@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v9 09/10] KVM: selftests: Test disabling NX hugepages on a VM
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
 .../selftests/kvm/include/kvm_util_base.h     |   6 +
 .../selftests/kvm/x86_64/nx_huge_pages_test.c | 134 ++++++++++++------
 .../kvm/x86_64/nx_huge_pages_test.sh          |  14 +-
 3 files changed, 106 insertions(+), 48 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 81ab7adfbef5..537b8a047d6e 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -804,4 +804,10 @@ static inline void virt_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 	virt_arch_dump(stream, vm, indent);
 }
 
+
+static inline int __vm_disable_nx_huge_pages(struct kvm_vm *vm)
+{
+	return __vm_enable_cap(vm, KVM_CAP_VM_DISABLE_NX_HUGE_PAGES, 0);
+}
+
 #endif /* SELFTEST_KVM_UTIL_BASE_H */
diff --git a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
index 5fa61d225787..cc6421716400 100644
--- a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
+++ b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
@@ -107,53 +107,34 @@ static void wait_for_reclaim(int reclaim_period_ms)
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
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	void *hva;
+	int r;
 
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
-		}
-	}
-
-	if (token != MAGIC_TOKEN) {
-		print_skip("This test must be run with the magic token %d.\n"
-			   "This is done by nx_huge_pages_test.sh, which\n"
-			   "also handles environment setup for the test.",
-			   MAGIC_TOKEN);
-		exit(KSFT_SKIP);
-	}
+	vm = vm_create(1);
 
-	if (!reclaim_period_ms) {
-		print_skip("The NX reclaim period must be specified and non-zero");
-		exit(KSFT_SKIP);
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
+		}
 	}
 
-	vm = vm_create(1);
 	vcpu = vm_vcpu_add(vm, 0, guest_code);
 
 	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS_HUGETLB,
@@ -187,31 +168,38 @@ int main(int argc, char **argv)
 	/*
 	 * Next, the guest will execute from the first huge page, causing it
 	 * to be remapped at 4k.
+	 *
+	 * If NX huge pages are disabled, this should have no effect.
 	 */
 	vcpu_run(vcpu);
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
 	vcpu_run(vcpu);
-	check_2m_page_count(vm, 1);
-	check_split_count(vm, 2);
+	check_2m_page_count(vm, disable_nx_huge_pages ? 3 : 1);
+	check_split_count(vm, disable_nx_huge_pages ? 0 : 2);
 
 	/* Reading from the first huge page again should have no effect. */
 	vcpu_run(vcpu);
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
@@ -219,10 +207,62 @@ int main(int argc, char **argv)
 	 * reading from it causes a huge page mapping to be installed.
 	 */
 	vcpu_run(vcpu);
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
2.36.1.476.g0c4daa206d-goog

