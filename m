Return-Path: <kvm+bounces-49414-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9604EAD8D4D
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 15:41:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 38F127A1A40
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 13:40:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9510A192580;
	Fri, 13 Jun 2025 13:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LWYGgfM2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33980158DA3
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 13:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749822081; cv=none; b=VeCXqAWtwznn9harY9AdWImsvABPFmLdMZ/wF1n2qgXefBt/htUvF2W5mtaGvOyjw945v9gQ9hFfgt4/hPxmCyNvEk7y2iDi4jbcxY0vUe/vNyzIn7Z8hdioP5Ud1rUaTDCGRH7/d62r19WRfwstHAopJMKhMZ/bsIj9B6QOEFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749822081; c=relaxed/simple;
	bh=gTS/EUIP8VCBOB3dazG/2BtugSlfm9QH354rN6o3IrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZyfsZVN98silBeRuLHgIzDaYApQflzNXubxM7pLMW8ZPseod73nWg9roROmg6pFQ1+sgNi0u0BgMQ7PjykY8jPl+xmXtVaAPg2gFWBEYipm3CNWDpU7Sohd8pz85kWtkxMPp+riq1IzmICBSoTG8t4syzoFKl3EM2OuoY7RHqSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LWYGgfM2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749822079;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z7W5IE9G9/u3/1BfK2SYpnNa28U9EpjOusASuWz1vAk=;
	b=LWYGgfM2ol8cVYF/k46SCgAMoogeSHgVSdzvDOTi+B6n+2e0W2ivZDqx95XDyIIY0o4QJh
	UfeYECEwhhkmcJ8LgiPpDLBm8Ni6+96P497onFS1ONV3NP5kIrcg9VMdcxLk0wMK+shhe2
	JYE8OXBLOfbugnLSqdnCHmdaKP7LUy0=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-669-NAKnTjp4NE-vz6591PnuIQ-1; Fri, 13 Jun 2025 09:41:18 -0400
X-MC-Unique: NAKnTjp4NE-vz6591PnuIQ-1
X-Mimecast-MFC-AGG-ID: NAKnTjp4NE-vz6591PnuIQ_1749822077
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7caee990721so507488085a.1
        for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 06:41:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749822077; x=1750426877;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z7W5IE9G9/u3/1BfK2SYpnNa28U9EpjOusASuWz1vAk=;
        b=LcL9R9eKevT44K8RKNpeGQDYAqxLq9Iy6a9wuRG9cjJpX+E6Rtt0pYh/2megDYW9Xa
         9B/61r9IIvts3HAXwQ/QjAEvYI4OrQgEyIrc5eJjkbj7AaeLx7k5pliyTil5vzPK+IUX
         EMHNnCmZ4AwMoUP7GbGVTcxA3g5DLla7vZniEfwZnzxDb922b6w3day+cH+y3qvH+FdH
         v6ciUn0Ral58qnr2LH4BbeU3RiBOjCXcgYE3JGfblVYW7zyyOEDRaGumIGHoorqm4gfN
         AfO0O7O0BAwyNh3WEJdVdeOHV22DdAiy2DzC+SUVa97feAYGdxJiDso2kmZOpCJBHBrk
         fq6A==
X-Forwarded-Encrypted: i=1; AJvYcCXJ+3US2Gs1dGIl/J3vW/OZabFNFi8AeD1Gu9z2gG+PD2ZliDvQ1AwAmOn9o7wU5HgfkoI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzG/moolAPJKXR9wxwC+JDSFQ7kSNIsCJw8NIXr23TdwHXR0KCe
	3c0uTKu6+sz2Yl0jXgFnG1r/6DSoEqob51EQy4Cb65ii7lkP0MbIj7wQaj9S2pktBKSPIfCEm9D
	Ye0+c+bYt2W+t8eJPAifXFLqkDOidFJX870fBzYLnAwWoD1BHzvUhkA==
X-Gm-Gg: ASbGnctoBdN4thhDd6i1cwjSLkqq7YOI9TEY1HkpGnEdIOVZ2rDzgf4kVBkNtlNdMo2
	Niu/uXXO+XzelIUGo9gjmElSUPNzs4GxWB0eMe/9y21HE9XVhuwL0YMpzqma3EMUBoYZ3+LT4gJ
	u7jLDA20yovWsyuk0I+9C6IaLflA3k+oUbnmQyiunW4FsOrBP/2E6GWP/d3qHJRT7DrG8CpjP8E
	L52o/8+7REzyl9JnJWK6vqu20nQ2xaYZJBKG5celP47hcwS5CfjP2juivf82gyyDa/iLmSviWQm
	ngeTSbJ5X2o=
X-Received: by 2002:a05:620a:3728:b0:7d3:914b:abe8 with SMTP id af79cd13be357-7d3bc4475a7mr706294085a.36.1749822077576;
        Fri, 13 Jun 2025 06:41:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFLW9momYNJwfmPgxDbKad4mtJlNzLyJURmiqrfzObWILrSALY5rlf3s+E58Q/NYKr9xf6MiQ==
X-Received: by 2002:a05:620a:3728:b0:7d3:914b:abe8 with SMTP id af79cd13be357-7d3bc4475a7mr706288985a.36.1749822077027;
        Fri, 13 Jun 2025 06:41:17 -0700 (PDT)
Received: from x1.com ([85.131.185.92])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7d3b8ee3f72sm171519285a.94.2025.06.13.06.41.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jun 2025 06:41:15 -0700 (PDT)
From: Peter Xu <peterx@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kvm@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Alex Mastro <amastro@fb.com>,
	David Hildenbrand <david@redhat.com>,
	Nico Pache <npache@redhat.com>,
	peterx@redhat.com
Subject: [PATCH 1/5] mm: Deduplicate mm_get_unmapped_area()
Date: Fri, 13 Jun 2025 09:41:07 -0400
Message-ID: <20250613134111.469884-2-peterx@redhat.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250613134111.469884-1-peterx@redhat.com>
References: <20250613134111.469884-1-peterx@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Essentially it sets vm_flags==0 for mm_get_unmapped_area_vmflags().  Use
the helper instead to dedup the lines.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 mm/mmap.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 09c563c95112..422f5b9d9660 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -871,9 +871,8 @@ mm_get_unmapped_area(struct mm_struct *mm, struct file *file,
 		     unsigned long addr, unsigned long len,
 		     unsigned long pgoff, unsigned long flags)
 {
-	if (test_bit(MMF_TOPDOWN, &mm->flags))
-		return arch_get_unmapped_area_topdown(file, addr, len, pgoff, flags, 0);
-	return arch_get_unmapped_area(file, addr, len, pgoff, flags, 0);
+	return mm_get_unmapped_area_vmflags(mm, file, addr, len,
+					    pgoff, flags, 0);
 }
 EXPORT_SYMBOL(mm_get_unmapped_area);
 
-- 
2.49.0


