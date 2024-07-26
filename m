Return-Path: <kvm+bounces-22418-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D9CCE93DBFF
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 02:12:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 946B92853E4
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 00:12:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B0A3186E5F;
	Fri, 26 Jul 2024 23:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CE1myMVp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE580186E34
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 23:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038073; cv=none; b=pHpQ4LN4bMhsLtJrEgbcIKOSheM2tAuCUbUoV/0oWJ+HFKOThiYxANwUOPKHVC5Z6h2mXp8NiDoEmrei69IoNdB6hJRtcENOAahsy3DPHG5xC3c3etQOrvQZRg5BKr4RCXf0lAWKYpRmiKaY3vL8eMF5BEF8sAdcHRfLdZ7mEh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038073; c=relaxed/simple;
	bh=+aOTq/dN+ZtKhcKidsUn1n9XU82CWPIY26uxDS8eRrg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UzZpGbKWhhjIpvieavS/6ECbnktk46F8CfGTql0aE7Y3XtP8u7uZIbCY6pNgaWRtxlSmU116pCSK5h8vro7zrmDMfgFGTT/wxylO9objz1C924fzToX0Fcf/7kj2KTjnaeBjNGDp78mgMai4PcWD+I3oMVH01M7G4N+gELU8LEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CE1myMVp; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-70ecd589debso373744b3a.2
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 16:54:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038071; x=1722642871; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=caIg6eZHDZieCZ2y8TnIGsflH+xvFOT1i8qMSVM8X2U=;
        b=CE1myMVp3Dl5k96tRgaVKwsJg1Hh5+4ubjoPOGHVYcU2nAp2bUAJp0xVcmUlG7Eq7T
         kX3FUVviN/xlCGE2VHhx4zvzCFdIXTTAeGebohLc0WJQy0S0QtKCndHVGf8rXyWhZZvK
         K6WBTEDu89MDh9neQNH/5VcA2kCk0bVCH1D5EZe+FSSWztgn1toecH/12k8k7EFV9IFW
         BG3oU0/hq36mZarPCztbdXApyZYytdiU/OQE2AlAAZob+lwGFksyoSApae8+/540p4Yu
         Vb4dBMy573Oloj6ALIjKMIRudvLdvUj3tPfjgkvnhxk4D5I4GciudU2Y9A4yO3tdKSdP
         iccQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038071; x=1722642871;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=caIg6eZHDZieCZ2y8TnIGsflH+xvFOT1i8qMSVM8X2U=;
        b=K100PwCvFvs5Hh8qCNrTEqdsOTHLtg+dGmZmGpZknvST0fseLcFkTzU+/BVsExmdPC
         5kqlQ8CD3AK3LNbinARDDuDQMBlH7gKv4ZMcuSzWbiTS+ue/JfAHKaUPE3cFACakTCCX
         6iawjpLy9Vkj/BItemau6BrzORx2gGJZz6iwl3uyXkDfRsZnzjhsU2hkmcBQdzZxiRqO
         LbdAc5OSazCO/8I/q6oQdFDpLBq5fkCoxP3csLS5zDbBZ4T2pN1Da52W02eDtI47C7q/
         IhWKrifot48QJZ07l/UAwUglfuj02tMUPcID6uVqGZkTKisMAKW/fGZzBr1JY8QkW/Go
         7zDA==
X-Gm-Message-State: AOJu0Yy7s2LJ1FB2E4LZ2XAkZc11S29MnbPbu42GjXOzhO8CRa7xKLbS
	/Fh/s3YsM8nYH7XEWQKK3CKcY+kgCdDeIr2GOcpMSUpqQJiZJh33QzoBmkGf+/7VkLnsKva7BPF
	uiA==
X-Google-Smtp-Source: AGHT+IFCpL56eroYNOyLiVhUcT5fyuFzA98b59p62FwWY/A7pZmePwqTF4FXfEto2ywMz9XC9lExu2Xr4CM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:9445:b0:706:3421:740d with SMTP id
 d2e1a72fcca58-70ece9ecf02mr25759b3a.1.1722038071004; Fri, 26 Jul 2024
 16:54:31 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:52:04 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-56-seanjc@google.com>
Subject: [PATCH v12 55/84] KVM: arm64: Use __kvm_faultin_pfn() to handle
 memory aborts
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Convert arm64 to use __kvm_faultin_pfn()+kvm_release_faultin_page().
Three down, six to go.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/mmu.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index ce13c3d884d5..756fc856ab44 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1439,6 +1439,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	long vma_pagesize, fault_granule;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
 	struct kvm_pgtable *pgt;
+	struct page *page;
 
 	if (fault_is_perm)
 		fault_granule = kvm_vcpu_trap_get_perm_fault_granule(vcpu);
@@ -1553,7 +1554,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 	/*
 	 * Read mmu_invalidate_seq so that KVM can detect if the results of
-	 * vma_lookup() or __gfn_to_pfn_memslot() become stale prior to
+	 * vma_lookup() or __kvm_faultin_pfn() become stale prior to
 	 * acquiring kvm->mmu_lock.
 	 *
 	 * Rely on mmap_read_unlock() for an implicit smp_rmb(), which pairs
@@ -1562,8 +1563,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	mmu_seq = vcpu->kvm->mmu_invalidate_seq;
 	mmap_read_unlock(current->mm);
 
-	pfn = __gfn_to_pfn_memslot(memslot, gfn, false, NULL,
-				   write_fault, &writable);
+	pfn = __kvm_faultin_pfn(memslot, gfn, write_fault ? FOLL_WRITE : 0,
+				&writable, &page);
 	if (pfn == KVM_PFN_ERR_HWPOISON) {
 		kvm_send_hwpoison_signal(hva, vma_shift);
 		return 0;
@@ -1576,7 +1577,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		 * If the page was identified as device early by looking at
 		 * the VMA flags, vma_pagesize is already representing the
 		 * largest quantity we can map.  If instead it was mapped
-		 * via gfn_to_pfn_prot(), vma_pagesize is set to PAGE_SIZE
+		 * via __kvm_faultin_pfn(), vma_pagesize is set to PAGE_SIZE
 		 * and must not be upgraded.
 		 *
 		 * In both cases, we don't let transparent_hugepage_adjust()
@@ -1685,11 +1686,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	}
 
 out_unlock:
-	if (writable && !ret)
-		kvm_set_pfn_dirty(pfn);
-	else
-		kvm_release_pfn_clean(pfn);
-
+	kvm_release_faultin_page(kvm, page, !!ret, writable);
 	read_unlock(&kvm->mmu_lock);
 
 	/* Mark the page dirty only if the fault is handled successfully */
-- 
2.46.0.rc1.232.g9752f9e123-goog


