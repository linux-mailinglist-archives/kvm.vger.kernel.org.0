Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E312614DB51
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 14:11:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727355AbgA3NLs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 08:11:48 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:29039 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727351AbgA3NLs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jan 2020 08:11:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580389907;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zqtE94spb3QdD6uV4vKdidFvzEvD2Ju3yWRW2zPpAFI=;
        b=AegGwjQoI1Qez3UBLDRhiBSZPO/ZRF+UI+h2MAoHx9YPyBQxVffjmagJweCtbNUYHGSH69
        8hidHOBige7re8Km0m2RMw1xeGkqe0rK6mJfl8FeUkx4OngANgNlgRWNlGvMKxkaNcAx9t
        ya731sLEchJYdPIrtINZ3DxE1/AIJhU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-12-Iwbj_BeINmyicPtymb7OuA-1; Thu, 30 Jan 2020 08:11:44 -0500
X-MC-Unique: Iwbj_BeINmyicPtymb7OuA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 43D30107ACCD;
        Thu, 30 Jan 2020 13:11:43 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-117-219.ams2.redhat.com [10.36.117.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C919C77927;
        Thu, 30 Jan 2020 13:11:36 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>, david@redhat.com,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [kvm-unit-tests PULL 4/6] s390x: lib: add SPX and STPX instruction wrapper
Date:   Thu, 30 Jan 2020 14:11:14 +0100
Message-Id: <20200130131116.12386-5-david@redhat.com>
In-Reply-To: <20200130131116.12386-1-david@redhat.com>
References: <20200130131116.12386-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

Add a wrapper for the SET PREFIX and STORE PREFIX instructions, and
use it instead of using inline assembly.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Message-Id: <20200120184256.188698-5-imbrenda@linux.ibm.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 lib/s390x/asm/arch_def.h | 13 +++++++++++++
 s390x/intercept.c        | 24 +++++++++---------------
 2 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index 1a5e3c6..15a4d49 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -284,4 +284,17 @@ static inline int servc(uint32_t command, unsigned l=
ong sccb)
 	return cc;
 }
=20
+static inline void set_prefix(uint32_t new_prefix)
+{
+	asm volatile("	spx %0" : : "Q" (new_prefix) : "memory");
+}
+
+static inline uint32_t get_prefix(void)
+{
+	uint32_t current_prefix;
+
+	asm volatile("	stpx %0" : "=3DQ" (current_prefix));
+	return current_prefix;
+}
+
 #endif
diff --git a/s390x/intercept.c b/s390x/intercept.c
index 3696e33..5f46b82 100644
--- a/s390x/intercept.c
+++ b/s390x/intercept.c
@@ -13,6 +13,7 @@
 #include <asm/asm-offsets.h>
 #include <asm/interrupt.h>
 #include <asm/page.h>
+#include <asm/facility.h>
=20
 static uint8_t pagebuf[PAGE_SIZE * 2] __attribute__((aligned(PAGE_SIZE *=
 2)));
=20
@@ -26,13 +27,10 @@ static void test_stpx(void)
 	uint32_t new_prefix =3D (uint32_t)(intptr_t)pagebuf;
=20
 	/* Can we successfully change the prefix? */
-	asm volatile (
-		" stpx	%0\n"
-		" spx	%2\n"
-		" stpx	%1\n"
-		" spx	%0\n"
-		: "+Q"(old_prefix), "+Q"(tst_prefix)
-		: "Q"(new_prefix));
+	old_prefix =3D get_prefix();
+	set_prefix(new_prefix);
+	tst_prefix =3D get_prefix();
+	set_prefix(old_prefix);
 	report(old_prefix =3D=3D 0 && tst_prefix =3D=3D new_prefix, "store pref=
ix");
=20
 	expect_pgm_int();
@@ -63,14 +61,10 @@ static void test_spx(void)
 	 * some facility bits there ... at least some of them should be
 	 * set in our buffer afterwards.
 	 */
-	asm volatile (
-		" stpx	%0\n"
-		" spx	%1\n"
-		" stfl	0\n"
-		" spx	%0\n"
-		: "+Q"(old_prefix)
-		: "Q"(new_prefix)
-		: "memory");
+	old_prefix =3D get_prefix();
+	set_prefix(new_prefix);
+	stfl();
+	set_prefix(old_prefix);
 	report(pagebuf[GEN_LC_STFL] !=3D 0, "stfl to new prefix");
=20
 	expect_pgm_int();
--=20
2.24.1

