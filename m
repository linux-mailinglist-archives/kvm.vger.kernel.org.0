Return-Path: <kvm+bounces-3242-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F1F4801BF6
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 10:57:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 58DD0281C42
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 09:57:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60A6C14F98;
	Sat,  2 Dec 2023 09:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XWDZVrUQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 601D4181;
	Sat,  2 Dec 2023 01:57:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701511044; x=1733047044;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=juntWTT8wckOCqH1OE3wLmKIfNnolWpXdTK3qwEkqLY=;
  b=XWDZVrUQic7KQgcyyYqGRqZLIG2kJJ3CD0a5dIkTcQt6Xa4/b1Nyz/SV
   DwFUpmJfmi6JwHnvOI71w2n179mVKUs4YeSpcCTGL3mdSJP1l7ivjpKqE
   LKK0yjYo/0CJ6EWBdJx4VALeGF7QILUmRBig0xni7zUZLBI/i53f+Phsm
   vGhtR9GWGu8XJ/8XrQa4CmbUbNhT5CrwBOJLkEFGAnTgJoZ2YS3ovFj6w
   PATLLpWKCbOhQDCd4m3ozSak7YtuFUfhMqbRx8QCWlkYrm6dd/7vCl6lU
   Xo6C/zYnErami3Ad5BQacnEpTMn/DdNIl+RDt5CE0xM2FDkMcqiQxPDBT
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10911"; a="457913602"
X-IronPort-AV: E=Sophos;i="6.04,245,1695711600"; 
   d="scan'208";a="457913602"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2023 01:57:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10911"; a="840460946"
X-IronPort-AV: E=Sophos;i="6.04,245,1695711600"; 
   d="scan'208";a="840460946"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2023 01:57:19 -0800
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
Subject: [RFC PATCH 26/42] KVM: x86/mmu: introduce new op get_default_mt_mask to kvm_x86_ops
Date: Sat,  2 Dec 2023 17:28:25 +0800
Message-Id: <20231202092825.15041-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20231202091211.13376-1-yan.y.zhao@intel.com>
References: <20231202091211.13376-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Introduce a new op get_default_mt_mask to kvm_x86_ops to get default memory
types when no non-coherent DMA devices are attached.

For VMX, when there's no non-coherent DMA devices, guest MTRRs and vCPUs
CR0.CD mode are not queried to get memory types of EPT. So, introduce a
new op get_default_mt_mask that does not require param "vcpu" to get memory
types.

This is a preparation patch for later KVM MMU to export TDP, because IO
page fault requests are in non-vcpu context and have no "vcpu" to get
memory type from op get_mt_mask.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/kvm/vmx/vmx.c             | 11 +++++++++++
 3 files changed, 13 insertions(+)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 26b628d84594b..d751407b1056c 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -92,6 +92,7 @@ KVM_X86_OP_OPTIONAL(sync_pir_to_irr)
 KVM_X86_OP_OPTIONAL_RET0(set_tss_addr)
 KVM_X86_OP_OPTIONAL_RET0(set_identity_map_addr)
 KVM_X86_OP_OPTIONAL_RET0(get_mt_mask)
+KVM_X86_OP_OPTIONAL_RET0(get_default_mt_mask)
 KVM_X86_OP(load_mmu_pgd)
 KVM_X86_OP(has_wbinvd_exit)
 KVM_X86_OP(get_l2_tsc_offset)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 16e01eee34a99..1f6ac04e0f952 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1679,6 +1679,7 @@ struct kvm_x86_ops {
 	int (*set_tss_addr)(struct kvm *kvm, unsigned int addr);
 	int (*set_identity_map_addr)(struct kvm *kvm, u64 ident_addr);
 	u8 (*get_mt_mask)(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
+	u8 (*get_default_mt_mask)(struct kvm *kvm, bool is_mmio);
 
 	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 			     int root_level);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1cc717a718e9c..f290dd3094da6 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7614,6 +7614,16 @@ static u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 	return kvm_mtrr_get_guest_memory_type(vcpu, gfn) << VMX_EPT_MT_EPTE_SHIFT;
 }
 
+static u8 vmx_get_default_mt_mask(struct kvm *kvm, bool is_mmio)
+{
+	WARN_ON(kvm_arch_has_noncoherent_dma(kvm));
+
+	if (is_mmio)
+		return MTRR_TYPE_UNCACHABLE << VMX_EPT_MT_EPTE_SHIFT;
+
+	return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
+}
+
 static void vmcs_set_secondary_exec_control(struct vcpu_vmx *vmx, u32 new_ctl)
 {
 	/*
@@ -8295,6 +8305,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.set_tss_addr = vmx_set_tss_addr,
 	.set_identity_map_addr = vmx_set_identity_map_addr,
 	.get_mt_mask = vmx_get_mt_mask,
+	.get_default_mt_mask = vmx_get_default_mt_mask,
 
 	.get_exit_info = vmx_get_exit_info,
 
-- 
2.17.1


