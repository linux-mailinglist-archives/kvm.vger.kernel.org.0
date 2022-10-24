Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84EA760A1FC
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 13:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230404AbiJXLh6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 07:37:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbiJXLhi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 07:37:38 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1D051C418;
        Mon, 24 Oct 2022 04:37:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666611444; x=1698147444;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KALREN8qvMPmTQ0EIZa6eHxaQ3wxIRqxncgPOySP9uo=;
  b=WQybs17xyJ7CJV8sX8JkR9kLnR5JnkC3mINNRtiXR+AoBbPZkW5gWGdJ
   lmV0lyHwc2pyLOGLYOGgHe2P5F+6egLEXNcP1zuxUiGiphOnStyKDJKUr
   DJgEY5mP+nnG9Xlbs2BdXefthTtAdsP+3N+4cgbRKVyH+3m4LaO8K9xT4
   Pxt27XUAWXCtXUw9lDxS7ATZiwAZGEg8Phax2RoIKFxhjEmUHsacLsMGH
   ChEma2wuWJRtHDY1VF374ju79H3lwg37v7tJsdXLJqmU29eq/WEE7a5Us
   dE+UAs+T8ydCE0/MQL4OckfvY2YFItKY8zFs4Ql9dqMu21KWy/IkBk5vA
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10509"; a="371612780"
X-IronPort-AV: E=Sophos;i="5.95,209,1661842800"; 
   d="scan'208";a="371612780"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2022 04:34:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10509"; a="773784645"
X-IronPort-AV: E=Sophos;i="5.95,209,1661842800"; 
   d="scan'208";a="773784645"
Received: from tdx-lm.sh.intel.com ([10.239.53.27])
  by fmsmga001.fm.intel.com with ESMTP; 24 Oct 2022 04:34:55 -0700
From:   Wei Wang <wei.w.wang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     dmatlack@google.com, vipinsh@google.com, ajones@ventanamicro.com,
        eric.auger@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH v1 03/18] KVM: selftests/kvm_util: helper functions for vcpus and threads
Date:   Mon, 24 Oct 2022 19:34:30 +0800
Message-Id: <20221024113445.1022147-4-wei.w.wang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20221024113445.1022147-1-wei.w.wang@intel.com>
References: <20221024113445.1022147-1-wei.w.wang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a vcpu thread field to the kvm_vcpu struct, so that each user
doesn't need to define an array of such threads on their own. The
private_data pointer is added and optionally used to hold user
specific data, and type casting to the user's data type will be
performed in the user vcpu thread's start_routine.

A couple of the helper functions are added to support vcpu related
operations:

pthread_create_with_name is provided to create general threads with
user specified name.

vcpu_thread_create is provided to create a vcpu thread with name in
"vcpu##id" format, vm_vcpu_threads_create is provided to create vcpu
threads for the vcpus that have been created for a vm. The thread
naming facilitates debugging, performance tuning, runtime pining etc.
An example is shown below reported from "top". With naming the vcpu
threads, the per-vcpu info becomes more noticeable:
PID  USER PR  NI VIRT    RES  SHR  S  %CPU  %MEM TIME+   COMMAND
4464 root 20  0  4248684 4.0g 1628 R  99.9  26.2 0:50.97 dirty_log_perf_
4467 root 20  0  4248684 4.0g 1628 R  99.9  26.2 0:50.93 vcpu0
4469 root 20  0  4248684 4.0g 1628 R  99.9  26.2 0:50.93 vcpu2
4470 root 20  0  4248684 4.0g 1628 R  99.9  26.2 0:50.94 vcpu3
4468 root 20  0  4248684 4.0g 1628 R  99.7  26.2 0:50.93 vcpu1

vm_vcpu_threads_join is provided to join all the vcpu threads.

vm_vcpu_threads_private_data_alloc is provided to allocate memory used
for user specific private data to each vcpu that have been created to
the vm.

