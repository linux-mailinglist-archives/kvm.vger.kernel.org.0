Return-Path: <kvm+bounces-10196-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D776486A6C4
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 03:44:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 06A511C23F68
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 02:44:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D52852C1AE;
	Wed, 28 Feb 2024 02:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JZQPbhn/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E8DC28DC3
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 02:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709088131; cv=none; b=Zp+KlDt/+GKNiXcWHe3Hn36PA83iMdfDlqR8Eo3XzboMnvX4DsUa0XrkZm8eqn6aWvaDBlCwHQ2TEO4HP4QvbI6N949E8m+O/KE8xRSjCirQrDW4cMy9IwSske9LLs906vCEjRScuQiTKHRGOQIOsgxqhSzEFFE5DqWbPZkC7Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709088131; c=relaxed/simple;
	bh=9PNdeAstWFyBPPWEs7KhyiizgXxO3+J35k1TqWTitDo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ISITKsObfneRPu/zvvsvA9rHJPY/NOG0Bt0fye2pPWh2nTB19EhpXb0dahQtmFVdNAMc6QEwhIoDVlYL+kDHkEi8ah0HSm8H9x30U5G6aSmhuxA8dHvqr6l7wckohNQmdOHUeG/QHI9DHUXTv7ssg2Rdw1jzoXDBdY/glBMFIsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JZQPbhn/; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6e5382e18e8so2386325b3a.3
        for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 18:42:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709088129; x=1709692929; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=L6OrO+CyUKUmFb+nQO2BWBH5lLYiXnAmYHqUzxi5l7c=;
        b=JZQPbhn//+Ga12435LtjkrbT5ugjSrcSMCPTXKjZGsoV4QYeR37wszvWluIbpI2aIZ
         XZrJJRUhCZ/FkwzECVje7AnlwZs1EsUqGrUEj6jpRwZQ8At6WFRqTcmLgL3RBNTIjDYM
         F+Nv7LuSfc/dkW77SjR7MelG3ygjAuGHU7ipUYOGGWPpcNlLAMXJK36c15Oqzwg/0UH8
         zR+uGGRr00a2iyq3RN9JZYXGnLRyG9mVFuzhSk7Eq1/nanepIT/Ouqqs6k0WTNFde3yC
         dIou95nF9WtE6J7m2JgQsKRFqTisE542GxbDn3Z8RXJyH+DoACu7M2APE7xGKCF10bYy
         Mu7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709088129; x=1709692929;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L6OrO+CyUKUmFb+nQO2BWBH5lLYiXnAmYHqUzxi5l7c=;
        b=Vt2yt+ZmX3onBGmwQ4yz3Kl0HIq3TNYR8G5Y9U621bTZ8EfrIPltuKKLrtq/tz5BDI
         JLcw5R6LeYrB/XeNE5bO1aBiF2jshm6M/kz6LW9w3sAOpVw099ca5Ts4ZhFiaPvx9uCw
         r4wrDmS0JJnXtQ14oxw2jHvPWd9p+4xYjaTmf0jecc8tDLgyarCmpgqnlYY4td8rlpu7
         5iYor24V3hPnZ/t3rNmGlqUuu2yAl59BQZEg2SNnEkUokIiJFCX4fuIV0C40PxzRmyi2
         JZMD2KcfDN6hhjmv3H4zL/87Uha4/Or/1GxZr2I1Qh1Acz11mJc2iaj2QienEVJHWGCw
         VJjA==
X-Gm-Message-State: AOJu0Yw5WND9UQxhsrgyYyC/GKMj+U5RH3r1gL9vnyRijvCs1CvuyVkK
	46FuwptH4i8TF18yqgHAS0E4W31zCwd9ZIcwt07wbbxjfBPyTC/dLh6hzTFOaiSmH2/Pi9j9dgO
	69A==
X-Google-Smtp-Source: AGHT+IEHUj/do6mCm4DLRIfshMpNYR8umtAxls3inWMMZJ4H/OwZPKN3I4Jwqe17wSm4B2+jtdaIEYQIJPk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:8917:b0:6e4:f310:1fd with SMTP id
 hw23-20020a056a00891700b006e4f31001fdmr362188pfb.4.1709088129052; Tue, 27 Feb
 2024 18:42:09 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 27 Feb 2024 18:41:41 -0800
In-Reply-To: <20240228024147.41573-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240228024147.41573-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240228024147.41573-11-seanjc@google.com>
Subject: [PATCH 10/16] KVM: x86/mmu: Don't force emulation of L2 accesses to
 non-APIC internal slots
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

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
---
 arch/x86/kvm/mmu/mmu.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 58c5ae8be66c..5c8caab64ba2 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4346,8 +4346,18 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
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
@@ -4360,8 +4370,7 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 		 * MMIO SPTE.  That way the cache doesn't need to be purged
 		 * when the AVIC is re-enabled.
 		 */
-		if (slot && slot->id == APIC_ACCESS_PAGE_PRIVATE_MEMSLOT &&
-		    !kvm_apicv_activated(vcpu->kvm))
+		if (!kvm_apicv_activated(vcpu->kvm))
 			return RET_PF_EMULATE;
 	}
 
-- 
2.44.0.278.ge034bb2e1d-goog


