Return-Path: <kvm+bounces-28584-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 63E20999A1D
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 04:13:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B95D52816EB
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 02:13:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 292A21F8933;
	Fri, 11 Oct 2024 02:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="r+DkhD1N"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59F91E909F
	for <kvm@vger.kernel.org>; Fri, 11 Oct 2024 02:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728612669; cv=none; b=VWotNpE2dzGIy5m1ybqmJT1sU+obKdHUMm0EUz3CFDCDQG2MI6qaTnKy9WIzQ1+SwuPFH63WLSU9m8/JKRd9tr8Z1EM1m5NE80L+LIuxHuL5KADcp3Mdi020E17Z8dC3zstEHU6vdjmZAVsrtEriNc6s26zQOjlxfqpQv4EafXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728612669; c=relaxed/simple;
	bh=7T0Y7z9DkiR+xsRM8ZPFp3xmx4pcPJcLvaBoxa7kVSw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Kw6BTG45CQDZQXw8EhjWSQhewVw5HtcbtOppYMTG5cNZQ6LyXjDWtZwk6ZCNG836rXujWMfahFOpsL76FocXPySb5I9FO2Ym2tkasEzxzM+iiUSDQ7IKLXhr1yYStmbTJ3S0jS3ulHlBKBUHau51PTJNlWM0I6sZlCbEwtZQy8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=r+DkhD1N; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e28b624bfcso25178507b3.2
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 19:11:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728612667; x=1729217467; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=3KbU21e26mgdFp4CthOOUh3jNyHnk8sJBVf29vXTz6Y=;
        b=r+DkhD1NPgjOLAefP8T58ISsLXSVejyB9xxByT5DmBSi3HmGISaYOt3XQd2m/FUDeb
         FLTS07c4HXbcIEbnocyjxtaHwvbpYrmy/gwQI++Si9pvcBkqeottU1XfvLUHoaxZp1nt
         7LUsnftC7NSHS8WtxS+GeNF4qeAFaoISnECX5EW/UwcsIfEnTsMifMPPAatfHdL8yoyI
         YvYD1BULBgj6cGkpXlWtnr4XmYYZLhFji9i/31Cx4Ogy437n/4YbgZtUEvFHOYJExfdu
         bBa/R3NinaHi6DC2ohRVbPk/bktfMKj+o0JJtcDXAvi9PBuIlr/r5WDS1BohuFleTv0x
         7u+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728612667; x=1729217467;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3KbU21e26mgdFp4CthOOUh3jNyHnk8sJBVf29vXTz6Y=;
        b=jMMbIZcPS0xikOQuhmIc+6fOoioX5ovs+tU8SrFNEVJi5aelsrYIVNMffnOOr+MD+Z
         L9C5Wu877v5UmPQfua0JVSAiqdHh/1oHwo74hjzGN0H3Qb1+8GfDPwpCGFCYS8aNGmtN
         7BlOx1+aGNUviSpZu1UZvcvJLrqNd+wIjzrpiJFXZ2Jv5SYHkeXXOlLhtHpy3062vN0a
         S6ps+Q09bUKcN+kIy5wsqOiCRsYoQxteeOen78sh0kHefPHj8aysZ54FESTF228SyDgT
         03VRK0nXuRrdzdt1tJC3vTl8k1NK/CKTXxSivPjxssu+GHK9wmwEwcaK/9SheaTTcrYQ
         lCdg==
X-Gm-Message-State: AOJu0Yz2BPEwqXLmGRwMymL54ps8Z7TutewZz/MQVDogdynxjMuLLMMi
	VvvVL5+2hO5Su6KD1Wp8tsMu5XBgdRVAH61ucCzMPPgy7IWlSUGhLFNYBPQ/s+rgMFV8NsnuTwM
	BuA==
