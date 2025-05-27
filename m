Return-Path: <kvm+bounces-47818-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F30E5AC59D1
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 20:04:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1D69A1BA813F
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 18:04:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 153EC2868AF;
	Tue, 27 May 2025 18:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ThhSNGpq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC52283CB0
	for <kvm@vger.kernel.org>; Tue, 27 May 2025 18:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368997; cv=none; b=W+JUWkH1EEsWXTlL34h1GCSxFRTYEemQ1DPRBxYVCd4QTFjFi0kkxAUu+nvub+zn6+G6uwYm63U2vREl5NWgxdRE4jNCNv/gaNYUqwdWar5a3qa4xn5SQ3YW2dobGb1VgmIAa0X0AvisiNR31g/wsu7wuNCkQmXfzRziQi25DiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368997; c=relaxed/simple;
	bh=8fxsGre2f1IkgNdTTjhRyUL7/5trQ7ThZlPhcPUxbWE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=r82Scis9N6JQEFzPf8FQnL+46JoLtY/fQvDZlqqotKe64vYkuzHoUCchNsai/Yfu1NLK83VzgWQFjmepTN4WNeM64zNnD+eT+LjkZXnnWs++FSKv8pWYwpzErFVRkJxcURlcikNqD/O4uWBLrJyRSVcflaeuklvInuu02BRvEU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ThhSNGpq; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43ce8f82e66so18815165e9.3
        for <kvm@vger.kernel.org>; Tue, 27 May 2025 11:03:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748368994; x=1748973794; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ur7OOliet+Wmg5x1tJxiZ+Y9kodvHeTOGK3Qgb8DW2U=;
        b=ThhSNGpqNI1d1fWapXuBA/Ch85lROki7R66iwi111/Dp0czG2CGyypz90kFXwiI4EM
         JOGUNiglqTIG9mkRF4PQjMyhNhwjlB8VPMncMXjMjR1kLd/WWCn1T+yDnCCSzDw4UdQO
         0OmnwG+/Z6rNwhX+7rMOzvNu4+/9PPr1uqrZVsAt5Vfno2V+YspfCSluo/3BQbUyzXe0
         E1el5kS3Wx5eLPbH7DNk3mX3Q/c1prt3FwM66y1rMmxD9Vzr86lJDvd6pdy4tMF9kqPb
         WM2tvmfpn1Q6WQckB51ggG6nhAGY+syOgiMxLVoPqT3Q9Ma599BZAU4mJWtxqKvP4J4/
         3BrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748368994; x=1748973794;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ur7OOliet+Wmg5x1tJxiZ+Y9kodvHeTOGK3Qgb8DW2U=;
        b=GA7baunm/8TO+7yvi+SdAKe18OTnX2k49mWIlo5yerb/od8xp9GdMoZ15Pmb9odfJk
         vjfXERznt/IHkAuM+9AqJVjkhtv4J6MazG9ZC0KISiSF6X/oJRKU2Cv9qwc/qgV8qDMC
         K9uYjRDzCSdDqEvWwZH+pb6mGu8D3ypPcifYMQOxhyR/+fluJJQDRdnADm4uVQgRV3df
         9FgdvmM6VBKBLMhvygwA+5XntfkoQfzFNfb8YYawAgtlvs3iSzQj3ms7yW0Mwwbp1zVN
         NUKpjXWXnpS5rA93Co8Rb5Wkya+YzdCA5zMH1BTvD9Qo3WDhoYe9nSrj8PonZOZX8LGu
         56dg==
X-Gm-Message-State: AOJu0Ywn1gg/urx/bHXk2cLYGOohYYcDCw67uPWmNPVuzPU0xMYQ+GGq
	Ql/vmK8uwNWm0mHUpaLG01BGpX+axq37tIfQO0NNQw1Zir+myAkplwDtX/MEqlchLcGFccg84aZ
	4P0Ofi27rodaaJChzKLIG0Mb7ExZGrdMLTietb4ixtPUo8ECZXLIWRhH+HDK/uQvw74Okpr7DVF
	xS0OH9GRaGhqTGJXh6bZ++q4nFaWw=
X-Google-Smtp-Source: AGHT+IHCf0bDJ76hTT4kSC4YiVQWOuaVECuOWgSL6WNt6PYLNGGO9OXNopWm7SAaIEhfPW/80Tr8Ykb3uA==
X-Received: from wmbed10.prod.google.com ([2002:a05:600c:614a:b0:442:ccfa:102])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:512a:b0:44b:2f53:351c
 with SMTP id 5b1f17b1804b1-44c91dcb6e7mr133582365e9.18.1748368993658; Tue, 27
 May 2025 11:03:13 -0700 (PDT)
