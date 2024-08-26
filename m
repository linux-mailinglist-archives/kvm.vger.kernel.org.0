Return-Path: <kvm+bounces-25088-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FE5E95FAD3
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 22:46:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 84E811C220C2
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 20:46:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE51019E7FA;
	Mon, 26 Aug 2024 20:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cqn1o6Yk"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA7019DFB6
	for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 20:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724705057; cv=none; b=dmmlf0P7Ng/O31zaCSzVPw+aof/t2y3+G2DvhkVb/p26ELKCX99ypUR+BBBZCsGp/kKdkSueYYztidSwoC3owVBJbgvxEPiBdCGLvbqw/9c0juTPXO//LZXxnEMTZtVCDNXI0hkBWc8N9tNiaoLGc4v2gY191XNnqlAAqGC/uHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724705057; c=relaxed/simple;
	bh=5m+a/sFeWuT8yBU8zTVl6UkOZQKWMf5wpgIpcmHb57A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bkPLZWwX6YE2PPZ8ng7ClwiEXQrekkixGOfkOdXPyUk7xwbheg45FDvD40hL1mzDQzzoNWQdYSrW/8Q2/g5dvnJn0peKMOPJAhbI06WdtHVoxCAE91gxhTUBvGWpWr6D9nb10NKWvNMMkRFnOFowAoD1t6mfUxQp1zMCsnRWlCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cqn1o6Yk; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724705055;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vK1PMhUcFVpQCvjQRaUqQOYBcILrsdr8yUlCuFWve7Q=;
	b=cqn1o6YkXtY2Da0jJ6CZFzfGjc/aMwAX/KqsM+od6aT9Llk2e2iSMpXjqrBOzYoQwwI6OZ
	RcM3dXMW0h38Nfa/pRkhQNGOrmtPudjG3Hij1X7bDT460Sl53PfjCOuyrVRCYyrsCuq3rF
	MekJBDmgUhW5JSeGQDqtbjMZ4jCjDcs=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-275-VQ5c9UaOOeKev-t9Zt5tcw-1; Mon, 26 Aug 2024 16:44:14 -0400
X-MC-Unique: VQ5c9UaOOeKev-t9Zt5tcw-1
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-6b351a76beeso102720317b3.0
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 13:44:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724705052; x=1725309852;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vK1PMhUcFVpQCvjQRaUqQOYBcILrsdr8yUlCuFWve7Q=;
        b=VWJEB+rDpRGrRumsM4XR4i+5BrB1AYOepJRlPZTZPc5GVUuH5NDHzfxlaF8aSuhPzh
         mBtH23MnZAPGfVJzCVbabMTY+30/kPY/ve53whKwbaYwNKkUGUXoR8Gv8dZ6XczL/+OO
         cwSsWckbq+r/sIr+qFgq+j+PFg+rRT0GujzbOxIC9ETIyRgJWKiWzf6noYmPtPqpcLW5
         uP+6roc2NXbYwOS/OiWi1SweozVMIERnawggJJFhnKhcvmTuyOZF6VKVTcPwbBrTsdPK
         +vpxP+107bCKpa9ozXEICYyn1PIH7LEsj2WA2bw8SZJyE1Qvi0M+7ckyzioH36VL4hIb
         O6HQ==
X-Forwarded-Encrypted: i=1; AJvYcCVFfp1Mg1ezQkWuiPhKAjPjE6QRjOhE3Wd4cHR4EeBM9iu2Z34ptragfWMVkZFRVYDcXsQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwcltE/fZ95T/zSiMxBv3hgvqJX10hVzKpc8/lOtRKS1A4Ivceu
	jJqNwl92Fq1XCXgZ672iwK4a21aeOXwv3M4EiSkVlLSwx03172RdgWtP2e1E4EmJD4Q2qlcciZw
	o0/ucus5YeLe7DYjD+CYOwiwPPKknIEQQclIsOsG6fDFlWe11yQ==
X-Received: by 2002:a05:690c:60c2:b0:6bd:fdd3:e170 with SMTP id 00721157ae682-6c624dc7042mr142338917b3.10.1724705052647;
        Mon, 26 Aug 2024 13:44:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEDLUzP2hp4LBST6IRuRTdz5MRV8z70t30cnU5hPcRwmZ021NQU+FxAT+ZUF1I58Qs4qkGJLg==