X-Google-Smtp-Source: AGHT+IExWa1Vf1fg4dGiNvdf7Xh8WjS5MlhdfzJm0txAXEjRaSgTANl34PRIe8HLwi1sfR/J7GW5EZ4hKo0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:5f50:0:b0:e28:f2a5:f1d with SMTP id
 3f1490d57ef6-e2919d9e584mr1371276.4.1728612666726; Thu, 10 Oct 2024 19:11:06
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 19:10:39 -0700
In-Reply-To: <20241011021051.1557902-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241011021051.1557902-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241011021051.1557902-8-seanjc@google.com>
Subject: [PATCH 07/18] KVM: x86/mmu: Fold mmu_spte_update_no_track() into mmu_spte_update()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Sagi Shahar <sagis@google.com>, 
	"=?UTF-8?q?Alex=20Benn=C3=A9e?=" <alex.bennee@linaro.org>, David Matlack <dmatlack@google.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Fold the guts of mmu_spte_update_no_track() into mmu_spte_update() now
that the latter doesn't flush when clearing A/D bits, i.e. now that there
is no need to explicitly avoid TLB flushes when aging SPTEs.

Opportunistically WARN if mmu_spte_update() requests a TLB flush when
aging SPTEs, as aging should never modify a SPTE in such a way that KVM
thinks a TLB flush is needed.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 50 ++++++++++++++++++------------------------
 1 file changed, 21 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index faa524d5a0e8..a72ecac63e07 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -485,32 +485,6 @@ static void mmu_spte_set(u64 *sptep, u64 new_spte)
 	__set_spte(sptep, new_spte);
 }
 
-/*
- * Update the SPTE (excluding the PFN), but do not track changes in its
- * accessed/dirty status.
- */
-static u64 mmu_spte_update_no_track(u64 *sptep, u64 new_spte)
-{
-	u64 old_spte = *sptep;
-
-	WARN_ON_ONCE(!is_shadow_present_pte(new_spte));
-	check_spte_writable_invariants(new_spte);
-
-	if (!is_shadow_present_pte(old_spte)) {
-		mmu_spte_set(sptep, new_spte);
-		return old_spte;
-	}
-
-	if (!spte_has_volatile_bits(old_spte))
-		__update_clear_spte_fast(sptep, new_spte);
-	else
-		old_spte = __update_clear_spte_slow(sptep, new_spte);
-
-	WARN_ON_ONCE(spte_to_pfn(old_spte) != spte_to_pfn(new_spte));
-
-	return old_spte;
-}
-
 /* Rules for using mmu_spte_update:
  * Update the state bits, it means the mapped pfn is not changed.
  *
@@ -535,10 +509,23 @@ static u64 mmu_spte_update_no_track(u64 *sptep, u64 new_spte)
  */
 static bool mmu_spte_update(u64 *sptep, u64 new_spte)
 {
-	u64 old_spte = mmu_spte_update_no_track(sptep, new_spte);
+	u64 old_spte = *sptep;
 
-	if (!is_shadow_present_pte(old_spte))
+	WARN_ON_ONCE(!is_shadow_present_pte(new_spte));
+	check_spte_writable_invariants(new_spte);
+
+	if (!is_shadow_present_pte(old_spte)) {
+		mmu_spte_set(sptep, new_spte);
 		return false;
+	}
+
+	if (!spte_has_volatile_bits(old_spte))
+		__update_clear_spte_fast(sptep, new_spte);
+	else
+		old_spte = __update_clear_spte_slow(sptep, new_spte);
+
+	WARN_ON_ONCE(!is_shadow_present_pte(old_spte) ||
+		     spte_to_pfn(old_spte) != spte_to_pfn(new_spte));
 
 	return is_mmu_writable_spte(old_spte) && !is_mmu_writable_spte(new_spte);
 }
@@ -1587,8 +1574,13 @@ static bool kvm_rmap_age_gfn_range(struct kvm *kvm,
 				clear_bit((ffs(shadow_accessed_mask) - 1),
 					(unsigned long *)sptep);
 			} else {
+				/*
+				 * WARN if mmu_spte_update() signals the need
+				 * for a TLB flush, as Access tracking a SPTE
+				 * should never trigger an _immediate_ flush.
+				 */
 				spte = mark_spte_for_access_track(spte);
-				mmu_spte_update_no_track(sptep, spte);
+				WARN_ON_ONCE(mmu_spte_update(sptep, spte));
 			}
 			young = true;
 		}
-- 
2.47.0.rc1.288.g06298d1525-goog


