Return-Path: <kvm+bounces-23715-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4108894D441
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 18:12:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A86F81F22991
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 16:12:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4903C19ADAC;
	Fri,  9 Aug 2024 16:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EzKgwvCp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07DDA19AA7A
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 16:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723219777; cv=none; b=Nf7M8ZRfwsduYq7CnyUD40UPsGvuMWu6ndzPg2zZaIF1KyFiI45dKia0ggJzSoa1aV78BbeDc4gAA95pMQY9B3mZ1AWJt0wvVE1Tqr67lsxR4Vo2J0R1UX6X43C5cr6Kgu8bjA2UTG0+CvO6vuazXTcWKZS9n5JSbLC+ykoSmaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723219777; c=relaxed/simple;
	bh=KGvOFcjjnMZbGILhL/il8UWmtwN07FBEuaEKlUcuKek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nKJSIG6haHhLtah1wV/8qrh2FmhlcrEZ4UcYRDdp9xiWMuf5Kj2ZNYrFPeFxDXHEJkJ4t/gUTMP5yyd8QSgmwr+CTtOI2gG2MGjMkiN4v+6d1UTjpIHrJLpYODDRkTpem6qIk/7VgT2Fi2QkpCVWhW8oHhGnSELUN5xLqFU0v0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EzKgwvCp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723219775;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3aM3oVPeXmFPFf4Q68bjufzjsUq2ESmscQPnLEkaBB8=;
	b=EzKgwvCpMXxU9YgyJ7NmKvLgz6ByhsBcszjh8Z3ilu4mFQOtFV5B+Ps2fZ9GG1C8v8yBun
	Uadfrw257Flm8DUa4bRV04py/anO36iu9EIkEuHHPyfLrkyf0J2ObsAkbV/lbxoBuxWxtI
	NcLdEdg4uSduAMfp4IW2Ra5SsmfFr10=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-218-sLBCqYkvPVayT_rwR-P1WQ-1; Fri, 09 Aug 2024 12:09:33 -0400
X-MC-Unique: sLBCqYkvPVayT_rwR-P1WQ-1
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-45009e27b83so4905401cf.1
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 09:09:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723219773; x=1723824573;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3aM3oVPeXmFPFf4Q68bjufzjsUq2ESmscQPnLEkaBB8=;
        b=hPq6V2Hx+mzsf4kbDZ68msyzooAzYAV8o4NYdxLpkTV81e8nAToxk0BnrGWyL0xL0F
         y1MrF9WEMQJBMLEze8WGrnm4PPVQew/gViC3DP3/x1patbnMAIgR20lkhLHteaqqg65T
         tDGkkSvs5iSQYj/BS7/I9/K2IYdIuQSm3j/ewEM4wrULLAq/6HQeWrz2jMH0LZCnXbjb
         Qv2gO4a28MvGjVNwpVD6kLSQJNknY8GesUyJxV/OnmCGS8O1VM+gtnhQZgsc0fqlvP0M
         mv/UisIMg3K0bhnGYyZPXGV+eSE27UkZMoEVSyKOMIeWgbo10aG8RR3S6GdNHqIa1a17
         3mlQ==
X-Forwarded-Encrypted: i=1; AJvYcCVuVv8V06y3uww067ea27Ws7eaYz0NE/i3Oysam0OSDWukbPjJBGkSmEPuNEkVEfBfhTgL/HP6zuvkYT0FiJlBWWkHD
X-Gm-Message-State: AOJu0Yz6ClATZR94YdP7xawnpJSth9AaFdvgTm025dfL2BUccE0Riage
	t02wXBPcPWW6hWNxOscAnxICDj1ZRBsrFwZUtMb48V4TKlG0GZPumS7ZBaH/b619OvJJ07S9BIk
	AkIui+cMzYOnVziNhWra3+iCO0RO3jAcGHqFxF217GbOphGS05Q==
X-Received: by 2002:ac8:5f10:0:b0:450:349:1170 with SMTP id d75a77b69052e-4531255c62dmr14739801cf.6.1723219773082;
        Fri, 09 Aug 2024 09:09:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE6GyuXgyukqToIMYwmYCyyJms6T0RBSwsqvRpSKO6DWSQsB926zH9/mqcqwcpfSE6Nqd5Tsw==
X-Received: by 2002:ac8:5f10:0:b0:450:349:1170 with SMTP id d75a77b69052e-4531255c62dmr14739431cf.6.1723219772696;
        Fri, 09 Aug 2024 09:09:32 -0700 (PDT)
Received: from x1n.redhat.com (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-451c870016csm22526741cf.19.2024.08.09.09.09.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Aug 2024 09:09:32 -0700 (PDT)
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
Subject: [PATCH 08/19] mm: Always define pxx_pgprot()
Date: Fri,  9 Aug 2024 12:08:58 -0400
Message-ID: <20240809160909.1023470-9-peterx@redhat.com>
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

There're:

  - 8 archs (arc, arm64, include, mips, powerpc, s390, sh, x86) that
  support pte_pgprot().

  - 2 archs (x86, sparc) that support pmd_pgprot().

  - 1 arch (x86) that support pud_pgprot().

Always define them to be used in generic code, and then we don't need to
fiddle with "#ifdef"s when doing so.

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


