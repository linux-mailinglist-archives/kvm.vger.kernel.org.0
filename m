Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4301D3EB46B
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 13:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240053AbhHMLM4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 07:12:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60507 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239842AbhHMLMz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Aug 2021 07:12:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628853148;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n6jYw1yE2ZotbitHQWIkZk1MjslczNMHhrJaIV09Hiw=;
        b=D9sVw094fA13wCySD50ZeQavJ8kxW6y6v7zKAWw531HPqvs0KYHAdpb3Z8NV2ChQMdChsl
        xKDfuVW85QfpX2sMs2YSqlACwQiVJQvEDSOySIc2lMwRNatWBuD07L7HOG1nEOuqoDHU4l
        wMZaguq4BluzFyU2JSSbQjpNa4YPy2E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-230-Ok5s957lPsOXDHjhBhLChA-1; Fri, 13 Aug 2021 07:12:27 -0400
X-MC-Unique: Ok5s957lPsOXDHjhBhLChA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ADDE71853026;
        Fri, 13 Aug 2021 11:12:26 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6E1EB60C04;
        Fri, 13 Aug 2021 11:12:26 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     babu.moger@amd.com
Subject: [PATCH kvm-unit-tests 1/2] access: optimize check for multiple reserved bits
Date:   Fri, 13 Aug 2021 07:12:24 -0400
Message-Id: <20210813111225.3603660-2-pbonzini@redhat.com>
In-Reply-To: <20210813111225.3603660-1-pbonzini@redhat.com>
References: <20210813111225.3603660-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Instead of using multiple ANDs statements, build a mask and check
it for more than one set bit.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/access.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/x86/access.c b/x86/access.c
index c71f39d..6285c8c 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -288,6 +288,7 @@ static int ac_test_bump_one(ac_test_t *at)
 static _Bool ac_test_legal(ac_test_t *at)
 {
     int flags = at->flags;
+    unsigned reserved;
 
     if (F(AC_ACCESS_FETCH) && F(AC_ACCESS_WRITE))
 	return false;
@@ -321,8 +322,12 @@ static _Bool ac_test_legal(ac_test_t *at)
      * error code; the odds of a KVM bug are super low, and the odds of actually
      * being able to detect a bug are even lower.
      */
-    if ((F(AC_PDE_BIT51) + F(AC_PDE_BIT36) + F(AC_PDE_BIT13) +
-        F(AC_PTE_BIT51) + F(AC_PTE_BIT36)) > 1)
+    reserved = (AC_PDE_BIT51_MASK | AC_PDE_BIT36_MASK | AC_PDE_BIT13_MASK |
+	        AC_PTE_BIT51_MASK | AC_PTE_BIT36_MASK);
+
+    /* Only test one reserved bit at a time.  */
+    reserved &= flags;
+    if (reserved & (reserved - 1))
         return false;
 
     return true;
-- 
2.27.0


