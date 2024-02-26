Return-Path: <kvm+bounces-9698-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B90E9866D13
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:51:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3F11D1F2100B
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 08:51:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B60A69D3F;
	Mon, 26 Feb 2024 08:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z8UzlLYl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 622CC65BD8;
	Mon, 26 Feb 2024 08:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936114; cv=none; b=fi+AvL+LZDB63FCwiO+nfbcFP+wINKU3cLrKlgxIMYCjqbJOr68qlAJ/SxStKpSW9yiV8veMk9qsW9DSe+cHFWtLot89s34kIKZX8CR7HReZvzjINmOFQav7PleglOH/iNwl+Qq3rkMLKf7uiGJhH0RconR5UkMQJ15RHxduwno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936114; c=relaxed/simple;
	bh=25C879RC4XCDozj4CupsIuo0NDO0r8Kx5QkcO4HDod8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NlaWEmBy7fRpg0oPZo7cvJOhBSvkewtueowc5/GzhvZqh3ya6+UrqihNKJyMnwzkxgxC5sC75WGUbBcyrtmxyqp2/N7z/ekKiomVnuvcpTASgaaRNw1wfMNYdSwacYsiaOZZ+wMnsp0kXZcaGkQ3qDoIXc6+BLu05d1zZg0bixw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z8UzlLYl; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936113; x=1740472113;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=25C879RC4XCDozj4CupsIuo0NDO0r8Kx5QkcO4HDod8=;
  b=Z8UzlLYlxoCAbVxVkWufi7J+AJqDBmsxdqHiKphHcbZPKdBApgQ5JUlT
   iqONuLrbzvVL0BtTSqb8JLHPFbvhZ+qBrbQshiiGt8unPIaR+i4wD6zbF
   bht7QaaZRqAujTaXeaUWshtTQRHV4cCZdW/xScC0ZdZEQwl0mh1XWXZKN
   5bqBLjGRrJCyg7a9gMRWHlIlJWNYEGnOxC13+LysGFnt8c/rz/mo4S7R2
   T+3+MVmUx+UErx+KaNEPga4Ujyk82t32j4zKlVj4P8hAJJAzuNsbT2jMh
   T6YmohGkQbZBHPLdMUjVX9F2iiOCZc77ix3yWe+hY2u8kpMWVa7i40jzm
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="3069484"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="3069484"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="11272466"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:32 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com
Subject: [PATCH v19 074/130] KVM: TDX: Create initial guest memory
Date: Mon, 26 Feb 2024 00:26:16 -0800
Message-Id: <bbac4998cfb34da496646491038b03f501964cbd.1708933498.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1708933498.git.isaku.yamahata@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Because the guest memory is protected in TDX, the creation of the initial
guest memory requires a dedicated TDX module API, tdh_mem_page_add, instead
of directly copying the memory contents into the guest memory in the case
of the default VM type.  KVM MMU page fault handler callback,
set_private_spte, handles it.

Implement the hooks for KVM_MEMORY_MAPPING, pre_memory_mapping() and
post_memory_mapping() to handle it.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
v19:
- Switched to use KVM_MEMORY_MAPPING
- Dropped measurement extension
- updated commit message. private_page_add() => set_private_spte()
---
 arch/x86/kvm/vmx/main.c    | 23 ++++++++++
 arch/x86/kvm/vmx/tdx.c     | 93 ++++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/vmx/tdx.h     |  4 ++
 arch/x86/kvm/vmx/x86_ops.h | 12 +++++
 4 files changed, 129 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index c5672909fdae..7258a6304b4b 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -252,6 +252,27 @@ static int vt_gmem_max_level(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn,
 	return 0;
 }
 
+static int vt_pre_memory_mapping(struct kvm_vcpu *vcpu,
+				 struct kvm_memory_mapping *mapping,
+				 u64 *error_code, u8 *max_level)
+{
+	if (is_td_vcpu(vcpu))
+		return tdx_pre_memory_mapping(vcpu, mapping, error_code, max_level);
+
+	if (mapping->source)
+		return -EINVAL;
+	return 0;
+}
+
+static void vt_post_memory_mapping(struct kvm_vcpu *vcpu,
+				   struct kvm_memory_mapping *mapping)
+{
+	if (!is_td_vcpu(vcpu))
+		return;
+
+	tdx_post_memory_mapping(vcpu, mapping);
+}
+
 #define VMX_REQUIRED_APICV_INHIBITS				\
 	(BIT(APICV_INHIBIT_REASON_DISABLE)|			\
 	 BIT(APICV_INHIBIT_REASON_ABSENT) |			\
@@ -415,6 +436,8 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.vcpu_mem_enc_ioctl = vt_vcpu_mem_enc_ioctl,
 
 	.gmem_max_level = vt_gmem_max_level,
+	.pre_memory_mapping = vt_pre_memory_mapping,
+	.post_memory_mapping = vt_post_memory_mapping,
 };
 
 struct kvm_x86_init_ops vt_init_ops __initdata = {
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index e65fff43cb1b..8cf6e5dab3e9 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -390,6 +390,7 @@ int tdx_vm_init(struct kvm *kvm)
 	 */
 	kvm->max_vcpus = min(kvm->max_vcpus, TDX_MAX_VCPUS);
 
+	mutex_init(&to_kvm_tdx(kvm)->source_lock);
 	return 0;
 }
 
@@ -541,6 +542,51 @@ static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
 	return 0;
 }
 
