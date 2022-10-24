Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 019E560A234
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 13:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231130AbiJXLjd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 07:39:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231223AbiJXLij (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 07:38:39 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 056D16B65E;
        Mon, 24 Oct 2022 04:38:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666611491; x=1698147491;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VpBbmMaQb192ltdQ0fPh97UAauMJ1f/HXW0McbVeszM=;
  b=QngsEM0in05SLg3iZlwtTNP3B0no2GqcG+DUdUci2dM67m2jJMOsUdIZ
   KN4omqXcksJ5bJWrCpJ7/+zlNXdP4CJ0E5h52uYH/ReBD4Iwpnfap7Unp
   qW3SGmHb1C+sxMp1OQhZG0ktE1kFPK9NMdR+gDXbt/Zo5/mztgm5regS8
   He3mO4s1b1nSBEh78WYCG7dT6Uvh+RcAPE3Uy7326PzL6Q7CYUqZFs7bU
   4b3oOeHGaPGsmjvPObHvgHONh5oeFB4MY8clHQjwLvmAM2MN9/OvMf3d3
   bY6U78MqIKkhUPDSgQ52rKnAU5p01wAEaH9yjWyF2MIeP60dYOmL5+T24
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10509"; a="369462498"
X-IronPort-AV: E=Sophos;i="5.95,209,1661842800"; 
   d="scan'208";a="369462498"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2022 04:35:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10509"; a="773785079"
X-IronPort-AV: E=Sophos;i="5.95,209,1661842800"; 
   d="scan'208";a="773785079"
Received: from tdx-lm.sh.intel.com ([10.239.53.27])
  by fmsmga001.fm.intel.com with ESMTP; 24 Oct 2022 04:35:30 -0700
From:   Wei Wang <wei.w.wang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     dmatlack@google.com, vipinsh@google.com, ajones@ventanamicro.com,
        eric.auger@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH v1 17/18] KVM: selftests: remove the *vcpu[] input from __vm_create_with_vcpus
Date:   Mon, 24 Oct 2022 19:34:44 +0800
Message-Id: <20221024113445.1022147-18-wei.w.wang@intel.com>
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

kvm_vm has included an array of vcpu pointers (i.e. *vcpu[]) to the
added vcpus, so there is no need for users to supply its own *vcpu[].
Remove the *vcpu[] from __vm_create_with_vcpus and the related callers.

Signed-off-by: Wei Wang <wei.w.wang@intel.com>
---
 tools/testing/selftests/kvm/aarch64/arch_timer.c      | 2 +-
 tools/testing/selftests/kvm/aarch64/vgic_init.c       | 4 ++--
 tools/testing/selftests/kvm/hardware_disable_test.c   | 2 +-
 tools/testing/selftests/kvm/include/kvm_util_base.h   | 7 +++----
 tools/testing/selftests/kvm/kvm_page_table_test.c     | 2 +-
 tools/testing/selftests/kvm/lib/kvm_util.c            | 4 ++--
 tools/testing/selftests/kvm/lib/perf_test_util.c      | 2 +-
 tools/testing/selftests/kvm/max_guest_memory_test.c   | 2 +-
 tools/testing/selftests/kvm/steal_time.c              | 2 +-
 tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c | 2 +-
 10 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer.c b/tools/testing/selftests/kvm/aarch64/arch_timer.c
index 7c1057e8fca7..1373e41ef365 100644
--- a/tools/testing/selftests/kvm/aarch64/arch_timer.c
+++ b/tools/testing/selftests/kvm/aarch64/arch_timer.c
@@ -357,7 +357,7 @@ static struct kvm_vm *test_vm_create(void)
 	struct kvm_vcpu *vcpu;
 	int i, nr_vcpus = test_args.nr_vcpus;
 
-	vm = vm_create_with_vcpus(nr_vcpus, guest_code, NULL);
+	vm = vm_create_with_vcpus(nr_vcpus, guest_code);
 
 	vm_init_descriptor_tables(vm);
 	vm_install_exception_handler(vm, VECTOR_IRQ_CURRENT, guest_irq_handler);
diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
index e24130a49581..b5defd94dd2e 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
@@ -79,7 +79,7 @@ static struct vm_gic vm_gic_create_with_vcpus(uint32_t gic_dev_type,
 	struct vm_gic v;
 
 	v.gic_dev_type = gic_dev_type;
-	v.vm = vm_create_with_vcpus(nr_vcpus, guest_code, NULL);
+	v.vm = vm_create_with_vcpus(nr_vcpus, guest_code);
 	v.gic_fd = kvm_create_device(v.vm, gic_dev_type);
 
 	return v;
@@ -641,7 +641,7 @@ int test_kvm_device(uint32_t gic_dev_type)
 	uint32_t other;
 	int ret;
 
-	v.vm = vm_create_with_vcpus(NR_VCPUS, guest_code, NULL);
+	v.vm = vm_create_with_vcpus(NR_VCPUS, guest_code);
 
 	/* try to create a non existing KVM device */
 	ret = __kvm_test_create_device(v.vm, 0);
diff --git a/tools/testing/selftests/kvm/hardware_disable_test.c b/tools/testing/selftests/kvm/hardware_disable_test.c
index c212d34a6714..f16e07485380 100644
--- a/tools/testing/selftests/kvm/hardware_disable_test.c
+++ b/tools/testing/selftests/kvm/hardware_disable_test.c
@@ -76,7 +76,7 @@ static void run_test(uint32_t run)
 	r = pthread_attr_setaffinity_np(&attr, sizeof(cpu_set_t), &cpu_set);
 	TEST_ASSERT(!r, "%s: failed to set affinity, r = %d", __func__, r);
 
-	vm = vm_create_with_vcpus(VCPU_NUM, guest_code, NULL);
+	vm = vm_create_with_vcpus(VCPU_NUM, guest_code);
 
 	pr_debug("%s: [%d] start vcpus\n", __func__, run);
 	vm_iterate_over_vcpus(vm, vcpu, i) {
diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index d0d6aaec0098..5a5b7210cf7c 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -663,14 +663,13 @@ static inline struct kvm_vm *vm_create(uint32_t nr_runnable_vcpus)
 
 struct kvm_vm *__vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
 				      uint64_t extra_mem_pages,
-				      void *guest_code, struct kvm_vcpu *vcpus[]);
+				      void *guest_code);
 
 static inline struct kvm_vm *vm_create_with_vcpus(uint32_t nr_vcpus,
-						  void *guest_code,
-						  struct kvm_vcpu *vcpus[])
+						  void *guest_code)
 {
 	return __vm_create_with_vcpus(VM_MODE_DEFAULT, nr_vcpus, 0,
-				      guest_code, vcpus);
+				      guest_code);
 }
 
 /*
diff --git a/tools/testing/selftests/kvm/kvm_page_table_test.c b/tools/testing/selftests/kvm/kvm_page_table_test.c
index 4c3df48d80fc..1a9dd189c225 100644
--- a/tools/testing/selftests/kvm/kvm_page_table_test.c
+++ b/tools/testing/selftests/kvm/kvm_page_table_test.c
@@ -253,7 +253,7 @@ static struct kvm_vm *pre_init_before_test(enum vm_guest_mode mode, void *arg)
 	/* Create a VM with enough guest pages */
 	guest_num_pages = test_mem_size / guest_page_size;
 	vm = __vm_create_with_vcpus(mode, nr_vcpus, guest_num_pages,
-				    guest_code, NULL);
+				    guest_code);
 
 	/* Align down GPA of the testing memslot */
 	if (!p->phys_offset)
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index ba3e774087fb..69dad4fa9ca1 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -366,7 +366,7 @@ struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint32_t nr_runnable_vcpus,
  */
 struct kvm_vm *__vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
 				      uint64_t extra_mem_pages,
-				      void *guest_code, struct kvm_vcpu *vcpus[])
+				      void *guest_code)
 {
 	struct kvm_vm *vm;
 	int i;
@@ -386,7 +386,7 @@ struct kvm_vm *__vm_create_with_one_vcpu(struct kvm_vcpu **vcpu,
 	struct kvm_vm *vm;
 
 	vm = __vm_create_with_vcpus(VM_MODE_DEFAULT, 1, extra_mem_pages,
-				    guest_code, NULL);
+				    guest_code);
 
 	*vcpu = vm->vcpus[0];
 	return vm;
diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index 94c0f496c9c1..3103c9f40e76 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -140,7 +140,7 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int nr_vcpus,
 	 * effect as KVM allows aliasing HVAs in meslots.
 	 */
 	vm = __vm_create_with_vcpus(mode, nr_vcpus, slot0_pages + guest_num_pages,
-				    perf_test_guest_code, NULL);
+				    perf_test_guest_code);
 
 	pta->vm = vm;
 
diff --git a/tools/testing/selftests/kvm/max_guest_memory_test.c b/tools/testing/selftests/kvm/max_guest_memory_test.c
index 2d9c83e36e65..7480730caeeb 100644
--- a/tools/testing/selftests/kvm/max_guest_memory_test.c
+++ b/tools/testing/selftests/kvm/max_guest_memory_test.c
@@ -205,7 +205,7 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	vm = vm_create_with_vcpus(nr_vcpus, guest_code, NULL);
+	vm = vm_create_with_vcpus(nr_vcpus, guest_code);
 
 	max_gpa = vm->max_gfn << vm->page_shift;
 	TEST_ASSERT(max_gpa > (4 * slot_size), "MAXPHYADDR <4gb ");
diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
index 857ed2c073fc..530b08e64846 100644
--- a/tools/testing/selftests/kvm/steal_time.c
+++ b/tools/testing/selftests/kvm/steal_time.c
@@ -261,7 +261,7 @@ int main(int ac, char **av)
 	pthread_setaffinity_np(pthread_self(), sizeof(cpu_set_t), &cpuset);
 
 	/* Create a VM and an identity mapped memslot for the steal time structure */
-	vm = vm_create_with_vcpus(NR_VCPUS, guest_code, NULL);
+	vm = vm_create_with_vcpus(NR_VCPUS, guest_code);
 	vcpus = vm->vcpus;
 	gpages = vm_calc_num_guest_pages(VM_MODE_DEFAULT, STEAL_TIME_SIZE * NR_VCPUS);
 	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, ST_GPA_BASE, 1, gpages, 0);
diff --git a/tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c b/tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c
index 34a8beef42b6..3c050ffe5edb 100644
--- a/tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c
+++ b/tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c
@@ -91,7 +91,7 @@ int main(int argc, char *argv[])
 {
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_VM_TSC_CONTROL));
 
-	vm = vm_create_with_vcpus(NR_TEST_VCPUS, guest_code, NULL);
+	vm = vm_create_with_vcpus(NR_TEST_VCPUS, guest_code);
 	vm_ioctl(vm, KVM_SET_TSC_KHZ, (void *) TEST_TSC_KHZ);
 
 	pthread_spin_init(&create_lock, PTHREAD_PROCESS_PRIVATE);
-- 
2.27.0

