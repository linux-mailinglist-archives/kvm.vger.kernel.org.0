Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED6FB15164B
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 08:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727236AbgBDHNz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 02:13:55 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21696 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727199AbgBDHNy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Feb 2020 02:13:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580800433;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=ZzDxOK+pIqxVlN9Uam+pyOBD/aAlOx/kYWT71p0Utnc=;
        b=NGVC/xd5QlSPrH5Azl1MybkoXj70eqOCm5lyafYWiwqmMGBKQ1xBwF2o8ASMWlZFJsq3Rw
        ZXauIg2JrjdzZJgR7p1m1bJBFCk5lmDwjEnJUkZ+058pt5D7hTSqkGIE/eP4Bng40fKP1C
        h6NcRUCzvYIG/GNAXYtPna8rlTJJRQ8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-436-38zMEIR7Om6Dtj8OgCEj7w-1; Tue, 04 Feb 2020 02:13:51 -0500
X-MC-Unique: 38zMEIR7Om6Dtj8OgCEj7w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 71AEAA0CC1;
        Tue,  4 Feb 2020 07:13:50 +0000 (UTC)
Received: from thuth.com (ovpn-116-39.ams2.redhat.com [10.36.116.39])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 434525C1D4;
        Tue,  4 Feb 2020 07:13:49 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     david@redhat.com, Janosch Frank <frankja@linux.ibm.com>
Subject: [kvm-unit-tests PULL 5/9] s390x: smp: Only use smp_cpu_setup once
Date:   Tue,  4 Feb 2020 08:13:31 +0100
Message-Id: <20200204071335.18180-6-thuth@redhat.com>
In-Reply-To: <20200204071335.18180-1-thuth@redhat.com>
References: <20200204071335.18180-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

Let's stop and start instead of using setup to run a function on a
cpu.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Message-Id: <20200201152851.82867-6-frankja@linux.ibm.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 s390x/smp.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/s390x/smp.c b/s390x/smp.c
index 93a9594..fa40753 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -53,7 +53,7 @@ static void test_start(void)
 	psw.addr = (unsigned long)test_func;
 
 	set_flag(0);
-	smp_cpu_setup(1, psw);
+	smp_cpu_start(1, psw);
 	wait_for_flag();
 	report(1, "start");
 }
@@ -109,6 +109,7 @@ static void test_store_status(void)
 	report(1, "status written");
 	free_pages(status, PAGE_SIZE * 2);
 	report_prefix_pop();
+	smp_cpu_stop(1);
 
 	report_prefix_pop();
 }
@@ -137,9 +138,8 @@ static void test_ecall(void)
 
 	report_prefix_push("ecall");
 	set_flag(0);
-	smp_cpu_destroy(1);
 
-	smp_cpu_setup(1, psw);
+	smp_cpu_start(1, psw);
 	wait_for_flag();
 	set_flag(0);
 	sigp(1, SIGP_EXTERNAL_CALL, 0, NULL);
@@ -172,9 +172,8 @@ static void test_emcall(void)
 
 	report_prefix_push("emcall");
 	set_flag(0);
-	smp_cpu_destroy(1);
 
-	smp_cpu_setup(1, psw);
+	smp_cpu_start(1, psw);
 	wait_for_flag();
 	set_flag(0);
 	sigp(1, SIGP_EMERGENCY_SIGNAL, 0, NULL);
@@ -192,7 +191,7 @@ static void test_reset_initial(void)
 	psw.addr = (unsigned long)test_func;
 
 	report_prefix_push("reset initial");
-	smp_cpu_setup(1, psw);
+	smp_cpu_start(1, psw);
 
 	sigp_retry(1, SIGP_INITIAL_CPU_RESET, 0, NULL);
 	sigp(1, SIGP_STORE_STATUS_AT_ADDRESS, (uintptr_t)status, NULL);
@@ -223,7 +222,7 @@ static void test_reset(void)
 	psw.addr = (unsigned long)test_func;
 
 	report_prefix_push("cpu reset");
-	smp_cpu_setup(1, psw);
+	smp_cpu_start(1, psw);
 
 	sigp_retry(1, SIGP_CPU_RESET, 0, NULL);
 	report(smp_cpu_stopped(1), "cpu stopped");
@@ -232,6 +231,7 @@ static void test_reset(void)
 
 int main(void)
 {
+	struct psw psw;
 	report_prefix_push("smp");
 
 	if (smp_query_num_cpus() == 1) {
@@ -239,6 +239,12 @@ int main(void)
 		goto done;
 	}
 
+	/* Setting up the cpu to give it a stack and lowcore */
+	psw.mask = extract_psw_mask();
+	psw.addr = (unsigned long)cpu_loop;
+	smp_cpu_setup(1, psw);
+	smp_cpu_stop(1);
+
 	test_start();
 	test_stop();
 	test_stop_store_status();
@@ -247,6 +253,7 @@ int main(void)
 	test_emcall();
 	test_reset();
 	test_reset_initial();
+	smp_cpu_destroy(1);
 
 done:
 	report_prefix_pop();
-- 
2.18.1

