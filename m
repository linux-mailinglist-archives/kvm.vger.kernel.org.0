Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14BC47BF60E
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 10:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442923AbjJJIfm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 04:35:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442897AbjJJIfg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 04:35:36 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 990BA9F;
        Tue, 10 Oct 2023 01:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696926934; x=1728462934;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XRUCF/P5uKgDye69B2VNPFxzhkCFQCyWEdXoWuKd6KA=;
  b=A/4c6uBGxvJpTwMiDq1ASuH8uLoKBG+XDxMXAxfMBWGDeGTZaKoxzNIs
   ifRhrWEMMoK+vYRC8eF5bFd95nEz5SXoozqeq2nMmGDsxOmPpWTVS5jk1
   3aIO1eF+XBUMYs6X3Qn5t4Hhj6ePD55RajVLCJepyVOOpCzg2Xf8N5SzO
   to2Dy8lz7ErcEIUUfrxD0ng8upzQkgLamx1PxmMdo3+hgTt3IAwup1ymn
   md5dCoBvd7DaLqxAcczdc6a24mWidEEF8Hwmrq1mDp7SuD/rmeBbFiLsQ
   MCU50FbCHgoR3aucDeyo2zpus4sgsLn8nQxnCdR7IlTIK4F62nUMRGtgI
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10858"; a="387176588"
X-IronPort-AV: E=Sophos;i="6.03,212,1694761200"; 
   d="scan'208";a="387176588"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2023 01:35:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10858"; a="730001327"
X-IronPort-AV: E=Sophos;i="6.03,212,1694761200"; 
   d="scan'208";a="730001327"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2023 01:35:32 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Michael Roth <michael.roth@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-coco@lists.linux.dev, Chao Peng <chao.p.peng@linux.intel.com>
Subject: [PATCH 01/12] x86/mce: Fix hw MCE injection feature detection
Date:   Tue, 10 Oct 2023 01:35:09 -0700
Message-Id: <23c6fa20777498bccd486aedc435eef9af174748.1696926843.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1696926843.git.isaku.yamahata@intel.com>
References: <cover.1696926843.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

When initializing x86 MCE injection framework, it checks if hardware mce
injection is available or not.  When it's not available on AMD, set the
boolean variable to false to not use it.  The variable is on by default and
the feature is AMD specific based on the code.

Because the variable is default on, it is true on Intel platform (probably
on other non-AMD x86 platform).  It results in unchecked msr access of
MSR_K7_HWCR=0xc0010015 when injecting MCE on Intel platform.  (Probably on
other x86 platform.)

Make the variable of by default, and set the variable on when the hardware
feature is usable.

The procedure to produce on Intel platform.
  echo hw > /sys/kernel/debug/mce-inject/flags
    This succeeds.
    set other MCE parameters if necessary.
  echo 0 > /sys/kernel/debug/mce-inject/bank
    This triggers mce injection.

The kernel accesses MSR_K7_HWCR=0xc0010015 resulting unchecked MSR access.

Fixes: 891e465a1bd8 ("x86/mce: Check whether writes to MCA_STATUS are getting ignored")
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kernel/cpu/mce/inject.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/mce/inject.c b/arch/x86/kernel/cpu/mce/inject.c
index 4d8d4bcf915d..881898a1d2f4 100644
--- a/arch/x86/kernel/cpu/mce/inject.c
+++ b/arch/x86/kernel/cpu/mce/inject.c
@@ -33,7 +33,7 @@
 
 #include "internal.h"
 
-static bool hw_injection_possible = true;
+static bool hw_injection_possible;
 
 /*
  * Collect all the MCi_XXX settings
@@ -732,6 +732,7 @@ static void check_hw_inj_possible(void)
 	if (!cpu_feature_enabled(X86_FEATURE_SMCA))
 		return;
 
+	hw_injection_possible = true;
 	cpu = get_cpu();
 
 	for (bank = 0; bank < MAX_NR_BANKS; ++bank) {
-- 
2.25.1

