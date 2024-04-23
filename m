Return-Path: <kvm+bounces-15729-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 950A88AFB9D
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 00:16:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C769A1C21F1A
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 22:16:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2DD3144D36;
	Tue, 23 Apr 2024 22:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FkA08b1r"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 633621448D9
	for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 22:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713910532; cv=none; b=S86De5eOf5JpAn+xwu3h+3asUIqX464DE+0UhnvjEMOiV76j9wo7rK9DjM65ynhIVmJ7h1jhVoORN64cr+Lpho1ormEDuwte0v4zxAxKn9M2b660MZJJdo2G41Fqmi2ZzfEUo/jGV5jUpBDRxQLIFM4NLFvg8yKBaT3vd2lsoHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713910532; c=relaxed/simple;
	bh=xE1KUFK4G+p/d3CyfBOgMCJHlIiny9RJ4lxmT/9Dm04=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=W80CRn0IiKycSZ0oqvL2ZCKrQ0YdCv0sS6cJKRqX0H7RQ8sIQdEUOBSsOw9f5ryHhHt3fIPChpyMuqtDcR3dzh8KXkw+aXBuRwYy72tsQntWRLYvEMExU+9y8PxZPLaSnnsSbHlpETUhw0YKnFTl5Ipxahv/tRNzKTxSPN6v6xM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FkA08b1r; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-de463fb34c9so11963566276.3
        for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 15:15:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713910530; x=1714515330; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=925/3TcbmBk8/dgvobnmcuIGRsrdaR6MRTRxQEFXUJk=;
        b=FkA08b1rtaw1mLOXxakIBnKEdlGtW4Zrn9fbVGt97lrntoEGBMRj8ZdMCyhYe+m2H2
         LgVtVOhvmd1wUHIrVw+WtH10m4oV8Idm914gUIeLsGfn8/FlBpmVX561ZfqF9P4tHcLO
         IfKW12JdEqsqqNFDSghsVNHEa/Ubtu6sD2AqDfie/lBe+b5U1NUnRLdkcgV3bfQzl2op
         GtkJi4H1MDyymGw+z3OCzzjPzGLAkskBayBSC/G++qV7bwKXfzExHbK+anYUPnqjuzic
         cw8bufB0UFgYfawnOteQ8VogZWe9bkm6VZvLV1pHRDRcfRXUlFZLfpCGMbSSeD5GziXX
         ijwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713910530; x=1714515330;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=925/3TcbmBk8/dgvobnmcuIGRsrdaR6MRTRxQEFXUJk=;
        b=I0IvGvxupCpm2Wog1L8SrKkiJUypes+I9YCWG+GW+ljb6xm85YNr8XXot53xGlDxED
         8ZCg1/xWPlnyMNgxi+3hFAbBbWrYk6yK8VobAYG+tX7OEiJ1dKQCOYBaLa+tWl/BEMsL
         fnvdJeZqNKnwLHJjBSKy3YZHr+rTQZmVxscfpiRPeUMzFk3IjJt43R5+TQwGIOw16cAl
         ioplcWVhBFRnqWknCzWcjh/WsfA4bEjAzXbLugPaWd0ywTAt9QaDfgj3yzKUeRmk8izB
         qDfc2ffAYPrgtyrp17vMFaHsdN51Fa+CmUN4WmvB6hSRp7sqkKAAZ4XUwo/FFinveiTn
         a6vQ==
X-Gm-Message-State: AOJu0Yx1h+8DuRGxM9mbhZEuLgAS7sMGx/fNoI416J3Fzkv9KsOuTL4M
	R+jXFHQCpoE9cuKCiv5LYfoiWaKuMo7HOw9rZMWr69CQu831CYBPJtI0fSVX/kLmDYa1OvJXodg
	PYA==
X-Google-Smtp-Source: AGHT+IFX0P+LbQNZxR5CLCQuMpKsdOUSE0MG1uSUj4yZFqITsFafOfA4cmVbD+WTu75aActV8Bz4bt1CoZc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1027:b0:de0:ecc6:4681 with SMTP id
 x7-20020a056902102700b00de0ecc64681mr100790ybt.1.1713910530470; Tue, 23 Apr
 2024 15:15:30 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 23 Apr 2024 15:15:20 -0700
In-Reply-To: <20240423221521.2923759-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240423221521.2923759-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240423221521.2923759-4-seanjc@google.com>
Subject: [PATCH 3/4] KVM: x86/mmu: Snapshot shadow_phys_bits when kvm.ko is loaded
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Snapshot shadow_phys_bits when kvm.ko is loaded, not when a vendor module
is loaded, to guard against usage of shadow_phys_bits before it is
initialized.  The computation isn't vendor specific in any way, i.e. there
there is no reason to wait to snapshot the value until a vendor module is
loaded, nor is there any reason to recompute the value every time a vendor
module is loaded.

Opportunistically convert it from "read mostly" to "read-only after init".

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu.h      | 2 +-
 arch/x86/kvm/mmu/spte.c | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index b410a227c601..ef970aea26e7 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -61,7 +61,7 @@ static __always_inline u64 rsvd_bits(int s, int e)
  * The number of non-reserved physical address bits irrespective of features
  * that repurpose legal bits, e.g. MKTME.
  */
-extern u8 __read_mostly shadow_phys_bits;
+extern u8 __ro_after_init shadow_phys_bits;
 
 static inline gfn_t kvm_mmu_max_gfn(void)
 {
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 6c7ab3aa6aa7..927f4abbe973 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -43,7 +43,7 @@ u64 __read_mostly shadow_acc_track_mask;
 u64 __read_mostly shadow_nonpresent_or_rsvd_mask;
 u64 __read_mostly shadow_nonpresent_or_rsvd_lower_gfn_mask;
 
-u8 __read_mostly shadow_phys_bits;
+u8 __ro_after_init shadow_phys_bits;
 
 void __init kvm_mmu_spte_module_init(void)
 {
@@ -55,6 +55,8 @@ void __init kvm_mmu_spte_module_init(void)
 	 * will change when the vendor module is (re)loaded.
 	 */
 	allow_mmio_caching = enable_mmio_caching;
+
+	shadow_phys_bits = kvm_get_shadow_phys_bits();
 }
 
 static u64 generation_mmio_spte_mask(u64 gen)
@@ -439,8 +441,6 @@ void kvm_mmu_reset_all_pte_masks(void)
 	u8 low_phys_bits;
 	u64 mask;
 
-	shadow_phys_bits = kvm_get_shadow_phys_bits();
-
 	/*
 	 * If the CPU has 46 or less physical address bits, then set an
 	 * appropriate mask to guard against L1TF attacks. Otherwise, it is
-- 
2.44.0.769.g3c40516874-goog


