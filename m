Return-Path: <kvm+bounces-19276-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3469C902D95
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 02:24:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 35EA11C21778
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 00:24:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FCCB2C684;
	Tue, 11 Jun 2024 00:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TZjEK4WZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB1B11B5A4
	for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 00:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718065327; cv=none; b=oWW8GBFmFJ/zwVs6+SuE4Xg00xPJk4k3XLv4UhwK+VV38kkBUoD3Ms41K/3hVUPNqtr3lxIZfc+/P4v3I6B/kRTUxri+xTWLH77YAxdzzzxH5BeMXoFjDmXtiF7ZoX6FJJ8UECfiRmg4AN4aw9X7R+p6fMG+pdq0LVFTZlOXTek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718065327; c=relaxed/simple;
	bh=TLFRX+aqWmviYS3ujVoFIt3OR1s8HN7oRYUrNpwybnQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Rzlo2QxxlMpr70aHEtTs07GA9QeNdroyo5Gd/2n6u/QAsLHV4EDDj9TFaZQDWxTnm0y8Eehw+z++UAFWDyynv5OYMSbwgh1dYsrcq3QcvoV9qGMSo8avSUpLQ00H+RHHYv/kSERhGLwfN0ItG1u49IGqbSk4yIXUkUPcfpdCnNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TZjEK4WZ; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-627e6fe0303so10762577b3.2
        for <kvm@vger.kernel.org>; Mon, 10 Jun 2024 17:22:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718065325; x=1718670125; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jRq1E0P4aXnPxzizQoW47AD5YHVJpyUxzEyvFYZC4Cg=;
        b=TZjEK4WZwZ76giyek/t3eOXFi+uTvRozz66gAy0/6tplI1prNKfNY+9srtusq1Qnfi
         7yHnN8Kcony3GRhEb36lxiNA0dbz8t0SzLM89zGHxAk+c0gcani93hNDC9jec5Gc1cjE
         am0jgkEGtfnUAn4grOC5X+DAPasQyOh+NUvLXfu+RtwVYGjlGPHkXjUSnsxh/Oo1Hl5w
         Uc9XvcQTl8NDjmuURlhezE0iC0s9TKyasXpiAJERxsD1Lkv4phQ4dYsDDR3dMSFuK825
         UOneVzphlQsFSh2ZcFRSP+L7OrpeWeXo2LfRssAR+j2AshUchDiDMsrivfsnt7B8MfS9
         874g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718065325; x=1718670125;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jRq1E0P4aXnPxzizQoW47AD5YHVJpyUxzEyvFYZC4Cg=;
        b=M0TVb/1qAOUeB56lIIfk5F1l0GXfyCfMPA5hSr+GFVZt3yoddLRDcLnbrjzt0BDagg
         uEIVYrSvvOrGUTxnM3Pb1WspsAFGHavvdjTib3Q5k/mIKkauxMAZtEEphOy6I5DG0xsd
         TDBfeOgx/Jz9jcUG57xunkMM2g6yTe+OHJtR3LG2+KElriZTi6wX7Y3kE5yo+LLWQZI+
         jdkYo8aKwkQX5iPJ9bP6jlJ/LeGKz/iml/f6nVdT8Elaoah0DC+MWNJAMQ+tLJKpPaHw
         p6cVvPslCnZfC/VgCoRyumTC6il2m/wOUAgSms1ra2aBAm1PRSJkQ4ZcHZDxtD2VqbTr
         0Hpg==
X-Forwarded-Encrypted: i=1; AJvYcCXOTlm8dBk1TrkVhDPrSjF5vqh83KOT++0bwQbJQqt4+gcUYANYGr7ZVgADQ6rJgi7b5GmELhOWZkURxO2cm4Q6JXrZ
X-Gm-Message-State: AOJu0YxtjVhg0bHIRFaZ63Amj0OMbp7Xjg2i7EZfbSBPwGpaEHtpxt5o
	8VDObrzrKyN+gU2gSlZqh9UcqAn13FxeZ6AgNjQzDhm6kbmFU9mAb13ylmdHIB8n2Or7UIwdLEf
	2uNGZCwAyk/G+6akhaQ==
X-Google-Smtp-Source: AGHT+IFmXdVsVq2jHeT0x/0hUnfSFWa7WYtFFT8Isj0HD4sG8F4BOnOmk4JS+KLDOFafX3S7G6SXbQD7sfuchknU
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:2a4f])
 (user=jthoughton job=sendgmr) by 2002:a05:690c:fca:b0:62c:fa1a:21d2 with SMTP
 id 00721157ae682-62cfa1a282cmr21119147b3.1.1718065324978; Mon, 10 Jun 2024
 17:22:04 -0700 (PDT)
