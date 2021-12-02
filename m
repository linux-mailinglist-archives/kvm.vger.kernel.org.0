Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1FDD4663C4
	for <lists+kvm@lfdr.de>; Thu,  2 Dec 2021 13:36:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347215AbhLBMjd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Dec 2021 07:39:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45173 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347120AbhLBMjc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Dec 2021 07:39:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638448569;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FjxO/vF/rRVFzKM6UkIt9wKmjaTlJtDIBD28uKBRo4E=;
        b=Y8zUGLWn3+DY84WK07javlSc8E+6GsasA98sYF2DfSbdJp0xxFJyb2sDBThfoXGQwEYKGO
        CuJbF/HDKA+IXbECP+4E1PIaamgqCDtCC1hH99gLropoKYOxWTGLQH2CrdNTkUIfswwm66
        Ved1v3TIsjRFqOCQbJRDqRHXGvLWOtc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-54-aOYRNsdCOSK5vz79amfzkA-1; Thu, 02 Dec 2021 07:36:06 -0500
X-MC-Unique: aOYRNsdCOSK5vz79amfzkA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0D3A264143;
        Thu,  2 Dec 2021 12:36:05 +0000 (UTC)
Received: from t480s.redhat.com (unknown [10.39.194.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BDE57100AE22;
        Thu,  2 Dec 2021 12:36:02 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sebastian Mitterle <smitterl@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        David Hildenbrand <david@redhat.com>
Subject: [kvm-unit-tests PATCH v2 2/2] s390x: firq: floating interrupt test
Date:   Thu,  2 Dec 2021 13:35:53 +0100
Message-Id: <20211202123553.96412-3-david@redhat.com>
In-Reply-To: <20211202123553.96412-1-david@redhat.com>
References: <20211202123553.96412-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We had a KVM BUG fixed by kernel commit a3e03bc1368c ("KVM: s390: index
kvm->arch.idle_mask by vcpu_idx"), whereby a floating interrupt might get
stuck forever because a CPU in the wait state would not get woken up.

The issue can be triggered when CPUs are created in a nonlinear fashion,
such that the CPU address ("core-id") and the KVM cpu id don't match.

So let's start with a floating interrupt test that will trigger a
floating interrupt (via SCLP) to be delivered to a CPU in the wait state.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 lib/s390x/sclp.c    |  11 ++--
 lib/s390x/sclp.h    |   1 +
 s390x/Makefile      |   1 +
 s390x/firq.c        | 122 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |  10 ++++
 5 files changed, 142 insertions(+), 3 deletions(-)
 create mode 100644 s390x/firq.c

diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
index 0272249..33985eb 100644
--- a/lib/s390x/sclp.c
+++ b/lib/s390x/sclp.c
@@ -60,9 +60,7 @@ void sclp_setup_int(void)
 void sclp_handle_ext(void)
 {
 	ctl_clear_bit(0, CTL0_SERVICE_SIGNAL);
-	spin_lock(&sclp_lock);
-	sclp_busy = false;
-	spin_unlock(&sclp_lock);
+	sclp_clear_busy();
 }
 
 void sclp_wait_busy(void)
@@ -89,6 +87,13 @@ void sclp_mark_busy(void)
 	}
 }
 
+void sclp_clear_busy(void)
+{
+	spin_lock(&sclp_lock);
+	sclp_busy = false;
+	spin_unlock(&sclp_lock);
+}
+
 static void sclp_read_scp_info(ReadInfo *ri, int length)
 {
 	unsigned int commands[] = { SCLP_CMDW_READ_SCP_INFO_FORCED,
diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
index 61e9cf5..fead007 100644
--- a/lib/s390x/sclp.h
+++ b/lib/s390x/sclp.h
@@ -318,6 +318,7 @@ void sclp_setup_int(void);
 void sclp_handle_ext(void);
 void sclp_wait_busy(void);
 void sclp_mark_busy(void);
+void sclp_clear_busy(void);
 void sclp_console_setup(void);
 void sclp_print(const char *str);
 void sclp_read_info(void);
diff --git a/s390x/Makefile b/s390x/Makefile
index f95f2e6..1e567c1 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -25,6 +25,7 @@ tests += $(TEST_DIR)/uv-host.elf
 tests += $(TEST_DIR)/edat.elf
 tests += $(TEST_DIR)/mvpg-sie.elf
 tests += $(TEST_DIR)/spec_ex-sie.elf
+tests += $(TEST_DIR)/firq.elf
 
 tests_binary = $(patsubst %.elf,%.bin,$(tests))
 ifneq ($(HOST_KEY_DOCUMENT),)
diff --git a/s390x/firq.c b/s390x/firq.c
new file mode 100644
index 0000000..1f87718
--- /dev/null
+++ b/s390x/firq.c
@@ -0,0 +1,122 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Floating interrupt tests.
+ *
+ * Copyright 2021 Red Hat Inc
+ *
+ * Authors:
+ *    David Hildenbrand <david@redhat.com>
+ */
+#include <libcflat.h>
+#include <asm/asm-offsets.h>
+#include <asm/interrupt.h>
+#include <asm/page.h>
+#include <asm-generic/barrier.h>
+
+#include <sclp.h>
+#include <smp.h>
+#include <alloc_page.h>
+
+static void wait_for_sclp_int(void)
+{
+	/* Enable SCLP interrupts on this CPU only. */
+	ctl_set_bit(0, CTL0_SERVICE_SIGNAL);
+
+	/* Enable external interrupts and go to the wait state. */
+	wait_for_interrupt(PSW_MASK_EXT);
+}
+
+/*
+ * Some KVM versions might mix CPUs when looking for a floating IRQ target,
+ * accidentially detecting a stopped CPU as waiting and resulting in the actually
+ * waiting CPU not getting woken up for the interrupt.
+ */
+static void test_wait_state_delivery(void)
+{
+	struct psw psw;
+	SCCBHeader *h;
+	int ret;
+
+	report_prefix_push("wait state delivery");
+
+	if (smp_query_num_cpus() < 3) {
+		report_skip("need at least 3 CPUs for this test");
+		goto out;
+	}
+
+	if (stap()) {
+		report_skip("need to start on CPU #0");
+		goto out;
+	}
+
+	/*
+	 * We want CPU #2 to be stopped. This should be the case at this
+	 * point, however, we want to sense if it even exists as well.
+	 */
+	ret = smp_cpu_stop(2);
+	if (ret) {
+		report_skip("CPU #2 not found");
+		goto out;
+	}
+
+	/*
+	 * We're going to perform an SCLP service call but expect
+	 * the interrupt on CPU #1 while it is in the wait state.
+	 */
+	sclp_mark_busy();
+
+	/* Start CPU #1 and let it wait for the interrupt. */
+	psw.mask = extract_psw_mask();
+	psw.addr = (unsigned long)wait_for_sclp_int;
+	ret = smp_cpu_setup(1, psw);
+	if (ret) {
+		sclp_clear_busy();
+		report_skip("cpu #1 not found");
+		goto out;
+	}
+
+	/*
+	 * We'd have to jump trough some hoops to sense e.g., via SIGP
+	 * CONDITIONAL EMERGENCY SIGNAL if CPU #1 is already in the
+	 * wait state.
+	 *
+	 * Although not completely reliable, use SIGP SENSE RUNNING STATUS
+	 * until not reported as running -- after all, our SCLP processing
+	 * will take some time as well and smp_cpu_setup() returns when we're
+	 * either already in wait_for_sclp_int() or just about to execute it.
+	 */
+	while(smp_sense_running_status(1));
+
+	h = alloc_page();
+	h->length = 4096;
+	ret = servc(SCLP_CMDW_READ_CPU_INFO, __pa(h));
+	if (ret) {
+		sclp_clear_busy();
+		report_fail("SCLP_CMDW_READ_CPU_INFO failed");
+		goto out_destroy;
+	}
+
+	/*
+	 * Wait until the interrupt gets delivered on CPU #1, marking the
+	 * SCLP requests as done.
+	 */
+	sclp_wait_busy();
+
+	report(true, "sclp interrupt delivered");
+
+out_destroy:
+	free_page(h);
+	smp_cpu_destroy(1);
+out:
+	report_prefix_pop();
+}
+
+int main(void)
+{
+	report_prefix_push("firq");
+
+	test_wait_state_delivery();
+
+	report_prefix_pop();
+	return report_summary();
+}
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index 3b454b7..054560c 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -112,3 +112,13 @@ file = mvpg-sie.elf
 
 [spec_ex-sie]
 file = spec_ex-sie.elf
+
+[firq-linear-cpu-ids]
+file = firq.elf
+timeout = 20
+extra_params = -smp 1,maxcpus=3 -cpu qemu -device qemu-s390x-cpu,core-id=1 -device qemu-s390x-cpu,core-id=2
+
+[firq-nonlinear-cpu-ids]
+file = firq.elf
+timeout = 20
+extra_params = -smp 1,maxcpus=3 -cpu qemu -device qemu-s390x-cpu,core-id=2 -device qemu-s390x-cpu,core-id=1
-- 
2.31.1

