Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 937D0374CEF
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 03:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbhEFBmI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 21:42:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:9154 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230216AbhEFBmH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 May 2021 21:42:07 -0400
IronPort-SDR: Oqopbjr0vRgWrvOcuYvsa4Np6RY4h4XdX1anVqBNHSod+eQC23rD/VEyQw56R65656aDAKRTN+
 vEcCcVCD0bpg==
X-IronPort-AV: E=McAfee;i="6200,9189,9975"; a="195230464"
X-IronPort-AV: E=Sophos;i="5.82,276,1613462400"; 
   d="scan'208";a="195230464"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2021 18:41:08 -0700
IronPort-SDR: uPhji8wrqNaeZG3Mx15aTG3QoZ6b2xJWQMAzi0YXCWaHM9Oyfz1pgbKWFbHplu9hTt+6w9flb1
 uo/VoboerKoA==
X-IronPort-AV: E=Sophos;i="5.82,276,1613462400"; 
   d="scan'208";a="469220354"
Received: from yy-desk-7060.sh.intel.com ([10.239.159.38])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2021 18:41:05 -0700
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     pbonzini@redhat.com
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, dgilbert@redhat.com,
        ehabkost@redhat.com, mst@redhat.com, armbru@redhat.com,
        mtosatti@redhat.com, ashish.kalra@amd.com, Thomas.Lendacky@amd.com,
        brijesh.singh@amd.com, isaku.yamahata@intel.com, yuan.yao@intel.com
Subject: [RFC][PATCH v1 03/10] Introduce new interface KVMState::set_mr_debug_ops and its wrapper
Date:   Thu,  6 May 2021 09:40:30 +0800
Message-Id: <20210506014037.11982-4-yuan.yao@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210506014037.11982-1-yuan.yao@linux.intel.com>
References: <20210506014037.11982-1-yuan.yao@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Yuan Yao <yuan.yao@intel.com>

This interface is designed to setup the MemoryRegion::debug_ops.

Also introduced 2 wrapper functions for installing/calling the
KVMState::set_mr_debug_ops from different targets easily.

Signed-off-by: Yuan Yao <yuan.yao@intel.com>

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index b6d5c9fd7d..1482561bd7 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -129,6 +129,8 @@ struct KVMState
         KVMMemoryListener *ml;
         AddressSpace *as;
     } *as;
+
+    set_memory_region_debug_ops set_mr_debug_ops;
 };
 
 KVMState *kvm_state;
@@ -3157,6 +3159,21 @@ static void kvm_set_kernel_irqchip(Object *obj, Visitor *v,
     }
 }
 
+void kvm_setup_memory_region_debug_ops(struct KVMState *s,
+                                       set_memory_region_debug_ops new_ops)
+{
+    if (s)
+        s->set_mr_debug_ops = new_ops;
+}
+
+void kvm_set_memory_region_debug_ops(void *handle, MemoryRegion *mr)
+{
+    if (!kvm_state || !kvm_state->set_mr_debug_ops)
+        return;
+
+    kvm_state->set_mr_debug_ops(handle, mr);
+}
+
 bool kvm_kernel_irqchip_allowed(void)
 {
     return kvm_state->kernel_irqchip_allowed;
diff --git a/accel/stubs/kvm-stub.c b/accel/stubs/kvm-stub.c
index 0f17acfac0..f1c57ad8d7 100644
--- a/accel/stubs/kvm-stub.c
+++ b/accel/stubs/kvm-stub.c
@@ -148,4 +148,15 @@ bool kvm_arm_supports_user_irq(void)
 {
     return false;
 }
+
+void kvm_setup_memory_region_debug_ops(struct KVMState *s,
+                                       set_memory_region_debug_ops new_ops)
+{
+
+}
+
+void kvm_set_memory_region_debug_ops(void *handle, MemoryRegion *mr)
+{
+
+}
 #endif
diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index a1ab1ee12d..64685cad57 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -547,4 +547,9 @@ bool kvm_cpu_check_are_resettable(void);
 
 bool kvm_arch_cpu_check_are_resettable(void);
 
+typedef void (*set_memory_region_debug_ops)(void *handle, MemoryRegion *mr);
+void kvm_setup_memory_region_debug_ops(struct KVMState *s, set_memory_region_debug_ops new_ops);
+
+void kvm_set_memory_region_debug_ops(void *handle, MemoryRegion *mr);
+
 #endif
-- 
2.20.1

