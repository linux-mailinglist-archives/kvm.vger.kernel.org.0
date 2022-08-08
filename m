Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4E6758C532
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 10:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237003AbiHHI7B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Aug 2022 04:59:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236126AbiHHI6u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Aug 2022 04:58:50 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E69BB7C4
        for <kvm@vger.kernel.org>; Mon,  8 Aug 2022 01:58:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659949127; x=1691485127;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ceue2YJDmDhZEScBQcBpkjEmrLT+MBE2xOZ3HH6uSjQ=;
  b=PTOXKJjtwfJI+lCfM5BayKX6D16GwdKG0cLU/w9fYk1XWl8tJKIET+Qx
   XXAoInPubIrHGfCsuccngZ2JQ+6m0EN17aYXGB9yx1Hii9F3gOvmn+wwe
   WDujkIvH2aw9dHlX8CezVl39m1k8i40HpnJ+3Kj3GSG76CK0UROV8NwQf
   JPD1wSP6fd574GMjI7/L9lZ4vUyYEbDWdHd+HElcEmhwtZRF0sl1q59eV
   Fa+5vKgnx4e85vocAit1Di+XnQrCVq60mPZAJiDGqIvnp/XUl4tCSyoPt
   DBWW9ItGJyWXHUW43HHZ6kD/AFH6P2oPWOvHiV6futrO88HH77rzdNqBs
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10432"; a="376835081"
X-IronPort-AV: E=Sophos;i="5.93,221,1654585200"; 
   d="scan'208";a="376835081"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2022 01:58:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,221,1654585200"; 
   d="scan'208";a="931970628"
Received: from lxy-dell.sh.intel.com ([10.239.48.38])
  by fmsmga005.fm.intel.com with ESMTP; 08 Aug 2022 01:58:46 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: [PATCH v2 8/8] target/i386/intel-pt: Access MSR_IA32_RTIT_ADDRn based on guest CPUID configuration
Date:   Mon,  8 Aug 2022 16:58:34 +0800
Message-Id: <20220808085834.3227541-9-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220808085834.3227541-1-xiaoyao.li@intel.com>
References: <20220808085834.3227541-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM only allows userspace to access legal number of MSR_IA32_RTIT_ADDRn,
which is enumrated by guest's CPUID(0x14,0x1):EAX[2:0], i.e.,
env->features[FEAT_14_1_EAX] & INTEL_PT_ADDR_RANGES_NUM_MASK

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/cpu.h     | 2 ++
 target/i386/kvm/kvm.c | 8 ++++----
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 797f384e3fc4..34c59942b1fa 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -939,6 +939,8 @@ uint64_t x86_cpu_get_supported_feature_word(FeatureWord w,
 /* Packets which contain IP payload have LIP values */
 #define CPUID_14_0_ECX_LIP                      (1U << 31)
 
+#define INTEL_PT_ADDR_RANGES_NUM_MASK       0x7
+
 /* CLZERO instruction */
 #define CPUID_8000_0008_EBX_CLZERO      (1U << 0)
 /* Always save/restore FP error pointers */
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index f148a6d52fa4..613d843bf5a4 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -3365,8 +3365,8 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
             }
         }
         if (env->features[FEAT_7_0_EBX] & CPUID_7_0_EBX_INTEL_PT) {
-            int addr_num = kvm_arch_get_supported_cpuid(kvm_state,
-                                                    0x14, 1, R_EAX) & 0x7;
+            int addr_num = env->features[FEAT_14_1_EAX] &
+                           INTEL_PT_ADDR_RANGES_NUM_MASK;
 
             kvm_msr_entry_add(cpu, MSR_IA32_RTIT_CTL,
                             env->msr_rtit_ctrl);
@@ -3808,8 +3808,8 @@ static int kvm_get_msrs(X86CPU *cpu)
     }
 
     if (env->features[FEAT_7_0_EBX] & CPUID_7_0_EBX_INTEL_PT) {
-        int addr_num =
-            kvm_arch_get_supported_cpuid(kvm_state, 0x14, 1, R_EAX) & 0x7;
+        int addr_num = env->features[FEAT_14_1_EAX] &
+                       INTEL_PT_ADDR_RANGES_NUM_MASK;
 
         kvm_msr_entry_add(cpu, MSR_IA32_RTIT_CTL, 0);
         kvm_msr_entry_add(cpu, MSR_IA32_RTIT_STATUS, 0);
-- 
2.27.0

