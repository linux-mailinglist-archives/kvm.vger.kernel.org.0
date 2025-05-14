Return-Path: <kvm+bounces-46572-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 67B88AB79BD
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 01:49:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0022D172C6A
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 23:49:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BAAD246775;
	Wed, 14 May 2025 23:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="imk+hA3n"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C898424467D
	for <kvm@vger.kernel.org>; Wed, 14 May 2025 23:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747266206; cv=none; b=TE+3mdAJtFISX9KE+x1h1iUszh6pQBqoIM+FK9b+vkKye+fJ9z1pYOHM0abcarqJ0f3YJqRBrcTihSBpK4R1Y0DiZwing43ASh9QIIA3aAheTP2NMUuZ7HhcMNJEw0VMUoszXYYBHKkc1CHlewd+EUOM/8pAxMBbHUtZb+HGVa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747266206; c=relaxed/simple;
	bh=eK6YjjFU2KAHnAlEWkJCwdN+qAg40CDXbvkKpISmFJA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uZqa4ZxouU/uV24LgKNAfMi+jrEpT+BmO/JuMydXdZA5hdpkRK16+3A0pIVVhZkennOr8WX/Qcsn1CkjmqlIb1Vdd0rt9L7bZmJP0Bxhj4256z7BIdyE7qr2RcETI9y20A4sQOut2lct9ywgJ72PzovH6za9hfW4GHumdZIrL9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=imk+hA3n; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b0ae9e87fe2so1139385a12.0
        for <kvm@vger.kernel.org>; Wed, 14 May 2025 16:43:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747266204; x=1747871004; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=E26Tl2T4mfZ/m1IX0grkZCH7fXFwkgs13AgMIoZPWuo=;
        b=imk+hA3nOyYwlkDgoZyciczpGiVhORSGCmsSK06vrYybPOL9XB3VwYDOHSR6iqYlwx
         dq9lYG23wzojd+RybT9pqkU1+ZIfQftZHQqzQvw0y3ezdPon4xrNPLZNIXGcm+Gn0uL0
         A24mVx/uT25dgPL0Id9iIV3HTHpFkIl0+eDsWs7KRtPU231+rD+F0FoJyxyz4reaDqt8
         lZp7BV0+FKieujP1w1scm13uJAOMvsTNe4Hxmed9sqVr2XH8/cyus7CT6ydih/1Fytps
         rYE11V72BiKIV5c6UaIe1sT2P0d0CDN/ND44Yvgx/VuVvk3RURlHbkqhot9Nhq8zSonm
         A4JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747266204; x=1747871004;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E26Tl2T4mfZ/m1IX0grkZCH7fXFwkgs13AgMIoZPWuo=;
        b=NgH8x+IgdUp2lVZSQGfzWXR3XoEMi8/6qVWLcrxXLyjewOaZZoanM1Qs5v1pnVUbAz
         s53c3Gwv8avgCVDh3nje/FPBOm5pEb6D1LBwDIgoVZfnJvH8ysdTR0gKVOFmVi6mxyRA
         14HLHDisMOg1ShnTQh/jMjc/cz/lb/4tP0UkzrQlnM2lViecgyWmbxVWzueVCAA2hdMk
         S7ZH7MOP3sIKUy7j7lGkLoAOglWkcJFNmUGsurrllWYUgle65OEZFQuHVoDIMZ01Rd6U
         lZCVcjSpEDKOTO9qHACzjJJr3h61hHPMRTF9fj8i5pwA6bxQnJnzSRO19u2YWQr7Ex7J
         ayCg==
X-Gm-Message-State: AOJu0Yzqc1Woy4udyW4VXjyS5LTuEq0XSmVU4RliE4Aq6UiEs1XyvUlR
	CohMRbUG5uvnz67xHtN7YJucbGI5RWMO+oAoH9tQAFDjbyUOgDA35Zm7yYkAowDBLpEfMgw8+Kp
	mIZCysVqkINQ5OKu4w3kbyZ5MZiY3PhHwZI3gkUAu3nfQeZhCHBKMc7+ia0uJrYLy8BT1P2Y+9t
	95w31eEWrDVrOlvy7RmVVE7A6LyHT5ojOQh0Y92vf+b9jMlb2zf0HCqhkgqqo=
X-Google-Smtp-Source: AGHT+IGGAEb3QlUf/WhLCRTxvufYT1iGlYd55goOcpCx/3NfQyHKKzpB2yIq1YSNBW8KeC+O0YA7TSeUeA6QlfAJtA==
X-Received: from pjbpb18.prod.google.com ([2002:a17:90b:3c12:b0:2f5:63a:4513])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2d84:b0:2fc:aaf:74d3 with SMTP id 98e67ed59e1d1-30e4daca157mr2160148a91.4.1747266203512;
 Wed, 14 May 2025 16:43:23 -0700 (PDT)
Date: Wed, 14 May 2025 16:41:56 -0700
In-Reply-To: <cover.1747264138.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1747264138.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.49.0.1045.g170613ef41-goog
Message-ID: <cbdec587dec5ee10de4e4596d158c871e9630cac.1747264138.git.ackerleytng@google.com>
Subject: [RFC PATCH v2 17/51] mm: hugetlb: Cleanup interpretation of gbl_chg
 in alloc_hugetlb_folio()
