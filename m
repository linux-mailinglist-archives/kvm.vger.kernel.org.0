Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4A514DB52
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 14:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727363AbgA3NLv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 08:11:51 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:38858 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727356AbgA3NLv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Jan 2020 08:11:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580389910;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zE0H4OKjNeVQ3tX4Xi7+inJ18C4QnIQe0wpraJt3MZ4=;
        b=HiEPX3uzWdl7iJbJLprPb9G3lijV9HvdC1vAdxboV5mc+ETlgaQw5eOcE96ceawxtDytpF
        D9Z3lreGQZWVjkiUHGybjk3ufz8ZgZkJ4CHlJb6G9n8acPf7fHUsDOkrckhNXJ6TTMKtHa
        Iif40iSq5pNMcSedwLfz7IB+RX7uctA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-413-O9i6Q2a1NvyHzXcQOvW27g-1; Thu, 30 Jan 2020 08:11:47 -0500
X-MC-Unique: O9i6Q2a1NvyHzXcQOvW27g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 71309800D6C;
        Thu, 30 Jan 2020 13:11:46 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-117-219.ams2.redhat.com [10.36.117.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F2FBD77927;
        Thu, 30 Jan 2020 13:11:43 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>, david@redhat.com,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [kvm-unit-tests PULL 5/6] s390x: lib: fix program interrupt handler if sclp_busy was set
Date:   Thu, 30 Jan 2020 14:11:15 +0100
Message-Id: <20200130131116.12386-6-david@redhat.com>
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

Fix the program interrupt handler for the case where sclp_busy is set.

The interrupt handler will attempt to write an error message on the
console using the SCLP, and will wait for sclp_busy to become false
before doing so. If an exception happenes between setting the flag and
the SCLP call, or if the call itself raises an exception, we need to
clear the flag so we can successfully print the error message.

Acked-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-Id: <20200120184256.188698-6-imbrenda@linux.ibm.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 lib/s390x/interrupt.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
index 05f30be..ccb376a 100644
--- a/lib/s390x/interrupt.c
+++ b/lib/s390x/interrupt.c
@@ -106,10 +106,13 @@ static void fixup_pgm_int(void)
=20
 void handle_pgm_int(void)
 {
-	if (!pgm_int_expected)
+	if (!pgm_int_expected) {
+		/* Force sclp_busy to false, otherwise we will loop forever */
+		sclp_handle_ext();
 		report_abort("Unexpected program interrupt: %d at %#lx, ilen %d\n",
 			     lc->pgm_int_code, lc->pgm_old_psw.addr,
 			     lc->pgm_int_id);
+	}
=20
 	pgm_int_expected =3D false;
 	fixup_pgm_int();
--=20
2.24.1

