Return-Path: <kvm+bounces-26873-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 274A7978AC4
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 23:44:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4C8B51C22808
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 21:44:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD3D317CA1F;
	Fri, 13 Sep 2024 21:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aJuR4R2x"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5176616F85E
	for <kvm@vger.kernel.org>; Fri, 13 Sep 2024 21:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726263818; cv=none; b=qjIVEcSBfEa/MvdpyZnr6N14VnqbPQNWZn7beSueJ9C8QC9y5fiBBFouw+7uMWSVN4jJlLMaRIGhukDPzO9LJNsnosomnJZBAj1R0Db5MCnB10Y/xeCBmI0cqkg5vo46aFuhTy3XtO2YgF991CjbG294vdYTn2wZqE6yRoGXLvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726263818; c=relaxed/simple;
	bh=091/pNCRdGXGxztyYIPeIZciZOeD1K3TPYeC5iTdipY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Tpb1qqsi7tTkRpugDkfVVwI0hMWYFl8t+08EjTJKeJLmgKGWJYMo28aoW/2JvOsU/pR9B9I6ytXbhVEZs+1zxtS6X2XZJL28XvieYnSQKJ6GqKntN7EIKrJZDxzRYSB3dBHUzl84/MVnsoKs4JCpDthR7KAx8/4UfawNHfCYNAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aJuR4R2x; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e1d46cee0b0so4557421276.2
        for <kvm@vger.kernel.org>; Fri, 13 Sep 2024 14:43:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726263815; x=1726868615; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rAUYJhCtl2npTL0Ze9xPEuUa5GQYdR3/oyvz0EeWkWA=;
        b=aJuR4R2xGap97q/ojfIWjW9d79B1nVTqY5pvfv4j/BZfvReCuuw3/OjhykXdC/8nrZ
         vuquw/smOuZlmFM34uMbA4xDL1mQcsZm4aJmdD3mko/r2758t98GKtRVo/2LxKBoko5G
         b8WihQWAt9jeZoVv+R6uEj6eocgsW7MMqIVZyjTeyfrIkbU53jOj8lv9oW4tnh6bxY1d
         EXlQRv+6SOyS5QqZXbgSsHcSAUF4xqzc5HaBscd/goAcd1Plp6TS0BdoIGbuRSfyxhqN
         kS0ak64Gp+Q4KAv+2r02TnEBhAAbA4DeELnrRozg3ah5juItW9JtBbAV19a09xJReuSk
         YM+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726263815; x=1726868615;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rAUYJhCtl2npTL0Ze9xPEuUa5GQYdR3/oyvz0EeWkWA=;
        b=tKFA0g04PJnCr5fhUaOF6nQwiCQkN3FnCrQFUhzbP3Lr9A+u0oLCLybgBbcG3uiTIT
         uVbBqVMNKvVKvewGpOElTI/el2YCfgCbteHr4CoZswBfV288vJq/Ozk6SA71GClzdaJ1
         4YwJlcZ0ZyHn/yj3en5q4ngNBaNJB0dRx5fkyBRhnpqLayvGML2B0c84ompLwVsfQIu6
         vvW1eObXUvXn8A9mtnp7fFZl9GrOYbKWjwgataNGNW7DWy9OeEOjIBCz2rhOZ0Im5Mdg
         QNJry60buwLKfkCE+MG2nZlP+FyqJxcYPda/LGcltkldJQ6VKUvQQqQ+s4dp1nMcyelT
         u+Hg==
X-Forwarded-Encrypted: i=1; AJvYcCU2HGo49jqPnLnATTiunT9vimWkVoIisAsNKfxLsMTrr/nWEuV5kDwsoQIDOrXPkQrrEjU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7e/KV2S6dj6sCzL1CaIw9KAm9Q11vz+9+8s/uNTjY482YskTL
	oo4pOShpWY8iCtrqiTui2Ab36+uUpHJGiey01S0Kt2ScM5iaJFyCNVqhAIQkyACvwqLXSavRaJd
	4q8cx2w==
X-Google-Smtp-Source: AGHT+IGnKFpaMNNVc7WWMIWqQzwsj3RQhz1JMObdkTK6x2eMJDipdhA6PX0yZBLM65ZhFmOcjP+ONsH8riiy
X-Received: from vipin.c.googlers.com ([35.247.89.60]) (user=vipinsh
 job=sendgmr) by 2002:a25:e812:0:b0:e16:51f9:59da with SMTP id
 3f1490d57ef6-e1d9dc1b42emr20182276.6.1726263815170; Fri, 13 Sep 2024 14:43:35
 -0700 (PDT)
Date: Fri, 13 Sep 2024 14:43:16 -0700
In-Reply-To: <20240913214316.1945951-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240913214316.1945951-1-vipinsh@google.com>
X-Mailer: git-send-email 2.46.0.662.g92d0881bb0-goog
Message-ID: <20240913214316.1945951-3-vipinsh@google.com>
Subject: [PATCH 2/2] KVM: x86/mmu: Use MMU shrinker to shrink KVM MMU memory caches
From: Vipin Sharma <vipinsh@google.com>
To: seanjc@google.com, pbonzini@redhat.com
Cc: dmatlack@google.com, zhi.wang.linux@gmail.com, weijiang.yang@intel.com, 
	mizhang@google.com, liangchen.linux@gmail.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
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

Suggested-by: Sean Christopherson <seanjc@google.com>
Suggested-by: David Matlack <dmatlack@google.com>
Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 arch/x86/include/asm/kvm_host.h |  6 +++
 arch/x86/kvm/mmu/mmu.c          | 69 +++++++++++++++++++++++++++------
 arch/x86/kvm/mmu/paging_tmpl.h  | 14 ++++---
 include/linux/kvm_host.h        |  1 +
 virt/kvm/kvm_main.c             |  8 +++-
 5 files changed, 81 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index cbfe31bac6cf..63eaf03111eb 100644
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
index 213e46b55dda..8e2935347615 100644
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
index 405bd7ceee2a..084a5c532078 100644
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
index b23c6d48392f..288e503f14a0 100644
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
index cb2b78e92910..5d89ca218791 100644
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
2.46.0.662.g92d0881bb0-goog


