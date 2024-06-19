Return-Path: <kvm+bounces-20020-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D8A190F916
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 00:37:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0B0661F22558
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 22:37:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFEF115EFC3;
	Wed, 19 Jun 2024 22:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z86INrjj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79ECB15B541;
	Wed, 19 Jun 2024 22:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718836588; cv=none; b=HvQg4MIECV/PWP5OAxoDvV7mQWq7CU8YX9x0YnjG3Wu1gxWYA5ZOIKsz5eMRzji3CyeSpwMlU/+BiWNrg2BaQgviiDpBqTZI3Sr2a5MbdzZnkL/T0ZGJ8D9exJhC34zlGmPZzOx3uywq6mwzt9U1KJ2/iF08ngC8otxogLOTamE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718836588; c=relaxed/simple;
	bh=yDbz8LgSURR5PSzpxuXHfQKkHmHCkhHdnFkVmC/D5YQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aX+8GAiLpr8adKl+5v3ailpdQ63Z+UeyRLKCe5pcH6QDoP0tvLhxbCw8mHq2R9yb9WDDPb5YlnqmOEXpG9T2O3UdPvKrxMEwz/t0AjxuSsNAo8UltpIHjBXES+PIUc+SjqfKIzCI59n2/QR6DRoXbToRZf5QVQBIMpFFvTO7JAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z86INrjj; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718836586; x=1750372586;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yDbz8LgSURR5PSzpxuXHfQKkHmHCkhHdnFkVmC/D5YQ=;
  b=Z86INrjjh4bACaqE5HxiO63k5KGt34h69F/xoi0D7F3lSjt9UPXdS2IA
   3CoBru11wDDRu4kSWfLjqJF01q4pUzoSXNahMvI0lkE9Fb5I/7hjZgDlp
   GkSJyk8ceB4zmKh2J0tMrAcpAdqLdHnuEMQdtQrDJp4jgOu/QRfPQTy5t
   6BNMnNqrTUDkUGt7SGE5nNRNkssJG0vKzr22HbKY6rdREwenF9X1pO5NX
   5mH6sc9D8tWC1E3dog8zGo7dkgwHLlvGfhiJtScE/fzJJq/9cWcxGLzQn
   cUXyxCokGnUhhcPboPB3SNSrALqmKhI2Ig6QZ0qKPDAQXmV2C3F5/ErHr
   g==;
X-CSE-ConnectionGUID: 1vA48aL3QeWYBZLpu8AJSw==
X-CSE-MsgGUID: nADY+JWkTo2cf1jMhoIYrA==
X-IronPort-AV: E=McAfee;i="6700,10204,11108"; a="15931951"
X-IronPort-AV: E=Sophos;i="6.08,251,1712646000"; 
   d="scan'208";a="15931951"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2024 15:36:21 -0700
X-CSE-ConnectionGUID: lPtdsyU4TnK+1ZhKMJR2ug==
X-CSE-MsgGUID: JLYqCEFJT0uUk3zALBZfSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,251,1712646000"; 
   d="scan'208";a="72793336"
Received: from ivsilic-mobl2.amr.corp.intel.com (HELO rpedgeco-desk4.intel.com) ([10.209.54.39])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2024 15:36:21 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	dmatlack@google.com,
	erdemaktas@google.com,
	isaku.yamahata@gmail.com,
	linux-kernel@vger.kernel.org,
	sagis@google.com,
	yan.y.zhao@intel.com,
	rick.p.edgecombe@intel.com
Subject: [PATCH v3 06/17] KVM: x86/mmu: Make kvm_tdp_mmu_alloc_root() return void
Date: Wed, 19 Jun 2024 15:36:03 -0700
Message-Id: <20240619223614.290657-7-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240619223614.290657-1-rick.p.edgecombe@intel.com>
References: <20240619223614.290657-1-rick.p.edgecombe@intel.com>
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
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
TDX MMU Prep v3:
 - Add Paolo's reviewed-by

TDX MMU Prep:
 - New patch
---
 arch/x86/kvm/mmu/mmu.c     | 6 ++++--
 arch/x86/kvm/mmu/tdp_mmu.c | 3 +--
 arch/x86/kvm/mmu/tdp_mmu.h | 2 +-
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8023cebeefaa..138e7bbcda1e 100644
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
index 35249555b585..07b0b884e246 100644
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


