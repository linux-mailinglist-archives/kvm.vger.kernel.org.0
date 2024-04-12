Return-Path: <kvm+bounces-14534-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 045428A3074
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 16:23:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AE9D9282F49
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 14:23:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA56412C487;
	Fri, 12 Apr 2024 14:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BuxXbBCV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30CA12C46A
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 14:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712931729; cv=none; b=G4HiAHR18GkgUG+hDP2bqeUVTJu6kEP3dK/u03nS/Cv8P2MlXLCCFYyUSOK8XQ20pfJlaUD46UaqIrV9hY3hVRpGkaXBS2wxVczjnIgCDopeDSjnX5K3xOUghqp5531ygghHOh7N7rfSROg7jrQLavYoOA9KX2M0paSPiEmXMOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712931729; c=relaxed/simple;
	bh=7fOLPHwtedPlEEz5+ot3Sre0AWrOfx+hG0wRkCREkFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RA5nOtqezhL+ecZi88IUwuMnkP2IhJ/v8YbM6B+HAKI5BdaKGQ5teufMNeZlm3fcACuf6xBDlMLiMeXtP0w/jNxZZ9UQ1uozMWFWmKvVEFI1l21eeN5ihaxBfmOd0j1O2ZjeqpXm8GbJIQ9Aw49zbyFEPT1mWPDTc2yuMOpK8Ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BuxXbBCV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712931726;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cuxxsq8XZw+QG+w/Ssgwsbj/UZc1HUhjcOJATM75AJM=;
	b=BuxXbBCVtysAMoQgrlWvUddbJBtkB44buIuMb9Gcbl1z1Ixls5R+jjLLy2Vpf8Dbc3cEyW
	i1VpF5W3DIeurUIcZo55BwdXGP1yuONvebTRSPwIxRt7yz9LgUawGXUMNknP4N4FObDQCu
	jLjpk1iNKvRcfXWsCAT1FAn2yMfu5nw=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-460-EAuPk9GYPqWpjgocvxHjTQ-1; Fri,
 12 Apr 2024 10:22:03 -0400
X-MC-Unique: EAuPk9GYPqWpjgocvxHjTQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C67B629AB3E5;
	Fri, 12 Apr 2024 14:22:02 +0000 (UTC)
Received: from t14s.redhat.com (unknown [10.39.193.165])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 843C740C6DAE;
	Fri, 12 Apr 2024 14:21:59 +0000 (UTC)
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
Subject: [PATCH v2 05/10] s390/uv: update PG_arch_1 comment
Date: Fri, 12 Apr 2024 16:21:15 +0200
Message-ID: <20240412142120.220087-6-david@redhat.com>
In-Reply-To: <20240412142120.220087-1-david@redhat.com>
References: <20240412142120.220087-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

We removed the usage of PG_arch_1 for page tables in commit
a51324c430db ("s390/cmma: rework no-dat handling").

Let's update the comment in UV to reflect that.

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 arch/s390/kernel/uv.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index 914dcec27329..ecfc08902215 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -495,13 +495,12 @@ int arch_make_page_accessible(struct page *page)
 		return 0;
 
 	/*
-	 * PG_arch_1 is used in 3 places:
-	 * 1. for kernel page tables during early boot
-	 * 2. for storage keys of huge pages and KVM
-	 * 3. As an indication that this small folio might be secure. This can
+	 * PG_arch_1 is used in 2 places:
+	 * 1. for storage keys of hugetlb folios and KVM
+	 * 2. As an indication that this small folio might be secure. This can
 	 *    overindicate, e.g. we set the bit before calling
 	 *    convert_to_secure.
-	 * As secure pages are never huge, all 3 variants can co-exists.
+	 * As secure pages are never large folios, both variants can co-exists.
 	 */
 	if (!test_bit(PG_arch_1, &folio->flags))
 		return 0;
-- 
2.44.0


