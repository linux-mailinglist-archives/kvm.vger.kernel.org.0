Return-Path: <kvm+bounces-27519-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CE3C986A76
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 03:35:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2D3E9281A16
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 01:35:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C007917A918;
	Thu, 26 Sep 2024 01:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0bUNuo1z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F232172BD5
	for <kvm@vger.kernel.org>; Thu, 26 Sep 2024 01:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727314519; cv=none; b=EUYrFovpNuEdQ/aJ9zG+OXiWEgkVJJyrlBYDZ15hYkIO3VzFAItWtBnJcgEB0O+9U1v+/+A7+xBhlYh0lgOmBN+Wm8IvkIVDroyi7vk+mRdwSjHnMOIpdFnbq2cziwAfy5gTctQpIe9SKzMb/9cnAUuuNN5GScx+a9R6EB9sUmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727314519; c=relaxed/simple;
	bh=pFh4dn0DcxvpXIZdI7PRhX8hY1TmiFNRUmbeFvcagR0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FrcfR92LkC92htsueOWnwCSB8G+rzf0mffvDBReAaoq9mu9rp11c72aCYEbUjqhapmAO2gIaMOd3Ns25s3B8/4vELmYLWoQ5KupywmeHbB+j3C6EqdjF8+UVIPP+A5m2pyp6DHLqiAVnqS4oZlbJHuomYQV85/9AVUcyI2kuJjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0bUNuo1z; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e25cae769abso816231276.0
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 18:35:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727314517; x=1727919317; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nrPGFdAf3DB4vj7nij04fMkTLi5+MW1J/YyJNP+NgJQ=;
        b=0bUNuo1zuvX/xdlLbkevtba/S+59HrgjxK9eSNMjQCr7KTaOuPWyIZ8tnV1I0DZ6n5
         RM25YHs5HibNT3Wc+N2Eizz6ZZGob6q1SKi5SzKaY70uZCIrrk7t8MWcLn+ShgNw38VR
         xPAlQDb7mYLP0VzERh42Cdf14F1J3+XoSuq7lj/tnh4B5/l0xLypNUWWw486WaNG7Q6E
         C3HpHV+rIFDgdp6CdytSCXAhS5/ZSj8UyMJuPXxbOn+vk8W/Fs2hJdYgu+KyAnB7nTjI
         2AWKGQs4pSqByLrDQDYTcBUGcAgFA6WoowbY7uXPFt0RaLgAQ71HxsZeD0S8ma0v9RCd
         wrlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727314517; x=1727919317;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nrPGFdAf3DB4vj7nij04fMkTLi5+MW1J/YyJNP+NgJQ=;
        b=K4V0l/9QVBMDXeZNt7ud5uQP809y2sQgUak799pRPqio213gaKUPvsA+4LrLCTYW91
         9Yze74Y96iRVNtyfsefCOdXsxO9RdEwo8cVgRi7xllak0G5m1DYXRTHl4I0USOARvnkE
         KsuytybD5mWxCVjAazURCgzA/n1bVquAHRj00UY2yjeIESCCh/tWonT5YfFhvFTxW8cy
         t2EJu4GljF89Hg/tjWa7u3SIuoSrrFx/20TtBP9vTiM82CoQs700fa7d+zCyFPBLHIZh
         a7GDSspKT5i4ih9hv8Ak1/8YEWmsWAJZCPV3c8moczlaOIYIzjegnuTawtEDjER0hHaM
         o6Gg==
X-Forwarded-Encrypted: i=1; AJvYcCUMTBHXU9yUKMrOVIQcpPbEEEVj/Bzc8fph4cDdbUhhxONtmIKU5VnwMJLZwullRy9X1r8=@vger.kernel.org
X-Gm-Message-State: AOJu0YziJkNXm5EZCmxCR1XyFHfbAgVFvL4u4zyVBz/7YQFpMcXs6dvL
	zXZl4AYKMCPA9G5n3Uw3uwowf19u6200EuFfK4aGxu+0Sto3z/dCXufRXAuL5Fd6eYoM56iRKvM
	afOfuOj7rgUaClO7Nyw==
X-Google-Smtp-Source: AGHT+IHBkpgMYqE9bFhZXKzj+UxHtQzg97Wx4pqBE3O5Wvje89pjGl0kpLMaEu3zaYYGi2UruxZxZDhUO7JaGYM6
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:13d:fb22:ac12:a84b])
 (user=jthoughton job=sendgmr) by 2002:a25:3546:0:b0:e1b:10df:78ea with SMTP
 id 3f1490d57ef6-e24d7df1a54mr3612276.4.1727314517106; Wed, 25 Sep 2024
 18:35:17 -0700 (PDT)
Date: Thu, 26 Sep 2024 01:34:50 +0000
In-Reply-To: <20240926013506.860253-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240926013506.860253-1-jthoughton@google.com>
X-Mailer: git-send-email 2.46.0.792.g87dc391469-goog
Message-ID: <20240926013506.860253-3-jthoughton@google.com>
Subject: [PATCH v7 02/18] KVM: Add lockless memslot walk to KVM
From: James Houghton <jthoughton@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, James Houghton <jthoughton@google.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>, Yu Zhao <yuzhao@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"

