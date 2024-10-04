Return-Path: <kvm+bounces-27993-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A3A89910C2
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2024 22:43:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8F0A8B2A970
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2024 20:18:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04D901E231A;
	Fri,  4 Oct 2024 19:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="l5+RxsgN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C3831E22F2
	for <kvm@vger.kernel.org>; Fri,  4 Oct 2024 19:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728071750; cv=none; b=oQGW+3zf5UxOH0+PyHewAQ9dBEnCFgUb5wQ1arSg/edBOlAw5YB3snyJtUkVN1QzsPuZENKrfv1L/Iqv4OhlcuhdWl+4tPvorTfb+yV3Jz16IzBtCRHZ7ujPue7w9ObLTW0RfdSlSKOmEG/QZONf1wI3sFlW51DDoeFa1SB975Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728071750; c=relaxed/simple;
	bh=DYdRMJkwfHq1EeSmBOjN2a31jLCtFMQDVwgOph06U6s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=njrvDhAWkwMI+UBGzm1dmA9ZUHJfDxsJy4ROcDPoD3rFq6avNeROQApAsXtlYUtzn4EU02PDvgge5JAKD0N8uT8fLIYHtrzKSwhg4wzM/S+D8H5jWHFAum/uYXt8+4w7/AsPotuUoOYfOeX87oci1F4UKwZbERHmBG/82Fzm4TY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=l5+RxsgN; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2e0b6b4d427so3279377a91.0
        for <kvm@vger.kernel.org>; Fri, 04 Oct 2024 12:55:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728071748; x=1728676548; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wOQiKDWxKwvHSTq+X53UtqBcRoF0/VfzwQic5qnhwMQ=;
        b=l5+RxsgNwm/YWWSXNflzk3F+davH+NLAexwiJr3kPOVpZgX1gDusJkLMnZpLS9GMXS
         n1v6P0Y+OscPL3mm2hrXL/y10h+uQd3DesVzbBBbYY6IZSQ7PmFX3rMs1hM1ovDAZQkI
         iM6vxloUG2zhC/GmP0v1IJVaWhHPhgF8iVx/bGjp0vIJ6pmUd0KgujNlnCDHPiSkocbm
         otxUybCt3+9QyFRoxgDp46o7TPzIQ3UGPfAzcBVZyrRAcHVBAjto3Oret4lbTrwRUZiU
         A3WdRCy+L704pzjg07433Bu8iC4QkEfBqXpcdDNST8nWC/UL+GZQyUcqpmyVc40NQ5nj
         gmdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728071748; x=1728676548;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wOQiKDWxKwvHSTq+X53UtqBcRoF0/VfzwQic5qnhwMQ=;
        b=ZeD3eMyTVQhG2EuGJjBO6bFHZvwefYAjtqHJAIV0+GcGJfVwCQMMGEn8mnkczv1LAa
         Em3g3rHf9DOK/P71HLzA/tIDxrAin0GqUv/HFdotK0A68IrFkOrnhq6nFUbhBURdUu1Y
         UKPZmQBTYPQLFNFv+b5tRKgLG6Lfz1nkVkUjalilJG5aU7dsEbkld4i7QRLcDFuS7NjW
         zujluP4YpyrQVWOWVzupeF/E8lL4vRACzz+4eBAAvsdSmaE6wox5ME79vBYoB4HWqui2
         JeBVWWnOhLc3l4OSuT4FUm30Ud9RenumiG6zQBEYN8kewYjHOEsPqPWCa2uvpBPAT1l3
         91XQ==
X-Forwarded-Encrypted: i=1; AJvYcCVElUbstRqcSvxX8xW5QlhBa1Evhml4cS3mikmL3ezSwXSsSNUAskg0ij4Awg5XmtTIdDA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzINV6KYz5xxaFbGfa64IGUbcq1LM0JDH/shlgdadLwJQMMiQ8G
	EhGRUh+7SZRbstSCnnM30GoHCVRf4E7cB+ayQS6sfZWa/kXXdK3etG4BXaMOs1xvdOLyKpNctKi
	8q5Cgzw==
