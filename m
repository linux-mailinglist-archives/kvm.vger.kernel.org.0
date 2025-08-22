Return-Path: <kvm+bounces-55481-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C2AAB30FDA
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 09:05:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D83737BEF18
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 07:03:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA4A52E764E;
	Fri, 22 Aug 2025 07:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CNrxXIgi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB302236FD;
	Fri, 22 Aug 2025 07:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755846290; cv=none; b=sPTkGsZ3WWpVx5qFzINsGMm8QOgRf9jDZcq/hWXmoUc0HK0908FLRUk/KKCDWm9KtoqzhX8e4tbwjJhTpGRCmpb37yCDD4pFxD7kEScCk/nDY0TFE2KYuAxiRZRVvrRllspFxzrzXlOFM+zIJyLE9oB4XMR9xWQdUzZynetGEJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755846290; c=relaxed/simple;
	bh=xmBXjO8SZupecrd5krZAb/9zMHsYWEIsecBzZ3vXRTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UR4eluNjtDvcrDuzK44A28PVBkka8Zxcx/p5pN5nBLSvT8Bf8Lcpp7pBFtFwbX2tMIRSgADgVC8dJjPICFusOpI6Eo/I53KAsy4gxd9RKdu2cbWpWWn3qed1uKgMejFlFFEzs9ktHhNs10XZ2uhTFW7wL8+ohCxvZt8sEaiRe48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CNrxXIgi; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755846288; x=1787382288;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xmBXjO8SZupecrd5krZAb/9zMHsYWEIsecBzZ3vXRTk=;
  b=CNrxXIgif5o5ta+YJ8bPAmRwQ/WyuPrsmsUAwj3XFwMGrt36l6Ar8Uo1
   c/OoldPZsn4OFuJlRdw7YaiYzXh6xBX+Yn16ZOWQA7KlsBuaerXyJwKZW
   ExGuLI+vLk6uQYgkH0Wo5OhP/a3cB0H/eTcuEELU/sBzJbV6zGBbfgzVS
   xL3emR41T/3qY9rzHMb7/BlldCD896Q1R2Kmsa2XnEhueIOPB/lCwVqri
   V9yMEf7uIYUhwb56Eb0xsZCah+Bmjk12RHM78+FKJFCgN2kgwd+c/6nTa
   7vm8fTyRLjX14uOK/BmfWugnDAa6ORzH3xJiBooR/UIc4muErC0bGH39S
   g==;
X-CSE-ConnectionGUID: KiEJp8JIR+y2YKjW2TX1fw==
X-CSE-MsgGUID: 4fuuzBU6RCy/aaz8Ifsmmg==
X-IronPort-AV: E=McAfee;i="6800,10657,11529"; a="58012685"
X-IronPort-AV: E=Sophos;i="6.17,309,1747724400"; 
   d="scan'208";a="58012685"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2025 00:04:47 -0700
X-CSE-ConnectionGUID: vvUvI6jpR8G82h0pBNSo5w==
X-CSE-MsgGUID: f0mWsXUNSJuSX++dpyW26w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,309,1747724400"; 
   d="scan'208";a="199595996"
Received: from yzhao56-desk.sh.intel.com ([10.239.47.19])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2025 00:04:45 -0700
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: reinette.chatre@intel.com,
	rick.p.edgecombe@intel.com,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v2 1/3] KVM: x86/mmu: Return -EAGAIN if userspace deletes/moves memslot during prefault
Date: Fri, 22 Aug 2025 15:03:47 +0800
Message-ID: <20250822070347.26451-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20250822070305.26427-1-yan.y.zhao@intel.com>
References: <20250822070305.26427-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sean Christopherson <seanjc@google.com>

Return -EAGAIN if userspace attempts to delete or move a memslot while also
prefaulting memory for that same memslot, i.e. force userspace to retry
instead of trying to handle the scenario entirely within KVM.  Unlike
KVM_RUN, which needs to handle the scenario entirely within KVM because
userspace has come to depend on such behavior, KVM_PRE_FAULT_MEMORY can
return -EAGAIN without breaking userspace as this scenario can't have ever
worked (and there's no sane use case for prefaulting to a memslot that's
being deleted/moved).

And also unlike KVM_RUN, the prefault path doesn't naturally gaurantee
forward progress.  E.g. to handle such a scenario, KVM would need to drop
and reacquire SRCU to break the deadlock between the memslot update
(synchronizes SRCU) and the prefault (waits for the memslot update to
complete).

However, dropping SRCU creates more problems, as completing the memslot
update will bump the memslot generation, which in turn will invalidate the
MMU root.  To handle that, prefaulting would need to handle pending
KVM_REQ_MMU_FREE_OBSOLETE_ROOTS requests and do kvm_mmu_reload() prior to
mapping each individual.

I.e. to fully handle this scenario, prefaulting would eventually need to
look a lot like vcpu_enter_guest().  Given that there's no reasonable use
case and practically zero risk of breaking userspace, punt the problem to
userspace and avoid adding unnecessary complexity to the prefualt path.

Note, TDX's guest_memfd post-populate path is unaffected as slots_lock is
held for the entire duration of populate(), i.e. any memslot modifications
will be fully serialized against TDX's flavor of prefaulting.

Reported-by: Reinette Chatre <reinette.chatre@intel.com>
Closes: https://lore.kernel.org/all/20250519023737.30360-1-yan.y.zhao@intel.com
Debugged-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 92ff15969a36..f31fad33c423 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4653,10 +4653,16 @@ static int kvm_mmu_faultin_pfn(struct kvm_vcpu *vcpu,
 	/*
 	 * Retry the page fault if the gfn hit a memslot that is being deleted
 	 * or moved.  This ensures any existing SPTEs for the old memslot will
-	 * be zapped before KVM inserts a new MMIO SPTE for the gfn.
+	 * be zapped before KVM inserts a new MMIO SPTE for the gfn.  Punt the
+	 * error to userspace if this is a prefault, as KVM's prefaulting ABI
+	 * doesn't need provide the same forward progress guarantees as KVM_RUN.
 	 */
-	if (slot->flags & KVM_MEMSLOT_INVALID)
+	if (slot->flags & KVM_MEMSLOT_INVALID) {
+		if (fault->prefetch)
+			return -EAGAIN;
+
 		return RET_PF_RETRY;
+	}
 
 	if (slot->id == APIC_ACCESS_PAGE_PRIVATE_MEMSLOT) {
 		/*
-- 
2.43.2


