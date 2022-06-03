Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56AD953C2F6
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240126AbiFCAoz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240067AbiFCAoc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:44:32 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F12C2251B
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:44:31 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id u67-20020a627946000000b0051b9c1256b0so3496595pfc.9
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:44:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=oQCFxAMCy4Jw3XIpLJBHS6CjwFdvmqncc8xgI0mkXvE=;
        b=cb+u0MrvY0qwG6yYIcajRJxDjinOHBOnxIj9/C3BQTYNbiiYPTEUcwH7HJstTeOXBG
         rgcITQi7lKuW/VCIetZmctjuEhh9swe3EXBEAOn8xX2d399IYUiu+j+VUIOh6laT8NS2
         ets/zk81mg14ujWW9DCOfD7U2GRm/x7gTq+UoOp7S/FEfsK0kjDEEXHAhf6kZdXfBuLT
         mPTBPxwFCOkQasXg5QfD8v1mE2X2Uhii3rh6XzJdKmaOGT/fP3vquhZsJUyBp1L0x5C5
         bSrmtk5T4+ZlZ1aF6oaP9yfgxqaxXDxJerIBNJg6ZfJvzrqix1lIbN/8T/hHG4+yu8mI
         e4KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=oQCFxAMCy4Jw3XIpLJBHS6CjwFdvmqncc8xgI0mkXvE=;
        b=oz+SYxcebdBugbXrJE2BYtVkK0hVXI0iDpUFgASbH9ZSBUZ/4AehUj+KIlTHx3ILaN
         M2heEVAa0gqadc6L6yV2SjzueGHViLQMRTFc47tZWt0Le5HCr3aqZZxDLrD74pAV+X8q
         Y93RSJJcOxvwNawPguDoWuiri2ZlDcBtyrU7sOe9LXeO5gvQCCgLrjwLu64Hkux0lSGN
         Iz7zMWv94yjQ+RdV23sbf3ZNbpP7LNcMjMCHQueh854pO32rcprmM6QOJMTi+hK0ZAL1
         If+JP71Y3wcGjkwbjLC+teD1Wsr7XdhJ6wJkR5Hzxp5Z4RB+p7JlQQPeFt5wNMK3ARbM
         zxCQ==
X-Gm-Message-State: AOAM532Ydw8dElArRlMeJ92jBg4lE8rLHU55qMnM9SgV1nlkvZDRDbPT
        5gh8qb4yFjfFv1ddTLyuyVOB526mEVk=
X-Google-Smtp-Source: ABdhPJz62ez6a8c0vVlCM4g19P81v5zbKvAwgB2uHKL7aZeKCHPT+5kmBsl7qS4t0jo3TclNosUHB0ORW60=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:20d4:b0:1e2:fadf:3f09 with SMTP id
 ju20-20020a17090b20d400b001e2fadf3f09mr8183139pjb.236.1654217071073; Thu, 02
 Jun 2022 17:44:31 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:41:37 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-31-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 030/144] KVM: selftests: Consolidate KVM_ENABLE_CAP usage
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
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

Add __vm_enable_cap() and use it for negative tests that expect
KVM_ENABLE_CAP to fail.  Opportunistically clean up the MAX_VCPU_ID test
error messages.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     |  4 +
 tools/testing/selftests/kvm/lib/x86_64/vmx.c  |  2 +-
 .../kvm/x86_64/max_vcpuid_cap_test.c          | 19 ++---
 .../selftests/kvm/x86_64/sev_migrate_tests.c  | 78 +++++++++----------
 4 files changed, 52 insertions(+), 51 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 2e1453cb0511..f0afc1dce8ba 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -231,6 +231,10 @@ static inline int vm_check_cap(struct kvm_vm *vm, long cap)
 	return ret;
 }
 
