Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32E271C0021
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 17:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbgD3PZC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 11:25:02 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:48512 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726810AbgD3PZB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Apr 2020 11:25:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588260300;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=24P6Uxqd7YNzAWjyBnTTOqp3txQctstT3STnNs9jdmg=;
        b=QoVEgM30kHhYkLqiMe/54oh+kq7V+7Oy7y+hPkBf1oU5zWWfJkRV68SlU7WFuqWGTkYuL8
        AW5dSU8Xd4nfpNrEsR+PKiQvO8tNCAE/sDk5qhvODEEh4FcJZBh8WZRaly00bNtAKkT08U
        nRR0qkk7eZIxQNVfXKFkkIfr07ORN8M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-123-OudTxjJRMYmkRWJu3ernvQ-1; Thu, 30 Apr 2020 11:24:56 -0400
X-MC-Unique: OudTxjJRMYmkRWJu3ernvQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6B5D1107ACF4;
        Thu, 30 Apr 2020 15:24:55 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-113-172.ams2.redhat.com [10.36.113.172])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B3C915EDE3;
        Thu, 30 Apr 2020 15:24:53 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        linux-s390@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        David Hildenbrand <david@redhat.com>
Subject: [kvm-unit-tests PULL 09/17] s390x: smp: Test all CRs on initial reset
Date:   Thu, 30 Apr 2020 17:24:22 +0200
Message-Id: <20200430152430.40349-10-david@redhat.com>
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

All CRs are set to 0 and CRs 0 and 14 are set to pre-defined values,
so we also need to test 1-13 and 15 for 0.

And while we're at it, let's also set some values to cr 1, 7 and 13, so
we can actually be sure that they will be zeroed.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Message-Id: <20200424093356.11931-1-frankja@linux.ibm.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 s390x/smp.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/s390x/smp.c b/s390x/smp.c
index 1641979..08fa770 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -195,16 +195,28 @@ static void test_sense_running(void)
 	report_prefix_pop();
 }
=20
+/* Used to dirty registers of cpu #1 before it is reset */
+static void test_func_initial(void)
+{
+	lctlg(1, 0x42000UL);
+	lctlg(7, 0x43000UL);
+	lctlg(13, 0x44000UL);
+	set_flag(1);
+}
+
 static void test_reset_initial(void)
 {
 	struct cpu_status *status =3D alloc_pages(0);
 	struct psw psw;
+	int i;
=20
 	psw.mask =3D extract_psw_mask();
-	psw.addr =3D (unsigned long)test_func;
+	psw.addr =3D (unsigned long)test_func_initial;
=20
 	report_prefix_push("reset initial");
+	set_flag(0);
 	smp_cpu_start(1, psw);
+	wait_for_flag();
=20
 	sigp_retry(1, SIGP_INITIAL_CPU_RESET, 0, NULL);
 	sigp(1, SIGP_STORE_STATUS_AT_ADDRESS, (uintptr_t)status, NULL);
@@ -215,6 +227,10 @@ static void test_reset_initial(void)
 	report(!status->fpc, "fpc");
 	report(!status->cputm, "cpu timer");
 	report(!status->todpr, "todpr");
+	for (i =3D 1; i <=3D 13; i++) {
+		report(status->crs[i] =3D=3D 0, "cr%d =3D=3D 0", i);
+	}
+	report(status->crs[15] =3D=3D 0, "cr15 =3D=3D 0");
 	report_prefix_pop();
=20
 	report_prefix_push("initialized");
--=20
2.25.3