Date: Tue, 11 Jun 2024 00:21:43 +0000
In-Reply-To: <20240611002145.2078921-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240611002145.2078921-1-jthoughton@google.com>
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Message-ID: <20240611002145.2078921-8-jthoughton@google.com>
Subject: [PATCH v5 7/9] KVM: x86: Implement kvm_fast_test_age_gfn and kvm_fast_age_gfn
From: James Houghton <jthoughton@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Ankit Agrawal <ankita@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, James Houghton <jthoughton@google.com>, 
	James Morse <james.morse@arm.com>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Raghavendra Rao Ananta <rananta@google.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Sean Christopherson <seanjc@google.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Wei Xu <weixugc@google.com>, Will Deacon <will@kernel.org>, Yu Zhao <yuzhao@google.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"

The fast-only notifier will only report an accurate result when the
shadow MMU is not in use.

Implement kvm_arch_young_notifier_likely_fast(), as MGLRU will check
this function to see if it should even be attempting the fast-only
notifier. We only want to attempt the notifier if there is a chance that
it will succeed (i.e., that we're using the TDP MMU).

Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/x86/include/asm/kvm_host.h |  7 +++++
 arch/x86/kvm/Kconfig            |  1 +
 arch/x86/kvm/mmu/mmu.c          | 50 ++++++++++++++++++++++++++++++---
 3 files changed, 54 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 0dc1fa99cdbb..ca2fbc162e51 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2338,4 +2338,11 @@ int memslot_rmap_alloc(struct kvm_memory_slot *slot, unsigned long npages);
  */
 #define KVM_EXIT_HYPERCALL_MBZ		GENMASK_ULL(31, 1)
 
+#define kvm_arch_young_notifier_likely_fast kvm_arch_young_notifier_likely_fast
+static inline bool kvm_arch_young_notifier_likely_fast(void)
+{
+	return IS_ENABLED(CONFIG_X86_64) && tdp_mmu_enabled &&
+		shadow_accessed_mask;
+}
+
 #endif /* _ASM_X86_KVM_HOST_H */
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 9dda7f8c72ed..84ae043c7d43 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -24,6 +24,7 @@ config KVM
 	select KVM_COMMON
 	select KVM_GENERIC_MMU_NOTIFIER
 	select KVM_MMU_NOTIFIER_YOUNG_LOCKLESS
+	select HAVE_KVM_YOUNG_FAST_ONLY_NOTIFIER
 	select HAVE_KVM_IRQCHIP
 	select HAVE_KVM_PFNCACHE
 	select HAVE_KVM_DIRTY_RING_TSO
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 51061f1fb3d1..ed50e78755ab 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1629,11 +1629,15 @@ static void rmap_add(struct kvm_vcpu *vcpu, const struct kvm_memory_slot *slot,
 	__rmap_add(vcpu->kvm, cache, slot, spte, gfn, access);
 }
 
-bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+static int __kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range,
+			 bool fast_only)
 {
 	bool young = false;
 
 	if (kvm_memslots_have_rmaps(kvm)) {
+		if (fast_only)
+			return -1;
+
 		write_lock(&kvm->mmu_lock);
 		young = kvm_handle_gfn_range(kvm, range, kvm_age_rmap);
 		write_unlock(&kvm->mmu_lock);
@@ -1642,14 +1646,18 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	if (tdp_mmu_enabled)
 		young |= kvm_tdp_mmu_age_gfn_range(kvm, range);
 
-	return young;
+	return (int)young;
 }
 
-bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+static int __kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range,
+			      bool fast_only)
 {
 	bool young = false;
 
 	if (kvm_memslots_have_rmaps(kvm)) {
+		if (fast_only)
+			return -1;
+
 		write_lock(&kvm->mmu_lock);
 		young = kvm_handle_gfn_range(kvm, range, kvm_test_age_rmap);
 		write_unlock(&kvm->mmu_lock);
@@ -1658,7 +1666,41 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	if (tdp_mmu_enabled)
 		young |= kvm_tdp_mmu_test_age_gfn(kvm, range);
 
-	return young;
+	return (int)young;
+}
+
+bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+{
+	return __kvm_age_gfn(kvm, range, false);
+}
+
+bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+{
+	return __kvm_test_age_gfn(kvm, range, false);
+}
+
+bool kvm_fast_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+{
+	int ret = __kvm_age_gfn(kvm, range, true);
+
+	if (ret < 0) {
+		*range->arg.failed = true;
+		return false;
+	}
+
+	return ret != 0;
+}
+
+bool kvm_fast_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+{
+	int ret = __kvm_test_age_gfn(kvm, range, true);
+
+	if (ret < 0) {
+		*range->arg.failed = true;
+		return false;
+	}
+
+	return ret != 0;
 }
 
 static void kvm_mmu_check_sptes_at_free(struct kvm_mmu_page *sp)
-- 
2.45.2.505.gda0bf45e8d-goog


