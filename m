Return-Path: <kvm+bounces-13308-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 58B108947BC
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 01:31:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AA2A5B224DB
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 23:31:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F0DA5A0E3;
	Mon,  1 Apr 2024 23:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tVYpo58p"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ua1-f74.google.com (mail-ua1-f74.google.com [209.85.222.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFC3358138
	for <kvm@vger.kernel.org>; Mon,  1 Apr 2024 23:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712014204; cv=none; b=FLF2//MK1pcytG98QwDu1WGM6h/4kjNPHH952o3s9uDp6HUUt8RW/JWJxFuX8S6u1ARP1uJnyH7rQajnQySp/PSkF0E1ODf8sAc4mkhtz4nwCeksyHkeaQrBmd1MijnPSNX5ESQibXp6Ouia3igbBcBAgHURHm+pBEYnn11oOLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712014204; c=relaxed/simple;
	bh=87QQcxOMBIslu//WSbbGVjdKhxGANqTulxkoL+oJYVo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EAT0dVq+1AmBfrJcgiikU8bZ8HG5YJiP6K+N8GSWI24KL5Mz1GJA38dOM+a6vluuxMP9GET3SmGckgkWWFfi2kfbDtYkkSa1+evlb1/+1WoxROKF0vtTTvH3OiOi7jfoIg5dgDa3VNGwCnsbIbDs6JwLUZjBvijXuPZDPz7gLus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tVYpo58p; arc=none smtp.client-ip=209.85.222.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-ua1-f74.google.com with SMTP id a1e0cc1a2514c-7d48198d021so1223024241.1
        for <kvm@vger.kernel.org>; Mon, 01 Apr 2024 16:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712014201; x=1712619001; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PXGb1c3s19z+8U24R5nbxlFRwqU1gq1c8Sy/WKQX1Zo=;
        b=tVYpo58ph/mGN2tzlhUjbUuKKa6493hDaeAtfnvWMLcMqvl7KmDNYxGDkkwG121M0S
         DG1WQ/iHYJm6JmIaLhakVh5PVlKY7VBUAWVG58ltcS6/nK5cE4LNYkJTmvIb9/SIccKR
         3hG6qVAFIeu16zQqAzIpHYS8jKeYL+d4l70iCGQ39+26GeYcCc0Ra0pPHsTbBHKHn8Y4
         uzg6km64ogbA8kzaws+2vqOvsr1lNS6faeSRSZr4oBvTkiThHRdagk55GJAyrPOWS5Ds
         b2AwGMvBAcBPadXevfE+7OhDsedUzKDtTt2S9yP/capsiW3CFjFb7Fm72ZfwDGD/Dzo0
         /6sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712014201; x=1712619001;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PXGb1c3s19z+8U24R5nbxlFRwqU1gq1c8Sy/WKQX1Zo=;
        b=qNv0Wo/E1fcoPEokOR6IfSFBClDSXuCzjB7HTCOzcDJJVnZJk6JcfMn4n+E/damuRd
         Ty239YVGVu5y+OKsD2fp6YekeBFoutvP8NZgwrXONgcXaISRjdvgtVEP9wJHIMRtgyij
         th5/iu0M1mnKwWln0F29Jda0mipB/cQ9H/fw2tEk+QBzRXkuIrffQ6WegiQXxf8HikNr
         oW95U+Bigj1yiNRsCUJybSoKJo/0+n0udOurjAmNs2GT+vdjKuxgqYLTS0Q4kj0Z81z4
         6szl+0susqVvxmOG/zwNETve3qBLkgymIW59sVXDIIzoSAVd2MdiX7rukKkHxJWNAOi6
         Y6Bg==
X-Forwarded-Encrypted: i=1; AJvYcCUhJ3ITvklgoJtbl7IMT3b7P254lxGH9mQbgBvk+WApYlRf5GAst3BhU495CLFq2qboeBWZKBm0CbUoazq5j+amCPCv
X-Gm-Message-State: AOJu0YxvZSXfDBAyfg/98uS6ndnE4J3NGzvR9eDG46Q1W+CEC9yrQA4b
	6KdS2NIXqMTi4mbVRPgTVVKzwA4mwaY4bAvgbJrGqJA/+A6KkrRe1yKbGOUcRU2UD9Yvt6Kuedt
	nDKbErle9Fho1Cmj1aQ==
X-Google-Smtp-Source: AGHT+IHiAeh9QdQ8JIxLLHU+30Xn5sQK+tQdEgkzewt+NNIBZBtyidDAUXciX6U3q2UCp3x2qiBYdkguFZKdqu9L
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:2a4f])
 (user=jthoughton job=sendgmr) by 2002:ab0:3792:0:b0:7e3:297b:9df1 with SMTP
 id d18-20020ab03792000000b007e3297b9df1mr67902uav.1.1712014200934; Mon, 01
 Apr 2024 16:30:00 -0700 (PDT)
