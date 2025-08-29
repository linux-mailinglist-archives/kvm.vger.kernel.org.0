Return-Path: <kvm+bounces-56208-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AE890B3AECE
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 02:07:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3BE35A01B53
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 00:07:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D968C18CC13;
	Fri, 29 Aug 2025 00:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gSIJ6mp9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B65C146A72
	for <kvm@vger.kernel.org>; Fri, 29 Aug 2025 00:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756425990; cv=none; b=In51yBgb45Ad159/of4tltqJ4pd7z8TCqoiJVPJ0OvYGN0flEpxAwfaJP66GeE/zgA8iUwgeGSvcRBw51E0Rz0gdkCKUUCqaKqb5Wn1+X1DWr4sPQqw0/y+8QgPM1HB2f9MWInoPoL0OLpZiVLRPqVktzDrt3JDkLf69x3Lf4WU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756425990; c=relaxed/simple;
	bh=+SN/7jwzsBSGX3ZaBL+TtK4mD4SxZwJY0/a1k70+r9I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JK+4bp7EKOo20+4nX5xuSR2vHh1eqNhDt9i5YgQkMfHEQRkSyz0/7FRCBvVw6Usiq/ExmcxMgqwgw0IxdYAdSlG32zfDV2vrdiuorIJiBBuFP73Qpqlnr7Qxb6SY5m2x8gAjtJ3YhYhpqDOGpGE2O3VAdNPlMYGPU4XNTAEE+bQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gSIJ6mp9; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b47156acca5so1193910a12.0
        for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 17:06:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756425988; x=1757030788; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=IfvFc9viaP2S1pT15SAkIYCawAjZc30p7N/9YScLJsM=;
        b=gSIJ6mp9m3Ksn/qhMybWP55alOvQfqjOXoTprGICRdl8WARgm5a5rkdwkCz1nK9J3d
         lY/iySrdDR6Fxi6R1YK3eGeE1jjBIE+/t/jfVnZSUJKXbT1og0kuhJLFRims1wiP3wyg
         gMTSl4FY5K+ZQ6xJxa+2omLWYQr82THhhecsw7aLQc/9+jTRwfxnPozppGHP/JZtbLqy
         rNB5SE4pBj+TOrSPFZX0YAHpn/EuBQMQX1e4+2wBf8TIRVC0yTbER9aXHTw/Wz4dKfFI
         2zjC1YDl2Yr5FI+SoDkovMrW+My8migbbiWgUW0fuqt1bOOl7dMOt+foF91co3By1uyp
         rFhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756425988; x=1757030788;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IfvFc9viaP2S1pT15SAkIYCawAjZc30p7N/9YScLJsM=;
        b=pPnNrj4AZfUQ5NM6Tu/ncg7X5+2EO6WOveuyMs4ERUyBbAEDAzu7wxk9ZZYAtgeGkE
         d/Pb+S+FfWa6fr1rA8ktGVzKEH3gKEcRD6axM4RlSoYuV3WTDfvVx1cXU19PEcr5EIRe
         rOsiiEvDIUzBxLaCoRkGrSh8wADClQCmrvT6h8ECBjB6gqWVp+7JFNGw6UR7ypWzQUUL
         GJiQG9QT/CL3fexvySOlefkssxoc6mnLj9fVrwl7kL7yXLsTVG5V6T6boO6nPUK5eDnA
         WnnVLBP5CnQzFjJHmoLlEriNJpZS+ayZR77WtMN3pfmFRDBxpMGR9vim7kKSsnZ4hbPE
         BRZw==
X-Gm-Message-State: AOJu0Yw+CEvqazLwWnFw3LBClD1Rgs1z+NZqLGJd2+G2nplD1klDEQln
	CPkA7NgClxKa5W+YmZThAPpLJy3JkrAet24a2Qj7S90Q6+CkgVLFSahL60UDD6OlTzPFY3L3iSB
	AiarYtw==
X-Google-Smtp-Source: AGHT+IFQQpXTh6rHGsE3ofmt/dZ3Md25hDKkJ4b99R0cEkcoLYtIyYzC64YgEZMJ6vkZUCO2UTc7vcpF+CE=
X-Received: from pjvf13.prod.google.com ([2002:a17:90a:da8d:b0:31c:4a51:8b75])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7f96:b0:240:792:e87a
 with SMTP id adf61e73a8af0-2438facc65cmr15373768637.3.1756425986990; Thu, 28
 Aug 2025 17:06:26 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 28 Aug 2025 17:06:03 -0700
