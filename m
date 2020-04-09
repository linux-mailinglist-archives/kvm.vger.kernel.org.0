Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD551A34EC
	for <lists+kvm@lfdr.de>; Thu,  9 Apr 2020 15:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbgDINdA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Apr 2020 09:33:00 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:27765 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726679AbgDINc7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Apr 2020 09:32:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586439178;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TOc6GFFTPKIpzxVPcx4sO1avNIBcz9F7mkm1phzQaq4=;
        b=bJVdR+yBuOr+0865ceJVgz/wsEofM2DNwuELVQMqHxe6yyJpio1lT9vLyh9+9kMRgG0YSl
        3vNEJYg8h+QXDqzTR0BCx/cJSQ1sWN+cdgqKYTYKwBuQkVm5JnraAjMU7sXhD4uCFXHrnR
        Dm3AemFUIVnwHkhAhPo88k20osAHHEA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-493-G2lCDIYlNomArhFBra1VhA-1; Thu, 09 Apr 2020 09:32:51 -0400
X-MC-Unique: G2lCDIYlNomArhFBra1VhA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 346AA107ACCC
        for <kvm@vger.kernel.org>; Thu,  9 Apr 2020 13:32:50 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-113-69.rdu2.redhat.com [10.10.113.69])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B332710027AC;
        Thu,  9 Apr 2020 13:32:49 +0000 (UTC)
From:   Cathy Avery <cavery@redhat.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: [PATCH kvm-unit-tests 2/2] svm: Add test cases around NMI injection with HLT
Date:   Thu,  9 Apr 2020 09:32:47 -0400
Message-Id: <20200409133247.16653-3-cavery@redhat.com>
In-Reply-To: <20200409133247.16653-1-cavery@redhat.com>
References: <20200409133247.16653-1-cavery@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This test checks for NMI delivery to L2 and
intercepted NMI (VMEXIT_NMI) delivery to L1
during an active HLT.

Signed-off-by: Cathy Avery <cavery@redhat.com>
---
 x86/svm_tests.c | 103 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 103 insertions(+)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index d1dbdef..7d7c546 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -9,6 +9,7 @@
 #include "alloc_page.h"
 #include "isr.h"
 #include "apic.h"
+#include "delay.h"
=20
 #define SVM_EXIT_MAX_DR_INTERCEPT 0x3f
=20
@@ -1421,6 +1422,105 @@ static bool nmi_check(struct svm_test *test)
     return get_test_stage(test) =3D=3D 3;
 }
=20
+#define NMI_DELAY 100000000ULL
+
+static void nmi_message_thread(void *_test)
+{
+    struct svm_test *test =3D _test;
+
+    while (get_test_stage(test) !=3D 1)
+        pause();
+
+    delay(NMI_DELAY);
+
+    apic_icr_write(APIC_DEST_PHYSICAL | APIC_DM_NMI | APIC_INT_ASSERT, i=
d_map[0]);
+
+    while (get_test_stage(test) !=3D 2)
+        pause();
+
+    delay(NMI_DELAY);
+
+    apic_icr_write(APIC_DEST_PHYSICAL | APIC_DM_NMI | APIC_INT_ASSERT, i=
d_map[0]);
+}
+
+static void nmi_hlt_test(struct svm_test *test)
+{
+    long long start;
+
+    on_cpu_async(1, nmi_message_thread, test);
+
+    start =3D rdtsc();
+
+    set_test_stage(test, 1);
+
+    asm volatile ("hlt");
+
+    report((rdtsc() - start > NMI_DELAY) && nmi_fired,
+          "direct NMI + hlt");
+
+    if (!nmi_fired)
+        set_test_stage(test, -1);
+
+    nmi_fired =3D false;
+
+    vmmcall();
+
+    start =3D rdtsc();
+
+    set_test_stage(test, 2);
+
+    asm volatile ("hlt");
+
+    report((rdtsc() - start > NMI_DELAY) && nmi_fired,
+           "intercepted NMI + hlt");
+
+    if (!nmi_fired) {
+        report(nmi_fired, "intercepted pending NMI not dispatched");
+        set_test_stage(test, -1);
+    }
+
+    set_test_stage(test, 3);
+}
+
+static bool nmi_hlt_finished(struct svm_test *test)
+{
+    switch (get_test_stage(test)) {
+    case 1:
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
+    case 2:
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
+    case 3:
+        break;
+
+    default:
+        return true;
+    }
+
+    return get_test_stage(test) =3D=3D 3;
+}
+
+static bool nmi_hlt_check(struct svm_test *test)
+{
+    return get_test_stage(test) =3D=3D 3;
+}
+
 #define TEST(name) { #name, .v2 =3D name }
=20
 /*
@@ -1530,6 +1630,9 @@ struct svm_test svm_tests[] =3D {
     { "nmi", default_supported, nmi_prepare,
       default_prepare_gif_clear, nmi_test,
       nmi_finished, nmi_check },
+    { "nmi_hlt", smp_supported, nmi_prepare,
+      default_prepare_gif_clear, nmi_hlt_test,
+      nmi_hlt_finished, nmi_hlt_check },
     TEST(svm_guest_state_test),
     { NULL, NULL, NULL, NULL, NULL, NULL, NULL }
 };
--=20
2.20.1

