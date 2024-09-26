Return-Path: <kvm+bounces-27532-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BD39986A9E
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 03:39:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DA1021F22516
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 01:39:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF7E8177982;
	Thu, 26 Sep 2024 01:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nBg7Tszw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6933A1A76D6
	for <kvm@vger.kernel.org>; Thu, 26 Sep 2024 01:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727314536; cv=none; b=A5v5DAsE59J2XsY+HsFTazQv7Cy8yLAl+lEfkQN/K0oQu6tzKZKwQ4IrUmRRZSDCJ28IVWicRxJeNXYsdYN1BJcdNsjrmB+FCG+Nlk7q6asJDEuSAcqpV30fALE4SvouMsKl/V92oPUwqbBaqtwVo1pHVzgCZxht6NBY2WUoYtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727314536; c=relaxed/simple;
	bh=P/XmdxbT2r5VTwTMBboA5fmY/qNQ13tNl6QPu1wIL4U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nL+kkloxxh+HLzjAAIa4tSo1xFkpy2mfnf2F835OgBcvqQMV5TrIWXKcVedY+NUYpc1lmVvln3mthp7awsQ6fJgmHi99FlfyCJ15feHP4kGL9yeaka0MoZHpY7ZOoYLLEaqRe1QP/QfgGtuu52e5GR97Ypt904MRs3zzrHjo2EY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nBg7Tszw; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e202bc54767so649428276.0
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 18:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727314533; x=1727919333; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/c4iHe6I2dqFJ8L4xEL/wcuXYs+QQdS3mQ0rZKnPlRM=;
        b=nBg7TszwOPouVBSmY7QUbGo6r19+GJG19iNTMli3HKbhLUDccOLZ1O4NEKzu88DJRw
         lKhZPzCcEjcQEQ6EYSwuDE71xUFdpcfQjoebuXEqWRRdvy1klsfZ+8RbiAfxoFnCAgon
         4gyukPJD2Jnk9xCyY7aAOixgV3wQRUTjQzUmKQIHUx8ns3aLEcdi01JPOEDFp16gm1MI
         RCOawb2ET08dOP9t/7jSjm/pkVBy16E4bqZxQOcWQWdsLLlC+2xNQkKH42CLkO+0uT4O
         Jnx21JkyDW3ob7GQQRs8N7vxGz1c9iOkw/oSEQVUAy0tER3u39OVHlAvoWmUpQ+rS87/
         nJwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727314533; x=1727919333;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/c4iHe6I2dqFJ8L4xEL/wcuXYs+QQdS3mQ0rZKnPlRM=;
        b=M45jBWsLSMw+jHRVdyZmmH+CGCyjXcToa2O+1ARgpgR1t3bmlmood++QxPUzKgR/8k
         c2bn/LkVK1biLzAzO/rz6sbC59iFMXPsESyR5u7/nFEQVE5CpOKwT/9OL4ta4qziXF98
         TRD/gFJk29QuvgCkYP/T/A+WwimM8d8g/lXmZq6/5irel4uH1e8BivrBbOZkRq2YHdwc
         ejFW9Pq6sCgWBo61L+IODNwRvW2Rrj8Dhj2W1hgN9xt/EdSdAzthR9X1vS0EviYk7XWD
         ccxouQwRnobu99i4FUMzXlSAFZeCb/P/lq1lQzRH02KDdjQpu393vKRedZT1NWK5vO37
         7jyw==
X-Forwarded-Encrypted: i=1; AJvYcCUQvN7aXxLfub5Fc1/xFyFQhNYAsUGJ+nMLafkecNRRDPohhoZEytCLzrBNZduApRIwzC4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJx59OwZIXUyeLKs3jj4eeBK8HSnQTF0o6UIbZeduCGczmanfl
	yQz3UGozHmLb8Fy/cduzgjSgEBi0WfBGgEnOau/SYdXvApowdEY44fKycCZMKt+YXq8Y3m+XN0R
	x4pUxV0kOLMRvdhBxjw==
