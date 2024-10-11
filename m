Return-Path: <kvm+bounces-28580-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F7B0999A16
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 04:12:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 274D71F24479
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 02:12:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F6651F4FAE;
	Fri, 11 Oct 2024 02:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FAPaQCoM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4BD31F4715
	for <kvm@vger.kernel.org>; Fri, 11 Oct 2024 02:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728612661; cv=none; b=Ua1RtzA5yBOwZTNqu1uvgBacSRn8S0h4V+N3WEo2GzN5AdSyLyPmHEwdiJjFyCi6r9QzXCRb+Ng+oEhF6PZZW6pBGbgV0D5hG+0ntFv65W8PRGDu5YbtDfeMBl91uXpPY9YfWVVO8m68wFv1y5u7I199zDk2xpL14g3QGsnHDoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728612661; c=relaxed/simple;
	bh=RqYw1AtTmNIpKfrRVZilkRfxBV1RzGHNLXu7fiax26k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=keTKeShUKAGPq1JYH5n4kxpjFtIaHqA+hv0Sok8nsFlwK2C1JMTV/52uyXigLo9xA+vqv1P0QoU0/UxE9QjynfjKs9TEXxZELpE/oJsbvNL7DuGYDqXAYbUmEn9lmWeQB41Kupt+Q1ZYhixcJ1LBpNp45oWKVXp7FopC5nmt3sA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FAPaQCoM; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7d4f9974c64so1152024a12.1
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 19:10:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728612659; x=1729217459; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=1cFPbD2dKRB4Ynjmw+1iKOno60r0l4Z0l+jOG9EoBK0=;
        b=FAPaQCoMvl+bXRlr7tk1gXpgMK1NvZajqyA2R6CyWU1/qdgk5wQVUX+c+eq7cHY4TV
         GYff4dFBwyiBBEGjHir/495APPWYcd104lvlWJ2FpnkKAhHaVXNz7YhsgRDTOW/eHSef
         IwdVc2wXrXZyDDuNUBxU8ek0+vj91by3sOA0qzhg1Wp5YcTl3kNs7hRYhqWfzrZcFPnd
         40MJ3FQbAMqknYGXCRvSo4IZPDv474MnKAL0wQStrZ8GUgAqGT2ZvAy5fnHfQh0rji+T
         0Oa73vYK2PcoqjcU6TzTVAPZfmMxBmLwDPauckIZCtd+xsVLT2oUcX/zjyzCPAFxTzvu
         e7/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728612659; x=1729217459;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1cFPbD2dKRB4Ynjmw+1iKOno60r0l4Z0l+jOG9EoBK0=;
        b=TwU6PsUvJGLbo8I7Fpd7r1uAb/9vXuNOQqLT/CwCY6bUUWDASBYrpObDOjUHSeYslg
         Gn0AXVd7dapH5Dkm0mrve6zlgFt4u3vaxEu5mhkljQdjQSsGl0XdZ8ksXntD2zaiVG4J
         xYh7KMEQL7NtsNrVsU2HqPhNK10ezbyQhI+Fu1MrJHIf04Q/myr9lQKhW6Pv5wQDcPbr
         +lajKwfGKsXgYknKI0xmoLUS2L1Q6obOz8e1YG26aJ3CR6HuUrgavjfJFh+sAIw+XzrJ
         QuTtWkL7UrqDRKaIttKKW/6FKhnAkTA2p4RhaLhIjHvZX058oFJyjJP9SryXiBXCKZoF
         jkQw==
X-Gm-Message-State: AOJu0YwGw2cjl0sYQshrWqS+bN9GVyZ2OwK5YVdnAd3ndi8ehAyY0iMl
	CraHSgEXP+M20s12EsodR9pphyRzYwZN+ias+mJJdln07cHyHYABmwUwOLRSTz+kmNp3qO2W875
	UKg==
X-Google-Smtp-Source: AGHT+IGX2CXRtmLd2XIO3ano1VLdg5QbiDrG6U3QGMBhMcsoaLOgnVSvhPE6pecTJ5VW0JuXmb1bfxqe1OQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a65:6896:0:b0:7db:18fc:3068 with SMTP id
 41be03b00d2f7-7ea535903c0mr782a12.5.1728612657867; Thu, 10 Oct 2024 19:10:57
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 19:10:35 -0700
In-Reply-To: <20241011021051.1557902-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241011021051.1557902-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241011021051.1557902-4-seanjc@google.com>
Subject: [PATCH 03/18] KVM: x86/mmu: Fold all of make_spte()'s writable
 handling into one if-else
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Sagi Shahar <sagis@google.com>, 
	"=?UTF-8?q?Alex=20Benn=C3=A9e?=" <alex.bennee@linaro.org>, David Matlack <dmatlack@google.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Now that make_spte() no longer uses a funky goto to bail out for a special
case of its unsync handling, combine all of the unsync vs. writable logic
into a single if-else statement.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/spte.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 09ce93c4916a..030813781a63 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -217,8 +217,6 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	spte |= (u64)pfn << PAGE_SHIFT;
 
 	if (pte_access & ACC_WRITE_MASK) {
-		spte |= PT_WRITABLE_MASK | shadow_mmu_writable_mask;
-
 		/*
 		 * Unsync shadow pages that are reachable by the new, writable
 		 * SPTE.  Write-protect the SPTE if the page can't be unsync'd,
@@ -233,16 +231,13 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		 * guaranteed by both the shadow MMU and the TDP MMU.
 		 */
 		if ((!is_last_spte(old_spte, level) || !is_writable_pte(old_spte)) &&
-		    mmu_try_to_unsync_pages(vcpu->kvm, slot, gfn, synchronizing, prefetch)) {
+		    mmu_try_to_unsync_pages(vcpu->kvm, slot, gfn, synchronizing, prefetch))
 			wrprot = true;
-			pte_access &= ~ACC_WRITE_MASK;
-			spte &= ~(PT_WRITABLE_MASK | shadow_mmu_writable_mask);
-		}
+		else
+			spte |= PT_WRITABLE_MASK | shadow_mmu_writable_mask |
+				spte_shadow_dirty_mask(spte);
 	}
 
-	if (pte_access & ACC_WRITE_MASK)
-		spte |= spte_shadow_dirty_mask(spte);
-
 	if (prefetch && !synchronizing)
 		spte = mark_spte_for_access_track(spte);
 
-- 
2.47.0.rc1.288.g06298d1525-goog


