Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A86F960A207
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 13:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230472AbiJXLi0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 07:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230475AbiJXLhp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 07:37:45 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07BA13ECF9;
        Mon, 24 Oct 2022 04:37:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666611454; x=1698147454;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/8kRGW6jheanoEsx0SN1Z08oqwhwoihZSgoeWklWb5s=;
  b=g9vWJ4ItRESk1S8Gdme3JEU+CmkNT0pcy72yxr4g58H5nKWoCWvkRh8Z
   CJZOdz9oCyU8Zum1wtMHuHIihHjVt5Ns09h3DspA7q0xzYTor11kl/6/7
   3gIq7Ho44qgQAYe8O7DbsEXyRxIOobv7DEFTtLgaHbeHccTndkMcUz4yp
   Iyaq0ugxQ2eWQlditiIzDrpQpEATbDNilrtYVOmijvYjvLIQ0+9SluN2K
   2Kh2oTSBGdc8Y+48U79IJKL87W4hBhEO0AtLD6Oluv7Jpp+dW71SZMHqT
   3BAhePG2vixWNZ+PPppHPn++4WPqlF23/BVbhdq3GbRikteqsBXLl79f5
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10509"; a="369462439"
X-IronPort-AV: E=Sophos;i="5.95,209,1661842800"; 
   d="scan'208";a="369462439"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2022 04:35:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10509"; a="773784910"
X-IronPort-AV: E=Sophos;i="5.95,209,1661842800"; 
   d="scan'208";a="773784910"
Received: from tdx-lm.sh.intel.com ([10.239.53.27])
  by fmsmga001.fm.intel.com with ESMTP; 24 Oct 2022 04:35:10 -0700
From:   Wei Wang <wei.w.wang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     dmatlack@google.com, vipinsh@google.com, ajones@ventanamicro.com,
        eric.auger@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH v1 09/18] KVM: selftests/steal_time: vcpu related code consolidation and cleanup
Date:   Mon, 24 Oct 2022 19:34:36 +0800
Message-Id: <20221024113445.1022147-10-wei.w.wang@intel.com>
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

Remove the unnecessary definition of array of the vcpu pointers and
re-use the one from the kvm_vm struct (i.e. vm->vcpus[]). Use the helper
function to create the time stealing thread with name.

Also add a check of the pthread_join return value.

Signed-off-by: Wei Wang <wei.w.wang@intel.com>
---
 tools/testing/selftests/kvm/steal_time.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
index db8967f1a17b..857ed2c073fc 100644
--- a/tools/testing/selftests/kvm/steal_time.c
+++ b/tools/testing/selftests/kvm/steal_time.c
@@ -8,7 +8,6 @@
 #include <stdio.h>
 #include <time.h>
 #include <sched.h>
-#include <pthread.h>
 #include <linux/kernel.h>
 #include <asm/kvm.h>
 #include <asm/kvm_para.h>
@@ -241,7 +240,7 @@ static void run_vcpu(struct kvm_vcpu *vcpu)
 
 int main(int ac, char **av)
 {
-	struct kvm_vcpu *vcpus[NR_VCPUS];
+	struct kvm_vcpu **vcpus;
 	struct kvm_vm *vm;
 	pthread_attr_t attr;
 	pthread_t thread;
@@ -250,7 +249,7 @@ int main(int ac, char **av)
 	long stolen_time;
 	long run_delay;
 	bool verbose;
-	int i;
+	int i, r;
 
 	verbose = ac > 1 && (!strncmp(av[1], "-v", 3) || !strncmp(av[1], "--verbose", 10));
 
@@ -262,7 +261,8 @@ int main(int ac, char **av)
 	pthread_setaffinity_np(pthread_self(), sizeof(cpu_set_t), &cpuset);
 
 	/* Create a VM and an identity mapped memslot for the steal time structure */
-	vm = vm_create_with_vcpus(NR_VCPUS, guest_code, vcpus);
+	vm = vm_create_with_vcpus(NR_VCPUS, guest_code, NULL);
+	vcpus = vm->vcpus;
 	gpages = vm_calc_num_guest_pages(VM_MODE_DEFAULT, STEAL_TIME_SIZE * NR_VCPUS);
 	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, ST_GPA_BASE, 1, gpages, 0);
 	virt_map(vm, ST_GPA_BASE, ST_GPA_BASE, gpages);
@@ -290,11 +290,14 @@ int main(int ac, char **av)
 
 		/* Steal time from the VCPU. The steal time thread has the same CPU affinity as the VCPUs. */
 		run_delay = get_run_delay();
-		pthread_create(&thread, &attr, do_steal_time, NULL);
+		__pthread_create_with_name(&thread, &attr,
+					   do_steal_time, NULL, "steal-time");
 		do
 			sched_yield();
 		while (get_run_delay() - run_delay < MIN_RUN_DELAY_NS);
-		pthread_join(thread, NULL);
+		r = pthread_join(thread, NULL);
+		TEST_ASSERT(!r, "failed to join the time stealing thread");
+
 		run_delay = get_run_delay() - run_delay;
 		TEST_ASSERT(run_delay >= MIN_RUN_DELAY_NS,
 			    "Expected run_delay >= %ld, got %ld",
-- 
2.27.0

