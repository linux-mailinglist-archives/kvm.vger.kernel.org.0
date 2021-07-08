Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 936453BF301
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 02:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbhGHA6m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 20:58:42 -0400
Received: from mga18.intel.com ([134.134.136.126]:19318 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230188AbhGHA6g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jul 2021 20:58:36 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10038"; a="196696070"
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="196696070"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 17:55:55 -0700
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="423770027"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 17:55:55 -0700
From:   isaku.yamahata@gmail.com
To:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, xiaoyao.li@intel.com,
        seanjc@google.com, erdemaktas@google.com
Cc:     kvm@vger.kernel.org, isaku.yamahata@gmail.com,
        isaku.yamahata@intel.com
Subject: [RFC PATCH v2 12/44] target/i386/tdx: Finalize the TD's measurement when machine is done
Date:   Wed,  7 Jul 2021 17:54:42 -0700
Message-Id: <a9948a7cd4f002ba4c3161287b366f4378523502.1625704981.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625704980.git.isaku.yamahata@intel.com>
References: <cover.1625704980.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Xiaoyao Li <xiaoyao.li@intel.com>

Invoke KVM_TDX_FINALIZEMR to finalize the TD's measurement and make
the TD vCPUs runnable once machine initialization is complete.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 target/i386/kvm/kvm.c |  7 +++++++
 target/i386/kvm/tdx.c | 21 +++++++++++++++++++++
 target/i386/kvm/tdx.h |  3 +++
 3 files changed, 31 insertions(+)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index be0b96b120..5742fa4806 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -53,6 +53,7 @@
 #include "migration/blocker.h"
 #include "exec/memattrs.h"
 #include "trace.h"
+#include "tdx.h"
 
 //#define DEBUG_KVM
 
@@ -2246,6 +2247,12 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
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
index c50a0dcf11..f8c7560fc8 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -58,6 +58,27 @@ static void __tdx_ioctl(int ioctl_no, const char *ioctl_name,
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
+    if (!tdx) {
+        return 0;
+    }
+
+    qemu_add_machine_init_done_late_notifier(&tdx_machine_done_late_notify);
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
2.25.1

