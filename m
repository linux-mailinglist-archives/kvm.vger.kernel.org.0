Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8FDF00E1
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 16:12:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389015AbfKEPMh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 10:12:37 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28347 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727889AbfKEPMh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Nov 2019 10:12:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572966756;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=OlkoVdflSMC+hZrDHTdU7MNDmd7YVwliCib2kuv9TNg=;
        b=ZZOis8xCVhpqZGrP7W5WooBxB3w5CLlvIUtpBBINt2d++aNIYQWwrEvcCqvAnngFH1Tgk0
        /wiqH/jFal+2aPuJdS+UfPqZTFS2LCZLwcHD13GSHYzN4RoGIPDZ+7yUWFFM7nslrrOfl9
        PYrr7ennUwjLPyw3/jZ+lReazuYzaHg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-13-_6cQfoz1MrCDdL_Xh9BPSw-1; Tue, 05 Nov 2019 10:12:35 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4C3BC1005500
        for <kvm@vger.kernel.org>; Tue,  5 Nov 2019 15:12:34 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-120-170.rdu2.redhat.com [10.10.120.170])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CA7975C3F8;
        Tue,  5 Nov 2019 15:12:33 +0000 (UTC)
From:   Cathy Avery <cavery@redhat.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: [PATCH kvm-unit-tests] svm: Verify a pending interrupt queued before entering the guest is not lost
Date:   Tue,  5 Nov 2019 10:12:34 -0500
Message-Id: <20191105151234.28160-1-cavery@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: _6cQfoz1MrCDdL_Xh9BPSw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch is based on Liran Aloni <liran.alon@oracle.com>
commit fd056f5b89ac for vmx.

The test configures VMCB to intercept external-interrupts and then
queues an interrupt by disabling interrupts and issue a self-IPI.
At this point, we enter guest and we expect CPU to immediately exit
guest on external-interrupt. To complete the test, we then re-enable
interrupts, verify interrupt is dispatched and re-enter guest to verify
it completes execution.

Signed-off-by: Cathy Avery <cavery@redhat.com>
---
 x86/svm.c | 93 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 93 insertions(+)

diff --git a/x86/svm.c b/x86/svm.c
index 4ddfaa4..6d2ab98 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -7,6 +7,8 @@
 #include "smp.h"
 #include "types.h"
 #include "alloc_page.h"
+#include "isr.h"
+#include "apic.h"
=20
 #define SVM_EXIT_MAX_DR_INTERCEPT 0x3f
=20
@@ -774,6 +776,13 @@ static int get_test_stage(struct test *test)
     return test->scratch;
 }
=20
+static void set_test_stage(struct test *test, int s)
+{
+    barrier();
+    test->scratch =3D s;
+    barrier();
+}
+
 static void inc_test_stage(struct test *test)
 {
     barrier();
@@ -1292,6 +1301,88 @@ static bool lat_svm_insn_check(struct test *test)
             latclgi_min, clgi_sum / LATENCY_RUNS);
     return true;
 }
+
+bool pending_event_ipi_fired;
+bool pending_event_guest_run;
+
+static void pending_event_ipi_isr(isr_regs_t *regs)
+{
+    pending_event_ipi_fired =3D true;
+    eoi();
+}
+
+static void pending_event_prepare(struct test *test)
+{
+    int ipi_vector =3D 0xf1;
+
+    default_prepare(test);
+
+    pending_event_ipi_fired =3D false;
+
+    handle_irq(ipi_vector, pending_event_ipi_isr);
+
+    pending_event_guest_run =3D false;
+
+    test->vmcb->control.intercept |=3D (1ULL << INTERCEPT_INTR);
+    test->vmcb->control.int_ctl |=3D V_INTR_MASKING_MASK;
+
+    apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL |
+                  APIC_DM_FIXED | ipi_vector, 0);
+
+    set_test_stage(test, 0);
+}
+
+static void pending_event_test(struct test *test)
+{
+    pending_event_guest_run =3D true;
+}
+
+static bool pending_event_finished(struct test *test)
+{
+    switch (get_test_stage(test)) {
+    case 0:
+        if (test->vmcb->control.exit_code !=3D SVM_EXIT_INTR) {
+            report("VMEXIT not due to pending interrupt. Exit reason 0x%x"=
,
+            false, test->vmcb->control.exit_code);
+            return true;
+        }
+
+        test->vmcb->control.intercept &=3D ~(1ULL << INTERCEPT_INTR);
+        test->vmcb->control.int_ctl &=3D ~V_INTR_MASKING_MASK;
+
+        if (pending_event_guest_run) {
+            report("Guest ran before host received IPI\n", false);
+            return true;
+        }
+
+        irq_enable();
+        asm volatile ("nop");
+        irq_disable();
+
+        if (!pending_event_ipi_fired) {
+            report("Pending interrupt not dispatched after IRQ enabled\n",=
 false);
+            return true;
+        }
+        break;
+
+    case 1:
+        if (!pending_event_guest_run) {
+            report("Guest did not resume when no interrupt\n", false);
+            return true;
+        }
+        break;
+    }
+
+    inc_test_stage(test);
+
+    return get_test_stage(test) =3D=3D 2;
+}
+
+static bool pending_event_check(struct test *test)
+{
+    return get_test_stage(test) =3D=3D 2;
+}
+
 static struct test tests[] =3D {
     { "null", default_supported, default_prepare, null_test,
       default_finished, null_check },
@@ -1342,6 +1433,8 @@ static struct test tests[] =3D {
       latency_finished, latency_check },
     { "latency_svm_insn", default_supported, lat_svm_insn_prepare, null_te=
st,
       lat_svm_insn_finished, lat_svm_insn_check },
+    { "pending_event", default_supported, pending_event_prepare,
+      pending_event_test, pending_event_finished, pending_event_check },
 };
=20
 int main(int ac, char **av)
--=20
2.20.1

