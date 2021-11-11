Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B34FD44D988
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 16:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234114AbhKKPx1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 10:53:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50559 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234181AbhKKPxG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Nov 2021 10:53:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636645816;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8mcY7YG+sTXHYGQAr55bmYVKvhVX6Ztjpy+U8tEn+BM=;
        b=TVdRIsvhJ64gp8u2DVD7jCXNWA6EwtRyMbmEU7PN/dqoQ04t/QnzafnO2DepGIV0zcyUc0
        WEhOq8yMO3FUmQrxKw5DFNeWbL7VXo/BK3dZ5zf9fACCwsrqj7ztRywswF4NaEGJwzwZbw
        NjJAIjG/kmvqqVQK4vycA60xAX651aU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-522-0LdVwneJMmWNebJg387hyg-1; Thu, 11 Nov 2021 10:50:12 -0500
X-MC-Unique: 0LdVwneJMmWNebJg387hyg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9C5BE100DFC7;
        Thu, 11 Nov 2021 15:50:10 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 035F75DEFB;
        Thu, 11 Nov 2021 15:50:09 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pgonda@google.com, seanjc@google.com,
        Marc Orr <marcorr@google.com>,
        David Rientjes <rientjes@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH 7/7] selftest: KVM: Add intra host migration tests
Date:   Thu, 11 Nov 2021 10:49:30 -0500
Message-Id: <20211111154930.3603189-8-pbonzini@redhat.com>
In-Reply-To: <20211111154930.3603189-1-pbonzini@redhat.com>
References: <20211111154930.3603189-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Peter Gonda <pgonda@google.com>

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
Message-Id: <20211021174303.385706-6-pgonda@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 tools/testing/selftests/kvm/Makefile          |   3 +-
 .../selftests/kvm/x86_64/sev_migrate_tests.c  | 203 ++++++++++++++++++
 2 files changed, 205 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index c23e89dea0b6..c4e34717826a 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -73,7 +73,8 @@ TEST_GEN_PROGS_x86_64 += x86_64/tsc_msrs_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_pmu_msrs_test
 TEST_GEN_PROGS_x86_64 += x86_64/xen_shinfo_test
 TEST_GEN_PROGS_x86_64 += x86_64/xen_vmcall_test
-TEST_GEN_PROGS_x86_64 += access_tracking_perf_test
+TEST_GEN_PROGS_x86_64 += x86_64/vmx_pi_mmio_test
+TEST_GEN_PROGS_x86_64 += x86_64/sev_migrate_tests
 TEST_GEN_PROGS_x86_64 += demand_paging_test
 TEST_GEN_PROGS_x86_64 += dirty_log_test
 TEST_GEN_PROGS_x86_64 += dirty_log_perf_test
diff --git a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
new file mode 100644
index 000000000000..53c58e8be580
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
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
+		.cap = KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM,
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
+	struct locking_thread_input *input = (struct locking_thread_input *)arg;
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
2.27.0

