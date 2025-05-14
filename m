Return-Path: <kvm+bounces-46576-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A28FCAB79CE
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 01:50:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A68643B00CD
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 23:50:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C406248F70;
	Wed, 14 May 2025 23:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="P8rY/Ivv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF080248F59
	for <kvm@vger.kernel.org>; Wed, 14 May 2025 23:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747266212; cv=none; b=I9DyqgxIBknz9tV55pCjVqOJ+lCS05NhHefbBRzus+H09GIN21+wIG2VaCnpSDuzdu4EI+5mnjZXzviv631UTbAemQxU9hHI5EmdVI+oxDkPLS2yM5GkyUurMpsPbFZHEaPkv70DJy8xE6nFGr73xXjQCyOLgvF0ot4iaW8uCis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747266212; c=relaxed/simple;
	bh=mDAgY99g40Yyk1XjcdF9j+JWk/+4IZdORF7bJ79w+2M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OvAjLKlOwc8KKHJkxR7lvRtNfuJeEvAIEWpbqenaFdhSdiXSKnzl5p4KjZXxRR/OEG47rp8jP10C94lpga5LSbhftVHkecJVVMH6K6iAO32HwnPk/VHR4UQgkG4zS+CD10Wwl+nzKfvcIa7R4hxwscJpxvGLg91pVUt5XAqJJ6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=P8rY/Ivv; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b23d12e14bdso259641a12.1
        for <kvm@vger.kernel.org>; Wed, 14 May 2025 16:43:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747266210; x=1747871010; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4sIecgGyO0lUZDlGmfbLoDOBmwYRGdtl4g13CxMI1VY=;
        b=P8rY/IvvwBvyW70WJBFVGFGhlMamvpRQiCX2/3Q1nOTdYLdi/RsRfZI/YllEZ4XHSw
         mhp7L+FwBIfmLMHVGDUBdqmeyV0KiJG39NT/ZnJ5IkopEJ9ClSKoN2F2wdlh5xakAM1o
         2XikV3dtuSleHExPqPDT8SPMlNc1zFUrwDPBnQbilrSCP5E7vOuZrN2c0SrLtj6WX3f5
         1yHhzCeAHmyuxBRYCsASzmJMJmSSCsqv995fZ6IqXEMBWzBt6br/wxovx1H5Pm2nogz0
         y8n2ykCVBI7VKICLRD7yRsPfamkyz0jwX80kBG6j0lqu2Himuf77p+J9nn1cQB3SoIVK
         AdjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747266210; x=1747871010;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4sIecgGyO0lUZDlGmfbLoDOBmwYRGdtl4g13CxMI1VY=;
        b=KGJhSF+u7WPpfT5j+v05JZtfZUzZXDL17/hNDYaKXrVmoiVZrkfY0ausner/j+fKch
         tZiF7O2S9tjS63y+h1JbwQhnSfC3OrrWgwnQvwuHJEy2FsiMCcgRWhVGIdL2/diDZdSg
         n4tyvAGon69jR7do/yFfFrk0CkVbDQuZs3Ku8xPAS03eJldPdZwXRaOwAvzKDsj4rI8f
         hY+wzQFwni4Ekwv044P0McgUv9jonwwpGF79y449/MpwPt5kFa0NwPKL9D8C8W+7YEhD
         31wOi13HMDiMcWXxmoc435mXUKmGiTl//5tE3FloUOkSCBG0AJvYGS5XtiHGmcu1ueq1
         urKw==
X-Gm-Message-State: AOJu0YxpIGuq/LSwkrg1dSYOKgBHGr2uNvxjG4mQ+cBUwF5EbUmHsbsX
	6QdU6jE/CdXUW/yqIYSgErbSTj1lM9WVe5l50dU74yenEaWJszSyj0w7OKTbleBpuQt3Pc/K2CZ
	tGoKHVulyYVACDc2KtXqv88Via9k7rtZ1wlVYaMoalZgJYfSRr2lgW4CozKaWUzrGV5DXJIsZ/u
	HVXuouzwsiIuWK8lbA3YC3zXotFOT4JlXmmH4GLvXpbrEOITuQdfP9Wpk=
X-Google-Smtp-Source: AGHT+IHE2ihGcSaSi+44FOfQo2JFT44j8vrPkcuV6SQcS6l9oOHcwMqkj/ZKectxEWeBtOTnjJpM1DV+MxgAJO4ylw==
X-Received: from pjbsw16.prod.google.com ([2002:a17:90b:2c90:b0:308:87dc:aa52])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90a:d647:b0:30c:540b:9b6 with SMTP id 98e67ed59e1d1-30e2e419501mr9813764a91.0.1747266209881;
 Wed, 14 May 2025 16:43:29 -0700 (PDT)
Date: Wed, 14 May 2025 16:42:00 -0700
In-Reply-To: <cover.1747264138.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1747264138.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.49.0.1045.g170613ef41-goog
Message-ID: <c6ecf0b9425db4993fb043caf3f48f2b32d7eb28.1747264138.git.ackerleytng@google.com>
Subject: [RFC PATCH v2 21/51] mm: hugetlb: Inline huge_node() into callers
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

huge_node()'s role was to read struct mempolicy (mpol) from the vma
and also interpret mpol to get node id and nodemask.

