Return-Path: <kvm+bounces-20163-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BBE25911243
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 21:37:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD83D1C22A0F
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 19:37:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B84091BA091;
	Thu, 20 Jun 2024 19:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Uv0tDssc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 143AF1B9AD6;
	Thu, 20 Jun 2024 19:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718912227; cv=none; b=VXhrGdKY5UNuV5dxOvuTarY2KBo1KDYTzxudxSyn6GbMtUV6VEzYG3bU62v5oKWa7uUpRE4LlBng1niNYIhnTobI4HHcAJgiYgpxKw7dS2CH4w9inxi7CM39bCLuvoN/F/VxowdcQriH6tZ1WndZmamDgKXajBIwjPa//ZC+Zc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718912227; c=relaxed/simple;
	bh=yZz3lSM2+eyxM8s5zcUsYg12gHFKn/bb+Dk6U7uPnJs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=p4DJUWZdG9dJDM0heFYx5uXwdGkeufYmr4nbsbTV5YwdjNf53oEE6zaCKhHdLQjDonoSvCA/AfxQCp4TYbDO0xqiTQBrEDwrXjxfYczXV9zOLZ8d8wGJvuIVYNXO3s/vYK+eyBQewne7ZxjlyAF+97xvg9qSSpwR1ka4OWHaYa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Uv0tDssc; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718912226; x=1750448226;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yZz3lSM2+eyxM8s5zcUsYg12gHFKn/bb+Dk6U7uPnJs=;
  b=Uv0tDsscAZ2VHP2lyRo/z4EmRS1ykap8rvHH3rp0R/VkC24rY57LWjlr
   XXiDGLiGzY8HM2Vde0ZY4YoG2yAN16coEUH+PiIIW7BP9ip7Zw7JZ5ESt
   5TpXp4n1k219p9ldyG4XSKOHjOiL7NT7fnvazggKAuWbfJVHYW5aSFo7s
   f8P14KeWAq5fYnwBNtg7MTj9b8ySeEtk0Gq0nlAJgxoswIeG7zZHT/h4Y
   zF12BrIF/hHpAHK3gqNKqFP5Pa+hc6wAH+wJalw6tuOgc5W3qyOeyijIp
   EUyVhxRgjgRBJ9vhUa36qgQmx++pcvsq/1qPVCw0zHVhjw8FzHpWGSnEh
   w==;
X-CSE-ConnectionGUID: YSZGvN5gSKGdtCrgBH/O0g==
X-CSE-MsgGUID: a7F6Z5ZkRECUrycot67ncQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11109"; a="15754131"
X-IronPort-AV: E=Sophos;i="6.08,252,1712646000"; 
   d="scan'208";a="15754131"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2024 12:37:05 -0700
X-CSE-ConnectionGUID: x18nf85+Teic2oICoGRKXg==
X-CSE-MsgGUID: FgbdG7gjRByz6F9l8eM6Pw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,252,1712646000"; 
   d="scan'208";a="42806941"
Received: from wjayasek-mobl1.amr.corp.intel.com (HELO rpedgeco-desk4.intel.com) ([10.209.71.12])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2024 12:37:06 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: yan.y.zhao@intel.com
Cc: dmatlack@google.com,
	erdemaktas@google.com,
	isaku.yamahata@intel.com,
	kai.huang@intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	pbonzini@redhat.com,
	rick.p.edgecombe@intel.com,
	sagis@google.com,
	seanjc@google.com
Subject: [PATCH] KVM: x86/mmu: Implement memslot deletion for TDX
Date: Thu, 20 Jun 2024 12:37:01 -0700
Message-Id: <20240620193701.374519-1-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240613060708.11761-1-yan.y.zhao@intel.com>
References: <20240613060708.11761-1-yan.y.zhao@intel.com>
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
1. KVM cannot zap TDX private PTEs and re-fault them without coordinating
   with the guest. This is due to the TDs needing to "accept" memory. So an
   operation to delete a memslot needs to limit the private zapping to the
   range of the memslot.
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

Here is the patch for TDX integration. It is not needed until we can
actually create KVM_X86_TDX_VMs.

Admittedly, this kind of combines two changes, but the amount of code is
very small so I left it as one patch.

 arch/x86/kvm/mmu.h     | 6 ++++++
 arch/x86/kvm/mmu/mmu.c | 3 ++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 7b12ba761c51..72ed6c07719a 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -335,4 +335,10 @@ static inline bool kvm_is_addr_direct(struct kvm *kvm, gpa_t gpa)
 
 	return !gpa_direct_bits || (gpa & gpa_direct_bits);
 }
+
+static inline bool kvm_memslot_flush_zap_all(struct kvm *kvm)
+{
+	return kvm->arch.vm_type == KVM_X86_DEFAULT_VM &&
+	       kvm_check_has_quirk(kvm, KVM_X86_QUIRK_SLOT_ZAP_ALL);
+}
 #endif
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 42faad76806a..8212bf77af70 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6993,6 +6993,7 @@ static void kvm_mmu_zap_memslot_leafs(struct kvm *kvm, struct kvm_memory_slot *s
 		.start = slot->base_gfn,
 		.end = slot->base_gfn + slot->npages,
 		.may_block = true,
+		.attr_filter = KVM_FILTER_PRIVATE | KVM_FILTER_SHARED,
 	};
 	bool flush = false;
 
@@ -7013,7 +7014,7 @@ static void kvm_mmu_zap_memslot_leafs(struct kvm *kvm, struct kvm_memory_slot *s
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 				   struct kvm_memory_slot *slot)
 {
-	if (kvm_check_has_quirk(kvm, KVM_X86_QUIRK_SLOT_ZAP_ALL))
+	if (kvm_memslot_flush_zap_all(kvm))
 		kvm_mmu_zap_all_fast(kvm);
 	else
 		kvm_mmu_zap_memslot_leafs(kvm, slot);
-- 
2.34.1


