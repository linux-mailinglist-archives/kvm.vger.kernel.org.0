Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4024D717A63
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 10:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234905AbjEaIna (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 04:43:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234934AbjEaIn2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 04:43:28 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51A3213D
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 01:43:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685522605; x=1717058605;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=COnzqPMSLYOBORO/c5DfjIidhTqe6fjVzZt1QcuYJos=;
  b=dsRZnDcxoOSNprbdHwyqWe2kbZeImuog+McN+MH1iYc7Jvs9mAm68zaD
   1/FMAawH5eS0/PAUJTQlzpyN3VTtX0BjLuS/VcRoHt4sufQtT0uoSRJpS
   Vx29SF++RMQ13ilfmJoTUEfTBjUC32N43cdZmsg0RTxoWac0tY21T1JdL
   kE5NC130pYKHAuo0PjdA+5t6HUQo4Fp+Y60ijmSaDwJGHjpQBQYNzG1mT
   OEKvBs322hEXFLV3o+sM2MhU+D9vJr2HqXZr+3+UmIaFfHwqBv5HcgF0F
   YP72dXc9ico8QsjyZ9PLX0iNaznC2i9HR8EGIj6Aqf1lx7z5Hf7uYmMsU
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="418669277"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="418669277"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2023 01:43:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="1036956432"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="1036956432"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.46])
  by fmsmga005.fm.intel.com with ESMTP; 31 May 2023 01:43:22 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Chenyi Qiang <chenyi.qiang@intel.com>, lei4.wang@intel.com
Subject: [PATCH v4 4/8] target/i386/intel-pt: print special message for INTEL_PT_ADDR_RANGES_NUM
Date:   Wed, 31 May 2023 04:43:07 -0400
Message-Id: <20230531084311.3807277-5-xiaoyao.li@intel.com>
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

Bit[2:0] of CPUID.14H_01H:EAX stands as a whole for the number of INTEL
PT ADDR RANGES. For unsupported value that exceeds what KVM reports,
report it as a whole in mark_unavailable_features() as well.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/cpu.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index e735c366bc97..03471efee66b 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -4888,7 +4888,14 @@ static void mark_unavailable_features(X86CPU *cpu, FeatureWord w, uint64_t mask,
         return;
     }
 
-    for (i = 0; i < 64; ++i) {
+    if ((w == FEAT_14_1_EAX) && (mask & INTEL_PT_ADDR_RANGES_NUM_MASK)) {
+        warn_report("%s: CPUID.14H_01H:EAX [bit 2:0]", verbose_prefix);
+        i = 3;
+    } else {
+        i = 0;
+    }
+
+    for (; i < 64; ++i) {
         if ((1ULL << i) & mask) {
             g_autofree char *feat_word_str = feature_word_description(f, i);
             warn_report("%s: %s%s%s [bit %d]",
-- 
2.34.1

