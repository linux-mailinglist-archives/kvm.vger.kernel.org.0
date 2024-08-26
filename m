Return-Path: <kvm+bounces-25082-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1982295FAC3
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 22:44:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C2C6B28463A
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 20:44:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A08719B3DD;
	Mon, 26 Aug 2024 20:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IfR9KALu"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3954619AA57
	for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 20:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724705044; cv=none; b=OVww9AWDFZ/92L1R6KgWATu1Y+ZMST3vjyXOFCdQYAeFXYXUyV51v5dA/vVTCUhh/o1n0oSLi8VIPrstqhNgdky34CHbU57EVoFZNFBElvMvgoJz5gbEJNqMupsKZhY8xK6qFX3YM1d0vDLTBne+EEIgb2LLrscz0hk7+TVxisY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724705044; c=relaxed/simple;
	bh=34MqcYAeedS1HMCphQeI6ozj3aHeCly2AzsezqBdon4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pvB3I4YgHaqpnm8frItXTg0eCWJZ93zrCiSoqBZQLgFqcPho6IWYIaNrR0gAZOSZHzaoCnFqDKns/olF2x5o61kkhfK83sKkDCEnGLrd3DKHj6wAk9leC1KquOtQ+onI5oHMJuQGgdAQwhXXxOYyWLmk6EnRl381GGJGBgciwB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IfR9KALu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724705042;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rCV2q6t08l8ndW0pGxUU3F/GDhRRI1SX3G16E23iQDg=;
	b=IfR9KALuKb4OfuYAomKCC9JuIVvP/pWCaCcefLaHyxeDS1EdHPwXpMC6HPG8JA1vsECQe9
	/fhj6D43nXi18gvck8/ZM1OWuTc0Zl+TaX+rwUIAlIJrJI0H6O+SyKREHC3aDah4nq/gwz
	7wfKhnI/5tuYhfkJKYoMgZNC1i1Purg=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-488-cOXSj4YUO16SKLLpOTjVpw-1; Mon, 26 Aug 2024 16:44:01 -0400
X-MC-Unique: cOXSj4YUO16SKLLpOTjVpw-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7a1d44099a3so628033885a.3
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 13:44:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724705040; x=1725309840;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rCV2q6t08l8ndW0pGxUU3F/GDhRRI1SX3G16E23iQDg=;
        b=p8OocfDrLG+yT/2DannDUNrveR2n7Wy7JE/fRx2ny+skXruIFc7vQY/ljdKSSlnway
         DKgDDANJEfTzX3QPMdjFUcLqR18fwPTGMhIE4nJt/iTcfOLrLPGz4k1iTwPT2tQC2Bpy
         RloDd27e4DiJ2JtvvXGK8h5H9PcsmXobGVvIdA2FdbnmDFsk2v2Z53Sps84sd8j6dfpv
         1Ao7G0rkhNOHVfpk1Jyv9YWTiOQn/BaKkFffQ99C/0Lz0jksJJe34JiNwibPZDI73/RF
         oX50t+vtSx6aRx3y6eZGkZ+TPbSzMkw8jwoB0v54wCmP0YY66uINNsWge05h3mvxD0de
         nPYg==
X-Forwarded-Encrypted: i=1; AJvYcCVtJ1AIAmlWQa1fWPacAVKhQZscryg8y3HUFwoToCF2dmNeD8KDO/XnAjsLmZwjQhA6f+k=@vger.kernel.org
X-Gm-Message-State: AOJu0YxC2zN7nVTx06sQUzZFfkG5OA0I1mn3x4sDGUR20SuPc+AjUU8J
	Tezs95nu8Dz2vOG0TorQfnNeNeK+rdmGVd9VtyoHfF1EJUFFhK81MO0OCLv8OtSbm6I+uixTgO1
	Wgx/VlgmVcva9/fk9UhG6d8ZmZ0SvIgxgbnGSsy625Y6h8NWVEg==
