Return-Path: <kvm+bounces-28594-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E0CB4999A33
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 04:17:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 54BE91F24511
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 02:17:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CB5B1FBCBB;
	Fri, 11 Oct 2024 02:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PYPMO+dI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50ADC1FBC8E
	for <kvm@vger.kernel.org>; Fri, 11 Oct 2024 02:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728612691; cv=none; b=qRe4GTXjkslC2UYe8KqoPEh1Qp7ih4ZHAAT7WzzgjCVyjzAnnU8n6ibQuLCQl9pcyclyHtBaUGs4lO3NETnpsFp7apSraZogqKl8NbMTgwglVqjYE5bMYw6hhFwksph9WteQIF9c5rhjEGAjo7hLGWTl0Jatdd8qlM/uuuWFfdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728612691; c=relaxed/simple;
	bh=iyJm/h+JOO59f+egBKANfLu+0QMr2pI0zJeagTYRCD4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tQKpgBJTPS/Op8yz5LvFEx0Q9p5JtW5NZQftg6lE+NtrwE7JXC/ScfiFaC1ihQx3I00CuH2X2iLyx4UwbmDDDqdJrt0R1XwTo2k6nIlBZ6r+cp9E2AWRElr0BD1apfmTbZyCmQR0nUKmsJBOfTMllkkCS28ZVsDYRpCfJENMQJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PYPMO+dI; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e0b8fa94718so2319056276.0
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 19:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728612689; x=1729217489; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=HPDDwUN824pfD2nj2HWQd9wsiBjvr8+g8+t2fSbMNlA=;
        b=PYPMO+dIz2MEJ9uWGnpzMDLoKh+UuyJIyZmNXuqbSiVOdTd214fzLaTbR1r/huZV6G
         gUCNMV6B52TgkvmtpjDNuduzkb92NtWqgasAaY+wAZYjvZ0H5I9C16O55KtJTEiAAvpc
         9QHy/RtL6SGjpF98SSBX5CaAtlaI34+Y9n5jvCtnuLGPW3j/w5bmER0tDHQPup2InfJh
         8NLMGe2+b0hFnbp0glpF33KZbnMpiOn7DpgyppnLX8VdkE3Eb2RDJQoxANgT2bQBpeTX
         hqnp3IwrCFkL1iBeNy+pL7ILktxKp96OaGtltMGYnfnPKp6V53PPQF4zzD2T5a5G9g3r
         F32w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728612689; x=1729217489;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HPDDwUN824pfD2nj2HWQd9wsiBjvr8+g8+t2fSbMNlA=;
        b=q5+GsAwnIeTlx3aymqy1Ul88WfMNZDH9+WpJSI/XqDnyxyQGLtJTs2a2RIUeDXKgT4
         L1/sNLAeIGws8QN6yV9gWkwu2IHvXnzEGAMs7MsTR6FKP9ydC/TtNAkuFWXxMpdh9AcL
         J4k3wQZI8JO2q4BvGJaMjwDK3O1bqW/9rYk9ebm9TR0woX7VdoQ7lzGXUFMQq94YySbH
         OH7MkzD2kEMdr6oUfvh+n7tCtTxbziFz/tdQjICO/0RV7wivLOn+Uj0GQaikiJqK8lLh
         BsAeSeR+1t3j+eZpda9sJGZJkL/LanUygriCQ5FX9LHuDbCnb9hcTIBldNUj7tGdDwcE
         xLSQ==
X-Gm-Message-State: AOJu0YyX5EJ9+KJWvzi6qR9be7lyr/FUGxHpazP+Qy17yzB1f41IP0Hw
	6U9/oSklyVczr1S1V42B21YzFsI+G5gCsdgOxzcrkpWXqt1pT6Ix/ALhXuCGRF6zXD/DGeTMTu5
	Qhg==
