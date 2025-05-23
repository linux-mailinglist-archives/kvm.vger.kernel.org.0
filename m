Return-Path: <kvm+bounces-47447-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 30399AC18E7
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 02:12:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5FE5C3BB065
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 00:12:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E689224DD0E;
	Fri, 23 May 2025 00:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="C+wT8y8Z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BEF6101DE
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 00:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747959108; cv=none; b=GRwcpsnVvLUGjp6tBZrAmQsk5MAKwGg+CnxCYXNWGfMXI+vLju/nbbGrRCyjfKZpWx1qPhjuL88h5R13eEFj6EdFTdWOfLQW7aGRlWTh5EE15DsDb0RxmbL3HN71vG1QiJSaiwRnmYEfu10iqM/ukCAxiSd4Fjoio9pBiL7ajl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747959108; c=relaxed/simple;
	bh=yeeO76fTwkSlC35gpHI7W6M2JmOIOSugXmyVksY+1RQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eFglzCUSiEoYBmUNPR8lvxKzoBIpufdCIbvU1JxKMrfFnSNS9BEC9oJGu6kaY2WFheRidKUGebUBY+amhTY2lAj0a0sCwk17qSuERm0x6lSFLlZW9cZfc6lBib4frMU3A41AZCxBCGyhxzVQ+Nx6qvtO3X9Mg8UDn1d8WMFTcO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=C+wT8y8Z; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30ea0e890ccso6022439a91.2
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 17:11:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747959105; x=1748563905; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Dk34eBQNyx1X+T1IGkU3aiQ/pwVlCQf8gXCAh3fmSMc=;
        b=C+wT8y8ZXkv1PHdU3Cinyowb9cE6/J3GPGg+4hpG48cIDV8kRttBU0szpqKnQla6oA
         0UHtVS1ieiSncTC0dClDNVMfbZdLNpZWjcoev8oT4+wElm+yo8qSXLn8otFISFQXOROp
         s8k9dQQwh0w4E9IaXYi/4e7OqerjyxS0yJpqhi2piBtqs4lXoglV0U+BdyrHrVP92B39
         vwzOcEF6qf+zzeBXugQgWs4yT5p7F1C0BCADtIm9+OG0ZSsBzRpJJ8zrUokuR3GpzzT2
         YJorBzIGx+aieZB9B39TUp9RsUUUo35sEbc1t0nMiTrqKc8JAVD4VucC0p3HTdfku5s6
         HKUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747959105; x=1748563905;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Dk34eBQNyx1X+T1IGkU3aiQ/pwVlCQf8gXCAh3fmSMc=;
        b=QI0swWTfcOz29a933kXMMGIgJAGkQMvsMnFUCMKuQ8QA/gRdQdfbPl4zd8WIbMSMTP
         6wzf0Xya3FZv4vGOmGVrFspWn6DwRNbYcwQRlRooQvQDOQdH66xURmF6xdFbUqzRfyoQ
         vzb3qd7L55WlKZzCyos8K5GWujH/Xfv+hs+dpouOd4gEFZnSxlwfhgnR8JSYxXYILGrn
         koCSg2/6zBsNtQuBA3o26a+bXMa2x7jP7Bua+BcZHdeNPEDSb3eRKH5jczLNz195Aimo
         92UXfIsAYLIusbYNBkHBKfKN3UWSYmU0ZHIsTc/WN0EEPKBAg+ldsL4KrhCdANdVcQ+N
         w6Iw==
X-Gm-Message-State: AOJu0Ywx78dLDONVZD0OGu47boN2JzYZ82ft1IY5RQmCCw5sk6o1m+0k
	kb6twlcVh+9vONHmXICmMEo/rQzUnFVYwZvyKILFt8KYrZntnEgsGu8L4BquVnR9oiX6NDoes7u
	tO+wuTg==
X-Google-Smtp-Source: AGHT+IGQCeiY9Bgt7vILoyXCOkcSCyFklm70V/Ox192NsumKnWZCgipPK8ctHIxrF/qvGl+cM19ZN02dy1A=
X-Received: from pjbpd8.prod.google.com ([2002:a17:90b:1dc8:b0:2f9:c349:2f84])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2e85:b0:2ee:af31:a7bd
 with SMTP id 98e67ed59e1d1-30e830c4833mr36271130a91.5.1747959104920; Thu, 22
 May 2025 17:11:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 May 2025 17:11:36 -0700
