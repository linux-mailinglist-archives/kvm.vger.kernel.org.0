Return-Path: <kvm+bounces-10199-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EC0E86A6CA
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 03:45:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C1E4A1C25FE9
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 02:45:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A540E28E2E;
	Wed, 28 Feb 2024 02:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="K3vCi+W9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF57E200BE
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 02:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709088137; cv=none; b=KbeT2qRMdKeL3hGXJacTVHixlGr2tP8RsJLV08NB0eWyLTJwimMMkKDRIVQhncHUJgeH+KKpiywjLQkAi4AreqktZQigYiraXPOyzmQUSxro5jOqu4eMamsH5K7Gjvup295r950P0JprwR9UHHXPEWNko7EeJkcdcd1X9vNlXrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709088137; c=relaxed/simple;
	bh=0gEhOu+NvnccPPQj+DGkgmpKe+mDJdiQ8EYFWVgv6Yg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KqdVeYRoJYJD0T/41Z8PBBi+ORPS3Xpt8IfdzIia3d2z8QZbA1ZXEBSmfYZiwUFqFmZCe/doqSfGESYlLl6L8I5UPIEGeMRQHEnNbZFmyh4UX2WOZ7dY04c+V/tXA7WAB8SZb8AcPkBmlciYADdQfyX1JnI9AmtzuUZ6ZGHKiJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=K3vCi+W9; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6093f75fc81so969307b3.1
        for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 18:42:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709088135; x=1709692935; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=l9B6PZq9lTAwCPQClSfUQyAcFb6buJcOcs8BLLLIFfI=;
        b=K3vCi+W9PP9mOXJVXEgpPk8GWlyWO7FsUI5EGYp9/KHl/81V5sfa2Ccl1HnuFMY4Uv
         CgxYNnEkV5Ky8lF7XRWzuGtVNb1olRoag5MKYejOOy0jy4FTBvf7AA8pyDYIG+Sa/ygg
         9kgq1/g/fFWFBUqHJxX9xnyn5vQ4PEh2VV0Mq4ChxWj2ZrR1jM8c3XHVPgWyMr2jNtz0
         +x4REkioKYUz5hHUmdpwEaNp9JWbQYagqq5uWE/upqWJp3KqhAEJO+IcCpdHKf2pYri8
         xLoc+lxD2m4Htsydv27gwksD+ofGYKndcFQpgHW01YKvE2WIlFX+3zCMhHcr1Thn/RQI
         pGLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709088135; x=1709692935;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l9B6PZq9lTAwCPQClSfUQyAcFb6buJcOcs8BLLLIFfI=;
        b=F0TTAsn0KypmkS7P3nP2yZ53Xl3ld/vrt/xPUKKqMs/gfMkjpBBwH9BuwP4pahL2Zc
         0UUfeYoYuJZBtwK8MCSKxe+nJh0w2Ql2hx96bTIXpL0rX4+wQmJMyrxuVPl3Urjyvod+
         VUuLaSLO4SX2M233OJ5ld/3qkpI3TeI/FTH8QmOa90JJY6wKBgeIO1wkTjxAxpGkWks3
         SsKx4jjRRiKPo4r7j5c9Fd7S7cvEJMElkt0/kTHc5ogdwpgxTFAMLriXvewdLSlLpUEp
         UT6QB3yGzEb9HEzPRbQtR1DLenw3wLlkw8Chv9MhxTfn2nFlD7BxsNVMXC3h10FzwGBy
         I1Hg==
X-Gm-Message-State: AOJu0YypBskBXIzQw3tlAH8c7KXkjeDxcQVBHlj/mfebLijf9pSLOnU4
	kbLL+n1A49vwRkLzLH/p01dNAeZn2rzQs16bthV1D3W0Yh/GWooXv2lYOcD/VbSXIHuz5+u5wrU
	zZA==
X-Google-Smtp-Source: AGHT+IEPzkpN558mdThb1mQJAX8w0FWfivalHkGQsaKz9YUi8JxhkESyegzZmqcp881opi3TCAgG1XKM99s=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:d64e:0:b0:608:d0a4:75ea with SMTP id
 y75-20020a0dd64e000000b00608d0a475eamr905939ywd.7.1709088134972; Tue, 27 Feb
 2024 18:42:14 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 27 Feb 2024 18:41:44 -0800
In-Reply-To: <20240228024147.41573-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240228024147.41573-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240228024147.41573-14-seanjc@google.com>
Subject: [PATCH 13/16] KVM: x86/mmu: Handle no-slot faults at the beginning of kvm_faultin_pfn()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

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
---
 arch/x86/kvm/mmu/mmu.c          | 29 +++++++++++++++++------------
 arch/x86/kvm/mmu/mmu_internal.h |  2 +-
 2 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8aa957f0a717..4dee0999a66e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3322,6 +3322,10 @@ static int kvm_handle_noslot_fault(struct kvm_vcpu *vcpu,
 	vcpu_cache_mmio_info(vcpu, gva, fault->gfn,
 			     access & shadow_mmio_access_mask);
 
+	fault->slot = NULL;
+	fault->pfn = KVM_PFN_NOSLOT;
+	fault->map_writable = false;
+
 	/*
 	 * If MMIO caching is disabled, emulate immediately without
 	 * touching the shadow page tables as attempting to install an
@@ -4393,15 +4397,18 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
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
@@ -4413,12 +4420,9 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
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
@@ -4429,6 +4433,9 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 			return RET_PF_EMULATE;
 	}
 
+	fault->mmu_seq = vcpu->kvm->mmu_invalidate_seq;
+	smp_rmb();
+
 	/*
 	 * Check for a relevant mmu_notifier invalidation event before getting
 	 * the pfn from the primary MMU, and before acquiring mmu_lock.
@@ -4450,19 +4457,17 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
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
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index d7c10d338f14..74736d517e74 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -235,7 +235,7 @@ struct kvm_page_fault {
 	/* The memslot containing gfn. May be NULL. */
 	struct kvm_memory_slot *slot;
 
-	/* Outputs of kvm_faultin_pfn.  */
+	/* Outputs of kvm_faultin_pfn. */
 	unsigned long mmu_seq;
 	kvm_pfn_t pfn;
 	hva_t hva;
-- 
2.44.0.278.ge034bb2e1d-goog