X-Google-Smtp-Source: AGHT+IHPE5k5SFpXLK6Z34zLxu8yWs3OwTfU0LRLmjyctWLUAce3eV/NaZe8zBYNUajJi9VaxaEPwfPjjn77
X-Received: from vipin.c.googlers.com ([35.247.89.60]) (user=vipinsh
 job=sendgmr) by 2002:a17:90a:ec08:b0:2d8:8c74:7088 with SMTP id
 98e67ed59e1d1-2e1e501d358mr37694a91.0.1728071747652; Fri, 04 Oct 2024
 12:55:47 -0700 (PDT)
Date: Fri,  4 Oct 2024 12:55:39 -0700
In-Reply-To: <20241004195540.210396-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241004195540.210396-1-vipinsh@google.com>
X-Mailer: git-send-email 2.47.0.rc0.187.ge670bccf7e-goog
Message-ID: <20241004195540.210396-3-vipinsh@google.com>
Subject: [PATCH v2 2/3] KVM: x86/mmu: Use MMU shrinker to shrink KVM MMU
 memory caches
From: Vipin Sharma <vipinsh@google.com>
To: seanjc@google.com, pbonzini@redhat.com, dmatlack@google.com
Cc: zhi.wang.linux@gmail.com, weijiang.yang@intel.com, mizhang@google.com, 
	liangchen.linux@gmail.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Use MMU shrinker to iterate through all the vCPUs of all the VMs and
free pages allocated in MMU memory caches. Protect cache allocation in
page fault and MMU load path from MMU shrinker by using a per vCPU
mutex. In MMU shrinker, move the iterated VM to the end of the VMs list
so that the pain of emptying cache spread among other VMs too.

The specific caches to empty are mmu_shadow_page_cache and
mmu_shadowed_info_cache as these caches store whole pages. Emptying them
will give more impact to shrinker compared to other caches like
mmu_pte_list_desc_cache{} and mmu_page_header_cache{}

Holding per vCPU mutex lock ensures that a vCPU doesn't get surprised
by finding its cache emptied after filling them up for page table
allocations during page fault handling and MMU load operation. Per vCPU
mutex also makes sure there is only race between MMU shrinker and all
other vCPUs. This should result in very less contention.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 arch/x86/include/asm/kvm_host.h |  6 +++
 arch/x86/kvm/mmu/mmu.c          | 69 +++++++++++++++++++++++++++------
 arch/x86/kvm/mmu/paging_tmpl.h  | 14 ++++---
 include/linux/kvm_host.h        |  1 +
 virt/kvm/kvm_main.c             |  8 +++-
 5 files changed, 81 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index cbfe31bac6cf6..63eaf03111ebb 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -811,6 +811,12 @@ struct kvm_vcpu_arch {
 	 */
 	struct kvm_mmu *walk_mmu;
 
+	/*
+	 * Protect cache from getting emptied in MMU shrinker while vCPU might
+	 * use cache for fault handling or loading MMU.  As this is a per vCPU
+	 * lock, only contention might happen when MMU shrinker runs.
+	 */
+	struct mutex mmu_memory_cache_lock;
 	struct kvm_mmu_memory_cache mmu_pte_list_desc_cache;
 	struct kvm_mmu_memory_cache mmu_shadow_page_cache;
 	struct kvm_mmu_memory_cache mmu_shadowed_info_cache;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 213e46b55dda2..8e2935347615d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4524,29 +4524,33 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	if (r != RET_PF_INVALID)
 		return r;
 
+	mutex_lock(&vcpu->arch.mmu_memory_cache_lock);
 	r = mmu_topup_memory_caches(vcpu, false);
 	if (r)
-		return r;
+		goto out_mmu_memory_cache_unlock;
 
 	r = kvm_faultin_pfn(vcpu, fault, ACC_ALL);
 	if (r != RET_PF_CONTINUE)
-		return r;
+		goto out_mmu_memory_cache_unlock;
 
 	r = RET_PF_RETRY;
 	write_lock(&vcpu->kvm->mmu_lock);
 
 	if (is_page_fault_stale(vcpu, fault))
-		goto out_unlock;
+		goto out_mmu_unlock;
 
 	r = make_mmu_pages_available(vcpu);
 	if (r)
-		goto out_unlock;
+		goto out_mmu_unlock;
 
 	r = direct_map(vcpu, fault);
 
-out_unlock:
+out_mmu_unlock:
 	write_unlock(&vcpu->kvm->mmu_lock);
 	kvm_release_pfn_clean(fault->pfn);
+out_mmu_memory_cache_unlock:
+	mutex_unlock(&vcpu->arch.mmu_memory_cache_lock);
+
 	return r;
 }
 
