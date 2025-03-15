Return-Path: <kvm+bounces-41132-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DEEF9A624C4
	for <lists+kvm@lfdr.de>; Sat, 15 Mar 2025 03:40:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0C4BC3B993A
	for <lists+kvm@lfdr.de>; Sat, 15 Mar 2025 02:40:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17BB918C930;
	Sat, 15 Mar 2025 02:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XNAC9G4O"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFDFD1DDE9
	for <kvm@vger.kernel.org>; Sat, 15 Mar 2025 02:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742006416; cv=none; b=LmYzYESK1G4/K+9OyUe2OnCqhbP475dZ7AWT/EznQGSAWvc9DszUrW86z99V2mFdRFAjeEJQVNqadIdFLK0/FdwTDqm0gE1hYWm9rgCcTnXlGN9AfEPJCMF9z0e/yRPPui0lqyAKJ73MZIbL4j8VjqODXL1XgrlpXdRVtG7PdRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742006416; c=relaxed/simple;
	bh=hHQMhqoJXwkU2iQFu0bAessW5nDhl6z0kwwuyI+P114=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YfkbI5sxXwdQxspZK94nk+UcmYIS2FPoxR3v79rzNQUd+tBfsNmBhC7a2hheoghuNk+Of1i6snUVG8hkshNV6TRO/kT1af3GqioDLgJQgE1Ac+0Od1WKqeNbkFapSU+rn1tVXJci4ndzy+OJWhBWdbcjTLtPK7M5bbZzz24kBbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XNAC9G4O; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-224192ff68bso40356255ad.1
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 19:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742006414; x=1742611214; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=8AnAaiMp1pogiyQq/P5ffzpAjmvR1I8H8po4dFjhB2Q=;
        b=XNAC9G4Oj7OlOkf8yfqTMuh05Pdg2+fSBDlx8HIkh3Gjq65VQvIev61W+TRcmFbnJp
         6v4GyPWctwnvTcsaQpSFnQHlXuNDY/qZHV5wsC2ZPnO9gjqyGk1UisJ828yPN/yJl2MT
         b2kL/AiGSjAZlTi22YTcrIle4pkvyE5SkYvRgT6+9kbiIT2YTr9pUjDIH7u739uK775d
         faxlXNuuvrU1aOA0WKgitMnURQY7VoEiqaxMg+Pgxji8lfO0d4w3c+evYXGodpQTlj84
         LvT6y4ICpCAYbIZlRd0ynecOE74iGtsos17PblTxcVyxFt0HNBJT/iGVcu4QuGmCWWq2
         Qpnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742006414; x=1742611214;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8AnAaiMp1pogiyQq/P5ffzpAjmvR1I8H8po4dFjhB2Q=;
        b=fIBe3xr7V6AqwGtI39oGQ//jmBgkr0AgK7CLOwx8oXUTGtE7QmuxiB/566+QVPjPZU
         iZBXRR+vqAAwLpMnRpivLPY8mlc/qKiDoyCLR5Tl7/Y0KMnwmGUwli9VnlEHpE/pGi0a
         bSB0/F6nEvH6R13bOkldayepTp1dlCoNPVutm3M0GOEXuFlmIu76LnnGp6FtDV9Wndg+
         Mn6hRnRPgkWZqj3eiU24j7bS7fq3gU0VWgHjXrhByjzd9U6uCPv8DkWF6dbj39fA2fF6
         Zkdld+yHWm7xlDigG3oR49QA4q5VNR8PfNiJLtWPqL4LdC1TCTBTU8wnkVgNVV9dRNfA
         QE0Q==
X-Gm-Message-State: AOJu0YxhGbkJMvpidMyKfP0BvlEENy/9fhBRZiEiWGONQGfPY0QN6oF9
	Pep0Q5PfkLUILTqmRhDsW/8oaWwKazsbI6Hhhhtwd2ZPN9+NXUO5XMUw8GJqreS7fD0EF5h3oXO
	84w==
