Return-Path: <kvm+bounces-52484-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CEC26B05698
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 11:36:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0026C3A8A2F
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 09:35:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35A4C2DCF72;
	Tue, 15 Jul 2025 09:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QME4h2rL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A13842DCC08
	for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 09:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752572069; cv=none; b=ejubHCQTnw6ZWba9EOThBatsfBla45dBMngo4ZP1NKK0d7u5s993FKX4tdfl31byPyP51upp2j7qKZYK+M+yXrXNpeobG3dzopjES+mRo80YJ/zuZcHvWTiUm7v/2NH0WtBkdgQlVonNU3DaMRUwvrbmNNSz+AGJV6bnWT5xTXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752572069; c=relaxed/simple;
	bh=zEZkLi/zufUM9bTMjQStV1DSpFIHKsECtzBWN+Saz3c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lvBUTE/39DowhygJ5amjTre3zyotVGxtftLHu+ZsZAYF3TzqFGibigzUdE38ACLigWD7/a1tBTCiEE0l9SIq/Pm9wRleeDe0WgUEcZWD5JODu9ReZc1t/ehU/5k4KIzpxwi6l81xDptTRqr8giRlEplNl6mKNlIOTd/e3flKSd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QME4h2rL; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4538a2f4212so30125055e9.2
        for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 02:34:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752572066; x=1753176866; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FLr2IgfKpLCEHT7MXIG6C0hRgCJ9BMJYV3UvbtKXymU=;
        b=QME4h2rL6kc5uRHbvkaQqwUsj8NAMQV/EQH/mLxB7EfrRpwKLjmRdmhBHzDSp3aUza
         rTT2u2M0VqvMMpKlZfpe5w/0Sj9o04ClfnXGpsA0aPtAFBfzImrsg2DWQVcORhIo+kY5
         2E3WN1U22XxO9xLqZt9bvnOeEXD8bSJEsejzYB7ZoJjNwJyIsMqHTKQRGHkhM1eqWvDv
         EwPv3wWdkKeWzsRQZV2seqo8KIrNV+DFr9z1/4xB+MC15O3QCuMLJZINkqVIRIdD0Wmc
         Fs2tcn0T2+hGScg1fNkWOaFTEoce6Dz5ct83uNLkpDH30FVSWD8bbzt7/0Uh9iFNJ41f
         WDQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752572066; x=1753176866;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FLr2IgfKpLCEHT7MXIG6C0hRgCJ9BMJYV3UvbtKXymU=;
        b=jgz2wjNjthxmntHyWg8NcZwAOlUqNVDvVFciOwwLVW/G8plz+voW23jQQg+Q+Bqrkj
         gNvXCkV9ewAvx2s80WsBhWzYZe3wjpGkAIu0Rkte7IoX+GFWml9p5J4W+E8+NhVPWzn2
         MNZilkFL5MDiX9vladyQ53gaULYrjaazsv4YVeqmhsd9v0W157orNg1yBie43zAXJIZO
         fJBUOOJxnxNaKtnhKtlQogzPwtAa9P6uiPNRy9VXhQ7VVFP4yqJLd4nEyBg5x/fwlKWD
         camYagZ0VRKravcnliIKEYqMoNIuV1ZN30uny2OQMQGsYMWERuJ06tRtKAMYV2oARkF9
         uBFg==
X-Gm-Message-State: AOJu0YyHExhXrQLrQ3yL6M1cJLC/F2hDjz2XpWCBeuBLAxAv9HvlfO0W
	ekz6hTdw+1GcWMV+aysFcg2w5COS/IOH+juVnIpR2X38jemy+dug0SVOgNOnRAagNkJZgxV0C5G
	pr0N4Ie1GAe59mjY72422dcckCAeRYyA9Nu/34oMJxkvqbV22zqNMmQ2OKbfuiqU3UGX2Bw9eOL
	ROdwk1C6ilwkJmEGLEaNVcH+OAsQM=
X-Google-Smtp-Source: AGHT+IGr/ToTExaXd1fztA3oBZSTLF4qbi6m2OY0gu5O+xOxmi0/NqRRIq7T+fjwKX6tdN/jPkynWyRVuA==
X-Received: from wmsd13.prod.google.com ([2002:a05:600c:3acd:b0:453:7edf:24ff])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:a216:b0:450:d386:1afb
 with SMTP id 5b1f17b1804b1-45555e4c191mr103954565e9.9.1752572065745; Tue, 15
 Jul 2025 02:34:25 -0700 (PDT)
Date: Tue, 15 Jul 2025 10:33:45 +0100
In-Reply-To: <20250715093350.2584932-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250715093350.2584932-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250715093350.2584932-17-tabba@google.com>
Subject: [PATCH v14 16/21] KVM: arm64: Handle guest_memfd-backed guest page faults
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev
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

