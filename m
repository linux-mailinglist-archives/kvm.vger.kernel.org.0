Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9508E1F9618
	for <lists+kvm@lfdr.de>; Mon, 15 Jun 2020 14:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729733AbgFOMK2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jun 2020 08:10:28 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:24027 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729630AbgFOMK2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Jun 2020 08:10:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592223026;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=dEcd7Ou8Wc2IM9OEpa2krlue9KWBHBJ5MmJhN3pvDxo=;
        b=YuMC37mek9wHDTiwqXe4u03LUWfyTT3sGB4GmU33hmkSmTzxuvVa7rs5lMFspSc/+8zTAc
        ZFK8gacO2YsveDS49HkbI2qSDlaarp/Hqz4Enz0M3Edc/FKKkxTfJzj+D6nGDkV5afWNzo
        9hbyABH0wM7M9ba9qCoLtAdwJ5elcDw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-196-reJFroX6NsCuo-629NVw0Q-1; Mon, 15 Jun 2020 08:10:24 -0400
X-MC-Unique: reJFroX6NsCuo-629NVw0Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DCEE68C23B8;
        Mon, 15 Jun 2020 12:09:52 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-3.gru2.redhat.com [10.97.112.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5F61C80883;
        Mon, 15 Jun 2020 12:09:52 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id 31640430716A; Mon, 15 Jun 2020 09:01:27 -0300 (-03)
Date:   Mon, 15 Jun 2020 09:01:27 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     qemu-devel <qemu-devel@nongnu.org>, kvm-devel <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH] kvm: i386: allow TSC to differ by NTP correction bounds
 without TSC scaling
Message-ID: <20200615120127.GB224592@fuller.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


The Linux TSC calibration procedure is subject to small variations
(its common to see +-1 kHz difference between reboots on a given CPU, for example).

So migrating a guest between two hosts with identical processor can fail, in case 
of a small variation in calibrated TSC between them.

Allow a conservative 250ppm error between host TSC and VM TSC frequencies,
rather than requiring an exact match. NTP daemon in the guest can
correct this difference.

Also change migration to accept this bound.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index 34f8387..257fee4 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -739,23 +739,44 @@ static int kvm_arch_set_tsc_khz(CPUState *cs)
 {
     X86CPU *cpu = X86_CPU(cs);
     CPUX86State *env = &cpu->env;
-    int r;
+    int r, cur_freq;
+    bool set_ioctl = false;
 
     if (!env->tsc_khz) {
         return 0;
     }
 
-    r = kvm_check_extension(cs->kvm_state, KVM_CAP_TSC_CONTROL) ?
+    cur_freq = kvm_check_extension(cs->kvm_state, KVM_CAP_GET_TSC_KHZ) ?
+               kvm_vcpu_ioctl(cs, KVM_GET_TSC_KHZ) : -ENOTSUP;
+
+    /*
+     * If TSC scaling is supported, attempt to set TSC frequency.
+     */
+    if (kvm_check_extension(cs->kvm_state, KVM_CAP_TSC_CONTROL)) {
+        set_ioctl = true;
+    }
+
+    /*
+     * If desired TSC frequency is within bounds of NTP correction,
+     * attempt to set TSC frequency.
+     */
+    if (cur_freq != -ENOTSUP && freq_within_bounds(cur_freq, env->tsc_khz)) {
+        set_ioctl = true;
+    }
+
+    r = set_ioctl ?
         kvm_vcpu_ioctl(cs, KVM_SET_TSC_KHZ, env->tsc_khz) :
         -ENOTSUP;
+
     if (r < 0) {
         /* When KVM_SET_TSC_KHZ fails, it's an error only if the current
          * TSC frequency doesn't match the one we want.
          */
-        int cur_freq = kvm_check_extension(cs->kvm_state, KVM_CAP_GET_TSC_KHZ) ?
-                       kvm_vcpu_ioctl(cs, KVM_GET_TSC_KHZ) :
-                       -ENOTSUP;
-        if (cur_freq <= 0 || cur_freq != env->tsc_khz) {
+        cur_freq = kvm_check_extension(cs->kvm_state, KVM_CAP_GET_TSC_KHZ) ?
+                   kvm_vcpu_ioctl(cs, KVM_GET_TSC_KHZ) :
+                   -ENOTSUP;
+        if (cur_freq <= 0 || (cur_freq != env->tsc_khz &&
+                              !freq_within_bounds(cur_freq, env->tsc_khz))) {
             warn_report("TSC frequency mismatch between "
                         "VM (%" PRId64 " kHz) and host (%d kHz), "
                         "and TSC scaling unavailable",
diff --git a/target/i386/kvm_i386.h b/target/i386/kvm_i386.h
index 00bde7a..ebf9a64 100644
--- a/target/i386/kvm_i386.h
+++ b/target/i386/kvm_i386.h
@@ -47,4 +47,20 @@ bool kvm_has_x2apic_api(void);
 
 bool kvm_hv_vpindex_settable(void);
 
+/*
+ * Check whether target_freq is within conservative
+ * ntp correctable bounds (250ppm) of freq
+ */
+static inline bool freq_within_bounds(int freq, int target_freq)
+{
+        int max_freq = freq + (freq * 250 / 1000000);
+        int min_freq = freq - (freq * 250 / 1000000);
+
+        if (target_freq >= min_freq && target_freq <= max_freq) {
+                return true;
+        }
+
+        return false;
+}
+
 #endif
diff --git a/target/i386/machine.c b/target/i386/machine.c
index 0c96531..b052654 100644
--- a/target/i386/machine.c
+++ b/target/i386/machine.c
@@ -300,7 +300,7 @@ static int cpu_post_load(void *opaque, int version_id)
     int i;
 
     if (env->tsc_khz && env->user_tsc_khz &&
-        env->tsc_khz != env->user_tsc_khz) {
+        !freq_within_bounds(env->tsc_khz, env->user_tsc_khz)) {
         error_report("Mismatch between user-specified TSC frequency and "
                      "migrated TSC frequency");
         return -EINVAL;

