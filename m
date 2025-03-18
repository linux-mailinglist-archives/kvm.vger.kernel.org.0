Return-Path: <kvm+bounces-41340-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F79EA6652C
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 02:35:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0FF97176BDA
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 01:34:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1485D146D65;
	Tue, 18 Mar 2025 01:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Hf+XGVFA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A12BC335C0;
	Tue, 18 Mar 2025 01:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742261679; cv=none; b=Gnd+UYO4dy99XSEr1ZYFe1QoPWxBj5Rws69JnQ/r1tVlCxYP+2mZACTtWF5vKDZF4quylb1RZjDm3GCwj44hx/Mdgnnp6nFrAJwgKOL5Shpk4s2liOBV0qiShG9aC31RAx9g10IJwBtg9HaDO89+odfuZkQMvkikhYxODhNZ+Rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742261679; c=relaxed/simple;
	bh=vvkZUaLrHnUJHGxnetVQdXOSxMK2s/AEG29SSV0tqc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HFyRPu74Q368/JpSxk710qOnVmBzb1ATaKUGnpek+Pq0MTtjof97S/ivDEDOHkHKsd/EFu2zGeCWJWqVsGrGdjOAmmbbdM77ezsIC0MvXR32lUIXm5lQHSJNx9KoOuqdNKXRI1rRA+G/JEsya2bClQ1cdVUK9i9NhgoRZWwsiWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Hf+XGVFA; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742261678; x=1773797678;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vvkZUaLrHnUJHGxnetVQdXOSxMK2s/AEG29SSV0tqc0=;
  b=Hf+XGVFA2n5R2d42UH5nolEapapT6OVwgwsU/cUjSGq0WvX/20nOk7A/
   9f/eWw8JndEC9DkPMjamVGaPBr/ZZKaxM4c2yunfecoicc41e1qwBF5WA
   n+c8wXUTYIwpQmkmCreUQFizl8xpb3DxScQuEl7sdnLHxSiybqopvbpKP
   hSA9Fsarw9qm5txil1sfYm1LyFp/8oFp1mUCGHPOvjRrsoSpupiMa1baK
   w+ElmakP0JV7G/QdnltaVpM0adcG5Iyr5rhTqQRw4dXqEv5VzByfAjWv7
   zh3Az6G7Cp6C+J0oLiRwUAsr0lwdXZxBMzkDu+Mmh5fhDzRBe0g6HLGCE
   A==;
X-CSE-ConnectionGUID: 9XMKcNb6Tuagua1kwILeGA==
X-CSE-MsgGUID: 6tvOL6YPSE2eWUrKlDuNOw==
X-IronPort-AV: E=McAfee;i="6700,10204,11376"; a="47269874"
X-IronPort-AV: E=Sophos;i="6.14,255,1736841600"; 
   d="scan'208";a="47269874"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2025 18:34:37 -0700
X-CSE-ConnectionGUID: NDAEbuUDR2uGardIrFORsA==
X-CSE-MsgGUID: fiedTt/KRaWdBpeKeQapgA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,255,1736841600"; 
   d="scan'208";a="122131390"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2025 18:34:35 -0700
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v2 4/5] KVM: x86/mmu: Warn if PFN changes on shadow-present SPTE in shadow MMU
Date: Tue, 18 Mar 2025 09:33:10 +0800
Message-ID: <20250318013310.5781-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20250318013038.5628-1-yan.y.zhao@intel.com>
References: <20250318013038.5628-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Warn if PFN changes on shadow-present SPTE in mmu_set_spte().

KVM should _never_ change the PFN of a shadow-present SPTE. In
mmu_set_spte(), there is a WARN_ON_ONCE() on pfn changes on shadow-present
SPTE in mmu_spte_update() to detect this condition. However, that
WARN_ON_ONCE() is not hittable since mmu_set_spte() invokes drop_spte()
earlier before mmu_spte_update(), which clears SPTE to a !shadow-present
state. So, before invoking drop_spte(), add a WARN_ON_ONCE() in
mmu_set_spte() to warn PFN change of a shadow-present SPTE.

For the spurious prefetch fault, only return RET_PF_SPURIOUS directly when
PFN is not changed. When PFN changes, fall through to follow the sequence
of drop_spte(), warn of PFN change, make_spte(), flush tlb, rmap_add().

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 94c677f8cc05..607cbb19ea96 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2846,7 +2846,8 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 	}
 
 	if (is_shadow_present_pte(*sptep)) {
-		if (prefetch && is_last_spte(*sptep, level))
+		if (prefetch && is_last_spte(*sptep, level) &&
+		    pfn == spte_to_pfn(*sptep))
 			return RET_PF_SPURIOUS;
 
 		/*
@@ -2860,7 +2861,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 			child = spte_to_child_sp(pte);
 			drop_parent_pte(vcpu->kvm, child, sptep);
 			flush = true;
-		} else if (pfn != spte_to_pfn(*sptep)) {
+		} else if (WARN_ON_ONCE(pfn != spte_to_pfn(*sptep))) {
 			drop_spte(vcpu->kvm, sptep);
 			flush = true;
 		} else
-- 
2.43.2


