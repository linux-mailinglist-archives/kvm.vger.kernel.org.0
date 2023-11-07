Return-Path: <kvm+bounces-923-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BA5947E4271
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 16:00:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 61166280FB0
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 15:00:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23B3B31594;
	Tue,  7 Nov 2023 14:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n25n87/Y"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 809EE30D0C
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 14:58:23 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ADBE1730;
	Tue,  7 Nov 2023 06:58:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699369094; x=1730905094;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gSN36tsOA+JmXtdzysv6finL0yWfkWR8vDgBn9N4SDQ=;
  b=n25n87/YDGmJ0jkGzkmOUpuOZt/ZbPfO9CpTmCYZZ9Ymn2ggCQ56rIF3
   XBk75/axvOU5BOL2v2PcLR+gK4Squc7iQzGeNFQJM+lcZhNcwKl8TGNkI
   iKQ3cj9ZIzyEkXHcUWFaLrY3VMVtg2mTGjL2pkq8yipLfW97aFcTMxQUz
   09DUqwUZqKcw/wjdEnPBFSFaAZ267FwKNemV4R1BseMJ4o7i7yMsKUPtU
   GxE3ufm2NTumEpntyMM0qOsN/ngnGGpWU+qlm/ui4r4/FhhPjWpQ8DEfC
   OEIQQO6Suv9HhApGEJSWi9kgvsmwOK2VbMW6JWy0qI1P6b0OIGxxdjPEb
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10887"; a="2462189"
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="2462189"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:58:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="10851260"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:58:06 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	David Matlack <dmatlack@google.com>,
	Kai Huang <kai.huang@intel.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com,
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [PATCH v17 029/116] KVM: x86/mmu: Add address conversion functions for TDX shared bit of GPA
Date: Tue,  7 Nov 2023 06:55:55 -0800
Message-Id: <6457cfa5898ae1ab0effb2dd95a3ad9da7fd45f5.1699368322.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1699368322.git.isaku.yamahata@intel.com>
References: <cover.1699368322.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDX repurposes one GPA bit (51 bit or 47 bit based on configuration) to
indicate the GPA is private(if cleared) or shared (if set) with VMM.  If
GPA.shared is set, GPA is covered by the existing conventional EPT pointed
by EPTP.  If GPA.shared bit is cleared, GPA is covered by TDX module.
VMM has to issue SEAMCALLs to operate.

Add a member to remember GPA shared bit for each guest TDs, add address
conversion functions between private GPA and shared GPA and test if GPA
is private.

Because struct kvm_arch (or struct kvm which includes struct kvm_arch. See
kvm_arch_alloc_vm() that passes __GPF_ZERO) is zero-cleared when allocated,
the new member to remember GPA shared bit is guaranteed to be zero with
this patch unless it's initialized explicitly.

Co-developed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  4 ++++
 arch/x86/kvm/mmu.h              | 27 +++++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx.c          |  5 +++++
 3 files changed, 36 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 78aa844f4dba..babdc3a6ba5e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1475,6 +1475,10 @@ struct kvm_arch {
 	 */
 #define SPLIT_DESC_CACHE_MIN_NR_OBJECTS (SPTE_ENT_PER_PAGE + 1)
 	struct kvm_mmu_memory_cache split_desc_cache;
+
+#ifdef CONFIG_KVM_MMU_PRIVATE
+	gfn_t gfn_shared_mask;
+#endif
 };
 
 struct kvm_vm_stat {
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index bb8c86eefac0..f64bb734fbb6 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -311,4 +311,31 @@ static inline gpa_t kvm_translate_gpa(struct kvm_vcpu *vcpu,
 		return gpa;
 	return translate_nested_gpa(vcpu, gpa, access, exception);
 }
+
+static inline gfn_t kvm_gfn_shared_mask(const struct kvm *kvm)
+{
+#ifdef CONFIG_KVM_MMU_PRIVATE
+	return kvm->arch.gfn_shared_mask;
+#else
+	return 0;
+#endif
+}
+
+static inline gfn_t kvm_gfn_to_shared(const struct kvm *kvm, gfn_t gfn)
+{
+	return gfn | kvm_gfn_shared_mask(kvm);
+}
+
+static inline gfn_t kvm_gfn_to_private(const struct kvm *kvm, gfn_t gfn)
+{
+	return gfn & ~kvm_gfn_shared_mask(kvm);
+}
+
+static inline bool kvm_is_private_gpa(const struct kvm *kvm, gpa_t gpa)
+{
+	gfn_t mask = kvm_gfn_shared_mask(kvm);
+
+	return mask && !(gpa_to_gfn(gpa) & mask);
+}
+
 #endif
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index c1a8560981a3..fe793425d393 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -878,6 +878,11 @@ static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 	kvm_tdx->attributes = td_params->attributes;
 	kvm_tdx->xfam = td_params->xfam;
 
+	if (td_params->exec_controls & TDX_EXEC_CONTROL_MAX_GPAW)
+		kvm->arch.gfn_shared_mask = gpa_to_gfn(BIT_ULL(51));
+	else
+		kvm->arch.gfn_shared_mask = gpa_to_gfn(BIT_ULL(47));
+
 out:
 	/* kfree() accepts NULL. */
 	kfree(init_vm);
-- 
2.25.1


