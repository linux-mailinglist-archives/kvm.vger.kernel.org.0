Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C36847AA08F
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 22:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232373AbjIUUls (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 16:41:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230445AbjIUUl3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 16:41:29 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACCAC2D62;
        Thu, 21 Sep 2023 13:15:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695327315; x=1726863315;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RtfNaKFCK9P/yxwP8BTsIwYqXtE9p2zlPuJXOdTAut0=;
  b=e4DH9lqW+/cctTriOc12YlCVQdbn4hcdR/U7va03BA2QBGCLmG3E/2uS
   gJfsv8Xyi6tJrrG+3slupzU5HtRm10N/yNNTz6QBGEG02hQN9hhLklTsV
   SSDbJu+4yWfgeTSEPgcrL25mflHF6+6m4pWjEB1Bq4qHXhVMhvZRoc4Xk
   wK26qv2Zno4TXNYHN3nk4yI5WCr8Z1EXZcz2BkCnPe5fE9RwcHQBZNEch
   YTE+zZeDoDO/819MR4u+L6W4QWe1RO/rNUMPokyO9JUTYDQItmPlr9hq+
   1qtWjYX+9Gga359OC6ECKDKD8QNuVLjg/dICN4hv44X/bdk6GhHKDuP5s
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10840"; a="383401616"
X-IronPort-AV: E=Sophos;i="6.03,166,1694761200"; 
   d="scan'208";a="383401616"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2023 13:14:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10840"; a="696897795"
X-IronPort-AV: E=Sophos;i="6.03,166,1694761200"; 
   d="scan'208";a="696897795"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2023 13:14:47 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Michael Roth <michael.roth@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, erdemaktas@google.com,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        linux-coco@lists.linux.dev,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Xu Yilun <yilun.xu@intel.com>,
        Quentin Perret <qperret@google.com>, wei.w.wang@intel.com,
        Fuad Tabba <tabba@google.com>
Subject: [RFC PATCH v2 3/6] KVM: selftests: Add tests for punch hole on guest_memfd
Date:   Thu, 21 Sep 2023 13:14:36 -0700
Message-Id: <26822c313754e03b2c393e6fdefe495f117bbfff.1695327124.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1695327124.git.isaku.yamahata@intel.com>
References: <cover.1695327124.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Punch hole implies the region is zeroed out. Add tests if the punched
region has zero.
Oppertunistically Remove unused member, pattern, in guest_run_test().

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 .../kvm/x86_64/private_mem_conversions_test.c | 26 ++++++++++++++-----
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/private_mem_conversions_test.c b/tools/testing/selftests/kvm/x86_64/private_mem_conversions_test.c
index 50541246d6fd..c05c725645af 100644
--- a/tools/testing/selftests/kvm/x86_64/private_mem_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86_64/private_mem_conversions_test.c
@@ -85,9 +85,10 @@ static void guest_sync_private(uint64_t gpa, uint64_t size, uint8_t pattern)
 /* Arbitrary values, KVM doesn't care about the attribute flags. */
 #define MAP_GPA_SHARED		BIT(0)
 #define MAP_GPA_DO_FALLOCATE	BIT(1)
+#define MAP_GPA_FALLOCATE_ONLY	BIT(2)
 
 static void guest_map_mem(uint64_t gpa, uint64_t size, bool map_shared,
-			  bool do_fallocate)
+			  bool do_fallocate, bool fallocate_only)
 {
 	uint64_t flags = 0;
 
@@ -95,17 +96,24 @@ static void guest_map_mem(uint64_t gpa, uint64_t size, bool map_shared,
 		flags |= MAP_GPA_SHARED;
 	if (do_fallocate)
 		flags |= MAP_GPA_DO_FALLOCATE;
+	if (fallocate_only)
+		flags |= MAP_GPA_FALLOCATE_ONLY;
 	kvm_hypercall_map_gpa_range(gpa, size, flags);
 }
 
 static void guest_map_shared(uint64_t gpa, uint64_t size, bool do_fallocate)
 {
-	guest_map_mem(gpa, size, true, do_fallocate);
+	guest_map_mem(gpa, size, true, do_fallocate, false);
 }
 
 static void guest_map_private(uint64_t gpa, uint64_t size, bool do_fallocate)
 {
-	guest_map_mem(gpa, size, false, do_fallocate);
+	guest_map_mem(gpa, size, false, do_fallocate, false);
+}
+
+static void guest_punch_hole_private(uint64_t gpa, uint64_t size)
+{
+	guest_map_mem(gpa, size, true, true, true);
 }
 
 static void guest_run_test(uint64_t base_gpa, bool do_fallocate)
@@ -113,7 +121,6 @@ static void guest_run_test(uint64_t base_gpa, bool do_fallocate)
 	struct {
 		uint64_t offset;
 		uint64_t size;
-		uint8_t pattern;
 	} stages[] = {
 		GUEST_STAGE(0, PAGE_SIZE),
 		GUEST_STAGE(0, SZ_2M),
@@ -156,6 +163,10 @@ static void guest_run_test(uint64_t base_gpa, bool do_fallocate)
 
 		if (size > PAGE_SIZE) {
 			memset((void *)gpa, p2, PAGE_SIZE);
+
+			/* Test if punch hole results in zeroing page. */
+			guest_punch_hole_private(gpa, PAGE_SIZE);
+			memcmp_g(gpa, 0, PAGE_SIZE);
 			goto skip;
 		}
 
@@ -229,6 +240,7 @@ static void handle_exit_hypercall(struct kvm_vcpu *vcpu)
 	uint64_t size = run->hypercall.args[1] * PAGE_SIZE;
 	bool map_shared = run->hypercall.args[2] & MAP_GPA_SHARED;
 	bool do_fallocate = run->hypercall.args[2] & MAP_GPA_DO_FALLOCATE;
+	bool fallocate_only = run->hypercall.args[2] & MAP_GPA_FALLOCATE_ONLY;
 	struct kvm_vm *vm = vcpu->vm;
 
 	TEST_ASSERT(run->hypercall.nr == KVM_HC_MAP_GPA_RANGE,
@@ -238,8 +250,10 @@ static void handle_exit_hypercall(struct kvm_vcpu *vcpu)
 	if (do_fallocate)
 		vm_guest_mem_fallocate(vm, gpa, size, map_shared);
 
-	vm_set_memory_attributes(vm, gpa, size,
-				 map_shared ? 0 : KVM_MEMORY_ATTRIBUTE_PRIVATE);
+	if (!fallocate_only)
+		vm_set_memory_attributes(vm, gpa, size,
+					 map_shared ?
+					 0 : KVM_MEMORY_ATTRIBUTE_PRIVATE);
 	run->hypercall.ret = 0;
 }
 
-- 
2.25.1

