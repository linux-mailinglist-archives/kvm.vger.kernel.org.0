Return-Path: <kvm+bounces-49791-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 90592ADE25E
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 06:24:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C9A6F189CB56
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 04:25:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2ABA1F4717;
	Wed, 18 Jun 2025 04:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pwQ7m/aJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592411AA1F4
	for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 04:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750220671; cv=none; b=NiSeXI9I8rIw1D5vzvvxlLLEUJ0qLaevQ3LMLqfcg9sVd1wfZip9ffjL6Tt2ALxF8+zFUNKPYPSG/7GvSABPJyMT3KLiMXgbQu+XWKpAlvPASm65SA+cn3Xf8WVoW8Vvvy4RpsQ4gZ7PHt8bQCSV2dvXhMfjdL2Bl+2CoAMWiqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750220671; c=relaxed/simple;
	bh=eP46jQ+rNHU6ISgY5UQik8NONkiapiV65A0WTIlahXU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qNWCI86YGmVZPlgbrv+8rkjQZ06WhH14l450U3tZy7KI4GjwTZnDL2nF3wnH8uCrzckQOvb4g2MwO7UyJrmIcCFzU6ZA4/nkmqdxDCuBBVY/teh3/FFhRD5W2zeXp7zdaBmZ84O8VWEQA40lNqfXkZspTCOQCRMNndQhvtIX5HI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pwQ7m/aJ; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-235e7550f7bso59123285ad.3
        for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 21:24:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750220669; x=1750825469; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lktvEP9OF/yBrtwNGnOYj58Kkb3on7duF4eax38mNfc=;
        b=pwQ7m/aJYNJ9qV3WuTexPOQMqpZIK4AoG8+0A3J1DpKLxAKsmGL1uGACfRQcbNOO50
         iPiDFZFGqeebfMVOI9GvHQpWG8ywK9ywvc6CmSXN+CGtyGkt/G7KuXLG5h7H6J3b7/6D
         xo4GIJS1V7eaefRInasje6bPHU/5LflE7sR+SQJjxdI0fd833f6UUlyu+RVmcdciHFV6
         IOFhGS87/5NBbKNJPDp2dsVHWFZJf/NUjeQT3flpO1GbDZe4uiEWchAQ9EQlVbjdKSrZ
         tknF4o8W+XwzpRenq88txK/oQc1eGIRFiyeqqKz0Hlzvn2vKaBHCl1FlaXC5oabRPDPL
         ZyNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750220669; x=1750825469;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lktvEP9OF/yBrtwNGnOYj58Kkb3on7duF4eax38mNfc=;
        b=hSKA0dtfThLmJ0zRrHMJY6KuC5eT6BFdx0F/7KngENvGbinMmmYe98tRIEpJAo6Tet
         RhV407GmXpTAyREd8cXGsfnEYVy5OYj29JnF5gZdzuRcpU74V98IaV2pLyZa7MUsbVbA
         FNUCnAGHH58LCrqo7Uq9B+rtCpQAm271KjhTsYRnV2Dq8kPw96w2uijOoDfB/bqsgt0h
         O279Z+fKCpc4qf8eMXQlEPFlGjy/sHc/RkwKEMdWiRUWay9jhPPPZiyeXepQ4rG45WI2
         esZ+UxxWdt40ePOTu3EAZy0jVa85+ElsSV9Z1XO3ceO5mqiXXa874kpKTnWatOUWzJmY
         DgiQ==
X-Forwarded-Encrypted: i=1; AJvYcCUvwBpZMkfBkYqSx+b97H5zgg4Ba9zD1KzL9mG9JaJOMUl8L+fWyzU8zGATEowtT5mMccQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyvhLBkauMgIMiNhoGUD0i9N3n6uT6vx30DglRXyslrTaw0n3Kp
	aL1n/KzRuGTKqYVnLwPcCMHhsv8Qy+6ekkyO655RbNXVCrJX3Va+kkjEvH5nUbiZ/wn2QC7noPi
	A7LIZApPqyya6uhpWcRiglg==
X-Google-Smtp-Source: AGHT+IFjtADbYlxljhsDQTOZW3D7A0uJ9AI1mGomIpn2hF7RaxHZsBqEwbheSqwAOtTN5nAEPPlQmENaTESm3DrC
X-Received: from pgbck15.prod.google.com ([2002:a05:6a02:90f:b0:b2c:4bfe:fb79])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:da81:b0:234:a063:e2c1 with SMTP id d9443c01a7336-2366b17b667mr224708415ad.42.1750220668697;
 Tue, 17 Jun 2025 21:24:28 -0700 (PDT)
Date: Wed, 18 Jun 2025 04:24:10 +0000
In-Reply-To: <20250618042424.330664-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250618042424.330664-1-jthoughton@google.com>
X-Mailer: git-send-email 2.50.0.rc2.696.g1fc2a0284f-goog
Message-ID: <20250618042424.330664-2-jthoughton@google.com>
Subject: [PATCH v3 01/15] KVM: x86/mmu: Move "struct kvm_page_fault"
 definition to asm/kvm_host.h
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Oliver Upton <oliver.upton@linux.dev>
Cc: Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	James Houghton <jthoughton@google.com>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Anish Moorthy <amoorthy@google.com>, Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

From: Sean Christopherson <seanjc@google.com>

