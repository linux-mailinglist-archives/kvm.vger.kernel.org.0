Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 380797A9BCC
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 21:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230394AbjIUTEa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 15:04:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbjIUTEG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 15:04:06 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70C8C4E5D8
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:50:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695318601; x=1726854601;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=W9fNFA8xcVEA/iV9+MsAkTcTdm8KC9i+ViXMaeaufNc=;
  b=Cb0EFyzwgXav3Q2zhKKxuNBmqvZ9nO/upBefVn2yZpQMeTFb0929xvB8
   x2r6AGgYWuhwYhSgrpsbNhV0HTEVOqtGhyv0TOJnDudvqsySWQqzlXHeC
   wN8TNMPfE2Et6VmtwB9XzQX2dj62ykRmhkuVV7u4Rg5PFUOtUVFv3/2yV
   bZoVqnkpm4GWuh0LxEij+jwGPxdudoim1zyryYHBapJ60ToFuS95JMEgS
   tvGGdo6GDKrw2XbtLSHdNGQKrexkCg/o2LXIW+wKJYbPsOVGV4JAr8RhE
   XMGsioqPjdBnrVovOAQHgKVKwVBplws8vHqfGu0+LrW0ZxtcANwYRjM5z
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10839"; a="359841386"
X-IronPort-AV: E=Sophos;i="6.03,164,1694761200"; 
   d="scan'208";a="359841386"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2023 01:31:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10839"; a="747001191"
X-IronPort-AV: E=Sophos;i="6.03,164,1694761200"; 
   d="scan'208";a="747001191"
Received: from dorasunx-mobl1.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.255.30.47])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2023 01:31:25 -0700
From:   Xiong Zhang <xiong.y.zhang@intel.com>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, like.xu.linux@gmail.com,
        dapeng1.mi@linux.intel.com, zhiyuan.lv@intel.com,
        zhenyu.z.wang@intel.com, kan.liang@intel.com,
        Xiong Zhang <xiong.y.zhang@intel.com>
Subject: [PATCH v2 9/9] KVM: selftests: Add fixed counters enumeration test case
Date:   Thu, 21 Sep 2023 16:29:57 +0800
Message-Id: <20230921082957.44628-10-xiong.y.zhang@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230921082957.44628-1-xiong.y.zhang@intel.com>
References: <20230921082957.44628-1-xiong.y.zhang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vPMU v5 adds fixed counter enumeration, which allows user space to
specify which fixed counters are supported through emulated
CPUID.0Ah.ECX.

This commit adds a test case which specify the max fixed counter
supported only, so guest can access the max fixed counter only, #GP
exception will be happen once guest access other fixed counters.

Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
---
 .../selftests/kvm/x86_64/vmx_pmu_caps_test.c  | 79 +++++++++++++++++++
 1 file changed, 79 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
index ebbcb0a3f743..c690cb389ae2 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
@@ -18,6 +18,8 @@
 #include "kvm_util.h"
 #include "vmx.h"
 
+uint8_t fixed_counter_num;
+
 union perf_capabilities {
 	struct {
 		u64	lbr_format:6;
@@ -233,6 +235,81 @@ static void test_lbr_perf_capabilities(union perf_capabilities host_cap)
 	kvm_vm_free(vm);
 }
 
+static void guest_v5_code(void)
+{
+	uint8_t  vector, i;
+	uint64_t val;
+
+	for (i = 0; i < fixed_counter_num; i++) {
+		vector = rdmsr_safe(MSR_CORE_PERF_FIXED_CTR0 + i, &val);
+
+		/*
+		 * Only the max fixed counter is supported, #GP will be generated
+		 * when guest access other fixed counters.
+		 */
+		if (i == fixed_counter_num - 1)
+			__GUEST_ASSERT(vector != GP_VECTOR,
+				       "Max Fixed counter is accessible, but get #GP");
+		else
+			__GUEST_ASSERT(vector == GP_VECTOR,
+				       "Fixed counter isn't accessible, but access is ok");
+	}
+
+	GUEST_DONE();
+}
+
+#define PMU_NR_FIXED_COUNTERS_MASK  0x1f
+
+static void test_fixed_counter_enumeration(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	int r;
+	struct kvm_cpuid_entry2 *ent;
+	struct ucall uc;
+	uint32_t fixed_counter_bit_mask;
+
+	if (kvm_cpu_property(X86_PROPERTY_PMU_VERSION) < 5)
+		return;
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_v5_code);
+	vm_init_descriptor_tables(vm);
+	vcpu_init_descriptor_tables(vcpu);
+
+	ent = vcpu_get_cpuid_entry(vcpu, 0xa);
+	fixed_counter_num = ent->edx & PMU_NR_FIXED_COUNTERS_MASK;
+	TEST_ASSERT(fixed_counter_num > 0, "fixed counter isn't supported");
+	fixed_counter_bit_mask = (1ul << fixed_counter_num) - 1;
+	TEST_ASSERT(ent->ecx == fixed_counter_bit_mask,
+		    "cpuid.0xa.ecx != %x", fixed_counter_bit_mask);
+
+	if (fixed_counter_num == 1) {
+		kvm_vm_free(vm);
+		return;
+	}
+
+	/* Support the max Fixed Counter only */
+	ent->ecx = 1UL << (fixed_counter_num - 1);
+	ent->edx &= ~(u32)PMU_NR_FIXED_COUNTERS_MASK;
+
+	r = __vcpu_set_cpuid(vcpu);
+	TEST_ASSERT(!r, "Setting modified cpuid.0xa.ecx and edx failed");
+
+	vcpu_run(vcpu);
+
+	switch (get_ucall(vcpu, &uc)) {
+	case UCALL_ABORT:
+		REPORT_GUEST_ASSERT(uc);
+		break;
+	case UCALL_DONE:
+		break;
+	default:
+		TEST_FAIL("Unexpected ucall: %lu", uc.cmd);
+	}
+
+	kvm_vm_free(vm);
+}
+
 int main(int argc, char *argv[])
 {
 	union perf_capabilities host_cap;
@@ -253,4 +330,6 @@ int main(int argc, char *argv[])
 	test_immutable_perf_capabilities(host_cap);
 	test_guest_wrmsr_perf_capabilities(host_cap);
 	test_lbr_perf_capabilities(host_cap);
+
+	test_fixed_counter_enumeration();
 }
-- 
2.34.1

