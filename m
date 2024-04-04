Return-Path: <kvm+bounces-13578-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FE5D898C45
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 18:37:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1B080289F3A
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 16:37:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CADA12B148;
	Thu,  4 Apr 2024 16:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IArdbN3s"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 715BE12BEAB
	for <kvm@vger.kernel.org>; Thu,  4 Apr 2024 16:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712248636; cv=none; b=LuRgXIha741xEBCyw0Szcq556pGfHmligL0Cq8VRSL3/WtfOSf+jPtABlsK4+Ocq0htd6ddia+TzPSKwXrpYoov/bNkqX6osKCS7Rm87FdN3QI8xP40xvCXonRUT1Z3GY6tZMVsYrcR5TGPLcbkrB7VZGi7vm5g5YPUs4as0k2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712248636; c=relaxed/simple;
	bh=SXHj9/wEFGN76Sp3lJeZ2bNl1eT6+d7ErWDVUzf0EaY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WxOw9EG7fazU6m8QHucQywjcGEYHbxE9Og2bmodnhxZHWoLdxASDOyUXvHPhxZPlOaWOoadCP5lLr572Q8D9l5EXY+tZeJOzd+ZexVigTUm0CcqpO0sEcO+zNwc67i6/mWgagoonI3EQUi+p78otoS5gziHQlw23qPScEuqYUiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IArdbN3s; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712248633;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=2i4EI1wSyDo81mrMl0H/7Wwslnn2XIreCf4ZZweSpD4=;
	b=IArdbN3sIrWQTd1/4YYuXuZhv3AcmSOYtmJTb2p9OS3JfZe0E88V2vOi/yeQLEI28BCka/
	jv6/iRaVMOSM7m1exv13FBRQjxGh3YXVGCc0zDZXUvos1cXuUJ7cxIeQ0BpDRLH93nPKpu
	n2odXzl7SCHIRUOOOWZypAgJb2KFXqY=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-679-AtxE8RxIP922gaPsZUJwcA-1; Thu,
 04 Apr 2024 12:37:10 -0400
X-MC-Unique: AtxE8RxIP922gaPsZUJwcA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1FD7B1C0CCAD;
	Thu,  4 Apr 2024 16:37:08 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.39.192.101])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7B2343C21;
	Thu,  4 Apr 2024 16:37:03 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linux-s390@vger.kernel.org,
	kvm@vger.kernel.org,
	David Hildenbrand <david@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>
Subject: [PATCH v1 0/5] s390: page_mapcount(), page_has_private() and PG_arch_1
Date: Thu,  4 Apr 2024 18:36:37 +0200
Message-ID: <20240404163642.1125529-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

On my journey to remove page_mapcount(), I got hooked up on other folio
cleanups that Willy most certainly will enjoy.

This series removes the s390x usage of:
* page_mapcount() [patches WIP]
* page_has_private() [have patches to remove it]

... and makes PG_arch_1 only be set on folio->flags (i.e., never on tail
pages of large folios).

Further, one "easy" fix upfront.

... unfortunately there is one other issue I spotted that I am not
tackling in this series, because I am not 100% sure what we want to
do: the usage of page_ref_freeze()/folio_ref_freeze() in
make_folio_secure() is unsafe. :(

In make_folio_secure(), we're holding the folio lock, the mmap lock and
the PT lock. So we are protected against concurrent fork(), zap, GUP,
swapin, migration ... The page_ref_freeze()/ folio_ref_freeze() should
also block concurrent GUP-fast very reliably.

But if the folio is mapped into multiple page tables, we could see
concurrent zapping of the folio, a pagecache folios could get mapped/
accessed concurrent, we could see fork() sharing the page in another
process, GUP ... trying to adjust the folio refcount while we froze it.
Very bad.

For anonymous folios, it would likely be sufficient to check that
folio_mapcount() == 1. For pagecache folios, that's insufficient, likely
we would have to lock the pagecache. To handle folios mapped into
multiple page tables, we would have to do what
split_huge_page_to_list_to_order() does (temporary migration entries).

So it's a bit more involved, and I'll have to leave that to s390x folks to
figure out. There are othe reasonable cleanups I think, but I'll have to
focus on other stuff.

Compile tested, but not runtime tested, I'll appreiate some testing help
from people with UV access and experience.

Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
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

David Hildenbrand (5):
  s390/uv: don't call wait_on_page_writeback() without a reference
  s390/uv: convert gmap_make_secure() to work on folios
  s390/uv: convert PG_arch_1 users to only work on small folios
  s390/uv: update PG_arch_1 comment
  s390/hugetlb: convert PG_arch_1 code to work on folio->flags

 arch/s390/include/asm/page.h |   2 +
 arch/s390/kernel/uv.c        | 112 ++++++++++++++++++++++-------------
 arch/s390/mm/gmap.c          |   4 +-
 arch/s390/mm/hugetlbpage.c   |   8 +--
 4 files changed, 79 insertions(+), 47 deletions(-)

-- 
2.44.0


