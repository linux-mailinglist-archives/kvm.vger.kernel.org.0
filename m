Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EFE3313076
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 12:16:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232929AbhBHLOz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 06:14:55 -0500
Received: from mga03.intel.com ([134.134.136.65]:51226 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232902AbhBHLMu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Feb 2021 06:12:50 -0500
IronPort-SDR: cYFfbF7VRHtIBDypg/2E+s2fYln3If/hP8+ufgskeXVObsy4rUD8GULEHdDoa29Qp4EG+niYEw
 LxSuglM/gcGQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9888"; a="181760489"
X-IronPort-AV: E=Sophos;i="5.81,161,1610438400"; 
   d="scan'208";a="181760489"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2021 03:11:00 -0800
IronPort-SDR: tQPxxlIxpgU2syF+t+y9/8vgr96RxgVSdqB1ryYM3UPrbvR2D4MYql2e8nyZDkEvcykN4FKdS0
 hOIBPdZZ0vHg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,161,1610438400"; 
   d="scan'208";a="395345985"
Received: from zhangyu-optiplex-7040.bj.intel.com ([10.238.154.148])
  by orsmga008.jf.intel.com with ESMTP; 08 Feb 2021 03:10:56 -0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     zhenyuw@linux.intel.com, zhi.a.wang@intel.com
Cc:     jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com,
        rodrigo.vivi@intel.com, airlied@linux.ie, daniel@ffwll.ch,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH] drm/i915/gvt/kvmgt: Fix the build failure in kvmgt.
Date:   Tue,  9 Feb 2021 02:52:10 +0800
Message-Id: <20210208185210.6002-1-yu.c.zhang@linux.intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Previously, commit 531810caa9f4 ("KVM: x86/mmu: Use
an rwlock for the x86 MMU") replaced KVM's mmu_lock
with type rwlock_t. This will cause a build failure
in kvmgt, which uses the same lock when trying to add/
remove some GFNs to/from the page tracker. Fix it with
write_lock/unlocks in kvmgt.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
---
 drivers/gpu/drm/i915/gvt/kvmgt.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index 60f1a386dd06..b4348256ae95 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -1703,7 +1703,7 @@ static int kvmgt_page_track_add(unsigned long handle, u64 gfn)
 		return -EINVAL;
 	}
 
-	spin_lock(&kvm->mmu_lock);
+	write_lock(&kvm->mmu_lock);
 
 	if (kvmgt_gfn_is_write_protected(info, gfn))
 		goto out;
@@ -1712,7 +1712,7 @@ static int kvmgt_page_track_add(unsigned long handle, u64 gfn)
 	kvmgt_protect_table_add(info, gfn);
 
 out:
-	spin_unlock(&kvm->mmu_lock);
+	write_unlock(&kvm->mmu_lock);
 	srcu_read_unlock(&kvm->srcu, idx);
 	return 0;
 }
@@ -1737,7 +1737,7 @@ static int kvmgt_page_track_remove(unsigned long handle, u64 gfn)
 		return -EINVAL;
 	}
 
-	spin_lock(&kvm->mmu_lock);
+	write_lock(&kvm->mmu_lock);
 
 	if (!kvmgt_gfn_is_write_protected(info, gfn))
 		goto out;
@@ -1746,7 +1746,7 @@ static int kvmgt_page_track_remove(unsigned long handle, u64 gfn)
 	kvmgt_protect_table_del(info, gfn);
 
 out:
-	spin_unlock(&kvm->mmu_lock);
+	write_unlock(&kvm->mmu_lock);
 	srcu_read_unlock(&kvm->srcu, idx);
 	return 0;
 }
@@ -1772,7 +1772,7 @@ static void kvmgt_page_track_flush_slot(struct kvm *kvm,
 	struct kvmgt_guest_info *info = container_of(node,
 					struct kvmgt_guest_info, track_node);
 
-	spin_lock(&kvm->mmu_lock);
+	write_lock(&kvm->mmu_lock);
 	for (i = 0; i < slot->npages; i++) {
 		gfn = slot->base_gfn + i;
 		if (kvmgt_gfn_is_write_protected(info, gfn)) {
@@ -1781,7 +1781,7 @@ static void kvmgt_page_track_flush_slot(struct kvm *kvm,
 			kvmgt_protect_table_del(info, gfn);
 		}
 	}
-	spin_unlock(&kvm->mmu_lock);
+	write_unlock(&kvm->mmu_lock);
 }
 
 static bool __kvmgt_vgpu_exist(struct intel_vgpu *vgpu, struct kvm *kvm)
-- 
2.17.1

