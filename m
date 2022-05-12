Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 224F052433E
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 05:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343517AbiELDTE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 23:19:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343646AbiELDS4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 23:18:56 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3735D216067
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 20:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652325530; x=1683861530;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vMFsLQVnoupHQ2jYhvlJfEfSaCwlUmEtAofylDNcL9Q=;
  b=X1WcBvASFsnx2NZG7ozwRMtKg25tpGAGJqWDalOpmbHSS9mzi+sj+l5l
   eJ55BzzhJBnrTW//I+ffyeH2P0tgZ+yFXjM3Hom21heyuqmmTIFuugpce
   F7DgAU3yVs1EPN4kKZzwemEESJDs3jp6ws9PilQq+ZIAfkHQrXL4yryCK
   Hoe375jytuVPiTy7pi4foXoEsGgjpXJpIyckHwdraKpQcZzJWxgk29V7V
   1p6XeK9EDMAdGpDZnaLswO9HWl/Ui4glrIrOlYILnyVBYzO+eYhZvmr1T
   53IkRf/RZry/uYYfmGjqkY4Vm9hA4wacWHQg6I1L++qM9Ke21HAeHH3BP
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10344"; a="332914734"
X-IronPort-AV: E=Sophos;i="5.91,218,1647327600"; 
   d="scan'208";a="332914734"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2022 20:18:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,218,1647327600"; 
   d="scan'208";a="594455557"
Received: from lxy-dell.sh.intel.com ([10.239.159.55])
  by orsmga008.jf.intel.com with ESMTP; 11 May 2022 20:18:43 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        isaku.yamahata@intel.com, Gerd Hoffmann <kraxel@redhat.com>,
        =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Eric Blake <eblake@redhat.com>
Cc:     Connor Kuehl <ckuehl@redhat.com>, erdemaktas@google.com,
        kvm@vger.kernel.org, qemu-devel@nongnu.org, seanjc@google.com,
        xiaoyao.li@intel.com
Subject: [RFC PATCH v4 08/36] i386/tdx: Adjust get_supported_cpuid() for TDX VM
Date:   Thu, 12 May 2022 11:17:35 +0800
Message-Id: <20220512031803.3315890-9-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220512031803.3315890-1-xiaoyao.li@intel.com>
References: <20220512031803.3315890-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For TDX, the allowable CPUID configuration differs from what KVM
reports for KVM scope via KVM_GET_SUPPORTED_CPUID.

- Some CPUID bits are not supported for TDX VM while KVM reports the
  support. Mask them off for TDX VM. e.g., CPUID_EXT_VMX, some PV
  features.

- The supported XCR0 and XSS bits needs to be cap'ed by tdx_caps, because
  KVM uses them to setup XFAM of TD.

Introduce tdx_get_supported_cpuid() to adjust the
kvm_arch_get_supported_cpuid() for TDX VM.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/cpu.h     |  5 +++++
 target/i386/kvm/kvm.c |  4 ++++
 target/i386/kvm/tdx.c | 44 +++++++++++++++++++++++++++++++++++++++++++
 target/i386/kvm/tdx.h |  2 ++
 4 files changed, 55 insertions(+)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 9661f9fbd1c6..0c922e5a305a 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -567,6 +567,11 @@ typedef enum X86Seg {
 #define ESA_FEATURE_XFD_MASK            (1U << ESA_FEATURE_XFD_BIT)
 
 
+#define XCR0_MASK       (XSTATE_FP_MASK | XSTATE_SSE_MASK | XSTATE_YMM_MASK | \
+                         XSTATE_BNDREGS_MASK | XSTATE_BNDCSR_MASK | \
+                         XSTATE_OPMASK_MASK | XSTATE_ZMM_Hi256_MASK | \
+                         XSTATE_Hi16_ZMM_MASK | XSTATE_PKRU_MASK)
+
 /* CPUID feature words */
 typedef enum FeatureWord {
     FEAT_1_EDX,         /* CPUID[1].EDX */
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index f257ffda259d..0751e6e102cc 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -498,6 +498,10 @@ uint32_t kvm_arch_get_supported_cpuid(KVMState *s, uint32_t function,
         ret |= 1U << KVM_HINTS_REALTIME;
     }
 
+    if (is_tdx_vm()) {
+        tdx_get_supported_cpuid(function, index, reg, &ret);
+    }
+
     return ret;
 }
 
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 803154efdb91..6e3b15ba8a4a 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -14,11 +14,22 @@
 #include "qemu/osdep.h"
 #include "qapi/error.h"
 #include "qom/object_interfaces.h"