@@ -4617,25 +4621,28 @@ static int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu,
 	if (r != RET_PF_INVALID)
 		return r;
 
+	mutex_lock(&vcpu->arch.mmu_memory_cache_lock);
 	r = mmu_topup_memory_caches(vcpu, false);
 	if (r)
-		return r;
+		goto out_mmu_memory_cache_unlock;
 
 	r = kvm_faultin_pfn(vcpu, fault, ACC_ALL);
 	if (r != RET_PF_CONTINUE)
-		return r;
+		goto out_mmu_memory_cache_unlock;
 
 	r = RET_PF_RETRY;
 	read_lock(&vcpu->kvm->mmu_lock);
 
 	if (is_page_fault_stale(vcpu, fault))
-		goto out_unlock;
+		goto out_mmu_unlock;
 
 	r = kvm_tdp_mmu_map(vcpu, fault);
 
-out_unlock:
+out_mmu_unlock:
 	read_unlock(&vcpu->kvm->mmu_lock);
 	kvm_release_pfn_clean(fault->pfn);
+out_mmu_memory_cache_unlock:
+	mutex_unlock(&vcpu->arch.mmu_memory_cache_lock);
 	return r;
 }
 #endif
@@ -5691,6 +5698,7 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
 {
 	int r;
 
+	mutex_lock(&vcpu->arch.mmu_memory_cache_lock);
 	r = mmu_topup_memory_caches(vcpu, !vcpu->arch.mmu->root_role.direct);
 	if (r)
 		goto out;
@@ -5717,6 +5725,7 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
 	 */
 	kvm_x86_call(flush_tlb_current)(vcpu);
 out:
+	mutex_unlock(&vcpu->arch.mmu_memory_cache_lock);
 	return r;
 }
 
@@ -6303,6 +6312,7 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
 	if (!vcpu->arch.mmu_shadow_page_cache.init_value)
 		vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
 
+	mutex_init(&vcpu->arch.mmu_memory_cache_lock);
 	vcpu->arch.mmu = &vcpu->arch.root_mmu;
 	vcpu->arch.walk_mmu = &vcpu->arch.root_mmu;
 