Signed-off-by: Wei Wang <wei.w.wang@intel.com>
---
 .../testing/selftests/kvm/include/kvm_util.h  |  20 ++
 .../selftests/kvm/include/kvm_util_base.h     |   2 +
 tools/testing/selftests/kvm/lib/kvm_util.c    | 172 ++++++++++++++++++
 3 files changed, 194 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 5d5c8968fb06..036ed05e72e6 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -6,6 +6,7 @@
  */
 #ifndef SELFTEST_KVM_UTIL_H
 #define SELFTEST_KVM_UTIL_H
+#include <pthread.h>
 
 #include "kvm_util_base.h"
 #include "ucall_common.h"
@@ -14,4 +15,23 @@
 	for (i = 0, vcpu = vm->vcpus[0];				\
 		vcpu && i < KVM_MAX_VCPUS; vcpu = vm->vcpus[++i])
 
+void __pthread_create_with_name(pthread_t *thread, const pthread_attr_t *attr,
+			void *(*start_routine)(void *), void *arg, char *name);
+
+void pthread_create_with_name(pthread_t *thread,
+			void *(*start_routine)(void *), void *arg, char *name);
+
+void __vcpu_thread_create(struct kvm_vcpu *vcpu, const pthread_attr_t *attr,
+		   void *(*start_routine)(void *), uint32_t private_data_size);
+
+void vcpu_thread_create(struct kvm_vcpu *vcpu, void *(*start_routine)(void *),
+			uint32_t private_data_size);
+
+void vm_vcpu_threads_create(struct kvm_vm *vm,
+		void *(*start_routine)(void *), uint32_t private_data_size);
+
+void vm_vcpu_threads_join(struct kvm_vm *vm);
+
+void vm_vcpu_threads_private_data_alloc(struct kvm_vm *vm, uint32_t data_size);
+
 #endif /* SELFTEST_KVM_UTIL_H */
diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index c90a9609b853..d0d6aaec0098 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -55,6 +55,8 @@ struct kvm_vcpu {
 	struct kvm_dirty_gfn *dirty_gfns;
 	uint32_t fetch_index;
 	uint32_t dirty_gfns_count;
+	pthread_t thread;
+	void *private_data;
 };
 
 struct userspace_mem_regions {
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 1f69f5ca8356..ba3e774087fb 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2006,3 +2006,175 @@ void __vm_get_stat(struct kvm_vm *vm, const char *stat_name, uint64_t *data,
 		break;
 	}
 }
