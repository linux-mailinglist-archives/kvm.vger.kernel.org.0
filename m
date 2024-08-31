Return-Path: <kvm+bounces-25604-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 420FA966D61
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 02:21:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 00541284C3D
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 00:21:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B407015854C;
	Sat, 31 Aug 2024 00:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gqxJs9zS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 754D514E2F6
	for <kvm@vger.kernel.org>; Sat, 31 Aug 2024 00:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725063383; cv=none; b=lGfh9e7i6tR5WMncHQDoBanFXnvpQHh6126N5hT/Wbe5i8mCaH/64k1YII53QmrgcrLarx57sK0g1PTBJWtCTn9i3BSwaJ/9PgAM1ymgmos0GeGXl/qzLiEs2KVAR6zRHUJz9YcOArzX2TGbkzyUdjCEwp19CgGlNmtKWVJIJ90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725063383; c=relaxed/simple;
	bh=jbNYq8nf4cToP9nG3R9NtHXCFO1UUWSTXyZK1MFowyM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Cj6zOwRXcki+iU9tuBcKS5xOn308e0k46jrC7VO9GjfDneazSVt4zvtBVCCHtfbbUIGWgQzdtTATdP5fDKmSU9N8S/L4H+8MJbfREqlw3UUr+dyYnNUEiA9NiPXVvZuqDQyPxKazZmnWbO6eMv/7nK+zQm7TB1WAPFLVzked7sU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gqxJs9zS; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2d88116d768so826418a91.0
        for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 17:16:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725063382; x=1725668182; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=cR1WOtXSuetpHOXK2S+96cMV73XM9Whtcc3KrMXdeXM=;
        b=gqxJs9zS7eFen9ZACMiMMglKRYkC+Xb7ZK7pYkLyKdJTjggbmQvEHqEXPGXI9Nxq41
         IdogRgDcL4iawguzYoGtGTKXVLrvIqW/c8GXBXgLxgecgUmmGQYociWuQDHLL6CebDle
         P3FZhsPvFOyLbtb+CoyYSP1zdWTZ4k+bF0bzf7Kx6Kwix8t2eSd9xD1XRlup0fsrdcju
         SzBaE9maQ65q7Fc06D6/GP2fxGzJDePck5H/kNgLrT+n48Ju5OBy3QgW5GCztmx1ansu
         IQjrxRvH6WvaIwSO51tzHxZ8jy37nGqXSXVyGY/y9S6K80UjVL58lPrr0AuO6KaREsLo
         VTHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725063382; x=1725668182;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cR1WOtXSuetpHOXK2S+96cMV73XM9Whtcc3KrMXdeXM=;
        b=AevP8ggLGhINB2giIh60Tv9RUuL5E4+ww+00hKvvOpFMDFuoDmJCEwJX3CmIXfN4r4
         BBXUz14b9SCym/MfZDkmXrGGAid9G/a4fCXCa2XfpgsepI1mAR6kEP+9JSDFx/rVGbll
         tJBQhdEmAtxmVQpwIwLVJt2xXjjI8XkgG3clRdUghZuc6yQyZ6SYQhIvbLBM1/CZCFOq
         PZBJupQ9lSDLF6VGKRsprVsv3UA7cf2s3eGLkQ/EYLniB5YPqricj5knftgvfkdv/wKE
         JUwb8PNclI3UNYJYGkCtMsvF9O6KVEozC7PpeB5AAOCQwCuc3ad/Wu/nkWWMxuNJgc7C
         VFKw==
X-Gm-Message-State: AOJu0YzViYIUdg39ROlF0siYkU7TIETzG/fs53gHGgwn2yeIN5ymw2hh
	E8rEoxTLII1S2QNRDWjSvh2n3i7knkT4vtoXW5d/Mb0NWSnE5rxwm02jxkE1ZktQYLbds6x88x1
	4DA==
X-Google-Smtp-Source: AGHT+IGfs7gXN6qWH4tGlZzsztZguerRTLfMi+oiBPqhIYFJkNIRpCAXsHN1MLCUuyCoUdzMs9CiDW0dVcI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:bc85:b0:2d8:94d4:5845 with SMTP id
 98e67ed59e1d1-2d894d4658amr1195a91.0.1725063381728; Fri, 30 Aug 2024 17:16:21
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 30 Aug 2024 17:15:35 -0700
In-Reply-To: <20240831001538.336683-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240831001538.336683-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <20240831001538.336683-21-seanjc@google.com>
Subject: [PATCH v2 20/22] KVM: x86/mmu: Subsume kvm_mmu_unprotect_page() into
 the and_retry() version
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yuan Yao <yuan.yao@intel.com>, Yuan Yao <yuan.yao@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Fold kvm_mmu_unprotect_page() into kvm_mmu_unprotect_gfn_and_retry() now
that all other direct usage is gone.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  1 -
 arch/x86/kvm/mmu/mmu.c          | 33 +++++++++++++--------------------
 2 files changed, 13 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4aa10db97f6f..0fbde3ca8d1a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2134,7 +2134,6 @@ int kvm_get_nr_pending_nmis(struct kvm_vcpu *vcpu);
 
 void kvm_update_dr7(struct kvm_vcpu *vcpu);
 
-int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn);
 bool __kvm_mmu_unprotect_gfn_and_retry(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 				       bool always_retry);
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index aabed77f35d4..d042874b0a3b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2695,27 +2695,12 @@ void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned long goal_nr_mmu_pages)
 	write_unlock(&kvm->mmu_lock);
 }
 
-int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn)
-{
-	struct kvm_mmu_page *sp;
-	LIST_HEAD(invalid_list);
-	int r;
-
-	r = 0;
-	write_lock(&kvm->mmu_lock);
-	for_each_gfn_valid_sp_with_gptes(kvm, sp, gfn) {
-		r = 1;
-		kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
-	}
-	kvm_mmu_commit_zap_page(kvm, &invalid_list);
-	write_unlock(&kvm->mmu_lock);
-
-	return r;
-}
-
 bool __kvm_mmu_unprotect_gfn_and_retry(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 				       bool always_retry)
 {
+	struct kvm *kvm = vcpu->kvm;
+	LIST_HEAD(invalid_list);
+	struct kvm_mmu_page *sp;
 	gpa_t gpa = cr2_or_gpa;
 	bool r = false;
 
@@ -2727,7 +2712,7 @@ bool __kvm_mmu_unprotect_gfn_and_retry(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	 * positive is benign, and a false negative will simply result in KVM
 	 * skipping the unprotect+retry path, which is also an optimization.
 	 */
-	if (!READ_ONCE(vcpu->kvm->arch.indirect_shadow_pages))
+	if (!READ_ONCE(kvm->arch.indirect_shadow_pages))
 		goto out;
 
 	if (!vcpu->arch.mmu->root_role.direct) {
@@ -2736,7 +2721,15 @@ bool __kvm_mmu_unprotect_gfn_and_retry(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 			goto out;
 	}
 
-	r = kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa));
+	r = false;
+	write_lock(&kvm->mmu_lock);
+	for_each_gfn_valid_sp_with_gptes(kvm, sp, gpa_to_gfn(gpa)) {
+		r = true;
+		kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
+	}
+	kvm_mmu_commit_zap_page(kvm, &invalid_list);
+	write_unlock(&kvm->mmu_lock);
+
 out:
 	if (r || always_retry) {
 		vcpu->arch.last_retry_eip = kvm_rip_read(vcpu);
-- 
2.46.0.469.g59c65b2a67-goog


