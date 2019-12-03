Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A36D11022B
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2019 17:25:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbfLCQZh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Dec 2019 11:25:37 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:52027 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726319AbfLCQZh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Dec 2019 11:25:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575390336;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=7gp/NLDCHcPBD7rTXpXJJ7UH2Y3VhuqxCT8Tk+uSXDc=;
        b=bJfW38MX9V+G2cXjA4pJrBQUu/NdjkcVIVg58uNp5jlWqEwXvjU1GFD/i58xudyFQnMhEu
        nNsZBhkbn/1O6k4HsWg0j3ergAuv+KSEAyV3NhaiNwfM2HIW8L5pBF7pmaUntaROZzd30P
        MuQVTtaMYXq+IZlOIltBSErKo2JlOs4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-35-HUL4w6-mOSKNPFPUgCa3sw-1; Tue, 03 Dec 2019 11:25:35 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2E61C18A07C1
        for <kvm@vger.kernel.org>; Tue,  3 Dec 2019 16:25:34 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-121-180.rdu2.redhat.com [10.10.121.180])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B71F1600C8;
        Tue,  3 Dec 2019 16:25:33 +0000 (UTC)
From:   Cathy Avery <cavery@redhat.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: [PATCH kvm-unit-tests v2] svm: Verify the effect of V_INTR_MASKING on INTR interrupts
Date:   Tue,  3 Dec 2019 11:25:32 -0500
Message-Id: <20191203162532.24209-1-cavery@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: HUL4w6-mOSKNPFPUgCa3sw-1
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

v2: Added suggested changes to set_host_if etc.
---
 x86/svm.c | 105 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 103 insertions(+), 2 deletions(-)

diff --git a/x86/svm.c b/x86/svm.c
index 0360d8d..626179c 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -44,6 +44,8 @@ u64 runs;
 u8 *io_bitmap;
 u8 io_bitmap_area[16384];
=20
+u8 set_host_if;
+
 #define MSR_BITMAP_SIZE 8192
=20
 u8 *msr_bitmap;
@@ -258,6 +260,7 @@ static void test_run(struct test *test, struct vmcb *vm=
cb)
=20
     irq_disable();
     test->vmcb =3D vmcb;
+    set_host_if =3D 1;
     test->prepare(test);
     vmcb->save.rip =3D (ulong)test_thunk;
     vmcb->save.rsp =3D (ulong)(guest_stack + ARRAY_SIZE(guest_stack));
@@ -266,21 +269,24 @@ static void test_run(struct test *test, struct vmcb *=
vmcb)
         tsc_start =3D rdtsc();
         asm volatile (
             "clgi \n\t"
+            "cmpb $0, set_host_if\n\t"
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
@@ -1386,6 +1392,98 @@ static bool pending_event_check(struct test *test)
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
+    return get_test_stage(test) =3D=3D 2;
+}
+
 static struct test tests[] =3D {
     { "null", default_supported, default_prepare, null_test,
       default_finished, null_check },
@@ -1438,6 +1536,9 @@ static struct test tests[] =3D {
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

