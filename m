Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82C47530CB2
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 12:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233437AbiEWJqe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 05:46:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233706AbiEWJox (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 05:44:53 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CA88626D
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 02:44:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653299092; x=1684835092;
  h=from:to:cc:subject:date:message-id;
  bh=g+69TL0yWtedPp0wWzH3au9MmScHvimfXrzMzJNXrWI=;
  b=Z7Ulxi6bOJiqVCbl67M4uxKzXFdCfUML2XiI3FuyzLxKKXoHu+2BuFog
   30NWWLH04NOJjRGQ0RL0RNGYBGherq+RBl/rDDfUhGpWztjAN3ozcFlKW
   DlA+51j86gOaAiuSCletkHyKA4PXOFcoM0GchnSJFW3dahu5HFHsmezU3
   LzkGoo1K/7Wg8jYBwK0gOyRZLE+zvhvI++bQQ+u/796O/kQ27QKtHJXiP
   hAF34GW/01lajgOYSlkNr94tGyFwbs2/H2opOOqZa4ZUgZj6W3gprq9QS
   RnRU/0Zfh9Zt+j1mrButrMEXIVeYaGKy1uZhNDAGxk7nYiz8vjPBG8hUO
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10355"; a="270737452"
X-IronPort-AV: E=Sophos;i="5.91,246,1647327600"; 
   d="scan'208";a="270737452"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2022 02:44:52 -0700
X-IronPort-AV: E=Sophos;i="5.91,246,1647327600"; 
   d="scan'208";a="600553709"
Received: from arthur-vostro-3668.sh.intel.com ([10.239.13.120])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2022 02:44:49 -0700
From:   Zeng Guang <guang.zeng@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Gao Chao <chao.gao@intel.com>,
        Zeng Guang <guang.zeng@intel.com>
Subject: [QEMU PATCH v2] x86: Set maximum APIC ID to KVM prior to vCPU creation
Date:   Mon, 23 May 2022 17:12:39 +0800
Message-Id: <20220523091239.7053-1-guang.zeng@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Specify maximum possible APIC ID assigned for current VM session to KVM
prior to the creation of vCPUs. By this setting, KVM can set up VM-scoped
data structure indexed by the APIC ID, e.g. Posted-Interrupt Descriptor
table to support Intel IPI virtualization, with the most optimal memory
footprint.

It can be achieved by calling KVM_ENABLE_CAP for KVM_CAP_MAX_VCPU_ID
capability once KVM has already enabled it. Ignoring the return error
if KVM doesn't support this capability yet.

Signed-off-by: Zeng Guang <guang.zeng@intel.com>
---
 hw/i386/x86.c              | 5 +++++
 target/i386/kvm/kvm.c      | 5 +++++
 target/i386/kvm/kvm_i386.h | 1 +
 3 files changed, 11 insertions(+)

diff --git a/hw/i386/x86.c b/hw/i386/x86.c
index 4cf107baea..a6ab406f85 100644
--- a/hw/i386/x86.c
+++ b/hw/i386/x86.c
@@ -123,6 +123,11 @@ void x86_cpus_init(X86MachineState *x86ms, int default_cpu_version)
      */
     x86ms->apic_id_limit = x86_cpu_apic_id_from_index(x86ms,
                                                       ms->smp.max_cpus - 1) + 1;
+
+    if (kvm_enabled()) {
+        kvm_set_max_apic_id(x86ms->apic_id_limit);
+    }
+
     possible_cpus = mc->possible_cpu_arch_ids(ms);
     for (i = 0; i < ms->smp.cpus; i++) {
         x86_cpu_new(x86ms, possible_cpus->cpus[i].arch_id, &error_fatal);
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 9cf8e03669..cb2fe39365 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -5251,3 +5251,8 @@ void kvm_request_xsave_components(X86CPU *cpu, uint64_t mask)
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