Make "struct kvm_page_fault" globally visible via asm/kvm_host.h so that
the structure can be referenced by common KVM.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/x86/include/asm/kvm_host.h | 68 ++++++++++++++++++++++++++++++++-
 arch/x86/kvm/mmu/mmu_internal.h | 67 --------------------------------
 2 files changed, 67 insertions(+), 68 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b4a391929cdba..f9d3333f6d64b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -443,7 +443,73 @@ struct kvm_mmu_root_info {
 #define KVM_HAVE_MMU_RWLOCK
 
 struct kvm_mmu_page;
-struct kvm_page_fault;
+
+struct kvm_page_fault {
+	/* arguments to kvm_mmu_do_page_fault.  */
+	const gpa_t addr;
+	const u64 error_code;
+	const bool prefetch;
+
+	/* Derived from error_code.  */
+	const bool exec;
+	const bool write;
+	const bool present;
+	const bool rsvd;
+	const bool user;
+
+	/* Derived from mmu and global state.  */
+	const bool is_tdp;
+	const bool is_private;
+	const bool nx_huge_page_workaround_enabled;
+
+	/*
+	 * Whether a >4KB mapping can be created or is forbidden due to NX
+	 * hugepages.
+	 */
+	bool huge_page_disallowed;
+
+	/*
+	 * Maximum page size that can be created for this fault; input to
+	 * FNAME(fetch), direct_map() and kvm_tdp_mmu_map().
+	 */
+	u8 max_level;
+
+	/*
+	 * Page size that can be created based on the max_level and the
+	 * page size used by the host mapping.
+	 */
+	u8 req_level;
+
+	/*
+	 * Page size that will be created based on the req_level and
+	 * huge_page_disallowed.
+	 */
+	u8 goal_level;
+
+	/*
+	 * Shifted addr, or result of guest page table walk if addr is a gva. In
+	 * the case of VM where memslot's can be mapped at multiple GPA aliases
+	 * (i.e. TDX), the gfn field does not contain the bit that selects between
+	 * the aliases (i.e. the shared bit for TDX).
+	 */
+	gfn_t gfn;
+
+	/* The memslot containing gfn. May be NULL. */
+	struct kvm_memory_slot *slot;
+
+	/* Outputs of kvm_mmu_faultin_pfn().  */
+	unsigned long mmu_seq;
+	kvm_pfn_t pfn;
+	struct page *refcounted_page;
+	bool map_writable;
+
+	/*
+	 * Indicates the guest is trying to write a gfn that contains one or
+	 * more of the PTEs used to translate the write itself, i.e. the access
+	 * is changing its own translation in the guest page tables.
+	 */
+	bool write_fault_to_shadow_pgtable;
+};
 
 /*
  * x86 supports 4 paging modes (5-level 64-bit, 4-level 64-bit, 3-level 32-bit,
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index db8f33e4de624..384fc4d0bfec0 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -230,73 +230,6 @@ static inline bool is_nx_huge_page_enabled(struct kvm *kvm)
 	return READ_ONCE(nx_huge_pages) && !kvm->arch.disable_nx_huge_pages;
 }
 
-struct kvm_page_fault {
-	/* arguments to kvm_mmu_do_page_fault.  */
-	const gpa_t addr;
-	const u64 error_code;
-	const bool prefetch;
-
-	/* Derived from error_code.  */
-	const bool exec;
-	const bool write;
-	const bool present;
-	const bool rsvd;
-	const bool user;
-
-	/* Derived from mmu and global state.  */
-	const bool is_tdp;
-	const bool is_private;
-	const bool nx_huge_page_workaround_enabled;
-
-	/*
-	 * Whether a >4KB mapping can be created or is forbidden due to NX
-	 * hugepages.
-	 */
-	bool huge_page_disallowed;
-
-	/*
-	 * Maximum page size that can be created for this fault; input to
-	 * FNAME(fetch), direct_map() and kvm_tdp_mmu_map().
-	 */
-	u8 max_level;
-
-	/*
-	 * Page size that can be created based on the max_level and the
-	 * page size used by the host mapping.
-	 */
-	u8 req_level;
-
-	/*
-	 * Page size that will be created based on the req_level and
-	 * huge_page_disallowed.
-	 */
-	u8 goal_level;
-
-	/*
-	 * Shifted addr, or result of guest page table walk if addr is a gva. In
-	 * the case of VM where memslot's can be mapped at multiple GPA aliases
-	 * (i.e. TDX), the gfn field does not contain the bit that selects between
-	 * the aliases (i.e. the shared bit for TDX).
-	 */
-	gfn_t gfn;
-
-	/* The memslot containing gfn. May be NULL. */
-	struct kvm_memory_slot *slot;
-
-	/* Outputs of kvm_mmu_faultin_pfn().  */
-	unsigned long mmu_seq;
-	kvm_pfn_t pfn;
-	struct page *refcounted_page;
-	bool map_writable;
-
-	/*
-	 * Indicates the guest is trying to write a gfn that contains one or
-	 * more of the PTEs used to translate the write itself, i.e. the access
-	 * is changing its own translation in the guest page tables.
-	 */
-	bool write_fault_to_shadow_pgtable;
-};
-
 int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
 
 /*
-- 
2.50.0.rc2.692.g299adb8693-goog


