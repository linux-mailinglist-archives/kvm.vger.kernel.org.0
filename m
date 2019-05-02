Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 128E1121E4
	for <lists+kvm@lfdr.de>; Thu,  2 May 2019 20:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbfEBSbr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 May 2019 14:31:47 -0400
Received: from mail-yw1-f73.google.com ([209.85.161.73]:42879 "EHLO
        mail-yw1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726193AbfEBSbq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 May 2019 14:31:46 -0400
Received: by mail-yw1-f73.google.com with SMTP id q2so5092598ywd.9
        for <kvm@vger.kernel.org>; Thu, 02 May 2019 11:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=nttFQl4+ZyYOOOXVU4coa0ys0cbTGwDwPaM88r9bviQ=;
        b=W6Oj0OKmvQ/NNikjF23W0wA20glHyARLpnelj9Z94hCer7cD/EvWbTMG+Lv4exSWpE
         gdB87Y/pP8IS9RWkgHlH6V+4bIdsqrawXO2cyI6+koXahdNZOtjPw0S9/ltHkVc0gcVZ
         thyJm5ieoiGZcTZicNid5EAby+j7v7IzeWcd4QdZq43PPtQiZV4iPtW2sMNa275/qWww
         vA93pIRZWiwF1Qd5leqKinATWydHMPczqdOG3umej1ntTiPZaOFm28W4PGpOVRe/6t/L
         j/Tm89lswikwt56SIWhtgj1Cu85/eys9FPTaMJRs2sWUcE2aMYqNAZci4Rn+52hZ2l7q
         JhbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=nttFQl4+ZyYOOOXVU4coa0ys0cbTGwDwPaM88r9bviQ=;
        b=aaybNmoY/0jelcmnet9udHd6EXHQCYzmy+k5UZeYhhQFibbTi+V47b9nLKLHoaYzVg
         doe2nHOsmhr4ZjwtfP18viHsqsmIgNRD9dV6BTaxHR5a2zbn1IVMYQl2IzSSrPQnTIwn
         joP6+rwbDmoApShA68OYUjmTkBnyhxYEN1k3iZHxPacz7pTS9/VNBo+AUGaohLP6l3Qx
         bBghhmTrsZucvAfPdrh4HBcol9M1S/5SJmCnOnFzOs1UEH88NlArQdHWlMtgvmj4P7bC
         N19Z8pWxFx0EwVYJ2kaWCf+dIZS4q/Y04FmDCgxCfB7xPvbgbeQ7sZIVaSo9yURNHG4p
         gISA==
X-Gm-Message-State: APjAAAUN2wzrYa375h4dgPLqEUrTwn+BGdMqhOFj63epH3zABGqxS3cJ
        UJ1fETqN70xwkLdwpYzODwwPh7YMsCNRc6WX
X-Google-Smtp-Source: APXvYqy3e8IFu87JztVhU26+Qd4krEjo0uuoir4n0tEPKsCxndrVp9pEqNfyl+z2fO2UzH3szE1iQT+iiEdN9ulx
X-Received: by 2002:a25:bc0a:: with SMTP id i10mr4467444ybh.121.1556821905858;
 Thu, 02 May 2019 11:31:45 -0700 (PDT)
Date:   Thu,  2 May 2019 11:31:41 -0700
Message-Id: <20190502183141.258667-1-aaronlewis@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.21.0.593.g511ec345e18-goog
Subject: [PATCH 3/3] tests: kvm: Add tests for KVM_SET_NESTED_STATE
From:   Aaron Lewis <aaronlewis@google.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, jmattson@google.com,
        marcorr@google.com, kvm@vger.kernel.org
Cc:     Aaron Lewis <aaronlewis@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add tests for KVM_SET_NESTED_STATE and for various code paths in its implementation in vmx_set_nested_state().

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Reviewed-by: Marc Orr <marcorr@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../testing/selftests/kvm/include/kvm_util.h  |   4 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  32 ++
 .../kvm/x86_64/vmx_set_nested_state_test.c    | 275 ++++++++++++++++++
 5 files changed, 313 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 2689d1ea6d7a..bbaa97dbd19e 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -6,4 +6,5 @@
 /x86_64/vmx_close_while_nested_test
 /x86_64/vmx_tsc_adjust_test
 /x86_64/state_test
+/x86_64/vmx_set_nested_state_test
 /dirty_log_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index f8588cca2bef..10eff4317226 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -20,6 +20,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/evmcs_test
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_cpuid
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_close_while_nested_test
 TEST_GEN_PROGS_x86_64 += x86_64/smm_test
+TEST_GEN_PROGS_x86_64 += x86_64/vmx_set_nested_state_test
 TEST_GEN_PROGS_x86_64 += dirty_log_test
 TEST_GEN_PROGS_x86_64 += clear_dirty_log_test
 
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 07b71ad9734a..8c6b9619797d 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -118,6 +118,10 @@ void vcpu_events_get(struct kvm_vm *vm, uint32_t vcpuid,
 		     struct kvm_vcpu_events *events);
 void vcpu_events_set(struct kvm_vm *vm, uint32_t vcpuid,
 		     struct kvm_vcpu_events *events);
+void vcpu_nested_state_get(struct kvm_vm *vm, uint32_t vcpuid,
+			   struct kvm_nested_state *state);
+int vcpu_nested_state_set(struct kvm_vm *vm, uint32_t vcpuid,
+			  struct kvm_nested_state *state, bool ignore_error);
 
 const char *exit_reason_str(unsigned int exit_reason);
 
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 4ca96b228e46..e9113857f44e 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1250,6 +1250,38 @@ void vcpu_events_set(struct kvm_vm *vm, uint32_t vcpuid,
 		ret, errno);
 }
 
