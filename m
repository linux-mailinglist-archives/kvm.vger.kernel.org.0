Return-Path: <kvm+bounces-25809-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6A7296AEF6
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 05:15:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 252781C236A5
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 03:15:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BBEE47772;
	Wed,  4 Sep 2024 03:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gAm0cQeC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F7D4A15;
	Wed,  4 Sep 2024 03:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725419673; cv=none; b=eEdfYMWN4Y3OqnJtbN4KV4cPuAkPeumkqIEfL3IVjYJA7cRSS/rQI1klAVQ2z0mlDY9ncbWATsuaw8NCq+dZW45FfAok+VCv2dFH7a3w0ArBngEgB1b7mRl9D436iy17ySTMKmN84DnRK4r0mtW6TRjoxQJE7utTciLFP+Ngvd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725419673; c=relaxed/simple;
	bh=N6xlq1IwCpX/qyuRU4A8GLbVCjaqTEZLoE5Y9X5Ku0E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OwBveivPU0/2tBGknhWZOeAfSZpOjmdh/fJRR1WOIzQ/TmfzggPlYr9ISJKL1CglH/uVkzOzptJX38zHBIoM0X3b/lz75w3MMPootzG7lSW8Ihv/yw+G5kqLAr27zuCyAAdGB5MZGJflgunYmzW8OE3ndRe/XiaDIVqE6TMZVek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gAm0cQeC; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725419671; x=1756955671;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=N6xlq1IwCpX/qyuRU4A8GLbVCjaqTEZLoE5Y9X5Ku0E=;
  b=gAm0cQeC6lFtTi4V7PJ1mLR6l8FDgcMhmSJKiMsBWqc81kiRfe7mEV2k
   xpkFYJqPOp+9WnkHyidp66SDJmKWFabtdR1VA5b9lbQABtPlHVBrlDg2D
   Dbmhr7GlfMmsUsAywsxdZSFwbBmcjJYeqsi3qWjUHXBaiY1+Q1XkW6yMo
   ln5bdd7dsQ/A1QZEyeMp+Dwhwi/Dn70qER1A+uJcvmXoDmcEwam9J1UpR
   8JYohFTCwm3JK1/EGrLGZry2Rk3xiH8UTvWPSW1fucgesRGCNwaQrUFHe
   z1yxNeShnCO7WkVuUeT9Ln9FfOluN73T9hh6tlSaDjVSGMibF0+8XLDbQ
   Q==;
X-CSE-ConnectionGUID: C2bKh+8XRt+I25vl4RVQOg==
X-CSE-MsgGUID: DSvl5GeMQoykVzqwATz0sA==
X-IronPort-AV: E=McAfee;i="6700,10204,11184"; a="23564622"
X-IronPort-AV: E=Sophos;i="6.10,200,1719903600"; 
   d="scan'208";a="23564622"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 20:07:58 -0700
X-CSE-ConnectionGUID: odBDxinvTtKIfddHcEi6cQ==
X-CSE-MsgGUID: zlY3GO5PQni6XKVmJP+Uog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,200,1719903600"; 
   d="scan'208";a="65106212"
Received: from dgramcko-desk.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.221.153])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 20:07:57 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	dmatlack@google.com,
	isaku.yamahata@gmail.com,
	yan.y.zhao@intel.com,
	nik.borisov@suse.com,
	rick.p.edgecombe@intel.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH 01/21] KVM: x86/mmu: Implement memslot deletion for TDX
Date: Tue,  3 Sep 2024 20:07:31 -0700
Message-Id: <20240904030751.117579-2-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Force TDX VMs to use the KVM_X86_QUIRK_SLOT_ZAP_ALL behavior.

TDs cannot use the fast zapping operation to implement memslot deletion for
a couple reasons:
1. KVM cannot fully zap and re-build TDX private PTEs without coordinating
   with the guest. This is due to the TDs needing to "accept" memory. So
   an operation to delete a memslot needs to limit the private zapping to
   the range of the memslot.
2. For reason (1), kvm_mmu_zap_all_fast() is limited to direct (shared)
   roots. This means it will not zap the mirror (private) PTEs. If a
   memslot is deleted with private memory mapped, the private memory would
   remain mapped in the TD. Then if later the gmem fd was whole punched,
   the pages could be freed on the host while still mapped in the TD. This
   is because that operation would no longer have the memslot to map the
   pgoff to the gfn.

To handle the first case, userspace could simply set the
KVM_X86_QUIRK_SLOT_ZAP_ALL quirk for TDs. This would prevent the issue in
(1), but it is not sufficient to resolve (2) because the problems there
extend beyond the userspace's TD, to affecting the rest of the host. So the
zap-leafs-only behavior is required for both

A couple options were considered, including forcing
KVM_X86_QUIRK_SLOT_ZAP_ALL to always be on for TDs, however due to the
currently limited quirks interface (no way to query quirks, or force them
to be disabled), this would require developing additional interfaces. So
instead just do the simple thing and make TDs always do the zap-leafs
behavior like when KVM_X86_QUIRK_SLOT_ZAP_ALL is disabled.

While at it, have the new behavior apply to all non-KVM_X86_DEFAULT_VM VMs,
as the previous behavior was not ideal (see [0]). It is assumed until
proven otherwise that the other VM types will not be exposed to the bug[1]
that derailed that effort.

Memslot deletion needs to zap both the private and shared mappings of a
GFN, so update the attr_filter field in kvm_mmu_zap_memslot_leafs() to
include both.

Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Link: https://lore.kernel.org/kvm/20190205205443.1059-1-sean.j.christopherson@intel.com/ [0]
Link: https://patchwork.kernel.org/project/kvm/patch/20190205210137.1377-11-sean.j.christopherson@intel.com [1]
---
TDX MMU part 2 v1:
 - Clarify TDX limits on zapping private memory (Sean)

Memslot quirk series:
 - New patch
---
 arch/x86/kvm/mmu/mmu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a8d91cf11761..7e66d7c426c1 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7104,6 +7104,7 @@ static void kvm_mmu_zap_memslot_leafs(struct kvm *kvm, struct kvm_memory_slot *s
 		.start = slot->base_gfn,
 		.end = slot->base_gfn + slot->npages,
 		.may_block = true,
+		.attr_filter = KVM_FILTER_PRIVATE | KVM_FILTER_SHARED,
 	};
 	bool flush = false;
 
-- 
2.34.1


