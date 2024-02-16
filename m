Return-Path: <kvm+bounces-8905-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 09C898585E1
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 20:01:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8C4B62840C0
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 19:01:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB64013541F;
	Fri, 16 Feb 2024 19:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M7zoBI4Z"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE0A1353EF
	for <kvm@vger.kernel.org>; Fri, 16 Feb 2024 19:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708110060; cv=none; b=Yje3/U/1dZJ4BnbIVqOyFOGFunD5KfKCjRII1LtmbVzF644ETEqEJ1M3BJMRCiGC1K8OjPmBEaVlSmZD+t3JEOQJ/qjjeeJkiAdX3/YHJvKTIDRXD4Z4nZ7AeYfIE0M6b45FGxHufGERxwH58nGZgNYnYQzbBh+sJOv1l/E6B5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708110060; c=relaxed/simple;
	bh=Yj1DLuFAHhRVzABVro82zXPj9Y+ZiKikd+RSYP0I3Bo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=dDlaNyFU/Qksn5U5ZjTSLMDH1hrBBJU5U7wcGYjRnsEKnbGPGPNgNfEVCZPnKxUow29N6efKiZ9P5XrnzVjy6Z+3Rlc5/FsyDFuJbmP2moB8zg0VcJmRKrAaI3wm0gY7ZugWiAsCXKhUJws0Rc2/0TT4kG7ENMaeyPJecTESDQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M7zoBI4Z; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708110057;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=9rV2I4qDQqipxUQlTN+VO+51VV+6LJI9xW6T48mbZMw=;
	b=M7zoBI4Zt1rjFydgGFwjb2Wc7Elsp7Zt94jze8SVO6IU+8ukxzsP/tiTKn7aSW+8Y0QKkK
	A9LyCLKTa/h2UGBkSMc1CCTVtCUbLdEtrC3WBtrA+chec1bfQizkPwxlzWo+gy4uecA+qG
	LwcjOEuEMdbULGnt9OdlHKcKDlxqUu4=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-524-FA6tnD0CMpKOBT5bHoBLcg-1; Fri,
 16 Feb 2024 14:00:52 -0500
X-MC-Unique: FA6tnD0CMpKOBT5bHoBLcg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7EABC3C0F187;
	Fri, 16 Feb 2024 19:00:51 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.39.192.30])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4F0D4492BE3;
	Fri, 16 Feb 2024 19:00:49 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: kvm@vger.kernel.org,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	=?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>
Cc: linux-s390@vger.kernel.org,
	David Hildenbrand <david@redhat.com>,
	Jan Richter <jarichte@redhat.com>
Subject: [kvm-unit-tests PATCH] s390x/snippets/c/sie-dat: Fix compiler warning with GCC 11.2
Date: Fri, 16 Feb 2024 20:00:48 +0100
Message-ID: <20240216190048.83801-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

GCC 11.2.1 from RHEL 9.0 complains:

 s390x/snippets/c/sie-dat.c: In function ‘main’:
 s390x/snippets/c/sie-dat.c:51:22: error: writing 1 byte into a region of size 0 [-Werror=stringop-overflow=]
    51 |         *invalid_ptr = 42;
       |         ~~~~~~~~~~~~~^~~~
 cc1: all warnings being treated as errors

Let's use the OPAQUE_PTR() macro here too, which we already used
in other spots to fix similar -Wstringop-overflow warnings.

Reported-by: Jan Richter <jarichte@redhat.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 s390x/snippets/c/sie-dat.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/s390x/snippets/c/sie-dat.c b/s390x/snippets/c/sie-dat.c
index ecfcb60e..9d89801d 100644
--- a/s390x/snippets/c/sie-dat.c
+++ b/s390x/snippets/c/sie-dat.c
@@ -9,6 +9,7 @@
  */
 #include <libcflat.h>
 #include <asm-generic/page.h>
+#include <asm/mem.h>
 #include "sie-dat.h"
 
 static uint8_t test_pages[GUEST_TEST_PAGE_COUNT * PAGE_SIZE] __attribute__((__aligned__(PAGE_SIZE)));
@@ -47,7 +48,7 @@ int main(void)
 	force_exit();
 
 	/* the first unmapped address */
-	invalid_ptr = (uint8_t *)(GUEST_TOTAL_PAGE_COUNT * PAGE_SIZE);
+	invalid_ptr = OPAQUE_PTR(GUEST_TOTAL_PAGE_COUNT * PAGE_SIZE);
 	*invalid_ptr = 42;
 
 	/* indicate we've written the non-allowed page (should never get here) */
-- 
2.43.0


