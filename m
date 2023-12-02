Return-Path: <kvm+bounces-3218-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 62328801BC0
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 10:44:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C500AB20E20
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 09:44:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7F94125DC;
	Sat,  2 Dec 2023 09:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jX5SEbC7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A322D134;
	Sat,  2 Dec 2023 01:44:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701510250; x=1733046250;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=USlqd3EMMW16iV2fDYRyDyMhXnAPYPczuIPu2d6BNb0=;
  b=jX5SEbC74aFHJecVVTiCJTOY+Pt/jWQ8UiSj4vnW1eIyWNWYs81zSLIG
   sIc4+4RJyPASsSJRR/+8npA2etrkDOMxiK49PraGEKkbF/pZKMztQk2TT
   8g1tkA32BAAL3/WtfMN5K6aotm/hvjxJIL00mv47O+AE4wCP/0yW1qXIV
   PWVi/0BgDQggis2aeuc5pSrgYD2y1pf3fXk9JhhTl/MqylbF3Kj088j8e
   GaaumgWkTZFP8Q5+ook68MxEKEO/sHaTNMuV1VsMAkL6ZkiAk7S23aGpa
   a9BN9kCkAi6aaHmN0i9L2b5hr/C74KHO0PzEiJHRkSxoBTRen2i74AhfE
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10911"; a="444223"
X-IronPort-AV: E=Sophos;i="6.04,245,1695711600"; 
   d="scan'208";a="444223"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2023 01:44:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10911"; a="943354101"
X-IronPort-AV: E=Sophos;i="6.04,245,1695711600"; 
   d="scan'208";a="943354101"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2023 01:44:05 -0800
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
Subject: [RFC PATCH 02/42] KVM: x86: Arch header for kvm to export TDP for Intel
Date: Sat,  2 Dec 2023 17:15:04 +0800
Message-Id: <20231202091504.13502-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20231202091211.13376-1-yan.y.zhao@intel.com>
References: <20231202091211.13376-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Headers to define Intel specific meta data for TDP page tables exported by
KVM.
The meta data includes page table type, level, HPA of root page, max huge
page level, and reserved zero bits currently.
(Note, each vendor can define their own meta data format .e.g. it could be
kvm_exported_tdp_meta_svm on AMD platform.)

The consumer of the exported TDP (e.g. Intel vt-d driver) can retrieve and
check the vendor specific meta data before loading the KVM exported TDP
page tables to their own secondary MMU.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/include/asm/kvm_exported_tdp.h | 43 +++++++++++++++++++++++++
 include/linux/kvm_types.h               | 12 +++++++
 2 files changed, 55 insertions(+)
 create mode 100644 arch/x86/include/asm/kvm_exported_tdp.h

diff --git a/arch/x86/include/asm/kvm_exported_tdp.h b/arch/x86/include/asm/kvm_exported_tdp.h
new file mode 100644
index 0000000000000..c7fe3f3cf89fb
--- /dev/null
+++ b/arch/x86/include/asm/kvm_exported_tdp.h
@@ -0,0 +1,43 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_X86_KVM_EXPORTED_TDP_H
+#define _ASM_X86_KVM_EXPORTED_TDP_H
+#define PT64_ROOT_MAX_LEVEL 5
+
+#include <linux/kvm_types.h>
+/**
+ * struct kvm_exported_tdp_meta_vmx - Intel specific meta data format of TDP
+ *                                    page tables exported by KVM.
+ *
+ * Importers of KVM exported TDPs can decode meta data of the page tables with
+ * this structure.
+ *
+ * @type:                Type defined across platforms to identify hardware
+ *                       platform of a KVM exported TDP. Importers of KVM
+ *                       exported TDP need to first check the type before
+ *                       decoding page table meta data.
+ * @level:               Levels of the TDP exported by KVM.
+ * @root_hpa:            HPA of the root page of TDP exported by KVM.
+ * @max_huge_page_level: Max huge page level allowed on the TDP exported by KVM.
+ * @rsvd_bits_mask:      The must-be-zero bits of leaf and non-leaf PTEs.
+ *                       rsvd_bits_mask[0] or rsvd_bits_mask[1] is selected by
+ *                       bit 7 or a PTE.
+ *                       This field is provided as a way for importers to check
+ *                       if the must-be-zero bits from KVM is compatible to the
+ *                       importer side. KVM will ensure that the must-be-zero
+ *                       bits must not be set even for software purpose.
+ *                       (e.g. on Intel platform, bit 11 is usually used by KVM
+ *                       to identify a present SPTE, though bit 11 is ignored by
+ *                       EPT. However, Intel vt-d requires the bit 11 to be 0.
+ *                       Before importing KVM TDP, Intel vt-d driver needs to
+ *                       check if bit 11 is set in the must-be-zero bits by KVM
+ *                       to avoid possible DMAR fault.)
+ */
+struct kvm_exported_tdp_meta_vmx {
+	enum kvm_exported_tdp_type type;
+	int level;
+	hpa_t root_hpa;
+	int max_huge_page_level;
+	u64 rsvd_bits_mask[2][PT64_ROOT_MAX_LEVEL];
+};
+
+#endif
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index 6f4737d5046a4..04deb8334ce42 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -123,4 +123,16 @@ struct kvm_vcpu_stat_generic {
 
 #define KVM_STATS_NAME_SIZE	48
 
+/**
+ * enum kvm_exported_tdp_type - Type defined across platforms for TDP exported
+ *                              by KVM.
+ *
+ * @KVM_TDP_TYPE_EPT: The TDP is of type EPT running on Intel platform.
+ *
+ * Currently, @KVM_TDP_TYPE_EPT is the only supported type for TDPs exported by
+ * KVM.
+ */
+enum kvm_exported_tdp_type {
+	KVM_TDP_TYPE_EPT = 1,
+};
 #endif /* __KVM_TYPES_H__ */
-- 
2.17.1


