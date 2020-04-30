Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B684C1C0029
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 17:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727790AbgD3PZP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 11:25:15 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:47805 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726701AbgD3PZO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Apr 2020 11:25:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588260313;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vc4y+38sfY2AqjlWqsyiGmpTqIgBJ39IMpZ6Li1i2Ds=;
        b=hLSp/Bm8a/oj7WICYqUDBpTCvaH2f2IRRC/AX+k2MlY6idxMjSznM7wlNtkhJFX0aq6Wfg
        GoMbL1uPn94yi6lByUIUH2xpQIk6jM09dVjlq+15H5itRGD/3ZSOvZ4i5AjqkVUfdu6UE5
        wmenXLOBXCWS/wyKTcoiDkRBa89vYGg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-209-0zj6lCzwPTWIF3zYuD78eA-1; Thu, 30 Apr 2020 11:25:08 -0400
X-MC-Unique: 0zj6lCzwPTWIF3zYuD78eA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 14CD0872FE0;
        Thu, 30 Apr 2020 15:25:07 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-113-172.ams2.redhat.com [10.36.113.172])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5D0885EDE3;
        Thu, 30 Apr 2020 15:25:03 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        linux-s390@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>
Subject: [kvm-unit-tests PULL 14/17] s390x: smp: Remove unneeded cpu loops
Date:   Thu, 30 Apr 2020 17:24:27 +0200
Message-Id: <20200430152430.40349-15-david@redhat.com>
In-Reply-To: <20200430152430.40349-1-david@redhat.com>
References: <20200430152430.40349-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

Now that we have a loop which is executed after we return from the
main function of a secondary cpu, we can remove the surplus loops.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Message-Id: <20200429143518.1360468-7-frankja@linux.ibm.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 s390x/smp.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/s390x/smp.c b/s390x/smp.c
index 447b998..f2319c4 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -35,15 +35,9 @@ static void set_flag(int val)
 	mb();
 }
=20
-static void cpu_loop(void)
-{
-	for (;;) {}
-}
-
 static void test_func(void)
 {
 	set_flag(1);
-	cpu_loop();
 }
=20
 static void test_start(void)
@@ -306,7 +300,7 @@ int main(void)
=20
 	/* Setting up the cpu to give it a stack and lowcore */
 	psw.mask =3D extract_psw_mask();
-	psw.addr =3D (unsigned long)cpu_loop;
+	psw.addr =3D (unsigned long)test_func;
 	smp_cpu_setup(1, psw);
 	smp_cpu_stop(1);
=20
--=20
2.25.3

