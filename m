Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0A8C60A1F6
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 13:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbiJXLht (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 07:37:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230320AbiJXLh3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 07:37:29 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD8F150FBA;
        Mon, 24 Oct 2022 04:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666611437; x=1698147437;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RgJBG8ARI2ObMkQFmZbYJeEN4Gn6KZAqtFE7Cxj6InY=;
  b=OzadMmOHTJ+Je38W4wbsGDzpUHjgZvlHzWe7kB/olSxgu/gnwwoDwoSf
   CbiFX3Do3s77dVZpmqLY+8W9EFzs236Kwm/iJRh8hNWzp/Tr/1saujzkO
   JhbC0H2AVuzRpjRZx5SSZ7/IO8aaPEahGvCj3Yj8g7LBRzEnbtzH2ze5A
   YG2Jc4l373c30beyypSkIEzITtXmxKdH6BbCKHtXL0c7Wu7NNfl1FVc4D
   XZGvldwqNdhJ045TW979gaUUk2mNStyakwrgpFG0aUqUGxVfVPaqKYi71
   bdK/1KyZmMA+7RxqC7dTaKtTC3lWE96WpDDaEzoMbO2BR9qT0DLNGTBfm
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10509"; a="369462409"
X-IronPort-AV: E=Sophos;i="5.95,209,1661842800"; 
   d="scan'208";a="369462409"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2022 04:35:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10509"; a="773784714"
X-IronPort-AV: E=Sophos;i="5.95,209,1661842800"; 
   d="scan'208";a="773784714"
Received: from tdx-lm.sh.intel.com ([10.239.53.27])
  by fmsmga001.fm.intel.com with ESMTP; 24 Oct 2022 04:35:00 -0700
From:   Wei Wang <wei.w.wang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     dmatlack@google.com, vipinsh@google.com, ajones@ventanamicro.com,
        eric.auger@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH v1 05/18] KVM: selftests/hardware_disable_test: code consolidation and cleanup
Date:   Mon, 24 Oct 2022 19:34:32 +0800
Message-Id: <20221024113445.1022147-6-wei.w.wang@intel.com>
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

Remove the unnecessary definition of the threads[] array, and use the
helper functions to create and join threads.

Also move setting of the thread affinity to __vcpu_thread_create using
attribute. This avoids an explicit step to set it after thread
creation.

Signed-off-by: Wei Wang <wei.w.wang@intel.com>
---
 .../selftests/kvm/hardware_disable_test.c     | 56 +++++--------------
 1 file changed, 15 insertions(+), 41 deletions(-)

diff --git a/tools/testing/selftests/kvm/hardware_disable_test.c b/tools/testing/selftests/kvm/hardware_disable_test.c
index f5d59b9934f1..c212d34a6714 100644
--- a/tools/testing/selftests/kvm/hardware_disable_test.c
+++ b/tools/testing/selftests/kvm/hardware_disable_test.c
@@ -8,7 +8,6 @@
 #define _GNU_SOURCE
 
 #include <fcntl.h>
-#include <pthread.h>
 #include <semaphore.h>
 #include <stdint.h>
 #include <stdlib.h>
@@ -59,64 +58,39 @@ static void *sleeping_thread(void *arg)
 	pthread_exit(NULL);
 }
 
-static inline void check_create_thread(pthread_t *thread, pthread_attr_t *attr,
-				       void *(*f)(void *), void *arg)
-{
-	int r;
-
-	r = pthread_create(thread, attr, f, arg);
-	TEST_ASSERT(r == 0, "%s: failed to create thread", __func__);
-}
-
-static inline void check_set_affinity(pthread_t thread, cpu_set_t *cpu_set)
-{
-	int r;
-
-	r = pthread_setaffinity_np(thread, sizeof(cpu_set_t), cpu_set);
-	TEST_ASSERT(r == 0, "%s: failed set affinity", __func__);
-}
-
-static inline void check_join(pthread_t thread, void **retval)
-{
-	int r;
-
-	r = pthread_join(thread, retval);
-	TEST_ASSERT(r == 0, "%s: failed to join thread", __func__);
-}
-
 static void run_test(uint32_t run)
 {
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	cpu_set_t cpu_set;
-	pthread_t threads[VCPU_NUM];
 	pthread_t throw_away;
-	void *b;
+	pthread_attr_t attr;
 	uint32_t i, j;
+	int r;
 
 	CPU_ZERO(&cpu_set);
 	for (i = 0; i < VCPU_NUM; i++)
 		CPU_SET(i, &cpu_set);
+	r = pthread_attr_init(&attr);
+	TEST_ASSERT(!r, "%s: failed to init thread attr, r = %d", __func__, r);
+	r = pthread_attr_setaffinity_np(&attr, sizeof(cpu_set_t), &cpu_set);
+	TEST_ASSERT(!r, "%s: failed to set affinity, r = %d", __func__, r);
 
-	vm = vm_create(VCPU_NUM);
+	vm = vm_create_with_vcpus(VCPU_NUM, guest_code, NULL);
 
 	pr_debug("%s: [%d] start vcpus\n", __func__, run);
-	for (i = 0; i < VCPU_NUM; ++i) {
-		vcpu = vm_vcpu_add(vm, i, guest_code);
+	vm_iterate_over_vcpus(vm, vcpu, i) {
+		__vcpu_thread_create(vcpu, &attr, run_vcpu, 0);
 
-		check_create_thread(&threads[i], NULL, run_vcpu, vcpu);
-		check_set_affinity(threads[i], &cpu_set);
-
-		for (j = 0; j < SLEEPING_THREAD_NUM; ++j) {
-			check_create_thread(&throw_away, NULL, sleeping_thread,
-					    (void *)NULL);
-			check_set_affinity(throw_away, &cpu_set);
-		}
+		for (j = 0; j < SLEEPING_THREAD_NUM; ++j)
+			__pthread_create_with_name(&throw_away, &attr,
+						sleeping_thread, (void *)NULL,
+						"sleeping-thread");
 	}
 	pr_debug("%s: [%d] all threads launched\n", __func__, run);
 	sem_post(sem);
-	for (i = 0; i < VCPU_NUM; ++i)
-		check_join(threads[i], &b);
+
+	vm_vcpu_threads_join(vm);
 	/* Should not be reached */
 	TEST_ASSERT(false, "%s: [%d] child escaped the ninja\n", __func__, run);
 }
-- 
2.27.0

