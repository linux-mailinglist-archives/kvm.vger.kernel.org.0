Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA7360A20B
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 13:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbiJXLif (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 07:38:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230490AbiJXLhq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 07:37:46 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B93020355;
        Mon, 24 Oct 2022 04:37:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666611455; x=1698147455;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KJBfPBUBTZiaXIiWbe2G6kNdjfIEI/B2n2ehEAeUbhI=;
  b=MZl9zgorN8+46itPUOm8HIkfAbSErY3MWfjzKCOLdET+bm6L4W6jXIIf
   O+mj7pa008+zXjct8s0jKFk5Gm3lvHD0nyGWwRwj8/OFgMX5diZs1zGHl
   mdZzxCusT5bxWSO1xjAztYAx95dkwM83Ti5R//XkyjyatiUHyeayWvPz5
   tdOQc0OJ9gK3vXnsIE7dpSYbpVzzu0/IhFZbyWNI+xq65eUSSPqa1iesy
   N0CczhYKL7HbzdTUI4K05dbQZwKuY1Xn3X4D5YkPkrZkEhpMwNof3s2vh
   aOeRcH1vVPry/v3l3kqSSKNtgmqqfTLpYSfVXEe5nRyPG50XYjP8wU5Do
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10509"; a="369462443"
X-IronPort-AV: E=Sophos;i="5.95,209,1661842800"; 
   d="scan'208";a="369462443"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2022 04:35:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10509"; a="773784960"
X-IronPort-AV: E=Sophos;i="5.95,209,1661842800"; 
   d="scan'208";a="773784960"
Received: from tdx-lm.sh.intel.com ([10.239.53.27])
  by fmsmga001.fm.intel.com with ESMTP; 24 Oct 2022 04:35:12 -0700
From:   Wei Wang <wei.w.wang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     dmatlack@google.com, vipinsh@google.com, ajones@ventanamicro.com,
        eric.auger@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH v1 10/18] KVM: selftests/tsc_scaling_sync: vcpu related code consolidation
Date:   Mon, 24 Oct 2022 19:34:37 +0800
Message-Id: <20221024113445.1022147-11-wei.w.wang@intel.com>
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

Remove the unnecessary definition of the vcpu_threads[] array, as
it has beend included in the kvm_vcpu struct. Use the helper functions
to create and join the vcpu threads.

Signed-off-by: Wei Wang <wei.w.wang@intel.com>
---
 .../selftests/kvm/x86_64/tsc_scaling_sync.c   | 25 ++++---------------
 1 file changed, 5 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c b/tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c
index 47139aab7408..34a8beef42b6 100644
--- a/tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c
+++ b/tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c
@@ -15,7 +15,6 @@
 #include <time.h>
 #include <sched.h>
 #include <signal.h>
-#include <pthread.h>
 
 #define NR_TEST_VCPUS 20
 
@@ -44,18 +43,15 @@ static void guest_code(void)
 }
 
 
-static void *run_vcpu(void *_cpu_nr)
+static void *run_vcpu(void *data)
 {
-	unsigned long vcpu_id = (unsigned long)_cpu_nr;
+	struct kvm_vcpu *vcpu = (struct kvm_vcpu *)data;
 	unsigned long failures = 0;
 	static bool first_cpu_done;
-	struct kvm_vcpu *vcpu;
 
 	/* The kernel is fine, but vm_vcpu_add() needs locking */
 	pthread_spin_lock(&create_lock);
 
-	vcpu = vm_vcpu_add(vm, vcpu_id, guest_code);
-
 	if (!first_cpu_done) {
 		first_cpu_done = true;
 		vcpu_set_msr(vcpu, MSR_IA32_TSC, TEST_TSC_OFFSET);
@@ -95,23 +91,12 @@ int main(int argc, char *argv[])
 {
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_VM_TSC_CONTROL));
 
-	vm = vm_create(NR_TEST_VCPUS);
+	vm = vm_create_with_vcpus(NR_TEST_VCPUS, guest_code, NULL);
 	vm_ioctl(vm, KVM_SET_TSC_KHZ, (void *) TEST_TSC_KHZ);
 
 	pthread_spin_init(&create_lock, PTHREAD_PROCESS_PRIVATE);
-	pthread_t cpu_threads[NR_TEST_VCPUS];
-	unsigned long cpu;
-	for (cpu = 0; cpu < NR_TEST_VCPUS; cpu++)
-		pthread_create(&cpu_threads[cpu], NULL, run_vcpu, (void *)cpu);
-
-	unsigned long failures = 0;
-	for (cpu = 0; cpu < NR_TEST_VCPUS; cpu++) {
-		void *this_cpu_failures;
-		pthread_join(cpu_threads[cpu], &this_cpu_failures);
-		failures += (unsigned long)this_cpu_failures;
-	}
-
-	TEST_ASSERT(!failures, "TSC sync failed");
+	vm_vcpu_threads_create(vm, run_vcpu, 0);
+	vm_vcpu_threads_join(vm);
 	pthread_spin_destroy(&create_lock);
 	kvm_vm_free(vm);
 	return 0;
-- 
2.27.0

