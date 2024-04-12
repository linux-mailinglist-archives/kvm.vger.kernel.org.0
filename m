Return-Path: <kvm+bounces-14530-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B1128A306A
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 16:22:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BB5E01C2131A
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 14:22:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3D1E127E31;
	Fri, 12 Apr 2024 14:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SAkUOyVY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7DB286ACC
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 14:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712931714; cv=none; b=D4AF7DqL5XcKYxgVTml0dPJXxqTbat1KN7g9DeT1u8IsvGnjcz0G9I8Sa2tdod/TVg38zv4rqets1lmJFnaQQt07hxT7ilMOXDRBr6YQ6ypVX18CiKPhAGfpzyd6+rJ/h6KotMxFJqwiVJYPjw6AjwuYiOJgPSSdLIIvC5ftsYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712931714; c=relaxed/simple;
	bh=K+6HTOJnwFp6JncWGOBXucWXLPkfQ9EILYLHiGGgUMs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZJWZ5qGFaRneigYNMUkEveGzEzi2/tYhlj+NrZB9w5an1VjWbbmuK30XYNrb0gNR+rCYwvcVBI1Ib03+dj3fGz9kK7CpMf9Z4SFuowp6qb26FEpXy6NbliUWHR/wOYCVpsyWFcpNb9KPgtAWf28ksNGlZUCrcXCJJTsbKzG1SbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SAkUOyVY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712931711;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=QXPWfkFHH0eKDY9i3utLqSp3pRrXAWTGDX0ZssDXaCM=;
	b=SAkUOyVY5KmeKO0KXDXyPQ38UeyVZcX6jyAJ1LZBZ51zQn0ducLYiCFODFkFQV5YAOdK4u
	80v0m8S9Md07ew/YJYZEfuJPFtKGPG4OKRrtOvLcKOdfHvkBvWB81Z8yNBw/bJbQSKKT8D
	tPoxwFfsXYjKK9Rp1jPYcakyPI2zwEw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-631-d9mE4TmeMi6VvcEsZiuYRQ-1; Fri, 12 Apr 2024 10:21:46 -0400
X-MC-Unique: d9mE4TmeMi6VvcEsZiuYRQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F30F280171B;
	Fri, 12 Apr 2024 14:21:44 +0000 (UTC)
Received: from t14s.redhat.com (unknown [10.39.193.165])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DD97B40C6CBF;
	Fri, 12 Apr 2024 14:21:41 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org,
	linux-s390@vger.kernel.org,
	David Hildenbrand <david@redhat.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Matthew Wilcox <willy@infradead.org>,
	Thomas Huth <thuth@redhat.com>
Subject: [PATCH v2 00/10] s390: PG_arch_1+folio cleanups for uv+hugetlb
Date: Fri, 12 Apr 2024 16:21:10 +0200
Message-ID: <20240412142120.220087-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

This is v2 of [1] with changed subject:
 "[PATCH v1 0/5] s390: page_mapcount(), page_has_private() and PG_arch_1"

Rebased on s390x/features which contains the page_mapcount() and
page_has_private() cleanups, and some PG_arch_1 cleanups from Willy. To
compensate, I added some more cleanups ;)

One "easy" fix upfront. Another issue I spotted is documented in [1].

Once this hits upstream, we can remove HAVE_ARCH_MAKE_PAGE_ACCESSIBLE
from core-mm and s390x, so only the folio variant will remain.

Compile tested, but not runtime tested with UV, I'll appreciate some
testing help from people with UV access and experience.

[1] https://lkml.kernel.org/r/20240404163642.1125529-1-david@redhat.com

v1 -> v2:
* Rebased on s390x/features:
* "s390/hugetlb: convert PG_arch_1 code to work on folio->flags"
 -> pmd_folio() not available on s390x/features
* "s390/uv: don't call folio_wait_writeback() without a folio reference"
 -> Willy's folio conversion is in s390x/features
* "s390/uv: convert PG_arch_1 users to only work on small folios"
 -> Add comments
* Rearrange code and handle split_folio() return values properly. New
  patches to handle splitting:
 -> "s390/uv: gmap_make_secure() cleanups for further changes"
 -> "s390/uv: split large folios in gmap_make_secure()"
* Added more cleanups:
 -> "s390/uv: make uv_convert_from_secure() a static function"
 -> "s390/uv: convert uv_destroy_owned_page() to uv_destroy_(folio|pte)()"
 -> "s390/uv: convert uv_convert_owned_from_secure() to
     uv_convert_from_secure_(folio|pte)()"
 -> "s390/mm: implement HAVE_ARCH_MAKE_FOLIO_ACCESSIBLE"

Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Thomas Huth <thuth@redhat.com>

David Hildenbrand (10):
  s390/uv: don't call folio_wait_writeback() without a folio reference
  s390/uv: gmap_make_secure() cleanups for further changes
  s390/uv: split large folios in gmap_make_secure()
  s390/uv: convert PG_arch_1 users to only work on small folios
  s390/uv: update PG_arch_1 comment
  s390/uv: make uv_convert_from_secure() a static function
  s390/uv: convert uv_destroy_owned_page() to uv_destroy_(folio|pte)()
  s390/uv: convert uv_convert_owned_from_secure() to
    uv_convert_from_secure_(folio|pte)()
  s390/uv: implement HAVE_ARCH_MAKE_FOLIO_ACCESSIBLE
  s390/hugetlb: convert PG_arch_1 code to work on folio->flags

 arch/s390/include/asm/page.h    |   5 +
 arch/s390/include/asm/pgtable.h |   8 +-
 arch/s390/include/asm/uv.h      |  12 +-
 arch/s390/kernel/uv.c           | 207 +++++++++++++++++++++-----------
 arch/s390/mm/fault.c            |  14 ++-
 arch/s390/mm/gmap.c             |  10 +-
 arch/s390/mm/hugetlbpage.c      |   8 +-
 7 files changed, 172 insertions(+), 92 deletions(-)

-- 
2.44.0


