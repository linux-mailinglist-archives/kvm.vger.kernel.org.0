Return-Path: <kvm+bounces-16867-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DDE9B8BE815
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 18:01:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 93FB92880C9
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 16:01:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07AF116D9DD;
	Tue,  7 May 2024 15:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XrCKn7zM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1007D16C6BE
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 15:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715097507; cv=none; b=I5BrhLhY1EjTMQza+fk6QzDDOlGhv0C7RQIq0teFhMW4vIaaoX+/6d596ytyI8zrHNaLh//NbY8GAxbBPW66grg8O00/RZtTk03Dn8juebem0KEnQYuWzyZumXLMxw620BkfHPO+JRPlaV+Euw/vI+NrNKLFkM333eKS7rTqtP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715097507; c=relaxed/simple;
	bh=wPlCXimapm+jPc+Vmg65K7D6e/gcKhVZU6wKgZ0EdL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SbJUy/rtu1zwZVwEb6p7JAIiz4GpA9Pzwxm2SqkIfbwmeikI1hENZ7R0Gu480s0tlChDSnaEV8AqEPawj+KeKVxPvwSxmLmvCNbgtDqXJz1SUjpLanxRaFnkVHpqy9bPfghK0BJObwEfzDyiW8nyDPPXY5CPjq+g+wdh9MWDrDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XrCKn7zM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715097504;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sj1bBQVsR0XAxvgoMpCTsAlzVv4DCommwwcKBFDz4Jg=;
	b=XrCKn7zMBY956IsifUtYvo7tQiloz4ErAUFP9WbG0Opwu6KkiQw/LsDbLdgyfnp7V/uppy
	yCaNzx4+F2wgbA2kFLTTd9oafvc/unUDz78auUt6+aFLWBa/v4GZqPnmJKY/XAx9AW+/Gs
	M4x1oCfSgDEfZWqzUdPDDfxdUonm8Jc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-549-aQp1tBL6P-6KjQldWUXi6g-1; Tue, 07 May 2024 11:58:20 -0400
X-MC-Unique: aQp1tBL6P-6KjQldWUXi6g-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5DA5E101A525;
	Tue,  7 May 2024 15:58:20 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3C3ED401441;
	Tue,  7 May 2024 15:58:20 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
	Kai Huang <kai.huang@intel.com>
Subject: [PATCH 13/17] KVM: x86/mmu: Move slot checks from __kvm_faultin_pfn() to kvm_faultin_pfn()
Date: Tue,  7 May 2024 11:58:13 -0400
Message-ID: <20240507155817.3951344-14-pbonzini@redhat.com>
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

From: Sean Christopherson <seanjc@google.com>

Move the checks related to the validity of an access to a memslot from the
inner __kvm_faultin_pfn() to its sole caller, kvm_faultin_pfn().  This
allows emulating accesses to the APIC access page, which don't need to
resolve a pfn, even if there is a relevant in-progress mmu_notifier
invalidation.  Ditto for accesses to KVM internal memslots from L2, which
KVM also treats as emulated MMIO.

More importantly, this will allow for future cleanup by having the
"no memslot" case bail from kvm_faultin_pfn() very early on.

