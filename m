Return-Path: <kvm+bounces-14536-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 09A308A307C
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 16:24:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 60B84B25F2F
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 14:24:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B549512D20E;
	Fri, 12 Apr 2024 14:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="guw8o70F"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E5612C530
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 14:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712931733; cv=none; b=IsyeGqxjEMNV/uu8G7/MycE6TGAaxnMS3kOstly88KuDPVGj+icCoOdySysJ0s6KqOxO0g+quXGXWK/EfBKkINF9fl7g+VZ0cNdbLJhKAq641GlSp/ckbOuteBliZw87fSNr1+QRq5XKZV2ngy6oSH++qbkiee+I4RMy12dkiYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712931733; c=relaxed/simple;
	bh=Phe+lYXoRi24QyGQuxCqNCGKvUUZ+0zh5Rap9SldaDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dCznQmFIgFrWcAxtVT3qJXkPYa1BCH5KbppE44cSqKTPzBaUoDAdGFjrFYHV9DE5LDqbMEFA7k5JLPymuq/Ps0oSSK7hSWDmrLDDro1UX6q5gcpFlZ2FkG5z7rwK4izePPmrtshS6+6VmR23GAYM+84nkq4Wue3OBuPOKv+gA3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=guw8o70F; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712931730;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xnfJ1VHTxISYLGq4mlbz2Skb/m7VY1n6kTTDVNpcpew=;
	b=guw8o70F/tdVBRO8ZzU/FGlfYr/PXYbvOYeKQH7Ym21dldbb88ABR6u0G19hq8I4yanYd5
	BiZ13+pd87AeS2m7jFLOhlMBOYIOFmetM0ms6lO0k5PtHJpmoBcrO9XHo4L6+PY3oXo6Or
	Nb006eI76s9KixeyETuQHnlfIy3OkhI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-679-OoCH9gzXMWuEIstknxSGTQ-1; Fri, 12 Apr 2024 10:22:07 -0400
X-MC-Unique: OoCH9gzXMWuEIstknxSGTQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8129F881E62;
	Fri, 12 Apr 2024 14:22:06 +0000 (UTC)
Received: from t14s.redhat.com (unknown [10.39.193.165])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3626940C6CBF;
	Fri, 12 Apr 2024 14:22:03 +0000 (UTC)
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
Subject: [PATCH v2 06/10] s390/uv: make uv_convert_from_secure() a static function
Date: Fri, 12 Apr 2024 16:21:16 +0200
Message-ID: <20240412142120.220087-7-david@redhat.com>
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

It's not used outside of uv.c, so let's make it a static function.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 arch/s390/include/asm/uv.h | 6 ------
 arch/s390/kernel/uv.c      | 2 +-
 2 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index 0e7bd3873907..d2205ff97007 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -484,7 +484,6 @@ int uv_pin_shared(unsigned long paddr);
 int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb);
 int gmap_destroy_page(struct gmap *gmap, unsigned long gaddr);
 int uv_destroy_owned_page(unsigned long paddr);
-int uv_convert_from_secure(unsigned long paddr);
 int uv_convert_owned_from_secure(unsigned long paddr);
 int gmap_convert_to_secure(struct gmap *gmap, unsigned long gaddr);
 
@@ -503,11 +502,6 @@ static inline int uv_destroy_owned_page(unsigned long paddr)
 	return 0;
 }
 
-static inline int uv_convert_from_secure(unsigned long paddr)
-{
-	return 0;
-}
-
 static inline int uv_convert_owned_from_secure(unsigned long paddr)
 {
 	return 0;
diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index ecfc08902215..3d3250b406a6 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -156,7 +156,7 @@ int uv_destroy_owned_page(unsigned long paddr)
  *
  * @paddr: Absolute host address of page to be exported
  */
-int uv_convert_from_secure(unsigned long paddr)
+static int uv_convert_from_secure(unsigned long paddr)
 {
 	struct uv_cb_cfs uvcb = {
 		.header.cmd = UVC_CMD_CONV_FROM_SEC_STOR,
-- 
2.44.0


