Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74C8D5A0799
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 05:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232272AbiHYD0H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Aug 2022 23:26:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232235AbiHYD0F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Aug 2022 23:26:05 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BFA23F337
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 20:26:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661397961; x=1692933961;
  h=from:to:cc:subject:date:message-id;
  bh=QfU5n0LNLrsAsHbr2o9JAswWSZVSgNUI7m3XVlMIrJw=;
  b=BxKFdkIqVn+T6NARu7Ryz9Lu5xUNcDaZZMFofKILMEguESvQIVjMIU6o
   x2OhKAAzh/RMh5IrlxZXC2eRKa/6JS1UQppzm1em7dxNPsuuf9QW/VKPL
   XsZBcOHdCSiRE9JwbJIHH2Z3lWSV6Rk1B6wKA8FgfPh5Elhy87S/QJNjq
   G9ezlrMikJdtEsmJlYkcBTkgA9PNeZWTmNqtehD/e/ivK5dC3B+wZ8WK+
   Ighz69d1BTVg4qR+GSsaWKmcgbi4b8uydkJGEiDS71fLTt+0d6cQCwSA+
   NesQECV+iLZ5pb58LUWZuKKRASD/AsoGcDQ2xPp8FDevXW/Lstnbo8jG9
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10449"; a="277155882"
X-IronPort-AV: E=Sophos;i="5.93,262,1654585200"; 
   d="scan'208";a="277155882"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2022 20:26:00 -0700
X-IronPort-AV: E=Sophos;i="5.93,262,1654585200"; 
   d="scan'208";a="670792058"
Received: from arthur-vostro-3668.sh.intel.com ([10.238.200.53])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2022 20:25:50 -0700
From:   Zeng Guang <guang.zeng@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Gao Chao <chao.gao@intel.com>,
        Zeng Guang <guang.zeng@intel.com>
Subject: [PATCH v3] target/i386: Set maximum APIC ID to KVM prior to vCPU creation
Date:   Thu, 25 Aug 2022 10:52:46 +0800
Message-Id: <20220825025246.26618-1-guang.zeng@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Specify maximum possible APIC ID assigned for current VM session to KVM
prior to the creation of vCPUs. By this setting, KVM can set up VM-scoped
data structure indexed by the APIC ID, e.g. Posted-Interrupt Descriptor
pointer table to support Intel IPI virtualization, with the most optimal
memory footprint.

It can be achieved by calling KVM_ENABLE_CAP for KVM_CAP_MAX_VCPU_ID
capability once KVM has enabled it. Ignoring the return error if KVM
doesn't support this capability yet.

Signed-off-by: Zeng Guang <guang.zeng@intel.com>
---
 hw/i386/x86.c              | 4 ++++
 target/i386/kvm/kvm-stub.c | 5 +++++
 target/i386/kvm/kvm.c      | 5 +++++
 target/i386/kvm/kvm_i386.h | 1 +
 4 files changed, 15 insertions(+)

diff --git a/hw/i386/x86.c b/hw/i386/x86.c
index 050eedc0c8..4831193c86 100644
--- a/hw/i386/x86.c
+++ b/hw/i386/x86.c
@@ -139,6 +139,10 @@ void x86_cpus_init(X86MachineState *x86ms, int default_cpu_version)
         exit(EXIT_FAILURE);
     }
 
+    if (kvm_enabled()) {
+        kvm_set_max_apic_id(x86ms->apic_id_limit);
+    }
+
     possible_cpus = mc->possible_cpu_arch_ids(ms);
     for (i = 0; i < ms->smp.cpus; i++) {
         x86_cpu_new(x86ms, possible_cpus->cpus[i].arch_id, &error_fatal);
diff --git a/target/i386/kvm/kvm-stub.c b/target/i386/kvm/kvm-stub.c
index f6e7e4466e..e052f1c7b0 100644
--- a/target/i386/kvm/kvm-stub.c
+++ b/target/i386/kvm/kvm-stub.c
@@ -44,3 +44,8 @@ bool kvm_hyperv_expand_features(X86CPU *cpu, Error **errp)
 {
     abort();
 }
+
+void kvm_set_max_apic_id(uint32_t max_apic_id)
+{
+    return;
+}
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index f148a6d52f..af4ef1e8f0 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -5428,3 +5428,8 @@ void kvm_request_xsave_components(X86CPU *cpu, uint64_t mask)
         mask &= ~BIT_ULL(bit);
     }
 }
+
+void kvm_set_max_apic_id(uint32_t max_apic_id)
+{
+    kvm_vm_enable_cap(kvm_state, KVM_CAP_MAX_VCPU_ID, 0, max_apic_id);
+}
diff --git a/target/i386/kvm/kvm_i386.h b/target/i386/kvm/kvm_i386.h
index 4124912c20..c133b32a58 100644
--- a/target/i386/kvm/kvm_i386.h
+++ b/target/i386/kvm/kvm_i386.h
@@ -54,4 +54,5 @@ uint64_t kvm_swizzle_msi_ext_dest_id(uint64_t address);
 bool kvm_enable_sgx_provisioning(KVMState *s);
 void kvm_request_xsave_components(X86CPU *cpu, uint64_t mask);
 
+void kvm_set_max_apic_id(uint32_t max_apic_id);
 #endif
-- 
2.27.0

