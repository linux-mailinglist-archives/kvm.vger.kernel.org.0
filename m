Return-Path: <kvm+bounces-26396-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DD74397468F
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 01:46:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2A938B24B46
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 23:46:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 893111B5315;
	Tue, 10 Sep 2024 23:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rOZokNwW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDCBA1B29CC
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 23:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726011883; cv=none; b=ZpwrAH4CnkKy/Xau7ff4YBKrP6E4Iruv9lS7i5xP+vKlg+C+g8/koirky8J6xRTpyXjTiDsXIupUSccvOQ0TALsiR0T7mkJYeJUbm5D6Lp1oRYnPjFOaXfI+nj/k6+0wwbjg5+Ml/cZXDvTKcMDSMqLfY9XoDLa8WlHEwvqixAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726011883; c=relaxed/simple;
	bh=O/edjtmypoPixHRv0x+vItyFxW+7M9gDRhPux2Wm++E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mrQvr58ZZgDrbt+IEzJ0GQsikJ/lFbJbuJiRjhLcL0M0HN+O8vkOfMkdZoaRcSRpt8qQQCzHFQZuP77gx4RxNYFfcZlhZGX54XTZvZR+swCdKi3xHTMoxvjK5u1en2YHb5ti/5w2+6iWNp+I8Dnk9oaBVkfE1o0GlpPfMr3+I00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rOZokNwW; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e1d351c9fb5so10658257276.1
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 16:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726011880; x=1726616680; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jTd2rO5Zdb8WdV1vtO69lkT5XfB4R/SsMg9R2z/uiu4=;
        b=rOZokNwWfVjQwfsiG59uePX96CmdA7qptRgEwB9Fe12fVDwDfvKRSsPoovObcX8CvE
         3FsV8+EDkURejrssYLuYoNN2jymSRaulqS328CMVeB/6rH25UImuSwAH4Mjaot/JbqSH
         NOpKIYa7v6QeS1BY5Wzpd8ZZmlOH1XUqoohoaUF8C/tGB+I5AMR4uKEC11cAjJ/FYDXF
         PA2TcEEm0NJtOFqCp82zbdfHhZ2M3ff240jsv+Wems1iDEI4To2libgXN4x6Cf9XiLAe
         KGEKkw601A7nmU492wkyXdiSWdMG+AG4iX4ixQnbl7aqJBCNR5VhMI/qWur/v2Bm+6uW
         mynQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726011880; x=1726616680;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jTd2rO5Zdb8WdV1vtO69lkT5XfB4R/SsMg9R2z/uiu4=;
        b=DWXv6CkhwR6AkyokzYs03lPG066ZumSQcnkyHExMTZu22PrgBVFZXdIxAi5S3/6V6w
         l1bavurgMnJi0S62qntjyrxeDlZG9GGUlZ0ynsYvpd113BSJMKb0fze5fHFcpJzOjFvI
         el8afFnaWO+W7K7gY/t/v4MVSgN7nurLHWtON8LYU37JV6X2IcP7UDVGkACtx6vernRX
         VcyDZ6aTy1PL78gGr/cFjROSs2hve4hNx37YIDmnSY3HtWwDOXWaBgZpnYd7NIw9+hKL
         vKZCT+8u6gNhJhwJYNRuU+w1BE0hMV6KL71gzhDUUZQ0/j/6k3mgK/w71jvPuWxvLcSJ
         rsjA==
X-Forwarded-Encrypted: i=1; AJvYcCW3RPZhw/e9a+xE5qY+lKO2A5Rpn8+5HuUfHZeHVldNpdxuSEzEitQ6joahiSPDZq4uipA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxXNNyqMCX8mScw8aLo2tkU+dlJwcCiwoKFmUciwMMrTQSQrVZE
	kMSVtCeTlE41KBButlhRlp4t+3wQJ9XS/GweCT8XxEGqg5kmJfq+5gPU8/7M121FpI8wqZJpkHP
	K40Pgx93MZEcOWPeOrfKO8A==