Add arm64 architecture support for handling guest page faults on memory
slots backed by guest_memfd.

This change introduces a new function, gmem_abort(), which encapsulates
the fault handling logic specific to guest_memfd-backed memory. The
kvm_handle_guest_abort() entry point is updated to dispatch to
gmem_abort() when a fault occurs on a guest_memfd-backed memory slot (as
determined by kvm_slot_has_gmem()).

Until guest_memfd gains support for huge pages, the fault granule for
these memory regions is restricted to PAGE_SIZE.

Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: James Houghton <jthoughton@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/mmu.c | 86 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 83 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index b3eacb400fab..8c82df80a835 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1512,6 +1512,82 @@ static void adjust_nested_fault_perms(struct kvm_s2_trans *nested,
 	*prot |= kvm_encode_nested_level(nested);
 }
 
+#define KVM_PGTABLE_WALK_MEMABORT_FLAGS (KVM_PGTABLE_WALK_HANDLE_FAULT | KVM_PGTABLE_WALK_SHARED)
+
+static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
+		      struct kvm_s2_trans *nested,
+		      struct kvm_memory_slot *memslot, bool is_perm)
+{
+	bool write_fault, exec_fault, writable;
+	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_MEMABORT_FLAGS;
+	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
+	struct kvm_pgtable *pgt = vcpu->arch.hw_mmu->pgt;
+	unsigned long mmu_seq;
+	struct page *page;
+	struct kvm *kvm = vcpu->kvm;
+	void *memcache;
+	kvm_pfn_t pfn;
+	gfn_t gfn;
+	int ret;
+
+	ret = prepare_mmu_memcache(vcpu, true, &memcache);
+	if (ret)
+		return ret;
+
+	if (nested)
+		gfn = kvm_s2_trans_output(nested) >> PAGE_SHIFT;
+	else
+		gfn = fault_ipa >> PAGE_SHIFT;
+
+	write_fault = kvm_is_write_fault(vcpu);
+	exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
+
+	VM_WARN_ON_ONCE(write_fault && exec_fault);
+
+	mmu_seq = kvm->mmu_invalidate_seq;
+	/* Pairs with the smp_wmb() in kvm_mmu_invalidate_end(). */
+	smp_rmb();
+
+	ret = kvm_gmem_get_pfn(kvm, memslot, gfn, &pfn, &page, NULL);
+	if (ret) {
+		kvm_prepare_memory_fault_exit(vcpu, fault_ipa, PAGE_SIZE,
+					      write_fault, exec_fault, false);
+		return ret;
+	}
+
+	writable = !(memslot->flags & KVM_MEM_READONLY);
+
+	if (nested)
+		adjust_nested_fault_perms(nested, &prot, &writable);
+
+	if (writable)
+		prot |= KVM_PGTABLE_PROT_W;
+
+	if (exec_fault ||
+	    (cpus_have_final_cap(ARM64_HAS_CACHE_DIC) &&
+	     (!nested || kvm_s2_trans_executable(nested))))
+		prot |= KVM_PGTABLE_PROT_X;
+
+	kvm_fault_lock(kvm);
+	if (mmu_invalidate_retry(kvm, mmu_seq)) {
+		ret = -EAGAIN;
+		goto out_unlock;
+	}
+
+	ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, fault_ipa, PAGE_SIZE,
+						 __pfn_to_phys(pfn), prot,
+						 memcache, flags);
+
+out_unlock:
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
@@ -1536,7 +1612,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
 	struct kvm_pgtable *pgt;
 	struct page *page;
-	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_HANDLE_FAULT | KVM_PGTABLE_WALK_SHARED;
+	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_MEMABORT_FLAGS;
 
 	if (fault_is_perm)
 		fault_granule = kvm_vcpu_trap_get_perm_fault_granule(vcpu);
@@ -1961,8 +2037,12 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 	VM_WARN_ON_ONCE(kvm_vcpu_trap_is_permission_fault(vcpu) &&
 			!write_fault && !kvm_vcpu_trap_is_exec_fault(vcpu));
 
-	ret = user_mem_abort(vcpu, fault_ipa, nested, memslot, hva,
-			     esr_fsc_is_permission_fault(esr));
+	if (kvm_slot_has_gmem(memslot))
+		ret = gmem_abort(vcpu, fault_ipa, nested, memslot,
+				 esr_fsc_is_permission_fault(esr));
+	else
+		ret = user_mem_abort(vcpu, fault_ipa, nested, memslot, hva,
+				     esr_fsc_is_permission_fault(esr));
 	if (ret == 0)
 		ret = 1;
 out:
-- 
2.50.0.727.gbf7dc18ff4-goog