+static inline int __vm_enable_cap(struct kvm_vm *vm, struct kvm_enable_cap *cap)
+{
+	return __vm_ioctl(vm, KVM_ENABLE_CAP, cap);
+}
 static inline void vm_enable_cap(struct kvm_vm *vm, struct kvm_enable_cap *cap)
 {
 	vm_ioctl(vm, KVM_ENABLE_CAP, cap);
diff --git a/tools/testing/selftests/kvm/lib/x86_64/vmx.c b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
index 0d42aa821833..14a9a0fd2e50 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
@@ -51,7 +51,7 @@ int vcpu_enable_evmcs(struct kvm_vm *vm, int vcpu_id)
 		 .args[0] = (unsigned long)&evmcs_ver
 	};
 
-	vcpu_ioctl(vm, vcpu_id, KVM_ENABLE_CAP, &enable_evmcs_cap);
+	vcpu_enable_cap(vm, vcpu_id, &enable_evmcs_cap);
 
 	/* KVM should return supported EVMCS version range */
 	TEST_ASSERT(((evmcs_ver >> 8) >= (evmcs_ver & 0xff)) &&
diff --git a/tools/testing/selftests/kvm/x86_64/max_vcpuid_cap_test.c b/tools/testing/selftests/kvm/x86_64/max_vcpuid_cap_test.c
index 419fbdc51246..c6fd36a31c8c 100644
--- a/tools/testing/selftests/kvm/x86_64/max_vcpuid_cap_test.c
+++ b/tools/testing/selftests/kvm/x86_64/max_vcpuid_cap_test.c
@@ -25,28 +25,25 @@ int main(int argc, char *argv[])
 	/* Try to set KVM_CAP_MAX_VCPU_ID beyond KVM cap */
 	cap.cap = KVM_CAP_MAX_VCPU_ID;
 	cap.args[0] = ret + 1;
-	ret = ioctl(vm->fd, KVM_ENABLE_CAP, &cap);
+	ret = __vm_enable_cap(vm, &cap);
 	TEST_ASSERT(ret < 0,
-		    "Unexpected success to enable KVM_CAP_MAX_VCPU_ID"
-		    "beyond KVM cap!\n");
+		    "Setting KVM_CAP_MAX_VCPU_ID beyond KVM cap should fail");
 
 	/* Set KVM_CAP_MAX_VCPU_ID */
 	cap.cap = KVM_CAP_MAX_VCPU_ID;
 	cap.args[0] = MAX_VCPU_ID;
-	ret = ioctl(vm->fd, KVM_ENABLE_CAP, &cap);
-	TEST_ASSERT(ret == 0,
-		    "Unexpected failure to enable KVM_CAP_MAX_VCPU_ID!\n");
+	vm_enable_cap(vm, &cap);
+
 
 	/* Try to set KVM_CAP_MAX_VCPU_ID again */
 	cap.args[0] = MAX_VCPU_ID + 1;
-	ret = ioctl(vm->fd, KVM_ENABLE_CAP, &cap);
+	ret = __vm_enable_cap(vm, &cap);
 	TEST_ASSERT(ret < 0,
-		    "Unexpected success to enable KVM_CAP_MAX_VCPU_ID again\n");
+		    "Setting KVM_CAP_MAX_VCPU_ID multiple times should fail");
 
 	/* Create vCPU with id beyond KVM_CAP_MAX_VCPU_ID cap*/
-	ret = ioctl(vm->fd, KVM_CREATE_VCPU, MAX_VCPU_ID);
-	TEST_ASSERT(ret < 0,
-		    "Unexpected success in creating a vCPU with VCPU ID out of range\n");
+	ret = __vm_ioctl(vm, KVM_CREATE_VCPU, (void *)MAX_VCPU_ID);
+	TEST_ASSERT(ret < 0, "Creating vCPU with ID > MAX_VCPU_ID should fail");
 
 	kvm_vm_free(vm);
 	return 0;
diff --git a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
index 5b565aa11e32..f127f2fccca6 100644
--- a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
+++ b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
@@ -80,22 +80,22 @@ static struct kvm_vm *aux_vm_create(bool with_vcpus)
 	return vm;
 }
 
