Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD67260A230
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 13:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231147AbiJXLjg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 07:39:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230487AbiJXLie (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 07:38:34 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA50FB1E9;
        Mon, 24 Oct 2022 04:38:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666611482; x=1698147482;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VfbQaPDh8z2xxcOon1s6cTrPqmF5WJAx6/Ye0pT0g4o=;
  b=gvdUL6ByCWqDhy8Km5LfNivDeZq98j17Oax7mlmuybFDO6fA6zELwBvc
   7HTOIR2OxMSsVYABS8eVtSQ8/nSzIoKSsgot0fB5HN6AC5KGzZyRKNqvM
   ZRD7cn7ZjSQW6MnwkiErKmfFAzQotpnX8TAJdlOUKgpm84pFCm5CvktLt
   VmlRSFIErg6vVRYFdjamTQIYy2DF7t0F1lEObIwxL00gkoAq69okq3aFZ
   LXhowZVv1jMDi229AtKfmD//ZmOfvvnWrqF3RxslRPbTDC4MfqymZEUmT
   t3I7Vn0H8EmSgTpFwLKPwsBScM0WRzI5a/JtNfPXKaPO4oFz1Hk6gFo8R
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10509"; a="369462478"
X-IronPort-AV: E=Sophos;i="5.95,209,1661842800"; 
   d="scan'208";a="369462478"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2022 04:35:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10509"; a="773785057"
X-IronPort-AV: E=Sophos;i="5.95,209,1661842800"; 
   d="scan'208";a="773785057"
Received: from tdx-lm.sh.intel.com ([10.239.53.27])
  by fmsmga001.fm.intel.com with ESMTP; 24 Oct 2022 04:35:25 -0700
From:   Wei Wang <wei.w.wang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     dmatlack@google.com, vipinsh@google.com, ajones@ventanamicro.com,
        eric.auger@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH v1 15/18] KVM: selftests/vgic_init: vcpu related code consolidation
Date:   Mon, 24 Oct 2022 19:34:42 +0800
Message-Id: <20221024113445.1022147-16-wei.w.wang@intel.com>
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

Remove the unnecessary definition of the *vcpu[] array and reuse the one
from kvm_vm. Simplify the related function interface by removeing the
*vcpu[].

Signed-off-by: Wei Wang <wei.w.wang@intel.com>
---
 .../testing/selftests/kvm/aarch64/vgic_init.c | 35 +++++++++----------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
