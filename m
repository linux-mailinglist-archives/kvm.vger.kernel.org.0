Return-Path: <kvm+bounces-9673-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CD6EB866CA8
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:43:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6ED761F24183
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 08:43:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E48C35FBAD;
	Mon, 26 Feb 2024 08:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HoRbKJ3G"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B3A5208AD;
	Mon, 26 Feb 2024 08:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936096; cv=none; b=cOkcmMdvfKn7+diOmqEWPvhTZBvxAEAxVoO17o1KDn6IuktEo9mWkKFstQzB8DLadJJ5/K12p78tcOX/9GRwNVISXm2ffgd54wf9DidfVW4g5DI9IXWDqzAhdjcSssMVYl8Z7G1RCW+DgK4ONM7XXaxIQ1GUBKqoLELYDjjSH58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936096; c=relaxed/simple;
	bh=X5tL+FTdFYIo/iu/ZRdr5tfelqekqbOSzf0LKCUZinM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=R2/YdGBUkH50UA6m1BYvaF0JBHsLGEtQFNus/vYTrFBeoLDFe4GW51bEJEIVDpktxXgqAleIHM9z0KQ1FNWT42rBCc87VgBXYSsPrIbZx4RS2nwouevshCLAcwstLdziHCvBx6Ixr2g2FE3aMjOuJixoUYOkySB46AxLwEMvEe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HoRbKJ3G; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936093; x=1740472093;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=X5tL+FTdFYIo/iu/ZRdr5tfelqekqbOSzf0LKCUZinM=;
  b=HoRbKJ3GiHQhNmG6aAF5deRzleDhO17EooWcUO7f5nZTrsa3E5IyWJBc
   a8xXDLRNI+Wxs/uMNrBBWZv+qDmJ9bbxPhh9fwRKzXybOvuHOucYESVhr
   RpJ4CRXqkjuh2fvqIod4s/pSCvkizcGJhMAUCts0C0rkdyrkhsQXYrNV6
   sJA5wyvVLyNbp1fzJsnONkK/gdvyapbA3YGcaNWD2vdiU8V+2a1V65dnp
   LLj1tjOeSAVUctwCygyDLH/CfXvlz8ltuTZGj3nj8HHcNmpPERxPQebfa
   y+m7bxFbZhC/SEVmMAhTVo2rziMp9ucGdOD6tFT7nyt5jIk/TZkNWuyan
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="6155368"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6155368"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6615787"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:09 -0800
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
Subject: [PATCH v19 048/130] KVM: Allow page-sized MMU caches to be initialized with custom 64-bit values
Date: Mon, 26 Feb 2024 00:25:50 -0800
Message-Id: <9c392612eac4f3c489ad12dd4a4d505cf10d36dc.1708933498.git.isaku.yamahata@intel.com>
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
index de38f308738e..d399009ef1d7 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -401,12 +401,17 @@ static void kvm_flush_shadow_all(struct kvm *kvm)
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
@@ -421,6 +426,13 @@ int __kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int capacity,
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


