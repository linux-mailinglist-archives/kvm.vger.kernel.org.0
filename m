Return-Path: <kvm+bounces-3256-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D392801C1D
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 11:05:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5931F281E08
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 10:05:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC67915ADB;
	Sat,  2 Dec 2023 10:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oIzpXtFm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 507AB197;
	Sat,  2 Dec 2023 02:05:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701511501; x=1733047501;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=salWrsDL9dpOvmr91p0gKRVzj1lK++JFGh51YeQPB6Q=;
  b=oIzpXtFmjMjZ3HkDSzsUvWt8FnfccUhdTn+CskBij29VX6Pa2Cdt+7XY
   sXFVClfmOJGKMiHUAKtJCuWs3M1Tp3NHMBrSYNanNEqhAbMzDrebyCwPU
   MSNJlY9i7tGr1IJ6DjJ+9/HYNHCYvKHAx+hUYiH4ZJzCaQtIsCZ1diHMy
   8+aKynWhtMI3dO2AAC7Hn2hZgnbI9xatq8N2HvPmdZ1B3mQLRKnsO4IEH
   +sMC1c8TvLqj22F7DUNOIBoOmnlSSqK9cduzkVIyCE2X7hXwYwWwSEFLD
   0mdc3DQgWhDNVUJvhwiKqmMnE8J2jg9rYpdGbfF8nQLNqDRDPvz4DORJC
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10911"; a="457913864"
X-IronPort-AV: E=Sophos;i="6.04,245,1695711600"; 
   d="scan'208";a="457913864"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2023 02:05:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10911"; a="840461606"
X-IronPort-AV: E=Sophos;i="6.04,245,1695711600"; 
   d="scan'208";a="840461606"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2023 02:04:57 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: iommu@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: alex.williamson@redhat.com,
	jgg@nvidia.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	joro@8bytes.org,
	will@kernel.org,
	robin.murphy@arm.com,
	kevin.tian@intel.com,
	baolu.lu@linux.intel.com,
	dwmw2@infradead.org,
	yi.l.liu@intel.com,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH 40/42] KVM: VMX: Compose VMX specific meta data for KVM exported TDP
Date: Sat,  2 Dec 2023 17:36:01 +0800
Message-Id: <20231202093601.15931-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20231202091211.13376-1-yan.y.zhao@intel.com>
References: <20231202091211.13376-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Compose VMX specific meta data of KVM exported TDP. The format of the meta
data is defined in "asm/kvm_exported_tdp.h".

Intel VT-d driver can include "asm/kvm_exported_tdp.h" to decode this meta
data in order to check page table format, level, reserved zero bits before
loading KVM page tables with root HPA.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f290dd3094da6..7965bc32f87de 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -48,6 +48,7 @@
 #include <asm/mwait.h>
 #include <asm/spec-ctrl.h>
 #include <asm/vmx.h>
+#include <asm/kvm_exported_tdp.h>
 
 #include "capabilities.h"
 #include "cpuid.h"
@@ -8216,6 +8217,22 @@ static void vmx_vm_destroy(struct kvm *kvm)
 	free_pages((unsigned long)kvm_vmx->pid_table, vmx_get_pid_table_order(kvm));
 }
 
+#ifdef CONFIG_KVM_INTEL_EXPORTED_EPT
+void kvm_exported_tdp_compose_meta(struct kvm_exported_tdp *tdp)
+{
+	struct kvm_exported_tdp_meta_vmx *meta = tdp->arch.meta;
+	struct kvm_mmu_common *context = &tdp->arch.mmu.common;
+	void *rsvd_bits_mask = context->shadow_zero_check.rsvd_bits_mask;
+
+	meta->root_hpa = context->root.hpa;
+	meta->level = context->root_role.level;
+	meta->max_huge_page_level = min(ept_caps_to_lpage_level(vmx_capability.ept),
+					KVM_MAX_HUGEPAGE_LEVEL);
+	memcpy(meta->rsvd_bits_mask, rsvd_bits_mask, sizeof(meta->rsvd_bits_mask));
+	meta->type = KVM_TDP_TYPE_EPT;
+}
+#endif
+
 static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.name = KBUILD_MODNAME,
 
@@ -8357,6 +8374,11 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.complete_emulated_msr = kvm_complete_insn_gp,
 
 	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
+
+#ifdef CONFIG_KVM_INTEL_EXPORTED_EPT
+	.exported_tdp_meta_size = sizeof(struct kvm_exported_tdp_meta_vmx),
+	.exported_tdp_meta_compose = kvm_exported_tdp_compose_meta,
+#endif
 };
 
 static unsigned int vmx_handle_intel_pt_intr(void)
-- 
2.17.1