X-Received: by 2002:a05:620a:28c8:b0:7a1:62ad:9d89 with SMTP id af79cd13be357-7a7e4e6d3c1mr92954885a.64.1724705040432;
        Mon, 26 Aug 2024 13:44:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEW5yVxsMo5HJEI7stPZogQTAiTuzeFOof5FGrO8bEsBYthlHw7SRF31ZNT2saoeMAKCiiqzA==
X-Received: by 2002:a05:620a:28c8:b0:7a1:62ad:9d89 with SMTP id af79cd13be357-7a7e4e6d3c1mr92952485a.64.1724705040096;
        Mon, 26 Aug 2024 13:44:00 -0700 (PDT)
Received: from x1n.redhat.com (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a67f3fd6c1sm491055185a.121.2024.08.26.13.43.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2024 13:43:59 -0700 (PDT)
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
	Alex Williamson <alex.williamson@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	"Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
Subject: [PATCH v2 02/19] mm: Drop is_huge_zero_pud()
Date: Mon, 26 Aug 2024 16:43:36 -0400
Message-ID: <20240826204353.2228736-3-peterx@redhat.com>
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

It constantly returns false since 2017.  One assertion is added in 2019 but
it should never have triggered, IOW it means what is checked should be
asserted instead.

If it didn't exist for 7 years maybe it's good idea to remove it and only
add it when it comes.

Cc: Matthew Wilcox <willy@infradead.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 include/linux/huge_mm.h | 10 ----------
 mm/huge_memory.c        | 13 +------------
 2 files changed, 1 insertion(+), 22 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 4902e2f7e896..b550b5a248bb 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -433,11 +433,6 @@ static inline bool is_huge_zero_pmd(pmd_t pmd)
 	return pmd_present(pmd) && READ_ONCE(huge_zero_pfn) == pmd_pfn(pmd);
 }
 
-static inline bool is_huge_zero_pud(pud_t pud)
-{
-	return false;
-}
-
 struct folio *mm_get_huge_zero_folio(struct mm_struct *mm);
 void mm_put_huge_zero_folio(struct mm_struct *mm);
 
@@ -578,11 +573,6 @@ static inline bool is_huge_zero_pmd(pmd_t pmd)
 	return false;
 }
 
-static inline bool is_huge_zero_pud(pud_t pud)
-{
-	return false;
-}
-
 static inline void mm_put_huge_zero_folio(struct mm_struct *mm)
 {
 	return;
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index a81eab98d6b8..3f74b09ada38 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1429,10 +1429,8 @@ static void insert_pfn_pud(struct vm_area_struct *vma, unsigned long addr,
 	ptl = pud_lock(mm, pud);
 	if (!pud_none(*pud)) {
 		if (write) {
-			if (pud_pfn(*pud) != pfn_t_to_pfn(pfn)) {
-				WARN_ON_ONCE(!is_huge_zero_pud(*pud));
+			if (WARN_ON_ONCE(pud_pfn(*pud) != pfn_t_to_pfn(pfn)))
 				goto out_unlock;
-			}
 			entry = pud_mkyoung(*pud);
 			entry = maybe_pud_mkwrite(pud_mkdirty(entry), vma);
 			if (pudp_set_access_flags(vma, addr, pud, entry, 1))
@@ -1680,15 +1678,6 @@ int copy_huge_pud(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	if (unlikely(!pud_trans_huge(pud) && !pud_devmap(pud)))
 		goto out_unlock;
 
-	/*
-	 * When page table lock is held, the huge zero pud should not be
-	 * under splitting since we don't split the page itself, only pud to
-	 * a page table.
-	 */
-	if (is_huge_zero_pud(pud)) {
-		/* No huge zero pud yet */
-	}
-
 	/*
 	 * TODO: once we support anonymous pages, use
 	 * folio_try_dup_anon_rmap_*() and split if duplicating fails.
-- 
2.45.0


