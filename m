Return-Path: <kvm+bounces-31298-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 743269C21F0
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 17:21:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 26EE21F21C29
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 16:21:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FE471990CD;
	Fri,  8 Nov 2024 16:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="o/GxW8x1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27FB6199240
	for <kvm@vger.kernel.org>; Fri,  8 Nov 2024 16:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731082856; cv=none; b=A060QK4xBawzJSGCrDs/uvTPTAk9TL8cnovEMIl96T3Sn0gRLrm5clA9j911GDKgYhMm08SaBLREYl3VHxrYC6Xa4TW8rAWTCZaiZt9GS8Lwl6dfkTZPTdqGATzRtU0JwiV7X2b+XaR4pfM1qrHVKI6E9yb2Oi/1xDZpTLhtt3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731082856; c=relaxed/simple;
	bh=h4L+KXVTwGkQMGdujiC/AYyjJPycReScryr5KWmZ71A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=m1fu+//1WxqGPQ8Q91kxQqchlIj6aCW9xosw2YFS9yr96Zuf5K+FRQxyfegBLQl3+NSvAc9GdgfdpLzrjKyoDhKiaOI4ALlOPTKHGiGENBq5wpI7f5044pD0v0e7d5Q70Vd2iI3x4G99y63ipqZxjbnlnadi1CrRiHVfLpGW81s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=o/GxW8x1; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6ea8a5e86e9so42834357b3.2
        for <kvm@vger.kernel.org>; Fri, 08 Nov 2024 08:20:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731082854; x=1731687654; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EuhnD2p0KG553uFJn8sTE5BvDRtJggITHppkxTMLSiU=;
        b=o/GxW8x131gcJSb9RNmv4ntAqyMWJ2LpNrUQoPvGh0jwVEB5ZDqmprMQOn+w7OXEg1
         PE9o3DeUNw4km6caLtF61kM08HhEBgOk98rl091alffzh/c+qj/heVVXEPv5YokLATXD
         IQwdiiVzYbjhHVAkvuLW1GnXYJ1S6US1WpWjhHFtdgWohsZgcyNcty/RnLMuMcU1WYeh
         kGMdorogPbnfbHnkCel6GyaCUxIWM7mqiqY7mwW98yejf+prJFylWW7exSqFGRaPRsV2
         xAyLJAuTBnQYEiGEd05yl8iK4xssD4zPvXk8inihd1APXPC7LUbG6WXU6XDqeGdPod3L
         PZqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731082854; x=1731687654;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EuhnD2p0KG553uFJn8sTE5BvDRtJggITHppkxTMLSiU=;
        b=Ng9k8L1i8eXDOuoAHCgDWqQPSbKhA8K8o2sMfQD6AWgVmpzDeo4Iwd4HCPKT9gr0rM
         Irle0OAW6swi4U9vL27IMWlmsdSg5EdT4DLRVU9/U4m8Oan3vDVnlQ3YEclIUh0MaokS
         y9xzZR4jZ9rhvtBegj0XrjE8i4vJO585sqdBIHKs5l4jkM/IXj8NwXxOaAbl/jhBGud+
         /TBoTqqoQRfwY0tQPuAqeqqtdBIUknxWMH+VxWntJjG1+HjpZI2Nd102T03cngzNa14a
         R5SVQuMHnbqMIXKwgsdiUit56OsXxOZlEc0v/EJVytDpChpRiUmeUDvBeseJ6bZJS/hl
         bmew==
X-Gm-Message-State: AOJu0YzwoVg59gnlaDCzk+M1fzl+pIxSdNxL8nW0Gr0vWTwMuqFykOvz
	6mKZjkn13vPfjtXIHQaGjGAIhHLmkz71Wtx7aKL/Z2QbfbtIDyXWfUiffwOWCpcoDI/ECfRXFw=
	=
X-Google-Smtp-Source: AGHT+IESFJvscd0BPH0GhrFsgF5ykZdsLy8VBXsCYVPr2h3JOn3SzzNujpcRbxNhrkNgQoNrxNGAtYBroQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a25:d001:0:b0:e30:d518:30f2 with SMTP id
 3f1490d57ef6-e337f8417b3mr2585276.1.1731082854058; Fri, 08 Nov 2024 08:20:54
 -0800 (PST)
Date: Fri,  8 Nov 2024 16:20:35 +0000
In-Reply-To: <20241108162040.159038-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241108162040.159038-1-tabba@google.com>
X-Mailer: git-send-email 2.47.0.277.g8800431eea-goog
Message-ID: <20241108162040.159038-6-tabba@google.com>
Subject: [RFC PATCH v1 05/10] mm/hugetlb: use folio->lru int demote_free_hugetlb_folios()
From: Fuad Tabba <tabba@google.com>
To: linux-mm@kvack.org
Cc: kvm@vger.kernel.org, nouveau@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, david@redhat.com, rppt@kernel.org, 
	jglisse@redhat.com, akpm@linux-foundation.org, muchun.song@linux.dev, 
	simona@ffwll.ch, airlied@gmail.com, pbonzini@redhat.com, seanjc@google.com, 
	willy@infradead.org, jgg@nvidia.com, jhubbard@nvidia.com, 
	ackerleytng@google.com, vannapurve@google.com, mail@maciej.szmigiero.name, 
	kirill.shutemov@linux.intel.com, quic_eberman@quicinc.com, maz@kernel.org, 
	will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk, 
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

From: David Hildenbrand <david@redhat.com>

Let's avoid messing with pages.

Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 mm/hugetlb.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index d58bd815fdf2..a64852280213 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3806,13 +3806,15 @@ static long demote_free_hugetlb_folios(struct hstate *src, struct hstate *dst,
 
 		for (i = 0; i < pages_per_huge_page(src); i += pages_per_huge_page(dst)) {
 			struct page *page = folio_page(folio, i);
+			struct folio *new_folio;
 
 			page->mapping = NULL;
 			clear_compound_head(page);
 			prep_compound_page(page, dst->order);
+			new_folio = page_folio(page);
 
-			init_new_hugetlb_folio(dst, page_folio(page));
-			list_add(&page->lru, &dst_list);
+			init_new_hugetlb_folio(dst, new_folio);
+			list_add(&new_folio->lru, &dst_list);
 		}
 	}
 
-- 
2.47.0.277.g8800431eea-goog


