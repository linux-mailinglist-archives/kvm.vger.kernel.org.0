Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 083E84369A8
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 19:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232473AbhJURtO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 13:49:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232615AbhJURra (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Oct 2021 13:47:30 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89631C0432D0
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 10:43:16 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id e6-20020a170902ed8600b0013f165d1b51so537327plj.15
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 10:43:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=G+Eb+AKiudzJdpfkaf1MGAuq6eL6ODdOkLPKTe9XNic=;
        b=nX/NBARWooFEbcShaSrRxq0Xx9MibFPcZB/2i1Mn2Ln5zbeod1pVWq2LFu/qbyZMdt
         EAMAeWmMIFr8uxc67uN5IIb5jL49i4lKg/xofvh2CxGZsIkVrrgoPb5peWknV1iqThh9
         Jgov+WQpSu/2u55SKHOsKxoSIpvlnylmre0J7l4d5vpCJgxPzNA1IXyCxEYaCh71uICI
         DOkiYpGwCLMSpobuVPvKgS6Np0B+I1YJz81K3rfa7H131nGPMeuXrc0OdsfAkIPvGQgp
         IPFoeG8Inlp4J1I2nxkTjWWFfPTX8NRl6uHmXj5JhN56pfFjLgG6QmmGWd/ETnlRoZwP
         jysA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=G+Eb+AKiudzJdpfkaf1MGAuq6eL6ODdOkLPKTe9XNic=;
        b=PLPfz53HHcd3C6U2yLNmrLOppSPcbNh88ClxNVVfgTq5+lMaWVwUW28AXSI4k7/iHa
         mrJXQrC/Soy3oTUL2hcKlqWh8rULNmObMzeGsY8OUZGvlJ2cb/SHvK55rXgDz5Wl8WrL
         T1Gn/O+rQ5Vf1LDcsooarnEg0sFuWMB4PWdnCqcVjpOySZEkjCJ7Jl/4Ge0f5bszH2at
         k1vKlColCec9TKz1g5zMeJeqSdgbW0B/K0rAK+Hto6SwK2arNGJxZASsyFrZ8U61Kqw5
         IwdWQFhc0bL8ay6sFw4Ltf7Y+UPANa/uIURS/6hi/aGl7SxYz2tmPwk98o7AZ5cueXc+
         hUUg==
X-Gm-Message-State: AOAM530mjmCeKfW64qqdQCy+FKDY4no12TAI2EaWOz2tMsEgNtkkfQE7
        n8NgK7wfLygcoRcwLA698WhoYB+RnCPTBeWipjWmYETMt5drpJMO9Y+sB70/HnBLAdUvjAj/Uv/
        Ns8yNVR+Xq6QQPoJk11jMiwDccuGHTPf2cQaI4oJFfGhX7UTSN+Oolcb2vA==
X-Google-Smtp-Source: ABdhPJzx9vLVdSN2d46+zIV9wo4+PMvRzQ01Cb1WkRwJG3OWv3V/pZhk6sgx5cScCDB8C/+pA46OrV5NhtI=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:204:da2d:dcb2:6:add9])
 (user=pgonda job=sendgmr) by 2002:a63:7c5b:: with SMTP id l27mr5415408pgn.227.1634838195703;
 Thu, 21 Oct 2021 10:43:15 -0700 (PDT)
Date:   Thu, 21 Oct 2021 10:43:03 -0700
In-Reply-To: <20211021174303.385706-1-pgonda@google.com>
Message-Id: <20211021174303.385706-6-pgonda@google.com>
Mime-Version: 1.0
References: <20211021174303.385706-1-pgonda@google.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
Subject: [PATCH V11 5/5] selftest: KVM: Add intra host migration tests
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Orr <marcorr@google.com>,
        David Rientjes <rientjes@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Adds testcases for intra host migration for SEV and SEV-ES. Also adds
locking test to confirm no deadlock exists.

Signed-off-by: Peter Gonda <pgonda@google.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Cc: Marc Orr <marcorr@google.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 tools/testing/selftests/kvm/Makefile          |   3 +-
 .../selftests/kvm/x86_64/sev_vm_tests.c       | 203 ++++++++++++++++++
 2 files changed, 205 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/sev_vm_tests.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index d1774f461393..c6b37d2045d9 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -72,7 +72,8 @@ TEST_GEN_PROGS_x86_64 += x86_64/tsc_msrs_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_pmu_msrs_test
 TEST_GEN_PROGS_x86_64 += x86_64/xen_shinfo_test
 TEST_GEN_PROGS_x86_64 += x86_64/xen_vmcall_test
