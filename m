Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B8C731C573
	for <lists+kvm@lfdr.de>; Tue, 16 Feb 2021 03:21:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbhBPCTS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Feb 2021 21:19:18 -0500
Received: from mga06.intel.com ([134.134.136.31]:39373 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229811AbhBPCQn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Feb 2021 21:16:43 -0500
IronPort-SDR: cYA1jA1021Hufx0VV2IsOmScO9QvWkjGLMWQUbjyuNFdpb7aJcU0eEELF4vgXNVVrBuNMzI/ab
 DhTVf5XVJfsg==
X-IronPort-AV: E=McAfee;i="6000,8403,9896"; a="244270206"
X-IronPort-AV: E=Sophos;i="5.81,182,1610438400"; 
   d="scan'208";a="244270206"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2021 18:14:52 -0800
IronPort-SDR: kw8wE7s6+1sJZg0EIihC7z+FLtmQXjavIVVEEbyL0obw9oaHQZtE4rbedZzQvxn66xqMa+dJ3a
 7R9ofpfY3eSw==
X-IronPort-AV: E=Sophos;i="5.81,182,1610438400"; 
   d="scan'208";a="591705419"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2021 18:14:52 -0800
From:   Isaku Yamahata <isaku.yamahata@intel.com>
To:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, xiaoyao.li@intel.com,
        seanjc@google.com
Cc:     kvm@vger.kernel.org, isaku.yamahata@gmail.com,
        isaku.yamahata@intel.com
Subject: [RFC PATCH 12/23] target/i386/tdx: Finalize the TD's measurement when machine is done
Date:   Mon, 15 Feb 2021 18:13:08 -0800
Message-Id: <73044bc1f696b1409445b6fe35712044c875928c.1613188118.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1613188118.git.isaku.yamahata@intel.com>
References: <cover.1613188118.git.isaku.yamahata@intel.com>
In-Reply-To: <cover.1613188118.git.isaku.yamahata@intel.com>
References: <cover.1613188118.git.isaku.yamahata@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Xiaoyao Li <xiaoyao.li@intel.com>

Invoke KVM_TDX_FINALIZEMR to finalize the TD's measurement and make the
TD vCPUs runnable once machine initialization is complete.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/kvm/kvm.c |  7 +++++++
 target/i386/kvm/tdx.c | 20 ++++++++++++++++++++
 target/i386/kvm/tdx.h |  3 +++
 3 files changed, 30 insertions(+)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index beb768a7d3..018a757dc6 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -51,6 +51,7 @@
 #include "migration/blocker.h"
 #include "exec/memattrs.h"
 #include "trace.h"
+#include "tdx.h"
 
 //#define DEBUG_KVM
 
@@ -2184,6 +2185,12 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
         return ret;
     }
 
+    ret = tdx_kvm_init(ms->cgs, &local_err);
+    if (ret < 0) {
+        error_report_err(local_err);
+        return ret;
+    }
+
     if (!kvm_check_extension(s, KVM_CAP_IRQ_ROUTING)) {
         error_report("kvm: KVM_CAP_IRQ_ROUTING not supported by KVM");
         return -ENOTSUP;
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 00eda80725..d8b79e975f 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -56,6 +56,26 @@ static void __tdx_ioctl(int ioctl_no, const char *ioctl_name,
 #define tdx_ioctl(ioctl_no, metadata, data) \
         __tdx_ioctl(ioctl_no, stringify(ioctl_no), metadata, data)
 
+static void tdx_finalize_vm(Notifier *notifier, void *unused)
+{
+    tdx_ioctl(KVM_TDX_FINALIZE_VM, 0, NULL);
+}
+
+static Notifier tdx_machine_done_late_notify = {
+    .notify = tdx_finalize_vm,
+};
+
+int tdx_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
+{
+    TdxGuest *tdx = (TdxGuest *)object_dynamic_cast(OBJECT(cgs),
+                                                    TYPE_TDX_GUEST);
+    if (tdx) {
+        qemu_add_machine_init_done_late_notifier(
+            &tdx_machine_done_late_notify);
+    }
+    return 0;
+}
+
 void tdx_pre_create_vcpu(CPUState *cpu)
 {
     struct {
diff --git a/target/i386/kvm/tdx.h b/target/i386/kvm/tdx.h
index 6ad6c9a313..e15657d272 100644
--- a/target/i386/kvm/tdx.h
+++ b/target/i386/kvm/tdx.h
@@ -2,6 +2,7 @@
 #define QEMU_I386_TDX_H
 
 #include "qom/object.h"
+#include "qapi/error.h"
 #include "exec/confidential-guest-support.h"
 
 #define TYPE_TDX_GUEST "tdx-guest"
@@ -21,4 +22,6 @@ typedef struct TdxGuest {
     bool debug;
 } TdxGuest;
 
+int tdx_kvm_init(ConfidentialGuestSupport *cgs, Error **errp);
+
 #endif
-- 
2.17.1