-static int __sev_migrate_from(int dst_fd, int src_fd)
+static int __sev_migrate_from(struct kvm_vm *dst, struct kvm_vm *src)
 {
 	struct kvm_enable_cap cap = {
 		.cap = KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM,
-		.args = { src_fd }
+		.args = { src->fd }
 	};
 
-	return ioctl(dst_fd, KVM_ENABLE_CAP, &cap);
+	return __vm_enable_cap(dst, &cap);
 }
 
 
-static void sev_migrate_from(int dst_fd, int src_fd)
+static void sev_migrate_from(struct kvm_vm *dst, struct kvm_vm *src)
 {
 	int ret;
 
-	ret = __sev_migrate_from(dst_fd, src_fd);
+	ret = __sev_migrate_from(dst, src);
 	TEST_ASSERT(!ret, "Migration failed, ret: %d, errno: %d\n", ret, errno);
 }
 
@@ -110,13 +110,13 @@ static void test_sev_migrate_from(bool es)
 		dst_vms[i] = aux_vm_create(true);
 
 	/* Initial migration from the src to the first dst. */
-	sev_migrate_from(dst_vms[0]->fd, src_vm->fd);
+	sev_migrate_from(dst_vms[0], src_vm);
 
 	for (i = 1; i < NR_MIGRATE_TEST_VMS; i++)
-		sev_migrate_from(dst_vms[i]->fd, dst_vms[i - 1]->fd);
+		sev_migrate_from(dst_vms[i], dst_vms[i - 1]);
 
 	/* Migrate the guest back to the original VM. */
-	ret = __sev_migrate_from(src_vm->fd, dst_vms[NR_MIGRATE_TEST_VMS - 1]->fd);
+	ret = __sev_migrate_from(src_vm, dst_vms[NR_MIGRATE_TEST_VMS - 1]);
 	TEST_ASSERT(ret == -1 && errno == EIO,
 		    "VM that was migrated from should be dead. ret %d, errno: %d\n", ret,
 		    errno);
@@ -128,7 +128,7 @@ static void test_sev_migrate_from(bool es)
 
 struct locking_thread_input {
 	struct kvm_vm *vm;
-	int source_fds[NR_LOCK_TESTING_THREADS];
+	struct kvm_vm *source_vms[NR_LOCK_TESTING_THREADS];
 };
 
 static void *locking_test_thread(void *arg)
@@ -138,7 +138,7 @@ static void *locking_test_thread(void *arg)
 
 	for (i = 0; i < NR_LOCK_TESTING_ITERATIONS; ++i) {
 		j = i % NR_LOCK_TESTING_THREADS;
-		__sev_migrate_from(input->vm->fd, input->source_fds[j]);
+		__sev_migrate_from(input->vm, input->source_vms[j]);
 	}
 
 	return NULL;
@@ -152,11 +152,11 @@ static void test_sev_migrate_locking(void)
 
 	for (i = 0; i < NR_LOCK_TESTING_THREADS; ++i) {
 		input[i].vm = sev_vm_create(/* es= */ false);
-		input[0].source_fds[i] = input[i].vm->fd;
+		input[0].source_vms[i] = input[i].vm;
 	}
 	for (i = 1; i < NR_LOCK_TESTING_THREADS; ++i)
-		memcpy(input[i].source_fds, input[0].source_fds,
-		       sizeof(input[i].source_fds));
+		memcpy(input[i].source_vms, input[0].source_vms,
+		       sizeof(input[i].source_vms));
 
 	for (i = 0; i < NR_LOCK_TESTING_THREADS; ++i)
 		pthread_create(&pt[i], NULL, locking_test_thread, &input[i]);
@@ -175,7 +175,7 @@ static void test_sev_migrate_parameters(void)
 
 	vm_no_vcpu = vm_create(0);
 	vm_no_sev = aux_vm_create(true);
