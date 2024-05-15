Return-Path: <kvm+bounces-17403-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BA46E8C5E8F
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 03:02:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E7ECD1C208D3
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 01:02:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8928D2E416;
	Wed, 15 May 2024 01:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iq4SykKi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 170C9208CA;
	Wed, 15 May 2024 01:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715734810; cv=none; b=b1vCsnPZcwNO0ScMairq4uhrL+ABdJylPRcDllP8IEY+ei5z8pZwCazFF3FRF5r7znVHDtWzx3tTH+v+YHNakGO0ekpLWmPN0Yzm521xZJryzv/96XWv7G9zDwGCr0extwbs8Zn2m/iWTbTKqm0fzhAIdyM4l3qy6ZljGIKtpaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715734810; c=relaxed/simple;
	bh=F8pMCkdedaDEThDQRu19WnnjslknaUfMOKX2A+N1yxQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nD8S8lczp9Rfquuhtim4MfeNOXiy+h4ugXeZTdItiS4nLRWja3UtHiMgUoOX3zwhQ35N0nfPBiiQTKDRb6BuKJXslnnFX5fvIF6ppqpb82KK0tSvLGT289APcVL+U+wQMYKeVQpZtBOBLnL4ugxbekYlSmwx6L2qq/21uw7vW7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iq4SykKi; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715734809; x=1747270809;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=F8pMCkdedaDEThDQRu19WnnjslknaUfMOKX2A+N1yxQ=;
  b=iq4SykKiBCkQRz22jrQ8/Fg8/A2SipiWvWkvsku1XngWBLP9Z2ylxqos
   SwxC9ZBECrxA5toFzxEfa7L0luihlFJVGr1oEJTdUEiAtHRm2ERiQvHR9
   HYzUle236moJVhbfGdQzkWIXjfUle8A7gkPx7luh4geyDLMm32Ebuz4Dj
   Lw7NKIPEkMeP4pr5HKL1zD2gbSj4R5tvJjBq5FVB1BtZM/fdTi+5XWKpc
   Er48fqj46pZNW4zptZj3OuHQdz9cqFyYY1RpqaclQyxPctd8yQaXv3wqD
   djomzv1WJeNbQe+IwzBhCUCjQfo5pDmJ/ehMQgGMuIk9IlT96ya65iGLm
   A==;
X-CSE-ConnectionGUID: aucpdI9cT6emLVw5xIz7CA==
X-CSE-MsgGUID: 5K97AqX5Sxq2COkilqo6rA==
X-IronPort-AV: E=McAfee;i="6600,9927,11073"; a="11613967"
X-IronPort-AV: E=Sophos;i="6.08,160,1712646000"; 
   d="scan'208";a="11613967"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2024 18:00:06 -0700
X-CSE-ConnectionGUID: AOJ4G5LsTwGNnoW5TOQ9hw==
X-CSE-MsgGUID: puttENqYQQS+WPln4B9VHA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,160,1712646000"; 
   d="scan'208";a="30942777"
Received: from oyildiz-mobl1.amr.corp.intel.com (HELO rpedgeco-desk4.intel.com) ([10.209.51.34])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2024 18:00:05 -0700
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
Subject: [PATCH 09/16] KVM: x86/mmu: Make kvm_tdp_mmu_alloc_root() return void
Date: Tue, 14 May 2024 17:59:45 -0700
Message-Id: <20240515005952.3410568-10-rick.p.edgecombe@intel.com>
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

The kvm_tdp_mmu_alloc_root() function currently always returns 0. This
allows for the caller, mmu_alloc_direct_roots(), to call
kvm_tdp_mmu_alloc_root() and also return 0 in one line:
   return kvm_tdp_mmu_alloc_root(vcpu);

So it is useful even though the return value of kvm_tdp_mmu_alloc_root()
is always the same. However, in future changes, kvm_tdp_mmu_alloc_root()
will be called twice in mmu_alloc_direct_roots(). This will force the
first call to either awkwardly handle the return value that will always
be zero or ignore it. So change kvm_tdp_mmu_alloc_root() to return void.
Do it in a separate change so the future change will be cleaner.

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
TDX MMU Part 1:
 - New patch
---
 arch/x86/kvm/mmu/mmu.c     | 6 ++++--
 arch/x86/kvm/mmu/tdp_mmu.c | 3 +--
 arch/x86/kvm/mmu/tdp_mmu.h | 2 +-
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 808805b3478d..76f92cb37a96 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3700,8 +3700,10 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 	unsigned i;
 	int r;
 
-	if (tdp_mmu_enabled)
-		return kvm_tdp_mmu_alloc_root(vcpu);
+	if (tdp_mmu_enabled) {
+		kvm_tdp_mmu_alloc_root(vcpu);
+		return 0;
+	}
 
 	write_lock(&vcpu->kvm->mmu_lock);
 	r = make_mmu_pages_available(vcpu);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 6fa910b017d1..0d6d96d86703 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -224,7 +224,7 @@ static void tdp_mmu_init_child_sp(struct kvm_mmu_page *child_sp,
 	tdp_mmu_init_sp(child_sp, iter->sptep, iter->gfn, role);
 }
 
-int kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu)
+void kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	union kvm_mmu_page_role role = mmu->root_role;
@@ -285,7 +285,6 @@ int kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu)
 	 */
 	mmu->root.hpa = __pa(root->spt);
 	mmu->root.pgd = 0;
-	return 0;
 }
 
 static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 58b55e61bd33..437ddd4937a9 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -10,7 +10,7 @@
 void kvm_mmu_init_tdp_mmu(struct kvm *kvm);
 void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm);
 
-int kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu);
+void kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu);
 
 __must_check static inline bool kvm_tdp_mmu_get_root(struct kvm_mmu_page *root)
 {
-- 
2.34.1