X-Google-Smtp-Source: AGHT+IELcWQwCF/9EVJh/HJrP9xEFU149NgacCTcvYjoLYUSuucXNFK9/9x50btN31jddKHhaQJO6vkBJPZwQK4+6w==
X-Received: from ackerleytng-ctop.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:13f8])
 (user=ackerleytng job=sendgmr) by 2002:a25:ae9b:0:b0:e0b:f69b:da30 with SMTP
 id 3f1490d57ef6-e1d34a2f4b4mr88712276.9.1726011879738; Tue, 10 Sep 2024
 16:44:39 -0700 (PDT)
Date: Tue, 10 Sep 2024 23:43:35 +0000
In-Reply-To: <cover.1726009989.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1726009989.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
Message-ID: <9831cfcc77e325e48ec3674c3a518bda76e78df5.1726009989.git.ackerleytng@google.com>
Subject: [RFC PATCH 04/39] mm: mempolicy: Refactor out policy_node_nodemask()
From: Ackerley Tng <ackerleytng@google.com>
To: tabba@google.com, quic_eberman@quicinc.com, roypat@amazon.co.uk, 
	jgg@nvidia.com, peterx@redhat.com, david@redhat.com, rientjes@google.com, 
	fvdl@google.com, jthoughton@google.com, seanjc@google.com, 
	pbonzini@redhat.com, zhiquan1.li@intel.com, fan.du@intel.com, 
	jun.miao@intel.com, isaku.yamahata@intel.com, muchun.song@linux.dev, 
	mike.kravetz@oracle.com
Cc: erdemaktas@google.com, vannapurve@google.com, ackerleytng@google.com, 
	qperret@google.com, jhubbard@nvidia.com, willy@infradead.org, 
	shuah@kernel.org, brauner@kernel.org, bfoster@redhat.com, 
	kent.overstreet@linux.dev, pvorel@suse.cz, rppt@kernel.org, 
	richard.weiyang@gmail.com, anup@brainfault.org, haibo1.xu@intel.com, 
	ajones@ventanamicro.com, vkuznets@redhat.com, maciej.wieczor-retman@intel.com, 
	pgonda@google.com, oliver.upton@linux.dev, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-fsdevel@kvack.org
Content-Type: text/plain; charset="UTF-8"

This was refactored out of huge_node().

huge_node()'s interpretation of vma for order assumes the
hugetlb-specific storage of the hstate information in the
inode. policy_node_nodemask() does not assume that, and can be used
more generically.

This refactoring also enforces that nid default to the current node
id, which was not previously enforced.

alloc_pages_mpol_noprof() is the last remaining direct user of
policy_nodemask(). All its callers begin with nid being the current
node id as well. More refactoring is required for to simplify that.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 include/linux/mempolicy.h |  2 ++
 mm/mempolicy.c            | 36 ++++++++++++++++++++++++++----------
 2 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
index 1add16f21612..a49631e47421 100644
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -138,6 +138,8 @@ extern void numa_policy_init(void);
 extern void mpol_rebind_task(struct task_struct *tsk, const nodemask_t *new);
 extern void mpol_rebind_mm(struct mm_struct *mm, nodemask_t *new);
 