-	ret = __sev_migrate_from(vm_no_vcpu->fd, vm_no_sev->fd);
+	ret = __sev_migrate_from(vm_no_vcpu, vm_no_sev);
 	TEST_ASSERT(ret == -1 && errno == EINVAL,
 		    "Migrations require SEV enabled. ret %d, errno: %d\n", ret,
 		    errno);
@@ -189,25 +189,25 @@ static void test_sev_migrate_parameters(void)
 	sev_ioctl(sev_es_vm_no_vmsa->fd, KVM_SEV_ES_INIT, NULL);
 	vm_vcpu_add(sev_es_vm_no_vmsa, 1);
 
-	ret = __sev_migrate_from(sev_vm->fd, sev_es_vm->fd);
+	ret = __sev_migrate_from(sev_vm, sev_es_vm);
 	TEST_ASSERT(
 		ret == -1 && errno == EINVAL,
 		"Should not be able migrate to SEV enabled VM. ret: %d, errno: %d\n",
 		ret, errno);
 
-	ret = __sev_migrate_from(sev_es_vm->fd, sev_vm->fd);
+	ret = __sev_migrate_from(sev_es_vm, sev_vm);
 	TEST_ASSERT(
 		ret == -1 && errno == EINVAL,
 		"Should not be able migrate to SEV-ES enabled VM. ret: %d, errno: %d\n",
 		ret, errno);
 
-	ret = __sev_migrate_from(vm_no_vcpu->fd, sev_es_vm->fd);
+	ret = __sev_migrate_from(vm_no_vcpu, sev_es_vm);
 	TEST_ASSERT(
 		ret == -1 && errno == EINVAL,
 		"SEV-ES migrations require same number of vCPUS. ret: %d, errno: %d\n",
 		ret, errno);
 
-	ret = __sev_migrate_from(vm_no_vcpu->fd, sev_es_vm_no_vmsa->fd);
+	ret = __sev_migrate_from(vm_no_vcpu, sev_es_vm_no_vmsa);
 	TEST_ASSERT(
 		ret == -1 && errno == EINVAL,
 		"SEV-ES migrations require UPDATE_VMSA. ret %d, errno: %d\n",
@@ -221,22 +221,22 @@ static void test_sev_migrate_parameters(void)
 	kvm_vm_free(vm_no_sev);
 }
 
-static int __sev_mirror_create(int dst_fd, int src_fd)
+static int __sev_mirror_create(struct kvm_vm *dst, struct kvm_vm *src)
 {
 	struct kvm_enable_cap cap = {
 		.cap = KVM_CAP_VM_COPY_ENC_CONTEXT_FROM,
-		.args = { src_fd }
+		.args = { src->fd }
 	};
 
-	return ioctl(dst_fd, KVM_ENABLE_CAP, &cap);
+	return __vm_enable_cap(dst, &cap);
 }
 
 
-static void sev_mirror_create(int dst_fd, int src_fd)
+static void sev_mirror_create(struct kvm_vm *dst, struct kvm_vm *src)
 {
 	int ret;
 
-	ret = __sev_mirror_create(dst_fd, src_fd);
+	ret = __sev_mirror_create(dst, src);
 	TEST_ASSERT(!ret, "Copying context failed, ret: %d, errno: %d\n", ret, errno);
 }
 
@@ -284,7 +284,7 @@ static void test_sev_mirror(bool es)
 	src_vm = sev_vm_create(es);
 	dst_vm = aux_vm_create(false);
 
-	sev_mirror_create(dst_vm->fd, src_vm->fd);
+	sev_mirror_create(dst_vm, src_vm);
 
 	/* Check that we can complete creation of the mirror VM.  */
 	for (i = 0; i < NR_MIGRATE_TEST_VCPUS; ++i)
@@ -308,18 +308,18 @@ static void test_sev_mirror_parameters(void)
 	vm_with_vcpu = aux_vm_create(true);
 	vm_no_vcpu = aux_vm_create(false);
 
-	ret = __sev_mirror_create(sev_vm->fd, sev_vm->fd);
+	ret = __sev_mirror_create(sev_vm, sev_vm);
 	TEST_ASSERT(
 		ret == -1 && errno == EINVAL,
 		"Should not be able copy context to self. ret: %d, errno: %d\n",
 		ret, errno);
 
