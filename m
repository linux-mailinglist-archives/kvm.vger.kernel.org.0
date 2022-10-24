Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C423560A225
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 13:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbiJXLjb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 07:39:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231153AbiJXLiq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 07:38:46 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B47B6C751;
        Mon, 24 Oct 2022 04:38:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666611486; x=1698147486;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qLJRZLD+f1gvO5Oh214ugWG3QwbmcspGXqq4LSrfK9k=;
  b=ge07G5Y993pPQWLKVK7sWIbDJ7y4EqEa0TTQ2C9DJ+vzouz7yRSK6Z1B
   SpVvLUmUu3YVMto16lye7T6iIUSAiGsQLtBbe2BhYz9UaU1xWT++XVmIi
   RaN/kskWJr8KpedrxG7TSoOs16Dg9HTbv348rKT12Lzlj0u6HQBbOV9Fl
   9RojqJ9praESpA81Z+fjFUIwWUwr7JY0n66NqekWs/L+6BQn0AH0C3bNa
   Y4sWFBRLBaU7F6Z+Tna3ddhFsdfpNJMgFh4vz6/M6MFGqoXPF9NE51QDv
   CgQ8azQFK4CtfJ7tYjp9/YBdqX4uY0nbY2NGofyJSwAl5DRc0MOhlu1m1
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10509"; a="369462488"
X-IronPort-AV: E=Sophos;i="5.95,209,1661842800"; 
   d="scan'208";a="369462488"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2022 04:35:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10509"; a="773785071"
X-IronPort-AV: E=Sophos;i="5.95,209,1661842800"; 
   d="scan'208";a="773785071"
Received: from tdx-lm.sh.intel.com ([10.239.53.27])
  by fmsmga001.fm.intel.com with ESMTP; 24 Oct 2022 04:35:27 -0700
From:   Wei Wang <wei.w.wang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     dmatlack@google.com, vipinsh@google.com, ajones@ventanamicro.com,
        eric.auger@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH v1 16/18] KVM: selftest/arch_timer: vcpu related code consolidation
Date:   Mon, 24 Oct 2022 19:34:43 +0800
Message-Id: <20221024113445.1022147-17-wei.w.wang@intel.com>
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

Remove the globally defined vcpu and pthread arrays, and reuse the one
from kvm_vm and kvm_vcpu. Also use the helper functions to create vcpu
threads with name.

Signed-off-by: Wei Wang <wei.w.wang@intel.com>
---
 .../selftests/kvm/aarch64/arch_timer.c        | 42 +++++++------------
 1 file changed, 16 insertions(+), 26 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer.c b/tools/testing/selftests/kvm/aarch64/arch_timer.c
index 574eb73f0e90..7c1057e8fca7 100644
--- a/tools/testing/selftests/kvm/aarch64/arch_timer.c
+++ b/tools/testing/selftests/kvm/aarch64/arch_timer.c
@@ -23,7 +23,6 @@
 #define _GNU_SOURCE
 
 #include <stdlib.h>
-#include <pthread.h>
 #include <linux/kvm.h>
 #include <linux/sizes.h>
 #include <linux/bitmap.h>
@@ -76,8 +75,6 @@ struct test_vcpu_shared_data {
 	uint64_t xcnt;
 };
 
-static struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
-static pthread_t pt_vcpu_run[KVM_MAX_VCPUS];
 static struct test_vcpu_shared_data vcpu_shared_data[KVM_MAX_VCPUS];
 
 static int vtimer_irq, ptimer_irq;
@@ -212,7 +209,8 @@ static void guest_code(void)
 
 static void *test_vcpu_run(void *arg)
 {
-	unsigned int vcpu_idx = (unsigned long)arg;
+	struct kvm_vcpu *vcpu = (struct kvm_vcpu *)arg;
+	unsigned int vcpu_idx = vcpu->id;
 	struct ucall uc;
 	struct kvm_vcpu *vcpu = vcpus[vcpu_idx];
 	struct kvm_vm *vm = vcpu->vm;
@@ -263,18 +261,19 @@ static uint32_t test_get_pcpu(void)
 	return pcpu;
 }
 
