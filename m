Return-Path: <kvm+bounces-16865-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A33588BE822
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 18:02:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 31444B27FFE
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 16:01:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07A5616D9DB;
	Tue,  7 May 2024 15:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OJWhEJiF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A2B916C6A4
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 15:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715097507; cv=none; b=DCWYr3ZarnfcKjK2+ovIFdITOrFCn4zVkzV6fCdfKc8yr3VDwaq7Ka/SssMRyqtGju9MXapZbjwxjFV4D0mOWmY7n+2FJgNyyfmBlLrYLev8bqU/PHwWDkxgTwixaYeYUQ6OyhlxXyK4dN0j9oeSuoJzCYLkAQnfiny5qsp02Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715097507; c=relaxed/simple;
	bh=i9B+Gt5Pm+6zf8v66N4gLn2bBCTw0xN4qNBNeTPWtkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZN54uXwRdhzlPwn+h4Cj1LajEhok/zF7pnPgo2RDQjun0F1iPWKoJ36d8WgUqi/jmXd2lNpddYVC1+M1ubYapwoGcbxU7NxHO8lDus8YG+uRtYzA7Uh+UYQX2NhDc4uPDSeXBcTCNDjKsKrLtfiDViH1viSrSggsLMz7eXYF9ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OJWhEJiF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715097503;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xq2Tt26O33vj04BePyh0aDanH1v4ZfKL8A+WOD0+H98=;
	b=OJWhEJiF9QQGEGv/he6GVaKG6yDopd7WqDxhHW4Zk4GgrT5dmPJaOMwhU5ybb7TEX0/a0G
	Yx30iP+9C5i8NrC6FiOUoCr5v8GF/AfPZwJiBXFriCgF4KZhK+/OkVmy043OaeDSW2OC4D
	ES2giI8qSZ94MpkyRzM25+Jg7rCXG2Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-237-J7DHvXnxM4SVyF2CRWTz4g-1; Tue, 07 May 2024 11:58:20 -0400
X-MC-Unique: J7DHvXnxM4SVyF2CRWTz4g-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0DE188029EB;
	Tue,  7 May 2024 15:58:20 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DF608492CAA;
	Tue,  7 May 2024 15:58:19 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
	Kai Huang <kai.huang@intel.com>
Subject: [PATCH 11/17] KVM: x86/mmu: Don't force emulation of L2 accesses to non-APIC internal slots
Date: Tue,  7 May 2024 11:58:11 -0400
Message-ID: <20240507155817.3951344-12-pbonzini@redhat.com>
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

Allow mapping KVM's internal memslots used for EPT without unrestricted
guest into L2, i.e. allow mapping the hidden TSS and the identity mapped
page tables into L2.  Unlike the APIC access page, there is no correctness
issue with letting L2 access the "hidden" memory.  Allowing these memslots
to be mapped into L2 fixes a largely theoretical bug where KVM could
incorrectly emulate subsequent _L1_ accesses as MMIO, and also ensures
consistent KVM behavior for L2.

If KVM is using TDP, but L1 is using shadow paging for L2, then routing
through kvm_handle_noslot_fault() will incorrectly cache the gfn as MMIO,
and create an MMIO SPTE.  Creating an MMIO SPTE is ok, but only because
kvm_mmu_page_role.guest_mode ensure KVM uses different roots for L1 vs.
L2.  But vcpu->arch.mmio_gfn will remain valid, and could cause KVM to
incorrectly treat an L1 access to the hidden TSS or identity mapped page
tables as MMIO.

Furthermore, forcing L2 accesses to be treated as "no slot" faults doesn't
actually prevent exposing KVM's internal memslots to L2, it simply forces
KVM to emulate the access.  In most cases, that will trigger MMIO,
amusingly due to filling vcpu->arch.mmio_gfn, but also because
vcpu_is_mmio_gpa() unconditionally treats APIC accesses as MMIO, i.e. APIC
accesses are ok.  But the hidden TSS and identity mapped page tables could
go either way (MMIO or access the private memslot's backing memory).

Alternatively, the inconsistent emulator behavior could be addressed by
forcing MMIO emulation for L2 access to all internal memslots, not just to
the APIC.  But that's arguably less correct than letting L2 access the
hidden TSS and identity mapped page tables, not to mention that it's
*extremely* unlikely anyone cares what KVM does in this case.  From L1's
perspective there is R/W memory at those memslots, the memory just happens
to be initialized with non-zero data.  Making the memory disappear when it
is accessed by L2 is far more magical and arbitrary than the memory
existing in the first place.

The APIC access page is special because KVM _must_ emulate the access to
do the right thing (emulate an APIC access instead of reading/writing the
APIC access page).  And despite what commit 3a2936dedd20 ("kvm: mmu: Don't
expose private memslots to L2") said, it's not just necessary when L1 is
accelerating L2's virtual APIC, it's just as important (likely *more*
imporant for correctness when L1 is passing through its own APIC to L2.

Fixes: 3a2936dedd20 ("kvm: mmu: Don't expose private memslots to L2")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Message-ID: <20240228024147.41573-11-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index ba50b93e93ed..a8e14c2b68a7 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4298,8 +4298,18 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	if (slot && (slot->flags & KVM_MEMSLOT_INVALID))
 		return RET_PF_RETRY;
 
-	if (!kvm_is_visible_memslot(slot)) {
-		/* Don't expose private memslots to L2. */
+	if (slot && slot->id == APIC_ACCESS_PAGE_PRIVATE_MEMSLOT) {
+		/*
+		 * Don't map L1's APIC access page into L2, KVM doesn't support
+		 * using APICv/AVIC to accelerate L2 accesses to L1's APIC,
+		 * i.e. the access needs to be emulated.  Emulating access to
+		 * L1's APIC is also correct if L1 is accelerating L2's own
+		 * virtual APIC, but for some reason L1 also maps _L1's_ APIC
+		 * into L2.  Note, vcpu_is_mmio_gpa() always treats access to
+		 * the APIC as MMIO.  Allow an MMIO SPTE to be created, as KVM
+		 * uses different roots for L1 vs. L2, i.e. there is no danger
+		 * of breaking APICv/AVIC for L1.
+		 */
 		if (is_guest_mode(vcpu)) {
 			fault->slot = NULL;
 			fault->pfn = KVM_PFN_NOSLOT;
@@ -4312,8 +4322,7 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 		 * MMIO SPTE.  That way the cache doesn't need to be purged
 		 * when the AVIC is re-enabled.
 		 */
-		if (slot && slot->id == APIC_ACCESS_PAGE_PRIVATE_MEMSLOT &&
-		    !kvm_apicv_activated(vcpu->kvm))
+		if (!kvm_apicv_activated(vcpu->kvm))
 			return RET_PF_EMULATE;
 	}
 
-- 
2.43.0



