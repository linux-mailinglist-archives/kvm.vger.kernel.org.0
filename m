Return-Path: <kvm+bounces-11183-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3166A873D54
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 18:19:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 552151C22808
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 17:19:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A05613E7F4;
	Wed,  6 Mar 2024 17:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bT6C0rNL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B340B13BAF9
	for <kvm@vger.kernel.org>; Wed,  6 Mar 2024 17:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709745522; cv=none; b=EpOFGsrdpw3JtuEWbpBwFew4l18d2NtS5+nsUAMpeX5oe72pu0fSQSf5Yvek9UhnBiX4YUw6u1vJQoui8FHXFD8Td1PafQP8DAtodPotR5b0oQnpKtcSVIz4oP4tnHOOe7pYHC8lNqhVUEh//RMwWPxC6wJeirDP77DTUSkTXRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709745522; c=relaxed/simple;
	bh=0gVozzpTzqNYrDTCsEX2bFk7WIjYzA4nK1eFhSe/Xz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EC8WeWO3dmmqXMO8D2dgyWT4vjEPS3UX0iPVwPKeyQpdqQOffm++LcROmGQJuknazViMhr3DW9hAYXGW+ffSV1oFl0NH3t9iRM7tWJn6TcAoNAuPmnavIyUKzX6UmZt6oLv9zgg7Nh5NcXHNBFKC9iJACt5iftclseQaHT1nYv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bT6C0rNL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709745519;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UWVS9geXgWwEfVf83LC8EmlPXIz0AXJ0B6+JVEuSQP8=;
	b=bT6C0rNL0LnN5KwA0Vt1Thgd5p2x0On6JdAZfL+w5QARAkVcoL2G+rw/cR06nU+hb5pp3d
	sivbHGwvRa0+IK1gB06Hjj0H1/mWXWn6BGo30QZ1zLliDQnygkagQfywwgiZVZAH2f7ZHQ
	NaOwjqvBZlau62xzAnR+9E7ITNrrdWc=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-65-7U0QBM3UMi2mEU3YGwpw3g-1; Wed,
 06 Mar 2024 12:18:36 -0500
X-MC-Unique: 7U0QBM3UMi2mEU3YGwpw3g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5668D1C38290;
	Wed,  6 Mar 2024 17:18:36 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.226.41])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9FF4E40C6CB8;
	Wed,  6 Mar 2024 17:18:35 +0000 (UTC)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: Metin Kaya <metikaya@amazon.com>
Subject: [PATCH kvm-unit-tests 12/13] x86: hyperv_stimer: add direct mode tests
Date: Wed,  6 Mar 2024 18:18:22 +0100
Message-ID: <20240306171823.761647-13-vkuznets@redhat.com>
In-Reply-To: <20240306171823.761647-1-vkuznets@redhat.com>
References: <20240306171823.761647-1-vkuznets@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

All tests but stimer_test_one_shot_busy() are applicable, make them run in
both 'message' and 'direct' modes.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 x86/hyperv.h        |   7 +++
 x86/hyperv_stimer.c | 123 ++++++++++++++++++++++++++++++++++++++------
 x86/unittests.cfg   |   6 +++
 3 files changed, 121 insertions(+), 15 deletions(-)

diff --git a/x86/hyperv.h b/x86/hyperv.h
index 2fc70e561ef2..a1443842ed0b 100644
--- a/x86/hyperv.h
+++ b/x86/hyperv.h
@@ -10,6 +10,8 @@
 #define HV_X64_MSR_SYNIC_AVAILABLE              (1 << 2)
 #define HV_X64_MSR_SYNTIMER_AVAILABLE           (1 << 3)
 
+#define HV_STIMER_DIRECT_MODE_AVAILABLE		(1 << 19)
+
 #define HV_X64_MSR_GUEST_OS_ID                  0x40000000
 #define HV_X64_MSR_HYPERCALL                    0x40000001
 
@@ -205,6 +207,11 @@ static inline bool hv_stimer_supported(void)
     return cpuid(HYPERV_CPUID_FEATURES).a & HV_X64_MSR_SYNTIMER_AVAILABLE;
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
index 0b9ec7a5b1b4..e50903b24820 100644
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
@@ -279,8 +342,15 @@ static void stimer_test_auto_enable_periodic(int vcpu, struct stimer *timer)
 
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
@@ -334,7 +404,12 @@ static void stimer_test_cleanup(void *ctx)
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
 
@@ -346,16 +421,30 @@ static void stimer_test_all(void)
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
 
-int main(int ac, char **av)
+int main(int argc, char **argv)
 {
+    bool direct = argc >= 2 && !strcmp(argv[1], "direct");
 
     if (!hv_synic_supported()) {
         report_skip("Hyper-V SynIC is not supported");
@@ -372,7 +461,11 @@ int main(int ac, char **av)
         goto done;
     }
 
-    stimer_test_all();
+    if (direct && !stimer_direct_supported()) {
+	report_skip("Hyper-V SinIC timer direct mode is not supported");
+    }
+
+    stimer_test_all(direct);
 done:
     return report_summary();
 }
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 06164ae22aa7..124be7a1f208 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -466,6 +466,12 @@ smp = 2
 extra_params = -cpu host,hv_passthrough
 groups = hyperv
 
+[hyperv_stimer_direct]
+file = hyperv_stimer.flat
+smp = 2
+extra_params = -cpu host,hv_passthrough -append direct
+groups = hyperv
+
 [hyperv_clock]
 file = hyperv_clock.flat
 smp = 2
-- 
2.44.0