In-Reply-To: <20250523001138.3182794-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250523001138.3182794-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250523001138.3182794-3-seanjc@google.com>
Subject: [PATCH v4 2/4] KVM: x86/mmu: Dynamically allocate shadow MMU's hashed
 page list
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vipin Sharma <vipinsh@google.com>, James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Dynamically allocate the (massive) array of hashed lists used to track
shadow pages, as the array itself is 32KiB, i.e. is an order-3 allocation
all on its own, and is *exactly* an order-3 allocation.  Dynamically
allocating the array will allow allocating "struct kvm" using kvmalloc(),
and will also allow deferring allocation of the array until it's actually
needed, i.e. until the first shadow root is allocated.

Opportunistically use kvmalloc() for the hashed lists, as an order-3
allocation is (stating the obvious) less likely to fail than an order-4
allocation, and the overhead of vmalloc() is undesirable given that the
size of the allocation is fixed.

Cc: Vipin Sharma <vipinsh@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  4 ++--
 arch/x86/kvm/mmu/mmu.c          | 23 ++++++++++++++++++++++-
 arch/x86/kvm/x86.c              |  5 ++++-
 3 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 330cdcbed1a6..9667d6b929ee 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1343,7 +1343,7 @@ struct kvm_arch {
 	bool has_private_mem;
 	bool has_protected_state;
 	bool pre_fault_allowed;
-	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
+	struct hlist_head *mmu_page_hash;
 	struct list_head active_mmu_pages;
 	/*
 	 * A list of kvm_mmu_page structs that, if zapped, could possibly be
@@ -2006,7 +2006,7 @@ void kvm_mmu_vendor_module_exit(void);
 
 void kvm_mmu_destroy(struct kvm_vcpu *vcpu);
 int kvm_mmu_create(struct kvm_vcpu *vcpu);
-void kvm_mmu_init_vm(struct kvm *kvm);
+int kvm_mmu_init_vm(struct kvm *kvm);
 void kvm_mmu_uninit_vm(struct kvm *kvm);
 
 void kvm_mmu_init_memslot_memory_attributes(struct kvm *kvm,
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index cbc84c6abc2e..41da2cb1e3f1 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3882,6 +3882,18 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 	return r;
 }
 
+static int kvm_mmu_alloc_page_hash(struct kvm *kvm)
+{
+	typeof(kvm->arch.mmu_page_hash) h;
+
+	h = kvcalloc(KVM_NUM_MMU_PAGES, sizeof(*h), GFP_KERNEL_ACCOUNT);
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
@@ -6675,13 +6687,19 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
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
 
@@ -6692,6 +6710,7 @@ void kvm_mmu_init_vm(struct kvm *kvm)
 
 	kvm->arch.split_desc_cache.kmem_cache = pte_list_desc_cache;
 	kvm->arch.split_desc_cache.gfp_zero = __GFP_ZERO;
+	return 0;
 }
 
 static void mmu_free_vm_memory_caches(struct kvm *kvm)
@@ -6703,6 +6722,8 @@ static void mmu_free_vm_memory_caches(struct kvm *kvm)
 
 void kvm_mmu_uninit_vm(struct kvm *kvm)
 {
+	kvfree(kvm->arch.mmu_page_hash);
+
 	if (tdp_mmu_enabled)
 		kvm_mmu_uninit_tdp_mmu(kvm);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f9f798f286ce..d204ba9368f8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12787,7 +12787,9 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	if (ret)
 		goto out;
 
-	kvm_mmu_init_vm(kvm);
+	ret = kvm_mmu_init_vm(kvm);
+	if (ret)
+		goto out_cleanup_page_track;
 
 	ret = kvm_x86_call(vm_init)(kvm);
 	if (ret)
@@ -12840,6 +12842,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 out_uninit_mmu:
 	kvm_mmu_uninit_vm(kvm);
+out_cleanup_page_track:
 	kvm_page_track_cleanup(kvm);
 out:
 	return ret;
-- 
2.49.0.1151.ga128411c76-goog


