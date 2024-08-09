Return-Path: <kvm+bounces-23726-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DDA194D45A
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 18:16:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 97CC4B24B4F
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 16:16:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1276D19EEC8;
	Fri,  9 Aug 2024 16:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Lpo0D3yx"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9DBA19E828
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 16:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723219799; cv=none; b=p2enzGrjjrbiKDLMoVxbVyMZu7gFrcL3PzZFRs+B3i81r2MFg83k5Tffjc+KypNwCjuFV9PiV3lm/trwog/53l+nV6+CKQUfWFqFApSU8tJtFRAf4sTdM89eW0PxkIB0oz8Onngrr1up3Ic+weol2pxCNBsgB1iAjRUV/HdTRdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723219799; c=relaxed/simple;
	bh=Pk1TeOIKWSjAqBlIFkGydJm2rF11Zc/q9MVN9zTRZbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mxYCQPi1DvTkc0rjulFwLOz/YiPOqMpGy/8TXTa/jA+GjiZsaFt19jFSzqL74YHSM+UUUR0Tbb4MVtP2EyGLEgJbHvCUNAMR7vZz6tj9DGCT1M0Ywa2dDqsPCNdobxkacJHQGhfYQiFZlZiGqrgZldG5aTi1wBcLXfqkUwF1B/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Lpo0D3yx; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723219796;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UM853E440qfXKYz7avWh673RydKsfl7XbVKvi0Id2+c=;
	b=Lpo0D3yxB98V3pjIwIbcRmR0iGbEGA4mNWJ13SnVz9N9BqWg9G6VEm/G581C02CiT3hToL
	uxvjbKAsyPwjyHH5cHmxh34+glNxbJFRAR2aJmwcCq2sQsKHxS8WzpoPST0CoJvBbr0elp
	+H2h/9g/RiXcJgWnHyMWcB0xYQXTNlc=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-54-YHPtvVxrN7iRc0NFCikK7A-1; Fri, 09 Aug 2024 12:09:55 -0400
X-MC-Unique: YHPtvVxrN7iRc0NFCikK7A-1
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-44ff585970bso4757171cf.2
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 09:09:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723219795; x=1723824595;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UM853E440qfXKYz7avWh673RydKsfl7XbVKvi0Id2+c=;
        b=XyBoxmrRAqp5Em0FfsaTjEOk+zwlHeWJgCvSPepUGCqXoaFaXLLMClf0BZ24SSsuoy
         Uq/qwKuSrQSB2yXnCpoYjwJ3cQ81E4+GcAPFbIvkUDRbgzzHecMkP1YYCpNqGMfrSI7j
         ZzGdyYgH8F4H879fg67SIC3c+R4saCbvVZViWMUMGOgX3FfM2Fg7Uv/WDvr/4EqIZUJ2
         LEWpj1FTXZIq2O9Gh73NeKi8iD+iLKHzV490CxfR818XkXGUsqL7pWKkuhyQCryCjypI
         eaDbo9EIhQS1w7myDOMyN8RorN58spHR4INYVIfw0/URM6GGaY//X3gIhVjzJQ/5GDk8
         XbZg==
X-Forwarded-Encrypted: i=1; AJvYcCVnFZ9mTJSg5KmbyPBwDDwD327jgMfiTiHgBu9q+Cr9oayKAguLECECrw60aAP3S8eMUS4fK32X9c49G0FU8NMXDjbM
X-Gm-Message-State: AOJu0YyIxet0rX2RbpYzo+i/uIqJqZ+mdr0eoVObbv43IvvvdBUllBlG
	oIaoLO1LBltVVHMPVmr8z4ikM8/K9TRAvnze5P8KzFBQaSmLzvqzadfwgY/AjvTXk4khPNBnzY5
	g91t/Fbx61QJhYcIYhY6icCtW+oTgYanxvZlPGasxiq4KaGJDBQ==
X-Received: by 2002:ac8:5e07:0:b0:44e:cff7:3741 with SMTP id d75a77b69052e-45312646da2mr14006661cf.7.1723219795211;
        Fri, 09 Aug 2024 09:09:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEzDYjFq+v9SYAdrw2G1PaR/i1nnMK5UGwVdyzJwk9mK3TcvaabWRsZT43a6L+rPfA/Jc6OAg==
X-Received: by 2002:ac8:5e07:0:b0:44e:cff7:3741 with SMTP id d75a77b69052e-45312646da2mr14006381cf.7.1723219794745;
        Fri, 09 Aug 2024 09:09:54 -0700 (PDT)
