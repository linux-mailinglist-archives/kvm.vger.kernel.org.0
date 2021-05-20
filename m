Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FAC1389D37
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 07:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbhETFpL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 01:45:11 -0400
Received: from mga18.intel.com ([134.134.136.126]:3310 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230414AbhETFpI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 01:45:08 -0400
IronPort-SDR: tiGr6RLwMyFvWRWgcerqDN0Q7S8WTvSyLraBrSlz7yVjK/v7RctpQ2cKsUqzARfrnUGLU+6xDB
 19RI7+v1OjzA==
X-IronPort-AV: E=McAfee;i="6200,9189,9989"; a="188553709"
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="188553709"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2021 22:43:46 -0700
IronPort-SDR: cZqagD11VLjzvRbUJKGY9KOcyv4K/5+8Y9LtWZYrUvk5ioCiMlyXY9HtqzEq7i5y3jXfHMf0u9
 rQwx8W9shfKQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="440160324"
Received: from michael-optiplex-9020.sh.intel.com ([10.239.159.172])
  by fmsmga008.fm.intel.com with ESMTP; 19 May 2021 22:43:44 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, ehabkost@redhat.com, mtosatti@redhat.com,
        seanjc@google.com, richard.henderson@linaro.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v8 5/6] target/i386: Add CET state support for guest migration
Date:   Thu, 20 May 2021 13:57:10 +0800
Message-Id: <1621490231-4765-6-git-send-email-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1621490231-4765-1-git-send-email-weijiang.yang@intel.com>
References: <1621490231-4765-1-git-send-email-weijiang.yang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Save the MSRs being used on source machine and restore them
on destination machine.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 target/i386/machine.c | 161 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 161 insertions(+)

diff --git a/target/i386/machine.c b/target/i386/machine.c
index 137604ddb8..4d63340931 100644
--- a/target/i386/machine.c
+++ b/target/i386/machine.c
@@ -1000,6 +1000,159 @@ static const VMStateDescription vmstate_umwait = {
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
+static bool pl0_ssp_needed(void *opaque)
+{
+    X86CPU *cpu = opaque;
+    CPUX86State *env = &cpu->env;
+
+    return env->pl0_ssp != 0;
+}
+
+static const VMStateDescription vmstate_pl0_ssp = {
+    .name = "cpu/pl0_ssp",
+    .version_id = 1,
+    .minimum_version_id = 1,
+    .needed = pl0_ssp_needed,
+    .fields = (VMStateField[]) {
+        VMSTATE_UINT64(env.pl0_ssp, X86CPU),
+        VMSTATE_END_OF_LIST()
+    }
+};
+
+static bool pl1_ssp_needed(void *opaque)
+{
+    X86CPU *cpu = opaque;
+    CPUX86State *env = &cpu->env;
+
+    return env->pl1_ssp != 0;
+}
+
+static const VMStateDescription vmstate_pl1_ssp = {
+    .name = "cpu/pl1_ssp",
+    .version_id = 1,
+    .minimum_version_id = 1,
+    .needed = pl1_ssp_needed,
+    .fields = (VMStateField[]) {
+        VMSTATE_UINT64(env.pl1_ssp, X86CPU),
+        VMSTATE_END_OF_LIST()
+    }
+};
+
+static bool pl2_ssp_needed(void *opaque)
+{
+    X86CPU *cpu = opaque;
+    CPUX86State *env = &cpu->env;
+
+    return env->pl2_ssp != 0;
+}
+
+static const VMStateDescription vmstate_pl2_ssp = {
+    .name = "cpu/pl2_ssp",
+    .version_id = 1,
+    .minimum_version_id = 1,
+    .needed = pl2_ssp_needed,
+    .fields = (VMStateField[]) {
+        VMSTATE_UINT64(env.pl2_ssp, X86CPU),
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
+static bool ssp_tbl_needed(void *opaque)
+{
+    X86CPU *cpu = opaque;
+    CPUX86State *env = &cpu->env;
+
+    return env->ssp_tbl != 0;
+}
+
+static const VMStateDescription vmstate_ssp_tbl = {
+    .name = "cpu/ssp_tbl",
+    .version_id = 1,
+    .minimum_version_id = 1,
+    .needed = ssp_tbl_needed,
+    .fields = (VMStateField[]) {
+        VMSTATE_UINT64(env.ssp_tbl, X86CPU),
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
@@ -1531,6 +1684,14 @@ VMStateDescription vmstate_x86_cpu = {
         &vmstate_nested_state,
 #endif
         &vmstate_msr_tsx_ctrl,
+        &vmstate_u_cet,
+        &vmstate_s_cet,
+        &vmstate_pl0_ssp,
+        &vmstate_pl1_ssp,
+        &vmstate_pl2_ssp,
+        &vmstate_pl3_ssp,
+        &vmstate_ssp_tbl,
+        &vmstate_guest_ssp,
         NULL
     }
 };
-- 
2.26.2

