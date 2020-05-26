Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0DB61A371D
	for <lists+kvm@lfdr.de>; Thu,  9 Apr 2020 17:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728224AbgDIP24 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Apr 2020 11:28:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:42115 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728191AbgDIP24 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Apr 2020 11:28:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586446135;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=FVUPLOZX5xr5YRaXLAPd3Mgvd0RbL/KcfmZ9/KPlJrk=;
        b=NgToxMWoDxquJtCt9ZqGYLIL++6Wf6zj/mN5RfELLUDfhfsQmzD/jEoTXkoQta+Tq20Bvv
        kUyqWKqAYdp0eF9AZ6TuipwUOTp4pTYnZRl+qJ59UXic0gA70GYm+ReDjYZsmoPPFI9W8P
        nZeuqlZgmOCP1sIljXtzeymeC2MRNPM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-46-PwF-f56YN3S6QN6_21pWOg-1; Thu, 09 Apr 2020 11:28:50 -0400
X-MC-Unique: PwF-f56YN3S6QN6_21pWOg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 46B93107ACC4
        for <kvm@vger.kernel.org>; Thu,  9 Apr 2020 15:28:49 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-113-69.rdu2.redhat.com [10.10.113.69])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CED735D9CA;
        Thu,  9 Apr 2020 15:28:48 +0000 (UTC)
From:   Cathy Avery <cavery@redhat.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: [PATCH kvm-unit-tests v2 1/2] svm: Add test cases around NMI injection
Date:   Thu,  9 Apr 2020 11:28:48 -0400
Message-Id: <20200409152848.17762-1-cavery@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This test checks for NMI delivery to L2 and
intercepted NMI (VMEXIT_NMI) delivery to L1.

Signed-off-by: Cathy Avery <cavery@redhat.com>
---
v2: Remove redundant NMI_VECTOR
---
 x86/svm_tests.c | 82 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 82 insertions(+)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 16b9dfd..b6c0106 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -1340,6 +1340,85 @@ static bool interrupt_check(struct svm_test *test)
     return get_test_stage(test) =3D=3D 5;
 }
=20
+static volatile bool nmi_fired;
+
+static void nmi_handler(isr_regs_t *regs)
+{
+    nmi_fired =3D true;
+    apic_write(APIC_EOI, 0);
+}
+
+static void nmi_prepare(struct svm_test *test)
+{
+    default_prepare(test);
+    nmi_fired =3D false;
+    handle_irq(NMI_VECTOR, nmi_handler);
+    set_test_stage(test, 0);
+}
+
+static void nmi_test(struct svm_test *test)
+{
+    apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL | APIC_DM_NMI | A=
PIC_INT_ASSERT, 0);
+
+    report(nmi_fired, "direct NMI while running guest");
+
+    if (!nmi_fired)
+        set_test_stage(test, -1);
+
+    vmmcall();
+
+    nmi_fired =3D false;
+
+    apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL | APIC_DM_NMI | A=
PIC_INT_ASSERT, 0);
+
+    if (!nmi_fired) {
+        report(nmi_fired, "intercepted pending NMI not dispatched");
+        set_test_stage(test, -1);
+    }
+
+}
+
+static bool nmi_finished(struct svm_test *test)
+{
+    switch (get_test_stage(test)) {
+    case 0:
+        if (vmcb->control.exit_code !=3D SVM_EXIT_VMMCALL) {
+            report(false, "VMEXIT not due to vmmcall. Exit reason 0x%x",
+                   vmcb->control.exit_code);
+            return true;
+        }
+        vmcb->save.rip +=3D 3;
+
+        vmcb->control.intercept |=3D (1ULL << INTERCEPT_NMI);
+        break;
+
+    case 1:
+        if (vmcb->control.exit_code !=3D SVM_EXIT_NMI) {
+            report(false, "VMEXIT not due to NMI intercept. Exit reason =
0x%x",
+                   vmcb->control.exit_code);
+            return true;
+        }
+
+        report(true, "NMI intercept while running guest");
+        break;
+
+    case 2:
+        break;
+
+    default:
+        return true;
+    }
+
+    inc_test_stage(test);
+
+    return get_test_stage(test) =3D=3D 3;
+}
+
+static bool nmi_check(struct svm_test *test)
+{
+    return get_test_stage(test) =3D=3D 3;
+}
+
 #define TEST(name) { #name, .v2 =3D name }
=20
 /*
@@ -1446,6 +1525,9 @@ struct svm_test svm_tests[] =3D {
     { "interrupt", default_supported, interrupt_prepare,
       default_prepare_gif_clear, interrupt_test,
       interrupt_finished, interrupt_check },
+    { "nmi", default_supported, nmi_prepare,
+      default_prepare_gif_clear, nmi_test,
+      nmi_finished, nmi_check },
     TEST(svm_guest_state_test),
     { NULL, NULL, NULL, NULL, NULL, NULL, NULL }
 };
--=20
2.20.1

