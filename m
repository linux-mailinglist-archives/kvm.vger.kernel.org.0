Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61AD014DB4F
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 14:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727252AbgA3NLg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 08:11:36 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49266 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727260AbgA3NLf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jan 2020 08:11:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580389895;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XxF5rh0fjlJQF8gPvNefazXBystQtff0RuoMaUzH8Sw=;
        b=XPAn60Wy9T804vldyzYa0nCOj3ANZpLtbKFQ2rarpyOTUQ58MP5TTppkSS4g2XcrHmRhFd
        M1Kmx2zYW/cbekQM2gL/NZH8x1oe0Wic2M1Uw+iCDfhY06alJVucWqGZ3WnrgvAHtmGEd9
        iVhALH7PJDqHOwJ8xkKUB5XR/txMNSI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-258-nagE0HYuNZWz0fTgDFmFkA-1; Thu, 30 Jan 2020 08:11:33 -0500
X-MC-Unique: nagE0HYuNZWz0fTgDFmFkA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B29DC800D48;
        Thu, 30 Jan 2020 13:11:31 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-117-219.ams2.redhat.com [10.36.117.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1D5837793C;
        Thu, 30 Jan 2020 13:11:27 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>, david@redhat.com,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [kvm-unit-tests PULL 2/6] s390x: sclp: add service call instruction wrapper
Date:   Thu, 30 Jan 2020 14:11:12 +0100
Message-Id: <20200130131116.12386-3-david@redhat.com>
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

Add a wrapper for the service call instruction, and use it for SCLP
interactions instead of using inline assembly everywhere.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Message-Id: <20200120184256.188698-3-imbrenda@linux.ibm.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 lib/s390x/asm/arch_def.h | 13 +++++++++++++
 lib/s390x/sclp.c         |  7 +------
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index cf6e1ca..1a5e3c6 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -271,4 +271,17 @@ static inline int stsi(void *addr, int fc, int sel1,=
 int sel2)
 	return cc;
 }
=20
+static inline int servc(uint32_t command, unsigned long sccb)
+{
+	int cc;
+
+	asm volatile(
+		"       .insn   rre,0xb2200000,%1,%2\n"  /* servc %1,%2 */
+		"       ipm     %0\n"
+		"       srl     %0,28"
+		: "=3D&d" (cc) : "d" (command), "a" (sccb)
+		: "cc", "memory");
+	return cc;
+}
+
 #endif
diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
index 123b639..4054d0e 100644
--- a/lib/s390x/sclp.c
+++ b/lib/s390x/sclp.c
@@ -116,12 +116,7 @@ int sclp_service_call(unsigned int command, void *sc=
cb)
 	int cc;
=20
 	sclp_setup_int();
-	asm volatile(
-		"       .insn   rre,0xb2200000,%1,%2\n"  /* servc %1,%2 */
-		"       ipm     %0\n"
-		"       srl     %0,28"
-		: "=3D&d" (cc) : "d" (command), "a" (__pa(sccb))
-		: "cc", "memory");
+	cc =3D servc(command, __pa(sccb));
 	sclp_wait_busy();
 	if (cc =3D=3D 3)
 		return -1;
--=20
2.24.1