index 9c131d977a1b..e24130a49581 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
@@ -74,13 +74,12 @@ static int run_vcpu(struct kvm_vcpu *vcpu)
 }
 
 static struct vm_gic vm_gic_create_with_vcpus(uint32_t gic_dev_type,
-					      uint32_t nr_vcpus,
-					      struct kvm_vcpu *vcpus[])
+					      uint32_t nr_vcpus)
 {
 	struct vm_gic v;
 
 	v.gic_dev_type = gic_dev_type;
-	v.vm = vm_create_with_vcpus(nr_vcpus, guest_code, vcpus);
+	v.vm = vm_create_with_vcpus(nr_vcpus, guest_code, NULL);
 	v.gic_fd = kvm_create_device(v.vm, gic_dev_type);
 
 	return v;
@@ -324,14 +323,15 @@ static void subtest_v3_redist_regions(struct vm_gic *v)
  */
 static void test_vgic_then_vcpus(uint32_t gic_dev_type)
 {
-	struct kvm_vcpu *vcpus[NR_VCPUS];
+	struct kvm_vcpu **vcpus;
 	struct vm_gic v;
 	int ret, i;
 
-	v = vm_gic_create_with_vcpus(gic_dev_type, 1, vcpus);
+	v = vm_gic_create_with_vcpus(gic_dev_type, 1);
 
 	subtest_dist_rdist(&v);
 
+	vcpus = v.vm->vcpus;
 	/* Add the rest of the VCPUs */
 	for (i = 1; i < NR_VCPUS; ++i)
 		vcpus[i] = vm_vcpu_add(v.vm, i, guest_code);
@@ -345,15 +345,14 @@ static void test_vgic_then_vcpus(uint32_t gic_dev_type)
 /* All the VCPUs are created before the VGIC KVM device gets initialized */
 static void test_vcpus_then_vgic(uint32_t gic_dev_type)
 {
-	struct kvm_vcpu *vcpus[NR_VCPUS];
 	struct vm_gic v;
 	int ret;
 
-	v = vm_gic_create_with_vcpus(gic_dev_type, NR_VCPUS, vcpus);
+	v = vm_gic_create_with_vcpus(gic_dev_type, NR_VCPUS);
 
 	subtest_dist_rdist(&v);
 
-	ret = run_vcpu(vcpus[3]);
+	ret = run_vcpu(v.vm->vcpus[3]);
 	TEST_ASSERT(ret == -EINVAL, "dist/rdist overlap detected on 1st vcpu run");
 
 	vm_gic_destroy(&v);
@@ -361,24 +360,25 @@ static void test_vcpus_then_vgic(uint32_t gic_dev_type)
 
 static void test_v3_new_redist_regions(void)
 {
-	struct kvm_vcpu *vcpus[NR_VCPUS];
+	struct kvm_vcpu **vcpus;
 	void *dummy = NULL;
 	struct vm_gic v;
 	uint64_t addr;
 	int ret;
 
-	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS, vcpus);
+	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS);
 	subtest_v3_redist_regions(&v);
 	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
 			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
 
+	vcpus = v.vm->vcpus;
 	ret = run_vcpu(vcpus[3]);
 	TEST_ASSERT(ret == -ENXIO, "running without sufficient number of rdists");
 	vm_gic_destroy(&v);
 
 	/* step2 */
 
-	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS, vcpus);
+	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS);
 	subtest_v3_redist_regions(&v);
 
 	addr = REDIST_REGION_ATTR_ADDR(1, 0x280000, 0, 2);
@@ -392,7 +392,7 @@ static void test_v3_new_redist_regions(void)
 
 	/* step 3 */
 
-	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS, vcpus);
+	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS);
 	subtest_v3_redist_regions(&v);
 
 	ret = __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
@@ -559,12 +559,12 @@ static void test_v3_last_bit_single_rdist(void)
 /* Uses the legacy REDIST region API. */
 static void test_v3_redist_ipa_range_check_at_vcpu_run(void)
 {
-	struct kvm_vcpu *vcpus[NR_VCPUS];
+	struct kvm_vcpu **vcpus;
 	struct vm_gic v;
 	int ret, i;
 	uint64_t addr;
 
-	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, 1, vcpus);
+	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, 1);
 
 	/* Set space for 3 redists, we have 1 vcpu, so this succeeds. */
 	addr = max_phys_size - (3 * 2 * 0x10000);
@@ -575,6 +575,7 @@ static void test_v3_redist_ipa_range_check_at_vcpu_run(void)
 	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
 			    KVM_VGIC_V3_ADDR_TYPE_DIST, &addr);
 
+	vcpus = v.vm->vcpus;
 	/* Add the rest of the VCPUs */
 	for (i = 1; i < NR_VCPUS; ++i)
 		vcpus[i] = vm_vcpu_add(v.vm, i, guest_code);
@@ -592,12 +593,11 @@ static void test_v3_redist_ipa_range_check_at_vcpu_run(void)
 
 static void test_v3_its_region(void)
 {
-	struct kvm_vcpu *vcpus[NR_VCPUS];
 	struct vm_gic v;
 	uint64_t addr;
 	int its_fd, ret;
 
-	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS, vcpus);
+	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS);
 	its_fd = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_ITS);
 
 	addr = 0x401000;
@@ -637,12 +637,11 @@ static void test_v3_its_region(void)
  */
 int test_kvm_device(uint32_t gic_dev_type)
 {
-	struct kvm_vcpu *vcpus[NR_VCPUS];
 	struct vm_gic v;
 	uint32_t other;
 	int ret;
 
-	v.vm = vm_create_with_vcpus(NR_VCPUS, guest_code, vcpus);
+	v.vm = vm_create_with_vcpus(NR_VCPUS, guest_code, NULL);
 
 	/* try to create a non existing KVM device */
 	ret = __kvm_test_create_device(v.vm, 0);
-- 
2.27.0