@@ -6997,13 +7007,50 @@ void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen)
 static unsigned long mmu_shrink_scan(struct shrinker *shrink,
 				     struct shrink_control *sc)
 {
-	return SHRINK_STOP;
+	struct kvm *kvm, *next_kvm, *first_kvm = NULL;
+	unsigned long i, freed = 0;
+	struct kvm_vcpu *vcpu;
+
+	mutex_lock(&kvm_lock);
+	list_for_each_entry_safe(kvm, next_kvm, &vm_list, vm_list) {
+		if (!first_kvm)
+			first_kvm = kvm;
+		else if (first_kvm == kvm)
+			break;
+
+		list_move_tail(&kvm->vm_list, &vm_list);
+
+		kvm_for_each_vcpu(i, vcpu, kvm) {
+			if (!mutex_trylock(&vcpu->arch.mmu_memory_cache_lock))
+				continue;
+			freed += kvm_mmu_empty_memory_cache(&vcpu->arch.mmu_shadow_page_cache);
+			freed += kvm_mmu_empty_memory_cache(&vcpu->arch.mmu_shadowed_info_cache);
+			mutex_unlock(&vcpu->arch.mmu_memory_cache_lock);
+			if (freed >= sc->nr_to_scan)
+				goto out;
+		}
+	}
+out:
+	mutex_unlock(&kvm_lock);
+	return freed;
 }
 
 static unsigned long mmu_shrink_count(struct shrinker *shrink,
 				      struct shrink_control *sc)
 {
-	return SHRINK_EMPTY;
+	unsigned long i, count = 0;
+	struct kvm_vcpu *vcpu;
+	struct kvm *kvm;
+
+	mutex_lock(&kvm_lock);
+	list_for_each_entry(kvm, &vm_list, vm_list) {
+		kvm_for_each_vcpu(i, vcpu, kvm) {
+			count += READ_ONCE(vcpu->arch.mmu_shadow_page_cache.nobjs);
+			count += READ_ONCE(vcpu->arch.mmu_shadowed_info_cache.nobjs);
+		}
+	}
+	mutex_unlock(&kvm_lock);
+	return !count ? SHRINK_EMPTY : count;
 }
 
 static struct shrinker *mmu_shrinker;
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 405bd7ceee2a3..084a5c532078f 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -809,13 +809,14 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 		return RET_PF_EMULATE;
 	}
 
+	mutex_lock(&vcpu->arch.mmu_memory_cache_lock);
 	r = mmu_topup_memory_caches(vcpu, true);
 	if (r)
-		return r;
+		goto out_mmu_memory_cache_unlock;
 
 	r = kvm_faultin_pfn(vcpu, fault, walker.pte_access);
 	if (r != RET_PF_CONTINUE)
-		return r;
+		goto out_mmu_memory_cache_unlock;
 
 	/*
 	 * Do not change pte_access if the pfn is a mmio page, otherwise
@@ -840,16 +841,19 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	write_lock(&vcpu->kvm->mmu_lock);
 
 	if (is_page_fault_stale(vcpu, fault))
-		goto out_unlock;
+		goto out_mmu_unlock;
 
 	r = make_mmu_pages_available(vcpu);
 	if (r)
-		goto out_unlock;
+		goto out_mmu_unlock;
 	r = FNAME(fetch)(vcpu, fault, &walker);
 
-out_unlock:
+out_mmu_unlock:
 	write_unlock(&vcpu->kvm->mmu_lock);
 	kvm_release_pfn_clean(fault->pfn);
+out_mmu_memory_cache_unlock:
+	mutex_unlock(&vcpu->arch.mmu_memory_cache_lock);
+
 	return r;
 }
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index b23c6d48392f7..288e503f14a0b 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1446,6 +1446,7 @@ void kvm_flush_remote_tlbs_memslot(struct kvm *kvm,
 int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min);
 int __kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int capacity, int min);
 int kvm_mmu_memory_cache_nr_free_objects(struct kvm_mmu_memory_cache *mc);
+int kvm_mmu_empty_memory_cache(struct kvm_mmu_memory_cache *mc);
 void kvm_mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc);
 void *kvm_mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
 #endif
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index cb2b78e92910f..5d89ca218791b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -451,15 +451,21 @@ int kvm_mmu_memory_cache_nr_free_objects(struct kvm_mmu_memory_cache *mc)
 	return mc->nobjs;
 }
 
-void kvm_mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc)
+int kvm_mmu_empty_memory_cache(struct kvm_mmu_memory_cache *mc)
 {
+	int freed = mc->nobjs;
 	while (mc->nobjs) {
 		if (mc->kmem_cache)
 			kmem_cache_free(mc->kmem_cache, mc->objects[--mc->nobjs]);
 		else
 			free_page((unsigned long)mc->objects[--mc->nobjs]);
 	}
+	return freed;
+}
 
+void kvm_mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc)
+{
+	kvm_mmu_empty_memory_cache(mc);
 	kvfree(mc->objects);
 
 	mc->objects = NULL;
-- 
2.47.0.rc0.187.ge670bccf7e-goog


