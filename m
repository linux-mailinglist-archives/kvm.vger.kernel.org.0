Return-Path: <kvm+bounces-10161-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A474986A3B4
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 00:32:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ECC40B2E5AD
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 23:24:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BA195B20F;
	Tue, 27 Feb 2024 23:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QJkZAnk7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CBB357888
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 23:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709076072; cv=none; b=NBlojs2LQaH0DejDc8DuldPt6sMnBOV5C9MF6LEtY1lrk1gW3EYv233FxNaOf11DF0VKq7heGqYupg2n0usLjqGZifGO25nivJJHsH1hUAgDGHiciGIzc/tTeF9gKWByxF80D61i77CLFkNjxXrhKzHa3Tc/zdSeUva1LK5ExQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709076072; c=relaxed/simple;
	bh=kAGvldVSSgs/cuGA2UhZHAoRzsM3NNWHqjWVGuiXJcU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YVVyhcM8tDqpjU55bJ4MsCH0kqKDNLLFT348Uwot2JJ3m2RGYGma4sfLvfK79p46YlZQWe/MoqcCJvnEyAChwaqNTeEkBnb+wg9GtBWUX5uVWR8PaHx5VkMBAssRhJAdmUyEC1nJzj/eXPKeccWVlCVrtM6tDCXt+ej0Vge0ekI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QJkZAnk7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709076068;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ItA4hweoRhWLy+GIQ/7oXHP94HCpIoNmoXorWKs0+NI=;
	b=QJkZAnk7gBbyux7knWohPefBoPyXAiqXWMaBWPtgCblbfttqI3VPWh8H8g/jSdKwL1hJho
	22VgKrU5CSz/m2QB6/jjvcGWu5ytcKmhSsl2MBWZUhpNe8xeYNqwBV5YqeJaULZ8jaYCCf
	S1GeuIPW8iw0bAXfG3Y5KpHenTn0ho8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-169-tuhU7xeHM2uf3DRJImU8EQ-1; Tue, 27 Feb 2024 18:21:04 -0500
X-MC-Unique: tuhU7xeHM2uf3DRJImU8EQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 65E90800074;
	Tue, 27 Feb 2024 23:21:04 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 395F3C0348F;
	Tue, 27 Feb 2024 23:21:04 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	michael.roth@amd.com,
	isaku.yamahata@intel.com,
	thomas.lendacky@amd.com
Subject: [PATCH 15/21] KVM: x86/mmu: Use PFERR_GUEST_ENC_MASK to indicate fault is private
Date: Tue, 27 Feb 2024 18:20:54 -0500
Message-Id: <20240227232100.478238-16-pbonzini@redhat.com>
In-Reply-To: <20240227232100.478238-1-pbonzini@redhat.com>
References: <20240227232100.478238-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

SEV-SNP defines PFERR_GUEST_ENC_MASK (bit 34) in page-fault error bits to
represent the guest page is encrypted.  Use the bit to designate that the
page fault is private and that it requires looking up memory attributes.

The vendor kvm page fault handler should set PFERR_GUEST_ENC_MASK bit based
on their fault information.  It may or may not use the hardware value
directly or parse the hardware value to set the bit.

Based on a patch by Isaku Yamahata.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
	Compared to what is in the Intel TDX tree, I am dropping the

		if (vcpu->kvm->arch.vm_type == KVM_X86_SW_PROTECTED_VM)
			return RET_PF_RETRY;

	change in __kvm_faultin_pfn().  It is not well documented why it
	is needed and selftests seem to pass.

	Also, checking has_private_mem is needed so as not to break SEV-ES.

 arch/x86/include/asm/kvm_host.h | 2 ++
 arch/x86/kvm/mmu/mmu.c          | 9 +++++++++
 arch/x86/kvm/mmu/mmu_internal.h | 2 +-
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 24e30ca2ca8f..7de8a3f2a118 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -264,6 +264,7 @@ enum x86_intercept_stage;
 #define PFERR_SGX_BIT 15
 #define PFERR_GUEST_FINAL_BIT 32
 #define PFERR_GUEST_PAGE_BIT 33
+#define PFERR_GUEST_ENC_BIT 34
 #define PFERR_IMPLICIT_ACCESS_BIT 48
 
 #define PFERR_PRESENT_MASK	BIT(PFERR_PRESENT_BIT)
@@ -275,6 +276,7 @@ enum x86_intercept_stage;
 #define PFERR_SGX_MASK		BIT(PFERR_SGX_BIT)
 #define PFERR_GUEST_FINAL_MASK	BIT_ULL(PFERR_GUEST_FINAL_BIT)
 #define PFERR_GUEST_PAGE_MASK	BIT_ULL(PFERR_GUEST_PAGE_BIT)
+#define PFERR_GUEST_ENC_MASK	BIT_ULL(PFERR_GUEST_ENC_BIT)
 #define PFERR_IMPLICIT_ACCESS	BIT_ULL(PFERR_IMPLICIT_ACCESS_BIT)
 
 #define PFERR_NESTED_GUEST_PAGE (PFERR_GUEST_PAGE_MASK |	\
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c9890e5b6e4c..6b4cb71668df 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5846,6 +5846,7 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
 {
 	int r, emulation_type = EMULTYPE_PF;
 	bool direct = vcpu->arch.mmu->root_role.direct;
+	struct kvm *kvm = vcpu->kvm;
 
 	/*
 	 * IMPLICIT_ACCESS is a KVM-defined flag used to correctly perform SMAP
@@ -5861,6 +5862,14 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
 	if (WARN_ON_ONCE(!VALID_PAGE(vcpu->arch.mmu->root.hpa)))
 		return RET_PF_RETRY;
 
+	/*
+	 * There is no vendor code that can set PFERR_GUEST_ENC_MASK for
+	 * software-protected VMs.  Compute it here.
+	 */
+	if (kvm->arch.vm_type == KVM_X86_SW_PROTECTED_VM &&
+	    kvm_mem_is_private(kvm, cr2_or_gpa >> PAGE_SHIFT))
+		error_code |= PFERR_GUEST_ENC_MASK;
+
 	r = RET_PF_INVALID;
 	if (unlikely(error_code & PFERR_RSVD_MASK)) {
 		r = handle_mmio_page_fault(vcpu, cr2_or_gpa, direct);
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 21f55e8b4dc6..154aa44eeb33 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -290,6 +290,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		.present = err & PFERR_PRESENT_MASK,
 		.rsvd = err & PFERR_RSVD_MASK,
 		.user = err & PFERR_USER_MASK,
+		.is_private = vcpu->kvm->arch.has_private_mem && (err & PFERR_GUEST_ENC_MASK),
 		.prefetch = prefetch,
 		.is_tdp = likely(vcpu->arch.mmu->page_fault == kvm_tdp_page_fault),
 		.nx_huge_page_workaround_enabled =
@@ -298,7 +299,6 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		.max_level = KVM_MAX_HUGEPAGE_LEVEL,
 		.req_level = PG_LEVEL_4K,
 		.goal_level = PG_LEVEL_4K,
-		.is_private = kvm_mem_is_private(vcpu->kvm, cr2_or_gpa >> PAGE_SHIFT),
 	};
 	int r;
 
-- 
2.39.0



