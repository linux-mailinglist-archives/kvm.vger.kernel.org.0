Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7402264691A
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 07:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbiLHGZg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 01:25:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbiLHGZa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 01:25:30 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 608AA9E464
        for <kvm@vger.kernel.org>; Wed,  7 Dec 2022 22:25:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670480730; x=1702016730;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mwOPmVUdqlyMI1uNhdPsAC6RlBHQAAuU0mt1mEWLh28=;
  b=W7t2+BTfJlQvVBTS4N5uKipLgvaEMyREYQqYCht/trbrVoYOdDVS/ydl
   6wBWJrYBFzE+im1A/HnwTcwdif8Kk4dL8N2ki9FiJZhnmJviS4NpXXqg2
   wm+mN+xkqdMjDBOdh7gv0ehTBmskEqPrhOdSgoNkHHnN18+Te3RjUzqX1
   Vro5/pM4DYFJk1jobumEc07LmZI99zULMvIAngwmPXOJTAdb+oHTRISpl
   mzO+9jGTEigNElPwofovGmeGAe6SsLOCU9f95Yd6vz8wVc43TgvPGSQ8s
   Vy+zIM2PFY42Ohg4oM3yxB/9tGgCVyDkYzILGLLUVhU6tCjy+KYzuezRa
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="297444516"
X-IronPort-AV: E=Sophos;i="5.96,226,1665471600"; 
   d="scan'208";a="297444516"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 22:25:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="679413441"
X-IronPort-AV: E=Sophos;i="5.96,227,1665471600"; 
   d="scan'208";a="679413441"
Received: from lxy-dell.sh.intel.com ([10.239.48.100])
  by orsmga001.jf.intel.com with ESMTP; 07 Dec 2022 22:25:28 -0800
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, xiaoyao.li@intel.com
Subject: [PATCH v3 8/8] target/i386/intel-pt: Access MSR_IA32_RTIT_ADDRn based on guest CPUID configuration
Date:   Thu,  8 Dec 2022 14:25:13 +0800
Message-Id: <20221208062513.2589476-9-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20221208062513.2589476-1-xiaoyao.li@intel.com>
References: <20221208062513.2589476-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
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
index 91a3971c1c29..1156813ed0ad 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -941,6 +941,8 @@ uint64_t x86_cpu_get_supported_feature_word(FeatureWord w,
 /* Packets which contain IP payload have LIP values */
 #define CPUID_14_0_ECX_LIP                      (1U << 31)
 
+#define INTEL_PT_ADDR_RANGES_NUM_MASK       0x7
+
 /* CLZERO instruction */
 #define CPUID_8000_0008_EBX_CLZERO      (1U << 0)
 /* Always save/restore FP error pointers */
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index a21320937943..e06a25f5e3ee 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -3446,8 +3446,8 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
             }
         }
         if (env->features[FEAT_7_0_EBX] & CPUID_7_0_EBX_INTEL_PT) {
-            int addr_num = kvm_arch_get_supported_cpuid(kvm_state,
-                                                    0x14, 1, R_EAX) & 0x7;
+            int addr_num = env->features[FEAT_14_1_EAX] &
+                           INTEL_PT_ADDR_RANGES_NUM_MASK;
 
             kvm_msr_entry_add(cpu, MSR_IA32_RTIT_CTL,
                             env->msr_rtit_ctrl);
@@ -3889,8 +3889,8 @@ static int kvm_get_msrs(X86CPU *cpu)
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

