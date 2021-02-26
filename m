Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4887325B77
	for <lists+kvm@lfdr.de>; Fri, 26 Feb 2021 03:11:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbhBZCK3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 21:10:29 -0500
Received: from mga03.intel.com ([134.134.136.65]:38821 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230037AbhBZCK3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Feb 2021 21:10:29 -0500
IronPort-SDR: oTC0YuuBoEHNKP5+oef/+RTtM1EOTBt5kuMvvnVXtTJKEK1f0dlx3mkbUbYUkURThe5qo62a1F
 jeWUnoc55Zbg==
X-IronPort-AV: E=McAfee;i="6000,8403,9906"; a="185801052"
X-IronPort-AV: E=Sophos;i="5.81,207,1610438400"; 
   d="scan'208";a="185801052"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2021 18:09:37 -0800
IronPort-SDR: lOD7m08hreyDN3buUMqVk4jPc3TcXvnKhAgbx+9tjUrVLe8+GQvtN10CsNHwhmQy4F2jcVwBXm
 qTuYmv4OfipQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,207,1610438400"; 
   d="scan'208";a="404680139"
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.166])
  by orsmga008.jf.intel.com with ESMTP; 25 Feb 2021 18:09:35 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, richard.henderson@linaro.org,
        ehabkost@redhat.com, mtosatti@redhat.com,
        sean.j.christopherson@intel.com, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v7 5/6] target/i386: Add CET state support for guest migration
Date:   Fri, 26 Feb 2021 10:20:57 +0800
Message-Id: <20210226022058.24562-6-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20210226022058.24562-1-weijiang.yang@intel.com>
References: <20210226022058.24562-1-weijiang.yang@intel.com>
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
index 233e46bb70..c76a7caeec 100644
--- a/target/i386/machine.c
+++ b/target/i386/machine.c
@@ -980,6 +980,159 @@ static const VMStateDescription vmstate_umwait = {
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
 #ifdef TARGET_X86_64
 static bool pkru_needed(void *opaque)
 {
@@ -1495,6 +1648,14 @@ VMStateDescription vmstate_x86_cpu = {
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