X-Google-Smtp-Source: AGHT+IEuUNeaevdUXvWFAIJ8JsyZ358tix7OrYJ/fGDFTE4Ye0y79h20U/9yKG7qAiftx1GmhHfquVa3dWI=
X-Received: from pjbqn6.prod.google.com ([2002:a17:90b:3d46:b0:2f8:4024:b59a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:190:b0:223:525b:2a7
 with SMTP id d9443c01a7336-225e0a4f8demr55785875ad.15.1742006414027; Fri, 14
 Mar 2025 19:40:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Mar 2025 19:40:08 -0700
In-Reply-To: <20250315024010.2360884-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250315024010.2360884-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.rc1.451.g8f38331e32-goog
Message-ID: <20250315024010.2360884-2-seanjc@google.com>
Subject: [PATCH 1/3] KVM: x86/mmu: Dynamically allocate shadow MMU's hashed
 page list
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Dynamically allocate the (massive) array of hashed lists used to track
shadow pages, as the array itself is 32KiB, i.e. is an order-3 allocation
all on its own, and is *exactly* an order-3 allocation.  Dynamically
allocating the array will allow allocating "struct kvm" using regular
kmalloc(), and will also allow deferring allocation of the array until
it's actually needed, i.e. until the first shadow root is allocated.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  4 ++--
 arch/x86/kvm/mmu/mmu.c          | 21 ++++++++++++++++++++-
 arch/x86/kvm/x86.c              |  5 ++++-
 3 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d881e7d276b1..6ead9e57446a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1332,7 +1332,7 @@ struct kvm_arch {
 	bool has_private_mem;
 	bool has_protected_state;
 	bool pre_fault_allowed;
-	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
+	struct hlist_head *mmu_page_hash;
 	struct list_head active_mmu_pages;
 	/*
 	 * A list of kvm_mmu_page structs that, if zapped, could possibly be
@@ -1984,7 +1984,7 @@ void kvm_mmu_vendor_module_exit(void);
 
 void kvm_mmu_destroy(struct kvm_vcpu *vcpu);
 int kvm_mmu_create(struct kvm_vcpu *vcpu);
-void kvm_mmu_init_vm(struct kvm *kvm);
+int kvm_mmu_init_vm(struct kvm *kvm);
 void kvm_mmu_uninit_vm(struct kvm *kvm);
 
 void kvm_mmu_init_memslot_memory_attributes(struct kvm *kvm,
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 63bb77ee1bb1..b878f2e89dec 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3880,6 +3880,18 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 	return r;
 }
 
+static int kvm_mmu_alloc_page_hash(struct kvm *kvm)
+{
+	typeof(kvm->arch.mmu_page_hash) h;
+
+	h = kcalloc(KVM_NUM_MMU_PAGES, sizeof(*h), GFP_KERNEL_ACCOUNT);
+	if (!h)
+		return -ENOMEM;
+
+	kvm->arch.mmu_page_hash = h;
+	return 0;
+}
+
 static int mmu_first_shadow_root_alloc(struct kvm *kvm)
 {
 	struct kvm_memslots *slots;
@@ -6673,13 +6685,19 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 		kvm_tdp_mmu_zap_invalidated_roots(kvm, true);
 }
 
-void kvm_mmu_init_vm(struct kvm *kvm)
+int kvm_mmu_init_vm(struct kvm *kvm)
 {
+	int r;
+
 	kvm->arch.shadow_mmio_value = shadow_mmio_value;
 	INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
 	INIT_LIST_HEAD(&kvm->arch.possible_nx_huge_pages);
 	spin_lock_init(&kvm->arch.mmu_unsync_pages_lock);
 
+	r = kvm_mmu_alloc_page_hash(kvm);
+	if (r)
+		return r;
+
 	if (tdp_mmu_enabled)
 		kvm_mmu_init_tdp_mmu(kvm);
 
@@ -6690,6 +6708,7 @@ void kvm_mmu_init_vm(struct kvm *kvm)
 
 	kvm->arch.split_desc_cache.kmem_cache = pte_list_desc_cache;
 	kvm->arch.split_desc_cache.gfp_zero = __GFP_ZERO;
+	return 0;
 }
 
 static void mmu_free_vm_memory_caches(struct kvm *kvm)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 69c20a68a3f0..a1d85740d6e7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12704,7 +12704,9 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	if (ret)
 		goto out;
 
-	kvm_mmu_init_vm(kvm);
+	ret = kvm_mmu_init_vm(kvm);
+	if (ret)
+		goto out_cleanup_page_track;
 
 	ret = kvm_x86_call(vm_init)(kvm);
 	if (ret)
@@ -12757,6 +12759,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 out_uninit_mmu:
 	kvm_mmu_uninit_vm(kvm);
+out_cleanup_page_track:
 	kvm_page_track_cleanup(kvm);
 out:
 	return ret;
-- 
2.49.0.rc1.451.g8f38331e32-goog


