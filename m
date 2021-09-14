Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4F8D40B53B
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 18:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbhINQtB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 12:49:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbhINQsz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Sep 2021 12:48:55 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E3CAC061766
        for <kvm@vger.kernel.org>; Tue, 14 Sep 2021 09:47:38 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id a5-20020a656405000000b002692b7b6d95so9746656pgv.11
        for <kvm@vger.kernel.org>; Tue, 14 Sep 2021 09:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=nEzN9hRbkHfp1Go2P4vKAnhGUtg9DnodsmPyxoY5+Bw=;
        b=Z7tnvDe+7SA4bVTQ77dFe7lqvdYrU7IkL4BoUdwI2KcMDnqaShc7PnssO8O7zHZ0Gz
         6p2dz5LQcXUUD5Q3ukk/jIp5o1hZ+WsSXYhLlTcPPh6DNEKXJ07etdWBQMWP8hi1K2e0
         k/CFgBPWKsD1wS3lOqy58EhhBs8h3dAs6FXivJJF2x4/IspjkMQE1/u07a1rDcNzwn7x
         4Aj9f0ma+eYARb9LYsXkSZY+YBA0VY8Dgz5DFamymvRPtLilrqPs3YabNTOF3G58LjMw
         A+OgvRt/cX1VnwmgCrmG2IjU9NLxw+0tp/veJzDxrCY3Kfw+IYHOzysh4nAzkUbKawnp
         1q3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=nEzN9hRbkHfp1Go2P4vKAnhGUtg9DnodsmPyxoY5+Bw=;
        b=gMpKbfmzsb6bN2M5ToW4sPkNTnCwKx8pMujsRXHr3OMSRHGu26gLLDu1lxcGwP6F/o
         xl0WnBICo+uBIIobZslEq7p+D3k5yLMVLRI1XBDkRbZyvp3W4VdeeNJkgYliMU+ffTOl
         p+HwrgiLbksHPldYQRBKokEc8rg+91aRKMvnLTVbESofvKnAYDLXiHdh8+TdNxeRfTN/
         sKTK/OfBBaIzuHU3tuwc/ei3lNP5zqbNRiGWdLSJMtf9ILJ9wjI8i/dujoKj1Q0izkHk
         IvJtQUcrKpIYAxv/IAB6uAdHfs8aLF4wxvMqfzeVnUCPOc5Hhs8N1QY/loBl/Bp4gMdw
         f4CQ==
X-Gm-Message-State: AOAM5332HguYgi6xtWO8vxGpT5Sta9BP3xTb4Vl2jpqQdVmown1kzrnf
        ERQJTB8gilTf0SmuVn5Sg9ZaGkdNS1cLDuD4CAnwSYECOGCjoCVBlAI1fukDvRlcipId3nibvss
        dpG7GA99DTxLjSNSkfeODshuhJTnwhEkQhskbC0bTmR17q0Rs1dDl4bZ9kQ==
X-Google-Smtp-Source: ABdhPJyrpI+j0kUaSBEIkZYtkoHp8PeGuh+ectwaSIO0BRZUjgF4pyomcN9rpOPk29OJ1EGI6X9YF1ixOP4=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:204:b358:1f40:79d5:ab23])
 (user=pgonda job=sendgmr) by 2002:a17:90b:1bd1:: with SMTP id
 oa17mr3183602pjb.82.1631638057872; Tue, 14 Sep 2021 09:47:37 -0700 (PDT)
Date:   Tue, 14 Sep 2021 09:47:27 -0700
In-Reply-To: <20210914164727.3007031-1-pgonda@google.com>
Message-Id: <20210914164727.3007031-5-pgonda@google.com>
Mime-Version: 1.0
References: <20210914164727.3007031-1-pgonda@google.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [PATCH 4/4 V8] selftest: KVM: Add intra host migration tests
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Orr <marcorr@google.com>,
        David Rientjes <rientjes@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Adds testcases for intra host migration for SEV and SEV-ES. Also adds
locking test to confirm no deadlock exists.

Signed-off-by: Peter Gonda <pgonda@google.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Marc Orr <marcorr@google.com>
Cc: Marc Orr <marcorr@google.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/x86_64/sev_vm_tests.c       | 203 ++++++++++++++++++
 2 files changed, 204 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/sev_vm_tests.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index c103873531e0..44fd3566fb51 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -72,6 +72,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/vmx_pmu_msrs_test
 TEST_GEN_PROGS_x86_64 += x86_64/xen_shinfo_test
 TEST_GEN_PROGS_x86_64 += x86_64/xen_vmcall_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_pi_mmio_test
+TEST_GEN_PROGS_x86_64 += x86_64/sev_vm_tests
 TEST_GEN_PROGS_x86_64 += access_tracking_perf_test
 TEST_GEN_PROGS_x86_64 += demand_paging_test
 TEST_GEN_PROGS_x86_64 += dirty_log_test
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
2.33.0.309.g3052b89438-goog