X-Google-Smtp-Source: AGHT+IGK4m8FSya1x5h1yKPn0SlYZqL+0YnNSUJKqrhSqJhacVQdW7OQ9a4614HCOKTuoSQjtwwz7rbSxAQZQC1c
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:13d:fb22:ac12:a84b])
 (user=jthoughton job=sendgmr) by 2002:a5b:a:0:b0:e25:cf7f:a065 with SMTP id
 3f1490d57ef6-e25cf7fa247mr2793276.8.1727314533354; Wed, 25 Sep 2024 18:35:33
 -0700 (PDT)
Date: Thu, 26 Sep 2024 01:35:03 +0000
In-Reply-To: <20240926013506.860253-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240926013506.860253-1-jthoughton@google.com>
X-Mailer: git-send-email 2.46.0.792.g87dc391469-goog
Message-ID: <20240926013506.860253-16-jthoughton@google.com>
Subject: [PATCH v7 15/18] KVM: x86/mmu: Locklessly harvest access information
 from shadow MMU
From: James Houghton <jthoughton@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, James Houghton <jthoughton@google.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>, Yu Zhao <yuzhao@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"

Move where the lock is taken for the shadow MMU case to only take the
lock when !range->arg.fast_only (i.e., for the non-fast_only aging MMU
notifiers).

Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a63497bbcc61..f47bd88b55e3 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1822,16 +1822,24 @@ static bool __kvm_rmap_age_gfn_range(struct kvm *kvm,
 static bool kvm_rmap_age_gfn_range(struct kvm *kvm,
 				   struct kvm_gfn_range *range, bool test_only)
 {
+	bool young;
+
 	/*
 	 * We can always locklessly test if an spte is young. Because marking
 	 * non-A/D sptes for access tracking without holding the mmu_lock is
 	 * not currently supported, we cannot always locklessly clear.
+	 *
+	 * For fast_only, we must not take the mmu_lock, so locklessly age in
+	 * that case even though we will not be able to clear the age for
+	 * non-A/D sptes.
 	 */
-	if (test_only)
+	if (test_only || range->arg.fast_only)
 		return kvm_rmap_age_gfn_range_lockless(kvm, range, test_only);
 
-	lockdep_assert_held_write(&kvm->mmu_lock);
-	return __kvm_rmap_age_gfn_range(kvm, range, test_only);
+	write_lock(&kvm->mmu_lock);
+	young = __kvm_rmap_age_gfn_range(kvm, range, test_only);
+	write_unlock(&kvm->mmu_lock);
+	return young;
 }
 
 static bool kvm_has_shadow_mmu_sptes(struct kvm *kvm)
@@ -1846,11 +1854,8 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	if (tdp_mmu_enabled)
 		young = kvm_tdp_mmu_age_gfn_range(kvm, range);
 
-	if (kvm_has_shadow_mmu_sptes(kvm)) {
-		write_lock(&kvm->mmu_lock);
+	if (kvm_has_shadow_mmu_sptes(kvm))
 		young |= kvm_rmap_age_gfn_range(kvm, range, false);
-		write_unlock(&kvm->mmu_lock);
-	}
 
 	return young;
 }
@@ -1862,11 +1867,11 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	if (tdp_mmu_enabled)
 		young = kvm_tdp_mmu_test_age_gfn(kvm, range);
 
-	if (!young && kvm_has_shadow_mmu_sptes(kvm)) {
-		write_lock(&kvm->mmu_lock);
+	if (young)
+		return young;
+
+	if (kvm_has_shadow_mmu_sptes(kvm))
 		young |= kvm_rmap_age_gfn_range(kvm, range, true);
-		write_unlock(&kvm->mmu_lock);
-	}
 
 	return young;
 }
-- 
2.46.0.792.g87dc391469-goog


