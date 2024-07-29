Return-Path: <kvm+bounces-22521-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AB70193FD7F
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 20:39:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 242F0B21797
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 18:39:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A42E187325;
	Mon, 29 Jul 2024 18:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QkGj2IcC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F36C1419B5
	for <kvm@vger.kernel.org>; Mon, 29 Jul 2024 18:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722278348; cv=none; b=qF5Aj10h9EabM46Yc05Qj0hQ9ejwpLJ88HVdapH33v++sbBwH/cj5Qu6rhHBsMnVYNTwbaYct35iXIvZF5dG7AK5geZEMR8vGseXCbISwXkWjYQAZctZ7Xvebld9OFx4SD0TFalXEaxBUqL/svXmCHfQaDTggFgrnJ54aklEivU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722278348; c=relaxed/simple;
	bh=IWVi8Pr8sW021RhAGLAJlDE+PyLZkSOOvAS+fiTMESk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=l5eLFEoUAjJhJk6dqL6HjRnNTosZ2w1L8Z91e6xBjcJRr4KiNLtjBE2iYcNTII7O76m3XY6hZX1lPaOMHBd4GOFsYUetOCZ2ptTHdWHu5+AJzgnEjuzp1B4V4xr5yHh5sD8EGt9ADTtOC5cGW4adH4/RCB9vBv6y+YOjGPs1gkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QkGj2IcC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722278346;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=5PYsSiOWBQFI5JFl6WQemJ8OEXFzybl56PwzMET4SDg=;
	b=QkGj2IcCV0zTSennfNA6gcti1WwM5QjvJQzRIiFJVSh3VuFk5DOtt7p9Y/pfobqQBvaBh+
	olxktOGerryNQiMkrxlvEzi2ysDSny8h353uVHpj/8hPa8hA1Eqz6+iaI8Ge+PnfZmIJOn
	6JSMC9LUhYADLuuJru1GYH04MEfsVFk=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-580-fS78pyLtPMqfopk0SJeTEQ-1; Mon,
 29 Jul 2024 14:39:01 -0400
X-MC-Unique: fS78pyLtPMqfopk0SJeTEQ-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D43CD1955D56;
	Mon, 29 Jul 2024 18:38:58 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.39.192.25])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A1ED91955D42;
	Mon, 29 Jul 2024 18:38:50 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linux-s390@vger.kernel.org,
	kvm@vger.kernel.org,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [PATCH v1 0/3] mm: remove arch_make_page_accessible()
Date: Mon, 29 Jul 2024 20:38:41 +0200
Message-ID: <20240729183844.388481-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Now that s390x implements arch_make_folio_accessible(), let's convert
remaining users to use arch_make_folio_accessible() instead so we can
remove arch_make_page_accessible().

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>

David Hildenbrand (3):
  mm: simplify arch_make_folio_accessible()
  mm/gup: convert to arch_make_folio_accessible()
  s390/uv: drop arch_make_page_accessible()

 arch/s390/include/asm/page.h |  2 --
 arch/s390/kernel/uv.c        |  5 -----
 include/linux/mm.h           | 18 +-----------------
 mm/gup.c                     |  8 +++++---
 4 files changed, 6 insertions(+), 27 deletions(-)


base-commit: 3bb434b9ff9bfeacf7f4aef6ae036146ae3c40cc
-- 
2.45.2