-static int test_migrate_vcpu(unsigned int vcpu_idx)
+static int test_migrate_vcpu(struct kvm_vcpu *vcpu)
 {
 	int ret;
 	cpu_set_t cpuset;
 	uint32_t new_pcpu = test_get_pcpu();
+	uint32_t vcpu_idx = vcpu->id;
 
 	CPU_ZERO(&cpuset);
 	CPU_SET(new_pcpu, &cpuset);
 
 	pr_debug("Migrating vCPU: %u to pCPU: %u\n", vcpu_idx, new_pcpu);
 
-	ret = pthread_setaffinity_np(pt_vcpu_run[vcpu_idx],
+	ret = pthread_setaffinity_np(vcpu->thread,
 				     sizeof(cpuset), &cpuset);
 
 	/* Allow the error where the vCPU thread is already finished */
@@ -287,6 +286,7 @@ static int test_migrate_vcpu(unsigned int vcpu_idx)
 
 static void *test_vcpu_migration(void *arg)
 {
+	struct kvm_vm *vm = (struct kvm_vm *)arg;
 	unsigned int i, n_done;
 	bool vcpu_done;
 
@@ -303,7 +303,7 @@ static void *test_vcpu_migration(void *arg)
 				continue;
 			}
 
-			test_migrate_vcpu(i);
+			test_migrate_vcpu(vm->vcpus[i]);
 		}
 	} while (test_args.nr_vcpus != n_done);
 
@@ -314,31 +314,21 @@ static void test_run(struct kvm_vm *vm)
 {
 	pthread_t pt_vcpu_migration;
 	unsigned int i;
-	int ret;
 
 	pthread_mutex_init(&vcpu_done_map_lock, NULL);
 	vcpu_done_map = bitmap_zalloc(test_args.nr_vcpus);
 	TEST_ASSERT(vcpu_done_map, "Failed to allocate vcpu done bitmap\n");
 
-	for (i = 0; i < (unsigned long)test_args.nr_vcpus; i++) {
-		ret = pthread_create(&pt_vcpu_run[i], NULL, test_vcpu_run,
-				     (void *)(unsigned long)i);
-		TEST_ASSERT(!ret, "Failed to create vCPU-%d pthread\n", i);
-	}
+	vm_vcpu_threads_create(vm, test_vcpu_run, 0);
 
 	/* Spawn a thread to control the vCPU migrations */
 	if (test_args.migration_freq_ms) {
 		srand(time(NULL));
-
-		ret = pthread_create(&pt_vcpu_migration, NULL,
-					test_vcpu_migration, NULL);
-		TEST_ASSERT(!ret, "Failed to create the migration pthread\n");
+		pthread_create_with_name(&pt_vcpu_migration,
+				 test_vcpu_migration, vm, "control-thread");
 	}
 
-
-	for (i = 0; i < test_args.nr_vcpus; i++)
-		pthread_join(pt_vcpu_run[i], NULL);
-
+	vm_vcpu_threads_join(vm);
 	if (test_args.migration_freq_ms)
 		pthread_join(pt_vcpu_migration, NULL);
 
@@ -364,16 +354,16 @@ static int gic_fd;
 static struct kvm_vm *test_vm_create(void)
 {
 	struct kvm_vm *vm;
-	unsigned int i;
-	int nr_vcpus = test_args.nr_vcpus;
+	struct kvm_vcpu *vcpu;
+	int i, nr_vcpus = test_args.nr_vcpus;
 
-	vm = vm_create_with_vcpus(nr_vcpus, guest_code, vcpus);
+	vm = vm_create_with_vcpus(nr_vcpus, guest_code, NULL);
 
 	vm_init_descriptor_tables(vm);
 	vm_install_exception_handler(vm, VECTOR_IRQ_CURRENT, guest_irq_handler);
 
-	for (i = 0; i < nr_vcpus; i++)
-		vcpu_init_descriptor_tables(vcpus[i]);
+	vm_iterate_over_cpus(vm, vcpu, i)
+		vcpu_init_descriptor_tables(vcpu);
 
 	ucall_init(vm, NULL);
 	test_init_timer_irq(vm);
-- 
2.27.0

