Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E88E780921
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 11:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359479AbjHRJ42 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Aug 2023 05:56:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359540AbjHRJ4P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Aug 2023 05:56:15 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C67E3581
        for <kvm@vger.kernel.org>; Fri, 18 Aug 2023 02:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692352563; x=1723888563;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mc6hfwR/NsRyKjy6Yf1mN0Fyb5bpTiJsLDAtSJim7wY=;
  b=RSprDDkOg1apTIQmq1YuLTnHu59B3zwXBrrLZcEeG/cFJsqeYA6IfT5G
   3jWcwyb33n+jk5Olm3sjwxMoZFCX9b1j3gFrF9/bN/OhRNf1yvuI2tGRZ
   FJOQLIymnNn1tQQ6lFYFJi9AG1oKdsq/cCTk1CHFt0T4xTQL0PIRXFOHs
   EGTiyRfy1kwtiD4WDzkkgUtMS2v+tRdj79ylkZD9Mq9f43rRN2ZqPzOtF
   LzxOI8xih+ELP0t05T5seOFxBm0jaynMHKkmZxogG5Ob8eleFBL+3/z6V
   qIysgDGYt4qOp88vMAE+3OPzEzOJVTItImqP80ONgV81/u5RRKzimsaNf
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="371965909"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="371965909"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2023 02:56:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="849234988"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="849234988"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.46])
  by fmsmga002.fm.intel.com with ESMTP; 18 Aug 2023 02:55:56 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <anisinha@redhat.com>, Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Eduardo Habkost <eduardo@habkost.net>,
        Laszlo Ersek <lersek@redhat.com>, xiaoyao.li@intel.com,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        erdemaktas@google.com, Chenyi Qiang <chenyi.qiang@intel.com>
Subject: [PATCH v2 18/58] i386/tdx: Validate TD attributes
Date:   Fri, 18 Aug 2023 05:50:01 -0400
Message-Id: <20230818095041.1973309-19-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230818095041.1973309-1-xiaoyao.li@intel.com>
References: <20230818095041.1973309-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Validate TD attributes with tdx_caps that fixed-0 bits must be zero and
fixed-1 bits must be set.

Besides, sanity check the attribute bits that have not been supported by
QEMU yet. e.g., debug bit, it will be allowed in the future when debug
TD support lands in QEMU.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
---
 target/i386/kvm/tdx.c | 27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 629abd267da8..73da15377ec3 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -32,6 +32,7 @@
                                      (1U << KVM_FEATURE_PV_SCHED_YIELD) | \
                                      (1U << KVM_FEATURE_MSI_EXT_DEST_ID))
 
+#define TDX_TD_ATTRIBUTES_DEBUG             BIT_ULL(0)
 #define TDX_TD_ATTRIBUTES_SEPT_VE_DISABLE   BIT_ULL(28)
 #define TDX_TD_ATTRIBUTES_PKS               BIT_ULL(30)
 #define TDX_TD_ATTRIBUTES_PERFMON           BIT_ULL(63)
@@ -462,13 +463,32 @@ int tdx_kvm_init(MachineState *ms, Error **errp)
     return 0;
 }
 
-static void setup_td_guest_attributes(X86CPU *x86cpu)
+static int tdx_validate_attributes(TdxGuest *tdx)
+{
+    if (((tdx->attributes & tdx_caps->attrs_fixed0) | tdx_caps->attrs_fixed1) !=
+        tdx->attributes) {
+            error_report("Invalid attributes 0x%lx for TDX VM (fixed0 0x%llx, fixed1 0x%llx)",
+                          tdx->attributes, tdx_caps->attrs_fixed0, tdx_caps->attrs_fixed1);
+            return -EINVAL;
+    }
+
+    if (tdx->attributes & TDX_TD_ATTRIBUTES_DEBUG) {
+        error_report("Current QEMU doesn't support attributes.debug[bit 0] for TDX VM");
+        return -EINVAL;
+    }
+
+    return 0;
+}
+
+static int setup_td_guest_attributes(X86CPU *x86cpu)
 {
     CPUX86State *env = &x86cpu->env;
 
     tdx_guest->attributes |= (env->features[FEAT_7_0_ECX] & CPUID_7_0_ECX_PKS) ?
                              TDX_TD_ATTRIBUTES_PKS : 0;
     tdx_guest->attributes |= x86cpu->enable_pmu ? TDX_TD_ATTRIBUTES_PERFMON : 0;
+
+    return tdx_validate_attributes(tdx_guest);
 }
 
 int tdx_pre_create_vcpu(CPUState *cpu)
@@ -493,7 +513,10 @@ int tdx_pre_create_vcpu(CPUState *cpu)
         goto out_free;
     }
 
-    setup_td_guest_attributes(x86cpu);
+    r = setup_td_guest_attributes(x86cpu);
+    if (r) {
+        goto out;
+    }
 
     init_vm->cpuid.nent = kvm_x86_arch_cpuid(env, init_vm->cpuid.entries, 0);
     init_vm->attributes = tdx_guest->attributes;
-- 
2.34.1