Date: Tue, 27 May 2025 19:02:42 +0100
In-Reply-To: <20250527180245.1413463-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250527180245.1413463-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.1164.gab81da1b16-goog
Message-ID: <20250527180245.1413463-14-tabba@google.com>
Subject: [PATCH v10 13/16] KVM: arm64: Handle guest_memfd-backed guest page faults
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Add arm64 support for handling guest page faults on guest_memfd backed
memslots. Until guest_memfd supports huge pages, the fault granule is
restricted to PAGE_SIZE.

Signed-off-by: Fuad Tabba <tabba@google.com>

---

Note: This patch introduces a new function, gmem_abort() rather than
previous attempts at trying to expand user_mem_abort(). This is because
there are many differences in how faults are handled when backed by
guest_memfd vs regular memslots with anonymous memory, e.g., lack of
VMA, and for now, lack of huge page support for guest_memfd. The
function user_mem_abort() is already big and unwieldly, adding more
complexity to it made things more difficult to understand.

Once larger page size support is added to guest_memfd, we could factor
out the common code between these two functions.

---
 arch/arm64/kvm/mmu.c | 89 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 87 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 9865ada04a81..896c56683d88 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1466,6 +1466,87 @@ static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
 	return vma->vm_flags & VM_MTE_ALLOWED;
 }
 
+static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
+			  struct kvm_memory_slot *memslot, bool is_perm)
+{
+	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_HANDLE_FAULT | KVM_PGTABLE_WALK_SHARED;
+	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
+	bool logging, write_fault, exec_fault, writable;
+	struct kvm_pgtable *pgt;
+	struct page *page;
+	struct kvm *kvm;
+	void *memcache;
+	kvm_pfn_t pfn;
+	gfn_t gfn;
+	int ret;
+
+	if (!is_perm) {
+		int min_pages = kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu);
+
+		if (!is_protected_kvm_enabled()) {
+			memcache = &vcpu->arch.mmu_page_cache;
+			ret = kvm_mmu_topup_memory_cache(memcache, min_pages);
+		} else {
+			memcache = &vcpu->arch.pkvm_memcache;
+			ret = topup_hyp_memcache(memcache, min_pages);
+		}
+		if (ret)
+			return ret;
+	}
+
+	kvm = vcpu->kvm;
+	gfn = fault_ipa >> PAGE_SHIFT;
+
+	logging = memslot_is_logging(memslot);
+	write_fault = kvm_is_write_fault(vcpu);
+	exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
+	VM_BUG_ON(write_fault && exec_fault);
+
+	if (is_perm && !write_fault && !exec_fault) {
+		kvm_err("Unexpected L2 read permission error\n");
+		return -EFAULT;
+	}
+
+	ret = kvm_gmem_get_pfn(vcpu->kvm, memslot, gfn, &pfn, &page, NULL);
+	if (ret) {
+		kvm_prepare_memory_fault_exit(vcpu, fault_ipa, PAGE_SIZE,
+					      write_fault, exec_fault, false);
+		return ret;
+	}
+
+	writable = !(memslot->flags & KVM_MEM_READONLY) &&
+		   (!logging || write_fault);
+
+	if (writable)
+		prot |= KVM_PGTABLE_PROT_W;
+
+	if (exec_fault || cpus_have_final_cap(ARM64_HAS_CACHE_DIC))
+		prot |= KVM_PGTABLE_PROT_X;
+
+	pgt = vcpu->arch.hw_mmu->pgt;
+
+	kvm_fault_lock(kvm);
+	if (is_perm) {
+		/*
+		 * Drop the SW bits in favour of those stored in the
+		 * PTE, which will be preserved.
+		 */
+		prot &= ~KVM_NV_GUEST_MAP_SZ;
+		ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, fault_ipa, prot, flags);
+	} else {
+		ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, fault_ipa, PAGE_SIZE,
+					     __pfn_to_phys(pfn), prot,
+					     memcache, flags);
+	}
+	kvm_release_faultin_page(kvm, page, !!ret, writable);
+	kvm_fault_unlock(kvm);
+
+	if (writable && !ret)
+		mark_page_dirty_in_slot(kvm, memslot, gfn);
+
+	return ret != -EAGAIN ? ret : 0;
+}
+
 static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			  struct kvm_s2_trans *nested,
 			  struct kvm_memory_slot *memslot, unsigned long hva,
@@ -1944,8 +2025,12 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 		goto out_unlock;
 	}
 
-	ret = user_mem_abort(vcpu, fault_ipa, nested, memslot, hva,
-			     esr_fsc_is_permission_fault(esr));
+	if (kvm_slot_has_gmem(memslot))
+		ret = gmem_abort(vcpu, fault_ipa, memslot,
+				 esr_fsc_is_permission_fault(esr));
+	else
+		ret = user_mem_abort(vcpu, fault_ipa, nested, memslot, hva,
+				     esr_fsc_is_permission_fault(esr));
 	if (ret == 0)
 		ret = 1;
 out:
-- 
2.49.0.1164.gab81da1b16-goog


