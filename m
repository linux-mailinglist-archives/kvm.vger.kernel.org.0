Return-Path: <kvm+bounces-9697-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 77CFF866D0F
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:51:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A88BB1C21E46
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 08:51:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C9E369D2B;
	Mon, 26 Feb 2024 08:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DqJ8POca"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1595E65BA7;
	Mon, 26 Feb 2024 08:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936114; cv=none; b=Ur/wNuGW6ByTz1uMGIhKT0DW/kxkAChvkyKHc8e/NRlErik0x9LkYk44NtqCemhUOE6hW9S1jDmpbXd5ufWO6HKkT2Y6lQJ0K6lLiIX4As17PH5sjHLkG9iy0Nj8rb17kfNYF1nczWIFuZtUNU8aoPBl/mfPz9TYUOhwCnKzDOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936114; c=relaxed/simple;
	bh=dkFZVaecF0CWHpUjngt3GvwMS5f8pMevrJfNVmUMsaA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IRuN5mAdTQE99CwEe51VMy230F4I25j1L2vXWf8MJDYNyo8iz+TIEPtPA5G8NYERqrAJ/yXoPFxMF6qmnmm/xmpR5Yf06YwHY3r4UWNxdotQPrJPIbN58DPLJO6aoYcDSGXIRYIvd1QDoWPISkQAjqYW78q00JE2DKk/Vaxac2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DqJ8POca; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936112; x=1740472112;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dkFZVaecF0CWHpUjngt3GvwMS5f8pMevrJfNVmUMsaA=;
  b=DqJ8POcaoyNxYgSFI55YNRbqK/6UwME70qJAURWM3IQozfiXrAmJL0If
   dxqVjOqzRssR/iLCDLAdOGT/EJ/LqlRZXWnyvIsQCB323EFxjaPpqCy2y
   TVejVqWOl7QePvDLiZ3ElqBCE3wcf07c4mO8y8i1Y0E1CIYlLouqkr4JT
   xfs8A8eEYb1Gp+zISbdKT9kkCJMn7QDT03ZHcdyuO9xmtJ4CwmVQ+2EeE
   kjf/l0Q14seUGyc6+Kamj5qKuXIm3GcWSAgKSVkJYjcgz9tB5w3JCyXgv
   xZdPo1OGTP1XZec6L413sr31R3amW+a/6lOQBs6APxOZiX7t8CQjSa98J
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="3069480"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="3069480"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="11272457"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:31 -0800
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
Subject: [PATCH v19 073/130] KVM: x86: Add hooks in kvm_arch_vcpu_memory_mapping()
Date: Mon, 26 Feb 2024 00:26:15 -0800
Message-Id: <349a549e44fb03f2ec00fd9c45caed308dabbf25.1708933498.git.isaku.yamahata@intel.com>
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

In the case of TDX, the memory contents needs to be provided to be
encrypted when populating guest memory before running the guest.  Add hooks
in kvm_mmu_map_tdp_page() for KVM_MEMORY_MAPPING before/after calling
kvm_mmu_tdp_page().  TDX KVM will implement the hooks.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
v19:
- newly added
---
 arch/x86/include/asm/kvm-x86-ops.h |  2 ++
 arch/x86/include/asm/kvm_host.h    |  5 +++++
 arch/x86/kvm/x86.c                 | 13 ++++++++++++-
 3 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index e1c75f8c1b25..fb3ae97c724e 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -151,6 +151,8 @@ KVM_X86_OP(vcpu_deliver_sipi_vector)
 KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
 KVM_X86_OP_OPTIONAL(get_untagged_addr)
 KVM_X86_OP_OPTIONAL_RET0(gmem_max_level)
+KVM_X86_OP_OPTIONAL(pre_memory_mapping);
+KVM_X86_OP_OPTIONAL(post_memory_mapping);
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_OPTIONAL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index bc0767c884f7..36694e784c27 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1839,6 +1839,11 @@ struct kvm_x86_ops {
 
 	int (*gmem_max_level)(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn,
 			      bool is_private, u8 *max_level);
+	int (*pre_memory_mapping)(struct kvm_vcpu *vcpu,
+				  struct kvm_memory_mapping *mapping,
+				  u64 *error_code, u8 *max_level);
+	void (*post_memory_mapping)(struct kvm_vcpu *vcpu,
+				    struct kvm_memory_mapping *mapping);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2bd4b7c8fa51..23ece956c816 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5826,10 +5826,21 @@ int kvm_arch_vcpu_memory_mapping(struct kvm_vcpu *vcpu,
 	u8 max_level = KVM_MAX_HUGEPAGE_LEVEL;
 	u64 error_code = PFERR_WRITE_MASK;
 	u8 goal_level = PG_LEVEL_4K;
-	int r;
+	int r = 0;
+
+	if (kvm_x86_ops.pre_memory_mapping)
+		r = static_call(kvm_x86_pre_memory_mapping)(vcpu, mapping, &error_code, &max_level);
+	else {
+		if (mapping->source)
+			r = -EINVAL;
+	}
+	if (r)
+		return r;
 
 	r = kvm_mmu_map_tdp_page(vcpu, gfn_to_gpa(mapping->base_gfn), error_code,
 				 max_level, &goal_level);
+	if (kvm_x86_ops.post_memory_mapping)
+		static_call(kvm_x86_post_memory_mapping)(vcpu, mapping);
 	if (r)
 		return r;
 
-- 
2.25.1


