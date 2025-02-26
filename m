Return-Path: <kvm+bounces-39366-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 10472A46B7E
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 20:57:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 18DB23AABCB
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 19:56:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0416E25D552;
	Wed, 26 Feb 2025 19:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hZl5Ir4u"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6218625A659
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 19:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740599747; cv=none; b=Vg9QrSD7kGUwE3TA2Yhq+28orfShckypaWiW0aOgHE/o7LTNa7t2brkAY9jZ3YhGv8Q9HKvPGwEv3wtQ4eQfOiJrXoBW3xeScC1N3h2nMa8uLbAxiPBePWwdyjkYlZ/ugsxTPYwviw3UFbAhrS/3jQlIvUXTNQ5LxiENlRadeQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740599747; c=relaxed/simple;
	bh=F/ElMsRyKHW98cCVtsU7nZs3X1Oye+965XrPrtj+S5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cGDALYnGYBLhiXEHQesFErlTeRL43nL0B3UmLzZOURUjlQn4a3PRmoUpjlz17E1PC0VtH/F2jKZH5r4ezZLVTwZVt0pHs755hix5sCIb/VKQ1tjm0lY+NDQY3ttQg6ruHbDStP8GxSRoM8231Mel8kCgs18rzelL/UXm+xw7ans=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hZl5Ir4u; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740599744;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7CVED5K0DPAsIBLFdlZi8ssHHoQwINfn2NzlJIvPUEk=;
	b=hZl5Ir4uEv8B2TAGSU0uThgqP7rObKLtYYO/u5C0oAuPqqL3S6IRLLwijmfeomh7vkcJfj
	GFKuKC7METBvUFcRAIqo59BpDC/ePOfvOUONKqJ8Q72ZLzIcv6rXTPN9rn0edYzR3zVX5I
	yhO8xShv7SsJp1frA9HAyy43u54TuHQ=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-558-ko3nC-gQNFuhUkyjpuplLA-1; Wed,
 26 Feb 2025 14:55:42 -0500
X-MC-Unique: ko3nC-gQNFuhUkyjpuplLA-1
X-Mimecast-MFC-AGG-ID: ko3nC-gQNFuhUkyjpuplLA_1740599741
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4C01719783B2;
	Wed, 26 Feb 2025 19:55:41 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 58AAB196ADAB;
	Wed, 26 Feb 2025 19:55:40 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	Yan Zhao <yan.y.zhao@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>
Subject: [PATCH 07/29] KVM: x86/tdp_mmu: Add a helper function to walk down the TDP MMU
Date: Wed, 26 Feb 2025 14:55:07 -0500
Message-ID: <20250226195529.2314580-8-pbonzini@redhat.com>
In-Reply-To: <20250226195529.2314580-1-pbonzini@redhat.com>
References: <20250226195529.2314580-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

From: Isaku Yamahata <isaku.yamahata@intel.com>

Export a function to walk down the TDP without modifying it and simply
check if a GPA is mapped.

Future changes will support pre-populating TDX private memory. In order to
implement this KVM will need to check if a given GFN is already
pre-populated in the mirrored EPT. [1]

There is already a TDP MMU walker, kvm_tdp_mmu_get_walk() for use within
the KVM MMU that almost does what is required. However, to make sense of
the results, MMU internal PTE helpers are needed. Refactor the code to
provide a helper that can be used outside of the KVM MMU code.

Refactoring the KVM page fault handler to support this lookup usage was
also considered, but it was an awkward fit.

kvm_tdp_mmu_gpa_is_mapped() is based on a diff by Paolo Bonzini.

Link: https://lore.kernel.org/kvm/ZfBkle1eZFfjPI8l@google.com/ [1]
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <20241112073457.22011-1-yan.y.zhao@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu.h         |  3 +++
 arch/x86/kvm/mmu/mmu.c     |  3 +--
 arch/x86/kvm/mmu/tdp_mmu.c | 37 ++++++++++++++++++++++++++++++++-----
 3 files changed, 36 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 050a0e229a4d..8d0fca4b4a50 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -253,6 +253,9 @@ extern bool tdp_mmu_enabled;
 #define tdp_mmu_enabled false
 #endif
 
+bool kvm_tdp_mmu_gpa_is_mapped(struct kvm_vcpu *vcpu, u64 gpa);
+int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level);
+
 static inline bool kvm_memslots_have_rmaps(struct kvm *kvm)
 {
 	return !tdp_mmu_enabled || kvm_shadow_root_allocated(kvm);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 9d5d50e2464f..800684c3b2c9 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4685,8 +4685,7 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	return direct_page_fault(vcpu, fault);
 }
 
-static int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code,
-			    u8 *level)
+int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level)
 {
 	int r;
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 046b6ba31197..22675a5746d0 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1894,16 +1894,13 @@ bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
  *
  * Must be called between kvm_tdp_mmu_walk_lockless_{begin,end}.
  */
-int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
-			 int *root_level)
+static int __kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
+				  struct kvm_mmu_page *root)
 {
-	struct kvm_mmu_page *root = root_to_sp(vcpu->arch.mmu->root.hpa);
 	struct tdp_iter iter;
 	gfn_t gfn = addr >> PAGE_SHIFT;
 	int leaf = -1;
 
-	*root_level = vcpu->arch.mmu->root_role.level;
-
 	tdp_mmu_for_each_pte(iter, vcpu->kvm, root, gfn, gfn + 1) {
 		leaf = iter.level;
 		sptes[leaf] = iter.old_spte;
@@ -1912,6 +1909,36 @@ int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
 	return leaf;
 }
 
+int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
+			 int *root_level)
+{
+	struct kvm_mmu_page *root = root_to_sp(vcpu->arch.mmu->root.hpa);
+	*root_level = vcpu->arch.mmu->root_role.level;
+
+	return __kvm_tdp_mmu_get_walk(vcpu, addr, sptes, root);
+}
+
+bool kvm_tdp_mmu_gpa_is_mapped(struct kvm_vcpu *vcpu, u64 gpa)
+{
+	struct kvm *kvm = vcpu->kvm;
+	bool is_direct = kvm_is_addr_direct(kvm, gpa);
+	hpa_t root = is_direct ? vcpu->arch.mmu->root.hpa :
+				 vcpu->arch.mmu->mirror_root_hpa;
+	u64 sptes[PT64_ROOT_MAX_LEVEL + 1], spte;
+	int leaf;
+
+	lockdep_assert_held(&kvm->mmu_lock);
+	rcu_read_lock();
+	leaf = __kvm_tdp_mmu_get_walk(vcpu, gpa, sptes, root_to_sp(root));
+	rcu_read_unlock();
+	if (leaf < 0)
+		return false;
+
+	spte = sptes[leaf];
+	return is_shadow_present_pte(spte) && is_last_spte(spte, leaf);
+}
+EXPORT_SYMBOL_GPL(kvm_tdp_mmu_gpa_is_mapped);
+
 /*
  * Returns the last level spte pointer of the shadow page walk for the given
  * gpa, and sets *spte to the spte value. This spte may be non-preset. If no
-- 
2.43.5



