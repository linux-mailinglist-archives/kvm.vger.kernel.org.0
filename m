Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1222B717A76
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 10:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234726AbjEaIpD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 04:45:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235070AbjEaIoi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 04:44:38 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C865610B
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 01:44:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685522666; x=1717058666;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KkICQLUL0N6wno1F6DhwOg202/VMAVLCyaivtde70OQ=;
  b=ICFXwmleUNZq8CFO/Hw5uV5e1xCKhPhWTlzi1Nj1745KsLIaMn8rZZo2
   TYYV0ljMp1TWMDzWM7qckMPK9HCRhudcTFmoyPfjeEvsz1dFeRQ4yQrn0
   VtKaPe/Vfen6bzPUfCmL7yaHYS0C0fYIrrw8LMUwCenfX5SEU7YS5ZDfX
   KRiltcb+mLpcpuKvfOkC0glYj0OpWlRso+mP73UyGhLK1fIHGuLHkU1dK
   Jedzai5n5Et119VdnJlTjj+3saWoBlYv3IUxq+DebpGEtWcQuAmIFpuhK
   rH/yZxkllvc1h7FjiMrf+uAkeZ0v1p6/269a49665+K5Q93FSvRbxtJ9z
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="418669325"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="418669325"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2023 01:43:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="1036956500"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="1036956500"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.46])
  by fmsmga005.fm.intel.com with ESMTP; 31 May 2023 01:43:30 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Chenyi Qiang <chenyi.qiang@intel.com>, lei4.wang@intel.com
Subject: [PATCH v4 8/8] target/i386/intel-pt: Access MSR_IA32_RTIT_ADDRn based on guest CPUID configuration
Date:   Wed, 31 May 2023 04:43:11 -0400
Message-Id: <20230531084311.3807277-9-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230531084311.3807277-1-xiaoyao.li@intel.com>
References: <20230531084311.3807277-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
index 71b83102b75e..d745ba2ad77a 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -973,6 +973,8 @@ uint64_t x86_cpu_get_supported_feature_word(FeatureWord w,
 /* Packets which contain IP payload have LIP values */
 #define CPUID_14_0_ECX_LIP                      (1U << 31)
 
+#define INTEL_PT_ADDR_RANGES_NUM_MASK       0x7
+
 /* CLZERO instruction */
 #define CPUID_8000_0008_EBX_CLZERO      (1U << 0)
 /* Always save/restore FP error pointers */
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index de531842f6b1..e68846100ddb 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -3561,8 +3561,8 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
             }
         }
         if (env->features[FEAT_7_0_EBX] & CPUID_7_0_EBX_INTEL_PT) {
-            int addr_num = kvm_arch_get_supported_cpuid(kvm_state,
-                                                    0x14, 1, R_EAX) & 0x7;
+            int addr_num = env->features[FEAT_14_1_EAX] &
+                           INTEL_PT_ADDR_RANGES_NUM_MASK;
 
             kvm_msr_entry_add(cpu, MSR_IA32_RTIT_CTL,
                             env->msr_rtit_ctrl);
@@ -4004,8 +4004,8 @@ static int kvm_get_msrs(X86CPU *cpu)
     }
 
     if (env->features[FEAT_7_0_EBX] & CPUID_7_0_EBX_INTEL_PT) {
-        int addr_num =
-            kvm_arch_get_supported_cpuid(kvm_state, 0x14, 1, R_EAX) & 0x7;
+        int addr_num = env->features[FEAT_14_1_EAX] &
+                       INTEL_PT_ADDR_RANGES_NUM_MASK;
 
         kvm_msr_entry_add(cpu, MSR_IA32_RTIT_CTL, 0);
         kvm_msr_entry_add(cpu, MSR_IA32_RTIT_STATUS, 0);
-- 
2.34.1

