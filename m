Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83D2C1C0028
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 17:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbgD3PZK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 11:25:10 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:59924 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727112AbgD3PZJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Apr 2020 11:25:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588260308;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QGdZkNa1iuJeTe+FUSCAEfNCQKynn56veEV55lQF5+w=;
        b=D6b8Jk7Im+D6j1GoTAcECYVsBRNszAaHECisTajACA7pDtMFkqx6ORqk/wYeqP2uJBVd8b
        h70D2Wqt1qkioQDAHkoZI3StAv8m7vryNADUEQ13KzWjB9KlCCemArmuz09P2F4VC0eVjt
        vpAcupmqKolc9cz40FP9dX3GHXJhBuQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-181-htrIRbJqOHCQHZmt2L9qhQ-1; Thu, 30 Apr 2020 11:25:05 -0400
X-MC-Unique: htrIRbJqOHCQHZmt2L9qhQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 39E758005B7;
        Thu, 30 Apr 2020 15:25:01 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-113-172.ams2.redhat.com [10.36.113.172])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AE40A5EDE3;
        Thu, 30 Apr 2020 15:24:59 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        linux-s390@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>
Subject: [kvm-unit-tests PULL 12/17] s390x: smp: Test local interrupts after cpu reset
Date:   Thu, 30 Apr 2020 17:24:25 +0200
Message-Id: <20200430152430.40349-13-david@redhat.com>
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

Local interrupts (external and emergency call) should be cleared after
any cpu reset.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Message-Id: <20200429143518.1360468-5-frankja@linux.ibm.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 s390x/smp.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/s390x/smp.c b/s390x/smp.c
index 57eacb2..447b998 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -258,6 +258,19 @@ static void test_reset_initial(void)
 	report_prefix_pop();
 }
=20
+static void test_local_ints(void)
+{
+	unsigned long mask;
+
+	/* Open masks for ecall and emcall */
+	ctl_set_bit(0, 13);
+	ctl_set_bit(0, 14);
+	mask =3D extract_psw_mask();
+	mask |=3D PSW_MASK_EXT;
+	load_psw_mask(mask);
+	set_flag(1);
+}
+
 static void test_reset(void)
 {
 	struct psw psw;
@@ -266,10 +279,18 @@ static void test_reset(void)
 	psw.addr =3D (unsigned long)test_func;
=20
 	report_prefix_push("cpu reset");
+	sigp(1, SIGP_EMERGENCY_SIGNAL, 0, NULL);
+	sigp(1, SIGP_EXTERNAL_CALL, 0, NULL);
 	smp_cpu_start(1, psw);
=20
 	sigp_retry(1, SIGP_CPU_RESET, 0, NULL);
 	report(smp_cpu_stopped(1), "cpu stopped");
+
+	set_flag(0);
+	psw.addr =3D (unsigned long)test_local_ints;
+	smp_cpu_start(1, psw);
+	wait_for_flag();
+	report(true, "local interrupts cleared");
 	report_prefix_pop();
 }
=20
--=20
2.25.3

