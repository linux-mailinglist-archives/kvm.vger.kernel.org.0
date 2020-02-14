Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8300515DA0F
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 15:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387505AbgBNO7i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 09:59:38 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36753 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387499AbgBNO7h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Feb 2020 09:59:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581692376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Vi+NQYoOmU1ZDKZO+mIyuQFx3Qhtr4pAc4uPdqMXHLA=;
        b=fPm9cU1mTqZVmY8/5MTiIIzxaIt4n9Mn1ChJRecAH8WVPJoSzBz3zhMrgP8pVkh1PoKN/R
        sVd1mdddW0vIVKRSNYpebZY0qDgcpXNzEvZtgh4Tb1Kico2qvVWf8dNyqNhJMl9RPy/9bs
        l7WdoGm2I029TfpyzwqRbDnCOI5Tvq0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-273-8Li7mBloMIWLyQInalQMkw-1; Fri, 14 Feb 2020 09:59:35 -0500
X-MC-Unique: 8Li7mBloMIWLyQInalQMkw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1F119800D4E;
        Fri, 14 Feb 2020 14:59:34 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6ECF98AC43;
        Fri, 14 Feb 2020 14:59:32 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, bgardon@google.com, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, thuth@redhat.com, peterx@redhat.com
Subject: [PATCH 04/13] fixup! KVM: selftests: Add memory size parameter to the demand paging test
Date:   Fri, 14 Feb 2020 15:59:11 +0100
Message-Id: <20200214145920.30792-5-drjones@redhat.com>
In-Reply-To: <20200214145920.30792-1-drjones@redhat.com>
References: <20200214145920.30792-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[Rewrote parse_size() to simplify and provide user more flexibility as
 to how sizes are input. Also fixed size overflow assert.]
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/lib/test_util.c | 76 +++++++++------------
 1 file changed, 33 insertions(+), 43 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/=
selftests/kvm/lib/test_util.c
index 706e0f963a44..cbd7f51b07a1 100644
--- a/tools/testing/selftests/kvm/lib/test_util.c
+++ b/tools/testing/selftests/kvm/lib/test_util.c
@@ -4,58 +4,48 @@
  *
  * Copyright (C) 2020, Google LLC.
  */
-
-#include "test_util.h"
-
+#include <stdlib.h>
 #include <ctype.h>
+#include <limits.h>
+#include "test_util.h"
=20
 /*
  * Parses "[0-9]+[kmgt]?".
  */
 size_t parse_size(const char *size)
 {
-	size_t len =3D strlen(size);
-	size_t i;
-	size_t scale_shift =3D 0;
 	size_t base;
-
-	TEST_ASSERT(len > 0, "Need at least 1 digit in '%s'", size);
-
-	/* Find the first letter in the string, indicating scale. */
-	for (i =3D 0; i < len; i++) {
-		if (!isdigit(size[i])) {
-			TEST_ASSERT(i > 0, "Need at least 1 digit in '%s'",
-				    size);
-			TEST_ASSERT(i =3D=3D len - 1,
-				    "Expected letter at the end in '%s'.",
-				    size);
-			switch (tolower(size[i])) {
-			case 't':
-				scale_shift =3D 40;
-				break;
-			case 'g':
-				scale_shift =3D 30;
-				break;
-			case 'm':
-				scale_shift =3D 20;
-				break;
-			case 'k':
-				scale_shift =3D 10;
-				break;
-			default:
-				TEST_ASSERT(false, "Unknown size letter %c",
-					    size[i]);
-			}
-		}
+	char *scale;
+	int shift =3D 0;
+
+	TEST_ASSERT(size && isdigit(size[0]), "Need at least one digit in '%s'"=
, size);
+
+	base =3D strtoull(size, &scale, 0);
+
+	TEST_ASSERT(base !=3D ULLONG_MAX, "Overflow parsing size!");
+
+	switch (tolower(*scale)) {
+	case 't':
+		shift =3D 40;
+		break;
+	case 'g':
+		shift =3D 30;
+		break;
+	case 'm':
+		shift =3D 20;
+		break;
+	case 'k':
+		shift =3D 10;
+		break;
+	case 'b':
+	case '\0':
+		shift =3D 0;
+		break;
+	default:
+		TEST_ASSERT(false, "Unknown size letter %c", *scale);
 	}
=20
-	TEST_ASSERT(scale_shift < 8 * sizeof(size_t),
-		    "Overflow parsing scale!");
-
-	base =3D atoi(size);
-
-	TEST_ASSERT(!(base & ~((1 << (sizeof(size_t) - scale_shift)) - 1)),
-	       "Overflow parsing size!");
+	TEST_ASSERT((base << shift) >> shift =3D=3D base, "Overflow scaling siz=
e!");
=20
-	return base << scale_shift;
+	return base << shift;
 }
--=20
2.21.1