+void vcpu_nested_state_get(struct kvm_vm *vm, uint32_t vcpuid,
+			   struct kvm_nested_state *state)
+{
+	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
+	int ret;
+
+	TEST_ASSERT(vcpu != NULL, "vcpu not found, vcpuid: %u", vcpuid);
+
+	ret = ioctl(vcpu->fd, KVM_GET_NESTED_STATE, state);
+	TEST_ASSERT(ret == 0,
+		"KVM_SET_NESTED_STATE failed, ret: %i errno: %i",
+		ret, errno);
+}
+
+int vcpu_nested_state_set(struct kvm_vm *vm, uint32_t vcpuid,
+			  struct kvm_nested_state *state, bool ignore_error)
+{
+	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
+	int ret;
+
+	TEST_ASSERT(vcpu != NULL, "vcpu not found, vcpuid: %u", vcpuid);
+
+	ret = ioctl(vcpu->fd, KVM_SET_NESTED_STATE, state);
+	if (!ignore_error) {
+		TEST_ASSERT(ret == 0,
+			"KVM_SET_NESTED_STATE failed, ret: %i errno: %i",
+			ret, errno);
+	}
+
+	return ret;
+}
+
 /*
  * VM VCPU System Regs Get
  *
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c b/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
new file mode 100644
index 000000000000..5eea24087d19
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
@@ -0,0 +1,275 @@
+/*
+ * vmx_set_nested_state_test
+ *
+ * Copyright (C) 2019, Google LLC.
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2.
+ *
+ * This test verifies the integrity of calling the ioctl KVM_SET_NESTED_STATE.
+ */
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+#include "vmx.h"
+
+#include <errno.h>
+#include <linux/kvm.h>
+#include <string.h>
+#include <sys/ioctl.h>
+#include <unistd.h>
+
+/*
+ * Mirror of VMCS12_REVISION in arch/x86/kvm/vmx/vmcs12.h. If that value
+ * changes this should be updated.
+ */
+#define VMCS12_REVISION 0x11e57ed0
+#define VCPU_ID 5
+
+void test_nested_state(struct kvm_vm *vm, struct kvm_nested_state *state)
+{
+	volatile struct kvm_run *run;
+
+	vcpu_nested_state_set(vm, VCPU_ID, state, false);
+	run = vcpu_state(vm, VCPU_ID);
+	vcpu_run(vm, VCPU_ID);
+	TEST_ASSERT(run->exit_reason == KVM_EXIT_SHUTDOWN,
+		"Got exit_reason other than KVM_EXIT_SHUTDOWN: %u (%s),\n",
+		run->exit_reason,
+		exit_reason_str(run->exit_reason));
+}
+
+void test_nested_state_expect_errno(struct kvm_vm *vm,
+				    struct kvm_nested_state *state,
+				    int expected_errno)
+{
+	volatile struct kvm_run *run;
+	int rv;
+
+	rv = vcpu_nested_state_set(vm, VCPU_ID, state, true);
+	TEST_ASSERT(rv == -1 && errno == expected_errno,
+		"Expected %s (%d) from vcpu_nested_state_set but got rv: %i errno: %s (%d)",
+		strerror(expected_errno), expected_errno, rv, strerror(errno),
+		errno);
+	run = vcpu_state(vm, VCPU_ID);
+	vcpu_run(vm, VCPU_ID);
+	TEST_ASSERT(run->exit_reason == KVM_EXIT_SHUTDOWN,
+		"Got exit_reason other than KVM_EXIT_SHUTDOWN: %u (%s),\n",
+		run->exit_reason,
+		exit_reason_str(run->exit_reason));
+}
+
+void test_nested_state_expect_einval(struct kvm_vm *vm,
+				     struct kvm_nested_state *state)
+{
+	test_nested_state_expect_errno(vm, state, EINVAL);
+}
+
+void test_nested_state_expect_efault(struct kvm_vm *vm,
+				     struct kvm_nested_state *state)
+{
+	test_nested_state_expect_errno(vm, state, EFAULT);
+}
+
+void set_revision_id_for_vmcs12(struct kvm_nested_state *state,
+				u32 vmcs12_revision)
+{
+	/* Set revision_id in vmcs12 to vmcs12_revision. */
+	*(u32 *)(state->data) = vmcs12_revision;
+}
+
+void set_default_state(struct kvm_nested_state *state)
+{
+	memset(state, 0, sizeof(*state));
+	state->flags = KVM_STATE_NESTED_RUN_PENDING |
+		       KVM_STATE_NESTED_GUEST_MODE;
+	state->format = 0;
+	state->size = sizeof(*state);
+}
+
+void set_default_vmx_state(struct kvm_nested_state *state, int size)
+{
+	memset(state, 0, size);
+	state->flags = KVM_STATE_NESTED_GUEST_MODE  |
+			KVM_STATE_NESTED_RUN_PENDING |
+			KVM_STATE_NESTED_EVMCS;
+	state->format = 0;
+	state->size = size;
+	state->vmx.vmxon_pa = 0x1000;
+	state->vmx.vmcs_pa = 0x2000;
+	state->vmx.smm.flags = 0;
+	set_revision_id_for_vmcs12(state, VMCS12_REVISION);
+}
+
+void test_vmx_nested_state(struct kvm_vm *vm)
+{
+	/* Add a page for VMCS12. */
+	const int state_sz = sizeof(struct kvm_nested_state) + getpagesize();
+	struct kvm_nested_state *state =
+		(struct kvm_nested_state *)malloc(state_sz);
+
+	/* The format must be set to 0. 0 for VMX, 1 for SVM. */
+	set_default_vmx_state(state, state_sz);
+	state->format = 1;
+	test_nested_state_expect_einval(vm, state);
+
+	/*
+	 * We cannot virtualize anything if the guest does not have VMX
+	 * enabled.
+	 */
+	set_default_vmx_state(state, state_sz);
+	test_nested_state_expect_einval(vm, state);
+
+	/*
+	 * We cannot virtualize anything if the guest does not have VMX
+	 * enabled.  We expect KVM_SET_NESTED_STATE to return 0 if vmxon_pa
+	 * is set to -1ull.
+	 */
+	set_default_vmx_state(state, state_sz);
+	state->vmx.vmxon_pa = -1ull;
+	test_nested_state(vm, state);
+
+	/* Enable VMX in the guest CPUID. */
+	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
+
+	/* It is invalid to have vmxon_pa == -1ull and SMM flags non-zero. */
+	set_default_vmx_state(state, state_sz);
+	state->vmx.vmxon_pa = -1ull;
+	state->vmx.smm.flags = 1;
+	test_nested_state_expect_einval(vm, state);
+
+	/* It is invalid to have vmxon_pa == -1ull and vmcs_pa != -1ull. */
+	set_default_vmx_state(state, state_sz);
+	state->vmx.vmxon_pa = -1ull;
+	state->vmx.vmcs_pa = 0;
+	test_nested_state_expect_einval(vm, state);
+
+	/*
+	 * Setting vmxon_pa == -1ull and vmcs_pa == -1ull exits early without
+	 * setting the nested state.
+	 */
+	set_default_vmx_state(state, state_sz);
+	state->vmx.vmxon_pa = -1ull;
+	state->vmx.vmcs_pa = -1ull;
+	test_nested_state(vm, state);
+
+	/* It is invalid to have vmxon_pa set to a non-page aligned address. */
+	set_default_vmx_state(state, state_sz);
+	state->vmx.vmxon_pa = 1;
+	test_nested_state_expect_einval(vm, state);
+
+	/*
+	 * It is invalid to have KVM_STATE_NESTED_SMM_GUEST_MODE and
+	 * KVM_STATE_NESTED_GUEST_MODE set together.
+	 */
+	set_default_vmx_state(state, state_sz);
+	state->flags = KVM_STATE_NESTED_GUEST_MODE  |
+		      KVM_STATE_NESTED_RUN_PENDING;
+	state->vmx.smm.flags = KVM_STATE_NESTED_SMM_GUEST_MODE;
+	test_nested_state_expect_einval(vm, state);
+
+	/*
+	 * It is invalid to have any of the SMM flags set besides:
+	 *	KVM_STATE_NESTED_SMM_GUEST_MODE
+	 *	KVM_STATE_NESTED_SMM_VMXON
+	 */
+	set_default_vmx_state(state, state_sz);
+	state->vmx.smm.flags = ~(KVM_STATE_NESTED_SMM_GUEST_MODE |
+				KVM_STATE_NESTED_SMM_VMXON);
+	test_nested_state_expect_einval(vm, state);
+
+	/* Outside SMM, SMM flags must be zero. */
+	set_default_vmx_state(state, state_sz);
+	state->flags = 0;
+	state->vmx.smm.flags = KVM_STATE_NESTED_SMM_GUEST_MODE;
+	test_nested_state_expect_einval(vm, state);
+
+	/* Size must be large enough to fit kvm_nested_state and vmcs12. */
+	set_default_vmx_state(state, state_sz);
+	state->size = sizeof(*state);
+	test_nested_state(vm, state);
+
+	/* vmxon_pa cannot be the same address as vmcs_pa. */
+	set_default_vmx_state(state, state_sz);
+	state->vmx.vmxon_pa = 0;
+	state->vmx.vmcs_pa = 0;
+	test_nested_state_expect_einval(vm, state);
+
+	/* The revision id for vmcs12 must be VMCS12_REVISION. */
+	set_default_vmx_state(state, state_sz);
+	set_revision_id_for_vmcs12(state, 0);
+	test_nested_state_expect_einval(vm, state);
+
+	/*
+	 * Test that if we leave nesting the state reflects that when we get
+	 * it again.
+	 */
+	set_default_vmx_state(state, state_sz);
+	state->vmx.vmxon_pa = -1ull;
+	state->vmx.vmcs_pa = -1ull;
+	state->flags = 0;
+	test_nested_state(vm, state);
+	vcpu_nested_state_get(vm, VCPU_ID, state);
+	TEST_ASSERT(state->size >= sizeof(*state) && state->size <= state_sz,
+		    "Size must be between %d and %d.  The size returned was %d.",
+		    sizeof(*state), state_sz, state->size);
+	TEST_ASSERT(state->vmx.vmxon_pa == -1ull, "vmxon_pa must be -1ull.");
+	TEST_ASSERT(state->vmx.vmcs_pa == -1ull, "vmcs_pa must be -1ull.");
+
+	free(state);
+}
+
+int main(int argc, char *argv[])
+{
+	struct kvm_vm *vm;
+	struct kvm_nested_state state;
+	struct kvm_cpuid_entry2 *entry = kvm_get_supported_cpuid_entry(1);
+
+	/*
+	 * AMD currently does not implement set_nested_state, so for now we
+	 * just early out.
+	 */
+	if (!(entry->ecx & CPUID_VMX)) {
+		fprintf(stderr, "nested VMX not enabled, skipping test\n");
+		exit(KSFT_SKIP);
+	}
+
+	vm = vm_create_default(VCPU_ID, 0, 0);
+
+	/* Passing a NULL kvm_nested_state causes a EFAULT. */
+	test_nested_state_expect_efault(vm, NULL);
+
+	/* 'size' cannot be smaller than sizeof(kvm_nested_state). */
+	set_default_state(&state);
+	state.size = 0;
+	test_nested_state_expect_einval(vm, &state);
+
+	/*
+	 * Setting the flags 0xf fails the flags check.  The only flags that
+	 * can be used are:
+	 *     KVM_STATE_NESTED_GUEST_MODE
+	 *     KVM_STATE_NESTED_RUN_PENDING
+	 *     KVM_STATE_NESTED_EVMCS
+	 */
+	set_default_state(&state);
+	state.flags = 0xf;
+	test_nested_state_expect_einval(vm, &state);
+
+	/*
+	 * If KVM_STATE_NESTED_RUN_PENDING is set then
+	 * KVM_STATE_NESTED_GUEST_MODE has to be set as well.
+	 */
+	set_default_state(&state);
+	state.flags = KVM_STATE_NESTED_RUN_PENDING;
+	test_nested_state_expect_einval(vm, &state);
+
+	/*
+	 * TODO: When SVM support is added for KVM_SET_NESTED_STATE
+	 *       add tests here to support it like VMX.
+	 */
+	if (entry->ecx & CPUID_VMX)
+		test_vmx_nested_state(vm);
+
+	kvm_vm_free(vm);
+	return 0;
+}
-- 
2.21.0.593.g511ec345e18-goog

