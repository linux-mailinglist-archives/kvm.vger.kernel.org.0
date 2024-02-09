Return-Path: <kvm+bounces-8507-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 967A684FFF2
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 23:30:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A4F421C249A1
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 22:30:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D88DE39FCE;
	Fri,  9 Feb 2024 22:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HiTvF/wM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AAA03987B
	for <kvm@vger.kernel.org>; Fri,  9 Feb 2024 22:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707517751; cv=none; b=pkS7/SQOdJ5Zm5YlTh65NlsSmDBsMi5tPWgIrz6KpGSthA+fHdM1/5vOm+9axTBq0V2gNWpi5myS9xRQ5SG0BvdtsSoyW05ylSretp8TrhYsbFIKEjbCLAF1Z7Kl0gdaXBvgkl4pPDX4MMR/gbTJ5illvuNspnnNLYENZCEooXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707517751; c=relaxed/simple;
	bh=+BzY1mPGL9nhkNO3V2zfL1PyIK23e4DvUb11rip84d4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LKgEpOEPTt94E9C62WgFGjaaEzH/R2ZIXUdrHwmaJdZXeIMPrttCFuEXdGq4+saX+V3D5V/djHDn7EC/U5gYzfUktwAar1t8d5aOBLKDQc+UJVHBIw8RkDORNcGZa70nXdI+SuE7jhf6Nou5rDjv56z/4K5+uwWWNWiEbWlL+fU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HiTvF/wM; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc743cc50a6so2048618276.2
        for <kvm@vger.kernel.org>; Fri, 09 Feb 2024 14:29:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707517748; x=1708122548; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=kAg+9jSv1tP63SQt0oBxMImkHQpyEVjvNJmbkD/YeDg=;
        b=HiTvF/wMJ7P5PXvGFeh5182hDQYnTMPqu2XnC/kbD2H2h+fKT0vWquTL7mMH+Hv7Uy
         d3nTW7ykXxCEd6dVYvm1DFF66h8CUFbM+UIIEQCnXwlzb2+lmT1l6MSCx7dDufCbWL5t
         IPMuAMQpeh5hfiMbCSYqK2DEEMnbb0cVrlvX9p88pMNAQhuYNH+bcVuzDsw5Tl2BbG7Z
         VhwA3g2labHdtmAn/IqpYPKjPzKf4KhBaW2IswfRxXhP0v3tp6oRU+5/fgEdQxG+c6b9
         lb2xoNE4lQmwSp+esObWSP7p8xMkdQr+NJM4s0iTVv8NO80bWYKM+n+19N4QzP8ZLoA7
         eitA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707517748; x=1708122548;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kAg+9jSv1tP63SQt0oBxMImkHQpyEVjvNJmbkD/YeDg=;
        b=itdbBDqvHxwvLduGNoRf3FPybsBSoOFzliqdMlfrWFaf5/ZUOmlF/gwUilSXeVzAHN
         DDtl6nehtHiogdomHfIaBHhhdOQ1is8ojNTArLyLA5RdTFQ8u4gAA/mPO2bfS88MoMCn
         hjB0MgakZs24Wej2RajnYj1JVpil77wtaJ1keu87kDlxmeGFj41JVWPLd8kz0Juewxk7
         Z5agR2Py/+VoFoH/abFQzoxLkfWdmA2ACpC9MyEIAw3a71RBLbiZCE5NyQmeItwx7xO9
         l1F/AOKF9nrgfmSWvZH0539wpZqMbX8mFF+7xSNgH1/OUxB5b2sayC4fvK5stxFr4JVv
         DF5g==
X-Gm-Message-State: AOJu0YwYctGSmygn7okNooMZPU5OEsI582tiOa0JNZSY3mvvhy+mjwyA
	mg3Em/nLHHwbGcgMMB/hSynnZEUyrslPQM+Kg2UE9AV6rotb9LAGgDbBH17IFvJtt/FygJaCN88
	qBQ==
X-Google-Smtp-Source: AGHT+IFOx1fyJpguwH0rOayekQLXVRWsIIxJy0ZzhL6eJHbncGhAhhXwZ33rmybP0dmqo+Vp4BOITKePg60=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1b8a:b0:dc6:4bf5:5a74 with SMTP id
 ei10-20020a0569021b8a00b00dc64bf55a74mr20696ybb.11.1707517748503; Fri, 09 Feb
 2024 14:29:08 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  9 Feb 2024 14:28:58 -0800