-TEST_GEN_PROGS_x86_64 += access_tracking_perf_test
+TEST_GEN_PROGS_x86_64 += x86_64/vmx_pi_mmio_test
+TEST_GEN_PROGS_x86_64 += x86_64/sev_vm_tests
 TEST_GEN_PROGS_x86_64 += demand_paging_test
 TEST_GEN_PROGS_x86_64 += dirty_log_test
 TEST_GEN_PROGS_x86_64 += dirty_log_perf_test
diff --git a/tools/testing/selftests/kvm/x86_64/sev_vm_tests.c b/tools/testing/selftests/kvm/x86_64/sev_vm_tests.c
new file mode 100644
index 000000000000..ec3bbc96e73a
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/sev_vm_tests.c
@@ -0,0 +1,203 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <linux/kvm.h>
+#include <linux/psp-sev.h>
+#include <stdio.h>
+#include <sys/ioctl.h>
+#include <stdlib.h>
+#include <errno.h>
+#include <pthread.h>
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+#include "svm_util.h"
+#include "kselftest.h"
+#include "../lib/kvm_util_internal.h"
+
+#define SEV_POLICY_ES 0b100
+
+#define NR_MIGRATE_TEST_VCPUS 4
+#define NR_MIGRATE_TEST_VMS 3
+#define NR_LOCK_TESTING_THREADS 3
+#define NR_LOCK_TESTING_ITERATIONS 10000
+
+static void sev_ioctl(int vm_fd, int cmd_id, void *data)
+{
+	struct kvm_sev_cmd cmd = {
+		.id = cmd_id,
+		.data = (uint64_t)data,
+		.sev_fd = open_sev_dev_path_or_exit(),
+	};
+	int ret;
+
+	ret = ioctl(vm_fd, KVM_MEMORY_ENCRYPT_OP, &cmd);
+	TEST_ASSERT((ret == 0 || cmd.error == SEV_RET_SUCCESS),
+		    "%d failed: return code: %d, errno: %d, fw error: %d",
+		    cmd_id, ret, errno, cmd.error);
+}
+
+static struct kvm_vm *sev_vm_create(bool es)
+{
+	struct kvm_vm *vm;
+	struct kvm_sev_launch_start start = { 0 };
+	int i;
+
+	vm = vm_create(VM_MODE_DEFAULT, 0, O_RDWR);
+	sev_ioctl(vm->fd, es ? KVM_SEV_ES_INIT : KVM_SEV_INIT, NULL);
+	for (i = 0; i < NR_MIGRATE_TEST_VCPUS; ++i)
+		vm_vcpu_add(vm, i);
+	if (es)
+		start.policy |= SEV_POLICY_ES;
+	sev_ioctl(vm->fd, KVM_SEV_LAUNCH_START, &start);
+	if (es)
+		sev_ioctl(vm->fd, KVM_SEV_LAUNCH_UPDATE_VMSA, NULL);
+	return vm;
+}
+
+static struct kvm_vm *__vm_create(void)
+{
+	struct kvm_vm *vm;
+	int i;
+
+	vm = vm_create(VM_MODE_DEFAULT, 0, O_RDWR);
+	for (i = 0; i < NR_MIGRATE_TEST_VCPUS; ++i)
+		vm_vcpu_add(vm, i);
+
+	return vm;
+}
+
+static int __sev_migrate_from(int dst_fd, int src_fd)
+{
+	struct kvm_enable_cap cap = {
+		.cap = KVM_CAP_VM_MIGRATE_PROTECTED_VM_FROM,
+		.args = { src_fd }
+	};
+
+	return ioctl(dst_fd, KVM_ENABLE_CAP, &cap);
+}
+
+
+static void sev_migrate_from(int dst_fd, int src_fd)
+{
+	int ret;
+
+	ret = __sev_migrate_from(dst_fd, src_fd);
+	TEST_ASSERT(!ret, "Migration failed, ret: %d, errno: %d\n", ret, errno);
+}
+
+static void test_sev_migrate_from(bool es)
+{
+	struct kvm_vm *src_vm;
+	struct kvm_vm *dst_vms[NR_MIGRATE_TEST_VMS];
+	int i;
+
+	src_vm = sev_vm_create(es);
+	for (i = 0; i < NR_MIGRATE_TEST_VMS; ++i)
+		dst_vms[i] = __vm_create();
+
+	/* Initial migration from the src to the first dst. */
+	sev_migrate_from(dst_vms[0]->fd, src_vm->fd);
+
+	for (i = 1; i < NR_MIGRATE_TEST_VMS; i++)
+		sev_migrate_from(dst_vms[i]->fd, dst_vms[i - 1]->fd);
+
+	/* Migrate the guest back to the original VM. */
+	sev_migrate_from(src_vm->fd, dst_vms[NR_MIGRATE_TEST_VMS - 1]->fd);
+
+	kvm_vm_free(src_vm);
+	for (i = 0; i < NR_MIGRATE_TEST_VMS; ++i)
+		kvm_vm_free(dst_vms[i]);
+}
+
+struct locking_thread_input {
+	struct kvm_vm *vm;
+	int source_fds[NR_LOCK_TESTING_THREADS];
+};
+
+static void *locking_test_thread(void *arg)
+{
+	int i, j;
+	struct locking_thread_input *input = (struct locking_test_thread *)arg;
+
+	for (i = 0; i < NR_LOCK_TESTING_ITERATIONS; ++i) {
+		j = i % NR_LOCK_TESTING_THREADS;
+		__sev_migrate_from(input->vm->fd, input->source_fds[j]);
+	}
+
+	return NULL;
+}
+
+static void test_sev_migrate_locking(void)
+{
+	struct locking_thread_input input[NR_LOCK_TESTING_THREADS];
+	pthread_t pt[NR_LOCK_TESTING_THREADS];
+	int i;
+
+	for (i = 0; i < NR_LOCK_TESTING_THREADS; ++i) {
+		input[i].vm = sev_vm_create(/* es= */ false);
+		input[0].source_fds[i] = input[i].vm->fd;
+	}
+	for (i = 1; i < NR_LOCK_TESTING_THREADS; ++i)
+		memcpy(input[i].source_fds, input[0].source_fds,
+		       sizeof(input[i].source_fds));
+
+	for (i = 0; i < NR_LOCK_TESTING_THREADS; ++i)
+		pthread_create(&pt[i], NULL, locking_test_thread, &input[i]);
+
+	for (i = 0; i < NR_LOCK_TESTING_THREADS; ++i)
+		pthread_join(pt[i], NULL);
+}
+
+static void test_sev_migrate_parameters(void)
+{
+	struct kvm_vm *sev_vm, *sev_es_vm, *vm_no_vcpu, *vm_no_sev,
+		*sev_es_vm_no_vmsa;
+	int ret;
+
+	sev_vm = sev_vm_create(/* es= */ false);
+	sev_es_vm = sev_vm_create(/* es= */ true);
+	vm_no_vcpu = vm_create(VM_MODE_DEFAULT, 0, O_RDWR);
+	vm_no_sev = __vm_create();
+	sev_es_vm_no_vmsa = vm_create(VM_MODE_DEFAULT, 0, O_RDWR);
+	sev_ioctl(sev_es_vm_no_vmsa->fd, KVM_SEV_ES_INIT, NULL);
+	vm_vcpu_add(sev_es_vm_no_vmsa, 1);
+
+
+	ret = __sev_migrate_from(sev_vm->fd, sev_es_vm->fd);
+	TEST_ASSERT(
+		ret == -1 && errno == EINVAL,
+		"Should not be able migrate to SEV enabled VM. ret: %d, errno: %d\n",
+		ret, errno);
+
+	ret = __sev_migrate_from(sev_es_vm->fd, sev_vm->fd);
+	TEST_ASSERT(
+		ret == -1 && errno == EINVAL,
+		"Should not be able migrate to SEV-ES enabled VM. ret: %d, errno: %d\n",
+		ret, errno);
+
+	ret = __sev_migrate_from(vm_no_vcpu->fd, sev_es_vm->fd);
+	TEST_ASSERT(
+		ret == -1 && errno == EINVAL,
+		"SEV-ES migrations require same number of vCPUS. ret: %d, errno: %d\n",
+		ret, errno);
+
+	ret = __sev_migrate_from(vm_no_vcpu->fd, sev_es_vm_no_vmsa->fd);
+	TEST_ASSERT(
+		ret == -1 && errno == EINVAL,
+		"SEV-ES migrations require UPDATE_VMSA. ret %d, errno: %d\n",
+		ret, errno);
+
+	ret = __sev_migrate_from(vm_no_vcpu->fd, vm_no_sev->fd);
+	TEST_ASSERT(ret == -1 && errno == EINVAL,
+		    "Migrations require SEV enabled. ret %d, errno: %d\n", ret,
+		    errno);
+}
+
+int main(int argc, char *argv[])
+{
+	test_sev_migrate_from(/* es= */ false);
+	test_sev_migrate_from(/* es= */ true);
+	test_sev_migrate_locking();
+	test_sev_migrate_parameters();
+	return 0;
+}
-- 
2.33.0.1079.g6e70778dc9-goog

