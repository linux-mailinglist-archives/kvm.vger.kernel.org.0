Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2F66E080D
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 17:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388956AbfJVP4b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 11:56:31 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:57721 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388719AbfJVP4b (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Oct 2019 11:56:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571759788;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XjIyO9F5IlzneyrFrPIv+xnS5AsRqepMW6jaFv/bstM=;
        b=Al+yoEDhtv+HkDEqT5BTcJGtaJWIkgAMLr1P9x8wurcKscygBCqO77H7uh2S+LRfY+PKnW
        zNLD3sWwXbqUFIhwH9xRGkrCFLFYXaM2RLpXnmDkY7rz3Ir3clg6Tc2ErYAtNXDLpBOhiI
        AceaEwgws8iNk+YoAdk+N2VsTMCQs5Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-292-SvPwkpUyOe-Kjc3HnSCQgQ-1; Tue, 22 Oct 2019 11:56:27 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 83AB0476;
        Tue, 22 Oct 2019 15:56:26 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.43.2.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4DB555D6A9;
        Tue, 22 Oct 2019 15:56:23 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Roman Kagan <rkagan@virtuozzo.com>
Subject: [PATCH kvm-unit-tests 4/4] x86: hyperv_stimer: add direct mode tests
Date:   Tue, 22 Oct 2019 17:56:08 +0200
Message-Id: <20191022155608.8001-5-vkuznets@redhat.com>
In-Reply-To: <20191022155608.8001-1-vkuznets@redhat.com>
References: <20191022155608.8001-1-vkuznets@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: SvPwkpUyOe-Kjc3HnSCQgQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

All tests but stimer_test_one_shot_busy() are applicable, make them run in
both 'message' and 'direct' modes.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 x86/hyperv.h        |   7 +++
 x86/hyperv_stimer.c | 109 ++++++++++++++++++++++++++++++++++++++------
 x86/unittests.cfg   |   6 +++
 3 files changed, 108 insertions(+), 14 deletions(-)

diff --git a/x86/hyperv.h b/x86/hyperv.h
index 9a83da483467..718744c4d179 100644
--- a/x86/hyperv.h
+++ b/x86/hyperv.h
@@ -10,6 +10,8 @@
 #define HV_X64_MSR_SYNIC_AVAILABLE              (1 << 2)
 #define HV_X64_MSR_SYNTIMER_AVAILABLE           (1 << 3)
=20
+#define HV_STIMER_DIRECT_MODE_AVAILABLE=09=09(1 << 19)
+
 #define HV_X64_MSR_GUEST_OS_ID                  0x40000000
 #define HV_X64_MSR_HYPERCALL                    0x40000001
=20
@@ -205,6 +207,11 @@ static inline bool stimer_supported(void)
     return cpuid(HYPERV_CPUID_FEATURES).a & HV_X64_MSR_SYNIC_AVAILABLE;
 }
=20
+static inline bool stimer_direct_supported(void)
+{
+    return cpuid(HYPERV_CPUID_FEATURES).d & HV_STIMER_DIRECT_MODE_AVAILABL=
E;
+}
+
 static inline bool hv_time_ref_counter_supported(void)
 {
     return cpuid(HYPERV_CPUID_FEATURES).a & HV_X64_MSR_TIME_REF_COUNT_AVAI=
LABLE;
diff --git a/x86/hyperv_stimer.c b/x86/hyperv_stimer.c
index 6f72205d97c0..3e6a4a04d9df 100644
--- a/x86/hyperv_stimer.c
+++ b/x86/hyperv_stimer.c
@@ -16,6 +16,9 @@
 #define SINT1_VEC 0xF1
 #define SINT2_VEC 0xF2
=20
+#define APIC_VEC1 0xF3
+#define APIC_VEC2 0xF4
+
 #define SINT1_NUM 2
 #define SINT2_NUM 3
 #define ONE_MS_IN_100NS 10000
@@ -25,6 +28,8 @@ static struct spinlock g_synic_alloc_lock;
 struct stimer {
     int sint;
     int index;
+    bool direct;
+    int apic_vec;
     atomic_t fire_count;
 };
=20
@@ -81,8 +86,7 @@ static void stimer_shutdown(struct stimer *timer)
     wrmsr(HV_X64_MSR_STIMER0_CONFIG + 2*timer->index, 0);
 }
=20
-static void process_stimer_expired(struct svcpu *svcpu, struct stimer *tim=
er,
-                                   u64 expiration_time, u64 delivery_time)
+static void process_stimer_expired(struct stimer *timer)
 {
     atomic_inc(&timer->fire_count);
 }
@@ -119,8 +123,7 @@ static void process_stimer_msg(struct svcpu *svcpu,
         abort();
     }
     timer =3D &svcpu->timer[payload->timer_index];
-    process_stimer_expired(svcpu, timer, payload->expiration_time,
-                          payload->delivery_time);
+    process_stimer_expired(timer);
=20
     msg->header.message_type =3D HVMSG_NONE;
     mb();
@@ -159,6 +162,32 @@ static void stimer_isr_auto_eoi(isr_regs_t *regs)
     __stimer_isr(vcpu);
 }
