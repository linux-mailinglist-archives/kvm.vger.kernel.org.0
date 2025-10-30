Return-Path: <kvm+bounces-61535-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5353FC222A6
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 21:14:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4D2D0188AF03
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 20:12:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6451937FC6C;
	Thu, 30 Oct 2025 20:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JeIsWZTM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 381D137EE1D
	for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 20:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761855016; cv=none; b=P0i70T0r73NO6SSRjSwhTBhbSRgHqVD9axEpX/5BujuUqKSRqJthA1VzN0/4BXrL223syHbJsgc2L6bx81XbvkpGio359mAMuWm+EdyIsY2zH2hVZ2WsS+7bTY5EhVTrErgN+R5uQtyqNjGOw8crUvLaJztIC04ZrUalOMtyQbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761855016; c=relaxed/simple;
	bh=iL9gs/36+Vag8cN5PVoyBc4UOU0u8h8j4kVKzBjrjFc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QkGW/Eu02b18pKZvPfO5KZA7j5wPiA5zC1NbI9Laj+rcn/dpGBNQwaJW4gG606H5xoNNUbBweLY7dQhQMPAHx9f8MoNN6Kvs41w2C3tnlHt+QTnlvP3Ul346ggClVnWx+/8g0ldoq2bcRn7YvVqXrplAZ8KVQTk3jRW0QMxBVpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JeIsWZTM; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-340871b5d89so129649a91.2
        for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 13:10:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761855013; x=1762459813; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=LWKZ6GH7M+zzFa/XrLh2XF2IHEzo52dgkoqprkhASvM=;
        b=JeIsWZTMq//40EaN6zLpNZimRLaIpktiS+1lE8IiY+upY61nVc4zHTpUlM55pgOjfu
         kNopOGB6uxjXeeKuyUyiDdLUCyhiEeLpAv+R/8QS+WyDrVfdLQ7ZeMitI1uioaX/8H0b
         93w57UKAPXUs4UlZoREZVuhiaGwD0iTvG6FTeZtAP5FsgEwyZz7F7sOWbEw8LWmMlKVQ
         gFflFs/d179iVoQEkFGGGruVrsU6Xqu3y7A825QEHxsaq1hcDqBHHszRpjyXo0+IPH0m
         xu1RQ5VFOBSXBYwCLrT6NupGiOnpHq2ql1fac6UeL+roVcp4Yc3hiRQ4VbBPFdCMaYBv
         eeMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761855013; x=1762459813;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LWKZ6GH7M+zzFa/XrLh2XF2IHEzo52dgkoqprkhASvM=;
        b=U3UMX1BBDXtSYAlkjsTc3UAdNzGQTaMYWgn9nZClC+fOgw9x331i7lijojHixLQptS
         ILaRaZTCFRA7cFQcLlwaYQ0N1LVTb56kCpC1IPFF3hl2cwlkVjkzJeaZd63IN8L9DyW/
         wnRarLrS8qrrji1s2r28lF/aORiARmlQwzE1x6GJV/F51+JdOWvz2zJ10IxQdH9trigb
         WsiBg9XYTSLhPL3XYC/duosEthOfRKalMMgQHvRPKKiLOAzb54YH79LcnTteOUuxeegW
         0xonzRzt+fE7xsJbO7hpMM8xe4er3/swT+lHVZd6fwdA/EHy1iUGzowW2/cieijI3LbP
         9D6Q==
X-Forwarded-Encrypted: i=1; AJvYcCVswyXi8rTxbyXr4Mk1O1vr+nD09KoBBcdhrIJH7GJjEgckzqHwiNuQ7a1ckW+gh5KDnnY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9fRdrExJib3qneWw4G7rZTR2vTM1Qjq0lLtRrxzdYae8Gh0kc
	7j5fuErXfsSjKIKJEYlRghZdLIIqXd+VfQRDeCOfzyhjPrOh1slvGazaXUdjjb47IWe0Ifsq243
	w3FcVgw==
X-Google-Smtp-Source: AGHT+IG7uuixnfesLu6aOkm8lY1M0UiQHdZ1syGC1fH0ExXdaI9kZ+0pX4GRNJah3kEFWI4QtyuhY8kfLfE=
X-Received: from pjrx14.prod.google.com ([2002:a17:90a:bc8e:b0:332:7fae:e138])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:530d:b0:330:797a:f4ea
 with SMTP id 98e67ed59e1d1-3408308b46emr1245875a91.29.1761855013586; Thu, 30
 Oct 2025 13:10:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 30 Oct 2025 13:09:29 -0700
In-Reply-To: <20251030200951.3402865-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251030200951.3402865-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
Message-ID: <20251030200951.3402865-7-seanjc@google.com>
Subject: [PATCH v4 06/28] Revert "KVM: x86/tdp_mmu: Add a helper function to
 walk down the TDP MMU"
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, "Kirill A. Shutemov" <kas@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, x86@kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, 
	Kai Huang <kai.huang@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

Remove the helper and exports that were added to allow TDX code to reuse
kvm_tdp_map_page() for its gmem post-populate flow now that a dedicated
TDP MMU API is provided to install a mapping given a gfn+pfn pair.

This reverts commit 2608f105760115e94a03efd9f12f8fbfd1f9af4b.

Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu.h         |  2 --
 arch/x86/kvm/mmu/mmu.c     |  4 ++--
 arch/x86/kvm/mmu/tdp_mmu.c | 37 +++++--------------------------------
 3 files changed, 7 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 2f108e381959..9e5045a60d8b 100644
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
index bad0480bdb0d..3a5104e4127a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4924,7 +4924,8 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	return direct_page_fault(vcpu, fault);
 }
 
-int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level)
+static int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code,
+			    u8 *level)
 {
 	int r;
 
@@ -4966,7 +4967,6 @@ int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level
 		return -EIO;
 	}
 }
-EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_tdp_map_page);
 
 long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
 				    struct kvm_pre_fault_memory *range)
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 440fd8f80397..e735d2f8367b 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1941,13 +1941,16 @@ bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
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
@@ -1956,36 +1959,6 @@ static int __kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
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
-EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_tdp_mmu_gpa_is_mapped);
-
 /*
  * Returns the last level spte pointer of the shadow page walk for the given
  * gpa, and sets *spte to the spte value. This spte may be non-preset. If no
-- 
2.51.1.930.gacf6e81ea2-goog


