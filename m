Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92BE158C52D
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 10:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241975AbiHHI6x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Aug 2022 04:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241537AbiHHI6r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Aug 2022 04:58:47 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C07E13EAC
        for <kvm@vger.kernel.org>; Mon,  8 Aug 2022 01:58:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659949119; x=1691485119;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JoLhHDUQ0buGQR/L9NPQ9wh0/PiW8CiBoeswGZy+EaE=;
  b=TD7LfWKCHfY1iybeGPJb5O/3vGwREBn7A78NOLyxLkMYKHII25r9LMEz
   7IqUKJE5tulMODPerA/SLXvVZe5jxy2ACsUn8xuXvYNmRE4Rc9XUKPLWJ
   vS/xokrTbcH7RhbBcoDpTm9Hki0Tw5QAGNyRJbL7CizP4n/7iboWRlEh3
   /ECt1/XB6OV4CQ6TSGR6ge/i/y0ixhYx4QvzVG9Zv6h21r/ajMh3eurLN
   PDPVk+BV+EJFBSIjwb+xdTtFJOWMRbpHfyfKH4eXhtLI0AhVoQgX88h6W
   Ur7ke2VWHLADUCv71usFz+FGXrQKTR8j2jfYsq/H7TQyet/8i5H3Sc7Xd
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10432"; a="376835051"
X-IronPort-AV: E=Sophos;i="5.93,221,1654585200"; 
   d="scan'208";a="376835051"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2022 01:58:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,221,1654585200"; 
   d="scan'208";a="931970551"
Received: from lxy-dell.sh.intel.com ([10.239.48.38])
  by fmsmga005.fm.intel.com with ESMTP; 08 Aug 2022 01:58:37 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: [PATCH v2 2/8] target/i386/intel-pt: Fix INTEL_PT_ADDR_RANGES_NUM_MASK
Date:   Mon,  8 Aug 2022 16:58:28 +0800
Message-Id: <20220808085834.3227541-3-xiaoyao.li@intel.com>
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

Per Intel SDM, bits 2:0 of CPUID(0x14,0x1).EAX indicate the number of
address ranges for INTEL-PT.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/cpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index f9646e16b872..fa02910ce811 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -570,7 +570,7 @@ static CPUCacheInfo legacy_l3_cache = {
 /* generated packets which contain IP payloads have LIP values */
 #define INTEL_PT_IP_LIP          (1 << 31)
 #define INTEL_PT_ADDR_RANGES_NUM 0x2 /* Number of configurable address ranges */
-#define INTEL_PT_ADDR_RANGES_NUM_MASK 0x3
+#define INTEL_PT_ADDR_RANGES_NUM_MASK 0x7
 #define INTEL_PT_MTC_BITMAP      (0x0249 << 16) /* Support ART(0,3,6,9) */
 #define INTEL_PT_CYCLE_BITMAP    0x1fff         /* Support 0,2^(0~11) */
 #define INTEL_PT_PSB_BITMAP      (0x003f << 16) /* Support 2K,4K,8K,16K,32K,64K */
-- 
2.27.0

