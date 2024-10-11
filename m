Return-Path: <kvm+bounces-28587-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9970B999A24
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 04:14:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C97B11C2330B
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 02:14:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F6311F9438;
	Fri, 11 Oct 2024 02:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BPREzY0J"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECBA91F940C
	for <kvm@vger.kernel.org>; Fri, 11 Oct 2024 02:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728612675; cv=none; b=aAK1HenkqXBSAofx+W1ELSh8QuuZ3Ejw25K4GEC+AIVj84rLX3wuOLE+QoFPNyiPcWRXS6KzWCUUK5n6y+xErtHhcsNP4JJ2YNmPLN6xHVaT0pCLO4ipG7il29AxvZnOaWM2ki+Bfim0/cBgFBbAkBih0q+dYufrV0Omw4O2eCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728612675; c=relaxed/simple;
	bh=aKgSp3XrLYNy8hNKG4jop6hvDJmh/ChMqz+HQoJA+wE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dmvgj1f1rNBjK2x4Mfv03GgMKhZ6EK4KZyQvIyTqjMg9S/wO4Ymw0/z+HVryjZDCbIv3APGWqa8MR3wmUCPSkM5VMsb6WULMhI3d0OyPayX6UnW8dnnCFN6Oii3lwD4WL7XHS9dfJoU9wzQ2PyUWDFu8aTrBitFlJtUyF3hrrok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BPREzY0J; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e000d68bb1so30467957b3.1
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 19:11:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728612673; x=1729217473; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=TrIlp1Guds3zrlzSMYuxG6o1rQn3R2bekD4gqwcbBS8=;
        b=BPREzY0JAOiY1f8lVJCq9+YxrYjDQeMYdT+GFTMze8Spr+ZcQB9GCEuqBA1MJX06Kx
         ETO7NSzcDw4/w7aK68EgUr1aWHSCDjRZjJgL5eGxKQ44AWm7CF6BeOJBcwZWTNLW63BD
         fHjv++pmJRKO2odF5gN0NkFTYs/0cyvNUy3U84h9wFJYhsmyq093fFFVeNDswgshT/bP
         pGEHgA7WvZ92VnPu4GVRZTSHkK7Xj5kEPEheZJGqwgkWm9TOfZhbGpXDoQu8DeJpz51I
         YYd/gQEPHtJJNRodIvLm/Hx386nUYwap44oZ9kbPLSqvm6yJPJIqzdMR99Tl2sGDFZIy
         8TAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728612673; x=1729217473;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TrIlp1Guds3zrlzSMYuxG6o1rQn3R2bekD4gqwcbBS8=;
        b=UwkOgXMmu5w9SkbwLwxrhHsFXPb+VaF7l/DiWPWS+689OSA+NUwQqK9xjbp0Gxyv7m
         cfg9j5GfCUhKJb0tp1rcm9bOWgy45YWyjxz1FJ3gdV4PjAnFFZMdgq5/R4/x/ilHuXJS
         foV6jKUuTFZeiXV2XcIO2LgcSsT07Jcs3YIue1nJ4g/fH/zcz+XcPU9XWGi/R2T5Snst
         Cus5OnpdIEo9kaXMYBkK1B1ayE5vii0K4k/bkER9xbSr7zLs+e/C8GHwMYKSJscGc7AS
         OgQLz2/EmYRKKP5e/7i6Dq6ROFjwjIhYvYed8jGb1ItQ/wDuMOG8QvYuisZv4QYwORHc
         M4zQ==
X-Gm-Message-State: AOJu0YwiHLusLwgO5AOsM+RbsBXsmQspngfZpD7dMbit3k3OTDJRopF8
	rd/2r5FZOoYZ8IHyXca+zEy1dsqCYb4mql1B0Uukc1BALqiVcW3Elqmw41Orc5ulCCbxK+UiCqC
	7Lg==
X-Google-Smtp-Source: AGHT+IElEKizd4vm3idzgibROUYOU9UMUvmYhyDSJ+LMWh+4cN4KYm1fNLHVNNLdSguOs2K4bXih+kBr8mQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1349:b0:e20:2da6:ed77 with SMTP id
 3f1490d57ef6-e2918421de9mr9964276.5.1728612672856; Thu, 10 Oct 2024 19:11:12
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 19:10:42 -0700
In-Reply-To: <20241011021051.1557902-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241011021051.1557902-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241011021051.1557902-11-seanjc@google.com>
Subject: [PATCH 10/18] KVM: x86/mmu: Set shadow_accessed_mask for EPT even if
 A/D bits disabled
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Sagi Shahar <sagis@google.com>, 
	"=?UTF-8?q?Alex=20Benn=C3=A9e?=" <alex.bennee@linaro.org>, David Matlack <dmatlack@google.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Now that KVM doesn't use shadow_accessed_mask to detect if hardware A/D
bits are enabled, set shadow_accessed_mask for EPT even when A/D bits
are disabled in hardware.  This will allow using shadow_accessed_mask for
software purposes, e.g. to preserve accessed status in a non-present SPTE
acros NUMA balancing, if something like that is ever desirable.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/spte.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index c9543625dda2..e352d1821319 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -419,7 +419,7 @@ void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only)
 	kvm_ad_enabled		= has_ad_bits;
 
 	shadow_user_mask	= VMX_EPT_READABLE_MASK;
-	shadow_accessed_mask	= has_ad_bits ? VMX_EPT_ACCESS_BIT : 0ull;
+	shadow_accessed_mask	= VMX_EPT_ACCESS_BIT;
 	shadow_dirty_mask	= has_ad_bits ? VMX_EPT_DIRTY_BIT : 0ull;
 	shadow_nx_mask		= 0ull;
 	shadow_x_mask		= VMX_EPT_EXECUTABLE_MASK;
-- 
2.47.0.rc1.288.g06298d1525-goog


