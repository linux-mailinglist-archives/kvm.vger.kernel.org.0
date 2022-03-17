Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 451684DC81E
	for <lists+kvm@lfdr.de>; Thu, 17 Mar 2022 15:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234793AbiCQOBT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Mar 2022 10:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234822AbiCQOBL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Mar 2022 10:01:11 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84C911E31B6
        for <kvm@vger.kernel.org>; Thu, 17 Mar 2022 06:59:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647525594; x=1679061594;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8WKU8kUjVsDeAkVl5TJBOLFr5Ihd3Yk1VXbr2Gl8d48=;
  b=OZ0poGS05EU3jE7VjglX9B0UwI38/PEUW6A8FEZbQWqyJ1/smmRfPw/N
   QS+1Mvnk2cHEidmov9K9zQu4YcSl7BT2Jqrp5ZZAN21lNe6MTXuns09al
   JzHITSeQ4j/lcHa9fjJNXRrxfUMxvkdTH6ebQrYKoZR6QcKBG0w13aFuy
   DlBRGviY7SvjShaZ7BJqi8b+Y4fHGYyBAu9JcwemXt+LNjoqv4enNt1J4
   v+dePpZvT/mRhIKYXysEVkZcjwkxIRguNtzTdZH9n5flvy0EoutWUdKH4
   STdhZpDZWTv+XoM0xwsg7XzovDw8obOXj1JPD1ExHnD2XZS1A8T2mCQvj
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10288"; a="257058289"
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="257058289"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2022 06:59:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="541377924"
Received: from lxy-dell.sh.intel.com ([10.239.159.55])
  by orsmga007.jf.intel.com with ESMTP; 17 Mar 2022 06:59:49 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Eric Blake <eblake@redhat.com>
Cc:     Connor Kuehl <ckuehl@redhat.com>, isaku.yamahata@intel.com,
        xiaoyao.li@intel.com, erdemaktas@google.com, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, seanjc@google.com
Subject: [RFC PATCH v3 08/36] i386/tdx: Adjust get_supported_cpuid() for TDX VM
Date:   Thu, 17 Mar 2022 21:58:45 +0800
Message-Id: <20220317135913.2166202-9-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220317135913.2166202-1-xiaoyao.li@intel.com>
References: <20220317135913.2166202-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For TDX, the allowable CPUID configuration differs from what KVM
reports for KVM scope via KVM_GET_SUPPORTED_CPUID.

- Some CPUID bits are not supported for TDX VM while KVM reports the
  support. Mask them off for TDX VM. e.g., CPUID_EXT_VMX, some PV
  featues.

- The supported XCR0 and XSS bits needs to be caped by tdx_caps, because
  KVM uses them to setup XFAM of TD.

Introduce tdx_get_supported_cpuid() to adjust the
kvm_arch_get_supported_cpuid() for TDX VM.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/cpu.h     |  5 +++++
 target/i386/kvm/kvm.c |  4 ++++
 target/i386/kvm/tdx.c | 39 +++++++++++++++++++++++++++++++++++++++
 target/i386/kvm/tdx.h |  2 ++
 4 files changed, 50 insertions(+)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 5e406088a91a..7fa30f4ed7db 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -566,6 +566,11 @@ typedef enum X86Seg {
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
index 26ed5faf07b8..ddbe8f64fadb 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -486,6 +486,10 @@ uint32_t kvm_arch_get_supported_cpuid(KVMState *s, uint32_t function,
         ret |= 1U << KVM_HINTS_REALTIME;
     }
 
+    if (is_tdx_vm()) {
+        tdx_get_supported_cpuid(function, index, reg, &ret);
+    }
+
     return ret;
 }
 
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 846511b299f4..e4ee55f30c79 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -14,6 +14,7 @@
 #include "qemu/osdep.h"
 #include "qapi/error.h"
 #include "qom/object_interfaces.h"
+#include "standard-headers/asm-x86/kvm_para.h"
 #include "sysemu/kvm.h"
 
 #include "hw/i386/x86.h"
@@ -110,6 +111,44 @@ int tdx_kvm_init(MachineState *ms, Error **errp)
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
+            *ret &= ~((1ULL << KVM_FEATURE_CLOCKSOURCE) |
+                      (1ULL << KVM_FEATURE_CLOCKSOURCE2) |
+                      (1ULL << KVM_FEATURE_CLOCKSOURCE_STABLE_BIT) |
+                      (1ULL << KVM_FEATURE_ASYNC_PF) |
+                      (1ULL << KVM_FEATURE_ASYNC_PF_VMEXIT) |
+                      (1ULL << KVM_FEATURE_ASYNC_PF_INT));
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

