Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6786EA470
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 09:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbjDUHQz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 03:16:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbjDUHQx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 03:16:53 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A2B610F
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 00:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682061412; x=1713597412;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TLq6UCCw6H2MXvktTy5ZqQ0ZM/+Ojum490E6zzwtrE0=;
  b=N3N/UlkJm94Ra05nqra2F1wvoYr/+Qc6makMrIxxEUR3v3J5p4+x/EeW
   b0R5bja2nkT5C1A0/EQeM1dDBjgLsZbEHlYZv7GVMb/p3kNsxlFLbLth8
   werOp0Z4F9Y1uppFIhbcVwZtYuku3KCwu4CWc8QJA7RUJ3MswrBJP2LMg
   GZ7PJx602v5nCk1onh8Yr9bzRHPU2vq5rgKSBzmHJB5v/nsdpI7hZ99yF
   1GxJLigz4HfTywYUf8kj5xmguHWkTe1K2wgELs1ZSCWQuK2Uw8iyGA22c
   imD3UfEBeCJ4R9lsiHK4yLBIyuNuVei23nKSrs3du29K5ssycj6cJI8hz
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="326260536"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="326260536"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 00:16:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="938385328"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="938385328"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 00:16:39 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, mtosatti@redhat.com, seanjc@google.com,
        qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, weijiang.yang@intel.com
Subject: [PATCH 3/4] target/i386: Enable CET states migration
Date:   Fri, 21 Apr 2023 00:12:26 -0400
Message-Id: <20230421041227.90915-4-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230421041227.90915-1-weijiang.yang@intel.com>
References: <20230421041227.90915-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add supported CET states in vmstate for VM migration.

Other MSRs, i.e., MSR_IA32_PL{0,1,2}_SSP and MSR_IA32_INTR_SSP_TBL
are for non-supported supervisor mode shadow stack, are ignored now.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 target/i386/machine.c | 81 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 81 insertions(+)

diff --git a/target/i386/machine.c b/target/i386/machine.c
index c7ac8084b2..904a7e9574 100644
--- a/target/i386/machine.c
+++ b/target/i386/machine.c
@@ -1018,6 +1018,83 @@ static const VMStateDescription vmstate_umwait = {
     }
 };
 
+static bool u_cet_needed(void *opaque)
+{
+    X86CPU *cpu = opaque;
+    CPUX86State *env = &cpu->env;
+
+    return env->u_cet != 0;
+}
+
+static const VMStateDescription vmstate_u_cet = {
+    .name = "cpu/u_cet",
+    .version_id = 1,
+    .minimum_version_id = 1,
+    .needed = u_cet_needed,
+    .fields = (VMStateField[]) {
+        VMSTATE_UINT64(env.u_cet, X86CPU),
+        VMSTATE_END_OF_LIST()
+    }
+};
+
+static bool s_cet_needed(void *opaque)
+{
+    X86CPU *cpu = opaque;
+    CPUX86State *env = &cpu->env;
+
+    return env->s_cet != 0;
+}
+
+static const VMStateDescription vmstate_s_cet = {
+    .name = "cpu/s_cet",
+    .version_id = 1,
+    .minimum_version_id = 1,
+    .needed = s_cet_needed,
+    .fields = (VMStateField[]) {
+        VMSTATE_UINT64(env.s_cet, X86CPU),
+        VMSTATE_END_OF_LIST()
+    }
+};
+
+
+static bool pl3_ssp_needed(void *opaque)
+{
+    X86CPU *cpu = opaque;
+    CPUX86State *env = &cpu->env;
+
+    return env->pl3_ssp != 0;
+}
+
+static const VMStateDescription vmstate_pl3_ssp = {
+    .name = "cpu/pl3_ssp",
+    .version_id = 1,
+    .minimum_version_id = 1,
+    .needed = pl3_ssp_needed,
+    .fields = (VMStateField[]) {
+        VMSTATE_UINT64(env.pl3_ssp, X86CPU),
+        VMSTATE_END_OF_LIST()
+    }
+};
+
+static bool guest_ssp_needed(void *opaque)
+{
+    X86CPU *cpu = opaque;
+    CPUX86State *env = &cpu->env;
+
+    return env->guest_ssp != 0;
+}
+
+static const VMStateDescription vmstate_guest_ssp = {
+    .name = "cpu/guest_ssp",
+    .version_id = 1,
+    .minimum_version_id = 1,
+    .needed = guest_ssp_needed,
+    .fields = (VMStateField[]) {
+        VMSTATE_UINT64(env.guest_ssp, X86CPU),
+        VMSTATE_END_OF_LIST()
+    }
+};
+
 static bool pkru_needed(void *opaque)
 {
     X86CPU *cpu = opaque;
@@ -1745,6 +1822,10 @@ const VMStateDescription vmstate_x86_cpu = {
         &vmstate_msr_tsx_ctrl,
         &vmstate_msr_intel_sgx,
         &vmstate_pdptrs,
+        &vmstate_u_cet,
+        &vmstate_s_cet,
+        &vmstate_pl3_ssp,
+        &vmstate_guest_ssp,
         &vmstate_msr_xfd,
 #ifdef TARGET_X86_64
         &vmstate_amx_xtile,
-- 
2.27.0

