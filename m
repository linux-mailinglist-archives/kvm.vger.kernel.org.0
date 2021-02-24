Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E30A6324249
	for <lists+kvm@lfdr.de>; Wed, 24 Feb 2021 17:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234768AbhBXQjq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 11:39:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22270 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234487AbhBXQhZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 24 Feb 2021 11:37:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614184558;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/cykzK4/txSh+VMc+LR/WwUPtiOJKuKhe+NHf4sQ6mk=;
        b=DcGv4EcN8v21478WHcmGqeaiGc/AD1Qf8XTR0c8QSGKbf3Wiq5cC7ac0Lg+i18PUr2g2+R
        UKJ2Vz1/zUGNLCqQBtUDoTu4D7cjQ2V8hVuGyTfBF2oR0q2vxuKUMo7eo/f2obPJGvjNQR
        rZVEnXyGqop3CDRAGtopnFkF+DJ9SO8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-87-dwAwwuxwPcmtwv_gL3sQ2A-1; Wed, 24 Feb 2021 11:35:56 -0500
X-MC-Unique: dwAwwuxwPcmtwv_gL3sQ2A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 79EF2195D561
        for <kvm@vger.kernel.org>; Wed, 24 Feb 2021 16:35:55 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.221])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7015E19C46;
        Wed, 24 Feb 2021 16:35:54 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH kvm-unit-tests v2 4/4] x86: hyperv_stimer: add direct mode tests
Date:   Wed, 24 Feb 2021 17:35:47 +0100
Message-Id: <20210224163547.197100-5-vkuznets@redhat.com>
In-Reply-To: <20210224163547.197100-1-vkuznets@redhat.com>
References: <20210224163547.197100-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

All tests but stimer_test_one_shot_busy() are applicable, make them run in
both 'message' and 'direct' modes.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 x86/hyperv.h        |   7 +++
 x86/hyperv_stimer.c | 116 ++++++++++++++++++++++++++++++++++++++------
 x86/unittests.cfg   |   6 +++
 3 files changed, 115 insertions(+), 14 deletions(-)

diff --git a/x86/hyperv.h b/x86/hyperv.h
index 9a83da483467..718744c4d179 100644
--- a/x86/hyperv.h
+++ b/x86/hyperv.h
@@ -10,6 +10,8 @@
 #define HV_X64_MSR_SYNIC_AVAILABLE              (1 << 2)
 #define HV_X64_MSR_SYNTIMER_AVAILABLE           (1 << 3)
 
+#define HV_STIMER_DIRECT_MODE_AVAILABLE		(1 << 19)
+
 #define HV_X64_MSR_GUEST_OS_ID                  0x40000000
 #define HV_X64_MSR_HYPERCALL                    0x40000001
 
@@ -205,6 +207,11 @@ static inline bool stimer_supported(void)
     return cpuid(HYPERV_CPUID_FEATURES).a & HV_X64_MSR_SYNIC_AVAILABLE;
 }
 
+static inline bool stimer_direct_supported(void)
+{
+    return cpuid(HYPERV_CPUID_FEATURES).d & HV_STIMER_DIRECT_MODE_AVAILABLE;
+}
+
 static inline bool hv_time_ref_counter_supported(void)
 {
     return cpuid(HYPERV_CPUID_FEATURES).a & HV_X64_MSR_TIME_REF_COUNT_AVAILABLE;
diff --git a/x86/hyperv_stimer.c b/x86/hyperv_stimer.c
index 1e4eff270406..231a1e3bc06e 100644
--- a/x86/hyperv_stimer.c
+++ b/x86/hyperv_stimer.c
@@ -16,6 +16,9 @@
 #define SINT1_VEC 0xF1
 #define SINT2_VEC 0xF2
 
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
 
@@ -81,8 +86,7 @@ static void stimer_shutdown(struct stimer *timer)
     wrmsr(HV_X64_MSR_STIMER0_CONFIG + 2*timer->index, 0);
 }
 
-static void process_stimer_expired(struct svcpu *svcpu, struct stimer *timer,
-                                   u64 expiration_time, u64 delivery_time)
+static void process_stimer_expired(struct stimer *timer)
 {
     atomic_inc(&timer->fire_count);
 }
@@ -119,8 +123,14 @@ static void process_stimer_msg(struct svcpu *svcpu,
         abort();
     }
     timer = &svcpu->timer[payload->timer_index];
-    process_stimer_expired(svcpu, timer, payload->expiration_time,
-                          payload->delivery_time);
+
+    if (timer->direct) {
+        report(false, "VMBus message in direct mode received");
+        report_summary();
+        abort();
+    }
+
+    process_stimer_expired(timer);
 
     msg->header.message_type = HVMSG_NONE;
     mb();
@@ -159,6 +169,32 @@ static void stimer_isr_auto_eoi(isr_regs_t *regs)
     __stimer_isr(vcpu);
 }
 
