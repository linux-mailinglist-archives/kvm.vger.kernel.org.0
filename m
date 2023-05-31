Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58099717A61
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 10:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234925AbjEaIn1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 04:43:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbjEaInW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 04:43:22 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35251E6
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 01:43:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685522601; x=1717058601;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PUiPWRxoJu35zk6JisuELImdtxTwEvzqb0+TEiNmcuc=;
  b=Qnx4mj5yheDZvJH0FyG0+Yc5Tl+fOEDh5Ic8bnMJWBxG7pRk3MPZkPQV
   uIgBZeqkobKJrvRMO/hO1U65W15cvLiAF+szsuHPT+o91fonzPknVc+/l
   B8jito2PqW0QUtEmWzjS+rXiaIeFacn6KKimQqCTAHOikkz28jIQOJZdr
   FKu21bwIO+Kt9Q6Xa5rLiH3GYI/misdphRe4Or9E4ehn0blZq6Q99wpkn
   4aAWPbR2881MSyJ0kIyskh3u7rvbOLBhWWQPLz7y89kb5bekgmHrAxZ/2
   gAOSwnzAiz2wvl5TIfEnhjO5hmcC+BUzHdHUxhZbxDCTg1eIkof7M6SIy
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="418669251"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="418669251"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2023 01:43:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="1036956407"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="1036956407"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.46])
  by fmsmga005.fm.intel.com with ESMTP; 31 May 2023 01:43:19 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Chenyi Qiang <chenyi.qiang@intel.com>, lei4.wang@intel.com
Subject: [PATCH v4 2/8] target/i386/intel-pt: Fix INTEL_PT_ADDR_RANGES_NUM_MASK
Date:   Wed, 31 May 2023 04:43:05 -0400
Message-Id: <20230531084311.3807277-3-xiaoyao.li@intel.com>
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

Per Intel SDM, bits 2:0 of CPUID(0x14,0x1).EAX indicate the number of
address ranges for INTEL-PT.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/cpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 88e90c1f7b7c..7d2f20c84c7a 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -573,7 +573,7 @@ static CPUCacheInfo legacy_l3_cache = {
 /* generated packets which contain IP payloads have LIP values */
 #define INTEL_PT_IP_LIP          (1 << 31)
 #define INTEL_PT_ADDR_RANGES_NUM 0x2 /* Number of configurable address ranges */
-#define INTEL_PT_ADDR_RANGES_NUM_MASK 0x3
+#define INTEL_PT_ADDR_RANGES_NUM_MASK 0x7
 #define INTEL_PT_MTC_BITMAP      (0x0249 << 16) /* Support ART(0,3,6,9) */
 #define INTEL_PT_CYCLE_BITMAP    0x1fff         /* Support 0,2^(0~11) */
 #define INTEL_PT_PSB_BITMAP      (0x003f << 16) /* Support 2K,4K,8K,16K,32K,64K */
-- 
2.34.1