+static int tdx_mem_page_add(struct kvm *kvm, gfn_t gfn,
+			    enum pg_level level, kvm_pfn_t pfn)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	hpa_t hpa = pfn_to_hpa(pfn);
+	gpa_t gpa = gfn_to_gpa(gfn);
+	struct tdx_module_args out;
+	hpa_t source_pa;
+	u64 err;
+
+	lockdep_assert_held(&kvm_tdx->source_lock);
+
+	/*
+	 * KVM_MEMORY_MAPPING for TD supports only 4K page because
+	 * tdh_mem_page_add() supports only 4K page.
+	 */
+	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
+		return -EINVAL;
+
+	if (KVM_BUG_ON(!kvm_tdx->source_page, kvm)) {
+		tdx_unpin(kvm, pfn);
+		return -EINVAL;
+	}
+
+	source_pa = pfn_to_hpa(page_to_pfn(kvm_tdx->source_page));
+	do {
+		err = tdh_mem_page_add(kvm_tdx->tdr_pa, gpa, hpa, source_pa,
+				       &out);
+		/*
+		 * This path is executed during populating initial guest memory
+		 * image. i.e. before running any vcpu.  Race is rare.
+		 */
+	} while (unlikely(err == TDX_ERROR_SEPT_BUSY));
+	/*
+	 * Don't warn: This is for KVM_MEMORY_MAPPING. So tdh_mem_page_add() can
+	 * fail with parameters user provided.
+	 */
+	if (err) {
+		tdx_unpin(kvm, pfn);
+		return -EIO;
+	}
+
+	return 0;
+}
+
 static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 				     enum pg_level level, kvm_pfn_t pfn)
 {
@@ -563,9 +609,7 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 	if (likely(is_td_finalized(kvm_tdx)))
 		return tdx_mem_page_aug(kvm, gfn, level, pfn);
 
-	/* TODO: tdh_mem_page_add() comes here for the initial memory. */
-
-	return 0;
+	return tdx_mem_page_add(kvm, gfn, level, pfn);
 }
 
 static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
@@ -1469,6 +1513,49 @@ int tdx_gmem_max_level(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn,
 	return 0;
 }
 
+#define TDX_SEPT_PFERR	(PFERR_WRITE_MASK | PFERR_GUEST_ENC_MASK)
+
+int tdx_pre_memory_mapping(struct kvm_vcpu *vcpu,
+			   struct kvm_memory_mapping *mapping,
+			   u64 *error_code, u8 *max_level)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
+	struct page *page;
+	int r = 0;
+
+	/* memory contents is needed for encryption. */
+	if (!mapping->source)
+		return -EINVAL;
+
+	/* Once TD is finalized, the initial guest memory is fixed. */
+	if (is_td_finalized(to_kvm_tdx(vcpu->kvm)))
+		return -EINVAL;
+
+	/* TDX supports only 4K to pre-populate. */
+	*max_level = PG_LEVEL_4K;
+	*error_code = TDX_SEPT_PFERR;
+
+	r = get_user_pages_fast(mapping->source, 1, 0, &page);
+	if (r < 0)
+		return r;
+	if (r != 1)
+		return -ENOMEM;
+
+	mutex_lock(&kvm_tdx->source_lock);
+	kvm_tdx->source_page = page;
+	return 0;
+}
+
+void tdx_post_memory_mapping(struct kvm_vcpu *vcpu,
+			     struct kvm_memory_mapping *mapping)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
+
+	put_page(kvm_tdx->source_page);
+	kvm_tdx->source_page = NULL;
+	mutex_unlock(&kvm_tdx->source_lock);
+}
+
 #define TDX_MD_MAP(_fid, _ptr)			\
 	{ .fid = MD_FIELD_ID_##_fid,		\
 	  .ptr = (_ptr), }
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 75596b9dcf3f..d822e790e3e5 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -21,6 +21,10 @@ struct kvm_tdx {
 	atomic_t tdh_mem_track;
 
 	u64 tsc_offset;
+
+	/* For KVM_MEMORY_MAPPING */
+	struct mutex source_lock;
+	struct page *source_page;
 };
 
 struct vcpu_tdx {
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 5335d35bc655..191f2964ec8e 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -160,6 +160,11 @@ int tdx_sept_flush_remote_tlbs(struct kvm *kvm);
 void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level);
 int tdx_gmem_max_level(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn,
 		       bool is_private, u8 *max_level);
+int tdx_pre_memory_mapping(struct kvm_vcpu *vcpu,
+			   struct kvm_memory_mapping *mapping,
+			   u64 *error_code, u8 *max_level);
+void tdx_post_memory_mapping(struct kvm_vcpu *vcpu,
+			     struct kvm_memory_mapping *mapping);
 #else
 static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return -EOPNOTSUPP; }
 static inline void tdx_hardware_unsetup(void) {}
@@ -192,6 +197,13 @@ static inline int tdx_gmem_max_level(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn,
 {
 	return -EOPNOTSUPP;
 }
+int tdx_pre_memory_mapping(struct kvm_vcpu *vcpu,
+			   struct kvm_memory_mapping *mapping,
+			   u64 *error_code, u8 *max_level)
+{
+	return -EOPNOTSUPP;
+}
+void tdx_post_memory_mapping(struct kvm_vcpu *vcpu, struct kvm_memory_mapping *mapping) {}
 #endif
 
 #endif /* __KVM_X86_VMX_X86_OPS_H */
-- 
2.25.1


