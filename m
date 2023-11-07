Return-Path: <kvm+bounces-928-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B38A37E4279
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 16:00:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6E170281623
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 15:00:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F281831A81;
	Tue,  7 Nov 2023 14:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nvsMx4lE"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5674431A66
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 14:58:49 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0880BD7A;
	Tue,  7 Nov 2023 06:58:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699369106; x=1730905106;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/QQnC6NuR+jveGFHm7lY9Jr4kJQvgq3Qc9nLEe3cDso=;
  b=nvsMx4lEiqAQ4Cr2e5/AMeFPI2CpXCyBXCNHqfgiqQ7cB0JBBNMbxLFl
   zT/uNcRcoefrhHAGPIUTMvI1mfiHuwiyPJvNliBbMrT3QdpI4zc6q7yjI
   V3ykqsbYajM7ReD4YmphbhuxrXY6mgvLUTr7yYSJFVJ7NwUAxgnxGboI/
   5/w65hpe1v54X0KuzkLh/43gzN7jshnXlEUoSwNnohFs+WpLdSYEjE73K
   LJ9l9YZXMPYmMYDMsA+fI9PuxD37F5rRDYBRBg43aJuPEA+mWdL+Vfw9A
   44CYqjQaEh+5G0M5p6zgQ4o0EtGf8AVXaU4mcV7NbYpgQGLgAbHMow8VK
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10887"; a="2462217"
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="2462217"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:58:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="10851301"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:58:08 -0800
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
	tina.zhang@intel.com
Subject: [PATCH v17 034/116] KVM: x86/mmu: Add Suppress VE bit to shadow_mmio_mask/shadow_present_mask
Date: Tue,  7 Nov 2023 06:56:00 -0800
Message-Id: <e895e6579c4a2137c65a2f1d51c51b4e50957463.1699368322.git.isaku.yamahata@intel.com>
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

To make use of the same value of shadow_mmio_mask and shadow_present_mask
for TDX and VMX, add Suppress-VE bit to shadow_mmio_mask and
shadow_present_mask so that they can be common for both VMX and TDX.

TDX will require shadow_mmio_mask and shadow_present_mask to include
VMX_SUPPRESS_VE for shared GPA so that EPT violation is triggered for
shared GPA.  For VMX, VMX_SUPPRESS_VE doesn't matter for MMIO because the
spte value is required to cause EPT misconfig.  the additional bit doesn't
affect VMX logic to add the bit to shadow_mmio_{value, mask}.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/vmx.h | 1 +
 arch/x86/kvm/mmu/spte.c    | 6 ++++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 0e73616b82f3..76ed39541a52 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -513,6 +513,7 @@ enum vmcs_field {
 #define VMX_EPT_IPAT_BIT    			(1ull << 6)
 #define VMX_EPT_ACCESS_BIT			(1ull << 8)
 #define VMX_EPT_DIRTY_BIT			(1ull << 9)
+#define VMX_EPT_SUPPRESS_VE_BIT			(1ull << 63)
 #define VMX_EPT_RWX_MASK                        (VMX_EPT_READABLE_MASK |       \
 						 VMX_EPT_WRITABLE_MASK |       \
 						 VMX_EPT_EXECUTABLE_MASK)
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 4a599130e9c9..02a466de2991 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -429,7 +429,9 @@ void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only)
 	shadow_dirty_mask	= has_ad_bits ? VMX_EPT_DIRTY_BIT : 0ull;
 	shadow_nx_mask		= 0ull;
 	shadow_x_mask		= VMX_EPT_EXECUTABLE_MASK;
-	shadow_present_mask	= has_exec_only ? 0ull : VMX_EPT_READABLE_MASK;
+	/* VMX_EPT_SUPPRESS_VE_BIT is needed for W or X violation. */
+	shadow_present_mask	=
+		(has_exec_only ? 0ull : VMX_EPT_READABLE_MASK) | VMX_EPT_SUPPRESS_VE_BIT;
 	/*
 	 * EPT overrides the host MTRRs, and so KVM must program the desired
 	 * memtype directly into the SPTEs.  Note, this mask is just the mask
@@ -446,7 +448,7 @@ void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only)
 	 * of an EPT paging-structure entry is 110b (write/execute).
 	 */
 	kvm_mmu_set_mmio_spte_mask(VMX_EPT_MISCONFIG_WX_VALUE,
-				   VMX_EPT_RWX_MASK, 0);
+				   VMX_EPT_RWX_MASK | VMX_EPT_SUPPRESS_VE_BIT, 0);
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_set_ept_masks);
 
-- 
2.25.1


