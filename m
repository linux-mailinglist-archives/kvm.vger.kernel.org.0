Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1061422AAD
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 16:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235871AbhJEORI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 10:17:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235358AbhJEOQ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Oct 2021 10:16:58 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C24AC0612A5
        for <kvm@vger.kernel.org>; Tue,  5 Oct 2021 07:14:14 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id p19-20020a634f53000000b002877a03b293so12503297pgl.10
        for <kvm@vger.kernel.org>; Tue, 05 Oct 2021 07:14:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=YUtrtiwbKfY9rDzT+0XeYzKLaqbwCbEKDHs2gDl3TcQ=;
        b=mJH8mNs3mSfInuaKeg8/apHMOo6n0c/5ddij1DG6793INyJ7r4yxavZMHLYGSdYxEx
         bz1T8L/exv1bN9SviQoo3URk9iHGG3xoup+pR0W7bjK0ll/kYKGPsmwrAw7OrNEz11lN
         Tp6rV+pANiwMt+HZTpxgJP8Q2NDuOc8XvszWIpGifJpvC2U/SXGl6V2UBUiXWF3BdZxz
         NinxI8CsKrmRII6SzxlmyqCTCQo4bQWXuTtVGYy6IDxWMbGoJuTRC4AXGMGhY6J+6O3j
         rsghr0ZMcz3CRaCsTSAKcxBggKHcg+mAJcQxdhzEGOBji8kbc3UFRAS8xNW3iSEvUQ1X
         OhZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=YUtrtiwbKfY9rDzT+0XeYzKLaqbwCbEKDHs2gDl3TcQ=;
        b=JK5XD77Q5V2Xha2h8DsRhS+KdhzKOy1Y96DEMy1zIO91+OcCekjrISzkLTyer+6+R1
         3LjI54Lp4hworuZJDs9SfFCvSpbcRoDu1u67MfGqfdyEvvPu5/J9jyQdRjzNOabWdMdc
         Dk09FeXbZ7y5mG8BEOi05vP28sBP1yI+5o3B1FOzLg8QWUR024gwfZ4vn3V4yU+SqCkI
         jvIrD2kPZuahRNahxIs3Hd8ucn7+1as3w7+PmADUfJmYsPmE3bV+VTy4Sek81+Ct7o0G
         pN/ccdQM/kXNxAMq7nAe0GERY8IjwsB2MtUMp8datTMtrkaiVMuYZEz3wByfXdkVMXI5
         FbIw==
X-Gm-Message-State: AOAM533glRn2CT6tJwF4Gys0d3yS/rVP3gj2yohUB3g693SQ9oiOT9Qa
        ntZh1sC2nE8BK+ZGzfHbwOAF/anBLbQJUWlRxCQ8M/pRyWANT1Rj6eyv/mm20aQC/xwBb50G9bC
        zL1kYz2A/+0ck9i7xVt+GhBt+aNbBsVDYGs9NS+UN9JBE4Df1GNwV4g0QAQ==
X-Google-Smtp-Source: ABdhPJxCNOMoQnphKdlx7pHLYLIuQ/O/Y7g8lZcH016VxxOTUsfTOU+yTOv5PCx7lDDv22rZ6nThdKOjeCE=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:204:225f:7216:6111:7f1c])
 (user=pgonda job=sendgmr) by 2002:a62:7bd5:0:b0:44c:72f5:5da4 with SMTP id
 w204-20020a627bd5000000b0044c72f55da4mr6904551pfc.48.1633443253802; Tue, 05
 Oct 2021 07:14:13 -0700 (PDT)
Date:   Tue,  5 Oct 2021 07:13:57 -0700
In-Reply-To: <20211005141357.2393627-1-pgonda@google.com>
Message-Id: <20211005141357.2393627-5-pgonda@google.com>
Mime-Version: 1.0
References: <20211005141357.2393627-1-pgonda@google.com>
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
Subject: [PATCH 4/4 V9] selftest: KVM: Add intra host migration tests
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Orr <marcorr@google.com>,
        David Rientjes <rientjes@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org
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
Cc: Joerg Roedel <joro@8bytes.org>
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