Received: from x1n.redhat.com (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-451c870016csm22526741cf.19.2024.08.09.09.09.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Aug 2024 09:09:54 -0700 (PDT)
From: Peter Xu <peterx@redhat.com>
To: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	peterx@redhat.com,
	Will Deacon <will@kernel.org>,
	Gavin Shan <gshan@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Alistair Popple <apopple@nvidia.com>,
	Borislav Petkov <bp@alien8.de>,
	David Hildenbrand <david@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	kvm@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH 18/19] mm/arm64: Support large pfn mappings
Date: Fri,  9 Aug 2024 12:09:08 -0400
Message-ID: <20240809160909.1023470-19-peterx@redhat.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240809160909.1023470-1-peterx@redhat.com>
References: <20240809160909.1023470-1-peterx@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Support huge pfnmaps by using bit 56 (PTE_SPECIAL) for "special" on
pmds/puds.  Provide the pmd/pud helpers to set/get special bit.

There's one more thing missing for arm64 which is the pxx_pgprot() for
pmd/pud.  Add them too, which is mostly the same as the pte version by
dropping the pfn field.  These helpers are essential to be used in the new
follow_pfnmap*() API to report valid pgprot_t results.

Note that arm64 doesn't yet support huge PUD yet, but it's still
straightforward to provide the pud helpers that we need altogether.  Only
PMD helpers will make an immediate benefit until arm64 will support huge
PUDs first in general (e.g. in THPs).

Cc: linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/arm64/Kconfig               |  1 +
 arch/arm64/include/asm/pgtable.h | 29 +++++++++++++++++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index b3fc891f1544..5f026b95f309 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -99,6 +99,7 @@ config ARM64
 	select ARCH_SUPPORTS_NUMA_BALANCING
 	select ARCH_SUPPORTS_PAGE_TABLE_CHECK
 	select ARCH_SUPPORTS_PER_VMA_LOCK
+	select ARCH_SUPPORTS_HUGE_PFNMAP if TRANSPARENT_HUGEPAGE
 	select ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH
 	select ARCH_WANT_COMPAT_IPC_PARSE_VERSION if COMPAT
 	select ARCH_WANT_DEFAULT_BPF_JIT
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index b78cc4a6758b..2faecc033a19 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -578,6 +578,14 @@ static inline pmd_t pmd_mkdevmap(pmd_t pmd)
 	return pte_pmd(set_pte_bit(pmd_pte(pmd), __pgprot(PTE_DEVMAP)));
 }
 
+#ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
+#define pmd_special(pte)	(!!((pmd_val(pte) & PTE_SPECIAL)))
+static inline pmd_t pmd_mkspecial(pmd_t pmd)
+{
+	return set_pmd_bit(pmd, __pgprot(PTE_SPECIAL));
+}
+#endif
+
 #define __pmd_to_phys(pmd)	__pte_to_phys(pmd_pte(pmd))
 #define __phys_to_pmd_val(phys)	__phys_to_pte_val(phys)
 #define pmd_pfn(pmd)		((__pmd_to_phys(pmd) & PMD_MASK) >> PAGE_SHIFT)
@@ -595,6 +603,27 @@ static inline pmd_t pmd_mkdevmap(pmd_t pmd)
 #define pud_pfn(pud)		((__pud_to_phys(pud) & PUD_MASK) >> PAGE_SHIFT)
 #define pfn_pud(pfn,prot)	__pud(__phys_to_pud_val((phys_addr_t)(pfn) << PAGE_SHIFT) | pgprot_val(prot))
 
+#ifdef CONFIG_ARCH_SUPPORTS_PUD_PFNMAP
+#define pud_special(pte)	pte_special(pud_pte(pud))
+#define pud_mkspecial(pte)	pte_pud(pte_mkspecial(pud_pte(pud)))
+#endif
+
+#define pmd_pgprot pmd_pgprot
+static inline pgprot_t pmd_pgprot(pmd_t pmd)
+{
+	unsigned long pfn = pmd_pfn(pmd);
+
+	return __pgprot(pmd_val(pfn_pmd(pfn, __pgprot(0))) ^ pmd_val(pmd));
+}
+
+#define pud_pgprot pud_pgprot
+static inline pgprot_t pud_pgprot(pud_t pud)
+{
+	unsigned long pfn = pud_pfn(pud);
+
+	return __pgprot(pud_val(pfn_pud(pfn, __pgprot(0))) ^ pud_val(pud));
+}
+
 static inline void __set_pte_at(struct mm_struct *mm,
 				unsigned long __always_unused addr,
 				pte_t *ptep, pte_t pte, unsigned int nr)
-- 
2.45.0


