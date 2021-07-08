Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5A6F3BF2FA
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 02:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbhGHA6e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 20:58:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:27077 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230000AbhGHA6e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jul 2021 20:58:34 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10038"; a="209381422"
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="209381422"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 17:55:53 -0700
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="423769999"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 17:55:53 -0700
From:   isaku.yamahata@gmail.com
To:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, xiaoyao.li@intel.com,
        seanjc@google.com, erdemaktas@google.com
Cc:     kvm@vger.kernel.org, isaku.yamahata@gmail.com,
        isaku.yamahata@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH v2 05/44] linux-headers: Update headers to pull in TDX API changes
Date:   Wed,  7 Jul 2021 17:54:35 -0700
Message-Id: <6aee1a3a4d57cf4856fc0733eb01ba8176706773.1625704980.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625704980.git.isaku.yamahata@intel.com>
References: <cover.1625704980.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Xiaoyao Li <xiaoyao.li@intel.com>

Pull in recent TDX updates, which are not backwards compatible.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 linux-headers/asm-x86/kvm.h | 60 +++++++++++++++++++++++++++++++++++++
 linux-headers/linux/kvm.h   |  2 ++
 2 files changed, 62 insertions(+)

diff --git a/linux-headers/asm-x86/kvm.h b/linux-headers/asm-x86/kvm.h
index 0662f644aa..dbcb590fb8 100644
--- a/linux-headers/asm-x86/kvm.h
+++ b/linux-headers/asm-x86/kvm.h
@@ -490,4 +490,64 @@ struct kvm_pmu_event_filter {
 #define KVM_PMU_EVENT_ALLOW 0
 #define KVM_PMU_EVENT_DENY 1
 
+#define KVM_X86_LEGACY_VM	0
+#define KVM_X86_SW_PROTECTED_VM	1
+#define KVM_X86_TDX_VM		2
+
+/* Trust Domain eXtension command*/
+enum kvm_tdx_cmd_id {
+	KVM_TDX_CAPABILITIES = 0,
+	KVM_TDX_INIT_VM,
+	KVM_TDX_INIT_VCPU,
+	KVM_TDX_INIT_MEM_REGION,
+	KVM_TDX_FINALIZE_VM,
+
+	KVM_TDX_CMD_NR_MAX,
+};
+
+struct kvm_tdx_cmd {
+	__u32 id;
+	__u32 metadata;
+	__u64 data;
+};
+
+struct kvm_tdx_cpuid_config {
+	__u32 leaf;
+	__u32 sub_leaf;
+	__u32 eax;
+	__u32 ebx;
+	__u32 ecx;
+	__u32 edx;
+};
+
+struct kvm_tdx_capabilities {
+	__u64 attrs_fixed0;
+	__u64 attrs_fixed1;
+	__u64 xfam_fixed0;
+	__u64 xfam_fixed1;
+
+	__u32 nr_cpuid_configs;
+	__u32 padding;
+	struct kvm_tdx_cpuid_config cpuid_configs[0];
+};
+
+struct kvm_tdx_init_vm {
+	__u32 max_vcpus;
+	__u32 tsc_khz;
+	__u64 attributes;
+	__u64 cpuid;
+	__u64 mrconfigid[6];    /* sha384 digest */
+	__u64 mrowner[6];       /* sha384 digest */
+	__u64 mrownerconfig[6]; /* sha348 digest */
+	__u64 reserved[43];     /* must be zero for future extensibility */
+};
+
+#define KVM_TDX_MEASURE_MEMORY_REGION	(1UL << 0)
+
+struct kvm_tdx_init_mem_region {
+	__u64 source_addr;
+	__u64 gpa;
+	__u64 nr_pages;
+};
+
 #endif /* _ASM_X86_KVM_H */
diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index 20d6a263bb..65ac70d6fd 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -1084,6 +1084,8 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_VM_COPY_ENC_CONTEXT_FROM 197
 #define KVM_CAP_PTP_KVM 198
 
+#define KVM_CAP_VM_TYPES 1000
+
 #ifdef KVM_CAP_IRQ_ROUTING
 
 struct kvm_irq_routing_irqchip {
-- 
2.25.1