huge_node() can be inlined into callers since 2 out of 3 of the
callers will be refactored in later patches to take and interpret mpol
without reading mpol from the vma.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Change-Id: Ic94b2ed916fd4f89b7d2755288a3a2f6a56051f7
---
 include/linux/mempolicy.h | 12 ------------
 mm/hugetlb.c              | 13 ++++++++++---
 mm/mempolicy.c            | 21 ---------------------
 3 files changed, 10 insertions(+), 36 deletions(-)

diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
index 840c576abcfd..41fc53605ef0 100644
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -140,9 +140,6 @@ extern void mpol_rebind_mm(struct mm_struct *mm, nodemask_t *new);
 
 extern int policy_node_nodemask(struct mempolicy *mpol, gfp_t gfp_flags,
 				pgoff_t ilx, nodemask_t **nodemask);
-extern int huge_node(struct vm_area_struct *vma,
-				unsigned long addr, gfp_t gfp_flags,
-				struct mempolicy **mpol, nodemask_t **nodemask);
 extern bool init_nodemask_of_mempolicy(nodemask_t *mask);
 extern bool mempolicy_in_oom_domain(struct task_struct *tsk,
 				const nodemask_t *mask);
@@ -260,15 +257,6 @@ static inline int policy_node_nodemask(struct mempolicy *mpol, gfp_t gfp_flags,
 	return 0;
 }
 
-static inline int huge_node(struct vm_area_struct *vma,
-				unsigned long addr, gfp_t gfp_flags,
-				struct mempolicy **mpol, nodemask_t **nodemask)
-{
-	*mpol = NULL;
-	*nodemask = NULL;
-	return 0;
-}
-
 static inline bool init_nodemask_of_mempolicy(nodemask_t *m)
 {
 	return false;
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index b822b204e9b3..5cc261b90e39 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1372,10 +1372,12 @@ static struct folio *dequeue_hugetlb_folio(struct hstate *h,
 	struct mempolicy *mpol;
 	gfp_t gfp_mask;
 	nodemask_t *nodemask;
+	pgoff_t ilx;
 	int nid;
 
 	gfp_mask = htlb_alloc_mask(h);
-	nid = huge_node(vma, address, gfp_mask, &mpol, &nodemask);
+	mpol = get_vma_policy(vma, address, h->order, &ilx);
+	nid = policy_node_nodemask(mpol, gfp_mask, ilx, &nodemask);
 
 	if (mpol_is_preferred_many(mpol)) {
 		folio = dequeue_hugetlb_folio_nodemask(h, gfp_mask,
@@ -2321,8 +2323,11 @@ static struct folio *alloc_surplus_hugetlb_folio(struct hstate *h,
 	gfp_t gfp_mask = htlb_alloc_mask(h);
 	int nid;
 	nodemask_t *nodemask;
+	pgoff_t ilx;
+
+	mpol = get_vma_policy(vma, addr, h->order, &ilx);
+	nid = policy_node_nodemask(mpol, gfp_mask, ilx, &nodemask);
 
-	nid = huge_node(vma, addr, gfp_mask, &mpol, &nodemask);
 	if (mpol_is_preferred_many(mpol)) {
 		gfp_t gfp = gfp_mask & ~(__GFP_DIRECT_RECLAIM | __GFP_NOFAIL);
 
@@ -6829,10 +6834,12 @@ static struct folio *alloc_hugetlb_folio_vma(struct hstate *h,
 	nodemask_t *nodemask;
 	struct folio *folio;
 	gfp_t gfp_mask;
+	pgoff_t ilx;
 	int node;
 
 	gfp_mask = htlb_alloc_mask(h);
-	node = huge_node(vma, address, gfp_mask, &mpol, &nodemask);
+	mpol = get_vma_policy(vma, address, h->order, &ilx);
+	node = policy_node_nodemask(mpol, gfp_mask, ilx, &nodemask);
 	/*
 	 * This is used to allocate a temporary hugetlb to hold the copied
 	 * content, which will then be copied again to the final hugetlb
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 7837158ee5a8..39d0abc407dc 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2145,27 +2145,6 @@ int policy_node_nodemask(struct mempolicy *mpol, gfp_t gfp_flags,
 }
 
 #ifdef CONFIG_HUGETLBFS
-/*
- * huge_node(@vma, @addr, @gfp_flags, @mpol)
- * @vma: virtual memory area whose policy is sought
- * @addr: address in @vma for shared policy lookup and interleave policy
- * @gfp_flags: for requested zone
- * @mpol: pointer to mempolicy pointer for reference counted mempolicy
- * @nodemask: pointer to nodemask pointer for 'bind' and 'prefer-many' policy
- *
- * Returns a nid suitable for a huge page allocation and a pointer
- * to the struct mempolicy for conditional unref after allocation.
- * If the effective policy is 'bind' or 'prefer-many', returns a pointer
- * to the mempolicy's @nodemask for filtering the zonelist.
- */
-int huge_node(struct vm_area_struct *vma, unsigned long addr, gfp_t gfp_flags,
-		struct mempolicy **mpol, nodemask_t **nodemask)
-{
-	pgoff_t ilx;
-
-	*mpol = get_vma_policy(vma, addr, hstate_vma(vma)->order, &ilx);
-	return policy_node_nodemask(*mpol, gfp_flags, ilx, nodemask);
-}
 
 /*
  * init_nodemask_of_mempolicy
-- 
2.49.0.1045.g170613ef41-goog


