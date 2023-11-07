Return-Path: <kvm+bounces-925-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AB9B7E4274
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 16:00:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F3384B2134E
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 15:00:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BAD7315B3;
	Tue,  7 Nov 2023 14:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nxhEzkxw"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CDE031591
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 14:58:30 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EB81D57;
	Tue,  7 Nov 2023 06:58:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699369098; x=1730905098;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=az0Zf9XrHGdSnYQvBicS+yUZFO3/U2MPO+vM4+fc3KM=;
  b=nxhEzkxwivE7EMCSoj3kxgds+AlV8T7OeiKqS7yB3Zb5Jkf0wxtb3RjR
   s5bZraJ1CJdlpzWlxOQMcK3IBqQO2XRWPlTSIsqDye4Va+8yGcF79W5T7
   RHFuHACEGHbuAUCiLNs/KvgYOAxOe09Sk1/0EyRfSP20Mx+AytycRCxdr
   n1OSG0K8AWwiARZl5kCDuEzlEKvcRpSl7DwQRlIQj+ykk9N9VdBqAWUIN
   QlRvUOyjxvgjG3fsGUAbmOzzLqH9+8cQ5iRWX/G1YAhWU6ZcnSuKKtVqe
   xCM35eCyjsBSDM4dwhiMv08uDA5PoHy/ULuBgv3kBuIordoLsx/Vp7Z9t
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10887"; a="2462203"
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="2462203"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:58:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="10851279"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:58:07 -0800
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
Subject: [PATCH v17 031/116] KVM: Allow page-sized MMU caches to be initialized with custom 64-bit values
Date: Tue,  7 Nov 2023 06:55:57 -0800
Message-Id: <302f6c591af7b2ca01e08286009e489491708af3.1699368322.git.isaku.yamahata@intel.com>
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

From: Sean Christopherson <seanjc@google.com>

Add support to MMU caches for initializing a page with a custom 64-bit
value, e.g. to pre-fill an entire page table with non-zero PTE values.
The functionality will be used by x86 to support Intel's TDX, which needs
to set bit 63 in all non-present PTEs in order to prevent !PRESENT page
faults from getting reflected into the guest (Intel's EPT Violation #VE
architecture made the less than brilliant decision of having the per-PTE
behavior be opt-out instead of opt-in).

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 include/linux/kvm_types.h |  1 +
 virt/kvm/kvm_main.c       | 16 ++++++++++++++--
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index 9d1f7835d8c1..60c8d5c9eab9 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -94,6 +94,7 @@ struct gfn_to_pfn_cache {
 struct kvm_mmu_memory_cache {
 	gfp_t gfp_zero;
 	gfp_t gfp_custom;
+	u64 init_value;
 	struct kmem_cache *kmem_cache;
 	int capacity;
 	int nobjs;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 29fdb39976e0..7d9f4f9bb115 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -403,12 +403,17 @@ static void kvm_flush_shadow_all(struct kvm *kvm)
 static inline void *mmu_memory_cache_alloc_obj(struct kvm_mmu_memory_cache *mc,
 					       gfp_t gfp_flags)
 {
+	void *page;
+
 	gfp_flags |= mc->gfp_zero;
 
 	if (mc->kmem_cache)
 		return kmem_cache_alloc(mc->kmem_cache, gfp_flags);
-	else
-		return (void *)__get_free_page(gfp_flags);
+
+	page = (void *)__get_free_page(gfp_flags);
+	if (page && mc->init_value)
+		memset64(page, mc->init_value, PAGE_SIZE / sizeof(mc->init_value));
+	return page;
 }
 
 int __kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int capacity, int min)
@@ -423,6 +428,13 @@ int __kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int capacity,
 		if (WARN_ON_ONCE(!capacity))
 			return -EIO;
 
+		/*
+		 * Custom init values can be used only for page allocations,
+		 * and obviously conflict with __GFP_ZERO.
+		 */
+		if (WARN_ON_ONCE(mc->init_value && (mc->kmem_cache || mc->gfp_zero)))
+			return -EIO;
+
 		mc->objects = kvmalloc_array(sizeof(void *), capacity, gfp);
 		if (!mc->objects)
 			return -ENOMEM;
-- 
2.25.1


