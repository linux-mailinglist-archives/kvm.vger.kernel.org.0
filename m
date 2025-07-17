Return-Path: <kvm+bounces-52769-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BDA2EB091D0
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 18:30:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D8F8816FB69
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 16:30:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B73AE2FF482;
	Thu, 17 Jul 2025 16:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ng77itDl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23D1C2FEE0F
	for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 16:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752769672; cv=none; b=uRlqCYGuGPJTD5mSrL+vgR6209B4hM1fMYhwNWyjPKta2btzfVmotDo2VRgvRK955QbS4AFThnv+4ZMVF3nqMF+U5otvVMc0dqQ8IAy+jMqLx52fW6YWLkKaGN5rAt4ZDRseXJhSAbdF/05+nalKynE5R7h8GfkQg+ZKmeR2OV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752769672; c=relaxed/simple;
	bh=zEZkLi/zufUM9bTMjQStV1DSpFIHKsECtzBWN+Saz3c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CP0xp42Rln0S7VV+r4UtX+5rQK3PVoeeVY+2FpZoJmDaWbpi9EQ71WHt4b0mdbHTwrh4SX0ErtQAOYU6FQpxCMToe9RaOsg7E/Mo1RxYdaCed+PLMU5yiryucfb2RdhVm0XdYU2nAdqQCQhCPLEpaEeWFp0IeTqBgocJbf7Zu3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ng77itDl; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3a4fabcafecso581245f8f.0
        for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 09:27:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752769669; x=1753374469; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FLr2IgfKpLCEHT7MXIG6C0hRgCJ9BMJYV3UvbtKXymU=;
        b=Ng77itDlQUd5VTizUALBHhoV19ffeDU7ugB+sAe9z2Y5KDChT/6Ke96mFtnAZkrxqp
         ds7CDiW2agGU6zkMoZuuUQ9SjDCBGLlkqnvf32onVbs2mODzSWLC+wk1Po7H1Ttxct3R
         Y0OjpmlcBOtW2nymSILvxBBwBlCfqeHPwzC9nt6MAgqVu71ciHYYPTz6aMGdTu4SZ7my
         vxrz8OwafzxWLwFS475rb4yxH5yxtpmFDgjOoZEp6wsfdlafC8qNuhejsbP3OsWwN+r9
         9mIRirnA+8dIhLYkWfOub9vO+Zks276vAsix2S92/F9yAydHks9ixnLR/wVQiWzcrCs+
         QvOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752769669; x=1753374469;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FLr2IgfKpLCEHT7MXIG6C0hRgCJ9BMJYV3UvbtKXymU=;
        b=fFZBOat+vS/3w8tALRKe2Jgbt2/kG7mF3NQR20FKLHfAcuk4cKY7qATKIaSKEucdG7
         0MT6nJO5Cdxa7VgSvy+7SDWGq/nkxFiQgWyH/MveexKVuGUPYxFj7UxaMg2chWOmFBP7
         OtsbQt894i1y3ceub4wtnKkFDdROfXmXK8n+hk5P7gz0uTRHdASwzUXOoaRycKNA3kcz
         V2XwDkCi1Hf4WMEJeZEJG/KzMYXQE+9+RPI4Nk112J1Ho1OJCdi+t6bXK0KE1mybYxxv
         xqZAeGRil53bcZiTAEGYN6lfWSvuCCZfO9ifV+RUEuKSPHOufRxS348nNogEYT0M9rp4
         SgbA==
X-Gm-Message-State: AOJu0YxLhD5orqnGRLJsAP8x6/fsQfj0n/EVcbpdIxV9FapdoxbSOFr0
	bEcj+vLm52F0oU3jfab/mIWRYVfC6evL4zwrHhGTPWutLF8ZdlEdpjNn//HIkKhT82lNYLGVDGY
	vOijNEDmgsZOQqT6kx2XgCzDcANBirST4D6l40VNls6+nuldzQRd9qUuITN1bGmaRjsGf6uB1ke
	L3t3JGsZnumig8uV/zrGe+xQNAbWc=
X-Google-Smtp-Source: AGHT+IGLGRNOwWdU0sarMvh/CV/xZw5fHmBfiAXJxNl/bH62ly67wunlKYsYQUCgrzb+O9vFJnxucVGfVg==
X-Received: from wrrv11.prod.google.com ([2002:a5d:43cb:0:b0:3a5:751c:a327])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2811:b0:3a5:8565:44d1
 with SMTP id ffacd0b85a97d-3b60dd78e32mr4493555f8f.25.1752769668932; Thu, 17
 Jul 2025 09:27:48 -0700 (PDT)
Date: Thu, 17 Jul 2025 17:27:26 +0100
In-Reply-To: <20250717162731.446579-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250717162731.446579-17-tabba@google.com>
Subject: [PATCH v15 16/21] KVM: arm64: Handle guest_memfd-backed guest page faults
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


