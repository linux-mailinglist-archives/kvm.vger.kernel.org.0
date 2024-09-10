Return-Path: <kvm+bounces-26403-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 76DC19746A9
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 01:49:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3BD47287EB8
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 23:49:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32B9B1BC07E;
	Tue, 10 Sep 2024 23:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uD2ixa7T"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E090F1AD9C2
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 23:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726011893; cv=none; b=bHsahd2akC7PjVyJBEKdC2Tk1aV91j0Nvr6tqX7wpvwfXywbq88ou5rnANW3s8U8rmqUWZCzOjEPQns8v+IkUJNtLMvvkGvGaOw9qLZDDOyIRNgK+uAhsQqOz91lG/zw9rqOj4fmymy1suZWOUEum75hF+AusOHHE7mzmPOUj5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726011893; c=relaxed/simple;
	bh=5iqTuQB0fj5V1jzzqaRJUquxydmdc8dIqTru11KkJIU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HgXF84a7S+Ic2JGNYdviKX+3PG5wTCvZGOtWuwHS9g6ZENTmgFaAbIkQPYzumCOaM/SQ6c6gNYwANDtCJQ2hqXw4YPjeW6JHSSnP7/HXFlxiqyeD9uEOor963iURJAdi4NjnGBhaF20qpJx3Kqv6h8ZZZp5tprl/HZc/m3zNUng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uD2ixa7T; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2d8e59fcd4bso1529733a91.1
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 16:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726011891; x=1726616691; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2ar3js6y/uqSuZ8kEtPgJYc0vWuZF8j/b1JF25slk+c=;
        b=uD2ixa7TW6gUg899GkwZWVy9IuCOXKkt/uwlwU4r+x+CFqunpPNP3Rv+gbmz6FjgnJ
         HuD1NBITWm+znQzWHZoUylP0rPnuZIv+EpQ2y27vm5uyAjTAMpaU25UmiQ4KinVSoumm
         2APpgp3FXfYsmarEeoJX3oGvSPkwA3GlyXU6ee26c69K8qkAT1AeYhC19taRabegzXb1
         8h0QwaUM2QzXarzH0Vop18bbn4Zl3aHWNY9pUo4bRVTH+eN88CYcKfJAH48ytBV7z8bK
         e6ySzn8u2OW3MdEunjh0XSbKnyWrKyDuCkUaRgiBcXWRY/HXbSYfzvUpFqHHBsMj1/bm
         gZYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726011891; x=1726616691;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2ar3js6y/uqSuZ8kEtPgJYc0vWuZF8j/b1JF25slk+c=;
        b=DFh2MMM7SMLx02cvnNgLQZM6UQtGKR9G+FeNK38GtEx+NtrbwYvbatHspabqx38iQe
         ozUqCunv+sLo50x+3U2OkHYV021rHb8Bh1+tqUWq1CF5JhnsMX6mPLd/APH+iuzflvFY
         SYSKIR4rmBZafkpN0xWxMiVNyo4MiGXKpLRCNqyGwLmh4mh3wY6LQbFoLLy9WK9L4pHg
         Y4v/Kh06vu3fQ3lqmapGcYlVbmA3KZzgvhIEolDECyMryzCW0Dx+EvGCqk0e682IVtYO
         Evn2v+mRX8u7jwJOSF24gl2MXJknYTa1Mdwze1BjjjZmzWuBQdH6YfARn0cBeXSOmX2y
         McwQ==
X-Forwarded-Encrypted: i=1; AJvYcCVXh/n8VMTcqNEN9Yh0O0lPzSc/MJ9qxpjpMc1bdUNsOxOxyzoc2DUQmWKgIxSxCSWbJnM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+0H2uaq163Te4DuDrNg0m6SEVI4JDTw+lPxC261iIjSIyxL23
	R3AWdLJlLe6k1/t9AK9ro1hizwE74yLylQoQzojnrraGf7nCTEY4VZoLAvGRckCSgZimRO/4g80
	LxXA3QW7yZ2gWmIxzwK/6Qw==
X-Google-Smtp-Source: AGHT+IFJTKDezjG0ZGixJJEKykOQcK4Q2RdFfnGKlypTv43g1OIUEWvOedTsxO4Flime3+ygfPrCyueBrEPlyPHzTg==
X-Received: from ackerleytng-ctop.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:13f8])
 (user=ackerleytng job=sendgmr) by 2002:a17:90b:1e50:b0:2d2:453:1501 with SMTP
 id 98e67ed59e1d1-2db82e64986mr2443a91.2.1726011890733; Tue, 10 Sep 2024
 16:44:50 -0700 (PDT)
Date: Tue, 10 Sep 2024 23:43:42 +0000
In-Reply-To: <cover.1726009989.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1726009989.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
Message-ID: <3b49aeaa7ec0a91f601cde00b9e183bc75dc37a6.1726009989.git.ackerleytng@google.com>
Subject: [RFC PATCH 11/39] mm: hugetlb: Expose hugetlb_acct_memory()
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

This will used by guest_memfd in a later patch.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 include/linux/hugetlb.h | 2 ++
 mm/hugetlb.c            | 4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 9ef1adbd3207..4d47bf94c211 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -122,6 +122,8 @@ void hugepage_put_subpool(struct hugepage_subpool *spool);
 long hugepage_subpool_get_pages(struct hugepage_subpool *spool, long delta);
 long hugepage_subpool_put_pages(struct hugepage_subpool *spool, long delta);
 
+int hugetlb_acct_memory(struct hstate *h, long delta);
+
 void hugetlb_dup_vma_private(struct vm_area_struct *vma);
 void clear_vma_resv_huge_pages(struct vm_area_struct *vma);
 int move_hugetlb_page_tables(struct vm_area_struct *vma,
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index efdb5772b367..5a37b03e1361 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -93,7 +93,7 @@ struct mutex *hugetlb_fault_mutex_table ____cacheline_aligned_in_smp;
 
 /* Forward declaration */
 static int __hugetlb_acct_memory(struct hstate *h, long delta, bool use_surplus);
-static int hugetlb_acct_memory(struct hstate *h, long delta);
+int hugetlb_acct_memory(struct hstate *h, long delta);
 static void hugetlb_vma_lock_free(struct vm_area_struct *vma);
 static void hugetlb_vma_lock_alloc(struct vm_area_struct *vma);
 static void __hugetlb_vma_unlock_write_free(struct vm_area_struct *vma);
@@ -5170,7 +5170,7 @@ static int __hugetlb_acct_memory(struct hstate *h, long delta, bool use_surplus)
 	return ret;
 }
 
-static int hugetlb_acct_memory(struct hstate *h, long delta)
+int hugetlb_acct_memory(struct hstate *h, long delta)
 {
 	return __hugetlb_acct_memory(h, delta, true);
 }
-- 
2.46.0.598.g6f2099f65c-goog