In-Reply-To: <20240209222858.396696-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240209222858.396696-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.687.g38aa6559b0-goog
Message-ID: <20240209222858.396696-5-seanjc@google.com>
Subject: [PATCH v4 4/4] KVM: x86/mmu: Handle no-slot faults at the beginning
 of kvm_faultin_pfn()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Friedrich Weber <f.weber@proxmox.com>, 
	Kai Huang <kai.huang@intel.com>, Yuan Yao <yuan.yao@linux.intel.com>, 
	Xu Yilun <yilun.xu@linux.intel.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, 
	Michael Roth <michael.roth@amd.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Handle the "no memslot" case at the beginning of kvm_faultin_pfn(), just
after the private versus shared check, so that there's no need to
repeatedly query whether or not a slot exists.  This also makes it more
obvious that, except for private vs. shared attributes, the process of
faulting in a pfn simply doesn't apply to gfns without a slot.

Cc: David Matlack <dmatlack@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 33 ++++++++++++++++++---------------
 arch/x86/kvm/mmu/mmu_internal.h |  5 ++++-
 2 files changed, 22 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 505fc7eef533..7a2874756b3f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3278,6 +3278,14 @@ static int direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	return ret;
 }
 
+static void kvm_mmu_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
+					      struct kvm_page_fault *fault)
+{
+	kvm_prepare_memory_fault_exit(vcpu, fault->gfn << PAGE_SHIFT,
+				      PAGE_SIZE, fault->write, fault->exec,
+				      fault->is_private);
+}
+
 static void kvm_send_hwpoison_signal(struct kvm_memory_slot *slot, gfn_t gfn)
 {
 	unsigned long hva = gfn_to_hva_memslot(slot, gfn);
@@ -3314,9 +3322,16 @@ static int kvm_handle_noslot_fault(struct kvm_vcpu *vcpu,
 {
 	gva_t gva = fault->is_tdp ? 0 : fault->addr;
 
+	if (fault->is_private) {
+		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
+		return -EFAULT;
+	}
+
 	vcpu_cache_mmio_info(vcpu, gva, fault->gfn,
 			     access & shadow_mmio_access_mask);
 
+	fault->pfn = KVM_PFN_NOSLOT;
+
 	/*
 	 * If MMIO caching is disabled, emulate immediately without
 	 * touching the shadow page tables as attempting to install an
@@ -4296,14 +4311,6 @@ static inline u8 kvm_max_level_for_order(int order)
 	return PG_LEVEL_4K;
 }
 
-static void kvm_mmu_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
-					      struct kvm_page_fault *fault)
-{
-	kvm_prepare_memory_fault_exit(vcpu, fault->gfn << PAGE_SHIFT,
-				      PAGE_SIZE, fault->write, fault->exec,
-				      fault->is_private);
-}
-
 static int kvm_faultin_pfn_private(struct kvm_vcpu *vcpu,
 				   struct kvm_page_fault *fault)
 {
@@ -4376,12 +4383,12 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 		return -EFAULT;
 	}
 
+	if (unlikely(!slot))
+		return kvm_handle_noslot_fault(vcpu, fault, access);
+
 	fault->mmu_seq = vcpu->kvm->mmu_invalidate_seq;
 	smp_rmb();
 
-	if (!slot)
-		goto faultin_pfn;
-
 	/*
 	 * Retry the page fault if the gfn hit a memslot that is being deleted
 	 * or moved.  This ensures any existing SPTEs for the old memslot will
@@ -4434,7 +4441,6 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 	if (mmu_invalidate_retry_gfn_unsafe(vcpu->kvm, fault->mmu_seq, fault->gfn))
 		return RET_PF_RETRY;
 
-faultin_pfn:
 	ret = __kvm_faultin_pfn(vcpu, fault);
 	if (ret != RET_PF_CONTINUE)
 		return ret;
@@ -4442,9 +4448,6 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 	if (unlikely(is_error_pfn(fault->pfn)))
 		return kvm_handle_error_pfn(vcpu, fault);
 
-	if (unlikely(!slot))
-		return kvm_handle_noslot_fault(vcpu, fault, access);
-
 	/*
 	 * Check again for a relevant mmu_notifier invalidation event purely to
 	 * avoid contending mmu_lock.  Most invalidations will be detected by
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 0669a8a668ca..bd7d07e6c697 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -235,7 +235,10 @@ struct kvm_page_fault {
 	/* The memslot containing gfn. May be NULL. */
 	struct kvm_memory_slot *slot;
 
-	/* Outputs of kvm_faultin_pfn.  */
+	/*
+	 * Outputs of kvm_faultin_pfn, guaranteed to be valid if and only if
+	 * slot is non-NULL.
+	 */
 	unsigned long mmu_seq;
 	kvm_pfn_t pfn;
 	hva_t hva;
-- 
2.43.0.687.g38aa6559b0-goog


