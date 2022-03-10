Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 876764D4F98
	for <lists+kvm@lfdr.de>; Thu, 10 Mar 2022 17:47:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbiCJQsZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 11:48:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244133AbiCJQrg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 11:47:36 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06F03198EC8
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 08:46:23 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id o41-20020a17090a0a2c00b001bf06e5badfso3662418pjo.3
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 08:46:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=lSRTllOR9r6/nLyxV36+XgGPCp0gJBo+opj3caznl+k=;
        b=ectWumox3D7lwv3ygc0FdA62EqZF3SruvaSume3D5rakSI7TpPx3hcZuhxP6/9u1Lf
         /qBK5JVoPUFvR+moyFhzUibr6F075GEVqrzdZ26n+fqzWdU6QrkETCPG632GLVrM6wX6
         Cytt7F/5aR60/f8XrR19dRV3b8PAWuo6O3tW01nA1/wKFAw8if6nSY87Ba0efOlcdpe7
         G/07cRhUj1Mz3Z6lbtDbKuZoRFydKAFVQN1etgCFSyG372u+iO1IwIaTRKJ/t/9mwIcp
         JhKd5sUgRnNnq2BarHsaQm1Kd7RI11qGHd5WdxHf9LOcRG29qXmdMzaTQ5kuOyHXRZvL
         CbxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=lSRTllOR9r6/nLyxV36+XgGPCp0gJBo+opj3caznl+k=;
        b=SmpH5HjFlz5M4PaLWI+OJb2HH/CdfTtQGxCbwRHEd/+pufxZp0dD00pbCUnKdw9BAe
         5racONWVX231SwBd7ugoJjio/W8vygpJ7QxqSxyr9O02XXFyIqzYbyjKMvpDBRwd19if
         2nFKL/m1SOwufX4makQknjKzG5ypjf1mKRIxCdYNlluZquye++fXaLuHfbcwmk8Lg9EA
         6unigS31iu9i57lHdR1xeJhNpY+4/rEtc1Dem31DYj0kSU5UJabdZuNM1x38JZhjkCjD
         FCgAUK5SSsK6O32lcB0xs7BTwipMwN11vVV1SMheE97LDbKKK1iCUDdfpTbsw15jTkOl
         bHeA==
X-Gm-Message-State: AOAM530/mTKDwHOBbEHS0mi1X1bXLAt+Ryea+SgEpDYfKcFtVwVDYnPK
        yAKLmXHq7lcPSHCilj3gcvalJ8V1BmvT
X-Google-Smtp-Source: ABdhPJxl3fnS2a59GPzC3rTVspwk/LybLE/JpU6Fr2EWIc2Lsku1IXeppMG3yQI2T4+MqEuXaj7YPi4mpTIJ
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:2d58:733f:1853:8e86])
 (user=bgardon job=sendgmr) by 2002:a17:903:4054:b0:151:be03:2994 with SMTP id
 n20-20020a170903405400b00151be032994mr6045519pla.77.1646930782505; Thu, 10
 Mar 2022 08:46:22 -0800 (PST)
Date:   Thu, 10 Mar 2022 08:45:32 -0800
In-Reply-To: <20220310164532.1821490-1-bgardon@google.com>
Message-Id: <20220310164532.1821490-14-bgardon@google.com>
Mime-Version: 1.0
References: <20220310164532.1821490-1-bgardon@google.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
Subject: [PATCH 13/13] selftests: KVM: Test disabling NX hugepages on a VM
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
 tools/testing/selftests/kvm/lib/kvm_util.c    |  7 +++
 .../selftests/kvm/x86_64/nx_huge_pages_test.c | 49 ++++++++++++++-----
 .../kvm/x86_64/nx_huge_pages_test.sh          |  2 +-
 4 files changed, 48 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 530b5272fae2..8302cf9b1e1d 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -420,4 +420,6 @@ uint64_t vm_get_single_stat(struct kvm_vm *vm, const char *stat_name);
 
 uint32_t guest_get_vcpuid(void);
 
+void vm_disable_nx_huge_pages(struct kvm_vm *vm);
+
 #endif /* SELFTEST_KVM_UTIL_BASE_H */
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index f9591dad1010..880786fe9fac 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2760,3 +2760,10 @@ uint64_t vm_get_single_stat(struct kvm_vm *vm, const char *stat_name)
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
index 5cbcc777d0ab..1020a4758664 100644
--- a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
+++ b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
@@ -56,12 +56,39 @@ static void check_split_count(struct kvm_vm *vm, int expected_splits)
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
+	bool disable_nx = false;
+	int opt;
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
 
+	if (disable_nx)
+		vm_disable_nx_huge_pages(vm);
+
 	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS_HUGETLB,
 				    HPAGE_PADDR_START, HPAGE_SLOT,
 				    HPAGE_SLOT_NPAGES, 0);
@@ -81,25 +108,25 @@ int main(int argc, char **argv)
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
 
 	/* Give recovery thread time to run */
 	sleep(3);
-	check_2m_page_count(vm, 1);
+	check_2m_page_count(vm, disable_nx ? 4 : 1);
 	check_split_count(vm, 0);
 
 	/*
@@ -107,13 +134,13 @@ int main(int argc, char **argv)
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
index a5f946fb0626..205d8c9fd750 100755
--- a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh
+++ b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh
@@ -14,7 +14,7 @@ echo 1 > /sys/module/kvm/parameters/nx_huge_pages_recovery_ratio
 echo 2 > /sys/module/kvm/parameters/nx_huge_pages_recovery_period_ms
 echo 200 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
 
-./nx_huge_pages_test
+./nx_huge_pages_test "${@}"
 RET=$?
 
 echo $NX_HUGE_PAGES > /sys/module/kvm/parameters/nx_huge_pages
-- 
2.35.1.616.g0bdcbb4464-goog