In-Reply-To: <20250829000618.351013-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250829000618.351013-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.318.gd7df087d1a-goog
Message-ID: <20250829000618.351013-4-seanjc@google.com>
Subject: [RFC PATCH v2 03/18] Revert "KVM: x86/tdp_mmu: Add a helper function
 to walk down the TDP MMU"
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ira Weiny <ira.weiny@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

Remove the helper and exports that were added to allow TDX code to reuse
kvm_tdp_map_page() for its gmem post-populate flow now that a dedicated
TDP MMU API is provided to install a mapping given a gfn+pfn pair.

This reverts commit 2608f105760115e94a03efd9f12f8fbfd1f9af4b.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu.h         |  2 --
 arch/x86/kvm/mmu/mmu.c     |  4 ++--
 arch/x86/kvm/mmu/tdp_mmu.c | 37 +++++--------------------------------
 3 files changed, 7 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 697b90a97f43..dc6b965cea4f 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -257,8 +257,6 @@ extern bool tdp_mmu_enabled;
 #define tdp_mmu_enabled false
 #endif
 
-bool kvm_tdp_mmu_gpa_is_mapped(struct kvm_vcpu *vcpu, u64 gpa);
-int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level);
 int kvm_tdp_mmu_map_private_pfn(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn);
 
 static inline bool kvm_memslots_have_rmaps(struct kvm *kvm)
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 65300e43d6a1..f808c437d738 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4904,7 +4904,8 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	return direct_page_fault(vcpu, fault);
 }
 
-int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level)
+static int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code,
+			    u8 *level)
 {
 	int r;
 
@@ -4946,7 +4947,6 @@ int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level
 		return -EIO;
 	}
 }
-EXPORT_SYMBOL_GPL(kvm_tdp_map_page);
 
 long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
 				    struct kvm_pre_fault_memory *range)
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 31d921705dee..3ea2dd64ce72 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1939,13 +1939,16 @@ bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
  *
  * Must be called between kvm_tdp_mmu_walk_lockless_{begin,end}.
  */
-static int __kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
-				  struct kvm_mmu_page *root)
+int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
+			 int *root_level)
 {
+	struct kvm_mmu_page *root = root_to_sp(vcpu->arch.mmu->root.hpa);
 	struct tdp_iter iter;
 	gfn_t gfn = addr >> PAGE_SHIFT;
 	int leaf = -1;
 
+	*root_level = vcpu->arch.mmu->root_role.level;
+
 	for_each_tdp_pte(iter, vcpu->kvm, root, gfn, gfn + 1) {
 		leaf = iter.level;
 		sptes[leaf] = iter.old_spte;
@@ -1954,36 +1957,6 @@ static int __kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
 	return leaf;
 }
 
-int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
-			 int *root_level)
-{
-	struct kvm_mmu_page *root = root_to_sp(vcpu->arch.mmu->root.hpa);
-	*root_level = vcpu->arch.mmu->root_role.level;
-
-	return __kvm_tdp_mmu_get_walk(vcpu, addr, sptes, root);
-}
-
-bool kvm_tdp_mmu_gpa_is_mapped(struct kvm_vcpu *vcpu, u64 gpa)
-{
-	struct kvm *kvm = vcpu->kvm;
-	bool is_direct = kvm_is_addr_direct(kvm, gpa);
-	hpa_t root = is_direct ? vcpu->arch.mmu->root.hpa :
-				 vcpu->arch.mmu->mirror_root_hpa;
-	u64 sptes[PT64_ROOT_MAX_LEVEL + 1], spte;
-	int leaf;
-
-	lockdep_assert_held(&kvm->mmu_lock);
-	rcu_read_lock();
-	leaf = __kvm_tdp_mmu_get_walk(vcpu, gpa, sptes, root_to_sp(root));
-	rcu_read_unlock();
-	if (leaf < 0)
-		return false;
-
-	spte = sptes[leaf];
-	return is_shadow_present_pte(spte) && is_last_spte(spte, leaf);
-}
-EXPORT_SYMBOL_GPL(kvm_tdp_mmu_gpa_is_mapped);
-
 /*
  * Returns the last level spte pointer of the shadow page walk for the given
  * gpa, and sets *spte to the spte value. This spte may be non-preset. If no
-- 
2.51.0.318.gd7df087d1a-goog


