Return-Path: <kvm+bounces-10664-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 93A1586E747
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 18:31:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4BF9F289E1A
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 17:31:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DDBE3A1B0;
	Fri,  1 Mar 2024 17:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GNP5/VVx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B5A22260A;
	Fri,  1 Mar 2024 17:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709314189; cv=none; b=uqtQ3KFpNJjUztjn7D1+ZrB7Tih+W1DIbMsuoG5pPnyOeZias8k5amGQUnc//P8GduWhApGSbDZT9ZrwP+tSIpeDyAtnB59Hv+SrIKdX/T5GQnL1kfm53U9entiNE4J1k38VcYVf/mOcmg/n1vZzizhbGFpcDFbrpkwuudjSeqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709314189; c=relaxed/simple;
	bh=y1JrrW54QV2rrlJRNIe/iaQAHwsqZ6loiMUvuPO+XB0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ptS4tN++qtfLf+YkcsDCcCgBDq7cOUY4QqBke/bv7Fl6HEkWEa5JCKXc8X3L/rMdViUWWKw0C1/C7IaK5I8qimgVyhrgqipPqgKKzi4T/AtmrgHv4h3rW48ORyG77+PVVMbOcWUc7TCohXloQrI8lXPSFioZMckoSRKmm81rskw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GNP5/VVx; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709314187; x=1740850187;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=y1JrrW54QV2rrlJRNIe/iaQAHwsqZ6loiMUvuPO+XB0=;
  b=GNP5/VVx3BWc/9drOl76uSR92iLdu2ekeNNVw3P6w9BzEMwmv4AQAaIS
   baonqQO8T2QrgaEOmy+RsR255jkirv2vftGuRK9MGzDLDHkEjKKAOUJnZ
   i+4cvlhInOIM+Zm0ZOkv9Y1rkb0HSOHrVXS5c+KL1Y9OVL8Q3gcZ72ZxT
   mCtgkaCMlUjeZKgB8BZSOo/31QdK82WhYD8P1OUwVP8Pfpfd2B+yNAb29
   Oa1XAVVzcIPSH8Klp7ssD5x2aNwsHkOElsWd6MkOQxHV86N8bJiHeqX1Z
   50lQMbh5BqjW6pu9zSkxrv3dl3lrMOafitrMxMfOX5noSuLsS/rgBO+F9
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11000"; a="6812441"
X-IronPort-AV: E=Sophos;i="6.06,196,1705392000"; 
   d="scan'208";a="6812441"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2024 09:29:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,196,1705392000"; 
   d="scan'208";a="12946576"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2024 09:29:27 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Michael Roth <michael.roth@amd.com>,
	David Matlack <dmatlack@google.com>,
	Federico Parola <federico.parola@polito.it>
Subject: [RFC PATCH 7/8] KVM: x86: Add hooks in kvm_arch_vcpu_map_memory()
Date: Fri,  1 Mar 2024 09:28:49 -0800
Message-Id: <fa1b167cbb0473e90144315bfbdea1a7d187cae6.1709288671.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1709288671.git.isaku.yamahata@intel.com>
References: <cover.1709288671.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

In the case of TDX, the memory contents needs to be provided to be
encrypted when populating guest memory before running the guest.  Add hooks
in kvm_mmu_map_tdp_page() for KVM_MAP_MEMORY before/after calling
kvm_mmu_tdp_page().  TDX KVM will use the hooks.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  2 ++
 arch/x86/include/asm/kvm_host.h    |  6 ++++++
 arch/x86/kvm/x86.c                 | 34 ++++++++++++++++++++++++++++++
 3 files changed, 42 insertions(+)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 3942b74c1b75..fc4e11d40733 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -137,6 +137,8 @@ KVM_X86_OP(complete_emulated_msr)
 KVM_X86_OP(vcpu_deliver_sipi_vector)
 KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
 KVM_X86_OP_OPTIONAL(get_untagged_addr)
+KVM_X86_OP_OPTIONAL(pre_mmu_map_page);
+KVM_X86_OP_OPTIONAL(post_mmu_map_page);
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_OPTIONAL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9e7b1a00e265..301fedd6b156 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1805,6 +1805,12 @@ struct kvm_x86_ops {
 	unsigned long (*vcpu_get_apicv_inhibit_reasons)(struct kvm_vcpu *vcpu);
 
 	gva_t (*get_untagged_addr)(struct kvm_vcpu *vcpu, gva_t gva, unsigned int flags);
+
+	int (*pre_mmu_map_page)(struct kvm_vcpu *vcpu,
+				struct kvm_memory_mapping *mapping,
+				u32 *error_code, u8 *max_level);
+	void (*post_mmu_map_page)(struct kvm_vcpu *vcpu,
+				  struct kvm_memory_mapping *mapping);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6025c0e12d89..ba8bf35f1c9a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5811,6 +5811,36 @@ int kvm_arch_vcpu_pre_map_memory(struct kvm_vcpu *vcpu)
 	return kvm_mmu_reload(vcpu);
 }
 
+static int kvm_pre_mmu_map_page(struct kvm_vcpu *vcpu,
+				struct kvm_memory_mapping *mapping,
+				u32 error_code, u8 *max_level)
+{
+	int r = 0;
+
+	if (vcpu->kvm->arch.vm_type == KVM_X86_DEFAULT_VM ||
+	    vcpu->kvm->arch.vm_type == KVM_X86_SW_PROTECTED_VM) {
+		if (mapping->source)
+			r = -EINVAL;
+	} else if (kvm_x86_ops.pre_mmu_map_page)
+		r = static_call(kvm_x86_pre_mmu_map_page)(vcpu, mapping,
+							  &error_code,
+							  max_level);
+	else
+		r = -EOPNOTSUPP;
+
+	return r;
+}
+
+static void kvm_post_mmu_map_page(struct kvm_vcpu *vcpu, struct kvm_memory_mapping *mapping)
+{
+	if (vcpu->kvm->arch.vm_type == KVM_X86_DEFAULT_VM ||
+	    vcpu->kvm->arch.vm_type == KVM_X86_SW_PROTECTED_VM)
+		return;
+
+	if (kvm_x86_ops.post_mmu_map_page)
+		static_call(kvm_x86_post_mmu_map_page)(vcpu, mapping);
+}
+
 int kvm_arch_vcpu_map_memory(struct kvm_vcpu *vcpu,
 			     struct kvm_memory_mapping *mapping)
 {
@@ -5842,8 +5872,12 @@ int kvm_arch_vcpu_map_memory(struct kvm_vcpu *vcpu,
 	else
 		max_level = PG_LEVEL_4K;
 
+	r = kvm_pre_mmu_map_page(vcpu, mapping, error_code, &max_level);
+	if (r)
+		return r;
 	r = kvm_mmu_map_page(vcpu, gfn_to_gpa(mapping->base_gfn), error_code,
 			     max_level, &goal_level);
+	kvm_post_mmu_map_page(vcpu, mapping);
 	if (r)
 		return r;
 
-- 
2.25.1