=20
+static void __stimer_isr_direct(int vcpu, int timer_index)
+{
+    struct svcpu *svcpu =3D &g_synic_vcpu[vcpu];
+    struct stimer *timer =3D &svcpu->timer[timer_index];
+
+    process_stimer_expired(timer);
+}
+
+static void stimer_isr_direct1(isr_regs_t *regs)
+{
+    int vcpu =3D smp_id();
+
+    __stimer_isr_direct(vcpu, 0);
+
+    eoi();
+}
+
+static void stimer_isr_direct2(isr_regs_t *regs)
+{
+    int vcpu =3D smp_id();
+
+    __stimer_isr_direct(vcpu, 1);
+
+    eoi();
+}
+
 static void stimer_start(struct stimer *timer,
                          bool auto_enable, bool periodic,
                          u64 tick_100ns)
@@ -171,7 +200,12 @@ static void stimer_start(struct stimer *timer,
     config.periodic =3D periodic;
     config.enable =3D 1;
     config.auto_enable =3D auto_enable;
-    config.sintx =3D timer->sint;
+    if (!timer->direct) {
+        config.sintx =3D timer->sint;
+    } else {
+        config.direct_mode =3D 1;
+        config.apic_vector =3D timer->apic_vec;
+    }
=20
     if (periodic) {
         count =3D tick_100ns;
@@ -229,6 +263,28 @@ static void stimer_test_prepare(void *ctx)
     timer2->sint =3D SINT2_NUM;
 }
=20
+static void stimer_test_prepare_direct(void *ctx)
+{
+    int vcpu =3D smp_id();
+    struct svcpu *svcpu =3D &g_synic_vcpu[vcpu];
+    struct stimer *timer1, *timer2;
+
+    write_cr3((ulong)ctx);
+
+    timer1 =3D &svcpu->timer[0];
+    timer2 =3D &svcpu->timer[1];
+
+    stimer_init(timer1, 0);
+    stimer_init(timer2, 1);
+
+    timer1->apic_vec =3D APIC_VEC1;
+    timer2->apic_vec =3D APIC_VEC2;
+
+    timer1->direct =3D true;
+    timer2->direct =3D true;
+}
+
+
 static void stimer_test_periodic(int vcpu, struct stimer *timer1,
                                  struct stimer *timer2)
 {
@@ -279,8 +335,15 @@ static void stimer_test_auto_enable_periodic(int vcpu,=
 struct stimer *timer)
=20
 static void stimer_test_one_shot_busy(int vcpu, struct stimer *timer)
 {
-    struct hv_message_page *msg_page =3D g_synic_vcpu[vcpu].msg_page;
-    struct hv_message *msg =3D &msg_page->sint_message[timer->sint];
+    struct hv_message_page *msg_page;
+    struct hv_message *msg;
+
+    /* Skipping msg slot busy test in direct mode */
+    if (timer->direct)
+        return;
+
+    msg_page =3D g_synic_vcpu[vcpu].msg_page;
+    msg =3D &msg_page->sint_message[timer->sint];
=20
     msg->header.message_type =3D HVMSG_TIMER_EXPIRED;
     wmb();
@@ -334,7 +397,12 @@ static void stimer_test_cleanup(void *ctx)
     synic_disable();
 }
=20
-static void stimer_test_all(void)
+static void stimer_test_cleanup_direct(void *ctx)
+{
+    stimers_shutdown();
+}
+
+static void stimer_test_all(bool direct)
 {
     int ncpus;
=20
@@ -347,12 +415,25 @@ static void stimer_test_all(void)
         report_abort("number cpus exceeds %d", MAX_CPUS);
     printf("cpus =3D %d\n", ncpus);
=20
-    handle_irq(SINT1_VEC, stimer_isr);
-    handle_irq(SINT2_VEC, stimer_isr_auto_eoi);
+    if (!direct) {
+        printf("Starting Hyper-V SynIC timers tests: message mode\n");
+
+        handle_irq(SINT1_VEC, stimer_isr);
+        handle_irq(SINT2_VEC, stimer_isr_auto_eoi);
+
+=09on_cpus(stimer_test_prepare, (void *)read_cr3());
+=09on_cpus(stimer_test, NULL);
+=09on_cpus(stimer_test_cleanup, NULL);
+    } else {
+        printf("Starting Hyper-V SynIC timers tests: direct mode\n");
+
+        handle_irq(APIC_VEC1, stimer_isr_direct1);
+        handle_irq(APIC_VEC2, stimer_isr_direct2);
=20
-    on_cpus(stimer_test_prepare, (void *)read_cr3());
-    on_cpus(stimer_test, NULL);
-    on_cpus(stimer_test_cleanup, NULL);
+        on_cpus(stimer_test_prepare_direct, (void *)read_cr3());
+        on_cpus(stimer_test, NULL);
+        on_cpus(stimer_test_cleanup_direct, NULL);
+    }
 }
=20
 int main(int ac, char **av)
@@ -373,7 +454,7 @@ int main(int ac, char **av)
         goto done;
     }
=20
-    stimer_test_all();
+    stimer_test_all(stimer_direct_supported());
 done:
     return report_summary();
 }
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 5c0c55a0f405..933fed1c2038 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -306,6 +306,12 @@ smp =3D 2
 extra_params =3D -cpu kvm64,hv_vpindex,hv_time,hv_synic,hv_stimer
 groups =3D hyperv
=20
+[hyperv_stimer_direct]
+file =3D hyperv_stimer.flat
+smp =3D 2
+extra_params =3D -cpu kvm64,hv_vpindex,hv_time,hv_synic,hv_stimer,hv_stime=
r_direct
+groups =3D hyperv
+
 [hyperv_clock]
 file =3D hyperv_clock.flat
 smp =3D 2
--=20
2.20.1

