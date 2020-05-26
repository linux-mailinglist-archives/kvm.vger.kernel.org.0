Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A308119B13F
	for <lists+kvm@lfdr.de>; Wed,  1 Apr 2020 18:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387822AbgDAQdT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Apr 2020 12:33:19 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:32293 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388522AbgDAQdQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 1 Apr 2020 12:33:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585758794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=/uHYR3Hg3qBZEmTsxulFkg4E+9gG5trSXBJP5OBFkXs=;
        b=YESoXzyMYgJdOZDNqVsEF8DN2Qqr9YOOdqqqI+c/sdAuk3VxQE7mloSYn2uMGcCVxx8SSK
        n8R5UmcmWIW6krIlrANU7UFMMmqUOCiT6/OP188C1o6SUbx4+4WDVdK3OdcC+LrDofzOeM
        f+/wJB+c5MeeS66Bdes8n/0cWDXdvl4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-465-g5E3kL6HOg2sxZlQy6C5Mw-1; Wed, 01 Apr 2020 12:33:11 -0400
X-MC-Unique: g5E3kL6HOg2sxZlQy6C5Mw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 02A3019067E0;
        Wed,  1 Apr 2020 16:33:10 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-114-59.ams2.redhat.com [10.36.114.59])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E229B166B7;
        Wed,  1 Apr 2020 16:33:05 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>
Subject: [kvm-unit-tests PATCH v1] s390x: STFLE operates on doublewords
Date:   Wed,  1 Apr 2020 18:33:05 +0200
Message-Id: <20200401163305.31550-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

STFLE operates on doublewords, not bytes. Passing in "256" resulted in
some ignored bits getting set. Not bad, but also not clean.

Let's just convert our stfle handling code to operate on doublewords.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 lib/s390x/asm/facility.h | 14 +++++++-------
 lib/s390x/io.c           |  2 +-
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/lib/s390x/asm/facility.h b/lib/s390x/asm/facility.h
index e34dc2c..def2705 100644
--- a/lib/s390x/asm/facility.h
+++ b/lib/s390x/asm/facility.h
@@ -14,12 +14,12 @@
 #include <asm/facility.h>
 #include <asm/arch_def.h>
=20
-#define NR_STFL_BYTES 256
-extern uint8_t stfl_bytes[];
+#define NB_STFL_DOUBLEWORDS 32
+extern uint64_t stfl_doublewords[];
=20
 static inline bool test_facility(int nr)
 {
-	return stfl_bytes[nr / 8] & (0x80U >> (nr % 8));
+	return stfl_doublewords[nr / 64] & (0x8000000000000000UL >> (nr % 64));
 }
=20
 static inline void stfl(void)
@@ -27,9 +27,9 @@ static inline void stfl(void)
 	asm volatile("	stfl	0(0)\n" : : : "memory");
 }
=20
-static inline void stfle(uint8_t *fac, unsigned int len)
+static inline void stfle(uint64_t *fac, unsigned int nb_doublewords)
 {
-	register unsigned long r0 asm("0") =3D len - 1;
+	register unsigned long r0 asm("0") =3D nb_doublewords - 1;
=20
 	asm volatile("	.insn	s,0xb2b00000,0(%1)\n"
 		     : "+d" (r0) : "a" (fac) : "memory", "cc");
@@ -40,9 +40,9 @@ static inline void setup_facilities(void)
 	struct lowcore *lc =3D NULL;
=20
 	stfl();
-	memcpy(stfl_bytes, &lc->stfl, sizeof(lc->stfl));
+	memcpy(stfl_doublewords, &lc->stfl, sizeof(lc->stfl));
 	if (test_facility(7))
-		stfle(stfl_bytes, NR_STFL_BYTES);
+		stfle(stfl_doublewords, NB_STFL_DOUBLEWORDS);
 }
=20
 #endif
diff --git a/lib/s390x/io.c b/lib/s390x/io.c
index e091c37..c0f0bf7 100644
--- a/lib/s390x/io.c
+++ b/lib/s390x/io.c
@@ -19,7 +19,7 @@
 #include "smp.h"
=20
 extern char ipl_args[];
-uint8_t stfl_bytes[NR_STFL_BYTES] __attribute__((aligned(8)));
+uint64_t stfl_doublewords[NB_STFL_DOUBLEWORDS];
=20
 static struct spinlock lock;
=20
--=20
2.25.1

