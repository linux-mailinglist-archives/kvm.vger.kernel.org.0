Return-Path: <kvm+bounces-14561-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 985008A34E5
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 19:37:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BBC841C20B40
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 17:37:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E282152199;
	Fri, 12 Apr 2024 17:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PyhU+XJR"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5ACD14F9D5
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 17:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712943343; cv=none; b=rs8vdAs3/fjbtJ6BMWH6H6+e1O90dTm/8kx3jmDF2oUh+AmedLcHxoJmMNu4Y0qhxgYzSJfU2B2FG1XJ/esbAim/uyEWbRhXX0wcnNYtvPWCITqhtK+1lBkvgb+YE7iPUiqQu8CJ5WZK4M+TMC1l54rvdI3rPYquoB4u31gzmm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712943343; c=relaxed/simple;
	bh=SblgvMbXzd2Ze5EwcGXr9NfOC6NhtN8U7V3X2qt0Jrc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A0NmLS/4cON0gO1ZDGyNSQlZEb1ppTiAhZcrOU+iSrdS+oYoN6UXs9L/GIur53gV1LJjo01q4qPJ/5RZAuI4kliOzc1JxY/FZsthX0BcfybYva2qqDPeZgxLrinh8jXjXrK/aex+yLHpP9tLRluGt8Vnk2yPrF8Rpn5UC1g8Jms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PyhU+XJR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712943340;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hxUVcXbFfmeqgMIAoI895HcOMlTFsPTHP3NiqFn31Sg=;
	b=PyhU+XJRHM0kQeHv9frNuaOtsMgYRJTT3Qs5w8P4/d4bzW4+Um8RbXgma6MV2cgdZeEzYG
	UxSfb/dF0aoIWQvjvCc3n49COcQliwic0Qw02tpPxZP7ErQe+SkD7Cw/RTW8KfSS6FnRZI
	NbbtYNfWzxFRPjbG2efGXYBomhzr+uM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-258-uMLvgyG0MV6Qrudf1UeWYA-1; Fri, 12 Apr 2024 13:35:35 -0400
X-MC-Unique: uMLvgyG0MV6Qrudf1UeWYA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A5980104B505;
	Fri, 12 Apr 2024 17:35:34 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8E4F7492BC7;
	Fri, 12 Apr 2024 17:35:34 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH 09/10] KVM: x86/mmu: Use PFERR_GUEST_ENC_MASK to indicate fault is private
Date: Fri, 12 Apr 2024 13:35:31 -0400
Message-ID: <20240412173532.3481264-10-pbonzini@redhat.com>
In-Reply-To: <20240412173532.3481264-1-pbonzini@redhat.com>
References: <20240412173532.3481264-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

SEV-SNP defines PFERR_GUEST_ENC_MASK (bit 34) in page-fault error bits to
represent the guest page is encrypted.  Use the bit to designate that the
page fault is private and that it requires looking up memory attributes.

The vendor kvm page fault handler should set PFERR_GUEST_ENC_MASK bit based
on their fault information.  It may or may not use the hardware value
directly or parse the hardware value to set the bit.

Based on a patch by Isaku Yamahata.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 2 ++
 arch/x86/kvm/mmu/mmu.c          | 9 +++++++++
 arch/x86/kvm/mmu/mmu_internal.h | 2 +-
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 23f1b123830a..0b73f78dd70a 100644
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
index 8c56d278d8a2..0fb175ad6b9b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5801,6 +5801,7 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
 {
 	int r, emulation_type = EMULTYPE_PF;
 	bool direct = vcpu->arch.mmu->root_role.direct;
+	struct kvm *kvm = vcpu->kvm;
 
 	/*
 	 * IMPLICIT_ACCESS is a KVM-defined flag used to correctly perform SMAP
@@ -5816,6 +5817,14 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
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
index 49b428cca04e..7c2ba50cec68 100644
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
2.43.0



