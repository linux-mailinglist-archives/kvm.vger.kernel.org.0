Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 819B9276FAB
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 13:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727398AbgIXLR4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Sep 2020 07:17:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24683 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726483AbgIXLR4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Sep 2020 07:17:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600946275;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=WkqZ/iREvhMbCNBzcXttwJxZSXR/+eOruAO+X3MZ0b8=;
        b=FkAkKHNspzQlAzCKL+zikJlBkkRt3g0ruA6QOT2cL5yVZ1YFClgWNz+AoaW3YR54Mh/J7N
        lmFOSN56dtHTxMmQ08HKDr6huRAg2MyNAKt/gAFSdHEp21I3lwlUTNl34sEP79l7SC57hp
        3/NRrbOd2gxk50x2sJ2xU7wkCUcP7h8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-91-beVbKS9UO_izwZ16RD0YQQ-1; Thu, 24 Sep 2020 07:17:53 -0400
X-MC-Unique: beVbKS9UO_izwZ16RD0YQQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D3E7356B55;
        Thu, 24 Sep 2020 11:17:52 +0000 (UTC)
Received: from thuth.com (ovpn-113-113.ams2.redhat.com [10.36.113.113])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3924255778;
        Thu, 24 Sep 2020 11:17:48 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>
Subject: [kvm-unit-tests PATCH] s390x/selftest: Fix constraint of inline assembly
Date:   Thu, 24 Sep 2020 13:17:46 +0200
Message-Id: <20200924111746.131633-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Clang on s390x compains:

/home/thuth/devel/kvm-unit-tests/s390x/selftest.c:39:15: error:
 %r0 used in an address
        asm volatile("  stg %0,0(%0)\n" : : "r"(-1L));
                     ^
<inline asm>:1:13: note: instantiated into assembly here
                stg %r0,0(%r0)
                          ^

Right it is. We should not use address register 0 for STG.
Thus let's use the "a" constraint to avoid register 0 here.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 s390x/selftest.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/s390x/selftest.c b/s390x/selftest.c
index 4c16646..eaf5b18 100644
--- a/s390x/selftest.c
+++ b/s390x/selftest.c
@@ -36,7 +36,7 @@ static void test_pgm_int(void)
 	check_pgm_int_code(PGM_INT_CODE_OPERATION);
 
 	expect_pgm_int();
-	asm volatile("	stg %0,0(%0)\n" : : "r"(-1L));
+	asm volatile("	stg %0,0(%0)\n" : : "a"(-1L));
 	check_pgm_int_code(PGM_INT_CODE_ADDRESSING);
 }
 
-- 
2.18.2

