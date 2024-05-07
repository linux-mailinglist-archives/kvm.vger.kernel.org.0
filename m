Return-Path: <kvm+bounces-16866-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B7448BE814
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 18:01:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C72FF2880C9
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 16:01:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F115116D9D9;
	Tue,  7 May 2024 15:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M9WCl8WZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 974AF16C69E
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 15:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715097507; cv=none; b=cUeABQNoXBS43THyJrFdy0osMVpTeCTY8RL7y35SSLXOxHYj6qXEGg1fNy1YVoMdan/J4lQtN0AWxkiZaglWVFqlx/hNzU4fFGaGHKBzDqfK/0G4RqHeCrdTU0R2d3BR0zBECGxWzTWI4e5tv1z3Mv3ECE/nHBm+QeL0mSXHotg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715097507; c=relaxed/simple;
	bh=Nv7alPH5S+bfefJPfN/RIwSAyzbcD0z6//fULF1pSNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o8/igXfuPg5S0kk2q2UGz3lBrihxmBYAnL3ca7GcOJlckMu5R2NU4QLg7NAe3sqh3Fuw9eiJTLMNrkwrgM2fup25k97yrbjHmjpe8SgFBDQrau08IegqmgW4dV6S7KKHXdJOarcciHEFZvHrdsxLae1c1RHRk5AOEcn2EICHZmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M9WCl8WZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715097503;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B008ipLLAUODyL5/aCau7+Mv2sC3RQCFlbYlFbvm7+c=;
	b=M9WCl8WZ+rzQsbrJ9NWCO8xKVw0vLxm1QajFb3FrPDqAhB7gfkSCD2f0am5yWqBaV1pJdo
	gQBoqTdnOgrkyPx+IT9dLg+2kyGZGaKbISynVTD7+RY4UYzleCzUdlsFoEGdfcLa5l/EIy
	eA91dTquEznr4n6QAeWmK5+Fubepyps=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-279-Whl3HQ72PNaa1_RSdPwmTw-1; Tue, 07 May 2024 11:58:21 -0400
X-MC-Unique: Whl3HQ72PNaa1_RSdPwmTw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8D62B857A86;
	Tue,  7 May 2024 15:58:20 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 670074750A1;
	Tue,  7 May 2024 15:58:20 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
	David Matlack <dmatlack@google.com>,
	Kai Huang <kai.huang@intel.com>
Subject: [PATCH 14/17] KVM: x86/mmu: Handle no-slot faults at the beginning of kvm_faultin_pfn()
Date: Tue,  7 May 2024 11:58:14 -0400
Message-ID: <20240507155817.3951344-15-pbonzini@redhat.com>
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

Handle the "no memslot" case at the beginning of kvm_faultin_pfn(), just
after the private versus shared check, so that there's no need to
repeatedly query whether or not a slot exists.  This also makes it more
obvious that, except for private vs. shared attributes, the process of
faulting in a pfn simply doesn't apply to gfns without a slot.

Opportunistically stuff @fault's metadata in kvm_handle_noslot_fault() so
that it doesn't need to be duplicated in all paths that invoke
kvm_handle_noslot_fault(), and to minimize the probability of not stuffing
the right fields.

Leave the existing handle behind, but convert it to a WARN, to guard
against __kvm_faultin_pfn() unexpectedly nullifying fault->slot.

Cc: David Matlack <dmatlack@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Message-ID: <20240228024147.41573-14-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b09c8034ed15..7630ad8cb022 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3270,6 +3270,10 @@ static int kvm_handle_noslot_fault(struct kvm_vcpu *vcpu,
 	vcpu_cache_mmio_info(vcpu, gva, fault->gfn,
 			     access & shadow_mmio_access_mask);
 
+	fault->slot = NULL;
+	fault->pfn = KVM_PFN_NOSLOT;
+	fault->map_writable = false;
+
 	/*
 	 * If MMIO caching is disabled, emulate immediately without
 	 * touching the shadow page tables as attempting to install an
@@ -4350,15 +4354,18 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 		return -EFAULT;
 	}
 
+	if (unlikely(!slot))
+		return kvm_handle_noslot_fault(vcpu, fault, access);
+
 	/*
 	 * Retry the page fault if the gfn hit a memslot that is being deleted
 	 * or moved.  This ensures any existing SPTEs for the old memslot will
 	 * be zapped before KVM inserts a new MMIO SPTE for the gfn.
 	 */
-	if (slot && (slot->flags & KVM_MEMSLOT_INVALID))
+	if (slot->flags & KVM_MEMSLOT_INVALID)
 		return RET_PF_RETRY;
 
-	if (slot && slot->id == APIC_ACCESS_PAGE_PRIVATE_MEMSLOT) {
+	if (slot->id == APIC_ACCESS_PAGE_PRIVATE_MEMSLOT) {
 		/*
 		 * Don't map L1's APIC access page into L2, KVM doesn't support
 		 * using APICv/AVIC to accelerate L2 accesses to L1's APIC,
@@ -4370,12 +4377,9 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 		 * uses different roots for L1 vs. L2, i.e. there is no danger
 		 * of breaking APICv/AVIC for L1.
 		 */
-		if (is_guest_mode(vcpu)) {
-			fault->slot = NULL;
-			fault->pfn = KVM_PFN_NOSLOT;
-			fault->map_writable = false;
-			goto faultin_done;
-		}
+		if (is_guest_mode(vcpu))
+			return kvm_handle_noslot_fault(vcpu, fault, access);
+
 		/*
 		 * If the APIC access page exists but is disabled, go directly
 		 * to emulation without caching the MMIO access or creating a
@@ -4386,6 +4390,9 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 			return RET_PF_EMULATE;
 	}
 
+	fault->mmu_seq = vcpu->kvm->mmu_invalidate_seq;
+	smp_rmb();
+
 	/*
 	 * Check for a relevant mmu_notifier invalidation event before getting
 	 * the pfn from the primary MMU, and before acquiring mmu_lock.
@@ -4407,19 +4414,17 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 	 * *guaranteed* to need to retry, i.e. waiting until mmu_lock is held
 	 * to detect retry guarantees the worst case latency for the vCPU.
 	 */
-	if (fault->slot &&
-	    mmu_invalidate_retry_gfn_unsafe(vcpu->kvm, fault->mmu_seq, fault->gfn))
+	if (mmu_invalidate_retry_gfn_unsafe(vcpu->kvm, fault->mmu_seq, fault->gfn))
 		return RET_PF_RETRY;
 
 	ret = __kvm_faultin_pfn(vcpu, fault);
 	if (ret != RET_PF_CONTINUE)
 		return ret;
 
-faultin_done:
 	if (unlikely(is_error_pfn(fault->pfn)))
 		return kvm_handle_error_pfn(vcpu, fault);
 
-	if (unlikely(!fault->slot))
+	if (WARN_ON_ONCE(!fault->slot))
 		return kvm_handle_noslot_fault(vcpu, fault, access);
 
 	/*
-- 
2.43.0



