Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21F174E3531
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 01:07:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233687AbiCUXvW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 19:51:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233692AbiCUXvO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 19:51:14 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC020195D8A
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 16:49:21 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id j1-20020a170903028100b0014b1f9e0068so6234635plr.8
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 16:49:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=m5T3Hbrl4DyDMOn7A4MiOSbjCSgOB5xSxPj2asSn9Wg=;
        b=Zacml26OoL/GF6NlL2gXG5FXZUDRoVGueOLiN6hKDPI9ASu/bkCxXaoxGt8/F0Mh5J
         FWAq8pUohHlkR4XmRKhyQX+XZq5v4u5JIPCUzw9V+zwzW3CD09XBZejqxuTyU+Ii6p5B
         h+Y6Mgnp/2n0gVU4Y4TPVDo9iP7NTj1BSTk5eHfqbtDS08cJpEdPHNTIFJhzeaylgWGK
         HCBBpc9KmVs32VdzG55JHsK/Ub+SjtOb9RQrJSwQiVk1whsye2wBJCWaosKcrBzNQroP
         kwSzod88EmWiLZ9h8zLQyjncwJB9lHtFgRayQOIFH24ZZj+dulNmO9RI7Mi8JwBXLPiG
         qoOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=m5T3Hbrl4DyDMOn7A4MiOSbjCSgOB5xSxPj2asSn9Wg=;
        b=xnmpUA7Zoq44nbrOgqOqycBJOTwyfaPOt6d8gzFbP1LHgJtunIoYnMDUDZ7ywt98kI
         NMSxDWbYYleEbHQ0fE9O92rcfI0IXSXw4gqKYSgy/kYbngg7avvMoPb/EbZmTf/ajR8Z
         HEfACHSlAqCL5LeLKSTDdXF5gGuWAlvj4YyfEn2CNEMsv4NYJ8LKmd844nYKj05IhDZ+
         okxTvAUkyq3yTRN8ISF7bXKQqQfRPscD70KArAueLRjbPOfpr6zEYjTL3zyZ7uonuZDq
         w4Dz/LPVNRpgyJr664rp+Ee2EI6ZJBmJiE+OONse1LKivwwSmHxX9fJ4HVgpsFvvxL90
         UtvQ==
X-Gm-Message-State: AOAM530mIclMN0y+KryagLprVLitxo/LxuIT6S4wX7yQqg4gAO4aUBJx
        V4vCYVTQR+5PM4foi6ROrS7vVuoJOnaZ
X-Google-Smtp-Source: ABdhPJxiNgqjZsgRsl/JaT3z6xvFFNLrDtQigGPFZbUOauwKxglp+Z1PfpkQGMLQS016z4FSanVYNBEijQ/w
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:b76a:f152:cb5e:5cd2])
 (user=bgardon job=sendgmr) by 2002:a17:90b:e81:b0:1c6:5a9c:5afa with SMTP id
 fv1-20020a17090b0e8100b001c65a9c5afamr204556pjb.1.1647906560754; Mon, 21 Mar
 2022 16:49:20 -0700 (PDT)
Date:   Mon, 21 Mar 2022 16:48:44 -0700
In-Reply-To: <20220321234844.1543161-1-bgardon@google.com>
Message-Id: <20220321234844.1543161-12-bgardon@google.com>
Mime-Version: 1.0
References: <20220321234844.1543161-1-bgardon@google.com>
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH v2 11/11] KVM: x86/MMU: Require reboot permission to disable
 NX hugepages
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

Ensure that the userspace actor attempting to disable NX hugepages has
permission to reboot the system. Since disabling NX hugepages would
allow a guest to crash the system, it is similar to reboot permissions.

This approach is the simplest permission gating, but passing a file
descriptor opened for write for the module parameter would also work
well and be more precise.
The latter approach was suggested by Sean Christopherson.

Suggested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/x86.c                            | 18 ++++++-
 .../selftests/kvm/include/kvm_util_base.h     |  2 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  7 +++
 .../selftests/kvm/x86_64/nx_huge_pages_test.c | 49 ++++++++++++++-----
 .../kvm/x86_64/nx_huge_pages_test.sh          |  2 +-
 5 files changed, 65 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 74351cbb9b5b..995f30667619 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4256,7 +4256,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_SYS_ATTRIBUTES:
 	case KVM_CAP_VAPIC:
 	case KVM_CAP_ENABLE_CAP:
-	case KVM_CAP_VM_DISABLE_NX_HUGE_PAGES:
 		r = 1;
 		break;
 	case KVM_CAP_EXIT_HYPERCALL:
@@ -4359,6 +4358,14 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_DISABLE_QUIRKS2:
 		r = KVM_X86_VALID_QUIRKS;
 		break;
+	case KVM_CAP_VM_DISABLE_NX_HUGE_PAGES:
+		/*
+		 * Since the risk of disabling NX hugepages is a guest crashing
+		 * the system, ensure the userspace process has permission to
+		 * reboot the system.
+		 */
+		r = capable(CAP_SYS_BOOT);
+		break;
 	default:
 		break;
 	}
@@ -6050,6 +6057,15 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		mutex_unlock(&kvm->lock);
 		break;
 	case KVM_CAP_VM_DISABLE_NX_HUGE_PAGES:
+		/*
+		 * Since the risk of disabling NX hugepages is a guest crashing
+		 * the system, ensure the userspace process has permission to
+		 * reboot the system.
+		 */
+		if (!capable(CAP_SYS_BOOT)) {
+			r = -EPERM;
+			break;
+		}
 		kvm->arch.disable_nx_huge_pages = true;
 		kvm_update_nx_huge_pages(kvm);
 		r = 0;
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
index 2bcbe4efdc6a..5ce98f759bc8 100644
--- a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
+++ b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
@@ -57,13 +57,40 @@ static void check_split_count(struct kvm_vm *vm, int expected_splits)
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
@@ -83,21 +110,21 @@ int main(int argc, char **argv)
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
@@ -110,7 +137,7 @@ int main(int argc, char **argv)
 	/*
 	 * Now that the reclaimer has run, all the split pages should be gone.
 	 */
-	check_2m_page_count(vm, 1);
+	check_2m_page_count(vm, disable_nx ? 4 : 1);
 	check_split_count(vm, 0);
 
 	/*
@@ -118,13 +145,13 @@ int main(int argc, char **argv)
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
2.35.1.894.gb6a874cedc-goog

