Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9944B8369
	for <lists+kvm@lfdr.de>; Wed, 16 Feb 2022 09:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231812AbiBPIyY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Feb 2022 03:54:24 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:48790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231797AbiBPIyU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Feb 2022 03:54:20 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DB6F2ABD10
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 00:54:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645001648; x=1676537648;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=o84uKWKMQfEn4ExBF+qBe2pAQYKLeDqkmI267vu6PGw=;
  b=hSRiKkEuQ7qiZveoMr7DOZybY3hCUwvtTV4YDzC2dTWYPdEZltUqJmeX
   NCzb/VgpOegsCf9z92yhVSKNwQmQMQUU9mOb2XMRGU8fMr6D4GNonq1uc
   Na9bO38i2w27jBxMlRdbOEjYos/giy7gCwrAUA70AbirIUtnt1r89AXjp
   o24QPWh8MUPincwq5u2YSyobXlBsyyTymHi6IKaAW1bYqyDW/WpDKmk1y
   ImauSSX0JJVm9uh7wQ/OpK1UIqqm6vCS5OoK8tOmP1TXGR532xqekV3nI
   EeQm207jSnA6+KOX8tcNfifVkkfwJP+Fvf/PcNqg2xIg3+k2gGhpQG9F/
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10259"; a="275135812"
X-IronPort-AV: E=Sophos;i="5.88,373,1635231600"; 
   d="scan'208";a="275135812"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2022 00:54:07 -0800
X-IronPort-AV: E=Sophos;i="5.88,373,1635231600"; 
   d="scan'208";a="633418293"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2022 00:54:07 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, ehabkost@redhat.com, mtosatti@redhat.com,
        seanjc@google.com, richard.henderson@linaro.org,
        like.xu.linux@gmail.com, wei.w.wang@intel.com,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH 7/8] target/i386: Enable Arch LBR migration states in vmstate
Date:   Tue, 15 Feb 2022 14:52:57 -0500
Message-Id: <20220215195258.29149-8-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220215195258.29149-1-weijiang.yang@intel.com>
References: <20220215195258.29149-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DATE_IN_PAST_12_24,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The Arch LBR record MSRs and control MSRs will be migrated
to destination guest if the vcpus were running with Arch
LBR active.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 target/i386/machine.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/target/i386/machine.c b/target/i386/machine.c
index 1f9d0c46f1..08db7d3629 100644
--- a/target/i386/machine.c
+++ b/target/i386/machine.c
@@ -136,6 +136,22 @@ static const VMStateDescription vmstate_mtrr_var = {
 #define VMSTATE_MTRR_VARS(_field, _state, _n, _v)                    \
     VMSTATE_STRUCT_ARRAY(_field, _state, _n, _v, vmstate_mtrr_var, MTRRVar)
 
+static const VMStateDescription vmstate_lbr_records_var = {
+    .name = "lbr_records_var",
+    .version_id = 1,
+    .minimum_version_id = 1,
+    .fields = (VMStateField[]) {
+        VMSTATE_UINT64(from, LBR_ENTRY),
+        VMSTATE_UINT64(to, LBR_ENTRY),
+        VMSTATE_UINT64(info, LBR_ENTRY),
+        VMSTATE_END_OF_LIST()
+    }
+};
+
+#define VMSTATE_LBR_VARS(_field, _state, _n, _v)                    \
+    VMSTATE_STRUCT_ARRAY(_field, _state, _n, _v, vmstate_lbr_records_var, \
+                         LBR_ENTRY)
+
 typedef struct x86_FPReg_tmp {
     FPReg *parent;
     uint64_t tmp_mant;
@@ -1523,6 +1539,27 @@ static const VMStateDescription vmstate_amx_xtile = {
     }
 };
 
+static bool arch_lbr_needed(void *opaque)
+{
+    X86CPU *cpu = opaque;
+    CPUX86State *env = &cpu->env;
+
+    return !!(env->features[FEAT_7_0_EDX] & CPUID_7_0_EDX_ARCH_LBR);
+}
+
+static const VMStateDescription vmstate_arch_lbr = {
+    .name = "cpu/arch_lbr",
+    .version_id = 1,
+    .minimum_version_id = 1,
+    .needed = arch_lbr_needed,
+    .fields = (VMStateField[]) {
+        VMSTATE_UINT64(env.msr_lbr_ctl, X86CPU),
+        VMSTATE_UINT64(env.msr_lbr_depth, X86CPU),
+        VMSTATE_LBR_VARS(env.lbr_records, X86CPU, ARCH_LBR_NR_ENTRIES, 1),
+        VMSTATE_END_OF_LIST()
+    }
+};
+
 const VMStateDescription vmstate_x86_cpu = {
     .name = "cpu",
     .version_id = 12,
@@ -1664,6 +1701,7 @@ const VMStateDescription vmstate_x86_cpu = {
         &vmstate_pdptrs,
         &vmstate_msr_xfd,
         &vmstate_amx_xtile,
+        &vmstate_arch_lbr,
         NULL
     }
 };
-- 
2.27.0

