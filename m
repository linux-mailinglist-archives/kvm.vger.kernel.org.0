Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB4E775B113
	for <lists+kvm@lfdr.de>; Thu, 20 Jul 2023 16:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232159AbjGTOTy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jul 2023 10:19:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232132AbjGTOTu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jul 2023 10:19:50 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE192130
        for <kvm@vger.kernel.org>; Thu, 20 Jul 2023 07:19:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689862789; x=1721398789;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=buXmaIF8bsSZQ+khArpLQjEisj2O6Xke+QF4SVMpF2M=;
  b=OggMF+Z1+ha9mVOSzYvdvxXvF0lseUrvIOgYxhh/JzG6gRBES+FGWApN
   t0D/krOvzXmLkHlT019TcAsfR4UmYhIS5XtOqALSFanLNInHKSoJko+jz
   BKgfDL2n7feCB50vMj0oaJccXmLdE+KVdTWTWaCYNx1+yUbGPJGvGlmd9
   vasoO7R/1CvfrW5UmGEr1Rnce9TwppCjdGIJKWUSOFNmksV63+RiMVmB1
   X2TGbly7mST/25uDC6h5BHsgZA8PipS6b3HHOzR0vT/pX9XL6W11khkIn
   4cJ4Tmw5xf1SVQ+9qWieEycoIPKztX+uN/eWU8drvgR/hA8HoMkbnG89U
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="397629177"
X-IronPort-AV: E=Sophos;i="6.01,219,1684825200"; 
   d="scan'208";a="397629177"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 07:19:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="898295625"
X-IronPort-AV: E=Sophos;i="6.01,219,1684825200"; 
   d="scan'208";a="898295625"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 07:19:29 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, mtosatti@redhat.com, seanjc@google.com,
        qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, weijiang.yang@intel.com
Subject: [PATCH v2 3/4] target/i386: Add CET states to vmstate
Date:   Thu, 20 Jul 2023 07:14:44 -0400
Message-Id: <20230720111445.99509-4-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230720111445.99509-1-weijiang.yang@intel.com>
References: <20230720111445.99509-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add CET states in vmstate if the feature is enabled.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 target/i386/machine.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/target/i386/machine.c b/target/i386/machine.c
index c7ac8084b2..6d42f6dc7e 100644
--- a/target/i386/machine.c
+++ b/target/i386/machine.c
@@ -1586,6 +1586,33 @@ static const VMStateDescription vmstate_arch_lbr = {
     }
 };
 
+static bool cet_needed(void *opaque)
+{
+    X86CPU *cpu = opaque;
+    CPUX86State *env = &cpu->env;
+
+    return !!((env->features[FEAT_7_0_ECX] & CPUID_7_0_ECX_CET_SHSTK) ||
+              (env->features[FEAT_7_0_EDX] & CPUID_7_0_EDX_CET_IBT));
+}
+
+static const VMStateDescription vmstate_cet = {
+    .name = "cpu/cet",
+    .version_id = 1,
+    .minimum_version_id = 1,
+    .needed = cet_needed,
+    .fields = (VMStateField[]) {
+        VMSTATE_UINT64(env.u_cet, X86CPU),
+        VMSTATE_UINT64(env.s_cet, X86CPU),
+        VMSTATE_UINT64(env.guest_ssp, X86CPU),
+        VMSTATE_UINT64(env.pl0_ssp, X86CPU),
+        VMSTATE_UINT64(env.pl1_ssp, X86CPU),
+        VMSTATE_UINT64(env.pl2_ssp, X86CPU),
+        VMSTATE_UINT64(env.pl3_ssp, X86CPU),
+        VMSTATE_UINT64(env.ssp_table_addr, X86CPU),
+        VMSTATE_END_OF_LIST()
+    }
+};
+
 static bool triple_fault_needed(void *opaque)
 {
     X86CPU *cpu = opaque;
@@ -1745,6 +1772,7 @@ const VMStateDescription vmstate_x86_cpu = {
         &vmstate_msr_tsx_ctrl,
         &vmstate_msr_intel_sgx,
         &vmstate_pdptrs,
+        &vmstate_cet,
         &vmstate_msr_xfd,
 #ifdef TARGET_X86_64
         &vmstate_amx_xtile,
-- 
2.27.0