X-Google-Smtp-Source: AGHT+IGTSYki/MPVOSXtSoZ4BErjm1NrfbNeO31MKvV+62YjjXjQGEoBGgc7gkTIPIKCnszTY2Gpwqbhv0k=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:d346:0:b0:e17:8e4f:981a with SMTP id
 3f1490d57ef6-e291a32c730mr5851276.11.1728612688656; Thu, 10 Oct 2024 19:11:28
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 19:10:49 -0700
In-Reply-To: <20241011021051.1557902-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241011021051.1557902-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241011021051.1557902-18-seanjc@google.com>
Subject: [PATCH 17/18] KVM: Allow arch code to elide TLB flushes when aging a
 young page
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Sagi Shahar <sagis@google.com>, 
	"=?UTF-8?q?Alex=20Benn=C3=A9e?=" <alex.bennee@linaro.org>, David Matlack <dmatlack@google.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a Kconfig to allow architectures to opt-out of a TLB flush when a
young page is aged, as invalidating TLB entries is not functionally
required on most KVM-supported architectures.  Stale TLB entries can
result in false negatives and theoretically lead to suboptimal reclaim,
but in practice all observations have been that the performance gained by
skipping TLB flushes outweighs any performance lost by reclaiming hot
pages.

E.g. the primary MMUs for x86 RISC-V, s390, and PPC Book3S elide the TLB
flush for ptep_clear_flush_young(), and arm64's MMU skips the trailing DSB
that's required for ordering (presumably because there are optimizations
related to eliding other TLB flushes when doing make-before-break).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/Kconfig    |  4 ++++
 virt/kvm/kvm_main.c | 20 ++++++--------------
 2 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index fd6a3010afa8..54e959e7d68f 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -100,6 +100,10 @@ config KVM_GENERIC_MMU_NOTIFIER
        select MMU_NOTIFIER
        bool
 
+config KVM_ELIDE_TLB_FLUSH_IF_YOUNG
+       depends on KVM_GENERIC_MMU_NOTIFIER
+       bool
+
 config KVM_GENERIC_MEMORY_ATTRIBUTES
        depends on KVM_GENERIC_MMU_NOTIFIER
        bool
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b1b10dc408a0..83b525d16b61 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -630,7 +630,8 @@ static __always_inline kvm_mn_ret_t __kvm_handle_hva_range(struct kvm *kvm,
 static __always_inline int kvm_handle_hva_range(struct mmu_notifier *mn,
 						unsigned long start,
 						unsigned long end,
-						gfn_handler_t handler)
+						gfn_handler_t handler,
+						bool flush_on_ret)
 {
 	struct kvm *kvm = mmu_notifier_to_kvm(mn);
 	const struct kvm_mmu_notifier_range range = {
@@ -638,7 +639,7 @@ static __always_inline int kvm_handle_hva_range(struct mmu_notifier *mn,
 		.end		= end,
 		.handler	= handler,
 		.on_lock	= (void *)kvm_null_fn,
-		.flush_on_ret	= true,
+		.flush_on_ret	= flush_on_ret,
 		.may_block	= false,
 	};
 
@@ -650,17 +651,7 @@ static __always_inline int kvm_handle_hva_range_no_flush(struct mmu_notifier *mn
 							 unsigned long end,
 							 gfn_handler_t handler)
 {
-	struct kvm *kvm = mmu_notifier_to_kvm(mn);
-	const struct kvm_mmu_notifier_range range = {
-		.start		= start,
-		.end		= end,
-		.handler	= handler,
-		.on_lock	= (void *)kvm_null_fn,
-		.flush_on_ret	= false,
-		.may_block	= false,
-	};
-
-	return __kvm_handle_hva_range(kvm, &range).ret;
+	return kvm_handle_hva_range(mn, start, end, handler, false);
 }
 
 void kvm_mmu_invalidate_begin(struct kvm *kvm)
@@ -825,7 +816,8 @@ static int kvm_mmu_notifier_clear_flush_young(struct mmu_notifier *mn,
 {
 	trace_kvm_age_hva(start, end);
 
-	return kvm_handle_hva_range(mn, start, end, kvm_age_gfn);
+	return kvm_handle_hva_range(mn, start, end, kvm_age_gfn,
+				    !IS_ENABLED(CONFIG_KVM_ELIDE_TLB_FLUSH_IF_YOUNG));
 }
 
 static int kvm_mmu_notifier_clear_young(struct mmu_notifier *mn,
-- 
2.47.0.rc1.288.g06298d1525-goog


