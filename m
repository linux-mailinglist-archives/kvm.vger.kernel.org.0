Return-Path: <kvm+bounces-9675-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E12D1866CB2
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:44:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F3C61C218C8
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 08:44:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CAE15FF01;
	Mon, 26 Feb 2024 08:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Lb72AzBs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35B665F853;
	Mon, 26 Feb 2024 08:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936098; cv=none; b=qWXeDc0bX5k7xghLPNS/7Ve2TKI2TWspeanuKomPC3PXnQw6W7u01ZwkmTdbO3e97yMhFLeauECIkkAiRKgSF5kVtFTRaOC98mfsJAUmOo+ssY+YDvw+QHNs7VANamyLOP24KsX15zOEu1IlYNAB9ArJh17HOniNALPXhoTprMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936098; c=relaxed/simple;
	bh=/QQnC6NuR+jveGFHm7lY9Jr4kJQvgq3Qc9nLEe3cDso=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IdI3TIPqChpP/iokltpRsSNrb2NWaZis22YZlkr+bFaSw4jrStJsvtAqREh99vXI4m7/qJ8T4R9RRryh7Kh445bAE/qjm78BahwsOiRhJEqfrRkFcjremKFUMZWDhYtxbXwug62fOqiBVALyVXzTRJ3l8M8U0Bh0XeqMp9ooBTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Lb72AzBs; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936096; x=1740472096;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/QQnC6NuR+jveGFHm7lY9Jr4kJQvgq3Qc9nLEe3cDso=;
  b=Lb72AzBs6KSkDvVgrO7QyqpivCvt1HSLoGV3o6ud0CDDhv7GDaK9EgRx
   4OoAvEJkGs0zf/sJnXZm8HWYm1d1HjijIvITNN+FnM5f5GhHvvTlUkWRL
   r/eNTG4yPqPfj3zZZZHqbvZAGOHJW+B8G/4TfffA2MdMIvaCZhrcq2TpB
   XR6BBfgY9ti2cqYMXXRs5wHJU9OHmTUt9oCWH11IyzMUFFZt4Ozuct4Lb
   5SSzxjHhmLYtvVbO1XKNzgQm8hmR7MMLgrJymcwkNi14ZJ6A1ynEC0vwk
   WS75WXtfcy5RQlYRpqe8y47JjayMDIbrX8iEaabVhZB2P5JBWMmNLHHe7
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="6155382"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6155382"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6615809"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:11 -0800
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
Subject: [PATCH v19 051/130] KVM: x86/mmu: Add Suppress VE bit to shadow_mmio_mask/shadow_present_mask
Date: Mon, 26 Feb 2024 00:25:53 -0800
Message-Id: <29a80b4fef28dad24e6366f2f707fec5266875da.1708933498.git.isaku.yamahata@intel.com>
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


