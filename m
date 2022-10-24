Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 982EA60A250
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 13:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230522AbiJXLk5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 07:40:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231214AbiJXLih (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 07:38:37 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5F50696FD;
        Mon, 24 Oct 2022 04:37:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666611466; x=1698147466;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tOCK3h3jPTF9+zsBKkGPw4b8sRWy9dxpSKt7joVm7RQ=;
  b=f9kylC3xIZwJfYktCAHkH6xe+FHSr026mckP+weduDPuf8m/0GfyqAGm
   sdlP4LGQXBT6SGvWtajTRgkoeog5qeHCJtHGkWY5icGygJ/mJdGQujNC/
   9jNsRAr547JggRqYGDwaUPLoOtfEWMM4IVpkdvhZqn09gSlkzoROPPrRm
   59klknAifdEnu3PYomagMYaFTYXKxIQjIRUWkJ8CgLm6ZRISnGuD5Enkm
   B5LApfNoaEJghPfKIQ/ib4IczjVaq8nqh73iyJYUBtzR1+9poyxTaXiJM
   nNqOIz2wxdLqEYoXqbFL9QSQDflm92b646UeRS2bFs5lDqNT856JXzZpY
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10509"; a="369462454"
X-IronPort-AV: E=Sophos;i="5.95,209,1661842800"; 
   d="scan'208";a="369462454"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2022 04:35:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10509"; a="773785009"
X-IronPort-AV: E=Sophos;i="5.95,209,1661842800"; 
   d="scan'208";a="773785009"
Received: from tdx-lm.sh.intel.com ([10.239.53.27])
  by fmsmga001.fm.intel.com with ESMTP; 24 Oct 2022 04:35:17 -0700
From:   Wei Wang <wei.w.wang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     dmatlack@google.com, vipinsh@google.com, ajones@ventanamicro.com,
        eric.auger@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH v1 12/18] KVM: selftests/rseq_test: name the migration thread and some cleanup
Date:   Mon, 24 Oct 2022 19:34:39 +0800
Message-Id: <20221024113445.1022147-13-wei.w.wang@intel.com>
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

Use the helper function to create the migration thread with name. Change
the global defination of migration_thread to local, as it's not
referenced anywhere outside main(). Aslo, check the return value from
pthread_join and assert on errors.

Signed-off-by: Wei Wang <wei.w.wang@intel.com>
---
 tools/testing/selftests/kvm/rseq_test.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/rseq_test.c b/tools/testing/selftests/kvm/rseq_test.c
index 6f88da7e60be..c124f00ca4fe 100644
--- a/tools/testing/selftests/kvm/rseq_test.c
+++ b/tools/testing/selftests/kvm/rseq_test.c
@@ -2,7 +2,6 @@
 #define _GNU_SOURCE /* for program_invocation_short_name */
 #include <errno.h>
 #include <fcntl.h>
-#include <pthread.h>
 #include <sched.h>
 #include <stdio.h>
 #include <stdlib.h>
@@ -28,7 +27,6 @@
  */
 #define NR_TASK_MIGRATIONS 100000
 
-static pthread_t migration_thread;
 static cpu_set_t possible_mask;
 static int min_cpu, max_cpu;
 static bool done;
@@ -204,6 +202,7 @@ int main(int argc, char *argv[])
 	struct kvm_vm *vm;
 	struct kvm_vcpu *vcpu;
 	u32 cpu, rseq_cpu;
+	pthread_t migration_thread;
 
 	/* Tell stdout not to buffer its content */
 	setbuf(stdout, NULL);
@@ -226,8 +225,8 @@ int main(int argc, char *argv[])
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 	ucall_init(vm, NULL);
 
-	pthread_create(&migration_thread, NULL, migration_worker,
-		       (void *)(unsigned long)syscall(SYS_gettid));
+	pthread_create_with_name(&migration_thread, migration_worker,
+		 (void *)(unsigned long)syscall(SYS_gettid), "mig-thread");
 
 	for (i = 0; !done; i++) {
 		vcpu_run(vcpu);
@@ -272,7 +271,8 @@ int main(int argc, char *argv[])
 	TEST_ASSERT(i > (NR_TASK_MIGRATIONS / 2),
 		    "Only performed %d KVM_RUNs, task stalled too much?\n", i);
 
-	pthread_join(migration_thread, NULL);
+	r = pthread_join(migration_thread, NULL);
+	TEST_ASSERT(r == 0, "failed to join the migration thread");
 
 	kvm_vm_free(vm);
 
-- 
2.27.0

