Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A997E60A1F7
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 13:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbiJXLhx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 07:37:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbiJXLhb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 07:37:31 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 109E352FE8;
        Mon, 24 Oct 2022 04:37:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666611449; x=1698147449;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Da+ApiJuZCWPMMb4BYSHDLZOCQ5nv4rti0CmXFAl03s=;
  b=Zl90wj1bhcRXKhyN9mFMb2nthcI5KrWbuHMnAw5kYfHqm692UOsExDvI
   C/Qch7iy3XME5sFuHK23k+PBITr8Adu1tEfDQSg1ACrVC+tufbCHDzyXe
   +BcFVm2vuu3M5VWsX/3M0N4R6t8X/EqSZ43q3PXfApe/zxiQacd2mu9fS
   34WGXFh/MMp/op6EWewn+qfhQJEz5yUU8KcObpgb6OD0DeAFVpr57+vtM
   b7KKrdrfiW4aGvzBNhlKUOGmi0hho6CvljRGCyD7ePEvN2XCI3JzKk+m2
   ++rPEalz/hrHud74Mvomsfx+2ysMcBFu/4t97AaYf9Z1TgUDJ7HYEge8N
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10509"; a="369462419"
X-IronPort-AV: E=Sophos;i="5.95,209,1661842800"; 
   d="scan'208";a="369462419"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2022 04:35:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10509"; a="773784810"
X-IronPort-AV: E=Sophos;i="5.95,209,1661842800"; 
   d="scan'208";a="773784810"
Received: from tdx-lm.sh.intel.com ([10.239.53.27])
  by fmsmga001.fm.intel.com with ESMTP; 24 Oct 2022 04:35:05 -0700
From:   Wei Wang <wei.w.wang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     dmatlack@google.com, vipinsh@google.com, ajones@ventanamicro.com,
        eric.auger@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH v1 07/18] KVM: selftests/max_guest_memory_test: vcpu related code consolidation
Date:   Mon, 24 Oct 2022 19:34:34 +0800
Message-Id: <20221024113445.1022147-8-wei.w.wang@intel.com>
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

Remove the unnecessary allocation of the vcpu and threads array,
and use the helper functinos to create and join the vcpu threads.

As the vcpu thread's start routine (i.e. vcpu_worker) uses kvm_vcpu as the
interface, change vcpu_info to be the vcpu thread's private data to have
it passed to the thread's start routine.

Signed-off-by: Wei Wang <wei.w.wang@intel.com>
---
 .../selftests/kvm/max_guest_memory_test.c     | 53 +++++++------------
 1 file changed, 20 insertions(+), 33 deletions(-)

diff --git a/tools/testing/selftests/kvm/max_guest_memory_test.c b/tools/testing/selftests/kvm/max_guest_memory_test.c
index 9a6e4f3ad6b5..2d9c83e36e65 100644
--- a/tools/testing/selftests/kvm/max_guest_memory_test.c
+++ b/tools/testing/selftests/kvm/max_guest_memory_test.c
@@ -3,7 +3,6 @@
 
 #include <stdio.h>
 #include <stdlib.h>
-#include <pthread.h>
 #include <semaphore.h>
 #include <sys/types.h>
 #include <signal.h>
@@ -27,8 +26,7 @@ static void guest_code(uint64_t start_gpa, uint64_t end_gpa, uint64_t stride)
 	GUEST_DONE();
 }
 
