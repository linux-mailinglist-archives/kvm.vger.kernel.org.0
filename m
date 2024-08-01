Return-Path: <kvm+bounces-22984-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 07F8F9452CA
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 20:36:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8D0E8282981
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 18:36:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50FDD14B979;
	Thu,  1 Aug 2024 18:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="C7tdv47U"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E15DF14AD32
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 18:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722537306; cv=none; b=T5ZxW+AAhGI8/f9Jtz3Gy3dTsQks3qsLdmEOZU9n1l+mWGpIUOvuOb8niuxfHubcP3SYeSJ2F5DrCWicej/BQh268QM1Rd7pp8wPwwiABQCnyk8ALQVHJ1Kg7d1ZFC+rao8k99k4Kw+D/ZwDG8KXPyEYvjvwy789ZigXX1mgWMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722537306; c=relaxed/simple;
	bh=AFPTyvXyadKJHf2QzotKTohG8D5ttOVVpldlFI2PF/8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SggkFADCQHio5qD9QkTmXt+NLkedP+DFIdw7ff61reZFAbsixYRADt1XeyiBgIuSlYlsrXOopRKfMmM8fDp1TKNcq3P4osIA9y+1zXHWjd+JtPKr8gHp/8W9zH9ha6HkW/xc9ACo6pO+UTICLwZloEGCo/JeCIpmFpzNg+srdZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=C7tdv47U; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e03623b24ddso10619397276.1
        for <kvm@vger.kernel.org>; Thu, 01 Aug 2024 11:35:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722537304; x=1723142104; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=3iPJtAYuasIIRGf+GbxPHB6qYRb6caAhSB2/PDr0qIc=;
        b=C7tdv47URhonZ+WxIGRenpMDCXavAWGZS2cD2LJ1vVBzYKxwrDTJeULd6p4pt26iGD
         jEnLYrUgL+4qKG7R+ssYR6RwTVbXN9WAHW8n5IFqLrQpeLotqioICzTPrHOzBdXCkMgF
         0s45KB1ZjtEezrkU98nMIJ17jXGjGODUQXPX2cYQiN/xI3yCgAOQTIqyUZ/yyJssJOp4
         2pUvNcMqjQittJ44Z26466+qHpvtLxrkWTMH27jKiA4E7xswA7XXj0CBNonKLbKjqDZx
         Id4obGNAHSM73X7GbPTbkZiFulvePz9lfdPc1Qy7VZ2iVhXslYGZOkz82b6wbuuTepwr
         9/Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722537304; x=1723142104;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3iPJtAYuasIIRGf+GbxPHB6qYRb6caAhSB2/PDr0qIc=;
        b=qdVkGwGhQm10Inb3v7YDaZoKS6Dvubu6QiGkwPorPILPahCeSPEQj/fBbWVI74x/aN
         BSbRZdRe9t0IEeUL9FeENRJTrCiGgU03fpAsa7J+Ovf1QBjIyHFl5EO4iwb1mYIC2evn
         0F54U7EqLXytIOyi2pyNmfvOVuK+xcFdDoDQVVTZo0u9uOmPYZHPBWmqs6NTtMinVxZt
         vMo3ARXVBsaQgTMtpIX6aifVj+rRZV5iu1UkOzzUmIMlrtGxim2f73UMmqr/uvlGp7eA
         lmzZPg2mGGR62JNKVMSAmmV8DsWjhpE/Gg75kbRGOZ0SA9BwecPsEtm/Aky/1gVGbZhR
         ovXQ==
X-Gm-Message-State: AOJu0Yx37CbMM9SH7D9wEirdkbwTF8O4v9kakXMdNO+XjX22K70Ebcka
	MhSrqvGGqqsUjVXEXxbWbUlF0Tp+2H5ctgkBMxZLyOBUJ/TV/xmE4ktFbNac4VaNk1+Y26U2BY4
	C7Q==