X-Received: by 2002:a05:690c:60c2:b0:6bd:fdd3:e170 with SMTP id 00721157ae682-6c624dc7042mr142338617b3.10.1724705052349;
        Mon, 26 Aug 2024 13:44:12 -0700 (PDT)
Received: from x1n.redhat.com (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a67f3fd6c1sm491055185a.121.2024.08.26.13.44.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2024 13:44:11 -0700 (PDT)
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
Subject: [PATCH v2 08/19] mm: Always define pxx_pgprot()
Date: Mon, 26 Aug 2024 16:43:42 -0400
Message-ID: <20240826204353.2228736-9-peterx@redhat.com>
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

There're:

  - 8 archs (arc, arm64, include, mips, powerpc, s390, sh, x86) that
  support pte_pgprot().

  - 2 archs (x86, sparc) that support pmd_pgprot().

  - 1 arch (x86) that support pud_pgprot().

Always define them to be used in generic code, and then we don't need to
fiddle with "#ifdef"s when doing so.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/arm64/include/asm/pgtable.h    |  1 +
 arch/powerpc/include/asm/pgtable.h  |  1 +
 arch/s390/include/asm/pgtable.h     |  1 +
 arch/sparc/include/asm/pgtable_64.h |  1 +
 include/linux/pgtable.h             | 12 ++++++++++++
 5 files changed, 16 insertions(+)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 7a4f5604be3f..b78cc4a6758b 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -384,6 +384,7 @@ static inline void __sync_cache_and_tags(pte_t pte, unsigned int nr_pages)
 /*
  * Select all bits except the pfn
  */
+#define pte_pgprot pte_pgprot
 static inline pgprot_t pte_pgprot(pte_t pte)
 {
 	unsigned long pfn = pte_pfn(pte);
diff --git a/arch/powerpc/include/asm/pgtable.h b/arch/powerpc/include/asm/pgtable.h
index 264a6c09517a..2f72ad885332 100644
--- a/arch/powerpc/include/asm/pgtable.h
+++ b/arch/powerpc/include/asm/pgtable.h
@@ -65,6 +65,7 @@ static inline unsigned long pte_pfn(pte_t pte)
 /*
  * Select all bits except the pfn
  */
+#define pte_pgprot pte_pgprot
 static inline pgprot_t pte_pgprot(pte_t pte)
 {
 	unsigned long pte_flags;
diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 3fa280d0672a..0ffbaf741955 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -955,6 +955,7 @@ static inline int pte_unused(pte_t pte)
  * young/old accounting is not supported, i.e _PAGE_PROTECT and _PAGE_INVALID
  * must not be set.
  */
+#define pte_pgprot pte_pgprot
 static inline pgprot_t pte_pgprot(pte_t pte)
 {
 	unsigned long pte_flags = pte_val(pte) & _PAGE_CHG_MASK;
diff --git a/arch/sparc/include/asm/pgtable_64.h b/arch/sparc/include/asm/pgtable_64.h
index 3fe429d73a65..2b7f358762c1 100644
--- a/arch/sparc/include/asm/pgtable_64.h
+++ b/arch/sparc/include/asm/pgtable_64.h
@@ -783,6 +783,7 @@ static inline pmd_t pmd_mkwrite_novma(pmd_t pmd)
 	return __pmd(pte_val(pte));
 }
 
+#define pmd_pgprot pmd_pgprot
 static inline pgprot_t pmd_pgprot(pmd_t entry)
 {
 	unsigned long val = pmd_val(entry);
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 780f3b439d98..e8b2ac6bd2ae 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1956,6 +1956,18 @@ typedef unsigned int pgtbl_mod_mask;
 #define MAX_PTRS_PER_P4D PTRS_PER_P4D
 #endif
 
+#ifndef pte_pgprot
+#define pte_pgprot(x) ((pgprot_t) {0})
+#endif
+
+#ifndef pmd_pgprot
+#define pmd_pgprot(x) ((pgprot_t) {0})
+#endif
+
+#ifndef pud_pgprot
+#define pud_pgprot(x) ((pgprot_t) {0})
+#endif
+
 /* description of effects of mapping type and prot in current implementation.
  * this is due to the limited x86 page protection hardware.  The expected
  * behavior is in parens:
-- 
2.45.0


