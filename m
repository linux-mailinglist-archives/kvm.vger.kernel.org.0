Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE2C646913
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 07:25:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbiLHGZX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 01:25:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbiLHGZU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 01:25:20 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A389D2CF
        for <kvm@vger.kernel.org>; Wed,  7 Dec 2022 22:25:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670480719; x=1702016719;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ANSGjufLLPoRfF/om6K+WGEXxzVfJiLQYuBjX7wdEwA=;
  b=csC+28siBumV0S/XQMgFCGhpbeOSP15t6n+yO8OfVK7b5eTQNc1VTFrJ
   VKiz4zqVCEr7RhkAxPRa2tRadUWbWqidWHN0V9rBmme1mk3PTu8NdmPI5
   8UnJ0XEU6z0BB4axnQvmsyeyj75WHeRDlZYDr+d5iBmVLWHGj2DES8MoE
   Ep7g/eY/9/tuyoszraPzeoM4Qn1FA6zwE9dLO5pJGf1NB41AK0Edj17W+
   iW09p1dtiVqijPboJpjEsjsBFDwrhGwYR2Gxb0tPCB4FcNevaKifyjT24
   XZGsGOGpyh2ScAk4wxUmT30YNkUlH59Ce6I5uHJAjjFQ6f9mNVzyTXcCv
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="297444455"
X-IronPort-AV: E=Sophos;i="5.96,226,1665471600"; 
   d="scan'208";a="297444455"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 22:25:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="679413394"
X-IronPort-AV: E=Sophos;i="5.96,227,1665471600"; 
   d="scan'208";a="679413394"
Received: from lxy-dell.sh.intel.com ([10.239.48.100])
  by orsmga001.jf.intel.com with ESMTP; 07 Dec 2022 22:25:17 -0800
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, xiaoyao.li@intel.com
Subject: [PATCH v3 2/8] target/i386/intel-pt: Fix INTEL_PT_ADDR_RANGES_NUM_MASK
Date:   Thu,  8 Dec 2022 14:25:07 +0800
Message-Id: <20221208062513.2589476-3-xiaoyao.li@intel.com>
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

Per Intel SDM, bits 2:0 of CPUID(0x14,0x1).EAX indicate the number of
address ranges for INTEL-PT.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/cpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 8d95202f6a42..9ae36639d380 100644
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

