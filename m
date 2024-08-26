Return-Path: <kvm+bounces-25087-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A842395FAD0
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 22:46:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5DD38286390
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 20:46:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 981F819DF95;
	Mon, 26 Aug 2024 20:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Mp/CL9LT"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA3C19DF49
	for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 20:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724705054; cv=none; b=cYK8CGkJnJ1PYY9ZS2P27thKBtCZnMt+mIDwodTaLPsOPNGVRfjAiAqo7hmXyjxPTmyfg/QPdXpLKH72ZT6YOdhbPL21u4qBE3IMwpm4kfUd8OjaTukCQL9hr70MCS53NkpZWApQPS8LLOwWWHA9QW9dUF/YRoSxNGCJuqxzFEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724705054; c=relaxed/simple;
	bh=2o5q081kpM9gqW6xM+rZ8YlKEO3D1caJMlb8NRd33tM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K2POPiZkO6yrdh9+UPW7Bujx6X/cGHu4GryRCShSTJdMcoswoKxAKFNJAD5ESoA7FH/I6sW0Fw7mLw+2pCoXOaZCHPd2mojQnGsK5AaJ27wansnEXh+tqhWybp7i1IV8Vr0eXeP9wNocVTr/9n8KoceApEDvk3m5MLMe6ZuMxn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Mp/CL9LT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724705052;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xat90K+7laktWlKWrEYj2NKDd4TQak32OHmU5MtaKmE=;
	b=Mp/CL9LTo0Q5866CqBhTpD+usRUcv+G+3B8fcVrnRFs0M7AuVpdqj1MYmrydyyaFdfDKet
	WEvWYGlLWht27HJeMAR9/OgDGmhIGaAx3YfuE5ffPzmZwi4Cp4Phr96/kU/68de2NTopkI
	VOQ5HfjQ0Xn2ZbiE267Tm9pyRfj+gic=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-528-vtdB0HNFOTSmQWSCHj8mfg-1; Mon, 26 Aug 2024 16:44:11 -0400
X-MC-Unique: vtdB0HNFOTSmQWSCHj8mfg-1
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-6ad26d5b061so84748757b3.2
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 13:44:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724705051; x=1725309851;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xat90K+7laktWlKWrEYj2NKDd4TQak32OHmU5MtaKmE=;
        b=H1m9xa2Q+8q+rwykUzTPMtDRtjK5FTSPaS1wIzcT3ZtZqm2wR4wlah9y9rZr+SZCVV
         NQP/2VC7/NaO4wOALCFRBPUMVuT1VnZg3p0NXY/Vpl7/B4Mod82FC/mLARlANpBRq+xB
         nCqXEJfQ86w38UcF71MIDX2YG2lYf3xbsFW43lxKW9nHAGO0UgLtLzXalUcWEerncI5a
         qATcLywGi79X5BmzGLj9y+ib+tuda6X5ZhRwkMwzKJRm8jEhoHkGF0fYHfc3ZgycFWCA
         yqlLOqnH7CfW1E8O/DKzTJSIk6rZb8678aPBO483aMZf22Ztk2iAhZagkd9QMIZ4zMnl
         MfLg==
X-Forwarded-Encrypted: i=1; AJvYcCWi4H0PBf8tAoZERBWEEiBqn+sjVwK7es9LeUTPf4Q3tT/2yfRsUyJxm4kxLn0o7UZv2wc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5aKmJtgdWw+a5+VkwGFzocczQLMPZN8xf3U7R6E7VBm3PB5QL
	AAePQjnEG1FLBwvrZzMP5EzP4g4KfyrkNbJ2XcnrY2fRXe1/DtJAnxI5pJTysjPbn1CSEQb2Gr1
	VgvRoN9MGxDJkLJo1a3s1/JqgBKaldpegnotQT+vhjORZRujZug==
X-Received: by 2002:a05:690c:380b:b0:6c1:2b6d:1964 with SMTP id 00721157ae682-6c62906557cmr136660647b3.38.1724705050750;
        Mon, 26 Aug 2024 13:44:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGVQdSmnkARvKpk+I4g97hETTq/PaNGcO/OaJoau0YQSMQm37evWRXkCU2N5l4bob/h1UXyLw==
X-Received: by 2002:a05:690c:380b:b0:6c1:2b6d:1964 with SMTP id 00721157ae682-6c62906557cmr136660497b3.38.1724705050419;
        Mon, 26 Aug 2024 13:44:10 -0700 (PDT)
Received: from x1n.redhat.com (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a67f3fd6c1sm491055185a.121.2024.08.26.13.44.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2024 13:44:09 -0700 (PDT)
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
Subject: [PATCH v2 07/19] mm/fork: Accept huge pfnmap entries
Date: Mon, 26 Aug 2024 16:43:41 -0400
Message-ID: <20240826204353.2228736-8-peterx@redhat.com>
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

Teach the fork code to properly copy pfnmaps for pmd/pud levels.  Pud is
much easier, the write bit needs to be persisted though for writable and
shared pud mappings like PFNMAP ones, otherwise a follow up write in either
parent or child process will trigger a write fault.

Do the same for pmd level.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 mm/huge_memory.c | 29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index e2c314f631f3..15418ffdd377 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1559,6 +1559,24 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	pgtable_t pgtable = NULL;
 	int ret = -ENOMEM;
 
+	pmd = pmdp_get_lockless(src_pmd);
+	if (unlikely(pmd_special(pmd))) {
+		dst_ptl = pmd_lock(dst_mm, dst_pmd);
+		src_ptl = pmd_lockptr(src_mm, src_pmd);
+		spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
+		/*
+		 * No need to recheck the pmd, it can't change with write
+		 * mmap lock held here.
+		 *
+		 * Meanwhile, making sure it's not a CoW VMA with writable
+		 * mapping, otherwise it means either the anon page wrongly
+		 * applied special bit, or we made the PRIVATE mapping be
+		 * able to wrongly write to the backend MMIO.
+		 */
+		VM_WARN_ON_ONCE(is_cow_mapping(src_vma->vm_flags) && pmd_write(pmd));
+		goto set_pmd;
+	}
+
 	/* Skip if can be re-fill on fault */
 	if (!vma_is_anonymous(dst_vma))
 		return 0;
@@ -1640,7 +1658,9 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	pmdp_set_wrprotect(src_mm, addr, src_pmd);
 	if (!userfaultfd_wp(dst_vma))
 		pmd = pmd_clear_uffd_wp(pmd);
-	pmd = pmd_mkold(pmd_wrprotect(pmd));
+	pmd = pmd_wrprotect(pmd);
+set_pmd:
+	pmd = pmd_mkold(pmd);
 	set_pmd_at(dst_mm, addr, dst_pmd, pmd);
 
 	ret = 0;
@@ -1686,8 +1706,11 @@ int copy_huge_pud(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	 * TODO: once we support anonymous pages, use
 	 * folio_try_dup_anon_rmap_*() and split if duplicating fails.
 	 */
-	pudp_set_wrprotect(src_mm, addr, src_pud);
-	pud = pud_mkold(pud_wrprotect(pud));
+	if (is_cow_mapping(vma->vm_flags) && pud_write(pud)) {
+		pudp_set_wrprotect(src_mm, addr, src_pud);
+		pud = pud_wrprotect(pud);
+	}
+	pud = pud_mkold(pud);
 	set_pud_at(dst_mm, addr, dst_pud, pud);
 
 	ret = 0;
-- 
2.45.0


