Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5427674BA6
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 06:03:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbjATFD5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 00:03:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230311AbjATFDU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 00:03:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC86DBFF47
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 20:49:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674190132;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=+LRagk6PL+VCh4WXT1/1N+QScv/LuUh/E9vGhjKrpng=;
        b=imgo1Tk/utZyoviw5sCIEiIYdBknugYCw3ugRMwLYdAi+ed72hZcMWRtvXCBaPrlODdp5X
        QbfdMm01M8krErvB5rXGqg2E3ci2ZeX2/ewdFd9Ex9XKBZ8bPfR11PEy0v6b+sNQgARo0a
        Cizl3lKeem4m/m8J3hWKnsZNHFeyf1o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-346-Pxq9fQkDMlqlGtbUtn9NVA-1; Thu, 19 Jan 2023 23:48:50 -0500
X-MC-Unique: Pxq9fQkDMlqlGtbUtn9NVA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 407E485CBE1;
        Fri, 20 Jan 2023 04:48:50 +0000 (UTC)
Received: from tpad.localdomain (ovpn-112-2.gru2.redhat.com [10.97.112.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E2C711121315;
        Fri, 20 Jan 2023 04:48:49 +0000 (UTC)
Received: by tpad.localdomain (Postfix, from userid 1000)
        id 0A2DE4099C363; Thu, 19 Jan 2023 22:15:17 -0300 (-03)
Message-ID: <20230120011412.558538345@redhat.com>
User-Agent: quilt/0.67
Date:   Thu, 19 Jan 2023 22:11:18 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 2/2] hw/i386/kvm/clock.c: read kvmclock from guest memory if !correct_tsc_shift
References: <20230120011116.134437211@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Before kernel commit 78db6a5037965429c04d708281f35a6e5562d31b,
kvm_guest_time_update() would use vcpu->virtual_tsc_khz to calculate
tsc_shift value in the vcpus pvclock structure written to guest memory.

For those kernels, if vcpu->virtual_tsc_khz != tsc_khz (which can be the
case when guest state is restored via migration, or if tsc-khz option is
passed to QEMU), and TSC scaling is not enabled (which happens if the
difference between the frequency requested via KVM_SET_TSC_KHZ and the
host TSC KHZ is smaller than 250ppm), then there can be a difference
between what KVM_GET_CLOCK would return and what the guest reads as
kvmclock value.

The effect is that the guest sees a jump in kvmclock value
(either forwards or backwards) in such case.

To fix incoming migration from pre-78db6a5037965 hosts, 
read kvmclock value from guest memory.

Unless the KVM_CLOCK_CORRECT_TSC_SHIFT bit indicates
that the value retrieved by KVM_GET_CLOCK on the source
is safe to be used.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

Index: qemu/hw/i386/kvm/clock.c
===================================================================
--- qemu.orig/hw/i386/kvm/clock.c
+++ qemu/hw/i386/kvm/clock.c
@@ -50,6 +50,16 @@ struct KVMClockState {
     /* whether the 'clock' value was obtained in a host with
      * reliable KVM_GET_CLOCK */
     bool clock_is_reliable;
+
+    /* whether machine type supports correct_tsc_shift */
+    bool mach_use_correct_tsc_shift;
+
+    /*
+     * whether the 'clock' value was obtained in a host
+     * that computes correct tsc_shift field (the one
+     * written to guest memory)
+     */
+    bool clock_correct_tsc_shift;
 };
 
 struct pvclock_vcpu_time_info {
@@ -150,6 +160,8 @@ static void kvm_update_clock(KVMClockSta
      *               read from memory
      */
     s->clock_is_reliable = kvm_has_adjust_clock_stable();
+
+    s->clock_correct_tsc_shift = kvm_has_correct_tsc_shift();
 }
 
 static void do_kvmclock_ctrl(CPUState *cpu, run_on_cpu_data data)
@@ -176,7 +188,7 @@ static void kvmclock_vm_state_change(voi
          * If the host where s->clock was read did not support reliable
          * KVM_GET_CLOCK, read kvmclock value from memory.
          */
-        if (!s->clock_is_reliable) {
+        if (!s->clock_is_reliable || !s->clock_correct_tsc_shift) {
             uint64_t pvclock_via_mem = kvmclock_current_nsec(s);
             /* We can't rely on the saved clock value, just discard it */
             if (pvclock_via_mem) {
@@ -252,14 +264,40 @@ static const VMStateDescription kvmclock
 };
 
 /*
+ * Sending clock_correct_tsc_shift=true means that the destination
+ * can use VMSTATE_UINT64(clock, KVMClockState) value,
+ * instead of reading from guest memory.
+ */
+static bool kvmclock_clock_correct_tsc_shift_needed(void *opaque)
+{
+    KVMClockState *s = opaque;
+
+    return s->mach_use_correct_tsc_shift;
+}
+
+static const VMStateDescription kvmclock_correct_tsc_shift = {
+    .name = "kvmclock/clock_correct_tsc_shift",
+    .version_id = 1,
+    .minimum_version_id = 1,
+    .needed = kvmclock_clock_correct_tsc_shift_needed,
+    .fields = (VMStateField[]) {
+        VMSTATE_BOOL(clock_correct_tsc_shift, KVMClockState),
+        VMSTATE_END_OF_LIST()
+    }
+};
+
+/*
  * When migrating, assume the source has an unreliable
- * KVM_GET_CLOCK unless told otherwise.
+ * KVM_GET_CLOCK (and computes tsc shift
+ * in guest memory using vcpu->virtual_tsc_khz),
+ * unless told otherwise.
  */
 static int kvmclock_pre_load(void *opaque)
 {
     KVMClockState *s = opaque;
 
     s->clock_is_reliable = false;
+    s->clock_correct_tsc_shift = false;
 
     return 0;
 }
@@ -301,6 +339,7 @@ static const VMStateDescription kvmclock
     },
     .subsections = (const VMStateDescription * []) {
         &kvmclock_reliable_get_clock,
+        &kvmclock_correct_tsc_shift,
         NULL
     }
 };
@@ -308,6 +347,8 @@ static const VMStateDescription kvmclock
 static Property kvmclock_properties[] = {
     DEFINE_PROP_BOOL("x-mach-use-reliable-get-clock", KVMClockState,
                       mach_use_reliable_get_clock, true),
+    DEFINE_PROP_BOOL("x-mach-use-correct-tsc-shift", KVMClockState,
+                      mach_use_correct_tsc_shift, true),
     DEFINE_PROP_END_OF_LIST(),
 };
 
Index: qemu/target/i386/kvm/kvm.c
===================================================================
--- qemu.orig/target/i386/kvm/kvm.c
+++ qemu/target/i386/kvm/kvm.c
@@ -164,6 +164,13 @@ bool kvm_has_adjust_clock_stable(void)
     return (ret & KVM_CLOCK_TSC_STABLE);
 }
 
+bool kvm_has_correct_tsc_shift(void)
+{
+    int ret = kvm_check_extension(kvm_state, KVM_CAP_ADJUST_CLOCK);
+
+    return ret & KVM_CLOCK_CORRECT_TSC_SHIFT;
+}
+
 bool kvm_has_adjust_clock(void)
 {
     return kvm_check_extension(kvm_state, KVM_CAP_ADJUST_CLOCK);
Index: qemu/target/i386/kvm/kvm_i386.h
===================================================================
--- qemu.orig/target/i386/kvm/kvm_i386.h
+++ qemu/target/i386/kvm/kvm_i386.h
@@ -35,6 +35,7 @@
 bool kvm_has_smm(void);
 bool kvm_has_adjust_clock(void);
 bool kvm_has_adjust_clock_stable(void);
+bool kvm_has_correct_tsc_shift(void);
 bool kvm_has_exception_payload(void);
 void kvm_synchronize_all_tsc(void);
 void kvm_arch_reset_vcpu(X86CPU *cs);


