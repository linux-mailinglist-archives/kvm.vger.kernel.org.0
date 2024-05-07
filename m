Return-Path: <kvm+bounces-16862-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 29BD78BE810
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 18:00:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4D9A61C232DA
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 16:00:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8B9416D4CE;
	Tue,  7 May 2024 15:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="alKryGus"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87CF016ABC6
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 15:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715097506; cv=none; b=h8TVjBt9pteeF+rlWn5v4uunVBDmTxH4F5v1Po1SqQBGS3WJMPDWO8EEL0vq4UbjZk5eXO77Y6mkDQ3nGgkCydsQEe8tLUucGi3Hjt7tA4c/sH5taB4BatHF7VwWrH9zqOaszCDWX24E8AN95mMo5oKLuth87lpRRwkCcI7AnDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715097506; c=relaxed/simple;
	bh=Jc1Tbss7i1Ju4KveDSuZj4nCUDFkNCR8orrkEHkum5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bNDxSemtn7uynquJvam+DFI16hOlVq0nEusPVtHGSbmf7CQR579y4Ws9Ty6NHrvQlROXWIPd3Bd/MwjUffS0GK5ossanALrar77nhAQHeigNw23b9ULNLYw6Pb9WNNxt3Y2WRw2NvcnCENCuv8tIkexFjzwMOybbBTnccYEZ6rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=alKryGus; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715097502;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rUh2GSNIC9mFZceVpUckSJUlR16exki8Ae5fEBtcFTE=;
	b=alKryGusbAE8T+6fG8fK/zfn93Hz39rGD565tz/ILKQptVUf5Fi8GdvyoYS/yO8hCT9/kr
	UN3sRswPs/DwXLfAfdys8VDiJ1Iq83n/2/Xdzckq1/tk65s0X+7GxRSw3ZMJ6oUBrGMd2Y
	SpJMGXduChQqj7RHspEN+iIG9NpVjRg=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-346-8y3twOTSMzaVkPuSJ1q2aA-1; Tue,
 07 May 2024 11:58:19 -0400
X-MC-Unique: 8y3twOTSMzaVkPuSJ1q2aA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 35AB33802AC9;
	Tue,  7 May 2024 15:58:19 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 19A14200B2F6;
	Tue,  7 May 2024 15:58:19 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>
Subject: [PATCH 07/17] KVM: x86/mmu: Use synthetic page fault error code to indicate private faults
Date: Tue,  7 May 2024 11:58:07 -0400
Message-ID: <20240507155817.3951344-8-pbonzini@redhat.com>
In-Reply-To: <20240507155817.3951344-1-pbonzini@redhat.com>
References: <20240507155817.3951344-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

From: Sean Christopherson <seanjc@google.com>

Add and use a synthetic, KVM-defined page fault error code to indicate
whether a fault is to private vs. shared memory.  TDX and SNP have
different mechanisms for reporting private vs. shared, and KVM's
software-protected VMs have no mechanism at all.  Usurp an error code
flag to avoid having to plumb another parameter to kvm_mmu_page_fault()
and friends.

Alternatively, KVM could borrow AMD's PFERR_GUEST_ENC_MASK, i.e. set it
for TDX and software-protected VMs as appropriate, but that would require
*clearing* the flag for SEV and SEV-ES VMs, which support encrypted
memory at the hardware layer, but don't utilize private memory at the
KVM layer.

Opportunistically add a comment to call out that the logic for software-
protected VMs is (and was before this commit) broken for nested MMUs, i.e.
for nested TDP, as the GPA is an L2 GPA.  Punt on trying to play nice with
nested MMUs as there is a _lot_ of functionality that simply doesn't work
for software-protected VMs, e.g. all of the paths where KVM accesses guest
memory need to be updated to be aware of private vs. shared memory.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20240228024147.41573-6-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  7 ++++++-
 arch/x86/kvm/mmu/mmu.c          | 14 ++++++++++++++
 arch/x86/kvm/mmu/mmu_internal.h |  2 +-
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 12e727301262..0dc755a6dc0c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -273,7 +273,12 @@ enum x86_intercept_stage;
  * when emulating instructions that triggers implicit access.
  */
 #define PFERR_IMPLICIT_ACCESS	BIT_ULL(48)
-#define PFERR_SYNTHETIC_MASK	(PFERR_IMPLICIT_ACCESS)
+/*
+ * PRIVATE_ACCESS is a KVM-defined flag us to indicate that a fault occurred
+ * when the guest was accessing private memory.
+ */
+#define PFERR_PRIVATE_ACCESS   BIT_ULL(49)
+#define PFERR_SYNTHETIC_MASK   (PFERR_IMPLICIT_ACCESS | PFERR_PRIVATE_ACCESS)
 
 #define PFERR_NESTED_GUEST_PAGE (PFERR_GUEST_PAGE_MASK |	\
 				 PFERR_WRITE_MASK |		\
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3609167ba30e..eb041acec2dc 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5799,6 +5799,20 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
 	if (WARN_ON_ONCE(!VALID_PAGE(vcpu->arch.mmu->root.hpa)))
 		return RET_PF_RETRY;
 
+	/*
+	 * Except for reserved faults (emulated MMIO is shared-only), set the
+	 * PFERR_PRIVATE_ACCESS flag for software-protected VMs based on the gfn's
+	 * current attributes, which are the source of truth for such VMs.  Note,
+	 * this wrong for nested MMUs as the GPA is an L2 GPA, but KVM doesn't
+	 * currently supported nested virtualization (among many other things)
+	 * for software-protected VMs.
+	 */
+	if (IS_ENABLED(CONFIG_KVM_SW_PROTECTED_VM) &&
+	    !(error_code & PFERR_RSVD_MASK) &&
+	    vcpu->kvm->arch.vm_type == KVM_X86_SW_PROTECTED_VM &&
+	    kvm_mem_is_private(vcpu->kvm, gpa_to_gfn(cr2_or_gpa)))
+		error_code |= PFERR_PRIVATE_ACCESS;
+
 	r = RET_PF_INVALID;
 	if (unlikely(error_code & PFERR_RSVD_MASK)) {
 		r = handle_mmio_page_fault(vcpu, cr2_or_gpa, direct);
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 797b80f996a7..dfd9ff383663 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -306,7 +306,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		.max_level = KVM_MAX_HUGEPAGE_LEVEL,
 		.req_level = PG_LEVEL_4K,
 		.goal_level = PG_LEVEL_4K,
-		.is_private = kvm_mem_is_private(vcpu->kvm, cr2_or_gpa >> PAGE_SHIFT),
+		.is_private = err & PFERR_PRIVATE_ACCESS,
 	};
 	int r;
 
-- 
2.43.0



