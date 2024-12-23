Return-Path: <kvm+bounces-34331-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B12399FAB3C
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2024 08:41:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A334C18852E6
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2024 07:41:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 077B318FC79;
	Mon, 23 Dec 2024 07:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h+86XFVz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81A3F38385;
	Mon, 23 Dec 2024 07:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734939695; cv=none; b=P+Vk1wtXE3n04zESt/4M+BVrL0fMiCDDK/36jsIj+SB1XryypVldv7hlAEdlOxgHuUfXqwdnVm6ysD4HrLQQgiSzsdzo28nObjDDoHNC8Sb4Usb1ZdMLDHU+DjMrLLvrPOGLeCg9v5uUyQjCBuXO0aegK9KgY+DExW96SY8v0gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734939695; c=relaxed/simple;
	bh=PNBLci5V+1wxwc33eqYhL6fyiXoZscx2etUNk8y3ihg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ujs9VjN6XNBVLiLCfa9DzZfeg0qeLHdao7SGRrTwCppQnPKFALp1NeBQE0dTpKv9IU3NrHPRrbdpOYj6c4srokiOwrh/xCyRCkap/fsAWk8jm3g9l821mW8SfJq7BQgEOlaCgaB/jJ7CT5BAHK35y/Ez4xkqbhbCro8OUEr8/tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h+86XFVz; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734939693; x=1766475693;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PNBLci5V+1wxwc33eqYhL6fyiXoZscx2etUNk8y3ihg=;
  b=h+86XFVzpGDlwykdncyXZxM3rjL72xIwXWvP7Nbt6NhRxbajCY4wuN9c
   VUZFRz55ewozsof8mDLUFzCkK3c3SADjcOfdo6ExnXER3o+X3cvUGJ4Vy
   4YKJxt3wCjJvcfUBvIkDNomTmsp7+NC2AM/L5Efz9qu8x/o5rDE/6b3v4
   POp5cMOdzzlRRtVlodsRgXbpM0IK9W6kyUgdRHtbEJM+yXPVZdjbpdX4w
   cbAxWUVrqXuzAhUrZh0wvNlGUjY/gHZZSRYyIBOY1rN2kmJpQB6LHR3DV
   zQRtMxzGxbFx/FuefqOOpfBhhtwJbIwAtMjeUUg7yCSSEnqYc4zw5lHwL
   Q==;
X-CSE-ConnectionGUID: 6vYzoHHLTN6zFqWea53EzA==
X-CSE-MsgGUID: soC6/l/RTn6oKiGhVKFSxg==
X-IronPort-AV: E=McAfee;i="6700,10204,11294"; a="22988319"
X-IronPort-AV: E=Sophos;i="6.12,256,1728975600"; 
   d="scan'208";a="22988319"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2024 23:41:33 -0800
X-CSE-ConnectionGUID: uUdgQf3aRWqxLpJyxOP6WQ==
X-CSE-MsgGUID: 0qaY/0mQQo2URxKgh1HpHg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="103743300"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2024 23:41:29 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: peterx@redhat.com,
	rick.p.edgecombe@intel.com,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v2 1/2] KVM: Do not reset dirty GFNs in a memslot not enabling dirty tracking
Date: Mon, 23 Dec 2024 15:07:12 +0800
Message-ID: <20241223070712.29626-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20241223070427.29583-1-yan.y.zhao@intel.com>
References: <20241223070427.29583-1-yan.y.zhao@intel.com>
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
enable dirty tracking, userspace can write arbitrary data into the dirty
ring. This makes it possible for misbehaving userspace to specify that it
has harvested a GFN belonging to such a memslot. When this happens, KVM
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
 virt/kvm/dirty_ring.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
index d14ffc7513ee..d52093b5ec73 100644
--- a/virt/kvm/dirty_ring.c
+++ b/virt/kvm/dirty_ring.c
@@ -66,7 +66,13 @@ static void kvm_reset_dirty_gfn(struct kvm *kvm, u32 slot, u64 offset, u64 mask)
 
 	memslot = id_to_memslot(__kvm_memslots(kvm, as_id), id);
 
-	if (!memslot || (offset + __fls(mask)) >= memslot->npages)
+	/*
+	 * Userspace can write arbitrary data into the dirty ring, making it
+	 * possible for misbehaving userspace to try to reset an out-of-memslot
+	 * GFN or a GFN in a memslot that isn't being dirty-logged.
+	 */
+	if (!memslot || (offset + __fls(mask)) >= memslot->npages ||
+	    !kvm_slot_dirty_track_enabled(memslot))
 		return;
 
 	KVM_MMU_LOCK(kvm);
-- 
2.43.2