+#include "standard-headers/asm-x86/kvm_para.h"
 #include "sysemu/kvm.h"
 
 #include "hw/i386/x86.h"
 #include "tdx.h"
 
+#define TDX_SUPPORTED_KVM_FEATURES  ((1ULL << KVM_FEATURE_NOP_IO_DELAY) | \
+                                     (1ULL << KVM_FEATURE_STEAL_TIME) | \
+                                     (1ULL << KVM_FEATURE_PV_EOI) | \
+                                     (1ULL << KVM_FEATURE_PV_UNHALT) | \
+                                     (1ULL << KVM_FEATURE_PV_TLB_FLUSH) | \
+                                     (1ULL << KVM_FEATURE_PV_SEND_IPI) | \
+                                     (1ULL << KVM_FEATURE_POLL_CONTROL) | \
+                                     (1ULL << KVM_FEATURE_PV_SCHED_YIELD) | \
+                                     (1ULL << KVM_FEATURE_MSI_EXT_DEST_ID))
+
 static TdxGuest *tdx_guest;
 
 /* It's valid after kvm_confidential_guest_init()->kvm_tdx_init() */
@@ -121,6 +132,39 @@ int tdx_kvm_init(MachineState *ms, Error **errp)
     return 0;
 }
 
+void tdx_get_supported_cpuid(uint32_t function, uint32_t index, int reg,
+                             uint32_t *ret)
+{
+    switch (function) {
+    case 1:
+        if (reg == R_ECX) {
+            *ret &= ~CPUID_EXT_VMX;
+        }
+        break;
+    case 0xd:
+        if (index == 0) {
+            if (reg == R_EAX) {
+                *ret &= (uint32_t)tdx_caps->xfam_fixed0 & XCR0_MASK;
+                *ret |= (uint32_t)tdx_caps->xfam_fixed1 & XCR0_MASK;
+            } else if (reg == R_EDX) {
+                *ret &= (tdx_caps->xfam_fixed0 & XCR0_MASK) >> 32;
+                *ret |= (tdx_caps->xfam_fixed1 & XCR0_MASK) >> 32;
+            }
+        } else if (index == 1) {
+            /* TODO: Adjust XSS when it's supported. */
+        }
+        break;
+    case KVM_CPUID_FEATURES:
+        if (reg == R_EAX) {
+            *ret &= TDX_SUPPORTED_KVM_FEATURES;
+        }
+        break;
+    default:
+        /* TODO: Use tdx_caps to adjust CPUID leafs. */
+        break;
+    }
+}
+
 /* tdx guest */
 OBJECT_DEFINE_TYPE_WITH_INTERFACES(TdxGuest,
                                    tdx_guest,
diff --git a/target/i386/kvm/tdx.h b/target/i386/kvm/tdx.h
index 4036ca2f3f99..06599b65b827 100644
--- a/target/i386/kvm/tdx.h
+++ b/target/i386/kvm/tdx.h
@@ -27,5 +27,7 @@ bool is_tdx_vm(void);
 #endif /* CONFIG_TDX */
 
 int tdx_kvm_init(MachineState *ms, Error **errp);
+void tdx_get_supported_cpuid(uint32_t function, uint32_t index, int reg,
+                             uint32_t *ret);
 
 #endif /* QEMU_I386_TDX_H */
-- 
2.27.0

