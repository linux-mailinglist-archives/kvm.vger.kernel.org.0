Return-Path: <kvm+bounces-34209-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 49A9D9F8E63
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 09:57:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 141151897109
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 08:57:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11CC11A9B55;
	Fri, 20 Dec 2024 08:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Jr+ZaORl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6850D259499;
	Fri, 20 Dec 2024 08:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734685022; cv=none; b=gxpY0A/AzWbLD310Mh7gRoEmqTU4Xh5Vn2iNo0w5eTN2JgGcMDl6RH0sZv1EpcwTDjBAf96w2guizjhAOnHi1rVPtERrRZIQkvkVUKHBZ4LxBPxv3ZT5BSWTriCTVxvo6rLXla2+Anx2/1cHrgwg/TVi/F4N7aaB1jo6LTsshYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734685022; c=relaxed/simple;
	bh=Ix2B9C/Nh26ny/NHyjFiP49HplKZ/yC1VOGz7tuztF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tPcBBf6UGTGLNoSk3qmq1Me54b1ahJQ0g8/ixSKzkjYsIpxQpJsuXkmrHVHnotue/HLmUAzNKCIATah+DG+ss/Qn9TUxQjYqulEC2yPukd85vInyjI0Un5PFh/VFGkaQVQ7TGU0x8s1KpKX92MYG103xV7tXF4npBRjnwQz1c48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Jr+ZaORl; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734685020; x=1766221020;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ix2B9C/Nh26ny/NHyjFiP49HplKZ/yC1VOGz7tuztF8=;
  b=Jr+ZaORlANQgfiddP2LsiaA1o3WCcs/zwFgUVvLzfpwA2Y76EMFTiT3K
   0YZatSpPbRyiK6cFVTQkclpKdEKidpEIkQx0+GrMdF19q0BHzlqzjdIyL
   ldO7+1UiFhgsKeeb7jOO9X1DRMrLf7pfKELfIwRHNgeBeu/Ab4gWfPkjv
   BXIM+amABAY8vPTxdXf3JVCCY6Q18YOs4QxSfjHFGJ59oa02by94d0EW5
   mT3uH5wifkC8aeXfiPJXpgSJbGeR7r2Dhyz/sOWGa3dJiZCSOdyHPRIJO
   z5/pz3T1LEtIa9DnqJuojW1zXS33LrDaF1Tf0qY6wKhxrTJDPgeJlYc5b
   w==;
X-CSE-ConnectionGUID: l5wlAiOzRgq3K5c6klt4eA==
X-CSE-MsgGUID: 3ySD0Dk2TCy4UQEcv2DOkQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11291"; a="60610727"
X-IronPort-AV: E=Sophos;i="6.12,250,1728975600"; 
   d="scan'208";a="60610727"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2024 00:56:59 -0800
X-CSE-ConnectionGUID: xVkDxudaQDCoNQXbUE4FKA==
X-CSE-MsgGUID: gQy0ciHeSRiv/AJLBraO7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="98284466"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2024 00:56:57 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: peterx@redhat.com,
	rick.p.edgecombe@intel.com,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH 1/2] KVM: Do not reset dirty GFNs in a memslot not enabling dirty tracking
Date: Fri, 20 Dec 2024 16:22:31 +0800
Message-ID: <20241220082231.15884-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20241220082027.15851-1-yan.y.zhao@intel.com>
References: <20241220082027.15851-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Do not allow resetting dirty GFNs belonging to a memslot that does not
enable dirty tracking.

vCPUs' dirty rings are shared between userspace and KVM. After KVM sets
dirtied entries in the dirty rings, userspace is responsible for
harvesting/resetting the dirtied entries and calling the ioctl
KVM_RESET_DIRTY_RINGS to inform KVM to advance the reset_index in the
dirty rings and invoke kvm_arch_mmu_enable_log_dirty_pt_masked() to clear
the SPTEs' dirty bits or perform write protection of GFNs.

Although KVM does not set dirty entries for GFNs in a memslot that does not
enable dirty tracking, it is still possible for userspace to specify that
it has harvested a GFN belonging to such a memslot. When this happens, KVM
will be asked to clear dirty bits or perform write protection for GFNs in a
memslot that does not enable dirty tracking, which is not desired.

For TDX, this unexpected resetting of dirty GFNs could cause inconsistency
between the mirror SPTE and the external SPTE in hardware (e.g., the mirror
SPTE has no write bit while it is writable in the external SPTE in
hardware). When kvm_dirty_log_manual_protect_and_init_set() is true and
when huge pages are enabled in TDX, this could even lead to
kvm_mmu_slot_gfn_write_protect() being called and the external SPTE being
removed.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 virt/kvm/dirty_ring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
index d14ffc7513ee..1ce5352ea596 100644
--- a/virt/kvm/dirty_ring.c
+++ b/virt/kvm/dirty_ring.c
@@ -66,7 +66,8 @@ static void kvm_reset_dirty_gfn(struct kvm *kvm, u32 slot, u64 offset, u64 mask)
 
 	memslot = id_to_memslot(__kvm_memslots(kvm, as_id), id);
 
-	if (!memslot || (offset + __fls(mask)) >= memslot->npages)
+	if (!memslot || (offset + __fls(mask)) >= memslot->npages ||
+	    !kvm_slot_dirty_track_enabled(memslot))
 		return;
 
 	KVM_MMU_LOCK(kvm);
-- 
2.43.2


