Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A18F5EEE97
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 09:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235100AbiI2HOS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 03:14:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235137AbiI2HOH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 03:14:07 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B9C0132FC1
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 00:14:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664435644; x=1695971644;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=uQGTvFkRu2suvO/BBfMCi7VX8taOodq9QWl6FH4+5vk=;
  b=IaO3xdBlcr5onNWFme9JzWN15RHexThxDinHBIMsPjze0HYTeDtyqJpw
   G8HmWrKDeyeJMoIHlYOa7e+MQuCnuh6Iy+oId9GXRGHMrRS/U66O0lFWt
   b75PFv2xs/qdz/T8n71yrySs8OgAyMGBBnhcgsRiDEgSWh8a0murSpyyh
   E7yUPDZX5JG5zgC7SuWHEfGmUb+abknUx/H43PY8Cbq6gODJTaZWLwLmu
   RfTSt4Q9rRPARZpaDpHA0ObH5F702NkMWmh1Bu1mYU/pCaLOaFue05oi1
   4HUdFBM61aYcQ6i2OxBloIQlqxojEdoV9w6SqD/duUoGn5Km5aUaGdZWQ
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="288978808"
X-IronPort-AV: E=Sophos;i="5.93,354,1654585200"; 
   d="scan'208";a="288978808"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2022 00:14:03 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="655440727"
X-IronPort-AV: E=Sophos;i="5.93,354,1654585200"; 
   d="scan'208";a="655440727"
Received: from chenyi-pc.sh.intel.com ([10.239.159.53])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2022 00:14:01 -0700
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Peter Xu <peterx@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: [RESEND PATCH v8 2/4] kvm: allow target-specific accelerator properties
Date:   Thu, 29 Sep 2022 15:20:12 +0800
Message-Id: <20220929072014.20705-3-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220929072014.20705-1-chenyi.qiang@intel.com>
References: <20220929072014.20705-1-chenyi.qiang@intel.com>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

Several hypervisor capabilities in KVM are target-specific.  When exposed
to QEMU users as accelerator properties (i.e. -accel kvm,prop=value), they
should not be available for all targets.

Add a hook for targets to add their own properties to -accel kvm, for
now no such property is defined.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 accel/kvm/kvm-all.c    | 2 ++
 include/sysemu/kvm.h   | 2 ++
 target/arm/kvm.c       | 4 ++++
 target/i386/kvm/kvm.c  | 4 ++++
 target/mips/kvm.c      | 4 ++++
 target/ppc/kvm.c       | 4 ++++
 target/riscv/kvm.c     | 4 ++++
 target/s390x/kvm/kvm.c | 4 ++++
 8 files changed, 28 insertions(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 5acab1767f..f90c5cb285 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -3737,6 +3737,8 @@ static void kvm_accel_class_init(ObjectClass *oc, void *data)
         NULL, NULL);
     object_class_property_set_description(oc, "dirty-ring-size",
         "Size of KVM dirty page ring buffer (default: 0, i.e. use bitmap)");
+
+    kvm_arch_accel_class_init(oc);
 }
 
 static const TypeInfo kvm_accel_type = {
diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index efd6dee818..50868ebf60 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -353,6 +353,8 @@ bool kvm_device_supported(int vmfd, uint64_t type);
 
 extern const KVMCapabilityInfo kvm_arch_required_capabilities[];
 
+void kvm_arch_accel_class_init(ObjectClass *oc);
+
 void kvm_arch_pre_run(CPUState *cpu, struct kvm_run *run);
 MemTxAttrs kvm_arch_post_run(CPUState *cpu, struct kvm_run *run);
 
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index e5c1bd50d2..d21603cf28 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -1056,3 +1056,7 @@ bool kvm_arch_cpu_check_are_resettable(void)
 {
     return true;
 }
+
+void kvm_arch_accel_class_init(ObjectClass *oc)
+{
+}
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 3838827134..eab09833f9 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -5472,3 +5472,7 @@ void kvm_request_xsave_components(X86CPU *cpu, uint64_t mask)
         mask &= ~BIT_ULL(bit);
     }
 }
+
+void kvm_arch_accel_class_init(ObjectClass *oc)
+{
+}
diff --git a/target/mips/kvm.c b/target/mips/kvm.c
index caf70decd2..bcb8e06b2c 100644
--- a/target/mips/kvm.c
+++ b/target/mips/kvm.c
@@ -1294,3 +1294,7 @@ bool kvm_arch_cpu_check_are_resettable(void)
 {
     return true;
 }
+
+void kvm_arch_accel_class_init(ObjectClass *oc)
+{
+}
diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
index 466d0d2f4c..7c25348b7b 100644
--- a/target/ppc/kvm.c
+++ b/target/ppc/kvm.c
@@ -2966,3 +2966,7 @@ bool kvm_arch_cpu_check_are_resettable(void)
 {
     return true;
 }
+
+void kvm_arch_accel_class_init(ObjectClass *oc)
+{
+}
diff --git a/target/riscv/kvm.c b/target/riscv/kvm.c
index 70b4cff06f..30f21453d6 100644
--- a/target/riscv/kvm.c
+++ b/target/riscv/kvm.c
@@ -532,3 +532,7 @@ bool kvm_arch_cpu_check_are_resettable(void)
 {
     return true;
 }
+
+void kvm_arch_accel_class_init(ObjectClass *oc)
+{
+}
diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
index 6a8dbadf7e..508c24cfec 100644
--- a/target/s390x/kvm/kvm.c
+++ b/target/s390x/kvm/kvm.c
@@ -2581,3 +2581,7 @@ int kvm_s390_get_zpci_op(void)
 {
     return cap_zpci_op;
 }
+
+void kvm_arch_accel_class_init(ObjectClass *oc)
+{
+}
-- 
2.17.1

