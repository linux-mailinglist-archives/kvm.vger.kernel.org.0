Return-Path: <kvm+bounces-17411-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 990618C5E9F
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 03:04:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CA63E1C209CC
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 01:04:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D96563FB1B;
	Wed, 15 May 2024 01:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QdpfjLYS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7491939FD3;
	Wed, 15 May 2024 01:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715734816; cv=none; b=kyqbo/R2V7QLWDz9iaY6JDtVuBFg1YoaeEJM4d5xKoQrDr7hXQv80I21mrgixFeaq5oI/JQLDCW0b3ouOe6f3J6VihefeV00lOAfWC2KSEsilKj43/WX5uYlVkqWP5GGMkxcoHR9tXu7NpUcXpQXlCR3cz9SOwnqxxbwXeJB2sI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715734816; c=relaxed/simple;
	bh=aj7fEmDeepMPOarJYfKiRSUouqqIYmoqtkZdy4tUeqg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aJpoZLeYkJ+RSxYV6cpe2AyT6nvktSyB7PRzT4ZmLmxlGTjAOHeaAmVr8FS+eRnXqfm7wPVFRzpUdRBaDKhXM6VLRcmC2RB8oumyM1hfnX9V2k+6kQ9zHDp/fJALV8RMSTspGKZkuy/E4C2jREPiCCsZhRqu+iTveUIJ6dasV7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QdpfjLYS; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715734815; x=1747270815;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aj7fEmDeepMPOarJYfKiRSUouqqIYmoqtkZdy4tUeqg=;
  b=QdpfjLYStE+yiWVUfX3BnQ0+hygbzbbp3hpbUA9trrdgwXR6Ja3MDx5W
   tpF4W+udcuMJntxVNYdPIzJU83YMZ7+e/cL61I1zPrM4zz8Exjr64llJO
   SNBY4gm/hIOF/G6zseqL+v/Q0ipupi1jK2juwBzxdCP2KHqu69Ch1NPjE
   oeaSBEDOY5dPJlbFxe8FX8/rG5MITBnLsCYPeiO8/6Bt2sINolOkucydM
   E3kW6ULyXORt1ABQ1UmroGazathgm9SRRqdQPudNE1bV32ciw0lAb6sGl
   soMkkPO93PxFsig1qGMQ/TkUdgEarKMUoFOa27eGL2/QssKjUsBCTB3qp
   Q==;
X-CSE-ConnectionGUID: a8KbWV+hRqWXNTA0oiD8Zg==
X-CSE-MsgGUID: gQZq+WRRSbuY1akc02rQQg==
X-IronPort-AV: E=McAfee;i="6600,9927,11073"; a="11613999"
X-IronPort-AV: E=Sophos;i="6.08,160,1712646000"; 
   d="scan'208";a="11613999"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2024 18:00:10 -0700
X-CSE-ConnectionGUID: TFQG3a5BRwWlS7yGvC+bXg==
X-CSE-MsgGUID: awm+P7luTueABNtx8YYR7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,160,1712646000"; 
   d="scan'208";a="30942860"
Received: from oyildiz-mobl1.amr.corp.intel.com (HELO rpedgeco-desk4.intel.com) ([10.209.51.34])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2024 18:00:08 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	isaku.yamahata@gmail.com,
	erdemaktas@google.com,
	sagis@google.com,
	yan.y.zhao@intel.com,
	dmatlack@google.com,
	rick.p.edgecombe@intel.com
Subject: [PATCH 16/16] KVM: x86/tdp_mmu: Invalidate correct roots
Date: Tue, 14 May 2024 17:59:52 -0700
Message-Id: <20240515005952.3410568-17-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sean Christopherson <sean.j.christopherson@intel.com>

When invalidating roots, respect the root type passed.

kvm_tdp_mmu_invalidate_roots() is called with different root types. For
kvm_mmu_zap_all_fast() it only operates on shared roots. But when tearing
down a TD it needs to invalidate all roots. Check the root type in root
iterator.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Co-developed-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
[evolved quite a bit from original author's patch]
Co-developed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
TDX MMU Part 1:
 - Rename from "Don't zap private pages for unsupported cases", and split
   many parts out.
 - Don't support MTRR, apic zapping (Rick)
 - Detangle private/shared alias logic in kvm_tdp_mmu_unmap_gfn_range()
   (Rick)
 - Fix TLB flushing bug debugged by (Chao Gao)
   https://lore.kernel.org/kvm/Zh8yHEiOKyvZO+QR@chao-email/
 - Split out MTRR part
 - Use enum based root iterators (Sean)
 - Reorder logic in kvm_mmu_zap_memslot_leafs().
 - Replace skip_private with enum kvm_tdp_mmu_root_type.
---
 arch/x86/kvm/mmu/tdp_mmu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index af61d131d2dc..42ccafc7deff 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1196,6 +1196,9 @@ void kvm_tdp_mmu_invalidate_roots(struct kvm *kvm,
 	 * or get/put references to roots.
 	 */
 	list_for_each_entry(root, &kvm->arch.tdp_mmu_roots, link) {
+		if (!tdp_mmu_root_match(root, types))
+			continue;
+
 		/*
 		 * Note, invalid roots can outlive a memslot update!  Invalid
 		 * roots must be *zapped* before the memslot update completes,
-- 
2.34.1


