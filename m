Return-Path: <kvm+bounces-26395-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3830797468B
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 01:45:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CC3C5B24980
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 23:45:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DB0C1B2529;
	Tue, 10 Sep 2024 23:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Z/iNgi57"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2391AED29
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 23:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726011880; cv=none; b=f7b+enZnGFkHCxygrH1fvxyC5XgbCVuYMVVtxDaDvBnHhCvLOknwvByscMoJ2B4jRnpwqghrH1bgXDsHDy6zYM2QDWvsPHAPfoNo/i9cMXKqfufN49xKPRIbz7hzYpelEGfuvWdYPUIsaKvA1tkB4QU5wMshzi9cDpQRi/8qLho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726011880; c=relaxed/simple;
	bh=SUyjtMHnKCBirkEyGaCQmRTjwdwC4Zfx5OkiQdo5v1w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mu1HQQ679gmX2uS1GD3g3zPKIX3mQl1mrvpwL2O7MQ+k9WitcpoYE2FYkJZFfB/MixgtpFzXQhsq04U+MTwB7Y8URe5+bCw4cb2O8eAuAlgxJBYNvIeKzs6yegg61bZHm0OQVEbJJPjmIm47a6ZPgk+rcYGMz2SIo653qTjhuyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Z/iNgi57; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2070e327014so13330465ad.1
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 16:44:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726011878; x=1726616678; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=krcbfxFAJP32Bl8ts+LdeAkshb3wdoRz7FQc5et7+e0=;
        b=Z/iNgi57aLEHJg4BcLMEzaIvu5jOsIROElY/EBtvI6qVdPVdjkFe+bX0uuAZkcTjGU
         FH/UfqYH4n77GuNM9PL9ejze3Nb2Bu+YECbIR2UEFf9obE5fsigLdRUJCJQjRnN0WxqV
         7ZfeTMmiNMGQ3kYaLlal/jmJaQAaKKmRrySdMiURWwuUN5nZtewgxDvbo+l15gFbQLH1
         Kkc5+84prctqRJoHUe0u+dJ4tk0OADpyBx00EgaGsV1k+Li72EM/CqUZbMR+Vy5dXNoN
         cestXe4N9cN3Aw4GOJAaCUDZNEWVMFxJlAbFHtcDeXqmUGihf8PmU5a2JB5gUg2erJth
         jsrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726011878; x=1726616678;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=krcbfxFAJP32Bl8ts+LdeAkshb3wdoRz7FQc5et7+e0=;
        b=mfUe56HFmY5lmVyb+HEOL1WOwUBgVFEI63XtXdKGa0pVwVcIW04zF94HMj5vvBkR7Y
         NVdEdGa+KmZo6Gwx0sjlWNki6wZFvwGQI5ctTB3N8bF9s5QsEhPuE8OPx2hNbezS/mL5
         rYTGtVCTwxalXttjw74GTEdooAfrai0ehqTGMb8bIPQB+YZjWS/Hrc9Oex4t13Bl+d4n
         yG9+bCO5UUIK+cwcyehmYmX8M3DfaHP+4KeKkhj1nTtOkDdy8/yQalI0izkd2vN+09LL
         cRazXnQ1uJHlLANU7QHEmkD21xlhBwZUaWGpGNrZKNtul7HHmy8Wzbk3gHLtGUQqVUmS
         2AvA==
X-Forwarded-Encrypted: i=1; AJvYcCWG8kKbwi7C0OX//do/6Ow9aRYpCvQHcDEisYrn/v1rD2YfoSdF/hBCVTBe4BvjpMPZolM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxVzxx2lic0UNg5zcOIRINZ7SkPYNqHe0TFP3W1CtAX790X526n
	uwfehbPaYoHlA97ejEwkKdCcH5duDyP6Pt/pAFrLEfGsALQImap9LUe9SfcY4DW1O6eHMEIDEXd
	kAZxdJA0f7bMV6fGGWcKztA==
X-Google-Smtp-Source: AGHT+IGzA4nKfM70wloRZKktU8I5wwl9MfYLThvDDzHIgaA6loY/0Smr81sI2GQQVA1zTeWX0Ryp6QAH+KUadLwDFg==
X-Received: from ackerleytng-ctop.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:13f8])
 (user=ackerleytng job=sendgmr) by 2002:a17:903:1c3:b0:205:71f1:853f with SMTP
 id d9443c01a7336-207521d6944mr178125ad.5.1726011878156; Tue, 10 Sep 2024
 16:44:38 -0700 (PDT)
Date: Tue, 10 Sep 2024 23:43:34 +0000
In-Reply-To: <cover.1726009989.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1726009989.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
Message-ID: <5a5e998e8f154c28a28dcdab73fb563f658f2f51.1726009989.git.ackerleytng@google.com>
Subject: [RFC PATCH 03/39] mm: hugetlb: Remove unnecessary check for avoid_reserve
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

If avoid_reserve is true, gbl_chg is not used anyway, so there is no
point in setting gbl_chg.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 mm/hugetlb.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 597102ed224b..5cf7fb117e9d 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3166,16 +3166,6 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 		if (gbl_chg < 0)
 			goto out_end_reservation;
 
-		/*
-		 * Even though there was no reservation in the region/reserve
-		 * map, there could be reservations associated with the
-		 * subpool that can be used.  This would be indicated if the
-		 * return value of hugepage_subpool_get_pages() is zero.
-		 * However, if avoid_reserve is specified we still avoid even
-		 * the subpool reservations.
-		 */
-		if (avoid_reserve)
-			gbl_chg = 1;
 	}
 
 	/* If this allocation is not consuming a reservation, charge it now.
-- 
2.46.0.598.g6f2099f65c-goog


