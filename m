Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 869F760A1FF
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 13:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbiJXLiH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 07:38:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230397AbiJXLhp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 07:37:45 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF09263AC;
        Mon, 24 Oct 2022 04:37:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666611452; x=1698147452;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DB1bYR1A7NeiADV6itewTi7E2/TdqRod02cjfT4etd0=;
  b=WrOgQsMIS3pkJnbunaNVVDYbr44SrfyC70DZPCvFsz/DBSfgOI/z2qiF
   TsXaiQnySQfxYtKwU8lNN46MWAKSnCQPCcv45usw8MQr86bm+NWJema+v
   2OB6sVu1jnyPYJq2q2Vgk7U1WtWeJlzw2yHk9jdIoFYb2krErdQwwUGk9
   7X++9cInskc5/1KL4zwo3FP77Vc94aIhnM1XuFIHXUTO9kcM3iV4HhzYm
   vLtJyWi4iqgfnq6ihX0YVNz00c7d1Cx/TjkxBXekeJALy6mJjXjxMABvr
   ENJtXeh7JaXYXvQ6Rzft5x/2iM9SpOyqoZBe0JUVw3+4v+UirH6JWyfog
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10509"; a="369462433"
X-IronPort-AV: E=Sophos;i="5.95,209,1661842800"; 
   d="scan'208";a="369462433"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2022 04:35:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10509"; a="773784858"
X-IronPort-AV: E=Sophos;i="5.95,209,1661842800"; 
   d="scan'208";a="773784858"
Received: from tdx-lm.sh.intel.com ([10.239.53.27])
  by fmsmga001.fm.intel.com with ESMTP; 24 Oct 2022 04:35:08 -0700
From:   Wei Wang <wei.w.wang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     dmatlack@google.com, vipinsh@google.com, ajones@ventanamicro.com,
        eric.auger@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH v1 08/18] KVM: selftests/set_memory_region_test: vcpu related code consolidation
Date:   Mon, 24 Oct 2022 19:34:35 +0800
Message-Id: <20221024113445.1022147-9-wei.w.wang@intel.com>
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

Remove the unnecessary vcpu_thread definition and remove it from the
related funtions' input as it can be referenced from the kvm_vcpu
struct. Also use the helper functinos to create and join the vcpu thread.

Signed-off-by: Wei Wang <wei.w.wang@intel.com>
---
 .../selftests/kvm/set_memory_region_test.c       | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
index 0d55f508d595..d233668957da 100644
--- a/tools/testing/selftests/kvm/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c
@@ -1,7 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #define _GNU_SOURCE /* for program_invocation_short_name */
 #include <fcntl.h>
-#include <pthread.h>
 #include <sched.h>
 #include <semaphore.h>
 #include <signal.h>
@@ -108,8 +107,7 @@ static void wait_for_vcpu(void)
 	usleep(100000);
 }
 
-static struct kvm_vm *spawn_vm(struct kvm_vcpu **vcpu, pthread_t *vcpu_thread,
-			       void *guest_code)
+static struct kvm_vm *spawn_vm(struct kvm_vcpu **vcpu, void *guest_code)
 {
 	struct kvm_vm *vm;
 	uint64_t *hva;
@@ -134,7 +132,7 @@ static struct kvm_vm *spawn_vm(struct kvm_vcpu **vcpu, pthread_t *vcpu_thread,
 	hva = addr_gpa2hva(vm, MEM_REGION_GPA);
 	memset(hva, 0, 2 * 4096);
 
-	pthread_create(vcpu_thread, NULL, vcpu_worker, *vcpu);
+	vm_vcpu_threads_create(vm, vcpu_worker, 0);
 
 	/* Ensure the guest thread is spun up. */
 	wait_for_vcpu();
@@ -175,12 +173,11 @@ static void guest_code_move_memory_region(void)
 
 static void test_move_memory_region(void)
 {
-	pthread_t vcpu_thread;
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	uint64_t *hva;
 
-	vm = spawn_vm(&vcpu, &vcpu_thread, guest_code_move_memory_region);
+	vm = spawn_vm(&vcpu, guest_code_move_memory_region);
 
 	hva = addr_gpa2hva(vm, MEM_REGION_GPA);
 
@@ -211,7 +208,7 @@ static void test_move_memory_region(void)
 	/* Defered sync from when the memslot was misaligned (above). */
 	wait_for_vcpu();
 
-	pthread_join(vcpu_thread, NULL);
+	vm_vcpu_threads_join(vm);
 
 	kvm_vm_free(vm);
 }
@@ -254,13 +251,12 @@ static void guest_code_delete_memory_region(void)
 
 static void test_delete_memory_region(void)
 {
-	pthread_t vcpu_thread;
 	struct kvm_vcpu *vcpu;
 	struct kvm_regs regs;
 	struct kvm_run *run;
 	struct kvm_vm *vm;
 
-	vm = spawn_vm(&vcpu, &vcpu_thread, guest_code_delete_memory_region);
+	vm = spawn_vm(&vcpu, guest_code_delete_memory_region);
 
 	/* Delete the memory region, the guest should not die. */
 	vm_mem_region_delete(vm, MEM_REGION_SLOT);
@@ -282,7 +278,7 @@ static void test_delete_memory_region(void)
 	 */
 	vm_mem_region_delete(vm, 0);
 
-	pthread_join(vcpu_thread, NULL);
+	vm_vcpu_threads_join(vm);
 
 	run = vcpu->run;
 
-- 
2.27.0