-	ret = __sev_mirror_create(vm_no_vcpu->fd, vm_with_vcpu->fd);
+	ret = __sev_mirror_create(vm_no_vcpu, vm_with_vcpu);
 	TEST_ASSERT(ret == -1 && errno == EINVAL,
 		    "Copy context requires SEV enabled. ret %d, errno: %d\n", ret,
 		    errno);
 
-	ret = __sev_mirror_create(vm_with_vcpu->fd, sev_vm->fd);
+	ret = __sev_mirror_create(vm_with_vcpu, sev_vm);
 	TEST_ASSERT(
 		ret == -1 && errno == EINVAL,
 		"SEV copy context requires no vCPUS on the destination. ret: %d, errno: %d\n",
@@ -329,13 +329,13 @@ static void test_sev_mirror_parameters(void)
 		goto out;
 
 	sev_es_vm = sev_vm_create(/* es= */ true);
-	ret = __sev_mirror_create(sev_vm->fd, sev_es_vm->fd);
+	ret = __sev_mirror_create(sev_vm, sev_es_vm);
 	TEST_ASSERT(
 		ret == -1 && errno == EINVAL,
 		"Should not be able copy context to SEV enabled VM. ret: %d, errno: %d\n",
 		ret, errno);
 
-	ret = __sev_mirror_create(sev_es_vm->fd, sev_vm->fd);
+	ret = __sev_mirror_create(sev_es_vm, sev_vm);
 	TEST_ASSERT(
 		ret == -1 && errno == EINVAL,
 		"Should not be able copy context to SEV-ES enabled VM. ret: %d, errno: %d\n",
@@ -363,16 +363,16 @@ static void test_sev_move_copy(void)
 	dst2_mirror_vm = aux_vm_create(false);
 	dst3_mirror_vm = aux_vm_create(false);
 
-	sev_mirror_create(mirror_vm->fd, sev_vm->fd);
+	sev_mirror_create(mirror_vm, sev_vm);
 
-	sev_migrate_from(dst_mirror_vm->fd, mirror_vm->fd);
-	sev_migrate_from(dst_vm->fd, sev_vm->fd);
+	sev_migrate_from(dst_mirror_vm, mirror_vm);
+	sev_migrate_from(dst_vm, sev_vm);
 
-	sev_migrate_from(dst2_vm->fd, dst_vm->fd);
-	sev_migrate_from(dst2_mirror_vm->fd, dst_mirror_vm->fd);
+	sev_migrate_from(dst2_vm, dst_vm);
+	sev_migrate_from(dst2_mirror_vm, dst_mirror_vm);
 
-	sev_migrate_from(dst3_mirror_vm->fd, dst2_mirror_vm->fd);
-	sev_migrate_from(dst3_vm->fd, dst2_vm->fd);
+	sev_migrate_from(dst3_mirror_vm, dst2_mirror_vm);
+	sev_migrate_from(dst3_vm, dst2_vm);
 
 	kvm_vm_free(dst_vm);
 	kvm_vm_free(sev_vm);
@@ -392,10 +392,10 @@ static void test_sev_move_copy(void)
 	mirror_vm = aux_vm_create(false);
 	dst_mirror_vm = aux_vm_create(false);
 
-	sev_mirror_create(mirror_vm->fd, sev_vm->fd);
+	sev_mirror_create(mirror_vm, sev_vm);
 
-	sev_migrate_from(dst_mirror_vm->fd, mirror_vm->fd);
-	sev_migrate_from(dst_vm->fd, sev_vm->fd);
+	sev_migrate_from(dst_mirror_vm, mirror_vm);
+	sev_migrate_from(dst_vm, sev_vm);
 
 	kvm_vm_free(mirror_vm);
 	kvm_vm_free(dst_mirror_vm);
-- 
2.36.1.255.ge46751e96f-goog