+extern int policy_node_nodemask(struct mempolicy *mpol, gfp_t gfp_flags,
+				pgoff_t ilx, nodemask_t **nodemask);
 extern int huge_node(struct vm_area_struct *vma,
 				unsigned long addr, gfp_t gfp_flags,
 				struct mempolicy **mpol, nodemask_t **nodemask);
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index b858e22b259d..f3e572e17775 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1212,7 +1212,6 @@ static struct folio *alloc_migration_target_by_mpol(struct folio *src,
 	struct mempolicy *pol = mmpol->pol;
 	pgoff_t ilx = mmpol->ilx;
 	unsigned int order;
-	int nid = numa_node_id();
 	gfp_t gfp;
 
 	order = folio_order(src);
@@ -1221,10 +1220,11 @@ static struct folio *alloc_migration_target_by_mpol(struct folio *src,
 	if (folio_test_hugetlb(src)) {
 		nodemask_t *nodemask;
 		struct hstate *h;
+		int nid;
 
 		h = folio_hstate(src);
 		gfp = htlb_alloc_mask(h);
-		nodemask = policy_nodemask(gfp, pol, ilx, &nid);
+		nid = policy_node_nodemask(pol, gfp, ilx, &nodemask);
 		return alloc_hugetlb_folio_nodemask(h, nid, nodemask, gfp,
 				htlb_allow_alloc_fallback(MR_MEMPOLICY_MBIND));
 	}
@@ -1234,7 +1234,7 @@ static struct folio *alloc_migration_target_by_mpol(struct folio *src,
 	else
 		gfp = GFP_HIGHUSER_MOVABLE | __GFP_RETRY_MAYFAIL | __GFP_COMP;
 
-	return folio_alloc_mpol(gfp, order, pol, ilx, nid);
+	return folio_alloc_mpol(gfp, order, pol, ilx, numa_node_id());
 }
 #else
 
@@ -2084,6 +2084,27 @@ static nodemask_t *policy_nodemask(gfp_t gfp, struct mempolicy *pol,
 	return nodemask;
 }
 
+/**
+ * policy_node_nodemask(@mpol, @gfp_flags, @ilx, @nodemask)
+ * @mpol: the memory policy to interpret. Reference must be taken.
+ * @gfp_flags: for this request
+ * @ilx: interleave index, for use only when MPOL_INTERLEAVE or
+ *       MPOL_WEIGHTED_INTERLEAVE
+ * @nodemask: (output) pointer to nodemask pointer for 'bind' and 'prefer-many'
+ *            policy
+ *
+ * Returns a nid suitable for a page allocation and a pointer. If the effective
+ * policy is 'bind' or 'prefer-many', returns a pointer to the mempolicy's
+ * @nodemask for filtering the zonelist.
+ */
+int policy_node_nodemask(struct mempolicy *mpol, gfp_t gfp_flags,
+			 pgoff_t ilx, nodemask_t **nodemask)
+{
+	int nid = numa_node_id();
+	*nodemask = policy_nodemask(gfp_flags, mpol, ilx, &nid);
+	return nid;
+}
+
 #ifdef CONFIG_HUGETLBFS
 /*
  * huge_node(@vma, @addr, @gfp_flags, @mpol)
@@ -2102,12 +2123,8 @@ int huge_node(struct vm_area_struct *vma, unsigned long addr, gfp_t gfp_flags,
 		struct mempolicy **mpol, nodemask_t **nodemask)
 {
 	pgoff_t ilx;
-	int nid;
-
-	nid = numa_node_id();
 	*mpol = get_vma_policy(vma, addr, hstate_vma(vma)->order, &ilx);
-	*nodemask = policy_nodemask(gfp_flags, *mpol, ilx, &nid);
-	return nid;
+	return policy_node_nodemask(*mpol, gfp_flags, ilx, nodemask);
 }
 
 /*
@@ -2549,8 +2566,7 @@ unsigned long alloc_pages_bulk_array_mempolicy_noprof(gfp_t gfp,
 		return alloc_pages_bulk_array_preferred_many(gfp,
 				numa_node_id(), pol, nr_pages, page_array);
 
-	nid = numa_node_id();
-	nodemask = policy_nodemask(gfp, pol, NO_INTERLEAVE_INDEX, &nid);
+	nid = policy_node_nodemask(pol, gfp, NO_INTERLEAVE_INDEX, &nodemask);
 	return alloc_pages_bulk_noprof(gfp, nid, nodemask,
 				       nr_pages, NULL, page_array);
 }
-- 
2.46.0.598.g6f2099f65c-goog