-struct vcpu_info {
-	struct kvm_vcpu *vcpu;
+struct vcpu_thread_data {
 	uint64_t start_gpa;
 	uint64_t end_gpa;
 };
@@ -59,13 +57,15 @@ static void run_vcpu(struct kvm_vcpu *vcpu)
 
 static void *vcpu_worker(void *data)
 {
-	struct vcpu_info *info = data;
-	struct kvm_vcpu *vcpu = info->vcpu;
+	struct kvm_vcpu *vcpu = (struct kvm_vcpu *)data;
+	struct vcpu_thread_data *thread_data =
+		(struct vcpu_thread_data *)vcpu->private_data;
 	struct kvm_vm *vm = vcpu->vm;
 	struct kvm_sregs sregs;
 	struct kvm_regs regs;
 
-	vcpu_args_set(vcpu, 3, info->start_gpa, info->end_gpa, vm->page_size);
+	vcpu_args_set(vcpu, 3, thread_data->start_gpa,
+		      thread_data->end_gpa, vm->page_size);
 
 	/* Snapshot regs before the first run. */
 	vcpu_regs_get(vcpu, &regs);
@@ -88,31 +88,24 @@ static void *vcpu_worker(void *data)
 	return NULL;
 }
 
-static pthread_t *spawn_workers(struct kvm_vm *vm, struct kvm_vcpu **vcpus,
-				uint64_t start_gpa, uint64_t end_gpa)
+static void vm_vcpu_threads_data_init(struct kvm_vm *vm,
+				     uint64_t start_gpa, uint64_t end_gpa)
 {
-	struct vcpu_info *info;
+	struct kvm_vcpu *vcpu;
+	struct vcpu_thread_data *thread_data;
 	uint64_t gpa, nr_bytes;
-	pthread_t *threads;
 	int i;
 
-	threads = malloc(nr_vcpus * sizeof(*threads));
-	TEST_ASSERT(threads, "Failed to allocate vCPU threads");
-
-	info = malloc(nr_vcpus * sizeof(*info));
-	TEST_ASSERT(info, "Failed to allocate vCPU gpa ranges");
-
 	nr_bytes = ((end_gpa - start_gpa) / nr_vcpus) &
 			~((uint64_t)vm->page_size - 1);
 	TEST_ASSERT(nr_bytes, "C'mon, no way you have %d CPUs", nr_vcpus);
 
-	for (i = 0, gpa = start_gpa; i < nr_vcpus; i++, gpa += nr_bytes) {
-		info[i].vcpu = vcpus[i];
-		info[i].start_gpa = gpa;
-		info[i].end_gpa = gpa + nr_bytes;
-		pthread_create(&threads[i], NULL, vcpu_worker, &info[i]);
+	vm_iterate_over_vcpus(vm, vcpu, i) {
+		thread_data = (struct vcpu_thread_data *)vcpu->private_data;
+		gpa = start_gpa + i * nr_bytes;
+		thread_data->start_gpa =  gpa;
+		thread_data->end_gpa = gpa + nr_bytes;
 	}
-	return threads;
 }
 
 static void rendezvous_with_vcpus(struct timespec *time, const char *name)
@@ -170,8 +163,6 @@ int main(int argc, char *argv[])
 	uint64_t max_gpa, gpa, slot_size, max_mem, i;
 	int max_slots, slot, opt, fd;
 	bool hugepages = false;
-	struct kvm_vcpu **vcpus;
-	pthread_t *threads;
 	struct kvm_vm *vm;
 	void *mem;
 
@@ -214,10 +205,7 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	vcpus = malloc(nr_vcpus * sizeof(*vcpus));
-	TEST_ASSERT(vcpus, "Failed to allocate vCPU array");
-
-	vm = vm_create_with_vcpus(nr_vcpus, guest_code, vcpus);
+	vm = vm_create_with_vcpus(nr_vcpus, guest_code, NULL);
 
 	max_gpa = vm->max_gfn << vm->page_shift;
 	TEST_ASSERT(max_gpa > (4 * slot_size), "MAXPHYADDR <4gb ");
@@ -254,10 +242,10 @@ int main(int argc, char *argv[])
 	}
 
 	atomic_set(&rendezvous, nr_vcpus + 1);
-	threads = spawn_workers(vm, vcpus, start_gpa, gpa);
 
-	free(vcpus);
-	vcpus = NULL;
+	vm_vcpu_threads_create(vm, vcpu_worker,
+			       sizeof(struct vcpu_thread_data));
+	vm_vcpu_threads_data_init(vm, start_gpa, gpa);
 
 	pr_info("Running with %lugb of guest memory and %u vCPUs\n",
 		(gpa - start_gpa) / size_1gb, nr_vcpus);
@@ -287,8 +275,7 @@ int main(int argc, char *argv[])
 	munmap(mem, slot_size / 2);
 
 	/* Sanity check that the vCPUs actually ran. */
-	for (i = 0; i < nr_vcpus; i++)
-		pthread_join(threads[i], NULL);
+	vm_vcpu_threads_join(vm);
 
 	/*
 	 * Deliberately exit without deleting the remaining memslots or closing
-- 
2.27.0

