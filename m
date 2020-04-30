Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD7211C001D
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 17:24:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgD3PY4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 11:24:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:57834 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727110AbgD3PY4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Apr 2020 11:24:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588260294;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=06QUopc2pdglVt4rmYY6zhlBwcqBRKBgP4bCflio89M=;
        b=MhUTKqps6mItOSDxTqKl1ro0bTtEHOtE0RAOFplrztEcITa6vBE+6uo4++ywJbpbrHj7Zh
        D6jfTsw25DKOLyq+Y9JW/l7l6J3OGxD914ZmRTToz++ZNQ99nVYprAtpM+ElK0TEt8+Geu
        55GQ0gzi+RUCMkPZxwq3MHr4/dGH0YY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-281-IBIVG9lTM6ORqkpSIBNKjw-1; Thu, 30 Apr 2020 11:24:50 -0400
X-MC-Unique: IBIVG9lTM6ORqkpSIBNKjw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 35C26107ACCA;
        Thu, 30 Apr 2020 15:24:49 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-113-172.ams2.redhat.com [10.36.113.172])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7FB1E5D780;
        Thu, 30 Apr 2020 15:24:47 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        linux-s390@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>
Subject: [kvm-unit-tests PULL 07/17] s390x/smp: add minimal test for sigp sense running status
Date:   Thu, 30 Apr 2020 17:24:20 +0200
Message-Id: <20200430152430.40349-8-david@redhat.com>
In-Reply-To: <20200430152430.40349-1-david@redhat.com>
References: <20200430152430.40349-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Christian Borntraeger <borntraeger@de.ibm.com>

Two minimal tests:
- our own CPU should be running when we check ourselves
- a CPU should at least have some times with a not running
indication. To speed things up we stop CPU1

Also rename smp_cpu_running to smp_sense_running_status.

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Message-Id: <20200402154441.13063-1-borntraeger@de.ibm.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 lib/s390x/smp.c |  2 +-
 lib/s390x/smp.h |  2 +-
 s390x/smp.c     | 14 ++++++++++++++
 3 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
index 203792a..df8dcd9 100644
--- a/lib/s390x/smp.c
+++ b/lib/s390x/smp.c
@@ -58,7 +58,7 @@ bool smp_cpu_stopped(uint16_t addr)
 	return !!(status & (SIGP_STATUS_CHECK_STOP|SIGP_STATUS_STOPPED));
 }
=20
-bool smp_cpu_running(uint16_t addr)
+bool smp_sense_running_status(uint16_t addr)
 {
 	if (sigp(addr, SIGP_SENSE_RUNNING, 0, NULL) !=3D SIGP_CC_STATUS_STORED)
 		return true;
diff --git a/lib/s390x/smp.h b/lib/s390x/smp.h
index ce63a89..d66e39a 100644
--- a/lib/s390x/smp.h
+++ b/lib/s390x/smp.h
@@ -40,7 +40,7 @@ struct cpu_status {
 int smp_query_num_cpus(void);
 struct cpu *smp_cpu_from_addr(uint16_t addr);
 bool smp_cpu_stopped(uint16_t addr);
-bool smp_cpu_running(uint16_t addr);
+bool smp_sense_running_status(uint16_t addr);
 int smp_cpu_restart(uint16_t addr);
 int smp_cpu_start(uint16_t addr, struct psw psw);
 int smp_cpu_stop(uint16_t addr);
diff --git a/s390x/smp.c b/s390x/smp.c
index fa40753..1641979 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -182,6 +182,19 @@ static void test_emcall(void)
 	report_prefix_pop();
 }
=20
+static void test_sense_running(void)
+{
+	report_prefix_push("sense_running");
+	/* we (CPU0) are running */
+	report(smp_sense_running_status(0), "CPU0 sense claims running");
+	/* stop the target CPU (CPU1) to speed up the not running case */
+	smp_cpu_stop(1);
+	/* Make sure to have at least one time with a not running indication */
+	while(smp_sense_running_status(1));
+	report(true, "CPU1 sense claims not running");
+	report_prefix_pop();
+}
+
 static void test_reset_initial(void)
 {
 	struct cpu_status *status =3D alloc_pages(0);
@@ -251,6 +264,7 @@ int main(void)
 	test_store_status();
 	test_ecall();
 	test_emcall();
+	test_sense_running();
 	test_reset();
 	test_reset_initial();
 	smp_cpu_destroy(1);
--=20
2.25.3

