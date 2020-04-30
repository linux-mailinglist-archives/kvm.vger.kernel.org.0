Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71B571C002F
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 17:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727807AbgD3PZV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 11:25:21 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:59491 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727801AbgD3PZU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Apr 2020 11:25:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588260319;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qfQ2wE+gD/G6WCu1cAhJmw6ubfumU3Ld2YMoCPO3gm0=;
        b=BRkeEPfIUlGEmlTLodkgtoy44+KCiYPXdS/tVgGSIfPwLbh2ZbutsM3KaN+PBR6BELXmUb
        XYi5MV+keySnwEUNFUgGDZaxwj0H0U9Y3/0qwH6THgA2gSIklhH/bxDvzx0rcRJxSOyPOZ
        fXBCjh2A1NwVAswNfcLIHgH3rH/5hJA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-203-qD6li75OP_G_LDY962uk7g-1; Thu, 30 Apr 2020 11:25:17 -0400
X-MC-Unique: qD6li75OP_G_LDY962uk7g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CFE32108BD18;
        Thu, 30 Apr 2020 15:25:15 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-113-172.ams2.redhat.com [10.36.113.172])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 93C885EDE3;
        Thu, 30 Apr 2020 15:25:11 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        linux-s390@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>
Subject: [kvm-unit-tests PULL 16/17] s390x: smp: Add restart when running test
Date:   Thu, 30 Apr 2020 17:24:29 +0200
Message-Id: <20200430152430.40349-17-david@redhat.com>
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

Let's make sure we can restart a cpu that is already running.
Restarting it if it is stopped is implicitely tested by the the other
restart calls in the smp test.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Message-Id: <20200429143518.1360468-10-frankja@linux.ibm.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 s390x/smp.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/s390x/smp.c b/s390x/smp.c
index f2319c4..ad30e3c 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -52,6 +52,34 @@ static void test_start(void)
 	report(1, "start");
 }
=20
+/*
+ * Does only test restart when the target is running.
+ * The other tests do restarts when stopped multiple times already.
+ */
+static void test_restart(void)
+{
+	struct cpu *cpu =3D smp_cpu_from_addr(1);
+	struct lowcore *lc =3D cpu->lowcore;
+
+	lc->restart_new_psw.mask =3D extract_psw_mask();
+	lc->restart_new_psw.addr =3D (unsigned long)test_func;
+
+	/* Make sure cpu is running */
+	smp_cpu_stop(0);
+	set_flag(0);
+	smp_cpu_restart(1);
+	wait_for_flag();
+
+	/*
+	 * Wait until cpu 1 has set the flag because it executed the
+	 * restart function.
+	 */
+	set_flag(0);
+	smp_cpu_restart(1);
+	wait_for_flag();
+	report(1, "restart while running");
+}
+
 static void test_stop(void)
 {
 	smp_cpu_stop(1);
@@ -305,6 +333,7 @@ int main(void)
 	smp_cpu_stop(1);
=20
 	test_start();
+	test_restart();
 	test_stop();
 	test_stop_store_status();
 	test_store_status();
--=20
2.25.3