X-Google-Smtp-Source: AGHT+IEPP91NM9n4/Te5UnC7Xo0l/Vq7qcp/6WQ3dD16sls4NkylR/VCD/51Fsi8RHqYZr1QyafatST0IEY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2605:b0:e0b:bd79:307b with SMTP id
 3f1490d57ef6-e0bde439c87mr43504276.9.1722537303997; Thu, 01 Aug 2024 11:35:03
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  1 Aug 2024 11:34:48 -0700
In-Reply-To: <20240801183453.57199-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801183453.57199-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240801183453.57199-5-seanjc@google.com>
Subject: [RFC PATCH 4/9] KVM: x86/mmu: Use Accessed bit even when _hardware_
 A/D bits are disabled
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Use the Accessed bit in SPTEs even when A/D bits are disabled in hardware,
i.e. propagate accessed information to SPTE.Accessed even when KVM is
doing manual tracking by making SPTEs not-present.  In addition to
eliminating a small amount of code in is_accessed_spte(), this also paves
the way for preserving Accessed information when a SPTE is zapped in
response to a mmu_notifier PROTECTION event, e.g. if a SPTE is zapped
because NUMA balancing kicks in.

Note, EPT is the only flavor of paging in which A/D bits are conditionally
enabled, and the Accessed (and Dirty) bit is software-available when A/D
bits are disabled.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c  |  6 ++++--
 arch/x86/kvm/mmu/spte.c |  6 +++---
 arch/x86/kvm/mmu/spte.h | 11 +----------
 3 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1e24bc4a06db..c8fc59fcc8e0 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3454,8 +3454,10 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		 * uses A/D bits for non-nested MMUs.  Thus, if A/D bits are
 		 * enabled, the SPTE can't be an access-tracked SPTE.
 		 */
-		if (unlikely(!kvm_ad_enabled) && is_access_track_spte(spte))
-			new_spte = restore_acc_track_spte(new_spte);
+		if (unlikely(!kvm_ad_enabled) && is_access_track_spte(spte)) {
+			new_spte = restore_acc_track_spte(new_spte) |
+				   shadow_accessed_mask;
+		}
 
 		/*
 		 * To keep things simple, only SPTEs that are MMU-writable can
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index a0ff504f1e7e..ca1a8116de34 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -181,7 +181,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 
 	spte |= shadow_present_mask;
 	if (!prefetch)
-		spte |= spte_shadow_accessed_mask(spte);
+		spte |= shadow_accessed_mask;
 
 	/*
 	 * For simplicity, enforce the NX huge page mitigation even if not
@@ -258,7 +258,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	}
 
 	if (pte_access & ACC_WRITE_MASK)
-		spte |= spte_shadow_dirty_mask(spte);
+		spte |= shadow_accessed_mask;
 
 out:
 	if (prefetch)
@@ -367,7 +367,7 @@ u64 mark_spte_for_access_track(u64 spte)
 
 	spte |= (spte & SHADOW_ACC_TRACK_SAVED_BITS_MASK) <<
 		SHADOW_ACC_TRACK_SAVED_BITS_SHIFT;
-	spte &= ~shadow_acc_track_mask;
+	spte &= ~(shadow_acc_track_mask | shadow_accessed_mask);
 
 	return spte;
 }
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index d722b37b7434..ba7ff1dfbeb2 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -316,12 +316,6 @@ static inline bool spte_ad_need_write_protect(u64 spte)
 	return (spte & SPTE_TDP_AD_MASK) != SPTE_TDP_AD_ENABLED;
 }
 
-static inline u64 spte_shadow_accessed_mask(u64 spte)
-{
-	KVM_MMU_WARN_ON(!is_shadow_present_pte(spte));
-	return spte_ad_enabled(spte) ? shadow_accessed_mask : 0;
-}
-
 static inline u64 spte_shadow_dirty_mask(u64 spte)
 {
 	KVM_MMU_WARN_ON(!is_shadow_present_pte(spte));
@@ -355,10 +349,7 @@ static inline kvm_pfn_t spte_to_pfn(u64 pte)
 
 static inline bool is_accessed_spte(u64 spte)
 {
-	u64 accessed_mask = spte_shadow_accessed_mask(spte);
-
-	return accessed_mask ? spte & accessed_mask
-			     : !is_access_track_spte(spte);
+	return spte & shadow_accessed_mask;
 }
 
 static inline bool is_dirty_spte(u64 spte)
-- 
2.46.0.rc1.232.g9752f9e123-goog


