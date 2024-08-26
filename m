Return-Path: <kvm+bounces-25098-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0063C95FAEA
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 22:49:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 09D8F1C22799
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 20:49:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF7EE1A2557;
	Mon, 26 Aug 2024 20:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GCF8AjKH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 671C81A0B05
	for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 20:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724705078; cv=none; b=TNJ1jZ38ZxNfxnNec317Y49o/1KmqMJ1265ywTJNJhRuQm9JZjRZGAXek05o/sgRdgS7098qBfUUBHCVWioAnabBpxpKK42ABV8vmok22akaDnw+sMALhBtOWmVQ+2Fu7uPs3qplfrlJ16CfWcMzLTTB8B8JrZrHfIH//Y+lBo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724705078; c=relaxed/simple;
	bh=5/RkLDpH7n+0lRZdC6d7Fr9a2r7GbmT3sDiSd48lk+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EauaLnJvIn5nr+ThMaaoYB5WWFQWFcBeSzC+2Xd6UgGOjQTorG0msBtKMWqMgUYL5jmWMWKeP46GtMkwKsUzx0ZVKqVHFO5rMdKng5RzLedYeJL+m9fziOODVZ3oYOH5phIkPSImC9+iztNC0pZNyxrdm7fl3o7WppQ8wk/d5+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GCF8AjKH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724705076;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FEAM9DK74WZYySVYhL7YnC2YOY0xQ42haB8uzH2x2BY=;
	b=GCF8AjKHkwg96mBkzB2sBebZgDfnSkfAC0Za1lGOGjnaARDiYvn7h31mMK4R43Te9VqYmQ
	Uc30PlxK0U5SpwL9R4mfZ/JwKMxa4scuSYHxRyDNSGbSpQv+CYMbapSu2r9wC9bx1XUOJc
	g2gy2flvaF1+ohE+gwB/A0Dx0QH2dec=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-126-f4fLNMtDP7efYHp5vxZkAg-1; Mon, 26 Aug 2024 16:44:33 -0400
X-MC-Unique: f4fLNMtDP7efYHp5vxZkAg-1
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-7a1e9a3825aso606412085a.2
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 13:44:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724705072; x=1725309872;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FEAM9DK74WZYySVYhL7YnC2YOY0xQ42haB8uzH2x2BY=;
        b=D9gi/WTJRtmaaG6itass9Cb0eiThguXzdubRNbjFMQ/LSTPpYGflmtMutMKs6LM2TY
         SbcrqXhmAiYOELVaaI5Atho4AaWdDa/NI21zPqJxn753/ufDqcyYc2ZqZXUxGZlfrOD/
         WzfVhoVI/jd1L5O5q7YyBmnZF+vWfHot12FIF7M0eU2BF5QYuQHRV31zXp15JX9Aikwa
         +xjBEKX6+CMuXFbCEkZMk+XmEmcWfpPlW9U4MUUXpU0xHmGPpaVuKu93uXjF0MAO7uQl
         AaJDTrmZZq8rKCvdLznjIe4HyqwtZpKlILvi9BQ/48HVTRRiX/4s3E1wLtK6vKb92Ofc
         eopA==
X-Forwarded-Encrypted: i=1; AJvYcCU2wMGfmeH23+qEA1vq2yCcW1xGI9YGrQrGx95yq+JMPQPi5voNaJuw9lKcAKJnZ2WLv3s=@vger.kernel.org
X-Gm-Message-State: AOJu0YyrAsmfRoZUgUscjrjxdXdIMNbd4vJKxcD+Q/AoG39KoVqWwA8G
	lyNulllykyPdAPue9PijdNhMlNIDNAmbjMxjajmkiopzDvsXzQRFxQmTNry48l+HHGiX1pwqEK/
	+a1bNIW/D7/ruceViRSArJks61uS3xPqg9zAQxjfi4FcRWtQ0JQ==
X-Received: by 2002:a05:620a:430a:b0:7a4:faab:fc79 with SMTP id af79cd13be357-7a6896d1835mr1392500685a.8.1724705072553;
        Mon, 26 Aug 2024 13:44:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHDiJ56urcvTKu8a4/ieO25ZyreTkMfmYYALFQqTS8OY3wwzzWFQolk9khXQC+xv0hRJc4KwA==
X-Received: by 2002:a05:620a:430a:b0:7a4:faab:fc79 with SMTP id af79cd13be357-7a6896d1835mr1392497485a.8.1724705072141;
        Mon, 26 Aug 2024 13:44:32 -0700 (PDT)
Received: from x1n.redhat.com (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a67f3fd6c1sm491055185a.121.2024.08.26.13.44.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2024 13:44:31 -0700 (PDT)
From: Peter Xu <peterx@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Gavin Shan <gshan@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	x86@kernel.org,
	Ingo Molnar <mingo@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Alistair Popple <apopple@nvidia.com>,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Sean Christopherson <seanjc@google.com>,
	peterx@redhat.com,
	Oscar Salvador <osalvador@suse.de>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Borislav Petkov <bp@alien8.de>,
	Zi Yan <ziy@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	David Hildenbrand <david@redhat.com>,
	Yan Zhao <yan.y.zhao@intel.com>,
	Will Deacon <will@kernel.org>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH v2 18/19] mm/arm64: Support large pfn mappings
Date: Mon, 26 Aug 2024 16:43:52 -0400
Message-ID: <20240826204353.2228736-19-peterx@redhat.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240826204353.2228736-1-peterx@redhat.com>
References: <20240826204353.2228736-1-peterx@redhat.com>
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
index 6494848019a0..6607ed8fdbb4 100644
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


