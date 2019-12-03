Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C699710FEB4
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2019 14:24:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbfLCNYd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Dec 2019 08:24:33 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:36785 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726105AbfLCNYd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Dec 2019 08:24:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575379472;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=yUz5V0ICOk8/qnlm76z0FyFQ5SAkIpNDEqdcHIvOkpU=;
        b=Q+L58909qNG2y7HZfgX8EquoFzgXtQvRMCL0IV6nAbsUoMwwWgdKSMzVwt3wA0sca2JJV9
        xFCO0ol2xsfYj3IYkMwWXcOKPoME1zQ32wXtj/BPMshlmT4Lte6rAjAV5wNWfdXvTuntb0
        6YyeHGPoq5YJCdXUYz30VPdOkdtCKec=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-203-shKdd1JhOeWQn_ocK_BOug-1; Tue, 03 Dec 2019 08:24:28 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E768F107ACC4
        for <kvm@vger.kernel.org>; Tue,  3 Dec 2019 13:24:27 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-121-180.rdu2.redhat.com [10.10.121.180])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7B41919C68;
        Tue,  3 Dec 2019 13:24:27 +0000 (UTC)
From:   Cathy Avery <cavery@redhat.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: [PATCH kvm-unit-tests] svm: Verify the effect of V_INTR_MASKING on INTR interrupts
Date:   Tue,  3 Dec 2019 08:24:26 -0500
Message-Id: <20191203132426.21244-1-cavery@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: shKdd1JhOeWQn_ocK_BOug-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The test confirms the influence of the V_INTR_MASKING bit
on RFLAGS.IF. The expectation is while running a guest
with V_INTR_MASKING cleared to zero:

- EFLAGS.IF controls both virtual and physical interrupts.

While running a guest with V_INTR_MASKING set to 1:

- The host EFLAGS.IF at the time of the VMRUN is saved and
  controls physical interrupts while the guest is running.

- The guest value of EFLAGS.IF controls virtual interrupts only.

As discussed previously, this patch also modifies the vmrun
loop ( test_run ) to allow running with HIF=3D0

Signed-off-by: Cathy Avery <cavery@redhat.com>
---
 x86/svm.c | 106 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 104 insertions(+), 2 deletions(-)

diff --git a/x86/svm.c b/x86/svm.c
index 0360d8d..fb5796f 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -44,6 +44,8 @@ u64 runs;
 u8 *io_bitmap;
 u8 io_bitmap_area[16384];
=20
+u64 set_host_if =3D 1;
+
 #define MSR_BITMAP_SIZE 8192
=20
 u8 *msr_bitmap;
@@ -266,21 +268,24 @@ static void test_run(struct test *test, struct vmcb *=
vmcb)
         tsc_start =3D rdtsc();
         asm volatile (
             "clgi \n\t"
+            "cmp $0, set_host_if\n\t"
+            "jz 1f\n\t"
+            "sti \n\t"
+            "1: \n\t"
             "vmload \n\t"
             "mov regs+0x80, %%r15\n\t"  // rflags
             "mov %%r15, 0x170(%0)\n\t"
             "mov regs, %%r15\n\t"       // rax
             "mov %%r15, 0x1f8(%0)\n\t"
             LOAD_GPR_C
-            "sti \n\t"=09=09// only used if V_INTR_MASKING=3D1
             "vmrun \n\t"
-            "cli \n\t"
             SAVE_GPR_C
             "mov 0x170(%0), %%r15\n\t"  // rflags
             "mov %%r15, regs+0x80\n\t"
             "mov 0x1f8(%0), %%r15\n\t"  // rax
             "mov %%r15, regs\n\t"
             "vmsave \n\t"
+            "cli \n\t"
             "stgi"
             : : "a"(vmcb_phys)
             : "rbx", "rcx", "rdx", "rsi",
@@ -307,6 +312,7 @@ static bool default_supported(void)
 static void default_prepare(struct test *test)
 {
     vmcb_ident(test->vmcb);
+    cli();
 }
=20
 static bool default_finished(struct test *test)
@@ -1386,6 +1392,99 @@ static bool pending_event_check(struct test *test)
     return get_test_stage(test) =3D=3D 2;
 }
=20
+static void pending_event_prepare_vmask(struct test *test)
+{
+    default_prepare(test);
+
+    pending_event_ipi_fired =3D false;
+
+    set_host_if =3D 0;
+
+    handle_irq(0xf1, pending_event_ipi_isr);
+
+    apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL |
+              APIC_DM_FIXED | 0xf1, 0);
+
+    set_test_stage(test, 0);
+}
+
+static void pending_event_test_vmask(struct test *test)
+{
+    if (pending_event_ipi_fired =3D=3D true) {
+        set_test_stage(test, -1);
+        report("Interrupt preceeded guest", false);
+        vmmcall();
+    }
+
+    irq_enable();
+    asm volatile ("nop");
+    irq_disable();
+
+    if (pending_event_ipi_fired !=3D true) {
+        set_test_stage(test, -1);
+        report("Interrupt not triggered by guest", false);
+    }
+
+    vmmcall();
+
+    irq_enable();
+    asm volatile ("nop");
+    irq_disable();
+}
+
+static bool pending_event_finished_vmask(struct test *test)
+{
+    if ( test->vmcb->control.exit_code !=3D SVM_EXIT_VMMCALL) {
+        report("VM_EXIT return to host is not EXIT_VMMCALL exit reason 0x%=
x", false,
+                test->vmcb->control.exit_code);
+        return true;
+    }
+
+    switch (get_test_stage(test)) {
+    case 0:
+        test->vmcb->save.rip +=3D 3;
+
+        pending_event_ipi_fired =3D false;
+
+        test->vmcb->control.int_ctl |=3D V_INTR_MASKING_MASK;
+
+        apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL |
+              APIC_DM_FIXED | 0xf1, 0);
+
+        break;
+
+    case 1:
+        if (pending_event_ipi_fired =3D=3D true) {
+            report("Interrupt triggered by guest", false);
+            return true;
+        }
+
+        irq_enable();
+        asm volatile ("nop");
+        irq_disable();
+
+        if (pending_event_ipi_fired !=3D true) {
+            report("Interrupt not triggered by host", false);
+            return true;
+        }
+
+        break;
+
+    default:
+        return true;
+    }
+
+    inc_test_stage(test);
+
+    return get_test_stage(test) =3D=3D 2;
+}
+
+static bool pending_event_check_vmask(struct test *test)
+{
+    set_host_if =3D 1;
+    return get_test_stage(test) =3D=3D 2;
+}
+
 static struct test tests[] =3D {
     { "null", default_supported, default_prepare, null_test,
       default_finished, null_check },
@@ -1438,6 +1537,9 @@ static struct test tests[] =3D {
       lat_svm_insn_finished, lat_svm_insn_check },
     { "pending_event", default_supported, pending_event_prepare,
       pending_event_test, pending_event_finished, pending_event_check },
+    { "pending_event_vmask", default_supported, pending_event_prepare_vmas=
k,
+      pending_event_test_vmask, pending_event_finished_vmask,
+      pending_event_check_vmask },
 };
=20
 int main(int ac, char **av)
--=20
2.20.1

