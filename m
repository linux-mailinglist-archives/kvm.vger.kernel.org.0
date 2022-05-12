Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2DBC524809
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 10:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351550AbiELIlW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 04:41:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351556AbiELIlI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 04:41:08 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31C8031515;
        Thu, 12 May 2022 01:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652344866; x=1683880866;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=YB368LqUg4BrgfUK4oJ4xxCcsWnby6dXQHX9fMaGRUw=;
  b=RtF2V6dNaCleVazNXT7kT5gHDjY2h7qy97MzFOjzRMoCV5K1FY8rts4t
   PRm+o6D99spz+5RNIga01WAJzpqEKgLYLDAg2bGEEKXjdrfRUM8G0q1FM
   OxCekgSrw5JlR5PHzF2N+CnTo98lNU6m9wQlgmuuZn4Jm9EVySMbeqYy/
   Ravho2BF9o7UlEhlrRcU2N137zsVMS1H0jjLqpHl6LcDEeeRIy2sWzSky
   hyj88jItqB5gWoeGogP20FHQ8hCDifz5ZBDJ932WDhrUZuDdHjDnFmtUV
   OUrQ5DRB3rrJ+USItcgC5qkg/j0Vm8qbjqQEMX2aeihHxBLhyy1l0YF+Y
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10344"; a="249831643"
X-IronPort-AV: E=Sophos;i="5.91,219,1647327600"; 
   d="scan'208";a="249831643"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2022 01:41:05 -0700
X-IronPort-AV: E=Sophos;i="5.91,219,1647327600"; 
   d="scan'208";a="542683032"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2022 01:41:05 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, likexu@tencent.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v2] KVM: selftests: x86: Fix test failure on arch lbr capable platforms
Date:   Thu, 12 May 2022 04:40:46 -0400
Message-Id: <20220512084046.105479-1-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Arch LBR capable platforms, LBR_FMT in perf capability msr is 0x3f,
so the last format test will fail. Use a true invalid format(0x30) for
the test if it's running on these platforms. Opportunistically change
the file name to reflect the tests actually carried out.

v2:
Select a true invalid format instead of skipping the test on arch lbr
capable platforms.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 tools/testing/selftests/kvm/Makefile           |  2 +-
 ...vmx_pmu_msrs_test.c => vmx_pmu_caps_test.c} | 18 ++++++++++--------
 2 files changed, 11 insertions(+), 9 deletions(-)
 rename tools/testing/selftests/kvm/x86_64/{vmx_pmu_msrs_test.c => vmx_pmu_caps_test.c} (83%)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 681b173aa87c..9a1a84803b01 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -81,7 +81,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/xapic_state_test
 TEST_GEN_PROGS_x86_64 += x86_64/xss_msr_test
 TEST_GEN_PROGS_x86_64 += x86_64/debug_regs
 TEST_GEN_PROGS_x86_64 += x86_64/tsc_msrs_test
-TEST_GEN_PROGS_x86_64 += x86_64/vmx_pmu_msrs_test
+TEST_GEN_PROGS_x86_64 += x86_64/vmx_pmu_caps_test
 TEST_GEN_PROGS_x86_64 += x86_64/xen_shinfo_test
 TEST_GEN_PROGS_x86_64 += x86_64/xen_vmcall_test
 TEST_GEN_PROGS_x86_64 += x86_64/sev_migrate_tests
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_pmu_msrs_test.c b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
similarity index 83%
rename from tools/testing/selftests/kvm/x86_64/vmx_pmu_msrs_test.c
rename to tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
index 2454a1f2ca0c..97b7fd4a9a3d 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_pmu_msrs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
@@ -1,15 +1,14 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * VMX-pmu related msrs test
+ * Test for VMX-pmu perf capability msr
  *
  * Copyright (C) 2021 Intel Corporation
  *
- * Test to check the effect of various CPUID settings
- * on the MSR_IA32_PERF_CAPABILITIES MSR, and check that
- * whatever we write with KVM_SET_MSR is _not_ modified
- * in the guest and test it can be retrieved with KVM_GET_MSR.
- *
- * Test to check that invalid LBR formats are rejected.
+ * Test to check the effect of various CPUID settings on
+ * MSR_IA32_PERF_CAPABILITIES MSR, and check that what
+ * we write with KVM_SET_MSR is _not_ modified by the guest
+ * and check it can be retrieved with KVM_GET_MSR, also test
+ * the invalid LBR formats are rejected.
  */
 
 #define _GNU_SOURCE /* for program_invocation_short_name */
@@ -107,8 +106,11 @@ int main(int argc, char *argv[])
 	ASSERT_EQ(vcpu_get_msr(vm, VCPU_ID, MSR_IA32_PERF_CAPABILITIES), (u64)host_cap.lbr_format);
 
 	/* testcase 3, check invalid LBR format is rejected */
-	ret = _vcpu_set_msr(vm, 0, MSR_IA32_PERF_CAPABILITIES, PMU_CAP_LBR_FMT);
+	/* Note, on Arch LBR capable platforms, LBR_FMT in perf capability msr is 0x3f,
+	 * to avoid the failure, use a true invalid format 0x30 for the test. */
+	ret = _vcpu_set_msr(vm, 0, MSR_IA32_PERF_CAPABILITIES, 0x30);
 	TEST_ASSERT(ret == 0, "Bad PERF_CAPABILITIES didn't fail.");
 
+	printf("Completed perf capability tests.\n");
 	kvm_vm_free(vm);
 }

base-commit: 672c0c5173427e6b3e2a9bbb7be51ceeec78093a
-- 
2.27.0