Date: Mon,  1 Apr 2024 23:29:44 +0000
In-Reply-To: <20240401232946.1837665-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240401232946.1837665-1-jthoughton@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240401232946.1837665-6-jthoughton@google.com>
Subject: [PATCH v3 5/7] KVM: x86: Participate in bitmap-based PTE aging
From: James Houghton <jthoughton@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Yu Zhao <yuzhao@google.com>, David Matlack <dmatlack@google.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Sean Christopherson <seanjc@google.com>, Jonathan Corbet <corbet@lwn.net>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Gavin Shan <gshan@redhat.com>, Ricardo Koller <ricarkol@google.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	David Rientjes <rientjes@google.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Only handle the TDP MMU case for now. In other cases, if a bitmap was
not provided, fallback to the slowpath that takes mmu_lock, or, if a
bitmap was provided, inform the caller that the bitmap is unreliable.

Suggested-by: Yu Zhao <yuzhao@google.com>
Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/x86/include/asm/kvm_host.h | 14 ++++++++++++++
 arch/x86/kvm/mmu/mmu.c          | 16 ++++++++++++++--
 arch/x86/kvm/mmu/tdp_mmu.c      | 10 +++++++++-
 3 files changed, 37 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3b58e2306621..c30918d0887e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2324,4 +2324,18 @@ int memslot_rmap_alloc(struct kvm_memory_slot *slot, unsigned long npages);
  */
 #define KVM_EXIT_HYPERCALL_MBZ		GENMASK_ULL(31, 1)
 
+#define kvm_arch_prepare_bitmap_age kvm_arch_prepare_bitmap_age
+static inline bool kvm_arch_prepare_bitmap_age(struct mmu_notifier *mn)
+{
+	/*
+	 * Indicate that we support bitmap-based aging when using the TDP MMU
+	 * and the accessed bit is available in the TDP page tables.
+	 *
+	 * We have no other preparatory work to do here, so we do not need to
+	 * redefine kvm_arch_finish_bitmap_age().
+	 */
+	return IS_ENABLED(CONFIG_X86_64) && tdp_mmu_enabled
+					 && shadow_accessed_mask;
+}
+
 #endif /* _ASM_X86_KVM_HOST_H */
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 992e651540e8..fae1a75750bb 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1674,8 +1674,14 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	bool young = false;
 
-	if (kvm_memslots_have_rmaps(kvm))
+	if (kvm_memslots_have_rmaps(kvm)) {
+		if (range->lockless) {
+			kvm_age_set_unreliable(range);
+			return false;
+		}
+
 		young = kvm_handle_gfn_range(kvm, range, kvm_age_rmap);
+	}
 
 	if (tdp_mmu_enabled)
 		young |= kvm_tdp_mmu_age_gfn_range(kvm, range);
@@ -1687,8 +1693,14 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	bool young = false;
 
-	if (kvm_memslots_have_rmaps(kvm))
+	if (kvm_memslots_have_rmaps(kvm)) {
+		if (range->lockless) {
+			kvm_age_set_unreliable(range);
+			return false;
+		}
+
 		young = kvm_handle_gfn_range(kvm, range, kvm_test_age_rmap);
+	}
 
 	if (tdp_mmu_enabled)
 		young |= kvm_tdp_mmu_test_age_gfn(kvm, range);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index d078157e62aa..edea01bc145f 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1217,6 +1217,9 @@ static bool age_gfn_range(struct kvm *kvm, struct tdp_iter *iter,
 	if (!is_accessed_spte(iter->old_spte))
 		return false;
 
+	if (!kvm_gfn_should_age(range, iter->gfn))
+		return false;
+
 	if (spte_ad_enabled(iter->old_spte)) {
 		iter->old_spte = tdp_mmu_clear_spte_bits(iter->sptep,
 							 iter->old_spte,
@@ -1250,7 +1253,12 @@ bool kvm_tdp_mmu_age_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 static bool test_age_gfn(struct kvm *kvm, struct tdp_iter *iter,
 			 struct kvm_gfn_range *range)
 {
-	return is_accessed_spte(iter->old_spte);
+	bool young = is_accessed_spte(iter->old_spte);
+
+	if (young)
+		kvm_gfn_record_young(range, iter->gfn);
+
+	return young;
 }
 
 bool kvm_tdp_mmu_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
-- 
2.44.0.478.gd926399ef9-goog


