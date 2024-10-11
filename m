Return-Path: <kvm+bounces-28591-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B208C999A2D
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 04:16:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1E09E1F244A0
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 02:16:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5B5D1FB3C0;
	Fri, 11 Oct 2024 02:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CU3FIr26"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 761A41FAC2A
	for <kvm@vger.kernel.org>; Fri, 11 Oct 2024 02:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728612683; cv=none; b=CGLnKYlbxwsXwdC6iY1s0wp33KkOQTS4CF711rxrVWUI407C/9QItyx8bTkws+xDnKwwvsjobHQphFllznqgtjpVT9LjyKSMtjHuDKMlGQczK1rw/bTk9HBZh8CjsyKjzKr20DTCrAwBBK7+9zdI2qcjhPMH8CTGRy5W6SVnyYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728612683; c=relaxed/simple;
	bh=m/5CauBdL1nt8Fd10Sy1g4VhGuxt93poof2ffX7YAoM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sJOeGc0GCtw0RNQ+G31WLbNpWI+mIUkfcYQFiD6oDG3WYZyQLTZ6Ta4oOmv91fxBD1JEOKbXvrwwJ56eQPSP+fjd6IcK8hPhyAIoLfxVCN5eIv3yYj3ZLnsYeBToa0eYBXaQGQZmsTgENXR+dMt8mWmWhjCYqd7LvFLbB/iKOU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CU3FIr26; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-20c94f450c7so9949655ad.3
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 19:11:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728612682; x=1729217482; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=F6r5K1Obxnm5Vr48TnHxk1cPnehpFcrMpqKQdTEhjUg=;
        b=CU3FIr26OFZC3tciRj903lQGZIDMfFot9AXP+/hE9/Lm9k0hdT4VFQFWjMEjorD5W5
         xf1Dj0fK5h57EFWI8E+p42VFraY4AnuxujbET9qI0ScB6KjZXQmnJhw+r3m4A+du/2/+
         URv1FCIqDCqIvKpNZByY/KLcyBBC/utG5C6MkPZInS2ztuhSx2z0OgzhAZOrCHvQJ6kS
         ba5x45lPbR9urZCEOCCInOOMnOZsgRIAvEgatGhMBQUc+V/cb3gROaGYQG06u1/I68tv
         JuudrXaqfJLh3NOVoKmQW0BOOa04A33dZeIS59gEqn0euPaUE0GT6/a5OiYk0sNrmBHn
         rP1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728612682; x=1729217482;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F6r5K1Obxnm5Vr48TnHxk1cPnehpFcrMpqKQdTEhjUg=;
        b=ekRjgkbVFtOI3wL9X200AWlCzzZSPrvEYUaxv1vdBuYy/MRO0ZI2eEsQVFUQMRFGl1
         avMyAWFb2+sHvu70JAQ2Po8R+pUUbLWvhcrK0R0CuGXbrqr9lJp6sFrIBRh/OCj7M0Wb
         zGG4drnEFhhkOfJrBzrkUq4bQS0VOJGTwl8PoN+h9Jk/DHIVVJGMaH2y55ttlaTdDbDx
         NIgITBzNWJ+TKGcVfYdIiHE3yPcnvNRufqOTCNKnmXsb7DOnBiMs+sk7L6pHv8Yr9uL+
         z+q9BDCQrmFcgn0SgsqK/RKKWCmVdEc2fji/yKfSfNuczusz2K7gOrQwX4RvIKogWOvw
         fS2w==
X-Gm-Message-State: AOJu0YwrgRuGnWQ1KjUXIl5exrd7dz0MBeoeYAr0qKLRjbbn7Rq/xF1q
	NBxWiBl0+adeLNvMV0jtBYL854vUcHuxrylI0OtoWrkoPek/Taiz0dyVh2g9CppCKsrrUqOKCLh
	7bw==
X-Google-Smtp-Source: AGHT+IErTn43l0LgEWENkKDIgkfXKjKQt8ITh9JwTsuSnXZvVQSIOElg4tIAx1YgDCRzg3lb2AMhAmBmMyg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:902:ecc7:b0:20b:9522:6564 with SMTP id
 d9443c01a7336-20ca16ddcefmr7355ad.9.1728612681515; Thu, 10 Oct 2024 19:11:21
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 19:10:46 -0700
In-Reply-To: <20241011021051.1557902-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241011021051.1557902-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241011021051.1557902-15-seanjc@google.com>
Subject: [PATCH 14/18] KVM: x86/mmu: Stop processing TDP MMU roots for
 test_age if young SPTE found
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Sagi Shahar <sagis@google.com>, 
	"=?UTF-8?q?Alex=20Benn=C3=A9e?=" <alex.bennee@linaro.org>, David Matlack <dmatlack@google.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Return immediately if a young SPTE is found when testing, but not updating,
