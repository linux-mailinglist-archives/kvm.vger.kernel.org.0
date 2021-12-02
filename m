Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEF7D46610B
	for <lists+kvm@lfdr.de>; Thu,  2 Dec 2021 10:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240993AbhLBKDE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Dec 2021 05:03:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:57818 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231446AbhLBKC6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Dec 2021 05:02:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638439176;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6yN5hveEfujHo9to4/YhvNOcbUorOwiHB//UhyWng2g=;
        b=FnfQrOCww7u8GILmwvvr2RtKqS67PK1fleldhulwf6WGaYLbA1M00HWGiZzrdi1cU7suV7
        oznYiBdmuChu0BFUa4312yCtQRuiZUv2P0QGVJ/dutvu6O+l3InREAx2smCVLNUOZAqVVS
        mFvgm6HcTr+UVLfVWqRNcB2aQOrIfHE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-559-_nfj5OrnMyOxMG1LV9oFXg-1; Thu, 02 Dec 2021 04:59:33 -0500
X-MC-Unique: _nfj5OrnMyOxMG1LV9oFXg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C10CF81EE61;
        Thu,  2 Dec 2021 09:59:31 +0000 (UTC)
Received: from t480s.redhat.com (unknown [10.39.194.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8607C5D9CA;
        Thu,  2 Dec 2021 09:59:05 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sebastian Mitterle <smitterl@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        David Hildenbrand <david@redhat.com>
Subject: [kvm-unit-tests PATCH v1 2/2] s390x: firq: floating interrupt test
Date:   Thu,  2 Dec 2021 10:58:43 +0100
Message-Id: <20211202095843.41162-3-david@redhat.com>
In-Reply-To: <20211202095843.41162-1-david@redhat.com>
References: <20211202095843.41162-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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
 s390x/Makefile      |   1 +
 s390x/firq.c        | 141 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |  10 ++++
 3 files changed, 152 insertions(+)
 create mode 100644 s390x/firq.c

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
index 0000000..3e60681
--- /dev/null
+++ b/s390x/firq.c
@@ -0,0 +1,141 @@
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
+static int testflag = 0;
+
+static void wait_for_flag(void)
+{
+	while (!testflag)
+		mb();
+}
+
+static void set_flag(int val)
+{
+	mb();
+	testflag = val;
+	mb();
+}
+
+static void wait_for_sclp_int(void)
+{
+	/* Enable SCLP interrupts on this CPU only. */
+	ctl_set_bit(0, CTL0_SERVICE_SIGNAL);
+
+	set_flag(1);
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
+	set_flag(0);
+
+	/* Start CPU #1 and let it wait for the interrupt. */
+	psw.mask = extract_psw_mask();
+	psw.addr = (unsigned long)wait_for_sclp_int;
+	ret = smp_cpu_setup(1, psw);
+	if (ret) {
+		report_skip("cpu #1 not found");
+		goto out;
+	}
+
+	/* Wait until the CPU #1 at least enabled SCLP interrupts. */
+	wait_for_flag();
+
+	/*
+	 * We'd have to jump trough some hoops to sense e.g., via SIGP
+	 * CONDITIONAL EMERGENCY SIGNAL if CPU #1 is already in the
+	 * wait state.
+	 *
+	 * Although not completely reliable, use SIGP SENSE RUNNING STATUS
+	 * until not reported as running -- after all, our SCLP processing
+	 * will take some time as well and make races very rare.
+	 */
+	while(smp_sense_running_status(1));
+
+	h = alloc_page();
+	memset(h, 0, sizeof(*h));
+	h->length = 4096;
+	ret = servc(SCLP_CMDW_READ_CPU_INFO, __pa(h));
+	if (ret) {
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
+	report(true, "firq delivered");
+
+out_destroy:
+	smp_cpu_destroy(1);
+	free_page(h);
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