+static void __stimer_isr_direct(int vcpu, int timer_index)
+{
+    struct svcpu *svcpu = &g_synic_vcpu[vcpu];
+    struct stimer *timer = &svcpu->timer[timer_index];
+
+    process_stimer_expired(timer);
+}
+
+static void stimer_isr_direct1(isr_regs_t *regs)
+{
+    int vcpu = smp_id();
+
+    __stimer_isr_direct(vcpu, 0);
+
+    eoi();
+}
+
+static void stimer_isr_direct2(isr_regs_t *regs)
+{
+    int vcpu = smp_id();
+
+    __stimer_isr_direct(vcpu, 1);
+
+    eoi();
+}
+
 static void stimer_start(struct stimer *timer,
                          bool auto_enable, bool periodic,
                          u64 tick_100ns)
@@ -171,7 +207,12 @@ static void stimer_start(struct stimer *timer,
     config.periodic = periodic;
     config.enable = 1;
     config.auto_enable = auto_enable;
-    config.sintx = timer->sint;
+    if (!timer->direct) {
+        config.sintx = timer->sint;
+    } else {
+        config.direct_mode = 1;
+        config.apic_vector = timer->apic_vec;
+    }
 
     if (periodic) {
         count = tick_100ns;
@@ -229,6 +270,28 @@ static void stimer_test_prepare(void *ctx)
     timer2->sint = SINT2_NUM;
 }
 
+static void stimer_test_prepare_direct(void *ctx)
+{
+    int vcpu = smp_id();
+    struct svcpu *svcpu = &g_synic_vcpu[vcpu];
+    struct stimer *timer1, *timer2;
+
+    write_cr3((ulong)ctx);
+
+    timer1 = &svcpu->timer[0];
+    timer2 = &svcpu->timer[1];
+
+    stimer_init(timer1, 0);
+    stimer_init(timer2, 1);
+
+    timer1->apic_vec = APIC_VEC1;
+    timer2->apic_vec = APIC_VEC2;
+
+    timer1->direct = true;
+    timer2->direct = true;
+}
+
+
 static void stimer_test_periodic(int vcpu, struct stimer *timer1,
                                  struct stimer *timer2)
 {
@@ -281,8 +344,15 @@ static void stimer_test_auto_enable_periodic(int vcpu, struct stimer *timer)
 
 static void stimer_test_one_shot_busy(int vcpu, struct stimer *timer)
 {
-    struct hv_message_page *msg_page = g_synic_vcpu[vcpu].msg_page;
-    struct hv_message *msg = &msg_page->sint_message[timer->sint];
+    struct hv_message_page *msg_page;
+    struct hv_message *msg;
+
+    /* Skipping msg slot busy test in direct mode */
+    if (timer->direct)
+        return;
+
+    msg_page = g_synic_vcpu[vcpu].msg_page;
+    msg = &msg_page->sint_message[timer->sint];
 
     msg->header.message_type = HVMSG_TIMER_EXPIRED;
     wmb();
@@ -336,7 +406,12 @@ static void stimer_test_cleanup(void *ctx)
     synic_disable();
 }
 
-static void stimer_test_all(void)
+static void stimer_test_cleanup_direct(void *ctx)
+{
+    stimers_shutdown();
+}
+
+static void stimer_test_all(bool direct)
 {
     int ncpus;
 
@@ -348,12 +423,25 @@ static void stimer_test_all(void)
         report_abort("number cpus exceeds %d", MAX_CPUS);
     printf("cpus = %d\n", ncpus);
 
-    handle_irq(SINT1_VEC, stimer_isr);
-    handle_irq(SINT2_VEC, stimer_isr_auto_eoi);
+    if (!direct) {
+        printf("Starting Hyper-V SynIC timers tests: message mode\n");
 
-    on_cpus(stimer_test_prepare, (void *)read_cr3());
-    on_cpus(stimer_test, NULL);
-    on_cpus(stimer_test_cleanup, NULL);
+        handle_irq(SINT1_VEC, stimer_isr);
+        handle_irq(SINT2_VEC, stimer_isr_auto_eoi);
+
+	on_cpus(stimer_test_prepare, (void *)read_cr3());
+	on_cpus(stimer_test, NULL);
+	on_cpus(stimer_test_cleanup, NULL);
+    } else {
+        printf("Starting Hyper-V SynIC timers tests: direct mode\n");
+
+        handle_irq(APIC_VEC1, stimer_isr_direct1);
+        handle_irq(APIC_VEC2, stimer_isr_direct2);
+
+        on_cpus(stimer_test_prepare_direct, (void *)read_cr3());
+        on_cpus(stimer_test, NULL);
+        on_cpus(stimer_test_cleanup_direct, NULL);
+    }
 }
 
 int main(int ac, char **av)
@@ -374,7 +462,7 @@ int main(int ac, char **av)
         goto done;
     }
 
-    stimer_test_all();
+    stimer_test_all(stimer_direct_supported());
 done:
     return report_summary();
 }
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 176f9e80b013..ad9afcec92ab 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -364,6 +364,12 @@ smp = 2
 extra_params = -cpu kvm64,hv_vpindex,hv_time,hv_synic,hv_stimer
 groups = hyperv
 
+[hyperv_stimer_direct]
+file = hyperv_stimer.flat
+smp = 2
+extra_params = -cpu kvm64,hv_vpindex,hv_time,hv_synic,hv_stimer,hv_stimer_direct
+groups = hyperv
+
 [hyperv_clock]
 file = hyperv_clock.flat
 smp = 2
-- 
2.29.2