SPTEs.  The return value is a boolean, i.e. whether there is one young SPTE
or fifty is irrelevant (ignoring the fact that it's impossible for there to
be fifty SPTEs, as KVM has a hard limit on the number of valid TDP MMU
roots).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 84 ++++++++++++++++++--------------------
 1 file changed, 40 insertions(+), 44 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index e8c061bf94ec..f412bca206c5 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1192,35 +1192,6 @@ bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
 	return flush;
 }
 
-typedef bool (*tdp_handler_t)(struct kvm *kvm, struct tdp_iter *iter,
-			      struct kvm_gfn_range *range);
-
-static __always_inline bool kvm_tdp_mmu_handle_gfn(struct kvm *kvm,
-						   struct kvm_gfn_range *range,
-						   tdp_handler_t handler)
-{
-	struct kvm_mmu_page *root;
-	struct tdp_iter iter;
-	bool ret = false;
-
-	/*
-	 * Don't support rescheduling, none of the MMU notifiers that funnel
-	 * into this helper allow blocking; it'd be dead, wasteful code.  Note,
-	 * this helper must NOT be used to unmap GFNs, as it processes only
-	 * valid roots!
-	 */
-	for_each_valid_tdp_mmu_root(kvm, root, range->slot->as_id) {
-		rcu_read_lock();
-
-		tdp_root_for_each_leaf_pte(iter, root, range->start, range->end)
-			ret |= handler(kvm, &iter, range);
-
-		rcu_read_unlock();
-	}
-
-	return ret;
-}
-
 /*
  * Mark the SPTEs range of GFNs [start, end) unaccessed and return non-zero
  * if any of the GFNs in the range have been accessed.
@@ -1229,15 +1200,10 @@ static __always_inline bool kvm_tdp_mmu_handle_gfn(struct kvm *kvm,
  * from the clear_young() or clear_flush_young() notifier, which uses the
  * return value to determine if the page has been accessed.
  */
-static bool age_gfn_range(struct kvm *kvm, struct tdp_iter *iter,
-			  struct kvm_gfn_range *range)
+static void kvm_tdp_mmu_age_spte(struct tdp_iter *iter)
 {
 	u64 new_spte;
 
-	/* If we have a non-accessed entry we don't need to change the pte. */
-	if (!is_accessed_spte(iter->old_spte))
-		return false;
-
 	if (spte_ad_enabled(iter->old_spte)) {
 		iter->old_spte = tdp_mmu_clear_spte_bits(iter->sptep,
 							 iter->old_spte,
@@ -1253,23 +1219,53 @@ static bool age_gfn_range(struct kvm *kvm, struct tdp_iter *iter,
 
 	trace_kvm_tdp_mmu_spte_changed(iter->as_id, iter->gfn, iter->level,
 				       iter->old_spte, new_spte);
-	return true;
+}
+
+static bool __kvm_tdp_mmu_age_gfn_range(struct kvm *kvm,
+					struct kvm_gfn_range *range,
+					bool test_only)
+{
+	struct kvm_mmu_page *root;
+	struct tdp_iter iter;
+	bool ret = false;
+
+	/*
+	 * Don't support rescheduling, none of the MMU notifiers that funnel
+	 * into this helper allow blocking; it'd be dead, wasteful code.  Note,
+	 * this helper must NOT be used to unmap GFNs, as it processes only
+	 * valid roots!
+	 */
+	for_each_valid_tdp_mmu_root(kvm, root, range->slot->as_id) {
+		rcu_read_lock();
+
+		tdp_root_for_each_leaf_pte(iter, root, range->start, range->end) {
+			if (!is_accessed_spte(iter.old_spte))
+				continue;
+
+			ret = true;
+			if (test_only)
+				break;
+
+			kvm_tdp_mmu_age_spte(&iter);
+		}
+
+		rcu_read_unlock();
+
+		if (ret && test_only)
+			break;
+	}
+
+	return ret;
 }
 
 bool kvm_tdp_mmu_age_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	return kvm_tdp_mmu_handle_gfn(kvm, range, age_gfn_range);
-}
-
-static bool test_age_gfn(struct kvm *kvm, struct tdp_iter *iter,
-			 struct kvm_gfn_range *range)
-{
-	return is_accessed_spte(iter->old_spte);
+	return __kvm_tdp_mmu_age_gfn_range(kvm, range, false);
 }
 
 bool kvm_tdp_mmu_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	return kvm_tdp_mmu_handle_gfn(kvm, range, test_age_gfn);
+	return __kvm_tdp_mmu_age_gfn_range(kvm, range, true);
 }
 
 /*
-- 
2.47.0.rc1.288.g06298d1525-goog


