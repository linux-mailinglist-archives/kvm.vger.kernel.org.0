Return-Path: <kvm+bounces-28593-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2547B999A30
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 04:16:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B1AC8B24582
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 02:16:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1768D1FB3FF;
	Fri, 11 Oct 2024 02:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Va1ihGKY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F571FB3EB
	for <kvm@vger.kernel.org>; Fri, 11 Oct 2024 02:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728612689; cv=none; b=SUf8WxXi539hxrsiq88Zzp771SNmkU4mdCoy0q7RoX7nzkWO+5GlbqhWW4RoL2xWmUxQoLjvGcIQFRnTKRDSFeRLmcfA4yX8daXKpzxQccSa56ZbyeHH32kZN0vO5JK99ZJt9YqXcx9l+oQzBx0BWbQ5UDgZvw3Uw3sehy7beMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728612689; c=relaxed/simple;
	bh=Tp2aWz/KUkLgHNMUQeB0T53YK5NkYJtBqImftywh1pg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aCnqArJNa2+xrmGbr33w6Bduhvw82K+D5MAho3r65xh/bFocQTou08xvmVIKyPaSJOlcL+NqvR+xnDi0NnJ+XZHX60+w2VBITAbLUaeAjDYk8Oia/aFYT+QX8J+iQUAPqgB2NJA679JBmcg43IvrTmFmG6x6vlR4NUWWe8uOAR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Va1ihGKY; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6dbbeee08f0so39660697b3.0
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 19:11:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728612687; x=1729217487; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=VgP7ZnqG8N9jdCaiPxtHytdx2vM8g+9dqJnt13kkQQE=;
        b=Va1ihGKY/nVmOINfhOXd8M7aT59KbsX96wpgdbJhNOvasLR7rfi4cXKK897pDwFb9U
         06n2x/k5uhzaF1eHKcISXMkmp3ANm7qFdyOqtzNdf8oosPh+ZvIyi7wp5lOCpnuDYqrx
         EJtcBckCfISE54OIGSKBr5PGTshjngSM9e8ziO4yH5yVBaD8Z8stDD5QiWaOR+jTVvUJ
         T8xpaVusrO/uSap8jQ+Lv6oPyhLNNOCl3kw3zb4lpGBjSxwFRzd+2IJdaa3/Jat6O2Ve
         ATqFKi9KPGR5JmYDOl7qlmyMXf7k0YxYPxWXIgKVRFFkwb0XeeoGduKPTdLlm7gkjp8c
         Ck1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728612687; x=1729217487;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VgP7ZnqG8N9jdCaiPxtHytdx2vM8g+9dqJnt13kkQQE=;
        b=HWmNIXspKAzBfb3/krklcPiBJ5UhBYrbhTy4/JJQaWqaABO19LQDMppneW4FtsfUsN
         qpXaftCSjYTSINhOYjpUDMj92EeaXmAV7ld+QCRmE+5bRMHYYpoLB3E1ru79IuSxHLAA
         fm+zM7XxNNK71EfHhzyedEx4lvr+mqQMKHyM+HXuet7wyAnNmtq/qfULEsLzIwBS7haT
         nTSHGgx16cgFjTsI5IgM5ngV11BxLC4Tw3Nv08tYSQKMjFun1Yr/NhnbWN72FBKndG8O
         P0qy+FeVpP5iuGFVBvBi9u/5JvAh8t2fhAMBhiIKB14O75aH2BfYjnQFc00iUDr3O1xP
         mmRQ==
X-Gm-Message-State: AOJu0YyOzsLwo6Qdu3ZuAyD/fBTAMPMb77Va6CVwn+s34mid+Jx8CYm0
	HFFupYocNKgKDjFAEghlt9lW7oWINjsOcK/2qVxi/cX7lciM6t34qGdmKM9sPJ+woILRdod2wZL
	30Q==
X-Google-Smtp-Source: AGHT+IHfuBbi88SzKZ8fyOpKZIpd/P6uL6w934+Qz4f2IixKQEh8/8BEdcKQO7aaLExUXEvNpT4HwLrwVCw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:b104:0:b0:e29:a86:fd0d with SMTP id
 3f1490d57ef6-e290bb40627mr81586276.5.1728612686619; Thu, 10 Oct 2024 19:11:26
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 19:10:48 -0700
In-Reply-To: <20241011021051.1557902-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241011021051.1557902-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241011021051.1557902-17-seanjc@google.com>
Subject: [PATCH 16/18] KVM: x86/mmu: Set Dirty bit for new SPTEs, even if
 _hardware_ A/D bits are disabled
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Sagi Shahar <sagis@google.com>, 
	"=?UTF-8?q?Alex=20Benn=C3=A9e?=" <alex.bennee@linaro.org>, David Matlack <dmatlack@google.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

When making a SPTE, set the Dirty bit in the SPTE as appropriate, even if
hardware A/D bits are disabled.  Only EPT allows A/D bits to be disabled,
and for EPT, the bits are software-available (ignored by hardware) when
A/D bits are disabled, i.e. it is perfectly legal for KVM to use the Dirty
to track dirty pages in software.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/spte.c | 2 +-
 arch/x86/kvm/mmu/spte.h | 6 ------
 2 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 617479efd127..fd8c3c92ade0 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -237,7 +237,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 			wrprot = true;
 		else
 			spte |= PT_WRITABLE_MASK | shadow_mmu_writable_mask |
-				spte_shadow_dirty_mask(spte);
+				shadow_dirty_mask;
 	}
 
 	if (prefetch && !synchronizing)
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index a404279ba731..e90cc401c168 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -316,12 +316,6 @@ static inline bool spte_ad_need_write_protect(u64 spte)
 	return (spte & SPTE_TDP_AD_MASK) != SPTE_TDP_AD_ENABLED;
 }
 
-static inline u64 spte_shadow_dirty_mask(u64 spte)
-{
-	KVM_MMU_WARN_ON(!is_shadow_present_pte(spte));
-	return spte_ad_enabled(spte) ? shadow_dirty_mask : 0;
-}
-
 static inline bool is_access_track_spte(u64 spte)
 {
 	return !spte_ad_enabled(spte) && (spte & shadow_acc_track_mask) == 0;
-- 
2.47.0.rc1.288.g06298d1525-goog