Go to rather extreme and gross lengths to make the change a glorified
nop, e.g. call into __kvm_faultin_pfn() even when there is no slot, as the
related code is very subtle.  E.g. fault->slot can be nullified if it
points at the APIC access page, some flows in KVM x86 expect fault->pfn
to be KVM_PFN_NOSLOT, while others check only fault->slot, etc.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Message-ID: <20240228024147.41573-13-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 115 +++++++++++++++++++++--------------------
 1 file changed, 58 insertions(+), 57 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index fdae6d19e72b..b09c8034ed15 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4292,9 +4292,64 @@ static int kvm_faultin_pfn_private(struct kvm_vcpu *vcpu,
 
 static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
-	struct kvm_memory_slot *slot = fault->slot;
 	bool async;
 
+	if (fault->is_private)
+		return kvm_faultin_pfn_private(vcpu, fault);
+
+	async = false;
+	fault->pfn = __gfn_to_pfn_memslot(fault->slot, fault->gfn, false, false,
+					  &async, fault->write,
+					  &fault->map_writable, &fault->hva);
+	if (!async)
+		return RET_PF_CONTINUE; /* *pfn has correct page already */
+
+	if (!fault->prefetch && kvm_can_do_async_pf(vcpu)) {
+		trace_kvm_try_async_get_page(fault->addr, fault->gfn);
+		if (kvm_find_async_pf_gfn(vcpu, fault->gfn)) {
+			trace_kvm_async_pf_repeated_fault(fault->addr, fault->gfn);
+			kvm_make_request(KVM_REQ_APF_HALT, vcpu);
+			return RET_PF_RETRY;
+		} else if (kvm_arch_setup_async_pf(vcpu, fault)) {
+			return RET_PF_RETRY;
+		}
+	}
+
+	/*
+	 * Allow gup to bail on pending non-fatal signals when it's also allowed
+	 * to wait for IO.  Note, gup always bails if it is unable to quickly
+	 * get a page and a fatal signal, i.e. SIGKILL, is pending.
+	 */
+	fault->pfn = __gfn_to_pfn_memslot(fault->slot, fault->gfn, false, true,
+					  NULL, fault->write,
+					  &fault->map_writable, &fault->hva);
+	return RET_PF_CONTINUE;
+}
+
+static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
+			   unsigned int access)
+{
+	struct kvm_memory_slot *slot = fault->slot;
+	int ret;
+
+	/*
+	 * Note that the mmu_invalidate_seq also serves to detect a concurrent
+	 * change in attributes.  is_page_fault_stale() will detect an
+	 * invalidation relate to fault->fn and resume the guest without
+	 * installing a mapping in the page tables.
+	 */
+	fault->mmu_seq = vcpu->kvm->mmu_invalidate_seq;
+	smp_rmb();
+
+	/*
+	 * Now that we have a snapshot of mmu_invalidate_seq we can check for a
+	 * private vs. shared mismatch.
+	 */
+	if (fault->is_private != kvm_mem_is_private(vcpu->kvm, fault->gfn)) {
+		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
+		return -EFAULT;
+	}
+
 	/*
 	 * Retry the page fault if the gfn hit a memslot that is being deleted
 	 * or moved.  This ensures any existing SPTEs for the old memslot will
@@ -4319,7 +4374,7 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 			fault->slot = NULL;
 			fault->pfn = KVM_PFN_NOSLOT;
 			fault->map_writable = false;
-			return RET_PF_CONTINUE;
+			goto faultin_done;
 		}
 		/*
 		 * If the APIC access page exists but is disabled, go directly
@@ -4331,61 +4386,6 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 			return RET_PF_EMULATE;
 	}
 
-	if (fault->is_private)
-		return kvm_faultin_pfn_private(vcpu, fault);
-
-	async = false;
-	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, false, &async,
-					  fault->write, &fault->map_writable,
-					  &fault->hva);
-	if (!async)
-		return RET_PF_CONTINUE; /* *pfn has correct page already */
-
-	if (!fault->prefetch && kvm_can_do_async_pf(vcpu)) {
-		trace_kvm_try_async_get_page(fault->addr, fault->gfn);
-		if (kvm_find_async_pf_gfn(vcpu, fault->gfn)) {
-			trace_kvm_async_pf_repeated_fault(fault->addr, fault->gfn);
-			kvm_make_request(KVM_REQ_APF_HALT, vcpu);
-			return RET_PF_RETRY;
-		} else if (kvm_arch_setup_async_pf(vcpu, fault)) {
-			return RET_PF_RETRY;
-		}
-	}
-
-	/*
-	 * Allow gup to bail on pending non-fatal signals when it's also allowed
-	 * to wait for IO.  Note, gup always bails if it is unable to quickly
-	 * get a page and a fatal signal, i.e. SIGKILL, is pending.
-	 */
-	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, true, NULL,
-					  fault->write, &fault->map_writable,
-					  &fault->hva);
-	return RET_PF_CONTINUE;
-}
-
-static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
-			   unsigned int access)
-{
-	int ret;
-
-	/*
-	 * Note that the mmu_invalidate_seq also serves to detect a concurrent
-	 * change in attributes.  is_page_fault_stale() will detect an
-	 * invalidation relate to fault->fn and resume the guest without
-	 * installing a mapping in the page tables.
-	 */
-	fault->mmu_seq = vcpu->kvm->mmu_invalidate_seq;
-	smp_rmb();
-
-	/*
-	 * Now that we have a snapshot of mmu_invalidate_seq we can check for a
-	 * private vs. shared mismatch.
-	 */
-	if (fault->is_private != kvm_mem_is_private(vcpu->kvm, fault->gfn)) {
-		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
-		return -EFAULT;
-	}
-
 	/*
 	 * Check for a relevant mmu_notifier invalidation event before getting
 	 * the pfn from the primary MMU, and before acquiring mmu_lock.
@@ -4415,6 +4415,7 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 	if (ret != RET_PF_CONTINUE)
 		return ret;
 
+faultin_done:
 	if (unlikely(is_error_pfn(fault->pfn)))
 		return kvm_handle_error_pfn(vcpu, fault);
 
-- 
2.43.0



