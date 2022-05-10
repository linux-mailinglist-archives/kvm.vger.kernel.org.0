Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05802520C71
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 05:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234254AbiEJDyv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 23:54:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231679AbiEJDyu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 23:54:50 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67C1825EE;
        Mon,  9 May 2022 20:50:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652154649; x=1683690649;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=nbv7UmfdXbcrW16GgE7aK/oiYQcXbQEJkwqMj9eP0Gk=;
  b=VN66fcUAuPw9/X30HQc+PRR5L9T5PszsN4qaW3da7zwQSGb/mRJCwDbH
   1S7kuTEbKa5ynqqt4eEjIALDqO33K8I+oBHgPQrmajVCyV5jpfVqXNR44
   AY/jAVx/IPJuOgarMjxZpJguUVUgznfJI+c2yVK+ghHIWw/ketP7neKVS
   zvlBZrfpoAlq4Niua/fSrLSKC+wBjsAN6lmaM1VYllS1Q8wGZUqWoZA99
   Z0zf16LOWYE3azd8lGtUfR8ybfNJNoSdyn/GPEGXuCbRGGss26WEjPSr5
   WXeJzQWl+8gOaIT5sc912Idq4lim2GcD2VfDSn8SVZ53b56F//mCl+xqY
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10342"; a="266837547"
X-IronPort-AV: E=Sophos;i="5.91,213,1647327600"; 
   d="scan'208";a="266837547"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2022 20:50:49 -0700
X-IronPort-AV: E=Sophos;i="5.91,213,1647327600"; 
   d="scan'208";a="602270857"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2022 20:50:48 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com
Cc:     likexu@tencent.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH] KVM: selftests: x86: Skip unsupported test when Arch LBR is available
Date:   Mon,  9 May 2022 23:50:28 -0400
Message-Id: <20220510035028.21042-1-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Arch LBR capable platforms, LBR_FMT in perf capability msr is 0x3f,
so skip invalid format test if it's running on these platforms.
Opportunistically change the file name to reflect the tests actually
carried out.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 tools/testing/selftests/kvm/Makefile                     | 2 +-
 .../x86_64/{vmx_pmu_msrs_test.c => vmx_pmu_caps_test.c}  | 9 +++++++--
 2 files changed, 8 insertions(+), 3 deletions(-)
 rename tools/testing/selftests/kvm/x86_64/{vmx_pmu_msrs_test.c => vmx_pmu_caps_test.c} (88%)

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
similarity index 88%
rename from tools/testing/selftests/kvm/x86_64/vmx_pmu_msrs_test.c
rename to tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
index 2454a1f2ca0c..977c268a6ad4 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_pmu_msrs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
@@ -107,8 +107,13 @@ int main(int argc, char *argv[])
 	ASSERT_EQ(vcpu_get_msr(vm, VCPU_ID, MSR_IA32_PERF_CAPABILITIES), (u64)host_cap.lbr_format);
 
 	/* testcase 3, check invalid LBR format is rejected */
-	ret = _vcpu_set_msr(vm, 0, MSR_IA32_PERF_CAPABILITIES, PMU_CAP_LBR_FMT);
-	TEST_ASSERT(ret == 0, "Bad PERF_CAPABILITIES didn't fail.");
+	/* Note, on Arch LBR capable platforms, LBR_FMT in perf capability msr is 0x3f,
+	 * so skip below test if running on these platforms. */
+	if (host_cap.lbr_format != PMU_CAP_LBR_FMT) {
+		ret = _vcpu_set_msr(vm, 0, MSR_IA32_PERF_CAPABILITIES, PMU_CAP_LBR_FMT);
+		TEST_ASSERT(ret == 0, "Bad PERF_CAPABILITIES didn't fail.");
+	}
 
+	printf("Completed pmu capability tests successfully.\n");
 	kvm_vm_free(vm);
 }
-- 
2.27.0

