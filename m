Return-Path: <kvm+bounces-42329-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B9708A77FA1
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 17:57:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A90FE7A23E0
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 15:56:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6764320D4FD;
	Tue,  1 Apr 2025 15:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="32CcTCKq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1454B20C486
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 15:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743523040; cv=none; b=rDxT5mJBXPN8+q9+SoT/iPrWVYQQTEZK+fSS5KbaTZwVAIcrc5tpXBZe/PR0azWS8QXpcMB354fjQWV8/B0fO+mg4SEj2Af2svx1rW7qiMHduGSuqp5ZYdF5oKlvRxARmVBYqp6Zp6Ig7Zrl8Yj79IPGnZBBebOQ/4Zk5gE+CCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743523040; c=relaxed/simple;
	bh=XFMN/1TjDkt0VHZXeAmqM88pM/Yy9sojmu6ZVcp+G5A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QrKKBUHefiWrVGfb+1mjaaXm3BrOC9jpqd/aPjLAmoTnTGBxrNLlSxzfVgF4gJI9f2oWO2iStYwXVEJ2Q1oIVmfHDS0hSOdLUhTLOF8gOIbEcMKsTZrmShO9isBkLQK+GgfS7HALao0LqVBDtLgaLiUamrxmv1TaG4DP6UEXMko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=32CcTCKq; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ff4b130bb2so10362224a91.0
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 08:57:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743523038; x=1744127838; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=XfD+/olMCjjTlr+W07rgl23+xXZX9pNmPmnT7WHnWhU=;
        b=32CcTCKqt2w3lQA/Q/QL5MQ4SJaL6xsMoDUbEf2R6UjFalcXqi/fpiUPyNUX8bY848
         DGUE+Kz9cN0kMDVnB6H2Jb/Ppm2ZfHJbRPAGQp9aabNhzW2KnkkYQCvmIAwnfUjca2cm
         6y5OLvBYqyT+rU2ePgqaLLBJaiHBu51b3oJ+pYIb83ReCiGlwOWGcFP7liyLqLQMzMsG
         KmVjkka4s3MYHeF7T3sz/eNhyn8LKoxqsmkZJ04G2crkAX85uf5J1sujsA+qHdoeVYwh
         LjWprGBws2qA/8eTlqJPVi8MwtlxKI8i641nqQRBFYTvAFROZI++hkIRBsdpjVlSCPLW
         4/Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743523038; x=1744127838;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XfD+/olMCjjTlr+W07rgl23+xXZX9pNmPmnT7WHnWhU=;
        b=YsUZ5XgdoAebf/O+MLowYtCzXvc9i5uHlF7bxRekoOhdYrIZhY6UmEy1/QRSo4S44t
         wJD2SlDpSz8ZI/Y9cvdVRubEoe1bIlOVoPRJoqBb/V4/K4TrBxKxtElI2m4aDHu9+Bw1
         DfDNOVuM/61zPkGipCZa3jc6Bb5vko93X1cxm1AePw3GKnRAy8dlXT40hMyT20ywRGwz
         A2jSWIbUK7KEd2Bjy0fzcXPRtbKHEDLLt+RXnGNZTiDRfhS/n6KRHg4d9OBF8A2IDSwu
         U+TQbQm88GxQlkmz2rQ8mmnadhVZDUU/lGuu8pQJVg0nHqfrVzWlFzKuFxd8atNhvdeb
         wK+A==
X-Gm-Message-State: AOJu0YwQkxsAwauQB5TulV9NE8+XiibDMFW0C7fKEPQmhwlnuEoOsRub
	Fhaz9fjGv7wtbjPn66bcikWz81MQ5YYJ3hOxK98+z+o2nl/JLgJWeGmSo+p8XMhmTv3y2DxqD6M
	G5g==
X-Google-Smtp-Source: AGHT+IGCmi+AM1Kq1m2h89y+RWMJjrT8URQip51SgDFCFbGhP2V4jxmx+W28wYOkSn98iKOm32ePbQd01rw=
X-Received: from pjyp8.prod.google.com ([2002:a17:90a:e708:b0:2ef:78ff:bc3b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3b85:b0:2ff:6e72:b8e9
 with SMTP id 98e67ed59e1d1-30532154023mr19843757a91.25.1743523038368; Tue, 01
 Apr 2025 08:57:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  1 Apr 2025 08:57:12 -0700
In-Reply-To: <20250401155714.838398-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250401155714.838398-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.472.ge94155a9ec-goog
Message-ID: <20250401155714.838398-2-seanjc@google.com>
Subject: [PATCH v2 1/3] KVM: x86/mmu: Dynamically allocate shadow MMU's hashed
 page list
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Dynamically allocate the (massive) array of hashed lists used to track
shadow pages, as the array itself is 32KiB, i.e. is an order-3 allocation
all on its own, and is *exactly* an order-3 allocation.  Dynamically
allocating the array will allow allocating "struct kvm" using regular
kmalloc(), and will also allow deferring allocation of the array until
it's actually needed, i.e. until the first shadow root is allocated.

Cc: Vipin Sharma <vipinsh@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  4 ++--
 arch/x86/kvm/mmu/mmu.c          | 23 ++++++++++++++++++++++-
 arch/x86/kvm/x86.c              |  5 ++++-
 3 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a884ab544335..e523d7d8a107 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1333,7 +1333,7 @@ struct kvm_arch {
 	bool has_private_mem;
 	bool has_protected_state;
 	bool pre_fault_allowed;
-	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
+	struct hlist_head *mmu_page_hash;
 	struct list_head active_mmu_pages;
 	/*
 	 * A list of kvm_mmu_page structs that, if zapped, could possibly be
@@ -1985,7 +1985,7 @@ void kvm_mmu_vendor_module_exit(void);
 
 void kvm_mmu_destroy(struct kvm_vcpu *vcpu);
 int kvm_mmu_create(struct kvm_vcpu *vcpu);
-void kvm_mmu_init_vm(struct kvm *kvm);
+int kvm_mmu_init_vm(struct kvm *kvm);
 void kvm_mmu_uninit_vm(struct kvm *kvm);
 
 void kvm_mmu_init_memslot_memory_attributes(struct kvm *kvm,
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 63bb77ee1bb1..6b9c72405860 100644
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
@@ -6701,6 +6720,8 @@ static void mmu_free_vm_memory_caches(struct kvm *kvm)
 
 void kvm_mmu_uninit_vm(struct kvm *kvm)
 {
+	kfree(kvm->arch.mmu_page_hash);
+
 	if (tdp_mmu_enabled)
 		kvm_mmu_uninit_tdp_mmu(kvm);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c841817a914a..4070f9d34521 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12721,7 +12721,9 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	if (ret)
 		goto out;
 
-	kvm_mmu_init_vm(kvm);
+	ret = kvm_mmu_init_vm(kvm);
+	if (ret)
+		goto out_cleanup_page_track;
 
 	ret = kvm_x86_call(vm_init)(kvm);
 	if (ret)
@@ -12774,6 +12776,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 out_uninit_mmu:
 	kvm_mmu_uninit_vm(kvm);
+out_cleanup_page_track:
 	kvm_page_track_cleanup(kvm);
 out:
 	return ret;
-- 
2.49.0.472.ge94155a9ec-goog