From: Ackerley Tng <ackerleytng@google.com>
To: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, linux-fsdevel@vger.kernel.org
Cc: ackerleytng@google.com, aik@amd.com, ajones@ventanamicro.com, 
	akpm@linux-foundation.org, amoorthy@google.com, anthony.yznaga@oracle.com, 
	anup@brainfault.org, aou@eecs.berkeley.edu, bfoster@redhat.com, 
	binbin.wu@linux.intel.com, brauner@kernel.org, catalin.marinas@arm.com, 
	chao.p.peng@intel.com, chenhuacai@kernel.org, dave.hansen@intel.com, 
	david@redhat.com, dmatlack@google.com, dwmw@amazon.co.uk, 
	erdemaktas@google.com, fan.du@intel.com, fvdl@google.com, graf@amazon.com, 
	haibo1.xu@intel.com, hch@infradead.org, hughd@google.com, ira.weiny@intel.com, 
	isaku.yamahata@intel.com, jack@suse.cz, james.morse@arm.com, 
	jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, jhubbard@nvidia.com, 
	jroedel@suse.de, jthoughton@google.com, jun.miao@intel.com, 
	kai.huang@intel.com, keirf@google.com, kent.overstreet@linux.dev, 
	kirill.shutemov@intel.com, liam.merwick@oracle.com, 
	maciej.wieczor-retman@intel.com, mail@maciej.szmigiero.name, maz@kernel.org, 
	mic@digikod.net, michael.roth@amd.com, mpe@ellerman.id.au, 
	muchun.song@linux.dev, nikunj@amd.com, nsaenz@amazon.es, 
	oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com, 
	paul.walmsley@sifive.com, pbonzini@redhat.com, pdurrant@amazon.co.uk, 
	peterx@redhat.com, pgonda@google.com, pvorel@suse.cz, qperret@google.com, 
	quic_cvanscha@quicinc.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_tsoni@quicinc.com, richard.weiyang@gmail.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, roypat@amazon.co.uk, 
	rppt@kernel.org, seanjc@google.com, shuah@kernel.org, steven.price@arm.com, 
	steven.sistare@oracle.com, suzuki.poulose@arm.com, tabba@google.com, 
	thomas.lendacky@amd.com, usama.arif@bytedance.com, vannapurve@google.com, 
	vbabka@suse.cz, viro@zeniv.linux.org.uk, vkuznets@redhat.com, 
	wei.w.wang@intel.com, will@kernel.org, willy@infradead.org, 
	xiaoyao.li@intel.com, yan.y.zhao@intel.com, yilun.xu@intel.com, 
	yuzenghui@huawei.com, zhiquan1.li@intel.com
Content-Type: text/plain; charset="UTF-8"

The comment before dequeuing a folio explains that if gbl_chg == 0, a
reservation exists for the allocation.

In addition, if a vma reservation exists, there's no need to get a
reservation from the subpool, and gbl_chg was set to 0.

This patch replaces both of that with code: subpool_reservation_exists
defaults to false, and if a vma reservation does not exist, a
reservation is sought from the subpool.

Then, the existence of a reservation, whether in the vma or subpool,
is summarized into reservation_exists, which is then used to determine
whether to dequeue a folio.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Change-Id: I52130a0bf9f33e07d320a446cdb3ebfddd9de658
---
 mm/hugetlb.c | 28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index b843e869496f..597f2b9f62b5 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2999,8 +2999,10 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 {
 	struct hugepage_subpool *spool = subpool_vma(vma);
 	struct hstate *h = hstate_vma(vma);
+	bool subpool_reservation_exists;
+	bool reservation_exists;
 	struct folio *folio;
-	long retval, gbl_chg;
+	long retval;
 	map_chg_state map_chg;
 	int ret, idx;
 	struct hugetlb_cgroup *h_cg = NULL;
@@ -3036,17 +3038,16 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	 * that the allocation will not exceed the subpool limit.
 	 * Or if it can get one from the pool reservation directly.
 	 */
+	subpool_reservation_exists = false;
 	if (map_chg) {
-		gbl_chg = hugepage_subpool_get_pages(spool, 1);
-		if (gbl_chg < 0)
+		int npages_req = hugepage_subpool_get_pages(spool, 1);
+
+		if (npages_req < 0)
 			goto out_end_reservation;
-	} else {
-		/*
-		 * If we have the vma reservation ready, no need for extra
-		 * global reservation.
-		 */
-		gbl_chg = 0;
+
+		subpool_reservation_exists = npages_req == 0;
 	}
+	reservation_exists = !map_chg || subpool_reservation_exists;
 
 	/*
 	 * If this allocation is not consuming a per-vma reservation,
@@ -3065,13 +3066,8 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 
 	spin_lock_irq(&hugetlb_lock);
 
-	/*
-	 * gbl_chg == 0 indicates a reservation exists for the allocation - so
-	 * try dequeuing a page. If there are available_huge_pages(), try using
-	 * them!
-	 */
 	folio = NULL;
-	if (!gbl_chg || available_huge_pages(h))
+	if (reservation_exists || available_huge_pages(h))
 		folio = dequeue_hugetlb_folio(h, vma, addr);
 
 	if (!folio) {
@@ -3089,7 +3085,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	 * Either dequeued or buddy-allocated folio needs to add special
 	 * mark to the folio when it consumes a global reservation.
 	 */
-	if (!gbl_chg) {
+	if (reservation_exists) {
 		folio_set_hugetlb_restore_reserve(folio);
 		h->resv_huge_pages--;
 	}
-- 
2.49.0.1045.g170613ef41-goog


