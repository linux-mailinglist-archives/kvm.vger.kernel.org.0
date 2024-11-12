Return-Path: <kvm+bounces-31582-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A478C9C4FC1
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 08:45:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 693AE2830BE
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 07:45:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24A48213EE8;
	Tue, 12 Nov 2024 07:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dXGsbST2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF32920C03D;
	Tue, 12 Nov 2024 07:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731397249; cv=none; b=SY9I2D90EOD9VgQAH/hh9MMiGU84tVmxDoakLWOhDr3xn4jcwIi9yZlSW6a1E/88zEMkMSDiOI8QaBBug+C9X2dqNAuilsm9kUNaI/au1+4VgIkXNsQpG3iOL32nxBP+g0kxc8aaGE/5y5m7EJh6TgIHtM5t9DfFUwXQsRtIZDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731397249; c=relaxed/simple;
	bh=7t0ccS7gH3OWd/7wU0XQ8THGzqp4LvQk2C6Q3mrvDLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z9boFEHhYqnWJsAvt5r/XweAg6S915DetSH0QxTwkmF3lc6L7QLQi/YQKEgFBhGVcumh+jtiOEHW7zSTbwbCUBUDHN570SBjJoPmFfn6SbP60zXj9xbt7hMsjdBiFvwcN2S/aKloOlApIvCs4MDyl00Vbz9Ro/Z90jiMkvle3T8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dXGsbST2; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731397248; x=1762933248;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7t0ccS7gH3OWd/7wU0XQ8THGzqp4LvQk2C6Q3mrvDLQ=;
  b=dXGsbST2lFxW3QNbcPbI/clsAQya22n0qjSs6Yttyb15xWJ3lq+LYGYU
   eeVOPk1vzpIgBCa7Wtll0jHmHWDN+2qhQP3GyFfssQkbdblmhMaNaYPiu
   4kqHYbnjT+8yLPMW8u2IB8fFLY7tBIndJEbF1bv6E39AuSvBHCsJXmclS
   IVW+SBqZvLivc00oSB+2d7AXyoek7GOEQ8HnkVROxw+zWMDheImas2tlw
   f2A37ZFN2jloqHPBRTBfn3j8aUqefkA0BTvwwsXyZ8/7KDXhOdLBMu+j8
   fV8PbAzFZRLZjKsEo6yaLsDDLfb38e36Lmo91voJQ4IOGUgBvRIks1td7
   w==;
X-CSE-ConnectionGUID: GMxBp4XETg2RP7kApJdKOw==
X-CSE-MsgGUID: Go754VkXQIaxK6x6dUtAnA==
X-IronPort-AV: E=McAfee;i="6700,10204,11253"; a="42598890"
X-IronPort-AV: E=Sophos;i="6.12,147,1728975600"; 
   d="scan'208";a="42598890"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 23:40:46 -0800
X-CSE-ConnectionGUID: 81R8YG8aSmupKs4lXuCnIg==
X-CSE-MsgGUID: hIgTE4UkTCG/bTNOXQPCww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,147,1728975600"; 
   d="scan'208";a="87427089"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 23:40:43 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org,
	dave.hansen@linux.intel.com
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	binbin.wu@linux.intel.com,
	dmatlack@google.com,
	isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	nik.borisov@suse.com,
	linux-kernel@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH v2 19/24] KVM: TDX: Implement hook to get max mapping level of private pages
Date: Tue, 12 Nov 2024 15:38:16 +0800
Message-ID: <20241112073816.22256-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20241112073327.21979-1-yan.y.zhao@intel.com>
References: <20241112073327.21979-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Implement hook private_max_mapping_level for TDX to let TDP MMU core get
max mapping level of private pages.

The value is hard coded to 4K for no huge page support for now.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
TDX MMU part 2 v2:
 - Added Paolo's rb.

TDX MMU part 2 v1:
 - Split from the big patch "KVM: TDX: TDP MMU TDX support".
 - Fix missing tdx_gmem_private_max_mapping_level() implementation for
   !CONFIG_INTEL_TDX_HOST

v19:
 - Use gmem_max_level callback, delete tdp_max_page_level.
---
 arch/x86/kvm/vmx/main.c    | 10 ++++++++++
 arch/x86/kvm/vmx/tdx.c     |  5 +++++
 arch/x86/kvm/vmx/x86_ops.h |  2 ++
 3 files changed, 17 insertions(+)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index cb41e9a1d3e3..244fb80d385a 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -174,6 +174,14 @@ static int vt_vcpu_mem_enc_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
 	return tdx_vcpu_ioctl(vcpu, argp);
 }
 
+static int vt_gmem_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
+{
+	if (is_td(kvm))
+		return tdx_gmem_private_max_mapping_level(kvm, pfn);
+
+	return 0;
+}
+
 #define VMX_REQUIRED_APICV_INHIBITS				\
 	(BIT(APICV_INHIBIT_REASON_DISABLED) |			\
 	 BIT(APICV_INHIBIT_REASON_ABSENT) |			\
@@ -329,6 +337,8 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.mem_enc_ioctl = vt_mem_enc_ioctl,
 	.vcpu_mem_enc_ioctl = vt_vcpu_mem_enc_ioctl,
+
+	.private_max_mapping_level = vt_gmem_private_max_mapping_level
 };
 
 struct kvm_x86_init_ops vt_init_ops __initdata = {
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 29f01cff0e6b..ead520083397 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1627,6 +1627,11 @@ int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
 	return ret;
 }
 
+int tdx_gmem_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
+{
+	return PG_LEVEL_4K;
+}
+
 static int tdx_online_cpu(unsigned int cpu)
 {
 	unsigned long flags;
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 3e7e7d0eadbf..f61daac5f2f0 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -142,6 +142,7 @@ int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 void tdx_flush_tlb_current(struct kvm_vcpu *vcpu);
 void tdx_flush_tlb_all(struct kvm_vcpu *vcpu);
 void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level);
+int tdx_gmem_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
 #else
 static inline int tdx_vm_init(struct kvm *kvm) { return -EOPNOTSUPP; }
 static inline void tdx_mmu_release_hkid(struct kvm *kvm) {}
@@ -185,6 +186,7 @@ static inline int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 static inline void tdx_flush_tlb_current(struct kvm_vcpu *vcpu) {}
 static inline void tdx_flush_tlb_all(struct kvm_vcpu *vcpu) {}
 static inline void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level) {}
+static inline int tdx_gmem_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn) { return 0; }
 #endif
 
 #endif /* __KVM_X86_VMX_X86_OPS_H */
-- 
2.43.2


