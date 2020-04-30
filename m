Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 960441C0019
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 17:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbgD3PYw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 11:24:52 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24156 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726814AbgD3PYv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Apr 2020 11:24:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588260290;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UD/j5+1iXGhqPUgR0TfBbEOD/BrP+tUkdBHy9BoUCs0=;
        b=CDB1a1zv13j/MWNZ4eNvFRoWOYeXg6hexpZpsa5l9cETy8UT3735vKXxGPnqO398hkesgS
        vbYEQFc2ua6PsiB1ve8ey9hdCgJxXjFWXU2xjQLRlbX6dN4NqiHeWWBGJL1N1eNIhrzOEM
        mCbDTdhc88mcAJNUNQtZ8PEZBdeXcLg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-416-Wmc_HmfENzO2xqsqOihI-A-1; Thu, 30 Apr 2020 11:24:48 -0400
X-MC-Unique: Wmc_HmfENzO2xqsqOihI-A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 311DC107ACCD;
        Thu, 30 Apr 2020 15:24:47 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-113-172.ams2.redhat.com [10.36.113.172])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A6F5D5EDE3;
        Thu, 30 Apr 2020 15:24:45 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        linux-s390@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [kvm-unit-tests PULL 06/17] s390x: STFLE operates on doublewords
Date:   Thu, 30 Apr 2020 17:24:19 +0200
Message-Id: <20200430152430.40349-7-david@redhat.com>
In-Reply-To: <20200430152430.40349-1-david@redhat.com>
References: <20200430152430.40349-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

STFLE operates on doublewords, not bytes. Passing in "256" resulted in
some ignored bits getting set. Not bad, but also not clean.

Let's just convert our stfle handling code to operate on doublewords.

Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Message-Id: <20200401163305.31550-1-david@redhat.com>
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
2.25.3

