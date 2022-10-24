Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29F1960A201
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 13:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231135AbiJXLiB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 07:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230419AbiJXLhf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 07:37:35 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 174B065240;
        Mon, 24 Oct 2022 04:37:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666611443; x=1698147443;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mKq2NUT7YOX2uBR+Ke1CoZuizyxYRwCCOE+dvTpxS40=;
  b=kDl178Yi+/m+aNCVfLI5i/erG9pOJsBXIeHSvN0CgLZ5jb1dN7SO+Edw
   cL/VxnlXR3g/0s6WVDzgN7EJfPENcT8MmGKYtX6amXc+mGw0YHQJ8F24K
   knSqUKICLr+yue2LbtDStAojmbMkAFzbBpLRdoO34zZZcPU65MlSD8zKP
   czFI6M0t+IMtMyxkby+9z66mBTgtK9rYI5n0ZAEibRAUZWuSHVBqxiy2K
   c0WtCL9sFvLATiYBUuKEqSM5DLhF2Spt0ZJkRRRqHsgKIqRih3OIKNSBK
   i0eXcN6HbJJ9toPHdwhAp74S4SGFvs2r5bw0jRQUdNsW5YiAGhSBx71Gd
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10509"; a="369462415"
X-IronPort-AV: E=Sophos;i="5.95,209,1661842800"; 
   d="scan'208";a="369462415"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2022 04:35:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10509"; a="773784761"
X-IronPort-AV: E=Sophos;i="5.95,209,1661842800"; 
   d="scan'208";a="773784761"
Received: from tdx-lm.sh.intel.com ([10.239.53.27])
  by fmsmga001.fm.intel.com with ESMTP; 24 Oct 2022 04:35:03 -0700
From:   Wei Wang <wei.w.wang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     dmatlack@google.com, vipinsh@google.com, ajones@ventanamicro.com,
        eric.auger@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH v1 06/18] KVM: selftests/dirty_log_test: vcpu related code consolidation
Date:   Mon, 24 Oct 2022 19:34:33 +0800
Message-Id: <20221024113445.1022147-7-wei.w.wang@intel.com>
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

Remove the globally defined vcpu thread, and reuse the one from
kvm_vcpu. Also, use the helper functions to create and join the vcpu
thread, which has implemented error check (i.e. TEST_ASSERT) inside.

Signed-off-by: Wei Wang <wei.w.wang@intel.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index b5234d6efbe1..9177b8ca004d 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -9,7 +9,6 @@
 
 #include <stdio.h>
 #include <stdlib.h>
-#include <pthread.h>
 #include <semaphore.h>
 #include <sys/types.h>
 #include <signal.h>
@@ -188,12 +187,11 @@ enum log_mode_t {
 static enum log_mode_t host_log_mode_option = LOG_MODE_ALL;
 /* Logging mode for current run */
 static enum log_mode_t host_log_mode;
-static pthread_t vcpu_thread;
 static uint32_t test_dirty_ring_count = TEST_DIRTY_RING_COUNT;
 
-static void vcpu_kick(void)
+static void vcpu_kick(struct kvm_vcpu *vcpu)
 {
-	pthread_kill(vcpu_thread, SIG_IPI);
+	pthread_kill(vcpu->thread, SIG_IPI);
 }
 
 /*
@@ -315,10 +313,10 @@ static uint32_t dirty_ring_collect_one(struct kvm_dirty_gfn *dirty_gfns,
 	return count;
 }
 
-static void dirty_ring_wait_vcpu(void)
+static void dirty_ring_wait_vcpu(struct kvm_vcpu *vcpu)
 {
 	/* This makes sure that hardware PML cache flushed */
-	vcpu_kick();
+	vcpu_kick(vcpu);
 	sem_wait_until(&sem_vcpu_stop);
 }
 
@@ -336,7 +334,7 @@ static void dirty_ring_collect_dirty_pages(struct kvm_vcpu *vcpu, int slot,
 	uint32_t count = 0, cleared;
 	bool continued_vcpu = false;
 
-	dirty_ring_wait_vcpu();
+	dirty_ring_wait_vcpu(vcpu);
 
 	if (!dirty_ring_vcpu_ring_full) {
 		/*
@@ -772,7 +770,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	host_clear_count = 0;
 	host_track_next_count = 0;
 
-	pthread_create(&vcpu_thread, NULL, vcpu_worker, vcpu);
+	vcpu_thread_create(vcpu, vcpu_worker, 0);
 
 	while (iteration < p->iterations) {
 		/* Give the vcpu thread some time to dirty some pages */
@@ -805,7 +803,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	/* Tell the vcpu thread to quit */
 	host_quit = true;
 	log_mode_before_vcpu_join();
-	pthread_join(vcpu_thread, NULL);
+	vm_vcpu_threads_join(vm);
 
 	pr_info("Total bits checked: dirty (%"PRIu64"), clear (%"PRIu64"), "
 		"track_next (%"PRIu64")\n", host_dirty_count, host_clear_count,
-- 
2.27.0