Provide flexibility to the architecture to synchronize as optimally as
they can instead of always taking the MMU lock for writing.

Architectures that do their own locking must select
CONFIG_KVM_MMU_NOTIFIER_YOUNG_LOCKLESS.

The immediate application is to allow architectures to implement the
test/clear_young MMU notifiers more cheaply.

Suggested-by: Yu Zhao <yuzhao@google.com>
Signed-off-by: James Houghton <jthoughton@google.com>
---
 include/linux/kvm_host.h |  1 +
 virt/kvm/Kconfig         |  3 +++
 virt/kvm/kvm_main.c      | 28 +++++++++++++++++++++-------
 3 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index b23c6d48392f..98a987e88578 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -266,6 +266,7 @@ struct kvm_gfn_range {
 	gfn_t end;
 	union kvm_mmu_notifier_arg arg;
 	bool may_block;
+	bool lockless;
 };
 bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
 bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index fd6a3010afa8..58d896b2f4ed 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -100,6 +100,9 @@ config KVM_GENERIC_MMU_NOTIFIER
        select MMU_NOTIFIER
        bool
 
+config KVM_MMU_NOTIFIER_YOUNG_LOCKLESS
+       bool
+
 config KVM_GENERIC_MEMORY_ATTRIBUTES
        depends on KVM_GENERIC_MMU_NOTIFIER
        bool
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 090e79e4304f..7d5b35cfc1ed 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -555,6 +555,7 @@ struct kvm_mmu_notifier_range {
 	on_lock_fn_t on_lock;
 	bool flush_on_ret;
 	bool may_block;
+	bool lockless;
 };
 
 /*
@@ -609,6 +610,10 @@ static __always_inline kvm_mn_ret_t kvm_handle_hva_range(struct kvm *kvm,
 			 IS_KVM_NULL_FN(range->handler)))
 		return r;
 
+	/* on_lock will never be called for lockless walks */
+	if (WARN_ON_ONCE(range->lockless && !IS_KVM_NULL_FN(range->on_lock)))
+		return r;
+
 	idx = srcu_read_lock(&kvm->srcu);
 
 	for (i = 0; i < kvm_arch_nr_memslot_as_ids(kvm); i++) {
@@ -640,15 +645,18 @@ static __always_inline kvm_mn_ret_t kvm_handle_hva_range(struct kvm *kvm,
 			gfn_range.start = hva_to_gfn_memslot(hva_start, slot);
 			gfn_range.end = hva_to_gfn_memslot(hva_end + PAGE_SIZE - 1, slot);
 			gfn_range.slot = slot;
+			gfn_range.lockless = range->lockless;
 
 			if (!r.found_memslot) {
 				r.found_memslot = true;
-				KVM_MMU_LOCK(kvm);
-				if (!IS_KVM_NULL_FN(range->on_lock))
-					range->on_lock(kvm);
-
-				if (IS_KVM_NULL_FN(range->handler))
-					goto mmu_unlock;
+				if (!range->lockless) {
+					KVM_MMU_LOCK(kvm);
+					if (!IS_KVM_NULL_FN(range->on_lock))
+						range->on_lock(kvm);
+
+					if (IS_KVM_NULL_FN(range->handler))
+						goto mmu_unlock;
+				}
 			}
 			r.ret |= range->handler(kvm, &gfn_range);
 		}
@@ -658,7 +666,7 @@ static __always_inline kvm_mn_ret_t kvm_handle_hva_range(struct kvm *kvm,
 		kvm_flush_remote_tlbs(kvm);
 
 mmu_unlock:
-	if (r.found_memslot)
+	if (r.found_memslot && !range->lockless)
 		KVM_MMU_UNLOCK(kvm);
 
 	srcu_read_unlock(&kvm->srcu, idx);
@@ -834,6 +842,8 @@ static int kvm_mmu_notifier_clear_flush_young(struct mmu_notifier *mn,
 		.on_lock	= (void *)kvm_null_fn,
 		.flush_on_ret	= true,
 		.may_block	= false,
+		.lockless	=
+			IS_ENABLED(CONFIG_KVM_MMU_NOTIFIER_YOUNG_LOCKLESS),
 	};
 
 	trace_kvm_age_hva(start, end);
@@ -854,6 +864,8 @@ static int kvm_mmu_notifier_clear_young(struct mmu_notifier *mn,
 		.on_lock	= (void *)kvm_null_fn,
 		.flush_on_ret	= false,
 		.may_block	= false,
+		.lockless	=
+			IS_ENABLED(CONFIG_KVM_MMU_NOTIFIER_YOUNG_LOCKLESS),
 	};
 
 	trace_kvm_age_hva(start, end);
@@ -886,6 +898,8 @@ static int kvm_mmu_notifier_test_young(struct mmu_notifier *mn,
 		.on_lock	= (void *)kvm_null_fn,
 		.flush_on_ret	= false,
 		.may_block	= false,
+		.lockless	=
+			IS_ENABLED(CONFIG_KVM_MMU_NOTIFIER_YOUNG_LOCKLESS),
 	};
 
 	trace_kvm_test_age_hva(address);
-- 
2.46.0.792.g87dc391469-goog


