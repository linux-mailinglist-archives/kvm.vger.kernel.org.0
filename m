Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3311E646915
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 07:25:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbiLHGZZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 01:25:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbiLHGZX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 01:25:23 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15FF89E445
        for <kvm@vger.kernel.org>; Wed,  7 Dec 2022 22:25:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670480723; x=1702016723;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=P1e98jpmiSmmJIjh1aftNejYNigw3c/QIJS1mkpRlYQ=;
  b=boe34L7w4wXEKf41l0/Y3AVWsmoKFc8x9tgFxGZ/sxQF01QSaztxxcHy
   Gfd9/W0UVgWV7+bkd1PgVHgw1jicdY8Du8Tp2T0xeIeFpShQzcXDRhaRn
   Cc0bYpp0acD9XSNy8IDjTiNlgr0z/oPwOSwed5yksGKR3PMCx6hjWZV/5
   n6T452wW2nj/ITJP7PRL53i0iApTVV57KduwZSJwz2WVE6ayQsLbpg8FO
   mkD0XAu9Ww/XJA46QzjwyuMoyI9azDlchKDeXvCxjFGjbYdbNRIdbnOVs
   OLtaoY1FJN2eVAY0nLQo/GDnbf3eWQhMHN4c2wKbr67BMbj4yuoDll2Oa
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="297444467"
X-IronPort-AV: E=Sophos;i="5.96,226,1665471600"; 
   d="scan'208";a="297444467"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 22:25:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="679413412"
X-IronPort-AV: E=Sophos;i="5.96,227,1665471600"; 
   d="scan'208";a="679413412"
Received: from lxy-dell.sh.intel.com ([10.239.48.100])
  by orsmga001.jf.intel.com with ESMTP; 07 Dec 2022 22:25:21 -0800
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, xiaoyao.li@intel.com
Subject: [PATCH v3 4/8] target/i386/intel-pt: print special message for INTEL_PT_ADDR_RANGES_NUM
Date:   Thu,  8 Dec 2022 14:25:09 +0800
Message-Id: <20221208062513.2589476-5-xiaoyao.li@intel.com>
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

Bit[2:0] of CPUID.14H_01H:EAX stands as a whole for the number of INTEL
PT ADDR RANGES. For unsupported value that exceeds what KVM reports,
report it as a whole in mark_unavailable_features() as well.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/cpu.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 65c6f8ae771a..4d7beccc0af7 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -4387,7 +4387,14 @@ static void mark_unavailable_features(X86CPU *cpu, FeatureWord w, uint64_t mask,
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
2.27.0