+
+/*
+ * Create a named thread with user's attribute
+ *
+ * Input Args:
+ *   attr - the attribute of the thread to create
+ *   start_routine - the routine to run in the thread context
+ *   arg - the argument passed to start_routine
+ *   name - the name of the thread
+ *
+ * Output Args:
+ *   thread - the thread to be created
+ *
+ * Create a thread with a user specified name.
+ */
+void __pthread_create_with_name(pthread_t *thread, const pthread_attr_t *attr,
+			void *(*start_routine)(void *), void *arg, char *name)
+{
+	int r;
+
+	r = pthread_create(thread, NULL, start_routine, arg);
+	TEST_ASSERT(!r, "thread(%s) creation failed, r = %d", name, r);
+	r = pthread_setname_np(*thread, name);
+	TEST_ASSERT(!r, "thread(%s) setting name failed, r = %d", name, r);
+}
+
+/*
+ * Create a named thread with the default thread attribute
+ *
+ * Input Args:
+ *   start_routine - the routine to run in the thread context
+ *   arg - the argument passed to start_routine
+ *   name - the name of the thread
+ *
+ * Output Args:
+ *   thread - the thread to be created
+ *
+ * Create a thread with a user specified name and default thread attribute.
+ */
+void pthread_create_with_name(pthread_t *thread,
+			void *(*start_routine)(void *), void *arg, char *name)
+{
+	__pthread_create_with_name(thread, NULL, start_routine, arg, name);
+}
+
+/*
+ * Create a vcpu thread with user's attribute
+ *
+ * Input Args:
+ *   vcpu - the vcpu for which the thread is created
+ *   attr - the attribute of the vcpu thread
+ *   start_routine - the routine to run in the thread context
+ *   private_data_size - the size of the user's per-vcpu private_data
+ *
+ * Output Args:
+ *   None
+ *
+ * Create a vcpu thread with user provided attribute and the name in
+ * "vcpu-##id" format.
+ */
+void __vcpu_thread_create(struct kvm_vcpu *vcpu, const pthread_attr_t *attr,
+		   void *(*start_routine)(void *), uint32_t private_data_size)
+{
+	char vcpu_name[16];
+
+	if (private_data_size) {
+		vcpu->private_data = calloc(1, private_data_size);
+		TEST_ASSERT(vcpu->private_data, "%s: failed", __func__);
+	}
+
+	sprintf(vcpu_name, "vcpu-%d", vcpu->id);
+	__pthread_create_with_name(&vcpu->thread, attr,
+				   start_routine, (void *)vcpu, vcpu_name);
+}
+
+/*
+ * Create a vcpu thread with the default thread attribute
+ *
+ * Input Args:
+ *   vcpu - the vcpu for which the thread is created
+ *   start_routine - the routine to run in the thread context
+ *   private_data_size - the size of the user's per-vcpu private_data
+ *
+ * Output Args:
+ *   None
+ *
+ * Create a vcpu thread with the default thread attribute and the name in
+ * "vcpu-##id" format, and allocate memory to be used as the vcpu thread's
+ * private data if private_data_size isn't 0.
+ */
+void vcpu_thread_create(struct kvm_vcpu *vcpu, void *(*start_routine)(void *),
+			uint32_t private_data_size)
+{
+	__vcpu_thread_create(vcpu, NULL, start_routine, private_data_size);
+}
+
+/*
+ * Create vcpu threads for all the vcpus that have been created for a VM
+ *
+ * Input Args:
+ *   vm - the VM for which the vcpu threads are created
+ *   start_routine - the routine to run in the thread context
+ *   private_data_size - the size of the user's per-vcpu private_data
+ *
+ * Output Args:
+ *   None
+ *
+ * Create vcpu threads for all the vcpus that have been created for the VM,
+ * and the thread name in "vcpu-##id" format. Allocate memory to each vcpu
+ * thread to be used for its private data if private_data_size isn't 0.
+ */
+void vm_vcpu_threads_create(struct kvm_vm *vm,
+		void *(*start_routine)(void *), uint32_t private_data_size)
+{
+	struct kvm_vcpu *vcpu;
+	uint32_t i;
+
+	vm_iterate_over_vcpus(vm, vcpu, i)
+		vcpu_thread_create(vcpu, start_routine, private_data_size);
+
+}
+
+/*
+ * Join the VM's vcpu threads
+ *
+ * Input Args:
+ *   vm - the VM for which its vcpu threads should join
+ *
+ * Output Args:
+ *   None
+ *
+ * Iterate over all the vcpus and join the threads.
+ */
+void vm_vcpu_threads_join(struct kvm_vm *vm)
+{
+	struct kvm_vcpu *vcpu;
+	void *one_failure;
+	unsigned long failures = 0;
+	int r, i;
+
+	vm_iterate_over_vcpus(vm, vcpu, i) {
+		r = pthread_join(vcpu->thread, &one_failure);
+		TEST_ASSERT(r == 0, "failed to join vcpu %d thread", i);
+		failures += (unsigned long)one_failure;
+	}
+
+	TEST_ASSERT(!failures, "%s: failed", __func__);
+}
+
+/*
+ * Allocate memory used for private data of the vm's vcpus
+ *
+ * Input Args:
+ *   vm - the VM for which its vcpus will be assigned the allocated memory
+ *   data_size - the size of the memory to allocate
+ *
+ * Output Args:
+ *   None
+ *
+ * Allocate memory to be used for private data of each vcpu that has been
+ * created for vm.
+ */
+void vm_vcpu_threads_private_data_alloc(struct kvm_vm *vm, uint32_t data_size)
+{
+	struct kvm_vcpu *vcpu;
+	int i;
+
+	vm_iterate_over_vcpus(vm, vcpu, i) {
+		vcpu->private_data = calloc(1, data_size);
+		TEST_ASSERT(vcpu->private_data, "%s: failed", __func__);
+	}
+}
-- 
2.27.0

