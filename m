Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC306151650
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 08:14:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727242AbgBDHN4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 02:13:56 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20937 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725834AbgBDHN4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Feb 2020 02:13:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580800435;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=/hdIUNxmNRqt4zaw3xAf/IgcFBF5K2rkiMWYAX1h6Ek=;
        b=jKxB42Nwltds5SsVhraU2CF4Qj6hLgZUUwZZUltwMpH/58pAtgyXPvR8iSe8RFMwvE3VuU
        A6DMy/WFV2p4kUYt441Fs6BZjm9Zorndcg9SQJcvlM2uV1c1nTA4gS74jUv15038y32TT4
        Q8ihP1rimp+F+5p4l/Mv9fy/LNGFBJg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-361-57DPMwZgNa61ONB3uAnfdg-1; Tue, 04 Feb 2020 02:13:53 -0500
X-MC-Unique: 57DPMwZgNa61ONB3uAnfdg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 18D1718B644C;
        Tue,  4 Feb 2020 07:13:52 +0000 (UTC)
Received: from thuth.com (ovpn-116-39.ams2.redhat.com [10.36.116.39])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CF9D85C1D4;
        Tue,  4 Feb 2020 07:13:50 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     david@redhat.com, Janosch Frank <frankja@linux.ibm.com>
Subject: [kvm-unit-tests PULL 6/9] s390x: smp: Rework cpu start and active tracking
Date:   Tue,  4 Feb 2020 08:13:32 +0100
Message-Id: <20200204071335.18180-7-thuth@redhat.com>
In-Reply-To: <20200204071335.18180-1-thuth@redhat.com>
References: <20200204071335.18180-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

The architecture specifies that processing sigp orders may be
asynchronous, and this is indeed the case on some hypervisors, so we
need to wait until the cpu runs before we return from the setup/start
function.

As there was a lot of duplicate code, a common function for cpu
restarts has been introduced.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Message-Id: <20200201152851.82867-7-frankja@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 lib/s390x/smp.c | 56 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 35 insertions(+), 21 deletions(-)

diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
index f57f420..4578003 100644
--- a/lib/s390x/smp.c
+++ b/lib/s390x/smp.c
@@ -104,35 +104,52 @@ int smp_cpu_stop_store_status(uint16_t addr)
 	return rc;
 }
 
+static int smp_cpu_restart_nolock(uint16_t addr, struct psw *psw)
+{
+	int rc;
+	struct cpu *cpu = smp_cpu_from_addr(addr);
+
+	if (!cpu)
+		return -1;
+	if (psw) {
+		cpu->lowcore->restart_new_psw.mask = psw->mask;
+		cpu->lowcore->restart_new_psw.addr = psw->addr;
+	}
+	/*
+	 * Stop the cpu, so we don't have a race between a running cpu
+	 * and the restart in the test that checks if the cpu is
+	 * running after the restart.
+	 */
+	smp_cpu_stop_nolock(addr, false);
+	rc = sigp(addr, SIGP_RESTART, 0, NULL);
+	if (rc)
+		return rc;
+	/*
+	 * The order has been accepted, but the actual restart may not
+	 * have been performed yet, so wait until the cpu is running.
+	 */
+	while (!smp_cpu_running(addr))
+		mb();
+	cpu->active = true;
+	return 0;
+}
+
 int smp_cpu_restart(uint16_t addr)
 {
-	int rc = -1;
-	struct cpu *cpu;
+	int rc;
 
 	spin_lock(&lock);
-	cpu = smp_cpu_from_addr(addr);
-	if (cpu) {
-		rc = sigp(addr, SIGP_RESTART, 0, NULL);
-		cpu->active = true;
-	}
+	rc = smp_cpu_restart_nolock(addr, NULL);
 	spin_unlock(&lock);
 	return rc;
 }
 
 int smp_cpu_start(uint16_t addr, struct psw psw)
 {
-	int rc = -1;
-	struct cpu *cpu;
-	struct lowcore *lc;
+	int rc;
 
 	spin_lock(&lock);
-	cpu = smp_cpu_from_addr(addr);
-	if (cpu) {
-		lc = cpu->lowcore;
-		lc->restart_new_psw.mask = psw.mask;
-		lc->restart_new_psw.addr = psw.addr;
-		rc = sigp(addr, SIGP_RESTART, 0, NULL);
-	}
+	rc = smp_cpu_restart_nolock(addr, &psw);
 	spin_unlock(&lock);
 	return rc;
 }
@@ -192,10 +209,7 @@ int smp_cpu_setup(uint16_t addr, struct psw psw)
 	lc->sw_int_crs[0] = 0x0000000000040000UL;
 
 	/* Start processing */
-	rc = sigp_retry(cpu->addr, SIGP_RESTART, 0, NULL);
-	if (!rc)
-		cpu->active = true;
-
+	smp_cpu_restart_nolock(addr, NULL);
 out:
 	spin_unlock(&lock);
 	return rc;
-- 
2.18.1

