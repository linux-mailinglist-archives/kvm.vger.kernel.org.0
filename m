Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E663660A1F2
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 13:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbiJXLhg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 07:37:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230428AbiJXLhX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 07:37:23 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B08A8659F6;
        Mon, 24 Oct 2022 04:37:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666611421; x=1698147421;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VPV00uz2lI67kSDFo1lvZX3bcVuhMRyuHgzIy6XvjFA=;
  b=jnfl6gjJxawfdf9ie4wZzMy7tJs00Bbtilxjbwu6VvnanU8ckXWpuIe8
   aaeTdjfHNrcVwZUj4pMpcShPYSnjoUN/Vekbks39smsl89eH7PyuEXERI
   z5jj+F/TrlJQ6TFatZr8WYJfapaBaX+k+MLNnrDYUMVtv0d47wwAjCuk7
   iZpNJcXhpQkQpfFStK4O6E2ym5iS/OcDrzmyFjnasm6N2ccjPlzBt2vGs
   tJ/iboJEfBqjVLt2wJ/9eoCT+ZfnpLevwFPSy6eVvFugodiNZHjrim/qk
   Z4jqWrfI6i86hnodTA8Jt4nNWZ8Ur3P9oXgOdYwqIRbeA5zUX/y+eoKp9
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10509"; a="369462405"
X-IronPort-AV: E=Sophos;i="5.95,209,1661842800"; 
   d="scan'208";a="369462405"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2022 04:35:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10509"; a="773784675"
X-IronPort-AV: E=Sophos;i="5.95,209,1661842800"; 
   d="scan'208";a="773784675"
Received: from tdx-lm.sh.intel.com ([10.239.53.27])
  by fmsmga001.fm.intel.com with ESMTP; 24 Oct 2022 04:34:58 -0700
From:   Wei Wang <wei.w.wang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     dmatlack@google.com, vipinsh@google.com, ajones@ventanamicro.com,
        eric.auger@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH v1 04/18] KVM: selftests/kvm_page_table_test: vcpu related code consolidation
Date:   Mon, 24 Oct 2022 19:34:31 +0800
Message-Id: <20221024113445.1022147-5-wei.w.wang@intel.com>
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

kvm_vm has changed to use an array of vcpu pointers (i.e. *vcpus[]) and
the vcpu thread has been included in kvm_vcpu. Remove the unnecessary
array of vcpu poniters and vcpu threads allocation. Use the helper
functions to create and join the vcpu threads.

Signed-off-by: Wei Wang <wei.w.wang@intel.com>
---
 .../testing/selftests/kvm/kvm_page_table_test.c  | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/kvm/kvm_page_table_test.c b/tools/testing/selftests/kvm/kvm_page_table_test.c
index f42c6ac6d71d..4c3df48d80fc 100644
--- a/tools/testing/selftests/kvm/kvm_page_table_test.c
+++ b/tools/testing/selftests/kvm/kvm_page_table_test.c
@@ -14,7 +14,6 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <time.h>
-#include <pthread.h>
 #include <semaphore.h>
 
 #include "test_util.h"
@@ -55,7 +54,6 @@ struct test_args {
 	uint64_t large_num_pages;
 	uint64_t host_pages_per_lpage;
 	enum vm_mem_backing_src_type src_type;
-	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
 };
 
 /*
@@ -255,7 +253,7 @@ static struct kvm_vm *pre_init_before_test(enum vm_guest_mode mode, void *arg)
 	/* Create a VM with enough guest pages */
 	guest_num_pages = test_mem_size / guest_page_size;
 	vm = __vm_create_with_vcpus(mode, nr_vcpus, guest_num_pages,
-				    guest_code, test_args.vcpus);
+				    guest_code, NULL);
 
 	/* Align down GPA of the testing memslot */
 	if (!p->phys_offset)
@@ -343,7 +341,6 @@ static void vcpus_complete_new_stage(enum test_stage stage)
 
 static void run_test(enum vm_guest_mode mode, void *arg)
 {
-	pthread_t *vcpu_threads;
 	struct kvm_vm *vm;
 	struct timespec start;
 	struct timespec ts_diff;
@@ -352,15 +349,10 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	/* Create VM with vCPUs and make some pre-initialization */
 	vm = pre_init_before_test(mode, arg);
 
-	vcpu_threads = malloc(nr_vcpus * sizeof(*vcpu_threads));
-	TEST_ASSERT(vcpu_threads, "Memory allocation failed");
-
 	host_quit = false;
 	*current_stage = KVM_BEFORE_MAPPINGS;
 
-	for (i = 0; i < nr_vcpus; i++)
-		pthread_create(&vcpu_threads[i], NULL, vcpu_worker,
-			       test_args.vcpus[i]);
+	vm_vcpu_threads_create(vm, vcpu_worker, 0);
 
 	vcpus_complete_new_stage(*current_stage);
 	pr_info("Started all vCPUs successfully\n");
@@ -407,8 +399,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 		TEST_ASSERT(ret == 0, "Error in sem_post");
 	}
 
-	for (i = 0; i < nr_vcpus; i++)
-		pthread_join(vcpu_threads[i], NULL);
+	vm_vcpu_threads_join(vm);
 
 	ret = sem_destroy(&test_stage_updated);
 	TEST_ASSERT(ret == 0, "Error in sem_destroy");
@@ -416,7 +407,6 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	ret = sem_destroy(&test_stage_completed);
 	TEST_ASSERT(ret == 0, "Error in sem_destroy");
 
-	free(vcpu_threads);
 	ucall_uninit(vm);
 	kvm_vm_free(vm);
 }
-- 
2.27.0

