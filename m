Return-Path: <kvm+bounces-55489-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A61DB31129
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 10:05:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1401816A527
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 08:04:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E34D2ED847;
	Fri, 22 Aug 2025 08:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KrV4KVFS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B7E22EC56E;
	Fri, 22 Aug 2025 08:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755849768; cv=none; b=df4E9FmXUKpxWMkl1jzFrcVnKHc895TWcC6bsDT/fNrUC8E878tma0jkbKzB2doJTSkNInT0UzoI6RRUPAPw4LUMC6PtHCqaW1xJ6GiV3WWfUs5p2pmggrFEksBDGOhrAs3xBjrxIPd6Mw5PjFpvgN6+c7wMAxaD71bBaTiD1Os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755849768; c=relaxed/simple;
	bh=ox5HagInQkEYD1GyuBjm/ab9Ea4XC/Vn17AhqV0cy7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SWB7fhaBRNC5YRKHSBv05IwKtalyRZ+FHQy5bIPA/fv2vjxVfbYqPj4CzNlW6Pv0CkIIuUgzwejOZs7f3mESlJ66WbRS2ahlwbxZBGdzRL2J3vacXReTHauulrtVHKqauoicIgI0SxfHZbx9n36PDJqfELil3VfbUO0zYoPaKBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KrV4KVFS; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755849766; x=1787385766;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ox5HagInQkEYD1GyuBjm/ab9Ea4XC/Vn17AhqV0cy7U=;
  b=KrV4KVFS6gSGrB/zR3VghDCr+naorLKc4EaHKrYNXCRR0ATV9T0JS9mT
   Wc1y288ZesYys2RmdiR/kCyRp8Bh3/Pc85cI8w0AT080myVDlfQ8yQOV6
   0ZBIS/uSODQvjNfix3FILUoPd0vgfnRKm7qmoXDRmPXK2oIRHvQK0Onga
   EcGjw7V+uTZWJH/ixjm/lqiNnJ1fE3mETfgHgeqPoOVHhDVqYypEb3MG7
   0MHuA0Hcoc3h7vDbJUemq62gQxy0pLBy/O6x0EmuMp3lAV9AsO1/aIadw
   lgn4jeR7lryOnjft44uhPqbLyczE+l0FWEOKebliTFzgllMJ1XNG1i48z
   g==;
X-CSE-ConnectionGUID: G4HMukrbSZC12nvmsDKupA==
X-CSE-MsgGUID: byTF2TsNScWOl0XimPVx5w==
X-IronPort-AV: E=McAfee;i="6800,10657,11529"; a="75734597"
X-IronPort-AV: E=Sophos;i="6.17,309,1747724400"; 
   d="scan'208";a="75734597"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2025 01:02:46 -0700
X-CSE-ConnectionGUID: nV5Fy5uyQ/e+psGksPr6ug==
X-CSE-MsgGUID: yEvuChSPTjWxAFfP30bjmw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,309,1747724400"; 
   d="scan'208";a="199530676"
Received: from yzhao56-desk.sh.intel.com ([10.239.47.19])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2025 01:02:44 -0700
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: peterx@redhat.com,
	rick.p.edgecombe@intel.com,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v3 1/3] KVM: Do not reset dirty GFNs in a memslot not enabling dirty tracking
Date: Fri, 22 Aug 2025 16:02:03 +0800
Message-ID: <20250822080203.27247-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20250822080100.27218-1-yan.y.zhao@intel.com>
References: <20250822080100.27218-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Do not allow resetting dirty GFNs in memslots that do not enable dirty
tracking.

vCPUs' dirty rings are shared between userspace and KVM. After KVM sets
dirtied entries in the dirty rings, userspace is responsible for
harvesting/resetting these entries and calling the ioctl
KVM_RESET_DIRTY_RINGS to inform KVM to advance the reset_index in the dirty
rings and invoke kvm_arch_mmu_enable_log_dirty_pt_masked() to clear the
SPTEs' dirty bits or perform write protection of the GFNs.

Although KVM does not set dirty entries for GFNs in a memslot that does not
enable dirty tracking, userspace can write arbitrary data into the dirty
ring. This makes it possible for misbehaving userspace to specify that it
has harvested a GFN from such a memslot. When this happens, KVM will be
asked to clear dirty bits or perform write protection for GFNs in a memslot
that does not enable dirty tracking, which is undesirable.

For TDX, this unexpected resetting of dirty GFNs could cause inconsistency
between the mirror SPTE and the external SPTE in hardware (e.g., the mirror
SPTE has no write bit while the external SPTE is writable). When
kvm_dirty_log_manual_protect_and_init_set() is true and huge pages are
enabled in TDX, this could even lead to kvm_mmu_slot_gfn_write_protect()
being called and trigger KVM_BUG_ON() due to permission reduction changes
in the huge mirror SPTEs.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 virt/kvm/dirty_ring.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
index 02bc6b00d76c..b38b4b7d7667 100644
--- a/virt/kvm/dirty_ring.c
+++ b/virt/kvm/dirty_ring.c
@@ -63,7 +63,13 @@ static void kvm_reset_dirty_gfn(struct kvm *kvm, u32 slot, u64 offset, u64 mask)
 
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


